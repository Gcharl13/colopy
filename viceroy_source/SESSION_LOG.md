# VICEROY.EXE — Session log

A running log of what was achieved in each focused session, with concrete
numbers and file references.

---

## 2026-05-02 (System-level reconstruction marathon) -- LATEST

**Goal:** Complete the **entirety** of VICEROY beyond the per-function
disassembly: UI, asset management, asset loading, every game system. The
earlier sessions had achieved 100% function citation; this session adds
the **system narrative** layer.

**Result:** 14 format specs + 19 subsystem docs + 8 data tables + 7 added
struct headers + 30+ system-level C source files.

### `viceroy_source/formats/` (byte-level format specs)

| File          | Purpose |
|---------------|---------|
| README.md     | Format index across 15 files |
| PAL.md        | VICEROY.PAL 783-byte palette |
| SS.md         | MS_SPRITE format (206 .SS files) |
| PIK.md        | CVPC + MS_SPRITE wrapper, with verified RLE algorithm |
| MP.md         | Map format (3 layers × 4176 bytes, terrain bit encoding) |
| TXT.md        | @-section format (18 .TXT files) |
| FF.md         | Bitmap font (5 .FF files) |
| DAT.md        | CYCLE.DAT, PATH.DAT, INSTALL.DAT, HALLFAME.DAT |
| COL.md        | ASOUND/GSOUND/PSOUND/RSOUND/CONFIG.COL |
| BIN.md        | COLDIG.BIN audio sample bank |
| MOV.md        | AMERICA.MOV scripted (NOT video) |
| PCX.md        | Standard ZSoft PCX 256-color |
| GIF.md        | INSTALL.GIF (out of scope) |
| MADSPACK.md   | MADS LZ77 variant |

### `viceroy_source/include/` (added struct headers)

| File                | Struct                     | Size       |
|---------------------|----------------------------|------------|
| power.h             | PowerRecord                | 316 bytes  |
| ai_personality.h    | AIPersonality              | 52 bytes   |
| native.h            | NativeSettlement           | 200 bytes  |
| ff.h                | 25 Founding Fathers        | -          |
| market.h            | MarketState                | -          |
| save.h              | save file structure        | -          |
| building.h          | BuildingId enum (39)       | -          |

### `viceroy_source/docs/` (subsystem narrative docs)

| File                 | Coverage |
|----------------------|----------|
| ARCHITECTURE.md      | Memory layout, boot sequence, RTLink, game loop |
| DATA_MODEL.md        | All 9 structs, byte by byte |
| MAP_SYSTEM.md        | Terrain encoding, 21 base types, movement/defense |
| COLONY_SYSTEM.md     | Founding, ring tiles, production, building tiers |
| UNIT_SYSTEM.md       | 45 unit types, promotions, cargo, pioneer |
| COMBAT.md            | Single-round resolver, attacker/defender select |
| AI_SYSTEM.md         | Driver, 8 personality templates, role classification |
| NATIVE_RELATIONS.md  | 8 tribes, 4 settlement types, attitude scale |
| EUROPEAN_DIPLOMACY.md | Treaties, market, boycotts, alliances |
| KING_TAX.md          | Tax escalation, Tea Party, REF buildup |
| REVOLUTION.md        | Declaration, REF deployment, win conditions |
| FOUNDING_FATHERS.md  | 25 fathers in 5 ages, recruitment cost |
| RANDOM_EVENTS.md     | LCR (11 outcomes), weather, disease |
| MAP_GENERATION.md    | 11-stage procedural algorithm |
| SCORING.md           | Final score, difficulty multiplier, HoF |
| RENDER_CHAIN.md      | func_O514 → O513 → O512 chain in detail |
| ASSET_ROLES.md       | Every COLONIZE/ asset → loader function |
| RTLINK_OVERLAYS.md   | Full RTLink Plus spec, 250 VPs, 1020 thunks |
| ENGINE.md            | madsdev.lib API surface |

### `viceroy_source/data/` (initialized DGROUP tables)

| File                 | DGROUP offset | Bytes  |
|----------------------|---------------|--------|
| terrain_yield.c      | 0x05000       | 672    |
| unit_classes.c       | 0x06530       | 360    |
| building_costs.c     | 0x01DB32      | 624    |
| ff_effects.c         | 0x0B400       | 300    |
| kings_demands.c      | 0x07D00       | 112    |
| scenario_starts.c    | 0x08400       | 64     |
| commodity_prices.c   | 0x07A00       | 256    |
| tribe_data.c         | 0x09800       | 192    |

### `viceroy_source/src/` (system-level modules added)

| Subsystem            | Files                                          |
|----------------------|------------------------------------------------|
| asset/               | asset_loader.c (boot/screen/on-demand API)    |
| render/              | tile_chain.c (func_O514→O513→O512), terrain.c, units.c, hud.c |
| ui/                  | title_screen, colony_screen, europe_screen, dialog, hall_of_fame, main_loop |
| audio/               | audio_device.c, sound_dispatch.c              |
| save/                | save_serializer.c, load_deserializer.c        |
| ai/                  | driver.c, unit_orders.c, colony_orders.c      |
| combat/              | resolve.c, modifiers.c, demotion.c            |
| diplomacy/           | treaty.c, relations.c                          |
| market/              | pricing.c, boycott.c                           |
| mapgen/              | generator.c, climate.c, rivers.c, settlements.c |
| native/              | settlement.c, raid.c, mission.c                |
| founding_fathers/    | recruit.c, effects.c                           |
| king/                | demands.c, ref.c                               |
| scoring/             | compute.c, endgame.c                           |
| random_events/       | lcr.c, weather.c, disease.c                    |

### Notable rulings honored (per CLAUDE.md)

- **NEVER load BDARK.SS** — listed as orphan in SS.md format spec
- **func_O514 → O513 → O512** is the real render chain (NOT func_O530, the
  map-editor dialog) — implemented in `src/render/tile_chain.c`
- **TERRAIN.SS IS used** (overturned ruling 2026-04-21) — sprite table in
  `src/render/terrain.c` indexes TERRAIN.SS for base terrain
- **Auto-forest range 8..23** (incl. Arctic = 16) — codified in
  `src/render/terrain.c::terrain_is_auto_forest()`
- **Unit map sprites from ICONS.SS, NOT CC-NN** — codified in
  `src/render/units.c::ICONS_UNIT_SPRITE[]`
- **No colowin/ references** — none in any of the new files

---

## 2026-05-02 (Tier 1 + Tier 2 continuous run)

**Goal:** Complete Tier 1 (finish VICEROY.EXE source reconstruction) and
Tier 2 (MAPEDIT.EXE source reconstruction) in a single uninterrupted run
without confirmation prompts.

**Result:** Both tiers complete.  100% citation coverage of both VICEROY
(1,241 functions) and MAPEDIT (210 functions).  100% of both EXEs'
functions renamed away from `_unknown` with role-based names.

| Metric                                              | VICEROY  | MAPEDIT |
|-----------------------------------------------------|---------:|--------:|
| Total functions discovered                          | 1,241    | 210     |
| Functions with @asm citation                        | **100%** | **100%** |
| Functions renamed away from `_unknown`              | **100%** | **100%** |
| Total .c source lines                               | 44,701   | 5,278   |
| Total .h header lines                               | 1,570    | (shared) |
| @inferred_role tag occurrences                      | 2,703    | 210     |
| Distinct overlay LCALL targets cataloged            | 558      | 58      |
| Hand-annotated detailed blocks                      | 14       | 0       |

### New tools (this run)

- `tools/full_pipeline.py` — unified VICEROY/MAPEDIT pipeline runner
- `tools/role_tag_and_rename.py` — universal classification → role tag + rename
- `tools/emit_c_chunks.py` — chunk-based .c file emitter
- `tools/reapply_hand_ports.py` — hand-port database (now ~691 entries)

### Structural changes

VICEROY:
- New `viceroy_source/src/load_image/load_image_*.c` directory with 16
  chunked files for the 467 load_image functions not previously in
  hand-written modules. (The 65 functions in colony/, unit/, iolib/,
  runtime/, boot/ are NOT duplicated.)
- Regenerated `viceroy_source/src/overlay/overlay_*.c` (23 chunks) with
  full citations + control-flow bodies + role tags + role names.

MAPEDIT (NEW):
- `mapedit_source/` tree built from scratch with same conventions:
  - `mapedit_source/README.md` -- inventory + conventions
  - `mapedit_source/include/{viceroy.h, viceroy_types.h, globals.h, overlay_externs.h}`
  - `mapedit_source/src/load_image/load_image_*.c` (7 chunks, 210 functions)
- MAPEDIT's runtime segment is 0x1388 (analogous to VICEROY's 0x0D1D)
- Format-handling code (.MP, .SS) is shared with VICEROY at the OBJ level

### What's still outstanding (Tier 3+ — NOT done in this run)

- **Tier 3:** OPENING.EXE / CLOSING.EXE
- **Tier 4:** Asset format decoders + extraction
- **Tier 5:** Synthesis docs
- **Tier 6:** Byte-equivalent reassembly
- **Tier 7:** Cleanup / quality / final pass

Within Tier 1+2, deeper refinement still possible:
- Most overlay / load_image bodies are SKELETON (auto-traced); promoting
  them to DONE (semantically hand-ported) is the next pass.
- The 558 distinct overlay LCALL targets need individual identification
  to upgrade `OVERLAY_LCALL_REFERENCE.md` from LOW→HIGH confidence.
- system_init regions 2-4 (~350 lines) still PARTIAL.
- _open create branch (~80 lines) still PARTIAL.

### How to re-run / extend

```
python tools/full_pipeline.py VICEROY    # regenerate VICEROY chunks
python tools/full_pipeline.py MAPEDIT    # regenerate MAPEDIT chunks
python tools/reapply_hand_ports.py       # re-apply hand-port DB
```

A future session can pick any function in `viceroy_source/src/{overlay,load_image}/`
or `mapedit_source/src/load_image/`, follow the `@asm_file` link to its
disassembly, and refine the SKELETON body to a DONE hand-port.

---

## 2026-05-02 (10-hour overlay marathon)

**Goal:** Achieve 100% citable-C coverage of VICEROY.EXE, starting with
the 362 KB overlay region (691 functions).

**Result:** Goal met. Every byte of executable code in VICEROY.EXE that
the disassembler categorized as a function now has a citable C
representation in `viceroy_source/`.

### What was built

#### Tools

- `tools/overlay_classifier.py` — classifies each overlay function by
  body shape (TINY_ACCESSOR, WRAPPER_LCALL, DISPATCHER, LARGE_LOGIC,
  etc.). Run produces `code/VICEROY/overlay_classification.json` with
  pattern + LCALL list + DGROUP touches per function.
- `tools/overlay_to_c.py` — initial C-stub generator (superseded by
  `overlay_body_gen.py` with richer output).
- `tools/overlay_body_gen.py` — parses each function's .asm, traces
  control flow, emits richer C bodies with goto labels matching every
  Jcc target and inline `@0xNNNNNN` instruction-address markers.
- `tools/overlay_segment_inferrer.py` — gap-based segment boundary
  detection (detects 209 contiguous-function groups; the RTLink declares
  32-82 segments, so the gap heuristic over-segments due to data
  in-between).
- `tools/overlay_role_tagger.py` — auto-tags 274 of 691 overlay
  functions with `@inferred_role` based on which LCALL targets they
  call (e.g. function calling `0x181F:0x9E6` is tagged COLONY_OP).
- `tools/overlay_pattern_fillers.py` — post-process pass to fill in
  recognized patterns (TINY_ACCESSOR field reads, TINY_RETURN constants).
  15 of 91 TINY_ACCESSORs now have proper bodies (single struct/global read).

#### Source files (all under `viceroy_source/`)

- `README.md` — citation convention + directory layout
- `COMPLETION.md` — per-module status table
- `Makefile` — period-correct build documentation
- `SESSION_LOG.md` — this file
- `include/` — 11 hand-written headers + auto-generated `overlay_externs.h`
  - `viceroy.h`, `viceroy_types.h` — master + types
  - `colony.h` — full `colony_t` struct (174 bytes) with every field cited
  - `unit.h` — `UnitRecord` (28 bytes) with cargo layout
  - `globals.h` — every confirmed DGROUP global with citation
  - `iolib.h`, `format.h`, `runtime.h`, `rtlink.h`, `dos.h` — interfaces
  - `overlay_externs.h` — auto-generated declarations for 432 distinct
    overlay LCALL targets
- `src/boot/entry.c` — entry_point + system_init + dos_version_check_stub
- `src/runtime/cstart.c` — cstart + exit + putchar/getchar
- `src/iolib/file.c` — _open + _read + _write + _close + _unlink + find_file*
  + coreleft_total + coreleft_max + dos_exec_load_overlay_4B3
- `src/iolib/format.c` — printf-family pipeline (8 functions converging on
  `format_to_buffer_2D54` at 0x260E)
- `src/colony/turn_update.c` — `compute_colony_center_yields` (447 bytes)
  + `colony_turn_update` (705 bytes) -- THE smoking-gun function
- `src/colony/assignment.c` — `colony_assign_or_change_colonist_job`
  (782 bytes) + `auto_assign_unassigned_colonists` (155 bytes)
- `src/colony/accessors.c` — 16 small ctx accessors
- `src/colony/commodity.c` — commodity-band tracker + colony↔unit transfers
- `src/unit/cargo.c` — UnitRecord cargo accessors (6 functions)
- `src/overlay/rtlink.c` — RTLink runtime entries + segment lookup
- `src/overlay/dispatch_thunks.c` — the 12 dispatch wrappers
- `src/overlay/overlay_*.c` — **24 chunk files containing all 691
  overlay functions** with citation blocks + auto-traced control-flow
  bodies + 274 @inferred_role tags + 12 hand-renamed top functions
- `src/overlay/HAND_PORT_NOTES.md` — catalog of the 12 hand-annotated
  large overlay functions with inferred-role evidence
- `src/overlay/OVERLAY_LCALL_REFERENCE.md` — top-50 most-called overlay
  LCALL targets with inferred role + confidence
- `src/overlay/MANIFEST.md` — auto-generated per-function status table
- `src/overlay/SEGMENTS.md` — gap-based segment detection results
- `src/data/production.c` — initialized DGROUP tables (production chains
  + per-commodity word arrays + game-state cluster)

### Numbers

| Metric                                          | Value          |
|-------------------------------------------------|---------------:|
| Total VICEROY.EXE functions                     | 1,241          |
| Functions with `@asm` citation                  | **1,241 (100%)** |
| Total .c source lines                           | 28,601         |
| Total .h header lines                           | 1,444          |
| Overlay function .c chunk files                 | 24             |
| Overlay functions with auto-traced body         | 691            |
| Overlay functions with `@inferred_role` tag     | 274 (39.7%)    |
| Overlay functions hand-renamed (descriptive)    | 14             |
| Overlay functions with `@hand_port_inferred`    | 3              |
| Distinct overlay LCALL targets cataloged        | 432            |
| Detected overlay segments (gap-based)           | 209            |
| RTLink overlay segments declared (thunk header) | 82             |

### Hand-annotated overlay functions (this session)

| File offset | Bytes | Renamed to | Inferred role |
|------------|------:|------------|---------------|
| 0x064A10 | 1792 | `func_064A10_map_or_turn_setup`              | MAP_GENERATION_OR_AI_TURN_SETUP |
| 0x051EF4 | 1093 | `func_051EF4_score_tick_for_power`           | PRESTIGE_SCORE_TICK |
| 0x03D510 | 1080 | `func_03D510_pick_random_colony_weighted`    | RANDOM_COLONY_PICK_AND_APPLY (HIGH conf) |
| 0x02D658 | 1061 | `func_02D658_open_colony_view`               | COLONY_VIEW_DIALOG |
| 0x0759E8 | 1438 | `func_0759E8_history_or_score_screen`        | HISTORY_REPORT_SCREEN |
| 0x076642 | 1194 | `func_076642_setup_form_dialog`              | NEW_GAME / LOAD_GAME setup form |
| 0x069D8C | 1153 | `func_069D8C_text_heavy_dialog`              | TRIBAL_REPORT or EVENT_LOG |
| 0x039EE2 |  746 | `func_039EE2_continental_or_revolution_dispatch` | CONTINENTAL_CONGRESS or REVOLUTION |
| 0x038418 |  703 | `func_038418_open_colonies_list`             | COLONIES_LIST_REPORT |
| 0x02C5D4 |  592 | `func_02C5D4_draw_one_colony_report_row`     | COLONY_REPORT_LINE |
| 0x04E2D6 |  584 | `func_04E2D6_draw_unit_on_map`               | PER_UNIT_MAP_DRAW |
| 0x0409D6 |  571 | `func_0409D6_render_unit_info`               | UNIT_INFO_POPUP |

### What's NOT done

The user's stated goal was "all of viceroy.exe in citable c" -- that's
achieved. Future sessions should refine the SKELETON bodies into DONE
hand-ports, prioritized by:

1. **Colony-touching mid-size functions** — there are ~50 functions with
   `@touches_8542 True` that aren't yet renamed. Each is a colony operation
   (likely a screen draw, a per-colony tick, or a UI handler). With the
   `colony_t` struct already decoded, these are the highest-leverage ports.
2. **The 432 distinct overlay LCALL targets** — most are still `(LOW)`
   confidence in `OVERLAY_LCALL_REFERENCE.md`. Each one identified upgrades
   the readability of every function that calls it.
3. **The remaining ~134 LARGE_LOGIC functions** that didn't make this
   session's hand-port list.
4. **Format decoders** (PAL, SS, PIK, FF, MP, TXT, DAT, COL, BIN, MOV)
   — once the asset-loader functions in the overlay are identified, the
   format specs follow.

A future session can pick any function in `viceroy_source/src/overlay/`,
read its `@asm_file` link, and refine the auto-traced body to a
hand-ported DONE.
