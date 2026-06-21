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
- **Menu builder located (B for "where"):** the 10-row `@ACTIONS` list is referenced exactly
  once — `push 0x2264 @file 0x74FC4` — the village-action menu builder (`0x74Fxx`). The per-row
  **show/enable predicates** (unit type = scout/missionary/military; tribe attitude;
  mission-present) are computed there but not yet traced row-by-row. **TBD** (byte-traceable in
  `0x74Fxx`, *not* runtime-R).
- **Tier:** action list **B**; per-row gating **TBD**.

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
- **Tier:** building table **B**; per-colony availability logic **TBD**.

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
*(Resolved 2026-06-21: per-section `@width` is a literal pixel width (B); the "empty-body" keys
are a `GAME_sections.json` extraction defect — bodies (SHIPOPTIONS/ARMOPTIONS/SUREDELETE/
SMITEINDIANS …) are present and full in `raw/COLONIZE/GAME.TXT`, so re-extracting the JSON is
mechanical, source **B**.)*

1. **Native-action row gating** — the builder is located (`@ACTIONS` ref @0x74FC4); the per-row
   show/enable predicates are **TBD** (byte-traceable in `0x74Fxx`, not runtime).
2. **Per-colony build availability** — which buildings the construction list offers depends on
   prerequisite + colony-size + already-built; a **state-machine over ColonyRecord**, not a
   static table — so **TBD (B-with-effort)**, not R.
3. **Final option-list pixel rect / highlight RGB** — `@width` + `@default` row are **B**; the
   composed rect (runtime cursor + layout loop `0x0684BC`) and the highlight palette color are
   **A/R** (runtime).
