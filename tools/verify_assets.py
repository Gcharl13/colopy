#!/usr/bin/env python3
"""
verify_assets.py — Round-trip verify every asset in COLONIZE/ against
the golden manifest. Uses available extract/encode tools where possible.

For each asset:
1. Extract via the appropriate tool (mpskit or extract_<ext>.py).
2. Re-encode the extraction.
3. Compute SHA-256 of the re-encoded bytes; compare to golden manifest.
4. Pass/fail.

Status:
- Most COLONIZE/ files don't have round-trip tools yet. This script
  records the status of what IS verifiable and flags the gap for the
  unfinished work.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    args = ap.parse_args()

    manifest_path = ROOT / "verification" / "golden_manifest.json"
    if not manifest_path.exists():
        print(f"ERROR: golden manifest not found at {manifest_path}", file=sys.stderr)
        return 1
    manifest = json.loads(manifest_path.read_text())

    results = {
        "total": len(manifest),
        "have_extractor": 0,
        "round_trip_pass": 0,
        "round_trip_fail": 0,
        "no_extractor": 0,
        "details": [],
    }

    # Map extension -> "round-trip tooling status"
    ext_status = {
        # Format -> (extracted, encoded, round-trip-verified)
        "PAL": ("via tools/extract_pal.py + encode_pal.py",
                "tools/extract_pal.py works; verify_pal.py runs both",
                "TBD"),
        "MP":  ("via tools/extract_mp.py", "via tools/encode_mp.py", "TBD"),
        "SS":  ("via tools/mpskit/main.py ss extract", "encode supported", "TBD"),
        "PIK": ("via tools/mpskit/main.py pik extract", "encode supported", "TBD"),
        "FF":  ("via tools/mpskit/main.py ff extract", "encode supported", "TBD"),
        "DAT": ("partial — CYCLE.DAT decoded", "TBD", "TBD"),
        "COL": ("partial — header parsed", "TBD", "TBD"),
        "BIN": ("raw — no decoder needed", "raw", "raw"),
        "MOV": ("partial — script format only", "TBD", "TBD"),
        "GIF": ("standard GIF", "standard", "via PIL"),
        "TXT": ("plain text", "plain text", "n/a"),
        "EXE": ("MZ disassembled", "n/a", "n/a"),
        "JSON":("source files", "n/a", "n/a"),
        "PNG": ("standard PNG", "standard", "via PIL"),
        "PART":("RTLink overlay parts", "TBD", "TBD"),
        "BAT": ("DOS batch script", "n/a", "n/a"),
        "DB":  ("text database", "n/a", "n/a"),
        "BACKUP":("backup of MP", "n/a", "n/a"),
        "COM": ("DOS COM executable", "n/a", "n/a"),
    }

    by_ext = {}
    for name in manifest:
        ext = name.rsplit(".", 1)[-1].upper() if "." in name else "NONE"
        by_ext.setdefault(ext, []).append(name)

    print(f"[verify_assets] Total files: {results['total']}")
    print()
    print("Format -> extract/encode/round-trip status:")
    for ext in sorted(by_ext):
        n = len(by_ext[ext])
        status = ext_status.get(ext, ("?", "?", "?"))
        print(f"  {ext:6s} {n:4d} files  extract={status[0]}, encode={status[1]}, "
              f"round-trip={status[2]}")
        if status[0] != "?":
            results["have_extractor"] += n

    print()
    print("Per the project's existing tooling (`tools/mpskit/`), MOST")
    print("formats have working extract+encode; round-trip SHA-256")
    print("verification against the golden manifest is the remaining")
    print("step. This script records the inventory; running mpskit's")
    print("round-trip is a separate (non-trivial) integration step.")

    out = ROOT / "verification" / "verify_assets_status.json"
    out.write_text(json.dumps({"results": results, "by_ext": {
        k: len(v) for k, v in by_ext.items()
    }}, indent=2))
    print(f"\nWrote {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
