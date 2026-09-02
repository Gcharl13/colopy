#!/usr/bin/env python3
"""popup_census.py — is each audited popup key actually wired, right now?

`docs/POPUP_AUDIT_2026-08-08.md` is a point-in-time audit. Sweeps landed after
it and their rows were never updated, so the audit (and anything derived from
it, notably `docs/REMAINING_WORK.md` Part B) reads as a to-do list that
overstates what is missing. This walks the audit's own rows and, for every
GAME.TXT key each one names, reports whether both engines reference it today.

Emission, not correctness: a key that shows WIRED still has to be judged on
substitutions and trigger. What the tool is FOR is the opposite direction — a
key that shows ABSENT in both engines cannot possibly be right, and a row the
audit calls MISSING that is WIRED in both is a row to re-audit before anyone
spends effort "implementing" it again.

A key can show ABSENT for more reasons than "the mechanic is missing": the
engine may reach it by a reference shape this tool does not read. That is
why `--self-test` exists (G2b): it plants one key per shape and asserts the
shape is seen, so the tool's own blind spots are a failing test rather than
a quiet gap. `tools/stale_check.py` runs it under `make test`.

Usage:
  python3 tools/popup_census.py                 # rows the audit left open
  python3 tools/popup_census.py --all           # every row, resolved included
  python3 tools/popup_census.py --sev HIGH      # one severity
  python3 tools/popup_census.py --absent        # only keys absent in an engine
  python3 tools/popup_census.py --self-test     # one planted key per reference shape
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
AUDIT = ROOT / "docs" / "POPUP_AUDIT_2026-08-08.md"
JS = ROOT / "port" / "src" / "game.js"
C_DIRS = [ROOT / "cport" / "core", ROOT / "cport" / "game", ROOT / "cport" / "render"]

ROW = re.compile(r"^- \*\*\[(HIGH|MEDIUM|LOW)\]\s*(.+?)\*\*\s*—\s*(.*)$")
KEY = re.compile(r"@([A-Z][A-Z0-9]*)")


def _strip_comments(t: str) -> str:
    """Code only. A key mentioned in a comment is not a reference — and the
    audit rows are quoted in comments all over both engines, so without
    this a key could read WIRED because the code SAYS it is missing."""
    t = re.sub(r"/\*.*?\*/", " ", t, flags=re.S)
    t = re.sub(r"//.*$", " ", t, flags=re.M)
    return t


class EngineRefs:
    """Every way a GAME.TXT key reaches an engine, read from its source.

    Four reference shapes, and one non-reference. Shape 1 alone was the whole
    test until 2026-08-17; shapes 2 and 3 were added that day, when the four
    context menus read ABSENT while wired (they read a section's ROWS and never
    quote its key). Shape 4 and the comment strip were added 2026-09-02 by the
    self-test this file now carries, after @PISS0..5 and @MISSION0..3 read
    ABSENT in an engine that emits every one of them:

      1. a quoted literal at an emit site
             showEvent('STARVE1')             ev_emit("STARVE1", ...)
      2. a property read of a bundled section (rows, not a popup)
             DATA.events.ARMOPTIONS  DATA.dialogs.BUYME1  DATA.diplotext.MEEKNESS
      3. the C's generated section symbols (cport/data/colopy_text.h)
             dat_events_armoptions_body       dat_dialogs_landho_width
      4. a COMPUTED key: a literal prefix completed with a number
             JS   `PISS${cause}`   `TUTORIAL${n}`   'PISS' + n
             C    char key[8] = "PISS0"; key[4] = (char)('0' + cause);
         The prefix claims an audit key only when the remainder is all
         digits — `IND${t}A0` (prefix IND) does not claim INDIANGOLD.
      ×  NOT a reference: a mention inside a comment. Comments are stripped
         before matching, so `/* @PISS4 */` cannot make a key read wired.

    Honest limits, in the self-test's terms: a C key assembled by strcpy or
    snprintf, or a JS key held in a variable, is invisible here; and a
    quoted prefix in a concatenation (`'RID' + suffix`) also counts as the
    bare key RID, because the literal alone cannot say whether the suffix is
    ever empty.
    """
    LITERAL = re.compile(r"""['"]([A-Z][A-Z0-9]{2,})['"]""")
    PROPERTY = re.compile(r"DATA\.(?:events|dialogs|diplotext)\.([A-Z][A-Z0-9]{2,})")
    SYMBOL = re.compile(r"\bdat_(?:events|dialogs)_([a-z][a-z0-9]{2,})_"
                        r"(?:body|tail|width|default|small)\b")
    JS_TEMPLATE = re.compile(r"`([A-Z][A-Z0-9]{2,})\$\{")
    JS_CONCAT = re.compile(r"""['"]([A-Z][A-Z0-9]{2,})['"]\s*\+""")
    C_BUFFER = re.compile(r"""char\s+\w+\s*\[\s*\d+\s*\]\s*=\s*"([A-Z][A-Z0-9]*?)[0-9]"\s*;""")

    def __init__(self, text: str):
        t = _strip_comments(text)
        self.keys = (set(self.LITERAL.findall(t))
                     | set(self.PROPERTY.findall(t))
                     | {m.upper() for m in self.SYMBOL.findall(t)})
        self.prefixes = (set(self.JS_TEMPLATE.findall(t))
                         | set(self.JS_CONCAT.findall(t))
                         | set(self.C_BUFFER.findall(t)))

    def form(self, key: str) -> str | None:
        """'wired', 'wired:<prefix>+n' or None."""
        if key in self.keys:
            return "wired"
        for p in sorted(self.prefixes, key=len, reverse=True):
            if key.startswith(p) and key[len(p):].isdigit():
                return "wired:%s+n" % p
        return None


def engine_refs() -> tuple[EngineRefs, EngineRefs]:
    c_text = "\n".join(f.read_text() for d in C_DIRS for f in sorted(d.glob("*.c")))
    return EngineRefs(JS.read_text()), EngineRefs(c_text)


def self_test(verbose: bool = True) -> int:
    """Plant one key per reference shape in synthetic JS and C sources and
    assert each is seen — and that the non-references are not."""
    js = """
      showEvent('PLANTA', {});                       // shape 1
      const rows = DATA.events.PLANTB.rows;          // shape 2
      const dlg = DATA.dialogs.PLANTM;               // shape 2, dialogs
      showEvent(`PLANTC${n}`, {});                   // shape 4, template
      showEvent('PLANTD' + k, {});                   // shape 4, concat
      const spk = `IND${t}A0`;                       // prefix IND: NOT INDIANGOLD
      // showEvent('PLANTE') -- a comment is not a reference
      /* DATA.events.PLANTF is documented here, not referenced */
    """
    c = """
      ev_emit("PLANTG", 0, 0, 0, 0);                 /* shape 1 */
      rows = dat_events_planth_body;                 /* shape 3 */
      w = dat_dialogs_planti_width;                  /* shape 3, dialogs */
      char key[8] = "PLANTJ0"; key[6] = (char)('0' + n);   /* shape 4 */
      /* ev_emit("PLANTK") -- a comment is not a reference */
      // dat_events_plantl_body -- nor is this
    """
    J, C = EngineRefs(js), EngineRefs(c)
    cases = [
        ("literal (JS)", "PLANTA", J, True),
        ("property read (JS)", "PLANTB", J, True),
        ("property read, dialogs (JS)", "PLANTM", J, True),
        ("computed, template (JS)", "PLANTC3", J, True),
        ("computed prefix alone is not a key (JS)", "PLANTC", J, False),
        ("computed, concat (JS)", "PLANTD12", J, True),
        ("prefix + letters is not computed (JS)", "INDIANGOLD", J, False),
        ("line comment is not a reference (JS)", "PLANTE", J, False),
        ("block comment is not a reference (JS)", "PLANTF", J, False),
        ("literal (C)", "PLANTG", C, True),
        ("section symbol, events (C)", "PLANTH", C, True),
        ("section symbol, dialogs (C)", "PLANTI", C, True),
        ("computed, char buffer (C)", "PLANTJ4", C, True),
        ("computed buffer's literal itself (C)", "PLANTJ0", C, True),
        ("block comment is not a reference (C)", "PLANTK", C, False),
        ("line comment is not a reference (C)", "PLANTL", C, False),
        ("absent everywhere (JS)", "PLANTZ", J, False),
        ("absent everywhere (C)", "PLANTZ", C, False),
    ]
    fails = 0
    for what, key, refs, want in cases:
        got = refs.form(key) is not None
        ok = got == want
        fails += not ok
        if verbose or not ok:
            print("  %s  %-42s %-11s -> %s" % ("ok  " if ok else "FAIL", what,
                                                key, refs.form(key) or "absent"))
    if verbose:
        print("popup_census self-test: %d/%d shapes behave" % (len(cases) - fails, len(cases)))
    return 1 if fails else 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--all", action="store_true",
                    help="include rows the audit marked RESOLVED")
    ap.add_argument("--sev", choices=("HIGH", "MEDIUM", "LOW"))
    ap.add_argument("--absent", action="store_true",
                    help="print only keys missing from an engine")
    ap.add_argument("--self-test", action="store_true",
                    help="plant one key per reference shape and assert detection")
    args = ap.parse_args()

    if args.self_test:
        return self_test()

    js_refs, c_refs = engine_refs()

    rows = []
    for line in AUDIT.read_text().splitlines():
        m = ROW.match(line)
        if not m:
            continue
        sev, subject, body = m.groups()
        if args.sev and sev != args.sev:
            continue
        resolved = "RESOLVED" in body
        if resolved and not args.all:
            continue
        keys = sorted(set(KEY.findall(subject)) | set(KEY.findall(body)))
        if not keys:
            continue
        verdict = body.split("—")[0].strip() or "?"
        rows.append((sev, subject.strip(), verdict, resolved, keys))

    n_both = n_one = n_neither = 0
    for sev, subject, verdict, resolved, keys in rows:
        marks = []
        for k in keys:
            fj, fc = js_refs.form(k), c_refs.form(k)
            if fj and fc:
                n_both += 1
                tag = fj if fj != "wired" else fc
            elif fj or fc:
                n_one += 1
                tag = "JS-only" if fj else "C-only"
            else:
                n_neither += 1
                tag = "ABSENT"
            if args.absent and tag.startswith("wired"):
                continue
            marks.append(f"@{k}:{tag}")
        if not marks:
            continue
        head = subject if len(subject) <= 64 else subject[:61] + "..."
        print(f"[{sev}] {head}")
        print(f"      audit says: {verdict}{'  (RESOLVED)' if resolved else ''}")
        print(f"      today:      {'  '.join(marks)}")

    total = n_both + n_one + n_neither
    print(f"\n{total} key mentions across {len(rows)} rows: "
          f"{n_both} wired in both, {n_one} in one engine only, "
          f"{n_neither} absent from both.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
