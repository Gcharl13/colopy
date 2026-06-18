# Main-Menu & Setup Screens

> **Layer 2 — UI Specification (population stub).** Primary-only per
> `/METHODOLOGY.md`. Tiers: B (`BYTE_VERIFIED`) / A (`ANCHOR_VERIFIED`) /
> R (`RECONSTRUCTED`) / `TBD`. Details TBD — breadth pass.

**Overall confidence:** screen→PIK asset mapping **A** (`docs/SESSION_UI_CATALOG.md`,
visual ID); the menu-item text and option lists are partly **B** (verified in
`MENU_sections.json` / `LABELS_sections.json`), partly **TBD** (main-menu item
list not found as a single menu section). **Canonical primary:**
`data_extracted/text/MENU_sections.json`, `data_extracted/text/LABELS_sections.json`,
`docs/SESSION_UI_CATALOG.md`. **Last updated:** 2026-06-18.

## Overview — the menu framework

The setup flow is a sequence of **full-screen PIK backgrounds**, each with a
small number of clickable wood-framed plaques, driven by `OPENING.EXE` /
VICEROY startup before the map loads. Backgrounds are 320×200 mode-13h PIKs,
all visually identified in `docs/SESSION_UI_CATALOG.md`:
`OPENING.PIK` (title), `OPENMENU.PIK` (main menu), `CUSTOMIZ.PIK`,
`DIFFICUL.PIK`, `NATIONS.PIK`. The in-game pull-down menus (GAME / VIEW /
ORDERS / REPORTS / TRADE / CHEAT / COLONIZOPEDIA) are separate and live in
`MENU_sections.json` (those are the map-screen menu bars, not the boot menu).

> Note: the **main-menu item list** (New / Load / Hall of Fame / Quit) is **not**
> present as a discrete section in `MENU_sections.json` (which holds the in-game
> menu bars). Individual labels are sourced from `GAME_sections.json`
> (`@RETIRE`, `@DOSYES`) and `LABELS @MISC` ("COLONIZATION HALL OF FAME"). The
> exact boot-menu option strings are **TBD**.

## Main menu
- **Purpose:** entry choices after the title screen.
- **Background:** `OPENMENU.PIK` over `OPENING.PIK`, decorative `OPENBORD`. **A**
  (`docs/SESSION_UI_CATALOG.md`).
- **Items:** New game / Load game / Hall of Fame / Quit (function per manual,
  **R**). Verified label fragments: `LABELS @MISC` "COLONIZATION HALL OF FAME"
  (**B**); exit-to-DOS confirm `GAME @DOSYES` ("Exit to DOS?\nYes\nNo", **B**).
  The in-game `MENU @GAME` list ("Save Game / Load Game / DECLARE INDEPENDENCE /
  Retire / Exit to DOS") is the *map* menu, not the boot menu (**B**).
- **Tier:** background **A**; item set **R/TBD**.

## New-game options (world type / difficulty / nationality / name)
- **Purpose:** the ordered new-game setup wizard.
- **Flow (A, `docs/UI_DIALOGS.md` screen list):** Customize world →
  Difficulty select → Nation select → leader name entry. Land-naming /
  leader-name prompts: `GAME @LEADERNAME`, `GAME @LANDHO` /
  "@default=America" ("Land Ho! What shall we call this new land…", **B**).
- **Tier:** flow **A**; per-field detail in sections below.

## Customize world (land / moisture / climate)
- **Purpose:** tune the generated map before play.
- **Background:** `CUSTOMIZ.PIK`. **A.**
- **Labels (B, `LABELS @MISC`):** "CUSTOMIZE NEW WORLD",
  "Click Here When Finished"; axes "Land Mass", "Land Form", "Temperature",
  "Climate"; values **Land Mass** Small/Moderate/Large; **Land Form**
  Archipelago/Continents (label shows "Normal/Continents"); **Temperature**
  Cool/Temperate/Warm; **Climate** Arid/Normal/Wet. The in-popup help keys
  `GAME @CLAND`, `@CCONT`, `@CTEMP`, `@CCLIM` exist (**B**, bodies empty in dump).
- **Tier:** labels **B**; control geometry **TBD**.

## Difficulty select
- **Purpose:** choose the difficulty level (also sets AI aggression).
- **Background:** `DIFFICUL.PIK` (5 conquistador figures). **A.**
- **Levels (B):** `NAMES @DIFFICULTY` = Discoverer / Explorer / Conquistador /
  Governor / Viceroy (in order). `LABELS @MISC` also carries the prompt
  "Choose / Difficulty Level / Level" and rank words
  Easiest/Easy/Moderate/Tough/Toughest (**B**). The `GAME @DIFFICULTY` key
  exists (**B**, body empty).
- **Tier:** level names **B**.

## Nationality / leader select
- **Purpose:** pick the European power and named leader.
- **Background:** `NATIONS.PIK` (4 flag plaques). **A.**
- **Powers (B):** `NAMES @COUNTRY` = England / France / Spain / Netherlands;
  `@NATIONALITY` = English/French/Spanish/Dutch; `@HOMEPORT` =
  London/La Rochelle/Seville/Amsterdam; `@COLONYNAME`; default leaders
  `@LEADERNAME` = Walter Raleigh / Jacques Cartier / Christopher Columbus /
  Michiel De Ruyter. `LABELS @MISC` "Select / European Power / Power" +
  play-style words Immigration/Cooperation/Conquest/Trade (**B**). Picker keys
  `GAME @PICKNATION`, `@PICKACARGO` exist (**B**, body empty). Per-nation flavor
  `GAME @NATION0A/0B..3A/3B` (**B**, empty).
- **Tier:** power/leader data **B**; layout **TBD**.

## Save dialog (10 slots)
- **Purpose:** write the game to one of the save slots.
- **Keys (B):** `GAME @SAVEGAME`, `@SAVEGOOD`, `@SAVEERROR` (all present, bodies
  empty in dump). Manual: 10 slots (**R** — slot count not byte-verified here).
- **Tier:** keys **B**; 10-slot count **R/TBD**.

## Load dialog
- **Purpose:** restore a saved game.
- **Keys (B):** `GAME @LOADGAME`, `@LOADGOOD`, `@LOADNOT`, `@LOADOLD`,
  `@LOADSIZE`, `@LOADERROR` (present, bodies empty). Map-load `@MAPTOLOAD`.
- **Tier:** keys **B**; slot layout **TBD**.

## Hall of Fame
- **Purpose:** high-score / retired-leader roster.
- **Title (B):** `LABELS @MISC` "COLONIZATION HALL OF FAME"; columns from
  `@MISC`: "President", "General, Continental Army", "Leader", "Score",
  "Colonization_Rating", "A.D." (**B**). Retirement keys `GAME @RETIRE`,
  `@RETIRING`, `@RETIRING2`, `@SOONRETIRING0/1` (**B**, bodies empty).
- **Background/geometry:** **TBD** (no dedicated Hall-of-Fame PIK identified in
  `docs/SESSION_UI_CATALOG.md`).
- **Tier:** title/columns **B**; layout **TBD**.

## Scenario select (adjacent)
- **Purpose:** choose a preset scenario map (custom-scenario path).
- **Assets (A):** `LEVN0001..LEVN0010.PIK` thumbnails
  (`docs/SESSION_UI_CATALOG.md`, `docs/UI_DIALOGS.md`). Scenario data
  `NAMES @SCENARIO` (AMER2 / AMERICA, **B**).
- **Tier:** thumbnails **A**; selection geometry **TBD**.

## Evidence
- `data_extracted/text/MENU_sections.json` — in-game menu bars `@GAME @VIEW
  @ORDERS @REPORTS @TRADE @CUP @PEDIA` (full text). **B**.
- `data_extracted/text/LABELS_sections.json` `@MISC` — "CUSTOMIZE NEW WORLD",
  difficulty/temperature/climate/land-form value words, "Select European Power",
  "COLONIZATION HALL OF FAME" + columns. **B**.
- `data_extracted/text/NAMES_sections.json` — `@DIFFICULTY`, `@COUNTRY`,
  `@NATIONALITY`, `@HOMEPORT`, `@LEADERNAME`, `@SCENARIO`. **B**.
- `data_extracted/text/GAME_sections.json` — `@SAVEGAME @LOADGAME @PICKNATION
  @DIFFICULTY @LEADERNAME @RETIRE @DOSYES @LANDHO @CLAND @CCONT @CTEMP @CCLIM`. **B**.
- `docs/SESSION_UI_CATALOG.md` — `OPENING/OPENMENU/CUSTOMIZ/DIFFICUL/NATIONS/LEVN*`
  PIK visual identification. **A**.

## Open questions (TBD)
1. **Boot main-menu item strings** — locate the New/Load/Hall-of-Fame/Quit menu
   section (likely baked into `OPENMENU.PIK` or an OPENING.EXE string table).
2. **Save/load slot count** — confirm 10 slots and slot-name layout by tracing
   the save/load dialog handler.
3. **Hall-of-Fame background + row geometry.**
4. **Customize-world control widget geometry** (sliders/plaques) per axis.
