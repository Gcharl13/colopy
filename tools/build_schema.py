#!/usr/bin/env python3
"""Assemble the ONE authoritative schema (the DDL) + the enriched function catalog.

The game is a database. This unifies the three data kinds into data_extracted/engine/schema.json:
  * reference tables  (names_tables.json + tribe_tables.json)      kind="reference"
  * state tables      (bindings.json, cited to dgroup records)     kind="state"
  * config scalars    (cfg.json, from sim/rules.hpp Config)        kind="config"
Each column carries {name, type, default?, rw, meaning, tier, source}. It also enriches
functions.json with per-function `writes` (from function_writes.json) and a generated reverse
index (column -> functions that write it), and regenerates variables.json (compat) + schemas.md.

Sources are DATA files (no hardcoded catalog in Python), so any language can rebuild the engine
from data_extracted/. Usage: python3 tools/build_schema.py
"""
import json, os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
def rd(p): return json.load(open(os.path.join(ROOT, p)))
def wr(p, obj): json.dump(obj, open(os.path.join(ROOT, p), "w"), indent=2);

def infer_type(rows, col):
    """int if every present value parses as a number, else str."""
    saw = False
    for r in rows:
        v = r.get(col)
        if v is None or v == "": continue
        saw = True
        try: float(v)
        except (ValueError, TypeError): return "str"
    return "int" if saw else "str"

def build_schema(names, tribes, dgroup, binds, cfg):
    tables = {}
    # --- reference tables (names + tribe) ---
    def add_reference(src):
        for sec, body in src.items():
            if not (isinstance(body, dict) and isinstance(body.get("rows"), list)): continue
            rows = body["rows"]
            cols = body.get("columns") or (list(rows[0].keys()) if rows else [])
            tables[sec] = {
                "kind": "reference",
                "cardinality": "table",
                "rows": len(rows),
                "columns": [{"name": c, "type": infer_type(rows, c), "rw": "write",
                             "meaning": "", "tier": "B", "source": "NAMES.TXT" if src is names else "TRIBE.TXT"}
                            for c in cols],
            }
    add_reference(names)
    add_reference(tribes)
    # --- state tables (bindings.json) ---
    for tname, body in binds["state_tables"].items():
        tables[tname] = {
            "kind": "state",
            "cardinality": body["cardinality"],
            "index": body.get("index", tname),
            **({"count": body["count"]} if "count" in body else {}),
            **({"count_source": body["count_source"]} if "count_source" in body else {}),
            "columns": body["columns"],
        }
    # --- config table (cfg.json) ---
    cfg_cols = []
    for group, items in cfg["groups"].items():
        for it in items:
            cfg_cols.append({"name": it["name"], "type": "int-list" if isinstance(it["default"], list) else "int",
                             "default": it["default"], "rw": "write", "group": group,
                             "meaning": it["meaning"], "tier": "R", "source": "sim/rules.hpp Config"})
    tables["cfg"] = {"kind": "config", "cardinality": "singleton", "index": "cfg", "columns": cfg_cols}

    kinds = {}
    for t in tables.values(): kinds[t["kind"]] = kinds.get(t["kind"], 0) + 1
    return {
        "_note": ("The authoritative game database schema (DDL). Three kinds: reference (rules data, "
                  "NAMES/TRIBE), state (dynamic per-turn records, cited to the dgroup memory map for "
                  "traceability only), config (tunable cfg scalars). One path grammar addresses any "
                  "cell: game.<col>, power<N>.<col>, colony<N>.<col> / colony<N>.stockpile.<good>, "
                  "unit<N>.<col>, @SECTION[row].col, cfg.<name>. The runtime interprets this schema; "
                  "no offsets are needed to rebuild."),
        "path_grammar": {
            "singleton": "<table>.<col>            e.g. game.turn, revolution.sol, cfg.max_population",
            "entity": "<table_singular><N>.<col>  e.g. power0.gold, colony2.population, unit5.type",
            "indexed_col": "<...>.<col>.<idx>     e.g. colony0.stockpile.3, ff.16, price.9",
            "reference": "@SECTION[<row index or name:VALUE>].<column>  e.g. @BUILDING[name:Fort].cost",
        },
        "kind_counts": kinds,
        "tables": tables,
    }

def build_functions(base, writes_map):
    """Merge `writes` into each formula + generate the reverse index column -> writers."""
    reverse = {}
    for sys in base["systems"]:
        for f in sys["formulas"]:
            w = writes_map["writes"].get(f["fn"], [])
            f["writes"] = w
            for col in w:
                reverse.setdefault(col, [])
                if f["fn"] not in reverse[col]: reverse[col].append(f["fn"])
    base["_note"] = ("The sim's functions and their I/O. `knobs` = the editable cfg inputs a formula "
                     "READS; `writes` = the schema columns it mutates. `reverse_index` inverts it: "
                     "for each state column, which functions update it (the 'how it's updated' map).")
    base["reverse_index"] = dict(sorted(reverse.items()))
    return base

def build_variables(names, binds):
    """Compat variables.json: live-state (from bindings.json) + table sections (from names)."""
    out = {"_note": "Generated from bindings.json + names_tables.json by tools/build_schema.py. "
                    "Live-state names resolve via forge/engine.cpp; table cells use @SECTION[row].col.",
           "live_state": {}, "table_cells": {"_syntax": "@SECTION[<row index or name:VALUE>].<column>",
           "_examples": ["@BUILDING[name:Fort].cost", "@CLASS[3].transport_cost"], "sections": {}}}
    for tname, body in binds["state_tables"].items():
        idx = body.get("index", tname)
        group = []
        for c in body["columns"]:
            path = c["name"] if "." in c["name"] or idx == "" else (idx + "." + c["name"] if idx else c["name"])
            group.append({"name": path, "type": c["type"], "writable": c["rw"] == "write",
                          "source": c["source"], "meaning": c["meaning"]})
        out["live_state"][tname] = group
    for sec, body in names.items():
        if isinstance(body, dict) and isinstance(body.get("rows"), list):
            cols = body.get("columns") or (list(body["rows"][0].keys()) if body["rows"] else [])
            out["table_cells"]["sections"][sec] = {"columns": cols, "rows": len(body["rows"])}
    return out

def write_schemas_md(schema, funcs):
    kc = schema["kind_counts"]
    lines = ["# Forge engine — the game database schema", "",
             "The game is a **database** mutated by functions and events. Everything is data:",
             "**reference** tables (rules), **state** tables (dynamic records), **config** scalars.",
             "The runtime interprets this schema; offsets are traceability-only.", "",
             f"- Tables: {sum(kc.values())} total — {kc.get('reference',0)} reference, "
             f"{kc.get('state',0)} state, {kc.get('config',0)} config.", "",
             "## Path grammar (one interface addresses any cell)"]
    for k, v in schema["path_grammar"].items(): lines.append(f"- **{k}**: `{v}`")
    lines += ["", "## State tables", ""]
    for tname, t in schema["tables"].items():
        if t["kind"] != "state": continue
        lines.append(f"- **{tname}** ({t['cardinality']}, `{t.get('index',tname)}`): "
                     + ", ".join(c["name"] for c in t["columns"]))
    lines += ["", "## Config (cfg.<name>) — tunable scalars", "",
              ", ".join(c["name"] for c in schema["tables"]["cfg"]["columns"]), "",
              "## Reference tables (@SECTION[row].col)", ""]
    refs = [n for n, t in schema["tables"].items() if t["kind"] == "reference"]
    lines.append(", ".join(refs))
    lines += ["", "## Functions → columns (update rules)",
              "Each function's `writes` and the `reverse_index` (column → writers) live in "
              "`functions.json`. Example writers:"]
    for col, fns in list(funcs["reverse_index"].items())[:10]:
        lines.append(f"- `{col}` ← {', '.join(fns)}")
    open(os.path.join(ROOT, "data_extracted/engine/schemas.md"), "w").write("\n".join(lines) + "\n")

def main():
    names  = rd("data_extracted/tables/names_tables.json")
    tribes = rd("data_extracted/tables/tribe_tables.json")
    dgroup = rd("data_extracted/tables/dgroup_tables.json")
    binds  = rd("data_extracted/engine/bindings.json")
    cfg    = rd("data_extracted/engine/cfg.json")
    writes = rd("data_extracted/engine/function_writes.json")
    funcs  = rd("data_extracted/engine/functions.json")

    schema = build_schema(names, tribes, dgroup, binds, cfg)
    wr("data_extracted/engine/schema.json", schema)
    funcs = build_functions(funcs, writes)
    wr("data_extracted/engine/functions.json", funcs)
    variables = build_variables(names, binds)
    wr("data_extracted/engine/variables.json", variables)
    write_schemas_md(schema, funcs)

    kc = schema["kind_counts"]
    ncols = sum(len(t["columns"]) for t in schema["tables"].values())
    print(f"schema.json: {sum(kc.values())} tables ({kc}), {ncols} columns")
    print(f"functions.json: {sum(len(s['formulas']) for s in funcs['systems'])} functions, "
          f"{len(funcs['reverse_index'])} columns with writers")
    print(f"variables.json: {sum(len(v) for v in variables['live_state'].values())} live names, "
          f"{len(variables['table_cells']['sections'])} sections")

if __name__ == "__main__":
    main()
