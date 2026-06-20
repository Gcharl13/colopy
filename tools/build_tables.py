#!/usr/bin/env python3
"""build_tables.py -- byte-grounded gameplay tables from the .TXT basis.

The NAMES.TXT / TRIBE.TXT sections ARE the game's data tables, and the file's
own `;` legend comments document the columns. This emits clean, typed tables to
data_extracted/tables/*.json covering EVERY section (CSV rows AND id->name
lists):

  values      = verbatim from the game data file (primary; BYTE-EXACT)
  column names= from the file's own legend (primary, MicroProse-documented)
  byte_anchors= cross-refs to the EXE loader/use-site offsets where verified
  provenance  = how each table is grounded
  kind        = "csv" (named/raw columns) | "list" (row index = runtime id)

Run extract_txt_sections.py first (produces *.full.json).
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEXT = ROOT / "data_extracted" / "text"
OUT = ROOT / "data_extracted" / "tables"

# section -> {columns (from file legend, or None to keep raw), byte_anchors+tier}
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
    "@OTHER": {
        "columns": ["name", "movement", "defensive", "improvement", "value",
                     "y_farmer", "y_planter_sugar", "y_planter_tobacco",
                     "y_planter_cotton", "y_trapper", "y_lumberjack",
                     "y_ore", "y_silver", "y_fisherman"],
        "byte_anchors": "other/misc terrain (Arctic/Ocean/Sea Lane/Mountains...); "
                          "Sea Lane = base id 26 (hard rule 2); func_006204 [B]",
    },
    "@RESOURCE": {
        "columns": ["name", "value"],
        "byte_anchors": "special-resource squares; legend 'Special resource squares & values' [B legend]",
    },
    "@COUNTRY": {
        "columns": ["name", "color"],
        "byte_anchors": "EU powers idx 0..3 = PowerRecord index (DGROUP:0x8808 stride 316) [B]; "
                          "legend 'color => must be 9-15' [B legend]",
    },
    "@LEADERNAME": {
        "columns": ["name", "aggressive_friendly", "expansionist_perfectionist",
                     "civilize_militaristic"],
        "byte_anchors": "AIPersonality leader_name DGROUP:0x540E+0x00 (4 EU powers) [B]; "
                          "legend a/b/c personality axes [B legend]",
    },
    "@CLASS": {
        "columns": ["name", "transport_cost"],
        "byte_anchors": "European classes; legend 'Name, transportation costs' [B legend]; "
                          "@CLASS DGROUP:0x9602 stride 4 loaded @0x074CB0 (RESIDUAL §) [B]",
    },
    "@SCENARIO": {
        "columns": ["map_file", "start", "end", "x0", "y0", "x1", "y1",
                     "x2", "y2", "x3", "y3"],
        "byte_anchors": "scenario bounds; legend 'map file, start, end, x0..y3' [B legend]",
    },
    "@UNIT": {
        "columns": ["name", "icon", "movement", "attack", "combat", "cargo",
                     "size", "cost", "tools", "guns", "hull", "ai_role_bits"],
        "byte_anchors": ("loader @0x74EC3 maps cols -> runtime stat tables: "
                          "attack->0x5236, combat/DEFENSE->0x5235 (LAND, accessor x8), "
                          "guns->0x523B, ->0x523C (ship). ai_role_bits = AI Role binary "
                          "(Invade/Settle/Explore/Attack/Defend/Escort/Transp/Naval). "
                          "[B, RULINGS wave-10]"),
    },
    "@BUILDING": {
        "columns": ["name", "cost", "tools_x10", "size", "min_colony", "upkeep"],
        "byte_anchors": "loader func_074D18 (5-field parse 0x074D18..0x074D3C, lcall 0x1A1F:0x88A x5) [B]; cols per legend",
    },
    "@CARGO": {
        "columns": ["name", "price_start1", "price_start2", "drift_low",
                     "drift_high", "burden", "rise", "fall", "attrition", "volatility"],
        "byte_anchors": ("loader func_074DEC (9-field parse @0x074E05, lcall 0x1A1F:0x88A x9) -> "
                          "DGROUP 0x96FC stride 9 [B]; per-turn drift func_0305A8 [B]; "
                          "goods index = PowerRecord market arrays order [B]"),
    },
    "@JOB": {
        "columns": ["name", "expert_name", "school_tier", "europe_value"],
        "byte_anchors": "expertise = UnitRecord +0x17 (vet/profession 0x13..0x1C) [B]; "
                          "school_tier = min teaching building (1=Schoolhouse/2=College/3=University/4=base) [B, manual chart]; "
                          "europe_value -1 = n/a",
    },
    "@FATHERS": {
        "columns": ["name", "type", "weight_1500_1600", "weight_1600_1700", "weight_1700plus"],
        "byte_anchors": "Congress acquisition weights by era; PowerRecord +0x07 acquired bitmask [B]; selection func_03BFD2 [B]",
    },
    "@LEVELS": {
        "columns": ["tech_name", "settlement_singular", "settlement_plural"],
        "byte_anchors": "native settlement size tiers (Camp/Village/City/...); indexed by @TRIBES level col [B]",
    },
    "@TRIBES": {
        "columns": ["name", "singular", "treasure", "level", "value"],
        "byte_anchors": "native tribes; order = PowerRecord idx 4..11 [B]; "
                          "level col = @LEVELS settlement-tier idx (Inca/Aztec 3/2 -> City, nomads 0 -> Camp) [B]; "
                          "value col = capital-raze treasure base (Aztec=149, Inca=97) DATA_MODEL [B]; "
                          "rows 9-26 = name-only extra tribe pool",
    },
    "@ORDERS": {
        "columns": ["name", "key"],
        "byte_anchors": "unit order index; key = 1-char status letter (-/S/T/G/L/F/B/P/R); rows 10-12 reserved (No Orders) [B]",
    },
    "@COLORS": {
        "columns": ["basic", "hilite", "grey", "enhance", "shadow", "select",
                     "border0", "border1", "border2"],
        "byte_anchors": "text palette indices; legend names all 9 cols [B legend]",
    },
}

# Sections kept as raw rows (CSV detected but columns not confidently named).
RAW_OK = {"@SEASONS"}  # placeholder; everything else is mapped or list


def clean_cell(c: str) -> str:
    # strip inline "; comment" the game sometimes appends to the last cell
    return re.split(r"\s*;", c, 1)[0].strip()


def split_row(line: str) -> "list[str]":
    return [clean_cell(c) for c in line.split(",")]


def build_table(key: str, sec: dict) -> dict:
    """Build one typed table from a section. Always returns a table:
    kind 'csv' when the body is comma-structured, else 'list' (id -> name)."""
    spec = COLMAP.get(key, {})
    legend = sec.get("legend", [])
    byte_anchors = spec.get("byte_anchors", "TBD")
    nonblank = [l for l in sec.get("body", "").split("\n") if l.strip()]

    # CSV when the parser already split rows, or every line carries a comma and
    # we have named columns for it (covers single-line tables like @COLORS).
    has_rows = "rows" in sec
    comma_lines = [l for l in nonblank if "," in l]
    is_csv = has_rows or (spec.get("columns") and comma_lines and len(comma_lines) == len(nonblank))

    if is_csv:
        raw_rows = sec["rows"] if has_rows else [split_row(l) for l in nonblank]
        rows = [[clean_cell(c) for c in r] for r in raw_rows]
        cols = spec.get("columns")
        # Name the columns as long as NO row is LONGER than the column list
        # (zip+pad is then lossless). Short rows -- e.g. @CARGO's trailing
        # name-only goods, @TRIBES' extra tribe names -- are padded with "".
        # Only when a row would overflow the named columns do we keep raw rows.
        if cols and rows and all(len(r) <= len(cols) for r in rows):
            body = [dict(zip(cols, r + [""] * (len(cols) - len(r)))) for r in rows]
            columns = cols
        else:
            body = rows               # keep raw; a row overflows the named columns
            columns = cols            # may be None or "best effort"
        return {
            "kind": "csv",
            "source": sec.get("_src"),
            "legend": legend,
            "columns": columns,
            "columns_named": bool(cols) and isinstance(body[0], dict) if body else False,
            "byte_anchors": byte_anchors,
            "provenance": "values verbatim from game data file (primary); columns from file legend",
            "row_count": len(rows),
            "rows": body,
        }

    # list section: row index IS the runtime id (per CLAUDE.md hard rule)
    return {
        "kind": "list",
        "source": sec.get("_src"),
        "legend": legend,
        "columns": ["id", "name"],
        "columns_named": True,
        "byte_anchors": byte_anchors if byte_anchors != "TBD"
                         else "row index = runtime id [B per CLAUDE.md hard rule]",
        "provenance": "names verbatim from game data file; index = position (runtime id)",
        "row_count": len(nonblank),
        "rows": [{"id": str(i), "name": v} for i, v in enumerate(nonblank)],
    }


def build_from(full_path: Path, want: "set[str] | None") -> dict:
    data = json.load(open(full_path, encoding="utf-8"))
    src = data["file"]
    tables = {}
    for key, sec in data["sections"].items():
        if want is not None and key not in want:
            continue
        sec = dict(sec)
        sec["_src"] = src
        tables[key] = build_table(key, sec)
    return tables


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)

    # NAMES: emit ALL sections (every CSV + every id->name list).
    names = build_from(TEXT / "NAMES.full.json", None)
    (OUT / "names_tables.json").write_text(
        json.dumps(names, indent=2, ensure_ascii=False), encoding="utf-8")
    csv_n = sum(1 for t in names.values() if t["kind"] == "csv")
    print(f"[tables] names_tables.json  {len(names)} tables ({csv_n} csv, {len(names)-csv_n} list)")

    # TRIBE: dispersal coordinate tables (map_x, map_y) per tribe.
    tribe_full = TEXT / "TRIBE.full.json"
    if tribe_full.is_file():
        COLMAP.update({k: {"columns": ["map_x", "map_y"],
                            "byte_anchors": "tribe dispersal template; loaded by func_0749E0; "
                                            "matched to NativeSettlement (DGROUP:0x54EC) at init [B]"}
                       for k in json.load(open(tribe_full))["sections"]})
        tribe = build_from(tribe_full, None)
        (OUT / "tribe_tables.json").write_text(
            json.dumps(tribe, indent=2, ensure_ascii=False), encoding="utf-8")
        print(f"[tables] tribe_tables.json  {len(tribe)} tables")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
