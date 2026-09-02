#!/usr/bin/env python3
"""
encode_pal.py — Re-emit a byte-identical VICEROY.PAL from the JSON.

Format spec: formats/PAL.md.  Codec: tools/asset_codecs.pal_encode.

Layout: 768 bytes of RGB triples, then one flag byte per index.  NOT a
4-byte interleave -- that reading was corrected on 2026-06-27
(formats/PAL.md), but this encoder kept the old stride until 2026-08-05, so
the round-trip gate had been failing silently while STATUS.md reported it
green.  VICEROY's loader func_0781DE reads only the first 0x300 bytes
(fread @0x781FA-0x78205); the tail is re-emitted verbatim so the file
round-trips (tools/extract_pal.py header has the full citation).
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
import asset_codecs  # noqa: E402


def encode(json_path: Path, out_path: Path) -> bytes:
    obj = json.loads(json_path.read_text())
    if len(obj["entries"]) != 256:
        print(f"WARN: expected 256 entries, got {len(obj['entries'])}", file=sys.stderr)
    blob = asset_codecs.pal_encode(obj)
    out_path.write_bytes(blob)
    return blob


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
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
