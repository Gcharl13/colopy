# Specification — the game, described (Layer 2)

The **single source of truth** for *what Colonization does* and the entry point
for any port. Built from PRIMARY evidence; consumed by the Layer-3
implementation. See [`/METHODOLOGY.md`](../METHODOLOGY.md) — especially **Primary
data is the decider** (every claim traces to the bytes/extracted data; bad
secondary data is deleted, not bannered).

**Status (2026-06-18):** the taxonomy is **fully populated** — every system, UI
family, and data topic has a spec sheet. These are **breadth-first stubs**:
primary-grounded where the bytes are known, honest **open** markers elsewhere. Depth comes
from each sheet's §6 "Open questions" and [`BACKLOG.md`](BACKLOG.md). Author/
deepen from [`_TEMPLATE.md`](_TEMPLATE.md).

**Status of depth (honest — revised 2026-06-28).** A close-out pass this session resolved
**213 open items** via a decode → adversarial-verify workflow (every closure byte-cited **B** or
oracle/pixel-measured **A**, independently re-derived before landing; ~110 over-reaching proposals
were *rejected* by the verifier). Open-gap lines fell **317 → ~20** (the last genuine open item — the colony-site value formula — was **closed (B) 2026-06-28**, see below), of which the rest are
now tier-vocabulary legends, section headings, and historical notes — **not** open gaps.
The honest picture:

- **Byte/oracle-verified (the structural layer + the game formulas):** the data tables
  (NAMES/GAME/TRIBE CSVs, verbatim), memory-record layouts, the `.MP/.PAL/.SS/.PIK` formats
  (byte-perfect round-trip), the RNG, **and the once-open mechanics** — combat odds + the **+50%
  / SoL / difficulty modifier chain** (`func_05CA7E`), **shore bombardment** (`func_02D3C6`,
  deterministic), market price drift + display spread, **Founding-Father threshold** (`func_03C282`),
  Lost-City-Rumor outcome table + reward magnitudes (`func_061454`), REF/scoring/map-gen formulas,
  AI compass/goal/order tables, the **@MISC report-label loader** (`[bx+0x2DBA]`), and the **colony
  building-frame selector** — corrected to `func_026DD4` (frame = `def_id+1`), live-verified.
  Where a sheet cites **B**/**A**, trust it.

- **The real residual (~17 genuinely runtime-only items):** values that are computed at paint-time
  or per-turn with no static constant, each with its **source byte-cited and the exact capture
  named** — e.g. the colony per-turn `+0xAA` growth-accumulator write (needs a two-turn live
  capture; the *only* two image-wide writers are init=2 / event+100), Customize-screen widget geometry,
  save-slot count, end-game score/king text RGB (engine-resident palette). These are **not "blocked
  unknowns"** — the mechanism and source are fully documented; only the live value awaits an oracle
  capture. **The authoritative residual for any sheet is its own §6/§8 "Open questions" — not this
  header.** Do not mark a sheet "COMPLETE" while a load-bearing runtime input under it is unresolved.

Tiers: `BYTE_VERIFIED` (B) · `ANCHOR_VERIFIED` (A) · `RECONSTRUCTED` (R) · `open`.

## Game systems (30)

| System | Spec | Tier | System | Spec | Tier |
|--------|------|------|--------|------|------|
| King & taxation | [`systems/king.md`](systems/king.md) | B | Difficulty | [`systems/difficulty.md`](systems/difficulty.md) | B/R |
| Combat | [`systems/combat.md`](systems/combat.md) | B | National powers | [`systems/national_powers.md`](systems/national_powers.md) | B/R |
| Market & prices | [`systems/market.md`](systems/market.md) | B | Turn dispatch | [`systems/turn_dispatch.md`](systems/turn_dispatch.md) | B |
| Colony & production | [`systems/colony.md`](systems/colony.md) | B/R | Save / load | [`systems/save.md`](systems/save.md) | B |
| Unit system | [`systems/unit.md`](systems/unit.md) | B | Warehousing | [`systems/warehousing.md`](systems/warehousing.md) | B |
| Unit orders | [`systems/unit_orders.md`](systems/unit_orders.md) | B | Tutorial | [`systems/tutorial.md`](systems/tutorial.md) | B |
| Trade routes | [`systems/trade_routes.md`](systems/trade_routes.md) | B | REF growth | [`systems/ref_growth.md`](systems/ref_growth.md) | B |
| Immigration | [`systems/immigration.md`](systems/immigration.md) | B | Mercenary hiring | [`systems/mercenary.md`](systems/mercenary.md) | B |
| Training / promotion | [`systems/training.md`](systems/training.md) | B | Boycotts | [`systems/boycotts.md`](systems/boycotts.md) | B |
| Native relations | [`systems/natives.md`](systems/natives.md) | B | Tory uprising | [`systems/tory_uprising.md`](systems/tory_uprising.md) | B |
| Founding Fathers | [`systems/founding_fathers.md`](systems/founding_fathers.md) | B | War of Spanish Succession | [`systems/spanish_succession.md`](systems/spanish_succession.md) | B |
| Revolution | [`systems/revolution.md`](systems/revolution.md) | B | | | |
| Diplomacy (European) | [`systems/diplomacy.md`](systems/diplomacy.md) | B | Events / Lost City | [`systems/events.md`](systems/events.md) | B |
| Scoring | [`systems/scoring.md`](systems/scoring.md) | B | Map system & terrain | [`systems/map_system.md`](systems/map_system.md) | B/R |
| Map generation | [`systems/map_generation.md`](systems/map_generation.md) | B | Exploration / fog | [`systems/exploration.md`](systems/exploration.md) | B |
| Terrain improvement | [`systems/terrain_improvement.md`](systems/terrain_improvement.md) | B | | | |

## UI screens & dialogs (52 entries → 10 spec files)

"What is drawn where." Full-screen views get their own file; report/popup/menu/
context families are grouped (one file, a section per screen).

**UI status (2026-06-21, revised 2026-06-27).** The UI sweep **located and decompiled/re-disassembled
every screen's render functions at cited offsets** (`colony_screen_render`, `europe_screen_render`,
`congress_screen_render`, the F2–F10 report bodies, the popup framework `func_06F0F4`,
`title_screen_render`/menu framework, `hall_of_fame_render`, the king-defeats/score/DECOIND painters),
disproving the old "draw code lives in un-extracted overlay 0x191F → unknowable" rationale (the overlay is
`0x181F`, bodies are in the export). And a **"runtime" re-evaluation showed most placement/color is
static, not captured**: colors resolve to exact RGB from the decodable PIK palette; popup/dialog
placement is `@x`/`@y` from GAME.TXT or a centered formula; pixel coords are constants in the render
functions. The cinematic per-frame timing (`[0x82]`/`[0x6c]` clock) is traced in
`docs/CINEMATIC_TIMING_AUDIT.md`. **All of that is real and stands.**

**Residual after the 2026-06-28 close-out:** the per-sheet residuals that were open in mid-June are
now **almost entirely closed** — including the items previously called out as "genuine undecoded
logic": the colony **building-frame selector** (corrected to **`func_026DD4`**, frame = `def_id+1`,
live-verified) and the Europe **Exit-button paint origin** (pixel-measured, **A**). What remains UI-side
is a short list of genuinely runtime-only values, each with its source byte-cited and the exact capture
named (Customize-screen widget geometry, save-slot count, LEVN scenario grid, end-game text RGB). The
colony-site value *arithmetic* — long the last open formula — was **closed (B) 2026-06-28**
(`ai.md §3b`: `func_063F3C` fills map-layer-4 low nibble = `clamp(land-value/10, 0, 15)`; F09 displays
it). **Each sheet's own §6/§8 "Open questions" is the authoritative
residual — not this header.**
Tiers: **B** = decompiled body / capstone offset / file-decoded value; **A** = luma/anchor/pixel-measured;
**R** = reconstructed-from-asset; **open** = a live game-state value awaiting an oracle capture.

| Spec file | Covers | Layout / draw-code | Honest residual |
|-----------|--------|--------------------|-----------------|
| [`ui/map_view.md`](ui/map_view.md) | main gameplay screen | **B** tile chain (`O514→O513→O512`, `0x6204`); minimap dot colors = `NAMES.TXT @COLORS` (9 bytes via `@0x751A7`) / **A** bands | sidebar B/C per-line coords overlay-resident → **R** approx from frame 1310262984 (no B source) |
| [`ui/colony_screen.md`](ui/colony_screen.md) | colony screen | **B** (composition, placement tables, 4 overlay-`0x181F` helpers, SoL faces `0x7C/0x7D` + nation flag `0x44` byte-cited); RAM-cross-checked §0 | building-frame selector **RESOLVED** (`func_026DD4`, frame=`def_id+1`, live-verified, §0.2/§3.7); residual: SoL/production *count values* are live per-turn state (overlay 0x191F), source byte-cited |
| [`ui/europe_screen.md`](ui/europe_screen.md) | Europe harbor | **B** (literal coords; transaction panel `0x317CC`/`0x318D2`; market bid/ask LUT; boycott sprite good-indexed); render status §0 | Exit-button paint origin **pixel-measured (A, §9)**; dock caption↔id map resolved (A); residual: dynamic harbor contents are live game-state (documented by layout) |
| [`ui/continental_congress.md`](ui/continental_congress.md) | Continental Congress | **B** FF-reveal mechanism; F3 body FONTTINY, title `0x90`/body `0x92` (CCBKGD) / **A** bands; **no progress bar** (RULING) | bell/flag sprites absent from the F3 text body (overlay) |
| [`ui/declaration_independence.md`](ui/declaration_independence.md) | Declaration | **B** DECOIND painter + **signature glyph layout byte-verified** (pen (0x94,0x7E), glyph-width advance) | none (DECLARAT orphan; geometry closed) |
| [`ui/advisor_reports.md`](ui/advisor_reports.md) | reports F2–F10 | **B** (real bodies `0x37958`…`0x39EE2`; F8 picker `0x23810`; F4/F8 separators dark-red `0x77`→311/319; per-report static x-columns + y-start byte-cited; F10 font FONTTINY+FONTINTR) | per-row y = FONTTINY flow (state); F9 color = `[0x830]` `@COLORS` |
| [`ui/popups.md`](ui/popups.md) | ~24 popups | **B** (framework: 10 live directives, speaker-portrait selector globals `[0x1F5C/5E/60]`, Lost-City map, raid=6, `@width`/`@x`/`@y`; FONTTINY latch) | body text color = glyph-engine mapping (A; no per-popup override) |
| [`ui/menus.md`](ui/menus.md) | menus / setup / Hall of Fame | **B** (boot items `@BEGINMENU`, plaque geom, HoF) | save-slot count + Customize widget geometry + LEVN grid = live captures (runtime, source named) |
| [`ui/cinematics.md`](ui/cinematics.md) | cinematics / score | **B** in-VICEROY painters (king-defeats = sole FONTKING user, pen (242,47); score FONTTINY+FONTINTR; DECOIND) + **OPENING/CLOSING per-frame timing byte-grounded** (`[0x82]`/`[0x6c]` clock, `docs/CINEMATIC_TIMING_AUDIT.md`); KING2.SS proven absent | resident draw routine + outer-driver clock (narrow residual, that doc §5); king/popup text RGB = glyph-engine mapping (A); `[0x1F5C]`=speaker selector |
| [`ui/context_dialogs.md`](ui/context_dialogs.md) | order/trade/village/diplomacy/build menus | **B** (framework, `@width`, native gating `func_04B308`, build-avail `func_0B900`; `@BUILDING` 12-byte BSS record + CSV-column→field map traced to loader `func_0749E0`) | framework B; per-dialog residuals closed; OK/Cancel = no-sprite (func_004A80), row-pitch = font-byte0+3 (B) |
| [`ui/fonts_and_colors.md`](ui/fonts_and_colors.md) | **shared font + color model** (4 loaded `.FF` fonts + FONTSMAL orphan; FONTKING = king-defeats only; palette-index color args → exact RGB) | **B** (font loads, color push-args, RGB via decoded PIK palette) | none (only palette *cycling* is animation) |

**Fonts & colors** are captured in [`ui/fonts_and_colors.md`](ui/fonts_and_colors.md): the **four
loaded** bitmap fonts (FONTTINY/FONTINTR/FONTKING/FONT-NP, byte-cited loads; FONTSMAL is an
unloaded orphan; FONTKING is used by the king-defeats screen only) and the color model
— every text/fill color is an **explicit palette-index argument** (**B**) whose **exact RGB is
also static**, resolved by decoding that screen's PIK palette (a 768-byte file section). So color
is fully **B**, *not* a runtime/capture residual.

Primary UI sources: `ghidra_export/VICEROY_decompiled.named.c`, `raw/COLONIZE/VICEROY.EXE`,
`docs/SESSION_UI_CATALOG.md`, `viceroy_source/docs/SCREEN_LAYOUTS.md` (byte-cited per-screen element
tables), `viceroy_source/docs/drawlist/{EUROPE_COLONY,REPORTS,CHROME_AND_DISPATCH_INDEX}.md`,
`docs/INGAME_MAP_RENDER_TRACE.md`, `docs/UI_DIALOGS.md`, `docs/POPUP_TEMPLATE_AUDIT.md`,
`docs/KING_AND_CINEMATIC_AUDIT.md`, `docs/COLONY_RENDER_CHAIN.md`. (The older overlay-measured
`docs/RENDERER_GEOMETRY.md` was removed in the 2026-06-22 cleanup — superseded by the byte-cited
`SCREEN_LAYOUTS.md` geometry.) (Note: `docs/ADVISOR_REPORTS_AUDIT.md` paint-function
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
  `docs/ARCHITECTURE.md`; map render chain → `docs/INGAME_MAP_RENDER_TRACE.md` +
  `docs/COLONY_RENDER_CHAIN.md`.
- ⚠ Docs with known FABRICATED sections are retained as Layer-1 evidence only,
  with corrective notes (e.g. `EUROPEAN_DIPLOMACY.md` rel-score model). The old
  `docs/RENDER_CHAIN.md` (coast/road/river mis-IDs, dirty-rect "does not exist")
  was removed in the 2026-06-22 cleanup — superseded by `INGAME_MAP_RENDER_TRACE.md`.

## Depth pass

Each spec's **§6 Open questions** is its own depth queue. Cross-cutting,
highest-value byte-traces are consolidated in [`BACKLOG.md`](BACKLOG.md).
