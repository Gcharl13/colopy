#!/usr/bin/env python3
"""symbolize.py — stamp decoded names onto the flat substrate (INTERNAL, regenerable).

Post-pass over tools/deoverlay.py output (code/VICEROY/flat/). Pulls names from committed sources:
  * function ROLES  — the 119 role-named disasm filenames (func_XXXXXX_<role>.asm) + NAMES roles
  * DGROUP global NAMES — data_extracted/tables/dgroup_tables.json `scalars` (28) + load-bearing
    record bases from docs/DATA_MODEL.md
Emits code/VICEROY/flat/symbols.json and rewrites functions.jsonl with `role` + named `globals`/calls.
"""
import json, re, glob
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DIS = ROOT / "code/VICEROY/disasm"
FLAT = ROOT / "code/VICEROY/flat"

# ---- function roles from filenames ----------------------------------------------------------
roles = {}   # func_NAME(upper) -> role
for p in DIS.glob("func_*.asm"):
    m = re.match(r"^func_([0-9A-Fa-f]{6})_(.+)\.asm$", p.name)
    if m and m.group(2) != "unknown":
        roles[f"func_{m.group(1).upper()}"] = m.group(2)

# ---- DGROUP global names --------------------------------------------------------------------
gnames = {}   # int offset -> name
dg = json.load(open(ROOT / "data_extracted/tables/dgroup_tables.json"))
for s in dg.get("scalars", []):
    a = s["address"].strip("`")
    try:
        gnames[int(a, 16)] = s["row"].get("Meaning", "").strip()
    except ValueError:
        pass
# load-bearing record bases (DATA_MODEL.md / SETTLED) — few, well-verified, high-traffic
gnames.update({
    0x8542: "active_colony_ptr", 0x5D46: "ColonyRecord_base", 0x3144: "UnitRecord_base",
    0x8809: "PowerRecord_base", 0x539E: "num_colonies", 0x539A: "num_native_settlements",
    0x853A: "map_width", 0x853C: "map_height", 0x853E: "cursor_y", 0x8540: "cursor_x",
    0x54EC: "UnitTypeStats_base", 0x5AD6: "TribeData_base", 0x540E: "NativeSettlement_base",
    0x28EE: "rng_seed_lo", 0x28F0: "rng_seed_hi", 0x18E: "terrain_display_mode",
})

def gname(hexoff):
    return gnames.get(int(hexoff, 16))

# ---- enrich functions.jsonl -----------------------------------------------------------------
recs = [json.loads(l) for l in open(FLAT / "functions.jsonl")]
for r in recs:
    r["role"] = roles.get(r["name"])
    r["globals"] = [{"off": g, "name": gname(g)} for g in r["globals"]]
    for c in r["calls"]:
        c["target_role"] = roles.get(c.get("target_name"))
with open(FLAT / "functions.jsonl", "w") as f:
    for r in recs:
        f.write(json.dumps(r) + "\n")

json.dump({"functions": roles, "globals": {f"0x{k:X}": v for k, v in sorted(gnames.items())}},
          open(FLAT / "symbols.json", "w"), indent=1)
print(f"symbolize: {len(roles)} function roles, {len(gnames)} named globals -> flat/symbols.json")
print(f"  enriched {len(recs)} functions.jsonl records (role + named globals/calls)")
