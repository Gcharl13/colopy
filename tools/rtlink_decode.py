#!/usr/bin/env python3
"""rtlink_decode.py -- decode VICEROY.EXE's RTLink Plus overlay layout.

The pending tool named in formats/RTLINK.md: parses the MZ header + the
thunk table, then derives the overlay-segment -> file-offset directory so
every thunk's linker-virtual target becomes a concrete file offset.

Method (all empirical, validated against byte-verified spec anchors):
  * TYPE-B thunks (lcall 0x110D:0xD91) carry a REAL seg:off in their LJMP:
    the target is image-resident and maps linearly,
        file = header_paras*16 + seg*16 + off            (= 0x2400 + ...)
    Anchor: thunk 0x718 -> ljmp 0x037F:0x04B0 -> file 0x60A0 = func_0060A0
    (the resource predicate, spec/systems/map_system.md "Prime resources").
  * TYPE-A thunks (lcall 0x110D:0xDAB) LJMP to a runtime-patched seg 0x0000;
    the trailer is  <segment_index:le16> [<para:le16>]  and the target is
        file = segment_file_base + para*16 + ljmp_off
    (para = 0 when the trailer is the short 2-byte form). The para word was
    discovered 2026-07-03: without it, pages whose thunks carry mixed para
    values (e.g. segment 0x15) cannot be fitted to a single base.
    Each segment's file base is fitted by maximizing function-prologue hits
    (ENTER / PUSH BP;MOV BP,SP) over paragraph-aligned candidates in the
    overlay region -- then pinned exactly where a byte-verified spec anchor
    identifies a thunk's target function (ANCHORS below); an anchor always
    wins over the blind fit (several pages are dominated by frameless leaf
    functions the prologue heuristic cannot see).

Anchors (byte-verified in spec/):
  thunk 0x0718 (type B)                -> 0x060A0 func_0060A0  map_system.md
  seg 0x03 base + 0x33A                -> 0x2D30A depletion    map_system.md
  thunk 0x0E1C (0x181F:0xE1C, A 0x15)  -> 0x67700 func_067700  map_view.md 6.3
  thunk 0x1896 (0x191F:0x896, A 0x15)  -> 0x672C8 func_0672C8  map_view.md 6.3
  thunk 0x123C (0x191F:0x23C, A 0x17)  -> 0x6C520 func_06C520  turn_dispatch.md 4
  thunk 0x1928 (0x191F:0x928, A 0x18)  -> 0x6F8FA func_06F8FA  turn_dispatch.md 4
  thunk 0x11A8 (0x191F:0x1A8, A 0x1F)  -> 0x789FA func_0789FA  turn_dispatch.md 4

Usage: python3 tools/rtlink_decode.py [--json out.json] [path/to/VICEROY.EXE]
"""
import json
import struct
import sys

DEF_EXE = "raw/COLONIZE/VICEROY.EXE"
TT0, TT1 = 0x1A5F0, 0x1D5E6          # thunk table (formats/RTLINK.md)

# Byte-verified thunk targets (table offset -> file offset); type-A entries
# pin their segment's base = file - para*16 - ljmp_off.
ANCHORS = {
    0x0718: 0x060A0,   # func_0060A0 (type B; validates the linear mapping)
    0x0E1C: 0x67700,   # func_067700 sidebar/HUD composer      (seg 0x15)
    0x1896: 0x672C8,   # func_0672C8 unit-panel data           (seg 0x15)
    0x123C: 0x6C520,   # func_06C520 message-box draw          (seg 0x17)
    0x1928: 0x6F8FA,   # func_06F8FA popup window fill         (seg 0x18)
    0x11A8: 0x789FA,   # func_0789FA resident string primitive (seg 0x1F)
}


def parse(exe_path):
    d = open(exe_path, "rb").read()
    _, lastpage, pages, _, hdr = struct.unpack_from("<HHHHH", d, 0)
    code_base = hdr * 16
    image_end = pages * 512 - (512 - lastpage if lastpage else 0)

    thunks, i = [], TT0
    while i < TT1 - 9:
        if d[i] == 0x9A and d[i + 1] in (0x91, 0xAB) and d[i + 3] == 0x0D \
           and d[i + 4] == 0x11 and d[i + 5] == 0xEA:
            typ = "B" if d[i + 1] == 0x91 else "A"
            off, seg = struct.unpack_from("<HH", d, i + 6)
            j = i + 10
            while j < TT1 and not (d[j] == 0x9A and d[j + 1] in (0x91, 0xAB)
                                   and d[j + 3] == 0x0D and d[j + 4] == 0x11):
                j += 1
            tr = d[i + 10:j]
            t = {"thunk": i - TT0, "type": typ, "seg": seg, "off": off,
                 "trailer": tr.hex()}
            if typ == "A" and len(tr) >= 2:
                t["overlay_segment"] = struct.unpack_from("<H", tr, 0)[0]
                t["para"] = struct.unpack_from("<H", tr, 2)[0] if len(tr) >= 4 else 0
            thunks.append(t)
            i = j
        else:
            i += 1

    def prologue(p):
        return p < len(d) and (d[p] == 0xC8 or (d[p] == 0x55 and d[p + 1] == 0x8B))

    # type-B: linear image mapping
    for t in thunks:
        if t["type"] == "B":
            t["file"] = code_base + t["seg"] * 16 + t["off"]
            t["prologue"] = prologue(t["file"])

    # type-A: group by overlay-segment index; file = base + para*16 + off
    groups = {}
    for t in thunks:
        if t["type"] == "A" and "overlay_segment" in t:
            groups.setdefault(t["overlay_segment"], []).append(t)

    # anchor-derived bases (byte-verified identifications win over the fit)
    anchor_bases = {}
    by_toff = {t["thunk"]: t for t in thunks}
    for toff, file in ANCHORS.items():
        t = by_toff.get(toff)
        if t is None or t["type"] != "A":
            continue
        b = file - t.get("para", 0) * 16 - t["off"]
        gi = t["overlay_segment"]
        prev = anchor_bases.get(gi)
        if prev is not None and prev != b:
            print(f"ANCHOR CONFLICT seg {gi:#x}: {prev:#x} vs {b:#x}")
        anchor_bases[gi] = b

    bases = {}
    for gi, ts in sorted(groups.items()):
        best = (0, None)
        for base in range(image_end & ~0xF, len(d), 16):
            hits = sum(1 for t in ts if prologue(base + t["para"] * 16 + t["off"]))
            if hits > best[0]:
                best = (hits, base)
        base = anchor_bases.get(gi, best[1])
        hits = sum(1 for t in ts if prologue(base + t["para"] * 16 + t["off"]))
        bases[gi] = {"base": base, "hits": hits, "thunks": len(ts),
                     "confidence": round(hits / max(1, len(ts)), 2),
                     "anchored": gi in anchor_bases,
                     "fit_base": best[1], "fit_hits": best[0]}
        for t in ts:
            t["file"] = (base or 0) + t["para"] * 16 + t["off"]
            t["prologue"] = prologue(t["file"])
    return d, code_base, image_end, thunks, bases


def main():
    args = sys.argv[1:]
    out_json = None
    if "--json" in args:
        k = args.index("--json")
        out_json = args[k + 1]
        del args[k:k + 2]
    exe = args[0] if args else DEF_EXE
    d, code_base, image_end, thunks, bases = parse(exe)

    nA = sum(1 for t in thunks if t["type"] == "A")
    nB = len(thunks) - nA
    okB = sum(1 for t in thunks if t["type"] == "B" and t.get("prologue"))
    print(f"{exe}: {len(thunks)} thunks ({nA} type-A overlay, {nB} type-B image-linear)")
    print(f"type-B linear mapping: {okB}/{nB} land on a function prologue")
    print(f"overlay segments: {len(bases)}")
    for gi, b in sorted(bases.items()):
        tag = " [anchored]" if b["anchored"] else ""
        print(f"  segment {gi:#04x}: file base {b['base']:#08x}"
              f"  ({b['hits']}/{b['thunks']} prologues, confidence {b['confidence']}){tag}")

    # validation anchors (byte-verified in spec/)
    by_toff = {t["thunk"]: t for t in thunks}
    ok = True
    for toff, want in sorted(ANCHORS.items()):
        t = by_toff.get(toff)
        got = t["file"] if t else -1
        good = got == want
        ok = ok and good
        print(f"anchor thunk {toff:#06x} -> {want:#07x}: "
              f"{'OK' if good else 'FAIL got ' + hex(got)}")
    a2 = bases.get(3, {}).get("base")
    ok2 = a2 is not None and a2 + 0x33A == 0x2D30A
    ok = ok and ok2
    print(f"anchor depletion scan (seg 3 + 0x33A -> 0x2D30A): {'OK' if ok2 else 'FAIL'}")

    if out_json:
        with open(out_json, "w") as f:
            json.dump({"code_base": code_base, "image_end": image_end,
                       "segments": bases, "thunks": thunks}, f, indent=1)
        print(f"wrote {out_json}")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
