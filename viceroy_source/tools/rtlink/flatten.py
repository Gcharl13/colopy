#!/usr/bin/env python3
"""
rtlink/flatten.py — static RTLink/Plus v2 overlay flattener for VICEROY.EXE.

Recovers the overlay SEGMENT-ID -> FILE-OFFSET map so that overlay-only call
targets (reached through the thunk table) resolve to a concrete file offset,
WITHOUT a runtime dump.  This is the piece the coverage notes called the
"missing RTLink V2 flattener".

------------------------------------------------------------------------------
How RTLink overlay calls work in this image
------------------------------------------------------------------------------
Every inter-segment call goes through a 10/12-byte thunk in the table block at
file 0x1A5F0 (aliased as seg 0x181F / 0x191F / 0x1A1F).  Two shapes:

  RESIDENT target (10 bytes):
      9A <loader off,seg>        ; call far the dynamic linker (0x110D:0x0D9x)
      EA <off:u16> <seg:u16>     ; jmp far  -> resolves NOW: foff(seg,off)

  OVERLAY target (12 bytes):
      9A <loader off,seg>        ; call far the dynamic linker
      EA <off:u16> 00 00         ; jmp far with a PLACEHOLDER segment (0x0000)
      <segid:u16>                ; RTLink overlay-segment id (patched at load)

  The loader, on first hit, loads overlay segment `segid`, patches the EA
  placeholder with the runtime segment, and the jmp proceeds to <seg>:<off>.

------------------------------------------------------------------------------
The fingerprint that recovers segid -> file base
------------------------------------------------------------------------------
The overlay code is already present in the file at fixed offsets (funcscan finds
706 overlay functions).  Each overlay segment occupies a contiguous file region;
the thunk OFFSETS targeting a given segid are exactly the segment-relative
offsets of the routines called within it — and most of those are FUNCTION
STARTS.  So for each segid we collect its set of thunk offsets {o_i} and find the
file base F that maximises | {F + o_i} ∩ function_starts |.  The winning F is
dominant and unambiguous for every segment with enough thunks (see confidence).

Then any overlay call resolves as:  file_offset = base[segid] + offset.

Outputs:
  re_work/overlay_segmap.json   {segid: {base, match, total, second, confidence}}

CLI:
  python3 flatten.py                 # print the recovered map
  python3 flatten.py 5 0x92          # resolve overlay seg 5 : offset 0x92
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from viceroy_exe import EXE, _REPO

THUNK_SCAN_LO = 0x1A000      # covers the 0x181F/0x191F/0x1A1F thunk windows
THUNK_SCAN_HI = 0x1E000
OUT = os.path.join(_REPO, "re_work", "overlay_segmap.json")


def scan_thunks(exe):
    """Return (overlay, resident):
        overlay  = {segid: set(offset)}     EA placeholder-seg thunks
        resident = [(seg, off, foff)]       EA real-seg thunks (for validation)
    """
    d = exe.data
    overlay, resident = {}, []
    i = THUNK_SCAN_LO
    while i < THUNK_SCAN_HI - 12:
        if d[i] == 0x9A and d[i + 5] == 0xEA:
            off = d[i + 6] | (d[i + 7] << 8)
            seg = d[i + 8] | (d[i + 9] << 8)
            if seg == 0x0000:
                segid = d[i + 10] | (d[i + 11] << 8)
                overlay.setdefault(segid, set()).add(off)
                i += 12
                continue
            else:
                resident.append((seg, off, exe.foff(seg, off)))
                i += 10
                continue
        i += 1
    return overlay, resident


def func_starts(exe, overlay_only=True):
    fj = json.load(open(os.path.join(_REPO, "re_work", "functions.json")))
    if overlay_only:
        return set(fn["foff"] for fn in fj if fn["foff"] > exe.image_len)
    return set(fn["foff"] for fn in fj)


def fingerprint(segid, offs, starts, lo, hi):
    """Best file base for `segid` = argmax over candidate bases of the number of
    (base + offset) values that hit an exact function start.  Returns
    (base, match, total, second_best_match)."""
    cand = {}
    for fs in starts:
        for o in offs:
            F = fs - o
            if lo < F < hi:
                cand[F] = cand.get(F, 0) + 1
    if not cand:
        return None
    ranked = sorted(cand.items(), key=lambda x: -x[1])
    base, match = ranked[0]
    second = ranked[1][1] if len(ranked) > 1 else 0
    return base, match, len(offs), second


def confidence(match, total, second):
    if match >= max(3, 0.5 * total) and match > second:
        return "STRONG"
    if match > second:
        return "weak"
    return "AMBIG"


def build_map(exe):
    starts = func_starts(exe)
    overlay, _ = scan_thunks(exe)
    lo, hi = exe.image_len, len(exe.data)
    out = {}
    for segid, offs in overlay.items():
        # drop scan false positives (single-thunk garbage ids)
        if len(offs) < 2 and segid > 0x40:
            continue
        r = fingerprint(segid, offs, starts, lo, hi)
        if not r:
            continue
        base, match, total, second = r
        out[segid] = {
            "base": base, "match": match, "total": total,
            "second": second, "confidence": confidence(match, total, second),
        }
    return out


def main(argv):
    exe = EXE()
    segmap = build_map(exe)

    if len(argv) >= 3:                       # resolve one seg:off
        segid = int(argv[1], 0)
        off = int(argv[2], 0)
        e = segmap.get(segid)
        if not e:
            print(f"seg {segid}: not resolved")
            return
        foff = e["base"] + off
        print(f"overlay {segid}:{off:#06x} -> file {foff:#08x}  "
              f"(base {e['base']:#08x}, {e['confidence']})")
        print(exe.disasm_str(foff, 48))
        return

    # print the full map + validate resident thunks land on starts.
    # Resident EA targets are real seg:off into the resident image, so they must
    # hit resident function starts — an independent check that the thunk model
    # (and the foff translation) is correct.
    all_starts = func_starts(exe, overlay_only=False)
    _, resident = scan_thunks(exe)
    rhit = sum(1 for _, _, fo in resident if fo in all_starts)
    print(f"overlay segments resolved: {len(segmap)}  "
          f"(STRONG {sum(1 for v in segmap.values() if v['confidence']=='STRONG')})")
    print(f"resident-thunk control: {rhit}/{len(resident)} land on function starts\n")
    print(f"{'seg':>4} {'file_base':>10} {'match':>9}  confidence")
    for segid in sorted(segmap):
        v = segmap[segid]
        print(f"{segid:>4} {v['base']:#010x} {v['match']:>4}/{v['total']:<3} "
              f"{v['confidence']}")

    with open(OUT, "w") as f:
        json.dump({str(k): v for k, v in segmap.items()}, f, indent=1)
    print(f"\nwrote {OUT}")


if __name__ == "__main__":
    main(sys.argv)
