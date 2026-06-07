#!/usr/bin/env python3
"""
encode_pal.py — Re-emit a byte-identical VICEROY.PAL from the JSON.

Format spec: formats/PAL.md.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def encode(json_path: Path, out_path: Path) -> bytes:
    obj = json.loads(json_path.read_text())
    entries = obj["entries"]
    if len(entries) != 256:
        print(f"WARN: expected 256 entries, got {len(entries)}", file=sys.stderr)
    blob = bytearray(1024)
    for e in entries:
        i = e["index"]
        r, g, b = e["vga_6bit"]
        pad = e["padding"]
        blob[i * 4 + 0] = r
        blob[i * 4 + 1] = g
        blob[i * 4 + 2] = b
        blob[i * 4 + 3] = pad
    out_path.write_bytes(bytes(blob))
    return bytes(blob)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--source", type=Path,
                    default=ROOT / "assets" / "palettes" / "viceroy.pal.json")
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "results" / "viceroy.pal.repacked")
    args = ap.parse_args()
    args.out.parent.mkdir(parents=True, exist_ok=True)
    blob = encode(args.source, args.out)
    sha = hashlib.sha256(blob).hexdigest()
    print(f"  encoded {len(blob)} bytes to {args.out}")
    print(f"  sha256: {sha}")

    expected = json.loads(args.source.read_text()).get("source_sha256")
    if expected:
        match = sha == expected
        print(f"  expected: {expected}")
        print(f"  ROUND-TRIP: {'PASS' if match else 'FAIL'}")
        return 0 if match else 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
