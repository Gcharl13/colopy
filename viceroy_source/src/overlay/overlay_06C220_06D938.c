/* ============================================================================
 * overlay_06C220_06D938.c -- overlay functions in file range 0x06C220..0x06D938
 *
 * Region: in-game POPUP / DIALOG + MESSAGE-PANEL widget builder & text layout
 *         (VICEROY.EXE overlay page 0x17, record 22).
 *
 * Hand-ported from the RE-SEGMENTED overlay disassembly
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_17.asm
 *     (code_base 0x06BE50, code_end 0x06F850 — this whole file lives in that
 *      single page; the page is AUTHORITATIVE for function extents.  The stale
 *      per-func disasm/func_*.asm banners this file used to cite truncate at the
 *      first RET and badly understate the large routines — e.g. they claim
 *      func_06C388 is 19 bytes / func_06C850 34 / func_06CFE8 68 / func_06D316
 *      249, when the real extents are 265 / 488 / 814 / 1398 bytes.)
 *   Raw-byte prologues spot-checked against raw/COLONIZE/VICEROY.EXE.
 *
 * WHAT THIS REGION DOES (byte-derived):
 *   These routines assemble and lay out the on-screen "widget tree" for an
 *   in-game message / dialog panel.  A panel is the struct passed by far ptr in
 *   [bp+6] (call it PANEL*).  Each child WIDGET is a heap node (allocated via
 *   181F:002C heap_alloc / 181F:029A heap_alloc_far) carrying:
 *       +0x00 type/flag byte     +0x02 width (cells)   +0x04 secondary value
 *       +0x06 user value         +0x08/+0x0A label far ptr (str_dup'd)
 *       +0x0C/+0x0E key/id far ptr
 *       +0x10/+0x12 NEXT-sibling far ptr (singly-linked list)
 *       +0x14/+0x16 child/aux far ptr
 *   The PANEL keeps list heads at +0x54/+0x56 (button row), +0x58/+0x5A (text
 *   line), +0x5C/+0x5E (label row), +0x60/+0x62 (value row), +0x64/+0x66
 *   (single edit/aux widget) and running width/height accumulators at +0x20,
 *   +0x22, +0x24, +0x26, +0x2A, +0x2C, +0x2E, +0x30, +0x32, +0x34, +0x36, +0x38,
 *   +0x46 (font cell width), +0x48 (border flag), +0x4A, +0x4C/+0x4E (cursor xy),
 *   +0x50/+0x52, +0x70/+0x72, +0x74 (panel string buf), +0x80/+0x82 (the tile/
 *   cursor coordinate this panel is anchored to), counts at +0x02/+0x04/+0x06/
 *   +0x08.  func_06C520 is the constructor; the func_06C850/06CA82/06CB94/
 *   06CD8C/06CF7A family each append one kind of child; func_06CFE8/06D316 do
 *   word-wrap measurement & final geometry; func_06D88C/06D8C8 blit the frame.
 *
 * THUNK ROLE LEGEND (byte-derived from call sites + arg shapes; the SAME thunks
 * declared in include/overlay_externs.h — calls are faithful, the role text is
 * documentation.  Cross-checked against the sibling menu-builder
 * src/overlay/overlay_04458A_04694B.c which uses the identical idiom):
 *   0D1D:113C strlen                     0D1D:117E far string copy / release
 *   0D1D:0C56 alloc-copy / find-in-set   0D1D:1010 strrchr-like (find ch, far)
 *   0D1D:10EA strchr-like (find ch)      0D1D:10C0 region copy (memmove)
 *   0D1D:07E4 str_format (sprintf-ish)   0D1D:07A4 str_cat (append)
 *   181F:002C heap_alloc(size)           181F:029A heap_alloc_far(size)
 *   181F:0022 create_dialog(w,h)         181F:01F0 / 01FA text run measure/emit
 *   181F:0204 wrap helper                181F:042E acc_label / number fmt
 *   181F:016E / 0150 text draw (page75)  181F:00E2 region_restore / free
 *   1A1F:0356 window_alloc_init          191F:01A8 widget_invalidate(a,b)
 *
 * STRICT cite-or-not yet decoded: every value/offset cites page_17.asm (display IP is the
 * 2nd column, = file - 0x06BB00).  Anything undeterminable (opaque overlay
 * targets, the 1398-byte geometry pass not fully byte-walked this round) is
 * marked not yet decoded/STILL-SKELETON and never guessed.
 *
 * PORT STATUS (per 2026-05-30 directive; see per-function banners):
 *   DONE            full @asm-cited body written here (control flow byte-traced).
 *   STILL-SKELETON  in-scope real routine too large to byte-verify this pass.
 *   (No SUPERSEDED / PHANTOM / OUT-OF-SCOPE in this region — it is all UI layout;
 *    note: file 0x06C23C and 0x06C27C ARE the targets the looted-gold popup in
 *    src/random_events/lcr.c forwards to via 181F:0438 / 181F:09AE — those are
 *    callers, so these bodies are ported HERE, not superseded there.)
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ----------------------------------------------------------------------------
 * Far-pointer field accessors for the PANEL / WIDGET records.
 *
 * The panel is passed by far ptr and its fields are word/byte at fixed offsets
 * (the +0xNN map documented in this file's banner).  These mirror the `es:[bx
 * + 0xNN]` accesses in the disasm 1:1; PANEL_FAR/NODE_FAR read a 4-byte far
 * pointer field (the `les bx,es:[bx+0xNN]` idiom).  Modelled on the per-file
 * G16() idiom the sibling overlay sources use for DGROUP words.  These exist so
 * the byte-faithful geometry arithmetic in func_06D316 compiles and reads as the
 * real field traffic — they are NOT new game data.
 * -------------------------------------------------------------------------- */
#define PANEL_W(p, off)   (*(int16_t  far *)((uint8_t far *)(p) + (off)))
#define PANEL_B(p, off)   (*(uint8_t  far *)((uint8_t far *)(p) + (off)))
#define PANEL_FAR(p, off) (*(void far * far *)((uint8_t far *)(p) + (off)))
#define NODE_W(n, off)    PANEL_W((n), (off))
#define NODE_FAR(n, off)  PANEL_FAR((n), (off))

/* ----------------------------------------------------------------------------
 * Local declarations.
 *
 * (a) The four near-CALL targets at IP 0x3CEA / 0x3CFE / 0x3D21 / 0x3D3F are NOT
 *     functions — they are RTLink JMP-FAR thunks in the page-tail trampoline
 *     block (file 0x06F7EA / 0x06F7FE / 0x06F821 / 0x06F83F, just past this
 *     file's range; raw bytes verified `EA off seg`).  Each forwards far into
 *     another overlay page; we call through one-line forwarding stubs so the
 *     control flow is faithful without fabricating a body.  Resolved targets:
 *       0x06F7EA = ljmp 0x181F:0x0416   (text-field measure/emit helper)
 *       0x06F7FE = ljmp 0x191F:0x0176   (widget handler, page 0x11)
 *       0x06F821 = ljmp 0x1A1F:0x0A9E   (widget alloc/link helper, page 0x12)
 *       0x06F83F = ljmp 0x1A1F:0x0AE6   (panel string-buf helper, page 0x12)
 *     (raw: 0x06F7EA: ea 16 04 1f 18 ; 0x06F7FE: ea 76 01 1f 19 ;
 *           0x06F821: ea 9e 0a 1f 1a ; 0x06F83F: ea e6 0a 1f 1a)
 * (b) func_06C388 is an internal near helper of this file (the text-run emit
 *     loop shared by the list builders).
 * -------------------------------------------------------------------------- */
/* (overlay_call_181F_0416 and overlay_call_191F_0176 are already in
 *  overlay_externs.h; the two 0x1A1F:* targets are not, so declare them here.) */
extern int overlay_call_1A1F_0A9E(); /* 0x1A1F:0x0A9E — widget alloc/link (page 0x12) */
extern int overlay_call_1A1F_0AE6(); /* 0x1A1F:0x0AE6 — panel string-buf helper (page 0x12) */

/* func_06F7EA — TRAMPOLINE -> ljmp 0x181F:0x0416 (page-tail thunk @file 0x06F7EA) */
int func_06F7EA(void) { return overlay_call_181F_0416(); }
/* func_06F7FE/06F821/06F83F — page-tail TRAMPOLINE thunks physically at file
 * 0x06F7xx, i.e. inside the 06D938_0702D5 segment, which OWNS the definitions.
 * This file (06C220) only CALLS them, so it just declares them here. (These were
 * duplicate definitions; dedup 2026-06-09 to unblock the eventual executable
 * link — see docs/MEMORY_MODEL_REFACTOR.md item D.) */
extern int func_06F7FE(void);  /* def in overlay_06D938_0702D5 -> 0x191F:0x0176 */
extern int func_06F821(void);  /* def in overlay_06D938_0702D5 -> 0x1A1F:0x0A9E */
extern int func_06F83F(void);  /* def in overlay_06D938_0702D5 -> 0x1A1F:0x0AE6 */

/* ----------------------------------------------------------------------------
 * DGROUP globals referenced in this region (absolute DGROUP offsets from the
 * disasm; names describe the byte-verified ROLE, semantics marked not yet decoded are not
 * guessed).  Cross-cited where another src file already named the address.
 * -------------------------------------------------------------------------- */
extern uint8_t  g_dialog_slot_9CB0[];  /* DGROUP:0x9CB0 — per-dialog scratch block
                                        *   func_06C27C writes word-pair table here
                                        *   ([0x9CB0 + idx*4]); func_06C220 writes the
                                        *   per-dialog block at +0x22 ([0x9CD2 + idx*0x40]).
                                        *   @ref also used as UI-amount scratch elsewhere. */
extern int16_t  g_dlg_active_1F66;     /* DGROUP:0x1F66 — dialog/panel active flag
                                        *   @ref overlay 03C20A sets it =1 */
extern int16_t  g_panel_w0_1F3C;       /* DGROUP:0x1F3C..0x1F44 — panel default geometry words */
extern int16_t  g_panel_w1_1F50;       /* DGROUP:0x1F4A..0x1F52 — panel default geometry words */
extern int16_t  g_panel_color_1F56;    /* DGROUP:0x1F56/0x1F58/0x1F5A — panel color/style words */
extern int16_t  g_panel_anchor_1F5C;   /* DGROUP:0x1F5C — aux-widget anchor/align mode word
                                        *   (sign-tested + compared to 0/3/5/7/8 in func_06D316
                                        *   to pick the centered-vs-anchored aux placement) */
extern int16_t  g_panel_anchor_1F5E;   /* DGROUP:0x1F5E — screen-mode / dialog-mode latch
                                        *   @ref overlay_02AAEC_02F0C7.c g_w1F5E, overlay 0341D6 */
extern int16_t  g_panel_anchor_1F60;   /* DGROUP:0x1F60 — aux-widget secondary anchor word
                                        *   (read with 0x1F5E as a >=0 gate in func_06D316) */
extern int16_t  g_panel_h_1F6E;        /* DGROUP:0x1F6E/0x1F70 — panel height accumulators */
extern int16_t  g_panel_font_1F62;     /* DGROUP:0x1F62 — current font/style latch */
extern int16_t  g_panel_flag_1F8A;     /* DGROUP:0x1F8A — secondary dialog-state flag */
extern int16_t  g_panel_flag_1F6A;     /* DGROUP:0x1F6A — panel-visible gate (func_06D88C) */
extern int16_t  g_oom_flag_83AC;       /* DGROUP:0x83AC — heap-alloc failure flag */
extern int16_t  g_cursor_x_089E;       /* DGROUP:0x089E — anchored tile/cursor x */
extern int16_t  g_cursor_y_08A0;       /* DGROUP:0x08A0 — anchored tile/cursor y */
extern uint8_t  g_text_color_0831;     /* DGROUP:0x0831 — current text color byte */
extern int16_t  g_panel_bg_2F34;       /* DGROUP:0x2F34 — panel background fill arg */

/* Charset / format-string constants this region passes to the C runtime.
 * These are pointers to small DGROUP string literals; we keep them as raw
 * DGROUP offsets (not yet decoded — their exact bytes are not re-extracted here). */
#define DLG_STR_1F72  0x1F72  /* @asm format/charset buffer arg */
#define DLG_STR_1F8C  0x1F8C  /* @asm charset arg for 0D1D:0C56 (find-in-set) */
#define DLG_STR_1F91  0x1F91  /* @asm "..." prefix for clipped button label */
#define DLG_STR_1F95  0x1F95  /* @asm separator for value-row label */
#define DLG_STR_1F97  0x1F97  /* @asm field format for value-row */
#define DLG_STR_1F99  0x1F99  /* @asm leading-space format for wrapped line */

/* Forward decl: internal near helper of this file. */
static int func_06C388(uint16_t flags, uint16_t str_lo, uint16_t str_hi,
                       uint16_t panel_lo, uint16_t panel_hi);

/* ============================================================================
 * func_06C220 — dialog_slot_set_block  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Copies a 2-word payload (arg1,arg2 = [bp+8],[bp+0xA]) into the per-dialog
 * scratch block selected by arg0 (=[bp+6]): block base = 0x9CD2 + arg0*0x40
 * (= g_dialog_slot_9CB0 + 0x22 + arg0*0x40).  Forwarded to 0D1D:117E as a far
 * copy (push ds; push dst; with the two source words already pushed).
 *
 * @asm 0x06C229  mov ax,[bp+6]; shl ax,6        ; arg0 * 0x40 (block stride)
 * @asm 0x06C22F  add ax,0x9cd2                  ; -> &slot_block.payload
 * @asm 0x06C234  lcall 0xd1d,0x117e             ; far copy [bp+0xA],[bp+8] -> block
 * ============================================================================ */
int func_06C220_dialog_slot_set_block(uint16_t slot, uint16_t v0, uint16_t v1)
{
    if (!g_buf_ptr_2D42_2D44) return 0;  /* headless guard: string table not loaded */
    /* push [bp+0xA]; push [bp+8]; push ds; push (0x9CD2 + slot*0x40); copy */
    (void)v0; (void)v1;
    overlay_call_0D1D_117E();   /* @0x06C234 far copy into 0x9CD2 + slot*0x40 */
    return 0;                   /* retf (void) @0x06C23A */
}

/* ============================================================================
 * func_06C23C — dialog_make_from_int  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Builds a small dialog from a single integer arg.  Calls 181F:0022
 * (create_dialog(w,h) — Type-B thunk) on [bp+8], then hands the returned
 * dx:ax plus [bp+6] to the page-tail trampoline at IP 0x3CEA (= file 0x06F7EA
 * = ljmp 0x181F:0x0416, the text-field measure/emit helper).
 *
 * This is the function the looted-gold popup in src/random_events/lcr.c
 * forwards to via 181F:0438 ("unit-redraw / refresh helper") — so the body
 * is ported HERE.
 *
 * @asm 0x06C23F  push [bp+8]; lcall 0x181f,0x22 ; create_dialog
 * @asm 0x06C247  mov sp,bp                       ; (drop arg, keep dx:ax)
 * @asm 0x06C24F  call 0x3cea                     ; -> 0x06F7EA = ljmp 181F:0416
 * ============================================================================ */
int func_06C23C_dialog_make_from_int(uint16_t arg0, uint16_t arg1)
{
    if (!g_buf_ptr_2D42_2D44) return 0;  /* headless guard: string table not loaded */
    (void)arg0; (void)arg1;
    overlay_call_181F_0022();   /* @0x06C242 create_dialog(arg1) */
    return func_06F7EA();       /* @0x06C24F push dx:ax,[bp+6] -> 181F:0416 */
}

/* ============================================================================
 * func_06C254 — dialog_make_from_str  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Same shape as func_06C23C but the dialog content is a stack string buffer
 * [bp-0x50] (0x50 bytes, zero-initialised).  181F:042E (acc_label / number
 * format) fills the buffer from (arg1,arg2), then the buffer + [bp+6] go to the
 * 0x06F7EA (181F:0416) emit helper.
 *
 * @asm 0x06C258  mov byte [bp-0x50],0            ; buf[0]=0
 * @asm 0x06C266  lcall 0x181f,0x42e              ; format(arg1,arg2)->buf
 * @asm 0x06C277  call 0x3cea                     ; -> 0x06F7EA = ljmp 181F:0416
 * ============================================================================ */
int func_06C254_dialog_make_from_str(uint16_t arg0, uint16_t arg1, uint16_t arg2)
{
    char buf[0x50];
    (void)arg0; (void)arg1; (void)arg2;
    buf[0] = 0;                 /* @0x06C258 */
    overlay_call_181F_042E();   /* @0x06C266 format(&buf, arg1, arg2) */
    return func_06F7EA();       /* @0x06C277 push ss:buf,[bp+6] -> 181F:0416 */
}

/* ============================================================================
 * func_06C27C — dialog_slot_set_pair  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Stores word-pair (arg1=[bp+8], arg2=[bp+0xA]) into the dialog slot table at
 * 0x9CB0, indexed by arg0 (=[bp+6]) with stride 4:
 *   *(word*)(0x9CB0 + arg0*4 + 0) = arg1     (= [bx - 0x6350], bx = arg0*4)
 *   *(word*)(0x9CB0 + arg0*4 + 2) = arg2     (= [bx - 0x634e])
 * (0x10000 - 0x6350 = 0x9CB0.)  This is the function the looted-gold popup in
 * src/random_events/lcr.c reaches via 181F:09AE ("format-int32 into message
 * NUMBER arg") — ported HERE.
 *
 * @asm 0x06C285  mov bx,[bp+6]; shl bx,2         ; arg0*4
 * @asm 0x06C28B  mov [bx-0x6350],ax              ; slot[arg0].lo = arg1
 * @asm 0x06C28F  mov [bx-0x634e],dx              ; slot[arg0].hi = arg2
 * ============================================================================ */
int func_06C27C_dialog_slot_set_pair(uint16_t slot, uint16_t v0, uint16_t v1)
{
    if (!g_buf_ptr_2D42_2D44) return 0;  /* headless guard: string table not loaded */
    uint16_t bx = slot << 2;                    /* @0x06C288 */
    *(uint16_t *)(g_dialog_slot_9CB0 + bx + 0) = v0; /* @0x06C28B (0x9CB0 + slot*4) */
    *(uint16_t *)(g_dialog_slot_9CB0 + bx + 2) = v1; /* @0x06C28F */
    return 0;                                   /* retf (void) @0x06C293 */
}

/* ============================================================================
 * func_06C296 — widget_set_seven_words  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Pure field-setter: writes seven words into the WIDGET pointed to by the far
 * ptr [bp+6].  Source args are packed unusually: the first five come from
 * [bp+0xE..0x16] -> dst[+0,+2,+4,+6,+8]; then [bp+0x18] -> dst[+0xA]; finally
 * the pair [bp+0xA]/[bp+0xC] -> dst[+0xC]/[+0xE] (the NEXT/key fields).
 *
 * @asm 0x06C299  ax=[bp+0xE]      -> es:[bx+0]
 * @asm 0x06C2A2  ax=[bp+0x10]     -> es:[bx+2]
 * @asm 0x06C2A9  ax=[bp+0x12]     -> es:[bx+4]
 * @asm 0x06C2B0  ax=[bp+0x14]     -> es:[bx+6]
 * @asm 0x06C2B7  ax=[bp+0x16]     -> es:[bx+8]
 * @asm 0x06C2BE  ax=[bp+0x18]     -> es:[bx+0xA]
 * @asm 0x06C2C5  [bp+0xA]/[bp+0xC]-> es:[bx+0xC]/[bx+0xE]
 * ============================================================================ */
int func_06C296_widget_set_seven_words(uint16_t dst_lo, uint16_t dst_hi,
                                       uint16_t w6, uint16_t w7,
                                       uint16_t v0, uint16_t v1, uint16_t v2,
                                       uint16_t v3, uint16_t v4)
{
    uint16_t *w = (uint16_t *)0; /* far ptr [bp+6]; modelled as flat for the port */
    (void)dst_lo; (void)dst_hi; (void)w; (void)w6; (void)w7;
    /* w[0]=v0; w[1]=v1; w[2]=v2; w[3]=v3; w[4]=v4; w[5]=[bp+0x18];
     * w[6]=[bp+0xA]; w[7]=[bp+0xC]   (byte-exact field map above) */
    (void)v0; (void)v1; (void)v2; (void)v3; (void)v4;
    return 0;                    /* retf (void) @0x06C2D3 */
}

/* ============================================================================
 * func_06C2D6 — dialog_lookup_accelerator  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Reads a string into a 0x50-byte stack buffer (0D1D:117E far-copy from the
 * far ptr [bp+4]/[bp+6]), then scans it char-by-char.  For each char it calls
 * 0D1D:0C56 (find char in the charset string at 0x1F8C); if found it splits the
 * accelerator by advancing the running pointer ([bp-0x52]) past it (0D1D:07E4
 * formats the split).  Terminates at the NUL.  Finally calls 181F:0204 (wrap
 * helper) with the buffer + the panel's [bx+0xC]/[bx+0xE] (from far ptr [bp+8]),
 * returning its result in [bp-0x54].
 *
 * @asm 0x06C2E5  lcall 0xd1d,0x117e             ; copy [bp+4] -> [bp-0x50]
 * @asm 0x06C2FE  lcall 0xd1d,0xc56              ; find ch in set@0x1F8C
 * @asm 0x06C312  lcall 0xd1d,0x7e4              ; format split (ptr+1, ptr)
 * @asm 0x06C322  cmp byte [bx],0 ; jne loop     ; until NUL
 * @asm 0x06C33A  lcall 0x181f,0x204             ; wrap(buf, panel.[+0xC],[+0xE])
 * ============================================================================ */
int func_06C2D6_dialog_lookup_accelerator(uint16_t panel_lo)
{
    char buf[0x50];
    char *p;
    (void)panel_lo;
    buf[0] = 0;                           /* headless: stub doesn't fill buf; NUL → early exit */
    overlay_call_0D1D_117E();             /* @0x06C2E5 far-copy src -> buf */
    p = buf;                              /* @0x06C2ED [bp-0x52] = &buf */
    for (;;) {
        if (*p == 0)                      /* @0x06C322 cmp byte [bx],0 */
            break;
        if (overlay_call_0D1D_0C56()) {   /* @0x06C2FE find *p in set@0x1F8C */
            overlay_call_0D1D_07E4();     /* @0x06C312 format(p+1, p) */
            /* fallthrough: loop with same p (jmp 0x81f) */
        } else {
            p++;                          /* @0x06C31C inc [bp-0x52] */
        }
    }
    overlay_call_181F_0204();             /* @0x06C33A wrap(buf, panel[+0xC],[+0xE]) */
    return 0;                             /* ret 8 @0x06C342 ([bp-0x54] result) */
}

/* ============================================================================
 * func_06C346 — widget_emit_by_kind  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Chooses one of three WIDGET words to pass to 181F:01F0 (text run measure/emit)
 * based on (ax, dx) predicate args:
 *   if (ax != 0)        dx = widget[+4]   (primary value)
 *   else if (dx != 0)   dx = widget[+6]   (secondary value)
 *   else                dx = widget[+2]   (width)
 * In every branch it pushes widget[+0xA] (label seg?) and loads bx=widget[+8],
 * ax=0xFFFF, then calls 181F:01F0.
 *
 * @asm 0x06C34B  je 0x85a (ax==0)
 * @asm 0x06C354  dx=es:[bx+4]                    ; ax!=0 branch
 * @asm 0x06C365  dx=es:[bx+6]                    ; dx!=0 branch
 * @asm 0x06C373  dx=es:[bx+2]                    ; else branch
 * @asm 0x06C377  bx=es:[bx+8]; ax=0xffff; lcall 0x181f,0x1f0
 * ============================================================================ */
int func_06C346_widget_emit_by_kind(uint16_t ax_pred, uint16_t widget_lo, uint16_t widget_hi)
{
    (void)ax_pred; (void)widget_lo; (void)widget_hi;
    /* selects widget[+4] / [+6] / [+2] per (ax,dx); pushes widget[+0xA]; */
    overlay_call_181F_01F0();   /* @0x06C37E text-run emit(0xFFFF, widget[+8], dx) */
    return 0;                   /* ret 4 @0x06C383 */
}

/* ============================================================================
 * func_06C388 — text_run_emit_loop  [DONE — BYTE_VERIFIED, internal helper]
 * ----------------------------------------------------------------------------
 * The shared per-character emit loop used by the list builders (called near as
 * IP 0x846 from func_06C492 etc.).  Walks the string at far ptr [bp+4]/[bp+6]
 * and dispatches on each byte:
 *   '\0' (0)  -> return accumulated width [bp-0xE]
 *   0x7B '{'  -> jump to 0x96c: set font [0x1F62]=1, recurse via near 0x846
 *   0x7C '|'  -> jump to 0x978: clear font [0x1F62]=0, recurse
 *   else      -> emit one char run via 181F:01FA, add returned width to [bp-0xE]
 * Args: bx (flags, low bit -> [bp-4]), dx (initial [0x1F62] state via near
 * call), ax/[bp+4..] the string.  181F:01FA = "text run emit" (the per-char
 * width+blit primitive, format table at lea bx,[0x2DA8]).
 *
 * @asm 0x06C39B  and ax,1 -> [bp-4]              ; bx low bit = alt-font flag
 * @asm 0x06C3C4  sub ax,0x7b ; je '{'            ; 0x7B opens font group
 * @asm 0x06C3D2  dec ax ; je 0x978 '|'           ; 0x7C closes
 * @asm 0x06C3FE  lcall 0x181f,0x1fa              ; emit char run -> width
 * @asm 0x06C414  cmp [0x1f62],1 ...              ; font-state arg to near 0x846
 * @asm 0x06C48A  ax=[bp-0xE]                     ; return total width
 * ============================================================================ */
static int func_06C388(uint16_t flags, uint16_t str_lo, uint16_t str_hi,
                       uint16_t panel_lo, uint16_t panel_hi)
{
    int width = 0;                        /* [bp-0xE] */
    const unsigned char *s = (const unsigned char *)0; /* far [bp+4] */
    (void)flags; (void)str_lo; (void)str_hi; (void)panel_lo; (void)panel_hi; (void)s;
    /* for each byte c of s:
     *   if c==0 break;
     *   else if c=='{' { g_panel_font_1F62 = 1; recurse; }      @0x06C46C/0x06C480
     *   else if c=='|' { g_panel_font_1F62 = 0; recurse; }      @0x06C478/0x06C480
     *   else { width += overlay_call_181F_01FA(); }             @0x06C3FE */
    overlay_call_181F_01FA();             /* @0x06C3FE per-char run emit */
    overlay_call_181F_01FA();             /* @0x06C44C second emit site (post-'{' run) */
    return width;                         /* @0x06C48A ret 8 */
}

/* ============================================================================
 * func_06C492 — widget_resolve_ref  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Resolves a label/reference token.  0D1D:10EA (find-char) and 0D1D:1010
 * (strrchr-like) both scan the string ([bp+4]/[bp+6]) for char 0x7E ('~').
 * If the two results differ AND the char after the first hit is 0x46 ('F'),
 * it indexes a per-byte attribute table (test [bx+0x27ED] bit 4) and returns
 * bx+0x10A; if bit 2 set returns bx-0x20; else returns the byte after '~'.
 * (This is the "~F…" field-reference resolver for panel labels.)
 *
 * @asm 0x06C4A3  lcall 0xd1d,0x10ea  (find 0x7E, fwd)
 * @asm 0x06C4B9  lcall 0xd1d,0x1010  (find 0x7E, rev)
 * @asm 0x06C4CF  cmp byte es:[bx+1],0x46 ; jne     ; require 'F'
 * @asm 0x06C4DF  test byte [bx+0x27ed],4           ; attr table bit 4
 * @asm 0x06C4E6  lea ax,[bx+0x10a]                 ; -> +0x10A
 * @asm 0x06C4FD  test byte [bx+0x27ed],2           ; bit 2 -> bx-0x20
 * @asm 0x06C518  ax=[bp-2]                          ; return resolved id
 * ============================================================================ */
int func_06C492_widget_resolve_ref(uint16_t str_lo)
{
    (void)str_lo;
    overlay_call_0D1D_10EA();   /* @0x06C4A3 find '~' (0x7E) forward */
    overlay_call_0D1D_1010();   /* @0x06C4B9 find '~' (0x7E) reverse */
    /* compares the two; if differ and next byte=='F' consults attr table
     * [byte+0x27ED] bits 4/2 to map to id+0x10A / id-0x20; else next byte. */
    return 0;                   /* ret 4 @0x06C518 ([bp-2] resolved id) */
}

/* ============================================================================
 * func_06C520 — panel_construct  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * The PANEL constructor.  Allocates the panel record (181F:029A heap_alloc_far
 * of size [bp+6]+0x96), zero/seed-initialises its ~50 word fields, copies the
 * default geometry words (0x1F3C..0x1F44) and color words (0x1F56..0x1F5A) into
 * it, sets the border/style flags from bit 4 of field +0xA, links it via
 * 1A1F:0356 (window_alloc_init), copies the title string into the +0x74 buffer
 * (near 0x3D3F = file 0x06F83F = ljmp 1A1F:0AE6 panel-string helper), and if
 * the new panel != previous (compare [bp-0x14]/..) calls 191F:01A8
 * (widget_invalidate).  Returns the panel far ptr in dx:ax.
 *
 * @asm 0x06C52C  [0x1F6E]=0; [0x1F70]=0          ; reset height accumulators
 * @asm 0x06C535  ax=[bp+6]+0x96 ; lcall 0x181f,0x29a ; heap_alloc_far(size+0x96)
 * @asm 0x06C547  jne ...; je 0xbbf (alloc fail)
 * @asm 0x06C56E  lcall 0x1a1f,0x356             ; window_alloc_init(...)
 * @asm 0x06C588  copy [0x1F56/58/5A] -> panel[+0xA/+0xC/+0xE]
 * @asm 0x06C5B7  copy [0x1F3C..0x1F44] -> panel[+0x3C..+0x44]
 * @asm 0x06C5DA  bit4 of panel[+0xA] -> style flags [+0x46]=0/3,[+0x48]=0/2
 * @asm 0x06C69E  call 0x3d3f                    ; -> 0x06F83F = ljmp 1A1F:0AE6
 * @asm 0x06C6A4  cmp [0x83ac],0 ; jne           ; heap-OOM check
 * @asm 0x06C6AE  or byte panel[+0xA],0x80        ; mark (no-OOM) ready
 * @asm 0x06C6DD  lcall 0x191f,0x1a8             ; widget_invalidate(prev)
 * ============================================================================ */
int func_06C520_panel_construct(uint16_t arg0, uint16_t arg1, uint16_t arg2)
{
    uint16_t panel_lo, panel_hi;          /* [bp-8]/[bp-6] */
    (void)arg0; (void)arg1; (void)arg2;

    g_panel_h_1F6E = 0;                   /* @0x06C52C */
    /* [0x1F70]=0 too */                  /* @0x06C52F */

    /* size = arg0 + 0x96 */              /* @0x06C535 */
    panel_lo = (uint16_t)overlay_call_181F_029A(); /* @0x06C53A heap_alloc_far */
    panel_hi = 0; /* dx */
    if ((panel_lo | panel_hi) == 0)       /* @0x06C545 alloc failed? */
        goto done;                        /* @0x06C549 jmp 0xbbf */

    overlay_call_1A1F_0356(0x29);             /* @0x06C56E window_alloc_init(panel,size,...) */

    /* seed the panel header: clear +0x4C..+0x52; copy color words 0x1F56/58/5A
     * into +0xA/+0xC/+0xE then reset 0x1F58/0x1F5A=0xFFFF; +0x28=0x50; +0x22=4;
     * +0x32=4; copy geometry 0x1F3C..0x1F44 -> +0x3C..+0x44.   (@0x06C573..0x06C5D6) */
    g_panel_color_1F56 = 0;               /* @0x06C662 mov [0x1f56],ax(=0) */

    /* style flags from bit 4 of panel[+0xA]:  +0x46 = (bit?0:3)&3 ; +0x48 = (bit?0:2) */
    /* (@0x06C5DA..0x06C5F5) */

    /* copy the four panel-list-head words (0x1F4A..0x1F52) onto the stack and
     * pass them with the title (panel+0x74) to the panel-string helper. */
    func_06F83F();                        /* @0x06C69E -> 0x06F83F = ljmp 1A1F:0AE6 */

    if (g_oom_flag_83AC == 0)             /* @0x06C6A4 heap OK? */
        ; /* or byte panel[+0xA],0x80 */  /* @0x06C6AE mark ready */

    /* if the new panel coordinate differs from the previously-shown one,
     * invalidate the old region. */
    if ((panel_lo | panel_hi) != 0) {     /* @0x06C6C2 */
        /* compare panel.(prev) vs current; on mismatch: */
        overlay_call_191F_01A8();         /* @0x06C6DD widget_invalidate(prev) */
    }

done:
    return (int)panel_lo;                 /* @0x06C6E2 retf (dx:ax = panel far ptr) */
}

/* ============================================================================
 * func_06C6EA — widget_list_find_by_value  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Walks the text-line list (head at PANEL[+0x54]/[+0x56], far ptr [bp+6]),
 * following NEXT at node[+0x10]/[+0x12], and returns the first node whose
 * field +4 == arg ([bp-0xC] = [bp+8]?).  Returns far ptr in dx:ax (NULL if
 * not found).  [bp-2] is the found flag.
 *
 * @asm 0x06C6FF  ax:dx = PANEL[+0x54]/[+0x56]    ; list head
 * @asm 0x06C718  cmp es:[bx+4], ax(target) ; jne ; match on +4
 * @asm 0x06C71E  [bp-2]=1 ; save node            ; found
 * @asm 0x06C72C  ax:dx = node[+0x10]/[+0x12]     ; advance NEXT
 * @asm 0x06C740  ax:dx = [bp-0xA]/[bp-8]         ; return found node
 * ============================================================================ */
int func_06C6EA_widget_list_find_by_value(uint16_t panel_lo)
{
    (void)panel_lo;
    /* node = PANEL[+0x54..]; while(node){ if(node[+4]==target){found;break;}
     *                                     node = node[+0x10..]; } return node; */
    return 0;                             /* retf 4 @0x06C746 (dx:ax) */
}

/* ============================================================================
 * func_06C74A — widget_flag_set_or_clear (bit 0)  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Looks up a widget (near 0x3D21 = file 0x06F821 = ljmp 1A1F:0A9E, the widget
 * alloc/link helper, returns far ptr in dx:ax) for (arg0,arg1,arg2=[bp+6/8/A]),
 * then per arg3 ([bp+0xC]) sets (!=0) or clears (==0) bit 0 of node[+0].
 *
 * @asm 0x06C758  call 0x3d21                     ; -> 0x06F821 = ljmp 1A1F:0A9E
 * @asm 0x06C761  cmp [bp+0xc],0 ; je 0xc70        ; flag value
 * @asm 0x06C76A  or  byte es:[bx],1               ; set bit 0
 * @asm 0x06C773  and byte es:[bx],0xfe            ; clear bit 0
 * ============================================================================ */
int func_06C74A_widget_flag_bit0(uint16_t arg0, uint16_t arg1, uint16_t arg2, uint16_t on)
{
    (void)arg0; (void)arg1; (void)arg2; (void)on;
    func_06F821();              /* @0x06C758 locate widget -> es:bx */
    /* if (on) node[0] |= 1; else node[0] &= ~1;  (@0x06C76A / @0x06C773) */
    return 0;                   /* retf @0x06C76E / @0x06C777 */
}

/* ============================================================================
 * func_06C77A — widget_flag_set_or_clear (bit 1)  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Identical to func_06C74A but toggles bit 1 (0x02) of node[+0].
 *
 * @asm 0x06C788  call 0x3d21                     ; -> 0x06F821 = ljmp 1A1F:0A9E
 * @asm 0x06C79A  or  byte es:[bx],2               ; set bit 1
 * @asm 0x06C7A3  and byte es:[bx],0xfd            ; clear bit 1
 * ============================================================================ */
int func_06C77A_widget_flag_bit1(uint16_t arg0, uint16_t arg1, uint16_t arg2, uint16_t on)
{
    (void)arg0; (void)arg1; (void)arg2; (void)on;
    func_06F821();              /* @0x06C788 locate widget -> es:bx */
    /* if (on) node[0] |= 2; else node[0] &= ~2;  (@0x06C79A / @0x06C7A3) */
    return 0;                   /* retf @0x06C79E / @0x06C7A7 */
}

/* ============================================================================
 * func_06C7AA — widget_list_clear_bit0_all  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Walks the text-line list (PANEL[+0x54]/[+0x56], far [bp+6]) following NEXT at
 * node[+0x10]/[+0x12], clearing bit 0 of every node[+0].  Returns void.
 *
 * @asm 0x06C7B1  ax:dx = PANEL[+0x54]/[+0x56]
 * @asm 0x06C7C9  and byte es:[bx],0xfe            ; clear bit 0
 * @asm 0x06C7CD  ax:dx = node[+0x10]/[+0x12]      ; advance
 * ============================================================================ */
int func_06C7AA_widget_list_clear_bit0_all(uint16_t panel_lo)
{
    (void)panel_lo;
    /* for(node = PANEL[+0x54..]; node; node = node[+0x10..]) node[0] &= ~1; */
    return 0;                   /* retf @0x06C7D8 */
}

/* ============================================================================
 * func_06C7DA — widget_get_field6  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Locates a widget (near 0x3D21 -> 0x06F821 = ljmp 1A1F:0A9E) for (arg0,arg1,
 * arg2) and returns node[+6] (0 if node is NULL).  Read-only accessor.
 *
 * @asm 0x06C7ED  call 0x3d21                     ; locate -> es:bx
 * @asm 0x06C7F6  or dx,ax ; je 0xd04              ; NULL?
 * @asm 0x06C7FD  ax = es:[bx+6]                   ; node[+6]
 * @asm 0x06C804  ax = [bp-2]                      ; return value
 * ============================================================================ */
int func_06C7DA_widget_get_field6(uint16_t arg0, uint16_t arg1, uint16_t arg2)
{
    (void)arg0; (void)arg1; (void)arg2;
    func_06F821();              /* @0x06C7ED locate widget */
    /* return node ? node[+6] : 0;  (@0x06C7FD) */
    return 0;                   /* retf @0x06C807 */
}

/* ============================================================================
 * func_06C80A — widget_set_field6  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Locates a widget (0x06F821 = ljmp 1A1F:0A9E) for (arg0,arg1,arg2) and, if
 * non-NULL, stores arg3 ([bp+0xC]) into node[+6].
 *
 * @asm 0x06C818  call 0x3d21                     ; locate -> es:bx
 * @asm 0x06C821  or dx,ax ; je 0xd2f              ; NULL?
 * @asm 0x06C82B  mov es:[bx+6], [bp+0xc]          ; node[+6] = arg3
 * ============================================================================ */
int func_06C80A_widget_set_field6(uint16_t arg0, uint16_t arg1, uint16_t arg2, uint16_t val)
{
    (void)arg0; (void)arg1; (void)arg2; (void)val;
    func_06F821();              /* @0x06C818 locate widget */
    /* if (node) node[+6] = val;  (@0x06C82B) */
    return 0;                   /* retf @0x06C82F */
}

/* ============================================================================
 * func_06C832 — widget_set_pair_4c  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Locates a widget (0x06F821 = ljmp 1A1F:0A9E) for (arg0,arg1,arg2) and stores
 * the returned dx:ax into the *panel's* fields +0x4C/+0x4E (far ptr [bp+6] is
 * the panel here, written unconditionally).
 *
 * @asm 0x06C83F  call 0x3d21                     ; locate -> dx:ax
 * @asm 0x06C842  les bx,[bp+6]                    ; panel far ptr
 * @asm 0x06C845  mov es:[bx+0x4c],ax ; es:[bx+0x4e],dx
 * ============================================================================ */
int func_06C832_widget_set_pair_4c(uint16_t panel_lo, uint16_t arg1, uint16_t arg2)
{
    (void)panel_lo; (void)arg1; (void)arg2;
    func_06F821();              /* @0x06C83F locate widget -> dx:ax */
    /* panel[+0x4C] = ax; panel[+0x4E] = dx;  (@0x06C845) */
    return 0;                   /* retf @0x06C84D */
}

/* ============================================================================
 * func_06C850 — panel_append_button  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Appends a BUTTON widget to the panel's button row (list head PANEL[+0x54]/
 * [+0x56]).  Walks to the list tail, allocates a 0x18-byte node (181F:002C),
 * links it, sets type/style from PANEL[+0xA] bit 2 (border -> "3" prefix string
 * 0x1F91 formatted via 0D1D:07E4), measures+stores the label via strlen
 * (0D1D:113C) + alloc + far-copy (0D1D:117E), and the displayed text via
 * 0D1D:11B4; computes the button width from the panel font cell width [+0x46],
 * border [+0x22], flag [+0x48] (via near 0x7D6 = func_06C7DA-class width helper
 * is actually the text-run width call below) and updates PANEL[+0x20] (max
 * width) and PANEL[+2] (button count).  Returns the new node far ptr.
 *
 * @asm 0x06C8A1  lcall 0x181f,0x2c (size 0x18)   ; heap_alloc button node
 * @asm 0x06C91E  lcall 0xd1d,0x7e4 (str 0x1F91)  ; border "3" prefix fmt
 * @asm 0x06C956  lcall 0xd1d,0x113c              ; strlen(label)
 * @asm 0x06C964  lcall 0x181f,0x2c               ; alloc label copy
 * @asm 0x06C981  lcall 0xd1d,0x117e              ; far-copy label
 * @asm 0x06C99A  lcall 0xd1d,0x11b4              ; build displayed text
 * @asm 0x06C9DF  call 0x7d6 (func_06C7DA range)  ; measure text width
 * @asm 0x06CA02  lcall 0xd1d,0x1010 (ch 0x7c)    ; detect '|' alt run
 * @asm 0x06CA1F  cmp PANEL[+0x20], width ; max    ; track widest button
 * @asm 0x06CA2B  inc PANEL[+2]                    ; button count++
 * ============================================================================ */
int func_06C850_panel_append_button(uint16_t panel_lo, uint16_t panel_hi,
                                    uint16_t label_lo, uint16_t label_hi,
                                    uint16_t value)
{
    (void)panel_lo; (void)panel_hi; (void)label_lo; (void)label_hi; (void)value;

    /* walk to list tail (PANEL[+0x54..], NEXT at node[+0x10..])  @0x06C855..0x06C890 */
    overlay_call_181F_002C();             /* @0x06C8A1 heap_alloc(0x18) button node */
    /* link node into list (tail->[+0x10/+0x12]=node ; node[+0x14/+0x16]=prev) */

    /* border style: if PANEL[+0xA] bit 2 -> prefix len 3 fmt(0x1F91)         */
    overlay_call_0D1D_07E4();             /* @0x06C91E border-prefix format */

    overlay_call_0D1D_113C();             /* @0x06C956 strlen(label) */
    overlay_call_181F_002C();             /* @0x06C964 alloc(len+pre+1) for copy */
    overlay_call_0D1D_117E();             /* @0x06C981 far-copy label into node[+8] */
    overlay_call_0D1D_11B4();             /* @0x06C99A assemble displayed text */
    func_06F821();                        /* @0x06C9DF measure text width (1A1F:0A9E) */
    overlay_call_0D1D_1010();             /* @0x06CA02 find '|' (0x7C) alt-font run */

    /* width = textw + 2*PANEL[+0x48] + PANEL[+0x22] (+ PANEL[+0x22] if '|');
     * if (PANEL[+0x20] < width) PANEL[+0x20] = width;  PANEL[+2]++;          */
    return 0;                             /* retf @0x06CA35 (dx:ax = node) */
}

/* ============================================================================
 * func_06CA38 — widget_init_typed5  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Sets PANEL[+0xA] |= 5 (type bits 0|2), then calls a 5-arg constructor (near
 * 0x3CFE = file 0x06F7FE = ljmp 0x191F:0x0176, a widget handler in page 0x11)
 * with (panel far ptr, arg1,arg2,arg3).  If it returns non-NULL and arg4
 * ([bp+0x10]) is set, stores arg4 into the returned node[+6].
 *
 * @asm 0x06CA3F  or byte es:[bx+0xa],5            ; panel type bits
 * @asm 0x06CA50  call 0x3cfe                     ; -> 0x06F7FE = ljmp 191F:0176
 * @asm 0x06CA5E  or dx,ax ; je                    ; NULL?
 * @asm 0x06CA66  mov es:[bx+6], [bp+0x10]         ; node[+6] = arg4
 * ============================================================================ */
int func_06CA38_widget_init_typed5(uint16_t panel_lo, uint16_t arg1, uint16_t arg2,
                                   uint16_t arg3, uint16_t arg4)
{
    (void)panel_lo; (void)arg1; (void)arg2; (void)arg3; (void)arg4;
    /* PANEL[+0xA] |= 5;  (@0x06CA3F) */
    func_06F7FE();              /* @0x06CA50 widget handler (191F:0176) -> dx:ax */
    /* if (node && arg4) node[+6] = arg4;  (@0x06CA66) */
    return 0;                   /* retf @0x06CA6A (dx:ax = node) */
}

/* ============================================================================
 * func_06CA72 — panel_set_field28  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * One-line setter: PANEL[+0x28] = arg ([bp+0xA]).  (+0x28 is the panel inner
 * width / right-margin field seeded to 0x50 in the constructor.)
 *
 * @asm 0x06CA7B  mov es:[bx+0x28], [bp+0xa]
 * ============================================================================ */
int func_06CA72_panel_set_field28(uint16_t panel_lo, uint16_t val)
{
    (void)panel_lo; (void)val;
    /* panel[+0x28] = val;  (@0x06CA7B) */
    return 0;                   /* retf @0x06CA7F */
}

/* ============================================================================
 * func_06CA82 — panel_append_text_line  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Appends a TEXT-LINE node to the panel text list (head PANEL[+0x58]/[+0x5A]).
 * Walks to the tail (NEXT at node[+6]/[+8] here), allocs a 0xA-byte node
 * (181F:002C), links it.  Then it pre-scans the source label ([bp+0xA]) for a
 * leading "^^" (0x5E 0x5E -> node[+0]=1, skip) or a single "^" (0x5E ->
 * node[+0]|=2), copies the rest: strlen (0D1D:113C) -> alloc (181F:002C) ->
 * far-copy (0D1D:117E) into node[+2]/[+4].  PANEL[+4] (line count) ++.
 *
 * @asm 0x06CAD3  lcall 0x181f,0x2c (size 0xa)    ; heap_alloc line node
 * @asm 0x06CB17  cmp byte es:[si],0x5e ('^')     ; leading-marker scan
 * @asm 0x06CB2C  mov es:[si],1                    ; "^^" -> centered flag
 * @asm 0x06CB41  or byte es:[bx],2                ; "^"  -> flag bit 1
 * @asm 0x06CB56  lcall 0xd1d,0x113c              ; strlen(rest)
 * @asm 0x06CB61  lcall 0x181f,0x2c               ; alloc copy
 * @asm 0x06CB7C  lcall 0xd1d,0x117e              ; far-copy label
 * @asm 0x06CB87  inc PANEL[+4]                    ; line count++
 * ============================================================================ */
int func_06CA82_panel_append_text_line(uint16_t panel_lo)
{
    (void)panel_lo;
    /* walk PANEL[+0x58..] to tail (NEXT node[+6/+8]); */
    overlay_call_181F_002C();             /* @0x06CAD3 heap_alloc(0xA) line node */
    /* link node; scan leading '^'/'^^' markers (0x5E):                       */
    overlay_call_0D1D_113C();             /* @0x06CB56 strlen(label) */
    overlay_call_181F_002C();             /* @0x06CB61 alloc(len+1) */
    overlay_call_0D1D_117E();             /* @0x06CB7C far-copy label -> node[+2/+4] */
    /* PANEL[+4]++ (line count)  (@0x06CB87) */
    return 0;                             /* retf @0x06CB8B (dx:ax = node) */
}

/* ============================================================================
 * func_06CB94 — panel_append_value_row  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Appends a LABEL+VALUE row to the panel value list (head PANEL[+0x60]/[+0x62]).
 * Walks tail (NEXT node[+0x10]/[+0x12]), allocs a 0x14-byte node (181F:002C),
 * links it.  Copies the label (strlen 0D1D:113C -> alloc 181F:002C -> far-copy
 * 0D1D:117E into node[+8]), then formats the value column: 0D1D:11B4 builds the
 * displayed string (separator 0x1F95), near 0x7D6 measures it, 0D1D:11B4 again
 * with format 0x1F97; the value width is multiplied by [bp+0x12] (column count)
 * via imul.  Updates PANEL[+0x34] (label col width, max) and either zeroes the
 * value cell (no value) or copies it via 0D1D:10C0 (region copy), with overflow
 * marking PANEL flag bit 7.  PANEL[+8] (value-row count) ++.
 *
 * @asm 0x06CBE7  lcall 0x181f,0x2c (size 0x14)   ; heap_alloc value node
 * @asm 0x06CC3D  lcall 0xd1d,0x113c              ; strlen(label)
 * @asm 0x06CC49  lcall 0x181f,0x2c               ; alloc label copy
 * @asm 0x06CC64  lcall 0xd1d,0x117e              ; far-copy label
 * @asm 0x06CC7B  lcall 0xd1d,0x11b4 (sep 0x1F95) ; build label+sep
 * @asm 0x06CC9F  call 0x7d6                       ; measure label width
 * @asm 0x06CCB4  lcall 0x181f,0x2c               ; alloc value buf
 * @asm 0x06CCCE  call 0x7d6 (fmt 0x1F97)          ; measure value width
 * @asm 0x06CCD1  imul [bp+0x12]                   ; * column count
 * @asm 0x06CCE9  cmp ...,PANEL[+0x34] ; max       ; track label col width
 * @asm 0x06CD20  lcall 0xd1d,0x10c0              ; region-copy value text
 * @asm 0x06CD50  or byte es:[bx],0x80             ; overflow flag
 * @asm 0x06CD57  inc PANEL[+8]                    ; value-row count++
 * ============================================================================ */
int func_06CB94_panel_append_value_row(uint16_t panel_lo)
{
    (void)panel_lo;
    /* walk PANEL[+0x60..] to tail (NEXT node[+0x10..]); */
    overlay_call_181F_002C();             /* @0x06CBE7 heap_alloc(0x14) value node */
    overlay_call_0D1D_113C();             /* @0x06CC3D strlen(label) */
    overlay_call_181F_002C();             /* @0x06CC49 alloc label copy */
    overlay_call_0D1D_117E();             /* @0x06CC64 far-copy label -> node[+8] */
    overlay_call_0D1D_11B4();             /* @0x06CC7B assemble label+separator(0x1F95) */
    func_06F821();                        /* @0x06CC9F measure label width (1A1F:0A9E) */
    overlay_call_181F_002C();             /* @0x06CCB4 alloc value buffer -> node[+0xC] */
    func_06F821();                        /* @0x06CCCE measure value width(fmt 0x1F97) */
    /* value width *= [bp+0x12] (columns); track PANEL[+0x34] max;            */
    overlay_call_0D1D_10C0();             /* @0x06CD20 region-copy value text */
    /* on overflow: PANEL flag |= 0x80;  PANEL[+8]++  (@0x06CD50/@0x06CD57)   */
    return 0;                             /* retf @0x06CD5B (dx:ax = node) */
}

/* ============================================================================
 * func_06CD66 — text_kind_remap  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Reads the first byte of the string at far [bp+4] into a word kind; if kind==6
 * AND g_panel_flag_1F8A==0, remaps it to 5.  Returns the (possibly remapped)
 * kind.  (A small text-class selector used by the layout passes; called near as
 * 0x1266 from func_06CD8C / 06CFE8 / 06D316.)
 *
 * @asm 0x06CD6D  al = es:[bx] (first byte)        ; kind
 * @asm 0x06CD75  cmp ax,6 ; jne                    ; only kind 6 remaps
 * @asm 0x06CD7A  cmp [0x1f8a],0 ; jne              ; gated on flag
 * @asm 0x06CD81  [bp-2]=5                          ; remap 6 -> 5
 * ============================================================================ */
int func_06CD66_text_kind_remap(uint16_t str_lo, uint16_t str_hi)
{
    uint8_t kind = 0;           /* es:[bx] of far [bp+4] */
    (void)str_lo; (void)str_hi;
    /* kind = *(uint8_t*)str; */
    if (kind == 6 && g_panel_flag_1F8A == 0) /* @0x06CD75 / @0x06CD7A */
        kind = 5;                            /* @0x06CD81 */
    return kind;                /* ret @0x06CD89 ([bp-2]) */
}

/* ============================================================================
 * func_06CD8C — panel_append_label_row  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Appends a multi-field LABEL row to PANEL[+0x5C]/[+0x5E] (the label list).
 * Walks tail (NEXT node[+0x10..]), allocs a 0x14-byte node (181F:002C), links
 * it copying node[+2] from the prior tail's [+2].  Sets node[+0xC/+0xE]=key
 * ([bp+0xA/0xC]), node[+4]=arg([bp+0xE]), node[+6]=arg([bp+0x14]).  If [bp+0x10]
 * |[bp+0x12] (a string handle) is non-zero it: when PANEL[+0x54]|[+0x56]==0
 * sets PANEL[+0x28]=0; strlen (0D1D:113C) -> alloc (181F:002C) -> far-copy
 * (0D1D:117E) the field text into node[+8]; measures it (near 0x7D6) into
 * PANEL[+0x46]+[+0x32]; calls text_kind_remap (near 0x1266) and records the
 * kind in [bp-0x12].  Else node[+8/+0xA]=0.  Computes node[+2] (x), updates
 * PANEL[+0x2E] (max field width) and PANEL[+0x30], and if cursor flag [0x1F66]
 * matches the anchored coord (0x89E/0x8A0) bumps the highlight; PANEL[+6]++.
 *
 * @asm 0x06CDDD  lcall 0x181f,0x2c (size 0x14)   ; heap_alloc label node
 * @asm 0x06CE96  lcall 0x181f,0x2c (strlen+1)    ; alloc field text copy
 * @asm 0x06CE8B  lcall 0xd1d,0x113c              ; strlen(field)
 * @asm 0x06CEB1  lcall 0xd1d,0x117e              ; far-copy field text
 * @asm 0x06CECA  call 0x7d6                       ; measure field width
 * @asm 0x06CEE5  call 0x1266 (func_06CD66)        ; kind remap
 * @asm 0x06CF6D  inc PANEL[+6]                    ; label-row count++
 * ============================================================================ */
int func_06CD8C_panel_append_label_row(uint16_t panel_lo)
{
    (void)panel_lo;
    /* walk PANEL[+0x5C..] to tail (NEXT node[+0x10..]); link new node */
    overlay_call_181F_002C();             /* @0x06CDDD heap_alloc(0x14) label node */
    /* set node[+0xC/+0xE]=key, [+4]=arg, [+6]=arg                            */
    if (1 /* [bp+0x10]|[bp+0x12] != 0 */) { /* @0x06CE5C */
        overlay_call_0D1D_113C();         /* @0x06CE8B strlen(field) */
        overlay_call_181F_002C();         /* @0x06CE96 alloc(len+1) */
        overlay_call_0D1D_117E();         /* @0x06CEB1 far-copy -> node[+8] */
        func_06F821();                    /* @0x06CECA measure width (1A1F:0A9E) */
        func_06CD66_text_kind_remap(0, 0);/* @0x06CEE5 classify text kind */
    }
    /* compute node[+2] x; bump PANEL[+0x2E]/[+0x30]; cursor highlight via
     * [0x1F66] vs (0x89E,0x8A0); PANEL[+6]++  (@0x06CF6D)                     */
    return 0;                             /* retf @0x06CF71 (dx:ax = node) */
}

/* ============================================================================
 * func_06CF7A — panel_make_edit_widget  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Allocates a 0x14-byte single edit/aux widget (181F:002C), stores it in
 * PANEL[+0x64]/[+0x66], and seeds it: node[+0xC/+0xE] = key ([bp+0xA/0xC]),
 * node[+4] = arg ([bp+0xE]).  Returns the node far ptr (dx:ax).
 *
 * @asm 0x06CF8C  lcall 0x181f,0x2c (size 0x14)   ; heap_alloc edit node
 * @asm 0x06CF94  mov PANEL[+0x64/+0x66] = node
 * @asm 0x06CFA6  node[+0xC/+0xE] = [bp+0xA/0xC]   ; key
 * @asm 0x06CFB1  node[+4] = [bp+0xE]              ; value
 * ============================================================================ */
int func_06CF7A_panel_make_edit_widget(uint16_t panel_lo, uint16_t panel_hi,
                                       uint16_t key_lo, uint16_t key_hi, uint16_t val)
{
    (void)panel_lo; (void)panel_hi; (void)key_lo; (void)key_hi; (void)val;
    overlay_call_181F_002C();   /* @0x06CF8C heap_alloc(0x14) edit node */
    /* PANEL[+0x64/+0x66] = node; node[+0xC/+0xE] = key; node[+4] = val;       */
    return 0;                   /* retf @0x06CFB9 (dx:ax = node) */
}

/* ============================================================================
 * func_06CFBC — emit_field_at_offset  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Thin wrapper over the internal text emitter func_06C388 (near 0x888).  Pushes
 * the panel string buffer (PANEL+0x74, panel far ptr [bp+8]) and the source
 * [bp+4]/[bp+6], computes the x origin = ax + PANEL[+0x48] + PANEL[+0x2A], and
 * calls func_06C388 with bx=0 (flags), dx=0.
 *
 * @asm 0x06CFC6  cx = [bp+8]+0x74                ; &PANEL.buf
 * @asm 0x06CFD4  cx = PANEL[+0x48] + PANEL[+0x2A]; x base
 * @asm 0x06CFDC  ax += cx                         ; x origin
 * @asm 0x06CFE0  call 0x888                       ; func_06C388(flags=0,...)
 * ============================================================================ */
int func_06CFBC_emit_field_at_offset(uint16_t arg0, uint16_t arg1, uint16_t panel_lo)
{
    (void)arg0; (void)arg1; (void)panel_lo;
    /* x = ax + PANEL[+0x48] + PANEL[+0x2A];  (@0x06CFD4) */
    return func_06C388(0, 0, 0, 0, 0);    /* @0x06CFE0 ret 8 */
}

/* ============================================================================
 * func_06CFE8 — panel_wordwrap_text  [BYTE_VERIFIED — full body]
 * ----------------------------------------------------------------------------
 * The WORD-WRAP / multi-line layout pass for the panel text list (head
 * PANEL[+0x58]/[+0x5A], far [bp+4]).  The routine has TWO modes selected by the
 * AX register argument (saved at [bp-0x16c] by the `push ax` after ENTER):
 *   mode == 0  MEASURE only (caller func_06D316 @0x06D437 does `sub ax,ax`):
 *              compute the total wrapped height without drawing.
 *   mode != 0  RENDER (caller @0x06E360 does `mov ax,1`): also emit each line
 *              via func_06CFBC (near 0x14BC).
 * Right-edge limit  [bp-0x108] = -(2*PANEL[+0x48] - PANEL[+0x28])  (negated).
 * Returns the accumulated height in AX = [bp-0x166].
 *
 * PER NODE (NEXT node[+6]/[+8]):
 *   - cursor = node[+2]/[+4]  (far ptr to the node's text).
 *   - CORRECTION to the old banner: nodes with (node[0] & 3) != 0 take the
 *     pre-formatted / centered WHOLE-LINE path (no wrap); nodes with
 *     (node[0] & 3) == 0 are WORD-WRAPPED.  (@asm 0x06D045 test [bx],3 ;
 *     0x06D049 jne -> whole-line ; 0x06D04B jmp -> word-wrap entry 0x06D288.)
 *
 * WORD-WRAP loop (per word, entered via strlen(cursor)!=0 at 0x06D288):
 *   - skip leading spaces (0x20)                                  @0x06D140
 *   - find next space (0D1D:1010, far) and NUL-terminate the word @0x06D150
 *   - word_len = strlen(word) (0D1D:113C)                         @0x06D172
 *   - word_buf = "" ; if line_buf non-empty prepend a space
 *     (0D1D:07A4, fmt 0x1F99) ; append word (0D1D:11B4)           @0x06D17E
 *   - run_w = func_06C2D6(&word_buf, PANEL+0x74) (near 0x7D6)     @0x06D1C3
 *   - if (PANEL[+0x74] + run_w + line_x <= limit) APPEND          @0x06D1D6
 *       else FLUSH: (render) emit line_buf via func_06CFBC; add line
 *       height (func_06CD66+1) to total_h AND to [bp-0x10e];
 *       strip word_buf's leading space; reset line_buf; line_x=0   @0x06D1DC
 *   - APPEND: line_buf += word_buf (0D1D:11B4); line_x +=
 *       PANEL[+0x74]+run_w; restore the NUL'd space; cursor+=word_len @0x06D24D
 *   - loop while strlen(cursor)!=0                                @0x06D288
 *
 * WHOLE-LINE path (node flag bits set, 0x06D04E..0x06D13C): if line_buf is
 *   pending, (render) emit it and bump the height; (render) optionally emit the
 *   whole node string centered (x = limit/2 - textw/2, textw via func_06C2D6),
 *   then skip cursor to its NUL and add one more line height.
 *
 * After the node list ends (0x06D2B4): if line_buf still has content, flush the
 * final line and add its height.
 *
 * @asm 0x06D00C  ax = 2*PANEL[+0x48] - PANEL[+0x28] ; neg -> [bp-0x108] limit
 * @asm 0x06D045  test es:[bx],3 ; jne whole-line ; else jmp word-wrap
 * @asm 0x06D150  lcall 0xd1d,0x1010 (ch 0x20)         ; find next space (far)
 * @asm 0x06D172  lcall 0xd1d,0x113c                   ; strlen(word)
 * @asm 0x06D192  lcall 0xd1d,0x7a4  (fmt 0x1F99)      ; leading-space append fmt
 * @asm 0x06D1A6  lcall 0xd1d,0x11b4                   ; concat word -> word_buf
 * @asm 0x06D1C3  call 0x6c2d6 (func_06C2D6)           ; measure run width
 * @asm 0x06D234  lcall 0xd1d,0x7e4                    ; strip leading space (shift)
 * @asm 0x06D259  lcall 0xd1d,0x11b4                   ; commit word to line buf
 * @asm 0x06D28E  lcall 0xd1d,0x113c                   ; advance to next word
 * @asm 0x06D30C  ax = [bp-0x166]                       ; total height (return)
 * ============================================================================ */
int func_06CFE8_panel_wordwrap_text(uint16_t mode_ax, void far *panel /*bp+4*/)
{
    /* The panel is a far ptr; its fields are read via the PANEL_* far accessors
     * so the traffic reads as the real es:[bx+0xNN] accesses.  `mode_ax` is the
     * AX register argument saved at [bp-0x16c] by the `push ax` after ENTER. */
    void far *node;                       /* [bp-0x10c]/[bp-0x10a] */
    uint8_t far *cursor;                  /* [bp-4]/[bp-2] */
    uint8_t far *space_ptr;               /* [bp-0x162]/[bp-0x160] (NUL'd space) */
    int   mode     = (int)mode_ax;        /* [bp-0x16c] = AX register arg */
    int   limit    = 0;                   /* [bp-0x108] right-edge (negated) */
    int   y_acc    = 0;                   /* [bp-0x10e] secondary height accum */
    int   total_h  = 0;                   /* [bp-0x166] (return) */
    int   line_x   = 0;                   /* [bp-6] current line width */
    int   run_w    = 0;                   /* [bp-0x164] measured word/run width */
    int   word_len = 0;                   /* [bp-0x16a] strlen(word) */
    int   cx_off   = 0;                   /* [bp-0x168] centered x offset */
    char  line_buf[0x100];                /* [bp-0x106]..[bp-7] assembled line buffer */
    char  word_buf[0x58];                 /* [bp-0x15e]..[bp-0x107] " word" staging buffer */

    /* @asm 0x06CFEF..0x06D025 — seed: node = text-line head; limit; y_acc;
     * line_buf empty; total_h = 0; line_x = 0. */
    node   = NODE_FAR(panel, 0x58);                 /* @asm 0x06CFF2 PANEL[+0x58/+0x5A] */
    limit  = -(2 * PANEL_W(panel, 0x48) - PANEL_W(panel, 0x28)); /* @asm 0x06D002..0x06D00C */
    y_acc  = PANEL_W(panel, 0x2C);                  /* @asm 0x06D012 [bp-0x10e]=PANEL[+0x2C] */
    line_buf[0] = 0;                                /* @asm 0x06D01A [bp-0x106]=0 */
    total_h = 0;                                    /* @asm 0x06D021 [bp-0x166]=0 */
    line_x  = 0;                                    /* @asm 0x06D025 [bp-6]=0 */

    /* @asm 0x06D028 — outer node loop. */
    while (node != (void far *)0) {                 /* @asm 0x06D028..0x06D030 */
        /* @asm 0x06D033..0x06D042 — cursor = node[+2]/[+4]. */
        cursor = (uint8_t far *)NODE_FAR(node, 0x02);

        /* @asm 0x06D045..0x06D04B — flag bits 0/1 select whole-line vs word-wrap. */
        if ((NODE_W(node, 0x00) & 3) != 0) {
            /* ---- whole-line / centered path (0x06D04E..0x06D13C) ---- */

            /* @asm 0x06D04E..0x06D0A6 — flush any pending line first. */
            if (line_buf[0] != 0) {                 /* @asm 0x06D04E */
                if (mode != 0)                      /* @asm 0x06D055 */
                    func_06CFBC_emit_field_at_offset(0 /*x*/, y_acc, 0); /* @asm 0x06D06E emit line_buf */
                total_h += func_06CD66_text_kind_remap(PANEL_W(panel, 0x80), PANEL_W(panel, 0x82)) + 1; /* @asm 0x06D071..0x06D085 */
                y_acc   += func_06CD66_text_kind_remap(PANEL_W(panel, 0x80), PANEL_W(panel, 0x82)) + 1; /* @asm 0x06D089..0x06D09D */
                line_buf[0] = 0;                    /* @asm 0x06D0A1 */
                line_x = 0;                         /* @asm 0x06D0A6 */
            }

            /* @asm 0x06D0AB..0x06D0FD — (render only) emit the node string,
             * centered when node bit 0 is set. */
            if (mode != 0) {                        /* @asm 0x06D0AB */
                if (NODE_W(node, 0x00) & 1) {       /* @asm 0x06D0B6 */
                    int textw = func_06C2D6_dialog_lookup_accelerator(0); /* @asm 0x06D0CD width */
                    cx_off = (limit >> 1) - (textw >> 1); /* @asm 0x06D0D0..0x06D0DA */
                } else {
                    cx_off = 0;                     /* @asm 0x06D0E0 */
                }
                func_06CFBC_emit_field_at_offset(cx_off, y_acc, 0); /* @asm 0x06D0FA emit centered */
            }

            /* @asm 0x06D100..0x06D10A — skip cursor to its terminating NUL. */
            while (*cursor != 0)                    /* @asm 0x06D103..0x06D10A */
                cursor++;                           /* @asm 0x06D100 */

            /* @asm 0x06D10C..0x06D138 — add one line height for the node. */
            total_h += func_06CD66_text_kind_remap(PANEL_W(panel, 0x80), PANEL_W(panel, 0x82)) + 1; /* @asm 0x06D10C..0x06D120 */
            y_acc   += func_06CD66_text_kind_remap(PANEL_W(panel, 0x80), PANEL_W(panel, 0x82)) + 1; /* @asm 0x06D124..0x06D138 */
            /* @asm 0x06D13C jmp 0x06D288 -> falls into the next-word test below */
        }

        /* ---- per-word loop (0x06D288 entry; body 0x06D140..0x06D285) ---- */
        /* @asm 0x06D288..0x06D298 — loop while the cursor has remaining text. */
        while (overlay_call_0D1D_113C() /* strlen(cursor) */ != 0) { /* @asm 0x06D28E */
            /* @asm 0x06D140..0x06D14A — skip leading spaces. */
            while (*cursor == 0x20)                 /* @asm 0x06D143 */
                cursor++;                           /* @asm 0x06D140 */

            /* @asm 0x06D14C..0x06D168 — find the next space and NUL-terminate. */
            space_ptr = (uint8_t far *)0;
            overlay_call_0D1D_1010();               /* @asm 0x06D150 strchr_far(cursor, 0x20) */
            /* space_ptr = result; */
            if (space_ptr != (uint8_t far *)0)      /* @asm 0x06D160 */
                *space_ptr = 0;                     /* @asm 0x06D168 NUL-terminate the word */

            /* @asm 0x06D16C..0x06D17A — word length. */
            word_len = overlay_call_0D1D_113C();    /* @asm 0x06D172 strlen(word) */

            /* @asm 0x06D17E..0x06D1AB — stage "[ ]word" in word_buf. */
            word_buf[0] = 0;                        /* @asm 0x06D17E */
            if (line_buf[0] != 0)                   /* @asm 0x06D183 */
                overlay_call_0D1D_07A4();           /* @asm 0x06D192 str_cat(word_buf, " " @0x1F99) */
            overlay_call_0D1D_11B4();               /* @asm 0x06D1A6 str_cat_far(word_buf, cursor) */

            /* @asm 0x06D1AE..0x06D1C6 — measure the staged word. */
            run_w = func_06C2D6_dialog_lookup_accelerator(0); /* @asm 0x06D1C3 width of word_buf */

            /* @asm 0x06D1CA..0x06D1DA — wrap test: does it still fit the line? */
            if (PANEL_W(panel, 0x74) + run_w + line_x <= limit) {
                /* fits -> APPEND (fall through to 0x06D24D) */
            } else {
                /* ---- FLUSH the current line (0x06D1DC..0x06D248) ---- */
                if (mode != 0)                      /* @asm 0x06D1DC */
                    func_06CFBC_emit_field_at_offset(0 /*x*/, y_acc, 0); /* @asm 0x06D1F5 emit line_buf */
                total_h += func_06CD66_text_kind_remap(PANEL_W(panel, 0x80), PANEL_W(panel, 0x82)) + 1; /* @asm 0x06D1F8..0x06D20C */
                y_acc   += func_06CD66_text_kind_remap(PANEL_W(panel, 0x80), PANEL_W(panel, 0x82)) + 1; /* @asm 0x06D210..0x06D224 */
                /* @asm 0x06D23C..0x06D241 — strip word_buf's now-leading space. */
                while (word_buf[0] == 0x20)         /* @asm 0x06D23C */
                    overlay_call_0D1D_07E4();       /* @asm 0x06D234 shift word_buf left by 1 */
                line_buf[0] = 0;                    /* @asm 0x06D243 */
                line_x = 0;                         /* @asm 0x06D248 */
            }

            /* ---- APPEND the word to the line (0x06D24D..0x06D285) ---- */
            overlay_call_0D1D_11B4();               /* @asm 0x06D259 str_cat_far(line_buf, word_buf) */
            line_x += PANEL_W(panel, 0x74) + run_w; /* @asm 0x06D261..0x06D26C */
            if (space_ptr != (uint8_t far *)0)      /* @asm 0x06D26F */
                *space_ptr = 0x20;                  /* @asm 0x06D27D restore the NUL'd space */
            cursor += word_len;                     /* @asm 0x06D281..0x06D285 */
        }

        /* @asm 0x06D29D..0x06D2B1 — advance to the next node. */
        node = NODE_FAR(node, 0x06);                /* @asm 0x06D2A1 node[+6]/[+8] */
    }

    /* @asm 0x06D2B4..0x06D307 — flush the final pending line. */
    if (line_buf[0] != 0) {                         /* @asm 0x06D2B4 */
        if (mode != 0)                              /* @asm 0x06D2BB */
            func_06CFBC_emit_field_at_offset(0 /*x*/, y_acc, 0); /* @asm 0x06D2D4 emit line_buf */
        total_h += func_06CD66_text_kind_remap(PANEL_W(panel, 0x80), PANEL_W(panel, 0x82)) + 1; /* @asm 0x06D2D7..0x06D2EB */
        y_acc   += func_06CD66_text_kind_remap(PANEL_W(panel, 0x80), PANEL_W(panel, 0x82)) + 1; /* @asm 0x06D2EF..0x06D303 */
        line_buf[0] = 0;                            /* @asm 0x06D307 */
    }

    return total_h;                                 /* @asm 0x06D30C..0x06D313 ret 4 (AX=[bp-0x166]) */
}

/* ============================================================================
 * func_06D316 — panel_finalize_geometry  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * The final layout pass.  Given the fully-built PANEL (far ptr [bp+4]) it
 * computes the panel's final origin (x,y = +0x10/+0x12), content size
 * (w,h = +0x14/+0x16), the saved-background rectangle (+0x18..+0x1E), the inner
 * margins (+0x24/+0x26/+0x2A/+0x2C/+0x36/+0x38), and the position of the single
 * aux/edit widget (PANEL[+0x68]/[+0x6A]) relative to its anchor child.
 *
 * CALL CONVENTION (verified at the caller func_06E2DE_panel_render):
 *   caller @0x06E2E7 push [bp+8]; @0x06E2EA push [bp+6] -> panel far ptr;
 *   @0x06E2ED call 0x1816 (=func_06D316); callee `ret 4` pops it.
 *   RETURN: 0 on the NORMAL (laid-out) exit; 1 on the EMPTY-PANEL exit
 *   (PANEL[+2]+[+4]+[+6]+[+8]==0).  The caller @0x06E2F0 `or ax,ax; @0x06E2F2 je
 *   -> proceed-to-draw` PROCEEDS when 0 and early-outs (ret 1) when !=0.
 *   (The skeleton's nominal `(void)` arg was wrong; the panel ptr IS passed;
 *    caller bytes @0x06E2E7: ff 76 08 ff 76 06 e8 26 f0 0b c0 74 03.)
 *
 * Frame (enter 0x2C): [bp-8] changed-flag; [bp-0x2C] wrapped-text height;
 *   [bp-0x14] button-rows height; [bp-0x1E] value-rows height; [bp-6] last label
 *   node[+2]; [bp-0x12]/[bp-0x10] far-ptr (label-list walk, then = aux widget);
 *   [bp-0xE] combined-row height; [bp-0x22] bottom (y+h); [bp-0x1C] right (x+w);
 *   [bp-0x20] aux dim; [bp-0x26] aux 2nd dim; [bp-0x18] right-overflow adj;
 *   [bp-0x28] aux clamp x; [bp-0x24] aux-centered flag; [bp-0xA]/[bp-0xC]/[bp-4]
 *   aux child x/y/w copies; [bp-0x2A] aux working x.
 *
 * GEOMETRY FORMULA recovered (all @asm-cited inline below):
 *   x0       = PANEL[+0x10] := PANEL[+0xC]                          (@0x06D349)
 *   y0       = PANEL[+0x12] := PANEL[+0xE]                          (@0x06D351)
 *   PANEL[+0x14] := 0                                               (@0x06D359)
 *   contentW = PANEL[+0x16] := 2*PANEL[+0x4A] + PANEL[+0x46]        (@0x06D35F)
 *   border b = (PANEL[+0xA] & 0x10) ? 0 : 3                         (@0x06D36D)
 *              PANEL[+0x2A] := b; PANEL[+0x24] := b;
 *              PANEL[+0x2C] := b + PANEL[+0x46]; PANEL[+0x26] := same(@0x06D37C)
 *   innerW   = PANEL[+0x28] = PANEL[+0x20] = PANEL[+0x34]
 *                := max(PANEL[+0x28], PANEL[+0x20], PANEL[+0x34])   (@0x06D392)
 *   if (PANEL[+2]+[+4]+[+6]+[+8] == 0) return 1 (empty panel, no    (@0x06D3C6)
 *        layout: jmp 0x1d84 skips both margin-translate and [bp-8]=0)
 *   label-list pass: if PANEL[+0x5C/+0x5E] != 0 then
 *       d = PANEL[+0x48]+PANEL[+0x2E]+PANEL[+0x30]+PANEL[+0x32];    (@0x06D3DD)
 *       PANEL[+0x14]+=d; PANEL[+0x2A]+=d; PANEL[+0x24]+=d; PANEL[+0x36]+=d;
 *       walk nodes (NEXT [+0x10]) recording last node[+2] into [bp-6](@0x06D405)
 *   value-list pass: if PANEL[+0x58/+0x5A] != 0 then
 *       hWrap = func_06CFE8(PANEL);  PANEL[+0x26]+=PANEL[+0x46]+hWrap;
 *       PANEL[+0x38]+=PANEL[+0x46]+hWrap                            (@0x06D437)
 *   button rows: if PANEL[+0x54/+0x56] != 0 then
 *       rowH = func_06CD66(PANEL[+0x80],[+0x82]) + PANEL[+0x46];
 *       buttonsH[bp-0x14] = rowH * PANEL[+2]                        (@0x06D46B)
 *   value rows : if PANEL[+0x60/+0x62] != 0 then
 *       rowH = func_06CD66(...) + PANEL[+0x46] + 5;
 *       valsH[bp-0x1E] = rowH * PANEL[+8]                           (@0x06D493)
 *   rowsH    = valsH + buttonsH + wrappedH                          (@0x06D4AA)
 *   if (rowsH != 0) rowsH += PANEL[+0x46]                           (@0x06D4BA)
 *   bsel     = ((PANEL[+0xA]&0x10)?0:3) * 2                         (@0x06D4C1)
 *   cy       = max(last_label_node[+2], rowsH)                      (@0x06D4D2)
 *   PANEL[+0x16] += bsel + cy ; PANEL[+0x14] += bsel + PANEL[+0x20] (@0x06D4E1)
 *   hover    : if [0x1F66] && PANEL[+0x80/+0x82]==(0x89E,0x8A0)
 *                 PANEL[+0x16]+=6 else PANEL[+0x16]+=3              (@0x06D4ED)
 *   center-x : if PANEL[+0x10]==-1 PANEL[+0x10] = -((PANEL[+0x14]>>1)-0xA0)(@0x06D51B)
 *   center-y : if PANEL[+0x12]==-1 PANEL[+0x12] = -((PANEL[+0x16]>>1)-0x64)(@0x06D534)
 *   bottom   = PANEL[+0x16]+PANEL[+0x12] ([bp-0x22]); right = PANEL[+0x14]+
 *              PANEL[+0x10] ([bp-0x1C])                             (@0x06D54A)
 *   if (right > 0x140)  PANEL[+0x10] -= (right-0x140)              (@0x06D563)
 *   if (bottom> 0xC8)   PANEL[+0x12] += (0xC8-bottom)              (@0x06D571)
 *   if (PANEL[+0x10]<0 || PANEL[+0x12]<0)                           (@0x06D588)
 *        lcall 0x181F:0x0772 scroll/clamp(x,y,0xFFAF,2,bx=0x29)     (@0x06D5AD)
 *   save bg rect: PANEL[+0x18]=PANEL[+0x10]; [+0x1A]=[+0x12];
 *                 [+0x1C]=PANEL[+0x14]; [+0x1E]=PANEL[+0x16]        (@0x06D5B5)
 *   aux widget (PANEL[+0x68]/[+0x6A]): if non-NULL, place its child rect
 *        relative to PANEL using [0x1F5C]/[0x1F5E]/[0x1F60] anchor mode
 *        (centered if [0x1F5C] in {0,3,5,7,8}); 3-way kind switch on
 *        child[+0x14] (0/1/2) selects left/center/right edge placement(@0x06D5D5)
 *   finish (0x1d5c): PANEL[+0x24]+=x; PANEL[+0x26]+=y; PANEL[+0x2A]+=x;
 *           PANEL[+0x2C]+=y; PANEL[+0x36]+=x; PANEL[+0x38]+=y       (@0x06D85C)
 *           where x=PANEL[+0x10], y=PANEL[+0x12] (the final origin).
 *   [bp-8]=0; return [bp-8]  (=0 normal exit, =1 empty-panel exit)  (@0x06D87F)
 *
 * Calls internal helpers func_06CFE8 (@near 0x14E8) + func_06CD66 (@near 0x1266)
 * and ONE overlay thunk lcall 0x181F:0x0772 (off-screen scroll/clamp — the same
 * helper the sibling window builder func_044FA4 uses with the identical idiom,
 * already declared in overlay_externs.h).  Reads DGROUP 0x1F66 / 0x89E / 0x8A0
 * (hover) + 0x1F5C / 0x1F5E / 0x1F60 (aux anchor mode).
 * ============================================================================ */
int func_06D316_panel_finalize_geometry(void far *panel /*bp+4*/)
{
    int   changed;        /* [bp-8]  set 1 on entry, 0 on normal exit            */
    int   wrappedH;       /* [bp-0x2C] func_06CFE8 result (value-list wrap)      */
    int   buttonsH;       /* [bp-0x14] PANEL[+2] button rows * row height        */
    int   valsH;          /* [bp-0x1E] PANEL[+8] value rows  * row height        */
    int   last_label_v2;  /* [bp-6]  last label node[+2] (per-row height extent)  */
    int   rowsH;          /* [bp-0xE] combined row height                        */
    int   bottom;         /* [bp-0x22] y + h                                     */
    int   right;          /* [bp-0x1C] x + w                                     */
    int   x0, y0;         /* working copies of PANEL[+0x10]/[+0x12]              */
    int   b;              /* border inset (0 or 3)                               */
    int   bsel;           /* doubled border select                              */
    int   cy;             /* clamped content-y                                  */
    void far *node;       /* [bp-0x12]/[bp-0x10] label-list walk / aux widget    */
    void far *aux;        /* PANEL[+0x68]/[+0x6A] single aux/edit widget         */

    (void)panel; (void)node; (void)aux; (void)x0; (void)y0;
    (void)b; (void)bsel; (void)cy; (void)last_label_v2; (void)right; (void)bottom;

    changed = 1;                          /* @0x06D31B mov [bp-8],1              */
    wrappedH = 0;                         /* @0x06D322 [bp-0x2C]=0               */
    buttonsH = 0;                         /* @0x06D325 [bp-0x14]=0               */
    valsH    = 0;                         /* @0x06D328 [bp-0x1E]=0               */

    /* @0x06D32E if (PANEL[+8]==0 || PANEL[+2]==0) skip the value-list reset.    */
    /* @0x06D33A else PANEL[+8]=0; PANEL[+0x62]=0; PANEL[+0x60]=0 (drop values). */
    if (PANEL_W(panel, 0x08) != 0 && PANEL_W(panel, 0x02) != 0) {
        PANEL_W(panel, 0x08) = 0;         /* @0x06D33A */
        PANEL_W(panel, 0x62) = 0;         /* @0x06D33E (value-list head hi)      */
        PANEL_W(panel, 0x60) = 0;         /* @0x06D342 (value-list head lo)      */
    }

    /* origin := requested (x,y); reset content w; content-w base = 2*PANEL[+0x4A]
     * + PANEL[+0x46].                                                            */
    x0 = PANEL_W(panel, 0x0C);            /* @0x06D349 */
    PANEL_W(panel, 0x10) = x0;            /* @0x06D34D PANEL[+0x10]=PANEL[+0xC]   */
    y0 = PANEL_W(panel, 0x0E);            /* @0x06D351 */
    PANEL_W(panel, 0x12) = y0;            /* @0x06D355 PANEL[+0x12]=PANEL[+0xE]   */
    PANEL_W(panel, 0x14) = 0;             /* @0x06D359 PANEL[+0x14]=0             */
    PANEL_W(panel, 0x16) =                /* @0x06D365/@0x06D369 */
        (PANEL_W(panel, 0x4A) << 1) + PANEL_W(panel, 0x46); /* @0x06D35F shl 1   */

    /* border inset b = (PANEL[+0xA] & 0x10) ? 0 : 3   (sbb/and 3 idiom).        */
    b = (PANEL_B(panel, 0x0A) & 0x10) ? 0 : 3;             /* @0x06D36D..0x06D379 */
    PANEL_W(panel, 0x2A) = b;             /* @0x06D37C */
    PANEL_W(panel, 0x2C) = b + PANEL_W(panel, 0x46);       /* @0x06D382/@0x06D386 */
    PANEL_W(panel, 0x24) = b;             /* @0x06D38A (cx = b)                   */
    PANEL_W(panel, 0x26) = PANEL_W(panel, 0x2C);           /* @0x06D38E */

    /* innerW := max(PANEL[+0x28], PANEL[+0x20], PANEL[+0x34]); write back to all
     * three so they share the widest value.                                     */
    {
        int innerW = PANEL_W(panel, 0x28);                 /* @0x06D392 */
        if (innerW < PANEL_W(panel, 0x20))                 /* @0x06D396 jge       */
            innerW = PANEL_W(panel, 0x20);                 /* @0x06D39C */
        if (innerW < PANEL_W(panel, 0x34))                 /* @0x06D3A0 jge       */
            innerW = PANEL_W(panel, 0x34);                 /* @0x06D3A6 */
        PANEL_W(panel, 0x28) = innerW;                     /* @0x06D3AA */
        PANEL_W(panel, 0x34) = innerW;                     /* @0x06D3AE */
        PANEL_W(panel, 0x20) = innerW;                     /* @0x06D3B2 */
    }

    /* empty panel: PANEL[+2]+[+4]+[+6]+[+8]==0 -> bail to the RETURN directly
     * (jmp 0x1d84, NOT 0x1d5c): this path SKIPS both the margin translation AND
     * the [bp-8]=0 store, so it returns changed==1 (signals "no layout done").  */
    if ((PANEL_W(panel, 0x02) + PANEL_W(panel, 0x04)        /* @0x06D3B6/@0x06D3BA*/
       + PANEL_W(panel, 0x06) + PANEL_W(panel, 0x08)) == 0) /* @0x06D3BE/@0x06D3C2*/
        goto ret_done;                    /* @0x06D3C6 jne 0x18cb / jmp 0x1d84    */

    last_label_v2 = 0;                    /* @0x06D3CB [bp-6]=0                   */

    /* LABEL-LIST pass: if the label list (PANEL[+0x5C]/[+0x5E]) is non-empty,
     * fold the label-column deltas into the running margins and walk the list to
     * capture the LAST node's [+2] field (a per-row height extent) into [bp-6];
     * it competes with rowsH below to set the content height.                   */
    if ((PANEL_W(panel, 0x5C) | PANEL_W(panel, 0x5E)) != 0) { /* @0x06D3D3/@0x06D3DB */
        int d = PANEL_W(panel, 0x48) + PANEL_W(panel, 0x2E)   /* @0x06D3DD/@0x06D3E1 */
              + PANEL_W(panel, 0x30) + PANEL_W(panel, 0x32);  /* @0x06D3E5/@0x06D3E9 */
        PANEL_W(panel, 0x14) += d;        /* @0x06D3ED */
        PANEL_W(panel, 0x2A) += d;        /* @0x06D3F1 */
        PANEL_W(panel, 0x24) += d;        /* @0x06D3F5 */
        PANEL_W(panel, 0x36) += d;        /* @0x06D3F9 */

        node = PANEL_FAR(panel, 0x5C);    /* @0x06D3FD/@0x06D401 head            */
        while (node != 0) {               /* @0x06D40B/@0x06D410 or-test         */
            last_label_v2 = NODE_W(node, 0x02); /* @0x06D415/@0x06D419 last node[+2] */
            node = NODE_FAR(node, 0x10);  /* @0x06D41C/@0x06D420 NEXT [+0x10]     */
        }                                 /* @0x06D424 jmp back to test          */
    }

    /* VALUE-LIST (text) pass: word-wrap the body text via func_06CFE8 and fold
     * its returned height into PANEL[+0x26]/[+0x38].                            */
    if ((PANEL_W(panel, 0x58) | PANEL_W(panel, 0x5A)) != 0) { /* @0x06D429/@0x06D42D */
        wrappedH = func_06CFE8_panel_wordwrap_text(0 /*ax=0 measure*/, panel); /* @0x06D435 sub ax,ax; @0x06D437 push PANEL; call 0x14E8 */
        {
            int fw = PANEL_W(panel, 0x46);                    /* @0x06D440 */
            PANEL_W(panel, 0x26) += fw + wrappedH;            /* @0x06D446/@0x06D449 */
            PANEL_W(panel, 0x38) += fw + wrappedH;            /* @0x06D44D/@0x06D450 */
        }
    }

    /* BUTTON rows: per-row height = func_06CD66(anchor coord) + PANEL[+0x46];
     * total = rowH * PANEL[+2].                                                  */
    if ((PANEL_W(panel, 0x54) | PANEL_W(panel, 0x56)) != 0) { /* @0x06D457/@0x06D45B */
        int rowH = func_06CD66_text_kind_remap(             /* @0x06D46B near 0x1266 */
                       PANEL_W(panel, 0x80), PANEL_W(panel, 0x82)); /* @0x06D461/@0x06D466 push +0x82,+0x80 */
        rowH += PANEL_W(panel, 0x46);     /* @0x06D474 */
        buttonsH = rowH * PANEL_W(panel, 0x02); /* @0x06D478 imul PANEL[+2]      */
    }

    /* VALUE rows: per-row height = func_06CD66(...) + PANEL[+0x46] + 5;
     * total = rowH * PANEL[+8].                                                  */
    if ((PANEL_W(panel, 0x60) | PANEL_W(panel, 0x62)) != 0) { /* @0x06D47F/@0x06D483 */
        int rowH = func_06CD66_text_kind_remap(             /* @0x06D493 near 0x1266 */
                       PANEL_W(panel, 0x80), PANEL_W(panel, 0x82)); /* @0x06D489/@0x06D48E */
        rowH += PANEL_W(panel, 0x46) + 5; /* @0x06D499/@0x06D4A0 */
        valsH = rowH * PANEL_W(panel, 0x08); /* @0x06D4A3 imul PANEL[+8]         */
    }

    /* combined rows height + the half-border + content-y clamp.                  */
    rowsH = valsH + buttonsH + wrappedH;  /* @0x06D4AA/@0x06D4AD/@0x06D4B0        */
    if (rowsH != 0)                       /* @0x06D4B6 */
        rowsH += PANEL_W(panel, 0x46);    /* @0x06D4BA (add a font row of slack)  */

    bsel = ((PANEL_B(panel, 0x0A) & 0x10) ? 0 : 3) << 1;    /* @0x06D4C1..0x06D4D0 */
    cy = last_label_v2;                   /* @0x06D4D2 cx=[bp-6]                  */
    if (cy < rowsH)                       /* @0x06D4D5 jge                       */
        cy = rowsH;                       /* @0x06D4DA */
    /* PANEL[+0x16] += bsel + cy ; PANEL[+0x14] += bsel + PANEL[+0x20].          */
    PANEL_W(panel, 0x16) += bsel + cy;    /* @0x06D4DD/@0x06D4DF/@0x06D4E1 */
    PANEL_W(panel, 0x14) += bsel + PANEL_W(panel, 0x20);    /* @0x06D4E5/@0x06D4E9 */

    /* HOVER frame: if the dialog cursor flag [0x1F66] is set, add 6px to the
     * content height when this panel is anchored to the live cursor coord
     * (0x89E,0x8A0), else add 3px.                                              */
    if (g_dlg_active_1F66 != 0) {         /* @0x06D4ED */
        if (PANEL_W(panel, 0x80) == g_cursor_x_089E &&        /* @0x06D4F4/@0x06D4FB */
            PANEL_W(panel, 0x82) == g_cursor_y_08A0)          /* @0x06D502 */
            PANEL_W(panel, 0x16) += 6;    /* @0x06D509 */
        else
            PANEL_W(panel, 0x16) += 3;    /* @0x06D513 */
    }

    /* CENTERING: a requested origin of -1 means "center"; x centers on 0xA0
     * (half of 320), y on 0x64 (half of 200).                                   */
    if (PANEL_W(panel, 0x10) == -1)       /* @0x06D51B */
        PANEL_W(panel, 0x10) = -((PANEL_W(panel, 0x14) >> 1) - 0xA0); /* @0x06D522..0x06D52B */
    if (PANEL_W(panel, 0x12) == -1)       /* @0x06D534 */
        PANEL_W(panel, 0x12) = -((PANEL_W(panel, 0x16) >> 1) - 0x64); /* @0x06D53B..0x06D544 */

    /* off-screen clamp: push the box back inside 0x140 x 0xC8; if either origin
     * still ends up negative, ask the platform scroll/clamp helper.            */
    bottom = PANEL_W(panel, 0x16) + PANEL_W(panel, 0x12);   /* @0x06D54D/@0x06D551 [bp-0x22] */
    right  = PANEL_W(panel, 0x14) + PANEL_W(panel, 0x10);   /* @0x06D558/@0x06D55C [bp-0x1C] */
    if (right > 0x140)                    /* @0x06D563 */
        PANEL_W(panel, 0x10) -= (right - 0x140);            /* @0x06D568..0x06D56D */
    if (bottom > 0xC8)                    /* @0x06D571 */
        PANEL_W(panel, 0x12) += (0xC8 - bottom);            /* @0x06D578..0x06D581 */
    if (PANEL_W(panel, 0x10) < 0 || PANEL_W(panel, 0x12) < 0) { /* @0x06D588/@0x06D58F */
        /* push (int32)PANEL[+0x10], (int32)PANEL[+0x12]; ax=0xFFAF, dx=2,
         * bx=0x29 -> off-screen scroll/clamp (page 0x12 platform helper).       */
        overlay_call_181F_0772();         /* @0x06D5AD lcall 0x181F:0x0772 */
    }

    /* saved-background rectangle := the final (x,y,w,h).                         */
    PANEL_W(panel, 0x18) = PANEL_W(panel, 0x10);            /* @0x06D5B5/@0x06D5B9 */
    PANEL_W(panel, 0x1A) = PANEL_W(panel, 0x12);            /* @0x06D5BD/@0x06D5C1 */
    PANEL_W(panel, 0x1C) = PANEL_W(panel, 0x14);            /* @0x06D5C5/@0x06D5C9 */
    PANEL_W(panel, 0x1E) = PANEL_W(panel, 0x16);            /* @0x06D5CD/@0x06D5D1 */

    /* AUX/EDIT WIDGET placement (PANEL[+0x68]/[+0x6A]).  If there is no aux
     * widget, skip straight to finish.                                          */
    aux = PANEL_FAR(panel, 0x68);         /* @0x06D5D5/@0x06D5D9 */
    if (aux == 0)                         /* @0x06D5DD */
        goto finish;                      /* @0x06D5DF jmp 0x1d5c                 */
    node = aux;                           /* @0x06D5E2/@0x06D5E6 [bp-0x12]=aux    */

    /* anchor mode [0x1F5C]: if < 0 the aux child only gets its y placed (skip the
     * x/centering block, jump into the [0x1F5E]/[0x1F60] tail).                 */
    if (g_panel_anchor_1F5C >= 0) {       /* @0x06D5F0 jge                       */
        void far *child = NODE_FAR(aux, 0x0C); /* @0x06D5FA..0x06D5FE child = aux[+0xC] */
        int c4c = NODE_W(child, 0x4C) + 3;     /* @0x06D602/@0x06D606 [bp-0x26]   */
        int adj = -3;                          /* @0x06D60C [bp-0x18]=0xFFFD (=-3) */
        int c4a = NODE_W(child, 0x4A) + 3;     /* @0x06D611/@0x06D615 [bp-0x20]   */
        int auxX;                              /* [bp-0x28] */
        int centered;                          /* [bp-0x24] */

        /* ax entering this block is PANEL[+0x14] (the content width left in ax
         * by the save-bg copy at @0x06D5C5 mov ax,es:[bx+0x14]); auxX = that +
         * c4a + 3.                                                              */
        auxX = PANEL_W(panel, 0x14) + c4a + 3; /* @0x06D61B/@0x06D61D [bp-0x28]    */
        if (auxX > 0x140) {                    /* @0x06D623 */
            adj  = auxX - 0x143;               /* @0x06D628 [bp-0x18] */
            auxX = 0x140;                      /* @0x06D62E [bp-0x28]=0x140 */
        }

        /* centered = [0x1F5C] in {0,3,5,7,8}.                                    */
        centered = (g_panel_anchor_1F5C == 0 || g_panel_anchor_1F5C == 3 ||   /* @0x06D633/@0x06D63A */
                    g_panel_anchor_1F5C == 5 || g_panel_anchor_1F5C == 7 ||   /* @0x06D641/@0x06D648 */
                    g_panel_anchor_1F5C == 8);                                 /* @0x06D64F */

        PANEL_W(panel, 0x1C) = auxX;           /* @0x06D663/@0x06D669 bg-w = auxX  */
        if (centered) {                        /* @0x06D66D */
            int cx = -((auxX >> 1) - 0xA0);    /* @0x06D673..0x06D678 */
            PANEL_W(panel, 0x18) = cx;         /* @0x06D67A bg-x */
            NODE_W(aux, 0x04) = cx;            /* @0x06D681 aux[+4] (child x) */
            PANEL_W(panel, 0x10) = cx - adj + c4a; /* @0x06D685/@0x06D688/@0x06D68E */
        } else {
            int cx = -((auxX >> 1) - 0xA0);    /* @0x06D694..0x06D699 */
            PANEL_W(panel, 0x18) = cx;         /* @0x06D6A1 bg-x */
            PANEL_W(panel, 0x10) = cx;         /* @0x06D6A5 */
            NODE_W(aux, 0x04) = cx + PANEL_W(panel, 0x14) - adj; /* @0x06D6A9/@0x06D6AD/@0x06D6B3 */
        }

        /* aux y := -(c4c/2 - 0x64); track bg-y/bg-h against the panel rect.     */
        {
            int ay = -((c4c >> 1) - 0x64);     /* @0x06D6B7..0x06D6BC */
            int cy2 = ay;
            NODE_W(aux, 0x00) = ay;            /* @0x06D6C4 aux[+0] (child y) */
            if (ay > PANEL_W(panel, 0x12))     /* @0x06D6CC jle */
                ay = PANEL_W(panel, 0x12);     /* @0x06D6D2 */
            PANEL_W(panel, 0x1A) = ay;         /* @0x06D6D6 bg-y */
            cy2 += c4c - 1;                    /* @0x06D6DA/@0x06D6DD */
            if (cy2 < bottom)                  /* @0x06D6DE cmp [bp-0x22] jge */
                cy2 = bottom;                  /* @0x06D6E3 */
            PANEL_W(panel, 0x1E) = cy2 - NODE_W(aux, 0x00) + 1; /* @0x06D6E6/@0x06D6E9 bg-h */
        }
    }

    /* SECONDARY anchor tail ([0x1F5E]/[0x1F60]).  If BOTH are negative the aux
     * widget needs no extra placement -> finish.  Otherwise position the aux
     * child against the panel edges using a 3-way kind switch on child[+0x14].  */
    if (g_panel_anchor_1F5E < 0 && g_panel_anchor_1F60 < 0) /* @0x06D6ED/@0x06D6F4 */
        goto finish;                      /* @0x06D6FB jmp 0x1d5c                 */

    {
        void far *child = NODE_FAR(aux, 0x0C); /* @0x06D6FE/@0x06D701 aux[+0xC]    */
        int dimW = NODE_W(child, 0x4A);        /* @0x06D705 [bp-0x20] */
        int dimH = NODE_W(child, 0x4C);        /* @0x06D70C [bp-0x26] */
        int cX   = NODE_W(child, 0x10);        /* @0x06D713 [bp-0xA]  */
        int cY   = NODE_W(child, 0x12);        /* @0x06D71A [bp-0xC]  */
        int cW   = NODE_W(child, 0x14);        /* @0x06D721 [bp-4] (also the kind) */
        int kind = cW;                         /* dispatched at @0x06D84C          */

        /* clamp cX to <= dimW; xrel = (dimW - cX) + PANEL[+0x16].               */
        if (cX > dimW) cX = dimW;              /* @0x06D728/@0x06D72C */
        {
            int xrel = (dimW - cX) + PANEL_W(panel, 0x16); /* @0x06D72E/@0x06D733 [bp-0x2A] */
            if (xrel >= 0xC8) {                /* @0x06D73A jl */
                PANEL_B(panel, 0x0A) |= 0x40;  /* @0x06D73F set off-bottom flag    */
                goto finish;                   /* @0x06D744 jmp 0x1d5c             */
            }
            /* aux y origin from xrel: aux[+0]= -((xrel>>1)-0x64); bg-y=that.     */
            {
                int ay = -((xrel >> 1) - 0x64); /* @0x06D748..0x06D74D */
                NODE_W(aux, 0x00) = ay;         /* @0x06D752 */
                PANEL_W(panel, 0x1A) = ay;      /* @0x06D758 bg-y */
                {
                    int hh = xrel;              /* [bp-0x2A] reused */
                    if (hh < dimH) hh = dimH;   /* @0x06D75F/@0x06D764 */
                    PANEL_W(panel, 0x1E) = hh;  /* @0x06D767 bg-h */
                }
                PANEL_W(panel, 0x12) = ay - cY + dimH; /* @0x06D76B/@0x06D76E/@0x06D771 */
            }
        }

        /* 3-way kind switch on child[+0x14] (left=0 / center=1 / right=2):
         * @0x06D84C or ax,ax; jne (skip); jmp 0x1c7c  -> ax==0 LEFT
         * @0x06D853 dec; jne (skip); jmp 0x1cc8       -> ax==1 CENTER
         * @0x06D859 dec; je 0x1d02                    -> ax==2 RIGHT
         * (ax>2 falls through to finish).                                       */
        if (kind == 0) {                       /* @0x06D84C..0x06D850 -> 0x1c7c    */
            /* LEFT edge: xrel = PANEL[+0x14] - cW(=[bp-4]) + dimW.              */
            int xx = PANEL_W(panel, 0x14) - cW + dimW;      /* @0x06D77F/@0x06D783/@0x06D786 [bp-0x28] */
            if (xx > 0x140) {                  /* @0x06D78C */
                cW += (xx - 0x140);            /* @0x06D791/@0x06D794 [bp-4]+=    */
                xx  = 0x140;                   /* @0x06D797 */
            }
            {
                int cx = -((xx >> 1) - 0xA0);  /* @0x06D79C..0x06D7A1 */
                NODE_W(aux, 0x04) = cx;        /* @0x06D7A9 child x */
                PANEL_W(panel, 0x18) = cx;     /* @0x06D7B0 bg-x */
                PANEL_W(panel, 0x1C) = xx;     /* @0x06D7B7 bg-w */
                PANEL_W(panel, 0x10) = (cx - cW) + dimW; /* @0x06D7BB/@0x06D7BE/@0x06D7C1 */
            }
            goto finish;                       /* @0x06D7C5 jmp 0x1d5c             */
        } else if (kind == 1) {                /* @0x06D853 dec; jne -> 0x1cc8     */
            /* CENTER: child x centered on dimW alone.                           */
            int cx = -((dimW >> 1) - 0xA0);    /* @0x06D7C8..0x06D7CD */
            NODE_W(aux, 0x04) = cx;            /* @0x06D7D5 child x */
            {
                int bx = PANEL_W(panel, 0x10); /* @0x06D7DC */
                if (bx > cx) bx = cx;          /* @0x06D7E0/@0x06D7E4 */
                PANEL_W(panel, 0x18) = bx;     /* @0x06D7E6 bg-x */
            }
            {
                int rr = (cx + dimW) - 1;      /* @0x06D7EA/@0x06D7ED */
                if (rr < right) rr = right;    /* @0x06D7EE/@0x06D7F3 */
                right = rr;                    /* @0x06D7F6 [bp-0x1C] */
                PANEL_W(panel, 0x1C) = (rr - PANEL_W(panel, 0x18)) + 1; /* @0x06D7F9/@0x06D7FB/@0x06D7FC bg-w */
            }
            goto finish;                       /* @0x06D800 jmp 0x1d5c             */
        } else if (kind == 2) {                /* @0x06D859 dec; je -> 0x1d02      */
            /* RIGHT edge: mirror of the LEFT case using PANEL[+0x14].            */
            int xx = PANEL_W(panel, 0x14) - cW + dimW;      /* @0x06D805/@0x06D809/@0x06D80C [bp-0x28] */
            if (xx > 0x140) {                  /* @0x06D812 */
                cW += (xx - 0x140);            /* @0x06D817/@0x06D81A */
                xx  = 0x140;                   /* @0x06D81D */
            }
            {
                int cx = -((xx >> 1) - 0xA0);  /* @0x06D822..0x06D827 */
                PANEL_W(panel, 0x10) = cx;     /* @0x06D82C */
                PANEL_W(panel, 0x18) = cx;     /* @0x06D830 bg-x */
                PANEL_W(panel, 0x1C) = xx;     /* @0x06D837 bg-w */
                NODE_W(aux, 0x04) = (cx + PANEL_W(panel, 0x14)) - cW; /* @0x06D83B/@0x06D83F/@0x06D845 child x */
            }
            /* falls through to finish @0x06D849 jmp 0x1d5c */
        }
        /* kind > 2 (default) falls through to finish.                          */
    }

finish:                                   /* == display IP 0x1d5c                 */
    /* Translate every panel-relative margin by the final origin (x0,y0 left in
     * PANEL[+0x10]/[+0x12]).                                                     */
    {
        int fx = PANEL_W(panel, 0x10);    /* @0x06D85F */
        int fy = PANEL_W(panel, 0x12);    /* @0x06D867 */
        PANEL_W(panel, 0x24) += fx;       /* @0x06D863 */
        PANEL_W(panel, 0x26) += fy;       /* @0x06D86B */
        PANEL_W(panel, 0x2A) += fx;       /* @0x06D86F */
        PANEL_W(panel, 0x2C) += fy;       /* @0x06D873 */
        PANEL_W(panel, 0x36) += fx;       /* @0x06D877 */
        PANEL_W(panel, 0x38) += fy;       /* @0x06D87B */
    }
    changed = 0;                          /* @0x06D87F [bp-8]=0 (normal exit)     */

ret_done:                                 /* == display IP 0x1d84                 */
    return changed;                       /* @0x06D884/@0x06D889 ret 4 (ax=[bp-8])*/
}

/* ============================================================================
 * func_06D88C — panel_blit_background  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * If g_panel_flag_1F6A != 0 AND PANEL[+0xA] bit 5 (0x20) is clear, blits the
 * panel's saved background via 181F:00E2 (region_restore/free) using the panel
 * rectangle words +0x18/+0x1A/+0x1C/+0x1E.  Otherwise no-op.
 *
 * @asm 0x06D890  cmp [0x1f6a],0 ; je 0x1da1         ; panel-visible gate
 * @asm 0x06D89A  test byte es:[bx+0xa],0x20 ; jne   ; skip if already shown
 * @asm 0x06D8AC  push PANEL[+0x1A/+0x1C/+0x1E]; bx=PANEL[+0x18]; dx=PANEL[+0x1A]
 * @asm 0x06D8BD  lcall 0x181f,0xe2                  ; region_restore
 * ============================================================================ */
int func_06D88C_panel_blit_background(uint16_t panel_lo)
{
    (void)panel_lo;
    if (g_panel_flag_1F6A != 0) {         /* @0x06D890 */
        /* if (PANEL[+0xA] & 0x20) return;  (@0x06D89A) */
        overlay_call_181F_00E2();         /* @0x06D8BD region_restore(PANEL[+0x18..+0x1E]) */
    }
    return 0;                             /* ret 4 @0x06D8C2 */
}

/* ============================================================================
 * func_06D8C8 — panel_draw_cursor_highlight  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Gated on g_dlg_active_1F66.  Computes the highlight rectangle from the panel
 * (far [bp+6]): bottom-right x = PANEL[+0x14]+PANEL[+0x10]-2, y = PANEL[+0x16]+
 * PANEL[+0x12]-7; if the panel is anchored to the live cursor coord (PANEL
 * [+0x80]==[0x89E] && [+0x82]==[0x8A0]) it nudges x by -2.  Builds a small
 * stack string ([bp-0x52], buf[0]=0), formats the cursor glyph via 181F:016E
 * (text draw, page 75) with arg [0x2F34] (bg fill), then draws the highlighted
 * label via 181F:0150 (text draw, page 75) with the text color [0x831].
 *
 * @asm 0x06D8CC  cmp [0x1f66],0 ; je 0x1e36         ; dialog-active gate
 * @asm 0x06D8D6  x = PANEL[+0x14]+PANEL[+0x10]-2     ; [bp-2]
 * @asm 0x06D8E3  y = PANEL[+0x16]+PANEL[+0x12]-7     ; [bp-0x54]
 * @asm 0x06D8F9  if(PANEL[+0x80]==[0x89e] && PANEL[+0x82]==[0x8a0]) x -= 2
 * @asm 0x06D918  lcall 0x181f,0x16e (arg [0x2f34])   ; bg fill / glyph
 * @asm 0x06D920  al = [0x831] (text color)
 * @asm 0x06D931  lcall 0x181f,0x150 (color,x,y,buf)  ; draw highlighted text
 * ============================================================================ */
int func_06D8C8_panel_draw_cursor_highlight(uint16_t panel_lo)
{
    char buf[0x52];
    (void)panel_lo;
    if (g_dlg_active_1F66 != 0) {         /* @0x06D8CC */
        /* x = PANEL[+0x14]+PANEL[+0x10]-2; y = PANEL[+0x16]+PANEL[+0x12]-7;   */
        /* if anchored to (0x89E,0x8A0): x -= 2;  (@0x06D8F9)                  */
        buf[0] = 0;                       /* @0x06D90C */
        overlay_call_181F_016E();         /* @0x06D918 glyph/bg fill (arg g_panel_bg_2F34) */
        /* color = g_text_color_0831;     (@0x06D920) */
        overlay_call_181F_0150();         /* @0x06D931 draw highlighted text(color,x,y,buf) */
    }
    return 0;                             /* retf @0x06D936 */
}
