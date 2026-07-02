#!/usr/bin/env python3
"""spec_coverage.py -- measure how much of spec/ is implemented, and where.

The specs carry byte anchors (@0xNNNNN sites, func_XXXXXX names) for every
verified formula. The implementation echoes those anchors in code comments and
cites the spec files in functions.json. This tool cross-references the two so
"what is implemented / what remains / what is referenced twice" is a REPORT,
not a manual search:

  - per spec file: how many of its byte anchors are echoed by the
    implementation (sim/ + forge/ comments, functions.json), whether any
    Systems card cites the file, and a status call (COVERED / PARTIAL / TODO /
    DATA-ONLY for format/reference docs with no formulas to implement);
  - anchors echoed from MORE THAN ONE implementation file (duplication watch);
  - a remaining-work list ordered by anchor count (a proxy for spec depth).

Usage: python3 tools/spec_coverage.py [--verbose]
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SPEC_DIRS = ["spec/systems", "spec/ui"]
IMPL_DIRS = ["viceroy_cpp/sim", "viceroy_cpp/forge"]
FUNCTIONS = "data_extracted/engine/functions.json"

# Spec files that are formats/reference/meta -- they document data or process,
# not formulas to implement, so zero code anchors is their correct end state.
DATA_ONLY = {
    "save.md", "map_system.md", "map_generation.md",  # formats + generator docs
    "tutorial.md",                                     # help text
}

ANCHOR = re.compile(r"@0x[0-9A-Fa-f]{4,6}\b|func_[0-9A-Fa-f]{5,6}\b")


def norm(a: str) -> str:
    """Normalize an anchor: @0x040656 == func_040656 == @0x40656 (leading zeros)."""
    h = a[3:] if a.startswith("@0x") else a[5:]
    return h.lstrip("0").lower() or "0"


def anchors_in(text: str) -> set:
    return {norm(m.group(0)) for m in ANCHOR.finditer(text)}


def read(path):
    with open(path, encoding="utf-8", errors="replace") as f:
        return f.read()


def main() -> int:
    verbose = "--verbose" in sys.argv
    os.chdir(ROOT)

    # 1. anchors per spec file
    spec_anchors = {}
    for d in SPEC_DIRS:
        for fn in sorted(os.listdir(d)):
            if fn.endswith(".md"):
                spec_anchors[os.path.join(d, fn)] = anchors_in(read(os.path.join(d, fn)))

    # 2. anchors per implementation file (code comments echo the byte citations)
    impl_anchors = {}           # anchor -> set of impl files
    for d in IMPL_DIRS:
        for base, _, files in os.walk(d):
            for fn in files:
                if not fn.endswith((".cpp", ".hpp")):
                    continue
                p = os.path.join(base, fn)
                for a in anchors_in(read(p)):
                    impl_anchors.setdefault(a, set()).add(p)
    fx = read(FUNCTIONS)
    for a in anchors_in(fx):
        impl_anchors.setdefault(a, set()).add(FUNCTIONS)

    # 3. which spec files the Systems cards cite
    cites = set()
    d = json.loads(fx)
    for s in d.get("systems", []):
        for m in re.finditer(r"spec/(?:systems|ui)/[a-z_]+\.md", s.get("spec", "")):
            cites.add(m.group(0))

    # 4. the report
    rows = []
    for path, anchors in spec_anchors.items():
        fn = os.path.basename(path)
        echoed = {a for a in anchors if a in impl_anchors}
        cited = path in cites
        if fn in DATA_ONLY:
            status = "DATA-ONLY"
        elif not anchors:
            status = "COVERED" if cited else "NO-ANCHORS"
        elif cited and echoed:
            status = "COVERED" if len(echoed) >= max(1, len(anchors) // 4) else "PARTIAL"
        elif echoed:
            status = "PARTIAL"
        else:
            status = "TODO"
        rows.append((status, path, len(echoed), len(anchors), cited))

    order = {"TODO": 0, "PARTIAL": 1, "NO-ANCHORS": 2, "COVERED": 3, "DATA-ONLY": 4}
    rows.sort(key=lambda r: (order[r[0]], -r[3]))
    print(f"{'status':<11} {'spec file':<42} {'echoed':>6}/{'anchors':<7} cited-in-Systems")
    print("-" * 84)
    for status, path, e, n, cited in rows:
        print(f"{status:<11} {path:<42} {e:>6}/{n:<7} {'yes' if cited else '-'}")

    todo = [r for r in rows if r[0] == "TODO"]
    partial = [r for r in rows if r[0] == "PARTIAL"]
    print("-" * 84)
    print(f"summary: {sum(1 for r in rows if r[0]=='COVERED')} covered, "
          f"{len(partial)} partial, {len(todo)} todo, "
          f"{sum(1 for r in rows if r[0]=='DATA-ONLY')} data-only, "
          f"{sum(1 for r in rows if r[0]=='NO-ANCHORS')} no-anchors "
          f"(of {len(rows)} spec files)")
    if todo:
        print("\nremaining (by spec depth):")
        for _, path, _, n, _ in todo:
            print(f"  {path}  ({n} byte anchors)")

    # 5. duplication watch: an anchor echoed from several implementation files
    if verbose:
        dups = {a: fs for a, fs in impl_anchors.items()
                if len({f for f in fs if f != FUNCTIONS}) > 1}
        if dups:
            print("\nanchors echoed by multiple implementation files (check for duplication):")
            for a, fs in sorted(dups.items()):
                print(f"  {a}: {', '.join(sorted(fs))}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
