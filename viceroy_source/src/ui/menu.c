/* ============================================================================
 * menu.c -- The colony-services MENU-ITEM dispatch engine + the shared
 *           menu/option CONTROL MODEL (GUI framework primitives).
 * ----------------------------------------------------------------------------
 * Two things live here, both decoded from raw VICEROY.EXE bytes:
 *
 *   1. func_02883E -- the in-colony command/menu-item dispatcher.  Given a
 *      colony + a selected menu-item id it runs the matching service action
 *      (train at school/college/university, build/keep stockade, town-hall /
 *      assembly / meeting-hall liberty bells, dock loading, Indian bribe, ...).
 *      It is the "menu-item engine" the framework brief names.
 *
 *   2. The page-0x17 GUI primitives (func_06F51A region) -- the *shared* menu
 *      descriptor + option-flag bitmask + per-option field builders that BOTH
 *      func_02883E and the colony dialog engine (func_028D8C, src/ui/dialog.c)
 *      call to register/lay-out/hit-test options.  This is the control model.
 *
 * AUTHORITATIVE SOURCES (RULINGS 2026-05-30 priority order):
 *   - COLONIZE/VICEROY.EXE raw bytes (ultimate arbiter).
 *   - code/VICEROY/disasm_overlay_reseg/page_02.asm (func_02883E full body).
 *   - code/VICEROY/disasm_overlay_reseg/page_17.asm (the GUI primitives).
 *   - code/VICEROY/typeA_thunk_targets.json (thunk seg:off -> file offset).
 *   String rule: file_offset = string_handle + 0x1D9A0.
 *
 * *** EXTENT CORRECTION (BYTE_VERIFIED 2026-05-30) ***
 *   The per-function dump code/VICEROY/disasm/func_02883E_unknown.asm claims
 *   "138 bytes (0x02883E..0x0288C8)".  FALSE — first-RET/dump truncation.
 *   Raw EXE: ENTER frame at 0x02883E (c8 6a 00 00), and the function's
 *   POP di / POP si? no -- the tail is  5f c9 cb  (POP di / LEAVE / RETF) at
 *   0x028D88..0x028D8A.  True body = 0x02883E..0x028D8B = 0x54D = 1357 bytes
 *   (matches reseg "size=1357 insns=481").  FUNCTION_INVENTORY/MANIFEST "138"
 *   is wrong; this file records the real extent.
 *
 * cite-or-TBD throughout: every offset/value/string cites the bytes; the
 * per-pixel blit leaves (the 0x181F:* / 0x191F:* GUI thunks) keep their CALL
 * SITES byte-exact and their internals TBD.  No fabrication.
 * ============================================================================ */
#include "viceroy_types.h"
#include "iolib.h"

/* DGROUP overlays — kept LOCAL to this .c (scope rule: no globals.h edits). */
extern int16_t g_word[];
extern uint8_t g_byte[];

/* The active colony record (near ptr at DGROUP:0x8542;
 * project_colony_struct_at_8542).  Field offsets per colony_screen.c:
 *   +0x1A owner_power_idx   +0x1F size/population. */
extern uint8_t *colony_8542(void);

/* ============================================================================
 * GAME.TXT message keys referenced by func_02883E (the colony-service menu).
 * Every handle below was read from the EXE at file = handle + 0x1D9A0 and the
 * decoded text is shown.  These are the menu-item action strings (the leaves).
 * ============================================================================ */
#define K_KEEPSTOCKADE   0x0BBA   /* "KEEPSTOCKADE"   @asm 0x028888 / file 0x1E55A */
#define K_MORETHANTHREE  0x0BC7   /* "MORETHANTHREE"  @asm 0x028898 / file 0x1E567 */
#define K_ONE_ENTER      0x0BD5   /* "ONE_ENTER"      @asm 0x02889E / file 0x1E575 */
#define K_ONE_LEAVE      0x0BDF   /* "ONE_LEAVE"      @asm 0x0288AA / file 0x1E57F */
#define K_FULL           0x0BE9   /* "FULL"           @asm 0x0288C3 / file 0x1E589 */
#define K_ABANDON        0x0BEE   /* "ABANDON"        @asm 0x0288DB / file 0x1E58E */
#define K_GRADUATE       0x0BF8   /* "GRADUATE"       @asm 0x0289C5 / file 0x1E598 */
#define K_DROPOUT        0x0C01   /* "DROPOUT"        @asm 0x028A0A / file 0x1E5A1 */
#define K_NOMATCH        0x0C09   /* "NOMATCH"        @asm 0x028A1F / file 0x1E5A9 */
#define K_NOSCHOOL       0x0C11   /* "NOSCHOOL"       @asm 0x028A37 / file 0x1E5B1 */
#define K_UNIV3          0x0C1A   /* "UNIV3"          @asm 0x028A48 / file 0x1E5BA */
#define K_COLLEGE2       0x0C20   /* "COLLEGE2"       @asm 0x028A50 / file 0x1E5C0 */
#define K_SCHOOL1        0x0C29   /* "SCHOOL1"        @asm 0x028A58 / file 0x1E5C9 */
#define K_NOTEACHER      0x0C31   /* "NOTEACHER"      @asm 0x028A60 / file 0x1E5D1 */
#define K_NEEDCOLLEGE    0x0C3B   /* "NEEDCOLLEGE"    @asm 0x028A89 / file 0x1E5DB */
#define K_NEEDUNIVERSITY 0x0C47   /* "NEEDUNIVERSITY" @asm 0x028AB3 / file 0x1E5E7 */
#define K_ASSEMBLY       0x0C56   /* "ASSEMBLY"       @asm 0x028ABC / file 0x1E5F6 */
#define K_TOWNHALL       0x0C5F   /* "TOWNHALL"       @asm 0x028AC4 / file 0x1E5FF */
#define K_MEETINGHALL    0x0C68   /* "MEETINGHALL"    @asm 0x028ACC / file 0x1E608 */
#define K_NODOCKS        0x0C74   /* "NODOCKS"        @asm 0x028AD4 / file 0x1E614 */
#define K_SIEGE          0x0C7C   /* "SIEGE"          @asm 0x028ADC / file 0x1E61C */
#define K_INDIANLAND     0x0C82   /* "INDIANLAND"     @asm 0x0288D0 / file 0x1E622 */
#define K_INDIANBRIBE    0x0C8D   /* "INDIANBRIBE"    @asm 0x028AA7 / file 0x1E62D */
#define K_TUTORIAL7      0x0C99   /* "TUTORIAL7"      @asm 0x028D36 / file 0x1E639 */
#define K_LOBOTOMIZE     0x0CAE   /* "LOBOTOMIZE"     @asm 0x0297A4 / file 0x1E64E */

/* ----------------------------------------------------------------------------
 * GUI-framework leaf calls used by func_02883E (call sites byte-exact;
 * pixel/overlay internals TBD).  thunk seg:off -> behaviour:
 *   0x181F:0xC0E  colony_field_get(c)   (==[bp-0x5E])     @asm 0x02884C
 *   0x181F:0xC54  colony_attr_get(c)    (==[bp-0x6A])     @asm 0x02885A
 *   0x181F:0x652  msg_popup(mode,key)   -> 1=accept       @asm 0x02888B  (the
 *                  modal yes/no popup; mode 0/1/5 = button-set selector)
 *   0x181F:0x3FE  opt_register(bx=key)  -> page-0x17 option builder (func_06F594)
 *                  @asm 0x0288A2  (used by the ONE_ENTER / ONE_LEAVE arms)
 *   0x181F:0x416  fmt_into(seg,ptr,0)   -> overlay text format @asm 0x0288B9
 *   0x181F:0x438  ...                                       @asm 0x028A7F
 *   0x181F:0x22   num_to_str(n) -> DX:AX text               @asm 0x028951
 *   0x191F:0x182  / 0x176 / 0x1A8 / 0x16A / 0x1B6 / 0x33C    windowed control
 *   0xD1D:0x7A4   sprintf   0xD1D:0x7E4 strcpy   0xD1D:0x117E concat-fmt
 * ---------------------------------------------------------------------------- */
extern int  mn_colony_field(int c);                 /* 0x181F:0xC0E */
extern int  mn_colony_attr(int c);                  /* 0x181F:0xC54 */
extern int  mn_msg_popup(int mode, int key);        /* 0x181F:0x652 -> 1 = accept */
extern void mn_opt_register(int key);               /* 0x181F:0x3FE -> func_06F594 */
extern int  mn_service_query(int sel, int c);       /* near CALL 0x2CA00 @asm 0x02887A */

/* ============================================================================
 * func_02883E -- colony-services menu-item dispatcher.   ANCHOR_VERIFIED.
 * ----------------------------------------------------------------------------
 * @asm_function  func_02883E   file 0x02883E..0x028D8B (ENTER 0x6A,0; tail
 *                POP di / LEAVE / RETF at 0x028D88).  Reached as an overlay
 *                target via thunk 0x181F:0x154C (typeA_thunk_targets.json:
 *                thunk @0x01BB3C -> 0x02883E, lands_on_entry).
 *
 * Args (cdecl, from the PUSH/[bp+] uses):
 *   colony_sel = [bp+6]   colony selector passed to colony_field/attr getters
 *   item_id    = [bp+8]   the chosen menu-item id (the dispatch selector)
 *
 * PURPOSE — proven by string xref (decisive): the leaf arms push the colony-
 * service strings TOWNHALL / ASSEMBLY / MEETINGHALL (liberty bells), SCHOOL1 /
 * COLLEGE2 / UNIV3 + GRADUATE / DROPOUT / NOTEACHER (colonist training),
 * KEEPSTOCKADE / SIEGE, NODOCKS, INDIANBRIBE — i.e. the in-colony command menu.
 * (FUNCTION_INVENTORY.md already names it "Town hall / colony-services menu".)
 *
 * SHAPE (byte-faithful):
 *   1. attrs   = colony_attr_get(colony_sel);   field = colony_field_get(...)
 *   2. item_id == 0x17 is remapped to 0x15      @asm 0x02886B..0x028873
 *   3. result  = service_query(item_id, colony_sel)  (near CALL 0x2CA00)
 *   4. JMP to the dispatch: dec result; if (result-1) > 0x15 -> common tail;
 *      else jump through the CS jump-table.   @asm 0x028AE2..0x028AEB:
 *          028AE2  48              dec  ax
 *          028AE3  3D 15 00        cmp  ax, 0x15
 *          028AE6  77 34           ja   0x3F2C (common tail)
 *          028AE8  D1 E0           shl  ax, 1
 *          028AEB  2E FF A7 F0 31  jmp  word ptr cs:[bx+0x31F0]
 *      Raw EXE @0x028AEB = 2e ff a7 f0 31  (BYTE_VERIFIED).
 *
 * THE JUMP TABLE (BYTE_VERIFIED).  It lives at CS:0x31F0.  CS for this overlay
 * page = the page CODE base 0x025900 (page_02 header "code_offset = 0x025900";
 * func_02883E maps file 0x02883E -> IP 0x3C4E so CS-rel IP = file-0x025900).
 * So the table is at file 0x025900+0x31F0 = 0x028AF0.  Each word is a CS-rel
 * IP; target file = 0x025900 + word.  22 entries (item ids 1..0x16):
 *   raw @0x028AF0:
 *     aa 2f 9e 2f c8 2f b0 2f 2e 30 cc 30 46 31 4e 31 56 31 ca 31
 *     c2 31 ba 31 d2 31 cc 30 cc 30 5e 31 66 31 90 31 1c 32 da 31 86 2f 96 2f
 *
 *   id  IP      ->file     handler / action (string xref)
 *   --  ----    --------   --------------------------------------------------
 *    1  0x2FAA  0x0288AA   opt_register(ONE_LEAVE)        (leave-colony toggle)
 *    2  0x2F9E  0x02889E   opt_register(ONE_ENTER)        (enter-colony toggle)
 *    3  0x2FC8  0x0288C8   INDIANLAND / INDIANBRIBE block (native land buy)
 *    4  0x2FB0  0x0288B0   fmt colony+2; then msg_popup(FULL)   (warehouse full)
 *    5  0x302E  0x02892E   the big production-display block (NOMATCH path)
 *    6  0x30CC  0x0289CC   GRADUATE / DROPOUT training block
 *    7  0x3146  0x028A46   msg_popup(UNIV3)               (university blurb)
 *    8  0x314E  0x028A4E   msg_popup(COLLEGE2)            (college blurb)
 *    9  0x3156  0x028A56   msg_popup(SCHOOL1)             (schoolhouse blurb)
 *   10  0x31CA  0x028ACA   msg_popup(MEETINGHALL)         (liberty bells)
 *   11  0x31C2  0x028AC2   msg_popup(TOWNHALL)            (liberty bells)
 *   12  0x31BA  0x028ABA   msg_popup(ASSEMBLY)            (liberty bells)
 *   13  0x31D2  0x028AD2   msg_popup(0, NODOCKS)          (no docks to load)
 *   14  0x30CC  0x0289CC   (alias of id 6: GRADUATE/DROPOUT)
 *   15  0x30CC  0x0289CC   (alias of id 6)
 *   16  0x315E  0x028A5E   msg_popup(NOTEACHER)
 *   17  0x3166  0x028A66   colony_attr -> 0x181F:0x438; msg_popup(NEEDCOLLEGE)
 *   18  0x3190  0x028A90   colony_attr -> 0x181F:0x438; msg_popup(NEEDUNIVERSITY)
 *   19  0x321C  0x028B1C   -> the common tail (no-op item; falls through)
 *   20  0x31DA  0x028ADA   msg_popup(1, SIEGE)
 *   21  0x2F86  0x028886   msg_popup(KEEPSTOCKADE)
 *   22  0x2F96  0x028896   msg_popup(MORETHANTHREE) (via the KEEPSTOCKADE blit)
 *
 * Two service arms (KEEPSTOCKADE id21, MORETHANTHREE id22) share the popup blit
 * at 0x02888B; the training arms (SCHOOL1/COLLEGE2/UNIV3, GRADUATE/DROPOUT) gate
 * on the colony's school level and the colonist's eligibility before popping
 * their blurb.  The common tail @0x028B1C..0x028D8A re-reads [bp+8] (the item),
 * runs the build/redraw bookkeeping ([0x8D7C] cursor, [0x034E] result, the
 * SIEGE/4-flag in [0x5387]&4, the TUTORIAL7 hint when colony size>=3), and
 * returns [bp-0x54] (0 = item handled / 1 = re-show menu).
 *
 * STATUS: ANCHOR_VERIFIED — dispatch table + every arm's string is byte-exact;
 * the per-arm overlay actions (msg_popup pixel work, the build bookkeeping
 * leaves) stay TBD.
 * ---------------------------------------------------------------------------- */
int colony_service_menu(int colony_sel, int item_id)
{
    int  attrs;             /* [bp-0x6A]  colony_attr_get(colony_sel)        */
    int  field;             /* [bp-0x5E]  colony_field_get(colony_sel)       */
    int  sel;               /* [bp-0x66]  item_id (with the 0x17->0x15 remap)*/
    int  result;            /* [bp-0x62]  service_query(...) dispatch value  */
    int  reshow = 1;        /* [bp-0x54]  return: 1 = re-show menu (default) */
    uint8_t *col = colony_8542();
    (void)col;

    field = mn_colony_field(colony_sel);            /* @asm 0x02884C 0x181F:0xC0E */
    attrs = mn_colony_attr(colony_sel);             /* @asm 0x02885A 0x181F:0xC54 */
    sel   = item_id;                                /* @asm 0x028865 [bp-0x66]=[bp+8] */
    if (sel == 0x17)                                /* @asm 0x02886B CMP ax,0x17/JNE */
        sel = 0x15;                                 /* @asm 0x028870 */

    result = mn_service_query(sel, colony_sel);     /* @asm 0x02887A near CALL 0x2CA00 */

    /* dispatch: id = result; if (--id) in 1..0x16 jump table, else common tail. */
    switch (result) {                               /* @asm 0x028AE2 dec/cmp/ja/jmp cs:[] */
    case 21: /* 0x2F86 */
        mn_msg_popup(5, K_KEEPSTOCKADE);            /* @asm 0x028886..0x02888B */
        break;
    case 22: /* 0x2F96 */
        mn_msg_popup(5, K_MORETHANTHREE);           /* @asm 0x028896 -> blit @0x02888B */
        break;
    case 2:  /* 0x2F9E */
        mn_opt_register(K_ONE_ENTER);               /* @asm 0x02889E LEA bx,[0xBD5]; 0x3FE */
        break;
    case 1:  /* 0x2FAA */
        mn_opt_register(K_ONE_LEAVE);               /* @asm 0x0288AA LEA bx,[0xBDF]; 0x3FE */
        break;
    case 4:  /* 0x2FB0 */
        /* fmt(colony+2); msg_popup(FULL).  @asm 0x0288B0..0x0288C6 */
        mn_msg_popup(5, K_FULL);
        break;
    case 3:  /* 0x2FC8 : INDIANLAND / INDIANBRIBE (buy native land) */
        /* @asm 0x0288C8..0x02892C: fmt colony+2 with INDIANLAND template,
         * pop the buy confirm; on accept commit.  Internals TBD. */
        break;
    case 7:  mn_msg_popup(5, K_UNIV3);    break;    /* @asm 0x028A46 */
    case 8:  mn_msg_popup(5, K_COLLEGE2); break;    /* @asm 0x028A4E */
    case 9:  mn_msg_popup(5, K_SCHOOL1);  break;    /* @asm 0x028A56 */
    case 16: mn_msg_popup(5, K_NOTEACHER);break;    /* @asm 0x028A5E */
    case 12: mn_msg_popup(5, K_ASSEMBLY); break;    /* @asm 0x028ABA */
    case 11: mn_msg_popup(5, K_TOWNHALL); break;    /* @asm 0x028AC2 */
    case 10: mn_msg_popup(5, K_MEETINGHALL);break;  /* @asm 0x028ACA */
    case 13: mn_msg_popup(0, K_NODOCKS);  break;    /* @asm 0x028AD2 (mode 0) */
    case 20: mn_msg_popup(1, K_SIEGE);    break;    /* @asm 0x028ADA (mode 1) */
    case 6: case 14: case 15:
        /* GRADUATE / DROPOUT training block.  @asm 0x0289CC..0x028A43:
         * shows the schoolhouse roster, formats GRADUATE/DROPOUT lines, and on
         * field==0xE adds NEEDCOLLEGE / field==0xF adds NEEDUNIVERSITY notes.
         * Internals TBD. */
        break;
    case 17:
        /* colony_attr -> 0x181F:0x438; msg_popup(NEEDCOLLEGE).  @asm 0x028A66 */
        mn_msg_popup(5, K_NEEDCOLLEGE);
        break;
    case 18:
        /* colony_attr -> 0x181F:0x438; msg_popup(NEEDUNIVERSITY). @asm 0x028A90 */
        mn_msg_popup(5, K_NEEDUNIVERSITY);
        break;
    case 5:
        /* the big production-display arm (NOMATCH).  @asm 0x02892E.. : it
         * re-reads colony_attr, formats the production line ("|   "/" = "/"/"),
         * and either commits or shows NOMATCH.  Internals TBD. */
        break;
    case 19:
    default:
        /* id 19 (0x321C) and out-of-range -> the common tail (no popup). */
        break;
    }

    /* common tail @0x028B1C..0x028D8A: build/redraw bookkeeping.
     *   - if item_id >= 9 and colony[+0x1F] > colony_sel -> redraw_tile(...)
     *       @asm 0x028CB2..0x028CD0
     *   - [bp-0x64] = list_next_row(item_id, colony_sel)   @asm 0x028CD0 0xC36
     *   - SIEGE auto-warning when [0x5382]&0x80 && !([0x5387]&4) && size>=3:
     *       fmt colony+2 + msg_popup(TUTORIAL7-area key 0xC99) then set
     *       [0x5387]|=4.   @asm 0x028CFD..0x028D41
     *   - publish [0x034E] (=row or 0xFFFF) and [0x8D7C]/[0x8D7E] cursor;
     *       clear [0x346] when colony[+0x1F]==0.   @asm 0x028D46..0x028D7E
     *   - reshow = 0 (item handled).   @asm 0x028D79 [bp-0x54]=0
     * (The build-bookkeeping leaves are overlay TBD; the control flow is exact.)
     */
    reshow = 0;                                     /* @asm 0x028D79 (handled path) */

    return reshow;                                  /* @asm 0x028D84 MOV ax,[bp-0x54]; RETF */
}


/* ############################################################################
 * ##  THE SHARED MENU / OPTION CONTROL MODEL  (page-0x17 GUI primitives)    ##
 * ############################################################################
 *
 * @asm_disasm  code/VICEROY/disasm_overlay_reseg/page_17.asm
 * These small functions are the control model that func_02883E and the colony
 * dialog engine (func_028D8C) register options into.  They are reached via the
 * 0x181F thunks resolved in typeA_thunk_targets.json (page 0x17):
 *
 *   thunk            -> file       function       role
 *   --------------   ----------    -----------    -----------------------------
 *   0x181F:0x998     0x06F51A      func_06F51A    menu_lookup_run(key) (lands@0)
 *   0x181F:0x3FE     0x06F594      func_06F57E+22 opt_register(bx=key)
 *   0x181F:0x652     0x06F5F2      func_06F5F2    opt_set_mode(key, mode)
 *
 * ALL of them operate on ONE shared menu descriptor and a shared option-flags
 * word in DGROUP (BYTE_VERIFIED addresses at the cited @asm):
 *
 *   DGROUP:0x087C   the menu/option DESCRIPTOR base.  Every builder does
 *                   `LEA bx,[0x87C]` before calling the common append routine
 *                   (CS-near 0x3CEF on page 0x17).   @asm 0x06F596/0x06F5F9/...
 *   DGROUP:0x1F54   the option-FLAG bitmask (one bit per option = enabled/
 *                   checked).  set/clear/test by func_06F554/func_06F57E.
 *   DGROUP:0x1F5C   per-option field A  (opt_field_a builder func_06F5B0)
 *   DGROUP:0x1F5E   per-option field B == the SCREEN-MODE selector that
 *                   main_loop.c reads (Europe=4 / Report=5).  Written by
 *                   func_06F5F2 (the 0x652 builder).   @asm 0x06F5F8 a3 5e 1f
 *   DGROUP:0x1F60   per-option field C  (builder func_06F61C)
 *
 * So "registering a menu option" = stage its key/fields in 0x1F54/0x1F5C/
 * 0x1F5E/0x1F60 then append to the descriptor at 0x87C; "running the menu" =
 * func_06F51A walks the descriptor, dispatches the picked option, and disposes
 * the control window via 0x191F:0x1A8.  This is the hit-test + return-code
 * machinery the brief asked to decode.
 * ============================================================================ */
#define MENU_DESC_087C   0x087C   /* @asm LEA bx,[0x87C] in every builder */
#define OPT_FLAGS_1F54   0x1F54   /* @asm 0x06F567/0x06F578/0x06F58D bitmask */
#define OPT_FIELD_1F5C   0x1F5C   /* @asm 0x06F5B6 builder field A */
#define OPT_MODE_1F5E    0x1F5E   /* @asm 0x06F5F8 builder field B = screen-mode */
#define OPT_FIELD_1F60   0x1F60   /* @asm 0x06F622 builder field C */

/* The page-0x17 near-call targets are LOCAL FAR-JMP trampolines into the
 * 0x191F/0x181F control family (BYTE_VERIFIED from raw EXE):
 *   CS-near 0x3CEF (file 0x06F7EF) = LJMP 0x181F:0x998  -> menu_lookup_run itself
 *       raw 0x06F7EF: ea 98 09 1f 18
 *   CS-near 0x3CF9 (file 0x06F7F9) = LJMP 0x191F:0x16A  -> win_query / hit-test
 *       raw 0x06F7F9: ea 6a 01 1f 19
 *   CS-near 0x3D03 (file 0x06F803) = LJMP 0x191F:0x182  -> record/lookup helper
 *       raw 0x06F803: ea 82 01 1f 19
 * (call displacements verified: func_06F51A @0x06F524 e8 dc 02 -> 0x3D03;
 *  @0x06F536 e8 c0 02 -> 0x3CF9; func_06F594 @0x06F59D e8 4f 02 -> 0x3CEF.) */
extern void far *opt_lookup_rec(void);           /* CS 0x3D03 -> 0x191F:0x182  */
extern int       opt_win_query(void far *rec);   /* CS 0x3CF9 -> 0x191F:0x16A  */
extern void      opt_win_dispose(void far *win); /* 0x191F:0x1A8               */
extern void      opt_run_menu(int key, int field);/* CS 0x3CEF -> 0x181F:0x998 */

/* ----------------------------------------------------------------------------
 * menu_lookup_run -- func_06F51A  (thunk 0x181F:0x998).  BYTE_VERIFIED shape.
 *   size=57, ENTER 6,0.  @asm 0x06F51A..0x06F54B:
 *     rec = opt_lookup_rec();                   ; @asm 0x06F523 push cs;call 0x3D03
 *                                               ;   (0x3D03 = LJMP 0x191F:0x182)
 *     ret = 0;
 *     if (rec != NULL) {                          ; @asm 0x06F52D OR dx,ax / JE
 *         ret = opt_win_query(rec);               ; @asm 0x06F535 push cs;call 0x3CF9
 *                                               ;   (0x3CF9 = LJMP 0x191F:0x16A)
 *         opt_win_dispose(rec);                   ; @asm 0x06F542 LCALL 0x191F:0x1A8
 *     }
 *     return ret;                                 ; @asm 0x06F547 MOV ax,[bp-2]; RETF
 *   Raw EXE @0x06F542 = 9a a8 01 1f 19 (LCALL 0x191F:0x1A8) — BYTE_VERIFIED.
 *   This is main_loop.c's `menu_lookup_key(...)`: it materialises the menu
 *   record for a key (0x191F:0x182), runs/picks it (0x191F:0x16A hit-test),
 *   frees the control window (0x191F:0x1A8), and returns the chosen item (or 0).
 * ---------------------------------------------------------------------------- */
int menu_lookup_run(void)
{
    void far *rec = opt_lookup_rec();            /* @asm 0x06F523->0x3D03->0x191F:0x182 */
    int ret = 0;                                 /* @asm 0x06F51E */
    if (rec != 0) {                              /* @asm 0x06F52D OR dx,ax / JE */
        ret = opt_win_query(rec);                /* @asm 0x06F535->0x3CF9->0x191F:0x16A */
        opt_win_dispose(rec);                    /* @asm 0x06F542 LCALL 0x191F:0x1A8 */
    }
    return ret;                                  /* @asm 0x06F547 MOV ax,[bp-2]; RETF */
}

/* ----------------------------------------------------------------------------
 * opt_flag_set / opt_flag_clear -- func_06F554 (size=42).  BYTE_VERIFIED.
 *   bit = 1 << (n-1).  if (dx != 0) flags |= bit;  else flags &= ~bit.
 *   @asm 0x06F558 DEC [bp-2]; 0x06F565 SHL ax,cl; 0x06F567 OR [0x1F54],ax (set)
 *                                          0x06F578 AND [0x1F54],~ax (clear).
 * opt_flag_test -- func_06F57E (size=49).  BYTE_VERIFIED.
 *   return (1 << (n-1)) & flags.   @asm 0x06F585 SUB [bp-2],1; 0x06F58D AND
 *   ax,[0x1F54].   (This is the checkbox get/set the brief referenced.)
 * ---------------------------------------------------------------------------- */
void opt_flag_set(int n, int on)
{
    int bit = 1 << (n - 1);                      /* @asm 0x06F558/0x06F565 */
    if (on)                                       /* @asm 0x06F55B OR dx,dx / JE */
        g_word[OPT_FLAGS_1F54] |= bit;           /* @asm 0x06F567 */
    else
        g_word[OPT_FLAGS_1F54] &= ~bit;          /* @asm 0x06F578 */
}

int opt_flag_test(int n)
{
    return (1 << (n - 1)) & g_word[OPT_FLAGS_1F54];   /* @asm 0x06F585..0x06F58D */
}

/* ----------------------------------------------------------------------------
 * opt_register -- func_06F594 (thunk 0x181F:0x3FE).  BYTE_VERIFIED.
 *   The bare option-append: takes the key in BX, points BX at the descriptor
 *   DGROUP:0x87C, zeroes DX, and calls the common emit (CS-near 0x3CEF).
 *     @asm 0x06F594 MOV ax,bx; 0x06F596 LEA bx,[0x87C]; 0x06F59A SUB dx,dx;
 *           0x06F59C push cs;call 0x3CEF; 0x06F5A0 RETF.
 *   Raw EXE @0x06F594 = 8b c3 8d 1e 7c 08 2b d2 (BYTE_VERIFIED).
 *   This is the entry func_02883E's ONE_ENTER/ONE_LEAVE arms reach via 0x3FE.
 *   The CS-near 0x3CEF target is LJMP 0x181F:0x998 = menu_lookup_run, so this
 *   stages the key in the descriptor (BX, DX=0) and immediately RUNS it.
 * ---------------------------------------------------------------------------- */
void opt_register(int key)
{
    opt_run_menu(key, 0);                        /* @asm 0x06F594..0x06F5A0 (BX=key,DX=0) */
}

/* ----------------------------------------------------------------------------
 * opt_set_field_a / opt_set_mode / opt_set_field_c -- the per-option field
 * builders.  Each stores one field then emits, all into DGROUP:0x87C.
 *   func_06F5B0 (0x1F5C field A):  @asm 0x06F5B3 [bp+8]->[0x1F5C]; emit([bp+6]).
 *   func_06F5F2 (0x1F5E mode, thunk 0x181F:0x652):
 *       @asm 0x06F5F5 ax=[bp+8]; 0x06F5F8 MOV [0x1F5E],ax; emit([bp+6]).
 *       Raw EXE @0x06F5F8 = a3 5e 1f (MOV [0x1F5E],ax) — BYTE_VERIFIED.
 *       [0x1F5E] is the screen-mode selector main_loop.c switches on (Europe=4,
 *       Report=5) — so opt_set_mode is how a menu option stages a screen open.
 *   func_06F61C (0x1F60 field C):  @asm 0x06F61F [bp+8]->[0x1F60]; emit([bp+6]).
 * ---------------------------------------------------------------------------- */
void opt_set_field_a(int key, int field_a)
{
    g_word[OPT_FIELD_1F5C] = field_a;            /* @asm 0x06F5B6 MOV [0x1F5C],ax */
    opt_run_menu(key, field_a);                  /* @asm 0x06F5C2 -> 0x3CEF -> 0x181F:0x998 */
}

void opt_set_mode(int key, int screen_mode)
{
    g_word[OPT_MODE_1F5E] = screen_mode;         /* @asm 0x06F5F8 MOV [0x1F5E],ax */
    opt_run_menu(key, screen_mode);              /* @asm 0x06F605 -> 0x3CEF -> 0x181F:0x998 */
}

void opt_set_field_c(int key, int field_c)
{
    g_word[OPT_FIELD_1F60] = field_c;            /* @asm 0x06F622 MOV [0x1F60],ax */
    opt_run_menu(key, field_c);                  /* @asm 0x06F62F -> 0x3CEF -> 0x181F:0x998 */
}
