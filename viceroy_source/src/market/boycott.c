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
 * STATUS: [V] byte-verified ; [TBD] not byte-verified (do not trust the number).
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"
#include "ff.h"

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
 * BYTE_VERIFIED: the warehouse stock for the chosen good is knocked toward 0
 * (Europe-stock table clamp <=0x64 @0x3468C-0x3469B), the TEAPARTY message is
 * emitted (@0x034700, key ptr 0x106A), then boycott_set(good) (@0x034717).
 *
 * [TBD] the secondary effects in the prior reconstruction (SoL +25, king_anger
 * +10, +25 toward next FF) are NOT byte-verified — their magnitudes/locations
 * were invented. Left as TODO rather than fabricated numbers.
 * ============================================================================ */
void colony_tea_party(Colony *c, int good)
{
    c->stock[good] = 0;                                 /* warehouse dumped (@asm 0x3468C region) */
    boycott_set(good);                                  /* @asm 0x034717 */
    emit_message("TEAPARTY");                           /* @asm 0x034700 (ptr 0x106A) */
    /* TODO [TBD]: SoL / king-anger / FF-progress side effects — locate & verify
       (the previous 25/10/25 constants were RECONSTRUCTED guesses, removed). */
}
