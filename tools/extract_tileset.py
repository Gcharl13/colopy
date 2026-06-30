#!/usr/bin/env python3
"""Crop a clean 16x16 terrain tileset from the committed TERRAIN.SS contact sheet.

docs/atlas/sprites/atlas_TERRAIN.png is a labeled contact sheet: 12 terrain tiles,
each drawn at 2x (32x32) with a text label above it. This lifts the 12 tile squares
out (dropping the labels), downscales them to native 16x16, and writes a clean
horizontal strip data_extracted/tileset/terrain16.png (192x16, tile i at x=i*16) plus
a tiny terrain16.json describing it. The map renderer (Forge "Map" tab) draws from
this strip. Needs Pillow only to regenerate; the runtime serves the committed PNG.

Tile order matches TERRAIN.SS frames 0..11:
  0 Tundra 1 Desert 2 Plains 3 Prairie 4 Grassland 5 Savanna
  6 Marsh 7 Swamp 8 (forest/hill ground) 9 Arctic 10 Ocean 11 Sea Lane

Usage: tools/extract_tileset.py
"""
import json
import os
from PIL import Image

SRC = "docs/atlas/sprites/atlas_TERRAIN.png"
OUT_DIR = "data_extracted/tileset"
N = 12
TILE_BAND = (45, 77)              # rows of the 32px (=16 @2x) tile, below the labels
X0, PITCH, SIZE2X = 13, 58, 32    # first tile x, slot pitch, 2x tile size


def main():
    im = Image.open(SRC).convert("RGBA")
    strip = Image.new("RGBA", (N * 16, 16), (0, 0, 0, 0))
    for i in range(N):
        x = X0 + i * PITCH
        cell = im.crop((x, TILE_BAND[0], x + SIZE2X, TILE_BAND[1]))   # 32x32
        tile = cell.resize((16, 16), Image.NEAREST)                  # back to native
        strip.paste(tile, (i * 16, 0))
    os.makedirs(OUT_DIR, exist_ok=True)
    strip.save(os.path.join(OUT_DIR, "terrain16.png"))
    meta = {
        "tile": 16, "count": N, "source": SRC,
        "names": ["Tundra", "Desert", "Plains", "Prairie", "Grassland", "Savanna",
                  "Marsh", "Swamp", "Forest/Hill ground", "Arctic", "Ocean", "Sea Lane"],
    }
    with open(os.path.join(OUT_DIR, "terrain16.json"), "w") as f:
        json.dump(meta, f, indent=2)
    print(f"wrote {OUT_DIR}/terrain16.png ({strip.size[0]}x{strip.size[1]}) + terrain16.json")


if __name__ == "__main__":
    main()
