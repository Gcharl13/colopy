#!/usr/bin/env python3
"""Validate that every binding the graphs + screens reference resolves to a schema column.

This is the "no orphan bindings" fidelity gate: it extracts binding paths from the logic graphs
(GetState.path, Formula.expr tokens, ShowPopup/{...} fills) and the screens ({path} in widget text),
normalizes each to (table, column) per schema.json's path grammar, and reports any that don't exist.
Exit non-zero if orphans are found. Usage: python3 tools/validate_schema.py
"""
import json, os, re, glob, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
def rd(p): return json.load(open(p))

SCHEMA = rd(os.path.join(ROOT, "data_extracted/engine/schema.json"))
TABLES = SCHEMA["tables"]

# entity-prefix -> state table name
ENTITY = {"power": "powers", "colony": "colonies", "unit": "units", "native": "settlements"}
# singleton tables addressed by their own name
SINGLETON = {t for t, b in TABLES.items() if b.get("kind") == "state"
             and b.get("cardinality") in ("singleton", "matrix")}
# world-level aliases that live under the `world` state table
WORLD_COLS = {c["name"] for c in TABLES.get("world", {}).get("columns", [])}
MARKET_COLS = {c["name"] for c in TABLES.get("market", {}).get("columns", [])}

def col_names(table):
    return {c["name"] for c in TABLES.get(table, {}).get("columns", [])}

def normalize_and_check(path):
    """Return (ok, resolved) for a binding path, or (True, 'skip') for non-bindings."""
    p = path.strip()
    if not p or p in ("true", "false"): return True, "skip"
    # reference cell @SECTION[row].col
    m = re.fullmatch(r"@([A-Z_]+)\[[^\]]*\]\.([A-Za-z0-9_]+)", p)
    if m:
        sec, col = "@" + m.group(1), m.group(2)
        return (col in col_names(sec)), f"{sec}.{col}"
    # cfg.<name>
    if p.startswith("cfg."):
        return (p[4:] in col_names("cfg")), p
    # entity<N>.col[.idx]
    m = re.match(r"^([a-z]+)(\d+)\.(.+)$", p)
    if m and m.group(1) in ENTITY:
        table, rest = ENTITY[m.group(1)], m.group(3)
        cols = col_names(table)
        if rest in cols: return True, f"{table}.{rest}"
        head = rest.split(".")[0]
        # indexed columns: stockpile.<good>, built.<id>
        for c in cols:
            if c.startswith(head + ".<"): return True, f"{table}.{c}"
        return False, f"{table}.{rest}"
    # market price.<g> / boycott.<g>
    if re.match(r"^(price|boycott)\.\d+$", p):
        base = p.split(".")[0] + ".<good>"
        return (base in MARKET_COLS), f"market.{base}"
    # war.<a>.<b>
    if re.match(r"^war\.\d+\.\d+$", p):
        return ("war.<a>.<b>" in col_names("diplomacy")), "diplomacy.war.<a>.<b>"
    # world aliases: colonies.count/population, units.count, terrain.defense.<id>
    if p in ("colonies.count", "colonies.population", "units.count") or p.startswith("terrain.defense."):
        key = "terrain.defense.<id>" if p.startswith("terrain.defense.") else p
        return (key in WORLD_COLS), f"world.{key}"
    # singleton.<col> (game, revolution, congress, ff, natives, ref, succession)
    head = p.split(".")[0]
    if head in SINGLETON or head in ("game", "world"):
        rest = p[len(head) + 1:]
        cols = col_names(head)
        if rest in cols: return True, p
        for c in cols:
            if c.startswith("<") or c.endswith(">"): return True, p  # ff.<id> style
            if "." in c and rest.split(".")[0] == c.split(".")[0]: return True, p
        # ff.<id>: numeric id
        if head == "ff" and re.match(r"^\d+$", rest): return True, "ff.<id>"
        return False, p
    return True, "skip"  # not a recognizable binding token (literal, pin name, etc.)

TOKEN = re.compile(r"@?[A-Za-z_][A-Za-z0-9_]*(?:\[[^\]]*\])?(?:\.[A-Za-z0-9_]+)+")

def extract_from_graph(g):
    out = []
    for n in g.get("nodes", []):
        t, pr = n.get("type"), n.get("params", {})
        if t == "GetState" and pr.get("path"): out.append(pr["path"])
        if t == "Formula" and pr.get("expr"):
            out += [tok for tok in TOKEN.findall(pr["expr"]) if "." in tok or tok.startswith("@")]
        for key in ("body", "text"):
            if isinstance(pr.get(key), str):
                out += re.findall(r"\{([^}]+)\}", pr[key])
    return out

def extract_from_screen(s):
    out = []
    for w in s.get("widgets", []):
        if isinstance(w.get("text"), str): out += re.findall(r"\{([^}]+)\}", w["text"])
    return out

def main():
    orphans, checked = [], 0
    for f in glob.glob(os.path.join(ROOT, "data_extracted/engine/graphs/*.json")):
        for path in extract_from_graph(rd(f)):
            checked += 1
            ok, resolved = normalize_and_check(path)
            if not ok: orphans.append((os.path.basename(f), path, resolved))
    for f in glob.glob(os.path.join(ROOT, "data_extracted/engine/screens/*.json")):
        for path in extract_from_screen(rd(f)):
            checked += 1
            ok, resolved = normalize_and_check(path)
            if not ok: orphans.append((os.path.basename(f), path, resolved))
    print(f"checked {checked} binding references across graphs + screens")
    if orphans:
        print(f"ORPHANS ({len(orphans)}): bindings with no schema column:")
        for src, path, res in orphans: print(f"  {src}: {path}  (-> {res})")
        sys.exit(1)
    print("SCHEMA OK: every binding resolves to a schema column")

if __name__ == "__main__":
    main()
