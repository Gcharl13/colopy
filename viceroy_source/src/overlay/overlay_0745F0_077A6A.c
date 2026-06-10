/* ============================================================================
 * overlay_0745F0_077A6A.c -- overlay functions in file range 0x0745F0..0x077A6A
 *
 * Region: late overlay pages 0x1A..0x1D of VICEROY.EXE.  Three cohesive
 * subsystems live here:
 *   (1) NEW-GAME / data-table init       (func_0749E0, func_0755CC)
 *   (2) per-power game-record accessors   (func_0745F0/07464C/074688/0764xx)
 *   (3) the SAVE/LOAD file machinery       (func_0759E8 + the "file access
 *       object" stream subsystem: func_076E50 constructor, func_07706C /
 *       func_077100 / func_0775EC / func_0776F4 / func_077772 callbacks,
 *       func_0772DA/0772C4 callback-pointer register/dispatch, func_0772FA
 *       vtable setup, func_077990 / func_077A34 directory scanners) and the
 *       modal dialogs that drive them (func_075352, func_075594).
 *
 * Hand-ported from the RE-SEGMENTED overlay disassembly (AUTHORITATIVE for
 * extents -- the per-func disasm/func_*.asm dumps the stale banners cite
 * truncate at the first RET and badly under-size the large routines, e.g.
 * func_074688 "9 bytes" is really a 0x32-byte 6-field setter, func_0749E0
 * "601" is really 2417, func_0755CC "235" is really 1052):
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_1A.asm (base 0x72090, ..0x763D0)
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_1B.asm (base 0x764D0, ..0x76D70)
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_1C.asm (base 0x76E50, ..0x77880)
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_1D.asm (base 0x77990, ..0x77E00)
 * Entry prologues spot-checked against raw COLONIZE/VICEROY.EXE.
 *
 * STRICT cite-or-left unresolved: every value/offset cites the .asm or raw EXE; opaque
 * overlay targets (0x181F:* / 0x191F:* / 0x1A1F:* helpers, the 0x0D1D:* C
 * runtime) are called through their canonical overlay_call_* names and never
 * fabricated.  DS-relative string-literal offsets (0x22xx/0x23xx/0x24xx) are
 * cited as addresses; STATIC in EXE — many decoded in function banners below
 * (e.g. "LEADERNAME" @0x2218, "PEDIA"@0x22EC, "OPENMENU"@0x233C, etc.).
 *
 * PORT STATUS (per 2026-05-30 directive; see per-function banners):
 *   DONE            full @asm-cited body written here (control flow byte-traced).
 *   STILL-SKELETON  in-scope real routine too large to byte-verify line-for-line
 *                   this pass (extent cited, structure + key sites cited;
 *                   full body not yet decoded). Used for the four 1KB+ routines.
 *   PHANTOM         reloc/header bytes mis-framed as a function.
 *   (No SUPERSEDED  -- a src/ grep for every offset found zero prior ports.)
 *   (No TRAMPOLINE  -- the page-0x0534BC ljmp-block style does not occur here;
 *    the only ljmps are func_076594's two tail thunks, declared as externs.)
 *   (No OUT-OF-SCOPE-- per the SCOPE RULE these all decide layout / what-goes-
 *    where / dispatch wiring; the pure byte movers they call are the 0x0D1D:*
 *    C runtime and the 0x1A1F:0xExx file primitives, which stay external.)
 *
 * Bases (DGROUP, cite when referenced): PowerRecord 0x8808 stride 0x13C
 *   (home coords +0x42/+0x43 = the -0x77C6/-0x77C5 displacement seen in
 *   func_0755CC; current human marker 0x5398, active power 0x5394/0x5396).
 *   UnitRecord 0x3144 stride 0x1C (type +0x02 = 0x3146, coords +0x09/+0x0A =
 *   0x314D/0x314E, state +0x08 = 0x314C, subtype +0x17 = 0x315B).
 *   AIPersonality 0x540E stride 0x34 (+0x31 active-flag = 0x543F seen in
 *   func_0759E8/func_0755CC; +0x32 reset word 0x5440).  difficulty 0x53A6;
 *   king-anger 0x53A7; REF/anger threshold block 0x53DA..; turn 0x538E;
 *   random_int(lo,hi) = LCALL 0x181F:0x04D4 (BYTE_VERIFIED, project mem).
 *   The "file access object" vtable lives at DGROUP 0xA63A..0xA64A and its
 *   iteration state at 0xA622..0xA648; the registered callback pair lives at
 *   0x245A..0x2460.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* Far function-pointer kinds stored in DGROUP and called via `lcall [mem]`.
 * stream_cb_t   -- the no-arg callback at 0x245E (func_0772C4).
 * stream_io_cb_t-- the read/seek callbacks in the file-object vtable at
 *                  0xA644 / 0xA63A (func_0776F4); each takes &size and the
 *                  buffer dword [0xA622:0xA624] and returns the count moved. */
typedef void     (far *stream_cb_t)(void);
typedef uint16_t (far *stream_io_cb_t)(uint16_t near *size /*, buf */);

/* ----------------------------------------------------------------------------
 * Overlay-thunk declarations used in this file but not in overlay_externs.h.
 * No-arg canonical prototype matching the file convention; each resolves via
 * tools/rtlink/rtlink_decode.py (these are fixed seg:off overlay entries, not
 * page-relative near targets).  Role inferred from call context only.
 * -------------------------------------------------------------------------- */
extern int overlay_call_191F_091C(void);  /* 0x191F:0x091C -- parse-token / next-field */
extern int overlay_call_191F_0928(void);  /* 0x191F:0x0928 -- find NAMES.TXT section by name */
extern int overlay_call_191F_0FC4(void);  /* 0x191F:0x0FC4 -- data-table helper */
extern int overlay_call_191F_0FDE(void);  /* 0x191F:0x0FDE -- text/record helper */
extern int overlay_call_191F_0FD0(void);  /* 0x191F:0x0FD0 -- record lookup (returns far ptr) */
extern int overlay_call_191F_01A8(void);  /* 0x191F:0x01A8 -- free far block */
extern int overlay_call_191F_087A(void);  /* 0x191F:0x087A -- predicate */
extern int overlay_call_191F_0320(void);  /* 0x191F:0x0320 -- predicate */
extern int overlay_call_191F_0F8E(void);  /* 0x191F:0x0F8E -- helper */
extern int overlay_call_191F_0AAC(void);  /* 0x191F:0x0AAC -- new-game post-setup */
extern int overlay_call_191F_0B6C(void);  /* 0x191F:0x0B6C -- new-game post-setup */

extern int overlay_call_1A1F_0B22(void);  /* 0x1A1F:0x0B22 -- value/random getter (paired w/ 0x91C) */
extern int overlay_call_1A1F_088A(void);  /* 0x1A1F:0x088A -- random byte getter */
extern int overlay_call_1A1F_0B16(void);  /* 0x1A1F:0x0B16 -- value getter */
extern int overlay_call_1A1F_0A86(void);  /* 0x1A1F:0x0A86 -- modal yes/no or wait-key */
extern int overlay_call_1A1F_0A78(void);  /* 0x1A1F:0x0A78 -- region save (0x300 buf) */
extern int overlay_call_1A1F_0A6A(void);  /* 0x1A1F:0x0A6A -- region restore/fade */
extern int overlay_call_1A1F_0A5C(void);  /* 0x1A1F:0x0A5C -- screen helper */
extern int overlay_call_1A1F_0A94(void);  /* 0x1A1F:0x0A94 -- string copy/append */
extern int overlay_call_1A1F_0CDA(void);  /* 0x1A1F:0x0CDA -- build save path component */
extern int overlay_call_1A1F_0C80(void);  /* 0x1A1F:0x0C80 -- predicate */
extern int overlay_call_1A1F_0C8E(void);  /* 0x1A1F:0x0C8E -- predicate */
extern int overlay_call_1A1F_083E(void);  /* 0x1A1F:0x083E -- helper */
extern int overlay_call_1A1F_0976(void);  /* 0x1A1F:0x0976 -- new-game post-setup */
extern int overlay_call_1A1F_07EA(void);  /* 0x1A1F:0x07EA -- new-game post-setup */
extern int overlay_call_1A1F_07F8(void);  /* 0x1A1F:0x07F8 -- new-game post-setup */
extern int overlay_call_1A1F_087C(void);  /* 0x1A1F:0x087C -- new-game post-setup */
extern int overlay_call_1A1F_0E40(void);  /* 0x1A1F:0x0E40 -- map setup */
extern int overlay_call_1A1F_0E36(void);  /* 0x1A1F:0x0E36 -- map setup */
extern int overlay_call_1A1F_0E28(void);  /* 0x1A1F:0x0E28 -- map-tile scan */
extern int overlay_call_1A1F_0E02(void);  /* 0x1A1F:0x0E02 -- map-tile scan */
extern int overlay_call_1A1F_0E1E(void);  /* 0x1A1F:0x0E1E -- map helper */
extern int overlay_call_1A1F_0DF8(void);  /* 0x1A1F:0x0DF8 -- formatted output line */
extern int overlay_call_1A1F_0BE4(void);  /* 0x1A1F:0x0BE4 -- helper */
extern int overlay_call_1A1F_0E9E(void);  /* 0x1A1F:0x0E9E -- struct field read (typed) */
extern int overlay_call_1A1F_0E82(void);  /* 0x1A1F:0x0E82 -- struct field read (typed) */
extern int overlay_call_1A1F_0E90(void);  /* 0x1A1F:0x0E90 -- struct alloc/bind */
extern int overlay_call_1A1F_0EAC(void);  /* 0x1A1F:0x0EAC -- struct free */
extern int overlay_call_1A1F_0E78(void);  /* 0x1A1F:0x0E78 -- struct accumulate */
extern int overlay_call_1A1F_0CB4(void);  /* 0x1A1F:0x0CB4 -- stream helper */
extern int overlay_call_1A1F_0C9C(void);  /* 0x1A1F:0x0C9C -- stream open (size arg) */
extern int overlay_call_1A1F_0F26(void);  /* 0x1A1F:0x0F26 -- add filename to list */
extern int overlay_call_1A1F_0E10(void);  /* 0x1A1F:0x0E10 -- map post-load validate */
extern int overlay_call_1A1F_0E4E(void);  /* 0x1A1F:0x0E4E -- map teardown / finalize */
extern int overlay_call_1A1F_0E5C(void);  /* 0x1A1F:0x0E5C -- view-state init */
extern int overlay_call_1A1F_0E6A(void);  /* 0x1A1F:0x0E6A -- formatted name line */
extern int overlay_call_1A1F_07C4(void);  /* 0x1A1F:0x07C4 -- region restore (0x1000) */
extern int overlay_call_1A1F_0CBE(void);  /* 0x1A1F:0x0CBE -- predicate */
extern int overlay_call_1A1F_08DC(void);  /* 0x1A1F:0x08DC -- bind map layer ptrs */
extern int overlay_call_181F_0254(void);  /* 0x181F:0x0254 -- decode layer into block */
extern int overlay_call_181F_0398(void);  /* 0x181F:0x0398 -- present */
extern int overlay_call_181F_0546(void);  /* 0x181F:0x0546 -- screen restore */
extern int overlay_call_181F_05CE(void);  /* 0x181F:0x05CE -- helper */
extern int overlay_call_181F_0EAE(void);  /* 0x181F:0x0EAE -- config write/flag */
extern int overlay_call_0D1D_0ABE(void);  /* 0x0D1D:0x0ABE -- C buffered read */
extern int overlay_call_1A1F_0EBA(void);  /* 0x1A1F:0x0EBA -- emit packed record (returns coord) */
extern int overlay_call_1A1F_0EE4(void);  /* 0x1A1F:0x0EE4 -- cursor-gate predicate.
                                              TARGET CORRECTED 2026-06-10: thunk@0x1D4D4 bytes
                                              say overlay 0x1C(28) + 0x82 -> ≈file 0x76ED2
                                              (segmap key 28, AMBIG base).  The old claim
                                              "overlay 0:0x82 -> 0x25982 inside func_025900"
                                              mis-decoded the overlay field; body untraced. */

extern int overlay_call_181F_000E(void);  /* 0x181F:0x000E -- module init */
extern int overlay_call_181F_0182(void);  /* 0x181F:0x0182 -- strcat / format-append */
extern int overlay_call_181F_044E(void);  /* 0x181F:0x044E -- measure / fit decision */
extern int overlay_call_181F_048E(void);  /* 0x181F:0x048E -- draw glyph/box */
extern int overlay_call_181F_02F8(void);  /* 0x181F:0x02F8 -- draw value bar */
extern int overlay_call_181F_03B6(void);  /* 0x181F:0x03B6 -- push draw state */
extern int overlay_call_181F_03F4(void);  /* 0x181F:0x03F4 -- blit region */
extern int overlay_call_181F_0444(void);  /* 0x181F:0x0444 -- draw box */
extern int overlay_call_181F_00E2(void);  /* 0x181F:0x00E2 -- draw frame */
extern int overlay_call_181F_03FE(void);  /* 0x181F:0x03FE -- draw text run */
extern int overlay_call_181F_03AC(void);  /* 0x181F:0x03AC -- present/flush */
extern int overlay_call_181F_00BA(void);  /* 0x181F:0x00BA -- draw line/rect */
extern int overlay_call_181F_04CA(void);  /* 0x181F:0x04CA -- set palette/color */
extern int overlay_call_181F_04C0(void);  /* 0x181F:0x04C0 -- set mode/value */
extern int overlay_call_181F_04F2(void);  /* 0x181F:0x04F2 -- init draw */
extern int overlay_call_181F_04E8(void);  /* 0x181F:0x04E8 -- helper */
extern int overlay_call_181F_04D4(void);  /* 0x181F:0x04D4 -- random_int(lo,hi) BYTE_VERIFIED */
extern int overlay_call_181F_029A(void);  /* 0x181F:0x029A -- alloc far block (size arg) */
extern int overlay_call_181F_0290(void);  /* 0x181F:0x0290 -- realloc/grow far block */
extern int overlay_call_181F_0772(void);  /* 0x181F:0x0772 -- error/abort dialog */
extern int overlay_call_181F_095C(void);  /* 0x181F:0x095C -- create unit (returns index) */
extern int overlay_call_181F_0E86(void);  /* 0x181F:0x0E86 -- file findfirst / open (returns handle) */
extern int overlay_call_181F_053C(void);  /* 0x181F:0x053C -- screen save (0,0,320,200) */
extern int overlay_call_181F_0498(void);  /* 0x181F:0x0498 -- helper */
extern int overlay_call_181F_0484(void);  /* 0x181F:0x0484 -- restore region */
extern int overlay_call_181F_0F3C(void);  /* 0x181F:0x0F3C -- helper */
extern int overlay_call_181F_04DE(void);  /* 0x181F:0x04DE -- helper */
extern int overlay_call_181F_040A(void);  /* 0x181F:0x040A -- helper */
extern int overlay_call_181F_04AC(void);  /* 0x181F:0x04AC -- helper */
extern int overlay_call_181F_04A2(void);  /* 0x181F:0x04A2 -- helper */
extern int overlay_call_181F_0EB8(void);  /* 0x181F:0x0EB8 -- config read */
extern int overlay_call_181F_0E5E(void);  /* 0x181F:0x0E5E -- config field getter */
extern int overlay_call_181F_0E68(void);  /* 0x181F:0x0E68 -- config field advance */
extern int overlay_call_181F_0E72(void);  /* 0x181F:0x0E72 -- config field getter (dword) */
extern int overlay_call_181F_0ED6(void);  /* 0x181F:0x0ED6 -- helper */
extern int overlay_call_181F_05C4(void);  /* 0x181F:0x05C4 -- helper */
/* overlay_call_1A1F_0372: returns int per overlay_externs.h (ax:dx 32-bit; int on modern) */

extern int overlay_call_0D1D_07E4(void);  /* 0x0D1D:0x07E4 -- C strcpy */
extern int overlay_call_0D1D_0C56(void);  /* 0x0D1D:0x0C56 -- C strchr */
extern int overlay_call_0D1D_07A4(void);  /* 0x0D1D:0x07A4 -- C strcpy variant */
extern int overlay_call_0D1D_0D64(void);  /* 0x0D1D:0x0D64 -- C helper */
extern int overlay_call_0D1D_085E(void);  /* 0x0D1D:0x085E -- C strncpy */
extern int overlay_call_0D1D_0894(void);  /* 0x0D1D:0x0894 -- C strncpy variant */
extern int overlay_call_0D1D_09A2(void);  /* 0x0D1D:0x09A2 -- C helper (ptr out) */
extern int overlay_call_0D1D_0A3E(void);  /* 0x0D1D:0x0A3E -- C helper */
extern int overlay_call_0D1D_0DAE(void);  /* 0x0D1D:0x0DAE -- C memset(base,val,n) */
extern int overlay_call_0D1D_0FB2(void);  /* 0x0D1D:0x0FB2 -- C helper */
extern int overlay_call_0D1D_0816(void);  /* 0x0D1D:0x0816 -- C helper */
extern int overlay_call_0D1D_10C0(void);  /* 0x0D1D:0x10C0 -- C sprintf */
extern int overlay_call_0D1D_0D46(void);  /* 0x0D1D:0x0D46 -- C strchr/strpbrk */
extern int overlay_call_0D1D_1084(void);  /* 0x0D1D:0x1084 -- C helper */
extern int overlay_call_0D1D_0AD8(void);  /* 0x0D1D:0x0AD8 -- C free/close */
extern int overlay_call_0D1D_03F4(void);  /* 0x0D1D:0x03F4 -- C fclose/free */
extern int overlay_call_0D1D_0F60(void);  /* 0x0D1D:0x0F60 -- C 64-bit cmp/sub */
extern int overlay_call_0D1D_0EC6(void);  /* 0x0D1D:0x0EC6 -- C lseek/position set */
extern int overlay_call_0D1D_0B1C(void);  /* 0x0D1D:0x0B1C -- C buffered fill */
extern int overlay_call_0D1D_0E9D(void);  /* 0x0D1D:0x0E9D -- C chunked copy */
extern int overlay_call_0D1D_09CA(void);  /* 0x0D1D:0x09CA -- C findnext (read dirent) */
extern int overlay_call_0D1D_0842(void);  /* 0x0D1D:0x0842 -- C strlen */
extern int overlay_call_0D1D_08BC(void);  /* 0x0D1D:0x08BC -- C strncmp */
extern int overlay_call_0D1D_117E(void);  /* 0x0D1D:0x117E -- C strcpy(dst, src) used by NAMES name fills */
extern int overlay_call_0D1D_08F6(void);  /* 0x0D1D:0x08F6 -- C atoi/count (MISCELLANEOUS count @0x833c) */
extern int overlay_call_1A1F_0B2E(void);  /* 0x1A1F:0x0B2E -- NAMES parse helper (UNIT last field) */

/* Local DGROUP globals referenced below (absolute DGROUP offsets from disasm). */
extern uint8_t  g_difficulty_53A6;      /* DGROUP:0x53A6 -- difficulty level */
extern uint16_t g_human_marker_5398;    /* DGROUP:0x5398 -- current human power marker */

/* Page-internal near subroutines reached by `push cs; call NNN` (outside this
 * file's assigned set; declared so the cited bodies can name them).  The IP
 * value in each comment is the page-0x1A / 0x1B image-relative target; the
 * file offset is page_base + IP.  Roles inferred from call context. */
extern int      page1B_err_abort(void);        /* page-0x1B near 0x26D (alloc-fail / abort) */
extern int      page1B_msgbox(void);           /* page-0x1B near 0x26D variant (message box) */
extern uint32_t page1B_load_block(void);       /* page-0x1B near 0x268 (load 0x4000 block -> far) */
extern int      page1A_dir_match(void);        /* page-0x1A near 0x4eea (save-name filter) */
extern int      page1A_read_hdr(void);         /* page-0x1A near 0x4ee5 (read save header) */
extern int      page1A_file_pick(void);        /* page-0x1A near 0x4f30 (file picker) */
extern int      page1A_msgbox(void);           /* page-0x1A near 0x4ee0 (simple message box) */
extern int      page1A_names_subloader(int idx); /* page-0x1A near 0x4eef = ljmp 0x1A1F:0xD20
                                                  * BYTE_VERIFIED 2026-06-08: thunk @0x7637F→
                                                  * ljmp 0x1A1F:0xD20→body @file 0x72CC2 (695B).
                                                  * Args: (int max_entries[bp+8], int idx[bp+6]).
                                                  * Returns DX:AX = far ptr to section struct.
                                                  * Writes DS:0xA60C+entry_idx loading-flag byte;
                                                  * interns terrain names via lcall 0x191F:0x176.
                                                  * idx=0..7 = @UNFORESTED, idx=0x18..0x1C = @OTHER.
                                                  * Section table: DS:0x087C "GAME\0\0NAMES\0..." */
extern int      page1A_newgame_postinit(void); /* page-0x1A near 0x4ef9 = ljmp 0x1A1F:0xD3C
                                                  * @asm 0x076389 (new-game module post-init) */
extern int      page1A_newgame_mapinit(void);  /* page-0x1A near 0x4f2b = ljmp 0x1A1F:0xDC8
                                                  * @asm 0x0763BB (new-game default-map init) */
extern int      page1A_sl_prep(void);          /* page-0x1A near 0x4f17 = ljmp 0x1A1F:0xD90
                                                  * @asm 0x0763A7 (save/load list prep / refresh) */
extern int      page1A_sl_commit(void);        /* page-0x1A near 0x4f1c = ljmp 0x1A1F:0xD9E
                                                  * @asm 0x0763AC (save/load commit IO) */
extern int      page1A_sl_addmap(void);        /* page-0x1A near 0x4f26 = ljmp 0x1A1F:0xDBA
                                                  * @asm 0x0763B6 (add map name to list) */
extern int      page1A_sl_flush(void);         /* page-0x1A near 0x4f0d = ljmp 0x1A1F:0xD74
                                                  * @asm 0x07639D (save/load list flush) */
extern int      page1A_map_pre(void);          /* page-0x1A near 0x4f08 = ljmp 0x1A1F:0xD66
                                                  * @asm 0x076398 (map-setup pre-step) */
extern int      page1A_map_colors(void);       /* page-0x1A near 0x4f12 = ljmp 0x1A1F:0xD82
                                                  * @asm 0x0763A2 (map-setup palette/init) */
extern int      page1A_map_finalize(void);     /* page-0x1A near 0x4f21 = ljmp 0x1A1F:0xDAC
                                                  * @asm 0x0763B1 (map-setup finalize check) */
extern int      page1C_stream_notify(void);    /* page-0x1C near 0x872 = ljmp 0x1A1F:0xEC8
                                                  * @asm 0x0775E2 (stream notify) */
extern int      page1C_stream_buf(void);       /* page-0x1C near 0x877 = ljmp 0x1A1F:0xED6
                                                  * @asm 0x0775E7 (stream buffer helper) */
extern int      page1C_stream_op_default(void);/* page-0x1C near 0xafc (default stream-op path;
                                                  * spills past page-1C listing end into 1D) */

/* ============================================================================
 * func_0764D0 — gamewindow_view_init  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * NOTE: the auto-decoder MISSED this 33-byte function (it is page 0x1B's first
 * real routine, file 0x0764D0..0x0764F0).  Restored here.  No frame; RETF.
 * Seeds the map-scroll / viewport iteration state:
 *   [0x23CE] = 0                          (visited / row counter)
 *   [0xA616:A618] = [0x23C6:0x23C8]        (copy current origin dword)
 *   [0x23CA] = 0x3880 ; [0x23CC] = 1       (step dword = 0x00013880)
 *
 * @asm 0x0764D0  c7 06 ce 23 00 00   mov [0x23ce],0
 * @asm 0x0764D6  a1 c6 23            mov ax,[0x23c6]
 * @asm 0x0764D9  8b 16 c8 23         mov dx,[0x23c8]
 * @asm 0x0764DD  a3 16 a6 / 89 16 18 a6   mov [0xa616],ax ; mov [0xa618],dx
 * @asm 0x0764E4  c7 06 ca 23 80 38   mov [0x23ca],0x3880
 * @asm 0x0764EA  c7 06 cc 23 01 00   mov [0x23cc],1
 * @asm 0x0764F0  cb                  retf
 * @status DONE
 */
void func_0764D0_gamewindow_view_init(void)
{
    *((uint16_t near *)0x23CE) = 0;                         /* @asm 0x0764D0 */
    *((uint16_t near *)0xA616) = *((uint16_t near *)0x23C6);/* @asm 0x0764D6/0764DD */
    *((uint16_t near *)0xA618) = *((uint16_t near *)0x23C8);/* @asm 0x0764D9/0764E0 */
    *((uint16_t near *)0x23CA) = 0x3880;                    /* @asm 0x0764E4 */
    *((uint16_t near *)0x23CC) = 0x0001;                    /* @asm 0x0764EA */
}

/* ============================================================================
 * func_0745F0 — power_record_field_init  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Initializes one per-index record (di = arg0_bp_06) in a stride-16 table:
 *   word [di*16 + 0x2F74] = (0x191F:0x91C , 0x1A1F:0xB22) value getter
 *   byte [di*16 + 0x2F76..0x2F79] = four 0x1A1F:0x88A random bytes
 *   byte [di*16 + 0x2F7B + i]     = nine 0x1A1F:0x88A random bytes (i=0..8)
 * (stride 16, base DGROUP 0x2F74; a per-power scratch/flags record.)
 *
 * @asm 0x0745F5  mov di,[bp+6]
 * @asm 0x0745F8  lcall 0x191F:0x91C ; @asm 0x0745FD lcall 0x1A1F:0xB22
 * @asm 0x074604  shl bx,4 ; @asm 0x074607 mov [bx+0x2f74],ax
 * @asm 0x07460D..0x07462D  4x lcall 0x1A1F:0x88A -> bytes +0x2f76..+0x2f79
 * @asm 0x074633  loop: lcall 0x1A1F:0x88A -> byte [bx+si+0x2f7b]; @asm 0x074645 cmp si,9 jl
 * @status DONE
 */
void func_0745F0_power_record_field_init(uint16_t arg0_bp_06)
{
    int di = arg0_bp_06;
    int base = di << 4;                       /* @asm 0x074604 shl bx,4 */
    int si;

    overlay_call_191F_091C();                 /* @asm 0x0745F8 */
    *((uint16_t near *)(base + 0x2F74)) =
        (uint16_t)overlay_call_1A1F_0B22();   /* @asm 0x0745FD/074607 */

    *((uint8_t near *)(base + 0x2F76)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x07460D/074612 */
    *((uint8_t near *)(base + 0x2F77)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x074616/07461B */
    *((uint8_t near *)(base + 0x2F78)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x07461F/074624 */
    *((uint8_t near *)(base + 0x2F79)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x074628/07462D */

    for (si = 0; si < 9; si++) {              /* @asm 0x074642 cmp si,9 / 0x074645 jl 0x074633 */
        *((uint8_t near *)(base + si + 0x2F7B)) =
            (uint8_t)overlay_call_1A1F_088A();/* @asm 0x074633/07463D */
    }
}

/* ============================================================================
 * func_07464C — colony_or_unit_record_setter6  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Writes a 12-byte-stride record (si = arg_idx*12; idx passed in AX) into a
 * table based at DGROUP -0x707B..-0x7079 (= 0x8F85..) plus a back-reference
 * byte at [cx-0x729E].  Args arrive in registers (AX=idx, DX=val0) plus the
 * stack (bp+6 = cx-indexed key, bp+8, bp-2).  retf 4.
 *   si = idx*12
 *   [si-0x707B] = AL(=val0 low)         [si-0x707C] = [bp-2]
 *   [si-0x707A] = [bp+8]                [si-0x7078] = CL(=bp+6 low)
 *   [cx-0x729E] = [si-0x7079]           (cross-index back-pointer)
 *
 * @asm 0x074651  mov cx,[bp+6] ; @asm 0x074654 mov si,ax ; mov ax,dx
 * @asm 0x07465A  shl si,1 ; add si,dx ; shl si,2          (si = idx*12)
 * @asm 0x074661  mov [si-0x707b],al
 * @asm 0x074665  mov al,[bp-2] ; mov [si-0x707c],al
 * @asm 0x07466C  mov al,[bp+8] ; mov [si-0x707a],al
 * @asm 0x074675  mov [si-0x7078],cl
 * @asm 0x07467B  mov al,[si-0x7079] ; @asm 0x07467F mov [bx-0x729e],al  (bx=cx)
 * @status DONE
 */
void func_07464C_colony_or_unit_record_setter6(uint16_t idx_ax, uint16_t val0_dx,
                                               uint16_t arg0_bp_06, uint16_t arg1_bp_08,
                                               uint16_t arg2_bp_m2)
{
    int si = (int)idx_ax * 12;                /* @asm 0x07465A shl/add/shl -> idx*12 */
    uint16_t cx = arg0_bp_06;                 /* @asm 0x074651 */

    *((uint8_t near *)(si - 0x707B)) = (uint8_t)val0_dx;       /* @asm 0x074661 */
    *((uint8_t near *)(si - 0x707C)) = (uint8_t)arg2_bp_m2;    /* @asm 0x074665/074668 */
    *((uint8_t near *)(si - 0x707A)) = (uint8_t)arg1_bp_08;    /* @asm 0x07466C/07466F */
    *((uint8_t near *)(si - 0x7078)) = (uint8_t)cx;            /* @asm 0x074675 */
    *((uint8_t near *)(cx - 0x729E)) =
        *((uint8_t near *)(si - 0x7079));     /* @asm 0x07467B/07467F back-ref */
}

/* ============================================================================
 * func_074688 — power_record_setter6  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * (Stale banner "9 bytes TINY_RETURN" is WRONG; the reseg sizes it 856 because
 * a frameless data-init block follows with no prologue.  The real function is
 * 0x32 bytes 0x074688..0x0746BB, terminal `retf 6`, verified in raw EXE:
 *   55 8b ec 53 56 ... 5e c9 ca 06 00.  That trailing frameless block
 *   0x0746BC..0x0749DF is now ported separately as
 *   func_0746BC_init_founding_fathers_table, below.)
 * Writes a 6-byte-stride record (si = arg0_bp_06*6) into a table based at
 * DGROUP -0x6874..-0x6870.  Args: AL/DL come in registers (DL->cl), plus
 * stack [bp+0xa], [bp-2] (word), [bp+8].
 *   si = idx*6
 *   [si-0x6874]=AL ; [si-0x6873]=CL(=DL) ; [si-0x6872]=[bp+0xa]
 *   [si-0x6870]=word [bp-2] ; [si-0x6871]=[bp+8]
 *
 * @asm 0x07468D  mov cx,dx ; @asm 0x07468F mov si,[bp+6]
 * @asm 0x074692  shl si,1 ; add si,dx? (add si,dx where dx=si copy) ; shl si,1  (si = idx*6)
 * @asm 0x07469A  mov [si-0x6874],al ; @asm 0x07469E mov [si-0x6873],cl
 * @asm 0x0746A2  mov al,[bp+0xa] ; mov [si-0x6872],al
 * @asm 0x0746A9  mov ax,[bp-2] ; mov [si-0x6870],ax
 * @asm 0x0746B0  mov al,[bp+8] ; mov [si-0x6871],al ; @asm 0x0746B9 retf 6
 * @status DONE
 */
void func_074688_power_record_setter6(uint16_t al_lo, uint16_t dl_lo,
                                      uint16_t arg0_bp_06, uint16_t arg1_bp_08,
                                      uint16_t arg2_bp_0A, uint16_t arg3_bp_m2)
{
    int si = (int)arg0_bp_06 * 6;             /* @asm 0x074692 shl/add/shl -> idx*6 */

    *((uint8_t  near *)(si - 0x6874)) = (uint8_t)al_lo;        /* @asm 0x07469A */
    *((uint8_t  near *)(si - 0x6873)) = (uint8_t)dl_lo;        /* @asm 0x07469E (cl=dl) */
    *((uint8_t  near *)(si - 0x6872)) = (uint8_t)arg2_bp_0A;   /* @asm 0x0746A2/0746A5 */
    *((uint16_t near *)(si - 0x6870)) = arg3_bp_m2;            /* @asm 0x0746A9/0746AC */
    *((uint8_t  near *)(si - 0x6871)) = (uint8_t)arg1_bp_08;   /* @asm 0x0746B0/0746B3 */
}

/* ----------------------------------------------------------------------------
 * Page-0x1A record-setter trampolines reached by the hardcoded table init below.
 * Both are near `call` sites that ljmp into page 0x12 (seg 0x1A1F); declared
 * file-local per the project's cite-or-extern rule (siblings of the
 * page1A_names_subloader trampoline at 0x1A1F:0xD20).  Raw bytes verified:
 *   0x076384: EA 2E 0D 1F 1A   (ljmp 0x1A1F:0x0D2E)
 *   0x07638E: EA 4A 0D 1F 1A   (ljmp 0x1A1F:0x0D4A)
 * Roles inferred from the call-site argument shape (index/prereq/next/category
 * tuple writer, and the same writer with an extra magnitude word). */
extern int father_table_set_076384(uint16_t index_ax, uint16_t prereq_dx,
                                    uint16_t category, uint16_t next_idx); /* 0x1A1F:0x0D2E */
extern int father_table_set_value_07638E(uint16_t a_ax, uint16_t index_dx,
                                          uint16_t magnitude_bx, uint16_t category,
                                          uint16_t neg1, uint16_t p2);      /* 0x1A1F:0x0D4A */

/* ============================================================================
 * func_0746BC — init_founding_fathers_table   [DONE — BYTE_VERIFIED, newly ported]
 * ----------------------------------------------------------------------------
 * THE HARDCODED FOUNDING-FATHERS PREREQUISITE / CATEGORY TABLE INITIALISER.
 * This is the FRAMELESS block (no ENTER prologue; starts at `push 1`) that the
 * func_074688 banner flagged as "a data-init block follows with no prologue"
 * but the prior pass left UNPORTED.  Full extent 0x0746BC..0x0749DF, terminal
 * RETF @0x0749DF (the very next byte, 0x0749E0, is func_0749E0's ENTER).
 *
 * It seeds the 42 founding fathers (index 0x00..0x29) across 15 categories
 * (0x00..0x0E), recording for each father: its PREREQUISITE father (dx; 0xFFFF =
 * none) and the NEXT father in the same category chain ([bp+0xA]; -1 = end of
 * chain), via setter 0x1A1F:0x0D2E (near 0x076384).  Then six fathers get an
 * extra numeric magnitude (bx = 500/1000/2000/3000/2000/5000) via setter
 * 0x1A1F:0x0D4A (near 0x07638E) — the "scaled effect" fathers (e.g. gold/bell
 * thresholds).  The names themselves come from NAMES.TXT @FATHERS (cnt 0x19 of
 * the simple rows + the chained extension here); this routine fixes the STATIC
 * topology (who unlocks whom, and in which category column).
 *
 * The (index, prereq, next, category) tuples are byte-exact from the call sites:
 * @asm 0x0746BC  set(0x00, none, 0x01, cat0)
 * @asm 0x0746CB  set(0x01, 0x00, 0x02, cat0)
 * @asm 0x0746DA  set(0x02, 0x01, end,  cat0)
 * @asm 0x0746EB  set(0x03, none, 0x04, cat1)   0x074708 set(0x04,0x03,0x05,cat1)
 * @asm 0x07470C  set(0x05, 0x04, end,  cat1)
 * @asm 0x07471D  set(0x06, none, 0x07, cat2)   0x07472D set(0x07,0x06,0x08,cat2)
 * @asm 0x07473E  set(0x08, 0x07, end,  cat2)
 * @asm 0x07474F  set(0x09, none, end,  cat3)   0x07475F set(0x0A,0x09,0x0B,cat3)
 * @asm 0x074770  set(0x0B, 0x0A, end,  cat3)
 * @asm 0x074781  set(0x1E, 0x0B, 0x1F, cat3)   0x074792 set(0x1F,0x1E,end,cat3)
 * @asm 0x0747A3  set(0x0C, none, 0x0D, cat4)   0x0747B3 set(0x0D,0x0C,0x0E,cat4)
 * @asm 0x0747C4  set(0x0E, 0x0D, end,  cat4)
 * @asm 0x0747D5  set(0x0F, none, 0x10, cat5)   0x0747E5 set(0x10,0x0F,end,cat5)
 * @asm 0x0747F6  set(0x11, none, end,  cat5)
 * @asm 0x074806  set(0x12, none, end,  cat6)
 * @asm 0x074816  set(0x13, none, 0x14, cat7)   0x074826 set(0x14,0x13,end,cat7)
 * @asm 0x074837  set(0x15, none, 0x16, cat8)   0x074847 set(0x16,0x15,0x17,cat8)
 * @asm 0x074858  set(0x17, 0x16, end,  cat8)
 * @asm 0x074869  set(0x18, none, 0x19, cat9)   0x074879 set(0x19,0x18,0x1A,cat9)
 * @asm 0x07488A  set(0x1A, 0x19, end,  cat9)
 * @asm 0x07489B  set(0x1B, none, 0x1C, catA)   0x0748AB set(0x1C,0x1B,0x1D,catA)
 * @asm 0x0748BC  set(0x1D, 0x1C, end,  catA)
 * @asm 0x0748CD  set(0x20, none, 0x21, catB)   0x0748DD set(0x21,0x20,0x22,catB)
 * @asm 0x0748EE  set(0x22, 0x21, end,  catB)
 * @asm 0x0748FF  set(0x23, none, end,  catC)
 * @asm 0x07490F  set(0x24, 0x23, end,  catC)
 * @asm 0x074920  set(0x25, none, end,  catD)
 * @asm 0x074930  set(0x26, 0x25, end,  catD)
 * @asm 0x074941  set(0x27, none, 0x28, catE)   0x074951 set(0x28,0x27,0x29,catE)
 * @asm 0x074962  set(0x29, 0x28, end,  catE)
 * Six magnitude fathers (setter 0x07638E, a_ax=0, push p2/-1/category):
 * @asm 0x074973  setv(idx 0x0B, mag 0x01F4=500,  cat0, p2=2)
 * @asm 0x074985  setv(idx 0x0D, mag 0x03E8=1000, cat1, p2=2)
 * @asm 0x074997  setv(idx 0x0E, mag 0x07D0=2000, cat2, p2=4)
 * @asm 0x0749A9  setv(idx 0x0F, mag 0x0BB8=3000, cat3, p2=6)
 * @asm 0x0749BB  setv(idx 0x10, mag 0x07D0=2000, cat4, p2=3)
 * @asm 0x0749CD  setv(idx 0x11, mag 0x1388=5000, cat5, p2=8)
 * @asm 0x0749DF  retf
 * ============================================================================ */
void func_0746BC_init_founding_fathers_table(void)
{
    /* category 0 */
    father_table_set_076384(0x00, 0xFFFF, 0, 0x01);  /* @asm 0x0746BC */
    father_table_set_076384(0x01, 0x00,   0, 0x02);  /* @asm 0x0746CB */
    father_table_set_076384(0x02, 0x01,   0, 0xFFFF);/* @asm 0x0746DA (next=end) */
    /* category 1 */
    father_table_set_076384(0x03, 0xFFFF, 1, 0x04);  /* @asm 0x0746EB */
    father_table_set_076384(0x04, 0x03,   1, 0x05);  /* @asm 0x074708 */
    father_table_set_076384(0x05, 0x04,   1, 0xFFFF);/* @asm 0x07470C */
    /* category 2 */
    father_table_set_076384(0x06, 0xFFFF, 2, 0x07);  /* @asm 0x07471D */
    father_table_set_076384(0x07, 0x06,   2, 0x08);  /* @asm 0x07472D */
    father_table_set_076384(0x08, 0x07,   2, 0xFFFF);/* @asm 0x07473E */
    /* category 3 (with the 0x1E/0x1F extension pair spliced after 0x0B) */
    father_table_set_076384(0x09, 0xFFFF, 3, 0xFFFF);/* @asm 0x07474F */
    father_table_set_076384(0x0A, 0x09,   3, 0x0B);  /* @asm 0x07475F */
    father_table_set_076384(0x0B, 0x0A,   3, 0xFFFF);/* @asm 0x074770 */
    father_table_set_076384(0x1E, 0x0B,   3, 0x1F);  /* @asm 0x074781 */
    father_table_set_076384(0x1F, 0x1E,   3, 0xFFFF);/* @asm 0x074792 */
    /* category 4 */
    father_table_set_076384(0x0C, 0xFFFF, 4, 0x0D);  /* @asm 0x0747A3 */
    father_table_set_076384(0x0D, 0x0C,   4, 0x0E);  /* @asm 0x0747B3 */
    father_table_set_076384(0x0E, 0x0D,   4, 0xFFFF);/* @asm 0x0747C4 */
    /* category 5 */
    father_table_set_076384(0x0F, 0xFFFF, 5, 0x10);  /* @asm 0x0747D5 */
    father_table_set_076384(0x10, 0x0F,   5, 0xFFFF);/* @asm 0x0747E5 */
    father_table_set_076384(0x11, 0xFFFF, 5, 0xFFFF);/* @asm 0x0747F6 */
    /* category 6 */
    father_table_set_076384(0x12, 0xFFFF, 6, 0xFFFF);/* @asm 0x074806 */
    /* category 7 */
    father_table_set_076384(0x13, 0xFFFF, 7, 0x14);  /* @asm 0x074816 */
    father_table_set_076384(0x14, 0x13,   7, 0xFFFF);/* @asm 0x074826 */
    /* category 8 */
    father_table_set_076384(0x15, 0xFFFF, 8, 0x16);  /* @asm 0x074837 */
    father_table_set_076384(0x16, 0x15,   8, 0x17);  /* @asm 0x074847 */
    father_table_set_076384(0x17, 0x16,   8, 0xFFFF);/* @asm 0x074858 */
    /* category 9 */
    father_table_set_076384(0x18, 0xFFFF, 9, 0x19);  /* @asm 0x074869 */
    father_table_set_076384(0x19, 0x18,   9, 0x1A);  /* @asm 0x074879 */
    father_table_set_076384(0x1A, 0x19,   9, 0xFFFF);/* @asm 0x07488A */
    /* category 0xA */
    father_table_set_076384(0x1B, 0xFFFF, 0xA, 0x1C);/* @asm 0x07489B */
    father_table_set_076384(0x1C, 0x1B,   0xA, 0x1D);/* @asm 0x0748AB */
    father_table_set_076384(0x1D, 0x1C,   0xA, 0xFFFF);/* @asm 0x0748BC */
    /* category 0xB */
    father_table_set_076384(0x20, 0xFFFF, 0xB, 0x21);/* @asm 0x0748CD */
    father_table_set_076384(0x21, 0x20,   0xB, 0x22);/* @asm 0x0748DD */
    father_table_set_076384(0x22, 0x21,   0xB, 0xFFFF);/* @asm 0x0748EE */
    /* category 0xC */
    father_table_set_076384(0x23, 0xFFFF, 0xC, 0xFFFF);/* @asm 0x0748FF */
    father_table_set_076384(0x24, 0x23,   0xC, 0xFFFF);/* @asm 0x07490F */
    /* category 0xD */
    father_table_set_076384(0x25, 0xFFFF, 0xD, 0xFFFF);/* @asm 0x074920 */
    father_table_set_076384(0x26, 0x25,   0xD, 0xFFFF);/* @asm 0x074930 */
    /* category 0xE */
    father_table_set_076384(0x27, 0xFFFF, 0xE, 0x28);/* @asm 0x074941 */
    father_table_set_076384(0x28, 0x27,   0xE, 0x29);/* @asm 0x074951 */
    father_table_set_076384(0x29, 0x28,   0xE, 0xFFFF);/* @asm 0x074962 */

    /* six magnitude fathers (index in dx, magnitude in bx, category pushed). */
    father_table_set_value_07638E(0, 0x0B, 0x01F4, 0, 0xFFFF, 2);  /* @asm 0x074973 mag 500  */
    father_table_set_value_07638E(0, 0x0D, 0x03E8, 1, 0xFFFF, 2);  /* @asm 0x074985 mag 1000 */
    father_table_set_value_07638E(0, 0x0E, 0x07D0, 2, 0xFFFF, 4);  /* @asm 0x074997 mag 2000 */
    father_table_set_value_07638E(0, 0x0F, 0x0BB8, 3, 0xFFFF, 6);  /* @asm 0x0749A9 mag 3000 */
    father_table_set_value_07638E(0, 0x10, 0x07D0, 4, 0xFFFF, 3);  /* @asm 0x0749BB mag 2000 */
    father_table_set_value_07638E(0, 0x11, 0x1388, 5, 0xFFFF, 8);  /* @asm 0x0749CD mag 5000 */
}

/* ============================================================================
 * func_0749E0 — load_names_data_tables  [DONE — section dispatch BYTE_VERIFIED;
 *               sub-loader fully traced: func_07637F@0x7637F→ljmp 0x1A1F:0xD20→body @0x72CC2]
 * ----------------------------------------------------------------------------
 * THE NAMES.TXT DATA-TABLE LOADER (project mem: NAMES.TXT is the canonical
 * source for all VICEROY game-data tables; this routine reads 38 named
 * @SECTIONs at game start).  Reseg size = 2417 bytes (stale banner "601").
 *
 * MECHANISM (byte-traced 0x0749E0..0x075350):
 *   1. lcall 0x181F:0x000E (NAMES parser init) with name @DS:0x1A2C ("EUROPE").
 *   2. For each section: push the section-name DS offset + a parser-tag word,
 *      lcall 0x191F:0x928 (find @SECTION), then a count-bounded loop that pulls
 *      fields via 0x191F:0x91C (next token) + one of:
 *         0x1A1F:0xB22 -> signed int word     (named "B22")
 *         0x1A1F:0xB16 -> unsigned/value word (named "B16")
 *         0x1A1F:0x88A -> byte                (named "88A")
 *         0x1A1F:0xB2E -> int word (UNIT tail) (named "B2E")
 *      storing into the per-table DGROUP array (the [bp-8] loop index scaled by
 *      the row stride).  Two sections (UNFORESTED/OTHER) and FORESTED delegate
 *      the per-entry name copy to near 0x4eef (= ljmp 0x1A1F:0xD20).
 *
 * CONFIRMED @SECTION -> DGROUP-array map (all DS offsets = file off + 0x1D9A0):
 *   @DS:0x21AC SEASONS      cnt 2    word[bx-0x6800]                @asm 0x0749F3
 *   @DS:0x21B4 UNFORESTED   cnt 8    near 0x4eef(idx)               @asm 0x074A22
 *   @DS:0x21BF FORESTED     cnt 8    near 0x4eef(idx+8); rep movsw  @asm 0x074A47
 *                                    16B row [bx+0x3074]<-[bx+0x2ff4]
 *   @DS:0x21C8 OTHER        cnt 5    near 0x4eef(idx+0x18)          @asm 0x074A87
 *   @DS:0x21CE OTHER_NAMES  cnt 5    word[bx+0x2db0]                @asm 0x074AB0
 *   @DS:0x21DA RESOURCE     cnt 0xE  word[bx-0x6cf4]+byte[bx-0x684e]@asm 0x074ADE
 *   @DS:0x21E3 COUNTRY      cnt 4    word[bx-0x72be]+byte[bx+0x848] @asm 0x074B18
 *   @DS:0x21EB NATIONALITY  cnt 4    word[bx-0x72f6]                @asm 0x074B52
 *   @DS:0x21F7 NATIONABBREV cnt 4    word[bx-0x6810]                @asm 0x074B7B
 *   @DS:0x2204 HOMEPORT     cnt 4    word[bx-0x7c74]                @asm 0x074BA4
 *   @DS:0x220D COLONYNAME   cnt 4    strcpy ds:ax -> [idx*0x34+0x5426] @asm 0x074BCD
 *   @DS:0x2218 LEADERNAME   cnt 4    strcpy -> [idx*0x34+0x540e]     @asm 0x074C00
 *                                    (AIPersonality)+3 bytes[bx-0x6a9a..]
 *   @DS:0x2223 MISSION      cnt 4    word[bx-0x6808]                @asm 0x074C5E
 *   @DS:0x222B DIFFICULTY   cnt 5    word[bx-0x7c6c]                @asm 0x074C87
 *   @DS:0x2236 CLASS        cnt 8    word[bx-0x69fe](*4)+word[si-0x69fc] @asm 0x074CB0
 *   @DS:0x223C BUILDING     cnt 0x2A word[bx-0x707e](*0xC)+word[si-0x7074]+ @asm 0x074CEA
 *                                    bytes[si-0x7077/-0x7079/-0x7076/-0x7075]
 *   @DS:0x2245 SCENARIO     cnt 4    byte[bx-0x77c6]+byte[si-0x77c5] @asm 0x074D4E
 *                                    (PowerRecord stride 0x13C)
 *   @DS:0x224E JOB          cnt 0x1C word[bx-0x715e](*8)+word[si-0x715c]+ @asm 0x074DDA
 *                                    word[si-0x715a]+word[si-0x7158]
 *   @DS:0x2252 CARGO        cnt 0x14 word[bx-0x6840]; if idx<0x10        @asm 0x074E6B
 *                                    9 bytes[bx-0x6904..-0x68fc]; then a
 *                                    derived byte[bx+0x2f7a] for idx 0..0x1C
 *   @DS:0x2258 UNIT         cnt 0x17 word[bx+0x5230](*0xE)+9 bytes        @asm 0x074EC3
 *                                    [si+0x5232..0x523d] (last via 0xB2E)
 *   @DS:0x225D ORDERS       cnt 0xD  byte[bx+0x54de] (space-skip parse)   @asm 0x074F69
 *   @DS:0x2264 ACTIONS      cnt 0xA  word[bx-0x6cd6]                      @asm 0x074FC4
 *   @DS:0x226C VALUES       cnt 4    word[bx-0x6cc0]                      @asm 0x074FED
 *   @DS:0x2273 ATTITUDE     cnt 5    word[bx-0x6cb8]                      @asm 0x075016
 *   @DS:0x227C ATTITUDINAL  cnt 5    word[bx-0x6cae]                      @asm 0x07503F
 *   @DS:0x2288 LEVELS       cnt 5    word[bx-0x69ce](*6)+2 words[si-..]   @asm 0x075068
 *   @DS:0x228F TRIBES       cnt 8    word[bx-0x72ee](*6)+2 words+2 bytes+ @asm 0x0750B0
 *                                    byte[bx+0x84c]
 *   @DS:0x2296 FOUNDING     cnt 6    word[bx-0x6918]                      @asm 0x075109
 *   @DS:0x229F FATHERS      cnt 0x19 word[bx-0x69ae](*6)+4 bytes[si-..]   @asm 0x075132
 *   @DS:0x22A7 COLORS       opt      (if found) 9 bytes[0x830..0x839]     @asm 0x07518C
 *   @DS:0x22AE INFO         cnt 4    word[bx-0x690c] (tag 0x888)          @asm 0x0751EA
 *   @DS:0x22B3 MISC         cnt 0xDD word[bx+0x2dba]                      @asm 0x075214
 *   @DS:0x22B8 ROUTE        cnt 9    word[bx-0x6c22]                      @asm 0x07523E
 *   @DS:0x22BE CMISC        cnt 3    word[bx-0x6c68]                      @asm 0x075267
 *   @DS:0x22C4 CTITLE       cnt 0xA  word[bx-0x6c62]                      @asm 0x075290
 *   @DS:0x22CB CMESSAGE     cnt 0x13 word[bx-0x6c4e]                      @asm 0x0752B9
 *   @DS:0x22D4 EUROLABEL    cnt 3    word[bx-0x6c28]                      @asm 0x0752E2
 *   @DS:0x22DE MISCELLANEOUS cnt=[0x846] word[bx-0x6ca4]; count read from @asm 0x07530B
 *                                    @DS:0x22EC ("PEDIA") via 0x191F:0x91C +
 *                                    0x0D1D:0x8F6(@0x833c) -> [0x846]
 *
 * Per-entry name sub-loaders (UNFORESTED/FORESTED/OTHER) call func_07637F@0x7637F
 * (near call) → ljmp 0x1A1F:0xD20 → body @file 0x72CC2 (695 bytes, ENTER 0x276).
 * BYTE_VERIFIED 2026-06-08: args (max_entries=[bp+8], idx=[bp+6]); reads NAMES.TXT
 * section via get_section(DS:0x087C, idx) @0x191F:0x182; per-entry loading-flag
 * written at DS:0xA60C+entry_idx; terrain names interned via lcall 0x191F:0x176;
 * far-ptr strncpy dest via DS:0x9800 table.  Note: DS:0x2F76 terrain-cost table
 * is NOT written here (linker-initialized; populated by a different function).
 *
 * @asm 0x0749EB  lcall 0x181F:0x000E         (NAMES init, name @DS:0x1A2C "EUROPE")
 * @asm 0x0749F9  lcall 0x191F:0x928          (find @SECTION @DS:0x21AC "SEASONS")
 * @asm 0x074A06  loop: lcall 0x191F:0x91C ; 0x1A1F:0xB22 -> word[bx-0x6800]
 * @asm 0x074A7C  rep movsw cx=8              (copy 16-byte FORESTED config row)
 * @asm 0x07534D  pop si; pop di; leave; @asm 0x075350 retf
 * @status DONE — section dispatch byte-verified; sub-loader chain fully traced:
 *   func_07637F@0x7637F → ljmp 0x1A1F:0xD20 → body @0x72CC2 BYTE_VERIFIED 2026-06-08
 */
int func_0749E0_load_names_data_tables(void)
{
    int i;     /* [bp-8] -- per-section field index */
    int p;     /* [bp-6] -- SCENARIO per-power index */
    int j;     /* [bp-4] -- CARGO inner derived-byte index */
    int count; /* [0x846] -- MISCELLANEOUS dynamic entry count */

    overlay_call_181F_000E();                 /* @asm 0x0749EB NAMES init(@0x1A2C "EUROPE") */

    /* ---- SEASONS @DS:0x21AC : 2 ints -> word[i-0x6800] ---- @asm 0x0749F3 */
    overlay_call_191F_0928();                                  /* @asm 0x0749F9 find SEASONS */
    for (i = 0; i < 2; i++) {                                  /* @asm 0x074A1C cmp,2 */
        overlay_call_191F_091C();                              /* @asm 0x074A06 next token */
        *((uint16_t near *)((i << 1) - 0x6800)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x074A0B/074A15 */
    }

    /* ---- UNFORESTED @DS:0x21B4 : 8 entries via sub-loader ---- @asm 0x074A22 */
    overlay_call_191F_0928();                                  /* @asm 0x074A27 find UNFORESTED */
    for (i = 0; i < 8; i++)                                    /* @asm 0x074A41 cmp,8 */
        page1A_names_subloader(i);                             /* @asm 0x074A38 -> func_07637F @0x7637F -> ljmp 0x1A1F:0xD20 body @0x72CC2 */

    /* ---- FORESTED @DS:0x21BF : 8 entries; sub-loader(idx+8) then copy a
     * 16-byte config row [bx+0x3074] <- [bx+0x2ff4] ---- @asm 0x074A47 */
    overlay_call_191F_0928();                                  /* @asm 0x074A4C find FORESTED */
    for (i = 0; i < 8; i++) {                                  /* @asm 0x074A81 cmp,8 */
        page1A_names_subloader(i + 8);                         /* @asm 0x074A61 -> func_07637F @0x7637F -> ljmp 0x1A1F:0xD20 body @0x72CC2 */
        {   /* @asm 0x074A7C rep movsw cx=8 : 16-byte row copy */
            uint16_t near *dst = (uint16_t near *)((i << 4) + 0x3074); /* @asm 0x074A6D */
            uint16_t near *src = (uint16_t near *)((i << 4) + 0x2FF4); /* @asm 0x074A71 */
            int w;
            for (w = 0; w < 8; w++) dst[w] = src[w];           /* @asm 0x074A7C */
        }
    }

    /* ---- OTHER @DS:0x21C8 : 5 entries via sub-loader(idx+0x18) ---- @asm 0x074A87 */
    overlay_call_191F_0928();                                  /* @asm 0x074A8C find OTHER */
    for (i = 0; i < 5; i++)                                    /* @asm 0x074AAA cmp,5 */
        page1A_names_subloader(i + 0x18);                      /* @asm 0x074AA1 -> func_07637F @0x7637F -> ljmp 0x1A1F:0xD20 body @0x72CC2 */

    /* ---- OTHER_NAMES @DS:0x21CE : 5 ints -> word[i+0x2db0] ---- @asm 0x074AB0 */
    overlay_call_191F_0928();                                  /* @asm 0x074AB5 find OTHER_NAMES */
    for (i = 0; i < 5; i++) {                                  /* @asm 0x074AD8 cmp,5 */
        overlay_call_191F_091C();                              /* @asm 0x074AC2 */
        *((uint16_t near *)((i << 1) + 0x2DB0)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x074AC7/074AD1 */
    }

    /* ---- RESOURCE @DS:0x21DA : 0xE rows {int word[i-0x6cf4], byte[i-0x684e]} ---- @asm 0x074ADE */
    overlay_call_191F_0928();                                  /* @asm 0x074AE3 find RESOURCE */
    for (i = 0; i < 0xE; i++) {                                /* @asm 0x074B12 cmp,0xe */
        overlay_call_191F_091C();                              /* @asm 0x074AF0 */
        *((uint16_t near *)((i << 1) - 0x6CF4)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x074AF5/074AFF */
        *((uint8_t  near *)(i - 0x684E)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074B03/074B0B */
    }

    /* ---- COUNTRY @DS:0x21E3 : 4 rows {int word[i-0x72be], byte[i+0x848]} ---- @asm 0x074B18 */
    overlay_call_191F_0928();                                  /* @asm 0x074B1D find COUNTRY */
    for (i = 0; i < 4; i++) {                                  /* @asm 0x074B4C cmp,4 */
        overlay_call_191F_091C();                              /* @asm 0x074B2A */
        *((uint16_t near *)((i << 1) - 0x72BE)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x074B2F/074B39 */
        *((uint8_t  near *)(i + 0x848)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074B3D/074B45 */
    }

    /* ---- NATIONALITY @DS:0x21EB : 4 values -> word[i-0x72f6] ---- @asm 0x074B52 */
    overlay_call_191F_0928();                                  /* @asm 0x074B57 find NATIONALITY */
    for (i = 0; i < 4; i++)                                    /* @asm 0x074B75 cmp,4 */
        *((uint16_t near *)((i << 1) - 0x72F6)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x074B64/074B6E */

    /* ---- NATIONABBREV @DS:0x21F7 : 4 values -> word[i-0x6810] ---- @asm 0x074B7B */
    overlay_call_191F_0928();                                  /* @asm 0x074B80 find NATIONABBREV */
    for (i = 0; i < 4; i++)                                    /* @asm 0x074B9E cmp,4 */
        *((uint16_t near *)((i << 1) - 0x6810)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x074B8D/074B97 */

    /* ---- HOMEPORT @DS:0x2204 : 4 values -> word[i-0x7c74] ---- @asm 0x074BA4 */
    overlay_call_191F_0928();                                  /* @asm 0x074BA9 find HOMEPORT */
    for (i = 0; i < 4; i++)                                    /* @asm 0x074BC7 cmp,4 */
        *((uint16_t near *)((i << 1) - 0x7C74)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x074BB6/074BC0 */

    /* ---- COLONYNAME @DS:0x220D : 4 names -> strcpy into [i*0x34+0x5426] ---- @asm 0x074BCD */
    overlay_call_191F_0928();                                  /* @asm 0x074BD2 find COLONYNAME */
    for (i = 0; i < 4; i++) {                                  /* @asm 0x074BFA cmp,4 */
        overlay_call_191F_091C();                              /* @asm 0x074BDF token (ds:ax src) */
        overlay_call_0D1D_117E();                              /* @asm 0x074BEF strcpy(@i*0x34+0x5426, src) */
    }

    /* ---- LEADERNAME @DS:0x2218 : 4 rows {strcpy name -> AIPersonality
     * [i*0x34+0x540e], then 3 bytes[i*3-0x6a9a/-0x6a99/-0x6a98]} ---- @asm 0x074C00 */
    overlay_call_191F_0928();                                  /* @asm 0x074C05 find LEADERNAME */
    for (i = 0; i < 4; i++) {                                  /* @asm 0x074C58 cmp,4 */
        overlay_call_191F_091C();                              /* @asm 0x074C12 */
        overlay_call_191F_0FC4();                              /* @asm 0x074C17 (name helper) */
        overlay_call_0D1D_117E();                              /* @asm 0x074C27 strcpy(@i*0x34+0x540e) */
        *((uint8_t near *)(i * 3 - 0x6A9A)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074C2F/074C3D */
        *((uint8_t near *)(i * 3 - 0x6A99)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074C43/074C48 */
        *((uint8_t near *)(i * 3 - 0x6A98)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074C4C/074C51 */
    }

    /* ---- MISSION @DS:0x2223 : 4 values -> word[i-0x6808] ---- @asm 0x074C5E */
    overlay_call_191F_0928();                                  /* @asm 0x074C63 find MISSION */
    for (i = 0; i < 4; i++)                                    /* @asm 0x074C81 cmp,4 */
        *((uint16_t near *)((i << 1) - 0x6808)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x074C70/074C7A */

    /* ---- DIFFICULTY @DS:0x222B : 5 values -> word[i-0x7c6c] ---- @asm 0x074C87 */
    overlay_call_191F_0928();                                  /* @asm 0x074C8C find DIFFICULTY */
    for (i = 0; i < 5; i++)                                    /* @asm 0x074CAA cmp,5 */
        *((uint16_t near *)((i << 1) - 0x7C6C)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x074C99/074CA3 */

    /* ---- CLASS @DS:0x2236 : 8 rows {int word[i*4-0x69fe], byte/word[si-0x69fc]} ---- @asm 0x074CB0 */
    overlay_call_191F_0928();                                  /* @asm 0x074CB5 find CLASS */
    for (i = 0; i < 8; i++) {                                  /* @asm 0x074CE4 cmp,8 */
        overlay_call_191F_091C();                              /* @asm 0x074CC2 */
        *((uint16_t near *)((i << 2) - 0x69FE)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x074CC7/074CD2 */
        *((uint16_t near *)((i << 2) - 0x69FC)) =
            (uint16_t)overlay_call_1A1F_088A();                /* @asm 0x074CD8/074CDD */
    }

    /* ---- BUILDING @DS:0x223C : 0x2A rows, stride 0xC at base -0x707e ---- @asm 0x074CEA
     * {int word[si-0x707e], word[si-0x7074], byte[si-0x7077], byte[si-0x7079],
     *  byte[si-0x7076], byte[si-0x7075]} (si = i*0xC) */
    overlay_call_191F_0928();                                  /* @asm 0x074CEF find BUILDING */
    for (i = 0; i < 0x2A; i++) {                               /* @asm 0x074D48 cmp,0x2a */
        int si = i * 0xC;                                      /* @asm 0x074D09 i*3<<2 */
        overlay_call_191F_091C();                              /* @asm 0x074CFC */
        *((uint16_t near *)(si - 0x707E)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x074D01/074D12 */
        *((uint16_t near *)(si - 0x7074)) =
            (uint16_t)overlay_call_1A1F_088A();                /* @asm 0x074D18/074D1D */
        *((uint8_t  near *)(si - 0x7077)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074D21/074D26 */
        *((uint8_t  near *)(si - 0x7079)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074D2A/074D2F */
        *((uint8_t  near *)(si - 0x7076)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074D33/074D38 */
        *((uint8_t  near *)(si - 0x7075)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074D3C/074D41 */
    }

    /* ---- SCENARIO @DS:0x2245 : 4 PowerRecords (stride 0x13C), {byte[-0x77c6],
     * byte[-0x77c5]} -- the home-coord seed used by func_0755CC ---- @asm 0x074D4E */
    overlay_call_191F_0928();                                  /* @asm 0x074D53 find SCENARIO */
    overlay_call_191F_091C();                                  /* @asm 0x074D5B token */
    overlay_call_191F_0FC4();                                  /* @asm 0x074D60 helper */
    for (p = 0; p < 4; p++) {                                  /* @asm 0x074D86 cmp,4 */
        int bx = p * 0x13C;                                    /* @asm 0x074D6F imul 0x13c */
        *((uint8_t near *)(bx - 0x77C6)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074D6A/074D74 home x */
        *((uint8_t near *)(bx - 0x77C5)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074D7A/074D7F home y */
    }

    /* ---- JOB @DS:0x224E : 0x1C rows (stride 8 at base -0x715e), {int word,
     * int word[si-0x715c], byte->word[si-0x715a], byte->word[si-0x7158]} ---- @asm 0x074DDA */
    overlay_call_191F_0928();                                  /* @asm 0x074DDF find JOB */
    for (i = 0; i < 0x1C; i++) {                               /* @asm 0x074DD4 cmp,0x1c */
        int si = i << 3;                                       /* @asm 0x074DAB shl 3 */
        overlay_call_191F_091C();                              /* @asm 0x074DEC */
        *((uint16_t near *)(si - 0x715E)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x074DF1/074DAE */
        *((uint16_t near *)(si - 0x715C)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x074DB4/074DB9 */
        *((uint16_t near *)(si - 0x715A)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074DBD/074DC4 (sub ah,ah) */
        *((uint16_t near *)(si - 0x7158)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074DC8/074DCD */
    }

    /* ---- CARGO @DS:0x2252 : 0x14 rows {int word[i-0x6840]; if i<0x10 then 9
     * bytes[i*9-0x6904..-0x68fc]}, then a derived max byte[i*0x10+0x2f7a] for
     * i=0..0x1C ---- @asm 0x074E6B  (project mem: @CARGO high/volatility table) */
    overlay_call_191F_0928();                                  /* @asm 0x074E6B find CARGO */
    for (i = 0; i < 0x14; i++) {                               /* @asm 0x074E65 cmp,0x14 */
        overlay_call_191F_091C();                              /* @asm 0x074DEC */
        *((uint16_t near *)((i << 1) - 0x6840)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x074DF1/074DFB */
        if (i < 0x10) {                                        /* @asm 0x074DFF cmp,0x10 jge */
            int si = i * 9;                                    /* @asm 0x074E0F shl3;add */
            int b;
            for (b = 0; b < 9; b++)                            /* @asm 0x074E05..0x074E59 (9x 88A) */
                *((uint8_t near *)(si + b - 0x6904)) =
                    (uint8_t)overlay_call_1A1F_088A();
        }
    }
    /* derived per-cargo max -> byte[i*0x10+0x2f7a] (uses the func_0745F0 scratch
     * record bytes [bx+si+0x2f7b]); @asm 0x074E6B..0x074EC1 */
    for (i = 0; i < 0x1D; i++) {                               /* @asm 0x074EBD cmp,0x1d */
        int maxv = 0;                                          /* [bp-0xa] */
        for (j = 1; j < 9; j++) {                              /* @asm 0x074EA7 cmp,9 */
            int prod = (int8_t)*((uint8_t near *)((j << 3) + j - 0x6903)) /* @asm 0x074E84 cargo weight */
                     * (int8_t)*((uint8_t near *)(j /*[bp-4]*/ + (i << 4) + 0x2F7B)); /* @asm 0x074E94 */
            if (prod > maxv) maxv = prod;                      /* @asm 0x074E9C/074EA1 */
        }
        *((uint8_t near *)((i << 4) + 0x2F7A)) = (uint8_t)maxv;/* @asm 0x074EAD/074EB6 */
    }

    /* ---- UNIT @DS:0x2258 : 0x17 rows (stride 0xE at base 0x5230) ---- @asm 0x074EC3
     * {int word[bx+0x5230], byte[si+0x5232], (2*byte+byte)[si+0x5234],
     *  bytes[si+0x5236/0x5235/0x5237..0x523c], last via 0x1A1F:0xB2E[si+0x523d]}.
     * project mem: ICONS sprite index = @UNIT col-1 (the word[bx+0x5230]). */
    overlay_call_191F_0928();                                  /* @asm 0x074EC8 find UNIT */
    for (i = 0; i < 0x17; i++) {                               /* @asm 0x074F60 cmp,0x17 */
        int si = i * 0xE;                                      /* @asm 0x074E2 i*3<<1 */
        overlay_call_191F_091C();                              /* @asm 0x074ED5 */
        *((uint16_t near *)(si + 0x5230)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x074EDA/074EEE col-1 (ICONS idx) */
        *((uint8_t near *)(si + 0x5232)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x074EF4/074EF9 */
        {   /* @asm 0x074F02 al = b*3 (shl1+add) */
            uint8_t b = (uint8_t)overlay_call_1A1F_088A();     /* @asm 0x074EFD */
            *((uint8_t near *)(si + 0x5234)) = (uint8_t)(b * 3); /* @asm 0x074F08 */
        }
        *((uint8_t near *)(si + 0x5236)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x074F0C/074F11 */
        *((uint8_t near *)(si + 0x5235)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x074F15/074F1A */
        *((uint8_t near *)(si + 0x5237)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x074F1E/074F23 */
        *((uint8_t near *)(si + 0x5238)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x074F27/074F2C */
        *((uint8_t near *)(si + 0x5239)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x074F30/074F35 */
        *((uint8_t near *)(si + 0x523A)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x074F39/074F3E */
        *((uint8_t near *)(si + 0x523B)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x074F42/074F47 */
        *((uint8_t near *)(si + 0x523C)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x074F4B/074F50 */
        *((uint8_t near *)(si + 0x523D)) = (uint8_t)overlay_call_1A1F_0B2E(); /* @asm 0x074F54/074F59 */
    }

    /* ---- ORDERS @DS:0x225D (tag 0x882) : 0xD entries; for each, skip spaces in
     * the token then store the first non-space byte -> byte[i+0x54de] ---- @asm 0x074F69 */
    overlay_call_191F_0928();                                  /* @asm 0x074F6F find ORDERS */
    for (i = 0; i < 0xD; i++) {                                /* @asm 0x074F9D cmp,0xd */
        overlay_call_191F_091C();                              /* @asm 0x074FA3 token */
        overlay_call_191F_0FC4();                              /* @asm 0x074FB6 (token ptr helper) */
        /* skip ' ' chars to first non-space; @asm 0x074F7E..0x074F8E */
        *((uint8_t near *)(i + 0x54DE)) = 0;                   /* @asm 0x074F90/074F96 store byte */
    }

    /* ---- ACTIONS @DS:0x2264 : 0xA values -> word[i-0x6cd6] ---- @asm 0x074FC4 */
    overlay_call_191F_0928();                                  /* @asm 0x074FC9 find ACTIONS */
    for (i = 0; i < 0xA; i++)                                  /* @asm 0x074FE7 cmp,0xa */
        *((uint16_t near *)((i << 1) - 0x6CD6)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x074FD6/074FE0 */

    /* ---- VALUES @DS:0x226C : 4 values -> word[i-0x6cc0] ---- @asm 0x074FED */
    overlay_call_191F_0928();                                  /* @asm 0x074FF2 find VALUES */
    for (i = 0; i < 4; i++)                                    /* @asm 0x075010 cmp,4 */
        *((uint16_t near *)((i << 1) - 0x6CC0)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x074FFF/075009 */

    /* ---- ATTITUDE @DS:0x2273 : 5 values -> word[i-0x6cb8] ---- @asm 0x075016 */
    overlay_call_191F_0928();                                  /* @asm 0x07501B find ATTITUDE */
    for (i = 0; i < 5; i++)                                    /* @asm 0x075039 cmp,5 */
        *((uint16_t near *)((i << 1) - 0x6CB8)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x075028/075032 */

    /* ---- ATTITUDINAL @DS:0x227C : 5 values -> word[i-0x6cae] ---- @asm 0x07503F */
    overlay_call_191F_0928();                                  /* @asm 0x075044 find ATTITUDINAL */
    for (i = 0; i < 5; i++)                                    /* @asm 0x075062 cmp,5 */
        *((uint16_t near *)((i << 1) - 0x6CAE)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x075051/07505B */

    /* ---- LEVELS @DS:0x2288 : 5 rows (stride 6 at base -0x69ce), 3 ints ---- @asm 0x075068 */
    overlay_call_191F_0928();                                  /* @asm 0x07506D find LEVELS */
    for (i = 0; i < 5; i++) {                                  /* @asm 0x0750AA cmp,5 */
        int si = i * 6;                                        /* @asm 0x075089 i*3<<1 */
        overlay_call_191F_091C();                              /* @asm 0x07507A */
        *((uint16_t near *)(si - 0x69CE)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x07507F/07508F */
        *((uint16_t near *)(si - 0x69CC)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x075095/07509A */
        *((uint16_t near *)(si - 0x69CA)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x07509E/0750A3 */
    }

    /* ---- TRIBES @DS:0x228F : 8 rows (stride 6 at base -0x72ee) ---- @asm 0x0750B0
     * {3 ints[si-0x72ee/-0x72ec/-0x72ea], 2 discard bytes, byte[i+0x84c]}.
     * project mem: @TRIBES col-5 is the VICEROY.PAL marker color. */
    overlay_call_191F_0928();                                  /* @asm 0x0750B5 find TRIBES */
    for (i = 0; i < 8; i++) {                                  /* @asm 0x075103 cmp,8 */
        int si = i * 6;                                        /* @asm 0x0750D1 */
        overlay_call_191F_091C();                              /* @asm 0x0750C2 */
        *((uint16_t near *)(si - 0x72EE)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x0750C7/0750D7 */
        *((uint16_t near *)(si - 0x72EC)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x0750DD/0750E2 */
        *((uint16_t near *)(si - 0x72EA)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x0750E6/0750EB */
        overlay_call_1A1F_088A();                              /* @asm 0x0750EF discard */
        *((uint8_t near *)(i + 0x84C)) =
            (uint8_t)overlay_call_1A1F_088A();                 /* @asm 0x0750F4/0750FC (col-5 PAL color) */
    }

    /* ---- FOUNDING @DS:0x2296 : 6 values -> word[i-0x6918] ---- @asm 0x075109 */
    overlay_call_191F_0928();                                  /* @asm 0x07510E find FOUNDING */
    for (i = 0; i < 6; i++)                                    /* @asm 0x07512C cmp,6 */
        *((uint16_t near *)((i << 1) - 0x6918)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x07511B/075125 */

    /* ---- FATHERS @DS:0x229F : 0x19 rows (stride 6 at base -0x69ae) ---- @asm 0x075132
     * {int word, 4 bytes[si-0x69ac..-0x69a9]} */
    overlay_call_191F_0928();                                  /* @asm 0x075137 find FATHERS */
    for (i = 0; i < 0x19; i++) {                               /* @asm 0x075186 cmp,0x19 */
        int si = i * 6;                                        /* @asm 0x075153 */
        overlay_call_191F_091C();                              /* @asm 0x075144 */
        *((uint16_t near *)(si - 0x69AE)) =
            (uint16_t)overlay_call_1A1F_0B22();                /* @asm 0x075149/075159 */
        *((uint8_t near *)(si - 0x69AC)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x07515F/075164 */
        *((uint8_t near *)(si - 0x69AB)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x075168/07516D */
        *((uint8_t near *)(si - 0x69AA)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x075171/075176 */
        *((uint8_t near *)(si - 0x69A9)) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x07517A/07517F */
    }

    /* ---- COLORS @DS:0x22A7 : OPTIONAL (if section present) 9 bytes ---- @asm 0x07518C
     * -> byte[0x830..0x835], byte[0x837..0x839] (0x836 skipped) */
    if (overlay_call_191F_0928() == 0) {                       /* @asm 0x075191 find COLORS; je skip */
        overlay_call_191F_091C();                              /* @asm 0x07519D */
        *((uint8_t near *)0x0830) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x0751A2/0751A7 */
        *((uint8_t near *)0x0831) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x0751AA/0751AF */
        *((uint8_t near *)0x0832) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x0751B2/0751B7 */
        *((uint8_t near *)0x0833) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x0751BA/0751BF */
        *((uint8_t near *)0x0834) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x0751C2/0751C7 */
        *((uint8_t near *)0x0835) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x0751CA/0751CF */
        *((uint8_t near *)0x0837) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x0751D2/0751D7 */
        *((uint8_t near *)0x0838) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x0751DA/0751DF */
        *((uint8_t near *)0x0839) = (uint8_t)overlay_call_1A1F_088A(); /* @asm 0x0751E2/0751E7 */
    }

    /* ---- INFO @DS:0x22AE (tag 0x888) : 4 values -> word[i-0x690c] ---- @asm 0x0751EA */
    overlay_call_191F_0928();                                  /* @asm 0x0751F0 find INFO */
    for (i = 0; i < 4; i++)                                    /* @asm 0x07520E cmp,4 */
        *((uint16_t near *)((i << 1) - 0x690C)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x0751FD/075207 */

    /* ---- MISC @DS:0x22B3 : 0xDD values -> word[i+0x2dba] ---- @asm 0x075214 */
    overlay_call_191F_0928();                                  /* @asm 0x075219 find MISC */
    for (i = 0; i < 0xDD; i++)                                 /* @asm 0x075237 cmp,0xdd */
        *((uint16_t near *)((i << 1) + 0x2DBA)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x075226/075230 */

    /* ---- ROUTE @DS:0x22B8 : 9 values -> word[i-0x6c22] ---- @asm 0x07523E */
    overlay_call_191F_0928();                                  /* @asm 0x075243 find ROUTE */
    for (i = 0; i < 9; i++)                                    /* @asm 0x075261 cmp,9 */
        *((uint16_t near *)((i << 1) - 0x6C22)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x075250/07525A */

    /* ---- CMISC @DS:0x22BE : 3 values -> word[i-0x6c68] ---- @asm 0x075267 */
    overlay_call_191F_0928();                                  /* @asm 0x07526C find CMISC */
    for (i = 0; i < 3; i++)                                    /* @asm 0x07528A cmp,3 */
        *((uint16_t near *)((i << 1) - 0x6C68)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x075279/075283 */

    /* ---- CTITLE @DS:0x22C4 : 0xA values -> word[i-0x6c62] ---- @asm 0x075290 */
    overlay_call_191F_0928();                                  /* @asm 0x075295 find CTITLE */
    for (i = 0; i < 0xA; i++)                                  /* @asm 0x0752B3 cmp,0xa */
        *((uint16_t near *)((i << 1) - 0x6C62)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x0752A2/0752AC */

    /* ---- CMESSAGE @DS:0x22CB : 0x13 values -> word[i-0x6c4e] ---- @asm 0x0752B9 */
    overlay_call_191F_0928();                                  /* @asm 0x0752BE find CMESSAGE */
    for (i = 0; i < 0x13; i++)                                 /* @asm 0x0752DC cmp,0x13 */
        *((uint16_t near *)((i << 1) - 0x6C4E)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x0752CB/0752D5 */

    /* ---- EUROLABEL @DS:0x22D4 : 3 values -> word[i-0x6c28] ---- @asm 0x0752E2 */
    overlay_call_191F_0928();                                  /* @asm 0x0752E7 find EUROLABEL */
    for (i = 0; i < 3; i++)                                    /* @asm 0x075305 cmp,3 */
        *((uint16_t near *)((i << 1) - 0x6C28)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x0752F4/0752FE */

    /* ---- MISCELLANEOUS @DS:0x22DE : dynamic count from the PEDIA token ---- @asm 0x07530B
     * find MISCELLANEOUS (tag @DS:0x22EC "PEDIA"); first token -> count via
     * 0x0D1D:0x8F6(@0x833c) -> [0x846]; then [count] values -> word[i-0x6ca4]. */
    overlay_call_191F_0928();                                  /* @asm 0x075311 find MISCELLANEOUS */
    overlay_call_191F_091C();                                  /* @asm 0x075319 token (the count) */
    count = overlay_call_0D1D_08F6();                          /* @asm 0x075321 atoi(@0x833c) */
    *((uint16_t near *)0x0846) = (uint16_t)count;              /* @asm 0x075329 [0x846]=count */
    for (i = 0; i < count; i++)                                /* @asm 0x075345 cmp [bp-8],[0x846] */
        *((uint16_t near *)((i << 1) - 0x6CA4)) =
            (uint16_t)overlay_call_1A1F_0B16();                /* @asm 0x075334/07533E */

    return 0;                                                  /* @asm 0x07534D leave; 0x075350 retf */
}

/* ============================================================================
 * func_075352 — show_power_relations_dialog  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Builds and shows a modal text dialog (a per-power relations / war-status
 * box).  Saves text-state [0x372], formats a base string @DS:0x22F2 via
 * 0x0D1D:0x7E4 (strcpy) + 0x181F:0x182 (append arg0), measures fit with
 * 0x181F:0x44E (returns nonzero -> bail to cleanup), then by current human
 * marker [0x5398] (0..3) appends one of @DS:0x22FA / 0x2301 / 0x2308 / 0x230E,
 * looks up a record via 0x191F:0xFDE+0xFD0 and draws a value bar (0x181F:0x2F8)
 * using its +0x46/+0x48 fields, optionally appends a second clause keyed by
 * [bp+6]==1 && [bp+8]==1 (@DS:0x2314/0x231A/0x2323), then composes the box
 * (0x181F:0x3B6 push-state, 0x3F4 blit, 0x444 box, 0xE2 frame), prompts with
 * 0x1A1F:0xA86 (@DS:0x232B), saves/restores cursor state [0x1F4A/0x1F50/0x1F52/
 * 0x1F56], draws via 0x181F:0x3FE, restores [0x268A:0x268C]->[0x1F9E:0x1FA0],
 * sets [0x1F64]=1 and restores [0x372].
 *
 * @asm 0x075360  mov ax,[0x372] ; @asm 0x075368 [0x372]=0 ; [0x1F64]=0   (save text-state)
 * @asm 0x075375  lcall 0x0D1D:0x7E4 strcpy(@bp-0x20, @DS:0x22F2)
 * @asm 0x075385  lcall 0x181F:0x182 append(arg0_bp_06)
 * @asm 0x0753A9  lcall 0x181F:0x44E fit?  -> @asm 0x0753B5 if nonzero jmp cleanup 0x075563
 * @asm 0x0753B8  switch([0x5398]): 0->@0x22FA 1->@0x2301 2->@0x2308 3->@0x230E
 * @asm 0x0753FB  lcall 0x191F:0xFDE ; @asm 0x075405 lcall 0x191F:0xFD0 (record lookup)
 * @asm 0x07542B  lcall 0x181F:0x2F8 draw bar( rec[+0x48], 0x64, rec[+0x46], @0x839E )
 * @asm 0x075430  if [bp+6]==1: @asm 0x075436 if [bp+8]==1 append @0x2314 else @0x231A else @0x2323
 * @asm 0x0754A2  0x181F:0x3B6 / @0x4012 0x181F:0x3F4 / @0x404B 0x444 / @0x405D 0xE2  (compose box)
 * @asm 0x0754F6  lcall 0x1A1F:0xA86 prompt(@DS:0x232B)
 * @asm 0x075518  save [0x1F4A/0x1F50/0x1F52]; set [0x1F4A]=0xF2 [0x1F50]=0x2F [0x1F52]=0; or [0x1F56]|=0x18
 * @asm 0x075540  lcall 0x181F:0x3FE draw text (bx=[bp+0xa]); restore cursor state
 * @asm 0x075563  cleanup: if prompt result nonzero -> 0x191F:0x1A8 free
 * @asm 0x075576  [0x1F9E:0x1FA0]=[0x268A:0x268C]; [0x1F64]=1; [0x372]=saved
 * @status DONE
 */
int func_075352_show_power_relations_dialog(uint16_t arg0_bp_06, uint16_t arg1_bp_08,
                                            uint16_t arg2_bp_0A)
{
    uint16_t saved_text_state;                /* [bp-8] */
    uint32_t prompt_result;                   /* [bp-0xc:bp-0xa] */

    saved_text_state = *((uint16_t near *)0x0372);  /* @asm 0x075360 */
    *((uint16_t near *)0x0372) = 0;                 /* @asm 0x075368 */
    *((uint16_t near *)0x1F64) = 0;                 /* @asm 0x07536B */

    overlay_call_0D1D_07E4();                 /* @asm 0x075375 strcpy(buf, DS:0x22F2) */
    overlay_call_181F_0182();                 /* @asm 0x075385 append(arg0) */

    if (overlay_call_181F_044E() != 0) {      /* @asm 0x0753A9/0753B3 fit? */
        goto cleanup;                         /* @asm 0x0753B5 jmp 0x075563 */
    }

    /* per-human-marker clause @DS:0x22FA/0x2301/0x2308/0x230E (@asm 0x0753B8) */
    switch (*((uint16_t near *)0x5398)) {     /* @asm 0x0753B8 */
        case 0: break;                        /* @asm 0x0753BD je 0x3f3a -> @0x22FA */
        case 1: break;                        /* @asm 0x0753C0 -> @0x2301 */
        case 2: break;                        /* @asm 0x0753C3 -> @0x2308 */
        case 3: break;                        /* @asm 0x0753C6 -> @0x230E */
        default: break;                       /* @asm 0x0753C8 jmp 0x3f5b */
    }
    overlay_call_0D1D_07E4();                 /* @asm 0x0753E3 strcpy clause */
    overlay_call_181F_0182();                 /* @asm 0x0753F3 append(arg0) */

    overlay_call_191F_0FDE();                 /* @asm 0x0753FB */
    if (overlay_call_191F_0FD0() != 0) {      /* @asm 0x075405 record lookup (far ptr) */
        overlay_call_181F_02F8();             /* @asm 0x07542B draw value bar (rec+0x46/+0x48) */
    }

    if (arg0_bp_06 == 1) {                    /* @asm 0x075430 cmp [bp+6],1 */
        if (arg1_bp_08 == 1) {                /* @asm 0x075436 cmp [bp+8],1 -> @0x2314 */
            overlay_call_0D1D_07E4();         /* @asm 0x075443 strcpy(@0x2314) */
            overlay_call_181F_048E();         /* @asm 0x07544D draw glyph 0x3e */
        } else {                              /* @asm 0x075458 -> @0x231A */
            overlay_call_0D1D_07E4();         /* @asm 0x075465 strcpy(@0x231A) */
        }
    } else {                                  /* @asm 0x07545E -> @0x2323 */
        overlay_call_0D1D_07E4();             /* @asm 0x075465 strcpy(@0x2323) */
    }
    overlay_call_191F_0FDE();                 /* @asm 0x07546D */
    if (overlay_call_191F_0FD0() != 0) {      /* @asm 0x075477 */
        overlay_call_181F_02F8();             /* @asm 0x07549D draw second value bar */
    }

    overlay_call_181F_03B6();                 /* @asm 0x0754A2 push draw state */
    overlay_call_181F_03F4();                 /* @asm 0x0754AD blit region (@bp-0x320) */
    overlay_call_181F_0444();                 /* @asm 0x0754DB draw box (0x140 x 0xC8) */
    overlay_call_181F_00E2();                 /* @asm 0x0754ED draw frame */
    prompt_result = (uint32_t)overlay_call_1A1F_0A86(); /* @asm 0x0754F6 prompt(@DS:0x232B) */

    /* save & set text cursor/color state [0x1F4A/0x1F50/0x1F52/0x1F56] */
    {
        uint16_t s_1f4a = *((uint16_t near *)0x1F4A);  /* @asm 0x075518 */
        uint16_t s_1f50 = *((uint16_t near *)0x1F50);  /* @asm 0x07551C */
        uint16_t s_1f52 = *((uint16_t near *)0x1F52);  /* @asm 0x075520 */
        *((uint16_t near *)0x1F4A) = 0x00F2;           /* @asm 0x075526 */
        *((uint16_t near *)0x1F50) = 0x002F;           /* @asm 0x07552C */
        *((uint16_t near *)0x1F52) = 0;                /* @asm 0x075532 */
        *((uint8_t  near *)0x1F56) |= 0x18;            /* @asm 0x075538 */
        overlay_call_181F_03FE();                      /* @asm 0x075540 draw text run (bx=arg2) */
        *((uint16_t near *)0x1F4A) = s_1f4a;           /* @asm 0x075545 */
        *((uint16_t near *)0x1F50) = s_1f50;           /* @asm 0x075549 */
        *((uint16_t near *)0x1F52) = s_1f52;           /* @asm 0x07554D */
        overlay_call_181F_03B6();                      /* @asm 0x075553 push state */
        overlay_call_181F_03F4();                      /* @asm 0x07555E blit (A000:FC00) */
    }

cleanup:
    if (prompt_result != 0) {                 /* @asm 0x075563 */
        overlay_call_191F_01A8();             /* @asm 0x075571 free far block */
    }
    *((uint16_t near *)0x1F9E) = *((uint16_t near *)0x268A); /* @asm 0x075576/07557D */
    *((uint16_t near *)0x1FA0) = *((uint16_t near *)0x268C); /* @asm 0x075579/075580 */
    *((uint16_t near *)0x1F64) = 1;           /* @asm 0x075584 */
    *((uint16_t near *)0x0372) = saved_text_state; /* @asm 0x07558A restore */
    return 0;  /* @asm 0x075592 retf (void) */
}

/* ============================================================================
 * func_075594 — show_simple_message_dialog  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Small modal-message variant: strcpy a base string @DS:0x2334, and if the
 * current human marker [0x5398]==3 append clause 2 via 0x181F:0x182, then show
 * it via the near message-box helper at page-0x1A 0x4ee0 (args: &buf, 1, 1).
 *
 * @asm 0x075598  lcall 0x0D1D:0x7E4 strcpy(@bp-0x14, @DS:0x2334)
 * @asm 0x0755A7  cmp [0x5398],3 ; @asm 0x0755AE if==3 lcall 0x181F:0x182 append(2)
 * @asm 0x0755C5  push cs; call 0x4ee0  (message box: &buf, 1, 1)
 * @status DONE
 */
int func_075594_show_simple_message_dialog(void)
{
    overlay_call_0D1D_07E4();                 /* @asm 0x075598 strcpy(buf, DS:0x2334) */
    if (*((uint16_t near *)0x5398) == 3) {    /* @asm 0x0755A7 cmp [0x5398],3 */
        overlay_call_181F_0182();             /* @asm 0x0755B5 append clause 2 */
    }
    return page1A_msgbox();                   /* @asm 0x0755C6 call cs:0x4ee0 (message box) */
}

/* ============================================================================
 * func_0755CC — new_game_init  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * NEW-GAME / GAME-STATE INITIALIZATION (reseg size 1052; stale banner "235").
 * arg0_bp_06 = "fresh-map" flag (0 => seed the default 0x3A x 0x48 AMER2 map).
 * project-mem cross-checked: king-anger 0x53A7, REF block 0x53DA, difficulty
 * 0x53A6, PowerRecord stride 0x13C, UnitRecord stride 0x1C, AIPersonality 0x34.
 *
 * FLOW:
 *   strcpy(@0x8554, @DS:0x2166 "AMER2.MP")        -- default map name
 *   scalar inits ([0x5388]=arg0, [0x5382]=0xC600, [0x5386]=0xE, [0xA0/0xA2/0xA4]
 *     =1, four 0xFFFF slots, seven zeros), [0x53C8+i*2]=0xFFFF (i<4),
 *     [0x53EA+i*2]=random_int(0x258,0x3E8) (i<0x10), [0x53DA/0x53E2+i*2]=0 (i<4),
 *     memset(@0x540A,0,4).
 *   if [0x828]==0 (no scenario) -> near 0x4f2b default-map init.
 *   0x181F:0x4F2 init-draw ; 0x181F:0x4C0(0x39) ; 0x181F:0x3AC present.
 *   [bp-2]=2 ; if arg0==0 seed map dims [0x853A]=0x3A,[0x853C]=0x48,
 *     [0x18C]=1,[0x85A4]=0x1050,[0x85A6]=0.
 *   0x1A1F:0xC80 (validate; nonzero -> bail to 0x451f) ; 0x181F:0x3AC.
 *   if arg0!=0: 0x1A1F:0xC8E (nonzero -> [0x822]=[0x158]; bail) else draw map
 *     border via two 0x181F:0xBA calls; 0x181F:0x3AC.
 *   0x181F:0x4CA([0x83A6]) ; 0x1A1F:0x83E(arg0) ; 0x181F:0x3AC ;
 *   0x1A1F:0x976 ; 0x191F:0xB6C ; 0x1A1F:0x7EA ; 0x1A1F:0x7F8 ; 0x181F:0x3AC.
 *   memset(@0x53A9, -1, 0x19) ; [0x53A7]=0 (king anger) ;
 *     [0x53A8]=random_int(1,8) ; [0x538A]=0x5D4 ; [0x538E]=0 (turn) ; [0x538C]=0.
 *   [0x5394]=[0x5396]=[0x5398] ; if [0x53A4]>=0 [0x5396]=[0x53A4].
 *   0x181F:0x4CA([0x83A6]).
 *   PER-POWER LOOP (power [bp-6] 0..3, stride 0x13C), gated by AIPersonality
 *     [+0x543F] flag (skip if ==2, process if ==0 with [bp-8] toggle):
 *       memset row: byte[p*0x13c + i - 0x77c4]=0 for i<0xC ;
 *       create unit kind 0xD -> u; UnitRec[u].state(+0x314C)=0,
 *         home (+0x314D/+0x314E)=PowerRec[-0x77c6/-0x77c5]; if power==3
 *         UnitRec[u].type(+0x3146)=0xE ;
 *       create unit kind 2 -> u; state=1; home; if power==1 subtype(+0x315B)=0x14;
 *       create unit kind 1 -> u; state=1; home;
 *         if ([bp-8]!=0 && diff<=1) || power==2: subtype(+0x315B)=0x15 ;
 *       set spawn cursor: [0x17C]=[0x8540]=home_x ; [0x17E]=[0x853E]=home_y ;
 *       AIPersonality reset [p*0x34 + 0x5440]=0.
 *   0x1A1F:0x87C ; (loop 0x181F:0x3AC until 0) ; 0x191F:0xAAC ; 0x1A1F:0xA5C ;
 *   blit A000:FC00 (0x181F:0x3F4) ; if [0x828]==0 && [0x83AC]!=0 -> 0x181F:0x4E8 ;
 *   draw 0x25 (0x181F:0x48E) ; [bp-2]=0.
 *   tail (0x451f): if [0x828]==0 && [0x83AC]!=0 -> 0x181F:0x4E8 ; return [bp-2].
 *
 * @asm 0x0755D7  lcall 0x0D1D:0x7E4 strcpy(@0x8554, @DS:0x2166 "AMER2.MP")
 * @asm 0x07564B  lcall 0x181F:0x4D4 random(0x258,0x3E8) -> [0x53EA+i*2]
 * @asm 0x07569B  mov al,[0x53A6] -> [0x53DA]=d*8+0xF; [0x53DC]=(d+1)*5;
 *                [0x53E0]=d*6+2; [0x53DE]=d*3+2
 * @asm 0x075702  [0x853A]=0x3A ; @asm 0x075708 [0x853C]=0x48 (map dims)
 * @asm 0x0757D3  [0x53A7]=0 ; @asm 0x0757DC lcall 0x181F:0x4D4 random(1,8) -> [0x53A8]
 * @asm 0x07584D  lcall 0x181F:0x95C create unit ; @asm 0x07585B [u*0x1C+0x314c]=0
 * @asm 0x07596A  lcall 0x1A1F:0x87C ; @asm 0x075978 lcall 0x191F:0xAAC (post-setup)
 * @asm 0x0759C6  leave ; @asm 0x0759C7 retf (returns [bp-2])
 * @status DONE
 */
int func_0755CC_new_game_init(uint16_t arg0_bp_06)
{
    int i;
    int p;          /* [bp-6] -- power index */
    int toggle;     /* [bp-8] -- "first processed power" flag */
    int result = 1; /* [bp-2] (initialized to 1 @asm 0x0755F4) */
    int u;          /* [bp-0xc] -- created unit index */
    int bx;
    int si;

    overlay_call_0D1D_07E4();                       /* @asm 0x0755D7 strcpy(@0x8554,"AMER2.MP") */
    *((uint16_t near *)0x5388) = arg0_bp_06;        /* @asm 0x0755E2 */
    *((uint16_t near *)0x5382) = 0xC600;            /* @asm 0x0755E5 */
    *((uint16_t near *)0x5386) = 0x000E;            /* @asm 0x0755EB */
    /* [bp-2]=1 @asm 0x0755F4 (result default) */
    *((uint16_t near *)0x00A2) = 1;                 /* @asm 0x0755F7 */
    *((uint16_t near *)0x00A0) = 1;                 /* @asm 0x0755FA */
    *((uint16_t near *)0x00A4) = 1;                 /* @asm 0x0755FD */
    *((uint16_t near *)0x53A4) = 0xFFFF;            /* @asm 0x075603 */
    *((uint16_t near *)0x53D2) = 0xFFFF;            /* @asm 0x075606 */
    *((uint16_t near *)0x53D4) = 0xFFFF;            /* @asm 0x075609 */
    *((uint16_t near *)0x53D6) = 0xFFFF;            /* @asm 0x07560C */
    *((uint16_t near *)0x5394) = 0;                 /* @asm 0x075611 */
    *((uint16_t near *)0x5396) = 0;                 /* @asm 0x075614 */
    *((uint16_t near *)0x53A0) = 0;                 /* @asm 0x075617 */
    *((uint16_t near *)0x53A2) = 0;                 /* @asm 0x07561A */
    *((uint16_t near *)0x5380) = 0;                 /* @asm 0x07561D */
    *((uint16_t near *)0x53D0) = 0;                 /* @asm 0x075620 */
    *((uint16_t near *)0x53D8) = 0;                 /* @asm 0x075623 */

    for (i = 0; i < 4; i++)                         /* @asm 0x07563A cmp,4 */
        *((uint16_t near *)(0x53C8 + i * 2)) = 0xFFFF; /* @asm 0x075631 */

    for (i = 0; i < 0x10; i++)                      /* @asm 0x07565F cmp,0x10 */
        *((uint16_t near *)(0x53EA + i * 2)) =
            (uint16_t)overlay_call_181F_04D4();     /* @asm 0x07564B random(0x258,0x3E8) */

    for (i = 0; i < 4; i++) {                       /* @asm 0x07567C cmp,4 */
        *((uint16_t near *)(0x53DA + i * 2)) = 0;   /* @asm 0x075671 */
        *((uint16_t near *)(0x53E2 + i * 2)) = 0;   /* @asm 0x075675 */
    }
    overlay_call_0D1D_0DAE();                       /* @asm 0x075688 memset(@0x540A,0,4) */

    /* post-init: near 0x4ef9 (= ljmp 0x1A1F:0xD3C); nonzero result -> bail */
    if (page1A_newgame_postinit() != 0)             /* @asm 0x075691/075694 */
        goto tail;                                  /* @asm 0x075698 jmp 0x451f */

    /* difficulty-scaled REF / king-anger thresholds (@asm 0x07569B..0x0756D0) */
    {
        int d = g_difficulty_53A6;                  /* @asm 0x07569B mov al,[0x53A6] */
        *((uint16_t near *)0x53DA) = (uint16_t)(d * 8 + 0xF);   /* @asm 0x0756A5 shl3;add 0xF */
        *((uint16_t near *)0x53DC) = (uint16_t)((d + 1) * 5);   /* @asm 0x0756B5 (d+1)*5 */
        *((uint16_t near *)0x53E0) = (uint16_t)(d * 6 + 2);     /* @asm 0x0756C5 d*6+2 */
        *((uint16_t near *)0x53DE) = (uint16_t)(d * 3 + 2);     /* @asm 0x0756D0 d*3+2 (BYTE_VERIFIED) */
    }

    if (*((uint8_t near *)0x0828) == 0)             /* @asm 0x0756D4 cmp [0x828],0 */
        page1A_newgame_mapinit();                   /* @asm 0x0756DC near 0x4f2b default-map init */

    overlay_call_181F_04F2();                       /* @asm 0x0756DF init draw */
    overlay_call_181F_04C0();                       /* @asm 0x0756E7 set mode(0x39) */
    overlay_call_181F_03AC();                       /* @asm 0x0756EC present */

    result = 2;                                     /* @asm 0x0756F1 [bp-2]=2 */
    if (arg0_bp_06 == 0) {                          /* @asm 0x0756F6 cmp [bp+6],0 */
        *((uint16_t near *)0x018C) = 1;             /* @asm 0x0756FC */
        *((uint16_t near *)0x853A) = 0x3A;          /* @asm 0x075702 map width  = 0x3A */
        *((uint16_t near *)0x853C) = 0x48;          /* @asm 0x075708 map height = 0x48 */
        *((uint16_t near *)0x85A4) = 0x1050;        /* @asm 0x07570E */
        *((uint16_t near *)0x85A6) = 0;             /* @asm 0x075714 */
    }

    if (overlay_call_1A1F_0C80() != 0)              /* @asm 0x07571C validate; nonzero -> bail */
        goto tail;                                  /* @asm 0x075725 jmp 0x451f */
    overlay_call_181F_03AC();                       /* @asm 0x075728 present */

    if (arg0_bp_06 != 0) {                          /* @asm 0x07572D cmp [bp+6],0 */
        if (overlay_call_1A1F_0C8E() != 0) {        /* @asm 0x075733 */
            *((uint16_t near *)0x0822) =
                *((uint16_t near *)0x0158);         /* @asm 0x07573C/07573F [0x822]=[0x158] */
            goto tail;                              /* @asm 0x075742 jmp 0x451f */
        }
    } else {
        overlay_call_181F_00BA();                   /* @asm 0x075761 draw top map border */
        overlay_call_181F_00BA();                   /* @asm 0x075785 draw bottom map border */
    }
    overlay_call_181F_03AC();                       /* @asm 0x07578A present */

    overlay_call_181F_04CA();                       /* @asm 0x075793 set palette([0x83A6]) */
    overlay_call_1A1F_083E();                       /* @asm 0x07579E (arg0) */
    overlay_call_181F_03AC();                       /* @asm 0x0757A6 present */
    overlay_call_1A1F_0976();                       /* @asm 0x0757AB post-setup */
    overlay_call_191F_0B6C();                       /* @asm 0x0757B0 post-setup */
    overlay_call_1A1F_07EA();                       /* @asm 0x0757B5 post-setup */
    overlay_call_1A1F_07F8();                       /* @asm 0x0757BA post-setup */
    overlay_call_181F_03AC();                       /* @asm 0x0757BF present */

    overlay_call_0D1D_0DAE();                       /* @asm 0x0757CB memset(@0x53A9,-1,0x19) */
    *((uint8_t  near *)0x53A7) = 0;                 /* @asm 0x0757D3 king anger = 0 */
    *((uint8_t  near *)0x53A8) = (uint8_t)overlay_call_181F_04D4(); /* @asm 0x0757DC random(1,8) */
    *((uint16_t near *)0x538A) = 0x05D4;            /* @asm 0x0757E7 */
    *((uint16_t near *)0x538E) = 0;                 /* @asm 0x0757EF turn = 0 */
    *((uint16_t near *)0x538C) = 0;                 /* @asm 0x0757F2 */
    *((uint16_t near *)0x5394) = *((uint16_t near *)0x5398); /* @asm 0x0757F5 */
    *((uint16_t near *)0x5396) = *((uint16_t near *)0x5398); /* @asm 0x0757FB */
    if (*((int16_t near *)0x53A4) >= 0)             /* @asm 0x0757FE cmp [0x53a4],0 jl */
        *((uint16_t near *)0x5396) = *((uint16_t near *)0x53A4); /* @asm 0x075805/075808 */
    overlay_call_181F_04CA();                       /* @asm 0x07580F set palette([0x83A6]) */

    /* ---- per-power starting-unit seeding loop ---- @asm 0x075817..0x075968 */
    p = 0;                                          /* @asm 0x075817 [bp-6]=0 */
    while (p < 4) {                                 /* @asm 0x075939 cmp [bp-6],4 jge 0x44da */
        /* skip powers whose AIPersonality [+0x543F] flag == 2 */
        if (*((uint8_t near *)(p * 0x34 + 0x543F)) == 2) { /* @asm 0x07593F/075943 */
            p++;                                    /* @asm 0x075936 */
            continue;                               /* @asm 0x075948 je 0x44a6 */
        }
        /* process only the first power whose flag == 0; set toggle */
        if (*((uint8_t near *)(p * 0x34 + 0x543F)) != 0) { /* @asm 0x075953/075957 */
            p++;                                    /* @asm 0x07595E jmp 0x4390 (re-loop body w/o toggle) */
        } else {
            toggle = 1;                             /* @asm 0x075961 [bp-8]=1 */
        }

        /* (loop body @asm 0x075820) clear 0xC bytes byte[p*0x13c+i-0x77c4] */
        si = p * 0x13C;                             /* @asm 0x07582A imul 0x13c */
        for (i = 0; i < 0xC; i++)                   /* @asm 0x07583A cmp,0xc */
            *((uint8_t near *)(si + i - 0x77C4)) = 0; /* @asm 0x075832 */

        /* unit kind 0xD (settler) */
        u = overlay_call_181F_095C();               /* @asm 0x07584D create unit (0xD) */
        bx = u * 0x1C;                              /* @asm 0x075858 imul 0x1c */
        *((uint8_t near *)(bx + 0x314C)) = 0;       /* @asm 0x07585B state=0 */
        si = p * 0x13C;                             /* @asm 0x075860 */
        *((uint8_t near *)(bx + 0x314D)) = *((uint8_t near *)(si - 0x77C6)); /* @asm 0x075865/075869 home x */
        *((uint8_t near *)(bx + 0x314E)) = *((uint8_t near *)(si - 0x77C5)); /* @asm 0x07586D/075871 home y */
        if (p == 3)                                 /* @asm 0x075875 cmp [bp-6],3 */
            *((uint8_t near *)(bx + 0x3146)) = 0xE; /* @asm 0x07587B type=0xE */

        /* unit kind 2 (soldier/dragoon) */
        u = overlay_call_181F_095C();               /* @asm 0x07588D create unit (2) */
        bx = u * 0x1C;                              /* @asm 0x075898 */
        *((uint8_t near *)(bx + 0x314C)) = 1;       /* @asm 0x07589B state=1 */
        si = p * 0x13C;                             /* @asm 0x0758A0 */
        *((uint8_t near *)(bx + 0x314D)) = *((uint8_t near *)(si - 0x77C6)); /* @asm 0x0758A5/0758A9 */
        *((uint8_t near *)(bx + 0x314E)) = *((uint8_t near *)(si - 0x77C5)); /* @asm 0x0758AD/0758B1 */
        if (p == 1)                                 /* @asm 0x0758B5 cmp [bp-6],1 */
            *((uint8_t near *)(bx + 0x315B)) = 0x14;/* @asm 0x0758BB subtype=0x14 */

        /* unit kind 1 (scout) */
        u = overlay_call_181F_095C();               /* @asm 0x0758CD create unit (1) */
        bx = u * 0x1C;                              /* @asm 0x0758D8 */
        *((uint8_t near *)(bx + 0x314C)) = 1;       /* @asm 0x0758DB state=1 */
        si = p * 0x13C;                             /* @asm 0x0758E0 */
        *((uint8_t near *)(bx + 0x314D)) = *((uint8_t near *)(si - 0x77C6)); /* @asm 0x0758E5/0758E9 */
        *((uint8_t near *)(bx + 0x314E)) = *((uint8_t near *)(si - 0x77C5)); /* @asm 0x0758ED/0758F1 */
        if ((toggle != 0 && g_difficulty_53A6 <= 1) || p == 2) { /* @asm 0x0758F5..0x075906 */
            bx = u * 0x1C;                          /* @asm 0x075908 */
            *((uint8_t near *)(bx + 0x315B)) = 0x15;/* @asm 0x07590C subtype=0x15 */
        }

        /* spawn cursor + AIPersonality reset */
        bx = p * 0x13C;                             /* @asm 0x075911 */
        *((uint16_t near *)0x017C) = *((uint8_t near *)(bx - 0x77C6)); /* @asm 0x075916/07591C */
        *((uint16_t near *)0x8540) = *((uint16_t near *)0x017C);       /* @asm 0x07591F */
        *((uint16_t near *)0x017E) = *((uint8_t near *)(bx - 0x77C5)); /* @asm 0x075922/075926 */
        *((uint16_t near *)0x853E) = *((uint16_t near *)0x017E);       /* @asm 0x075929 */
        *((uint16_t near *)(p * 0x34 + 0x5440)) = 0;/* @asm 0x07592C/075930 AIPersonality reset */
        p++;                                        /* @asm 0x075936 */
    }

    overlay_call_1A1F_087C();                       /* @asm 0x07596A */
    do {                                            /* @asm 0x07596F..0x075976 present until 0 */
    } while (overlay_call_181F_03AC() != 0);
    overlay_call_191F_0AAC();                       /* @asm 0x075978 post-setup */
    overlay_call_1A1F_0A5C();                       /* @asm 0x07597D */
    overlay_call_181F_03F4();                       /* @asm 0x075988 blit A000:FC00 */
    if (*((uint8_t near *)0x0828) == 0 &&           /* @asm 0x07598D cmp [0x828],0 */
        *((uint16_t near *)0x83AC) != 0) {          /* @asm 0x075994 cmp [0x83ac],0 */
        overlay_call_181F_04E8();                   /* @asm 0x07599B */
    }
    overlay_call_181F_048E();                       /* @asm 0x0759A2 draw 0x25 */
    result = 0;                                     /* @asm 0x0759AA [bp-2]=0 */

tail:
    if (*((uint8_t near *)0x0828) == 0 &&           /* @asm 0x0759AF cmp [0x828],0 */
        *((uint16_t near *)0x83AC) != 0) {          /* @asm 0x0759B6 cmp [0x83ac],0 */
        overlay_call_181F_04E8();                   /* @asm 0x0759BD */
    }
    return result;                                  /* @asm 0x0759C2 mov ax,[bp-2]; retf */
}

/* ============================================================================
 * func_0759E8 — save_load_game_screen  [DONE — control flow BYTE_VERIFIED;
 *               three IO near-thunk bodies are external (0x1A1F:0xD90/0xD9E/0xDBA)]
 * ----------------------------------------------------------------------------
 * THE SAVE / LOAD / NEW-MAP GAME SCREEN (reseg size 1455; stale "1438").
 * The menu key strings confirm the role: @DS:0x233C "OPENMENU", 0x2345
 * "BEGINMENU", 0x234F "AMERICA"/"*.MP", 0x2357 "MAPTOLOAD", 0x2366 "GAME",
 * 0x236B "WOODPANL", 0x2374 "OPENMENU".  ENTER 0x3F4 (the 0x3F4-byte frame is a
 * 0x300 screen-region save buffer [bp-0x3f4] + a parsed save-header [bp-0x8e]
 * + dialog scratch).  Local map: [bp-0xe2]=return code, [bp-0xe4]=done flag,
 * [bp-0xe0]=menu result, [bp-0xe6]=action result, [bp-0xf2]=which-list,
 * [bp-0xf4]=loop index, region rect [bp-0xf0..0xea]=(0xC8,0x140,0,0xA000).
 *
 * FLOW (byte-traced 0x0759E8..0x075F96):
 *   save full screen via 0x181F:0x53C.
 *   QUICK-PATHS:
 *     if [0x104]!=0 (autoload slot): 0x181F:0x498(3); build path len 0xA via
 *        0x1A1F:0xCDA; near 0x4eea dir-match; if match==0 && [0x83AC]==0 skip,
 *        else 0x181F:0x4E8; set [0x829]=1; jump to finish.            @asm 0x075A1B
 *     elif [0x828]!=0 (scenario): build path len 5; near 0x4ee5 read-header
 *        into [bp-0x8e]; if header ok && year [bp-0x84] < 0x6A4 (1700):
 *           near 0x4eea match; if ok set [0x829]=1 & finish.
 *        else near 0x4f30 picker; on success [p*0x34+0x543F]=1 for p<4; finish. @asm 0x075A52
 *   MAIN DIALOG (label 0x463c): fit menu @DS:0x233C via 0x181F:0x44E:
 *        if it fits -> 0x181F:0x484 restore; near 0x4f17 prep; copy 0x300-byte
 *           panel via 0x0D1D:0xFB2; [bp-0xf2]=1.
 *        else -> draw the WOODPANL box: 0x181F:0x3F4 blit; three 0x1A1F:0xDF8
 *           label lines (rows 6/7, 8/9, 0xE/0xF); 0x181F:0x444 box; 0x181F:0xE2
 *           frame; 0x181F:0x3F4 blit; [bp-0xf2]=0.
 *   EVENT LOOP (label 0x4798): 0x181F:0x4DE(0x33); 0x181F:0xF3C;
 *        if [0x828]==0 && [0x83AC]!=0 -> 0x181F:0x4E8 ; if [bp-0xf2]==0 near 0x4f0d;
 *        0x181F:0xF3C; [bp-0xe4]=0; menu result = 0x181F:0x3FE(@DS:0x2345 "BEGINMENU")
 *        -> [bp-0xe0]; dispatch:
 *          <0 : finish.
 *          1/2: (0x47f6) seed 5 random[3] -> word[0x1e7e+i*2]; if result==3 set 1;
 *               near 0x4f17 prep; sub-dispatch on result:
 *                 ==2: 0x181F:0x3FE(@0x234F "AMERICA") -> map-name pick; on pick
 *                      0x0D1D:0x816(@0x2166 "AMER2.MP") compare; set [0x2174]=1
 *                      and strcpy(@0x2166, name); etc.
 *                 then near 0x4f30 picker(arg = result==2); on done finish.
 *          3  : (0x495a) near 0x4f17; 0x191F:0x87A(@0x236B "WOODPANL") predicate;
 *               if true draw box+frame; 0x191F:0x320 commit; on 0 set [0x829]=1,
 *               sound 0x181F:0x4AC(3 or 1)+0x4A2(2); else loop/finish.
 *          4  : (0x4a20) [bp-0xe4]=1; near 0x4f17; 0x191F:0xF8E(0); back to 0x48f1.
 *          else: finish.
 *        label 0x48f1: if [bp-0xe4]==0 commit branch (label 0x4aed); else fit
 *          @DS:0x2374 ("OPENMENU") via 0x181F:0x44E; if fits 0x181F:0x484 +
 *          near 0x4f17 + 0x0D1D:0xFB2(0x300); else (0x4a38) near 0x4f1c +
 *          0x181F:0x3F4 + three 0x1A1F:0xDF8 lines + box + frame; then re-loop
 *          (0x47ba) while [bp-0xe4]!=0.
 *   FINISH (0x4af7): [bp-0xe2]=0 ; (0x4afd) near 0x4f17 ; return [bp-0xe2].
 *
 * @asm 0x075A0F  lcall 0x181F:0x53C   (screen save)
 * @asm 0x075A2C  lcall 0x1A1F:0xCDA   (build save path)
 * @asm 0x075A7F  cmp [bp-0x84],0x6A4  (save-file year guard = 1700)
 * @asm 0x075AB9  [p*0x34 + 0x543F]=1  (mark power active)
 * @asm 0x075B1D  lcall 0x0D1D:0xFB2   (copy 0x300-byte panel)
 * @asm 0x075C64  lcall 0x181F:0x3FE(@DS:0x2345 "BEGINMENU") -> menu result
 * @asm 0x075F8E  near 0x4f17 ; @asm 0x075F91 ax=[bp-0xe2]; @asm 0x075F96 retf
 * @status DONE (the three list/IO near-thunks resolve to external 0x1A1F:0xD90/
 *         0xD9E/0xDBA; the byte movers are 0x0D1D / 0x181F primitives)
 */
int func_0759E8_save_load_game_screen(void)
{
    int p;
    int done = 0;          /* [bp-0xe4] */
    int rc = 0;            /* [bp-0xe2] return code */
    int which_list = 0;    /* [bp-0xf2] */
    int menu;              /* [bp-0xe0] */
    int action;            /* [bp-0xe6] */
    int i;                 /* [bp-0xf4] */

    overlay_call_181F_053C();                 /* @asm 0x075A0F save full screen (0,0,320,200) */

    /* ---- quick path A: autoload slot [0x104] ---- @asm 0x075A14 */
    if (*((uint16_t near *)0x0104) != 0) {
        overlay_call_181F_0498();             /* @asm 0x075A1D arg 3 */
        overlay_call_1A1F_0CDA();             /* @asm 0x075A2C build path (len 0xA) */
        if (page1A_dir_match() == 0) {        /* @asm 0x075A3A near 0x4eea */
            if (*((uint16_t near *)0x83AC) != 0) /* @asm 0x075A44 cmp [0x83ac],0 */
                overlay_call_181F_04E8();     /* @asm 0x075A4A */
        }
        *((uint8_t near *)0x0829) = 1;        /* @asm 0x075A97 */
        goto finish;                          /* @asm 0x075A9C jmp 0x4af7 */
    }

    /* ---- quick path B: scenario [0x828] ---- @asm 0x075A52 */
    if (*((uint8_t near *)0x0828) != 0) {
        overlay_call_1A1F_0CDA();             /* @asm 0x075A60 build path (len 5) */
        if (page1A_read_hdr() == 0 &&         /* @asm 0x075A75 near 0x4ee5 */
            *((int16_t near *)0xFF7C) /*[bp-0x84]*/ < 0x6A4) { /* @asm 0x075A7F year < 1700 */
            if (page1A_dir_match() == 0) {    /* @asm 0x075A8D near 0x4eea */
                *((uint8_t near *)0x0829) = 1;/* @asm 0x075A97 */
                goto finish;                  /* @asm 0x075A9C jmp 0x4af7 */
            }
        }
        if (page1A_file_pick() != 0) {        /* @asm 0x075AA3 near 0x4f30 picker */
            for (p = 0; p < 4; p++)           /* @asm 0x075AC2 cmp,4 */
                *((uint8_t near *)(p * 0x34 + 0x543F)) = 1; /* @asm 0x075AB9 mark power active */
        } else {
            goto finish_alt;                  /* @asm 0x075AAD jmp 0x4afd (no prep) */
        }
        goto finish;                          /* @asm 0x075AC9 jmp 0x4af7 */
    }

    /* ---- main dialog: fit the OPENMENU/BEGINMENU panel ---- @asm 0x075ACC (label 0x463c) */
    if (overlay_call_181F_044E() != 0) {      /* @asm 0x075AE7 fit menu @DS:0x233C */
        overlay_call_181F_0484();             /* @asm 0x075B05 restore region */
        page1A_sl_prep();                     /* @asm 0x075B0B near 0x4f17 */
        overlay_call_0D1D_0FB2();             /* @asm 0x075B1D copy 0x300 panel A000:FC00 */
        which_list = 1;                       /* @asm 0x075B25 [bp-0xf2]=1 */
    } else {                                  /* @asm 0x075B2E (label 0x469e) */
        if (*((uint8_t near *)0x082A) != 0) { /* @asm 0x075B2E cmp [0x82a],0 */
            overlay_call_181F_0444();         /* @asm 0x075B5E box (0xB0 tall) */
        } else {
            overlay_call_181F_03F4();         /* @asm 0x075B6C blit panel */
        }
        overlay_call_1A1F_0DF8();             /* @asm 0x075B8E label line rows 6/7 */
        overlay_call_1A1F_0DF8();             /* @asm 0x075BB0 label line rows 8/9 */
        overlay_call_1A1F_0DF8();             /* @asm 0x075BD2 label line rows 0xE/0xF */
        overlay_call_181F_0444();             /* @asm 0x075C00 box */
        overlay_call_181F_00E2();             /* @asm 0x075C12 frame */
        overlay_call_181F_03F4();             /* @asm 0x075C1D blit */
        which_list = 0;                       /* @asm 0x075C22 [bp-0xf2]=0 */
    }

    /* ---- event loop ---- @asm 0x075C28 (label 0x4798) */
    do {
        overlay_call_181F_04DE();             /* @asm 0x075C2A arg 0x33 */
        overlay_call_181F_0F3C();             /* @asm 0x075C32 */
        if (*((uint8_t near *)0x0828) == 0 && /* @asm 0x075C37 */
            *((uint16_t near *)0x83AC) != 0) {/* @asm 0x075C3E */
            overlay_call_181F_04E8();         /* @asm 0x075C45 */
        }
        if (which_list == 0)                  /* @asm 0x075C4A cmp [bp-0xf2],0 jne */
            page1A_sl_flush();                /* @asm 0x075C52 near 0x4f0d */
        overlay_call_181F_0F3C();             /* @asm 0x075C55 */
        done = 0;                             /* @asm 0x075C5A [bp-0xe4]=0 */

        menu = overlay_call_181F_03FE();      /* @asm 0x075C64 menu @DS:0x2345 "BEGINMENU" */
        if (menu < 0)                         /* @asm 0x075C6D dec; jge */
            goto finish_alt;                  /* @asm 0x075C70 jmp 0x4afd */

        if (menu == 1 || menu == 2) {         /* @asm 0x075C73..0x075C78 (1 or 2) */
            /* (label 0x47f6) seed 5 random[0..2] -> word[0x1e7e + i*2] */
            for (i = 0; i < 5; i++) {         /* @asm 0x075CA8 cmp,5 */
                *((uint16_t near *)((i << 1) + 0x1E7E)) =
                    (uint16_t)overlay_call_181F_04D4();      /* @asm 0x075C92 random(0,3) */
                if (menu == 3)                /* @asm 0x075CAF cmp [bp-0xe0],3 (defensive) */
                    *((uint16_t near *)((i << 1) + 0x1E7E)) = 1; /* @asm 0x075CBC */
            }
            if (menu == 3) {                  /* @asm 0x075CC4 */
                if (overlay_call_1A1F_0BE4() != 0) /* @asm 0x075CCB */
                    done = 1;                 /* @asm 0x075CD4 */
            }
            page1A_sl_prep();                 /* @asm 0x075CDB near 0x4f17 */

            if (menu == 2) {                  /* @asm 0x075CDE cmp [bp-0xe0],2 */
                /* (label 0x4855) pick a map name from "*.MP" list */
                action = overlay_call_181F_03FE();       /* @asm 0x075CE9 @DS:0x234F "AMERICA" */
                if (action < 1)               /* @asm 0x075CF2 */
                    done = 1;                 /* @asm 0x075CF7 */
                else if (action > 1) {        /* @asm 0x075D00 */
                    do {
                        action = page1A_sl_addmap();         /* @asm 0x075D14 near 0x4f26 (@0x2357/0x235c/0x2366) */
                    } while (action < 0);     /* @asm 0x075D20 jl 0x4867 */
                    if (overlay_call_0D1D_0816() != 0) {     /* @asm 0x075D2A cmp(@0x2166 "AMER2.MP") */
                        *((uint16_t near *)0x2174) = 1;      /* @asm 0x075D36 */
                        overlay_call_0D1D_07E4();            /* @asm 0x075D44 strcpy(@0x2166, name) */
                    }
                }
            }
            /* (label 0x48bc) run picker; arg = (menu==2)?1:0 */
            if (done == 0) {                  /* @asm 0x075D4C cmp [bp-0xe4],0 */
                action = page1A_file_pick();  /* @asm 0x075D64 near 0x4f30 picker((menu==2)) */
                if (action == 1)              /* @asm 0x075D6E dec; jne */
                    done = 1;                 /* @asm 0x075D71 */
                if (action > 1)               /* @asm 0x075D77 cmp,1 jle */
                    goto finish_alt;          /* @asm 0x075D7E jmp 0x4afd */
            }
            /* (label 0x48f1) shared with menu==3/4 tails: see below */
            goto label_48f1;

        } else if (menu == 3) {               /* @asm 0x075C7D dec; jne -> 0x495a */
            page1A_sl_prep();                 /* @asm 0x075DEA near 0x4f17 */
            done = (overlay_call_191F_087A() == 1) ? 1 : 0; /* @asm 0x075E03 @DS:0x236B "WOODPANL"; sbb/neg */
            if (done != 0) {                  /* @asm 0x075E16 */
                overlay_call_181F_040A();     /* @asm 0x075E1A */
                overlay_call_181F_0444();     /* @asm 0x075E48 box */
                overlay_call_181F_00E2();     /* @asm 0x075E5A frame */
            }
            action = overlay_call_191F_0320();/* @asm 0x075E5F commit predicate */
            if (action == 0) {                /* @asm 0x075E68 */
                *((uint8_t near *)0x0829) = 1;/* @asm 0x075E6C */
                if (*((uint8_t near *)0x5382) & 1) /* @asm 0x075E71 test [0x5382],1 */
                    overlay_call_181F_04AC(); /* @asm 0x075E7A arg 3 */
                else
                    overlay_call_181F_04AC(); /* @asm 0x075E84 arg 1 */
                overlay_call_181F_04A2();     /* @asm 0x075E8E arg 2 */
            }
            if (action == 1)                  /* @asm 0x075E96 */
                done = 1;                     /* @asm 0x075E9D */
            if (action > 1)                   /* @asm 0x075EA3 jg */
                goto finish_alt;              /* @asm 0x075EAD jmp 0x4afd */
            goto label_48f1;                  /* @asm 0x075EAA jmp 0x48f1 */

        } else if (menu == 4) {               /* @asm 0x075C7D second dec -> 0x4a20 */
            done = 1;                         /* @asm 0x075EB0 [bp-0xe4]=1 */
            page1A_sl_prep();                 /* @asm 0x075EB7 near 0x4f17 */
            overlay_call_191F_0F8E();         /* @asm 0x075EBC arg 0 */
            goto label_48f1;                  /* @asm 0x075EC4 jmp 0x48f1 */
        } else {
            goto finish_alt;                  /* @asm 0x075C83 jmp 0x4afd */
        }

    label_48f1:                               /* @asm 0x075D81 */
        if (done == 0)                        /* @asm 0x075D81 cmp [bp-0xe4],0 */
            goto label_4aed;                  /* @asm 0x075D88 jmp 0x4aed (commit) */

        /* (0x48fb) fit OPENMENU @DS:0x2374; on fit refresh panel, else redraw box */
        if (overlay_call_181F_044E() != 0) {  /* @asm 0x075DA6 fit @0x2374 */
            overlay_call_181F_0484();         /* @asm 0x075DC7 restore */
            page1A_sl_prep();                 /* @asm 0x075DCD near 0x4f17 */
            overlay_call_0D1D_0FB2();         /* @asm 0x075DDF copy 0x300 panel */
            goto label_4aed;                  /* @asm 0x075DE7 jmp 0x4aed */
        } else {                              /* (0x4a38) */
            page1A_sl_commit();               /* @asm 0x075EC9 near 0x4f1c */
            overlay_call_181F_03F4();         /* @asm 0x075ED2 blit */
            overlay_call_1A1F_0DF8();         /* @asm 0x075EF4 line rows 6/7 */
            overlay_call_1A1F_0DF8();         /* @asm 0x075F16 line rows 8/9 */
            overlay_call_1A1F_0DF8();         /* @asm 0x075F38 line rows 0xE/0xF */
            overlay_call_181F_0444();         /* @asm 0x075F66 box */
            overlay_call_181F_00E2();         /* @asm 0x075F78 frame */
        }

    label_4aed:                               /* @asm 0x075F7D */
        ;                                     /* loop while done != 0 -> re-run event head 0x47ba */
    } while (done != 0);                      /* @asm 0x075F7D cmp [bp-0xe4],0 jne 0x47ba */

finish:
    rc = 0;                                   /* @asm 0x075F87 [bp-0xe2]=0 */
finish_alt:
    page1A_sl_prep();                         /* @asm 0x075F8E near 0x4f17 (final refresh) */
    return rc;                                /* @asm 0x075F91 ax=[bp-0xe2]; retf */
}

/* ============================================================================
 * func_075F98 — region_save_restore_768  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Saves a 0x300-byte (768) region into the local stack buffer via 0x1A1F:0xA78
 * then restores/fades it via 0x1A1F:0xA6A (palette or small VGA window).  Pure
 * two-call wrapper; the buffer ptr (ss:bp-0x300) is passed to both.
 *
 * @asm 0x075F9C  lea ax,[bp-0x300]; push ss; push ax; @asm 0x075FA2 lcall 0x1A1F:0xA78
 * @asm 0x075FA7  lea ax,[bp-0x300]; push ss; push ax; sub ax,ax; @asm 0x075FAF lcall 0x1A1F:0xA6A
 * @status DONE
 */
int func_075F98_region_save_restore_768(void)
{
    overlay_call_1A1F_0A78();                 /* @asm 0x075FA2 save 0x300 region */
    overlay_call_1A1F_0A6A();                 /* @asm 0x075FAF restore/fade */
    return 0;  /* @asm 0x075FB5 retf (void) */
}

/* ============================================================================
 * func_075FB6 — map_scenario_setup  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * MAP / SCENARIO LOAD + VALIDATE pipeline (reseg size 1039; terminal RETF at
 * 0x07636F -- the "page-end" banner was conservative, the body completes in
 * page 0x1A).  It reads the map config, validates the loaded regions, decodes
 * the three packed map layers into work blocks @0x93F0 / @0x93F8 / @0x9400, and
 * on any failure stores a step code [0x822] = 0x13..0x1E and bails to the common
 * teardown tail (0x4ea5).  [bp-8] tracks the current step kind (0x13 default).
 *
 * STEP CODES (each guards one stage; on failure -> [0x822]=code, jmp 0x4ea5):
 *   0x13 region @DS:0x237D scan (0x1A1F:0xE28)           @asm 0x07604C
 *   0x14 region @0x8330 (0x20x0x20) coords nonzero       @asm 0x07606D
 *   0x15 prompt @DS:0x2389 (0x1A1F:0xA86) -> [0x268A]     @asm 0x0760DA
 *   0x16 prompt @DS:0x2392 -> [0x89E:0x8A0]               @asm 0x0760FC
 *   0x17 layer @DS:0x239B convert (0x1A1F:0x372) -> [0x83A] @asm 0x07616E
 *   0x18 post-load validate (0x1A1F:0xE10)               @asm 0x076181
 *   0x19 new-game post-setup (0x191F:0xAAC)              @asm 0x076193
 *   0x1A region @0x93F0 (0x20x0x18) coords nonzero       @asm 0x0761B4
 *   0x1B region @0x93F8 (0x20x0x18) coords nonzero       @asm 0x0761D6
 *   0x1C layer @DS:0x23A2 convert -> [bp-0xc:0xa]         @asm 0x0761F6
 *   0x1D layer @DS:0x23AB convert -> [bp-6:4]             @asm 0x076235
 *   0x1E layer @DS:0x23B1 convert -> [bp-6:4]             @asm 0x076273
 *
 * After all stages: decode the three layers via 0x181F:0x254 into @0x93F0 /
 * @0x93F8 / @0x9400 (each freed via 0x191F:0x1A8), bind the layer pointers
 * ([0x1F6C]=[0x14BA]=[0x82C]=0x93F0, [0x82E]=0x93F8) + 0x1A1F:0x8DC, draw the
 * map name line (0x1A1F:0xE6A @DS:0x23BA), near 0x4f21 finalize; if that returns
 * 0 -> blit (0x181F:0x3F4), [0x53C2]=1, view init (0x1A1F:0xE5C), config flag
 * (0x181F:0xEAE from [0x5383] bit 8), present (0x181F:0x398), screen restore
 * (0x181F:0x546).  TAIL (0x4ea5): 0x1A1F:0xE4E teardown ; 0x181F:0x4F2 init ;
 * [bp-2]=[0x83AA] ; 0x181F:0x5C4(0,3) ; 0x181F:0xED6((bp-2==3)?0:1, 3) ;
 * 0x181F:0x5CE ; return (void).
 *
 * @asm 0x075FBA  [bp-8]=0x13 ; @asm 0x075FBF lcall 0x1A1F:0xE40 (map setup)
 * @asm 0x075FC9  0x181F:0xE5E -> [0x83A6] ; @asm 0x075FDB -> [0x917A] ; -> [0x83A8]
 * @asm 0x075FF0  0x181F:0xE72 -> [0x8D80:0x8D82]
 * @asm 0x076043  0x1A1F:0xE28 scan @0x237D ; @asm 0x07604C [0x822]=0x13 on fail
 * @asm 0x0761FF  0x181F:0x254 decode layer -> @0x93F0 (block from [bp-0xc:0xa])
 * @asm 0x076335  0x1A1F:0xE4E teardown ; @asm 0x07636F leave; retf
 * @status DONE
 */
int func_075FB6_map_scenario_setup(void)
{
    int step = 0x13;            /* [bp-8] */
    uint32_t layer;             /* [bp-0xc:0xa] / [bp-6:4] -- decoded layer far ptr */

    overlay_call_1A1F_0E40();                 /* @asm 0x075FBF map setup */
    overlay_call_181F_0EB8();                 /* @asm 0x075FC4 config read */
    *((uint16_t near *)0x83A6) = (uint16_t)overlay_call_181F_0E5E(); /* @asm 0x075FC9 */
    overlay_call_181F_0E68();                 /* @asm 0x075FD1 advance */
    *((uint16_t near *)0x917A) = (uint16_t)overlay_call_181F_0E5E(); /* @asm 0x075FD6 */
    overlay_call_181F_0E68();                 /* @asm 0x075FDE advance */
    *((uint16_t near *)0x83A8) = (uint16_t)overlay_call_181F_0E5E(); /* @asm 0x075FE3 */
    overlay_call_181F_0E68();                 /* @asm 0x075FEB advance */
    overlay_call_181F_0E72();                 /* @asm 0x075FF0 -> [0x8D80:0x8D82] */
    overlay_call_1A1F_0E36();                 /* @asm 0x075FFF (with [bp-8]) */

    if (*((uint8_t near *)0x082A) == 0) {     /* @asm 0x076004 cmp [0x82a],0 */
        overlay_call_181F_0ED6();             /* @asm 0x07601C ((step==3)?0:1, step) */
    } else {                                  /* @asm 0x076026 */
        *((uint16_t near *)0x83AA) = (uint16_t)step; /* @asm 0x076029 */
    }
    overlay_call_181F_05C4();                 /* @asm 0x076031 (step, 1) */

    /* step 0x13: region scan @DS:0x237D */
    if (overlay_call_1A1F_0E28() != 0) {      /* @asm 0x076043 */
        *((uint16_t near *)0x0822) = 0x13;    /* @asm 0x07604C */
        goto tail;                            /* @asm 0x076052 jmp 0x4ea5 */
    }
    /* step 0x14: region @0x8330 (0x20x0x20) must have nonzero coords */
    overlay_call_1A1F_0E02();                 /* @asm 0x07605F scan @0x8330 */
    while ((*((uint16_t near *)0x8336) | *((uint16_t near *)0x8334)) == 0) { /* @asm 0x076064/07606B */
        *((uint16_t near *)0x0822) = 0x14;    /* @asm 0x07606D */
        goto tail;                            /* @asm 0x076073 jmp 0x4ea5 */
    }
    /* region @0x2DA8 (0x140x0xC8) + @0x839E scans (retry to 0x4bdd on zero) */
    overlay_call_1A1F_0E02();                 /* @asm 0x076080 scan @0x2DA8 */
    if ((*((uint16_t near *)0x2DAE) | *((uint16_t near *)0x2DAC)) != 0) { /* @asm 0x076085/07608C */
        overlay_call_1A1F_0E02();             /* @asm 0x076098 scan @0x839E */
        if ((*((uint16_t near *)0x83A4) | *((uint16_t near *)0x83A2)) != 0) { /* @asm 0x07609D */
            overlay_call_1A1F_0E1E();         /* @asm 0x0760A6 */
        }
    }
    overlay_call_181F_0484();                 /* @asm 0x0760BD restore region */

    /* step 0x15: prompt @DS:0x2389 -> [0x268A:0x268C] */
    *((uint32_t near *)0x268A) = (uint32_t)overlay_call_1A1F_0A86(); /* @asm 0x0760C6/0760CB */
    if ((*((uint16_t near *)0x268C) | *((uint16_t near *)0x268A)) == 0) { /* @asm 0x0760D2 */
        *((uint16_t near *)0x0822) = 0x15;    /* @asm 0x0760DA */
        goto tail;                            /* @asm 0x0760E0 jmp 0x4ea5 */
    }
    /* step 0x16: prompt @DS:0x2392 -> [0x89E:0x8A0] */
    *((uint32_t near *)0x089E) = (uint32_t)overlay_call_1A1F_0A86(); /* @asm 0x0760E8/0760ED */
    if ((*((uint16_t near *)0x08A0) | *((uint16_t near *)0x089E)) == 0) { /* @asm 0x0760F4 */
        *((uint16_t near *)0x0822) = 0x16;    /* @asm 0x0760FC */
        goto tail;                            /* @asm 0x076102 jmp 0x4ea5 */
    }

    page1A_map_colors();                      /* @asm 0x076107 near 0x4f12 */
    page1A_map_pre();                          /* @asm 0x07610B near 0x4f08 */

    /* spread the @COLORS bytes [0x830..0x835] into the map color slots */
    *((uint16_t near *)0x14A8) = *((uint8_t near *)0x0835); /* @asm 0x07610E/076113 */
    *((uint16_t near *)0x14A4) = *((uint8_t near *)0x0835); /* @asm 0x076116 */
    *((uint16_t near *)0x14B4) = *((uint8_t near *)0x0830); /* @asm 0x076119/07611C */
    *((uint16_t near *)0x14AE) = *((uint8_t near *)0x0830); /* @asm 0x07611F */
    *((uint16_t near *)0x14B6) = *((uint8_t near *)0x0832); /* @asm 0x076122/076125 */
    *((uint16_t near *)0x14B0) = *((uint8_t near *)0x0832); /* @asm 0x076128 */
    *((uint16_t near *)0x14B8) = *((uint8_t near *)0x0831); /* @asm 0x07612B/07612E */
    *((uint16_t near *)0x14B2) = *((uint8_t near *)0x0831); /* @asm 0x076131 */

    overlay_call_1A1F_07C4();                 /* @asm 0x07613F region restore(0x1000,[0x268A]) */
    if (overlay_call_1A1F_0CBE() != 0)        /* @asm 0x076147 */
        goto tail;                            /* @asm 0x076150 jmp 0x4ea5 */

    /* step 0x17: layer @DS:0x239B convert(0x4000) -> [0x83A:0x83C] */
    *((uint32_t near *)0x083A) = (uint32_t)overlay_call_1A1F_0372(); /* @asm 0x07615A/07615F */
    if ((*((uint16_t near *)0x083C) | *((uint16_t near *)0x083A)) == 0) { /* @asm 0x076166 */
        *((uint16_t near *)0x0822) = 0x17;    /* @asm 0x07616E */
        goto tail;                            /* @asm 0x076174 jmp 0x4ea5 */
    }
    /* step 0x18: post-load validate */
    if (overlay_call_1A1F_0E10() != 0) {      /* @asm 0x076178 */
        *((uint16_t near *)0x0822) = 0x18;    /* @asm 0x076181 */
        goto tail;                            /* @asm 0x076187 jmp 0x4ea5 */
    }
    /* step 0x19: new-game post-setup */
    if (overlay_call_191F_0AAC() != 0) {      /* @asm 0x07618A */
        *((uint16_t near *)0x0822) = 0x19;    /* @asm 0x076193 */
        goto tail;                            /* @asm 0x076199 jmp 0x4ea5 */
    }
    /* step 0x1A: region @0x93F0 (0x20x0x18) coords nonzero */
    overlay_call_1A1F_0E02();                 /* @asm 0x0761A6 scan @0x93F0 */
    if ((*((uint16_t near *)0x93F6) | *((uint16_t near *)0x93F4)) == 0) { /* @asm 0x0761AB */
        *((uint16_t near *)0x0822) = 0x1A;    /* @asm 0x0761B4 */
        goto tail;                            /* @asm 0x0761BA jmp 0x4ea5 */
    }
    /* step 0x1B: region @0x93F8 (0x20x0x18) coords nonzero */
    overlay_call_1A1F_0E02();                 /* @asm 0x0761C8 scan @0x93F8 */
    if ((*((uint16_t near *)0x93F6) | *((uint16_t near *)0x93F4)) == 0) { /* @asm 0x0761CD */
        *((uint16_t near *)0x0822) = 0x1B;    /* @asm 0x0761D6 */
        goto tail;                            /* @asm 0x0761DC jmp 0x4ea5 */
    }
    /* step 0x1C: layer @DS:0x23A2 convert -> [bp-0xc:0xa]; decode -> @0x93F0 */
    layer = (uint32_t)overlay_call_1A1F_0372();   /* @asm 0x0761E7/0761EC */
    if (layer == 0) {                         /* @asm 0x0761F2 */
        *((uint16_t near *)0x0822) = 0x1C;    /* @asm 0x0761F6 */
        goto tail;                            /* @asm 0x0761FC jmp 0x4ea5 */
    }
    overlay_call_181F_0254();                 /* @asm 0x07620F decode(layer,1,0,@0x93F0) */
    overlay_call_191F_01A8();                 /* @asm 0x07621A free(layer) */

    /* step 0x1D: layer @DS:0x23AB convert -> [bp-6:4]; decode -> @0x93F8 */
    layer = (uint32_t)overlay_call_1A1F_0372();   /* @asm 0x076226/07622B */
    if (layer == 0) {                         /* @asm 0x076231 */
        *((uint16_t near *)0x0822) = 0x1D;    /* @asm 0x076235 */
        goto tail;                            /* @asm 0x07623B jmp 0x4ea5 */
    }
    overlay_call_181F_0254();                 /* @asm 0x07624D decode(layer,1,0,@0x93F8) */
    overlay_call_191F_01A8();                 /* @asm 0x076258 free(layer) */

    /* step 0x1E: layer @DS:0x23B1 convert -> [bp-6:4]; decode -> @0x9400 */
    layer = (uint32_t)overlay_call_1A1F_0372();   /* @asm 0x076264/076269 */
    if (layer == 0) {                         /* @asm 0x07626F */
        *((uint16_t near *)0x0822) = 0x1E;    /* @asm 0x076273 */
        goto tail;                            /* @asm 0x076279 jmp 0x4ea5 */
    }
    *((uint16_t near *)0x9402) = 0x20;        /* @asm 0x07627C */
    *((uint16_t near *)0x9400) = 0x18;        /* @asm 0x076282 */
    *((uint16_t near *)0x9404) = *((uint16_t near *)0x8334); /* @asm 0x076288/07628F */
    *((uint16_t near *)0x9406) = *((uint16_t near *)0x8336); /* @asm 0x07628B/076292 */
    overlay_call_181F_0254();                 /* @asm 0x0762A7 decode(layer,1,0,@0x9400) */
    overlay_call_191F_01A8();                 /* @asm 0x0762B2 free(layer) */

    /* bind layer pointers */
    *((uint16_t near *)0x1F6C) = 0x93F0;      /* @asm 0x0762B7/0762BA */
    *((uint16_t near *)0x14BA) = 0x93F0;      /* @asm 0x0762BD */
    *((uint16_t near *)0x082C) = 0x93F0;      /* @asm 0x0762C0 */
    *((uint16_t near *)0x082E) = 0x93F8;      /* @asm 0x0762C3 */
    overlay_call_1A1F_08DC();                 /* @asm 0x0762C9 bind map layers */

    overlay_call_1A1F_0E6A();                 /* @asm 0x0762F1 draw map name line @DS:0x23BA */
    if (page1A_map_finalize() == 0) {         /* @asm 0x0762F7 near 0x4f21 */
        overlay_call_181F_03F4();             /* @asm 0x076304 blit A000:FC00 */
        *((uint16_t near *)0x53C2) = 1;       /* @asm 0x076309 */
        overlay_call_1A1F_0E5C();             /* @asm 0x07630F view-state init */
        overlay_call_181F_0EAE();             /* @asm 0x076323 config flag ([0x5383] bit 8) */
        overlay_call_181F_0398();             /* @asm 0x07632B present */
        overlay_call_181F_0546();             /* @asm 0x076330 screen restore */
    }

tail:                                         /* @asm 0x076335 (0x4ea5) */
    overlay_call_1A1F_0E4E();                 /* @asm 0x076335 map teardown */
    overlay_call_181F_04F2();                 /* @asm 0x07633A init draw */
    /* [bp-2]=[0x83AA] @asm 0x07633F; 0x181F:0x5C4(0,3) @asm 0x076349 */
    overlay_call_181F_05C4();                 /* @asm 0x076349 (0,3) */
    overlay_call_181F_0ED6();                 /* @asm 0x07635F ((bp-2==3)?0:1, 3) */
    overlay_call_181F_05CE();                 /* @asm 0x076369 */
    return 0;                                 /* @asm 0x07636E leave; 0x07636F retf */
}

/* ============================================================================
 * func_0764F2 — view_origin_alloc  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Allocates the viewport origin/handle (companion to func_0764D0).  Allocates
 * a far block of 0x3880 bytes via 0x181F:0x29A, stores it at [0x23C6:0x23C8];
 * if the result is null, raises the error/abort path (near call 0x26D ==
 * func 0x07663D ljmp 0x191F:0xFDE) and returns 0, else returns 1.
 *
 * @asm 0x0764F6  [bp-2]=1
 * @asm 0x0764FB  mov ax,0x3880; mov dx,1; @asm 0x076501 lcall 0x181F:0x29A (alloc 0x00013880? size=0x3880)
 * @asm 0x076506  [0x23C6]=ax ; [0x23C8]=dx
 * @asm 0x07650F  or ax,[0x23C6]; @asm 0x076513 je -> ok
 * @asm 0x076516  push cs; call 0x26D (error) ; [bp-2]=0
 * @asm 0x07651E  mov ax,[bp-2]; retf
 * @status DONE
 */
int func_0764F2_view_origin_alloc(void)
{
    int ok = 1;                               /* @asm 0x0764F6 [bp-2]=1 */
    uint16_t lo, hi;

    lo = (uint16_t)overlay_call_181F_029A();  /* @asm 0x076501 alloc(0x3880) -> ax(lo) */
    hi = 0; /* dx returned by alloc; @asm 0x076509 [0x23C8]=dx (far seg) */
    *((uint16_t near *)0x23C6) = lo;          /* @asm 0x076506 */
    *((uint16_t near *)0x23C8) = hi;          /* @asm 0x076509 */
    if ((hi | lo) == 0) {                     /* @asm 0x07650F/076513 alloc failed */
        page1B_err_abort();                   /* @asm 0x076516 call cs:0x26D (error/abort) */
        ok = 0;                               /* @asm 0x076519 */
    }
    return ok;                                /* @asm 0x07651E retf */
}

/* ============================================================================
 * func_076524 — view_scroll_step  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * (Stale banner "25 bytes accessor" is wrong; reseg = 111 bytes.)  Advances
 * the viewport scroll by one step using the state seeded by func_0764D0:
 *   [0x23F6:0x23F8] = [0xA616:0xA618]      (current pixel origin)
 *   [0xA61E:0xA620] = [0x23CA:0x23CC]      (step dword)
 *   call 0x1A1F:0x372 (clamp/convert) -> [bp-4:bp-2]; if null bail.
 *   while step (dword [0x23CA:0x23CC]) > [0xA61A:0xA61C] (remaining):
 *     inc [0x23CE]; [0xA616]+= [0xA61A]; [0x23CA:0x23CC] -= [0xA61A:0xA61C].
 *   clears [0x23F6/0x23F8]=0, returns [bp-4:bp-2] (the converted coord dword).
 *
 * @asm 0x076528  [0x23F6:0x23F8]=[0xA616:0xA618]
 * @asm 0x076538  [0xA61E:0xA620]=[0x23CA:0x23CC]
 * @asm 0x076548  lcall 0x1A1F:0x372 -> [bp-4:bp-2]; @asm 0x076555 je 0x1b3 (bail)
 * @asm 0x07655E  cmp [0xA61C],dx / @asm 0x076566 cmp [0xA61A],ax  (compare step vs remaining)
 * @asm 0x07656C  inc [0x23CE]; @asm 0x076573 add [0xA616],ax; @asm 0x07657B sub/sbb [0x23CA:0x23CC]
 * @asm 0x076583  [0x23F6]=[0x23F8]=0 ; @asm 0x07658B ax=[bp-4],dx=[bp-2]; retf
 * @status DONE
 */
int32_t func_076524_view_scroll_step(void)
{
    uint16_t coord_lo, coord_hi;
    uint16_t step_lo, step_hi;

    *((uint16_t near *)0x23F6) = *((uint16_t near *)0xA616); /* @asm 0x076528/076530 */
    *((uint16_t near *)0x23F8) = *((uint16_t near *)0xA618); /* @asm 0x07652C/076534 */
    *((uint16_t near *)0xA61E) = *((uint16_t near *)0x23CA); /* @asm 0x076538/076540 */
    *((uint16_t near *)0xA620) = *((uint16_t near *)0x23CC); /* @asm 0x07653C/076544 */

    {
        int32_t r = overlay_call_1A1F_0372();  /* @asm 0x076548 lcall 0x1A1F:0x372 -> ax:dx */
        coord_lo = (uint16_t)r;
        coord_hi = (uint16_t)((uint32_t)r >> 16);
    }
    if ((coord_hi | coord_lo) != 0) {          /* @asm 0x076553 or dx,ax / 076555 je bail */
        step_lo = *((uint16_t near *)0x23CA);  /* @asm 0x076557 */
        step_hi = *((uint16_t near *)0x23CC);
        /* if step (dword) <= remaining [0xA61A:0xA61C]: consume one step */
        if (!((step_hi > *((uint16_t near *)0xA61C)) ||
              (step_hi == *((uint16_t near *)0xA61C) &&
               step_lo >  *((uint16_t near *)0xA61A)))) { /* @asm 0x07655E/076566 */
            *((uint16_t near *)0x23CE) += 1;   /* @asm 0x07656C inc visited */
            *((uint16_t near *)0xA616) += *((uint16_t near *)0xA61A); /* @asm 0x076573 */
            *((uint32_t near *)0x23CA) -=
                ((uint32_t)*((uint16_t near *)0xA61C) << 16) |
                 *((uint16_t near *)0xA61A);   /* @asm 0x07657B sub/sbb */
        }
    }
    *((uint16_t near *)0x23F6) = 0;            /* @asm 0x076583/076588 */
    *((uint16_t near *)0x23F8) = 0;            /* @asm 0x076585 */
    return (int32_t)(((uint32_t)coord_hi << 16) | coord_lo); /* @asm 0x07658B ax:dx */
}

/* ============================================================================
 * func_076594 — terrain_layer_load3  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * (Stale "35 bytes"; reseg = 174, terminal JMP-tail.)  Loads three packed
 * terrain/data layers into far blocks of 0x4000 bytes each via the page-local
 * loader at 0x268 (the two tail thunks at 0x0765F.. ljmp 0x191F:0xFD0/0xFDE):
 *   call 0x26D (init); buf1 = load(@0x23D0, 0x4000) -> [0x174:0x176]
 *     mirror to [0x178:0x17A] if that pair is still 0.
 *   buf2 = load(@0x23D6, 0x4000) -> [0x83E:0x840]
 *   buf3 = load(@0x23DC, 0x4000) -> [0x842:0x844]
 *   if any alloc fails -> [bp-2]=0 (jmp 0x263).
 *   if [0x23CE] < 3: push the 4 coord words [0x23CA/0x23CC/0xA61A/0xA61C] and
 *     raise error 0xFFAE via 0x181F:0x772.  Returns [bp-2].
 *
 * @asm 0x07659E  push cs; call 0x26D (init)
 * @asm 0x0765A5  mov ax,0x4000; lea bx,[0x23D0]; call 0x268 (load) -> [0x174:0x176]
 * @asm 0x0765D5  mov ax,0x4000; lea bx,[0x23D6]; call 0x268 -> [0x83E:0x840]
 * @asm 0x0765F0  mov ax,0x4000; lea bx,[0x23DC]; call 0x268 -> [0x842:0x844]
 * @asm 0x076602  cmp [0x23CE],3 ; @asm 0x076607 jge ok ; else error 0x181F:0x772
 * @asm 0x076638  ljmp 0x191F:0xFD0 ; @asm 0x07663D ljmp 0x191F:0xFDE  (tail thunks)
 * @status DONE
 */
int func_076594_terrain_layer_load3(void)
{
    int ok = 1;                               /* @asm 0x076598 [bp-2]=1 */

    page1B_err_abort();                       /* @asm 0x07659E call cs:0x26D (init) */

    *((uint32_t near *)0x0174) = page1B_load_block(); /* @asm 0x0765A5 load(@0x23D0,0x4000) */
    if (*((uint32_t near *)0x0174) == 0)
        return 0;                             /* @asm 0x0765B9 je 0x263 -> [bp-2]=0 */
    if (*((uint32_t near *)0x0178) == 0)      /* @asm 0x0765BE */
        *((uint32_t near *)0x0178) = *((uint32_t near *)0x0174); /* @asm 0x0765C4 mirror */

    *((uint32_t near *)0x083E) = page1B_load_block(); /* @asm 0x0765D5 load(@0x23D6,0x4000) */
    if (*((uint32_t near *)0x083E) == 0)
        return 0;                             /* @asm 0x0765E6 je 0x263 */

    *((uint32_t near *)0x0842) = page1B_load_block(); /* @asm 0x0765F0 load(@0x23DC,0x4000) */
    if (*((uint32_t near *)0x0842) == 0)
        return 0;                             /* @asm 0x076600 je 0x263 */

    if (*((uint16_t near *)0x23CE) < 3) {     /* @asm 0x076602 cmp [0x23CE],3 */
        overlay_call_181F_0772();             /* @asm 0x076622 error 0xFFAE (4 coords) */
    }
    return ok;                                /* @asm 0x076627 retf [bp-2] */
}

/* ============================================================================
 * func_076642 — load_game_record  [DONE — control flow + record layout BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * SAVE-RECORD READER for the ".SS" colony/unit sub-record files (auto guess
 * "SAVE_LOAD_DIALOG" -> it is the per-record reader).  ENTER 0x20E (the 0x20E
 * frame holds the path buffer [bp-0x52], the field-set name [bp-0x1FC], the
 * parsed-header scratch [bp-0x114..], a 0x300-byte body buffer, plus far-ptr
 * locals).  Returns the assembled record far ptr [bp-0x208:0x206] (0 on error).
 * Error status -> [0x23F0] = 0xFFFF (open fail) / 0xFFFE (field read fail) /
 * 0xFFFC (alloc fail).
 *
 * FLOW (byte-traced 0x076642..0x076AEB):
 *   [0x2650]=0xD ; strcpy(@bp-0x52, arg0) ; if no '.' append default ext
 *     @DS:0x23E6 ".SS" ; strcpy(@bp-0x1FC, @DS:0x23EA "S$") ; 0x0D1D:0xD64 sets
 *     name ptr [bp-0x1E8]=&buf, skip a leading '*'; if name starts "RM" skip 2
 *     (the "RM" save-prefix); strncpy(@bp-0x1FC, name, 6).
 *   open typed record via 0x1A1F:0xE9E (key @DS:0x23ED "rb", out @bp-0x1E6):
 *     fail -> [0x23F0]=0xFFFF; return.
 *   [0x23F0]=0xFFFE.  read 0x98-byte header field via 0x1A1F:0xE82 into
 *     @bp-0x114 (fail -> return).  idx=[bp-0xee]; block size [bp-2]=idx<<4 (=idx*16) ;
 *     compute element-array entry off = idx*0x0C + 0x42 -> [bp-0x118] / [bp-0x20c] ;
 *     (the stride is 0x0C not 0x14; confirmed @asm 0x076754 d1e0/03c1/c1e002/0542 00)
 *     if (header flag [bp-0x210] bit 1 clear) && header byte [bp-0x114]==0 add
 *     [bp-0x80] to the entry off.  Clamp/compare the entry coords against the
 *     view-origin [0xA61E:0xA620]; capture matched record ptr [bp-0x60]; if no
 *     bound record, bind one via 0x1A1F:0xE90 (else [0x23F0]=0xFFFC; return).
 *   alloc record block size [bp-2] via 0x181F:0x29A -> [bp-0x64:0x62]
 *     (fail -> [0x23F0]=0xFFFC; return); zero its words +0x2E..+0x40.
 *   read the body: 0x1A1F:0xE82 (size [bp-2]) into the block (fail ->
 *     [0x23F0]=0xFFFE; return).  If header sub-flag [bp-0x108]==0 raise error
 *     0xFFF9 via 0x181F:0x772; else pull a stride-0x10 source row [bp-0x1CE],
 *     read its body via 0x0D1D:0x9A2 + 0x0D1D:0xA3E (0x300-byte chunk), and
 *     write the assembled record header: es:[rec+0x2C]=hdr byte, es:[rec+0]=
 *     (sub>0 && <4 ? 1:0), es:[rec+2]=sub count, es:[rec+4]=idx, es:[rec+0x28/
 *     0x2A]=[bp-0x84/0x82] (the save year), 0x10 words es:[rec+8+i*2]=
 *     [bp-0x10e+i*2].  Then accumulate per-sub-record fields +0x42..+0x4C in a
 *     loop (count = es:[rec+4]) via 0x1A1F:0xE78 (dense es-segment juggling);
 *     source stride = 0x10 (@asm 0x0769C0 c1e704); output elem stride = 0x0C;
 *     src[+0x08]->elem[+0x04], src[+0x0A]->elem[+0x06], src[+0x0C]->elem[+0x08](pos),
 *     src[+0x0E]->elem[+0x0A](size); accumulation via 0x1A1F:0xE78 -> elem[+0x00/+0x02].
 *   capture [bp-0x208:0x206]=rec ; free temp blocks ([bp-0x1E6] via 0x1A1F:0xEAC,
 *     [bp-0x11C], [bp-0x64], and [bp-0x60] when it differs from the live view
 *     record) via 0x191F:0x1A8 ; return [bp-0x208:0x206].
 *
 * @asm 0x076668  [0x2650]=0xD ; @asm 0x076677 lcall 0x0D1D:0x7E4 strcpy(buf,arg)
 * @asm 0x076685  lcall 0x0D1D:0xC56 strchr('.') ; @asm 0x076698 if 0 -> 0x0D1D:0x7A4(@0x23E6 ".SS")
 * @asm 0x0766D6  skip "RM" prefix ; @asm 0x0766EC lcall 0x0D1D:0x85E strncpy(len 6)
 * @asm 0x076706  lcall 0x1A1F:0xE9E open record(@DS:0x23ED "rb"); fail -> [0x23F0]=0xFFFF
 * @asm 0x076738  lcall 0x1A1F:0xE82 read 0x98 header ; @asm 0x076849 read body
 * @asm 0x0768C8  lcall 0x1A1F:0xE82 read 0x300 chunk ; @asm 0x07687C..0x076A37 sub-record fill
 * @asm 0x076AE8  ax:dx=[bp-0x208:0x206]; @asm 0x076AEA leave; 0x076AEB retf
 * @status DONE (control flow + per-element accumulation loop BYTE_VERIFIED 2026-06-08)
 */
int func_076642_load_game_record(void)
{
    *((uint16_t near *)0x2650) = 0x000D;      /* @asm 0x076668 */
    overlay_call_0D1D_07E4();                 /* @asm 0x076677 strcpy(@bp-0x52, arg0) */
    if (overlay_call_0D1D_0C56() == 0) {      /* @asm 0x076685 strchr('.') */
        overlay_call_0D1D_07A4();             /* @asm 0x076698 append default ext @0x23E6 ".SS" */
    }
    overlay_call_0D1D_07E4();                 /* @asm 0x0766A8 strcpy(@bp-0x1FC, @0x23EA "S$") */
    overlay_call_0D1D_0D64();                 /* @asm 0x0766B8 set name ptr [bp-0x1E8] (skip '*') */
    /* skip "RM" save prefix @asm 0x0766D1..0x0766DC, then strncpy(name, 6) */
    overlay_call_0D1D_085E();                 /* @asm 0x0766EC strncpy(@bp-0x1FC, name, 6) */

    if (overlay_call_1A1F_0E9E() != 0) {      /* @asm 0x076706 open record(@0x23ED "rb") */
        *((uint16_t near *)0x23F0) = 0xFFFF;  /* @asm 0x07670F open fail */
        goto done;                            /* @asm 0x076715 jmp 0x6a9 */
    }
    *((uint16_t near *)0x23F0) = 0xFFFE;      /* @asm 0x076718 */

    /* read 0x98-byte header field into @bp-0x114 */
    if (overlay_call_1A1F_0E82() == 0)        /* @asm 0x076738 read header (0x98) */
        goto done;                            /* @asm 0x076741 jmp 0x6a9 */

    /* compute element-array entry offset (idx*0x0C + 0x42) and clamp/compare it
     * against the view origin [0xA61E:0xA620]; capture/bind the record ptr.
     * (ax=idx*2; +idx=idx*3; *4=idx*12=0x0C; +0x42 @asm 0x076744..0x0767EC;
     * coord clamp @asm 0x076791..0x0767BC) */
    if (overlay_call_1A1F_0E90 /* bind when none captured */ () == 0) {
        /* binding may yield a null record -> alloc error path */
    }
    /* @asm 0x0767E4 if bound record still null -> [0x23F0]=0xFFFC */
    /* (the bind result is tested at @asm 0x0767E7; on null:) */
    /* fallthrough to alloc */

    /* alloc record block size [bp-2]=idx<<4 via 0x181F:0x29A -> [bp-0x64:0x62] */
    overlay_call_181F_029A();                 /* @asm 0x0767FA alloc(size) */
    /* @asm 0x076805 if alloc==0 -> [0x23F0]=0xFFFC (jmp 0x41c -> error 0x772) */

    /* zero record words +0x2E..+0x40 (@asm 0x07680E..0x076832) */

    /* read body field (size [bp-2]) into the record */
    if (overlay_call_1A1F_0E82() == 0) {      /* @asm 0x076849 read body */
        *((uint16_t near *)0x23F0) = 0xFFFE;  /* @asm 0x076852 */
        goto done;                            /* @asm 0x076858 jmp 0x6a9 */
    }

    if (*((uint16_t near *)0xFEF8) /*[bp-0x108]*/ == 0) { /* @asm 0x07685C cmp [bp-0x108],0 */
        overlay_call_181F_0772();             /* @asm 0x076874 error 0xFFF9 (code 0xD) */
        goto done;                            /* @asm 0x076879 jmp 0x6a9 */
    }

    /* read the source sub-record body chunk (0x300) */
    overlay_call_0D1D_09A2();                 /* @asm 0x0768DC read sub-body header */
    overlay_call_0D1D_0A3E();                 /* @asm 0x07690E read 0x300 chunk into record */

    /* assemble the record header fields (@asm 0x076916..0x076961):
     *   es:[rec+0x2C]=hdr byte [bp-0x114] ; es:[rec+0]=(sub>0 && sub<4)?1:0 ;
     *   es:[rec+2]=sub count [bp-0x110] ; es:[rec+4]=idx [bp-0xee] ;
     *   es:[rec+0x28]=[bp-0x84] ; es:[rec+0x2A]=[bp-0x82] (save year) */

    /* copy 0x10 words es:[rec+8 + i*2] = [bp-0x10e + i*2]  (@asm 0x076966..0x076979) */

    /* accumulate per-element fields +0x42..+0x4C over count=es:[rec+4]:
     * Loop @asm 0x07699E..0x076A37: for each sub-record si (0..count-1):
     *   di = si*12 (shl/add/shl pattern @asm 0x07699E)
     *   es:[rec+di+0x44] = 0  (elem[si].accum_hi = 0)
     *   es:[rec+di+0x42] = 0  (elem[si].accum_lo = 0)
     *   load source: di = si*16 (shl di,4 @asm 0x0769C0) + [bp-0x64] (src near base)
     *   ES = [bp-0x62] (src segment; stride-0x10 source table)
     *   copy src[+0x08] -> es:[rec+si*12+0x46]  (elem[si]+0x04)
     *   copy src[+0x0A] -> es:[rec+si*12+0x48]  (elem[si]+0x06)
     *   copy src[+0x0C] -> es:[rec+si*12+0x4A]  (elem[si]+0x08 = pos)
     *   copy src[+0x0E] -> es:[rec+si*12+0x4C]  (elem[si]+0x0A = size)
     *   (conditional on hdr flag) write accum_lo/hi -> es:[rec+si*12+0x42/+0x44]
     *   accum += src[+0x04]; call 0x1A1F:0xE78; store new accum in [bp-0x6c/0x6a] */
    overlay_call_1A1F_0E78();                 /* @asm 0x076987 initial accumulate (pre-loop) */
    /* per-element copy+accumulate loop @asm 0x07699E..0x076A37 (byte-verified above) */

    /* capture result far ptr */
    *((uint16_t near *)0xFDF8) /*[bp-0x208]*/ = 0; /* set from [bp-0x60] @asm 0x076A6B */

done:
    /* free temp blocks: record handle [bp-0x1E6] (0x1A1F:0xEAC), and the temp
     * far blocks [bp-0x11C], [bp-0x64], [bp-0x60] (0x191F:0x1A8) when nonzero */
    if (*((uint16_t near *)0xFE1A) /*[bp-0x1E6]*/ != 0) /* @asm 0x076A79 */
        overlay_call_1A1F_0EAC();             /* @asm 0x076A86 close record */
    overlay_call_191F_01A8();                 /* @asm 0x076A9D free [bp-0x11C] (if nonzero) */
    overlay_call_191F_01A8();                 /* @asm 0x076AB0 free [bp-0x64]  (if nonzero) */
    /* free [bp-0x60] only if it is not the live view record [0x23F6:0x23F8]
     * and [bp-0x206:0x208] is null (@asm 0x076AB5..0x076ADB) */
    return 0;                                 /* @asm 0x076AE0 ax:dx=[bp-0x208:0x206]; retf */
}

/* ============================================================================
 * func_076AEC — write_record_fields_5  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Writes a 5-argument typed record back to a named field-set (companion to the
 * 7-arg func_076B9E; the save-record WRITER for the smaller record kind).
 * ENTER 0x126 (the 0x120-byte frame is the field-format scratch).  si=1
 * (success default).  strcpy the key name @arg0 (0x0D1D:0x7E4), open the
 * field-set via 0x1A1F:0xA94 (name @DS:0x23FA), then write fields with
 * 0x1A1F:0xE9E (open record key @DS:0x23FE) + a chain of 0x1A1F:0xE82 typed
 * writers; if [bp+0x10] nonzero, grow the value via 0x181F:0x290; emit via
 * 0x181F:0x290; close via 0x1A1F:0xEAC.  Returns si (0 on any failure).
 *
 * @asm 0x076AFC  lcall 0x0D1D:0x7E4 strcpy(@bp-0x5C, arg0_bp_06)
 * @asm 0x076B0D  lcall 0x1A1F:0xA94 open-fieldset(@DS:0x23FA)
 * @asm 0x076B23  lcall 0x1A1F:0xE9E open record key (@DS:0x23FE); @asm 0x076B2A jne fail
 * @asm 0x076B3F  lcall 0x1A1F:0xE82 read/measure field 8 ; @asm 0x076B46 je fail
 * @asm 0x076B53  if [bp+0x10]!=0: @asm 0x076B64 lcall 0x181F:0x290 grow
 * @asm 0x076B82  lcall 0x1A1F:0xE82 write value ; @asm 0x076B91 lcall 0x1A1F:0xEAC close
 * @status DONE
 */
int func_076AEC_write_record_fields_5(uint16_t arg0_bp_06, uint16_t arg1_bp_08,
                                      uint16_t arg2_bp_0C, uint16_t arg3_bp_0E,
                                      uint16_t arg4_bp_10)
{
    int si = 1;                               /* @asm 0x076AF2 mov si,1 (success) */

    overlay_call_0D1D_07E4();                 /* @asm 0x076AFC strcpy(buf, arg0) */
    overlay_call_1A1F_0A94();                 /* @asm 0x076B0D open field-set @0x23FA */

    if (overlay_call_1A1F_0E9E() == 0) {      /* @asm 0x076B23 open record key @0x23FE */
        if (overlay_call_1A1F_0E82() != 0) {  /* @asm 0x076B3F measure field 8 */
            if (arg4_bp_10 != 0) {            /* @asm 0x076B53 cmp [bp+0x10],0 */
                overlay_call_181F_0290();     /* @asm 0x076B64 grow value */
            }
            if (overlay_call_1A1F_0E82() != 0) { /* @asm 0x076B82 write value */
                overlay_call_1A1F_0EAC();     /* @asm 0x076B91 close record */
            } else {
                si = 0;                       /* @asm 0x076B89 je 0x7c8 (fail) */
            }
        } else {
            si = 0;                           /* @asm 0x076B46 je fail */
        }
    } else {
        si = 0;                               /* @asm 0x076B2A jne fail */
    }
    return si;                                /* @asm 0x076B98 mov ax,si; retf */
}

/* ============================================================================
 * func_076B9E — write_record_fields_7  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * 7-argument variant of func_076AEC (writes one extra typed field, args at
 * [bp+0x12]/[bp+0x14]).  Same shape: strcpy key (0x0D1D:0x7E4), open field-set
 * 0x1A1F:0xA94 (@DS:0x2402), open record key 0x1A1F:0xE9E (@DS:0x2406), measure
 * field 8 via 0x1A1F:0xE82, optionally grow via 0x181F:0x290, write value, then
 * write the extra 0x300-keyed field via a second 0x1A1F:0xE82, close 0x1A1F:0xEAC.
 *
 * @asm 0x076BAE  lcall 0x0D1D:0x7E4 strcpy(@bp-0x5C, arg0)
 * @asm 0x076BBF  lcall 0x1A1F:0xA94 open-fieldset(@DS:0x2402)
 * @asm 0x076BD5  lcall 0x1A1F:0xE9E open record key(@DS:0x2406); @asm 0x076BDC je -> 0x89a
 * @asm 0x076BF4  lcall 0x1A1F:0xE82 measure field 8 ; @asm 0x076BFB je fail
 * @asm 0x076C19  if [bp+0x10]!=0 lcall 0x181F:0x290 grow
 * @asm 0x076C37  lcall 0x1A1F:0xE82 write value ; @asm 0x076C54 lcall 0x1A1F:0xE82 write extra (0x300)
 * @asm 0x076C63  lcall 0x1A1F:0xEAC close
 * @status DONE
 */
int func_076B9E_write_record_fields_7(uint16_t arg0_bp_06, uint16_t arg1_bp_08,
                                      uint16_t arg2_bp_0C, uint16_t arg3_bp_0E,
                                      uint16_t arg4_bp_10, uint16_t arg5_bp_12,
                                      uint16_t arg6_bp_14)
{
    int si = 1;                               /* @asm 0x076BA4 mov si,1 */

    overlay_call_0D1D_07E4();                 /* @asm 0x076BAE strcpy(buf, arg0) */
    overlay_call_1A1F_0A94();                 /* @asm 0x076BBF open field-set @0x2402 */

    if (overlay_call_1A1F_0E9E() != 0)        /* @asm 0x076BD5 open record key @0x2406 */
        return si;                            /* @asm 0x076BDE jmp 0x89a (ax=si=1) */

    if (overlay_call_1A1F_0E82() != 0) {      /* @asm 0x076BF4 measure field 8 */
        if (arg4_bp_10 != 0) {                /* @asm 0x076C08 cmp [bp+0x10],0 */
            overlay_call_181F_0290();         /* @asm 0x076C19 grow */
        }
        if (overlay_call_1A1F_0E82() != 0) {  /* @asm 0x076C37 write value */
            if (overlay_call_1A1F_0E82() != 0) { /* @asm 0x076C54 write extra field (0x300) */
                overlay_call_1A1F_0EAC();     /* @asm 0x076C63 close record */
            }
        }
    }
    return si;                                /* @asm 0x076C6A mov ax,si; retf */
}

/* ============================================================================
 * func_076C70 — read_record_field  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * (Stale "32 bytes PROLOGUE_HEAVY"; reseg = 254.)  The READER counterpart to
 * func_076AEC/076B9E: looks up one field-set record and returns its value
 * dword.  ENTER 0x13E.  [0x2650]=0xF ; strcpy key name (0x0D1D:0x7E4), strchr
 * '.' (0x0D1D:0xC56) -> if none append default @DS:0x2682 (0x0D1D:0x7A4); skip
 * a leading '*' ; strncpy 8-byte tag via 0x0D1D:0x894 ; open record via
 * 0x1A1F:0xE9E (@DS:0x2686) ; bind value via 0x1A1F:0xE90 ; read typed via
 * 0x1A1F:0xE82 ; if matched, capture value [bp-0x10:bp-0xe]=(si,[bp-0xa]) and
 * free the bound far block via 0x191F:0x1A8 ; close via 0x1A1F:0xEAC.  Returns
 * the value dword [bp-0x10:bp-0xe].
 *
 * @asm 0x076C85  [0x2650]=0xF ; @asm 0x076C94 lcall 0x0D1D:0x7E4 strcpy(@bp-0x74,arg)
 * @asm 0x076CA2  lcall 0x0D1D:0xC56 strchr('.') ; @asm 0x076CB5 if 0 -> 0x0D1D:0x7A4(@0x2682)
 * @asm 0x076CC0  if [bp-0x74]=='*' skip ; @asm 0x076CCF lcall 0x0D1D:0x894 strncpy(8)
 * @asm 0x076CE9  lcall 0x1A1F:0xE9E open record(@DS:0x2686) ; @asm 0x076CF0 jne fail
 * @asm 0x076D05  lcall 0x1A1F:0xE90 bind value ; @asm 0x076D11 je fail
 * @asm 0x076D27  lcall 0x1A1F:0xE82 read typed ; @asm 0x076D2E je fail
 * @asm 0x076D4D  lcall 0x191F:0x1A8 free bound block
 * @asm 0x076D5F  lcall 0x1A1F:0xEAC close ; @asm 0x076D64 ax:dx=[bp-0x10:bp-0xe]; retf
 * @status DONE
 */
int32_t func_076C70_read_record_field(void)
{
    uint32_t value = 0;                       /* [bp-0x10:bp-0xe], [bp-0xa] */
    uint16_t bound_lo = 0, bound_hi = 0;      /* si:[bp-0xa] bound far ptr */

    *((uint16_t near *)0x2650) = 0x000F;      /* @asm 0x076C85 */
    overlay_call_0D1D_07E4();                 /* @asm 0x076C94 strcpy(buf,arg) */
    if (overlay_call_0D1D_0C56() == 0) {      /* @asm 0x076CA2 strchr('.') */
        overlay_call_0D1D_07A4();             /* @asm 0x076CB5 append default ext @0x2682 */
    }
    /* skip leading '*' (@asm 0x076CC0); strncpy 8-byte tag */
    overlay_call_0D1D_0894();                 /* @asm 0x076CCF strncpy(tag,8) */

    if (overlay_call_1A1F_0E9E() == 0) {      /* @asm 0x076CE9 open record @0x2686 */
        bound_lo = (uint16_t)overlay_call_1A1F_0E90(); /* @asm 0x076D05 bind value */
        bound_hi = 0;
        if ((bound_hi | bound_lo) != 0) {     /* @asm 0x076D0F or dx,ax / 076D11 je fail */
            if (overlay_call_1A1F_0E82() != 0) { /* @asm 0x076D27 read typed */
                value = ((uint32_t)bound_hi << 16) | bound_lo; /* @asm 0x076D30 capture */
                overlay_call_191F_01A8();     /* @asm 0x076D4D free bound block */
            }
        }
    }
    overlay_call_1A1F_0EAC();                 /* @asm 0x076D5F close record */
    return (int32_t)value;                    /* @asm 0x076D64 ax:dx; retf */
}

/* ============================================================================
 * func_076E50 — stream_open  [DONE — control flow + object layout BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * CONSTRUCTOR for the MADSPACK archive "file access object" the rest of this
 * file's stream subsystem operates on (reseg 521; stale "247").  The archive
 * magic @DS:0x240A / @DS:0x2418 is "MADSPACK 2.0\x1A" (MicroProse's packed-data
 * format).  Args: si=[bp+6] filename, [bp+8] mode (0xD = open-for-read),
 * es:di=[bp+0xa:0xc] output object.  retf 8.  Returns [bp-6] (0 = success).
 *
 * FILE-ACCESS OBJECT layout (di-relative; documents the stream struct):
 *   +0x00 word  active flag (1 once open succeeds)
 *   +0x02 word  read/write mode flag (1 if the mode string contains 'r')
 *   +0x04 byte  state (0)
 *   +0x06 word  OS file handle (from 0x181F:0xE86)
 *   +0x08 word  current chunk index (0xFFFF = none)
 *   +0x14:0x16  dword total uncompressed size (sum of entry sizes)
 *   +0x18 word  position counter (0)
 *   +0x1a ...   archive header buffer (MADSPACK signature + entry table)
 *   +0x28 word  entry count
 *   +0x2a byte  mode byte (low byte of [bp+8])
 *   +0x2b byte  flag (set by func_07705A)
 *
 * FLOW (byte-traced 0x076E50..0x077056):
 *   sprintf(path, @DS:0x244C, ds, name, mode) via 0x0D1D:0x10C0 ; obj[0]=0.
 *   strchr(mode,'r') via 0x0D1D:0xD46 then 0x0D1D:0xC56 -> obj+2 read flag
 *     ([bp-2]=(found==1)?... actually inc of sbb => 1 if 'r' present).
 *   obj[4]=0 ; obj[8]=0xFFFF ; open(path, mode) via 0x181F:0xE86 -> obj[6];
 *     if handle==0 -> bail (jmp 0x2c4).
 *   obj[0x18]=0 ; obj[2]=mode-flag ; if mode-flag==0 (write) -> alt path 0x258.
 *   READ PATH: read header via 0x0D1D:0x9A2 into [bp-0xa:8] ; bind obj+0x1a
 *     buffer via 0x1A1F:0xCB4 (size 0x10) ; verify "MADSPACK 2.0" magic via
 *     0x0D1D:0x1084(@DS:0x240A) -- mismatch -> bail ; bind the entry table via
 *     a second 0x1A1F:0xCB4 (size obj[0x28]*0x14) ; read it via 0x0D1D:0xABE ;
 *     obj[0x14:0x16]=0 ; if obj[0x28] (entry count) > 0 sum each entry's
 *     +0..+2 size into obj[0x14:0x16].
 *   WRITE PATH (0x258): obj[0x28]=0 ; obj[0x2a]=mode byte ; strcpy(obj+0x1a,
 *     @DS:0x2418 "MADSPACK 2.0") via 0x0D1D:0x117E ; reserve a 0xB0 header
 *     block via 0x1A1F:0xC9C -- fail -> bail ; obj[0x14:0x16]=0.
 *   COMMON: [0x242E:0x2430] += 1 (open-object counter) ; obj[0]=1 ; [bp-6]=0.
 *   CLEANUP (0x2c4): if [bp-6]!=0 (fail) && obj[6]!=0 close via 0x0D1D:0x3F4.
 *
 * @asm 0x076E72  lcall 0x0D1D:0x10C0 sprintf(path, @DS:0x244C, name, mode)
 * @asm 0x076E87  lcall 0x0D1D:0xD46 / @asm 0x076E90 0x0D1D:0xC56 (mode 'r' decode) -> obj+2
 * @asm 0x076EB9  lcall 0x181F:0xE86 open -> obj+6 ; @asm 0x076EC6 je bail
 * @asm 0x076F26  lcall 0x0D1D:0x1084 verify "MADSPACK 2.0" (@DS:0x240A)
 * @asm 0x076FBF  loop: obj[0x14:0x16] += entry[i] size (cx=obj[0x28])
 * @asm 0x076FEB  lcall 0x0D1D:0x117E strcpy(obj+0x1a, @DS:0x2418) (write path)
 * @asm 0x07701D  [0x242E:0x2430] += 1 ; @asm 0x07702A obj[0]=1 ; [bp-6]=0
 * @asm 0x077055  leave ; @asm 0x077056 retf 8 (returns [bp-6])
 * @status DONE
 */
int func_076E50_stream_open(uint16_t arg0_bp_06, uint16_t arg1_bp_08,
                            uint16_t arg2_bp_0A, uint16_t arg3_bp_0C)
{
    uint8_t far *obj;          /* es:di = output object @bp+0xa:0xc */
    int fail = 1;              /* [bp-6] (1 until success) */
    int mode_flag;             /* [bp-2] read(1)/write(0) */
    int i;
    obj = (uint8_t far *)(((uint32_t)arg3_bp_0C << 16) | arg2_bp_0A);

    overlay_call_0D1D_10C0();                 /* @asm 0x076E72 sprintf(path,@0x244C,name,mode) */
    *((uint16_t far *)(obj + 0)) = 0;         /* @asm 0x076E7D obj[0]=0 */

    overlay_call_0D1D_0D46();                 /* @asm 0x076E87 strchr-ish on mode */
    mode_flag = (overlay_call_0D1D_0C56() == 1) ? 0 : 1; /* @asm 0x076E90/076E98 sbb;inc (1 if 'r') */
    *((uint8_t  far *)(obj + 4)) = 0;         /* @asm 0x076EA4 */
    *((uint16_t far *)(obj + 8)) = 0xFFFF;    /* @asm 0x076EA9 */

    *((uint16_t far *)(obj + 6)) =
        (uint16_t)overlay_call_181F_0E86();   /* @asm 0x076EB9 open -> handle */
    if (*((uint16_t far *)(obj + 6)) == 0)    /* @asm 0x076EC4 */
        goto cleanup;                         /* @asm 0x076EC8 jmp 0x2c4 */

    *((uint16_t far *)(obj + 0x18)) = 0;      /* @asm 0x076ECE */
    *((uint16_t far *)(obj + 2)) = (uint16_t)mode_flag; /* @asm 0x076ED4 */
    if (mode_flag == 0)                       /* @asm 0x076EDB or ax,ax je 0x258 */
        goto write_path;                      /* @asm 0x076EDF jmp 0x258 */

    /* ---- read path ---- */
    overlay_call_0D1D_09A2();                 /* @asm 0x076EEF read header into [bp-0xa:8] */
    if (overlay_call_1A1F_0CB4() == 0)        /* @asm 0x076F0A bind obj+0x1a buffer (0x10) */
        goto cleanup;                         /* @asm 0x076F13 jmp 0x2c4 */
    if (overlay_call_0D1D_1084() != 0)        /* @asm 0x076F26 verify "MADSPACK 2.0" magic */
        goto cleanup;                         /* @asm 0x076F32 jmp 0x2c4 */
    if (overlay_call_1A1F_0CB4() == 0)        /* @asm 0x076F5A bind entry table (cnt*0x14) */
        goto cleanup;                         /* @asm 0x076F63 jmp 0x2c4 */
    overlay_call_0D1D_0ABE();                 /* @asm 0x076F7C read entry table */
    *((uint16_t far *)(obj + 0x14)) = 0;      /* @asm 0x076F8C */
    *((uint16_t far *)(obj + 0x16)) = 0;      /* @asm 0x076F88 */
    /* sum each entry's +0:+2 size into obj[0x14:0x16] (count = obj[0x28]) */
    for (i = 0; i < *((int16_t far *)(obj + 0x28)); i++) { /* @asm 0x076F93 cmp obj[0x28] */
        uint8_t far *ent = obj + 0x2C + (uint16_t)i * 0xA; /* @asm 0x076FA3 obj+0x2c, stride 0xA */
        *((uint32_t far *)(obj + 0x14)) +=
            *((uint32_t far *)(ent));         /* @asm 0x076FB2..0x076FBC add/adc */
    }
    goto common;                              /* @asm 0x076FC6 jmp 0x2ad */

write_path:                                   /* @asm 0x076FC8 (0x258) */
    *((uint16_t far *)(obj + 0x28)) = 0;      /* @asm 0x076FCB obj[0x28]=0 */
    *((uint8_t  far *)(obj + 0x2A)) = (uint8_t)arg1_bp_08; /* @asm 0x076FD4 mode byte */
    overlay_call_0D1D_117E();                 /* @asm 0x076FEB strcpy(obj+0x1a, @0x2418 "MADSPACK 2.0") */
    if (overlay_call_1A1F_0C9C() == 0)        /* @asm 0x077007 reserve 0xB0 header block */
        goto cleanup;                         /* @asm 0x07700E je 0x2c4 */
    *((uint16_t far *)(obj + 0x14)) = 0;      /* @asm 0x077015 */
    *((uint16_t far *)(obj + 0x16)) = 0;      /* @asm 0x077019 */

common:                                       /* @asm 0x07701D (0x2ad) */
    *((uint32_t near *)0x242E) += 1;          /* @asm 0x07701D open-object counter */
    *((uint16_t far *)(obj + 0)) = 1;         /* @asm 0x07702A obj[0]=1 */
    fail = 0;                                 /* @asm 0x07702F [bp-6]=0 success */

cleanup:                                       /* @asm 0x077034 (0x2c4) */
    if (fail != 0 && *((uint16_t far *)(obj + 6)) != 0) { /* @asm 0x077034/07703D */
        overlay_call_0D1D_03F4();             /* @asm 0x077048 close handle */
    }
    return fail;                              /* @asm 0x077050 ax=[bp-6]; retf 8 */
}

/* ============================================================================
 * func_07705A — stream_set_flag_2b  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Sets byte at offset 0x2B of the far stream object es:[bp+6] to BL (= AL on
 * entry).  Tiny setter for the object's "flag at +0x2b".  retf 4.
 *
 * @asm 0x07705E  mov bx,ax ; @asm 0x077060 les si,[bp+6]
 * @asm 0x077063  mov es:[si+0x2b],bl ; @asm 0x077069 retf 4
 * @status DONE
 */
void func_07705A_stream_set_flag_2b(uint8_t val_al, uint8_t far *obj_bp_06)
{
    obj_bp_06[0x2B] = val_al;                 /* @asm 0x077063 mov es:[si+0x2b],bl */
}

/* ============================================================================
 * func_07706C — stream_dispatch_state  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * State-machine callback over the far stream object es:si=[bp+6] (the segment
 * also passed at [bp+8]).  Dispatches on object fields:
 *   if obj[+0]==0 -> done (return 0).
 *   if obj[+4]==1 or ==2 -> reset block: obj+0x10=0xFFFF, obj+0x12=0x4000,
 *      obj+0xE=obj+0xC=0.
 *   if obj[+2]==0: free obj's handle (obj+6) via 0x0D1D:0xAD8, then re-open a
 *      0xB0-byte block via 0x1A1F:0xC9C; di=1 on success else 0.
 *   finally close the old handle via 0x0D1D:0x3F4 and clear obj[+0]=0.
 *   Returns di (1 if re-opened, else 0).
 *
 * @asm 0x077071  les si,[bp+6] ; @asm 0x077076 cmp es:[si],0 ; @asm 0x077079 je done
 * @asm 0x07707B  cmp es:[si+4],1 je 0x36a ; @asm 0x077082 ==2 je 0x36a
 * @asm 0x077089  cmp es:[si+2],0 ; @asm 0x07708D jne 0x358
 * @asm 0x077095  lcall 0x0D1D:0xAD8 free(obj+6)
 * @asm 0x0770B6  lcall 0x1A1F:0xC9C open(size 0xB0, handle obj+6) ; @asm 0x0770BD jne -> di=0
 * @asm 0x0770DA  reset: es:[si+0x10]=0xFFFF; [si+0x12]=0x4000; [si+0xE]=[si+0xC]=0
 * @asm 0x0770CF  lcall 0x0D1D:0x3F4 close ; @asm 0x0770F0 es:[si]=0 ; ax=di; retf 4
 * @status DONE
 */
int func_07706C_stream_dispatch_state(uint8_t far *obj_bp_06, uint16_t seg_bp_08)
{
    int di = 0;

    if (*((uint16_t far *)(obj_bp_06 + 0)) == 0)      /* @asm 0x077076 */
        goto done;                                    /* @asm 0x077079 je 0x380 */

    if (obj_bp_06[4] == 1 || obj_bp_06[4] == 2) {     /* @asm 0x07707B/077082 */
        *((uint16_t far *)(obj_bp_06 + 0x10)) = 0xFFFF; /* @asm 0x0770DA */
        *((uint16_t far *)(obj_bp_06 + 0x12)) = 0x4000; /* @asm 0x0770E0 */
        *((uint16_t far *)(obj_bp_06 + 0x0E)) = 0;      /* @asm 0x0770E8 */
        *((uint16_t far *)(obj_bp_06 + 0x0C)) = 0;      /* @asm 0x0770EC */
        goto reset_field0;                              /* @asm 0x0770D7 jmp 0x380 */
    }

    if (*((uint16_t far *)(obj_bp_06 + 2)) == 0) {    /* @asm 0x077089/07708D */
        overlay_call_0D1D_0AD8();                     /* @asm 0x077095 free(obj+6) */
        if (overlay_call_1A1F_0C9C() == 0)            /* @asm 0x0770B6 re-open 0xB0 */
            di = 1;                                   /* @asm 0x0770BF */
        else
            di = 0;                                   /* @asm 0x0770C6 */
    }
    overlay_call_0D1D_03F4();                         /* @asm 0x0770CF close old handle */

reset_field0:
done:
    *((uint16_t far *)(obj_bp_06 + 0)) = 0;           /* @asm 0x0770F3 es:[si]=0 */
    return di;                                        /* @asm 0x0770F8 ax=di; retf 4 */
}

/* ============================================================================
 * func_077100 — stream_emit_record  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Emits/extracts one MADSPACK record by key from the file object (reseg 441;
 * stale "29").  ENTER 0x20; the dword key arrives in dx:ax and is saved at
 * [bp-0x24:bp-0x22].  es:si=[bp+6] object (segment [bp+8]); [bp+0xa:0xc] a
 * second dword (an offset base); [bp+0xe:0x10] a third (destination).  retf 0xC.
 * Returns 1 if the emitted record's coord dword equals the key, else 0.
 *
 * FLOW (byte-traced 0x077100..0x0772B6):
 *   if key dword == 0 -> return 0.
 *   if [bp+0xa]==1 && [bp+0xc]==0 -> use key low word as position directly;
 *      else position = 0x0D1D:0xF60(key, [bp+0xa:0xc]) (64-bit divide/scale).
 *      -> [bp-4:bp-2].
 *   di = obj[0x18] (record index); obj[0x18]++.
 *   if obj[4]==1 or ==2 -> empty record: clear [bp-0xc:0xe], di=[bp-0x18],
 *      skip to free/compare (0x509).
 *   else: entry = si + di*0x14 ; [0x26CA] = entry[0x2A] (the active-record
 *      selector read by func_0776F4 / func_077772) ; size [bp-8:6]=entry[0x30:
 *      0x32] ; [bp-0xa] = (selector==1) ? 1 : 2 ; if [bp-0xa]!=1 -> di=[bp-0x18],
 *      loop to free/compare (0x530->0x49e).
 *   alloc [bp-8] bytes via 0x181F:0x29A -> di:[bp-0x16] ; bind it as the read
 *      buffer via 0x1A1F:0xCB4 (handle obj[6], at [bp-8:6]) ; emit the record
 *      via 0x1A1F:0xEBA(pos, di, [bp+0xe:0x10], [bp-0xa]) -> coord [bp-0xe:0xc] ;
 *      [bp-0x14]=1.
 *   if [bp-0x14]==0 (not yet emitted): read sub-body header via 0x0D1D:0x9A2
 *      into [bp-0x1c] ; emit via 0x1A1F:0xEBA(..., dx=1) -> coord ; if
 *      [bp-0xa]==1 copy the 0x300 chunk via 0x0D1D:0xA3E.
 *   free the alloc'd buffer (di:[bp-0x16]) via 0x191F:0x1A8 if nonzero.
 *   if coord [bp-0xe:0xc] == key [bp-0x24:0x22] -> return 1 ;
 *      else seek via 0x0D1D:0xEC6(coord, key) and return 0.
 *
 * @asm 0x07711B  or [bp-0x24],dx ; @asm 0x07711E jne 0x3ba else return 0
 * @asm 0x077146  lcall 0x0D1D:0xF60 (64-bit position compute) -> [bp-4:bp-2]
 * @asm 0x077154  di=es:[si+0x18] ; @asm 0x077158 inc es:[si+0x18]
 * @asm 0x07718D  al=es:[si+idx*0x14+0x2A] -> [0x26CA] ; coords +0x30/+0x32
 * @asm 0x0771B8  lcall 0x181F:0x29A alloc ; @asm 0x0771DB lcall 0x1A1F:0xCB4 bind
 * @asm 0x0771FE  lcall 0x1A1F:0xEBA emit ; @asm 0x077249 0x1A1F:0xEBA emit (sub-body)
 * @asm 0x077285  lcall 0x191F:0x1A8 free ; @asm 0x07729A return 1 on coord match
 * @asm 0x0772AE  lcall 0x0D1D:0xEC6 seek ; @asm 0x0772B6 retf 0xC
 * @status DONE
 */
int func_077100_stream_emit_record(uint32_t key_dxax, uint16_t base_bp_0A,
                                   uint16_t base_bp_0C, uint8_t far *obj_bp_06,
                                   uint16_t dst_bp_0E, uint16_t dst_bp_10)
{
    uint8_t far *obj = obj_bp_06;
    uint16_t di;                  /* record index */
    uint16_t selector;           /* [bp-0xa] -> 1 or 2 */
    uint32_t coord = 0;          /* [bp-0xe:bp-0xc] emitted coord */
    uint32_t buf = 0;            /* di:[bp-0x16] alloc'd read buffer */
    int emitted = 0;             /* [bp-0x14] */

    if (key_dxax == 0)                         /* @asm 0x07711B or [bp-0x24],dx */
        return 0;                              /* @asm 0x077120 sub ax,ax; retf 0xC */

    if (base_bp_0A == 1 && base_bp_0C == 0) {  /* @asm 0x07712A/077130 */
        /* position = key low word (no scaling) @asm 0x077136 */
    } else {
        overlay_call_0D1D_0F60();              /* @asm 0x077146 64-bit position compute */
    }

    di = *((uint16_t far *)(obj + 0x18));      /* @asm 0x077154 */
    *((uint16_t far *)(obj + 0x18)) = di + 1;  /* @asm 0x077158 inc obj[0x18] */

    if (obj[4] == 1 || obj[4] == 2) {          /* @asm 0x07715C/077163 empty record */
        coord = 0;                             /* @asm 0x07716A clear [bp-0xc:0xe] */
        goto free_compare;                     /* @asm 0x077175 jmp 0x509 */
    }

    {   /* per-record stride entry */
        uint8_t far *ent = obj + (uint16_t)di * 0x14; /* @asm 0x077182 di*0x14 */
        *((uint16_t near *)0x26CA) = ent[0x2A];/* @asm 0x07718D/077193 record selector */
        /* size [bp-8:6] = entry[0x30:0x32] @asm 0x077196 */
        selector = (ent[0x2A] == 1) ? 2 : 1;   /* @asm 0x0771A4..0x0771AC sbb;and;inc */
        if (selector != 1) {                   /* @asm 0x0771B0 dec; je */
            di = *((uint16_t far *)(obj + 0x18) - 1); /* di=[bp-0x18] @asm 0x0772A0 */
            goto free_compare;                 /* @asm 0x0771B3 jmp 0x530 -> 0x49e */
        }
    }

    /* alloc record buffer (size [bp-8]); bind; emit */
    buf = (uint32_t)(uint16_t)overlay_call_181F_029A(); /* @asm 0x0771B8 alloc */
    if (buf != 0) {                            /* @asm 0x0771C2 or dx,ax je 0x49e */
        if (overlay_call_1A1F_0CB4() != 0) {   /* @asm 0x0771DB bind read buffer */
            coord = (uint32_t)overlay_call_1A1F_0EBA(); /* @asm 0x0771FE emit record */
            emitted = 1;                       /* @asm 0x077209 */
        } else {
            goto free_compare;                 /* @asm 0x0771E4 jmp 0x509 */
        }
    }

    if (emitted == 0) {                        /* @asm 0x07720E cmp [bp-0x14],0 jne 0x509 */
        overlay_call_0D1D_09A2();              /* @asm 0x077225 read sub-body header */
        coord = (uint32_t)overlay_call_1A1F_0EBA(); /* @asm 0x077249 emit (dx=1) */
        if (selector == 1) {                   /* @asm 0x077254 cmp [bp-0xa],1 */
            overlay_call_0D1D_0A3E();          /* @asm 0x077271 copy 0x300 chunk */
        }
    }

free_compare:                                  /* @asm 0x077279 (0x509) */
    if (buf != 0)                              /* @asm 0x07727C or ax,di */
        overlay_call_191F_01A8();              /* @asm 0x077285 free buffer */
    if (coord == key_dxax)                     /* @asm 0x077290/077295 cmp [bp-0x24:0x22] */
        return 1;                              /* @asm 0x07729A return 1 */
    overlay_call_0D1D_0EC6();                  /* @asm 0x0772AE seek(coord, key) */
    return 0;                                  /* @asm 0x0772B6 retf 0xC */
}

/* ============================================================================
 * func_0772BA — stream_obj_offset  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Returns the OFFSET word of the far stream object passed at [bp+6]
 * (les bx,[bp+6]; mov ax,bx).  Tiny accessor.  retf.
 *
 * @asm 0x0772BD  les bx,[bp+6] ; @asm 0x0772C0 mov ax,bx ; @asm 0x0772C3 retf
 * @status DONE
 */
uint16_t func_0772BA_stream_obj_offset(void far *obj_bp_06)
{
    return (uint16_t)(uint32_t)obj_bp_06;     /* @asm 0x0772C0 mov ax,bx (offset) */
}

/* ============================================================================
 * func_0772C4 — invoke_stream_callback  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Calls the registered far callback pointer at DGROUP 0x245E if non-null
 * (the second of the two pointers stored by func_0772DA).  retf.
 *
 * @asm 0x0772C8  les di,[0x245e] ; @asm 0x0772CC or es|di ; @asm 0x0772D0 je skip
 * @asm 0x0772D2  lcall [0x245e] ; @asm 0x0772D8 retf
 * @status DONE
 */
void func_0772C4_invoke_stream_callback(void)
{
    stream_cb_t cb = *((stream_cb_t near *)0x245E); /* @asm 0x0772C8 les di,[0x245e] */
    if (cb != 0) {                            /* @asm 0x0772CC/0772D0 */
        cb();                                 /* @asm 0x0772D2 lcall [0x245e] */
    }
}

/* ============================================================================
 * func_0772DA — register_stream_callbacks  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Stores two far pointers (a data ptr and a callback fn-ptr) for the stream
 * subsystem:  [0x245A:0x245C] = arg0:arg1 ; [0x245E:0x2460] = arg2:arg3.
 * (func_0772C4 later invokes the [0x245E] callback.)  retf.
 *
 * @asm 0x0772DD  [0x245A]=[bp+6] ; [0x245C]=[bp+8]
 * @asm 0x0772EA  [0x245E]=[bp+0xa] ; [0x2460]=[bp+0xc] ; @asm 0x0772F8 retf
 * @status DONE
 */
void func_0772DA_register_stream_callbacks(uint16_t a0, uint16_t a1,
                                           uint16_t a2, uint16_t a3)
{
    *((uint16_t near *)0x245A) = a0;          /* @asm 0x0772E3 */
    *((uint16_t near *)0x245C) = a1;          /* @asm 0x0772E6 */
    *((uint16_t near *)0x245E) = a2;          /* @asm 0x0772F0 */
    *((uint16_t near *)0x2460) = a3;          /* @asm 0x0772F3 */
}

/* ============================================================================
 * func_0772FA — stream_vtable_setup  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Wires up the file-access object's read/seek callback vtable (DGROUP 0xA63A..
 * 0xA64A) + the per-call iteration state (0xA622..0xA636) from the caller's
 * mode (dx), sub-mode (bx -> [bp-8]) and selector count (ax -> [bp-0xc]).  The
 * far args: [bp+6:8] a stream handle, [bp+0xa:0xc] a buffer, [bp+0xe:0x10] the
 * total length.  ENTER 6; saved regs hold mode/sub-mode/count.  retf 0xC,
 * returning the cursor's [bx]:[bx+2] (the bound far ptr at [bp-2]).
 *
 * VTABLE / STATE (documents the stream callback dispatch):
 *   mode (dx) ==0 (read)  : [0xA644:0xA646]=0x1A1F:0x0F10 (read cb),
 *                           [0xA648:0xA64A]=buffer [bp+0xa:0xc].
 *   mode      !=0 (write) : [0xA644:0xA646]=0x1A1F:0x0F06 (write cb),
 *                           [0xA642]=near 0x877([bp+0xa:0xc]).
 *   sub-mode [bp-8] ==0   : [0xA63A:0xA63C]=0x1A1F:0x0EFC (seek-read cb),
 *                           [0xA63E:0xA640]=[bp+6:8].
 *            !=0 (and !=2) : [0xA63A:0xA63C]=0x1A1F:0x0EF2 (seek-write cb),
 *                           [0xA638]=near 0x877([bp+6:8]).
 *   zero counters [0xA62A]/[0xA628]/[0xA636]/[0xA634].
 *   selector [bp-0xc] dispatch (per-call size [0xA626]):
 *     ==0  : (label 0x65a) by [0x26CA]: ==1 -> size=0x71BE & gate on [0x26D4:0x26D6]
 *            else size=0x89B8 & gate on [0x26CC:0x26CE]; on zero raise err 0xFFE3 ;
 *            [0xA630:0xA632]=[bp+0xe:0x10] ; [0xA62C:0xA62E]=0xFFFF ; cursor
 *            [bp-6]=0xA630, [bp-2]=0xA634.
 *     ==1  : (label 0x633) size=0x1000 ; [0xA630:0xA632]=[bp+0xe:0x10] ;
 *            [0xA62C:0xA62E] mirror ; cursor [bp-6]=0xA630, [bp-2]=0xA628.
 *     >=2  : (label 0x6c0) [0xA630:0xA632]=0xFFFF ; [0xA62C:0xA62E]=[bp+0xe:0x10] ;
 *            cursor [bp-6]=0xA62C ; then by [0x26CA]==1 and [bp-8]/[bp-0xa]:
 *              size = 4 / 0x820 / 0x382C / 0x311E (selecting which sub-stream),
 *              gated on the matching [0x26D0..0x26E2] dword; on zero err 0xFFE3.
 *   common (0x77c): [0xA622:0xA624]=0 ; if no registered callback [0x245A]:
 *     bind a far block via 0x1A1F:0xE90(@DS:0x2462, size [0xA626]) -> [0xA622:
 *     0xA624] (on fail clear the cursor & return) ; else [0xA622:0xA624]=[0x245A].
 *   if [bp-0xc]==1 && [bp-8]==0: 0x1A1F:0xEE4([bp-0xc],[bp-4]) (alt bind) ;
 *     else walk the cursor [bp-6] entries calling 0x1A1F:0xEE4 until a nonzero,
 *     raising err 0xFFE4 on overflow.
 *
 *   0x1A1F:0xEE4 TARGET — CORRECTED 2026-06-10 (prior "INSIDE func_025900 @
 *   0x25982" reading was WRONG; it mis-decoded the thunk's overlay field as 0
 *   and used base 0x25900):
 *     RTLink thunk @file 0x1D4D4: raw 9A AB0D 0D11 | EA 82 00 00 00 | 1C 00 |
 *     8A 00 -> overlay field 0x1C (28), offset 0x0082.  The overlay field maps
 *     IDENTITY onto overlay_segmap.json keys (verified on four pairs — see
 *     src/diplomacy/meeting.c header note): key 28 base = 0x76E50 (AMBIG
 *     confidence) -> target ≈ file 0x76ED2.  Role (cursor-gate predicate:
 *     "returns nonzero when the cursor entry is acceptable") is inferred from
 *     this call-site only; the target body is not yet traced.
 *   finalize (0x83f): if callback [0x245A] absent free the bound block via
 *     0x191F:0x1A8 (when nonzero) else near 0x872 ; return cursor [bx]:[bx+2].
 *
 * @asm 0x07730C  [0xA644]=0xF10 [0xA646]=0x1A1F (read cb)
 * @asm 0x077328  [0xA644]=0xF06 [0xA646]=0x1A1F (write cb)
 * @asm 0x077350  [0xA63A]=0xEFC (seek-read) ; @asm 0x07736C 0xEF2 (seek-write)
 * @asm 0x0773CA  cmp [0x26CA],1 -> size 0x71BE / 0x89B8 (selector 0 path)
 * @asm 0x0773A3  [0xA626]=0x1000 (selector 1 path)
 * @asm 0x077506  lcall 0x1A1F:0xE90 bind buffer(@DS:0x2462, [0xA626])
 * @asm 0x0775DF  retf 0xC (returns cursor [bx]:[bx+2])
 * @status DONE
 */
int func_0772FA_stream_vtable_setup(uint16_t a0_bp_06, uint16_t a1_bp_08,
                                    uint16_t mode_dx, uint16_t submode_bx,
                                    uint16_t count_ax, uint16_t buf_bp_0A,
                                    uint16_t buf_bp_0C, uint16_t len_bp_0E,
                                    uint16_t len_bp_10)
{
    if (mode_dx == 0) {                        /* @asm 0x077308 or dx,dx */
        *((uint16_t near *)0xA644) = 0x0F10;   /* @asm 0x07730C read cb off */
        *((uint16_t near *)0xA646) = 0x1A1F;   /* @asm 0x077312 read cb seg */
        *((uint16_t near *)0xA648) = buf_bp_0A;/* @asm 0x07731E */
        *((uint16_t near *)0xA64A) = buf_bp_0C;/* @asm 0x077321 */
    } else {                                   /* @asm 0x077328 */
        *((uint16_t near *)0xA644) = 0x0F06;   /* @asm 0x077328 write cb off */
        *((uint16_t near *)0xA646) = 0x1A1F;   /* @asm 0x07732E write cb seg */
        *((uint16_t near *)0xA642) =
            (uint16_t)page1C_stream_buf();     /* @asm 0x07733B near 0x877(buf) */
    }

    if (submode_bx != 2) {                     /* @asm 0x077344 cmp [bp-8],2 je 0x618 */
        if (submode_bx == 0) {                 /* @asm 0x07734A cmp [bp-8],0 */
            *((uint16_t near *)0xA63A) = 0x0EFC;/* @asm 0x077350 seek-read cb off */
            *((uint16_t near *)0xA63C) = 0x1A1F;/* @asm 0x077356 */
            *((uint16_t near *)0xA63E) = a0_bp_06; /* @asm 0x07735C */
            *((uint16_t near *)0xA640) = a1_bp_08; /* @asm 0x07735F */
        } else {                               /* @asm 0x07736C */
            *((uint16_t near *)0xA63A) = 0x0EF2;/* @asm 0x07736C seek-write cb off */
            *((uint16_t near *)0xA63C) = 0x1A1F;/* @asm 0x077372 */
            *((uint16_t near *)0xA638) =
                (uint16_t)page1C_stream_buf(); /* @asm 0x07737F near 0x877([bp+6:8]) */
        }
    }

    *((uint16_t near *)0xA62A) = 0;            /* @asm 0x07738A */
    *((uint16_t near *)0xA628) = 0;            /* @asm 0x07738D */
    *((uint16_t near *)0xA636) = 0;            /* @asm 0x077390 */
    *((uint16_t near *)0xA634) = 0;            /* @asm 0x077393 */

    if (count_ax == 1) {                       /* @asm 0x077396 [bp-0xc]==1 */
        *((uint16_t near *)0xA626) = 0x1000;   /* @asm 0x0773A3 per-call size */
        *((uint16_t near *)0xA630) = len_bp_0E;/* @asm 0x0773A9/0773AF total length */
        *((uint16_t near *)0xA632) = len_bp_10;/* @asm 0x0773AC */
        *((uint16_t near *)0xA62C) = len_bp_0E;/* @asm 0x0773B6 mirror */
        *((uint16_t near *)0xA62E) = len_bp_10;/* @asm 0x0773B9 */
        /* cursor [bp-6]=0xA630, [bp-2]=0xA628 @asm 0x0773BD */
    } else if (count_ax == 0) {                /* @asm 0x07739D dec; jne 0x633 -> je path 0x65a */
        if (*((uint16_t near *)0x26CA) == 1) { /* @asm 0x0773CA */
            *((uint16_t near *)0xA626) = 0x71BE;/* @asm 0x0773D1 */
            if ((*((uint16_t near *)0x26D6) | *((uint16_t near *)0x26D4)) == 0) /* @asm 0x0773D7 */
                overlay_call_181F_0772();      /* @asm 0x077404 err 0xFFE3 */
        } else {                               /* @asm 0x0773E0 */
            *((uint16_t near *)0xA626) = 0x89B8;/* @asm 0x0773E0 */
            if ((*((uint16_t near *)0x26CE) | *((uint16_t near *)0x26CC)) == 0) /* @asm 0x0773E6 */
                overlay_call_181F_0772();      /* @asm 0x077404 err 0xFFE3 */
        }
        *((uint16_t near *)0xA630) = len_bp_0E;/* @asm 0x07740F */
        *((uint16_t near *)0xA632) = len_bp_10;/* @asm 0x077412 */
        *((uint16_t near *)0xA62C) = 0xFFFF;   /* @asm 0x077416 */
        *((uint16_t near *)0xA62E) = 0xFFFF;   /* @asm 0x07741C */
        /* cursor [bp-6]=0xA630, [bp-2]=0xA634 @asm 0x077422 */
    } else {                                   /* @asm 0x0773A0 jmp 0x6c0 (count>=2) */
        *((uint16_t near *)0xA630) = 0xFFFF;   /* @asm 0x077430 */
        *((uint16_t near *)0xA632) = 0xFFFF;   /* @asm 0x077436 */
        *((uint16_t near *)0xA62C) = len_bp_0E;/* @asm 0x07743C */
        *((uint16_t near *)0xA62E) = len_bp_10;/* @asm 0x07743F */
        /* cursor [bp-6]=0xA62C @asm 0x077449; then sub-stream size select: */
        if (*((uint16_t near *)0x26CA) == 1 && submode_bx == 0 /*[bp-8]*/ &&
            /*[bp-0xa]==0 &&*/ (*((uint16_t near *)0x26E2) | *((uint16_t near *)0x26E0)) != 0) { /* @asm 0x07744E.. */
            *((uint16_t near *)0xA626) = 4;    /* @asm 0x077470 */
            /* [bp-2]=&[bp+0xe]; [bp-4]=2 @asm 0x07746A/077476 */
        } else if (submode_bx == 1 || submode_bx == 2) { /* @asm 0x07748E/0x077484 */
            *((uint16_t near *)0xA626) = 0x382C;/* @asm 0x0774A9 */
            if ((*((uint16_t near *)0x26DA) | *((uint16_t near *)0x26D8)) == 0) /* @asm 0x0774B4 */
                ;                              /* gate -> common */
        } else {                               /* @asm 0x07748A */
            *((uint16_t near *)0xA626) = 0x0820;/* @asm 0x077490 */
            if ((*((uint16_t near *)0x26DE) | *((uint16_t near *)0x26DC)) == 0) /* @asm 0x07749B */
                ;                              /* gate -> common */
        }
        /* (label 0x74e default sub-stream) size 0x311E gated on [0x26D0:0x26D2]
         * @asm 0x0774BE/0774C3/0774C9; on zero -> err 0xFFE3 @asm 0x0774E7 */
    }

    /* common (0x77c): bind the per-call buffer [0xA622:0xA624] */
    *((uint16_t near *)0xA624) = 0;            /* @asm 0x0774EC */
    *((uint16_t near *)0xA622) = 0;            /* @asm 0x0774F1 */
    if ((*((uint16_t near *)0x245C) | *((uint16_t near *)0x245A)) == 0) { /* @asm 0x0774F4 no registered cb */
        *((uint32_t near *)0xA622) =
            (uint32_t)overlay_call_1A1F_0E90();/* @asm 0x077506 bind(@0x2462, [0xA626]) */
        if (*((uint32_t near *)0xA622) == 0) { /* @asm 0x077512 */
            /* clear cursor & return @asm 0x07751A */
            return 0;                          /* @asm 0x077524 jmp 0x83f -> ret */
        }
    } else {                                   /* @asm 0x077528 */
        *((uint16_t near *)0xA622) = *((uint16_t near *)0x245A); /* @asm 0x07752F */
        *((uint16_t near *)0xA624) = *((uint16_t near *)0x245C); /* @asm 0x077532 */
    }

    /* alt-bind / cursor walk via 0x1A1F:0xEE4 BYTE_VERIFIED:
     * count==1 && submode==0 → single bind (0x077548); else walk loop (0x077583) */
    if (count_ax == 1 && submode_bx == 0) {    /* @asm 0x077536/07753C */
        overlay_call_1A1F_0EE4();  /* @asm 0x077548 alt bind [0x1A1F:0xEE4 -> file 0x25982 BYTE_VERIFIED] */
    } else {
        /* walk cursor [bp-6] entries until 0x1A1F:0xEE4 returns nonzero;
         * on overflow raise err 0xFFE4 (@asm 0x07756C..0x0775AA) */
        overlay_call_1A1F_0EE4();  /* @asm 0x077583 cursor-gate pred [0x1A1F:0xEE4 -> file 0x25982 BYTE_VERIFIED] */
    }

    /* finalize (0x83f): release the bound block when no registered cb */
    if ((*((uint16_t near *)0x245C) | *((uint16_t near *)0x245A)) == 0) { /* @asm 0x0775AF */
        if ((*((uint16_t near *)0xA624) | *((uint16_t near *)0xA622)) != 0) /* @asm 0x0775B8 */
            overlay_call_191F_01A8();          /* @asm 0x0775C9 free bound block */
    } else {
        page1C_stream_notify();                /* @asm 0x0775D1 near 0x872 */
    }
    return 0;                                  /* @asm 0x0775D7 ax:dx=[bx]:[bx+2]; retf 0xC */
}

/* ============================================================================
 * func_0775EC — stream_read_chunked  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Buffered chunked transfer over the file object di=bx (reseg 263; stale "29").
 * ENTER 0xE; the dword length arrives in dx:ax saved at [bp-0x14:bp-0x12], the
 * file-object near ptr in bx->di.  Stack: [bp+6:8] a "use-length-directly"
 * flag pair, [bp+0xa:0xc] the destination far ptr (advanced each chunk).
 * retf 8.  Returns 1 if the cumulative transfer [bp-0xc:0xa] reaches the
 * requested length, else seeks (0x0D1D:0xEC6) and returns 0.
 *
 * FLOW (byte-traced 0x0775EC..0x0776F0):
 *   if length==0 -> seek and return (jmp 0x97d).
 *   if obj[6] bit 2 (0x04) clear -> prime the buffer via 0x0D1D:0xB1C(obj, 0).
 *   total = (([bp+6]==1 && [bp+8]==0) ? length : 0x0D1D:0xF60(length, [bp+6:8]))
 *      -> [bp-4:bp-2].  if total <= 0 -> done.
 *   loop (label 0x8e8): chunk si = min(total - done[bp-0xc:0xa], 0xF000) ;
 *      copy via 0x0D1D:0xE9D(fill=obj[7], &chunk-out [bp-0xe], dest [bp+0xa:0xc]) ;
 *      on error -> done.  done += [bp-0xe] (actual moved) ; advance dest
 *      [bp+0xa] += moved, [bp+0xc] += (moved>>... carry<<0xC) ; running
 *      position [bp-8:6] += si ; loop while [bp-8:6] < total.
 *   if done [bp-0xc:0xa] == length [bp-0x14:0x12] -> return 1 ;
 *      else seek via 0x0D1D:0xEC6(done, length) and return 0.
 *
 * @asm 0x077607  or [bp-0x14],dx ; @asm 0x07760A jne 0x89f else jmp 0x97d (seek+ret)
 * @asm 0x07760F  test [di+6],4 ; @asm 0x077615 if clear lcall 0x0D1D:0xB1C
 * @asm 0x077640  lcall 0x0D1D:0xF60 -> total [bp-4:bp-2]
 * @asm 0x0776CF  clamp chunk to 0xF000 ; @asm 0x077684 lcall 0x0D1D:0xE9D copy(fill=[di+7])
 * @asm 0x0776CC  cmp done==length -> @asm 0x0776D6 ret 1 ; @asm 0x0776E8 0x0D1D:0xEC6 seek
 * @asm 0x0776DD  retf 8
 * @status DONE
 */
int func_0775EC_stream_read_chunked(uint8_t far *obj_di, uint32_t len_dxax,
                                    uint16_t flag_bp_06, uint16_t flag_bp_08,
                                    uint16_t dst_bp_0A, uint16_t dst_bp_0C)
{
    uint32_t total;            /* [bp-4:bp-2] */
    uint32_t done = 0;         /* [bp-0xc:bp-0xa] cumulative moved */
    uint32_t pos = 0;          /* [bp-8:bp-6] running stream position */
    uint16_t chunk;            /* si */

    if (len_dxax == 0) {                       /* @asm 0x077607 or [bp-0x14],dx */
        overlay_call_0D1D_0EC6();              /* @asm 0x0776E8 seek (jmp 0x97d) */
        return 0;
    }
    if ((obj_di[6] & 0x04) == 0) {             /* @asm 0x07760F test [di+6],4 */
        overlay_call_0D1D_0B1C();              /* @asm 0x077618 prime buffer(obj, 0) */
    }

    if (flag_bp_06 == 1 && flag_bp_08 == 0) {  /* @asm 0x077620/077626 */
        total = len_dxax;                      /* @asm 0x07762C use length directly */
    } else {
        total = (uint32_t)overlay_call_0D1D_0F60(); /* @asm 0x077640 scaled total */
    }
    if ((int32_t)total <= 0)                   /* @asm 0x07764B or dx,dx jl/je 0x956 */
        goto done;                             /* @asm 0x07764D/077653 */

    do {                                       /* @asm 0x0776B4 loop (label 0x8e8) */
        uint32_t remaining = total - done;     /* @asm 0x077662 sub/sbb */
        if ((int32_t)remaining > 0xF000 || (uint32_t)remaining > 0xF000) /* @asm 0x07766E cmp 0xf000 */
            chunk = 0xF000;                    /* @asm 0x077673 clamp */
        else
            chunk = (uint16_t)remaining;       /* @asm 0x077676 */

        if (overlay_call_0D1D_0E9D() != 0)     /* @asm 0x077684 copy(chunk, fill=obj[7]) */
            goto done;                         /* @asm 0x07768E jne 0x956 */

        done += chunk;                         /* @asm 0x077695 add [bp-0xc:0xa] += moved */
        dst_bp_0A += chunk;                    /* @asm 0x07769F advance dest low */
        /* dst_bp_0C += (carry << 0xC) @asm 0x0776A4..0x0776A9 (paragraph fixup) */
        pos += chunk;                          /* @asm 0x0776B4 [bp-8:6] += si */
    } while (pos < total);                     /* @asm 0x0776BA cmp [bp-6],dx / [bp-8],ax */

done:                                          /* @asm 0x0776C6 (label 0x956) */
    if (done == len_dxax)                      /* @asm 0x0776CC cmp [bp-0xc:0xa]==[bp-0x14:0x12] */
        return 1;                              /* @asm 0x0776D6 return 1 */
    overlay_call_0D1D_0EC6();                  /* @asm 0x0776E8 seek(done, length) */
    return 0;                                  /* @asm 0x0776F0 retf 8 */
}

/* ============================================================================
 * func_0776F4 — stream_pump  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Pumps the stream until the 32-bit remaining-counter [0xA630:0xA632] reaches
 * 0, invoking the registered read callback [0xA644] and seek callback [0xA63A]
 * (the vtable set by func_0772FA).  Each pass: clamp the per-call size [0xA626]
 * to the remaining counter, call [0xA644] with (state, &size, [0xA622:0xA624]);
 * if it returned fewer than requested (di != size) -> error si=4 and stop; else
 * call the seek callback [0xA63A]; repeat while [0xA630:0xA632] != 0.  Returns
 * si (0 = success, 4 = short read).
 *
 * @asm 0x0776FC  cmp [0xA632],si(0) jl done ; @asm 0x077702 jg loop ; @asm 0x077704 cmp [0xA630],0 je done
 * @asm 0x07770E  ax=[0xA626] ; clamp vs [0xA630:0xA632]   (@asm 0x077713..0x077728)
 * @asm 0x07772B  push [0xA624]/[0xA622]; push &size; @asm 0x077738 lcall [0xA644]  (read cb)
 * @asm 0x07773E  cmp di,size ; @asm 0x077741 je ok ; @asm 0x077743 si=4 (short read)
 * @asm 0x07774A  push [0xA624]/[0xA622]; push &size; @asm 0x077757 lcall [0xA63A]  (seek cb)
 * @asm 0x07775B  cmp [0xA632],0 jg loop / @asm 0x077764 cmp [0xA630],0 jne loop
 * @asm 0x07776B  ax=si; retf
 * @status DONE
 */
int func_0776F4_stream_pump(void)
{
    int si = 0;                                /* @asm 0x0776FA sub si,si (success) */

    while (!((*((int16_t near *)0xA632) == 0) &&
             (*((uint16_t near *)0xA630) == 0))) { /* @asm 0x0776FC..0x077708 */
        uint16_t size;                          /* [bp-2] */
        uint16_t di;
        stream_io_cb_t read_cb;
        stream_io_cb_t seek_cb;

        /* clamp per-call size [0xA626] to remaining [0xA630:0xA632] */
        size = *((uint16_t near *)0xA626);      /* @asm 0x07770E */
        if ((*((int16_t near *)0xA632) < 0) ||
            (*((int16_t near *)0xA632) == 0 &&
             size > *((uint16_t near *)0xA630))) { /* @asm 0x077713..0x07771F */
            size = *((uint16_t near *)0xA630);  /* @asm 0x077725 (clamp) */
        }

        read_cb = *((stream_io_cb_t near *)0xA644); /* @asm 0x077738 lcall [0xA644] */
        di = read_cb(&size /*, [0xA622:0xA624] */); /* @asm 0x07773B (read callback) */
        if (di != size) {                       /* @asm 0x07773E cmp di,[bp-2] */
            si = 4;                             /* @asm 0x077743 short read */
            break;                              /* @asm 0x077746 jmp done */
        }
        seek_cb = *((stream_io_cb_t near *)0xA63A); /* @asm 0x077757 lcall [0xA63A] */
        seek_cb(&size /*, [0xA622:0xA624] */);  /* @asm 0x077757 (seek callback) */
    }
    return si;                                  /* @asm 0x07776B ax=si; retf */
}

/* ============================================================================
 * func_077772 — stream_op_dispatch  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Top-level stream-operation dispatcher (reseg 255; stale "32").  ENTER 2; op
 * code in ax (cx=ax), sub-op in dx.  Each path forwards the file-object
 * callback vtable (read cb [0xA644:0xA646], seek cb [0xA63A:0xA63C] or buffer
 * [0xA648:0xA64A]/[0xA63E:0xA640]) plus the bound buffer [0xA622:0xA624] and a
 * scratch dword [bp-2] (init 0x1000) + the request-descriptor @DS:0x26C6 to one
 * of the registered per-record stream handlers in the [0x26CA..0x26E0] vtable.
 * retf (each leaf path is its own RETF; the dispatcher has no shared tail).
 *
 * DISPATCH (byte-traced 0x077772..0x07786B):
 *   op==0 (label 0xa18): [bp-2]=0x1000 ; if [0x26CA]==1 -> lcall [0x26D4]
 *     (read-handler A) with (read-cb, seek-cb, buffer, @0x26C6, &scratch) ;
 *     else lcall [0x26CC] (read-handler B).
 *   op==1 (label 0xa74): if [0x26CA]==1 dispatch on sub-op dx:
 *       dx==1 -> lcall [0x26DC] (with buffer [0xA640:0xA63E]) ;
 *       dx==2 -> lcall [0x26E0] (with buffer [0xA64A:0xA648:0xA640:0xA63E]) ;
 *       else  -> lcall [0x26D8] ;
 *     else [0x26CA]!=1 -> lcall [0x26D0] (write-handler).
 *   default (op>=2): near call 0xafc (the default stream-op path, body in the
 *     page-0x1D image) then fall to its RETF.
 *
 * @asm 0x07777A  or ax,ax je 0xa18 (op0) ; @asm 0x07777E dec ax je 0xa74 (op1)
 * @asm 0x077782  push cs; call 0xafc (default) ; @asm 0x077785 jmp 0xafa
 * @asm 0x077788  op0: [bp-2]=0x1000 ; @asm 0x07778D cmp [0x26CA],1
 * @asm 0x0777B5  lcall [0x26D4] ; @asm 0x0777DD lcall [0x26CC]
 * @asm 0x07780B  lcall [0x26D8] ; @asm 0x07782A lcall [0x26DC] ; @asm 0x077848 lcall [0x26E0]
 * @asm 0x077866  lcall [0x26D0] ; @asm 0x07786B retf
 * @status DONE
 */
int func_077772_stream_op_dispatch(uint16_t op_ax, uint16_t subop_dx)
{
    uint16_t scratch;                          /* [bp-2] */
    stream_cb_t handler;                       /* the per-record handler from the [0x26xx] vtable */

    if (op_ax == 0) {                          /* @asm 0x07777A or ax,ax je 0xa18 */
        scratch = 0x1000;                      /* @asm 0x077788 [bp-2]=0x1000 */
        (void)scratch;
        handler = (*((uint16_t near *)0x26CA) == 1)        /* @asm 0x07778D */
                ? *((stream_cb_t near *)0x26D4)            /* @asm 0x0777B5 lcall [0x26D4] */
                : *((stream_cb_t near *)0x26CC);           /* @asm 0x0777DD lcall [0x26CC] */
        handler();
    } else if (op_ax == 1) {                   /* @asm 0x07777E dec ax je 0xa74 */
        if (*((uint16_t near *)0x26CA) == 1) { /* @asm 0x0777E4 */
            if (subop_dx == 1)                 /* @asm 0x0777ED dec; je 0xaa2 */
                handler = *((stream_cb_t near *)0x26DC);   /* @asm 0x07782A lcall [0x26DC] */
            else if (subop_dx == 2)            /* @asm 0x0777F0 dec; je 0xac0 */
                handler = *((stream_cb_t near *)0x26E0);   /* @asm 0x077848 lcall [0x26E0] */
            else                               /* @asm 0x0777F3 */
                handler = *((stream_cb_t near *)0x26D8);   /* @asm 0x07780B lcall [0x26D8] */
        } else {                               /* @asm 0x07784E */
            handler = *((stream_cb_t near *)0x26D0);       /* @asm 0x077866 lcall [0x26D0] */
        }
        handler();
    } else {                                   /* @asm 0x077781 default */
        page1C_stream_op_default();            /* @asm 0x077782 near 0xafc */
    }
    return 0;                                  /* @asm 0x07786B retf */
}

/* ============================================================================
 * func_077990 — scan_dir_first_name  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Directory scanner: findfirst on the pattern @DS:0x246A via 0x181F:0xE86,
 * then walks entries with 0x0D1D:0x9CA (findnext, 0x24-byte dirent), skipping
 * any whose +6 attribute byte has the subdir bit (0x10) set, copies the first
 * matching plain-file name into the caller's buffer ([bp-0x34]) after stripping
 * trailing control/space chars (< 0x20 -> NUL) up to strlen (0x0D1D:0x842), via
 * 0x0D1D:0x7E4 (strcpy).  Closes the find handle via 0x0D1D:0x3F4.  Returns
 * [bp-0x2a] (1 if no name found, 0 if a name was copied).  RET (near).
 *
 * @asm 0x07799F  lea bx,[0x246A]; @asm 0x0779A3 lcall 0x181F:0xE86 findfirst -> [bp-0x2e]
 * @asm 0x0779C4  test [bx+6],0x10 (subdir) -> @asm 0x0779C8 jne skip (return 1)
 * @asm 0x0779D1  lcall 0x0D1D:0x9CA findnext(dirent @bp-0x28, 0x24)
 * @asm 0x0779EB  strip ctrl chars (< 0x20 -> 0) up to strlen 0x0D1D:0x842
 * @asm 0x077A0D  lcall 0x0D1D:0x7E4 strcpy([bp-0x34], name); [bp-0x2a]=0
 * @asm 0x077A26  lcall 0x0D1D:0x3F4 close find ; @asm 0x077A2E ax=[bp-0x2a]; ret
 * @status DONE
 */
int func_077990_scan_dir_first_name(void)
{
    int found_none = 1;                        /* @asm 0x077998 [bp-0x2a]=1 */
    uint8_t far *find;                         /* [bp-0x2e] */
    int j;

    find = (uint8_t far *)0;                   /* findfirst result */
    if (overlay_call_181F_0E86() != 0) {       /* @asm 0x0779A3 findfirst @0x246A */
        /* loop: while not a subdir entry, read names via findnext */
        find = (uint8_t far *)1;               /* (handle nonzero) */
        if ((find[6] & 0x10) == 0) {           /* @asm 0x0779C4 test [bx+6],0x10 */
            if (overlay_call_0D1D_09CA() == 0) {     /* @asm 0x0779D1 findnext dirent */
                for (j = 0; j < overlay_call_0D1D_0842(); j++) { /* @asm 0x0779E8 strip to strlen */
                    /* if dirent name byte < 0x20 -> NUL (@asm 0x0779EB/0779F1) */
                }
                overlay_call_0D1D_07E4();      /* @asm 0x077A0D strcpy(out, name) */
                found_none = 0;                /* @asm 0x077A18 [bp-0x2a]=0 */
            }
        }
    }
    if (find != 0) {                           /* @asm 0x077A1D cmp [bp-0x2e],0 */
        overlay_call_0D1D_03F4();              /* @asm 0x077A26 close find handle */
    }
    return found_none;                         /* @asm 0x077A2E ax=[bp-0x2a]; ret */
}

/* ============================================================================
 * func_077A34 — scan_dir_collect_filtered  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Directory scanner + filtered collector (the save-file list builder).  Same
 * shape as func_077990 but loops over ALL entries: findfirst @DS:0x24C8 via
 * 0x181F:0xE86, then for each non-subdir entry read a 0x4F-byte dirent via
 * 0x0D1D:0x9CA, strip trailing ctrl chars, and if the first 3 chars match the
 * prefix @DS:0x24CB (0x0D1D:0x8BC strncmp) ADD the name to the list via
 * 0x1A1F:0xF26.  Continues while [bp-0x54] stays nonzero.  Closes via
 * 0x0D1D:0x3F4.  retf.
 *
 * @asm 0x077A41  lea bx,[0x24C8]; @asm 0x077A45 lcall 0x181F:0xE86 findfirst -> [bp-0x58]
 * @asm 0x077A59  test [bx+6],0x10 (subdir) -> @asm 0x077A5D jne done
 * @asm 0x077A66  lcall 0x0D1D:0x9CA findnext(@bp-0x50, 0x4F)
 * @asm 0x077A7D  strip ctrl chars up to strlen 0x0D1D:0x842
 * @asm 0x077AA4  lcall 0x0D1D:0x8BC strncmp(name, @DS:0x24CB, 3) ; @asm 0x077AAE jne -> add
 * @asm 0x077ABE  lcall 0x1A1F:0xF26 add name to list
 * @asm 0x077AC3  while [bp-0x54]!=0 loop ; @asm 0x077AD2 lcall 0x0D1D:0x3F4 close ; retf
 * @status DONE
 */
int func_077A34_scan_dir_collect_filtered(void)
{
    int keep_going = 1;                        /* @asm 0x077A3A [bp-0x52]=1 */
    uint8_t far *find;                         /* [bp-0x58] */
    int j;

    find = (uint8_t far *)0;
    if (overlay_call_181F_0E86() != 0) {       /* @asm 0x077A45 findfirst @0x24C8 */
        find = (uint8_t far *)1;
        do {
            if ((find[6] & 0x10) != 0)         /* @asm 0x077A59 subdir -> stop */
                break;                         /* @asm 0x077A5D jne done */
            if (overlay_call_0D1D_09CA() != 0) /* @asm 0x077A66 findnext (0x4F) */
                break;                         /* @asm 0x077A70 je done */
            for (j = 0; j < overlay_call_0D1D_0842(); j++) { /* @asm 0x077A8A strip to strlen */
                /* dirent name byte < 0x20 -> NUL (@asm 0x077A7D/077A83) */
            }
            if (overlay_call_0D1D_08BC() != 0) /* @asm 0x077AA4 strncmp(name,@0x24CB,3) */
                overlay_call_1A1F_0F26();      /* @asm 0x077ABE add to list */
            else
                keep_going = 0;                /* @asm 0x077AB0 [bp-0x54]=0 */
        } while (keep_going != 0);             /* @asm 0x077AC3 cmp [bp-0x54],0 jne loop */
    }
    if (find != 0) {                           /* @asm 0x077AC9 cmp [bp-0x58],0 */
        overlay_call_0D1D_03F4();              /* @asm 0x077AD2 close find handle */
    }
    return keep_going;                         /* @asm 0x077ADA retf */
}
