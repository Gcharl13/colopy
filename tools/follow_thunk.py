#!/usr/bin/env python3
"""follow_thunk.py -- resolve an RTLink overlay thunk to its real target and
disassemble it, so "thunk-blocked" code paths can be read.

Mechanism (byte-verified against VICEROY.EXE, see tools/rtlink/RTLINK_V2.md):
each overlay call `LCALL seg:off` lands on a 7-byte THUNK STUB at the resident
file offset `0x2400 + seg*16 + off`. The stub is:
    LCALL 0x110D:0xD91     ; RTLink page-loader (pages in the overlay)
    LJMP  S:O              ; jump to the paged-in code at runtime segment S
- **Type-B (resident):** S:O is already in the always-loaded image; its file
  offset is `0x2400 + S*16 + O` -> disassemble directly.
- **Type-A (paged overlay):** S:O lives in an overlay page; the file offset is
  `overlay_pages[page_id].code_offset + (S<<4) + O` (per
  code/VICEROY/overlay_functions_reseg.json). The page_id must come from the
  call-site's page or the thunk directory -- the inline disasm "overlay @file"
  annotations are NOT reliable for Type-A (some point at data).

Needs `pip install capstone`. Usage:
    python tools/follow_thunk.py 0x181f 0x9a4      # resolve+disasm a thunk
    python tools/follow_thunk.py --at 0x05FE60     # disasm a file offset
"""
from __future__ import annotations
import argparse, re, json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXE = (ROOT / "raw/COLONIZE/VICEROY.EXE").read_bytes()
DIS = ROOT / "code/VICEROY/disasm"
CODE_BASE = 0x2400

def _md():
    from capstone import Cs, CS_ARCH_X86, CS_MODE_16
    return Cs(CS_ARCH_X86, CS_MODE_16)

def disasm_at(fo: int, n: int = 60, skip_pad: bool = True):
    md = _md()
    start = fo
    if skip_pad:
        while start < len(EXE) and EXE[start] == 0:
            start += 1
        if start != fo:
            print(f"  (skipped {start-fo} pad bytes -> 0x{start:06X})")
    for i, ins in enumerate(md.disasm(EXE[start:start+260], start)):
        if i >= n:
            break
        print(f"  {ins.address:06X}  {ins.mnemonic:7s} {ins.op_str}")

def callers(seg: int, off: int):
    pat = re.compile(rf"LCALL\s+0x{seg:x},\s*0x{off:x}\b", re.I)
    out = []
    for af in DIS.glob("*.asm"):
        m = re.search(r"func_([0-9A-Fa-f]{6})", af.name)
        for line in af.read_text(errors="replace").splitlines():
            if pat.search(line):
                am = re.match(r"^([0-9A-Fa-f]{6})", line.strip())
                out.append((m.group(1) if m else "?", am.group(1) if am else "?"))
    return out

def pages():
    rs = json.load(open(ROOT / "code/VICEROY/overlay_functions_reseg.json"))
    return [(int(v["code_offset"], 16), int(v["code_end"], 16)) for v in rs["pages"].values()]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("seg", nargs="?"); ap.add_argument("off", nargs="?")
    ap.add_argument("--at")
    a = ap.parse_args()
    if a.at:
        disasm_at(int(a.at, 16)); return
    seg, off = int(a.seg, 16), int(a.off, 16)
    cs = callers(seg, off)
    print(f"thunk 0x{seg:X}:0x{off:X} — {len(cs)} call site(s)"
          + ("  [shared utility — many callers]" if len(cs) > 6 else ""))
    for fn, addr in cs[:10]:
        print(f"  called from func_{fn} @ 0x{addr}")

    stub = CODE_BASE + seg*16 + off
    print(f"\nthunk stub @ file 0x{stub:06X}:")
    disasm_at(stub, n=3, skip_pad=False)
    # parse the LJMP S:O from the stub (EA off seg after the LCALL)
    b = EXE
    j = stub
    if b[j] == 0x9a:        # LCALL loader, skip 5 bytes
        j += 5
    if b[j] == 0xea:        # LJMP
        o = int.from_bytes(b[j+1:j+3], "little"); s = int.from_bytes(b[j+3:j+5], "little")
        resident = CODE_BASE + s*16 + o
        in_pages = any(cs0 <= resident < ce for cs0, ce in pages())
        kind = "Type-A (paged overlay)" if (s << 4) + o < 0x10000 and not in_pages else "Type-B (resident)"
        print(f"\n  -> LJMP {s:#06x}:{o:#06x}  ({kind})")
        if kind.startswith("Type-B"):
            print(f"  resident target file 0x{resident:06X}:")
            disasm_at(resident)
        else:
            print(f"  paged target runtime {s:#06x}:{o:#06x} — file = page.code_offset + {(s<<4)+o:#x}")
            print("  (resolve page_id via the call-site page / thunk directory; then --at <file_off>)")

if __name__ == "__main__":
    main()
