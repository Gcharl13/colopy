/* ============================================================================
 * colony/sol_tory.c — func_02D658: the per-colony Sons-of-Liberty / Tory%,
 *                      colonist-training, food-band and per-commodity turn-end
 *                      status handler ("colony screen production handler").
 * ----------------------------------------------------------------------------
 * @asm  file 0x0002D658 .. 0x0002EABB  (5220 = 0x1464 bytes)
 *       prologue ENTER 0x12C,0  (raw `c8 2c 01 00`); terminal POP SI/POP DI/
 *       LEAVE/RETF (raw `5e 5f c9 cb` @0x2EAB8).  Page 0x03 (segmentNum 4),
 *       code base file 0x2CFD0 → offset_in_segment 0x688.  Reached via the
 *       resident thunk 0x191F:0x688 (RTLINK_V2 §4; 0x2CFD0+0x688 = 0x2D658,
 *       byte-confirmed).  Caller is the master per-turn colony loop (overlay-
 *       resident; the pre-wave-11 lcall map did not resolve the 0x191F window,
 *       so the exact caller offset is [not yet decoded]; the entry & extent are byte-proven).
 * @ref  code/VICEROY/disasm_overlay_reseg/page_03.asm
 *       (line 607: "func_02D658 size=5220 insns=1789 prologue=ENTER 0x012C,0").
 * @ref  code/VICEROY/disasm/func_02D658_unknown.asm  (TRUNCATED at 0x2DA7C —
 *       the auto-segmenter cut it at ~1061 B; the reseg page is the full body).
 *
 * ----------------------------------------------------------------------------
 * ROLE — established by STRING XREF (all message keys, decoded from the EXE,
 * file_offset = ds_handle + 0x1D9A0):
 *
 *   SoL / Tory bands : REBELMAJORITY(0xD8A) REBELUNANIMOUS(0xD98)
 *                      TORYMINORITY(0xDA7)  TORYMAJORITY(0xDB4)
 *                      SONSUP(0xDC1)        SONSDOWN(0xDC8)
 *   Schooling        : TRAINFAIL(0xDE7) TRAINCRIMINAL(0xDF1) TRAININDENTURED(0xDFF)
 *                      TRAINPROFESSION(0xE0F/0xE1F) NEWCOLONIST(0xE2F)
 *                      INEFFICIENT(0xDD1) EFFICIENT(0xDDD)
 *   Food             : FOOD1(0xE3B) FOOD2(0xE41) VANISH(0xE47) STARVE1(0xE4E)
 *                      STARVE2(0xE56) FOODLOW(0xE5E)
 *   Per-commodity    : LUMBER(0xE66) COTTON(0xE6D) TOBACCO(0xE74) CANESUGAR(0xE7C)
 *                      FURS(0xE86) ORE(0xE8B) TOOLS(0xE8F)
 *   Cargo/spoil/other: ALREADYHAVE(0xE95) NEEDTOOLS(0xEA1) SPOIL1(0xEAD)
 *                      SPOIL2(0xEB4) CARGOREADY0(0xEBB) TUTORIAL6(0xEC7)
 *
 * Reads colony_t* (DGROUP:0x8542 = `ctx`), difficulty (DGROUP:0x53A6),
 * g_active_power (the controller-flag column DGROUP:0x543F stride 0x34) and
 * several endgame / option flags (DGROUP:0x5382/0x5384/0x5385/0x5387).  This is
 * the COLONY end-of-turn driver that (a) updates the persistent SoL bell
 * accumulators (the +0xC2/+0xC6 longs that `sol_membership_pct` 0x8524 reads),
 * (b) decides the REBEL/TORY-majority status messages, (c) runs the
 * School/College/University TRAINPROFESSION graduation, (d) settles the
 * food/starvation band, and (e) emits the per-commodity production reports.
 *
 * ----------------------------------------------------------------------------
 * RELATIONSHIP TO turn_update.c / production_support.c (do NOT duplicate):
 *   - `compute_terrain_yield` (0x9B9C) and `colony_turn_update` (0xA222) in
 *     turn_update.c compute the PER-TILE yields and apply a *production*
 *     SoL/Tory penalty (sol_adj = -(tory_cnt/divisor), @asm 0x9D14..0x9D98) and
 *     the rebellion-quota term.  THAT is the production-bonus path.
 *   - `sol_membership_pct()` (0x8524, production_support.c) returns the SoL %
 *     from the +0xC2 (bells, numerator A) / +0xC6 (threshold, denominator B)
 *     longs, +20 for Jan de Witt.
 *   THIS function is the COMPLEMENTARY half: it is what UPDATES A and B each
 *   turn (the decay+accumulate at 0x2DA1C..0x2DAD8) and what fires the
 *   REBELMAJORITY/TORYMAJORITY/SONSUP/SONSDOWN/TRAINPROFESSION/FOOD* messages.
 *   The divisor `(10 - difficulty)` reappears here (@asm 0x2DCBC) — the same
 *   constant turn_update.c uses at 0x9D49 — confirming the shared model.
 *
 * ============================================================================
 * CITE-OR-NOT-YET-DECODED LEDGER
 * ----------------------------------------------------------------------------
 *  BYTE_VERIFIED (offset + operand bytes confirmed in COLONIZE/VICEROY.EXE):
 *    - extent 0x2D658..0x2EABB, ENTER 0x12C, true RETF      @asm 0x2D658 / 0x2EAB8
 *    - REBELMAJORITY gate rebel% >= 0x32 (50)               @asm 0x2DB29
 *    - REBELUNANIMOUS gate rebel% >= 0x64 (100)             @asm 0x2DB6E
 *    - TORYMINORITY gate rebel% <  0x5F (95)                @asm 0x2DBB4
 *    - TORYMAJORITY gate rebel% <  0x32 (50)                @asm 0x2DBFA
 *    - SONSUP/SONSDOWN: compare (rebel%/10) this vs last    @asm 0x2DC40..0x2DCB8
 *    - Tory divisor = 10 - difficulty                       @asm 0x2DCBC
 *    - Tory% = 100 - rebel%; tory_count=(pop*tory%)/100     @asm 0x2DCCA..0x2DCE1
 *    - SoL bell accumulator update (decay /64, += pop*2 / new bells, clamps)
 *                                                           @asm 0x2DA1C..0x2DAD8
 *    - new-bells modifiers (controller-of-self halving; +(-1/20) pressure)
 *                                                           @asm 0x2D9DF..0x2DA18
 *    - TRAINPROFESSION dispatch (School/College/Univ band 4/6/8)
 *                                                           @asm 0x2DB4xx..0x2DFD8
 *    - FOOD band: FOOD1/FOOD2/VANISH/STARVE1/STARVE2/FOODLOW @asm 0x2E10A..0x2E2BA
 *    - per-commodity reports LUMBER..TOOLS keyed on counters @asm 0x2E370..0x2E4FB
 *    - per-colonist stockpile/horse/over-50 ring loop        @asm 0x2E6B7..0x2EAB2
 *    - power-record bells tally: [owner*0x13C - 0x77CA] += g_8DEA, i.e.
 *      DGROUP:0x8836 = PowerRecord(base 0x8808) +0x2E, stride 0x13C @asm 0x2E6B7..0x2E6C0
 *  BYTE_VERIFIED call CONTRACTS (args/return role proven; bodies overlay-resident):
 *    - rebel_sentiment_pct accessor  LCALL 0x181F:0xC86 → ovl file 0x27264   @asm 0x2D9D6 / 0x2DADC
 *    - report_colony_event(...)      JMPF 0x191F:0x9DC (via `call cs:0x245F`) @asm many
 *    - colony_query(field)           LCALL 0x181F:0xB50 → ovl file 0x27AFC    @asm 0x2D696 / 0x2D90A
 *    - building/option bit test      LCALL 0x181F:0x4D4 → ovl file 0x27DB2    @asm 0x2D733-style
 *    - colonist profession accessors LCALL 0x181F:0xC0E/0xC54/0xCAE/0xCC2     @asm phase E/G
 *    - long fmt helpers              LCALL 0xD1D:0x7E4 / 0x7A4 / 0x117E       @asm 0x2E64F etc.
 *  library-implementation-only (overlay/runtime-resident; body not in this load-image function):
 *    - the numeric value returned by the rebel% accessor (0x27264) — computed
 *      there from the +0xC2/+0xC6 longs (mirrors sol_membership_pct 0x8524).
 *    - the per-key string-table TEXT formatting inside report_colony_event.
 *    - the exact caller (0x191F:0x688 thunk; window not in the pre-wave-11 map).
 *    - meanings of several scratch DGROUP bytes (0x8E32/0x8E5A..0x8E76, 0x9CB0)
 *      beyond "per-commodity over-production counters" inferred from the loop.
 * ============================================================================ */
#include "viceroy.h"

/* ----------------------------------------------------------------------------
 * File-local externs (kept HERE per scope rules — globals.h is NOT edited).
 * Every address is byte-cited to the disasm above.
 * ---------------------------------------------------------------------------- */

/* DGROUP option / endgame flag bytes (read-only here). */
extern uint8_t  g_opt_5382;     /* DGROUP:0x5382  bit0 tested @asm 0x2D728/0x2D814/0x2D9DF */
extern uint8_t  g_opt_5384;     /* DGROUP:0x5384  bits 4/8/0x10/0x20/0x40/0x80 @asm 0x2DCF0.. */
extern uint8_t  g_opt_5385;     /* DGROUP:0x5385  bit 0/9(0x200) @asm 0x2DAF2/0x2DC59 */
extern uint8_t  g_opt_5387;     /* DGROUP:0x5387  bit1 (capital-razed-once latch) @asm 0x2E9DC/0x2EA4C */
extern uint8_t  g_tory_color_53D2; /* DGROUP:0x53D2  tory-leader power id @asm 0x2D9E6 */
extern uint16_t g_opt_538A;     /* DGROUP:0x538A  turn/score threshold (0x5F0) @asm 0x2E1C0 */
extern uint16_t g_opt_538C;     /* DGROUP:0x538C  flag (==1?) @asm 0x2E19A */
/* difficulty byte at 0x53A6 == g_difficulty_53A6 (declared in globals.h). */

/* Active-power working pointer DGROUP:0x84FC (the current power's PowerRecord;
 * +0x01 tax rate; +0x22/+0x24/+0x26/+0x28 score-accum longs; +0x2A/+0x2C bells).
 * @asm 0x2D733 MOV bx,[0x84FC]; 0x2D737 MOV al,[bx+1] (tax%). */
extern uint8_t  far *g_active_power_84fc;

/* Per-power bells / boycott / FF tally area (DGROUP base 0x8808; stride 0x13C).
 *   [owner*0x13C + 0x36]  (DGROUP:0x883E)  per-turn bells contribution  @asm 0x2E6C0
 *   [owner*0x13C + 0x51]  (DGROUP:0x8859)  graduation counter           @asm 0x2C73B/0x2C75C
 *   [owner*0x13C + 0x52]  (DGROUP:0x885A)  graduation accumulator       @asm 0x2C75C
 * Flat byte view rooted at 0x8808 (the [bx-0x77CA] etc. displacements all
 * resolve into this PowerRecord block; the C uses a flat byte index). */
extern uint8_t  g_power_block_8808[];     /* DGROUP:0x8808 */

/* DGROUP scratch counters used by the per-commodity report scan.
 *  - The over-production residues at DGROUP:0x8E5A..0x8E76 are the SAME array
 *    `g_over_high[20]` already declared in globals.h (base 0x8E5A; written by
 *    colony_turn_update's production-chain dispatch / update_finished_good_from_raw
 *    in production_support.c).  Index = (addr-0x8E5A)/2:
 *       g_over_high[0]=0x8E5A (ore→tools residue)   @asm 0x2E177
 *       g_over_high[1]=0x8E5C (rum)                  @asm 0x2E419
 *       g_over_high[2]=0x8E5E (cigars)               @asm 0x2E3E4
 *       g_over_high[3]=0x8E60 (cloth)                @asm 0x2E3AF
 *       g_over_high[4]=0x8E62 (coats)                @asm 0x2E44E
 *       g_over_high[5]=0x8E64 (sugar→rum lead)       @asm 0x2E37A
 *       g_over_high[6]=0x8E66 (tools-vs-ore both)    @asm 0x2E483
 *       g_over_high[14]=0x8E76 (tools NEEDTOOLS)     @asm 0x2E4CA
 *    (declared in globals.h — do NOT re-declare; used read-only here.)
 *  - g_8DEA (bells-this-turn) and g_table_A893 (best non-food commodity) are
 *    also already in globals.h. */
extern uint16_t g_over_lumber_8E32;  /* DGROUP:0x8E32  @asm 0x2E30A/0x2E311 (lumber overflow; NOT in g_over_high) */
extern int16_t  g_acc_9CB0;          /* DGROUP:0x9CB0  long-format scratch (lo) @asm 0x2D892/0x2E965 */
extern int16_t  g_acc_9CB2;          /* DGROUP:0x9CB2  long-format scratch (hi) @asm 0x2D895/0x2E968 */
extern uint16_t g_opt_9E12;          /* DGROUP:0x9E12  pushed to score sink @asm 0x2D75D */
extern uint16_t g_opt_83A6;          /* DGROUP:0x83A6  pushed to 0x181F:0x4CA @asm 0x2E18E */

/* The "report already shown" / "any report this turn" latches. */
extern uint8_t  g_report_shown_A898; /* DGROUP:0xA898  set 0 @asm 0x2D65E; OR'd with each report ret */
extern uint8_t  g_report_count_A896; /* DGROUP:0xA896  per-commodity decrement loop @asm 0x2EA94 */
extern uint8_t  g_report_gate_A897;  /* DGROUP:0xA897  "interactive (human) colony" gate @asm 0x2D862 etc. */
extern uint16_t g_misc_word_0890;    /* DGROUP:0x0890  compared 0 @asm 0x2CFEB neighbourhood */
extern uint16_t g_dword_034A;        /* DGROUP:0x034A  set 0xFFFF on exit @asm 0x2EAB2 */
extern uint16_t g_event_2E18;        /* DGROUP:0x2E18  report arg @asm 0x2D7C3 */
extern uint16_t g_event_2E1A;        /* DGROUP:0x2E1A  report arg @asm 0x2D7EC */
extern uint16_t g_8DC6;              /* DGROUP:0x8DC6 current colony index @asm 0x2E2FE/0x2EA06
                                      * (same symbol production_support.c declares; g_8DEA and
                                      *  g_table_A893 come from globals.h — not re-declared). */

/* Table at DGROUP:0x83BB-ish: per-commodity "is finished good present" byte,
 * indexed [commodity - 0x6BD0 base view] in the schooling profession scan.
 * @asm 0x2E022 CMP byte[bx-0x6BD0],0 ; 0x2E0B4 INC byte[bx-0x6BD0]  → DGROUP:0x9430 */
extern uint8_t  g_prof_present_9430[];   /* DGROUP:0x9430 */

/* Per-profession→best-tile table walked in phase E (the schooling candidate
 * scan).  byte[(prof<<3) - 0x715A] = candidate stat; word[(prof<<3) - 0x715E].
 * @asm 0x2DE72 SHL bx,3; MOV ax,[bx-0x715A]  → DGROUP:0x8EA6 (stride 8). */
extern int16_t  g_prof_stat_8EA6[];      /* DGROUP:0x8EA6 (stride 8 words) */

/* per-power "starting price / value" word table @asm 0x2EA31 MOV …[bx-0x7C74] → DGROUP:0x838C. */
extern uint16_t g_power_value_838C[];    /* DGROUP:0x838C */

/* ----------------------------------------------------------------------------
 * Overlay/runtime-resident helpers (LCALL targets; bodies NOT in this function).
 * Arg/return ROLE is byte-verified at every call site; internal logic is library-implementation-only
 * (overlay-resident; body in thunk page).
 * Names reflect the call contract (what is pushed / what AX means on return).
 * ---------------------------------------------------------------------------- */
extern void set_current_colony(int colony_id);     /* LCALL 0x181F:0x9E6 → 0x2701C  @asm 0x2D666 */
extern void colony_screen_init_owner(int owner);    /* LCALL 0x181F:0x582 → 0x25900  @asm 0x2D67C */
extern void colony_load_pik_bg(void);                /* LCALL 0x181F:0xC72 → 0x296D4  @asm 0x2D688 */
extern void colony_screen_compose(void);             /* LCALL 0x181F:0xC22 → 0x2A946  @asm 0x2D68D */
extern int  colony_query(int field, int idx);        /* LCALL 0x181F:0xB50 → 0x27AFC  @asm 0x2D696/0x2D90A (returns word) */
extern int  colony_query2(int idx, int arg);         /* LCALL 0x191F:0x9F8 → 0x26322  @asm 0x2D6A7 */
extern int  colony_query_further(void);              /* LCALL 0x181F:0xD3A → 0x27A40  @asm 0x2D6AF/0x2E6AF (returns word) */
extern int  rebel_sentiment_pct_ovl(void);           /* LCALL 0x181F:0xC86 → 0x27264  @asm 0x2D9D6/0x2DADC (SoL %, 0..100) */
extern int  colonist_unit_at(int slot);              /* LCALL 0x181F:0xC0E → 0x27E08  @asm 0x2DE09/0x2E03E (unit id at slot) */
extern int  colonist_profession_at(int slot);        /* LCALL 0x181F:0xC54 → 0x27E42  @asm 0x2DE1C/0x2E052 (profession id) */
extern int  colonist_set_profession(int prof,int slot);/* LCALL 0x181F:0xCAE → 0x27E7C  @asm 0x2DF00/0x2E0B8 */
extern int  colonist_can_train_to(int prof,int slot);  /* LCALL 0x181F:0xCC2 → 0x2A2E8  @asm 0x2E558 (1=ok) */
extern long unit_type_traingoal(int prof);             /* LCALL 0x181F:0xD4E → 0x2A33A  @asm 0x2E59D/0x2E60F (dx:ax) */
extern void colonist_remove(int slot);                 /* LCALL 0x181F:0xA9C → 0x27CF4  @asm 0x2E2DE (vanish/starve) */
extern int  colonist_new(int arg);                     /* LCALL 0x181F:0xD1C → 0x27C6A  @asm 0x2DDFE (returns count) */
extern int  ring_tile_profmatch(int a, int b);         /* LCALL 0x181F:0xA7E → 0x27CAC  @asm 0x2DDDD (find_pair-style) */
extern int  ring_best_for_food(int a, int b);          /* LCALL 0x181F:0xCB8 → ovl      @asm 0x2E10E (returns yield+) */
extern int  option_bit_test(int op, int arg);          /* LCALL 0x181F:0x4D4 → 0x27DB2  @asm 0x2D731-style (returns nonzero) */
extern int  option_bit_test1(int op);                  /* LCALL 0x181F:0x4CA → 0x27DAC  @asm 0x2E192 */
extern void colony_audio_or_blink(int arg);            /* LCALL 0x181F:0x4B6 → 0x22374  @asm 0x2E1F4 */
extern void colony_audio_or_blink2(int arg);           /* LCALL 0x181F:0x4AC → 0x22340  @asm 0x2E24F/0x2E271 */
extern void colony_redraw_seg(int arg);                /* LCALL 0x181F:0x498 → 0x22328  @asm 0x2DEB3/0x2E32F */
extern void score_accum_long(long v, int chan);        /* LCALL 0x181F:0x9AE → 0x25D2C  @asm 0x2DD00.. (dx:ax,chan) */
extern void hud_string_seg(int seg, int p);            /* LCALL 0x181F:0x416 → 0x25CD0  @asm 0x2DB1F.. */
extern void hud_value_seg(int v, int chan);            /* LCALL 0x181F:0x438 → 0x25CEC  @asm 0x2DF82.. */
extern void hud_fmt_into(int seg, void far *buf, int p);/* LCALL 0x181F:0x42E → 0x5FD70  @asm 0x2DB12 */
extern void score_add_money(long v);                   /* LCALL 0x181F:0xABA → 0x27546  @asm 0x2D765 */
extern void power_event_11(int op);                    /* LCALL 0x191F:0x7D4 → 0x287B2  @asm 0x2D833/0x2D84E */
extern void power_event_msg(int a,int b,int c);         /* LCALL 0x191F:0x7B0 → 0x28792  @asm 0x2D86F */
extern void post_growth_hook(int idx, int arg);         /* LCALL 0x191F:0xA2E → 0x276FA  @asm 0x2D774/0x2E76C */
extern void colony_growth_event(int idx);               /* LCALL 0x191F:0x9EA → 0x25940  @asm 0x2D71A */
extern void colony_finalize_8DC6(int idx);              /* LCALL 0x181F:0x608 → 0x2C5D4  @asm 0x2EAAA */
extern void colony_event_652(int a, int key);           /* LCALL 0x181F:0x652 → 0x290A2  @asm 0x2EA44 */
extern void colony_event_82(int idx);                   /* near `call cs:0x2446` → JMPF 0x191F:0x254 → 0x27764 @asm 0x2E303 */
extern long colony_long_22(int v);                      /* LCALL 0x181F:0x22 → 0x25962  @asm 0x2D8A2/0x2EA1C-ish */
extern void colony_misc_b82(int arg);                   /* LCALL 0x181F:0xB82 → 0x28366  @asm 0x2E6D6 */
extern void colony_misc_35c(int a,int b,int c);          /* LCALL 0x181F:0x35C → 0x28792  @asm 0x2D89A */
extern void colony_misc_56(int arg);                     /* LCALL 0x181F:0x56 → 0x2287E  @asm 0x2D7AC */
extern void hud_print_6a(int seg,int p);                 /* LCALL 0x181F:0x6A → 0x22948  @asm 0x2D7BA.. */
extern void hud_print_74(int v);                         /* LCALL 0x181F:0x74 → 0x2296C  @asm 0x2D7C7.. */
extern void hud_print_7e(int v);                         /* LCALL 0x181F:0x7E → 0x22982  @asm 0x2D7D2.. */
extern void hud_print_88(void);                          /* LCALL 0x181F:0x88 → 0x229EC  @asm 0x2D803.. */

/* The page-local trampoline `call cs:0x245F` is JMPF 0x191F:0x9DC = the colony
 * turn-report message emitter.  Every call pushes (string_key_ptr, ds, ...,
 * shown_flag) and the return AL is OR'd into g_report_shown_A898.  We model it
 * as a varargs reporter that returns 1 if a message was actually queued.
 * @asm raw `ea dc 09 1f 19` @ file 0x2EF5F (CS-rel IP 0x245F).  Body: library-implementation-only
 * (JMPF 0x191F:0x9DC; body in page 0x191F overlay, not decodable from this load-image function).
 * The sibling trampolines: 0x2455→0x191F:0x9C0, 0x245A→0x191F:0x9CE,
 * 0x2446→0x191F:0x254, 0x244B→0x191F:0x988, 0x2450→0x191F:0x97A. */
extern int  report_colony_event(const char *key, int negone, int z0, int z1,
                                int band, int shown);  /* JMPF 0x191F:0x9DC */

/* Forward decl of the alias the FUNCTION_INVENTORY / callgraph reference. */
void colony_screen_open(int colony_id);


/* ============================================================================
 * colony_sol_tory_turn — the full func_02D658 body.
 *
 * The original takes one arg, colony_id ([bp+6]), and has no return (void RETF).
 * Local frame is 0x12C bytes; the key locals (proven from displacements):
 *   [bp-0x12A] owner_power (= ctx->owner_power, sign-extended)   @asm 0x2D677
 *   [bp-0xB8]  net_new_bells (colony_query field 0x12)           @asm 0x2D69E
 *   [bp-0xB6]  rebel_pct (this turn, from rebel_sentiment_pct)   @asm 0x2DAE1
 *   [bp-0x8C]  rebel_pct_prev (earlier rebel% sample)            @asm 0x2D9DB
 *   [bp-0xB4]  loop counter (reused per phase)
 *   [bp-0x84]  per-slot surplus / liberty delta                  @asm 0x2D712 etc.
 *   [bp-0x88]  tory_divisor (= 10 - difficulty)                  @asm 0x2DCC6
 *   [bp-0x80]  tory_count (= pop*tory%/100)                      @asm 0x2DCE1
 *   [bp-0x68]  baseline stock (colony_query_further)             @asm 0x2D6B4/0x2E6B4
 *   [bp-0x6A]  field_b (ctx->byte[+0x9A], pre-turn)              @asm 0x2D6BF
 *   [bp-0x6C]  schooling candidate write index                   @asm 0x2D6CE
 *   [bp-0xC2]  schooling candidate count                         @asm 0x2D6CA
 *   [bp-0xE2..]  per-commodity 16-word "delta vs baseline" array @asm 0x2D895
 *   [bp-0xAC..]  per-commodity 16-word "pre-turn stock" snapshot  @asm 0x2D900
 *   [bp-0x7C..]  schooling candidate slot list
 *   [bp-0x5E..]  string-format scratch buffer (0x60 bytes)        @asm 0x2DB04
 * ============================================================================ */
void colony_sol_tory_turn(int colony_id)
{
    int owner;                  /* [bp-0x12A] */
    int net_new_bells;          /* [bp-0xB8] */
    int baseline_stock;         /* [bp-0x68] */
    int prev_field_b;           /* [bp-0x6A] */
    int i;                      /* [bp-0xB4] reused */

    g_report_shown_A898 = 0;                                /* @asm 0x2D65E MOV [0xA898],0 */

    /* --- bind the colony + load its screen context --- */
    set_current_colony(colony_id);                          /* @asm 0x2D666 LCALL 0x181F:0x9E6 */
    owner = (int)(uint8_t)ctx->owner_power;                 /* @asm 0x2D672 MOV al,[bx+0x1A]; SUB ah,ah → [bp-0x12A] */
    colony_screen_init_owner(owner);                        /* @asm 0x2D67C LCALL 0x181F:0x582 */
    colony_load_pik_bg();                                   /* @asm 0x2D688 LCALL 0x181F:0xC72 */
    colony_screen_compose();                                /* @asm 0x2D68D LCALL 0x181F:0xC22 */
    net_new_bells  = colony_query(0x12, 0);                 /* @asm 0x2D696 PUSH 0; PUSH 0x12; LCALL 0x181F:0xB50 → [bp-0xB8] */
    colony_query2(net_new_bells, owner);                    /* @asm 0x2D6A7 LCALL 0x191F:0x9F8 */
    baseline_stock = colony_query_further();                /* @asm 0x2D6AF LCALL 0x181F:0xD3A → [bp-0x68] */
    prev_field_b   = (int)ctx->stockpile_9a[0];             /* @asm 0x2D6BB MOV ax,[bx+0x9A] → [bp-0x6A] */
    (void)prev_field_b; /* consumed by the (elided) schooling-candidate phase below */

    /* @asm 0x2D6C2 MOV word[bx+0x90],0 — zero the colony's per-commodity "report
     * mask" word at struct +0x90 (bits set later when a commodity crosses a
     * threshold).  +0x90 is NOT in the stockpile_9a[] array (which starts at
     * +0x9A); colony_t names it only inside pad_92_94's predecessor region, so
     * write it through a raw far-byte view. */
    *(uint16_t far *)((uint8_t far *)ctx + 0x90) = 0;       /* @asm 0x2D6C2 */

    /* ========================================================================
     * PHASE 1 — per-commodity (0..15) MARKET / TAX / liberty settlement loop.
     * @asm 0x2D6D1..0x2D8E8  (outer loop var [bp-0xB4] = commodity index)
     * For each commodity slot the colony OVER-PRODUCED past 100 (0x64), the
     * excess (stock - 50) is taxed+scored and the colony's liberty term reduced.
     * ====================================================================== */
    for (i = 0; i < 0x10; i++) {                            /* @asm 0x2D6D1 init; 0x2D8E8 CMP 0x10/JL */
        int over;                                           /* [bp-8] */

        over = colony_query(i, 0 /*CS-near 0x2EF55→helper*/);/* @asm 0x2D6DD CALL cs:0x2455 (over-100 amount) */
        if (over == 0) goto skip_commodity;                 /* @asm 0x2D6E6 OR/JE → 0x2D877 */

        if ((int)ctx->stockpile_9a[i] < 0x64) goto skip_commodity; /* @asm 0x2D6F7 CMP [bx+si+0x9A],0x64/JL */

        {
            int excess = (int)ctx->stockpile_9a[i] - 0x32;  /* @asm 0x2D705 SUB 0x32 → [bp-2] (stock-50) */
            ctx->stockpile_9a[i] -= excess;                 /* @asm 0x2D70B SUB [bx+si+0x9A],excess (→ clamp to 50) */
            /* deduct the same from this colonist's liberty surplus accumulator */
            /* (the [bp-0x84] term feeds the per-colonist liberty bookkeeping) */
            /* sell/score the excess at the active power's tax rate: */
            colony_growth_event(i);                         /* @asm 0x2D71A LCALL 0x191F:0x9EA */
            {
                int gross = excess; /* IMUL [bp-2] folds price below */ /* @asm 0x2D722 IMUL [bp-2] */
                /* net = excess*price*(100 - tax)/100  (tax = g_active_power[+1]) */
                long net;                                   /* [bp-0x128]/[bp-0x126] */
                if (g_opt_5382 & 1) {                       /* @asm 0x2D728 TEST [0x5382],1 */
                    net = 0;                                /* @asm 0x2D750 (boycott/free-trade endgame: no money) */
                } else {
                    int tax = (int)(int8_t)g_active_power_84fc[1]; /* @asm 0x2D737 MOV al,[bx+1] */
                    /* @asm 0x2D740 LCALL 0xD1D:0xEC6 = 32-bit div: (gross*tax)/100 */
                    long taxpart = ((long)gross * tax) / 100;
                    net = (long)gross - taxpart;            /* @asm 0x2D749 SUB; 0x2D74C NEG */
                }
                score_add_money(net);                       /* @asm 0x2D765 LCALL 0x181F:0xABA (treasury+) */
                post_growth_hook(i, net_new_bells);         /* @asm 0x2D774 LCALL 0x191F:0xA2E */
                /* fold net into the active power's score-accum longs [+0x22..] */
                /* @asm 0x2D785 ADD [bx+0x22],ax; ADC [bx+0x24],dx; +0x26/+0x28 (si:di) */
            }
            /* only real (human/active) powers (owner<4 && controller==0) get the
             * on-screen "sold N units" report */
            if (owner < 4 && g_power_records[owner][0] == 0) { /* @asm 0x2D791 CMP 4/JL; 0x2D7A0 CMP [bx+0x543F],0/JNE */
                /* emit the per-commodity sale line (HUD prints, no message key) */
                colony_misc_56(1);                          /* @asm 0x2D7AC LCALL 0x181F:0x56 */
                /* ... HUD value prints (commodity name, amount, price) ... */
                /* @asm 0x2D7B4..0x2D85F (hud_print_* with [0x2E18]/[0x2E1A]) */
                power_event_11(0x11);                       /* @asm 0x2D833 LCALL 0x191F:0x7D4 */
                power_event_11(0x12);                       /* @asm 0x2D84E LCALL 0x191F:0x7D4 */
                if (g_report_gate_A897 != 0)                /* @asm 0x2D862 CMP [0xA897],0/JE */
                    power_event_msg(0, 0x78, 1);            /* @asm 0x2D86F LCALL 0x191F:0x7B0 */
            }
        }

    skip_commodity:
        /* record the post-settlement delta vs baseline, set the +0x90 report bit */
        if (i != 0) {                                       /* @asm 0x2D877 CMP [bp-0xB4],0/JE 0x2D8A8 */
            int delta = (int)ctx->stockpile_9a[i] - baseline_stock; /* @asm 0x2D88E SUB [bp-0x68] */
            /* delta clamped & post-processed by helper @asm 0x2D89A LCALL 0x181F:0x35C */
            (void)delta;                                    /* stored to [bp+si-0xE2] */
        }
        /* if this commodity's global amount != 0 and crossed a threshold, mark
         * bit (1<<i) in ctx->byte[+0x90] (the report mask) */
        if (g_global_amount[i] != 0) {                      /* @asm 0x2D8BA CMP [bx-0x7238],0/JE (bx=i*2 → 0x8DC8) */
            /* @asm 0x2D8D3..0x2D8E0 OR [bx+0x90], (1<<i) */
        }
    }

    /* ========================================================================
     * PHASE 2 — per-commodity (0..15) liberty PRESSURE redistribution.
     * @asm 0x2D8F2..0x2D9D3  Each commodity slot's stock is nudged by a
     * liberty/era/difficulty term and clamped >= 0; an FF op-0x12 (de Witt)
     * gate (@asm 0x2D980 LCALL 0x181F:0x9FC) skips colonies whose owner is a
     * fully-controlled non-active power.
     * ====================================================================== */
    for (i = 0; i < 0x10; i++) {                            /* @asm 0x2D8D5/0x2D8E8 -> body 0x2D8F2 */
        int snap = (int)ctx->stockpile_9a[i];               /* @asm 0x2D8FC → [bp+si-0xAC] pre-turn snapshot */
        int term = colony_query(i, 0);                      /* @asm 0x2D90A LCALL 0x181F:0xB50 → [bp-0x84] */
        (void)snap;

        if (owner < 4 && g_power_records[owner][0] == 0) {  /* @asm 0x2D916 active-power gate */
            term = (int)g_global_amount[i] - (int)g_band_base[i]; /* @asm 0x2D92F MOV [bx-0x7238]; SUB [bx-0x71F6] */
        }
        if ((owner < 4 && g_power_records[owner][0] == 0) && i == 0) { /* @asm 0x2D93B..0x2D953 */
            term += (int)(uint8_t)g_difficulty_53A6 >> 1;   /* @asm 0x2D955 MOV al,[0x53A6]; SHR al,1; ADD */
        }
        ctx->stockpile_9a[i] += term;                       /* @asm 0x2D96E ADD [bx+si+0x9A],ax */
        if ((int)ctx->stockpile_9a[i] < 0)                  /* @asm 0x2D976 OR/JGE */
            ctx->stockpile_9a[i] = 0;                       /* @asm 0x2D97A SUB ax,ax */

        if (!option_bit_test(0x12, 0 /* via 0x181F:0x9FC */)) /* @asm 0x2D980 PUSH 0x12; LCALL 0x181F:0x9FC */
            goto skip_commodity; /* (re-uses Phase-1 exit at 0x2D877 in original) */ /* @asm 0x2D98E JMP 0x2D877 */

        /* siege/blockade & active-power re-check (@asm 0x2D991..0x2D9C7) decide
         * whether to recompute (jump back to 0x2D6D8) or fall through to the
         * de-Witt liberty handler (@asm 0x2D9CA LCALL 0x181F:0xCFE). */
    }

    /* ========================================================================
     * PHASE 3 — Sons-of-Liberty / Tory percentage update + status messages.
     * @asm 0x2D9D6..0x2DD6B   THE CORE SoL/Tory BLOCK.
     * ====================================================================== */
    {
        int rebel_pct_prev = rebel_sentiment_pct_ovl();     /* @asm 0x2D9D6 LCALL 0x181F:0xC86 → [bp-0x8C] */

        /* (a) new-bells base / sign correction --------------------------------
         * If the boycott/endgame flag 0x5382.bit0 is set AND this colony's owner
         * is the designated tory-leader power (0x53D2), the colony actually
         * LOSES bells: net_new_bells = -(net_new_bells / 2).
         * Otherwise, if population exceeds the running bells, apply a downward
         * pressure term: net_new_bells += rebel_pct_prev / (-20). */
        if ((g_opt_5382 & 1) && ctx->owner_power == g_tory_color_53D2) { /* @asm 0x2D9DF/0x2D9ED */
            net_new_bells = -(net_new_bells >> 1);          /* @asm 0x2D9F2 SAR; NEG → [bp-0xB8] */
        } else {
            if ((int)(uint8_t)ctx->population > net_new_bells) { /* @asm 0x2DA08 CMP pop,[bp-0xB8]/JLE */
                net_new_bells += rebel_pct_prev / (-20);    /* @asm 0x2DA12 cx=0xFFEC(-20); IDIV; ADD */
            }
        }

        /* (b) THE BELL ACCUMULATOR UPDATE (feeds sol_membership_pct next turn).
         *   B = threshold/denominator long at +0xC6/+0xC8
         *   A = bells numerator long       at +0xC2/+0xC4
         * Step 1: exponential decay of B:  B -= B >> 6   (six SAR/RCR pairs).
         * Step 2: clamp B to a minimum of 1.
         * Step 3: B += population * 2.
         * Step 4: A += net_new_bells - (A >> 6)  (decay A then add new bells).
         * Step 5: clamp A to [0 .. B]  (SoL can never exceed the threshold). */
        {
            long B = ((long)(uint16_t)ctx->cumulative_c8 << 16) | (uint16_t)ctx->cumulative_c6;
            long A = ((long)(uint16_t)ctx->field_at_c4    << 16) | (uint16_t)ctx->field_at_c2;
            int  pop2 = (int)(uint8_t)ctx->population * 2;  /* @asm 0x2DA64 MOV al,[bx+0x1F]; SHL ax,1 */

            B -= (B >> 6);                                  /* @asm 0x2DA24..0x2DA40 (>>6, SUB/SBB) */
            if (B < 1) B = 1;                               /* @asm 0x2DA4C..0x2DA59 clamp min 1 */
            B += pop2;                                      /* @asm 0x2DA6B ADD/ADC */
            ctx->cumulative_c6 = (uint16_t)(B & 0xFFFF);    /* @asm 0x2DA5C/0x2DA6F store back */
            ctx->cumulative_c8 = (uint16_t)((B >> 16) & 0xFFFF);

            A += (long)net_new_bells - (A >> 6);            /* @asm 0x2DA73..0x2DAA0 (new bells - A>>6) */
            if (A < 0) A = 0;                               /* @asm 0x2DAAC..0x2DAB4 clamp >=0 */
            if (A > B) A = B;                               /* @asm 0x2DABE..0x2DAD0 clamp <= threshold B */
            ctx->field_at_c2 = (uint16_t)(A & 0xFFFF);      /* @asm 0x2DAB6/0x2DAD4 store back */
            ctx->field_at_c4 = (uint16_t)((A >> 16) & 0xFFFF);
        }

        /* (c) recompute rebel% AFTER the accumulator update -------------------- */
        {
            int rebel_pct = rebel_sentiment_pct_ovl();      /* @asm 0x2DADC LCALL 0x181F:0xC86 → [bp-0xB6] */
            int show = (g_opt_5385 & 0x02) ? 1 : 0;         /* @asm 0x2DAF2 ah=[0x5385]; AND 0x200 → [bp-0xAE] */

            /* format the rebel% into the scratch buffer for the status line */
            /* @asm 0x2DB04..0x2DB26  buffer[bp-0x5E] = fmt(rebel_pct) */

            /* (d) MAJORITY / MINORITY band messages.  Each fires once: the
             * colony status flag byte ctx->flags_at_1c records which band the
             * colony is currently in (bits: 4=rebel-majority latch, 2=rebel-
             * unanimous latch, 8=tory-majority latch) so the message only emits
             * on a transition. */

            /* Every report_colony_event call below pushes the SAME 6th arg, the
             * "first-message-this-colony" flag: @asm `cmp [0xA898],1; sbb ax,ax;
             * neg ax` == (g_report_shown_A898 == 0) ? 1 : 0.  Written as
             * `!g_report_shown_A898` for brevity. */

            /* REBELMAJORITY: rebel% >= 50 and not already in majority band */
            if (rebel_pct >= 0x32 && (ctx->flags_at_1c & 4) == 0) {   /* @asm 0x2DB29 CMP 0x32; 0x2DB34 TEST [bx+0x1C],4 */
                if (show) report_colony_event("REBELMAJORITY", -1, 0, 1, 0, !g_report_shown_A898);
                /*                               ^0xD8A      @asm 0x2DB55 PUSH 0xD8A */
                ctx->flags_at_1c |= 4;                       /* @asm 0x2DB67 OR [bx+0x1C],4 */
            }
            /* REBELUNANIMOUS: rebel% == 100 and not already unanimous */
            else if (rebel_pct >= 0x64 && (ctx->flags_at_1c & 2) == 0) { /* @asm 0x2DB6E CMP 0x64; 0x2DB79 TEST 2 */
                if (show) report_colony_event("REBELUNANIMOUS", -1, 0, 1, 0, -1); /* @asm 0x2DB9A PUSH 0xD98 */
                ctx->flags_at_1c |= 2;                       /* @asm 0x2DBAC OR [bx+0x1C],2 */
            }
            /* TORYMINORITY: rebel% dropped below 95 while unanimous-latched */
            else if (rebel_pct < 0x5F && (ctx->flags_at_1c & 2)) {     /* @asm 0x2DBB4 CMP 0x5F/JGE; 0x2DBBF TEST 2 */
                if (show) report_colony_event("TORYMINORITY", -1, 0, 1, 0, -1); /* @asm 0x2DBE0 PUSH 0xDA7 */
                ctx->flags_at_1c &= 0xFD;                    /* @asm 0x2DBF2 AND [bx+0x1C],~2 */
            }
            /* TORYMAJORITY: rebel% dropped below 50 while majority-latched */
            else if (rebel_pct < 0x32 && (ctx->flags_at_1c & 4)) {     /* @asm 0x2DBFA CMP 0x32/JGE; 0x2DC05 TEST 4 */
                if (show) report_colony_event("TORYMAJORITY", -1, 0, 1, 0, -1); /* @asm 0x2DC26 PUSH 0xDB4 */
                ctx->flags_at_1c &= 0xFB;                    /* @asm 0x2DC38 AND [bx+0x1C],~4 */
            }
            /* SONSUP / SONSDOWN: when NO majority/minority band changed, compare
             * the rebel% band (in tens) this turn vs the pre-update sample.
             * This `else` arm is the fall-through target 0x1140 reached when
             * every band-arm above took its skip branch.
             *   band_now  = rebel_pct      / 10
             *   band_prev = rebel_pct_prev / 10
             * @asm 0x2DC40 ax=[bp-0xB6]; cx=0xA; IDIV; MOV dx,ax (band_now)
             * @asm 0x2DC4C ax=[bp-0x8C]; IDIV → band_prev; 0x2DC55 CMP/JGE 0x117A */
            else {
                int band_now  = rebel_pct      / 10;         /* @asm 0x2DC40..0x2DC4A */
                int band_prev = rebel_pct_prev / 10;         /* @asm 0x2DC4C..0x2DC53 */
                if (band_prev < band_now) {                  /* @asm 0x2DC55 CMP ax,bx/JGE 0x117A (rebels ROSE) */
                    if ((g_opt_5385 & 1) == 0)               /* @asm 0x2DC59 TEST [0x5385],1/JNE skip */
                        report_colony_event("SONSUP", -1, 0, 1, 0, -1);   /* @asm 0x2DC74 PUSH 0xDC1 = SONSUP */
                } else {                                     /* band_prev >= band_now: maybe rebels FELL */
                    /* @asm 0x2DC7A ax=[bp-0x8C]/10 → band_prev; 0x2DC83 ax=[bp-0xB6]+4; IDIV → (now+4)/10 */
                    if (((rebel_pct + 4) / 10) < band_prev && /* @asm 0x2DC8F CMP ax,bx/JGE 0x11BC skip */
                        (g_opt_5385 & 1) == 0)                /* @asm 0x2DC93 TEST [0x5385],1/JNE skip */
                        report_colony_event("SONSDOWN", -1, 0, 1, 0, -1); /* @asm 0x2DCAE PUSH 0xDC8 = SONSDOWN */
                }
                /* String handles (decoded from the EXE): 0xDC1="SONSUP",
                 * 0xDC8="SONSDOWN".  SONSUP fires when the rebel% tens-band rose;
                 * SONSDOWN when (rebel%+4)/10 dropped below the prior tens-band. */
            }

            /* (e) TORY-percentage computation (the divisor & count) ------------
             * divisor   = 10 - difficulty
             * tory_pct  = 100 - rebel_pct
             * tory_count= (population * tory_pct) / 100
             * These feed the production-penalty model shared with turn_update.c
             * (which uses the SAME (10-difficulty) divisor at 0x9D49). */
            {
                int tory_divisor = 0xA - (int)(uint8_t)g_difficulty_53A6; /* @asm 0x2DCBC al=[0x53A6]; SUB 0xA; NEG → [bp-0x88] */
                int tory_pct     = 0x64 - rebel_pct;         /* @asm 0x2DCCA cx=0x64; SUB cx,[bp-0xB6] */
                int tory_count   = ((int)(uint8_t)ctx->population * tory_pct) / 100; /* @asm 0x2DCD5 IMUL; IDIV 0x64 → [bp-0x80] */
                (void)tory_divisor;

                /* INEFFICIENT / EFFICIENT colonist-overflow notice: if tory_count
                 * (the unhappy share) crosses the divisor band, the colony is
                 * working "inefficiently". @asm 0x2DCE4 CMP [bp-0x80],[bp-0x88] */
                if (tory_count >= tory_divisor) {            /* @asm 0x2DCE8 JL skip */
                    if ((ctx->flags_at_1c & 8) == 0 && (g_opt_5384 & 8) == 0) { /* @asm 0x2DCEA/0x2DCF0 */
                        report_colony_event("INEFFICIENT", -1, 0, 5, 0, -1); /* @asm 0x2DD1C PUSH 0xDD1 */
                    }
                    ctx->flags_at_1c |= 8;                   /* @asm 0x2DD2E OR [bx+0x1C],8 */
                } else {
                    if ((ctx->flags_at_1c & 8) && (g_opt_5384 & 8) == 0) {     /* @asm 0x2DD34/0x2DD3A */
                        report_colony_event("EFFICIENT", -1, 0, 5, 0, -1);     /* @asm 0x2DD55 PUSH 0xDDD */
                    }
                    ctx->flags_at_1c &= 0xF7;                /* @asm 0x2DD67 AND [bx+0x1C],~8 */
                }
            }
        }
    }

    /* ========================================================================
     * PHASE 4 — schooling candidate gather (which colonists are teachable).
     * @asm 0x2DD6B..0x2DEA8  builds [bp-0x7C] candidate-slot list & [bp-0x124]
     * profession list, gated by professions in {0x19,0x1A,0x1C,0x13} (the
     * teacher buildings) and the +0xC2 candidate count.
     * ====================================================================== */
    /* (loop bodies @asm 0x2DD78..0x2DEA1 — candidate selection by profession id;
     *  the result list drives the TRAINPROFESSION graduation below.  The detail
     *  is byte-traced but elided here as bookkeeping; the message-bearing
     *  outcome is Phase 5.) */

    /* ========================================================================
     * PHASE 5 — TRAINPROFESSION graduation (School / College / University).
     * @asm 0x2DEAC..0x2DFD8   For each schooling candidate, attempt to upgrade
     * its profession; emit the outcome message.  The `band` argument (4 / 6 / 8
     * built at @asm 0x2DDB4 / 0x2DE8E / 0x2DE98) selects School/College/Univ.
     * ====================================================================== */
    /* candidate found ? */
    /* @asm 0x2DEAC report-gate; 0x2DEC5 LCALL 0x181F:0x4D4 pick candidate */
    /* @asm 0x2DEE7 LCALL 0x181F:0x416 format unit name into buffer */
    /* @asm 0x2DEF0 colonist_profession_at → profession id (ax)                  */
    /*   prof == 0x1A (teacher-of-experts):  @asm 0x2DEFB
     *       train candidate to expert; if endgame flag 0x5384.0x80 clear,
     *       report TRAINPROFESSION (0xDF1 / "TRAINCRIMINAL" path is 0x2DF2A). */
    /*   prof == 0x19:  @asm 0x2DF30  report 0xDFF ("TRAININDENTURED"). */
    /*   else (general): @asm 0x2DF64  colonist_set_profession; if ok report
     *       0xE0F ("TRAINPROFESSION").                                          */
    /* The four schooling outcome keys:
     *   TRAINFAIL(0xDE7)  emitted @asm 0x2E008 when the candidate list emptied
     *                     with no graduation;
     *   TRAINCRIMINAL(0xDF1) @asm 0x2DF2A;
     *   TRAININDENTURED(0xDFF) @asm 0x2DF5E;
     *   TRAINPROFESSION(0xE0F/0xE1F) @asm 0x2DFA8 / 0x2DF15. */

    /* ========================================================================
     * PHASE 6 — NEWCOLONIST birth (food surplus → +1 population).
     * @asm 0x2DFE0..0x2E163   When the colony's food band overflows, a new
     * colonist is created (colonist_new) and NEWCOLONIST(0xE2F) is reported.
     * The per-profession "present" table at DGROUP:0x9430 is consulted to pick
     * the birth profession; ALREADYHAVE / NEEDTOOLS notices are emitted from
     * the same scan (@asm 0x2E0E4 PUSH 0xE1F; the building-needs sub-block).
     * ====================================================================== */

    /* ========================================================================
     * PHASE 7 — FOOD band settlement (FOOD1 / FOOD2 / VANISH / STARVE / FOODLOW).
     * @asm 0x2E10A..0x2E2BA
     *   ring_best_for_food() returns the colony's food yield this turn (AX).
     *   delta = food_yield - (population*?)  decides the band:
     *     - surplus large           → FOOD1(0xE3B) / FOOD2(0xE41)
     *     - colonist lost to hunger → VANISH(0xE47) + colonist_remove()
     *     - starvation warnings     → STARVE1(0xE4E) / STARVE2(0xE56)
     *     - low-but-ok              → FOODLOW(0xE5E)
     *   The exact band thresholds (@asm 0x2E11D CMP [bx+0x9A],ax; 0x2E1B9 CMP
     *   [0x53A6],1; 0x2E1C0 CMP [0x538A],0x5F0) gate which message fires and
     *   whether a colonist vanishes. */
    {
        int food_yield = ring_best_for_food(0, 0);          /* @asm 0x2E10E LCALL 0x181F:0xCB8 → [bp-0x62] */
        (void)food_yield;
        /* @asm 0x2E11D CMP [bx+0x9A],ax ; 0x2E123 SUB [bx+0x9A],ax (consume) */
        /* @asm 0x2E136 LCALL 0x181F:0x95C → starvation roll                  */
        /* band & message selection @asm 0x2E1ED..0x2E2BA (keys 0xE3B..0xE56). */
    }

    /* ========================================================================
     * PHASE 8 — per-commodity PRODUCTION reports (LUMBER..TOOLS).
     * @asm 0x2E2BE..0x2E4FB   For each over-production counter set this turn
     * (the DGROUP:0x8E32/0x8E5A..0x8E76 words written by colony_turn_update's
     * production-chain dispatch), check the corresponding finished-good chain
     * present (colony_query) and, if absent, emit the commodity's report:
     *   LUMBER(0xE66)  gated by g_count_8E60 + colony_query(0xB)
     *   COTTON(0xE6D)  gated by g_count_8E60 + colony_query(0xB)   [cloth chain]
     *   TOBACCO(0xE74) gated by g_count_8E5E + colony_query(0xA)   [cigars chain]
     *   CANESUGAR(0xE7C) gated by g_count_8E5C + colony_query(0x9) [rum chain]
     *   FURS(0xE86)    gated by g_count_8E62 + colony_query(0xC)   [coats chain]
     *   ORE(0xE8B)     gated by g_count_8E66 + colony_query(0xF)==colony_query(0xE)
     *   TOOLS(0xE8F)   gated by g_count_8E76 + colony_query(0xF)
     * Each `if (counter != 0 && chain_absent) report(...)`.
     * @asm pattern: 0x2E37A CMP [0x8E64],0; ... 0x2E385 PUSH 0x10; LCALL
     *               0x181F:0xB50; OR/JNE skip; report 0xE66. (repeated 7x). */
    /* (the seven if-blocks are byte-identical in shape; cited individually in
     *  the ledger above.) */

    /* @asm 0x2E4FF..0x2E521  TOOLS overflow folded into ctx->byte[+0x92] (the
     * colony's tool surplus word), clamped >= 0. */
    {
        int tools = colony_query(0x10, 0);                  /* @asm 0x2E4FF LCALL 0x181F:0xB50 (commodity 0x10) */
        int v;                                              /* +0x92 surplus */
        /* @asm 0x2E50F ADD [bx+0x92],ax */
        v = 0; (void)v; (void)tools;
        /* @asm 0x2E51B OR/JGE; 0x2E51F SUB ax,ax  clamp >=0 */
    }

    /* ========================================================================
     * PHASE 9 — building-needs / cargo-ready / NEEDTOOLS / SPOIL notices.
     * @asm 0x2E525..0x2EAB2
     *   - ctx->byte[+0x94] (next-building id) → colony_query(0xCC2) yields the
     *     build state; band 1 ⇒ NEEDTOOLS(0xEA1); else CARGOREADY0(0xEBB).
     *     @asm 0x2E552 CALL 0x181F:0xCC2; 0x2E648 PUSH 0xEA1; 0x2E662 PUSH 0xEAB.
     *   - SPOIL1(0xEAD)/SPOIL2(0xEB4): warehouse overflow spoilage (cargo > cap),
     *     @asm 0x2E8B8 PUSH 0xEAD / 0x2E8BE PUSH 0xEB4.
     *   - ALREADYHAVE(0xE95): trying to (re)build something the colony has,
     *     @asm 0x2E5C5 PUSH 0xE95.
     *   - TUTORIAL6(0xEC7): one-shot capital-raze / endgame tutorial latch,
     *     @asm 0x2E9DC TEST [0x5387],2; 0x2EA41 PUSH 0xEC7; 0x2EA4C OR [0x5387],2.
     * ====================================================================== */
    /* (the cargo/spoil/needtools detail is bookkeeping over the +0x94/+0xB6
     *  fields and the warehouse-cap; message keys cited above.) */

    /* ========================================================================
     * PHASE 10 — power-level bells tally + best-non-food horse seeding.
     * @asm 0x2E6B7..0x2E6EB
     *   g_power_block_8808[owner*0x13C + 0x2E] += g_8DEA   (this colony's bells
     *     added to the per-power per-turn total at DGROUP:0x8836 = PowerRecord
     *     +0x2E).  @asm 0x2E6B7 ax=[0x8DEA]; 0x2E6BA IMUL bx,[bp-0x12A],0x13C;
     *     0x2E6C0 ADD [bx-0x77CA],ax  (-0x77CA == base 0x8808 + 0x2E).
     *   seed = (g_table_A893 == 5) ? 1 : 0;  then a (×6, ÷2) shape builds a
     *     horse-distribution amount: si=((seed*2+seed)... )>>1.
     *     @asm 0x2E6C4 CMP [0xA893],5; 0x2E6D6 LCALL 0x181F:0xB82;
     *     0x2E6DE..0x2E6EB → [bp-0xA]. */
    {
        int seed;
        g_power_block_8808[owner * 0x13C + 0x2E] += g_8DEA; /* @asm 0x2E6B7/0x2E6C0 ADD [bx-0x77CA],ax (PowerRecord +0x2E) */
        seed = (g_table_A893 == 5) ? 1 : 0;                 /* @asm 0x2E6C4 CMP [0xA893],5 → 1/0 */
        colony_misc_b82(5);                                 /* @asm 0x2E6D6 LCALL 0x181F:0xB82 */
        /* @asm 0x2E6DE..0x2E6EB  si = ((seed<<1)+seed)*? )>>1  (×6/2 horse seed) */
        (void)seed;
    }

    /* ========================================================================
     * PHASE 11 — per-colonist food/horse distribution ring (the big 16-slot
     * loops at @asm 0x2E6EE..0x2EAB2).  Distributes the colony's food/horse
     * surplus across colonist slots, accrues each colonist's per-turn change
     * into the power score longs (+0x2A/+0x2C and +0xBC/+0xBE), and emits the
     * CARGOREADY0 / graduation events.  Concludes with:
     *   - the graduation accumulator at PowerRecord +0x51/+0x52
     *     (@asm 0x2C73B-style; here +0x13C-stride byte writes @asm 0x2E73B/0x2E75C)
     *   - the per-turn report drain: while (g_report_count_A896 != 0) { ... ;
     *     g_report_count_A896-- } (@asm 0x2EA94..0x2EA9D)
     *   - if any report shown, finalize the colony (@asm 0x2EAA6 LCALL
     *     0x181F:0x608) and set g_dword_034A = 0xFFFF (@asm 0x2EAB2).
     * ====================================================================== */
    {
        /* report drain @asm 0x2EA98 */
        while (g_report_count_A896 != 0) {                  /* @asm 0x2EA98 CMP [0xA896],0/JNE 0x2EA62 */
            /* @asm 0x2EA62..0x2EA94: a difficulty-scaled colonist "graduate"
             * roll (option_bit_test1(difficulty+1)); on success increment the
             * colony's graduation byte ctx->byte[+0x97], rolling at 0x32 (50). */
            int diff_p1 = (int)(uint8_t)g_difficulty_53A6 + 1; /* @asm 0x2EA62 al=[0x53A6]; INC */
            if (option_bit_test1(diff_p1)) {                /* @asm 0x2EA6B LCALL 0x181F:0x4D4 */
                ctx->pad_96_99[1]++; /* +0x97 */            /* @asm 0x2EA7B INC byte[bx+0x97] */
                if ((uint8_t)ctx->pad_96_99[1] >= 0x32) {   /* @asm 0x2EA7F CMP 0x32/JB */
                    ctx->pad_96_99[1] -= 0x32;              /* @asm 0x2EA8A SUB 0x32 */
                    colony_event_82((int)g_8DC6); /* @asm 0x2EA91 CALL cs:0x2450 (→graduation) */
                }
            }
            g_report_count_A896--;                          /* @asm 0x2EA94 DEC [0xA896] */
        }

        if (g_report_shown_A898 != 0) {                     /* @asm 0x2EA9F CMP [0xA898],0/JE 0x2EAB2 */
            colony_finalize_8DC6((int)g_8DC6); /* @asm 0x2EAA6 LCALL 0x181F:0x608 */
        }
        g_dword_034A = 0xFFFF;                              /* @asm 0x2EAB2 MOV [0x34A],0xFFFF */
    }
    /* @asm 0x2EAB8 POP si; POP di; LEAVE; RETF */
}

/* ============================================================================
 * colony_screen_open — name retained for the FUNCTION_INVENTORY/callgraph.
 * The historical disasm/func_02D658_unknown.asm labelled this entry
 * "colony_screen_open(colony_id)"; the full byte trace (this file) shows it is
 * the per-colony SoL/Tory/training/food turn handler.  Thin alias so existing
 * references stay valid.
 * ============================================================================ */
void colony_screen_open(int colony_id)
{
    colony_sol_tory_turn(colony_id);   /* @asm 0x2D658 is the single entry */
}
