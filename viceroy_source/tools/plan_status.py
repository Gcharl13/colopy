#!/usr/bin/env python3
"""
plan_status.py -- the single honest progress readout for ROUTE_B_PLAN.md.

Prints, in one table:
  - per-phase checkbox state parsed from docs/ROUTE_B_PLAN.md
  - the live inventory counters the plan's no-new-items contract rests on
    (link-gap, thunk wiring, arity truth, cite hygiene), read from their
    generated artifacts when present.

This replaces narrative progress claims: if it is not green here, it is
not done.

Usage:  python3 viceroy_source/tools/plan_status.py
"""
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from portlib import REPO, RE_WORK

DOCS = os.path.join(REPO, "viceroy_source", "docs")
PLAN = os.path.join(DOCS, "ROUTE_B_PLAN.md")


def plan_phases():
    phase = None
    out = []  # (phase_title, done, total)
    for line in open(PLAN, errors="ignore"):
        m = re.match(r"^## (Phase [0-9].*?)\s*(?:\(|$)", line)
        if m:
            phase = m.group(1).strip()
            out.append([phase, 0, 0])
            continue
        if phase and re.match(r"^- \[( |x|X)\]", line):
            out[-1][2] += 1
            if line[3].lower() == "x":
                out[-1][1] += 1
    return out


def grep_int(path, rx, default=None):
    if not os.path.exists(path):
        return default
    m = re.search(rx, open(path, errors="ignore").read())
    return int(m.group(1)) if m else default


def main():
    print("ROUTE B STATUS")
    print("=" * 64)
    total_d = total_t = 0
    for title, done, tot in plan_phases():
        bar = "#" * done + "." * (tot - done)
        print(f"{title:<44} {done:>2}/{tot:<2} {bar}")
        total_d += done
        total_t += tot
    print("-" * 64)
    print(f"{'PLAN ITEMS':<44} {total_d:>2}/{total_t}")

    print("\nINVENTORY COUNTERS (no-new-items contract)")
    print("=" * 64)
    lg = os.path.join(DOCS, "LINK_GAP.md")
    tw = os.path.join(DOCS, "THUNK_WIRING.md")
    rows = [
        ("undefined symbols in lib",
         grep_int(lg, r"`libviceroy_rules\.a`: \*\*(\d+)\*\*")),
        ("  func bodies missing",
         grep_int(lg, r"func_body \| (\d+)")),
        ("thunk stubs referenced",
         grep_int(tw, r"referenced by the lib: \*\*(\d+)\*\*")),
        ("  wired", grep_int(tw, r"real ported function\): (\d+)")),
        ("  mid-function entries",
         grep_int(tw, r"needs entry split\) — (\d+)")),
    ]
    at = os.path.join(RE_WORK, "arity_truth.json")
    if os.path.exists(at):
        d = json.load(open(at))
        mixed = sum(1 for r in d["rows"] if r["arity"].startswith("MIXED"))
        rows.append(("thunks with call-site arity truth", len(d["rows"])))
        rows.append(("  MIXED needing review", mixed))
    for name, val in rows:
        print(f"{name:<44} {val if val is not None else '?':>6}")
    print("\n(cite hygiene: run tools/cite_check.py --all; "
          "decode sheets: tools/decode_sheet.py)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
