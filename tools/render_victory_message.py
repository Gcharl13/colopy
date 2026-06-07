#!/usr/bin/env python3
"""
render_victory_message.py — Render the end-of-revolution victory
message popup overlaid on the gameplay map.

Reference: verification/dosbox_screenshots/4de8318b...jpg

Body (real GAME.TXT-style narrative):
  "Royal Expeditionary Force annihilated! General <NAME> accepts
   surrender of all Tory forces in brief ceremony. Parliament declares
   King unfit to rule and votes to accept independence of <NATION>.
   Continental Congress proclaims <NAME> the first President of the
   new republic!"
"""
from __future__ import annotations
import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"

SCREEN_W = 320
SCREEN_H = 200

POPUP_BODY_YELLOW = (240, 200, 40)
POPUP_VAR_YELLOW  = (240, 200, 40)


def load_glyph_recolored(font_name, ascii_code, color):
    from PIL import Image
    fpath = ASSETS / "fonts" / font_name / f"{font_name}.FF.{ascii_code:03d}.png"
    if not fpath.exists():
        return None
    glyph = Image.open(fpath)
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
                    shadow = (color[0]//3, color[1]//3, color[2]//4)
                    dst[px, py] = (*shadow, 255)
    return new


def render_text(canvas, text, x, y, color, font="FONTTINY"):
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
        cur_x += glyph.size[0] + 1
    return cur_x


def render_victory_message(state):
    """Compose victory popup over the existing gameplay frame."""
    from PIL import Image, ImageDraw
    # Start from existing gameplay render
    gameplay_path = ROOT / "verification" / "gameplay" / "gameplay.png"
    if gameplay_path.exists():
        canvas = Image.open(gameplay_path).convert("RGBA")
        # Make sure it's at the native resolution; if upscaled, downscale
        if canvas.size != (SCREEN_W, SCREEN_H):
            canvas = canvas.resize((SCREEN_W, SCREEN_H), Image.LANCZOS)
    else:
        canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (60, 100, 60, 255))

    # Per DOSBox 4de8318b layout: popup at upper-middle, ~75% wide,
    # ~7 lines tall. Pixel-measured native rect:
    #   x=48..240  (192 wide)
    #   y=58..130  (72 tall)
    pw = 200
    ph = 72
    px = 50
    py = 50

    # Wood-grain background tiled
    woodpanl = ASSETS / "backgrounds" / "WOODPANL" / "WOODPANL.PIK.png"
    if woodpanl.exists():
        bg = Image.open(woodpanl).convert("RGBA")
        if bg.size[0] >= pw and bg.size[1] >= ph:
            cx = (bg.size[0] - pw) // 2
            cy = (bg.size[1] - ph) // 2
            canvas.paste(bg.crop((cx, cy, cx + pw, cy + ph)), (px, py))

    # Wood frame
    draw = ImageDraw.Draw(canvas)
    draw.rectangle([(px, py), (px + pw - 1, py + ph - 1)],
                   outline=(40, 20, 12), width=1)
    draw.rectangle([(px + 1, py + 1), (px + pw - 2, py + ph - 2)],
                   outline=(140, 90, 50), width=1)
    draw.rectangle([(px + 2, py + 2), (px + pw - 3, py + ph - 3)],
                   outline=(80, 50, 30), width=1)

    # Body text — all YELLOW per DOSBox 4de8318b (no green/yellow split).
    body_lines = state["body_lines"]
    text_x = px + 4
    text_y = py + 4
    for line in body_lines:
        # Strip the {} marks since the entire body is one color
        clean = line.replace("{", "").replace("}", "")
        render_text(canvas, clean, text_x, text_y, POPUP_BODY_YELLOW)
        text_y += 9

    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "popups" / "popup_victory.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    state = {
        "body_lines": [
            'Royal Expeditionary Force annihilated!',
            'General {Walter Raleigh} accepts surrender',
            'of all Tory forces in brief ceremony.',
            'Parliament declares King unfit to rule',
            'and votes to accept independence of',
            '{England}. Continental Congress proclaims',
            '{Walter Raleigh} the first President of',
            'the new republic!',
        ],
    }
    canvas = render_victory_message(state)
    if args.scale > 1:
        from PIL import Image
        canvas = canvas.resize((SCREEN_W * args.scale, SCREEN_H * args.scale),
                               Image.NEAREST)
    canvas.save(args.out)
    print(f"  wrote {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
