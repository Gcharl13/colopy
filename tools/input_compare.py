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
    C = lambda x, y: ev.append(["CLICK", x, y])
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


def boot_click_script():
    ev = []
    C = lambda x, y: ev.append(["CLICK", x, y])
    K = lambda k, a=0, s=0: ev.append([k, a, s])
    C(100, 110)                     # title row 0 -> difficulty
    C(150, 30)                      # difficulty cell 0 (idx 1: 128,7)
    C(25, 120)                      # cell 2 (idx 3: 23,103)
    C(60, 50)                       # commit zone (my<103, mx<128) -> nation
    C(150, 30)                      # nation cell 0 (112,13)
    C(260, 120)                     # nation cell 3 (211,104)
    C(50, 100)                      # commit zone (mx<112) -> name
    K("W")
    C(10, 10)                       # name click -> briefing
    C(10, 10)                       # briefing page 0 -> 1
    return ev


def map_script():
    ev = []
    K = lambda k, a=0, s=0: ev.append([k, a, s])
    C = lambda x, y: ev.append(["CLICK", x, y])
    # real unit movement first: empty land, water no-ops, ships,
    # villages, rumours and the newly ported native/REF attack arm all
    # resolve identically; the directions are empirically pinned to
    # avoid the still-unported rival-land arm
    for k in ("ArrowRight", "ArrowDown", "ArrowLeft", "ArrowUp",
              "ArrowRight", "ArrowDown"):
        K(k)
    # viewMode panning
    K("v")
    for k in ("ArrowRight", "ArrowRight", "ArrowDown", "ArrowLeft",
              "ArrowUp", "ArrowUp"):
        K(k)
    K("m")
    # §26.7 zoom: x out (recentres), pan in viewMode, click at 8px
    # tiles, level rows via VIEW, z back in
    K("x")                          # zoom 1 (30 x 24)
    K("v")
    K("ArrowRight")
    K("m")
    C(120, 104)                     # viewport centre at TILE_PX 8
    K("x")                          # zoom 2 (60 x 48)
    C(60, 52)
    K("z")
    K("z")                          # back to 15 x 12
    K("v", 1)                       # Alt+V opens VIEW
    K("X")                          # accel: the Zoom Out row
    K("v", 1)
    K("Z")                          # accel: the Zoom In row — home
    # trade routes: assign with none (@TRADENONE), then the create flow
    # (stops picked by row; Done -> @TRADETYPE ask; the @TRADENAME
    # openDialog is inert here, so no route survives — mirrored)
    K("t")                          # assign, no routes -> @TRADENONE
    K("t", 1)                       # Alt+T opens TRADE
    K("ArrowDown")                  # row 1 = Create Trade Route
    K("Enter")                      # -> the trade screen
    K("Enter")                      # add stop: first colony
    K("ArrowDown")
    K("Enter")                      # add a second stop
    K("ArrowUp")
    K("ArrowUp")                    # wrap to the Done row
    K("Enter")                      # @TRADETYPE ask -> back on the map
    K("t")                          # still no routes -> @TRADENONE
    # unit cycle: centre view, next, skip, orders — several turns' worth,
    # with movement bursts so DIFFERENT units step (village entries,
    # rumour squares and the attack arm all get live chances)
    K("c")
    for i in range(40):
        K(["Tab", "Space", "f", "s", "w", "Space"][i % 6])
        if i % 5 == 2:
            K(["ArrowRight", "ArrowDown", "ArrowLeft", "ArrowUp",
               "9", "1", "7", "3"][i % 8])
            # if that step entered a village: Enter commits the trade
            # row (asks inert), Escape leaves it; on the map both no-op
            K("Enter")
            K("Escape")
    # report ladder in and out
    for fk in ("F2", "F3", "F5", "F10"):
        K(fk)
        K("Escape")
    K("F4")
    K("F6")                          # F-key inside a report also exits
    # slice 8: map mechanics — improvement orders, build/join colony
    # (guards + ask chains; the name dialog is inert), ship cargo
    # (@CARGOLOAD/@CARGOUNLOAD picks + @HOWMUCH modals), dump, disband
    # (@SUREDISBAND: row 0 = yes on the even ask), sail for Europe
    K("p")                           # Clear/Plow order (advances)
    K("r")                           # Build Road order (advances)
    K("b")                           # Build/Join Colony
    K("Escape")                      # colony exit if the join opened one
    K("l")                           # Load (ship at a colony; else msg)
    K("7")                           # modal digit / diagonal move
    K("Enter")                       # commit load / village-safe no-op
    K("Escape")                      # village-safe balance
    K("u")                           # Unload pick + @HOWMUCH2
    K("Enter")                       # full amount / no-op
    K("Escape")
    K("o")                           # dump a hold slot overboard
    K("D", 0, 1)                     # Shift+D: disband (ask)
    K("e")                           # sail for Europe -> europe screen
    K("Escape")                      # -> map
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
    # the jobs popup (Enter opens it when an askZoom left us on the
    # colony screen; on the map Enter no-ops and the arrows move the
    # selected unit — mirrored either way)
    K("Enter")
    K("ArrowDown")
    K("ArrowDown")
    K("ArrowUp")
    K("Enter")                       # commit: colonist 0 takes the row's job
    K("Enter")                       # reopen
    K("Escape")                      # close without committing
    K("l")                           # @LOBOTOMIZE (colony) / load (map)
    K("b")                           # rush-buy ask (colony) / build (map)
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
    # the @HOWMUCH5 sell-amount modal (goods are aboard from the buys)
    K("u")
    K("2")
    K("2")                           # entry "22"
    K("Backspace")                   # -> "2"
    K("Enter")                       # sell 2
    K("u")
    K("Escape")                      # cancel = 0
    K("u")
    K("Enter")                       # empty entry = the FULL amount
    # the r/p/t sub-menus (openEuroMenu): recruit slot 0, train the
    # second-cheapest expert, open+close purchase, petition the King
    K("r")
    K("ArrowDown")
    K("Enter")                       # recruit dock candidate 0
    K("t")
    K("ArrowDown")
    K("ArrowDown")
    K("Enter")                       # train (gold gate may keep it open)
    K("Escape")                      # close it if the gate held
    K("p")
    K("ArrowDown")
    K("Escape")                      # purchase menu: browse + close
    K("k")                           # petition the King
    K("s")                           # @SAILAWAY openDialog: inert
    K("Escape")                      # -> map
    # colony-view keys: live if an askZoom opened a colony, no-ops on map
    K("2")
    K("Escape")
    # slice 3: the pointer layer
    C = lambda x, y: ev.append(["CLICK", x, y])
    C(50, 3)                        # menubar: open VIEW
    C(52, 13)                       # pulldown row 0 (Move Pieces)
    C(83, 3)                        # menubar: open ORDERS
    C(300, 100)                     # outside the box: closes it
    C(120, 104)                     # viewport centre: colony/cycle/centre
    C(120, 104)                     # again (cycles or re-centres)
    C(30, 40)                       # another viewport tile
    C(121, 3)                       # menubar: open REPORTS
    K("Escape")
    # colony pointer coverage (live after an askZoom, no-ops on map:
    # x>240 misses the viewport and my<8 fails the menubar test)
    C(310, 150)                     # view button 1
    C(310, 135)                     # view button 0
    C(250, 150)                     # production numbers toggle
    C(310, 185)                     # exit box -> map
    # Europe pointer coverage via the VIEW menu
    K("v", 1)
    K("E")                          # -> europe
    C(164, 150)                     # ship box 1 (selects if present)
    C(164, 150)                     # same box: @EUROPESHIPOPTIONS (em 4)
    K("ArrowDown")
    K("ArrowDown")                  # row 2: Unload all cargo (= sell)
    K("Enter")
    C(240, 145)                     # dock unit 0: @ARMOPTIONS (em 5)
    K("ArrowDown")                  # -> move to front
    K("Enter")
    C(240, 145)                     # reopen
    K("Escape")                     # close
    C(100, 190)                     # market bar: select + sell mirror
    C(310, 185)                     # exit box -> map
    return ev


def main():
    scen = sys.argv[1] if len(sys.argv) > 1 else "boot"
    events = (boot_script() if scen == "boot"
              else boot_click_script() if scen == "bootclick"
              else map_script())
    with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as f:
        json.dump(events, f)
        path = f.name

    js = json.loads(subprocess.run(
        [sys.executable, ROOT / "tools/sim_trace.py", "input", scen, path],
        capture_output=True, text=True, check=True).stdout)

    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host",
                   check=True)
    feed = "\n".join(("C %d %d" % (e[1], e[2])) if e[0] == "CLICK"
                     else ("K %s %d %d" % (e[0], e[1], e[2]))
                     for e in events)
    args = ["./smoke", "--input"] + ([] if scen in ("boot", "bootclick")
                                     else [scen])
    cc = [json.loads(l) for l in subprocess.run(
        args, cwd=ROOT / "cport/host", input=feed, capture_output=True,
        text=True, check=True).stdout.splitlines()]

    bad = 0
    for i, (j, c) in enumerate(zip(js, cc)):
        for f in j:
            if f in ("gold", "year") and scen in ("boot", "bootclick"):
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
