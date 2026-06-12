/* ============================================================================
 *        >>> BYTE-VERIFIED (func_03C322 / func_03BFD2 / helpers) <<<
 * ----------------------------------------------------------------------------
 * congress.c -- Continental Congress: liberty-bell accumulation, the
 * "next Founding Father" availability/notification, and the Congress
 * election screen that ultimately calls ff_acquire_dispatch (func_03BC42,
 * see effects.c).
 *
 * Every function below is hand-decompiled from the re-segmented overlay
 * page 0x06 (code/VICEROY/disasm_overlay_reseg/page_06.asm). Page 0x06
 * file image base = 0x03B380; display IP = file - 0x03B380. All @asm
 * citations are absolute VICEROY.EXE file offsets, spot-checked against the
 * raw bytes (see VERIFICATION_LEDGER.md 2026-05-30 entry).
 *
 * Purpose was confirmed by STRING xref FIRST (the brief's method):
 *   - func_03C322 pushes dgroup 0x126f="AMBUSHHINT" + 0x127a="CONSIDER"
 *     (file 0x1EC0F / 0x1EC1A via base 0x1D9A0) — the "a new Founding Father
 *     may now be elected" Congress notification.
 *   - func_03BFD2 passes dgroup 0x1262="WHICHFREEDOM" (file 0x1EC02) — the
 *     Continental-Congress *election* screen title ("which freedom/father?").
 *   - func_03BC42 (effects.c) uses dgroup 0x125a="FREEDOM" — the acquire popup.
 *
 * ============================================================================
 * THE FULL CONGRESS / FOUNDING-FATHER SCREEN CHAIN  (ROUTE_B 3.2, 2026-06-12;
 * every hop disassembled + whois-verified; stale resolutions corrected):
 *
 *   turn path (per colony):
 *     func_02D658 colony_sol_tory_turn  @0x2D658  (src/colony/sol_tory.c)
 *       bells = colony_query(0x12,0)              @asm 0x2D696 0x181F:0xB50
 *       lcall 0x191F:0x9F8 (power, bells)         @asm 0x2D6A7
 *         -> page06+0xA22 = file 0x3C322 = ff_bells_tick (THIS FILE)  [WIRED]
 *
 *   ff_bells_tick (func_03C322):
 *     pending<0 && !independence  -> call cs:0x1081 = ljmp 0x1A1F:0x0000
 *         -> func_03BFD2 = ff_congress_screen (THIS FILE; the thunk re-enters
 *            the page-06 election body — corrected: NOT a separate function)
 *     bells filled, pre-independence, pending>=0 -> call cs:0x107C
 *         = ljmp 0x191F:0xFEC -> func_03BC42 ff_acquire_dispatch (effects.c)
 *     bells filled, POST-independence -> lcall 0x191F:0x348
 *         -> func_03D948 = @FRIEND "foreign general joins" handler
 *            (src/king/intervention.c foreign_intervention; the old
 *            "cong_screen_a" reading was WRONG — post-independence bells buy
 *            intervention, not Congress)                      [WIRED]
 *
 *   ff_congress_screen (func_03BFD2) — the SELECTION DIALOG:
 *     dlg_open  = 0x191F:0x182 -> func_06F0F4 text_template_run = the SAME
 *                 GAME.TXT template engine as menu_runner.c 3.1 ("GAME" base
 *                 DS:0x87C + key DS:0x1262 "WHICHFREEDOM")
 *     dlg_add_row = 0x191F:0x176 -> func_06C850 panel_append_button
 *                 (value = category+1 @asm 0x3C1E9 inc ax)
 *     dlg_run   = 0x191F:0x16A -> func_06E3D0 panel_run_modal
 *     dlg_free  = 0x191F:0x1A8 -> func_0789FA free_dos_block
 *     (modern: all four are STRONG overrides in src/ui/menu_runner.c that
 *      ride the ported 3.1 engine)                            [WIRED]
 *
 *   ff_acquire_dispatch (func_03BC42, effects.c) — on election win:
 *     0x181F:0x998 ("GAME" + key 0x125A "FREEDOM") = the 3.1 menu shim
 *                 func_06F51A -> boxed acquire popup           [WIRED]
 *     cs:0x1077 = ljmp 0x191F:0xF74 -> func_03BB4A cc_screen_background =
 *                 the CONGRESS SCREEN COMPOSER ("CCBKGD" backdrop + CC-NN.SS
 *                 portrait plates; modern port src/ui/congress_screen.c)
 *                                                              [WIRED]
 *     0x1A1F:0x62 -> func_06AE08 single_label_value_dialog = the FF
 *                 announcement banner (pushes "FATHER" @0x6AEC4) [WIRED]
 *
 *   second composer entry: func_037A10 report_congress (F3) tail
 *     @asm 0x3806E push -1; push player; 0x38073 lcall 0x191F:0xF74
 *     -> cc_screen_background(player, -1)  (hall view, no reveal)  [WIRED in
 *        src/ui/report_screen.c]
 * ============================================================================
 *
 * RESOLVES two items the prior pass left unresolved (VERIFICATION_LEDGER.md 2026-05-29):
 *   1. "Bell accumulator (+0x0C/+0x0E) + Continental-Congress trigger" → here
 *      (func_03C322). Independently corroborated by docs/DATA_MODEL.md:313
 *      (PowerRecord+0x0C = bells_toward_next_ff, RESETS on acquisition; +0x0E
 *      = bells per turn).
 *   2. "FF owned bitmap PowerRecord+0x07 set on acquire" → ff_set_owned_bit
 *      (func_03B900, in recruit.c).
 *
 * bell-COST threshold: produced by the getter ff_bells_required (0x191F:0x0F66).
 * RESOLVED 2026-05-30 via the RTLink tool: 0x191F:0x0F66 -> page 0x06 +0x982 ->
 * file **0x03C282** = func_03C282 ff_bell_cost_curve, byte-ported in
 * src/overlay/overlay_038A50_03C5A8.c (modern bridge in ui/congress_screen.c).
 *
 * MODERN-SAFETY (2026-06-12): all DGROUP accesses converted to DG accessors
 * (dgroup.h) — the previous raw absolute pointers ("*(int16_t *)0x9652") and
 * the g_active_power extern (which the link floor binds to the NAVAL word at
 * 0x5394, NOT the [0x84FC] PowerRecord slot) would fault the moment the turn
 * path executed this file.  The [0x84FC] slot holds a DGROUP OFFSET in the
 * modern convention (market_set_active, pricing.c).
 *
 * BYTE-TRUTH FIXES (2026-06-12, against re_work/disasm/func_03BFD2.asm):
 *   - AI path WAS MISSING: power>=4 or controller!=0 jumps to 0x3C25E with
 *     AX = ff_present_primer result (the best-offer CATEGORY) and stages
 *     pending_ff = chosen[best_cat]  (@asm 0x3C101/0x3C107 -> 0x3C25E).
 *   - ESC / no-pick (chosen_idx<=0) RE-OPENS the dialog (@asm 0x3C236
 *     jmp 0x3C12B — the Congress pick is mandatory), as does the
 *     [0x1F68] animate path (@asm 0x3C25B jmp 0x3C12B, NOT the build loop).
 *   - ui_key_print arg order corrected: key=[bp+6], flag=[bp+8]
 *     (func_06F5F2 @0x6F5F8 mov ax,[bp+6] -> menu key; [0x1F5E]=[bp+8]).
 * ============================================================================ */
#include "viceroy_types.h"
#include "dgroup.h"
#include "power.h"
#include "ff.h"

/* ----------------------------------------------------------------------------
 * VERIFIED DGROUP homes (all accessed through DG accessors below). @asm cites:
 *   0x84FC  active PowerRecord slot (near offset)  @asm 03C332 mov bx,[0x84fc]
 *   0x538A  current year                           @asm 03B963 cmp [0x538a],0x640
 *   0x5382  game-phase flag byte (bit0=independence declared, bit1=boycott,
 *           bit2=congress-notified latch; cross-ref scoring/compute.c)
 *                                                  @asm 03C33C test [0x5382],1
 *   0x53D4  arg pushed to 0x191F:0xAC8             @asm 03C36C
 *   0x543F  AIPersonality controller column, stride 0x34 (0=human)
 *                                                  @asm 03C10A imul bx,[bp+6],0x34
 *   0x2E88  global word appended to row text (RUNTIME_ONLY) @asm 03C1CA
 *   0x1F66  dialog-active flag                     @asm 03C20A mov [0x1f66],1
 *   0x1F68  "animate-pick" mode                    @asm 03C240 cmp [0x1f68],0
 * ---------------------------------------------------------------------------- */

/* ----------------------------------------------------------------------------
 * The 25-entry in-MEMORY Founding-Father table at DGROUP:0x9652, stride 6.
 * (Populated at startup by the NAMES.TXT loader func_0749E0 from @FATHERS;
 *  @ref MEMORY.md names_txt_authoritative. The on-disk @FATHERS columns are
 *  transcribed in recruit.c FF_TABLE[].)
 *
 * Record layout (BYTE_VERIFIED by index arithmetic ff_id*6 across page 0x06):
 *   +0x00 word  per-FF name/flag string handle (pushed to power_set_flag)
 *                                                      @asm 03BC78 [bx-0x69ae]
 *   +0x02 byte  category (0..4 == @FATHERS "type")     @asm 03B9B0 [bx-0x69ac]
 *   +0x03 byte  AI weight, era band 0 (year < 1600)    @asm 03B9C7 [bx+si-0x69ab]
 *   +0x04 byte  AI weight, era band 1 (1600 <= year < 1700)   (si=2)
 *   +0x05 byte  AI weight, era band 2 (year >= 1700)          (si=4)
 * (-0x69ae == DGROUP 0x9652, since (0x10000-0x69ae)&0xffff == 0x9652.)
 *
 * A 6-WORD TABLE at DGROUP:0x96E8 (loaded from NAMES.TXT @FOUNDING section,
 * cnt=6, by func_0749E0 @asm 0x075109: word[i-0x6918] = overlay_call_1A1F_0B16()).
 * Each word is a STRING HANDLE; entries 0..4 are indexed by FF category in the
 * congress row builder: @asm 03C1AE push [si-0x6918] where si = cat*2. */
#define FF_MEM_BASE   0x9652   /* word[0]=handle, byte[2]=cat, byte[3..5]=era weights */
#define FF_MEM2_BASE  0x96E8   /* 6-word FOUNDING string-handle table: [cat*2] = per-cat text */

/* ----------------------------------------------------------------------------
 * Overlay helpers. Call sites/args BYTE_VERIFIED at the @asm sites; the modern
 * bindings (strong overrides of the weak link-floor stubs) live in
 * src/ui/congress_screen.c + src/ui/menu_runner.c — chain map in the banner.
 * ---------------------------------------------------------------------------- */
extern void ff_announce(int power);            /* 0x181F:0x0582 -> func_030550 market_set_active (sets [0x9E12]+[0x84FC]) @asm 03BFE2 / 03C328 */
extern int  ff_owned(int ff_id, int power);    /* 0x181F:0x07B4 -> func_00BC10 (resident; REAL arg order (power,ff) — the
                                                * bridge swaps; call sites here push (ff, power) @asm 03C091/03C094) */
extern int  random_int(int lo, int hi);        /* 0x181F:0x04D4 -> file 0x0C322 (resident; src/runtime/rng.c) @asm 03C0DB */
extern void ff_msg_open(int arg);              /* 0x181F:0x04AC -> func_005108 (resident; track/view stage) @asm 03C123 push 3 */
extern int  ff_present_primer(int power);      /* call cs:0x108b -> ljmp 0x1A1F:0x001C -> func_03BA5A ff_best_offer_category
                                                * @asm 03C0F9; result -> [bp-0x56]; CONSUMED BY THE AI PATH @0x3C25E */
extern void ff_animate_pre(void);              /* 0x181F:0x056A -> file 0x0C136 (resident push-leaf; not in any span) @asm 03C256 */
extern void ff_pre_b(int ff_id);               /* 0x1A1F:0x0062 -> func_06AE08 single_label_value_dialog (the FF banner;
                                                * pushes "FATHER" dg 0x1EFA @0x6AEC4) @asm 03C24E */

/* 0x191F selection-screen feed — ALL FOUR resolve into the 3.1 menu engine
 * (whois 2026-06-12; the old "file 0x028BA4/0x026300/0x027E80/0x025AAA"
 * resolutions were stale digit-shuffles):
 *   dlg_open    0x191F:0x0182 -> page23+0x32A4 = func_06F0F4 text_template_run
 *   dlg_add_row 0x191F:0x0176 -> page23+0x0A00 = func_06C850 panel_append_button
 *   dlg_run     0x191F:0x016A -> page23+0x2580 = func_06E3D0 panel_run_modal
 *   dlg_free    0x191F:0x01A8 -> page31+...    = func_0789FA free_dos_block
 * Strong modern implementations: src/ui/menu_runner.c (dlg_* family). */
extern void *dlg_open(void *ctx_key, void *title_key, int z); /* @asm 03C135 ("WHICHFREEDOM") */
extern void  dlg_add_row(void *dlg, char *text, int value);   /* @asm 03C1F6 (value = cat+1) */
extern int   dlg_run(void *dlg);                              /* @asm 03C216 -> committed row VALUE */
extern void  dlg_free(void *dlg);                             /* @asm 03C224 */

/* Type-A near thunks in page 0x06 (thunk row @file 0x3C3F1..0x3C423,
 * disassembled 2026-06-12 — each `call cs:0x10xx` lands on an ljmp):
 *   cs:0x1072 -> ljmp 0x191F:0xF66  = func_03C282 ff_bell_cost_curve
 *   cs:0x1077 -> ljmp 0x191F:0xF74  = func_03BB4A cc_screen_background
 *   cs:0x107C -> ljmp 0x191F:0xFEC  = func_03BC42 ff_acquire_dispatch
 *   cs:0x1081 -> ljmp 0x1A1F:0x0000 = func_03BFD2 ff_congress_screen (SELF-page)
 *   cs:0x1086 -> ljmp 0x1A1F:0x000E = func_03BA26 ff_format_name_row
 *   cs:0x108B -> ljmp 0x1A1F:0x001C = func_03BA5A ff_best_offer_category
 *   cs:0x1090 -> ljmp 0x1A1F:0x002A = func_03BAA6 ff_portraits_draw
 *   cs:0x1095 -> ljmp 0x1A1F:0x0038 = func_03B900 ff_set_owned_bit
 *   cs:0x109A -> ljmp 0x1A1F:0x0046 = func_03B95A ff_era_band
 *   cs:0x109F -> ljmp 0x1A1F:0x0054 = func_03B980 ff_count_offerable_in_cat */
extern int  ff_bells_required(int power);      /* cs:0x1072 @asm 03C37F/03C3B1 -> func_03C282 */
extern void ff_become_available(int power);    /* cs:0x1081 @asm 03C34D -> ff_congress_screen */
extern int  ff_category_band(int power);       /* cs:0x109A @asm 03BFEB -> func_03B95A (era band; arg unused by body) */
extern int  ff_cat_candidate(int cat, int pw); /* cs:0x109F @asm 03C07F/03C165 -> func_03B980 (REAL order (power,cat); bridge swaps) */
extern void ff_log_notify(int idx, int ff, int pw); /* cs:0x107C @asm 03C3DC -> func_03BC42 ff_acquire_dispatch(power,ff)
                                                * (pushes 0,ff,power -> callee [bp+6]=power,[bp+8]=ff, trailing 0 unused) */
extern void ff_notify_sound(long n, int z);    /* 0x181F:0x09AE -> func_06C27C dialog_slot_set_pair(slot=z, lo, hi)
                                                * = stage the bells-required NUMBER into message slot z @asm 03C389 */
extern void ui_key_print(int key, int flag);   /* 0x181F:0x0652 -> func_06F5F2: [0x1F5E]=flag([bp+8]); AX=key([bp+6]);
                                                * BX=0x87C "GAME"; DX=0 -> 0x181F:0x998 menu shim = BOXED GAME.TXT key.
                                                * (arg order fixed 2026-06-12: key first) @asm 03C395/03C3A1 */
extern void cong_anim(int a, int b, int c);    /* 0x191F:0x0AC8 -> func_06C254 dialog_make_from_str; push order
                                                * [0x53D4],1,0 -> callee args (0,1,[0x53D4]) @asm 03C374 */
extern void cong_screen_a(void);               /* 0x191F:0x0348 -> func_03D948 = @FRIEND foreign-general-joins handler
                                                * (king/intervention.c foreign_intervention) — POST-INDEPENDENCE bells
                                                * buy intervention @asm 03C3CD (corrected 2026-06-12; was misread as a
                                                * "congress screen" entry) */

/* ============================================================================
 * ff_bells_tick -- func_03C322 @0x03C322  (page 0x06, push bp;mov bp,sp, RETF)
 * ----------------------------------------------------------------------------
 * Per-power liberty-bell accumulation + Continental-Congress trigger. Called
 * each turn with the bells produced this turn.
 *   power == [bp+6] : the power
 *   bells == [bp+8] : liberty bells produced this turn (signed)
 *
 * Behaviour (BYTE_VERIFIED):
 *   p = [0x84FC]; p->bells_toward_next (+0x0C) += bells;
 *                 p->bells_per_turn    (+0x0E) += bells;
 *   if (!(g_game_phase & 1) && p->pending_ff (+0x12) < 0)  ff_become_available(power);
 *   if ( (g_game_phase & 1) && !(g_game_phase & 6) && p->bells_toward_next > bells)
 *        { ...Congress-newly-unlocked animation + "AMBUSHHINT"/"CONSIDER"
 *          notification; set g_game_phase |= 4; }
 *   if (ff_bells_required(power) <= p->bells_toward_next) {
 *        if (g_game_phase & 1) { if (!(g_game_phase & 2)) cong_screen_a(); }
 *        else if (p->pending_ff >= 0) ff_log_notify(0, p->pending_ff, power);
 *        p->bells_toward_next = 0;     // RESET on acquisition (DATA_MODEL.md:313)
 *   }
 * ---------------------------------------------------------------------------- */
void ff_bells_tick(int power, int bells)
{
    unsigned p;                                          /* PowerRecord near offset */

    ff_announce(power);                                  /* @asm 03C328 lcall 0x181f,0x582 */
    p = DG16(0x84FC);                                    /* @asm 03C332 mov bx,[0x84fc] */
    DGS16(p + 0x0C) = (int16_t)(DGS16(p + 0x0C) + bells); /* @asm 03C336 add [bx+0xc],ax  bells_toward_next */
    DGS16(p + 0x0E) = (int16_t)(DGS16(p + 0x0E) + bells); /* @asm 03C339 add [bx+0xe],ax  bells_per_turn */

    /* @asm 03C33C: if (!(phase & 1) && pending_ff < 0) run the election */
    if (!(DG8(0x5382) & 0x01) &&                         /* @asm 03C33C test [0x5382],1 ; je past */
        DGS16(p + 0x12) < 0) {                           /* @asm 03C343 cmp [bx+0x12],0 ; jge */
        ff_become_available(power);                      /* @asm 03C34D call cs:0x1081 -> ff_congress_screen */
    }

    /* @asm 03C352: if ((phase & 1) && !(phase & 6) && bells_toward_next > bells)
     *   -> Congress just unlocked (post-independence intervention notice) */
    if ((DG8(0x5382) & 0x01) &&                          /* @asm 03C352 test [0x5382],1 ; je 0x102d */
        !(DG8(0x5382) & 0x06) &&                         /* @asm 03C359 test [0x5382],6 ; jne 0x102d */
        DGS16(p + 0x0C) > bells) {                       /* @asm 03C367 cmp [bx+0xc],ax ; jle 0x102d */
        cong_anim((int)DGS16(0x53D4), 1, 0);             /* @asm 03C374 push [0x53d4];push 1;push 0; lcall 0x191f,0xac8 */
        {
            long req = (long)ff_bells_required(power);   /* @asm 03C37F call cs:0x1072 (ljmp 0x191f,0xf66) */
            ff_notify_sound(req, 0);                     /* @asm 03C384 cdq;push dx;push ax;push 0; lcall 0x181f,0x9ae */
        }
        ui_key_print(0x126F /* "AMBUSHHINT" */, 1);      /* @asm 03C392 push 1;push 0x126f; lcall 0x181f,0x652 */
        ui_key_print(0x127A /* "CONSIDER"   */, 1);      /* @asm 03C39E push 1;push 0x127a; lcall 0x181f,0x652 */
        DG8(0x5382) |= 0x04;                             /* @asm 03C3A8 or byte [0x5382],4 */
    }

    /* @asm 03C3AD: if (ff_bells_required(power) <= bells_toward_next) {...; reset} */
    if (ff_bells_required(power) <= DGS16(p + 0x0C)) {   /* @asm 03C3B1 call cs:0x1072 ; 03C3BA cmp ax,[bx+0xc] ; jg 0x106f */
        if (DG8(0x5382) & 0x01) {                        /* @asm 03C3BF test [0x5382],1 ; je 0x1054 */
            if (!(DG8(0x5382) & 0x02))                   /* @asm 03C3C6 test [0x5382],2 ; jne 0x106f */
                cong_screen_a();                         /* @asm 03C3CD lcall 0x191f,0x348 -> func_03D948 @FRIEND */
        } else if (DGS16(p + 0x12) >= 0) {               /* @asm 03C3D4 cmp [bx+0x12],0 ; jl 0x1066 */
            ff_log_notify(0, (int)DGS16(p + 0x12), power); /* @asm 03C3DC push 0;push [bx+0x12];push pw; call cs:0x107c */
        }
        p = DG16(0x84FC);                                /* @asm 03C3E6 mov bx,[0x84fc] */
        DGS16(p + 0x0C) = 0;                             /* @asm 03C3EA mov [bx+0xc],0  RESET bells_toward_next */
    }
    /* @asm 03C3EF leave / 03C3F0 retf */
}

/* ============================================================================
 * ff_congress_screen -- func_03BFD2 @0x03BFD2  (page 0x06, ENTER 0x74,0, RETF)
 * ----------------------------------------------------------------------------
 * The Continental-Congress *election*: build the per-category candidate set,
 * choose one Founding Father per category by WEIGHTED RANDOM over the era-band
 * weights (FF_MEM_BASE+0x03..+0x05), then:
 *   - HUMAN power (power<4 && controller==0): present the "WHICHFREEDOM"
 *     dialog (template engine + 5 appended rows, value=cat+1); the pick is
 *     MANDATORY — ESC/no-pick re-opens (@asm 0x3C236 jmp 0x3C12B);
 *     the [0x1F68] animate mode previews the pick then re-opens.
 *   - AI power: pending_ff = chosen[ff_present_primer(power)] (the best-offer
 *     category's candidate) — @asm 0x3C101/0x3C107 jmp 0x3C25E.
 * The staged PowerRecord+0x12 is consumed by ff_bells_tick -> ff_log_notify
 * -> ff_acquire_dispatch when the bell pool fills.
 *   power == [bp+6]
 *
 * Locals (frame, ENTER 0x74):
 *   chosen[5]   = [bp-0x74 .. bp-0x6B] : per-category chosen ff_id (word, 0xFFFF=none)
 *   cat         = [bp-0x68] : category loop index 0..4
 *   ff          = [bp-0x6a] : ff_id loop index 0..24
 *   pick        = [bp-0x66] : ff_id selected in the weighted pass (0xFFFF=none)
 *   sum/budget  = [bp-0x64]/[bp-0x62] : weight sum, then random budget
 *   band        = [bp-0x54] : era band (ff_category_band)
 *   n_categories= [bp-2]    : count of categories that had >=1 candidate
 *   dlg lo/hi   = [bp-0x5e]/[bp-0x5c] : far dlg handle
 *   primer/sel  = [bp-0x56] : primer result, then (chosen_idx-1)
 * ---------------------------------------------------------------------------- */
void ff_congress_screen(int power)
{
    int16_t chosen[5];          /* @asm bp-0x74 base, indexed by cat*2 */
    int cat, ff;
    int pick;                   /* [bp-0x66] */
    int sum, budget;            /* [bp-0x64] / [bp-0x62] */
    int band;                   /* [bp-0x54] */
    int n_categories = 0;       /* [bp-2] */
    void *dlg = 0;              /* [bp-0x5e:bp-0x5c] */
    int chosen_idx = 0;         /* [bp-0x58] */
    int sel;                    /* [bp-0x56] (primer result / pick index) */

    ff_announce(power);                                  /* @asm 03BFE2 lcall 0x181f,0x582 */
    band = ff_category_band(power);                      /* @asm 03BFEB call cs:0x109a -> era band */

    /* ---- build chosen[cat] for each of the 5 categories ---- */
    for (cat = 0; cat < 5; cat++) {                      /* @asm 03BFF6 cat=0 ; 03C060 cmp [bp-0x68],5 */
        chosen[cat] = (int16_t)0xFFFF;                   /* @asm 03C06E mov [bp+si-0x74],0xffff */
        sum = 0;                                         /* @asm 03C073 mov [bp-0x64],0 */
        if (ff_cat_candidate(cat, power) == 0)           /* @asm 03C07F call cs:0x109f ; 03C085 or ax,ax ; je 0xcdd */
            continue;                                    /* category has no offerable FF */
        n_categories++;                                  /* @asm 03C089 inc [bp-2] */

        /* PASS A: sum era-band weights of every UN-owned FF in this category */
        for (ff = 0; ff < 25; ff++) {                    /* @asm 03C08C ff=0 ; 03C0D0 cmp [bp-0x6a],0x19 */
            if (ff_owned(ff, power))                     /* @asm 03C091 push ff;push pw; lcall 0x7b4 ; 03C0A1 jne (skip owned) */
                continue;
            if (DG8(FF_MEM_BASE + (unsigned)ff * 6 + 0x02) != (uint8_t)cat) /* @asm 03C0B1 cmp [bx-0x69ac],al */
                continue;
            sum += (int)DG8(FF_MEM_BASE + (unsigned)ff * 6 + 0x03 + (unsigned)band); /* @asm 03C0C4 [bx+si-0x69ab]; 03C0CA add [bp-0x64],ax */
        }

        /* PASS B: weighted random pick over [1..sum] */
        budget = random_int(1, sum);                     /* @asm 03C0D9 push sum;push 1; lcall 0x181f,0x4d4 */
        pick = -1;                                       /* @asm 03C0E6 mov [bp-0x66],0xffff */
        for (ff = 0; ff < 25 && pick < 0; ff++) {        /* @asm 03C0EB ff=0 ; loop re-enters via jmp 0xccc while pick<0 */
            if (ff_owned(ff, power))                     /* @asm 03C012 jne (skip owned) */
                continue;
            if (DG8(FF_MEM_BASE + (unsigned)ff * 6 + 0x02) != (uint8_t)cat) /* @asm 03C022 cmp [bx-0x69ac],al */
                continue;
            budget -= (int)DG8(FF_MEM_BASE + (unsigned)ff * 6 + 0x03 + (unsigned)band); /* @asm 03C035/03C03B sub [bp-0x62],ax */
            if (budget <= 0)                             /* @asm 03C03E cmp [bp-0x62],0 ; jg (continue) */
                pick = ff;                               /* @asm 03C044 mov [bp-0x66],cx */
        }
        chosen[cat] = (int16_t)pick;                     /* @asm 03C052 mov [bp+si-0x74],ax (cat*2) */
    }

    /* ---- present / resolve ---- */
    sel = ff_present_primer(power);                      /* @asm 03C0F9 call cs:0x108b -> [bp-0x56] = best-offer category */

    if (power >= 4 ||                                    /* @asm 03C101 cmp [bp+6],4 ; jl -> human check */
        DG8(0x543F + (unsigned)power * 0x34) != 0) {     /* @asm 03C10A imul bx,[bp+6],0x34 ; 03C10E cmp [bx+0x543f],0 */
        /* --- AI power: stage the best-offer category's candidate ---
         * @asm 03C107/03C115 jmp 0x3C25E: si=AX*2; pending_ff = chosen[AX].
         * (Original quirk: when every FF is owned the primer returns 5 — the
         * Independence sentinel — and [bp+si-0x74] reads the adjacent local
         * [bp-0x6A]; guarded here, chosen[] is then -1/none anyway.) */
        if (sel >= 0 && sel < 5) {                       /* (guard for the documented quirk) */
            unsigned p = DG16(0x84FC);                   /* @asm 03C265 mov bx,[0x84fc] */
            DGS16(p + 0x12) = chosen[sel];               /* @asm 03C262/03C269 mov [bx+0x12],ax */
        }
        goto resolve_pending;                            /* falls into the free-tail @0x3C26C */
    }

    /* --- HUMAN power: the WHICHFREEDOM election dialog --- */
    if (n_categories == 0)                               /* @asm 03C118 cmp [bp-2],0 ; jne -> dialog ; je 0x3C26C */
        goto resolve_pending;                            /* no candidates at all */

    ff_msg_open(3);                                      /* @asm 03C121 push 3 ; lcall 0x181f,0x4ac
                                                          * (first pass only — the re-open jump @0x3C236
                                                          * lands AFTER it, at 0x3C12B) */
reopen_dialog:                                           /* @asm 0x3C12B (re-entered on ESC / animate) */
    dlg = dlg_open((void *)0x087C /*"GAME"*/,            /* @asm 03C12B lea bx,[0x87c] */
                   (void *)0x1262 /*"WHICHFREEDOM"*/, 0);/* @asm 03C12F lea ax,[0x1262]; 03C133 sub dx,dx; 03C135 lcall 0x191f,0x182 */
    if (dlg == 0)                                        /* @asm 03C140 or dx,ax ; jne ; je 0x3C26C */
        goto resolve_pending;
    *(int16_t *)((uint8_t *)dlg + 0x22) = 8;             /* @asm 03C14A mov es:[bx+0x22],8 — panel header word +0x22
                                                          * (row-x offset field per the draw chain @0x6DA54;
                                                          * the modern dlg handle reserves the header area) */

    if (n_categories != 0) {                             /* @asm 03C150 cmp [bp-2],0 ; jne build-rows */
        char rowbuf[0x52];                               /* @asm bp-0x52 work string */
        for (cat = 0; cat < 5; cat++) {                  /* @asm 03C159 cat=0 ; 03C201 cmp [bp-0x68],5 */
            if (ff_cat_candidate(cat, power) == 0)       /* @asm 03C165 call cs:0x109f ; 03C16B or ax,ax ; je skip */
                continue;                                /* (empty category emits no row) */
            rowbuf[0] = 0;                               /* @asm 03C172 mov [bp-0x52],0 */
            /* Row text (byte-cited append chain @0x3C186..0x3C1E3):
             *   0x181F:0x16E  append label  handle = FF name word [0x9652+ff*6]
             *   0x181F:0x178  append separator
             *   0x181F:0x11E  segment break (modern: single-space substitute —
             *                 the original starts a 2nd text segment here)
             *   0x181F:0x16E  append label  handle = FOUNDING cat text [0x96E8+cat*2]
             *   0x181F:0x178  append separator
             *   0x181F:0x16E  append label  handle = [0x2E88] (runtime word)
             *   0x181F:0x128  finalize (modern no-op) */
            {
                extern void ovly_text_applabel_16E(uint16_t labelptr, char *buf);
                extern void ovly_text_appsep_178(char *buf);
                int ffsel = chosen[cat];                 /* @asm 03C17B mov bx,[bp+si-0x74] */
                ovly_text_applabel_16E(DG16(FF_MEM_BASE + (unsigned)ffsel * 6), rowbuf); /* @asm 03C186/03C18E */
                ovly_text_appsep_178(rowbuf);            /* @asm 03C19A lcall 0x181f,0x178 */
                ovly_text_appsep_178(rowbuf);            /* @asm 03C1A6 0x181F:0x11E segment break (substitute) */
                ovly_text_applabel_16E(DG16(FF_MEM2_BASE + (unsigned)cat * 2), rowbuf);  /* @asm 03C1AE/03C1B6 (si=cat*2) */
                ovly_text_appsep_178(rowbuf);            /* @asm 03C1C2 lcall 0x181f,0x178 */
                ovly_text_applabel_16E(DG16(0x2E88), rowbuf); /* @asm 03C1CA push [0x2e88]; 03C1D2 0x181F:0x16E */
                /* @asm 03C1DE 0x181F:0x128 finalize (modern no-op) */
            }
            dlg_add_row(dlg, rowbuf, cat + 1);           /* @asm 03C1E6 ax=[bp-0x68]+1 ; 03C1F6 lcall 0x191f,0x176 */
        }
    }

    DG16(0x1F66) = 1;                                    /* @asm 03C20A mov [0x1f66],1 (dialog-active flag) */
    chosen_idx = dlg_run(dlg);                           /* @asm 03C216 lcall 0x191f,0x16a -> [bp-0x58] (committed VALUE) */
    dlg_free(dlg);                                       /* @asm 03C224 lcall 0x191f,0x1a8 */
    dlg = 0;                                             /* @asm 03C229 sub ax,ax; store [bp-0x5e]/[bp-0x5c] */

    /* @asm 03C231 cmp [bp-0x58],ax(0):
     *   <=0 (ESC / dismissed)  -> jmp 0x3C12B  RE-OPEN (pick is mandatory)
     *   >0: sel = value-1 (= category);
     *       [0x1F68] animate: preview banner then RE-OPEN (@asm 0x3C25B);
     *       else fall into 0x3C25E: pending_ff = chosen[sel]. */
    if (chosen_idx <= 0) {                               /* @asm 03C231/03C236 jmp 0x3C12B */
        extern int viceroy_interactive(void);
        if (viceroy_interactive())
            goto reopen_dialog;
        /* modern substitute: a headless run cannot block on a mandatory
         * dialog — fall through with no pick (pending stays unset). */
        goto resolve_pending;
    }
    sel = chosen_idx - 1;                                /* @asm 03C239/03C23C dec ax -> [bp-0x56] */
    if (DG16(0x1F68) != 0) {                             /* @asm 03C240 cmp [0x1f68],0 ; je 0x3C25E */
        ff_pre_b((int)chosen[sel]);                      /* @asm 03C24B push [bp+si-0x74]; 03C24E lcall 0x1a1f,0x62 */
        ff_animate_pre();                                /* @asm 03C256 lcall 0x181f,0x56a */
        goto reopen_dialog;                              /* @asm 03C25B jmp 0x3C12B */
    }
    {
        unsigned p = DG16(0x84FC);                       /* @asm 03C265 mov bx,[0x84fc] */
        DGS16(p + 0x12) = chosen[sel];                   /* @asm 03C25E si=ax*2; 03C262 ax=[bp+si-0x74]; 03C269 mov [bx+0x12],ax */
    }

resolve_pending:
    /* @asm 03C26C: if (dlg != 0) dlg_free(dlg); */
    if (dlg != 0)                                        /* @asm 03C26C ax=[bp-0x5c]|[bp-0x5e] ; je */
        dlg_free(dlg);                                   /* @asm 03C27A lcall 0x191f,0x1a8 */
    /* @asm 03C27F pop si / 03C280 leave / 03C281 retf */
    (void)band;
}

/* ============================================================================
 * NOTES:
 *   - ff_bells_required (cs:0x1072 -> 0x191F:0x0F66 -> file 0x03C282): the
 *     bell-cost CURVE, byte-ported as func_03C282_ff_bell_cost_curve
 *     (src/overlay/overlay_038A50_03C5A8.c); bridged in ui/congress_screen.c.
 *   - g_game_phase (DGROUP:0x5382) bit meanings cross-ref'd with scoring/compute.c:
 *     bit0=independence declared, bit1=boycott, bit2=congress-notified latch,
 *     bit8=war/revolution, bit0x10=independence won.
 *   - FF_MEM2_BASE (0x96E8): 6-word FOUNDING table (cat*2 index). The suffix
 *     handle [0x2E88] pushed into each row is RUNTIME_ONLY.
 *   - [0x53D4] (cong_anim arg), [0x1F66] dialog-active, [0x1F68] animate-pick:
 *     roles inferred from call context; RUNTIME_ONLY values.
 *   - The headless fall-through on a dismissed mandatory dialog and the 0x11E
 *     segment-break substitute are the only modern deviations; both are
 *     marked at their lines.
 * ============================================================================ */
