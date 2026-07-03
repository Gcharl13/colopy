#!/usr/bin/env python3
"""Generate data/base/*.rec from the extraction JSON (Drydock P0 migration).

One-shot-but-idempotent: reads data_extracted/tables/names_tables.json and
writes the canonical one-record-per-file layout for the migrated types
(GOOD <- @CARGO, UNIT <- @UNIT, PROF <- @JOB). The output must be
byte-identical to what the C++ canonical serializer would emit -- the
drydockc round-trip gate enforces that, and the drydock_migrate ctest diffs a
regeneration against the committed files (so data/base cannot silently drift
from its extraction provenance).

Every column is carried losslessly; `index` preserves the EXE-parity row
ordinal (load-bearing: unit type ids, goods indices, profession ids).

Usage: tools/drydock_migrate.py [--check]   (--check: diff only, no writes)
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "data_extracted/tables/names_tables.json")
OUT = os.path.join(ROOT, "data/base")

# (type, @SECTION, [(rec_field, src_column, kind)...]) -- schema field order.
TYPES = [
    ("good", "@CARGO", [
        ("name", "name", "str"),
        ("price_start1", "price_start1", "int"), ("price_start2", "price_start2", "int"),
        ("drift_low", "drift_low", "int"), ("drift_high", "drift_high", "int"),
        ("burden", "burden", "int"), ("rise", "rise", "int"), ("fall", "fall", "int"),
        ("attrition", "attrition", "int"), ("volatility", "volatility", "int"),
    ]),
    ("unit", "@UNIT", [
        ("name", "name", "str"), ("icon", "icon", "int"), ("movement", "movement", "int"),
        ("attack", "attack", "int"), ("combat", "combat", "int"), ("cargo", "cargo", "int"),
        ("size", "size", "int"), ("cost", "cost", "int"), ("tools", "tools", "int"),
        ("guns", "guns", "int"), ("hull", "hull", "int"),
        ("ai_role_bits", "ai_role_bits", "str"),
    ]),
    ("prof", "@JOB", [
        ("name", "name", "str"), ("expert_name", "expert_name", "str"),
        ("school_tier", "school_tier", "int"), ("europe_value", "europe_value", "int"),
    ]),
    ("bldg", "@BUILDING", [
        ("name", "name", "str"), ("cost", "cost", "int"), ("tools_x10", "tools_x10", "int"),
        ("size", "size", "int"), ("min_colony", "min_colony", "int"), ("upkeep", "upkeep", "int"),
    ]),
]

TERR_COLS = [("name", "name", "str"), ("movement", "movement", "int"),
             ("defensive", "defensive", "int"), ("improvement", "improvement", "int"),
             ("value", "value", "int"), ("y_farmer", "y_farmer", "int"),
             ("y_planter_sugar", "y_planter_sugar", "int"),
             ("y_planter_tobacco", "y_planter_tobacco", "int"),
             ("y_planter_cotton", "y_planter_cotton", "int"),
             ("y_trapper", "y_trapper", "int"), ("y_lumberjack", "y_lumberjack", "int"),
             ("y_ore", "y_ore", "int"), ("y_silver", "y_silver", "int"),
             ("y_fisherman", "y_fisherman", "int")]


def terr_rows(tables):
    """29 terrain-id rows: 0-7 @UNFORESTED, 8-15 and 16-23 @FORESTED (the two
    forested bands share the 8 rows -- the render/classify fold (id&7)|8),
    24-28 @OTHER. Band-2 record ids get a _2 suffix."""
    un = tables["@UNFORESTED"]["rows"]
    fo = tables["@FORESTED"]["rows"]
    ot = tables["@OTHER"]["rows"]
    out = []
    for r in un: out.append((r, ""))
    for r in fo: out.append((r, ""))
    for r in fo: out.append((r, "_2"))
    for r in ot: out.append((r, ""))
    return out


def slug(name, used):
    s = re.sub(r"[^a-z0-9]+", "_", name.lower()).strip("_") or "row"
    base, n = s, 2
    while s in used:
        s = f"{base}_{n}"
        n += 1
    used.add(s)
    return s


def quote(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'


def render(rec_id, fields):
    """fields: [(name, rendered_value)] in schema order; mirrors serialize_record."""
    w = max(len(n) for n, _ in fields)
    out = ["record " + rec_id + " {"]
    for n, v in fields:
        out.append("  " + n + " " * (w - len(n)) + " = " + v)
    out.append("}")
    return "\n".join(out) + "\n"


def emit(path_rel, text, check, drift):
    path = os.path.join(OUT, path_rel)
    old = open(path).read() if os.path.exists(path) else None
    if old != text:
        drift += 1
        if check:
            print(f"DRIFT: {path}")
        else:
            os.makedirs(os.path.dirname(path), exist_ok=True)
            open(path, "w").write(text)
            print(f"wrote {os.path.relpath(path, ROOT)}")
    return drift


def main():
    check = "--check" in sys.argv
    tables = json.load(open(SRC))
    drift = 0

    # TERR: the 29-id space assembled from the three yield tables
    used = set()
    for idx, (row, suffix) in enumerate(terr_rows(tables)):
        rid = f"terr.{slug(row['name'] + suffix, used)}"
        fields = [("index", str(idx))]
        for fname, col, kind in TERR_COLS:
            v = row.get(col, "")
            if str(v).strip() == "":
                continue
            fields.append((fname, quote(str(v)) if kind == "str" else str(int(v))))
        drift = emit(os.path.join("terr", rid.split(".", 1)[1] + ".rec"),
                     render(rid, fields), check, drift)

    # CONF: cfg.json knobs (value scalar OR ordered values list)
    cfg = json.load(open(os.path.join(ROOT, "data_extracted/engine/cfg.json")))
    for group, knobs in cfg["groups"].items():
        for k in knobs:
            rid = f"conf.{k['name']}"
            fields = []
            if isinstance(k["default"], list):
                fields.append(("values", "[" + ", ".join(str(int(x)) for x in k["default"]) + "]"))
            else:
                fields.append(("value", str(int(k["default"]))))
            fields.append(("group", quote(group)))
            fields.append(("doc", quote(str(k.get("meaning", "")))))
            drift = emit(os.path.join("conf", k["name"] + ".rec"),
                         render(rid, fields), check, drift)

    # PHAS: turn.json pipeline entries, order = index
    tj = json.load(open(os.path.join(ROOT, "data_extracted/engine/turn.json")))
    for idx, ph in enumerate(tj["phases"]):
        rid = f"phas.{ph['id']}"
        fields = [("index", str(idx)),
                  ("function", quote(ph["function"])),
                  ("scope", quote(ph.get("scope", "global"))),
                  ("enabled", "1" if ph.get("enabled", True) else "0")]
        for lk in ("reads", "writes"):
            if ph.get(lk):
                fields.append((lk, "[" + ", ".join(quote(x) for x in sorted(ph[lk])) + "]"))
        if ph.get("note"):
            fields.append(("doc", quote(ph["note"])))
        drift = emit(os.path.join("phas", ph["id"] + ".rec"),
                     render(rid, fields), check, drift)
    for type_code, section, cols in TYPES:
        rows = tables[section]["rows"]
        used = set()
        for idx, row in enumerate(rows):
            rid = f"{type_code}.{slug(row['name'], used)}"
            fields = [("index", str(idx))]
            for fname, col, kind in cols:
                v = row.get(col, "")
                if str(v).strip() == "":
                    continue                      # empty source cell -> field absent (lossless)
                fields.append((fname, quote(str(v)) if kind == "str" else str(int(v))))
            drift = emit(os.path.join(type_code, rid.split(".", 1)[1] + ".rec"),
                         render(rid, fields), check, drift)
    if check:
        print("drydock_migrate --check:", "DRIFT" if drift else "OK",
              f"({drift} files)" if drift else "(data/base matches extraction)")
        sys.exit(1 if drift else 0)
    print(f"drydock_migrate: {drift} files (re)written")


if __name__ == "__main__":
    main()
