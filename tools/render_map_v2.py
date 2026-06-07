#!/usr/bin/env python3
"""
render_map_v2.py — Render an .MP map to PNG using correct terrain
colors (low-fi but pixel-correct), suitable for diff against a
DOSBox minimap screenshot.

Uses the verified TERRAIN_PAL_INDEX mapping (from parent project's
empirical analysis):
  0..15: unforested + forested 8-tier biomes
  16:    Arctic
  17-23: extended biome variants (forested)
  25:    Ocean
  26:    Sea Lane

Each tile renders as a solid color block (or 2x2 / 4x4 swatch).
This is a low-fi check that the .MP decode + terrain mapping +
palette load are all correct end-to-end.

For full-fidelity tile rendering (with PHYS0.SS sprites + transitions
+ forest overlays + coast halos), see render_map.py — but that
requires the per-terrain-id → sprite-index lookup which is itself
a Phase D deliverable.

Usage:
    python render_map_v2.py
    python render_map_v2.py --tile-size 4   # smaller minimap
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


# Per parent project's `colonize_sdl/dos_data.py` TERRAIN_PAL_INDEX
# (BYTE_VERIFIED at game-start by inspecting how colonize_sdl renders).
TERRAIN_PAL_INDEX = {
    0:  20,   # Tundra
    1:  66,   # Desert
    2:  54,   # Plains
    3:  60,   # Prairie
    4:  91,   # Grassland
    5:  40,   # Savannah
    6:  43,   # Marsh
    7:  46,   # Swamp
    8:  20,   # Boreal (Tundra base)
    9:  66,   # Scrub (Desert base)
    10: 54,   # Mixed
    11: 60,   # Broadleaf
    12: 91,   # Conifer
    13: 40,   # Tropical
    14: 43,   # Wetland
    15: 46,   # Rain
    16: 15,   # Arctic
    17: 91,   # extended -> Grassland-green
    18: 20,   # extended -> Tundra-grey (FAR NORTH)
    19: 91,   # extended -> Grassland-green
    20: 91,   # extended -> Grassland-green
    21: 40,   # extended -> Savannah bright-green (tropical)
    22: 43,   # extended -> Marsh-green
    23: 91,   # extended -> Grassland-green
    25: 45,   # Ocean
    26: 93,   # Sea Lane
}


def load_palette_rgb(pal_json: Path):
    """Load 8-bit RGB triples from VICEROY.PAL JSON."""
    obj = json.loads(pal_json.read_text())
    return [tuple(e["rgb_8bit"]) for e in obj["entries"]]


def render(map_json: dict, palette: list, tile_size: int = 4):
    from PIL import Image
    width = map_json["width"]
    height = map_json["height"]
    tiles = map_json["tiles"]

    canvas = Image.new("RGB", (width * tile_size, height * tile_size), (0, 0, 0))
    pixels = canvas.load()

    unmapped = set()
    for y in range(height):
        for x in range(width):
            byte = tiles[y * width + x]
            terrain_id = byte & 0x1F   # bottom 5 bits — 0..31

            pal_idx = TERRAIN_PAL_INDEX.get(terrain_id)
            if pal_idx is None:
                unmapped.add(terrain_id)
                # Fallback: solid magenta for unmapped
                color = (255, 0, 255)
            else:
                color = palette[pal_idx]

            for dy in range(tile_size):
                for dx in range(tile_size):
                    pixels[x * tile_size + dx, y * tile_size + dy] = color

    return canvas, unmapped


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--map", type=Path,
                    default=ROOT / "assets" / "maps" / "amer2.json")
    ap.add_argument("--palette", type=Path,
                    default=ROOT / "assets" / "palettes" / "viceroy.pal.json")
    ap.add_argument("--out", type=Path,
                    default=ROOT / "assets" / "maps" / "AMER2_render_v2.png")
    ap.add_argument("--tile-size", type=int, default=4,
                    help="Output pixels per map tile (default 4 = minimap-style)")
    args = ap.parse_args()

    if not args.map.exists() or not args.palette.exists():
        print("Source files missing", file=sys.stderr)
        return 1

    try:
        from PIL import Image
    except ImportError:
        print("PIL/Pillow required", file=sys.stderr)
        return 1

    print(f"Loading palette from {args.palette}...")
    palette = load_palette_rgb(args.palette)
    print(f"  {len(palette)} colors loaded")

    print(f"Loading map from {args.map}...")
    map_json = json.loads(args.map.read_text())
    print(f"  {map_json['width']}×{map_json['height']} tiles")

    print(f"Rendering at tile_size={args.tile_size}...")
    canvas, unmapped = render(map_json, palette, args.tile_size)
    canvas.save(args.out)
    print(f"  wrote {args.out}  ({canvas.size[0]}×{canvas.size[1]})")
    if unmapped:
        print(f"  WARN: unmapped terrain IDs: {sorted(unmapped)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
