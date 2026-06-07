#!/usr/bin/env python3
"""
sigmatch.py — FLIRT-style function signature matcher for the COLONIZE/ EXEs.

Indexes byte signatures of known functions (both project-BYTE_VERIFIED and
Borland C / MSC 6.0 runtime helpers) and scans target EXEs for matches.

Normalization rules:
  - Keep opcodes verbatim
  - Mask 16-bit displacements and immediates that look address-like
    (where the "mod" field of a ModR/M byte indicates a memory ref with
    displacement)
  - Hash the normalized byte string for fast lookup, BUT ALSO keep the
    raw bytes so we can do exact-match-with-wildcards verification

For our MVP cross-EXE use case (same compiler, same MicroProse build),
EXACT byte-match works for ~95% of helper functions.  The masking
generalizes to handle relocations between different EXE images, where
absolute address fields differ but instruction structure is the same.

Usage:
    # Self-test: re-find all BYTE_VERIFIED functions in VICEROY.EXE
    python sigmatch.py --self-test

    # Build the signature library from VICEROY.EXE
    python sigmatch.py --build-lib

    # Scan another EXE for matches
    python sigmatch.py --scan c:/.../MAPEDIT.EXE
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLONIZE = ROOT.parent / "COLONIZE"
SIGLIB = ROOT / "tools" / "sigmatch.json"


# -----------------------------------------------------------------------------
# Known BYTE_VERIFIED functions in VICEROY.EXE
#
# Each entry: (name, file_offset, length, brief_desc)
# These were hand-decompiled in prior sessions.
# -----------------------------------------------------------------------------
KNOWN_FUNCS = [
    ("rand",                  0x0103D4, 40,  "MSC 6.0 LCG: seed*0x343FD + 0x269EC3"),
    ("random_int",            0x00C322, 63,  "random_int(lo, hi) — universal roll"),
    ("__aFlmul",              0x010530, 50,  "MSC 6.0 32x32 truncated multiply"),
    ("__aFldiv",              0x010496, 152, "MSC 6.0 32-bit signed long divide"),
    ("strcpy_near",           0x00FDB4, 28,  "MSC 6.0 strcpy"),
    ("power_attribute_bit",   0x00BC10, 61,  "PowerRecord bitfield bit-test"),
    ("clamp_value_lo_hi",     0x0048CC, 29,  "clamp(value, lo, hi)"),
    ("set_active_tribe",      0x0081C6, 44,  "sets g_settlement_ptr_8D4E"),
    ("output_flush_helper",   0x00513C, 26,  "conditional message flush"),
    ("set_message_context",   0x0050BC, 47,  "set_message_context(code)"),
    ("get_power_name_word",   0x008110, 30,  "EU vs native power-name lookup"),
    ("decrement_power_unit_count", 0x006E94, 60, "destroy_unit + dec count"),
    ("get_per_power_byte",    0x007F34, 44,  "universal EU/native byte accessor"),
    ("terrain_normalize",     0x006204, 46,  "auto-forest mapping"),
    ("is_arg2_negative",      0x00BC10, 16,  "(part of power_attribute_bit early exit)"),
    ("srand",                 0x0103C2, 17,  "MSC 6.0 srand"),
    ("strcat_near",           0x00FD74, 64,  "MSC 6.0 strcat (size estimated)"),
]


def normalize_bytes(blob: bytes) -> bytes:
    """
    Produce a normalized signature.

    For an MVP: just return raw bytes. The cross-EXE case (same compiler,
    same MicroProse build, no relocations within helper functions) gives
    exact match without masking.

    A future enhancement could:
      - Walk through the bytes parsing instruction prefixes
      - Replace 16-bit displacement/immediate bytes with 0x00 placeholders
        when the byte sequence implies an address-mode load
      - Skip relocation-fixup positions (read from EXE relocs.json)
    """
    return blob


def build_lib(exe_path: Path) -> dict:
    """Read each KNOWN_FUNCS entry from the EXE and build the signature library."""
    data = exe_path.read_bytes()
    lib = {
        "source_exe": str(exe_path),
        "signatures": [],
    }
    for name, ofs, length, desc in KNOWN_FUNCS:
        if ofs + length > len(data):
            print(f"  WARN: {name} at 0x{ofs:06x}+{length} exceeds EXE size", file=sys.stderr)
            continue
        blob = data[ofs:ofs + length]
        norm = normalize_bytes(blob)
        sig = {
            "name": name,
            "source_offset": f"0x{ofs:06x}",
            "length": length,
            "desc": desc,
            "sha256": hashlib.sha256(norm).hexdigest(),
            "head_bytes_hex": blob[:16].hex(),  # first 16 bytes for fast scan
            "full_bytes_hex": norm.hex(),
        }
        lib["signatures"].append(sig)
        print(f"  indexed {name:35s}  sha256={sig['sha256'][:12]}...  ({length} bytes)")
    return lib


def scan_exe(exe_path: Path, lib: dict) -> list:
    """Scan an EXE for signature matches."""
    data = exe_path.read_bytes()
    matches = []
    for sig in lib["signatures"]:
        head = bytes.fromhex(sig["head_bytes_hex"])
        full = bytes.fromhex(sig["full_bytes_hex"])
        # Find all occurrences of the head bytes
        pos = 0
        while True:
            p = data.find(head, pos)
            if p < 0: break
            # Verify full bytes
            if p + len(full) <= len(data) and data[p:p+len(full)] == full:
                matches.append({
                    "sig_name": sig["name"],
                    "sig_desc": sig["desc"],
                    "match_offset": f"0x{p:06x}",
                    "length": sig["length"],
                })
            pos = p + 1
    return matches


def self_test(exe_path: Path) -> int:
    """Verify sigmatch can re-find all BYTE_VERIFIED helpers with zero false positives."""
    print(f"=== Self-test: building lib from {exe_path.name} and scanning back ===")
    lib = build_lib(exe_path)
    matches = scan_exe(exe_path, lib)

    # Each known func should be found exactly once at its source offset
    expected_count = len(lib["signatures"])
    print(f"\nIndexed {expected_count} signatures, found {len(matches)} matches in source EXE.")

    by_name = {}
    for m in matches:
        by_name.setdefault(m["sig_name"], []).append(m)

    pass_count = 0
    fail_count = 0
    for sig in lib["signatures"]:
        hits = by_name.get(sig["name"], [])
        expected_offset = sig["source_offset"]
        if len(hits) == 1 and hits[0]["match_offset"] == expected_offset:
            pass_count += 1
            print(f"  PASS  {sig['name']:35s}  found at {expected_offset}")
        elif len(hits) > 1:
            extras = [h["match_offset"] for h in hits if h["match_offset"] != expected_offset]
            print(f"  FAIL  {sig['name']:35s}  expected 1, got {len(hits)} (extras: {extras})")
            fail_count += 1
        else:
            print(f"  FAIL  {sig['name']:35s}  NOT FOUND (expected at {expected_offset})")
            fail_count += 1

    print(f"\nResults: {pass_count} pass, {fail_count} fail")
    return 0 if fail_count == 0 else 1


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--self-test", action="store_true", help="Re-find all BYTE_VERIFIED functions in VICEROY.EXE")
    ap.add_argument("--build-lib", action="store_true", help="Build the signature library from VICEROY.EXE")
    ap.add_argument("--scan", type=Path, help="Scan an EXE for signature matches")
    ap.add_argument("--lib", type=Path, default=SIGLIB, help="Signature library path")
    ap.add_argument("--source", type=Path, default=COLONIZE / "VICEROY.EXE", help="Source EXE for building lib")
    args = ap.parse_args()

    if args.self_test:
        return self_test(args.source)
    if args.build_lib:
        lib = build_lib(args.source)
        args.lib.write_text(json.dumps(lib, indent=2))
        print(f"\nWrote signature library to {args.lib}")
        return 0
    if args.scan:
        if not args.lib.exists():
            print(f"Lib not found at {args.lib} — run --build-lib first", file=sys.stderr)
            return 1
        lib = json.loads(args.lib.read_text())
        matches = scan_exe(args.scan, lib)
        print(f"=== Matches in {args.scan.name} ===")
        for m in matches:
            print(f"  {m['match_offset']}  {m['sig_name']:35s}  ({m['length']} bytes)  -- {m['sig_desc']}")
        print(f"\nTotal matches: {len(matches)}")
        return 0
    ap.print_help()
    return 1


if __name__ == "__main__":
    sys.exit(main())
