/* ============================================================================
 *                  >>> BYTE_VERIFIED (formula structure) <<<
 * ----------------------------------------------------------------------------
 * The "SMITE" branch of the diplomacy/parley dialog.  When the player meets
 * a native chief and chooses to attack ("SMITE") instead of negotiate, this
 * is the code that computes the loot the player gains.
 *
 * Function: `func_057F4E` (the diplomacy meeting handler)
 *   SEE ALSO: src/diplomacy/meeting.c — the wave-4 port of the SAME function
 *   (the European-relation dispatcher skeleton + treaty/war/tribute/peace
 *   mutations). This file is the SMITE-loot branch only; the two are
 *   complementary and do not overlap. (meeting.c verified the real extent as
 *   0x057F4E..0x059B3C / 7151 B; the 0x0580B1 cutoff below was the truncated
 *   per-func dump, RULINGS 2026-05-30.)
 *   NOTE: the `g_powerrecord_8809[..+0x29]` labels below reach the SAME bytes
 *   as the canonical base 0x8808 + idx*0x13C + 0x2A (gold). Address math is
 *   correct; only the symbolic base/offset split is the older convention.
 *   Real extent:  file 0x057F4E..0x059B3D  (~6,640 bytes — boundary
 *                 detector cut off at 0x0580B1, an early-exit RETF)
 *   Region:       overlay
 *   Args:         [BP+6]  = power_idx of attacker (the player)
 *                 [BP+8]  = power_idx of opponent (the native tribe)
 *                 [BP+0xE] = some flag (decision context)
 *   Locals:       ENTER 0xD6 — 214-byte stack frame, ~12 named locals
 *
 * Function purpose: this is a HUGE diplomacy dispatcher.  Strings PUSHed
 * by this function include:
 *   HELLO, AHOY, FIRST, KINGS, DEEDS, MEEK, MANLY, APOSTATES, HEATHEN,
 *   LEADER, PIRACY, SIEGES, TRIBUTE, WANTSTUFF, PROVOKE, WARMANLY,
 *   WORTHY, PEACE, OLDPEACE, PEACEUSA, GIFTS, THREATS, NOCONTACT,
 *   ALREADYSMITE, SMITEINDIANS, SMITEEUROPE, UNFORTUNATE, MERCENARY,
 *   WITHDRAW, NOTHINGWITHDRAW, NOTWITHDRAW, MAYBEWITHDRAW.
 *
 * The SMITE branch (file 0x05991C..0x059B3D) computes the loot the player
 * would gain by attacking, displays the SMITEINDIANS / SMITEEUROPE dialog
 * with the value, and on YES executes the gold transfer.
 * ============================================================================ */
#include <stdbool.h>
#include "viceroy_types.h"
#include <stdbool.h>

/* BYTE_VERIFIED 2026-06-08: per-power (0..3) flat arrays — NOT stride-0x13C.
 *   942C: per-power diplomatic contact/activity count, uint8 [4], saturating 0..255.
 *         Zeroed on power init @0x042171; saturating-incremented via helper @0x042126.
 *         Read @0x03DF67 as (byte+1)/16 for display/score.
 *   941C: per-power cumulative trade/gold accumulator, uint16 [4].
 *         Zeroed @0x042142 (bx=power*2; [bx-0x6BE4]=0); accumulated from unit
 *         trade values via 0x181F:0x09C8 @0x042335.
 *         Read @0x03DF7A as (word+1)/32 for display; summed all 4 @0x035E80;
 *         compared between powers for preferred-trade-partner selection @0x03F0C5.
 *   In the smite formula the byte (contact count) + word (trade volume) form the
 *   player_factor; local_C8 is a power index (0..3) — likely attacker power. */
extern uint8_t  g_diplo_contact_942C[4]; /* per-power contact count (0..255 sat.) */
extern uint16_t g_trade_accum_941C[4];   /* per-power trade/gold accumulator */
extern uint8_t  g_powerrecord_8809[];   /* PowerRecord[] base, stride 0x13C (BYTE_VERIFIED) */
extern void *   g_payer_record_84FC;    /* DGROUP:0x84FC — far ptr to current "payer"
                                         * record (the tribe being smited).  Has a
                                         * 32-bit gold field at +0x2A. */
extern uint16_t power_attribute_bit(uint16_t power, int16_t bit);
extern int32_t  __aFlmul(int32_t a, int32_t b);
extern int32_t  __aFldiv(int32_t a, int32_t b);
/* BYTE_VERIFIED 2026-06-08: pure clamp. Implementation at file 0x0048CC (runtime
 * 0x024C:0x000C, dispatched via overlay stub 0x181F:0x035C at file 0x1A94C).
 * Arg order: clamp(value=[bp+6], lo=[bp+8], hi=[bp+0xa]) = max(lo, min(value, hi)).
 * Call in smite: ovly_181F_035C(step3, 10, 200) → result ∈ [10, 200] → gold ∈ [500, 10000]. */
extern int16_t  ovly_181F_035C(int16_t value, int16_t lo, int16_t hi);

/* ============================================================================
 * SMITE branch — byte-verified formula
 *
 * Compute the loot the player would gain by attacking the tribe at
 * `opponent_power_idx`, display the SMITEINDIANS / SMITEEUROPE dialog,
 * and on confirmation transfer the gold from the tribe to the attacker.
 *
 * BYTE-VERIFIED instruction range: file 0x05997C..0x059AD9  (380 bytes)
 * ============================================================================ */
void smite_branch(int attacker_power_idx, int opponent_power_idx)
{
    /* ---- 1. Compute "intermediate" = factor × tribe_treasury / 2500 ------
     *
     * @asm 0x05997C..0x05999A  the setup PUSHes (4 longs on stack):
     *   PUSH 200          ; saved as third arg of clamp call later
     *   PUSH 10           ; saved as second arg of clamp call later
     *   PUSH 0; PUSH 50   ; long divisor for first fldiv
     *   PUSH 0; PUSH 50   ; long divisor for second fldiv (after fmul)
     *
     * @asm 0x059989..0x059996  load tribe treasury and divide by 50:
     *   IMUL bx, [bp+6], 0x13c             ; bx = attacker * 0x13C  (PowerRecord stride)
     *   PUSH word [bx+0x8834]               ; PR[attacker]+0x2B (high)
     *   PUSH word [bx+0x8832]               ; PR[attacker]+0x29 (low)
     *   LCALL __aFldiv                      ; DX:AX = treasury / 50
     */
    int32_t treasury_attacker_8829 =
        *(int32_t *)&g_powerrecord_8809[attacker_power_idx * 0x13C + 0x29];
    int32_t step1 = __aFldiv(treasury_attacker_8829, 50);

    /* ---- 2. Multiply by player_factor (table-driven) ---------------------
     *
     * @asm 0x05999D..0x0599B0
     *   MOV bx, [bp-0xC8]                   ; bx = local_C8 (power index 0..3)
     *   MOV al, [bx + 0x942C]               ; AL = g_diplo_contact_942C[power]
     *   SUB ah, ah                          ; AX = AL (zero-extended)
     *   SHL bx, 1                           ; bx *= 2 (word index for 941C)
     *   ADD ax, [bx + 0x941C]               ; AX += g_trade_accum_941C[power]
     *   PUSH 0; PUSH AX                     ; long: player_factor as int32
     *   LCALL __aFlmul                      ; DX:AX = player_factor * step1
     *
     * player_factor = contact_count + trade_volume:
     *   contact_count  = g_diplo_contact_942C[power] (diplomatic meetings, 0..255)
     *   trade_volume   = g_trade_accum_941C[power] (cumulative gold/trade activity)
     */
    int power_idx = attacker_power_idx; /* local_C8 = power index 0..3 (not yet decoded: attacker vs opponent) */
    int32_t player_factor =
        (int32_t)g_diplo_contact_942C[power_idx] + (int32_t)g_trade_accum_941C[power_idx];
    int32_t step2 = __aFlmul(player_factor, step1);

    /* ---- 3. Divide by 50 again — the previously-pushed 50 long is consumed -
     *
     * @asm 0x0599B5..0x0599BC
     *   PUSH DX; PUSH AX                    ; long: step2 (= player_factor * treasury / 50)
     *   LCALL __aFldiv                      ; DX:AX = step2 / 50  =  pf * tr / 2500
     *   PUSH AX                             ; PUSH only the low word (gold fits in 16 bits)
     */
    int32_t step3 = __aFldiv(step2, 50);     /* = player_factor × treasury / 2500 */

    /* ---- 4. Clamp to [10, 200] via ovly_181F_035C — BYTE_VERIFIED 2026-06-08 -----
     *
     * @asm 0x0599BD..0x0599C5
     *   LCALL 0x181F:0x035C                 ; clamp(step3, 10, 200) — VERIFIED
     *   ADD SP, 6                           ; pop the 3 word args
     *   IMUL AX, AX, 0x32                   ; AX = result × 50
     *   MOV [BP-0x94], AX                   ; gold = result × 50
     *
     * ovly_181F_035C IS a pure clamp: file 0x0048CC (runtime 0x024C:0x000C).
     * Result = max(10, min(step3, 200)).  gold = clamp × 50 ∈ [500, 10000]. */
    int16_t clamped = ovly_181F_035C((int16_t)step3, 10, 200);
    int16_t gold = clamped * 50;

    /* ---- 5. Optional halving: bit 19 of attacker's PowerRecord bitfield --
     *
     * @asm 0x0599CC..0x0599DF
     *   PUSH 0x13                           ; PUSH 19  (bit number)
     *   PUSH word [bp+6]                    ; PUSH attacker_power_idx
     *   LCALL ovly_181F_07B4                ; = power_attribute_bit
     *   ADD SP, 4
     *   OR AX, AX
     *   JE +4                               ; bit clear -> no halve
     *   SAR word [BP-0x94], 1               ; gold /= 2  (signed shift)
     */
    if (power_attribute_bit(attacker_power_idx, 19) != 0) {
        gold >>= 1;       /* arithmetic right-shift (signed div by 2) */
    }

    /* ---- 6. Display SMITEINDIANS / SMITEEUROPE dialog --------------------
     *
     * @asm 0x0599E1..0x059A1D
     *   ... formatting calls via ovly_181F_09A4, ovly_181F_0438, ovly_181F_09AE ...
     *   PUSH word [bp+8]                    ; opponent_power_idx
     *   PUSH 0x1A1A → SMITEINDIANS  (or 0x1A27 → SMITEEUROPE)
     *   LCALL 0x1A1F:0x0688                 ; display dialog (returns 1=YES, else NO)
     *   CMP AX, 1
     *   JE 0x59A22  (yes path)
     *   JMP 0x59ADA (no path → epilogue)
     */
    bool confirmed = display_smite_dialog(opponent_power_idx, gold);
    if (!confirmed) return;

    /* ---- 7. (yes path) Sufficient-funds check ----------------------------
     *
     * @asm 0x059A22..0x059A3F
     *   MOV ax, [BP-0x94]; CDQ              ; DX:AX = gold (sign-extended)
     *   MOV bx, [0x84FC]                    ; BX = ptr to PAYER record
     *   CMP [BX+0x2C], DX                   ; compare high words first
     *   JG  +0x10  → 0x59A40                ; payer.gold high > gold high → ok
     *   JL  +5     → 0x59A37                ; payer.gold high < gold high → insufficient
     *   CMP [BX+0x2A], AX
     *   JAE +9     → 0x59A40                ; payer.gold low >= gold low → ok
     *
     *   ; insufficient funds branch (0x59A37):
     *   PUSH word [bp+8]
     *   PUSH 0x1A33 → "UNFORTUNATE"         ; "you'd love to but the tribe is broke"
     *   JMP -0x1A0 → 0x598A0
     */
    int32_t *payer_gold = (int32_t *)((char *)g_payer_record_84FC + 0x2A);
    if (*payer_gold < (int32_t)gold) {
        display_message(opponent_power_idx, "UNFORTUNATE");
        return;
    }

    /* ---- 8. Gold transfer (BYTE_VERIFIED) ---------------------------------
     *
     * @asm 0x059ABE..0x059AD9
     *   MOV ax, [BP-0x94]; CDQ              ; DX:AX = gold
     *   MOV bx, [0x84FC]                    ; payer (the tribe)
     *   SUB [BX+0x2A], AX                   ; payer.gold_low -= gold
     *   SBB [BX+0x2C], DX                   ; payer.gold_high -= gold (with borrow)
     *   IMUL bx, [bp+8], 0x13C              ; bx = opponent * 0x13C  (recipient)
     *   ADD [BX+0x8832], AX                 ; PowerRecord[opponent]+0x29 += gold
     *   ADC [BX+0x8834], DX
     */
    *payer_gold -= (int32_t)gold;
    *(int32_t *)&g_powerrecord_8809[opponent_power_idx * 0x13C + 0x29] += (int32_t)gold;

    /* ---- 9. (Tail of yes-path includes additional MERCENARY message,
     *         tribe-extinction check, and bookkeeping — at 0x59A66 onward.
     *         Not required for the gold formula itself.) -------------------*/
}

/* ============================================================================
 * SUMMARY (BYTE_VERIFIED FORMULA — fully resolved 2026-06-08)
 *
 * For a player smiting a native tribe:
 *
 *   step1    = tribe_treasury / 50                               (32-bit)
 *   step2    = player_factor × step1                              (32-bit)
 *   step3    = step2 / 50              = pf × treasury / 2500
 *   clamped  = clamp(step3, 10, 200)   [ovly_181F_035C CONFIRMED CLAMP]
 *   gold     = clamped × 50            ∈ [500, 10000]
 *   if (PowerBitfield[attacker].bit19 set):
 *       gold = gold / 2
 *
 *   payer.gold        -= gold       (the tribe being smited)
 *   recipient.gold    += gold       (the player's PowerRecord +0x29)
 *
 *   player_factor = g_diplo_contact_942C[power] + g_trade_accum_941C[power]
 *     TABLE IDENTITIES RESOLVED 2026-06-10: 0x942C = the AI-census per-power
 *     COASTAL-CARGO TOTAL and 0x941C = the census FINANCE word (writer
 *     overlay_040C1E_04458A.c) — i.e. the smite payout scales with the
 *     power's visible wealth.  (Which side's index — attacker vs opponent —
 *     still needs the register trace at the call site.)
 *
 * RESOLVED 2026-06-08:
 *   - ovly_181F_035C: PURE CLAMP (file 0x0048CC, runtime 0x024C:0x000C)
 *     clamp(value=[bp+6], lo=[bp+8], hi=[bp+a]) = max(lo, min(value, hi))
 *   - g_byte_DGROUP_942C → g_diplo_contact_942C: per-power uint8[4] contact count
 *     (reset to 0 @0x042171; saturating increment @0x042126; /16 for display)
 *   - g_word_DGROUP_941C → g_trade_accum_941C: per-power uint16[4] trade volume
 *     (accumulated from unit trade values @0x042335; /32 for display)
 * STILL not yet decoded:
 *   - exact power index for local_C8 (attacker vs opponent)
 *   - bit 19 of attacker PowerRecord (Founding Father or scenario flag)
 * ============================================================================ */
