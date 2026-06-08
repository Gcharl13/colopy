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
Every inter-segment call goes through a thunk in the table block at file
0x1A5F0 (aliased as seg 0x181F / 0x191F / 0x1A1F).  Three shapes:

  RESIDENT target (10 bytes):
      9A <loader off,seg>        ; call far the dynamic linker (0x110D:0x0D9x)
      EA <off:u16> <seg:u16>     ; jmp far  -> resolves NOW: foff(seg,off)

  OVERLAY target Type-B (12 bytes, loader at 0x110D:0x0D91):
      9A 91 0D 0D 11             ; call far Type-B loader
      EA <off:u16> 00 00         ; jmp far with a PLACEHOLDER segment
      <segid:u16>                ; RTLink overlay-segment id (patched at load)

  OVERLAY target Type-A (14 bytes, loader at 0x110D:0x0DAB):
      9A AB 0D 0D 11             ; call far Type-A loader
      EA <off:u16> 00 00         ; jmp far with a PLACEHOLDER segment
      <segid:u16>                ; RTLink overlay-segment id
      <extra:u16>                ; paragraph adjustment (added to resolved seg
                                 ; when overlay descriptor bit 6 is set; 0 if not)

  Confirmed by disassembling the loader at 0x1427B and the patching code at
  0x110D:0x1111.  The extra field: `add ax, es:[di+7]` (si=EA offset) then
  `mov es:[di+3], ax` patches the placeholder.  When extra==0 the patching is
  identical to Type-B.

  TYPE-A RESOLUTION:
    file_offset = base[segid] + extra * 16 + off
  TYPE-B RESOLUTION (and Type-A with extra==0):
    file_offset = base[segid] + off

  VERIFIED EXAMPLE — raw_power_score (func_039EE2):
    thunk at file 0x1B99A (0x191F:0x3AA):  off=0x0092, segid=5, extra=0x02B1
    base[5] = 0x037340  ->  0x037340 + 0x02B1*16 + 0x0092 = 0x039EE2  [confirmed]

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

Note: thunks with non-zero extra target a DIFFERENT effective base
(base + extra*16).  The fingerprint uses extra=0 thunks to recover the primary
base; thunks with extra≠0 require the explicit formula above.

Then any overlay call resolves as:  file_offset = base[segid] + extra*16 + offset.

Outputs:
  re_work/overlay_segmap.json   {segid: {base, match, total, second, confidence}}

CLI:
  python3 flatten.py                    # print the recovered map
  python3 flatten.py 5 0x92            # resolve overlay seg 5:0x92 (extra=0)
  python3 flatten.py 5 0x92 0x2b1      # resolve with explicit extra paragraph
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from viceroy_exe import EXE, _REPO

THUNK_SCAN_LO = 0x1A000      # covers the 0x181F/0x191F/0x1A1F thunk windows
THUNK_SCAN_HI = 0x1E000
OUT = os.path.join(_REPO, "re_work", "overlay_segmap.json")


TYPE_A_LOADER = (0xAB, 0x0D, 0x0D, 0x11)   # bytes [1..4] of a Type-A thunk
TYPE_B_LOADER = (0x91, 0x0D, 0x0D, 0x11)   # bytes [1..4] of a Type-B thunk


def scan_thunks(exe):
    """Return (overlay, resident, type_a_extras):
        overlay      = {segid: set(offset)}   EA placeholder-seg thunks (extra=0 only)
        resident     = [(seg, off, foff)]      EA real-seg thunks (validation)
        type_a_extra = {(segid,off): extra}   Type-A thunks with nonzero extra field
    """
    d = exe.data
    overlay, resident, type_a_extra = {}, [], {}
    i = THUNK_SCAN_LO
    while i < THUNK_SCAN_HI - 12:
        if d[i] == 0x9A and d[i + 5] == 0xEA:
            off = d[i + 6] | (d[i + 7] << 8)
            seg = d[i + 8] | (d[i + 9] << 8)
            # check loader variant
            loader_bytes = (d[i+1], d[i+2], d[i+3], d[i+4])
            is_type_a = (loader_bytes == TYPE_A_LOADER)
            if seg == 0x0000:
                segid = d[i + 10] | (d[i + 11] << 8)
                if is_type_a and i + 14 <= THUNK_SCAN_HI:
                    extra = d[i + 12] | (d[i + 13] << 8)
                    # Distinguish genuine extra from a 12-byte thunk (next thunk leaking in).
                    # A 12-byte Type-A thunk has bytes[12..13] == 9A AB (start of next thunk).
                    # A genuine extra field is never 0xAB9A (that value * 16 far exceeds the
                    # file size of ~480 KB).  Using the 0x9A boundary test is robust.
                    if extra and d[i + 12] != 0x9A:
                        type_a_extra[(segid, off)] = extra
                        i += 14
                        continue
                    # extra==0 or 12-byte thunk (extra bytes are next thunk): 12-byte advance
                    i += 12
                else:
                    i += 12
                # add to fingerprint only when extra==0 (primary base is extra-0 base)
                overlay.setdefault(segid, set()).add(off)
                continue
            else:
                resident.append((seg, off, exe.foff(seg, off)))
                i += 10
                continue
        i += 1
    return overlay, resident, type_a_extra


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
    overlay, _, _extras = scan_thunks(exe)
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


def resolve(exe, segmap, segid, off, extra=0):
    """Resolve overlay segid:off (with optional extra paragraph) to a file offset.
    Returns (file_offset, entry) or (None, None) if segid not in segmap.
    file_offset = base[segid] + extra*16 + off
    """
    e = segmap.get(segid)
    if not e:
        return None, None
    foff = e["base"] + extra * 16 + off
    return foff, e


def main(argv):
    exe = EXE()
    segmap = build_map(exe)

    if len(argv) >= 3:                       # resolve one seg:off [extra]
        segid = int(argv[1], 0)
        off = int(argv[2], 0)
        extra = int(argv[3], 0) if len(argv) >= 4 else 0
        foff, e = resolve(exe, segmap, segid, off, extra)
        if foff is None:
            print(f"seg {segid}: not resolved")
            return
        extra_note = f" extra={extra:#06x} (+{extra*16:#x}B)" if extra else ""
        print(f"overlay {segid}:{off:#06x}{extra_note} -> file {foff:#08x}  "
              f"(base {e['base']:#08x}, {e['confidence']})")
        print(exe.disasm_str(foff, 48))
        return

    # print the full map + validate resident thunks land on starts.
    # Resident EA targets are real seg:off into the resident image, so they must
    # hit resident function starts — an independent check that the thunk model
    # (and the foff translation) is correct.
    all_starts = func_starts(exe, overlay_only=False)
    _, resident, type_a_extras = scan_thunks(exe)
    rhit = sum(1 for _, _, fo in resident if fo in all_starts)
    print(f"overlay segments resolved: {len(segmap)}  "
          f"(STRONG {sum(1 for v in segmap.values() if v['confidence']=='STRONG')})")
    print(f"resident-thunk control: {rhit}/{len(resident)} land on function starts")
    print(f"Type-A thunks with nonzero extra field: {len(type_a_extras)}\n")
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
