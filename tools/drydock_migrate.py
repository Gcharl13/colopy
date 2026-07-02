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
]


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


def main():
    check = "--check" in sys.argv
    tables = json.load(open(SRC))
    drift = 0
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
            text = render(rid, fields)
            path = os.path.join(OUT, type_code, rid.split(".", 1)[1] + ".rec")
            old = open(path).read() if os.path.exists(path) else None
            if old != text:
                drift += 1
                if check:
                    print(f"DRIFT: {path}")
                else:
                    os.makedirs(os.path.dirname(path), exist_ok=True)
                    open(path, "w").write(text)
                    print(f"wrote {os.path.relpath(path, ROOT)}")
    if check:
        print("drydock_migrate --check:", "DRIFT" if drift else "OK",
              f"({drift} files)" if drift else "(data/base matches extraction)")
        sys.exit(1 if drift else 0)
    print(f"drydock_migrate: {drift} files (re)written")


if __name__ == "__main__":
    main()
