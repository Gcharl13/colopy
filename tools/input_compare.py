#!/usr/bin/env python3
"""input_compare.py — the Phase-8 keyboard oracle: feed the SAME key
script through the JS onKey dispatcher (sim_trace input) and the C
in_key layer (smoke --input), diff the per-event projections exactly.

Two scenarios:
  boot     no fixture — the title/difficulty/nation/name flow
  <save>   the map screen over a loaded fixture — viewMode pans, the
           unit cycle with its endTurn rollover, orders, F-key reports,
           pulldown navigation (slice-1 vocabulary: no unit movement)

Every run ends with a COVERAGE CENSUS (G2a): the screens the scenario
visited and the prompt kinds it raised, compared against the expectation
DECLARED in EXPECT below.  Agreement between the engines is all the diff
above asks, and two engines agreeing about a fall-through look exactly
like two engines agreeing about a screen -- `colony_clicks` ran on the MAP
for months, every click fell through the map handler, and the oracle read
green.  A scenario that stops reaching a declared screen or prompt now
fails; one that reaches something undeclared fails too, so the table is
kept honest instead of quietly drifting under the runs.

Usage: python3 tools/input_compare.py [boot|bootclick|sav1653|savraleigh|savnewcolony]
"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# ---- the coverage census ---------------------------------------------------
# Screen numbers are sim_trace.py's INPUT `SCR` map, which the C's UI.screen
# enum mirrors; the `s` field is compared per event, so the two engines
# cannot disagree about it and still reach the census.
SCR_NAMES = ["title", "difficulty", "nation", "name", "briefing", "hof", "map",
             "report", "colony", "europe", "woodcut", "village", "king",
             "cards", "pedia", "options", "trade", "congress", "declaration",
             "score", "endking"]
# the projection's kind fields: colony popup `cp`, Europe menu `em`,
# numeric dialog `dg` -- the same vocabularies both engines project
CP_NAMES = {1: "popup", 2: "build", 3: "occupation", 4: "unitopts", 5: "shipopts"}
EM_NAMES = {1: "recruit", 2: "purchase", 3: "train", 4: "ship", 5: "dockunit"}
DG_NAMES = {1: "HOWMUCH5", 2: "HOWMUCH1", 3: "HOWMUCH2", 4: "other"}
CATEGORIES = ("screens", "prompts", "popups", "euromenus", "dialogs")

# What each scenario reaches TODAY (measured 2026-09-02), declared so a loss
# is a failure and not a silent narrowing.  Absences are as load-bearing as
# presences: `shipopts` is missing from every scenario because no fixture
# parks a ship in a colony at the point the script clicks the dock (the
# honest limit noted in colony_clicks) -- the day one does, the census
# says UNDECLARED and the table grows.
EXPECT = {
    "boot": {
        "screens": {"title", "difficulty", "nation", "name", "briefing"},
        "prompts": set(), "popups": set(), "euromenus": set(), "dialogs": set()},
    "bootclick": {
        "screens": {"difficulty", "nation", "name", "briefing"},
        "prompts": set(), "popups": set(), "euromenus": set(), "dialogs": set()},
    "sav1653": {
        "screens": {"map", "colony", "europe", "report", "trade"},
        "prompts": {"BUYME1", "CARGOREADY1", "GIVECASH", "NEEDTOOLS",
                    "NEEDTOOLS0", "REALLYBUY", "SUREDISBAND", "TRADETYPE",
                    "WAREHOUSEFULL", "WHICHFREEDOM"},
        "popups": {"popup", "build", "occupation"},
        "euromenus": {"recruit", "purchase", "train", "dockunit"},
        "dialogs": set()},
    "savraleigh": {
        "screens": {"map", "colony", "europe", "report", "trade"},
        "prompts": {"BUYME1", "CARGOREADY1", "KINGWAR", "KINGWIFE", "KISSUP",
                    "LOBOTOMIZE", "REALLYBUY", "RECRUITCHOOSE", "SUREDISBAND",
                    "TRADETYPE", "WHICHFREEDOM"},
        "popups": {"popup", "build"},
        "euromenus": {"recruit", "purchase", "train", "dockunit"},
        "dialogs": set()},
    "savnewcolony": {
        "screens": {"map", "europe", "report", "trade"},
        "prompts": {"REALLYBUY", "TRADETYPE"},
        "popups": set(),
        "euromenus": {"recruit", "purchase", "train", "dockunit"},
        "dialogs": set()},
}
# Read the gaps as findings, not noise: no scenario reaches the `ship`
# Europe menu, the `unitopts`/`shipopts` colony popups or ANY numeric
# dialog (`dg`), and savnewcolony never opens a colony at all -- every one
# of those handlers is exercised only by agreement about a fall-through.


def census(js, cc):
    """The screens, prompts and popup kinds the two projections reached."""
    reached = {c: set() for c in CATEGORIES}
    for p in js + cc:
        s = p.get("s", -1)
        reached["screens"].add(SCR_NAMES[s] if 0 <= s < len(SCR_NAMES)
                               else "s%d" % s)
        if p.get("cp"):
            reached["popups"].add(CP_NAMES.get(p["cp"], "cp%d" % p["cp"]))
        if p.get("em"):
            reached["euromenus"].add(EM_NAMES.get(p["em"], "em%d" % p["em"]))
        if p.get("dg"):
            reached["dialogs"].add(DG_NAMES.get(p["dg"], "dg%d" % p["dg"]))
    for last in (js[-1:], cc[-1:]):
        for p in last:                      # askmap counters are cumulative
            reached["prompts"] |= set(p.get("askmap") or {})
    return reached


def check_census(scen, js, cc) -> int:
    """Print the census; return the number of coverage faults."""
    reached = census(js, cc)
    print("census %s:" % scen)
    for cat in CATEGORIES:
        print("  %-9s %s" % (cat, " ".join(sorted(reached[cat])) or "-"))
    exp = EXPECT.get(scen)
    if exp is None:
        print("  NO EXPECTATION DECLARED for %r -- add its census to EXPECT "
              "in tools/input_compare.py" % scen)
        return 1
    bad = 0
    for cat in CATEGORIES:
        for x in sorted(exp[cat] - reached[cat]):
            print("  COVERAGE LOST: %s no longer reaches %s %r (declared in "
                  "EXPECT -- the check is dead or the script drifted)"
                  % (scen, cat, x))
            bad += 1
        for x in sorted(reached[cat] - exp[cat]):
            print("  UNDECLARED: %s now reaches %s %r -- add it to EXPECT so "
                  "losing it again is caught" % (scen, cat, x))
            bad += 1
    return bad


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
    colony_clicks(C, K)              # the colony pointer layer, live here
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
    # the recruit/purchase/train buttons (281, 89+11k, 37, 9) open the
    # euro menus; a far-outside click closes them (both geometries)
    C(285, 92)                      # RECRUIT button
    K("Escape")
    C(285, 103)                     # PURCHASE button
    C(20, 20)                       # outside the box: closes it
    C(285, 114)                     # TRAIN button
    K("ArrowDown")
    K("Escape")
    C(310, 185)                     # exit box -> map
    return ev


def colony_clicks(C, K):
    """the colony screen's pointer layer (onClick 'colony', 12130):
    scene cells, the plaza row, the build buttons, popup rows.

    OPENS THE COLONY FIRST (2026-08-17). Until now this block ran wherever
    the preceding 40-step loop happened to leave the session -- which is the
    MAP -- so every click in it fell through the map handler and the colony
    pointer layer was never exercised at all. The two engines still had to
    agree about the fall-through, so the oracle stayed green while covering
    nothing here. Roanoke sits at tile (26,22), which with the view at
    (19,17) and VP (0,8)/16px puts it at screen (120,96) at exactly this
    point in the script."""
    C(120, 96)                      # -> the colony screen
    C(256, 64)                      # scene centre cell: works itself, no-op
    C(280, 64)                      # cell (1,0): send the selected colonist
    C(280, 64)                      # again: select him / open his menu
    C(160, 100)                     # a popup row (or dismiss + fall through)
    C(6, 146)                       # plaza colonist 0
    C(6, 146)                       # again -> the jobs popup
    C(160, 96)                      # commit a popup row
    # The occupation menu's BUILDING rows (added 2026-08-19). The block above
    # opens the menu and commits by clicking a y, which lands on one of the
    # outdoor jobs at the top -- the building rows sit below them and were
    # never touched, so a merge bug there would have read green. This walks to
    # them by KEY, which is deterministic whatever the colony has built:
    # ArrowUp from row 0 wraps to the LAST row, so it also pins the two
    # engines' row COUNTS against each other, which is where an off-by-one in
    # the derived fence index would show.
    C(280, 64)                      # select the worker on cell (1,0)
    C(280, 64)                      # again -> his occupation menu
    K("ArrowUp")                    # wrap to the last row: "Return to the fence"
    K("ArrowUp")                    # -> the last BUILDING row
    K("Enter")                      # commit: the field worker moves indoors
    C(303, 162)                     # view button 2 (build)
    C(276, 142)                     # BUILD_BTN change -> the picker
    C(160, 60)                      # a picker row
    C(224, 142)                     # BUILD_BTN buy -> the @BUYME1 rush-buy ask
    C(303, 132)                     # view button 0 (production)
    # the plaza row's GARRISON half: a unit figure opens @UNITOPTIONS (cp 4).
    # x=54 lands on Roanoke's one garrison figure: its five members run
    # 2..42, then the byte-verified 4px break, then the unit at 48..62. In a
    # fixture with no garrison these fall through harmlessly and the two
    # engines still have to agree about that.
    C(54, 146)                      # a garrison figure -> @UNITOPTIONS
    K("ArrowDown")                  # -> "Clear orders."
    K("ArrowDown")                  # -> "Sentry / Board ship."
    K("Enter")                      # commit: orders = 1
    C(54, 146)                      # reopen
    K("ArrowDown")
    K("ArrowDown")
    K("ArrowDown")                  # -> "Fortify."
    K("Enter")                      # commit: orders = 5
    C(54, 146)                      # reopen
    K("Escape")                     # close, no change
    C(54, 146)                      # the same figure again
    K("Enter")                      # row 0: move to front of the cycle
    # The ships-in-port dock needs a colony that HAS one: Roanoke has none,
    # so leave it and open Vlissingen (25,34), which holds a player ship at
    # this point. It is off the bottom of the viewport (VP 0,8,240,192 shows
    # rows 17..28 at view (19,17)), so pan first: a click on an empty tile
    # centres on it, view := (tx-7, ty-6). Two clicks at the bottom row walk
    # the view (19,17) -> (19,22) -> (19,27), which puts (25,34) at screen
    # (96,120); +8 lands mid-tile.
    K("Escape")                     # -> map
    C(112, 184)                     # centre (26,28) -> view (19,22)
    C(112, 184)                     # centre (26,33) -> view (19,27)
    C(104, 128)                     # -> Vlissingen's colony screen
    # the dock: click a ship box to select, again for @SHIPOPTIONS (cp 5).
    # Boxes are the byte-cited 16x16 cells at x = 130 + 18k, y = 147
    # (drawColonyDock @0x27EAB).
    #
    # HONEST LIMIT: these do NOT fire today. Vlissingen holds a player ship at
    # LOAD, but this block runs after ~30 end-turns and by then it has sailed;
    # no fixture parks a ship in a colony at this point in the script. So
    # @SHIPOPTIONS is implemented in both engines and NOT exercised by the
    # oracle -- the clicks are left in, agreeing on the fall-through, and will
    # start covering the menu the moment a fixture does park one. This is the
    # concrete case for the coverage assertion logged as G2a.
    C(136, 152)                     # ship box 0: select
    C(136, 152)                     # same box: @SHIPOPTIONS
    K("ArrowDown")
    K("ArrowDown")
    K("ArrowDown")                  # -> 'Anchor in harbor ("Fortify").'
    K("Enter")                      # commit: orders = 5
    C(136, 152)                     # reselect
    C(136, 152)                     # reopen
    K("ArrowDown")
    K("ArrowDown")
    K("ArrowDown")
    K("ArrowDown")                  # -> "Unload all cargo."
    K("Enter")                      # commit: the whole hold into the warehouse
    C(136, 152)
    C(136, 152)
    K("Escape")                     # close, no change


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

    # `askmap` -- how many times each prompt has been asked -- is compared
    # whole-value, key by key. Until 2026-09-02 a prompt only ONE engine
    # raised was reported and not failed, on the authority of B4.6 (the C did
    # not reach the European meeting flow). B4.6 closed, no scenario raises a
    # one-sided prompt any more, and the allowance went with its reason
    # (G2d). A prompt BOTH raise a different number of times was always the
    # real fault: the scripted `n % 2` answer then differs, and the two
    # engines answer the SAME question differently -- what made the colony
    # BUY button look like two separate bugs when it was one desync (G2c).
    bad = 0
    for i, (j, c) in enumerate(zip(js, cc)):
        for f in j:
            # SCOPE-REASON: structural -- the boot scenarios run no sim, so
            # gold/year exist on the JS side only by construction.
            if f in ("gold", "year") and scen in ("boot", "bootclick"):
                continue
            if f == "askmap":
                jm, cm = j[f] or {}, c.get(f) or {}
                for k in sorted(set(jm) | set(cm)):
                    if jm.get(k) != cm.get(k):
                        print("event %d %s .askmap[%s]: JS %s != C %s"
                              % (i, events[i], k, jm.get(k, "absent"),
                                 cm.get(k, "absent")))
                        bad += 1
                continue
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
    bad += check_census(scen, js, cc)
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
