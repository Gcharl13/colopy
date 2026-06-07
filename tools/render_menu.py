#!/usr/bin/env python3
"""
render_menu.py — Render the main menu screen.

Composition:
  - OPENMENU.PIK background (Sid Meier's COLONIZATION title image)
  - Menu options box at center per GAME.TXT @BEGINMENU definition:
    @width=160, @y=91, @smallfont
    Body: "{COLONIZATION} Version 1.0"
    Options: Start a Game in NEW WORLD / Start a Game in AMERICA /
             CUSTOMIZE New World / LOAD Game / View Hall of Fame

Per pixel-verified font usage: title text in yellow FONTTINY; menu
options in green FONTTINY (matches GAME.TXT @smallfont directive
which would map to FONTSMAL but font shape match better with FONTTINY).
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"

SCREEN_W = 320
SCREEN_H = 200

TITLE_YELLOW = (200, 160, 24)
OPTION_GREEN = (80, 144, 48)


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


def render_menu():
    from PIL import Image, ImageDraw

    pik = ASSETS / "backgrounds" / "OPENMENU" / "OPENMENU.PIK.png"
    if pik.exists():
        canvas = Image.open(pik).convert("RGBA")
    else:
        canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (0, 0, 0, 255))

    # Menu box per GAME.TXT @BEGINMENU: width=160, y=91
    box_w = 160
    box_x = (SCREEN_W - box_w) // 2
    box_y = 91

    # Translucent darker bg behind menu options for readability
    overlay = Image.new("RGBA", (box_w, 70), (40, 30, 15, 200))
    canvas.paste(overlay, (box_x, box_y), overlay)

    # Title text "COLONIZATION Version 1.0"
    title_text = "COLONIZATION  Version 1.0"
    text_w = measure_text(title_text, "FONTTINY")
    render_text(canvas, title_text, box_x + (box_w - text_w) // 2, box_y + 2,
                TITLE_YELLOW, "FONTTINY")

    # Options
    options = [
        "Start a Game in NEW WORLD",
        "Start a Game in AMERICA",
        "CUSTOMIZE New World",
        "LOAD Game",
        "View Hall of Fame",
    ]
    opt_y = box_y + 12
    for option in options:
        render_text(canvas, option, box_x + 4, opt_y,
                    OPTION_GREEN, "FONTTINY")
        opt_y += 9

    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "screens" / "menu_with_options.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    canvas = render_menu()
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
