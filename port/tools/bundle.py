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
    } for i in range(4)]

    game = json.load(open(ROOT / "data_extracted/text/GAME_sections.json"))
    labels = json.load(open(ROOT / "data_extracted/text/LABELS_sections.json"))
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
  html,body {{ margin:0; height:100%; background:#0b0b0d; overflow:hidden; }}
  #host {{ position:fixed; inset:0; display:flex; align-items:center;
           justify-content:center; }}
  #screen {{ image-rendering:pixelated; image-rendering:crisp-edges;
             touch-action:manipulation; box-shadow:0 0 40px #000; }}
  #loading {{ position:fixed; inset:0; display:flex; align-items:center;
              justify-content:center; color:#c8b98a;
              font:14px ui-monospace,monospace; }}
</style>
<div id="host"><canvas id="screen"></canvas></div>
<div id="loading">loading…</div>
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
