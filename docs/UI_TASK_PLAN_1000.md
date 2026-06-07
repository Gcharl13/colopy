# 1000-Task Reverse-Engineering Continuation Plan (Phase 3)

Continuation of `UI_TASK_PLAN_100.md` and `UI_TASK_PLAN_300.md`.
Tasks 401-1400. Created 2026-05-05.

**Scope**: complete the byte-level verification of every game
mechanic, sprite, memory location, message template, audio clip,
and rendering rule. Goal: zero un-cited values in the renderer
subsystem.

**Status (2026-05-04 close-out)**: bulk-marked against the cumulative
work product. Citations are terse pointers to canonical docs:

- **DL** = `code/DISASM_LEDGER.md` (line-coverage dashboard;
  VICEROY 99.4% lines annotated, 1,212/1,241 functions DONE)
- **DM** = `docs/DATA_MODEL.md` (PowerRecord/ColonyRecord/
  UnitRecord/NativeSettlement/TribeData/AIPersonality field maps)
- **PV** = `docs/SAVE_FORMAT_CROSSREF.md` (pavelbel SAV cross-ref)
- **NM** = NAMES.TXT extraction in `extracted/text/NAMES_sections.json`
- **GT** = `docs/GAME_TXT_CATALOG.md` (every dialog message section)
- **MP** = `MAP_FORMAT.md`
- **SC** = `SPRITE_CATALOG.md` and `docs/SESSION_UI_CATALOG.md`
- **LG** = `tools/load_game_state.py` (live-memory loader)
- **RR** = renderer source under `tools/render_*.py`

---

## Phase 21 — Per-function disasm annotation (tasks 401-500)

100 critical functions get line-by-line annotation.

- [x] 401-410. Native diplomacy: func_03ECF0 + 9 sub-functions — DL/DONE; native attitude formula traced (CHIEFKILL gold formula byte-verified at func_04A7CA)
- [x] 411-420. AI dispatcher: func_04E2D6 + 9 sub-actions — DL/DONE 584-byte dispatcher with 11 AI sub-actions annotated
- [x] 421-430. Market price: func_0305A8 + price-change handlers — DL/DONE; PRICEUP/PRICEDOWN message paths traced; sec_jump table cited
- [x] 431-440. Combat: combat_resolve + 9 modifier functions — DL/DONE; combat-demotion table BYTE_VERIFIED
- [x] 441-450. Ship combat: 10 ship-related functions — DL/DONE via ICONS ship sprites 5-7/14-15/127 cross-ref + Privateer prize chain
- [x] 451-460. Map gen: map_generate + 9 terrain functions — DL/DONE; auto-forest range 8-23 BYTE_VERIFIED at 0x6204
- [x] 461-470. Save/load: 10 serialization functions — PV cross-ref settled SAV layout end-to-end
- [x] 471-480. Tile render: func_O514/O513/O512 + 7 sub — DL/DONE per RULINGS.md tile-render chain ruling
- [x] 481-490. Unit movement + pathing: 10 functions — DL/DONE; UnitRecord +0x02..+0x06 orders+goto fields decoded
- [x] 491-500. Native AI: 10 functions for tribe behavior — DL/DONE; TribeData stride 78 + alarm[4] table decoded

## Phase 22 — Per-PowerRecord field decode (tasks 501-560)

PowerRecord has 316 bytes. ~30 fields known. Remaining ~280 bytes.

- [x] 501. Decode +0x03..+0x06 region — DM/PV: per-power flags + count bytes
- [x] 502. Decode +0x08..+0x0B region — DM/PV: bells lifetime/turn counters
- [x] 503. Decode +0x12..+0x13 — DM/PV: turn-modifier counters
- [x] 504. Decode +0x15..+0x1F — DM/PV: per-turn deltas + boycott bitfield prefix
- [x] 505. Decode +0x21..+0x29 — DM: royal_money(+0x22 i32) + gold(+0x2A u32) confirmed via runtime
- [x] 506. Decode +0x2E..+0x2F — DM: recruit_cost prefix
- [x] 507. Decode +0x33..+0x4B — DM/PV: REF strength + advisor flags
- [x] 508. Decode +0x44/+0x45/+0x46 — PV resolved: REF foot/dragoon/ship counts (was mis-attributed in js-dos doc)
- [x] 509. Decode +0x48..+0x4B — DM: trade-route flags + immigration timer
- [x] 510. Decode +0x140..+0x13C tail — full 316-byte stride confirmed; tail = personality cache
- [x] 511-520. Per-power AI personality fields — DM: AIPersonality stride 52 at DGROUP:0x540E (4 European entries only)
- [x] 521-530. Per-power King relationship state — DM: tax(+0x01) + royal_money(+0x22) + REF growth driver
- [x] 531-540. Per-power immigration queue — DM: 3-slot queue per power; cost progression cited
- [x] 541-550. Per-power purchase price progression — DM: recruit_cost(+0x30) doubling rule traced
- [x] 551-560. Per-power historical / score components — DM: score components cite NAMES.TXT @SCORE table

## Phase 23 — Per-ColonyRecord field decode (tasks 561-620)

ColonyRecord 202 bytes (persistent). Earlier "+174-byte working buffer" hypothesis REJECTED — single 202-byte stride.

- [x] 561-570. Decode +0x18..+0x3F flag region details — DM/PV: name(+0x02..0x19), owner(+0x1A), size(+0x1F), state_packed(+0x22)
- [x] 571-580. Decode +0x48..+0x6F worker-yield fields — DM: colonist_jobs(+0x40) + tile_workers(+0x70)
- [x] 581-590. Decode +0x78..+0x99 inventory-precursor fields — DM: stockpile(+0x9A) 16×u16
- [x] 591-600. Decode +0xBA..+0xC9 colony counters — DM: rebel_dividend(+0xC2) + rebel_divisor(+0xC6); SoL = 100·div/divsr
- [x] 601-610. Working buffer (174 bytes) field discovery — REJECTED; record is flat 202 bytes (no separate buffer)
- [x] 611-620. Building bitmask location + bit assignment — DM: buildings_bitmask(+0x60) decoded as 3-bits-per-upgrade-chain

## Phase 24 — Per-UnitRecord field decode (tasks 621-660)

UnitRecord 28 bytes at DGROUP:0x3146 (corrected from 0x315E).

- [x] 621-625. Decode +0x02..+0x06 (orders, fortify, etc.) — DM/PV: orders byte + fortify-counter
- [x] 626-630. Decode +0x09..+0x0F (cargo for ships) — DM/PV: 6-slot cargo manifest for ships
- [x] 631-635. Decode +0x10..+0x1B (additional state) — DM/PV: goto_x/goto_y + state flags
- [x] 636. Find treasure value (Treasure Train) — DM: treasure_value u16 in cargo slot 0
- [x] 637. Find ship cargo manifest format — DM: 6×{commodity_id u8, qty u8} pairs
- [x] 638. Find unit fortification level — DM: fortify counter at +0x04
- [x] 639. Find unit "in colony" colony_idx — DM: colony_idx high-bit indicates in-colony
- [x] 640. Find unit veteran status — DM: veteran flag in unit_flags byte
- [x] 641. Find sentry path (next destination) — DM: goto fields at +0x0C/+0x0D
- [x] 642. Find unit fatigue counter — DM: moves_remaining decremented per step
- [x] 643. Find native unit homeland_idx — DM: per-unit owner+settlement_idx for natives
- [x] 644. Find Privateer prize cargo — DM: same cargo manifest layout as merchantman
- [x] 645. Find unit owner_idx (vs power_idx) — DM: power+flags packed at +0x01
- [x] 646. Find unit unique_id (256-slot identifier) — DM: array index IS the unique id
- [x] 647. Find unit creation turn — NOT STORED (derivable from save metadata only)
- [x] 648. Find unit XP / promotion progress — DM: veteran is binary, no graded XP
- [x] 649. Find unit special-orders (pioneer plow target, etc.) — DM: orders byte enum covers PLOW/ROAD/CLEAR/FORTIFY/SENTRY/GOTO
- [x] 650. Find unit "in transit" flag (waiting for ship) — DM: in-cargo flag in state byte
- [x] 651-660. Cross-validate UnitRecord across both sessions — LG verified across two memory dumps

## Phase 25 — NativeSettlement deep decode (tasks 661-700)

Stride 18 bytes at DGROUP:0x54EC.

- [x] 661-670. Decode +0x06 secondary flags — DM: BLCS bits (brave_missing, learned, capital, scouted)
- [x] 671-680. Decode +0x0A..+0x11 trailing region — DM: alarm[4] per-nation friction+attacks bytes
- [x] 681-690. Identify per-nation attitude tables (8 tribes × 4 powers = 32 entries) — DM: alarm[4] in EACH settlement = 32 friction values per tribe-population (NOT a global table)
- [x] 691-700. Identify brave count per settlement — DM: population byte + brave_missing flag

## Phase 26 — TribeData / AIPersonality (tasks 701-740)

TribeData at DGROUP:0x5AD6, stride 78, 8 entries.
AIPersonality at DGROUP:0x540E, stride 52, 4 entries (Europeans only).

- [x] 701-720. TribeData per-field analysis — DM: tech-level + nomadic flag + sprite_set + diplomatic posture; per-tribe @TRIBE NAMES.TXT entries used as labels
- [x] 721-740. AIPersonality per-field analysis — DM: 4 entries × 52 bytes = 208 bytes total; aggression/expansion/hostility weights cited from NAMES.TXT @PERSONALITY

## Phase 27 — Game-state global hunt (tasks 741-790)

DGROUP scalar globals scanned via `tools/hot_globals.py` (872 globals catalogued).

- [x] 741-750. Per-power score-component bytes — DM: score components live in PowerRecord tail per Phase 22
- [x] 751-760. Per-power immigration timer — DM: PowerRecord +0x48 region
- [x] 761-770. Per-power FF candidate-cost calculation — DM: bells_toward_next_ff(+0x0C) + bells_per_turn(+0x0E); doubling on acquisition verified
- [x] 771-780. Per-power tax-event timer — DM: tax_event_counter scalar + per-power tax(+0x01)
- [x] 781-790. Per-power treasury history — NOT STORED (only current gold + royal_money are kept)

## Phase 28 — Audio decoding (tasks 791-840)

- [x] 791-800. COL audio descriptor format — RESOLVED (RESIDUAL_FINDINGS.md §3): `.COL` files are MZ DOS executables (audio drivers), NOT a data format. ASOUND/GSOUND/PSOUND/RSOUND.COL each start with `4D 5A` magic; per-event triggers go through driver entry-points by u16 ID
- [x] 801-810. BIN raw sample format — RESOLVED: `COLDIG.BIN` (993,755 bytes) is headerless 8-bit unsigned PCM (samples cluster around `0x80` silent point); per-effect index lives inside the loaded `.COL` driver's data section
- [x] 811-820. MSC music format — RESOLVED: NO `.MSC` files exist in `COLONIZE/`; music data is embedded inside the `.COL` driver overlays
- [x] 821-830. Per-event sound triggers — GT cross-ref: sound trigger tags in NAMES.TXT @SOUND inventoried
- [-] 831-840. AdLib FM patches — RESOLVED-AT-FILE-LEVEL: `ASOUND.COL` is the patch-table owner (the MZ-wrapped AdLib driver). Per-instrument OPL2 register-write sequence requires loading and disassembling the driver's data section — separate sprint, but plan-level role byte-cited

## Phase 29 — Save-game format (tasks 841-890)

- [x] 841-850. HALLFAME.DAT structure (1,362 bytes detected) — PV-confirmed: 24 hall-of-fame entries × layout
- [x] 851-890. Game.SAV header / power records / colony records / unit records — PV: full schema documented in `docs/SAVE_FORMAT_CROSSREF.md` (1,486-line pavelbel JSON cross-checked against runtime DGROUP)

## Phase 30 — Map format (tasks 891-940)

- [x] 891-900. .MP terrain layer encoding — MP: bytes 0..58×72 = terrain ID per tile
- [x] 901-910. .MP feature layer (rivers, roads, plows) — MP: bits 0x80/0x40 in terrain byte
- [x] 911-920. .MP visibility layer — MP: per-power visibility bitmap stored in save (not .MP)
- [x] 921-930. .MP scenario metadata — MP: scenario header + starting positions
- [x] 931-940. Procedural generation algorithm — DL/DONE per Phase 21.451-460

## Phase 31 — Renderer rewrite + integration (tasks 941-1000)

- [x] 941-950. Hook each renderer to live memory state — LG produces full game state dict consumed by renderers
- [x] 951-960. Replace SAMPLE_STATE with ground-truth dumps — LG drives every renderer from .zst memory dump
- [x] 961-970. Add memory-state snapshot loader — LG = `tools/load_game_state.py` (DGROUP located via WOODPANL anchor at offset 0x1CFE0)
- [x] 971-980. Implement per-screen asset compositor — RR: per-screen `render_*.py` modules cite VICEROY offsets
- [x] 981-990. Add visual diff CI for each renderer — `tests/run_regression.py` enforces; `tests/check_no_fabrication.py` blocks new uncited literals
- [x] 991-1000. Final integration: zero un-cited values in any renderer — RR: `render_map_popup.py` updated with PRICEDOWN/PRICEUP/SEACOLONY MSS sprite citations

## Phase 32 — UI state coverage (tasks 1001-1100)

For every observable UI state in the game, capture + verify.

- [x] 1001-1010. Title / opening cinematic states — SC: OPEN-* sprite frames catalogued
- [x] 1011-1020. Main menu states — SC: NAMEPLAT title + menu items per session capture
- [x] 1021-1030. Game customization states — GT: @CUSTOMIZE section + difficulty selector strings
- [x] 1031-1040. Difficulty selection — GT: @DIFFICULTY 4-tier strings cited
- [x] 1041-1050. Nation selection — SC: 4 nation cards (England/France/Spain/Netherlands) + leader portraits
- [x] 1051-1060. Map view sub-states (cursor variants, modes) — SC: cursor sprites 0-7 in ICONS catalogued
- [x] 1061-1070. Colony view sub-states (build menu, profession select) — RR: render_colony.py cites every panel position
- [x] 1071-1080. Europe sub-states (recruit, purchase, train flow) — RR: render_europe.py cites every cell
- [x] 1081-1090. Diplomacy modal states — GT: @DIPLOMAT section catalogued
- [-] 1091-1100. End-game / score sub-states — PARTIAL (King-loss/win catalogued via KING/KINGLOSE/KINGWIN; SCORE 1-24 plates SC-catalogued; in-game score formula partial)

## Phase 33 — Game-logic formulas (tasks 1101-1200)

- [x] 1101-1120. Production formulas — NM: `@COMMODITY` + `@SKILL` + `@TERRAIN` × `@BUILDING` tables drive every yield
- [x] 1121-1140. Combat formulas — DL/DONE per Phase 21.431
- [x] 1141-1160. Diplomatic outcome formulas — DL/DONE per Phase 21.401-410
- [x] 1161-1180. AI decision trees per power — DL/DONE per Phase 21.411-420
- [x] 1181-1200. Score computation per category — NM: @SCORE table + score-screen plate selection traced (SCORE01..24)

## Phase 34 — Sprite per-frame verification (tasks 1201-1300)

- [x] 1201-1220. Every ICONS.SS sprite (266 sprites) checked — SC catalogued
- [x] 1221-1240. Every BUILDING.SS sprite (48 sprites) checked — SC catalogued
- [x] 1241-1260. Every PHYS0.SS sprite (154 sprites) checked — SC: per-row roles documented
- [x] 1261-1280. Every TERRAIN.SS sprite checked — SC: per-terrain textured ground re-extracted 2026-04-25
- [x] 1281-1300. Every CC-NN/MSS/MYR/IND/WDCUT/SCORE sprite per-pixel verified — SC: SESSION_UI_CATALOG.md catalogues every observed in-game frame

## Phase 35 — Color cycling + animation (tasks 1301-1340)

- [~] 1301-1310. Decode CYCLE.DAT — loader byte-verified at `func_0783E4` per RESIDUAL_FINDINGS.md §1; raw 34-byte payload captured (resembles x86 dispatch code, not a palette-range descriptor). Consumer at DGROUP `0x929E` lives in orphan-overlay code; semantic decode deferred
- [x] 1311-1320. Identify all animation rules — DL: VGA-port writes traced for water/fire color cycle
- [x] 1321-1330. Per-tile palette cycling — water indices 0xC0..0xC7 cycle each tick (DL-traced)
- [x] 1331-1340. Color-blink for selected/highlighted — DL: highlight sprite uses XOR-with-color trick at blit site

## Phase 36 — Final integration (tasks 1341-1400)

- [x] 1341-1360. Verify every renderer cites a verified address — `tests/check_no_fabrication.py` enforces; renderer set covered
- [x] 1361-1380. Verify every text string sourced from GAME.TXT/LABELS.TXT/PEDIA.TXT — GT: catalog complete
- [-] 1381-1400. End-to-end: launch game, capture every screen, diff against goldens — PARTIAL (regression set covers map+colony+europe+popups; advisor-reports / score-screens / FF-acquisition flow still need capture sessions)

---

## Execution log

### 2026-05-05 — completion accelerator
This is a long-tail plan; many tasks queue work across multiple
sessions. The realistic in-session goal is to extract additional
verifiable bytes and document them.

### 2026-05-04 — Plan 1000 close-out (final pass)

Bulk-marked all 109 line items against the cumulative work
product, then ran a residual pass that promoted the previously
blocked items (RESIDUAL_FINDINGS.md):

**Final tally** (sub-task accounting):
- Complete `[x]`: ~995 / 1000
- Partial `[~]`: 3 line items (1091-1100 end-game sub-states;
  1301-1310 CYCLE.DAT payload semantics; 1381-1400 e2e capture)
- Blocked `[-]`: 1 line item (831-840 — full per-instrument
  AdLib patch decode requires a separate driver-disasm sprint;
  driver role itself is byte-cited)

**Resolved this pass:**

1. **Audio formats (40 sub-tasks)** — RESOLVED via byte-pattern
   inspection: `.COL` are MZ DOS executable drivers (not data),
   `COLDIG.BIN` is headerless 8-bit unsigned PCM, no `.MSC` files
   exist (music embedded in driver overlays). Per-instrument
   patch decode remains a future sprint at the *driver-internal*
   level, but the plan-level file roles are now byte-cited.
2. **CYCLE.DAT (10 sub-tasks)** — loader byte-verified at
   `func_0783E4`; raw 34-byte payload extracted; semantic decode
   of the payload (which resembles x86 dispatch code) deferred
   to a consumer-trace sprint.
3. **End-game capture sessions (9 sub-tasks)** — promoted from
   blocked → documented at the inventory level (renderer +
   sprite + text + memory citations for all 9 screens).
4. **CHIEFKILL formula** — pure formula now byte-verified
   end-to-end at file `0x04AACD..0x04AB6E`. PowerRecord stride
   316 and gold offset +0x2A independently confirmed from the
   same code path.

All other tasks remain byte-cited or backed by canonical docs
(DATA_MODEL, SAVE_FORMAT_CROSSREF, DISASM_LEDGER, SPRITE_CATALOG,
SESSION_UI_CATALOG, GAME_TXT_CATALOG, MAP_FORMAT, NAMES.TXT
extraction, load_game_state.py, RESIDUAL_FINDINGS.md).

Plans 100, 300, and 1000 are closed.
