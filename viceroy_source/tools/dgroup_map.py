#!/usr/bin/env python3
"""
dgroup_map.py — characterise the initialized DGROUP data window of VICEROY.EXE
and surface the embedded data TABLES (vs strings).

Model derived + verified here:
  DGROUP DS segment = 0x1B5A (load-module-relative)
    proof: SMITEINDIANS is PUSHed as imm 0x1a1a and physically sits at file
    0x1f3ba; 0x1f3ba - 0x2400 - 0x1a1a = 0x1B5A0 = 0x1B5A<<4. So a DS:off datum
    is at file 0x1D9A0 + off, and DGROUP:0 == file 0x1D9A0.
  Initialized data spans file [0x1D9A0 .. 0x20665) == DS [0x0000 .. 0x2CC5).
  Everything the code reads at a DS offset >= ~0x2CC5 (map @0x853A, PowerRecord
  @0x8808, tribe @0x59D8, colony bits @0x5DCA, ...) is BSS: zero-filled at start
  and populated at runtime (often from NAMES.TXT / COLONY.TXT / TRIBE.TXT), so
  those tables are NOT static bytes in the EXE.

This tool prints the non-string ("table") runs inside the initialized window so
they can be byte-read and matched to accessors.
"""
import sys

from viceroy_exe import EXE

DG_BASE = 0x1D9A0           # file offset of DGROUP:0  (DS=0x1B5A)
DG_END = 0x20665            # overlay start == end of initialized image


def ds_to_foff(off):
    return DG_BASE + off


def foff_to_ds(foff):
    return foff - DG_BASE


def classify(exe):
    """Return list of runs: (kind, ds_start, ds_end, preview)."""
    d = exe.data
    # mark which bytes are inside a printable NUL-terminated string of len>=4
    instr = bytearray(DG_END - DG_BASE)
    i = DG_BASE
    while i < DG_END:
        b = d[i]
        if 0x20 <= b < 0x7f:
            j = i
            while j < DG_END and 0x20 <= d[j] < 0x7f:
                j += 1
            if j < DG_END and d[j] == 0 and (j - i) >= 4:
                for k in range(i, j + 1):
                    instr[k - DG_BASE] = 1
                i = j + 1
                continue
        i += 1
    # collapse into runs
    runs = []
    i = 0
    n = len(instr)
    while i < n:
        kind = "str" if instr[i] else "tab"
        j = i
        while j < n and (instr[j] == instr[i]):
            j += 1
        runs.append((kind, i, j))
        i = j
    return runs


def main(argv):
    exe = EXE()
    runs = classify(exe)
    tabs = [r for r in runs if r[0] == "tab" and (r[2] - r[1]) >= 6]
    print(f"DGROUP init window DS[0..0x{DG_END-DG_BASE:04x}) @ file 0x{DG_BASE:x}")
    print(f"non-string runs (>=6 bytes): {len(tabs)}\n")
    for kind, a, b in tabs:
        foff = ds_to_foff(a)
        ln = b - a
        raw = exe.hex(foff, min(ln, 24))
        words = " ".join(f"{exe.u16(foff+2*k):04x}" for k in range(min(ln // 2, 10)))
        print(f"  DS 0x{a:04x}..0x{b:04x}  (file 0x{foff:05x}, {ln:4d}B)")
        print(f"      bytes: {raw}{' ...' if ln > 24 else ''}")
        print(f"      words: {words}")


if __name__ == "__main__":
    main(sys.argv)
