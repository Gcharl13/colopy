#!/usr/bin/env python3
"""Regenerate docs/MESSAGE_STATUS.md: every GAME.TXT key's implementation
status in the port, computed mechanically (bundled? call site exists?).
Run after adding message keys or wiring triggers:
    python3 port/tools/message_status.py
"""
import json, re, datetime
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
full = json.load(open(ROOT / 'data_extracted/text/GAME.full.json'))['sections']
src = open(ROOT / 'port/src/game.js').read()
bnd = open(ROOT / 'port/tools/bundle.py').read()
exported = set(re.findall(r'"@([A-Z0-9]+)"', bnd))
quoted = set(re.findall(r"['\"]([A-Z][A-Z0-9]{2,})['\"]", src))
dyn = set(re.findall(r"`([A-Z][A-Z0-9]*)\$\{[^}]*\}`", src))
DYN_FAMILIES = ('MISSION', 'LOSTCITY', 'BURIAL', 'HERESY', 'VILLAGE')
def wired(key):
    if key in quoted:
        return True
    return any(key.startswith(p) and len(key) <= len(p) + 2 and p in DYN_FAMILIES
               for p in dyn)
cats = {'DONE': [], 'BUNDLED-UNWIRED': [], 'MISSING': [],
        'SUPPORT (no @width - lists/menus)': []}
for k in sorted(full):
    key = k.lstrip('@')
    if not full[k].get('directives', {}).get('width'):
        cats['SUPPORT (no @width - lists/menus)'].append(
            key + (' [wired]' if (key in exported or wired(key)) else ''))
    elif key in exported and wired(key):
        cats['DONE'].append(key)
    elif key in exported:
        cats['BUNDLED-UNWIRED'].append(key)
    else:
        cats['MISSING'].append(key)
out = [f"# GAME.TXT message keys - implementation status "
       f"(generated {datetime.date.today()})", "",
       "Regenerate with `python3 port/tools/message_status.py`.  Status is",
       "mechanical: DONE = text bundled AND a live call site exists;",
       "BUNDLED-UNWIRED = text exported, no trigger yet; MISSING = not in the",
       "port at all.  DONE does not certify trigger/format fidelity - flagged",
       "readings live in notes/rulings/RULINGS.md and the popup audit.", ""]
for c, v in cats.items():
    out += [f"## {c} ({len(v)})", ""] + [f"- {x}" for x in v] + [""]
(ROOT / 'docs/MESSAGE_STATUS.md').write_text("\n".join(out))
print(f"wrote docs/MESSAGE_STATUS.md: " +
      ", ".join(f"{c.split()[0]} {len(v)}" for c, v in cats.items()))
