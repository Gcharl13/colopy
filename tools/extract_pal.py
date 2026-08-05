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
COLONIZE = ROOT / "raw" / "COLONIZE"


def extract(pal_path: Path, out_dir: Path):
    out_dir.mkdir(parents=True, exist_ok=True)
    data = pal_path.read_bytes()
    if len(data) < 768:
        print(f"WARN: expected >=768 palette bytes, got {len(data)}", file=sys.stderr)

    entries = []
    for i in range(256):
        # VICEROY.PAL = 256 RGB triples (3 bytes/entry, 6-bit). The first 768 bytes are
        # the palette; verified by rendering COLONY.PIK vs the live DOS capture (sky idx54 ->
        # (104,136,192)). The old 4-byte stride produced wrong colours across every asset.
        r = data[i * 3 + 0]
        g = data[i * 3 + 1]
        b = data[i * 3 + 2]
        # Byte 768+i: one flag per palette index, NOT padding. It holds only 0 or 5
        # in the shipped file (5 across indices 0..151 and 252..255, 0 between), so
        # it is real content and the extract is lossy without it -- which is what
        # broke the encode_pal round-trip from 2026-06-27 to 2026-08-05. Its
        # meaning is TBD; the loader is unidentified (docs/PALETTE_AND_CYCLING.md).
        flag = data[768 + i] if len(data) >= 1024 else 0
        # Scale 6-bit -> 8-bit
        r8 = (r * 255 + 31) // 63
        g8 = (g * 255 + 31) // 63
        b8 = (b * 255 + 31) // 63
        entries.append({
            "index": i,
            "vga_6bit": [r, g, b],
            "rgb_8bit": [r8, g8, b8],
            # Kept under the old key so existing readers keep working; the value is
            # now the real byte instead of a hardcoded 0.
            "padding": flag,
        })

    sha = hashlib.sha256(data).hexdigest()
    out_json = {
        "source_file": pal_path.name,
        "source_sha256": sha,
        "format_spec": "formats/PAL.md",
        "layout": "768 bytes of RGB triples, then one flag byte per index (768+i)",
        "trailing_bytes": len(data) - 768,
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
