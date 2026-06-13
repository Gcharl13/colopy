#!/usr/bin/env python3
"""
g4_floor.py -- the machine check for Gate G4's link-active stub floor.

`tools/active_stubs.sh` reports the weak symbols that survive un-overridden into
the FINAL link (the only stubs that can actually be hit at runtime). This tool
turns that into a regression gate:

  1. Collect link-active weak `func_` stubs from `nm viceroy_modern`.
  2. Assert each is listed in docs/g4_interactive_floor.json (the committed
     allowlist of interactive-only entries). A NEW unlisted func_ stub FAILS
     the gate -- that is the no-new-items contract for the stub floor.
  3. Report the named/overlay-thunk buckets (the display surface, Phase-7-gated)
     for visibility; these are not gated here -- Phase 7.1/7.2 exercise them and
     the runtime stub-hit counter (tools/stub_hits.c) is the live zero check.

The OPERATIVE Gate-G4 test ("zero gameplay-reachable weak stubs") is the runtime
counter: `--smoke=500` must report `stub-hits: 0`. This tool is the STATIC
companion: it pins WHICH stubs remain and proves none is a surprise.

Usage:  python3 tools/g4_floor.py [path/to/viceroy_modern]
Exit 0 = floor matches the allowlist; 1 = an unlisted func_ stub appeared.
"""
import json
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
EXE = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "build_modern", "viceroy_modern")
ALLOW = os.path.join(ROOT, "docs", "g4_interactive_floor.json")


def link_active_weak(exe):
    out = subprocess.run(["nm", exe], capture_output=True, text=True).stdout
    syms = set()
    for ln in out.splitlines():
        p = ln.split()
        if len(p) >= 3 and p[-2] in ("W", "w"):
            syms.add(p[-1])
    return syms


def main():
    if not os.path.exists(EXE):
        sys.exit(f"build first: {EXE} not found")
    allow = json.load(open(ALLOW))["interactive_func_floor"]
    weak = link_active_weak(EXE)

    func_stubs = sorted(s for s in weak if re.match(r"func_0[0-9A-Fa-f]{5,6}", s))
    overlay = sorted(s for s in weak if s.startswith("overlay_call_"))
    ovly = sorted(s for s in weak if s.startswith("ovly_"))
    named = sorted(weak - set(func_stubs) - set(overlay) - set(ovly))

    print("GATE G4 -- link-active stub floor")
    print("=" * 60)
    print(f"link-active weak (all)        : {len(weak)}")
    print(f"  func_ stubs (gated)         : {len(func_stubs)}")
    print(f"  overlay_call_ thunks        : {len(overlay)}   (display/interactive surface)")
    print(f"  ovly_ aliases               : {len(ovly)}")
    print(f"  named leaves                : {len(named)}")
    print()

    unlisted = [s for s in func_stubs if s not in allow]
    listed_missing = [s for s in allow if s not in func_stubs]

    print("interactive func_ floor (allowlisted):")
    for s in func_stubs:
        tag = "OK " if s in allow else "NEW"
        st = allow.get(s, {}).get("state", "UNLISTED")
        print(f"  [{tag}] {s:<32} {st}")
    if listed_missing:
        print("\nallowlisted but no longer link-active (now ported/wired -- prune from json):")
        for s in listed_missing:
            print(f"  - {s}")

    if unlisted:
        print("\nFAIL: unlisted func_ stub(s) appeared (no-new-items breach):")
        for s in unlisted:
            print(f"  + {s}")
        return 1
    print("\nPASS: every link-active func_ stub is an allowlisted interactive entry.")
    print("(operative zero-hit proof: run --smoke=500 -> stub-hits: 0)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
