#!/usr/bin/env python3
"""encode_mp.py — Re-emit a byte-identical .MP file from the JSON."""
from __future__ import annotations
import argparse, hashlib, json, struct, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def encode(json_path: Path, out_path: Path) -> bytes:
    obj = json.loads(json_path.read_text())
    width, height = obj["width"], obj["height"]
    tiles = obj["tiles"]
    trailer = bytes.fromhex(obj["trailer_hex"])
    blob = bytearray()
    blob += struct.pack("<HH", width, height)
    blob += bytes(tiles)
    blob += trailer
    out_path.write_bytes(bytes(blob))
    return bytes(blob)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--source", type=Path,
                    default=ROOT / "assets" / "maps" / "amer2.json")
    ap.add_argument("--out", type=Path,
                    default=ROOT / "verification" / "results" / "amer2.mp.repacked")
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
