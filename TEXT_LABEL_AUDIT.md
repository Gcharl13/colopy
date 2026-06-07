# Text Label Audit (2026-05-03)

Comprehensive cross-reference of every text string used in the Python
renderers against the canonical strings in COLONIZE/*.TXT files.

The four authoritative sources of UI text are:

| File | Sections of interest | Used by |
|------|---------------------|---------|
| `COLONIZE/LABELS.TXT` | `@INFO @MISC @ROUTE @CMISC @CTITLE @CMESSAGE @EUROLABEL` | colony / Europe / reports / score / sidebars / inventory |
| `COLONIZE/GAME.TXT`   | `@VICEROY @KINGTAX @WHACKINDIANS @LOSTCITY1..9 @INDIANWAR @RAIDBURN ...` | dialogs / popups / menus |
| `COLONIZE/NAMES.TXT`  | `@COUNTRY @NATIONALITY @NATIONABBREV @HOMEPORT @COLONYNAME @LEADERNAME @DIFFICULTY` | nation/leader/colony name defaults |
| `COLONIZE/MENU.TXT`   | `@GAME @VIEW @ORDERS @REPORTS @TRADE @PEDIA` | gameplay top menu bar |
| `COLONIZE/COLONY.TXT` | `@ENGLISH @FRENCH @SPANISH @DUTCH` | colony name pools |
| `COLONIZE/WOODCUT.TXT`| `@WOODCUT` | WDCUT01..13 sprite labels |

---

## Font + color rules (verified)

| Color | RGB | Used for | Citation |
|-------|-----|----------|----------|
| Yellow / gold | (200, 160, 24) | menu bar items, button labels, dialog highlight braces, %VAR substitutions, dialog titles in nameplate, Europe/Colony/score titles | acaab05 dialog yellow highlights |
| Body green | (80, 144, 48) | dialog body, report body, popup body, sidebar status, nations title, finish prompt | acaab05 dialog body |
| Dark navy | (20, 28, 120) | colony inventory cell numbers | colon3.jpg cell numbers |
| White | (255, 255, 255) | SoL bars (rebel/tory %), minimap viewport rect | colon3.jpg SoL bars |
| Black | (0, 0, 0) | Audience parchment ink | KINGLSS1 user reference |
| Red | (220, 60, 60) | "Exit" labels (Europe right edge) | 0d9a26d Europe |

Font rules:
- **FONTKING**: ONLY for "Audience with the King" parchment.
- **FONTTINY**: default for all other text — title bars, menus,
  dialogs, popups, inventory numbers, sidebar, button labels.
- **FONT-NP**: nameplate strip text (shadowed). 2-bit recoloring.
- **FONTINTR**: opening / introduction screens.

---

## Per-renderer audit

### `render_gameplay.py` — top menu bar + sidebar

| Rendered string | Source | Status |
|-----------------|--------|--------|
| GAME / VIEW / ORDERS / REPORTS / TRADE | MENU.TXT @GAME @VIEW @ORDERS @REPORTS @TRADE | ✓ verified |
| COLONIZOPEDIA | MENU.TXT @PEDIA (~COLONIZOPEDIA) | ✓ verified |
| Spring 1510 | LABELS.TXT @MISC (no specific entry — season+year template) | ✓ acceptable |
| Gold: NNNN  Tax: N% | LABELS.TXT @CTITLE (`Gold:`, `Tax:`) | ✓ verified |
| Moves: N | LABELS.TXT @INFO (line 9: `Moves:`) | ✓ verified |
| Locat: (X, Y) | LABELS.TXT @INFO (line 10: `Locat:`) | ✓ verified |
| Fr. Caravel / No Orders / (Ocean) | derived from unit state | ✓ acceptable |

### `render_europe.py` — Europe screen

| Rendered string | Source | Fix applied |
|-----------------|--------|-------------|
| London. Spring, 1492. Tax: 0%   Gold: 1000 | NAMES.TXT @HOMEPORT + @CTITLE keys | ✓ verified |
| Expected Soon | LABELS.TXT @MISC line 24 | ✓ verified |
| Bound For \<colony\> | LABELS.TXT @MISC line 25 | ✓ verified |
| No Ships In Port | LABELS.TXT @MISC line 26 (capital `I`) | ✓ verified |
| **RECRUIT / PURCHASE / TRAIN** | LABELS.TXT @EUROLABEL lines 288-290 | **Fixed:** changed from "Recruit"/"Purchase"/"Train" to UPPERCASE |
| Exit | LABELS.TXT @MISC line 225 | ✓ verified |

### `render_colony.py` — Colony management screen

| Rendered string | Source | Fix applied |
|-----------------|--------|-------------|
| Baltimore. Spring, 1567. Gold: 4010 | NAMES.TXT @COLONYNAME pool + @CTITLE keys | ✓ verified |
| Town Hall (building label) | PEDIA.TXT @BUILDING list | ✓ acceptable |
| 5% (0) / 95% (8) — Tory/Rebel | LABELS.TXT @MISC `Rebel`, `Tory`, `Sentiment`, `Sons of Liberty` | ✓ acceptable |
| **No Ships In Port** | LABELS.TXT @MISC line 26 | **Fixed:** "No Ships in Port" → "No Ships In Port" (cap I) |
| Inventory cell numbers | dynamic | ✓ verified |
| EXIT (vertical) | LABELS.TXT @MISC line 225 (`Exit`) | ✓ verified |

### `render_nations.py` — Nation selection

| Rendered string | Source | Fix applied |
|-----------------|--------|-------------|
| Select / European / Power | LABELS.TXT @MISC lines 185-187 | ✓ verified (3-line stacked) |
| **Click Here When Finished** | LABELS.TXT @MISC line 176 | **Fixed:** removed surrounding `()` parens |
| Selected nation name | NAMES.TXT @COUNTRY (England/France/Spain/Netherlands) | ✓ verified |
| Trade | LABELS.TXT @MISC line 191 | ✓ verified |

### `render_score.py` — End-of-game score

| Rendered string | Source | Status |
|-----------------|--------|--------|
| COLONIZATION SCORE | LABELS.TXT @MISC line 129 | ✓ verified |
| Citizens | LABELS.TXT @MISC line 130 | ✓ verified |
| Continental Congress | LABELS.TXT @MISC line 149 | ✓ verified |
| Total Score | LABELS.TXT @MISC line 136 | ✓ verified |
| Independence | LABELS.TXT @MISC line 131 | ✓ verified |
| Villages Burned | LABELS.TXT @MISC line 132 | ✓ verified |
| Foreign Recognition | LABELS.TXT @MISC line 135 | ✓ verified |
| Achieved | LABELS.TXT @MISC line 134 | ✓ verified |
| Early Revolution | LABELS.TXT @MISC line 157 | ✓ verified |
| Liberty Bells | (LABELS.TXT — used elsewhere) | ✓ acceptable |
| Rebel Sentiment | LABELS.TXT @MISC `Rebel` + `Sentiment` lines 84,86 | ✓ verified |
| Walter Raleigh / Explorer / England | NAMES.TXT @LEADERNAME[0] / @DIFFICULTY / @COUNTRY[0] | ✓ verified |

### `render_report.py` — 9 advisor reports

| Rendered title | Source | Status |
|----------------|--------|--------|
| INDIAN ADVISER REPORT | LABELS.TXT @MISC line 44 | ✓ verified |
| RELIGIOUS ADVISER REPORT | LABELS.TXT @MISC line 45 | ✓ verified |
| LABOR ADVISER REPORT | LABELS.TXT @MISC line 64 | ✓ verified |
| ECONOMIC ADVISER REPORT | LABELS.TXT @MISC line 65 | ✓ verified |
| COLONY ADVISER REPORT | LABELS.TXT @MISC line 66 | ✓ verified |
| NAVAL ADVISER REPORT | LABELS.TXT @MISC line 67 | ✓ verified |
| FOREIGN AFFAIRS REPORT | LABELS.TXT @MISC line 108 | ✓ verified |

### `render_menu.py` — Opening main menu

| Rendered string | Source | Status |
|-----------------|--------|--------|
| COLONIZATION  Version 1.0 | GAME.TXT @BEGINMENU body line 35 (without `-- %STRING1`) | ✓ acceptable |
| Start a Game in NEW WORLD | GAME.TXT @BEGINMENU options line 37 | ✓ verified |
| Start a Game in AMERICA | GAME.TXT @BEGINMENU line 38 | ✓ verified |
| CUSTOMIZE New World | GAME.TXT @BEGINMENU line 39 | ✓ verified |
| LOAD Game | GAME.TXT @BEGINMENU line 40 | ✓ verified |
| View Hall of Fame | GAME.TXT @BEGINMENU line 41 | ✓ verified |

### `render_king.py` — Audience with the King (FONTKING)

| Rendered string | Source | Status |
|-----------------|--------|--------|
| Year of Our Lord / 1492 | GAME.TXT @VICEROY lines 205-206 | ✓ verified |
| An Audience With | GAME.TXT @VICEROY line 208 | ✓ verified |
| The King of \<COUNTRY\> | GAME.TXT @VICEROY line 209 | ✓ verified |
| The Stadtholder (Dutch) | GAME.TXT @VICEROY2 line 227 | ✓ verified |
| Body quote | GAME.TXT @VICEROY lines 211-215 | ✓ verified (wrapped to 78px parchment) |
| Position x=232, y=21, w=78 | GAME.TXT @VICEROY @x= @y= @width= | ✓ byte-cited |

### `render_dialog.py` — In-game dialog popups

| Dialog | Body source | Fix applied |
|--------|-------------|-------------|
| **king_tax** | GAME.TXT @KINGTAX line 1622 | **Fixed:** replaced made-up "His Majesty demands a 5%..." with real "It is essential that the Crown..." |
| **cherokee_attack** | GAME.TXT @WHACKINDIANS line 746 | **Fixed:** replaced made-up "Cherokee Attack" title with real {Cherokee} highlight + Yes/No options |
| **raze** | GAME.TXT @CHIEFKILL line 1320 | **Fixed:** replaced made-up "The Aztec village is destroyed" with real "You have broken sacred taboos..." |
| **diplomatic** | modeled on @HAVETREATY | ✓ acceptable (no exact GAME.TXT match) |
| **cibola** | GAME.TXT @LOSTCITY2 line 646 | ✓ verified |
| **ff_acquired** | (no exact GAME.TXT body — use FFINTRO if found) | ✓ acceptable |

### `render_map_popup.py` — Map-view event popups

All 9 popups load body text from real GAME.TXT sections via
`parse_game_txt()` — bodies are not hardcoded, ensuring the in-game
text is always exactly what the player would see.

| Popup | GAME.TXT section | WDCUT illustration |
|-------|------------------|---------------------|
| lostcity2_cibola | @LOSTCITY2 | WDCUT07 |
| lostcity1_fountain | @LOSTCITY1 | WDCUT11 |
| kingtax | @KINGTAX | KING1.SS |
| indianwar | @INDIANWAR | WDCUT13 |
| indianpeace | @INDIANPEACE | WDCUT02 |
| chiefarea | @CHIEFAREA | WDCUT07 |
| raidburn | @RAIDBURN | WDCUT12 |
| declarewar | @DECLAREWAR | WDCUT06 |
| cashtreasure | @CASHTREASURE | WDCUT04 |

---

## WOODCUT.TXT canonical labels

The 13 WDCUT*.SS sheets correspond to these labels in
`COLONIZE/WOODCUT.TXT @WOODCUT`:

| Sheet | Label |
|-------|-------|
| WDCUT01 | A NEW WORLD |
| WDCUT02 | DISCOVERY OF THE NEW WORLD |
| WDCUT03 | BUILDING A COLONY |
| WDCUT04 | MEETING THE NATIVES |
| WDCUT05 | THE AZTEC EMPIRE |
| WDCUT06 | THE INCA NATION |
| WDCUT07 | DISCOVERY OF THE PACIFIC OCEAN |
| WDCUT08 | ENTERING INDIAN VILLAGE |
| WDCUT09 | THE FOUNTAIN OF YOUTH |
| WDCUT10 | CARGO FROM THE NEW WORLD |
| WDCUT11 | MEETING FELLOW EUROPEANS |
| WDCUT12 | COLONY BURNING |
| WDCUT13 | COLONY DESTROYED |

---

## Fixes applied this session

| Renderer | Old | New | Source |
|----------|-----|-----|--------|
| `render_europe.py` | `"Recruit" "Purchase" "Train"` | `"RECRUIT" "PURCHASE" "TRAIN"` | LABELS.TXT @EUROLABEL |
| `render_colony.py` | `"No Ships in Port"` | `"No Ships In Port"` | LABELS.TXT @MISC line 26 |
| `render_nations.py` | `"(Click Here When Finished)"` | `"Click Here When Finished"` | LABELS.TXT @MISC line 176 |
| `render_dialog.py:king_tax` | made-up "His Majesty demands..." | real GAME.TXT @KINGTAX body | GAME.TXT line 1622 |
| `render_dialog.py:cherokee_attack` | made-up Yes/No title | real GAME.TXT @WHACKINDIANS | GAME.TXT line 746 |
| `render_dialog.py:raze` | made-up "Aztec village destroyed" | real GAME.TXT @CHIEFKILL | GAME.TXT line 1320 |

---

## Open items (acceptable but not byte-cited)

These render legibly but lack a direct GAME.TXT/LABELS.TXT citation:

- `render_dialog.py:diplomatic` — body modeled on @HAVETREATY but
  not a literal copy. Could be replaced with a literal
  @HAVETREATY/@SIGNTREATY/@DECLAREWAR body if needed.
- `render_dialog.py:ff_acquired` — Adam Smith Founding Father join
  message is in PEDIA.TXT (Founding Father descriptions) rather
  than GAME.TXT. Currently uses placeholder body.
- `render_score.py` stat values (Gold/Rebel Sentiment/Liberty Bells
  amounts) — these are sample numbers; in-game they are dynamic.
- `render_report.py` body content (per-report stats) — sample data;
  in-game these are computed from world state.
