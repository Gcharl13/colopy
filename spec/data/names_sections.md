# NAMES.TXT Sections — Game-Data Taxonomy Backbone

> **Layer 2 — Data Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.

**Canonical primary:** `data_extracted/text/NAMES_sections.json` (the extracted NAMES.TXT `@`-sections — CANONICAL for the data). This stub enumerates the sections actually present with their entry counts; for the raw rows read the JSON.

## 1. Summary

NAMES.TXT is the game-data taxonomy backbone: a series of `@`-keyed sections, each a list of named rows. Row index within a section IS the runtime id (e.g. `@UNIT` row index = UnitRecord `+0x00` unit_type; `@COUNTRY`/`@TRIBES` order = PowerRecord index 0..11). Many sections carry extra numeric parameters per row (e.g. `@CARGO` has 9; see `docs/GAME_INDEX_TABLES.md`). **The extracted JSON has 31 `@`-sections** (the ~23 the task named plus `@NATIONABBREV`, `@INDEPENDENT`, `@VALUES`, `@ATTITUDINAL`).

## 2. Contents (sections present, with non-empty line counts)

| Section | Lines | Role | Section | Lines | Role |
|---------|------:|------|---------|------:|------|
| `@SEASONS` | 2 | season names | `@CARGO` | 20 | 16 commodities (+params) |
| `@UNFORESTED` | 8 | base terrain yields | `@UNIT` | 23 | unit types (0..23) |
| `@FORESTED` | 8 | forested terrain yields | `@ORDERS` | 13 | order codes |
| `@OTHER` | 5 | other terrain/misc | `@ACTIONS` | 10 | action labels |
| `@OTHER_NAMES` | 5 | misc names | `@VALUES` | 4 | value labels |
| `@RESOURCE` | 14 | special resources | `@ATTITUDE` | 5 | attitude states |
| `@COUNTRY` | 4 | EU powers (idx 0..3) | `@ATTITUDINAL` | 5 | attitude phrasing |
| `@NATIONALITY` | 4 | adjectives | `@LEVELS` | 5 | rank/level names |
| `@NATIONABBREV` | 4 | nation abbreviations | `@TRIBES` | 26 | native tribes (idx 4..11 + more) |
| `@HOMEPORT` | 4 | home port names | `@FOUNDING` | 6 | founding-father categories |
| `@COLONYNAME` | 4 | colony name pools | `@FATHERS` | 25 | founding fathers |
| `@INDEPENDENT` | 4 | post-independence names | `@COLORS` | 1 | color table |
| `@LEADERNAME` | 4 | leader names | `@CLASS` | 8 | unit/colonist classes |
| `@MISSION` | 4 | mission types | `@BUILDING` | 42 | colony buildings (+mods) |
| `@DIFFICULTY` | 5 | difficulty names | `@SCENARIO` | 2 | scenario names |
| `@JOB` | 28 | professions / job slots | | | |

All 31 sections present in `data_extracted/text/NAMES_sections.json`. (Of the task-named set: all present; `@SEASONS @UNFORESTED @FORESTED @OTHER @OTHER_NAMES @RESOURCE @COUNTRY @NATIONALITY @HOMEPORT @COLONYNAME @LEADERNAME @MISSION @DIFFICULTY @CLASS @BUILDING @SCENARIO @JOB @CARGO @UNIT @ORDERS @ACTIONS @ATTITUDE @LEVELS @TRIBES @FOUNDING @FATHERS @COLORS` — 27 confirmed, plus extras `@NATIONABBREV @INDEPENDENT @VALUES @ATTITUDINAL`.)

## 3. Evidence

- `data_extracted/text/NAMES_sections.json` — extracted sections + rows. **B** (data exists; counts read 2026-06-18).
- `docs/DATA_MODEL.md` — `@COUNTRY`/`@TRIBES` order = PowerRecord index; `@UNIT` row = UnitRecord `+0x00`. **B**
- `docs/GAME_INDEX_TABLES.md` — per-section numeric params (`@CARGO` 9 params). **B**
- `formats/TXT.md` — `.TXT` section format. **B**

## 4. Open questions (TBD)

1. Per-row numeric parameter layouts for `@BUILDING`/`@JOB`/`@UNIT`/`@RESOURCE` (only `@CARGO` is fully catalogued in `docs/GAME_INDEX_TABLES.md`).
2. Whether `@TRIBES` (26 lines) maps cleanly onto the 8 PowerRecord tribe slots (idx 4..11) or includes sub-tribe/extra rows — confirm against `docs/DATA_MODEL.md`.
3. Exact role of `@VALUES` / `@ATTITUDINAL` / `@INDEPENDENT` / `@NATIONABBREV` — TBD.
