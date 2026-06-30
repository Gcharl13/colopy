#!/usr/bin/env python3
"""Crop the on-map unit sprites from the committed ICONS contact sheet.

docs/atlas/sprites/atlas_ICONS.png is a labeled contact sheet: a 16-column grid at
58px pitch, 9 rows separated by full-width lines (at y=24,81,139,197,255,313,371,
429,487), each cell = a small index label above a transparent sprite. This lifts the
on-map unit sprites out (one per sim UnitType 0..23, via the byte-verified
@UNIT sprite-frame column) and packs them into data_extracted/tileset/units.png: a
horizontal strip of 32x32 transparent cells, cell t = UnitType t (the founding-unit
ordering in sim/unit.hpp), each sprite centered. units.json records the layout.

The map renderer (Forge Play/Map tabs) draws cell `unit.type` over the terrain;
UnitType 23 is unused (left blank -> the renderer falls back to a marker). Needs
Pillow only to regenerate; the runtime just serves the committed PNG.

Usage: tools/extract_unitset.py
"""
import json
import os
from PIL import Image

SRC = "docs/atlas/sprites/atlas_ICONS.png"
OUT_DIR = "data_extracted/tileset"
PITCH = 58
SEPS = [24, 81, 139, 197, 255, 313, 371, 429, 487, 546]   # row-band boundaries (last = H)
CELL = 32
LABEL_SKIP = 15                                            # px of label strip at each band top

# sim UnitType (0..23) -> ICONS PNG frame index (VICEROY @UNIT sprite col minus 1).
TYPE_TO_FRAME = [100, 102, 101, 105, 104, 103, 125, 129, 126, 128, 16, 9, 8, 5,
                 6, 7, 14, 15, 127, 109, 110, 111, 112, -1]
NAMES = ["Colonists","Soldiers","Pioneers","Missionaries","Dragoons","Scouts",
         "Regulars","Continental Cavalry","Cavalry","Continental Army","Treasure",
         "Artillery","Wagon Train","Caravel","Merchantman","Galleon","Privateer",
         "Frigate","Man-O-War","Braves","Armed Braves","Mounted Braves",
         "Mounted Warriors","(unused)"]


def sprite_bbox(px, x0, x1, y0, y1):
    xs, ys = [], []
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b, a = px[x, y]
            if a > 0 and (r or g or b):
                xs.append(x); ys.append(y)
    if not xs:
        return None
    return min(xs), min(ys), max(xs) + 1, max(ys) + 1


def main():
    im = Image.open(SRC).convert("RGBA")
    W, _ = im.size
    px = im.load()
    n = len(TYPE_TO_FRAME)
    strip = Image.new("RGBA", (n * CELL, CELL), (0, 0, 0, 0))
    for t, fr in enumerate(TYPE_TO_FRAME):
        if fr < 0:
            continue
        col, row = fr % 16, fr // 16
        x0, x1 = col * PITCH, min(col * PITCH + PITCH, W)
        bb = sprite_bbox(px, x0 + 1, x1 - 1, SEPS[row] + LABEL_SKIP, SEPS[row + 1] - 1)
        if not bb:
            continue
        sp = im.crop(bb)
        sp = sp.crop((0, 0, min(sp.width, CELL), min(sp.height, CELL)))   # clamp to cell
        ox = t * CELL + (CELL - sp.width) // 2
        oy = (CELL - sp.height) // 2
        strip.paste(sp, (ox, oy), sp)
    os.makedirs(OUT_DIR, exist_ok=True)
    strip.save(os.path.join(OUT_DIR, "units.png"))
    meta = {"cell": CELL, "count": n, "source": SRC,
            "types": NAMES, "frames": TYPE_TO_FRAME}
    with open(os.path.join(OUT_DIR, "units.json"), "w") as f:
        json.dump(meta, f, indent=2)
    print(f"wrote {OUT_DIR}/units.png ({strip.size[0]}x{strip.size[1]}) + units.json")


if __name__ == "__main__":
    main()
