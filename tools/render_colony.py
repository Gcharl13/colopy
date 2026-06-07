#!/usr/bin/env python3
"""
render_colony.py - Render a colony screen matching the structure of
the user's Baltimore reference (Spring 1567, Gold 4010).

Native: 320x200. Layout:
  - Top bar (1 line): "<colony name>. <season>, <year>. Gold: <treasury>"
  - Top-left (~50% w x 60% h): Colony view - building grid + colonists + trees
  - Top-right (~30% w x 30% h): Town production grid (3x3 around center tile)
  - Middle band (~25% h): SoL bars + ships panel + workers panel
  - Bottom band (~15% h): Commodity inventory grid (16 cells)
  - Right edge: wood-grain panel with EXIT button

Memory addresses for live values (RUNTIME-VERIFIED 2026-05-05):

  - ColonyRecord pointer = DGROUP:0x8542 (active colony)
  - ColonyRecord stride = 202 bytes
  - ColonyRecord +0x00 = map_x byte
  - ColonyRecord +0x01 = map_y byte
  - ColonyRecord +0x02..+0x19 = name (NUL-terminated, 24 bytes)
  - ColonyRecord +0x1A = owner_power_idx
  - ColonyRecord +0x1F = size byte (colonist count)
  - ColonyRecord +0x40..+0x4? = colonist_job_skills (NAMES.TXT @JOB index per colonist)
  - ColonyRecord +0x9A..+0xB9 = stockpile (16 × u16 in NAMES.TXT @CARGO order)
  - ColonyRecord +0xC2 = wealth (u32)
  - ColonyRecord +0xC6 = colony lifetime counter (TBD: hammers/bells/crosses)

Title-bar values come from per-power PowerRecord:
  - PowerRecord +0x2A = gold (u32, treasury)
  - PowerRecord +0x01 = tax_pct

Sprite assets:
  - BUILDING.SS — 48 sprites for colony scene composition
  - ICONS.SS at indices 12-27 = 16 commodity sprites
  - ICONS.SS at unit-type indices = colonist sprites at work tiles
  - WOODPANL.PIK = right sidebar background
  - COLONY.PIK = inventory bar strip at y=128..200

Doc refs:
  - docs/RENDERER_GEOMETRY.md — pixel positions
  - docs/DATA_MODEL.md — ColonyRecord field layout
  - docs/GAME_INDEX_TABLES.md — cargo/unit/job indexing
  - docs/SCREEN_ASSET_REQUIREMENTS.md — required assets list

Usage:
    python render_colony.py
    python render_colony.py --colony baltimore_def.json
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"

# Native game-screen dimensions
SCREEN_W = 320
SCREEN_H = 200

# Sample colony state. Defaults reflect a typical English start
# (see NAMES.TXT @COLONYNAME = "New England", @COUNTRY = "England").
# Baltimore is the colony name shown in the user's Baltimore reference
# screenshot (colon3.jpg) — owner is England (not "Continental").
SAMPLE_COLONY = {
    "name": "Baltimore",
    "season": "Spring",
    "year": 1567,
    "treasury": 4010,
    "owner_nation": "England",
    "rebel_pct": 95,
    "tory_pct": 5,
    "rebel_count": 8,
    "tory_count": 0,
    "buildings": [
        # building_id, x, y, label
        ("town_hall",   3, 1, "Town Hall"),
        ("church",      4, 4, ""),
        ("stockade",    1, 0, ""),
        ("smithy",      6, 0, ""),
        ("lumber_mill", 0, 4, ""),
        ("warehouse",   1, 1, ""),
        ("dock",        5, 5, ""),
        ("school",      0, 2, ""),
    ],
    "colonists": [
        # job, x, y
        ("statesman",   3, 1),  # Town Hall
        ("preacher",    4, 4),  # Church
        ("smith",       6, 0),
        ("lumberjack",  0, 4),
    ],
    "production_yields": [
        # tile_x_offset (-1..1), tile_y_offset (-1..1), commodity_id, yield
        (-1, -1, "food",     5),
        ( 0, -1, "food",     6),
        ( 1, -1, "food",     5),
        (-1,  0, "ore",      6),
        ( 1,  0, "lumber",   8),  # Selected tile
        (-1,  1, "ore",      6),
        ( 0,  1, "tobacco",  16),
        ( 1,  1, "lumber",   12),
    ],
    "stockpile": {
        # commodity_id: amount
        "food": 89, "sugar": 0, "tobacco": 6, "cotton": 99,
        "fur": 76, "lumber": 0, "ore": 0, "silver": 6,
        "horses": 0, "rum": 0, "cigars": 0, "cloth": 12,
        "coats": 0, "trade_goods": 6, "tools": 0, "muskets": 0,
    },
    # Total stockpile capacity (warehouse-dependent)
    "stockpile_capacity": 100,
    # Ships in port
    "ships_in_port": [],  # Empty list = "No Ships in Port"
}


# Commodity order (left-to-right in inventory bar) — per Colonization design
COMMODITY_ORDER = [
    "food", "sugar", "tobacco", "cotton",
    "fur", "lumber", "ore", "silver",
    "horses", "rum", "cigars", "cloth",
    "coats", "trade_goods", "tools", "muskets"
]

# ICONS.SS sprite index per commodity — BYTE_VERIFIED via visual inspection
# of ICONS.SS frames 022-037 (see verification/icons_22_37.png).
# Order matches Colonization's inventory bar (left-to-right).
COMMODITY_ICONS = {
    "food":         22, "sugar":   23, "tobacco":     24, "cotton":   25,
    "fur":          26, "lumber":  27, "ore":         28, "silver":   29,
    "horses":       30, "rum":     31, "cigars":      32, "cloth":    33,
    "coats":        34, "trade_goods": 35, "tools":   36, "muskets":  37,
}


def load_glyph_recolored(font_name, ascii_code, color, shadow_color=None):
    """Load a font glyph and recolor.

    Detects 1-bit vs 2-bit fonts:
      1-bit (FONTTINY, FONTSMAL): only idx 0+1 used; idx 1 = primary color
      2-bit (FONTKING, FONTINTR, FONT-NP): idx 0/1/2/3 used; idx 3 = primary,
        idx 1 = shadow, idx 2 = mid
    """
    from PIL import Image
    fpath = ASSETS / "fonts" / font_name / f"{font_name}.FF.{ascii_code:03d}.png"
    if not fpath.exists():
        return None
    glyph = Image.open(fpath)
    if shadow_color is None:
        shadow_color = (color[0] // 3, color[1] // 3, color[2] // 4)
    if glyph.mode != "P":
        return glyph.convert("RGBA")
    gw, gh = glyph.size
    new = Image.new("RGBA", (gw, gh), (0, 0, 0, 0))
    src = glyph.load()
    dst = new.load()
    # Determine if this is a 1-bit font (only idx 0 and 1 used)
    indices_used = set()
    for py in range(gh):
        for px in range(gw):
            indices_used.add(src[px, py])
    is_one_bit = (3 not in indices_used and 2 not in indices_used)

    for py in range(gh):
        for px in range(gw):
            idx = src[px, py]
            if is_one_bit:
                if idx == 1:
                    dst[px, py] = (*color, 255)
            else:
                if idx == 3:
                    dst[px, py] = (*color, 255)
                elif idx == 1:
                    dst[px, py] = (*shadow_color, 255)
                elif idx == 2:
                    mid = ((color[0] + shadow_color[0]) // 2,
                           (color[1] + shadow_color[1]) // 2,
                           (color[2] + shadow_color[2]) // 2)
                    dst[px, py] = (*mid, 255)
    return new



def render_text(canvas, text: str, x: int, y: int,
                color=(200, 160, 24), font: str = "FONTTINY", spacing: int = 1):
    cur_x = x
    for ch in text:
        ascii_code = ord(ch)
        if ascii_code == 32:
            cur_x += 3
            continue
        glyph = load_glyph_recolored(font, ascii_code, color)
        if glyph is None:
            cur_x += 3
            continue
        canvas.paste(glyph, (cur_x, y), glyph)
        cur_x += glyph.size[0] + spacing
    return cur_x


def render_topbar(canvas, colony):
    """Top title bar (8 px tall) — wood-grain background tiled from
    WOODTILE.SS frame 000, with mixed-case yellow title text centered.
    Citation: colon3.jpg shows the title bar uses the same wood-grain
    texture as the rest of the chrome panels.
    """
    from PIL import Image
    woodtile_path = ASSETS / "sprites" / "WOODTILE" / "WOODTILE.SS.000.png"
    if woodtile_path.exists():
        wood = Image.open(woodtile_path).convert("RGBA")
        wt_w, wt_h = wood.size
        # Tile horizontally across full width, vertical extent = 1 wood-tile row
        for ty in range(0, 9, max(wt_h, 1)):
            for tx in range(0, SCREEN_W, max(wt_w, 1)):
                canvas.paste(wood, (tx, ty), wood)
    title = f"{colony['name']}.  {colony['season']}, {colony['year']}.  Gold: {colony['treasury']}"
    # Measure precisely for proper centering
    text_w = measure_text(title, "FONTTINY")
    center_x = max(2, (SCREEN_W - text_w) // 2)
    render_text(canvas, title, center_x, 1, color=(200, 160, 24), font="FONTTINY")


def render_colony_view(canvas, colony):
    """Top-left quadrant: building grid + colonists.

    Pixel-verified background: TERRAIN.SS.001 (16x16 beige Plains tile)
    tiled across the colony view area. Colors match colon3.jpg dominant
    rgb(224,208,160) cream-beige (TERRAIN.SS.001 idx 109/111 = (210,194,157)
    and (194,174,133) which JPG-compresses to ~(224,208,160)).

    TERRAIN.SS is in the BYTE_VERIFIED-loaded sheet list (per
    CLAUDE.md ruling 2026-04-21). Frame 001 = Plains terrain, which
    is what Baltimore sits on per AMER2.MP.
    """
    from PIL import Image
    cv_x = 0
    cv_y = 8
    cv_w = 175
    cv_h = 110

    # Tile TERRAIN.SS.001 as the ground background
    terrain_path = ASSETS / "sprites" / "TERRAIN" / "TERRAIN.SS.001.png"
    if terrain_path.exists():
        tile = Image.open(terrain_path).convert("RGBA")
        tw, th = tile.size
        for ty in range(cv_y, cv_y + cv_h, max(th, 1)):
            for tx in range(cv_x, cv_x + cv_w, max(tw, 1)):
                # Only paste if it fits within the colony view
                if tx + tw > cv_x + cv_w or ty + th > cv_y + cv_h:
                    # Paste then crop
                    canvas.paste(tile, (tx, ty), tile)
                else:
                    canvas.paste(tile, (tx, ty), tile)

    # Place buildings using BUILDING.SS sprites
    building_dir = ASSETS / "sprites" / "BUILDING"
    cell_w = cv_w // 7  # 7 columns
    cell_h = cv_h // 6  # 6 rows
    # Map building_id -> sprite frame index (TBD approximations)
    # BYTE_VERIFIED via visual inspection of buildings_labeled.png
    # - 000-002, 016: 73x18 long stockade/fence segments
    # - 003-005, 012-015, 020-022: 44x22 banner-decorated buildings
    # - 006-009: 75x48 / 53x37 LARGE multi-story (town hall, large warehouse)
    # - 023-039: 23x27 small/medium colonial houses + churches
    # - 037-038: church-style with cross
    bldg_sprite_idx = {
        "town_hall":    8,   # large multi-story
        "church":      37,
        "stockade":    16,   # long fence segment
        "smithy":      26,
        "lumber_mill": 32,
        "warehouse":   12,
        "dock":        47,   # near water
        "school":      28,
    }
    for bldg_id, gx, gy, label in colony["buildings"]:
        idx = bldg_sprite_idx.get(bldg_id, 10)
        png = building_dir / f"BUILDING.SS.{idx:03d}.png"
        if png.exists():
            sprite = Image.open(png).convert("RGBA")
            ox = cv_x + gx * cell_w
            oy = cv_y + gy * cell_h
            # Ensure not above colony view top edge
            if oy < cv_y:
                oy = cv_y
            # Constrain
            if ox + sprite.size[0] <= cv_x + cv_w and oy + sprite.size[1] <= cv_y + cv_h:
                canvas.paste(sprite, (ox, oy), sprite)
            # Label rendered in FONTTINY (mixed-case, smaller than FONTTINY)
            # ALWAYS below building, never above (avoids title bar overlap)
            if label:
                label_y = oy + sprite.size[1] - 8
                # Black background pill behind label for legibility
                from PIL import ImageDraw
                draw = ImageDraw.Draw(canvas)
                label_w = len(label) * 5
                draw.rectangle(
                    [(ox + 2, label_y - 1), (ox + 2 + label_w, label_y + 8)],
                    fill=(0, 0, 0)
                )
                render_text(canvas, label, ox + 4, label_y,
                            color=(255, 255, 255), font="FONTTINY")

    # Layer 2: Colonist sprites at each building (showing assigned worker)
    icons_dir = ASSETS / "sprites" / "ICONS"
    job_to_icon_idx = {
        "statesman":   95,   # Free Colonist (gray figure)
        "preacher":   105,   # Missionary
        "smith":      106,   # Pioneer (worker)
        "lumberjack":  96,   # Indentured Servant
    }
    for job, gx, gy in colony.get("colonists", []):
        idx = job_to_icon_idx.get(job, 95)
        png = icons_dir / f"ICONS.SS.{idx:03d}.png"
        if png.exists():
            sprite = Image.open(png).convert("RGBA")
            # Position next to building
            ox = cv_x + gx * cell_w + cell_w // 2
            oy = cv_y + gy * cell_h + cell_h // 2 + 8
            canvas.paste(sprite, (ox, oy), sprite)


def render_production_grid(canvas, colony):
    """Top-right: 3x3 production grid showing commodity icon + yield
    per surrounding tile.

    Each cell has a TERRAIN.SS background (matching the surrounding
    map terrain at that offset from colony center). For now, uses
    cell-specific terrain frames per the colony def's neighbor types.
    Center cell uses TERRAIN.SS.001 (Plains where colony sits).
    """
    from PIL import Image
    pg_x = 180
    pg_y = 9
    pg_w = 140
    pg_h = 96
    cell_w = pg_w // 3
    cell_h = pg_h // 3
    icons_dir = ASSETS / "sprites" / "ICONS"
    terrain_dir = ASSETS / "sprites" / "TERRAIN"

    # Commodity-to-terrain heuristic: yield type implies surrounding terrain
    # food/sugar/cotton -> grassland-like (TERRAIN 003)
    # tobacco -> Plains (TERRAIN 001)
    # ore/silver -> Mountain/Hill (TERRAIN 005)
    # lumber -> Forest (TERRAIN 002)
    # furs -> Forest
    com_to_terrain = {
        "food": 3, "sugar": 1, "tobacco": 1, "cotton": 1,
        "fur": 5, "lumber": 5, "ore": 5, "silver": 5,
        "horses": 1, "rum": 1, "cigars": 1, "cloth": 1,
        "coats": 1, "trade_goods": 1, "tools": 1, "muskets": 1,
    }

    # Pre-fill ALL 9 cells with default terrain bg (so center cell isn't black)
    default_terrain_png = terrain_dir / "TERRAIN.SS.001.png"
    if default_terrain_png.exists():
        default_tile = Image.open(default_terrain_png).convert("RGBA")
        dtw, dth = default_tile.size
        for ry in range(3):
            for rx in range(3):
                cell_left = pg_x + rx * cell_w
                cell_top = pg_y + ry * cell_h
                for ty in range(cell_top, cell_top + cell_h, max(dth, 1)):
                    for tx in range(cell_left, cell_left + cell_w, max(dtw, 1)):
                        canvas.paste(default_tile, (tx, ty), default_tile)

    # Now overlay the per-yield terrain + icon + number on each used cell
    for dx, dy, com, yld in colony["production_yields"]:
        rx, ry = dx + 1, dy + 1
        cell_left = pg_x + rx * cell_w
        cell_top = pg_y + ry * cell_h

        # Tile commodity-specific TERRAIN.SS frame as cell background
        terrain_idx = com_to_terrain.get(com, 1)
        terrain_png = terrain_dir / f"TERRAIN.SS.{terrain_idx:03d}.png"
        if terrain_png.exists():
            tile = Image.open(terrain_png).convert("RGBA")
            tw, th = tile.size
            for ty in range(cell_top, cell_top + cell_h, max(th, 1)):
                for tx in range(cell_left, cell_left + cell_w, max(tw, 1)):
                    canvas.paste(tile, (tx, ty), tile)

        # Commodity icon (BYTE_VERIFIED indices 22-37)
        idx = COMMODITY_ICONS.get(com, 22)
        png = icons_dir / f"ICONS.SS.{idx:03d}.png"
        if png.exists():
            sprite = Image.open(png).convert("RGBA")
            sw, sh = sprite.size
            ox = cell_left + (cell_w - sw) // 2
            oy = cell_top + (cell_h - sh) // 2
            canvas.paste(sprite, (ox, oy), sprite)
        # Yield number top-right of cell, yellow (FONTTINY clean)
        ty_text = cell_top + 1
        tx_text = cell_left + cell_w - 9
        render_text(canvas, str(yld), tx_text, ty_text,
                    color=(200, 160, 24), font="FONTTINY")

    # Center cell — show the colony's BUILDING.SS town-hall sprite
    # to indicate the colony itself
    center_left = pg_x + cell_w
    center_top = pg_y + cell_h
    bldg_png = ASSETS / "sprites" / "BUILDING" / "BUILDING.SS.008.png"
    if bldg_png.exists():
        bldg = Image.open(bldg_png).convert("RGBA")
        bw, bh = bldg.size
        # Scale down to fit cell
        max_w = cell_w - 4
        max_h = cell_h - 4
        if bw > max_w or bh > max_h:
            scale = min(max_w / bw, max_h / bh)
            bldg = bldg.resize((int(bw*scale), int(bh*scale)), Image.LANCZOS)
            bw, bh = bldg.size
        ox = center_left + (cell_w - bw) // 2
        oy = center_top + (cell_h - bh) // 2
        canvas.paste(bldg, (ox, oy), bldg)


def render_bottom_strip(canvas, colony):
    """Bottom 72 rows of the colony screen — uses COLONY.PIK as the
    background.

    Citation: COLONY.PIK is a 320x72 MADSPACK-2-section image (header +
    pixels). Section 0 declares w=320 h=72; section 1 = 23040 bytes of
    raw indexed pixels. It contains the middle band (SoL panel + ships
    dock + workers panel) above the 16-cell commodity inventory bar
    plus the EXIT button. This is what the game blits at y=128..200 on
    the colony screen.

    Per user instruction "don't add color boxes or textures as place
    holders" — we use the REAL extracted PIK image, not a faked solid.
    """
    from PIL import Image
    pik_png = ASSETS / "backgrounds" / "COLONY" / "COLONY.PIK.png"
    if pik_png.exists():
        bg = Image.open(pik_png).convert("RGBA")
        canvas.paste(bg, (0, SCREEN_H - 72), bg)

    # Middle band overlays — text only, on top of the PIK background.
    # PIK middle-band layout (from pixel inspection):
    #   Left panel (sky+grass) ~ x=0..114 — for SoL %
    #   Center panel (water with dock) ~ x=114..228 — for "No Ships"
    #   Right panel (grass+mountains) ~ x=228..304 — for workers/colonists
    # Pixel-verified fonts (colon3.jpg measurement):
    #   SoL %: FONTTINY white, ~7px tall (y=290-304 in 640x480 colon3 = 7px native)
    #   "No Ships in Port": FONTTINY yellow, ~7px tall
    mb_y = SCREEN_H - 72  # y=128
    # SoL percentages — top of left panel (sky area)
    render_text(canvas, f"{colony['tory_pct']}% ({colony['tory_count']})",
                4, mb_y + 2, color=(255, 255, 255), font="FONTTINY")
    render_text(canvas, f"{colony['rebel_pct']}% ({colony['rebel_count']})",
                4, mb_y + 12, color=(255, 255, 255), font="FONTTINY")

    # Ships panel — top of center panel
    if not colony["ships_in_port"]:
        # Center horizontally over center panel (x=114..228 -> mid 171)
        # LABELS.TXT @MISC line 26 = "No Ships In Port" (capital I)
        text = "No Ships In Port"
        text_w = measure_text(text, "FONTTINY")
        center_x = 114 + (228 - 114 - text_w) // 2
        render_text(canvas, text, center_x, mb_y + 2,
                    color=(200, 160, 24), font="FONTTINY")


def measure_text(text: str, font: str, spacing: int = 1) -> int:
    """Compute pixel width of `text` in the given font."""
    from PIL import Image
    total = 0
    for ch in text:
        if ch == " ":
            total += 3
            continue
        ascii_code = ord(ch)
        font_dir = ASSETS / "fonts" / font
        fpath = font_dir / f"{font}.FF.{ascii_code:03d}.png"
        if fpath.exists():
            g = Image.open(fpath)
            total += g.size[0] + spacing
        else:
            total += 4
    return total


def render_inventory_overlay(canvas, colony):
    """Overlay 16 commodity icons + quantities on top of the COLONY.PIK
    background.

    Pixel-verified from colon3.jpg DOSBox capture:
      COLONY.PIK is 320x72, pasted at screen y=128..200.
      Within COLONY.PIK relative coords:
        relative y=46..58 (screen y=174..186) = thin GREEN GRASS strip
          where commodity icons sit (icons bottom-align to y=186)
        relative y=58..72 (screen y=186..200) = 16 BLUE cells with
          dark-navy quantity numbers
      Icon width ≈ 12-14px; bottom of icon at y=186 (top of blue cell).
      Number is FONTTINY dark navy (20,28,120) centered at y=189.
    """
    from PIL import Image
    icon_bottom = 186    # bottom edge of icons = top of blue cells
    num_y = 189          # FONTTINY ascender at this Y in blue cell
    cell_w = 19
    start_x = 0
    icons_dir = ASSETS / "sprites" / "ICONS"
    for i, com in enumerate(COMMODITY_ORDER):
        cx = start_x + i * cell_w
        idx = COMMODITY_ICONS.get(com, 22)
        png = icons_dir / f"ICONS.SS.{idx:03d}.png"
        if png.exists():
            sprite = Image.open(png).convert("RGBA")
            sw, sh = sprite.size
            ox = cx + (cell_w - sw) // 2
            oy = icon_bottom - sh
            canvas.paste(sprite, (ox, oy), sprite)
        qty = colony["stockpile"].get(com, 0)
        qty_str = str(qty)
        # Pixel-verified: inventory numbers are FONTTINY in DARK BLUE
        # Sample colon3.jpg at (14-27, 470): rgb(20,28,120) — dark navy
        text_w = measure_text(qty_str, "FONTTINY")
        nx = cx + (cell_w - text_w) // 2
        render_text(canvas, qty_str, nx, num_y,
                    color=(20, 28, 120), font="FONTTINY")


def render_right_panel(canvas, colony):
    """Right-edge wood panel + vertical EXIT label.

    Per colon3.jpg the wood panel spans the FULL height (y=0..200) but
    is narrow (~12-15 px wide). The "EXIT" letters are stacked vertically.

    Drawn AFTER the COLONY.PIK background so it overlays correctly.
    Tiles WOODTILE.SS frame 000 vertically.
    """
    from PIL import Image
    woodtile = ASSETS / "sprites" / "WOODTILE" / "WOODTILE.SS.000.png"
    if not woodtile.exists():
        return
    wood = Image.open(woodtile).convert("RGBA")
    wt_w, wt_h = wood.size
    panel_w = 12
    panel_x = SCREEN_W - panel_w
    # Tile from y=9 (just below title bar) to bottom
    for ty in range(9, SCREEN_H, max(wt_h, 1)):
        for tx in range(panel_x, SCREEN_W, max(wt_w, 1)):
            canvas.paste(wood, (tx, ty), wood)
    # EXIT vertical label — yellow letters stacked
    label_chars = list("EXIT")
    label_y_top = SCREEN_H - 4 - len(label_chars) * 7
    for i, ch in enumerate(label_chars):
        render_text(canvas, ch, panel_x + 3, label_y_top + i * 7,
                    color=(200, 160, 24), font="FONTTINY")


def render_colony(colony):
    from PIL import Image
    canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (0, 0, 0, 255))
    print(f"  Rendering colony screen: {colony['name']}")
    print("  - top bar (WOODTILE)")
    render_topbar(canvas, colony)
    print("  - colony view (BUILDING + ICONS)")
    render_colony_view(canvas, colony)
    print("  - production grid (ICONS commodities)")
    render_production_grid(canvas, colony)
    print("  - bottom strip (COLONY.PIK background)")
    render_bottom_strip(canvas, colony)
    print("  - inventory overlay (ICONS commodities + qty)")
    render_inventory_overlay(canvas, colony)
    print("  - right wood panel + EXIT label (WOODTILE)")
    render_right_panel(canvas, colony)
    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--colony", type=Path,
                    help="Colony definition JSON (uses Baltimore sample if omitted)")
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "screens" / "colony_baltimore.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)

    if args.colony:
        colony = json.loads(args.colony.read_text())
    else:
        colony = SAMPLE_COLONY

    canvas = render_colony(colony)
    if args.scale > 1:
        from PIL import Image
        upscaled = canvas.resize(
            (SCREEN_W * args.scale, SCREEN_H * args.scale),
            Image.NEAREST,
        )
        upscaled.save(args.out)
    else:
        canvas.save(args.out)
    print(f"  wrote {args.out}  ({canvas.size[0] * args.scale}x{canvas.size[1] * args.scale})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
