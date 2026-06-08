/* ============================================================================
 * colony.h — the colony_t struct + accessor declarations
 * ----------------------------------------------------------------------------
 * This is the central game-state struct. The DGROUP global at 0x8542 holds
 * a far-pointer to the "current colony" — the colony being viewed, modified,
 * or simulated. 102 functions in VICEROY.EXE dereference this pointer.
 *
 * @ref decompiled.md "Struct: colony_t (the *(0x8542) struct — CONFIRMED COLONY)"
 * @ref PROGRESS.md   "Headline finding (2026-05-02)"
 * @evidence  The colony_turn_update function at file 0xA3E1 dispatches the
 *            standard Colonization production chains (Sugar→Rum, Tobacco→
 *            Cigars, Cotton→Cloth, Furs→Coats, Ore→Tools) using the +0x9A
 *            word array. Confirms colony identity.
 * ============================================================================ */
#ifndef VICEROY_COLONY_H
#define VICEROY_COLONY_H

#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * Colony record — TWO related sizes
 * ----------------------------------------------------------------------------
 * - **174 bytes (0xAE)** — the WORKING BUFFER at *(0x8542). This is the
 *   "current colony" struct used by the live simulation. load_game_state
 *   at 0x011F6E allocates a 174-byte buffer matching this stride.
 * - **202 bytes (0xCA)** — the PERSISTENT RECORD stride in the colony
 *   table at DGROUP:0x5D46. Each colony in the saved table occupies 202
 *   bytes; the additional 28 bytes (vs the 174-byte working buffer) hold
 *   computed/derived state that's reconstituted on load.
 *   (BASE CORRECTED 2026-06-08: base is 0x5D46, NOT 0x5D60. Proven at
 *    func_0082DC @0x008307 `imul bx,idx,0xCA; add bx,0x5D46; mov [0x8542],bx`.
 *    0x5D60 is base+0x1A = the owner_power field, not the table base — the same
 *    base-vs-field trap that put UnitRecord at 0x3146 instead of 0x3144.)
 *
 * The two structs share their common 174-byte prefix. The full 202-byte
 * version adds: continent_id, region_id, last_visited_turn, lookup-cache
 * pointers, and a few flags.
 *
 * @ref load_game_state @ 0x011F6E (allocates 0xAE-byte working buffer)
 * @ref decompiled.md "load_game_state — 0xAE-byte working buffer"
 * @ref ../../../COLONIZATION_TECHNICAL_REFERENCE.md  §2 ColonyRecord (202)
 * @asm DGROUP:0x5D46 = colony_table base (proven func_0082DC @0x008307:
 *      `imul bx,idx,0xCA; add bx,0x5D46`); stride 0xCA = 202 bytes per colony.
 *      (0x5D60 = base+0x1A = owner_power, formerly mis-cited as the base.)
 * Field offsets are confirmed by direct disassembly references; widths
 * with `?` are pending exact verification. */
struct colony_t {
    uint8_t  map_x;            /* +0x00  1-based X origin (interior offset = x-2)
                                * @ref blit_at_origin_if_pair_visible @ 0x008918
                                *      reads (struct.byte[+0]-2) as 'origin X' */
    uint8_t  map_y;            /* +0x01  1-based Y origin
                                * @ref same as map_x */
    uint8_t  pad_02[0x18];     /* +0x02..0x19  not yet decoded — likely contains name string */
    uint8_t  owner_power;      /* +0x1A  owning power (0..3 European; 4..7 NPCs)
                                * @ref colony_turn_update @ 0xA3E1 — selects entry
                                *      in g_table_543F (stride 0x34) */
    uint8_t  flags_at_1c;      /* +0x1C  bit-flags (bit 1, 2, 4 affect production)
                                * @ref compute_colony_center_yields @ 0xA222 — bits 2/4 give bonuses */
    uint8_t  pad_1d_1e[2];     /* +0x1D..0x1E  not yet decoded */
    uint8_t  population;       /* +0x1F  number of working colonists; bounds the
                                *        per-colonist arrays at +0x20/+0x40/+0x60.
                                * @ref current_unit_field_at_20 @ 0x90C8 (bound check)
                                * @ref current_unit_field_at_40 @ 0x9102 */
    uint8_t  job_at_20[8];     /* +0x20..+0x27  per-colonist job/profession (0..0x12)
                                * @ref current_unit_field_at_20 @ 0x90C8
                                * @evidence colony_turn_update reads job[i]==8 as
                                *           'expert' specialist marker */
    uint8_t  pad_28_3F[0x18];  /* +0x28..+0x3F  not yet decoded (probably tail of job array;
                                *               max population is ~32 per +0x1F < 0x20 cap) */
    uint8_t  unit_type_at_40[8]; /* +0x40..+0x47  per-colonist unit type (0..0x17);
                                  *               value 0x17 is remapped to 0x15 by setter
                                  * @ref set_field_at_40_or_unit_byte @ 0x913C */
    uint8_t  pad_48_5F[0x18];  /* +0x48..+0x5F  not yet decoded */
    uint8_t  expertise_60[3];  /* +0x60..+0x62  packed-nibble: per-colonist expertise
                                * (0..15, bucketized to 0..3 by 0x9184 helper)
                                * @ref unpack_nibble_at_60 @ 0x8F2A
                                * @ref pack_nibble_at_60   @ 0x8F6C */
    uint8_t  pad_63_6F[0xD];   /* +0x63..+0x6F  not yet decoded */
    uint8_t  tile_state_70[20];/* +0x70..+0x83  per-grid-square tile state (the 20
                                *        surrounding tiles, indexed via find_pair match);
                                *        0xFF = empty, else per-tile flags
                                * @ref lookup_byte_from_pair @ 0x8956
                                * @ref auto_assign_unassigned_colonists @ 0xB150 */
    uint8_t  bits_at_84[6];    /* +0x84..+0x89  bit-array #1 (48 bits) — building presence
                                * @ref set_or_clear_bit_at_84 @ 0x92E0 */
    uint8_t  bits_at_8a[8];    /* +0x8A..+0x91  bit-array #2 — feature flags
                                * @ref test_bit_at_8a         @ 0x85B2
                                * @ref set_or_clear_bit_at_8a @ 0x85D6 */
    uint8_t  pad_92_94[3];     /* +0x92..+0x94  not yet decoded */
    uint8_t  field_at_95;      /* +0x95  *** OPEN CONFLICT — canonical meaning not yet decoded ***
                                * Two byte-verified reads of THIS SAME offset disagree:
                                *  (a) FOOD stock — the colony-screen food widget draws
                                *      [bx+0x95] as a pile count (overlay_024342 @0x26F8D
                                *      `mov al,[bx+0x95]`; +0x96 = HORSE count @0x26FA0).
                                *      This DISPLAY evidence is the stronger candidate.
                                *  (b) era/level — step_100_or_level_scaled @0x8D00 does
                                *      `if [bx+0x95]: step=([bx+0x95]+1)*100` (the basis of
                                *      the old "era counter" label; just USES the value).
                                * Both confirmed to read +0x95. Leaning FOOD (the widget
                                * displays it), but not flipped definitively — needs one
                                * more trace (what consumes 0x8D00's step). Left unresolved, not
                                * guessed. (+0x94 "build selector", +0x96 "horse" from the
                                * same overlay are likewise candidate-but-unconfirmed.) */
    uint8_t  pad_96_99[4];     /* +0x96..+0x99  not yet decoded */
    uint16_t stockpile_9a[20]; /* +0x9A..+0xC1  per-commodity stockpile (15 commodities + 5 slack);
                                * indexed by commodity_id 0..14:
                                *   [0]=Food   [1]=Sugar [2]=Tobacco [3]=Cotton
                                *   [4]=Furs   [5]=Lumber [6]=Ore    [7]=Silver
                                *   [8]=Horses [9]=Rum   [10]=Cigars [11]=Cloth
                                *   [12]=Coats [13]=TradeGoods       [14]=Tools
                                * @ref colony_turn_update @ 0xA3E1
                                * @ref colony_transfer_commodity_to_unit @ 0xB880
                                * @ref colony_receive_commodity_from_unit @ 0xB8D0
                                * @ref check_total_exceeds_threshold @ 0x8F02 */
    uint16_t liberty_aa;       /* +0xAA  liberty-bell / rebellion-sentiment counter
                                * @ref colony_turn_update — used in tax/rebellion phase */
    uint8_t  pad_ac_b5[10];    /* +0xAC..+0xB5  not yet decoded */
    uint16_t progress_b6;      /* +0xB6  tutorial / progress counter (turns into popularity tier
                                *         via /20 in colony_assign_or_change_colonist_job)
                                * @ref colony_assign_or_change_colonist_job @ 0x9318 */
    uint8_t  pad_b8_c1[10];    /* +0xB8..+0xC1  not yet decoded */
    uint16_t field_at_c2;      /* +0xC2  LOW word of the 32-bit SoL "bells" numerator A.
                                *         sol_membership_pct (0x8524) reads [+0xC2]/[+0xC4]
                                *         as a long and divides by the [+0xC6] long.
                                * @ref sol_membership_pct @ 0x8524 (BYTE_VERIFIED 2026-05-30):
                                *      @asm 0x8531 MOV ax,[bx+0xC2]; 0x8535 MOV dx,[bx+0xC4] */
    uint16_t field_at_c4;      /* +0xC4  HIGH word of the SoL bells numerator A.
                                * @asm 0x8535 (was an unnamed 2-byte hole; named 2026-05-30) */
    uint16_t cumulative_c6;    /* +0xC6  LOW word of the 32-bit SoL threshold/divisor B
                                *        (increments by 100 on population growth — the
                                *        per-colonist bells-to-100% denominator).
                                * @ref colony_assign_or_change_colonist_job @ 0x9318 line 0x9453
                                * @ref sol_membership_pct @ 0x8524 @asm 0x8542 MOV …,[bx+0xC6] */
    uint16_t cumulative_c8;    /* +0xC8  HIGH word of threshold B (was "high word of cumulative_c6").
                                * @asm 0x8539 MOV dx,[bx+0xC8] / 0x853E CMP [bx+0xC8],0 */
    uint8_t  pad_ca_tail[0xE2]; /* +0xCA..  remainder toward the persistent
                                *           ColonyRecord stride; contains Custom House
                                *           toggles, building states, siege flags,
                                *           founding-father binds, etc.  not yet decoded — to be
                                *           decoded from individual readers.
                                * (was pad_ca_ad[0xE4]; shrunk 2 to offset the newly
                                *  named field_at_c4 above so the documented total is
                                *  byte-neutral vs the pre-2026-05-30 layout.) */
};

/* sanity check: expected total stride is 0xAE bytes */
#if (sizeof(struct colony_t) != 0xAE)
#  error "colony_t stride mismatch — expected 0xAE per load_game_state allocator"
#endif

/* The current-colony pointer (DGROUP:0x8542; 102 functions touch it) */
extern struct colony_t  far *ctx;
#define COLONY_CTX_FAR_PTR_OFFSET  0x8542  /* DGROUP relative */

/* ----------------------------------------------------------------------------
 * Per-colonist accessors (all bound-checked against ctx->population)
 * ---------------------------------------------------------------------------- */

/* @asm 0x0090C8..0x0090E4  (29 bytes)  ENTER 2 / LEAVE / RETF
 * @ref decompiled.md "current_unit_field_at_20"
 * Returns ctx->job_at_20[i] or ctx->population on out-of-bounds. */
int   current_unit_field_at_20(int i);

/* @asm 0x009102..0x00911E  (29 bytes)  sister of 0x90C8 reading +0x40 array
 * @ref decompiled.md "current_unit_field_at_40" */
int   current_unit_field_at_40(int i);

/* @asm 0x00913C..0x009183  (72 bytes; auto-detector split — full at 0x913C..0x9183)
 * @ref decompiled.md "set_field_at_40_or_unit_byte"
 * Dual-mode setter: in-bounds → ctx; out-of-bounds → UnitRecord overflow.
 * Value 0x17 is remapped to 0x15 before storing. */
void  set_field_at_40_or_unit_byte(int i, int value);

/* @asm 0x008F2A..0x008F5F  (53 bytes)  bound-checked against ctx->population
 * @ref decompiled.md "unpack_nibble_at_60"
 * Returns the 0..15 packed nibble at expertise_60[i/2] (low nibble even, high odd) */
int   unpack_nibble_at_60(int i);

/* @asm 0x008F6C..0x008FB3  (72 bytes)
 * @ref decompiled.md "pack_nibble_at_60" */
void  pack_nibble_at_60(int i, int value);

/* @asm 0x009184..0x0091CB  (72 bytes; split into 4 branches)
 * @ref decompiled.md "nibble_to_4_tier_quantity"
 * Bucketizes nibble: 15→3, ≥8→2, ≥4→1, else 0. */
int   nibble_to_4_tier_quantity(int i);

/* ----------------------------------------------------------------------------
 * Bit-array accessors (the +0x84 and +0x8A bit arrays)
 * ---------------------------------------------------------------------------- */

/* @asm 0x0085B2..0x0085D5  (34 bytes)
 * @ref decompiled.md "test_bit_at_8a" */
int   test_bit_at_8a(int bit_idx);

/* @asm 0x0085D6..0x00860D  (56 bytes; auto-detector split — set/clear branches)
 * @ref decompiled.md "set_or_clear_bit_at_8a" */
void  set_or_clear_bit_at_8a(int bit_idx, int set_flag);

/* @asm 0x0092E0..0x009317  (40 bytes; auto-detector split)
 * @ref decompiled.md "set_or_clear_bit_at_84" */
void  set_or_clear_bit_at_84(int bit_idx, int set_flag);

/* ----------------------------------------------------------------------------
 * Tile-state / 20-cell pair-table accessors
 * ---------------------------------------------------------------------------- */

/* @asm 0x008892..0x0088CF  (62 bytes)  ENTER 4 / LEAVE / RETF
 * @ref decompiled.md "find_pair_in_table_C8_DE"
 * Linear scan of parallel byte tables at DGROUP:0xC8 / 0xDE for 20 entries.
 * Subtracts 2 from each key before scanning. Returns 0..0x13 or -1. */
int   find_pair_in_table_C8_DE(int key1, int key2);

/* @asm 0x008956..0x008981  (44 bytes)
 * @ref decompiled.md "lookup_byte_from_pair" */
int   lookup_byte_from_pair(int key1, int key2);

/* @asm 0x00929A..0x0092DF  (70 bytes; split into 4 branches)
 * @ref decompiled.md "classify_pair_bounds" — 4-case dispatch code 0..3 */
int   classify_pair_bounds(int primary, int secondary);

/* ----------------------------------------------------------------------------
 * Major colony operations (full pseudo-C in decompiled.md)
 * ---------------------------------------------------------------------------- */

/* @asm 0x00A222..0x00A6A1  (ONE function, 1152 bytes; single `ENTER 0x2a,0`
 *      prologue at 0xA222, `POP SI/LEAVE/RETF` at 0xA6A1).
 * @ref src/colony/turn_update.c (CORRECTION banner, BYTE_VERIFIED 2026-05-30)
 *
 * The whole per-colony turn-end economy update.  Phases: center-tile food
 * class + best-non-food scan (0xA227), zero the 20-word accumulator (0xA3D5),
 * apply center yields (0xA3EE), 5x5 ring scan (0xA40D), per-colonist handler
 * pass (0xA47F), bell/building/FF multipliers (0xA4B0), liberty/rebellion
 * quota (0xA5B0), and the 5 canonical production chains (Sugar→Rum,
 * Tobacco→Cigars, Cotton→Cloth, Furs→Coats, Ore→Tools) + direct Food/Lumber/
 * Tools band dispatch (0xA642).
 *
 * NOTE: `compute_colony_center_yields` (the 0xA222 name) was previously
 * modelled as a SEPARATE function that fell through into 0xA3E1.  The byte
 * trace proves that was a disassembler SEGMENTATION ARTIFACT (the spurious
 * "ENTER 0x8d,0" at 0xA3E1 is the mid-instruction tail of the accumulator-
 * zeroing store `C7 87 C8 8D 00 00` at 0xA3DF).  There is no real reference
 * to 0xA3E1; the only entry is 0xA222.  The decl below is therefore an ALIAS
 * that calls colony_turn_update() (kept for callgraph/symbol stability). */
void  colony_turn_update(void);
void  compute_colony_center_yields(void);   /* alias → colony_turn_update (see above) */

/* @asm 0x009318..0x009626  (782 bytes)
 * @ref decompiled.md "colony_assign_or_change_colonist_job"
 * 4-way dispatcher (job-change / population-grow / unit-enter / unit-leave). */
int   colony_assign_or_change_colonist_job(int slot, int new_action);

/* @asm 0x00B150..0x00B1EB  (155 bytes)
 * @ref decompiled.md "auto_assign_unassigned_colonists" */
void  auto_assign_unassigned_colonists(void);

/* @asm 0x008918..0x008955  (62 bytes)
 * @ref decompiled.md "blit_at_origin_if_pair_visible" */
void  blit_at_origin_if_pair_visible(int key1, int key2, int arg3);

/* @asm 0x008982..0x008B95  (532 bytes)
 * @ref decompiled.md "update_and_render_tile_at" */
void  update_and_render_tile_at(int key1, int key2, int new_state);

/* @asm 0x008D00..0x008D25  (38 bytes)
 * @ref decompiled.md "step_100_or_level_scaled" */
int   step_100_or_level_scaled(void);

/* @asm 0x009626..0x00965A  (53 bytes)
 * @ref decompiled.md "count_field_at_20_matching" */
int   count_field_at_20_matching(uint8_t target);

/* @asm 0x00965C..0x009690  (53 bytes)
 * @ref decompiled.md "count_field_at_40_matching" */
int   count_field_at_40_matching(uint8_t target);

/* @asm 0x009692..0x0096D9  (72 bytes)
 * @ref decompiled.md "count_field_40_matches_field_20" */
int   count_field_40_matches_field_20(void);

/* @asm 0x0096DA..0x009725  (75 bytes)
 * @ref decompiled.md "find_nth_match_in_field_at_20" */
int   find_nth_match_in_field_at_20(uint8_t target, int n);

/* @asm 0x008C70..0x008CFF  (144 bytes; auto-detector truncated)
 * @ref decompiled.md "init_and_scan_units_in_area" */
void  init_and_scan_units_in_area(void);

/* @asm 0x009726..0x009759  (52 bytes)
 * @ref decompiled.md "register_origin_to_overlay_9EF" */
void  register_origin_to_overlay_9EF(void);

/* ----------------------------------------------------------------------------
 * Commodity-band tracker (per-commodity Europe-market state)
 * ---------------------------------------------------------------------------- */

/* @asm 0x008E02..0x008E45  (68 bytes)
 * @ref decompiled.md "set_commodity_band_at_index" */
void  set_commodity_band_at_index(int idx, uint16_t midpoint,
                                   uint16_t primary, uint16_t delta);

/* @asm 0x008E46..0x008E82  (61 bytes)
 * @ref decompiled.md "dispatch_via_8e02_with_band" */
void  dispatch_via_8e02_with_band(int idx, uint16_t midpoint);

/* @asm 0x008F02..0x008F22  (33 bytes)
 * @ref decompiled.md "check_total_exceeds_threshold" */
int   check_total_exceeds_threshold(int idx);

/* ----------------------------------------------------------------------------
 * Production-support cluster — building-bit / chain / SoL% / raw->finished
 * (all BYTE_VERIFIED 2026-05-30; bodies in src/colony/production_support.c)
 * ---------------------------------------------------------------------------- */

/* @asm 0x00860E..0x00861D  test bit `bit_idx` of ColonyRecord[colony_idx]'s
 * building/feature bit-array (DGROUP:0x5DCA + colony_idx*0xCA). */
int   test_colony_building_bit(int bit_idx, int colony_idx);

/* @asm 0x00863E..0x00864D  same, for the CURRENT colony (index g_8DC6). */
int   test_building_or_father_bit(int bit_idx);

/* @asm 0x00864E..0x008684  walk the stride-12 prereq chain (DGROUP:0x8F86)
 * from start_idx; count links whose bit is set in the current colony. */
int   count_building_chain_present(int start_idx);

/* @asm 0x008686..0x0086BF  as above but for an arbitrary colony. */
int   count_building_chain_present_colony(int colony_idx, int start_idx);

/* @asm 0x0086C0..0x0086E2  walk the chain to its terminal link, return it. */
int   building_chain_walk_to_top(int start_idx);

/* @asm 0x0086E4..0x00871F  highest chain link whose bit is set (else -1). */
int   highest_building_chain_bit_set(int start_idx);

/* @asm 0x008524..0x0085B1  Sons-of-Liberty membership % = (bells_C2 * 100) /
 * threshold_C6, +20 (Jan de Witt FF op 0x12), clamped to 100. */
int   sol_membership_pct(void);

/* @asm 0x008D9C..0x008DBA  signed byte DGROUP:0x2F4[index] (-1 if index>=0x13);
 * the chain-start building id for a finished good. */
int   lookup_signed_2F4(int index);

/* @asm 0x008DBC..0x008E00  g_global_amount[idx]-g_band_base[idx]-over_high[rel],
 * rel=g_byte_2A2[idx]; optionally outputs the over_high term. */
int   commodity_net_minus_chain(int idx, uint16_t far *out_ptr);

/* @asm 0x008E84..0x008F01  one raw->finished production step (×2/3 when the
 * finished good's building chain has >2 links present); 5 calls from 0xA3E1. */
void  update_finished_good_from_raw(int raw_id, int finished_id);

/* Compatibility aliases (names used by turn_update.c / data/production.c). */
int   rebel_sentiment_pct(void);     /* == sol_membership_pct */
int   building_present_count(int bit_idx);   /* == count_building_chain_present */
int   highest_building_le(int bit_idx);      /* == highest_building_chain_bit_set */

#endif /* VICEROY_COLONY_H */
