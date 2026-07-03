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
    the FIRST LE16 WORD OF THE TRAILER IS THE OVERLAY-SEGMENT INDEX. Each
    index's file base is fitted by maximizing function-prologue hits
    (ENTER C8..00 / PUSH BP;MOV BP,SP) across the group's target offsets
    over paragraph-aligned candidates in the overlay region.
    Anchor: segment 3 + 0x33A -> file 0x2D30A = the mine-depletion scan
    (spec/systems/map_system.md "Depletion writer").

Usage: python3 tools/rtlink_decode.py [--json out.json] [path/to/VICEROY.EXE]
"""
import json
import struct
import sys

DEF_EXE = "raw/COLONIZE/VICEROY.EXE"
TT0, TT1 = 0x1A5F0, 0x1D5E6          # thunk table (formats/RTLINK.md)


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
            thunks.append({"thunk": i - TT0, "type": typ, "seg": seg,
                           "off": off, "trailer": d[i + 10:j].hex()})
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

    # type-A: group by trailer word = overlay segment index, fit bases
    groups = {}
    for t in thunks:
        if t["type"] == "A" and len(t["trailer"]) >= 4:
            gi = struct.unpack("<H", bytes.fromhex(t["trailer"][:4]))[0]
            groups.setdefault(gi, []).append(t)
    bases = {}
    for gi, ts in sorted(groups.items()):
        offs = [t["off"] for t in ts]
        best = (0, None)
        for base in range(image_end & ~0xF, len(d), 16):
            hits = sum(1 for o in offs if prologue(base + o))
            if hits > best[0]:
                best = (hits, base)
        bases[gi] = {"base": best[1], "hits": best[0], "thunks": len(offs),
                     "confidence": round(best[0] / max(1, len(offs)), 2)}
        for t in ts:
            t["overlay_segment"] = gi
            t["file"] = (best[1] or 0) + t["off"]
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
    print(f"overlay segments fitted: {len(bases)}")
    for gi, b in sorted(bases.items()):
        print(f"  segment {gi:#04x}: file base {b['base']:#08x}"
              f"  ({b['hits']}/{b['thunks']} prologues, confidence {b['confidence']})")

    # validation anchors (byte-verified in spec/systems/map_system.md)
    a1 = next(t for t in thunks if t["thunk"] == 0x718)
    ok1 = a1["file"] == 0x60A0
    a2 = bases.get(3, {}).get("base")
    ok2 = a2 is not None and a2 + 0x33A == 0x2D30A
    print(f"anchor func_0060A0 (thunk 0x718 -> 0x60A0): {'OK' if ok1 else 'FAIL ' + hex(a1['file'])}")
    print(f"anchor depletion scan (seg 3 + 0x33A -> 0x2D30A): {'OK' if ok2 else 'FAIL'}")

    if out_json:
        with open(out_json, "w") as f:
            json.dump({"code_base": code_base, "image_end": image_end,
                       "segments": bases, "thunks": thunks}, f, indent=1)
        print(f"wrote {out_json}")
    return 0 if (ok1 and ok2) else 1


if __name__ == "__main__":
    sys.exit(main())
