#!/usr/bin/env python3
"""Merge a Ghidra export back into the repo — run on the REPO machine.

    python3 tools/ghidra/merge_ghidra_export.py viceroy_ghidra_export.json

Input is whatever `viceroy_ghidra_export.py` wrote inside Ghidra. Output is
`data_extracted/ghidra_user_symbols.json`, which `make_ghidra_scripts.py`
picks up on its next run — so a name you write in Ghidra survives losing the
database, and reappears in every future import.

WHY A SEPARATE FILE, not an edit to tools/viceroy_symbols.json
--------------------------------------------------------------
Per notes/TRUTH_HIERARCHY.md the provenance of a name is part of the name.
The existing symbol files hold names derived from byte evidence — CodeView
matches, fingerprints, emitter analysis. A name typed into Ghidra is a
different tier: it is a human judgement, possibly excellent, but not a byte
citation. Keeping it in its own file means the tier never gets laundered, and
the merge can never corrupt an evidence file.

Names from this file are applied by the generator with tier `U` and are
labelled as such in the Ghidra plate comment.

CONFLICTS
---------
An entry whose `was` no longer matches the current generated name means the
repo's own name changed since you exported (new evidence landed, or someone
else edited). Those are reported and SKIPPED, never silently overwritten —
re-import, redo the rename if you still want it, and re-export.
"""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
STORE = ROOT / "data_extracted/ghidra_user_symbols.json"

EMPTY = {"_doc": "Names and comments authored by hand in Ghidra and exported "
                 "via tools/ghidra/viceroy_ghidra_export.py. Tier U (human "
                 "judgement), NOT byte-verified — see the module docstring of "
                 "tools/ghidra/merge_ghidra_export.py.",
         "functions": {}, "globals": {},
         "plate_comments": {}, "eol_comments": {}}


def load(path):
    return json.loads(path.read_text()) if path.exists() else dict(EMPTY)


def main(argv):
    if len(argv) != 2:
        raise SystemExit(__doc__)
    incoming = json.loads(Path(argv[1]).read_text())
    store = load(STORE)
    for k in EMPTY:
        store.setdefault(k, EMPTY[k] if isinstance(EMPTY[k], dict) else EMPTY[k])

    # The baseline the export compared against, so we can detect a stale export.
    current = {}
    gen = ROOT / "tools/ghidra/viceroy_ghidra_symbols.py"
    if gen.exists():
        import re
        m = re.search(r'^DATA = json\.loads\(r"""(.*?)"""\)',
                      gen.read_text(), re.S | re.M)
        if m:
            data = json.loads(m.group(1))
            current = {f["a"]: f["n"] for f in data["funcs"]}

    added = updated = skipped = stale = 0
    for e in incoming.get("functions", []):
        key = "0x%06X" % e["a"]
        was, now = e.get("was"), e["now"]
        if was is not None and current and current.get(e["a"]) not in (was, now):
            print("STALE  %s: exported over %r but the repo now generates %r"
                  % (key, was, current.get(e["a"])))
            stale += 1
            continue
        if store["functions"].get(key) == now:
            skipped += 1
        elif key in store["functions"]:
            print("update %s: %r -> %r" % (key, store["functions"][key], now))
            store["functions"][key] = now
            updated += 1
        else:
            store["functions"][key] = now
            added += 1

    for e in incoming.get("globals", []):
        key = "0x%04X" % e["ds"]
        if store["globals"].get(key) == e["now"]:
            skipped += 1
            continue
        store["globals"][key] = e["now"]
        added += 1

    for field, src in (("plate_comments", "plate_comments"),
                       ("eol_comments", "eol_comments")):
        for e in incoming.get(src, []):
            key = "0x%06X" % e["a"]
            if store[field].get(key) == e["text"]:
                skipped += 1
                continue
            store[field][key] = e["text"]
            added += 1

    STORE.parent.mkdir(parents=True, exist_ok=True)
    STORE.write_text(json.dumps(store, indent=1, sort_keys=True) + "\n")

    print("")
    print("added   : %d" % added)
    print("updated : %d" % updated)
    print("unchanged: %d" % skipped)
    if stale:
        print("STALE   : %d  <- re-import, redo those renames, re-export"
              % stale)
    print("-> %s" % STORE)
    print("")
    print("totals now: %d functions, %d globals, %d plate, %d EOL"
          % (len(store["functions"]), len(store["globals"]),
             len(store["plate_comments"]), len(store["eol_comments"])))
    print("Next: python3 tools/ghidra/make_ghidra_scripts.py   (folds these in)")


if __name__ == "__main__":
    main(sys.argv)
