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
/* RTLink thunk at file 0x3681D -> LJMP 0x191F:0x0AE0 (king_announce_tax_raise).
 * Called by the raise_was_blocked path with (adjusted_delta, "KINGRAISE" offset).
 * Overlay internals TBD. BYTE_VERIFIED call site: file 0x034B78..0x034B7D
 *   0e e8 a1 1c  (push cs; call near [+0x1CA1] -> file 0x3681D = LJMP 0x191F:0x0AE0) */
extern void   ovly_191F_0AE0(uint16_t delta, uint16_t str_off); /* king_announce_tax_raise — TBD */

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
        /* @asm 0x034B62..0x034B7D (file 0x034B62, Convention A: file offset = named address)
         *
         * BYTE_VERIFIED 2026-06-08: the raise/guard path draws a random delta and
         * calls through an RTLink thunk into overlay function 0x191F:0x0AE0.
         *
         * The call sequence (BYTE_VERIFIED at file 0x034B62..0x034B7D):
         *   a0 a6 53        mov al, [0x53a6]      ; difficulty
         *   2a e4           sub ah, ah
         *   50              push ax                ; arg lo = difficulty
         *   6a 01           push 1                 ; arg hi = 1
         *   9a d4 04 1f 18  lcall 0x181f:0x4d4     ; random_int(difficulty, 1) -> AX
         *   83 c4 04        add sp, 4
         *   d1 e0           shl ax, 1              ; adjusted = random * 2
         *   50              push ax                ; push adjusted
         *   68 b2 10        push 0x10b2            ; push string offset "KINGRAISE"
         *   0e              push cs
         *   e8 a1 1c        call near [+0x1CA1]   ; -> file 0x3681D (RTLink thunk)
         *
         * File 0x3681D: EA E0 0A 1F 19 = LJMP 0x191F:0x0AE0 (RTLink thunk stub)
         * -> calls overlay function king_announce_tax_raise(adjusted, "KINGRAISE")
         * Internals of 0x191F:0x0AE0 are TBD (overlay not yet dumped).
         *
         * CORRECTION (BYTE_VERIFIED 2026-06-08):
         *   The earlier note "CALL near 0x35418 = func_0353DE" was DOUBLY WRONG:
         *   - 0x35418 is NOT a function entry point; it is mid-instruction (the JE
         *     opcode byte within "or ax,ax ; je 0x35450") inside func_0353DE's body.
         *   - func_0353DE (file 0x0353DE, segment 65, ENTER 2,0) is an INPUT/ACTION
         *     DISPATCHER for a game screen — it reads [0x7ec]/[0x7f6] event queues,
         *     calls get_pending_action (near 0x3689a), and dispatches via a 12-entry
         *     jump table at CS:0x4F54.  It does NOT touch the king's tax-rate field.
         *   - func_0354BE (file 0x0354BE, ENTER 0xE,0, segment 65) is a keyboard
         *     handler for a dialog (likely the king tax-raise dialog); it also does
         *     not write the tax rate directly.
         *   - The actual NEAR CALL target resolves to file 0x3681D which is an RTLink
         *     thunk (EA E0 0A 1F 19 = LJMP 0x191F:0x0AE0), NOT an internal entry
         *     into func_034318 at +0x105.
         */
        uint16_t adjusted = ovly_181F_04D4(g_difficulty_53A6, 1);
        adjusted *= 2;
        /* push "KINGRAISE" then jump through RTLink thunk at file 0x3681D -> 0x191F:0x0AE0 */
        ovly_191F_0AE0(adjusted, 0x10b2 /* "KINGRAISE" */);  /* TBD: internals of king_announce_tax_raise */
        return;
    }
}

/* ============================================================================
 * Summary
 *
 * Per-event tax raise amount = ((diff & 0xFE) * 2 + 4) * (turn/400 + 1)
 *
 * For Discoverer (diff=0): +4 -> +4 -> +4 -> ... per era (turn 0, 400, 800, ...)
 *                          (always 4 since era_mult * 4)
 *                          actually: 4, 8, 12, 16 (era_mult = 1, 2, 3, 4)
 * For Conquistador (diff=2): 8, 16, 24, 32
 * For Viceroy (diff=4): 12, 24, 36, 48
 *
 * The 5-point safety margin (`proposed_change + 5 >= current_tax`) prevents
 * the king from raising taxes when current tax is already near maximum.
 *
 * BYTE_VERIFIED SUMMARY (func_0353DE / segment 65) — 2026-06-08:
 *
 *  1. Project naming convention: function addresses are FILE OFFSETS (not
 *     asm_addr + 0x2400).  "func_0353DE" = bytes at file offset 0x0353DE.
 *
 *  2. func_0353DE (file 0x0353DE..0x0354BD, ENTER 2,0, 224 bytes):
 *     - Reads event queues [DGROUP:0x7ec] and [DGROUP:0x7f6].
 *     - Calls get_pending_action (near 0x3689a) to pop the current action code
 *       into [DGROUP:0x9e3a] and [DGROUP:0x9e3c].
 *     - Special-cases action codes 0x08/0x09/0x0A (navigation/arrow group):
 *       calls get_pending_action a second time to get a sub-code (0..3).
 *     - Falls through to a 12-entry CS-relative jump table at CS:0x4F54.
 *     - Jump table branches all use "push cs; call near" to invoke sub-handlers
 *       at 0x36877, 0x36859, 0x36895, 0x3689a, 0x368D1, 0x368EF, 0x3693A, 0x36930.
 *     - Guard: if action_code == 0 AND [DGROUP:0x5384] bit 0 clear -> early RETF.
 *     - Does NOT touch king tax rate, boycott mask, or any king record field.
 *     - Identity: input/action dispatcher for an in-game screen (likely
 *       "king audience" or "Europe view" mode).
 *
 *  3. func_0354BE (file 0x0354BE..0x0355A5, ENTER 0xE,0):
 *     - Takes arg [bp+6] = key/scan code.
 *     - Dispatches on ASCII values 0x09, 0x1B, 0x21, 0x31, 0x50, 0x52, 0x58.
 *     - References [DGROUP:0x9e38], [DGROUP:0x5383] bit 5, [DGROUP:0x5384].
 *     - Calls sub-handlers in the same segment (0x36903, 0x36930, 0x36935).
 *     - Also calls 0x191f:0x934 and 0x191f:0x942 (audio/overlay helpers).
 *     - Identity: keyboard handler for a dialog (likely the king tax-raise dialog).
 *
 *  4. The "CALL near 0x35418 = func_0353DE" note in the original king_tax_raise.c
 *     was doubly wrong: 0x35418 is mid-instruction (JE opcode byte) in func_0353DE,
 *     and king_attempt_tax_change actually calls through RTLink thunk at file 0x3681D
 *     to overlay function 0x191F:0x0AE0 — not into func_034318 or func_0353DE.
 *
 *  5. The actual call from king_attempt_tax_change (BYTE_VERIFIED):
 *       push adjusted_delta    ; random * 2
 *       push 0x10b2            ; "KINGRAISE" string offset
 *       push cs
 *       call near [+0x1CA1]    ; -> file 0x3681D (RTLink thunk)
 *       ; file 0x3681D: EA E0 0A 1F 19 = LJMP 0x191F:0x0AE0
 *     Resolves to overlay function 0x191F:0x0AE0 (king_announce_tax_raise).
 *     Internals of that overlay are TBD (segment not yet dumped).
 *     Note: file 0x3441D (Convention A) is mid-function boycott loop code INSIDE
 *     func_034318 (not a call target from king_attempt_tax_change).
 *
 *  6. STILL UNKNOWN (TODO_VERIFY):
 *     - Whether 0x191F:0x0AE0 internally calls func_034318 (tax_apply_delta) to
 *       write the new tax rate, or handles the write itself.
 *     - The chance/frequency of king_attempt_tax_change being called per turn
 *       (find via "KINGTAX" PUSH at file 0x02f392).
 * ============================================================================ */
