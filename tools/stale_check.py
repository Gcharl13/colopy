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
  python3 tools/stale_check.py --scopes # every scoped comparison and its reason
"""
from __future__ import annotations

import argparse
import hashlib
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
    """Also pinned: colony UNIT builds complete (the record's own
    0x2A + (type - 0x0B) encoding, func_00B5A8, resolved by
    advance_construction through build_target_unit_type -- C3.7 2026-09-02
    replaced the port-private 0xC0+u marker). Holds while that stays true."""
    t = _strip_comments(_c_text())
    return "build_target_unit_type" in t and "0x2A" in t


# ---- G2d: a scoped comparison must say WHY, and the why must still hold ----
#
# Every oracle scopes something -- a key family it drops, a field it skips, a
# pixel class it accepts -- and each scope was justified by a bug on the day
# it was written.  Nothing reminded anyone when the bug was fixed (`emrows`
# stayed on the two harbour menus long after D12 closed).  So: a scope in an
# oracle tool carries `SCOPE-REASON: <ledger row>` or `SCOPE-REASON:
# structural` within the 12 lines above it, and the row it names must still
# be OPEN in docs/REMAINING_WORK.md.  The day the row closes, this probe fires
# and the scope comes out -- or gets a new reason.
#
# Detection is by SHAPE, and that is the honest limit: a novel scope shape
# the list below does not know is invisible until someone writes "scoped" or
# "intersection" in the comment beside it (the prose marker), which is the
# habit G2d asks for anyway.
ORACLE_TOOLS = ["tools/sim_compare.py", "tools/input_compare.py",
                "tools/sim_trace.py", "tools/render_common.py",
                "tools/screen_census.py"]
SCOPE_SHAPES = [
    ("family filter",    r'\bnot \w+\.startswith\("[A-Z]'),
    ("acceptance class", r'\baccepted \+= 1'),
    ("field skip",       r'^\s*if f in \('),
    ("entry skip",       r'^\s*if nm == "'),
    ("prose marker",     r'(?:#|//|/\*).*(?i:\b(?:scoped|intersection)\b)'),
]
REASON = re.compile(r"SCOPE-REASON:\s*([A-Z]\d+(?:\.\d+)?[a-z]?|structural)\b")


def scopes() -> list[tuple[str, int, str, str | None]]:
    """Every scoped comparison in the oracle tools: (file, line, shape,
    reason) -- reason None when no SCOPE-REASON sits within 12 lines above."""
    files = ORACLE_TOOLS + sorted(
        str(p.relative_to(ROOT)) for p in (ROOT / "tools").glob("render_*_compare.py"))
    out = []
    for rel in files:
        lines = (ROOT / rel).read_text().split("\n")
        for i, line in enumerate(lines):
            if "SCOPE-REASON:" in line:
                continue
            for shape, pat in SCOPE_SHAPES:
                if re.search(pat, line):
                    window = "\n".join(lines[max(0, i - 12):i + 1])
                    m = REASON.findall(window)
                    out.append((rel, i + 1, shape, m[-1] if m else None))
                    break
    return out


def ledger_row(row_id: str) -> str | None:
    """'open' | 'closed' | None (no such row) from docs/REMAINING_WORK.md: a
    row is closed when its status cell says so or its item is struck."""
    for line in (ROOT / "docs/REMAINING_WORK.md").read_text().splitlines():
        if re.match(r"\|\s*%s\s*\|" % re.escape(row_id), line):
            cells = [c.strip() for c in line.strip().strip("|").split("|")]
            item = cells[1] if len(cells) > 1 else ""
            if cells[-1].lower().startswith("closed") or item.startswith("~~"):
                return "closed"
            return "open"
    return None


def probe_scope_reasons() -> bool:
    """G2d: every scoped comparison in the oracle tools names an OPEN ledger
    row (or `structural`, a permanent model difference) as its reason."""
    ok = True
    for rel, ln, shape, reason in scopes():
        if reason is None:
            print("  scope without a reason: %s:%d (%s) -- add "
                  "`SCOPE-REASON: <ledger row>` or `SCOPE-REASON: structural`"
                  % (rel, ln, shape), file=sys.stderr)
            ok = False
        elif reason != "structural" and ledger_row(reason) != "open":
            print("  scope outlived its reason: %s:%d cites %s, which is %s -- "
                  "remove the scope or re-justify it"
                  % (rel, ln, reason, ledger_row(reason) or "not a ledger row"),
                  file=sys.stderr)
            ok = False
    return ok


# ---- 2026-09-02: the tooling rows (Part G), pinned the same way ------------

def probe_render_ceilings() -> bool:
    """G2: every render oracle bounds its palette-model acceptances through
    render_common.verdict(), and the ceiling table covers all seven."""
    sys.path.insert(0, str(ROOT / "tools"))
    import render_common
    tools = sorted((ROOT / "tools").glob("render_*_compare.py"))
    return (len(tools) == 7 and len(render_common.PALETTE_CEILING) >= 7
            and all("verdict(" in t.read_text() for t in tools))


def probe_input_census() -> bool:
    """G2a: input_compare declares a coverage expectation for every scenario
    it runs, and checks it after the diff."""
    sys.path.insert(0, str(ROOT / "tools"))
    import input_compare
    return (set(input_compare.EXPECT) >= {"boot", "bootclick", "sav1653",
                                          "savraleigh", "savnewcolony"}
            and "check_census(" in (ROOT / "tools/input_compare.py").read_text())


def probe_census_selftest() -> bool:
    """G2b: popup_census sees every reference shape it claims to -- its
    planted-key self-test passes."""
    sys.path.insert(0, str(ROOT / "tools"))
    import popup_census
    return popup_census.self_test(verbose=False) == 0


def probe_ino_gate() -> bool:
    """G2e: the .ino mock gate keeps both fixes -- prototypes hoisted ABOVE
    the first definition, indented definitions matched -- and locates the
    sketch relative to itself, never by an absolute path."""
    g = (ROOT / "tools/ino_mock/gen_mock.py").read_text()
    s = (ROOT / "tools/ino_mock/check.sh").read_text()
    return (r'r"^[ \t]*(' in g and "lines[:first_line] + protos" in g
            and "/home/" not in s)


def probe_asset_gate() -> bool:
    """G7: the asset gate decodes with the in-repo codec and cannot pass by
    not looking -- no external tool, and a declared-failure table it checks
    in both directions."""
    t = (ROOT / "tools/extract_visuals.py").read_text()
    return ("import ssdec" in t and "KNOWN_FAILURES" in t
            and "import subprocess" not in t)


def probe_vendor_pinned() -> bool:
    """G9/G10: the vendored Elecrow tree is pinned -- PROVENANCE names the
    upstream commit, and every vendored file still matches
    cport/p4/VENDORED.sha256 (drift fails here, not on the next refresh)."""
    prov = (ROOT / "cport/p4/PROVENANCE.md").read_text()
    if not re.search(r"\b[0-9a-f]{40}\b", prov):
        return False
    base = ROOT / "cport/p4"
    n = 0
    for line in (base / "VENDORED.sha256").read_text().splitlines():
        digest, name = line.split(None, 1)
        p = base / name.lstrip("*")
        if not p.is_file() or hashlib.sha256(p.read_bytes()).hexdigest() != digest:
            return False
        n += 1
    return n > 400


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
    ("G2", "tools/render_common.py",
     "render oracles ceiling their palette acceptances", probe_render_ceilings),
    ("G2a", "tools/input_compare.py",
     "every input scenario declares and checks its coverage", probe_input_census),
    ("G2b", "tools/popup_census.py",
     "the census sees every reference shape (self-test)", probe_census_selftest),
    ("G2d", "tools/*_compare.py",
     "every scoped comparison cites an OPEN row or `structural`",
     probe_scope_reasons),
    ("G2e", "tools/ino_mock/",
     "the .ino gate hoists like the IDE and is self-locating", probe_ino_gate),
    ("G7", "tools/extract_visuals.py",
     "the asset gate decodes in-repo and cannot pass by not looking",
     probe_asset_gate),
    ("G9/G10", "cport/p4/PROVENANCE.md",
     "the vendored Elecrow tree is pinned and unchanged", probe_vendor_pinned),
]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--scopes", action="store_true",
                    help="list every scoped comparison in the oracle tools")
    args = ap.parse_args()

    if args.list:
        print("claims with a probe (%d):" % len(CLAIMS))
        for cid, where, what, fn in CLAIMS:
            print("  %-18s %-28s %s" % (cid, where, what))
        print("\nEverything else in the ledger is UNCHECKED prose.")
        return 0

    if args.scopes:
        found = scopes()
        print("scoped comparisons in the oracle tools (%d):" % len(found))
        for rel, ln, shape, reason in found:
            why = ("structural" if reason == "structural"
                   else "%s (%s)" % (reason, ledger_row(reason) or "no such row")
                   if reason else "NO REASON")
            print("  %-32s %4d  %-17s %s" % (rel, ln, shape, why))
        print("\nShapes not in SCOPE_SHAPES are unseen until someone writes "
              "'scoped' beside them.")
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
