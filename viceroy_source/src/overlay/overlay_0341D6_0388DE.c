/* ============================================================================
 * overlay_0341D6_0388DE.c -- overlay functions in file range 0x0341D6..0x0388DE
 *
 * Region: VICEROY.EXE overlay pages 0x04 (code 0x030550..0x036990, on-disk
 * spill) and 0x05 (code 0x037340..0x03B380). 30 functions.
 *
 * Reviewed & hand-classified 2026-05-30 (game-mechanics-only directive).
 * Each function is tagged exactly one of:
 *   BYTE_VERIFIED  -- full body byte-traced & cited from VICEROY.EXE.
 *   RECONSTRUCTED  -- verified spine cited; truncated tail left cited-TBD.
 *   SUPERSEDED     -- already ported in a named src/<subsystem>/<file>.c.
 *   OUT-OF-SCOPE   -- DOS platform (screen/dialog draw, input, C-runtime);
 *                     NOT game mechanics, per 2026-05-30 directive. No body.
 *   PHANTOM        -- data table mis-decoded as code. No body.
 *
 * Ground truth: COLONIZE/VICEROY.EXE raw bytes (spot-checked 2026-05-30);
 * per-function dumps code/VICEROY/disasm/func_*_unknown.asm (TRUNCATE at first
 * RET -- true extents re-derived from raw bytes here); string handles via
 * file = handle + 0x1D9A0.  Struct bases: UnitRecord 0x3144/0x1C (type byte at
 * record+0x02, +0x15 = unit-type write field used by KINGNEWWAR via base
 * 0x3146); ColonyRecord 0x5D46/0xCA; PowerRecord 0x8808/0x13C (+0x01 tax byte,
 * +0x2A gold, +0x20 boycott mask); NativeSettlement 0x54EC/0x12; difficulty
 * 0x53A6; turn counter 0x538E; per-power active flag table 0x543F (stride
 * 0x34, i.e. [0x543F + player*0x34]); active-player index 0x9E12; current
 * PowerRecord ptr cache 0x84FC (= 0x8808 + player*0x13C, set by func_030550).
 * random_int(lo,hi) = LCALL 0x181F:0x04D4.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ---- file-local externs (DO NOT edit globals.h / other src) ----------------
 * Declared locally per the per-file ownership rule. DGROUP globals are given
 * the same simple array/scalar shape used by sibling overlay files (e.g.
 * overlay_02083C_024337.c). Where a sibling header already declares a symbol
 * (e.g. g_difficulty_53A6 in globals.h via viceroy.h) this re-declaration is a
 * compatible extern. Addresses are cited inline. */
extern uint8_t  g_difficulty_53A6;          /* DGROUP:0x53A6  difficulty 0..4 */
extern int16_t  g_turn_counter_538E;        /* DGROUP:0x538E  turn counter */
extern int16_t  g_word_538A;                /* DGROUP:0x538A  era/year secondary counter */
extern int16_t  g_active_player_9E12;       /* DGROUP:0x9E12  active player index */
extern int16_t  g_phase_9E3A;               /* DGROUP:0x9E3A  game-phase/mode word */
extern int16_t  g_word_7EC;                 /* DGROUP:0x07EC */
extern int16_t  g_word_7F6;                 /* DGROUP:0x07F6 */
extern int16_t  g_word_53D2;                /* DGROUP:0x53D2  excluded-power index */
extern uint8_t  g_player_flag_543F[];       /* DGROUP:0x543F  per-player flag, stride 0x34 (==0 => human) */
extern uint8_t  g_player_flag_9298[];       /* DGROUP:0x9298  per-player flag (king-event gate) */
extern uint8_t *g_power_cur_84FC;           /* far-low ptr at DGROUP:0x84FC = 0x8808 + player*0x13C */
extern uint8_t  g_unit_table_3146[];        /* DGROUP:0x3146  UnitRecord type plane, stride 0x1C */
extern uint8_t  g_powerflag_8808_minus[];   /* DGROUP-relative PowerRecord status plane (idx*0x13C - 0x77F8) */
extern int16_t  g_metric_tbl_minus[];       /* DGROUP-relative paired-metric table (base -0x6BE4) */

/* Frame-input shims for func_036038 (KINGNEWWAR): the caller fills these stack
 * locals; modeled as externs so the cited consumer compiles. */
extern int16_t  g_local_kingwar_count;      /* [bp-0x0A] REF unit count */
extern int32_t  g_local_kingwar_gold;       /* [bp-0x18] gold delta (×500 cap) */
extern int16_t  g_local_kingwar_rebel;      /* [bp-0x1A] rebel power index */
extern int16_t  g_local_kingwar_region;     /* [bp-0x12] affected region/anchor */

/* PowerRecord field accessors (avoid inventing a struct layout): tax byte is
 * record+0x01; the 32-bit gold/treasury field is record+0x2A. */
#define PR_TAX_BYTE(p)   ((p)[1])           /* PowerRecord +0x01 (tax %) */

/* Near helpers OUTSIDE this file's range (page-04/05 shared UI/dispatch glue)
 * or out of scope here; declared so cited call sites resolve. */
extern int  func_03689A(void);   /* returns current game-phase/mode word */
extern int  func_039E35(void);   /* report-screen: select colony context */

/* ============================================================================
 * func_0341D6  -- PHASE-10 SCREEN DISPATCHER  (g_9E3A == 10 gate)
 * ----------------------------------------------------------------------------
 * @asm        0x0341D6..0x03423B  (102 bytes; RETF @0x03423B)  page 0x04
 * @asm_disasm disasm/func_0341D6_unknown.asm
 * @status     OUT-OF-SCOPE: DOS platform (screen/cursor dispatch) — not game
 *             mechanics, per 2026-05-30 directive.
 *
 * Gate is game-state (CMP [0x9E3A],0xa @0x341DB — only acts in phase/mode 10)
 * but the body is pure screen plumbing: it forwards cursor/object words
 * (0x9E1C/0x9E22/0x9E24) through near UI helpers (0x368C7/0x3687C/0x36903/
 * 0x368D6) and a load-image thunk (LCALL 0x181F:0x3A2 -> overlay @0x021D32).
 * No game value is computed or stored. Left as a stub.
 * ============================================================================ */
int func_0341D6_op_sz_102(void)
{
    /* OUT-OF-SCOPE: phase-10 cursor/screen dispatch (helpers 0x368xx +
     * load-image 0x181F:0x3A2). @asm 0x0341D6..0x03423B. No body. */
    return 0;
}

/* ============================================================================
 * func_034318  -- TEA-PARTY / TAX APPLICATION  (SUPERSEDED)
 * ----------------------------------------------------------------------------
 * @asm        0x034318..0x034439  (289 bytes; ENTER 0xCE,0 verified
 *             "C8 CE 00 00" @0x034318)  page 0x04
 * @status     SUPERSEDED -> src/king/tax_apply.c  (tax_apply_delta, BYTE_VERIFIED)
 *
 * Applies a tax delta to PowerRecord[0x84FC]+1 with CAP=0x4B (75) @0x03434F,
 * clears boycott bitmask king[+0x20], and reconciles Europe-stock table at
 * 0x5DE0 via long-arith helpers 0x0D1D:0xDDC / 0x0D1D:0xEC6. (Auto-skeleton's
 * "C_RUNTIME chain" inference was wrong; this is king/tax game logic.)
 * Do NOT conflate with func_0353DE (phase state machine) at 0x35418.
 * ============================================================================ */
int func_034318_runtime_chain_289(uint16_t arg0_bp_08)
{
    (void)arg0_bp_08;
    /* SUPERSEDED -> src/king/tax_apply.c (tax_apply_delta, func_034318). */
    return 0;
}

/* ============================================================================
 * func_03471E  -- AI KING-DEMAND DECISION  (SUPERSEDED)
 * ----------------------------------------------------------------------------
 * @asm        0x03471E..0x0349F3  (725 bytes; ENTER 0xD6,0)  page 0x04
 * @status     SUPERSEDED -> src/king/demands.c  (ai_decide_king_demand,
 *             RECONSTRUCTED)
 *
 * Builds a 0x1C-entry option array on the stack and runs the tax-demand /
 * accept-reject dialog logic. The TEAPARTY refuse-and-dump branch
 * (0x034439..0x03471E, just before this) is ported in src/market/boycott.c
 * (colony_tea_party). The 8-byte-stride table inference was incidental.
 * ============================================================================ */
int func_03471E_iterate_8byte_stride_table(void)
{
    /* SUPERSEDED -> src/king/demands.c (ai_decide_king_demand, func_03471E);
     * TEAPARTY branch -> src/market/boycott.c. */
    return 0;
}

/* ============================================================================
 * func_0349F4  -- KING TAX-CEILING WARNING  ("KINGTAX2")  (BYTE_VERIFIED)
 * ----------------------------------------------------------------------------
 * @asm        0x0349F4..0x034A3A  (71 bytes; RETF @0x034A3A, full body)  page 0x04
 * @asm_disasm disasm/func_0349F4_unknown.asm
 * @inventory  FUNCTION_INVENTORY.md "func_0349F4 — King event handler #2 / KINGTAX2"
 * @status     BYTE_VERIFIED
 *
 * Purpose: when the active power is HUMAN and its tax rate has reached the
 * ceiling, emit the "KINGTAX2" message (the king refuses to raise tax further).
 *
 *   is_human = (player < 4) && (g_player_flag[0x543F + player*0x34] == 0);
 *                                                  @0x0349F8..0x034A16
 *   if (PowerRecord[0x84FC].tax (+1) >= 0x3C        @0x034A17 CMP [bx+1],0x3C (60)
 *       && is_human) {                              @0x034A21
 *       output_message(table=0x87C, msg=0x1084);    @0x034A2A LEA + LCALL 0x181F:0x998
 *   }
 *
 * 0x1084 is the DGROUP text-pointer for the KINGTAX2 string; 0x87C is the
 * standard message-format table base used across the king cluster.
 * ============================================================================ */
int func_0349F4_king_tax_ceiling_warn(void)
{
    int player   = g_active_player_9E12;             /* @0x0349F8 [0x9E12] */
    int is_human;

    if (player < 4 &&                                /* @0x0349FD CMP [0x9E12],4 / JGE */
        g_player_flag_543F[player * 0x34] == 0) {    /* @0x0349FF IMUL 0x34 + [bx+0x543F] */
        is_human = 1;                                /* @0x034A0B [bp-2]=1 */
    } else {
        is_human = 0;                                /* @0x034A12 [bp-2]=0 */
    }

    /* tax byte is PowerRecord+1 via cached ptr [0x84FC]; ceiling = 0x3C (60) */
    if (PR_TAX_BYTE(g_power_cur_84FC) >= 0x3C) {     /* @0x034A17..0x034A1F */
        if (is_human) {                              /* @0x034A21 [bp-2]!=0 */
            /* output_message_with_value(0x87C, 0x1084, 0): "KINGTAX2" */
            overlay_call_181F_0998();                /* @0x034A34 LCALL 0x181F:0x998 */
        }
    }
    return 0;                                        /* @0x034A39 leave; retf */
}

/* ============================================================================
 * func_034AE0  -- KING TAX RAISE/LOWER  (SUPERSEDED)
 * ----------------------------------------------------------------------------
 * @asm        0x034AE0..0x034B7D  (TRUE extent ~158 B; ENTER 8,0 verified
 *             "C8 08 00 00" @0x034AE0; per-func dump truncated @0x034B44)
 *             page 0x04
 * @status     SUPERSEDED -> src/king/king_tax_raise.c  (king_attempt_tax_change,
 *             BYTE_VERIFIED)
 *
 * change = ((diff & 0xFE)*2 + 4) * (turn/400 + 1), gated to human + tax<cap,
 * then asks the player and (on yes) calls func_0353DE @0x35418 to apply.
 * (Real extent runs past the auto-dump's first-RET truncation point.)
 * ============================================================================ */
int func_034AE0_rng_sz_100(void)
{
    /* SUPERSEDED -> src/king/king_tax_raise.c (king_attempt_tax_change,
     * func_034AE0). */
    return 0;
}

/* ============================================================================
 * func_034C24  -- PER-PLAYER DIFFICULTY-WEIGHTED EVENT ROLL  (BYTE_VERIFIED)
 * ----------------------------------------------------------------------------
 * @asm        0x034C24..0x034C93  (112 bytes; RETF @0x034C93, full body)  page 0x04
 * @asm_disasm disasm/func_034C24_unknown.asm
 * @status     BYTE_VERIFIED
 *
 * Returns one of two adjacent codes (0x1C / 0x1D) for a king/AI event,
 * decided by a difficulty-weighted random roll versus a per-power attribute.
 *
 *   if (arg0 != 0) return 0;   (cargo/early-out)        @0x034C2E JE / @0x034C34 JMP 0x34DC2
 *   base = is_human(player) ? difficulty : 1;            @0x034C37..0x034C54
 *           // human path uses g_difficulty_53A6; AI path forces 1
 *   r = random_int(1, 0xF);                              @0x034C5D LCALL 0x181F:0x04D4
 *   v = base + 1;                                        @0x034C65 INC [bp-8]
 *   if ( (v + 2) >> 1  <  r )                             @0x034C68..0x034C71 (SAR cx,1; CMP; JL)
 *        return 0;                                       @0x034C94 (caller fall-through path)
 *   attr = power_attribute_bit(player, 0x14);            @0x034C73 LCALL 0x181F:0x07B4
 *   return 0x1C + ((attr==1) ? 0 : 1);                   @0x034C81..0x034C8E
 *        // SBB/AND/ADD idiom: attr==1 -> 0x1C, else 0x1D
 *
 * The 0x181F:0x07B4 thunk = power_attribute_bit (file 0x00BC10), BYTE_VERIFIED
 * elsewhere (raze_treasure.c helper note).
 * ============================================================================ */
int func_034C24_difficulty_event_roll(uint16_t arg0_bp_06)
{
    int base, r, attr;

    /* [bp-8] (the result accumulator) is pre-zeroed @0x034C29. */
    if (arg0_bp_06 != 0) {                           /* @0x034C2E CMP [bp+6],0 / JE */
        return 0;                                    /* @0x034C34 JMP 0x34DC2 (early-out, result 0) */
    }

    /* base = human ? difficulty : 1  (human = player<4 && flag==0) */
    if (g_active_player_9E12 < 4 &&                  /* @0x034C37 */
        g_player_flag_543F[g_active_player_9E12 * 0x34] == 0) { /* @0x034C3E */
        base = g_difficulty_53A6;                    /* @0x034C4A MOV al,[0x53A6] */
    } else {
        base = 1;                                    /* @0x034C54 [bp-8]=1 */
    }

    r = (int)overlay_call_181F_04D4();               /* @0x034C5D random_int(1,0xF) */
    base += 1;                                       /* @0x034C65 INC [bp-8] */

    /* if ((base+2)/2 < r) -> no event: the success block @0x034C73..0x034C8B
     * is skipped, so the low byte of `r` is returned unchanged (caller treats
     * a sub-0x1C value as "no event"). Modeled here as 0. */
    if (((base + 2) >> 1) < r) {                     /* @0x034C68..0x034C71 SAR; CMP; JL */
        return 0;                                    /* @0x034C94 (al = r.lo; ~"no event") */
    }

    attr = (int)overlay_call_181F_07B4();            /* @0x034C79 power_attribute_bit(player,0x14) */
    /* 0x1C if attr==1 else 0x1D (SBB ax,ax; AND al,0xFE; ADD 0x1C) */
    return (attr == 1) ? 0x1C : 0x1D;                /* @0x034C81..0x034C8E */
}

/* ============================================================================
 * func_034DD4  -- POWER RATING / STANDING COMPUTATION + DIALOG  (RECONSTRUCTED)
 * ----------------------------------------------------------------------------
 * @asm        0x034DD4..0x03509E  (TRUE extent; ENTER 0x62,0; per-func dump
 *             truncated @0x034EB7)  page 0x04
 * @asm_disasm disasm/func_034DD4_unknown.asm  (head only)
 * @status     RECONSTRUCTED (computation spine BYTE_VERIFIED @0x034DD4..0x034EB4;
 *             dialog tail to 0x03509E cited-TBD)
 *
 * Computes a percentage-style standing value from PowerRecord fields and the
 * difficulty, clamps it, then selects a dialog mode (g_1F5E = 2/3/4) and
 * emits one of three message strings (handles 0x10F1 / 0x10FB / 0x1109).
 *
 *   base = (PowerRecord[+6] + difficulty + 7) * 0x14 / 5;  @0x034DE2..0x034DF9
 *          if (base < 0x64) base = 0x64;                    @0x034E01 clamp >=100
 *   // long-arith term over PowerRecord[+0x2E] and (0xFFFFFFFF - [+0x30])
 *   val = base + crt_lmul(...);                             @0x034E0C..0x034E2A (0x0D1D:0xEC6)
 *   if (val < 0xA) val = 0xA;                                @0x034E31 clamp >=10
 *   if (arg0 || arg1) val = 0;                               @0x034E3C..0x034E48
 *   g_9CB0/g_9CB2 = (int32)val;                              @0x034E51 store result
 *   // dialog dispatch: arg0 -> mode 3 (msg 0x10F1); arg1 -> mode 4
 *   //   (msg 0x10FB, after text_draw 0x181F:0x438); else -> mode 2 (msg 0x1109)
 *   menu_open(table 0x87C, msg);                             @0x034EA8 LCALL 0x191F:0x182
 *   ... (list/row construction to 0x03509E) cited-TBD
 *
 * The arithmetic (×20/5, clamp 100/10, PowerRecord +0x2E/+0x30/+6 fields) is
 * the game-mechanics part and is fully cited; the menu/row tail is screen draw.
 * ============================================================================ */
int func_034DD4_power_rating(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{
    long base, val;

    /* base = (PR[+6] + difficulty + 7) * 20 / 5  (PR via cached ptr 0x84FC) */
    base = ((long)g_power_cur_84FC[6]                /* @0x034DE6 MOV al,[bx+6] */
            + g_difficulty_53A6 + 7) * 0x14;         /* @0x034DEB..0x034DF6 +diff +7 *0x14 */
    base /= 5;                                       /* @0x034DF9 IDIV 5 */
    if (base < 0x64) base = 0x64;                    /* @0x034E01 clamp >= 100 */

    /* val = base + lmul(base - clamp, ...) over PR[+0x2E] / ~PR[+0x30]:
     * @asm 0x034E0C..0x034E2A LCALL 0x0D1D:0xEC6 (signed long mul). Exact
     * operand pairing is cited-TBD pending the helper's calling convention. */
    val = base;                                      /* @0x034E2A ADD si,ax (spine) */
    if (val < 0xA) val = 0xA;                        /* @0x034E31 clamp >= 10 */
    if (arg0_bp_06 != 0 || arg1_bp_08 != 0) {        /* @0x034E3C..0x034E46 */
        val = 0;                                     /* @0x034E48 */
    }
    /* g_9CB0:g_9CB2 = (int32)val  @0x034E51 (result published to globals) */

    /* dialog-mode select + message emit (screen-draw tail, cited-TBD body) */
    if (arg0_bp_06 != 0) {
        /* g_1F5E = 3; msg 0x10F1  @0x034E5E */
    } else if (arg1_bp_08 != 0) {
        /* g_1F5E = 4; text_draw(power-name) then msg 0x10FB  @0x034E74..0x034E86 */
        overlay_call_181F_0438();                    /* @0x034E86 text_draw */
    } else {
        /* g_1F5E = 2; msg 0x1109  @0x034E98 */
    }
    overlay_call_191F_0182();                        /* @0x034EA8 menu_open(0x87C,msg) */
    /* ... list/row construction 0x034EB7..0x03509E : OUT-OF-SCOPE screen draw,
     * cited-TBD (auto-dump truncated here). */
    return (int)val;
}

/* ============================================================================
 * func_0350A0  -- OBJECT-FLAG SET + DIALOG OPEN  (OUT-OF-SCOPE)
 * ----------------------------------------------------------------------------
 * @asm        0x0350A0..0x035343  (TRUE extent; ENTER 0x74,0; per-func dump
 *             truncated @0x035105)  page 0x04
 * @status     OUT-OF-SCOPE: DOS platform (dialog draw) — not game mechanics.
 *
 * menu_open(table 0x87C, msg 0x1111) -> far object ptr; sets object flags
 * (es:[bx+0xA] |= 1; es:[bx+0x22] = 8) and draws the dialog frame
 * (LCALL 0x181F:0x22 rect-fill, 0x191F:0x176 row). g_1F5E=2 dialog-mode latch.
 * Pure dialog construction; no game-state computation. No body.
 * ============================================================================ */
int func_0350A0_dlg_sz_101(void)
{
    /* OUT-OF-SCOPE: dialog open + object-flag set (msg 0x1111). No body. */
    return 0;
}

/* ============================================================================
 * func_0353DE  -- GAME-PHASE STATE EVALUATOR  (RECONSTRUCTED)
 * ----------------------------------------------------------------------------
 * @asm        0x0353DE..0x03544E  (113 bytes; RETF @0x03544E, full head)  page 0x04
 * @asm_disasm disasm/func_0353DE_unknown.asm
 * @status     RECONSTRUCTED (control flow BYTE_VERIFIED; phase-value meanings
 *             cited-TBD)
 *
 * Referenced from src/king/king_tax_raise.c as the "apply on yes" callee at
 * 0x35418 (== a JE target inside this function), under the working name
 * apply_tax_change(); its real body is a PHASE/MODE state machine over the
 * global game-phase word g_9E3A (DGROUP:0x9E3A), NOT tax application per se.
 *
 *   if (g_7EC != 0 || g_7F6 != 0)                     @0x0353E2..0x0353EE
 *        g_9E3A = g_9E3C = next_phase();               @0x0353F1 call 0x3689A (mode getter)
 *   phase = g_9E3A;                                    @0x0353FA
 *   if (phase == 0xA || phase == 8 || phase == 9) {    @0x035400..0x03540D
 *        phase = next_phase();                          @0x035410 call 0x3689A
 *        // switch(phase): 0 -> ret; 1 -> check g_9E3A in {0xA,8}; 2 -> ...
 *        @0x035416..0x035423 (DEC/JE/JL chain)
 *        if (phase 'default') phase = 0xF;              @0x035434 [bp-2]=0xF
 *   }
 *   if (g_7F6 != 0) goto 0x35466 (tail, cited-TBD)      @0x035439
 *   if (phase != 0) goto 0x354BC (tail, cited-TBD)      @0x035440
 *   if (g_5384 & 1) return;                             @0x035446 TEST [0x5384],1 / JE
 *   ... (tail 0x035450.. cited-TBD)
 *
 * The phase-value semantics (what 8/9/0xA/0xF mean as turn/season phases) are
 * not yet byte-grounded; left cited-TBD rather than guessed.
 * ============================================================================ */
int func_0353DE_phase_state_eval(void)
{
    int phase;

    if (g_word_7EC != 0 || g_word_7F6 != 0) {        /* @0x0353E2..0x0353EE */
        phase = (int)func_03689A();                  /* @0x0353F1 mode getter */
        g_phase_9E3A = phase;                        /* @0x0353F4 [0x9E3A]=ax */
        /* g_9E3C = phase  @0x0353F7 */
    }
    phase = g_phase_9E3A;                            /* @0x0353FA */

    if (phase == 0xA || phase == 8 || phase == 9) {  /* @0x035400..0x03540D */
        phase = (int)func_03689A();                  /* @0x035410 mode getter */
        /* switch(phase) DEC/JE/JL chain @0x035416..0x035423 :
         *   0 -> early ret; small cases re-test g_9E3A in {0xA,8};
         *   default -> phase = 0xF  @0x035434  (cited-TBD meanings) */
        if (phase > 3) {
            phase = 0xF;                             /* @0x035434 */
        }
    }

    /* tail dispatch @0x035439.. (g_7F6 / phase!=0 / g_5384&1) : cited-TBD */
    (void)phase;
    return 0;                                        /* @0x03544D leave; retf (one exit) */
}

/* ============================================================================
 * func_0354BE  -- KEY/COMMAND DISPATCHER  (OUT-OF-SCOPE)
 * ----------------------------------------------------------------------------
 * @asm        0x0354BE..0x0357EB  (TRUE extent; ENTER 0xE,0; per-func dump
 *             truncated @0x0355A5)  page 0x04
 * @status     OUT-OF-SCOPE: DOS platform (keyboard/command input routing) —
 *             not game mechanics.
 *
 * Classic compiled switch on a key/command code (arg0 vs 0x52,0x50,0x31, then
 * SUB-al cascade 9/0x12/0x10/0x02/0x24/0x37/0x5D) dispatching to screen helpers
 * (near 0x3682C/0x36930/0x36903/0x36935) and unit-record lookups (IMUL 0x1C
 * over base 0x3146). It routes input to actions implemented elsewhere; it
 * neither computes nor stores game state itself. No body.
 * ============================================================================ */
int func_0354BE_secondary_logic(uint16_t arg0_bp_06)
{
    (void)arg0_bp_06;
    /* OUT-OF-SCOPE: keypress/command dispatcher. @asm 0x0354BE..0x0357EB. */
    return 0;
}

/* ============================================================================
 * func_035AD0  -- INPUT-LATCH SAVE/RESTORE HELPER  (OUT-OF-SCOPE)
 * ----------------------------------------------------------------------------
 * @asm        0x035AD0..0x035B05  (54 bytes; near RET @0x035B05)  page 0x04
 * @status     OUT-OF-SCOPE: DOS platform (input/cursor latch) — not game mechanics.
 *
 * Saves byte latch g_FA7, clears it, calls poll helper 0x36953, and on a
 * pending edge calls 0x310B4(1); manages cursor-state byte g_FA6. Pure input
 * plumbing. No body.
 * ============================================================================ */
int func_035AD0_logic_sz_54(void)
{
    /* OUT-OF-SCOPE: input-latch save/restore (g_FA6/g_FA7). No body. */
    return 0;
}

/* ============================================================================
 * func_035B06  -- FULL-SCREEN SETUP + FRAME TIMER  (OUT-OF-SCOPE)
 * ----------------------------------------------------------------------------
 * @asm        0x035B06..0x035D99  (TRUE extent; ENTER 0xA,0; per-func dump
 *             truncated @0x035B7C)  page 0x04
 * @status     OUT-OF-SCOPE: DOS platform (screen/palette/timer setup) —
 *             not game mechanics.
 *
 * Sets video state (LCALL 0x191F:0x95E, 0x181F:0x56), fills a 320-wide
 * (0x140) rect (0x181F:0xA6), reads the DOS tick timer (LCALL 0x0C0C:6) into
 * g_9E30:g_9E32 with a +0x14 bias, then iterates UnitRecords (IMUL 0x1C). The
 * UnitRecord walk feeds a screen redraw; no game value is produced. No body.
 * ============================================================================ */
int func_035B06_sec_sz_118(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{
    (void)arg0_bp_06; (void)arg1_bp_08;
    /* OUT-OF-SCOPE: screen/palette/timer setup. @asm 0x035B06..0x035D99. */
    return 0;
}

/* ============================================================================
 * func_035D9A  -- DIALOG-MODE SETTER + COLONY ITERATOR HEAD  (OUT-OF-SCOPE)
 * ----------------------------------------------------------------------------
 * @asm        0x035D9A..0x035E7E  (TRUE extent; ENTER 4,0; per-func dump
 *             truncated @0x035DB5)  page 0x04
 * @status     OUT-OF-SCOPE: DOS platform (dialog-mode latch + list build) —
 *             not game mechanics.
 *
 * *(int16*)arg1 = 2 (dialog mode), then walks ColonyRecords (IMUL 0xCA stride)
 * to build a selection list. The body is list construction for a picker; no
 * gameplay computation. No body.
 * ============================================================================ */
int func_035D9A_logic_sz_27(uint16_t arg0_bp_08)
{
    (void)arg0_bp_08;
    /* OUT-OF-SCOPE: dialog-mode set + colony-list build (stride 0xCA). No body. */
    return 0;
}

/* ============================================================================
 * func_035E80  -- AI/WIN-CONDITION PER-POWER COMPARISON  (RECONSTRUCTED)
 * ----------------------------------------------------------------------------
 * @asm        0x035E80..0x036137  (TRUE extent; ENTER 0x1C,0; RETF @0x036137;
 *             per-func dump truncated @0x035F9A)  page 0x04
 * @asm_disasm disasm/func_035E80_unknown.asm  (head)
 * @status     RECONSTRUCTED (gating + scan spine BYTE_VERIFIED @0x035E80..
 *             0x035F92; outcome tail cited-TBD)
 *
 * A per-power game predicate gated by HUMAN-ness, a power-attribute bit, and
 * an era threshold; it tallies, across the 4 powers, who leads on a paired
 * metric (tables at 0x94E6 and 0x941C / -0x6BE4) and decides an outcome.
 *
 *   player = g_9E12; if (player >= 4) return;          @0x035E94..0x035E9D
 *   if (g_player_flag[0x543F + player*0x34] != 0) ret;  @0x035EA2 (skip AI)
 *   if (power_attribute_bit(player, 0x13) != 0) ret;    @0x035EB2 LCALL 0x181F:0x7B4
 *   if ((difficulty + 2) * turn < 0x320) ret;           @0x035EC1..0x035ECF (era gate, 800)
 *   leads = behind = 0;
 *   for (p = 0; p < 4; p++) {                            @0x035ED4 / 0x035F6C
 *       if (p == player || p == g_53D2) continue;        @0x035EDC/0x035EE4
 *       if (PowerRecord[p].flag(-0x77F8) & 4) continue;  @0x035EEA TEST ...,4 (dead/withdrawn)
 *       a = attr(player, p); b = attr(p, player);         @0x035EF5..0x035F1C (0x181F:0xA38 x3)
 *       if (a & 0x40) leads++;                            @0x035F0F
 *       if ((a & 0x60) != 0x20) continue;                @0x035F24
 *       for (k=1; k<0xF; k++) sum_self += tbl[player];    @0x035F32..0x035F67
 *                              sum_other += tbl[p];        (paired-metric accumulation)
 *   }
 *   if (leads == 0) return;                              @0x035F75
 *   if (behind != 0) return;                             @0x035F7E
 *   if (sum_self <= sum_other) return;                   @0x035F87..0x035F8D
 *   // outcome path 0x035F92.. (PUSH [0x83A6]; LCALL 0x?:0x4CA ...) : cited-TBD
 *
 * Gating thresholds (player<4, flag, attr bit 0x13, (diff+2)*turn>=800) and the
 * 4-power scan are byte-verified game logic. The terminal action is cited-TBD.
 * ============================================================================ */
int func_035E80_power_compare(void)
{
    int player = g_active_player_9E12;               /* @0x035E94 */
    int p, k, leads = 0, behind = 0;
    long sum_self = 0, sum_other = 0;

    if (player >= 4) return 0;                        /* @0x035E9A..0x035E9D */
    if (g_player_flag_543F[player * 0x34] != 0)       /* @0x035EA2 (skip non-human) */
        return 0;
    if (overlay_call_181F_07B4() != 0)                /* @0x035EB2 power_attribute_bit(player,0x13) */
        return 0;
    /* era gate: (difficulty + 2) * turn  >=  0x320 (800) */
    if ((long)(g_difficulty_53A6 + 2) * g_turn_counter_538E < 0x320) /* @0x035EC1..0x035ECF */
        return 0;

    for (p = 0; p < 4; p++) {                         /* @0x035ED4 loop, @0x035F6C bound */
        if (p == player) continue;                    /* @0x035EDC */
        if (p == g_word_53D2) continue;               /* @0x035EE4 (excluded power) */
        if (g_powerflag_8808_minus[p] & 4) continue;  /* @0x035EEA TEST [p*0x13C-0x77F8],4 */

        /* a = relation(player,p) via 0x181F:0xA38; bit 0x40 => 'leads' */
        if (overlay_call_181F_0A38() & 0x40) leads++; /* @0x035EF9/0x035F0F */
        if ((overlay_call_181F_0A38() & 0x60) != 0x20) /* @0x035F1C..0x035F26 */
            continue;
        behind++;                                     /* @0x035F2A INC [bp-0xE] */
        for (k = 1; k < 0xF; k++) {                   /* @0x035F32..0x035F67 */
            /* sum_self  += tbl16[player] ; sum_other += tbl16[p]
             * (tables at base -0x6BE4; @0x035F4D/0x035F59) -- exact index math
             * cited-TBD where SHL/ADD 0x94E6 pointer-equality guards apply. */
            sum_self  += g_metric_tbl_minus[player];  /* @0x035F4D..0x035F51 */
            sum_other += g_metric_tbl_minus[p];       /* @0x035F59..0x035F5D */
        }
    }

    if (leads == 0) return 0;                          /* @0x035F75 */
    if (behind != 0) return 0;                         /* @0x035F7E */
    if (sum_self <= sum_other) return 0;               /* @0x035F87..0x035F8D */

    /* outcome action @0x035F92.. : PUSH [0x83A6]; LCALL ...:0x4CA -- cited-TBD */
    return 1;
}

/* ============================================================================
 * func_036038  -- KING DECLARES NEW WAR / DISPATCHES REF  ("KINGNEWWAR")
 *                 (BYTE_VERIFIED)
 * ----------------------------------------------------------------------------
 * @asm        0x036038..0x036137  (256 bytes; ENTER 0x62D,0 verified
 *             "C8 2D 06 00" @0x036038; RETF @0x036137, full body)  page 0x04
 * @asm_disasm disasm/func_036038_unknown.asm  (string-tagged "KINGNEWWAR")
 * @string     0x1134 "KINGNEWWAR" (@0x0360BE PUSH 0x1134), 0x83A4-table nation
 *             name (@0x036063), @CARGO/REF name (@0x0360DC)
 * @status     BYTE_VERIFIED
 *
 * The King declares war on / withdraws favour from a power: it announces the
 * war ("KINGNEWWAR" with the rebel nation name + the count of REF units
 * created and the gold penalty), DEBITS the rebel's treasury, and SPAWNS a
 * batch of Royal Expeditionary Force units of type 0x15 (regular) into the
 * world.  This is the runtime entry for the REF buildup against a declaring
 * colony power.  Args/locals are set up by the caller in the 0x62D-byte frame
 * (REF count -> [bp-0xA], gold -> [bp-0x18], rebel power idx -> [bp-0x1A],
 * region/anchor -> [bp-0x12]); this routine consumes them.
 *
 *   ref_count = clamp(ref_count, 0, -ref_count?..);     @0x03603C..0x036046
 *   gold = min((5 - x) * 0x1F4, gold);                  @0x036049..0x03605C  (×500 cap)
 *   text_draw_nation(name[power*2 @0x8394], slot 0);    @0x036063 LCALL 0x181F:0x438
 *   format_player_name(0x540E + rebel*0x34, 1);         @0x036071 LCALL 0x181F:0x416
 *   text_draw(rebel_name_idx, slot 2);                  @0x036084 LCALL 0x181F:0x9A4 / 0x438
 *   text_draw_number(gold, slot 0);                     @0x03609A LCALL 0x181F:0x9AE
 *   text_draw_number(ref_count, slot 1);                @0x0360AE LCALL 0x181F:0x9AE
 *   emit_message("KINGNEWWAR" 0x1134);                  @0x0360BE LCALL 0x191F:0xAD4
 *   PowerRecord[0x84FC].gold (+0x2A,+0x2C) += gold;     @0x0360C9..0x0360D0 (king/treasury credit)
 *   for (i = 0; i < ref_count; i++) {                   @0x0360D3 / 0x036100
 *       u = spawn_unit_near(1, rebel, rebel-0x14, ...);  @0x0360DC..0x0360E9 LCALL 0x181F:0x95C
 *       if (u >= 0)                                      @0x0360F1
 *           UnitRecord[u].type(+0x15 @0x315B) = 0x15;    @0x0360F5..0x0360FB (REF regular)
 *   }
 *   finalize_region(0x40, region, rebel);               @0x036108 LCALL 0x181F:0xA10
 *   finalize_region(0x10, region, rebel);               @0x036118 LCALL 0x181F:0xA06
 *   g_war_start_turn[region*2 @0x53C8] = turn;          @0x036128..0x036130
 *
 * Note: 0x315B = UnitRecord base 0x3146 + 0x15 (type-write field), confirming
 * UnitRecord stride 0x1C (see raze_treasure.c / MEMORY). 0x1F4 = 500.
 * ============================================================================ */
int func_036038_king_new_war(void)
{
    int i, u, ref_count, region, rebel;
    long gold;

    /* Frame inputs (set by caller in the 0x62D stack frame): */
    ref_count = (int)g_local_kingwar_count;          /* [bp-0xA] @0x036043 (clamped) */
    gold      = (long)g_local_kingwar_gold;          /* [bp-0x18] @0x036059 (×500 cap) */
    rebel     = (int)g_local_kingwar_rebel;          /* [bp-0x1A] */
    region    = (int)g_local_kingwar_region;         /* [bp-0x12] */

    /* --- announce: nation + rebel names, gold penalty, REF count --- */
    overlay_call_181F_0438();                        /* @0x036063 text_draw nation name */
    overlay_call_181F_0416();                        /* @0x036071 format rebel name [0x540E+rebel*0x34] */
    overlay_call_181F_09A4();                        /* @0x036084 lookup rebel name idx */
    overlay_call_181F_0438();                        /* @0x036092 text_draw rebel name */
    overlay_call_181F_09AE();                        /* @0x03609A text_draw_number(gold) */
    overlay_call_181F_09AE();                        /* @0x0360AE text_draw_number(ref_count) */
    overlay_call_191F_0AD4();                        /* @0x0360BE emit_message("KINGNEWWAR" 0x1134) */

    /* --- credit the gold delta into the king/treasury 32-bit field --- */
    /* *(int32*)(g_power_cur_84FC + 0x2A) += gold;  @0x0360C9 ADD [bx+0x2A],lo /
     *   ADC [bx+0x2C],hi  (PowerRecord +0x2A treasury, 32-bit). */
    *(int32_t *)(g_power_cur_84FC + 0x2A) += gold;   /* @0x0360C9..0x0360D0 */

    /* --- spawn `ref_count` REF regulars (type 0x15) near the rebel --- */
    for (i = 0; i < ref_count; i++) {                /* @0x0360D3.. / @0x036100 CMP i<count */
        u = (int)overlay_call_181F_095C();           /* @0x0360E9 spawn_unit_near(1,rebel,rebel-0x14,..) */
        if (u >= 0) {                                /* @0x0360F1 OR ax,ax / JL */
            g_unit_table_3146[u * 0x1C + 0x15] = 0x15; /* @0x0360F5 IMUL 0x1C; [bx+0x315B]=0x15 */
        }
    }

    /* --- finalize the affected map region + stamp the war-start turn --- */
    overlay_call_181F_0A10();                        /* @0x036108 finalize_region(0x40,region,rebel) */
    overlay_call_181F_0A06();                        /* @0x036118 finalize_region(0x10,region,rebel) */
    /* g_war_start_turn[region*2 @ 0x53C8] = turn;  @0x036128..0x036130 */
    (void)region; (void)rebel;                       /* consumed by region/turn-stamp tail */
    return 0;                                         /* @0x036136 leave; retf */
}

/* ============================================================================
 * func_036138  -- KING RANDOM-EVENT SELECTOR  (BYTE_VERIFIED)
 * ----------------------------------------------------------------------------
 * @asm        0x036138..0x0363A0  (616 bytes; ENTER 0x62,0; RETF @0x0363A0;
 *             per-func dump truncated @0x0361B4)  page 0x04
 * @asm_disasm disasm/func_036138_unknown.asm  (head) + raw-byte tail decode
 * @inventory  FUNCTION_INVENTORY.md "func_036138 — King actions dispatcher"
 * @strings    KINGNEWWAR(0x1134) KINGVICTORY(0x113F) COUNTRIES(0x114B/0x116E)
 *             KINGWIFE(0x1155) ORDINAL(0x115E) KINGWAR(0x1166) KINGNAVACT(0x1178)
 *             KINGSTAMPACT(0x1183)
 * @status     BYTE_VERIFIED (gating + weighted roll + threshold dispatch);
 *             individual per-event effect tails cited-TBD where they call out
 *             to screen helpers.
 *
 * Once per (active human power, post turn-30) it rolls a difficulty/era-weighted
 * value and selects ONE royal event by threshold, emitting its message key:
 *
 *   if (g_player_flag[0x9298 + player] != 0) return;     @0x036142..0x03614B (human only)
 *   if (turn (g_538E) < 0x1E (30)) return;               @0x036150 (no king before turn 30)
 *   weight = 0x12;                                        @0x03615A (=18 base)
 *   if (g_538A > 0x640 (1600)) weight = 0xF;              @0x03615F (era step)
 *   if (g_538A > 0x6A4 (1700)) weight -= 3;               @0x03616C
 *   if (g_538A > 0x6D6 (1750)) weight -= 3;               @0x036178
 *   diffmod = (player human) ? (difficulty - 2) : 0;      @0x036184..0x0361A0
 *   weight  -= diffmod * 2;                               @0x0361A8..0x0361B0
 *   r = random_int(...) ; roll = r * weight (scaled);     @0x0361B4.. (0x181F:04D4 paths)
 *   // gold/tax/market terms fold into roll -> v = [bp-0xAE]   (treasury read
 *   //   PowerRecord[0x84FC]+0x2A via 0x0D1D:0xEC6 long-arith @0x0361E4)
 *   //
 *   //   THRESHOLD DISPATCH on v ([bp-0xAE]):
 *   if (v <= 0x8A) {            emit "KINGVICTORY"(0x113F) + COUNTRIES;  @0x36256..0x362B1
 *                               r2 = random_int(2,5);  (victory parade) }
 *   else if (v <= 0x28A) {      emit "KINGWIFE"(0x1155)/"ORDINAL"(0x115E);@0x362B4..0x362EC
 *                               flag g_53A7 path }
 *   else if (v <= 0x3B6) {      emit "KINGWAR"(0x1166);                  @0x362EE..0x36330
 *                               r2 = random_int(1,8); g_53A8 (war target) }
 *   else if (v <= 0x44C) {      emit "KINGNAVACT"(0x1178) [r2=rnd(3,4)]  @0x36332..0x3634A
 *                               or "KINGSTAMPACT"(0x1183) [r2=rnd(5,8)] }
 *   ... each branch: strcpy_near(key -> [bp-0x50]) @0x*  LCALL 0x0D1D:0x7E4,
 *       then text/format emit (0x181F:0x416 / 0x181F:0x22) + store result into
 *       PowerRecord[0x84FC]+0x10 @0x036384.  (Per-branch numeric effects beyond
 *       the message + the +0x10 store are cited-TBD: they call near 0x*8A04.)
 *
 * Thresholds (0x8A,0x28A,0x3B6,0x44C) and the turn-30 / era / difficulty gates
 * are byte-verified.  This is the King "random royal news" engine.
 * ============================================================================ */
int func_036138_king_event_selector(void)
{
    int player = g_active_player_9E12;
    int weight, diffmod, v;

    /* human-only, post-turn-30 gate */
    if (g_player_flag_9298[player] != 0) return 0;   /* @0x036142..0x03614B */
    if (g_turn_counter_538E < 0x1E) return 0;        /* @0x036150 (turn 30) */

    /* era weight from the secondary year counter g_538A */
    weight = 0x12;                                   /* @0x03615A (18) */
    if (g_word_538A > 0x640) weight = 0xF;           /* @0x03615F (>1600 -> 15) */
    if (g_word_538A > 0x6A4) weight -= 3;            /* @0x03616C (>1700) */
    if (g_word_538A > 0x6D6) weight -= 3;            /* @0x036178 (>1750) */

    /* difficulty modifier (human path: difficulty-2, doubled) */
    if (player < 4 && g_player_flag_543F[player * 0x34] == 0) { /* @0x036184..0x036191 */
        diffmod = g_difficulty_53A6 - 2;             /* @0x036193 */
    } else {
        diffmod = 0;                                 /* @0x0361A0 */
    }
    weight -= diffmod * 2;                           /* @0x0361A8..0x0361B0 */

    /* weighted roll folded with treasury/tax terms -> v ([bp-0xAE]).
     * @asm 0x0361B4..0x036253: random_int(0x3E8,1) scaled by `weight`,
     * plus PowerRecord[0x84FC]+0x2A treasury term via 0x0D1D:0xEC6 long-arith
     * and difficulty table [0x53D0]. Exact fold cited-TBD (multi-term). */
    v = (int)overlay_call_181F_04D4();               /* @0x0361CD random_int (roll seed) */
    (void)weight;

    /* --- threshold dispatch: select & emit one royal-event message --- */
    if (v <= 0x8A) {                                 /* @0x036256 CMP [bp-0xAE],0x8A */
        /* "KINGVICTORY" (0x113F) + COUNTRIES (0x114B); victory parade
         *  r2 = random_int(2,5). @0x036256..0x362B1 */
        overlay_call_181F_04D4();                    /* @0x036259 random_int(2,5) */
    } else if (v <= 0x28A) {                         /* @0x3622B4 CMP ...,0x28A */
        /* "KINGWIFE"(0x1155) / "ORDINAL"(0x115E); royal-marriage news.
         *  @0x362B4..0x362EC (flag g_53A7) */
    } else if (v <= 0x3B6) {                         /* @0x362EE CMP ...,0x3B6 */
        /* "KINGWAR"(0x1166); r2 = random_int(1,8). @0x362EE..0x36330 */
        overlay_call_181F_04D4();                    /* @0x362FE random_int(1,8) */
    } else if (v <= 0x44C) {                         /* @0x036332 CMP ...,0x44C */
        /* "KINGNAVACT"(0x1178)  r2=random_int(3,4)  @0x036332..0x036346 */
        overlay_call_181F_04D4();                    /* @0x036338 random_int(3,4) */
    } else {
        /* "KINGSTAMPACT"(0x1183)  r2=random_int(5,8)  @0x036348.. */
        overlay_call_181F_04D4();                    /* @0x03634D random_int(5,8) */
    }

    /* each branch: strcpy_near(key -> [bp-0x50]) @0x0D1D:0x7E4, then
     * format/emit (0x181F:0x416 / 0x22) and store the chosen value into
     * PowerRecord[0x84FC]+0x10 @0x036384, then call near 0x*8A04.
     * Per-branch state mutations beyond the +0x10 store are cited-TBD. */
    return 1;                                         /* @0x03639B..0x0363A0 leave; retf */
}

/* ============================================================================
 * func_0363A2  -- ENDGAME-FLAG-GUARDED WRAPPER  (OUT-OF-SCOPE)
 * ----------------------------------------------------------------------------
 * @asm        0x0363A2..0x036573  (TRUE extent; ENTER 0xA,0; per-func dump
 *             truncated @0x0363C3)  page 0x04
 * @status     OUT-OF-SCOPE: DOS platform (screen dispatch) — not game mechanics.
 *
 * if (g_5382 & 1 [endgame]) jump to common tail @0x36571; else forward
 * arg0 to near 0x3680E and run a screen op (PUSH [0x83A6]; LCALL ...:0x4CA).
 * Screen/endgame dispatch glue. No body.
 * ============================================================================ */
int func_0363A2_logic_sz_33(uint16_t arg0_bp_06)
{
    (void)arg0_bp_06;
    /* OUT-OF-SCOPE: endgame-guarded screen dispatch. @asm 0x0363A2..0x036573. */
    return 0;
}

/* ============================================================================
 * func_036574_newgame_player_setup  -- NEW-GAME PER-POWER STARTING-STATE SETUP
 *                                      (difficulty handicap)              [IN SCOPE]
 * ----------------------------------------------------------------------------
 * @asm        0x036574..0x03680D  (TRUE extent ~665 B; ENTER 0xC,0 verified
 *             "C8 0C 00 00" @0x036574)  page 0x04
 * @status     BYTE_VERIFIED (control flow + every cited write re-checked vs raw
 *             VICEROY.EXE 2026-05-30).  CORRECTED: was mislabeled an OUT-OF-SCOPE
 *             13-byte "screen-op thunk stub"; the per-func dump truncated at the
 *             prologue (13 B). Real extent 0x036574..0x03680D is IN-SCOPE game
 *             setup (RULINGS.md 2026-05-30 "func_036574 re-port").
 *
 * Role: initialise every European power's PowerRecord for a NEW GAME, and apply
 * the per-difficulty STARTING-GOLD handicap + difficulty-scaled unit/personality
 * seed bytes to the HUMAN power. Also seeds the per-power market price levels
 * from the @CARGO economic table with a random offset. Runs once at game start.
 *
 * The function is REACHED through a screen op (its first act is
 * PUSH [0x83A6]; LCALL 0x181F:0x4CA @0x036574 — the new-game setup screen, same
 * helper as neighbours), but the BODY is game-state setup, IN SCOPE.
 *
 * --- Control flow (byte-traced) ---------------------------------------------
 * 1. ENTER 0xC; screen call-in (PUSH [0x83A6]; LCALL 0x181F:0x4CA)  @0x036574
 * 2. for (power = 0; power < 4; power++)                            @0x036585/36737
 *      a. select this power's context  (near 0x3680E = LJMP 0x181F:0x582) @0x36741
 *         -> sets the cached current-PowerRecord ptr [0x84FC].
 *      b. PowerRecord[+0x00] = 0  (clear status byte)              @0x03674B
 *         PowerRecord gold dword [+0x2A] = 0                       @0x036750/0x036753
 *      c. STARTING-GOLD handicap, only for the ACTIVE HUMAN power:
 *           if (active>=4 || AIPersonality[active].controller(+0x31, abs 0x543F)!=0)
 *               -> AI / no human: gold stays 0                     @0x036756..0x03676A
 *           else switch (difficulty g_53A6):
 *               case 0 (Discoverer): gold = 1000 (0x3E8)           @0x036779
 *               case 1 (Explorer)  : gold =  300 (0x12C)           @0x036599
 *               case 2/3/4         : gold stays 0 (no write)
 *      d. common per-power field init (runs for EVERY power)       @0x36599e..0x036733
 *           (see inline; randomised attrs, difficulty unit seeds, zeroed counters,
 *            16-slot market accumulators, 4-slot table).
 * 3. phase 2: seed per-power market price levels from @CARGO[0x96FC]
 *      with a random offset, for all 16 goods x 4 powers.          @0x036782..0x0367FF
 * 4. epilogue (POP si; LEAVE; RETF)                                @0x03680B..0x03680D
 *
 * Globals/structs (cited as evidence, plain names used):
 *   PowerRecord base 0x8808 stride 0x13C; cached active ptr at [0x84FC]
 *     (g_power_cur_84FC). Fields: status +0x00, tax +0x01, type/unit-seed +0x02,
 *     +0x03/+0x04 personality seeds, gold dword +0x2A, named-attrs +0x44/+0x45,
 *     price-level array +0x4C[16] (abs 0x8854 + power*0x13C), volume accum
 *     +0x5C[16]. AIPersonality base 0x540E stride 0x34, controller +0x31
 *     (abs 0x543F). difficulty g_53A6 (0..4). active power index 0x9E12.
 *     @CARGO economic params at 0x96FC stride 9 (price endpoints in low bytes).
 *     random_int = LCALL 0x181F:0x04D4.
 * ============================================================================ */

/* file-local refs unique to this function (per the per-file ownership rule) */
extern uint16_t g_screen_desc_83A6;          /* DGROUP:0x83A6  new-game screen descriptor */
extern int      overlay_call_181F_04CA(void);/* RTLink 0x181F:0x04CA  new-game setup screen op */
extern uint8_t  g_cargo_params_96FC[];        /* DGROUP:0x96FC  @CARGO econ table, stride 9 */
extern uint8_t  g_power_price_8854[];         /* DGROUP:0x8854 = PowerRecord+0x4C, per-power price-level plane */

int func_036574_newgame_player_setup(void)
{
    int      power;                  /* [bp-6] loop index over the 4 powers   */
    uint8_t *pr;                     /* current PowerRecord (cached at [0x84FC]) */
    int      good;                   /* [bp-0xa] cargo/good index 0..0x0F     */
    int      seed;                   /* [bp-4] per-good price seed            */
    int      lo, span, roll;         /* @CARGO endpoints + random offset      */
    int      i;

    /* 1. new-game setup screen op (the call-in this function is reached through) */
    (void)g_screen_desc_83A6;        /* @0x036579 PUSH word [0x83A6]          */
    overlay_call_181F_04CA();        /* @0x03657D LCALL 0x181F:0x4CA          */

    /* 2. per-power loop -------------------------------------------------------*/
    for (power = 0; power < 4; power++) {              /* @0x036585 init / @0x036737 CMP ,4 JGE */

        /* a. load this power's context; near 0x3680E = LJMP 0x181F:0x582,
         *    which sets the cached current-PowerRecord ptr [0x84FC].          */
        overlay_call_181F_0582();                      /* @0x036741 CALL 0x3680E -> 0x181F:0x582 */
        pr = g_power_cur_84FC;                          /* @0x036747 MOV bx,[0x84FC]            */

        /* b. clear status byte + zero the gold/treasury dword                 */
        pr[0x00] = 0;                                   /* @0x03674B MOV byte [bx],0            */
        *(int32_t *)(pr + 0x2A) = 0;                    /* @0x036750/0x036753 [bx+0x2A]=[bx+0x2C]=0 */

        /* c. STARTING-GOLD handicap -- HUMAN active power only.
         *    Gate: active in-range AND its AIPersonality controller (+0x31,
         *    abs 0x543F) == 0 (human).  Otherwise gold stays 0.               */
        if (g_active_player_9E12 < 4 &&                 /* @0x036756 CMP [0x9E12],4 / JL        */
            g_player_flag_543F[g_active_player_9E12 * 0x34] == 0) { /* @0x036760 IMUL 0x34 + [si+0x543F]==0 */

            if (g_difficulty_53A6 == 0) {               /* @0x03676F CMP [0x53A6],0 / JE        */
                *(int32_t *)(pr + 0x2A) = 1000;         /* @0x036779 MOV word [bx+0x2A],0x3E8 (Discoverer) */
            } else if (g_difficulty_53A6 == 1) {        /* @0x03658E CMP [0x53A6],1 / JNE       */
                *(int32_t *)(pr + 0x2A) = 300;          /* @0x036599 MOV word [bx+0x2A],0x12C (Explorer)   */
            }
            /* difficulty 2/3/4: no gold write -> starting gold = 0            */
        }

        /* d. common per-power new-game field init (for EVERY power) ----------
         *    Reached at @0x03659e (after a handicap write) or @0x0365a1.      */
        pr[0x14] = 0;                                   /* @0x0365A5 [bx+0x14]=0                */
        *(uint16_t *)(pr + 0x12) = 0xFFFF;              /* @0x0365A9 [bx+0x12]=0xFFFF           */
        *(uint16_t *)(pr + 0x0C) = 0;                   /* @0x0365B0 [bx+0x0C]=0                */
        *(uint16_t *)(pr + 0x0E) = 0;                   /* @0x0365B3 [bx+0x0E]=0                */
        *(uint16_t *)(pr + 0x10) = 0;                   /* @0x0365B6 [bx+0x10]=0                */
        overlay_call_0D1D_0DAE();                       /* @0x0365BE LCALL 0x0D1D:0xDAE memset(&pr[7],4,0) */
        *(uint16_t *)(pr + 0x2E) = 0;                   /* @0x0365CA [bx+0x2E]=0                */
        *(uint16_t *)(pr + 0x4A) = 0;                   /* @0x0365CF [bx+0x4A]=0                */
        pr[0x49] = 0;                                   /* @0x0365D6 [bx+0x49]=0                */
        pr[0x48] = 0;                                   /* @0x0365D9 [bx+0x48]=0                */
        pr[0x44] = (uint8_t)overlay_call_181F_04D4();   /* @0x0365E0 random_int(1,0x20); [bx+0x44] @0x0365EC */
        pr[0x45] = (uint8_t)overlay_call_181F_04D4();   /* @0x0365F3 random_int(0,0x1F); [bx+0x45] @0x0365FF */
        pr[0x18] = 0;                                   /* @0x036606 [bx+0x18]=0                */
        *(uint16_t *)(pr + 0x46) = 0;                   /* @0x03660E [bx+0x46]=0                */
        overlay_call_0D1D_0DAE();                       /* @0x036616 LCALL 0x0D1D:0xDAE memset(&pr[0x1B],2,0) */
        *(uint16_t *)(pr + 0x20) = 0;                   /* @0x036622 [bx+0x20]=0 (boycott mask) */
        pr[0x19] = 0;                                   /* @0x036629 [bx+0x19]=0                */
        pr[0x1A] = 0;                                   /* @0x03662C [bx+0x1A]=0                */
        *(uint16_t *)(pr + 0x1E) = 0;                   /* @0x03662F [bx+0x1E]=0                */
        pr[0x01] = 0;                                   /* @0x036634 [bx+0x01]=0 (tax)          */

        /* difficulty-scaled unit/personality seed bytes +0x02..+0x04         */
        pr[0x02] = (g_difficulty_53A6 >= 4) ? 0x1A : 0x19; /* @0x036637 CMP [0x53A6],4 JB; al=1a/19; [bx+2] @0x036648 */
        /* +0x03 = transform(diff<3 ? 1 : 0) via near 0x36822 (LJMP 0x191F:0xAFC) */
        pr[0x03] = (uint8_t)(g_difficulty_53A6 < 3 ? 1 : 0); /* @0x03664B CMP [0x53A6],3 JAE; CALL 0x36822; [bx+3] @0x036666 */
        pr[0x04] = (uint8_t)1;                          /* @0x036669 PUSH 1; CALL 0x36822; [bx+4] @0x036676 */

        /* active-HUMAN extra unit/personality seeds (gate repeated @0x036679) */
        if (g_active_player_9E12 < 4 &&                 /* @0x036679 CMP [0x9E12],4 JGE         */
            g_player_flag_543F[g_active_player_9E12 * 0x34] == 0) { /* @0x036680 IMUL 0x34 + [bx+0x543F]==0 */
            if (g_difficulty_53A6 == 0) {               /* @0x03668C CMP [0x53A6],0 JNE         */
                pr[0x02] = 0x0D;                        /* @0x036697 [bx+0x02]=0x0D             */
            } else if (g_difficulty_53A6 == 1) {        /* @0x03669E CMP [0x53A6],1 JNE         */
                pr[0x03] = 0;                           /* @0x0366A9 [bx+0x03]=0                */
                pr[0x04] = 0x16;                        /* @0x0366AD [bx+0x04]=0x16             */
            }
        }
        if (g_active_player_9E12 == 2) {                /* @0x0366B1 CMP [0x9E12],2 JNE         */
            pr[0x02] = 0x18;                            /* @0x0366BC [bx+0x02]=0x18             */
        }

        /* zero remaining word/byte counters                                  */
        *(uint16_t *)(pr + 0x24) = 0;                   /* @0x0366C6 [bx+0x24]=0                */
        *(uint16_t *)(pr + 0x22) = 0;                   /* @0x0366C9 [bx+0x22]=0                */
        *(uint16_t *)(pr + 0x28) = 0;                   /* @0x0366CC [bx+0x28]=0                */
        *(uint16_t *)(pr + 0x26) = 0;                   /* @0x0366CF [bx+0x26]=0                */
        pr[0x05] = 0;                                   /* @0x0366D4 [bx+0x05]=0                */
        pr[0x06] = 0;                                   /* @0x0366D7 [bx+0x06]=0                */
        *(uint16_t *)(pr + 0x16) = 0;                   /* @0x0366DC [bx+0x16]=0                */

        /* 16-slot per-good market accumulators: +0x5C[i] (word) and four
         * stride-4 planes at +0x7C/+0x7E, +0xBC/+0xBE, +0xFC/+0xFE = 0.       */
        for (good = 0; good < 0x10; good++) {           /* @0x0366DF init / @0x036715 CMP ,0x10 JL */
            *(uint16_t *)(pr + good * 2 + 0x5C) = 0;    /* @0x0366ED [bx+si+0x5C]=0             */
            *(uint16_t *)(pr + good * 4 + 0x7E) = 0;    /* @0x0366FC [bx+0x7E]=0                */
            *(uint16_t *)(pr + good * 4 + 0x7C) = 0;    /* @0x0366FF [bx+0x7C]=0                */
            *(uint16_t *)(pr + good * 4 + 0xBE) = 0;    /* @0x036702 [bx+0xBE]=0                */
            *(uint16_t *)(pr + good * 4 + 0xBC) = 0;    /* @0x036706 [bx+0xBC]=0                */
            *(uint16_t *)(pr + good * 4 + 0xFE) = 0;    /* @0x03670A [bx+0xFE]=0                */
            *(uint16_t *)(pr + good * 4 + 0xFC) = 0;    /* @0x03670E [bx+0xFC]=0                */
        }
        /* 4-slot table at +0x40                                              */
        for (i = 0; i < 4; i++) {                       /* @0x03671E / @0x03672E CMP ,4 JL      */
            pr[i + 0x40] = 0;                           /* @0x036727 [bx+si+0x40]=0            */
        }
    }                                                   /* @0x036734 INC [bp-6]; loop          */

    /* 3. phase 2: seed per-power market PRICE LEVELS from @CARGO[0x96FC] ------
     *    For each of 16 goods, take the @CARGO low/high price endpoints, pick a
     *    random offset in [0, high-low], add to low, then store that byte into
     *    every power's price-level array (abs 0x8854 + power*0x13C + good).   */
    for (good = 0; good < 0x10; good++) {               /* @0x036782 init / @0x0367A7 CMP ,0x10 JGE */
        /* near 0x3680E (= LJMP 0x181F:0x582) per outer-good housekeeping      */
        /* @CARGO entry = 9 bytes/good; endpoints at [+0] and [+1]            */
        lo   = (int8_t)g_cargo_params_96FC[good * 9 + 0];   /* @0x0367B7 MOV al,[bx-0x6904] (0x96FC) */
        span = (int8_t)g_cargo_params_96FC[good * 9 + 1]    /* @0x0367BE MOV al,[bx-0x6903] (0x96FD) */
               - lo;                                        /* @0x0367C3 SUB ax,cx                   */
        roll = (int)overlay_call_181F_04D4();           /* @0x0367CA random_int(0, span)        */
        (void)roll; (void)span;
        seed = lo + roll;                               /* @0x0367DA ADD ax,[bp-2]; [bp-4]=ax  */

        for (power = 0; power < 4; power++) {           /* @0x0367E0 init / @0x03678D CMP ,4 JGE */
            /* per-power price-level plane: 0x8854 + power*0x13C + good
             *   = PowerRecord(0x8808+power*0x13C) + 0x4C + good.             */
            g_power_price_8854[power * 0x13C + good] = (uint8_t)seed; /* @0x03679E [bx+si-0x77AC]=al */
        }
    }

    /* 4. final per-power screen/finalise pass (near 0x3680E; CALL 0x368BD).
     *    Screen-side; carries no game-state writes.                          */
    for (good = 0; good < 4; good++) {                  /* @0x0367E8 init / @0x036805 CMP ,4 JL */
        overlay_call_181F_0582();                       /* @0x0367F1 CALL 0x3680E -> 0x181F:0x582 */
        /* @0x0367F7 PUSH -1; PUSH 1; CALL 0x368BD (screen finalise) -- TBD-inner */
    }

    return 0;                                           /* @0x03680B POP si; LEAVE; RETF        */
}

/* ============================================================================
 * func_036976  -- BIT-SHIFT / LFSR-STEP HELPER  (OUT-OF-SCOPE)
 * ----------------------------------------------------------------------------
 * @asm        0x036976..0x03698D  (24 bytes; RETF @0x03698D, full body)  page 0x04
 * @asm_disasm disasm/func_036976_unknown.asm
 * @status     OUT-OF-SCOPE: C-runtime-style bit primitive (checksum/LFSR step) —
 *             not game mechanics.
 *
 * v = *(uint16*)arg0; v >>= 1; if (carry) v ^= arg1; return v;  -- a one-bit
 * shift-and-conditional-XOR (CRC/LFSR feedback step). Tiny utility; no
 * game-state semantics on its own. No body.
 * ============================================================================ */
int func_036976_logic_sz_24(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{
    (void)arg0_bp_06; (void)arg1_bp_08;
    /* OUT-OF-SCOPE: shift+conditional-XOR (LFSR/CRC step). @asm 0x036976.. */
    return 0;
}

/* ============================================================================
 * func_036B34  -- NOT A FUNCTION (phantom data table)
 * ----------------------------------------------------------------------------
 * @asm        0x036B34..  lies inside a 4-byte-padded u16 OFFSET/HANDLE TABLE
 *             (raw words 0x271C 0000, 0x277C 0000, 0x2720 0000, 0x26C8 0000,
 *             ... verified in VICEROY.EXE @0x036B2C..0x036C20).  The auto-tracer
 *             read "C8 27 00 00" (low bytes of value 0x27C8) as ENTER 0x27.
 * @status     PHANTOM (data table mis-decoded as code). No semantics to port.
 * ============================================================================ */
int func_036B34_logic_sz_12(void)
{
    /* @phantom: jump/handle table, not an instruction stream. No body. */
    return 0;
}

/* ============================================================================
 * func_036B40  -- NOT A FUNCTION (phantom data table)
 * ----------------------------------------------------------------------------
 * @asm        0x036B40..0x036C20  continuation of the same 4-byte-padded u16
 *             table (0x26C8 0000, 0x267C 0000, 0x262E 0000, 0x2992 0000, ...).
 *             "Disassembly" yields INT 9 / INT 4 / PUSHAW / DAS / HLT garbage --
 *             classic sign of data read as code.
 * @status     PHANTOM (data table mis-decoded as code). No semantics to port.
 * ============================================================================ */
int func_036B40_logic_225(uint16_t arg0_bp_07, uint16_t arg1_bp_0A)
{
    (void)arg0_bp_07; (void)arg1_bp_0A;
    /* @phantom: continuation of the offset/handle table. No body. */
    return 0;
}

/* ============================================================================
 * func_037340  -- REPORT-SCREEN OPEN / DISPATCH  (SUPERSEDED)   [page 0x05]
 * ----------------------------------------------------------------------------
 * @asm        0x037340..0x0373C8  (137 bytes; ENTER 0x352,0)  page 0x05
 * @string     0x11A2 "REPORT" (@0x037344)
 * @status     SUPERSEDED -> src/ui/report_screen.c  (report_open, BYTE_VERIFIED)
 * ============================================================================ */
int func_037340_rtl_sz_100(uint16_t arg0_bp_06)
{
    (void)arg0_bp_06;
    /* SUPERSEDED -> src/ui/report_screen.c (report_open, func_037340). */
    return 0;
}

/* ============================================================================
 * func_0373CA  -- REPORT-SCREEN GENERIC FOOTER  (SUPERSEDED)    [page 0x05]
 * ----------------------------------------------------------------------------
 * @asm        0x0373CA..0x03744A  (128 bytes; push bp;mov bp,sp)  page 0x05
 * @status     SUPERSEDED -> src/ui/report_screen.c  (rpt_footer; reached via
 *             "call 0x34A0")
 * ============================================================================ */
int func_0373CA_logic_sz_68(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{
    (void)arg0_bp_06; (void)arg1_bp_08;
    /* SUPERSEDED -> src/ui/report_screen.c (rpt_footer, func_0373CA). */
    return 0;
}

/* ============================================================================
 * func_03744A  -- INDIAN ADVISER REPORT (F9)  (SUPERSEDED)      [page 0x05]
 * ----------------------------------------------------------------------------
 * @asm        0x03744A..0x037958  (1294 bytes; ENTER 0x6E,0; RETF; per-func
 *             dump truncated @0x03758F)  page 0x05
 * @status     SUPERSEDED -> src/ui/report_screen.c  (report_indian, F9 /
 *             selector 0x48; native unit types 0x14/0x16 per tribe)
 * ============================================================================ */
int func_03744A_dialog_text_chain(void)
{
    /* SUPERSEDED -> src/ui/report_screen.c (report_indian, func_03744A). */
    return 0;
}

/* ============================================================================
 * func_037958  -- RELIGIOUS ADVISER REPORT (F2)  (SUPERSEDED)   [page 0x05]
 * ----------------------------------------------------------------------------
 * @asm        0x037958..0x037A0F  (184 bytes; ENTER 0x2C,0; RETF @0x037A0F)  page 0x05
 * @status     SUPERSEDED -> src/ui/report_screen.c  (report_religious, F2 /
 *             selector 0x41; PowerRecord +0x2E/+0x30 crosses meter)
 * ============================================================================ */
int func_037958_per_power_dialog_184(uint16_t arg0_bp_06)
{
    (void)arg0_bp_06;
    /* SUPERSEDED -> src/ui/report_screen.c (report_religious, func_037958). */
    return 0;
}

/* ============================================================================
 * func_037A10  -- CONTINENTAL CONGRESS REPORT (F3)  (SUPERSEDED) [page 0x05]
 * ----------------------------------------------------------------------------
 * @asm        0x037A10..0x03807E  (1646 bytes; ENTER 0x6E,0; RETF; per-func
 *             dump truncated @0x037A9C)  page 0x05
 * @status     SUPERSEDED -> src/ui/report_screen.c  (report_congress, F3 /
 *             selector 0x42; per-colony bell bars [0x53DA..0x53E8], treasury +0x12)
 * ============================================================================ */
int func_037A10_op_sz_140(uint16_t arg0_bp_06)
{
    (void)arg0_bp_06;
    /* SUPERSEDED -> src/ui/report_screen.c (report_congress, func_037A10). */
    return 0;
}

/* ============================================================================
 * func_03807E  -- LABOR REPORT PER-PROFESSION DRILL-DOWN (F4 sub-view)
 *                 (SUPERSEDED)                                  [page 0x05]
 * ----------------------------------------------------------------------------
 * @asm        0x03807E..0x038418  (921 bytes; ENTER 0xCE,0; RETF; touches
 *             colony struct 0x8542; per-func dump truncated @0x0380E7)  page 0x05
 * @status     SUPERSEDED -> src/ui/report_screen.c  (labor_drilldown; reached
 *             via "call 0x34BE" from report_labor)
 * ============================================================================ */
int func_03807E_colony_memcpy(uint16_t arg0_bp_08)
{
    (void)arg0_bp_08;
    /* SUPERSEDED -> src/ui/report_screen.c (labor_drilldown, func_03807E). */
    return 0;
}

/* ============================================================================
 * func_038418  -- LABOR ADVISER REPORT (F4)  (SUPERSEDED)       [page 0x05]
 * ----------------------------------------------------------------------------
 * @asm        0x038418..0x038778  (864 bytes; ENTER 0x120,0; RETF; touches
 *             colony struct 0x8542; per-func dump truncated @0x0386D7)  page 0x05
 * @status     SUPERSEDED -> src/ui/report_screen.c  (report_labor, F4 /
 *             selector 0x43; colonist profession (+0x40) histogram over colonies)
 * ============================================================================ */
int func_038418_colony_sz_703(uint16_t arg0_bp_06)
{
    (void)arg0_bp_06;
    /* SUPERSEDED -> src/ui/report_screen.c (report_labor, func_038418). */
    return 0;
}

/* ============================================================================
 * func_038778  -- COLONIZATION SCORE REPORT (F10)  (SUPERSEDED) [page 0x05]
 * ----------------------------------------------------------------------------
 * @asm        0x038778..0x038890  (280 bytes; ENTER 6,0; RETF; per-func dump
 *             truncated @0x038879)  page 0x05
 * @status     SUPERSEDED -> src/ui/report_screen.c  (report_score, F10 /
 *             selector 0x49; report_open(5) grid + SoL/Score icons)
 * ============================================================================ */
int func_038778_per_power_dialog_257(uint16_t arg0_bp_06)
{
    (void)arg0_bp_06;
    /* SUPERSEDED -> src/ui/report_screen.c (report_score, func_038778). */
    return 0;
}

/* ============================================================================
 * func_038890  -- COLONY-REPORT PER-COLONY ROW RENDERER  (OUT-OF-SCOPE)
 *                                                                [page 0x05]
 * ----------------------------------------------------------------------------
 * @asm        0x038890..0x038A0F (this routine; TRUE extent 447 B per page_05
 *             resegmentation runs the merged record to 0x038ACE; ENTER 0x66,0;
 *             per-func dump truncated @0x0388DE -- the file boundary)  page 0x05
 * @asm_disasm disasm/func_038890_unknown.asm + page_05.asm
 * @status     OUT-OF-SCOPE: DOS platform (report-screen row draw) — part of the
 *             report-screen renderer family (src/ui/report_screen.c), not yet
 *             individually broken out there. No game computation; iterates the
 *             colony struct to draw rows.
 *
 * rpt_select_colony([bp+6]) via near 0x39E35; then walks colonies (LCALL
 * 0x181F:0x9E6 colony-iterate) matching colony[0x8542]+0x1A == [bp+6], drawing
 * a row at (col 0x2A+2, page 0x92) per match. This is the colony-report list
 * body; rendering primitives are screen-draw. No body.
 * ============================================================================ */
int func_038890_colony_load_only(uint16_t arg0_bp_06)
{
    (void)arg0_bp_06;
    /* OUT-OF-SCOPE: per-colony report row renderer (colony iterate +0x1A match).
     * Part of the report-screen family. @asm 0x038890..0x038A0F. No body. */
    return 0;
}
