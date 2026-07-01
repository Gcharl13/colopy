#!/usr/bin/env python3
"""verify_rules.py -- oracle: the sim's default RuleData is value-identical to the
extracted data tables.

The RuleData seam (viceroy_cpp/sim/rules.{hpp,cpp}) lets the headless sim read its
balance numbers from data instead of hard-coded literals. This check proves the
seam is honest: the C++ default table (kDefaultUnits in rules.cpp) reproduces the
@UNIT rows in data_extracted/tables/names_tables.json for the balance columns, so
the data file is the true source of truth.

Mapping (verified):
    UnitStats.attack   <- @UNIT.attack
    UnitStats.defense  <- @UNIT.combat
    UnitStats.cargo    <- @UNIT.cargo
    UnitStats.movement <- @UNIT.movement
Code-side (NOT in @UNIT, intentionally not compared):
    UnitStats.name        -- display string (@UNIT has abbreviations)
    UnitStats.move_class  -- structural class (1 land / 99 naval / 6 treasure / 0 native)

Usage: python3 tools/verify_rules.py   (exit 0 = PARITY OK)
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TABLES = os.path.join(ROOT, "data_extracted", "tables", "names_tables.json")
RULES_CPP = os.path.join(ROOT, "viceroy_cpp", "sim", "rules.cpp")

# A kDefaultUnits row:  {"Name ...", attack, defense, cargo, move_class, movement},
ROW_RE = re.compile(r'\{\s*"((?:[^"\\]|\\.)*)"\s*,\s*'
                    r'(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*\}')


def parse_cpp_units(path):
    """Extract kDefaultUnits[] rows -> list of (name,atk,def,cargo,move_class,movement)."""
    with open(path, encoding="utf-8") as f:
        text = f.read()
    m = re.search(r'kDefaultUnits\[NUNITTYPES\]\s*=\s*\{(.*?)\n\};', text, re.S)
    if not m:
        sys.exit("verify_rules: could not find kDefaultUnits[] in %s" % path)
    body = m.group(1)
    rows = []
    for r in ROW_RE.finditer(body):
        name, atk, dfn, cargo, mclass, mv = r.groups()
        rows.append((name, int(atk), int(dfn), int(cargo), int(mclass), int(mv)))
    return rows


# A kDefaultCargo row: {start1, start2, lo, hi, burden},   // Name
CARGO_ROW_RE = re.compile(r'\{\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*\}\s*,?\s*//\s*(.+)')


def parse_cpp_cargo(path):
    """Extract kDefaultCargo[] rows -> list of (start1,start2,lo,hi,burden,name)."""
    with open(path, encoding="utf-8") as f:
        text = f.read()
    m = re.search(r'kDefaultCargo\[NGOODS\]\s*=\s*\{(.*?)\n\};', text, re.S)
    if not m:
        sys.exit("verify_rules: could not find kDefaultCargo[] in %s" % path)
    rows = []
    for r in CARGO_ROW_RE.finditer(m.group(1)):
        s1, s2, lo, hi, bd, name = r.groups()
        rows.append((int(s1), int(s2), int(lo), int(hi), int(bd), name.strip()))
    return rows


def check_cargo(names, mism):
    """@CARGO parity: the C++ kDefaultCargo market columns == the extracted table."""
    cargo = names["@CARGO"]["rows"][:16]          # rows 16+ are the Hammers/Crosses placeholders
    cpp = parse_cpp_cargo(RULES_CPP)
    if len(cpp) != len(cargo):
        mism.append("  @CARGO: C++ has %d rows, JSON has %d" % (len(cpp), len(cargo)))
        return
    for i, row in enumerate(cargo):
        j = (int(row["price_start1"]), int(row["price_start2"]),
             int(row["drift_low"]), int(row["drift_high"]), int(row["burden"]))
        c = cpp[i][:5]
        if c != j:
            mism.append("  @CARGO row %2d %-12s JSON%s != C++%s" % (i, row["name"], j, c))


def main():
    names = json.load(open(TABLES, encoding="utf-8"))
    units = names["@UNIT"]["rows"]
    cpp = parse_cpp_units(RULES_CPP)

    # The JSON ships 23 rows (0..22); the C++ table pads a 24th unused/zeroed row.
    if len(cpp) < len(units):
        sys.exit("verify_rules: C++ has %d rows, JSON has %d" % (len(cpp), len(units)))

    mism = []
    for i, row in enumerate(units):
        j = (int(row["attack"]), int(row["combat"]), int(row["cargo"]), int(row["movement"]))
        _, c_atk, c_def, c_cargo, _mclass, c_mv = cpp[i]
        c = (c_atk, c_def, c_cargo, c_mv)
        if c != j:
            mism.append("  row %2d %-17s  JSON(a%d d%d c%d mv%d) != C++(a%d d%d c%d mv%d)" % (
                i, row["name"], j[0], j[1], j[2], j[3], c[0], c[1], c[2], c[3]))

    # The padded C++ rows beyond the JSON (the unused 23rd unit) must be zeroed.
    for i in range(len(units), len(cpp)):
        _, c_atk, c_def, c_cargo, _mclass, c_mv = cpp[i]
        if (c_atk, c_def, c_cargo, c_mv) != (0, 0, 0, 0):
            mism.append("  row %2d (padding) expected zeros, got (a%d d%d c%d mv%d)" % (
                i, c_atk, c_def, c_cargo, c_mv))

    check_cargo(names, mism)

    if mism:
        print("PARITY FAIL: @UNIT/@CARGO vs default RuleData")
        print("\n".join(mism))
        return 1
    print("PARITY OK: default RuleData == @UNIT for attack/defense(combat)/cargo/movement "
          "across %d rows (+%d zeroed padding); == @CARGO for start1/start2/lo/hi/burden "
          "across 16 goods" % (len(units), len(cpp) - len(units)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
