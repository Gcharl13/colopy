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
                                  "cargo", "size", "cost", "tools", "guns",
                                  "hull")},
    } for r in rows("@UNIT")]

    # Popup templates, verbatim from GAME.TXT with their @directives (the box
    # builder needs @width; @default is the highlighted row, or the pre-filled
    # text for an entry field). Body and tail are split on the blank line the
    # parser treats as a paragraph break.
    full = json.load(open(ROOT / "data_extracted/text/GAME.full.json"))["sections"]
    D["dialogs"] = {}
    for key in ("@LANDHO", "@LANDFALL", "@LANDFALL2", "@COLONY", "@RECRUIT",
                "@PURCHASE", "@RENAMECOLONY", "@SAILAWAY", "@SAILHOME",
                "@TRADENAME", "@HOWMUCH1", "@HOWMUCH2", "@HOWMUCH3",
                "@HOWMUCH4", "@HOWMUCH5"):
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
    # `size` is carried through because it IS the plot category the placement
    # RNG reads at [0x8F87 + id*12] -- verified against a live RAM read of that
    # table for all 42 rows (RULINGS.md 2026-08-06b).
    D["buildings"] = [{"name": r["name"], "cost": int(r["cost"]),
                       "min_colony": int(r["min_colony"]), "upkeep": int(r["upkeep"]),
                       "tools_x10": int(r["tools_x10"]), "size": int(r["size"])}
                      for r in rows("@BUILDING")]

    # Per-terrain job yields, used for colony production. Row order is the
    # runtime terrain id within each band.
    YIELDS = ["y_farmer", "y_planter_sugar", "y_planter_tobacco", "y_planter_cotton",
              "y_trapper", "y_lumberjack", "y_ore", "y_silver", "y_fisherman"]
    # Terrain Defensive column (§5.6 / §14.2): open land 0, marsh 1, forests 2,
    # hills 4, mountains 6 -- the +25%-per-point defender bonus.
    D["defensive"] = {k.lstrip("@").lower(): [int(r["defensive"]) for r in rows(k)]
                      for k in ("@UNFORESTED", "@FORESTED", "@OTHER")}
    # The terrain table's `movement` column is the tile's move cost in whole
    # moves (unit budgets are stored in THIRDS, unit.md §3), and `improvement`
    # is the pioneer work threshold at +0x2F78 -- the byte the clear/plow/road
    # executors compare their work counter against.
    D["terrainmove"] = {k.lstrip("@").lower(): [int(r["movement"]) for r in rows(k)]
                        for k in ("@UNFORESTED", "@FORESTED", "@OTHER")}
    D["improvework"] = {k.lstrip("@").lower(): [int(r["improvement"]) for r in rows(k)]
                        for k in ("@UNFORESTED", "@FORESTED", "@OTHER")}
    D["yields"] = {k.lstrip("@").lower():
                   [[int(r[c] or 0) for c in YIELDS] for r in rows(k)]
                   for k in ("@UNFORESTED", "@FORESTED", "@OTHER")}
    D["jobs"] = [r["name"] for r in rows("@JOB")]
    # The master/expert title for each @JOB row, parallel to D["jobs"] -- what a
    # village grants when it teaches (Live Among The Natives, §19.4).
    D["jobexpert"] = [r["expert_name"] for r in rows("@JOB")]
    # @JOB's third column is the SKILL CLASS the schoolhouse reads: 1/2/3 take
    # 4/6/8 turns to teach and need Schoolhouse/College/University; class 4 is
    # not teachable at all (criminals, converts, teachers).
    D["jobtier"] = [int(r["school_tier"] or 4) for r in rows("@JOB")]
    # @ACTIONS: the ten rows of the native-village action menu, in runtime
    # order (spec/ui/context_dialogs.md §6 -- func_04B308 is their sole
    # consumer). @MISSION: the four per-power mission-name prefixes.
    # @ATTITUDE / @LEVELS: the attitude band names and the settlement nouns.
    D["actions"] = [r["name"] for r in rows("@ACTIONS")]
    D["missionpre"] = [r["name"] for r in rows("@MISSION")]
    D["attitude"] = [r["name"] for r in rows("@ATTITUDE")]
    # @ATTITUDINAL: the "Extremely/Very/Rather/Somewhat/Slightly" modifiers
    # the @PISS* announcements compose with the band word.
    D["attitudinal"] = [r["name"] for r in rows("@ATTITUDINAL")]
    # @VALUES: the four-step goods-quality ladder the haggle's @TRADE0
    # %STRING0 indexes (func_049600 tail @0x49AE6, RULINGS 2026-08-07z9).
    D["values"] = [r["name"] for r in rows("@VALUES")]
    # GAME.TXT @SCORE: the endgame joke-name lines ("%STRING0 Fever" ...),
    # one drawn on the @EXPLOITS rating card.
    D["scorenames"] = [l for l in
                       json.load(open(ROOT / "data_extracted/text/GAME.full.json"))
                       ["sections"]["@SCORE"]["body"].split("\n") if l.strip()]
    D["levelname"] = [r["settlement_singular"] for r in rows("@LEVELS")]
    D["regionname"] = [r["name"] for r in rows("@COLONYNAME")]

    game = json.load(open(ROOT / "data_extracted/text/GAME_sections.json"))
    labels = json.load(open(ROOT / "data_extracted/text/LABELS_sections.json"))
    D["eurolabel"] = labels["@EUROLABEL"].split("\n")
    # @TRADENAMES: a leading count then the five route-name nouns the engine
    # picks from when naming a route (Run / Ferry / Cargo / Transport / Triangle).
    D["tradenames"] = [l for l in game["@TRADENAMES"].split("\n")[1:] if l.strip()]

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
    # @INDEPENDENT: the four per-nation republic names the Hall of Fame's
    # "President, <republic>" line uses (capture hof_02_round2.png).
    D["independent"] = [l for l in json.load(
        open(ROOT / "data_extracted/text/NAMES_sections.json"))["@INDEPENDENT"].split("\n")
        if l.strip()]
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
    # Event popup bodies, verbatim from GAME.TXT. These are emitted by the
    # native handlers (§19.7/§19.9): the four mission-founding lines banded by
    # attitude, the two heresy endings, the six raid outcomes, the conversion
    # notice and the loss-of-faith notice.
    # Bodies split on the blank line exactly as the dialogs above: the first
    # paragraph is the notice, a second paragraph (where present) is the option
    # rows, so a choice popup and a plain notice come from the same shape.
    D["events"] = {}
    for k in ("@MISSION0", "@MISSION1", "@MISSION2", "@MISSION3",
              "@HERESY0", "@HERESY1", "@INDIANWELCOME",
              # Keys the port calls (or that replace ad-hoc notices) that were
              # never exported -- each silently no-opped at showEvent's !t
              # guard (popup audit 2026-08-08 + framework sweep 2026-08-07).
              "@BURNED", "@CAPTURED", "@CLEARCUT", "@USEDUPTOOLS",
              "@NOTENOUGH", "@CANCELPEACE", "@INDIANWARFARE", "@MERCS",
              "@UNREST", "@MERCENARIES",
              # Market price movement (func_0305A8) + the boycott-blocked
              # unload (Phase 1 wire-only sweep).
              "@PRICEUP", "@PRICEDOWN", "@SOMEBOYCOTT",
              # Schooling guards + the two lower graduation rungs
              # (func_02D658 teaching block, spec/systems/training.md).
              "@SCHOOL1", "@COLLEGE2", "@UNIV3",
              "@NEEDCOLLEGE", "@NEEDUNIVERSITY", "@NOTEACHER",
              "@TEACHCONVERT", "@TRAINCRIMINAL", "@TRAININDENTURED",
              # Pioneer / colony-siting / movement guards (func_022542 +
              # order predicates; Phase 1). TOONEARBUILD, SHIPLAKE and the
              # TOOMANY* caps are deliberately unwired -- see RULINGS.
              "@NOPLOW", "@NOROAD", "@ONLYCOL", "@ONLYPIO",
              "@TOOMOUNTAIN", "@TOONEAR", "@SEACOLONY", "@NOPORT",
              "@KEEPSTOCKADE", "@LANDFIRST", "@CANNOTATTACK", "@DISBANDSHIP",
              "@TUTNOLUMBER", "@TUTNOSPACES",
              # Warehouse / colony-turn notices + the misc wire-only set.
              "@SPOIL1", "@SPOIL2", "@SPOIL3", "@SPOIL4", "@WAREHOUSEFULL",
              "@CARGOREADY1", "@CARGOREADY2", "@FOOD1", "@FOOD2", "@STARVE2",
              "@EFFICIENT", "@INEFFICIENT", "@CONTINENTAL", "@TIMECHANGE",
              # Trade-route editor bodies (previously paraphrased literals).
              "@TRADESELECT", "@TRADESTART", "@TRADETYPE", "@TRADEDELETE",
              # Phase 2: rush-buy, repairs, build caps.
              "@BUYME0", "@BUYME1", "@REFIT",
              "@NOMOREWAGONS", "@NOMOREWAREHOUSE", "@ALREADYHAVE",
              "@KISSUP", "@KISSSORRY", "@VANISH", "@CUSTOM",
              # Native tension-band announcements + the friendly half.
              "@PISS0", "@PISS1", "@PISS2", "@PISS3", "@PISS4", "@PISS5",
              "@INDIANBEGFOOD", "@INDIANGIVEFOOD", "@INDIANGIVESTUFF",
              "@INDIANCOMMENT", "@INDIANCOME",
              "@INDIANFOREST", "@INDIANFOREST2",
              # The retirement clock + endgame sequence.
              # The news-bulletin bus (native-vs-rival raids + territory).
              "@INDIANWINCOLONY2", "@INDIANBURNCOLONY2", "@INDIANLOSE",
              "@VIOLATE",
              # func_05CA7E aftermath bulletins (RULINGS 2026-08-07z8): the
              # human/third-party variant splits are byte-read.
              "@BURNED2", "@BURNED3", "@CAPTURED2", "@CAPTURED3",
              "@EUROPEWIN", "@EUROPELOSE", "@INDIANWINCOLONY",
              # The native land claim on founding.
              "@INDIANLAND", "@INDIANBOW", "@INDIANTREATY", "@INDIANBRIBE",
              # War of Independence completion: sentiment, losses, siege,
              # arrivals and the screen lockouts.
              "@REBELUP", "@REBELUP50", "@REBELDOWN",
              "@LOSING1", "@LOSING2", "@LOSING3", "@WARN1", "@WARN3",
              "@SIEGE", "@INVASION", "@INTERVENE", "@WINNING",
              "@EUROPENOTAVAIL", "@EUROPENOTLEAVE", "@FOREIGNNOTAVAIL",
              # The Crown: REF growth surface, purchase taxes, the war cycle.
              "@KINGBUY", "@PURCHASETAX", "@MERCANTILISM",
              "@KINGNEWWAR", "@KINGVICTORY", "@KINGMERCY", "@KINGFRIGATE",
              # The pre-capture completion sweep: congress picker, confirms,
              # cargo pickers, foreign trade, ambush bulletins, depletion.
              "@WHICHFREEDOM", "@TRADEWITH", "@DEFICIT",
              "@SUREDELETE", "@SUREDISBAND", "@REALLYBUY", "@LOBOTOMIZE",
              "@ABANDON2", "@RECRUITCHOOSE", "@OVERBOARD",
              "@CARGOLOAD", "@CARGOUNLOAD", "@PICKACARGO", "@SCREWED",
              "@NOCOLONIESEITHER", "@LOSENOCOLONIES",
              "@INDIANWIN0", "@INDIANWIN1", "@INDIANWIN2", "@INDIANGRUDGE",
              "@DEPLETION", "@DEFOREST",
              "@FREEDOM", "@LOOT", "@LOOT2", "@NOLOOT", "@INDIANWAR",
              "@INDIANPEACE", "@INDIANSLAVES", "@SEIZURE", "@SEIZURELAND",
              "@SEIZURESEA", "@AMBUSHHINT", "@HOWTOWIN",
              "@LOSTOURSCOUTS", "@LOSTTHEIRSCOUTS",
              "@INDIANHELLO1", "@INDIANHELLO2", "@DONTKNOWSHIPS",
              "@GRUDGEWAGONS", "@BRING", "@INDIANWARPATH",
              "@KILLWAGONS", "@LOOTWAGONS", "@ROUTELOOP",
              "@TRAVELPLACE", "@SAILPORT", "@TRADENONE2",
              "@INDIANBURN", "@INDIANSURPRISE", "@INDIANBURNCOLONY",
              "@CONFISCATE", "@OTHERMIGHT", "@OTHERLESS", "@OTHERGRANTED",
              "@INDIANSHUN",
              "@SOONRETIRING0", "@SOONRETIRING1", "@RETIRING", "@RETIRING2",
              "@EXPLOITS", "@SCORED",
              # The tutorial lessons (spec/systems/tutorial.md -- bitmask
              # [0x5386/7], per-step idempotent emit sites).
              "@TUTORIAL1", "@TUTORIAL2", "@TUTORIAL3", "@TUTORIAL4",
              "@TUTORIAL5", "@TUTORIAL6", "@TUTORIAL7", "@TUTORIAL8",
              "@TUTORIAL9", "@TUTORIAL10", "@TUTORIAL11", "@TUTORIAL12",
              "@TUTORIAL13", "@TUTORIAL14", "@TUTORIAL15", "@TUTORIAL16",
              "@TUTORIAL17", "@TUTORIAL18", "@TUTORIAL19",
              # The village haggle loop (func_049600).
              "@BUY0", "@BUY1", "@TRADE0", "@TRADE1",
              "@BADHAGGLE0", "@BADHAGGLE1", "@BADHAGGLE2", "@BADHAGGLE3",
              "@BADCARGO", "@BUYWHICH", "@TRADEWHICH",
              "@TRADENOCARGO", "@TRADENOWANT",
              # The European meeting flow (func_057F4E) -- greetings, the
              # standing-peace hub and its branches, demands and guards.
              "@HELLOFIRST", "@HELLOAHOY", "@HELLOMEEK", "@HELLOMANLY",
              "@HELLOUSA",
              "@PEACEMEEK", "@PEACEMANLY", "@OLDPEACEMEEK", "@OLDPEACEMANLY",
              "@PEACEUSA",
              "@NOTWITHDRAW", "@NOTHINGWITHDRAW", "@MAYBEWITHDRAW",
              "@GIFTS", "@PROVOKE",
              "@MILITARY", "@NOCONTACT", "@ALREADYSMITE", "@SMITEINDIANS",
              "@SMITEEUROPE", "@UNFORTUNATE", "@MERCENARY",
              "@TRIBUTEUSA", "@WANTSTUFF", "@WANTSTUFFUSA", "@RID", "@RIDUSA",
              "@WARMEEK", "@WARMANLY",
              "@APOSTATES", "@APOSTATESUSA", "@HEATHEN", "@HEATHENUSA",
              "@PIRACY", "@PIRACYUSA", "@SIEGES", "@SIEGESUSA",
              "@HAVETREATY", "@SNEAK", "@TRADEATWAR", "@TRADEMERCANTILISM",
              "@RAIDSTORES", "@RAIDWREAK", "@RAIDGOLD", "@RAIDBURN", "@RAIDSHIP",
              "@RAIDNOTHING", "@INDIANSCONVERT", "@DEADCONVERTS",
              "@VILLAGEHAPPY", "@VILLAGEMEDIUM", "@VILLAGESAVAGE",
              "@VILLAGEBAD", "@VILLAGEWAR",
              # Live Among The Natives
              "@LEARNSTAY", "@LEARNDONE", "@LEARNSLOW", "@LEARNMASTER",
              "@LEARNCRIMINAL", "@LEARNALREADY", "@LEARNLATER", "@LEARNMAD",
              # Ask to Speak With Chief
              "@CHIEFHOWDY", "@CHIEFGUIDES", "@CHIEFAREA", "@CHIEFGIFT",
              "@CHIEFBORED", "@CHIEFKILL",
              # Demand Tribute / Incite / Attack
              "@EXTORTSTUFF", "@EXTORTPOOR", "@EXTORTLAUGH", "@EXTORTNO",
              "@INDIANWARPATH2", "@WHACKINDIANS", "@EXTINCT",
              "@MADATSHIPS", "@MADATWAGONS",
              # Declaration, the REF war and its endings
              "@DECLARE", "@TOOTORY", "@ALREADYREVOLUTION", "@INDEPENDENCE",
              "@MOBILIZE", "@MOBILIZE2", "@WARN1", "@WARN2", "@WARN3",
              "@CONSIDER", "@INTERVENTION", "@KINGLOSE", "@KINGWIN",
              # The King's tax demands and the tea party
              "@KINGTAX", "@KINGWIFE", "@KINGWAR", "@KINGNAVACT", "@KINGSTAMPACT",
              "@TAXOPTIONS", "@TEAPARTY",
              # Lost City Rumours
              "@LOSTCITY0",
              "@LOSTCITY1", "@LOSTCITY2", "@LOSTCITY3", "@LOSTCITY4", "@LOSTCITY5",
              "@LOSTCITY6", "@LOSTCITY7", "@LOSTCITY8", "@LOSTCITY9",
              "@BURIAL1", "@BURIAL2", "@BURIAL3",
              # Combat aftermath
              "@DEMOTE", "@COLONISTCAPTURE", "@COLONISTCAPTURE2", "@WAGONCAPTURE",
              "@LOOTCAPTURE", "@ARTILLERY", "@ARTILLERY2", "@SHIPDAMAGE",
              "@SHIPSUNK", "@VETERAN", "@VALOR", "@WELLSEASONED", "@HALF",
              # Treasure transport
              "@KINGGALLEON2", "@KINGGALLEON3", "@LOOTCASH", "@CASHTREASURE",
              # Diplomacy
              "@SIGNTREATY", "@DECLAREWAR", "@WORTHY", "@THREATS", "@WITHDRAW",
              "@GIVECASH", "@TRIBUTE", "@NOWARSDURINGREV",
              # Per-turn colony messages (func_02D658 poster)
              "@FOODLOW", "@FOOD1", "@FOOD2", "@STARVE1", "@STARVE2", "@VANISH",
              "@BUILT", "@NEEDTOOLS", "@NEEDTOOLS0", "@NEWCOLONIST",
              "@SONSUP", "@SONSDOWN", "@NODOCKS",
              "@LUMBER", "@COTTON", "@TOBACCO", "@CANESUGAR", "@FURS", "@ORE", "@TOOLS",
              "@WAREHOUSEFULL", "@SPOIL1", "@SPOIL2", "@CARGOREADY1",
              # Schoolhouse teaching
              "@TRAINPROFESSION", "@TRAINFAIL", "@NOTEACHER",
              # Trade routes
              "@TRADETYPE", "@TRADESTART", "@TRADESELECT", "@TRADEDELETE",
              "@TRADEMANY", "@TRADENONE", "@TRADENAME",
              # Native demands on you, Tory uprising, mercenaries
              "@INDIANGOLD", "@INDIANWAGONS", "@INDIANCITY", "@INDIANLAND",
              "@INDIANROAD", "@REBELMAJORITY", "@REBELUNANIMOUS",
              "@TORYMINORITY", "@TORYMAJORITY", "@TORYUPRISING",
              "@KINGRECRUIT", "@UPKEEP", "@ABANDON", "@RENAMECOLONY",
              "@TOONEAR", "@NOPORT", "@MORETHANTHREE", "@SAILAWAY",
              # The Europe harbour context menus (dock units and ships)
              "@EUROPEARM", "@EUROPESHIPCLICK", "@ARMOPTIONS", "@EUROPESHIPOPTIONS",
              # Naval combat, scouts, the Spanish Succession
              "@SHIPCOMBAT", "@FORTFIRE", "@CARGOCAPTURE", "@EVASIVE",
              "@SCOUTCOLONY", "@NOMAYORSDURINGREV", "@SUCCESSION",
              # Options dialogs and Retire
              "@GAMEOPTIONS", "@COLONYOPTIONS", "@SOUNDOPTIONS", "@RETIRE",
              # Pick Music: one main picker plus the three class sub-pickers,
              # all driven by func_023344 (spec/ui/options_dialogs.md §3), and
              # the GAME menu's Exit to DOS confirmation.
              "@PICKMUSIC", "@PICKINDEPENDENCE", "@PICKMILITARY", "@PICKINDIAN",
              "@DOS"):
        if k not in full:
            continue
        sec = full[k]
        para = sec["body"].split("\n\n")
        # '^'-prefixed lines are GAME.TXT's help-card format ('^^' = centred
        # title, '^' = blank) -- @TIMECHANGE is the only event key using it.
        # The port renders help cards as plain popup lines, carets stripped.
        D["events"][k.lstrip("@")] = {
            "body": [l.lstrip("^") for l in para[0].split("\n")],
            "tail": para[1].split("\n") if len(para) > 1 else [],
            "width": int(sec["directives"].get("width", 0x50)),
            "default": sec["directives"].get("default"),
        }
    D["text"] = {
        "beginmenu": game["@BEGINMENU"].split("\n"),
        "leadername": game["@LEADERNAME"],
        "misc": labels["@MISC"].split("\n"),
        # LABELS @CTITLE: the colony screen's own dialog titles -- row 4
        # "Select An Item To Build", row 8 "Select a Profession for", plus the
        # BUY/CHANGE captions and "(No Production)"/"(More)"/"Turns)".
        "ctitle": labels["@CTITLE"].split("\n"),
        "cmessage": labels["@CMESSAGE"].split("\n"),
    }
    # The diplomacy support lists (func_057A3A's %STRING fills): one row per
    # power in @GREATKINGS/@GREATDEEDS/@GREATLEADER(2)/@FRIEND, and
    # @MEEKNESS's request/demand pair.
    D["diplotext"] = {k.lstrip("@"): game[k].split("\n")
                      for k in ("@MEEKNESS", "@GREATKINGS", "@GREATDEEDS",
                                "@GREATLEADER", "@GREATLEADER2", "@FRIEND")}

    # The shipped 1653 Dutch save, bundled so LOAD GAME can restore it without
    # a file picker. Raw bytes; the importer walks the byte-verified 43-block
    # sequence of spec/systems/save.md.
    sav = ROOT / "tools/dosbox_harness/game/COLONY00.SAV"
    if sav.exists():
        D["sav1653"] = base64.b64encode(sav.read_bytes()).decode()
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
    # VGA colour cycling: the band, its step period, and which atlases carry a
    # mask the renderer can re-tint per phase (CYCLE.DAT, build_assets.CYCLE).
    D["cycle"] = dict(man["cycle"])
    D["cycle"]["sheets"] = sorted(k for k, v in man["sheets"].items() if "cycle" in v)
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
    for sh, meta in man["sheets"].items():
        assets["SS_" + sh] = uri(ASSETS / f"{sh}.png")
        if "cycle" in meta:
            assets["CYC_" + sh] = uri(ASSETS / meta["cycle"])
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
  html,body {{ margin:0; height:100%; background:var(--ground);
                overflow-y:hidden; overflow-x:auto; }}
  body {{ display:flex; flex-direction:row; align-items:stretch; }}
  /* `safe center` is load-bearing, not a flourish: plain `center` on an
     over-wide child splits the overflow BOTH ways, and the left half then sits
     outside the scroll origin where overflow-x:auto can never reach it -- the
     plaza colonist row at logical x 0..33 became unclickable. `safe` falls back
     to flex-start the moment the child would overflow. resize() also subtracts
     the panel width, so this is the second line of defence. */
  #stage {{
    flex:1 1 auto; min-width:0;
    display:flex; flex-direction:column; align-items:safe center;
    justify-content:safe center; gap:14px; padding:16px;
  }}
  /* The debug column. It reserves its own width so it never overlaps the
     screen; hiding it (backtick, or the x) gives the game the space back and
     rescales it to exactly what it was before the panel existed. */
  /* Fixed width, and resize() subtracts the same number so the screen and the
     panel never fight over the same pixels. Keep the two in step. */
  #debug {{
    flex:0 0 430px;
    height:100%; overflow-y:auto; overflow-x:hidden;
    background:#0F0C0A; border-left:1px solid var(--rule);
    font:11px/1.45 ui-monospace,"SF Mono",Menlo,Consolas,monospace;
    color:#C9BFA8; padding:0 0 24px;
  }}
  #debug.hidden {{ display:none; }}
  #debug h1 {{
    position:sticky; top:0; margin:0; padding:8px 10px;
    background:#1A130E; border-bottom:1px solid var(--rule);
    font:600 10px/1 ui-monospace,monospace; letter-spacing:.18em;
    text-transform:uppercase; color:var(--gold);
    display:flex; justify-content:space-between; align-items:center;
  }}
  #debug h1 button {{
    background:none; border:1px solid var(--rule); color:var(--muted);
    font:inherit; cursor:pointer; padding:2px 6px; border-radius:2px;
  }}
  #debug #dbgbody {{ display:flex; flex-direction:column; height:calc(100% - 29px); }}
  /* Tabs. A single row that wraps rather than scrolling, so no tab can hide. */
  #dbgtabs {{
    display:flex; flex-wrap:wrap; gap:2px; padding:6px 6px 4px;
    border-bottom:1px solid var(--rule); background:#140F0B;
  }}
  #dbgtabs .tab {{
    background:none; border:1px solid transparent; color:var(--muted);
    font:inherit; cursor:pointer; padding:2px 7px; border-radius:2px;
    letter-spacing:.04em;
  }}
  #dbgtabs .tab:hover {{ color:#E4DCC6; }}
  #dbgtabs .tab.on {{ color:#14100C; background:var(--gold); font-weight:600; }}
  #dbgpane {{ flex:1 1 auto; overflow-y:auto; padding:0 0 24px; }}
  #debug .sub {{
    color:var(--gold); padding:8px 8px 3px; letter-spacing:.06em;
    border-bottom:1px solid #241A12;
  }}
  #debug .none {{ color:#5C5344; padding:6px 8px; }}
  #debug .note {{ color:#5C5344; padding:6px 8px; line-height:1.5; }}
  /* Key/value, for genuine scalars only. */
  #debug .kv {{ padding:4px 8px 6px; }}
  #debug .row {{ display:flex; gap:8px; align-items:baseline; }}
  #debug .row .k {{ flex:0 0 132px; color:var(--muted); }}
  #debug .row .v {{
    flex:1 1 auto; min-width:0; color:#E4DCC6;
    white-space:pre-wrap; overflow-wrap:break-word;
  }}
  /* Tables. The wrapper scrolls sideways on its own so a wide table can never
     widen the panel or get silently clipped. */
  #debug .tw {{ overflow-x:auto; padding:2px 0 8px; }}
  #debug table {{ border-collapse:collapse; font-size:10px; white-space:nowrap; }}
  #debug thead th {{
    position:sticky; top:0; background:#1A130E; color:var(--muted);
    text-align:left; font-weight:400; padding:3px 7px;
    border-bottom:1px solid var(--rule); letter-spacing:.05em;
  }}
  #debug tbody td {{ padding:2px 7px; color:#E4DCC6; border-bottom:1px solid #1C1510; }}
  #debug tbody tr:hover td {{ background:#191309; }}
  #debug th.n, #debug td.n {{ text-align:right; }}
  #debug td.dim {{ color:#6E6350; }}
  #debug td.hot {{ color:#E0A33A; }}
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
<div id="stage">
<div id="cabinet"><canvas id="screen" tabindex="0"></canvas></div>
<p id="hint"><b>Arrows</b> choose &amp; move &nbsp;·&nbsp; <b>Enter</b> confirm
&nbsp;·&nbsp; <b>Space</b> end turn &nbsp;·&nbsp; or click
&nbsp;·&nbsp; <b>`</b> debug panel</p>
</div>
<aside id="debug"><h1>State <button id="dbgclose" title="hide (`)">&times;</button></h1>
<div id="dbgbody"></div></aside>
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
