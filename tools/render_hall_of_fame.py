#!/usr/bin/env python3
"""
render_hall_of_fame.py — Render the Colonization Rating / Hall of Fame
"things named after you" screen.

Reference: verification/dosbox_screenshots/ae4f47d9...jpg

Composition:
  - WOODTILE.SS background tiled full-screen (wood-grain panel)
  - Top: "COLONIZATION RATING: 632" yellow FONTTINY, centered
  - Subtitle: "In memory of your deeds, the citizens of <NATION>
    give your name to . . ."
  - Left half: a framed scene illustration (one of WDCUT01..13)
    + caption "<NATION> Bay" or similar
  - Right half: yellow FONTTINY list of items named after the player
    (LABELS.TXT @MISC entries)

LABELS.TXT @MISC (already verified) provides the canonical name list:
  An Inland Sea, A Mountain Range, A University, A River,
  A Prestigious Award, A Mountain Lion, A College, A Bird,
  A Bridge, An Apple, A School, A Flower, A Street,
  A Fast Food Chain, A Prison, A Venomous Snake,
  A Poisonous Plant, A Stinging Insect, An Infectious Disease
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
BODY_YELLOW = (200, 160, 24)


SAMPLE_STATE = {
    "rating": 632,
    "nation_full": "England",
    "scene_caption": "England Bay",
    # The DOSBox HoF screen shows a generic landscape (canyon/cliffs/river)
    # in the framed picture. Use WDCUT08 (tropical jungle, contains the
    # most landscape scenery without a dominant figure).
    "wdcut_index": 8,
    # LABELS.TXT @MISC items the citizens name after the player.
    # Ranked positive -> negative depending on rating.
    "named_items": [
        "An Inland Sea", "A Mountain Range", "A University",
        "A River", "A Prestigious Award", "A Mountain Lion",
        "A College", "A Bird", "A Bridge", "An Apple",
        "A School", "A Flower", "A Street",
        "A Fast Food Chain", "A Prison", "A Venomous Snake",
        "A Poisonous Plant", "A Stinging Insect", "An Infectious Disease",
    ],
}


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


def render_hall_of_fame(state):
    from PIL import Image, ImageDraw
    canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (40, 25, 15, 255))

    # Tile WOODTILE
    woodtile = ASSETS / "sprites" / "WOODTILE" / "WOODTILE.SS.000.png"
    if woodtile.exists():
        wood = Image.open(woodtile).convert("RGBA")
        wt_w, wt_h = wood.size
        for ty in range(0, SCREEN_H, max(wt_h, 1)):
            for tx in range(0, SCREEN_W, max(wt_w, 1)):
                canvas.paste(wood, (tx, ty), wood)

    # Title
    title = f"COLONIZATION RATING: {state['rating']}"
    tw = measure_text(title)
    render_text(canvas, title, (SCREEN_W - tw) // 2, 2, TITLE_YELLOW)

    # Subtitle (two lines centered)
    sub1 = "In memory of your deeds, the citizens of"
    sub2 = f"{state['nation_full']} give your name to . . ."
    s1w = measure_text(sub1)
    s2w = measure_text(sub2)
    render_text(canvas, sub1, (SCREEN_W - s1w) // 2, 11, TITLE_YELLOW)
    render_text(canvas, sub2, (SCREEN_W - s2w) // 2, 19, TITLE_YELLOW)

    # Left half: framed scene illustration + caption
    wdcut_idx = state.get("wdcut_index", 5)
    wdcut_path = ASSETS / "sprites" / f"WDCUT{wdcut_idx:02d}" / f"WDCUT{wdcut_idx:02d}.SS.000.png"
    if wdcut_path.exists():
        scene = Image.open(wdcut_path).convert("RGBA")
        # Place left, centered vertically below subtitle
        sx = 20
        sy = 38
        canvas.paste(scene, (sx, sy), scene)
        # Wood frame border
        draw = ImageDraw.Draw(canvas)
        sw, sh = scene.size
        draw.rectangle([(sx-2, sy-2), (sx+sw+1, sy+sh+1)],
                       outline=(80, 50, 30), width=1)
        # Caption below
        cap = state.get("scene_caption", "")
        cw = measure_text(cap)
        render_text(canvas, cap, sx + (sw - cw) // 2, sy + sh + 4, BODY_YELLOW)

    # Right half: list of named items (yellow FONTTINY).
    # Per DOSBox ae4f47d9 layout, the list is CENTERED in the right
    # half (not right-aligned). Right half spans x=160..320.
    list_y = 36
    line_h = 8
    right_center = SCREEN_W // 2 + (SCREEN_W // 2) // 2  # x=240
    for i, item in enumerate(state["named_items"]):
        if list_y + i * line_h > SCREEN_H - 6:
            break
        iw = measure_text(item)
        render_text(canvas, item, right_center - iw // 2,
                    list_y + i * line_h, BODY_YELLOW)

    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "screens" / "hall_of_fame.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    canvas = render_hall_of_fame(SAMPLE_STATE)
    if args.scale > 1:
        from PIL import Image
        canvas = canvas.resize((SCREEN_W * args.scale, SCREEN_H * args.scale),
                               Image.NEAREST)
    canvas.save(args.out)
    print(f"  wrote {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
