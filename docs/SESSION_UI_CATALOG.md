# Session UI / Events / Popups Catalog

Built 2026-05-05 from systematic frame-by-frame review of
`session_1777952458/frames/` (396 frames, 7 turns of gameplay,
years 1543–1550). Each entry documents an observed UI state,
the memory signature that produces it, and what game data is on
display.

This is the in-game ground truth that anchors all the renderer
work — when a renderer claims to draw the Continental Congress,
the values it draws should match what the game showed in the
frame cited here.

---

## 1. Default map view

**Frequency**: 155 / 396 snaps (the majority of game time).
**Font signature**: `(248, 207)` — full draw rect = 16 cells × 13
cells, the entire map viewport at native 320×200 mode.

**Layout (frame 1310262984)**:
- Top menu bar (yellow text on wood-panel): GAME / VIEW / ORDERS /
  REPORTS / TRADE / CHEAT / COLONIZOPEDIA
- Top-right minimap (~80×54 px) — shows whole world with a white
  rectangle indicating current viewport; orange dots = own colonies,
  grey/red dots = foreign or natives
- Right sidebar (woodgrain bg) shows context-dependent info:
  - Always: `Spring NNNN` `Gold: NNNN%` `Tax: NN%`
  - When unit selected: unit sprite + `Moves: N` + `Locat: (x, y)`
    + unit type / skill (e.g. `54 Eng. Scouts Expert`) + orders
    (`No Orders` / `Sentry` / `Going to London`) + terrain in parens
- Map fills the left ~3/4 of screen; hexagonal-ish sprite tiles

**Sidebar variants observed**:
- Foreign colony (Quebec — Spanish): shows colony name + nation +
  `Gold: 2200` (their treasury) + colonist list
- Foreign colony with trade interface: `With:` (commodities to trade)
  `Ask:` (what they want) + ship list

---

## 2. Colony view

**Frequency**: 33 snaps (Plymouth visited 2 times).
**Font signature**: `(88, 95)` — 6 cells × 6 cells = 96×96 viewport.

**Layout (frame 1310196718 — Plymouth, Spring 1543, Gold 19200)**:
- Top banner: `Plymouth, Spring 1543, Gold: 19200%`
- Top-left: colony scene (buildings, trees, colonists at work)
- Top-right: viewable-tiles grid (3×3 worked tiles + center = colony)
  showing crops being produced per tile
- Bottom strip: 4 panels
  - Left: colonist list with SoL / Tory percentages: `102 (0)` and
    `902 (5)` numbers (units per category × bell points?)
  - Center: `Loading: Caravel` panel showing ship + cargo crates
  - Right: production icons (cross, lightning, wrench-icon = produce
    bell/cross/hammer)
  - Far right: 3 stacked button slots — buildings selected
- Bottom row: 16 commodity icons with stockpile counts (numbers below
  each icon — `31, 96, 0, 0, 0, 100, 0, 0, ...`)
- Bottom-right: red `Exit` button (sprite EXIT_E)

**16-good order in bottom strip** (matches NAMES.TXT @CARGO):
Food, Sugar, Tobacco, Cotton, Furs, Lumber, Ore, Silver, Horses,
Rum, Cigars, Cloth, Coats, Trade, Tools, Muskets

**Build menu overlay** (frame 1310206750) — opens when "Change"
button clicked, lists all 19 building types with hammer/tool costs:

| Building | Hammers | Tools |
|----------|--------:|------:|
| Stockade | 64 | – |
| Armory | 52 | – |
| Docks | 52 | – |
| Schoolhouse | 64 | – |
| Warehouse | 80 | – |
| Stable | 64 | – |
| Printing Press | 52 | 20 |
| Weaver's Shop | 64 | 20 |
| Tobacconist's Shop | 64 | 20 |
| Rum Distillery | 64 | 20 |
| Fur Trading Post | 56 | 20 |
| Lumber Mill | 52 | – |
| Church | 64 | – |
| Blacksmith's Shop | 64 | 20 |
| Wagon Train | 40 | – |

(F1 for Help) hint shown bottom-right of the dialog.

---

## 3. Continental Congress report

**Frame**: `1310124562`
**Font signature**: `(248, 207)` — same as default map (full screen);
the report draws as an overlay PIK, so font_w/h don't change.

**Layout** (over CCBKGD background — orange-toned scene with
robed figure at desk):
- Top title: `CONTINENTAL CONGRESS ACTIVITIES`
- Line 1: `Next Continental Congress Session: (William Brewster)
  (30 in 129)` — current FF being acquired with progress bar
- Progress bar — long thin bar with white tick marks; current
  marker visible at ~23% of bar (= 30/129)
- Line 2: `Rebel Sentiment: 13%   Tory Sentiment: 87%`
- Below that: 7 cyan/blue bell sprites (1 per bells/turn) +
  USA flag at left
- Line 3: `English Expeditionary Force:`
- Visualized as 4 sprite groups with count badges:
  - Red soldier sprites with `23` badge (Regulars)
  - White/blue dragoon sprites with `10` badge (Cavalry)
  - Black artillery sprites with `8` badge (Artillery)
  - Yellow ship sprites with `5` badge (Man-O-War)
- Line 4: `Founding Fathers:` then list — `Adam Smith`
- Bottom-right: `OK` button

**Memory tied to display**:
| Display | Address | This frame value |
|---------|---------|------------------|
| Rebel Sentiment 13% | PowerRecord+0x02 byte | 13 |
| Tory Sentiment 87% | derived = 100 − Rebel | 87 |
| Bells/turn (7 sprites) | PowerRecord+0x0E word | 7 |
| FF count (1 = Adam Smith) | PowerRecord+0x14 word | 1 |
| Congress progress (30) | derived from +0x0C accumulator (=99) | – |
| FF threshold (129) | FF table at DGROUP:0xE7AC | 129 |
| REF Reg 23 / Cav 10 / Art 8 / MoW 5 | DGROUP:0x53DA..0x53E1 | (23,10,5,8) |

---

## 4. Europe screen (London/New England trade port)

**Frame**: `1310291187`
**Layout**:
- Top banner (yellow on dark wood): `Selling Sugar at 1632 Gold: (19200%)`
  — current trade transaction summary (1632 = sell-price-format, see
  notes)
- Trade-result text: `Sold 72 Rum at 0%/ton`, then aligned columns
  - `Price:    0%`
  - `0% Tax:   0%`
  - `Net:      0%`
- Sky background fills upper half
- Right-side buttons: `RECRUIT`, `PURCHASE`, `TRAIN`
- Mid-screen 3 docked panels (left to right):
  - `Expected Soon` — ships en route from Europe
  - `Bound For New England` — ships sailing back to player
  - `Loading: Caravel` — ship currently loading cargo at the dock
- Right-half: harbor scene (London buildings, dock walkway)
- Bottom row: 16 commodity icons each with two numbers `current/max`
  - Food: `1/29` with red **X** = **BOYCOTTED**
  - Sugar: `17/19`
  - Tobacco: `5/7`
  - Cotton: `4/6`
  - Furs: `16/18`
  - Lumber: `1/6`
  - Ore: `3/6`
  - Silver: `19/20`
  - Horses: `3/4`
  - Rum: `0/0` (saturated, no buyers)
  - Cigars: `0/0`
  - Cloth: `0/0`
  - Coats: `0/0`
  - Trade Goods: `2/3`
  - Tools: `1/2`
  - Muskets: `2/3`
- Bottom-right: red `Exit E` button

**Critical observation — boycott vs saturation**:
- Food shows red X on top of icon = BOYCOTTED state
- Rum/Cigars/Cloth/Coats show `0/0` numbers but no X = market
  saturated, returns 0 gold but legal to attempt
- This refutes the earlier guess that `0xC8` in PowerRecord+0x4C..+0x5B
  is a boycott marker. Boycott is stored elsewhere (TBD) — the 0xC8
  bytes correspond to the saturated-zero-price goods.

---

## 5. Merchant price-change banner popup

**Frame**: `1310280609` (Sugar fallen to 17), `1310348437` (Sugar
risen to 20), `1310385812` (Sugar risen to 21), `1310430343` (Sugar
risen to 22), `1310462140` (Sugar risen to 23).

**Font signature**: `(40, 15)` or `(8, 15)` — small banner draw rect.

**Layout**: Half-figure merchant sprite (MSS2 — purple feathered cap,
yellow doublet, white frilled cuffs, beard) standing slightly above
center with arms outstretched. Wood-panel popup box below merchant
contains green/yellow text:

> `The price of Sugar in London has fallen to 17%.`
> (or `risen to 20%.` etc.)

- Sugar/commodity name highlighted in yellow
- Price number highlighted in yellow
- Map view + sidebar still visible BEHIND the popup (popup overlays
  the lower-center of the map)

**Sugar price trajectory observed across session**:
- Spring 1543 start: ~28 (per memory snapshot)
- Spring 1546: fell to 17
- Spring 1546 (later): risen to 20
- Spring 1548: risen to 21
- Spring 1549: risen to 22
- Spring 1549 (later): risen to 23

Each price change is a separate popup. The merchant sprite is the
same MSS2 portrait every time.

---

## 6. Ship-status banner popups

**Font signature**: `(56, 31)`, `(120, 15)`, `(72, 15)` etc. — small
top-banner text.

**Examples seen**:
- `English Caravel Sailing For London` (frame 1310221421) —
  Caravel just departed Plymouth for London with cargo
- `Caravel Docks At Plymouth` (frame 1310392843) — Caravel arrived
- Map view stays visible; banner text in top wood-strip area

These are status banners not modal popups — game continues, you
can click through them.

---

## 7. (Outside Colony) cursor banner

**Frame**: many in 1310196xxx range
**Layout**: When the player has selected a colonist who is NOT
working in a colony cell (= "(Outside Colony)" — these are colonists
on the colony scene but not assigned), the game shows a small
white-on-black `(Outside Colony)` text label near the cursor.

---

## 8. Foreign colony info — sidebar trade view

**Frame**: `1310321000` (Santo Domingo, Spanish, Spring 1546)
**Layout** (sidebar only, map visible left):
- `Spring 1546   Gold: 3552%   Tax: 0%`
- `Locat: (46, 34)   12` — coords + something
- `New Spain` — owner nation
- `(Tropical Forest) (Road)` — tile attributes
- Colony icon + `Santo Domingo` name
- `With:` line — small commodity icons for goods Santo Domingo
  has to trade (boots, swords, ammo, tools)
- `Ask:` line — what they want (musket icon)
- `Merchantman 53 No Orders` — ship at the foreign colony
- `Fisherman 54 No Orders` — colonist there
- `+ More +` — scroll indicator

This is the "view foreign colony" interaction triggered by clicking
on another nation's colony with one of your own units adjacent or
on a trade-capable unit.

---

## 9. Advisor warning popup — "no ocean access"

**Frame**: `1310261859`
**Font signature**: `(184, 207)` — wide popup, full height.

**Layout**: Half-figure Pioneer character (MSS3 — fur hat, beard,
holding rifle, brown jacket) standing center of screen with rifle
held diagonally. Wood-panel popup box below contains green text:

> `This square does not have access to the ocean, Your Excellency.
> If we build a colony here we must transport its produce to port
> using wagon trains, which we can build in any colony.`
>
> `"Oh, I forgot about that."`
> `"And that is exactly what I had in mind."`

- 2 response options (player chooses one; lower text is brighter)
- Map view still visible behind popup

**Trigger**: Player attempted to found a colony on a tile not
adjacent to ocean. Sidebar shows the founding unit (`54 Eng.
Scouts Expert`) at tile (49, 46) on Tropical Forest.

---

## 10. Inca region exploration view

**Frame**: `1310345000`
**Font signature**: `(248, 143)` — wider draw rect, no popup.

**Layout**: Map shows lower South America with:
- White-capped mountains on left edge
- Yellow desert / cactus scrubland
- Inca pyramid/temple sprites (sun-disc and stepped pyramid icons)
- Native braves (Inca units with red/white markers)
- Player Scout sprite near pyramid
- "New Amste..." label visible (cut off — colony name)

This is the user exploring the Inca-controlled region with a Scout.
Frame 1310333546 shows similar Inca terrain at smaller render scale.

---

## Movement patterns observed across session

From frame-by-frame analysis:

| Unit | Movement |
|------|----------|
| **54 Eng. Scouts (Expert)** | Mid-Eastern coast → south through forest → discovery of Aztec/Inca regions |
| **Veteran Soldier (later 42 No Orders)** | Stationed at (27, 5) Boreal Forest — northern frontier |
| **English Caravel** | Cycle: Plymouth dock → sail to London (sea lane) → return with new immigrants |
| **Multiple Dragoons** | Patrol formation around Roanoke / Plymouth / New Amsterdam |
| **Carpenter (88 Sentry)** | Stationed inside Plymouth |

The session shows the user methodically exploring south, scouting
foreign colonies for trade intel, and rotating ships between
Plymouth and Europe for sugar export.

---

## Memory state changes correlated with events

| Frame range | Game event | Memory delta |
|-------------|-----------|--------------|
| 1310124562 | First Continental Congress shown | Rebel +0x02 = 13 |
| ~1310225000 | Tax-event triggered | tax +0x01: 0 → 1 (later frames) |
| 1310330093 (turn 54) | First Boston Tea Party | king-anger 0x53A7: 3 → 4 |
| 1310335828 (turn 54) | Second Boston Tea Party | king-anger 0x53A7: 4 → 5 |
| Mid-session | Rebel sentiment grew | PowerRecord+0x02: 13 → 25 → 28 |
| Mid-session | Sugar prices rose 5× | 0xC8 saturation marker stable |

---

## Open questions / TBD

1. **FF threshold table location** — the `129` for William Brewster
   appeared at multiple DGROUP offsets including 0xE7AC. The full FF
   table layout (cost + unlocked-at-position + name) needs decoding.
2. **Boycott bitfield** — Food's red X needs a separate flag location.
3. **Bell accumulator** — bells/turn at +0x0E is per-turn, but the
   ROLLING-TOTAL that triggers REF growth is unidentified.
4. **Foreign colony info display field** — when hovering over a
   foreign colony, the "Locat: (x,y) 12" includes a mystery `12` —
   maybe colony size or population.

---

## Sprite usage observed in this session

Cross-reference between session frames and the
`reverse_engineered/assets/sprites/` library. Each entry below
identifies the sprite asset by directory name, gives its visual
description (verified from the .png), and lists the in-session
frame(s) where it appears.

### Half-figure character portraits — popup speakers

The 6 MSS / 4 MYR sheets are half-figure portrait sprites used
as the "speaker" graphic in modal popups. Each has a single
sprite at `<NAME>/<NAME>.SS.000.png`.

| Sheet | Visual | Role | Used in this session |
|-------|--------|------|----------------------|
| **MSS0** | Naval Officer — bicorne hat, blue/red uniform, epaulettes | Admiral / military official | not observed in session 1777952458 |
| **MSS1** | Continental Soldier — tricorn hat, holding rifle, blue coat | Pioneer / colonist returning with gold | not observed |
| **MSS2** | **Merchant** — purple feathered cap, yellow doublet, white frilled cuffs, beard | London merchant / trade messenger | **frames 1310280609, 1310348437, 1310385812, 1310430343, 1310462140** — every Sugar @PRICEDOWN / @PRICERISE popup |
| **MSS3** | **Pioneer** — fur hat, beard, holding rifle diagonally, brown jacket | Scout / advisor warning the player | **frame 1310261859** — @NOOCEANCOLONY warning |
| **MSS4** | Jesuit Priest — black robes, cross necklace, wide black hat | Mission / religious advisor | not observed |
| **MSS5** | Nun — white wimple, cross necklace | Mission / religious advisor (female) | not observed |
| **MYR0** | Native chief — red robe, feathered headdress, arms outstretched | Tribal speaker | not observed |
| **MYR1** | Courtier / diplomat — blue waistcoat, white wig | European diplomatic figure | not observed |
| **MYR2** | Yellow-robed figure (looks like merchant or trader) | trade-related dialog | not observed |
| **MYR3** | Native elder — orange/amber robe, beard | tribal elder dialog | not observed |

### Full-figure portraits

| Sheet | Visual | Role |
|-------|--------|------|
| **KING** | King in red coat, white wig, full standing figure | King's tax-raise dialog, royal events |
| **KING1**, **KING2** | (variant kings) | Probably French/Spanish/Dutch king variants |
| **KINGLOSE**, **KINGWIN** | (lose / win poses) | End-of-game cinematics |

### Event scene woodcuts — all 13 verified

The 13 WDCUT##.SS files are large (~150×80px) painted scenes used
as the visual header for major events. All verified by direct
.png inspection 2026-05-05:

| Sheet | Visual description | Event association (from STATUS.md + GAME.TXT) |
|-------|-------------------|------------------------------------------------|
| **WDCUT01** | Sailor on ship deck **with French tricolor flag**, pointing to land | French-led discovery / La Salle event / @DISCOVER |
| **WDCUT02** | Native chief **seated under tree with peace pipe**, calm posture | @INDIANPEACE — first peaceful contact |
| **WDCUT03** | Native group on shore + **European boat landing**, cargo carriers | First contact / @MEET / explorer arrival |
| **WDCUT04** | **Aztec royal couple** with stepped pyramid + gold treasure objects | @CASHTREASURE — Inca/Aztec gold ransom |
| **WDCUT05** | **Inca royal couple** in mountain terrain with **llamas grazing** | @LOSTCITY1 / Inca capital discovery (different from Aztec WDCUT04) |
| **WDCUT06** | **Sunset shore scene** with figure planting flag near boat | Founding-colony moment / @LANDFALL |
| **WDCUT07** | Frontier scout (rifle) with **distant native village (teepees)** | @LOSTCITY2 — scout sighting unmapped village |
| **WDCUT08** | **Jungle creek between two native silhouettes** (peering through foliage) | @AMBUSH / @FOUNTAIN_OF_YOUTH discovery |
| **WDCUT09** | **Ship dockside with cargo crates** + shirtless dockworkers | @TRADE / loading ship / @DOCKLOADING |
| **WDCUT10** | **Bloody battle field** with soldiers firing at each other | @BATTLE / war event |
| **WDCUT11** | **Burning settlement at night** with flames and fleeing figures | @COLONYBURN / colony raid (player's colony razed) |
| **WDCUT12** | **Burning native village**, natives fleeing with weapons raised | @RAIDBURN — player razes native village |
| **WDCUT13** | **Native warriors dancing/celebrating** in red war paint | @WARDANCE / native braves spawned |

### Map unit sprites (ICONS sheet)

`ICONS.SS.000`..`ICONS.SS.NNN.png` — small (~16×16) sprites used
on the map for units, ships, and inventory commodities.

Observed in session frames (right sidebar + map):

| Sprite role | Visual at small scale | Where seen |
|-------------|----------------------|------------|
| Caravel | Brown ship with sails | Plymouth dock, sailing for London |
| Merchantman | Larger ship with multiple sails | Santo Domingo (Spanish, frame 1310321000) |
| Scout (mounted) | White horse + rider with red flag badge | "54 Eng. Scouts Expert" sidebar entry |
| Dragoon | Mounted soldier with sword | multiple in patrol formations |
| Foot colonist | Standing figure | Plymouth interior + (Outside Colony) marker |
| Pioneer | Figure with hat | working tiles in Plymouth |
| Native brave | Figure with red marker | natives on map |
| Native mounted brave | Mounted with red marker | aggressive natives |

### UI / chrome sprites

| Sheet | Visual | Used for |
|-------|--------|----------|
| **WOODFRAM** | Wood-grain rectangular frame with hollow center | The brown popup-box border seen on every modal popup (PRICEDOWN, NOOCEAN, etc.) |
| **NAMEPLAT** | Inner sprite — colony nameplate background | Background plate for colony names visible on map |
| **WOODTILE** | Repeating wood-grain texture | Right sidebar background, fills behind text |
| **PARCH** | Parchment scroll | King's tax dialog backdrop |
| **CURSOR** | Mouse cursor variants | Default arrow + contextual cursors |
| **BUILDING** | Colony building sprites | All buildings inside Plymouth colony view (church, smith, docks, etc.) |
| **EXIT** | Red E button | "Exit" button bottom-right of Europe + Colony screens |

### Founding Father portraits (CC-00 .. CC-24) — full mapping

25 portrait sprites, one per Founding Father. Indices map directly
to NAMES.TXT @FATHERS line order, verified by direct .png
inspection cross-referenced against historical likenesses.

#### Trade category (FF type 0)

| Index | FF Name | Visual |
|------:|---------|--------|
| **CC-00** | Adam Smith | Young man, brown coat, holding green ledger/book |
| **CC-01** | Jakob Fugger | Older man with yellow tunic, gold-trimmed cap, holding gold/scrolls |
| **CC-02** | Peter Minuit | Man in dark coat with feathered hat, beaded pouch (Dutch trader) |
| **CC-03** | Peter Stuyvesant | Man with **peg leg**, dark coat, holding green flag |
| **CC-04** | Jan de Witt | Blue/white doublet, blonde hair, lacy collar (Dutch official) |

#### Exploration category (FF type 1)

| Index | FF Name | Visual |
|------:|---------|--------|
| **CC-05** | Ferdinand Magellan | Red robe, holding **globe**, gold star/badge — circumnavigator |
| **CC-06** | Francisco Coronado | Knight in **silver armor with feathered helm**, conquistador |
| **CC-07** | Hernando de Soto | Knight in armor with red plume on helmet |
| **CC-08** | Henry Hudson | Bearded man in blue with **map/parchment**, gold sash |
| **CC-09** | Sieur De La Salle | Green coat, holding rifle, **dog at his feet** (frontier explorer) |

#### Military category (FF type 2)

| Index | FF Name | Visual |
|------:|---------|--------|
| **CC-10** | Hernan Cortes | Knight in heavy armor with sword, red cross emblem |
| **CC-11** | George Washington | Gentleman in **red & blue uniform with cape**, white hose |
| **CC-12** | Paul Revere | Green coat with **lantern in hand**, brown drum/saddle (the iconic ride) |
| **CC-13** | Francis Drake | Sailor sitting on **chest of gold coins**, gold buttons |
| **CC-14** | John Paul Jones | Naval officer in **dark blue uniform with cannonballs at feet** |

#### Political category (FF type 3)

| Index | FF Name | Visual |
|------:|---------|--------|
| **CC-15** | Thomas Jefferson | White-haired man in white waistcoat **holding Declaration scroll** |
| **CC-16** | Pocahontas | Native American woman in tan dress with **single feather**, holding flowers |
| **CC-17** | Thomas Paine | Green coat, **pointing finger upward** (orator pose), red book in other hand |
| **CC-18** | Simon Bolivar | Officer in dark uniform with sword, sash (South American liberator) |
| **CC-19** | Benjamin Franklin | Older bald man in **green coat sitting on chair** |

#### Religious category (FF type 4)

| Index | FF Name | Visual |
|------:|---------|--------|
| **CC-20** | William Brewster | **Puritan** in brown clothes, hat, holding sack — Plymouth founder |
| **CC-21** | William Penn | Quaker in black/white outfit, **holding book** |
| **CC-22** | Jean de Brebeuf | Priest in dark blue robe with **gold cross** (French Jesuit) |
| **CC-23** | Juan de Sepulveda | Figure in **colorful patterned cape & feathered hat** |
| **CC-24** | Bartolome de las Casas | Friar in dark hooded robe holding **skull** (memento mori) |

In this session, the only acquired FF was **Adam Smith** (CC-00) —
visible as text in the Continental Congress report at frame
1310124562. Other CC-NN portraits appear in dedicated FF
acquisition popups + Continental Congress detail screens.

### Declaration sprites (DEC-UPPA..Z, DEC-LOWA..Z)

52 letter sprites (26 uppercase + 26 lowercase) of cursive
handwriting style — used for the signing of the Declaration of
Independence screen (post-revolution endgame). Not used in this
pre-revolution session.

### Background images (.PIK format) — full identification

All 35 PIK backgrounds visually identified by direct .png inspection
2026-05-05. Each is 320×200 (mode 13h native).

#### Gameplay screens (used during normal play)

| PIK | Visual / role |
|-----|---------------|
| **CCBKGD** | Orange-toned scene with white-wigged man at writing desk — Continental Congress |
| **EUROPE** | Sky over harbor, ships, dockside buildings — Europe trade port |
| **COLONY** | 320×72 strip drawn at y=128..200 — colony screen middle band + inventory bar (uses EUROPE.PIK palette, 2-section MADSPACK only) |
| **DECLARAT** | Parchment Declaration of Independence document — pre-revolution signing screen |
| **DECOIND** | Declaration deco-image (decorative border for revolution screen) |
| **WOODPANL** | Wood-grain panel — right sidebar background, used on every map frame |
| **WOODPAN2** | Wood-grain variant — different sidebar style (likely score / report alt) |

#### Advisor reports (REPORT1..9)

The Reports menu has 9 advisor categories. Each PIK is an
orange-toned painted scene matching the advisor's domain:

| PIK | Visual | Advisor |
|-----|--------|---------|
| **REPORT1** | Native warrior on shore with spear, ships in distance | **INDIAN ADVISER** |
| **REPORT2** | Preacher at pulpit before seated congregation | **RELIGIOUS ADVISER** |
| **REPORT3** | Two men at desk reviewing documents (workforce mgmt) | **LABOR ADVISER** |
| **REPORT4** | Frontier work scene — pioneers building colony | **COLONY ADVISER** |
| **REPORT5** | Trade scales + currency + hourglass on table | **ECONOMIC ADVISER** |
| **REPORT6** | Aerial view of fortified colony with palisade | COMBAT ANALYSIS / military view |
| **REPORT7** | Galleon with full sails at sea | **NAVAL ADVISER** |
| **REPORT8** | Map with wax seal stamp + cartographer's tools | **FOREIGN AFFAIRS** |
| **REPORT9** | Same composition as REPORT1 (native + spear) | duplicate / Indian Adviser alt |

(Final advisor mappings refined to align with `render_report.py`
existing assignments + LABELS.TXT @MISC titles.)

#### Setup / menu screens

| PIK | Visual | Used for |
|-----|--------|----------|
| **OPENING** | Old-style world map with sea monsters, dragons, ships, "OCEANVS OCCIDENTALIS" / "TERRA INCOGNITA" labels | Title screen / boot |
| **OPENMENU** | (menu over OPENING bg) | Main menu |
| **OPENBORD** | Decorative border | Opening screen frame |
| **NATIONS** | 4 wood-framed nation flag plaques (Eng + Fr / Sp + Du) | Nation selection screen |
| **DIFFICUL** | 5 conquistador-era figures in wood frames — Discoverer / Explorer / Conquistador / Governor / Viceroy | Difficulty selection screen |
| **CUSTOMIZ** | Customization options screen | Game customization |

#### End-game

| PIK | Visual | Used for |
|-----|--------|----------|
| **KINGLSS1** | King-loses cinematic frame 1 | When King loses Revolution |
| **KINGLSS2** | King-loses cinematic frame 2 | continuation |
| **CLOS-BKG** | Closing cinematic background | End credits |

#### Scenario thumbnails (LEVN0001..LEVN0010)

10 small scenario preview images shown on the New Game screen.
Each represents a different historical scenario / preset map.

These weren't observed in the gameplay session (which was a regular
new game), but they appear when the user picks "Custom Scenario"
from the main menu.

### Session frame ↔ background mapping

| Session frame | Background loaded |
|---------------|-------------------|
| 1310124562 (Continental Congress) | CCBKGD.PIK |
| 1310291187 (Europe screen) | EUROPE.PIK + COLONY.PIK overlay |
| 1310196718 (Plymouth colony) | COLONY.PIK |
| All map-view frames | WOODPANL.PIK (right sidebar only; map area is tile-rendered) |

The session never triggered any REPORT, KINGLSS, NATIONS, or
DIFFICUL screens (those would appear from menu navigation, not
in-game events).

### BUILDING sprite sheet — colony interior elements

48 sprites in `BUILDING.SS.000..047.png` — used to compose the
colony scene. Each colony renders as a layered scene of multiple
BUILDING sprites placed at fixed positions in the layout.

Categories observed from the contact sheet:

| Range | Category |
|-------|----------|
| 000–005 | Fence pieces / palisade segments (horizontal logs) |
| 006–010 | Stockade gate variants (with/without doors) |
| 011–019 | Trees / forest decoration sprites |
| 020–029 | Smaller building sprites (huts, sheds, blacksmith with chimney) |
| 030–039 | Mid-size buildings (warehouses, mills) |
| 040–047 | Large signature buildings (church, large warehouse, custom-house) |

The actual building-name → sprite-index mapping is set by the
colony renderer (`func_02D658`) and uses the sprite indices
hardcoded in the disasm. From session frame 1310196718 (Plymouth)
the visible buildings include:
- Church (large white-roof building bottom-center)
- Sawmill / lumber huts
- Log cabin colonist dwellings
- Stockade fence around perimeter
- Ferry dock (water edge)

The `BUILDING_contact_sheet.png` shows all 48 in a grid for visual
reference.

### ICONS sprite sheet — units + commodities + UI markers

266 sprites in `ICONS.SS.000..NNN.png` — the master sprite sheet
for ALL on-map units, ship types, commodity icons in the inventory
bars, and small UI markers like the boycott red X.

Categories observed from the contact sheet:

| Range | Category |
|-------|----------|
| 000–011 | Ship types (Caravel, Merchantman, Galleon, Privateer, Frigate, Man-O-War, ...) + Wagon Train, Artillery |
| 012–023 | Commodity barrels / bales (Food, Sugar, Tobacco, Cotton, Furs, Lumber, Ore, Silver, Horses, Rum, Cigars, Cloth, Coats, Trade Goods, Tools, Muskets — exact mapping per NAMES.TXT @CARGO order) |
| 024–035 | More commodities + raw resources |
| 036–047 | UI markers (incl. **slot 043 = red X = BOYCOTT marker**, slot 044 = mission cross, etc.) |
| 048–059 | Nation flag elements + colony nameplates |
| 060–095 | Land unit sprites — Colonist, Soldier, Veteran, Dragoon, Pioneer, Hardy Pioneer, Scout, Missionary, Jesuit, etc. |
| 096–107 | Selected/active unit highlighted variants (with red selection border) |
| 108–117 | Ground items / decorations |
| 118–265 | Continued unit poses + animations |

The **red X at ICONS.SS.043** is the boycott marker observed on
Food in the Europe screen (frame 1310291187) — confirms boycott is
rendered as an icon overlay, not stored in PowerRecord +0x4C..+0x5B.

The boycott bitfield in DGROUP must therefore signal:
"draw ICONS.SS.043 over good index N's icon" — and is a separate
bitfield I haven't located yet (16 bits, only Food's bit set in
this game state).

### NAMEPLAT, WOODFRAM, PARCH, CURSOR, EXIT

Smaller "chrome" sheets:

| Sheet | Sprites | Role |
|-------|--------:|------|
| **NAMEPLAT** | (small) | Inner sprite — colony nameplate background that shows behind colony names on map |
| **WOODFRAM** | 1 | Wood-grain rectangular frame border — used on every modal popup box |
| **PARCH** | 1 | Parchment/scroll background — used for King's tax dialog backdrop |
| **CURSOR** | several | Mouse cursor variants (arrow, target, sword, no-entry, hourglass) |
| **EXIT** | 1 | Red E button — bottom-right of Europe + Colony screens |

The frame at 1310124562 confirms Adam Smith's name appears as a
TEXT STRING (not as a CC-NN portrait blit) — the FF list at the
bottom of the Congress screen is plain green text, not sprite-based.

### Per-sprite usage summary for renderers

For rendering correctness, the priority assignments verified by
this session are:

1. **PRICEDOWN/PRICERISE popup** = `WOODFRAM` border + `MSS2` speaker
   sprite + green text body. Speaker is positioned slightly above
   center; popup box below the speaker; both rendered over a still
   map view. Text uses GAME.TXT @PRICEDOWN / @PRICERISE template.

2. **NOOCEAN warning popup** = `WOODFRAM` border + `MSS3` speaker +
   green/yellow text + 2 response options at bottom (lower text
   highlighted as the "active" choice).

3. **Continental Congress** = `CCBKGD.PIK` full-screen + REF sprites
   from `ICONS` (4 unit-type icons with count badges) + bell sprites
   (looks like a small bell icon repeated 7× for bells/turn) + text
   labels in yellow/cyan. No CC-NN sprite required for FF list
   (text-only).

4. **Europe screen** = `EUROPE.PIK` full-screen background + 16
   commodity icons (from ICONS sheet) at bottom + 3 text panels +
   `EXIT` red button + 3 button stack (RECRUIT/PURCHASE/TRAIN).

5. **Colony screen** = colony-specific PIK background + `BUILDING`
   sprites placed by colony-layout rules + 16 commodity-icon row +
   colonist sprites (from ICONS) at work-tile positions + 3-panel
   bottom strip + `EXIT` red button.

### Native tribe portrait sprites (IND0..IND7) — full mapping

8 native tribe sprite sheets, each with 4 animation/pose frames
(A0/A1/A2/A3 suffix). These are full-figure tribal representatives
used in native diplomacy / chief-meeting popups + the Indian
advisor in Continental Congress.

Tribe order matches NAMES.TXT @TRIBES (not the DGROUP TribeData
indexing — those use a different mapping; see DATA_MODEL.md):

| Sheet | Tribe | Visual (A0 frame) |
|-------|-------|------------------|
| **IND0** | Inca | **Female in long brown dress with beaded necklace** (royal/ceremonial) |
| **IND1** | Aztec | Male warrior, **feathered headdress + spear**, gold/yellow shoulder |
| **IND2** | Arawak | Bare-chested male with **red sash**, single-feather headband |
| **IND3** | Iroquois | Bare-chested male, **holding tomahawk**, beaded belt |
| **IND4** | Cherokee | Female in **white dress with beaded necklace** |
| **IND5** | Apache | Male in **dark heavy fur cloak**, holding spear, green-feather headband |
| **IND6** | Sioux | Male with **full-feather war bonnet** + leather tunic (Plains chief) |
| **IND7** | Tupi | Male in **grass skirt with leaf headdress** (Amazonian) |

Civilization tier visible from outfit complexity:
- **Tier 3 (Inca)**: full clothing, ceremonial dress
- **Tier 2 (Aztec)**: warrior gear with insignia
- **Tier 1 (Arawak/Iroquois/Cherokee)**: partial clothing, tools
- **Tier 0 (Apache/Sioux/Tupi)**: nomadic / minimal clothing

A1/A2/A3 suffixes are the same tribe rendered in different
orientations (likely combat-direction frames).

### European nation flags/banners

| Sheet | Nation | Visual |
|-------|--------|--------|
| **ENGLND1, ENGLND2** | England | **Red banner with gold lions / dragons heraldry**, quartered |
| **FRANCE1, FRANCE2** | France | **Blue banner with gold fleur-de-lis** pattern |
| **SPAIN1, SPAIN2** | Spain | **Red/white quartered with castle/lion** (Spanish royal arms) |
| **DUTCH1, DUTCH2** | Netherlands | **Orange/purple/black vertical stripes** (Princely tricolor variant) |

The "1" and "2" suffixes are likely paired flags hung on either
side of a podium/throne in the Continental Congress / diplomatic
screens, OR variants for normal vs ceremonial banners.

### KING sprite variants

| Sheet | Visual | Used for |
|-------|--------|----------|
| **KING** | Standing king in **red coat, white wig**, pointing | Default king-tax-raise dialog (your own king) |
| **KING1** | King **walking with corgi/dog**, casual pose | Possibly during peaceful king events / monthly stipend |
| **KING2** | (similar variant) | Likely France/Spain/Dutch king alternate |
| **KINGLOSE** | King **dejected, slumped pose**, head in hand, dog beside | Loss cinematic when player loses Revolution |
| **KINGWIN** | King **leaping back with crown thrown off**, dog watching | Victory cinematic when player wins Revolution (the iconic "victory dance") |

### End-game / cinematic sprites

| Sheet | Visual | Used for |
|-------|--------|----------|
| **WIN** | **Independence Hall at night with fireworks**, American flag flying | Revolution victory celebration screen |
| **WIN-FWRK** | (fireworks animation overlay frames) | Animated fireworks over WIN background |
| **MPSLOGO** | MicroProse logo | Boot screen |
| **MPSNAME** | MicroProse text | Boot/credits screen |

### Score screen panels (SCORE01..SCORE24) — extended visual catalog

24 small painted illustrations (~50×35px) shown alongside the
end-of-game score breakdown — one per score category. The art
deliberately mixes period-appropriate scenes (forts, agriculture,
wildlife) with **anachronistic humor** (drive-thru franchise,
school bus, sports player) — a signature MicroProse joke style.

| Sheet | Visual | Score category (inferred) |
|-------|--------|---------------------------|
| **SCORE01** | Half-cut-off laughing man face | indolence / lazy ruler penalty |
| **SCORE02** | Mosquito on water | disease / death from insects |
| **SCORE03** | Eagle / torn parchment | heroic deeds gone wrong |
| **SCORE04** | Shoreline with fish leaping | fishing / coastal |
| **SCORE05** | Castle / fortress walls | military defense |
| **SCORE06** | Drive-thru fast-food (anachronistic!) | commercialism |
| **SCORE07** | Curved road through countryside | road infrastructure |
| **SCORE08** | Orange flowers | flora / wilderness |
| **SCORE09** | School bus (anachronistic) | education |
| **SCORE10** | Apples in a basket | food production |
| **SCORE11** | Stone bridge over creek | bridge engineering |
| **SCORE12** | Brown eagle perched | military victory / national symbol |
| **SCORE13** | Red-brick mansion / civic building | established settlement |
| **SCORE14** | Cougar / mountain lion | predator wildlife |
| **SCORE15** | Yellow stone pillar with sun emblem | achievement marker |
| **SCORE16** | River through forested hills | exploration / wilderness |
| **SCORE17** | Industrial complex / factories | manufacturing |
| **SCORE18** | Plowed fields with plants | agriculture |
| **SCORE19** | Grand Canyon (sandstone cliffs, river view) | geography / national park |
| **SCORE20** | Athlete with ball (anachronistic) | sports/recreation |
| **SCORE21** | Western US states map (Wyoming/Colorado area) | territorial expansion |
| **SCORE22** | Sheriff star badge (anachronistic) | law enforcement |
| **SCORE23** | USA outline filled red | national unification |
| **SCORE24** | Map of North America | total continental expansion |

All 24 SCORE panels now visually identified. The recurring theme:
period-appropriate scenes mixed with deliberately anachronistic
modern American imagery (drive-thru, school bus, sports player,
sheriff badge). The renderer should match each panel to its
score-category line by reading the disasm-cited mapping in
`func_03A9C0` (score-screen renderer).

Each SCORE panel maps to one score-line entry. Full mapping needs
disasm of `func_03A9C0` (score-screen renderer at file 0x03A9C0).
The 24 panels likely match the categories listed in
LABELS.TXT @MISC under "COLONIZATION SCORE":
Citizens, Independence, Villages Burned, Foreign Recognition,
Total Score (and other components from the score formula).

### Cursor variants (CURSOR.SS)

Just 2 sprites in the CURSOR sheet:
- **CURSOR.SS.000** = Default arrow cursor (small white arrow)
- **CURSOR.SS.001** = Click-target marker (small white dot/cross)

Per the disasm + observation, the game uses these alongside hardware-
managed mouse cursor states — additional context-specific cursors
(target, hourglass, no-entry) are likely rendered ad-hoc rather than
loaded from this sheet.

### NAMEPLAT — colony nameplate elements (3 sprites)

NAMEPLAT.SS contains 3 small chrome sprites used for the
flag/nameplate decoration shown next to colony names on the map:

- **NAMEPLAT.SS.000** = Pennant point / flag-tip wedge (small triangle)
- **NAMEPLAT.SS.001** = Pole base / flat tab
- **NAMEPLAT.SS.002** = Pennant tail / second flag-tip variant

These are composited next to colony name labels on the map view
to form the small flag-graphic that prefixes each colony name.

### Closing cinematic (CLOS-* sheets)

7 cinematic-fragment sprites used in the closing sequence
(post-game credits + retirement). Each is small (10..30 px),
composited together with CLOS-BKG.PIK background:

| Sheet | Visual | Role in cinematic |
|-------|--------|-------------------|
| **CLOS-BEL** | Tiny white serif character | Title/text overlay element |
| **CLOS-FWK** | Star-burst firework explosion (wide) | Fireworks animation |
| **CLOS-HAT** | Tricorn hat (period-appropriate) | Retiree's hat in scene |
| **CLOS-LDY** | Lady in gown (small figure) | Female figure in retirement scene |
| **CLOS-MAN** | Man in long coat (small figure) | Male figure in retirement scene |
| **CLOS-MIL** | Military figure with rifle next to stone | Soldier guard in scene |
| **CLOS-ROC** | Tiny rock/stone cluster | Decorative ground prop |

Cinematic plays after the player retires or wins the revolution.

### Opening cinematic (OPEN* sheets)

15 sprites for the title-screen / opening cinematic:

| Sheet | Visual | Role |
|-------|--------|------|
| **OPENLOGO** | MicroProse logo | First boot screen |
| **OPENBORD** | Decorative border | Frame around opening menu |
| **OPENMENU** | Menu PIK | Main menu background |
| **OPENGUY** | Tiny waving figure with rifle | Foreground colonist sprite |
| **OPENSHIP** | Period sailing ship sprite (animated) | Ship moving across map |
| **OPENFISH** | Tiny fish silhouette | Sea-monster decoration on map |
| **OPENSUN** | Sun-rays gradient stripe | Animated sunrise overlay |
| **OPENMON1**, **OPENMON2**, **OPENMON3** | Sea-monster heads (3 variants) | Mythological sea creatures decorating "TERRA INCOGNITA" map |
| **OPENWND1**, **OPENWND2** | Wind-puff sprites | Wind-rose animation |
| **OPENCRD1**, **OPENCRD2**, **OPENCRD3** | Coordinate / heraldry markers | Compass-rose elements |
| **OPENTILE** | Tile pattern | Background fill |
| **OPENBONK** | (impact / clash sprite) | Boot-sequence sound-cue art |

The opening cinematic composes these over OPENING.PIK (the
old-style world map with sea monsters) for the iconic boot screen.

### Opening and closing cinematic sprites

`OPEN*` and `CLOS-*` sprites belong to the OPENING.EXE and
CLOSING.EXE introductory/credits cinematics — separate executables
from VICEROY.EXE. Not loaded during normal gameplay; they're
shown when launching the game and on game-end victory respectively.

### Declaration of Independence letter sprites

`DEC-LOWA..Z` (26) + `DEC-UPPA..Z` (26) + `DEC-SQIG` = 53 sprites
of cursive handwriting style. Used to render the full Declaration
text on the signing screen (post-revolution). Each sprite is a
single hand-drawn letter; the renderer composes the Declaration
paragraph by paragraph using these.

### Sprites used in this session vs library coverage

This session triggered:
- 1 of 25 CC-NN (Adam Smith — text only, no portrait blit)
- 2 of 6 MSS (MSS2 merchant, MSS3 pioneer)
- 0 of 4 MYR
- 0 of 8 IND tribes (no native combat / chief-meeting events)
- 0 of 4 nation flag pairs (no diplomatic full-screen)
- 0 of 13 WDCUT (no major events fired)
- 0 of 24 SCORE (end-of-game only)
- 0 of 53 DEC-* (post-revolution only)

But the library is now **fully visually identified** — any future
session can be analyzed against this catalog to confirm sprite
roles by direct comparison.

---

## How to use this catalog

When implementing a renderer for any of these UI states:

1. Find the matching frame here for visual reference.
2. Use the listed memory addresses to source the dynamic values.
3. Cross-check with the doc layout described above.

When investigating a new event/popup type:

1. Find a frame near the relevant event timestamp in the trace.
2. Check the font signature — that's a quick clue to the popup type.
3. Compare adjacent memory snapshots to identify which globals
   changed during the event.
