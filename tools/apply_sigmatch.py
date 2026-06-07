#!/usr/bin/env python3
"""
apply_sigmatch.py — Apply sigmatch results to .asm files: rewrite the
boilerplate header with the verified annotation.

For each (target_exe, match) tuple, find the .asm file at
`code/<EXE>/disasm/func_<6hex>_unknown.asm`, replace the placeholder
header with a verified header citing the source EXE/offset.

This is the auto-promotion step that pushes Phase D coverage by 30-50%
without manual annotation.

Usage:
    python apply_sigmatch.py --target MAPEDIT
    python apply_sigmatch.py --target OPENING --target CLOSING
    python apply_sigmatch.py --target ALL    # = MAPEDIT, OPENING, CLOSING
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLONIZE = ROOT.parent / "COLONIZE"
SIGLIB = ROOT / "tools" / "sigmatch.json"

# Map target name → EXE filename + code dir
TARGETS = {
    "MAPEDIT": ("MAPEDIT.EXE", "MAPEDIT"),
    "OPENING": ("OPENING.EXE", "OPENING"),
    "CLOSING": ("CLOSING.EXE", "CLOSING"),
}


def make_verified_header(sig_name: str, sig_desc: str, source_offset: str,
                         source_exe: str, file_offset: int, length: int) -> str:
    """Build the new .asm header block."""
    return f"""; ============================================================================
; {sig_name}  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match {source_exe} at {source_offset} ({length} bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: {sig_desc}
; ----------------------------------------------------------------------------
; Region   : {("load_image" if file_offset < 0x20000 else "overlay")}
; Bytes    : file 0x{file_offset:06X}..0x{file_offset+length:06X}  ({length} bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY {source_offset})
; ============================================================================

"""


def apply_target(target_name: str, lib: dict) -> int:
    """Apply sigmatch annotations to a target EXE's disasm files."""
    if target_name not in TARGETS:
        print(f"Unknown target: {target_name}", file=sys.stderr)
        return 1

    exe_filename, code_dir_name = TARGETS[target_name]
    exe_path = COLONIZE / exe_filename
    code_dir = ROOT / "code" / code_dir_name / "disasm"

    if not exe_path.exists():
        print(f"EXE not found: {exe_path}", file=sys.stderr)
        return 1
    if not code_dir.exists():
        print(f"disasm dir not found: {code_dir}", file=sys.stderr)
        return 1

    # Re-run scan to get current matches
    data = exe_path.read_bytes()
    promoted = 0
    skipped = 0

    for sig in lib["signatures"]:
        full = bytes.fromhex(sig["full_bytes_hex"])
        head = full[:16]
        pos = 0
        while True:
            p = data.find(head, pos)
            if p < 0:
                break
            if p + len(full) <= len(data) and data[p:p+len(full)] == full:
                # Found a match. Find the corresponding .asm file.
                asm_filename = f"func_{p:06X}_unknown.asm"
                asm_path = code_dir / asm_filename
                if not asm_path.exists():
                    # Try lowercase
                    asm_filename = f"func_{p:06x}_unknown.asm"
                    asm_path = code_dir / asm_filename
                if not asm_path.exists():
                    # Find any file starting with the offset
                    candidates = list(code_dir.glob(f"func_{p:06X}_*.asm")) \
                        + list(code_dir.glob(f"func_{p:06x}_*.asm"))
                    if candidates:
                        asm_path = candidates[0]
                if not asm_path.exists():
                    print(f"  SKIP  {sig['name']:35s}  match at 0x{p:06x} but no .asm file")
                    skipped += 1
                    pos = p + 1
                    continue

                # Read existing .asm
                content = asm_path.read_text(encoding='utf-8', errors='replace')
                # Detect if already annotated (has BYTE_VERIFIED marker)
                if "BYTE_VERIFIED" in content[:500]:
                    skipped += 1
                    pos = p + 1
                    continue

                # Find the end of the existing header (first instruction line, hex offset)
                lines = content.split("\n")
                first_inst_idx = None
                for i, line in enumerate(lines):
                    # Instruction lines start with 6 hex digits then 2 spaces
                    if len(line) >= 8 and all(c in "0123456789abcdefABCDEF" for c in line[:6]) and line[6:8] == "  ":
                        first_inst_idx = i
                        break
                if first_inst_idx is None:
                    print(f"  SKIP  {asm_path.name}  no instruction lines found")
                    skipped += 1
                    pos = p + 1
                    continue

                # Replace header with verified one
                new_header = make_verified_header(
                    sig["name"], sig["desc"],
                    sig["source_offset"], "VICEROY.EXE",
                    p, sig["length"]
                )
                new_content = new_header + "\n".join(lines[first_inst_idx:])
                asm_path.write_text(new_content, encoding='utf-8')
                print(f"  PROMOTED  {asm_path.name}  -> {sig['name']}")
                promoted += 1
                pos = p + len(full)  # don't double-match overlapping
            else:
                pos = p + 1

    print(f"\n{target_name}: {promoted} promoted, {skipped} skipped")
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--target", action="append", default=[],
                    help="Target EXE name (MAPEDIT, OPENING, CLOSING, or ALL)")
    ap.add_argument("--lib", type=Path, default=SIGLIB)
    args = ap.parse_args()

    if not args.lib.exists():
        print(f"Lib not found at {args.lib} — run sigmatch.py --build-lib first", file=sys.stderr)
        return 1

    lib = json.loads(args.lib.read_text())

    targets = []
    for t in args.target:
        if t == "ALL":
            targets.extend(["MAPEDIT", "OPENING", "CLOSING"])
        else:
            targets.append(t)
    if not targets:
        targets = ["MAPEDIT", "OPENING", "CLOSING"]

    rc = 0
    for t in targets:
        print(f"\n=== Applying sigmatch to {t} ===")
        rc |= apply_target(t, lib)
    return rc


if __name__ == "__main__":
    sys.exit(main())
