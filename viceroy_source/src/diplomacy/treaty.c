/* ============================================================================
 *           >>> PARTIALLY BYTE-VERIFIED (func_057DC0) <<<
 * ----------------------------------------------------------------------------
 * The control flow, struct offsets, and matrix arithmetic of treaty_set_state()
 * below are decompiled byte-for-byte from VICEROY.EXE overlay page 0x0F,
 * function func_057DC0 @ file 0x057DC0 (the SIGNTREATY / treaty-state handler).
 * Anchors carry @asm citations with the exact bytes.
 *
 * Helper routines reached through `lcall 0x181F:NNNN` are RTLink overlay/
 * load-image thunks; their *call sites and arguments* are verified, but their
 * internal behaviour is body in thunk page (resolved target file offsets are cited so
 * they can be decompiled in a later pass).
 *
 * Anything still labelled not yet decoded has NOT been confirmed against bytes — do not
 * trust it. Upgrade per viceroy_source/VERIFICATION_LEDGER.md.
 * ============================================================================ */

/* ============================================================================
 * treaty.c -- European treaty / war / peace / alliance state machine
 * ----------------------------------------------------------------------------
 * @ref ../docs/EUROPEAN_DIPLOMACY.md
 * @asm VICEROY.EXE func_057DC0 @0x057DC0  (page 0x0F, size 397, terminal RETF)
 * @asm overlay_functions_reseg.json : {"file_offset":"0x057DC0","page_id":"0x0F",
 *      "size":397,"prologue_type":"push bp;mov bp,sp","terminal":"RETF"}
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"

/* ----------------------------------------------------------------------------
 * Per-power relation/alliance state matrix.
 * ----------------------------------------------------------------------------
 * @asm 057EBD: imul si, word ptr [bp+6], 0x13c   ; si = powerA * stride(316)
 * @asm 057EC2: mov  bx, word ptr [bp+8]          ; bx = powerB index
 * @asm 057EC5: mov  byte ptr [bx + si - 0x77b8], al   ; matrix[A][B] = al
 * @asm 057EC9: imul si, bx, 0x13c                ; (symmetric)
 * @asm 057ECD: mov  bx, word ptr [bp+6]
 * @asm 057ED0: mov  byte ptr [bx + si - 0x77b8], al   ; matrix[B][A] = al
 *
 * -0x77B8 (mod 0x10000) == +0x8848.  PowerRecord base is DGROUP:0x8808 with
 * stride 0x13C, so 0x8848 = PowerRecord + 0x40.  The treaty/alliance state for
 * the pair (A,B) is therefore the byte PowerRecord[A].rel_state[B], a 4-entry
 * (one per European power) array embedded at PowerRecord offset +0x40, written
 * SYMMETRICALLY (both [A][B] and [B][A]).
 *
 * VERIFIED: base 0x8848, stride 0x13C, symmetric write, location PowerRecord+0x40.
 * @ref docs/RULINGS.md 2026-05-28 (alliance matrix at DGROUP:0x8848 stride 0x13C).
 *
 * Written value `al`:
 *   1  -> treaty/alliance ESTABLISHED   (@asm 057EBB: mov al, 1)
 *   0  -> treaty/alliance CLEARED/WAR   (@asm 057F23: sub al, al)
 */
#define REL_STATE_MATRIX_BASE   0x8848        /* @asm -0x77B8 -> +0x8848 = PowerRecord+0x40 */
#define POWER_STRIDE            0x13C         /* @asm 057EBD imul ...,0x13c */

/* Message keys pushed to the load-image string/notify helper 0x181F:0x652.
 * RESOLVED 2026-05-30 (BYTE_VERIFIED): the handle->string mapping is
 * file_offset = handle + 0x1D9A0 (derived & verified from SIGNTREATY
 * 0x188D->0x1F22D, CANCELTREATY 0x1898->0x1F238, DECLAREWAR 0x18A5->0x1F245;
 * raw bytes 0x057F10=68 98 18 and 0x057F18=68 A5 18 confirm the pushes).
 * @asm 057E84: push 2 ; 057E86: push 0x188d ; 057E89: lcall 0x181f,0x652
 *   -> SIGNTREATY    @ file 0x1F22D
 * @asm 057F0E: push 2 ; push 0x1898   -> CANCELTREATY @ file 0x1F238  (CONFIRMED)
 * @asm 057F16: push 2 ; push 0x18a5   -> DECLAREWAR   @ file 0x1F245  (CONFIRMED)
 * The leading literal 2 is the sub-view channel id for 0x181F:0x0652's
 * multi-channel event broadcaster (BYTE_VERIFIED 2026-06-08 via full
 * disassembly of 0x181F:0x9AE body):
 *   Channel 0 = base-attribute sub-view
 *   Channel 1 = intermediate/key sub-view
 *   Channel 2 = PRIMARY NUMERIC RESULT sub-view (the main value to display)
 * In this context channel 2 sends the 32-bit signed treaty-effect value,
 * targeting the slot that shows the actual +/− relation number in the
 * diplomatic-relation display panel.  (0x181F:0x9AE computes
 * dispatch offset = (channel+1)×16; channel 2 → offset 48 = 0x30.)
 * So this handler's "clear" branch emits CANCELTREATY when a treaty was in force
 * and DECLAREWAR otherwise — the break-vs-declare-war distinction. */
#define MSGKEY_SIGNTREATY       0x188D        /* @asm 057E86 push 0x188d -> "SIGNTREATY"   */
#define MSGKEY_CANCELTREATY     0x1898        /* @asm 057F10 push 0x1898 -> "CANCELTREATY" (CONFIRMED) */
#define MSGKEY_DECLAREWAR       0x18A5        /* @asm 057F18 push 0x18a5 -> "DECLAREWAR"   (CONFIRMED) */
/* channel 2 = primary numeric sub-view; BYTE_VERIFIED 2026-06-08 */
#define NOTIFY_CHANNEL_TREATY   2             /* @asm push 2 before the key [V] */

/* ----------------------------------------------------------------------------
 * Overlay/load-image helpers (RTLink thunks). Call sites + args VERIFIED;
 * internal behaviour: body in thunk page. Resolved target file offsets cited for follow-up.
 * (lcall_resolution_VICEROY.json)
 * ---------------------------------------------------------------------------- */
/* 0x181F:0x0A38 -> Type-B, file 0x5FC30 : relation-flag accessor.
 *   Called rel_flags = rel_query(p, q); returned in AL, tested by bit:
 *     bit 0x02  -> "at war" / hostile lock        (@asm 057E05 test al,2)
 *     bit 0x20  -> some peace/treaty-pending bit   (@asm 057DF0 test al,0x20)
 *     bit 0x40  -> existing treaty/alliance bit     (@asm 057E7D test al,0x40)
 *   Bit meanings: BYTE_VERIFIED 2026-06-08 via OVERLAY_LCALL_REFERENCE.md:
 *   war_matrix_read(power,k) -> relation/war-slot byte; power<4: 0x883C+power*0x13C+k,
 *   power>=4: 0x59D8+power*0x4E+k.  Cross-ref: relations.c REL_FLAG_WAR/PEACE_PENDING/TREATY. */
extern uint8_t rel_query(int power_self, int power_other);            /* 0x181F:0x0A38 */

/* 0x181F:0x09A4 -> Type-B, file 0x5FE0C : power-index -> name handle/token.
 *   Cross-ref: overlay_046D70_04C2E1.c @asm 0x046F9E "power_handle(tribe_power_index) → ax"
 *   (the return value is a localised name handle pushed to 0x181F:0x0438 slot args).
 *   Body: library-implementation-only (overlay-resident). */
extern int      power_handle(int power_idx);                          /* 0x181F:0x09A4 */

/* 0x181F:0x0438 -> Type-A, file 0x25CEC : msg_set_arg(handle, slot) — set message
 *   argument/subject for the current dialog context.  Cross-ref: overlay_046D70
 *   @asm 0x046FA9 "msg_set_arg(handle, slot=0)"; overlay_02083C set_message_subject.
 *   Body: library-implementation-only (overlay-resident). */
extern void     power_set_flag(int handle, int flag);                 /* 0x181F:0x0438 */

/* 0x181F:0x0652 -> Type-A, file 0x290A2 : show localized message by handle.
 *   Cross-ref: king/intervention.c "ui_show_message(channel, msg_handle)";
 *   overlay_046D70 @asm 0x046FB6 "display_message(3, 'EXTINCT')"; treaty.c verified use
 *   (channel 2 = primary numeric sub-view, see NOTIFY_CHANNEL_TREATY comment above).
 *   Body: library-implementation-only (overlay-resident). */
extern void     ui_notify_key(int channel, int msg_key);              /* 0x181F:0x0652 */

/* 0x181F:0x0A06 -> Type-B, file 0x5FCD2 : SET masked treaty/relation bit for pair (A,B).
 *   Cross-ref: overlay_038A50_03C5A8.c declares as power_set_a06(power, marker, code).
 *   Body: library-implementation-only (overlay-resident). */
extern void     rel_apply_event(int mask, int power_a, int power_b);  /* 0x181F:0x0A06 */
/* 0x181F:0x0A10 -> Type-B, file 0x5FCFC : CLEAR masked treaty/relation bit for (A, handle).
 *   Cross-ref: overlay_038A50_03C5A8.c declares as power_set_a10(power, marker, code).
 *   Body: library-implementation-only (overlay-resident). */
extern void     rel_clear_event(int mask, int power_a, int handle);   /* 0x181F:0x0A10 */

/* cs-relative near calls inside page 0x0F.  RESOLVED 2026-05-30: cs:0x3FXX is a
 * far-jump TRAMPOLINE table at file 0x05A1D6 (a run of `ljmp 0x1A1F:NNN`).  CS
 * base of page 0x0F is 0x562B0 (file 0x057DC0 == cs-off 0x1B10), so:
 *   cs:0x3F58 = file 0x05A208 = `ljmp 0x1A1F:0x67A`  (relation predicate)
 *   cs:0x3F30 = file 0x05A1E0 = `ljmp 0x1A1F:0x60A`  (per-side relation tag/mutate)
 * Trampoline bytes verified (EA <off> <seg> far-jumps).  The 0x1A1F overlay is
 * the diplomacy UI/relation overlay; the target bodies are library-implementation-only
 * (0x1A1F page; bodies not decodable from the load image). */
extern int  cs_3f58(int a, int b);   /* @asm 057E54/057E65 call cs:0x3f58 -> ljmp 0x1A1F:0x67A */
extern void cs_3f30(int a, int b);   /* @asm 057EA8/057EB5 call cs:0x3f30 -> ljmp 0x1A1F:0x60A */

/* Module-scope DGROUP globals referenced by the handler.
 * 0x5382 cross-ref: ai/unit_ai_leaf.c "bit0 = endgame / War-of-Independence active";
 *   overlay_038A50 "bit0 = independence declared"; king/war_turn.c "global event flags".
 * 0x538E cross-ref: ai/unit_ai_leaf.c "turn counter (VERIFICATION_LEDGER.md:492)";
 *   overlay_054505_05C69B.c "g_turn_538E — turn counter". */
extern uint8_t  g_diplo_guard_5382;  /* @asm 057DC4 test byte ptr [0x5382],1 — global-event / independence-lock flag; bit0=at war/endgame */
extern int16_t  g_diplo_phase_538e;  /* @asm 057DD1 add ax, word ptr [0x538e] — turn counter */

/* The active player's PowerRecord pointer cache (DGROUP:0x84FC). Verified by
 * the gold dword at [bx+0x2a]/[bx+0x2c] and ff_count at [bx+0x14] across many
 * functions; see effects.c. Used here only for documentation. */
extern struct PowerRecord *g_active_power;   /* DGROUP:0x84FC */

static inline uint8_t *rel_state_cell(int power_self, int power_other)
{
    /* @asm matrix[self][other] = *(uint8_t*)(0x8848 + self*0x13C + other) */
    uint8_t *base = (uint8_t *)REL_STATE_MATRIX_BASE;
    return base + (unsigned)power_self * POWER_STRIDE + (unsigned)power_other;
}

/* ----------------------------------------------------------------------------
 * treaty_set_state -- func_057DC0
 * ----------------------------------------------------------------------------
 * Establish or break a treaty/alliance between two European powers `a`,`b`.
 * Mirrors the original byte-for-byte: a chain of relation-flag gates decides
 * whether the action is legal, then either SETS (al=1) or CLEARS (al=0) the
 * symmetric relation-state matrix and fires the appropriate UI notify key.
 *
 * Args correspond to the stack:  a == [bp+6], b == [bp+8].
 * ---------------------------------------------------------------------------- */
void treaty_set_state(int a, int b)
{
    /* @asm 057DC4: test byte ptr [0x5382], 1 ; jne -> exit
     * If diplomacy is globally locked this turn, do nothing. */
    if (g_diplo_guard_5382 & 1)
        return;                                       /* @asm jmp 0x1c9a (exit) */

    /* @asm 057DCE..057DE0: ((a + [0x538e] + b) % 3) != 0 ?
     * A turn/phase parity gate; on the off-phase fall through to the SET path. */
    int phase = (a + g_diplo_phase_538e + b) % 3;     /* @asm idiv cx(=3); or dx,dx */

    if (phase != 0) {
        /* @asm 057DE2: push [bp+8](b); push [bp+6](a) -> rel_query(a,b)
         * (far cdecl: last push = arg0). @asm 057DF0 test al,0x20 -> exit. */
        if (rel_query(a, b) & 0x20)                    /* @asm 057DF0 peace-pending lock */
            return;                                    /* @asm 057DF4 jmp exit */
        /* @asm 057DF7: push [bp+8](b); push [bp+6](a) -> rel_query(a,b) */
        if (rel_query(a, b) & 0x02)                    /* @asm 057E05 already at war */
            return;                                    /* @asm 057E09 jmp exit */
    }

    /* @asm 057E0C: push [bp+6](a); push [bp+8](b) -> rel_query(b,a) */
    if (rel_query(b, a) & 0x02)                        /* @asm 057E1A war the other direction */
        return;                                        /* @asm 057E1E jmp exit */

    /* @asm 057E21..057E4C: power_set_flag(power_handle(a), 0);
     *                       power_set_flag(power_handle(b), 1);
     * Tags each side with its role (0 = self/proposer slot, 1 = other). */
    power_set_flag(power_handle(a), 0);                /* @asm 057E2D push 0 */
    power_set_flag(power_handle(b), 1);                /* @asm 057E43 push 1 */

    /* @asm 057E54 / 057E65: two relation predicates (cs:0x3f58).  If EITHER
     * returns non-zero -> the "break/cancel" branch at 0x1c28. */
    if (cs_3f58(b, a) || cs_3f58(a, b)) {
        /* ----- CLEAR / cancel-or-declare-war branch (@asm 0x1c28) -----
         * All rel_query calls here push [bp+8](b) then [bp+6](a) -> rel_query(a,b). */
        /* @asm 057EE6: if (rel_query(a,b) & 0x40) goto do_clear (0x1c4c)
         * @asm 057EF8: else if (rel_query(a,b) & 0x20) -> exit
         * i.e. only break a treaty that actually exists; ignore if pending. */
        if (!(rel_query(a, b) & 0x40)) {
            if (rel_query(a, b) & 0x20)
                return;                                /* @asm 057EFA exit */
        }

        /* @asm 057F0A: choose notify key by whether a treaty was in force —
         * CANCELTREATY if breaking an existing treaty, else DECLAREWAR. */
        int key = (rel_query(a, b) & 0x40)
                      ? MSGKEY_CANCELTREATY            /* @asm 057F10 push 0x1898 -> "CANCELTREATY" */
                      : MSGKEY_DECLAREWAR;             /* @asm 057F18 push 0x18a5 -> "DECLAREWAR" */
        ui_notify_key(NOTIFY_CHANNEL_TREATY, key);     /* @asm 057F1B lcall 0x181f,0x652 */

        /* @asm 057F23: al = 0  -> CLEAR both symmetric cells */
        *rel_state_cell(a, b) = 0;                      /* @asm 057F2D */
        *rel_state_cell(b, a) = 0;                      /* @asm 057F38 */

        /* @asm 057F3C: rel_clear_event(0x40, b, power_handle(b)) */
        rel_clear_event(0x40, b, power_handle(b));      /* @asm 057F42 lcall 0x181f,0xa10 */
        return;                                         /* @asm 057F4A exit */
    }

    /* ----- ESTABLISH treaty/alliance branch (fall-through) ----- */
    /* @asm 057E6F: push [bp+8](b); push [bp+6](a) -> rel_query(a,b) & 0x40
     *              -> exit (a treaty is already in force). */
    if (rel_query(a, b) & 0x40)
        return;                                         /* @asm 057E81 exit */

    /* @asm 057E84: notify SIGNTREATY */
    ui_notify_key(NOTIFY_CHANNEL_TREATY, MSGKEY_SIGNTREATY);  /* @asm 057E89 lcall 0x181f,0x652 */

    /* @asm 057E91: rel_apply_event(0x40, b, a) */
    rel_apply_event(0x40, b, a);                        /* @asm 057E99 lcall 0x181f,0xa06 */

    /* @asm 057EA1 / 057EAE: two relation mutations (cs:0x3f30) for each side */
    cs_3f30(b, a);                                      /* @asm 057EA8 call 0x3f30 */
    cs_3f30(a, b);                                      /* @asm 057EB5 call 0x3f30 */

    /* @asm 057EBB: al = 1 -> SET both symmetric cells */
    *rel_state_cell(a, b) = 1;                          /* @asm 057EC5 */
    *rel_state_cell(b, a) = 1;                          /* @asm 057ED0 */
    /* @asm 057ED5 leave / 057ED6 retf */
}

/* ============================================================================
 * EVERYTHING BELOW IS not yet decoded (NOT byte-verified)
 * ----------------------------------------------------------------------------
 * The original game presents treaty proposals through a UI/AI-evaluation path
 * that has NOT yet been located or decompiled.  The proposal-scoring logic,
 * gold/goods transfer, and AI accept/reject heuristics are unknown.  No
 * numbers below are trustworthy; they exist only as a placeholder shape and
 * are explicitly marked not yet decoded so they are never mistaken for verified facts.
 * Anchor for future work: the in-game diplomacy dialog driver that calls
 * func_057DC0 (caller not yet decoded; reachable via the page-0x0F Type-A thunk for 0x57DC0).
 * ============================================================================ */
#if 0  /* not yet decoded — proposal/AI-eval path not yet reverse-engineered */
int  treaty_propose(/* not yet decoded */);          /* not yet decoded: who calls treaty_set_state, and the accept/reject UI/AI */
int  ai_evaluate_treaty(/* not yet decoded */);      /* not yet decoded: AI scoring weights unknown */
void treaty_transfer_payment(/* not yet decoded */); /* not yet decoded: gold/goods exchange on a signed treaty */
#endif
