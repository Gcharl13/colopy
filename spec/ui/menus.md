# Main-Menu & Setup Screens

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers:
> B (`BYTE_VERIFIED`) / A (`ANCHOR_VERIFIED`) / R (`RECONSTRUCTED`) / `TBD`.
> Substantive: boot-menu items, plaque framework geometry, Hall-of-Fame layout + record I/O, and
> screen→background names are **B**; setup-screen backgrounds **A**. Residuals: save/load slot
> count (R/TBD — overlay file-list, no `MAX_SAVE` constant) and the per-axis setup-widget /
> LEVN-thumbnail hit-rects (R, pixel-measured from the committed PIK PNGs — §6).

**Overall confidence:** boot-menu items now **B** (GAME.TXT `@BEGINMENU @options`, matched
to the 1–5 dispatch); menu-plaque framework geometry **B** (`menu_run_key`/`mr_finalize_geometry`
constants); Hall-of-Fame layout + record I/O **B** (raw-verified); screen→background base-names
**B** (literal EXE strings, upgrading the prior luma IDs). · **Canonical primary:**
`ghidra_export/VICEROY_decompiled.named.c` (boot dispatch 52193, menu framework 48237–48663,
HoF 24990–25147), `raw/COLONIZE/{VICEROY.EXE,GAME.TXT}`. **Last updated:** 2026-06-21.

> **Corrections (2026-06-21):** (a) the boot-menu item strings are **not** "baked into
> OPENMENU.PIK / OPENING.EXE" — they are **GAME.TXT `@BEGINMENU @options`** (5 lines, read by
> `mr_load_section`), matched 1:1 to the live 5-way dispatch at export line **52193**
> (`title_screen_update`'s switch is a stub). (b) The Hall of Fame has **no PIK** — it draws on
> the procedural **WOODPANL/WOODPAN2** wood panels; the old "no HoF PIK → geometry TBD" is
> resolved.

## Overview — the menu framework

The setup flow is a sequence of **full-screen PIK backgrounds**, each with a
small number of clickable wood-framed plaques, driven by `OPENING.EXE` /
VICEROY startup before the map loads. Backgrounds are 320×200 mode-13h PIKs,
all visually identified in `docs/SESSION_UI_CATALOG.md`:
`OPENING.PIK` (title), `OPENMENU.PIK` (main menu), `CUSTOMIZ.PIK`,
`DIFFICUL.PIK`, `NATIONS.PIK`. The in-game pull-down menus (GAME / VIEW /
ORDERS / REPORTS / TRADE / CHEAT / COLONIZOPEDIA) are separate and live in
`MENU_sections.json` (those are the map-screen menu bars, not the boot menu).

> **Boot-menu item list — RESOLVED (B):** the five items live in **GAME.TXT `@BEGINMENU`**
> under its `@options` directive (`@width=160 @y=91`): "Start a Game in NEW WORLD" /
> "Start a Game in AMERICA" / "CUSTOMIZE New World" / "LOAD Game" / "View Hall of Fame". Read
> by `mr_load_section("BEGINMENU")` and dispatched 1–5 at export line 52193 (`menu==2` opens
> the `@AMERICA` "Original Americas / Map Editor" sub-picker `menu_run_boxed(0x234F)`). The
> JSON section dump shows the body empty, but **`raw/COLONIZE/GAME.TXT` lines 31–42** carry it
> verbatim (re-verified this pass).

## Menu-plaque framework geometry — **B** (`mr_finalize_geometry`, export 48376)
All wood-plaque menus (boot + setup + in-game bars) share this layout engine; constants at
export 48237–48245: BORDER=3, INSET=2, GAP=3, MIN_W=80, LINE_MARGIN=10. `w = max(80,
longest+10, @width) + 6`; row pitch = `font.maxh + 3`; `x = (@x==-1)? (320-w)/2 : @x`,
`y = (@y==-1)? (200-h)/2 : @y` (so `@BEGINMENU` pins y=91, centered x, width ≥160); text
origin (x+4, y+5). Panel fill = **WOODTILE.SS** tiled. Nav: ENTER 13 / ESC 27 / SPACE 32 /
arrows / digit + first-letter hotkeys. **B**.

**Fonts & colors (B):** the four plaque colors are passed as **direct RGB** through
`mr_color_for(r,g,b)` (export 48464), which scans the live palette for the nearest entry — they
are design-intent RGBs, not palette-index pushes: outline **(20,12,6)**, selection bar
**(56,32,16)**, text green **(82,138,49)**, selected gold **(227,170,40)** (gold hits OPENMENU
idx `0x54` exactly). **Boot-menu body font = the latched font (FONTINTR/FONTTINY)** — the
`@BEGINMENU` section's `@smallfont` directive sets `m->smallfont=1` (`mr_load_section`), but
**FONTSMAL.FF is never loaded** by VICEROY.EXE (RULING 2026-06-21), so `@smallfont` selects no
distinct font; the body renders in the active latch (A — the exact metric effect of the flag is
not byte-pinned). *(Correction to an earlier claim that this was "FONTSMAL".)*

## Main menu
- **Purpose:** entry choices after the title screen.
- **Background:** `OPENMENU.PIK` over `OPENING.PIK`, decorative `OPENBORD`. **A**
  (`docs/SESSION_UI_CATALOG.md`).
- **Background:** **OPENMENU** (literal EXE string @0x1FCDC; handle `BG_BOOT=0x233C`); plaque
  rendered over it via the framework above. **B**
- **Items (B):** the 5 `@BEGINMENU @options` lines (New World / America / Customize / Load /
  Hall of Fame), dispatched 1–5 at export 52193. The in-game `MENU @GAME` list is a *separate*
  map menu. **B**
- **Tier:** background **B**; item set **B**.

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
- **Background/geometry + font/color — RESOLVED (B):** there is **no HoF PIK** —
  `hall_of_fame_render` (export 25037, `@file 0x3ACB2`) draws on the procedural **WOODPAN2**
  (render screen, handle 0x11D7) / **WOODPANL** (table screen) wood panels. Font = **FONTINTR**
  (`push [0x268A]` @0x22ABE/0x23C06 — *not* FONTKING, which loads only in king-defeats; RULING
  2026-06-21).
  Colors resolve via **WOODPAN2.PIK** (*not* WOODPANL — there 0xFC is magenta): title at
  (0x8C,0x8E) color **`0xFC`→(199,162,32) gold** (sprite 0x22); score/rating bars x=0xA0,
  `y=0xC3−(i+1)`, color `0xFC` gold when `i==rating` else `0xFE`; full-screen rule
  `box_rule(0,0x140,0xC8)`; trophy sprite **0x24** (rating≥0x17) / **0x21** (≤6) / **0x25** (else)
  — all byte-verified `@0x3AC37..0x3AD6A`. Table rows (`hall_of_fame_table`): start y=0x10, x=0x0A,
  pitch 10. **B**.
- **Record I/O — B (raw-verified, `@file 0x3ADA6`):** `HALLFAME.DAT`, `fread/fwrite` size
  **0xD2 (210)** = 5 records × **0x2A (42)**; buffer holds 6 slots, file holds 5; **score =
  int16 @ record +0x26**, descending insertion-sort. (Cross-ref `spec/systems/save.md` §6.5.)
- **Tier:** title/columns/layout/record-I/O **B**.

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
*(Resolved 2026-06-21: boot-menu item strings = GAME.TXT `@BEGINMENU @options`; Hall-of-Fame
background+geometry = procedural WOODPAN2/WOODPANL + the row literals above. Both struck.)*

1. **Save/load slot count** — the save/load picker (`page1A_file_pick`) is a **file-list
   dialog** (glob `*.MP`), overlay-resident; there is **no `MAX_SAVE`/10 array constant** in
   any decompiled body. The manual's "10" may be a save-name limit, not a code array. Stays
   **R/TBD** (overlay code not in the export).
2. **Customize / difficulty / nationality per-axis widget geometry** — the generic plaque
   geometry is known (above), but the slider / flag-plaque hit-rects are drawn by the
   overlay handlers (`191F:087A` Customize, `PICKNATION`/`DIFFICULTY`) not in the export. **TBD**.
3. **Scenario-select (LEVN*.PIK) thumbnail-grid geometry** — no decompiled body touches the
   LEVN thumbnails. **A (assets) / TBD (geometry)**.
