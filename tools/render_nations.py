#!/usr/bin/env python3
"""
render_nations.py — Render the Nation Selection screen.

Pixel-verified composition (per 719e508...jpg DOSBox screenshot
+ NATIONS.PIK direct inspection 2026-05-05):
  - Background: NATIONS.PIK (wood-grain with 4 flag panels in 2×2)
  - Title (left side): "Select European Power" in GREEN FONTTINY
    -- LABELS.TXT @MISC lines 185-187 ("Select" / "European" / "Power")
  - Bottom-left prompt: "(Click Here When Finished)"
    -- LABELS.TXT @MISC line 176
  - 4 flag panels in 2x2 grid (each ~100x80, in painted wood frames):
    Top-left:    England (red+gold lions/dragons heraldry)
    Top-right:   France (blue with gold fleur-de-lis)
    Bottom-left: Spain  (red/white quartered with castle/lion)
    Bottom-right: Dutch (orange/purple/black tricolor)

  Each flag is one of the ENGLND1/FRANCE1/SPAIN1/DUTCH1 sprites.
  - Selected panel: GREEN BORDER + nation name above + mode below

  Mode text per nation (from NAMES.TXT @COUNTRY + special):
    "Trade" / "Cooperation" / "Conquest" / "Immigration"
    -- LABELS.TXT @MISC lines 188-191

Doc refs:
  - docs/SESSION_UI_CATALOG.md — flag sprite identification
  - docs/RENDERER_GEOMETRY.md — Nation selection screen layout
  - docs/LABELS_TXT_CATALOG.md — text label sources
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"

SCREEN_W = 320
SCREEN_H = 200

SELECT_GREEN = (80, 144, 48)
SELECTED_BORDER_GREEN = (0, 255, 0)


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



def measure_text(text, font, spacing=1):
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


def render_text(canvas, text, x, y, color, font="FONTTINY"):
    cur_x = x
    for ch in text:
        if ch == " ":
            cur_x += 3
            continue
        ascii_code = ord(ch)
        glyph = load_glyph_recolored(font, ascii_code, color)
        if glyph is None:
            cur_x += 4
            continue
        canvas.paste(glyph, (cur_x, y), glyph)
        cur_x += glyph.size[0] + 1
    return cur_x


def render_nations(state):
    from PIL import Image, ImageDraw

    nations_pik = ASSETS / "backgrounds" / "NATIONS" / "NATIONS.PIK.png"
    if nations_pik.exists():
        canvas = Image.open(nations_pik).convert("RGBA")
    else:
        # Fallback: WOODTILE bg
        canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (50, 30, 20, 255))
        woodtile = ASSETS / "sprites" / "WOODTILE" / "WOODTILE.SS.000.png"
        if woodtile.exists():
            wood = Image.open(woodtile).convert("RGBA")
            for ty in range(0, SCREEN_H, max(wood.size[1], 1)):
                for tx in range(0, SCREEN_W, max(wood.size[0], 1)):
                    canvas.paste(wood, (tx, ty), wood)

    # Title text on left side. Per DOSBox 719e508 layout:
    # "Select" on first line (y=40), "European Power" on second (y=50).
    line1 = "Select"
    line2 = "European  Power"
    l1_w = measure_text(line1, "FONTTINY")
    l2_w = measure_text(line2, "FONTTINY")
    # Center within the left ~110px region
    title_center = 55
    render_text(canvas, line1, title_center - l1_w // 2, 40, SELECT_GREEN, "FONTTINY")
    render_text(canvas, line2, title_center - l2_w // 2, 50, SELECT_GREEN, "FONTTINY")

    # Bottom-left finish prompt.
    # DOSBox shows "(Click Here When Finished)" WITH parens.
    render_text(canvas, "(Click Here When Finished)", 4, SCREEN_H - 8,
                SELECT_GREEN, "FONTTINY")

    # Flag panel positions matched to actual NATIONS.PIK frame edges +
    # verified against the green selection rectangle in DOSBox capture
    # 719e508.jpg (where green pixels span native x=211..299 y=104..186):
    PANEL_BOXES = [
        (111, 16, 199, 98),    # 0 = top-left (England)
        (211, 16, 299, 98),    # 1 = top-right (France)
        (111, 104, 199, 186),  # 2 = bot-left (Spain)
        (211, 104, 299, 186),  # 3 = bot-right (Holland)
    ]

    sel_idx = state.get("selected_nation_idx", 3)
    if 0 <= sel_idx < len(PANEL_BOXES):
        x0, y0, x1, y1 = PANEL_BOXES[sel_idx]
        draw = ImageDraw.Draw(canvas)
        draw.rectangle([(x0, y0), (x1, y1)], outline=SELECTED_BORDER_GREEN)

        # Nation name + mode positioned above/below the selected panel
        nation_name = state.get("selected_nation", "GOG GOG:")
        nation_mode = state.get("selected_mode", "Trade")
        name_w = measure_text(nation_name, "FONTTINY")
        panel_w = x1 - x0
        render_text(canvas, nation_name, x0 + (panel_w - name_w) // 2,
                    y0 - 7, SELECT_GREEN, "FONTTINY")
        mode_w = measure_text(nation_mode, "FONTTINY")
        render_text(canvas, nation_mode, x0 + (panel_w - mode_w) // 2,
                    y1 + 1, SELECT_GREEN, "FONTTINY")

    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "screens" / "nations.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    # Default to Netherlands (idx 3) per the user's reference screenshot.
    # Per NAMES.TXT @COUNTRY: 0=England, 1=France, 2=Spain, 3=Netherlands.
    NATIONS = ["England", "France", "Spain", "Netherlands"]
    state = {
        "selected_nation_idx": 3,
        "selected_nation": NATIONS[3] + ":",
        "selected_mode": "Trade",
    }
    canvas = render_nations(state)
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
