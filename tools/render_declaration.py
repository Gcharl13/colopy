#!/usr/bin/env python3
"""
render_declaration.py — Render the Declaration of Independence
completion screen (post-revolution game-end cinematic).

Composition:
  - DECLARAT.PIK background (Declaration document image on a green
    table with a quill in inkwell)
  - DECOIND.PIK overlay (decorative flourishes around the document)
  - Player signature overlaid using DEC-LOW*/DEC-UPP* sprite glyphs
    (one sprite per letter; positioned at signature line)

Sprite sheets used:
  - DEC-UPPA .. DEC-UPPZ (26 sprites) — uppercase calligraphic letters
  - DEC-LOWA .. DEC-LOWZ (26 sprites) — lowercase calligraphic letters
  - DEC-SQIG (1 sprite)               — squiggle / signature flourish

Total: 53 letter-form sprites for composing the signing.

Trigger: Game enters this screen after player declares Revolution
and the Declaration sequence completes. Renders ONLY post-revolution.

Doc refs:
  - docs/SESSION_UI_CATALOG.md — DEC-* identification
  - assets/backgrounds/DECLARAT/ — bg image
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"

SCREEN_W = 320
SCREEN_H = 200


def load_decoration_letter(ch):
    """Load a DEC-LOW or DEC-UPP letter sprite."""
    from PIL import Image
    if ch.isalpha():
        if ch.isupper():
            sheet_name = f"DEC-UPP{ch}"
        else:
            sheet_name = f"DEC-LOW{ch.upper()}"
        path = ASSETS / "sprites" / sheet_name / f"{sheet_name}.SS.000.png"
        if path.exists():
            return Image.open(path).convert("RGBA")
    return None


def render_signature(canvas, name, x, y):
    """Render player's signature using DEC-* glyph sprites."""
    cur_x = x
    for ch in name:
        if ch == " ":
            cur_x += 6
            continue
        glyph = load_decoration_letter(ch)
        if glyph:
            canvas.paste(glyph, (cur_x, y), glyph)
            cur_x += glyph.size[0] + 1
        else:
            cur_x += 4


def render_declaration(state):
    from PIL import Image
    pik = ASSETS / "backgrounds" / "DECLARAT" / "DECLARAT.PIK.png"
    if pik.exists():
        canvas = Image.open(pik).convert("RGBA")
    else:
        canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (220, 200, 160, 255))

    # Player signature on the document. Per cf61be1.jpg reference, signature
    # appears below the document body, around y=150 (in 320x200 native).
    name = state.get("player_name", "Walter Raleigh")
    render_signature(canvas, name, 60, 145)

    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "screens" / "declaration_signed.png")
    ap.add_argument("--name", default="Walter Raleigh")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    canvas = render_declaration({"player_name": args.name})
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
