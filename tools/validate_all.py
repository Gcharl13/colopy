#!/usr/bin/env python3
"""Comprehensive cross-reference validator (B12): every reference across the data set resolves.

Beyond the binding/schema check (tools/validate_schema.py), this verifies the links that tie the
game data together, so a dangling reference fails CI instead of surfacing at runtime:
  1. screen button onClick        -> an existing graph id
  2. graph ShowPopup/Notify @KEY  -> an existing GAME.TXT message
  3. graph FireEvent graph        -> an existing graph id
  4. graph Navigate screen        -> an existing screen id
  5. effects.json force_composition unit/carrier names -> a row in @UNIT
  6. turn.json phase functions    -> the pipeline's known dispatch set
  7. scenario unit 'type' names    -> a row in @UNIT

Exit non-zero on any dangling reference. Usage: python3 tools/validate_all.py
"""
import json, os, glob, sys, re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
def rd(p): return json.load(open(p))
def exists(p): return os.path.exists(os.path.join(ROOT, p))

ENG = os.path.join(ROOT, "data_extracted/engine")
GRAPH_IDS = {os.path.splitext(os.path.basename(f))[0] for f in glob.glob(ENG + "/graphs/*.json")}
SCREEN_IDS = {os.path.splitext(os.path.basename(f))[0] for f in glob.glob(ENG + "/screens/*.json")}

# GAME.TXT message keys (the @KEY set a ShowPopup may reference)
GAME_TXT = rd(os.path.join(ROOT, "data_extracted/text/GAME_sections.json"))
MSG_KEYS = set(GAME_TXT.keys())

# @UNIT names (row index == type id); the effect + scenario unit names must resolve here
NAMES = rd(os.path.join(ROOT, "data_extracted/tables/names_tables.json"))
UNIT_NAMES = {r["name"] for r in NAMES.get("@UNIT", {}).get("rows", []) if isinstance(r, dict) and "name" in r}

# the pipeline's known phase functions (forge/turnpipe.cpp dispatch)
TURN_FUNCS = {"colony_economic_step", "price_drift", "immigration_step",
              "ref_accrue_purchase", "refresh_and_orders", "advance_cadence",
              "apply_orders"}

errors = []
checked = 0

def check(cond, msg):
    global checked; checked += 1
    if not cond: errors.append(msg)

# 1/3/4: graph references (onClick handled in screens below; here FireEvent + Navigate + textKey)
for f in glob.glob(ENG + "/graphs/*.json"):
    g = rd(f); gid = os.path.basename(f)
    for n in g.get("nodes", []):
        t, pr = n.get("type"), n.get("params", {})
        if t in ("ShowPopup", "Notify"):
            key = pr.get("textKey", "")
            if key:
                check(key in MSG_KEYS, f"{gid}: {t} textKey '{key}' not in GAME.TXT")
        if t == "FireEvent" and pr.get("graph"):
            check(pr["graph"] in GRAPH_IDS, f"{gid}: FireEvent -> unknown graph '{pr['graph']}'")
        if t == "Navigate" and pr.get("screen"):
            check(pr["screen"] in SCREEN_IDS, f"{gid}: Navigate -> unknown screen '{pr['screen']}'")

# 2: screen button onClick -> existing graph
for f in glob.glob(ENG + "/screens/*.json"):
    s = rd(f); sid = os.path.basename(f)
    for w in s.get("widgets", []):
        oc = w.get("onClick")
        if oc:
            check(oc in GRAPH_IDS, f"{sid}: button onClick -> unknown graph '{oc}'")

# 5: effects force-composition unit + carrier names -> @UNIT
if exists("data_extracted/engine/effects.json"):
    eff = rd(os.path.join(ENG, "effects.json"))
    for name, comp in eff.get("force_composition", {}).items():
        for cat in comp.get("categories", []):
            u = cat.get("unit")
            if u: check(u in UNIT_NAMES, f"effects.json {name}: unit '{u}' not in @UNIT")
        carrier = comp.get("carrier")
        if carrier: check(carrier in UNIT_NAMES, f"effects.json {name}: carrier '{carrier}' not in @UNIT")

# 6: turn.json phase functions -> known dispatch
if exists("data_extracted/engine/turn.json"):
    turn = rd(os.path.join(ENG, "turn.json"))
    for ph in turn.get("phases", []):
        fn = ph.get("function")
        if fn: check(fn in TURN_FUNCS, f"turn.json: phase '{ph.get('id')}' function '{fn}' unknown to the pipeline")

# 7: scenario unit type names -> @UNIT
for f in glob.glob(ENG + "/scenarios/*.json"):
    sc = rd(f); scid = os.path.basename(f)
    for u in sc.get("units", []):
        tn = u.get("type")
        if tn: check(tn in UNIT_NAMES, f"{scid}: scenario unit type '{tn}' not in @UNIT")

print(f"validate_all: checked {checked} cross-references")
if errors:
    print(f"DANGLING ({len(errors)}):")
    for e in errors: print("  " + e)
    sys.exit(1)
print("CROSS-REFS OK: every screen/graph/effect/turn/scenario reference resolves")

if __name__ == "__main__":
    pass
