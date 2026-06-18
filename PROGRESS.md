# Progress Dashboard

> **⚠️ STALE (pre-2026-05-04) — superseded by [`STATUS.md`](STATUS.md) and
> [`AUDIT.md`](AUDIT.md).** This file predates the sprint-completion work and
> contains contradictory/inflated claims (e.g. "100% in citable C",
> "OPENING/CLOSING not started"). See `AUDIT.md` §3–§4 for corrected metrics.
> Kept for history; do not cite as current state.

Top-level status of the reverse-engineering effort. Per-line code status
lives in `code/DISASM_LEDGER.md`; per-asset status lives in the sidecar JSONs
inside `assets/`. This file is the bird's-eye view.

Updated by hand at the end of each session.

**Scope note** (per user, 2026-05-02): `INSTALL.EXE` and `MPSCOPY.EXE`
are out of scope. The pipeline runs against `VICEROY.EXE`, `MAPEDIT.EXE`,
`OPENING.EXE`, and `CLOSING.EXE` only. Their `code/` directories have been
removed; their raw bytes remain in `raw/COLONIZE/`.

| # | Phase | Status |
|---|-------|--------|
| 0 | Foundation (skeleton, raw copy, manifest, docs) | **DONE** |
| 1 | Disassembler + asset inventory pass | **DONE** |
| 2 | VICEROY.EXE annotation (region by region) | **IN PROGRESS** — 60+ functions fully DONE + 15 header-only; 1,241 functions total; **35+ functions ported as pseudo-C** in `code/VICEROY/decompiled.md` (the preferred work product per user feedback 2026-05-02). Major colony functions decompiled: colony_turn_update (705 bytes), colony_assign_or_change_colonist_job (782 bytes), compute_terrain_yield (1120 bytes), compute_colony_center_yields (447 bytes), update_and_render_tile_at (532 bytes), auto_assign_unassigned_colonists (155 bytes). Boot/asset loaders: _open, _read, dos_exec_load_overlay_4B3, RTLink overlay file-open helper. All 5 DOS Open File sites identified. |
| 2b | **VICEROY.EXE source reconstruction (Tier 1)** | **COMPLETE** — `viceroy_source/` tree built. **100% of 1,241 VICEROY.EXE functions are in citable C** (44,701 .c lines + 1,570 .h lines across 36+ files). **100% of overlay AND load_image functions renamed away from `_unknown`** with role-based descriptive names (e.g. `func_064A10_map_or_turn_setup`, `func_NNNNNN_colony_sz_NN`, `func_NNNNNN_dlg_sz_NN`). **2,703 @inferred_role tag occurrences** across all .c files. 14 of the largest overlay functions hand-annotated with detailed semantic blocks. See `viceroy_source/COMPLETION.md`, `SESSION_LOG.md`, `src/overlay/HAND_PORT_NOTES.md`. |
| 2c | **MAPEDIT.EXE source reconstruction (Tier 2)** | **COMPLETE** — `mapedit_source/` tree built. **100% of 210 MAPEDIT functions in citable C** (5,278 .c lines). **100% renamed** with role-based names. Same citation framework as viceroy_source/. Companion includes (viceroy.h, globals.h, viceroy_types.h, overlay_externs.h with 58 distinct LCALL targets). MAPEDIT's runtime segment is 0x1388 (analogous to VICEROY's 0x0D1D). |
| 3 | MAPEDIT.EXE annotation | **MERGED** into Tier 2c above |
| 4 | Code-driven asset extraction | not started |
| 5 | Audio + Movie | not started |
| 6 | Other DOS executables (OPENING/CLOSING) | not started |
| 7 | Synthesis docs | not started |

## Headline finding

**VICEROY.EXE's overlay code is built with the Borland-style `ENTER` prologue, not Microsoft's `PUSH BP / MOV BP, SP`.** Recognising ENTER as a function prologue exploded auto-detected functions from **371 → 1,237** and captured CALL graph edges from **150 → 1,073**. Three of the four DOS executables in scope (`MAPEDIT`, `OPENING`, `CLOSING`) have overlays that are **debug data**, not loadable code (zero or near-zero standard-prologue + return-instruction density). Only VICEROY's overlay actually contains executable code.

## Headline finding (2026-05-02)

**The struct at `*(0x8542)` is the current-colony struct.** Confirmed via
the colony-turn-update function at file 0xA3E1 which dispatches the seven
canonical Colonization production chains in order:
- Sugar→Rum (commodity 1→9)
- Tobacco→Cigars (2→10)
- Cotton→Cloth (3→11)
- Furs→Coats (4→12)
- Ore→Tools (6→14)
- Plus direct band updates for Food (0), Lumber (5), Tools (14)

The struct's per-colonist arrays at +0x20 (job), +0x40 (unit type), and
+0x60 (packed-nibble expertise) are bound by `colony.population` at +0x1F.
The per-commodity word array at +0x9A is the colony's stockpile (15 entries
+ 5 slack for the 16 standard commodities). The +0x70 byte array (20
entries) tracks per-grid-square tile state in the colony's 5×5 surrounding
land area. See `code/VICEROY/decompiled.md` for the full struct layout
plus pseudo-C decompilations of 25+ colony-related functions.

## Phase 2 — VICEROY.EXE annotation

### Region 0 — RTLink overlay infrastructure (DONE)

| Function | Offset | Size | Status | Notes |
|----------|-------:|----:|--------|-------|
| `rtlink_overlay_thunk_table` | 0x01A5F0 | 12,278 | data block annotated | 1,020 thunks, 82 distinct overlay segments |
| `rtlink_loader_A` (0x110D:0x0DAB) | 0x01427B | 24 | header annotated | type-A entry; called 127× |
| `rtlink_loader_B` (0x110D:0x0D91) | 0x014261 | 26 | header annotated | type-B entry; called 109× |
| `rtlink_loader_shared` | 0x014293 | 1018 | header annotated | shared body; per-line pending |
| `rtlink_segment_lookup` | 0x0164A2 | 59 | **DONE** (line-by-line) | dispatcher across 6 storage-class helpers |

### Region 1 — Boot / startup + C runtime wrappers

| Function | Offset | Size | Lines | Status |
|----------|-------:|----:|------:|--------|
| `entry_point`             | 0x013BED |    10 |   2 | **DONE** |
| `system_init`             | 0x013BF7 | 1,368 | 437 | IN PROGRESS — region 1 of 4 annotated (EMS+XMS+conventional memory queries; ~84 lines done) |
| `dos_version_check_stub`  | 0x00F720 |    13 |   8 | **DONE** |
| `cstart`                  | 0x00F72D |   182 |  73 | **DONE** |
| `kbhit`                   | 0x00D272 |    13 |   8 | **DONE** |
| `getch`                   | 0x00D286 |    15 |   9 | **DONE** |
| `exit`                    | 0x00F8DD |     7 |   4 | **DONE** |
| `exit_abort`              | 0x00F8E4 |     8 |   4 | **DONE** |
| `putchar`                 | 0x00FD20 |     8 |   4 | **DONE** |
| `getchar`                 | 0x00FD4E |     8 |   4 | **DONE** |
| `_read`                   | 0x010466 |     7 |   4 | **DONE** |
| `_write`                  | 0x01046D |     5 |   3 | **DONE** |
| `unlink`                  | 0x01041A |    14 |   7 | **DONE** |
| `_close`                  | 0x01144A |    32 |  13 | **DONE** |
| `dos_version_far`         | 0x01A425 |    23 |  15 | **DONE** |
| `coreleft_max`            | 0x078AF2 |    23 |  11 | **DONE** |
| `wait_for_keypress`       | 0x004A5C |    36 |  14 | **DONE** |
| `drain_keyboard_buffer`   | 0x004AFA |    28 |   9 | **DONE** |
| `find_file`               | 0x010433 |    79 | RAW | boundary identified |
| `coreleft_total`          | 0x0124D6 |    90 | RAW | boundary identified |
| `fclose_or_remove`        | 0x00F9C4 |   186 | RAW | header annotated |
| `load_game_state`         | 0x011F6E |   403 | RAW | header annotated |

### Region 2 — Standard C library utilities (DONE for top hits)

| Function | Offset | Size | Lines | Callers |
|----------|-------:|----:|------:|--------:|
| `strcpy_near`             | 0x00FDB4 |    50 |  26 | 38 — most-called custom helper |
| `strcat_near`             | 0x00FD74 |    63 |  30 | 34 |
| `strlen_near`             | 0x00FE12 |    27 |  15 |  9 |
| `strcpy_far`              | 0x01074E |    54 |  29 | 17 |
| `strcat_far`              | 0x010784 |    70 |  34 | 16 |
| `strlen_far`              | 0x01070C |    23 |  13 |  5 |
| `strchr_near`             | 0x010226 |    42 |  24 | 10 |
| `strrchr_far`             | 0x0106BA |    42 |  23 |  6 |
| `memset_near`             | 0x01037E |    45 |  23 |  8 |
| `itoa_radix_dispatch`     | 0x00FECA |    28 |  14 | 12 |
| `printf_to_str`           | 0x00FAAA |    21 |  10 |  9 |

### Region 3 — Game-state accessors (DONE)

| Function | Offset | Size | Lines | Callers | Notes |
|----------|-------:|----:|------:|--------:|-------|
| `is_xy_in_map_bounds`         | 0x005BFA | 49 | 18 | 24 | reads map_width [0x853A] and map_height [0x853C] |
| `map_xy_bounds_or_neg1`       | 0x005F04 | 31 | 12 |  7 | wrapper returning -1 if out-of-bounds |
| `map_xy_bounds_or_neg1_alt`   | 0x005FD4 | 31 | 12 |  6 | sibling of 0x5F04 |
| `map_tile_read_layer_15C`     | 0x005CFE | 28 | 10 |  7 | reads from far-pointer at [0x15C..0x15F] |
| `map_tile_read_layer_160`     | 0x005D32 | 28 | 10 |  5 | reads from far-pointer at [0x160..0x163] |
| `is_tile_walkable_or_special` | 0x0062B4 | 39 | 18 |  5 | calls overlay tile-classify; tests for terrain 25/26 |
| `unit_field_lookup_simple`    | 0x0066BA | 18 |  9 | 18 | reads UnitRecord[i] next-link word +0x1A (stride 0x1C, base 0x3144) |
| `unit_chain_resolve`          | 0x006672 | 35 | 16 | 15 | follows tile-chain link words +0x18/+0x1A (base 0x3144; 0x315C/0x315E) |
| `unit_table_offset_calc`      | 0x006CCA | 13 |  5 |  4 | computes idx*0x1C, used as IMUL helper |
| `power_record_read_dword`     | 0x0087F4 | 18 |  7 |  4 | PowerRecord[idx].field (stride 0x13C) |
| `unit_field_test_at_3146`     | 0x008B96 | 24 | 10 |  4 | tests byte at unit_table_3146[idx] |
| `lookup_table_2F4_signed`     | 0x008D9C | 31 | 11 |  4 | bounded array lookup with sign-extension |
| `current_unit_field_at_20`    | 0x0090C8 | 29 | 13 |  6 | reads sub-array at offset +0x20 within *(0x8542) struct |
| `current_unit_field_at_40`    | 0x009102 | 29 | 13 |  6 | sister of 0x90C8 — sub-array at offset +0x40 |
| `unit_table_3154_byte`        | 0x00B2F0 | 20 |  9 |  3 | byte at unit_table_3154[idx] with caller base |
| `read_far_dword_via_267A`     | 0x00E4C6 | 12 |  4 | 17 | reads DWORD at the far pointer in [0x267A] |
| `normalize_far_pointer`       | 0x00E454 | 23 | 10 |  3 | normalises (seg, off) so off is in 0..15 |
| `set_global_269E_byte_pair`   | 0x00E68A | 15 |  6 |  7 | stores AL/DL at DGROUP:0x269E/0x269F |
| `wrapper_with_global_8DC6`    | 0x00863E | 15 |  7 |  9 | forwards arg with current-context global |
| `terrain_id_normalize_to_8`   | 0x003436 | 25 | 10 |  4 | maps id 17 or 9 → 8; passes other values through |
| `format_to_buffer_2D54`       | 0x00260E | 35 | 16 |  4 | dual format-engine call to fixed buffer at 0x2D54 |
| `call_overlay_with_80`        | 0x0028B0 | 16 |  7 |  3 | wrapper passing fixed context-id 80 to overlay helper |
| `clamp_byte_at_far_ptr_to_5`  | 0x044540 | 19 |  9 |  3 | reads byte; clamps 6 → 5 |
| `ltoa_dispatch`               | 0x00FEE6 | 10 |  6 |  3 | sister of itoa_radix_dispatch for long-decimal |

## Pipeline run summary

| EXE          | Funcs | Lines     | Identified | %     | RTLink segs (in thunk table) |
|--------------|------:|----------:|-----------:|------:|------------:|
| VICEROY.EXE  | 1,241 |   212,746 |        842 | 0.40% |          82 |
| MAPEDIT.EXE  |   210 |    83,318 |          0 | 0.00% |          12 (debug-only) |
| OPENING.EXE  |   145 |    56,428 |          0 | 0.00% |           9 (debug-only) |
| CLOSING.EXE  |   136 |    54,037 |          0 | 0.00% |           6 (debug-only) |

## Hot globals (from per-function memory-displacement scan)

| Addr (DGROUP) | Distinct fns | Inferred meaning |
|---------------|-------------:|------------------|
| `0x8542` | **102** | Current-context-struct pointer (most-touched global by far) |
| `0x2DA8` | 75 | Major game-state field |
| `0x2DAA / 0x2DAC / 0x2DAE` | 55-56 each | Adjacent struct fields alongside 0x2DA8 |
| `0x5382 / 0x539C / 0x53A6 / 0x539E / 0x5398 / 0x5394 / 0x5396 / 0x5392` | 20-37 each | "Game progress" struct cluster — turns/year/season/score/etc. |
| `0x83A0 / 0x83A2 / 0x83A4 / 0x839E` | 20-23 each | Adjacent struct in a different module |
| `0x089E / 0x083E / 0x0840 / 0x07E8` | 16-36 each | Low-DGROUP system flags |
| `0x853A / 0x853C` | confirmed | **map_width** / **map_height** (verified via is_xy_in_map_bounds) |
| `0x3144` | confirmed | **unit_table base** (stride 0x1C); 0x3146=type+0x02; 0x315C/0x315E = chain words +0x18/+0x1A |
| `0x267A` | confirmed | far pointer to a major game-state record (read by 0xE4C6) |
| `0x27B9` | 6 | NFILE_QQ — open-files limit (confirmed via _close) |
| `0x27D3 / 0x27D1 / 0x27CF` | (cstart) | envp / argv / argc — confirmed in cstart |
| `0x27B2` | 3 | saved DGROUP segment (cstart) |
| `0x39B7 / 0x39DE / 0x39DD / 0x39E1 / 0x39F1 / 0x397D / 0x397F / 0x3983` | (system_init, RTLink) | Memory layout / overlay-loader-busy flag globals |

## Tools added in Phase 2

- `tools/classify_funcs.py` — buckets functions by shape.
- `tools/xref_bucket.py` — buckets byte-search xrefs by containing function.
- `tools/xref_strict.py` — capstone-driven operand-immediate xref scan.
- `tools/callgraph.py` — per-function CALL/LCALL graph (per-function disasm avoids capstone flat-scan desync).
- `tools/hot_globals.py` — most-referenced DGROUP global addresses.
- `tools/parse_thunks.py` — defensive thunk-table parser (handles variable-size type-A trailers 2/4/6 bytes).
- `disasm_mz.py` — recognises both `55 8B EC` AND `C8 imm16 imm8` (ENTER) prologues, alternative `55 89 E5`. Manual_funcs.json ingestion. Per-line annotation preservation across `--force` regenerations. Orphan cleanup on rename.

## Game-logic mapping

The consolidated map of game-logic anchors lives in
`code/VICEROY/anchor_map.md`. It joins three independent signals:

1. **Resource-key tables in DGROUP** (NAMES.TXT @-section names at
   0x01FB4C..0x01FC5C, plus 30+ GAME.TXT keys with high reference
   counts).
2. **Call graph** (`code/VICEROY/callgraph.json`) — confirmed (caller, callee) edges across 1,073 distinct edges.
3. **Hot global addresses** (`code/VICEROY/hot_globals.md`) — 872 distinct DGROUP variables identified.

**Headline**: VICEROY's load image (~123 KB) is mostly C runtime + I/O + DOS plumbing. The actual game logic lives in the **362 KB overlay** behind the RTLink overlay loader. With the ENTER prologue heuristic now in place, **691 overlay functions** are auto-detected (102 KB of identified code, ~28% of the overlay).

## RTLink overlay infrastructure

See `formats/RTLINK.md` for the full byte-level format docs. Key facts:

- Thunk table at `0x01A5F0..0x01D5E6` (12 KB, 1020 thunks, 82 segments)
- Two RTLink runtime entry points: `0x110D:0x0DAB` (file 0x1427B) and `0x110D:0x0D91` (file 0x14261)
- Both share a body at file 0x14293 that pops the LJMP target, calls `0x164A2` (the segment-lookup dispatcher), patches the LJMP's segment word, and far-returns
- Overlay segment directory format is partially decoded — segment-id ↔ file-offset mapping is the next leverage point

## Notes

- 17 files inside `raw/COLONIZE/` (TERRAIN.SS.000.png, .json, .part shards) are flagged as **foreign / derived** in `MANIFEST.md`.
- `colowin/` (Win16 build) is **out of scope by user rule**.
