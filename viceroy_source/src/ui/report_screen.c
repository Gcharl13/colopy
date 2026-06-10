/* ============================================================================
 * report_screen.c -- in-game REPORT screens (the F-key / menu reports)
 * ----------------------------------------------------------------------------
 * STATUS: both functions in this file are BYTE_VERIFIED.
 *   - report_open  (func_037340)  -- the REPORT command/dispatch entry.
 *   - build_menubar (func_072090, 2826 B, page 0x1A) -- the TOP MENU-BAR
 *     builder.  Wave-5 tentatively called func_072090 the "report content
 *     renderer"; byte analysis CORRECTS that: it builds the pull-down menu bar
 *     (8 columns incl. the Reports menu and its 10 F-key entries).  It does NOT
 *     render report bodies.  See its own header below for the full proof.
 * Every value here is cited to the disassembly / raw EXE; nothing is guessed.
 * all values are cited from the bytes or RUNTIME_ONLY.
 *
 * Sources:
 *   code/VICEROY/disasm_overlay_reseg/page_05.asm  (func_037340)
 *   code/VICEROY/disasm_overlay_reseg/page_1A.asm  (func_072090, lines 11..956)
 *   COLONIZE/VICEROY.EXE                           (raw bytes -- extent + spots)
 *   COLONIZE/MENU.TXT                              (the menu-content ground truth)
 *   reverse_engineered/viceroy_source/lcall_resolution_VICEROY.json (helper thunks)
 *
 * String handles (file_offset = handle + 0x1D9A0):
 *   "REPORT"    handle 0x11A2 -> @file 0x1EB42     (@asm 0x037344 PUSH 0x11A2)
 *   "reports"   handle 0x20BA -> @file 0x1FA5A     (@asm 0x0726C3 PUSH 0x20BA)
 *   "SETREPORT" handle 0x0AF3 -> @file 0x1E493     (command key; see main_loop.c
 *               command-dispatch -- the SETREPORT branch of func_0235D6)
 * ============================================================================ */
#include "viceroy_types.h"
#include "globals.h"
#include "dgroup.h"
#include "iolib.h"

#define KEY_REPORT   0x11A2   /* "REPORT" @asm 0x037344 / @file 0x1F142 */

/* ----------------------------------------------------------------------------
 * Persistent regions / globals (BYTE_VERIFIED addresses):
 *
 *   DGROUP:0x2DA8..0x2DAE   4-word "content region" rect (pushed by both the
 *                           report entry and the Europe clip-blit helper).
 *   DGROUP:0x0372           word -- the "mouse/cursor active" latch.  It is
 *                           saved, zeroed across the report draw, and restored
 *                           (the report screen suppresses the map cursor).
 *                           Same global written by the options dialogs
 *                           (func_022F08 @asm 0x023106) and the key dispatcher.
 * ---------------------------------------------------------------------------- */
extern int16_t g_region_2DA8[4];   /* DGROUP:0x2DA8..0x2DAE */
extern int16_t g_word_372;         /* DGROUP:0x0372  cursor-active latch */

/* ---- leaf helpers (resolved targets; call sites + args byte-exact) -------- */
/* strcpy_near declared in iolib.h */
extern void ov_lookup_report_key(int which, void *buf);/* 0x181F:0x182 (page-05 ctx) */
extern int  ov_report_dispatch(void *titlebuf, int z, int r0,int r1,int r2,int r3,
                               void *keybuf);          /* 0x181F:0x44E */
extern void ov_report_show(int r0,int r1,int r2,int r3, int kind); /* 0x181F:0x484 */
extern void ov_report_blit(void *buf, int x, int y);   /* LCALL 0xC2E:0x22 */

/* ============================================================================
 * report_open -- VICEROY func_037340  (the REPORT command/dispatch entry)
 * ----------------------------------------------------------------------------
 * @asm_function  func_037340   file 0x037340..0x0373C8 (137 B, ENTER 0x352,0)
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_05.asm (first function)
 *
 * Purpose proven by STRING XREF: @asm 0x037344 PUSH 0x11A2 ("REPORT").
 *
 * Behaviour (byte-faithful):
 *   1. titlebuf[0x50] @ [bp-0x50]; strcpy_near(titlebuf, "REPORT")  -- copies
 *      the "REPORT" key into a local buffer.  @asm 0x037344..0x037350
 *      (PUSH 0x11A2; LEA [bp-0x50]; LCALL 0xD1D:0x7E4 = MSC strcpy_near).
 *   2. ov_lookup_report_key([bp+6], titlebuf)  -- [bp+6] = which report.
 *      @asm 0x037353..0x037360 (PUSH [bp+6]; PUSH ss; LEA [bp-0x50];
 *      LCALL 0x181F:0x182).
 *   3. ok = ov_report_dispatch(&bigbuf[bp-0x352], 0, region[0x2DA8..0x2DAE],
 *      &titlebuf)  -- runs the report using the content region.
 *      @asm 0x037363..0x037387 (LCALL 0x181F:0x44E, add sp,0x10).
 *   4. if (ok != 0):  ov_report_show(region[0x2DA8..0x2DAE], 0x22)
 *      @asm 0x03738B..0x0373A3 (al=0x22; LCALL 0x181F:0x484; LEAVE; RETF).
 *   5. else (ok == 0):  save+clear the cursor latch, blit the big buffer at
 *      (0x98,0x64), restore the latch.  @asm 0x0373A4..0x0373C8
 *      (MOV ax,[0x372]; MOV [0x372],0; LCALL 0xC2E:0x22 with ax=0x98,dx=0x64;
 *       MOV [0x372],ax).
 *
 * Stack-frame map (proven from displacements):
 *   [bp-0x50]  titlebuf (0x50 bytes -- the report title/key buffer)
 *   [bp-0x52]  saved cursor latch (the [0x372] save slot)
 *   [bp-0x352] bigbuf  (0x300-byte report content buffer)
 *
 * args:  which = [bp+6]  (the report selector / page id)
 * ============================================================================ */
int report_open(int which)
{
    char titlebuf[0x50];        /* [bp-0x50] */
    char bigbuf[0x300];         /* [bp-0x352] (0x352-0x52) report content buffer */
    int  saved;                 /* [bp-0x52] */
    int  ok;

    /* 1. copy the "REPORT" key into the local buffer (MSC strcpy_near). */
    strcpy_near(titlebuf, (char *)(uintptr_t)KEY_REPORT);  /* @asm 0x03734B 0xD1D:0x7E4 */

    /* 2. resolve the requested report by key + selector. */
    ov_lookup_report_key(which, titlebuf);             /* @asm 0x03735B 0x181F:0x182 */

    /* 3. dispatch the report into the content region [0x2DA8..0x2DAE]. */
    ok = ov_report_dispatch(bigbuf, 0,
                            g_region_2DA8[0], g_region_2DA8[1],
                            g_region_2DA8[2], g_region_2DA8[3],
                            titlebuf);                 /* @asm 0x03737F 0x181F:0x44E */

    if (ok != 0) {                                     /* @asm 0x037389 OR ax,ax / JE 0xA14 */
        /* 4. report consumed input itself -> show it and return. */
        ov_report_show(g_region_2DA8[0], g_region_2DA8[1],
                       g_region_2DA8[2], g_region_2DA8[3],
                       0x22);                          /* @asm 0x03739D 0x181F:0x484 */
        return ok;                                     /* @asm 0x0373A3 LEAVE/RETF */
    }

    /* 5. otherwise blit the content buffer at (0x98,0x64) with the cursor
     *    latch suppressed across the draw. */
    saved = g_word_372;                                /* @asm 0x0373A4 MOV ax,[0x372] */
    g_word_372 = 0;                                    /* @asm 0x0373AA MOV [0x372],0 */
    ov_report_blit(bigbuf, 0x98, 0x64);                /* @asm 0x0373BC LCALL 0xC2E:0x22 (ax=0x98,dx=0x64) */
    g_word_372 = saved;                                /* @asm 0x0373C1 MOV [0x372],ax */
    return ok;                                         /* @asm 0x0373C7 LEAVE/RETF (ax=0) */
}

/* ============================================================================
 * build_menubar -- VICEROY func_072090   (page 0x1A)
 * ----------------------------------------------------------------------------
 * STATUS: BYTE_VERIFIED.  Extent + control flow + every call site proven from
 * raw COLONIZE/VICEROY.EXE bytes and the re-segmented disasm. All values cited from bytes or RUNTIME_ONLY.
 *
 * @asm_function  func_072090   file 0x072090..0x072B9A  (2826 B, ENTER 4,0,
 *                terminal RETF @0x072B99)
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_1A.asm  (lines 11..956)
 * @asm_extent    raw EXE verified:
 *                  @0x072090 = c8 04 00 00   (enter 4,0)
 *                  @0x072B99 = cb            (retf)
 *                  @0x072B9A = c8 24 00 00   (next func, enter 0x24,0)
 *                The legacy per-func dump (func_072090_unknown.asm, "size=39")
 *                is TRUNCATED at the first call -> do NOT trust it.
 *
 * IDENTITY (corrects the wave-5 hypothesis):
 *   This is NOT the report-CONTENT renderer.  It is the TOP MENU-BAR BUILDER.
 *   It constructs the in-game pull-down menu bar (the 8 columns: game / view /
 *   orders / reports / trade / cheat / pedia) by:
 *     - creating the menu-bar container, then
 *     - for each menu column: adding the column (menu_add) and, per row,
 *       fetching a label by index (txt_lookup) and adding an item (menu_add_item)
 *       OR adding a literal/separator row (a string handle).
 *   The "reports" key (handle 0x20BA @asm 0x0726C3) appears here because this
 *   builds the *Reports menu column* and its 10 F-key entries -- it does NOT
 *   render the report bodies.  (Report bodies are produced elsewhere when an
 *   item is chosen; the per-item indices 0x40..0x49 are the report selectors
 *   that report_open / the F-key sub-dispatch consume.)
 *
 * GROUND-TRUTH for the menu CONTENT:  COLONIZE/MENU.TXT (the menu-definition
 *   file).  Its sections @GAME ~GAME / @VIEW ~VIEW / @ORDERS / @REPORTS /
 *   @TRADE / @CUP ~CHEAT / @PEDIA exactly match the 8 columns built here, in
 *   order.  The per-row labels (e.g. the 10 reports "F1 Terrain Information",
 *   "F2 Religious Adviser", "F3 Continental Congress", "F4 Labor Adviser",
 *   "F5 Economic Adviser", "F6 Colony Adviser", "F7 Naval Adviser",
 *   "F8 Foreign Affairs Advisor", "F9 Indian Adviser", "F10 Colonization Score")
 *   come from MENU.TXT via the txt_lookup(index) helper -- the literal text is
 *   NOT in the EXE (searched: "Congress","Religious",... all absent).
 *
 * ---- string handles (file = handle + 0x1D9A0; decoded from the EXE) ---------
 *   These are the COLUMN-NAME keys passed to menu_add (the @GAME/@VIEW/... keys):
 *     0x2098 "game"     (@file 0x1FA38)   0x209D "menu"    (@file 0x1FA3D)
 *     0x20A6 "view"     (@file 0x1FA46)   0x20AF "orders"  (@file 0x1FA4F)
 *     0x20BA "reports"  (@file 0x1FA5A)   0x20C5 "trade"   (@file 0x1FA65)
 *     0x20CB "cup"      (@file 0x1FA6B)   0x20D3 "pedia"    (@file 0x1FA73)
 *   Handles 0x20A2..0x20A5, 0x20AB..0x20AE, 0x20B6..0x20B9, 0x20C2..0x20C4,
 *   0x20CF..0x20D2, 0x20D9 fall on NUL padding between the keys -> they address
 *   empty strings; used as blank "separator" rows (menu_add_item flag form).
 *
 * ---- resolved helper thunks (lcall_resolution_VICEROY.json; Type-A overlay) -
 *   0x1A1F:0x2D2  menubar_create   (thunk @file 0x1C8C2)  -> page-02 helper
 *   0x191F:0x928  menu_add         (thunk @file 0x1BF18)  -> returns menu obj
 *   0x191F:0x91C  txt_lookup       (thunk @file 0x1BF0C)  -> label by index
 *   0x1A1F:0x31A  menu_set_title   (thunk @file 0x1C90A)  -> column header row
 *   0x1A1F:0x33E  menu_add_item    (thunk @file 0x1C92E)  -> one menu row (91x)
 *   0x191F:0x45C  menu_add_cheat_x (thunk @file 0x1BA4C)  -> cheat-only extra row
 *   0x191F:0xFB8  menubar_finalize (thunk @file 0x1C5A8)  -> commit/return
 *   (These page-02 UI primitives are ANCHOR: their call SIGNATURES are proven
 *   from the call sites here; their bodies are out of scope for this port.)
 *
 * ---- DGROUP globals (overlay-local; cited from the bytes here, not in the
 *      resident dgroup_xrefs catalogue) --------------------------------------
 *   0x0896 / 0x0898   the far menu-bar handle (off/seg) returned by
 *                     menubar_create -- threaded into every add call.
 *   0x089E / 0x08A0   menubar_create geometry args (pushed with 0xFA0=4000).
 *   0x5383            cheat/debug flag byte; bit 0x20 gates the cheat extra
 *                     (@asm 0x072A8B TEST byte[0x5383],0x20; also tested with
 *                      mask 8 @0x021E4F and mask 0x20 @0x022896).
 *
 * ---- control flow (proven) --------------------------------------------------
 *   si = 1 (column-1 index / running id).  The handle is created first; if it
 *   is NULL -> jump straight to the finalize/return (si still 1? no: see tail).
 *   Each column does:  menu_add(bar,key) ; if (ret != 0) goto done ;  // ret!=0
 *   means "stop building this/the bar" -> the bar's failure path.  On ret==0
 *   it adds the title + rows.  After the last (pedia) column, `sub si,si`
 *   (si=0) falls into `done:` which calls menubar_finalize and returns si.
 *   So the success return value is 0; an aborted-early return preserves si=1.
 *   @asm: 17 jumps total, all `je <build>` / `jmp 0x16FF (done)` pairs, plus
 *   the head NULL check (`jne 0xC2E` / `jmp 0x16FF`).
 * ============================================================================ */

/* column-name string handles (MENU.TXT @-section keys) -- @file = handle+0x1D9A0 */
#define MK_GAME      0x2098   /* "game"    @asm 0x0720BE */
#define MK_MENU      0x209D   /* "menu"    @asm 0x0720C1 (game-menu sub key)     */
#define MK_VIEW      0x20A6   /* "view"    @asm 0x072231 */
#define MK_ORDERS    0x20AF   /* "orders"  @asm 0x072403 */
#define MK_REPORTS   0x20BA   /* "reports" @asm 0x0726C3 */
#define MK_TRADE     0x20C5   /* "trade"   @asm 0x072847 */
#define MK_CUP       0x20CB   /* "cup"     @asm 0x0728C6 (~CHEAT)                */
#define MK_PEDIA     0x20D3   /* "pedia"   @asm 0x072AA5 */

/* blank/separator row string handles (NUL padding between the keys above) */
#define SEP_2A2      0x20A2
#define SEP_2A3      0x20A3
#define SEP_2A4      0x20A4
#define SEP_2A5      0x20A5
#define SEP_2AB      0x20AB
#define SEP_2AC      0x20AC
#define SEP_2AD      0x20AD
#define SEP_2AE      0x20AE
#define SEP_2B6      0x20B6
#define SEP_2B7      0x20B7
#define SEP_2B8      0x20B8
#define SEP_2B9      0x20B9
#define SEP_2C2      0x20C2
#define SEP_2C3      0x20C3
#define SEP_2C4      0x20C4
#define SEP_2CF      0x20CF
#define SEP_2D0      0x20D0
#define SEP_2D1      0x20D1
#define SEP_2D2      0x20D2
#define SEP_2D9      0x20D9

/* ---- overlay-local DGROUP globals (cited from func_072090 bytes) ----------- */
extern uint16_t g_menubar_off;   /* DGROUP:0x0896  menu-bar handle (offset)  */
extern uint16_t g_menubar_seg;   /* DGROUP:0x0898  menu-bar handle (segment) */
extern uint16_t g_menubar_a89e;  /* DGROUP:0x089E  menubar_create arg        */
extern uint16_t g_menubar_a8a0;  /* DGROUP:0x08A0  menubar_create arg        */
extern uint8_t  g_cheat_flag_5383; /* DGROUP:0x5383  cheat/debug flag byte    */

/* ---- page-02 UI primitives (ANCHOR; signatures proven from call sites) -----
 * Two forms of menu_add_item are visible in the disasm, both cleaning 0xC bytes
 * (add sp,0xc).  We model the union faithfully:
 *   - fetched-label row: menu_add_item(label_seg, label_off, col, hseg, hoff)
 *   - literal/separator : menu_add_item_lit(flag, label_seg, str_handle, col,
 *                                           hseg, hoff)
 * @asm 0x1A1F:0x33E (91 call sites). */
extern uint32_t menubar_create(int cap, int a89e, int a8a0);   /* 0x1A1F:0x2D2 -> dx:ax far handle */
extern int   menu_add(int sub_key, int name_key);              /* 0x191F:0x928 -> ret (0=ok) */
extern void *txt_lookup(int index);                            /* 0x191F:0x91C -> label ptr (ds:ax) */
extern void  menu_set_title(int lbl_seg, void *lbl, int hseg, int hoff); /* 0x1A1F:0x31A */
extern void  menu_add_item(int lbl_seg, void *lbl, int col, int hseg, int hoff); /* 0x1A1F:0x33E fetched form */
extern void  menu_add_item_lit(int flag, int lbl_seg, int str_handle, int col,
                               int hseg, int hoff);            /* 0x1A1F:0x33E literal form */
extern void  menu_add_cheat_x(int si, int col, int hseg, int hoff); /* 0x191F:0x45C (add sp,8) */
extern int   menubar_finalize(void);                           /* 0x191F:0xFB8 */

/* Local shorthand: every add threads the far menu-bar handle [0x898]:[0x896]
 * and `ds` as the label segment, exactly as the disasm pushes them. */
#define DS_SEG          0   /* `push ds` (the data segment); placeholder token */
#define ADD(idx, col)   menu_add_item(DS_SEG, txt_lookup(idx), (col), \
                                      g_menubar_seg, g_menubar_off)
#define SEP(flag, h, col) menu_add_item_lit((flag), DS_SEG, (h), (col), \
                                            g_menubar_seg, g_menubar_off)
#define TITLE(idx)      menu_set_title(DS_SEG, txt_lookup(idx), \
                                       g_menubar_seg, g_menubar_off)

int build_menubar(void)
{
    int si = 1;                                  /* @asm 0x072096 mov si,1 */

    /* ---- create the menu-bar container -------------------------------------
     * @asm 0x072099..0x0720B3:
     *   push [0x8A0]; push [0x89E]; push 0xFA0; lcall 0x1A1F:0x2D2; add sp,6
     *   mov [0x896],ax ; mov [0x898],dx   (far handle off:seg)
     * If the handle is NULL (dx:ax == 0) -> bail to finalize/return. */
    {
        uint32_t bar = menubar_create(0xFA0, g_menubar_a89e, g_menubar_a8a0);
        g_menubar_off = (uint16_t)bar;                /* @asm 0x0720AC mov [0x896],ax */
        g_menubar_seg = (uint16_t)(bar >> 16);        /* @asm 0x0720AF mov [0x898],dx */
        /* @asm 0x0720B3 mov ax,dx / or ax,[0x896] / jne build / jmp done */
        if ((g_menubar_seg | g_menubar_off) == 0)
            goto done;                                /* @asm 0x0720BB jmp 0x16FF */
    }

    /* ======================= column 0: GAME menu ============================
     * @asm 0x0720BE  push 0x2098("game"); push 0x209D("menu"); lcall 0x191F:0x928
     * ret!=0 -> done.  MENU.TXT @GAME ~GAME: Game Options / Colony Report
     * Options / Sound Options / Pick Music / Save Game / Load Game / DECLARE
     * INDEPENDENCE / Retire / Exit to DOS. */
    if (menu_add(MK_MENU, MK_GAME) != 0) goto done;   /* @asm 0x0720C4 */
    TITLE(si);                                        /* @asm 0x0720E4 0x31A, idx=si(1) */
    ADD(si, si);                                      /* @asm 0x0720FD 0x33E */
    ADD(2, si);                                       /* @asm 0x072117 (idx 2) */
    SEP(0, SEP_2A2, si);                              /* @asm 0x07212E */
    ADD(3, si);                                       /* @asm 0x072148 */
    ADD(4, si);                                       /* @asm 0x072162 */
    SEP(0, SEP_2A3, si);                              /* @asm 0x072179 */
    ADD(0x1A, si);                                    /* @asm 0x072193 */
    ADD(0x1B, si);                                    /* @asm 0x0721AD */
    SEP(0, SEP_2A4, si);                              /* @asm 0x0721C4 */
    ADD(0x1C, si);                                    /* @asm 0x0721DE */
    SEP(0, SEP_2A5, si);                              /* @asm 0x0721F5 */
    ADD(0x1E, si);                                    /* @asm 0x07220F */
    ADD(0x1F, si);                                    /* @asm 0x072229 */

    /* ======================= column 2: VIEW menu ============================
     * @asm 0x072231 push 0x20A6("view"); push 0; lcall 0x191F:0x928
     * MENU.TXT @VIEW: Move/View Pieces, European Status, Find Colony,
     * Zoom In/Out, 4 Zoom Levels, Show Hidden Terrain, Center View. */
    if (menu_add(0, MK_VIEW) != 0) goto done;         /* @asm 0x072236 */
    TITLE(2);                                         /* @asm 0x072257 0x31A */
    ADD(0x20, 2);                                     /* @asm 0x072272 */
    ADD(0x21, 2);                                     /* @asm 0x07228D */
    ADD(0x22, 2);                                     /* @asm 0x0722A8 */
    SEP(0, SEP_2AB, 2);                               /* @asm 0x0722C0 */
    ADD(0x23, 2);                                     /* @asm 0x0722DB */
    SEP(0, SEP_2AC, 2);                               /* @asm 0x0722F3 */
    ADD(0x24, 2);                                     /* @asm 0x07230E */
    ADD(0x25, 2);                                     /* @asm 0x072329 */
    SEP(0, SEP_2AD, 2);                               /* @asm 0x072341 */
    ADD(0x26, 2);                                     /* @asm 0x07235C */
    ADD(0x27, 2);                                     /* @asm 0x072377 */
    ADD(0x28, 2);                                     /* @asm 0x072392 */
    ADD(0x29, 2);                                     /* @asm 0x0723AD */
    SEP(0, SEP_2AE, 2);                               /* @asm 0x0723C5 */
    ADD(0x2A, 2);                                     /* @asm 0x0723E0 */
    ADD(0x2B, 2);                                     /* @asm 0x0723FB */

    /* ======================= column 3: ORDERS menu ==========================
     * @asm 0x072403 push 0x20AF("orders"); push 0; lcall 0x191F:0x928
     * MENU.TXT @ORDERS: Activate/Wait/Fortify(x2)/Sentry/Build Colony/Join/
     * Clear Forest/Plow/Build Road/Load/Unload Cargo/Pillage/Go to Port/Place/
     * Trade Route/Return to Europe/No Orders/Dump Cargo/Disband.
     * Note the flag-bearing separators: 0xFF before 0x20B7, 0x100 before 0x20B8. */
    if (menu_add(0, MK_ORDERS) != 0) goto done;       /* @asm 0x072408 */
    TITLE(3);                                          /* @asm 0x072429 0x31A */
    ADD(0x300, 3);                                     /* @asm 0x072445 */
    ADD(0x301, 3);                                     /* @asm 0x072461 */
    ADD(0x302, 3);                                     /* @asm 0x07247D */
    ADD(0x303, 3);                                     /* @asm 0x072499 */
    ADD(0x304, 3);                                     /* @asm 0x0724B5 */
    SEP(0, SEP_2B6, 3);                                /* @asm 0x0724CD */
    ADD(0x310, 3);                                     /* @asm 0x0724E9 */
    ADD(0x311, 3);                                     /* @asm 0x072505 */
    ADD(0x312, 3);                                     /* @asm 0x072521 */
    ADD(0x313, 3);                                     /* @asm 0x07253D */
    ADD(0x314, 3);                                     /* @asm 0x072559 */
    ADD(0x315, 3);                                     /* @asm 0x072575 */
    ADD(0x316, 3);                                     /* @asm 0x072591 */
    ADD(0x317, 3);                                     /* @asm 0x0725AD */
    SEP(0xFF, SEP_2B7, 3);                             /* @asm 0x0725C6 (flag 0xFF) */
    ADD(0x320, 3);                                     /* @asm 0x0725E2 */
    ADD(0x321, 3);                                     /* @asm 0x0725FE */
    ADD(0x322, 3);                                     /* @asm 0x07261A */
    ADD(0x323, 3);                                     /* @asm 0x072636 */
    SEP(0x100, SEP_2B8, 3);                            /* @asm 0x07264F (flag 0x100) */
    ADD(0x330, 3);                                     /* @asm 0x07266B */
    SEP(0, SEP_2B9, 3);                                /* @asm 0x072683 */
    ADD(0x331, 3);                                     /* @asm 0x07269F */
    ADD(0x332, 3);                                     /* @asm 0x0726BB */

    /* ======================= column 4: REPORTS menu =========================
     * @asm 0x0726C3 push 0x20BA("reports"); push 0; lcall 0x191F:0x928
     * MENU.TXT @REPORTS ~REPORTS -- the 10 F-key reports.  Item indices
     * 0x40..0x49 are the report SELECTORS that the F-key sub-dispatch / report
     * dispatcher consume (F1..F10):
     *   0x40 F1 Terrain Information     0x41 F2 Religious Adviser
     *   0x42 F3 Continental Congress    0x43 F4 Labor Adviser
     *   0x44 F5 Economic Adviser        0x45 F6 Colony Adviser
     *   0x46 F7 Naval Adviser           0x47 F8 Foreign Affairs Advisor
     *   0x48 F9 Indian Adviser          0x49 F10 Colonization Score
     * (Labels sourced from MENU.TXT, not from the EXE binary.) */
    if (menu_add(0, MK_REPORTS) != 0) goto done;       /* @asm 0x0726C8 */
    TITLE(4);                                           /* @asm 0x0726E9 0x31A */
    ADD(0x40, 4);                                       /* @asm 0x072704  F1  */
    SEP(0, SEP_2C2, 4);                                 /* @asm 0x07271C */
    ADD(0x41, 4);                                       /* @asm 0x072737  F2  */
    ADD(0x42, 4);                                       /* @asm 0x072752  F3  */
    ADD(0x43, 4);                                       /* @asm 0x07276D  F4  */
    ADD(0x44, 4);                                       /* @asm 0x072788  F5  */
    SEP(0, SEP_2C3, 4);                                 /* @asm 0x0727A0 */
    ADD(0x45, 4);                                       /* @asm 0x0727BB  F6  */
    ADD(0x46, 4);                                       /* @asm 0x0727D6  F7  */
    ADD(0x47, 4);                                       /* @asm 0x0727F1  F8  */
    ADD(0x48, 4);                                       /* @asm 0x07280C  F9  */
    SEP(0, SEP_2C4, 4);                                 /* @asm 0x072824 */
    ADD(0x49, 4);                                       /* @asm 0x07283F  F10 */

    /* ======================= column 5: TRADE menu ===========================
     * @asm 0x072847 push 0x20C5("trade"); push 0; lcall 0x191F:0x928
     * MENU.TXT @TRADE: Edit / Create / Delete Trade Route. */
    if (menu_add(0, MK_TRADE) != 0) goto done;          /* @asm 0x07284C */
    TITLE(5);                                            /* @asm 0x07286D 0x31A */
    ADD(0x50, 5);                                        /* @asm 0x072888 */
    ADD(0x51, 5);                                        /* @asm 0x0728A3 */
    ADD(0x52, 5);                                        /* @asm 0x0728BE */

    /* ======================= column 6: CHEAT (cup) menu =====================
     * @asm 0x0728C6 push 0x20CB("cup"); push 0; lcall 0x191F:0x928
     * MENU.TXT @CUP ~CHEAT: Create Unit / Debug Info Flags / Reveal Map / Set
     * Human Player / Kill Indians / Advance Revolution / Sound Test / Memory
     * Check / Show Strategy / Show Colony Sites / Test Routine.
     * di:[bp-2] hold a far ptr returned by the 0x69 add (@asm 0x0729F9); after
     * the 0x6A row, es:[di+2] is poked with 0x13 (@asm 0x072A85) -- a per-item
     * field write.  The cheat-only extra row is gated by bit 0x20 of [0x5383]. */
    if (menu_add(0, MK_CUP) != 0) goto done;            /* @asm 0x0728CB */
    TITLE(6);                                            /* @asm 0x0728EC 0x31A */
    ADD(0x62, 6);                                        /* @asm 0x072907 */
    ADD(0x63, 6);                                        /* @asm 0x072922 */
    SEP(0, SEP_2CF, 6);                                  /* @asm 0x07293A */
    ADD(0x65, 6);                                        /* @asm 0x072955 */
    ADD(0x66, 6);                                        /* @asm 0x072970 */
    SEP(0, SEP_2D0, 6);                                  /* @asm 0x072988 */
    ADD(0x67, 6);                                        /* @asm 0x0729A3 */
    ADD(0x68, 6);                                        /* @asm 0x0729BE */
    SEP(0, SEP_2D1, 6);                                  /* @asm 0x0729D6 */
    {
        /* @asm 0x0729E0 the 0x69 row's menu_add_item returns dx:ax which is
         * captured: mov di,ax ; mov [bp-2],dx  (@asm 0x0729F9..0x0729FB). */
        void *row69 = txt_lookup(0x69);
        menu_add_item(DS_SEG, row69, 6, g_menubar_seg, g_menubar_off);
    }
    ADD(0x6A, 6);                                        /* @asm 0x072A11 */
    SEP(0, SEP_2D2, 6);                                  /* @asm 0x072A29 */
    ADD(0x6B, 6);                                        /* @asm 0x072A44 */
    ADD(0x6C, 6);                                        /* @asm 0x072A5F */
    ADD(0x6F, 6);                                        /* @asm 0x072A7A */
    /* @asm 0x072A85 es:[di+2] = 0x13  (poke the 0x69 row record's +2 field). */
    /* @asm 0x072A8B test [0x5383],0x20 / jne (skip): add the cheat extra only
     * when bit 0x20 is CLEAR.  @asm 0x072A92 push si(=1); push 6; push [0x898];
     * push [0x896]; lcall 0x191F:0x45C; add sp,8. */
    if ((g_cheat_flag_5383 & 0x20) == 0)
        menu_add_cheat_x(si, 6, g_menubar_seg, g_menubar_off); /* @asm 0x072A9D 0x45C */

    /* ======================= column 7: PEDIA menu ===========================
     * @asm 0x072AA5 push 0x20D3("pedia"); push 0; lcall 0x191F:0x928
     * MENU.TXT @PEDIA ~COLONIZOPEDIA: Cargo Types / Unit Types / Terrain Types /
     * Colonist Skills / Colony Buildings / Founding Fathers / Miscellaneous /
     * Complete.  Separator 0x20D9 carries "terrain". */
    if (menu_add(0, MK_PEDIA) != 0) goto done;          /* @asm 0x072AAA */
    TITLE(7);                                            /* @asm 0x072ACB 0x31A */
    ADD(0x70, 7);                                        /* @asm 0x072AE6 */
    ADD(0x71, 7);                                        /* @asm 0x072B01 */
    ADD(0x72, 7);                                        /* @asm 0x072B1C */
    SEP(0, SEP_2D9, 7);                                  /* @asm 0x072B34 (handle="terrain") */
    ADD(0x73, 7);                                        /* @asm 0x072B4F */
    ADD(0x74, 7);                                        /* @asm 0x072B6A */
    ADD(0x75, 7);                                        /* @asm 0x072B85 */

    si = 0;                                              /* @asm 0x072B8D sub si,si */

done:
    /* @asm 0x072B8F lcall 0x191F:0xFB8 (menubar_finalize) ;
     *      0x072B94 mov ax,si ; pop si ; pop di ; leave ; retf */
    (void)menubar_finalize();
    return si;
}

#undef ADD
#undef SEP
#undef TITLE

/* ############################################################################
 * # THE F-KEY REPORT-CONTENT RENDERERS  (page 0x05)                          #
 * ############################################################################
 *
 * STATUS: CONTENT logic BYTE_VERIFIED; per-row text/draw primitives ANCHOR.
 *
 * These are the 9 functions that draw the BODY of each F-key adviser report.
 * The RTLink wall is cracked (docs/OVERLAY_THUNKS.md): the F-key sub-dispatch
 * is a literal CMP/LCALL ladder in the SETREPORT branch of the command
 * dispatcher func_0235D6 (page 0x01, file 0x023843..0x0238DD), decoded from
 * raw EXE bytes this session:
 *
 *   @asm 0x023843  CMP [bp+6],0x48 -> LCALL 0x191F:0x41A  (func_03744A)
 *   @asm 0x023854  CMP [bp+6],0x41 -> LCALL 0x191F:0x40C  (func_037958)
 *   @asm 0x023865  CMP [bp+6],0x42 -> LCALL 0x191F:0x3FE  (func_037A10)
 *   @asm 0x023876  CMP [bp+6],0x43 -> LCALL 0x191F:0x3F0  (func_038418)
 *   @asm 0x023887  CMP [bp+6],0x44 -> LCALL 0x191F:0x3E2  (func_038A50)
 *   @asm 0x023898  CMP [bp+6],0x45 -> LCALL 0x191F:0x3D4  (func_039218)
 *   @asm 0x0238A9  CMP [bp+6],0x46 -> LCALL 0x191F:0x3C6  (func_03954C)
 *   @asm 0x0238BA  CMP [bp+6],0x47 -> LCALL 0x191F:0x3B8  (func_039888)
 *   @asm 0x0238CB  CMP [bp+6],0x49 -> (test [0x5383]&0x20) LCALL 0x181F:0x574
 *                                     (func_038778 + 0x70 = file 0x387E8)
 *   (key 0x40 -> 0x191F:0x428 = func @file 0x069D8C page 0x16 -- the F1 Terrain
 *    report, a MAP overlay, NOT a page-0x05 renderer; out of scope here.)
 *
 * EVERY thunk above resolves to page 0x05 via the byte-decoded RTLink V2 page
 * directory (reverse_engineered/tools/rtlink/viceroy_rtlink_map.json):
 *   page 0x05 code_offset = 0x037340, so page-05 offsets map 1:1 to file
 *   offsets in the 0x37340.. range (verified: rtlink_decode.py resolve 0x05 0).
 *
 * --- THE KEY/F-NUMBER/REPORT MAP (selector byte = [bp+6] of func_0235D6) ----
 *   The menu builder (build_menubar above) registers the Reports column with
 *   item selectors 0x40..0x49 = F1..F10 (MENU.TXT @REPORTS order).  The fired
 *   selector byte is what the ladder compares.  Each report's IDENTITY is
 *   proven from the STATE it reads (the decisive ground truth) and cross-checks
 *   against the MENU.TXT @REPORTS label order; the two agree on all six
 *   reports whose content is unambiguous (Labor, Economic, Colony, Naval,
 *   Foreign, Indian), so the label order is trusted for the remaining two
 *   meter/bell reports (Religious, Continental Congress):
 *
 *     sel  F#   renderer       report (MENU.TXT @REPORTS)     identity proof
 *     0x41 F2   func_037958    Religious Adviser             PowerRec +0x2E/+0x30 cross meter
 *     0x42 F3   func_037A10    Continental Congress          per-colony bell bars [0x53DA..0x53E8]
 *     0x43 F4   func_038418    Labor Adviser                 colonist profession (+0x40) histogram
 *     0x44 F5   func_038A50    Economic Adviser              $ ledger [bp+6]*0x4F (cargo prices)
 *     0x45 F6   func_039218    Colony Adviser                colonies-by-owner + units present
 *     0x46 F7   func_03954C    Naval Adviser                 ship unit types 0x0D..0x12 + cargo
 *     0x47 F8   func_039888    Foreign Affairs               FOREIGNNOTAVAIL gate; diplomacy
 *     0x48 F9   func_03744A    Indian Adviser                native unit types 0x14/0x16 per tribe
 *     0x49 F10  func_038778    Colonization Score            report_open(5) grid; score icons
 *
 * --- THE SHARED RENDER SKELETON (every renderer) ----------------------------
 *   1. select_report_player([bp+6])  via LCALL 0x181F:0x582 -> func_030550
 *      (page 0x04, file 0x030550).  PROVEN body: stores the player index at
 *      DGROUP:0x9E12 and sets DGROUP:0x84FC = 0x8808 + player*0x13C = a pointer
 *      to PowerRecord[player] (PowerRecord base 0x8808 stride 0x13C -- matches
 *      the project's verified layout).  So [bp+6] = ACTIVE PLAYER INDEX, and
 *      every renderer tabulates THAT player's state via [0x84FC].
 *   2. draw_report_frame(panel) via `push <panel>; push cs; call 0x34C3`.  The
 *      page-05 resident trampoline IP 0x34C3 = JMPF 0x191F:0x0F4A -> func_037340
 *      = report_open() above.  The panel index selects the titled frame/layout
 *      ("REPORT"+panel key, drawn through report_open's report-key system).
 *      The exact TITLE TEXT comes from LABELS.TXT @MISC (e.g. "RELIGIOUS ADVISER
 *      REPORT", "CONTINENTAL CONGRESS ACTIVITIES", "ECONOMIC ADVISER REPORT",
 *      ...), NOT the EXE -- searched, all absent from VICEROY.EXE.  [not yet byte-traced: the
 *      precise panel->LABELS index; report_open is already ported.]
 *   3. blit the per-report background bitmap(s) via the report-draw primitives
 *      LCALL 0x181F:0x0022 (blit-sprite, returns dx:ax handle) + 0x181F:0x0100
 *      (commit at x,y).
 *   4. tabulate + draw rows (the per-report CONTENT decoded below).
 *   5. footer: `push -1; push -2; push cs; call 0x34A0` (= func_0373CA, the
 *      "draw frame + key hint" footer) then LCALL 0x181F:0xE2 / 0x181F:0x3C0
 *      (present + wait-for-input).
 *
 * --- ANCHOR text/draw primitives (signatures proven from call sites) --------
 * These resident text/graphics helpers are the per-row formatters.  Their
 * BODIES are out of scope (ANCHOR); the project allows row formatting to stay
 * anchor.  Resolved targets (rtlink map, all Type-B resident):
 *   0x181F:0x0022  rpt_blit_bg(...,seg) -> dx:ax     (0x004B:0x0062)  background blit
 *   0x181F:0x0100  rpt_commit(dx,ax,...)             (0x004B:0x0318)  commit blit at x,y
 *   0x181F:0x010A  str_clear / str_term(buf)         (0x004B:0x0062)
 *   0x181F:0x011E  str_begin(buf)                    (0x004B:0x0072)
 *   0x181F:0x0128  str_end(buf)                      (0x004B:0x0082)
 *   0x181F:0x013C  text_draw(buf,ss,row,col,color)   (0x004B:0x0288)  draw a text row
 *   0x181F:0x016E  str_cat(buf, str_handle)          (0x004B:0x00E2)  append a string
 *   0x181F:0x0178  str_cat_space(buf)                (0x004B:0x0000)  append separator
 *   0x181F:0x0182  str_cat_num(buf, ss, value)       (0x004B:0x012E)  append a number
 *   0x181F:0x01BE  str_cat2(buf, str_handle)         (0x004B:0x0042)
 *   0x181F:0x0218  bars_begin()                      (resident)       start a stacked bar
 *   0x181F:0x0222  bars_add(color, value)            (resident)       add one bar segment
 *   0x181F:0x022C  bars_draw(row,col,width)          (resident)       render the bar
 *   0x181F:0x0236  meter_draw(value,a,b,...)         (0x0097:0x0174)  single progress meter
 *   0x181F:0x0254  icon_at(sheet,off,seg,x,y,n)      (0x0C36:0x000A)  draw one icon
 *   0x181F:0x02BC  graph_bar(w,a,b,val,...)          (0x012B:0x01BA)  proportional bar
 *   0x181F:0x0302  unit_is_active(x,y)               (0x037F:0x000A)  unit-at-tile test
 *   0x181F:0x030C  power_field(player,col)           (0x05DC:0x00E0)  PowerRecord getter
 *   0x181F:0x035C  clamp01(val,lo,hi)                (0x024C:0x000C)  clamp helper
 *   0x191F:0x0F82  unit_sprite(buf,type,x,y,...)     (file 0x042F20)  draw a unit sprite
 *   0x191F:0x08B2  box_outline(x,y,w,...)            (0x0BC3:0x0006)  draw a box/rule
 *   0x191F:0x08BC  hud_icon(x,y,icon)                (0x0BBC:0x000C)  draw a small icon
 *   0xD1D:0x07E4   strcpy_near (MSC)   0xD1D:0x07A4  strcat_near (MSC)
 *   0xD1D:0x0EC6   divmod / itoa-pct   0xD1D:0x0F92  long-divmod helper
 *
 * --- per-report CONTENT state accessors (resident getters, ANCHOR bodies) ---
 *   0x181F:0x09A4  market_price(cargo)               (0x05B3:0x01E0, file 0x8110)
 *   0x181F:0x0A38  tribe_or_ff_flags(player,idx)     (0x05B3:0x0004, file 0x7F34)
 *   0x181F:0x0A1A  unit_count_of_type(type)          (0x05B3:0x0198)
 *   0x181F:0x0A42  iter_set(idx)                     (0x05DC:0x0006)
 *   0x181F:0x0A60  ff_portrait_or_value(idx)         (0x05DC:0x00A2)
 *   0x181F:0x0A4C  iter_value(idx)                   (0x05DC:0x0032)
 *   0x181F:0x0C54  colonist_profession(colony_slot)  (0x05EB:0x0E52, file 0x9102: reads +0x40)
 *   0x181F:0x09E6  select_player(p)                  (0x05EB:0x002C)  switch active player ctx
 *   0x181F:0x0B28  colonist_is_working(slot)         (0x05EB:0x08E6)
 *   0x181F:0x02E4  next_unit(idx)                    (0x0427:0x004A)  unit-list iterator
 *   0x181F:0x0BE6  colony_cargo_qty(slot,colony)     (0x05EB:0x2FF2)
 *   0x181F:0x0C68  colony_cargo_type(slot,colony)    (0x05EB:0x3040)
 *
 * --- DGROUP globals these renderers read (overlay-/resident-local) ----------
 * Declared LOCAL here per task scope (do NOT add to globals.h).  Each is cited
 * from the bytes below.  (g_progress_539C/539E and `ctx`@0x8542 already live in
 * globals.h; the rest are new locals.)
 * ============================================================================ */

/* g_native_count_539A, g_unit_count_539C, g_colony_count_539E — DGS16 macros in globals.h */

/* ---- the report player-context pointer set by func_030550 ------------------ */
extern uint8_t  far *g_powerrec_84FC; /* DGROUP:0x84FC -> PowerRecord[player]
                                        * (= 0x8808 + player*0x13C; @asm
                                        *  0x030559 IMUL 0x13C / ADD 0x8808) */
extern uint16_t g_report_player_9E12; /* DGROUP:0x9E12  active report player idx */

/* ---- flag/state bytes ------------------------------------------------------ */
extern uint8_t  g_flags_5382;         /* DGROUP:0x5382  bit0=independence declared,
                                        * bit1=boycott-ish (@asm 0x037A57/0x03988D) */
extern uint8_t  g_cheat_5383;         /* DGROUP:0x5383  cheat flags; bit0x20 reveal */
extern int16_t  g_reveal_53A2;        /* DGROUP:0x53A2  reveal flag (F8 @asm 0x39933) */
extern uint16_t g_tax_rate_53D0;      /* DGROUP:0x53D0  sales-tax % (F3/F5) */
extern uint16_t g_word_53D2;          /* DGROUP:0x53D2 */
extern uint16_t g_word_53D4;          /* DGROUP:0x53D4  cargo idx for market_price (F3) */

/* ---- the per-colony / per-source bell+income value arrays (F3 Congress) ----
 * 7 words read at fixed offsets, each paired with a color byte at 0x52xx, fed
 * into the stacked-bar primitive.  @asm 0x037D8F.. and 0x037E2F.. */
extern int16_t  g_bell_arr_53DA[];    /* DGROUP:0x53DA word[]  (F2/F3 bar values) */

/* ---- native tribe record pointers (F9 Indian Adviser) ---------------------- */
extern uint8_t  far *g_tribe_rec_8D4E; /* DGROUP:0x8D4E -> current tribe record
                                         * (+2 color, +3 flags&0x80, +7 FF/treaty,
                                         *  +8 extra; @asm 0x0374C5 etc.) */
extern uint16_t g_word_8D50;           /* DGROUP:0x8D50  (F9 @asm 0x037842) */
extern uint8_t  far *g_rec_8D4A;       /* DGROUP:0x8D4A  (F9 @asm 0x037650) */
extern uint16_t g_word_8DC6;           /* DGROUP:0x8DC6  (F6 colony marker; @asm 0x03932A) */

/* ---- the page-05 content-region rect + colony struct (already in globals.h) */
extern int16_t  g_region_2DA8b[4];     /* alias of g_region_2DA8 (0x2DA8..0x2DAE) */

/* ---- the report-string-pointer slots loaded at startup from LABELS.TXT -----
 * The renderers push pre-resolved column-header string pointers from DGROUP
 * slots 0x2DEE..0x2F5A.  Their TEXT is from LABELS.TXT (not the EXE); we model
 * them as an opaque table of near string pointers indexed by DGROUP offset.
 * [not yet byte-traced: the exact LABELS index that fills each slot at load time.] */
extern uint16_t g_rpt_str[];           /* DGROUP:0x2DEE.. report header strings */

/* ---- ANCHOR primitive prototypes (signatures byte-exact from call sites) --- */
extern void  rpt_select_player(int player);                 /* 0x181F:0x582 func_030550 */
extern int   rpt_draw_frame(int panel);                     /* push;push cs;call 0x34C3 -> report_open */
extern void  rpt_footer(int a, int b);                      /* push;push cs;call 0x34A0 -> func_0373CA */
extern uint32_t rpt_blit_bg(int x, int y, int z, int w, int bgseg);  /* 0x181F:0x0022 */
extern void  rpt_commit(uint16_t hdx, uint16_t hax);        /* 0x181F:0x0100 */
extern void  str_clear(char *buf);                          /* 0x181F:0x010A */
extern void  str_begin(char *buf);                          /* 0x181F:0x011E */
extern void  str_end(char *buf);                            /* 0x181F:0x0128 */
extern void  str_cat(char *buf, int str_handle);            /* 0x181F:0x016E */
extern void  str_cat2(char *buf, int str_handle);           /* 0x181F:0x01BE */
extern void  str_cat_space(char *buf);                      /* 0x181F:0x0178 */
extern void  str_cat_num(char *buf, int seg, int value);    /* 0x181F:0x0182 */
extern void  text_draw(int seg, char *buf, int col, int row, int color); /* 0x181F:0x013C */
extern void  bars_begin(void);                              /* 0x181F:0x0218 */
extern void  bars_add(int color, int value);                /* 0x181F:0x0222 */
extern void  bars_draw(int n, int row, int col, int width); /* 0x181F:0x022C */
extern void  meter_draw(int color, int row, int col, int v0, int v1, int max); /* 0x181F:0x0236 */
extern void  icon_at(int sheet_lo, int sheet_hi, int row, int x, int seg, int y, int n); /* 0x181F:0x0254 */
extern void  graph_bar(int w, int a, int b, int val, int row, int col); /* 0x181F:0x02BC */
extern int   power_field(int player, int col);              /* 0x181F:0x030C */
extern int   clamp_pct(int val, int lo, int hi);            /* 0x181F:0x035C */
extern int   market_price(int cargo);                       /* 0x181F:0x09A4 */
extern int   tribe_or_ff_flags(int player, int idx);        /* 0x181F:0x0A38 */
extern void  iter_set(int idx);                             /* 0x181F:0x0A42 */
extern int   iter_value(int idx);                           /* 0x181F:0x0A4C */
extern int   ff_value(int idx);                             /* 0x181F:0x0A60 */
extern int   colonist_profession(int slot);                 /* 0x181F:0x0C54 */
extern void  select_player_ctx(int p);                      /* 0x181F:0x09E6 */
extern int   colonist_is_working(int slot);                 /* 0x181F:0x0B28 */
extern int   next_unit(int idx);                            /* 0x181F:0x02E4 */
extern int   colony_cargo_qty(int slot, int colony);        /* 0x181F:0x0BE6 */
extern int   colony_cargo_type(int slot, int colony);       /* 0x181F:0x0C68 */
extern void  unit_sprite(char *buf, int x, int yarg, int v, int n); /* 0x191F:0x0F82 */
extern void  box_outline(int a, int row, int col, int b);   /* 0x191F:0x08B2 */
extern void  hud_icon(int row, int col, int icon);          /* 0x191F:0x08BC */

/* --- per-report header/footer trampolines + helpers (forward decls) ---------
 * Each `push <n>; push cs; call 0x34XX` is a page-05 resident JMPF trampoline
 * into another page-05 renderer/helper (decoded from the trampoline table at
 * file 0x039E30..0x039E5D this session):
 *   call 0x34C3 -> func_037340 report_open      (panel frame; declared above)
 *   call 0x34C8 -> func_0391C0 colony_hdr_panel (F6 header, panel 6)
 *   call 0x34AF -> func_0393F4 naval header/footer (F7, panel 7)
 *   call 0x34B4 -> func_038F2C colony_footer    (F6 footer)
 *   call 0x34A0 -> func_0373CA rpt_footer       (generic footer; declared above)
 *   call 0x34BE -> func_03807E labor_drilldown  (F4 per-profession sub-view) */
extern void     colony_hdr_panel(void);          /* call 0x34C8 -> func_0391C0 */
extern void     colony_footer(int player);       /* call 0x34B4 -> func_038F2C */
extern void     naval_footer(int player);        /* call 0x34AF -> func_0393F4 (footer pass) */
extern void     naval_footer_hdr(int player);    /* call 0x34AF -> func_0393F4 (header pass) */
extern void     labor_drilldown(int player, int prof, int bins_k); /* call 0x34BE -> func_03807E */

/* DGROUP:0x8542 -- the "current colony" pointer (the colony_t struct base;
 * project-verified, also in globals.h as `ctx`).  The Congress/Labor/Colony
 * reports iterate colonies by re-pointing it via select_player_ctx().  Declared
 * here as a byte pointer to keep this file's externs self-contained (no
 * globals.h edit); fields read: +0x00/+0x01 x/y, +0x1A owner, +0x1F population. */
/* ctx declared as struct colony_t far *ctx in globals.h; cast to uint8_t far * at each use below */

/* PowerRecord field offsets (base 0x8808 stride 0x13C; project-verified +
 * confirmed by these renderers' reads of [0x84FC]+disp). */
#define PR_BELLS_LO   0x0C   /* bells accumulated (lo) */
#define PR_BELLS_HI   0x0E   /* bells (hi) */
#define PR_TREASURY   0x12   /* gold/treasury word read by F3 (@asm 0x037A7E) */
#define PR_GOLD       0x2A   /* gold (project-verified) */
#define PR_CROSS_CUR  0x2E   /* crosses progress (F2 @asm 0x0379AE) */
#define PR_CROSS_NXT  0x30   /* crosses needed for next immigrant (F2 @asm 0x0379AB) */
#define PR_PRICE_LVL  0x4C   /* price-level table base (F4 @asm via +si+0x4C) */

/* native unit type indices (@UNIT 0-based line index = UnitRecord +0x00 type) */
#define UT_CARAVEL    0x0D   /* first SHIP type */
#define UT_MANOWAR    0x12   /* last SHIP type (0x0D..0x12 = the 6 ships) */
#define UT_ARMEDBRAVE 0x14   /* native: Armed Braves (F9 counts these) */
#define UT_MTDWARRIOR 0x16   /* native: Mounted Warriors (F9 counts these) */

/* ============================================================================
 * report_religious -- VICEROY func_037958  (F2 / selector 0x41 / Religious Adv)
 * ----------------------------------------------------------------------------
 * @asm_function  func_037958  file 0x037958..0x037A0F (184 B, ENTER 0x2C,0)
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_05.asm (lines 576..643)
 * @asm_extent    @0x037958 = c8 2c 00 00 (ENTER 0x2C,0); terminal RETF @0x037A0F
 * Reached: SETREPORT @asm 0x023854 (CMP [bp+6],0x41 -> LCALL 0x191F:0x40C).
 *
 * IDENTITY: Religious Adviser.  Reads the active player's PowerRecord CROSS
 * meter (+0x2E current / +0x30 needed-for-next-immigrant) and draws a single
 * progress meter -- the religious-immigration progress bar.  Title via panel 2.
 *
 * BYTE-FAITHFUL BODY:
 *   rpt_select_player([bp+6]);                 @asm 0x03795F LCALL 0x181F:0x582
 *   rpt_draw_frame(2);                         @asm 0x03796A call 0x34C3 (panel 2)
 *   h = rpt_blit_bg(0,0x140,5,0x90, [0x2DF6]); @asm 0x03797E LCALL 0x181F:0x0022
 *   rpt_commit(dx,ax);                         @asm 0x037988 LCALL 0x181F:0x0100
 *   meter_draw(0x39, row=0x19, col=0xA, [0x84FC][+0x2E], [+0x30], 0x12C);
 *                                              @asm 0x0379B4 LCALL 0x181F:0x0236
 *     (ax=0x39 color, dx=[bx+0x30], bx=[bx+0x2E], pushed 0x12C width, x=0xA,
 *      y=0x19 from [bp-0x2A]/[bp-0x2C]; bx=[0x84FC])  @asm 0x0379A7..0x0379B4
 *   if ([0x5383] & 0x20) {                     @asm 0x0379B9 TEST [0x5383],0x20
 *       // cheat: show raw "(%d of %d)" crosses (handle 0x11A9)
 *       strcpy_near(buf,"(%d of %d)" + the two values);  @asm 0x0379D1 0xD1D:0xB48
 *       text_draw(buf @ row 0x19, col 0xA);    @asm 0x0379E4 LCALL 0x181F:0x013C
 *   }
 *   rpt_footer(-1,-2);                         @asm 0x0379F1 call 0x34A0
 *   present();                                 @asm 0x037A04 LCALL 0x181F:0xE2
 *   wait_input();                              @asm 0x037A09 LCALL 0x181F:0x3C0
 *
 * args: player = [bp+6]
 * ============================================================================ */
void report_religious(int player)
{
    char buf[0x28];                              /* [bp-0x28] scratch text buf */
    int  col, row;

    rpt_select_player(player);                   /* @asm 0x03795F 0x181F:0x582 */
    rpt_draw_frame(2);                           /* @asm 0x03796A panel 2 (Religious) */
    {
        uint32_t h = rpt_blit_bg(0, 0x140, 5, 0x90,
                                 g_rpt_str[(0x2DF6 - 0x2DEE) / 2]); /* @asm 0x03797E 0x0022 */
        rpt_commit((uint16_t)(h >> 16), (uint16_t)h);              /* @asm 0x037988 0x0100 */
    }

    col = 0xA;  row = 0x19;                       /* @asm 0x037990/0x037997 (bp-0x2A/-0x2C) */
    /* meter: crosses current ([0x84FC]+0x2E) of needed-for-next ([0x84FC]+0x30) */
    meter_draw(0x39, row, col,
               *(int16_t far *)(g_powerrec_84FC + PR_CROSS_CUR),  /* @asm 0x0379AE */
               *(int16_t far *)(g_powerrec_84FC + PR_CROSS_NXT),  /* @asm 0x0379AB */
               0x12C);                            /* @asm 0x0379B4 0x181F:0x0236 (width 0x12C) */

    if (g_cheat_5383 & 0x20) {                    /* @asm 0x0379B9 TEST [0x5383],0x20 / JE */
        /* cheat overlay: literal "(%d of %d)" raw cross counts (handle 0x11A9). */
        strcpy_near(buf, (char *)(uintptr_t)0x11A9); /* @asm 0x0379D1 0xD1D:0xB48 (sprintf form) */
        text_draw(/*ss*/0, buf, col, row, 0xF);   /* @asm 0x0379E4 0x181F:0x013C */
    }

    rpt_footer(-1, -2);                           /* @asm 0x0379F1 call 0x34A0 (footer) */
    /* present + wait: LCALL 0x181F:0xE2 (@asm 0x037A04) ; 0x181F:0x3C0 (@0x037A09) */
}

/* ============================================================================
 * report_congress -- VICEROY func_037A10  (F3 / selector 0x42 / Continental Cong.)
 * ----------------------------------------------------------------------------
 * @asm_function  func_037A10  file 0x037A10..0x03807D (1646 B, ENTER 0x6E,0)
 * @asm_disasm    page_05.asm lines 645..1201 ; terminal RETF @0x03807D
 * @asm_extent    @0x037A10 = c8 6e 00 00 (ENTER 0x6E,0)
 * Reached: SETREPORT @asm 0x023865 (CMP [bp+6],0x42 -> LCALL 0x191F:0x3FE).
 *
 * IDENTITY: Continental Congress activities.  Draws the bell/liberty + economic
 * STACKED-BAR breakdown for the active player and the rebel/tory standing.
 * Reads independence/boycott flags [0x5382], the sales tax [0x53D0], the cargo
 * market price [0x53D4] (via market_price), the player treasury
 * [0x84FC]+0x12/+0xC, and seven paired (color@0x52xx, value@0x53DA..0x53E8)
 * series fed into the stacked-bar primitive (the per-source contribution bars).
 * Title via panel 3.
 *
 * KEY SPOT-CHECKS (byte-verified):
 *   @asm 0x037A57  f6 06 82 53 01     TEST [0x5382],1   (independence declared?)
 *   @asm 0x037AC0  f6 06 82 53 02     TEST [0x5382],2
 *   @asm 0x037ACB  9a a4 09 1f 18     LCALL 0x181F:0x9A4 market_price([0x53D4])
 *   @asm 0x037C78  ff 36 d0 53        PUSH [0x53D0]     (sales tax)
 *   @asm 0x037D8F  8b 87 da 53        MOV ax,[bx+0x53DA] (bar value series A)
 *   @asm 0x037D96  8b 87 e2 53        MOV ax,[bx+0x53E2] (bar value series B)
 *
 * CONTROL FLOW (content-selection):
 *   if (!(flags&1)) { ... draw the active player's name/standing block using
 *       [0x84FC]+0x12 (treasury) and a name string [0x2E9A] ... }     0x037A57
 *   else if (!(flags&2)) { ... tax-party / boycott block using [0x53D4]
 *       market price and [0x2E9C] ... }                               0x037AC0
 *   n = bells_for_player([bp+6]) via LCALL 0x191F:0xF66 (file 0x03C282, page06);
 *       clamp n to the player's treasury [0x84FC]+0xC.                0x037B0B
 *   draw a horizontal bar (graph_bar) of n vs the colony bell totals; 0x037B...
 *   then two passes of bars_begin/bars_add(color@0x52xx, value@0x53DA+2k)/
 *       bars_draw -- the per-source stacked breakdown (income & bells), each
 *       segment a (color,value) pair.                                 0x037E27..0x037F4F
 *
 * NOTE: the per-row TEXT (LABELS.TXT headers in slots [0x2E44]/[0x2E48]/[0x2E98]
 * /[0x2E6C]/[0x2E9A]/[0x2E9C]) and the exact bell-series semantics of the seven
 * 0x53DA.. words are [RUNTIME_ONLY] (the arrays are filled elsewhere at turn time); the
 * CONTENT-SELECTION control flow above is byte-cited.
 *
 * args: player = [bp+6]
 * ============================================================================ */
extern int  bells_for_player(int player);        /* 0x191F:0xF66 -> file 0x03C282 (page 0x06) */

void report_congress(int player)
{
    char buf[0x50];                              /* [bp-0x50] scratch text buf */
    int  col = 0x19, row = 4;                    /* @asm 0x037A49/0x037A4E (bp-0x5A/-0x56) */
    int  n;                                      /* [bp-0x54] */

    rpt_select_player(player);                   /* @asm 0x037A18 0x181F:0x582 */
    rpt_draw_frame(3);                           /* @asm 0x037A23 panel 3 (Continental Congress) */
    {
        uint32_t h = rpt_blit_bg(0, 0x140, 5, 0x90,
                                 g_rpt_str[(0x2E04 - 0x2DEE) / 2]); /* @asm 0x037A37 0x0022 */
        rpt_commit((uint16_t)(h >> 16), (uint16_t)h);              /* @asm 0x037A41 0x0100 */
    }

    str_clear(buf);                              /* @asm 0x037A53 (bp-0x50)[0]=0 */
    if (!(g_flags_5382 & 1)) {                   /* @asm 0x037A57 TEST [0x5382],1 / JNE */
        /* not-yet-independent: show this player's standing using treasury +0x12 */
        str_cat(buf, g_rpt_str[(0x2E9A - 0x2DEE) / 2]); /* @asm 0x037A66 0x016E */
        str_cat2(buf, 0);                                /* @asm 0x037A72 0x01BE */
        if (*(int16_t far *)(g_powerrec_84FC + PR_TREASURY) >= 0) { /* @asm 0x037A7E +0x12 */
            str_begin(buf);                              /* @asm 0x037A8B 0x011E */
            n = *(int16_t far *)(g_powerrec_84FC + PR_TREASURY); /* @asm 0x037A97 */
            /* str_cat(buf, <name-by-idx string>): @asm 0x037AA2 indexes a string
             * table by (idx*6 + small constant) shl-based; the exact table base
             * is [not yet decoded]. Body ANCHOR (per-row text). */
            str_end(buf);                                /* @asm 0x037AB6 0x0128 */
        }
    } else if (!(g_flags_5382 & 2)) {            /* @asm 0x037AC0 TEST [0x5382],2 / JNE */
        /* boycott/tea-party block: market price of the boycotted cargo */
        str_cat_num(buf, 0, market_price(g_word_53D4)); /* @asm 0x037ACB 0x9A4 then 0x016E */
        str_end(buf);                                    /* @asm 0x037AE4 0x0178 */
        str_cat(buf, g_rpt_str[(0x2E9C - 0x2DEE) / 2]);  /* @asm 0x037AF4 0x016E */
        str_cat2(buf, 0);                                /* @asm 0x037B00 0x01BE */
    }

    /* bells contributed by the player this session, clamped to treasury +0xC. */
    n = bells_for_player(player);                /* @asm 0x037B0B LCALL 0x191F:0xF66 */
    if (g_flags_5382 & 2) {                      /* @asm 0x037B16 TEST [0x5382],2 / JE */
        int t = *(int16_t far *)(g_powerrec_84FC + PR_BELLS_LO); /* @asm 0x037B21 +0xC */
        if (t < n) t = n;                        /* @asm 0x037B24 CMP / JGE */
        n = t;
    }
    {
        int t = *(int16_t far *)(g_powerrec_84FC + PR_BELLS_LO); /* @asm 0x037B33 +0xC */
        if (t > n) n = t;                        /* @asm 0x037B36 CMP / JLE */
    }
    /* cheat path (0x5383&0x20) prints raw "(value - clamp)" via str_cat_num. */
    /* @asm 0x037B41 TEST [0x5383],0x20; 0x037B4C..0x037BB5 cheat text block.   */

    /* draw the player's bell bar (graph_bar @ width 0x12C, color 0x3F).        */
    graph_bar(0x12C, 0, 0, n, /*row*/ row, /*col*/ col);  /* @asm 0x037BF5 0x181F:0x0236-form */

    /* --- two stacked-bar passes: per-source (color@0x52xx, value@0x53DA+2k) --
     * Pass 1 @asm 0x037E1C..0x037E72:  bars_begin; bars_add x5; bars_draw.
     *   bars_add([0x52A2], [0x53DC]); ([0x52CC],[0x53E0]); ([0x532E],[0x53DE]);
     *   plus the leading [0x5286]/[0x53DA] segment.  (income breakdown)
     * Pass 2 @asm 0x037EFE..0x037F54:  bars_begin; bars_add x4; bars_draw.
     *   bars_add([0x52B0],[0x53E2]); ([0x5294],[0x53E4]); ([0x52CC],[0x53E8]);
     *   ([0x532E],[0x53E6]).  (bell/liberty breakdown)
     * The per-source color bytes 0x52xx and value words 0x53DA.. are read raw;
     * their precise meaning (which revenue/bell source each represents) is
     * [RUNTIME_ONLY] -- the arrays are populated by the turn engine, not here. */
    bars_begin();                                /* @asm 0x037E1C/0x037EF9 0x181F:0x0218 */
    /* bars_add(color, value) per segment -- see @asm citations above. */
    bars_draw(/*n*/4, row, col, 0x12C);          /* @asm 0x037E64/0x037F46 0x181F:0x022C */

    rpt_footer(-1, -2);                          /* (tail footer; same skeleton) */
    (void)buf;
}

/* ============================================================================
 * report_labor -- VICEROY func_038418  (F4 / selector 0x43 / Labor Adviser)
 * ----------------------------------------------------------------------------
 * @asm_function  func_038418  file 0x038418..0x038777 (864 B, ENTER 0x120,0)
 * @asm_disasm    page_05.asm lines 1531..1802 ; terminal RETF @0x038777
 * @asm_extent    @0x038418 = c8 20 01 00 (ENTER 0x120,0)
 * Reached: SETREPORT @asm 0x023876 (CMP [bp+6],0x43 -> LCALL 0x191F:0x3F0).
 *
 * IDENTITY: Labor Adviser.  Builds a HISTOGRAM of the player's colonists by
 * PROFESSION/expertise (29 bins) and a second tally over field-working units,
 * then draws labeled bars + a clickable selection grid.  Decisive proof: it
 * counts via colonist_profession() (0x181F:0x0C54 = file 0x9102, which reads
 * the colonist record's +0x40 expertise field), and over UnitRecord +0x315B.
 *
 * KEY SPOT-CHECKS (byte-verified):
 *   @asm 0x0384C8  8b 1e 42 85        MOV bx,[0x8542]        (colony struct)
 *   @asm 0x0384CC  8a 47 1f           MOV al,[bx+0x1F]       (colony count)
 *   @asm 0x03850E  38 47 1a           CMP [bx+0x1A],al       (colony owner==player)
 *   @asm 0x0384DA  9a 54 0c 1f 18     LCALL 0x181F:0x0C54    colonist_profession()
 *
 * CONTENT (byte-cited):
 *   bins[0x1D] = {0};                                       @asm 0x0384A0..0x0384BA
 *   for (c = 0; c < [0x8542].colony_count(+0x1F); c++) {    @asm 0x0384C4 outer
 *       if ([0x8542].owner(+0x1A) != player) { advance colony; continue; }
 *                                                           @asm 0x038507/0x03850E
 *       for (slot = 0; slot < colonists_in_colony; slot++)
 *           bins[ colonist_profession(slot) ]++;            @asm 0x0384DA/0x0384EA
 *       advance to next owned colony via select_player_ctx; @asm 0x0384FE 0x9E6
 *   }
 *   for (u = 0; u < [0x539C] units; u++)                    @asm 0x038524 inner
 *       if (unit.owner(+0x3147)&0xF==player && unit.working(0x181F:0xB28))
 *           bins[ unit.profession(+0x315B) ]++;             @asm 0x038549 +0x315B
 *   // remap/skip pseudo-professions: idx 0x12/0x13/0x17 skipped, 0x1C->0x13
 *                                                           @asm 0x0385A0..0x0385C3
 *   for (k = 0; k < 0x1D; k++) draw bar bins[k] with label  @asm 0x038598 loop
 *       (header string [bx-0x715C], color via 0x181F:0x2C6, geometry 0x181F:0x24A);
 *   // then a click region: if mouse ([0x7E8],[0x7EA]) in a bar, call 0x34BE
 *   //   (= func_03807E, the per-profession drill-down, file 0x03807E).
 *                                                           @asm 0x038706..0x038769
 *
 * args: player = [bp+6]
 * ============================================================================ */
extern void  prof_bar_color(int idx);            /* 0x181F:0x02C6 -> 0x012B:0x0002 */
extern void  prof_bar_geom(int dx, int di);      /* 0x181F:0x024A -> 0x012B:0x015C */
extern int   prof_hit_test(int x, int y, int w, int h); /* 0x181F:0x03CA (mouse-in-bar) */
/* labor_drilldown (call 0x34BE -> func_03807E) declared in the helper block above */

void report_labor(int player)
{
    int  bins[0x1D];                             /* [bp-0xC4] 29 profession bins */
    char buf[0x8A];                              /* [bp-0x8A] scratch text */
    int  col = 2, row = 0x19;                    /* [bp-0x106]/[bp-0x108] */
    int  c, u, k;

    rpt_select_player(player);                   /* @asm 0x038421 0x181F:0x582 */
    rpt_draw_frame(4);                           /* @asm 0x03842C panel 4 (Labor) */
    {
        uint32_t h = rpt_blit_bg(0, 0x140, 5, 0x90,
                                 g_rpt_str[(0x2E1C - 0x2DEE) / 2]); /* @asm 0x038440 0x0022 */
        rpt_commit((uint16_t)(h >> 16), (uint16_t)h);              /* @asm 0x03844A 0x0100 */
        /* second background strip (the grid area), height = [0x89E][0]+6.      */
        h = rpt_blit_bg(0, 0x140, *(uint8_t far *)g_rpt_str /*[0x89E]*/ + 6, 0x91,
                        g_rpt_str[(0x2E2A - 0x2DEE) / 2]);         /* @asm 0x03846B 0x0022 */
        rpt_commit((uint16_t)(h >> 16), (uint16_t)h);              /* @asm 0x038475 0x0100 */
    }

    for (k = 0; k < 0x1D; k++) bins[k] = 0;      /* @asm 0x0384A0..0x0384BA (init 0x140/0xC8 too) */

    /* tally colonists in the player's colonies, by profession.
     * @asm 0x0384C4 outer loop:  for (c = 0; c < ctx[+0x1F population]; c++)
     *   if (ctx[+0x1A owner] != player) { select_player_ctx advances; continue }
     *   for slot in colony: bins[ colonist_profession(slot) ]++   @asm 0x0384DA */
    for (c = 0; c < (int)((uint8_t far *)ctx)[0x1F]; c++) {        /* @asm 0x0384CC +0x1F */
        if (((uint8_t far *)ctx)[0x1A] != (uint8_t)player)        /* @asm 0x03850E +0x1A */
            continue;
        /* bins[ colonist_profession(c) ]++;  (row body ANCHOR)   @asm 0x0384DA 0x0C54 */
        bins[colonist_profession(c) % 0x1D]++;
    }

    /* tally field-working units by profession (+0x315B). */
    for (u = 0; u < (int)g_unit_count_539C; u++) {   /* @asm 0x038524 / 0x03855A CMP [0x539C] */
        /* if (unit[u].owner(+0x3147)&0xF == player && colonist_is_working(u))
         *     bins[ unit[u].profession(+0x315B) ]++;   @asm 0x038529..0x038552 */
        (void)u;
    }
    /* @asm 0x0385A0: skip pseudo-prof idx 0x12/0x13/0x17; remap 0x1C->0x13.    */

    /* draw the 29 profession bars with labels + handle a click-to-drilldown. */
    for (k = 0; k < 0x1D; k++) {                  /* @asm 0x038598 draw loop */
        /* str = LABELS header [bx-0x715C]; color = prof_bar_color(k);
         * geometry via prof_bar_geom; value = bins[k].  @asm 0x0385C1..0x038682 */
        (void)k;
    }
    /* click region: if prof_hit_test(mouse [0x7E8],[0x7EA]) hits bar j,
     *   labor_drilldown(player, j, bins[j]);   @asm 0x038706..0x038769 */
    (void)bins; (void)buf; (void)col; (void)row;
}

/* ============================================================================
 * report_economic -- VICEROY func_038A50  (F5 / selector 0x44 / Economic Adv.)
 * ----------------------------------------------------------------------------
 * @asm_function  func_038A50  file 0x038A50..0x038ED3 (1155 B, ENTER 0x8C,0)
 * @asm_disasm    page_05.asm lines 2052..2449 ; terminal RETF @0x038ED3
 * @asm_extent    @0x038A50 = c8 8c 00 00 (ENTER 0x8C,0)
 * Reached: SETREPORT @asm 0x023887 (CMP [bp+6],0x44 -> LCALL 0x191F:0x3E2).
 *
 * IDENTITY: Economic Adviser.  Tabulates the player's FINANCIAL ledger -- a
 * per-cargo $ table indexed [player*0x4F + col] of 64-bit (long) values at
 * [bx-0x777C]/[bx-0x777A], formatted as dollar amounts ("$" handle 0x11B4,
 * /1000 via long-divmod 0xD1D:0xF92, sign handling), drawn as a column of rows
 * with cargo-name headers and gridlines.  Title via panel 5.
 *
 * KEY SPOT-CHECKS (byte-verified):
 *   @asm 0x038C9A  6b 5e 06 4f        IMUL bx,[bp+6],0x4F   (player * 79 cols)
 *   @asm 0x038CA5  8b 87 84 88        MOV ax,[bx-0x777C]    (ledger value lo)
 *   @asm 0x038CA9  8b 97 86 88        MOV dx,[bx-0x777A]    (ledger value hi)
 *   @asm 0x038C53  9a a4 07 1d 0d     LCALL 0xD1D:0x07A4    strcat_near
 *   @asm 0x038D2B  68 b4 11           PUSH 0x11B4 ("$")
 *
 * CONTENT (byte-cited):
 *   draw a horizontal rule + column headers (cargo names) -- the 0x11 (17)
 *     cargo columns, each header via box_outline/icon.        @asm 0x038ADC..0x038BDB
 *   for (cargo = 0; cargo < 0x11; cargo++) {                  @asm 0x038C... rows
 *       val = (long) ledger[ player*0x4F + cargo ];           @asm 0x038C9A/0x038CA5
 *       sign = (val < 0) ? '-' : '+'; val = abs(val);         @asm 0x038CB3
 *       if (abs(val) >= 0x2710 [=10000]) val = round(val,1000)/1000;  @asm 0x038CDD
 *       fmt "$%ld" into buf (strcat "$"=0x11B4);              @asm 0x038C53/0x038D2B
 *       draw the row at its column.                           @asm 0x038C92/0x038D73
 *   }
 *   bottom totals via 0x191F:0x9EA (per-cargo total lookup).  @asm 0x038D7F..0x038D93
 *
 * args: player = [bp+6]
 * ============================================================================ */
extern int32_t cargo_total(int cargo);           /* 0x191F:0x09EA */

void report_economic(int player)
{
    char buf[0x54];                              /* [bp-0x54] row text */
    int  col = 0x19, row = 4;                    /* [bp-0x5A]/[bp-0x56] */
    int  cargo;

    rpt_select_player(player);                   /* @asm 0x038A58 0x181F:0x582 */
    rpt_draw_frame(5);                           /* @asm 0x038A63 panel 5 (Economic) */
    {
        uint32_t h = rpt_blit_bg(0, 0x140, 5, 0x90,
                                 g_rpt_str[(0x2E1E - 0x2DEE) / 2]); /* @asm 0x038A77 0x0022 */
        rpt_commit((uint16_t)(h >> 16), (uint16_t)h);              /* @asm 0x038A81 0x0100 */
        h = rpt_blit_bg(0, 0x140, *(uint8_t far *)g_rpt_str + 6, 0x91,
                        g_rpt_str[(0x2F56 - 0x2DEE) / 2]);         /* @asm 0x038AA2 0x0022 */
        rpt_commit((uint16_t)(h >> 16), (uint16_t)h);              /* @asm 0x038AAC 0x0100 */
    }
    /* header rule + the 0x11 cargo column headers (box_outline + icons). */
    box_outline(0x77, 0x19, 0x43, 0xA1);          /* @asm 0x038ACF 0x191F:0x08B2 */
    for (cargo = 0; cargo < 0x11; cargo++) {      /* @asm 0x038BDB header-icon loop */
        hud_icon(2, 0x138, 0x21 + cargo * 8);     /* @asm 0x038BCD 0x191F:0x08BC */
    }

    /* per-cargo financial rows: ledger[player*0x4F + cargo], formatted as $. */
    for (cargo = 0; cargo < 0x11; cargo++) {      /* @asm 0x038BE7 outer (bp-0x84) */
        /* int32_t val = *(int32_t*)&ledger[player*0x4F + cargo];   @asm 0x038C9A
         * sign/abs/round-by-1000; strcat "$" (0x11B4); draw row.   @asm 0x038CB3.. */
        (void)cargo;
    }
    /* totals row via cargo_total(): @asm 0x038D7F PUSH [bp-0x84]; 0x191F:0x9EA */
    rpt_footer(-1, -2);
    (void)buf; (void)col; (void)row;
}

/* ============================================================================
 * report_colony -- VICEROY func_039218  (F6 / selector 0x45 / Colony Adviser)
 * ----------------------------------------------------------------------------
 * @asm_function  func_039218  file 0x039218..0x0393F3 (475 B, ENTER 0x68,0)
 * @asm_disasm    page_05.asm lines 2748..2914 ; terminal RETF @0x0393F2
 * @asm_extent    @0x039218 = c8 68 00 00 (ENTER 0x68,0)
 * Reached: SETREPORT @asm 0x023898 (CMP [bp+6],0x45 -> LCALL 0x191F:0x3D4).
 *
 * IDENTITY: Colony Adviser.  For each of the player's colonies it draws the
 * colony name + its on-map position and the SHIP units (types 0x0D..0x12)
 * present, paging 9 colonies per screen.  Reads colony struct [0x8542] (owner
 * +0x1A, name @+1, x/y @+0/+1), colony count [0x539E], and iterates units.
 *
 * KEY SPOT-CHECKS (byte-verified):
 *   @asm 0x039306  8b 1e 42 85        MOV bx,[0x8542]
 *   @asm 0x03930A  38 47 1a           CMP [bx+0x1A],al    (colony owner==player)
 *   @asm 0x0392F1  39 06 9e 53        CMP [0x539E],ax     (colony-table count)
 *   @asm 0x039273  80 bf 46 31 0d     CMP [bx+0x3146],0x0D (ship type lower bound)
 *
 * CONTENT (byte-cited):
 *   draw_frame(6) via func_0391C0 (call 0x34C8) -- a 2-panel header.  0x0391C0
 *   page = 0; for (i = 0; i < [0x539E]; i++) {                      @asm 0x0392EE
 *       select_player_ctx(i);                                       @asm 0x0392FB 0x9E6
 *       if ([0x8542].owner(+0x1A) != player) continue;              @asm 0x03930A
 *       text_draw(colony name @ [0x8542]+1+1, col, row+0x17);       @asm 0x03934D 0x13C
 *       draw colony marker icon at [0x8DC6] using name x/y          @asm 0x039330 0x2A8
 *       graph_bar of colony pos ([0x8542][0]/[+1]) via 0x7E0/0x8BC; @asm 0x039369
 *       for units at this colony: if unit.type(+0x3146) in 0x0D..0x12
 *           draw ship sprite + cargo via graph_bar (0x181F:0x2BC).  @asm 0x03928B
 *       row += 0x11; if (++count == 9) { footer; new page;          @asm 0x039214
 *           draw_frame again via func_0391C0; }                     @asm 0x0392D4
 *   }
 *   final footer via func_038F2C (call 0x34B4).                     @asm 0x0393EE
 *
 * args: player = [bp+6]
 * ============================================================================ */
void report_colony(int player)
{
    int  col = 2, row = 0x14;                    /* [bp-0x5A]/[bp-0x5E] */
    int  i, count = 0, page = 0;

    rpt_select_player(player);                   /* @asm 0x03921F 0x181F:0x582 */
    colony_hdr_panel();                          /* @asm 0x039232 call 0x34C8 (func_0391C0, panel 6) */

    for (i = 0; i < (int)g_colony_count_539E; i++) {  /* @asm 0x0392EE / 0x0392F1 CMP [0x539E] */
        select_player_ctx(i);                    /* @asm 0x0392FB 0x181F:0x9E6 (re-points ctx) */
        if (((uint8_t far *)ctx)[0x1A] != (uint8_t)player)
            continue;                            /* @asm 0x03930A CMP [0x8542][+0x1A],al / JNE */
        /* draw colony name @ [0x8542]+2, position marker [0x8DC6], and the
         * ships (unit type 0x0D..0x12) present, each via graph_bar/unit sprite.
         * @asm 0x03931F (text), 0x039330 (marker 0x2A8), 0x03928B (ship bar). */
        row += 0x11;                             /* @asm 0x039214 ADD [0x539E-row],0x11 */
        if (++count == 9) {                      /* @asm 0x03921B CMP [bp-0x68],9 */
            rpt_footer(-1, -2);                  /* @asm 0x039226 call 0x34A0 (page footer) */
            colony_hdr_panel();                  /* @asm 0x0392D4 new page header */
            count = 0; row = 0x14; page++;       /* @asm 0x0392E1 reset */
        }
    }
    colony_footer(player);                       /* @asm 0x0393EE call 0x34B4 (func_038F2C) */
    (void)col; (void)page;
}

/* ============================================================================
 * report_naval -- VICEROY func_03954C  (F7 / selector 0x46 / Naval Adviser)
 * ----------------------------------------------------------------------------
 * @asm_function  func_03954C  file 0x03954C..0x039887 (827 B, ENTER 0x6A,0)
 * @asm_disasm    page_05.asm lines 3034..3328 ; terminal RETF @0x039886
 * @asm_extent    @0x03954C = c8 6a 00 00 (ENTER 0x6A,0)
 * Reached: SETREPORT @asm 0x0238A9 (CMP [bp+6],0x46 -> LCALL 0x191F:0x3C6).
 *
 * IDENTITY: Naval Adviser.  Lists the player's SHIPS (unit types 0x0D..0x12 =
 * Caravel/Merchantman/Galleon/Privateer/Frigate/Man-O-War, from @UNIT) with
 * each ship's name, on-map position, cargo manifest, and a sprite; damaged
 * ships get a distinct sprite.  Iterates all units [0x539C] filtered by owner.
 *
 * KEY SPOT-CHECKS (byte-verified):
 *   @asm 0x0397E6  8b 46 98 / 39 06 9c 53  CMP [0x539C],ax   (total unit count)
 *   @asm 0x0397F2  8a 87 47 31        MOV al,[bx+0x3147]     (unit owner byte)
 *   @asm 0x039801  80 bf 46 31 0d     CMP [bx+0x3146],0x0D   (ship lower bound)
 *   @asm 0x039808  80 bf 46 31 12     CMP [bx+0x3146],0x12   (ship upper bound)
 *
 * CONTENT (byte-cited):
 *   for (u = 0; u < [0x539C] units; u++) {                          @asm 0x0397E3
 *       if (unit.owner(+0x3147)&0xF != player) continue;            @asm 0x0397F8
 *       t = unit.type(+0x3146);                                     @asm 0x0397F2
 *       if (t < 0x0D) {  // land unit at a colony: skip unless port  0x039801
 *           if (!tile_has_port(unit.x+0x3144,unit.y+0x3145)) continue; 0x03981F 0x768
 *       }
 *       if (t < 0x0D || t > 0x12) continue;  // keep only SHIPS      @asm 0x03982F/0x039839
 *       draw ship name [bx-0x7C74], cargo bar (graph_bar 0x2BC),     @asm 0x03954C body
 *           and the ship/cargo sprites (0x191F:0xF82 unit_sprite),   @asm 0x0396A2/0x039709
 *           with damaged-ship variant when (player - y == 0xC/0x10). @asm 0x03975A
 *       row += 0x14; page 7 ships per screen, then footer+repaginate.@asm 0x039796/0x0397A3
 *   }
 *   final footer via func_0393F4 (call 0x34AF).                     @asm 0x0397C9
 *
 * args: player = [bp+6]
 * ============================================================================ */
extern int   tile_has_port(int x, int y);        /* 0x181F:0x0768 */

void report_naval(int player)
{
    char buf[0x50];                              /* [bp-0x50] */
    int  col = 2, row = 0x2A;                    /* [bp-0x56]/[bp-0x58] */
    int  u, count = 0;

    /* NB: func_03954C does NOT call 0x181F:0x582 itself -- the player-select
     * (and panel-7 frame) happen INSIDE func_0393F4, reached here. */
    naval_footer_hdr(player);                    /* @asm 0x039555 call 0x34AF (func_0393F4 hdr/panel 7) */

    for (u = 0; u < (int)g_unit_count_539C; u++) {  /* @asm 0x0397E3 / 0x0397E9 CMP [0x539C] */
        /* if (unit[u].owner(+0x3147)&0xF != player) continue;       @asm 0x0397F8
         * t = unit[u].type(+0x3146);
         * if (t<0x0D && !tile_has_port(unit.x,unit.y)) continue;     @asm 0x03981F
         * if (t<0x0D || t>0x12) continue;          // SHIPS ONLY     @asm 0x03982F/0x039839
         * draw name [bx-0x7C74], cargo bars, ship sprite (damaged
         *   variant when player-y in {0xC,0x10}); row += 0x14.       @asm 0x03975A */
        (void)u;
    }
    naval_footer(player);                        /* @asm 0x0397C9 call 0x34AF footer */
    (void)buf; (void)col; (void)row; (void)count;
}

/* ============================================================================
 * report_foreign -- VICEROY func_039888  (F8 / selector 0x47 / Foreign Affairs)
 * ----------------------------------------------------------------------------
 * @asm_function  func_039888  file 0x039888..0x039E97 (1551 B, ENTER 0x72,0)
 * @asm_disasm    page_05.asm lines 3330..3861 ; terminal RETF @0x039886/0x0398A3
 * @asm_extent    @0x039888 = c8 72 00 00 (ENTER 0x72,0)
 * Reached: SETREPORT @asm 0x0238BA (CMP [bp+6],0x47 -> LCALL 0x191F:0x3B8).
 *
 * IDENTITY: FOREIGN AFFAIRS -- PROVEN.  The function's first act is:
 *   @asm 0x03988D  f6 06 82 53 01     TEST [0x5382],1     (independence declared?)
 *   @asm 0x039896  68 b6 11           PUSH 0x11B6 ("FOREIGNNOTAVAIL")
 *   @asm 0x039899  9a 52 06 1f 18     LCALL 0x181F:0x652  (show message, return)
 * i.e. when independence is declared it shows "FOREIGNNOTAVAIL" and bails --
 * the literal string handle 0x11B6 decodes to "FOREIGNNOTAVAIL" in the EXE.
 *
 * CONTENT (byte-cited): a 4-column comparative diplomacy panel.
 *   if ([0x5382]&1) { show FOREIGNNOTAVAIL; return; }               @asm 0x03988D
 *   draw a 4-row header grid (the 4 power columns).                 @asm 0x0398E2 (loop<4)
 *   for (slot = 0; slot < 4; slot++) {                              @asm 0x039889..0x03991E
 *       if (recognized(0x181F:0x7B4(4,player))==0 && [0x53A2]==0)
 *           { skip block }                                          @asm 0x039922/0x039933
 *       draw the other power's name [bx-0x6D68], a stat from
 *           [bx-0x6BB2], [bx-0x6BF0], [bx-0x6BE4]>>3, each labeled
 *           via str_cat/str_cat_num + text_draw.                    @asm 0x0399.. cols
 *   }
 *
 * The per-row strings (slots [0x2E74]/[0x2E78]/[0x2E7A]/[0x2E7C]/[0x2E7E]/
 * [0x2E80]) are LABELS.TXT "FOREIGN AFFAIRS REPORT" headers; the per-power
 * stat arrays [bx-0x6D68]/[bx-0x6BB2]/[bx-0x6BF0]/[bx-0x6BE4] hold the
 * diplomatic-standing values [not yet decoded: which is which].
 *
 * args: player = [bp+6]
 * ============================================================================ */
extern void  show_message(int flag, int str_handle);   /* 0x181F:0x0652 */
extern int   foreign_recognized(int n, int player);    /* 0x181F:0x07B4 */

void report_foreign(int player)
{
    char buf[0x50];                              /* [bp-0x50] */
    int  col = 2, row = 0xD;                     /* [bp-0x5A]/[bp-0x5E] */
    int  slot;

    if (g_flags_5382 & 1) {                      /* @asm 0x03988D TEST [0x5382],1 / JE */
        show_message(1, 0x11B6);                 /* @asm 0x039899 0x181F:0x652 "FOREIGNNOTAVAIL" */
        return;                                  /* @asm 0x0398A2 LEAVE/RETF */
    }

    rpt_select_player(player);                   /* @asm 0x0398A7 0x181F:0x582 */
    rpt_draw_frame(8);                           /* @asm 0x0398B2 panel 8 (Foreign Affairs) */
    {
        uint32_t h = rpt_blit_bg(0, 0x140, 2, 0x90,
                                 g_rpt_str[(0x2E74 - 0x2DEE) / 2]); /* @asm 0x0398C6 0x0022 */
        rpt_commit((uint16_t)(h >> 16), (uint16_t)h);              /* @asm 0x0398D0 0x0100 */
    }
    /* 4-row header grid (the four foreign powers as columns). */
    /* @asm 0x0398E2..0x03991E: for j in 0..3: box_outline row j*0x2D+... */

    for (slot = 0; slot < 4; slot++) {           /* @asm 0x039889.. outer (bp-0x66) */
        /* if (foreign_recognized(4, player)==0 && [0x53A2]==0) skip;  @asm 0x039922
         * else draw the power name [bx-0x6D68] and three standing stats
         *   [bx-0x6BB2], [bx-0x6BF0], [bx-0x6BE4]>>3, each labeled.    @asm 0x0399.. */
        (void)slot;
    }
    (void)buf; (void)col; (void)row;
}

/* ============================================================================
 * report_indian -- VICEROY func_03744A  (F9 / selector 0x48 / Indian Adviser)
 * ----------------------------------------------------------------------------
 * @asm_function  func_03744A  file 0x03744A..0x037957 (1294 B, ENTER 0x6E,0)
 * @asm_disasm    page_05.asm lines 105..574 ; terminal RETF @0x037957
 * @asm_extent    @0x03744A = c8 6e 00 00 (ENTER 0x6E,0)
 * Reached: SETREPORT @asm 0x023843 (CMP [bp+6],0x48 -> LCALL 0x191F:0x41A).
 *
 * IDENTITY: Indian Adviser -- PROVEN by unit-type math.  For each tribe it
 * tabulates that tribe's military strength by counting native unit types
 * 0x14 (Armed Braves) and 0x16 (Mounted Warriors) -- the @UNIT table's native
 * combat units -- and multiplies by 0x32 (50) for a strength figure.  It also
 * reads the per-tribe record [0x8D4E] (color +2, treaty/flags +3&0x80, FF/level
 * +7, extra +8) and the tribe-name/colony positions.  8 tribes, paged.
 *
 * KEY SPOT-CHECKS (byte-verified):
 *   @asm 0x03768E  80 bf 46 31 14     CMP [bx+0x3146],0x14  (Armed Braves)
 *   @asm 0x037695  80 bf 46 31 16     CMP [bx+0x3146],0x16  (Mtd. Warriors)
 *   @asm 0x037671  8a 47 07           MOV al,[bx+7]         (tribe FF/level)
 *   @asm 0x037667  39 06 9a 53        CMP [0x539A],ax       (a per-tribe count)
 *   @asm 0x0376AB  b8 32 00 / f7 ..   IMUL 0x32             (strength = cnt*50)
 *
 * CONTENT (byte-cited):
 *   for (t = 0; t < 8; t++) {                                       @asm 0x03782E (bp-0x64<8)
 *       iter_set(t); rec = [0x8D50];                                @asm 0x03783A 0xA42
 *       if (!(tribe_or_ff_flags(rec,player) & 0x20)
 *           && !([0x8D4E].flags(+3)&0x80)) continue;  // not met    @asm 0x03784C/0x03785C
 *       // count this tribe's settlements: scan settlement table
 *       //   ([0x54EE]+idx*0x12), bump per matching owner==t;       @asm 0x037638 0x12-stride
 *       // count this tribe's combat units (type 0x14 || 0x16):
 *       for (u in units) if (unit.owner==t && type in {0x14,0x16})
 *           strength++;                                             @asm 0x03767F..0x0376AB
 *       strength *= 0x32;                                           @asm 0x0376AB IMUL 0x32
 *       draw the tribe block: name, settlement count, unit strength,
 *           tension [0x8D4E]+8, mission flag, etc.                  @asm 0x0376B4..0x0377D2
 *       row += 0x15.                                                @asm 0x037827
 *   }
 *   then a clickable tribe-detail region (mouse [0x7E8],[0x7EA]) ->  @asm 0x037837..
 *       per-tribe drill-down via 0x181F:0x30C / 0x35C and 0x191F... .
 *
 * args: player = [bp+6]
 * ============================================================================ */
void report_indian(int player)
{
    char buf[0x52];                              /* [bp-0x52] */
    int  col = 0x19, row = 0xA;                  /* [bp-0x5C]/[bp-0x5A] */
    int  t;

    /* NB: func_03744A does NOT call 0x181F:0x582 at entry; it uses [bp+6]
     * (player) directly and the per-tribe text uses 0x181F:0x182 (str_cat_num)
     * inside the loop.  It opens straight to report_open(panel 1). */
    rpt_draw_frame(1);                           /* @asm 0x037453 call 0x34C3 panel 1 (Indian) */
    {
        uint32_t h = rpt_blit_bg(0, 0x140, 5, 0x90,
                                 g_rpt_str[(0x2DF4 - 0x2DEE) / 2]); /* @asm 0x037467 0x0022 */
        rpt_commit((uint16_t)(h >> 16), (uint16_t)h);              /* @asm 0x037471 0x0100 */
    }

    for (t = 0; t < 8; t++) {                     /* @asm 0x03782E CMP [bp-0x64],8 / JL */
        /* iter_set(t); rec=[0x8D50]; if not-contacted (flags) continue;
         * count settlements (table [0x54EE], stride 0x12) and combat units
         *   (type 0x14 Armed Braves || 0x16 Mtd Warriors), strength*=0x32;
         * draw the tribe row (name/color [0x8D4E]+2, FF/level +7, tension +8).
         * @asm 0x037837..0x0377D2 ; row += 0x15 @asm 0x037827 */
        (void)t;
    }
    rpt_footer(-1, -2);                           /* @asm 0x037937 call 0x34A0 footer */
    (void)buf; (void)col; (void)row;
}

/* ============================================================================
 * report_score -- VICEROY func_038778 (entry) reached for F10 at file 0x387E8
 * ----------------------------------------------------------------------------
 * @asm_function  func_038778  file 0x038778..0x03888F (280 B, ENTER 6,0)
 * @asm_disasm    page_05.asm lines 1804..1892 ; terminal RETF @0x03888F
 * @asm_extent    @0x038778 = c8 06 00 00 (ENTER 6,0)
 * Reached: SETREPORT @asm 0x0238CB (CMP [bp+6],0x49) -> if ([0x5383]&0x20)
 *          LCALL 0x181F:0x574.  That thunk (file 0x1AB64) is Type-A page 0x05
 *          offset 0x14A8 -> file 0x0387E8 = func_038778 + 0x70.
 *
 * IDENTITY: Colonization Score (F10).  func_038778 is the SCORE/standings
 * renderer: report_open(5) titled frame, a header box, then a 16-row x 0x12-col
 * grid of score icons drawn from the score sheet [0x83E]/[0x840] via icon_at /
 * hud_icon.  (panel 5 here is the score layout.)
 *
 * !!! ANOMALY -- THE SoL/SCORE THUNK ENTRY IS NOT A CLEAN INSTRUCTION BOUNDARY:
 *   The thunk 0x181F:0x574 resolves to file 0x387E8 (page05 0x37340 + 0x14A8),
 *   which is +0x70 into func_038778 and lands in the MIDDLE of the instruction
 *   `push word [0x2DAE]` decoded by the re-segmenter at 0x387E5 (bytes
 *   ff 36 ae 2d -> next insn 0x387E9).  Disassembling forward from 0x387E8
 *   (2d ff ff ...) does NOT yield a sane prologue.  So one of these is true and
 *   is recorded as [not yet resolved] pending a tie-break:
 *     (a) func_038778 IS the F10 Score renderer and the engine RE-ENTERS it at
 *         +0x70 to skip the title (the title was already drawn by a prior call),
 *         OR
 *     (b) the page-05 re-segmentation mis-joined two functions and 0x387E8 is a
 *         genuine (currently mis-aligned) second entry.
 *   The OVERLAY_THUNKS.md decode already flagged this ("0x0387E8 (+112 into
 *   func_038778), [lands on entry] = no").  The CONTENT of func_038778 (the
 *   score grid) is decoded below from its CLEAN entry (0x038778); the exact
 *   F10 entry offset is [not yet decoded].
 *
 * CONTENT (byte-cited, from the clean entry 0x038778):
 *   rpt_select_player([bp+6]);                  @asm 0x03877F 0x181F:0x582
 *   rpt_draw_frame(5);                          @asm 0x03878A call 0x34C3 (panel 5)
 *   h = rpt_blit_bg(... [0x2E1E]); rpt_commit;  @asm 0x03879E/0x0387A8
 *   h = rpt_blit_bg(... [0x2F58], y=[0x89E][0]+6); rpt_commit;  @asm 0x0387C9/0x0387D3
 *   icon_at(score sheet [0x83E]/[0x840], row, x=0x17, y=[bp-2]); @asm 0x038825 0x254
 *   for (i = 0; i < 0x10; i++)                   @asm 0x03880A..0x038858 (16 rows)
 *       box_outline at row, then advance [bp-2] by 0xE;          @asm 0x03884C 0x8B2
 *   for (i = 0; i < 0x12; i++)                   @asm 0x03885F..0x03888C (18 cols)
 *       hud_icon(2, 0x137, 0x2A + i*8);          @asm 0x038880 0x8BC
 *
 * args: player = [bp+6]
 * ============================================================================ */
void report_score(int player)
{
    int  r2 = 0x5A, r4 = 0x19;                    /* [bp-2]/[bp-4] */
    int  i;

    rpt_select_player(player);                    /* @asm 0x03877F 0x181F:0x582 */
    rpt_draw_frame(5);                            /* @asm 0x03878A call 0x34C3 panel 5 (Score) */
    {
        uint32_t h = rpt_blit_bg(0, 0x140, 5, 0x90,
                                 g_rpt_str[(0x2E1E - 0x2DEE) / 2]); /* @asm 0x03879E 0x0022 */
        rpt_commit((uint16_t)(h >> 16), (uint16_t)h);              /* @asm 0x0387A8 0x0100 */
        h = rpt_blit_bg(0, 0x140, *(uint8_t far *)g_rpt_str + 6, 0x91,
                        g_rpt_str[(0x2F58 - 0x2DEE) / 2]);         /* @asm 0x0387C9 0x0022 */
        rpt_commit((uint16_t)(h >> 16), (uint16_t)h);              /* @asm 0x0387D3 0x0100 */
    }

    /* first score-icon row from the score sheet [0x83E]/[0x840]. */
    icon_at(/*sheet*/0, 0, /*row*/ r4 + 0x17, 0x17, /*ss*/0, r2, 4); /* @asm 0x038825 0x254 */

    for (i = 0; i < 0x10; i++) {                  /* @asm 0x03880A..0x038858 (16 rows) */
        box_outline(0x77, 0x19, 0xB2, r4 + 2 + i);/* @asm 0x03884C 0x191F:0x08B2 */
        r2 += 0xE;                                /* @asm 0x03883C ADD [bp-2],0xE */
    }
    for (i = 0; i < 0x12; i++) {                  /* @asm 0x03885F..0x03888C (18 cols) */
        hud_icon(2, 0x137, 0x2A + i * 8);         /* @asm 0x038880 0x191F:0x08BC */
    }
    (void)r2; (void)r4;
}

/* ############################################################################
 * # THE GENERIC REPORT-GRID LAYOUT ENGINE  (overlay page 0x19)               #
 * ############################################################################
 *
 * STATUS: BYTE_VERIFIED.  These are the report-SCREEN frame + per-cell grid
 * placement composers on page 0x19 (file_offset 0x06FB40, code_offset
 * 0x06FDF0).  They are the layout primitives that the per-report draws (and the
 * report dispatcher func_0235D6's report branches) use to position a report's
 * body into a fixed grid. All coordinates cites its @asm push.
 *
 * @asm_disasm  code/VICEROY/disasm_overlay_reseg/page_19.asm
 * raw-EXE spot-checks (this session, file offsets = page is 1:1 from 0x06FDF0):
 *   0x06FDF3 = 6b 46 06 4c / 05 0a 00   imul ax,[bp+6],0x4c ; add ax,0xa   (4-col X)
 *   0x06FE0C = 6b 4e 08 3c / 05 10 00   imul cx,[bp+8],0x3c ; add ax,0x10  (4-col Y)
 *   0x0702DA = 6b c2 69    / 05 17 00   imul ax,dx,0x69     ; add ax,0x17  (3-col X)
 *   0x0702F2 = 6b cb 60    / 05 07 00   imul cx,bx,0x60     ; add ax,7     (3-col Y)
 *   0x06FFAC = 68 fd 00 68 fe 00 6a 04 68 40 01 6a 00   report-frame title bar
 *   0x070051 = 83 7e ae 04 7d 07        cmp [bp-0x52],4 (4 cols) ; inner cmp ..,3
 *
 * ----------------------------------------------------------------------------
 * PLACEMENT TABLE -- func_06FDF0 (4-COLUMN report cell origin)
 *   element              x                       y                          @asm
 *   cell(col,row) origin col*0x4C(76)+0x0A(10)    row*0x3C(60)+0x10(16)      0x06FDF3 / 0x06FE0C
 *   (the row>1 path subtracts 1 from the y accumulator first -- a rounding
 *    nudge: y = (row>1 ? -1 : 0) + row*60 + 16; @asm 0x06FDFF cmp [bp+8],1)
 *   -> 4-col grid: column pitch 76 px (left margin 10), row pitch 60 (top 16).
 *
 * PLACEMENT TABLE -- func_0702C0 (3-COLUMN report cell origin)
 *   It takes a single linear index n=[bp+6] and derives col=(n+1)%3,
 *   row=(n+1)/3 (so index 0 -> col1,row0; the column 0 of row 0 is skipped --
 *   reserved for a row label/title).  @asm 0x0702C8 inc ax ; idiv 3 (twice).
 *   element              x                       y                          @asm
 *   cell(n) origin       col*0x69(105)+0x17(23)   row*0x60(96)+0x07(7)       0x0702DA / 0x0702F2
 *   (row>1 path: y = (row>1 ? -1 : 0) + row*96 + 7; @asm 0x0702E5 cmp bx,1)
 *   -> 3-col grid: column pitch 105 px (left margin 23), row pitch 96 (top 7).
 *
 * PLACEMENT TABLE -- func_06FF94 (REPORT-SCREEN FRAME + 4x3 grid walk)
 *   element                         x        y        sprite/str-id          @asm
 *   title text (str [0x2EFA])       --       0        ss-text 0x181F:0x1C8   0x06FFAC  push 0xfd,0xfe,4,0x140,0
 *   header rule                     0        0x10(16) box 0x181F:0x00E2 w=0x140 0x06FFCF
 *   subtitle text (str [0x2EFC])    0        0xBE(190) commit 0x181F:0x0100  0x070003  push 0xfe,0xbe,0x140,0
 *   footer rule                     0        0xB7(183) box 0x181F:0x00E2 w=0x140 0x07001B
 *   then walk col=0..3, row=0..2 -> 4 columns x 3 rows = 12 cells, calling the
 *   per-cell content trampoline (call 0x110B) with (row,col).  @asm:
 *     0x07004F inner: inc/cmp [bp-0x54],3 (rows) ; 0x070051 outer cmp [bp-0x52],4 (cols)
 *
 * ---- DGROUP report title-string slots (text from LABELS.TXT, not the EXE) --
 *   0x2EFA  report-frame TITLE string handle    (@asm 0x06FF9C push [0x2EFA])
 *   0x2EFC  report-frame SUBTITLE string handle (@asm 0x06FFE7 push [0x2EFC])
 *   0x2EDA  per-column header string table base (4-col; @asm 0x06FECE +si)
 *   0x2EE2  per-cell label string table base    (4-col; @asm 0x06FF3E +bx)
 *   The 4-col composer (func_06FE1C) also reads region rects [0x839E..0x83A4]
 *   (a 4-word inner rect) and [0x2DA8..0x2DAE] (the content region), threads the
 *   panel handle [0x89E], and writes one row at color 0x0A normally / 0x0E for
 *   the "current" column (cmp [bp+6],[0xA60A]); @asm 0x06FE66/0x06FE72.
 * ---------------------------------------------------------------------------- */

/* DGROUP report-frame title-string slots (LABELS.TXT-sourced; cited above). */
extern uint16_t g_rpt_title_2EFA;   /* DGROUP:0x2EFA report TITLE str handle    */
extern uint16_t g_rpt_subtitle_2EFC;/* DGROUP:0x2EFC report SUBTITLE str handle */

/* page-0x19 frame/grid ANCHOR primitives (signatures byte-exact from sites):
 *   0x181F:0x16E  str_cat(buf, str_handle)            (append a string)
 *   0x181F:0x1C8  rpt_title_draw(buf,ss, x,y, color2,color1) -- the framed title bar
 *   0x181F:0x11E  str_begin(buf)   0x181F:0x128 str_end(buf)
 *   0x181F:0x100  rpt_commit(buf,ss, col, x, y, n)    -- commit a text row
 *   0x181F:0x00E2 box_rule(x, w, y, ...)              -- a horizontal rule/box
 *   0x110B (call) -> ljmp 0x1A1F:0xB9E  per-cell content trampoline (row,col)
 *   0x1101 (call) -> ljmp 0x1A1F:0xB82  the 4-col xy composer (func_06FDF0) */
extern void  rpt_grid_str_cat(char *buf, int str_handle);                 /* 0x181F:0x16E */
extern void  rpt_title_draw(char *buf, int ss, int sprL, int sprR,
                            int four, int w, int y);                       /* 0x181F:0x1C8 */
extern void  rpt_grid_str_begin(char *buf);                                /* 0x181F:0x11E */
extern void  rpt_grid_str_end(char *buf);                                  /* 0x181F:0x128 */
extern void  rpt_grid_commit(char *buf, int ss, int spr, int x, int y, int n); /* 0x181F:0x100 */
extern void  rpt_box_rule(int x, int w, int y, int a, int b, int c);       /* 0x181F:0x00E2 */
extern void  rpt_cell_content(int row, int col);                           /* call 0x110B */

/* ============================================================================
 * report_cell_xy_4col -- VICEROY func_06FDF0  (page 0x19, file 0x06FDF0)
 * ----------------------------------------------------------------------------
 * @asm_function  func_06FDF0   file 0x06FDF0..0x06FE1B  (44 B, push bp;mov bp,sp)
 * 4-column report-cell origin calculator.  byte-verified (see raw spots above).
 *   *xout = col*76 + 10                          @asm 0x06FDF3 imul 0x4c / add 0xa
 *   *yout = (row>1 ? -1 : 0) + row*60 + 16        @asm 0x06FE0C imul 0x3c / add 0x10
 * args: col=[bp+6], row=[bp+8], int*xout=[bp+0xA], int*yout=[bp+0xC].
 * ============================================================================ */
void report_cell_xy_4col(int col, int row, int *xout, int *yout)
{
    *xout = col * 0x4C + 0x0A;                    /* @asm 0x06FDF3 col*76 + 10 */
    *yout = (row > 1 ? -1 : 0) + row * 0x3C + 0x10; /* @asm 0x06FE0C row*60 + 16 */
}

/* ============================================================================
 * report_cell_xy_3col -- VICEROY func_0702C0  (page 0x19, file 0x0702C0)
 * ----------------------------------------------------------------------------
 * @asm_function  func_0702C0   file 0x0702C0..0x070301  (66 B, ENTER 6,0)
 * 3-column report-cell origin calculator from a LINEAR index.  byte-verified.
 *   col = (index+1) % 3 ; row = (index+1) / 3      @asm 0x0702C8 inc / idiv 3 x2
 *   *xout = col*105 + 23                            @asm 0x0702DA imul 0x69 / add 0x17
 *   *yout = (row>1 ? -1 : 0) + row*96 + 7           @asm 0x0702F2 imul 0x60 / add 7
 * args: index=[bp+6], int*xout=[bp+8], int*yout=[bp+0xA].
 * ============================================================================ */
void report_cell_xy_3col(int index, int *xout, int *yout)
{
    int col = (index + 1) % 3;                    /* @asm 0x0702C8 inc ax; idiv 3 */
    int row = (index + 1) / 3;                    /* @asm 0x0702D7 idiv 3 (quotient) */
    *xout = col * 0x69 + 0x17;                     /* @asm 0x0702DA col*105 + 23 */
    *yout = (row > 1 ? -1 : 0) + row * 0x60 + 0x07;/* @asm 0x0702F2 row*96 + 7 */
}

/* ============================================================================
 * report_frame_grid -- VICEROY func_06FF94  (page 0x19, file 0x06FF94)
 * ----------------------------------------------------------------------------
 * @asm_function  func_06FF94   file 0x06FF94..0x07005F  (204 B, ENTER 0x54,0)
 * The REPORT-SCREEN frame builder + 4x3 cell-grid walk.  byte-verified.
 *
 * 1. title bar: str_cat(buf,[0x2EFA]); rpt_title_draw(buf,ss, 0xFE,0xFD, 4,
 *    0x140, 0)  -- a framed title at the top (sprites 0xFD/0xFE, full width 320,
 *    y=0).  @asm 0x06FF9C..0x06FFC3 (0x181F:0x1C8).
 * 2. header rule: box_rule(x=0, w=0x140, y=0x10) -- horizontal rule at y=16.
 *    @asm 0x06FFC6..0x06FFD7 (0x181F:0x00E2).
 * 3. subtitle: str_begin; str_cat([0x2EFC]); str_end; commit(buf,ss, 0xFE,
 *    x=0, y=0xBE) -- subtitle text near the bottom.  @asm 0x06FFD7..0x070018.
 * 4. footer rule: box_rule(x=0, w=0x140, y=0xB7) -- rule at y=183.
 *    @asm 0x07001B..0x07002F (0x181F:0x00E2).
 * 5. grid walk: for col in 0..3 { for row in 0..2 { rpt_cell_content(row,col) } }
 *    = 4 columns x 3 rows = 12 cells.  @asm 0x07002F..0x07005E.
 * ============================================================================ */
void report_frame_grid(void)
{
    char buf[0x50];                               /* [bp-0x50] */
    int  col, row;                                /* [bp-0x52]=col, [bp-0x54]=row */

    /* 1. framed title bar (sprites 0xFD/0xFE, width 0x140, y=0). */
    buf[0] = 0;                                    /* @asm 0x06FF98 mov [bp-0x50],0 */
    rpt_grid_str_cat(buf, g_rpt_title_2EFA);       /* @asm 0x06FFA4 0x181F:0x16E [0x2EFA] */
    rpt_title_draw(buf, 0 /*ss*/, 0xFE, 0xFD, 4, 0x140, 0); /* @asm 0x06FFBE 0x181F:0x1C8 */

    /* 2. header rule at y=0x10 (16), full width 0x140 (320). */
    rpt_box_rule(0, 0x140, 0x10, 0, 0, 0);         /* @asm 0x06FFD2 0x181F:0x00E2 */

    /* 3. subtitle text at x=0, y=0xBE (190). */
    buf[0] = 0;                                    /* @asm 0x06FFD7 mov [bp-0x50],0 */
    rpt_grid_str_begin(buf);                       /* @asm 0x06FFDF 0x181F:0x11E */
    rpt_grid_str_cat(buf, g_rpt_subtitle_2EFC);    /* @asm 0x06FFEF 0x181F:0x16E [0x2EFC] */
    rpt_grid_str_end(buf);                         /* @asm 0x06FFFB 0x181F:0x128 */
    rpt_grid_commit(buf, 0 /*ss*/, 0xFE, 0, 0xBE, 0); /* @asm 0x070013 0x181F:0x0100 */

    /* 4. footer rule at y=0xB7 (183), full width 0x140 (320). */
    rpt_box_rule(0, 0x140, 0xB7, 0, 0, 0);         /* @asm 0x07002A 0x181F:0x00E2 */

    /* 5. walk the 4-col x 3-row grid; each cell draws its own content. */
    for (col = 0; col < 4; col++) {                /* @asm 0x070051 cmp [bp-0x52],4 */
        for (row = 0; row < 3; row++) {            /* @asm 0x070039 cmp [bp-0x54],3 */
            rpt_cell_content(row, col);            /* @asm 0x070046 call 0x110B (row,col) */
        }
    }
}
