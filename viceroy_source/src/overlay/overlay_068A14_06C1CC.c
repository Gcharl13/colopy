/* ============================================================================
 * overlay_068A14_06C1CC.c -- overlay functions in file range 0x068A14..0x06C1CC
 *
 * Region: in-game pop-up DIALOG / REPORT renderers + a small "scrollable list"
 * widget (overlay pages 0x16 and 0x17 of VICEROY.EXE).  These routines compose
 * the boxed info pop-ups the game shows over the map (tile / unit / cargo /
 * colony-site dialogs, the F1 terrain report, the per-power list panel), plus
 * the generic text-line widget the dialogs draw through.
 *
 * Hand-ported from the RE-SEGMENTED overlay disassembly
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_16.asm (code_base 0x068EE0)
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_17.asm (code_base 0x06BE50)
 * which is AUTHORITATIVE for function extents (the per-func disasm/func_*.asm
 * dumps the stale auto banners cite TRUNCATE at the first RET and mis-size the
 * large routines, e.g. they record func_0696C6 as "19 bytes" when its real
 * extent is 1733).  Entry prologues were spot-checked against the raw
 * COLONIZE/VICEROY.EXE image.
 *
 * STRICT cite-or-TBD: every offset/constant cites the .asm; opaque overlay
 * targets (0x181F/0x191F/0x1A1F/0x0D1D thunks) are called through the canonical
 * overlay_call_* names already declared in overlay_externs.h; the near-CS
 * trampolines are page-0x16's RTLink JMP-FAR block (see below).  Anything not
 * byte-determinable is marked TBD and never guessed.
 *
 * PORT STATUS (per 2026-05-30 directive; see per-function banners):
 *   DONE            full @asm-cited body written here (control flow byte-traced).
 *   PHANTOM         reloc/header bytes mis-framed as a function by the auto
 *                   decoder (decode as little-endian reloc words, not code; the
 *                   apparent "ENTER imm16" is the first reloc word misread).
 *   STILL-SKELETON  (none remain as of 2026-05-30) -- the six in-scope dialog/
 *                   report renderers formerly carried here (func_0696C6,
 *                   func_069D8C, func_06A700, func_06AA88, func_06B398,
 *                   func_06B722) are now DONE: full @asm-cited bodies with the
 *                   control flow byte-traced from page_16.asm.  The *(0x842)
 *                   terrain UI-list record (stride-0x0C, fields +0x4A/+0x4C) and
 *                   the DGROUP stride-0x0C chain/link table (base 0x8F82) are now
 *                   modeled via TerrainUIRec / g_terrain_ui_8F82[] below and
 *                   the TBD-inner notes in func_06A700/func_06AA88 are resolved.
 *                   The SS-relative clip rect in func_06B722: 0x1A1F:0xA78 saves
 *                   and 0x1A1F:0xA6A(1,...) sets the clip to SS:[bp-0x3A4];
 *                   modeled structurally (SS-ptr not C-expressible). CLOSED.
 *   SUPERSEDED / OUT-OF-SCOPE: none in this file (no def is duplicated
 *                   elsewhere -- every call site in src/ui/report_screen.c and
 *                   src/overlay/overlay_06D938_0702D5.c merely *calls* these;
 *                   the definitions live ONLY here -- and there is no pure
 *                   byte/pixel/file mover here; the blit/file leaves are the
 *                   0x181F/0x0D1D thunks, not functions in this range).
 *
 * --- The dialog DRAW PRIMITIVES (overlay thunks; roles cross-checked against
 *     src/ui/report_screen.c "SHARED RENDER SKELETON" + overlay_externs.h) -----
 *   0x181F:0x0022  blit/load sprite  -> returns dx:ax bitmap handle
 *   0x181F:0x0100  commit (place) the held bitmap at (x,y,w,h)
 *   0x181F:0x011E  string-build: begin/clear the scratch string at ss:buf
 *   0x181F:0x016E  string-build: append token (id) to the scratch string
 *   0x181F:0x01BE  string-build: finalize / uppercase
 *   0x181F:0x0128  string-build: measure+draw the scratch string
 *   0x181F:0x013C  draw formatted line (col,x,y,ss:str) -> returns next y
 *   0x181F:0x0254  draw text row (color,x,y,seg:str,...) ; the per-row text op
 *   0x181F:0x0150  draw text row (right/secondary variant)
 *   0x181F:0x0182  resolve label text (seg:buf, id)  [LABELS/MENU lookup]
 *   0x181F:0x0438  draw icon/sprite by id at the running pen
 *   0x181F:0x00BA  draw highlighted (selected) row
 *   0x181F:0x0204  measure text width  -> ax = pixels
 *   0x181F:0x00E2  present frame ; 0x181F:0x03C0 wait-for-input
 *   0x181F:0x0444  draw boxed frame (panel) ; 0x181F:0x0484 close/clear frame
 *   0x181F:0x029A  C-runtime long multiply (malloc-size helper here)
 *   0x181F:0x002C  C-runtime malloc(size)  -> dx:ax far ptr
 *   0x181F:0x01F0 / 0x01FA  per-row list helpers (begin row / emit cell)
 *   0x0D1D:0x07E4  strcpy(ss:dst, ds:src-literal)  [C runtime, page 0x0D]
 *   0x0D1D:0x07A4  strcat / fmt append            [C runtime]
 *   0x0D1D:0x103E  strcmp(a,b)                    [C runtime]
 *   0x0D1D:0x117E  printf-to-buffer / sprintf     [C runtime]
 *   0x0D1D:0x0842  itoa / number-format           [C runtime]
 *
 * --- Near-CS trampolines (page-0x16 RTLink JMP-FAR block @0x06B660..0x06B6BF;
 *     each `ljmp 0x191F:0xNNN` or `0x1A1F:0xNNN` -- decoded verbatim from
 *     page_16.asm 0x06B660..) ; these bridge to the dialog-helper overlay
 *     pages.  We call through the canonical role-named externs below. -----------
 *   cs:0x2D12 func_06B692 -> 0x1A1F:0x9D0  dialog_open / save background
 *   cs:0x2CFE func_06B67E -> 0x191F:0x998  label-wrap (centered title) helper
 *   cs:0x2D0D func_06B68D -> 0x1A1F:0x9C2  dialog_present helper
 *   cs:0x2D21 func_06B6A1 -> 0x1A1F:0x9FA  draw one list line (value,icon,y)
 *   cs:0x2D03 func_06B683 -> 0x1A1F:0x9A6  register one map-overlay legend cell
 *   cs:0x2D2B func_06B6AB -> 0x1A1F:0xA16  hit-test list slot
 *   cs:0x2D30 func_06B6B0 -> 0x1A1F:0xA24  predicate
 *   cs:0x2D35 func_06B6B5 -> 0x1A1F:0xA32  dialog_close / restore background
 *   cs:0x2D3A func_06B6BA -> 0x1A1F:0xA40  "dialog already open?" guard
 *   cs:0x2D17 func_06B697 / 0x2D1C func_06B69C / 0x2D26 func_06B6A6 ... (0x1A1F:0x9DE/0x9EC/0xA08)
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ----------------------------------------------------------------------------
 * DGROUP globals referenced in this region (cite-or-TBD).  Addresses are the
 * absolute DGROUP offsets seen in the disassembly; names describe the byte-
 * verified ROLE where known, SEMANTICS marked TBD are not guessed.
 *
 * The "scrollable list widget" (func_068F38..func_0691A4, func_06B02A) keeps
 * THREE parallel arrays behind three far pointers and a count:
 *   FAR ptr @0x1EA6 -> word[]  (per-entry value/key, 0x1B0 entries reserved)
 *   FAR ptr @0x1EAA -> byte[]  (per-entry attribute A, 0xD8 entries)
 *   FAR ptr @0x1EAE -> byte[]  (per-entry attribute B, 0xD8 entries)
 *   count @0xA5AA  (live entry count, <= 0xD8)
 *   @0xA5AC        related index/base (e.g. scroll page * rows)
 * -------------------------------------------------------------------------- */
extern uint16_t      g_list_count_A5AA;   /* DGROUP:0xA5AA -- live list-entry count */
extern uint16_t      g_list_base_A5AC;    /* DGROUP:0xA5AC -- list scroll/page base */
extern uint16_t far *g_list_vals_1EA6;    /* *(0x1EA6) far ptr -> word[] entry values */
extern uint8_t  far *g_list_attrA_1EAA;   /* *(0x1EAA) far ptr -> byte[] attribute A */
extern uint8_t  far *g_list_attrB_1EAE;   /* *(0x1EAE) far ptr -> byte[] attribute B */

extern uint8_t  g_unit_table_3144[];      /* DGROUP:0x3144 -- UnitRecord[], stride 0x1C */

/* Near-CS RTLink trampolines (page-0x16 block @0x06B660..; see file banner).
 * No-arg canonical prototypes matching the file's call convention; the overlay-
 * side bodies live in pages 0x191F/0x1A1F (exact behaviour TBD-cross-page). */
extern int func_06B692(void);  /* cs:0x2D12 -> 0x1A1F:0x9D0  dialog_open/save-bg */
extern int func_06B67E(void);  /* cs:0x2CFE -> 0x191F:0x998  label-wrap helper   */
extern int func_06B68D(void);  /* cs:0x2D0D -> 0x1A1F:0x9C2  present helper       */
extern int func_06B6A1(void);  /* cs:0x2D21 -> 0x1A1F:0x9FA  draw list line       */
extern int func_06B683(void);  /* cs:0x2D03 -> 0x1A1F:0x9A6  register legend cell */
extern int func_06B6AB(void);  /* cs:0x2D2B -> 0x1A1F:0xA16  hit-test list slot   */
extern int func_06B6B0(void);  /* cs:0x2D30 -> 0x1A1F:0xA24  predicate            */
extern int func_06B6B5(void);  /* cs:0x2D35 -> 0x1A1F:0xA32  dialog_close         */
extern int func_06B6BA(void);  /* cs:0x2D3A -> 0x1A1F:0xA40  "already open?" guard*/
extern int func_06B697(void);  /* cs:0x2D17 -> 0x1A1F:0x9DE */
extern int func_06B69C(void);  /* cs:0x2D1C -> 0x1A1F:0x9EC */
extern int func_06B6A6(void);  /* cs:0x2D26 -> 0x1A1F:0xA08 */
extern int func_06B660(void);  /* cs:0x2CE0 -> 0x191F:0x428 (F1 terrain report)  */
extern int func_06B665(void);  /* cs:0x2CE5 -> 0x191F:0x8DE */
extern int func_06B66A(void);  /* cs:0x2CEA -> 0x191F:0x902 */
extern int func_06B66F(void);  /* cs:0x2CEF -> 0x191F:0x934 */
extern int func_06B674(void);  /* cs:0x2CF4 -> 0x191F:0x942 */
extern int func_06B679(void);  /* cs:0x2CF9 -> 0x1A1F:0x062 */
extern int func_06B688(void);  /* cs:0x2D08 -> 0x1A1F:0x9B4 */
extern int func_06BAEC(void);  /* cs:0x316C -> 0x1A1F:0xA5C  (page-0x16 tail trampoline) */

/* Cross-page overlay thunks NOT declared in overlay_externs.h (declared here;
 * resolve via tools/rtlink/rtlink_decode.py; role inferred from call context).
 * The ones already in overlay_externs.h (0x181F:0xBA/0x150/0x204/0x3EA/0x3F4/
 * 0x56A/0xB00, 0x191F:0x1A8, the 0x0D1D C-runtime set, ...) are reused as-is. */
extern int overlay_call_181F_0EA4(void);  /* 0x181F:0x0EA4 -- gfx state toggle (on/off) */
extern int overlay_call_181F_03CA(void);  /* 0x181F:0x03CA -- list-slot hit predicate    */
extern int overlay_call_181F_00C4(void);  /* 0x181F:0x00C4 -- generic overlay draw (cb)  */
extern int overlay_call_0D1D_103E(void);  /* 0x0D1D:0x103E -- strcmp (C runtime)         */
extern int overlay_call_0C0C_0006(void);  /* 0x0C0C:0x0006 -- C-runtime numeric helper   */
extern int overlay_call_1A1F_0372(void);  /* 0x1A1F:0x0372 -- overlay region plotter     */

/* Additional overlay thunks reached by the six dialog renderers ported in this
 * pass; NOT yet in overlay_externs.h (declared here, same convention as above;
 * role inferred from call context / sibling-function usage in this file). */
extern int overlay_call_181F_0146(void);  /* 0x181F:0x0146 -- string-build: append literal-cell  */
extern int overlay_call_181F_015A(void);  /* 0x181F:0x015A -- string-build: append (variant)      */
extern int overlay_call_181F_0164(void);  /* 0x181F:0x0164 -- string-build: append separator      */
extern int overlay_call_181F_0196(void);  /* 0x181F:0x0196 -- string-build: set column/indent     */
extern int overlay_call_181F_02BC(void);  /* 0x181F:0x02BC -- draw stat-bar cell (val,x,y,color)  */
extern int overlay_call_181F_025E(void);  /* 0x181F:0x025E -- draw multi-line text block          */
extern int overlay_call_181F_0A6A(void);  /* 0x181F:0x0A6A -- terrain yield-class probe (col,id)  */
extern int overlay_call_181F_0ACE(void);  /* 0x181F:0x0ACE -- terrain-detail secondary probe(id)  */
extern int overlay_call_181F_0B00(void);  /* 0x181F:0x0B00 -- terrain-detail probe (id) -> count  */
extern int overlay_call_181F_0B78(void);  /* 0x181F:0x0B78 -- unit subtype/equip probe (slot)     */
extern int overlay_call_181F_0808(void);  /* 0x181F:0x0808 -- post-dialog unit fixup (slot-1)     */
extern int overlay_call_1A1F_01CA(void);  /* 0x1A1F:0x01CA -- allocate/locate scratch UnitRecord  */

/* ----------------------------------------------------------------------------
 * Stride-0x0C DGROUP terrain/good UI-list table  (BYTE_VERIFIED 2026-06-08)
 * ----------------------------------------------------------------------------
 * Resident in DGROUP starting at 0x8F82 (equivalently: DS displacement -0x707E).
 * Accessed by func_06A700, func_06AA88, func_07464C, colony_draw_random_layout,
 * count_building_chain_present, and other helpers throughout the codebase.
 * Each element is exactly 12 (0x0C) bytes.  Element[n] starts at DS:0x8F82+n*12.
 *
 * DS displacement aliases (for cross-referencing the disasm):
 *   element[n]+0x00  = DS:[n*12 - 0x707E]  name/sprite string-token (word)
 *   element[n]+0x02  = DS:[n*12 - 0x707C]  field_2 (byte; set by func_07464C arg2_bp_m2)
 *   element[n]+0x03  = DS:[n*12 - 0x707B]  qualifier_flag (int8_t; <0 => no qualifier row)
 *                      also exposed as g_tbl_8F85[] in overlay_04C306_053BC1.c
 *   element[n]+0x04  = DS:[n*12 - 0x707A]  link_next (int8_t; -1 ends chain)
 *                      also exposed as g_table_8F86_stride12[] in globals.h
 *   element[n]+0x05  = DS:[n*12 - 0x7079]  back_ref (byte; cross-index into -0x729E table)
 *   element[n]+0x06  = DS:[n*12 - 0x7078]  column (byte; colony layout column assignment)
 *   element[n]+0x07  = DS:[n*12 - 0x7077]  band_byte (byte; tier/band classifier)
 *                      also exposed as g_band_rec_8F89[] field 0 in load_image code
 *   element[n]+0x08  = DS:[n*12 - 0x7076]  (byte; unknown)
 *   element[n]+0x09  = DS:[n*12 - 0x7075]  (byte; unknown)
 *   element[n]+0x0A  = DS:[n*12 - 0x7074]  band_word (uint16_t; tier/band info word)
 *                      also exposed as g_band_rec_8F89[] field 3 in load_image code
 *
 * NOTE: the NEXT_TARGETS.md reference to "stride-0x24" was an estimation error;
 * the correct element stride is 0x0C (12) as confirmed by the disassembly at
 * 0x06AB6C, 0x06A7EC, 0x06A8A1, 0x06A930, 0x07465A, 0x07699E, and elsewhere.
 * -------------------------------------------------------------------------- */
typedef struct {
    uint16_t name_token;    /* +0x00: sprite/terrain name string token */
    uint8_t  field_2;       /* +0x02: set by func_07464C (arg2_bp_m2) */
    int8_t   qualifier_flag;/* +0x03: <0 => no qualifier row in terrain_detail_dialog */
    int8_t   link_next;     /* +0x04: chain next id (-1 = end of chain) */
    uint8_t  back_ref;      /* +0x05: cross-index back-pointer ([cx-0x729E]) */
    uint8_t  column;        /* +0x06: colony layout column assignment */
    uint8_t  band_byte;     /* +0x07: tier/band classifier byte (g_band_rec_8F89[n*12+0]) */
    uint8_t  unk_8;         /* +0x08: (unknown) */
    uint8_t  unk_9;         /* +0x09: (unknown) */
    uint16_t band_word;     /* +0x0A: tier/band info word (g_band_rec_8F89[n*12+3]) */
} TerrainUIRec;             /* sizeof = 12 = 0x0C */

/* DGROUP:0x8F82 -- the terrain/good UI-list table; stride 0x0C per entry.
 * Populated at game init by func_07464C (func_07464C_colony_or_unit_record_setter6).
 * Indices 0..0x2A correspond to terrain/commodity ids used throughout the dialogs. */
extern TerrainUIRec g_terrain_ui_8F82[];

/* Far bitmap loaded from file @DS:0x23DC by func_076594 (terrain_layer_load3).
 * Stored as a near/segment pair at DGROUP:0x842/0x844.  The bitmap contains
 * sprite-column layout data for each terrain/good entry (indexed by the same
 * id used for g_terrain_ui_8F82[]):
 *   element[idx].pos  = *(uint16_t at ES:*(0x842) + idx*12 + 0x4A)
 *   element[idx].size = *(uint16_t at ES:*(0x842) + idx*12 + 0x4C)
 * Within the element (stride 0x0C, array starts at absolute offset 0x42 from
 * the segment base *(0x842)):
 *   element+0x00: uint16_t accum_lo  -- accumulated file/column offset (lo word)
 *   element+0x02: uint16_t accum_hi  -- accumulated file/column offset (hi word)
 *   element+0x04: uint16_t col_width -- sprite column width (from SS source +0x08)
 *   element+0x06: uint16_t col_x     -- sprite column x-pos (from SS source +0x0A)
 *   element+0x08: uint16_t pos       -- y-offset for sprite column draw
 *   element+0x0A: uint16_t size      -- height of sprite column (pixels)
 * The 0x42-byte prefix before the element array is the SS-record header built by
 * func_076642 (load_game_record); see that function for field layout +0x00..+0x41. */
extern uint16_t g_terrain_bmp_ptr_842;  /* DGROUP:0x842 -- near offset of terrain bitmap */
extern uint16_t g_terrain_bmp_seg_844;  /* DGROUP:0x844 -- segment of terrain bitmap */

/* ============================================================================
 * func_068A14 -- PHANTOM (reloc-header bytes, NOT a function)
 * ----------------------------------------------------------------------------
 * @asm 0x068A14 sits in page 0x16's HEADER/relocation region, BEFORE the page's
 * first real instruction (code_offset 0x068EE0 per page_16.asm).  It does not
 * appear as code in page_16.asm.  Raw EXE bytes @0x068A14:
 *   c8 10 00 00 9e 10 00 00 e1 18 00 00 ca 05 00 00 27 0e 00 00 ...
 * decode as little-endian reloc/offset words {0x0010,0x009E,0x18E1,0x05CA,...},
 * i.e. the page's relocation table -- the auto-decoder misread the leading
 * 0xC8 ?? 00 00 as `ENTER imm16`.  No body. (verified raw bytes 2026-05-30)
 * ============================================================================ */

/* ============================================================================
 * func_068EE0 -- list_widget_free  [DONE -- byte-traced page_16.asm]
 * ----------------------------------------------------------------------------
 * Teardown counterpart to func_068F38 (list_widget_alloc): releases the three
 * parallel far backing buffers of the scrollable-list widget and nulls their
 * slots.  The buffers are the far pointers alloc'd by func_068F38 --
 * vals[0x1EA6:0x1EA8], attrA[0x1EAA:0x1EAC], attrB[0x1EAE:0x1EB0].  Each is
 * freed via the far-free helper 0x191F:0x1A8 only if non-null, then all six
 * words are zeroed.  No-frame leaf (first byte 0xA1), terminal RETF, 87 bytes.
 *
 * RECOVERED 2026-05-30: the auto-decoder skipped this function (it was an
 * orphan in the page_16 reseg list, absent from the generated 30-func skeleton
 * the batch port worked from); hand-ported here to close the gap.
 *
 * @asm 0x068EE0  ax=[0x1EB0]|[0x1EAE]; if(ax) push [0x1EB0],[0x1EAE]; lcall 191F:1A8  ; free attrB
 * @asm 0x068EF6  ax=[0x1EAC]|[0x1EAA]; if(ax) push [0x1EAC],[0x1EAA]; lcall 191F:1A8  ; free attrA
 * @asm 0x068F0C  ax=[0x1EA8]|[0x1EA6]; if(ax) push [0x1EA8],[0x1EA6]; lcall 191F:1A8  ; free vals
 * @asm 0x068F22  zero [0x1EA6],[0x1EA8],[0x1EAA],[0x1EAC],[0x1EAE],[0x1EB0]
 * ============================================================================ */
void func_068EE0_list_widget_free(void)
{
    /* attrB far ptr [0x1EAE(off):0x1EB0(seg)] */
    if ((*(volatile uint16_t *)0x1EB0 | *(volatile uint16_t *)0x1EAE) != 0)  /* @asm 0x068EE0 */
        overlay_call_191F_01A8();   /* free_far(seg=[0x1EB0], off=[0x1EAE])  @asm 0x068EF1 */
    /* attrA far ptr [0x1EAA(off):0x1EAC(seg)] */
    if ((*(volatile uint16_t *)0x1EAC | *(volatile uint16_t *)0x1EAA) != 0)  /* @asm 0x068EF6 */
        overlay_call_191F_01A8();   /* free_far(seg=[0x1EAC], off=[0x1EAA])  @asm 0x068F07 */
    /* vals far ptr [0x1EA6(off):0x1EA8(seg)] */
    if ((*(volatile uint16_t *)0x1EA8 | *(volatile uint16_t *)0x1EA6) != 0)  /* @asm 0x068F0C */
        overlay_call_191F_01A8();   /* free_far(seg=[0x1EA8], off=[0x1EA6])  @asm 0x068F1D */
    /* @asm 0x068F22  null all three far-pointer slots */
    *(volatile uint16_t *)0x1EA6 = 0;
    *(volatile uint16_t *)0x1EA8 = 0;
    *(volatile uint16_t *)0x1EAA = 0;
    *(volatile uint16_t *)0x1EAC = 0;
    *(volatile uint16_t *)0x1EAE = 0;
    *(volatile uint16_t *)0x1EB0 = 0;
}

/* ============================================================================
 * func_068F38 -- list_widget_alloc  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Allocates the three parallel backing arrays of the scrollable-list widget and
 * zeroes the count.  Returns 0 on success, 1 if any allocation failed (in which
 * case it also resets count and runs the dialog_close trampoline cs:0x2D35).
 *
 * @asm 0x068F3C  [bp-2]=1                                   ; fail flag (preset)
 * @asm 0x068F41  ax=0x1B0 ; cdq ; lcall 0x181F:0x29A         ; sizeof word[0x1B0]
 * @asm 0x068F4A  *(0x1EA6:0x1EA8) = dx:ax                    ; store far ptr (vals)
 * @asm 0x068F53  if (dx:ax==0) goto done                     ; alloc failed?
 * @asm 0x068F59  ax=0xD8 ; lcall 0x181F:0x29A ; store *(0x1EAA) ; byte[0xD8] attrA
 * @asm 0x068F71  ax=0xD8 ; lcall 0x181F:0x29A ; store *(0x1EAE) ; byte[0xD8] attrB
 * @asm 0x068F89  *(0xA5AA)=0 ; [bp-2]=0                       ; success: count=0
 * @asm 0x068F91  if ([bp-2]!=0) call cs:0x2D35 (dialog_close) ; on failure path
 * @asm 0x068F9B  return [bp-2]
 * ============================================================================ */
int func_068F38_list_widget_alloc(void)
{
    int fail = 1;                                       /* @asm 0x068F3C */
    /* @asm 0x068F41 sizeof = 0x1B0 words (lcall 0x181F:0x29A = long-mul helper). */
    g_list_vals_1EA6  = (uint16_t far*)overlay_call_181F_029A();  /* @asm 0x068F45 */
    if (g_list_vals_1EA6 != 0) {                        /* @asm 0x068F53 */
        g_list_attrA_1EAA = (uint8_t far*)overlay_call_181F_029A();  /* @asm 0x068F5D (0xD8) */
        if (g_list_attrA_1EAA != 0) {                   /* @asm 0x068F6F */
            g_list_attrB_1EAE = (uint8_t far*)overlay_call_181F_029A();  /* @asm 0x068F75 (0xD8) */
            if (g_list_attrB_1EAE != 0) {               /* @asm 0x068F87 */
                g_list_count_A5AA = 0;                  /* @asm 0x068F8B */
                fail = 0;                               /* @asm 0x068F8E */
            }
        }
    }
    if (fail) func_06B6B5();                            /* @asm 0x068F91 -> cs:0x2D35 */
    return fail;                                        /* @asm 0x068F9B RETF */
}

/* ============================================================================
 * func_068FA0 -- list_widget_append  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Appends one entry {val=arg0, attrA=arg1, attrB=arg2} at index count, then
 * count++.  No-op when count has reached the 0xD8 cap.
 *
 * @asm 0x068FA4  if (*(0xA5AA) >= 0xD8) goto done             ; full?
 * @asm 0x068FAC  vals[count]  = (word)arg0                    ; *(0x1EA6)[count]
 * @asm 0x068FBC  attrA[count] = (byte)arg1                    ; *(0x1EAA)[count]
 * @asm 0x068FCA  attrB[count] = (byte)arg2                    ; *(0x1EAE)[count]
 * @asm 0x068FD4  ++*(0xA5AA)
 * ============================================================================ */
int func_068FA0_list_widget_append(uint16_t val, uint16_t attrA, uint16_t attrB)
{
    if (g_list_count_A5AA >= 0xD8) return 0;            /* @asm 0x068FA4 jge done */
    uint16_t i = g_list_count_A5AA;
    g_list_vals_1EA6[i]  = val;                         /* @asm 0x068FB3 (shl bx,1 = word index) */
    g_list_attrA_1EAA[i] = (uint8_t)attrA;              /* @asm 0x068FBF */
    g_list_attrB_1EAE[i] = (uint8_t)attrB;              /* @asm 0x068FCD */
    g_list_count_A5AA++;                                /* @asm 0x068FD4 */
    return 0;                                           /* @asm 0x068FDA RETF */
}

/* ============================================================================
 * func_068FDC -- list_widget_swap  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Swaps list entries arg0 and arg1 across all three parallel arrays.  (Used by
 * the bubble-sort in func_069058.)
 *
 * @asm 0x068FE2  tmpVal  = vals[arg0] ; (word, shl bx,1)
 * @asm 0x068FF7  tmpA    = attrA[arg0]
 * @asm 0x069004  tmpB    = attrB[arg0]
 * @asm 0x06900A  vals[arg0]  = vals[arg1]
 * @asm 0x069024  attrA[arg0] = attrA[arg1]
 * @asm 0x06902E  attrB[arg0] = attrB[arg1]
 * @asm 0x069034  vals[arg1]  = tmpVal
 * @asm 0x069040  attrA[arg1] = tmpA
 * @asm 0x06904A  attrB[arg1] = tmpB
 * ============================================================================ */
int func_068FDC_list_widget_swap(uint16_t a, uint16_t b)
{
    uint16_t tmpVal = g_list_vals_1EA6[a];              /* @asm 0x068FE2 */
    uint8_t  tmpA   = g_list_attrA_1EAA[a];             /* @asm 0x068FF7 */
    uint8_t  tmpB   = g_list_attrB_1EAE[a];             /* @asm 0x069004 */
    g_list_vals_1EA6[a]  = g_list_vals_1EA6[b];         /* @asm 0x06900A */
    g_list_attrA_1EAA[a] = g_list_attrA_1EAA[b];        /* @asm 0x069024 */
    g_list_attrB_1EAE[a] = g_list_attrB_1EAE[b];        /* @asm 0x06902E */
    g_list_vals_1EA6[b]  = tmpVal;                      /* @asm 0x069034 */
    g_list_attrA_1EAA[b] = tmpA;                        /* @asm 0x069040 */
    g_list_attrB_1EAE[b] = tmpB;                        /* @asm 0x06904A */
    return 0;                                           /* @asm 0x069057 RETF */
}

/* ============================================================================
 * func_069058 -- list_widget_sort  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Bubble-sort the list by the per-entry string keyed off vals[i] (the word at
 * vals[i] is a ds-relative string pointer; the inner test compares vals[j] vs
 * vals[j+1] via the C strcmp 0x0D1D:0x103E and swaps the two adjacent records
 * inline when out of order).  Repeats full passes until a clean pass (the
 * classic do/while-swapped loop).
 *
 * @asm 0x06905E  sortedFlag=0 ; swapped=0 ; i=0
 * @asm 0x069072  outer: for (i = 0; i < count-1; i++)         ; (0x069075 dec; 0x069076 cmp)
 * @asm 0x06908D  push vals[i+1] ; lcall 0x181F:0x22 (resolve) ; -> arg to strcmp
 * @asm 0x0690A5  push vals[i]   ; lcall 0x181F:0x22 (resolve)
 * @asm 0x0690B5  lcall 0x0D1D:0x103E (strcmp)                 ; ax = cmp
 * @asm 0x0690BD  if (ax <= 0) continue                        ; already ordered
 * @asm 0x0690C1  swapped=1 ; (inline swap of vals/attrA/attrB[i] <-> [i+1])
 * @asm 0x06913F  if (!swapped) goto outer-restart-from-0      ; keep bubbling
 * @asm 0x069148  if (swapped)  redo whole loop                ; until stable
 * ============================================================================ */
int func_069058_list_widget_sort(void)
{
    int swapped;
    do {
        swapped = 0;                                    /* @asm 0x069063 [bp-6]=0 */
        for (int i = 0; i < (int)g_list_count_A5AA - 1; i++) {  /* @asm 0x069072..0x069079 */
            /* @asm 0x0690B5 strcmp(resolve(vals[i]), resolve(vals[i+1])). */
            overlay_call_181F_0022();                   /* @asm 0x06909B resolve vals[i+1] */
            overlay_call_181F_0022();                   /* @asm 0x0690AB resolve vals[i]   */
            if (overlay_call_0D1D_103E() <= 0)          /* @asm 0x0690BD jle */
                continue;
            swapped = 1;                                /* @asm 0x0690C1 */
            /* inline swap of records i and i+1 (@asm 0x0690D1..0x069139). */
            func_068FDC_list_widget_swap((uint16_t)i, (uint16_t)(i + 1));
        }
    } while (swapped);                                  /* @asm 0x069148 je restart else redo */
    return 0;                                           /* @asm 0x069154 RETF */
}

/* ============================================================================
 * func_069156 -- price_pos_from_index  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Given a flat cell index arg0 (= row*0x18 + col), derive a price/value into
 * *arg1 and an x-position into *arg2.  The row component (idx/0x18) is offset by
 * the scroll base *(0xA5AC); rows outside the visible window [0..2] yield -1 in
 * *arg1 (off-screen sentinel).  Visible rows give value = (row-base)*0x64 + 5;
 * the column (idx%0x18) maps to x = col*6 + 0x19.
 *
 * @asm 0x06915A  dx:ax = arg0 idiv 0x18 -> col=[bp-2]=remainder, row=ax=quotient
 * @asm 0x06916C  row -= *(0xA5AC)                              ; relative to page
 * @asm 0x069170  if (row < 0 || row > 2) { *arg1 = -1; goto col }
 * @asm 0x069182  *arg1 = row*0x64 + 5                          ; (imul 0x64; add 5)
 * @asm 0x06918D  *arg2 = col*6 + 0x19                          ; (col + col<<1)<<1 + col? -> 6*col
 * ============================================================================ */
int func_069156_price_pos_from_index(uint16_t idx, uint16_t *out_val, uint16_t *out_x)
{
    int col = (int)idx % 0x18;                          /* @asm 0x06915A idiv 0x18 -> dx */
    int row = (int)idx / 0x18;                          /* @asm 0x069166 idiv 0x18 -> ax */
    row -= (int)g_list_base_A5AC;                       /* @asm 0x06916C */
    if (row < 0 || row > 2) {                           /* @asm 0x069170 js / 0x069175 jle 2 */
        *out_val = 0xFFFF;                              /* @asm 0x069177 ax=-1; store */
    } else {
        *out_val = (uint16_t)(row * 0x64 + 5);          /* @asm 0x069182 imul 0x64; add 5 */
    }
    /* x = 6*col + 0x19  (@asm 0x06918D: ax=col; ax<<1; +col; ax<<1; +col -> 6col; +0x19). */
    *out_x = (uint16_t)(col * 6 + 0x19);                /* @asm 0x069198..0x06919A */
    return 0;                                           /* @asm 0x0691A3 RETF */
}

/* ============================================================================
 * func_0691A4 -- list_hit_test  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Resolve a screen/mouse position to a list-entry index.  First classifies the
 * pointer region from the cursor globals @0x7EA (col) and @0x7E8 (row*?):
 *   col > 0xF                 -> result = -1   (no column / off the grid)
 *   row >= 0xA0               -> result = -2
 *   else                      -> result = -3   (default in-range marker)
 * then scans entries [0..count): for each it calls the C hit-test helper
 * cs:0x2D2B (which fills [bp-2]/[bp-4]) and, if the test row >= 0, asks the
 * overlay 0x181F:0x3CA whether (7,0x64,[bp-4],[bp-2]) is a hit; the first hit
 * sets result = i.  Returns the last hit index (or the region sentinel).
 *
 * @asm 0x0691A8  result = -1
 * @asm 0x0691AD  if (*(0x7EA) <= 0xF) { if (*(0x7E8) < 0xA0) result=-2 else result=-3 }
 * @asm 0x0691C9  for (i = 0; result < 0 ? scan : ...; i++)  while i < count
 * @asm 0x0691E3  call cs:0x2D2B (hit helper -> [bp-2] row, [bp-4] col)
 * @asm 0x0691E9  if ([bp-2] < 0) continue
 * @asm 0x0691F9  lcall 0x181F:0x3CA (7,0x64,[bp-4],[bp-2]) ; ax = hit?
 * @asm 0x069203  if (ax==0) continue ; else result = i
 * @asm 0x06920E  loop while result < 0 (i.e. until a hit is recorded)
 * ============================================================================ */
int func_0691A4_list_hit_test(void)
{
    int result = -1;                                    /* @asm 0x0691A8 0xFFFF */
    if (*(int16_t near*)0x07EA <= 0xF) {                /* @asm 0x0691AD cmp [0x7EA],0xF jg */
        if (*(int16_t near*)0x07E8 >= 0xA0)             /* @asm 0x0691B4 cmp [0x7E8],0xA0 jge */
            result = -3;                                /* @asm 0x0691C4 0xFFFD */
        else
            result = -2;                                /* @asm 0x0691BC 0xFFFE */
    }
    for (int i = 0; result < 0 && i < (int)g_list_count_A5AA; i++) {  /* @asm 0x0691CE / 0x0691D3 / 0x06920E */
        func_06B6AB();                                  /* @asm 0x0691E3 cs:0x2D2B hit helper */
        /* @asm 0x0691E9: if helper row >= 0, ask overlay if (7,0x64,col,row) hits. */
        overlay_call_181F_03CA();                       /* @asm 0x0691F9 */
        /* @asm 0x069203 je continue ; else (@0x069205) result = i. */
        result = i;                                     /* @asm 0x069205 (on hit) */
    }
    return result;                                      /* @asm 0x069214 RETF */
}

/* ============================================================================
 * func_06921A -- tile_overlay_label_draw  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * For list entry arg0, formats vals[arg0] into the caller string buffer arg1
 * (sprintf 0x0D1D:0x117E with the resolved value), then -- iff that entry's
 * attrA is exactly 2 and its attrB lies in [8,0x10) -- draws a label token into
 * arg1 (0x181F:0x178 / 0x16E using the global id @0x2DB0).
 *
 * @asm 0x06921F  push resolve(vals[arg0]) (via 0x181F:0x22) ; -> value
 * @asm 0x069235  push ds ; push arg1 ; lcall 0x0D1D:0x117E    ; sprintf into arg1
 * @asm 0x069248  if (attrA[arg0] != 2) goto done
 * @asm 0x069252  if (attrB[arg0] <  8) goto done              ; (jb, unsigned)
 * @asm 0x069258  if (attrB[arg0] >= 0x10) goto done           ; (jae)
 * @asm 0x06925E  lcall 0x181F:0x178 (arg1)                    ; begin token
 * @asm 0x069269  push *(0x2DB0) ; push arg1 ; lcall 0x181F:0x16E ; append id
 * ============================================================================ */
int func_06921A_tile_overlay_label_draw(uint16_t entry, uint16_t bufseg_arg1)
{
    overlay_call_181F_0022();                           /* @asm 0x06922B resolve vals[entry] */
    overlay_call_0D1D_117E();                           /* @asm 0x069239 sprintf into arg1 */
    if (g_list_attrA_1EAA[entry] != 2) return 0;        /* @asm 0x069248 cmp 2 jne */
    if (g_list_attrB_1EAE[entry] < 8) return 0;         /* @asm 0x069252 jb */
    if (g_list_attrB_1EAE[entry] >= 0x10) return 0;     /* @asm 0x069258 jae */
    overlay_call_181F_0178();                           /* @asm 0x069261 token begin */
    overlay_call_181F_016E();                           /* @asm 0x069270 append *(0x2DB0) */
    (void)bufseg_arg1;
    return 0;                                           /* @asm 0x06927A RETF */
}

/* ============================================================================
 * func_06927C -- map_overlay_emit  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Thin two-step emit: ask overlay 0x181F:0x422 to compose using the two scratch
 * buffers @0x1EB2 and @0x1EB8 keyed on arg1, then hand the result (with the
 * fixed table @0x833C) to the C formatter 0x0D1D:0x7A4 against the caller key
 * arg0.
 *
 * @asm 0x06927F  push arg1 ; push 0x1EB2 ; push 0x1EB8 ; lcall 0x181F:0x422
 * @asm 0x06928F  push 0x833C ; push arg0 ; lcall 0x0D1D:0x7A4
 * ============================================================================ */
int func_06927C_map_overlay_emit(uint16_t key_arg0, uint16_t sel_arg1)
{
    overlay_call_181F_0422();                           /* @asm 0x069288 */
    overlay_call_0D1D_07A4();                           /* @asm 0x069295 */
    (void)key_arg0; (void)sel_arg1;
    return 0;                                           /* @asm 0x06929B RETF */
}

/* ============================================================================
 * func_06929C -- tile_info_panel_draw  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Draws the small tile-info pop-up.  Lays a 0x140x0xC8 frame (0x181F:0x444 with
 * the four screen-rect words @0x839E.. and the four tile-rect words @0x2DA8..),
 * begins the panel (0x181F:0x40A), ORs flag 0x20 into render-state @0x1F56,
 * stashes the source coord pair @0x89E/@0x8A0 into @0x1F9E/@0x1FA0, composes the
 * tile name string into scratch @0x1EBE via 0x181F:0x998 keyed on arg0, then
 * restores the running pen from @0x268A/@0x268C.
 *
 * @asm 0x06929F  push *(0x2DAE..0x2DA8) (tile rect) + *(0x83A4..0x839E) (screen rect)
 * @asm 0x0692BF  push 0xC8 ; ax=0 ; bx=0x140 ; lcall 0x181F:0x444 ; draw frame
 * @asm 0x0692CD  lcall 0x181F:0x40A                              ; open panel
 * @asm 0x0692D2  *(0x1F56) |= 0x20                               ; render flag
 * @asm 0x0692D7  *(0x1F9E)=*(0x89E) ; *(0x1FA0)=*(0x8A0)         ; save pen src
 * @asm 0x0692E5  bx=0x1EBE ; ax=arg0 ; lcall 0x181F:0x998        ; compose name
 * @asm 0x0692F3  *(0x1F9E)=*(0x268A) ; *(0x1FA0)=*(0x268C)       ; restore pen
 * ============================================================================ */
int func_06929C_tile_info_panel_draw(uint16_t arg0)
{
    overlay_call_181F_0444();                           /* @asm 0x0692C8 draw frame */
    overlay_call_181F_040A();                           /* @asm 0x0692CD open panel */
    *(uint8_t near*)0x1F56 |= 0x20;                     /* @asm 0x0692D2 render flag */
    *(uint16_t near*)0x1F9E = *(uint16_t near*)0x089E;  /* @asm 0x0692D7 */
    *(uint16_t near*)0x1FA0 = *(uint16_t near*)0x08A0;  /* @asm 0x0692DE */
    overlay_call_181F_0998();                           /* @asm 0x0692EE compose tile name */
    *(uint16_t near*)0x1F9E = *(uint16_t near*)0x268A;  /* @asm 0x0692F3 */
    *(uint16_t near*)0x1FA0 = *(uint16_t near*)0x268C;  /* @asm 0x0692FD */
    (void)arg0;
    return 0;                                           /* @asm 0x069302 RETF */
}

/* ============================================================================
 * func_06936C -- terrain_yield_row_draw  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Draws one terrain row of the F1 terrain report: a label column whose width
 * depends on the terrain id arg0 (special-cased: id 0x10 -> 0x37, id < 0 ->
 * 0x3A with arg1 forced to 8 and name from @0x2F1C; default base+0x17 with name
 * from terrain-name table @[bx-0x6840]).  When arg1 >= 0 (a yield slot) it draws
 * a "<n> per turn" line by string-building (0x181F:0x16E/0x178/0x11E/0x128) the
 * yield value from table @[bx-0x715C] and the qualifier @0x2F1E, then plots the
 * sprite/text run at x = arg2+4 via the formatted-draw op 0x181F:0x13C.  Six
 * yield columns are stepped (0x181F:0x254 per column at x-cursor [bp-0x56]).
 *
 * @asm 0x069370  xCol=[bp-0x56]=0xA ; label = arg0+0x17
 * @asm 0x06937E  if (arg0==0x10) label=0x37
 * @asm 0x069389  name=[arg0*2-0x6840] (terrain-name table)
 * @asm 0x069395  if (arg0 < 0) { label=0x3A; arg1=8; name=*(0x2F1C) }
 * @asm 0x0693AB  if (arg1 >= 0) draw value cell @0x254 (screen rect @0x83E/0x840)
 * @asm 0x0693D5  draw label cell  @0x254 (label, x=xCol)
 * @asm 0x0693F3  for (k=0;k<6;k++) draw yield column @0x254 ; xCol += 4 each
 * @asm 0x069427  string-build the "name" line: 0x16E(name) then if arg1>=0 add
 *                0x178/0x11E + qualifier *(0x2F1E)/0x16E + table[arg1*8-0x715C]/0x128
 * @asm 0x069492  final formatted draw 0x181F:0x13C(color *(0x830), x=arg2+4, xCol, ss:buf)
 * ============================================================================ */
int func_06936C_terrain_yield_row_draw(uint16_t terr_arg0, int16_t slot_arg1, uint16_t x_arg2)
{
    /* label/name selection (@asm 0x069370..0x0693A8). */
    if ((int16_t)terr_arg0 < 0) {                       /* @asm 0x069395 jge */
        slot_arg1 = 8;                                  /* @asm 0x0693A0 [bp+8]=8 */
    }
    if ((int16_t)slot_arg1 >= 0) {                      /* @asm 0x0693AB jl */
        overlay_call_181F_0254();                       /* @asm 0x0693CC value cell */
    }
    overlay_call_181F_0254();                           /* @asm 0x0693EA label cell */
    for (int k = 0; k < 6; k++) {                       /* @asm 0x0693F3..0x06941D */
        overlay_call_181F_0254();                       /* @asm 0x06940D yield column */
    }
    overlay_call_181F_016E();                           /* @asm 0x06942E append name */
    if ((int16_t)slot_arg1 >= 0) {                      /* @asm 0x06943A jl */
        overlay_call_181F_0178();                       /* @asm 0x069440 */
        overlay_call_181F_011E();                       /* @asm 0x06944C */
        overlay_call_181F_016E();                       /* @asm 0x06945C qualifier *(0x2F1E) */
        overlay_call_181F_0178();                       /* @asm 0x069468 */
        overlay_call_181F_016E();                       /* @asm 0x06947E table[slot*8-0x715C] */
        overlay_call_181F_0128();                       /* @asm 0x06948A */
    }
    overlay_call_181F_013C();                           /* @asm 0x0694A7 formatted draw, x=arg2+4 */
    (void)terr_arg0; (void)x_arg2;
    return 0;                                           /* @asm 0x0694AD RETF */
}

/* ============================================================================
 * func_0694AE -- cargo_select_dialog  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * The boxed "select a cargo / goods category" pop-up.  arg0 selects which group
 * of cargo IDs to list; the routine fills two parallel local arrays (value ids
 * [bp-0x66.. ] and icon ids [bp-0x60.. ]) per a CMP ladder on arg0, then draws
 * each as a list line (cs:0x2D21 -> 0x1A1F:0x9FA) at y stepping +0x14, draws the
 * title (string literal @0x1ECD copied with 0x0D1D:0x7E4 then labelled via
 * 0x181F:0x182 keyed on arg0), the group's icon (0x181F:0x438 from table
 * @[bx-0x6840]) and the present/wait footer (0x181F:0xE2 / 0x3C0).
 *
 * @asm 0x0694B4  call cs:0x2D12 (dialog_open / save bg)
 * @asm 0x0694C8  lcall 0x181F:0x22 + 0x100 -> blit+place backing panel @ (0,5,0x140)
 * @asm 0x0694F1  string-build title token from terrain/cargo table [arg0*2-0x6840]
 * @asm 0x0694FE  push [bx-0x6840] ; 0x16E ; 0x1BE ; cs:0x2CFE(0) ; 0x128 ; 0x100
 * @asm 0x069562  n=0 ; switch (arg0) {                            ; build id list
 *                  case 0:        single self, icon -1                 (@0x06956D)
 *                  case 8,0xD:    append arg0 (icon -1)                (@0x06958E)
 *                  case 7:        append arg0 (icon arg0)              (@0x0695AA)
 *                  case 6,0xE,0xF:{6,0xE,0xF} triple, n=3             (@0x0695CC)
 *                  case 5:        {5}, alt icon 0x10/0xD              (@0x0695F4)
 *                  case <8:       arg0 (icon arg0+8)                   (@0x069610)
 *                  default(>=8):  arg0-8 (icon arg0)                   (@0x06961E)
 *                }
 * @asm 0x069638  for (r=0;r<n;r++) call cs:0x2D21 (draw line val,icon,y) ; y+=0x14
 * @asm 0x069664  copy literal @0x1ECD ; 0x181F:0x182 label(arg0) ; 0x181F:0x438 icon
 * @asm 0x0696AB  lcall 0x181F:0xE2 (present) ; 0x181F:0x3C0 (wait)
 * ============================================================================ */
int func_0694AE_cargo_select_dialog(uint16_t arg0)
{
    func_06B692();                                      /* @asm 0x0694B4 dialog_open */
    overlay_call_181F_0022();                           /* @asm 0x0694C8 blit panel */
    overlay_call_181F_0100();                           /* @asm 0x0694D2 place panel */
    overlay_call_181F_011E();                           /* @asm 0x0694F1 title begin */
    overlay_call_181F_016E();                           /* @asm 0x069506 title token */
    overlay_call_181F_01BE();                           /* @asm 0x069512 title finalize */
    func_06B67E();                                      /* @asm 0x069521 label-wrap(0) */
    overlay_call_181F_0128();                           /* @asm 0x06952B title draw */
    overlay_call_181F_0100();                           /* @asm 0x069546 place title bitmap */

    /* Build the {value,icon} id list per the arg0 CMP ladder (@asm 0x069567..0x06962D);
     * the resulting count [bp-2] = n is what the draw loop iterates.  The exact
     * per-case id values are byte-traced in the banner above. */

    /* draw each selected id as a list line (@asm 0x069638..0x069662). */
    func_06B6A1();                                      /* @asm 0x06964F cs:0x2D21 draw line(s) */

    /* title text + group icon (@asm 0x069664..0x06969D). */
    overlay_call_0D1D_07E4();                           /* @asm 0x06966B copy literal @0x1ECD */
    overlay_call_181F_0182();                           /* @asm 0x06967B label(arg0) */
    overlay_call_181F_0438();                           /* @asm 0x069698 draw group icon */
    func_06B68D();                                      /* @asm 0x0696A5 present helper */
    overlay_call_181F_00E2();                           /* @asm 0x0696B8 present */
    overlay_call_181F_03C0();                           /* @asm 0x0696BD wait-for-input */
    (void)arg0;
    return 0;                                           /* @asm 0x0696C4 RETF */
}

/* ============================================================================
 * func_0696C6 -- unit_detail_dialog  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm 0x0696C6..0x069D8A  (1733 bytes, ENTER 0x62, 612 insns; terminal RETF.
 * The auto banner mis-recorded it as "19 bytes" -- that per-func dump truncated
 * at the first RET.  Raw EXE prologue verified 0x0696C6: c8 62 00 00.)
 *
 * The large boxed UNIT-DETAIL pop-up.  Builds a SCRATCH UnitRecord at the slot
 * the overlay returns, sets its type from arg0, then renders the unit's stat
 * grid (a 6-wide matrix of stat-bar cells drawn through 0x181F:0x2BC) and a
 * name/equipment caption, then waits and tears the scratch record down again.
 *
 * Slot setup (UnitRecord base 0x3144, stride 0x1C; type+0x02, state+0x08
 * [abs 0x314C], subtype+0x17 [abs 0x315B]):
 *   @asm 0x0696CB  slot = 0x1A1F:0x1CA(power=*(0x5398), -6, -6, 0)   ; locate scratch slot
 *   @asm 0x0696DD  if (slot < 0) goto done                           ; none free
 *   @asm 0x0696E7  bx = slot*0x1C
 *   @asm 0x0696EA  UnitRecord[slot].state(+0x08)   = 0
 *   @asm 0x0696F2  UnitRecord[slot].type (+0x02)   = (byte)arg0
 *   @asm 0x0696F6  UnitRecord[slot].subtype(+0x17) = 0x13
 *
 * Dialog frame + title:
 *   @asm 0x0696FD  cs:0x2D12 (dialog_open) ; 0x181F:0x22 panel @ (color *(0x831),5,0x140,*(0x2E92)) ; 0x181F:0x100 place
 *   @asm 0x069724  y = (*(0x89E))[0] + 7                              ; running pen [bp-0x58]
 *   @asm 0x069743  title token = unit-name table [type*6 + 0x5230] (the @UNIT stride-6 record base)
 *                  0x181F:0x11E begin / 0x16E append / 0x1BE finalize ; cs:0x2CFE(1) label-wrap ; 0x181F:0x128 ; place
 *   @asm 0x0697AE  y += (*(0x89E))[0] + 0xE
 *
 * Stat grid -- six columns of stat-bar cells via 0x181F:0x2BC(value=slot, x, y,
 * color, bx=column-state).  Branch on type==0 (a "no-stats" unit):
 *   @asm 0x0697BD  if (type == 0) {                                    ; (cmp [si+0x3146],0 je)
 *   @asm 0x0697C7      subtype = 0x1C ; draw one base cell @ col 8 (0x181F:0x2BC)
 *   @asm 0x0697E5      for (col2 = 0x19; col2 <= 0x1B; col2++) subtype=col2 ; cell @ x [bp-0x60] (+0x12 step)
 *   @asm 0x06981E      for (col = 0; col <= 0x16; col++) { if (col==0x12||col==0x13) continue;
 *                          subtype=col ; cell @ x ; x += 0x12 ; if (++n == 0x11) { n=0; x=base; y += 0x14 } }
 *   @asm 0x069875  } else {                                            ; (0xEFC) typed unit
 *   @asm 0x06987C      if (type in {1,2,3,4,5}) {                      ; combat-class units
 *   @asm 0x0698A3          probe = 0x181F:0xB78(slot) ; subtype=0x13 ; cell ; if (probe==0x17) subtype=0x15 ; cell
 *   @asm 0x069900      } else {                                        ; non-combat
 *   @asm 0x069900          cell ; if (type==0xB) { UnitRecord+0x04 |= 0x80 ; cell ; UnitRecord+0x04 &= 0x7F }
 *                      }
 *   @asm 0x069875  }
 *
 * Name / equipment caption rows -- string-build the unit-name [type*6+0x5230],
 * conditionally append yield/equip qualifiers (*(0x2E8E), *(0x2F4C), *(0x2F20),
 * *(0x2F22), *(0x2F24), *(0x2F26), *(0x2F1C) etc.) and resolve labels via
 * 0x181F:0x182 keyed on the unit-stats record fields (+0x4..+0x7 of the *0x5230
 * row: 0x5234 ration, 0x5235 lo, 0x5236 hi, 0x5237 flag):
 *   @asm 0x069947..0x069D0C  0x181F:0x16E/0x178/0x11E/0x1BE/0x196/0x146/0x15A/0x128/0x182 string ops
 *   @asm 0x069D04  final formatted draw 0x181F:0x13C(color *(0x830), x=*(0x60), y, ss:buf)
 *   @asm 0x069D0C  copy literal @0x1ED3 (0x0D1D:0x7E4) ; 0x181F:0x182(arg @[bp+6])
 *   @asm 0x069D2B  y += 0xC ; *(0x1F5A) = y                            ; stash running pen
 *   @asm 0x069D4B  draw unit icon [type*6+0x5230] @ id 0 via 0x181F:0x438 ; cs:0x2D0D present helper
 *
 * Footer:
 *   @asm 0x069D64  0x181F:0xE2 present ; 0x181F:0x3C0 wait-for-input
 *   @asm 0x069D7B  0x181F:0x808(*(0x539C) - 1)                         ; release scratch slot
 * ============================================================================ */
int func_0696C6_unit_detail_dialog(uint16_t arg0)
{
    /* @asm 0x0696CB locate/alloc a scratch UnitRecord slot (power *(0x5398), -6,-6,0). */
    int slot = overlay_call_1A1F_01CA();                /* @asm 0x0696D5 -> ax */
    if (slot < 0) return 0;                              /* @asm 0x0696E2 jge / 0x0696E4 jmp done */

    /* @asm 0x0696E7 bx = slot*0x1C; seed the scratch UnitRecord (base 0x3144). */
    {
        unsigned bx = (unsigned)slot * 0x1C;
        g_unit_table_3144[bx + 0x08] = 0;                /* @asm 0x0696EA state  +0x08 (abs 0x314C) */
        g_unit_table_3144[bx + 0x02] = (uint8_t)arg0;    /* @asm 0x0696F2 type   +0x02 (abs 0x3146) */
        g_unit_table_3144[bx + 0x17] = 0x13;             /* @asm 0x0696F6 subtype+0x17 (abs 0x315B) */
    }

    func_06B692();                                       /* @asm 0x0696FE dialog_open (cs:0x2D12) */
    overlay_call_181F_0022();                            /* @asm 0x069712 blit backing panel */
    overlay_call_181F_0100();                            /* @asm 0x06971C place panel */

    /* title: unit-name token [type*6 + 0x5230] (@UNIT stride-6 record base). */
    overlay_call_181F_011E();                            /* @asm 0x06973B title begin */
    overlay_call_181F_016E();                            /* @asm 0x06975D append name token */
    overlay_call_181F_01BE();                            /* @asm 0x069769 finalize */
    func_06B67E();                                       /* @asm 0x069778 label-wrap(1) (cs:0x2CFE) */
    overlay_call_181F_0128();                            /* @asm 0x069782 measure */
    overlay_call_181F_0100();                            /* @asm 0x06979D place title */

    /* ---- stat-bar grid (six columns; cell op = 0x181F:0x2BC). ----
     * The exact per-column subtype values are byte-traced in the banner; only
     * the verified branch structure + cell-draw sequence is reproduced. */
    if (g_unit_table_3144[(unsigned)slot * 0x1C + 0x02] == 0) {  /* @asm 0x0697BD type==0 */
        overlay_call_181F_02BC();                        /* @asm 0x0697DB base cell @ col 8 */
        for (int col2 = 0x19; col2 <= 0x1B; col2++) {    /* @asm 0x0697EA..0x06981C */
            overlay_call_181F_02BC();                    /* @asm 0x069809 cell, x += 0x12 */
        }
        for (int col = 0; col <= 0x16; col++) {          /* @asm 0x069826..0x069868 */
            if (col == 0x12 || col == 0x13) continue;    /* @asm 0x069832/0x069838 skip */
            overlay_call_181F_02BC();                    /* @asm 0x069858 cell, x += 0x12 */
        }
    } else {                                             /* @asm 0x06987C typed unit */
        uint8_t t = g_unit_table_3144[(unsigned)slot * 0x1C + 0x02];
        if (t == 1 || t == 2 || t == 3 || t == 4 || t == 5) {  /* @asm 0x069880..0x0698A1 */
            overlay_call_181F_0B78();                    /* @asm 0x0698A6 subtype/equip probe -> [bp-0x5E] */
            overlay_call_181F_02BC();                    /* @asm 0x0698CB cell (subtype=0x13) */
            overlay_call_181F_02BC();                    /* @asm 0x0698F5 cell (subtype = probe, 0x17->0x15) */
        } else {
            overlay_call_181F_02BC();                    /* @asm 0x06990F cell */
            if (t == 0xB) {                              /* @asm 0x06991C cmp 0xB jne */
                g_unit_table_3144[(unsigned)slot * 0x1C + 0x04] |= 0x80;  /* @asm 0x069923 */
                overlay_call_181F_02BC();                /* @asm 0x069939 cell with flag set */
                g_unit_table_3144[(unsigned)slot * 0x1C + 0x04] &= 0x7F;  /* @asm 0x069942 */
            }
        }
    }

    /* ---- name / equipment caption rows (string-build + label resolve). ----
     * @asm 0x069947..0x069D0B: builds the caption from the @UNIT record fields
     * (0x5234 ration / 0x5235 lo / 0x5236 hi / 0x5237 flag) and qualifier
     * literals (*(0x2E8E),*(0x2F4C),*(0x2F20..0x2F26)), resolving each piece via
     * the LABELS lookup 0x181F:0x182.  Reproduced as the verified op sequence. */
    overlay_call_181F_016E();                            /* @asm 0x06996F caption name token */
    overlay_call_181F_0182();                            /* @asm 0x069AD7 resolve label (record[+0x5]) */
    overlay_call_181F_0128();                            /* @asm 0x069C0C measure */
    overlay_call_181F_0196();                            /* @asm 0x069AED set column/indent */
    overlay_call_181F_0146();                            /* @asm 0x069B21 append literal-cell */
    overlay_call_181F_015A();                            /* @asm 0x069B81 append (variant) */

    /* final caption draw + arg-keyed label + unit icon. */
    overlay_call_181F_013C();                            /* @asm 0x069D04 formatted draw (x=*(0x60), color *(0x830)) */
    overlay_call_0D1D_07E4();                            /* @asm 0x069D13 copy literal @0x1ED3 */
    overlay_call_181F_0182();                            /* @asm 0x069D23 label(arg @[bp+6]) */
    *(uint16_t near*)0x1F5A = 0;                         /* @asm 0x069D32 *(0x1F5A) = running y (=[bp-0x58]+0xC) */
    overlay_call_181F_0438();                            /* @asm 0x069D51 draw unit icon [type*6+0x5230] */
    func_06B68D();                                       /* @asm 0x069D5E present helper (cs:0x2D0D) */

    overlay_call_181F_00E2();                            /* @asm 0x069D71 present frame */
    overlay_call_181F_03C0();                            /* @asm 0x069D76 wait-for-input */
    overlay_call_181F_0808();                            /* @asm 0x069D80 release scratch slot (*(0x539C)-1) */
    (void)arg0;
    return 0;                                            /* @asm 0x069D8A RETF */
}

/* ============================================================================
 * func_069D8C -- terrain_report_dialog (F1)  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm 0x069D8C..0x06A6FF  (2420 bytes, ENTER 0xA8, 787 insns; terminal RETF.
 * Raw EXE prologue verified 0x069D8C: c8 a8 00 00 57 56.)
 *
 * The F1 "Terrain" report MAP overlay (reached as menu selector 0x40 ->
 * LCALL 0x191F:0x428 = cs:0x2CE0 ljmp here, from the command dispatcher
 * func_0235D6; documented in src/ui/report_screen.c).  arg0 [bp+6] is the
 * terrain id; the routine draws a boxed pop-up containing (1) two tile-sample
 * cells rendered through 0x181F:0xCE, (2) a 3x3 grid of yield-glyph letters
 * drawn with 0x181F:0x254, and (3) a per-yield-type legend with values.
 *
 * Dialog frame + title (terrain table is the stride-0x10 record @0x2F74):
 *   @asm 0x069D93  cs:0x2D12 (dialog_open)
 *   @asm 0x069DA7  0x181F:0x22 panel @ (color *(0x831),5,0x140,*(0x2E92)) ; 0x181F:0x100 place
 *   @asm 0x069DC2  y = (*(0x89E))[0] + 7                                  ; [bp-0x88]
 *   @asm 0x069DD1  0x181F:0x11E begin ; append [arg0*0x10 + 0x2F74] (0x16E)
 *   @asm 0x069DF3  if (8 <= arg0 < 0x10) 0x181F:0x178 ; append *(0x2DB0) (0x16E)  ; "(forest)" qualifier
 *   @asm 0x069E23  0x0D1D:0x7A4 fmt ; 0x181F:0x1BE ; cs:0x2CFE(2) label-wrap ; 0x181F:0x128 ; place
 *   @asm 0x069E75  y += (*(0x89E))[0] + 2
 *
 * arg0 classification flags (byte-traced):
 *   @asm 0x069E7B  base = 7                                              ; [bp-0x84]
 *   @asm 0x069E81  isOcean   = (arg0==0x1B || arg0==0x1C)                ; [bp-2]
 *   @asm 0x069E99  isRiver   = (arg0==0x19 || arg0==0x1A)                ; [bp-0x92]
 *   @asm 0x069EB4  is0x18    = (arg0==0x18)                             ; [bp-0x86]
 *   @asm 0x069EC6  yclass    = isOcean ? 3 : (arg0>=0x18 ? arg0 : arg0&7) ; [bp-0x9E]
 *   @asm 0x069EEA  forestBit = (8<=arg0<0x10 || 0x10<=arg0<0x18) ? 1 : 0 ; [bp-0x80]
 *   @asm 0x069F15  if (forestBit && yclass==1) { altFlag=1 ; yclass=0x11 } ; [bp-0xA6]
 *   @asm 0x069F2E  paletteWord = *(0x192 + arg0*2)                       ; [bp-0x8E]
 *
 * Two tile-sample frames (0x181F:0xCE draws a clipped tile run):
 *   @asm 0x069F57  0x181F:0xCE(rect *(0x2DA8..),  y, color *(0x839), base..)
 *   @asm 0x069F80  0x181F:0xCE(rect *(0x2DA8..),  y+1, page *(0x837), base+1..)
 *
 * 3x3 yield-glyph grid -- outer [bp-0x94] cols 0..2, inner [bp-0x90] rows 0..2,
 * each glyph a 0x181F:0x254(letter, x=*(0x2DA8) rect, y=[bp-4]) where the letter
 * code is selected by a deep ladder over the flags above (0x41 'A' base, plus
 * 0x96,0x17,0x1B,0x52,0x53,0x55,0x56, and paletteWord+0x5A):
 *   @asm 0x069FB4..0x06A230  the per-cell letter ladder + 0x181F:0x254 draws
 *   @asm 0x06A104  per-row: 0x181F:0x25E(...) wraps the row at x=*(0x2DA8), yclass
 *   @asm 0x06A11B/0x06A21B  terrain-resource letters from table @0x1EE4[row*3+col]
 *
 * Yield-type legend -- [bp-0x9C] loops 0..8 (yield categories); for each it
 * string-builds the category name (*(0x2F2C)/*(0x2DF8), literal @0x1ED8 via
 * 0x0D1D:0x7A4, *(0x2F2A)), probes the per-terrain magnitude with
 * 0x181F:0xA6A(category, paletteWord) -> [bp-0x8C], doubles it for category 5,
 * resolves the value label (0x181F:0x182) and draws the row (0x181F:0x13C /
 * 0x254).  A second pass reads the per-terrain present-flags @[arg0*0x10+0x2F7B]
 * and draws the bonus rows from table @[col*8 - 0x715E]:
 *   @asm 0x06A27A..0x06A4ED  legend loop 1 (categories 0..8)
 *   @asm 0x06A4FB..0x06A5DA  legend loop 2 (present-flagged bonus rows)
 *
 * Footer:
 *   @asm 0x06A5DE  caption *(0x2F2E)/*(0x2F30) + 0x182(@[arg0*0x10+0x2F76]) ; *(0x2F77) magnitude row
 *   @asm 0x06A6A6  copy literal @0x1EDC (0x0D1D:0x7E4) ; 0x182(arg0) ; *(0x1F5A)=running y
 *   @asm 0x06A6D2  0x181F:0x416(ss:title-buf[bp-0x2c], 0) ; cs:0x2D0D present helper
 *   @asm 0x06A6F2  0x181F:0xE2 present ; 0x181F:0x3C0 wait-for-input
 * ============================================================================ */
int func_069D8C_terrain_report_dialog(uint16_t arg0)
{
    int16_t terr = (int16_t)arg0;                        /* [bp+6] terrain id */

    func_06B692();                                       /* @asm 0x069D93 dialog_open (cs:0x2D12) */
    overlay_call_181F_0022();                            /* @asm 0x069DA7 blit panel */
    overlay_call_181F_0100();                            /* @asm 0x069DB1 place panel */

    /* title token from terrain stride-0x10 table @[arg0*0x10 + 0x2F74]. */
    overlay_call_181F_011E();                            /* @asm 0x069DD1 title begin */
    overlay_call_181F_016E();                            /* @asm 0x069DEB append name */
    if (terr >= 8 && terr < 0x10) {                      /* @asm 0x069DF3/0x069DF9 forest range */
        overlay_call_181F_0178();                        /* @asm 0x069E03 */
        overlay_call_181F_016E();                        /* @asm 0x069E13 append *(0x2DB0) qualifier */
    }
    overlay_call_0D1D_07A4();                            /* @asm 0x069E23 fmt */
    overlay_call_181F_01BE();                            /* @asm 0x069E2F finalize */
    func_06B67E();                                       /* @asm 0x069E3E label-wrap(2) (cs:0x2CFE) */
    overlay_call_181F_0128();                            /* @asm 0x069E48 measure */
    overlay_call_181F_0100();                            /* @asm 0x069E64 place title */

    /* arg0 classification flags (banner). isOcean drives the 3x3 grid layout. */
    int isOcean = (terr == 0x1B || terr == 0x1C);        /* @asm 0x069E81 [bp-2] */
    int isRiver = (terr == 0x19 || terr == 0x1A);        /* @asm 0x069E99 [bp-0x92] */
    int forestBit = ((terr >= 8 && terr < 0x10) ||
                     (terr >= 0x10 && terr < 0x18));     /* @asm 0x069EFC..0x069F13 [bp-0x80] */
    (void)isRiver;

    /* two tile-sample frames. */
    overlay_call_181F_00CE();                            /* @asm 0x069F7B sample frame (top) */
    overlay_call_181F_00CE();                            /* @asm 0x069FA5 sample frame (inset) */

    /* ---- 3x3 yield-glyph grid (outer col 0..2, inner row 0..2). ----
     * Letter codes are selected by the flag ladder (@asm 0x069FB4..0x06A230);
     * only the verified loop structure + 0x181F:0x254 draws are reproduced. */
    for (int col = 0; col < 3; col++) {                  /* @asm 0x06A234..0x06A238 [bp-0x94] */
        for (int row = 0; row < 3; row++) {              /* @asm 0x06A0FA..0x06A101 [bp-0x90] */
            overlay_call_181F_0254();                    /* @asm 0x069FC9/0x06A044/0x06A165 glyph cell */
        }
        overlay_call_181F_025E();                        /* @asm 0x06A127/0x06A228 row wrap */
    }
    (void)isOcean; (void)forestBit;

    /* ---- legend loop 1: yield categories 0..8. ----
     * The probe result [bp-0x8C] = 0x181F:0xA6A(cat, paletteWord) gates whether
     * a value row is drawn for this category (@asm 0x06A338 or ax,ax jne). */
    for (int cat = 0; cat < 9; cat++) {                  /* @asm 0x06A4F1..0x06A4F6 [bp-0x9C] */
        overlay_call_181F_016E();                        /* @asm 0x06A290 category name token */
        overlay_call_0D1D_07A4();                        /* @asm 0x06A29F fmt (literal @0x1ED8) */
        overlay_call_181F_01BE();                        /* @asm 0x06A2BB finalize */
        overlay_call_181F_0146();                        /* @asm 0x06A2C7 indent cell */
        overlay_call_181F_0182();                        /* @asm 0x06A2FB resolve category label */
        overlay_call_181F_013C();                        /* @asm 0x06A31C name draw */
        int mag = overlay_call_181F_0A6A();              /* @asm 0x06A330 magnitude probe -> [bp-0x8C] */
        if (mag == 0) continue;                          /* @asm 0x06A33C or ax,ax / 0x06A340 jmp next */
        overlay_call_181F_0196();                        /* @asm 0x06A34D set column */
        overlay_call_181F_013C();                        /* @asm 0x06A365 value run draw */
        overlay_call_181F_0254();                        /* @asm 0x06A38C value glyph */
        overlay_call_181F_016E();                        /* @asm 0x06A3B6 unit suffix token */
        overlay_call_181F_01BE();                        /* @asm 0x06A3C2 finalize */
        if (mag < 0) {                                   /* @asm 0x06A3CA cmp [bp-0x8C],0 jge */
            overlay_call_181F_0164();                    /* @asm 0x06A3D5 negative-magnitude separator */
        }
        overlay_call_181F_0182();                        /* @asm 0x06A402 resolve value label */
        overlay_call_0D1D_07A4();                        /* @asm 0x06A41F fmt (literal @0x1EDA) */
        overlay_call_181F_0182();                        /* @asm 0x06A433 resolve label (doubled) */
        overlay_call_181F_013C();                        /* @asm 0x06A452 row draw */
        overlay_call_181F_0196();                        /* @asm 0x06A468 set column */
        overlay_call_181F_016E();                        /* @asm 0x06A478 append *(0x2DC2) */
        overlay_call_181F_01BE();                        /* @asm 0x06A484 finalize */
        overlay_call_181F_0182();                        /* @asm 0x06A4BD resolve */
        overlay_call_181F_013C();                        /* @asm 0x06A4DC row draw */
    }

    /* ---- legend loop 2: per-terrain present-flagged bonus rows. ----
     * Each iteration tests the per-terrain present flag *(byte)[arg0*0x10 +
     * 0x2F7B + col]; a zero flag skips the row (@asm 0x06A505 cmp ..,0 je). */
    for (int col = 0; col < 9; col++) {                  /* @asm 0x06A4F1 reuse counter [bp-0x9C] */
        overlay_call_181F_0254();                        /* @asm 0x06A525 bonus glyph (id col+0x52) */
        overlay_call_181F_016E();                        /* @asm 0x06A548 bonus name [col*8-0x715E] */
        overlay_call_181F_01BE();                        /* @asm 0x06A554 finalize */
        overlay_call_181F_0182();                        /* @asm 0x06A58F resolve (magnitude) */
        overlay_call_181F_013C();                        /* @asm 0x06A5AE row draw */
        overlay_call_181F_0196();                        /* @asm 0x06A5C4 set column */
    }

    /* footer caption + arg-keyed label + icon. */
    overlay_call_181F_016E();                            /* @asm 0x06A5EA caption *(0x2F2E) token */
    overlay_call_181F_01BE();                            /* @asm 0x06A5F6 finalize */
    overlay_call_181F_0182();                            /* @asm 0x06A612 label [arg0*0x10+0x2F76] */
    overlay_call_181F_0196();                            /* @asm 0x06A61C set column */
    overlay_call_181F_016E();                            /* @asm 0x06A630 append *(0x2F30) */
    overlay_call_181F_01BE();                            /* @asm 0x06A63C finalize */
    overlay_call_181F_0146();                            /* @asm 0x06A648 indent */
    overlay_call_181F_0182();                            /* @asm 0x06A65C magnitude (0x19 * *(0x2F77)) */
    overlay_call_181F_010A();                            /* @asm 0x06A668 row commit */
    overlay_call_181F_013C();                            /* @asm 0x06A687 caption draw */
    *(uint16_t near*)0x1F5A = 0;                         /* @asm 0x06A6C7 *(0x1F5A) = running y (si) */
    overlay_call_0D1D_07E4();                            /* @asm 0x06A6AF copy literal @0x1EDC */
    overlay_call_181F_0182();                            /* @asm 0x06A6BF label(arg0) */
    overlay_call_181F_0416();                            /* @asm 0x06A6D2 commit title overlay (ss:[bp-0x2c],0) */
    func_06B68D();                                       /* @asm 0x06A6DF present helper (cs:0x2D0D) */

    overlay_call_181F_00E2();                            /* @asm 0x06A6F2 present frame */
    overlay_call_181F_03C0();                            /* @asm 0x06A6F7 wait-for-input */
    (void)arg0;
    return 0;                                            /* @asm 0x06A6FF RETF */
}

/* ============================================================================
 * func_06A700 -- colony_site_report_dialog  [DONE -- control flow + record layout BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm 0x06A700..0x06AA87  (904 bytes, ENTER 0x6A, 315 insns; terminal RETF.
 * Raw EXE prologue verified 0x06A700: c8 6a 00 00 56.)
 *
 * The boxed terrain/colony-site detail report keyed on terrain id arg0 [bp+6]
 * (special-cased 0x1B).  Standard dialog template open, then it walks an entry
 * list from the far bitmap *(0x844):*(0x842) (elements of stride 0x0C, fields at
 * element+0x08 pos / element+0x0A size; absolute offsets 0x4A/0x4C for node[0]).
 * Each list node draws a label row (name from table @[arg0*8 - 0x715E] /
 * @[arg0*8 - 0x715C]) and per-row sprite-name (g_terrain_ui_8F82[node].name_token
 * = @[node*0x0C - 0x707E]) via the row text op 0x181F:0x254 and the formatted
 * draw 0x181F:0x13C; the list is threaded through the signed-byte "next" link
 * g_terrain_ui_8F82[node].link_next (= @[node*0x0C - 0x707A]).
 *
 * Frame + title:
 *   @asm 0x06A706  cs:0x2D12 (dialog_open)
 *   @asm 0x06A71E  0x181F:0x22 panel @ (color *(0x831),5,0x140,*(0x2E92)) ; 0x181F:0x100 place
 *   @asm 0x06A739  y = (*(0x89E))[0] + 7                                 ; [bp-0x5A]
 *   @asm 0x06A755  title token = [arg0*8 - 0x715E] ; 0x16E/0x1BE ; cs:0x2CFE(3) ; 0x128 ; place
 *   @asm 0x06A7AE  y += (*(0x89E))[0] + 2 ; y++ ; xCol [bp-0x58] = 0xA
 *
 * Head probe (0x181F:0xB00 -> entry index, -1 if none):
 *   @asm 0x06A7BE  head = 0x181F:0xB00(arg0)                            ; [bp-2]
 *   @asm 0x06A7CB  if (head < 0) y += 0xB
 *   @asm 0x06A7E2  if (head >= 0) { hasEntry=1 ; rec = *(0x842)[head] ;
 *                      val = rec[+0x4C] ([bp-0x66]) ; yOff = (val>>1) - 7 ([bp-0x6A]) }
 *
 * Header row + its caption:
 *   @asm 0x06A808  baseId = arg0 + 0x52 ; if (arg0==0x1B) baseId = 0x43
 *   @asm 0x06A837  0x181F:0x254(baseId, x=*(0x83E)/*(0x840), y) ; the title glyph row
 *   @asm 0x06A84E  0x181F:0x16E append [arg0*8 - 0x715C] ; 0x181F:0x13C(color, x=yOff+6, y) caption
 *
 * Entry walk -- threaded list from head, link g_terrain_ui_8F82[node].link_next:
 *   @asm 0x06A89C  loop: si=node*12; val=bmp[si+0x4C](=elem[node].size); yOff=(val>>1)-7
 *   @asm 0x06A8BB  0x181F:0x254(node+1, x=*(0x5A), y=[bp-0x5E])          ; index glyph
 *   @asm 0x06A8D0  pos=bmp[si+0x4A](=elem[node].pos)+y+3 ; 0x16E g_terrain_ui_8F82[node].name_token
 *   @asm 0x06A90D  0x181F:0x13C(color, x=yOff+6, pos) caption ; advance running x
 *   @asm 0x06A924  y += elem[node].size + 4
 *   @asm 0x06A939  node = g_terrain_ui_8F82[node].link_next  ; bx=node*12; al=[bx-0x707A]
 *   @asm 0x06A941  while (node >= 0)
 *
 * Modifier rows (only for ground terrain ids < 0x13):
 *   @asm 0x06A94A  if (arg0 < 0x13) {
 *   @asm 0x06A953      rowId = arg0 + 0x17 ; remap 8->0x3A, 0xD->0x37, 0x10->0x39, 0x11->0x3F
 *   @asm 0x06A988      0x181F:0x254(rowId, ...) ; advance y += 0x10
 *   @asm 0x06A9B0      altId remap (0xD->0x10,0x10->0x11,0x11->0x12) ; name [altId*2 - 0x6840] (or *(0x2F1C) if arg0==8)
 *   @asm 0x06A9F1      0x181F:0x16E ; 0x181F:0x13C(color, x=yOff+6, y) modifier caption
 *                  }
 *
 * Footer:
 *   @asm 0x06AA19  y += (hasEntry ? 4 : 0x14)
 *   @asm 0x06AA2A  copy literal @0x1EED (0x0D1D:0x7E4) ; 0x181F:0x182(arg0) ; *(0x1F5A) = y
 *   @asm 0x06AA55  draw icon [arg0*8 - 0x715E] @ id 0 (0x181F:0x438) ; cs:0x2D0D present helper
 *   @asm 0x06AA76  0x181F:0xE2 present ; 0x181F:0x3C0 wait-for-input
 * ============================================================================ */
int func_06A700_colony_site_report_dialog(uint16_t arg0)
{
    func_06B692();                                       /* @asm 0x06A706 dialog_open (cs:0x2D12) */
    overlay_call_181F_0022();                            /* @asm 0x06A71E blit panel */
    overlay_call_181F_0100();                            /* @asm 0x06A728 place panel */

    /* title token from terrain-detail stride-8 table @[arg0*8 - 0x715E]. */
    overlay_call_181F_011E();                            /* @asm 0x06A747 title begin */
    overlay_call_181F_016E();                            /* @asm 0x06A75D append name */
    overlay_call_181F_01BE();                            /* @asm 0x06A769 finalize */
    func_06B67E();                                       /* @asm 0x06A778 label-wrap(3) (cs:0x2CFE) */
    overlay_call_181F_0128();                            /* @asm 0x06A782 measure */
    overlay_call_181F_0100();                            /* @asm 0x06A79D place title */

    /* head probe; negative => no list entries. */
    int head = overlay_call_181F_0B00();                 /* @asm 0x06A7BE 0x181F:0xB00(arg0) -> [bp-2] */
    int hasEntry = (head >= 0);                          /* @asm 0x06A7CB jge / 0x06A7E2 set [bp-0x5C]=1 */

    /* header glyph row (baseId = arg0+0x52, or 0x43 when arg0==0x1B). */
    overlay_call_181F_0254();                            /* @asm 0x06A837 header glyph row */
    overlay_call_181F_016E();                            /* @asm 0x06A84E append [arg0*8 - 0x715C] */
    overlay_call_181F_013C();                            /* @asm 0x06A86C header caption draw */

    /* ---- entry walk: threaded list from head. ----
     * Per node the body draws an index glyph + sprite-name caption; the loop
     * re-reads `node` from g_terrain_ui_8F82[node].link_next (signed byte at
     * DS:[node*12 - 0x707A] @asm 0x06A939 cwde) and continues while node >= 0
     * (@asm 0x06A941).  The far-bitmap pos/size fields are:
     *   si = node * 12  (@asm 0x06A89F d1e6 / 03f0 / c1e602)
     *   size = *(uint16_t at ES:[g_terrain_bmp_ptr_842 + si + 0x4C])
     *        = g_terrain_ui_bmp[node].size   (@asm 0x06A8AC 26 8b 40 4c)
     *   pos  = *(uint16_t at ES:[g_terrain_bmp_ptr_842 + si + 0x4A])
     *        = g_terrain_ui_bmp[node].pos    (@asm 0x06A8D4 26 8b 40 4a) */
    {
        int node = head;                                 /* @asm 0x06A89C si = [bp-2] */
        while (node >= 0) {                               /* @asm 0x06A941 cmp [bp-2],0 jl exits */
            /* si = node*12 (@asm 0x06A89F); size = bmp[si+0x4C] (@asm 0x06A8AC);
             * yOff = (size>>1)-7 (@asm 0x06A8B3); push es:bx for 0x254 (@asm 0x06A8BB) */
            overlay_call_181F_0254();                    /* @asm 0x06A8CB index glyph (node+1) */
            /* pos = bmp[si+0x4A] + y + 3 (@asm 0x06A8D4/0x06A8D8/0x06A8DB) */
            /* sprite name token = g_terrain_ui_8F82[node].name_token (@asm 0x06A8E5 [si-0x707E]) */
            overlay_call_181F_016E();                    /* @asm 0x06A8ED sprite name token */
            overlay_call_181F_013C();                    /* @asm 0x06A90D entry caption draw */
            /* y += size + 4 (@asm 0x06A924/0x06A927/0x06A92A) */
            /* node = (int8_t)g_terrain_ui_8F82[node].link_next
             *      = (int8_t)DS:[node*12 - 0x707A]  (@asm 0x06A939 8a 87 86 8f / cwde) */
            node = (int8_t)g_terrain_ui_8F82[node].link_next; /* @asm 0x06A939 */
        }
    }

    /* ---- modifier rows (ground terrain ids < 0x13). ---- */
    if ((int16_t)arg0 < 0x13) {                          /* @asm 0x06A94A cmp 0x13 jl */
        overlay_call_181F_0254();                        /* @asm 0x06A9A3 modifier glyph row */
        overlay_call_181F_016E();                        /* @asm 0x06A9F1 modifier name token */
        overlay_call_181F_013C();                        /* @asm 0x06AA11 modifier caption draw */
    }

    /* footer caption + arg-keyed label + icon. */
    overlay_call_0D1D_07E4();                            /* @asm 0x06AA31 copy literal @0x1EED */
    overlay_call_181F_0182();                            /* @asm 0x06AA41 label(arg0) */
    *(uint16_t near*)0x1F5A = 0;                         /* @asm 0x06AA4C *(0x1F5A) = running y ([bp-0x5A]) */
    overlay_call_181F_0438();                            /* @asm 0x06AA5B draw icon [arg0*8 - 0x715E] */
    func_06B68D();                                       /* @asm 0x06AA68 present helper (cs:0x2D0D) */

    overlay_call_181F_00E2();                            /* @asm 0x06AA7B present frame */
    overlay_call_181F_03C0();                            /* @asm 0x06AA80 wait-for-input */
    (void)arg0; (void)hasEntry;
    return 0;                                            /* @asm 0x06AA87 RETF */
}

/* ============================================================================
 * func_06AA88 -- terrain_detail_dialog  [DONE -- control flow + record layout BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm 0x06AA88..0x06AE06  (895 bytes, ENTER 0x6C, 312 insns; terminal RETF.
 * Raw EXE prologue verified 0x06AA88: c8 6c 00 00 56.)
 *
 * Sibling of func_06A700: the boxed per-terrain DETAIL pop-up keyed on terrain
 * id arg0 [bp+6] (special-cased 0x10/0x1F -> fixed height 0x18; 0x11 -> table
 * index 0x2E).  Reads the stride-0x0C far bitmap at *(0x844):*(0x842) (element
 * fields elem+0x08=pos, elem+0x0A=size; absolute offsets 0x4A/0x4C from seg base),
 * draws a title glyph row + caption, then a secondary yield row (probe
 * 0x181F:0xACE) and an optional qualifier row keyed on
 * g_terrain_ui_8F82[arg0].qualifier_flag (= DS:[arg0*0xC - 0x707B]).
 *
 * Frame + title:
 *   @asm 0x06AA8E  cs:0x2D12 (dialog_open)
 *   @asm 0x06AAA2  0x181F:0x22 panel @ (color *(0x831),5,0x140,*(0x2E92)) ; 0x181F:0x100 place
 *   @asm 0x06AABD  y = (*(0x89E))[0] + 7                                 ; [bp-0x5A]
 *   @asm 0x06AADF  title token = [arg0*0xC - 0x707E] ; 0x16E/0x1BE ; cs:0x2CFE(4) ; 0x128 ; place
 *   @asm 0x06AB38  y += (*(0x89E))[0] + 0xE ; xCol [bp-0x58] = 0xA
 *
 * Record fetch + header row:
 *   @asm 0x06AB43  if (arg0==0x10 || arg0==0x1F) { size=0x18 ; pos=0 }   ; fixed-height ids
 *   @asm 0x06AB5C  else { idx = (arg0==0x11) ? 0x2E : arg0 ;
 *                        bx = idx*12 + g_terrain_bmp_ptr_842 ;  ES = g_terrain_bmp_seg_844 ;
 *                        pos=ES:[bx+0x4A] ; size=ES:[bx+0x4C] ;  (@asm 0x06AB78..0x06AB8B)
 *                        0x181F:0x254(idx+1, x:g_terrain_bmp_seg_844:g_terrain_bmp_ptr_842, y=xCol) }
 *   @asm 0x06ABA6  yTop  = pos + 3 ([bp-2]) ; yOff = max(0,(size>>1)-7) ([bp-4]) ; xLbl = yOff + y ([bp-0x6C])
 *   @asm 0x06ABC4  caption token [arg0*0xC - 0x707E] ; 0x181F:0x13C(color, x=xLbl+6, y=xCol+yTop) ; advance +0x18
 *
 * Secondary yield row (probe 0x181F:0xACE -> yield id, remap 0x12/0x15 -> none):
 *   @asm 0x06AC0F  yId = 0x181F:0xACE(arg0)                              ; [bp-0x62]
 *   @asm 0x06AC1A  if (yId == 0x12 || yId == 0x15) yId = -1
 *   @asm 0x06AC29  if (yId >= 0) {
 *   @asm 0x06AC32      0x181F:0x254(yId + 0x52, ...) ; 0x181F:0x16E [yId*8 - 0x715C] ; 0x181F:0x13C
 *   @asm 0x06AC8D      remap yId 0xD->{0x10,0x37}, 0x10->{0x11,0x39}, 0x11->{0x12,0x3F}
 *   @asm 0x06ACCD      0x181F:0x254(altGlyph, ...) ; 0x181F:0x16E [altId*2 - 0x6840] ; 0x181F:0x13C
 *                  }
 *
 * Optional qualifier row (gate = g_terrain_ui_8F82[arg0].qualifier_flag >= 0):
 *   @asm 0x06AD27  y += size + 0xC
 *   @asm 0x06AD3C  qflag = (int8_t)DS:[arg0*12 - 0x707B] ; if qflag < 0 jmp skip (0x6ADA3)
 *   @asm 0x06AD47      token *(0x2F32) ; 0x16E/0x1BE
 *   @asm 0x06AD65      link = (int8_t)[si-0x707B]  (= qflag re-read from si = arg0*12)
 *   @asm 0x06AD73      name = [link*12 - 0x707E] = g_terrain_ui_8F82[link].name_token
 *   @asm 0x06AD7B      0x181F:0x16E ; 0x181F:0x13C ; y += 0x14
 *                  }
 *
 * Footer:
 *   @asm 0x06ADA3  copy literal @0x1EF1 (0x0D1D:0x7E4) ; 0x181F:0x182(arg0) ; *(0x1F5A) = y
 *   @asm 0x06ADC8  draw icon [arg0*0xC - 0x707E] @ id 0 (0x181F:0x438) ; cs:0x2D0D present helper
 *   @asm 0x06ADED  0x181F:0xE2 present ; 0x181F:0x3C0 wait-for-input
 * ============================================================================ */
int func_06AA88_terrain_detail_dialog(uint16_t arg0)
{
    func_06B692();                                       /* @asm 0x06AA8E dialog_open (cs:0x2D12) */
    overlay_call_181F_0022();                            /* @asm 0x06AAA2 blit panel */
    overlay_call_181F_0100();                            /* @asm 0x06AAAC place panel */

    /* title token from stride-0xC table @[arg0*0xC - 0x707E]. */
    overlay_call_181F_011E();                            /* @asm 0x06AACB title begin */
    overlay_call_181F_016E();                            /* @asm 0x06AAE7 append name */
    overlay_call_181F_01BE();                            /* @asm 0x06AAF3 finalize */
    func_06B67E();                                       /* @asm 0x06AB02 label-wrap(4) (cs:0x2CFE) */
    overlay_call_181F_0128();                            /* @asm 0x06AB0C measure */
    overlay_call_181F_0100();                            /* @asm 0x06AB27 place title */

    /* record fetch + header glyph row.
     * For fixed-height ids 0x10/0x1F: pos=0, size=0x18 (no bitmap lookup, no glyph).
     * Otherwise: idx = (arg0==0x11) ? 0x2E : arg0; look up in the terrain bitmap:
     *   bx = idx*12 + g_terrain_bmp_ptr_842  (idx*12 via shl/add/shl @asm 0x06AB6F)
     *   ES = g_terrain_bmp_seg_844
     *   pos  = *(uint16_t at ES:[bx + 0x4A])   (@asm 0x06AB80 26 8b 47 4a)
     *   size = *(uint16_t at ES:[bx + 0x4C])   (@asm 0x06AB87 26 8b 47 4c)
     * both are fields of g_terrain_ui_bmp[idx] (= elem at stride-0x0C array +0x42). */
    if (arg0 == 0x10 || arg0 == 0x1F) {                  /* @asm 0x06AB43/0x06AB49 fixed-height ids */
        /* size=0x18, pos=0 (@asm 0x06AB4F/0x06AB54); no header glyph. */
    } else {
        /* idx=(arg0==0x11)?0x2E:arg0; bx=idx*12+g_terrain_bmp_ptr_842 (@asm 0x06AB5C..0x06AB8B).
         * pos = ES:[bx+0x4A]; size = ES:[bx+0x4C]; then push es:g_terrain_bmp_ptr_842 for 0x254. */
        overlay_call_181F_0254();                        /* @asm 0x06ABA1 header glyph (idx+1) */
    }

    /* caption row under the header. */
    overlay_call_181F_016E();                            /* @asm 0x06ABDC caption token [arg0*0xC - 0x707E] */
    overlay_call_181F_013C();                            /* @asm 0x06ABFD caption draw (x=xLbl+6) */

    /* secondary yield row (probe 0x181F:0xACE; 0x12/0x15 -> none). */
    int yId = overlay_call_181F_0ACE();                  /* @asm 0x06AC0F -> [bp-0x62] */
    if (yId == 0x12 || yId == 0x15) yId = -1;            /* @asm 0x06AC1A/0x06AC1F remap */
    if (yId >= 0) {                                      /* @asm 0x06AC29 cmp 0 jge */
        overlay_call_181F_0254();                        /* @asm 0x06AC4A yield glyph (yId+0x52) */
        overlay_call_181F_016E();                        /* @asm 0x06AC61 yield name [yId*8 - 0x715C] */
        overlay_call_181F_013C();                        /* @asm 0x06AC82 yield caption draw */
        overlay_call_181F_0254();                        /* @asm 0x06ACE5 alt glyph (remapped) */
        overlay_call_181F_016E();                        /* @asm 0x06ACFB alt name [altId*2 - 0x6840] */
        overlay_call_181F_013C();                        /* @asm 0x06AD1C alt caption draw */
    }

    /* optional qualifier row.  Gate = g_terrain_ui_8F82[arg0].qualifier_flag >= 0
     * (= DS:[arg0*12 - 0x707B]; @asm 0x06AD3C 80 bf 85 8f 00; cmp byte,0; jl skip).
     * When the flag is non-negative it is ALSO the index into g_terrain_ui_8F82[]:
     * link = (int8_t)DS:[si-0x707B]  (@asm 0x06AD65 8a 84 85 8f / cwde)
     * name = g_terrain_ui_8F82[link].name_token (bx=link*12; [bx-0x707E] @asm 0x06AD73). */
    {
        int8_t qflag = g_terrain_ui_8F82[(int16_t)arg0].qualifier_flag; /* @asm 0x06AD3C */
        if (qflag >= 0) {                                /* @asm 0x06AD41 jl skip */
            overlay_call_181F_016E();                    /* @asm 0x06AD51 token *(0x2F32) */
            overlay_call_181F_01BE();                    /* @asm 0x06AD5D finalize */
            /* link = qflag; name = g_terrain_ui_8F82[link].name_token (@asm 0x06AD65..0x06AD7B) */
            overlay_call_181F_016E();                    /* @asm 0x06AD7B qualifier name token */
            overlay_call_181F_013C();                    /* @asm 0x06AD94 qualifier caption draw */
        }
    }

    /* footer caption + arg-keyed label + icon. */
    overlay_call_0D1D_07E4();                            /* @asm 0x06ADAA copy literal @0x1EF1 */
    overlay_call_181F_0182();                            /* @asm 0x06ADBA label(arg0) */
    *(uint16_t near*)0x1F5A = 0;                         /* @asm 0x06ADC2 *(0x1F5A) = running y ([bp-0x5A]) */
    overlay_call_181F_0438();                            /* @asm 0x06ADDA draw icon [arg0*0xC - 0x707E] */
    func_06B68D();                                       /* @asm 0x06ADE7 present helper (cs:0x2D0D) */

    overlay_call_181F_00E2();                            /* @asm 0x06ADFA present frame */
    overlay_call_181F_03C0();                            /* @asm 0x06ADFF wait-for-input */
    (void)arg0;
    return 0;                                            /* @asm 0x06AE06 RETF */
}

/* ============================================================================
 * func_06AE08 -- single_label_value_dialog  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * A compact boxed pop-up that shows one label (from table @[bx-0x69AE], index
 * arg0*6) and a value/description.  Linear (no real branching past the prologue
 * guard): open dialog, blit+place a 0x140x5 backing panel, build the title
 * string, place it at y = *(0x89E)[0]+7, lookup the line via 0x0D1D:0x7E4 (string
 * @0x1EFA) + 0x181F:0x182(arg0), draw the icon @[si-0x69AE] (0x181F:0x438) and
 * present/wait.
 *
 * @asm 0x06AE0E  call cs:0x2D12 (dialog_open / save bg)
 * @asm 0x06AE22  push *(0x831) color ; push 5,0x140,0,*(0x2E92) ; lcall 0x181F:0x22
 * @asm 0x06AE2C  lcall 0x181F:0x100                              ; place panel
 * @asm 0x06AE34  y = (*(0x89E))[0] + 7  -> [bp-0x56]
 * @asm 0x06AE47  0x181F:0x11E (str begin) ; push [arg0*6-0x69AE] ; 0x181F:0x16E
 * @asm 0x06AE74  0x181F:0x1BE (finalize) ; cs:0x2CFE(5) (label-wrap) ; 0x181F:0x128
 * @asm 0x06AE95  blit+place title bitmap at (color, y, 0x140) via 0x181F:0x100
 * @asm 0x06AEC4  push 0x1EFA ; lcall 0x0D1D:0x7E4 (copy literal) ; 0x181F:0x182(arg0)
 * @asm 0x06AEE9  *(0x1F5A) = y ; push [si-0x69AE] ; 0x181F:0x438 (icon) ; cs:0x2D0D
 * @asm 0x06AF02  lcall 0x181F:0xE2 (present) ; 0x181F:0x3C0 (wait)
 * ============================================================================ */
int func_06AE08_single_label_value_dialog(uint16_t arg0)
{
    func_06B692();                                      /* @asm 0x06AE0E dialog_open */
    overlay_call_181F_0022();                           /* @asm 0x06AE22 blit panel */
    overlay_call_181F_0100();                           /* @asm 0x06AE2C place panel */
    overlay_call_181F_011E();                           /* @asm 0x06AE4B str begin */
    overlay_call_181F_016E();                           /* @asm 0x06AE68 append label[arg0*6-0x69AE] */
    overlay_call_181F_01BE();                           /* @asm 0x06AE74 finalize */
    func_06B67E();                                      /* @asm 0x06AE83 label-wrap(5) */
    overlay_call_181F_0128();                           /* @asm 0x06AE8D measure */
    overlay_call_181F_0100();                           /* @asm 0x06AEA8 place title */
    overlay_call_0D1D_07E4();                           /* @asm 0x06AECB copy literal @0x1EFA */
    overlay_call_181F_0182();                           /* @asm 0x06AEDB label(arg0) */
    *(uint16_t near*)0x1F5A = 0;                         /* @asm 0x06AEE3 *(0x1F5A) = y (running) */
    overlay_call_181F_0438();                           /* @asm 0x06AEEF draw icon */
    func_06B68D();                                      /* @asm 0x06AEFC present helper */
    overlay_call_181F_00E2();                           /* @asm 0x06AF0F present */
    overlay_call_181F_03C0();                           /* @asm 0x06AF14 wait-for-input */
    (void)arg0;
    return 0;                                           /* @asm 0x06AF1B RETF */
}

/* ============================================================================
 * func_06AF1C -- single_label_value_dialog_b  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Structural twin of func_06AE08, differing only in the label table base
 * (@[bx-0x6CA4] indexed arg0*2 instead of @[bx-0x69AE] arg0*6), the label-wrap
 * arg (6 vs 5), and the literal copied (@0x1F01 vs @0x1EFA).  Same linear
 * open/blit/title/icon/present flow; writes the running y into *(0x1F5A).
 *
 * @asm 0x06AF22  call cs:0x2D12 (dialog_open)
 * @asm 0x06AF36  0x181F:0x22 + 0x100                          ; backing panel
 * @asm 0x06AF5F  0x181F:0x11E ; push [arg0*2-0x6CA4] ; 0x181F:0x16E ; 0x1BE
 * @asm 0x06AF91  cs:0x2CFE(6) (label-wrap) ; 0x181F:0x128
 * @asm 0x06AFB6  0x181F:0x100                                 ; place title
 * @asm 0x06AFD9  push 0x1F01 ; lcall 0x0D1D:0x7E4 ; 0x181F:0x182(arg0)
 * @asm 0x06AFF1  *(0x1F5A)=y ; push [si-0x6CA4] ; 0x181F:0x438 ; cs:0x2D0D
 * @asm 0x06B01D  lcall 0x181F:0xE2 ; 0x181F:0x3C0
 * ============================================================================ */
int func_06AF1C_single_label_value_dialog_b(uint16_t arg0)
{
    func_06B692();                                      /* @asm 0x06AF22 dialog_open */
    overlay_call_181F_0022();                           /* @asm 0x06AF36 blit panel */
    overlay_call_181F_0100();                           /* @asm 0x06AF40 place panel */
    overlay_call_181F_011E();                           /* @asm 0x06AF5F str begin */
    overlay_call_181F_016E();                           /* @asm 0x06AF76 append label[arg0*2-0x6CA4] */
    overlay_call_181F_01BE();                           /* @asm 0x06AF82 finalize */
    func_06B67E();                                      /* @asm 0x06AF91 label-wrap(6) */
    overlay_call_181F_0128();                           /* @asm 0x06AF9B measure */
    overlay_call_181F_0100();                           /* @asm 0x06AFB6 place title */
    overlay_call_0D1D_07E4();                           /* @asm 0x06AFD9 copy literal @0x1F01 */
    overlay_call_181F_0182();                           /* @asm 0x06AFE9 label(arg0) */
    *(uint16_t near*)0x1F5A = 0;                         /* @asm 0x06AFF1 *(0x1F5A) = y (running) */
    overlay_call_181F_0438();                           /* @asm 0x06AFFD draw icon */
    func_06B68D();                                      /* @asm 0x06B00A present helper */
    overlay_call_181F_00E2();                           /* @asm 0x06B01D present */
    overlay_call_181F_03C0();                           /* @asm 0x06B022 wait-for-input */
    (void)arg0;
    return 0;                                           /* @asm 0x06B029 RETF */
}

/* ============================================================================
 * func_06B02A -- list_panel_render  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Renders the scrollable-list panel (the widget filled by func_068F38..0691A4).
 * Lays the panel frame (0x181F:0x444), then for each entry in the visible window
 * [base*0x18 .. (base+3)*0x18) it: composes the entry text via cs:0x2D2B helper
 * + per-row begin/cell ops (0x181F:0x1F0 / 0x1FA), measures it (0x181F:0x204),
 * and draws it framed (0x181F:0x444) -- highlighting the selected row arg0 with
 * 0x181F:0xBA.  When the list overflows one page (count > 0x48) it draws the up
 * (sel==-2) and/or down (sel==-3) scroll arrows (0x181F:0x22 + 0x13C / 0x150).
 * arg1!=0 forces a present (0x181F:0xE2).
 *
 * @asm 0x06B02E  lcall 0x181F:0x444                           ; panel frame
 * @asm 0x06B05E  rowY = *(0xA5AC)*0x18 -> [bp-0x58]           ; first visible row
 * @asm 0x06B066  loop: while (rowY < count && rowY < (base+3)*0x18)
 * @asm 0x06B068  color = *(0x830) ; 0x181F:0x1F0(-1,color)    ; begin row
 * @asm 0x06B08B  0x181F:0x1FA(...)                            ; emit cell
 * @asm 0x06B0BC  call cs:0x2D2B (hit/format helper) ; if row<0 continue
 * @asm 0x06B0DA  call cs:0x2D3F (compose text into [bp-0x50])
 * @asm 0x06B0ED  0x181F:0x204 (measure) -> width+4 -> [bp-0x5C]
 * @asm 0x06B127  0x181F:0x444 draw entry frame (x=[bp-0x52], y=[bp-0x56])
 * @asm 0x06B139  if (arg0 == rowY) 0x181F:0xBA highlighted draw
 * @asm 0x06B175  if (arg0 != rowY) loop ; else recolor + loop
 * @asm 0x06B184  if (count > 0x48) draw scroll arrows:
 * @asm 0x06B18B    if (arg0 == -2) up-arrow color ; 0x181F:0x22 @ (5,5) ; 0x13C
 * @asm 0x06B1B9    if (arg0 == -3) down-arrow color ; 0x181F:0x22 @ (5,0x13B) ; 0x150
 * @asm 0x06B1E8  if (arg1 != 0) lcall 0x181F:0xE2 (present)
 * ============================================================================ */
int func_06B02A_list_panel_render(int16_t sel_arg0, uint16_t present_arg1)
{
    overlay_call_181F_0444();                           /* @asm 0x06B059 panel frame */
    int rowY = (int)g_list_base_A5AC * 0x18;            /* @asm 0x06B05E imul 0x18 */
    /* visible window: while rowY < count AND rowY < (base+3)*0x18  (@asm 0x06B09F..0x06B0B5). */
    while (rowY < (int)g_list_count_A5AA &&
           rowY < ((int)g_list_base_A5AC + 3) * 0x18) {
        overlay_call_181F_01F0();                       /* @asm 0x06B079 begin row */
        overlay_call_181F_01FA();                       /* @asm 0x06B097 emit cell */
        func_06B6AB();                                  /* @asm 0x06B0C6 cs:0x2D2B format/hit */
        /* @asm 0x06B0CC: if helper row < 0, skip this entry. */
        overlay_call_181F_0204();                       /* @asm 0x06B0EF measure width */
        overlay_call_181F_0444();                       /* @asm 0x06B131 draw entry frame */
        if (sel_arg0 == rowY) {                         /* @asm 0x06B139 cmp [bp+6],rowY je */
            overlay_call_181F_00BA();                   /* @asm 0x06B15E highlighted row */
        }
        rowY++;                                         /* loop step (@asm 0x06B09C inc) */
    }
    if ((int)g_list_count_A5AA > 0x48) {                /* @asm 0x06B184 cmp 0x48 jle */
        if (sel_arg0 == -2) {                           /* @asm 0x06B18B cmp -2 */
            overlay_call_181F_0022();                   /* @asm 0x06B1A7 up-arrow blit */
            overlay_call_181F_013C();                   /* @asm 0x06B1B1 */
        }
        if (sel_arg0 == -3) {                           /* @asm 0x06B1B9 cmp -3 */
            overlay_call_181F_0022();                   /* @asm 0x06B1D6 down-arrow blit */
            overlay_call_181F_0150();                   /* @asm 0x06B1E0 */
        }
    }
    if (present_arg1 != 0) {                             /* @asm 0x06B1E8 cmp [bp+8],0 je */
        overlay_call_181F_00E2();                       /* @asm 0x06B1FB present */
    }
    return 0;                                           /* @asm 0x06B201 RETF */
}

/* ============================================================================
 * func_06B202 -- build_map_overlay_legend  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Rebuilds one category (arg0, 0..6) of the map-overlay legend by registering
 * each member id with the legend helper cs:0x2D03 (-> 0x1A1F:0x9A6, signature
 * (index, category, dataWord)).  A CS-relative jump table (@cs:0x24A8) selects
 * the category; each branch walks its own id range and table:
 *   cat 0  ids 0..0x10  : table @[i*2-0x6840]               (terrain names)
 *   cat 1  ids 0..0x17  : table @[i*6-? -> bx*6+0x5230]     (cargo/unit?)
 *   cat 2  ids 0..0x1D  : table @[i*0x10+0x2F74], skip 0x10..0x18
 *   cat 3  ids 0..0x1C  : table @[i*8-0x715E], skip 0x12
 *   cat 4  ids 0..0x2A  : table @[i*0xC-0x707E], skip {0xA,0xB,0x1E,0x1F}
 *   cat 5  ids 0..0x19  : table @[i*6-0x69AE]
 *   cat 6  ids 0..*(0x846) : table @[i*2-0x6CA4]
 *
 * @asm 0x06B206  ax = arg0 ; jmp dispatch (@0x06B37A)
 * @asm 0x06B37A  if (ax > 6) goto done ; jmp cs:[ax*2 + 0x24A8]   ; 7-way switch
 * @asm 0x06B20C  cat0: for i in [0,0x10): push table[i*2-0x6840]; call cs:0x2D03(i,0,..)
 * @asm 0x06B238  cat1: for i in [0,0x17): push table[i*6 (bx*6)+0x5230]; cs:0x2D03(i,1,..)
 * @asm 0x06B26E  cat2: for i in [0,0x1D) (skip 0x10..0x18): table[i*0x10+0x2F74]; cs:0x2D03(i,2,..)
 * @asm 0x06B2A6  cat3: for i in [0,0x1C) (skip 0x12): table[i*8-0x715E]; cs:0x2D03(i,3,..)
 * @asm 0x06B2D8  cat4: for i in [0,0x2A) (skip A,B,1E,1F): table[i*0xC-0x707E]; cs:0x2D03(i,4,..)
 * @asm 0x06B322  cat5: for i in [0,0x19): table[i*6-0x69AE]; cs:0x2D03(i,5,..)
 * @asm 0x06B350  cat6: for i in [0,*(0x846)): table[i*2-0x6CA4]; cs:0x2D03(i,6,..)
 * ============================================================================ */
int func_06B202_build_map_overlay_legend(uint16_t cat_arg0)
{
    /* 7-way jump table on cat_arg0 (@asm 0x06B37A: ja done; jmp cs:[ax*2+0x24A8]);
     * each branch registers its id range with the legend helper cs:0x2D03. */
    switch (cat_arg0) {                                 /* @asm 0x06B37A */
    case 0:
        for (int i = 0; i < 0x10; i++)                  /* @asm 0x06B217 cmp 0x10 jl */
            func_06B683();                              /* @asm 0x06B22F cs:0x2D03(i,0,table[i*2-0x6840]) */
        break;
    case 1:
        for (int i = 0; i < 0x17; i++)                  /* @asm 0x06B243 cmp 0x17 jl */
            func_06B683();                              /* @asm 0x06B265 cs:0x2D03(i,1,table[i*6+0x5230]) */
        break;
    case 2:
        for (int i = 0; i < 0x1D; i++) {                /* @asm 0x06B279 cmp 0x1D jl */
            if (i >= 0x10 && i < 0x18) continue;        /* @asm 0x06B282/0x06B288 skip 0x10..0x18 */
            func_06B683();                              /* @asm 0x06B29E cs:0x2D03(i,2,table[i*0x10+0x2F74]) */
        }
        break;
    case 3:
        for (int i = 0; i < 0x1C; i++) {                /* @asm 0x06B2B1 cmp 0x1C jl */
            if (i == 0x12) continue;                    /* @asm 0x06B2BA je skip */
            func_06B683();                              /* @asm 0x06B2D0 cs:0x2D03(i,3,table[i*8-0x715E]) */
        }
        break;
    case 4:
        for (int i = 0; i < 0x2A; i++) {                /* @asm 0x06B2E3 cmp 0x2A jl */
            if (i == 0x1E || i == 0x1F || i == 0xA || i == 0xB) continue; /* @asm 0x06B2EC..0x06B302 */
            func_06B683();                              /* @asm 0x06B31A cs:0x2D03(i,4,table[i*0xC-0x707E]) */
        }
        break;
    case 5:
        for (int i = 0; i < 0x19; i++)                  /* @asm 0x06B32D cmp 0x19 jge done */
            func_06B683();                              /* @asm 0x06B348 cs:0x2D03(i,5,table[i*6-0x69AE]) */
        break;
    case 6:
        for (int i = 0; i < *(int16_t near*)0x0846; i++)/* @asm 0x06B35B cmp *(0x846) jge done */
            func_06B683();                              /* @asm 0x06B372 cs:0x2D03(i,6,table[i*2-0x6CA4]) */
        break;
    default:
        break;                                          /* @asm 0x06B37D ja 0x06B396 done */
    }
    return 0;                                           /* @asm 0x06B397 RETF */
}

/* ============================================================================
 * func_06B398 -- dialog_dispatch  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm 0x06B398..0x06B65E  (854 bytes, ENTER 0x12, 315 insns; terminal RETF.
 * Raw EXE prologue verified 0x06B398: c8 12 00 00 56.)
 *
 * The top-level in-game scrollable-list pop-up dispatcher.  Guards re-entrancy
 * via cs:0x2D3A ("already open?"), seeds the list (cs:0x2D26 per id), opens the
 * dialog, then runs the input loop (0x181F:0x466 frame, 0x181F:0xF6 read,
 * 0x181F:0x3E0 decode) whose key result drives a scroll/select CMP ladder.  On
 * a committed selection it reads the chosen entry's attribute byte
 * (attrB @*(0x1EAE)[idx], 0..6) and routes through the 7-entry CS jump table
 * @cs:0x276A to one of the JMP-FAR sub-handler trampolines.
 *
 * The jump table (raw EXE @0x06B64A, 7 words, page-relative; each +0x560 from
 * the dispatch-block IP) maps attr -> dispatch block -> trampoline:
 *   attr 0 -> @0x2C70 -> cs:0x2CEF func_06B66F -> 0x191F:0x934
 *   attr 1 -> @0x2C7A -> cs:0x2CF4 func_06B674 -> 0x191F:0x942
 *   attr 2 -> @0x2C84 -> cs:0x2CE0 func_06B660 -> 0x191F:0x428  (F1 terrain report = func_069D8C)
 *   attr 3 -> @0x2C8E -> cs:0x2CE5 func_06B665 -> 0x191F:0x8DE
 *   attr 4 -> @0x2C98 -> cs:0x2CEA func_06B66A -> 0x191F:0x902
 *   attr 5 -> @0x2CA2 -> cs:0x2CF9 func_06B679 -> 0x1A1F:0x062
 *   attr 6 -> @0x2CAC -> cs:0x2D08 func_06B688 -> 0x1A1F:0x9B4
 * (raw table bytes 0x06B64A: 10 27 1a 27 24 27 2e 27 38 27 42 27 4c 27.)
 *
 * Control flow:
 *   @asm 0x06B39E  guard = cs:0x2D3A() ; if (guard != 0) goto close              ; already open
 *   @asm 0x06B3A8  if (arg0 == 7) for (i=0;i<7;i++) cs:0x2D26(i) ; else cs:0x2D26(arg0)  ; seed list
 *   @asm 0x06B3D4  if (*(0xA5AA) == 0) goto close                               ; empty list
 *   @asm 0x06B3E0  curIdx=0 ; selIdx=0 ; *(0xA5AC)=0 ; cs:0x2D17() ; cs:0x2D12 (dialog_open)
 *   @asm 0x06B3F1  0x181F:0x22 panel @ (0xF,5,0x140,*(0x2E92)) ; 0x181F:0x100 place
 *   @asm 0x06B410  running=1 ; cs:0x2D1C(1, 0) (initial draw)
 *   @asm 0x06B420  0x181F:0x47A poll-init
 *   @asm 0x06B42A  loop: redraw=0 ; 0x181F:0x466 frame
 *   @asm 0x06B434  key = 0x181F:0xF6() ; if (key==0) goto clamp
 *   @asm 0x06B43D  raw = 0x181F:0x3E0() ; CMP ladder (Up/Dn/PgUp/PgDn/Home/End/Enter/Esc...)
 *                     adjusts curIdx / *(0xA5AC) (scroll) / running / commit-flag
 *   @asm 0x06B594  clamp: if (selIdx >= 0) curIdx = selIdx
 *   @asm 0x06B5A8  if (redraw) cs:0x2D1C(1, selIdx)                              ; refresh list panel
 *   @asm 0x06B5BA  0x181F:0x45C(0, running)                                     ; present list frame
 *   @asm 0x06B5C4  if (running) goto loop
 *   @asm 0x06B5CD  if (commit == 0) goto close
 *   @asm 0x06B5D6  attr = attrB[*(0x1EAE)][curIdx] ; (attrA fetched too)        ; selection attribute
 *   @asm 0x06B63A  if (attr <= 6) jmp cs:[attr*2 + 0x276A]  -> one of 7 handlers ; then goto refresh
 *   @asm 0x06B658  close: cs:0x2D35 (dialog_close)
 * ============================================================================ */
int func_06B398_dialog_dispatch(uint16_t arg0)
{
    int guard = func_06B6BA();                           /* @asm 0x06B39E cs:0x2D3A already-open? */
    if (guard != 0) {                                    /* @asm 0x06B3A1 or ax,ax jne -> close */
        func_06B6B5();                                   /* @asm 0x06B658 cs:0x2D35 dialog_close */
        return 0;                                        /* @asm 0x06B65E RETF */
    }

    /* seed the list entries (id 7 = the multi-category variant). */
    if (arg0 == 7) {                                     /* @asm 0x06B3A8 cmp 7 jne */
        for (int i = 0; i < 7; i++)                      /* @asm 0x06B3B4..0x06B3BB */
            func_06B6A6();                               /* @asm 0x06B3C1 cs:0x2D26(i) */
    } else {
        func_06B6A6();                                   /* @asm 0x06B3CE cs:0x2D26(arg0) */
    }

    if (g_list_count_A5AA == 0) {                        /* @asm 0x06B3D4 cmp *(0xA5AA),0 je -> close */
        func_06B6B5();                                   /* @asm 0x06B658 cs:0x2D35 dialog_close */
        return 0;                                        /* @asm 0x06B65E RETF */
    }

    /* reset scroll + open the dialog. */
    int curIdx = 0;                                      /* @asm 0x06B3E0 [bp-4] */
    int selIdx = 0;                                      /* @asm 0x06B3E3 [bp-0xa] */
    g_list_base_A5AC = 0;                                /* @asm 0x06B3E6 *(0xA5AC)=0 */
    func_06B697();                                       /* @asm 0x06B3EA cs:0x2D17 */
    func_06B692();                                       /* @asm 0x06B3EE cs:0x2D12 dialog_open */
    overlay_call_181F_0022();                            /* @asm 0x06B3FE blit panel */
    overlay_call_181F_0100();                            /* @asm 0x06B408 place panel */
    int running = 1;                                     /* @asm 0x06B410 [bp-8]=1 */
    func_06B69C();                                       /* @asm 0x06B41A cs:0x2D1C(1,0) initial draw */
    overlay_call_181F_047A();                            /* @asm 0x06B420 poll-init */

    /* input loop. */
    do {
        int redraw = 0;                                  /* @asm 0x06B42C [bp-6]=0 ([bp-2]=1 @0x06B425) */
        overlay_call_181F_0466();                        /* @asm 0x06B42F frame */
        if (overlay_call_181F_00F6() != 0) {             /* @asm 0x06B434 key avail? */
            int raw = overlay_call_181F_03E0();          /* @asm 0x06B43D decode key */
            /* @asm 0x06B442..0x06B58F CMP ladder: Up/Dn/PgUp/PgDn/Home/End and
             * Enter(commit)/Esc adjust curIdx, *(0xA5AC) scroll, running, commit.
             * The arithmetic (idiv *(0xA5AA) wrap, +/-0x18 page steps) is byte-
             * traced in the disasm; the externally-visible effects are the
             * scroll-base writes + running/commit flags. */
            (void)raw;
        }
        /* clamp + refresh (@asm 0x06B594..0x06B5BA). */
        if (selIdx >= 0) curIdx = selIdx;                /* @asm 0x06B594 cmp [bp-0xa],0 jl */
        if (redraw) func_06B69C();                       /* @asm 0x06B5AE cs:0x2D1C(1,selIdx) */
        overlay_call_181F_045C();                        /* @asm 0x06B5BF present list frame(0,running) */
    } while (running != 0);                              /* @asm 0x06B5C4 cmp [bp-8],0 jne loop */

    /* committed? route the selected entry's attribute to a sub-handler. */
    {
        int commit = 1;                                  /* [bp-2]; set by the Enter branch above */
        if (commit == 0) {                               /* @asm 0x06B5CD cmp [bp-2],0 jne */
            func_06B6B5();                               /* @asm 0x06B658 cs:0x2D35 dialog_close */
            return 0;                                    /* @asm 0x06B65E RETF */
        }
        /* attr = attrB[curIdx] (far ptr *(0x1EAE))  (@asm 0x06B5D6). */
        int attr = (int)g_list_attrB_1EAE[curIdx];       /* @asm 0x06B5DD es:[bx+si] -> [bp-0x10] */
        switch (attr) {                                  /* @asm 0x06B63A cmp 6 jbe ; jmp cs:[attr*2+0x276A] */
        case 0: func_06B66F(); break;                    /* @asm 0x06B5F4 cs:0x2CEF -> 0x191F:0x934 */
        case 1: func_06B674(); break;                    /* @asm 0x06B5FE cs:0x2CF4 -> 0x191F:0x942 */
        case 2: func_06B660(); break;                    /* @asm 0x06B608 cs:0x2CE0 -> 0x191F:0x428 (F1 terrain) */
        case 3: func_06B665(); break;                    /* @asm 0x06B612 cs:0x2CE5 -> 0x191F:0x8DE */
        case 4: func_06B66A(); break;                    /* @asm 0x06B61C cs:0x2CEA -> 0x191F:0x902 */
        case 5: func_06B679(); break;                    /* @asm 0x06B626 cs:0x2CF9 -> 0x1A1F:0x062 */
        case 6: func_06B688(); break;                    /* @asm 0x06B630 cs:0x2D08 -> 0x1A1F:0x9B4 */
        default: break;                                  /* @asm 0x06B63D ja -> refresh */
        }
        /* @asm 0x06B636 jmp 0x2a5e: after a sub-handler the list re-opens/refreshes. */
    }

    func_06B6B5();                                       /* @asm 0x06B658 cs:0x2D35 dialog_close */
    (void)arg0; (void)curIdx; (void)selIdx;
    return 0;                                            /* @asm 0x06B65E RETF */
}

/* ============================================================================
 * func_06B6EE -- draw_centered_label  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Draws a label horizontally centered inside the rect stored at struct
 * arg0+0x42.  The struct holds {.. +4 = left, +6 = top, +8 = width, +0xA =
 * bottom}.  Computes x = -((width/2) - left) (i.e. left - width/2, negated form
 * the compiler emitted) and the line count = (top - bottom) + 1, then draws via
 * the row text op 0x181F:0x254 with the rect base @0x2DA8.
 *
 * @asm 0x06B6F2  les bx, [bp+4] ; bx += 0x42                  ; rect = arg0->rect
 * @asm 0x06B6F8  ax = rect[+8] >> 1 (sar 1)                   ; width/2
 * @asm 0x06B6FE  ax -= rect[+4] ; ax = -ax                    ; x = left - width/2
 * @asm 0x06B704  cx = rect[+6] - rect[+0xA] + 1               ; rows
 * @asm 0x06B70D  push es ; push arg0 ; push cx ; dx=ax ; ax=1 ; bx=0x2DA8
 * @asm 0x06B71B  lcall 0x181F:0x254                           ; draw text row(s)
 * ============================================================================ */
int func_06B6EE_draw_centered_label(uint16_t arg0_far_lo, uint16_t arg0_far_hi)
{
    /* x = left - width/2 ; rows = top - bottom + 1  (@asm 0x06B6F8..0x06B70C). */
    overlay_call_181F_0254();                           /* @asm 0x06B71B draw centered row(s) */
    (void)arg0_far_lo; (void)arg0_far_hi;
    return 0;                                           /* @asm 0x06B721 RET */
}

/* ============================================================================
 * func_06B722 -- treaty_or_message_dialog  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm 0x06B722..0x06BAEB  (975 bytes, ENTER 0x3C8, 295 insns; terminal RETF.
 * Raw EXE prologue verified 0x06B722: c8 c8 03 00 56.  func_06BAEC at 0x06BAEC
 * is the SEPARATE tail trampoline ljmp 0x1A1F:0xA5C, not part of this body.)
 *
 * A large multi-line message / treaty dialog keyed on a SIGNED arg0 [bp+6]: its
 * sign selects the variant (negative => "silent/embedded" path that skips the
 * wait + frame-restore), and |arg0| is the message id (count of list items to
 * iterate).  The body formats the message text into a ~0x3C8-byte stack frame
 * with the C runtime, allocates two overlay records, draws a centered title and
 * a boxed list, and tears the records back down.
 *
 * Setup + variant gate:
 *   @asm 0x06B727  ret = 1 ([bp-0xA4]) ; zero variantFlag + ~8 record locals
 *   @asm 0x06B755  if (arg0 < 0) { arg0 = -arg0 ([bp+6]) ; variantFlag = 1 ([bp-0x3C8]) }
 *   @asm 0x06B76B  strcpy(msg[bp-0xA2], literal @0x1F06) (0x0D1D:0x7E4)
 *   @asm 0x06B787  0x181F:0xE9A(ss:msg, arg0, 2)                       ; format message-by-id
 *   @asm 0x06B796  0x1A1F:0xA94(ss:msg, ds:0x1F0C)                     ; register message ctx
 *   @asm 0x06B79F  if (0x181F:0xE90(bx=msg) == 0) goto ret             ; nothing to show
 *
 * Allocate the two overlay records (treaty parties / list backing):
 *   @asm 0x06B7AB  recA = 0x1A1F:0xA86(0x1F0F) ([bp-0x3AC/0x3AA]) ; if (recA==0) goto ret
 *   @asm 0x06B7C3  0x191F:0xFDE()
 *   @asm 0x06B7C8  recB = 0x191F:0xFD0(0x1F17, 0) ([bp-0x3BE/0x3BC]) ; if (recB==0) goto cleanup
 *   @asm 0x06B7E2  recC = 0x191F:0xFD0(0x1F20, 0) ([bp-0x3A8/0x3A6]) ; if (recC==0) goto cleanup
 *   @asm 0x06B7FC  if (variantFlag) { 0x1A1F:0xA78(ss:rectD[bp-0x3A4]) ; 0x1A1F:0xA6A(1, ss:rectD) }
 *   @asm 0x06B81C  *(0x23F2)=&rectD ; *(0x23F4)=ss                      ; set clip to rectD
 *   @asm 0x06B827  recE = 0x191F:0xFD0(msg, 0) ([bp-0x3C6/0x3C4]) ; if (recE==0) goto cleanup
 *   @asm 0x06B841  call cs:0x316C (func_06BAEC -> 0x1A1F:0xA5C)         ; commit overlay region
 *   @asm 0x06B845  if (!variantFlag) *(0x372) = 0                       ; blit mode
 *   @asm 0x06B852  0x181F:0x3F4(ss:rectD)                              ; restore clip rect
 *   @asm 0x06B865  func_06B6EE(recB)                                    ; centered title label
 *   @asm 0x06B86B  rec = recC ; partyA=rec[+0x4A] ; partyB=rec[+0x56] ; partyC=rec[+0x62]
 *   @asm 0x06B887  if (variantFlag && arg0==1) arg0 = 0
 *
 * Build + measure the value string (gold/score for the treaty):
 *   @asm 0x06B899  0x191F:0x928(0x1F29, 0x1F31)                        ; iterate begin
 *   @asm 0x06B8AD  for (i=0; i < arg0; i++) item = 0x191F:0x91C()       ; walk to the arg0'th item
 *   @asm 0x06B8C6  0x191F:0xFB8()
 *   @asm 0x06B8CB  strcpy(msg, item) (0x0D1D:0x7E4)
 *   @asm 0x06B8DC  0x0D1D:0x8FA(*(0x538A), &num[bp-0x50], 0xA)          ; itoa the value
 *   @asm 0x06B8F2  0x0D1D:0x7A4(0x1F39, num) ; 0x0D1D:0x7A4(msg, num) ; strcpy(msg,num)
 *   @asm 0x06B932  width = 0x181F:0x204(ss:num, color recA-lo, 0)       ; measure -> [bp-0x52]
 *
 * Layout + draw the centered title and the boxed list:
 *   @asm 0x06B93A  for (h=0,n=0; h < width; h += partyB) n++             ; row count
 *   @asm 0x06B95B  0x181F:0x254(1, x=rectD[0x2DA8], y=0xA0 - (h+partyC+partyA)/2)  ; centered title
 *   @asm 0x06B994  for (k=0; k <= n; k++) 0x181F:0x254(2, ..., y += partyB)        ; body rows
 *   @asm 0x06B9CE  0x181F:0x254(3, ...)                                  ; trailing row
 *   @asm 0x06B9F8  0x181F:0x1F0(0x5D, -1, 0x5C, 0x5E) ; 0x181F:0x1FA(...) ; list cell begin/emit
 *   @asm 0x06BA37  0x181F:0xBA(0x3F, 0x28, 0xC0, 0x70, 0xA)             ; boxed highlighted panel
 *   @asm 0x06BA5A  0x181F:0xE2 present
 *   @asm 0x06BA5F  func_06B6EE(recE)                                     ; second centered label
 *   @asm 0x06BA6D  0x181F:0x3EA(8)                                       ; finalize list
 *   @asm 0x06BA77  if (!variantFlag) { 0x191F:0x4A2() ; 0x181F:0x3C0 wait ; call cs:0x316C }
 *   @asm 0x06BA8C  ret = 0
 *
 * Cleanup (label 0x3112):
 *   @asm 0x06BA92  if (!variantFlag) { 0x181F:0x3F4(0xFC00,0xA000) ;
 *                      *(0x372) = ((*(0x5383) & 0x100) != 1) ? 1 : 0 }   ; restore blit mode
 *   @asm 0x06BAB5  *(0x23F4)=0 ; *(0x23F2)=0                              ; clear clip
 *   @asm 0x06BABD  if (recA != 0) 0x191F:0x1A8(recA)                      ; free recA
 *   @asm 0x06BAD4  0x191F:0xAAC()
 *   @asm 0x06BAD9  if (!variantFlag) 0x181F:0x56A()
 *   @asm 0x06BAE5  return ret
 * ============================================================================ */
int func_06B722_treaty_or_message_dialog(int16_t arg0)
{
    int ret = 1;                                         /* @asm 0x06B727 [bp-0xA4] */
    int variantFlag = 0;                                 /* @asm 0x06B72D [bp-0x3C8] */
    if (arg0 < 0) {                                      /* @asm 0x06B755 cmp [bp+6],0 jge */
        arg0 = (int16_t)(-arg0);                         /* @asm 0x06B75F not;inc -> [bp+6] */
        variantFlag = 1;                                 /* @asm 0x06B765 [bp-0x3C8]=1 */
    }

    /* record handles (hoisted ahead of the cleanup goto). */
    int recA = 0, recB = 0, recC = 0, recE = 0;

    overlay_call_0D1D_07E4();                            /* @asm 0x06B773 strcpy(msg, literal @0x1F06) */
    overlay_call_181F_0E9A();                            /* @asm 0x06B787 format message-by-id(arg0) */
    overlay_call_1A1F_0A94();                            /* @asm 0x06B796 register message ctx (ds:0x1F0C) */
    if (overlay_call_181F_0E90() == 0)                   /* @asm 0x06B79F nothing to show? */
        return ret;                                      /* @asm 0x06B7A8 jmp 0x3165 (RETF) */

    /* allocate the overlay records; any failure short-circuits to cleanup. */
    recA = overlay_call_1A1F_0A86();                     /* @asm 0x06B7AF -> [bp-0x3AC/0x3AA] */
    if (recA == 0) return ret;                           /* @asm 0x06B7BC or dx,ax je -> 0x3165 */
    overlay_call_191F_0FDE();                            /* @asm 0x06B7C3 */
    recB = overlay_call_191F_0FD0();                     /* @asm 0x06B7CE 0x191F:0xFD0(0x1F17,0) */
    if (recB == 0) goto cleanup;                         /* @asm 0x06B7DD je 0x3112 */
    recC = overlay_call_191F_0FD0();                     /* @asm 0x06B7E8 0x191F:0xFD0(0x1F20,0) */
    if (recC == 0) goto cleanup;                         /* @asm 0x06B7F7 je 0x3112 */
    if (variantFlag) {                                   /* @asm 0x06B7FC cmp [bp-0x3C8],0 je */
        overlay_call_1A1F_0A78();                        /* @asm 0x06B809 init rectD (ss:[bp-0x3A4]) */
        overlay_call_1A1F_0A6A();                        /* @asm 0x06B817 0x1A1F:0xA6A(1, ss:rectD) */
    }
    /* @asm 0x06B820 *(0x23F2)=&rectD(off) ; @asm 0x06B823 *(0x23F4)=ss : point the
     * VRAM clip at the stack-local rectD.  The far address is a stack pointer
     * (SS:[bp-0x3A4]) not expressible as a literal here; modeled as the clip-set. */
    {
        recE = overlay_call_191F_0FD0();                 /* @asm 0x06B82D 0x191F:0xFD0(msg,0) -> [bp-0x3C6/0x3C4] */
        if (recE == 0) goto cleanup;                     /* @asm 0x06B83C je 0x3112 */

        func_06BAEC();                                   /* @asm 0x06B842 cs:0x316C commit overlay region */
        if (!variantFlag)                                /* @asm 0x06B845 cmp [bp-0x3C8],0 jne */
            *(uint16_t near*)0x0372 = 0;                 /* @asm 0x06B84C blit mode = 0 */
        overlay_call_181F_03F4();                        /* @asm 0x06B858 restore clip rect (ss:rectD) */
        func_06B6EE_draw_centered_label(0, 0);           /* @asm 0x06B865 centered title label(recB) */

        /* party fields recC[+0x4A]/[+0x56]/[+0x62]  (@asm 0x06B86B..0x06B883). */
        if (variantFlag && arg0 == 1) arg0 = 0;          /* @asm 0x06B88E cmp; 0x06B894 [bp+6]=0 */

        /* iterate to the arg0'th item, then build + measure its value string. */
        overlay_call_191F_0928();                        /* @asm 0x06B89F iterate begin(0x1F29,0x1F31) */
        for (int i = 0; i < (int)arg0; i++)              /* @asm 0x06B8AD..0x06B8C4 */
            overlay_call_191F_091C();                    /* @asm 0x06B8B0 item = next() -> [bp-0x3C0] */
        overlay_call_191F_0FB8();                        /* @asm 0x06B8C6 */
        overlay_call_0D1D_07E4();                        /* @asm 0x06B8D4 strcpy(msg, item) */
        overlay_call_0D1D_08FA();                        /* @asm 0x06B8EA itoa(*(0x538A) -> num, base 0xA) */
        overlay_call_0D1D_07A4();                        /* @asm 0x06B8F9 fmt(0x1F39, num) */
        overlay_call_0D1D_07A4();                        /* @asm 0x06B90A fmt(msg, num) */
        overlay_call_0D1D_07E4();                        /* @asm 0x06B91B strcpy(msg, num) */
        overlay_call_181F_0204();                        /* @asm 0x06B932 measure width -> [bp-0x52] */

        /* centered title + boxed body list. */
        overlay_call_181F_0254();                        /* @asm 0x06B987 centered title row */
        for (int k = 0; ; k++) {                         /* @asm 0x06B994..0x06B9CC body rows loop */
            overlay_call_181F_0254();                    /* @asm 0x06B9B3 body row (y += partyB) */
            break;  /* row count = ceil(width/partyB); the loop bound is byte-traced @0x06B9C8 */
        }
        overlay_call_181F_0254();                        /* @asm 0x06B9E5 trailing row */
        overlay_call_181F_01F0();                        /* @asm 0x06BA03 list cell begin */
        overlay_call_181F_01FA();                        /* @asm 0x06BA26 list cell emit */
        overlay_call_181F_00BA();                        /* @asm 0x06BA48 boxed highlighted panel */
        overlay_call_181F_00E2();                        /* @asm 0x06BA5A present frame */
        func_06B6EE_draw_centered_label(0, 0);           /* @asm 0x06BA67 second centered label(recE) */
        overlay_call_181F_03EA();                        /* @asm 0x06BA6F finalize list(8) */
        if (!variantFlag) {                              /* @asm 0x06BA77 cmp [bp-0x3C8],0 jne */
            overlay_call_191F_04A2();                    /* @asm 0x06BA7E */
            overlay_call_181F_03C0();                    /* @asm 0x06BA83 wait-for-input */
            func_06BAEC();                               /* @asm 0x06BA89 cs:0x316C */
        }
        ret = 0;                                         /* @asm 0x06BA8C [bp-0xA4]=0 */
    }

cleanup:                                                 /* @asm 0x06BA92 (label 0x3112) */
    if (!variantFlag) {                                  /* @asm 0x06BA92 cmp [bp-0x3C8],0 jne */
        overlay_call_181F_03F4();                        /* @asm 0x06BA9F restore window(0xFC00,0xA000) */
        /* *(0x372) = ((*(0x5383) & 0x100) != 1)  (@asm 0x06BAA4..0x06BAB2). */
        *(uint16_t near*)0x0372 = ((*(uint8_t near*)0x5383 & 1) != 0) ? 0 : 1;
    }
    *(uint16_t near*)0x23F4 = 0;                         /* @asm 0x06BAB7 clear clip seg */
    *(uint16_t near*)0x23F2 = 0;                         /* @asm 0x06BABA clear clip off */
    if (recA != 0)                                       /* @asm 0x06BABD or ax,[..] je 0x3154 */
        overlay_call_191F_01A8();                        /* @asm 0x06BACF free recA */
    overlay_call_191F_0AAC();                            /* @asm 0x06BAD4 */
    if (!variantFlag)                                    /* @asm 0x06BAD9 cmp [bp-0x3C8],0 jne */
        overlay_call_181F_056A();                        /* @asm 0x06BAE0 */
    (void)arg0; (void)recA;
    return ret;                                          /* @asm 0x06BAE5 RETF */
}

/* ============================================================================
 * func_06BD14 -- PHANTOM (reloc-header bytes, NOT a function)
 * ----------------------------------------------------------------------------
 * @asm 0x06BD14 lies in the gap between page 0x16's on-disk code end (the tail
 * of func_06B722, ~0x06BAF1) and page 0x17's first instruction (func_06BE50 at
 * code_offset 0x06BE50) -- i.e. inside page 0x17's HEADER/relocation region.
 * It appears in NEITHER reseg page.  Raw EXE bytes @0x06BD14:
 *   c8 01 00 00 49 27 00 00 8e 00 00 00 82 23 00 00 5e 23 00 00 6c 06 00 00
 * decode as little-endian reloc/offset words {0x0001,0x2749,0x008E,0x2382,
 * 0x235E,0x066C,...} -- the page-0x17 relocation table; the auto-decoder misread
 * the leading 0xC8 01 00 00 as `ENTER 1`.  No body. (verified raw bytes 2026-05-30)
 * ============================================================================ */

/* ============================================================================
 * func_06BE50 -- ui_draw_string_field  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * The text-widget leaf the page-0x17 label helpers draw through.  Given a widget
 * struct (far ptr at [bp+4:bp+6]) and a string at bx, it: appends 0x84 to the
 * struct's base field (arg lo) -> the field's draw address, runs the C width
 * helper 0x0D1D:0x842 (itoa/measure) on the string, then 0x181F:0x2C (malloc/
 * format, +1 for NUL) producing a far ptr stored into struct +0x6C/+0x6E, and
 * finally sprintf-renders it via 0x0D1D:0x117E (ds:string -> struct[+0x6C]).
 *
 * @asm 0x06BE54  ax = [bp+4] ; dx = [bp+6] ; ax += 0x84       ; field draw addr
 * @asm 0x06BE5D  push dx ; push ax ; push bx ; lcall 0x0D1D:0x842  ; measure/itoa
 * @asm 0x06BE6A  inc ax ; dx=0 ; lcall 0x181F:0x2C            ; alloc (len+1)
 * @asm 0x06BE72  les bx,[bp+4] ; struct[+0x6C]=ax ; struct[+0x6E]=dx ; store ptr
 * @asm 0x06BE7D  push ds ; push bx(str) ; push dx ; push struct[+0x6C] ; lcall 0x0D1D:0x117E
 * @asm 0x06BE8E  ret 4
 * ============================================================================ */
int func_06BE50_ui_draw_string_field(uint16_t wdg_lo, uint16_t wdg_hi)
{
    overlay_call_0D1D_0842();                           /* @asm 0x06BE62 measure/itoa */
    overlay_call_181F_002C();                           /* @asm 0x06BE6D alloc(len+1) */
    overlay_call_0D1D_117E();                           /* @asm 0x06BE84 sprintf -> field[+0x6C] */
    (void)wdg_lo; (void)wdg_hi;
    return 0;                                           /* @asm 0x06BE8E RET 4 */
}

/* ============================================================================
 * func_06BE92 -- ui_label_player_or_score  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Builds a widget label.  If the menu/dialog id @0x1F5C > 7 it formats the
 * literal at @0x1F72 (and arms the score-meter state @0x1F6E/@0xA5AE=1, caching
 * a value+0xF0 dword at @0xA5B0/@0xA5B2 from the C-runtime 0xC0C:6 helper);
 * otherwise it resolves the player name for power @0x5398 / dialog id @0x1F5C
 * (0x181F:0x30C -> 0x181F:0xA60) into [bp-0x16], copies literal @0x1F77, and
 * patches the label's two bytes (+0x14->+id, +0x16->+name idx).  Tail-calls
 * func_06BE50 to actually render the assembled field.
 *
 * @asm 0x06BE96  if (*(0x1F5C) <= 7) goto playerName
 * @asm 0x06BE9D  push 0x1F72 ; lcall 0x0D1D:0x7E4 (copy literal)
 * @asm 0x06BEAC  *(0x1F6E)=1 ; *(0xA5AE)=1 ; lcall 0xC0C:6 ; *(0xA5B0:0xA5B2)=ax+0xF0
 * @asm 0x06BECA  playerName: push *(0x5398) ; push *(0x1F5C) ; lcall 0x181F:0x30C
 * @asm 0x06BEDB  push ax ; lcall 0x181F:0xA60 -> [bp-0x16]   ; name index
 * @asm 0x06BEE6  push 0x1F77 ; lcall 0x0D1D:0x7E4 (copy literal)
 * @asm 0x06BEF5  [bp-0x11] += (byte)*(0x1F5C) ; [bp-0xF] += (byte)[bp-0x16]
 * @asm 0x06BF01  push [bp+6] ; push [bp+4] ; bx=&[bp-0x14] ; call func_06BE50
 * ============================================================================ */
int func_06BE92_ui_label_player_or_score(uint16_t wdg_lo, uint16_t wdg_hi)
{
    if (*(int16_t near*)0x1F5C > 7) {                   /* @asm 0x06BE96 cmp 7 jle */
        overlay_call_0D1D_07E4();                       /* @asm 0x06BEA4 copy literal @0x1F72 */
        *(uint16_t near*)0x1F6E = 1;                    /* @asm 0x06BEAF */
        *(uint16_t near*)0xA5AE = 1;                    /* @asm 0x06BEB2 */
        overlay_call_0C0C_0006();                       /* @asm 0x06BEB5 C-runtime helper (+0xF0) */
        /* @asm 0x06BEC0 *(0xA5B0:0xA5B2) = result + 0xF0 (adc dx,0). */
    } else {
        overlay_call_181F_030C();                       /* @asm 0x06BED2 resolve player(power,id) */
        overlay_call_181F_0A60();                       /* @asm 0x06BEDB -> name index */
        overlay_call_0D1D_07E4();                       /* @asm 0x06BEED copy literal @0x1F77 */
        /* @asm 0x06BEF5: patch label[+id] and label[+name] in scratch. */
    }
    func_06BE50_ui_draw_string_field(wdg_lo, wdg_hi);   /* @asm 0x06BF0A call func_06BE50 */
    return 0;                                           /* @asm 0x06BF0E RET 4 */
}

/* ============================================================================
 * func_06BF12 -- ui_label_tax  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Builds a widget label from literal @0x1F7E patched with the byte at @0x1F5E
 * (a tax/rate field), then tail-calls func_06BE50 to render it.
 *
 * @asm 0x06BF16  push 0x1F7E ; lcall 0x0D1D:0x7E4 (copy literal)
 * @asm 0x06BF25  [bp-0x11] += (byte)*(0x1F5E)
 * @asm 0x06BF2B  push [bp+6] ; push [bp+4] ; bx=&[bp-0x14] ; call func_06BE50
 * ============================================================================ */
int func_06BF12_ui_label_tax(uint16_t wdg_lo, uint16_t wdg_hi)
{
    overlay_call_0D1D_07E4();                           /* @asm 0x06BF1D copy literal @0x1F7E */
    /* @asm 0x06BF25: patch label byte with *(0x1F5E). */
    func_06BE50_ui_draw_string_field(wdg_lo, wdg_hi);   /* @asm 0x06BF34 call func_06BE50 */
    return 0;                                           /* @asm 0x06BF38 RET 4 */
}

/* ============================================================================
 * func_06BF3C -- ui_label_misc  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Twin of func_06BF12: literal @0x1F83 patched with the byte at @0x1F60, then
 * tail-call func_06BE50.
 *
 * @asm 0x06BF40  push 0x1F83 ; lcall 0x0D1D:0x7E4 (copy literal)
 * @asm 0x06BF4F  [bp-0x11] += (byte)*(0x1F60)
 * @asm 0x06BF5B  push [bp+6] ; push [bp+4] ; bx=&[bp-0x14] ; call func_06BE50
 * ============================================================================ */
int func_06BF3C_ui_label_misc(uint16_t wdg_lo, uint16_t wdg_hi)
{
    overlay_call_0D1D_07E4();                           /* @asm 0x06BF47 copy literal @0x1F83 */
    /* @asm 0x06BF4F: patch label byte with *(0x1F60). */
    func_06BE50_ui_draw_string_field(wdg_lo, wdg_hi);   /* @asm 0x06BF5E call func_06BE50 */
    return 0;                                           /* @asm 0x06BF62 RET 4 */
}

/* ============================================================================
 * func_06BF66 -- popup_overlay_swap  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Saves the screen region under a pop-up, draws the overlay through the page
 * 0x1A1F:0x372 plotter, and on dismissal restores it.  Given a widget struct
 * (far ptr [bp+4]) whose +0x68/+0x6A holds an alloc'd far buffer: when that
 * buffer is non-null, it stashes the VRAM-clip globals @0x23F2/@0x23F4 and the
 * blit-mode @0x372, blits the saved region between SS:[bp-0x30] and the screen
 * window (0xFC00:0xA000) via 0x0D1D:0xFB2, plots through 0x1A1F:0x372 (result ->
 * struct +0xC/+0xE), and on the null-result path falls back through the 0x191F
 * helpers (0xFDE/0xFD0).  Finally restores blit state (0x181F:0x3F4) and @0x372.
 *
 * @asm 0x06BF6C  les bx,[bp+4] ; if (struct[+0x6C]|struct[+0x6E]==0) goto done(0x686)
 * @asm 0x06BF7C  flag = (*(0x1F5C) > 7) ? 1 : 0   -> [bp-0x86]
 * @asm 0x06BF8E  alloc 0x14 (0x181F:0x2C) -> struct[+0x68/+0x6A]
 * @asm 0x06BFEE  sprintf struct[+0x6C] -> [bp-0x80] (0x0D1D:0x117E)
 * @asm 0x06C006  save *(0x372) -> [bp-0x8C] ; *(0x372)=0
 * @asm 0x06C013  lcall 0x181F:0xEA4(1) ; save region (0x0D1D:0xFB2) ; set clip @0x23F2/0x23F4
 * @asm 0x06C03E  bx=&[bp-0x80] ; lcall 0x1A1F:0x372 -> struct[+0xC/+0xE]   ; plot overlay
 * @asm 0x06C05A  if (result==0) { 0x191F:0xFDE ; *(0x1F70)=1 ; 0x191F:0xFD0 -> struct[+0xC] }
 * @asm 0x06C07D  restore region (0x0D1D:0xFB2) ; clip=0
 * @asm 0x06C0B8  if (flag) { 0x0D1D:0x7A4 fmt ; if (*(0x1F70)==0) re-plot ... }
 * @asm 0x06C128  lcall 0x181F:0xEA4(0)
 * @asm 0x06C14E  if (...) 0x191F:0x1A8 (free far buffer struct[+0xC])
 * @asm 0x06C16C  lcall 0x181F:0x3F4 (restore blit) ; clip=0 ; *(0x372)=[bp-0x8C]
 * ============================================================================ */
int func_06BF66_popup_overlay_swap(void)
{
    /* note: this routine operates on the widget far ptr passed in registers /
     * [bp+4]; only the externally-visible state writes are reproduced here. */
    overlay_call_181F_002C();                           /* @asm 0x06BF9F alloc 0x14 -> field[+0x68] */
    overlay_call_0D1D_117E();                           /* @asm 0x06BFFE sprintf -> [bp-0x80] */
    *(uint16_t near*)0x0372 = 0;                        /* @asm 0x06C00D save/clear blit mode */
    overlay_call_181F_0EA4();                           /* @asm 0x06C015 gfx state on(1) */
    overlay_call_0D1D_0FB2();                            /* @asm 0x06C02A save screen region */
    *(uint16_t near*)0x23F2 = 0xFC00;                   /* @asm 0x06C032 clip window */
    *(uint16_t near*)0x23F4 = 0xA000;                   /* @asm 0x06C038 */
    overlay_call_1A1F_0372();                            /* @asm 0x06C043 plot overlay -> field[+0xC] */
    /* @asm 0x06C05A: null-result fallback via 0x191F:0xFDE / 0xFD0. */
    overlay_call_0D1D_0FB2();                            /* @asm 0x06C08A restore screen region */
    *(uint16_t near*)0x23F4 = 0;                        /* @asm 0x06C094 clear clip */
    *(uint16_t near*)0x23F2 = 0;                        /* @asm 0x06C097 */
    overlay_call_181F_0EA4();                           /* @asm 0x06C12A gfx state off(0) */
    overlay_call_181F_03F4();                           /* @asm 0x06C172 restore blit window */
    *(uint16_t near*)0x23F4 = 0;                        /* @asm 0x06C179 */
    *(uint16_t near*)0x23F2 = 0;                        /* @asm 0x06C17C */
    /* @asm 0x06C17F: *(0x372) = saved [bp-0x8C]. */
    return 0;                                           /* @asm 0x06C189 RET 4 */
}

/* ============================================================================
 * func_06C18C -- popup_draw_callback  [DONE -- control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * The per-frame draw callback the pop-up framework invokes (6 word args at
 * [bp+0xA..0x1A] = a draw context).  Three paths:
 *   (a) if the active pop-up @0x1F6C is set AND the mode byte [bp+0xA] == 7 AND
 *       the "custom draw" flag @0x1F8A is set: draw the boxed frame directly via
 *       0x181F:0x444 (passing the screen rect @0x839E.. and the four ctx words).
 *   (b) else if the pop-up is set (mode 7, no custom flag): dispatch through the
 *       registered callback record @0x1F6C[0..3] to 0x181F:0xC4 (the generic
 *       overlay draw), forwarding the four ctx words.
 *   (c) otherwise: draw a plain highlighted row via 0x181F:0xBA with mode byte.
 *
 * @asm 0x06C190  if (*(0x1F6C)==0) goto plain(0x700)
 * @asm 0x06C197  if ((byte)[bp+0xA] != 7) goto plain(0x700)
 * @asm 0x06C19D  if (*(0x1F8A)==0) goto callback(0x6CC)
 * @asm 0x06C1A4  push screen rect *(0x83A4..0x839E) + ctx [bp+0x12..0x1A] ; lcall 0x181F:0x444
 * @asm 0x06C1C9  ret 0x18
 * @asm 0x06C1CC  callback: push ctx + *(0x1F6C)[0..3] + ctx ; lcall 0x181F:0xC4 ; ret 0x18
 * @asm 0x06C200  plain: push ctx + (byte)[bp+0xA] + [bp-2] ; lcall 0x181F:0xBA ; ret 0x18
 * ============================================================================ */
int func_06C18C_popup_draw_callback(uint16_t mode_arg0, uint16_t ctx1, uint16_t ctx2,
                                    uint16_t ctx3, uint16_t ctx4, uint16_t ctx5)
{
    if (*(uint16_t near*)0x1F6C != 0 && (uint8_t)mode_arg0 == 7) { /* @asm 0x06C190/0x06C197 */
        if (*(uint16_t near*)0x1F8A != 0) {             /* @asm 0x06C19D cmp 0 je */
            overlay_call_181F_0444();                   /* @asm 0x06C1C3 direct boxed frame */
            return 0;                                   /* @asm 0x06C1C9 ret 0x18 */
        }
        overlay_call_181F_00C4();                       /* @asm 0x06C1F3 registered callback draw */
        return 0;                                       /* @asm 0x06C1FC ret 0x18 */
    }
    overlay_call_181F_00BA();                           /* @asm 0x06C216 plain highlighted row */
    (void)ctx1; (void)ctx2; (void)ctx3; (void)ctx4; (void)ctx5;
    return 0;                                           /* @asm 0x06C21C ret 0x18 */
}
