#!/usr/bin/env python3
"""input_compare.py — the Phase-8 keyboard oracle: feed the SAME key
script through the JS onKey dispatcher (sim_trace input) and the C
in_key layer (smoke --input), diff the per-event projections exactly.

Two scenarios:
  boot     no fixture — the title/difficulty/nation/name flow
  <save>   the map screen over a loaded fixture — viewMode pans, the
           unit cycle with its endTurn rollover, orders, F-key reports,
           pulldown navigation (slice-1 vocabulary: no unit movement)

Usage: python3 tools/input_compare.py [boot|sav1653|savraleigh|savnewcolony]
"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def boot_script():
    ev = []
    K = lambda k, a=0, s=0: ev.append([k, a, s])
    # title row walk + into the setup chain
    for _ in range(7):
        K("ArrowDown")
    K("ArrowUp")
    K("Enter")                      # -> difficulty (row wrapped to 2)
    for _ in range(3):
        K("ArrowDown")
    K("ArrowUp")
    K("Enter")                      # -> nation
    K("ArrowRight")
    K("ArrowRight")
    K("ArrowLeft")
    K("Enter")                      # -> name (leader prefilled)
    K("Backspace")
    K("Backspace")
    K("X")
    K("y")
    K("Escape")                     # a plain key on the name screen
    K("Enter")                      # -> briefing
    K("Escape")                     # briefing ignores it (slice 1)
    return ev


def map_script():
    ev = []
    K = lambda k, a=0, s=0: ev.append([k, a, s])
    # viewMode panning
    K("v")
    for k in ("ArrowRight", "ArrowRight", "ArrowDown", "ArrowLeft",
              "ArrowUp", "ArrowUp"):
        K(k)
    K("m")
    # unit cycle: centre view, next, skip, orders — several turns' worth
    K("c")
    for i in range(40):
        K(["Tab", "Space", "f", "s", "w", "Space"][i % 6])
    # report ladder in and out
    for fk in ("F2", "F3", "F5", "F10"):
        K(fk)
        K("Escape")
    K("F4")
    K("F6")                          # F-key inside a report also exits
    # pulldown navigation (no Enter in slice 1)
    K("g", 1)                        # Alt+G opens GAME
    K("ArrowDown")
    K("ArrowDown")
    K("ArrowUp")
    K("ArrowRight")                  # next menu
    K("ArrowDown")
    K("ArrowLeft")
    K("Escape")
    # more unit cycling across an endTurn boundary
    for _ in range(30):
        K("Space")
    K("a")
    K("c")
    # slice 2: menu Enter + accelerators
    K("v", 1)                        # Alt+V opens VIEW
    K("C")                           # accel: Center View (runs + closes)
    K("v", 1)
    K("H")                           # Show Hidden toggle on
    K("v", 1)
    K("H")                           # ...and off
    K("o", 1)                        # Alt+O opens ORDERS
    K("A")                           # accel: Activate unit
    K("o", 1)
    K("F")                           # accel: Fortify (advances)
    K("r", 1)                        # Alt+R opens REPORTS
    K("ArrowDown")                   # F1 -> F2
    K("Enter")                       # F2 Religious Adviser
    K("Escape")                      # report -> map
    # the Europe screen via VIEW / European Status
    K("v", 1)
    K("E")                           # -> europe
    K("ArrowRight")
    K("ArrowRight")
    K("ArrowLeft")
    K("l")                           # buy 100 of the market cursor good
    K("+")                           # buy 10 more
    K("Escape")                      # -> map
    # colony-view keys: live if an askZoom opened a colony, no-ops on map
    K("2")
    K("Escape")
    return ev


def main():
    scen = sys.argv[1] if len(sys.argv) > 1 else "boot"
    events = boot_script() if scen == "boot" else map_script()
    with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as f:
        json.dump(events, f)
        path = f.name

    js = json.loads(subprocess.run(
        [sys.executable, ROOT / "tools/sim_trace.py", "input", scen, path],
        capture_output=True, text=True, check=True).stdout)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    feed = "\n".join("K %s %d %d" % (e[0], e[1], e[2]) for e in events)
    args = ["./smoke", "--input"] + ([] if scen == "boot" else [scen])
    cc = [json.loads(l) for l in subprocess.run(
        args, cwd=ROOT / "cport/host", input=feed, capture_output=True,
        text=True, check=True).stdout.splitlines()]

    bad = 0
    for i, (j, c) in enumerate(zip(js, cc)):
        for f in j:
            if f in ("gold", "year") and scen == "boot":
                continue            # boot runs no sim
            if j[f] != c.get(f):
                print("event %d %s .%s: JS %s != C %s"
                      % (i, events[i], f, j[f], c.get(f)))
                bad += 1
        if bad > 15:
            print("...")
            break
    if len(js) != len(cc):
        print("length mismatch: JS %d C %d" % (len(js), len(cc)))
        bad += 1
    print("input %s: %d events compared, %d disagreement(s)"
          % (scen, len(events), bad))
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
