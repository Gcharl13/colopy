#!/usr/bin/env python3
"""
render_cc.py — Render the Continental Congress screen.

Composition:
  - CCBKGD.PIK background (the Congress hall room)
  - Up to 25 founding-father portrait sprites (CC-00..CC-24) arranged
    along the back wall + balcony
  - Title at top: "Continental Congress" or current debate
  - Stats display at bottom

Per pixel-verification, text on this screen uses FONTTINY in green
on dark background or yellow on title strip.
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
BODY_GREEN = (80, 144, 48)


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


# Founding Father names per NAMES.TXT @FOUNDING (25 fathers, indexed 0..24)
FOUNDING_FATHERS = [
    "Adam Smith", "Jakob Fugger", "Peter Stuyvesant", "Peter Minuit",
    "Francisco de Coronado", "Juan de Sepulveda", "Hernan Cortes", "Henry Hudson",
    "John Smith", "Bartolome de las Casas", "Jean de Brebeuf", "La Salle",
    "Hernando de Soto", "Jakob Fugger", "Henry Hudson", "Pocahontas",
    "Sieur de La Salle", "Simon Bolivar", "Benjamin Franklin", "Francisco de Coronado",
    "Thomas Jefferson", "Father Las Casas", "George Washington", "Jose de San Martin",
    "Paul Revere",
]


def render_cc(state):
    """Continental Congress hall — NO TEXT OVERLAYS.

    Per user correction: the CC hall view contains NO text. It just
    shows the Founding Father portraits standing on the balcony with
    CCBKGD.PIK as the room background.
    """
    from PIL import Image

    pik = ASSETS / "backgrounds" / "CCBKGD" / "CCBKGD.PIK.png"
    if pik.exists():
        canvas = Image.open(pik).convert("RGBA")
    else:
        canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (180, 165, 140, 255))

    # FF portraits arranged on the balcony.
    # Each acquired father stands on the balcony at full sprite size.
    acquired = state.get("acquired_fathers", [])
    if not acquired:
        acquired = list(range(8))

    # The balcony in CCBKGD.PIK runs roughly y=60..90, full width.
    # Stand each FF at their position along the balcony.
    n_per_row = 8
    spacing_x = SCREEN_W // n_per_row
    for i, ff_idx in enumerate(acquired[:n_per_row]):
        cc_dir = ASSETS / "sprites" / f"CC-{ff_idx:02d}"
        png = cc_dir / f"CC-{ff_idx:02d}.SS.000.png"
        if not png.exists():
            continue
        sprite = Image.open(png).convert("RGBA")
        # Scale down to fit balcony height ~50px
        max_h = 50
        if sprite.size[1] > max_h:
            ratio = max_h / sprite.size[1]
            sprite = sprite.resize(
                (int(sprite.size[0] * ratio), max_h), Image.LANCZOS
            )
        # Position centered on each balcony slot, feet on balcony floor (y=110)
        x = i * spacing_x + (spacing_x - sprite.size[0]) // 2
        y = 110 - sprite.size[1]
        canvas.paste(sprite, (x, y), sprite)

    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "screens" / "cc_with_fathers.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    state = {
        "title": "Continental Congress Activities",
        "debating": "Adam Smith",
        "acquired_fathers": [0, 4, 7, 10, 18, 20, 22, 24],
        "stats": "Liberty Bells: +32   Members: 8 / 25",
    }
    canvas = render_cc(state)
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
