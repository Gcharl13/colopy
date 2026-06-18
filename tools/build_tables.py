#!/usr/bin/env python3
"""build_tables.py -- byte-grounded gameplay tables from the .TXT basis.

The NAMES.TXT / TRIBE.TXT CSV sections ARE the game's data tables, and the file's
own `;` legend comments document the columns. This emits clean, named tables to
data_extracted/tables/*.json:

  values      = verbatim from the game data file (primary; BYTE-EXACT)
  column names= from the file's own legend (primary, MicroProse-documented)
  byte_anchors= cross-refs to the EXE loader/use-site offsets where verified
  provenance  = how each table is grounded

Run extract_txt_sections.py first (produces *.full.json).
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEXT = ROOT / "data_extracted" / "text"
OUT = ROOT / "data_extracted" / "tables"

# section -> (named columns, byte_anchor note + tier, provenance)
COLMAP: dict[str, dict] = {
    "@UNFORESTED": {
        "columns": ["name", "movement", "defensive", "improvement", "value",
                     "y_farmer", "y_planter_sugar", "y_planter_tobacco",
                     "y_planter_cotton", "y_trapper", "y_lumberjack",
                     "y_ore", "y_silver", "y_fisherman"],
        "byte_anchors": "terrain ids 0..; auto-forest range 8..23 via func_006204 (file 0x6204) [B]",
    },
    "@FORESTED": {
        "columns": ["name", "movement", "defensive", "improvement", "value",
                     "y_farmer", "y_planter_sugar", "y_planter_tobacco",
                     "y_planter_cotton", "y_trapper", "y_lumberjack",
                     "y_ore", "y_silver", "y_fisherman"],
        "byte_anchors": "forested variants of @UNFORESTED; func_006204 [B]",
    },
    "@UNIT": {
        "columns": ["name", "icon", "movement", "attack", "combat", "cargo",
                     "size", "cost", "tools", "guns", "hull", "role", "ai_role_bits"],
        "byte_anchors": ("loader @0x74EC3 maps cols -> runtime stat tables: "
                          "attack->0x5236, combat/DEFENSE->0x5235 (LAND, accessor x8), "
                          "guns->0x523B, ->0x523C (ship). [B, RULINGS wave-10]"),
    },
    "@BUILDING": {
        "columns": ["name", "cost", "tools_x10", "size", "min_colony", "upkeep"],
        "byte_anchors": "consumed by colony build/production; loader TBD",
    },
    "@CARGO": {
        "columns": ["name", "price_start1", "price_start2", "drift_low",
                     "drift_high", "burden", "rise", "fall", "attrition", "volatility"],
        "byte_anchors": ("market price model inputs; per-turn drift fn behind "
                          "overlay thunk 0x181F:0x9A4 [TBD]; values are primary [B]"),
    },
    "@JOB": {
        "columns": ["name", "expert_name", "student_level", "europe_cost"],
        "byte_anchors": "profession; UnitRecord +0x15 = class/profession [B]; europe_cost -1 = not purchasable",
    },
    "@FATHERS": {
        "columns": ["name", "type", "weight_1500_1600", "weight_1600_1700", "weight_1700plus"],
        "byte_anchors": "Congress acquisition weights by era; selection fn TBD",
    },
    "@LEVELS": {
        "columns": ["tech_name", "settlement_singular", "settlement_plural"],
        "byte_anchors": "native settlement size tiers (Camp/Village/City/...)",
    },
    "@CLASS": {"columns": None, "byte_anchors": "colonist classes; @UNIT/@JOB cross-ref"},
    "@ORDERS": {"columns": None, "byte_anchors": "unit order list + key letters [B present]"},
}


def clean_cell(c: str) -> str:
    # strip inline "; comment" the game sometimes appends to the last cell
    return re.split(r"\s*;", c, 1)[0].strip()


def build_from(full_path: Path, want: "set[str] | None") -> dict:
    data = json.load(open(full_path, encoding="utf-8"))
    src = data["file"]
    tables = {}
    for key, sec in data["sections"].items():
        if "rows" not in sec:
            continue
        if want is not None and key not in want:
            continue
        rows = [[clean_cell(c) for c in r] for r in sec["rows"]]
        spec = COLMAP.get(key, {})
        cols = spec.get("columns")
        if cols and all(len(r) >= len(cols) for r in rows):
            named = [dict(zip(cols, r)) for r in rows]
        else:
            named = None  # keep raw rows; columns not confidently named
        tables[key] = {
            "source": src,
            "legend": sec.get("legend", []),
            "columns": cols,
            "byte_anchors": spec.get("byte_anchors", "TBD"),
            "provenance": "values verbatim from game data file (primary); columns from file legend",
            "row_count": len(rows),
            "rows": named if named is not None else rows,
        }
    return tables


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    names = build_from(TEXT / "NAMES.full.json", set(COLMAP) | {"@OTHER", "@RESOURCE",
              "@OTHER_NAMES", "@COUNTRY", "@NATIONALITY", "@DIFFICULTY", "@SCENARIO",
              "@HOMEPORT", "@MISSION", "@ATTITUDE", "@SEASONS", "@TRIBES", "@FOUNDING", "@VALUES", "@COLORS"})
    (OUT / "names_tables.json").write_text(json.dumps(names, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"[tables] names_tables.json  {len(names)} tables")

    tribe_full = TEXT / "TRIBE.full.json"
    if tribe_full.is_file():
        tribe = build_from(tribe_full, None)
        (OUT / "tribe_tables.json").write_text(json.dumps(tribe, indent=2, ensure_ascii=False), encoding="utf-8")
        print(f"[tables] tribe_tables.json  {len(tribe)} tables")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
