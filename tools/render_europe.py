#!/usr/bin/env python3
"""
render_europe.py — Render the Europe screen.

Pixel-verified composition (per DOSBox screenshot 0d9a26d...jpg):
  - Background: EUROPE.PIK (320x200, sky+harbor+buildings)
  - Title bar (y=0..8): WOODTILE.SS tiled, GREEN FONTTINY text
    "<HOMEPORT> HQ.  <NATION>.com.  <Season>, <Year>. Tax: N% Gold: NNNN"
  - Three info panels (y=120..130):
      x=0..115   "Expected Soon"
      x=115..215 "Bound For <colony>"
      x=215..320 "No Ships in Port"
  - Three RECRUIT/PURCHASE/TRAIN buttons stacked top-right:
      x=275..318  y=145..177  light-blue fill, white border, yellow text
  - Ship lineup at the dock (existing ships + recruits with yellow $$$)
  - Inventory bar (y=180..200): 16 cells × 19 px wide, "current/max" yellow
  - Yellow selection rectangle highlights the currently-active commodity
  - "Exit" red label at far right (x=305..320, y=193)
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"

SCREEN_W = 320
SCREEN_H = 200

# Pixel-sampled colors from 0d9a26d... DOSBox capture
TITLE_GREEN     = (96, 168, 60)     # title bar text
LABEL_GREEN     = (96, 168, 60)     # panel labels
NUMBER_YELLOW   = (240, 200, 40)    # inventory numbers
CELL_BG         = (88, 96, 144)     # blue cell background (under inventory)
SELECT_YELLOW   = (240, 200, 40)    # selected-cell highlight rect
BUTTON_FILL     = (224, 224, 248)   # light-blue button background
BUTTON_BORDER   = (255, 255, 255)   # white button border
BUTTON_TEXT     = (200, 160, 24)    # yellow button text
EXIT_RED        = (220, 60, 60)     # Exit label red


# SAMPLE_STATE matches verified frame 1310291187 (Spring 1543, English
# player, after selling 72 Rum at 0%/ton — Sugar still trading)
# Verified against memory snapshot at that timestamp.
SAMPLE_STATE = {
    "nation_short": "Eng.",        # NAMES.TXT @NATIONABBREV[0]
    "nation_full":  "London",      # NAMES.TXT @HOMEPORT[0]
    "season":       "Spring",
    "year":         1543,
    "treasury":     19200,         # PowerRecord[+0x2A] in early-session
    "tax_rate":     0,             # PowerRecord[+0x01]
    "expected_arrivals": [],
    "in_transit_ship": "Caravel",  # ICONS.SS.<caravel-idx>
    "destination":   "New England",
    "ships_in_port": [],
    # Stockpile values from frame 1310291187 inventory bar (current/max)
    "stockpile": {
        "food": 1, "sugar": 17, "tobacco": 5, "cotton": 4,
        "fur": 16, "lumber": 1, "ore": 3, "silver": 19,
        "horses": 3, "rum": 0, "cigars": 0, "cloth": 0,
        "coats": 0, "trade_goods": 2, "tools": 1, "muskets": 2,
    },
    # Maxes also from frame
    "stockpile_max": {
        "food": 29, "sugar": 19, "tobacco": 7, "cotton": 6,
        "fur": 18, "lumber": 6, "ore": 6, "silver": 20,
        "horses": 4, "rum": 0, "cigars": 0, "cloth": 0,
        "coats": 0, "trade_goods": 3, "tools": 2, "muskets": 3,
    },
    "selected_commodity": "food",
    # Boycott bitfield from PowerRecord[+0x20] u16
    # In the verified game state, only Food (bit 0) was boycotted
    "boycott_bitfield": 0x0001,    # bit 0 = Food boycotted
    # Saturation: byte=0xC8 in PowerRecord[+0x4C+i] means "show 0/0"
    # Verified for Rum/Cigars/Cloth/Coats in this frame
}

COMMODITY_ORDER = [
    "food", "sugar", "tobacco", "cotton",
    "fur", "lumber", "ore", "silver",
    "horses", "rum", "cigars", "cloth",
    "coats", "trade_goods", "tools", "muskets"
]
COMMODITY_ICONS = {
    "food":         22, "sugar":   23, "tobacco":     24, "cotton":   25,
    "fur":          26, "lumber":  27, "ore":         28, "silver":   29,
    "horses":       30, "rum":     31, "cigars":      32, "cloth":    33,
    "coats":        34, "trade_goods": 35, "tools":   36, "muskets":  37,
}


def load_glyph_recolored(font_name, ascii_code, color, shadow_color=None):
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


def measure_text(text, font="FONTTINY", spacing=1):
    from PIL import Image
    total = 0
    for ch in text:
        if ch == " ":
            total += 3
            continue
        ascii_code = ord(ch)
        fpath = ASSETS / "fonts" / font / f"{font}.FF.{ascii_code:03d}.png"
        if fpath.exists():
            g = Image.open(fpath)
            total += g.size[0] + spacing
        else:
            total += 4
    return total


def render_text(canvas, text, x, y, color, font="FONTTINY", spacing=1):
    cur_x = x
    for ch in text:
        if ch == " ":
            cur_x += 3
            continue
        ascii_code = ord(ch)
        glyph = load_glyph_recolored(font, ascii_code, color)
        if glyph is None:
            cur_x += 3
            continue
        canvas.paste(glyph, (cur_x, y), glyph)
        cur_x += glyph.size[0] + spacing
    return cur_x


def render_europe(state):
    from PIL import Image, ImageDraw

    # 1. Background
    europe_pik = ASSETS / "backgrounds" / "EUROPE" / "EUROPE.PIK.png"
    if europe_pik.exists():
        canvas = Image.open(europe_pik).convert("RGBA")
    else:
        canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (50, 100, 150, 255))

    # 2. Title bar — WOODTILE tiled
    woodtile_path = ASSETS / "sprites" / "WOODTILE" / "WOODTILE.SS.000.png"
    if woodtile_path.exists():
        wood = Image.open(woodtile_path).convert("RGBA")
        wt_w, wt_h = wood.size
        for ty in range(0, 9, max(wt_h, 1)):
            for tx in range(0, SCREEN_W, max(wt_w, 1)):
                canvas.paste(wood, (tx, ty), wood)

    # 3. Title text
    title = (f"{state['nation_full']} HQ.  "
             f"{state['nation_full']}.com.  "
             f"{state['season']}, {state['year']}. "
             f"Tax: {state['tax_rate']}% "
             f"Gold: {state['treasury']}")
    text_w = measure_text(title)
    center_x = (SCREEN_W - text_w) // 2 if text_w <= SCREEN_W - 4 else 2
    render_text(canvas, title, center_x, 1, TITLE_GREEN)

    draw = ImageDraw.Draw(canvas)

    # 4. Three info panels at y=125. Per pixel-measure of 0d9a26d:
    #    Panel separators at x=115 and x=215 (thin white lines from y=120..145)
    PANEL_Y = 125
    PANEL_TOP = 120
    PANEL_BOT = 145
    panel_seps = [(115, PANEL_TOP, 115, PANEL_BOT),
                  (215, PANEL_TOP, 215, PANEL_BOT)]
    for x0, y0, x1, y1 in panel_seps:
        draw.line([(x0, y0), (x1, y1)], fill=(255, 255, 255))
    # Top border across panels
    draw.line([(0, PANEL_TOP), (SCREEN_W, PANEL_TOP)], fill=(255, 255, 255))

    # Panel 1: "Expected Soon"
    p1_text = "Expected Soon"
    p1_w = measure_text(p1_text)
    render_text(canvas, p1_text, (115 - p1_w) // 2, PANEL_Y, LABEL_GREEN)

    # Panel 2: "Bound For <dest>" (only when in_transit_ship is non-None)
    if state.get("in_transit_ship"):
        # 2-line label: "Bound For" / "<destination>"
        line1 = "Bound For"
        line2 = state["destination"]
        l1_w = measure_text(line1)
        l2_w = measure_text(line2)
        center = (115 + 215) // 2
        render_text(canvas, line1, center - l1_w // 2, PANEL_Y, LABEL_GREEN)
        render_text(canvas, line2, center - l2_w // 2, PANEL_Y + 8, LABEL_GREEN)

    # Panel 3: "No Ships in Port"
    if not state["ships_in_port"]:
        p3_text = "No Ships in Port"
        p3_w = measure_text(p3_text)
        center3 = (215 + SCREEN_W) // 2
        render_text(canvas, p3_text, center3 - p3_w // 2, PANEL_Y, LABEL_GREEN)

    # 5. Top-right buttons RECRUIT/PURCHASE/TRAIN at y=148..177
    # Pixel-measured from 0d9a26d: 3 buttons stacked, 44 px wide, light-blue
    # fill, white border, yellow text. x=275..318, y=148+11i (3 buttons).
    button_w = 43
    button_h = 9
    button_x = 273
    for i, label in enumerate(("RECRUIT", "PURCHASE", "TRAIN")):
        by = 148 + i * (button_h + 2)
        draw.rectangle([(button_x, by),
                        (button_x + button_w - 1, by + button_h)],
                       fill=BUTTON_FILL, outline=BUTTON_BORDER)
        tw = measure_text(label)
        render_text(canvas, label,
                    button_x + (button_w - tw) // 2, by + 2,
                    BUTTON_TEXT)

    # 6. Inventory bar at y=180..200.
    # 16 cells, each 19 px wide. Cell background is dark blue.
    # Per-cell: icon top-half, "current/max" yellow text bottom-half.
    cell_w = 19
    icon_bottom = 192
    num_y = 193
    icons_dir = ASSETS / "sprites" / "ICONS"
    for i, com in enumerate(COMMODITY_ORDER):
        cx = i * cell_w
        # Cell background fill (slight blue overlay on EUROPE.PIK water)
        draw.rectangle([(cx, 180), (cx + cell_w - 1, 199)],
                       fill=CELL_BG)
        # Icon
        idx = COMMODITY_ICONS[com]
        png = icons_dir / f"ICONS.SS.{idx:03d}.png"
        if png.exists():
            sprite = Image.open(png).convert("RGBA")
            sw, sh = sprite.size
            ox = cx + (cell_w - sw) // 2
            oy = icon_bottom - sh
            canvas.paste(sprite, (ox, oy), sprite)
        # "current/max" number
        qty = state["stockpile"].get(com, 0)
        cap = state.get("stockpile_max", {}).get(com, qty)
        num_text = f"{qty}/{cap}"
        tw = measure_text(num_text)
        nx = cx + (cell_w - tw) // 2
        render_text(canvas, num_text, nx, num_y, NUMBER_YELLOW)

    # 7. Yellow selection rect on currently-active commodity
    sel = state.get("selected_commodity")
    if sel and sel in COMMODITY_ORDER:
        si = COMMODITY_ORDER.index(sel)
        sx0 = si * cell_w
        draw.rectangle([(sx0, 180), (sx0 + cell_w - 1, 199)],
                       outline=SELECT_YELLOW)

    # 8. "Exit" red label far right
    exit_x = SCREEN_W - 16
    render_text(canvas, "Exit", exit_x, 193, EXIT_RED)

    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "screens" / "europe.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    canvas = render_europe(SAMPLE_STATE)
    if args.scale > 1:
        from PIL import Image
        canvas = canvas.resize(
            (SCREEN_W * args.scale, SCREEN_H * args.scale),
            Image.NEAREST,
        )
    canvas.save(args.out)
    print(f"  wrote {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
