# Context Menus & Action Dialogs

> **Layer 2 — UI Specification (population stub).** Primary-only per
> `/METHODOLOGY.md`. Tiers: B (`BYTE_VERIFIED`) / A (`ANCHOR_VERIFIED`) /
> R (`RECONSTRUCTED`) / `TBD`. Details TBD — breadth pass.

**Overall confidence:** option-list text **B** where the list body is captured
in `GAME_sections.json` / `NAMES_sections.json`; trigger functions **A**
(`docs/UI_DIALOGS.md`); per-dialog geometry **TBD**.
**Canonical primary:** `docs/UI_DIALOGS.md`, `data_extracted/text/NAMES_sections.json`
(`@ORDERS`/`@ACTIONS`/`@LEVELS`), `data_extracted/text/GAME_sections.json`,
`data_extracted/text/LABELS_sections.json`. **Last updated:** 2026-06-18.

## Overview — the menu-list framework

These dialogs all use the same framework `func_06F0F4` as popups — the **11**-directive parser
(`OPTIONS / PROMPT / TEXT / SMALLFONT / Y / X / WIDTH / LENGTH / CHECKBOX / DEFAULT / TEXTCOLR`
at file `0x1F967`; see `popups.md` §Overview). The `OPTIONS` directive marks an option-list
section; `@default=N` is the **highlight-row** directive (handler @0x6F374, stored to the
section struct). A section with a bare numeric first line (`@TRADENAMES` = "5\nRun\nFerry\n…")
is consumed as a menu list. Each section's **`@width=NN` is a literal pixel width** (B) — e.g.
SUREDELETE=190, SMITEINDIANS=220, ABANDON=190; bare option-lists (UNITOPTIONS/SHIPOPTIONS/
ARMOPTIONS/TRADENAMES) have no `@width` and flow through the OPTIONS path. The map-screen
pull-down bars are the verbatim `MENU_sections.json` tables, distinct from these context
popups. **B** (framework + `@width` + list bodies) / **A** (trigger fns).

## Unit jobs / orders menu
- **Purpose:** issue movement/work orders to the selected unit.
- **Option lists (B):** `GAME @UNITOPTIONS` ("Move to front. / Clear orders. /
  Sentry / Board ship. / Fortify. / No changes.", **B**); ship variants
  `@SHIPOPTIONS`, `@EUROPESHIPOPTIONS` (full bodies, **B**); arm/equip list
  `@ARMOPTIONS` (Muskets/Tools/Horses/Missionary toggles, **B**). The
  short-code order table is `NAMES @ORDERS` (No Orders/Sentry/Trade Route/Go To/
  Live In Village/Fortify/Build Colony/Clear-Plow/Build Road, **B**). The
  in-game ~ORDERS menu bar is `MENU @ORDERS` (**B**).
- **Trigger:** unit-orders popup sets `[0x1f5e]` advisor channel
  (`func_021EDE`, `docs/POPUP_TEMPLATE_AUDIT.md`). **A.**
- **Tier:** list bodies **B**.

## Trade-route setup
- **Purpose:** create / edit / delete a trade route.
- **Lists (B):** `GAME @TRADENAMES` ("5\nRun\nFerry\nCargo\nTransport\nTriangle",
  **B**); route keys `@TRADESTART`, `@TRADETYPE`, `@TRADENAME`, `@TRADESELECT`,
  `@TRADEDELETE`, `@SUREDELETE`, `@CARGOLOAD`, `@CARGOUNLOAD`, `@ROUTELOOP`,
  `@TRADENONE`, `@TRADEMANY` (**B**, bodies empty in dump). Editor labels
  `LABELS @ROUTE` ("EDIT TRADE ROUTE / Route Name: / Route Type: / Sea / Land /
  Destination / Unload Cargo / Load Cargo / (Delete Destination)", **B**).
  Menu bar `MENU @TRADE` (Edit/Create/Delete Trade Route, **B**).
- **Tier:** **B**.

## Native-village interaction (10 actions)
- **Purpose:** the action menu when a unit enters a native settlement.
- **Action list (B):** `NAMES @ACTIONS` — the 10 lines:
  "Trade With Village / Enter Hostile Village / Establish Mission /
  Denounce Heresy of %Fs Mission / Live Among The Natives /
  Ask to Speak With Chief / Incite Indians / Demand Tribute / Attack Village /
  Cancel Action". **B** (full body verbatim).
- **Outcome keys (B):** `GAME @CHIEFHOWDY/@CHIEFGUIDES/@CHIEFAREA/@CHIEFGIFT/
  @CHIEFBORED/@CHIEFKILL`, learn `@LEARNMASTER/@LEARNSTAY/@LEARNSLOW/@LEARNDONE`,
  mission `@MISSION0..3`, `@LIVE`-related. Handler `func_04A7CA` (CHIEFHOWDY) +
  the speaker uses `IND<tribe>` via `[0x1f5c]` (`docs/KING_AND_CINEMATIC_AUDIT.md`
  §6). **A.**
- **Per-row gating — RESOLVED 2026-06-21 (B).** *(Correction: `0x74FC4` is the NAMES string-table
  loader, not the menu builder.)* The action menu is built by **`func_04B308`** (`enter 0xba`),
  the sole consumer of the `@ACTIONS` label array (DGROUP `0x932A`, +2/row). Inputs: UnitRecord
  `0x3146` stride 0x1C (type@+0; `@UNIT` codes 3=Missionary, 5=Scout); current village `[0x8D4A]`;
  tribe→player **alarm** via `func_0082A0`; row-add `lcall 0x191F:0x176` (arg 1/2 = enable). Each
  row's show/enable predicate (all B):
  - **r0 Trade / r1 Enter Hostile** (`@0x4B664`) — mutually exclusive on **alarm < 0x4B (75)**
    (`<75`→Trade, else Hostile).
  - **r2 Establish Mission** — unit type==3 AND village mission `[+5] < 0` (none present).
  - **r3 Denounce Heresy** — mission present (`[+5]≥0`) AND foreign owner (`[+5]&0xF ≠ self`).
  - **r4 Live Among** — player-relation ≥0 AND tribe-record `[+0x5236] < 2` AND not Scout.
  - **r5 Speak With Chief** — unit type==5 (Scout).
  - **r6 Incite / r7 Demand Tribute** — tribe-record `[+0x5236] ≠ 0` (tribute also excludes
    ships 0xD–0x12).
  - **r8 Attack** — tribe-record `[+0x5236] > 1`. **r9 Cancel** — always.
- **Tier:** action list **B**; per-row gating **B**.

## Colonial-authority (build / abandon / rename)
- **Purpose:** found, abandon, or rename a colony.
- **Keys (B):** build prompt `GAME @COLONY` ("What shall we name this colony?",
  **B**); rename `@RENAMECOLONY` ("What shall we rename this colony?", **B**);
  abandon `@ABANDON`, `@ABANDON2`, `@default=2` (the "Shall we indeed {abandon}
  our %STRING0 colony…" confirm body, **B**). Site warnings `@TOONEAR`,
  `@TOONEARBUILD`, `@TOOMOUNTAIN`, `@NOPORT`, `@SEACOLONY` (**B**). Build-order
  menu bar `MENU @ORDERS` "Build Colony". **B.**
- **Tier:** **B**.

## Diplomatic choices (war / peace / treaty / SMITE)
- **Purpose:** the diplomatic-action menu vs another European power.
- **Option keys (B):** `GAME @CANCELPEACE`, `@SIGNTREATY`, `@DECLAREWAR`,
  `@HAVETREATY`, `@WHACKINDIANS`, `@SMITEINDIANS`, `@SMITEEUROPE`,
  `@ALREADYSMITE`, `@NOCONTACT` (**B**, bodies empty). Demand/threat bodies
  `@WANTSTUFF` (full body present, **B**), `@THREATS`, `@GIFTS`, `@MILITARY`,
  `@PROVOKE`, `@WARMEEK`, `@WARMANLY`, `@PEACEMEEK`, `@PEACEMANLY`. Handler:
  diplomatic-actions menu `func_03ECF0`, SMITE `func_057F4E`
  (`docs/UI_DIALOGS.md`). **A.**
- **Tier:** keys **B**.

## Recruitment
- **Purpose:** recruit a waiting immigrant from the docks (Europe).
- **Keys (B):** `GAME @RECRUIT`, `@RECRUIT2`, `@RECRUITCHOOSE`, `@KINGRECRUIT`
  (**B**). Recruit-pool classes `NAMES @CLASS` (Petty Criminals 300 …
  Educated Elite 2000, **B**). Europe button label `LABELS @EUROLABEL`
  "RECRUIT" (**B**).
- **Tier:** keys **B**; pool-cost table **B**.

## Purchase-unit
- **Purpose:** buy a unit/ship from Europe.
- **Keys (B):** `GAME @PURCHASE`, `@REALLYBUY`, `@BUYME0`, `@BUYME1`,
  `@PICKACARGO` (**B**). Button `LABELS @EUROLABEL` "PURCHASE" (**B**). Unit
  catalog `NAMES @UNIT` (Caravel/Merchantman/Galleon/Artillery/… with stats,
  **B**).
- **Tier:** keys **B**; unit table **B**.

## Training / school
- **Purpose:** train a colonist into a specialist (schoolhouse/college/univ).
- **Keys (B):** `GAME @SCHOOL1`, `@COLLEGE2`, `@UNIV3`, `@NOTEACHER`,
  `@NEEDCOLLEGE`, `@NEEDUNIVERSITY`, `@TRAINFAIL`, `@TRAINCRIMINAL`,
  `@TRAININDENTURED`, `@TRAINPROFESSION`, `@TEACHCONVERT` (**B**, bodies empty).
  Profession list `NAMES @JOB` (Farmer/Sugar Planter/… with skill tier + cost,
  **B**). Build-cost row `LABELS @CTITLE` "Select a Profession for". Button
  `LABELS @EUROLABEL` "TRAIN" (**B**).
- **Tier:** keys **B**; profession table **B**.

## Construction-choice (colony build menu)
- **Purpose:** pick what a colony builds next.
- **Labels (B):** `LABELS @CTITLE` "Select An Item To Build / (No Production) /
  (More) / Turns) / CHANGE / BUY" (**B**). Building catalog `NAMES @BUILDING`
  (Stockade 64 … Iron Works, with hammer/tool/size costs, **B**; also captured
  in `docs/SESSION_UI_CATALOG.md` §2 build-menu). Completion-buy confirm
  `GAME @default=1` ("Cost to complete %STRING0…", **B**). Wagon-cap warning
  `GAME @width=190` (**B**).
- **Availability — RESOLVED 2026-06-21 (B).** Menu fn **`func_02B4D2`** ("Select An Item To
  Build" = `@CTITLE[4]`), paginated, filters each slot via `func_0BB98` → predicate
  **`func_0B900`** (`[bp-0x12]=1` default-buildable). Gates: **colony-size** (`@0xB940`:
  `min_colony[entry-0x7076] > colony_pop[+0x1F]` ⇒ not buildable); **prereq-built** (entry+3
  must be built, entry+2 built ⇒ superseded) via built-bitmap; **already-built / single-instance**
  tail (`@0xBB39`, per-building meta `[+0x3146]`); plus a few index special-cases (terrain
  adjacency, colony flag `[+0x1C]&0x40`, per-nation capability). Built-bitmap **`func_0860E`**:
  `[colony·0xCA + 0x5DCA]` bit `idx&7` — **re-confirms CLAUDE.md hard rule #8 (ColonyRecord
  stride 0xCA)**. Residual R: the entry+2/+3 prereq-building *indices* aren't a visible NAMES
  comma column (data-table decode).
- **Tier:** building table **B**; availability predicate **B** (prereq index data R).

## Evidence
- `data_extracted/text/NAMES_sections.json` — `@ORDERS` (order codes),
  `@ACTIONS` (10 village actions), `@CLASS`, `@JOB`, `@UNIT`, `@BUILDING`,
  `@LEVELS`. **B**.
- `data_extracted/text/GAME_sections.json` — `@UNITOPTIONS`, `@SHIPOPTIONS`,
  `@EUROPESHIPOPTIONS`, `@ARMOPTIONS`, `@TRADENAMES`, `@COLONY`,
  `@RENAMECOLONY`, `@default=1`, `@default=2`, diplomatic + recruit/purchase/
  train keys. **B**.
- `data_extracted/text/LABELS_sections.json` — `@ROUTE` (trade-route editor),
  `@CTITLE` (build dialog), `@EUROLABEL` (Recruit/Purchase/Train),
  `@INFO`. **B**.
- `data_extracted/text/MENU_sections.json` — `@ORDERS`, `@TRADE`, `@VIEW`
  in-game menu bars. **B**.
- `docs/UI_DIALOGS.md` — trigger functions `func_03ECF0` (diplomatic menu),
  `func_057F4E` (SMITE), `func_04A7CA` (village), `func_049600` (haggle). **A**.
- `docs/POPUP_TEMPLATE_AUDIT.md` — `func_021EDE` unit-orders advisor channel,
  `func_06F0F4` option-list framework. **A**.

## Open questions (TBD)
*(Resolved 2026-06-21: per-section `@width` (B); "empty-body" keys = `GAME_sections.json`
extraction defect (bodies full in `raw/COLONIZE/GAME.TXT`); **native-action row gating** =
`func_04B308` per-row predicates (B, §Native-village); **build availability** = `func_0B900`
pop+prereq gates (B, §Construction-choice). All struck.)*

1. ~~Final option-list pixel rect / highlight RGB.~~ **RESOLVED — static (B):** the rect is
   `@width` + `@x`/`@y` (or centered), not cursor-dependent; the `@default`/highlight palette
   index resolves to exact RGB via the loaded PIK palette (`fonts_and_colors.md`). No runtime.
2. The construction prereq-building **indices** in the in-memory `@BUILDING` record (entry+2/+3)
   aren't a visible NAMES column — a small data-table decode (**R**), not a missing function.
