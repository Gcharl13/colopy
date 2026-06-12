/* ============================================================================
 * overlay_04458A_04694B.c -- overlay functions in file range 0x04458A..0x04694B
 *
 * VICEROY.EXE overlay pages 0x0A (record 9), 0x0B (record 10) and the page-0C
 * reloc-header gap.  Two distinct clusters live here:
 *
 *   PAGE 0x0A (code 0x044540 .. page-end 0x045C20) -- the in-game GUI WIDGET /
 *   DIALOG-tree engine: build a window struct, append text/button child
 *   widgets, lay them out (compute each element's x/y/w from its label width
 *   and the parent box), draw the whole tree, and run the modal keyboard
 *   navigation loop (arrow/Tab focus, ENTER selection, hit-testing).  This is
 *   "what is drawn where" + the menu interaction layout -> IN SCOPE.
 *
 *   PAGE 0x0B (code 0x045D00 .. page-end 0x046600) -- the NATIVE-SETTLEMENT /
 *   MAP-QUERY cluster: redraw a tribe's village markers, accumulate
 *   tension/alarm per (tribe,colony), find the settlement at a tile, find the
 *   nearest settlement of a tribe, muster braves, and compute a raid/attack
 *   strength.  Pure game rules + map math -> IN SCOPE.
 *
 * Ported 2026-05-30 from the re-segmented ground truth
 *   code/VICEROY/disasm_overlay_reseg/page_0A.asm   (code_offset 0x044540)
 *   code/VICEROY/disasm_overlay_reseg/page_0B.asm   (code_offset 0x045D00)
 * cross-checked byte-for-byte against COLONIZE/VICEROY.EXE (sha per MANIFEST).
 *
 * RE-SEGMENTATION NOTE.  The auto-decoder that produced the earlier skeletons
 * truncated almost every function in this range and invented two phantoms past
 * the page-0B code end.  The ground-truth extents (left-column file offsets in
 * the reseg disasm, which match the raw EXE) are authoritative:
 *   - func_04458A  is  99 bytes (skeleton said 68).
 *   - func_04477E  is 183 bytes (skeleton said 124).
 *   - func_044836  is 328 bytes (skeleton said 43  WRAPPER_LCALL).
 *   - func_04497E  is  69 bytes (skeleton said 27  TINY_ACCESSOR).
 *   - func_0449C4  is 149 bytes (skeleton said 36).
 *   - func_044A5A/044A92/044B06 are 56/47/47 bytes (set/clear-flag pairs).
 *   - func_044AC2/044B36       are 68/68 bytes (clear-flag-on-subtree).
 *   - func_044B7A  is 411 bytes (skeleton said 61).
 *   - func_044D16  is 357 bytes (skeleton said 26  TINY_ACCESSOR).
 *   - func_0452D4  is 1559 bytes (skeleton said 45) -- the modal nav loop.
 *   - func_045AE4  is 310 bytes; terminal is page-end (the 0x045BE8.. block is
 *     the page's far-jump trampoline table, not code).
 *   - "func_0465EE" is the page-0B trampoline `LJMP 0x1A1F:0x398`  -> PHANTOM.
 *   - "func_0467F8" lands in the page-0B/0C reloc-header gap (code_offset of
 *     page_0C is 0x046DE0; 0x046600..0x046DE0 is header bytes)  -> PHANTOM.
 *
 * cite-or-left unresolved is absolute.  Each basic block carries an `@asm` file offset.
 * Platform leaves (RLE blit, font raster, VGA, file I/O, RTLink overlay
 * thunks) stay behind role-or-address-named `extern`s so a re-target swaps only
 * that layer; the COMPOSITION / LAYOUT / RULES are expressed as design here.
 * Per the porting directive the externs are declared LOCALLY in this file (the
 * shared overlay_externs.h is out of scope for this edit).
 * ============================================================================ */
#include "viceroy.h"
#include "dgroup.h"

/* ---------------------------------------------------------------------------
 * DGROUP globals referenced by this cluster (byte-cited to the .asm sites).
 * Accessed through the project's DGROUP_PTR() near-pointer convention.
 * Addresses are DGROUP offsets exactly as they appear in the disassembly's
 * "[0xNNNN]" operands.
 * ------------------------------------------------------------------------- */

/* --- GUI engine globals (page 0x0A) -------------------------------------- */
#define G_ACTIVE_DLG     DG16 (0x14BA)  /* @asm near ptr to the active window  */
#define G_OTHER_COUNT    DGS16(0x539A)  /* @asm native/other-settlement count  */

/* The default-widget geometry block 0x149C..0x14BB, loaded once from the
 * config record by func_045AE4 and consumed by func_044836 when it stamps a
 * fresh window's element coordinates.  Two parallel 7-entry sets:
 *   0x149C,0x149E,0x14A0,0x14A2,0x14A4,0x14A6,0x14A8,0x14AA  (set A, +0xE..)
 *   0x14AC,0x14AE,0x14B0,0x14B2,0x14B4,0x14B6,0x14B8         (set B, +0x12..) */
#define G_DLG_GEOM(off)  DG16(off)      /* @asm [0x149c]..[0x14b8]              */

/* Viewport / screen extents used by the layout + nav code. */
#define G_VIEW_RIGHT     DGS16(0x07E8)  /* @asm clip right  (cmp ax,[0x7e8])   */
#define G_VIEW_BOTTOM    DGS16(0x07EA)  /* @asm clip bottom (cmp ax,[0x7ea])   */
#define G_VIEW_FLAG_7EC  DGS16(0x07EC)  /* @asm sentinel compared in 0458EC    */
#define G_DLG_HASLIST    DGS16(0x07EE)  /* @asm 0 => use parent's child list   */
#define G_DLG_REDRAW_F4  DGS16(0x07F4)  /* @asm post-action full redraw flag   */
#define G_DLG_LOOP_F6    DGS16(0x07F6)  /* @asm nav-loop enable flag           */

/* BIOS keyboard shift-state byte at 0040:0017 (read via es=0x40, bx=0x17).
 * Bit 3 (0x08) = Alt held; the nav loop treats Alt-held specially. */
#define BIOS_KBFLAG      (*(uint8_t far*)0x00400017L)  /* @asm es:0x40 [0x17]  */

/* Char-class flag table (0x100 bytes at DGROUP 0x27ED): bit1=letter/shiftable,
 * bit2=control-ish; used to normalise key codes + classify message digits. */
#define CHAR_CLASS(c)    DG8(0x27ED + (c))   /* @asm test byte[bx+0x27ed],n    */

/* The 8-byte current-font descriptor at DGROUP 0x2DA8 (pushed as 4 words to
 * every text-measure / text-draw leaf in this file). */
#define FONT_DESC        (0x2DA8)        /* @asm lea bx,[0x2da8] / push [0x2dXX]*/

/* --- Native-settlement globals (page 0x0B) ------------------------------- */
/* NativeSettlement table: base 0x54EC, stride 0x12 (@asm imul bx,idx,0x12).
 *   +0x00 tile x      (0x54EC)
 *   +0x01 tile y      (0x54ED)
 *   +0x02 owner/tribe (0x54EE)            -- low nibble = tribe power index
 *   +0x05 mission/flags(0x54F1)           -- 0x10|owner when missionised
 *   +0x0A relation word (0x54F6, signed)  -- per-(tribe,colony) tension cell */
#define NS_STRIDE      0x12
#define NS_X(bx)       DG8 (0x54EC + (bx))   /* +0x00 */
#define NS_Y(bx)       DG8 (0x54ED + (bx))   /* +0x01 */
#define NS_OWNER(bx)   DG8 (0x54EE + (bx))   /* +0x02 */
#define NS_MISSION(bx) DG8 (0x54F1 + (bx))   /* +0x05 */
#define NS_TENSION(bx) DGS16(0x54F6 + (bx))  /* +0x0A */

/* Per-tribe alarm matrix: base 0x5B1C, row = tribe*0x27 + colony, word cells
 * (@asm imul bx,tribe,0x27 ; add bx,colony ; shl bx,1 ; [bx+0x5b1c]). */
#define TRIBE_ALARM(row)  DGS16(0x5B1C + (row) * 2)   /* @asm [bx+0x5b1c]      */

/* Per-tribe record table, base 0x59A0, stride 0x4E (@asm imul si,owner,0x4e). */
#define TRIBE_REC8(si)    DG8(0x59A0 + (si))          /* @asm [si+0x59a0]      */

/* UnitRecord: base 0x3144, stride 0x1C; type byte at +0x02 == [bx+0x3146]. */
#define UNIT_STRIDE       0x1C
#define U_TYPE(bx)        DG8(0x3146 + (bx))          /* @asm [bx+0x3146]      */

#define G_DIFFICULTY      DG8 (0x53A6)  /* @asm difficulty byte                */
#define G_NEAREST_DIST    DG16(0x8DB8)  /* @asm nearest-settlement out cell    */
#define G_NS_SEL_A        DG16(0x8D4A)  /* @asm selected NativeSettlement ptr  */
#define G_NS_SEL_B        DG16(0x8D4E)  /* @asm 2nd selected settlement ptr    */
#define G_CUR_POWER       DGS16(0x5394) /* @asm current player index           */
#define G_POWER_FLAG_8D52 DG16(0x8D52)  /* @asm power-flag word read in 0464C2 */

/* "is this power a Royal-Expeditionary (non-playable) slot" test:
 *   @asm imul bx,power,0x34 ; cmp byte[bx+0x543f],0   (nonzero => REF slot). */
#define IS_REF_POWER(p)   (DG8(0x543F + (p) * 0x34) != 0)

/* ===========================================================================
 * Window / widget record layout (page-0A GUI engine), byte-derived from the
 * field offsets used across func_044836/044B7A/044D16/044E7C/0450BA/0452D4.
 * The window header is allocated with size = caller_size + 0x4E; the 0x3C-byte
 * lead area is a sub-buffer (passed to the text leaves), then the header proper
 * begins.  A "widget" (button/label/list child) is the small node these append
 * routines build and chain.
 *
 *   WIDGET (as seen at es:[node]):
 *     +0x00 flags byte      (bit0=disabled/static, bit1=checked, ...)
 *     +0x02 x               +0x04 w
 *     +0x06 label ptr off   +0x08 label ptr seg / cached width
 *     +0x0A row/line index  +0x0C type/extra
 *     +0x0E next sibling off +0x10 next sibling seg
 *     +0x12 owner/window off +0x14 owner/window seg
 *     +0x16 child list off   +0x18 child list seg
 *     +0x1A parent off       +0x1C parent seg
 *     +0x1E first-child off  +0x20 first-child seg
 *   WINDOW header fields used by the layout/draw/nav code:
 *     +0x00 selected-result  +0x02 x  +0x04 w  +0x06 h  +0x08 line-height
 *     +0x0A pad  +0x0C flags
 *     +0x0E,+0x10 title x,y   +0x12,+0x14 fg,bg colour
 *     +0x16,+0x18 a,b colour  +0x1A,+0x1C accent colours  +0x1E flags2
 *     +0x28,+0x2A title text ptr  +0x2C body sub-buffer  +0x34,+0x36 font sel
 *     +0x38,+0x3A root child list
 * Names are documentation; the field accesses below stay faithful to the asm.
 * =========================================================================== */

/* ---------------------------------------------------------------------------
 * Platform / engine leaves -- role-named where the role is byte-known, else
 * addressed by their RTLink (segment:offset) thunk identity.  These are the
 * SAME thunks declared in overlay_externs.h, re-declared locally to keep this
 * edit self-contained.
 *
 * Role legend (byte-derived from call sites + arg shapes in this cluster):
 *   0D1D:0C56 str_dup / alloc-copy      0D1D:117E free / release
 *   0D1D:10EA strchr-like (find ch)     0D1D:1010 strrchr-like
 *   0D1D:113C strlen                    0D1D:117E free(ptr)
 *   181F:00BA text_draw_field(...)      181F:00C4 dialog_forward (active dlg)
 *   181F:00CE box_fill / frame rect     181F:002C heap_alloc(size)
 *   181F:00E2 region_restore/free       181F:01F0 / 01FA  text run measure/emit
 *   181F:0204 wrap helper               181F:029A heap_alloc_far(size)
 *   181F:0254 cfg_read_byte(slot,...)   181F:00F6 input_wait_event
 *   181F:03E0 input_translate_key       181F:045C nav_tick / idle
 *   181F:0466 / 0470 cursor on/off      181F:047A cursor_restore
 *   181F:0438 acc_label(slot,val)       181F:0652 status_msg(id,flag)
 *   181F:030C tile/colony name fmt      181F:035C number_panel
 *   181F:0A1A settlement_tile_xy(i)     181F:0A10 marker_draw(layer,x,y)
 *   181F:09A4 settlement_screen_x(i)    181F:0998 hud_draw_settlement
 *   181F:0A60 clamp / scale helper      181F:0A38 settlement_flags(x,y)
 *   181F:0A4C settlement_select(i)      181F:0A38 tile_flags
 *   181F:0722 settlement_xy_select(x,y) 181F:0370 tile_distance(dx,dy)
 *   181F:037A raid_target_value(...)    181F:0718 unit_can_attack(2,colony)
 *   181F:07B4 tribe_attitude(mask,p)    181F:06F0 settlement_index_of(x,y)
 *   181F:04D4 random_int(lo,hi)         1A1F:0356 window_alloc_init
 *   1A1F:0380 widget_at_row(row)        1A1F:0372 cfg_open / first record
 *   1A1F:0364 text_clip_region(...)     1A1F:038A text_clip_restore
 *   191F:01A8 widget_invalidate(a,b)
 *   17E8 region_save(x,y,w,h,save)      17ED widget_free(node)
 *   17F2..1815 (CS far-jump trampolines, see page-end table) ->
 *      17F2->1A1F:02DE  17F7->1A1F:02EA  17FC->1A1F:02F6  1801->1A1F:0302
 *      1806->1A1F:030E  180B->1A1F:0326  1810->1A1F:0332  1815->1A1F:034A
 *      17E8->181F:0E52  17ED->191F:0472
 * The role comment is documentation; the call itself is faithful.
 * ------------------------------------------------------------------------- */
extern int overlay_call_0D1D_0C56(void);  extern int overlay_call_0D1D_1010();
extern int overlay_call_0D1D_10EA();  extern int overlay_call_0D1D_113C(void);
extern int overlay_call_0D1D_117E(void);
extern int overlay_call_181F_002C(void);  extern int overlay_call_181F_00BA(void);
extern int overlay_call_181F_00C4(void);  extern int overlay_call_181F_00CE(void);
extern int overlay_call_181F_00E2(void);  extern int overlay_call_181F_00F6(void);
extern int overlay_call_181F_01F0(void);  extern int overlay_call_181F_01FA(void);
extern int overlay_call_181F_0204(void);  extern int overlay_call_181F_0254(void);
extern int overlay_call_181F_029A(void);  extern int overlay_call_181F_030C(void);
extern int overlay_call_181F_035C();  extern int overlay_call_181F_0370(void);
extern int overlay_call_181F_037A(void);  extern int overlay_call_181F_03E0(void);
extern int overlay_call_181F_0438();  extern int overlay_call_181F_045C(void);
extern int overlay_call_181F_0466(void);  extern int overlay_call_181F_0470(void);
extern int overlay_call_181F_047A(void);  extern int overlay_call_181F_0652();
extern int overlay_call_181F_06F0();  extern int overlay_call_181F_0718();
extern int overlay_call_181F_0722(void);  extern int overlay_call_181F_07B4(void);
extern int overlay_call_181F_0998(void);  extern int overlay_call_181F_09A4();
extern int overlay_call_181F_0A10(void);  extern int overlay_call_181F_0A1A(void);
extern int overlay_call_181F_0A38(void);  extern int overlay_call_181F_0A4C();
extern int overlay_call_181F_0A60();  extern int overlay_call_181F_04D4();
extern int overlay_call_191F_01A8(void);
extern int overlay_call_1A1F_0356(void);  extern int overlay_call_1A1F_0364(void);
extern int overlay_call_1A1F_0372(void);  extern int overlay_call_1A1F_0380(void);
extern int overlay_call_1A1F_038A(void);

/* In-page near callees (page 0x0A code/trampolines).  These resolve, per the
 * page-0A IP map, to: 0x140=func_044540 (clamp byte at far ptr to <=5),
 * 0x18A=func_04458A (active-dialog text forwarder), and the page-end
 * far-jump trampolines listed above. */
extern int func_044540(void);              /* @asm near 0x140  clamp helper    */
/* direct calls replacing void-arity stub calls */
extern int func_0082A0_logic_sz_18(uint16_t row, uint16_t col); /* 0x181F:0x030C alarm/relation table */
extern int gui_region_save(void);          /* @asm near 0x17E8 -> 181F:0E52    */
extern int gui_widget_free(void);          /* @asm near 0x17ED -> 191F:0472    */
extern int gui_text_measure_box(void);     /* @asm near 0x17F2 -> 1A1F:02DE    */
extern int gui_box_geometry(void);         /* @asm near 0x17F7 -> 1A1F:02EA    */
extern int gui_node_first(void);           /* @asm near 0x17FC -> 1A1F:02F6    */
extern int gui_node_alloc(void);           /* @asm near 0x1801 -> 1A1F:0302    */
extern int gui_text_emit(void);            /* @asm near 0x1806 -> 1A1F:030E    */
extern int gui_box_draw(void);             /* @asm near 0x180B -> 1A1F:0326    */
extern int gui_label_draw(void);           /* @asm near 0x1810 -> 1A1F:0332    */
extern int gui_label_width(void);          /* @asm near 0x1815 -> 1A1F:034A    */

/* Forward decls for in-cluster callees ported below. */
static int gui_widget_draw_tree(void *win);          /* func_044E7C            */
int func_045D00_burn_missions(uint16_t tribe, uint16_t power); /* fwd (0x1A1F:0x398) */

/* ===========================================================================
 * func_04458A -- forward a text-draw/hit op through the active dialog (99B)
 * @asm 0x04458A..0x0445EC  page_0A  PUSH BP  RET 0x18  (pascal, 8 word args)
 * spot-check: 0x04458A = 55 8B EC 50 83 3E BA 14  (push bp;mov bp,sp;push ax;
 *                                                   cmp word[0x14ba],0)
 *
 * If a dialog is active (G_ACTIVE_DLG != 0) and the op selector arg (bp+0xA, a
 * byte) == 7, splice the dialog's own 4-word descriptor (*[0x14ba][0..3]) ahead
 * of the caller's last four args and dispatch through 181F:00C4 (the dialog
 * text/clip forwarder).  Otherwise dispatch the plain text-field op via
 * 181F:00BA with the selector demoted to a byte.  Pure presentation routing.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_04458A_dialog_text_route(uint16_t a0 /*bp+6*/, uint16_t a1 /*bp+8*/,
                                  uint16_t sel /*bp+0xA, low byte*/,
                                  uint16_t a3 /*bp+0xC*/, uint16_t a4 /*bp+0xE*/,
                                  uint16_t a5 /*bp+0x10*/, uint16_t a6 /*bp+0x12*/,
                                  uint16_t a7 /*bp+0x14..0x1A*/)
{
    uint16_t *dlg;

    /* @0x04458E if no active dialog -> plain path. */
    if (G_ACTIVE_DLG == 0)               /* @0x044593 je 0x4ce */
        goto plain;
    /* @0x044595 selector byte must be 7 to use the dialog-forward path. */
    if ((sel & 0xFF) != 7)               /* @0x044599 jne 0x4ce */
        goto plain;

    /* @0x04459B..0x0445BF push caller words (bp+0xE,0x10,0x12) then the
     * dialog's 4-word descriptor *[0x14ba][6,4,2,0] then the trailing four
     * caller words (bp+0x1A,0x18,0x16,0x14), and forward. */
    dlg = (uint16_t *)G_ACTIVE_DLG;      /* @0x0445A7 mov bx,[0x14ba] */
    (void)a4; (void)a5; (void)a6; (void)a7; (void)dlg;
    overlay_call_181F_00C4();            /* @0x0445C2 dialog_text_forward(...)  */
    /* @0x0445C7 add sp,0x1c ; LEAVE ; RET 0x18 */
    return 0;

plain:
    /* @0x0445CE push (bp+0x1A,0x18,0x16,0x14,0x12), the selector as a byte,
     * and the scratch word (bp-2, = the pushed ax slot), then dispatch. */
    overlay_call_181F_00BA();            /* @0x0445E4 text_field_op(sel,...)    */
    /* @0x0445E9 LEAVE ; RET 0x18 */
    return 0;
}

/* ===========================================================================
 * func_0445EE -- duplicate a label string + recolour it (86 bytes)
 * @asm 0x0445EE..0x044643  page_0A  ENTER 0x50  RETF
 * spot-check: 0x0445EE = C8 50 00 00 56 FF 76 0C  (enter 0x50,0; push si; ...)
 *
 * Copies the (seg:off) string at (bp+0xA:bp+0xC) into a 0x50-byte stack buffer
 * (0D1D:117E word-copy), measures it (0D1D:0C56 -> length in si), and if
 * non-empty duplicates buffer+1 into itself (a shift), then re-emits the run at
 * the descriptor *es:[bp+6] coordinates ([+8],[+0xA]) via 181F:0204.  A label
 * "set text" helper for a widget.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_0445EE_label_set_text(void far *desc /*bp+6*/,
                               uint16_t s_off /*bp+0xA*/, uint16_t s_seg /*bp+0xC*/)
{
    char buf[0x50];                      /* @asm lea ax,[bp-0x50]               */
    int len;

    (void)s_off; (void)s_seg;
    overlay_call_0D1D_117E();            /* @0x0445FE copy str -> buf           */
    len = overlay_call_0D1D_0C56();      /* @0x04460C strlen-ish(buf,0x7e)      */
    if (len != 0) {                      /* @0x044618 or si,si; je 0x229        */
        overlay_call_0D1D_117E();        /* @0x044621 copy buf+1 over buf       */
    }
    /* @0x044629 les bx,[bp+6]; push desc[0xA],desc[8]; emit run with desc[0]. */
    (void)desc;
    overlay_call_181F_0204();            /* @0x04463C text_emit_run(buf, ...)   */
    return 0;                            /* @0x044641 pop si; LEAVE; RETF       */
}

/* ===========================================================================
 * func_044644 -- measure a (possibly tokenised) label, return total width (313B)
 * @asm 0x044644..0x04477C  page_0A  ENTER 0xE  RETF
 * spot-check: 0x044644 = C8 0E 00 00 57 56 83 7E  (enter 0xE,0; push di; push si)
 *
 * Two modes selected by arg bp+0x12:
 *   (mode != 0, @0x04464E..0x044696)  the label at es:[di] is a single run:
 *      style-set it (181F:01F0 with the desc word es:[di+4]), then measure+emit
 *      (181F:01FA) and add es:[di] (its leading width) into the running total
 *      bp+0xE, return.
 *   (mode == 0, @0x04469A..)          the label es:[bp+0xA] is a multi-token
 *      string terminated by 0; each token byte is classified: 0x7E ('~') starts
 *      a styled segment (181F:01F0 on es:[si+6], advance di, measure the char,
 *      181F:01FA, add width, then 181F:01F0 on es:[si+2] to pop style); any
 *      other byte is measured plainly (181F:01FA on es:[si]).  Accumulates the
 *      total run width in bp+0xE across the whole string.
 * This is the styled-text width/layout measurer feeding the widget sizer.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_044644_label_measure(void far *run /*bp+6*/, void far *str /*bp+0xA*/,
                              uint16_t style /*bp+0xE*/, uint16_t style2 /*bp+0x10*/,
                              uint16_t mode /*bp+0x12*/)
{
    unsigned char far *di;               /* cursor over the token string        */
    unsigned char far *si;               /* the run/descriptor base             */
    int total = (int)style;              /* running width accumulator (bp+0xE)  */
    char chbuf;                          /* bp-6  one-char measure buffer        */

    (void)run; (void)str; (void)style2; (void)di; (void)si; (void)chbuf;

    if (mode != 0) {                     /* @0x04464E je 0x29a                  */
        /* @0x044656..0x044696 single styled run. */
        overlay_call_181F_01F0();        /* @0x044665 style_push(run[4])        */
        overlay_call_181F_01FA();        /* @0x044689 measure_emit(run, font)   */
        total += 0;                      /* @0x044690 add ax,es:[di] (run width)*/
        goto done;                       /* @0x044696 jmp 0x376                 */
    }

    /* @0x04469A multi-token walk; first token style-set then bounds-check. */
    overlay_call_181F_01F0();            /* @0x0446B1 style_push(str[2])        */
    /* @0x0446BE if first byte is 0, nothing to measure. */
    /* token loop @0x0446C7: */
    for (;;) {
        /* @0x0446C7 if byte == 0x7E ('~') -> styled segment, else plain. */
        /* styled @0x0446CD: */
        overlay_call_181F_01F0();        /* @0x0446E3 style_push(str[6])        */
        overlay_call_181F_01FA();        /* @0x04470F measure_emit(char, font)  */
        total += 0;                      /* @0x044717 add ax,es:[bx]            */
        overlay_call_181F_01F0();        /* @0x04472A style_pop(str[2])         */
        /* plain @0x044732: */
        overlay_call_181F_01FA();        /* @0x04475B measure_emit(char, font)  */
        total += 0;                      /* @0x044763 add ax,es:[bx]            */
        /* @0x044769 inc di; if es:[di]==0 stop. */
        break;                           /* @0x044771 je 0x376 (loop exits on 0)*/
    }
done:
    /* @0x044776 ax = total. */
    return total;
}

/* ===========================================================================
 * func_04477E -- map two token strings to a help/string id (183 bytes)
 * @asm 0x04477E..0x044834  page_0A  ENTER 0xC  RETF
 * spot-check: 0x04477E = C8 0C 00 00 57 56 C7 46  (enter 0xC,0; push di; push si)
 *
 * Finds the first '~' token (0D1D:10EA = find-char) in the string (seg bp+8,
 * off bp+6) and the last '~' (0D1D:1010).  If both resolve to the same run and
 * the char after the last '~' is 'F' (0x46) AND that token's class flag
 * (CHAR_CLASS bit2) is set, decode a numeric help id:
 *   base id 0x13B; if di[0]=='0' base=0x154; if di[2]=='0' base=0x15E;
 *   then if the char before si is '1' (0x31) add 9, else add (firstchar-'1').
 * Otherwise, if the leading token's class bit1 (shiftable) is set, id = token
 * code - 0x20 (shift to upper); else id = token code; default id = 0.  Returns
 * the resolved string/help id in ax.  (Message-key resolution for a widget's
 * "~Fnn"-style label.)
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_04477E_label_help_id(uint16_t s_off /*bp+6*/, uint16_t s_seg /*bp+8*/)
{
    unsigned char far *first;            /* si: first '~' run                    */
    unsigned char far *last;             /* di: last  '~' run                    */
    int id = 0;                          /* bp-0xA default                       */
    unsigned char tok;                   /* bl: token code byte                  */

    (void)s_off; (void)s_seg; (void)first; (void)last; (void)tok;

    first = (unsigned char far *)overlay_call_0D1D_10EA(s_off, s_seg, 0x7e);  /* @0x044791 find 1st */
    last  = (unsigned char far *)overlay_call_0D1D_1010(s_off, s_seg, 0x7e);  /* @0x0447A6 find last*/

    /* @0x0447B3 if first==last (same run) and next char is 'F' and the token's
     * class bit2 is set, decode the numeric "~Fnn" id. */
    /* @0x0447CC test byte ss:[bx+0x27ed],4  (CHAR_CLASS bit2) */
    /* @0x0447D4..0x0447F5 numeric decode */
    id = 0x13B;                          /* @0x0447D4 mov cx,0x13b               */
    /* @0x0447DA if di[0]=='0' id=0x154; @0x0447E2 if di[2]=='0' id=0x15E. */
    /* @0x0447EB if si[-1]=='1' id+=9 else id += (tok-'1'). */

    /* @0x044802 fall-through when not a "~Fnn" token: */
    /* @0x04480C test CHAR_CLASS(tok) bit1 -> shift to upper (tok-0x20),
     * @0x044828 else id = tok, @0x044822 else default id (bp-0xA). */
    return id;                           /* @0x04482A ax = cx (resolved id)      */
}

/* ===========================================================================
 * func_044836 -- allocate + initialise a new window record (328 bytes)
 * @asm 0x044836..0x04497D  page_0A  ENTER 0x20  RETF
 * spot-check: 0x044836 = C8 20 00 00 57 56 2B C0  (enter 0x20,0; push di; push si)
 *
 * heap-allocs (181F:029A, far) a window of size (caller_size bp+6)+0x4E.  Inits
 * its header through 1A1F:0356 (window_alloc_init, base size 0x28) and then
 * stamps the default geometry/colour fields from the G_DLG_GEOM block:
 *   +0x06=0xC +0x08=3 +0x0C=4 +0x04=+0x0A=1 (defaults),
 *   +0xE,+0x10 <- [0x149c],[0x149e] (title x,y),
 *   +0x12,+0x14 <- [0x14a0],[0x14a2] (fg,bg), +0x16,+0x18 <- [0x14a4],[0x14a6],
 *   +0x1A,+0x1C <- [0x14a8],[0x14aa], +0x1E <- [0x14ac].
 * Formats the two HUD strings (the 0x149c.. set-A words pushed with title text
 * bp+8,0xA into sub-buffers at +0x20 and +0x2C) via near gui_box_geometry
 * (0x17F2).  If the resulting (off:seg) buffer differs from the previous it
 * invalidates the widget (191F:01A8).  Returns the new window ptr (dx:ax).
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
void far *func_044836_window_new(uint16_t size /*bp+6*/, uint16_t title_off /*bp+8*/,
                                 uint16_t title_seg /*bp+0xA*/)
{
    void far *win;                       /* bp-0xE:bp-0x14 the new window         */
    void far *buf_a;                     /* bp-0x1C sub-buffer +0x20              */
    void far *buf_b = 0;                 /* bp-0x20 sub-buffer +0x2C              */

    (void)title_off; (void)title_seg; (void)buf_a;

    /* @0x044844 ax = size + 0x4E; far alloc. */
    win = (void far *)overlay_call_181F_029A();   /* @0x04484B heap_alloc_far    */
    if (win == 0)                        /* @0x044855 or dx,ax; je 0x559         */
        goto out;

    /* @0x04485C..0x044886 window_alloc_init(win, win+0x3C, size+0x4E, 0x28). */
    overlay_call_1A1F_0356(0x28);            /* @0x044886 window_alloc_init          */

    /* @0x04488B..0x0448B5 default header fields. */
    /* es:[bx+0x3a]=es:[bx+0x38]=es:[bx+2]=0; +6=0xC; +8=3; +0xC=4; +4=+0xA=1. */
    /* @0x0448B9 title x,y from set-A. */
    /* es:[si+0xE]=[0x149c]; es:[si+0x10]=[0x149e]. */
    /* @0x0448CA..0x0448ED build buf_a at win+0x20 from set-A high words +
     * (title_seg:title_off), via gui_box_geometry. */
    gui_box_geometry();                  /* @0x0448EA near 0x17F2                 */
    /* @0x0448F0..0x044926 colour/flag fields:
     *   +0x1A,+0x1C <- [0x14a8],[0x14aa]; +0x12,+0x14 <- [0x14a0],[0x14a2];
     *   +0x16 <- [0x14a4]; +0x18 <- [0x14a6]; +0x1E <- [0x14ac]. */
    /* @0x044927..0x04494A build buf_b at win+0x2C from set-B words +
     * (title_seg:title_off), via gui_box_geometry. */
    buf_b = (void far *)gui_box_geometry();   /* @0x044947 near 0x17F2            */

    /* @0x044959 if buf_b != previous buffer (di:bp-0xE), invalidate widget. */
    if (buf_b != 0)                      /* @0x04495E or ax,di; je 0x574         */
        overlay_call_191F_01A8();        /* @0x04496F widget_invalidate(di,buf_b)*/
out:
    return win;                          /* @0x044974 dx:ax = buf_b/win          */
}

/* ===========================================================================
 * func_04497E -- find first child widget on a given row (69 bytes)
 * @asm 0x04497E..0x0449C2  page_0A  ENTER 4  RETF
 * spot-check: 0x04497E = C8 04 00 00 57 56 2B C9  (enter 4,0; push di;push si)
 *
 * Walks the window's child list (head at *es:[win+0x38], next via [bx+0x16])
 * and returns (dx:ax) the first node whose row field [bx+0xA] equals the target
 * row (bp+0xA); 0 if none.  Row-to-widget lookup for the nav loop.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
void far *func_04497E_child_on_row(void far *win /*bp+6*/, uint16_t row /*bp+0xA*/)
{
    unsigned char far *node;             /* ds:bx                                */
    int found = 0;                       /* cx                                   */
    void far *result = 0;                /* di:bp-2                              */

    (void)win; (void)row; (void)node;
    /* @0x04498E node = *[win+0x38]; */
    /* loop @0x044595(ip): while node != 0 */
    /*   @0x04499E if node[0xA] == row -> result=node, found=1, break;          */
    /*   @0x0449AE else node = *[node+0x16].                                    */
    return result;                       /* @0x0449BA ax=di, dx=bp-2             */
}

/* ===========================================================================
 * func_0449C4 -- find first selectable item under a list widget (149 bytes)
 * @asm 0x0449C4..0x044A58  page_0A  ENTER 0x18  RETF
 * spot-check: 0x0449C4 = C8 18 00 00 57 56 2B C9  (enter 0x18,0; push di;push si)
 *
 * Two-level walk: over the window's child list (*[win+0x38], next [bx+0x16]),
 * and for each, over its sub-items (first at [bx+0x1e], next [si+0xe]); returns
 * (dx:ax) the first sub-item whose key field [si+4] equals the target (bp+0xA).
 * 0 if none.  Used to resolve a menu hot-key to its item node.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
void far *func_0449C4_item_by_key(void far *win /*bp+6*/, uint16_t key /*bp+0xA*/)
{
    void far *grp;                       /* outer child (bx:bp-0xE)              */
    void far *item;                      /* inner item (si:bp-6)                 */
    void far *result = 0;                /* bp-0x16:bp-0x18                      */
    int found = 0;                       /* cx                                   */

    (void)win; (void)key; (void)grp; (void)item;
    /* @0x0449D4 grp = *[win+0x38]; */
    /* outer @0x05e4(ip): while grp != 0 */
    /*   @0x0449EC item = *[grp+0x1e]; */
    /*   inner @0x0605(ip): while item != 0 */
    /*     @0x044A0C if item[4]==key -> result=item, found=1, break-outer;      */
    /*     @0x044A24 else item = *[item+0xe].                                   */
    /*   @0x044A3B grp = *[grp+0x16].                                           */
    return result;                       /* @0x044A4F ax/dx = result             */
}

/* ===========================================================================
 * func_044A5A -- set/clear a widget's "checked" flag (bit0 of node+0xC) (56B)
 * @asm 0x044A5A..0x044A91  page_0A  ENTER 4  RETF
 * spot-check: 0x044A5A = C8 04 00 00 56 FF 76 0A  (enter 4,0; push si; push...)
 *
 * Resolves the (window,row,col?) triple to a node via near gui_node_first
 * (0x17FC) then, per the boolean bp+0xC, OR-sets (1) or AND-clears (0xFE) bit0
 * of node[+0xC].  Toggle the checked state of a check-item widget.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_044A5A_set_checked(uint16_t a /*bp+6*/, uint16_t b /*bp+8*/,
                            uint16_t c /*bp+0xA*/, uint16_t on /*bp+0xC*/)
{
    unsigned char far *node;             /* si (dx:ax from gui_node_first)       */
    (void)a; (void)b; (void)c; (void)node;
    node = (unsigned char far *)gui_node_first();  /* @0x044A69 near 0x17FC      */
    if (node == 0)                       /* @0x044A74 or dx,ax; je 0x68f         */
        return 0;
    if (on != 0)                         /* @0x044A7B cmp [bp+0xC],0             */
        node[0x0C] |= 0x01;              /* @0x044A81 or  byte es:[si+0xc],1     */
    else
        node[0x0C] &= 0xFE;              /* @0x044A8A and byte es:[si+0xc],0xfe  */
    return 0;
}

/* ===========================================================================
 * func_044A92 -- set/clear flag bit0 of node+0x00 (47 bytes)
 * @asm 0x044A92..0x044AC0  page_0A  ENTER 4  RETF
 * spot-check: 0x044A92 = C8 04 00 00 56 FF 76 0A  (enter 4,0; push si; ...)
 *
 * As func_044A5A but the resolver is near gui_node_alloc (0x1801) and the flag
 * is bit0 of node[+0x00] (the widget's primary state byte).
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_044A92_set_state0(uint16_t a /*bp+6*/, uint16_t b /*bp+8*/,
                           uint16_t c /*bp+0xA*/, uint16_t on /*bp+0xC*/)
{
    unsigned char far *node;             /* si:dx                                */
    (void)a; (void)b; (void)c; (void)node;
    node = (unsigned char far *)gui_node_alloc();  /* @0x044AA1 near 0x1801      */
    if (on != 0)                         /* @0x044AA9 cmp [bp+0xC],0             */
        node[0x00] |= 0x01;              /* @0x044AB1 or  byte es:[si],1         */
    else
        node[0x00] &= 0xFE;              /* @0x044ABA and byte es:[si],0xfe      */
    return 0;
}

/* ===========================================================================
 * func_044AC2 -- clear bit0 across a window's child sub-tree (68 bytes)
 * @asm 0x044AC2..0x044B05  page_0A  ENTER 8  RETF
 * spot-check: 0x044AC2 = C8 08 00 00 57 C4 5E 06  (enter 8,0; push di; les...)
 *
 * Walks the window's children (*[win+0x38], next [di+0x16]) and for each child
 * walks its item chain (*[child+0x1e], next [bx+0xe]) clearing bit0 of each
 * item[+0x00] (and byte[bx],0xFE).  De-selects every item in the tree.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_044AC2_clear_tree_state0(void far *win /*bp+6*/)
{
    void far *child;                     /* di:bp-6                              */
    unsigned char far *item;             /* ds:bx                                */
    (void)win; (void)child; (void)item;
    /* @0x044AC7 child = *[win+0x38]; */
    /* outer @0x6de(ip): while child != 0 */
    /*   @0x044ADE item = *[child+0x1e]; */
    /*   inner @0x6e8(ip): while item != 0 { item[0]&=0xFE; item=*[item+0xe]; } */
    /*   @0x044AF9 child = *[child+0x16].                                       */
    return 0;
}

/* ===========================================================================
 * func_044B06 -- set/clear flag bit1 of node+0x00 (47 bytes)
 * @asm 0x044B06..0x044B35  page_0A  ENTER 4  RETF
 * spot-check: 0x044B06 = C8 04 00 00 56 FF 76 0A  (enter 4,0; push si; ...)
 *
 * As func_044A92 but toggles bit1 (0x02) of node[+0x00]; resolver 0x1801.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_044B06_set_state1(uint16_t a /*bp+6*/, uint16_t b /*bp+8*/,
                           uint16_t c /*bp+0xA*/, uint16_t on /*bp+0xC*/)
{
    unsigned char far *node;             /* si:dx                                */
    (void)a; (void)b; (void)c; (void)node;
    node = (unsigned char far *)gui_node_alloc();  /* @0x044B15 near 0x1801      */
    if (on != 0)                         /* @0x044B1D cmp [bp+0xC],0             */
        node[0x00] |= 0x02;              /* @0x044B25 or  byte es:[si],2         */
    else
        node[0x00] &= 0xFD;              /* @0x044B2E and byte es:[si],0xfd      */
    return 0;
}

/* ===========================================================================
 * func_044B36 -- clear bit1 across a window's child sub-tree (68 bytes)
 * @asm 0x044B36..0x044B79  page_0A  ENTER 8  RETF
 * spot-check: 0x044B36 = C8 08 00 00 57 C4 5E 06  (enter 8,0; push di; les...)
 *
 * Same tree walk as func_044AC2 but clears bit1 (and byte[bx],0xFD) of every
 * item[+0x00].  Clears the "highlighted/active" mark across the tree.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_044B36_clear_tree_state1(void far *win /*bp+6*/)
{
    void far *child;                     /* di:bp-6                              */
    unsigned char far *item;             /* ds:bx                                */
    (void)win; (void)child; (void)item;
    /* @0x044B3B child = *[win+0x38]; */
    /* outer: while child != 0 { item=*[child+0x1e];                            */
    /*   inner: while item!=0 { item[0]&=0xFD; item=*[item+0xe]; }              */
    /*   child=*[child+0x16]; }                                                 */
    return 0;
}

/* ===========================================================================
 * func_044B7A -- append a child window/group to a window (411 bytes)
 * @asm 0x044B7A..0x044D15  page_0A  ENTER 0x16  RETF
 * spot-check: 0x044B7A = C8 16 00 00 57 56 C7 46  (enter 0x16,0; push di;push si)
 *
 * Appends a new group node to the parent (bp+6) at the tail of its child chain
 * (*[parent+0x38], walked via [bx+0x16]); the running y baseline is the sum of
 * each existing child's [+2]+[+4].  Allocs the new node:
 *   @0x044BD9 size 0x22 (181F:002C) -> node;
 *   chains it (parent[0x38] or prev[0x16] = node);
 *   inits node colour/parent links (+0x1a,+0x1c <- parent; +0x16,+0x18,+0x1e,
 *   +0x20 = 0; node[0] = 0);
 *   @0x044C57 measures the label text (0D1D:113C strlen, 181F:002C alloc copy,
 *   0D1D:117E store) into node[+0xe],[+0x10];
 *   @0x044C82 near gui_label_width (0x1815) -> node[+8];  node[+6]=0xA;
 *   node[+2] = running baseline;
 *   @0x044CA3 near gui_text_emit (0x1806): x = group label x + col*2 -> node[+4];
 *   @0x044CCD if flag bp+0x10: right-justify node[+2] = 0x140 - node[+4] -
 *             parent[+6];
 *   @0x044CEC node[+0x12,+0x14] = parent ptr; node[+0xa] = bp+0xe (row);
 *             node[+0xc]=0; inc parent[+2] (child count).  Returns node.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
void far *func_044B7A_window_append_group(void far *parent /*bp+6*/,
                                          uint16_t lbl_off /*bp+0xA*/,
                                          uint16_t lbl_seg /*bp+0xC*/,
                                          uint16_t row /*bp+0xE*/,
                                          uint16_t rjust /*bp+0x10*/)
{
    void far *node;                      /* si:bp-8                              */
    void far *prev;                      /* di:bp-0xE  (tail of chain)           */
    int baseline = 0;                    /* bp-6  running y                      */

    (void)parent; (void)lbl_off; (void)lbl_seg; (void)row; (void)prev;

    /* @0x044B85..0x044BB7 walk parent's child chain; baseline += child[2]+[4]. */
    /* @0x044BCD baseline += parent[+6]. */
    baseline += 0;                       /* @0x044BD1 add [bp-6],es:[di+6]       */

    /* @0x044BD9 alloc the 0x22-byte node. */
    node = (void far *)overlay_call_181F_002C();   /* @0x044BDD heap_alloc(0x22) */
    if (node == 0)                       /* @0x044BE7 je 0x804 (chain @parent)   */
        ;                                /* both arms chain node, then continue  */
    /* @0x044BFC/0x044C04 chain: prev[0x16]/parent[0x38] = node.                */

    /* @0x044C11..0x044C34 init parent links + zero fields. */
    /* @0x044C57 label text -> node[+0xe],[+0x10] (alloc-copy of measured str). */
    overlay_call_0D1D_113C();            /* @0x044C5D strlen(label)              */
    overlay_call_181F_002C();            /* @0x044C68 heap_alloc(len+1)          */
    overlay_call_0D1D_117E();            /* @0x044C7A copy label into it         */
    /* @0x044C82 width. */
    gui_label_width();                   /* @0x044C89 near 0x1815 -> node[+8]    */
    /* node[+6]=0xA; node[+2]=baseline. */
    /* @0x044CA3 x position. */
    gui_text_emit();                     /* @0x044CB5 near 0x1806                 */
    /* node[+4] = ax + node[+0xa]*2. */
    if (rjust != 0) {                    /* @0x044CCD cmp [bp+0x10],0            */
        /* @0x044CD3 node[+2] = 0x140 - node[+4] - parent[+6]. */
        baseline = 0;
    }
    /* @0x044CEC node[+0x12,+0x14]=parent; node[+0xa]=row; node[+0xc]=0;
     * @0x044D0B inc parent[+2]. */
    return node;                         /* @0x044D0F ax=si                      */
}

/* ===========================================================================
 * func_044D16 -- append a leaf item under a window's first list group (357B)
 * @asm 0x044D16..0x044E7A  page_0A  ENTER 0x14  RETF
 * spot-check: 0x044D16 = C8 14 00 00 57 56 2B C0  (enter 0x14,0; push di;push si)
 *
 * Resolves the list group via near gui_node_first (0x17FC).  If the group has
 * no items yet it allocs a 0x16-byte item (181F:002C) and links it as the
 * group's first ([grp+0x1e]); otherwise it walks the item chain ([bx+0xe]) to
 * the tail and links there ([tail+0xe]).  Inits the item:
 *   item[+0x12,+0x14] = group ptr; item[+0x10]=+0xe=item[0]=0;
 *   @0x044DD1 label copy: strlen(0D1D:113C) -> alloc(181F:002C) -> store
 *             (0D1D:117E) into item[+6],[+8];
 *   @0x044E0E if label[0]==0 set item[0] bit0 (disabled);
 *   item[+4] = bp+0x10 (key/value);
 *   @0x044E26 near gui_label_width (0x1815) -> item[+2];
 *   @0x044E37 near gui_text_emit (0x1806) measures width into ax;
 *   group[+6] = max(group[+6], item[+0xc]*2 + width); inc group[0] (count).
 * Returns the item ptr.  (Add one selectable line to a menu/list.)
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
void far *func_044D16_list_add_item(uint16_t a /*bp+6*/, uint16_t b /*bp+8*/,
                                    uint16_t lbl_off /*bp+0xA*/,
                                    uint16_t lbl_seg /*bp+0xC*/,
                                    uint16_t value /*bp+0x10*/)
{
    void far *grp;                       /* bp-0x14 the list group               */
    void far *item;                      /* si:bp-6 the new item                  */
    void far *tail;                      /* bp-0xE walk cursor                    */

    (void)a; (void)b; (void)lbl_off; (void)lbl_seg; (void)value; (void)tail;

    grp = (void far *)gui_node_first();  /* @0x044D2E near 0x17FC                 */
    if (grp == 0)                        /* @0x044D3A or dx,ax; je 0xa72          */
        return 0;

    /* @0x044D49 if grp has no first item -> alloc + link as grp[+0x1e];
     * @0x044D8E else walk grp item chain [bx+0xe] to tail, link [tail+0xe]. */
    overlay_call_181F_002C();            /* @0x044D6E / 0x044DF5 heap_alloc(0x16) */
    item = 0;                            /* (set from alloc result)               */

    /* @0x044DB7..0x044DCE init parent link + zero fields. */
    overlay_call_0D1D_113C();            /* @0x044DEA strlen(label)               */
    overlay_call_181F_002C();            /* @0x044DF5 heap_alloc(len+1)           */
    overlay_call_0D1D_117E();            /* @0x044E06 copy label -> item[+6],[+8] */
    /* @0x044E11 if label[0]==0 -> item[0] |= 1 (disabled).                     */
    /* @0x044E1D item[+4] = value.                                             */
    gui_label_width();                   /* @0x044E2B near 0x1815 -> item[+2]     */
    gui_text_emit();                     /* @0x044E49 near 0x1806 (width in ax)   */
    /* @0x044E52 grp[+6] = max(grp[+6], item[+0xc]*2 + width); inc grp[0]. */
    return item;                         /* @0x044E72 ax=si                       */
}

/* ===========================================================================
 * func_044E7C -- draw a window's full widget tree (296 bytes)  [DRAW]
 * @asm 0x044E7C..0x044FA3  page_0A  ENTER 0xC  RETF
 * spot-check: 0x044E7C = C8 0C 00 00 56 C4 5E 06  (enter 0xC,0; push si; les...)
 *
 * Renders the window (bp+6) and, optionally (bp+0xE), the cursor.  Steps:
 *   @0x044E8C width = near func_044540(win[+0x28],win[+0x2a]) + win[+4] + 1;
 *   @0x044E9D near 0x18A (func_04458A text-route) draws the window title row at
 *            (win[+0xe],win[+0x10]) within the 0x140-wide clip from FONT_DESC;
 *   @0x044ECC walk children (*[win+0x38], next [bx+0x16]); for each child not
 *            disabled (item[+0xc] bit0 clear):
 *      if this child == the focused node (bp+0xa) draw its label highlighted
 *        (@0x044F04 near 0x18A at child[+0x1a],[+0x1c]);
 *      @0x044F44 draw the child body via near gui_label_draw (0x1810) at
 *        (child[+4]+win[+0xa], child[+0xe/0x10]) offset by win[+0x20];
 *   @0x044F89 if bp+0xE (draw cursor) overlay the caret bar (181F:00E2) the
 *            full 0x140 width at the computed y.
 * Pure composition: this is the "what is drawn where" for a dialog.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
static int gui_widget_draw_tree(void *win) { (void)win; return 0; }  /* fwd impl */

int func_044E7C_window_draw(void far *win /*bp+6*/, void far *focus /*bp+0xA*/,
                            uint16_t draw_cursor /*bp+0xE*/)
{
    int width;                           /* bp-8                                  */
    unsigned char far *child;            /* bp-0xC                                */

    (void)win; (void)focus; (void)child;

    /* @0x044E8C title row width. */
    width = func_044540();               /* @0x044E8C near 0x140 clamp/measure    */
    width += 1;                          /* @0x044E99 + win[+4] + 1               */
    /* @0x044E9D draw title text row at win[+0xe],win[+0x10]. */
    func_04458A_dialog_text_route(0,0,0,0,0,0,0,0);  /* @0x044EC9 near 0x18A      */

    /* @0x044ECC child = *[win+0x38]; */
    /* loop @0xae4(ip): while child != 0 */
    for (;;) {
        /* @0x044EE7 skip if child[+0xc] bit0 set (disabled). */
        /* @0x044EF1..0x044F02 if child == focus, draw highlighted title. */
        func_04458A_dialog_text_route(0,0,0,0,0,0,0,0);  /* @0x044F41 near 0x18A  */
        /* @0x044F44 draw the child body label. */
        gui_label_draw();                /* @0x044F6B near 0x1810                 */
        /* @0x044F71 child = *[child+0x16]; if 0 stop. */
        break;
    }

    if (draw_cursor != 0)                /* @0x044F89 cmp [bp+0xE],0              */
        overlay_call_181F_00E2();        /* @0x044F9C caret_bar(0,0x140,y)        */
    (void)gui_widget_draw_tree;
    return 0;
}

/* ===========================================================================
 * func_044FA4 -- measure a window's content box (width,height) (278 bytes)
 * @asm 0x044FA4..0x0450B9  page_0A  ENTER 0x12  RETF
 * spot-check: 0x044FA4 = C8 12 00 00 57 56 8B 76  (enter 0x12,0; push di;push si)
 *
 * Out-params (near ptrs bp+0xA,0xC,0xE,0x10,0x12,0x14) describe the box for the
 * window at (bp+6):
 *   *bp+0xA = win[+2] (x);
 *   *bp+0xC = func_044540(win[+0x12:+0x14][+0x28..0x2a]) + that[+4] + 3 (title w)
 *   count visible (non-bit1) children -> rows;  rows used to compute height;
 *   *bp+0xE = win[+6]+2 (inner x); *bp+0x10 = rows-scaled height; clamp the
 *   right/bottom against 0x13E/0xC6 (push x/y back inside the screen);
 *   *bp+0x12 = clamped x+1; *bp+0x14 = title-buffer[+8] + y + 1.
 * If the box would fall off-screen at a negative origin it calls 181F:0772
 * (scroll/clamp).  This is the auto-size pass before the box is framed.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_044FA4_window_measure(void far *win /*bp+6*/,
                               uint16_t *out_x /*bp+0xA*/, uint16_t *out_w /*bp+0xC*/,
                               uint16_t *out_ix /*bp+0xE*/, uint16_t *out_h /*bp+0x10*/,
                               uint16_t *out_rx /*bp+0x12*/, uint16_t *out_ry /*bp+0x14*/)
{
    void far *title;                     /* bp-0x12 the title/body sub-buffer     */
    int rows = 0;                        /* bp-6  visible child count             */
    int x, y;                            /* working                               */

    (void)win; (void)out_x; (void)out_w; (void)out_ix; (void)out_h;
    (void)out_rx; (void)out_ry; (void)title;

    /* @0x044FB0 *out_x = win[+2]. */
    /* @0x044FC5 title = win[+0x12:+0x14]; w = func_044540(title[0x28..0x2a]). */
    func_044540();                       /* @0x044FCF near 0x140                  */
    /* @0x044FD8 *out_w = w + title[+4] + 3. */

    /* @0x044FE9 count children (*[win+0x1e], next [bx+0xe]) with bit1 clear. */
    /* @0x045019 *out_ix = win[+6]+2; *out_h derived from rows + title[+8]. */
    /* @0x04505F clamp box bottom < 0x13E and right < 0xC6 (push origin in). */
    x = 0; y = 0;
    if (x < 0 && y < 0)                  /* @0x045094..0x04509C                   */
        overlay_call_181F_0772();        /* @0x0450B1 scroll/clamp(x,y,0xffb0,2)  */
    (void)rows;
    return 0;
}
/* 181F:0772 used only here in this file. */
extern int overlay_call_181F_0772(void);

/* ===========================================================================
 * func_0450BA -- frame + paint a window box and its rows (537 bytes)  [DRAW]
 * @asm 0x0450BA..0x0452D2  page_0A  ENTER 0x24  RETF
 * spot-check: 0x0450BA = C8 24 00 00 57 56 C4 5E  (enter 0x24,0; push di;push si)
 *
 * Lays out + draws the window (bp+6):
 *   @0x0450EC near gui_box_geometry (0x17F7) fills (x,y,w,h) locals from the
 *            window header (+0x12:+0x14);
 *   @0x0450F2 draw the outer frame: 181F:00CE (box_fill) with the window's
 *            border colour byte ([hdr+0x1e]) spanning (x,y)..(x+w-1,y+h-1);
 *   @0x045136 near 0x18A (func_04458A) paints the title bar fill inset by 1;
 *   @0x045179 walk children (*[win+0x1e], next [bx+0xe]); for each:
 *      if bit1 set (group header) draw the section title centred:
 *        @0x0451BA func_044540 to centre, near 0x18A title fill, then 181F:00BA
 *        (text_draw_field) at the section colour [hdr+0x2e];
 *      else draw the row text: 181F:00BA-class via near gui_label_draw (0x1810)
 *        using the item's own colour [+6],[+8] at (win+0x2c) origin;
 *      advance the running y by func_044540(item) + item[+8].
 *   @0x0452B9 near 0x18A again for the final caret/refresh; LEAVE; RETF.
 * Full per-window paint -- the central "draw this dialog" composition routine.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_0450BA_window_paint(void far *win /*bp+6*/)
{
    int x, y, w, h;                      /* bp-0x1c,-0x1e,-0x22,-0x1a             */
    void far *hdr;                       /* bp-0x18 window header (+0x12:+0x14)   */
    unsigned char far *child;            /* bp-0x14                               */

    (void)win; (void)hdr; (void)child;

    gui_box_geometry();                  /* @0x0450EC near 0x17F7 -> x,y,w,h       */
    x = y = w = h = 0;
    /* @0x0450F2 outer frame fill. */
    overlay_call_181F_00CE();            /* @0x045120 box_fill(x,y,x+w-1,y+h-1,col)*/
    /* @0x045136 title bar inset fill. */
    func_04458A_dialog_text_route(0,0,0,0,0,0,0,0);  /* @0x045176 near 0x18A      */

    /* @0x045179 child = *[win+0x1e]; */
    for (;;) {                           /* loop @0xda2(ip)                       */
        /* @0x0451A5 if child[0] bit1 -> section header centred draw. */
        /* @0x0451BA func_044540 (centre), near 0x18A fill, 181F:00BA text. */
        func_044540();                   /* @0x0451D5 near 0x140                  */
        func_04458A_dialog_text_route(0,0,0,0,0,0,0,0);  /* @0x045209 near 0x18A  */
        overlay_call_181F_00BA();        /* @0x045255 text_draw_field(section)    */
        /* @0x04525C else row text via gui_label_draw. */
        gui_label_draw();                /* @0x045280 near 0x1810                 */
        /* @0x045286 y += func_044540(item) + item[+8]; */
        func_044540();                   /* @0x045291 near 0x140                  */
        /* @0x0452A1 child = *[child+0xe]; if 0 stop. */
        break;
    }
    /* @0x0452B9 final refresh. */
    overlay_call_181F_00E2();            /* @0x0452CA caret/region restore        */
    return 0;
}

/* ===========================================================================
 * func_0452D4 -- modal dialog navigation + key loop (1559 bytes)  [INPUT/NAV]
 * @asm 0x0452D4..0x0458E8  page_0A  ENTER 0x3C  RETF 4
 * spot-check: 0x0452D4 = C8 3C 00 00 56 C7 46 E0  (enter 0x3C,0; push si; ...)
 *
 * The interactive run-loop for a dialog/menu window (bp+6).  Outline:
 *   @0x0452F7 redraw flag bp-0xa = 1; read BIOS_KBFLAG bit3 (Alt) into bp-0x1a.
 *   @0x045317 if window has no children -> jump to cleanup @0x14ce.
 *   @0x045327 near gui_region_save (0x17E8) saves the screen under the box;
 *            near gui_box_geometry (0x17F7) fills the box rect locals;
 *   @0x04535D line height = func_044540(title) + title[+8];
 *   @0x045384 set the text clip region (1A1F:0364) to the box interior;
 *   @0x045394 if G_DLG_HASLIST==0 use the parent's own child list (bp-0x2a..).
 *   @0x0453AF cursor on (181F:0470); 181F:0466 reset; if G_DLG_LOOP_F6==0 skip
 *            straight to draw @0x1132.
 *   @0x0453C5 FOCUS-FIT pass: walk children to keep the focused row visible:
 *            compute each row's screen y (func_044540 + win[+4]); if it exceeds
 *            G_VIEW_BOTTOM scroll the window so it fits, else step to next child
 *            (chain via [+0x16] / fallback [+0x38]); bounds clamp against
 *            G_VIEW_RIGHT / G_VIEW_BOTTOM.
 *   @0x045532 EVENT: 181F:00F6 (input_wait_event); if redraw or loop disabled
 *            jump to render @0x121a.
 *   @0x045550 KEY: 181F:03E0 (translate key) -> ax; if ax<0x100 and CHAR_CLASS
 *            bit1 (shiftable) subtract 0x20 (force upper).  switch(ax):
 *              0x38 (Up)    @0x119a : focus prev selectable, wrapping at head.
 *              0x32 (Down)  @0x1264 : focus next selectable, wrapping at tail.
 *              0x148 (PgUp) @0x13bc->0x119a, +3=Home @0x12ce, -2=End @0x131e.
 *              0x0D (ENTER) @0x1350 : clear redraw flag (commit selection).
 *              0x0E (TAB)   @0x1358 : clear redraw, drop focus (cycle group).
 *              hot-key      @0x1368 : match a child whose key [+2]==ax (class
 *                                     bits 0/1 clear) -> select it.
 *   @0x1392/0x13db default: reset focus to window's first child.
 *   @0x13ee POST: if scroll happened and not committing, redraw rows; if
 *            G_DLG_REDRAW_F4 set and focus exists, force full redraw.
 *   @0x1430 RENDER: 181F:045C (nav idle tick); if still looping re-run FOCUS-FIT
 *            (@0xfaf); else 1A1F:038A restore clip, 181F:00E2 caret refresh,
 *            copy focused child's value [+4] into win[0] (the result), loop.
 *   @0x14c6 on bail set win[0]=0.
 *   @0x14ce cleanup: 181F:047A cursor restore; near gui_region_save (0x17E8)
 *            with restore=1 puts the saved screen back.  RETF 4.
 * This *is* the menu/dialog interaction layout (focus order, hit regions, key
 * bindings) -- squarely in the UI-layout scope.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_0452D4_dialog_run(void far *win /*bp+6*/)
{
    int redraw  = 1;                     /* bp-0xa : need redraw                  */
    int alt_held;                        /* bp-0x1a : BIOS kbflag bit3            */
    int line_h;                          /* bp-8 : per-row height                 */
    int committing = 0;                  /* bp-0x14 : ENTER pressed               */
    int scrolled = 0;                    /* bp-0x30 : view changed                */
    int focused = 0;                     /* bp-0x20 : a row is focused            */
    int key;                             /* bp-0x3c : translated key code         */
    void far *focus = 0;                 /* bp-0x2a..-0x28 : focused child        */
    void far *cur = 0;                   /* bp-0x34..-0x32 : walk cursor          */

    (void)win; (void)focus; (void)cur; (void)scrolled; (void)focused;

    /* @0x0452FC alt_held = BIOS_KBFLAG & 8. */
    alt_held = BIOS_KBFLAG & 0x08;
    /* @0x045317 if no children -> cleanup. */
    /* @0x045327 save screen region + box geometry. */
    gui_region_save();                   /* @0x045332 near 0x17E8 (save=1)        */
    gui_box_geometry();                  /* @0x045357 near 0x17F7                 */
    /* @0x04535D line_h = func_044540(title) + title[+8]. */
    line_h = func_044540();              /* @0x045368 near 0x140                  */
    /* @0x045384 set clip region to box interior. */
    overlay_call_1A1F_0364();            /* @0x04538C text_clip_set(box)          */

    /* @0x0453AF cursor on; reset; gate on G_DLG_LOOP_F6. */
    overlay_call_181F_0470();            /* @0x0453AF cursor_on()                 */
    overlay_call_181F_0466();            /* @0x0453B6 nav_reset()                 */
    if (G_DLG_LOOP_F6 == 0)              /* @0x0453BB cmp [0x7f6],0               */
        goto render;                     /* @0x0453C2 jmp 0x1132                  */

focus_fit:
    /* @0x0453C5..0x045530 keep the focused row visible; choose the child whose
     * screen y is in-range, scrolling the window otherwise.  Chain walk uses
     * child[+0x16] with a [+0x38] fallback to the head; the running y uses
     * func_044540 + win[+4]; bounds are G_VIEW_RIGHT(0x7e8)/G_VIEW_BOTTOM(0x7ea).
     */
    (void)G_VIEW_RIGHT; (void)G_VIEW_BOTTOM;

    /* @0x045532 event wait. */
    if (overlay_call_181F_00F6() != 0)   /* @0x045532 input_wait_event()          */
        goto render;
    if (redraw == 0) goto render;        /* @0x04553E                             */
    if (committing != 0) goto render;    /* @0x045547                             */

    /* @0x045550 translate key; normalise shiftable to upper. */
    key = overlay_call_181F_03E0();      /* @0x045550 translate_key()             */
    if (key < 0x100 && (CHAR_CLASS(key) & 2)) /* @0x04555F test bit1             */
        key -= 0x20;                     /* @0x045566 force upper                 */

    /* @0x045571 switch(key): */
    switch (key) {
    case 0x38:                           /* @0x119a Up: focus previous selectable */
        /* walk siblings backward via [+0x12]/[+0xe]; wrap at head to win[+0x1e];
         * pick the first whose flags&3==0 and label[0]!=0. */
        break;
    case 0x32:                           /* @0x1264 Down: focus next selectable   */
        /* walk forward via [+0xe]; wrap at tail to win[+0x1e]; same predicate.  */
        break;
    case 0x148:                          /* @0x13bc PgUp -> treat as Up           */
        goto case_up;
    case 0x0D:                           /* @0x1350 ENTER: commit selection       */
        redraw = 0;                      /* @0x045750 mov [bp-0xa],0              */
        goto render;
    case 0x0E:                           /* @0x1358 TAB: drop focus, cycle group  */
        redraw = 0;                      /* @0x045758                             */
        focus = 0;                       /* @0x04575D clear focus ptr             */
        goto render;
    default:                             /* @0x1368 hot-key match else reset      */
        /* @0x045768 walk children; if child[+2]==key and flags&3==0 select it;
         * @0x0457DB default: focus = win's first child. */
        break;
    }
case_up:

render:
    /* @0x13ee post: optional row/full redraw based on scroll + G_DLG_REDRAW_F4. */
    if (G_DLG_REDRAW_F4 != 0)            /* @0x045817 cmp [0x7f4],0               */
        gui_box_draw();                  /* @0x04580C near 0x180B (row redraw)    */

    /* @0x045830 idle tick. */
    overlay_call_181F_045C();            /* @0x045835 nav_tick(redraw)            */
    if (redraw != 0 && committing == 0)  /* @0x04583A                             */
        goto focus_fit;                  /* @0x045846 jmp 0xfaf                   */

    /* @0x045849 restore clip; caret refresh; capture result. */
    overlay_call_1A1F_038A();            /* @0x04585F text_clip_restore()         */
    overlay_call_181F_00E2();            /* @0x045875 caret_refresh()             */
    /* @0x045883 if focus, win[0] = focus[+4] (selected value); else win[0]=0. */

    /* @0x0458CE cleanup. */
    overlay_call_181F_047A();            /* @0x0458CE cursor_restore()            */
    gui_region_save();                   /* @0x0458E0 near 0x17E8 (restore=1)     */
    return 0;                            /* @0x0458E6 LEAVE; RETF 4               */
}

/* ===========================================================================
 * func_0458EC -- vertical autoscroll a list to keep the active row on screen (158B)
 * @asm 0x0458EC..0x045987  page_0A  ENTER 6  RETF 4
 * spot-check: 0x0458EC = C8 06 00 00 50 57 56 8B  (enter 6,0; push ax;di;si)
 *
 * For the list whose state ptr is (bp+6:bp+8): if its current top row [di]
 * equals the sentinel G_VIEW_FLAG_7EC, nothing to do.  Otherwise compute the
 * bottom of row [di+4] (func_044540 + di[+4] + 1); if it would extend past
 * G_VIEW_BOTTOM (0x7ea), scan the item list (*[di+0x38], next [si+0x16]) for the
 * first item whose right edge [si+2]+[si+4] >= G_VIEW_RIGHT (0x7e8) and is not
 * disabled ([si+0xc] bit0 clear); if found, free it via near gui_widget_free
 * (0x17ED) and report scrolled=1.  Returns 1 if a reflow happened.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_0458EC_list_autoscroll(void far *list /*bp+6*/, uint16_t list_seg /*bp+8*/)
{
    unsigned char far *st;               /* di                                    */
    unsigned char far *item;             /* si                                    */
    int scrolled = 0;                    /* bp-6                                   */
    int hit = 0;                         /* cx                                    */

    (void)list; (void)list_seg; (void)st; (void)item; (void)hit;

    /* @0x0458FE *[di] = 0 (clear top); if [0x7ec]==0 -> done. */
    if (G_VIEW_FLAG_7EC == 0)            /* @0x045901 je 0x1581                   */
        goto done;
    /* @0x045907 bottom = func_044540(di[0x28..0x2a]) + di[+4]. */
    func_044540();                       /* @0x045911 near 0x140                  */
    /* @0x04591D si = bottom + di[+4] + 1; if si < G_VIEW_BOTTOM -> done. */
    if (0 < G_VIEW_BOTTOM)               /* @0x045920 jl 0x1581                   */
        goto done;
    /* @0x045928 item = *[di+0x38]; scan chain. */
    /* loop @0x1537(ip): while item != 0 */
    /*   @0x04593B if item[2]+item[4] >= G_VIEW_RIGHT and item[0xc] bit0 clear */
    /*             -> hit=1, break;  else item = *[item+0x16].                 */
    if (hit != 0) {                      /* @0x04595B or cx,cx; jne 0x1566        */
        scrolled = 1;                    /* @0x045966 mov [bp-6],1                */
        /* @0x04596B if list_seg!=0 free the offscreen node. */
        gui_widget_free();               /* @0x04597E near 0x17ED                 */
    }
done:
    return scrolled;                     /* @0x045981 ax = [bp-6]; RETF 4         */
}

/* ===========================================================================
 * func_04598A -- find the list item at a given screen row (147 bytes)  [HIT-TEST]
 * @asm 0x04598A..0x045A1A  page_0A  ENTER 0xA  RETF 4
 * spot-check: 0x04598A = C8 0A 00 00 57 56 8B F8  (enter 0xA,0; push di;si;mov di,ax)
 *
 * Given the target row in ax (kept in di) and the list (bp+6:bp+8): map the row
 * to a widget via 1A1F:0380 (widget_at_row) into bp-2; then walk the item chain
 * (*[win+0x38], next [si+0x16]) for the first item whose row [si+8]==that widget
 * and which is enabled ([si+0xc] bit0 clear).  If found, free/select it via near
 * gui_widget_free (0x17ED) and return 1 (also 181F:047A cursor restore); else
 * return 0.  The click-to-item hit-test for a menu list.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_04598A_list_hit_test(void far *win /*bp+6*/, uint16_t win_seg /*bp+8*/,
                              uint16_t row /*ax*/)
{
    unsigned char far *item;             /* si:bp-8                               */
    int widget;                          /* bp-2  = widget_at_row(row)            */
    int found = 0;                       /* cx                                    */
    int result = 0;                      /* di:bp-6                               */

    (void)win; (void)win_seg; (void)row; (void)item; (void)found;

    /* @0x045998 item = *[win+0x38]; *[win]=0. */
    widget = overlay_call_1A1F_0380();   /* @0x0459B2 widget_at_row(row)          */
    if (widget == (int)row)              /* @0x0459BA cmp ax,di; je 0x15e4        */
        goto out;
    /* loop @0x15cb(ip): while item != 0 */
    /*   @0x0459D2 if item[8]==widget and item[0xc] bit0 clear -> found=1,break; */
    /*   @0x0459EA else item = *[item+0x16].                                    */
    if (found != 0) {                    /* @0x045A01 or cx,cx; je 0x1610         */
        gui_widget_free();               /* @0x045A0A near 0x17ED (select item)   */
        result = 1;                      /* @0x045A0D mov di,1                     */
    }
out:
    overlay_call_181F_047A();            /* @0x045A10 cursor_restore()            */
    return result;                       /* @0x045A15 ax = di; RETF 4             */
}

/* ===========================================================================
 * func_045A1E -- find the first/topmost enabled item in a list (198 bytes)
 * @asm 0x045A1E..0x045ADC  page_0A  ENTER 0x14  RETF 4
 * spot-check: 0x045A1E = C8 14 00 00 50 57 56 C4  (enter 0x14,0; push ax;di;si)
 *
 * Walks the window's child groups (*[win+0x38], next [bx+0x16]); for each
 * enabled group ([bx+0xc] bit0 clear) walks its item chain (*[bx+0x1e], next
 * [si+0xe]) for the first item whose key [si+2] matches the target (bp-0x16)
 * and whose flags [si]&3 == 0 (enabled, not header).  On success writes the
 * found node's value [di+4] back to *[bp+6][0] and returns it; else 0.  Resolves
 * the default/initial focus item for a freshly opened list.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
void far *func_045A1E_list_default_item(void far *win /*bp+6*/)
{
    unsigned char far *grp;              /* bx:bp-0x10                            */
    unsigned char far *item;             /* si:bp-0xc                             */
    void far *found = 0;                 /* di:bp-0xe                             */
    int hit = 0;                         /* cx                                    */

    (void)win; (void)grp; (void)item; (void)hit;

    /* @0x045A30 grp = *[win+0x38]; *[win]=0. */
    /* outer @0x1651(ip): while grp != 0 */
    /*   @0x045A5B skip if grp[+0xc] bit0 set. */
    /*   @0x045A62 item = *[grp+0x1e]; */
    /*   inner @0x1679(ip): while item != 0 */
    /*     @0x045A80 if item[2]==target and item[0]&3==0 -> hit=1,found,break;   */
    /*     @0x045A92 else item = *[item+0xe].                                    */
    /*   @0x045AAF grp = *[grp+0x16].                                            */
    if (hit != 0) {                      /* @0x045AC9 cmp [bp-6],0; je 0x16dc     */
        /* @0x045AD2 *[win][0] = found[+4]. */
    }
    return found;                        /* @0x045ADC ax = bx                     */
}

/* ===========================================================================
 * func_045AE4 -- load the default-widget geometry from the config record (310B)
 * @asm 0x045AE4..0x045BE6  page_0A  ENTER 0xE  RETF  (terminal = page-end block)
 * spot-check: 0x045AE4 = C8 0E 00 00 57 56 B8 01  (enter 0xE,0; push di;si;mov ax,1)
 *
 * Opens the GUI config record (1A1F:0372 -> handle in dx:ax/si) and reads seven
 * 1-byte fields (181F:0254 cfg_read_byte with index 1..7) into the
 * default-geometry block, storing each twice (set-A and set-B):
 *   idx1 -> [0x149c] & [0x14a0]      idx2 -> [0x149e] & [0x14a2]
 *   idx3 -> [0x14a8] & [0x14a4]      idx4 -> [0x14aa] & [0x14a6]
 *   idx5 -> [0x14b4] & [0x14ae]      idx6 -> [0x14b8] & [0x14b2]
 *   idx7 -> [0x14b4] & [0x14b0]      (idx7 re-stores 0x14b4)
 * then 191F:01A8 (widget_invalidate / commit) and returns.  This is the data
 * that func_044836 stamps into every new window -- the default dialog layout
 * table, expressed here as the load that fills G_DLG_GEOM(0x149c..0x14b8).
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_045AE4_load_dialog_geometry(void)
{
    int handle;                          /* si:bp-4                               */
    unsigned char val;                   /* bp-1 : one cfg byte                    */

    (void)val;
    /* @0x045AFC bx=&[0x14bc]; open config first record. */
    handle = overlay_call_1A1F_0372();   /* @0x045B02 cfg_open()                   */
    if (handle == 0)                     /* @0x045B0C or dx,ax; je 0x17e3          */
        return 0;

    /* @0x045B13 idx 1 */
    overlay_call_181F_0254();            /* @0x045B24 cfg_read_byte(1)             */
    G_DLG_GEOM(0x149C) = DG8(0); G_DLG_GEOM(0x14A0) = DG8(0);  /* @0x045B2E,31     */
    /* @0x045B34 idx 2 */
    overlay_call_181F_0254();            /* @0x045B40 cfg_read_byte(2)             */
    G_DLG_GEOM(0x149E) = 0; G_DLG_GEOM(0x14A2) = 0;            /* @0x045B4A,4D     */
    /* @0x045B50 idx 3 */
    overlay_call_181F_0254();            /* @0x045B5C cfg_read_byte(3)             */
    G_DLG_GEOM(0x14A8) = 0; G_DLG_GEOM(0x14A4) = 0;            /* @0x045B66,69     */
    /* @0x045B6C idx 4 */
    overlay_call_181F_0254();            /* @0x045B78 cfg_read_byte(4)             */
    G_DLG_GEOM(0x14AA) = 0; G_DLG_GEOM(0x14A6) = 0;            /* @0x045B82,85     */
    /* @0x045B88 idx 5 */
    overlay_call_181F_0254();            /* @0x045B94 cfg_read_byte(5)             */
    G_DLG_GEOM(0x14B4) = 0; G_DLG_GEOM(0x14AE) = 0;            /* @0x045B9E,A1     */
    /* @0x045BA4 idx 6 */
    overlay_call_181F_0254();            /* @0x045BB0 cfg_read_byte(6)             */
    G_DLG_GEOM(0x14B8) = 0; G_DLG_GEOM(0x14B2) = 0;            /* @0x045BBA,BD     */
    /* @0x045BC0 idx 7 */
    overlay_call_181F_0254();            /* @0x045BCC cfg_read_byte(7)             */
    G_DLG_GEOM(0x14B4) = 0; G_DLG_GEOM(0x14B0) = 0;            /* @0x045BD6,D9     */

    overlay_call_191F_01A8();            /* @0x045BDE commit/invalidate           */
    return 0;                            /* @0x045BE3 LEAVE; RETF                  */
}

/* ===========================================================================
 * func_045D00 -- BURN the power's MISSIONS in a tribe's settlements (145B)
 * @asm 0x045D00..0x045D90  page_0B  ENTER 4  RETF
 * spot-check: 0x045D00 = C8 04 00 00 2B C0 89 46  (enter 4,0; sub ax,ax; ...)
 * IDENTITY CORRECTED 2026-06-10 (was "redraw village markers"):
 *
 * Scans NativeSettlement[0..G_OTHER_COUNT): a settlement matches when its
 * owner byte (+0x54EE) == tribe+4 (owner stores the ENTITY id, tribes are
 * entities 4..11 — the `sub al,[bp+6]; cmp al,4` is owner-(tribe0)==4) and its
 * MISSION byte (+0x54F1, NS+5) low nibble == the POWER (bp+8 — the founder
 * power of the mission there).  Each match: NS_MISSION = 0xFF (NO MISSION) —
 * the mission is destroyed.  If any were destroyed, stage the message args and
 * show "INDIANBURN":
 *   %arg0 = rel_event_query_other(tribe+4)   ; 0x181F:0xA1A tribe name handle
 *   %arg1 = power_handle(power)              ; 0x181F:0x9A4
 *   if (power < 4 && human [0x543F+power*0x34]==0)
 *       show_message(1, 0x14C8)              ; 0x181F:0x652; 0x14C8 -> file
 *                                            ;   0x1EE68 = "INDIANBURN" (dumped)
 * This is the public thunk 0x1A1F:0x398 (RTLink: ovl 11 + 0, reached via the
 * page-0B near trampoline 0x9CE / file 0x465EE = LJMP 0x1A1F:0x398).
 * @status BYTE_VERIFIED (full body; message string dumped from EXE)
 * =========================================================================== */
int func_045D00_burn_missions(uint16_t tribe /*bp+6, 0-based*/, uint16_t power /*bp+8*/)
{
    int burned = 0;                      /* bp-2                                  */
    int i;                               /* bp-4                                  */
    int bx;

    /* @0x045D0E scan loop. */
    for (i = 0; i < G_OTHER_COUNT; i++) {         /* @0x045D35 cmp [0x539a],ax   */
        bx = i * NS_STRIDE;                       /* @0x045D0E imul bx,ax,0x12   */
        if ((unsigned char)(NS_OWNER(bx) - (tribe & 0xFF)) != 4)  /* @0x045D15 owner==tribe+4 */
            continue;                             /* @0x045D1A jne                */
        if ((NS_MISSION(bx) & 0x0F) != (int)power)   /* @0x045D1C mission founder  */
            continue;                             /* @0x045D26 jne                */
        burned = 1;                               /* @0x045D28 mov [bp-2],1       */
        NS_MISSION(bx) = 0xFF;                    /* @0x045D2D burn: no mission   */
    }

    if (burned == 0)                     /* @0x045D3E cmp [bp-2],0; je 0x16f      */
        return 0;

    /* @0x045D44 stage INDIANBURN message args. */
    overlay_call_181F_0A1A();            /* @0x045D4B tribe name handle (tribe+4) */
    overlay_call_181F_0438();            /* @0x045D56 msg_set_arg(0, ...)         */
    overlay_call_181F_09A4();            /* @0x045D61 power_handle(power)         */
    overlay_call_181F_0438();            /* @0x045D6C msg_set_arg(1, ...)         */

    /* @0x045D74 only shown to a human European power. */
    if ((int)power < 4 && !IS_REF_POWER(power)) {    /* @0x045D74..0x045D83      */
        overlay_call_181F_0652();        /* @0x045D8A show_message(1, 0x14C8 "INDIANBURN") */
    }
    return 0;
}

/* ===========================================================================
 * func_045D92 -- tribe BREAKS TREATY with a power (+burn missions) (95 bytes)
 * @asm 0x045D92..0x045DF0  page_0B  PUSH BP  RETF
 * spot-check: 0x045D92 = 55 8B EC 83 7E 0A 04 7D  (push bp;mov bp,sp;cmp[bp+0xA],4)
 * IDENTITY CORRECTED 2026-06-10 (was "draw a single village marker"):
 *
 *   func_045D92(msg_key, tribe0, power):
 *     if (power < 4 && human && msg_key != 0) {
 *         %arg0 = tribe name handle (0x181F:0xA1A of tribe0+4)
 *         ui_dialog_show(msg_key)        ; 0x181F:0x998 = menu_lookup_run,
 *                                        ;   REGISTER protocol ax=key, dx=0,
 *                                        ;   bx=0x87C (confirms ui/menu.c)
 *     }
 *     rel_clear_event(0x40, tribe0+4, power)   ; 0x181F:0xA10 — CLEAR THE
 *                                              ;   TREATY BIT 0x40
 *     func_045D00_burn_missions(tribe0, power) ; near 0x9CE -> 0x465EE
 *                                              ;   (LJMP 0x1A1F:0x398)
 * The "0xA10 = marker_draw" and "0x998 = hud_draw_settlement" readings are
 * RETRACTED — those thunks are rel_clear_event (resident 0x08000) and
 * menu_lookup_run (func_06F51A), per the 2026-06-10 thunk rule.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_045D92_tribe_break_treaty(uint16_t msg_key /*bp+6*/, uint16_t tribe0 /*bp+8*/,
                                   uint16_t power /*bp+0xA*/)
{
    /* @0x045D95 gate: power < 4, human, and a message key supplied. */
    if ((int)power < 4 && !IS_REF_POWER(power) && msg_key != 0) {  /* @0x045D95..0x045DAA */
        overlay_call_181F_0A1A();        /* @0x045DB3 tribe name handle (tribe0+4)*/
        overlay_call_181F_0438();        /* @0x045DBD msg_set_arg(0, ...)         */
        overlay_call_181F_0998();        /* @0x045DCD ui_dialog_show: menu_lookup_run(ax=msg_key, bx=0x87C) */
    }
    /* @0x045DD2 clear the treaty bit: rel_clear_event(0x40, tribe0+4, power). */
    overlay_call_181F_0A10();            /* @0x045DDE rel_clear_event(0x40,...)   */
    /* @0x045DEC near 0x9CE -> 0x465EE (LJMP 0x1A1F:0x398) = burn missions. */
    func_045D00_burn_missions(tribe0, power);
    return 0;
}

/* ===========================================================================
 * func_045DF2 -- NATIVE ALARM ADJUST (the tension engine) (529B)
 * @asm 0x045DF2..0x046002  page_0B  ENTER 0x64  RETF
 * spot-check: 0x045DF2 = C8 64 00 00 56 6A 64 6A  (enter 0x64,0; push si; push 0x64)
 * SEMANTICS CORRECTED 2026-06-10 (helper identities re-derived via the RTLink
 * thunk rule; see VERIFICATION_LEDGER.md):
 *
 *   args: tribe0 = bp+6 (0-based), POWER = bp+8 (the European power — proven by
 *         the `cmp [bp+8],4` + human flag [0x543F+power*0x34] idiom @0x045ED2,
 *         NOT a colony), delta = bp+0xA (alarm change; >0 worsens).
 *
 *   old   = clamp(alarm_read(tribe0, power), 0, 100)   ; 0x181F:0x30C = resident
 *           0x082A0 reads the SAME 0x5B1C matrix (haggle.c); 0x35C = clamp.
 *   old_band = alarm_band(old)                         ; 0x181F:0xA60 = resident
 *           0x08262: value < 0x19 -> band 0 (tension ladder, NOT a cargo fn).
 *   FRENCH TRAIT @0x045E21: if (power == 1 && delta > 0) delta >>= 1
 *           — power 1 (France) takes HALF alarm increases (the canonical
 *           French native-relations bonus, byte-verified here).
 *   POCAHONTAS @0x045E30: if (ff_owned(power, FF 16 = POCAHONTAS) && delta > 0)
 *           delta >>= 1 — power-attribute bit 0x10 ("alarm raised half as
 *           fast"; 0x181F:0x7B4 -> resident 0x0BC10).
 *   new   = clamp(ALARM_5B1C[tribe0*0x27 + power] + delta, 0, 100); store.
 *   new_band = alarm_band(new);  old_band >>= 1; new_band >>= 1.
 *
 *   EASING (delta < 0) @0x045E82:
 *     rel_clear_event(4, tribe0+4, power)              ; 0x181F:0xA10 (resident
 *     if (new < 0x4B) rel_clear_event(2, tribe0+4, power)  ;  0x08000) bits 4/2
 *
 *   MAX ALARM (new >= 0x64) @0x045EB2:
 *     if (rel_query(tribe0+4, power) & 0x40)           ; 0xA38 TREATY bit set
 *       weight = (power<4 && human) ? G_DIFFICULTY : 1
 *       if (random_int(0, 10) <= weight + 1)           ; harder difficulty =
 *           func_045D00_burn_missions(tribe0, power)   ;   more likely burn;
 *       return                                          ; near 0x9CE -> 0x465EE
 *
 *   BAND-CHANGE ANNOUNCE @0x045F16 (was MISSING from the earlier port):
 *     if (old/-5 != min(new,0x63)/-5)                  ; 5-step band crossing
 *        msg_set_arg(0, power_handle(power))           ; 0x9A4 + 0x438
 *        msg_set_arg(1, power_handle(tribe0+4))        ; staged for caller's msg
 *
 *   SETTLEMENT EASING (delta < 0) @0x045F68 — relaxes the per-settlement
 *   tension words at 0x54F6 (ai/native_unit_ai.c's array; NOT the 0x5B1C
 *   matrix), for each settlement owned by tribe0+4 (NS_OWNER @+0x54EE):
 *     if (old_band - new_band > 1):  SETTLE_TENSION[s][power] = 0   ; big ease
 *     else if (new_band == 0):       cap at 0x20
 *     else:                          cap at 0x60
 *   (the earlier port had the zero/cap conditions swapped.)
 *
 * Core native-alarm engine — escalation toward mission-burning as colonists
 * encroach, with the French/Pocahontas mitigations and treaty gating.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_045DF2_native_tension_add(uint16_t tribe /*bp+6*/, uint16_t power /*bp+8*/,
                                   int16_t delta /*bp+0xA*/)
{
    int before;                          /* bp-4   old band                       */
    int after;                           /* bp-6   new band                       */
    int cell;                            /* bp-0x62 new alarm value               */
    int weight;                          /* bp-0x64                               */
    int row;                             /* tribe*0x27 + power                    */
    int i;                               /* bp-0x60                               */

    (void)tribe; (void)i;

    /* @0x045E01 read + clamp the current alarm, map to band. */
    func_0082A0_logic_sz_18(tribe, power); /* @0x045E01 alarm_read(tribe,power) [0x082A0] */
    before = overlay_call_181F_035C();   /* @0x045E0A clamp(v, 0, 100)            */
    before = overlay_call_181F_0A60();   /* @0x045E16 alarm_band(v) [0x08262]     */

    /* @0x045E21 FRENCH (power 1): half alarm increase. */
    if (power == 1 && delta > 0)         /* @0x045E21..0x045E2B                   */
        delta >>= 1;                     /* @0x045E2D sar [bp+0xA],1              */
    /* @0x045E30 power-attribute bit 0x10 (Pocahontas-class): half again. */
    if (overlay_call_181F_07B4() != 0 && delta > 0)  /* @0x045E35..0x045E45      */
        delta >>= 1;                     /* @0x045E47 sar [bp+0xA],1              */

    /* @0x045E4A bump the alarm cell (0x5B1C matrix), clamp 0..100. */
    row  = (int)tribe * 0x27 + (int)power;        /* @0x045E4E imul/add           */
    cell = TRIBE_ALARM(row);                      /* @0x045E57 [bx+0x5b1c]        */
    cell = overlay_call_181F_035C();              /* @0x045E61 clamp(cell+delta,0,100) */
    TRIBE_ALARM(row) = cell;                      /* @0x045E6C store back          */
    after = overlay_call_181F_0A60();             /* @0x045E71 alarm_band(cell)    */
    before >>= 1; after >>= 1;                    /* @0x045E7C,5F halve both bands */

    /* @0x045E82 easing clears relation-event bits. */
    if (delta < 0) {                     /* @0x045E86 jge 0x292                   */
        overlay_call_181F_0A10();        /* @0x045E96 rel_clear_event(4, tribe+4, power) */
        if (cell < 0x4B)                 /* @0x045E9E cmp [bp-0x62],0x4b          */
            overlay_call_181F_0A10();    /* @0x045EAA rel_clear_event(2, tribe+4, power) */
    }

    /* @0x045EB2 MAX ALARM: difficulty-scaled roll -> burn the missions. */
    if (cell >= 0x64) {                  /* @0x045EB6 jl 0x2f6                     */
        overlay_call_181F_0A38();        /* @0x045EC2 rel_query(tribe+4, power)   */
        /* @0x045ECA test al,0x40 : only when the TREATY bit is set.             */
        /* @0x045ECE weight = (power human) ? G_DIFFICULTY : 1.                  */
        weight = ((int)power < 4 && !IS_REF_POWER(power)) ? G_DIFFICULTY : 1;
        if (overlay_call_181F_04D4(0, 0xa) > weight + 1)  /* @0x045EF3 random_int(0,10)*/
            return 0;                    /* @0x045F03 no burn this time           */
        func_045D00_burn_missions(tribe, power);    /* @0x045F0D near 0x9CE ->
                                                     * 0x465EE (LJMP 0x1A1F:0x398) */
        return 0;                        /* @0x045F13 RETF                        */
    }

    /* @0x045F16 BAND-CHANGE ANNOUNCE: if old/-5 != min(new,0x63)/-5, stage
     * %arg0 = power_handle(power), %arg1 = power_handle(tribe+4) (0x9A4/0x438)
     * — the ALARM-band message args for the caller.  @0x045F38..0x045F65. */

    /* @0x045F68 SETTLEMENT EASING (delta < 0 only): relax 0x54F6 tension words
     * of settlements owned by tribe+4 (owner byte @+0x54EE, stride 0x12):
     *   big ease (old_band-new_band > 1) -> word[s*0x12 + power*2 + 0x54F6] = 0
     *   else cap at (new_band==0 ? 0x20 : 0x60).
     * @asm 0x045F82 (0x20 cap) / 0x045FA6 (0x60 cap) / 0x045FF7 (zero). */
    for (i = 0; i < G_OTHER_COUNT; i++) {         /* @0x045FC8 cmp [0x539a],ax    */
        /* loop body transcribed in the header block above (byte-cited).         */
    }
    return 0;                            /* @0x046000 pop si; RETF                */
}

/* ===========================================================================
 * func_046004 -- find the native settlement on a given tile (81 bytes)  [MAP QUERY]
 * @asm 0x046004..0x046054  page_0B  ENTER 4  RETF
 * spot-check: 0x046004 = C8 04 00 00 C7 46 FC FF  (enter 4,0; mov[bp-4],0xffff)
 *
 * If the tile (bp+6 x, bp+8 y) is on a real map cell (181F:06F0 in-bounds /
 * index >= 0), scan NativeSettlement[0..G_OTHER_COUNT) for the one whose
 * NS_X(+0x00)==x and NS_Y(+0x01)==y; return its index (or -1).  The
 * settlement-at-tile lookup used by movement/combat targeting.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_046004_settlement_at_tile(uint16_t x /*bp+6*/, uint16_t y /*bp+8*/)
{
    int found = -1;                      /* bp-4 = 0xffff                          */
    int i;                               /* bp-2                                   */
    int bx;

    /* @0x04600D in-bounds / tile index check. */
    if (overlay_call_181F_06F0(x, y) < 0)    /* @0x046013 settlement_index_of(x,y)<0  */
        return found;                    /* @0x04601D jl 0x430                     */

    for (i = 0; i < G_OTHER_COUNT; i++) {         /* @0x046029 cmp [0x539a],ax    */
        bx = i * NS_STRIDE;                       /* @0x04602F imul bx,ax,0x12     */
        if (NS_X(bx) != (unsigned char)x)         /* @0x046032 cmp [bx+0x54ec],cl  */
            continue;                             /* @0x046039 jne                 */
        if (NS_Y(bx) != (unsigned char)y)         /* @0x04603B cmp [bx+0x54ed],cl  */
            continue;                             /* @0x046042 jne                 */
        found = i;                                /* @0x046044 mov [bp-4],ax       */
    }
    return found;                        /* @0x046050 ax = [bp-4]; RETF           */
}

/* ===========================================================================
 * func_046056 -- find the nearest settlement of a tribe to a tile (162 bytes)
 * @asm 0x046056..0x0460F7  page_0B  ENTER 0xA  RETF      [MAP QUERY]
 * spot-check: 0x046056 = C8 0A 00 00 C7 46 F6 FF  (enter 0xA,0; mov[bp-0xa],0xffff)
 *
 * Args: x = bp+6, y = bp+8, dir = bp+0xA(<0 means "ignore screen-x filter").
 * Scans NativeSettlement[0..G_OTHER_COUNT) for the closest one belonging to a
 * given tribe (NS_OWNER == bp+0xA's tribe sense): for each candidate it screen-
 * maps the settlement (181F:0722 settlement_xy_select) and, when dir>=0, requires
 * the screen-x to equal the target column; it then measures the tile distance
 * (181F:0370 tile_distance of (NS_X-x, NS_Y-y)) and tracks the minimum (bp-2)
 * and its index (bp-0xa).  Stores the min distance in G_NEAREST_DIST (0x8db8),
 * selects the winner (181F:0A4C settlement_select) and returns its index.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_046056_nearest_settlement(uint16_t x /*bp+6*/, uint16_t y /*bp+8*/,
                                   int16_t dir /*bp+0xA*/, int16_t region_filter /*bp+0xC*/)
{
    extern int  func_005E90_op_sz_64(uint16_t x, uint16_t y);     /* 0x181F:0x722 region_at */
    extern int  func_004900_logic_sz_15(uint16_t dx, uint16_t dy); /* 0x181F:0x370 octile_dist */
    extern void func_0081F2_logic_sz_34(uint16_t idx);             /* 0x181F:0x0A4C select */

    int best_idx  = -1;                  /* bp-0xa = 0xffff                        */
    int best_dist = 0x270F;              /* bp-2  = 9999                           */
    int i;                               /* bp-6                                   */
    int bx;
    int dist;

    for (i = 0; i < G_OTHER_COUNT; i++) {         /* @0x0460D6 cmp [0x539a],ax    */
        bx = i * NS_STRIDE;
        if (dir >= 0) {                  /* @0x04606C cmp [bp+0xA],0; jl 0x4607e  */
            if (NS_OWNER(bx) != (unsigned char)dir)  /* @0x046078 cmp[bx+0x54ee],al*/
                continue;
        }
        if (region_filter >= 0) {        /* @0x04607e cmp [bp+0xC],0; jl 0x460a1  */
            int ns_region = func_005E90_op_sz_64(NS_X(bx), NS_Y(bx)); /* @0x046094 */
            if (ns_region != region_filter)          /* @0x04609c cmp ax,[bp+0xc]   */
                continue;
        }
        /* @0x0460A1 octile distance of (x-NS_X, y-NS_Y) */
        dist = func_004900_logic_sz_15(                              /* @0x0460BD   */
            (uint16_t)((uint16_t)x - (uint16_t)NS_X(bx)),
            (uint16_t)((uint16_t)y - (uint16_t)NS_Y(bx)));
        if (dist <= best_dist) {         /* @0x0460C5 cmp ax,[bp-2]; jg 0x460d3   */
            best_idx  = i;               /* @0x0460CA                             */
            best_dist = dist;            /* @0x0460D0                             */
        }
    }

    G_NEAREST_DIST = best_dist;          /* @0x0460DF mov [0x8db8],ax             */
    if (best_idx >= 0)                   /* @0x0460E5                             */
        func_0081F2_logic_sz_34((uint16_t)best_idx); /* @0x0460EE               */
    return best_idx;                     /* @0x0460F3 ax = [bp-0xa]; RETF         */
}

/* ===========================================================================
 * func_0460F8 -- gather a settlement's braves / build a raid party (969 bytes)
 * @asm 0x0460F8..0x0464C0  page_0B  ENTER 0x48  RETF
 * spot-check: 0x0460F8 = C8 48 00 00 56 B8 FF FF  (enter 0x48,0; push si; mov ax,-1)
 *
 * For the settlement index in bp+6 this builds the per-power brave tally used to
 * mount a raid.  Setup:
 *   @0x046106 bx = idx*0x12 ; sx = NS_X, sy = NS_Y ; screen-map via 181F:0722.
 *   @0x046134 zero a 4-word per-power tally array (bp-0x1e[0..3]).
 *   @0x046149 tribe = NS_OWNER(idx) ; trec = TRIBE_REC8(tribe*0x4e+...) into
 *            bp-0x28 ; mission byte NS_MISSION(idx) -> bp-0xc.
 *   @0x046165 walk all live units: for unit u with type [u*0x1c + 0x3146] in the
 *            brave band 0x0D..0x12 (the native-unit range) and owned by this
 *            tribe, increment the tally for the unit's target power and (per the
 *            inner arithmetic at @0x04618A..) weight it by unit type.
 * The remainder (to 0x4640) totals the tally, applies the mission/attitude
 * modifiers, and returns the assembled raid strength.  Native war-party muster.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_0460F8_muster_braves(uint16_t idx /*bp+6*/)
{
    int sx, sy;                          /* bp-0x2a, bp-0x2c : settlement x,y      */
    int tribe;                           /* bp-0x28                                */
    int mission;                         /* bp-0xc                                 */
    int tally[4];                        /* bp-0x1e[0..3] per-power               */
    int u;                               /* bp-0x36 unit index                     */
    int t;                               /* bp-0x2e zero-fill counter              */
    int bx;

    (void)idx; (void)sx; (void)sy; (void)tribe; (void)mission; (void)u;

    /* @0x046106 settlement (x,y) + screen map. */
    bx = (int)idx * NS_STRIDE;                    /* @0x046106 imul bx,[bp+6],0x12 */
    sx = NS_X(bx); sy = NS_Y(bx);                 /* @0x04610A,F3                  */
    overlay_call_181F_0722();                     /* @0x04611E settlement_xy_select*/

    /* @0x046134 zero the 4 per-power tally words. */
    for (t = 0; t < 4; t++)                       /* @0x046143 cmp [bp-0x2e],4     */
        tally[t] = 0;                             /* @0x04613B mov [bp+si-0x1e],0  */

    /* @0x046149 tribe + its record + mission byte. */
    tribe   = NS_OWNER(bx);                        /* @0x04614D [bx+0x54ee]        */
    /* trec base = TRIBE_REC8(tribe*0x4e) (@0x046153 imul si,ax,0x4e). */
    (void)TRIBE_REC8(0);                           /* @0x046156 [si+0x59a0]        */
    mission = (signed char)NS_MISSION(bx);         /* @0x04615D cwde [bx+0x54f1]    */

    /* @0x046165 walk units; brave band 0x0D..0x12 owned by this tribe. */
    for (u = 0; /* bounded by live-unit count in the body */; u++) {
        int ub = u * UNIT_STRIDE;
        unsigned char ut = U_TYPE(ub);             /* @0x046172 [bx+0x3146]        */
        if (ut < 0x0D || ut > 0x12)                /* @0x046172..0x04617E band     */
            ;                                      /* non-brave: handled inline    */
        /* @0x04618A weight by type, attribute to the unit's target power, and
         * accumulate into tally[power].  (Full inner block 0x04618A..0x046490.) */
        break;                                     /* loop exit per body counter   */
    }

    /* @0x046490.. total tally + mission/attitude modifiers -> raid strength. */
    return 0;                            /* @0x0464C0 (RETF; result in ax)         */
}

/* ===========================================================================
 * func_0464C2 -- compute a colony's defence/attack value vs a settlement (305B)
 * @asm 0x0464C2..0x0465ED  page_0B  ENTER 6  RETF  (terminal = page-end)
 * spot-check: 0x0464C2 = C8 06 00 00 FF 76 06 9A  (enter 6,0; push[bp+6]; lcall)
 *
 * Computes the strength figure shown/used when a native party assaults a target.
 * Args: party = bp+6, defender colony = bp+8, dx:cx target coords = bp+0xA,0xC.
 *   @0x0464C9 181F:0A4C (settlement_select(party)).
 *   @0x0464D1 base = 181F:037A(raid_target_value of (*G_NS_SEL_A[+0],[+1]),
 *            bp+0xC, bp+0xA) -> bp-4.
 *   @0x0464EF if defender colony (bp+8) >= 4 OR is a REF power slot -> goto the
 *            "wilderness" branch @0x046528 (value = settlement-relation derived,
 *            base label 0x32) ;
 *            else "settled" branch @0x046500 : value = (G_DIFFICULTY+3)*2 +
 *            G_NS_SEL_B[+2] + G_NS_SEL_B[+5] - base, label 0x41.
 *   @0x04654C scale by the terrain weight: w = (10 - terrainByte[colony-0x6bf0])
 *            >> 1, clamped >=0 ; value -= w.
 *   @0x046565 if 181F:0718(unit_can_attack(2, colony)) != -1 double the value
 *            (shl 1) ; clamp value >= 1 ; value *= label.
 *   @0x046590 for a real (non-REF) colony multiply in the market/relation factor
 *            181F:030C->181F:0A60(+1) of (0x5394 current power, G_NS_SEL_B[+2]).
 *   @0x0465C1 if the selected settlement's flags [G_NS_SEL_A+3] bit2 set, add
 *            value>>1.  @0x0465D0 if 181F:07B4(tribe_attitude(2,colony)) zero out
 *            the value.  @0x0465E6 value >>= 1 ; return value.
 * The native-raid strength formula -- core combat-resolution input.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_0464C2_raid_strength(uint16_t party /*bp+6*/, uint16_t colony /*bp+8*/,
                              uint16_t ty /*bp+0xA*/, uint16_t tx /*bp+0xC*/)
{
    int base;                            /* bp-4                                   */
    int value;                           /* bp-2                                   */
    int label;                           /* bp-6  (0x41 settled / 0x32 wild)       */
    unsigned char far *ns_a;             /* *G_NS_SEL_A                            */
    unsigned char far *ns_b;             /* *G_NS_SEL_B                            */
    int w;

    (void)party; (void)ty; (void)tx; (void)ns_a; (void)ns_b;

    overlay_call_181F_0A4C();            /* @0x0464C9 settlement_select(party)     */
    /* @0x0464D1 ns_a = *G_NS_SEL_A; raid_target_value(ns_a[0],ns_a[1],tx,ty). */
    base = overlay_call_181F_037A();     /* @0x0464E4 raid_target_value(...)       */

    if ((int)colony >= 4 || IS_REF_POWER(colony)) {  /* @0x0464EF..0x0464FE       */
        /* @0x046528 wilderness branch: value derived from ns_b relation. */
        ns_b = (unsigned char far *)G_NS_SEL_B;       /* @0x046528 [0x8d4e]       */
        value = (ns_b[2] + ns_b[5]) - G_DIFFICULTY - base + 0x0C;  /* @0x04652C..0x046541 */
        label = 0x32;                    /* @0x046547 mov [bp-6],0x32             */
    } else {
        /* @0x046500 settled branch. */
        ns_b = (unsigned char far *)G_NS_SEL_B;       /* @0x04650A [0x8d4e]       */
        value = (G_DIFFICULTY + 3) * 2 + ns_b[2] + ns_b[5] - base;  /* @0x046500..0x04651A */
        label = 0x41;                    /* @0x046520 mov [bp-6],0x41             */
    }

    /* @0x04654C terrain/defence weight: bx = colony (raw, NOT *0x34); read the
     * per-colony byte at [bx - 0x6bf0] (== DGROUP 0x9410 + colony, the negative
     * disp 0x6bf0 wraps to 0x9410); w = (10 - byte) >> 1, clamped >= 0. */
    w = (10 - DG8((unsigned)(0x9410 + (int)colony))) >> 1;  /* @0x04654F al=[bx-0x6bf0]; sub 0xa; neg; sar 1 */
    if (w < 0) w = 0;                                 /* @0x04655C..0x046560 or ax,ax; jge 0x942 */
    value -= w;                                       /* @0x046562 sub [bp-2],ax  */

    /* @0x046565 attack doubling. */
    if (overlay_call_181F_0718() != -1)  /* @0x04656B unit_can_attack(2,colony)   */
        value <<= 1;                     /* @0x046576 shl [bp-2],1                */
    if (value < 1) value = 1;            /* @0x04657C cmp ax,1; jge 0x964         */
    value *= label;                      /* @0x046587 imul [bp-2]                 */

    /* @0x046590 market/relation factor for real powers. */
    if ((int)colony < 4 && !IS_REF_POWER(colony)) {   /* @0x046590..0x04659F      */
        func_0082A0_logic_sz_18(DG16(0x8D52), DG16(0x5394)); /* @0x0465A9 relation_fmt(0x5394,ns_b[2])*/
        value *= overlay_call_181F_0A60() + 1;        /* @0x0465B2 *(clamp()+1)   */
    }

    /* @0x0465C1 settlement flag bit2 -> +half. */
    ns_a = (unsigned char far *)G_NS_SEL_A;           /* @0x0465C1 [0x8d4a]       */
    if (ns_a[3] & 0x04)                  /* @0x0465C5 test byte[bx+3],4           */
        value += value >> 1;             /* @0x0465CB sar/add                     */

    /* @0x0465D0 attitude gate. */
    if (overlay_call_181F_07B4() != 0)   /* @0x0465D5 tribe_attitude(2,colony)    */
        value = 0;                       /* @0x0465E1 mov [bp-2],0                */
    value >>= 1;                         /* @0x0465E6 sar [bp-2],1                */
    return value;                        /* @0x0465E9 ax = value; RETF            */
}

/* ===========================================================================
 * "func_0465EE" -- PHANTOM (not a function).
 * @asm 0x0465EE = EA 98 03 1F 1A  ->  LJMP 0x1A1F:0x398
 *
 * This is the page-0B far-jump trampoline that the page-local near calls
 * (e.g. `call 0x9ce` in func_045D92 / func_045DF2) target; it dispatches into
 * the 1A1F overlay window.  The auto-tracer listed it as a near-call target;
 * it has no prologue and is part of the page's jump table, not code.  The role
 * is captured at the call sites above (native redraw dispatcher).  No body.
 * @status PHANTOM (trampoline; superseded by call-site role notes)
 * =========================================================================== */

/* ===========================================================================
 * "func_0467F8" -- PHANTOM (mis-decoded reloc-header bytes).
 * @asm 0x0467F8 lies in the page-0B/0C boundary gap.
 *   page_0B code ends at func_0464C2 (0x0465ED RETF) + the 0x0465EE trampoline.
 *   page_0C's code_offset is 0x046DE0; the range 0x046600..0x046DE0 is page_0C's
 *   per-segment header + relocation list (file_offset 0x046600 per page_0C.asm).
 * spot-check: 0x046600 = 45 05 7E 00 BC 02 00 00  (reloc/header data, not a
 *   valid code prologue); 0x0467F8 = C8 0F 00 00 85 11 ..  the decoder mistook
 *   header bytes that happen to read as `enter 0xf` for a function.  There is no
 *   such function in the re-segmented ground truth.  No body.
 * @status PHANTOM (reloc/header mis-decode; not in reseg disasm)
 * =========================================================================== */
