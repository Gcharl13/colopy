#!/usr/bin/env python3
"""verify_rules.py -- oracle: the sim's default RuleData is value-identical to the
extracted data tables.

The RuleData seam (viceroy_cpp/sim/rules.{hpp,cpp}) lets the headless sim read its
balance numbers from data instead of hard-coded literals. This check proves the
seam is honest: the C++ default table (kDefaultUnits in rules.cpp) reproduces the
@UNIT rows in data_extracted/tables/names_tables.json for the balance columns, so
the data file is the true source of truth.

Mapping (verified):
    UnitStats.attack  <- @UNIT.attack
    UnitStats.defense <- @UNIT.combat
    UnitStats.cargo   <- @UNIT.cargo
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

# A kDefaultUnits row:  {"Name ...", attack, defense, cargo, move_class},
ROW_RE = re.compile(r'\{\s*"((?:[^"\\]|\\.)*)"\s*,\s*'
                    r'(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*\}')


def parse_cpp_units(path):
    """Extract the kDefaultUnits[] initializer rows -> list of (name,atk,def,cargo,mv)."""
    with open(path, encoding="utf-8") as f:
        text = f.read()
    m = re.search(r'kDefaultUnits\[NUNITTYPES\]\s*=\s*\{(.*?)\n\};', text, re.S)
    if not m:
        sys.exit("verify_rules: could not find kDefaultUnits[] in %s" % path)
    body = m.group(1)
    rows = []
    for r in ROW_RE.finditer(body):
        name, atk, dfn, cargo, mv = r.groups()
        rows.append((name, int(atk), int(dfn), int(cargo), int(mv)))
    return rows


def main():
    units = json.load(open(TABLES, encoding="utf-8"))["@UNIT"]["rows"]
    cpp = parse_cpp_units(RULES_CPP)

    # The JSON ships 23 rows (0..22); the C++ table pads a 24th unused/zeroed row.
    if len(cpp) < len(units):
        sys.exit("verify_rules: C++ has %d rows, JSON has %d" % (len(cpp), len(units)))

    mism = []
    for i, row in enumerate(units):
        j_atk, j_def, j_cargo = int(row["attack"]), int(row["combat"]), int(row["cargo"])
        _, c_atk, c_def, c_cargo, _ = cpp[i]
        if (c_atk, c_def, c_cargo) != (j_atk, j_def, j_cargo):
            mism.append("  row %2d %-17s  JSON(a%d d%d c%d) != C++(a%d d%d c%d)" % (
                i, row["name"], j_atk, j_def, j_cargo, c_atk, c_def, c_cargo))

    # The padded C++ rows beyond the JSON (the unused 23rd unit) must be zeroed.
    for i in range(len(units), len(cpp)):
        _, c_atk, c_def, c_cargo, _ = cpp[i]
        if (c_atk, c_def, c_cargo) != (0, 0, 0):
            mism.append("  row %2d (padding) expected zeros, got (a%d d%d c%d)" % (
                i, c_atk, c_def, c_cargo))

    if mism:
        print("PARITY FAIL: @UNIT vs default RuleData")
        print("\n".join(mism))
        return 1
    print("PARITY OK: default RuleData == @UNIT for attack/defense(combat)/cargo "
          "across %d rows (+%d zeroed padding)" % (len(units), len(cpp) - len(units)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
