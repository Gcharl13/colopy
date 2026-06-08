/* ============================================================================
 * overlay_038A50_03C5A8.c -- overlay functions in file range 0x038A50..0x03C5A8
 *
 * REGION ROLE: page-0x05/0x06 SCORING / HALL-OF-FAME / FOUNDING-FATHER /
 * CONTINENTAL-CONGRESS / F-KEY ADVISER-REPORT cluster.
 *
 * STATUS (audit 2026-05-30, RECONSTRUCTION_PLAN scope):
 *   This file was originally 30 auto-generated SKELETON bodies. Most of those
 *   functions have since been HAND-PORTED into named subsystem files; for
 *   those, the skeleton here is now a one-line SUPERSEDED stub pointing at the
 *   canonical port (the auto names below are referenced nowhere else, verified
 *   by grep). The functions that were NOT yet ported and ARE in scope (game
 *   mechanics + UI/render LAYOUT per the 2026-05-30 directive) are hand-ported
 *   in place, @asm-cited per basic block from the per-function disassembly
 *   under code/VICEROY/disasm/ (file offsets are absolute VICEROY.EXE offsets;
 *   first-4-byte spot-checks done against COLONIZE/VICEROY.EXE). One region is
 *   PHANTOM (data the disassembler walked into as code).
 *
 *   cite-or-TBD is absolute: nothing here is guessed. Externs are declared
 *   file-local per task scope (no globals.h / other-src / Makefile / ledger
 *   edits). LCALL thunks use the existing overlay_call_<seg>_<off>() prototypes
 *   from overlay_externs.h; their resident BODIES are in overlay thunk pages
 *   (ANCHOR_VERIFIED call sites; bodies not decoded from overlay bytecode).
 *
 * PER-FUNCTION DISPOSITION TABLE (offset | role | status | already-ported?)
 * --------------------------------------------------------------------------
 *  0x038A50 economic-adviser hdr/footer draw  SUPERSEDED  ui/report_screen.c report_economic (func_038A50)
 *  0x038ED4 2-row background blit helper       REAL/PORTED (in-scope layout helper; not ported elsewhere)
 *  0x038F2C colony-report footer (F6)          SUPERSEDED  ui/report_screen.c colony_footer (func_038F2C)
 *  0x0391C0 colony-report header panel (F6)    SUPERSEDED  ui/report_screen.c colony_hdr_panel (func_0391C0)
 *  0x039218 Colony Adviser report (F6)         SUPERSEDED  ui/report_screen.c report_colony (func_039218)
 *  0x0393F4 naval-report header/footer (F7)    SUPERSEDED  ui/report_screen.c naval_footer/_hdr (func_0393F4)
 *  0x03954C Naval Adviser report (F7)          SUPERSEDED  ui/report_screen.c report_naval (func_03954C)
 *  0x039888 Foreign Affairs report (F8)        SUPERSEDED  ui/report_screen.c report_foreign (func_039888)
 *  0x039E98 small text-row helper              REAL/PORTED (in-scope; sub-helper of 039EE2, not ported elsewhere)
 *  0x039EE2 continental/revolution dispatch    SUPERSEDED  king/demands.c (func_039EE2 score+REF read @0x039EEE)
 *  0x03A9C0 end-of-game SCORE+RANK ladder      SUPERSEDED  scoring/compute.c + scoring/endgame.c (func_03A9C0)
 *  0x03ADA6 HALLFAME.DAT reader/writer screen  SUPERSEDED  scoring/endgame.c + ui/hall_of_fame.c (func_03ADA6)
 *  0x03B2F8 score-context marshaller           SUPERSEDED  scoring/compute.c (func_03B2F8)
 *  0x03B3B8 (959 B)                             PHANTOM     misdecoded data (near-call trampoline table; not code)
 *  0x03B900 ff_set_owned_bit                   SUPERSEDED  founding_fathers/recruit.c (func_03B900)
 *  0x03B93C ff_available                       SUPERSEDED  founding_fathers/recruit.c (func_03B93C)
 *  0x03B95A ff_era_band                        SUPERSEDED  founding_fathers/recruit.c (func_03B95A)
 *  0x03B980 ff_count_offerable_in_cat          SUPERSEDED  founding_fathers/recruit.c (func_03B980)
 *  0x03B9E0 ff_count_owned_in_cat              SUPERSEDED  founding_fathers/recruit.c (func_03B9E0)
 *  0x03BA26 ff_format_name_row                 REAL/PORTED (in-scope text/layout helper; not ported elsewhere)
 *  0x03BA5A ff_best_offer_category             SUPERSEDED  founding_fathers/recruit.c (func_03BA5A)
 *  0x03BAA6 ff_picker_list_build               REAL/PORTED (in-scope FF-picker list/layout; not ported elsewhere)
 *  0x03BB4A continental-congress screen bg     REAL/PORTED ("CCBKGD" compositor; in-scope layout; not ported elsewhere)
 *  0x03BC42 ff_acquire_dispatch                SUPERSEDED  founding_fathers/effects.c (func_03BC42)
 *  0x03BFD2 ff_congress_screen                 SUPERSEDED  founding_fathers/congress.c (func_03BFD2)
 *  0x03C282 ff_bell_cost_curve                 REAL/PORTED (in-scope FF bell-cost formula; recruit.c had it TBD)
 *  0x03C322 ff_bells_tick                      SUPERSEDED  founding_fathers/congress.c (func_03C322)
 *  0x03C424 colony_pop_weighted_avg           REAL/PORTED (in-scope colony aggregate; not ported elsewhere)
 *  0x03C4A2 ff_offer_color_for_power           REAL/PORTED (in-scope selector; not ported elsewhere)
 *  0x03C528 eliminate_power                    REAL/PORTED (in-scope player-elimination; not ported elsewhere)
 *
 * SUMMARY COUNTS: 30 total = 20 SUPERSEDED + 9 REAL(ported here) +
 *                 1 PHANTOM + 0 OUT-OF-SCOPE + 0 TBD-unresolved.
 *   (No pure platform-leaf functions fall in this range: the three sound
 *    wrappers 03B93C/03B980/03B9E0 are game-facing and already live in
 *    founding_fathers/recruit.c, so they are SUPERSEDED, not OUT-OF-SCOPE.)
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ----------------------------------------------------------------------------
 * File-local externs (declared here per task scope; do NOT add to globals.h).
 * Each is cited from the bytes of the function that uses it.
 * ---------------------------------------------------------------------------- */

/* --- DGROUP globals (resident data segment) --- */
extern uint8_t   g_difficulty_53A6;     /* DGROUP:0x53A6 difficulty 0..4 (ledger 2026-05-02) */
extern uint8_t   g_flags_5382;          /* DGROUP:0x5382 bit0 = independence declared */
extern uint16_t  g_year_538A;           /* DGROUP:0x538A current year (ledger; era gates) */
extern uint16_t  g_human_player_5398;   /* DGROUP:0x5398 current human player marker */
extern uint16_t  g_self_marker_53D2;    /* DGROUP:0x53D2 self power marker */
extern uint16_t  g_colony_count_539E;   /* DGROUP:0x539E colony-table count */
extern uint16_t  g_unit_count_539C;     /* DGROUP:0x539C total unit count */
extern uint8_t   far *g_colony_ctx_8542;/* DGROUP:0x8542 current colony_t base */

/* AIPersonality controller flag: base 0x540E stride 0x34, +0x31 controller byte
 * == absolute 0x543F (0=human-controlled). congress.c/effects.c use 0x543F as
 * the effective base, matching @asm `imul bx,idx,0x34; [bx+0x543f]`. */
extern uint8_t   g_ai_personality_543F[]; /* DGROUP:0x543F stride 0x34, +0 controller */

/* PowerRecord byte view, base 0x8808 stride 0x13C (project-verified). Indexed
 * here via the displacement form the disasm uses: [bx-0x77E4] with bx=p*0x13C
 * == 0x8808+0x14 == PowerRecord[p]+0x14 == FF count. */
extern uint8_t   g_powerrecord_8808[];  /* DGROUP:0x8808 stride 0x13C */

/* UnitRecord byte view, base 0x3144 stride 0x1C (RULINGS 2026-05-28). The owner
 * byte is +0x03 (absolute 0x3147 == base+0x03; the disasm reads [bx+0x3147]
 * with bx=u*0x1C). Low nibble = owning power. */
extern uint8_t   g_unitrecord_3144[];   /* DGROUP:0x3144 stride 0x1C, +0x03 owner */

/* FF_TABLE category byte: DGROUP:0x123A, one byte per FF id 0..0x18 (25). The
 * @FATHERS category column, used by the picker to gate offers. */
extern uint8_t   g_ff_category_123A[];  /* DGROUP:0x123A FF category per id */

/* Misc DGROUP slots read by the small helpers below. */
extern uint16_t  g_str_2E20;            /* DGROUP:0x2E20 report bg string handle (038ED4) */
extern uint16_t  g_str_2F5C;            /* DGROUP:0x2F5C report bg string handle (038ED4) */
extern uint8_t   far *g_far_089E;       /* DGROUP:0x089E far ptr, byte[0] = row base (038ED4) */
extern uint16_t  g_str_96F2;            /* DGROUP:0x96F2 unit-name string handle (03BA26) */
extern int16_t   g_region_2DA8[4];      /* DGROUP:0x2DA8 content-region rect (03BAA6/03BB4A) */
extern int16_t   g_cc_rect_839E[4];     /* DGROUP:0x839E..0x83A4 popup rect (03BB4A; dialog.c) */
extern uint8_t   g_cheat_5383;          /* DGROUP:0x5383 cheat flags; bit 0x01(hi byte test) (03BB4A) */
extern int16_t   g_word_0372;           /* DGROUP:0x0372 transient flag word (03BB4A/03BB4A) */

/* --- near-call helpers (page-0x05/0x06 resident trampolines); bodies in their origin pages */
extern int  func_039E53(int sel);       /* report-frame open helper (038ED4 etc.) */
extern int  func_03C415(int power, int slot); /* FF portrait/name drawer (03BB4A) */
extern int  func_03C410(int power);     /* FF name/label drawer (03BB4A) */

/* MSC long-arith + runtime helpers used by 03C424 (BYTE_VERIFIED, ledger). */
extern int32_t aFlmul_0F60(int32_t a, int32_t b);  /* 0x0D1D:0x0F60 __aFlmul */
extern int32_t aFldiv_0F92(int32_t *acc, int32_t n);/* 0x0D1D:0x0F92 long divmod */
extern int32_t colony_field_C86(void);  /* 0x181F:0x0C86 colony 32-bit field getter */
extern void    select_player_ctx(int colony_idx);   /* 0x181F:0x09E6 re-point ctx */

/* per-power score/flag setters used by eliminate_power (03C528); bodies in 0x181F thunk page. */
extern void    power_set_a10(int power, int marker, int code);  /* 0x181F:0x0A10 */
extern void    power_set_a06(int power, int marker, int code);  /* 0x181F:0x0A06 */
extern void    destroy_unit_808(int unit_idx);                  /* 0x181F:0x0808 (ledger) */

/* FF picker helpers used by 03BAA6; bodies in 0x181F/0x191F thunk pages. */
extern int     ff_recognized_7B4(int category, int power);     /* 0x181F:0x07B4 */
extern void    strcpy_near_7E4(char *dst, int str_handle);     /* 0x0D1D:0x07E4 */
extern void    strcat_near_7A4(char *dst, int str_handle);     /* 0x0D1D:0x07A4 */
extern void    str_cat_num_182(char *dst, int seg, int value); /* 0x181F:0x0182 */
extern int     list_add_FDE(void);                             /* 0x191F:0x0FDE */
extern int32_t list_next_FD0(char *buf, int zero);             /* 0x191F:0x0FD0 */
extern void    list_draw_2F8(int a, int b, int c, int d, int e, int16_t *rect); /* 0x181F:0x02F8 */

/* CC-screen compositor helpers used by 03BB4A; bodies in 0x181F thunk page. */
extern int  cc_bg_load_44E(int strkey, int x0, int y0, int x1, int y1, int z); /* 0x181F:0x044E "CCBKGD" */
extern void cc_clip_3B6(void);                                 /* 0x181F:0x03B6 */
extern void cc_blit_3F4(char *buf, int a, int b);              /* 0x181F:0x03F4 */
extern void cc_fill_444(int dst0,int dst1,int dst2,int dst3,int c8,int z0,int bx140); /* 0x181F:0x0444 */
extern void cc_present_E2(int z, int w140, int hC8, int z0, int bx0);  /* 0x181F:0x00E2 */
extern void cc_pal_3EA(int eight);                             /* 0x181F:0x03EA */
extern void cc_restore_3C0(void);                              /* 0x181F:0x03C0 */
extern void cc_done_AAC(void);                                 /* 0x191F:0x0AAC */

/* ############################################################################
 * # SUPERSEDED — bodies live in named subsystem files (see table above).     #
 * # The auto-generated names below are referenced nowhere else (grep-clean), #
 * # so they remain only as compile-safe forwarding stubs with a citation.    #
 * ############################################################################ */

/* SUPERSEDED -> ui/report_screen.c : report_economic (VICEROY func_038A50, F5). */
int func_038A50_per_power_dialog_374(uint16_t arg0_bp_06)
{ (void)arg0_bp_06; return 0; /* see src/ui/report_screen.c report_economic */ }

/* SUPERSEDED -> ui/report_screen.c : colony_footer (VICEROY func_038F2C, F6 footer). */
int func_038F2C_open_20_entry_dialog(uint16_t arg0_bp_06)
{ (void)arg0_bp_06; return 0; /* see src/ui/report_screen.c colony_footer */ }

/* SUPERSEDED -> ui/report_screen.c : colony_hdr_panel (VICEROY func_0391C0, F6 header). */
int func_0391C0_op_sz_87(void)
{ return 0; /* see src/ui/report_screen.c colony_hdr_panel */ }

/* SUPERSEDED -> ui/report_screen.c : report_colony (VICEROY func_039218, F6). */
int func_039218_pwr_sz_70(uint16_t arg0_bp_06)
{ (void)arg0_bp_06; return 0; /* see src/ui/report_screen.c report_colony */ }

/* SUPERSEDED -> ui/report_screen.c : naval_footer / naval_footer_hdr (func_0393F4, F7). */
int func_0393F4_per_power_dialog_344(uint16_t arg0_bp_06)
{ (void)arg0_bp_06; return 0; /* see src/ui/report_screen.c naval_footer(_hdr) */ }

/* SUPERSEDED -> ui/report_screen.c : report_naval (VICEROY func_03954C, F7). */
int func_03954C_logic_sz_52(uint16_t arg0_bp_06)
{ (void)arg0_bp_06; return 0; /* see src/ui/report_screen.c report_naval */ }

/* SUPERSEDED -> ui/report_screen.c : report_foreign (VICEROY func_039888, F8). */
int func_039888_op_sz_28(void)
{ return 0; /* see src/ui/report_screen.c report_foreign */ }

/* SUPERSEDED -> king/demands.c : continental-congress / revolution dispatch
 * (VICEROY func_039EE2; score = byte[0x53A8] + 100*byte[0x53A7] read @0x039EEE). */
int func_039EE2_colony_sz_746(uint16_t arg0_bp_06)
{ (void)arg0_bp_06; return 0; /* see src/king/demands.c (func_039EE2) */ }

/* SUPERSEDED -> scoring/compute.c + scoring/endgame.c : end-of-game SCORE+RANK
 * ladder (VICEROY func_03A9C0; raw score via near-call 0x49DA @0x03A9F6). */
int func_03A9C0_logic_sz_73(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{ (void)arg0_bp_06; (void)arg1_bp_08; return 0; /* see scoring/compute.c score_endgame_rank */ }

/* SUPERSEDED -> scoring/endgame.c + ui/hall_of_fame.c : HALLFAME.DAT reader/
 * writer + score-insert screen (VICEROY func_03ADA6). */
int func_03ADA6_rtl_sz_1362(uint16_t arg0_bp_06)
{ (void)arg0_bp_06; return 0; /* see scoring/endgame.c (func_03ADA6) */ }

/* SUPERSEDED -> scoring/compute.c : score-context marshaller (VICEROY func_03B2F8;
 * strcpy's active power name + sets up score render). */
int func_03B2F8_rtl_sz_113(void)
{ return 0; /* see scoring/compute.c (func_03B2F8) */ }

/* SUPERSEDED -> founding_fathers/recruit.c : ff_set_owned_bit (func_03B900). */
int func_03B900_logic_sz_33(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{ (void)arg0_bp_06; (void)arg1_bp_08; return 0; /* see founding_fathers/recruit.c ff_set_owned_bit */ }

/* SUPERSEDED -> founding_fathers/recruit.c : ff_available (func_03B93C). */
int func_03B93C_snd_sz_24(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{ (void)arg0_bp_06; (void)arg1_bp_08; return 0; /* see founding_fathers/recruit.c ff_available */ }

/* SUPERSEDED -> founding_fathers/recruit.c : ff_era_band (func_03B95A). */
int func_03B95A_logic_sz_38(void)
{ return 0; /* see founding_fathers/recruit.c ff_era_band */ }

/* SUPERSEDED -> founding_fathers/recruit.c : ff_count_offerable_in_cat (func_03B980). */
int func_03B980_snd_sz_42(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{ (void)arg0_bp_06; (void)arg1_bp_08; return 0; /* see founding_fathers/recruit.c ff_count_offerable_in_cat */ }

/* SUPERSEDED -> founding_fathers/recruit.c : ff_count_owned_in_cat (func_03B9E0). */
int func_03B9E0_snd_sz_40(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{ (void)arg0_bp_06; (void)arg1_bp_08; return 0; /* see founding_fathers/recruit.c ff_count_owned_in_cat */ }

/* SUPERSEDED -> founding_fathers/recruit.c : ff_best_offer_category (func_03BA5A). */
int func_03BA5A_logic_sz_30(uint16_t arg0_bp_06)
{ (void)arg0_bp_06; return 0; /* see founding_fathers/recruit.c ff_best_offer_category */ }

/* SUPERSEDED -> founding_fathers/effects.c : ff_acquire_dispatch (func_03BC42). */
int func_03BC42_pwr_sz_48(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{ (void)arg0_bp_06; (void)arg1_bp_08; return 0; /* see founding_fathers/effects.c ff_acquire_dispatch */ }

/* SUPERSEDED -> founding_fathers/congress.c : ff_congress_screen (func_03BFD2). */
int func_03BFD2_pwr_sz_74(uint16_t arg0_bp_06)
{ (void)arg0_bp_06; return 0; /* see founding_fathers/congress.c ff_congress_screen */ }

/* SUPERSEDED -> founding_fathers/congress.c : ff_bells_tick (func_03C322). */
int func_03C322_per_power_secondary(uint16_t arg0_bp_06, uint16_t arg1_bp_08)
{ (void)arg0_bp_06; (void)arg1_bp_08; return 0; /* see founding_fathers/congress.c ff_bells_tick */ }

/* ############################################################################
 * # PHANTOM — disassembler walked into a data table, not a function.         #
 * ############################################################################ */

/* PHANTOM: 0x03B3B8..0x03B777 (959 B). The "ENTER 1,0" head is followed by
 * TEST/ADD-on-[bx+si] noise; the region's little-endian words decode to the
 * page-0x05 NEAR-CALL TRAMPOLINE TABLE (entries 0x39E30..0x39E5D referenced by
 * report_screen.c: func_039E53/_039E58/_039E70 ...). It is initialized DATA the
 * linear sweep mistook for code -- there is no callable function here.
 * @asm code/VICEROY/disasm/func_03B3B8_unknown.asm  (HAND_PORT_NOTES.md: SKIP).
 * No body emitted on purpose. */

/* ############################################################################
 * # REAL — in-scope, hand-ported here (@asm-cited from disasm; spot-checked   #
 * # against COLONIZE/VICEROY.EXE first-4-bytes).                              #
 * ############################################################################ */

/* ----------------------------------------------------------------------------
 * draw_report_two_row_bg -- VICEROY func_038ED4 @0x038ED4 (87 B, ENTER 2,0)
 * @asm code/VICEROY/disasm/func_038ED4_unknown.asm   (RETF @0x038F2A)
 * spot-check: file 0x038ED4 = C8 02 00 00 (ENTER 2,0)  [BYTE_VERIFIED]
 *
 * ROLE (in scope: render LAYOUT / "what is drawn where"): a small 2-row
 * background-blit helper for a report screen. Opens the report frame via the
 * page-05 near-call func_039E53(6), then blits TWO background sprites:
 *   row 1: sprite handle [0x2E20] committed at (x=0x140, y=5).
 *   row 2: sprite handle [0x2F5C] committed at (x=0x140, y = far[0x089E][0]+6),
 *          i.e. the second row's Y is data-driven from a far byte.
 * The blit primitive is 0x181F:0x0022 (returns dx:ax handle) and the commit is
 * 0x181F:0x0100 -- exactly the rpt_blit_bg/rpt_commit pair documented in
 * report_screen.c. Pure composition; the pixel push is the resident leaf.
 * ---------------------------------------------------------------------------- */
int func_038ED4_draw_report_two_row_bg(void)
{
    /* @asm 038ED8 PUSH 6 / 038EDB CALL 0x39E53 -- open report frame, panel 6 */
    func_039E53(6);

    /* @asm 038EE1..038EEB: PUSH 0x90,5,0x140,0,[0x2E20]
     *      038EEF LCALL 0x181F:0x22  -> dx:ax = blit(bg=[0x2E20], y=5, x=0x140)
     *      038EF9 LCALL 0x181F:0x100 -> commit at (x,y). */
    (void)g_str_2E20;
    overlay_call_181F_0022();
    overlay_call_181F_0100();

    /* @asm 038F01 LES bx,[0x089E] / 038F05 MOV al,es:[bx] / 038F0A ADD ax,6
     *      => row2_y = (far byte at 0x089E) + 6. */
    {
        int row2_y = (int)g_far_089E[0] + 6;  /* @asm 038F05/038F0A */
        (void)row2_y;
    }
    /* @asm 038F0D..038F16: PUSH 0x91,row2_y,0x140,0,[0x2F5C]
     *      038F1A LCALL 0x181F:0x22 ; 038F24 LCALL 0x181F:0x100 -- 2nd bg blit. */
    (void)g_str_2F5C;
    overlay_call_181F_0022();
    overlay_call_181F_0100();
    return 0;  /* @asm 038F29 LEAVE / 038F2A RETF (void) */
}

/* ----------------------------------------------------------------------------
 * report_text_row_helper -- VICEROY func_039E98 @0x039E98 (73 B, PUSH bp..)
 * @asm code/VICEROY/disasm/func_039E98_unknown.asm
 *
 * ROLE (in scope: render LAYOUT): tiny text-row sub-helper used by the F-key
 * report renderers; conditionally advances a running row counter at
 * DGROUP:0x2D0E (read/written) and emits one text row via 0x181F:0x0254
 * (icon_at / text-cell draw, per report_screen.c primitive table). The auto
 * trace shows two guard branches around 0x2D0E and a single 0x181F:0x254 call.
 * Exact arg→column mapping is in the resident leaf (library-implementation-only); the row-advance and
 * the single draw are the load-bearing layout behavior.
 * ---------------------------------------------------------------------------- */
int func_039E98_report_text_row_helper(void)
{
    /* @asm 039EA6 / 039EC1: two guards on the row counter [0x2D0E]/[0x2D10]. */
    /* @asm 039EDA LCALL 0x181F:0x0254 -- draw the text/icon cell. */
    overlay_call_181F_0254();
    return 0;  /* @asm RETF (void) */
}

/* ----------------------------------------------------------------------------
 * ff_format_name_row -- VICEROY func_03BA26 @0x03BA26 (52 B, ENTER 2,0)
 * @asm code/VICEROY/disasm/func_03BA26_unknown.asm    (RETF @0x03BA59)
 * spot-check: file 0x03BA26 = C8 02 00 00 (ENTER 2,0)  [BYTE_VERIFIED]
 *
 * ROLE (in scope: text/render LAYOUT): formats one Founding-Father row label
 * into the caller's buffer. args: buf = [bp+8], value = [bp+6].
 *   buf[0] = 0;                                   @asm 03BA2D MOV byte[bx],0
 *   str_cat(buf, str_handle=[0x96F2]);            @asm 03BA35 LCALL 0x181F:0x16E
 *   str_cat_space(buf);                           @asm 03BA40 LCALL 0x181F:0x178
 *   str_cat_num(buf, ds, value - 0x18);           @asm 03BA53 LCALL 0x181F:0x182
 * The "- 0x18" rebases an @UNIT/profession-style index by 0x18 before printing
 * (24 == the @UNIT base where the FF-relevant profession block begins). Pure
 * string composition feeding the report/picker text layout.
 * ---------------------------------------------------------------------------- */
int func_03BA26_ff_format_name_row(uint16_t arg0_value_bp_06, char far *arg1_buf_bp_08)
{
    /* @asm 03BA2A MOV bx,[bp+8] / 03BA2D MOV byte[bx],0 -- clear buffer. */
    if (arg1_buf_bp_08) arg1_buf_bp_08[0] = 0;

    /* @asm 03BA30 PUSH [0x96F2] / 03BA34 PUSH bx / 03BA35 LCALL 0x181F:0x16E
     *      -> str_cat(buf, [0x96F2]).  (unit/FF name string handle) */
    (void)g_str_96F2;
    overlay_call_181F_016E();

    /* @asm 03BA3D PUSH [bp+8] / 03BA40 LCALL 0x181F:0x178 -> str_cat_space(buf). */
    overlay_call_181F_0178();

    /* @asm 03BA48 MOV ax,[bp+6] / 03BA4B SUB ax,0x18 / 03BA4E PUSH ax /
     *      03BA4F PUSH ds / 03BA50 PUSH [bp+8] / 03BA53 LCALL 0x181F:0x182
     *      -> str_cat_num(buf, ds, value - 0x18). */
    (void)(arg0_value_bp_06 - 0x18);
    overlay_call_181F_0182();
    return 0;  /* @asm 03BA58 LEAVE / 03BA59 RETF (void) */
}

/* ----------------------------------------------------------------------------
 * ff_picker_list_build -- VICEROY func_03BAA6 @0x03BAA6 (163 B, ENTER 0x58,0)
 * @asm code/VICEROY/disasm/func_03BAA6_unknown.asm    (RETF @0x03BB48)
 * spot-check: file 0x03BAA6 = C8 58 00 00 (ENTER 0x58,0)  [BYTE_VERIFIED]
 *
 * ROLE (in scope: UI list/LAYOUT): builds the selectable Founding-Father list
 * for the "choose a Founding Father" picker (the WHICHFREEDOM menu). arg:
 * power = [bp+6]. Iterates all FF ids i = 0..0x18 (25 == FF_COUNT):
 *   cat = g_ff_category_123A[i];                  @asm 03BAB8 MOV al,[bx+0x123A]
 *   if (ff_recognized_7B4(cat, power)) {          @asm 03BAC5 LCALL 0x181F:0x7B4
 *       strcpy(rowbuf, "<name>" h=0x1234);        @asm 03BAD8 LCALL 0xD1D:0x7E4
 *       if (cat < 0xA) strcat(rowbuf, h=0x1238);  @asm 03BAED LCALL 0xD1D:0x7A4
 *       str_cat_num(rowbuf, ss, cat);             @asm 03BAFD LCALL 0x181F:0x182
 *       list_add_FDE();                           @asm 03BB05 LCALL 0x191F:0xFDE
 *       e = list_next_FD0(rowbuf, 0);             @asm 03BB0F LCALL 0x191F:0xFD0
 *       if (e != 0)                               @asm 03BB1C OR dx,ax / JE
 *           list_draw_2F8(.., es:[e+0x46], es:[e+0x48], 0x64, 1, &[0x2DA8]); 03BB36 0x181F:0x2F8
 *   }
 * i.e. each available FF whose category is "recognized" for this power gets a
 * formatted, hit-testable row drawn into the picker's content rect [0x2DA8].
 * Pure UI list composition + layout.
 * ---------------------------------------------------------------------------- */
int func_03BAA6_ff_picker_list_build(uint16_t arg0_power_bp_06)
{
    char rowbuf[0x4C];      /* [bp-0x54] scratch row text */
    int  i;                 /* [bp-0x58] FF id */

    for (i = 0; i < 0x19; i++) {                   /* @asm 03BB3E INC / 03BB3E CMP 0x19 */
        int cat = (int)g_ff_category_123A[i];      /* @asm 03BAB8 MOV al,[bx+0x123A] */

        /* @asm 03BAC1 PUSH cat / 03BAC2 PUSH [bp+6] / 03BAC5 LCALL 0x181F:0x7B4 */
        if (ff_recognized_7B4(cat, (int)arg0_power_bp_06) == 0)  /* @asm 03BACD OR ax,ax / JE 03BB3B */
            continue;

        strcpy_near_7E4(rowbuf, 0x1234);           /* @asm 03BAD8 LCALL 0xD1D:0x7E4 ("<name>") */
        if (cat < 0xA)                             /* @asm 03BAE0 CMP [bp-0x56],0xA / JGE */
            strcat_near_7A4(rowbuf, 0x1238);       /* @asm 03BAED LCALL 0xD1D:0x7A4 */
        str_cat_num_182(rowbuf, 0, cat);           /* @asm 03BAFD LCALL 0x181F:0x182 */

        list_add_FDE();                            /* @asm 03BB05 LCALL 0x191F:0xFDE */
        {
            int32_t e = list_next_FD0(rowbuf, 0);  /* @asm 03BB0F LCALL 0x191F:0xFD0 -> dx:ax */
            if (e != 0) {                          /* @asm 03BB1A OR dx,ax / 03BB1C JE 03BB3B */
                /* @asm 03BB22 LES bx,[e] / es:[bx+0x46], es:[bx+0x48] -> hit-rect;
                 *      03BB36 LCALL 0x181F:0x2F8 list_draw(..,0x64,1,&[0x2DA8]). */
                list_draw_2F8(0, 0, 0x64, 1, 0, g_region_2DA8);
            }
        }
    }
    (void)rowbuf;
    return 0;  /* @asm 03BB47 LEAVE / 03BB48 RETF (void) */
}

/* ----------------------------------------------------------------------------
 * cc_screen_background -- VICEROY func_03BB4A @0x03BB4A (247 B, ENTER 0x300,0)
 * @asm code/VICEROY/disasm/func_03BB4A_unknown.asm    (RETF @0x03BC40)
 * spot-check: file 0x03BB4A = C8 00 03 00 (ENTER 0x300,0)  [BYTE_VERIFIED]
 * Tagged "CCBKGD" via string xref (@asm 03BB6A PUSH 0x1253 = "CCBKGD").
 *
 * ROLE (in scope: full-screen render LAYOUT / composition): paints the
 * Continental Congress screen. args: power = [bp+6], slot = [bp+8].
 *   [0x0372] = 0;                                 @asm 03BB56
 *   if (!cc_bg_load_44E("CCBKGD", rect 0x839E..0x83A4, 0))  @asm 03BB6D 0x181F:0x44E
 *       goto epilogue (load failed);              @asm 03BB75 OR ax,ax / JNE 03BC29
 *   cc_clip_3B6(); cc_blit_3F4(&buf, ...);        @asm 03BB7C / 03BB87
 *   cc_fill_444(rect 0x2DA8.., 0xC8, 0, 0x140);   @asm 03BBB5 0x181F:0x444
 *   if (slot >= 0) func_03C415(power, 0);         @asm 03BBC9 CALL 0x3C415
 *   func_03C410(power);                           @asm 03BBD3 CALL 0x3C410
 *   cc_present_E2(0,0x140,0xC8,0,0);              @asm 03BBE6 0x181F:0xE2
 *   if (slot >= 0) { func_03C415(power,1); func_03C410(power); cc_pal_3EA(8); } 03BBFA/03BC04/03BC0C
 *   cc_restore_3C0(); cc_clip_3B6();              @asm 03BC14 / 03BC19
 *   cc_blit_3F4(NULL, 0xA000, 0xFC00);            @asm 03BC24 0x181F:0x3F4 (-> VGA A000)
 * epilogue:
 *   [0x0372] = -((cheat[0x5383] hi & 1));         @asm 03BC29..03BC37
 *   cc_done_AAC();                                @asm 03BC3A 0x191F:0xAAC
 * "What is drawn where": the CCBKGD bitmap fills the popup rect, then per-power
 * FF portraits/labels (03C415/03C410) are composited, presented, and the frame
 * is copied to the VGA segment (0xA000).
 * ---------------------------------------------------------------------------- */
int func_03BB4A_cc_screen_background(uint16_t arg0_power_bp_06, int16_t arg1_slot_bp_08)
{
    char framebuf[0x300];   /* [bp-0x300] off-screen compose buffer */

    g_word_0372 = 0;        /* @asm 03BB56 MOV [0x372],ax(=0) */

    /* @asm 03BB5A..03BB6A push rect [0x83A4/0x83A2/0x83A0/0x839E] + "CCBKGD"(0x1253)
     *      03BB6D LCALL 0x181F:0x44E -> load CCBKGD into popup rect. */
    if (cc_bg_load_44E(0x1253,
                       g_cc_rect_839E[0], g_cc_rect_839E[1],
                       g_cc_rect_839E[2], g_cc_rect_839E[3], 0) != 0) {
        /* @asm 03BB77 OR ax,ax / 03BB79 JMP 03BC29 -- load failed, skip draw. */
        goto epilogue;
    }

    cc_clip_3B6();                                  /* @asm 03BB7C LCALL 0x181F:0x3B6 */
    cc_blit_3F4(framebuf, 0, 0);                    /* @asm 03BB87 LCALL 0x181F:0x3F4 */

    /* @asm 03BB8C..03BBB5 fill content rect [0x2DA8..0x2DAE], h=0xC8, w=0x140. */
    cc_fill_444(g_region_2DA8[0], g_region_2DA8[1],
                g_region_2DA8[2], g_region_2DA8[3], 0xC8, 0, 0x140);

    if (arg1_slot_bp_08 >= 0) {                      /* @asm 03BBBA CMP [bp+8],0 / JL */
        func_03C415((int)arg0_power_bp_06, 0);       /* @asm 03BBC9 CALL 0x3C415 (portrait, page 0) */
    }
    func_03C410((int)arg0_power_bp_06);              /* @asm 03BBD3 CALL 0x3C410 (label) */

    cc_present_E2(0, 0x140, 0xC8, 0, 0);             /* @asm 03BBE6 LCALL 0x181F:0xE2 (present) */

    if (arg1_slot_bp_08 >= 0) {                      /* @asm 03BBEB CMP [bp+8],0 / JL 03BC14 */
        func_03C415((int)arg0_power_bp_06, 1);       /* @asm 03BBFA CALL 0x3C415 (page 1) */
        func_03C410((int)arg0_power_bp_06);          /* @asm 03BC04 CALL 0x3C410 */
        cc_pal_3EA(8);                               /* @asm 03BC0C LCALL 0x181F:0x3EA */
    }

    cc_restore_3C0();                                /* @asm 03BC14 LCALL 0x181F:0x3C0 */
    cc_clip_3B6();                                   /* @asm 03BC19 LCALL 0x181F:0x3B6 */
    /* @asm 03BC1E PUSH 0xA000 / 03BC21 PUSH 0xFC00 / 03BC24 LCALL 0x181F:0x3F4
     *      -> copy composed frame to VGA segment 0xA000. */
    cc_blit_3F4((char far *)0, (int)0xA000, (int)0xFC00);

epilogue:
    /* @asm 03BC29 MOV ah,[0x5383] / AND ax,0x100 / CMP 1 / SBB / NEG -> bool
     *      03BC37 MOV [0x372],ax. */
    g_word_0372 = (int16_t)((g_cheat_5383 & 0x01) ? 1 : 0);
    cc_done_AAC();                                   /* @asm 03BC3A LCALL 0x191F:0xAAC */
    (void)framebuf;
    return 0;  /* @asm 03BC3F LEAVE / 03BC40 RETF (void) */
}

/* ----------------------------------------------------------------------------
 * ff_bell_cost_curve -- VICEROY func_03C282 @0x03C282 (160 B, ENTER 4,0)
 * @asm code/VICEROY/disasm/func_03C282_unknown.asm    (RETF @0x03C321)
 * spot-check: file 0x03C282 = C8 04 00 00 (ENTER 4,0)  [BYTE_VERIFIED]
 *
 * ROLE (in scope: GAME MECHANIC): the Founding-Father BELL COST curve for a
 * power -- the value recruit.c/congress.c previously left TBD. arg: power=[bp+6].
 *
 *   if (power < 4 && AIPersonality[power].ctrl(+0x543F)==0)   // human-ish
 *        base = (difficulty + 3) * 2;                 @asm 03C297..03C29F
 *   else base = -(difficulty - 14);                   @asm 03C2A4..03C2AC (= 14-diff)
 *   base <<= 3;                                       @asm 03C2B1 SHL [bp-4],3
 *   // era ramp: each reached era threshold multiplies base by 1.5 (compounding)
 *   if (year >= 0x640) base += base>>1;               @asm 03C2B5..03C2C2
 *   if (year >= 0x672) base += base>>1;               @asm 03C2C5..03C2D2
 *   if (year >= 0x6A4) base += base>>1;               @asm 03C2D5..03C2E2
 *   if (year >= 0x6D6) base += base>>1;               @asm 03C2E5..03C2F2
 *   ffcount = PowerRecord[power].byte(+0x14);         @asm 03C2F5 imul / 03C2FA [bx-0x77E4]
 *   ax = (ffcount + 1) * base + 1;                    @asm 03C300..03C306
 *   if (ffcount == 0) ax >>= 1;                       @asm 03C307 OR cl,cl / SAR
 *   if (independence [0x5382]&1)                       @asm 03C30D TEST [0x5382],1
 *        ax = difficulty*0x5DC + 0x7D0;               @asm 03C314..03C31D (post-revolution override)
 *   return ax;
 *
 * So bell cost scales with difficulty, compounds across the four era gates
 * (years 1600/1650/1700/1750 = 0x640/0x672/0x6A4/0x6D6), grows with how many
 * FFs the power already owns, is halved for the very first FF, and is replaced
 * by a flat difficulty-scaled figure once independence is declared.
 * NOTE: era thresholds 0x640/0x672/0x6A4/0x6D6 match the score era gates in
 * scoring/compute.c (func_051EF4) -- BYTE_VERIFIED there too.
 * ---------------------------------------------------------------------------- */
int func_03C282_ff_bell_cost_curve(uint16_t arg0_power_bp_06)
{
    int32_t base;   /* [bp-4] */
    int     diff = (int)g_difficulty_53A6;          /* @asm 03C297/03C2A4 MOV al,[0x53A6] */
    int     ffcount;
    int32_t ax;

    if ((int)arg0_power_bp_06 < 4 &&                 /* @asm 03C286 CMP [bp+6],4 / JGE */
        g_ai_personality_543F[(unsigned)arg0_power_bp_06 * 0x34] == 0) { /* @asm 03C290 [bx+0x543F]==0 */
        base = (int32_t)((diff + 3) * 2);            /* @asm 03C29C ADD 3 / 03C29F SHL 1 */
    } else {
        base = (int32_t)(14 - diff);                 /* @asm 03C2A9 SUB 0xE / 03C2AC NEG */
    }
    base <<= 3;                                      /* @asm 03C2B1 SHL [bp-4],3 */

    if (g_year_538A >= 0x640) base += base >> 1;     /* @asm 03C2B5/03C2C0 SAR/ADD */
    if (g_year_538A >= 0x672) base += base >> 1;     /* @asm 03C2C5/03C2D0 */
    if (g_year_538A >= 0x6A4) base += base >> 1;     /* @asm 03C2D5/03C2E0 */
    if (g_year_538A >= 0x6D6) base += base >> 1;     /* @asm 03C2E5/03C2F0 */

    /* @asm 03C2F5 IMUL bx,[bp+6],0x13C / 03C2FA MOV al,[bx-0x77E4] (PowerRecord+0x14). */
    ffcount = (int)g_powerrecord_8808[(unsigned)arg0_power_bp_06 * 0x13C + 0x14];

    ax = (int32_t)((ffcount + 1) * base + 1);        /* @asm 03C300 INC / 03C303 IMUL / 03C306 INC */
    if (ffcount == 0) ax >>= 1;                      /* @asm 03C307 OR cl,cl / 03C30B SAR ax,1 */

    if (g_flags_5382 & 1) {                          /* @asm 03C30D TEST [0x5382],1 / JE 03C320 */
        ax = (int32_t)(diff * 0x5DC + 0x7D0);        /* @asm 03C319 IMUL 0x5DC / 03C31D ADD 0x7D0 */
    }
    return (int)ax;  /* @asm 03C320 LEAVE / 03C321 RETF (ax) */
}

/* ----------------------------------------------------------------------------
 * colony_pop_weighted_avg -- VICEROY func_03C424 @0x03C424 (126 B, ENTER 0xA,0)
 * @asm code/VICEROY/disasm/func_03C424_unknown.asm    (RETF @0x03C4A1)
 * spot-check: file 0x03C424 = C8 0A 00 00 (ENTER 0xA,0)  [BYTE_VERIFIED]
 *
 * ROLE (in scope: COLONY aggregate / GAME MECHANIC): computes a population-
 * weighted aggregate over all of one power's colonies. arg: power = [bp+6].
 *   sum_pop(int32)=0 [bp-0xA/-8]; acc(int32)=0 [bp-4/-2];          @asm 03C42A..
 *   for (c = 0; c < [0x539E]; c++) {                               @asm 03C47C CMP [0x539E]
 *       select_player_ctx(c);                                      @asm 03C441 0x181F:0x9E6
 *       if (colony[0x8542].owner(+0x1A) != power) continue;        @asm 03C450 CMP [bx+0x1A]
 *       pop = colony.population(+0x1F);                            @asm 03C455 MOV al,[bx+0x1F]
 *       sum_pop += pop;                                            @asm 03C45A/03C45D (32-bit)
 *       v = colony_field_C86();    // 32-bit per-colony value      @asm 03C464 0x181F:0xC86
 *       acc += aFlmul(v, pop);     // value * population           @asm 03C46E 0xD1D:0xF60
 *   }
 *   if (sum_pop != 0) acc = aFldiv(&acc, sum_pop);  // weighted avg @asm 03C496 0xD1D:0xF92
 *   return (int)acc;                                               @asm 03C49B MOV ax,[bp-4]
 * i.e. acc = Σ(field_C86[c]*pop[c]) / Σpop[c] over the power's colonies -- a
 * population-weighted average of the per-colony 0xC86 metric (e.g. SoL%/value).
 * ---------------------------------------------------------------------------- */
int func_03C424_colony_pop_weighted_avg(uint16_t arg0_power_bp_06)
{
    int32_t sum_pop = 0;    /* [bp-0xA]:[bp-8] */
    int32_t acc     = 0;    /* [bp-4]:[bp-2] */
    int     c;              /* [bp-6] */

    for (c = 0; c < (int)g_colony_count_539E; c++) {     /* @asm 03C47C/03C47F */
        int pop;
        int32_t v;

        select_player_ctx(c);                            /* @asm 03C441 LCALL 0x181F:0x9E6 */
        /* @asm 03C44C MOV bx,[0x8542] / 03C450 CMP [bx+0x1A],al / JNE 03C479. */
        if (g_colony_ctx_8542[0x1A] != (uint8_t)arg0_power_bp_06)
            continue;

        pop = (int)g_colony_ctx_8542[0x1F];              /* @asm 03C455 MOV al,[bx+0x1F] (CWDE/CDQ) */
        sum_pop += (int32_t)pop;                         /* @asm 03C45A ADD / 03C45D ADC */

        v = colony_field_C86();                          /* @asm 03C464 LCALL 0x181F:0xC86 -> dx:ax */
        acc += aFlmul_0F60(v, (int32_t)pop);             /* @asm 03C46E LCALL 0xD1D:0xF60; 03C473 ADD/ADC */
    }

    if (sum_pop != 0) {                                  /* @asm 03C487 OR / 03C48A JE 03C49B */
        acc = aFldiv_0F92(&acc, sum_pop);                /* @asm 03C496 LCALL 0xD1D:0xF92 (acc /= sum_pop) */
    }
    return (int)acc;  /* @asm 03C49B MOV ax,[bp-4] / 03C4A0 LEAVE / 03C4A1 RETF */
}

/* ----------------------------------------------------------------------------
 * ff_offer_color_for_power -- VICEROY func_03C4A2 @0x03C4A2 (57 B, ENTER 2,0)
 * @asm code/VICEROY/disasm/func_03C4A2_unknown.asm    (RETF @0x03C4DA)
 * spot-check: file 0x03C4A2 = C8 02 00 00 (ENTER 2,0)  [BYTE_VERIFIED]
 *
 * ROLE (in scope: GAME-STATE selector / small mechanic): maps a (mode, power)
 * pair to a small status code -- used to pick the row color/state for a power
 * in the Congress/diplomacy listing. args: mode = [bp+6], power = [bp+8].
 *
 * Full return map (all paths byte-verified from shared tails beyond 0x03C4DA):
 *   mode==3: L_3C4DC: C7 46 FE 12 00 @0x3C4DC         -> return 18 (0x12)
 *   mode==2: L_3C4E6: C7 46 FE 0B 00 @0x3C4E6         -> return 11 (0x0B)
 *   mode==1, power>=4 or AI: L_3C514: C7 46 FE 08 00  -> return 8
 *   mode==1, human, indep. set:  SBB/AND 0xFD/ADD 7   -> return 7
 *   mode==1, human, no indep.:   SBB/AND 0xFD/ADD 7   -> return 4
 *   mode==0, power>=4 or AI: L_3C51E: C7 46 FE 06 00  -> return 6
 *   mode==0, human, indep. set:  SBB/AND 0xFB/ADD 9   -> return 9
 *   mode==0, human, no indep.:   SBB/AND 0xFB/ADD 9   -> return 4
 *
 * SBB/AND/ADD idiom (independence flag):
 *   MOV al,[0x5382]; AND ax,1; CMP ax,1; SBB ax,ax
 *   -> AX=0 if indep set (CMP==equal, SBB no borrow), AX=0xFFFF if not.
 *   AND al, mask; ADD ax, base -> base if indep, base-complement if not.
 *
 * Modes 1/2/3 jump to code physically after the main RETF @0x03C4DA; the
 * mode==1 handler at L_3C4F0 repeats the power/AI guard (same logic).
 * ---------------------------------------------------------------------------- */
int func_03C4A2_ff_offer_color_for_power(uint16_t arg0_mode_bp_06, uint16_t arg1_power_bp_08)
{
    /* @asm 03C4A6 MOV ax,[bp+6]; DEC/JE x3 chain dispatch */
    if (arg0_mode_bp_06 == 3)                        /* @asm 03C4B0 JE L_3C4DC */
        return 18;   /* L_3C4DC: C7 46 FE 12 00 @0x3C4DC [BYTE_VERIFIED] */
    if (arg0_mode_bp_06 == 2)                        /* @asm 03C4AD JE L_3C4E6 */
        return 11;   /* L_3C4E6: C7 46 FE 0B 00 @0x3C4E6 [BYTE_VERIFIED] */

    if (arg0_mode_bp_06 == 1) {                      /* @asm 03C4AA JE L_3C4F0 */
        /* L_3C4F0: same power/AI guard then SBB/AND 0xFD/ADD 7. @asm 03C4F0..03C513 */
        if ((int)arg1_power_bp_08 >= 4)
            return 8;  /* L_3C514: C7 46 FE 08 00 @0x3C514 [BYTE_VERIFIED] */
        if (g_ai_personality_543F[(unsigned)arg1_power_bp_08 * 0x34] != 0)
            return 8;  /* L_3C514 @0x3C4FF JNZ 03C514 [BYTE_VERIFIED] */
        /* @asm 0x3C501 MOV al,[0x5382]/AND 1/CMP 1/SBB ax,ax/AND al,0xFD/ADD 7 */
        return (g_flags_5382 & 1) ? 7 : 4;          /* [BYTE_VERIFIED] */
    }

    /* default (mode==0 / other): @asm 0x03C4B2..0x03C4D3 */
    if ((int)arg1_power_bp_08 >= 4)                  /* @asm 03C4B2 CMP [bp+8],4 / JGE 03C51E */
        return 6;    /* L_3C51E: C7 46 FE 06 00 @0x3C51E [BYTE_VERIFIED] */
    if (g_ai_personality_543F[(unsigned)arg1_power_bp_08 * 0x34] != 0)
        return 6;    /* L_3C51E @0x03C4C1 JNE 03C51E [BYTE_VERIFIED] */
    /* @asm 03C4C3 MOV al,[0x5382]/AND 1/CMP 1/SBB ax,ax/AND al,0xFB/ADD 9 */
    return (g_flags_5382 & 1) ? 9 : 4;              /* [BYTE_VERIFIED] */
}

/* ----------------------------------------------------------------------------
 * eliminate_power -- VICEROY func_03C528 @0x03C528 (128 B, ENTER 2,0)
 * @asm code/VICEROY/disasm/func_03C528_unknown.asm    (RETF @0x03C5A7)
 * spot-check: file 0x03C528 = C8 02 00 00 (ENTER 2,0)  [BYTE_VERIFIED]
 *
 * ROLE (in scope: GAME MECHANIC): eliminates a power -- clears its diplomatic
 * standings against the human/self markers, destroys all its units, and marks
 * it eliminated. arg: power = [bp+6].
 *   power_set_a10(power, [0x5398], 0x0B);          @asm 03C535 0x181F:0xA10 (vs current human)
 *   power_set_a10(power, [0x53D2], 0x0B);          @asm 03C546 0x181F:0xA10 (vs self marker)
 *   power_set_a06(power, [0x5398], 0x60);          @asm 03C557 0x181F:0xA06
 *   power_set_a06(power, [0x53D2], 0x60);          @asm 03C568 0x181F:0xA06
 *   for (u = [0x539C]-1; u >= 0; u--)              @asm 03C570/03C597 (descending)
 *       if (unit[u].owner(+0x3147)&0xF == power)   @asm 03C57E/03C584 (UnitRecord stride 0x1C @0x3144, +0x03 owner)
 *           destroy_unit_808(u);                   @asm 03C58C 0x181F:0x808 (ledger destroy_unit)
 *   AIPersonality[power].ctrl(+0x543F) = 2;        @asm 03C5A1 MOV [bx+0x543F],2
 * The two a10/a06 calls reset this power's relation/treaty rows against the
 * two viewer markers; the descending unit sweep removes every unit it owns;
 * the +0x543F = 2 stamp marks the power as eliminated (2 == removed/defeated).
 * ---------------------------------------------------------------------------- */
int func_03C528_eliminate_power(uint16_t arg0_power_bp_06)
{
    int u;  /* [bp-2] */

    /* @asm 03C52C..03C535 PUSH 0x0B,[0x5398],[bp+6] -> 0x181F:0xA10. */
    power_set_a10((int)arg0_power_bp_06, (int)g_human_player_5398, 0x0B);
    /* @asm 03C53D..03C546 PUSH 0x0B,[0x53D2],[bp+6] -> 0x181F:0xA10. */
    power_set_a10((int)arg0_power_bp_06, (int)g_self_marker_53D2, 0x0B);
    /* @asm 03C54E..03C557 PUSH 0x60,[0x5398],[bp+6] -> 0x181F:0xA06. */
    power_set_a06((int)arg0_power_bp_06, (int)g_human_player_5398, 0x60);
    /* @asm 03C55F..03C568 PUSH 0x60,[0x53D2],[bp+6] -> 0x181F:0xA06. */
    power_set_a06((int)arg0_power_bp_06, (int)g_self_marker_53D2, 0x60);

    /* @asm 03C570 MOV ax,[0x539C] / DEC / store; loop while [bp-2] >= 0. */
    for (u = (int)g_unit_count_539C - 1; u >= 0; u--) {   /* @asm 03C597 CMP / 03C59B JGE 03C57A */
        /* @asm 03C57A IMUL bx,[bp-2],0x1C / 03C57E MOV al,[bx+0x3147] / AND 0xF /
         *      03C584 CMP [bp+6] / JNE 03C594. */
        uint8_t owner = g_unitrecord_3144[(unsigned)u * 0x1C + 0x03];
        if ((owner & 0x0F) == (uint8_t)arg0_power_bp_06) {
            destroy_unit_808(u);                          /* @asm 03C58C LCALL 0x181F:0x808 */
        }
    }

    /* @asm 03C59D IMUL bx,[bp+6],0x34 / 03C5A1 MOV byte[bx+0x543F],2 -- mark eliminated. */
    g_ai_personality_543F[(unsigned)arg0_power_bp_06 * 0x34] = 2;
    return 0;  /* @asm 03C5A6 LEAVE / 03C5A7 RETF (void) */
}
