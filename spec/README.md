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

**Certification (2026-06-21, updated):** every game system's **byte layer is
`BYTE_VERIFIED`** (the `B` in each tier cell below), and the
**[Authoritative Residual Ledger](BACKLOG.md#-authoritative-residual-ledger-2026-06-20-certification)**
is now **empty of code/value residuals across all four categories (R/O/S/F)** — **no game
mechanic, function, or constant is left un-byte-grounded, and nothing required a memory dump
or runtime trace.** The last three "needs-a-trace" items were all found statically on
2026-06-21: the **school teaching rate** (`func_02D658`: 4/6/8 turns by skill class), the
**FF effect bindings** (`ov_power_flag` op_id ≡ `@FATHERS` index — Hudson ×2 furs, Jefferson
+50% bells, Paine bells+tax%, Bolívar +20% SoL, Penn +50% crosses), and the **Lost-City
marker** (dissolved — rumor presence is procedural via `func_006188` + map seed `[0x190]`,
not a stored `0xB0` byte; RULING 2026-06-21). **Categories S (static depth-queue) and O (the
`.SS` sprite codec) are also empty** — the SAV format,
warehousing, tutorial, immigration recruit-pool, `@JOB`/`@RESOURCE` legends, exploration
fog, the data-table loaders, and the revolution score bonus (additive `(1780−year)×2`,
*not* a multiplier — a manual correction) are all byte-verified this pass; and the `.SS`
codec is **solved** (standard **FAB**, recovered statically into [`tools/ssdec.py`](../tools/ssdec.py),
decoding all 28 sheets to exact `unpacked` sizes — CC-NN = the 25 `@FATHERS` portraits,
BUILDING.SS = 48 building frames; see `formats/SS.md`). Only narrow runtime/soft residuals
remain. No game *mechanic* is left un-byte-grounded — `tools/linkcheck.py` is clean
(`INVALID: 0`).

Tiers: `BYTE_VERIFIED` (B) · `ANCHOR_VERIFIED` (A) · `RECONSTRUCTED` (R) · `TBD`.

## Game systems (30)

| System | Spec | Tier | System | Spec | Tier |
|--------|------|------|--------|------|------|
| King & taxation | [`systems/king.md`](systems/king.md) | B/TBD | Difficulty | [`systems/difficulty.md`](systems/difficulty.md) | B/R |
| Combat | [`systems/combat.md`](systems/combat.md) | B/TBD | National powers | [`systems/national_powers.md`](systems/national_powers.md) | B/R |
| Market & prices | [`systems/market.md`](systems/market.md) | B/TBD | Turn dispatch | [`systems/turn_dispatch.md`](systems/turn_dispatch.md) | B/TBD |
| Colony & production | [`systems/colony.md`](systems/colony.md) | B/R | Save / load | [`systems/save.md`](systems/save.md) | B |
| Unit system | [`systems/unit.md`](systems/unit.md) | B | Warehousing | [`systems/warehousing.md`](systems/warehousing.md) | B |
| Unit orders | [`systems/unit_orders.md`](systems/unit_orders.md) | B | Tutorial | [`systems/tutorial.md`](systems/tutorial.md) | B |
| Trade routes | [`systems/trade_routes.md`](systems/trade_routes.md) | B/TBD | REF growth | [`systems/ref_growth.md`](systems/ref_growth.md) | B/TBD |
| Immigration | [`systems/immigration.md`](systems/immigration.md) | B/TBD | Mercenary hiring | [`systems/mercenary.md`](systems/mercenary.md) | B |
| Training / promotion | [`systems/training.md`](systems/training.md) | B | Boycotts | [`systems/boycotts.md`](systems/boycotts.md) | B/TBD |
| Native relations | [`systems/natives.md`](systems/natives.md) | B/TBD | Tory uprising | [`systems/tory_uprising.md`](systems/tory_uprising.md) | B |
| Founding Fathers | [`systems/founding_fathers.md`](systems/founding_fathers.md) | B | War of Spanish Succession | [`systems/spanish_succession.md`](systems/spanish_succession.md) | B/TBD |
| Revolution | [`systems/revolution.md`](systems/revolution.md) | B | | | |
| Diplomacy (European) | [`systems/diplomacy.md`](systems/diplomacy.md) | B | Events / Lost City | [`systems/events.md`](systems/events.md) | B |
| Scoring | [`systems/scoring.md`](systems/scoring.md) | B/TBD | Map system & terrain | [`systems/map_system.md`](systems/map_system.md) | B/R |
| Map generation | [`systems/map_generation.md`](systems/map_generation.md) | B/TBD | Exploration / fog | [`systems/exploration.md`](systems/exploration.md) | B/TBD |
| Terrain improvement | [`systems/terrain_improvement.md`](systems/terrain_improvement.md) | B/TBD | | | |

## UI screens & dialogs (52 entries → 10 spec files)

"What is drawn where." Full-screen views get their own file; report/popup/menu/
context families are grouped (one file, a section per screen).

**UI certification (2026-06-21):** the full UI sweep is complete. Every screen's **draw-code
semantics that exist in VICEROY.EXE are byte-grounded** — the render functions
(`colony_screen_render`, `europe_screen_render`, `congress_screen_render`, the F2–F10 report
bodies, the popup framework `func_06F0F4`, `title_screen_render`/menu framework,
`hall_of_fame_render`, the king-defeats/score/DECOIND painters) are decompiled and/or
re-disassembled at cited offsets. The pervasive stale rationale "per-element draw code lives in
un-extracted overlay 0x191F → TBD" was **false** (the overlay is `0x181F`, and the bodies are
in the export). Residuals are honestly tiered. A follow-up pass (2026-06-21) then **traced the remaining
"located-but-untraced" functions statically** — the colony overlay-`0x181F` helpers (SoL%,
per-cell good→sprite, unit iterator, build frame-select), the Europe transaction panel +
market-price LUT, the F8 power-picker, native-action gating (`func_04B308`), and
build-availability (`func_0B900`) are now **B**; and DECLARAT.PIK was shown to be an **orphan
asset** (the engine uses DECOIND.PIK). A **"runtime" re-evaluation (2026-06-21)** then showed
that nearly everything previously tagged *runtime* is in fact **static**: **colors** resolve to
exact RGB from the decodable PIK palette (index + palette, both byte-readable — not a capture);
**popup/dialog placement** is `@x`/`@y` from GAME.TXT or a centered formula (not the cursor);
**pixel layout coords** are constants in the render functions. The **only** genuine runtime
dependency is the displayed **values** themselves (gold, year, SoL%, which units/colonies exist)
— which are live game *state*, documented by layout/format, not spec gaps — plus the separate
non-exported `OPENING.EXE`/`CLOSING.EXE` cinematic frame timing. **No missing function or
un-resolvable constant remains in VICEROY.EXE.** Tiers: **B** = decompiled body / capstone offset
/ file-decoded value; **A** = luma/anchor-measured; **R** = reconstructed-from-asset; **TBD** =
separate non-exported binary or a live game-state value.

| Spec file | Covers | Layout / draw-code | Honest residual |
|-----------|--------|--------------------|-----------------|
| [`ui/map_view.md`](ui/map_view.md) | main gameplay screen | **B** tile chain (`O514→O513→O512`, `0x6204`); minimap dot colors = `NAMES.TXT @COLORS` (9 bytes via `@0x751A7`) / **A** bands | sidebar B/C per-line text coords (genuinely overlay-resident, TBD) |
| [`ui/colony_screen.md`](ui/colony_screen.md) | colony screen | **B** (composition, placement tables, 4 overlay-`0x181F` helpers, SoL faces `0x7C/0x7D` + nation flag `0x44` byte-cited) | none (live values only) |
| [`ui/europe_screen.md`](ui/europe_screen.md) | Europe harbor | **B** (literal coords; transaction panel `0x317CC`/`0x318D2`; market bid/ask LUT; boycott sprite good-indexed) | live values only (gold/prices) |
| [`ui/continental_congress.md`](ui/continental_congress.md) | Continental Congress | **B** FF-reveal mechanism; F3 body FONTTINY, title `0x90`/body `0x92` (CCBKGD) / **A** bands | bell/flag sprites absent from the F3 text body (overlay) |
| [`ui/declaration_independence.md`](ui/declaration_independence.md) | Declaration | **B** DECOIND painter + **signature glyph layout byte-verified** (pen (0x94,0x7E), glyph-width advance) | none (DECLARAT orphan; geometry closed) |
| [`ui/advisor_reports.md`](ui/advisor_reports.md) | reports F2–F10 | **B** (real bodies `0x37958`…`0x39EE2`; F8 picker `0x23810`; F4/F8 separators dark-red `0x77`→311/319; per-report static x-columns + y-start byte-cited; F10 font FONTTINY+FONTINTR) | per-row y = FONTTINY flow (state); F9 color = `[0x830]` `@COLORS` |
| [`ui/popups.md`](ui/popups.md) | ~24 popups | **B** (framework: 10 live directives, channels, Lost-City map, raid=6, `@width`/`@x`/`@y`; FONTTINY latch) | body/highlight color push is overlay-resident (A/TBD) |
| [`ui/menus.md`](ui/menus.md) | menus / setup / Hall of Fame | **B** (boot items `@BEGINMENU`, plaque geom, HoF) | save-slot count; per-axis widget geom (overlay); LEVN grid |
| [`ui/cinematics.md`](ui/cinematics.md) | cinematics / score | **B** in-VICEROY painters (king-defeats = sole FONTKING user, pen (242,47); score FONTTINY+FONTINTR; DECOIND) | OPENING/CLOSING frame timing (separate binaries); king-text RGB = engine fg latch (A) |
| [`ui/context_dialogs.md`](ui/context_dialogs.md) | order/trade/village/diplomacy/build menus | **B** (framework, `@width`, native gating `func_04B308`, build-avail `func_0B900`; `@BUILDING` 12-byte BSS record from NAMES) | `@BUILDING` CSV-column→field mapping (R) |
| [`ui/fonts_and_colors.md`](ui/fonts_and_colors.md) | **shared font + color model** (4 loaded `.FF` fonts + FONTSMAL orphan; FONTKING = king-defeats only; palette-index color args → exact RGB) | **B** (font loads, color push-args, RGB via decoded PIK palette) | none (only palette *cycling* is animation) |

**Fonts & colors** are captured in [`ui/fonts_and_colors.md`](ui/fonts_and_colors.md): the **four
loaded** bitmap fonts (FONTTINY/FONTINTR/FONTKING/FONT-NP, byte-cited loads; FONTSMAL is an
unloaded orphan; FONTKING is used by the king-defeats screen only) and the color model
— every text/fill color is an **explicit palette-index argument** (**B**) whose **exact RGB is
also static**, resolved by decoding that screen's PIK palette (a 768-byte file section). So color
is fully **B**, *not* a runtime/capture residual.

Primary UI sources: `ghidra_export/VICEROY_decompiled.named.c`, `raw/COLONIZE/VICEROY.EXE`,
`docs/SESSION_UI_CATALOG.md`, `docs/RENDERER_GEOMETRY.md`, `docs/UI_DIALOGS.md`,
`docs/POPUP_TEMPLATE_AUDIT.md`, `docs/KING_AND_CINEMATIC_AUDIT.md`, `docs/COLONY_RENDER_CHAIN.md`,
`viceroy_source/docs/drawlist/REPORTS.md`. (Note: `docs/ADVISOR_REPORTS_AUDIT.md` paint-function
offsets are superseded — see `notes/rulings/RULINGS.md` 2026-06-21.)

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
