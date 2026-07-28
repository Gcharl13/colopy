# UI documentation index

Master cross-reference for all UI / asset / memory documentation
created during the session-driven analysis (sessions 12, 1777952458,
1777955389). Created 2026-05-05.

---

## Top-level catalogs

| Doc | Purpose | Verified by |
|-----|---------|-------------|
| [`SESSION_UI_CATALOG.md`](SESSION_UI_CATALOG.md) | Master sprite + UI state catalog with frame references | Direct .png inspection of every sprite + frame analysis |
| [`UI_TASK_PLAN_100.md`](UI_TASK_PLAN_100.md) | 100-task UI resolution plan with progress tracking | — |
| `spec/ui/*` (dialog_framework.md, render_primitives.md, fonts_and_colors.md) | Pixel-coordinate spec for every UI element | *(the former RENDERER_GEOMETRY.md never existed — dangling link removed 2026-07-28)* |
| [`SCREEN_ASSET_REQUIREMENTS.md`](SCREEN_ASSET_REQUIREMENTS.md) | Per-screen list of required sprites + text + memory | Cross-reference of catalogs |

---

## Game data text-file catalogs

| Doc | Source | Sections |
|-----|--------|---------:|
| [`GAME_TXT_CATALOG.md`](GAME_TXT_CATALOG.md) | `COLONIZE/GAME.TXT` | 510 message templates |
| [`LABELS_TXT_CATALOG.md`](LABELS_TXT_CATALOG.md) | `COLONIZE/LABELS.TXT` | 7 sections, ~290 labels |
| [`PEDIA_TXT_CATALOG.md`](PEDIA_TXT_CATALOG.md) | `COLONIZE/PEDIA.TXT` | 163 indexed entries |
| [`GAME_INDEX_TABLES.md`](GAME_INDEX_TABLES.md) | All three above | Master index mapping |

---

## Memory-byte verification

| Doc | What it documents |
|-----|-------------------|
| [`DATA_MODEL.md`](DATA_MODEL.md) | All known DGROUP layouts (PowerRecord, ColonyRecord, NativeSettlement, UnitRecord, TribeData) |
| [`CAPITAL_BONUS_ANALYSIS.md`](CAPITAL_BONUS_ANALYSIS.md) | Capital raze gold formula derivation from 2 user data points |

---

## Session-specific traces

| Doc | Game session |
|-----|--------------|
| [`../session-12/SESSION_RUNTIME_TRACE.md`](../session-12/SESSION_RUNTIME_TRACE.md) | session-12 (112 snaps) cross-validated with session_1777952458 (396 snaps) |

---

## Visual reference assets

| Asset directory | Count |
|-----------------|------:|
| `assets/sprites/CC-00..24/` | 25 founding fathers |
| `assets/sprites/MSS0..5/` | 6 half-figure speakers |
| `assets/sprites/MYR0..3/` | 4 half-figure speakers |
| `assets/sprites/IND0..7 + A0..A3/` | 8 tribes × 4 poses |
| `assets/sprites/WDCUT01..13/` | 13 event scenes |
| `assets/sprites/SCORE01..24/` | 24 score milestones |
| `assets/sprites/KING + KING1/2 + KINGLOSE/WIN/` | 5 king variants |
| `assets/sprites/{ENGLND,FRANCE,SPAIN,DUTCH}1+2/` | 8 nation flags |
| `assets/sprites/DEC-{LOWA..Z, UPPA..Z, SQIG}/` | 53 cursive letters |
| `assets/sprites/CURSOR/` | 2 cursor variants |
| `assets/sprites/BUILDING/` | 48 building sprites |
| `assets/sprites/ICONS/` | 266 unit/commodity/UI sprites |
| `assets/sprites/PHYS0/` | 154 terrain overlays |
| `assets/sprites/TERRAIN/` | per-terrain ground sheet |
| `assets/sprites/{NAMEPLAT,WOODFRAM,WOODTILE,PARCH,EXIT,WIN-FWRK}/` | UI chrome |
| `assets/backgrounds/*.PIK/` | 35 full-screen backgrounds |
| `assets/sprites/CLOS-*/` | closing cinematic |
| `assets/sprites/OPEN*/` | opening cinematic |

---

## Verified game-state addresses (highlights)

### PowerRecord (per nation, stride 316 bytes from DGROUP:0x8808)
- `+0x01` byte: tax %
- `+0x02` byte: rebel sentiment %
- `+0x0C` u16: bells lifetime (cumulative)
- `+0x0E` u16: bells per turn
- `+0x10` u16: crosses per turn
- `+0x14` u16: founding father count
- `+0x20` u16: boycott bitfield (bit i = good i)
- `+0x2A` u32: gold treasury
- `+0x30` u16: recruit cost (Europe)
- `+0x32` u16: REF strength rating

### DGROUP scalars
- `0x372` u16: score (player)
- `0x53A7` byte: king anger (+1 per Tea Party)
- `0x53DA..0x53E1` 4×u16: REF (Reg / Cav / MoW / Art)
- `0x538A` u16: year
- `0x538E` u16: turn
- `0x5398` u16: active power
- `0x53D2` u16: self power
- `0x84FC` far ptr: → PowerRecord[active_power]
- `0x8542` u16: → ColonyRecord[active]

### NativeSettlement (DGROUP:0x54EC, stride 18)
- `+0x00, +0x01` bytes: map_x, map_y
- `+0x02` byte: tribe_power_idx (4=Inca, 5=Aztec, ..., 11=Tupi)
- `+0x03` byte: flags (0x04=capital, 0x08=visited)
- `+0x04` byte: population (used by CHIEFKILL formula)
- `+0x05` byte: mission (`0x10 | owner_idx`)

### ColonyRecord (pointer at DGROUP:0x8542, stride 202 bytes)
- `+0x00, +0x01` bytes: map_x, map_y
- `+0x02..+0x19` bytes: name (NUL-terminated, 24 bytes)
- `+0x1A` byte: owner_power_idx
- `+0x1F` byte: size (colonist count)
- `+0x22` u16: colony_state_packed (player-owned only)
- `+0x40..+0x4?` byte[size]: colonist job-skills (NAMES.TXT @JOB)
- `+0x70..+0x77` byte[8]: tile worker assignment (NW/N/NE/W/E/SW/S/SE)
- `+0x9A..+0xB9` u16[16]: **stockpile** (NAMES.TXT @CARGO order)
- `+0xC2` u32: wealth
- `+0xC6` u16: per-colony counter (TBD)

### Capital raze observation
- Inca capital pop=13 → 15,000 gold (CHIEFKILL max 10,080)
- Aztec capital pop=10 → 10,000 gold (CHIEFKILL max 7,920)
- Bonus formula: provisional `1000 × civ_tier × roll(1..5)`

---

## Outstanding investigations

These require either more game observations OR targeted disasm work:

1. **Bell rolling-total** identified as PowerRecord +0x0C (bells_lifetime)
   — but the threshold-trigger logic for REF growth still TBD.
2. **Tax-event timer** — when can the king raise taxes again? Likely
   a turn-counter delta stored somewhere.
3. **Mission-active counter** per nation — for the Religious Adviser
   report.
4. **Per-power score values** — partial (PowerRecord +0x12 = colony
   count?, +0x2E = population?). Total score at 0x372.
5. **Acquired FF bitmask** location — known FF count is in PowerRecord
   +0x14 but the bitmask of WHICH FFs are acquired is TBD.
6. **Capital bonus exact formula** — H5 (`1000 × civ_tier × roll(1,5)`)
   is best-fit but needs a 3rd capital raze to solve uniquely.
7. **Foreign-colony hover field "12"** — candidate at ColonyRecord
   +0x20 (= 13 in test data, off-by-one from displayed 12).
8. **CYCLE.DAT format** — 34-byte file, palette-cycling ranges. Not
   yet decoded.

---

## How to use this index

When fixing a UI rendering bug:
1. Find the screen in `SESSION_UI_CATALOG.md`
2. Look up exact pixel coordinates in the per-screen `spec/ui/*.md`
3. Look up required sprites in `SCREEN_ASSET_REQUIREMENTS.md`
4. Look up exact memory addresses for dynamic values in `DATA_MODEL.md`
5. Look up message-template format in `GAME_TXT_CATALOG.md` /
   `LABELS_TXT_CATALOG.md`
6. Pick the right sprite index from `GAME_INDEX_TABLES.md`

When investigating a new game-state value:
1. Check `DATA_MODEL.md` for the field's offset
2. If not present, scan recent session memory dumps with the analyzer
   tool (`tools/analyze_session_mem.py`)
3. Cross-reference with NAMES.TXT / PEDIA.TXT / LABELS.TXT for
   semantic meaning
4. Update `DATA_MODEL.md` with the verified field

When triggering a new event in-game:
1. Capture frame + memory snapshot
2. Find the matching @-section in `GAME_TXT_CATALOG.md`
3. Identify the speaker sprite in `SESSION_UI_CATALOG.md`
4. Verify popup geometry in `spec/ui/dialog_framework.md`
