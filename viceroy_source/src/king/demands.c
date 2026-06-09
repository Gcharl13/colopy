/* ============================================================================
 *           >>> KING TAX DEMANDS — cadence ANCHORED; amount BYTE_VERIFIED <<<
 * ----------------------------------------------------------------------------
 * The king's tax-raise demand fires from the per-power per-turn update loop.
 * The DEMAND AMOUNT and the accept/decline lower-bonus are fully byte-verified
 * in king_tax_raise.c (func_034AE0) — this file does NOT restate that formula;
 * it documents the CADENCE (who calls it, how the human-vs-AI gate works) and
 * the king-anger / boycott consequences.
 *
 * @verified_by  Hand-decompiled 2026-05-29 from disasm_overlay_reseg/ +
 *               per-function dump disasm/func_03471E_unknown.asm.
 * @ref          src/king/king_tax_raise.c   (func_034AE0 — amount, BYTE_VERIFIED)
 *
 * ----------------------------------------------------------------------------
 *  >>> 0x53A7 "king-anger" vs "year/100" — RESOLVED FROM BYTES (2026-05-30) <<<
 * ----------------------------------------------------------------------------
 * docs/RULINGS.md (2026-05-28) flagged 0x53A7 as an OPEN conflict: project
 * memory records it as the "king-anger" byte (runtime obs: 2 tea parties at
 * turn 54 took it 3->4->5), while static disasm shows year/century arithmetic.
 *
 * EXHAUSTIVE STATIC EVIDENCE (settles it — there are EXACTLY THREE references
 * to 0x53A7 in the entire re-segmented overlay disassembly, no others anywhere):
 *   1. WRITE  @0x03DE6F (func_03DE46):  A2 A7 53          mov [0x53A7], al
 *        where al = [0x538A]/100  (year / 100); the adjacent
 *        @0x03DE65: 88 16 A8 53      mov [0x53A8], dl  = year % 100.
 *   2. READ   @0x039EEE (func_039EE2): F6 2E A7 53       imul byte [0x53A7]
 *        computing [0x53A8] + 100*[0x53A7]  -> RECONSTRUCTS the year counter.
 *   3. INIT   @0x0757D3:               C6 06 A7 53 00    mov [0x53A7], 0
 * All three were verified byte-for-byte against COLONIZE/VICEROY.EXE.
 * There is NO `inc [0x53A7]`, NO `add [0x53A7]`, and NO indirect write to it
 * anywhere in the binary.
 *
 * RESOLUTION: 0x53A7 / 0x53A8 are the (year/100, year%100) split of the year
 * counter [0x538A] — a display/date scratch pair, NOT a persistent king-anger
 * counter.  The static byte evidence is Tier-1 ground truth and is now complete,
 * so it OVERRIDES the runtime-anger interpretation FOR THIS BYTE: the user's
 * observed 3->4->5 must have been a different address (the real per-power anger
 * state lives elsewhere — candidate is the king PowerRecord, not this DGROUP
 * scratch).  This file therefore does NOT model 0x53A7 as anger.
 *
 * NOTE: the matching docs/RULINGS.md entry (and the project_king_anger_and_ref
 * memory) should be updated to RESOLVED, but that edit is outside this task's
 * src/king + src/diplomacy scope and is left for the cross-source-reconciler.
 * The byte proof above is sufficient to close the conflict.
 *
 * ----------------------------------------------------------------------------
 *  >>> REFUSE-SIDE ANGER MODEL — BYTE_VERIFIED ABSENT (2026-06-08) <<<
 * ----------------------------------------------------------------------------
 * The prior reconstruction claimed "+5 king anger on refuse." This is CONFIRMED
 * ABSENT by exhaustive scan of func_034318 (file 0x034318..0x03471D, 1022 bytes):
 *
 * The pay/refuse branch (BYTE_VERIFIED):
 *   file 0x03466F: 83 7e ac 02   cmp word [bp-0x54], 2
 *   file 0x034673: 74 03         je  0x034678   ; choice==2 → TEA PARTY pay path
 *   file 0x034675: e9 a2 00      jmp 0x03471A   ; else → REFUSE: direct RETF
 *   file 0x03471A: 5e 5f c9 cb   pop si; pop di; leave; retf
 *
 * The refuse path (0x034675 → 0x03471A) writes NOTHING. There is no INC, ADD,
 * or MOV to any PowerRecord field, king-anger byte, or DGROUP global on this path.
 * The three writes to [bx+1] (PowerRecord+0x01 = TAX RATE) in this function are:
 *   @asm 0x03434C: ADD [bx+1], al  — tax += delta (always, on accepted raise)
 *   @asm 0x034364: MOV [bx+1], cl  — clamp to 0x4B (75%) max
 *   @asm 0x03467F: SUB [bx+1], al  — undo temp raise (tea-party pay path only)
 * None of these execute on the refuse path.
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"

extern uint8_t  g_ai_personality_543F[];   /* DGROUP:0x543F — controller byte, stride 0x34 (0 = human) */
extern void *   g_king_record_84FC;        /* DGROUP:0x84FC — far ptr to king PowerRecord */
extern int16_t  g_year_538A;               /* DGROUP:0x538A — current year */

/* The byte-verified tax-change handler (amount/lower-bonus) lives elsewhere. */
extern void king_attempt_tax_change(void);     /* func_034AE0 — see king_tax_raise.c */

/* ============================================================================
 * king_demand_cadence — ANCHOR_VERIFIED
 *
 * @asm_function  func_02F052  (file 0x02F052..0x02F3A0, 847 bytes)
 * @asm_disasm    disasm_overlay_reseg/page_03.asm
 *
 * This is the per-power per-turn update loop.  It iterates the 4 European
 * powers, keying on the AIPersonality controller byte:
 *   @asm 0x02F385  imul bx,[bp-8],0x34          ; AIPersonality stride 0x34
 *   @asm 0x02F389  cmp  byte [bx+0x543F], 0      ; 0 = human controller
 *   @asm 0x02F38E  jne  skip                     ; AI powers take a different path
 * For the human power it dispatches turn events through the message/overlay
 * thunks (LCALL 0x191F:0xAE0 with a resource id), which is where the king's tax
 * demand and other royal events are scheduled.
 *
 * The PRECISE per-turn FIRE PROBABILITY / cadence of the tax demand is NOT
 * byte-resolved: the scheduling crosses RTLink overlay thunk 0x191F:0xAE0 and
 * the king-event selector is data-driven (NAMES.TXT / message tables).  So the
 * cadence is ANCHORED (we know the loop and the gate) but the trigger chance is
 * not yet decoded.  The demand AMOUNT, once fired, is BYTE_VERIFIED (king_tax_raise.c):
 *
 *     per-event raise = ((difficulty & 0xFE) * 2 + 4) * (year/400 + 1)
 *     (blocked when proposed_change + 5 >= current tax)
 * ============================================================================ */
extern void king_schedule_royal_events(int power_id);   /* forward decl — defined below */
void king_demand_cadence(int power_id)   /* ANCHOR_VERIFIED loop; trigger not yet decoded */
{
    /* @asm 0x02F385..0x02F38E — only the human-controlled power runs the
     * royal-event dispatch here (AI powers branch away). */
    if (power_id < 4 && g_ai_personality_543F[power_id * 0x34] == 0) {
        /* Royal events for this turn are dispatched via the overlay message
         * scheduler (LCALL 0x191F:0xAE0).  When the tax-demand event is the one
         * selected, control reaches func_034AE0 (king_attempt_tax_change). The
         * selection probability itself is RUNTIME_ONLY (data-resident) (overlay/data-driven). */
        king_schedule_royal_events(power_id);   /* LCALL 0x191F:0xAE0 — internals in thunk page */
    }
}
/* (king_schedule_royal_events declared above, before king_demand_cadence) */

/* ============================================================================
 * king_tax_options_dialog — ANCHOR_VERIFIED (TAXOPTIONS / TEAPARTY menu)
 *
 * @asm_function  func_03471E  (file 0x03471E..0x0349F3, 725 bytes)
 * @asm_disasm    disasm/func_03471E_unknown.asm
 *
 * Builds the king's tax-options list (the "Boston Tea Party / pay / boycott"
 * choices — string cluster TAXOPTIONS@0x1E9FF, TEAPARTY@0x1EA0A, KINGRECRUIT,
 * KINGFUND, KINGTAX, KINGNOTHING all live adjacent at file 0x1E9FF..0x1EA3C):
 *   @asm 0x03471E  ENTER 0xD6  — builds a 0x1C-entry option array
 *   @asm 0x034789  LCALL 0x191F:0xED0  — present the selection list
 *   @asm 0x034960  selection code 0x62 -> DEC [bp-2]   ; one menu direction
 *   @asm 0x034969  selection code 0x63 -> INC [bp-2]   ; the other
 *   @asm 0x0349CF  on a "pay" choice: king[+0x2A] (gold dword) -= amount
 *                  (SUB [bx+0x2A]/SBB [bx+0x2C], bx = [0x84FC])
 *
 * This confirms the king record's gold field is the dword at +0x2A (consistent
 * with PowerRecord +0x2A), and that the Tea-Party choice routes through this
 * dialog.  The numeric BOYCOTT consequence of a Tea Party is handled by
 * func_034318 (see src/king/tax_apply.c — boycott bitmask king[+0x20] + market
 * price table 0x5DE0, tail not yet decoded).  The 0x53A7 "anger" question is now RESOLVED
 * (it is the year/100 split, not anger — see this file's header).
 * ============================================================================ */
/* (Decompilation captured as the asm citation above; no standalone C body —
 *  the menu internals depend on overlay list-builder thunks — body in thunk page.) */

/* ============================================================================
 *                  >>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<
 * ----------------------------------------------------------------------------
 * The AI tax-acceptance heuristic below is carried over from the prior
 * reconstruction and is NOT byte-verified.  The accept path's tax write is
 * superseded by tax_apply.c (func_034318, BYTE_VERIFIED).  The old "+5 king
 * anger on refuse" claim is BYTE_VERIFIED ABSENT (2026-06-08): 0x53A7 is the
 * year/100 split (RESOLVED, see header), and the refuse path in func_034318
 * (choice≠2, 0x034675 → 0x03471A) writes NOTHING — see header for proof.
 *
 * SCOPE NOTE (2026-06-08): the resident func_03471E (0x03471E, 725B) named
 * "AI king-demand decision" is in fact the human-facing DEMAND DIALOG builder —
 * it assembles a 0x1C-entry option array (8-byte-stride source table @[-0x7158])
 * and makes ~50 LCALLs to overlay list-builder / dialog / sprintf thunks
 * (0x191F:*, 0x181F:*, 0xD1D:*).  It carries no standalone "AI accepts iff X"
 * computation to byte-anchor (the game consequence — the tax write — is already
 * BYTE_VERIFIED in tax_apply.c).  So this heuristic stays RECONSTRUCTED/left unresolved by
 * design, not for lack of trying; a full port would be UI plumbing over
 * body-in-thunk-page overlay thunks, not game logic.
 * ============================================================================ */
int ai_decide_king_demand(PowerRecord *p, int proposed_tax)   /* RECONSTRUCTED */
{
    /* Prior heuristic: AI accepts if the new tax wouldn't exceed 50%. not yet decoded. */
    return (p->tax_rate + proposed_tax) <= 50;
}
