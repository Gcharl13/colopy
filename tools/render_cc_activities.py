#!/usr/bin/env python3
"""
render_cc_activities.py — Render the Continental Congress Activities
report screen.

GROUND TRUTH: session_1777952458/frames/1310124562000000.webp
Renderer geometry spec: docs/RENDERER_GEOMETRY.md
Memory layout: docs/DATA_MODEL.md
Sprite identification: docs/SESSION_UI_CATALOG.md

Composition (verified frame 1310124562):
  - CCBKGD.PIK background (orange-toned scene with white-wigged
    figure at writing desk)
  - Title: "CONTINENTAL CONGRESS ACTIVITIES" — LABELS.TXT @MISC line 52
  - Body labels (yellow / FONTKING for title, FONTSMAL for body):
      Line 1: "Next Continental Congress Session: (<FF name>)
              (NN in MM)"  — bells_remaining in threshold
      Progress bar (yellow fill on dark frame)
      Line 2: "Rebel Sentiment: NN%   Tory Sentiment: MM%"
      Bell-sprite array (one per bells_per_turn)
      Line 3: "<NATION> Expeditionary Force:"
      4 sprite groups: Regulars / Cavalry / Artillery / Man-O-War
      Line 4: "Founding Fathers:" + acquired list
  - "OK" red button bottom-right corner

Field-level memory citations:
  - rebel_pct        = PowerRecord[+0x02] byte
  - bells_per_turn   = PowerRecord[+0x0E] u16
  - bells_lifetime   = PowerRecord[+0x0C] u16  (accumulated total)
  - ff_count         = PowerRecord[+0x14] u16  (number acquired)
  - ref_regulars     = DGROUP[+0x53DA] u16
  - ref_cavalry      = DGROUP[+0x53DC] u16
  - ref_man_o_war    = DGROUP[+0x53DE] u16  (slot 2)
  - ref_artillery    = DGROUP[+0x53E0] u16  (slot 3, NOT slot 2!)
  - king_anger       = DGROUP[+0x53A7] byte (separate from bells)
  - boycott_bitfield = PowerRecord[+0x20] u16

Display arithmetic for progress bar:
  displayed_progress = next_ff_threshold - (bells_lifetime - sum(prev_FF_costs))
  In session frame: bells_lifetime=99, prev FF (Adam Smith) cost ~69,
  next FF (William Brewster) threshold=129 → display "30 in 129"
"""
from __future__ import annotations
import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"

SCREEN_W = 320
SCREEN_H = 200

# LABELS.TXT @MISC line 52: "CONTINENTAL CONGRESS ACTIVITIES"
TITLE = "CONTINENTAL CONGRESS ACTIVITIES"

# Color palette (from CCBKGD.PIK + frame 1310124562 inspection)
TITLE_YELLOW = (200, 160, 24)   # FONTKING title color
LABEL_YELLOW = (200, 160, 24)   # FONTSMAL section labels
BAR_RED = (200, 60, 60)         # Rebel sentiment bar
BAR_BLUE = (60, 120, 200)       # Tory sentiment bar
BAR_FILL_YELLOW = (200, 160, 24)  # FF progress bar fill


# SAMPLE_STATE — exact values from frame 1310124562 (Spring 1543, English player)
# All values verified against memory snapshot at that timestamp.
SAMPLE_STATE = {
    "next_ff_name": "William Brewster",        # NAMES.TXT @FATHERS[20]
    "next_ff_remaining": 30,                   # bells still needed
    "next_ff_threshold": 129,                  # cost for William Brewster
    "rebel_pct": 13,                           # PowerRecord[+0x02] = 13
    "tory_pct": 87,                            # 100 - rebel
    "nation_full": "English",                  # NAMES.TXT @NATIONALITY[0]
    "bells_per_turn": 7,                       # PowerRecord[+0x0E] = 7
    # REF order in 0x53DA matches what THIS screen displays:
    # Regulars / Cavalry / Artillery / Man-O-War (the screen reorders
    # the slot-2/3 swap so display order != memory order)
    "exp_force": {
        "regulars":  23,                       # DGROUP[+0x53DA]
        "cavalry":   10,                       # DGROUP[+0x53DC]
        "artillery":  8,                       # DGROUP[+0x53E0]  <-- slot 3!
        "ships":      5,                       # DGROUP[+0x53DE]  <-- slot 2!
    },
    "acquired_fathers": ["Adam Smith"],        # PowerRecord[+0x14] = 1 (only Smith)
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


def measure_text(text, font="FONTTINY"):
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
            total += g.size[0] + 1
        else:
            total += 4
    return total


def render_bar(canvas, x, y, w, h, fill_color, fill_pct):
    from PIL import ImageDraw
    draw = ImageDraw.Draw(canvas)
    # Outer outline
    draw.rectangle([(x, y), (x + w, y + h)], outline=(40, 25, 10))
    # Fill
    fw = int(w * fill_pct / 100)
    if fw > 0:
        draw.rectangle([(x + 1, y + 1), (x + fw, y + h - 1)], fill=fill_color)


def render_cc_activities(state):
    from PIL import Image, ImageDraw
    # Use REPORT3.PIK as a fallback orange-toned background
    pik = ASSETS / "backgrounds" / "REPORT3" / "REPORT3.PIK.png"
    if pik.exists():
        canvas = Image.open(pik).convert("RGBA")
        if canvas.size != (SCREEN_W, SCREEN_H):
            canvas = canvas.resize((SCREEN_W, SCREEN_H), Image.LANCZOS)
    else:
        canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (220, 160, 100, 255))

    # Title centered at top
    tw = measure_text(TITLE)
    render_text(canvas, TITLE, (SCREEN_W - tw) // 2, 2, TITLE_YELLOW)

    y = 14
    # Next Continental Congress Session
    render_text(canvas, f"Next Continental Congress Session:  ({state['next_ff_name']})",
                4, y, LABEL_YELLOW)
    y += 10
    pct = int(100 * state['next_ff_progress'] / max(state['next_ff_max'], 1))
    render_bar(canvas, 4, y, SCREEN_W - 8, 6, (200, 160, 24), pct)
    # Numeric overlay on bar
    render_text(canvas, str(state['next_ff_progress']), 6, y - 1, (40, 25, 10))
    render_text(canvas, str(state['next_ff_max']),
                SCREEN_W - 4 - measure_text(str(state['next_ff_max'])),
                y - 1, (40, 25, 10))
    y += 12

    # Rebel + Tory sentiment
    render_text(canvas,
                f"Rebel Sentiment: {state['rebel_pct']}%   Tory Sentiment: {state['tory_pct']}%",
                4, y, LABEL_YELLOW)
    y += 10
    # Two horizontal bars side by side
    half = (SCREEN_W - 12) // 2
    render_bar(canvas, 4, y, half, 6, BAR_RED, state['rebel_pct'])
    render_bar(canvas, 8 + half, y, half, 6, BAR_BLUE, state['tory_pct'])
    y += 12

    # Expeditionary Force
    render_text(canvas, f"{state['nation_full']} Expeditionary Force:",
                4, y, LABEL_YELLOW)
    y += 10
    # Show counts in 4 columns
    ef = state['exp_force']
    col_w = SCREEN_W // 4
    for i, (label, val) in enumerate([
        ("Regulars", ef['regulars']),
        ("Cavalry", ef['cavalry']),
        ("Artillery", ef['artillery']),
        ("Ships", ef['ships']),
    ]):
        cx = i * col_w + 4
        render_text(canvas, f"{val} {label}", cx, y, LABEL_YELLOW)
    y += 12

    # Founding Fathers list
    render_text(canvas, "Founding Fathers:", 4, y, LABEL_YELLOW)
    y += 10
    fl_x = 4
    for name in state['acquired_fathers']:
        nw = measure_text(name)
        if fl_x + nw > SCREEN_W - 4:
            fl_x = 4
            y += 8
        render_text(canvas, name, fl_x, y, LABEL_YELLOW)
        fl_x += nw + 12

    # OK button bottom-right
    ok_x = SCREEN_W - 22
    ok_y = SCREEN_H - 12
    draw = ImageDraw.Draw(canvas)
    draw.rectangle([(ok_x - 2, ok_y - 1), (ok_x + 14, ok_y + 7)],
                   outline=(40, 25, 10))
    render_text(canvas, "OK", ok_x, ok_y, TITLE_YELLOW)

    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "screens" / "cc_activities.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    canvas = render_cc_activities(SAMPLE_STATE)
    if args.scale > 1:
        from PIL import Image
        canvas = canvas.resize((SCREEN_W * args.scale, SCREEN_H * args.scale),
                               Image.NEAREST)
    canvas.save(args.out)
    print(f"  wrote {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
