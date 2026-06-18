# Continental Congress

> **Layer 2 — UI Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** band geometry **A**; state→display memory map **B**; FF portrait-slot rendering **R/TBD**. · **Canonical primary:** `docs/SESSION_UI_CATALOG.md` §3, `docs/RENDERER_GEOMETRY.md` "Continental Congress (VERIFIED v3)", `docs/ADVISOR_REPORTS_AUDIT.md` F3.

## 1. Purpose
The Continental Congress Activities screen (also reachable as advisor report F3). Shows progress toward the next Founding Father, Rebel/Tory sentiment, bells/turn, the King's Expeditionary Force (REF) by unit type, and the list of acquired Founding Fathers. Surfaces as an overlay on CCBKGD.PIK. **A** (`SESSION_UI_CATALOG.md` §3).

## 2. Layout — "what is drawn where"
Native 320×200. Bands frame-verified via luma analysis (`RENDERER_GEOMETRY.md` v3, tier **A**).

| Region | Pixel rect | Tier | Notes |
|--------|-----------|------|-------|
| Title | (0, 0, 320, 10) | A | "CONTINENTAL CONGRESS ACTIVITIES" |
| Session subtitle | (0, 10, 320, 20) | A | "Next Continental Congress Session: (\<FF\>) (NN in MM)" |
| Progress bar | (0, 30, 320, 6) | A | yellow fill = bells_current / threshold |
| Sentiment strip | (0, 36, 320, 8) | A | "Rebel Sentiment: X%   Tory Sentiment: Y%" |
| Bell icons row | (0, 44, 320, 32) | A | bell sprites + US flag |
| REF / FF list | (0, 76, 320, 40) | A | 4 REF unit groups w/ count badges |
| Founding Fathers list | (0, 116, 320, 60) | A | acquired FF names (plain green text, not portraits) |
| OK button | (290, 184, 26, 14) | A | bottom-right |

The "(NN in MM)" displays `NN = threshold − bells_current` (still needed), `MM = threshold` (`RENDERER_GEOMETRY.md` "Display formula"). **B**

**FF portrait slots (25, CC-NN.SS):** the 25 Founding-Father portraits CC-00..CC-24 map 1:1 to NAMES `@FATHERS` line order (`SESSION_UI_CATALOG.md` "Founding Father portraits — full mapping"). On this Activities screen the acquired-FF list renders as **plain text, not CC-NN blits** (frame 1310124562 confirms text-only). CC-NN portraits are used in the dedicated FF-acquisition popups / FF detail views — those slots are **R** (not byte-cited here). **A (text-only) / R (portrait use)**

## 3. Assets & text
- **Background:** CCBKGD.PIK full-screen (scribe at desk). REF unit icons + bell + US flag from ICONS.SS. FF portraits: CC-00..CC-24.SS (1 per FF, indices = `@FATHERS` order). **A/B**
- **Title** LABELS `@MISC` "CONTINENTAL CONGRESS ACTIVITIES" (verified in `LABELS_sections.json`). **B**
- **Labels** (verified `@MISC`): "Next Continental Congress Session", "Rebel", "Tory", "Sentiment", "Expeditionary Force", "Founding Fathers", "Rebels", "Tories", "OK". **B**
- FF names from NAMES `@FATHERS` (verified; Adam Smith / Jakob Fugger / Peter Minuit … confirmed in JSON). **B**

## 4. Interactions
- OK button → dismiss. **A**
- Reachable via REPORTS → F3 / menu-letter 'B' (`ADVISOR_REPORTS_AUDIT.md` dispatcher) and as the FF-acquired event screen. **B**

## 5. Evidence
- `docs/SESSION_UI_CATALOG.md` §3 — frame 1310124562, memory-tied display table, CC-NN→`@FATHERS` mapping. **A/B**
- `docs/RENDERER_GEOMETRY.md` "Continental Congress (VERIFIED v3)" + "Continental Congress Activities" detailed element table + memory map. **A/B**
- `docs/ADVISOR_REPORTS_AUDIT.md` F3 — paint_func file 0x025FD0, CCBKGD.PIK, title `@MISC[52]`. **B**
- State→display (BYTE_VERIFIED, `RENDERER_GEOMETRY.md`/`ADVISOR_REPORTS_AUDIT.md`): PowerRecord +0x02 rebel%, +0x0C bells_current, +0x0E bells/turn, +0x14 FF count, +0x07 acquired-FF mask; REF DGROUP 0x53DA Regulars / 0x53DC Cavalry / 0x53DE Man-O-War / 0x53E0 Artillery. **B**
- `data_extracted/text/{LABELS,NAMES}_sections.json` — `@MISC`, `@FATHERS` (verified). **B**

## 6. Open questions (TBD)
1. Bell sprite + US-flag exact ICONS.SS indices (not byte-cited).
2. FF "next session" selection logic (which FF is next) — walk `@FATHERS` by category; threshold table at DGROUP:0xE7AC noted but layout TBD (`SESSION_UI_CATALOG.md` open-questions #1).
3. REF group sprite indices + count-badge geometry (v2 sub-coords only).
4. CC-NN portrait-slot screen (FF acquisition popup) layout — separate from this Activities screen, not specified here.
