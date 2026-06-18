# Specification — the game, described (Layer 2)

The **single source of truth** for *what Colonization does* and the entry point
for any port. Built from PRIMARY evidence; consumed by the Layer-3
implementation. See [`/METHODOLOGY.md`](../METHODOLOGY.md) — especially **Primary
data is the decider** (every claim traces to the bytes/extracted data; bad
secondary data is deleted, not bannered).

This index enumerates **every spec sheet** the project needs (Route A). Most are
not yet authored — until a sheet exists under `systems/`, `ui/`, or `data/`, the
**canonical primary doc** named in its row *is* the spec for that topic. Author
new sheets from [`_TEMPLATE.md`](_TEMPLATE.md). Gap-closing work is queued in
[`BACKLOG.md`](BACKLOG.md).

Tiers: `BYTE_VERIFIED` (B) · `ANCHOR_VERIFIED` (A) · `RECONSTRUCTED` (R) · `TBD`.
Status: ✍ authored here · ◻ stub (canonical doc only).

## Game systems (24)

| # | System | Spec / canonical primary doc | Tier | Status |
|---|--------|------------------------------|------|--------|
| 1 | King & taxation | **[`systems/king.md`](systems/king.md)** | B/TBD | ✍ |
| 2 | Combat (land/naval) | **[`systems/combat.md`](systems/combat.md)** | B/TBD | ✍ |
| 3 | Market & prices | **[`systems/market.md`](systems/market.md)** | B/TBD | ✍ |
| 4 | Colony & production | **[`systems/colony.md`](systems/colony.md)** | B/TBD | ✍ |
| 5 | Unit system (types/movement/cargo) | `docs/DATA_MODEL.md` (UnitRecord) + `@UNIT` | B/R | ◻ |
| 6 | Unit orders (sentry/fortify/goto/build/plow/road) | `@ORDERS` + disasm | R/TBD | ◻ |
| 7 | Trade routes | `@ORDERS` + disasm | TBD | ◻ |
| 8 | Immigration / recruitment (crosses) | `docs/IMMIGRATION_RECRUIT_FINDINGS.md` | A/TBD | ◻ |
| 9 | Colonist training / promotion | `@JOB` + disasm | R/TBD | ◻ |
| 10 | Native relations (attitude/trade/raid/mission) | `viceroy_source/docs/NATIVE_RELATIONS.md` | R/TBD | ◻ |
| 11 | Founding Fathers / Congress | `@FATHERS`,`@FOUNDING` + disasm | R/TBD | ◻ |
| 12 | Independence / revolution | `viceroy_source/docs/REVOLUTION.md` | R/TBD | ◻ |
| 13 | European diplomacy | `viceroy_source/docs/EUROPEAN_DIPLOMACY.md` ⚠ | R/TBD | ◻ |
| 14 | Scoring | `viceroy_source/docs/SCORING.md` | R/TBD | ◻ |
| 15 | Random events / Lost City | `viceroy_source/docs/RANDOM_EVENTS.md` | R/TBD | ◻ |
| 16 | Map system & terrain | `viceroy_source/docs/MAP_SYSTEM.md` + `@UNFORESTED/@FORESTED` | B/R | ◻ |
| 17 | Map generation | `viceroy_source/docs/MAP_GENERATION.md` | TBD | ◻ |
| 18 | Exploration / visibility (fog) | disasm | TBD | ◻ |
| 19 | Terrain improvement (road/clear/plow) | `@ORDERS` + disasm | R/TBD | ◻ |
| 20 | Difficulty levels | `@DIFFICULTY` + global `0x53A6` | B/R | ◻ |
| 21 | National powers / abilities | `@COUNTRY` + disasm | R/TBD | ◻ |
| 22 | Turn dispatch (per-power sequence/phases) | `docs/ARCHITECTURE.md` | B | ◻ |
| 23 | Save / load | `docs/SAVE_FORMAT_CROSSREF.md` | R/TBD | ◻ |
| 24 | Resource mgmt / warehousing | `docs/DATA_MODEL.md` (ColonyRecord) | A/TBD | ◻ |
| +A | **Tutorial** (`@TUTORIAL1..19`) | `data_extracted/text/GAME_sections.json` | B/TBD | ◻ |
| +B | **REF growth** (budget→units) | `king.md` §7 + globals `0x53DA..` / `+0x22` | A/TBD | ◻ |
| +C | **Mercenary hiring** | `GAME_sections.json` (`@MERCENAR*`) | TBD | ◻ |
| +D | **Boycotts** | `GAME_sections.json` + ColonyRecord | TBD | ◻ |
| +E | **Tory uprising** | `GAME_sections.json` (`@TORYUPRISING`) | TBD | ◻ |
| +F | **Heir succession** | `GAME_sections.json` | TBD | ◻ |
| +G | **Wilderness camp / consolidation** | disasm | TBD | ◻ |

*(+A…+G were missing from the earlier draft; surfaced from primary `GAME_sections.json`.)*

## UI screens & dialogs (52)

Each needs a `ui/<name>.md` ("what is drawn where"). Until authored, the canonical
doc applies. Primary UI sources: `docs/SESSION_UI_CATALOG.md`,
`docs/RENDERER_GEOMETRY.md`, `docs/ADVISOR_REPORTS_AUDIT.md`,
`docs/UI_DIALOGS.md`, `docs/POPUP_TEMPLATE_AUDIT.md`, `docs/DIALOG_GEOMETRY.md`,
`docs/KING_AND_CINEMATIC_AUDIT.md`, `docs/GAME_INDEX_TABLES.md`.

- **Full-screen views (5):** map/gameplay · colony · Europe · Continental Congress · Declaration of Independence.
- **Advisor reports (9):** F2 Religious · F3 Congress · F4 Labor · F5 Economic · F6 Colony · F7 Naval · F8 Foreign Affairs · F9 Indian · F10 Score.
- **Popups (~24):** King tax demand · native raze · native attitude · native gift/haggle · native raid · Lost City (10 variants) · combat result · ship combat/landfall · heresy · rebel-sentiment change · food shortage/starvation · colony burn/capture · intervention · treasure delivery · unit capture/demotion · revolutionary-war messages.
- **Main-menu screens (8):** main menu · new-game options · customize world · difficulty select · nationality/leader select · save dialog · load dialog · Hall of Fame.
- **End-game (4):** King-defeats screen · score screen · opening cinematic · closing cinematic.
- **Context dialogs (≈2 groups):** unit jobs/orders menu · trade-route setup · native-village interaction (10 actions) · colonial-authority · diplomatic choices · recruitment · purchase-unit · training/school · construction-choice.

## Data & format specs (23)

| Topic | Canonical primary doc | Tier |
|-------|------------------------|------|
| Memory records (Power/Colony/Unit/Native) | **`docs/DATA_MODEL.md`** (runtime-verified) | B |
| Index tables (sprite/text indices) | `docs/GAME_INDEX_TABLES.md` | B |
| NAMES.TXT sections (23 `@`-sections) | `data_extracted/text/NAMES_sections.json` | B |
| Text resources (GAME/LABELS/PEDIA) | `data_extracted/text/*.json` + `docs/*_CATALOG.md` | B |
| File formats (.MP/.SS/.PAL/.PIK/.FF/COL/MOV/BIN/DAT/EXE/RTLINK) | `formats/` + `viceroy_source/formats/` | B |

## De-duplication record (this turn)

Primary data is canonical; conflicting secondary copies were **deleted** (per
`/METHODOLOGY.md` → Remove-bad-data):

- **Deleted** `notes/COLONIZATION_TECHNICAL_REFERENCE.md` — ~60–70% uncited
  speculation; source of the original king.md REF/tax-cap errors. Refs repointed
  to `docs/DATA_MODEL.md` / `data_extracted/text/*.json` / `docs/GAME_INDEX_TABLES.md`.
- **Deleted** `viceroy_source/docs/DATA_MODEL.md` — superseded by `docs/DATA_MODEL.md`.
- ⚠ marks docs with known FABRICATED sections retained as Layer-1 evidence with a
  corrective note (e.g. `EUROPEAN_DIPLOMACY.md` rel-score model;
  `RENDER_CHAIN.md` dirty-rect "does not exist").

Canonical: memory records → `docs/DATA_MODEL.md`; architecture → `docs/ARCHITECTURE.md`;
render chain → `docs/RENDER_CHAIN.md` + `docs/COLONY_RENDER_CHAIN.md`.
