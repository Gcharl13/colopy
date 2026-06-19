# Advisor Reports (F2–F10)

> **Layer 2 — UI Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** dispatcher + paint-func offsets + title keys **B** (byte-cited); PIK→report assignments **R** (visual-guess); per-report body layout **TBD**. · **Canonical primary:** `docs/ADVISOR_REPORTS_AUDIT.md` (byte-cited, primary for this file), `docs/RENDERER_GEOMETRY.md` (Naval table), `docs/SESSION_UI_CATALOG.md`.

## 0. Common framework (all reports)
- **Dispatcher** `func_0x2b743` maps extended scan codes 0x13C..0x144 (and menu letters 'A'..'I') to per-report paint thunks (`ADVISOR_REPORTS_AUDIT.md` "Dispatcher", file 0x2BDEA..0x2BECF). It pushes the current player power_idx (`[0x8542]+0x1A`) to each paint func. **B**
- **PIK loader** `func_037340` builds "REPORT"+n via sprintf then `load_PIK` (file 0x037340..0x0373A4). **B**
- **Title painter** `LCALL 0x4509:0x10F` draws a centered LABELS `@MISC[idx]` title. All `@MISC` titles below verified present in `data_extracted/text/LABELS_sections.json`. **B**
- **Footer:** "OK" (`@MISC` "OK", verified) bottom-right. **B**
- Menu: REPORTS pulldown (`MENU_sections.json` `@REPORTS`, verified — lists F2 Religious … F10 Score). **B**
- **PIK→report mapping is GUESS-level** (`ADVISOR_REPORTS_AUDIT.md`: "needs visual verification") → tier **R** wherever a REPORTn.PIK is named.

---

## F2 — Religious Adviser
- **paint_func:** file 0x025F18; scan 0x13C; letter 'A'. **B**
- **title:** `@MISC[45]` "RELIGIOUS ADVISER REPORT" (verified). **B**
- **background:** REPORT2.PIK (preacher at pulpit). **R**
- **body:** per-colony grid of crosses + colonist counts; iterates colonies via `set_current_colony` (LCALL 0x181F:0x09E6). Row template **TBD**.
- **data:** ColonyRecord +0x1F size, +0x70+N profession byte (missionary). **B/R**

## F3 — Continental Congress
- **paint_func:** file 0x025FD0; scan 0x13D; letter 'B'. **B**
- **title:** `@MISC[52]` "CONTINENTAL CONGRESS ACTIVITIES" (verified). **B**
- **background:** CCBKGD.PIK. **B**
- See dedicated spec `spec/ui/continental_congress.md` (full layout + memory map). **B**

## F4 — Labor Adviser
- **paint_func:** file 0x0269D8; scan 0x13E; letter 'C'. **B**
- **title:** `@MISC[64]` "LABOR ADVISER REPORT" (verified) + `@MISC` "(Click on item to zoom)" (verified). **B**
- **background:** REPORT3.PIK (clerks at desk). **R**
- **body:** profession columns × per-colony counts; bounds ~(0, 52, 244, 144). Iterates colonies; tallies by NAMES `@JOB`. Per-row (x,y) **TBD**.

## F5 — Economic Adviser
- **paint_func:** file 0x027010; scan 0x13F; letter 'D'. **B**
- **title:** `@MISC[65]` "ECONOMIC ADVISER REPORT" (verified). **B**
- **background:** REPORT5.PIK (scales + currency + hourglass). **R**
- **body:** treasury gold, tax rate, per-commodity prices/pool, "(Building Upkeep)" + "TOTAL UPKEEP" (`@MISC`, both verified). **B/R**
- **data:** PowerRecord +0x2A gold, +0x01 tax, +0x4C+i **sensitivity** (u8; not price — RULINGS 2026-06-19), +0x5C+i*2 pool. **B**

## F6 — Colony Adviser
- **paint_func:** file 0x0277D8; scan 0x140; letter 'E'. **B**
- **title:** `@MISC[66]` "COLONY ADVISER REPORT" (verified). **B**
- **background:** REPORT4.PIK (pioneers building). **R**
- **body:** per-colony row: name, size, production, SoL %, sentiment. Template **TBD**.
- **data:** ColonyRecord +0x02..0x19 name, +0x1A owner, +0x1F size. **B**

## F7 — Naval Adviser
- **paint_func:** file 0x027B0C; scan 0x141; letter 'F'. **B**
- **title:** `@MISC[67]` "NAVAL ADVISER REPORT" (verified). **B**
- **background:** REPORT7.PIK (galleon under sail — visually confirmed). **B/R**
- **layout (frame-verified, `RENDERER_GEOMETRY.md` "Naval Adviser Report v3"):** TABLE, 20-px row grid. Header row y=20; rows y=40,60,80,100,121,140,161; OK ~(280,184). Columns "Ship/Cargo/Location/Destination" (`@MISC` 76–79, verified). **A** (geometry)
- **data:** iterate UnitRecord (base 0x3146, stride 0x1C), filter ship types; status "On Mapboard"/"Off Mapboard (Europe)"/"High Seas" (`@MISC`, verified). **B**

## F8 — Foreign Affairs
- **paint_func:** file 0x027E48; scan 0x142; letter 'G'. **B**
- **title:** `@MISC[108]` "FOREIGN AFFAIRS REPORT" (verified). **B**
- **background:** REPORT8.PIK (map + wax seal). **R** (best visual fit per both audits)
- **gate:** unavailable once War of Independence begins — `[0x5382]` bit 0 → GAME `@FOREIGNNOTAVAIL` via `func_039888` (byte-verified). **B**
- **nested picker:** "View Whose Report?" sub-menu England/French/Spanish/Dutch (bounds ~(60,96,180,68)). Picker func offset **TBD**. **R**
- **per-nation body** rows (`@MISC`, verified): "Colonies"(110), "Population"(111), "Average Colony"(112), "Military Power"(113), "Naval Power"(114), "Merchant Marine"(115), "Rebels"/"Tories", "War"(116)/"Peace"(117), "'s"(109). **B**
- **data:** per PowerRecord N (+0x01 tax, +0x02 rebel, +0x14 FF count, +0x2A gold). **B**

## F9 — Indian Adviser
- **paint_func:** file 0x025A0A; scan 0x143; letter 'H'. **B**
- **title:** `@MISC[44]` "INDIAN ADVISER REPORT" (verified). **B**
- **background:** REPORT1.PIK / REPORT9.PIK (native warrior + spear; REPORT9 is a palette-variant duplicate). **R**
- **body:** per-tribe row: tribe name, settlements, missions, relationship. Template **TBD**.
- **data:** NativeSettlement table DGROUP:0x54EC stride 18 (+0x02 owner_tribe, +0x04 pop, +0x05 mission); NAMES `@TRIBES` (8 tribes, verified). **B**

## F10 — Colonization Score
- **paint_func:** file 0x026DA8 (in-game) / 0x025992 (alt); scan 0x144; letter 'I'. Path selected by `[0x5383]` bit 5. **B**
- **title:** `@MISC[129]` "COLONIZATION SCORE" (verified). **B**
- **background:** wood-panel (no PIK); uses FONTKING (only score screen does). **B/R**
- **body lines** (`@MISC`, verified): "Citizens", "Independence"/"Declared", "Villages Burned", "Foreign Recognition", "Total Score", + acquired-FF list, "Rebel Sentiment". 24 SCORE01..24.SS art plates via `func_03A9C0` (panel→line mapping **TBD**). **B/R**

## 5. Evidence
- `docs/ADVISOR_REPORTS_AUDIT.md` — dispatcher (0x2BDEA..0x2BECF), all paint-func offsets, `@MISC` title indices, `func_037340` PIK loader, F8 gate `func_039888`, memory map. **B**
- `docs/RENDERER_GEOMETRY.md` "Naval Adviser Report v3" — frame-verified 20-px table. **A**
- `docs/SESSION_UI_CATALOG.md` — REPORT1..9 visual identification (PIK↔advisor, GUESS-level). **R**
- `data_extracted/text/{LABELS,MENU,NAMES}_sections.json` — `@MISC` titles/rows, `@REPORTS` menu, `@JOB`/`@TRIBES` (all verified). **B**

## 6. Open questions (TBD)
1. REPORTn.PIK → F-key assignment: visual GUESS, needs DOSBox run to confirm loaded filename per paint func.
2. Per-report body layout (exact label (x,y), font, row stride, columns) — deeper decompile of each paint func.
3. F8 nested-picker function offset not located.
4. F10 24 SCORE-panel → score-line mapping via `func_03A9C0`.
5. Title/body color choices (`LCALL 0x181F:0x01F0` palette args) per report.
