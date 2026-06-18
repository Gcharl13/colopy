#!/usr/bin/env python3
"""extract_dgroup_tables.py -- structured DGROUP data-segment layout catalog.

Attempt to surface the game's "binary" data tables -- the DGROUP (data-segment)
record types and scalar globals.

FINDING (2026-06-18, byte-checked): the DGROUP record tables referenced
throughout the notes (PowerRecord, UnitRecord, ColonyRecord, NativeSettlement,
TribeData, AIPersonality, REF counts, ...) are **runtime / BSS** structures --
uninitialised in VICEROY.EXE and filled at game-init by loading NAMES.TXT or
restored from a save. Their *values* were byte-verified against DOSBox memory
dumps, NOT against static EXE bytes. Probing raw/COLONIZE/VICEROY.EXE confirms:

  * The DS file-base the notes use (the "recol" image / dump offset 0x1CFE0)
    does not reproduce against this repo's VICEROY.EXE, and
  * Known arrays (e.g. REF {23,10,5,8}) are NOT present as static initialisers.

So there are no static byte tables to dump for these records. The faithful,
non-fabricating deliverable is the **layout catalog** itself -- which struct
lives at which DGROUP offset, its stride/count, and its field map -- aggregated
from the already byte-verified docs/DATA_MODEL.md. Each row carries its source
heading; byte *values* stay value_source="runtime" (reproduce via memory dump,
not EXE) per the prime directive.

Output: data_extracted/tables/dgroup_tables.json
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "docs" / "DATA_MODEL.md"
OUT = ROOT / "data_extracted" / "tables" / "dgroup_tables.json"

H2_RE = re.compile(r"^##\s+(.*)$")
BASE_RE = re.compile(r"\*\*Base\*\*.*?DGROUP:0x([0-9A-Fa-f]+)")
STRIDE_RE = re.compile(r"\*\*Stride\*\*.*?0x([0-9A-Fa-f]+)\D+?(\d+)?")
COUNT_RE = re.compile(r"\*\*Count\*\*.*?(\d+)")
COUNT_HEAD_RE = re.compile(r"\((\d+)\s+entries|(\d+)\s+max|\((\d+)\b")
OFFSET_CELL_RE = re.compile(r"^[+\-]?(0x[0-9A-Fa-f]+|\d+)")


def split_row(line: str) -> "list[str]":
    cells = line.strip().strip("|").split("|")
    return [c.strip() for c in cells]


def is_sep(line: str) -> bool:
    return bool(re.match(r"^\|[\s:|-]+\|?\s*$", line.strip()))


def parse() -> dict:
    lines = SRC.read_text(encoding="utf-8").split("\n")
    records: list[dict] = []
    scalars: list[dict] = []

    rec_by_heading: dict[str, dict] = {}
    cur_name = None
    cur_base = None
    cur_stride_hex = cur_stride_dec = None
    cur_count = None

    i = 0
    n = len(lines)
    while i < n:
        line = lines[i]
        m = H2_RE.match(line)
        if m:
            cur_name = m.group(1).strip()
            cur_base = cur_stride_hex = cur_stride_dec = cur_count = None
            ch = COUNT_HEAD_RE.search(cur_name)
            if ch:
                cur_count = next(g for g in ch.groups() if g)
            i += 1
            continue
        if BASE_RE.search(line):
            cur_base = BASE_RE.search(line).group(1).upper()
        sm = STRIDE_RE.search(line)
        if sm and "Stride" in line:
            cur_stride_hex = sm.group(1).upper()
            cur_stride_dec = sm.group(2)
        if "**Count**" in line:
            cm = COUNT_RE.search(line)
            if cm:
                cur_count = cm.group(1)

        # markdown table?
        if line.strip().startswith("|") and i + 1 < n and is_sep(lines[i + 1]):
            header = split_row(line)
            rows = []
            j = i + 2
            while j < n and lines[j].strip().startswith("|"):
                rows.append(split_row(lines[j]))
                j += 1
            i = j
            h0 = header[0].lower()
            if h0 == "offset":
                # field-layout table for the current record
                fields = [dict(zip(header, r)) for r in rows
                          if r and OFFSET_CELL_RE.match(r[0])]
                if fields:
                    rec = rec_by_heading.get(cur_name)
                    if rec is None:
                        rec = {
                            "record": cur_name,
                            "dgroup_base": f"0x{cur_base}" if cur_base else None,
                            "stride_hex": f"0x{cur_stride_hex}" if cur_stride_hex else None,
                            "stride_dec": cur_stride_dec,
                            "count": cur_count,
                            "value_source": "runtime (BSS; loaded from NAMES.TXT/save) -- "
                                            "verified vs DOSBox memory dump, not static EXE bytes",
                            "source": f"docs/DATA_MODEL.md :: {cur_name}",
                            "header": header,
                            "fields": [],
                        }
                        rec_by_heading[cur_name] = rec
                        records.append(rec)
                    # fill base/stride/count if a later mention supplied them
                    if rec["dgroup_base"] is None and cur_base:
                        rec["dgroup_base"] = f"0x{cur_base}"
                    rec["fields"].extend(fields)
            elif h0 in ("address", "global"):
                # scalar-globals table
                for r in rows:
                    if not r or not r[0]:
                        continue
                    scalars.append({
                        "address": r[0],
                        "row": dict(zip(header, r)),
                        "group": cur_name,
                        "source": f"docs/DATA_MODEL.md :: {cur_name}",
                    })
            continue
        i += 1

    return {"records": records, "scalars": scalars}


def main() -> int:
    if not SRC.is_file():
        print(f"WARN missing {SRC}")
        return 1
    data = parse()
    note = (
        "DGROUP record VALUES are runtime/BSS (loaded from NAMES.TXT or save, "
        "verified vs DOSBox memory dumps) -- they are NOT static initialisers in "
        "raw/COLONIZE/VICEROY.EXE, so static byte extraction is N/A. This catalog "
        "is the byte-verified LAYOUT (offset/stride/count/field-map) aggregated "
        "from docs/DATA_MODEL.md. Reproduce values via tools/analyze_session_mem.py "
        "against a memory dump."
    )
    out = {
        "_note": note,
        "source": "docs/DATA_MODEL.md",
        "record_count": len(data["records"]),
        "scalar_count": len(data["scalars"]),
        "records": data["records"],
        "scalars": data["scalars"],
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(out, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"[dgroup] {OUT.name}  {len(data['records'])} record layouts, "
          f"{len(data['scalars'])} scalar globals")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
