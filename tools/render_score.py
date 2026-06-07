#!/usr/bin/env python3
"""
render_score.py — Render the end-of-game COLONIZATION SCORE screen.

Pixel-verified composition (per f8997b67...jpg DOSBox screenshot):
  - WOODTILE.SS tiled full-screen (wood-grain background)
  - Title (y~5): "COLONIZATION SCORE" yellow FONTTINY centered
    -- LABELS.TXT @MISC line 129
  - Subtitle (y~13): "Explorer <NAME> of the <NATION>:  <Season> <Year>"
  - "<NATION> Citizens:  +<N>" green FONTTINY left-aligned
    -- LABELS.TXT @MISC line 130 ("Citizens")
  - LONG colonist parade (~40 sprite row) showing units accumulated
    -- ICONS.SS unit sprites (slot 95+ for selected/highlighted variants)
  - "<NATION> Continental Congress: +<N>" green FONTTINY
    -- LABELS.TXT @MISC line 149 ("Continental Congress")
  - 4-column FF list (~13 fathers in ~4 rows)
    -- NAMES.TXT @FATHERS — order matches CC-NN portrait sprite indices
  - Bottom-half stats in 2 columns (left: Gold/Rebel/Liberty/Total;
    right: Villages/Revolution/Independence)
    -- LABELS.TXT @MISC ("Villages Burned" line 132,
       "Independence" line 131, "Total Score" line 136)
  - Bottom: GREEN progress bar (full at 100%)
  - 24 SCORE01..SCORE24 panel sprites correspond to score-line
    icons; each panel illustrates one scoring category with
    period-appropriate or anachronistic art (see
    docs/SESSION_UI_CATALOG.md)

Memory addresses for live values:
  - PowerRecord +0x14 = founding_father_count
  - PowerRecord +0x02 = rebel_sentiment_pct
  - PowerRecord +0x0C = bells_lifetime
  - PowerRecord +0x2A = gold (treasury)
  - DGROUP 0x372     = score (total)

Doc refs:
  - docs/RENDERER_GEOMETRY.md — pixel positions
  - docs/SESSION_UI_CATALOG.md — sprite identification
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

TITLE_YELLOW = (200, 160, 24)
BODY_GREEN   = (96, 168, 60)


SAMPLE_STATE = {
    "title_year":    1582,
    "title_season": "Spring",
    "leader_name":  "Walter Raleigh",
    "leader_class": "Explorer",
    "nation_full":  "England",
    "citizens":     276,
    "founding_fathers": [
        "Francisco Coronado", "Henry Hudson", "Hernan Cortes", "Paul Revere",
        "Francis Drake", "Thomas Jefferson", "Pocahontas", "Thomas Paine",
        "Benjamin Franklin", "William Brewster", "William Penn", "Jean de Brebeuf",
        "Juan de Sepulveda",
    ],
    "parade_units": [  # ICONS.SS frame indices for the parade row
        # Mix of free colonists, soldiers, dragoons (on horseback),
        # indentured servants. Per FFs accumulated; ~40 entries.
        95, 99, 100, 103, 95, 99, 100, 103,
        95, 99, 100, 103, 95, 99, 100, 103,
        95, 99, 100, 103, 95, 99, 100, 103,
        95, 99, 100, 103, 95, 99, 100, 103,
        95, 99, 100, 103, 95, 99, 100, 103,
    ],
    # 2 columns × 4 rows of (label, value) tuples
    "stats_left": [
        ("Gold:",            "(419,692) +419"),
        ("Rebel Sentiment:", "+71"),
        ("Liberty Bells:",   "+32"),
        ("Total Score:",     "2526"),
    ],
    "stats_right": [
        ("17 Villages Burned:",          "-34"),
        ("Early Revolution (Spring 1582):", "+434"),
        ("Independence Achieved:",       "+100%"),
    ],
    "rating_pct": 100,  # final progress bar fill 0..100
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


def render_score(state):
    from PIL import Image, ImageDraw
    canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (0, 0, 0, 255))

    # WOODTILE background full screen
    woodtile = ASSETS / "sprites" / "WOODTILE" / "WOODTILE.SS.000.png"
    if woodtile.exists():
        wood = Image.open(woodtile).convert("RGBA")
        wt_w, wt_h = wood.size
        for ty in range(0, SCREEN_H, max(wt_h, 1)):
            for tx in range(0, SCREEN_W, max(wt_w, 1)):
                canvas.paste(wood, (tx, ty), wood)

    # Title centered (y=2)
    title = "COLONIZATION SCORE"
    tw = measure_text(title)
    render_text(canvas, title, (SCREEN_W - tw) // 2, 2, TITLE_YELLOW)

    # Subtitle (y=10)
    subtitle = (f"{state['leader_class']} {state['leader_name']} "
                f"of the {state['nation_full']}:  "
                f"{state['title_season']} {state['title_year']}")
    sw = measure_text(subtitle)
    render_text(canvas, subtitle, (SCREEN_W - sw) // 2, 10, TITLE_YELLOW)

    # "<NATION> Citizens: +N" (y=20)
    nation_first = state['nation_full'].split()[0]
    citizens_line = f"{nation_first} Citizens:  +{state['citizens']}"
    render_text(canvas, citizens_line, 4, 20, BODY_GREEN)

    # Parade row (y=29..51) — sprite size ~16px wide each, 8x4 = ~40 sprites in row
    icons_dir = ASSETS / "sprites" / "ICONS"
    px_x = 4
    px_y = 29
    for unit_idx in state["parade_units"]:
        sprite_png = icons_dir / f"ICONS.SS.{unit_idx:03d}.png"
        if sprite_png.exists():
            sprite = Image.open(sprite_png).convert("RGBA")
            if px_x + sprite.size[0] > SCREEN_W - 4:
                break
            canvas.paste(sprite, (px_x, px_y), sprite)
            px_x += max(sprite.size[0] - 1, 1)  # slight overlap

    # "<NATION> Continental Congress: +N" (y=53)
    cc_line = f"{nation_first} Continental Congress: +85"
    render_text(canvas, cc_line, 4, 53, BODY_GREEN)

    # 4-column Founding Fathers list (y=63..95). DOSBox uses ~80px
    # columns BUT names are truncated/abbreviated so they fit. Use 4
    # explicit column x positions matching DOSBox layout.
    ff_y = 63
    col_x = [4, 90, 168, 248]
    line_h = 8
    for i, name in enumerate(state["founding_fathers"][:13]):
        col = i % 4
        row = i // 4
        cy = ff_y + row * line_h
        # Truncate name if it would overflow next column
        name_w = measure_text(name)
        max_w = (col_x[col + 1] - col_x[col] - 4) if col < 3 else (SCREEN_W - col_x[col] - 4)
        # If name too long, drop characters from end until it fits
        rendered_name = name
        while measure_text(rendered_name) > max_w and len(rendered_name) > 4:
            rendered_name = rendered_name[:-1]
        render_text(canvas, rendered_name, col_x[col], cy, BODY_GREEN)

    # Stats — 2 columns at bottom (y=130..170). Per DOSBox layout:
    # Left column x=4..150, Right column x=156..316.
    # Each row: label + value, value right-aligned within its half-width.
    stats_y = 130
    line_h = 10
    LEFT_LABEL_X = 4
    LEFT_VALUE_X = 80     # value column starts here in the left half
    RIGHT_LABEL_X = 156
    RIGHT_VALUE_X = 260   # value column starts here in the right half
    for i, (label, val) in enumerate(state["stats_left"]):
        sy = stats_y + i * line_h
        render_text(canvas, label, LEFT_LABEL_X, sy, BODY_GREEN)
        render_text(canvas, str(val), LEFT_VALUE_X, sy, BODY_GREEN)
    for i, (label, val) in enumerate(state["stats_right"]):
        sy = stats_y + i * line_h
        render_text(canvas, label, RIGHT_LABEL_X, sy, BODY_GREEN)
        # Right-align value at end of right half
        vw = measure_text(str(val))
        render_text(canvas, str(val), SCREEN_W - 6 - vw, sy, BODY_GREEN)

    # Final progress bar at bottom (y=190..196)
    draw = ImageDraw.Draw(canvas)
    bar_y = 190
    bar_h = 6
    bar_pct = state.get("rating_pct", 100) / 100.0
    bar_w = int((SCREEN_W - 8) * bar_pct)
    # Bar outline (dark green)
    draw.rectangle([(2, bar_y), (SCREEN_W - 4, bar_y + bar_h)],
                   outline=(40, 80, 30), fill=(40, 80, 30))
    # Bar fill (bright green)
    if bar_w > 0:
        draw.rectangle([(4, bar_y + 1), (4 + bar_w, bar_y + bar_h - 1)],
                       fill=(96, 168, 60))

    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "screens" / "score.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    canvas = render_score(SAMPLE_STATE)
    if args.scale > 1:
        from PIL import Image
        canvas = canvas.resize((SCREEN_W * args.scale, SCREEN_H * args.scale),
                               Image.NEAREST)
    canvas.save(args.out)
    print(f"  wrote {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
