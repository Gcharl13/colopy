/* ============================================================================
 *                       >>> BYTE_VERIFIED (mechanism & offsets) <<<
 * ----------------------------------------------------------------------------
 * boycott.c -- Per-commodity boycott tracking and the Boston Tea Party.
 *
 * The boycott state is a single WORD BITMASK at PowerRecord +0x20 (one bit per
 * trade good), NOT a per-good boolean array. Reconstructed from VICEROY.EXE.
 * Replaces the prior RECONSTRUCTED version (bool array + invented fine/tea-party
 * magnitudes). See docs/RULINGS.md 2026-05-28 (market).
 *
 * STATUS: [V] byte-verified ; [not yet decoded] not byte-verified (do not trust the number).
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"
#include "colony.h"
#include "ff.h"

/* DGROUP:0x84FC — active PowerRecord ptr (set by market_set_active in pricing.c).
 * Not declared in any header; mirror pricing.c's file-local extern so this TU and
 * pricing.c agree on the (struct PowerRecord*) type.  [V] DGROUP:0x84FC.
 * TODO: this `g_market` (DGROUP:0x84FC active PowerRecord ptr) probably belongs in
 *       include/globals.h alongside g_market_year. */

/* boycott bitmask: PowerRecord +0x20 (word).  @asm set 0x34717, clear-one
 * 0x33423, clear-all 0x3BD45, test 0x030B47.                              [V] */
#define PR_BOYCOTT_MASK(p)  (*(unsigned short *)((char *)(p) + 0x20))
#define PR_GOLD(p)          (*(long *)((char *)(p) + 0x2A))   /* @asm 0x3340D */
#define PR_SPENT(p)         (*(long *)((char *)(p) + 0x22))   /* @asm 0x033413 */

/* ============================================================================
 * boycott_is_active  --  @asm func_030B38 @ file 0x030B38 (20 bytes)    [V]
 *   return (1 << good) & PowerRecord[active].boycott_mask;
 * ============================================================================ */
int boycott_is_active(int good)
{
    return (1u << good) & PR_BOYCOTT_MASK(g_market);   /* @asm 0x030B3B-0x030B47 */
}

/* ============================================================================
 * boycott_set  --  @asm 0x034717 (within the TEAPARTY handler, 0x034439..0x03471E)
 *   boycott_mask |= (1 << good).                                          [V]
 * ============================================================================ */
void boycott_set(int good)
{
    PR_BOYCOTT_MASK(g_market) |= (1u << good);         /* @asm 0x034713-0x034717 */
}

/* ============================================================================
 * boycott_lift_paying_tax  --  @asm 0x03340D..0x033423                   [V]
 *   Pay `cost` gold (computed elsewhere) to lift the boycott on one good.
 * ============================================================================ */
void boycott_lift_paying_tax(int good, long cost)
{
    PR_GOLD(g_market)  -= cost;                         /* @asm 0x3340D/0x033410 */
    PR_SPENT(g_market) += cost;                         /* @asm 0x033413/0x033416 */
    PR_BOYCOTT_MASK(g_market) &= ~(1u << good);         /* @asm 0x03341F-0x033423 */
}

/* ============================================================================
 * boycott_clear_all  --  @asm 0x03BD45 (Founding Father id 1 = Jakob Fugger)  [V]
 *   boycott_mask = 0;  (whole word cleared in one store)
 * ============================================================================ */
void boycott_clear_all(void)
{
    PR_BOYCOTT_MASK(g_market) = 0;                      /* @asm 0x03BD45 */
}

/* ============================================================================
 * boycott_init  --  @asm 0x036622 (new-game player init)                 [V]
 * ============================================================================ */
void boycott_init(void)
{
    PR_BOYCOTT_MASK(g_market) = 0;                      /* @asm 0x036622 */
    /* (same init block also zeroes tax @+0x01 and recruit count @+0x1E, and sets
       recruit base @+0x02 = (difficulty>=4 ? 0x1A : 0x19) @asm 0x036637-0x036648) */
}

/* ============================================================================
 * Tea Party — refuse a tax demand and dump the cargo (@asm 0x034439..0x03471E).
 *
 * BYTE_VERIFIED (2026-06-08) — direct state changes inside 0x034678..0x03471D:
 *
 * 1. King-force (PowerRecord+0x01): NET ZERO from this handler.
 *    @asm 0x034348: add [bx+1], al   (temporary pre-dialog raise)
 *    @asm 0x03467F: sub [bx+1], al   (undo, after tea-party branch taken)
 *    The real king-anger increase (if any) is in a DIFFERENT handler.
 *
 * 2. Europe-stock dump (ColonyRecord stock table):
 *    @asm 0x034678..0x034692: cmp/clamp — ax = min(current_stock, 0x64)
 *    @asm 0x03469B: sub word ptr [bx+0x5de0], ax
 *      → Colony[selected].EuropeStock[good] -= min(current, 100)
 *    (EuropeStock stride 0xCA per colony, base DGROUP:0x5de0; each colony has
 *    0x65 word slots, so offset = colony_idx*0xCA + good*2)
 *
 * 3. Colony 32-bit accumulator at +0xC0 (DGROUP:0x5e08):
 *    @asm 0x0346A9: add word ptr [bx+0x5e08], ax   (lo word)
 *    @asm 0x0346AD: adc word ptr [bx+0x5e0a], dx   (hi word)
 *      → Colony[selected].at_0xC0 += dumped_amount  (32-bit)
 *    This field sits in the persistent-record-only tail (offset +0xC0 within the
 *    0xCA-byte record, beyond the 0xAE working buffer; see colony.h pad_ca_tail).
 *    No read of this field was found anywhere in the EXE image — it is consumed
 *    by the save/score subsystem from the persisted record (likely a "goods
 *    destroyed" tally for final scoring).  [V write-site; read-site overlay/save]
 *
 * 4. Boycott mask [BYTE_VERIFIED]:
 *    @asm 0x034717: or word ptr [bx+0x20], ax
 *      → PowerRecord[active].boycott_mask |= (1 << good)
 *
 * The prior reconstruction's SoL +25 / king_anger +10 / FF-progress +25
 * are NOT in this handler — those magnitudes were invented and are removed.
 * ============================================================================ */
void colony_tea_party(struct colony_t *c, int good)
{
    /* @asm 0x034678..0x03469B — clamp stock to 100, subtract from EuropeStock table.
     * `stock[good]` == colony_t.stockpile_9a[good] (per-commodity stockpile word
     * array @ +0x9A, indexed by commodity_id 0..14; see colony.h). */
    int dumped = (c->stockpile_9a[good] > 100) ? 100 : c->stockpile_9a[good];
    /* Colony[selected].EuropeStock[good] -= dumped (bx = colony*0xCA, table base 0x5de0) */

    /* @asm 0x0346A9/0x0346AD — Colony[selected].at_0xC0 += dumped (32-bit accumulator) */

    boycott_set(good);                                  /* @asm 0x034717 */
    emit_message("TEAPARTY");                           /* @asm 0x034700 (ptr 0x106A) */
}
