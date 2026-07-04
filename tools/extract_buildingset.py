#!/usr/bin/env python3
"""Crop the colony building sprites from the committed BUILDING contact sheet.

docs/atlas/sprites/atlas_BUILDING.png is a labeled contact sheet in the same family
as the ICONS/PHYS0 sheets: a 16-column grid at 58px pitch, with row bands separated
at y=24,81,139,197 (3 bands -> 48 frames, matching BUILDING.SS = 48 building frames,
formats/SS.md). Each cell has a small index label at the band top and a building
sprite below it, drawn on an opaque black key (the sheet baked transparency to black,
like atlas_PHYS0).

SCALE (measured 2026-07-04): unlike atlas_ICONS (a clean 2x pixel-double, parity
blockiness 1.000), the BUILDING cells are drawn at NATIVE 1x -- the frame-9 Town
Hall window pixel-matches the live capture docs/screens/colony_live_1505.png at
1:1 (a building ~52x41; halving it was the earlier bug that shrank every building
to half size). So each frame is lifted as the FULL 56x42 content window, unscaled
and untrimmed: the sprite's position inside the window carries the .SS frame's own
draw offset (capture-calibrated: the window's top-left sits at the plot table's
raw (x,y) -- the renderer must NOT add the +8 y bias on top of these windows).

Frame semantics: the decoded-bundle cell N == @BUILDING def_id N (0-based; cell 0
IS the Stockade, USER-VERIFIED). The EXE selects `def_id + 1` in EXE-sheet space,
but the ssdec decode is off-by-one from it (ssdec[K] = game[K+1],
spec/ui/colony_screen.md 0.2), so the two cancel: this strip is indexed directly
by def_id. buildings.json records the layout.

Blank cells stay fully transparent (a renderer's present-gate skips them). Same
black-key approximation caveat as phys0/units. Needs Pillow only to regenerate;
the runtime just serves the committed PNG.

Usage: tools/extract_buildingset.py
"""
import json
import os
from PIL import Image

SRC = "docs/atlas/sprites/atlas_BUILDING.png"
OUT_DIR = "data_extracted/tileset"
PITCH = 58
SEPS = [24, 81, 139, 197]          # 3 row bands; last entry = band-3 bottom
LABEL_SKIP = 14                     # px of index-label strip at each band top
CELL_W, CELL_H = 56, 42            # native 1x content window per cell
N = 48


def main():
    im = Image.open(SRC).convert("RGB")
    W, H = im.size
    strip = Image.new("RGBA", (N * CELL_W, CELL_H), (0, 0, 0, 0))
    drawn = 0
    for f in range(N):
        col, row = f % 16, f // 16
        x0 = col * PITCH + 1
        y0 = SEPS[row] + LABEL_SKIP
        cell = im.crop((x0, y0, min(x0 + CELL_W, W),
                        min(y0 + CELL_H, SEPS[row + 1] - 1))).convert("RGBA")
        px = cell.load()
        ink = 0
        for y in range(cell.height):
            for x in range(cell.width):
                r, g, b, _ = px[x, y]
                if r + g + b <= 24:
                    px[x, y] = (0, 0, 0, 0)   # black key -> transparent
                else:
                    ink += 1
        if ink < 16:
            continue                            # genuinely blank frame
        strip.paste(cell, (f * CELL_W, 0), cell)
        drawn += 1
    os.makedirs(OUT_DIR, exist_ok=True)
    strip.save(os.path.join(OUT_DIR, "buildings.png"))
    meta = {"cell_w": CELL_W, "cell_h": CELL_H, "count": N, "drawn": drawn,
            "source": SRC, "note": "strip cell N = @BUILDING def_id N (0-based; cell 0 = Stockade, "
            "USER-VERIFIED). EXE draws def_id+1 in EXE-sheet space; the ssdec decode is off-by-one "
            "from it so they cancel (spec/ui/colony_screen.md 0.2). Cells are the FULL 56x42 native "
            "1x window (atlas_BUILDING is NOT 2x); the in-window sprite position is the frame's own "
            "draw offset, so blit windows at the raw plot (x,y) with no extra +8 "
            "(capture-calibrated vs docs/screens/colony_live_1505.png)."}
    with open(os.path.join(OUT_DIR, "buildings.json"), "w") as fh:
        json.dump(meta, fh, indent=2)
    print(f"wrote {OUT_DIR}/buildings.png ({strip.size[0]}x{strip.size[1]}, "
          f"{drawn}/{N} frames) + buildings.json")


if __name__ == "__main__":
    main()
