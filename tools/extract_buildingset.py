#!/usr/bin/env python3
"""Crop the colony building sprites from the committed BUILDING contact sheet.

docs/atlas/sprites/atlas_BUILDING.png is a labeled contact sheet in the same family
as the ICONS/PHYS0 sheets: a 16-column grid at 58px pitch, with row bands separated
at y=24,81,139,197 (3 bands -> 48 frames, matching BUILDING.SS = 48 building frames,
formats/SS.md). Each cell has a small index label at the band top and a building
sprite below it, drawn on an opaque black key (the sheet baked transparency to black,
like atlas_PHYS0).

This lifts each frame's tight sprite bbox (skipping the label strip, black -> alpha)
and centers it in a fixed CELL_W x CELL_H cell, packing all 48 into a horizontal strip
data_extracted/tileset/buildings.png (frame f at x=f*CELL_W). Frame semantics: the
decoded-bundle cell N == @BUILDING def_id N (0-based; cell 0 IS the Stockade,
USER-VERIFIED). The EXE selects `def_id + 1` in EXE-sheet space, but the ssdec decode
is off-by-one from it (ssdec[K] = game[K+1], spec/ui/colony_screen.md §0.2), so the
two cancel: this strip is indexed directly by def_id. buildings.json records the layout.

Frames 10/11/30/31 are blank in the sheet (left empty -> a renderer falls back to its
placeholder). Same black-key approximation caveat as phys0/units. Needs Pillow only to
regenerate; the runtime just serves the committed PNG.

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
CELL_W, CELL_H = 56, 48            # fits the largest building (measured 56x43)
N = 48


def sprite_bbox(px, x0, x1, y0, y1):
    xs, ys = [], []
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b = px[x, y][:3]
            if r or g or b:                 # non-black = sprite ink
                xs.append(x); ys.append(y)
    if not xs:
        return None
    return min(xs), min(ys), max(xs) + 1, max(ys) + 1


def main():
    im = Image.open(SRC).convert("RGB")
    W, _ = im.size
    px = im.load()
    strip = Image.new("RGBA", (N * CELL_W, CELL_H), (0, 0, 0, 0))
    drawn = 0
    for f in range(N):
        col, row = f % 16, f // 16
        x0, x1 = col * PITCH + 1, min(col * PITCH + PITCH - 1, W)
        bb = sprite_bbox(px, x0, x1, SEPS[row] + LABEL_SKIP, SEPS[row + 1] - 1)
        if not bb or bb[2] - bb[0] < 4 or bb[3] - bb[1] < 4:
            continue                        # blank frame
        sp = im.crop(bb).convert("RGBA")
        sp = sp.crop((0, 0, min(sp.width, CELL_W), min(sp.height, CELL_H)))  # clamp
        spx = sp.load()
        for j in range(sp.height):
            for i in range(sp.width):
                r, g, b, _ = spx[i, j]
                if r == 0 and g == 0 and b == 0:
                    spx[i, j] = (0, 0, 0, 0)            # black key -> transparent
        ox = f * CELL_W + (CELL_W - sp.width) // 2
        oy = (CELL_H - sp.height) // 2
        strip.paste(sp, (ox, oy), sp)
        drawn += 1
    os.makedirs(OUT_DIR, exist_ok=True)
    strip.save(os.path.join(OUT_DIR, "buildings.png"))
    meta = {"cell_w": CELL_W, "cell_h": CELL_H, "count": N, "drawn": drawn,
            "source": SRC, "note": "strip cell N = @BUILDING def_id N (0-based; cell 0 = Stockade, "
            "USER-VERIFIED). EXE draws def_id+1 in EXE-sheet space; the ssdec decode is off-by-one "
            "from it so they cancel (spec/ui/colony_screen.md §0.2)"}
    with open(os.path.join(OUT_DIR, "buildings.json"), "w") as fh:
        json.dump(meta, fh, indent=2)
    print(f"wrote {OUT_DIR}/buildings.png ({strip.size[0]}x{strip.size[1]}, "
          f"{drawn}/{N} frames) + buildings.json")


if __name__ == "__main__":
    main()
