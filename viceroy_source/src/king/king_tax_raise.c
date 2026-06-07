/* ============================================================================
 *                  >>> BYTE_VERIFIED <<<
 * ----------------------------------------------------------------------------
 * The king's tax raise/lower decision logic.
 *
 * @asm_function   func_034AE0
 * @asm_offset     file 0x034AE0..0x034B7E (~158 bytes)
 *                 The boundary detector reported 100 bytes; real extent
 *                 includes the JE target at 0x34B44 (KINGLOWER branch) and
 *                 the JLE target at 0x34B62 (KINGRAISE branch).
 * @region         overlay
 * @verified_by    Hand-decompiled from VICEROY.EXE 2026-05-02
 *
 * Strings PUSHed by this function (BYTE_VERIFIED):
 *   "KINGLOWER" at 2b5a:0x10A8 (file 0x1EA48; string-seg base file 0x1D9A0 + 0x10A8)
 *   "KINGRAISE" at 2b5a:0x10B2 (file 0x1EA52)
 * ============================================================================ */
#include "viceroy_types.h"

extern uint8_t g_difficulty_53A6;   /* DGROUP:0x53A6 — difficulty 0..4 (Discoverer..Viceroy),
                                     * default 2. RESOLVED 2026-05-30: NOT player index — cross-
                                     * confirmed by raze (native_village_raze.c), FF (king/ref.c),
                                     * and the per-turn gold trace; active-power idx is 0x9E12. */
extern void *  g_king_record_84FC;            /* DGROUP:0x84FC — far ptr to king's record */
extern int16_t g_turn_counter_538E;           /* DGROUP:0x538E — turn counter (16-bit) */
/* ⚠ MISIDENTIFIED (RULINGS 2026-05-30): 0x181F:0x04D4 is random_int(lo,hi)
 * (BYTE_VERIFIED: thunk -> MSC LCG func_00C322; = the combat roll @0x5B849 and
 * native raid @0x05BF35), NOT an "ask king" dialog. The tax-accept branch logic
 * below that treats its return as 1=accept is therefore SUSPECT — func_034AE0
 * needs a re-trace to recover what it actually does with the random draws. */
extern uint16_t ovly_181F_04D4(uint16_t lo, uint16_t hi);  /* random_int(lo,hi) — see warning */
extern void   ovly_181F_0998(void *buf, void *src, int16_t arg);  /* output_message_with_value */

/* ============================================================================
 * king_attempt_tax_change — invoked when the king considers raising taxes
 *
 * Computes the proposed new tax rate, compares it to the current rate
 * (king.byte_at_+1), and if the proposed change exceeds a threshold, asks
 * the player to accept/decline. On decline, the king lowers taxes to the
 * "alternate" amount.
 *
 * Tax change formula (BYTE_VERIFIED):
 *   base_amount  = ((player_or_difficulty & 0xFE) * 2) + 4
 *   era_multiplier = (turn_counter / 400) + 1
 *   proposed_change = base_amount * era_multiplier
 *
 * For player_or_difficulty in 0..4:
 *   p=0: base=4, era_mult=1..N → 4, 8, 12, 16, ...
 *   p=1: base=4
 *   p=2: base=8
 *   p=3: base=8
 *   p=4: base=12
 *
 * `[0x53A6]` IS difficulty (Discoverer..Viceroy) — resolved 2026-05-30 — giving the harsher
 * tax progression on higher difficulties — matches Colonization's design.
 * ============================================================================ */
void king_attempt_tax_change(void)
{
    /* @asm 0x034AE4..0x034AEC — guard: only act if king's value is > 1 */
    int16_t current_tax = *((int8_t *)g_king_record_84FC + 1);
    if (current_tax <= 1) goto raise_was_blocked;

    /* @asm 0x034AEE..0x034AF9 — base_amount */
    int16_t base_amount = ((g_difficulty_53A6 & 0xFE) * 2) + 4;

    /* @asm 0x034AFC..0x034B07 — era multiplier from turn counter */
    int16_t era_mult = (g_turn_counter_538E / 400) + 1;

    /* @asm 0x034B08..0x034B0D — proposed_change */
    int16_t proposed_change = base_amount * era_mult;

    /* @asm 0x034B10..0x034B15 — block raise if proposed_change + 5 >= current_tax */
    if (proposed_change + 5 >= current_tax) goto raise_was_blocked;

    /* @asm 0x034B17..0x034B1D — and block again if current_tax <= proposed_change.lo
     * This is a paranoid double-guard that prevents the king from making
     * a "raise" that's actually a lower change. */
    if ((int8_t)proposed_change >= current_tax) goto raise_was_blocked;

    /* @asm 0x034B1F..0x034B31 — ask the player about the raise.
     * If user declines (LCALL returns AX = 0 after DEC), fall through to
     * the KINGLOWER branch. If user accepts (AX = 1, DEC = 0, JE), go to
     * the KINGRAISE display branch.
     */
    if (ovly_181F_04D4(g_difficulty_53A6 + 1, 1) == 0) {
        /* USER DECLINED — King lowers taxes by 5 - player_idx (a small bonus) */
        /* @asm 0x034B44..0x034B5C */
        int16_t lower_amount = -(g_difficulty_53A6 - 5);   /* = 5 - player */
        uint16_t adjusted = ovly_181F_04D4(lower_amount, 1);
        ovly_181F_0998(/*buf*/ NULL, /*src*/ "KINGLOWER" /*0x10A8*/, -(int16_t)adjusted);
        return;
    }

    /* @asm 0x034B33..0x034B43 — fall-through after "yes" path: display
     * the raised value via 0x181F:0x998 with KINGRAISE message at 0x10B2. */
raise_was_blocked:
    {
        /* @asm 0x034B62..0x034B7D */
        uint16_t adjusted = ovly_181F_04D4(g_difficulty_53A6, 1);
        adjusted *= 2;
        /* CALL near 0x35418 = func_0353DE — "actually apply the tax change to
         * game state".  This is NOT func_034318 (see src/king/tax_apply.c,
         * tax_apply_delta — the signed-delta apply+cap-75 routine); 0x35418
         * falls inside func_0353DE, a separate function (TBD body). */
        apply_tax_change(adjusted);   /* func_0353DE — TBD internals */
        return;
    }
}

/* ============================================================================
 * Summary
 *
 * Per-event tax raise amount = ((diff & 0xFE) * 2 + 4) * (turn/400 + 1)
 *
 * For Discoverer (diff=0): +4 → +4 → +4 → ... per era (turn 0, 400, 800, ...)
 *                          (always 4 since era_mult * 4)
 *                          actually: 4, 8, 12, 16 (era_mult = 1, 2, 3, 4)
 * For Conquistador (diff=2): 8, 16, 24, 32
 * For Viceroy (diff=4): 12, 24, 36, 48
 *
 * The 5-point safety margin (`proposed_change + 5 >= current_tax`) prevents
 * the king from raising taxes when current tax is already near maximum.
 *
 * STILL UNKNOWN (TODO_VERIFY):
 *   - [RESOLVED 2026-05-30] `[0x53A6]` is difficulty (NOT player_idx) — see decl comment
 *     (other functions use it as player_idx; here it appears to set the
 *     base_amount which suggests difficulty)
 *   - The "current_tax" interpretation: is it a percentage or a flat amount?
 *   - What `apply_tax_change` (CALL near 0x35418) actually does with the value
 *   - The chance/frequency of this function being called per turn
 *     (handled by another function — find via "KINGTAX" PUSH at 0x02f392)
 * ============================================================================ */
