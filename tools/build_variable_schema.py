#!/usr/bin/env python3
"""Generate the canonical variable schema + function catalog for the Logic engine.

The game's variables come from three places; this unifies them into ONE namespace that
both the data tables and the logic graphs reference:

  * live game state  -> bindings like power0.gold, colony0.hammers, revolution.sol
                        (resolved by forge/engine.cpp resolve_binding; each maps to a real
                         DGROUP record field in data_extracted/tables/dgroup_tables.json)
  * data-table cells -> @SECTION[row].column or @SECTION[name:X].column (any row added in the
                        Tables tab is instantly usable -- see forge/engine.cpp table_cell)
  * functions        -> the sim formulas (forge/formulas.cpp), each with its input "knobs"
                        and the variables it reads/writes.

Outputs:
  data_extracted/engine/variables.json   the variable catalog (live bindings + table sections)
  data_extracted/engine/functions.json   the function catalog (from /api/formulas, if provided)
  data_extracted/engine/schemas.md       a human-readable reference

Usage: python3 tools/build_variable_schema.py [path/to/formulas.json]
"""
import json, sys, os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
def rd(p): return json.load(open(os.path.join(ROOT, p)))

# ---- live-state binding catalog (mirrors forge/engine.cpp resolve_binding/set_binding) ----
# (name_or_pattern, type, writable, dgroup_source, meaning)
LIVE = {
  "Game clock": [
    ("game.year", "int", True,  "[0x538A]", "current year"),
    ("game.season", "int", True, "[0x538C]", "0=Spring/early, 1=Autumn"),
    ("game.turn", "int", True,  "[0x538E]", "turn counter"),
    ("game.difficulty", "int", True, "[0x53A6]", "0..4 (Discoverer..Viceroy)"),
    ("game.score", "int", False, "[0x0372]", "last computed game score"),
  ],
  "Power (power0..power3)": [
    ("power<N>.gold", "int", True, "PowerRecord +0x2A", "treasury"),
    ("power<N>.tax", "int", True, "PowerRecord +0x01", "tax rate %"),
    ("power<N>.royal_money", "int", False, "PowerRecord +0x22", "King's REF budget"),
    ("power<N>.crosses", "int", True, "PowerRecord +0x2E", "accumulated immigration crosses"),
    ("power<N>.mil_strength", "int", True, "[0x9418]*", "military strength (succession rank input)"),
    ("power<N>.econ_strength", "int", True, "[0x9410]*", "economic strength (succession/king inputs)"),
    ("power<N>.colonies", "int", False, "computed", "owned colony count"),
    ("power<N>.units", "int", False, "computed", "owned on-map unit count"),
    ("power<N>.strength", "int", False, "computed", "rank = 3*mil + 2*colonies + econ"),
  ],
  "Colony (colony0..)": [
    ("colony<N>.population", "int", True, "ColonyRecord +0x1F", "colonists"),
    ("colony<N>.sol", "int", False, "from +0xC2/+0xC6", "Sons of Liberty %"),
    ("colony<N>.bells", "int", False, "good 0x12 out", "liberty bells per turn"),
    ("colony<N>.hammers", "int", False, "good 0x10 out", "hammers per turn"),
    ("colony<N>.food", "int", False, "net food", "food surplus per turn"),
    ("colony<N>.crosses", "int", False, "ColonyRecord +0x05", "crosses output (feeds immigration)"),
    ("colony<N>.owner", "int", False, "ColonyRecord +0x1A", "owner power 0..3"),
    ("colony<N>.build_target", "int", False, "ColonyRecord +0x94", "building id under construction (-1 none)"),
    ("colony<N>.build_cost", "int", False, "@BUILDING cost", "hammers the target needs"),
    ("colony<N>.build_bank", "int", False, "ColonyRecord +0xB6", "hammers accumulated (the 'X of Y')"),
    ("colony<N>.build_remaining", "int", False, "computed", "max(0, build_cost - build_bank)"),
    ("colony<N>.building_name", "str", False, "@BUILDING name", "the in-progress building's name"),
    ("colony<N>.warehouse", "int", False, "ColonyRecord +0x95", "warehouse level 0/1/2"),
    ("colony<N>.built.<id>", "int", False, "ColonyRecord +0x84", "1 if building <id> is constructed"),
  ],
  "Unit (unit0..)": [
    ("unit<N>.type", "int", False, "UnitRecord +0x00", "@UNIT row index 0..23"),
    ("unit<N>.owner", "int", False, "UnitRecord +0x01", "owner power"),
    ("unit<N>.profession", "int", False, "UnitRecord +0x17", "class/profession 0x13..0x1C"),
    ("unit<N>.x / unit<N>.y", "int", False, "UnitRecord +0x07/+0x08", "map position"),
    ("unit<N>.alive", "int", False, "UnitRecord +0x08(alive)", "1 if alive"),
    ("unit<N>.attack", "int", False, "@UNIT attack", "attack strength (from its type)"),
    ("unit<N>.defense", "int", False, "@UNIT combat", "defense strength (from its type)"),
    ("unit<N>.movement", "int", False, "@UNIT movement", "move allowance"),
    ("unit<N>.terrain", "int", False, "map tile", "terrain id at the unit's tile"),
    ("unit<N>.terraindef", "int", False, "@TERRAIN defensive", "terrain defense bonus at its tile"),
  ],
  "Natives / Congress / Revolution": [
    ("natives.tension", "int", True, "settlement alarm", "0..100 alarm proxy (war at >=~128/80)"),
    ("congress.bells", "int", True, "PowerRecord +0x0C", "liberty-bell pool toward next Father"),
    ("congress.cost", "int", False, "func_03C282", "bell cost of the next Founding Father"),
    ("congress.era_band", "int", False, "func_03B95A", "0 (<1600) / 1 (1600-99) / 2 (>=1700)"),
    ("congress.count", "int", False, "popcount", "Founding Fathers acquired"),
    ("ff.count", "int", False, "popcount +0x07", "Founding Fathers acquired"),
    ("ff.<id>", "int", False, "PowerRecord +0x07 bit", "1 if Father <id> (0..24) is held"),
    ("revolution.sol", "int", True, "[0x53D0]", "national Sons of Liberty meter 0..100"),
    ("revolution.declared", "int", False, "[0x5382]&1", "1 if War of Independence declared"),
    ("revolution.rebel", "int", False, "[0x5398]", "power that declared independence"),
    ("succession.seceded", "int", False, "[0x53D2]", "power withdrawn by Spanish Succession"),
  ],
  "World / market / diplomacy": [
    ("colonies.count", "int", False, "[0x539E]", "total colonies"),
    ("colonies.population", "int", False, "sum +0x1F", "total colonists across colonies"),
    ("units.count", "int", False, "[0x539C]", "total on-map units"),
    ("ref.regulars / cavalry / manowar / artillery", "int", False, "[0x53DA..0x53E0]", "Royal Expeditionary Force counts"),
    ("price.<good>", "int", True, "[0x53EA]", "European base price for good 0..15"),
    ("boycott.<good>", "int", False, "PowerRecord +0x20 bit", "1 if good is boycotted"),
    ("war.<a>.<b>", "int", False, "diplomacy matrix", "1 if powers a,b are at war"),
    ("terrain.defense.<id>", "int", False, "@TERRAIN defensive", "terrain id defense value"),
  ],
}

def build_variables(names):
    out = {
      "_note": ("Canonical variable namespace shared by the logic and the tables. Live-state names are "
                "resolved by forge/engine.cpp resolve_binding (each maps to the DGROUP source shown); "
                "table cells use @SECTION[row].column or @SECTION[name:X].column and any row you add in "
                "the Tables tab is immediately usable. <N> is an index, <good>=0..15, <id> a row/bit. "
                "* = the DGROUP array is proxied by an editable field (undecoded magnitude)."),
      "live_state": {},
      "table_cells": {
        "_syntax": "@SECTION[<row index or name:VALUE>].<column>",
        "_examples": ["@BUILDING[name:Fort].cost", "@CLASS[3].transport_cost", "@UNIT[name:Soldiers].attack"],
        "sections": {},
      },
    }
    for group, rows in LIVE.items():
        out["live_state"][group] = [
            {"name": n, "type": t, "writable": w, "source": s, "meaning": m} for (n,t,w,s,m) in rows]
    # auto-enumerate every table section + its columns (so the catalog stays complete)
    for sec, body in names.items():
        if isinstance(body, dict) and isinstance(body.get("rows"), list):
            cols = body.get("columns") or (list(body["rows"][0].keys()) if body["rows"] else [])
            out["table_cells"]["sections"][sec] = {
                "columns": cols, "rows": body.get("row_count", len(body["rows"])),
                "legend": body.get("legend", []),
            }
    return out

def build_functions(formulas):
    if not formulas: return None
    out = {"_note": ("The sim's functions and their I/O (transcribed from forge/formulas.cpp; also at "
                     "/api/formulas). 'knobs' are the editable input variables each formula reads."),
           "systems": formulas.get("systems", [])}
    return out

def main():
    names = rd("data_extracted/tables/names_tables.json")
    formulas = None
    if len(sys.argv) > 1 and os.path.exists(sys.argv[1]):
        formulas = json.load(open(sys.argv[1]))
    os.makedirs(os.path.join(ROOT, "data_extracted/engine"), exist_ok=True)
    variables = build_variables(names)
    json.dump(variables, open(os.path.join(ROOT, "data_extracted/engine/variables.json"), "w"), indent=2)
    nlive = sum(len(v) for v in variables["live_state"].values())
    nsec = len(variables["table_cells"]["sections"])
    print(f"variables.json: {nlive} live-state names, {nsec} table sections")
    funcs = build_functions(formulas)
    if funcs:
        json.dump(funcs, open(os.path.join(ROOT, "data_extracted/engine/functions.json"), "w"), indent=2)
        nfn = sum(len(s["formulas"]) for s in funcs["systems"])
        print(f"functions.json: {len(funcs['systems'])} systems, {nfn} functions")

if __name__ == "__main__":
    main()
