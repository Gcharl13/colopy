#!/usr/bin/env python3
"""Bundle the port into one self-contained HTML file.

Pulls the decoded game data straight from data_extracted/ (the byte-verified
JSON) and the PNGs from port/assets/, inlines everything as data URIs, and
writes port/dist/colonization.html.
"""
import base64
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ASSETS = ROOT / "port" / "assets"
SRC = ROOT / "port" / "src"
DIST = ROOT / "port" / "dist"


def uri(p: Path) -> str:
    return "data:image/png;base64," + base64.b64encode(p.read_bytes()).decode()


def build_data():
    D = {}
    pal = json.load(open(ROOT / "data_extracted/palette.json"))
    D["palette"] = [[e["r"], e["g"], e["b"]] for e in pal]

    nt = json.load(open(ROOT / "data_extracted/tables/names_tables.json"))
    rows = lambda k: nt[k]["rows"]
    D["difficulty"] = [r["name"] for r in rows("@DIFFICULTY")]
    D["seasons"] = [r["name"] for r in rows("@SEASONS")]
    D["terrain"] = {
        "unforested": [r["name"] for r in rows("@UNFORESTED")],
        "forested": [r["name"] for r in rows("@FORESTED")],
        "other": [r["name"] for r in rows("@OTHER")],
        "othernames": [r["name"] for r in rows("@OTHER_NAMES")],
    }
    country = rows("@COUNTRY")
    leaders = rows("@LEADERNAME")
    ports = rows("@HOMEPORT")
    nat = rows("@NATIONALITY")
    D["nations"] = [{
        "country": country[i]["name"],
        "color": int(country[i]["color"]),
        "leader": leaders[i]["name"],
        "homeport": ports[i]["name"],
        "adjective": nat[i]["name"],
        "abbrev": rows("@NATIONABBREV")[i]["name"],
    } for i in range(4)]

    # @ORDERS: order name + the status letter shown on the unit's nation plate.
    D["orders"] = [{"name": r["name"], "key": r["key"]} for r in rows("@ORDERS")]

    # @UNIT: 23 rows of stats. Keep the numeric columns numeric for the port.
    D["units"] = [{
        "name": r["name"],
        **{c: int(r[c]) for c in ("icon", "movement", "attack", "combat",
                                  "cargo", "size", "cost", "hull")},
    } for r in rows("@UNIT")]

    # Popup templates, verbatim from GAME.TXT with their @directives (the box
    # builder needs @width; @default is the highlighted row, or the pre-filled
    # text for an entry field). Body and tail are split on the blank line the
    # parser treats as a paragraph break.
    full = json.load(open(ROOT / "data_extracted/text/GAME.full.json"))["sections"]
    D["dialogs"] = {}
    for key in ("@LANDHO", "@LANDFALL", "@COLONY", "@RECRUIT", "@PURCHASE"):
        sec = full[key]
        para = sec["body"].split("\n\n")
        D["dialogs"][key.lstrip("@")] = {
            "body": para[0].split("\n"),
            "tail": para[1].split("\n") if len(para) > 1 else [],
            "width": int(sec["directives"].get("width", 0x50)),
            # No @default at all means a plain entry field with no prefill --
            # do NOT substitute "0", which would read as an option index.
            "default": sec["directives"].get("default"),
        }

    # Woodcut captions: the single @WOODCUT section, one caption per line, index
    # = woodcut number (1 = DISCOVERY OF THE NEW WORLD, the first-landfall plate).
    wc = json.load(open(ROOT / "data_extracted/text/WOODCUT_sections.json"))
    D["woodcuts"] = wc["@WOODCUT"].split("\n")

    # Colony names: COLONY.TXT carries one list per nation, "<name>[,<year>]"
    # per line, used in order as colonies are founded.
    col = json.load(open(ROOT / "data_extracted/text/COLONY_sections.json"))
    D["colonynames"] = [[ln.split(",")[0] for ln in col[k].split("\n") if ln.strip()]
                        for k in ("@ENGLISH", "@FRENCH", "@SPANISH", "@DUTCH")]

    # @CARGO in table order -- the 16 tradeable goods drive both the colony
    # stockpile bar and the Europe market bar; bid/ask come from the record.
    # @CARGO drives the whole market: the start window, the price floor/ceiling
    # the stepping respects, the visible bid/ask spread (burden+1), the
    # traffic-accumulator thresholds +-100*(rise|fall), the per-turn attrition
    # drift, and the volatility left-shift on traded quantity (§9.2).
    D["cargo"] = [{"name": r["name"],
                   "start1": int(r["price_start1"] or 0),
                   "start2": int(r["price_start2"] or 0),
                   "low": int(r["drift_low"] or 0),
                   "high": int(r["drift_high"] or 0),
                   "burden": int(r["burden"] or 0),
                   "rise": int(r["rise"] or 0),
                   "fall": int(r["fall"] or 0),
                   "attrition": int(r["attrition"] or 0),
                   "volatility": int(r["volatility"] or 0)}
                  for r in rows("@CARGO")[:16]]
    # Recruit passage prices per colonist class, and training prices per job
    # (europe_value -1 = not trainable in Europe).
    D["classes"] = [{"name": r["name"], "cost": int(r["transport_cost"])}
                    for r in rows("@CLASS")]
    D["jobtrain"] = [{"name": r["name"], "expert": r["expert_name"],
                      "cost": int(r["europe_value"])}
                     for r in rows("@JOB") if r["europe_value"] != "-1"]
    # @BUILDING carries upkeep in the last column. Upkeep 0 marks the free base
    # tier every colony has from the start; the only zero-upkeep row gated above
    # a size-1 colony is the Stockade (min_colony 3), so "upkeep 0 AND
    # min_colony 1" selects the seven starting buildings exactly.
    D["buildings"] = [{"name": r["name"], "cost": int(r["cost"]),
                       "min_colony": int(r["min_colony"]), "upkeep": int(r["upkeep"]),
                       "tools_x10": int(r["tools_x10"])}
                      for r in rows("@BUILDING")]

    # Per-terrain job yields, used for colony production. Row order is the
    # runtime terrain id within each band.
    YIELDS = ["y_farmer", "y_planter_sugar", "y_planter_tobacco", "y_planter_cotton",
              "y_trapper", "y_lumberjack", "y_ore", "y_silver", "y_fisherman"]
    # Terrain Defensive column (§5.6 / §14.2): open land 0, marsh 1, forests 2,
    # hills 4, mountains 6 -- the +25%-per-point defender bonus.
    D["defensive"] = {k.lstrip("@").lower(): [int(r["defensive"]) for r in rows(k)]
                      for k in ("@UNFORESTED", "@FORESTED", "@OTHER")}
    D["yields"] = {k.lstrip("@").lower():
                   [[int(r[c] or 0) for c in YIELDS] for r in rows(k)]
                   for k in ("@UNFORESTED", "@FORESTED", "@OTHER")}
    D["jobs"] = [r["name"] for r in rows("@JOB")]
    D["regionname"] = [r["name"] for r in rows("@COLONYNAME")]

    game = json.load(open(ROOT / "data_extracted/text/GAME_sections.json"))
    labels = json.load(open(ROOT / "data_extracted/text/LABELS_sections.json"))
    D["eurolabel"] = labels["@EUROLABEL"].split("\n")

    # PEDIA.TXT: @PEDIA lists the seven category names; the rest are entry
    # bodies keyed @<CATEGORY><index>. Comment lines (@;) are already stripped.
    ped = json.load(open(ROOT / "data_extracted/text/PEDIA_sections.json"))
    D["pedia"] = {"categories": [l for l in ped["@PEDIA"].split("\n") if l.strip()],
                  "entries": {k.lstrip("@"): v for k, v in ped.items() if k != "@PEDIA"}}
    # @FATHERS: name, category (0..4 over @FOUNDING), then three ERA WEIGHT
    # bytes -- year <1600 / 1600-1699 / >=1700. A father with weight 0 in the
    # current era cannot be drawn (§17.3).
    fath_raw = [l for l in json.load(
        open(ROOT / "data_extracted/text/NAMES_sections.json"))["@FATHERS"].split("\n")
        if l.strip()]
    D["fathers"] = []
    for line in fath_raw:
        parts = [p.strip() for p in line.split(";")[0].split(",")]
        if len(parts) < 5:
            continue
        D["fathers"].append({"name": parts[0], "category": int(parts[1]),
                             "weights": [int(parts[2]), int(parts[3]), int(parts[4])]})
    D["founding"] = [r["name"] for r in rows("@FOUNDING")]
    # @TRIBES' `value` column is the tribe's MAP COLOUR -- a palette index, the
    # native counterpart of @COUNTRY.color for the European powers. The eight
    # resolve to visually distinct entries (cream, gold, blue, brown, green,
    # tan, dark red, dark green).
    D["tribes"] = [{"name": r["name"], "singular": r["singular"],
                    "level": int(r["level"] or 0), "color": int(r["value"])}
                   for r in rows("@TRIBES") if r["level"] != ""]

    # TRIBE.TXT is the native-settlement coordinate list: one @<TRIBE> section
    # per tribe, "x,y" per line. @STOP is a terminator, not a tribe.
    tribe_txt = json.load(open(ROOT / "data_extracted/text/TRIBE_sections.json"))
    D["tribesites"] = {}
    for key, body in tribe_txt.items():
        if key == "@STOP":
            continue
        pts = []
        for line in body.split("\n"):
            line = line.strip()
            if not line or "," not in line:
                continue
            x, y = line.split(",")[:2]
            pts.append([int(x), int(y)])
        D["tribesites"][key.lstrip("@")] = pts

    # MENU.TXT: one section per pulldown. The first line is the bar title, the
    # rest are rows. "~" marks the accelerator letter -- the menu engine parses
    # it out and matches it against the typed key (§27.1), so the letters are
    # data, not a hardcoded table. "#" marks a row the shipped build greys out.
    menu = json.load(open(ROOT / "data_extracted/text/MENU_sections.json"))

    def parse_row(line):
        raw = line.strip()
        disabled = raw.startswith("#") or "#" in raw.split()[0:1]
        accel = None
        out = []
        i = 0
        while i < len(raw):
            if raw[i] == "~" and i + 1 < len(raw):
                if accel is None and raw[i + 1].isalnum():
                    accel = raw[i + 1].upper()
                out.append(raw[i + 1])
                i += 2
            elif raw[i] == "#":
                i += 1
            else:
                out.append(raw[i])
                i += 1
        return {"label": "".join(out).strip(), "accel": accel, "disabled": disabled}

    D["menus"] = []
    for key in ("@GAME", "@VIEW", "@ORDERS", "@REPORTS", "@TRADE", "@PEDIA"):
        lines = [l for l in menu[key].split("\n") if l.strip()]
        head = parse_row(lines[0])
        D["menus"].append({"title": head["label"], "accel": head["accel"],
                           "rows": [parse_row(l) for l in lines[1:]]})
    D["text"] = {
        "beginmenu": game["@BEGINMENU"].split("\n"),
        "leadername": game["@LEADERNAME"],
        "misc": labels["@MISC"].split("\n"),
    }
    # Per-nation history (A) + gameplay-bonus (B) briefing pages.
    D["briefings"] = [[game.get(f"@NATION{i}A", ""), game.get(f"@NATION{i}B", "")]
                      for i in range(4)]
    # Intro card slideshow text (@BUILD1..10) + the King's audience scroll.
    D["cards"] = [game.get(f"@BUILD{i}", "") for i in range(1, 11)]
    D["viceroy"] = [game.get("@VICEROY", ""), game.get("@VICEROY2", "")]
    D["myleader"] = [r["name"] for r in rows("@MYLEADER")] \
        if "@MYLEADER" in nt else ["King", "King", "King", "Stadtholder"]

    # Starting positions: NAMES @SCENARIO holds 8 ints = 4 (x,y) pairs. The
    # column legend in the data file is stale (there are no year columns).
    sc = rows("@SCENARIO")[0]
    vals = [int(sc[k]) for k in ("start", "end", "x0", "y0", "x1", "y1", "x2", "y2")]
    D["starts"] = [[vals[i * 2], vals[i * 2 + 1]] for i in range(4)]

    mp = json.load(open(ROOT / "data_extracted/map/AMER2_tiles.json"))
    D["map"] = {"w": mp["width"], "h": mp["height"], "tiles": mp["tiles"]}

    man = json.load(open(ASSETS / "manifest.json"))
    D["sheets"] = {k: {"frames": v["frames"]} for k, v in man["sheets"].items()}
    # Each .PIK carries its own palette, which overrides the master VICEROY.PAL
    # placeholders (0xFC-0xFE are magenta there) -- see manual App. B.
    D["palettes"] = {k: v["pal"] for k, v in man["backgrounds"].items()}
    # Sheets that carry a palette the renderer must adopt (woodcut screen).
    for k, v in man["sheets"].items():
        if "pal" in v:
            D["palettes"][k] = v["pal"]
    D["fonts"] = {}
    alias = {"FONTINTR": "intr", "FONTTINY": "tiny", "FONTKING": "king",
             "FONT-NP": "np", "FONTSMAL": "smal"}
    for name, meta in man["fonts"].items():
        D["fonts"][alias[name]] = {
            "h": meta["h"], "y": meta["y"],
            "glyphs": {int(k): v for k, v in meta["glyphs"].items()},
            "widths": {int(k): v for k, v in meta["widths"].items()},
            "file": name,
        }
    return D, man


def main():
    DIST.mkdir(parents=True, exist_ok=True)
    D, man = build_data()

    assets = {}
    for bg in man["backgrounds"]:
        assets[bg] = uri(ASSETS / f"{bg}.png")
    for sh in man["sheets"]:
        assets["SS_" + sh] = uri(ASSETS / f"{sh}.png")
    for f in man["fonts"]:
        for lvl in (1, 2, 3):
            assets[f"FONT_{f}_L{lvl}"] = uri(ASSETS / f"FONT_{f}_L{lvl}.png")

    js = (SRC / "game.js").read_text()
    html = f"""<title>Colonization</title>
<style>
  /* Deliberately single-theme: this is a 320x200 DOS screen in a cabinet
     bezel. Palette is the game's own -- wood browns and the 0xFC gold. */
  :root {{
    --ground:#0B0908; --bezel:#2A1B12; --rule:#6B4A2F;
    --gold:#C7A220; --muted:#8A7A5C;
  }}
  * {{ box-sizing:border-box; }}
  html,body {{ margin:0; height:100%; background:var(--ground); overflow:hidden; }}
  body {{
    display:flex; flex-direction:column; align-items:center;
    justify-content:center; gap:14px; padding:16px;
  }}
  #cabinet {{
    padding:10px; background:var(--bezel);
    border:1px solid var(--rule); border-radius:2px;
    box-shadow:0 0 0 1px #00000080, 0 24px 60px -12px #000;
    line-height:0;
  }}
  #screen {{
    image-rendering:pixelated; image-rendering:crisp-edges;
    touch-action:manipulation; display:block; background:#000;
  }}
  #hint {{
    font:11px/1.4 ui-monospace,"SF Mono",Menlo,Consolas,monospace;
    letter-spacing:.14em; text-transform:uppercase; color:var(--muted);
    text-align:center; max-width:60ch;
  }}
  #hint b {{ color:var(--gold); font-weight:600; }}
  #loading {{
    position:fixed; inset:0; display:flex; align-items:center;
    justify-content:center; color:var(--gold); background:var(--ground);
    font:12px/1 ui-monospace,monospace; letter-spacing:.2em;
    text-transform:uppercase;
  }}
  canvas:focus-visible {{ outline:2px solid var(--gold); outline-offset:6px; }}
  @media (prefers-reduced-motion:reduce) {{ * {{ animation:none !important; }} }}
</style>
<div id="cabinet"><canvas id="screen" tabindex="0"></canvas></div>
<p id="hint"><b>Arrows</b> choose &amp; move &nbsp;·&nbsp; <b>Enter</b> confirm
&nbsp;·&nbsp; <b>Space</b> end turn &nbsp;·&nbsp; or click</p>
<div id="loading">Loading&#8230;</div>
<script>
const ASSETS = {json.dumps(assets)};
const DATA = {json.dumps(D, separators=(',', ':'))};
</script>
<script>
{js}
</script>
"""
    out = DIST / "colonization.html"
    out.write_text(html)
    kb = out.stat().st_size / 1024
    print(f"wrote {out} ({kb:.0f} KB)")


if __name__ == "__main__":
    main()
