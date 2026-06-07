#!/usr/bin/env python3
"""
rename_pass.py — Apply the rename table to a Ghidra C export, producing
a progressively-named viceroy_full.c.

Usage:
    # Once you have a Ghidra C export at any path:
    python rename_pass.py --input path/to/viceroy.c --output viceroy_source/viceroy_full.c

    # Without --input, looks for viceroy_source/viceroy_full.c.raw
    python rename_pass.py
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RENAME_TABLE = ROOT / "tools" / "rename_table.json"


def apply_renames(text: str, table: dict) -> tuple[str, dict]:
    """Apply all renames; return new text + stats dict."""
    stats = {"FUN_replaced": 0, "DAT_replaced": 0, "LCALL_replaced": 0}

    # FUN_<addr> renames — Ghidra emits these as FUN_xxxxxxxx
    for entry in table["FUN_renames"]:
        for variant in entry["case_variants"]:
            # Ghidra's FUN_ symbols often have a 4-, 6-, or 8-hex-digit suffix
            # Try the exact symbol first
            patterns = [variant]
            # Also try common Ghidra forms (FUN_0103d4, FUN_103d4, FUN_0000103d4)
            hex_part = variant.replace("FUN_", "").replace("fun_", "")
            for pad in (5, 6, 7, 8):
                padded = "FUN_" + hex_part.zfill(pad).lower()
                if padded not in patterns:
                    patterns.append(padded)
                padded = "FUN_" + hex_part.zfill(pad).upper()
                if padded not in patterns:
                    patterns.append(padded)
            for pat in patterns:
                # Word-boundary replace
                count = len(re.findall(rf"\b{re.escape(pat)}\b", text))
                if count > 0:
                    text = re.sub(rf"\b{re.escape(pat)}\b", entry["rename_to"], text)
                    stats["FUN_replaced"] += count

    # DAT_<addr> renames
    for entry in table["DAT_renames"]:
        for variant in entry["case_variants"]:
            hex_part = variant.replace("DAT_", "").replace("dat_", "")
            patterns = [variant]
            for pad in (4, 5, 6, 7, 8):
                p_lo = "DAT_" + hex_part.zfill(pad).lower()
                p_hi = "DAT_" + hex_part.zfill(pad).upper()
                if p_lo not in patterns:
                    patterns.append(p_lo)
                if p_hi not in patterns:
                    patterns.append(p_hi)
            for pat in patterns:
                count = len(re.findall(rf"\b{re.escape(pat)}\b", text))
                if count > 0:
                    text = re.sub(rf"\b{re.escape(pat)}\b", entry["rename_to"], text)
                    stats["DAT_replaced"] += count

    # LCALL helper renames — Ghidra represents these as far calls into segments
    # like (*0x181f:0x4d4)() or (**0x181f:0x4d4) or (FUN_281f_07b4)(...)
    # We mostly handle the FUN_ ones above; this is for edge cases.
    for entry in table["LCALL_helpers"]:
        # Strip prefix and convert e.g. "0x181F:0x04D4" → search for both FUN_281f_04d4
        # (Ghidra image-relative paragraph + 0x1000 = 0x281F)
        pass  # Handled by FUN_ renames above

    return text, stats


def coverage_report(text: str) -> dict:
    """Count remaining FUN_/DAT_ symbols (= unnamed)."""
    fun_remaining = len(re.findall(r"\bFUN_[0-9a-fA-F]+\b", text))
    dat_remaining = len(re.findall(r"\bDAT_[0-9a-fA-F]+\b", text))
    # Unique symbol counts (a single symbol may appear many times)
    fun_unique = len(set(re.findall(r"\bFUN_[0-9a-fA-F]+\b", text)))
    dat_unique = len(set(re.findall(r"\bDAT_[0-9a-fA-F]+\b", text)))
    return {
        "FUN_remaining_total": fun_remaining,
        "FUN_remaining_unique": fun_unique,
        "DAT_remaining_total": dat_remaining,
        "DAT_remaining_unique": dat_unique,
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--input", type=Path,
                    default=ROOT / "viceroy_source" / "viceroy_full.c.raw",
                    help="Input Ghidra C export (raw, with FUN_/DAT_ symbols)")
    ap.add_argument("--output", type=Path,
                    default=ROOT / "viceroy_source" / "viceroy_full.c",
                    help="Output renamed C file")
    ap.add_argument("--table", type=Path, default=RENAME_TABLE,
                    help="Rename table JSON (build via tools/build_rename_table.py)")
    args = ap.parse_args()

    if not args.table.exists():
        print(f"Rename table not found at {args.table}.", file=sys.stderr)
        print(f"Build it first: python tools/build_rename_table.py", file=sys.stderr)
        return 1
    if not args.input.exists():
        print(f"Input C export not found at {args.input}.", file=sys.stderr)
        print(f"Re-export from Ghidra (File → Export Program → C/C++) and save to that path.", file=sys.stderr)
        return 1

    table = json.loads(args.table.read_text())
    text = args.input.read_text(errors='replace')

    # Coverage before
    before = coverage_report(text)
    print(f"=== Coverage BEFORE rename ===")
    print(f"  FUN_ symbols remaining: {before['FUN_remaining_unique']:5} unique  ({before['FUN_remaining_total']} total occurrences)")
    print(f"  DAT_ symbols remaining: {before['DAT_remaining_unique']:5} unique  ({before['DAT_remaining_total']} total occurrences)")

    # Apply
    new_text, stats = apply_renames(text, table)

    # Coverage after
    after = coverage_report(new_text)
    print(f"\n=== Coverage AFTER rename ===")
    print(f"  FUN_ symbols remaining: {after['FUN_remaining_unique']:5} unique  ({after['FUN_remaining_total']} total occurrences)")
    print(f"  DAT_ symbols remaining: {after['DAT_remaining_unique']:5} unique  ({after['DAT_remaining_total']} total occurrences)")

    print(f"\nReplacement totals:")
    print(f"  FUN_ replacements: {stats['FUN_replaced']}")
    print(f"  DAT_ replacements: {stats['DAT_replaced']}")

    # Save
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(new_text)
    print(f"\nWrote {args.output}  ({len(new_text):,} bytes)")

    # Coverage percentage
    if before["FUN_remaining_unique"] > 0:
        pct_named = 100 * (1 - after["FUN_remaining_unique"] / before["FUN_remaining_unique"])
        print(f"\nFUN_ named coverage: {pct_named:.1f}%")
    return 0


if __name__ == "__main__":
    sys.exit(main())
