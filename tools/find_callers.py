#!/usr/bin/env python3
"""find_callers.py -- reverse call-graph resolver for the RTLink-overlaid VICEROY.EXE.

Given a target FILE offset, report every way it is reached:
  (1) NEAR callers  -- E8 rel16 from within the target's own segment;
  (2) FAR  callers  -- 9A off:seg, matched against the thunk(s) whose ljmp lands
                        on the target (using each thunk's real lcall_seg:lcall_off
                        from tools/rtlink/viceroy_rtlink_map.json -- NOT a derived
                        0x181F:nnnn guess), plus any direct 9A to the target's own
                        loaded seg:off;
  (3) DATA refs     -- the thunk's lcall_off appearing as a 16-bit word in the
                        image (catches jump tables / function-pointer dispatch).

This unblocks overlay-dispatched handlers (e.g. func_03C638 succession) whose
callers a naive `9A ?? ?? 1F 18` scan misses.

Usage:  python3 tools/find_callers.py 0x3C638
"""
from __future__ import annotations
import json, struct, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXE = (ROOT / "raw/COLONIZE/VICEROY.EXE").read_bytes()
RMAP = json.load(open(ROOT / "tools/rtlink/viceroy_rtlink_map.json"))
SEGS = RMAP["segments"]
THUNKS = RMAP["thunk_table"]["thunks"]

def seg_of(file_off: int):
    """Return the segment record whose code window contains file_off, or None."""
    for s in SEGS:
        c = s["code_offset"]
        if c <= file_off < c + s["code_size"]:
            return s
    return None

def thunk_target_file(t):
    """File offset the thunk ljmps to (type A = paged, B = resident base 0x2400)."""
    if t["type"] == "B":
        base = 0x2400
    else:
        seg = next((s for s in SEGS if s["page_id"] == t["page_id"]), None)
        if not seg:
            return None
        base = seg["code_offset"]
    return base + (t["ljmp_seg"] << 4) + t["offset_in_segment"]

def find_bytes(pat: bytes):
    out, i = [], 0
    while True:
        i = EXE.find(pat, i)
        if i < 0:
            break
        out.append(i); i += 1
    return out

def main(target: int):
    print(f"== callers of file 0x{target:06X} ==")
    tseg = seg_of(target)
    print(f"target segment: page_id={tseg['page_id'] if tseg else '?'} "
          f"code=[{(tseg['code_offset'] if tseg else 0):#08x}..] "
          f"load_seg={tseg['load_segment'] if tseg else '?'}")

    # (1) NEAR callers within the same segment (E8 rel16; file off tracks seg off)
    near = []
    lo = tseg["code_offset"] if tseg else 0x2400
    hi = (tseg["code_offset"] + tseg["code_size"]) if tseg else len(EXE)
    for i in range(lo, hi - 2):
        if EXE[i] == 0xE8:
            rel = struct.unpack("<h", EXE[i + 1:i + 3])[0]
            if (i + 3 + rel) == target:
                near.append(i)
    print(f"\n(1) NEAR E8 callers (same segment): {[hex(x) for x in near] or 'none'}")

    # (2) FAR callers via the thunk(s) that ljmp to the target.
    # Caller-facing addr of a resident thunk at file F: F = 0x2400 + seg*16 + off,
    # with seg one of the RTLink stub segments and 0 <= off < 0x1000.
    def caller_addr(thunk_file):
        rel = thunk_file - 0x2400
        for seg in (0x181F, 0x191F, 0x1A1F):
            off = rel - seg * 16
            if 0 <= off < 0x1000:
                return seg, off
        return None, None

    thits = [t for t in THUNKS if thunk_target_file(t) == target]
    print(f"\n(2) thunks landing on target: {len(thits)}")
    far_total, dptr_total = [], []
    for t in thits:
        seg, off = caller_addr(t["file_offset"])
        if seg is None:
            print(f"   thunk @0x{t['file_offset']:05X}: caller seg:off not resolvable"); continue
        # far CALL to the thunk:  9A off_lo off_hi seg_lo seg_hi
        call_pat = b"\x9a" + struct.pack("<H", off) + struct.pack("<H", seg)
        calls = [x for x in find_bytes(call_pat) if x != t["file_offset"]]
        far_total += calls
        # far POINTER to the thunk stored as DATA (jump table / fn-ptr): off,seg dword
        ptr_pat = struct.pack("<H", off) + struct.pack("<H", seg)
        dptrs = [x for x in find_bytes(ptr_pat)
                 if x != t["file_offset"] and EXE[x - 1] != 0x9a]  # exclude the call form
        dptr_total += dptrs
        print(f"   thunk @0x{t['file_offset']:05X}  reached as lcall {seg:#06x}:{off:#06x}")
        print(f"      far-CALL sites:    {len(calls)}  {[hex(x) for x in calls[:12]]}")
        print(f"      far-PTR data refs: {len(dptrs)}  {[hex(x) for x in dptrs[:12]]}"
              f"{' (jump-table/fn-ptr dispatch)' if dptrs else ''}")

    if not far_total and not near and not dptr_total:
        print("\n=> NO near / far-call / far-pointer reference anywhere.")
        print("   The handler is either dead code, or dispatched via a NEAR jump")
        print("   table inside its own segment (search FF /4 /5 indexed jumps there).")
    print(f"\nsummary: {len(near)} near-call + {len(far_total)} far-call + "
          f"{len(dptr_total)} far-pointer site(s).")

if __name__ == "__main__":
    main(int(sys.argv[1], 16))
