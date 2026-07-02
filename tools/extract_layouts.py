#!/usr/bin/env python3
"""extract_layouts.py -- lift the byte-cited UI geometry OUT of the specs into data.

Every spec/ui/*.md carries markdown tables of byte-verified layout facts in a
few recurring shapes:
  - element/region tables:  | Element/Region | Rect (x,y,w,h) | ... | Tier |
  - draw-chain / numbered tables: | # | element/call site | ... | @asm | ... |
This tool parses them into data_extracted/engine/layouts/<spec>.json so the
engine renders screens from extracted data -- no hand-transcription of
coordinates, and a spec correction re-extracts straight into the UI.

Each row is kept LOSSLESSLY: {name, rect:[x,y,w,h]|null, rect_raw, cols:{...}}
where cols maps every table header to its cleaned cell text. A rect is parsed
only when the cell carries a literal (x, y, w, h) tuple; formulas like
"x=147+slot*12" stay raw -- the renderer decides; nothing is invented.

Usage: python3 tools/extract_layouts.py   (writes layouts/*.json + a summary)
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = "data_extracted/engine/layouts"

RECT = re.compile(r"\((\d+),\s*(\d+),\s*(\d+),\s*(\d+)\)")
MD = re.compile(r"\*\*|`")            # strip markdown emphasis/code marks


def cells(line):
    return [c.strip() for c in line.strip().strip("|").split("|")]


def clean(s):
    return MD.sub("", s).strip()


def classify(hdr):
    h = [x.lower() for x in hdr]
    if any(("element" in c or "region" in c) for c in h) and any("rect" in c for c in h):
        return "elements"
    if h and h[0] in ("#", "step") :
        return "draw_order"
    return None


def parse_file(path):
    lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
    doc = {"source": os.path.relpath(path, ROOT), "elements": [], "draw_order": []}
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.lstrip().startswith("|") and i + 1 < len(lines) \
           and set(lines[i + 1].replace("|", "").strip()) <= set("-: ") \
           and lines[i + 1].lstrip().startswith("|"):
            hdr = cells(line)
            kind = classify(hdr)
            if kind:
                # which column holds the rect (any header mentioning rect; else scan all)
                rect_col = next((k for k, h in enumerate(hdr) if "rect" in h.lower()), None)
                j = i + 2
                while j < len(lines) and lines[j].lstrip().startswith("|"):
                    row = cells(lines[j])
                    row += [""] * (len(hdr) - len(row))
                    scan = [row[rect_col]] if rect_col is not None else row
                    m = next((RECT.search(c) for c in scan if RECT.search(c)), None)
                    doc[kind].append({
                        "name": clean(row[1] if kind == "draw_order" and len(row) > 1 else row[0]),
                        "rect": [int(g) for g in m.groups()] if m else None,
                        "rect_raw": clean(row[rect_col]) if rect_col is not None else "",
                        "cols": {clean(h): clean(v) for h, v in zip(hdr, row)},
                    })
                    j += 1
                i = j
                continue
        i += 1
    return doc


def main():
    os.chdir(ROOT)
    os.makedirs(OUT, exist_ok=True)
    total_e = total_d = files = 0
    for fn in sorted(os.listdir("spec/ui")):
        if not fn.endswith(".md"):
            continue
        doc = parse_file(os.path.join("spec/ui", fn))
        if not doc["elements"] and not doc["draw_order"]:
            continue
        out = os.path.join(OUT, fn[:-3] + ".json")
        with open(out, "w", encoding="utf-8") as f:
            json.dump(doc, f, indent=1, sort_keys=True)
        ne, nd = len(doc["elements"]), len(doc["draw_order"])
        nr = sum(1 for e in doc["elements"] if e["rect"])
        print(f"{out}: {ne} elements ({nr} literal rects), {nd} draw/step rows")
        total_e += ne; total_d += nd; files += 1
    print(f"-- {files} layout files, {total_e} elements, {total_d} draw/step rows extracted")
    return 0


if __name__ == "__main__":
    sys.exit(main())
