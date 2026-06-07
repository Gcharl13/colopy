#!/usr/bin/env python3
"""
extract_mp.py — Extract a .MP map file to JSON + raw tile-grid PNG.

Format spec: formats/MP_FORMAT.md.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLONIZE = ROOT.parent / "COLONIZE"


def extract(mp_path: Path, out_dir: Path):
    out_dir.mkdir(parents=True, exist_ok=True)
    data = mp_path.read_bytes()
    if len(data) < 4:
        print(f"ERROR: file too small ({len(data)} bytes)", file=sys.stderr)
        return 1

    width, height = struct.unpack_from("<HH", data, 0)
    tile_count = width * height
    tiles_end = 4 + tile_count
    if tiles_end > len(data):
        print(f"WARN: width={width} height={height} would require {tile_count} tile bytes "
              f"but only {len(data)-4} available", file=sys.stderr)
        tile_count = max(0, len(data) - 4)
        tiles_end = 4 + tile_count

    tiles = list(data[4:tiles_end])
    trailer = data[tiles_end:]   # ColonyRecord/UnitRecord/NativeSettlement arrays

    sha = hashlib.sha256(data).hexdigest()
    base_name = mp_path.stem.lower()

    # Write tiles + metadata as JSON
    out_json = {
        "source_file": mp_path.name,
        "source_sha256": sha,
        "format_spec": "formats/MP_FORMAT.md",
        "width": width,
        "height": height,
        "tile_count": len(tiles),
        "tile_data_offset": 4,
        "trailer_offset": tiles_end,
        "trailer_length": len(trailer),
        "tiles": tiles,                       # flat row-major
        "trailer_hex": trailer.hex(),         # opaque for now (per-record parsing pending Phase D)
    }
    json_path = out_dir / f"{base_name}.json"
    json_path.write_text(json.dumps(out_json, indent=2))
    print(f"  wrote {json_path}  ({width}x{height} tiles, {len(trailer)} trailer bytes)")

    # Write a raw tile-id PNG (1 pixel per tile, terrain ID as grayscale)
    try:
        from PIL import Image
        img = Image.new("L", (width, height))
        pixels = img.load()
        for y in range(height):
            for x in range(width):
                # Bottom 5 bits = terrain id; we visualize the tile byte directly
                pixels[x, y] = tiles[y * width + x]
        png_path = out_dir / f"{base_name}_tileids.png"
        img.save(png_path)
        print(f"  wrote {png_path}")
    except ImportError:
        print(f"  WARN: PIL/Pillow not installed; skipping tile-id PNG")

    # Sidecar
    sidecar = {
        "loader_function": "TBD",      # The .MP loader in VICEROY (Phase D)
        "loader_offset": "TBD",
        "called_with_args": [],
        "original_filename": mp_path.name,
        "sha256": sha,
        "format_spec": "formats/MP_FORMAT.md",
        "extracted_to": str(json_path.relative_to(ROOT)),
    }
    sidecar_path = out_dir / f"{base_name}.sidecar.json"
    sidecar_path.write_text(json.dumps(sidecar, indent=2))
    print(f"  wrote {sidecar_path}")
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--source", type=Path, default=COLONIZE / "AMER2.MP")
    ap.add_argument("--out", type=Path, default=ROOT / "assets" / "maps")
    args = ap.parse_args()
    if not args.source.exists():
        print(f"Source not found: {args.source}", file=sys.stderr)
        return 1
    return extract(args.source, args.out)


if __name__ == "__main__":
    sys.exit(main())
