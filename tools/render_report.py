#!/usr/bin/env python3
"""
render_report.py — Render an advisor report screen.

The 9 REPORT*.PIK backgrounds are pre-rendered orange-toned illustrations
of game scenes (settlements, native warriors, explorers, etc.). The report
overlay shows:
  - Title at top: "<TYPE> ADVISER REPORT" in yellow FONTTINY
  - Body content (statistics list) in green FONTTINY
  - Sometimes a list of items per advisor

Per LABELS.TXT, the reports are:
  REPORT1: Indian Adviser
  REPORT2: Religious Adviser
  REPORT3: Labor Adviser
  REPORT4: Economic Adviser
  REPORT5: Colony Adviser
  REPORT6: Naval Adviser
  REPORT7: Foreign Affairs
  REPORT8: ?
  REPORT9: ?
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


# Pixel-verified visual content of each REPORT*.PIK background:
#   REPORT1 — Indian on coast with rifle  → INDIAN ADVISER
#   REPORT2 — Priest preaching in church  → RELIGIOUS ADVISER
#   REPORT3 — Two figures at desk         → LABOR ADVISER (clerks managing workforce)
#   REPORT4 — Pioneers building colony    → COLONY ADVISER (settlement scene)
#   REPORT5 — Scales of justice + scrolls → ECONOMIC ADVISER (commerce)
#   REPORT6 — Aerial view of fort/colony  → CONTINENTAL CONGRESS (collective view)
#   REPORT7 — Galleon under sail          → NAVAL ADVISER
#   REPORT8 — Map with diplomatic stamp   → FOREIGN AFFAIRS ADVISER
#   REPORT9 — duplicate / fallback        → INDIAN alt
#
# Each tuple: (title, body_lines, pik_num).
# pik_num is the REPORT*.PIK file index, decoupled from the dict key.
REPORTS = {
    1: ("INDIAN ADVISER REPORT", [
        "Sioux: Worried",
        "Cherokee: Friendly",
        "Apache: Hostile",
        "Iroquois: Friendly",
        "Aztec: Wary",
        "Inca: Hostile",
        "Tupi: Worried",
        "Arawak: Friendly",
    ], 1),
    2: ("RELIGIOUS ADVISER REPORT", [
        "Active Missions: 5",
        "Converted Natives: 87",
        "Crosses Built: +12",
        "",
        "Most successful mission:",
        "Boston, +24 conversions",
    ], 2),
    3: ("LABOR ADVISER REPORT", [
        "Total Population: 276",
        "Free Colonists: 142",
        "Indentured Servants: 89",
        "Petty Criminals: 12",
        "Veteran Soldiers: 33",
        "",
        "Production Bottleneck:",
        "  Tools (-150 unfilled)",
    ], 3),
    4: ("ECONOMIC ADVISER REPORT", [
        "Treasury: 4,019,692 gold",
        "Annual Income: +84,231",
        "Expenses: -23,401",
        "Net: +60,830",
        "",
        "Top Export: Cigars (+12,456)",
        "Top Import: Tools (-3,201)",
    ], 5),  # REPORT5 = scales of justice
    5: ("COLONY ADVISER REPORT", [
        "Total Colonies: 14",
        "Population: 276",
        "Liberty Bells: +32",
        "Sons of Liberty: 95%",
        "",
        "Largest: Baltimore (24)",
        "Smallest: Roanoke (4)",
    ], 4),  # REPORT4 = pioneers at colony
    6: ("NAVAL ADVISER REPORT", [
        "Caravels: 4",
        "Merchantmen: 2",
        "Galleons: 1",
        "Frigates: 0",
        "Privateers: 1",
        "",
        "In Europe: 2 / In Port: 5",
    ], 7),  # REPORT7 = galleon under sail
    7: ("FOREIGN AFFAIRS REPORT", [
        # Player nation appears as "ourselves"; the four NAMES.TXT
        # @COUNTRY entries are England/France/Spain/Netherlands. Sample
        # state assumes player = England.
        "England: ourselves",
        "France: at Peace",
        "Spain: at Peace",
        "Netherlands: at Peace",
        "",
        "King's Popularity: -23",
    ], 8),  # REPORT8 = map with diplomatic stamp
    8: ("CONTINENTAL CONGRESS ACTIVITIES", [
        # LABELS.TXT @MISC line 52 = "CONTINENTAL CONGRESS ACTIVITIES".
        "Now debating: Adam Smith",
        "",
        "Liberty Bells needed: 240",
        "Bells produced this turn: +18",
        "",
        "Sons of Liberty: 95%",
    ], 6),  # REPORT6 = aerial fort/colony view
}


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


def render_report(report_num, custom_state=None):
    from PIL import Image, ImageDraw
    title, body_lines, pik_num = REPORTS.get(
        report_num, (f"REPORT {report_num}", [], report_num))
    pik = ASSETS / "backgrounds" / f"REPORT{pik_num}" / f"REPORT{pik_num}.PIK.png"
    if pik.exists():
        canvas = Image.open(pik).convert("RGBA")
    else:
        canvas = Image.new("RGBA", (SCREEN_W, SCREEN_H), (200, 100, 50, 255))

    if custom_state:
        title = custom_state.get("title", title)
        body_lines = custom_state.get("body", body_lines)

    # Translucent dark background behind text for legibility
    draw = ImageDraw.Draw(canvas, "RGBA")
    text_x = 4
    text_w = 160
    text_h = 12 + len(body_lines) * 9 + 8
    draw.rectangle([(text_x - 2, 4), (text_x + text_w, 4 + text_h)],
                   fill=(40, 25, 10, 200))

    # Title
    title_y = 6
    title_w = measure_text(title, "FONTTINY")
    render_text(canvas, title, text_x + (text_w - title_w) // 2, title_y,
                TITLE_YELLOW, "FONTTINY")

    # Body lines
    body_y = title_y + 11
    for line in body_lines:
        render_text(canvas, line, text_x + 2, body_y, BODY_GREEN, "FONTTINY")
        body_y += 9

    return canvas.convert("RGB")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--report", type=int, default=4,
                    help="Report number (1-9)")
    ap.add_argument("--all", action="store_true",
                    help="Render all reports")
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "screens" / "report_economic.png")
    ap.add_argument("--scale", type=int, default=4)
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)

    def write(canvas, out_path):
        if args.scale > 1:
            from PIL import Image
            canvas = canvas.resize(
                (SCREEN_W * args.scale, SCREEN_H * args.scale),
                Image.NEAREST,
            )
        canvas.save(out_path)

    if args.all:
        for n in range(1, 9):
            canvas = render_report(n)
            out = args.out.parent / f"report{n}_overlay.png"
            write(canvas, out)
            print(f"  rendered report{n}_overlay -> {out}")
    else:
        canvas = render_report(args.report)
        write(canvas, args.out)
        print(f"  wrote {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
