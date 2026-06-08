/* ============================================================================
 *                  >>> BYTE_VERIFIED (partial) <<<
 * ----------------------------------------------------------------------------
 * Combat demotion-ladder dispatch — byte-verified table within the combat
 * resolver function `func_05B2C2`.
 *
 * @asm_function   func_05B2C2 (combat resolver — actual size ~2926 bytes,
 *                              boundary detector reported only 35 bytes
 *                              before the early-exit at unit_id >= 300)
 * @asm_offset     file 0x05B2C2..~0x05BE30
 * @region         overlay
 *
 * The CORE combat-outcome dispatch happens at file 0x5B5AA..0x5B61F.
 * When a unit is defeated in combat, the function looks up the unit's
 * type in a hard-coded mapping table to determine what type the unit
 * "demotes" to (Veteran Soldier → Free Colonist, Dragoon → Soldier, etc.).
 *
 * @bytes  C7 46 DE FF FF / 6B 5E 06 1C / 80 BF 46 31 ... at file 0x5B5AA
 * @verified_by    Hand-traced 2026-05-02
 * ============================================================================ */
#include "viceroy_types.h"

extern uint8_t g_unit_table_3146[];   /* UnitRecord[N] base, stride 0x1C — BYTE_VERIFIED */

/* ============================================================================
 * Demotion table (BYTE_VERIFIED, deriving names from Colonization unit-type
 * conventions — type names tentative pending unit-class table verification)
 *
 *  Source unit type → Outcome (target demoted unit type) per the byte-traced
 *  if-ladder in func_05B2C2:
 *
 *    UnitType 1  → outcome 0    (file 0x5B5C3)
 *    UnitType 4  → outcome 1    (file 0x5B5B3)
 *    UnitType 7  → outcome 9    (file 0x5B5DF)
 *    UnitType 8  → outcome 6    (file 0x5B5EF)
 *    UnitType 9  → outcome 0    (file 0x5B5CF)
 *    (any other) → outcome -1   (no demotion / unit killed outright)
 *
 * Special-case override at file 0x5B60B..0x5B616:
 *   if outcome was 0 AND UnitRecord[idx].byte_at_+0x15 == 24:
 *       outcome = 3
 *
 * NAMES.TXT @UNIT mapping (BYTE_VERIFIED 2026-06-08 from data/unit_classes.c):
 *    0  Colonists (Free Colonist)
 *    1  Soldiers                   → demotes to 0 (Colonists)
 *    2  Pioneers
 *    3  Missionaries
 *    4  Dragoons                   → demotes to 1 (Soldiers)
 *    5  Scouts
 *    6  Regulars
 *    7  Cont. Cav.                 → demotes to 9 (Cont. Army)
 *    8  Cavalry                    → demotes to 6 (Regulars)
 *    9  Cont. Army                 → demotes to 0 (Colonists)
 * Special override: outcome==0 AND vet_type==0x18 → outcome=3 (Missionaries).
 *   (Profession 0x18 is likely Missionary, causing reversion to Missionaries unit type.)
 * ============================================================================ */

int8_t combat_demote_unit(int unit_idx, int promote_flag /* [BP+0xA] */)
{
    /* @asm 0x5B5A1..0x5B5A9 — guard: if local_28 != 0, jump elsewhere */
    /* (some pre-condition before applying demotion) */

    int8_t outcome = -1;                  /* @asm 0x5B5AA  default = -1 */
    uint8_t unit_type = g_unit_table_3146[unit_idx * 0x1C];   /* byte 0 of record */

    /* @asm 0x5B5AF..0x5B5FE  — switch on unit_type */
    if (unit_type == 4) outcome = 1;
    if (unit_type == 1) outcome = 0;
    if (unit_type == 9) outcome = 0;
    if (unit_type == 7) outcome = 9;
    if (unit_type == 8) outcome = 6;

    /* @asm 0x5B600..0x5B606 — if outcome stays -1, jump elsewhere
     *   (the unit dies entirely instead of demoting) */
    if (outcome < 0) {
        /* JMP 0x5B693 — handle "unit killed" path */
        return -1;
    }

    /* @asm 0x5B60E `80 bf 5b 31 18` = cmp byte [bx+0x315B],0x18 — vet_type override:
     *   if outcome == 0 AND vet_type == 24 (0x18), outcome = 3.
     *   NOTE: 0x315B is canonical UnitRecord+0x17 (vet_type). The index below uses
     *   the 0x3146-based alias, so +0x15 here == +0x17 from the canonical 0x3144
     *   base — address is correct; label clarified 2026-05-30 (verified byte). */
    if (outcome == 0 && g_unit_table_3146[unit_idx * 0x1C + 0x15] == 24) {
        outcome = 3;
    }

    /* @asm 0x5B61B..0x5B61F — if promote_flag == 0, take alternate path */
    if (promote_flag == 0) {
        /* JMP 0x5B685 — apply demotion + display message */
    }

    /* @asm 0x5B620..0x5B679 — display formatting + DEMOTE message */
    /* The DEMOTE message is shown at file 0x5B679 with PUSH 0x1B4D. */

    return outcome;
}

/* ============================================================================
 * SUMMARY (BYTE_VERIFIED)
 *
 * Demotion ladder is hard-coded in the combat resolver at file 0x5B5AA-0x5B616.
 * Five unit types have explicit demote targets; all others die outright.
 * The +0x15 byte of UnitRecord is checked to override outcome 0 → 3 in one
 * specific case (likely "Indentured Servant rebellion variant").
 *
 * What's STILL not byte-verified:
 *   - The unit_type → name mapping (need unit_classes table location)
 *   - The PROMOTION ladder (winners — likely a similar dispatch elsewhere)
 *   - The combat damage ROLL formula (which RNG, which modifiers)
 *   - The terrain/fortify/SoL/FF combat-strength modifiers
 *
 * The combat damage roll is probably in a DIFFERENT function that calls
 * `combat_demote_unit` after determining who won. Find via a search for
 * RNG calls + the calls into func_05B2C2.
 * ============================================================================ */
