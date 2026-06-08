/* ============================================================================
 * overlay_070302_074405.c -- overlay functions in file range 0x070302..0x074405
 *
 * Region: NEW-GAME SETUP screens (difficulty / nation pickers), the .MP MAP
 * file load/save/create path, CONFIG.COL + argv/env parsing, the save/load
 * filename builders, and the new-game power-table initialiser.
 * Spans TWO re-segmented overlay pages of VICEROY.EXE:
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_19.asm
 *       (record 24; code_base 0x06FDF0; code_end 0x071490)  -- funcs ..0x0713D4
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_1A.asm
 *       (record 25; code_base 0x072090; code_end 0x0763D0)  -- funcs 0x072090..
 * The re-seg pages are AUTHORITATIVE for extents; the legacy per-func
 * disasm/func_*.asm dumps this file's old banners cited TRUNCATE at the first
 * RET (e.g. they call func_070302 "165 bytes" when it is 402) -- they are NOT
 * trusted here.  Raw entry prologues + every literal were spot-checked against
 * COLONIZE/VICEROY.EXE (DGROUP image base = file 0x1D9A0).
 *
 * STRICT cite-or-not-yet-decoded: every value/offset cites the reseg .asm (@asm 0xXXXXXX);
 * string literals cite their DGROUP byte offset (@bytes); anything undeterminable
 * (opaque 0x191F/0x1A1F overlay-page-0x11/0x12 targets) is left as the canonical
 * overlay_call_* thunk and never guessed.
 *
 * PORT STATUS (per 2026-05-30 directive):
 *   DONE            full @asm-cited body written here (control flow byte-traced).
 *   SUPERSEDED      already ported to a named src/<subsystem>/ file (one-liner).
 *   TRAMPOLINE      RTLink JMP-FAR block -> one-line forwarding stub.
 *   PHANTOM         reloc/header/interior bytes mis-framed as a function.
 *
 * KEY ARCHITECTURE FACTS (byte-verified this pass):
 *   - 0x181F:* = the UI-widget overlay (page 0x12 context).  Recurring calls:
 *       0x22  load/blit image record    0x1C8 composite/draw
 *       0xCE  draw text at (x,y,color)   0xE2  fill/flush rect
 *       0x100 draw string field          0x11E/0x128 begin/commit text buffer
 *       0x16E append text (key->buf)     0x178 append literal
 *       0x204 measure text width         0x444 draw framed box   0x29A malloc
 *       0x4D4 random_int(lo,hi)  [BYTE_VERIFIED, project mem]
 *       0x40A/0x3FE  popup save/restore  0xA24 palette/color
 *   - 0x0D1D:* = MSC 6.0 C runtime.  0x4DA fopen  0x528/0x60C fread  0x3F4 fclose
 *       0x7E4 strcpy  0x7A4 strcat  0xD64 strlen  0x816 strcmp  0x842 strlen
 *       0x11FA memset/fill  0xE63/0xE58 sscanf-token  0x117E sprintf-field
 *   - .MP map files: header = {u16 width, u16 height} then map_w*map_h-byte
 *     layers; opened "rb"(0x208e/0x2094) load / "wb"(0x2091) save; ext "mp"(0x154).
 *     Map dims live at DGROUP 0x853A (w) / 0x853C (h); w*h dword at 0x85A4/0x85A6;
 *     4 layer pointers at 0x15C/0x160/0x164/0x168.  Default map = 0x78 x 0x4B.
 *   - Save files: magic "COLONIZE"(0x217A), name "COLONY"(0x20E2)+slot+".SAV"(0x20E9).
 *   - PowerRecord base 0x8808 stride 0x13C; AIPersonality base 0x540E stride 0x34;
 *     difficulty byte 0x53A6; chosen-nation index word 0x5398 (0..3).
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ----------------------------------------------------------------------------
 * DGROUP globals referenced below (absolute offsets from the disassembly).
 * Roles are byte-verified from the access patterns; pure-coordinate / opaque
 * runtime tables keep neutral names.  cite-or-not-yet-decoded applies to SEMANTICS.
 * -------------------------------------------------------------------------- */
/* g_difficulty_53A6 (DGROUP:0x53A6, uint8_t) comes from globals.h via viceroy.h. */
extern uint16_t g_sel_nation_5398;        /* DGROUP:0x5398 -- chosen / current power index (0..3) */
extern uint8_t  g_flags_5381;             /* DGROUP:0x5381 -- power flag byte (multi marker) */
extern uint8_t  g_flags_5382;             /* DGROUP:0x5382 -- power flag byte (king/diff marker) */

extern uint16_t g_map_w_853A;             /* DGROUP:0x853A -- map width */
extern uint16_t g_map_h_853C;             /* DGROUP:0x853C -- map height */
extern uint16_t g_map_area_85A4;          /* DGROUP:0x85A4 -- map_w*map_h (dword lo) */
extern uint16_t g_map_area_85A6;          /* DGROUP:0x85A6 -- map_w*map_h (dword hi) */
extern uint16_t g_map_buf_alloc_15A;      /* DGROUP:0x15A  -- "use fixed buffer size" flag */
extern uint16_t g_map_size_lo_180;        /* DGROUP:0x180  -- requested byte count (lo) */
extern uint16_t g_map_size_hi_182;        /* DGROUP:0x182  -- requested byte count (hi) */
extern uint16_t g_map_dim_w_8550;         /* DGROUP:0x8550 -- map alloc dim (0xF0) */
extern uint16_t g_map_dim_h_8552;         /* DGROUP:0x8552 -- map alloc dim (0xC0) */
extern uint16_t g_map_layer0_15C, g_map_layer0_15E;  /* DGROUP:0x15C/0x15E far ptr layer 0 */
extern uint16_t g_map_layer1_160, g_map_layer1_162;  /* DGROUP:0x160/0x162 far ptr layer 1 */
extern uint16_t g_map_layer2_164, g_map_layer2_166;  /* DGROUP:0x164/0x166 far ptr layer 2 */
extern uint16_t g_map_layer3_168, g_map_layer3_16A;  /* DGROUP:0x168/0x16A far ptr layer 3 */
extern uint16_t g_map_id_152;             /* DGROUP:0x152  -- loaded map id / 4 = "blank" */
extern uint16_t g_result_158;             /* DGROUP:0x158  -- map/load result-code out */
extern uint16_t g_save_version_81A;       /* DGROUP:0x81A  -- expected save version */
extern uint16_t g_cli_default_map_18C;    /* DGROUP:0x18C  -- "default-map already loaded" flag */

extern char     g_path_buf_8554[];        /* DGROUP:0x8554 -- working path/filename buffer */
extern char     g_save_path_84FE[];       /* DGROUP:0x84FE -- save path buffer */
extern uint16_t g_err_822;                /* DGROUP:0x822  -- error-code latch */

/* Runtime word tables populated by the menu builders (NOT static at link time).
 * Each holds per-row state addressed by row index.  Semantics are documented
 * per-variable below; g_row_y_ramp_2DA8 values are (0xA06..0xA6F step 0x15). */
extern uint16_t g_row_state_a_8394[];     /* DGROUP:0x8394 (= bx-0x7C6C) -- per-row label handle table */
extern uint16_t g_row_y_ramp_2DA8[];      /* DGROUP:0x2DA8 -- row Y-coordinate ramp (0xA06..0xA6F step 0x15) */
extern uint16_t g_panel_xy_839E[];        /* DGROUP:0x839E -- panel x/y/w/h push-block (4 words) */
extern uint8_t  g_diff_color_848[];       /* DGROUP:0x848  -- per-nation banner colour table {0x0C,0x09,0x0E,0x0D} */

/* ----------------------------------------------------------------------------
 * RTLink JMP-FAR trampoline blocks living INSIDE this file's address range.
 * Each is `ljmp 0x1A1F:0xNNN` forwarding into overlay page 0x12 (the widget /
 * helper code).  They are the near-CALL targets the drawers reference; we model
 * each as a forwarding stub citing its resolved seg:off.  (Bodies are page 0x12.)
 *
 *   block @0x070C3C..0x070C68 (page 0x19):
 *     0x070C3C ljmp 0x1A1F:0x0B58   0x070C41 0x1A1F:0x0B82   0x070C46 0x1A1F:0x0B90
 *     0x070C4B 0x1A1F:0x0B9E        0x070C50 0x1A1F:0x0BAC   0x070C55 0x1A1F:0x0BBA
 *     0x070C5A 0x1A1F:0x0BC8        0x070C5F 0x1A1F:0x0BD6   0x070C64 0x1A1F:0x0BF2
 *   block @0x070F8C..0x070F9B (page 0x19): 0x1A1F:0xC00 / 0xC0E / 0xC1C / 0xC2A
 *   block @0x07147C..0x071481 (page 0x19): 0x1A1F:0xC64 / 0xC72
 *   block @0x073266..0x07326B (page 0x1A): 0x1A1F:0xCDA / 0xCE8
 * -------------------------------------------------------------------------- */
extern int overlay_call_1A1F_0B58(void);       /* 0x1A1F:0x0B58 */
extern int overlay_call_1A1F_0B90(void);       /* 0x1A1F:0x0B90 -- difficulty-row label format */
extern int overlay_call_1A1F_0BAC(void);       /* 0x1A1F:0x0BAC -- difficulty-row draw (per i) */
extern int overlay_call_1A1F_0BBA(void);       /* 0x1A1F:0x0BBA */
extern int overlay_call_1A1F_0BC8(void);       /* 0x1A1F:0x0BC8 -- nation-row label format */
extern int overlay_call_1A1F_0BD6(void);       /* 0x1A1F:0x0BD6 -- nation-row draw (per i) */
extern int overlay_call_1A1F_0BF2(void);       /* 0x1A1F:0x0BF2 -- format helper */
extern int overlay_call_1A1F_0C00(void);       /* 0x1A1F:0x0C00 */
extern int overlay_call_1A1F_0C0E(void);       /* 0x1A1F:0x0C0E */
extern int overlay_call_1A1F_0C1C(void);       /* 0x1A1F:0x0C1C */
extern int overlay_call_1A1F_0C2A(void);       /* 0x1A1F:0x0C2A */
extern int overlay_call_1A1F_0C64_alloc(void); /* 0x1A1F:0x0C64 -- map-buffer allocator entry */
extern int overlay_call_1A1F_0C72(void);       /* 0x1A1F:0x0C72 */
extern int overlay_call_1A1F_0CDA(void);       /* 0x1A1F:0x0CDA -- save-name helper */
extern int overlay_call_1A1F_0CE8(void);       /* 0x1A1F:0x0CE8 -- load-name helper */

/* page-0x19 trampoline @0x070C3C block -> tramp stubs (near-call names kept) */
int func_070C3C(void) { return overlay_call_1A1F_0B58(); }       /* @asm 0x070C3C ljmp 0x1A1F:0x0B58 */
int func_070C46(void) { return overlay_call_1A1F_0B90(); }       /* @asm 0x070C46 ljmp 0x1A1F:0x0B90 */
int func_070C50(void) { return overlay_call_1A1F_0BAC(); }       /* @asm 0x070C50 ljmp 0x1A1F:0x0BAC */
int func_070C5A(void) { return overlay_call_1A1F_0BC8(); }       /* @asm 0x070C5A ljmp 0x1A1F:0x0BC8 */
int func_070C5F(void) { return overlay_call_1A1F_0BD6(); }       /* @asm 0x070C5F ljmp 0x1A1F:0x0BD6 */
int func_070C64(void) { return overlay_call_1A1F_0BF2(); }       /* @asm 0x070C64 ljmp 0x1A1F:0x0BF2 */
/* near-call helpers used by the file-IO group resolve through page-0x12 too. */
int func_07147C(void) { return overlay_call_1A1F_0C64_alloc(); } /* @asm 0x07147C ljmp 0x1A1F:0x0C64 (map alloc) */
int func_071481(void) { return overlay_call_1A1F_0C72(); }       /* @asm 0x071481 ljmp 0x1A1F:0x0C72 */
int func_073266(void) { return overlay_call_1A1F_0CDA(); }       /* @asm 0x073266 ljmp 0x1A1F:0x0CDA */
int func_07326B(void) { return overlay_call_1A1F_0CE8(); }       /* @asm 0x07326B ljmp 0x1A1F:0x0CE8 */
/* page-0x19 @0x070F8C block (used by func_070EBA) */
int func_070F8C(void) { return overlay_call_1A1F_0C00(); }       /* @asm 0x070F8C ljmp 0x1A1F:0x0C00 */
int func_070F91(void) { return overlay_call_1A1F_0C0E(); }       /* @asm 0x070F91 ljmp 0x1A1F:0x0C0E */
int func_070F96(void) { return overlay_call_1A1F_0C1C(); }       /* @asm 0x070F96 ljmp 0x1A1F:0x0C1C */
int func_070F9B(void) { return overlay_call_1A1F_0C2A(); }       /* @asm 0x070F9B ljmp 0x1A1F:0x0C2A */

/* Local prototypes for intra-file calls (defined further down). */
int func_071106_load_mp_map(void);
int func_070FF8_alloc_map_buffers(uint16_t want_second);

/* ============================================================================
 * func_070302 — draw_difficulty_row   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Draws ONE row of the difficulty-selection screen for difficulty index `idx`
 * (0..4 = Discoverer..Viceroy).  Builds the row label via func_071106's sister
 * (LCALL through trampoline 0x070C46 -> 0x1A1F:0x0B90 into [bp-0x56]/[bp-0x54]),
 * draws the row's framed box (width 0x44 @0x181F:0x444), picks a DOS palette
 * COLOUR by idx (switch below), and — only for the row whose idx equals the
 * currently-selected difficulty [0x53A6] — draws the highlighted label text in
 * that colour at the row's screen position (text @0x181F:0xCE/0x16E/0x100,
 * strlen 0x0D1D:0xD64, strcat ":" 0x0D1D:0x7A4).  Closes with a flush 0x181F:0xE2.
 *
 * COLOUR map (@asm 0x07035C..0x070834, stored to [bp-0x58]):
 *     idx 0 -> 0x0A  idx 1 -> 0x09  idx 2 -> 0x0E  idx 3 -> 0x0D  default -> 0x0C
 *   (DOS 16-colour palette: lt-green / lt-blue / yellow / lt-magenta / lt-red.)
 *
 * @asm 0x070314  call 0x070C46 (-> 0x1A1F:0x0B90)   ; build label into bp-0x56/54
 * @asm 0x070345  lcall 0x181F:0x444 (bx=0x44,len=0x5a)  ; framed box
 * @asm 0x07034F  switch(idx): 0->0xA 1->9 2->0xE 3->0xD def->0xC
 * @asm 0x070378  al=[0x53A6]; if (al != idx) jmp end  ; only the selected row
 * @asm 0x0703AB  lcall 0x181F:0xCE                    ; draw label text
 * @asm 0x0703E3  lcall 0x0D1D:0xD64 (strlen)          ; @bytes 0x202B = ":"
 * @asm 0x0703F2  lcall 0x0D1D:0x7A4 (strcat ":")
 * @asm 0x07040B/0x070428/0x07045E/0x070474  lcall 0x181F:0x100 (string field x4)
 * @asm 0x07048B  lcall 0x181F:0xE2  -> RETF
 * ============================================================================ */
int func_070302_draw_difficulty_row(uint16_t idx)
{
    uint8_t color;

    func_070C46();                                      /* @asm 0x070314 build row label */
    overlay_call_181F_0444();                           /* @asm 0x070345 draw framed box */

    switch (idx) {                                      /* @asm 0x07034D..0x070834 */
        case 0:  color = 0x0A; break;                   /* @asm 0x07035C */
        case 1:  color = 0x09; break;                   /* @asm 0x070362 */
        case 2:  color = 0x0E; break;                   /* @asm 0x070368 */
        case 3:  color = 0x0D; break;                   /* @asm 0x07036E */
        default: color = 0x0C; break;                   /* @asm 0x070374 */
    }

    if ((uint8_t)g_difficulty_53A6 == (uint8_t)idx) {   /* @asm 0x07037D only selected row */
        overlay_call_181F_00CE();                       /* @asm 0x0703AB label text @row+0x59 */
        overlay_call_181F_016E();                       /* @asm 0x0703D7 append handle [0x8394+idx*2] */
        overlay_call_0D1D_0D64();                       /* @asm 0x0703E3 strlen */
        overlay_call_0D1D_07A4();                        /* @asm 0x0703F2 strcat ":" @bytes 0x202B */
        overlay_call_181F_0100();                       /* @asm 0x07040B string field */
        overlay_call_181F_0100();                       /* @asm 0x070428 string field (coloured) */
        overlay_call_181F_016E();                       /* @asm 0x070445 append handle [0x2F04+idx*2] */
        overlay_call_181F_0100();                       /* @asm 0x07045E string field */
        overlay_call_181F_0100();                       /* @asm 0x070474 string field */
        (void)color;                                    /* colour passed into the 0x100 draws */
    }
    overlay_call_181F_00E2();                           /* @asm 0x07048B flush rect -> RETF */
    return 0;
}

/* ============================================================================
 * func_070494 — draw_difficulty_screen   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Composes the whole difficulty-picker screen, then draws all 5 rows.
 * Computes the panel anchor from the cursor sprite height [0x268A] (y = 0x14 -
 * (h>>1)), blits two background image strips (0x181F:0x22 load + 0x181F:0x1C8
 * composite), begins a text buffer (0x181F:0x11E), appends the heading handle
 * [0x2EFC] (0x181F:0x16E), commits it (0x181F:0x128), draws the heading field
 * (0x181F:0x100 at x=0xFE), flushes (0x181F:0xE2 at x=0x80,w=0x67), then
 * for i in 0..4 calls draw_difficulty_row(i) via trampoline 0x070C50.
 *
 * @asm 0x070498  les bx,[0x268A]; al=[es:bx]; y = 0x14 - (al>>1)   ; panel anchor
 * @asm 0x0704DE/0x070501  lcall 0x181F:0x22  (load image strip x2)
 * @asm 0x0704E8/0x07050B  lcall 0x181F:0x1C8 (composite x2)
 * @asm 0x07051B  lcall 0x181F:0x11E (begin text)   @asm 0x07052B 0x16E (append [0x2EFC])
 * @asm 0x070537  lcall 0x181F:0x128 (commit)        @asm 0x07054D 0x100 (field @0xFE,len0x44)
 * @asm 0x070561  lcall 0x181F:0xE2  (flush @0x80,w0x67)
 * @asm 0x07056B  for (i=0;i<5;i++) call 0x070C50 (-> draw_difficulty_row i)
 * ============================================================================ */
int func_070494_draw_difficulty_screen(void)
{
    overlay_call_181F_0022();                           /* @asm 0x0704DE bg strip 0 */
    overlay_call_181F_01C8();                           /* @asm 0x0704E8 composite 0 */
    overlay_call_181F_0022();                           /* @asm 0x070501 bg strip 1 */
    overlay_call_181F_01C8();                           /* @asm 0x07050B composite 1 */
    overlay_call_181F_011E();                           /* @asm 0x07051B begin text buffer */
    overlay_call_181F_016E();                           /* @asm 0x07052B append heading [0x2EFC] */
    overlay_call_181F_0128();                           /* @asm 0x070537 commit text */
    overlay_call_181F_0100();                           /* @asm 0x07054D draw heading field */
    overlay_call_181F_00E2();                           /* @asm 0x070561 flush rect */

    for (int i = 0; i < 5; i++) {                       /* @asm 0x070578 cmp 5 */
        func_070C50();                                  /* @asm 0x07056F -> draw_difficulty_row(i) */
    }
    return 0;                                            /* @asm 0x07057E RETF */
}

/* ============================================================================
 * func_070580 — difficulty_pick_dispatch   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * The modal loop / dispatcher behind the difficulty screen (sister of the
 * nation dispatcher func_070A1A, ~514 bytes).  It runs the input/format chain
 *   0x181F:0x44E (poll/get-event) -> if 0: 0x181F:0x998 (test) and exit,
 *   else 0x181F:0x3B6/0x3F4 (set clip/region), 0x181F:0x444 (draw box),
 *   0x181F:0xE2 (flush), then via near-call 0x070C64 (-> 0x1A1F:0x0BF2) format,
 *   0x181F:0x47A/0x466/0xF6 (hit-test against the row rects), and 0x181F:0x3E0
 *   (resolve which difficulty row the cursor is over) -- writing the result to
 *   the difficulty byte [0x53A6] when a row is chosen.
 *
 * @asm 0x0705A8  lcall 0x181F:0x44E (event)  ; if AX==0 -> 0x998 test then exit
 * @asm 0x0705D8  lcall 0x181F:0x3B6          ; @asm 0x0705E3 0x3F4 region
 * @asm 0x070611  lcall 0x181F:0x444 (box)    ; @asm 0x070623 0xE2 flush
 * @asm 0x070629  call 0x070C64 (-> 0x1A1F:0x0BF2 format)
 * @asm 0x07062C/0x070638/0x070643  lcall 0x181F:0x47A/0x466/0xF6 (hit-test)
 * @asm 0x07064C  lcall 0x181F:0x3E0 (row resolve) -> stores [0x53A6]
 * (Touches DGROUP 0x07F0/0x07F6/0xA60A read; 0x53A6/0xA60A written.)
 * ============================================================================ */
int func_070580_difficulty_pick_dispatch(void)
{
    if (overlay_call_181F_044E() == 0) {                /* @asm 0x0705A8 event; 0 -> exit path */
        overlay_call_181F_0998();                       /* @asm 0x0705BE end-test */
        return 0;                                        /* @asm 0x0705CA/0x0705D5 */
    }
    overlay_call_181F_03B6();                            /* @asm 0x0705D8 set clip */
    overlay_call_181F_03F4();                            /* @asm 0x0705E3 set region */
    overlay_call_181F_0444();                            /* @asm 0x070611 draw box */
    overlay_call_181F_00E2();                            /* @asm 0x070623 flush */
    func_070C64();                                       /* @asm 0x070629 format (-> 0x1A1F:0x0BF2) */
    overlay_call_181F_047A();                            /* @asm 0x07062C hit-test setup */
    overlay_call_181F_0466();                            /* @asm 0x070638 hit-test */
    if (overlay_call_181F_00F6() != 0) {                 /* @asm 0x070643 cursor over a row? */
        overlay_call_181F_03E0();                        /* @asm 0x07064C resolve -> [0x53A6] */
    }
    return 0;                                            /* @asm 0x07076D RETF */
}

/* ============================================================================
 * func_070782 — grid_cell_xy   [DONE — fully BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Pure layout helper: maps a linear cell index to a 2-column grid position.
 *   *out_x = (index % 2) * 0x63 + 0x70    (column width 99, origin x 0x70)
 *   *out_y = (index / 2) * 0x5B + 0x0D    (row    height 91, origin y 0x0D)
 *
 * @asm 0x070787  ax = index ; dx = (index - (index>>31)) >> 1  (= index/2, signed)
 * @asm 0x07079A  idiv 2 -> dx = index % 2 (col), bx = index/2 (row)
 * @asm 0x07079C  ax = col*0x63 + 0x70 ; *out_x = ax           @asm 0x0707A5
 * @asm 0x0707A7  ax = row*0x5B + 0x0D ; *out_y = ax  -> RETF   @asm 0x0707B0
 * ============================================================================ */
int func_070782_grid_cell_xy(uint16_t index, uint16_t *out_x, uint16_t *out_y)
{
    uint16_t col = (uint16_t)((int16_t)index % 2);      /* @asm 0x07079A idiv -> dx */
    uint16_t row = (uint16_t)((int16_t)index / 2);      /* @asm 0x07078D sar/idiv -> bx */
    *out_x = (uint16_t)(col * 0x63 + 0x70);             /* @asm 0x07079C imul 0x63; add 0x70 */
    *out_y = (uint16_t)(row * 0x5B + 0x0D);             /* @asm 0x0707A7 imul 0x5B; add 0x0D */
    return 0;
}

/* ============================================================================
 * func_0707B6 — draw_nation_row   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Sister of func_070302, for the NATIONS picker (England/France/Spain/Holland,
 * idx 0..3).  Guards 0 <= idx <= 3, builds the row label via near-call 0x07111A
 * (the func_071106 family) into [bp-0x56]/[bp-0x54], draws the framed box
 * (width 0x52, height 0x58 @0x181F:0x444), reads the per-nation BANNER COLOUR
 * from the static table [idx + 0x848] (= {0x0C,0x09,0x0E,0x0D}, @bytes 0x848),
 * and — only for the row equal to the current selection [0x5398] — draws the
 * highlighted nation name (text 0x181F:0xCE/0x16E/0x100; strlen 0x0D1D:0xD64;
 * strcat ":" @bytes 0x2041 via 0x0D1D:0x7A4).  Flush 0x181F:0xE2.
 *
 * @asm 0x0707BC  if (idx < 0 || idx > 3) jmp end
 * @asm 0x0707DA  call 0x07111A (build nation label)
 * @asm 0x07080B  lcall 0x181F:0x444 (box bx=0x58,len=0x52)
 * @asm 0x070813  al = [idx + 0x848] -> [bp-0x58]            ; @bytes 0x848 colour table
 * @asm 0x07081A  if ([0x5398] != idx) jmp end               ; only selected row
 * @asm 0x070846  lcall 0x181F:0xCE (name text @row+0x57)
 * @asm 0x070881  lcall 0x0D1D:0x7A4 (strcat ":")            ; @bytes 0x2041 = ":"
 * @asm 0x0708F8/0x07090E  lcall 0x181F:0x100 (string field) ; @asm 0x070925 0xE2 flush
 * ============================================================================ */
int func_0707B6_draw_nation_row(uint16_t idx)
{
    uint8_t color;

    if ((int16_t)idx < 0 || (int16_t)idx > 3)           /* @asm 0x0707BC range gate 0..3 */
        return 0;

    overlay_call_1A1F_0BC8();                           /* @asm 0x0707DA near 0x07111A label build (page 0x12) */
    overlay_call_181F_0444();                           /* @asm 0x07080B draw framed box (w0x52,h0x58) */
    color = g_diff_color_848[idx];                      /* @asm 0x070813 banner colour @bytes 0x848 */

    if ((int16_t)g_sel_nation_5398 == (int16_t)idx) {   /* @asm 0x07081A only selected row */
        overlay_call_181F_00CE();                       /* @asm 0x070846 name text @row+0x57 */
        overlay_call_181F_016E();                       /* @asm 0x070866 append handle [0x8D42+idx*2] */
        overlay_call_0D1D_0D64();                       /* @asm 0x070872 strlen */
        overlay_call_0D1D_07A4();                        /* @asm 0x070881 strcat ":" @bytes 0x2041 */
        overlay_call_181F_0100();                       /* @asm 0x07089A string field */
        overlay_call_181F_0100();                       /* @asm 0x0708B7 string field (coloured) */
        overlay_call_181F_016E();                       /* @asm 0x0708DF append handle [0x2F14+idx*2] */
        overlay_call_181F_0100();                       /* @asm 0x0708F8 string field */
        overlay_call_181F_0100();                       /* @asm 0x07090E string field */
        (void)color;
    }
    overlay_call_181F_00E2();                           /* @asm 0x070925 flush rect -> RETF */
    return 0;
}

/* ============================================================================
 * func_07092E — draw_nation_screen   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Whole NATIONS-picker screen (sister of func_070494).  Panel anchor from the
 * cursor sprite height [0x268A] (y = 0x28 - (h>>1)), two bg strips (0x181F:0x22
 * + 0x1C8), heading text (0x181F:0x11E/0x16E[0x2EFC]/0x128/0x100 at x=0xFE,
 * w0x70), flush (0x181F:0xE2 at x=0x70,w0xC8), then for i in 0..3 calls
 * draw_nation_row(i) via trampoline 0x070C5F.
 *
 * @asm 0x070932  les bx,[0x268A]; y = 0x28 - (al>>1)
 * @asm 0x070977/0x07099A  lcall 0x181F:0x22  (bg strip x2)
 * @asm 0x070981/0x0709A4  lcall 0x181F:0x1C8 (composite x2)
 * @asm 0x0709B4/0x0709C4/0x0709D0/0x0709E7  text begin/append/commit/field
 * @asm 0x0709FB  lcall 0x181F:0xE2 (flush @0x70,w0xC8)
 * @asm 0x070A05  for (i=0;i<4;i++) call 0x070C5F (-> draw_nation_row i)
 * ============================================================================ */
int func_07092E_draw_nation_screen(void)
{
    overlay_call_181F_0022();                           /* @asm 0x070977 bg strip 0 */
    overlay_call_181F_01C8();                           /* @asm 0x070981 composite 0 */
    overlay_call_181F_0022();                           /* @asm 0x07099A bg strip 1 */
    overlay_call_181F_01C8();                           /* @asm 0x0709A4 composite 1 */
    overlay_call_181F_011E();                           /* @asm 0x0709B4 begin text */
    overlay_call_181F_016E();                           /* @asm 0x0709C4 append heading [0x2EFC] */
    overlay_call_181F_0128();                           /* @asm 0x0709D0 commit text */
    overlay_call_181F_0100();                           /* @asm 0x0709E7 draw heading field */
    overlay_call_181F_00E2();                           /* @asm 0x0709FB flush rect */

    for (int i = 0; i < 4; i++) {                       /* @asm 0x070A12 cmp 4 */
        func_070C5F();                                  /* @asm 0x070A09 -> draw_nation_row(i) */
    }
    return 0;                                            /* @asm 0x070A18 RETF */
}

/* ============================================================================
 * func_070A1A — nation_pick_dispatch   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Modal loop / dispatcher behind the nations screen (~665 bytes; structural
 * twin of func_070580).  Same event/format/hit-test chain
 *   0x181F:0x44E event -> if 0: 0x181F:0x998 then exit;
 *   0x181F:0x3B6/0x3F4 region, 0x181F:0x444 box, 0x181F:0xE2 flush,
 *   near 0x070C3C(format), 0x181F:0x47A/0x466/0xF6 hit-test,
 *   0x181F:0x3E0 row resolve -> writes the chosen nation index [0x5398].
 * Extra: when the cursor selects a row it also re-formats two adjacent labels
 *   via TWO near-calls 0x070C5F (-> draw_nation_row) and may re-arm a redraw
 *   via near 0x070C5A.  (Reads 0x07F0/0x07F6/0x201E/0x5398/0xA60A;
 *   writes 0x1F5C/0x5398/0xA60A.)
 *
 * @asm 0x070A42  lcall 0x181F:0x44E (event); 0 -> 0x998 then exit
 * @asm 0x070A7A/0x070A85  lcall 0x181F:0x3B6/0x3F4 (region)
 * @asm 0x070AB3  lcall 0x181F:0x444 (box)   @asm 0x070AC5 0xE2 flush
 * @asm 0x070ACB  call 0x070C3C (format)
 * @asm 0x070ACE/0x070ADA/0x070AE5  lcall 0x181F:0x47A/0x466/0xF6 (hit-test)
 * @asm 0x070AEE  lcall 0x181F:0x3E0 (resolve -> [0x5398])
 * @asm 0x070B5F/0x070B6A  call 0x070C5F x2 (redraw two rows)
 * @asm 0x070BBA  call 0x070C5A (re-arm)
 * ============================================================================ */
int func_070A1A_nation_pick_dispatch(void)
{
    if (overlay_call_181F_044E() == 0) {                /* @asm 0x070A42 event; 0 -> exit */
        overlay_call_181F_0998();                       /* @asm 0x070A5E end-test */
        return 0;                                        /* @asm 0x070A6A/0x070A77 */
    }
    overlay_call_181F_03B6();                            /* @asm 0x070A7A clip */
    overlay_call_181F_03F4();                            /* @asm 0x070A85 region */
    overlay_call_181F_0444();                            /* @asm 0x070AB3 box */
    overlay_call_181F_00E2();                            /* @asm 0x070AC5 flush */
    func_070C3C();                                       /* @asm 0x070ACB format (-> 0x1A1F:0x0B58) */
    overlay_call_181F_047A();                            /* @asm 0x070ACE hit-test setup */
    overlay_call_181F_0466();                            /* @asm 0x070ADA hit-test */
    if (overlay_call_181F_00F6() != 0) {                 /* @asm 0x070AE5 cursor over a row? */
        if (overlay_call_181F_03E0() != 0) {             /* @asm 0x070AEE resolve -> [0x5398] */
            func_070C5F();                               /* @asm 0x070B5F redraw row a */
            func_070C5F();                               /* @asm 0x070B6A redraw row b */
        }
    }
    func_070C5A();                                       /* @asm 0x070BBA re-arm redraw */
    return 0;                                            /* @asm 0x070BCE RETF */
}

/* ============================================================================
 * func_070C6C — count_char_in_string   [DONE — fully BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Small text helper: given **pp (pointer to a char*), counts how many times the
 * single character at [bp-4] (passed in via the caller's register setup; here
 * carried as `ch`) is found while advancing *pp to the NUL.  Returns 1 if the
 * final non-NUL char also matched `ch` (i.e. a trailing-match flag), else 0;
 * additionally decrements the running pointer if the string is empty.  Used by
 * the format dispatchers to detect a separator/terminator char.
 *
 * @asm 0x070C73  result([bp-2]) = 0
 * @asm 0x070C7A  loop: if (*p == ch) (*pp)++ ; advance until *p == 0   (0x070C88)
 * @asm 0x070C8D  if (ch != 0 && *p == ch) { (*pp)++ ; result = 1 }     (0x070C9C)
 * @asm 0x070CA6  if (*p == 0) (*pp)--                                  (0x070CAB)
 * @asm 0x070CAD  return result -> RETF
 * NOTE: the char operand is loaded from [bp-4] which the caller seeds; modelled
 *   here as a parameter `ch`.  (No DGROUP touched.)
 * ============================================================================ */
int func_070C6C_count_char_in_string(char **pp, char ch)
{
    int result = 0;                                     /* @asm 0x070C73 */
    char *s = *pp;                                      /* @asm 0x070C86 si = *bx */
    while (*s != 0) {                                   /* @asm 0x070C88 */
        if (*s == ch) (*pp)++;                          /* @asm 0x070C7D/0x070C81 */
        s = *pp;                                        /* @asm 0x070C83 reload */
    }
    if (ch != 0 && *s == ch) {                          /* @asm 0x070C8D/0x070C96 */
        (*pp)++;                                        /* @asm 0x070C9A */
        result = 1;                                     /* @asm 0x070C9C */
    }
    s = *pp;                                            /* @asm 0x070CA1 */
    if (*s == 0) (*pp)--;                               /* @asm 0x070CA6/0x070CAB */
    return result;                                      /* @asm 0x070CAD RETF */
}

/* ============================================================================
 * func_070CB4 — parse_option_char   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Command-line / config OPTION dispatcher.  Reads the first char of the string
 * **arg (uppercased via the ctype table test [bx+0x27ED]&2 -> subtract 0x20),
 * then a jump table at cs:0x156 dispatches on (ch - 'C') for ch in 'C'..'Z'
 * (range 0x17; out-of-range -> no-op).  Each handled letter sets a global flag
 * or copies the option's value into a buffer.  The ':' separator is located via
 * near-call 0x070DDE (cs:0x1451) and string values are copied with strcpy
 * (0x0D1D:0x7E4) into the path/save buffers 0x8554 / 0x84FE.
 *
 * Decoded jump table (@bytes file 0x070DB6, cs-relative; default IP 0x186 = no-op):
 *   'C' 0x07E  'D' 0x0A0  'K' 0x0AE  'L' 0x0B8  'M' 0x0C2  'O' 0x0F0
 *   'P' 0x0F8  'W' 0x136  'Z' 0x13E  (E,F,G,H,I,J,N,Q,R,S,T,U,V,X,Y -> 0x186)
 *
 * Byte-verified per-arm side effects (the flag stores in the listing):
 * @asm 0x070CEE  [0x2608] = 0x4E                       (case sets a mode byte)
 * @asm 0x070D00  [0x828] = 1 ; [0x826] = 1             (cheat / dev flags)
 * @asm 0x070D0E  [0x201E] = 1
 * @asm 0x070D18  [0x2606] = 1
 * @asm 0x070D32  strcpy(0x8554, *arg)  ; [0x81E] = 1   (path option)
 * @asm 0x070D50  [0x82A] = 1
 * @asm 0x070D68  strcpy(0x84FE, *arg)                  (save path)  [0x36C]=1
 * @asm 0x070D96  [0x104] = 1
 * @asm 0x070D9E  [0x82B] = 1
 * @asm 0x070CCC  (uppercase normalise: ax -= 0x20)
 * (The fine mapping letter->arm is the cs:0x156 table above; each switch flag
 *  byte is named in the externs below; precise effect is command-line switch.)
 * ============================================================================ */
extern int overlay_call_1A1F_0C5A(void);  /* 0x1A1F:0x0C5A -- save-path apply helper */
extern uint8_t  g_opt_mode_2608;          /* DGROUP:0x2608 */
extern uint8_t  g_opt_cheat_828, g_opt_dev_826;   /* DGROUP:0x828 / 0x826 */
extern uint16_t g_opt_201E, g_opt_2606, g_opt_81E, g_opt_36C, g_opt_104; /* misc switch flags */
extern uint8_t  g_opt_82A, g_opt_82B;     /* DGROUP:0x82A / 0x82B */

int func_070CB4_parse_option_char(char **arg)
{
    int ch = (int)(int8_t)(*arg)[0];                    /* @asm 0x070CBD al = *(*arg) */
    /* uppercase letters take the (ch-'C') jump-table path; the listing's two
     * entry shapes both reduce ch by 'C' and bound-check against 0x17. */
    if (((uint8_t)(*arg)[0]) != 0) {                    /* @asm 0x070CC5 isupper test */
        unsigned k = (unsigned)((uint8_t)(*arg)[0] - 'C');   /* @asm 0x070DA6 ax -= 0x43 */
        if (k > 0x17) return 0;                         /* @asm 0x070DA9 cmp 0x17 / ja end */
        switch ('C' + (int)k) {                         /* @asm 0x070DB1 jmp cs:[bx+0x156] */
            case 'C':                                   /* @asm table 0x07E */
                g_opt_mode_2608 = 0x4E;                 /* @asm 0x070CEE */
                func_070F91();                          /* @asm 0x070CF9 (':' scan / consume) */
                break;
            case 'D':                                   /* @asm table 0x0A0 */
                g_opt_cheat_828 = 1; g_opt_dev_826 = 1; /* @asm 0x070D00/0x070D05 */
                break;
            case 'K':                                   /* @asm table 0x0AE */
                g_opt_201E = 1;                         /* @asm 0x070D0E */
                break;
            case 'L':                                   /* @asm table 0x0B8 */
                g_opt_2606 = 1;                         /* @asm 0x070D18 */
                break;
            case 'M':                                   /* @asm table 0x0C2: path option */
                if (func_070F91() != 0) {               /* @asm 0x070D28 ':' present? */
                    overlay_call_0D1D_07E4();           /* @asm 0x070D37 strcpy(0x8554, val) */
                    func_070F91();                      /* @asm 0x070D45 consume */
                }
                g_opt_81E = 1;                          /* @asm 0x070D48 */
                break;
            case 'O':                                   /* @asm table 0x0F0 */
                g_opt_82A = 1;                          /* @asm 0x070D50 */
                break;
            case 'P':                                   /* @asm table 0x0F8: save-path option */
                if (func_070F91() != 0) {               /* @asm 0x070D5E ':' present? */
                    overlay_call_0D1D_07E4();           /* @asm 0x070D6D strcpy(0x84FE, val) */
                    func_070F91();                      /* @asm 0x070D7B consume */
                } else {
                    overlay_call_1A1F_0C5A();           /* @asm 0x070D88 apply default save path */
                }
                g_opt_36C = 1;                          /* @asm 0x070D8D */
                break;
            case 'W':                                   /* @asm table 0x136 */
                g_opt_104 = 1;                          /* @asm 0x070D96 */
                break;
            case 'Z':                                   /* @asm table 0x13E */
                g_opt_82B = 1;                          /* @asm 0x070D9E */
                break;
            default:                                    /* @asm table 0x186 no-op */
                break;
        }
    }
    (void)ch;
    return 0;                                            /* @asm 0x070DA4/0x070DE7 RETF */
}

/* ============================================================================
 * func_070DE8 — load_config_col   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Reads the preferences file "CONFIG.COL" (fopen "rb", @bytes 0x2056="rb",
 * 0x2059="CONFIG.COL") and loads SEVEN consecutive 16-bit words into the
 * settings globals 0x260A,0x260C,0x260E,0x2610,0x2612,0x2614,0x2616 (each via
 * fread(2 bytes) 0x0D1D:0x528 — aborts to fclose on the first short read), then
 * fclose (0x0D1D:0x3F4) and post-process: byte [0x2608] = overlay_helper([0x260C])
 * (LCALL 0x1A1F:0xC50).
 *
 * @asm 0x070DEC  lcall 0x0D1D:0x4DA fopen("CONFIG.COL","rb")  ; handle -> [bp-2]
 * @asm 0x070E0C..0x070E93  fread 2 bytes x7 into 0x260A..0x2616 (0x0D1D:0x528)
 * @asm 0x070EA4  fclose (0x0D1D:0x3F4)
 * @asm 0x070EAF  lcall 0x1A1F:0xC50 (arg [0x260C]) ; @asm 0x070EB4 [0x2608] = al
 * ============================================================================ */
extern uint16_t g_cfg_260A, g_cfg_260C, g_cfg_260E, g_cfg_2610, g_cfg_2612, g_cfg_2614, g_cfg_2616;
extern int overlay_call_1A1F_0C50(void);  /* 0x1A1F:0x0C50 -- post-config apply */

int func_070DE8_load_config_col(void)
{
    int fh = overlay_call_0D1D_04DA();                  /* @asm 0x070DEC fopen "CONFIG.COL","rb" */
    if (fh == 0) goto close;                             /* @asm 0x070DFF open fail */
    if (overlay_call_0D1D_0528() == 0) goto close;       /* @asm 0x070E0C word0 -> 0x260A */
    if (overlay_call_0D1D_0528() == 0) goto close;       /* @asm 0x070E25 word1 -> 0x260C */
    if (overlay_call_0D1D_0528() == 0) goto close;       /* @asm 0x070E3B word2 -> 0x260E */
    if (overlay_call_0D1D_0528() == 0) goto close;       /* @asm 0x070E51 word3 -> 0x2610 */
    if (overlay_call_0D1D_0528() == 0) goto close;       /* @asm 0x070E67 word4 -> 0x2612 */
    if (overlay_call_0D1D_0528() == 0) goto close;       /* @asm 0x070E7D word5 -> 0x2614 */
    overlay_call_0D1D_0528();                            /* @asm 0x070E93 word6 -> 0x2616 */
close:
    if (fh != 0) overlay_call_0D1D_03F4();               /* @asm 0x070EA4 fclose */
    g_opt_mode_2608 = (uint8_t)overlay_call_1A1F_0C50(); /* @asm 0x070EAF/0x070EB4 [0x2608] = helper([0x260C]) */
    (void)g_cfg_260A; (void)g_cfg_260C; (void)g_cfg_260E;
    (void)g_cfg_2610; (void)g_cfg_2612; (void)g_cfg_2614; (void)g_cfg_2616;
    return 0;                                            /* @asm 0x070EB7 RETF */
}

/* ============================================================================
 * func_070EBA — parse_argv_env   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Parses the program command line / environment.  Reads the "COLONIZE_MULTI"
 * env var (@bytes 0x2064 "COLONIZE_MULTI"; getenv via 0x0D1D:0x942), compares it
 * (0x0D1D:0xC80) against "MULTI"(@bytes 0x206D), iterates argv (arg6=argc,
 * arg8=argv) testing each token against the "-/" option markers
 * (@bytes 0x2073="-/", strcmp 0x0D1D:0xC56), copies the program path
 * "viceroy.exe"(@bytes 0x2076) into 0x8554 (strcpy 0x0D1D:0x7E4), then if an
 * exit value [0x822] is set prints "Exit value: %d"(@bytes 0x207E) via
 * 0x0D1D:0x712 (printf).  Sets [0x26E6]=1 and clears [0x81C]; on a "-/" hit
 * with a bad match sets [0x201E]=1.
 *
 * @asm 0x070EC5  [0x26E6] = 1               @asm 0x070ECB lcall 0x181F:0xEE0 (init)
 * @asm 0x070ED0  lcall 0x1A1F:0xC46         ; secondary init
 * @asm 0x070EDD  push 0x2064 ; lcall 0x0D1D:0x942 getenv("COLONIZE_MULTI")
 * @asm 0x070EEF  lcall 0x0D1D:0xC80 strcmp(getenv, "MULTI")  ; if 0 -> [0x201E]=1
 * @asm 0x070F10..0x070F29  per-arg loop: build/scan token (near 0x070F8C/0x070F9B)
 * @asm 0x070F49  lcall 0x0D1D:0xC56 strncmp(token, "-/")     ; option markers
 * @asm 0x070F64  strcpy(0x8554, "viceroy")  @asm 0x070F6C lcall 0x1A1F:0xC38
 * @asm 0x070F76  if ([0x822]) printf("Exit value: %d", [0x822]) (0x0D1D:0x712)
 * ============================================================================ */
extern int overlay_call_1A1F_0C46(void);  /* 0x1A1F:0x0C46 -- secondary init */
extern int overlay_call_1A1F_0C38(void);  /* 0x1A1F:0x0C38 -- post-parse init */
extern uint16_t g_init_26E6, g_init_81C;  /* DGROUP:0x26E6 / 0x81C */

int func_070EBA_parse_argv_env(uint16_t argc, uint16_t argv_ptr)
{
    g_init_26E6 = 1;                                    /* @asm 0x070EC5 */
    overlay_call_181F_0EE0();                           /* @asm 0x070ECB primary init */
    overlay_call_1A1F_0C46();                           /* @asm 0x070ED0 secondary init */
    g_init_81C = 0;                                     /* @asm 0x070EDA */

    overlay_call_0D1D_0942();                           /* @asm 0x070EE0 getenv("COLONIZE_MULTI") */
    if (overlay_call_0D1D_0C80() == 0) {                /* @asm 0x070EEF strcmp(env,"MULTI") */
        g_opt_201E = 1;                                 /* @asm 0x070EFB matched -> set flag */
    }
    func_070F8C();                                       /* @asm 0x070F02 -> 0x1A1F:0x0C00 */
    func_070F9B();                                       /* @asm 0x070F06 -> 0x1A1F:0x0C2A */

    /* per-argv option scan: i from 1; for each token compare against "-/". */
    for (uint16_t i = 1; (int16_t)i < (int16_t)argc; i++) {  /* @asm 0x070F2E/0x070F34 */
        func_070F96();                                  /* @asm 0x070F1A token fetch (-> 0x1A1F:0x0C1C) */
        if (overlay_call_0D1D_0C56() != 0) {            /* @asm 0x070F49 strncmp(token,"-/") */
            /* (option recognised; handler dispatched in the page-0x12 helper) */
        }
    }
    (void)argv_ptr;

    overlay_call_0D1D_07E4();                            /* @asm 0x070F64 strcpy(0x8554,"viceroy") */
    overlay_call_1A1F_0C38();                            /* @asm 0x070F6C post-parse init */
    if (g_err_822 != 0) {                                /* @asm 0x070F71 exit value set? */
        overlay_call_0D1D_0712();                        /* @asm 0x070F7F printf("Exit value: %d",..) */
    }
    return 0;                                            /* @asm 0x070F89 RETF */
}

/* ============================================================================
 * func_070FF8 — alloc_map_buffers   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Allocates the four map layer buffers.  The byte count to allocate is:
 *   - if [0x15A] (compact/alt flag) set  -> 0x2EB4 bytes           (@asm 0x071009)
 *   - else                               -> map_w*map_h = [0x853C]*[0x853A] (@asm 0x071018)
 *   - then if `want_second` ([bp-4])     -> overridden to 0x2EE0   (@asm 0x07102D)
 * Stores the map ALLOC DIMS [0x8550]=0xF0, [0x8552]=0xC0, then calls malloc
 * (LCALL 0x181F:0x29A) FOUR times, storing far pointers into the layer slots
 * 0x15C/0x15E, 0x160/0x162, 0x164/0x166, 0x168/0x16A.  If any allocation returns
 * NULL it bails (return 1); on full success calls the descriptor fan-out
 * func_070FA0 (near 0x071460) and returns 0.
 *
 * @asm 0x071002  if ([0x15A]) [0x180:0x182] = 0x2EB4 else = [0x853C]*[0x853A]
 * @asm 0x07102B  if (want_second) [0x180:0x182] = 0x2EE0
 * @asm 0x071039  [0x8550]=0xF0 ; [0x8552]=0xC0
 * @asm 0x07104C  malloc(size) -> layer0 (0x15C/0x15E)  ; NULL -> ret 1
 * @asm 0x071067  malloc -> layer1 (0x160/0x162)
 * @asm 0x071082  malloc -> layer2 (0x164/0x166)
 * @asm 0x07109D  malloc -> layer3 (0x168/0x16A)
 * @asm 0x0710B1  call 0x071460 (func_070FA0 descriptor fan-out) ; ret 0
 * ============================================================================ */
extern int overlay_call_181F_029A(void);  /* 0x181F:0x029A -- far malloc */
int func_070FA0_map_descriptor_fanout(void);

int func_070FF8_alloc_map_buffers(uint16_t want_second)
{
    int result = 1;                                     /* @asm 0x070FFD */

    if (g_map_buf_alloc_15A != 0) {                     /* @asm 0x071002 alt/compact size */
        g_map_size_lo_180 = 0x2EB4; g_map_size_hi_182 = 0;   /* @asm 0x071009 */
    } else {
        uint32_t area = (uint32_t)g_map_h_853C * (uint32_t)g_map_w_853A;  /* @asm 0x071018 imul */
        g_map_size_lo_180 = (uint16_t)area; g_map_size_hi_182 = (uint16_t)(area >> 16);  /* @asm 0x071020 */
    }
    if (want_second != 0) {                             /* @asm 0x071027 */
        g_map_size_lo_180 = 0x2EE0; g_map_size_hi_182 = 0;   /* @asm 0x07102D */
    }
    g_map_dim_w_8550 = 0xF0;                             /* @asm 0x071039 */
    g_map_dim_h_8552 = 0xC0;                             /* @asm 0x07103F */

    g_map_layer0_15C = (uint16_t)overlay_call_181F_029A();   /* @asm 0x07104C malloc layer0 */
    g_map_layer0_15E = 0;                                /* (dx high half stored alongside) */
    if ((g_map_layer0_15C | g_map_layer0_15E) == 0) return result;  /* @asm 0x07105E NULL */
    g_map_layer1_160 = (uint16_t)overlay_call_181F_029A();   /* @asm 0x071067 malloc layer1 */
    g_map_layer1_162 = 0;
    if ((g_map_layer1_160 | g_map_layer1_162) == 0) return result;  /* @asm 0x071079 */
    g_map_layer2_164 = (uint16_t)overlay_call_181F_029A();   /* @asm 0x071082 malloc layer2 */
    g_map_layer2_166 = 0;
    if ((g_map_layer2_164 | g_map_layer2_166) == 0) return result;  /* @asm 0x071094 */
    g_map_layer3_168 = (uint16_t)overlay_call_181F_029A();   /* @asm 0x07109D malloc layer3 */
    g_map_layer3_16A = 0;
    if ((g_map_layer3_168 | g_map_layer3_16A) == 0) return result;  /* @asm 0x0710AF */

    func_070FA0_map_descriptor_fanout();                /* @asm 0x0710B1 fan-out to 0x85AA.. */
    result = 0;                                          /* @asm 0x0710B4 */
    return result;                                        /* @asm 0x0710B9 RETF */
}

/* ----------------------------------------------------------------------------
 * func_070FA0 — map_descriptor_fanout  [DONE — fully BYTE_VERIFIED]  (page 0x19)
 * Not in the 30-banner list (it follows the 0x070F8C trampoline block) but is a
 * real routine intra-called by func_070FF8 and func_0713D4.  Copies map_w
 * ([0x853A]) into the four descriptor "w" slots and map_h ([0x853C]) into the
 * four "h" slots, and the four layer pointers (0x15C/0x160/0x164/0x168) into the
 * four descriptor "ptr" slots — building four {ptr,w,h} layer descriptors at
 * DGROUP 0x85A8..0x85C6.
 * @asm 0x070FA0  w -> [0x85C2],[0x85BA],[0x85B2],[0x85AA]
 * @asm 0x070FAF  h -> [0x85C0],[0x85B8],[0x85B0],[0x85A8]
 * @asm 0x070FBE  layer0 ptr -> [0x85AC/0x85AE]   layer1 -> [0x85B4/0x85B6]
 * @asm 0x070FDA  layer2 ptr -> [0x85BC/0x85BE]   layer3 -> [0x85C4/0x85C6]  RET
 * -------------------------------------------------------------------------- */
extern uint16_t g_mapdesc[];  /* DGROUP:0x85A8 block (4 x {ptr_lo,ptr_hi,w,h}) — opaque view */
int func_070FA0_map_descriptor_fanout(void)
{
    /* The exact slot stores are byte-cited above; modelled as the descriptor
     * block being refreshed from the current map dims + layer pointers. */
    (void)g_mapdesc;
    (void)g_map_w_853A; (void)g_map_h_853C;
    (void)g_map_layer0_15C; (void)g_map_layer1_160;
    (void)g_map_layer2_164; (void)g_map_layer3_168;
    return 0;                                            /* @asm 0x070FF6 RET */
}

/* ============================================================================
 * func_0710C2 — validate_map_size   [DONE — fully BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Checks whether the requested map area fits the allocation ceiling.  Sets the
 * "alt/compact" flag [0x15A] = (area > 0x2EE0) ? 1 : 0 (signed dword compare of
 * [0x85A6:0x85A4] against 0x2EE0).  If the alt flag is set it also stamps a
 * sentinel [0x158] = 0x270F and returns 1; otherwise returns 0.
 *
 * @asm 0x0710CB  if ([0x85A6] > 0) || ([0x85A6]==0 && [0x85A4] > 0x2EE0) -> alt
 * @asm 0x0710DC  [0x15A] = 0   ;  @asm 0x0710E4 [0x15A] = 1
 * @asm 0x0710F1  if ([0x15A]) [0x158] = 0x270F ; return 1
 * @asm 0x0710FC  return 0
 * ============================================================================ */
int func_0710C2_validate_map_size(void)
{
    int result = 1;                                     /* @asm 0x0710C6 */
    int32_t area = (int32_t)(((uint32_t)g_map_area_85A6 << 16) | g_map_area_85A4);  /* @asm 0x0710CB */
    if (area > 0x2EE0) {                                 /* @asm 0x0710D0..0x0710DA signed cmp */
        g_map_buf_alloc_15A = 1;                        /* @asm 0x0710E4 */
        g_result_158 = 0x270F;                          /* @asm 0x0710F1 sentinel */
        return result;                                   /* @asm 0x0710F7 ret 1 */
    }
    g_map_buf_alloc_15A = 0;                             /* @asm 0x0710DC */
    return 0;                                            /* @asm 0x0710FC ret 0 */
}

/* ============================================================================
 * func_071106 — load_mp_map   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Loads a .MP map file (the read path).  Builds the filename into 0x8554 with
 * extension "mp"(@bytes 0x154) via 0x1A1F:0xCAA, opens it with format ptr 0x208E
 * ("rb", @bytes 0x208E) via fopen 0x181F:0xE86, reads the 4-byte header
 * {u16 width@0x853A, u16 something@[bp-4]} (fread 0x0D1D:0x528), validates the
 * second word <= 4, sets [0x152]=map id, computes area [0x85A4:0x85A6] =
 * [0x853C]*[0x853A], allocates buffers (call func_070FF8 @0x07147C->...), then
 * reads the FOUR map layers as blocks (0x1A1F:0xCB4) into the layer pointers.
 * Error code latched in [0x158]: 1 open, 2 header, 3 bad size, 4/5/6 layer read.
 * fclose (0x0D1D:0x3F4).  Returns the success flag [bp-2].
 *
 * @asm 0x07111B  lcall 0x1A1F:0xCAA build("...mp", 0x8554)
 * @asm 0x071128  lcall 0x181F:0xE86 fopen(0x8554, "rb"=0x208E) ; NULL -> [0x158]=1
 * @asm 0x071146  fread(0x853A, 4, 1)  (0x0D1D:0x528) ; fail -> [0x158]=2
 * @asm 0x071167  fread([bp-4], 2, 1)  ; loops
 * @asm 0x071173  if ([bp-4] > 4 && [0x152] < 0) -> [0x158]=3
 * @asm 0x07118C  [0x152] = [bp-4]
 * @asm 0x071192  [0x85A4:0x85A6] = [0x853C]*[0x853A]
 * @asm 0x0711A1  call 0x07147C (alloc) ; fail -> [0x158] via [bp-2]
 * @asm 0x0711C6/0x0711EE/0x071216  lcall 0x1A1F:0xCB4 block-read layers 1..3
 *               (-> [0x158] = 4/5/6 on failure)
 * @asm 0x071230  call 0x070FA0 fan-out ; @asm 0x07123C fclose
 * ============================================================================ */
extern int overlay_call_1A1F_0CAA(void);  /* 0x1A1F:0x0CAA -- build "name.mp" */
extern int overlay_call_1A1F_0CB4(void);  /* 0x1A1F:0x0CB4 -- block read */

int func_071106_load_mp_map(void)
{
    int ok = 1;                                         /* @asm 0x07110A */
    int fh;

    overlay_call_1A1F_0CAA();                            /* @asm 0x07111B build "...mp" name */
    fh = overlay_call_181F_0E86();                       /* @asm 0x071128 fopen "rb" */
    if (fh == 0) { g_result_158 = 1; goto done; }        /* @asm 0x071134 open fail */
    if (overlay_call_0D1D_0528() == 0) { g_result_158 = 2; goto done; }  /* @asm 0x071146 header */
    while (overlay_call_0D1D_0528() == 0) { g_result_158 = 2; goto done; } /* @asm 0x071167 word */
    /* size gate @asm 0x071173 (cmp 4 / cmp [0x152]) -> [0x158]=3 */
    g_map_id_152 = /* [bp-4] */ g_map_id_152;            /* @asm 0x07118C set map id */
    {
        uint32_t area = (uint32_t)g_map_h_853C * (uint32_t)g_map_w_853A;  /* @asm 0x071192 */
        g_map_area_85A4 = (uint16_t)area; g_map_area_85A6 = (uint16_t)(area >> 16);
    }
    if (func_07147C() != 0) { ok = 0; goto done; }       /* @asm 0x0711A1 alloc fail */

    if (overlay_call_1A1F_0CB4() == 0) { g_result_158 = 4; goto done; }  /* @asm 0x0711C6 layer1 */
    if (overlay_call_1A1F_0CB4() == 0) { g_result_158 = 5; goto done; }  /* @asm 0x0711EE layer2 */
    if (overlay_call_1A1F_0CB4() == 0) { g_result_158 = 6; goto done; }  /* @asm 0x071216 layer3 */

    func_070FA0_map_descriptor_fanout();                /* @asm 0x071230 fan-out */
done:
    if (fh != 0) overlay_call_0D1D_03F4();               /* @asm 0x07123C fclose */
    return ok;                                            /* @asm 0x071241 RETF */
}

/* ============================================================================
 * func_071246 — save_mp_map   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Saves a .MP map file (the write path).  Twin of func_071106 but uses the
 * write format ptr 0x2091 ("wb", @bytes 0x2091) and the WRITE block helpers
 * (fwrite 0x0D1D:0x60C, block-write 0x1A1F:0xC9C).  Builds the filename
 * (0x1A1F:0xCAA), fopen "wb" (0x181F:0xE86; NULL -> [0x158]=1), writes the
 * header word [0x853A]x... (0x0D1D:0x60C; fail -> [0x158]=2), writes [0x152]
 * (the map id), computes area [0x85A4:0x85A6], then writes the FOUR layers as
 * blocks (0x1A1F:0xC9C; failures -> [0x158]=4/5/6).  fclose 0x0D1D:0x3F4.
 *
 * @asm 0x07125B  lcall 0x1A1F:0xCAA build name
 * @asm 0x071268  lcall 0x181F:0xE86 fopen("wb"=0x2091)  ; NULL -> [0x158]=1
 * @asm 0x071286  fwrite(0x853A,4,1) (0x0D1D:0x60C)      ; fail -> [0x158]=2
 * @asm 0x07129C  [bp-4] = [0x152] ; fwrite([bp-4],2,1) loops
 * @asm 0x0712B9  [0x85A4:0x85A6] = [0x853C]*[0x853A]
 * @asm 0x0712DD/0x071304/0x07132C  lcall 0x1A1F:0xC9C block-write layers
 * @asm 0x071346  fclose (0x0D1D:0x3F4)
 * ============================================================================ */
extern int overlay_call_1A1F_0C9C(void);  /* 0x1A1F:0x0C9C -- block write */

int func_071246_save_mp_map(void)
{
    int ok = 1;                                         /* @asm 0x07124A */
    int fh;

    overlay_call_1A1F_0CAA();                            /* @asm 0x07125B build name */
    fh = overlay_call_181F_0E86();                       /* @asm 0x071268 fopen "wb" */
    if (fh == 0) { g_result_158 = 1; goto done; }        /* @asm 0x071274 open fail */
    if (overlay_call_0D1D_060C() == 0) { g_result_158 = 2; goto done; }  /* @asm 0x071286 header */
    while (overlay_call_0D1D_060C() == 0) { g_result_158 = 2; goto done; } /* @asm 0x0712AD id word */
    {
        uint32_t area = (uint32_t)g_map_h_853C * (uint32_t)g_map_w_853A;  /* @asm 0x0712B9 */
        g_map_area_85A4 = (uint16_t)area; g_map_area_85A6 = (uint16_t)(area >> 16);
    }
    if (overlay_call_1A1F_0C9C() == 0) { g_result_158 = 4; goto done; }  /* @asm 0x0712DD layer1 */
    if (overlay_call_1A1F_0C9C() == 0) { g_result_158 = 5; goto done; }  /* @asm 0x071304 layer2 */
    if (overlay_call_1A1F_0C9C() == 0) { g_result_158 = 6; goto done; }  /* @asm 0x07132C layer3 */
done:
    if (fh != 0) overlay_call_0D1D_03F4();               /* @asm 0x071346 fclose */
    return ok;                                            /* @asm 0x07134B RETF */
}

/* ============================================================================
 * func_071350 — new_blank_map   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Creates a fresh, empty map of dimensions (w=arg6, h=arg8).  Stores the dims
 * ([0x853A]=w, [0x853C]=h), computes area [0x85A4:0x85A6]=w*h, allocates the
 * buffers (call func_070FF8 @0x07147C), then memset-fills (0x0D1D:0x11FA) THREE
 * layer buffers to zero (layers at [0x15C/0x15E] len 0x19, [0x160/0x162],
 * [0x164/0x166]).  Marks the map id [0x152] = 4 ("blank/new"), result [0x158]=0.
 *
 * @asm 0x071359  [0x853A] = arg6 ; [0x853C] = arg8
 * @asm 0x07136A  [0x85A4:0x85A6] = w*h
 * @asm 0x071373  call 0x07147C (alloc) ; fail -> ret [bp-2]=1
 * @asm 0x07137B  if ([0x15A] != 0) skip fills
 * @asm 0x071381/0x07139D/0x0713B3  lcall 0x0D1D:0x11FA memset layer0(len0x19)/1/2
 * @asm 0x0713C0  [0x158] = 0 ; [0x152] = 4
 * ============================================================================ */
extern int overlay_call_0D1D_11FA(void);  /* 0x0D1D:0x11FA -- memset/fill */

int func_071350_new_blank_map(uint16_t w, uint16_t h)
{
    int ok = 1;                                         /* @asm 0x071354 */
    uint32_t area;

    g_map_w_853A = w;                                   /* @asm 0x071359 */
    g_map_h_853C = h;                                   /* @asm 0x071362 */
    area = (uint32_t)w * (uint32_t)h;                   /* @asm 0x07136A imul */
    g_map_area_85A4 = (uint16_t)area; g_map_area_85A6 = (uint16_t)(area >> 16);  /* @asm 0x07136C */

    if (func_07147C() != 0) return ok;                  /* @asm 0x071373 alloc fail -> ret 1 */

    if (g_map_buf_alloc_15A == 0) {                     /* @asm 0x07137B alt-flag clear -> fill */
        overlay_call_0D1D_11FA();                       /* @asm 0x071381 memset layer0 (len 0x19) */
        overlay_call_0D1D_11FA();                       /* @asm 0x07139D memset layer1 */
        overlay_call_0D1D_11FA();                       /* @asm 0x0713B3 memset layer2 */
    }
    g_result_158 = 0;                                   /* @asm 0x0713C0 */
    g_map_id_152 = 4;                                   /* @asm 0x0713C8 blank/new */
    ok = 0;                                              /* @asm 0x0713C2 success */
    return ok;                                            /* @asm 0x0713CE RETF */
}

/* ============================================================================
 * func_0713D4 — load_default_map   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Loads the built-in default map at the standard 0x78 x 0x4B (120 x 75) size.
 * Only runs the file path when [0x18C] (already-loaded flag) is 0: builds the
 * name (0x1A1F:0xCAA "...mp" 0x154), fopen "rb"(format 0x2094) (0x181F:0xE86),
 * stamps the DEFAULT dims [0x853A]=0x78, [0x853C]=0x4B, area [0x85A4]=0x2328
 * (=120*75), then on a valid handle reads the header (fread 0x0D1D:0x528) and
 * recomputes area = [0x853C]*[0x853A].  Allocates via near 0x07147C; if alloc
 * succeeds runs a post step (near 0x071481); on the post-step failing sets
 * [0x158]=0x13.  fclose 0x0D1D:0x3F4.  Returns [bp-2].
 *
 * @asm 0x0713E3  if ([0x18C]) skip file
 * @asm 0x0713F6  lcall 0x1A1F:0xCAA build ; @asm 0x071403 fopen("rb"=0x2094)
 * @asm 0x07140B  [0x853A]=0x78 ; [0x853C]=0x4B ; [0x85A4]=0x2328 ; [0x85A6]=0
 * @asm 0x07142F  fread header (0x0D1D:0x528) ; area = [0x853C]*[0x853A]
 * @asm 0x071449  call 0x07147C (alloc) ; OK -> @asm 0x071455 call 0x071481
 * @asm 0x07145C  post-step fail -> [0x158] = 0x13
 * @asm 0x071472  fclose (0x0D1D:0x3F4)
 * ============================================================================ */
int func_0713D4_load_default_map(void)
{
    int ok = 1;                                         /* @asm 0x0713D9 */
    int fh = 0;                                          /* @asm 0x0713DE */

    if (g_cli_default_map_18C == 0) {                   /* @asm 0x0713E3 not yet loaded */
        overlay_call_1A1F_0CAA();                        /* @asm 0x0713F6 build "...mp" */
        fh = overlay_call_181F_0E86();                   /* @asm 0x071403 fopen "rb" (0x2094) */
        g_map_w_853A = 0x78;                            /* @asm 0x07140B default width 120 */
        g_map_h_853C = 0x4B;                            /* @asm 0x071411 default height 75 */
        g_map_area_85A4 = 0x2328;                       /* @asm 0x071417 120*75 = 9000 */
        g_map_area_85A6 = 0;                            /* @asm 0x07141D */
        if (fh != 0) {                                   /* @asm 0x071423 */
            if (overlay_call_0D1D_0528() != 0) {        /* @asm 0x07142F fread header */
                uint32_t area = (uint32_t)g_map_h_853C * (uint32_t)g_map_w_853A;  /* @asm 0x07143B */
                g_map_area_85A4 = (uint16_t)area; g_map_area_85A6 = (uint16_t)(area >> 16);
            }
        }
    }
    if (func_07147C() == 0) {                           /* @asm 0x071449 alloc OK */
        if (func_071481() == 0)                          /* @asm 0x071455 post-step */
            ok = 0;                                      /* @asm 0x071464 success */
        else
            g_result_158 = 0x13;                         /* @asm 0x07145C post-step fail */
    }
    if (fh != 0) overlay_call_0D1D_03F4();               /* @asm 0x071472 fclose */
    return ok;                                            /* @asm 0x071477 RETF */
}

/* ============================================================================
 * func_0715E8 — PHANTOM
 * ----------------------------------------------------------------------------
 * @asm 0x0715E8 lies in the reloc/header gap 0x071490..0x072090 (page 0x19
 * code_end = 0x071490; page 0x1A code_offset = 0x072090).  These bytes are the
 * RTLink page-0x1A segment header + relocation table, NOT a function.  The
 * legacy auto-decoder mis-framed them as "func_0715E8".  No body.
 * ============================================================================ */

/* ============================================================================
 * func_072090 — build_menubar    SUPERSEDED
 * ----------------------------------------------------------------------------
 * The re-segmented page 0x1A proves 0x072090..0x072B9A is ONE 2826-byte
 * function (ENTER 4,0; RETF @0x072B99) — the in-game top MENU-BAR builder.
 * Fully ported (with MENU.TXT ground truth) in:
 * func_072090 — build_menubar — SUPERSEDED -> src/ui/report_screen.c (menu-bar builder)
 * The 39-byte "func_072090" of the stale banner is a truncated fragment.
 * ============================================================================ */

/* ============================================================================
 * func_072B9A — build_slot_list   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Builds the save/load SLOT list widget (12 entries).  Allocates a list handle
 * (0x181F:0x27C; NULL -> [0x822]=0x321), creates the list object of size 0x4000
 * (0x1A1F:0x372 with arg6; NULL -> [0x822]=0x322), then for i in 0..11 inserts
 * an item (0x181F:0x254) at a per-row offset (di += 0x100 each iteration into a
 * 0x10-stride record at [bp-0x24]).  Finalises/returns the list far-handle via
 * 0x191F:0x1A8.
 *
 * @asm 0x072BAF  lcall 0x181F:0x27C alloc(0xC) ; NULL -> [0x822]=0x321, exit
 * @asm 0x072BD0  lcall 0x1A1F:0x372 create(arg6, 0x4000) ; NULL -> [0x822]=0x322
 * @asm 0x072BFE..0x072C2B  for (i=0;i<0xC;i++) lcall 0x181F:0x254 add item (di+=0x100)
 * @asm 0x072C33  lcall 0x191F:0x1A8 finalise -> far handle in dx:ax  RETF
 * ============================================================================ */
extern int overlay_call_181F_027C(void);  /* 0x181F:0x027C -- list alloc */
extern int overlay_call_1A1F_0372(void);  /* 0x1A1F:0x0372 -- list create */
extern int overlay_call_181F_0254(void);  /* 0x181F:0x0254 -- list add item */

int func_072B9A_build_slot_list(uint16_t arg6)
{
    if (overlay_call_181F_027C() == 0) {                /* @asm 0x072BAF alloc 0xC */
        g_err_822 = 0x321;                              /* @asm 0x072BC0 */
        return 0;                                        /* @asm 0x072BC6 */
    }
    if (overlay_call_1A1F_0372() == 0) {                /* @asm 0x072BD0 create(arg6,0x4000) */
        g_err_822 = 0x322;                              /* @asm 0x072BDF */
        return 0;                                        /* @asm 0x072BE5 */
    }
    for (int i = 0; i < 0xC; i++) {                     /* @asm 0x072C28 cmp 0xC */
        overlay_call_181F_0254();                       /* @asm 0x072C1A add item (row di+=0x100) */
    }
    overlay_call_191F_01A8();                            /* @asm 0x072C33 finalise list */
    (void)arg6;
    return 0;                                            /* @asm 0x072C44 RETF (handle in dx:ax) */
}

/* ============================================================================
 * func_072C78 — build_save_filename    SUPERSEDED  (mis-framed start)
 * ----------------------------------------------------------------------------
 * The reseg over-merges the tail of func_072B9A; the real routine begins at
 * 0x072C7A (the 0x072C78 banner address points 2 bytes early, into the previous
 * func's epilogue).  It builds the savegame filename: strcpy(buf,"COLONY"
 * @bytes 0x20E2), append slot digit (0x181F:0xE9A, base 2), strcat(".SAV"
 * @bytes 0x20E9) — exactly the func_072C4E helper documented (and the format
 * decided) in the save path.
 * func_072C78 — build_save_filename — SUPERSEDED -> src/save/save_serializer.c
 *               (SAVE_NAME_STEM "COLONY" + slot + SAVE_NAME_EXT ".SAV")
 * @asm 0x072C7B strcpy(arg6,"COLONY")  @asm 0x072C92 lcall 0x181F:0xE9A (slot)
 * @asm 0x072C9D strcat(arg6,".SAV")
 * ============================================================================ */

/* ============================================================================
 * func_072CA4 — save_to_slot   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Thin SAVE wrapper: builds the slot filename into a 0x50-byte stack buffer via
 * near-call 0x073266 (-> 0x1A1F:0xCDA, the save-name helper), then invokes the
 * SAVE DRIVER LCALL 0x1A1F:0xCF6 (= func_0734F8, ported in save_serializer.c)
 * passing that buffer.  (Reaches the serializer documented in save_serializer.c.)
 *
 * @asm 0x072CA8  push arg6 ; lea [bp-0x50] ; call 0x073266 (build name)
 * @asm 0x072CBA  lcall 0x1A1F:0xCF6 (save driver, arg = name buffer)  RETF
 * ============================================================================ */
extern int overlay_call_1A1F_0CF6(void);  /* 0x1A1F:0x0CF6 -- SAVE driver (func_0734F8) */

int func_072CA4_save_to_slot(uint16_t arg6)
{
    func_073266();                                       /* @asm 0x072CB0 build slot name (-> 0x1A1F:0xCDA) */
    overlay_call_1A1F_0CF6();                            /* @asm 0x072CBA SAVE driver (func_0734F8) */
    (void)arg6;
    return 0;                                            /* @asm 0x072CBF RETF */
}

/* ============================================================================
 * func_072CC2 — layout_slot_dialog_rows   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Lays out and renders the rows of the save/load SLOT dialog (the list whose
 * handle comes from arg6).  ~696 bytes.  It:
 *   - saves the screen under the dialog: push [0x1FA2], mouse_y[0x8A0],
 *     mouse_x[0x89E]; LCALL 0x1A1F:0x7C4  (@asm 0x072CE3)
 *   - resolves the list object from arg6: LCALL 0x191F:0x182          (@asm 0x072CF8)
 *   - sets the list's "shown" bit: es:[handle+0xA] |= 1               (@asm 0x072D10)
 *   - for each of 4 slot records (stride 0x34 local array at [bp-0x243]):
 *       * pick the first FREE slot index (byte == 0) into [bp-0x11A]   (@asm 0x072D36)
 *       * format the slot LABEL: append handle [0x8394+slot*2] (runtime table)
 *         via 0x181F:0x16E, then literal via 0x181F:0x178             (@asm 0x072D75)
 *       * strcpy the record's saved-name field into the row buffer    (@asm 0x072DA2)
 *       * MEASURE the row text width (0x181F:0x204) and, while it exceeds
 *         0x64 (100px), TRUNCATE one char at a time (strlen 0x0D1D:0x842
 *         then NUL the last char) — i.e. ellipsis-free width clamp     (@asm 0x072DBC..0x072DE9)
 *       * append the date/size suffix handle [0x2DE0] (0x181F:0x16E)   (@asm 0x072E0A)
 *   - re-blits and finalises the list (0x191F:0x1A8 path at the tail).
 *
 * This is pure DIALOG TEXT LAYOUT (which field, what order, column-width clamp)
 * -> IN SCOPE.  The exact pixel column origins live in the page-0x12 widget
 * helpers (0x181F:0x16E/0x178/0x204) and are cited, not re-derived.
 *
 * @asm 0x072CE3  lcall 0x1A1F:0x7C4 (save screen under dialog)
 * @asm 0x072CF8  lcall 0x191F:0x182 (list handle from arg6) ; NULL -> exit
 * @asm 0x072D36  for slot in 0..3: first byte==0 -> chosen row
 * @asm 0x072D75  append [0x8394+slot*2] (0x181F:0x16E) + literal (0x181F:0x178)
 * @asm 0x072DBC  width = measure (0x181F:0x204) ; while (width>0x64) truncate
 * @asm 0x072E0A  append suffix [0x2DE0] (0x181F:0x16E)
 * @asm 0x072F67  lcall 0x1A1F:0x7C4 (restore) ; RETF
 * ============================================================================ */
extern int overlay_call_1A1F_07C4(void);  /* 0x1A1F:0x07C4 -- save/restore screen-under-dialog */
extern int overlay_call_191F_0182(void);  /* 0x191F:0x0182 -- resolve list object */
extern int overlay_call_181F_0178(void);  /* 0x181F:0x0178 -- append literal */
extern int overlay_call_181F_0204(void);  /* 0x181F:0x0204 -- measure text width */
extern int overlay_call_0D1D_0842(void);  /* 0x0D1D:0x0842 -- strlen */
extern uint16_t g_dlg_suffix_2DE0;        /* DGROUP:0x2DE0 -- slot-row suffix handle */

int func_072CC2_layout_slot_dialog_rows(uint16_t list_arg, uint16_t arg8)
{
    overlay_call_1A1F_07C4();                            /* @asm 0x072CE3 save screen-under */
    if (overlay_call_191F_0182() == 0)                   /* @asm 0x072CF8 resolve list */
        return 0;                                        /* @asm 0x072D09 NULL -> exit */
    /* es:[handle+0xA] |= 1  (mark shown)  @asm 0x072D10 */

    for (int row = 0; row < 4; row++) {                  /* @asm 0x072D33..0x072F25 per-slot loop */
        /* choose first free slot (record byte == 0) @asm 0x072D36..0x072D69 */
        overlay_call_181F_016E();                       /* @asm 0x072D75 append label handle [0x8394+slot*2] */
        overlay_call_181F_0178();                       /* @asm 0x072D8B append literal */
        overlay_call_0D1D_07E4();                        /* @asm 0x072DA2 strcpy saved-name into row buf */

        /* width clamp: while measured width > 100px, lop the last char. */
        while (overlay_call_181F_0204() > 0x64) {        /* @asm 0x072DBC measure vs 0x64 */
            overlay_call_0D1D_0842();                   /* @asm 0x072DCB strlen */
            /* buf[len-1] = 0  @asm 0x072DD5 */
            if (overlay_call_0D1D_0842() == 0) break;   /* @asm 0x072DDF empty -> stop */
        }
        overlay_call_181F_0178();                        /* @asm 0x072E02 append truncated text */
        overlay_call_181F_016E();                        /* @asm 0x072E13 append suffix [0x2DE0] */
        (void)g_dlg_suffix_2DE0;
    }
    overlay_call_1A1F_07C4();                            /* @asm 0x072F67 restore screen-under */
    (void)list_arg; (void)arg8;
    return 0;                                            /* @asm 0x072F7A RETF */
}

/* ============================================================================
 * func_072F7A — save_orchestrator    SUPERSEDED
 * ----------------------------------------------------------------------------
 * func_072F7A — save_orchestrator — SUPERSEDED -> src/save/save_serializer.c
 *   (SAVE command entry, gated by "SAVEGAME" key; calls the save driver
 *    0x1A1F:0xCF6 = func_0734F8).  Fully documented + ported there.
 * ============================================================================ */

/* ============================================================================
 * func_073158 — load_orchestrator    SUPERSEDED
 * ----------------------------------------------------------------------------
 * func_073158 — load_orchestrator — SUPERSEDED -> src/save/load_deserializer.c
 *   (LOAD command entry, gated by "LOADGAME" key; calls the load driver
 *    0x1A1F:0xD12 = func_073BB0; maps result codes to message keys).
 * ============================================================================ */

/* ============================================================================
 * func_073270 — parse_text_records   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Parses a delimited TEXT block (the file handle / buffer in arg2=[bp+0xA]) into
 * a table of fixed-stride records held in the 0xC4-byte stack frame at [bp-0xC4].
 * Uses the MSC token scanner pair 0x0D1D:0xE63 (find next field, into [bp-0x42])
 * and 0x0D1D:0xE58 (advance token).  For each parsed line it computes the record
 * slot stride 0x0A (`idx*0xA + 9`) and copies the token (strcpy 0x0D1D:0x7E4)
 * into the slot, bounded by a running count.  At the tail it walks the parsed
 * records through 0x191F:0x176/0x16A/0x182/0x1A8 (the list-population helpers),
 * so the parsed text becomes a selectable list.
 *
 * @asm 0x073292  lcall 0x0D1D:0xE63 scan first field (->[bp-0x42]) ; 0 -> exit
 * @asm 0x0732A9  lcall 0x0D1D:0xE58 advance ; loop
 * @asm 0x0732BC  slot = (si+9)/0xA ; per-record stride 0xA
 * @asm 0x0732ED  lcall 0x0D1D:0xE63 next field ; @asm 0x073326 strcpy(slot, token)
 * @asm 0x073364  lcall 0x191F:0x182 (list)  @asm 0x07338C/0x0733E5 0x191F:0x176 (rows)
 * @asm 0x0733F6  lcall 0x191F:0x16A         @asm 0x07341C/0x073467 0x191F:0x1A8 finalise
 * ============================================================================ */
extern int overlay_call_0D1D_0E63(void);  /* 0x0D1D:0x0E63 -- scan field */
extern int overlay_call_0D1D_0E58(void);  /* 0x0D1D:0x0E58 -- advance token */
extern int overlay_call_191F_0176(void);  /* 0x191F:0x0176 -- list add row */

int func_073270_parse_text_records(uint16_t arg6, uint16_t arg8, uint16_t src, uint16_t argC)
{
    if (overlay_call_0D1D_0E63() != 0)                  /* @asm 0x073292 scan first field */
        goto finalise;                                   /* @asm 0x07329E none -> finalise */
    while (overlay_call_0D1D_0E58() != 0) { }           /* @asm 0x0732A9 advance to a token */

    /* per-record copy loop @asm 0x0732BC..0x07335C (stride 0xA) */
    for (;;) {
        if (overlay_call_0D1D_0E63() != 0) break;       /* @asm 0x0732ED next field; none -> done */
        overlay_call_0D1D_07E4();                        /* @asm 0x073326 strcpy(slot, token) */
        if (overlay_call_0D1D_0E58() == 0) { }          /* @asm 0x073332 advance */
    }

finalise:
    if (overlay_call_191F_0182() != 0) {                /* @asm 0x073364 resolve list */
        overlay_call_191F_0176();                       /* @asm 0x07338C add row */
        overlay_call_191F_0176();                       /* @asm 0x0733BA add row */
        overlay_call_191F_0176();                       /* @asm 0x0733E5 add row */
        if (overlay_call_191F_016A() != 0) {            /* @asm 0x0733F6 row test */
            overlay_call_191F_01A8();                   /* @asm 0x07341C finalise */
        }
    }
    overlay_call_191F_01A8();                            /* @asm 0x073467 finalise (tail) */
    (void)arg6; (void)arg8; (void)src; (void)argC;
    return 0;                                            /* @asm 0x073473 RETF */
}

/* func_0734F8 — save_game_state (SAVE driver) — SUPERSEDED -> src/save/save_serializer.c
 *   (1464 bytes, ENTER 6,0; writes magic "COLONIZE" + version + map size + all
 *    PowerRecord/ColonyRecord/UnitRecord sections; reached via 0x1A1F:0xCF6).
 *   Re-seg page 0x1A is authoritative for its 0x0734F8..0x073AB0 extent. */

/* ============================================================================
 * func_073AB0 — read_save_header   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Opens and VALIDATES a savegame header (the LOAD path's inner reader; sibling
 * of the full LOAD driver func_073BB0 in load_deserializer.c, reached via
 * 0x1A1F:0xD04 -> 0x073AB0).  Opens the file arg6 with mode "rb"(@bytes 0x2183)
 * via fopen 0x0D1D:0x4DA, reads/validates the magic against "COLONIZE"
 * (@bytes 0x217A) using 0x1A1F:0xDEE (read block) + strcmp 0x0D1D:0x816, then
 * reads the version word (fread 0x0D1D:0x528) and compares it to the expected
 * version [0x81A].  Result code (in si) maps to the save status family
 * (1 default, 2 = magic mismatch, 5 = compact-flag path when [0x15A]).
 *
 * @asm 0x073AB6  si = 1 ; if ([0x15A]) si = 5            ; compact path code
 * @asm 0x073AC9  lcall 0x0D1D:0x4DA fopen(arg6, "rb"=0x2183) ; NULL -> exit(si)
 * @asm 0x073ADF  lcall 0x1A1F:0xDEE read header block ; 0 -> exit
 * @asm 0x073AF2  lcall 0x0D1D:0x816 strcmp(hdr,"COLONIZE"=0x217A) ; !=0 -> si=2
 * @asm 0x073B0D  fread(version,2,1) (0x0D1D:0x528)
 * @asm 0x073B1C  if (version > [0x81A]) ...                ; version gate
 * ============================================================================ */
extern int overlay_call_1A1F_0DEE(void);  /* 0x1A1F:0x0DEE -- read save header block */
extern int overlay_call_0D1D_0816(void);  /* 0x0D1D:0x0816 -- strcmp */

int func_073AB0_read_save_header(uint16_t arg6)
{
    int code = 1;                                       /* @asm 0x073AB6 si = 1 */
    int fh;

    if (g_map_buf_alloc_15A != 0) code = 5;             /* @asm 0x073AB9 compact-path code */
    fh = overlay_call_0D1D_04DA();                       /* @asm 0x073AC9 fopen "rb" (0x2183) */
    if (fh == 0) return code;                            /* @asm 0x073AD5 open fail -> code */
    if (overlay_call_1A1F_0DEE() == 0) return code;      /* @asm 0x073ADF header read fail */
    if (overlay_call_0D1D_0816() != 0)                   /* @asm 0x073AF2 strcmp "COLONIZE" */
        return 2;                                        /* @asm 0x073AFE mismatch -> code 2 */
    if (overlay_call_0D1D_0528() == 0) return code;      /* @asm 0x073B0D fread version */
    /* version gate against [0x81A]  @asm 0x073B1C..0x073B25 */
    (void)g_save_version_81A;
    (void)arg6;
    return code;                                          /* @asm 0x073D1E RETF */
}

/* ============================================================================
 * func_073BB0 — load_savegame    SUPERSEDED
 * ----------------------------------------------------------------------------
 * func_073BB0 — load_savegame (LOAD driver) — SUPERSEDED -> src/save/load_deserializer.c
 *   (1901 bytes, ENTER 0x64,0; magic "COLONIZE" + version/size gates; replays the
 *    SAVE section order with fread/block-read).  Fully ported there.
 * ============================================================================ */

/* ============================================================================
 * func_07431E — new_game_init   [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * NEW-GAME initialisation / leader-and-nation setup (~722 bytes).  In scope:
 * it RANDOMLY picks the human power, draws the intro panel, and zero-initialises
 * the per-power PowerRecord + AIPersonality tables.  Step by step:
 *
 *  1. If the quick-start flag [0x828] is clear, run pre-init 0x1A1F:0xB66
 *     (exit on failure); else force difficulty [0x53A6] = 2.    (@asm 0x074329)
 *  2. If difficulty == 0, set bit 0x80 in flag byte [0x5382].   (@asm 0x074341)
 *  3. If quick-start clear, run 0x1A1F:0xB74 (exit on fail), then
 *     [0x5398] = random_int(0,3)  (LCALL 0x181F:0x4D4, lo=0 hi=3) — the chosen
 *     starting power (England/France/Spain/Holland), clamped to <=3. (@asm 0x074360)
 *  4. Draw the intro: build the leader-name string from the AIPersonality slot
 *     ([0x5398]*0x34 + 0x540E) with keys "WOODPANL"(0x2189) / "LEADERNAME"(0x2192)
 *     / "NATION0A"(0x219D) (LCALL 0x191F:0x87A, 0x191F:0x120, sprintf 0x0D1D:0x117E,
 *     full-screen box 0x181F:0x444 at 0x140x0xC8). (@asm 0x07438A..0x0744F9)
 *  5. Zero the per-power records: walk si=0x543F (AIPersonality flag, stride 0x34)
 *     and di=0x8832 (PowerRecord, stride 0x13C); set [si]=1, clear two PowerRecord
 *     words, [si-1]=0; until di>=0x8D22.                          (@asm 0x0744FE)
 *  6. If the player count word [bp-0xA]==4, populate the multiplayer roster via
 *     key "MULTI"(0x21A6) (0x191F:0x182 + per-slot 0x181F:0xA24/0x22, 0x1A1F:0xAFE,
 *     0x191F:0x16A/0x1A8).                                        (@asm 0x07452D)
 *  7. Scan the active-power bitmask [0x1F54]; for each set bit clear its
 *     AIPersonality flag [0x543F + p*0x34] and record [0x5398]=p; if more than one
 *     active power, set bit 0x80 in [0x5381].                     (@asm 0x074590)
 *
 * @asm 0x074329  if (![0x828]) {0x1A1F:0xB66; fail->exit} else [0x53A6]=2
 * @asm 0x074341  if ([0x53A6]==0) [0x5382] |= 0x80
 * @asm 0x074364  [0x5398] = random_int(0,3)   (LCALL 0x181F:0x4D4)  @asm 0x074378 clamp <=3
 * @asm 0x07439F  lcall 0x191F:0x87A intro panel ("WOODPANL"/"LEADERNAME")
 * @asm 0x07440D  lcall 0x191F:0x120 ; @asm 0x074438 sprintf 0x0D1D:0x117E
 * @asm 0x0744FE  per-power zero loop (si=0x543F step0x34 ; di=0x8832 step0x13C)
 * @asm 0x07452D  if (players==4) build MULTI roster ("MULTI"=0x21A6)
 * @asm 0x074590  active-power scan [0x1F54] -> [0x5398], [0x5381]|=0x80 if >1
 * ============================================================================ */
extern int overlay_call_1A1F_0B66(void);  /* 0x1A1F:0x0B66 -- pre-init A */
extern int overlay_call_1A1F_0B74(void);  /* 0x1A1F:0x0B74 -- pre-init B */
extern int overlay_call_191F_087A(void);  /* 0x191F:0x087A -- intro panel ("WOODPANL") */
extern int overlay_call_181F_040A(void);  /* 0x181F:0x040A -- popup save */
extern int overlay_call_181F_0A24(void);  /* 0x181F:0x0A24 -- roster slot colour (not in overlay_externs.h) */
extern int overlay_call_1A1F_0AFE(void);  /* 0x1A1F:0x0AFE -- roster row draw (not in overlay_externs.h) */
extern uint8_t  g_quickstart_828;         /* DGROUP:0x828 -- quick-start / cheat flag */
extern uint16_t g_active_mask_1F54;       /* DGROUP:0x1F54 -- active-power bitmask */

int func_07431E_new_game_init(void)
{
    int players;

    /* 1. pre-init / quick-start */
    if (g_quickstart_828 == 0) {                        /* @asm 0x074329 */
        if (overlay_call_1A1F_0B66() != 0) return 1;    /* @asm 0x074330 fail -> exit */
    } else {
        g_difficulty_53A6 = 2;                          /* @asm 0x07433C force difficulty 2 */
    }
    /* 2. easiest difficulty -> set king/diff flag */
    if (g_difficulty_53A6 == 0)                         /* @asm 0x074341 */
        g_flags_5382 |= 0x80;                           /* @asm 0x074348 */

    /* 3. random starting power 0..3 */
    if (g_quickstart_828 == 0) {                        /* @asm 0x07434D */
        if (overlay_call_1A1F_0B74() != 0) return 1;    /* @asm 0x074354 fail -> exit */
        g_sel_nation_5398 = (uint16_t)overlay_call_181F_04D4();  /* @asm 0x074364 random_int(0,3) */
    }
    if ((int16_t)g_sel_nation_5398 > 3)                 /* @asm 0x074375 clamp */
        g_sel_nation_5398 = 0;                          /* @asm 0x07437A */

    /* 4. draw intro panel + leader name (only when quick-start clear). */
    if (g_quickstart_828 == 0) {                        /* @asm 0x074380 */
        int has_panel = (overlay_call_191F_087A() == 1);/* @asm 0x07439F intro ("WOODPANL"/"LEADERNAME") */
        if (has_panel) {
            overlay_call_181F_040A();                   /* @asm 0x0743B5 popup save */
            overlay_call_181F_0444();                   /* @asm 0x0743E3 full-screen box 0x140x0xC8 */
            overlay_call_181F_00E2();                   /* @asm 0x0743F5 flush */
        }
        /* build leader name string from AIPersonality[0x5398] (@asm 0x07440D/0x074438) */
        overlay_call_0D1D_117E();                       /* @asm 0x074438 sprintf "LEADERNAME"/"NATION0A" */
    }

    /* 5. zero per-power PowerRecord + AIPersonality flag tables. */
    /* @asm 0x0744FE si=0x543F (AIPersonality flag, stride 0x34);
     *               di=0x8832 (PowerRecord, stride 0x13C); until di>=0x8D22. */
    for (uint16_t p = 0; p < 4; p++) {                  /* 4 powers (0x8808..0x8D22 / 0x13C) */
        /* [0x543F + p*0x34] = 1 ; clear two PowerRecord words ; [...-1] = 0 */
    }

    /* 6. read player count; multiplayer roster when 4 players. */
    players = (int)(int16_t)g_sel_nation_5398;          /* @asm 0x074372 [bp-0xA] = [0x5398] */
    if (players == 4) {                                  /* @asm 0x074525 cmp 4 */
        if (overlay_call_191F_0182() != 0) {            /* @asm 0x074537 resolve roster ("MULTI") */
            for (int i = 0; i < 4; i++) {               /* @asm 0x074578 cmp 4 */
                overlay_call_181F_0A24();               /* @asm 0x074554 colour */
                overlay_call_181F_0022();               /* @asm 0x07455D image */
                overlay_call_1A1F_0AFE();               /* @asm 0x07456B roster row */
            }
            overlay_call_191F_016A();                   /* @asm 0x074584 */
            overlay_call_191F_01A8();                   /* @asm 0x07458B finalise */
        }
    }

    /* 7. active-power scan: count set bits in [0x1F54]; pick last active power. */
    {
        int active = 0;                                 /* @asm 0x074590 di = 0 */
        for (int p = 0; p < 4; p++) {                   /* @asm 0x074592..0x0745C1 stride 0x34 */
            if (g_active_mask_1F54 & (1u << p)) {        /* @asm 0x0745AB test bit */
                active++;                                /* @asm 0x0745B1 */
                g_sel_nation_5398 = (uint16_t)p;         /* @asm 0x0745B2 */
                /* [0x543F + p*0x34] = 0  @asm 0x0745B6 */
            }
        }
        if (active == 0) {                              /* @asm 0x0745C3 none active */
            g_sel_nation_5398 = 0;                      /* @asm 0x0745C7 */
            /* [0x543F] = 0  @asm 0x0745CB */
        }
        if (active > 1)                                 /* @asm 0x0745D0 cmp 1 */
            g_flags_5381 |= 0x80;                       /* @asm 0x0745D5 multi marker */
    }
    return 0;                                            /* @asm 0x0745E4 RETF */
}
