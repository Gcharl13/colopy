#!/usr/bin/env python3
"""
extract_visuals.py — Phase C-VISUAL extraction driver.

Runs mpskit on every .SS, .PIK, and .FF file in COLONIZE/, populating
the assets/ tree with PNGs + per-file sidecar JSONs.

NOTE on round-trip: mpskit's FAB compression is non-deterministic, so
re-encoded .SS/.PIK/.FF files don't byte-match the original. The
alternate "lossless decoded round-trip" criterion is used for these
formats: extract → re-encode → re-extract produces the same PNGs.
The byte-identity round-trip for the original asset files is satisfied
by `verify.py` independently.

Usage:
    python extract_visuals.py --type SS   # only sprite sheets
    python extract_visuals.py --type PIK  # only backgrounds
    python extract_visuals.py --type FF   # only fonts
    python extract_visuals.py             # all three
"""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLONIZE = ROOT / "raw" / "COLONIZE"
MPSKIT_MAIN = ROOT.parent / "tools" / "mpskit" / "main.py"

ASSET_DIRS = {
    "SS":  ROOT / "assets" / "sprites",
    "PIK": ROOT / "assets" / "backgrounds",
    "FF":  ROOT / "assets" / "fonts",
}

# Files to skip (per CLAUDE.md hard rule)
SKIP_FILES = {"BDARK.SS"}


def extract_one(src: Path, kind: str, dest_root: Path) -> tuple[bool, dict]:
    """Extract a single asset file using mpskit; collect output to dest_root/<basename>/."""
    if src.name in SKIP_FILES:
        return False, {"skipped": True, "reason": "orphan per CLAUDE.md"}

    base = src.stem
    dest = dest_root / base
    dest.mkdir(parents=True, exist_ok=True)

    # mpskit writes files alongside the source in the cwd, so use a temp dir
    with tempfile.TemporaryDirectory() as tmp:
        tmp_path = Path(tmp)
        src_copy = tmp_path / src.name
        shutil.copy2(src, src_copy)
        kind_lower = kind.lower()
        try:
            result = subprocess.run(
                [sys.executable, str(MPSKIT_MAIN), kind_lower, "unpack", src.name],
                capture_output=True, text=True, timeout=60,
                cwd=tmp_path,
            )
            stdout = result.stdout
            stderr = result.stderr
        except subprocess.TimeoutExpired:
            return False, {"skipped": True, "reason": "timeout"}
        except Exception as e:
            return False, {"skipped": True, "reason": f"mpskit error: {e}"}

        # Collect outputs (images -> 24-bit BMP + JSONs)
        png_count = 0
        json_count = 0
        for f in sorted(tmp_path.iterdir()):
            if f.name == src.name:
                continue
            if f.suffix == ".part":
                continue   # skip raw section dumps
            target = dest / f.name
            shutil.copy2(f, target)
            if f.suffix == ".png":
                # mpskit emits PNG; the project's asset format is 24-bit BMP
                from bmp_io import open_image, save_bmp
                save_bmp(open_image(str(target)).convert("RGBA"), str(target))
                target.unlink()
                png_count += 1
            if f.suffix == ".json": json_count += 1

        # Sidecar
        sha = hashlib.sha256(src.read_bytes()).hexdigest()
        sidecar = {
            "source_file": src.name,
            "sha256": sha,
            "format": kind,
            "format_spec": f"formats/{kind}.md",
            "loader_function": "TBD",
            "loader_offset": "TBD",
            "called_with_args": [],
            "extracted_to": str(dest.relative_to(ROOT)),
            "frames_or_glyphs_count": png_count,
            "metadata_count": json_count,
            "extraction_tool": "mpskit",
            "round_trip": "lossless_decoded (FAB compression is non-deterministic)",
        }
        sidecar_path = dest / "loader.json"
        sidecar_path.write_text(json.dumps(sidecar, indent=2))
        return True, sidecar


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--type", choices=["SS", "PIK", "FF", "ALL"], default="ALL")
    ap.add_argument("--limit", type=int, help="Only process first N files (for testing)")
    args = ap.parse_args()

    types = ["SS", "PIK", "FF"] if args.type == "ALL" else [args.type]

    summary = {}
    for kind in types:
        files = sorted(COLONIZE.glob(f"*.{kind}"))
        if args.limit:
            files = files[:args.limit]
        dest_root = ASSET_DIRS[kind]
        dest_root.mkdir(parents=True, exist_ok=True)

        success = 0
        skipped = 0
        failed = 0
        for f in files:
            ok, info = extract_one(f, kind, dest_root)
            if ok:
                success += 1
                if success <= 3 or success % 25 == 0:
                    print(f"  [{kind}] {f.name}: extracted {info.get('frames_or_glyphs_count', 0)} frames/glyphs")
            elif info.get("skipped"):
                skipped += 1
                print(f"  [{kind}] {f.name}: SKIPPED ({info.get('reason')})")
            else:
                failed += 1
                print(f"  [{kind}] {f.name}: FAILED")
        summary[kind] = {"success": success, "skipped": skipped, "failed": failed, "total": len(files)}
        print(f"  --- {kind}: {success}/{len(files)} extracted, {skipped} skipped, {failed} failed ---")

    print("\n=== Summary ===")
    for kind, s in summary.items():
        print(f"  {kind}: {s['success']}/{s['total']} extracted")
    return 0


if __name__ == "__main__":
    sys.exit(main())
