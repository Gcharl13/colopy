#!/usr/bin/env python3
"""fix_overlay_sizes.py -- correct truncated overlay function sizes in
code/VICEROY/functions.json.

The per-function boundary detector recorded overlay sizes truncated at the FIRST
internal RETF (e.g. func_05B2C2 = 35 B recorded, 2926 B true). That made ~70% of
overlay code show as "unmapped gaps" on the coverage map, when it is really the
tails of functions already listed (and mostly already decoded in C).

overlay_functions_reseg.json holds the TRUE extents (deterministic RTLink
segment-descriptor method, mid-function-RETF guarded). This adopts those extents,
extends any overlay function the reseg list lacks up to the next boundary, and
caps every function at the next function start / its page code_end so nothing
overlaps. Load-image functions are untouched.
"""
from __future__ import annotations
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FJ = ROOT / "code/VICEROY/functions.json"

def O(s): return int(s, 16)

def main():
    data = json.load(open(FJ))
    fns = data["functions"]
    rs = json.load(open(ROOT / "code/VICEROY/overlay_functions_reseg.json"))
    reseg = {O(f["file_offset"]): f for f in rs["functions"]}
    pages = [(O(v["code_offset"]), O(v["code_end"])) for v in rs["pages"].values()]

    def page_end(x):
        for cs, ce in pages:
            if cs <= x < ce:
                return ce
        return None

    by_off = {O(f["file_offset"]): f for f in fns}

    # add reseg-only functions (in an overlay code page, not already listed)
    added = 0
    for off, rf in reseg.items():
        if off in by_off:
            continue
        if page_end(off) is None:
            continue
        nf = {"file_offset": f"0x{off:06X}", "size": rf["size"], "instructions": rf.get("instructions", 0),
              "region": "overlay", "name": "unknown",
              "asm_file": f"disasm/func_{off:06X}_unknown.asm", "status": "RESEG"}
        fns.append(nf); by_off[off] = nf; added += 1

    # candidate true end for every overlay function
    ov = sorted((O(f["file_offset"]), f) for f in fns if f["region"] == "overlay")
    starts = [o for o, _ in ov]
    import bisect
    corrected = 0
    for i, (off, f) in enumerate(ov):
        pe = page_end(off)
        if pe is None:
            continue
        # base extent: reseg true size if known, else extend to page end
        base_end = off + (reseg[off]["size"] if off in reseg else (pe - off))
        # cap at next overlay function start and at page code_end
        nxt = starts[i+1] if i+1 < len(starts) else pe
        end = min(base_end, nxt, pe)
        new_size = max(1, end - off)
        if new_size != f["size"]:
            f["size"] = new_size; corrected += 1

    json.dump(data, open(FJ, "w"), indent=2)
    print(f"corrected {corrected} overlay sizes; added {added} reseg-only functions")
    # report coverage
    span = sum(ce - cs for cs, ce in pages)
    cov = sum(f["size"] for f in fns if f["region"] == "overlay"
              and page_end(O(f["file_offset"])) is not None)
    print(f"overlay code coverage now ~{100*min(cov,span)/span:.0f}% (was 30%)")

if __name__ == "__main__":
    main()
