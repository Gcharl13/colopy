#!/usr/bin/env python3
"""
coverage.py — quantify decompilation coverage by cross-referencing the @asm
citations in viceroy_source/src/**/*.c against the 1,248-function census.

For every function boundary (functions.json) we ask: does any source file cite a
file offset that falls inside it, and is that citation BYTE_VERIFIED? This turns
"what's left" into a hard number instead of an estimate.

Region split (file offsets):
  resident load image : 0x02400 .. 0x20665
  overlay region      : 0x20665 .. EOF
Output: re_work/coverage.json + a printed summary; also writes the markdown
table fragment used in docs/COVERAGE.md.
"""
import json
import os
import re
import sys

from viceroy_exe import EXE, _REPO

SRC = os.path.join(_REPO, "viceroy_source", "src")
OVERLAY_START = 0x20665

HEX = re.compile(r"0x0?([0-9A-Fa-f]{4,6})")
BV = re.compile(r"BYTE_VERIFIED", re.I)


def load_funcs():
    with open(os.path.join(_REPO, "re_work", "functions.json")) as f:
        funcs = json.load(f)
    funcs.sort(key=lambda x: x["foff"])
    return funcs


def func_of(funcs, off):
    """Return index of the function whose [foff,end) contains off, else None."""
    lo, hi = 0, len(funcs)
    while lo < hi:
        mid = (lo + hi) // 2
        if funcs[mid]["foff"] <= off:
            lo = mid + 1
        else:
            hi = mid
    i = lo - 1
    if 0 <= i < len(funcs) and funcs[i]["foff"] <= off < funcs[i]["end"]:
        return i
    return None


def main(argv):
    funcs = load_funcs()
    exe_len = len(EXE().data)
    cited = {}            # func idx -> {"bv":bool, "files":set}
    # scan source
    for root, _, files in os.walk(SRC):
        for fn in files:
            if not fn.endswith(".c"):
                continue
            path = os.path.join(root, fn)
            with open(path, errors="ignore") as f:
                text = f.read()
            rel = os.path.relpath(path, SRC)
            for m in HEX.finditer(text):
                off = int(m.group(1), 16)
                if off < 0x2400 or off > exe_len:
                    continue
                idx = func_of(funcs, off)
                if idx is None:
                    continue
                # is this citation line near a BYTE_VERIFIED marker?
                ls = text.rfind("\n", 0, m.start()) + 1
                le = text.find("\n", m.end())
                line = text[ls:le if le > 0 else len(text)]
                rec = cited.setdefault(idx, {"bv": False, "files": set()})
                rec["files"].add(rel)
                if BV.search(line) or BV.search(text[max(0, ls-200):ls]):
                    rec["bv"] = True

    n = len(funcs)
    res_funcs = [i for i, f in enumerate(funcs) if f["foff"] < OVERLAY_START]
    ovl_funcs = [i for i, f in enumerate(funcs) if f["foff"] >= OVERLAY_START]

    def tally(idxs):
        touched = sum(1 for i in idxs if i in cited)
        bv = sum(1 for i in idxs if cited.get(i, {}).get("bv"))
        return len(idxs), touched, bv

    print("VICEROY.EXE decompilation coverage\n")
    print(f"{'region':<12} {'funcs':>6} {'cited':>6} {'byte-verified':>14}")
    for name, idxs in [("resident", res_funcs), ("overlay", ovl_funcs),
                       ("ALL", list(range(n)))]:
        t, c, b = tally(idxs)
        print(f"{name:<12} {t:6d} {c:6d} {b:14d}  ({100*b//t}% bv, {100*c//t}% cited)")

    # files contributing the most verified functions
    out = {"total": n, "cited": len(cited),
           "bv": sum(1 for i in cited if cited[i]["bv"]),
           "byfunc": {funcs[i]["foff"]: {"bv": cited[i]["bv"],
                                         "files": sorted(cited[i]["files"])}
                      for i in cited}}
    with open(os.path.join(_REPO, "re_work", "coverage.json"), "w") as f:
        json.dump(out, f, indent=1)
    print(f"\nwrote re_work/coverage.json")
    print(f"functions with ANY @asm citation : {len(cited)} / {n}")
    print(f"functions with a BYTE_VERIFIED cite: {out['bv']} / {n}")


if __name__ == "__main__":
    main(sys.argv)
