#!/usr/bin/env python3
"""
string_xref_annotate.py — Annotate every PUSH imm16 instruction in the
.asm files where the immediate is a string offset. Emit a `; STRING:
"..."` comment after the line.

This is one of the most-leveraged annotation passes:
  - Every PUSH 0xNNNN that lands in the string table becomes a labeled comment
  - Functions that PUSH game-event strings (BURNED, KINGTAX, etc.) become
    instantly identifiable by reading their .asm
  - Phase D worklist gets ground truth for "what does this function do"
    without having to disassemble each function manually

Usage:
    # Annotate VICEROY.EXE's disasm tree (default):
    python string_xref_annotate.py

    # Annotate a specific EXE:
    python string_xref_annotate.py --target MAPEDIT
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLONIZE = ROOT / "raw" / "COLONIZE"

# Map target → EXE filename + code dir + string-segment file offset + length
TARGETS = {
    "VICEROY":  ("VICEROY.EXE",  "VICEROY",  0x01D9A0, 0x2cc5),
    "MAPEDIT":  ("MAPEDIT.EXE",  "MAPEDIT",  None,     None),  # different layout — skip for now
    "OPENING":  ("OPENING.EXE",  "OPENING",  None,     None),
    "CLOSING":  ("CLOSING.EXE",  "CLOSING",  None,     None),
}


def find_strings(data: bytes, base: int, length: int) -> dict:
    """Walk the string table and return {imm_offset: string_value}."""
    out = {}
    end = base + length
    ofs = 0
    while ofs < length:
        addr = base + ofs
        if 32 <= data[addr] < 127:
            e = addr
            while e < end and data[e] != 0:
                e += 1
            if 4 <= e - addr < 60:
                try:
                    s = data[addr:e].decode('ascii', errors='replace')
                    if all(32 <= ord(c) < 127 for c in s):
                        out[ofs] = s
                except: pass
            ofs = e - base + 1
        else:
            ofs += 1
    return out


def annotate_asm_files(target_name: str) -> int:
    """Walk the disasm dir for target_name, annotate PUSH imm sites."""
    if target_name not in TARGETS:
        print(f"Unknown target: {target_name}", file=sys.stderr)
        return 1
    exe_filename, code_dir_name, base, length = TARGETS[target_name]
    if base is None:
        print(f"  SKIP {target_name}: string-segment offset not yet known", file=sys.stderr)
        return 0

    exe_path = COLONIZE / exe_filename
    code_dir = ROOT / "code" / code_dir_name / "disasm"
    if not exe_path.exists() or not code_dir.exists():
        print(f"  SKIP {target_name}: missing EXE or disasm dir", file=sys.stderr)
        return 1

    data = exe_path.read_bytes()
    string_map = find_strings(data, base, length)
    print(f"  {target_name}: {len(string_map)} strings indexed in segment 0x{base:06x}..0x{base+length:06x}")

    asm_files = sorted(code_dir.glob("func_*.asm"))
    print(f"  {len(asm_files)} .asm files to scan")

    files_modified = 0
    lines_annotated = 0

    # Match: hex_addr  hex_bytes  PUSH  0xNNNN  ; ...
    # Specifically lines with PUSH imm16 instruction
    push_re = re.compile(
        r'^([0-9A-Fa-f]{6})  ((?:[0-9A-Fa-f]{2} ){2,5}\s*)\s*(PUSH)\s+(0x[0-9a-fA-F]+)\s+;\s*(.*)$'
    )

    for asm_path in asm_files:
        content = asm_path.read_text(encoding='utf-8', errors='replace')
        new_lines = []
        modified = False
        for line in content.split("\n"):
            m = push_re.match(line)
            if m:
                imm_hex = m.group(4)
                imm = int(imm_hex, 16)
                # Check if it lands in string table
                if imm in string_map:
                    s = string_map[imm]
                    # Replace the trailing comment with STRING annotation if it's still UNKNOWN
                    existing_comment = m.group(5).strip()
                    if existing_comment == "UNKNOWN" or "STRING:" not in existing_comment:
                        # Rebuild line with STRING annotation
                        prefix = line[:line.rindex(";") + 1]
                        new_line = prefix + f' STRING: "{s}"'
                        if existing_comment and existing_comment != "UNKNOWN" and "STRING:" not in existing_comment:
                            new_line += f"  ({existing_comment})"
                        new_lines.append(new_line)
                        modified = True
                        lines_annotated += 1
                        continue
            new_lines.append(line)

        if modified:
            asm_path.write_text("\n".join(new_lines), encoding='utf-8')
            files_modified += 1

    print(f"  {target_name}: {lines_annotated} PUSH-string sites annotated across {files_modified} files")
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--target", action="append", default=[],
                    help="Target EXE name (VICEROY, MAPEDIT, OPENING, CLOSING)")
    args = ap.parse_args()

    targets = args.target or ["VICEROY"]
    rc = 0
    for t in targets:
        print(f"\n=== Annotating {t} ===")
        rc |= annotate_asm_files(t)
    return rc


if __name__ == "__main__":
    sys.exit(main())
