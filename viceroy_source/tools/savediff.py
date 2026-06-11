#!/usr/bin/env python3
"""
savediff.py -- byte-compare two COLONIZE save files (Phase 0.2 gate).

Exit 0 only when the files are identical outside the allowlist.  The
allowlist is the cataloged set of legitimately-divergent byte ranges
(timestamps); growing it requires a recorded justification -- the gate is
only as strong as the allowlist is small.

Region naming comes from an optional layout map (offset-range -> name) so a
diff reads as "PowerRecord[1].gold" instead of "offset 0x1A42".

Usage:
  python3 tools/savediff.py A.SAV B.SAV
  python3 tools/savediff.py A.SAV B.SAV --allow tools/save_allowlist.json \
      --layout tools/save_layout.json --max-report 32
"""
import json
import os
import sys


def load_ranges(path):
    """[{lo, hi, name, why?}] with lo inclusive, hi exclusive."""
    if not path or not os.path.exists(path):
        return []
    raw = json.load(open(path))
    out = []
    for r in raw:
        out.append({"lo": int(r["lo"], 0) if isinstance(r["lo"], str) else r["lo"],
                    "hi": int(r["hi"], 0) if isinstance(r["hi"], str) else r["hi"],
                    "name": r.get("name", "?"), "why": r.get("why", "")})
    return out


def find(ranges, off):
    for r in ranges:
        if r["lo"] <= off < r["hi"]:
            return r
    return None


def main(argv):
    args, skip = [], False
    for i, a in enumerate(argv):
        if skip:
            skip = False
            continue
        if a.startswith("--"):
            skip = True  # all options take a value
            continue
        args.append(a)
    if len(args) != 2:
        print(__doc__)
        return 2
    a_path, b_path = args

    def opt(name, default=None):
        return argv[argv.index(name) + 1] if name in argv else default

    allow = load_ranges(opt("--allow"))
    layout = load_ranges(opt("--layout"))
    max_report = int(opt("--max-report", "32"))

    a = open(a_path, "rb").read()
    b = open(b_path, "rb").read()
    if len(a) != len(b):
        print(f"SIZE DIFF: {a_path}={len(a)}  {b_path}={len(b)}")
        return 1

    diffs, allowed = [], 0
    run_start = None
    for i in range(len(a) + 1):
        differs = i < len(a) and a[i] != b[i]
        if differs and run_start is None:
            run_start = i
        elif not differs and run_start is not None:
            lo, hi = run_start, i
            run_start = None
            ar = find(allow, lo)
            if ar and find(allow, hi - 1) is ar:
                allowed += 1
                continue
            diffs.append((lo, hi))

    if not diffs:
        print(f"IDENTICAL outside allowlist "
              f"({allowed} allowed run(s)); size {len(a)}")
        return 0

    print(f"DIVERGENT: {len(diffs)} run(s) outside allowlist "
          f"({allowed} allowed):")
    for lo, hi in diffs[:max_report]:
        nm = find(layout, lo)
        where = f"  [{nm['name']}]" if nm else ""
        av = a[lo:min(hi, lo + 8)].hex()
        bv = b[lo:min(hi, lo + 8)].hex()
        print(f"  0x{lo:06X}..0x{hi:06X} ({hi - lo:>4}B){where}  {av} != {bv}")
    if len(diffs) > max_report:
        print(f"  ... and {len(diffs) - max_report} more")
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
