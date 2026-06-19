#!/usr/bin/env python3
"""follow_thunk.py -- resolve an RTLink overlay thunk to its target FILE offset
and disassemble it. Now backed by the pre-computed thunk table in
tools/rtlink/viceroy_rtlink_map.json (1023 thunks), so type-A (paged) targets
resolve correctly -- the inline disasm "overlay @file" annotations did not.

Resolution (byte-validated: ~89% of thunks land on a clean function prologue):
    base = 0x2400                              (type-B, resident) OR
           segments[page_id-1].code_offset     (type-A, paged overlay)
    target_file_offset = base + ljmp_seg*16 + offset_in_segment

Subcommands:
    python tools/follow_thunk.py 0x181f 0x9a4   # resolve a thunk seg:off + disasm
    python tools/follow_thunk.py --at 0x39EE2   # disasm a file offset
    python tools/follow_thunk.py --emit         # write data_extracted/thunk_targets.json
"""
from __future__ import annotations
import argparse, json, re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXE = (ROOT / "raw/COLONIZE/VICEROY.EXE").read_bytes()
DIS = ROOT / "code/VICEROY/disasm"
RMAP = json.load(open(ROOT / "tools/rtlink/viceroy_rtlink_map.json"))
SEGS = {s["page_id"]: s for s in RMAP["segments"]}
THUNKS = {t["file_offset"]: t for t in RMAP["thunk_table"]["thunks"]}

def resolve_stub(stub: int):
    """stub file offset -> (type, target_file_offset) or (None, None)."""
    t = THUNKS.get(stub)
    if not t:
        return None, None
    base = 0x2400 if t["type"] == "B" else SEGS[t["page_id"]]["code_offset"]
    return t["type"], base + (t["ljmp_seg"] << 4) + t["offset_in_segment"]

def resolve(seg: int, off: int):
    return resolve_stub(0x2400 + seg * 16 + off)

def disasm_at(fo: int, n: int = 60):
    from capstone import Cs, CS_ARCH_X86, CS_MODE_16
    md = Cs(CS_ARCH_X86, CS_MODE_16)
    s = fo
    while s < len(EXE) and EXE[s] in (0, 0x90):
        s += 1
    if s != fo:
        print(f"  (skipped {s-fo} pad -> 0x{s:06X})")
    for i, ins in enumerate(md.disasm(EXE[s:s+260], s)):
        if i >= n:
            break
        print(f"  {ins.address:06X}  {ins.mnemonic:7s} {ins.op_str}")

def callers(seg, off):
    pat = re.compile(rf"LCALL\s+0x{seg:x},\s*0x{off:x}\b", re.I)
    out = []
    for af in DIS.glob("*.asm"):
        m = re.search(r"func_([0-9A-Fa-f]{6})", af.name)
        for line in af.read_text(errors="replace").splitlines():
            if pat.search(line):
                am = re.match(r"^([0-9A-Fa-f]{6})", line.strip())
                out.append((m.group(1) if m else "?", am.group(1) if am else "?"))
    return out

def emit():
    out = {}
    for t in RMAP["thunk_table"]["thunks"]:
        base = 0x2400 if t["type"] == "B" else SEGS[t["page_id"]]["code_offset"]
        tgt = base + (t["ljmp_seg"] << 4) + t["offset_in_segment"]
        # the thunk's own seg:off (resident table addr -> seg:off it answers for)
        out[f"{t['file_offset']:06X}"] = {
            "type": t["type"], "page_id": t.get("page_id"),
            "target_file_offset": f"0x{tgt:06X}",
        }
    p = ROOT / "data_extracted/thunk_targets.json"
    p.write_text(json.dumps({"_note": "RTLink thunk stub file_offset -> resolved "
                             "target file offset (tools/follow_thunk.py --emit)",
                             "count": len(out), "thunks": out}, indent=2))
    print(f"wrote {p.relative_to(ROOT)} ({len(out)} thunks)")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("seg", nargs="?"); ap.add_argument("off", nargs="?")
    ap.add_argument("--at"); ap.add_argument("--emit", action="store_true")
    a = ap.parse_args()
    if a.emit:
        emit(); return
    if a.at:
        disasm_at(int(a.at, 16)); return
    seg, off = int(a.seg, 16), int(a.off, 16)
    cs = callers(seg, off)
    print(f"thunk 0x{seg:X}:0x{off:X} — {len(cs)} call site(s)"
          + ("  [shared utility]" if len(cs) > 6 else ""))
    for fn, addr in cs[:8]:
        print(f"  called from func_{fn} @ 0x{addr}")
    kind, tgt = resolve(seg, off)
    if tgt is None:
        print("  (thunk not in rtlink map)"); return
    print(f"\n  Type-{kind} -> target file 0x{tgt:06X}:")
    disasm_at(tgt)

if __name__ == "__main__":
    main()
