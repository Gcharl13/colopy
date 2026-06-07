# PEDIA.TXT — Colonizopedia content catalog

Parsed from `COLONIZE/PEDIA.TXT` 2026-05-05. Total: 1,784 lines,
163 indexed entries across 6 categories.

The Colonizopedia is the in-game encyclopedia accessed via the
`COLONIZOPEDIA` menu in the top bar. Each typed section provides
a description for one game entity.

## Category index counts

| Category | Index range | Count |
|----------|------------|------:|
| `@FATHER0..24` | 0..24 | **25** Founding Fathers |
| `@CARGO0..15` | 0..15 | **16** cargo/commodity types |
| `@UNIT0..23` | 0..23 | **24** unit types |
| `@BUILDING0..41` | 0..41 | **42** colony buildings |
| `@TERRAIN0..28` | 0..28 | **29** terrain types |
| `@JOB0..26` | 0..26 | **27** colonist jobs (skills) |

Total: 163 indexed entries.

Plus 2 named sections:
- `@PEDIA` — list of category names (Cargo Type / Unit Type /
  Terrain Type / Colonist Skill / Colony Building / Founding
  Father / Game Concept)
- `@MISCELLANEOUS` — list of game-concept article titles
  (Disband / Fortify / Plowing / Roads / Sentry / Trade Route /
  Veteran Units / Prices / Taxes / Liberty Bells / Crosses / Hammers)

## Cross-reference: PEDIA index → sprite asset

### `@FATHER0..24` ↔ `CC-00..CC-24`

Index mapping is direct: PEDIA.TXT `@FATHER0` describes Adam Smith
and the sprite is at `assets/sprites/CC-00/`. The order matches
NAMES.TXT @FATHERS exactly (5 trade, 5 exploration, 5 military,
5 political, 5 religious — see `SESSION_UI_CATALOG.md` for full
visual mapping).

### `@CARGO0..15` ↔ ICONS commodity sprites

The 16 commodities are indexed in the same order across:
- NAMES.TXT @CARGO
- PEDIA.TXT @CARGO0..15
- PowerRecord market arrays (+0x4C, +0x5C, +0x7C, +0xBC, +0xFC)
- ICONS.SS commodity-icon range (estimated indices 12-27 per
  contact sheet)

Order: `0=Food, 1=Sugar, 2=Tobacco, 3=Cotton, 4=Furs, 5=Lumber,
6=Ore, 7=Silver, 8=Horses, 9=Rum, 10=Cigars, 11=Cloth, 12=Coats,
13=Trade Goods, 14=Tools, 15=Muskets`

### `@UNIT0..23` ↔ ICONS unit sprites

24 unit types described in PEDIA. Maps to ICONS sprites for the
on-map unit graphic. Type indices used by UnitRecord +0x00:

| PEDIA Index | Likely Unit |
|------------:|-------------|
| 0 | Free Colonist |
| 1 | Indentured Servant |
| 2 | Petty Criminal |
| 3 | Indian Convert |
| 4 | (skill variant) |
| 5 | Veteran Soldier |
| 6 | Continental Army |
| 7 | (other military) |
| 8 | Pioneer |
| 9 | Hardy Pioneer |
| 10 | Missionary |
| 11 | Jesuit Missionary |
| 12 | Scout |
| 13 | Seasoned Scout |
| 14 | Dragoon |
| 15 | Veteran Dragoon |
| 16 | Continental Cavalry |
| 17 | Artillery |
| 18 | Wagon Train |
| 19 | Caravel |
| 20 | Merchantman |
| 21 | Galleon |
| 22 | Privateer |
| 23 | Frigate / Man-O-War |

(Mapping inferred — needs cross-check vs PEDIA @UNIT body text;
confirmed indices appear in UnitRecord byte +0x00 from session
dumps where types 0x00, 0x02, 0x04, 0x0a, 0x0b, 0x0e, 0x12, 0x13,
0x14, 0x17 were observed).

### `@BUILDING0..41` ↔ BUILDING.SS sprite indices

42 buildings in PEDIA but only 48 sprites in BUILDING.SS. The
mapping isn't 1:1 — some buildings may share a sprite across
construction levels (e.g., "Stockade", "Fort", "Fortress" upgrade
chain shares a building footprint).

The 15 player-buildable buildings from the in-session Build menu
(frame 1310206750 Plymouth) are a SUBSET of the 42 PEDIA
buildings:

| Build menu | PEDIA index (likely) |
|-----------|---------------------|
| Stockade | @BUILDING0 (probably) |
| Armory | ... |
| Docks | ... |
| Schoolhouse | ... |
| Warehouse | ... |
| Stable | ... |
| Printing Press | ... |
| Weaver's Shop | ... |
| Tobacconist's Shop | ... |
| Rum Distillery | ... |
| Fur Trading Post | ... |
| Lumber Mill | ... |
| Church | ... |
| Blacksmith's Shop | ... |
| Wagon Train | ... |

The full 42 likely includes upgrades:
- Stockade → Fort → Fortress (3 levels)
- Armory → Magazine → Arsenal
- School → College → University
- Docks → Drydock → Shipyard
- Warehouse → Warehouse Expansion
- Press → Newspaper
- Weaver's → Textile Mill
- Tobacconist → Cigar Factory
- Distillery → Rum Factory
- Trading Post → Fur Factory
- Lumber Mill → Sawmill (alt)
- Church → Cathedral
- Blacksmith → Iron Works
- + Statehouse + Custom House + Stable + Wagon

That's ~30, plus some special buildings.

### `@TERRAIN0..28` ↔ NAMES.TXT terrain order

29 terrain types — matches NAMES.TXT @UNFORESTED + @FORESTED +
special terrains. Used by .MP map data byte values.

### `@JOB0..26` ↔ NAMES.TXT @JOB

27 colonist jobs/skills — matches NAMES.TXT @JOB section. Used
in colony view to label each colonist's profession.

## Format syntax in PEDIA entries

Each `@CATEGORY<N>` entry is followed by:
- `@width=N` — popup display width
- One or more body lines using:
  - `^` at line start = blank line marker
  - `{...}` braces = yellow highlight
  - `^{Title}` = highlighted heading
  - Plain text = green body text

Example (`@FATHER0` Adam Smith):
```
@FATHER0
@width=300
^{Adam Smith (1723-1790)}
British economist who published the first major work of political 
economy, "An Inquiry into the Nature and Causes of the Wealth of 
Nations," which was a detailed examination of the consequences of 
economic freedom.
^
{Adam Smith allows factory level buildings to be built in the colonies.
```

The first line is the title (yellow), then descriptive text
(green), then `^` blank lines, then game-effect summary (yellow
in braces).

## Renderer wiring spec

To render the Colonizopedia:
1. Game-init loads PEDIA.TXT into a section table.
2. User opens menu → COLONIZOPEDIA → category selection.
3. User picks an item (e.g. "Adam Smith" from the Founding Fathers
   list).
4. Renderer:
   - Looks up `@FATHER<N>` in PEDIA.TXT
   - Uses `@width=300` for popup geometry
   - Renders title line in yellow (FONTKING)
   - Renders body in green (FONTSMAL or default)
   - Highlights `{...}` segments in yellow
   - Composes WOODFRAM border + body
5. For Founding Father entries specifically, also blits the
   matching CC-NN sprite portrait alongside the text.

## Outstanding mapping work

- Verify exact PEDIA index for each PEDIA @BUILDING entry by
  reading body text (mention building name → confirm index).
- Same for @UNIT and @JOB.
- Cross-check that NAMES.TXT @CARGO[i] = PEDIA.TXT @CARGO<i>
  describes the same commodity.
