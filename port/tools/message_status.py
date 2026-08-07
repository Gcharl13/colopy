#!/usr/bin/env python3
"""Regenerate docs/MESSAGE_STATUS.md: every GAME.TXT key's implementation
status in the port, computed mechanically (bundled? call site exists?) plus
two hand-verified annotation maps for consumption the scanner cannot see.
Run after adding message keys or wiring triggers:
    python3 port/tools/message_status.py
"""
import json, re, datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
full = json.load(open(ROOT / 'data_extracted/text/GAME.full.json'))['sections']
src = open(ROOT / 'port/src/game.js').read()
bnd = open(ROOT / 'port/tools/bundle.py').read()

# Keys consumed through DATA channels rather than showEvent('KEY') literals --
# each entry names the consuming symbol so the claim stays checkable.
WIRED_VIA_DATA = {
    'BEGINMENU': 'DATA.text.beginmenu (main menu rows)',
    'DIFFICULTY': 'DATA.difficulty (drawDifficulty cells)',
    'LEADERNAME': 'DATA.text.leadername (name-entry prefill)',
    'VICEROY': 'DATA.viceroy (drawKing scroll)',
    'VICEROY2': 'DATA.viceroy (drawKing scroll, Dutch)',
    'NATION0A': 'DATA.briefings (drawBriefing page A)',
    'NATION0B': 'DATA.briefings (drawBriefing page B)',
    'NATION1A': 'DATA.briefings', 'NATION1B': 'DATA.briefings',
    'NATION2A': 'DATA.briefings', 'NATION2B': 'DATA.briefings',
    'NATION3A': 'DATA.briefings', 'NATION3B': 'DATA.briefings',
    # drawTrade reads these through DATA.events.<KEY>.body (Phase 1 swapped
    # the paraphrased literals for the bundled bodies).
    'TRADESELECT': 'drawTrade (DATA.events body)',
    'TRADESTART': 'drawTrade (DATA.events body)',
    'TRADEDELETE': 'drawTrade (DATA.events body)',
    # The opening cinematic cards, consumed as DATA.cards by drawCards.
    **{f'BUILD{i}': 'DATA.cards (drawCards/cardText)' for i in range(1, 11)},
    # The Europe harbour menu captions, read as DATA.events.<KEY>.body.
    'EUROPEARM': 'euroMenuBox (DATA.events body)',
    'EUROPESHIPCLICK': 'euroMenuBox (DATA.events body)',
    'KINGRECRUIT': 'euroMenuBox TRAIN caption (DATA.events body)',
}
# Keys whose BODIES the port paraphrases in its own UI -- swap these for the
# bundled text as they are found. (Emptied 2026-08-07: the five trade-route
# keys were the last, wired in the Phase 1 sweep.)
PARAPHRASED = {}
# Blocked on evidence that is NOT yet read -- each with the named blocker.
# These stay out deliberately (never guessed) until the Phase 4 capture or
# disasm window resolves them.
BLOCKED = {
    'CANTMOBILIZE': 'muskets gate absent from the byte-read mobilize (disasm)',
    'KINGMOBILIZE': 'REF-side mobilize announcement site unread (disasm)',
    'CARGOREADY0': 'func_008D00 READ 2026-08-07: capacity = (warehouse level+1)*100, '
                   'colony-wide (per-good refuted); remaining blocker = the disposal '
                   'gate thunk 0x191F:0x9C0 (does capacity gate the 100-cut?)',
    'FULL': 'no colony size cap model; threshold unread',
    'KINGBLESS': 'player-initiated audience entry point not byte-mapped',
    'KINGFUND': 'ditto', 'KINGLAUGH': 'ditto', 'KINGLOWER': 'ditto',
    'KINGNO': 'ditto', 'KINGNOTHING': 'ditto', 'KINGRAISE': 'ditto',
    'KINGWELCOME0': 'ditto',
    'LOOTFOREIGN': 'no rival treasure-fleet model',
    'RECRUIT2': 'native specialist-recruit site unclear (disasm)',
    'SHIPRUN': 'evade/blockade-run condition unmapped (disasm)',
    'SHIPSLOW': 'ditto',
    'SHIPLAKE': 'no inland-lake connectivity model',
    'TOOMANYCOLONIES': 'engine cap value unread (disasm)',
    'TOOMANYUNITS': 'ditto',
    'TOONEARBUILD': 'port founds instantly; no pending-build state',
    'HOWMUCH3': 'no carrier-to-carrier transfer site in the port',
    'APOSTATESUSA': 'reachable only via the USA suffix at runtime',
    'HEATHENUSA': 'ditto', 'RIDUSA': 'ditto', 'SIEGESUSA': 'ditto',
    'TRIBUTEUSA': 'ditto', 'WANTSTUFFUSA': 'ditto', 'PIRACYUSA': 'ditto',
}
# Structurally out of scope for the port -- each with the reason.
NA = {
    'SAVEGAME': 'port saves to localStorage, own UI', 'SAVEGOOD': 'ditto',
    'SAVEERROR': 'ditto', 'LOADGAME': 'ditto', 'LOADGOOD': 'ditto',
    'LOADERROR': 'ditto', 'LOADNOT': 'ditto', 'LOADOLD': 'ditto',
    'LOADSIZE': 'DOS disk-space check, no analogue',
    'MAPTOLOAD': 'DOS map-file picker, no analogue',
    'AMERICA': 'custom-world generator UI (port ships AMER2 only)',
    'CCLIM': 'custom-world label', 'CCONT': 'custom-world label',
    'CLAND': 'custom-world label', 'CTEMP': 'custom-world label',
    'MULTI': 'hot-seat multiplayer, out of scope',
    'MULTINEXT': 'ditto', 'MULTIREV': 'ditto',
    'COLONYFLAG': 'engine internal assertion string',
    'UNITFLAG': 'engine internal assertion string',
    'FINDCITY': 'debug locator', 'NOCITY': 'debug locator',
    'COLONYUNIT': 'debug locator',
    'RAIDSCALP': 'orphan -- no caller in the EXE (manual_src part5 22.x)',
}

exported = set(re.findall(r'"@([A-Z0-9]+)"', bnd))
quoted = set(re.findall(r"['\"]([A-Z][A-Z0-9]{2,})['\"]", src))
dyn = set(re.findall(r"`([A-Z][A-Z0-9]*)\$\{[^}]*\}`", src))
DYN_FAMILIES = ('MISSION', 'LOSTCITY', 'BURIAL', 'HERESY', 'VILLAGE',
                'TUTORIAL', 'PISS')


def wired(key):
    if key in quoted:
        return True
    return any(key.startswith(p) and len(key) <= len(p) + 2 and p in DYN_FAMILIES
               for p in dyn)


cats = {'DONE': [], 'DONE-VIA-DATA': [], 'PARAPHRASED': [],
        'BUNDLED-UNWIRED': [], 'BLOCKED (named blocker)': [], 'MISSING': [],
        'N/A': [], 'SUPPORT (no @width - lists/menus)': []}
for k in sorted(full):
    key = k.lstrip('@')
    if key in NA:
        cats['N/A'].append(f"{key} - {NA[key]}")
    elif key in BLOCKED and not (key in exported and wired(key)):
        cats['BLOCKED (named blocker)'].append(f"{key} - {BLOCKED[key]}")
    elif key in WIRED_VIA_DATA:
        cats['DONE-VIA-DATA'].append(f"{key} - {WIRED_VIA_DATA[key]}")
    elif key in PARAPHRASED:
        cats['PARAPHRASED'].append(f"{key} - {PARAPHRASED[key]}")
    elif not full[k].get('directives', {}).get('width'):
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
       "Regenerate with `python3 port/tools/message_status.py`.  DONE = text",
       "bundled AND a live call site exists; DONE-VIA-DATA = consumed through",
       "a DATA channel (annotated with the consumer); PARAPHRASED = the port",
       "renders its own copy of the body (swap for the bundled text);",
       "BUNDLED-UNWIRED = text exported, no trigger yet; MISSING = not in the",
       "port; N/A = structurally out of scope (annotated).  DONE does not",
       "certify trigger/format fidelity - flagged readings live in",
       "notes/rulings/RULINGS.md and the popup audit.  The completion",
       "roadmap is docs/COMPLETION_PLAN.md.", ""]
for c, v in cats.items():
    out += [f"## {c} ({len(v)})", ""] + [f"- {x}" for x in v] + [""]
(ROOT / 'docs/MESSAGE_STATUS.md').write_text("\n".join(out))
print("wrote docs/MESSAGE_STATUS.md: " +
      ", ".join(f"{c.split()[0]} {len(v)}" for c, v in cats.items()))
