#!/usr/bin/env python3
"""stale_check.py — the ledger's load-bearing claims, as assertions that RUN.

Every serious wrong turn in this project has had the same shape: a record said
something was missing, the code had moved on, and nothing connected the two.
The record kept being read as current.

  G2a  a scenario ran on the wrong screen, so a whole pointer layer was dead
       and the oracle read green
  G2b  a census matched one of three reference forms, so wired menus read ABSENT
  G2d  a comparison scoped down for a since-fixed reason, never rescoped
  G2e  a mock gate modelled the wrong compiler
  G3   PORT_LEDGER's status column was a hard-coded literal that the header
       called hand-maintained -- 113 of 279 `todo` rows named ported functions
  2026-08-19  colopy_rivals.c said every diplomacy topic "ENDS at its first
       ask" long after accept_treaty/declare_war_on were wired.  That comment
       put "European diplomacy = STUB" into a status overview.

A prose claim cannot notice it has become false.  So each claim below carries a
PROBE: a small function over the current tree that returns True while the claim
still holds.  When a probe disagrees with its claim, this exits non-zero and
names the row to correct.

WHAT THIS CANNOT DO, stated so the tool is not itself over-read:
  * A probe tests a PROXY (a symbol, a call, an encoding), never behaviour.
    Passing means "the thing the claim denies is still absent from the code",
    not "the feature is correct".  The parity oracles test behaviour.
  * A claim with no probe here is unchecked.  `--list` shows coverage.
  * A probe can rot too.  Each one says in its docstring what it looks for.

Usage:
  python3 tools/stale_check.py          # verify every claim
  python3 tools/stale_check.py --list   # what is and is not covered
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def _c_text() -> str:
    return "\n".join(p.read_text() for d in ("core", "game", "render")
                     for p in sorted((ROOT / "cport" / d).glob("*.c")))


def _js() -> str:
    return (ROOT / "port/src/game.js").read_text()


def _strip_comments(t: str) -> str:
    """Code only. A probe that greps raw text matches the very comment that
    DOCUMENTS the gap, and then reports the record as stale -- which is what
    happened to B3.2/B3.3 the first time this tool ran. Probes must read what
    the program does, not what it says about itself."""
    t = re.sub(r"/\*.*?\*/", " ", t, flags=re.S)     # C block comments
    t = re.sub(r"^\s*//.*$", " ", t, flags=re.M)      # line comments
    t = re.sub(r"//.*$", " ", t, flags=re.M)
    return t


def _c_cites_js_function(name: str) -> bool:
    """Does any C source cite this game.js function by name?"""
    return bool(re.search(r"\b%s\s*\(game\.js" % re.escape(name), _c_text()))


def probe_b42() -> bool:
    """B4.2: tutorial bindings not ported. Proxy: the C does not cite tutOnce."""
    return not _c_cites_js_function("tutOnce")


def probe_b43() -> bool:
    """B4.3 was STALE and is now CLOSED (2026-08-29): the C carries the
    byte-model haggle. Pinned: trade_sell_pick..trade_buy_round stay
    present in colopy_village.c."""
    v = _strip_comments((ROOT / "cport/core/colopy_village.c").read_text())
    return "trade_sell_pick" in v and "trade_buy_round" in v


def probe_b45_fixed() -> bool:
    """B4.5 was STALE and is now closed. Pinned: every move target stays
    handled -- village entry, rumour entry and the sea lane must all remain
    reachable from cmd_move."""
    c = _strip_comments((ROOT / "cport/core/colopy_cmd.c").read_text())
    return ("village_enter(" in c and "enter_rumour(" in c
            and "TERR_SEALANE" in c)


def probe_b47() -> bool:
    """B4.7: only the drag layer is absent from the C input port."""
    return "DRAG layer is absent" in (ROOT / "cport/game/colopy_input.c").read_text()


def probe_b32() -> bool:
    """B3.2: F5 Economic's second page (building upkeep) is not drawn.
    Proxy: neither engine references the @MISC 91/92 upkeep captions."""
    t = _strip_comments(_js() + _c_text())
    return "Building Upkeep" not in t and "TOTAL UPKEEP" not in t


def probe_b33() -> bool:
    """B3.3: F9's multi-page paginator is not wired -- an 8th contacted tribe
    is never shown. Proxy: no paginator state in either report painter."""
    t = _strip_comments(_js() +
                        (ROOT / "cport/render/colopy_report_render.c").read_text())
    return "func_039E98" not in t


def probe_b34() -> bool:
    """B3.4: trade routes have no per-stop good-list editor. Proxy: the C
    route model carries no per-stop goods list."""
    return "route_goods" not in _c_text()


def probe_b36() -> bool:
    """B3.6 (re-scoped): the colony pass still runs for the HUMAN only, so
    rival colonies do not develop. Proxy: turn_step_prefix's loop still tests
    the owner against cs_nation() rather than sweeping all four powers.
    Flips the day the per-power loop goes live -- which is the point."""
    t = _strip_comments((ROOT / "cport/core/colopy_turn.c").read_text())
    return "owner_power & 3) == cs_nation()" in t


def probe_b36_scaffold() -> bool:
    """Pinned: the per-power scaffolding stays in place, and father_owned
    keeps reading the PASS's power. Losing this silently re-introduces the
    cross-power Founding-Father bug the moment the loop goes live."""
    t = _strip_comments((ROOT / "cport/core/colopy_turn.c").read_text())
    return "turn_power" in t and "CS.powers[cur_power()].founding_fathers" in t


def probe_doi() -> bool:
    """Declaration of Independence screen absent. Proxy: DECOIND painter is in
    neither engine."""
    return "DECOIND" not in _strip_comments(_js() + _c_text())


def probe_census_exists() -> bool:
    """The census is the ONLY gate comparing the port to the real game. Pinned
    so it cannot quietly disappear or lose its committed reference frames --
    a census whose baseline vanishes on a fresh clone is not a gate."""
    t = ROOT / "tools" / "screen_census.py"
    base = ROOT / "docs" / "screens" / "census" / "baseline"
    return t.exists() and base.is_dir() and len(list(base.glob("census_*.png"))) >= 5


def probe_ledger_derived() -> bool:
    """G3: PORT_LEDGER's status must stay DERIVED, never a literal. Proxy: the
    generator computes it from C citations and the doc says so."""
    g = (ROOT / "tools/gen_port_ledger.py").read_text()
    d = (ROOT / "cport/PORT_LEDGER.md").read_text()
    return "c_citations" in g and "DERIVED" in d and "| todo |" not in d


def probe_diplomacy_live() -> bool:
    """The 2026-08-19 correction, pinned so it cannot regress: diplomacy DOES
    execute past the first ask. This probe holds while that stays true --
    meeting_topic must still reach the treaty and war writes."""
    r = _strip_comments((ROOT / "cport/core/colopy_rivals.c").read_text())
    return "accept_treaty(rn)" in r and "REL_WAR" in r


def probe_unit_builds() -> bool:
    """Also pinned: colony UNIT builds complete (0xC0+u encoding resolved by
    advance_construction). Holds while that stays true."""
    t = _strip_comments(_c_text())
    return "BUILD_UNIT_NAMES" in t and "0xC0" in t


CLAIMS = [
    ("B4.2", "docs/REMAINING_WORK.md", "tutorial bindings not ported", probe_b42),
    ("B4.3", "docs/REMAINING_WORK.md", "village trade haggle ported (closed)", probe_b43),
    ("FIXED-2026-08-19c", "cport/core/colopy_cmd.c",
     "every move target is handled", probe_b45_fixed),
    ("B4.7", "docs/REMAINING_WORK.md", "only the drag layer is absent", probe_b47),
    ("B3.2", "docs/REMAINING_WORK.md", "F5 second page not drawn", probe_b32),
    ("B3.3", "docs/REMAINING_WORK.md", "F9 paginator not wired", probe_b33),
    ("B3.4", "docs/REMAINING_WORK.md", "no per-stop trade-route editor", probe_b34),
    ("B3.6", "docs/REMAINING_WORK.md", "rival AI colony development absent", probe_b36),
    ("B3.6-scaffold", "cport/core/colopy_turn.c",
     "per-power scaffolding + father_owned reads the pass's power",
     probe_b36_scaffold),
    ("E-DoI", "docs/REMAINING_WORK.md", "Declaration screen does not exist", probe_doi),
    ("CENSUS", "tools/screen_census.py",
     "the DOS-vs-port census and its committed baseline exist",
     probe_census_exists),
    ("G3", "cport/PORT_LEDGER.md", "ledger status is derived, not declared",
     probe_ledger_derived),
    ("FIXED-2026-08-19a", "cport/core/colopy_rivals.c",
     "diplomacy executes past the first ask", probe_diplomacy_live),
    ("FIXED-2026-08-19b", "cport/core/colopy_turn.c",
     "colony unit builds complete", probe_unit_builds),
]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--list", action="store_true")
    args = ap.parse_args()

    if args.list:
        print("claims with a probe (%d):" % len(CLAIMS))
        for cid, where, what, fn in CLAIMS:
            print("  %-18s %-28s %s" % (cid, where, what))
        print("\nEverything else in the ledger is UNCHECKED prose.")
        return 0

    bad = []
    for cid, where, what, fn in CLAIMS:
        try:
            ok = fn()
        except Exception as exc:
            print("PROBE ERROR %s: %s" % (cid, exc), file=sys.stderr)
            bad.append((cid, where, what, "probe failed to run"))
            continue
        if not ok:
            bad.append((cid, where, what, "the code disagrees"))
    if bad:
        print("STALE RECORDS — %d claim(s) no longer match the code:\n" % len(bad))
        for cid, where, what, why in bad:
            print("  %s  (%s)" % (cid, where))
            print("      claims: %s" % what)
            print("      but:    %s\n" % why)
        print("Correct the record, or the probe if the probe is what is wrong.")
        return 1
    print("stale_check: %d claims, all still match the code" % len(CLAIMS))
    return 0


if __name__ == "__main__":
    sys.exit(main())
