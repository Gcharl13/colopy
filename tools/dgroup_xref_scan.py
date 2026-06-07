#!/usr/bin/env python3
"""
dgroup_xref_scan.py — Scan every disassembled VICEROY function for
16-bit immediate values that point into the DGROUP data range
(0x0000..0xFFFF in the data segment, mapped from file 0x10000..0x1FFFF).

Output: dgroup_xrefs.json
{
  "<dgroup_offset_hex>": {
      "string_text": "..." (if it falls on a known string),
      "xrefs": [
          {"func_offset": "0xNNNNNN", "func_name": "func_NNNNNN_...", "asm_addr": "0xNNNNNN"},
          ...
      ]
  },
  ...
}

This populates the xref column that strings.json was supposed to have but
never did. With this output we can answer "who reads CASHTREASURE", "who
writes to map_width", "who reads tribe_data table at DGROUP:0xNNN" — i.e.
the things needed to byte-verify formulas in viceroy_source/.
"""
from __future__ import annotations
import json
import re
import sys
from pathlib import Path
from collections import defaultdict

ROOT = Path(__file__).resolve().parents[1] / "code" / "VICEROY"
DISASM = ROOT / "disasm"
EXE = Path(__file__).resolve().parents[1] / "raw" / "COLONIZE" / "VICEROY.EXE"

DGROUP_FILE_BASE = 0x10000
DGROUP_FILE_END  = 0x20000      # 64 KB

# Match instructions that load an absolute 16-bit immediate or memory ref.
# We capture immediates in the form "0xHHHH" or "[0xHHHH]" or "byte ptr [0xHHHH]"
IMM_RE = re.compile(r"0x([0-9a-fA-F]{4})\b")
ADDR_RE = re.compile(r"^([0-9A-Fa-f]{6})\s")
FUNC_HEADER_RE = re.compile(r"^; func_([0-9A-Fa-f]{6})_(\S+)$", re.MULTILINE)


def load_strings_at_offsets(exe_path: Path) -> dict[int, str]:
    """Return a map: file_offset -> string text, for every NUL-terminated
    ASCII run in the DGROUP region of length >= 4."""
    out: dict[int, str] = {}
    with exe_path.open("rb") as f:
        f.seek(DGROUP_FILE_BASE)
        data = f.read(DGROUP_FILE_END - DGROUP_FILE_BASE)
    i = 0
    while i < len(data):
        if 32 <= data[i] < 127:
            j = i
            while j < len(data) and 32 <= data[j] < 127:
                j += 1
            if j < len(data) and data[j] == 0 and (j - i) >= 4:
                # Convert file offset to DGROUP-relative offset
                file_offset = DGROUP_FILE_BASE + i
                dgroup_offset = file_offset - DGROUP_FILE_BASE
                out[dgroup_offset] = data[i:j].decode("ascii", errors="replace")
                i = j + 1
                continue
        i += 1
    return out


def scan_disasm_files() -> dict[int, list[dict]]:
    """For every .asm file, find immediate values in the DGROUP range and
    record (function offset, instruction address) of each reference."""
    xrefs: dict[int, list[dict]] = defaultdict(list)
    for asm_file in DISASM.glob("*.asm"):
        # Extract function offset + name from filename: func_NNNNNN_<name>.asm
        m = re.match(r"func_([0-9A-Fa-f]{6})_(.+)\.asm$", asm_file.name)
        if not m:
            continue
        func_offset = int(m.group(1), 16)
        func_name = m.group(2)

        text = asm_file.read_text(errors="replace")
        for line in text.split("\n"):
            am = ADDR_RE.match(line)
            if not am:
                continue
            asm_addr = int(am.group(1), 16)
            for imm_match in IMM_RE.finditer(line):
                val = int(imm_match.group(1), 16)
                # If immediate falls in DGROUP range AND not also the
                # lower-byte of a likely opcode argument, record it.
                if 0x0000 <= val < 0x10000:
                    # We can't tell from raw immediate alone whether it's a
                    # data-segment reference — that depends on instruction
                    # context. Heuristic: only record if the line contains
                    # a memory-reference token like "ptr [" or "MOV ds:" or
                    # the value appears alongside DS reload.
                    if ("ptr [" in line or "ds:" in line.lower()
                            or "ds," in line.lower() or "PUSH" in line
                            or "MOV    ax," in line or "MOV    bx," in line
                            or "MOV    si," in line or "MOV    di," in line):
                        xrefs[val].append({
                            "func_offset": f"0x{func_offset:06X}",
                            "func_name": func_name,
                            "asm_addr": f"0x{asm_addr:06X}",
                            "context": line[:120].rstrip(),
                        })
    return xrefs


def main() -> int:
    print("Loading DGROUP strings...", file=sys.stderr)
    strings_at = load_strings_at_offsets(EXE)
    print(f"  Found {len(strings_at)} strings >= 4 chars", file=sys.stderr)

    print("Scanning disasm files...", file=sys.stderr)
    xrefs = scan_disasm_files()
    print(f"  Found {len(xrefs)} distinct DGROUP offsets referenced",
          file=sys.stderr)
    total_refs = sum(len(v) for v in xrefs.values())
    print(f"  Total ref sites: {total_refs}", file=sys.stderr)

    # Combine: emit per-offset record with optional string text
    out: dict = {}
    for offset, refs in sorted(xrefs.items()):
        rec: dict = {"xrefs": refs[:50]}    # cap at 50 per offset
        rec["xref_count"] = len(refs)
        if offset in strings_at:
            rec["string"] = strings_at[offset]
        out[f"0x{offset:04X}"] = rec

    out_path = ROOT / "dgroup_xrefs.json"
    with out_path.open("w") as f:
        json.dump({"summary": {
            "total_distinct_offsets": len(xrefs),
            "total_ref_sites": total_refs,
            "strings_known": len(strings_at)
        }, "xrefs": out}, f, indent=2)
    print(f"Wrote {out_path}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
