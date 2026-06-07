#!/usr/bin/env python3
"""
render_title.py — Render the Sid Meier's Colonization title screen
(OPENING.PIK at native 320x200).
"""
from __future__ import annotations
import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"
SCREEN_W = 320
SCREEN_H = 200


def render_title():
    from PIL import Image
    pik = ASSETS / "backgrounds" / "OPENING" / "OPENING.PIK.png"
    if pik.exists():
        canvas = Image.open(pik).convert("RGBA")
        if canvas.size != (SCREEN_W, SCREEN_H):
            canvas = canvas.resize((SCREEN_W, SCREEN_H), Image.LANCZOS)
    else:
        canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (0, 0, 0, 255))
    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "screens" / "title.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    canvas = render_title()
    if args.scale > 1:
        from PIL import Image
        canvas = canvas.resize((SCREEN_W * args.scale, SCREEN_H * args.scale),
                               Image.NEAREST)
    canvas.save(args.out)
    print(f"  wrote {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
