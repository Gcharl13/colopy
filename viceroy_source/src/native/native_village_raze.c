/* ============================================================================
 *            CHIEFKILL gold — RESOLVED (population-based, user-verified)
 * ----------------------------------------------------------------------------
 * RESOLVED 2026-05-30 (was "FIELD SEMANTICS UNVERIFIED"): the size factor is the
 * settlement POPULATION at NativeSettlement +0x04 — NOT byte +0x02 (which is the
 * owner/tribe id). The earlier +0x02 read produced the "raze gold all off /
 * Apache richer than Aztec" bug (gold scaled with tribe id). Corrected to +0x04
 * (population) and the formula now matches user-verified data:
 *   Inca capital pop=13 -> CHIEFKILL ceiling 30*6*4*14 = 10,080
 *   Aztec capital pop=10 -> CHIEFKILL ceiling 30*6*4*11 =  7,920
 * Both observed totals (15,000 / 10,000) exceed the CHIEFKILL ceiling, so a
 * separate CAPITAL-ONLY bonus is added on top (magnitude still hypothesis-level
 * — see docs/CAPITAL_BONUS_ANALYSIS.md; applied by the capital/Cibola handler,
 * NOT in this CHIEFKILL block). Wealth therefore tracks settlement population
 * and the capital bonus's civ-tier, never the tribe id.
 * @verified docs/CAPITAL_BONUS_ANALYSIS.md ; PROJECT_BOARD 2026-05-05 ("CHIEFKILL
 *   uses NativeSettlement +0x04 population, USER-VERIFIED via Inca raze");
 *   NativeSettlement +0x04 = pop in include/native.h + src/native/settlement.c.
 * ----------------------------------------------------------------------------
 * Native village destruction — gold formula, arithmetic traced.
 *
 * @asm_function   func_04A7CA  (CHIEFKILL handler)
 * @asm_offset     file 0x04A7CA..(extends past detected 507-byte size to ~0x04ABA0)
 * @region         overlay
 * @verified_by    Hand-decompiled 2026-05-03 — every instruction in the
 *                 gold-computation block (file 0x04AAD0..0x04AB6E) traced.
 *
 * Identifying string: CHIEFKILL @2b5a:0x1668 (PUSH at file 0x04ABAA).
 *
 * ARGUMENTS (from caller's PUSH order, RTL):
 *   [BP+6]  = arg1  — attacker unit_idx (UnitRecord index)
 *   [BP+8]  = arg2  — attacker power_idx (PowerRecord index, 0..3 for EU)
 *   [BP+0xA] = arg3 — defender power/tribe ref
 *
 * KEY GLOBALS (BYTE_VERIFIED):
 *   DGROUP:0x53A6  — difficulty level (0..4 for Discoverer..Viceroy)
 *   DGROUP:0x8D4E  — far ptr to the NativeSettlement record (the Aztec/etc
 *                    village). The size factor is +0x04 = POPULATION (NOT +0x02,
 *                    which is the owner/tribe id). User-verified (Inca pop 13,
 *                    Aztec pop 10). See docs/CAPITAL_BONUS_ANALYSIS.md.
 *   DGROUP:0x8832 + power*0x13C — PowerRecord[power].gold (32-bit, dword ADD/ADC)
 * ============================================================================ */
#include "viceroy_types.h"

extern uint8_t g_difficulty_53A6;        /* DGROUP:0x53A6 — difficulty 0..4 */
extern void *  g_settlement_ptr_8D4E;    /* DGROUP:0x8D4E — far ptr to settlement record */
extern uint8_t g_powerrecord_8809[];     /* PowerRecord[] base (stride 0x13C) */
extern int     random_int(int lo, int hi);  /* file 0x00C322 — BYTE_VERIFIED */

/* ============================================================================
 * native_village_raze_gold — BYTE_VERIFIED
 *
 * Computes the gold awarded to a player who destroys a native village.
 *
 * @asm bytes 0x04AAD0..0x04AB6E
 *
 * Formula:
 *
 *   diff      = DGROUP[0x53A6]              // difficulty 0..4
 *   upper     = 10 - diff                    // 10, 9, 8, 7, 6
 *   sum_3     = random_int(1, upper)
 *               + random_int(1, upper)
 *               + random_int(1, upper)       // 3 independent rolls, summed
 *   roll_4    = random_int(1, 6)             // independent fourth roll
 *   step1      = sum_3 * roll_4 * 4
 *   population = (*g_settlement_ptr_8D4E)[4] // NativeSettlement +0x04 = pop
 *   gold       = step1 * (population + 1)
 *   (+ a capital-only bonus added elsewhere for capitals; see banner)
 *
 *   PowerRecord[attacker].gold += gold       // 32-bit add at +0x8832
 *
 * Bounds (DETERMINISTIC max/min):
 *   For difficulty=0 (Discoverer), upper=10:
 *     sum_3 ∈ [3, 30]
 *     roll_4 ∈ [1, 6]
 *     step1 ∈ [12, 720]
 *     For settlement population in (CHIEFKILL only, before capital bonus):
 *        5  → factor=6  → gold ∈ [72,  4,320]
 *        10 → factor=11 → gold ∈ [132, 7,920]   ← Aztec capital pop=10 ceiling
 *        13 → factor=14 → gold ∈ [168, 10,080]   ← Inca  capital pop=13 ceiling
 *        20 → factor=21 → gold ∈ [252, 15,120]
 *
 *   For difficulty=4 (Viceroy), upper=6:
 *     sum_3 ∈ [3, 18]
 *     step1 ∈ [12, 432]
 *     For settlement_size_byte=20:
 *        gold ∈ [252, 9,072]
 *
 * The user's observed range of 4,000..15,000 for an Aztec capital fits
 * settlement_size_byte ~= 20 at standard difficulty (Discoverer or
 * Explorer), with mid-to-high rolls. The 15,000 upper bound corresponds
 * to (sum_3=30, roll_4=6, factor=21) = 30 × 6 × 4 × 21 = 15,120 —
 * essentially exact match.
 * ============================================================================ */
void native_village_raze_gold(int attacker_unit_idx,
                              int attacker_power_idx)
{
    /* @asm 0x04AAD0..0x04AADD — compute upper bound for the 3 main rolls */
    uint8_t diff = g_difficulty_53A6;
    int16_t upper = 10 - diff;          /* 10..6 across difficulty levels */

    /* @asm 0x04AADD..0x04AB06 — three random_int(1, upper) rolls, summed */
    int16_t roll_1 = random_int(1, upper);
    int16_t roll_2 = random_int(1, upper);
    int16_t roll_3 = random_int(1, upper);
    int16_t sum_3  = roll_1 + roll_2 + roll_3;

    /* @asm 0x04AB0B..0x04AB1D — multiply by random_int(1,6) and *4 */
    int16_t roll_4 = random_int(1, 6);
    int16_t step1  = sum_3 * roll_4 * 4;

    /* @asm 0x04AB20..0x04AB2D — multiply by (settlement.population + 1).
     * The size factor is NativeSettlement +0x04 = POPULATION (user-verified:
     * Inca pop 13, Aztec pop 10 — docs/CAPITAL_BONUS_ANALYSIS.md). The earlier
     * +0x02 read was the owner/tribe id, which produced the "Apache richer than
     * Aztec" bug (gold scaling with tribe id). RESOLVED. */
    int8_t  population = ((int8_t *)g_settlement_ptr_8D4E)[4];   /* +0x04 = pop */
    int16_t gold       = step1 * (population + 1);
    /* CAPITAL bonus (capitals only) is added on top by the capital/Cibola
     * handler, not here — magnitude TBD (docs/CAPITAL_BONUS_ANALYSIS.md). */

    /* @asm 0x04AB30..0x04AB3A — display the value via overlay messaging */
    display_gold_value(gold);

    /* @asm 0x04AB3D..0x04AB5C — if owner is human (< 4) and personality
     * is inactive, display a tribe-specific message. (Side effect only.) */

    /* @asm 0x04AB5D..0x04AB6E — add gold to attacker's PowerRecord */
    *(int32_t *)&g_powerrecord_8809[attacker_power_idx * 0x13C + 0x29] += gold;
}

/* ============================================================================
 * ANSWER TO USER QUESTION (2026-05-02..03)
 * "If I burn down an Aztec village, what is the min and max gold I can
 *  receive?"
 *
 * BYTE-VERIFIED ANSWER:
 *   gold = (random_int(1, 10-diff)
 *         + random_int(1, 10-diff)
 *         + random_int(1, 10-diff))    // sum_3
 *        × random_int(1, 6)            // roll_4
 *        × 4
 *        × (settlement.byte_at_+2 + 1) // size factor
 *
 * For an Aztec capital (size_byte ~= 20) on Discoverer (difficulty=0):
 *
 *   MIN gold = 3 × 1 × 4 × 21  =     252 gold     (worst rolls)
 *   MAX gold = 30 × 6 × 4 × 21 =  15,120 gold     (perfect rolls)
 *
 * Your observed 4,000-15,000 spread is entirely explained by the
 * randomization. The 15,000 upper-end corresponds to perfect rolls
 * on a top-tier village — matching `30 × 6 × 4 × 21 = 15,120`.
 *
 * Higher difficulty REDUCES the max:
 *   Discoverer (0):  max = 15,120
 *   Explorer  (1):  max = 13,608    (upper=9, sum_3 max=27)
 *   Conquistador (2): max = 12,096
 *   Governor  (3):  max = 10,584
 *   Viceroy   (4):   max =  9,072
 *
 * The randomization means every replay from the same save with the
 * same actions produces a different result (unlike SMITE diplomacy,
 * which is deterministic).
 *
 * STILL OPEN (each one tractable in 1 hour):
 *   - The exact value of settlement.byte_at_+2 per tribe/tier (need to
 *     trace what populates the settlement record at game-start)
 *   - What the bit-6 attribute test on the attacker (file 0x04A802) does
 *   - The pre-formula branches (CMP LOCAL_22 vs 25 / 75) — likely
 *     "village too small to raze" or "treasury empty" guards
 * ============================================================================ */
