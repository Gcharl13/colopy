/* ============================================================================
 * king_audience.c -- the King-audience full-screen dialog
 * ----------------------------------------------------------------------------
 * STATUS: BYTE_VERIFIED (structure + all DGROUP offsets + every string key +
 * the FONTKING swap + the two-portrait draw).  The leaf draw thunks
 * (0x181F:0x2F8 portrait blit, 0x181F:0x444 full-screen composite,
 * 0x181F:0x3F4 mode set) are type-B load-image routines; their CALL SITES +
 * args are byte-exact, their internals are not re-decoded.  cite-or-left unresolved.
 *
 * @asm_function  func_075352   file 0x075352..0x075593  (578 B, ENTER 0x320,0)
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_1A.asm (func_075352)
 *
 * Purpose proven by STRING XREF (decisive):
 *   @asm 0x07536E  PUSH 0x22F2  -> "KINGLSS"  (king-dialog base key)
 *   @asm 0x0753CA  PUSH 0x22FA  -> "ENGLND"   } the player nation's KING
 *   @asm 0x0753D0  PUSH 0x2301  -> "FRANCE"   } portrait/voice set, picked by
 *   @asm 0x0753D6  PUSH 0x2308  -> "SPAIN"    } DGROUP:[0x5398] (0..3)
 *   @asm 0x0753DC  PUSH 0x230E  -> "DUTCH"    }
 *   @asm 0x07543C  PUSH 0x2314  -> "KING1"    (audience intro: bp+6==1 & bp+8==1)
 *   @asm 0x075458  PUSH 0x231A  -> "KINGLOSE" (lose-outcome audience)
 *   @asm 0x07545E  PUSH 0x2323  -> "KINGWIN"  (win-outcome audience)
 *   @asm 0x0754F2  LEA bx,[0x232B] -> "FONTKING" (the special audience font)
 *   (string handle = file_offset - 0x1D9A0.)
 *
 * This is one of the LEA-[0x839E] dialog-rect sites flagged in dialog.c
 * (DIALOG_GEOMETRY.md "8 sites ... func_075352"): here the rect at
 * DGROUP:0x839E..0x83A4 frames the two portraits and the speech body.
 *
 * Args (cdecl):
 *   msg_idx   = [bp+6]   which king message / scene (1 => intro)
 *   subcase   = [bp+8]   sub-selector (1 => the KING1 intro path)
 *   run_arg   = [bp+0xA] passed to the dialog-run (0x181F:0x3FE) -- the choice
 *                        set / response mode for the audience.
 * ============================================================================ */
#include "viceroy_types.h"
#include "iolib.h"

/* FP_OFF / FP_SEG — the period-correct MSC <dos.h> far-pointer accessors
 * (companions to viceroy_types.h's MK_FP). Provided here for documentation; a
 * real MSC 6.0 build supplies them in <dos.h>. */
#ifndef FP_OFF
#  define FP_OFF(p)  ((uint16_t)(uint32_t)(p))
#endif
#ifndef FP_SEG
#  define FP_SEG(p)  ((uint16_t)((uint32_t)(p) >> 16))
#endif

/* GAME.TXT message keys (handles; file = handle + 0x1D9A0). CITED strings.json. */
#define KEY_KINGLSS    0x22F2   /* "KINGLSS"  @asm 0x07536E / @file 0x1FC92 */
#define KEY_ENGLND     0x22FA   /* "ENGLND"   @asm 0x0753CA / @file 0x1FC9A */
#define KEY_FRANCE     0x2301   /* "FRANCE"   @asm 0x0753D0 / @file 0x1FCA1 */
#define KEY_SPAIN      0x2308   /* "SPAIN"    @asm 0x0753D6 / @file 0x1FCA8 */
#define KEY_DUTCH      0x230E   /* "DUTCH"    @asm 0x0753DC / @file 0x1FCAE */
#define KEY_KING1      0x2314   /* "KING1"    @asm 0x07543C / @file 0x1FCB4 */
#define KEY_KINGLOSE   0x231A   /* "KINGLOSE" @asm 0x075458 / @file 0x1FCBA */
#define KEY_KINGWIN    0x2323   /* "KINGWIN"  @asm 0x07545E / @file 0x1FCC3 */
#define KEY_FONTKING   0x232B   /* "FONTKING" @asm 0x0754F2 / @file 0x1FCCB */

/* ---- DGROUP globals (BYTE_VERIFIED addresses) -----------------------------
 *   [0x0372]  cursor-active latch (saved, cleared across the audience).
 *   [0x1F64]  "in modal screen" flag (0 during, 1 on exit).
 *   [0x5398]  player nation index (0=England .. 3=Dutch) -- selects the KING
 *             portrait/voice key.  (Adjacent to 0x5394 current-nation /
 *             0x5396 active-player in main_loop.c's global block.)
 *   [0x839E..0x83A4]  the dialog rect (shared, see dialog.c).
 *   [0x2DA8..0x2DAE]  the second clip region (shared, see report_screen.c).
 *   [0x1F4A]/[0x1F50]/[0x1F52]/[0x1F56]  font-cell state (saved/overridden for
 *             the FONTKING render, then restored).
 *   [0x1F9E]/[0x1FA0]  active text-context far ptr (saved/restored).
 *   [0x089E]/[0x08A0]  default text-context far ptr.
 *   [0x268A]/[0x268C]  the text-context restored on exit.  */
extern int16_t g_word_372;
extern int16_t g_word_1F64;
extern int16_t g_nation_5398;        /* DGROUP:0x5398 player nation 0..3 */
extern int16_t g_dialog_rect[4];     /* DGROUP:0x839E.. */
extern int16_t g_region_2DA8[4];     /* DGROUP:0x2DA8.. */
extern int16_t g_font_1F4A, g_font_1F50, g_font_1F52;
extern uint8_t g_font_1F56;
extern int16_t g_textctx_1F9E, g_textctx_1FA0;
extern int16_t g_word_89E, g_word_8A0;
extern int16_t g_word_268A, g_word_268C;

/* ---- leaf helpers (call sites byte-exact; internals summarised) ----------- */
/* strcpy_near: declared in iolib.h as char near *(char near *, const char near *) */
extern void ov_lookup_msg(int idx, void *buf);              /* 0x181F:0x182 lookup by key */
extern int  ov_region_setup(void *body, int z, int r0,int r1,int r2,int r3, void *key);
                                                            /* 0x181F:0x44E */
extern void ov_rec_first(void);                             /* 0x191F:0xFDE */
extern void far *ov_rec_next(void *buf, int z);             /* 0x191F:0xFD0 -> DX:AX far rec, NULL if none */
/* draw_portrait: x=rec->[0x46], sprite=rec->[0x48], sz=0x64, ax=1, into rect.
 * @asm pushes es:[si+0x48], 0x64, dx=es:[si+0x46], ax=1, bx=&[0x839E]. */
extern void ov_draw_portrait(void far *rec, int rectptr);   /* 0x181F:0x2F8 (type B) */
extern void ov_play_audience_anim(int key);                 /* 0x181F:0x48E -> func_02211E */
extern void ov_snapshot(void);                              /* 0x181F:0x3B6 -> func_021D32 area */
extern void ov_set_mode(int lo, int hi);                    /* 0x181F:0x3F4 (type B) */
extern void ov_set_mode_buf(int seg, void *buf);            /* 0x181F:0x3F4 (buf variant) */
extern void ov_full_blit(int r0,int r1,int r2,int r3, int q0,int q1,int q2,int q3,
                         int h, int ax, int dx, int w);      /* 0x181F:0x444 (type B) */
extern void ov_clear_rect(int z0, int w, int h, int ax, int dx, int bx); /* 0x181F:0xE2 */
extern void far *ov_set_font(int handle);                   /* 0x1A1F:0xA86 (FONTKING) returns far ptr */
extern int  dialog_run(int run_arg);                        /* 0x181F:0x3FE -> func_06F594 (page-0x17
                                                             * option-run wrapper, +22 into func_06F57E),
                                                             * NOT func_028D8C — corrected 2026-05-30 by the
                                                             * wave-6 GUI thunk decode (func_028D8C is reached
                                                             * via 0x181F:0x1750). */
extern void menu_free(void far *menu);                      /* 0x191F:0x1A8 */

int king_audience(int msg_idx, int subcase, int run_arg)
{
    char keybuf[0x20];          /* [bp-0x20] message-key scratch */
    char body[0x300];           /* [bp-0x320] dialog body buffer */
    int  saved_cursor;          /* [bp-8] */
    void far *menu = 0;         /* [bp-0xC]:[bp-0xA] */
    void far *rec;              /* [bp-2]:si  per-portrait far record (DX:AX) */

    /* --- enter modal: suppress map cursor, clear in-screen flag --- */
    saved_cursor = g_word_372;                       /* @asm 0x075360 MOV ax,[0x372] */
    g_word_372 = 0;                                  /* @asm 0x075368 */
    g_word_1F64 = 0;                                 /* @asm 0x07536B */

    /* --- look up the base KINGLSS message + set the dialog region --- */
    strcpy_near(keybuf, (char *)(uintptr_t)KEY_KINGLSS);  /* @asm 0x07536E 0xD1D:0x7E4 */
    ov_lookup_msg(msg_idx, keybuf);                  /* @asm 0x075385 0x181F:0x182 */
    if (ov_region_setup(body, 0,
                        g_dialog_rect[0], g_dialog_rect[1],
                        g_dialog_rect[2], g_dialog_rect[3],
                        keybuf) != 0)                /* @asm 0x0753A9 0x181F:0x44E */
        goto exit_restore;                           /* @asm 0x0753B5 JMP 0x40D3 */

    /* --- pick the player nation's KING portrait key (ENGLND/FRANCE/SPAIN/DUTCH) --- */
    {
        int key;
        switch (g_nation_5398) {                     /* @asm 0x0753B8 switch [0x5398] */
        case 0:  key = KEY_ENGLND; break;            /* @asm 0x0753CA */
        case 1:  key = KEY_FRANCE; break;            /* @asm 0x0753D0 */
        case 2:  key = KEY_SPAIN;  break;            /* @asm 0x0753D6 */
        case 3:  key = KEY_DUTCH;  break;            /* @asm 0x0753DC */
        default: key = 0; break;                     /* @asm 0x0753C8 JMP past strcpy */
        }
        if (key) strcpy_near(keybuf, (char *)(uintptr_t)key); /* @asm 0x0753E3 0xD1D:0x7E4 */
    }

    /* --- PASS 1: draw the KING portrait --- */
    ov_lookup_msg(msg_idx, keybuf);                  /* @asm 0x0753F3 0x181F:0x182 */
    ov_rec_first();                                  /* @asm 0x0753FB 0x191F:0xFDE */
    rec = ov_rec_next(keybuf, 0);                    /* @asm 0x075405 0x191F:0xFD0 -> DX:AX */
    if (rec != 0) {                                  /* @asm 0x07540F OR dx,ax / JE */
        /* draw the king portrait (x = rec[+0x46], sprite = rec[+0x48]) into the
         * dialog rect; sz arg 0x64, ax=1.  @asm 0x075413..0x07542B 0x181F:0x2F8 */
        ov_draw_portrait(rec, 0x839E);
    }

    /* --- choose the audience title key, drive any intro anim --- */
    if (msg_idx == 1 && subcase == 1) {              /* @asm 0x075430/0x075436 */
        strcpy_near(keybuf, (char *)(uintptr_t)KEY_KING1);  /* @asm 0x075443 0xD1D:0x7E4 */
        ov_play_audience_anim(0x3E);                 /* @asm 0x07544D 0x181F:0x48E (anim id 0x3E) */
    } else if (msg_idx != 1) {                       /* @asm 0x075430 JNE 0x3FCE */
        strcpy_near(keybuf, (char *)(uintptr_t)KEY_KINGWIN);  /* @asm 0x075465 0xD1D:0x7E4 (0x2323) */
    } else {                                         /* msg_idx==1 && subcase!=1 */
        strcpy_near(keybuf, (char *)(uintptr_t)KEY_KINGLOSE); /* @asm 0x075465 (0x231A) */
    }

    /* --- PASS 2: draw the player's (diplomat/leader) portrait --- */
    ov_rec_first();                                  /* @asm 0x07546D 0x191F:0xFDE */
    rec = ov_rec_next(keybuf, 0);                    /* @asm 0x075477 0x191F:0xFD0 */
    if (rec != 0) {                                  /* @asm 0x075481 OR dx,ax / JE */
        ov_draw_portrait(rec, 0x839E);               /* @asm 0x075485..0x07549D 0x181F:0x2F8 */
    }

    /* --- composite the audience scene full-screen --- */
    ov_snapshot();                                   /* @asm 0x0754A2 0x181F:0x3B6 */
    ov_set_mode_buf(0/*ss*/, body);                  /* @asm 0x0754AD 0x181F:0x3F4 (buf) */
    /* full-screen blit (w=0x140, h=0xC8) with BOTH the dialog rect and the
     * [0x2DA8..] region.  @asm 0x0754B2..0x0754DB 0x181F:0x444 */
    ov_full_blit(g_dialog_rect[0], g_dialog_rect[1], g_dialog_rect[2], g_dialog_rect[3],
                 g_region_2DA8[0], g_region_2DA8[1], g_region_2DA8[2], g_region_2DA8[3],
                 0xC8, 0, 0, 0x140);
    ov_clear_rect(0, 0x140, 0xC8, 0, 0, 0);          /* @asm 0x0754ED 0x181F:0xE2 */

    /* --- swap in FONTKING, override the font cell metrics, run the audience ---
     * set_font returns a far ptr in DX:AX -> menu [bp-0xC](off):[bp-0xA](seg).
     * The text-context word-pair [0x1F9E]/[0x1FA0] is set from that ptr if
     * non-null (off,seg), else from the default context [0x89E]/[0x8A0].
     * @asm 0x0754F6..0x075518:
     *   [bp-0xc]=ax(off); [bp-0xa]=dx(seg); OR dx,ax/JE;
     *   non-null: dx=[bp-0xa]  (ax keeps off) ; null: ax=[0x89E],dx=[0x8A0];
     *   [0x1F9E]=ax ; [0x1FA0]=dx. */
    menu = ov_set_font(KEY_FONTKING);                /* @asm 0x0754F6 0x1A1F:0xA86 */
    if (menu != 0) {                                 /* @asm 0x075501 OR dx,ax / JE 0x407A */
        g_textctx_1F9E = FP_OFF(menu);               /* @asm 0x075511 ax = menu offset */
        g_textctx_1FA0 = FP_SEG(menu);               /* @asm 0x075505 dx = menu segment */
    } else {
        g_textctx_1F9E = g_word_89E;                 /* @asm 0x07550A default context off */
        g_textctx_1FA0 = g_word_8A0;                 /* @asm 0x07550D default context seg */
    }

    /* save + override the font-cell globals for the king render. @asm 0x075518..0x07553A */
    {
        int sv_4A = g_font_1F4A, sv_50 = g_font_1F50, sv_52 = g_font_1F52;
        g_font_1F4A = 0xF2;                          /* @asm 0x075526 */
        g_font_1F50 = 0x2F;                          /* @asm 0x07552C */
        g_font_1F52 = 0;                             /* @asm 0x075532 */
        g_font_1F56 |= 0x18;                         /* @asm 0x075538 */

        /* run the audience dialog (king speaks; player picks a response). */
        dialog_run(run_arg);                         /* @asm 0x075540 0x181F:0x3FE (bx=[bp+0xA]) */

        g_font_1F4A = sv_4A;                         /* @asm 0x075545 */
        g_font_1F50 = sv_50;                         /* @asm 0x075549 */
        g_font_1F52 = sv_52;                         /* @asm 0x075550 */
    }

    ov_snapshot();                                   /* @asm 0x075553 0x181F:0x3B6 */
    ov_set_mode(0xFC00, 0xA000);                     /* @asm 0x07555E 0x181F:0x3F4 */

exit_restore:
    /* --- restore: free menu if any, restore text context + cursor latch --- */
    if (menu != 0) {                                 /* @asm 0x075563 OR / JE */
        menu_free(menu);                             /* @asm 0x075571 0x191F:0x1A8 */
    }
    g_textctx_1F9E = g_word_268A;                    /* @asm 0x075576/0x07557D */
    g_textctx_1FA0 = g_word_268C;
    g_word_1F64 = 1;                                 /* @asm 0x075584 */
    g_word_372 = saved_cursor;                       /* @asm 0x07558A MOV [0x372],ax */
    return 0;                                         /* @asm 0x075592 LEAVE/RETF */
}
