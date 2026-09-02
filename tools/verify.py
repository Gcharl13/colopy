#!/usr/bin/env python3
"""
verify.py — Byte-identity check of every COLONIZE/ file against the golden
manifest (verification/golden_manifest.json).

Each file is copied to verification/results/ and its SHA-256 compared with
the manifest -- this proves the raw tree is what was frozen, nothing more.
The DECODE -> ENCODE round trips live in tools/verify_assets.py (2026-09-02,
REMAINING_WORK.md G6).  The manifest was regenerated the same day to cover
all 302 files in raw/COLONIZE/ (it had held 10 while this docstring
promised 319).

Usage:
    python verify.py                    # Run all
    python verify.py --quick            # Only recently-changed files
    python verify.py --format SS        # Only one format
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLONIZE = ROOT / "raw" / "COLONIZE"
GOLDEN = ROOT / "verification" / "golden_manifest.json"
RESULTS = ROOT / "verification" / "results"


def sha256_file(p: Path) -> str:
    return hashlib.sha256(p.read_bytes()).hexdigest()


def build_golden_manifest():
    """SHA-256 every file in COLONIZE/ once and freeze it."""
    GOLDEN.parent.mkdir(parents=True, exist_ok=True)
    files = sorted(COLONIZE.iterdir())
    manifest = {}
    for f in files:
        if f.is_file():
            manifest[f.name] = {
                "sha256": sha256_file(f),
                "size": f.stat().st_size,
            }
    GOLDEN.write_text(json.dumps(manifest, indent=2))
    print(f"Wrote golden manifest with {len(manifest)} files to {GOLDEN}")
    return manifest


def round_trip_byte_identity(src: Path) -> tuple[bool, str]:
    """The trivial round-trip: read bytes, write to results/, SHA-compare."""
    RESULTS.mkdir(parents=True, exist_ok=True)
    out = RESULTS / src.name
    blob = src.read_bytes()
    out.write_bytes(blob)
    src_sha = hashlib.sha256(blob).hexdigest()
    return True, src_sha


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--build-golden", action="store_true", help="Rebuild the golden manifest")
    ap.add_argument("--format", help="Limit to a specific extension (e.g. SS, PAL)")
    args = ap.parse_args()

    if args.build_golden or not GOLDEN.exists():
        manifest = build_golden_manifest()
    else:
        manifest = json.loads(GOLDEN.read_text())

    files = sorted(COLONIZE.iterdir())
    if args.format:
        ext = args.format.upper().lstrip(".")
        files = [f for f in files if f.is_file() and f.name.upper().endswith(f".{ext}")]

    pass_count = 0
    fail_count = 0
    skip_count = 0

    for f in files:
        if not f.is_file():
            continue
        expected_sha = manifest.get(f.name, {}).get("sha256")
        if not expected_sha:
            print(f"  SKIP  {f.name}  (not in golden manifest)")
            skip_count += 1
            continue

        # For now, all files use byte-identity round-trip.
        # Phase C-VISUAL will swap PAL/MP/SS/PIK/FF for proper parsers.
        ok, actual_sha = round_trip_byte_identity(f)
        if ok and actual_sha == expected_sha:
            pass_count += 1
        else:
            print(f"  FAIL  {f.name}  expected={expected_sha[:12]}... actual={actual_sha[:12]}...")
            fail_count += 1

    print(f"\nResults: {pass_count} pass, {fail_count} fail, {skip_count} skip "
          f"({len(files)} total)")
    return 0 if fail_count == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
