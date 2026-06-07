/* ============================================================================
 *                  >>> BYTE_VERIFIED (control flow + globals) <<<
 *           >>> per-nation PERSONALITY WEIGHTS: TBD (overlay data) <<<
 * ----------------------------------------------------------------------------
 * driver.c -- AI turn driver: how a power's turn is selected and dispatched.
 *
 * SCOPE OF VERIFICATION
 *   Every global address, structure stride, and control-flow edge below was
 *   read from VICEROY.EXE (COLONIZE/VICEROY.EXE) via the re-segmented overlay
 *   disassembly (reverse_engineered/code/VICEROY/disasm_overlay_reseg/) and the
 *   Type-A thunk map (reverse_engineered/code/VICEROY/typeA_thunk_targets.json,
 *   tools/map_typeA_thunks.py). Cross-page far-calls are annotated with the
 *   resolving Type-A thunk.
 *
 *   The per-nation PERSONALITY WEIGHTS (aggression / expansion / trade bias,
 *   etc.) that bias the leaf decisions are NOT in this file and are marked TBD:
 *   they live in overlay/data tables that this pass did not decode. They are
 *   NOT invented here. (See docs/RULINGS.md 2026-05-28 (ai).)
 *
 * KEY FINDING (architecture)
 *   Colonization's AI is UNIT-DRIVEN, gated per-owner by the AIPersonality
 *   controller flag -- it is NOT a single tidy `for(nation){...}` leaf-caller.
 *   "Whose turn it is" is the global current_nation_index (DGROUP:0x5398); the
 *   per-owner controller flag (DGROUP:0x543F + owner*0x34, byte +0x00) decides
 *   AI vs human at each per-unit/per-colony step. The big AI leaves on other
 *   overlay pages are reached EXCLUSIVELY through Type-A far-thunks.
 *
 * @region          overlay
 * @verified_by     Hand-decompiled from VICEROY.EXE 2026-05-28 (overlay reseg
 *                  + Type-A thunk map). Supersedes the prior RECONSTRUCTED
 *                  (fabricated) driver.c.
 * @ref             reverse_engineered/code/VICEROY/typeA_thunk_targets.json
 * @ref             reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_07.asm
 * @ref             reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_06.asm
 * ============================================================================ */
#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * Byte-verified globals (DGROUP-relative; DS = DGROUP at run time)
 * ------------------------------------------------------------------------- */

/* DGROUP:0x5398 -- current_nation_index ("whose turn is being processed").
 * 123 literal-word refs in VICEROY.EXE; written 6 times (the turn-cycle and
 * menu paths). @asm read as `cmp al,[0x5398]` 0x03F6BF; `mov ax,[0x5398]`
 * 0x03ED... ; restored to the human index at @asm 0x03E9DB (see below). */
extern int16_t g_current_nation_index_5398;

/* DGROUP:0x5394 -- local/active (human) player index. Copied INTO 0x5398 at
 * new-game setup (@asm 0x0757F5: mov ax,[0x5398]; mov [0x5394],ax) and copied
 * BACK FROM 0x5394 into 0x5398 when control returns to the human
 * (@asm 0x03E9D8 mov ax,[0x5394]; 0x03E9DB mov [0x5398],ax). */
extern int16_t g_human_player_index_5394;

/* DGROUP:0x5396 -- secondary "view/selected" nation index, kept in step with
 * 0x5394/0x5398 (@asm 0x0757FB mov [0x5396],ax; then conditionally overridden
 * from 0x53A4 @asm 0x075805 mov ax,[0x53A4]; 0x075808 mov [0x5396],ax when
 * [0x53A4] >= 0). Exact role TBD; tracked here only because the setup path
 * writes it alongside the turn indices. */
extern int16_t g_view_nation_index_5396;

/* DGROUP:0x543F -- AIPersonality table base; stride 0x34 (52) bytes per nation.
 * Byte +0x00 = CONTROLLER FLAG. Observed values: 0 and 1 (1 set as a controller
 * mode @asm 0x03E0BB `mov byte [bx+0x543f],1`); new-game setup reads it as
 * `cmp [bx+0x543f],2` and `cmp [bx+0x543f],0` (@asm 0x075943 / 0x075957) to
 * classify player slots, so the field is a small enum, not a bare bool.
 *   stride binding @asm: `imul bx,<idx>,0x34` then `[bx+0x543f]`
 *   (e.g. 0x040F1B imul bx,[0x5394],0x34 ; 0x040F20 cmp [bx+0x543f],0).
 * 220 literal-word refs. The REMAINING 51 bytes of each record (the personality
 * weights) are TBD -- not decoded in this pass. */
extern uint8_t g_ai_personality_543F[/* nation */][0x34];

/* DGROUP:0x3144 -- UnitRecord table base; stride 0x1C (28). Field map per
 * docs/RULINGS.md 2026-05-28 (RESOLVED):
 *   +0x00 map_x  (@asm `mov al,[bx+0x3144]` @0x03ED0F; read WITH map_y at 0x3145
 *                 as an (x,y) pair -> NOT owner)
 *   +0x01 map_y  (@asm `mov al,[bx+0x3145]` @0x03ED18)
 *   +0x02 type   (@asm `[bx+0x3146]`)                e.g. 0x04E33A, switch keys
 *   +0x03 owner  (low nibble; @asm `mov al,[bx+0x3147]; and al,0xf` @0x03F6B9)
 *   stride binding @asm: `imul bx,<unit>,0x1c` then `[bx+0x3144+k]`.
 * Full field map in unit.h / RULINGS 2026-05-28. */
extern uint8_t g_units_3144[/* unit */][0x1C];

/* DGROUP:0x5382 -- turn/game mode flag word. Bit 0 tested on the
 * "AI-vs-human" branch (@asm 0x03E988 test byte [0x5382],1). Other bits used
 * elsewhere (e.g. 0x10 at 0x023663). Exact bit map TBD. */
extern uint16_t g_game_mode_flags_5382;

/* DGROUP:0x5381 -- companion flag byte; bit 0x80 = "AI turn pending / showing
 * AI" (@asm 0x03E9BC test byte [0x5381],0x80; cleared `and [0x5381],0x7f`
 * @asm 0x03E9D3 right before restoring 0x5398 from the human index). */
extern uint8_t g_ai_turn_flag_5381;

/* ----------------------------------------------------------------------------
 * Cross-page AI leaves and per-unit handlers (reached via Type-A far-thunks).
 * Each declaration cites the target FILE offset and the resolving thunk.
 * ------------------------------------------------------------------------- */

/* func_03ECF0 (page 0x07) -- per-unit AI evaluator: see unit_orders.c.
 * Reached via Type-A thunk 0x01C732 (0x181F:0x2142 -> page 0x07:0x0000).
 * Far-call args (cdecl, pushed R-to-L): (unit_index, tile_x, tile_y). */
extern int16_t ovly_ai_eval_unit_03ECF0(int16_t unit_index,
                                        int16_t arg_x, int16_t arg_y);

/* func_040E22 (page 0x08) -- per-unit ORDER processor: see unit_orders.c.
 * Reached via Type-A thunk 0x01BAAA (0x181F:0x14BA). Far-call arg: (unit_index).
 * Internally iterates the AIPersonality controller flag and far-calls
 * ovly_ai_eval_unit_03ECF0 (@asm 0x040EC7). */
extern int16_t ovly_unit_order_step_040E22(int16_t unit_index);

/* func_03E984 (page 0x06) -- DECLARE-INDEPENDENCE handler (210 B, 63 insns;
 * reseg page_06 header `size=210 terminal=page-end`). IDENTITY CORRECTED
 * 2026-05-30: this was modeled as a generic "AI turn-end restore", but its four
 * dialog message handles resolve (verified rule file_offset = handle + 0x1D9A0)
 * to the REVOLUTION-DECLARATION strings -- 0x1374=ALREADYREVOLUTION,
 * 0x1386=TOOTORY, 0x138E=MULTIREV, 0x1397=DECLARE -- matching the old
 * FUNCTION_INVENTORY.md "Declaration guard" row. It guards + confirms a player's
 * declaration of independence and, on confirmation, hands control to the human
 * (0x5398 <- 0x5394) to begin the war. NOT thunked from the overlay (entered via
 * the page-06 turn state machine / near-call jump table at 0x03EA06). Kept the
 * name ai_turn_end_restore() to avoid a cross-subsystem rename race; see the
 * report's ledger row. @asm 0x03E984.. (docs/RULINGS.md 2026-05-30 (ai-unit-eval).) */

/* Helpers/globals referenced below (purpose from call context + string xref;
 * semantics TBD where noted). The 0x181F/0x191F ones are RTLink thunk operands. */
extern uint16_t ovly_181F_0652(int16_t flag, int16_t msg_id);   /* dialog @asm 0x03E994 etc. */
extern void     ovly_181F_09AE(int16_t lo, int16_t hi, int16_t z); /* fmt value @asm 0x03E9AD */
extern void     ovly_191F_0AC8(int16_t nation, int16_t a, int16_t b); /* finalize @asm 0x03E9E6 */
extern void     ai_turn_end_tail_03EA06(void);  /* @asm 0x03EA06 ljmp 0x191F:0x356 (begin revolution) */
extern int16_t  g_counter_53D0;                 /* DGROUP:0x53D0 rebel-sentiment % (SoL); thr 50 */

/* ============================================================================
 * ai_turn_end_restore -- func_03E984 (page 0x06), file 0x03E984..0x03EA05
 *   [SEMANTIC NAME: declare_independence_handler -- see banner above]
 * ----------------------------------------------------------------------------
 * The player's "Declare Independence" action handler. It (1) refuses with
 * ALREADYREVOLUTION if a revolution is already in progress (0x5382 & 1); (2)
 * refuses with TOOTORY if rebel sentiment (0x53D0) is below 50%; (3) when the
 * "turn pending" flag (0x5381 & 0x80) is set, prompts MULTIREV and, on confirm,
 * clears the flag and RESTORES current_nation_index from the human index; then
 * (4) finalizes (0x191F:0xAC8) and shows the DECLARE confirmation, beginning the
 * revolution on answer == 2.
 *
 * This is the only place in the page-06 chain that writes 0x5398, and it writes
 * it FROM 0x5394 (human) -- confirming 0x5398 = "currently processing nation"
 * and 0x5394 = "the human player".
 * ============================================================================ */
void ai_turn_end_restore(void)
{
    /* @asm 0x03E988 test byte [0x5382],1 ; je 0x03E99E
     * When game-mode bit 0 is set (a revolution is already in progress), push
     * (1, msg=0x1374) to the dialog helper 0x181F:0x652 and return.
     * msg 0x1374 -> file 0x1ED14 = "ALREADYREVOLUTION" (verified rule
     * file_offset = handle + 0x1D9A0 against strings.json). This is the
     * double-declaration guard the old FUNCTION_INVENTORY.md row described. */
    if (g_game_mode_flags_5382 & 1) {
        /* @asm 0x03E98F push 1 ; push 0x1374 ; lcall 0x181F:0x652 ; leave; retf */
        ovly_181F_0652(/*flag*/ 1, /*msg_id*/ 0x1374);   /* "ALREADYREVOLUTION" */
        return;
    }

    /* @asm 0x03E99E cmp word [0x53D0],0x32 ; jge 0x03E9BC
     * 0x53D0 is the rebel-sentiment / Sons-of-Liberty percentage; threshold
     * 0x32 = 50. When sentiment < 50 the declaration is REFUSED: format the
     * value via 0x181F:0x9AE then show msg 0x1386 and return.
     * msg 0x1386 -> file 0x1ED26 = "TOOTORY" (too few rebels / too "Tory" to
     * declare independence yet). */
    if ((int16_t)g_counter_53D0 < 0x32) {
        ovly_181F_09AE(/*lo*/ g_counter_53D0, /*hi*/ 0, /*z*/ 0);   /* @asm 0x03E9AD */
        ovly_181F_0652(1, 0x1386);                                  /* "TOOTORY" */
        return;
    }

    /* @asm 0x03E9BC test byte [0x5381],0x80 ; je 0x03E9DE */
    if (g_ai_turn_flag_5381 & 0x80) {
        /* @asm 0x03E9C3 push 1 ; push 0x138E ; lcall 0x181F:0x652 ; dec ax
         * msg 0x138E -> file 0x1ED2E = "MULTIREV" (a second/other power is also
         * in revolt -- confirm prompt; proceed only if the answer == 1). */
        if (ovly_181F_0652(1, 0x138E) - 1 != 0) {     /* "MULTIREV" @asm 0x03E9D0 */
            return;                                    /* user/other answered != 1 */
        }
        /* @asm 0x03E9D3 and byte [0x5381],0x7F  -- clear "AI turn pending" */
        g_ai_turn_flag_5381 &= 0x7F;
        /* @asm 0x03E9D8 mov ax,[0x5394] ; 0x03E9DB mov [0x5398],ax
         * RESTORE: current_nation_index = human player index. */
        g_current_nation_index_5398 = g_human_player_index_5394;
    }

    /* @asm 0x03E9DE push [0x5398] ; push 0 ; push 0 ; lcall 0x191F:0xAC8
     * Finalize for the (now-human) current nation. 0x191F:0xAC8 is a Type-A
     * thunk; its overlay target is in typeA_thunk_targets.json. */
    ovly_191F_0AC8(g_current_nation_index_5398, 0, 0);   /* @asm 0x03E9E6 */

    /* @asm 0x03E9EE push 1 ; push 0x1397 ; lcall 0x181F:0x652 ; cmp ax,2
     * msg 0x1397 -> file 0x1ED37 = "DECLARE" (the final "Declare independence?"
     * confirmation). On answer == 2 (a "yes, and ..." option), tail-call the
     * page-06 jump-table stub at 0x03EA06 (ljmp 0x191F:0x356) that begins the
     * revolution proper. */
    if (ovly_181F_0652(1, 0x1397) == 2) {                /* "DECLARE" @asm 0x03E9FB */
        ai_turn_end_tail_03EA06();                       /* @asm 0x03EA00 push cs; call 0x03EA06 */
    }
}

/* ============================================================================
 * NOTES / TODO_VERIFY
 * ----------------------------------------------------------------------------
 *  - The OUTER "advance to next power and run its AI" loop is driven by the
 *    resident game state machine (it calls the page-01 master loop func_0246E2
 *    via Type-A thunk 0x01B6E0, which has NO in-overlay caller -> it is an
 *    overlay entry point). func_0246E2 polls BIOS keyboard (es:[0x40:0x17]) and
 *    timers (0x0C0C:6) and drives per-unit order steps. The exact place that
 *    increments 0x5398 across the AI powers was not isolated to a single clean
 *    `for` in this pass; the writes to 0x5398 are at @asm 0x023D52 (func_0235D6,
 *    menu/command dispatch, page 01), 0x03E9DB (restore, here), 0x070A74 /
 *    0x070BE1 (func_070A1A map-view cycling, page 19), 0x07436C / 0x07437A
 *    (func_07431E init/new-turn, page 1A). Pinning the canonical increment site
 *    is TBD.
 *  - Message-id offsets RESOLVED 2026-05-30 via the verified string rule
 *    (file_offset = handle + 0x1D9A0, strings.json): 0x1374=ALREADYREVOLUTION,
 *    0x1386=TOOTORY, 0x138E=MULTIREV, 0x1397=DECLARE -- func_03E984 is the
 *    declare-independence handler (see banner).
 *  - 0x53D0 = rebel-sentiment / Sons-of-Liberty percentage (threshold 50 gates
 *    the declaration); BYTE_VERIFIED from this function's `cmp [0x53d0],0x32`
 *    @asm 0x03E99E. (Earlier "turn/era counter" guess withdrawn.)
 *  - PERSONALITY WEIGHTS (the per-nation bias inputs to the leaves): TBD,
 *    overlay/data-resident. DO NOT invent.
 * ============================================================================ */
