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
    ("ffat", "@FATHERS", [
        ("name", "name", "str"), ("type", "type", "int"),
        ("weight_1500_1600", "weight_1500_1600", "int"),
        ("weight_1600_1700", "weight_1600_1700", "int"),
        ("weight_1700plus", "weight_1700plus", "int"),
    ]),
]

# PROF.produces -- ref<good> keyed by @JOB row ordinal. Data-sourced from the
# engine's profession->good mapping, not invented:
#   0-7  tile professions == the terrain yield columns y_farmer..y_silver, whose
#        column index IS the good id (engine.cpp terrain_good_yield YCOL[good]);
#   8    Fisherman -> Food via the y_fisherman ocean-food column (engine.cpp:212);
#   9-15 artisans: the finished good whose throughput cap the worker feeds in
#        colony_compute_production (Rum<-Distiller ... Muskets<-Gunsmith;
#        Carpenter's output is the Hammers pseudo-good, index 16);
#   16/17 Preacher -> Crosses (17), Statesman -> Liberty Bells (18)
#        (colony_compute_production g==17/g==18 branches).
# Non-producing classes (Teacher 18 .. Convert 27) get no produces field.
PROF_PRODUCES = {
    0: "food", 1: "sugar", 2: "tobacco", 3: "cotton", 4: "furs", 5: "lumber",
    6: "ore", 7: "silver", 8: "food",
    9: "rum", 10: "cigars", 11: "cloth", 12: "coats", 13: "hammers",
    14: "tools", 15: "muskets", 16: "crosses", 17: "liberty_bells",
}

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

    # NATN: @COUNTRY merged with the row-parallel @NATIONALITY (same power slot)
    used = set()
    nat = tables["@NATIONALITY"]["rows"]
    for idx, row in enumerate(tables["@COUNTRY"]["rows"]):
        rid = f"natn.{slug(row['name'], used)}"
        fields = [("index", str(idx)), ("name", quote(row["name"]))]
        if idx < len(nat) and str(nat[idx].get("name", "")).strip():
            fields.append(("nationality", quote(nat[idx]["name"])))
        if str(row.get("color", "")).strip():
            fields.append(("color", str(int(row["color"]))))
        drift = emit(os.path.join("natn", rid.split(".", 1)[1] + ".rec"),
                     render(rid, fields), check, drift)

    # MSGE: GAME.TXT message records (messages.json, tools/build_messages.py).
    # "None" defaults stay absent (lossless): box_w 0, x/y -1, empty strings.
    msg = json.load(open(os.path.join(ROOT, "data_extracted/engine/messages.json")))
    used = set()
    for row in msg["messages"]:
        rid = f"msge.{slug(row['key'], used)}"
        fields = [("key", quote(row["key"])), ("text", quote(row["text"]))]
        if int(row.get("box_w", 0)):
            fields.append(("box_w", str(int(row["box_w"]))))
        for coord in ("x", "y"):
            if int(row.get(coord, -1)) != -1:
                fields.append((coord, str(int(row[coord]))))
        for sf in ("sprite", "speaker", "default"):
            if str(row.get(sf, "")):
                fields.append((sf, quote(str(row[sf]))))
        drift = emit(os.path.join("msge", rid.split(".", 1)[1] + ".rec"),
                     render(rid, fields), check, drift)

    # TEXT: verbatim line-list sections from the <FILE>_sections.json extractions.
    # Only sections consumed AS TEXT migrate; the NAMES CSV tables are typed
    # records already (good/unit/prof/terr/bldg/natn/ffat) -- duplicating them
    # as text would create dual authority.
    TEXT_SECTIONS = [
        ("LABELS", None),                 # all 7 label sections
        ("COLONY", None),                 # the per-nation colony-name pools + @STOP
        ("MENU", None),                   # the pulldown menus
        ("NAMES", {"@SEASONS"}),          # the one NAMES section consumed as text
    ]
    for src_file, only in TEXT_SECTIONS:
        secs = json.load(open(os.path.join(ROOT, f"data_extracted/text/{src_file}_sections.json")))
        for sec in sorted(secs):
            body = secs[sec]
            if not isinstance(body, str) or (only is not None and sec not in only):
                continue
            rid = f"text.{src_file.lower()}_{re.sub(r'[^a-z0-9]+', '_', sec.lower()).strip('_')}"
            fields = [("section", quote(sec)), ("source", quote(src_file)),
                      ("lines", "[" + ", ".join(quote(l) for l in body.split("\n")) + "]")]
            drift = emit(os.path.join("text", rid.split(".", 1)[1] + ".rec"),
                         render(rid, fields), check, drift)

    # DLOG: screen layouts (engine/screens/*.json). Values are int/str/list/dict
    # only (verified); dict keys emit SORTED so a designer save (which round-trips
    # through the C++ sorted-map JSON) is byte-stable against this generator.
    def rec_value(v):
        if isinstance(v, bool):
            return "1" if v else "0"
        if isinstance(v, int):
            return str(v)
        if isinstance(v, str):
            return quote(v)
        if isinstance(v, list):
            return "[" + ", ".join(rec_value(x) for x in v) + "]"
        if isinstance(v, dict):
            if not v:
                return "{}"
            return "{ " + ", ".join(f"{k} = {rec_value(v[k])}" for k in sorted(v)) + " }"
        raise ValueError(f"unrepresentable screen value: {v!r}")
    import glob as _glob
    for f in sorted(_glob.glob(os.path.join(ROOT, "data_extracted/engine/screens/*.json"))):
        scr = json.load(open(f))
        rid = f"dlog.{scr['id']}"
        fields = [("name", quote(scr["name"]))]
        if str(scr.get("background", "")):
            fields.append(("background", quote(scr["background"])))
        fields.append(("size", rec_value(scr["size"])))
        fields.append(("widgets", rec_value(scr["widgets"])))
        drift = emit(os.path.join("dlog", scr["id"] + ".rec"),
                     render(rid, fields), check, drift)

    # SCEN: authored scenarios (engine/scenarios/*.json); _doc carries into notes
    for f in sorted(_glob.glob(os.path.join(ROOT, "data_extracted/engine/scenarios/*.json"))):
        scn = json.load(open(f))
        rid = f"scen.{scn['id']}"
        fields = [("name", quote(scn["name"]))]
        if str(scn.get("map", "")):
            fields.append(("map", quote(scn["map"])))
        for k in ("year", "season", "end_year", "start_gold",
                  "default_nation", "default_difficulty"):
            if k in scn:
                fields.append((k, str(int(scn[k]))))
        for k in ("colonies", "units"):
            if scn.get(k):
                fields.append((k, rec_value(scn[k])))
        if str(scn.get("_doc", "")):
            fields.append(("notes", quote(scn["_doc"])))
        drift = emit(os.path.join("scen", scn["id"] + ".rec"),
                     render(rid, fields), check, drift)

    # SPRT: the sprite catalog (sprites.json). The verbatim catalog id lives in
    # `sid` (record slugs flatten its dot namespace); the one duplicated catalog
    # id (building.town_hall x3 tiers) dedups to _2/_3 slugs.
    spr = json.load(open(os.path.join(ROOT, "data_extracted/engine/sprites.json")))
    used = set()
    for row in spr["sprites"]:
        rid = f"sprt.{slug(row['id'], used)}"
        fields = [("sid", quote(row["id"])), ("label", quote(row["label"])),
                  ("kind", quote(row["kind"]))]
        if str(row.get("sheet", "")):
            fields.append(("sheet", quote(row["sheet"])))
        if "frame" in row:
            fields.append(("frame", str(int(row["frame"]))))
        if str(row.get("file", "")):
            fields.append(("file", quote(row["file"])))
        for dim in ("w", "h"):
            if int(row.get(dim, 0)):
                fields.append((dim, str(int(row[dim]))))
        drift = emit(os.path.join("sprt", rid.split(".", 1)[1] + ".rec"),
                     render(rid, fields), check, drift)

    # PLTT: VICEROY.PAL as one ordered 256-color record (position = index)
    pal = json.load(open(os.path.join(ROOT, "data_extracted/palette.json")))
    fields = [("name", quote("VICEROY.PAL")),
              ("colors", "[" + ", ".join(quote(c["hex"]) for c in pal) + "]")]
    drift = emit(os.path.join("pltt", "viceroy.rec"), render("pltt.viceroy", fields),
                 check, drift)

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
            if type_code == "prof" and idx in PROF_PRODUCES:
                fields.append(("produces", "good." + PROF_PRODUCES[idx]))
            drift = emit(os.path.join(type_code, rid.split(".", 1)[1] + ".rec"),
                         render(rid, fields), check, drift)
    if check:
        print("drydock_migrate --check:", "DRIFT" if drift else "OK",
              f"({drift} files)" if drift else "(data/base matches extraction)")
        sys.exit(1 if drift else 0)
    print(f"drydock_migrate: {drift} files (re)written")


if __name__ == "__main__":
    main()
