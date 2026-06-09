/* ============================================================================
 * colony/commodity.c — Europe-market commodity-band tracker (3 functions)
 *                       + colony↔unit commodity transfers
 * ----------------------------------------------------------------------------
 * The triple of parallel WORD arrays at DGROUP:0x8E0A / 0x8E32 / 0x8E5A
 * holds (base, over_low, over_high) for each of 20 commodity slots
 * (only indices 0..14 are used in the standard production loop).
 *
 * The Tools-vs-Ore special case (commodity 14 reading from g_over_high[6])
 * was the original clue that this struct was Colonization-specific.
 * ============================================================================ */
#include "viceroy.h"

extern int  unit_load_commodity_into_slots(int unit_idx, int commodity_idx, int qty);
extern int  unit_cargo_kind(int unit_idx, int qty);

/* ============================================================================
 * set_commodity_band_at_index — 68 bytes
 * @asm 0x008E02..0x008E45
 *
 * Updates the (base, over_low, over_high) triple for `idx`:
 *   base[idx]      = primary
 *   over_low[idx]  = max(0, primary - midpoint)
 *   over_high[idx] = max(0, (primary - delta) - midpoint)
 * ============================================================================ */
void set_commodity_band_at_index(int idx, uint16_t midpoint,
                                  uint16_t primary, uint16_t delta)
{
    g_band_base[idx] = primary;
    g_over_low[idx]  = (primary > midpoint) ? (primary - midpoint) : 0;

    int below = (int)primary - (int)delta - (int)midpoint;
    g_over_high[idx] = (below > 0) ? (uint16_t)below : 0;
}

/* ============================================================================
 * dispatch_via_8e02_with_band — 61 bytes
 * @asm 0x008E46..0x008E82
 *
 * Wrapper that:
 *   1. Reads the global per-commodity baseline at g_global_amount[idx]
 *   2. Applies the Tools→Ore-overflow adjustment (if idx==14)
 *   3. Calls set_commodity_band_at_index with computed (midpoint, primary, delta)
 * ============================================================================ */
void dispatch_via_8e02_with_band(int idx, uint16_t midpoint)
{
    uint16_t primary = g_global_amount[idx];

    /* @asm 0x8E54..0x8E64  Special-case: Tools (idx 14) reduced by Ore overflow */
    if (idx == COMMODITY_TOOLS && g_over_high_ore != 0) {
        primary -= g_over_high_ore;
    }

    uint16_t delta = ctx->stockpile_9a[idx];   /* per-commodity stockpile */
    set_commodity_band_at_index(idx, midpoint, primary, delta);
}

/* ============================================================================
 * check_total_exceeds_threshold — 33 bytes
 * @asm 0x008F02..0x008F22
 *
 * Returns 1 if (stockpile[idx] + global_amount[idx]) > band_base[idx];
 * otherwise falls through into the next function (func_008F2A — unpack
 * nibble).  This is the "predicate-then-fallthrough" pattern documented
 * with is_arg2_negative.
 * ============================================================================ */
int check_total_exceeds_threshold(int idx)
{
    uint16_t total = ctx->stockpile_9a[idx] + g_global_amount[idx];
    if (total > g_band_base[idx]) return 1;
    /* fall-through behavior in original: drops into the next function.
     * In our reconstructed C source we return 0; callers check both. */
    return 0;
}

/* ============================================================================
 * colony_transfer_commodity_to_unit — 80 bytes
 * @asm 0x00B880..0x00B8CF
 * ============================================================================ */
extern int  unit_cargo_action_qty5_get(int unit_idx);    /* +0x15 reader (cargo_qty[5]) */
extern void unit_cargo_action_qty5_set(int unit_idx, int v);

void colony_transfer_commodity_to_unit(int unit_idx, int commodity_idx, int max_qty)
{
    int avail = ctx->stockpile_9a[commodity_idx];
    if (avail > 100)     avail = 100;          /* @asm 0xB892: CMP AX,0x64; clamp */
    if (avail > max_qty) avail = max_qty;

    g_8DC4 = (uint16_t)avail;                  /* DGROUP:0x8DC4 staging */
    ctx->stockpile_9a[commodity_idx] -= avail;

    unit_load_commodity_into_slots(unit_idx, commodity_idx, avail);

    /* @asm 0xB8BE..0xB8CA  reset cargo-pickup flag unless frozen at 2 */
    if (unit(unit_idx).cargo_qty[5] != 2) {
        unit(unit_idx).cargo_qty[5] = 0;
    }
}

/* ============================================================================
 * colony_receive_commodity_from_unit — 47 bytes
 * @asm 0x00B8D0..0x00B8FE
 * ============================================================================ */
void colony_receive_commodity_from_unit(int unit_idx, int qty)
{
    int commodity = unit_cargo_kind(unit_idx, qty);
    if (commodity >= 0) {
        ctx->stockpile_9a[commodity] += g_8DC4;
    }
}

/* The k_production_chains[] table is defined in src/data/production.c
 * (initialized DGROUP data).  See viceroy.h for the declaration. */
