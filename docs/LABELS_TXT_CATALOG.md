# LABELS.TXT — UI label string catalog

Parsed from `COLONIZE/LABELS.TXT` 2026-05-05. Total: 292 lines, 7
named sections.

LABELS.TXT contains **fixed UI labels** — text strings rendered
directly in screen positions (button captions, status labels,
section headers). Unlike GAME.TXT messages (which are dynamic
templates with substitution variables), LABELS.TXT entries are
static.

## Section: `@INFO` (4 entries)

Sidebar info-line labels for the right-side panel during normal
map view:

- `Moves:` — selected unit's remaining movement points
- `Locat:` — selected unit's coordinates
- `With:` (×2) — cargo description for ships / wagons

## Section: `@MISC` (~210 entries)

The mega-section. Mostly UI labels and short status phrases. Key
categories:

### Advisor report titles

- `INDIAN ADVISER REPORT` — for REPORT1.PIK (native warrior bg)
- `RELIGIOUS ADVISER REPORT` — for REPORT2.PIK (preacher bg)
- `LABOR ADVISER REPORT` — for REPORT4.PIK (frontier work bg)
- `ECONOMIC ADVISER REPORT` — for REPORT5.PIK (scales+currency bg)
- `COLONY ADVISER REPORT` — likely REPORT3.PIK (clerks at desk)
- `NAVAL ADVISER REPORT` — for REPORT7.PIK (galleon bg)
- `FOREIGN AFFAIRS REPORT` — for REPORT8.PIK (map+seal bg)
- `COMBAT ANALYSIS` — for REPORT6.PIK (fortified colony bg)
- `CONTINENTAL CONGRESS ACTIVITIES` — for CCBKGD.PIK
- `ENCYCLOPEDIA OF COLONIZATION` — for Colonizopedia screen
- `COLONIZATION SCORE` — for end-game score screen
- `COLONIZATION HALL OF FAME` — for Hall of Fame screen
- `SCORING COMPLETE` — score-finished overlay
- `CUSTOMIZE NEW WORLD` — for CUSTOMIZ.PIK setup

### Sentiment / Continental Congress

- `Rebel` / `Tory` / `Sentiment` — Continental Congress sentiment
- `Sons of Liberty` — colony SoL display
- `Continental Congress` / `Next Continental Congress Session`
- `Founding Fathers` — section header in CC report
- `King's Popularity` — Tory sentiment alt label
- `Rebel Unrest` / `Tory Unrest`
- `Boycott` — boycott marker label

### Buttons / actions

- `OK` / `Exit` / `Continue turn.` / `Zoom to colony.`
- `Zoom to Europe.` — Europe button label
- `(More)` / `(Exit)` / `(Click on item to zoom)`
- `(Delete Destination)` — trade route editor
- `(F1 for Help)` — help hint

### Status / movement

- `Sailing For` / `Inbound From` / `Now Arriving In` / `Docks At`
- `Expected Soon` / `Bound For` / `Awaiting Passage`
- `No Ships In Port` / `Off Mapboard (Europe)` / `On Mapboard` / `In Colonies`
- `High Seas`
- `Loading` / `Unloading` / `onto` / `in`
- `(Outside Colony)` — colonist-not-assigned marker
- `(Withdrawn from New World)` — defeated nation status

### Combat / military

- `COMBAT ANALYSIS` — combat detail screen
- `Fatigue` / `Attack Bonus` / `Ambush` / `Terrain`
- `Colony` / `Fortified` / `Spain Bonus` / `Plowed`
- `Artillery In Open` / `Expeditionary Force`
- `Rebels` / `Tories`
- `Bombard`
- `Combat` / `Attack` / `Defense or Ambush Bonus`
- `Artillery Vs. Raid`

### Economy

- `Cost:` / `Gold` / `Tons` / `K` (= 1000)
- `Tax:` / `% Tax` / `Net` / `Price` / `$/ton`
- `Sold` / `Bought` / `at`
- `sells` / `for`
- `Bid Price` / `Ask Price` / `Asking` / `Bidding`
- `(Building Upkeep)` / `TOTAL UPKEEP`

### Native / mission

- `Mission` / `Missions`
- `Lost City Rumor`
- `Wilderness` / `Land` / `of the` / `Forest`
- `Extinct`
- `Veteran` / `Seasoned` / `Learned` (skill levels)

### Foreign affairs

- `War` / `Peace`
- `Adviser`
- `Colonies` / `Population` / `Average Colony`
- `Military Power` / `Naval Power` / `Merchant Marine`
- `Foreign Recognition`

### Score

- `COLONIZATION SCORE`
- `Citizens` / `Independence` / `Villages Burned`
- `Declared` / `Achieved`
- `Total Score`

### Customization

- `CUSTOMIZE NEW WORLD` / `Click Here When Finished`
- `Choose` / `Difficulty Level` / `Level`
- `Easiest` / `Easy` / `Moderate` / `Tough` / `Toughest`
- `Select` / `European Power`
- `Land Mass` / `Land Form` / `Temperature` / `Climate`
- `Small` / `Moderate` / `Large`
- `Archipelago` / `Normal` / `Continents`
- `Cool` / `Temperate` / `Warm` / `Arid` / `Wet`

### Hall of Fame

- `COLONIZATION HALL OF FAME`
- `to` / `A.D.`
- `President` / `General, Continental Army` / `Leader`
- `Score` / `Colonization_Rating`

## Section: `@ROUTE` (10 entries)

Trade route editor — when player sets up automated wagon/ship
routes between colonies and Europe:

- `EDIT TRADE ROUTE`
- `Route Name:` / `Route Type:`
- `Sea` / `Land`
- `Destination`
- `Unload Cargo` / `Load Cargo`
- `(Delete Destination)`

## Section: `@CMISC` (3 entries)

Colony view misc — small headers inside colony screen:

- `Harvest / Resources`
- `Units Present`
- `Make`

## Section: `@CTITLE` (10 entries)

Colony title bar + Build menu:

- `Pop:` (population label)
- `Gold:` (treasury label)
- `BUY` / `CHANGE` (buttons)
- `Select An Item To Build`
- `(No Production)`
- `(More)`
- `Turns)`
- `Select a Profession for`
- `Tax:`

## Section: `@CMESSAGE` (~16 entries)

Colony transaction messages — printed when buying/selling
commodities or transferring units:

- `bought for` / `sold for` / `moved to` / `at`
- `. Price:` / `% Tax:` / `. Net:`
- `No room for` / `Nothing to transport` / `Not enough`
- `to fill cargo hold!` / `too expensive!`
- `No` / `in cargo hold!` / `Nothing to transfer!`
- `Buying` / `Selling`
- `Loading` / `Unloading`

## Section: `@EUROLABEL` (4 entries)

Europe screen button labels — verified visible in session frame
1310291187:

- `RECRUIT`
- `PURCHASE`
- `TRAIN`
- `x` — exit / close button glyph

## Cross-reference: REPORT.PIK ↔ adviser title

| PIK | Title from @MISC | Frame match |
|-----|-----------------|-------------|
| REPORT1 | INDIAN ADVISER REPORT | native warrior on shore |
| REPORT2 | RELIGIOUS ADVISER REPORT | preacher in church |
| REPORT3 | LABOR ADVISER REPORT | clerks at desk (workforce mgmt) |
| REPORT4 | COLONY ADVISER REPORT | pioneers building (settlement) |
| REPORT5 | ECONOMIC ADVISER REPORT | scales / currency / hourglass |
| REPORT6 | COMBAT ANALYSIS or Continental Congress aerial | fortified colony |
| REPORT7 | NAVAL ADVISER REPORT | galleon under sail |
| REPORT8 | FOREIGN AFFAIRS REPORT | map + diplomatic stamp |
| REPORT9 | (duplicate of REPORT1) | native warrior alt |

**Note**: REPORT6 mapping is ambiguous between COMBAT ANALYSIS and
a Continental-Congress-style overview. The CCBKGD.PIK is the
PRIMARY Continental Congress background (verified via session
frame 1310124562). REPORT6 is more likely COMBAT ANALYSIS or
"Military Defense" report.

The 9 REPORT screens cover 8 distinct advisor categories + 1
duplicate. CCBKGD.PIK + CONTINENTAL CONGRESS ACTIVITIES is a 9th
report-style screen reached via Reports menu.

## Renderer wiring spec

For correct UI rendering, label strings should be loaded from this
file at game-init (not hardcoded in renderer source). Each label
entry is line-indexed within its section:

```
LABELS.TXT @CTITLE[0] = "Pop:"
LABELS.TXT @EUROLABEL[0] = "RECRUIT"
LABELS.TXT @MISC[44] = "INDIAN ADVISER REPORT"
```

The disasm `func_0749E0` (NAMES.TXT loader) also loads LABELS.TXT
into a parallel string table — verified by string-xref scans.
