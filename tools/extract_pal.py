#!/usr/bin/env python3
"""
extract_pal.py — Extract VICEROY.PAL to JSON + PNG swatch.

Format spec: formats/PAL.md.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLONIZE = ROOT.parent / "COLONIZE"


def extract(pal_path: Path, out_dir: Path):
    out_dir.mkdir(parents=True, exist_ok=True)
    data = pal_path.read_bytes()
    if len(data) != 1024:
        print(f"WARN: expected 1024 bytes, got {len(data)}", file=sys.stderr)

    entries = []
    for i in range(256):
        r = data[i * 4 + 0]
        g = data[i * 4 + 1]
        b = data[i * 4 + 2]
        pad = data[i * 4 + 3]
        # Scale 6-bit -> 8-bit
        r8 = (r * 255 + 31) // 63
        g8 = (g * 255 + 31) // 63
        b8 = (b * 255 + 31) // 63
        entries.append({
            "index": i,
            "vga_6bit": [r, g, b],
            "rgb_8bit": [r8, g8, b8],
            "padding": pad,
        })

    sha = hashlib.sha256(data).hexdigest()
    out_json = {
        "source_file": pal_path.name,
        "source_sha256": sha,
        "format_spec": "formats/PAL.md",
        "entries": entries,
    }
    json_path = out_dir / "viceroy.pal.json"
    json_path.write_text(json.dumps(out_json, indent=2))
    print(f"  wrote {json_path}")

    # PNG swatch (16x16 grid of 16x16 pixel cells = 256x256 image)
    try:
        from PIL import Image
        img = Image.new("RGB", (256, 256))
        pixels = img.load()
        for i in range(256):
            row, col = i // 16, i % 16
            r8, g8, b8 = entries[i]["rgb_8bit"]
            for y in range(row * 16, row * 16 + 16):
                for x in range(col * 16, col * 16 + 16):
                    pixels[x, y] = (r8, g8, b8)
        png_path = out_dir / "viceroy.png"
        img.save(png_path)
        print(f"  wrote {png_path}")
    except ImportError:
        print(f"  WARN: PIL/Pillow not installed; skipping PNG swatch")

    # Sidecar loader info (filled in once the loader function is identified)
    sidecar = {
        "loader_function": "TBD",
        "loader_offset": "TBD",
        "called_with_args": [],
        "original_filename": pal_path.name,
        "sha256": sha,
        "format_spec": "formats/PAL.md",
        "extracted_to": str(json_path.relative_to(ROOT)),
    }
    sidecar_path = out_dir / "viceroy.pal.sidecar.json"
    sidecar_path.write_text(json.dumps(sidecar, indent=2))
    print(f"  wrote {sidecar_path}")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--source", type=Path, default=COLONIZE / "VICEROY.PAL")
    ap.add_argument("--out", type=Path, default=ROOT / "assets" / "palettes")
    args = ap.parse_args()
    if not args.source.exists():
        print(f"Source not found: {args.source}", file=sys.stderr)
        return 1
    extract(args.source, args.out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
