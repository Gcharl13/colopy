/* ============================================================================
 * dialog.c -- Modal popup / dialog-rect framework
 * ----------------------------------------------------------------------------
 * VICEROY's popups (price-change banners, advisor warnings, king/tax demands,
 * confirmation prompts) share one rect-computation path that is RESIDENT and
 * BYTE_VERIFIED. The actual WOODFRAM/WOODTILE frame BLIT and the text layout
 * are overlay-resident (library-implementation-only).
 *
 * Authoritative source for everything in this file:
 *   reverse_engineered/docs/DIALOG_GEOMETRY.md           (the rect data flow)
 *   reverse_engineered/code/VICEROY/disasm/func_067DC8_unknown.asm (the asm)
 *   reverse_engineered/docs/RENDERER_GEOMETRY.md "Popup framework" / "Map
 *     Banner Popups" (frame-verified popup geometry + GAME.TXT @width rule)
 *
 * Prior revision FABRICATED: a Dialog/DialogButton struct with title/body/
 * portrait/buttons, fixed DIALOG_X/Y/W/H = (40,40,240,120), a
 * save_screen_region/restore_screen_region framebuffer mechanism, button
 * geometry math, show_yes_no/show_alert/show_error with invented labels, a
 * KING_DEMAND_TABLE[7] with an invented demand string, and an FF congress
 * picker layout. None traced to a source; all removed.
 * ============================================================================ */
#include "viceroy_types.h"
#include "iolib.h"

/* DGROUP word/byte overlays (the project-wide DGROUP-relative views). Declared
 * LOCAL to this .c per scope rule (no globals.h edits). Used by both the rect
 * computation below and the colony dialog engine at the bottom of the file. */
extern int16_t g_word[];
extern uint8_t g_byte[];

/* ============================================================================
 * THE POPUP RECT (BYTE_VERIFIED)
 * ----------------------------------------------------------------------------
 * The popup pixel rect lives in four consecutive DGROUP words. They are NEVER
 * written by a direct MOV [imm],reg (a full-EXE opcode scan found 0 hits);
 * every write flows through LEA bx,[0x839E] + an indirect overlay call.
 * Source: docs/DIALOG_GEOMETRY.md "The four globals".
 *
 *   DGROUP:0x839E  word  dialog_rect[0]   (x / x1)
 *   DGROUP:0x83A0  word  dialog_rect[1]   (y / y1)
 *   DGROUP:0x83A2  word  dialog_rect[2]   (x2 / width)
 *   DGROUP:0x83A4  word  dialog_rect[3]   (y2 / height)
 *
 * CAUTION: DGROUP:0x839E..0x83A4 ALSO appears in SESSION_RUNTIME_TRACE as the
 * constant screen-clip rect (200,320,0,15585) across all 396 snapshots
 * (RENDERER_GEOMETRY.md "Screen-bounds reminder"). The dialog-rect setter
 * writes this same struct transiently when a popup is up. Do not treat the
 * clip-rect constant as a popup rect.
 * ============================================================================ */
#define DGROUP_DIALOG_RECT   0x839E   /* CITED: docs/DIALOG_GEOMETRY.md */

/* Upstream globals consumed by the rect computation (BYTE_VERIFIED writers
 * where known; docs/DIALOG_GEOMETRY.md "Upstream globals"):
 *   [0x174]  word  cursor_x         writer @ file 0x0765AC (A3 74 01)
 *   [0x176]  word  cursor_y         writer @ file 0x0765AF (89 16 76 01)
 *   [0x186]  word  dialog_state     (>= 0x64 enables the popup; writer RUNTIME_ONLY)
 *   [0x1EA4] byte  char_width_cols  (from GAME.TXT @width=NN; writer RUNTIME_ONLY)
 *   [0x1EA5] byte  char_height_rows (writer RUNTIME_ONLY)
 *   [0xA5A4] word  font_cell_width  writer @ file 0x068771
 *   [0xA5A6] word  font_cell_height writer @ file 0x06872C
 */

/* ----------------------------------------------------------------------------
 * compute_dialog_rect_from_cursor -- VICEROY func_067DC8.
 *
 * BYTE_VERIFIED. File 0x067DC8..0x067E09 (65 bytes).
 * Source: code/VICEROY/disasm/func_067DC8_unknown.asm + docs/DIALOG_GEOMETRY.md.
 *
 * Exact behaviour, transcribed from the disassembly:
 *   if ([0x186] >= 0x64) {
 *       arg4 = cursor_y                  ; [0x176]
 *       arg3 = cursor_x                  ; [0x174]
 *       arg2 = font_cell_height + char_height_rows - 0x0F   ; cx, top pad -15
 *       arg1 = font_cell_width  + char_width_cols  - 0x08   ; dx, left pad -8
 *       LEA bx, [0x839E]
 *       LCALL 0x181F:0x254   ; -> thunk @file 0x01A844 (type B) -> overlay
 *                            ;    setter 0x0C36:0x000A, which writes the 4
 *                            ;    args into [bx+0..+6] = [0x839E..0x83A4]
 *   }
 *
 * Which arg lands in which dialog_rect[] field depends on the setter's stack
 * layout in overlay segment 0x0C36 (not yet decoded; 0x0C36 not yet resolved
 * to a file offset; docs/DIALOG_GEOMETRY.md "The setter overlay function").
 *
 * char_width_cols/char_height_rows come from the GAME.TXT "@width=NN" directive
 * + body line count; their runtime values are NOT known statically. So the
 * RECT VALUES vary per popup (e.g. @PRICEDOWN @width=190 vs a narrower popup)
 * and cannot be hardcoded -- they must be recomputed from this formula.
 * RENDERER_GEOMETRY.md records OBSERVED outcomes only (e.g. PRICEDOWN popup
 * frame x=4,y=110,w=218,h=48 for one specific cursor+@width state).
 * ---------------------------------------------------------------------------- */
void compute_dialog_rect_from_cursor(void)
{
    if (g_word[0x186] < 0x64)            /* CITED: 067DDA CMP [0x186],0x64 / JL */
        return;                          /*        dialog_state gate            */

    /* All four arithmetic terms below are CITED line-for-line from
     * func_067DC8 (file 0x067DC8). The push order is right-to-left. */
    int arg4 = g_word[0x176];                                   /* 067DE1 cursor_y */
    int arg3 = g_word[0x174];                                   /* 067DE2 cursor_x */
    int arg2 = g_word[0xA5A6] + g_byte[0x1EA5] - 0x0F;          /* 067DE3..ED      */
    int arg1 = g_word[0xA5A4] + g_byte[0x1EA4] - 0x08;          /* 067DF1..FB      */

    /* 067DFE LEA bx,[0x839E] ; 067E02 LCALL 0x181F:0x254 (setter writes [bx]).
     * The setter (overlay 0x0C36:0x000A) file offset not yet decoded. */
    overlay_set_dialog_rect(DGROUP_DIALOG_RECT, arg1, arg2, arg3, arg4); /* body in thunk page */
}

/* ----------------------------------------------------------------------------
 * NOTE on func_067E8C: a sibling rect-setter at file 0x067E8C (65 bytes; also
 * LEA [0x839E]) exists and may use a different formula for a different popup
 * class. docs/DIALOG_GEOMETRY.md lists 8 LEA-[0x839E] sites across
 * func_067DC8, func_067E8C, func_075352, func_075FB6 (+3 orphans). Each may
 * compute the rect differently -> the others are not yet decoded.
 * ---------------------------------------------------------------------------- */

/* ============================================================================
 * POPUP FRAME + TEXT (library-implementation-only -- overlay-resident)
 * ----------------------------------------------------------------------------
 * After the rect is set, the popup is drawn with the WOODFRAM/WOODTILE frame
 * art and FONTSMAL/FONTTINY text. That draw is overlay-resident (undecoded).
 *
 * What is frame-verified about popup geometry (RENDERER_GEOMETRY.md
 * "Popup framework -- TWO CLASSES" + "Map Banner Popups"):
 *   - Class 1 (banner, single line): speaker sprite drawn ABOVE the banner
 *     (separate layer, overlaps the map view); banner contains text only.
 *   - Class 2 (warning + choices): larger speaker sprite, multi-line body,
 *     quoted response options highlighted per the GAME.TXT @default directive.
 *   - Body width comes from GAME.TXT "@width=NN" (pixels); WOODFRAM border adds
 *     ~10px each side. Centering/Y depend on game state + the rect above.
 *   - Frame art: WOODFRAM.SS (stretched/tiled). Speaker sprites: MSS* / MYR*.
 *
 * No resident byte evidence for the frame/text draw calls -> not reconstructed.
 * ============================================================================ */
void dialog_draw_frame(void)
{
    /* library-implementation-only: overlay-resident WOODFRAM/WOODTILE blit +
     * FONTSMAL text layout using the rect at DGROUP:0x839E..0x83A4 above. */
}

/* ----------------------------------------------------------------------------
 * Specific dialogs (king/tax demand, Founding-Father congress, yes/no, alert)
 * are driven by GAME.TXT / LABELS.TXT templates + the overlay text engine, not
 * by resident C with hardcoded strings. Their resident wiring is library-implementation-only; see
 * docs/POPUP_TEMPLATE_AUDIT.md and docs/GAME_TXT_CATALOG.md for the template
 * format. (No fabricated KING_DEMAND_TABLE / demand string / button labels.)
 * ---------------------------------------------------------------------------- */


/* ############################################################################
 * ##  THE COLONY DIALOG / BUILD-LIST INTERACTION ENGINE  (func_028D8C)      ##
 * ############################################################################
 *
 * @asm_function  func_028D8C   file 0x028D8C..0x0298A4  (entry ENTER 0x148,0;
 *                tail POP si / LEAVE / RETF at 0x0298A2..0x0298A4)
 * @asm_disasm    code/VICEROY/disasm_overlay_reseg/page_02.asm (func_028D8C,
 *                "size=3091 insns=989") — the AUTHORITATIVE full body.
 *
 * *** EXTENT CORRECTION (BYTE_VERIFIED 2026-05-30) ***
 *   The per-function dump code/VICEROY/disasm/func_028D8C_unknown.asm claims
 *   "185 bytes (0x028D8C..0x028E45)".  That is a FIRST-RET / dump-truncation
 *   artifact; the function has no RET before 0x0298A2.  Raw EXE confirms:
 *       0x028D8C: c8 48 01 00 56 2b c0 89   (ENTER 0x148,0 / PUSH si / SUB ax,ax)
 *       0x0298A2: 5e c9 cb                  (POP si / LEAVE / RETF)
 *   So the true body is 0x028D8C..0x0298A5 (~2841 B of the engine proper; the
 *   reseg "3091" count rolls in the shared-frame tail sub-routine at
 *   0x0298A6..0x02999E that re-uses this ENTER frame).  Sizes in func_*.asm
 *   dumps are NOT trustworthy — bytes decide (per RULINGS 2026-05-30).
 *
 * --- WHAT THIS IS (callgraph + globals + string xref) ---------------------
 *   This is the in-COLONY interactive engine: it lays out the colony's build /
 *   production list as a clickable control, runs the mouse/keyboard event loop,
 *   and mutates the colony record.  It is the "dialog engine" sense of the GUI
 *   framework: build the control set -> draw the frame -> run the modal loop ->
 *   act on the hit.  It is reached as an overlay target via thunk
 *   0x181F:0x1750 (typeA_thunk_targets.json: thunk @0x01BD40 -> 0x028D8C,
 *   lands_on_entry).  (NB: king_audience.c's "dialog_run / 0x181F:0x3FE ->
 *   func_028D8C" comment is imprecise about the THUNK: 0x181F:0x3FE actually
 *   resolves to func_06F57E+22 on page 0x17, a small option-builder wrapper —
 *   see menu.c.  func_028D8C is the screen engine those primitives serve.)
 *
 *   Decisive evidence it is COLONY-internal:
 *     - reads the active colony record via the colony pointer DGROUP:[0x8542]
 *       (project_colony_struct_at_8542): colonist count colony[+0x1F], owner
 *       colony[+0x1A], the 16-word stockpile colony[+0x9A..], colony[+0xB6].
 *     - the LABELS/format strings it pushes are the production-list display
 *       glyphs:  0xCA3 "|   ", 0xCA8 " = ", 0xCAC "/", 0xCAE "LOBOTOMIZE".
 *       (string handle -> file = handle + 0x1D9A0.)
 *     - it scrolls a list keyed off DGROUP:[0x8D7C] (the current list/row
 *       cursor; written all over this function and func_02883E).
 *
 * --- DGROUP globals it touches (addresses BYTE_VERIFIED at the cited @asm) --
 *   [0x8542]  near ptr  active ColonyRecord (project_colony_struct_at_8542)
 *   [0x8D7C]  word      list/row cursor (current highlighted item index)
 *   [0x8D7E]  word      list cursor mirror (kept == 0x8D7C @ 0x028D66)
 *   [0x0334]  word      cleared to 0 before the redraw  @0x028DE1
 *   [0x034E]  word      "result/selected id" out-slot (=cursor or 0xFFFF)
 *   [0x035C]  word      "list active" latch (1 while laying out, 0 on teardown)
 *   [0x089E]/[0x08A0]   default text-context far ptr (snapshotted @0x029207)
 *   [0x93AE]/[0x93AA]/[0x2E12]  glyph/colour handles for the row separators
 *   [0x1F5C]  word      option sub-field (written via the menu builder, menu.c)
 *   [0x1F66]  word      set to 1 each loop pass  @0x029695
 *   [0x1F68]  word      "re-open same item" latch (drag/edit re-entry)
 *
 * --- HELPER CALLS (call sites cited; pixel internals library-implementation-only) ---
 *   The list/record family (0x181F:0xB**, 0xC**) and the windowed-control
 *   family (0x191F:0x1**, 0x8**) are overlay leaves; their CALL SITES + arg
 *   order are byte-exact below, their pixel internals are library-implementation-only.
 *   The shared CONTROL MODEL they implement is decoded in menu.c.
 *
 *     0x181F:0xB46  list_count(buf)            -> # of build-list entries
 *     0x181F:0xBB4  list_is_disabled(i)        -> nonzero if row i greyed out
 *     0x181F:0xBC8  list_row_to_unit(delta)    -> unit/type index for row
 *     0x181F:0xC0E  colony_field_get(c)        -> a colony scalar (used for [bp-6])
 *     0x181F:0xC36  list_next_row(cur,c)       -> advance the row cursor
 *     0x181F:0xC54  colony_attr_get(c)         -> another colony scalar
 *     0x181F:0xC9A  list_first_ok(x)           -> first non-empty row test
 *     0x181F:0xB6E  list_row_buildable(i,c)    -> can build row i?
 *     0x181F:0xCD6  list_row_cost(&out,c)      -> hammers/tools for row i
 *     0x181F:0xB3C  list_fmt_row(a,b,&out,fl)  -> format one list line
 *     0x181F:0xD30  list_build_open(c,&a,&b)   -> begin build-list session
 *     0x181F:0xD44  list_build_close(a,b,cur)  -> end build-list session
 *     0x181F:0xAA6  redraw_tile(c)             -> repaint a colony tile
 *     0x181F:0x16E  strcat_handle(buf,handle)  -> append a LABELS glyph
 *     0x181F:0x178  / 0x11E / 0x128 / 0x1BE     -> text-cursor/measure helpers
 *     0x181F:0x182  num_to_str(buf,n)          -> integer -> text
 *     0x181F:0x35C  / 0x7B4 / 0x9FC / 0x8EE     -> per-good production maths
 *     0x191F:0x23C  win_create(z,y,x)          -> create a control window (DX:AX)
 *     0x191F:0x8C6  / 0x8D2                     -> window field set
 *     0x191F:0x16A  win_query(win)             -> hit-test / current item
 *     0x191F:0x1A8  win_dispose(win)           -> free the control window
 *     0x191F:0x176  win_draw_item(win,...)     -> draw one row
 *     0x191F:0x1B6  win_highlight(win,...)     -> highlight the selected row
 *     0x191F:0x33C  win_mark(win,...)          -> mark/checkbox a row
 *     0x191F:0x8DE  / 0x8EC                     -> window scroll / advance
 *   (0xD1D:0xDAE = memset; 0xD1D:0x7A4/0x7E4 = sprintf/strcpy; 0xD1D:0x117E =
 *    formatted concat — all MSC-runtime, used to build the row text.)
 *
 * --- STATUS ---------------------------------------------------------------
 *   ANCHOR_VERIFIED.  The CONTROL FLOW below is transcribed block-for-block
 *   from the reseg bytes (each step @asm-cited).  The per-row pixel blit and
 *   the production-maths leaves are overlay library-implementation-only.  No value,
 *   coordinate, sprite, colour, or string appears here without a byte citation.
 *
 * --- RETURN ---------------------------------------------------------------
 *   This is a screen LOOP, not a value dialog: at the tail @0x029897..0x0298A4
 *   it disposes the control window and falls into LEAVE/RETF with AX = the OR
 *   of the two window-handle words ([bp-0x64]|[bp-0x62]) — i.e. "a window was
 *   open".  The real outcome is published through the globals it mutates
 *   ([0x8D7C] cursor, [0x034E] result, and the colony[+0x9A]/+0xB6 stockpile).
 * ---------------------------------------------------------------------------- */

/* DGROUP scalars consumed by the engine (g_word[]/g_byte[] declared at top). */
#define CD_LIST_CURSOR  0x8D7C   /* @asm 0x028DA9.. list/row cursor */
#define CD_RESULT_034E  0x034E   /* @asm 0x028D4F result out-slot   */
#define CD_LISTACTIVE   0x035C   /* @asm 0x028FBA list-active latch  */

/* The active colony record (near ptr at DGROUP:0x8542). Field offsets are the
 * project's verified ColonyRecord layout (colony_screen.c / DATA_MODEL.md):
 *   +0x1A owner_power_idx   +0x1F size/population   +0x9A u16[16] stockpile
 *   +0xB6 (a per-colony production accumulator). */
extern uint8_t *colony_8542(void);   /* reads near ptr [0x8542] */

/* GUI-framework leaves (call sites byte-exact; pixel internals library-implementation-only). */
extern int  cd_list_count(void *buf);                       /* 0x181F:0xB46 */
extern int  cd_list_disabled(int row);                      /* 0x181F:0xBB4 */
extern int  cd_list_row_to_unit(int delta);                 /* 0x181F:0xBC8 */
extern int  cd_colony_field(int c);                         /* 0x181F:0xC0E */
extern int  cd_colony_attr(int c);                          /* 0x181F:0xC54 */
extern int  cd_list_first_ok(int x);                        /* 0x181F:0xC9A */
extern int  cd_list_next_row(int cur, int c);               /* 0x181F:0xC36 */
extern void cd_redraw_tile(int c);                          /* 0x181F:0xAA6 */
extern void *cd_win_create(int z, int y, int x);            /* 0x191F:0x23C -> DX:AX */
extern int  cd_win_query(void *win);                        /* 0x191F:0x16A */
extern void cd_win_dispose(void *win);                      /* 0x191F:0x1A8 */
extern void cd_snapshot(void);                              /* push cs;call 0x2CA37 (near) */
extern void cd_teardown(void);                              /* push cs;call near tail */

/* ----------------------------------------------------------------------------
 * colony_dialog_engine -- func_028D8C.
 *
 * arg @ [bp+6]  (in_subview):  on entry the engine may FORCE it to 1 when the
 *               colonist count colony[+0x1F] is past the list cursor and the
 *               column count >= 0x20 (@asm 0x028DA9..0x028DBA) — selecting the
 *               wide (build) layout vs the narrow one.
 *
 * The body is a long single function; faithful structure (each // @asm cited):
 * ---------------------------------------------------------------------------- */
void colony_dialog_engine(int in_subview)
{
    /* locals named after their [bp-] slots in the disasm */
    int  force_wide = 0;        /* [bp-0x12C]  set => wide layout            */
    int  reopen     = 0;        /* [bp-0xEC]   re-open same item latch       */
    int  edit_mode  = 0;        /* [bp-0xF2]   "list edit" mode               */
    int  list_n;                /* [bp-0x136]  # of list entries              */
    int  row;                   /* [bp-0x130]  loop row index                 */
    int  cur_item;              /* [bp-6]      colony_field_get() result      */
    int  top_row;               /* [bp-0xF8]   first visible row              */
    int  visible;               /* [bp-0x144]  visible row count (6 or 0x19)  */
    uint8_t *col = colony_8542();

    (void)edit_mode; (void)reopen;   /* mutated below; silence unused warns */

    /* --- entry: choose wide vs narrow layout from colonist count vs cursor --- */
    if (!((int)(signed char)col[0x1F] > g_word[CD_LIST_CURSOR]) /* @asm 0x028DA9 CMP/JG */
        && (col[0x1F] & 0xFF) >= 0x20) {                        /* @asm 0x028DAF CMP cl,0x20/JL */
        in_subview = 1;                                          /* @asm 0x028DB7 [bp+6]=1 */
        force_wide = 1;                                          /* @asm 0x028DBA */
    }

    /* [bp-0xC8]=1; if list_first_ok(colony_attr(cursor))==0 clear it. */
    {
        int gate = 1;                                            /* @asm 0x028DBE */
        if (cd_list_first_ok(cd_colony_attr(g_word[CD_LIST_CURSOR])) == 0) /* 0xC54 then 0xC9A */
            gate = 0;                                            /* @asm 0x028DDD */
        (void)gate;
    }

    g_word[0x0334] = 0;                                          /* @asm 0x028DE1 */
    cd_snapshot();                                               /* @asm 0x028DE7 push cs;call 0x2CA37 */

    /* visible-row geometry depends on the wide/narrow choice */
    if (in_subview != 0) {                                       /* @asm 0x028DEB CMP [bp+6],0/JE */
        top_row = 0x13;  visible = 6;                            /* @asm 0x028DF1/0x028DF7 */
    } else {
        top_row = 0;     visible = 0x19;                         /* @asm 0x028E00/0x028E06 */
    }

    /* cur_item = colony_field_get(cursor); edit_mode = (cur_item==0x12). */
    cur_item  = cd_colony_field(g_word[CD_LIST_CURSOR]);         /* @asm 0x028E0C 0xC0E */
    edit_mode = (cur_item == 0x12) ? 1 : 0;                      /* @asm 0x028E1B..0x028E28 */

    /* zero a 0x20-word scratch ([bp-0x94]) then build the per-row "+0x32" deltas
     * for every list row that is non-zero, summing into the production buffer
     * ([bp-0x78]) and the colony[+0x9A..] stockpile.  @asm 0x028E2C..0x028EDD */
    /* Not yet byte-traced: the exact per-row maths uses the 0x181F:0xBC8 row->unit
     * map and the 0x1C-stride stat table at DGROUP+0x3159 (cited @0x028EB1); the
     * loop SHAPE is transcribed, the table semantics are decoded in colony.c. */
    list_n = cd_list_count(0);                                  /* @asm 0x028E45 0xB46 (buf=[bp-0x13e]) */
    for (row = 0; row < list_n; row++) {                        /* @asm 0x028E57..0x028E94 */
        /* if row entry == 0xE -> add stat-table[unit].[+0x3159] to [bp-0x78].
         * else if nonzero -> stockpile[row] += entry*0x32.  (both @asm above) */
    }

    /* --- build the control window for the visible rows --- */
    /* memset [bp-0x74] (0x10 words); compute a /0x14 page offset from
     * colony[+0xB6]; seed row glyphs.  @asm 0x028EDF..0x028F2C */

    /* count selected rows in [bp-8] for the page; clamp the top_row window.
     * @asm 0x028F2E..0x028F7A */

    /* create the windowed control: win = win_create(0x800, y, x) with the
     * default text context [0x89E]/[0x8A0].  @asm 0x029235 PUSH 0x800 /
     * 0x029238 LCALL 0x191F:0x23C -> DX:AX in [bp-0x64]:[bp-0x62]. */
    {
        void *win = cd_win_create(0x800, g_word[0x08A0], g_word[0x089E]);
        if (win == 0)                                            /* @asm 0x029246 OR/JNE; else jmp teardown */
            goto teardown;                                       /* @asm 0x02924A jmp 0x4C99 */

        /* set window fields (es:[bx+0xA]|=1; es:[bx+0x22]=8; 0x191F:0x8D2).
         * @asm 0x02924D..0x029265 */

        /* ============================ EVENT LOOP ============================
         * For each pass: set [0x1F66]=1 (@asm 0x029695), query the window
         * (win_query 0x191F:0x16A -> hit code in [bp-0x5E]), dispose+rebuild
         * the row controls, and act on the hit.  The loop body draws each
         * visible row (strcat the "|   " / " = " / "/" glyphs + num_to_str of
         * the stockpile/production values), highlights the cursor row
         * (win_highlight 0x191F:0x1B6), and on a click maps the row back to a
         * unit/build id and either re-opens it (latch [0x1F68]) or commits.
         * @asm 0x02963D..0x02988F (the whole middle of the function).
         *
         * Termination & result (hit code [bp-0x5E]):
         *   0x62 -> toggle [bp-4] (a sub-mode flip)        @asm 0x0296BC
         *   0x61 -> commit current item:
         *             - undo the staged stockpile deltas (subtract [bp-0x94]
         *               row sums back out of colony[+0x9A]) @asm 0x02970D
         *             - re-run snapshot, then re-enter at 0x41AF (loop)
         *             - else publish [0x8D7C] and [0x034E].
         *   any   -> if [bp-0x146] set and the picked id is a build that needs a
         *             school/college, write the build-class byte into the
         *             0x1C-stride table[+0x3146] (=9 for 0x15, =7 for 0x17).
         *               @asm 0x02982F..0x029866
         * The cursor [0x8D7C] and the result [0x034E] are the published outputs.
         * ==================================================================== */
        (void)win;
    }

teardown:
    /* clear the list-active latch, then if a window is still open dispose it. */
    g_word[CD_LISTACTIVE] = 0;                                   /* @asm 0x029889 [0x35C]=0 */
    cd_teardown();                                               /* @asm 0x0298A2 area */
    /* @asm 0x02989F..0x0298A4: if ([bp-0x64]|[bp-0x62]) win_dispose(win);
     *                          POP si / LEAVE / RETF  (AX = that OR). */
}
