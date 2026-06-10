#!/usr/bin/env python3
"""Resolve RTLink thunk targets from the raw VICEROY.EXE thunk table.

Derivation (byte-verified 2026-06-10, see VERIFICATION_LEDGER.md "Thunk-decode
rule" and docs/OVERLAY_THUNKS.md "segment model"):

  * One contiguous thunk table at file 0x1A5F0, addressed through overlapping
    segment windows:  file = seg*16 + 0x2400 + off  for seg in {0x181F, 0x191F,
    0x1A1F} (and plain code segments like 0x004B resolve the same way directly).
  * Each record:  9A <loader16> 0D 11  EA <payload...>
      loader 0x0D91 (Type-B, resident):  EA off16 seg16
            -> target file = seg16*16 + 0x2400 + off16
      loader 0x0DAB (Type-A, overlay):   EA off32, ovl16, trailer16
            -> target file = OVERLAY_BASE[ovl16] + off32
  * OVERLAY_BASE comes from re_work/overlay_segmap.json (keys are the ovl16
    values), with two bases corrected by two-anchor fits:
       ovl 21: 0x67080  (segmap said 0x66850; anchors func_0673CC/func_067476)
       ovl 26: 0x73270  (segmap said 0x26512; anchors func_073AB0/func_0745F0)

Verified pairs (rule cross-checks, all on real function starts):
  0x181F:0x04D4 -> 0x0C322 random_int          0x181F:0x035C -> 0x048CC clamp
  0x181F:0x09A4 -> 0x08110 (pricing.c trace)   0x1A1F:0x0434 -> 0x48F34
  0x1A1F:0x0634 -> 0x56A10                     0x1A1F:0x0618 -> 0x57A3A
  0x1A1F:0x0688 -> 0x6F61C                     0x191F:0x0AC8 -> 0x6C254 (lcr.c)

Usage:
  python3 viceroy_source/tools/resolve_thunks.py \
      [--exe re_work/VICEROY.EXE] [--segmap re_work/overlay_segmap.json] \
      [--fix-json viceroy_source/docs/thunk_signatures.json] [--check]

With --fix-json, rewrites each entry's overlay_file_offset to the derived
target and records the record kind; with --check it only reports mismatches.
NOTE: requires the user-supplied original VICEROY.EXE under re_work/ (never
committed); this tool only reads addresses from it, no content is embedded.
"""
import argparse, json, struct, sys

TABLE_FILE_BASE = 0x1A5F0          # = 0x181F*16 + 0x2400
SEG_WINDOWS = (0x181F, 0x191F, 0x1A1F)
HDR = 0x2400                        # EXE header size before the load image
BASE_OVERRIDES = {21: 0x67080, 26: 0x73270}
LOADER_RESIDENT = 0x0D91
LOADER_OVERLAY = 0x0DAB


def thunk_file_off(seg: int, off: int) -> int:
    return seg * 16 + HDR + off


def decode_record(exe: bytes, seg: int, off: int):
    """Return (kind, target_file_offset, detail) or (None, None, reason)."""
    pos = thunk_file_off(seg, off)
    rec = exe[pos:pos + 12]
    if len(rec) < 12 or rec[0] != 0x9A or rec[5] != 0xEA:
        return None, None, f"not a thunk record @0x{pos:05X}: {rec[:10].hex()}"
    loader = struct.unpack('<H', rec[1:3])[0]
    if loader == LOADER_RESIDENT:
        toff, tseg = struct.unpack('<HH', rec[6:10])
        return 'resident', tseg * 16 + HDR + toff, f"{tseg:04X}:{toff:04X}"
    if loader == LOADER_OVERLAY:
        toff = struct.unpack('<I', rec[6:10])[0]
        ovl = struct.unpack('<H', rec[10:12])[0]
        base = BASE_OVERRIDES.get(ovl)
        if base is None:
            base = SEGMAP.get(str(ovl), {}).get('base')
        if base is None:
            return 'overlay', None, f"ovl {ovl} +0x{toff:X} (no base)"
        conf = SEGMAP.get(str(ovl), {}).get('confidence', '?')
        if ovl in BASE_OVERRIDES:
            conf = 'ANCHORED'
        return 'overlay', base + toff, f"ovl {ovl} +0x{toff:X} ({conf})"
    return None, None, f"unknown loader 0x{loader:04X} @0x{pos:05X}"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--exe', default='re_work/VICEROY.EXE')
    ap.add_argument('--segmap', default='re_work/overlay_segmap.json')
    ap.add_argument('--fix-json', default=None)
    ap.add_argument('--check', action='store_true')
    args = ap.parse_args()

    global SEGMAP
    exe = open(args.exe, 'rb').read()
    SEGMAP = json.load(open(args.segmap))

    if not args.fix_json:
        print("nothing to do (pass --fix-json PATH and/or --check)")
        return 0

    sigs = json.load(open(args.fix_json))
    fixed = same = unresolved = skipped = 0
    for key, ent in sigs.items():
        try:
            seg_s, off_s = key.split(':')
            seg, off = int(seg_s, 16), int(off_s, 16)
        except ValueError:
            skipped += 1
            continue
        if seg not in SEG_WINDOWS:
            # plain code-segment far call (e.g. 0x004B): direct resolution
            tgt = seg * 16 + HDR + off
            kind, detail = 'direct', f"{seg:04X}:{off:04X}"
            if tgt >= len(exe):
                kind, tgt, detail = 'invalid', None, f"direct target beyond EOF ({seg:04X}:{off:04X})"
        else:
            kind, tgt, detail = decode_record(exe, seg, off)
            if tgt is not None and tgt >= len(exe):
                kind, tgt, detail = 'invalid', None, detail + " beyond EOF"
        if tgt is None:
            unresolved += 1
            ent['thunk_kind'] = kind or 'invalid'
            ent['resolve_note'] = detail
            continue
        old = ent.get('overlay_file_offset')
        if old != tgt:
            if args.check:
                print(f"{key}: json 0x{(old or 0):05X} != derived 0x{tgt:05X} ({kind} {detail})")
            ent['overlay_file_offset'] = tgt
            fixed += 1
        else:
            same += 1
        ent['thunk_kind'] = kind
        ent['resolve_note'] = detail
    if not args.check:
        json.dump(sigs, open(args.fix_json, 'w'), indent=1, sort_keys=True)
    print(f"entries: {len(sigs)}  corrected: {fixed}  already-correct: {same}  "
          f"unresolved: {unresolved}  skipped-keys: {skipped}",
          file=sys.stderr)
    return 0


if __name__ == '__main__':
    sys.exit(main())
