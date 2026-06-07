# VICEROY.EXE — Pseudo-C Decompilation

## Session log

| Date       | Change                                                                                                                          |
|-----------|----------------------------------------------------------------------------------------------------------------------------------|
| 2026-05-02 | File created. Pivoted from line-by-line .asm annotation to pseudo-C as the primary work product (per user feedback). |
| 2026-05-02 | **MAJOR**: identified `*(0x8542)` as the colony struct via the production-chain dispatch in `colony_turn_update` at 0xA3E1. Full struct layout decoded. |
| 2026-05-02 | Ported 25+ functions to pseudo-C: lookup_byte_from_pair, blit_at_origin_if_pair_visible, classify_pair_bounds, test/set bit accessors, packed nibble pack/unpack, nibble→4-tier, count/find in colony arrays, register_origin_to_overlay, set_or_clear_bit_at_84, init_and_scan_units_in_area, find_indexed_match_then_compute, set_commodity_band_at_index, dispatch_via_8e02_with_band, check_total_exceeds_threshold, **colony_turn_update (705 bytes — 7 production chains identified)**, **update_and_render_tile_at (532 bytes)**, **compute_terrain_yield (1120 bytes — high-level summary)**, colony_transfer_commodity_to_unit, colony_receive_commodity_from_unit, system_init (high-level summary). |
| 2026-05-02 | Ported 12 dispatch thunks (LCALL 0xD1D:0x7A4 with 12 distinct opcodes). |
| 2026-05-02 | Ported the 8-function format-buffer pipeline (printf-family, all converging on format_to_buffer_2D54 at 0x260E). |
| 2026-05-02 | **Round 2 — colony continuation**: ported `colony_assign_or_change_colonist_job` (0x9318, 782 bytes — the colony's 4-way dispatcher for change-job / population-grow / unit-enter / unit-leave), `compute_colony_center_yields` (0xA222, 447 bytes — colony center tile food/best-non-food computer), `auto_assign_unassigned_colonists` (0xB150, 155 bytes — post-load assignment fix-up). |
| 2026-05-02 | **Round 2 — boot / asset loaders**: ported `_open` (0x11D30, ~750 bytes), documented all 5 DOS Open File sites in VICEROY.EXE (0x011D60 + 0x011E59 = `_open`; 0x015635 + 0x016F39 = `fopen` core; 0x01A495 = RTLink overlay loader's `open EXE for read`); ported `_read` (0x114E4, 125 bytes); ported `dos_exec_load_overlay_4B3` (0x1287A, 136 bytes — DOS 4Bh/3 load-overlay). Documented why only 7 of 289 asset filenames appear by name in the EXE: most asset names are constructed at runtime in **overlay code**, so the asset loaders themselves live in overlay segments accessed via the RTLink thunk table. |
| 2026-05-02 | **Round 3 — UnitRecord cargo + savegame loader**: ported `unit_load_commodity_into_slots` (0xB368, 126 bytes), `unit_cargo_slot_kind_or_neg1` (0xB2A2 + fall-through to 0xB2C2), `unit_cargo_slot_set_quantity` (0xB304, 21 bytes), `load_game_state` (0x11F6E, 403 bytes — savegame parser using 0xAE-byte ColonyRecord buffer). Decoded UnitRecord cargo layout: cargo_kind packed nibbles at +0x0B..0x0D, cargo_qty bytes at +0x0E..0x13, with cargo_slot_count at +0x0A. Confirmed `*(0x8542)` points at a single ColonyRecord (174-byte stride, matches savegame's per-record buffer). |
| 2026-05-02 | **Round 4 — viceroy_source/ tree built**: created the production-form C source tree with citation convention. 12 hand-written .c files (boot, runtime, iolib, colony, unit, overlay/rtlink, overlay/dispatch_thunks, data) + 11 headers. ~50 functions hand-ported with full semantic detail. Total ~2,200 .c source lines. See `viceroy_source/README.md` for the citation convention. |
| 2026-05-02 | **Round 5 — overlay full-coverage pass**: `tools/overlay_classifier.py`, `tools/overlay_to_c.py`, `tools/overlay_body_gen.py`, `tools/overlay_segment_inferrer.py`, `tools/overlay_role_tagger.py`, `tools/overlay_pattern_fillers.py`. Result: **all 691 overlay functions now have citation-backed C** in `viceroy_source/src/overlay/` (24 chunked files). Each function has complete `@asm` block + auto-traced control-flow body documenting every CALL/LCALL/branch. **274 functions auto-tagged with @inferred_role** (COLONY_TOUCHED 50, DIALOG_DRAW 45, TEXT_DRAW 37, etc.). 12 of the largest hand-renamed and individually annotated (`func_064A10_map_or_turn_setup`, `func_03D510_pick_random_colony_weighted`, `func_02D658_open_colony_view`, `func_051EF4_score_tick_for_power`, `func_02C5D4_draw_one_colony_report_row`, `func_038418_open_colonies_list`, `func_039EE2_continental_or_revolution_dispatch`, `func_04E2D6_draw_unit_on_map`, `func_0409D6_render_unit_info`, `func_0759E8_history_or_score_screen`, `func_076642_setup_form_dialog`, `func_069D8C_text_heavy_dialog`). 432 distinct overlay LCALL targets cataloged in `viceroy_source/include/overlay_externs.h`. Total .c lines: 28,601. Total .h lines: 1,444. **100% citation coverage of VICEROY.EXE achieved.** |



This is the primary work product for VICEROY.EXE reverse engineering.
Functions are described in pseudo-C using known struct field names, helper
function names, and global names. The raw .asm files in `disasm/` remain
the ground truth for byte-level verification.

**Status:** populated incrementally. When a function is added here, its
disasm/.asm file should still exist (renamed from `unknown` to a meaningful
name) but does not need full line-by-line annotation.

---

## Global naming conventions

| File-offset prefix | Pseudo-C name             | Notes                                  |
|--------------------|---------------------------|----------------------------------------|
| `fn_<6hex>`        | The function itself       | Anchored to the file offset            |
| `g_<sym>`          | A DGROUP global           | E.g. `g_map_width = *(uint16*)0x853A`  |
| `ctx`              | `*(0x8542)` current ctx   | The most-touched DGROUP global         |
| `unit[i]`          | UnitRecord at idx `i`     | Stride 0x1C, base DGROUP:0x3144 (0x3146=type +0x02; 0x315E=+0x1A) |
| `power[i]`         | PowerRecord at idx `i`    | Stride 0x13C                           |

---

## Known DGROUP globals

```c
// Confirmed from disassembly + manual_funcs.json:
extern uint16_t g_map_width        = *(uint16_t*)0x853A;   // map cell columns
extern uint16_t g_map_height       = *(uint16_t*)0x853C;   // map cell rows
extern context_t* ctx              = *(context_t**)0x8542; // most-touched (102 fns)

// Per-commodity word arrays (20 slots each, indexed 0..14 for commodities 0..14;
// commodity 14 = Tools has special-case adjustment using over_high[6] = Ore):
extern uint16_t g_global_amount[20] = (uint16_t[])0x8DC8;  // global per-commodity baseline
extern uint16_t g_band_base[20]     = (uint16_t[])0x8E0A;  // 'set' / threshold value
extern uint16_t g_over_low[20]      = (uint16_t[])0x8E32;  // overflow above midpoint
extern uint16_t g_over_high[20]     = (uint16_t[])0x8E5A;  // shortfall below midpoint
                                                            // g_over_high[6] = the
                                                            // word at 0x8E66 used to
                                                            // dampen Tools demand

// Pair-table (20-entry; indexed 0..0x13). Used by find_pair_in_table_C8_DE:
extern uint8_t  g_pair_key1[20]     = (uint8_t[])0xC8;     // pair table key1 (e.g. screen X)
extern uint8_t  g_pair_key2[20]     = (uint8_t[])0xDE;     // pair table key2 (e.g. screen Y)

// Other near references seen in this region:
extern uint16_t g_iter_handle       = *(uint16_t*)0x8D78;  // iterator handle (LCALL 0x427:0x5C, 0x427:0x4A)
extern uint16_t g_iter_aux_a        = *(uint16_t*)0x8D72;
extern uint16_t g_iter_aux_b        = *(uint16_t*)0x8D74;
extern uint16_t g_iter_aux_c        = *(uint16_t*)0x8D76;
extern uint16_t g_pop_or_year       = *(uint16_t*)0x8DB8;  // mode/era flag (compared to 1, 2)
extern uint16_t g_render_aux_a      = *(uint16_t*)0x8D4C;  // used in dispatch (func_008982)
extern uint16_t g_render_aux_b      = *(uint16_t*)0x8D4E;  // ptr (deref +5 to inc byte)
extern uint16_t g_progress_4_5394   = *(uint16_t*)0x5394;  // game-progress field
extern uint8_t  g_progress_5_53A6   = *(uint8_t*)0x53A6;
extern uint8_t  g_render_flag_34D   = *(uint8_t*)0x34D;
extern uint8_t  g_table_543F[?]     = (uint8_t[])0x543F;   // stride 0x34, indexed by ctx.byte[+0x1A]
extern uint8_t  g_table_3146[?]     = (uint8_t[])0x3146;   // stride 0x1C (UnitRecord field +0)
extern uint8_t  g_table_315B[?]     = (uint8_t[])0x315B;   // stride 0x1C (UnitRecord field?)
extern uint8_t  g_table_8D9E[?]     = (uint8_t[])0x8D9E;   // accessed via [bx+si-0x7262]; SI=key1*5
```

---

## Struct: `colony_t` (the `*(0x8542)` struct — CONFIRMED COLONY)

The struct at `*(0x8542)` is **the current colony struct**, confirmed by
the colony_turn_update function at 0xA3E1 which dispatches the standard
Colonization production chains (Sugar→Rum, Tobacco→Cigars, Cotton→Cloth,
Furs→Coats, Ore→Tools) using the per-commodity word array at +0x9A.

```c
struct colony_t {
    uint8_t  map_x;           // +0x00  colony's map X coord (1-based; interior offset = x-2)
    uint8_t  map_y;           // +0x01  colony's map Y coord
    uint8_t  _pad_02[0x18];   // +0x02..0x19 — TBD
    uint8_t  owner_power;     // +0x1A  owning power (0..3 = English/French/Spanish/Dutch
                              //                    or English/Dutch/French/Spanish in
                              //                    standard MicroProse order; 4+ = NPCs);
                              //                    selects per-power 0x34-byte record at
                              //                    DGROUP:0x543F + owner * 0x34
    uint8_t  flags_at_1c;     // +0x1C  bit-flag byte (bit 1, bit 2 affect production)
    uint8_t  _pad_1d_1e[2];   // +0x1D..0x1E
    uint8_t  population;      // +0x1F  number of working colonists; bounds the per-colonist
                              //                    arrays at +0x20, +0x40, +0x60-nibble

    uint8_t  job_at_20[?];    // +0x20  per-colonist job/profession (0..0x12 for jobs
                              //                    plus 0x13/0x14 = idle / specialist tools)
                              //                    0x13 separates "real jobs" from
                              //                    extension overflow into UnitRecord
    uint8_t  unit_type_at_40[?]; // +0x40  per-colonist unit type (0..0x17) — 0x17 (Arctic?)
                              //                    is remapped to 0x15 by setter 0x913C
    uint8_t  expertise_60[?]; // +0x60  packed-nibble: per-colonist expertise level
                              //                    (0..15, bucketized to 0..3 by 0x9184)
    uint8_t  tile_state_70[20]; // +0x70  per-grid-square tile state (the 20 surrounding
                              //                    tiles indexed via find_pair match);
                              //                    0xFF = empty, else per-tile flags
    uint8_t  bits_at_84[6];   // +0x84  bit-array #1 (48 bits) — building presence?
    uint8_t  bits_at_8a[?];   // +0x8A  bit-array #2 — building/feature flags
    uint8_t  _pad_92_94[?];   // +0x92..0x94
    uint8_t  era_at_95;       // +0x95  technology / era counter (used by step_100×scaled)
    uint8_t  _pad_96_99[4];   // +0x96..0x99
    uint16_t stockpile_9a[20]; // +0x9A  per-commodity stockpile (15 commodities + 5 slack);
                              //                    indexed by commodity_id (0..14):
                              //                    [0]=Food, [1]=Sugar, [2]=Tobacco, [3]=Cotton,
                              //                    [4]=Furs, [5]=Lumber, [6]=Ore, [7]=Silver,
                              //                    [8]=Horses, [9]=Rum, [10]=Cigars, [11]=Cloth,
                              //                    [12]=Coats, [13]=TradeGoods, [14]=Tools
    uint16_t liberty_aa;      // +0xAA  liberty-bell / rebellion-sentiment counter
    uint8_t  _pad_ac_b5[10];  // +0xAC..0xB5
    uint16_t progress_b6;     // +0xB6  tutorial / progress counter (used in func_009318)
    uint8_t  _pad_b8_c1[10];  // +0xB8..0xC1
    uint16_t field_at_c2;     // +0xC2  word read by 0x8524 (TBD)
    uint16_t cumulative_c6;   // +0xC6  long counter (incremented by 100 in 0x9318:0x9453)
    uint16_t cumulative_c8;   // +0xC8  high word of long
    // ... more fields beyond +0xC8 TBD
};
```

(Field offsets are confirmed by direct reference; `?` widths reflect arrays
whose declared length depends on `population`. Per-power record at
DGROUP:0x543F has stride 0x34 = 52 bytes, so a max of ~4–8 powers fits
the typical Colonization power roster.)

---

## Region: load_image — pair-table + context accessors

### `int find_pair_in_table_C8_DE(uint8_t key1, uint8_t key2)` @ 0x8892

Linear scan of the 20-entry parallel byte tables at `g_pair_key1` (DGROUP:0xC8) and
`g_pair_key2` (DGROUP:0xDE). The two input keys are first decremented by 2
(callers pass 1-based screen coords; the tables are 0-based interior coords or
the tables index a smaller region than the screen).

```c
int find_pair_in_table_C8_DE(uint16_t key1, uint16_t key2) {
    key1 -= 2;
    key2 -= 2;
    for (int i = 0; i < 20; i++) {
        if (g_pair_key1[i] == (uint8_t)key1 && g_pair_key2[i] == (uint8_t)key2)
            return i;
    }
    return -1;
}
```

### `int lookup_byte_from_pair(uint8_t key1, uint8_t key2)` @ 0x8956

Looks up `(key1, key2)` in the pair table; if matched, returns the byte from
`ctx->array_at_70[match_idx]`. Returns 0xFF on no match.

```c
int lookup_byte_from_pair(uint16_t key1, uint16_t key2) {
    int idx = find_pair_in_table_C8_DE(key1, key2);
    if (idx < 0) return 0xFF;
    return ctx->array_at_70[idx];
}
```

### `void blit_at_origin_if_pair_visible(uint8_t key1, uint8_t key2, uint16_t arg3)` @ 0x8918

If `(key1, key2)` is a registered pair, translate the coords by the context origin
and dispatch to the far drawer at 0x37F:0x15E. The pair-table lookup is used purely
as a "is this position visible?" predicate — the match index is discarded.

```c
void blit_at_origin_if_pair_visible(uint16_t key1, uint16_t key2, uint16_t arg3) {
    if (find_pair_in_table_C8_DE(key1, key2) < 0) return;
    int adj_x = key1 + (ctx->origin_x - 2);
    int adj_y = key2 + (ctx->origin_y - 2);
    far_call_037F_015E(adj_x, adj_y, 0x10, arg3);   // overlay-resident drawer
}
```

### `int classify_pair_bounds(uint16_t primary, uint16_t secondary)` @ 0x929A

Custom 4-case dispatch code based on whether primary fits `ctx->count` and
whether secondary fits the 20-entry pair table:

```c
int classify_pair_bounds(uint16_t primary, uint16_t secondary) {
    bool p_in = primary < ctx->count;
    bool s_in = secondary < 0x13;
    if (p_in)  return s_in ? 0 : 2;
    else       return s_in ? 3 : 1;
}
```

### `int test_bit_at_8a(uint16_t bit_idx)` @ 0x85B2

```c
bool test_bit_at_8a(uint16_t bit_idx) {
    return (ctx->bits_at_8a[bit_idx >> 3] & (1u << (bit_idx & 7))) != 0;
}
```

### `void set_or_clear_bit_at_8a(uint16_t bit_idx, uint16_t set_flag)` @ 0x85D6

```c
void set_or_clear_bit_at_8a(uint16_t bit_idx, uint16_t set_flag) {
    uint8_t* p = &ctx->bits_at_8a[bit_idx >> 3];
    uint8_t mask = 1u << (bit_idx & 7);
    if (set_flag) *p |=  mask;
    else          *p &= ~mask;
}
```

### `int current_unit_field_at_20(uint16_t i)` @ 0x90C8

```c
int current_unit_field_at_20(uint16_t i) {
    if (i >= ctx->count) return ctx->count;   // sentinel: index out of range
    return ctx->array_at_20[i];
}
```

### `int current_unit_field_at_40(uint16_t i)` @ 0x9102

```c
int current_unit_field_at_40(uint16_t i) {
    if (i >= ctx->count) return ctx->count;
    return ctx->array_at_40[i];
}
```

### `void set_field_at_40_or_unit_byte(uint16_t i, uint16_t value)` @ 0x913C

Dual-mode setter: in-bounds writes to ctx; out-of-bounds writes through to a
UnitRecord overflow slot (treats `i - count` as an offset converted via helper
0x8BD4 to a UnitRecord index, then writes the byte at field offset 0
within `unit[converted_idx]`). The value 0x17 is remapped to 0x15 before storing.

```c
void set_field_at_40_or_unit_byte(uint16_t i, uint16_t value) {
    if (value == 0x17) value = 0x15;          // 23 → 21 remap (terrain or unit-type)
    if (i < ctx->count) {
        ctx->array_at_40[i] = (uint8_t)value;
    } else {
        int unit_idx = helper_8BD4(i - ctx->count);
        unit[unit_idx].field_at_315B_offset = (uint8_t)value;
        // (DGROUP:0x315B + unit_idx*0x1C — likely UnitRecord field +0 or -3)
    }
}
```

### `int unpack_nibble_at_60(uint16_t i)` @ 0x8F2A

```c
int unpack_nibble_at_60(uint16_t i) {
    if (i >= ctx->count) return /* fall through */;   // out-of-bounds: function falls
                                                       // through past its RETF into
                                                       // the next function (0x8F60)
    uint8_t b = ctx->packed_60[i >> 1];
    return (i & 1) ? (b >> 4) & 0xF : b & 0xF;
}
```

### `void pack_nibble_at_60(uint16_t i, uint16_t value)` @ 0x8F6C

```c
void pack_nibble_at_60(uint16_t i, uint16_t value) {
    if (i >= ctx->count) return;
    if (value > 15) value = 15;
    uint8_t* p = &ctx->packed_60[i >> 1];
    if (i & 1) {
        *p = (*p & 0x0F) | ((uint8_t)value << 4);
    } else {
        *p = (*p & 0xF0) | (uint8_t)value;
    }
}
```

### `int nibble_to_4_tier_quantity(uint16_t i)` @ 0x9184

Bucketizes a packed nibble into 0..3 ("none / small / medium / full"):

```c
int nibble_to_4_tier_quantity(uint16_t i) {
    int n = unpack_nibble_at_60(i);
    if (n == 15) return 3;       // full
    if (n >=  8) return 2;       // large
    if (n >=  4) return 1;       // medium
    return 0;                    // small / empty
}
```

### `int count_field_at_20_matching(uint8_t target)` @ 0x9626

Histogram bucket: counts how many entries in `ctx->array_at_20[0..count-1]`
equal `target`.

```c
int count_field_at_20_matching(uint8_t target) {
    int tally = 0;
    for (int i = 0; i < ctx->count; i++) {
        if (current_unit_field_at_20(i) == target) tally++;
    }
    return tally;
}
```

### `int count_field_at_40_matching(uint8_t target)` @ 0x965C

Sister of 0x9626 — counts the +0x40 array instead.

```c
int count_field_at_40_matching(uint8_t target) {
    int tally = 0;
    for (int i = 0; i < ctx->count; i++) {
        if (current_unit_field_at_40(i) == target) tally++;
    }
    return tally;
}
```

### `int count_field_40_matches_field_20()` @ 0x9692

Counts slots where ctx->array_at_40[i] is a valid commodity (< 0x13) AND
equals ctx->array_at_20[i]. Likely "count units whose assigned-job matches
their produced-commodity" — i.e. the count of correctly-employed colonists.

```c
int count_field_40_matches_field_20(void) {
    int tally = 0;
    for (int i = 0; i < ctx->count; i++) {
        int field40 = current_unit_field_at_40(i);
        int field20 = current_unit_field_at_20(i);
        if (field40 < 0x13 && field40 == field20) tally++;
    }
    return tally;
}
```

### `int find_nth_match_in_field_at_20(uint8_t target, int n)` @ 0x96DA

Find-Nth-occurrence in `ctx->array_at_20`. Returns the index of the Nth
slot whose value equals `target`, or -1 if there are fewer than N matches.

```c
int find_nth_match_in_field_at_20(uint8_t target, int n) {
    int result = -1;
    int hits = 0;
    for (int i = 0; i < ctx->count && result < 0; i++) {
        if (ctx->array_at_20[i] == target) {
            hits++;
            if (hits == n) result = i;
        }
    }
    return result;
}
```

### `void register_origin_to_overlay_9EF()` @ 0x9726

Computes a 32-bit origin-pixel-or-cell offset from `ctx->origin_x/y` plus
a long base at `g_long_8D80` (DGROUP:0x8D80–0x8D83), then dispatches to
overlay `0x9EF:0x1A`. Preceded by an overlay setup call to `0x9EF:0x2C`
with the value at `g_field_917A`.

```c
void register_origin_to_overlay_9EF(void) {
    overlay_call_09EF_002C(g_field_917A);
    long offset = ((long)ctx->origin_y << 8) | ctx->origin_x;
    offset += g_long_8D80;          // 32-bit base offset
    overlay_call_09EF_001A(offset);
}
```

### `void set_or_clear_bit_at_84(uint16_t bit_idx, uint16_t set_flag)` @ 0x92E0

Same pattern as `set_or_clear_bit_at_8a` but for the bit-array at
`ctx->bits_at_84` (a SECOND bit array in the struct, at offset +0x84
rather than +0x8A). NOTE: the auto-detector split this one too — full
function spans 0x92E0..0x9317 (40 bytes).

```c
void set_or_clear_bit_at_84(uint16_t bit_idx, uint16_t set_flag) {
    uint8_t* p = &ctx->bits_at_84[bit_idx >> 3];   // ctx + 0x84 + idx/8
    uint8_t mask = 1u << (bit_idx & 7);
    if (set_flag) *p |=  mask;
    else          *p &= ~mask;
}
```

(Updates the struct definition above: add `uint8_t bits_at_84[?]` at +0x84
preceding `bits_at_8a` at +0x8A — implies six bytes of bit-array at +0x84
covering at most 48 entries.)

### `int step_100_or_level_scaled()` @ 0x8D00

```c
int step_100_or_level_scaled() {
    if (ctx->level_at_95 == 0) return 100;
    return (ctx->level_at_95 + 1) * 100;
}
```

---

## Region: load_image — commodity-band tracker (0x8E02 / 0x8E46 / 0x8F02)

These three functions form the per-commodity Europe-market price/quantity
band tracker. The triple of parallel WORD arrays at DGROUP:0x8E0A,
0x8E32, 0x8E5A holds (base, over_low, over_high) for each of 20 slots
(though only commodity indices 0..14 appear to be used — 15 is unaccounted).

### `void set_commodity_band_at_index(int idx, uint16_t midpoint, uint16_t primary, uint16_t delta)` @ 0x8E02

```c
void set_commodity_band_at_index(int idx, uint16_t midpoint, uint16_t primary, uint16_t delta) {
    g_band_base[idx] = primary;
    g_over_low[idx]  = (primary > midpoint)            ? (primary - midpoint)            : 0;
    g_over_high[idx] = ((primary - delta) < midpoint)  ? (primary - delta - midpoint)    : 0;
    // Note: the "(primary - delta - midpoint)" is positive because the JGE check
    // ensures (midpoint + delta) < primary, i.e. (primary - delta) > midpoint and
    // (primary - delta - midpoint) > 0.
    // Wait — check the asm: it stores AX=(primary-delta-midpoint) only when
    // (midpoint+delta) < primary (i.e. primary-delta > midpoint), which means
    // (primary-delta-midpoint) is POSITIVE. So over_high is the amount by which
    // (primary - delta) exceeds midpoint — a "drift overshoot" indicator.
}
```

### `void dispatch_via_8e02_with_band(int idx, uint16_t midpoint)` @ 0x8E46

Reads the per-index global amount, applies the special-case Tools-vs-Ore
adjustment (when `idx == 14`, subtract `g_over_high[6]` from the primary —
i.e. surplus Ore reduces effective Tools demand), and forwards to
set_commodity_band_at_index.

```c
void dispatch_via_8e02_with_band(int idx, uint16_t midpoint) {
    uint16_t primary = g_global_amount[idx];
    if (idx == 14 && g_over_high[6] != 0) {
        primary -= g_over_high[6];   // Tools demand reduced by Ore surplus
    }
    uint16_t delta = ctx->array_word_9a[idx];
    set_commodity_band_at_index(idx, midpoint, primary, delta);
}
```

### `int check_total_exceeds_threshold(int idx)` @ 0x8F02

```c
int check_total_exceeds_threshold(int idx) {
    uint16_t total = ctx->array_word_9a[idx] + g_global_amount[idx];
    if (total > g_band_base[idx]) return 1;
    /* fall through to func_008F2A on else (predicate-then-fallthrough) */
}
```

---

## Region: boot / system_init pipeline

### `void system_init()` @ 0x13BF7 (1368 bytes)

The BOOT-TIME initialization function. Called once via LCALL from
`entry_point` (0x13BED) before the C runtime's `cstart` runs. Its
job is to set up DOS / EMS / XMS / heap state and store the runtime
memory layout in DGROUP globals at [0x3995..0x39FF] for later use
by file I/O, the asset loader, and the renderer.

```c
void system_init(void) {
    // ---- Phase 1: Save loader state ----
    g_saved_ds = DS;
    g_saved_es = ES;
    g_saved_ss = SS;

    // ---- Phase 2: DOS Get-Version ----
    int dos_ver = int21h_AH_30();        // INT 21h AH=30h
    g_dos_version = dos_ver;
    if (LOBYTE(dos_ver) < 2) panic_exit("DOS 2.0+ required");

    // ---- Phase 3: EMS detection (INT 67h) ----
    bool ems_present = ems_probe();      // INT 67h AH=42h
    if (ems_present) {
        g_ems_handle = ems_alloc(1);     // 1 page (16 KB)
        if (g_ems_handle < 0) g_ems_present = 0;
    }

    // ---- Phase 4: XMS detection ----
    g_xms_present = xms_detect_at_18153();
    if (g_xms_present) {
        g_xms_handle = xms_alloc_64k();
    }

    // ---- Phase 5: Conventional memory ceiling ----
    int psp_ceiling = read_word(MK_FP(g_psp_seg, 2));   // PSP[2..3] = top of memory
    int program_break = compute_program_break();         // BSS end + heap + stack

    // ---- Phase 6: Compute layout ----
    int near_heap_size = compute_near_heap_size();
    int far_heap_size  = compute_far_heap_size();
    int ems_window     = compute_ems_window();

    // ---- Phase 7: Shrink program memory block ----
    int shrink_size = program_break + near_heap_size + far_heap_size + ems_window;
    int21h_AH_4A(shrink_size);            // INT 21h AH=4Ah Resize Memory

    // ---- Phase 8: Allocate near-heap base ----
    int near_heap_seg = int21h_AH_48(near_heap_size);  // Allocate Memory
    if (near_heap_seg < 0) panic_no_memory();

    // ---- Phase 9: Hook environment-variable INT 21h handlers ----
    g_old_int21h_25 = get_vector_25h();    // current 25h subhandler
    g_old_int21h_45 = get_vector_45h();
    install_env_var_int21h_hooks();        // function 35h+25h sub-21h overrides

    // ---- Phase 10: Initialize globals at DGROUP:0x3995..0x39FF ----
    g_layout_3995 = near_heap_seg;
    g_layout_3997 = near_heap_size;
    g_layout_3999 = far_heap_size;
    // ... ~20 more layout globals
    g_layout_3997..[0x39FF] = ...;

    // (Far-return; pre-existing DS/ES/SS are restored from stack)
    return;
}
```

This is a high-level summary; the full byte-level annotation is in
the disasm file `func_013BF7_system_init.asm` (region 1 of 4 done so far).

---

## Region: boot / file I/O — _open / _creat / fopen (the asset-loader gateway)

These are the C-runtime file primitives. **Every asset loader in VICEROY
reaches the disk through one of these.** The four DOS Open call sites
identified by binary scan are at file offsets `0x011D60` (`_open` core),
`0x011E59` (`_open` create-then-open path), `0x016F39` (a third loader,
likely savegame), and `0x01A495` (overlay-loader file open).

### `int _open(const char* path, int oflag, int pmode)` @ 0x11D30 (full size ~750 bytes including create branch)

The C runtime's low-level `_open()`. Handles text/binary mode (O_TEXT/O_BINARY),
read/write/read-write modes, file creation (O_CREAT), truncation (O_TRUNC),
append mode (O_APPEND), and the legacy text-mode CR/LF translation when
opening an existing text file for write.

```c
int _open(const char* path, int oflag, int pmode) {
    bool text_mode = false;
    char fmode_byte = 0;     // [bp-4] — internal mode flag

    // ---- Determine binary vs text mode ----
    if      (oflag & 0x8000) /* O_BINARY */ text_mode = false;
    else if (oflag & 0x4000) /* O_TEXT   */ text_mode = true;
    else if (g_default_text_mode_flag_2B01 & 0x80) text_mode = false;
    else                                            text_mode = true;

    if (text_mode) fmode_byte = 0x80;

    // ---- DOS Open Existing File ----
    int dos_mode = (oflag & 3);     // 0=read, 1=write, 2=read-write
    int handle = int21h_AH_3D(path, dos_mode | (fmode_byte == 0x80 ? 0 : 0));
    if (FAILED) {
        if (errno == ENOENT && (oflag & 0x100) /* O_CREAT */) {
            goto create_branch;     // 0x11E13
        }
        return errno_epilogue();    // 0x10AE5
    }

    // ---- Special: "open and truncate" combo ----
    if ((oflag & 0x500) == 0x500) {
        // 0x500 = both O_TRUNC + O_TEMPORARY-like — Microsoft-specific:
        // open succeeded but we wanted a fresh file: close and report error 0x11.
        int21h_AH_3E(handle);    // DOS Close
        return -1; errno = 0x11;
    }

    // ---- Test if it's a character device (TTY, COM, etc.) ----
    int dev_info = int21h_AX_4400(handle);   // DOS IOCTL Get Device Info
    if (dev_info & 0x80 /* IFCHR */) {
        // text-mode CR/LF conversion irrelevant for char devices
        // ... (handle device-specific setup)
    }

    // ---- Text-mode CR/LF translation: peek for ^Z (text terminator) ----
    if (text_mode) {
        int seek = int21h_AX_4202(handle, 0xFFFFFFFF);   // Seek End -1
        char ch;
        int n = int21h_AH_3F(handle, &ch, 1);            // Read 1 byte
        if (n != 0 && ch == 0x1A) {                       // ^Z
            int21h_AX_4202(handle, 0xFFFFFFFF);
            int21h_AH_40(handle, 0, 0);                   // Truncate at ^Z position
        }
        int21h_AX_4200(handle, 0);                        // Seek beginning
    }

    return handle;

create_branch:                          // 0x11E13
    // ---- File didn't exist + O_CREAT: create then open for read-write ----
    {
        int new_oflag = oflag & ~3;     // strip access bits temporarily
        int new_handle;
        if (text_mode) goto fallback_create;
        if (oflag & 2)  goto fallback_create;     // O_RDWR
        new_handle = int21h_AH_3C(path, pmode);   // DOS Create File
        if (FAILED) return errno_epilogue();
        // ... close-and-reopen sequence to get correct mode ...
        return new_handle;

      fallback_create:
        // Path opens for read-write after create
        new_handle = int21h_AH_3C(path, pmode);   // DOS Create
        if (FAILED) return errno_epilogue();
        int21h_AH_3E(new_handle);                  // close
        // re-open with the wanted mode
        new_handle = int21h_AH_3D(path, oflag & 3);
        if (FAILED) return errno_epilogue();
        return new_handle;
    }
}
```

### `int _creat(const char* path, int pmode)` (also @ ~0x11E33, embedded in _open's create branch)

```c
int _creat(const char* path, int pmode) {
    return _open(path, O_CREAT | O_TRUNC | O_RDWR, pmode);
}
```

### `int fopen_internal(const char* path, const char* mode)` (above _open)

The higher-level `fopen()` that takes a "rb" / "wb" / "r+" / etc. mode
string and converts it to oflag bits before calling `_open()`. NOT YET
LOCATED — but is one of the heaviest callers of `_open`. Likely lives
in the same .OBJ module (file offset ~0x11C00..0x11D30).

### Five DOS Open sites in VICEROY.EXE

The full inventory of `MOV AH, 0x3D / INT 21h` (DOS Open File) sites:

| File offset | Module / role |
|-------------|---------------|
| `0x011D60`  | `_open` — main C runtime open path |
| `0x011E59`  | `_open` — alternate path (same function, after CREATE) |
| `0x015635`  | **`fopen()` core**: opens by `MOV AL, CS:[0x3C3A]` (access-mode byte stored as a global) |
| `0x016F39`  | **`fopen()` re-open**: same access-mode pattern; this is the post-truncate reopen path within the same module as 0x15635 |
| `0x01A495`  | **RTLink overlay loader**: a tiny `near-call` helper that opens VICEROY.EXE itself to read overlay segments. Wraps INT 21h AH=3Dh in 7 instructions, called from the RTLink dispatcher chain |

The byte at `CS:0x3C3A` (referenced by both 0x015635 and 0x016F39) is
the per-`fopen` access-mode byte (0=read, 1=write, 2=read-write —
mapping the `"r"` / `"w"` / `"r+"` mode-string to the DOS access bits).
Both call sites belong to the same `.OBJ` module (the standard C
runtime's `fopen()`).

### `int rtlink_open_exe_for_overlay_read(int mode_byte)` @ ~0x01A488 (small helper, ~13 bytes)

The 7-instruction helper called by the RTLink overlay loader to open
`VICEROY.EXE` itself for reading overlay segments. Returns a DOS file
handle in AX (or CF=1 on error).

```c
// Helper near 0x01A488 — caller has pushed segment of path on stack
int rtlink_open_exe_for_overlay_read(int access_mode /*[bp+0xE]*/) {
    // Path pointer is at DS:DX (from caller), DS = caller's [bp+0xC]
    // INT 21h, AH=3Dh, AL=access_mode → AX = handle (or error)
    return int21h_AH_3D(/* DS:DX */, access_mode);
}
```

This helper is called from the larger RTLink overlay loader function
that lives at ~0x01A43C. The big function is responsible for:
1. Finding the EXE filename in the program's command-line args
2. Walking past `\` and `:` characters to get the bare filename
3. Calling this helper to open it
4. Reading overlay segment headers
5. Storing the file handle in DGROUP for later overlay-segment reads

---

## Region: boot / asset-loader top-level

The asset loaders are the layer above `_open`. When the game needs e.g.
`VICEROY.PAL`, the loader function:
1. Builds the filename (literal string OR `sprintf("PHYS%d.SS", index)`).
2. Opens via `_open` or `fopen`.
3. Reads the header (typically 4-8 bytes).
4. Allocates a buffer (via `malloc` / `coreleft_check_then_alloc`).
5. Reads the body.
6. Closes.
7. Caches the buffer pointer in a per-asset DGROUP global.

### Direct-name asset xrefs (from `code/VICEROY/asset_xrefs.md`)

These are the seven filenames that appear as immediate strings in the
EXE:

| Asset filename | String at | Loader xref(s) | Notes |
|----------------|-----------|----------------|-------|
| `VICEROY.PAL`  | TBD       | TBD            | base palette |
| `AMER2.MP`     | 0x01FB06  | 0x011A62, 0x01A0CC, 0x034E93 | Americas map; loaded by func_011A62 |
| `AMERICA.MOV`  | 0x01F7F0  | 0x004973, 0x0049EB, 0x010501, 0x018567, ... | intro movie (played by OPENING.EXE) |
| `CONFIG.COL`   | 0x01F9F9  | (none — built dynamically?) | might be loaded by string-construction |
| `CYCLE.DAT`    | 0x01FF99  | 0x0645AE       | cycle/animation data |
| `TRIBE.TXT`    | 0x01F...  | TBD            | per-tribe data |

The other ~280 files in `COLONIZE/` (PHYS0.SS, ICONS.SS, etc.) are not
named directly in the EXE — they're built via `sprintf` from a printf-
template stored elsewhere. The format engine at `format_to_buffer_2D54`
(0x260E) is the apparent template-builder.

### `int load_AMER2_MP()` @ ~0x011A62 (TBD — site of AMER2.MP xref)

The function at 0x011A62 references the literal string `AMER2.MP`. It's
in the load-image (not overlay), making this the **map loader** for the
default Americas map. Likely also responsible for loading any `.MP` file
the user picks at "New Game".

(Pseudo-C TBD — to be filled in next.)

### `int load_game_state(file_handle, mode, count, init_flag)` @ 0x011F6E (403 bytes)

The savegame parser. Allocates a 0xAE-byte (174-byte) working buffer
that matches ColonyRecord stride, iterates over a list of records,
parses each via `0xD1D:0x2C8E` (the major record parser in the C
runtime overlay), uses `0xD1D:0x2746` for chunked file reads with
seek-to-position and `0xD1D:0x1F14` for fixed-size record reads.

```c
int load_game_state(int file_handle, int mode, int count, int init_flag) {
    uint8_t buf[0xAE];                  // single-record working buffer
    int  local_flags[8];

    void* alloc = overlay_call_0D1D_03D0(0xAE);   // malloc(0xAE)
    int file = file_handle;
    bool fresh_load = true;
    int  field = 0;

    if (init_flag == 0) {
        // First-time init: look up the savegame schema/dispatcher
        int dispatch = overlay_call_0D1D_0942(0x2AE2);   // table lookup by id 0x2AE2
        if (dispatch == 0) {
            g_errno_27AC = 8;            // ENOMEM-like
            return -1;
        }

        // Parse the master record: pointers to (count, mode, &flags, &field, &buf, handle, ...)
        int master = overlay_call_0D1D_2C8E(mode, count,
                                            &field, &local_flags, &buf[0],
                                            dispatch, file_handle);
        if (master + 1 == 0) {           // -1
            g_errno_27AC = 8;
            return -1;
        }
    }

    // Read schema header: 0x20-byte block at offset 0x8000 (flag bit) into a local
    int schema_handle = overlay_call_0D1D_2746(file_handle, 0x8000, 0x20);
    if (schema_handle == -1) {
        if (field != 0) overlay_call_0D1D_291C(field);  // free field
        g_errno_27AC = 8;
        return -1;
    }

    // Loop: read 0x18-byte records via 0xD1D:0x1F14 until end-of-list
    while (true) {
        int n = overlay_call_0D1D_1F14(schema_handle, &record[0x18], 0x18);
        if (n == -1) {
            overlay_call_0D1D_1E7A(schema_handle);   // close
            ...
            break;
        }
        // ... parse record fields, write into ColonyRecord array
    }

    // Cleanup
    _close(file_handle);
    int free_mem = coreleft_total();
    overlay_call_0D1D_291C(buf);          // free working buffer
    return 0;
}
```

This is the **savegame loader for the Colony array**. The 0xAE byte
buffer matches the ColonyRecord stride (the same struct that
`*(0x8542)` points at when a colony is "current"). The loader reads
N colonies into a backing array and the game then iterates the array
when computing turns.

### Boot-time asset loading order

The boot pipeline runs roughly:

```
entry_point (0x13BED)
  → system_init (0x13BF7)        // EMS/XMS/heap setup; saves runtime layout
  → dos_version_check_stub (0xF720)
  → cstart (0xF72D)               // C runtime init; calls precompiled-init chain
    → atexit init                  // (LCALL 0xD1D:0x1420)
    → FPU init                     // (LCALL 0xD1D:0x128E)
    → setargv equivalent           // (LCALL 0xD1D:0x248)
    → main (overlay thunk 0x1A5F0) // entry into the actual game code
      → (overlay-resident loaders for PAL, fonts, sprites, default map, etc.)
```

The overlay-resident main is what loads the PAL, ICONS, PHYS sheets, etc.
None of those load functions are in the load-image — they're in the
overlay segments accessed via the RTLink thunk table at 0x1A5F0.
**This is why the asset xref scan only found 7 of 289 filenames**: most
asset names are constructed at runtime in overlay code from format
strings stored in the overlay's data segments.

---

## Region: boot / memory + DOS exec helpers

### `int dos_exec_load_overlay_4B3(const char* exe_path, const void* param_block)` @ 0x01287A (136 bytes)

A DOS Exec / Load-Overlay helper. Allocates a maximum-sized memory block
(via DOS AH=48 BX=FFFF probe followed by AH=48 with the result), copies an
8-byte EXEC parameter block from DGROUP:0x26AB into the allocated segment,
saves SS:SP into globals, then calls **INT 21h, AH=4Bh, AL=3** (DOS Load
Overlay) with the path in DS:DX and the parameter block in ES:BX. After
the load, restores SS:SP from saved globals and returns BX = number of
free paragraphs above the overlay.

```c
int dos_exec_load_overlay_4B3(const char* exe_path, const void* param_block) {
    // ---- Probe maximum free memory ----
    int err = int21h_AH_48(0xFFFF);    // deliberately fail to get max paragraphs
    if (err) return err;               // out of memory

    int max_paras = BX - 2;            // leave 2 paragraphs slack
    int new_seg   = int21h_AH_48(max_paras);
    if (new_seg < 0) return errno_ENOMEM;

    // ---- Copy 8-byte EXEC parameter block from g_exec_param_26AB to overlay:8 ----
    memcpy(MK_FP(new_seg - 1, 8), &g_exec_param_26AB, 8);

    g_saved_ss = SS;                   // DGROUP:0x26A3
    g_saved_sp = SP;                   // DGROUP:0x26A5
    *(uint16_t*)(0x26A7) = new_seg;    // load segment slot in EXEC block
    *(uint16_t*)(0x26A9) = new_seg;    // (paired)

    int rc = int21h_AH_4B_AL_3(exe_path, MK_FP(DS, 0x26A7));   // DOS Load Overlay

    SS = g_saved_ss;
    SP = g_saved_sp;
    if (CF) return errno_translated();

    // ---- Compute paragraphs available above loaded overlay ----
    int psp_top  = *(uint16_t*)MK_FP(new_seg, 0x2C);     // PSP[0x2C] = env seg
    int psp_size = *(uint16_t*)MK_FP(new_seg, 0x2A);     // PSP[0x2A] = parent
    return /* difference = remaining paragraphs */;
}
```

**Use case:** this is how VICEROY.EXE could load auxiliary `.EXE` modules
(e.g. OPENING.EXE / CLOSING.EXE if not run via DOS shell), or load
non-RTLink overlays. The 4Bh/03h variant is "Load Overlay" — distinct
from the RTLink overlay system at 0x1A5F0. The two systems coexist:
RTLink for the main game's overlays, DOS 4Bh/03h for external auxiliary
modules.

### `void* malloc_via_coreleft_then_alloc(size_t size)` @ ~0x012599 (TBD — unfound boundary)

The pattern at file offsets 0x012599 / 0x012621 (both inside the same
unfound function) is the canonical:

```c
void* malloc(size_t size) {
    int paragraphs = (size + 15) >> 4;
    int seg = int21h_AH_48(paragraphs);
    if (FAILED) return NULL;
    return MK_FP(seg, 0);
}
```

These are the per-asset allocators called when loading e.g. AMER2.MP,
sprite sheets, etc. The full malloc/free implementation is in the
unfound function at file ~0x012573 (immediately before 0x012599).

### `int _read(int fd, void* buf, int count)` @ 0x0114E4 (125 bytes)

The C runtime's low-level `_read()` with text-mode CR/LF handling.
Used by all higher-level read functions (`fread`, `fgets`, etc.).

```c
int _read(int fd, void* buf, int count) {
    if (fd >= NFILE_QQ /* DGROUP:0x27B9 */) {
        return -1; errno = EBADF;
    }
    if (count == 0) return 0;
    if (g_file_flags[fd] & 2 /* AppendMode */) return 0;     // empty read
    if (g_iob_dispatch_2B16 == 0xD6D6) ((void(**)())0x2B18)();   // dispatcher hook

    int n = int21h_AH_3F(fd_dos_handle, buf, count);
    if (n < 0) { errno = 9; return -1; }

    if (!(g_file_flags[fd] & 0x80 /* TextMode */)) return n;  // binary: done
    g_file_flags[fd] &= 0xFB;                                   // clear flag bit 2

    // ---- Text-mode CR/LF translation ----
    char* dst = buf;
    char* src = buf;
    int  remaining = n;
    if (remaining == 0) return n;
    if (*src == '\n') g_file_flags[fd] |= 4;                    // LF at start
    while (remaining-- > 0) {
        char c = *src++;
        if      (c == '\r') /* CR — peek for LF, drop CR */ continue;
        else if (c == 0x1A /* ^Z */) {
            g_file_flags[fd] |= 2;                              // EOF mark
            break;
        } else {
            *dst++ = c;
        }
    }
    return dst - (char*)buf;
}
```

---

## Region: boot / C-runtime (already ported in manual_funcs.json)

See `manual_funcs.json` for full pseudo-C-friendly descriptions of:

- `entry_point` @ 0x13BED
- `system_init` @ 0x13BF7
- `dos_version_check_stub` @ 0xF720
- `cstart` @ 0xF72D
- `exit` @ 0xF8DD / `exit_abort` @ 0xF8E4
- `kbhit` @ 0xD272 / `getch` @ 0xD286
- `putchar` @ 0xFD20 / `getchar` @ 0xFD4E
- `find_file` @ 0x10433 / `unlink` @ 0x1041A
- `_close` @ 0x1144A / `_read` @ 0x10466 / `_write` @ 0x1046D
- `coreleft_total` @ 0x124D6 / `coreleft_max` @ 0x78AF2

---

## Region: load_image — colony-tile renderer

### `void update_and_render_tile_at(uint16_t key1, uint16_t key2, int8_t new_state)` @ 0x8982

The major colony-tile updater. Given a (key1, key2) screen position and a
new state byte, this function:

1. Looks up the (key1, key2) pair in the 20-entry pair table.
2. Pre-computes a "render parameter" via overlay helper 0x37F:0x2A0
   which takes (ctx->origin_x, ctx->origin_y).
3. Stores `new_state` into `ctx->array_at_70[match_idx]`.
4. If state is negative, or the global render gate `g_render_flag_34D`
   is set, returns without drawing.
5. Computes interior-translated `(draw_x, draw_y) = (key1, key2) + (origin - 2)`.
6. Asks the overlay's two clip predicates (0x37F:0x314 and 0x37F:0x3E4)
   whether the position is paintable. If neither says yes, the actual
   draw is skipped.
7. Calls overlay paint at 0x37F:0x228 with `(draw_x, draw_y, ctx->type_or_owner)`.
8. Reads `g_table_8D9E[key1 * 5 + key2]` — a 5-stride sub-table of tile
   IDs. If negative, falls into the "invalid tile" branch which writes
   0xFF into that table slot and calls `blit_at_origin_if_pair_visible(key1, key2, 1)`
   to render the cleared cell.
9. Otherwise dispatches to overlay-thunked drawer `0x181F:0xD84` with
   the tile id (minus 4 — likely an offset adjustment).
10. Cross-checks `power_record_read_dword(ctx->type_or_owner)` against
    a value computed by overlay-thunk `0x181F:0xD78` (uses `g_render_aux_a` as a parameter).
    The signed comparison decides whether an additional "visible to opponent"
    layer needs to be painted via near-call `0x8846`.
11. If `g_progress_4_5394 < 4` and the corresponding `g_table_543F[g_progress_4_5394*0x34] == 0`,
    derives an additional offset from `g_progress_5_53A6` (else 0).
    Adjusts that by 5, then doubles it twice based on `g_pop_or_year`
    being <= 1 / <= 2 (so the adjustment scales with era / population mode).
12. Calls overlay-thunked drawer `0x181F:0xD6C` to paint the secondary layer.

```c
void update_and_render_tile_at(uint16_t key1, uint16_t key2, int8_t new_state) {
    int match_idx = find_pair_in_table_C8_DE(key1, key2);
    int render_param = overlay_call_037F_02A0(ctx->origin_x, ctx->origin_y);

    if (match_idx < 0) goto cleanup;
    ctx->array_at_70[match_idx] = (uint8_t)new_state;
    if (new_state < 0) goto cleanup;
    if (g_render_flag_34D != 0) goto cleanup;

    int draw_x = key1 + (ctx->origin_x - 2);
    int draw_y = key2 + (ctx->origin_y - 2);

    int clip1 = overlay_call_037F_0314(draw_x, draw_y);
    if (clip1 < 0) {
        int clip2 = overlay_call_037F_03E4(draw_x, draw_y);
        if (clip2 < 0) {
            overlay_call_037F_0228(draw_x, draw_y, ctx->type_or_owner);
        }
    }

    int tile_id = (int8_t)g_table_8D9E[key1 * 5 + key2];   // 5-wide sub-table
    if (tile_id < 0) {
        // SET_TILE_INVALID branch
        g_table_8D9E[key1 * 5 + key2] = 0xFF;
        blit_at_origin_if_pair_visible(key1, key2, 1);
        goto cleanup;
    }

    overlay_thunk_181F_0D84(draw_x, draw_y, -1, render_param);

    int extra_flag = 0;
    if (ctx->type_or_owner >= 4 ||
        g_table_543F[ctx->type_or_owner * 0x34] != 0)
    {
        // Per-owner secondary rendering needed
        extra_flag = overlay_thunk_181F_0D78(draw_x, draw_y, ctx->type_or_owner, g_render_aux_a);

        long power_dword = power_record_read_dword(ctx->type_or_owner);   // 0x87F4
        long flag_dword  = (long)extra_flag;
        long diff = power_dword - flag_dword;

        // (high-half compare on diff vs flag/2 — the asm is doing a 32-bit signed >= test)
        if (diff >= flag_dword / 2) {
            ((uint8_t*)g_render_aux_b)[5]++;
            near_call_8846(draw_x, draw_y, ctx->type_or_owner);  // power-flag overlay
        } else {
            extra_flag = 0;
        }
    }

    if (extra_flag == 0) {
        int era_offset;
        if (g_progress_4_5394 < 4 && g_table_543F[g_progress_4_5394 * 0x34] == 0) {
            era_offset = g_progress_5_53A6;
        } else {
            era_offset = 0;
        }
        int sprite_y = era_offset + 5;
        int sprite_x = sprite_y;
        if (g_pop_or_year <= 2) sprite_x *= 2;
        if (g_pop_or_year <= 1) sprite_x += sprite_y;

        // Probe one more overlay position; double it if the probe returns -1
        if (overlay_call_037F_04B0(draw_x, draw_y) == -1) sprite_x *= 2;

        overlay_thunk_181F_0D6C(tile_id - 4, ctx->type_or_owner, sprite_x, 0);
    }

cleanup:
    return;
}
```

This is a large dispatcher. The structure is clearer than its 532 bytes
suggests — most of the size comes from the seven overlay LCALLs, each of
which assembles arg lists from `(draw_x, draw_y, ctx->type_or_owner, g_render_aux_*)`
in slight variations.

---

---

## Region: load_image — overlay-op dispatch thunks (LCALL 0xD1D:0x7A4)

Twelve identical-shape thunks at file offsets 0x28B0..0x2982, each wrapping
a far call to overlay function `0xD1D:0x7A4` with a fixed 16-bit opcode
plus the caller's argument. These are convenience wrappers for the major
dispatch table at `0xD1D:0x7A4(opcode, arg)`. The opcodes are not contiguous
(0x51, 0x53, 0x54, 0x56, 0x57, 0x59, 0x5A, 0x5B, 0x5D, 0x5F, 0x61, 0x63,
0x65, 0x67, 0x69 are NOT exposed as wrappers in this set), suggesting the
dispatcher may handle some opcodes only via direct LCALL from elsewhere.

| File offset | Pseudo-C function name             | Opcode | Likely role |
|-------------|------------------------------------|--------|-------------|
| 0x28B0      | `dispatch_overlay_op_50(arg)`      | 0x50   | already named call_overlay_with_80 (=0x50 dec) |
| 0x28E2      | `dispatch_overlay_op_52(arg)`      | 0x52   | TBD         |
| 0x28F2      | `dispatch_overlay_op_55(arg)`      | 0x55   | TBD         |
| 0x2902      | `dispatch_overlay_op_58(arg)`      | 0x58   | TBD         |
| 0x2912      | `dispatch_overlay_op_5C(arg)`      | 0x5C   | TBD         |
| 0x2922      | `dispatch_overlay_op_5E(arg)`      | 0x5E   | TBD         |
| 0x2932      | `dispatch_overlay_op_60(arg)`      | 0x60   | TBD         |
| 0x2942      | `dispatch_overlay_op_62(arg)`      | 0x62   | TBD         |
| 0x2952      | `dispatch_overlay_op_64(arg)`      | 0x64   | TBD         |
| 0x2962      | `dispatch_overlay_op_66(arg)`      | 0x66   | TBD         |
| 0x2972      | `dispatch_overlay_op_68(arg)`      | 0x68   | TBD         |
| 0x2982      | `dispatch_overlay_op_6A(arg)`      | 0x6A   | TBD         |

Each thunk has the same shape:

```c
int dispatch_overlay_op_NN(uint16_t arg) {
    return overlay_call_0D1D_07A4(0xNN, arg);
}
```

### `void repeat_dispatch_op_50(uint16_t arg, int count)` @ 0x28C0

Calls `dispatch_overlay_op_50(arg)` `count` times in a loop:

```c
void repeat_dispatch_op_50(uint16_t arg, int count) {
    if (count <= 0) return;
    for (int i = 0; i < count; i++) {
        dispatch_overlay_op_50(arg);
    }
}
```

---

## Region: load_image — formatted-output buffer pipeline

A printf-family of wrapper functions all converge on `format_to_buffer_2D54`
(at 0x260E). Each wrapper formats a different argument type into a 20-byte
stack buffer (`uint8_t buf[0x14]`) and then writes it through `format_to_buffer_2D54`.
The output stream's metadata lives at `g_output_stream` (DGROUP:0x2D40),
with byte counter `g_output_count` (DGROUP:0x2D52).

### `void open_output_stream()` @ 0x2400

```c
void open_output_stream(uint16_t mode_flag, uint16_t buf_arg /*[bp+8]*/, uint16_t source /*[bp+6]*/) {
    overlay_call_181F_0048(
        /* AX prefilled = */ 9,           // open mode flag
        FAR_DS, 0x0042,                    // arg slot
        FAR_DS, source, buf_arg,           // source/buf
        FAR_DS, &g_output_stream_2D40);    // stream descriptor
    g_output_count_2D52 = 0;
}
```

### `int format_int_to_stream(int value)` @ 0x242C

Calls a long-formatting helper at `0xD1D:0x113C(SI=value, AX=...)`, transforms
the result via `0x181F:0x2C` and `0xD1D:0x117E`, then post-increments the
output count.

### `int find_char_in_buffer(uint16_t count, /* implicit far pointer in [0x2D42:0x2D44] */)` @ 0x2462

REPNE SCASB scan: searches the buffer at `[g_buf_ptr_2D42..2D44]` for a
NUL byte (or until count reaches 0). Returns the far pointer (DX=segment,
AX=offset) of the matching byte.

### `void map_int_to_screen_code(int code, uint16_t* out_a, uint16_t* out_b)` @ 0x2494

```c
void map_int_to_screen_code(int code, uint16_t* out_a, uint16_t* out_b) {
    switch (code) {
        case 0:  *out_a = 0x44; break;     // 'D'?
        case 1:  *out_a = 0x95; break;     // ?
        case 2:  *out_a = 0x0C; break;     // form-feed?
        default: *out_a = 0x22; break;     // '"'?
    }
    *out_b = 0x22;     // '"' always
}
```

(The constants 0x44/0x95/0x0C/0x22 are not obviously printable in the same
encoding — they may be MicroProse internal symbol-codes for screen elements.)

### `void format_long_via_dispatcher_8FA(int radix /*=10*/, int value)` @ 0x2648

Formats a long via `0xD1D:0x8FA(value, &local_buf, 0xA)` (radix 10) into a
20-byte stack buffer, then ships through `format_to_buffer_2D54`.

```c
void format_long_via_dispatcher_8FA(int value) {
    uint8_t buf[20];
    overlay_call_0D1D_08FA(value, buf, /*radix=*/10);
    format_to_buffer_2D54(buf);                 // ss:&buf
}
```

### `void format_long_via_dispatcher_916(int high, int low)` @ 0x2668

```c
void format_long_via_dispatcher_916(int high, int low) {
    uint8_t buf[20];
    overlay_call_0D1D_0916(low, high, buf, /*radix=*/10);
    format_to_buffer_2D54(buf);
}
```

### `void format_via_lib_call_4B_1E8(uint16_t arg1, uint16_t arg2)` @ 0x268C

```c
void format_via_lib_call_4B_1E8(uint16_t arg1, uint16_t arg2) {
    uint8_t buf[20];
    buf[0] = 0;                                  // pre-clear
    overlay_call_004B_01E8(arg1, arg2, buf);
    format_to_buffer_2D54(buf);
}
```

---

---

## Region: load_image — colony turn update / production chain

This is one of the most informative functions in the load_image region.
It IS the per-colony turn-end economy update. The smoking gun is the
sequence of 7 calls at the end that map exactly to the standard
Colonization production chains:

| Pair        | Raw → Finished                          | Slot in ctx |
|-------------|-----------------------------------------|--------------|
| Sugar→Rum   | commodity 1 → commodity 9               | slot 1       |
| Tobacco→Cigars | commodity 2 → commodity 10           | slot 2       |
| Cotton→Cloth   | commodity 3 → commodity 11           | slot 3       |
| Furs→Coats     | commodity 4 → commodity 12           | slot 4       |
| Ore→Tools      | commodity 6 → commodity 14           | slot 6       |
| Food (special) | commodity 0                          | slot 0       |
| Lumber (special)| commodity 5                         | slot 5       |
| Tools (final) | commodity 14                          | slot 14      |

So `func_008E84` is `update_finished_good_from_raw(raw_id, finished_id)`
and the calls happen in a deliberate order (Tools last, after Ore).

This means **`*(0x8542)` is definitely the current-colony struct**, with
`ctx->array_word_9a` being the per-commodity stockpile (20 word slots,
indexed 0..14 for the 15 standard commodities, slots 15..19 reserved).

### `void colony_turn_update()` @ 0xA3E1  (705 bytes)

```c
void colony_turn_update(void) {
    // ---- Phase 1: scan colony's 5x5 surround for production tallies ----
    // The 0x14-loop iterates 0..19 (call this 'slot_idx', the colony's
    //   resource-tile index 0..19). The inner 5-loop iterates building
    //   types 0..4. For each (slot, building_type), call func_009B9C to
    //   get a yield-or-flag pair, then look up the unit at that pair via
    //   lookup_byte_from_pair (0x8956). If the unit's array_at_20 == 8
    //   (a special unit type — possibly 'expert'), accumulate into the
    //   byte at g_yield_a895. Otherwise add to one of the 20-word
    //   accumulator at DGROUP:0x8DC8 (g_global_amount).

    for (int slot_idx = 0; slot_idx < 20; slot_idx++) {
        for (int building_type = 0; building_type < 5; building_type++) {
            int yield_data;
            int yield_value = func_009B9C(building_type, slot_idx, &yield_data, 1);
            if (yield_data >= 0) {
                int unit_match = find_pair_in_table_C8_DE_via_8956(building_type, slot_idx);
                if (ctx->array_at_20[unit_match] == 8) {
                    g_yield_a895 += yield_value;     // expert / specialist accumulator
                }
                g_global_amount[yield_data] += yield_value;
            }
        }
    }

    // First-pass already accumulated baseline. Now: pull from the unused-slot
    // tables at g_table_A891/A893/A894 — these are reset state for the
    // next colony (or for an inactive slot).
    g_global_amount[/*food*/ 0] += (uint8_t)g_table_A891[0];
    if ((int8_t)g_table_A893 >= 0) {
        int idx = g_table_A893;
        g_global_amount[idx] += (uint8_t)g_table_A894;
    }

    // ---- Phase 2: for each occupied colony slot, run individual handlers ----
    // (this loops i = 0..ctx->count-1)
    for (int i = 0; i < ctx->count; i++) {
        int meta;
        int unit_yield = unit_individual_handler_9FFC(i, &meta);
        if (meta >= 0) {
            g_global_amount[meta] += unit_yield;
        }
    }

    // ---- Phase 3: housekeeping / morale / penalties ----
    g_8DEA++;     // increment some counter
    if (test_bit_via_863E(0x25)) g_8DEA++;   // bonus
    if (test_bit_via_863E(0x26)) g_8DEA++;
    g_table_A892 = 0;
    g_8DEC++;     // separate counter

    // Founding-father / building bonuses on g_8DEC
    if (overlay_call_0981_0000(ctx->type_or_owner, 0x0F)) {
        g_8DEC += g_8DEC / 2;        // +50% bonus
    }
    if (overlay_call_0981_0000(ctx->type_or_owner, 0x11)) {
        // Apply a per-power bonus from PowerRecord (stride 0x13C).
        int power_byte = power[ctx->type_or_owner].byte_at_minus_77F7_offset;
        g_8DEC += (power_byte * g_8DEC) / 100;
    }
    if (overlay_call_0981_0000(ctx->type_or_owner, 0x12)) {
        // Tory-related bonus (?): conditional on g_table_543F
        bool active_for_owner = (ctx->type_or_owner < 4 &&
                                 g_table_543F[ctx->type_or_owner * 0x34] == 0);
        if (!active_for_owner) {
            g_8DEC += (ctx->count + 3) / 5;
        }
    }
    g_8DEC += (uint8_t)g_table_A892;
    if (test_bit_via_863E(0x14))   g_8DEC *= 2;
    else if (test_bit_via_863E(0x13))
                                   g_8DEC += g_8DEC / 2;

    // ---- Phase 4: tax / rebellion handling ----
    int rebellion_quota = 0;
    if (ctx->word_at_aa >= 2) {       // ctx->something_at_AA
        int divisor = test_bit_via_863E(0x11) ? 0x19 : 0x32;
        rebellion_quota = ((ctx->word_at_aa + divisor - 1) / divisor) * 2;
    }
    int turn_step = step_100_or_level_scaled();
    int liberty_pressure = max(0, turn_step - ctx->word_at_aa);
    rebellion_quota = min(rebellion_quota, liberty_pressure);

    g_8DD8 += /*work points*/ ctx->count * 2;
    g_8E6A = (ctx->count * 2) - rebellion_quota;

    // ---- Phase 5: production chain dispatch ----
    dispatch_via_8e02_with_band(0,    /*midpoint=*/ rebellion_term);    // Food
    dispatch_via_8e02_with_band(5,    g_8DE8);                          // Lumber
    update_finished_good_from_raw(6, 14);   // Ore → Tools
    update_finished_good_from_raw(2, 10);   // Tobacco → Cigars
    update_finished_good_from_raw(3, 11);   // Cotton → Cloth
    update_finished_good_from_raw(4, 12);   // Furs → Coats
    update_finished_good_from_raw(1, 9);    // Sugar → Rum
    dispatch_via_8e02_with_band(0xE,  g_8DE6);                          // Tools (final)
}
```

This means we now know:

1. The struct at `*(0x8542)` is **the current colony**.
2. `ctx->array_word_9a[i]` is the colony's per-commodity stockpile.
3. `ctx->count` is the population (number of working colonists).
4. `ctx->array_at_20[i]` is each colonist's job/profession-or-expertise (0..0x12).
5. `ctx->array_at_40[i]` is each colonist's unit type (0..0x17).
6. `ctx->packed_60[i]` is a 0..15 attribute (likely "tool count / equipment").
7. `ctx->array_at_70[match_idx]` is per-grid-square colony tile state.
8. `ctx->bits_at_84` and `ctx->bits_at_8a` are colony flag bits (e.g. building presence).
9. `ctx->word_at_aa` is the rebellion sentiment / liberty bell counter.
10. `ctx->word_at_b6` is some other progress field (used in func_009318).
11. `ctx->word_at_c6` is a long stat (possibly cumulative production).
12. `ctx->level_at_95` is the colony's "tier" or technology level.
13. `ctx->type_or_owner (+0x1A)` is the OWNING POWER (0..3 for human + 3 European AIs;
   4..7 for Indian tribes / pirates) — values 0..3 are the European powers.

`g_global_amount[20]` (DGROUP:0x8DC8) holds per-commodity *daily-input* before
the price/band adjustment. `g_band_base[20]` (DGROUP:0x8E0A) holds the target
production that the band tracker compares against.

---

---

## Region: load_image — yield calculator and helpers

### `int compute_terrain_yield(int building_type, int slot_idx, int* terrain_out, int flag1)` @ 0x9B9C  (1120 bytes)

The colony's per-(slot, building) yield calculator. Given a slot 0..19 in
the colony's surrounding 5x5, returns the commodity production count for
that slot in the given building's profession. Reads the **terrain-yield
table at DGROUP:0x2F7B** (which has stride 16 bytes per terrain type,
indexed by terrain_id × 16 + commodity_id; total ~64 × 16 = 1024 bytes).

Outline:

```c
int compute_terrain_yield(int building_type, int slot_idx, int* terrain_out, int flag1) {
    int profession = func_009974(building_type, slot_idx, terrain_out);
                                                    // resolves 'which job is this slot for'
    if (profession < 0) return 0;

    // Translate slot to absolute map coordinates
    int draw_x = ctx->map_x + slot_idx_x_part - 2;
    int draw_y = ctx->map_y + slot_idx_y_part - 2;

    int terrain_id   = overlay_call_037F_010E(draw_x, draw_y);   // terrain at cell
    int terrain_base = overlay_call_03E4_000E(terrain_id);       // base yield index
    int features     = overlay_call_037F_04B0(draw_x, draw_y);   // forest/river/road flags

    int base_yield = g_terrain_yield_table[terrain_base * 16 + profession];
                                                          // DGROUP:0x2F7B + terrain_base*16 + profession
    if (base_yield == 0) goto bonus_phase;                 // tile produces nothing for this job

    // Apply terrain modifiers (heuristic switch on a factor returned by 0x99EE)
    if (profession >= 8) {
        int factor = func_099EE(0x1A, 0x19, draw_x, draw_y);
        if      (factor >= 8) base_yield -= 2;
        else if (factor >= 6) base_yield -= 1;
        else if (factor <  6) base_yield += 1;
        else if (factor <  4) base_yield += 2;
        else if (factor <  3) base_yield += 3;
        // ... and many more sub-branches for hills, mountains, river bonuses
    }

    // Apply unit-specialist bonuses (specialist gets 2x in their tile),
    // founding-father bonuses, and Tools/Horse bonuses for production buildings
    // ... (omitted detail; ~600 bytes of cascading conditionals)

bonus_phase:
    // Add features (forest yields lumber, river adds food/fish, etc.)
    // ...

    return base_yield;
}
```

### `void compute_colony_center_yields()` @ 0xA222 (447 bytes)

The "colony center tile" pre-pass that runs before `colony_turn_update`.
Sets the three globals at DGROUP:0xA891 / 0xA893 / 0xA894 (referenced
in `colony_turn_update`'s phase 1 tail):

- `g_table_A891` = the colony center's **food yield** (0..6+, depending
  on terrain class plus era/feature/flag bonuses)
- `g_table_A893` = the **best non-food commodity index** the center
  produces (signed; 0xFF = no good non-food)
- `g_table_A894` = the **yield amount** for that best non-food

```c
void compute_colony_center_yields(void) {
    g_table_A895 = 0;       // reset specialist tally
    g_table_A896 = 0;

    int terrain_at_center = overlay_call_03E4_003A(ctx->map_x, ctx->map_y);
                                  // base terrain id at colony tile

    // ---- Phase 1: classify terrain into food-yield class 0..3 ----
    if (terrain_at_center == 0x18) {
        g_table_A891 = 0;        // sealane / dead — no food
        goto era_bonus;
    }
    if (terrain_at_center == 1 || terrain_at_center == 0x11 || terrain_at_center == 9) {
        g_table_A891 = 1;        // desert / dry — minimal food
        goto era_bonus;
    }
    if (terrain_at_center == 0x1B || terrain_at_center == 0x1C ||
        (terrain_at_center >= 8 && terrain_at_center < 0x10)) {
        g_table_A891 = 2;        // forested / mixed — moderate
        goto era_bonus;
    }
    if (terrain_at_center >= 0x10 && terrain_at_center < 0x18) {
        g_table_A891 = 2;        // hill / mountain — moderate
    } else {
        g_table_A891 = 3;        // plains / grassland / prairie — high food
    }

era_bonus:
    // ---- Phase 2: era-based food bonus ----
    if (g_progress_5_53A6 != 0) g_table_A891 += 2;
    if (g_progress_5_53A6 == 1) g_table_A891 += 1;

    // ---- Phase 3: river / road bonus ----
    int features1 = overlay_call_037F_0142(ctx->map_x, ctx->map_y);
    if (features1 & 0x40) g_table_A891 += 1;          // river bonus

    int center_features = overlay_call_037F_04B0(ctx->map_x, ctx->map_y);
    int center_terrain  = overlay_call_037F_010E(ctx->map_x, ctx->map_y);
    int feature_tier = 0;
    if (center_terrain & 0x40) {
        feature_tier = 1;
        if (center_terrain & 0x80) feature_tier = 2;     // double-feature tile
    }

    // ---- Phase 4: feature bonus for special terrain types ----
    if (center_features == 1 || center_features == 9 || center_features == 2) {
        g_table_A891 += 2;
    }

    // ---- Phase 5: colony-flag bonuses (water / road) ----
    if (ctx->flags_at_1c & 4) g_table_A891 += 1;
    if (ctx->flags_at_1c & 2) g_table_A891 += 1;

    // ---- Phase 6: scan commodities 1..7 (skipping 5=Lumber) for best non-food yield ----
    g_table_A893 = 0xFF;          // best-commodity = none
    g_table_A894 = 0;             // best-yield = 0

    for (int commodity_idx = 1; commodity_idx < 8; commodity_idx++) {
        if (commodity_idx == 5) continue;     // Lumber excluded
        int base = g_terrain_yield_table[terrain_at_center * 16 + commodity_idx];
                                              // DGROUP:0x2F7B + terrain*16 + commodity
        int modifier = func_009AAA(center_features, commodity_idx);
        int yield;
        if (modifier >= 0) {
            yield = base;
        } else {
            yield = base * 2;     // negative modifier → double yield (specialist?)
        }
        yield += modifier;

        if (yield > g_table_A894) {
            g_table_A893 = commodity_idx;
            g_table_A894 = yield;
        }
    }

    // ---- Phase 7: post-process best-commodity yield ----
    if ((int8_t)g_table_A893 >= 0) {
        if (g_progress_5_53A6 == 0) g_table_A894 += 1;       // pre-era bonus
        g_table_A894 += feature_tier;                         // double-feature bonus
        if (ctx->flags_at_1c & 4) g_table_A894 += 1;
        if (ctx->flags_at_1c & 2) g_table_A894 += 1;
    }

    // ---- Phase 8: write to per-commodity totals (loop 0..0x13) ----
    for (int i = 0; i < 20; i++) {
        // (additional cleanup loop in the actual asm — clears stale state)
        // ... continues into func_00A3E1 (colony_turn_update)
    }
}
```

This function is the **prelude to `colony_turn_update`**. It computes the
colony center tile's contribution (which is added unconditionally to the
food/best-non-food totals before per-colonist yields are tallied). The
two functions form a pair: `compute_colony_center_yields` (0xA222) →
`colony_turn_update` (0xA3E1, fall-through, no break in execution).

### `int colony_assign_or_change_colonist_job(int slot, int new_action)` @ 0x9318 (782 bytes)

The colony's main "change colonist job" / "add colonist" / "remove colonist" /
"unit-from-outside enters colony" dispatcher. Branches via `classify_pair_bounds`
into 4 cases and recursively calls itself when growing the population.

Inputs:
- `slot` = colonist index (or `population + overflow` to refer to "next free slot")
- `new_action` = job code or unit transition (0..0x12 = job; 0x13 = boundary;
  0x14 = "with-tools" specialist; 0x17 = special which gets remapped to 0x15)

```c
int colony_assign_or_change_colonist_job(int slot, int new_action) {
    if (new_action == 0x17) new_action = 0x15;   // 23 → 21 unit-type / job remap

    int prev_job = current_unit_field_at_20(slot);    // 0x90C8 → existing job
    uint8_t produced[5*2];                             // [bp-0x28] — yield slots
    int yield_count = compute_job_outputs(prev_job, &produced[0]);  // 0x903E

    // ---- Phase 1: REVERSE the old job's contribution to the stockpile ----
    // For each (slot, raw_id) that prev_job was producing, subtract from stockpile.
    // Special-case Tools (production_id == 0xE) which costs 50 from a separate slot.
    for (int i = 0; i < yield_count; i++) {
        int production_id = produced[i*2];
        int yield;
        if (production_id == 0xE) {
            // Tools branch: re-fetch via UnitRecord field (units carrying tools)
            int unit_idx = helper_8BD4(population - slot);
            yield = unit[unit_idx].field_at_3159 - 50;   // base 50 then +/- by 0x32
        } else if (production_id > 0xE) {
            yield = base_yield - 8;
        } else if (production_id == 0) {
            yield = 0;
        } else {
            yield = base_yield;
        }
        ctx->stockpile_9a[production_id * 2] += yield;   // back into stockpile
    }

    // ---- Phase 2: zero a 0x10-byte scratch region on stack ----
    overlay_call_0D1D_0DAE(&local_buf[bp-0x16], 0, 0x10);    // memset

    // ---- Phase 3: compute liberty / population ratio ----
    int popularity = ctx->progress_b6 / 20;       // bp-6 = popularity tier
    int popular_pct = popularity * 20;
    if (popular_pct > 100) popular_pct = 100;
    uint8_t feature_byte = (uint8_t)popular_pct;  // bp-8 = feature byte
    uint8_t base_qty     = 0x32;                   // bp-7, bp-0xE = 50

    // ---- Phase 4: clear expertise nibble if job is changing ----
    if (new_action != prev_job) {
        pack_nibble_at_60(slot, 0);    // 0x8F6C
    }

    // ---- Phase 5: dispatch on (slot in-bounds?, action in-bounds?) ----
    int dispatch_code = classify_pair_bounds(slot, new_action);    // 0x929A
    int returned_slot = -1;

    switch (dispatch_code) {
        case 0:  // primary in-bounds, secondary in-bounds (NORMAL JOB CHANGE)
            ctx->job_at_20[slot] = (uint8_t)new_action;       // assign new job
            returned_slot = slot;
            yield_count = compute_job_outputs(new_action, &produced[0]);   // 0x903E
            // (fall through to Phase 6: re-add new job's production to stockpile)
            break;

        case 1:  // primary out-of-bounds, secondary out-of-bounds (UNIT LEAVES COLONY)
            {
                int unit_idx = helper_8BD4(population - slot);
                int translated = unit_translate_action_8BC6(new_action);
                unit[unit_idx].field_at_3146 = translated;       // unit type
                unit[unit_idx].field_at_314C = 0;                // clear flag
                if (new_action == 0x14) {
                    unit[unit_idx].field_at_3159 = feature_byte;  // tools/specialist
                }
                overlay_call_0427_155E(unit_idx);                 // detach unit from colony
                returned_slot = slot;
            }
            break;

        case 2:  // primary in-bounds, secondary out-of-bounds (UNIT ENTERS COLONY)
            {
                int translated = unit_translate_action_8BC6(new_action);
                int unit_idx = overlay_call_0427_06B4(translated, ctx->owner_power,
                                                      ctx->map_x, ctx->map_y);
                if (unit_idx < 0) {
                    returned_slot = slot;        // failed — fall back
                } else {
                    overlay_call_0427_155E(unit_idx);                 // attach unit
                    int existing = current_unit_field_at_40(slot);
                    unit[unit_idx].field_at_315B = (uint8_t)existing;
                    if (new_action == 0x14) {
                        unit[unit_idx].field_at_3159 = feature_byte;
                    }
                    func_8FB4(slot);
                    returned_slot = ctx->population;
                }
            }
            break;

        case 3:  // primary out-of-bounds, secondary in-bounds (POPULATION GROWTH)
            if (ctx->population >= 0x20) {
                // Cap reached: just return last available slot
                returned_slot = ctx->population - 1;
                break;
            }
            {
                int new_unit_idx = helper_8BD4(population - slot);
                ctx->cumulative_c6 += 100;       // long-add 100 to cumulative
                ctx->cumulative_c8 += 0;         // (carry)
                int new_slot = ctx->population;
                ctx->population++;               // grow!

                // Recursive call: assign the just-created slot's job
                colony_assign_or_change_colonist_job(new_slot, new_action);

                // Configure the new unit's binding to the new colonist
                int initial_field = unit[new_unit_idx].field_at_315B;
                set_field_at_40_or_unit_byte(new_slot, initial_field);   // 0x913C
                overlay_call_0427_0824(new_unit_idx);                     // place colonist on map

                returned_slot = new_slot;

                // Tutorial / first-3-colonists trigger
                if (ctx->population >= 3 || g_tutorial_flag_35C != 0) goto re_scan;
                if (overlay_call_0981_0000(ctx->owner_power, 9)) {
                    set_or_clear_bit_at_84(0, 1);   // light up colony bit 0
                }
            }
            break;
    }

re_scan:
    init_and_scan_units_in_area();    // 0x8C70 — refresh unit counters

    // ---- Phase 6: APPLY the new job's production by SUBTRACTING from stockpile ----
    // (for cases 0/3 only; the loop is shared via jump targets in the asm)
    for (int i = 0; i < yield_count; i++) {
        int production_id = produced[i*2];
        uint8_t feature_yield = scratch[i];   // pre-computed yield modifier from Phase 2
        if (production_id == 0) {
            // food / sentinel zero — set the "abandoned" flag
            ctx->population_abandoned_marker = 0;
        }
        int amount = ctx->stockpile_9a[production_id * 2] - feature_yield;
        if (amount < 0) amount = 0;
        ctx->stockpile_9a[production_id * 2] = amount;
    }

    // ---- Phase 7: if colony just emptied, fire global signal ----
    if (ctx->population == 0) {
        g_colony_abandoned_348 = 1;     // signal to outer turn loop
    }

    return returned_slot;
}
```

This is the pivotal function for the colony economy. It handles:
- **Changing a colonist's job** (case 0): the stockpile delta from the old job is reversed and the new job's delta applied.
- **Population growth** (case 3): a new colonist appears, recursively assigned to a job, and the cumulative-population stat at +0xC6 increments by 100.
- **Unit-becomes-colonist** (case 2): pulls a unit from the world map into the colony, binding it as a worker.
- **Colonist-becomes-unit** (case 1): converts a colony slot back to a free unit on the world.

The 0x17 → 0x15 remap and the 0x14 special case (tools/horses on a unit) are how non-job actions hitch a ride on this dispatcher.

### `void auto_assign_unassigned_colonists()` @ 0xB150 (155 bytes)

Post-load / post-population-change pass that ensures every colonist is
either assigned to a working tile (recorded in `ctx->tile_state_70`) or
moved to a default "idle" slot. Called after savegame load and probably
after population growth.

```c
void auto_assign_unassigned_colonists(void) {
    uint8_t slot_used[0x20];

    // Phase 1: zero the local slot-used array for `population` entries
    for (int i = 0; i < ctx->population; i++) {
        slot_used[i] = 0;
    }

    // Phase 2: mark slots referenced by tile_state_70 (the 5x5 grid bindings)
    for (int tile_idx = 0; tile_idx < 0x14; tile_idx++) {
        int8_t bound = (int8_t)ctx->tile_state_70[tile_idx];
        if (bound >= 0) slot_used[bound] = 1;
    }

    // Phase 3: for any unassigned colonist, try to place them on a tile;
    //         if placement fails, demote to "idle" (action code 0xD).
    for (int i = 0; i < ctx->population; i++) {
        if (slot_used[i] != 0) continue;     // already on a tile

        int job = current_unit_field_at_20(i);
        if (job >= 9) continue;              // non-working unit type; skip

        int placed = func_AB78(i, -1);       // try to find a working tile
        if (placed != 0) {
            slot_used[i] = 1;                // success — record as bound
        } else {
            // Couldn't place: park them at the colony center as "idle"
            colony_assign_or_change_colonist_job(i, 0xD);
        }
    }
}
```

### `int unit_load_commodity_into_slots(int unit_idx, int commodity_idx, int qty)` @ 0xB368 (126 bytes)

Adds `qty` of `commodity_idx` to `unit[unit_idx]`'s cargo slots. Each
unit's max cargo capacity is `unit.cargo_slot_count` (byte at +0x3150).
Each slot holds one commodity type with up to 100 units.

```c
int unit_load_commodity_into_slots(int unit_idx, int commodity_idx, int qty) {
    for (int slot = 0; slot < unit[unit_idx].cargo_slot_count; slot++) {
        if (qty == 0) break;
        int slot_kind = unit_cargo_slot_kind(slot, unit_idx);    // 0xB2A2 — what's in this slot?
        if (slot_kind != commodity_idx) continue;                // not our commodity

        int existing_qty = unit_cargo_slot_quantity(slot, unit_idx);   // 0xB2F0
        int room_left = 100 - existing_qty;
        if (room_left == 0) continue;
        int adding = (room_left < qty) ? room_left : qty;
        unit_cargo_slot_set_quantity(unit_idx, slot, existing_qty + adding);  // 0xB304
        qty -= adding;
    }

    // (If qty > 0 still: try to allocate a new empty slot — continues past 0xB3D9)
    if (qty > 0 && unit[unit_idx].cargo_slot_count < ?max?) {
        // Allocate a new slot, set its commodity = commodity_idx, quantity = qty
        // ... (omitted detail)
    }
    return /* leftover qty */;
}
```

Helpers in the same module:
- `unit_cargo_slot_kind(slot, unit_idx)` @ 0xB2A2 — packed-nibble reader for cargo TYPE; bound-checks via 0xB2A2 then falls into 0xB2C2 (the unpacker)
- `unit_cargo_slot_quantity(slot, unit_idx)` @ 0xB2F0 — quantity-byte reader (named `unit_table_3154_byte`; reads byte at +0x3154)
- `unit_cargo_slot_set_quantity(unit_idx, slot, qty)` @ 0xB304 — quantity writer (writes byte at +0x3154 + slot)
- `unit_cargo_kind` @ 0xB42C — get the commodity kind from a unit (bulk)

**UnitRecord cargo layout (now decoded):**
```c
struct UnitRecord {
    uint8_t  type;                  // +0x00 — unit type id (DGROUP:0x3146 + idx*0x1C is base)
    uint8_t  field_at_3147[?];      // +0x01..0x09
    uint8_t  cargo_slot_count;      // +0x0A — count, byte at DGROUP:0x3150 + idx*0x1C
    uint8_t  cargo_kind_packed[3];  // +0x0B..0x0D — 6-slot packed nibbles, DGROUP:0x3151 + idx*0x1C
    uint8_t  cargo_qty[6];          // +0x0E..0x13 — per-slot byte quantities, DGROUP:0x3154 + idx*0x1C
    uint8_t  field_3159;            // +0x14 — specialist tools (TBD)
    uint8_t  field_315B;            // +0x16 — colony binding (set during colony unit-bind)
    // ... continues to stride 0x1C
};
```

### `void colony_transfer_commodity_to_unit(int unit_idx, int commodity_idx, int max_qty)` @ 0xB880 (80 bytes)

Removes up to `max_qty` units of `commodity_idx` from colony stockpile and
loads them onto unit `unit_idx`. The amount actually transferred is clamped
to (max 100) AND (caller's max) AND (available in stockpile), then:

```c
void colony_transfer_commodity_to_unit(int unit_idx, int commodity_idx, int max_qty) {
    int avail = ctx->stockpile_9a[commodity_idx];
    if (avail > 100) avail = 100;          // clamp to 1 cargo unit max
    if (avail > max_qty) avail = max_qty;  // honor caller's request

    g_transfer_qty_8DC4 = avail;            // expose quantity to follow-up calls
    ctx->stockpile_9a[commodity_idx] -= avail;

    unit_load_commodity(unit_idx, commodity_idx, avail);    // 0xB368

    // Reset cargo-pickup flag (unit just loaded — clear "in transit" state
    // unless it's frozen at 2)
    if (unit[unit_idx].field_at_314C != 2) {
        unit[unit_idx].field_at_314C = 0;
    }
}
```

### `void colony_receive_commodity_from_unit(int unit_idx, int qty)` @ 0xB8D0 (47 bytes)

The reverse of 0xB880: queries unit cargo via `0xB42C`, and if the unit was
carrying a known commodity, ADDS the previously-set `g_transfer_qty_8DC4`
quantity back to the colony's stockpile.

```c
void colony_receive_commodity_from_unit(int unit_idx, int qty) {
    int commodity = unit_cargo_kind(unit_idx, qty);    // 0xB42C
    if (commodity >= 0) {
        ctx->stockpile_9a[commodity] += g_transfer_qty_8DC4;
    }
}
```

### `int helper_8BD4(int overflow_idx)` @ 0x8BD4 (referenced by 0x913C, 0x9318)

Converts an "overflow index" (population - count) into the appropriate
external UnitRecord index for colonists who don't fit in the colony's
job slots. Used when a unit count exceeds the colony's working population.

```c
int helper_8BD4(int overflow_idx);   // TBD — not yet decoded
```

---

## Other TODOs (known but not yet ported)

### `void init_and_scan_units_in_area()` @ 0x8C70  (full size 0x90 = 144 bytes; auto-boundary truncated at 0x66)

Scans all unit indices in the area around `ctx->origin_*`, accumulating three
counters into the `g_iter_aux_*` globals at DGROUP:0x8D72/74/76. The
iterator is a far-callable chain rooted at overlay function `0x427:0x5C`
(seed) with `0x427:0x4A` returning the next index (or -1 to terminate).

```c
void init_and_scan_units_in_area(void) {
    g_iter_aux_a = 0;        // a = count passing predicate 0x8B96 (clamped to 50 at end)
    g_iter_aux_b = 0;        // b = total iter count
    g_iter_aux_c = 0;        // c = count whose unit-type has non-zero byte in g_table_5237

    g_iter_handle = overlay_call_0427_005C(ctx->origin_x, ctx->origin_y);

    int iter = g_iter_handle;
    while (iter >= 0) {
        if (predicate_8B96(iter)) g_iter_aux_a++;
        int unit_type = unit[iter].field_at_3146_offset;     // byte at DGROUP:0x3146 + iter*0x1C
        if (g_table_5237[unit_type * 14] != 0) g_iter_aux_c++;
        g_iter_aux_b++;
        iter = overlay_call_0427_004A(iter);
    }

    if (g_iter_aux_a > 50) g_iter_aux_a = 50;                // hard clamp (50 = max?)

    if (g_iter_aux_c != 0 &&
        g_iter_aux_d /* 0x8D7A */ >= g_iter_aux_c) {
        g_iter_aux_d = 0;                                     // reset secondary counter
    }
}
```

### `int find_indexed_match_then_compute(int target_idx)` @ 0x8C1E (size 81)

Two-phase function. First initializes `g_iter_handle` (via overlay-callable
chain at 0x427:0x4A). Then iterates the chain, looking for the iter index
whose `current_unit_field_at_20` matches the caller's target. When found,
computes `result = ctx->count + match_position`.

```c
int find_indexed_match_then_compute(int target_idx) {
    int result = -1;
    int counter = -1;
    int iter = g_iter_handle;       // start from cached handle

    while (iter >= 0) {
        if (result < 0) {            // still searching
            if (predicate_8B96(iter)) {
                counter++;
                if (iter == target_idx) {
                    result = ctx->count + counter;
                }
            }
        }
        iter = overlay_call_0427_004A(iter);
    }
    return result;
}
```

- `func_0091CC` (181 bytes) — composite of unit/colony lookups; uses both
  `current_unit_field_at_20` and `current_unit_field_at_40`, has 0x1C-stride
  UnitRecord access, special-cases value 0x17 (Arctic-related).

- `func_008524` — reader of `ctx->field_at_c2` (word at +0xC2). Boundary
  imperfectly detected — needs re-disasm.

- `helper_8BD4` — overflow-index-to-UnitRecord-index converter referenced by
  `set_field_at_40_or_unit_byte`. Sees a counter struct lookup pattern.
