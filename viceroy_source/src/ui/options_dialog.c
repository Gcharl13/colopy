/* ============================================================================
 * options_dialog.c -- the Game / Colony-Report / Sound option checkbox dialogs
 *                      and the Find-City colony picker.
 * ----------------------------------------------------------------------------
 * STATUS: BYTE_VERIFIED. These four handlers form one contiguous code cluster
 * the re-segmenter merged into a single record (func_022F08, file
 * 0x022F08..0x023343, page 0x01).  In the binary they are FOUR distinct RETF-
 * terminated functions sharing the page; this file splits them back out with
 * exact @asm citations.  This is the "over-merged record" artifact the plan
 * warns about -- verified against the page boundaries.
 *
 * @asm_disasm  code/VICEROY/disasm_overlay_reseg/page_01.asm
 * Cluster span: file 0x022F08 .. 0x023343  (size 0x43C; next func @0x023344).
 *
 * The checkbox-dialog ENGINE is func_028D8C (page 0x02), reached via:
 *   0x191F:0x26E  dialog_begin(...)           init a new checkbox dialog
 *   0x191F:0x262  checkbox_set(idx, state)    pre-populate checkbox idx
 *   0x181F:0x3FE  dialog_run(key)             show + run the dialog by key
 *   0x191F:0x306  checkbox_get(idx) -> state  read checkbox idx after run
 *   0x191F:0x120  picker_run(lo,hi, msg)      run a list-picker by key
 * (Targets ANCHOR_VERIFIED via lcall_resolution -> func_028D8C; their internals
 *  are not re-decoded here.)
 *
 * GAME.TXT option lists (raw/COLONIZE/GAME.TXT) -- this is what pins each bit
 * to a human-readable preference (BYTE_VERIFIED against the file):
 *   @GAMEOPTIONS  (width=190, checkbox): Show Indian Moves / Show Foreign Moves
 *       / Fast Piece Slide / End of Turn / Autosave / Combat Analysis /
 *       Water Color Cycling / Tutorial Hints                       (8 options)
 *   @COLONYOPTIONS (width=220, checkbox): Labels on buildings / Labels on cargo
 *       and terrain / Report when colonists trained / Report food shortages /
 *       Report raw materials shortages / Report tools needed / Report
 *       inefficient government / Report new cargos / Report Sons of Liberty /
 *       Report rebel majorities                                    (10 options)
 *   @SOUNDOPTIONS (width=190, checkbox): Background Music / Event Music /
 *       Sound Effects                                              (3 options)
 *
 * String handles used (file = handle + 0x1D9A0; CITED strings.json):
 *   FINDCITY      handle 0x0A50/0x0A51  (@asm 0x022F17/0x022F1B)
 *   NOCITY        handle 0x0A5A         (@asm 0x022FCA)
 *   GAMEOPTIONS   handle 0x0A61         (@asm 0x023061)
 *   COLONYOPTIONS handle 0x0A6D         (@asm 0x0231F3)
 *   SOUNDOPTIONS  handle 0x0A7B         (@asm 0x0232D7)
 *   GAME          handle 0x087C         (table selector)
 * ============================================================================ */
#include "viceroy_types.h"
#include "iolib.h"

#define KEY_FINDCITY       0x0A50   /* "FINDCITY"      @file 0x1E3F0 */
#define KEY_NOCITY         0x0A5A   /* "NOCITY"        @file 0x1E3FA */
#define KEY_GAMEOPTIONS    0x0A61   /* "GAMEOPTIONS"   @file 0x1E401 */
#define KEY_COLONYOPTIONS  0x0A6D   /* "COLONYOPTIONS" @file 0x1E40D */
#define KEY_SOUNDOPTIONS   0x0A7B   /* "SOUNDOPTIONS"  @file 0x1E41B */
#define KEY_GAME           0x087C   /* "GAME"          @file 0x1E21C */

/* ---- option-flag globals (BYTE_VERIFIED addresses) ------------------------
 * DGROUP:0x5382/0x5383  game-option flags (0x5382 = state flags per
 *   GAME_SYSTEM_ANCHORS.md; the option bits live in the 16-bit view 0x5382).
 * DGROUP:0x5384/0x5385  colony-report-option flags.
 * DGROUP:0x5386         sound-option flag byte.
 * DGROUP:0x00A0/0xA2/0xA4  three sound-setting words (music/sfx levels).
 * DGROUP:0x0372         cursor-active latch (set by the game-options commit).
 * DGROUP:0x539E         colony count (loop bound in Find-City).
 * DGROUP:0x5396         active player index (ownership mask shift).
 * DGROUP:0x53A2         "all colonies visible" / cheat-reveal flag.
 * DGROUP:0x8542         -> active ColonyRecord (project memory: colony struct). */
extern uint8_t  g_flag_5382;   /* DGROUP:0x5382 (low) */
extern uint8_t  g_flag_5383;   /* DGROUP:0x5383 */
extern uint8_t  g_flag_5384;   /* DGROUP:0x5384 */
extern uint8_t  g_flag_5385;   /* DGROUP:0x5385 */
extern uint8_t  g_flag_5386;   /* DGROUP:0x5386 */
extern int16_t  g_snd_A0;      /* DGROUP:0x00A0 */
extern int16_t  g_snd_A2;      /* DGROUP:0x00A2 */
extern int16_t  g_snd_A4;      /* DGROUP:0x00A4 */
extern int16_t  g_word_372;    /* DGROUP:0x0372 cursor latch */
extern int16_t  g_colony_count;/* DGROUP:0x539E */
extern int16_t  g_active_player_idx; /* DGROUP:0x5396 */
extern int16_t  g_reveal_53A2; /* DGROUP:0x53A2 */
extern uint8_t  *g_active_colony_ptr; /* far ptr held at DGROUP:0x8542 (low word) */

/* ---- engine + leaf helpers (ANCHOR_VERIFIED targets) ---------------------- */
/* picker_run: @asm passes ax=key(0xA51), dx=key2(0xA50), bx=table(0x87C "GAME")
 * and the message id 0x17 on the stack.  @asm 0x022F11..0x022F1F. */
extern int   picker_run(int key, int key2, int table, int msg);    /* 0x191F:0x120 */
extern void  ov_colony_select(int idx);                            /* 0x181F:0x9E6 */
extern int   ov_colony_owned_visible(int colptr_word, int buf);    /* 0xD1D:0xC80 */
extern int   ov_colony_at_xy(int x, int y);                        /* 0x181F:0x74A */
extern void  ov_open_colony(int z, int x, int y);                  /* 0x181F:0xE08 */
extern void  ov_strbuf_init2(int seg, int buf, int z);             /* 0x181F:0x416 */
extern void  ov_msg_show(int key);                                 /* 0x181F:0x3FE (run/show) */
extern void  dialog_begin(void);                                   /* 0x191F:0x26E */
extern void  checkbox_set(int idx, int state);                     /* 0x191F:0x262 */
extern int   checkbox_get(int idx);                                /* 0x191F:0x306 */
extern void  ov_set_screen_mode(int a, int b);                     /* 0x181F:0x3F4 */
extern void  ov_sound_apply(int z);                                /* 0x181F:0x4DE */

/* ============================================================================
 * find_city_dialog -- VICEROY func @0x022F08  (Find City colony picker)
 * ----------------------------------------------------------------------------
 * @asm  file 0x022F08..0x022FD4  (ENTER 4,0; first RETF-block of the cluster)
 *
 * Runs the FINDCITY picker; if the player picks a colony, opens it.
 * Behaviour (byte-faithful):
 *   1. found = -1 ([bp-4]).  picker_run(FINDCITY(0xA51 lo / 0xA50 hi), 0x17):
 *      if it returns 0 -> NOCITY toast + return.  @asm 0x022F0C..0x022F28.
 *   2. count = picker result ([bp-2]); iterate idx 0..count-1 over colonies:
 *      ov_colony_select(idx) (0x181F:0x9E6); test the colony at
 *      *(0x8542)+2 via ov_colony_owned_visible(...,0x9820) (0xD1D:0xC80);
 *      for the player's own colonies (player<4) it cross-checks ownership with
 *      ov_colony_at_xy(map_x,map_y) (0x181F:0x74A) and the (0x10<<player) mask,
 *      gated by the reveal flag [0x53A2].  @asm 0x022F30..0x022F90.
 *      The matching colony index is latched into found.  @asm 0x022F8A.
 *   3. if (found >= 0): open it -- ov_open_colony(0, map_x, map_y)
 *      (0x181F:0xE08) using *(0x8542)[0],[1].  @asm 0x022F9F..0x022FBB.
 *   4. else: redraw map (ov_strbuf_init2(ds,0x9820,0); 0x181F:0x416) and show
 *      NOCITY (ov_msg_show(0xA5A); 0x181F:0x3FE).  @asm 0x022FBC..0x022FD2.
 * ============================================================================ */
void find_city_dialog(void)
{
    int found = -1;                 /* [bp-4]  @asm 0x022F0C MOV [bp-4],0xFFFF */
    int count, idx;                 /* [bp-2] */

    /* 1. run the FINDCITY picker (ax=FINDCITY+1, dx=FINDCITY, bx=GAME, msg=0x17). */
    count = picker_run(KEY_FINDCITY + 1, KEY_FINDCITY, KEY_GAME, 0x17); /* @asm 0x022F1F 0x191F:0x120 */
    if (count == 0)                 /* @asm 0x022F24 OR ax,ax / JNE -> exit */
        goto no_city;               /* @asm 0x022F28 JMP 0x2963 */

    /* 2. scan colonies for an owned + visible match. */
    idx = count;                                          /* [bp-2] = picker result @asm 0x022F2B */
    /* loop while found < 0 and idx < colony_count  (@asm 0x022F2E JMP test 0x2923) */
    while (found < 0) {                                   /* @asm 0x022F93 CMP [bp-4],0 / JL */
        if (idx >= (int)g_colony_count)                   /* @asm 0x022F30 cmp [bp-2],[0x539E] */
            break;                                        /* @asm 0x022F36 JGE 0x2929 */
        ov_colony_select(idx);                            /* @asm 0x022F3B 0x181F:0x9E6 */
        /* test the colony record (its address is the value at 0x8542) + 2 vs
         * scratch buffer 0x9820.  @asm 0x022F43 MOV ax,[0x8542]; INC;INC. */
        if (ov_colony_owned_visible((int)(g_active_colony_ptr + 2), 0x9820) == 0) {
                                                          /* @asm 0x022F4C 0xD1D:0xC80 / JNE skip */
            if ((int)g_active_player_idx < 4) {           /* @asm 0x022F58 cmp [0x5396],4 / JGE */
                /* ownership cross-check: mask (0x10 << player) vs colony_at_xy */
                int owner = ov_colony_at_xy(g_active_colony_ptr[0],
                                            g_active_colony_ptr[1]); /* @asm 0x022F6C 0x181F:0x74A */
                int mask  = 0x10 << (int)g_active_player_idx;        /* @asm 0x022F7A SHL */
                if (!(mask & owner) && g_reveal_53A2 == 0)           /* @asm 0x022F7F/0x022F83 */
                    goto next;                                       /* @asm 0x022F88 JE 0x2920 */
            }
            found = idx;                                  /* @asm 0x022F8A MOV [bp-4],[bp-2] */
        }
    next:
        idx++;                                            /* @asm 0x022F90 INC [bp-2] */
    }

    /* 3. open the found colony (its tile is *(0x8542)[0],[1]). */
    if (found >= 0) {                                     /* @asm 0x022F99 CMP [bp-4],0 / JL */
        /* push cs; CALL 0x4535 (a local fixup), then open.  @asm 0x022F9F */
        ov_open_colony(0, g_active_colony_ptr[0], g_active_colony_ptr[1]);
                                                          /* @asm 0x022FB2 0x181F:0xE08 */
        return;                                           /* @asm 0x022FBA LEAVE/RETF */
    }

no_city:
    /* 4. no colony chosen -> redraw + NOCITY toast. */
    ov_strbuf_init2(0/*ds*/, 0x9820, 0);                  /* @asm 0x022FC2 0x181F:0x416 */
    ov_msg_show(KEY_NOCITY);                              /* @asm 0x022FCE 0x181F:0x3FE */
    /* @asm 0x022FD3 LEAVE/RETF */
}

/* ============================================================================
 * game_options_dialog -- VICEROY func @0x022FD6  (Set Game Options checkboxes)
 * ----------------------------------------------------------------------------
 * @asm  file 0x022FD6..0x023118  (second RETF-block of the cluster)
 *
 * Pre-populates 8 checkboxes from the flag bits, runs @GAMEOPTIONS, then writes
 * the chosen states back.  The bit<->checkbox map is BYTE_VERIFIED line-for-
 * line; each label below comes from GAME.TXT @GAMEOPTIONS (in order).
 *
 * Bit map (checkbox N : flag bit):
 *   1 Show Indian Moves   : [0x5383] & 0x80     @asm 0x022FDB/0x02307C
 *   2 Show Foreign Moves  : [0x5383] & 0x40     @asm 0x022FEB/0x02308D
 *   3 Fast Piece Slide    : [0x5383] & 0x10     @asm 0x022FFB/0x02309E
 *   4 End of Turn         : [0x5383] & 0x08     @asm 0x02300B/0x0230AF
 *   5 Autosave            : [0x5383] & 0x04     @asm 0x02301B/0x0230C0
 *   6 Combat Analysis     : [0x5383] & 0x02     @asm 0x02302B/0x0230D1
 *   7 Water Color Cycling : [0x5383] & 0x01     @asm 0x02303B/0x0230E2
 *   8 Tutorial Hints      : [0x5382] & 0x80     @asm 0x023051/0x0230F3
 *
 * Commit phase clears the option bits first: AND [0x5382(word)],0x207F
 * (@asm 0x02306A) -- preserves bits 0x2000/0x0040/0x001F, clears the 8 option
 * bits -- then ORs back each set checkbox.
 *
 * Tail: copies the (Tutorial Hints / bit 0x100 of the word) state into the
 * cursor latch [0x372]; if it is zero, sets the screen mode via
 * ov_set_screen_mode(0xA000,0xFC00) (0x181F:0x3F4).  @asm 0x0230F8..0x023118.
 * ============================================================================ */
void game_options_dialog(void)
{
    dialog_begin();                                       /* @asm 0x022FD6 0x191F:0x26E */

    /* --- pre-populate (SET phase): checkbox_set(N, flag_bit) --- */
    checkbox_set(1, g_flag_5383 & 0x80);                  /* @asm 0x022FE6 0x191F:0x262 */
    checkbox_set(2, g_flag_5383 & 0x40);                  /* @asm 0x022FF6 */
    checkbox_set(3, g_flag_5383 & 0x10);                  /* @asm 0x023006 */
    checkbox_set(4, g_flag_5383 & 0x08);                  /* @asm 0x023016 */
    checkbox_set(5, g_flag_5383 & 0x04);                  /* @asm 0x023026 */
    checkbox_set(6, g_flag_5383 & 0x02);                  /* @asm 0x023036 */
    checkbox_set(7, g_flag_5383 & 0x01);                  /* @asm 0x023049 (CMP/SBB/NEG) */
    checkbox_set(8, g_flag_5382 & 0x80);                  /* @asm 0x02305C */

    /* --- run the dialog --- */
    ov_msg_show(KEY_GAMEOPTIONS);                         /* @asm 0x023065 0x181F:0x3FE */

    /* --- commit (READ phase): clear option bits, OR back each set checkbox --- */
    /* AND word[0x5382],0x207F  (keep non-option bits)  @asm 0x02306A */
    *(uint16_t *)&g_flag_5382 &= 0x207F;
    if (checkbox_get(1)) g_flag_5383 |= 0x80;             /* @asm 0x023073/0x02307C */
    if (checkbox_get(2)) g_flag_5383 |= 0x40;             /* @asm 0x023084/0x02308D */
    if (checkbox_get(3)) g_flag_5383 |= 0x10;             /* @asm 0x023095/0x02309E */
    if (checkbox_get(4)) g_flag_5383 |= 0x08;             /* @asm 0x0230A6/0x0230AF */
    if (checkbox_get(5)) g_flag_5383 |= 0x04;             /* @asm 0x0230B7/0x0230C0 */
    if (checkbox_get(6)) g_flag_5383 |= 0x02;             /* @asm 0x0230C8/0x0230D1 */
    /* NOTE option 7 inverts: JNE skips the OR (checkbox CLEAR => set bit). */
    if (!checkbox_get(7)) g_flag_5383 |= 0x01;            /* @asm 0x0230D9/0x0230E2 (JNE) */
    if (checkbox_get(8)) g_flag_5382 |= 0x80;             /* @asm 0x0230EA/0x0230F3 */

    /* tail: cursor latch = (word[0x5382] & 0x100) ? -1 : 0;  if 0, set mode. */
    g_word_372 = (*(uint16_t *)&g_flag_5382 & 0x0100) ? -1 : 0; /* @asm 0x0230F8..0x023106 */
    if (g_word_372 == 0)                                  /* @asm 0x023109 OR ax,ax / JNE */
        ov_set_screen_mode(0xFC00, 0xA000);               /* @asm 0x023113 0x181F:0x3F4 */
    /* @asm 0x023118 RETF */
}

/* ============================================================================
 * colony_report_options_dialog -- VICEROY func @0x02311A  (@COLONYOPTIONS)
 * ----------------------------------------------------------------------------
 * @asm  file 0x02311A..0x0232AC  (third RETF-block of the cluster)
 *
 * Identical structure to game_options_dialog, for the 10 colony-report flags in
 * [0x5384]/[0x5385].  Bit map (BYTE_VERIFIED; labels from GAME.TXT
 * @COLONYOPTIONS in order):
 *   1 Labels on buildings              : [0x5384] & 0x02   @asm 0x02312C/0x02320E
 *   2 Labels on cargo and terrain      : [0x5384] & 0x01   @asm 0x023141/0x02321F
 *   3 Report when colonists trained    : [0x5384] & 0x80   @asm 0x023156/0x023230
 *   4 Report food shortages            : [0x5384] & 0x40   @asm 0x02316B/0x023241
 *   5 Report raw materials shortages   : [0x5384] & 0x20   @asm 0x023180/0x023252
 *   6 Report tools needed              : [0x5384] & 0x10   @asm 0x023195/0x023263
 *   7 Report inefficient government    : [0x5384] & 0x08   @asm 0x0231AA/0x023274
 *   8 Report new cargos available      : [0x5384] & 0x04   @asm 0x0231BF/0x023285
 *   9 Report Sons of Liberty membership: [0x5385] & 0x01   @asm 0x0231D5/0x023296
 *  10 Report rebel majorities          : [0x5385] & 0x02   @asm 0x0231EB/0x0232A7
 *
 * Commit clears: AND word[0x5384],0xFC00 (@asm 0x0231FC) before re-OR.
 * ============================================================================ */
void colony_report_options_dialog(void)
{
    dialog_begin();                                       /* @asm 0x02311A 0x191F:0x26E */

    checkbox_set(1,  g_flag_5384 & 0x02);                 /* @asm 0x02312F */
    checkbox_set(2,  g_flag_5384 & 0x01);                 /* @asm 0x023144 */
    checkbox_set(3,  g_flag_5384 & 0x80);                 /* @asm 0x023159 */
    checkbox_set(4,  g_flag_5384 & 0x40);                 /* @asm 0x02316E */
    checkbox_set(5,  g_flag_5384 & 0x20);                 /* @asm 0x023183 */
    checkbox_set(6,  g_flag_5384 & 0x10);                 /* @asm 0x023198 */
    checkbox_set(7,  g_flag_5384 & 0x08);                 /* @asm 0x0231AD */
    checkbox_set(8,  g_flag_5384 & 0x04);                 /* @asm 0x0231C2 */
    checkbox_set(9,  g_flag_5385 & 0x01);                 /* @asm 0x0231D8 */
    checkbox_set(10, g_flag_5385 & 0x02);                 /* @asm 0x0231EE */

    ov_msg_show(KEY_COLONYOPTIONS);                       /* @asm 0x0231F7 0x181F:0x3FE */

    /* AND word[0x5384],0xFC00  (clear the 10 option bits)  @asm 0x0231FC */
    *(uint16_t *)&g_flag_5384 &= 0xFC00;
    if (checkbox_get(1))  g_flag_5384 |= 0x02;            /* @asm 0x023205/0x02320E */
    if (checkbox_get(2))  g_flag_5384 |= 0x01;            /* @asm 0x023216/0x02321F */
    if (checkbox_get(3))  g_flag_5384 |= 0x80;            /* @asm 0x023227/0x023230 */
    if (checkbox_get(4))  g_flag_5384 |= 0x40;            /* @asm 0x023238/0x023241 */
    if (checkbox_get(5))  g_flag_5384 |= 0x20;            /* @asm 0x023249/0x023252 */
    if (checkbox_get(6))  g_flag_5384 |= 0x10;            /* @asm 0x02325A/0x023263 */
    if (checkbox_get(7))  g_flag_5384 |= 0x08;            /* @asm 0x02326B/0x023274 */
    if (checkbox_get(8))  g_flag_5384 |= 0x04;            /* @asm 0x02327C/0x023285 */
    if (checkbox_get(9))  g_flag_5385 |= 0x01;            /* @asm 0x02328D/0x023296 */
    if (checkbox_get(10)) g_flag_5385 |= 0x02;            /* @asm 0x02329E/0x0232A7 */
    /* @asm 0x0232AC RETF */
}

/* ============================================================================
 * sound_options_dialog -- VICEROY func @0x0232AE  (@SOUNDOPTIONS)
 * ----------------------------------------------------------------------------
 * @asm  file 0x0232AE..0x023343  (fourth RETF-block; cluster end)
 *
 * 3 checkboxes backed by the three sound-setting WORDS [0xA2],[0xA0],[0xA4]
 * (not single bits):  Background Music, Event Music, Sound Effects (order from
 * GAME.TXT @SOUNDOPTIONS).
 *   checkbox 1 <-> [0xA2]   @asm 0x0232B6/0x0232E0
 *   checkbox 2 <-> [0xA0]   @asm 0x0232C2/0x0232EB
 *   checkbox 3 <-> [0xA4]   @asm 0x0232CE/0x0232F6
 *
 * After the run it derives the [0x5386] enable bits from which words are
 * nonzero (AND [0x5386],0xF1 then OR 2/4/8), and if any sound is enabled it
 * applies it: ov_sound_apply(1) (0x181F:0x4DE).  @asm 0x023301..0x023343.
 * ============================================================================ */
void sound_options_dialog(void)
{
    dialog_begin();                                       /* @asm 0x0232AE 0x191F:0x26E */

    checkbox_set(1, g_snd_A2);                            /* @asm 0x0232BA */
    checkbox_set(2, g_snd_A0);                            /* @asm 0x0232C6 */
    checkbox_set(3, g_snd_A4);                            /* @asm 0x0232D2 */

    ov_msg_show(KEY_SOUNDOPTIONS);                        /* @asm 0x0232DB 0x181F:0x3FE */

    g_snd_A2 = checkbox_get(1);                           /* @asm 0x0232E3/0x0232E8 */
    g_snd_A0 = checkbox_get(2);                           /* @asm 0x0232EE/0x0232F3 */
    g_snd_A4 = checkbox_get(3);                           /* @asm 0x0232F9/0x0232FE (ax) */

    /* AND [0x5386],0xF1; set bit2 if A2!=0, bit4 if A0!=0, bit8 if (ax)!=0. */
    g_flag_5386 &= 0xF1;                                  /* @asm 0x023301 */
    if (g_snd_A2 != 0) g_flag_5386 |= 0x02;               /* @asm 0x023306/0x02330D */
    if (g_snd_A0 != 0) g_flag_5386 |= 0x04;               /* @asm 0x023312/0x023319 */
    if (/*ax (checkbox 3)*/ g_snd_A4 != 0) g_flag_5386 |= 0x08; /* @asm 0x02331E/0x023322 */

    /* if any of the three words is nonzero, (re)apply sound. @asm 0x023327 */
    if ((g_snd_A0 != 0 && g_snd_A2 != 0) || g_snd_A4 != 0) /* @asm 0x023327..0x023337 */
        ov_sound_apply(1);                                /* @asm 0x02333B 0x181F:0x4DE */
    /* @asm 0x023343 RETF */
}
