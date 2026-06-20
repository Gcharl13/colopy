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

**Certification (2026-06-20):** every game system's **byte layer is `BYTE_VERIFIED`**
(the `B` in each tier cell below). The remaining open `§6` items are consolidated into
the single **[Authoritative Residual Ledger](BACKLOG.md#-authoritative-residual-ledger-2026-06-20-certification)**,
each tagged by *why* it is open: **R** runtime/BSS-bound (need a memory dump), **O**
overlay/asset-bound (the `.SS` `mode=4` decoder; loader is overlay-resident), **S**
static depth-queue (closeable by disassembly — chiefly the SAV format, warehousing,
tutorial, map `.MP`/`@RESOURCE`), **F** inherently fuzzy AI logic. No game *mechanic* is
left un-byte-grounded; what remains is data-legend, runtime-magnitude, or asset-decode
work — `tools/linkcheck.py` is clean (`INVALID: 0`).

Tiers: `BYTE_VERIFIED` (B) · `ANCHOR_VERIFIED` (A) · `RECONSTRUCTED` (R) · `TBD`.

## Game systems (30)

| System | Spec | Tier | System | Spec | Tier |
|--------|------|------|--------|------|------|
| King & taxation | [`systems/king.md`](systems/king.md) | B/TBD | Difficulty | [`systems/difficulty.md`](systems/difficulty.md) | B/R |
| Combat | [`systems/combat.md`](systems/combat.md) | B/TBD | National powers | [`systems/national_powers.md`](systems/national_powers.md) | B/R |
| Market & prices | [`systems/market.md`](systems/market.md) | B/TBD | Turn dispatch | [`systems/turn_dispatch.md`](systems/turn_dispatch.md) | B/TBD |
| Colony & production | [`systems/colony.md`](systems/colony.md) | B/R | Save / load | [`systems/save.md`](systems/save.md) | B/TBD |
| Unit system | [`systems/unit.md`](systems/unit.md) | B | Warehousing | [`systems/warehousing.md`](systems/warehousing.md) | B/TBD |
| Unit orders | [`systems/unit_orders.md`](systems/unit_orders.md) | B | Tutorial | [`systems/tutorial.md`](systems/tutorial.md) | B/TBD |
| Trade routes | [`systems/trade_routes.md`](systems/trade_routes.md) | B/TBD | REF growth | [`systems/ref_growth.md`](systems/ref_growth.md) | B/TBD |
| Immigration | [`systems/immigration.md`](systems/immigration.md) | B/TBD | Mercenary hiring | [`systems/mercenary.md`](systems/mercenary.md) | B |
| Training / promotion | [`systems/training.md`](systems/training.md) | B/TBD | Boycotts | [`systems/boycotts.md`](systems/boycotts.md) | B/TBD |
| Native relations | [`systems/natives.md`](systems/natives.md) | B/TBD | Tory uprising | [`systems/tory_uprising.md`](systems/tory_uprising.md) | B/TBD |
| Founding Fathers | [`systems/founding_fathers.md`](systems/founding_fathers.md) | B/TBD | War of Spanish Succession | [`systems/spanish_succession.md`](systems/spanish_succession.md) | B/TBD |
| Revolution | [`systems/revolution.md`](systems/revolution.md) | B/TBD | | | |
| Diplomacy (European) | [`systems/diplomacy.md`](systems/diplomacy.md) | B/TBD | Events / Lost City | [`systems/events.md`](systems/events.md) | B/TBD |
| Scoring | [`systems/scoring.md`](systems/scoring.md) | B/TBD | Map system & terrain | [`systems/map_system.md`](systems/map_system.md) | B/R |
| Map generation | [`systems/map_generation.md`](systems/map_generation.md) | B/TBD | Exploration / fog | [`systems/exploration.md`](systems/exploration.md) | B/TBD |
| Terrain improvement | [`systems/terrain_improvement.md`](systems/terrain_improvement.md) | B/TBD | | | |

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

## The basis (primary extraction — read this before writing any spec)

Specs are derived from the extracted **basis**, never imagination (see
`/METHODOLOGY.md` → Data-first). Rebuilt 2026-06-18 from the real game files:
- `data_extracted/text/*_sections.json` (flat `@KEY`→body) + `*.full.json`
  (legend/columns) — **complete bodies** via `tools/extract_txt_sections.py`
  (the old dump dropped bodies, which is how two systems got invented).
- `data_extracted/tables/*.json` — byte-anchored gameplay tables
  (`tools/build_tables.py`): `@UNIT/@CARGO/@BUILDING/@FATHERS/@TERRAIN/@JOB/…`,
  values verbatim from the data files, columns from the files' own legends.
- `data_extracted/viceroy_strings.txt` (EXE strings+offsets) · `docs/DATA_MODEL.md`
  (globals/records).

## Data & formats (6 spec files)

| Spec file | Covers | Canonical primary |
|-----------|--------|-------------------|
| [`data/records.md`](data/records.md) | Power/Colony/Unit/Native memory records | `docs/DATA_MODEL.md` |
| [`data/tables.md`](data/tables.md) | **every** gameplay data table — all NAMES CSV + id→name list sections, all TRIBE dispersal tables, and the DGROUP layout catalog (full rows inline) | `data_extracted/tables/*.json` |
| [`data/index_tables.md`](data/index_tables.md) | sprite/text index tables | `docs/GAME_INDEX_TABLES.md` |
| [`data/names_sections.md`](data/names_sections.md) | all **31** NAMES.TXT `@`-sections — **complete verbatim bodies** | `data_extracted/text/NAMES.full.json` |
| [`data/text_resources.md`](data/text_resources.md) | **all** text `.TXT` files (GAME/PEDIA/LABELS/MENU/COLONY/MAPEDIT/MAPMENU/DEBUG/OPENING/CLOSING/WOODCUT) — **complete verbatim bodies** (763 `@`-keys) | `data_extracted/text/*.full.json` |
| [`data/file_formats.md`](data/file_formats.md) | .MP/.SS/.PAL/.PIK/.FF/… on-disk formats | `formats/` |

**Complete enumeration (2026-06-18):** every `@`-key body across all 14 `.TXT`
files (794 keys: 31 NAMES + 763 others) and every data table (NAMES/TRIBE/DGROUP)
is now rendered **in full** inside `<!-- BEGIN GENERATED -->` blocks in
`names_sections.md`, `text_resources.md`, and `tables.md` — machine-rendered
verbatim from the basis by `tools/build_spec_data.py` (regenerate, don't hand-edit
inside the markers). Notes: NAMES.TXT has **31** `@`-sections (not 23); GAME.TXT
repeats some keys (`@smallfont`/`@options`) — the basis `sections_ordered` list
preserves every duplicate; ColonyRecord has **no static base** — reached via the
far pointer `[0x8542]` (stride `0xCA`); PowerRecord base appears as `0x8808`
(array head) / `0x8809` (first field) in `docs/DATA_MODEL.md`. The DGROUP record
*values* are runtime (memory-dump-verified, **not** static EXE bytes) — the
catalog surfaces the byte-verified *layout*.

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
