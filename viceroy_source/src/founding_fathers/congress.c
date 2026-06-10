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
 * file **0x03C282** (NOT the stale "0x026282" — that was a pre-tool mis-resolution).
 * = func_03C282 ff_bell_cost_curve, now byte-ported in
 * src/overlay/overlay_038A50_03C5A8.c. The CURVE (RESOLVED): difficulty-scaled
 * base, compounding x1.5 across the 4 era gates (years 0x640/0x672/0x6A4/0x6D6;
 * gate CMP[0x538A],0x640 @0x3C2B5), grows with owned-FF count, halved for the first
 * FF, flat override post-independence. (Runtime datum Brewster-next==129 is consistent.)
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"
#include "ff.h"

/* ----------------------------------------------------------------------------
 * VERIFIED globals (DGROUP). @asm citations below.
 * ---------------------------------------------------------------------------- */
extern struct PowerRecord *g_active_power;  /* DGROUP:0x84FC @asm 03C332 mov bx,[0x84fc] */
extern int16_t g_year;        /* DGROUP:0x538A current year (1500-based) @asm 03B963 cmp [0x538a],0x640 */
extern uint8_t g_game_phase;  /* DGROUP:0x5382 game-phase flag byte (bit0=independence declared,
                               * bit1=boycott, bit2=congress-notified latch, bit8=war/revolution,
                               * bit0x10=independence won; cross-ref'd scoring/compute.c) @asm 03C33C test [0x5382],1 */
extern int16_t g_num_powers;  /* DGROUP:0x539E power/colony loop bound (see effects.c) */
extern int16_t g_53d4;        /* DGROUP:0x53D4 arg pushed to 0x191F:0xAC8 (inferred: tune/sfx id) @asm 03C36C */
extern uint8_t g_ai_personality[]; /* DGROUP:0x543F stride 0x34, +0x00 controller (0=human) @asm 03C10A imul bx,[bp+6],0x34 */
extern int16_t g_2e88;        /* DGROUP:0x2E88 global word appended to row text (RUNTIME_ONLY) @asm 03C1CA */
extern int16_t g_1f66;        /* DGROUP:0x1F66 dialog-active flag @asm 03C20A mov [0x1f66],1 */
extern int16_t g_1f68;        /* DGROUP:0x1F68 "animate-pick" mode @asm 03C240 cmp [0x1f68],0 */

/* ----------------------------------------------------------------------------
 * The 25-entry in-MEMORY Founding-Father table at DGROUP:0x9652, stride 6.
 * (Populated at startup by the NAMES.TXT loader func_0749E0 from @FATHERS;
 *  @ref MEMORY.md names_txt_authoritative. The on-disk @FATHERS columns are
 *  transcribed in recruit.c FF_TABLE[].)
 *
 * Record layout (BYTE_VERIFIED by index arithmetic ff_id*6 across page 0x06):
 *   +0x00 word  per-FF flag/notify handle (pushed to power_set_flag)   @asm 03BC78 [bx-0x69ae]
 *   +0x02 byte  category (0..4 == @FATHERS "type")                     @asm 03B9B0 [bx-0x69ac]
 *   +0x03 byte  AI weight, era band 0 (year < 1600)                    @asm 03B9C7 [bx+si-0x69ab], si=era
 *   +0x04 byte  AI weight, era band 1 (1600 <= year < 1700)            (si=2)
 *   +0x05 byte  AI weight, era band 2 (year >= 1700)                   (si=4)
 * (-0x69ae == DGROUP 0x9652, since (0x10000-0x69ae)&0xffff == 0x9652.)
 *
 * A 6-WORD TABLE at DGROUP:0x96E8 (loaded from NAMES.TXT @FOUNDING section, cnt=6,
 * by func_0749E0 @asm 0x075109: word[i-0x6918] = overlay_call_1A1F_0B16()).
 * Entries 0..4 are indexed by FF category in the congress row builder:
 *   @asm 03C1AE  push [si-0x6918]  where si = cat*2 (NOT ffsel*6 as previously noted).
 * Entry 5 at DGROUP:0x96F2 is used by func_03BA26 as a standalone text token.
 * Semantic: per-category value displayed in each congress dialog row (likely the
 * current bells-required threshold for that category's available FF). BYTE_VERIFIED
 * 2026-06-10 against overlay_0745F0_077A6A.c @asm 0x075109 and func_03BFD2.asm. */
#define FF_MEM_BASE   0x9652   /* word[0]=handle, byte[2]=cat, byte[3..5]=era weights */
#define FF_MEM2_BASE  0x96E8   /* 6-word FOUNDING table: [cat*2] = per-cat display value */

/* ----------------------------------------------------------------------------
 * Overlay/load-image helpers. Call sites/args BYTE_VERIFIED; bodies in thunk page where
 * the resolved target is behind the blocked 0x191F/0x1A1F/0x181F overlay.
 * Resolved final file offsets from lcall_resolution_VICEROY.json.
 * ---------------------------------------------------------------------------- */
extern void ff_announce(int power);            /* 0x181F:0x0582 file 0x025900  @asm 03BFE2 / 03C328 */
extern int  ff_owned(int ff_id, int power);    /* 0x181F:0x07B4 -> nonzero if power owns ff_id (type-B, body in thunk page) @asm 03C008 */
extern int  random_int(int lo, int hi);        /* 0x181F:0x04D4 file 0x027DB2 (MEMORY.md byte-verified) @asm 03C0DB */
extern void ff_msg_open(int arg);              /* 0x181F:0x04AC file 0x022340  @asm 03C123 push 3 (presentation primer) */
extern int  ff_present_primer(int power);      /* call 0x108b -> ljmp 0x1A1F:0x001C  @asm 03C0FF; result -> [bp-0x56] */
extern void ff_animate_pre(void);              /* 0x181F:0x056A file 0x03240C  @asm 03C256 (same overlay
                                                * routine as effects.c ff_pre_a, but called argument-less
                                                * here: stack restored via `mov sp,bp` before the lcall) */
extern void ff_pre_b(int ff_id);               /* 0x1A1F:0x0062 file 0x027828  @asm 03C24E (mirrors effects.c ff_pre_b) */
extern void str_fmt_int(int v, char *buf);     /* 0x181F:0x016E file 0x06048A  @asm 03C18E append-int */
extern void str_append(char *buf);             /* 0x181F:0x0178 file 0x0603A8  @asm 03C19A append-substr/spacer */
extern void str_term_a(char *buf);             /* 0x181F:0x011E file 0x06041A  @asm 03C1A6 */
extern void str_term_b(char *buf);             /* 0x181F:0x0128 file 0x06042A  @asm 03C1DE */

/* 0x191F selection-screen feed (dialog overlay; bodies in thunk page): */
extern void *dlg_open(void *ctx_key, void *title_key, int z); /* 0x191F:0x0182 file 0x028BA4 @asm 03C135 ("WHICHFREEDOM") */
extern void  dlg_add_row(void *dlg, char *text, int idx);     /* 0x191F:0x0176 file 0x026300 @asm 03C1F6 */
extern int   dlg_run(void *dlg);                              /* 0x191F:0x016A file 0x027E80 @asm 03C216 -> chosen count/idx */
extern void  dlg_free(void *dlg);                             /* 0x191F:0x01A8 file 0x025AAA @asm 03C224 */

/* Type-A near thunks resolved in page 0x06 (file 0x03C322 region) → overlay
 * 0x1A1F (the FF-text overlay). Call sites verified; bodies in thunk page. */
extern int  ff_bells_required(int power);      /* call 0x1072 -> ljmp 0x191F:0x0F66 file 0x026282  @asm 03C37F/03C3B1 */
extern void ff_become_available(int power);    /* call 0x1081 -> ljmp 0x1A1F:0x0000             @asm 03C34D */
extern int  ff_category_band(int power);       /* call 0x109a -> ljmp 0x1A1F:0x0046             @asm 03BFEB (returns era/band index) */
extern int  ff_cat_candidate(int cat, int pw); /* call 0x109f -> ljmp 0x1A1F:0x0054 (count selectable in cat) @asm 03C07F/03C165 */
extern void ff_log_notify(int idx, int ff, int pw); /* call 0x107c -> ljmp 0x191F:0x0FEC file 0x0C5DC @asm 03C3E3 */
extern void ff_notify_sound(long n, int z);    /* 0x181F:0x09AE file 0x025D2C @asm 03C389 */
extern void ui_key_print(int z, int key);      /* 0x181F:0x0652 file 0x0290A2 @asm 03C395/03C3A1 (push "AMBUSHHINT"/"CONSIDER") */
extern void cong_anim(int a, int b, int c);    /* 0x191F:0x0AC8 file 0x025D04 @asm 03C374 */
extern void cong_screen_a(void);               /* 0x191F:0x0348 file 0x026E28 @asm 03C3CD */

/* ============================================================================
 * ff_bells_tick -- func_03C322 @0x03C322  (page 0x06, push bp;mov bp,sp, RETF)
 * ----------------------------------------------------------------------------
 * Per-power liberty-bell accumulation + Continental-Congress trigger. Called
 * each turn with the bells produced this turn.
 *   power == [bp+6] : the power
 *   bells == [bp+8] : liberty bells produced this turn (signed)
 *
 * Behaviour (BYTE_VERIFIED):
 *   p = g_active_power; p->bells_toward_next (+0x0C) += bells;
 *                       p->bells_per_turn    (+0x0E) += bells;
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
    struct PowerRecord *p;

    ff_announce(power);                                  /* @asm 03C328 lcall 0x181f,0x582 */
    p = g_active_power;                                  /* @asm 03C332 mov bx,[0x84fc] */
    *(int16_t *)((uint8_t *)p + 0x0C) += bells;          /* @asm 03C336 add [bx+0xc],ax  bells_toward_next */
    *(int16_t *)((uint8_t *)p + 0x0E) += bells;          /* @asm 03C339 add [bx+0xe],ax  bells_per_turn */

    /* @asm 03C33C: if (!(g_game_phase & 1) && pending_ff < 0) mark next available */
    if (!(g_game_phase & 0x01) &&                        /* @asm 03C33C test [0x5382],1 ; je past */
        *(int16_t *)((uint8_t *)p + 0x12) < 0) {         /* @asm 03C343 cmp [bx+0x12],0 ; jge */
        ff_become_available(power);                      /* @asm 03C34D call 0x1081 (ljmp 0x1a1f,0) */
    }

    /* @asm 03C352: if ((g_game_phase & 1) && !(g_game_phase & 6) &&
     *                  bells_toward_next > bells)  -> Congress just unlocked */
    if ((g_game_phase & 0x01) &&                         /* @asm 03C352 test [0x5382],1 ; je 0x102d */
        !(g_game_phase & 0x06) &&                        /* @asm 03C359 test [0x5382],6 ; jne 0x102d */
        *(int16_t *)((uint8_t *)p + 0x0C) > bells) {     /* @asm 03C367 cmp [bx+0xc],ax ; jle 0x102d */
        cong_anim(g_53d4, 1, 0);                         /* @asm 03C374 push [0x53d4];push 1;push 0; lcall 0x191f,0xac8 */
        {
            long req = (long)ff_bells_required(power);   /* @asm 03C37F call 0x1072 (ljmp 0x191f,0xf66) */
            ff_notify_sound(req, 0);                     /* @asm 03C384 cdq;push dx;push ax;push 0; lcall 0x181f,0x9ae */
        }
        ui_key_print(1, 0x126F /* "AMBUSHHINT" */);      /* @asm 03C392 push 1;push 0x126f; lcall 0x181f,0x652 */
        ui_key_print(1, 0x127A /* "CONSIDER"   */);      /* @asm 03C39E push 1;push 0x127a; lcall 0x181f,0x652 */
        g_game_phase |= 0x04;                            /* @asm 03C3A8 or byte [0x5382],4 */
    }

    /* @asm 03C3AD: if (ff_bells_required(power) <= bells_toward_next) {...; reset} */
    if (ff_bells_required(power) <=                      /* @asm 03C3B1 call 0x1072 ; 03C3BA cmp ax,[bx+0xc] ; jg 0x106f */
        *(int16_t *)((uint8_t *)p + 0x0C)) {
        if (g_game_phase & 0x01) {                       /* @asm 03C3BF test [0x5382],1 ; je 0x1054 */
            if (!(g_game_phase & 0x02))                  /* @asm 03C3C6 test [0x5382],2 ; jne 0x106f */
                cong_screen_a();                         /* @asm 03C3CD lcall 0x191f,0x348 */
        } else if (*(int16_t *)((uint8_t *)p + 0x12) >= 0) { /* @asm 03C3D4 cmp [bx+0x12],0 ; jl 0x1066 */
            ff_log_notify(0, *(int16_t *)((uint8_t *)p + 0x12), power); /* @asm 03C3DC push 0;push [bx+0x12];push pw; call 0x107c */
        }
        p = g_active_power;                              /* @asm 03C3E6 mov bx,[0x84fc] */
        *(int16_t *)((uint8_t *)p + 0x0C) = 0;           /* @asm 03C3EA mov [bx+0xc],0  RESET bells_toward_next */
    }
    /* @asm 03C3EF leave / 03C3F0 retf */
}

/* ============================================================================
 * ff_congress_screen -- func_03BFD2 @0x03BFD2  (page 0x06, ENTER 0x74,0, RETF)
 * ----------------------------------------------------------------------------
 * The Continental-Congress *election* feed: build the per-category candidate
 * set, choose one Founding Father per category by WEIGHTED RANDOM over the
 * era-band weights (FF_MEM_BASE+0x03..+0x05), present them ("WHICHFREEDOM"
 * screen) for a human power, then stage the chosen FF into pending-FF
 * (PowerRecord+0x12) so ff_acquire_dispatch picks it up.
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

    ff_announce(power);                                  /* @asm 03BFE2 lcall 0x181f,0x582 */
    band = ff_category_band(power);                      /* @asm 03BFEB call 0x109a (ljmp 0x1a1f,0x46) -> era band */

    /* ---- build chosen[cat] for each of the 5 categories ---- */
    for (cat = 0; cat < 5; cat++) {                      /* @asm 03BFF6 cat=0 ; 03C060 cmp [bp-0x68],5 */
        chosen[cat] = (int16_t)0xFFFF;                   /* @asm 03C06E mov [bp+si-0x74],0xffff */
        sum = 0;                                         /* @asm 03C073 mov [bp-0x64],0 */
        if (ff_cat_candidate(cat, power) == 0)           /* @asm 03C07F call 0x109f ; 03C085 or ax,ax ; je 0xcdd */
            continue;                                    /* category has no offerable FF */
        n_categories++;                                  /* @asm 03C089 inc [bp-2] */

        /* PASS A: sum era-band weights of every UN-owned FF in this category */
        for (ff = 0; ff < 25; ff++) {                    /* @asm 03C08C ff=0 ; 03C0D0 cmp [bp-0x6a],0x19 */
            if (ff_owned(ff, power))                     /* @asm 03C097 lcall 0x7b4 ; 03C0A1 jne (skip owned) */
                continue;
            if (*(uint8_t *)(FF_MEM_BASE + ff * 6 + 0x02) != (uint8_t)cat) /* @asm 03C0B1 cmp [bx-0x69ac],al */
                continue;
            sum += *(uint8_t *)(FF_MEM_BASE + ff * 6 + 0x03 + band);       /* @asm 03C0C4 al=[bx+si-0x69ab]; 03C0CA add [bp-0x64],ax */
        }

        /* PASS B: weighted random pick over [1..sum] */
        budget = random_int(1, sum);                     /* @asm 03C0D9 push sum;push 1; lcall 0x181f,0x4d4 */
        pick = (int16_t)0xFFFF;                          /* @asm 03C0E6 mov [bp-0x66],0xffff */
        for (ff = 0; ff < 25 && pick < 0; ff++) {        /* @asm 03C0EB ff=0 ; loop re-enters via jmp 0xccc while pick<0 */
            if (ff_owned(ff, power))                     /* @asm 03C012 jne (skip owned) */
                continue;
            if (*(uint8_t *)(FF_MEM_BASE + ff * 6 + 0x02) != (uint8_t)cat) /* @asm 03C022 cmp [bx-0x69ac],al */
                continue;
            budget -= *(uint8_t *)(FF_MEM_BASE + ff * 6 + 0x03 + band);    /* @asm 03C035 [bx+si-0x69ab]; 03C03B sub [bp-0x62],ax */
            if (budget <= 0)                             /* @asm 03C03E cmp [bp-0x62],0 ; jg (continue) */
                pick = ff;                               /* @asm 03C044 mov [bp-0x66],cx */
        }
        chosen[cat] = (int16_t)pick;                     /* @asm 03C052 mov [bp+si-0x74],ax (cat*2) */
    }

    /* ---- present / resolve ---- */
    (void)ff_present_primer(power);                      /* @asm 03C0FF call 0x108b (ljmp 0x1a1f,0x1c) -> [bp-0x56] (presentation primer) */

    if (power < 4 &&                                     /* @asm 03C101 cmp [bp+6],4 ; jl */
        g_ai_personality[(unsigned)power * 0x34 + 0x00] == 0) { /* @asm 03C10A imul bx,[bp+6],0x34 ; 03C10E cmp [bx+0x543f],0 ; je */
        /* --- HUMAN power: show the WHICHFREEDOM election dialog --- */
        if (n_categories == 0)                           /* @asm 03C118 cmp [bp-2],0 ; jne -> dialog ; else skip to tail */
            goto resolve_pending;                        /* no candidates at all */

        ff_msg_open(3);                                  /* @asm 03C121 push 3 ; lcall 0x181f,0x4ac */
        dlg = dlg_open((void *)0x087C /*"GAME"*/,         /* @asm 03C12B lea bx,[0x87c] */
                       (void *)0x1262 /*"WHICHFREEDOM"*/, 0); /* @asm 03C12F lea ax,[0x1262]; 03C133 sub dx,dx; 03C135 lcall 0x191f,0x182 */
        if (dlg == 0)                                    /* @asm 03C140 or dx,ax ; jne ; else skip */
            goto resolve_pending;
        *(int16_t *)((uint8_t *)dlg + 0x22) = 8;         /* @asm 03C14A mov es:[bx+0x22],8 (dialog field +0x22; role inferred from context) */

        if (n_categories != 0) {                         /* @asm 03C150 cmp [bp-2],0 ; jne build-rows */
            char rowbuf[0x52];                           /* @asm bp-0x52 work string */
            for (cat = 0; cat < 5; cat++) {              /* @asm 03C159 cat=0 ; 03C201 cmp [bp-0x68],5 */
                if (ff_cat_candidate(cat, power) == 0)   /* @asm 03C165 call 0x109f ; 03C16B or ax,ax ; jne build */
                    continue;                            /* (empty category emits no row)             */
                rowbuf[0] = 0;                           /* @asm 03C172 mov [bp-0x52],0 */
                /* Build the row text from the chosen FF's per-FF word fields.
                 * ff = chosen[cat] (FF_MEM_BASE+0x00 word handle, FF_MEM2_BASE word). */
                {
                    int ffsel = chosen[cat];             /* @asm 03C17B mov bx,[bp+si-0x74] */
                    str_fmt_int(*(int16_t *)(FF_MEM_BASE + (unsigned)ffsel * 6), rowbuf); /* @asm 03C186 push [bx-0x69ae]; 03C18E lcall 0x181f,0x16e */
                    str_append(rowbuf);                  /* @asm 03C19A lcall 0x181f,0x178 */
                    str_term_a(rowbuf);                  /* @asm 03C1A6 lcall 0x181f,0x11e */
                    str_fmt_int(*(int16_t *)(FF_MEM2_BASE + (unsigned)cat * 2), rowbuf); /* @asm 03C1AE push [si-0x6918] (si=cat*2, NOT ffsel*6); 03C1B6 lcall 0x181f,0x16e */
                    str_append(rowbuf);                  /* @asm 03C1C2 lcall 0x181f,0x178 */
                    str_fmt_int(g_2e88, rowbuf);         /* @asm 03C1CA push [0x2e88]; 03C1D2 lcall 0x181f,0x16e (global suffix word) */
                    str_term_b(rowbuf);                  /* @asm 03C1DE lcall 0x181f,0x128 */
                }
                dlg_add_row(dlg, rowbuf, cat + 1);       /* @asm 03C1E6 ax=[bp-0x68]+1; 03C1F6 lcall 0x191f,0x176 */
            }
        }

        g_1f66 = 1;                                      /* @asm 03C20A mov [0x1f66],1 (dialog-active flag) */
        chosen_idx = dlg_run(dlg);                       /* @asm 03C216 lcall 0x191f,0x16a -> [bp-0x58] */
        dlg_free(dlg);                                   /* @asm 03C224 lcall 0x191f,0x1a8 */
        dlg = 0;                                         /* @asm 03C229 sub ax,ax; store to [bp-0x5e:bp-0x5c] */

        /* @asm 03C231: if (chosen_idx > 0) { sel = chosen_idx-1;
         *   if (g_1f68) { ff_pre_b(chosen[sel]); ff_animate_pre(); loop }  // animate the pick
         *   else        { g_active_power->pending_ff(+0x12) = chosen[sel]; } } */
        if (chosen_idx > 0) {                            /* @asm 03C231 cmp [bp-0x58],ax(0) ; jg */
            int sel = chosen_idx - 1;                    /* @asm 03C23C dec ax -> [bp-0x56] */
            if (g_1f68 != 0) {                           /* @asm 03C240 cmp [0x1f68],0 ; je 0xede */
                ff_pre_b((int)chosen[sel]);              /* @asm 03C24B push [bp+si-0x74]; 03C24E lcall 0x1a1f,0x62 */
                ff_animate_pre();                        /* @asm 03C256 lcall 0x181f,0x56a */
                /* @asm 03C25B jmp 0xdab : re-enter the build/run loop (re-present) */
            } else {
                *(int16_t *)((uint8_t *)g_active_power + 0x12) = chosen[sel]; /* @asm 03C262 ax=chosen[sel]; 03C265 bx=[0x84fc]; 03C269 mov [bx+0x12],ax */
            }
        }
    }

resolve_pending:
    /* @asm 03C26C: if (dlg != 0) dlg_free(dlg); */
    if (dlg != 0)                                        /* @asm 03C26C ax=[bp-0x5c]|[bp-0x5e] ; je */
        dlg_free(dlg);                                   /* @asm 03C27A lcall 0x191f,0x1a8 */
    /* @asm 03C27F pop si / 03C280 leave / 03C281 retf */
    (void)band; (void)chosen_idx;
}

/* ============================================================================
 * NOTES (not yet byte-verified in this pass):
 *   - ff_bells_required (0x191F:0x0F66 -> file **0x03C282**, corrected from the
 *     stale 0x026282): the bell-cost CURVE per FF#. RESOLVED 2026-05-30 = func_03C282
 *     (src/overlay/overlay_038A50_03C5A8.c). Runtime datum: 129 for the 1st
 *     un-owned FF when "Brewster" is next (docs/DATA_MODEL.md:313) — consistent. NOT a
 *     formula — do NOT treat as the curve.
 *   - g_game_phase (DGROUP:0x5382) bit meanings cross-ref'd with scoring/compute.c:
 *     bit0=independence declared, bit1=boycott, bit2=congress-notified latch,
 *     bit8=war/revolution, bit0x10=independence won. The exact pre/post-Congress
 *     semantics for each branch are inferred from call context.
 *   - ff_cat_candidate (0x1A1F:0x0054), ff_category_band (0x1A1F:0x0046),
 *     ff_become_available (0x1A1F:0x0000), ff_present_primer (0x1A1F:0x001C),
 *     ff_log_notify (0x191F:0x0FEC file 0x0C5DC), and the 0x191F dialog
 *     primitives (dlg_open/add_row/run/free): call sites + args verified;
 *     bodies in thunk page.
 *   - FF_MEM2_BASE (0x96E8) is now decoded: 6-word FOUNDING table (cat*2 index).
 *     The global suffix word [0x2E88] pushed into each row is RUNTIME_ONLY.
 *   - g_53d4 (0x53D4), g_1f66 (0x1F66 dialog-active), g_1f68 (0x1F68
 *     "animate-pick" mode): roles inferred from call context; RUNTIME_ONLY values.
 * ============================================================================ */
