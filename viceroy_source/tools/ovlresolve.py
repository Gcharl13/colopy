#!/usr/bin/env python3
"""ovlresolve.py -- resolve RTLink thunk references to file offsets.

Decodes the stub records that overlay/resident calls go through, from the
USER-SUPPLIED VICEROY.EXE (../game_data/VICEROY.EXE by default; nothing is
embedded in the repo).

Three reference shapes (all verified against known ported functions; the
self-test below re-checks the calibration set on every run):

1. RESIDENT thunks  (seg 0x181F):
     record at file 0x2400 + 0x181F*16 + off:
       9A ll ll hh hh  EA oo oo ss ss      (ss != 0)
     -> target file = 0x2400 + ss*16 + oo
   e.g. 0x181F:0x72C -> 037F:010E -> file 0x005CFE (func_005CFE, terrain).

2. OVERLAY records  (seg 0x191F, 0x1A1F, ...):
     record at file 0x2400 + seg*16 + off:
       9A AB 0D 0D 11  EA oo oo 00 00  pp 00 [xx xx]
     -> target file = segmap[pp].base + oo
     The optional trailer xx (type-A "extra") selects an RTLink SUB-SEGMENT
     when non-zero -- the sub-segment directory decode is still open; such
     records are reported with the raw trailer instead of a file offset.
   e.g. 0x191F:0x840 -> page 2 + 0xFCE -> file 0x0268CE (colony title).

3. PAGE-TAIL trampolines: a near call inside a page lands on
       EA oo oo ss ss   (JMP FAR seg:off)
   at file <page_image> + <near IP>; resolve the seg:off per 1/2.

Usage:
  python3 tools/ovlresolve.py 0x191F:0x840 0x1A1F:0x142 ...
  python3 tools/ovlresolve.py --selftest
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
EXE = os.environ.get("VICEROY_EXE",
                     os.path.join(HERE, "..", "..", "game_data", "VICEROY.EXE"))
SEGMAP = os.path.join(HERE, "..", "..", "re_work", "overlay_segmap.json")


def load():
    with open(EXE, "rb") as f:
        data = f.read()
    with open(SEGMAP) as f:
        segmap = json.load(f)
    return data, segmap


def resolve(data, segmap, seg, off):
    """Return (kind, target_file_or_None, detail_str)."""
    rec_at = 0x2400 + seg * 16 + off
    rec = data[rec_at:rec_at + 14]
    if len(rec) < 12 or rec[0] != 0x9A:
        return ("bad", None, f"no record at {rec_at:#x}: {rec.hex(' ')}")
    if rec[5] != 0xEA:
        return ("bad", None, f"no jmpf at {rec_at:#x}+5: {rec.hex(' ')}")
    oo = rec[6] | (rec[7] << 8)
    ss = rec[8] | (rec[9] << 8)
    if ss:                                   # resident: direct seg:off
        tgt = 0x2400 + ss * 16 + oo
        return ("resident", tgt, f"{ss:04X}:{oo:04X}")
    page = rec[10] | (rec[11] << 8)
    # type-A trailer "extra" word: records pack at 12 bytes when absent, so
    # a following record-start marker (9A AB / 9A 91 = lcall manager) means
    # there is no extra on THIS record.
    extra = rec[12] | (rec[13] << 8) if len(rec) >= 14 else 0
    if rec[12] == 0x9A and rec[13] in (0xAB, 0x91):
        extra = 0
    ps = segmap.get(str(page))
    if ps is None:
        return ("overlay", None, f"page {page} not in segmap (raw {rec.hex(' ')})")
    if extra:                                # sub-segment selector: open decode
        return ("subseg", None,
                f"page {page} + {oo:#x}, SUB-SEGMENT {extra:#x} "
                f"(directory decode pending)")
    return ("overlay", ps["base"] + oo,
            f"page {page} ({ps['confidence']}) + {oo:#x}")


# (seg, off) -> expected target file; every entry independently verified
# against a ported/cited function in the tree.
CALIBRATION = {
    (0x181F, 0x72C): 0x005CFE,   # func_005CFE terrain read (naval_classify)
    (0x181F, 0x6BE): 0x005FD4,   # func_005FD4 owner_at
    (0x181F, 0x7E0): 0x0066CC,   # func_0066CC occupant_at
    (0x181F, 0x754): 0x005D32,   # func_005D32 feature read (move_cost)
    (0x181F, 0x78C): 0x00627A,   # func_00627A terrain class (move_cost)
    (0x191F, 0x840): 0x0268CE,   # colony title painter (composer table)
    (0x191F, 0x5C4): 0x0270D0,   # colonist row painter
    (0x191F, 0x654): 0x0281D6,   # stockpile painter
    (0x191F, 0x4E0): 0x02701C,   # buildings loop
    (0x191F, 0x0E4): 0x021A14,   # spring_turn_process (turn_step picker B)
    (0x191F, 0x06C): 0x0217E2,   # begin-Autumn trigger (turn_step picker A)
    (0x1A1F, 0x142): 0x03ECF0,   # unit-move executor (landfall commit)
}


def selftest(data, segmap):
    bad = 0
    for (seg, off), want in sorted(CALIBRATION.items()):
        kind, tgt, detail = resolve(data, segmap, seg, off)
        ok = (tgt == want)
        bad += (not ok)
        print(f"  [{'PASS' if ok else 'FAIL'}] {seg:04X}:{off:04X} -> "
              f"{detail}  = {tgt:#08x} (want {want:#08x})" if tgt is not None
              else f"  [FAIL] {seg:04X}:{off:04X} -> {detail}")
    print(f"selftest: {len(CALIBRATION) - bad}/{len(CALIBRATION)} pass")
    return 1 if bad else 0


def main(argv):
    data, segmap = load()
    if not argv or argv[0] == "--selftest":
        return selftest(data, segmap)
    for a in argv:
        seg, off = (int(x, 16) for x in a.split(":"))
        kind, tgt, detail = resolve(data, segmap, seg, off)
        line = f"{seg:04X}:{off:04X}  [{kind}]  {detail}"
        if tgt is not None:
            line += f"  -> file {tgt:#08x}"
        print(line)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
