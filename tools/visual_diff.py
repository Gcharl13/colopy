#!/usr/bin/env python3
"""
visual_diff.py — Pixel-compare each rendered Python output against
its corresponding DOSBox screenshot.

For each pair (rendered, reference), computes:
- Total pixel count
- Number of mismatching pixels
- Mismatch percentage
- Average per-channel delta on mismatching pixels

Outputs:
- viceroy_source/visual_diff_report.json
- printed summary

Usage:
    python visual_diff.py
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


# Pairings (rendered Python output, DOSBox reference)
PAIRINGS = [
    ("verification/screens/colony_baltimore.png",
     "verification/dosbox_screenshots/colon3.jpg",
     "Colony screen"),
    ("verification/gameplay/gameplay.png",
     "verification/dosbox_screenshots/screenshot_03.jpg",
     "Gameplay screen"),
    ("verification/screens/europe.png",
     "verification/dosbox_screenshots/0d9a26d4c422d6188237dff0521e62027795dcefaab8278ffc8373e500dbcbcd.jpg",
     "Europe screen"),
    ("verification/screens/nations.png",
     "verification/dosbox_screenshots/719e5080b9f342c2c8785061fba86c13a5702b01cf9e515ea82e47b306fa2bb8.jpg",
     "Nations screen"),
    ("verification/screens/score.png",
     "verification/dosbox_screenshots/f8997b67c07e4ba2f0416e5fb6a6ba3a39f9da1140bc8674edbddbb999adf7c9.jpg",
     "Score screen"),
    ("verification/popups/popup_lostcity2_cibola.png",
     "verification/dosbox_screenshots/b6235e52e93e0546fab74bc6669aa8e9f9cda0680b8439c3e3eb67fc9f970bfa.jpg",
     "Cibola popup"),
    ("verification/screens/declaration_signed.png",
     "verification/dosbox_screenshots/cf61be10bc6d787cfc8c8383790326df2f98af1268ff100375fdf8d7fa7b3f28.jpg",
     "Declaration signed"),
    ("verification/dialogs/example_diplomatic.png",
     "verification/dosbox_screenshots/acaab05505b30bd023db8e99d950ec831ed3c0aee0fc2d4441c5927bf8dfc1ab.jpg",
     "Diplomatic dialog"),
]


def diff_pair(rendered_path: Path, reference_path: Path) -> dict:
    """Compute pixel mismatch stats. Resizes reference to match rendered."""
    try:
        from PIL import Image
    except ImportError:
        return {"error": "PIL not installed"}
    if not rendered_path.exists():
        return {"error": f"rendered missing: {rendered_path}"}
    if not reference_path.exists():
        return {"error": f"reference missing: {reference_path}"}

    rendered = Image.open(rendered_path).convert("RGB")
    reference = Image.open(reference_path).convert("RGB")

    # Resize reference to rendered size for direct comparison.
    # NOTE: this is a STRUCTURAL diff, not pixel-perfect — DOSBox JPEG
    # captures vs PNG rendered will differ due to JPEG compression
    # artifacts. This compares LAYOUT not exact bytes.
    if reference.size != rendered.size:
        reference = reference.resize(rendered.size, Image.LANCZOS)

    rpx = rendered.load()
    fpx = reference.load()
    w, h = rendered.size
    total = w * h
    mismatch = 0
    sum_delta = 0
    threshold = 30  # per-channel delta below this counts as match
    for y in range(h):
        for x in range(w):
            r1, g1, b1 = rpx[x, y]
            r2, g2, b2 = fpx[x, y]
            d = abs(r1-r2) + abs(g1-g2) + abs(b1-b2)
            if d > threshold * 3:
                mismatch += 1
                sum_delta += d

    pct = (mismatch / total * 100) if total else 0
    avg_delta = (sum_delta / mismatch) if mismatch else 0
    return {
        "rendered_size": list(rendered.size),
        "reference_size_resized_to": list(rendered.size),
        "total_pixels": total,
        "mismatching_pixels": mismatch,
        "mismatch_percent": round(pct, 2),
        "avg_delta_on_mismatches": round(avg_delta, 1),
    }


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    args = ap.parse_args()

    report = []
    for rel_rend, rel_ref, label in PAIRINGS:
        rend = ROOT / rel_rend
        ref = ROOT / rel_ref
        result = diff_pair(rend, ref)
        result["rendered"] = rel_rend
        result["reference"] = rel_ref
        result["label"] = label
        report.append(result)
        if "error" in result:
            print(f"  {label}: SKIP — {result['error']}")
        else:
            print(f"  {label:30s}  mismatch={result['mismatch_percent']:5.2f}%  "
                  f"({result['mismatching_pixels']:,}/{result['total_pixels']:,} pixels)")

    out_path = ROOT / "viceroy_source" / "visual_diff_report.json"
    out_path.parent.mkdir(exist_ok=True)
    out_path.write_text(json.dumps(report, indent=2))
    print(f"\nWrote {out_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
