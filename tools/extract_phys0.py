#!/usr/bin/env python3
"""Crop the PHYS0.SS terrain-overlay frames from the committed contact sheet.

docs/atlas/sprites/atlas_PHYS0.png is a clean 16-col grid (10 rows, separators at
y=24,81,139,...,545) of 154 overlay frames: river masks (0x00-0x1F), mountains
(0x20-0x2F), hills (0x30-0x3F), forest canopy (0x40-0x4F), edge stencils
(0x68-0x6B), coast quadrant sub-tiles (0x6C-0x8B) and diagonal beaches (0x96-0x99).
The map renderer composites these OVER the TERRAIN.SS base ground, selected per a
tile's neighbours (see viceroy_cpp/src/mapview.cpp).

This lifts every frame (each drawn at 2x in its cell, lower-left fixed box) to native
16x16 and packs them into a horizontal strip data_extracted/tileset/phys0.png (frame
f at x=f*16), with black -> transparent (the contact sheet baked transparency to
opaque black; we restore alpha so the overlays composite over the ground). phys0.json
records the layout.

Caveat: the contact sheet lost the original land-side vs ocean-cutout index
distinction (both are black here), so coast rendering is a faithful approximation,
not the byte-exact in-game pipeline (which needs the raw .SS sheets). Needs Pillow
only to regenerate; the runtime serves the committed PNG.

Usage: tools/extract_phys0.py
"""
import json
import os
from PIL import Image
from bmp_io import open_image, open_rgba, save_bmp

SRC = "docs/atlas/sprites/atlas_PHYS0.bmp"
OUT_DIR = "data_extracted/tileset"
SEPS = [24, 81, 139, 197, 255, 313, 371, 429, 487, 545, 604]
PITCH = 58
BOX_DX, BOX_DY, BOX = 13, 21, 32   # the 2x (32px) frame box within each cell
N = 154


def main():
    im = open_image(SRC).convert("RGB")
    strip = Image.new("RGBA", (N * 16, 16), (0, 0, 0, 0))
    for f in range(N):
        col, row = f % 16, f // 16
        x, y = col * PITCH + BOX_DX, SEPS[row] + BOX_DY
        cell = im.crop((x, y, x + BOX, y + BOX)).resize((16, 16), Image.NEAREST).convert("RGBA")
        px = cell.load()
        for j in range(16):
            for i in range(16):
                r, g, b, _ = px[i, j]
                if r == 0 and g == 0 and b == 0:
                    px[i, j] = (0, 0, 0, 0)        # black -> transparent
        strip.paste(cell, (f * 16, 0))
    os.makedirs(OUT_DIR, exist_ok=True)
    save_bmp(strip, os.path.join(OUT_DIR, "phys0.bmp"))
    meta = {"frame": 16, "count": N, "source": SRC,
            "bands": {"river": [0x00, 0x1F], "mountains": [0x20, 0x2F], "hills": [0x30, 0x3F],
                      "forest": [0x40, 0x4F], "stencils": [0x68, 0x6B],
                      "coast_subtiles": [0x6C, 0x8B], "beaches": [0x96, 0x99]}}
    with open(os.path.join(OUT_DIR, "phys0.json"), "w") as f:
        json.dump(meta, f, indent=2)
    print(f"wrote {OUT_DIR}/phys0.bmp ({strip.size[0]}x{strip.size[1]}, {N} frames) + phys0.json")


if __name__ == "__main__":
    main()
