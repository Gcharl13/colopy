#!/usr/bin/env python3
"""
extract_mapedit_symbols.py — recover MAPEDIT.EXE's embedded C symbol table.

MAPEDIT.EXE (MSC 6.0, medium model) ships a public-symbol table whose records
are laid out back-to-back as:

    u16 offset   ; symbol's offset within its segment
    u16 segment  ; load-relative paragraph (DGROUP data = 0x15E7; others = code)
    u16 zero     ; always 0x0000
    u8  namelen
    char name[namelen]

The load image begins at file 0x1600 (352-paragraph MZ header) and is 0x1A809
bytes long, so a DATA symbol's initialized bytes live at

    file_off = 0x1600 + segment*16 + offset

when that lands inside the image; offsets past the image end are BSS (runtime
only, value not stored in the file).  CODE symbols map to the per-function
disassembly file code/MAPEDIT/disasm/func_<file_off:06X>_*.asm.

Outputs code/MAPEDIT/symbols.json: { name: {seg, off, file_offset, kind, init_u16?} }.
With CLI args, also prints those symbols' resolved values.
"""
import json
import re
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXE = ROOT / "raw" / "COLONIZE" / "MAPEDIT.EXE"
OUT = ROOT / "code" / "MAPEDIT" / "symbols.json"

IMAGE_BASE = 0x1600          # 352 paragraphs * 16
IMAGE_SIZE = 0x1A809         # from MAPEDIT_ANALYSIS.md
DGROUP_MIN = 0x1400          # segments >= this are DGROUP data, below are code
NAME_RE = re.compile(rb"[A-Za-z_][A-Za-z0-9_]*\Z")


def parse_symbols(data: bytes) -> dict:
    syms = {}
    n = len(data)
    for p in range(4, n - 8):
        # zero field + plausible length
        if data[p + 4] != 0 or data[p + 5] != 0:
            continue
        ln = data[p + 6]
        if ln < 2 or ln > 63 or p + 7 + ln > n:
            continue
        name = data[p + 7:p + 7 + ln]
        if not NAME_RE.match(name):
            continue
        off = struct.unpack_from("<H", data, p)[0]
        seg = struct.unpack_from("<H", data, p + 2)[0]
        if seg == 0:
            continue
        nm = name.decode("latin1")
        # first occurrence wins; the real table has each public once
        if nm in syms:
            continue
        file_off = IMAGE_BASE + seg * 16 + off
        kind = "data" if seg >= DGROUP_MIN else "code"
        rec = {"seg": seg, "off": off, "file_offset": file_off, "kind": kind}
        if kind == "data" and IMAGE_BASE <= file_off <= n - 2:
            rec["init_u16"] = struct.unpack_from("<H", data, file_off)[0]
        elif kind == "data":
            rec["init_u16"] = None        # BSS: runtime-only
        syms[nm] = rec
    return syms


def disasm_for(file_off: int) -> str | None:
    d = ROOT / "code" / "MAPEDIT" / "disasm"
    hits = list(d.glob(f"func_{file_off:06X}_*.asm"))
    return hits[0].name if hits else None


def main() -> int:
    data = EXE.read_bytes()
    syms = parse_symbols(data)
    OUT.write_text(json.dumps(syms, indent=1, sort_keys=True) + "\n")
    print(f"parsed {len(syms)} symbols -> {OUT}")

    for q in sys.argv[1:]:
        # substring query
        for nm in sorted(syms):
            if q.lower() in nm.lower():
                r = syms[nm]
                extra = ""
                if r["kind"] == "data":
                    v = r.get("init_u16")
                    extra = f"  init_u16={v}" + (
                        f" (0x{v:04x})" if isinstance(v, int) else " [BSS]")
                else:
                    f = disasm_for(r["file_offset"])
                    extra = f"  disasm={f or '(none — at file 0x%06X)' % r['file_offset']}"
                print(f"{nm:34s} {r['kind']:4s} seg=0x{r['seg']:04x} "
                      f"off=0x{r['off']:04x} file=0x{r['file_offset']:06X}{extra}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
