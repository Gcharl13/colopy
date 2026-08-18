#!/usr/bin/env python3
"""popup_census.py — is each audited popup key actually wired, right now?

`docs/POPUP_AUDIT_2026-08-08.md` is a point-in-time audit. Sweeps landed after
it and their rows were never updated, so the audit (and anything derived from
it, notably `docs/REMAINING_WORK.md` Part B) reads as a to-do list that
overstates what is missing. This walks the audit's own rows and, for every
GAME.TXT key each one names, reports whether both engines emit it today.

Emission, not correctness: a key that shows WIRED still has to be judged on
substitutions and trigger. What the tool is FOR is the opposite direction — a
key that shows ABSENT in both engines cannot possibly be right, and a row the
audit calls MISSING that is WIRED in both is a row to re-audit before anyone
spends effort "implementing" it again.

Usage:
  python3 tools/popup_census.py                 # rows the audit left open
  python3 tools/popup_census.py --all           # every row, resolved included
  python3 tools/popup_census.py --sev HIGH      # one severity
  python3 tools/popup_census.py --absent        # only keys absent in an engine
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


def engine_keys(text: str) -> set[str]:
    """Keys the engine actually references.

    Three forms, because there are three ways a key reaches the engine:

    1. A quoted literal at an emit site -- `showEvent('STARVE1')`,
       `ev_emit("STARVE1", ...)`. The common case.
    2. A property read of the bundled section -- `DATA.events.ARMOPTIONS`,
       `DATA.dialogs.BUYME1`. Used where the port takes the section's ROWS
       rather than posting it as a popup: the four context menus do this.
    3. The C's generated section symbols -- `dat_events_armoptions_body`.

    Form 1 alone was the whole test until 2026-08-17, and it made the four
    context menus read ABSENT on the day they were wired, because reading a
    section's rows never mentions its key in quotes."""
    keys = set(re.findall(r"""['"]([A-Z][A-Z0-9]{2,})['"]""", text))
    keys |= set(re.findall(r"DATA\.(?:events|dialogs)\.([A-Z][A-Z0-9]{2,})", text))
    keys |= {m.upper() for m in
             re.findall(r"dat_events_([a-z][a-z0-9]{2,})_body", text)}
    return keys


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--all", action="store_true",
                    help="include rows the audit marked RESOLVED")
    ap.add_argument("--sev", choices=("HIGH", "MEDIUM", "LOW"))
    ap.add_argument("--absent", action="store_true",
                    help="print only keys missing from an engine")
    args = ap.parse_args()

    js_keys = engine_keys(JS.read_text())
    c_keys: set[str] = set()
    for d in C_DIRS:
        for f in sorted(d.glob("*.c")):
            c_keys |= engine_keys(f.read_text())

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
            inj, inc = k in js_keys, k in c_keys
            if inj and inc:
                n_both += 1
                tag = "wired"
            elif inj or inc:
                n_one += 1
                tag = "JS-only" if inj else "C-only"
            else:
                n_neither += 1
                tag = "ABSENT"
            if args.absent and tag == "wired":
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
