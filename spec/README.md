# Specification — the game, described (Layer 2)

The **single source of truth** for *what Colonization does* and the entry point
for any port. Built from PRIMARY evidence; consumed by the Layer-3
implementation. See [`/METHODOLOGY.md`](../METHODOLOGY.md) — especially **Primary
data is the decider** (every claim traces to the bytes/extracted data; bad
secondary data is deleted, not bannered).

**Status (2026-06-18):** the taxonomy is **fully populated** — every system, UI
family, and data topic has a spec sheet. These are **breadth-first stubs**:
primary-grounded where the bytes are known, honest `TBD` elsewhere. Depth comes
from each sheet's §6 "Open questions" and [`BACKLOG.md`](BACKLOG.md). Author/
deepen from [`_TEMPLATE.md`](_TEMPLATE.md).

Tiers: `BYTE_VERIFIED` (B) · `ANCHOR_VERIFIED` (A) · `RECONSTRUCTED` (R) · `TBD`.

## Game systems (31)

| System | Spec | Tier | System | Spec | Tier |
|--------|------|------|--------|------|------|
| King & taxation | [`systems/king.md`](systems/king.md) | B/TBD | Difficulty | [`systems/difficulty.md`](systems/difficulty.md) | B/R |
| Combat | [`systems/combat.md`](systems/combat.md) | B/TBD | National powers | [`systems/national_powers.md`](systems/national_powers.md) | R/TBD |
| Market & prices | [`systems/market.md`](systems/market.md) | B/TBD | Turn dispatch | [`systems/turn_dispatch.md`](systems/turn_dispatch.md) | B/TBD |
| Colony & production | [`systems/colony.md`](systems/colony.md) | B/TBD | Save / load | [`systems/save.md`](systems/save.md) | R/TBD |
| Unit system | [`systems/unit.md`](systems/unit.md) | B/R | Warehousing | [`systems/warehousing.md`](systems/warehousing.md) | A/TBD |
| Unit orders | [`systems/unit_orders.md`](systems/unit_orders.md) | B/R | Tutorial | [`systems/tutorial.md`](systems/tutorial.md) | B/TBD |
| Trade routes | [`systems/trade_routes.md`](systems/trade_routes.md) | TBD | REF growth | [`systems/ref_growth.md`](systems/ref_growth.md) | A/TBD |
| Immigration | [`systems/immigration.md`](systems/immigration.md) | A/TBD | Mercenary hiring | [`systems/mercenary.md`](systems/mercenary.md) | B/TBD |
| Training / promotion | [`systems/training.md`](systems/training.md) | R/TBD | Boycotts | [`systems/boycotts.md`](systems/boycotts.md) | B/TBD |
| Native relations | [`systems/natives.md`](systems/natives.md) | B/TBD | Tory uprising | [`systems/tory_uprising.md`](systems/tory_uprising.md) | B/TBD |
| Founding Fathers | [`systems/founding_fathers.md`](systems/founding_fathers.md) | B/TBD | Heir succession | [`systems/heir_succession.md`](systems/heir_succession.md) | B/TBD |
| Revolution | [`systems/revolution.md`](systems/revolution.md) | R/TBD | Wilderness camp | [`systems/wilderness_camp.md`](systems/wilderness_camp.md) | A/TBD |
| Diplomacy (European) | [`systems/diplomacy.md`](systems/diplomacy.md) | A/TBD | Events / Lost City | [`systems/events.md`](systems/events.md) | B/TBD |
| Scoring | [`systems/scoring.md`](systems/scoring.md) | R/TBD | Map system & terrain | [`systems/map_system.md`](systems/map_system.md) | B/R |
| Map generation | [`systems/map_generation.md`](systems/map_generation.md) | TBD | Exploration / fog | [`systems/exploration.md`](systems/exploration.md) | TBD |
| Terrain improvement | [`systems/terrain_improvement.md`](systems/terrain_improvement.md) | R/TBD | | | |

## UI screens & dialogs (52 entries → 10 spec files)

"What is drawn where." Full-screen views get their own file; report/popup/menu/
context families are grouped (one file, a section per screen).

| Spec file | Covers |
|-----------|--------|
| [`ui/map_view.md`](ui/map_view.md) | main gameplay screen (viewport, minimap, sidebar, menu bar) |
| [`ui/colony_screen.md`](ui/colony_screen.md) | colony screen (buildings, production, SoL, warehouse) |
| [`ui/europe_screen.md`](ui/europe_screen.md) | Europe (docks, harbor, recruit/purchase/train) |
| [`ui/continental_congress.md`](ui/continental_congress.md) | Continental Congress |
| [`ui/declaration_independence.md`](ui/declaration_independence.md) | Declaration of Independence |
| [`ui/advisor_reports.md`](ui/advisor_reports.md) | the 9 advisor reports F2–F10 |
| [`ui/popups.md`](ui/popups.md) | ~24 gameplay popups (king/native/combat/events/colony/war) |
| [`ui/menus.md`](ui/menus.md) | main menu, new-game/customize/difficulty/nationality, save/load, Hall of Fame |
| [`ui/cinematics.md`](ui/cinematics.md) | opening/closing cinematics, king-defeats, score screen |
| [`ui/context_dialogs.md`](ui/context_dialogs.md) | unit orders, trade-route, native-village, diplomacy, recruit/purchase/train, construction menus |

Primary UI sources: `docs/SESSION_UI_CATALOG.md`, `docs/RENDERER_GEOMETRY.md`,
`docs/ADVISOR_REPORTS_AUDIT.md`, `docs/UI_DIALOGS.md`,
`docs/POPUP_TEMPLATE_AUDIT.md`, `docs/DIALOG_GEOMETRY.md`,
`docs/KING_AND_CINEMATIC_AUDIT.md`, `docs/COLONY_RENDER_CHAIN.md`.

## Data & formats (5 spec files)

| Spec file | Covers | Canonical primary |
|-----------|--------|-------------------|
| [`data/records.md`](data/records.md) | Power/Colony/Unit/Native memory records | `docs/DATA_MODEL.md` |
| [`data/index_tables.md`](data/index_tables.md) | sprite/text index tables | `docs/GAME_INDEX_TABLES.md` |
| [`data/names_sections.md`](data/names_sections.md) | the **31** NAMES.TXT `@`-sections | `data_extracted/text/NAMES_sections.json` |
| [`data/text_resources.md`](data/text_resources.md) | GAME/LABELS/PEDIA/MENU text | `data_extracted/text/*.json` + catalogs |
| [`data/file_formats.md`](data/file_formats.md) | .MP/.SS/.PAL/.PIK/.FF/… on-disk formats | `formats/` |

Notes from the population pass: NAMES.TXT has **31** `@`-sections (not 23);
ColonyRecord has **no static base** — it's reached via the far pointer
`[0x8542]` (stride `0xCA`); PowerRecord base appears as `0x8808` (array head) /
`0x8809` (first field) in `docs/DATA_MODEL.md`.

## De-duplication record

Primary data is canonical; conflicting secondary copies were **deleted** (per
`/METHODOLOGY.md` → Remove-bad-data):
- **Deleted** `notes/COLONIZATION_TECHNICAL_REFERENCE.md` (source of the original
  king.md REF/tax-cap errors) and `viceroy_source/docs/DATA_MODEL.md` (superseded).
- Canonical: memory records → `docs/DATA_MODEL.md`; architecture →
  `docs/ARCHITECTURE.md`; render chain → `docs/RENDER_CHAIN.md` +
  `docs/COLONY_RENDER_CHAIN.md`.
- ⚠ Docs with known FABRICATED sections are retained as Layer-1 evidence only,
  with corrective notes (e.g. `EUROPEAN_DIPLOMACY.md` rel-score model;
  `RENDER_CHAIN.md` dirty-rect "does not exist").

## Depth pass

Each spec's **§6 Open questions** is its own depth queue. Cross-cutting,
highest-value byte-traces are consolidated in [`BACKLOG.md`](BACKLOG.md).
