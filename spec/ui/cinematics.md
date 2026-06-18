# End-Game & Cinematic Screens

> **Layer 2 — UI Specification (population stub).** Primary-only per
> `/METHODOLOGY.md`. Tiers: B (`BYTE_VERIFIED`) / A (`ANCHOR_VERIFIED`) /
> R (`RECONSTRUCTED`) / `TBD`. Details TBD — breadth pass.

**Overall confidence:** asset names + endgame argument matrix **A/B**
(`docs/KING_AND_CINEMATIC_AUDIT.md`, disasm-cited `func_075352`); per-frame
animation timing in OPENING.EXE/CLOSING.EXE **TBD**.
**Canonical primary:** `docs/KING_AND_CINEMATIC_AUDIT.md`,
`data_extracted/text/OPENING_sections.json`,
`data_extracted/text/CLOSING_sections.json`, `data_extracted/text/GAME_sections.json`.
**Last updated:** 2026-06-18.

## Overview — cinematic engine split

Three distinct binaries paint cinematics:
- **OPENING.EXE** — title / boot demo (`OPENING.PIK` + `OPEN*.SS` sprites,
  sequenced by `OPENING_sections.json @OPENING`).
- **VICEROY.EXE** — in-game endgame (King-defeats screen `func_075352`,
  score screen `func_03A9C0`, Declaration `func_03DA2A`).
- **CLOSING.EXE** — closing credits / retirement (`CLOS-BKG.PIK` + `CLOS-*.SS`,
  sequenced by `CLOSING_sections.json @CLOSING`).

Each cinematic-script section is a CSV table of `(sprite_idx, frame, ...)`
rows (byte-verified format in the JSON dumps). King-text overlays use GAME.TXT
keys with explicit `@x` / `@y` / `@width` directives. **A/B**.

## King-defeats screen (KINGLSS1/2.PIK)
- **Purpose:** revolution conclusion — King mocked (player wins) or triumphant
  (player loses).
- **Painter:** `func_075352` (file `0x075352..0x075593`, 578 bytes), tagged
  "KINGLSS","ENGLND","FRANCE". **B** (disasm-cited in
  `docs/KING_AND_CINEMATIC_AUDIT.md` §5).
- **Argument matrix (B):** background `KINGLSS<N>.PIK` where `N=bp+6` (1 or 2);
  nation art `ENGLND/FRANCE/SPAIN/DUTCH` + `N` from `[0x5398]`; King sprite:
  `bp+6=1,bp+8=1`→`KING1.SS`; `bp+6=1,other`→`KINGLOSE.SS` (king crying =
  **player WINS**, `@KINGLOSE`); `bp+6=2`→`KINGWIN.SS` (king triumphant =
  **player LOSES**, `@KINGWIN`).
- **Text (B):** `GAME @KINGLOSE` (`@width=68 @x=232 @y=31`, body
  "…let you go your own way…") and `GAME @KINGWIN` (`@width=90 @x=202 @y=125`,
  body "…Rag Tag armies are simply no match…"). Both bodies + geometry verified
  in GAME_sections.json. **B.**
- **Tier:** **B**.

## Score screen (SCORE01-24.SS)
- **Purpose:** end-of-game score breakdown, one illustrated plate per category.
- **Painter:** `func_03A9C0` (score-screen renderer) — referenced in
  `docs/SESSION_UI_CATALOG.md`; per-line plate mapping **TBD** (needs disasm).
- **Assets (A):** 24 plates `SCORE01..SCORE24.SS`, all visually identified
  (`docs/SESSION_UI_CATALOG.md`). **A.**
- **Text (B):** title + category words in `LABELS @MISC` "COLONIZATION SCORE":
  "Citizens", "Independence", "Villages Burned", "Foreign Recognition",
  "Total Score", "SCORING COMPLETE", "SCORE COMPLETE". Naming-honor flavor
  `GAME @EXPLOITS` ("COLONIZATION RATING: …") + `@SCORE` (the 24-line
  honor-list, body present, **B**). `@SCORED` key exists (**B**, empty).
- **Tier:** assets **A**; plate→category map **TBD**; text **B**.

## Opening cinematic (OPENING.PIK)
- **Purpose:** title screen / boot demo (old-style world map with sea monsters).
- **Engine:** OPENING.EXE (separate exe; loads `AMERICA.MOV` script per
  `docs/KING_AND_CINEMATIC_AUDIT.md` §5). **A.**
- **Script (B):** `OPENING_sections.json @OPENING` — CSV of
  `(sprite, frame, layer, width)` rows commented Wind/Sun/Monster1-3/Fish/
  "Bonk into land"/"Guy getting out"/"Opening logo"/"END OF DEMO". `@CREDITS`
  section = credit-roll timing rows. **B** (table present verbatim).
- **Assets (A):** `OPENING.PIK` bg + `OPEN*` sprites (OPENLOGO, OPENBORD,
  OPENGUY, OPENSHIP, OPENFISH, OPENSUN, OPENMON1-3, OPENWND1-2, OPENCRD1-3,
  OPENTILE, OPENBONK) per `docs/SESSION_UI_CATALOG.md`.
- **Tier:** script **B**; assets **A**; exact frame timing **TBD**.

## Closing cinematic (CLOS-BKG.PIK / CLOS-*.SS)
- **Purpose:** end credits / retirement celebration (Liberty Bell, fireworks).
- **Engine:** CLOSING.EXE (separate exe; only references `CONFIG.COL`). **A.**
- **Script (B):** `CLOSING_sections.json @CLOSING` — CSV rows commented
  Fireworks / Liberty Bell / Rock / Hat / Lady / Man / Military / "End of
  closing". **B** (table present verbatim).
- **Assets (A):** bg `CLOS-BKG.PIK`; sprites `CLOS-FWK` (fireworks),
  `CLOS-BEL` (Liberty Bell), `CLOS-ROC`, `CLOS-HAT`, `CLOS-LDY`, `CLOS-MAN`,
  `CLOS-MIL` per `docs/SESSION_UI_CATALOG.md` / `docs/KING_AND_CINEMATIC_AUDIT.md`.
- **Tier:** script **B**; assets **A**; frame timing **TBD**.

## Declaration of Independence (adjacent, VICEROY.EXE)
- **Purpose:** the signing cinematic + printed-document screen.
- **Painters (B):** `func_03DA2A` (DECOIND.PIK signing scene, disasm-cited);
  `DECLARAT.PIK` printed-document scene (loader **TBD**).
  `docs/KING_AND_CINEMATIC_AUDIT.md` §5.
- **Assets (A):** `DECOIND.PIK`, `DECLARAT.PIK` backgrounds; signature drawn from
  `DEC-LOWA..Z` + `DEC-UPPA..Z` + `DEC-SQIG` cursive-letter sprites (53).
- **Tier:** DECOIND painter **B**; DECLARAT loader **TBD**.

## KINGWIN / KINGLOSE sprite roles (reference)
- `KINGLOSE.SS` = king crying (player won the Revolution); `KINGWIN.SS` = king
  triumphant (player lost); `KING1.SS` = mocking king + bound colonist sub-variant.
  Naming is inverted vs game outcome (`docs/KING_AND_CINEMATIC_AUDIT.md` §5). **B**.
  `KING2.SS` (8-frame arm-raise animation) loader site **TBD** (§7).

## Evidence
- `docs/KING_AND_CINEMATIC_AUDIT.md` — `func_075352` argument matrix (KINGLSS,
  nation art, KINGWIN/LOSE/KING1), `func_03DA2A` (DECOIND), `func_037340`
  (REPORT loader), GAME.TXT `@KINGLOSE`/`@KINGWIN` geometry, OPENING/CLOSING exe
  split. **B/A**.
- `data_extracted/text/OPENING_sections.json` — `@OPENING`, `@CREDITS`,
  `@MESSAGES` script tables. **B**.
- `data_extracted/text/CLOSING_sections.json` — `@CLOSING`, `@MESSAGES` script
  tables. **B**.
- `data_extracted/text/GAME_sections.json` — `@KINGLOSE` (`@width=68 @x=232
  @y=31` + body), `@KINGWIN` (`@width=90 @x=202 @y=125` + body), `@EXPLOITS`,
  `@SCORE`. **B**.
- `data_extracted/text/LABELS_sections.json` `@MISC` — "COLONIZATION SCORE",
  "SCORING COMPLETE", score category words. **B**.
- `docs/SESSION_UI_CATALOG.md` — `SCORE01..24`, `OPEN*`, `CLOS-*`, `KINGLSS1/2`,
  `DEC-*` visual identification. **A**.

## Open questions (TBD)
1. **Score plate→category mapping** — disasm `func_03A9C0` to bind each of the
   24 `SCORE*` plates to its score line.
2. **OPENING/CLOSING frame timing** — the per-frame sequencing lives in the
   separate exes (not yet disassembled).
3. **DECLARAT.PIK printed-document loader** — find the function that loads it
   (not located by string search in VICEROY disasm).
4. **`KING2.SS` animation loader** — locate the war-declaration cinematic that
   uses the 8-frame arm-raise sheet.
