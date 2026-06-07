#!/usr/bin/env python3
"""
render_gameplay.py — Compose a full gameplay screen matching the
DOSBox layout: top menu bar + map view + right sidebar + optional
dialog overlay.

Native game resolution: 320x200. Output here matches that, then
upscaled for visibility. Compare against DOSBox capture in
verification/dosbox_screenshots/.

This is structural verification: layout and asset placement, not
pixel-perfect tile rendering (which is gated on PHYS0 sprite mapping
+ neighbor-aware transition logic).

Usage:
    python render_gameplay.py
    python render_gameplay.py --dialog cherokee_attack
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
TOPBAR_H = 8
SIDEBAR_W = 100
MAP_VIEW_W = SCREEN_W - SIDEBAR_W
MAP_VIEW_H = SCREEN_H - TOPBAR_H
TILE_PX = 16

# Sample game state matching the user's reference screenshot 2
SAMPLE_GAME_STATE = {
    "menu_items": ["Game", "View", "Orders", "Reports", "Trade"],
    "menu_right":  "Colonizopedia",
    "season": "Spring",
    "year": 1510,
    "treasury": 3000,
    "tax_rate": 0,
    "moves_remaining": 4,
    "selected_unit_x": 28,
    "selected_unit_y": 31,
    "selected_unit_class": "Fr. Caravel",
    "selected_unit_orders": "No Orders",
    "selected_unit_terrain": "(Ocean)",
    "viewport_top_left_x": 22,
    "viewport_top_left_y": 25,
    # Visible map units (per user screenshot):
    # Each: (icons_sprite_idx, map_x, map_y) - rendered on top of terrain
    "map_units": [
        (5,  28, 31),    # Caravel ship (selected) - ICONS 005 = Caravel (small ship)
        (5,  32, 28),    # Another Caravel
        (5,  25, 35),    # Caravel
        (12, 31, 35),    # Aztec/Mayan native village (golden roof)
        (100, 30, 38),   # Continental Army soldier
        (108, 33, 36),   # Native warrior (red)
        (103, 28, 39),   # Dragoon
        (0,  29, 33),    # Native village
    ],
    # Selected unit highlight position (cursor blink)
    "cursor_x": 28,
    "cursor_y": 31,
}


def render_map_view(game_state):
    """Render the visible portion of the map (map_view_w x map_view_h).

    Per terrain ID, the map view composites:
      1. Solid base color from VICEROY.PAL via TERRAIN_PAL_INDEX
      2. PHYS0.SS overlay sprite (per the per-terrain PHYS0_BASE map)
      3. Forest/river/mountain decorations
    """
    from PIL import Image
    map_json = json.loads((ASSETS / "maps" / "amer2.json").read_text())
    palette = json.loads((ASSETS / "palettes" / "viceroy.pal.json").read_text())
    from render_map_v2 import TERRAIN_PAL_INDEX
    rgb = [tuple(e["rgb_8bit"]) for e in palette["entries"]]

    width = map_json["width"]
    height = map_json["height"]
    tiles = map_json["tiles"]

    vw_tiles = MAP_VIEW_W // TILE_PX
    vh_tiles = MAP_VIEW_H // TILE_PX

    vx = game_state["viewport_top_left_x"]
    vy = game_state["viewport_top_left_y"]

    canvas = Image.new("RGB", (MAP_VIEW_W, MAP_VIEW_H), (0, 0, 0))
    pixels = canvas.load()

    # PHYS0 OVERLAY for visible decoration on top of solid base color.
    # Most game terrain is rendered as solid base color (matched from
    # VICEROY.PAL via TERRAIN_PAL_INDEX) with a PHYS0 sprite overlay
    # that adds the recognizable look (forest trees, hills/mountains
    # icons). Plain water/grass/desert use NO overlay.
    PHYS0_OVERLAY = {
        # forested terrain IDs 8-15: tree-cluster overlay
        8:  48,   # Boreal: forest tile
        9:  None, # Scrub: leave solid
        10: 49,   # Mixed forest
        11: 50,   # Broadleaf
        12: 51,   # Conifer
        13: 52,   # Tropical
        14: 53,   # Wetland
        15: 54,   # Rain
        # special terrain
        19: 32,   # Hills (rolling-hill icon)
        24: 24,   # Mountains (jagged peaks)
    }
    FOREST_OVERLAY_FRAME = 64

    phys0_dir = ASSETS / "sprites" / "PHYS0"
    phys0_cache = {}

    def get_phys0(idx):
        if idx in phys0_cache:
            return phys0_cache[idx]
        path = phys0_dir / f"PHYS0.SS.{idx:03d}.png"
        if path.exists():
            sprite = Image.open(path).convert("RGBA")
            if sprite.size != (TILE_PX, TILE_PX):
                sprite = None
        else:
            sprite = None
        phys0_cache[idx] = sprite
        return sprite

    for ty in range(vh_tiles):
        for tx in range(vw_tiles):
            mx = vx + tx
            my = vy + ty
            if 0 <= mx < width and 0 <= my < height:
                byte = tiles[my * width + mx]
                terrain_id = byte & 0x1F
                forest_bit = bool(byte & 0x80)
                river_bit = bool(byte & 0x40)
                resource_bit = bool(byte & 0x20)

                # 1. Solid base color fill (fallback if PHYS0 sprite absent)
                pal_idx = TERRAIN_PAL_INDEX.get(terrain_id, 45)
                color = rgb[pal_idx]
                for dy in range(TILE_PX):
                    for dx in range(TILE_PX):
                        px = tx * TILE_PX + dx
                        py = ty * TILE_PX + dy
                        if px < MAP_VIEW_W and py < MAP_VIEW_H:
                            pixels[px, py] = color

                # 2. PHYS0 overlay decoration (forest/hill/mountain sprites)
                ov_phys0 = PHYS0_OVERLAY.get(terrain_id)
                if ov_phys0 is not None:
                    sprite = get_phys0(ov_phys0)
                    if sprite:
                        canvas.paste(sprite,
                                     (tx * TILE_PX, ty * TILE_PX), sprite)

                # 3. Forest overlay (auto-forest bit indicates forest cover)
                if forest_bit and terrain_id < 8:
                    forest_sprite = get_phys0(FOREST_OVERLAY_FRAME)
                    if forest_sprite:
                        canvas.paste(forest_sprite,
                                     (tx * TILE_PX, ty * TILE_PX),
                                     forest_sprite)
                    else:
                        # Fallback: draw tiny dark-green tree clusters
                        tree_color = (16, 64, 24)
                        for tx_off, ty_off in [(2, 3), (8, 5), (5, 9)]:
                            for tw in range(3):
                                for th in range(tw + 1):
                                    px = tx * TILE_PX + tx_off + tw
                                    py = ty * TILE_PX + ty_off + th
                                    if px < MAP_VIEW_W and py < MAP_VIEW_H:
                                        pixels[px, py] = tree_color

                # 4. River overlay
                if river_bit and terrain_id < 25:
                    river_color = rgb[45]  # ocean blue
                    for off in range(TILE_PX):
                        px = tx * TILE_PX + 7
                        py = ty * TILE_PX + off
                        if px < MAP_VIEW_W and py < MAP_VIEW_H:
                            pixels[px, py] = river_color

    # Layer 2: Map unit overlays (ships, soldiers, native villages, etc.)
    icons_dir = ASSETS / "sprites" / "ICONS"
    for sprite_idx, mx, my in game_state.get("map_units", []):
        # Compute screen position relative to viewport
        tx = mx - vx
        ty = my - vy
        if 0 <= tx < vw_tiles and 0 <= ty < vh_tiles:
            sprite_path = icons_dir / f"ICONS.SS.{sprite_idx:03d}.png"
            if sprite_path.exists():
                sprite = Image.open(sprite_path).convert("RGBA")
                # Center sprite within tile
                sx = tx * TILE_PX + (TILE_PX - sprite.size[0]) // 2
                sy = ty * TILE_PX + (TILE_PX - sprite.size[1]) // 2
                if 0 <= sx < MAP_VIEW_W and 0 <= sy < MAP_VIEW_H:
                    canvas.paste(sprite, (sx, sy), sprite)

    # Layer 3: Cursor blink on selected unit (white rect)
    if "cursor_x" in game_state and "cursor_y" in game_state:
        cx = game_state["cursor_x"] - vx
        cy = game_state["cursor_y"] - vy
        if 0 <= cx < vw_tiles and 0 <= cy < vh_tiles:
            from PIL import ImageDraw
            draw = ImageDraw.Draw(canvas)
            x0, y0 = cx * TILE_PX, cy * TILE_PX
            x1, y1 = x0 + TILE_PX - 1, y0 + TILE_PX - 1
            draw.rectangle([(x0, y0), (x1, y1)], outline=(255, 255, 255))

    return canvas


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



def render_text(canvas, text: str, x: int, y: int, color=(200, 160, 24),
                font: str = "FONTTINY", spacing: int = 1):
    """Render a string of text using the given font with recoloring.

    Default font is FONTTINY which has mixed-case + punctuation.
    Use font='FONTSMAL' for all-caps menu text.
    """
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


def render_topbar(canvas, game_state):
    """Top menu bar at y=0..TOPBAR_H-1, full width.

    Pixel-verified from screenshot_03.jpg:
    - Background: WOODTILE.SS frame 000 (wood-grain)
    - Font: FONTTINY (chunky 3D uppercase) — verified by letter-shape
      match against FONTSMAL/FONTTINY/FONTTINY comparison
    - Color: yellow ~(200, 160, 24)
    - VICEROY loads `fontintr` at startup (asset table file 0x1FD29)
    """
    from PIL import Image, ImageDraw
    woodtile_path = ASSETS / "sprites" / "WOODTILE" / "WOODTILE.SS.000.png"
    if woodtile_path.exists():
        wood = Image.open(woodtile_path).convert("RGBA")
        wt_w, wt_h = wood.size
        for ty in range(0, TOPBAR_H, max(wt_h, 1)):
            for tx in range(0, SCREEN_W, max(wt_w, 1)):
                canvas.paste(wood, (tx, ty), wood)
    # Menu items (UPPERCASE per pixel-verified shape match in FONTTINY)
    x = 4
    for item in game_state["menu_items"]:
        item_upper = item.upper()
        x = render_text(canvas, item_upper, x, 1, color=(200, 160, 24), font="FONTTINY")
        x += 6
    # Right-aligned COLONIZOPEDIA
    right_text = game_state["menu_right"].upper()
    right_x = SCREEN_W - len(right_text) * 6 - 2
    render_text(canvas, right_text, right_x, 1, color=(200, 160, 24), font="FONTTINY")


def render_sidebar(canvas, game_state):
    """Right sidebar at x=MAP_VIEW_W..SCREEN_W."""
    from PIL import Image, ImageDraw
    sx = MAP_VIEW_W
    sy = TOPBAR_H

    woodtile_path = ASSETS / "sprites" / "WOODTILE" / "WOODTILE.SS.000.png"
    draw = ImageDraw.Draw(canvas)
    if woodtile_path.exists():
        woodtile = Image.open(woodtile_path).convert("RGBA")
        wt_w, wt_h = woodtile.size
        for ty in range(sy, SCREEN_H, max(wt_h, 1)):
            for tx in range(sx, SCREEN_W, max(wt_w, 1)):
                canvas.paste(woodtile, (tx, ty), woodtile)
    else:
        draw.rectangle([(sx, sy), (SCREEN_W, SCREEN_H)], fill=(80, 50, 30))

    # Minimap at top
    minimap_h = 50
    draw.rectangle([(sx + 2, sy + 1), (SCREEN_W - 2, sy + minimap_h)], fill=(0, 0, 0))
    # Tiny world preview - render the full map at very low res
    map_json = json.loads((ASSETS / "maps" / "amer2.json").read_text())
    palette = json.loads((ASSETS / "palettes" / "viceroy.pal.json").read_text())
    from render_map_v2 import TERRAIN_PAL_INDEX
    rgb_pal = [tuple(e["rgb_8bit"]) for e in palette["entries"]]
    width = map_json["width"]
    height = map_json["height"]
    tiles = map_json["tiles"]
    # Fit to 70x47
    minimap_w_avail = SCREEN_W - 2 - (sx + 2)
    minimap_h_avail = minimap_h - 2
    px_per_tile_x = max(1, minimap_w_avail // width)
    px_per_tile_y = max(1, minimap_h_avail // height)
    px_per_tile = min(px_per_tile_x, px_per_tile_y)
    pixels = canvas.load()
    for y in range(height):
        for x in range(width):
            byte = tiles[y * width + x]
            terrain_id = byte & 0x1F
            pal_idx = TERRAIN_PAL_INDEX.get(terrain_id, 45)
            color = rgb_pal[pal_idx]
            for dy in range(px_per_tile):
                for dx in range(px_per_tile):
                    px = sx + 3 + x * px_per_tile + dx
                    py = sy + 2 + y * px_per_tile + dy
                    if sx + 3 <= px < SCREEN_W - 2 and sy + 2 <= py < sy + minimap_h:
                        pixels[px, py] = color

    # Viewport rectangle on minimap (white outline showing visible region)
    vp_x = game_state["viewport_top_left_x"]
    vp_y = game_state["viewport_top_left_y"]
    vp_w_tiles = MAP_VIEW_W // TILE_PX
    vp_h_tiles = MAP_VIEW_H // TILE_PX
    rx0 = sx + 3 + vp_x * px_per_tile
    ry0 = sy + 2 + vp_y * px_per_tile
    rx1 = sx + 3 + (vp_x + vp_w_tiles) * px_per_tile - 1
    ry1 = sy + 2 + (vp_y + vp_h_tiles) * px_per_tile - 1
    rx0 = max(sx + 3, min(rx0, SCREEN_W - 3))
    rx1 = max(sx + 3, min(rx1, SCREEN_W - 3))
    ry0 = max(sy + 2, min(ry0, sy + minimap_h - 1))
    ry1 = max(sy + 2, min(ry1, sy + minimap_h - 1))
    draw.rectangle([(rx0, ry0), (rx1, ry1)], outline=(255, 255, 255))

    # Status fields below minimap (mixed case, GREEN per pixel verification
    # of colon4.jpg and screenshot_03.jpg sidebar dominant text color
    # rgb(80,144,48). FONTTINY height 7px native matches.)
    field_y = sy + minimap_h + 3
    line_h = 8
    text_color = (80, 144, 48)  # green

    # Spring 1510 (season + year on one line)
    render_text(canvas, f"{game_state['season']} {game_state['year']}",
                sx + 2, field_y, color=text_color)
    field_y += line_h
    # Gold: 3000  Tax: 0%  (one line per user reference)
    render_text(canvas,
                f"Gold: {game_state['treasury']}  Tax: {game_state['tax_rate']}%",
                sx + 2, field_y, color=text_color)
    field_y += line_h
    # Moves: 4    Locat: (28, 31)  (one line)
    render_text(canvas,
                f"Moves: {game_state['moves_remaining']}  Locat: ({game_state['selected_unit_x']}, {game_state['selected_unit_y']})",
                sx + 2, field_y, color=text_color)
    field_y += line_h + 2
    # Selected unit details (3 lines)
    render_text(canvas, game_state["selected_unit_class"], sx + 2, field_y,
                color=text_color)
    field_y += line_h
    render_text(canvas, game_state["selected_unit_orders"], sx + 2, field_y,
                color=text_color)
    field_y += line_h
    render_text(canvas, game_state["selected_unit_terrain"], sx + 2, field_y,
                color=text_color)


def render_dialog_overlay(canvas, dialog_def):
    """Render a bottom-of-screen dialog overlay with portrait + text."""
    from PIL import Image, ImageDraw
    dlg_y = 130
    dlg_h = SCREEN_H - dlg_y
    dlg_x = 0
    dlg_w = MAP_VIEW_W

    draw = ImageDraw.Draw(canvas)
    woodtile_path = ASSETS / "sprites" / "WOODTILE" / "WOODTILE.SS.000.png"
    if woodtile_path.exists():
        woodtile = Image.open(woodtile_path).convert("RGBA")
        wt_w, wt_h = woodtile.size
        for ty in range(dlg_y, SCREEN_H, max(wt_h, 1)):
            for tx in range(dlg_x, dlg_x + dlg_w, max(wt_w, 1)):
                canvas.paste(woodtile, (tx, ty), woodtile)
    draw.rectangle([(dlg_x, dlg_y), (dlg_x + dlg_w - 1, SCREEN_H - 1)],
                   outline=(50, 30, 15))

    portrait_w = 60
    portrait_h = dlg_h - 4
    portrait_x = dlg_x + dlg_w - portrait_w - 4
    portrait_y = dlg_y + 2
    portrait_path = dialog_def.get("portrait_path")
    if portrait_path and Path(portrait_path).exists():
        portrait = Image.open(portrait_path).convert("RGBA")
        portrait.thumbnail((portrait_w, portrait_h), Image.LANCZOS)
        canvas.paste(portrait, (portrait_x, portrait_y), portrait)
    else:
        draw.rectangle([(portrait_x, portrait_y),
                        (portrait_x + portrait_w, portrait_y + portrait_h)],
                       outline=(200, 150, 80))

    title = dialog_def.get("title", "")
    text_x = dlg_x + 4
    text_y = dlg_y + 4
    # Pixel-verified from acaab... and b6235... DOSBox dialog screenshots:
    # Dialog text color = green rgb(80, 144, 48). FONTTINY shape match.
    DIALOG_COLOR = (80, 144, 48)
    if title:
        render_text(canvas, title, text_x, text_y, color=DIALOG_COLOR)
        text_y += 9

    for line in dialog_def.get("body_lines", []):
        render_text(canvas, line, text_x, text_y, color=DIALOG_COLOR)
        text_y += 8

    options_y = SCREEN_H - 18
    for i, option in enumerate(dialog_def.get("options", [])):
        render_text(canvas, option, text_x + 4, options_y + i * 8,
                    color=DIALOG_COLOR)


DIALOGS = {
    "cherokee_attack": {
        "title": "Shall we attack the Cherokee,",
        "body_lines": ["Your Excellency?"],
        "options": ["Yes", "No"],
        "portrait_path": str(ASSETS / "sprites" / "ICONS" / "ICONS.SS.100.png"),
    },
}


def render_gameplay(dialog_name=None):
    from PIL import Image
    canvas = Image.new("RGB", (SCREEN_W, SCREEN_H), (0, 0, 0))
    print("  rendering map view...")
    map_view = render_map_view(SAMPLE_GAME_STATE)
    canvas.paste(map_view, (0, TOPBAR_H))
    print("  rendering top menu bar...")
    render_topbar(canvas, SAMPLE_GAME_STATE)
    print("  rendering right sidebar...")
    render_sidebar(canvas, SAMPLE_GAME_STATE)
    if dialog_name and dialog_name in DIALOGS:
        print(f"  overlaying dialog: {dialog_name}")
        render_dialog_overlay(canvas, DIALOGS[dialog_name])
    return canvas


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--dialog", help="Overlay a sample dialog")
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "gameplay" / "gameplay.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    canvas = render_gameplay(dialog_name=args.dialog)
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
