#!/usr/bin/env python3
"""encode_mp.py — Re-emit a byte-identical .MP file from the JSON.

Writes what VICEROY's own writer func_071246 writes (@0x71286 w,h; @0x712AD
version; @0x712DD/@0x71304/@0x7132C the three layers) -- see
tools/extract_mp.py and formats/MP_FORMAT.md.  Codec: tools/asset_codecs.mp_encode.
"""
from __future__ import annotations
import argparse, hashlib, json, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
import asset_codecs  # noqa: E402


def encode(json_path: Path, out_path: Path) -> bytes:
    obj = json.loads(json_path.read_text())
    blob = asset_codecs.mp_encode(obj)
    out_path.write_bytes(blob)
    return blob


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
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
