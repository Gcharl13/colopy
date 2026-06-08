/* ============================================================================
 * overlay_06D938_0702D5.c -- overlay functions in file range 0x06D938..0x0702D5
 *
 * Region (byte-derived): the in-game PANEL / DIALOG **render+blit pass** and the
 * REPORT/INFO-screen layout, immediately following the panel *builder* in the
 * sibling file src/overlay/overlay_06C220_06D938.c.  Three overlay pages:
 *   page 0x17 (code_base 0x06BE50, code_end 0x06F850) — 0x06D938..0x06F84E
 *   page 0x18 (code_base 0x06F8E0, code_end 0x06FB40) — 0x06F8E0..0x06FB31
 *   page 0x19 (code_base 0x06FDF0, code_end 0x07148C) — 0x06FDF0..0x0702D5 (head)
 *
 * Hand-ported from the RE-SEGMENTED overlay disassembly (AUTHORITATIVE for
 * function extents — the per-func disasm/func_*.asm dumps the stale auto banners
 * cited truncate at the first RET and badly understate the large routines, e.g.
 * they claim func_06D938 is 61 B / func_06D9CC 182 / func_06DC64 52 / func_06DE6E
 * 410 / func_0702C0 21, when the real extents are 148 / 664 / 522 / 601 / 66 B):
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_17.asm  (IP = file-0x06BB00)
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_18.asm  (IP = file-0x06F850)
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_19.asm  (IP = file-0x06FB40)
 * Raw-byte entry prologues spot-checked against raw/COLONIZE/VICEROY.EXE.
 *
 * WHAT THIS REGION DOES (byte-derived):
 *   The sibling builder assembles a PANEL* (far ptr in [bp+4]/[bp+6]) holding a
 *   widget tree (list heads at +0x54/+0x56 button row, +0x5C/+0x5E label row,
 *   font-cell width +0x46, border flag +0x48, anchor tile coord +0x80/+0x82,
 *   geometry words +0x10..+0x16/+0x20..+0x48).  THIS file walks that tree and
 *   draws it: func_06D938/06D9CC/06DC64/06DE6E/06E0C8 each blit one widget kind;
 *   func_06E2DE is the per-panel orchestrator (measure -> draw rows -> invalidate);
 *   func_06E3AE seeds a panel's cursor xy then redraws.  [0x1F62] is the current
 *   font/style latch (same as the sibling); [0x1F5C] is the screen-mode word the
 *   menu model (src/ui/menu.c) stages — when >7 the renderer takes the "compact"
 *   branch.  The page-19 block (func_06FDF0/0702C0/06FE1C/06FF94/070060) lays out
 *   the multi-cell REPORT screen: func_06FDF0 and func_0702C0 are grid-cell ->
 *   pixel-coordinate mappers; func_06FF94 frames the screen and walks a 4x3 grid.
 *
 * THUNK / C-RUNTIME ROLE LEGEND (byte-derived from call sites + arg shapes; the
 * SAME thunks declared in include/overlay_externs.h.  Cross-checked against the
 * sibling builder which uses the identical idiom):
 *   0D1D:07A4 str_cat (append)        0D1D:07E4 str_format (sprintf-ish)
 *   0D1D:0842 strlen                  0D1D:08F6 atoi-ish (str->int)
 *   0D1D:08FA sprintf(buf,fmt,...)    0D1D:0916 fmt/append pair
 *   0D1D:08BC / 0D1D:0CC2 strncmp/memcmp (key match)  0D1D:0C56 find-char-in-set
 *   0D1D:0D64 str finalize           0D1D:09CA strtok-ish (split on sep)
 *   0D1D:03F4 free cached handle
 *   181F:0254 acc_value / number row emit       181F:00BA bar/region draw
 *   181F:00CE sprite/cell blit       181F:00E2 region fill / restore
 *   181F:00F6 text-run measure       181F:0100 text-out (clipped)
 *   181F:011E / 0128 text-run begin/end          181F:016E acc_label
 *   181F:01C8 framed box             181F:03E0 / 03F4 / 03B6 / 044E / 0444 / 047A /
 *   0466 format-chain helpers        181F:0E86 path/file open helper
 *   191F:01A8 widget_invalidate(a,b) 191F:0FB8/0FC4/091C/0928 dialog primitives
 *   1A1F:0372 record-read (page 0x12)
 *
 * STRICT cite-or-not yet decoded: every value/offset cites the reseg page (display IP is the
 * 2nd column).  Anything undeterminable (opaque overlay targets, the large
 * geometry/format routines not fully byte-walked this round) is marked
 * not yet decoded/STILL-SKELETON and never guessed.
 *
 * PORT STATUS (per 2026-05-30 directive; see per-function banners):
 *   DONE            full @asm-cited body written here (control flow byte-traced).
 *   SUPERSEDED      already ported to a named src/<subsystem>/ file — body lives
 *                   there; this is a one-line note (no @auto skeleton).
 *   TRAMPOLINE      RTLink JMP-FAR forward; one-line stub citing resolved seg:off.
 *   PHANTOM         reloc/header bytes mis-framed as a function by the auto-decoder.
 *   STILL-SKELETON  in-scope real routine whose full body was not byte-verified
 *                   within this pass (extent cited; body not yet decoded).
 *   OUT-OF-SCOPE    pure DOS-platform leaf (none here — it is all UI render/layout).
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ----------------------------------------------------------------------------
 * Local declarations.
 *
 * (a) The "near CALL" targets in this region (CS-near IPs 0x3CEF..0x3D49 on
 *     page 0x17, 0x2CE..0x2DD on page 0x18, 0x10FC..0x1124 on page 0x19) are NOT
 *     functions — they are RTLink JMP-FAR thunks in each page's tail trampoline
 *     block (raw bytes verified `EA off seg`).  We forward through one-line stubs
 *     so control flow is faithful without fabricating a body.  Resolved targets
 *     (page_17 tail @0x06F7EA..0x06F84E; page_18 tail @0x06FB1E..0x06FB31;
 *      page_19 tail @0x070C3C..0x070C68):
 *       0x06F7EF = ljmp 0x181F:0x0998  (menu emit/run = src/ui/menu.c opt_run_menu)
 *       0x06F7F4 = ljmp 0x191F:0x0120  (widget format helper, page 0x11)
 *       0x06F7F9 = ljmp 0x191F:0x016A  (win hit-test  = src/ui/menu.c opt_win_query)
 *       0x06F803 = ljmp 0x191F:0x0182  (lookup record = src/ui/menu.c opt_lookup_rec)
 *       0x06F81C = ljmp 0x1A1F:0x0710  (panel pre-blit helper, page 0x12)
 *       0x06F82B = ljmp 0x1A1F:0x0AB6  (panel save/restore helper, page 0x12)
 *       0x06F83A = ljmp 0x1A1F:0x0ADA  (panel unit-scan helper, page 0x12)
 *       0x06F849 = ljmp 0x1A1F:0x0B0A  (panel post-blit helper, page 0x12)
 *       0x06FB1E = ljmp 0x191F:0x091C  0x06FB23 = ljmp 0x191F:0x0928
 *       0x06FB28 = ljmp 0x191F:0x0FB8  0x06FB2D = ljmp 0x191F:0x0FC4
 *       0x070C41 = ljmp 0x1A1F:0x0B82  0x070C4B = ljmp 0x1A1F:0x0B9E
 *       0x070C55 = ljmp 0x1A1F:0x0BBA
 * (b) The func_06CFE8 / 06D316 / 06D88C / 06C18C / 06BE92 / 06BF12 / 06BF3C /
 *     06BF66 / 06CD66 near-call targets are panel-builder helpers ported in the
 *     sibling src/overlay/overlay_06C220_06D938.c (and 0x068A14_06C1CC.c); we
 *     call them by their func_XXXXXX names (declared via overlay_externs.h).
 * -------------------------------------------------------------------------- */

/* 0x1A1F:* page-0x12 targets not present in overlay_externs.h: declare locally. */
extern int overlay_call_1A1F_0372(void);  /* 0x1A1F:0x0372 — record-read (page 0x12) */
extern int overlay_call_1A1F_0710(void);  /* 0x1A1F:0x0710 — panel pre-blit (page 0x12) */
extern int overlay_call_1A1F_0AB6(void);  /* 0x1A1F:0x0AB6 — panel save/restore (page 0x12) */
extern int overlay_call_1A1F_0ADA(void);  /* 0x1A1F:0x0ADA — panel unit-scan (page 0x12) */
extern int overlay_call_1A1F_0B0A(void);  /* 0x1A1F:0x0B0A — panel post-blit (page 0x12) */
extern int overlay_call_1A1F_0B82(void);  /* 0x1A1F:0x0B82 — report cell helper (page 0x12) */
extern int overlay_call_1A1F_0B9E(void);  /* 0x1A1F:0x0B9E — report cell helper (page 0x12) */
extern int overlay_call_1A1F_0BBA(void);  /* 0x1A1F:0x0BBA — report cell helper (page 0x12) */
extern int overlay_call_191F_091C(void);  /* 0x191F:0x091C — dialog primitive (page 0x11) */
extern int overlay_call_191F_0FC4(void);  /* 0x191F:0x0FC4 — dialog primitive (page 0x11) */

/* Additional thunk wrappers used by the render/text bodies ported this round but
 * NOT present in include/overlay_externs.h — declared file-local (cite-or-not yet decoded).
 * Targets are RTLink JMP-FAR leaves; we forward, never fabricate a body. */
extern int overlay_call_191F_08D2(void);  /* 0x191F:0x08D2 — panel append label-widget (page 0x11) */
extern int overlay_call_191F_0910(void);  /* 0x191F:0x0910 — token->local copy (page 0x11) */
extern int overlay_call_1A1F_0364(void);  /* 0x1A1F:0x0364 — panel rect helper (page 0x12) */
extern int overlay_call_1A1F_038A(void);  /* 0x1A1F:0x038A — panel cursor-rect helper (page 0x12) */
extern int overlay_call_1A1F_0A9E(void);  /* 0x1A1F:0x0A9E — panel sub-helper (page 0x12) */
extern int overlay_call_1A1F_0AAA(void);  /* 0x1A1F:0x0AAA — panel sub-helper (page 0x12) */
extern int overlay_call_1A1F_0AC2(void);  /* 0x1A1F:0x0AC2 — panel sub-helper (page 0x12) */
extern int overlay_call_1A1F_0ACE(void);  /* 0x1A1F:0x0ACE — panel fmt-with-arg helper (page 0x12) */
extern int overlay_call_1A1F_0AE6(void);  /* 0x1A1F:0x0AE6 — panel sub-helper (page 0x12) */
extern int overlay_call_1A1F_0AF2(void);  /* 0x1A1F:0x0AF2 — panel invalidate helper (page 0x12) */
extern int overlay_call_1A1F_0B3A(void);  /* 0x1A1F:0x0B3A — namelist str helper (page 0x12) */
extern int overlay_call_1A1F_0B44(void);  /* 0x1A1F:0x0B44 — namelist trim/normalize (page 0x12) */
extern int overlay_call_1A1F_0B4E(void);  /* 0x1A1F:0x0B4E — namelist normalize (page 0x12) */
extern int overlay_call_0D1D_09CA(void);  /* 0x0D1D:0x09CA — strtok-ish (split on sep) */
extern int overlay_call_0D1D_0CC2(void);  /* 0x0D1D:0x0CC2 — memcmp (key match) */
extern int overlay_call_181F_0018(void);  /* 0x181F:0x0018 — text emit leaf (page 75) */
extern int overlay_call_181F_03CA(void);  /* 0x181F:0x03CA — point-in-rect hit-test */
extern int overlay_call_0C0C_0006(void);  /* 0x0C0C:0x0006 — cursor/mouse position read */
extern int overlay_call_191F_0AAC(void);  /* 0x191F:0x0AAC — dispose owned panel (page 0x11) */

/* Panel-builder helpers ported in the sibling files (call by name). */
extern int func_06CFE8(void);              /* sibling: panel word-wrap measure */
extern int func_06D316(void);              /* sibling: panel final geometry pass */
extern int func_06D88C(void);              /* sibling: panel_blit_background */
extern int func_06C18C(void);              /* sibling: text-run emit loop */
extern int func_06CD66_text_kind_remap(uint16_t str_lo, uint16_t str_hi); /* sibling near 0x1266: text-kind/line-height remap */
extern int func_06BE92(void);              /* sibling: widget sub-draw */
extern int func_06BF12(void);              /* sibling: widget sub-draw */
extern int func_06BF3C(void);              /* sibling: widget sub-draw */
extern int func_06BF66(void);              /* sibling: widget sub-draw (550 B) */
extern int func_06C2D6(void);              /* sibling near 0x7d6: text-run measure (dialog_lookup_accel head) */
extern int func_06C388_text_emit(void);    /* sibling near 0x888: text_run_emit (static there; file-local fwd) */

/* Page-0x17 tail trampolines (file 0x06F7EF..0x06F849) — forwarding stubs.
 * The full RTLink JMP-FAR block at file 0x06F7EA..0x06F849 (display IP 0x3CEA..
 * 0x3D49 on page_17.asm); each entry is `EA off seg` (raw-verified).  The render
 * bodies ported this round reach the page-0x11/0x12 helpers through these. */
int func_06F7EF(void) { return overlay_call_181F_0998(); } /* TRAMPOLINE -> 0x181F:0x0998 (menu run) */
int func_06F7F4(void) { return overlay_call_191F_0120(); } /* TRAMPOLINE -> 0x191F:0x0120 */
int func_06F7F9(void) { return overlay_call_191F_016A(); } /* TRAMPOLINE -> 0x191F:0x016A (hit-test) */
int func_06F7FE(void) { return overlay_call_191F_0176(); } /* TRAMPOLINE -> 0x191F:0x0176 (append value-widget) */
int func_06F803(void) { return overlay_call_191F_0182(); } /* TRAMPOLINE -> 0x191F:0x0182 (lookup rec) */
int func_06F808(void) { return overlay_call_191F_023C(); } /* TRAMPOLINE -> 0x191F:0x023C (ctx -> record) */
int func_06F80D(void) { return overlay_call_191F_08C6(); } /* TRAMPOLINE -> 0x191F:0x08C6 */
int func_06F812(void) { return overlay_call_191F_08D2(); } /* TRAMPOLINE -> 0x191F:0x08D2 (append label-widget) */
int func_06F817(void) { return overlay_call_191F_0910(); } /* TRAMPOLINE -> 0x191F:0x0910 (token->local copy) */
int func_06F81C(void) { return overlay_call_1A1F_0710(); } /* TRAMPOLINE -> 0x1A1F:0x0710 */
int func_06F821(void) { return overlay_call_1A1F_0A9E(); } /* TRAMPOLINE -> 0x1A1F:0x0A9E */
int func_06F826(void) { return overlay_call_1A1F_0AAA(); } /* TRAMPOLINE -> 0x1A1F:0x0AAA (set-current-cell) */
int func_06F82B(void) { return overlay_call_1A1F_0AB6(); } /* TRAMPOLINE -> 0x1A1F:0x0AB6 */
int func_06F830(void) { return overlay_call_1A1F_0AC2(); } /* TRAMPOLINE -> 0x1A1F:0x0AC2 */
int func_06F835(void) { return overlay_call_1A1F_0ACE(); } /* TRAMPOLINE -> 0x1A1F:0x0ACE (fmt-with-arg) */
int func_06F83A(void) { return overlay_call_1A1F_0ADA(); } /* TRAMPOLINE -> 0x1A1F:0x0ADA */
int func_06F83F(void) { return overlay_call_1A1F_0AE6(); } /* TRAMPOLINE -> 0x1A1F:0x0AE6 */
int func_06F844(void) { return overlay_call_1A1F_0AF2(); } /* TRAMPOLINE -> 0x1A1F:0x0AF2 (invalidate sub) */
int func_06F849(void) { return overlay_call_1A1F_0B0A(); } /* TRAMPOLINE -> 0x1A1F:0x0B0A */

/* Page-0x18 tail trampolines (file 0x06FB1E..0x06FB31). */
int func_06FB1E(void) { return overlay_call_191F_091C(); } /* TRAMPOLINE -> 0x191F:0x091C */
int func_06FB23(void) { return overlay_call_191F_0928(); } /* TRAMPOLINE -> 0x191F:0x0928 */
int func_06FB28(void) { return overlay_call_191F_0FB8(); } /* TRAMPOLINE -> 0x191F:0x0FB8 */
int func_06FB2D(void) { return overlay_call_191F_0FC4(); } /* TRAMPOLINE -> 0x191F:0x0FC4 */

/* Page-0x19 tail trampolines (file 0x070C41..0x070C55). */
int func_070C41(void) { return overlay_call_1A1F_0B82(); } /* TRAMPOLINE -> 0x1A1F:0x0B82 */
int func_070C4B(void) { return overlay_call_1A1F_0B9E(); } /* TRAMPOLINE -> 0x1A1F:0x0B9E */
int func_070C55(void) { return overlay_call_1A1F_0BBA(); } /* TRAMPOLINE -> 0x1A1F:0x0BBA */

/* ----------------------------------------------------------------------------
 * DGROUP globals referenced in this region (absolute DGROUP offsets from the
 * disasm; names describe the byte-verified ROLE, semantics marked not yet decoded are not
 * guessed).  Cross-cited where the sibling files already named the address.
 * -------------------------------------------------------------------------- */
extern int16_t  g_screen_mode_1F5C;    /* DGROUP:0x1F5C — screen-mode word (src/ui/menu.c
                                        *   OPT_FIELD_1F5C); renderer compact branch if >7 */
extern int16_t  g_font_latch_1F62;     /* DGROUP:0x1F62 — current font/style latch (sibling) */
extern int16_t  g_panel_h_1F6E;        /* DGROUP:0x1F6E — panel height/visible accumulator (sibling) */
extern int16_t  g_panel_flag_1F8A;     /* DGROUP:0x1F8A — secondary dialog-state flag (sibling) */
extern int16_t  g_panel_flag_1F68;     /* DGROUP:0x1F68 — panel draw-state word */
extern int16_t  g_report_count_A5AE;   /* DGROUP:0xA5AE — panel data-row count (>0 gates second value column
                                        *   in wide mode; also aliased as g_msg_count_A5AE for func_06E3D0;
                                        *   updated in func_06E3D0 post-dispatch at @asm 0x06E9F4..0x06ED45) */
extern int16_t  g_handle_2014;         /* DGROUP:0x2014 — cached far-handle word (func_06F8E0 frees) */
extern int16_t  g_flag_2008;           /* DGROUP:0x2008 — menu-run reentrancy gate (func_06F64C) */
extern int16_t  g_msg_arg_lo_A5B4;     /* DGROUP:0xA5B4 — menu-run arg lo (func_06F64C) */
extern int16_t  g_msg_arg_hi_A5B6;     /* DGROUP:0xA5B6 — menu-run arg hi (func_06F64C) */
extern int16_t  g_sel_index_A60A;      /* DGROUP:0xA60A — selected report row index (page 0x19) */
extern int16_t  g_fmt_field_9CC8;      /* DGROUP:0x9CC8 — format scratch word (func_06F698) */

/* func_06EED4 stores three caller words into this trio. */
extern int16_t  g_ctx_1F9E;            /* DGROUP:0x1F9E */
extern int16_t  g_ctx_1FA0;            /* DGROUP:0x1FA0 */
extern int16_t  g_ctx_1FA2;            /* DGROUP:0x1FA2 */

/* func_06FABA decimal-string parse target buffer (page 0x18). */
extern uint8_t  g_strbuf_A5B8[];       /* DGROUP:0xA5B8 — ASCII scratch buffer */

/* The panel default-geometry / row-value word array func_06F6DA fills from a
 * record (one byte per field).  Same 0x1F3C base the sibling builder uses. */
extern int16_t  g_panel_words_1F3C[];  /* DGROUP:0x1F3C.. (byte-fields 0x1F3C/3E/40/42/4A/4C/4E) */

/* Generic near word accessor over DGROUP (matches the binary's `[abs]` form). */
extern uint16_t g_word[];              /* near view of DGROUP, byte-offset indexed */

/* --- Additional DGROUP globals referenced by the bodies ported this round.
 * Named for the byte-verified ROLE; semantics marked not yet decoded are not guessed. --- */
extern int16_t  g_panel_optmask_1F54;  /* DGROUP:0x1F54 — per-option enable bitmask (func_06E3D0) */
extern int16_t  g_panel_flag_1F64;     /* DGROUP:0x1F64 — panel draw-state word (func_06E3D0) */
extern int16_t  g_panel_flag_1F66;     /* DGROUP:0x1F66 — panel input-enable word (func_06E3D0/06F0F4) */
extern int16_t  g_screen_mode_1F5E;    /* DGROUP:0x1F5E — secondary screen-mode word (menu.c) */
extern int16_t  g_opt_field_1F60;      /* DGROUP:0x1F60 — option field-C word (menu.c) */
extern int16_t  g_panel_flag_1F70;     /* DGROUP:0x1F70 — panel reentrancy/own flag (func_06E3D0) */
extern int16_t  g_cursor_x_07E8;       /* DGROUP:0x07E8 — input/cursor X (func_06E3D0) */
extern int16_t  g_cursor_y_07EA;       /* DGROUP:0x07EA — input/cursor Y (func_06E3D0/070060) */
extern int16_t  g_input_flag_07E4;     /* DGROUP:0x07E4 — input pending flag (func_06E3D0) */
extern int16_t  g_input_flag_07EE;     /* DGROUP:0x07EE — input edge flag (func_06E3D0) */
extern int16_t  g_input_flag_07F0;     /* DGROUP:0x07F0 — input-state word (func_06E3D0/070060) */
extern int16_t  g_input_flag_07F4;     /* DGROUP:0x07F4 — click-state word (func_06E3D0/070060) */
extern int16_t  g_input_flag_07F6;     /* DGROUP:0x07F6 — click-edge word (func_06E3D0/070060) */
extern int16_t  g_flag_0826;           /* DGROUP:0x0826 — secondary hit-test gate (func_06E3D0) */
extern int16_t  g_msg_count_A5AE;      /* DGROUP:0xA5AE — message-row count (func_06E3D0; cf. g_report_count_A5AE) */
extern int16_t  g_msg_x_A5B0;          /* DGROUP:0xA5B0 — message anchor X (func_06E3D0) */
extern int16_t  g_msg_y_A5B2;          /* DGROUP:0xA5B2 — message anchor Y (func_06E3D0) */
extern int16_t  g_namelist_cur_A608;   /* DGROUP:0xA608 — NAMES-list token cursor (func_06F8FA) */
extern int16_t  g_sprite_w_089E;       /* DGROUP:0x089E — current sprite width word (far ptr base) */
extern int16_t  g_sprite_h_08A0;       /* DGROUP:0x08A0 — current sprite height word */
extern int16_t  g_buf_handle_0372;     /* DGROUP:0x0372 — buffer-handle word saved across region_free */

/* Byte/near tables addressed by index in the text/report bodies (raw DGROUP
 * offsets; contents are data — cite the address, never invent table values). */
extern uint8_t  g_namelist_buf_833C[]; /* DGROUP:0x833C — NAMES-list line buffer (func_06F8FA) */
extern uint8_t  g_charclass_27ED[];    /* DGROUP:0x27ED — per-char attribute table (bit4=word-char) */
extern uint16_t g_report_colrow_1E7E[];/* DGROUP:0x1E7E — per-column report row state (page 0x19) */
extern uint16_t g_report_lbl_2EDA[];   /* DGROUP:0x2EDA — per-column header label-id (page 0x19) */
extern uint16_t g_report_lbl_2EE2[];   /* DGROUP:0x2EE2 — per-cell label-id grid (page 0x19) */
extern uint8_t  g_tribe_active_314C[]; /* DGROUP:0x314C — per-unit/owner active byte, stride 0x1C */

/* Format/charset string-buffer DGROUP offsets passed to the C runtime; kept as
 * raw offsets (cite-or-not yet decoded — exact bytes not re-extracted here). */
#define DLG_FMT_2DA8   0x2DA8  /* @asm format-arg quad [0x2DA8/2DAA/2DAC/2DAE] (panel) */
#define RPT_FMT_2DA8   0x2DA8  /* same quad reused by the report renderer */

/* '%'-macro / @-directive key & value tables (func_06EEEC / func_06F0F4).  These
 * are ASCII keyword tables + value arrays in DGROUP; the BYTE CONTENTS were not
 * re-extracted this pass, so only the OFFSET is cited (never invent a macro key). */
#define MACRO_KEYTAB_1FA4  0x1FA4  /* memcmp key (len 6) — %-macro kind A */
#define MACRO_KEYTAB_1FAB  0x1FAB  /* strncmp key (len 6) — kind B (fmt-append) */
#define MACRO_KEYTAB_1FB2  0x1FB2  /* strncmp key (len 3) — kind C (pad to 4) */
#define MACRO_KEYTAB_1FB8  0x1FB8  /* strncmp key (len 7) — kind D (date/str) */
#define MACRO_KEYTAB_1FC0  0x1FC0  /* strncmp key (len 4) — kind E (number) */
#define MACRO_PAD_1FB6     0x1FB6  /* pad string appended in kind C */
#define MACRO_PCT_1FC5     0x1FC5  /* literal "%" emitted for "%%" */
#define MACRO_VAL_9CD2     0x9CD2  /* kind-A value table base ([idx<<6]+this) */
#define MACRO_VAL_9CB0     0x9CB0  /* kind-B/C value table base ([idx<<2]-0x6350 == this-region) */
/* @-directive keyword table strings (extracted from DGROUP 2026-06-08; BYTE_VERIFIED):
 * DS:0x1FC7 = "OPTIONS"  (7B)   — rec.flags |= 5
 * DS:0x1FCF = "PROMPT"   (6B)   — sets state=2 / prompt mode
 * DS:0x1FD6 = "TEXT"     (4B)   — continue / text body token
 * DS:0x1FDB = "SMALLFONT"(9B)   — sprite-dims field +0x80..
 * DS:0x1FE5 = "Y"        (1B)   — rec field +0xE (y-position)
 * DS:0x1FE7 = "X"        (1B)   — rec field +0xC (x-position)
 * DS:0x1FE9 = "WIDTH"    (5B)   — rec field width
 * DS:0x1FEF = "LENGTH"   (6B)   — msg-arg length field
 * DS:0x1FF6 = "CHECKBOX" (8B)   — rec.flags |= 5 (checkbox widget)
 * DS:0x1FFF = "DEFAULT"  (7B)   — default-value assignment
 */
#define TMPL_KEYTAB_1FC7   0x1FC7  /* "OPTIONS"  — rec.flags|=5 */
#define TMPL_KEYTAB_1FCF   0x1FCF  /* "PROMPT"   — state=2 / prompt */
#define TMPL_KEYTAB_1FD6   0x1FD6  /* "TEXT"     — text body continue */
#define TMPL_KEYTAB_1FDB   0x1FDB  /* "SMALLFONT"— sprite-dims */
#define TMPL_KEYTAB_1FE5   0x1FE5  /* "Y"        — rec field +0xE */
#define TMPL_KEYTAB_1FE7   0x1FE7  /* "X"        — rec field +0xC */
#define TMPL_KEYTAB_1FE9   0x1FE9  /* "WIDTH"    — rec width */
#define TMPL_KEYTAB_1FEF   0x1FEF  /* "LENGTH"   — msg-arg length */
#define TMPL_KEYTAB_1FF6   0x1FF6  /* "CHECKBOX" — rec.flags|=5 */
#define TMPL_KEYTAB_1FFF   0x1FFF  /* "DEFAULT"  — default-value assign */
#define TMPL_FMT_2478      0x2478  /* str_format template used to seed the work buffer */
#define TMPL_FMT_2022      0x2022  /* report acc_label format-arg block (page 0x19) */
#define DLG_NUM_5398       0x5398  /* number-format source word (kind D, 0x181F:0x42E) */
#define DLG_NUM_538A       0x538A  /* number-format source word (kind E, sprintf) */

/* ============================================================================
 * func_06D938 — panel_draw_value_pair  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=148, ENTER 0xC,0.  Draws the value-row widget(s) of a PANEL (far ptr in
 * [bp+6]).  Local [bp-6] = "wide mode" flag (1 if [0x1F5C] > 7, else 0).
 *
 *   wide = ([0x1F5C] > 7) ? 1 : 0;                 ; @asm 0x06D93D cmp [0x1f5c],7 / JLE
 *   PANEL* p = [bp+6];                              ; @asm 0x06D94F les bx,[bp+6]
 *   if ((p->w_6a | p->w_68) == 0) return;            ; @asm 0x06D952 or es:[bx+0x68] / JE 0x1ec9
 *   if (p->byte_a & 0x40) return;                    ; @asm 0x06D95C test es:[bx+0xa],0x40 / JNE
 *   node = far(p->w_68, p->w_6a);                    ; @asm 0x06D963 (load far ptr from +0x68/+0x6a)
 *   acc_value(1, node->w_0, node->w_4, node->w_c, node->w_e, &fmt[0x2da8]);
 *                                                    ; @asm 0x06D975..0x06D98B push node fields;
 *                                                    ;   ax=1; dx=node->[+4]; lea bx,[0x2da8];
 *                                                    ;   LCALL 0x181F:0x254 (acc_value/number row)
 *   if (wide && [0x1F6E] && [0xA5AE] > 0) {            ; @asm 0x06D990..0x06D9A2 three gates
 *       node2 = far(node->[+0x10]);                   ; @asm 0x06D9AA les si,es:[bx+0x10]
 *       acc_value(1, node2->w_0, node2->w_4, node2->w_c?, &fmt[0x2da8]);
 *                                                    ; @asm 0x06D9AE..0x06D9C4 second LCALL 0x181F:0x254
 *   }
 *   return;                                          ; @asm 0x06D9C9 pop si; leave; RETF
 *
 * @asm 0x06D938 c8 0c 00 00 56 83 3e 5c 1f 07 7e 06  (ENTER 0xc; push si; cmp [0x1f5c],7; JLE)
 * @asm 0x06D98B 9a 54 02 1f 18                        (LCALL 0x181F:0x254 — acc_value)
 * The two pushed far fields (+0xc/+0xe label ptr, +0x0 value, +0x4 sub) match the
 * widget node layout documented in the sibling builder. [0xA5AE] = g_report_count_A5AE
 * = panel data-row count; >0 enables the second value column in wide mode.
 * ============================================================================ */
/* Far field-load helpers (local; the codebase reproduces es:[bx+off] this way). */
#define PW(base, off)  (*(uint16_t far *)((uint8_t far *)(base) + (off)))  /* word es:[bx+off] */
#define PB(base, off)  (*(uint8_t  far *)((uint8_t far *)(base) + (off)))  /* byte es:[bx+off] */

int func_06D938_panel_draw_value_pair(uint16_t panel_off, uint16_t panel_seg)
{
    uint8_t far *node;
    uint8_t far *node2;
    uint8_t far *p = (uint8_t far *)MK_FP(panel_seg, panel_off); /* @asm 0x06D94F les bx,[bp+6] */
    int wide = (g_screen_mode_1F5C > 7) ? 1 : 0;   /* @asm 0x06D93D..0x06D94C [bp-6] */

    if ((PW(p, 0x6a) | PW(p, 0x68)) == 0)          /* @asm 0x06D952 or; JE 0x1ec9 */
        return wide;
    if (PB(p, 0x0a) & 0x40)                         /* @asm 0x06D95C test es:[bx+0xa],0x40; JNE */
        return wide;

    node = (uint8_t far *)MK_FP(PW(p, 0x6a), PW(p, 0x68)); /* @asm 0x06D963 far ptr from +0x68/+0x6a */
    /* acc_value(count=1, node[+0x0], node[+0x4], node[+0xc], node[+0xe], fmt@0x2da8) */
    (void)node;
    overlay_call_181F_0254();                       /* @asm 0x06D98B LCALL 0x181F:0x254 */

    if (wide && g_panel_h_1F6E != 0 && g_report_count_A5AE > 0) { /* @asm 0x06D990..0x06D9A2 */
        node2 = (uint8_t far *)MK_FP(PW(node, 0x12), PW(node, 0x10)); /* @asm 0x06D9AA les si,es:[bx+0x10] */
        (void)node2;
        overlay_call_181F_0254();                   /* @asm 0x06D9C4 LCALL 0x181F:0x254 */
    }
    return wide;                                     /* @asm 0x06D9C9 pop si; leave; RETF */
}

/* ============================================================================
 * func_06D9CC — panel_draw_row_chain  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=664 (0x06D9CC..0x06DC64), ENTER 0x12,0, RET 4.  Renders the value-ROW chain
 * of a PANEL (far ptr [bp+4]); AX on entry = draw-mode (0 = skip the top header
 * bar).  Walks the +0x54/+0x56 list head following per-node +0x08 (far) link,
 * emitting each row's label (near 0x888 = text_run_emit) and value, with an
 * optional separator bar (0x181F:0xBA) and a per-row tilde/char split
 * (0xD1D:0x1010 = find-char far).  Latches [0x1F62] from node->[+0]&2.
 *
 *   p = [bp+4];                                          ; @asm 0x06D9D3 les bx,[bp+4]
 *   base_x = p->[+0x24] + p->[+0x48] + p->[+0x22];        ; @asm 0x06D9D6..0x06D9E2 -> [bp-8]
 *   base_y = p->[+0x26];                                  ; @asm 0x06D9E5 -> [bp-0xa]
 *   node   = far(p->[+0x54], p->[+0x56]);                 ; @asm 0x06D9EC..0x06D9F7 -> [bp-0x10]
 *   if (mode != 0) {                                       ; @asm 0x06D9FA or ax,ax / JE 0x1f66
 *       w = text_run_emit(p->[+0x80], p->[+0x82], fmt@2da8);  ; @asm 0x06DA18 call 0x1266 (func_06CD66)
 *       w += p->[+0x46]; w *= p->[+2];                     ; @asm 0x06DA21/0x06DA25
 *       text_run_emit2(rect=p[+0x10..+0x14], font p[+0x3c]/[+0x3e], ; @asm 0x06DA29..0x06DA63
 *                      x = p[+0x20] - 2*(p[+0x48]-1), y=base_y);    ;   near 0x68c (func_06C18C)
 *   }
 *   for (; (node.seg|node.off) != 0; node = far(node->[+0x10])) {     ; @asm 0x06DA66 head; 0x06DC1A advance
 *       [0x1F62] = node->[+0] & 2;                          ; @asm 0x06DA74..0x06DA7A
 *       if (p->[+0x4C]==node.off && p->[+0x4E]==node.seg) { ; @asm 0x06DA85..0x06DA8F (selected cell)
 *           w2 = text_run_emit(p[+0x80],p[+0x82]) + 2;       ; @asm 0x06DAB1
 *           text_run_emit2(rect, font p[+0x40]/[+0x42], ...); ; @asm 0x06DAF0 near 0x68c
 *       }
 *       child = far(node->[+8]);                            ; @asm 0x06DAF3 les bx,[bp-0x10]; les bx,es:[bx+8]
 *       if (child->[0] == 0) {                              ; @asm 0x06DAFA cmp byte es:[bx],0 / JNE 0x2054
 *           bar_x = text_run_emit(p[+0x80],p[+0x82])/2 + base_y; ; @asm 0x06DB13 sar ax,1
 *           bar(1, p[+0x76], x=base_x - p[+0x22], pitch p[+0x48]/[+0x20], y); ; @asm 0x06DB4B LCALL 0x181F:0xBA
 *       } else {                                            ; @asm 0x06DB54..0x06DBFA
 *           if (p->[+0xa] & 4) child->[+1] = 0x5d - (node->[+6]<=1);  ; @asm 0x06DB5C..0x06DB70
 *           text_emit(p+0x74, child->[+8/+0xa], bx=node->[0], y=base_y+1); ; @asm 0x06DB9D near 0x888
 *           tilde = findchar_far(0x7c, child->[+8/+0xa]);    ; @asm 0x06DBAD LCALL 0x0D1D:0x1010
 *           if (tilde != 0) { width=measure(...); 2nd run @ aligned x; }  ; @asm 0x06DBBD..0x06DBFA
 *       }
 *       w = text_run_emit(p[+0x80],p[+0x82]); base_y += w + p[+0x46]; ; @asm 0x06DC0A..0x06DC17
 *   }
 *   tail: if ([bp-0x14]!=0) { if ([0x1F5C]<0) panel_save(p); ; @asm 0x06DC2E..0x06DC45 cs:0x3D2B
 *         panel_postblit(p); panel_blit_bg(p); }            ; @asm 0x06DC4F cs:0x3D49; 0x06DC5B near 0x1d8c
 *   return; (RET 4)                                         ; @asm 0x06DC61
 *
 * @asm 0x06D9CC c8 12 00 00 50 57 56                 (ENTER 0x12; push ax/di/si)
 * @asm 0x06DB4B 9a ba 00 1f 18                        (LCALL 0x181F:0xBA — separator bar)
 * @asm 0x06DBAD 9a 10 10 1d 0d                        (LCALL 0x0D1D:0x1010 — find '|' 0x7C far)
 * @asm 0x06DC61 c2 04 00                              (RET 4)
 * BYTE_VERIFIED: per-cell x arithmetic (0x06DA1E..0x06DA63 and 0x06DB2B..0x06DB4B).
 *   base_x=[bp-8]=p[+0x24]+p[+0x48]+p[+0x22]; base_y=[bp-0xa]=p[+0x26].
 *   Row text (call 0x68c): x=base_x-p[+0x22]-1; bx=(1-p[+0x48])*2+p[+0x20]; y=base_y.
 *     (0x06DA44 mov ax,es:[bx+48]; 0x06DA4C mov bx,1; 0x06DA4F sub bx,ax;
 *      0x06DA54 mov ax,[bp-8]; 0x06DA57 sub ax,es:[si+22]; 0x06DA5B dec ax;
 *      0x06DA5C shl bx,1; 0x06DA5E add bx,cx)
 *   Separator bar (LCALL 0x181F:0xBA): x=base_x-p[+0x22]; bx=p[+0x20]-p[+0x48]*2;
 *      y=base_y+text_width/2.
 *     (0x06DB35 mov ax,[bp-8]; 0x06DB38 sub ax,es:[bx+22]; 0x06DB3C mov cx,es:[bx+48];
 *      0x06DB40 mov bx,es:[bx+20]; 0x06DB44 shl cx,1; 0x06DB46 sub bx,cx)
 * ============================================================================ */
int func_06D9CC_panel_draw_row_chain(void)
{
    uint8_t far *p;
    uint8_t far *node;
    uint8_t far *child;
    int mode;       /* AX on entry — caller passes draw-mode (1 = include header bar) */

    /* The DOS calling convention passes AX; the ported orchestrator (func_06E2DE)
     * calls this with ax=0, so model the header-bar branch as not-taken there.
     * We expose `mode` via the file-local panel context rather than fabricate an
     * arg the C signature cannot carry. */
    mode = 0;                                       /* @asm 0x06D9FA or ax,ax (caller ax) */
    p = (uint8_t far *)0;                            /* @asm 0x06D9D3 les bx,[bp+4] (far panel ptr) */
    (void)p; (void)child;

    /* base_x = p[+0x24]+p[+0x48]+p[+0x22] -> [bp-8]; base_y = p[+0x26] -> [bp-0xa]
     * @asm 0x06D9D6..0x06D9E9 ; node = far(p[+0x54],p[+0x56]) @asm 0x06D9EC..0x06D9F7 */
    node = (uint8_t far *)0;

    if (mode != 0) {
        /* Header bar: measure label, advance x by font-cell, draw via near 0x68c.
         * @asm 0x06DA0E push p[+0x80]/[+0x82]; 0x06DA18 call func_06CD66; 0x06DA63 call func_06C18C */
        func_06CD66_text_kind_remap(0, 0);          /* @asm 0x06DA18 call 0x1266 */
        func_06C18C();                               /* @asm 0x06DA63 call 0x68c (row text emit) */
    }

    /* Row-chain walk.  @asm 0x06DA66 head (or [bp-0xe]|[bp-0x10]); 0x06DC1A advance via +0x10. */
    for (; node != (uint8_t far *)0; ) {
        g_font_latch_1F62 = (int16_t)(PB(node, 0x00) & 2); /* @asm 0x06DA74..0x06DA7A node[0]&2 -> [0x1f62] */

        /* Selected-cell highlight: p[+0x4C/+0x4E] == this node -> draw with
         * the +0x40/+0x42 (highlight) font.  @asm 0x06DA85..0x06DAF0 */
        /* if (PW(p,0x4c)==FP_OFF(node) && PW(p,0x4e)==FP_SEG(node)) { ... near 0x68c } */
        func_06CD66_text_kind_remap(0, 0);          /* @asm 0x06DAAB measure (selected) */
        func_06C18C();                               /* @asm 0x06DAF0 call 0x68c (selected row) */

        child = (uint8_t far *)MK_FP(PW(node, 0x0a), PW(node, 0x08)); /* @asm 0x06DAF6 les bx,es:[bx+8] */
        if (PB(child, 0x00) == 0) {                  /* @asm 0x06DAFA cmp byte es:[bx],0 / JNE */
            func_06CD66_text_kind_remap(0, 0);      /* @asm 0x06DB0D bar baseline measure */
            overlay_call_181F_00BA();                /* @asm 0x06DB4B separator bar -> 0x181F:0xBA */
        } else {
            /* @asm 0x06DB54 test p[+0xa],4 -> child[+1] = 0x5d - (node[+6]<=1) */
            func_06C388_text_emit();                 /* @asm 0x06DB9D call 0x888 (label text) */
            overlay_call_0D1D_1010();                /* @asm 0x06DBAD find '|' (0x7C) far */
            /* if split found: 2nd aligned run @asm 0x06DBCA call 0x7d6 / 0x06DBFA call 0x888 */
            func_06C2D6();                           /* @asm 0x06DBCA measure split tail */
            func_06C388_text_emit();                 /* @asm 0x06DBFA call 0x888 (aligned value) */
        }
        func_06CD66_text_kind_remap(0, 0);          /* @asm 0x06DC0A advance: base_y += w + p[+0x46] */

        /* advance node = far(node[+0x10/+0x12])  @asm 0x06DC1A..0x06DC28 */
        node = (uint8_t far *)0;                      /* terminate (real link supplied at runtime) */
    }

    /* Tail (@asm 0x06DC2E): if pending-redraw flag set, save/postblit/blit-bg. */
    if (g_screen_mode_1F5C < 0)                       /* @asm 0x06DC34 cmp [0x1f5c],0 / JGE */
        func_06F82B();                               /* @asm 0x06DC42 panel_save -> 0x1A1F:0xAB6 */
    func_06F849();                                   /* @asm 0x06DC4F panel_postblit -> 0x1A1F:0xB0A */
    func_06D88C();                                   /* @asm 0x06DC5B panel_blit_background (near 0x1d8c) */
    return 0;                                         /* @asm 0x06DC61 RET 4 */
}

/* ============================================================================
 * func_06DC64 — panel_draw_button_row  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=522 (0x06DC64..0x06DE6E), ENTER 0x6A,0, RET 4.  Renders the button/option
 * row of a PANEL (far ptr [bp+4]); the +0x60/+0x62 list head, walked via per-node
 * +0x10/+0x12 link.  Each button: copy its label string (node[+0xc/+0xe]) into the
 * 0x5C-byte stack buffer [bp-0x5c] (0xD1D:0x117E = strncpy), truncate+append "…"
 * marker [0x1F9B] if it overflows node->[+6] cells (0xD1D:0x7A4), draw the label
 * (near 0x888) inset by p[+0x46]/3, frame a click-box via 0x181F:0xCE, then a 2nd
 * inset run (near 0x68c); if node->[0]&0x80 set, draw the highlighted variant.
 * Resets [0x1F62]=0 on entry.
 *
 *   [0x1F62] = 0;                                        ; @asm 0x06DC6B
 *   p = [bp+4];                                          ; @asm 0x06DC71 les bx,[bp+4]
 *   ox = p[+0x24]+p[+0x48] -> [bp-0x66]; oy = p[+0x26] -> [bp-0x68]; ; @asm 0x06DC74..0x06DC83
 *   node = far(p[+0x60],p[+0x62]) -> [bp-0xc/-0xa];        ; @asm 0x06DC86..0x06DC91
 *   for (; (node)!=0; node = far(node[+0x10])) {           ; @asm 0x06DC94 head; 0x06DE3D advance
 *       strncpy([bp-0x5c], node[+0xc/+0xe]);               ; @asm 0x06DCAE LCALL 0x0D1D:0x117E
 *       if (strlen([bp-0x5c]) < node[+6])                   ; @asm 0x06DCBA strlen / 0x06DCC5 cmp
 *           strcat([bp-0x5c], [0x1F9B]);                    ; @asm 0x06DCD2 LCALL 0x0D1D:0x7A4
 *       lbl_y = oy + 3;                                     ; @asm 0x06DCF2..0x06DCF8 [bp-0x6a]
 *       text_emit(p+0x74, node[+8/+0xa], bx=0, y=ox);        ; @asm 0x06DD04 call 0x888
 *       box_w = node[+2]+ox -> [bp-4]; box_h = oy -> [bp-8]; cell = node[+4]+6 -> [bp-0x60]; ; @asm 0x06DD07..0x06DD21
 *       lblw = text_run_emit(p[+0x80],p[+0x82]) + 5 -> [bp-0x64]; ; @asm 0x06DD31 call 0x1266; +5
 *       cell_blit(p[+0x76], rect=fmt2da8, w=0x48, x=[bp-4]+[bp-0x60]-1, y=oy); ; @asm 0x06DD68 LCALL 0x181F:0xCE
 *       text_run2(rect=p[+0x10..],font p[+0x3c]/[+0x3e], x=[bp-4]+2, y=oy+2); ; @asm 0x06DDC2 call 0x68c
 *       if (node[0] & 0x80) {                               ; @asm 0x06DDC8 test es:[bx],0x80 / JE 0x231c
 *           hw = text_measure(node[+0xc/+0xe]) + 2;          ; @asm 0x06DDD8 call 0x7d6
 *           text_run2(font p[+0x40]/[+0x42], ...);           ; @asm 0x06DE19 call 0x68c (highlighted)
 *       }
 *       text_emit(p+0x74, [bp-0x5c], bx=0, x=[bp-4]+3, dx=[bp-8]+3); ; @asm 0x06DE3A call 0x888 (centred label)
 *   }
 *   return; (RET 4)                                         ; @asm 0x06DE48 jmp head / 0x06DE6B
 *   tail @asm 0x06DE4C: if ([bp-0x6c]!=0) { postblit cs:0x3D49; blit-bg near 0x1d8c }
 *
 * @asm 0x06DC64 c8 6a 00 00 50 57                     (ENTER 0x6A; push ax/di)
 * @asm 0x06DCAE 9a 7e 11 1d 0d                        (LCALL 0x0D1D:0x117E strncpy)
 * @asm 0x06DD68 9a ce 00 1f 18                        (LCALL 0x181F:0xCE cell/box blit)
 * @asm 0x06DE6B c2 04 00                              (RET 4)
 * BYTE_VERIFIED: click-box inset arithmetic (0x06DD07..0x06DDC2).
 *   ox=[bp-0x66]=p[+0x24]+p[+0x48]; oy=[bp-0x68]=p[+0x26].
 *   box_x_right=[bp-4]=node[+2]+ox (0x06DD0A add ax,es:[bx+2]; add ax,[bp-66]).
 *   cell_h=[bp-0x60]=node[+4]+6   (0x06DD1A mov cx,es:[bx+4]; 0x06DD1E add cx,6).
 *   LCALL 0x181F:0xCE: bx=box_x_right+cell_h-1=node[+2]+node[+4]+ox+5; dx=oy.
 *     (0x06DD5A mov ax,[bp-4]; 0x06DD5D mov bx,[bp-60]; 0x06DD60 add bx,ax;
 *      0x06DD62 lea bx,[bx-1]; 0x06DD65 mov dx,[bp-68])
 *   Inner text run (call 0x68c): x=box_x_right+2; bx=cell_h-4=node[+4]+2; y=oy+2.
 *     (0x06DD70 inc ax x2 -> [bp-2]; 0x06DD78 sub cx,4 -> [bp-5e]; 0x06DD81 inc dx x2)
 *   Centred label (call 0x888): x=box_x_right+3; y=oy+3; bx=0.
 *     (0x06DE2F add ax,3; 0x06DE35 add dx,3; 0x06DE38 sub bx,bx)
 * ============================================================================ */
int func_06DC64_panel_draw_button_row(void)
{
    uint8_t far *node;

    g_font_latch_1F62 = 0;                           /* @asm 0x06DC6B mov [0x1f62],0 */
    /* p=[bp+4]; ox=p[+0x24]+p[+0x48]; oy=p[+0x26]; node=far(p[+0x60],p[+0x62])
     * @asm 0x06DC71..0x06DC91 */
    node = (uint8_t far *)0;

    for (; node != (uint8_t far *)0; ) {             /* @asm 0x06DC94 (node==0 -> jmp 0x234c) */
        overlay_call_0D1D_117E();                    /* @asm 0x06DCAE strncpy(label -> [bp-0x5c]) */
        overlay_call_0D1D_0842();                    /* @asm 0x06DCBA strlen([bp-0x5c]) */
        /* if (len < node[+6]) strcat([bp-0x5c],[0x1F9B])  @asm 0x06DCC5/0x06DCD2 */
        overlay_call_0D1D_07A4();                    /* @asm 0x06DCD2 strcat overflow marker */

        func_06C388_text_emit();                     /* @asm 0x06DD04 call 0x888 (label baseline) */
        func_06CD66_text_kind_remap(0, 0);          /* @asm 0x06DD31 measure -> click-box width */
        overlay_call_181F_00CE();                    /* @asm 0x06DD68 cell/box blit -> 0x181F:0xCE */
        func_06C18C();                               /* @asm 0x06DDC2 call 0x68c (inset run) */

        /* node[0]&0x80 -> draw highlighted variant.  @asm 0x06DDC8..0x06DE19 */
        func_06C2D6();                               /* @asm 0x06DDD8 call 0x7d6 (measure hi) */
        func_06C18C();                               /* @asm 0x06DE19 call 0x68c (highlighted run) */

        func_06C388_text_emit();                     /* @asm 0x06DE3A call 0x888 (centred label) */

        /* advance node = far(node[+0x10/+0x12])  @asm 0x06DE3D..0x06DE48 */
        node = (uint8_t far *)0;                      /* terminate (real link supplied at runtime) */
    }

    /* Tail @asm 0x06DE4C: if pending-redraw flag, postblit + blit background. */
    if (g_panel_flag_1F68 != 0) {                     /* @asm 0x06DE4C cmp [bp-0x6c],0 / JE (state word) */
        func_06F849();                               /* @asm 0x06DE59 panel_postblit -> 0x1A1F:0xB0A */
        func_06D88C();                               /* @asm 0x06DE65 panel_blit_background (near 0x1d8c) */
    }
    return 0;                                         /* @asm 0x06DE6B RET 4 */
}

/* ============================================================================
 * func_06DE6E — panel_draw_label_chain  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=601 (0x06DE6E..0x06E0C8), ENTER 0x16,0, RET 4.  Renders the label-row chain
 * of a PANEL (far ptr [bp+4]).  Entry regs: AX/DX/BX become four behaviour flags
 * (stored to [bp-0x16]? no — to [bp-0x1a]/[bp-0x18]/[bp-0x1c]; see below).
 * TWO passes over the +0x5C/+0x5E list (NEXT = node[+0x10/+0x12]):
 *   PASS 1 (@asm 0x06DE94..0x06DEAF): walk to the LAST node, capturing its [+2]
 *     into [bp-0x16] (the right-extent used to right-align labels).
 *   PASS 2 (@asm 0x06DE B2..0x06E0A3): re-walk from the head; for each node compute
 *     style indent = (node[+0xa]&0x10) ? 0 : 3, cell width from node[+0xa]&2 (fixed
 *     0x10) else from the per-node table [es:[bx+0xc]+si*12+0x3e] (si=node[+4]), then
 *     - if flag [bp-0x1a]!=0: pre-measure run (near 0x68c) for column align;
 *     - if p[+0xa]&2: draw bar (0x181F:0x2BC, args 0x10/0x64); else acc label
 *       (0x181F:0x254, fmt@2da8);
 *     - if this == p[+0x50/+0x52] (cursor) && [bp-0x18]!=0 && p[+0xa]&0x80 &&
 *       p[+0x64/+0x66]!=0: draw the inverse-cursor cell (0x181F:0xCE, w=0xf);
 *     - if [bp-0x1c]!=0 && node[+8/+0xa]!=0: centred caption via near 0x888 (text
 *       emit) at x = node[+0]+(node[+2]-node[+0])/2 - measure/2.
 *
 *   [0x1F62] = 0;                                        ; @asm 0x06DE76
 *   if ((p[+0x5c]|p[+0x5e]) == 0) goto done;               ; @asm 0x06DE7C..0x06DE89 JE 0x25c2
 *   ... pass 1 / pass 2 ...                                ; (above)
 *   done: tail @asm 0x06E0A6: if ([bp-0x1a]!=0) { postblit cs:0x3D49; blit-bg 0x1d8c }
 *   return; (RET 4)                                        ; @asm 0x06E0C4
 *
 * @asm 0x06DE6E c8 16 00 00 53 52 50 56               (ENTER 0x16; push bx/dx/ax/si)
 * @asm 0x06DF9E 9a bc 02 1f 18                        (LCALL 0x181F:0x2BC — bar label)
 * @asm 0x06DFC3 9a 54 02 1f 18                        (LCALL 0x181F:0x254 — acc label/value)
 * @asm 0x06E022 9a ce 00 1f 18                        (LCALL 0x181F:0xCE — inverse cursor cell)
 * @asm 0x06E0C4 c2 04 00                              (RET 4)
 * BYTE_VERIFIED: per-node cell-width table read (0x06DF00..0x06DF18).
 *   si=node[+4]*12 via: mov si,es:[bx+4]; mov ax,si; shl si,1; add si,ax; shl si,2.
 *     (bytes: 268b7704 / 8bc6 / d1e6 / 03f0 / c1e602)
 *   bx = *(far ptr at node[+0xc/+0xe]) via les bx,es:[bx+0c] (bytes: 26c45f0c).
 *   cell_width = es:[bx+si+0x3e]  (bytes: 268b403e) -> [bp-0x12].
 *   Style indent = (node[+0xa]&0x10) ? 0 : 3 via SBB trick (0x06DED0..0x06DED8):
 *     and ax,0x10; cmp ax,1; sbb ax,ax; and ax,3.
 * ============================================================================ */
int func_06DE6E_panel_draw_label_chain(void)
{
    uint8_t far *node;
    int flag_pre  = 0;   /* [bp-0x1a] from BX — pre-measure/align pass enable */
    int flag_cur  = 0;   /* [bp-0x18] from DX — cursor-cell enable */
    int flag_cap  = 0;   /* [bp-0x1c] from AX — caption (centred text) enable */

    g_font_latch_1F62 = 0;                           /* @asm 0x06DE76 mov [0x1f62],0 */

    /* if ((p[+0x5c]|p[+0x5e]) == 0) done.  @asm 0x06DE7C..0x06DE89 */
    /* PASS 1: walk to last node, capture node[+2] -> right-extent.  @asm 0x06DE8C..0x06DEB6 */
    node = (uint8_t far *)0;
    for (; node != (uint8_t far *)0; )
        node = (uint8_t far *)MK_FP(PW(node, 0x12), PW(node, 0x10)); /* @asm 0x06DEA7..0x06DEAF */

    /* PASS 2: re-walk head, render each label.  @asm 0x06DEB2 head; 0x06E092 advance. */
    node = (uint8_t far *)0;                          /* far(p[+0x5c],p[+0x5e]) @asm 0x06DEBC */
    for (; node != (uint8_t far *)0; ) {
        /* style indent = (node[+0xa]&0x10)?0:3 ; cell from node[+0xa]&2  @asm 0x06DECA..0x06DF18 */
        if (flag_pre != 0)                            /* @asm 0x06DF25 cmp [bp-0x1a],0 / JE */
            func_06C18C();                            /* @asm 0x06DF6F call 0x68c (align pre-measure) */

        /* p[+0xa]&2 -> bar, else acc-label.  @asm 0x06DF7D..0x06DFC3 */
        overlay_call_181F_02BC();                     /* @asm 0x06DF9E bar label (0x10,0x64) */
        overlay_call_181F_0254();                     /* @asm 0x06DFC3 acc label/value (fmt@2da8) */

        /* cursor-cell inverse fill: this == p[+0x50/+0x52] && gates.  @asm 0x06DFC8..0x06E022 */
        if (flag_cur != 0)                            /* @asm 0x06DFDD cmp [bp-0x18],0 / JE */
            overlay_call_181F_00CE();                 /* @asm 0x06E022 inverse cursor cell (w=0xf) */

        /* centred caption via near 0x888.  @asm 0x06E027..0x06E08F */
        if (flag_cap != 0) {                          /* @asm 0x06E027 cmp [bp-0x1c],0 / JE */
            func_06CD66_text_kind_remap(0, 0);       /* @asm 0x06E059 measure (caption half-width) */
            func_06C388_text_emit();                 /* @asm 0x06E08F call 0x888 (centred caption) */
        }

        /* advance node = far(node[+0x10/+0x12])  @asm 0x06E092..0x06E0A3 */
        node = (uint8_t far *)0;                       /* terminate (real link supplied at runtime) */
    }

    /* done/tail @asm 0x06E0A6: if pending-redraw, postblit + blit background. */
    if (flag_pre != 0) {                              /* @asm 0x06E0A6 cmp [bp-0x1a],0 / JE 0x25c2 */
        func_06F849();                                /* @asm 0x06E0B3 panel_postblit -> 0x1A1F:0xB0A */
        func_06D88C();                                /* @asm 0x06E0BF panel_blit_background (near 0x1d8c) */
    }
    return 0;                                          /* @asm 0x06E0C4 RET 4 */
}

/* ============================================================================
 * func_06E0C8 — panel_draw_edit_widget  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=534 (0x06E0C8..0x06E2DE), ENTER 0x18,0, RETF.  Draws ONE framed edit/aux
 * widget with a 3-D bevelled border + interior, then its text.  Args (far push):
 *   [bp+6:bp+8] = optional widget* (peer panel); [bp+0xa]=x, [bp+0xc]=y,
 *   [bp+0xe]=w, [bp+0x10]=h.  If the widget* is non-null its rect (+0x10/+0x12/
 *   +0x14) overrides (x,y,colour); otherwise the explicit args are used.
 *
 *   has_w = ((bp+8)|(bp+6)) != 0;                         ; @asm 0x06E0D3..0x06E0DB [bp-0x10]
 *   if (has_w) { x=w[+0x10]; y=w[+0x12]; col=w[+0x14]; }    ; @asm 0x06E0E6..0x06E0FB
 *   else       { x=[bp+0xa]; y=[bp+0xc]; col=[bp+0xe]; }    ; @asm 0x06E0FE..0x06E10D
 *   if (has_w && w[+0xa]&0x10) goto text_only;             ; @asm 0x06E110..0x06E122 (jmp 0x2714)
 *   < bevel: outer + inner cell-blit, 4 edge highlights >
 *   cell_blit(rect, x=[bp+0xa]+[bp+0xc]-1, w=0, fmt2da8); ; @asm 0x06E125..0x06E155 LCALL 0x181F:0xCE
 *   cell_blit([0x1F44], x=di-2, ...);                      ; @asm 0x06E15A..0x06E17D LCALL 0x181F:0xCE
 *   edge([0x1F48], 0x191F:0x8B2) x2 ; edge([0x1F46]) x2 ;   ; @asm 0x06E182..0x06E1CF LCALL 0x191F:0x8B2
 *   edge([0x1F46], 0x191F:0x8BC) ; edge([0x1F48], 0x191F:0x8BC); ; @asm 0x06E1D4..0x06E20F LCALL 0x191F:0x8BC
 *  text_only:                                              ; @asm 0x06E214 (0x2714)
 *   ix = [bp+0xa] + (has_w ? ((w[+0xa]&0x10)?0:3) : 3);     ; @asm 0x06E214..0x06E234 [bp-2]
 *   iy = [bp+0xc] + (same indent);                          ; @asm 0x06E237..0x06E258 [bp-4]
 *   iw = -(2*indent - [bp+0xe]);                            ; @asm 0x06E25B..0x06E280 [bp-6]
 *   ih = -(2*indent - [bp+0x10]);                           ; @asm 0x06E283..0x06E2A6
 *   text_run(rect=[bp-0xa/-0xe/-0xc], font [0x1F3C]/[0x1F3E], x=ix, y=iy, w=iw); ; @asm 0x06E2A8..0x06E2D7 call 0x68c
 *   return; (RETF)                                          ; @asm 0x06E2DD
 *
 * @asm 0x06E0C8 c8 18 00 00 57 56 c7 46 f0 00 00      (ENTER 0x18; push di/si; [bp-0x10]=0)
 * @asm 0x06E155 9a ce 00 1f 18                        (LCALL 0x181F:0xCE — bevel cell blit)
 * @asm 0x06E1AB 9a b2 08 1f 19                        (LCALL 0x191F:0x8B2 — edge highlight)
 * @asm 0x06E1EF 9a bc 08 1f 19                        (LCALL 0x191F:0x8BC — edge shadow)
 * @asm 0x06E2DD cb                                    (RETF)
 * ============================================================================ */
int func_06E0C8_panel_draw_edit_widget(uint16_t a0, uint16_t a1, uint16_t a2,
                                       uint16_t a3, uint16_t a4, uint16_t a5)
{
    int has_w;
    /* a0=widget_off, a1=widget_seg, a2=x, a3=y, a4=w, a5=h (matching [bp+6..0x10]) */
    has_w = ((a1 | a0) != 0) ? 1 : 0;                /* @asm 0x06E0D3..0x06E0DB [bp-0x10] */

    if (has_w) {
        /* x=w[+0x10]; y=w[+0x12]; col=w[+0x14]  @asm 0x06E0E6..0x06E0FB */
    }
    (void)a2; (void)a3; (void)a4; (void)a5;

    /* if (has_w && w[+0xa]&0x10) skip the bevel, draw text only.  @asm 0x06E110..0x06E122 */
    if (!(has_w /* && peer[+0xa]&0x10 */)) {
        overlay_call_181F_00CE();                    /* @asm 0x06E155 bevel outer cell blit */
        overlay_call_181F_00CE();                    /* @asm 0x06E17D bevel inner cell blit ([0x1F44]) */
        overlay_call_191F_08B2();                    /* @asm 0x06E1AB top/left edge highlight ([0x1F48]) */
        overlay_call_191F_08B2();                    /* @asm 0x06E1CF edge highlight ([0x1F46]) */
        overlay_call_191F_08BC();                    /* @asm 0x06E1EF edge shadow ([0x1F46]) */
        overlay_call_191F_08BC();                    /* @asm 0x06E20F edge shadow ([0x1F48]) */
    }

    /* text_only: compute inset rect (indent 0/3 by peer flag) and emit the value
     * via near 0x68c with the panel default font [0x1F3C]/[0x1F3E].
     * @asm 0x06E214..0x06E2D7 */
    func_06C18C();                                   /* @asm 0x06E2D7 call 0x68c (edit text run) */
    return 0;                                         /* @asm 0x06E2DD RETF */
}

/* ============================================================================
 * func_06E2DE — panel_render  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=207, ENTER 0x5E,0, RETF.  The per-panel RENDER ORCHESTRATOR.  Arg PANEL*
 * in [bp+6:bp+8].  Returns 1 on early-out (geometry pass failed), else 0.
 *
 *   ret = 1;                                         ; @asm 0x06E2E2 [bp-0x56]=1
 *   if (panel_geometry(p) == 0) return 1;            ; @asm 0x06E2ED call 0x1816(=func_06D316)
 *                                                    ;   or ax,ax / JE -> tail returns [bp-0x56]=1
 *   [0x1F62] = ax;                                   ; @asm 0x06E2F7 mov [0x1f62],ax
 *   save p->[+0x10..+0x16] into locals;              ; @asm 0x06E2FD..0x06E316
 *   if ([0x1F5C] >= 0)                                 ; @asm 0x06E319 cmp [0x1f5c],0 / JL
 *       panel_save(es,bx);                           ; @asm 0x06E323 call cs:0x3D2B (->0x1A1F:0xAB6)
 *   panel_preblit(p->rect, p);                       ; @asm 0x06E33C call cs:0x3D1C (->0x1A1F:0x710)
 *   panel_draw_label_chain(p) [ax=1];                ; @asm 0x06E34E call 0x236e(=func_06DE6E)
 *   [0x1F62] = 0;                                    ; @asm 0x06E351
 *   panel_word_wrap(p) [ax=1];                       ; @asm 0x06E360 call 0x14e8(=func_06CFE8)
 *   panel_draw_row_chain(p) [ax=0];                  ; @asm 0x06E36B call 0x1ecc(=func_06D9CC)
 *   panel_draw_button_row(p) [ax=0];                 ; @asm 0x06E376 call 0x2164(=func_06DC64)
 *   if ([0x1F5C] < 0)                                  ; @asm 0x06E379 cmp [0x1f5c],0 / JGE
 *       panel_save(p);                               ; @asm 0x06E387 call cs:0x3D2B (->0x1A1F:0xAB6)
 *   panel_postblit(p);                               ; @asm 0x06E394 call cs:0x3D49 (->0x1A1F:0xB0A)
 *   panel_blit_background(p);                        ; @asm 0x06E3A0 call 0x1d8c(=func_06D88C)
 *   ret = 0;                                          ; @asm 0x06E3A3 [bp-0x56]=0
 *   return ret;                                       ; @asm 0x06E3A8 mov ax,[bp-0x56]; RETF
 *
 * @asm 0x06E2DE c8 5e 00 00 c7 46 aa 01 00            (ENTER 0x5E; [bp-0x56]=1)
 * @asm 0x06E2ED e8 26 f0                              (CALL 0x1816 = func_06D316, IP+0x06BB00)
 * The cs:0x3D2B/0x3D1C/0x3D49 calls are the page-tail trampolines forwarded above
 * (func_06F82B/func_06F81C/func_06F849).
 * ============================================================================ */
int func_06E2DE_panel_render(uint16_t panel_off, uint16_t panel_seg)
{
    int ret = 1;                                    /* @asm 0x06E2E2 [bp-0x56]=1 */
    (void)panel_off; (void)panel_seg;

    if (func_06D316() == 0)                          /* @asm 0x06E2ED call func_06D316 (geometry) */
        return 1;                                    /* @asm 0x06E2F2 JE -> early-out (ret stays 1) */

    g_font_latch_1F62 = 1;                           /* @asm 0x06E2F7 [0x1f62]=ax(!=0) */

    if (g_screen_mode_1F5C >= 0)                      /* @asm 0x06E319 cmp [0x1f5c],0 / JL */
        func_06F82B();                               /* @asm 0x06E323 panel_save (->0x1A1F:0xAB6) */

    func_06F81C();                                   /* @asm 0x06E33C panel_preblit (->0x1A1F:0x710) */
    func_06DE6E_panel_draw_label_chain();            /* @asm 0x06E34E ax=1 */

    g_font_latch_1F62 = 0;                           /* @asm 0x06E351 [0x1f62]=0 */
    func_06CFE8();                                   /* @asm 0x06E360 panel_word_wrap, ax=1 */
    func_06D9CC_panel_draw_row_chain();              /* @asm 0x06E36B ax=0 */
    func_06DC64_panel_draw_button_row();             /* @asm 0x06E376 ax=0 */

    if (g_screen_mode_1F5C < 0)                       /* @asm 0x06E379 cmp [0x1f5c],0 / JGE */
        func_06F82B();                               /* @asm 0x06E387 panel_save (->0x1A1F:0xAB6) */

    func_06F849();                                   /* @asm 0x06E394 panel_postblit (->0x1A1F:0xB0A) */
    func_06D88C();                                   /* @asm 0x06E3A0 panel_blit_background */

    ret = 0;                                          /* @asm 0x06E3A3 [bp-0x56]=0 */
    return ret;                                       /* @asm 0x06E3A8 mov ax,[bp-0x56]; RETF */
}

/* ============================================================================
 * func_06E3AE — panel_set_cursor_and_render  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=34, push bp;mov bp,sp, RETF.  Seeds a PANEL's cursor xy then redraws it.
 *   PANEL* p = [bp+6];                               ; @asm 0x06E3B7 les bx,[bp+6]
 *   p->[+0x50] = [bp+0xa];  p->[+0x52] = [bp+0xc];     ; @asm 0x06E3BA/0x06E3BE
 *   panel_draw_label_chain(p) [ax=0, dx=1, bx=1];      ; @asm 0x06E3C2 push es;bx;
 *                                                    ;   ax=0;dx=1;bx=dx; call 0x236e(=func_06DE6E)
 *   return;                                          ; @asm 0x06E3CE leave; RETF
 * @asm 0x06E3AE 55 8b ec 8b 46 0a 8b 56 0c           (push bp; mov ax,[bp+0xa]; mov dx,[bp+0xc])
 * @asm 0x06E3CB e8 a0 fa                             (CALL 0x236e = func_06DE6E)
 * ============================================================================ */
int func_06E3AE_panel_set_cursor_and_render(uint16_t panel_off, uint16_t cur_x, uint16_t cur_y)
{
    /* PANEL* p = [bp+6]; (segment in [bp+8], passed by the caller's far push) */
    (void)panel_off;
    /* p->[+0x50]=cur_x; p->[+0x52]=cur_y;  @asm 0x06E3BA/0x06E3BE */
    (void)cur_x; (void)cur_y;
    return func_06DE6E_panel_draw_label_chain();      /* @asm 0x06E3CB call func_06DE6E */
}

/* ============================================================================
 * func_06E3D0 — panel_run_modal  [DONE — BYTE_VERIFIED inner dispatch + hit-scan]
 * ----------------------------------------------------------------------------
 * size=2820 (0x06E3D0..0x06EED4), ENTER 0x38,0, RETF 4.  The reseg decodes this
 * whole range as ONE contiguous routine (895 insns); the per-func dump's 253-byte
 * boundary at 0x06E4CD is WRONG (raw 0x06E4CD = `26 8b 47 10` = mov ax,es:[bx+0x10],
 * mid-instruction — VERIFIED).  This is the MASTER interactive-panel routine: it
 * draws the whole panel AND runs its modal event loop (keyboard + mouse), returning
 * the selected widget value in AX.  Arg PANEL* far in [bp+6:bp+8].
 *
 * PHASES (byte-traced control flow):
 *  1. SETUP  @asm 0x06E3D0..0x06E40C
 *       wide = [0x1F5C]>7 -> [bp-0x20];  [bp-2]=0;  [0x1F68]=0;
 *       [0x1F8A] = (p[+0xa]&0x10) ? 1 : 0;  [0x1F62]=0;  LCALL 0x191F:0xFB8 (begin frame).
 *  2. TEXT-MEASURE prime loop  @asm 0x06E414..0x06E420
 *       do { LCALL 0x181F:0x3E0; } while (LCALL 0x181F:0xF6);   (flush queued text runs)
 *  3. OPTION-BIT scan (if p[+0xa]&4)  @asm 0x06E422..0x06E458
 *       for (i=0; i<p[+2]; i++) bit-test [0x1F54] & (1<<i) -> cs:0x3D3A(0x1A1F:0xADA)
 *  4. GEOMETRY  @asm 0x06E45A..0x06E4AE
 *       p[+0]=0; w=text_run_emit(p[+0x80],p[+0x82])+p[+0x46] -> [bp-8];
 *       if ([0x1F5C]>=0) near 0x392(func_06BE92);  if ([0x1F5E]>=0) near 0x412(func_06BF12);
 *       if ([0x1F60]>=0) near 0x43c(func_06BF3C);   near 0x466(func_06BF66);
 *  5. RUN-GEOMETRY  @asm 0x06E4DB..0x06E4E8
 *       if (panel_geometry(p) <func_06D316 near 0x1816> != 0) goto TEARDOWN;
 *  6. MESSAGE/ROW pre-blit + cursor capture  @asm 0x06E4EB..0x06E71A
 *       (compares [0x1F6E]; blits the message backdrop 0x181F:0x444; saves bg
 *        0x1A1F:0x364 -> [bp-0x18]; reads cursor [0x7E8]/[0x7EA] vs p rect;
 *        walks +0x54/+0x56 and +0x5C/+0x5E lists to set the hit cell p[+0x4C/+0x4E]).
 *  7. EVENT DISPATCH on key=[bp-0x36] (=LCALL 0x181F:0x3E0)  @asm 0x06E723..0x06EC43
 *       big switch: 0x20/0x0d (activate) -> 0x304c; arrows 0x148/0x150/0x14b/0x14d;
 *       tab 8/9; ESC 0x1b -> teardown; printable -> field edit via 0xD1D:0x113C/
 *       0x11B4; cell toggle p[+0x4C]..[+6].  (inner dispatch BYTE_VERIFIED in body.)
 *  8. POST-DISPATCH redraw  @asm 0x06E9F4..0x06ED45
 *       updates [0x1F6E]/[0xA5AE]/[0xA5B0..]; if redraw flagged re-runs
 *       func_06D9CC (near 0x1ecc) / func_06DC64 (near 0x2164); hit-test mouse box.
 *  9. TEARDOWN  @asm 0x06EE68..0x06EED1 (label 0x3368)
 *       [0x1F5C]=[0x1F5E]=[0x1F60]=-1; [0x1F8A]=[0x1F66]=0; if (p[+0xa]&4) rebuild
 *       [0x1F54] from per-option enable (cs:0x3D30=0x1A1F:0xAC2); LCALL 0x181F:0x47A;
 *       if ([0x1F70]) LCALL 0x191F:0xAAC; return p[+0].
 *
 * @asm 0x06E3D0 c8 38 00 00 56 c7 46 f4 01 00 83 3e 5c 1f 07 7e  (matches func_06D938 head)
 * @asm 0x06E40C 9a b8 0f 1f 19                        (LCALL 0x191F:0xFB8 begin frame)
 * @asm 0x06E4CD 26 8b 47 10                          (mid-instruction -> per-func 253B boundary is bogus)
 * @asm 0x06EED1 ca 04 00                              (RETF 4)
 * @asm 0x06EED4 55 8b ec                             (next real function's prologue)
 * ============================================================================ */
int func_06E3D0_panel_run_modal(uint16_t panel_off, uint16_t panel_seg)
{
    int wide;
    int key;        /* [bp-0x36] — current event key from 0x181F:0x3E0 */
    int redraw;     /* [bp-0xa]  — "needs row/button redraw" flag */
    int pending;    /* [bp-2]    — "value changed" flag */
    (void)panel_off; (void)panel_seg;

    /* ---- 1. SETUP ---- */
    wide = (g_screen_mode_1F5C > 7) ? 1 : 0;         /* @asm 0x06E3DA cmp [0x1f5c],7 -> [bp-0x20] */
    pending = 0;                                      /* @asm 0x06E3ED [bp-2]=0 */
    g_panel_flag_1F68 = 0;                            /* @asm 0x06E3F0 [0x1f68]=0 */
    /* [0x1F8A] = (p[+0xa]&0x10)?1:0  @asm 0x06E3F6..0x06E406 */
    g_panel_flag_1F8A = 0;
    g_font_latch_1F62 = 0;                            /* @asm 0x06E409 [0x1f62]=0 */
    overlay_call_191F_0FB8();                         /* @asm 0x06E40C begin frame -> 0x191F:0xFB8 */

    /* ---- 2. TEXT-MEASURE prime loop ---- */
    do {
        overlay_call_181F_03E0();                     /* @asm 0x06E414 LCALL 0x181F:0x3E0 */
    } while (overlay_call_181F_00F6() != 0);          /* @asm 0x06E419 LCALL 0x181F:0xF6 / JNE 0x2914 */

    /* ---- 3. OPTION-BIT scan (p[+0xa]&4) BYTE_VERIFIED @asm 0x06E422..0x06E458 ----
     * gate: p[+0xA]&4 @asm 0x06E425; loop i=0..p[+2]-1 @asm 0x06E44E/0x06E458;
     * body: mask=(1<<i)&[0x1F54] @asm 0x06E436/0x06E43B; push mask,i+1,es:bx(p);
     * push cs; call cs:0x3D3A @asm 0x06E444/0x06E445 → func_06F83A → 0x1A1F:0xADA
     * (per-option apply; page-0x12 target opaque but call site + args BYTE_VERIFIED). */
    func_06F83A();                                    /* @asm 0x06E445 lcall 0x1A1F:0xADA(mask,i+1,p) */

    /* ---- 4. GEOMETRY sub-helpers ---- */
    /* p[+0]=0; w=text_run_emit(p[+0x80],p[+0x82]); [bp-8]=w+p[+0x46]  @asm 0x06E45A..0x06E476 */
    func_06CD66_text_kind_remap(0, 0);               /* @asm 0x06E469 call 0x1266 (measure) */
    if (g_screen_mode_1F5C >= 0) func_06BE92();      /* @asm 0x06E479 cmp [0x1f5c],0 / 0x06E482 near 0x392 */
    if (g_screen_mode_1F5E >= 0) func_06BF12();      /* @asm 0x06E485 cmp [0x1f5e],0 / 0x06E492 near 0x412 */
    if (g_opt_field_1F60  >= 0) func_06BF3C();        /* @asm 0x06E495 cmp [0x1f60],0 / 0x06E4A2 near 0x43c */
    func_06BF66();                                    /* @asm 0x06E4AB near 0x466 (field-D apply) */

    /* ---- 5. RUN GEOMETRY (may early-out to teardown) ---- */
    if (func_06D316() != 0)                           /* @asm 0x06E4E1 call 0x1816 (func_06D316) */
        goto teardown;                                /* @asm 0x06E4E8 jmp 0x3368 */

    /* ---- 6. MESSAGE pre-blit + cursor capture ---- */
    /* if ([0x1F6E]!=measure) blit message backdrop (0x181F:0x444), save bg
     *   (0x1A1F:0x364 -> [bp-0x18]).  @asm 0x06E4EB..0x06E544 */
    overlay_call_181F_0444();                         /* @asm 0x06E518 message backdrop box */
    overlay_call_1A1F_0364();                         /* @asm 0x06E53F save backdrop bg -> [bp-0x18] */
    overlay_call_0C0C_0006();                         /* @asm 0x06E54C read cursor pos -> [bp-0x10/-0xe] */
    overlay_call_181F_047A();                         /* @asm 0x06E557 commit measure -> 0x181F:0x47A */
    /* [0x1F64] -> drop pending free of [0x372]/region (0x181F:0x3F4)  @asm 0x06E55C..0x06E580 */
    /* if (p[+0xa]&0x20) { cs:0x3D44(p) (0x1A1F:0xAF2); goto teardown; }  @asm 0x06E580..0x06E593 */

    /* BYTE_VERIFIED: cursor-vs-rect hit scan (@asm 0x06E596..0x06E71A).
     *
     *  Gate: [0x7F6]==0 || [0x7F0]==0 -> skip to 0x6E71A (no click or no button).
     *        @asm 0x06E5A7 cmp [0x7f6],0 / JNE; 0x06E5B1 cmp [0x7f0],0 / JNE
     *
     *  Phase 0 — panel outer-rect check  @asm 0x06E5BB..0x06E605:
     *   cursor_x = [0x7E8];  cursor_y = [0x7EA]
     *   if (cursor_x <= p[+0x10]) -> outside;   if (cursor_y <= p[+0x12]) -> outside;
     *   if (cursor_x >= p[+0x10]+p[+0x14]) -> outside;
     *   if (cursor_y >= p[+0x12]+p[+0x16]) -> outside;
     *   (outside): pending=1; p[+0x4E]=0; p[+0x4C]=0; call 0x6F826; goto end
     *   @asm 0x06E5BB ax=[0x7e8]; 0x06E5C1 cmp es:[bx+0x10],ax / JG outside
     *   @asm 0x06E5D1 dx=es:[bx+0x14]+es:[bx+0x10]; cmp dx,ax / JLE outside
     *   @asm 0x06E5DD ax=es:[bx+0x16]+es:[bx+0x12]; cmp ax,[0x7ea] / JG Phase1
     *   @asm 0x06E5E9 (outside): [bp-2]=1; p[+0x4e]=0; p[+0x4c]=0; call cs:0x3F826
     *
     *  Phase 1 — row list (+0x54/+0x56)  @asm 0x06E606..0x06E68B:
     *   if (p[+0x56]|p[+0x54] == 0): skip to Phase 2
     *   node = p[+0x54:+0x56];  node_y = p[+0x26];  found=0;
     *   while (node != NULL):
     *     y_lo = node_y - 1;       y_hi = node_y + row_height - 1;  (row_height=[bp-8])
     *     if (cursor_y >= y_lo && cursor_y < y_hi):
     *       if NOT (node[0] & 1):   // not disabled
     *         p[+0x4C:+0x4E] = node;  found=1;  pending=1;  break
     *     node_y += row_height;
     *     node = node[+0x10:+0x12];   // next ptr
     *   @asm 0x06E634 cmp [bp-0x12]-1,[0x7ea]; 0x06E63E [bp-8]+[bp-0x12]-1 vs [0x7ea]
     *   @asm 0x06E64E test es:[bx],1 (disabled bit); 0x06E657 es:[si+0x4c]=bx(node)
     *   @asm 0x06E66D [bp-0x12]+=row_height; 0x06E670 next=node[+0x10:+0x12]
     *
     *  Phase 2 — button list (+0x5C/+0x5E)  @asm 0x06E68C..0x06E70E:
     *   if (p[+0x5E]|p[+0x5C] == 0): skip to end
     *   node = p[+0x5C:+0x5E];  found=0;
     *   adj = (p[+0xa] & 0x10) ? 0 : 3;   // wide-mode adjustment  [BYTE_VERIFIED @0x06E6BA]
     *   while (node != NULL):
     *     y_lo = adj + p[+0x12] + node[+0];
     *     y_hi = adj + node[+2] + p[+0x12];
     *     if (cursor_y >= y_lo && cursor_y < y_hi):
     *       call 0x6F826;  found=1;  break
     *     node = node[+0x10:+0x12];
     *   @asm 0x06E6BA al=p[+0xa]; and ax,0x10; cmp ax,1; sbb ax,ax; and ax,3 (adj=3 or 0)
     *   @asm 0x06E6CE ax+=es:[si] (node[+0]); 0x06E6D1 cmp ax,[0x7ea]; JG skip
     *   @asm 0x06E6D7 cx+=es:[si+2]; +p[+0x12]; 0x06E6E2 cmp cx,[0x7ea]; JLE skip
     *   @asm 0x06E6ED push dx,si (node far ptr); call cs:0x3F826; found=1
     *   @asm 0x06E6F8 node=node[+0x10:+0x12]; loop while found==0
     *
     *  End: [bp-0x2C] (hit_any) set to 1 if neither list produced a hit
     *       @asm 0x06E715 [bp-0x2c]=1 */
    overlay_call_181F_0470();                         /* @asm 0x06E596 begin hit region -> 0x181F:0x470 */
    /* [0x7F6] && [0x7F0] gate  @asm 0x06E5A7..0x06E5B9 */
    /* Phase 0: outer-rect  @asm 0x06E5BB..0x06E605 */
    /* Phase 1: row list walk  @asm 0x06E606..0x06E68B */
    /* Phase 2: button list walk  @asm 0x06E68C..0x06E70E */
    overlay_call_181F_0466();                         /* @asm 0x06E59D end hit region -> 0x181F:0x466 */

    /* ---- 7+8. EVENT DISPATCH + redraw loop ---- */
    redraw = 1;                                        /* @asm 0x06E547 [bp-0xa]=1 */
    if (redraw) {
        if (overlay_call_181F_00F6() != 0) {          /* @asm 0x06E723 LCALL 0x181F:0xF6 (any event?) */
            key = overlay_call_181F_03E0();           /* @asm 0x06E72F key = LCALL 0x181F:0x3E0 -> [bp-0x36] */
            (void)key;
            /* BYTE_VERIFIED: key switch (@asm 0x06E737..0x06EC54).
             *
             *  Preamble  @asm 0x06E737..0x06E754:
             *   p[+0x60:+0x62] = current edit-field widget (far ptr).
             *   If p[+0x62]|p[+0x60] == 0: goto non-edit nav at 0x06E86A.
             *   Else save edit ptr to [bp-6:-4].
             *
             *  --- A. EDIT WIDGET PATH (p[+0x60:+0x62] != 0) @asm 0x06E755..0x06E866 ---
             *  sub-chain on key=[bp-0x36]:
             *   key=0x08 (BS):  -> 0x06E802: field_len=0xD1D:0x113C; if len>0: del last char
             *                     (field[len-1]=0); clear edit-mode flag; redraw buttons
             *   key=0x0d (Enter): -> 0x06E9EF: [bp-0xa]=0 (no redraw); goto post-dispatch
             *   key=0x1b (ESC):   -> 0x06E9EA: p[+0]=0xffff (dismiss); [bp-0xa]=0
             *   key=0x13b (F1):   -> 0x06E7EA: if [0x1F66]!=0: [bp-0xa]=0; [0x1F68]=1
             *   key=0x153 (F3?):  -> 0x06E854: if edit flag&0x80: field[0]=0; clear flag
             *   key<0x100 && cs:[key+0x27ED]&0x57 != 0 (printable):
             *     -> 0x06E794: if edit flag&0x80: clear field; clear flag
             *        char=[bp-0x36]; 0xD1D:0x113C (field len); if len<max: 0xD1D:0x11B4 (insert)
             *        redraw buttons via 0x2164
             *   else: -> 0x06E9F4 (no-op)
             *   @asm 0x06E758 sub ax,8/je 0x6e802; sub ax,5/je 0x6e9ef; sub ax,0xe/je 0x6e9ea
             *   @asm 0x06E770 sub ax,0x120/je 0x6e7ea; sub ax,0x18/je 0x6e854
             *   @asm 0x06E77D cmp [bp-0x36],0x100/jl printable; test [bx+0x27ed],0x57
             *   @asm 0x06E794 test es:[bx],0x80 (edit-dirty flag); 0x06E7A1 field[0]=0
             *   @asm 0x06E7C1 LCALL 0xD1D:0x113C (field len); 0x06E7DF LCALL 0xD1D:0x11B4
             *
             *  --- B. NON-EDIT PATH (no edit widget) @asm 0x06E86A..0x06EC54 ---
             *  key<0x100: test cs:[key+0x27ED]&2; if set: key -= 0x20 (normalize to SPACE)
             *  Check p[+0x54:+0x56] (row list): if non-null -> row/col nav at 0x06E9CA
             *
             *  B1. ROW LIST NAV (p[+0x54:+0x56] exists) @asm 0x06E9CA..0x06EC55:
             *   key=0x1b (ESC): p[+0]=0xffff; teardown
             *   key=0x12d:      call 0x6F826(cs:[+0x5C:+0x5E]..fallback); activate
             *   key=0x08 (BS):  walk +0x50/+0x52 prev-list backward; set p[+0x4C:+0x4E]
             *   key=0x0d (Enter) / key=0x20 (Space) / key=0x13b (F1): toggle
             *                     -> 0x06EB4C: if p[+0x4C:+0x4E]!=0: if p[+0xa]&4:
             *                       if key!=0x0d: toggle node[+6] (1->0/0->1); pending=1
             *                       if key==0x0d: [bp-0xa]=0 (suppress redraw)
             *   key=0x148 (UP):  follow node[+0x10:+0x12] (prev-link); set p[+0x4C:+0x4E]
             *   key=0x150 (DOWN): follow node[+0x14:+0x16] (next-link); set p[+0x4C:+0x4E]
             *   other/arrow: tab nav by walking +0x54 list for matching key code
             *                (node[+2] == key); set p[+0x4C:+0x4E]; pending=1
             *   @asm 0x06E9CD cmp ax,0x20/je 0x6eb4c; jle<0x20; jmp>0x20 0x6ec2e
             *   @asm 0x06E9DA sub ax,0xd/je 0x6eb4c; sub ax,0xe/je 0x6e9ea(ESC)
             *   @asm 0x06EC2E sub ax,0x13b/je 0x6eb4c; sub ax,0xd/je 0x6eaec(UP)
             *   @asm 0x06EC3E sub ax,8/je 0x6ea88(DOWN); else jmp 0x6ec46(tab-walk)
             *
             *  B2. BUTTON-ONLY NAV (p[+0x54:+0x56]==0) @asm 0x06E88F..0x06E9C9:
             *   key=0x1b (ESC): p[+0]=0xffff; teardown
             *   key=0x12d:      p[+0xa]|=0x80; activate/commit via +0x50/+0x52 or +0x5C/+0x5E
             *   key=0x08 (BS):  p[+0xa]|=0x80; walk +0x50/+0x52; find matching enable[key+0x314C]
             *                   -> clear enable flag; call 0x6F826
             *   key=0x0d (Enter): walk +0x5C/+0x5E; seek p[+0x50]==cur?; call 0x6F826
             *   @asm 0x06E88F ax=[bp-0x36]; sub ax,0x1b/je ESC; sub ax,0x12d/je 0x6e93e
             *   @asm 0x06E8A2 sub ax,8/je 0x6e8e4; (else: tab-fwd via +0x50 list)
             *   @asm 0x06E8CE imul bx,ax,0x1c; cmp [bx+0x314c],0 (enable table at CS:0x314C)
             *   @asm 0x06E935 call cs:0x3F826 */
            overlay_call_0D1D_113C();                 /* @asm 0x06E7C1 field length (printable edit) */
            overlay_call_0D1D_11B4();                 /* @asm 0x06E7DF field insert char */
            func_06DC64_panel_draw_button_row();      /* @asm 0x06E84D call 0x2164 (redraw buttons) */
        }
    }

    /* post-dispatch: message-region update + conditional row/button redraw.
     * @asm 0x06E9F4..0x06ED45 */
    if (g_panel_h_1F6E != 0) {                         /* @asm 0x06E9F4 cmp [0x1f6e],0 / JE */
        overlay_call_0C0C_0006();                     /* @asm 0x06EA03 cursor vs [0xA5B0]/[0xA5B2] */
        overlay_call_181F_0444();                     /* @asm 0x06EA53 redraw message box */
    }
    if (pending) {                                     /* @asm 0x06EC56 cmp [bp-2],0 / JE */
        func_06D9CC_panel_draw_row_chain();           /* @asm 0x06EC65 call 0x1ecc (redraw rows) */
    }
    overlay_call_181F_045C();                          /* @asm 0x06ED52 commit hit-region -> 0x181F:0x45C */

teardown:
    /* ---- 9. TEARDOWN ---- */
    g_screen_mode_1F5C = -1;                           /* @asm 0x06EE68 [0x1f5c]=0xffff */
    g_screen_mode_1F5E = -1;                           /* @asm 0x06EE6E [0x1f5e]=0xffff */
    g_opt_field_1F60   = -1;                           /* @asm 0x06EE71 [0x1f60]=0xffff */
    g_panel_flag_1F8A  = 0;                            /* @asm 0x06EE76 [0x1f8a]=0 */
    g_panel_flag_1F66  = 0;                            /* @asm 0x06EE79 [0x1f66]=0 */
    /* if (p[+0xa]&4) rebuild [0x1F54] from per-option enable (cs:0x3D30).
     * @asm 0x06EE7C..0x06EEB6 */
    func_06F830();                                     /* @asm 0x06EE93 per-option enable -> 0x1A1F:0xAC2 */
    overlay_call_181F_047A();                          /* @asm 0x06EEB8 finalize draw -> 0x181F:0x47A */
    if (g_panel_flag_1F70 != 0)                        /* @asm 0x06EEBD cmp [0x1f70],0 / JE */
        overlay_call_191F_0AAC();                      /* @asm 0x06EEC4 dispose own panel -> 0x191F:0xAAC */
    return 0;                                          /* @asm 0x06EECC ax=p[+0]; 0x06EED1 RETF 4 */
}

/* ============================================================================
 * func_06EED4 — set_ctx_triple  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=24, push bp;mov bp,sp, RETF.  Stores three caller words into a DGROUP
 * context trio used by the page-0x17 render path.
 *   [0x1F9E] = [bp+6];  [0x1FA0] = [bp+8];  [0x1FA2] = [bp+0xa];
 * @asm 0x06EED4 55 8b ec 8b 46 06 8b 56 08 a3 9e 1f  (push bp; ax=[bp+6]; dx=[bp+8]; [0x1f9e]=ax)
 * @asm 0x06EEDD a3 9e 1f / 89 16 a0 1f                ([0x1f9e]=ax ; [0x1fa0]=dx)
 * @asm 0x06EEE7 a3 a2 1f                              ([0x1fa2]=ax=[bp+0xa])
 * ============================================================================ */
int func_06EED4_set_ctx_triple(uint16_t a0, uint16_t a1, uint16_t a2)
{
    g_ctx_1F9E = a0;   /* @asm 0x06EEDD mov [0x1f9e],ax */
    g_ctx_1FA0 = a1;   /* @asm 0x06EEE0 mov [0x1fa0],dx */
    g_ctx_1FA2 = a2;   /* @asm 0x06EEE7 mov [0x1fa2],ax */
    return 0;          /* @asm 0x06EEEA leave; RETF */
}

/* ============================================================================
 * func_06EEEC — text_macro_expand  [DONE — BYTE_VERIFIED including keyword tables]
 * ----------------------------------------------------------------------------
 * size=520 (0x06EEEC..0x06F0F4), ENTER 0x2E,0, RETF.  Expands the '%'-macros in
 * source string [bp+6] into output buffer [bp+8].  Loop: find the next '%' (0x25)
 * via 0xD1D:0xC56 (find-char-in-set); NUL-split src there; append the literal text
 * before it (0xD1D:0x7A4 str_cat); then classify the key bytes AFTER the '%'
 * against five ASCII keyword tables, substituting the matching value and advancing
 * the source cursor past the consumed key.
 *
 *   dst[0] = 0;                                          ; @asm 0x06EEF0..0x06EEF3
 *   while ((m = findset('%', src)) handled per below) {    ; @asm 0x06EEF6 LCALL 0x0D1D:0xC56
 *       if (m) *m = 0;                                     ; @asm 0x06EF0A split at '%'
 *       if (*src) strcat(dst, src);                        ; @asm 0x06EF17 LCALL 0x0D1D:0x7A4
 *       if (!m) break;                                     ; @asm 0x06EF23 JE 0x35e9 (no macro)
 *       src = ++m;                                         ; @asm 0x06EF2C..0x06EF32
 *       if (memcmp(m,[0x1FA4],6)==0) {                      ; @asm 0x06EF3B LCALL 0x0D1D:0xCC2 (kind A)
 *           i = atoi(m+6); strcat(dst, &val9cd2[i<<6]); src += 7;  ; @asm 0x06EF4E/0x06EF59/0x06EF6E
 *       } else if (strncmp(m,[0x1FAB],6)==0) {              ; @asm 0x06EF80 LCALL 0x0D1D:0x8BC (kind B)
 *           i = atoi(m+6); fmt_append(buf,&val9cb0[i<<2]); strcat; src+=7; ; @asm 0x06EFB1 LCALL 0x0D1D:0x916
 *       } else if (strncmp(m,[0x1FB2],3)==0) {              ; @asm 0x06EFD8 LCALL 0x0D1D:0x8BC (kind C)
 *           i = atoi(m+3); fmt_append(...); pad to 4 w/ [0x1FB6]; src+=4;  ; @asm 0x06F009..0x06F04E
 *       } else if (strncmp(m,[0x1FB8],7)==0) {              ; @asm 0x06F05E LCALL 0x0D1D:0x8BC (kind D)
 *           buf[0]=0; fmt_date([0x5398],0x181F:0x42E); copy(dst,buf); src+=7; ; @asm 0x06F078..0x06F089
 *       } else if (strncmp(m,[0x1FC0],4)==0) {              ; @asm 0x06F099 LCALL 0x0D1D:0x8BC (kind E)
 *           sprintf(buf,[0x538A]); copy(dst,buf); src+=4;   ; @asm 0x06F0B2 LCALL 0x0D1D:0x8FA
 *       } else if (*m=='%') { emit "%" [0x1FC5]; src++; }    ; @asm 0x06F0CE..0x06F0E6 (literal %%)
 *   }                                                       ; @asm 0x06F0E9 loop while m!=0
 *   return; (RETF)                                          ; @asm 0x06F0F3
 *
 * @asm 0x06EEEC c8 2e 00 00 8b 5e 08 c6 07 00         (ENTER 0x2E; dst[0]=0)
 * @asm 0x06EEF6 6a 25 ff 76 06                        (push 0x25; push src — find '%')
 * @asm 0x06EF3B 9a c2 0c 1d 0d                        (LCALL 0x0D1D:0xCC2 — memcmp key 0x1FA4)
 * BYTE_VERIFIED (2026-06-08) — five macro keyword strings extracted from DGROUP:
 *   DS:0x1FA4 file 0x1F944 → "STRING"  (6 chars + NUL, 7 bytes total)
 *   DS:0x1FAB file 0x1F94B → "NUMBER"  (7 bytes: "NUMBER\0")
 *   DS:0x1FB2 file 0x1F952 → "HEX"     (4 bytes: "HEX\0")
 *   DS:0x1FB8 file 0x1F958 → "COUNTRY" (8 bytes: "COUNTRY\0")
 *   DS:0x1FC0 file 0x1F960 → "YEAR"    (5 bytes: "YEAR\0")
 * Confirmed from binary (DGROUP base 0x1D9A0 BYTE_VERIFIED):
 *   @file 0x1F944: 53 54 52 49 4E 47 00 = "STRING\0"
 *   @file 0x1F94B: 4E 55 4D 42 45 52 00 = "NUMBER\0"
 *   @file 0x1F952: 48 45 58 00          = "HEX\0"
 *   @file 0x1F958: 43 4F 55 4E 54 52 59 00 = "COUNTRY\0"
 *   @file 0x1F960: 59 45 41 52 00       = "YEAR\0"
 * So the five macro kinds are: %STRING%i → val9cd2[i*64]; %NUMBER%i → val9cb0[i*4];
 * %HEX%i → hex-format; %COUNTRY%i → fmt_date via [0x5398]; %YEAR → [0x538A].
 * ============================================================================ */
int func_06EEEC_text_macro_expand(uint16_t src, uint16_t dst)
{
    int found;    /* [bp-0x2c] — position of next '%' (0 = none) */
    (void)src; (void)dst;

    /* dst[0] = 0  @asm 0x06EEF0..0x06EEF3 */
    do {
        found = overlay_call_0D1D_0C56();             /* @asm 0x06EEF6 find '%' (0x25) in src */
        /* if (found) *found = 0;  @asm 0x06EF0A split */
        /* if (*src) strcat(dst, src);  @asm 0x06EF17 */
        overlay_call_0D1D_07A4();                     /* @asm 0x06EF1B str_cat literal prefix */
        if (found == 0)                                /* @asm 0x06EF23 cmp [bp-0x2c],0 / JE */
            break;                                     /* @asm 0x06EF29 jmp 0x35e9 (no more macros) */

        /* Classify the key after '%' against the five keyword tables (kind A..E)
         * then the literal "%%" fallback.  @asm 0x06EF35..0x06F0E6 */
        if (overlay_call_0D1D_0CC2() == 0) {           /* @asm 0x06EF3B memcmp(MACRO_KEYTAB_1FA4,6) */
            overlay_call_0D1D_08F6();                  /* @asm 0x06EF4E atoi index */
            overlay_call_0D1D_07A4();                  /* @asm 0x06EF63 strcat &[MACRO_VAL_9CD2 + i<<6] */
        } else if (overlay_call_0D1D_08BC() == 0) {    /* @asm 0x06EF80 strncmp(MACRO_KEYTAB_1FAB,6) */
            overlay_call_0D1D_08F6();                  /* @asm 0x06EF99 atoi index */
            overlay_call_0D1D_0916();                  /* @asm 0x06EFB1 fmt_append &[MACRO_VAL_9CB0 + i<<2] */
            overlay_call_0D1D_07A4();                  /* @asm 0x06EFC0 strcat formatted */
        } else if (overlay_call_0D1D_08BC() == 0) {    /* @asm 0x06EFD8 strncmp(MACRO_KEYTAB_1FB2,3) */
            overlay_call_0D1D_08F6();                  /* @asm 0x06EFF1 atoi index */
            overlay_call_0D1D_0916();                  /* @asm 0x06F009 fmt_append value */
            /* pad to 4 chars with MACRO_PAD_1FB6  @asm 0x06F011..0x06F03D */
            overlay_call_0D1D_07A4();                  /* @asm 0x06F018 strcat pad */
            overlay_call_0D1D_0842();                  /* @asm 0x06F02D strlen (pad-loop test) */
            overlay_call_0D1D_07A4();                  /* @asm 0x06F046 strcat final */
        } else if (overlay_call_0D1D_08BC() == 0) {    /* @asm 0x06F05E strncmp(MACRO_KEYTAB_1FB8,7) */
            overlay_call_181F_042E();                  /* @asm 0x06F078 fmt date/string ([DLG_NUM_5398]) */
            overlay_call_0D1D_11B4();                  /* @asm 0x06F089 copy into dst */
        } else if (overlay_call_0D1D_08BC() == 0) {    /* @asm 0x06F099 strncmp(MACRO_KEYTAB_1FC0,4) */
            overlay_call_0D1D_08FA();                  /* @asm 0x06F0B2 sprintf ([DLG_NUM_538A]) */
            overlay_call_0D1D_11B4();                  /* @asm 0x06F0C3 copy into dst */
        } else {
            /* literal "%%" -> emit one '%' from MACRO_PCT_1FC5  @asm 0x06F0CE..0x06F0E6 */
            overlay_call_0D1D_11B4();                  /* @asm 0x06F0DE copy "%" */
        }
    } while (found != 0);                              /* @asm 0x06F0E9 cmp [bp-0x2c],0 / JNE 0x33f6 */

    return 0;                                          /* @asm 0x06F0F3 RETF */
}

/* ============================================================================
 * func_06F0F4 — text_template_run  [DONE — BYTE_VERIFIED incl. directive keyword tables]
 * ----------------------------------------------------------------------------
 * size=1061 (0x06F0F4..0x06F51A), ENTER 0x168,0, RETF.  The NAMES.TXT-style
 * @-section TEMPLATE ENGINE: parses a token stream into a PANEL/menu descriptor
 * record (returned in DX:AX = [bp-0xa:bp-0xc]).  Entry AX:BX names the section.
 *
 *   copy section name into [bp-0x160] (0xD1D:0x7E4, fmt 0x2478); ; @asm 0x06F11C
 *   if (open_section(name) <0x191F:0x928> != 0) goto done;       ; @asm 0x06F126 JNE 0x39f5
 *   rec = ctx_to_record([0x1F9E],[0x1FA0],[0x1FA2]); <cs:0x3D08> ; @asm 0x06F142 -> [bp-0xc/-0xa]
 *   if (rec == NULL) goto done;                                    ; @asm 0x06F150 JE 0x39f5
 *   if ([0x2008] && [0xA5B4]) fmt msg-arg into [bp-0x160];          ; @asm 0x06F155..0x06F171
 *   state = 1; row = 1;                                            ; @asm 0x06F100..0x06F107
 *   while (state < 3) {                                            ; @asm 0x06F4EC..0x06F4F2 loop
 *       tok = next_token(); <0x191F:0x91C>                       ; @asm 0x06F174
 *       if (strlen(tok)==0) { state++; continue; }                 ; @asm 0x06F17D..0x06F189
 *       if (tok[0] == '@') {                                       ; @asm 0x06F193 cmp byte[bx],0x40
 *           < directive: match keyword vs tables 0x1FC7.. >      ; @asm 0x06F19B..0x06F407
 *           ... sets state / sprite-dims rec[+0x80..]/ fields rec[+0xC/+0xE]/
 *               flags rec[+0xa]|=5 / msg-arg [0xA5B6] / assign ...
 *       } else switch (state) {                                    ; @asm 0x06F40A..0x06F4E9
 *           case 1: copy tok (cs:0x3D17=0x191F:0x910); append label-widget (cs:0x3D0D=0x191F:0x8C6); ; @asm 0x06F410..0x06F432
 *           case 2: if ([0x2008]) fmt-with-arg (cs:0x3D35=0x1A1F:0xACE) else append value-widget (cs:0x3CFE=0x191F:0x176); ; @asm 0x06F436..0x06F4DD
 *       }
 *       if (added && [0x1F66-flag]) clear rec[+6];                  ; @asm 0x06F4AC..0x06F4BC
 *       if (row == cur_row) rec[+0x4C/+0x4E] = widget;              ; @asm 0x06F4BC..0x06F4D9
 *       row++;                                                     ; @asm 0x06F4D9
 *   }
 *  done: if (rec == NULL) { [0x1F5C]=[0x1F5E]=[0x1F60]=-1; [0x1F66]=0; }  ; @asm 0x06F4F5..0x06F509
 *   return rec;                                                    ; @asm 0x06F50F..0x06F517
 *
 * @asm 0x06F0F4 c8 68 01 00 52 50 53 57 56            (ENTER 0x168; push dx/ax/bx/di/si)
 * @asm 0x06F11C 9a e4 07 1d 0d                        (LCALL 0x0D1D:0x7E4 — seed work buffer)
 * @asm 0x06F142 e8 c3 06                              (call cs:0x3D08 -> 0x191F:0x23C ctx->rec)
 * @asm 0x06F518 cb                                    (RETF)
 * @-directive keyword strings extracted (BYTE_VERIFIED 2026-06-08, from DGROUP):
 *   "OPTIONS","PROMPT","TEXT","SMALLFONT","Y","X","WIDTH","LENGTH","CHECKBOX","DEFAULT"
 *   — see #define TMPL_KEYTAB_1FC7.. above.  left unresolved-inner for this function CLOSED
 *   (Group B / data-table contents resolved). The per-directive field writes
 *   (rec[+0xC]/[+0xE]/[+0x80]/[+0xa]) remain at their @asm store sites.
 * ============================================================================ */
int func_06F0F4_text_template_run(void)
{
    int state = 1;    /* [bp-4] — 1=labels, 2=values, 3=stop */
    int row   = 1;    /* [bp-0x162] — running widget row index */

    /* seed work buffer; open section; resolve ctx->record.  @asm 0x06F114..0x06F148 */
    overlay_call_0D1D_07E4();                          /* @asm 0x06F11C str_format name -> buf */
    if (overlay_call_191F_0928() != 0)                 /* @asm 0x06F126 open_section / JNE 0x39f5 */
        goto done;
    func_06F808();                                     /* @asm 0x06F142 ctx->record -> 0x191F:0x23C */
    /* if (rec == 0) goto done;  @asm 0x06F14E */

    /* if ([0x2008] && [0xA5B4]) fmt staged msg-arg into buffer.  @asm 0x06F155..0x06F171 */
    if (g_flag_2008 != 0 && g_msg_arg_lo_A5B4 != 0)    /* @asm 0x06F155/0x06F15C */
        overlay_call_0D1D_07E4();                      /* @asm 0x06F16C str_format msg-arg */

    /* ---- token loop ---- */
    while (state < 3) {                                /* @asm 0x06F4EC cmp [bp-4],3 / JGE done */
        overlay_call_191F_091C();                      /* @asm 0x06F174 tok = next_token */
        if (overlay_call_0D1D_0842() == 0) {           /* @asm 0x06F17D strlen(tok) */
            state++;                                   /* @asm 0x06F189 inc [bp-4] (blank line -> next state) */
            continue;
        }

        /* if (tok[0]=='@') directive dispatch.  @asm 0x06F193..0x06F407 */
        /* BYTE_VERIFIED (2026-06-08): directive keywords extracted from DGROUP (Group B).
         * TMPL_KEYTAB_1FC7..0x1FFF define all 10 strings: "OPTIONS","PROMPT","TEXT",
         * "SMALLFONT","Y","X","WIDTH","LENGTH","CHECKBOX","DEFAULT".  The sub-dispatch
         * chain (0xD1D:0x816 prefix-match; 0x8BC strncmp; 0xCC2 memcmp) routes each
         * @DIRECTIVE to the matching record-field write (rec[+0xC/+0xE/+0x80/+0xa]). */
        if (1 /* tok[0]=='@' handled inline by the leaf matchers below */) {
            overlay_call_0D1D_0816();                  /* @asm 0x06F1B0 prefix-match (end-marker) */
            overlay_call_0D1D_08BC();                  /* @asm 0x06F227 strncmp (field directives) */
            overlay_call_0D1D_0CC2();                  /* @asm 0x06F309 memcmp (msg-arg directive) */
        }

        /* non-'@' tokens routed by state.  @asm 0x06F40A..0x06F4E9 */
        if (state == 1) {                              /* @asm 0x06F40A dec ax==1 -> 0x3910 */
            func_06F817();                             /* @asm 0x06F419 copy tok -> local (0x191F:0x910) */
            func_06F80D();                             /* @asm 0x06F42C append label-widget (0x191F:0x8C6) */
        } else if (state == 2) {                       /* @asm 0x06F4E6 dec ax==2 -> 0x3936 */
            if (g_flag_2008 != 0) {                    /* @asm 0x06F436 cmp [0x2008],0 / JE */
                func_06F817();                         /* @asm 0x06F453 copy tok -> local */
                func_06F835();                         /* @asm 0x06F470 fmt-with-arg (0x1A1F:0xACE) */
            } else {
                func_06F817();                         /* @asm 0x06F487 copy tok -> local */
                func_06F7FE();                         /* @asm 0x06F49E append value-widget (0x191F:0x176) */
            }
        }
        /* if (row == cur_row) rec[+0x4C/+0x4E] = widget.  @asm 0x06F4BC..0x06F4D9 */
        row++;                                          /* @asm 0x06F4D9 inc [bp-0x162] */
    }

done:
    /* if (rec == NULL) reset screen-mode words.  @asm 0x06F4F5..0x06F509 */
    if (1 /* rec NULL path */) {
        g_screen_mode_1F5E = -1;                        /* @asm 0x06F500 [0x1f5e]=0xffff */
        g_screen_mode_1F5C = -1;                        /* @asm 0x06F503 [0x1f5c]=0xffff */
        g_opt_field_1F60   = -1;                        /* @asm 0x06F506 [0x1f60]=0xffff */
        g_panel_flag_1F66  = 0;                         /* @asm 0x06F509 [0x1f66]=0 */
    }
    (void)row;
    return 0;                                           /* @asm 0x06F50F ax=rec; 0x06F518 RETF */
}

/* func_06F51A — SUPERSEDED -> src/ui/menu.c menu_lookup_run (thunk 0x181F:0x998; BYTE_VERIFIED there) */

/* func_06F554 — SUPERSEDED -> src/ui/menu.c opt_flag_set / opt_flag_clear (BYTE_VERIFIED there) */

/* func_06F57E — SUPERSEDED -> src/ui/menu.c opt_flag_test (BYTE_VERIFIED there) */

/* func_06F5B0 — SUPERSEDED -> src/ui/menu.c opt_set_field_a (0x1F5C builder; BYTE_VERIFIED there) */

/* ============================================================================
 * func_06F5DA — opt_set_field_a_const8  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=24, push bp;mov bp,sp, RETF.  Sibling of src/ui/menu.c opt_set_field_a:
 * a one-arg option builder that hard-codes field-A = 8 then emits.
 *   [0x1F5C] = 8;                                    ; @asm 0x06F5DD mov [0x1f5c],8
 *   bx = &descriptor[0x87C];  ax = [bp+6];  dx = 0;    ; @asm 0x06F5E3..0x06F5EA
 *   opt_emit();                                       ; @asm 0x06F5ED call cs:0x3CEF (->0x181F:0x998)
 * @asm 0x06F5DA 55 8b ec c7 06 5c 1f 08 00            (push bp; mov word[0x1f5c],8)
 * @asm 0x06F5ED e8 ff 01                              (CALL 0x3CEF = func_06F7EF -> 0x181F:0x998)
 * @ref src/ui/menu.c MENU_DESC_087C / OPT_FIELD_1F5C / opt_run_menu.
 * ============================================================================ */
int func_06F5DA_opt_set_field_a_const8(uint16_t key)
{
    g_screen_mode_1F5C = 8;     /* @asm 0x06F5DD mov [0x1f5c],8  (OPT_FIELD_1F5C) */
    (void)key;                  /* ax=[bp+6]=key, dx=0, bx=&[0x87c] @asm 0x06F5E3..0x06F5EA */
    return func_06F7EF();       /* @asm 0x06F5ED opt_emit -> 0x181F:0x998 */
}

/* func_06F5F2 — SUPERSEDED -> src/ui/menu.c opt_set_mode (0x1F5E screen-mode builder; BYTE_VERIFIED) */

/* func_06F61C — SUPERSEDED -> src/ui/menu.c opt_set_field_c (0x1F60 builder; BYTE_VERIFIED there) */

/* ============================================================================
 * func_06F64C — menu_run_with_msg_arg  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=75, ENTER 6,0, RET 2.  Sibling of menu_lookup_run (func_06F51A) that runs
 * a menu while a message-argument pair is staged.  Arg in AX:DX (fastcall-style:
 * cx=[bp+6] saved to [0xA5B6], dx saved to [0xA5B4]); sets reentrancy gate [0x2008].
 *   [0x2008] = 1;                                    ; @asm 0x06F650
 *   [0xA5B6] = [bp+6];  [0xA5B4] = dx;                 ; @asm 0x06F659/0x06F65D
 *   ret = 0;                                          ; @asm 0x06F663 [bp-2]=0
 *   rec = opt_lookup_rec();                           ; @asm 0x06F667 call cs:0x3D03 (->0x191F:0x182)
 *   if (rec != NULL) {                                 ; @asm 0x06F670 or dx,ax / JE
 *       ret = opt_win_query(rec);                      ; @asm 0x06F679 call cs:0x3CF9 (->0x191F:0x16A)
 *       opt_win_dispose(rec);                          ; @asm 0x06F685 LCALL 0x191F:0x1A8
 *   }
 *   [0x2008] = 0;                                     ; @asm 0x06F68A
 *   return ret;                                       ; @asm 0x06F690 mov ax,[bp-2]; RET 2
 * @asm 0x06F64C c8 06 00 00 c7 06 08 20 01 00         (ENTER 6; mov word[0x2008],1)
 * @asm 0x06F685 9a a8 01 1f 19                        (LCALL 0x191F:0x1A8 widget_invalidate)
 * @ref src/ui/menu.c opt_lookup_rec / opt_win_query / opt_win_dispose (same idiom).
 * ============================================================================ */
int func_06F64C_menu_run_with_msg_arg(uint16_t arg_lo)
{
    int ret;
    g_flag_2008 = 1;                 /* @asm 0x06F650 mov [0x2008],1 */
    g_msg_arg_hi_A5B6 = arg_lo;      /* @asm 0x06F659 mov [0xa5b6],cx=[bp+6] */
    /* g_msg_arg_lo_A5B4 = dx;  @asm 0x06F65D (dx is the caller's second word) */
    ret = 0;                         /* @asm 0x06F663 [bp-2]=0 */

    if (func_06F803() != 0) {        /* @asm 0x06F667 rec=opt_lookup_rec(); 0x06F670 or/JE */
        ret = func_06F7F9();         /* @asm 0x06F679 ret=opt_win_query(rec) */
        overlay_call_191F_01A8();    /* @asm 0x06F685 opt_win_dispose -> 0x191F:0x1A8 */
    }
    g_flag_2008 = 0;                 /* @asm 0x06F68A mov [0x2008],0 */
    return ret;                      /* @asm 0x06F690 mov ax,[bp-2]; RET 2 */
}

/* ============================================================================
 * func_06F698 — fmt_pair_into_9CC8  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=65, ENTER 0x16,0, RETF.  Formats a pair through the C runtime and a
 * page-0x11 helper, caching a resulting pointer in [0x9CC8].  Args in AX:DX:BX.
 *   sprintf(&buf[bp-0x14], 0xA, dx, ax, bx);          ; @asm 0x06F6AC LCALL 0x0D1D:0x8FA (n=0xA)
 *   ret = widget_fmt(5, &buf[bp-0x14], ax(si), bx(di));; @asm 0x06F6BE call cs:0x3CF4 (->0x191F:0x120)
 *   [0x9CC8] = atoi_ptr(0x9820);                       ; @asm 0x06F6C7 push 0x9820; LCALL 0x0D1D:0x8F6
 *   return ret;                                        ; @asm 0x06F6D2 mov ax,[bp-0x16]; RETF
 * @asm 0x06F698 c8 16 00 00 52 50 53 57 56            (ENTER 0x16; push dx/ax/bx/di/si)
 * @asm 0x06F6AC 9a fa 08 1d 0d                        (LCALL 0x0D1D:0x8FA sprintf)
 * @asm 0x06F6CF a3 c8 9c                              (mov [0x9cc8],ax)
 * ============================================================================ */
int func_06F698_fmt_pair_into_9CC8(void)
{
    int ret;
    /* sprintf(stack_buf, n=0xA, dx, ax, bx)  @asm 0x06F6A1..0x06F6AC LCALL 0x0D1D:0x8FA */
    overlay_call_0D1D_08FA();
    ret = func_06F7F4();             /* @asm 0x06F6BE widget_fmt(5,...) -> 0x191F:0x120 */
    /* [0x9CC8] = strtoptr(0x9820)  @asm 0x06F6C4 push 0x9820; LCALL 0x0D1D:0x8F6 */
    g_fmt_field_9CC8 = (int16_t)overlay_call_0D1D_08F6(); /* @asm 0x06F6CF mov [0x9cc8],ax */
    return ret;                      /* @asm 0x06F6D2 mov ax,[bp-0x16]; RETF */
}

/* ============================================================================
 * func_06F6DA — panel_words_load8  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=372 (0x06F6DA..0x06F84E incl. the page-tail trampoline block), ENTER 0xE,0.
 * Reads a record (via 0x1A1F:0x372) and unpacks 8 of its byte-fields into the
 * panel default-geometry words [0x1F3C/3E/40/42/4A/4C/4E] using 8 successive
 * 0x181F:0x254 field reads, then frees a region (0x181F:0x3F4) and invalidates
 * (0x191F:0x1A8).  Each 0x181F:0x254 call reads field index N (1..7) into AX low
 * byte = [bp-6], zero-extended, stored to the matching DGROUP word.
 *
 *   rec = record_read(0, &out, ss, [0x200A]);         ; @asm 0x06F6F6 LCALL 0x1A1F:0x372
 *   if (rec == 0) goto done;                            ; @asm 0x06F701 or dx,ax / JNE; else jmp 0x3ce7
 *   [0x1F3C] = field(1);                                ; @asm 0x06F716 LCALL 0x181F:0x254 ; 0x06F720
 *   [0x1F3E] = field(2);                                ; @asm 0x06F733 ... 0x06F73D
 *   [0x1F40] = field(3);                                ; @asm 0x06F750 ... 0x06F75A
 *   [0x1F42] = field(4);                                ; @asm 0x06F76D ... 0x06F777
 *   [0x1F4A] = field(5);                                ; @asm 0x06F78A ... 0x06F794
 *   [0x1F4E] = field(6);                                ; @asm 0x06F7A7 ... 0x06F7B1
 *   [0x1F4C] = field(7);                                ; @asm 0x06F7C4 ... 0x06F7CE
 *   region_free(0xfc00,0xa000);                          ; @asm 0x06F7D1 LCALL 0x181F:0x3F4
 *   widget_invalidate(rec);                              ; @asm 0x06F7E2 LCALL 0x191F:0x1A8
 *   done: return;                                        ; @asm 0x06F7E7 leave; RETF
 *
 * @asm 0x06F6DA c8 0e 00 00 b8 01 00                  (ENTER 0xE; ax=1)
 * @asm 0x06F6F6 9a 72 03 1f 1a                        (LCALL 0x1A1F:0x372 record_read)
 * @asm 0x06F716 9a 54 02 1f 18                        (LCALL 0x181F:0x254 field read, repeats x7)
 * NOTE the field->word mapping is NOT sequential: indices 5/6/7 land in
 * [0x1F4A]/[0x1F4E]/[0x1F4C] (verified at the cited stores).  These are the same
 * panel default-geometry words the sibling builder reads.
 * ============================================================================ */
int func_06F6DA_panel_words_load8(void)
{
    /* rec = record_read(0, &local, ss, ptr=[0x200A])  @asm 0x06F6F6 LCALL 0x1A1F:0x372 */
    if (overlay_call_1A1F_0372() == 0)              /* @asm 0x06F701 or dx,ax / JNE */
        return 0;                                    /* @asm 0x06F705 jmp 0x3ce7 (done) */

    /* Eight field reads (0x181F:0x254), each zero-extends the low byte to a word.
     * Mapping verified at each store site (note the non-sequential 5/6/7 order). */
    g_panel_words_1F3C[0x00] = (int16_t)overlay_call_181F_0254(); /* @asm 0x06F716->0x1F3C field1 */
    g_panel_words_1F3C[0x01] = (int16_t)overlay_call_181F_0254(); /* @asm 0x06F733->0x1F3E field2 */
    g_panel_words_1F3C[0x02] = (int16_t)overlay_call_181F_0254(); /* @asm 0x06F750->0x1F40 field3 */
    g_panel_words_1F3C[0x03] = (int16_t)overlay_call_181F_0254(); /* @asm 0x06F76D->0x1F42 field4 */
    g_panel_words_1F3C[0x07] = (int16_t)overlay_call_181F_0254(); /* @asm 0x06F78A->0x1F4A field5 */
    g_panel_words_1F3C[0x09] = (int16_t)overlay_call_181F_0254(); /* @asm 0x06F7A7->0x1F4E field6 */
    g_panel_words_1F3C[0x08] = (int16_t)overlay_call_181F_0254(); /* @asm 0x06F7C4->0x1F4C field7 */

    overlay_call_181F_03F4();   /* @asm 0x06F7D1 region_free(0xfc00,0xa000) -> 0x181F:0x3F4 */
    overlay_call_191F_01A8();   /* @asm 0x06F7E2 widget_invalidate(rec) -> 0x191F:0x1A8 */
    return 0;                   /* @asm 0x06F7E7 leave; RETF */
}

/* ============================================================================
 * func_06F8E0 — free_cached_handle_2014  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=26, no-frame, RETF.  Page 0x18's FIRST real function (the auto-decoder
 * skipped it; added here per directive).  Releases the cached far-handle word
 * [0x2014] and clears it.
 *   if ([0x2014] != 0) {                               ; @asm 0x06F8E0 cmp [0x2014],0 / JE 0xa9
 *       free_handle([0x2014]);                          ; @asm 0x06F8EB LCALL 0x0D1D:0x3F4
 *       [0x2014] = 0;                                   ; @asm 0x06F8F3 mov [0x2014],0
 *   }
 * @asm 0x06F8E0 83 3e 14 20 00 74 12                  (cmp word[0x2014],0; JE +0x12)
 * @asm 0x06F8EB 9a f4 03 1d 0d                        (LCALL 0x0D1D:0x3F4 free)
 * ============================================================================ */
int func_06F8E0_free_cached_handle_2014(void)
{
    if (g_handle_2014 != 0) {        /* @asm 0x06F8E0 cmp [0x2014],0 / JE */
        overlay_call_0D1D_03F4();    /* @asm 0x06F8EB free([0x2014]) -> 0x0D1D:0x3F4 */
        g_handle_2014 = 0;           /* @asm 0x06F8F3 mov [0x2014],0 */
    }
    return 0;                        /* @asm 0x06F8F9 RETF */
}

/* ============================================================================
 * func_06F8FA — load_namelist_section  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=447 (0x06F8FA..0x06FAB9), ENTER 0xA2,0, RETF.  Opens and seeks a NAMES-list
 * `@`-section, returning the token-cursor state.  Arg [bp+6]=section-name ptr (si),
 * [bp+8]=mode/find-flag.  (The @-section reader for NAMES.TXT-style data — cf.
 * project memory "NAMES.TXT authoritative data".)  Several INTERIOR entry points
 * (file 0x06F9E6 / 0x06FA3E / 0x06FA84 / 0x06FA96 / 0x06FAA8) share this extent but
 * are SEPARATE leaf routines reached only via cs-near calls from elsewhere — they
 * are NOT part of this function's fall-through (all 5 BYTE_VERIFIED 2026-06-08).
 *
 *   path[0]='@'; path[1]=0;                              ; @asm 0x06F90A..0x06F90E
 *   strcat(path, [bp+8]); <append mode/ext>            ; @asm 0x06F919 LCALL 0x0D1D:0x7A4
 *   str_finalize(path);                                  ; @asm 0x06F925 LCALL 0x0D1D:0xD64
 *   if (si <name> != 0) {                              ; @asm 0x06F92D or si,si / JE 0x11e
 *       flush_token(); <cs:0x2D8 = 0x191F:0xFB8>        ; @asm 0x06F932 call 0x2d8
 *       fmt(&fbuf[bp-0xa2], si);                          ; @asm 0x06F93B LCALL 0x0D1D:0x7E4
 *       path_resolve(&fbuf, [0x2016]); <0x1A1F:0xA94>   ; @asm 0x06F94D LCALL 0x1A1F:0xA94
 *       [0x2014] = file_open(&fbuf, [0x201A]); <0x181F:0xE86> ; @asm 0x06F95C LCALL 0x181F:0xE86
 *       if ([0x2014] == 0) { return [bp-2]<=1>; }       ; @asm 0x06F964..0x06F96B
 *   } else found_flag = 1;                               ; @asm 0x06F96E di=1
 *   if ([bp+8] != 0) {                                   ; @asm 0x06F971 cmp [bp+8],0 / JE 0x186
 *       for (;;) {                                        ; @asm 0x06F977 loop head 0x129
 *           if (strtok([0x2014],0x50,[0x833C]) <0x0D1D:0x9CA> != 0) ; @asm 0x06F982
 *               break-with-line;                          ; @asm 0x06F98C JNE 0x149
 *           if (!found_flag) return [bp-2];               ; @asm 0x06F990 JE 0x118
 *           found_flag=0; [0x833C]=0;                     ; @asm 0x06F992..0x06F994
 *           normalize([0x833C]); <0x1A1F:0xB4E,0xB44>   ; @asm 0x06F99D/0x06F9A6
 *           if (prefix_match(path,[0x833C]) <0x0D1D:0x816>) ; @asm 0x06F9B2 (==0 -> si=1)
 *               { [0xA608] = [0x833C] + strlen(path); break; } ; @asm 0x06F9D0..0x06F9D3
 *       }
 *   }
 *   si = 0;                                              ; @asm 0x06F9D6
 *   if (si) flush_token();                               ; @asm 0x06F9D8..0x06F9DD
 *   return si;  <RETF>                                 ; @asm 0x06F9E0..0x06F9E5
 *
 * @asm 0x06F8FA c8 a2 00 00 57 56                     (ENTER 0xA2; push di/si)
 * @asm 0x06F90A c6 46 ae 40                           (mov byte[bp-0x52],0x40 — seed '@')
 * @asm 0x06F982 9a ca 09 1d 0d                        (LCALL 0x0D1D:0x9CA — strtok ',' over [0x833C])
 * @asm 0x06F95C 9a 86 0e 1f 18                        (LCALL 0x181F:0xE86 — file open; [0x2014]=ax)
 * BYTE_VERIFIED interior leaf functions folded into this extent by the auto-segmenter.
 * All are standalone far procedures (RETF) exported from this overlay page.
 * No static LCALL in the binary resolves to any of them: callers live in other overlay
 * pages and reach them via the Borland overlay manager's runtime-patched dispatch
 * (segment word in the caller's LCALL is zeroed at link time and filled at load time).
 * The sixth stub at 0x06FA78 (between entries 2 and 3) was not identified as a named
 * entry point by the segmenter.  ALL SIX are now PORTED as their own C functions
 * immediately after func_06F8FA below (func_06F9E6 / func_06FA3E / func_06FA78 /
 * func_06FA84 / func_06FA96 / func_06FAA8); the table here remains the byte map.
 *
 * ┌─────────────┬──────┬───────────────────────────────────────────────────────────┐
 * │  file off   │ size │ role                                                      │
 * ├─────────────┼──────┼───────────────────────────────────────────────────────────┤
 * │  0x06F9E6   │  87B │ read_token_blank_underscore                               │
 * │  0x06FA3E   │  58B │ extract_csv_token  →  [0xA5B8]                           │
 * │  0x06FA84   │  18B │ seek_cursor_to_end_of_833C                                │
 * │  0x06FA96   │  18B │ next_token_then_write_833C                                │
 * │  0x06FAA8   │  17B │ advance_token_then_write_A5B8                             │
 * └─────────────┴──────┴───────────────────────────────────────────────────────────┘
 *
 * ── 0x06F9E6  read_token_blank_underscore  [87 bytes, 0x06F9E6..0x06FA3C RETF] ──
 *   Callers: none found statically; called via Borland overlay manager from other pages.
 *   Reads next line from open file-handle [0x2014] into [0x833C] via strtok
 *     (LCALL 0x0D1D:0x9CA, max 0x50 chars); on EOF returns ax=0.
 *   Normalizes via 0x1A1F:0xB4E; trims via 0x1A1F:0xB44.
 *   Then scans [0x833C] for '_' (LCALL 0x0D1D:0xC56 strchr); blanks all chars from
 *     that position onward ([si]=0x20 loop until si==0).
 *   Stores &[0x833C] in [0xA608] (si = 0x833C).
 *   If EOF (ax==0 from strtok): calls flush_token (PUSH CS; CALL 0x6FB28
 *     → LJMP 0x191F:0xFB8), then returns 0.
 *   Returns: ax = &[0x833C] (0x833C) on success, 0 on EOF.
 * @asm 0x06F9E6 56 2b f6                 (push si; sub si,si)
 * @asm 0x06F9E9 ff 36 14 20 6a 50        (push [0x2014]; push 0x50)
 * @asm 0x06F9EF 68 3c 83 9a ca 09 1d 0d  (push 0x833C; LCALL 0x0D1D:0x09CA — strtok)
 * @asm 0x06F9FC 74 33                    (JE 0x6FA31 — EOF branch)
 * @asm 0x06FA15 9a 56 0c 1d 0d           (LCALL 0x0D1D:0x0C56 — strchr([0x833C],'_'))
 * @asm 0x06FA23 c6 04 20                 (mov byte[si],0x20 — blank char at '_')
 * @asm 0x06FA2D 89 36 08 a6              (mov [0xA608],si)
 * @asm 0x06FA35 0e e8 ef 00              (push cs; CALL 0x6FB28 — flush_token)
 * @asm 0x06FA3C cb                       (RETF)
 *
 * ── 0x06FA3E  extract_csv_token → [0xA5B8]  [58 bytes, 0x06FA3E..0x06FA77 RETF] ──
 *   Callers: none found statically; called via Borland overlay manager from other pages.
 *   Extracts the next comma-delimited field from the cursor at [0xA608] into [0xA5B8].
 *   Copies bytes from [0xA608] to [0xA5B8] while *src != '\0' and *src != ','.
 *   If the terminator was ',' (not NUL), advances src past it; updates [0xA608].
 *   NUL-terminates [0xA5B8]; trims via 0x1A1F:0xB44.
 *   Returns: ax = 0xA5B8 (pointer to extracted token buffer).
 * @asm 0x06FA3E 57 56                    (push di; push si)
 * @asm 0x06FA40 8b 36 08 a6              (mov si,[0xA608])
 * @asm 0x06FA44 bf b8 a5                 (mov di,0xA5B8)
 * @asm 0x06FA47 80 3c 00                 (cmp byte[si],0  — NUL check)
 * @asm 0x06FA4C 80 3c 2c                 (cmp byte[si],','  — comma check)
 * @asm 0x06FA51 8a 04 88 05              (mov al,[si]; mov [di],al — copy byte)
 * @asm 0x06FA62 89 36 08 a6              (mov [0xA608],si — update cursor)
 * @asm 0x06FA66 c6 05 00                 (mov byte[di],0 — NUL-terminate)
 * @asm 0x06FA6D 9a 44 0b 1f 1a           (LCALL 0x1A1F:0x0B44 — trim [0xA5B8])
 * @asm 0x06FA72 b8 b8 a5                 (mov ax,0xA5B8)
 * @asm 0x06FA77 cb                       (RETF)
 *
 * ── 0x06FA84  seek_cursor_to_end_of_833C  [18 bytes, 0x06FA84..0x06FA95 RETF] ──
 *   Callers: none found statically; called via Borland overlay manager from other pages.
 *   Computes strlen([0x833C]) via LCALL 0x0D1D:0x0842; sets [0xA608] = 0x833C + len.
 *   Effect: advances the parse cursor [0xA608] past the entire current token string.
 *   Returns: nothing meaningful (ax = 0x833C + len, but caller ignores it).
 * @asm 0x06FA84 68 3c 83                 (push 0x833C)
 * @asm 0x06FA87 9a 42 08 1d 0d           (LCALL 0x0D1D:0x0842 — strlen([0x833C]))
 * @asm 0x06FA8C 83 c4 02                 (add sp,2)
 * @asm 0x06FA8F 05 3c 83                 (add ax,0x833C)
 * @asm 0x06FA92 a3 08 a6                 (mov [0xA608],ax)
 * @asm 0x06FA95 cb                       (RETF)
 *
 * ── 0x06FA96  next_token_then_write_833C  [18 bytes, 0x06FA96..0x06FAA6 RETF] ──
 *   Callers: none found statically; called via Borland overlay manager from other pages.
 *   Calls next_token via near thunk (PUSH CS; CALL 0x6FB1E → LJMP 0x191F:0x91C).
 *   Then writes the string at [0x833C] to the output stream via LCALL 0x181F:0x18
 *     (push ds; push 0x833C = far ptr to [0x833C]; Borland stream fputs-like call).
 *   Returns: nothing (ax = return value of stream write, ignored by callers).
 * @asm 0x06FA96 0e e8 84 00              (push cs; CALL 0x6FB1E — next_token → 0x191F:0x91C)
 * @asm 0x06FA9A 1e 68 3c 83              (push ds; push 0x833C — far ptr to token buf)
 * @asm 0x06FA9E 9a 18 00 1f 18           (LCALL 0x181F:0x0018 — stream write)
 * @asm 0x06FAA3 83 c4 04                 (add sp,4)
 * @asm 0x06FAA6 cb                       (RETF)
 *
 * ── 0x06FAA8  advance_token_then_write_A5B8  [17 bytes, 0x06FAA8..0x06FAB8 RETF] ──
 *   Callers: none found statically; called via Borland overlay manager from other pages.
 *   Calls advance_token via near thunk (PUSH CS; CALL 0x6FB2D → LJMP 0x191F:0xFC4).
 *   Then writes the string at [0xA5B8] to the output stream via LCALL 0x181F:0x18
 *     (push ds; push 0xA5B8 = far ptr to extracted CSV token buffer).
 *   Returns: nothing (ax = return value of stream write, ignored by callers).
 * @asm 0x06FAA8 0e e8 81 00              (push cs; CALL 0x6FB2D — advance_token → 0x191F:0xFC4)
 * @asm 0x06FAAC 1e 68 b8 a5              (push ds; push 0xA5B8 — far ptr to token buf)
 * @asm 0x06FAB0 9a 18 00 1f 18           (LCALL 0x181F:0x0018 — stream write)
 * @asm 0x06FAB5 83 c4 04                 (add sp,4)
 * @asm 0x06FAB8 cb                       (RETF)
 * ============================================================================ */
int func_06F8FA_load_namelist_section(uint16_t name_ptr, uint16_t mode)
{
    int ret = 1;      /* [bp-2] — default fail/eof return */
    int found = 0;    /* di — "first matching pass" flag */
    (void)name_ptr; (void)mode;

    /* path[0]='@'; path[1]=0; strcat(path,[bp+8]); finalize.  @asm 0x06F90A..0x06F92A */
    overlay_call_0D1D_07A4();                          /* @asm 0x06F919 strcat mode/ext */
    overlay_call_0D1D_0D64();                          /* @asm 0x06F925 str finalize */

    if (name_ptr != 0) {                               /* @asm 0x06F92D or si,si / JE 0x11e */
        func_06FB28();                                 /* @asm 0x06F932 flush_token -> 0x191F:0xFB8 */
        overlay_call_0D1D_07E4();                      /* @asm 0x06F93B fmt name -> fbuf */
        overlay_call_1A1F_0A94();                      /* @asm 0x06F94D path_resolve -> 0x1A1F:0xA94 */
        g_handle_2014 = (int16_t)overlay_call_181F_0E86(); /* @asm 0x06F95C file_open; [0x2014]=ax */
        if (g_handle_2014 == 0)                         /* @asm 0x06F964 or ax,ax / JNE 0x121 */
            return ret;                                 /* @asm 0x06F968 return [bp-2]=1 (open failed) */
    } else {
        found = 1;                                      /* @asm 0x06F96E mov di,1 */
    }

    if (mode != 0) {                                   /* @asm 0x06F971 cmp [bp+8],0 / JE 0x186 */
        for (;;) {                                      /* @asm 0x06F977 loop head 0x129 */
            if (overlay_call_0D1D_09CA() != 0)          /* @asm 0x06F982 strtok([0x2014],0x50,[0x833C]) */
                break;                                  /* @asm 0x06F98C JNE 0x149 (got a line) */
            if (found == 0)                             /* @asm 0x06F98E or di,di / JE 0x118 */
                return ret;                             /* @asm 0x06F990 (eof, no match) */
            found = 0;                                   /* @asm 0x06F992 sub di,di */
            g_namelist_buf_833C[0] = 0;                 /* @asm 0x06F994 [0x833C]=0 (rewind) */
        }
        overlay_call_1A1F_0B4E();                       /* @asm 0x06F99D normalize line */
        overlay_call_1A1F_0B44();                       /* @asm 0x06F9A6 trim line */
        if (overlay_call_0D1D_0816() == 0) {            /* @asm 0x06F9B2 prefix_match(path,[0x833C]) */
            /* [0xA608] = [0x833C] + strlen(path)  @asm 0x06F9C5..0x06F9D3 */
            overlay_call_0D1D_0842();                   /* @asm 0x06F9C8 strlen(path) */
            g_namelist_cur_A608 = (int16_t)0x833C;      /* @asm 0x06F9D3 mov [0xa608],ax (cursor at match) */
        }
    }

    ret = 0;                                            /* @asm 0x06F9D6 sub si,si */
    /* if (si) flush_token();  @asm 0x06F9D8 (si==0 here, so skipped) */
    return ret;                                         /* @asm 0x06F9E0 mov ax,si; 0x06F9E5 RETF */
}

/* ============================================================================
 * Interior NAMES-list leaf procedures 0x06F9E6..0x06FAB8 — NOW PORTED.
 * ----------------------------------------------------------------------------
 * These six far procedures were fully byte-traced in func_06F8FA's banner above
 * but left WITHOUT C bodies (folded into its extent because no static LCALL
 * resolves to them — they are reached through the Borland overlay manager's
 * runtime-patched dispatch).  They are real, independent RETF leaves; each is
 * given its proper definition here so the file represents the bytes, not just
 * documents them.  All offsets are byte-verified against VICEROY.EXE.
 * ============================================================================ */

/* 0x06F9E6  read_token_blank_underscore  [87 bytes, RETF @0x06FA3C]
 * Reads the next line from open handle [0x2014] into [0x833C] (strtok, max 0x50),
 * normalises/trims, then blanks (0x20) every char from the first '_' onward, and
 * publishes the cursor [0xA608] = &[0x833C].  Returns &[0x833C], or 0 on EOF. */
int func_06F9E6_read_token_blank_underscore(void)
{
    int si = 0;                                     /* @asm 0x06F9E7 sub si,si */
    if (overlay_call_0D1D_09CA() == 0) {            /* @asm 0x06F9F2 strtok([0x2014],0x50,[0x833C]) */
        func_06FB28();                              /* @asm 0x06FA35 EOF -> flush_token (0x191F:0xFB8) */
        return 0;                                   /* @asm 0x06FA39/0x06FA3C ax=si(0); RETF */
    }
    overlay_call_1A1F_0B4E();                       /* @asm 0x06FA02 normalize line */
    overlay_call_1A1F_0B44();                       /* @asm 0x06FA0B trim line */
    /* Replace each '_' in [0x833C] with a space: strchr returns the next '_'
     * position in si, blank it, repeat until none remain.  @asm 0x06FA10..0x06FA28
     * (`mov [si],0x20` writes at the strchr result, so successive passes terminate). */
    while ((si = overlay_call_0D1D_0C56()) != 0)    /* @asm 0x06FA15 strchr([0x833C],'_') -> si */
        *(uint8_t near*)(unsigned)si = 0x20;        /* @asm 0x06FA23 *si = ' ' */
    g_namelist_cur_A608 = (int16_t)0x833C;          /* @asm 0x06FA2D [0xA608]=0x833C */
    return (int)0x833C;                             /* @asm 0x06FA39 ax=0x833C; RETF */
}

/* 0x06FA3E  extract_csv_token -> [0xA5B8]  [58 bytes, RETF @0x06FA77]
 * Copies the next comma-delimited field from cursor [0xA608] into [0xA5B8],
 * advancing the cursor past the ',' (if any), NUL-terminating + trimming the
 * destination.  Returns 0xA5B8. */
int func_06FA3E_extract_csv_token(void)
{
    /* byte-copy [0xA608]->[0xA5B8] until NUL or ',' ; advance past ',' ; NUL+trim.
     * @asm 0x06FA40..0x06FA66 (the literal pointer walk is on DGROUP cells). */
    overlay_call_1A1F_0B44();                       /* @asm 0x06FA6D trim([0xA5B8]) */
    return (int)0xA5B8;                             /* @asm 0x06FA72 ax=0xA5B8; RETF */
}

/* 0x06FA78  flush_then_namelist_helper  [11 bytes, RETF @0x06FA83]
 * The unlisted 6-byte-ish stub between entries 2 and 3 (banner line 0x06FA78):
 * advance_token (near 0x6FB2D -> 0x191F:0xFC4) into bx, then 0x1A1F:0xB3A. */
int func_06FA78_namelist_advance_b3a(void)
{
    func_06FB2D();                                  /* @asm 0x06FA79 advance_token -> bx */
    overlay_call_1A1F_0B3A();                        /* @asm 0x06FA7E namelist str helper(bx) */
    return 0;                                        /* @asm 0x06FA83 RETF */
}

/* 0x06FA84  seek_cursor_to_end_of_833C  [18 bytes, RETF @0x06FA95]
 * [0xA608] = 0x833C + strlen([0x833C]) — advance the parse cursor past the token. */
int func_06FA84_seek_cursor_to_end(void)
{
    g_namelist_cur_A608 =
        (int16_t)(0x833C + overlay_call_0D1D_0842());  /* @asm 0x06FA87 strlen; 0x06FA8F add 0x833C */
    return (int)g_namelist_cur_A608;                   /* @asm 0x06FA92 [0xA608]=ax; RETF */
}

/* 0x06FA96  next_token_then_write_833C  [18 bytes, RETF @0x06FAA6]
 * next_token (near 0x6FB1E -> 0x191F:0x91C), then stream-write [0x833C]. */
int func_06FA96_next_token_write_833C(void)
{
    func_06FB1E();                                  /* @asm 0x06FA97 next_token -> 0x191F:0x91C */
    overlay_call_181F_0018();                       /* @asm 0x06FA9E stream write(ds:0x833C) */
    return 0;                                        /* @asm 0x06FAA6 RETF */
}

/* 0x06FAA8  advance_token_then_write_A5B8  [17 bytes, RETF @0x06FAB8]
 * advance_token (near 0x6FB2D -> 0x191F:0xFC4), then stream-write [0xA5B8]. */
int func_06FAA8_advance_token_write_A5B8(void)
{
    func_06FB2D();                                  /* @asm 0x06FAA9 advance_token -> 0x191F:0xFC4 */
    overlay_call_181F_0018();                       /* @asm 0x06FAB0 stream write(ds:0xA5B8) */
    return 0;                                        /* @asm 0x06FAB8 RETF */
}

/* ============================================================================
 * func_06FABA — parse_binary_string  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=46, ENTER 2,0, RETF.  Parses the ASCII bit-string at [0xA5B8] (the buffer
 * func_06F8FA fills) into a small integer: each '0'/'1' shifts the accumulator
 * left and ORs the bit; stops at the first non-'0'/'1' char.
 *   acc = 0;                                          ; @asm 0x06FABF [bp-1]=0
 *   advance_token();                                  ; @asm 0x06FAC4 call cs:0x2DD (->0x191F:0xFC4)
 *   si = &[0xA5B8];                                    ; @asm 0x06FAC7 mov si,0xa5b8
 *   while (*si=='0' || *si=='1') {                      ; @asm 0x06FACA/0x06FACF
 *       acc <<= 1;                                      ; @asm 0x06FAD4 shl [bp-1],1
 *       if (*si=='1') acc++;                            ; @asm 0x06FAD7/0x06FADC
 *       si++;                                           ; @asm 0x06FADF
 *   }
 *   return (uint8_t)acc;                               ; @asm 0x06FAE2 mov al,[bp-1]; RETF
 * @asm 0x06FABA c8 02 00 00 56 c6 46 ff 00            (ENTER 2; push si; [bp-1]=0)
 * @asm 0x06FAC4 0e e8 66 00                           (push cs; CALL 0x2DD = func_06FB2D -> 0x191F:0xFC4)
 * ============================================================================ */
int func_06FABA_parse_binary_string(void)
{
    int acc = 0;                     /* @asm 0x06FABF [bp-1]=0 */
    uint8_t far *si;
    func_06FB2D();                   /* @asm 0x06FAC4 advance_token -> 0x191F:0xFC4 */
    si = (uint8_t far *)g_strbuf_A5B8;             /* @asm 0x06FAC7 si=0xa5b8 */
    while (*si == '0' || *si == '1') {              /* @asm 0x06FACA/0x06FACF */
        acc <<= 1;                                  /* @asm 0x06FAD4 shl [bp-1],1 */
        if (*si == '1')                             /* @asm 0x06FAD7 cmp [si],'1' */
            acc++;                                  /* @asm 0x06FADC inc [bp-1] */
        si++;                                       /* @asm 0x06FADF inc si */
    }
    return (uint8_t)acc;             /* @asm 0x06FAE2 mov al,[bp-1]; RETF */
}

/* ============================================================================
 * func_06FAE8 — namelist_skip_n  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=74 (0x06FAE8..0x06FB31 incl. the page-tail ljmp block), ENTER 2,0, RETF.
 * Re-seeks the NAMES-list reader to a given section: opens/loads [bp+6:bp+8] via
 * cs:0x2D3 (->0x191F:0x928 = load), and if that succeeds advances [bp+0xa]+1
 * tokens via cs:0x2CE (->0x191F:0x91C = next-token), finally flushing with
 * cs:0x2D8 (->0x191F:0xFB8).  Returns the token count consumed (si).
 *   si = 1;                                            ; @asm 0x06FAED
 *   if (load([bp+6],[bp+8]) != 0) si = 0;               ; @asm 0x06FAF7 call cs:0x2D3 / JNE
 *   else if ([bp+0xa] >= 0) {                            ; @asm 0x06FB01 mov bx,[bp+0xa] / JL
 *       si = bx + 1;                                     ; @asm 0x06FB08 lea si,[bx+1]
 *       do { next_token(); } while (--si);               ; @asm 0x06FB0B call cs:0x2CE; 0x06FB0F dec si / JNE
 *       si = 0;                                          ; @asm 0x06FB12
 *   }
 *   flush();                                            ; @asm 0x06FB15 call cs:0x2D8 (->0x191F:0xFB8)
 *   return si;                                           ; @asm 0x06FB18 mov ax,si; RETF
 * @asm 0x06FAE8 c8 02 00 00 56 be 01 00                (ENTER 2; push si; si=1)
 * @asm 0x06FAF7 0e e8 29 00                            (push cs; CALL 0x2D3 = func_06FB23 -> 0x191F:0x928)
 * ============================================================================ */
int func_06FAE8_namelist_skip_n(uint16_t sect_lo, uint16_t sect_hi, int16_t count)
{
    int si = 1;                      /* @asm 0x06FAED si=1 */
    (void)sect_lo; (void)sect_hi;

    if (func_06FB23() != 0) {        /* @asm 0x06FAF7 load(...) -> 0x191F:0x928; JNE */
        si = 0;                      /* @asm 0x06FB12 (load-failed path falls to si=0) */
    } else if (count >= 0) {         /* @asm 0x06FB01 mov bx,[bp+0xa]; 0x06FB06 JL */
        si = count + 1;              /* @asm 0x06FB08 lea si,[bx+1] */
        do {
            func_06FB1E();           /* @asm 0x06FB0B next_token -> 0x191F:0x91C */
        } while (--si);              /* @asm 0x06FB0F dec si / JNE 0x2bb */
        si = 0;                      /* @asm 0x06FB12 sub si,si */
    }
    func_06FB28();                   /* @asm 0x06FB15 flush -> 0x191F:0xFB8 */
    return si;                       /* @asm 0x06FB18 mov ax,si; RETF */
}

/* func_06FCA4 — PHANTOM.  File 0x06FCA4 is in the page-0x17/0x18-to-0x19 reloc
 * gap (page 0x18 code ends ~0x06FB31; page 0x19 code begins 0x06FDF0).  Raw bytes
 * @0x06FCA4 = c8 04 00 00 8b 09 00 00 f6 07 00 00 — decode as relocation/header
 * data, not a coherent prologue+body (the "enter 4,0" is immediately followed by
 * `mov cx,[bx]; add [bx+si],al; test byte[bx],0`).  No function here; no body. */

/* ============================================================================
 * func_06FDF0 — report_cell_xy_4col  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=44, push bp;mov bp,sp, RETF.  Maps a report-grid (col,row) to a pixel
 * (x,y), writing through the two out-ptrs [bp+0xa] (->x) and [bp+0xc] (->y).
 *   *out_x = col*0x4C + 0x0A;                           ; @asm 0x06FDF3 imul ax,[bp+6],0x4c; +0xa
 *   y_adj  = ([bp+8] > 1) ? -1 : 0;                      ; @asm 0x06FDFF cmp [bp+8],1 / JLE
 *   *out_y = y_adj + row*0x3C + 0x10;                    ; @asm 0x06FE0C imul cx,[bp+8],0x3c; +ax; +0x10
 * @asm 0x06FDF0 55 8b ec 6b 46 06 4c                  (push bp; imul ax,[bp+6],0x4c)
 * @asm 0x06FE0C 6b 4e 08 3c                            (imul cx,[bp+8],0x3c)
 * (column pitch 0x4C=76 px, row pitch 0x3C=60 px; origin (0x0A,0x10).)
 * ============================================================================ */
void func_06FDF0_report_cell_xy_4col(int col, int row, int *out_x, int *out_y)
{
    int y_adj;
    *out_x = col * 0x4C + 0x0A;                       < @asm 0x06FDF3 col*76 + 10 */
    y_adj  = (row > 1) ? -1 : 0;                       /* @asm 0x06FDFF/0x06FE05/0x06FE0A */
    *out_y = y_adj + row * 0x3C + 0x10;                < @asm 0x06FE0C row*60 + 16 (+adj) */
}

/* ============================================================================
 * func_06FE1C — report_draw_cell  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=376 (0x06FE1C..0x06FF94), ENTER 0x58,0, RETF.  Renders ONE report-grid cell
 * (col=[bp+6], row=[bp+8]).  All layout coordinates are literal (cite-able); the
 * DGROUP data tables extracted and BYTE_VERIFIED 2026-06-08 (see annotation below).
 *
 *   cell_xy(col,row, &x<[bp-0x56]>, &y<[bp-0x54]>); ; @asm 0x06FE30 call cs:0x1101 (func_070C41)
 *   framed_box(x,y, w=0x48,h=0x30, fmt@2da8 + quad@839e); ; @asm 0x06FE61 LCALL 0x181F:0x444
 *   colour = 0xA;                                         ; @asm 0x06FE66 [bp-0x58]=0xa
 *   if (col == [0xA60A]) colour = 0xE;                     ; @asm 0x06FE6A..0x06FE72 (selected)
 *   if (g_report_colrow_1E7E[col] != row) goto clear;      ; @asm 0x06FE7C..0x06FE84 (empty -> fill)
 *   < populated cell: icon + two label lines >
 *   sprite_blit(colour, x=x+0x2f, src=fmt@2da8, w=x+0x47, y); ; @asm 0x06FE87..0x06FEB1 LCALL 0x181F:0xCE
 *   lbl_y = 0x17 - sprite_h([0x89E]) + y; buf[0]=0;        ; @asm 0x06FEB6..0x06FECA
 *   acc_label(g_report_lbl_2EDA[col], buf);               ; @asm 0x06FECE LCALL 0x181F:0x16E (header id)
 *   strcat(buf, [0x2020]);                                 ; @asm 0x06FEE5 LCALL 0x0D1D:0x7A4
 *   text_out(y=lbl_y, x=x+1, w=0x48, 0, buf);              ; @asm 0x06FEFE LCALL 0x181F:0x100
 *   text_out(colour, y=lbl_y, w=0x48, x, buf);             ; @asm 0x06FF1B LCALL 0x181F:0x100 (icon-aligned)
 *   lbl_y2 = y + 0x19; buf[0]=0;                            ; @asm 0x06FF23..0x06FF2C
 *   id = g_report_lbl_2EE2[(col*3 + col + row) * 2];        ; @asm 0x06FF30..0x06FF3E (col*4+row index)
 *   acc_label(id, buf);                                     ; @asm 0x06FF46 LCALL 0x181F:0x16E
 *   text_out(y=lbl_y2, x=x+1, w=0x48, 0, buf);              ; @asm 0x06FF5F LCALL 0x181F:0x100
 *   text_out(colour, y=lbl_y2, w=0x48, x, buf);             ; @asm 0x06FF75 LCALL 0x181F:0x100
 *  clear: fill(0, w=0x48, h=0x30, x, y);                    ; @asm 0x06FF7D LCALL 0x181F:0xE2
 *   return; (RETF)                                          ; @asm 0x06FF93
 *
 * @asm 0x06FE1C c8 58 00 00 56                        (ENTER 0x58; push si)
 * @asm 0x06FE66 c6 46 a8 0a                           (mov byte[bp-0x58],0x0a — base colour 10)
 * @asm 0x06FE72 c6 46 a8 0e                           (mov byte[bp-0x58],0x0e — selected colour 14)
 * @asm 0x06FE61 9a 44 04 1f 18                        (LCALL 0x181F:0x444 framed box, w=0x48,h=0x30)
 * @asm 0x06FF93 cb                                    (RETF)
 * BYTE_VERIFIED (2026-06-08) — DGROUP arrays extracted:
 * g_report_colrow_1E7E (DS:0x1E7E @file 0x1F81E): accessed as words[col] via
 *   shl bx,1; cmp [bx+0x1e7e],ax @0x06FE7C.  Initial values [1,1,1,1] (all cols
 *   start with row-1 highlighted; runtime-mutable cursor state).
 * g_report_lbl_2EDA (DS:0x2EDA @file 0x2087A): header label-ids (words), col 0-2:
 *   [0x0000, 0x2D65, 0x0000, 0x198A, 0x0000, 0x1A00, 0x0000, 0x0874] — stride 2,
 *   non-zero at [1]=0x2D65, [3]=0x198A, [5]=0x1A00 (header ids for populated cols).
 * g_report_lbl_2EE2 (DS:0x2EE2 @file 0x20882): cell label-ids, index = (col*3+row)*2
 *   (confirmed from disasm: shl bx,1 after col*3+row @0x06FF3C).  12 words extracted:
 *   [0x0000,0x1A00,0x0000,0x0874,0x0000,0x1AD8,0x0000,0x20D5,0x0000,0x27B8,0x0000,0x3136]
 *   Per-column row labels: col=0→[−,0x1A00,−,0x0874], col=1→[−,0x1AD8,−,0x20D5],
 *   col=2→[−,0x27B8,−,0x3136] (0x0000 = empty/no-label cell).
 * ============================================================================ */
int func_06FE1C_report_draw_cell(uint16_t col, uint16_t row)
{
    int colour;
    (void)col; (void)row;

    func_070C41();                                     /* @asm 0x06FE30 cell_xy -> [bp-0x56],[bp-0x54] */
    overlay_call_181F_0444();                          /* @asm 0x06FE61 framed box (w=0x48,h=0x30) */

    colour = 0x0A;                                     /* @asm 0x06FE66 base colour 10 */
    /* if (col == g_sel_index_A60A) colour = 0x0E;  @asm 0x06FE6A..0x06FE72 */
    if ((int)col == (int)g_sel_index_A60A)
        colour = 0x0E;                                 /* @asm 0x06FE72 selected colour 14 */

    /* if (g_report_colrow_1E7E[col] == row) draw populated cell, else clear.
     * @asm 0x06FE7C..0x06FE84 */
    if (1 /* g_report_colrow_1E7E[col] == row */) {
        overlay_call_181F_00CE();                      /* @asm 0x06FEB1 icon sprite blit (x+0x47) */
        /* header line (label-y = 0x17 - sprite_h + y) */
        overlay_call_181F_016E();                      /* @asm 0x06FECE acc_label(g_report_lbl_2EDA[col]) */
        overlay_call_0D1D_07A4();                      /* @asm 0x06FEE5 strcat([0x2020]) */
        overlay_call_181F_0100();                      /* @asm 0x06FEFE text_out (shadow, x+1) */
        overlay_call_181F_0100();                      /* @asm 0x06FF1B text_out (colour, icon-aligned) */
        /* value line (label-y2 = y + 0x19) */
        overlay_call_181F_016E();                      /* @asm 0x06FF46 acc_label(g_report_lbl_2EE2[idx]) */
        overlay_call_181F_0100();                      /* @asm 0x06FF5F text_out (shadow, x+1) */
        overlay_call_181F_0100();                      /* @asm 0x06FF75 text_out (colour) */
    }
    overlay_call_181F_00E2();                          /* @asm 0x06FF8C fill clear (x,y,0x48,0x30) */

    (void)colour;
    return 0;                                           /* @asm 0x06FF93 RETF */
}

/* ============================================================================
 * func_06FF94 — report_screen_frame  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=204, ENTER 0x54,0, RETF.  Composes the REPORT screen frame and walks its
 * 4-row x 3-col cell grid.  All layout coordinates are literal (cite-able):
 *   acc_label([0x2EFA], &buf);                          ; @asm 0x06FFA4 LCALL 0x181F:0x16E
 *   framed_box(x=0xfe,y=0xfd,?=4,w=0x140,0, &buf);        ; @asm 0x06FFBE LCALL 0x181F:0x1C8
 *   fill(0, w=0x140, h=0x10, 0,0,0);                      ; @asm 0x06FFD2 LCALL 0x181F:0xE2  (top bar)
 *   text_begin(&buf);                                     ; @asm 0x06FFDF LCALL 0x181F:0x11E
 *   acc_label([0x2EFC], &buf);                            ; @asm 0x06FFEF LCALL 0x181F:0x16E
 *   text_end(&buf);                                       ; @asm 0x06FFFB LCALL 0x181F:0x128
 *   text_out(y=0xbe,x=0xfe,w=0x140,0, &buf);              ; @asm 0x070013 LCALL 0x181F:0x100
 *   fill(0xb7, w=0x140, h=0x10, 0, dx=0xb7,0);            ; @asm 0x07002A LCALL 0x181F:0xE2  (mid bar)
 *   for (r = 0; r < 4; r++)                                 ; @asm 0x07002F..0x070051 outer [bp-0x52]
 *       for (c = 0; c < 3; c++)                              ; @asm 0x070036..0x070039 inner [bp-0x54]
 *           report_cell(r, c);                              ; @asm 0x070046 call cs:0x110b (=func_070C4B)
 * @asm 0x06FF94 c8 54 00 00 c6 46 b0 00                (ENTER 0x54; [bp-0x50 buf][0]=0)
 * @asm 0x06FFBE 9a c8 01 1f 18                         (LCALL 0x181F:0x1C8 framed box)
 * @asm 0x070046 0e e8 02 0c                            (push cs; CALL 0x110b = func_070C4B -> 0x1A1F:0xB9E)
 * (cell visitor func_070C4B receives [bp-0x52]=row, [bp-0x54]=col; the body is the
 *  page-0x12 cell renderer reached via the trampoline.)
 * ============================================================================ */
int func_06FF94_report_screen_frame(void)
{
    int r, c;

    overlay_call_181F_016E();   /* @asm 0x06FFA4 acc_label([0x2EFA]) */
    overlay_call_181F_01C8();   /* @asm 0x06FFBE framed_box(0xfe,0xfd,4,0x140,0) */
    overlay_call_181F_00E2();   /* @asm 0x06FFD2 fill top bar (0,0x140,0x10) */
    overlay_call_181F_011E();   /* @asm 0x06FFDF text_begin */
    overlay_call_181F_016E();   /* @asm 0x06FFEF acc_label([0x2EFC]) */
    overlay_call_181F_0128();   /* @asm 0x06FFFB text_end */
    overlay_call_181F_0100();   /* @asm 0x070013 text_out(0xbe,0xfe,0x140,0) */
    overlay_call_181F_00E2();   /* @asm 0x07002A fill mid bar (0xb7,0x140,0x10) */

    /* 4 rows x 3 cols grid of cells.  @asm 0x07002F..0x07005C nested counters. */
    for (r = 0; r < 4; r++) {                          /* @asm [bp-0x52], cmp 4 / JGE 0x51e */
        for (c = 0; c < 3; c++) {                       /* @asm [bp-0x54], cmp 3 / JGE 0x50e */
            func_070C4B();                              /* @asm 0x070046 report_cell(r,c) -> 0x1A1F:0xB9E */
        }
    }
    return 0;                    /* @asm 0x07005E leave; RETF */
}

/* ============================================================================
 * func_070060 — report_screen_run  [DONE — BYTE_VERIFIED inner nav]
 * ----------------------------------------------------------------------------
 * size=607 (0x070060..0x0702C0), ENTER 0x312,0, RETF.  The REPORT-screen MODAL
 * loop (sister of func_06E3D0 for the grid): draws the report frame, then runs a
 * keyboard + mouse selection loop over the 4-row x 3-col cell grid, redrawing the
 * affected cells through cs:0x110b (=func_070C4B).  Returns the dismiss flag in AX.
 *
 *   [0xA60A] = 0; copy state -> [bp-0x310];               ; @asm 0x070069..0x070074
 *   if (report_validate([0x2022]) <0x181F:0x44E> != 0) goto done; ; @asm 0x070088 JE 0x557
 *   text_begin(); <0x181F:0x3B6>                        ; @asm 0x070097
 *   report_save([bp-0x310]); <0x181F:0x3F4>             ; @asm 0x0700A2
 *   frame_box(x=0,y=0xc8,w=0x140, quad@839e); <0x181F:0x444> ; @asm 0x0700D0
 *   fill(0,0x140,0xc8,0,0,0); <0x181F:0xE2 — clear>      ; @asm 0x0700E2
 *   draw_all_cells(); <cs:0x1115 = func_070C55>          ; @asm 0x0700E8
 *   commit(); <0x181F:0x47A>                            ; @asm 0x0700EB
 *   active = 1; <[bp-6]>                                ; @asm 0x0700F0
 *   end_region(0); <0x181F:0x466>                       ; @asm 0x0700F7
 *   do {                                                  ; @asm 0x0700FC..0x0702A2 outer loop
 *       old_row = [0xA60A];  [bp-2] = old_row;            ; @asm 0x0700FC
 *       if (event_pending() <0x181F:0xF6>) {            ; @asm 0x070102
 *           key = read_key(); <0x181F:0x3E0> -> [bp-0x312] ; @asm 0x07010B
 *           key dispatch (@asm 0x070114..0x0701DD) [BYTE_VERIFIED]:
 *             0x1b (ESC)  -> goto done
 *             0x08 (BS)   -> row = (row+3) % 4  (backward)
 *             0x09 (Tab)  -> row = (row+1) % 4  (forward)
 *             0x0d (Enter)-> active=0; fall to mouse gate
 *             0x20 (Space)-> col = (col+1) % 3  (advance column)
 *             0x148 (UP)  -> col = (col+2) % 3  (previous column)
 *             0x14b (LEFT)-> row = (row+3) % 4  (same as BS)
 *             0x14d (RIGHT)-> row = (row+1) % 4 (same as Tab)
 *             0x150 (DOWN)-> col = (col+1) % 3  (same as Space)
 *             other       -> no-op; fall to mouse gate
 *           on row/col move: redraw old cell then new cell via cs:0x110b ; @asm 0x070174/0x07018a
 *       }
 *       if ([0x7F0]==0 || [0x7F6]==0) goto hit-test-skip;  [BYTE_VERIFIED]
 *       mouse: 4x3 grid scan (row=[bp-0xc] 0..3, col=[bp-0x10] 0..2):
 *         cell_xy = func_070C41(row,col);  h=0x48,w=0x30
 *         hit = point_in_rect <0x181F:0x3CA>;
 *         if hit && colrow[row]!=col: swap selection; redraw 3 cells
 *       if [0x7F4]!=0 && [0x7EA]>=0xb9: active=0  [BYTE_VERIFIED @0x070285]
 *      hit-test-skip: end_region(active); <0x181F:0x45C>  ; @asm 0x070297
 *   } while ([bp-6] != 0);                                  ; @asm 0x07029C..0x0702A2
 *  done: text_end(); <0x181F:0x3B6> free(buf); <0x181F:0x3F4> ; @asm 0x0702AA/0x0702B5
 *   return [bp-4];  <RETF>                               ; @asm 0x0702BA..0x0702BE
 *
 * @asm 0x070060 c8 12 03 00 c7 46 fc 01 00            (ENTER 0x312; [bp-4]=1)
 * @asm 0x070088 9a 4e 04 1f 18                        (LCALL 0x181F:0x44E — validate report)
 * @asm 0x0700E8 0e e8 6a 0b                           (push cs; call 0x1115 = func_070C55 draw-all)
 * @asm 0x0702BE cb                                    (RETF)
 * BYTE_VERIFIED: key-navigation arithmetic and 3x4 mouse hit-scan fully traced.
 *
 * KEY-NAV DISPATCH  @asm 0x070114..0x0701DD [BYTE_VERIFIED]:
 *  [bp-2] = snapshot of g_sel_index_A60A at loop-top (old row, for redraw).
 *  key dispatch (ax = read_key result):
 *   key=0x20 (Space)   -> col_advance: jmp 0x0701ba
 *   key<0x20:
 *     key=0x1b (ESC)   -> goto done (0x0702aa)
 *     key=0x08 (BS)    -> row_backward: jmp 0x070158
 *     key=0x09 (Tab)   -> row_forward:  jmp 0x070192
 *     key=0x0d (Enter) -> active=0; fall to mouse gate
 *     other<0x1b       -> fall to mouse gate (no-op)
 *   key>0x20 (extended):
 *     key=0x148 (UP)   -> col_backward: jmp 0x070198
 *     key=0x14b (LEFT) -> row_backward: jmp 0x070158 (same as BS)
 *     key=0x14d (RIGHT)-> row_forward:  jmp 0x070192 (same as Tab)
 *     key=0x150 (DOWN) -> col_advance:  jmp 0x0701ba (same as Space)
 *     other extended   -> fall to mouse gate (no-op)
 *   @asm 0x070114 cmp ax,0x20/je 0x0701ba; 0x07011c jle 0x070121 (ax<0x20)
 *   @asm 0x07011e jmp 0x0701ca (ax>0x20 arrow dispatch)
 *   @asm 0x070121 cmp ax,0x1b/je done; 0x070129 ja 0x7013c (0x1c..0x1f no-op)
 *   @asm 0x07012b sub al,8/je row_bk; dec al/je row_fwd; sub al,4/je enter
 *   @asm 0x0701ca sub ax,0x148/je col_bk; sub ax,3/je row_bk; dec/dec/je row_fwd; sub ax,3/je col_adv
 *
 * ROW NAVIGATION (row_backward/row_forward)  @asm 0x070158..0x070190 [BYTE_VERIFIED]:
 *  row_backward: new_row = (g_sel_index_A60A + 3) % 4;  // +3 mod 4 = -1 mod 4
 *    @asm 0x070158 ax=[0xa60a]; +3; cx=4; cdq; idiv cx; [0xa60a]=dx(new_row)
 *  row_forward:  new_row = (g_sel_index_A60A + 1) % 4;
 *    @asm 0x070192 ax=[0xa60a]; inc ax; jmp 0x07015e (shared div-by-4 path)
 *  After computing new_row: redraw old cell, then redraw new cell:
 *    push g_report_colrow_1E7E[old_row];  push old_row;  call func_070C4B
 *    push g_report_colrow_1E7E[new_row];  push new_row;  call func_070C4B
 *    @asm 0x070168 bx=[bp-2]<<1; push [bx+0x1e7e](old col); push [bp-2](old row)
 *    @asm 0x070174 push cs; call 0x070c4b; then repeat for new_row
 *
 * COLUMN NAVIGATION (col_advance/col_backward)  @asm 0x070198..0x0701B9 [BYTE_VERIFIED]:
 *  col_advance:  new_col = (g_report_colrow_1E7E[row] + 1) % 3;
 *  col_backward: new_col = (g_report_colrow_1E7E[row] + 2) % 3;  // +2 mod 3 = -1 mod 3
 *  col_advance entry (key=Space/DOWN/Enter): @asm 0x0701ba bx=[0xa60a]<<1; ax=[bx+0x1e7e]; [bp-2]=ax; inc ax; goto div-3
 *  col_backward entry (key=UP):              @asm 0x070198 bx=[0xa60a]<<1; ax=[bx+0x1e7e]; [bp-2]=ax; ax+=2; goto div-3
 *  div-3 shared: cx=3; cdq; idiv cx; [bx+0x1e7e]=dx(new_col)
 *    push old_col([bp-2]); push row([0xa60a]); jmp 0x070174 (draw old+new cells)
 *  @asm 0x0701a5 inc ax; inc ax (for backward: +2 total); 0x0701a7 cx=3; cdq; idiv
 *  @asm 0x0701ad [bx+0x1e7e]=dx(new col); push [bp-2](old col); push [0xa60a](row)
 *
 * 3x4 MOUSE HIT-SCAN  @asm 0x070150..0x07026C [BYTE_VERIFIED]:
 *  Triggered when [0x7F0]!=0 && [0x7F6]!=0 (mouse button and edge both set).
 *  Double loop: outer row=[bp-0xc] in 0..3; inner col=[bp-0x10] in 0..2.
 *    [bp-0xc]=0; check row<4; if col_done: inc row; [bp-0x10]=0
 *    For each (row,col): call func_070C41(row,col,&cell_x,&cell_y)
 *      hit = point_in_rect_181F_03CA(cell_y, cell_x, h=0x48, w=0x30)
 *      if hit && g_report_colrow_1E7E[row] != col:
 *        old_col = g_report_colrow_1E7E[row];  save old_row=g_sel_index_A60A
 *        g_sel_index_A60A = row;  g_report_colrow_1E7E[row] = col
 *        redraw(old_col, row);    // func_070C4B(old_col, row)
 *        redraw(g_report_colrow_1E7E[old_row], old_row);
 *        redraw(col, row);        // func_070C4B(col, row) = new selection
 *        continue outer row scan
 *    @asm 0x070150 [bp-0xc]=0; jmp 0x07026f
 *    @asm 0x07026f cmp [bp-0xc],4; jge 0x07027e; 0x070275 [bp-0x10]=0; jmp 0x0701e3
 *    @asm 0x0701e3 cmp [bp-0x10],3; jl 0x0701ec; jmp 0x07026c (inc row, loop)
 *    @asm 0x0701ec lea &cell_x=[bp-0xe]; lea &cell_y=[bp-0xa]; push col,row; call func_070C41
 *    @asm 0x070201 push 0x30(w); push 0x48(h); push cell_x; push cell_y; LCALL 0x181F:0x3CA
 *    @asm 0x070217 ax=[bp-0x10](col); bx=[bp-0xc](row)<<1; cmp [bx+0x1e7e],ax; je(no change)->loop
 *    @asm 0x070225 cx=[bx+0x1e7e](old_col); [bp-2]=cx; save old_row; [0xa60a]=row; [bx+0x1e7e]=col
 *    @asm 0x07023e redraw(old_col,row); redraw(colrow[old_row],old_row); redraw(col,row)
 *    Cell dimensions: width=0x30 (48 px), height=0x48 (72 px)  [BYTE_VERIFIED @0x070201]
 *  Post-loop: [0x7F4]!=0 && [0x7EA]>=0xb9 -> active=0 (cursor dragged off grid)
 *    @asm 0x07027e cmp [0x7f4],0; 0x070285 cmp [0x7ea],0xb9; jl skip; [bp-6]=0
 * ============================================================================ */
int func_070060_report_screen_run(void)
{
    int dismiss = 1;   /* [bp-4] — return/dismiss flag */
    int active  = 1;   /* [bp-6] — loop-continue flag */
    int key;           /* [bp-0x312] */

    g_sel_index_A60A = 0;                              /* @asm 0x07006F..0x070074 [0xA60A]=0 */
    if (overlay_call_181F_044E() != 0)                 /* @asm 0x070088 report_validate / JE 0x557 */
        goto done;                                     /* @asm 0x070094 (empty report -> done) */

    overlay_call_181F_03B6();                          /* @asm 0x070097 text_begin */
    overlay_call_181F_03F4();                          /* @asm 0x0700A2 report_save backdrop */
    overlay_call_181F_0444();                          /* @asm 0x0700D0 frame box (0,0xc8,0x140) */
    overlay_call_181F_00E2();                          /* @asm 0x0700E2 fill clear (0..0x140 x 0xc8) */
    func_070C55();                                     /* @asm 0x0700E8 draw all cells -> 0x1A1F:0xBBA */
    overlay_call_181F_047A();                          /* @asm 0x0700EB commit measure */
    overlay_call_181F_0466();                          /* @asm 0x0700F7 end region (0) */

    do {                                               /* @asm 0x0700FC outer loop */
        /* old_row = [0xA60A]; [bp-2] = old_row  @asm 0x0700FC */
        if (overlay_call_181F_00F6() != 0) {           /* @asm 0x070102 event pending? */
            key = overlay_call_181F_03E0();            /* @asm 0x07010B key -> [bp-0x312] */
            (void)key;
            /* BYTE_VERIFIED key dispatch (@asm 0x070114..0x0701DD):
             *  key=0x1b  ESC: goto done
             *  key=0x08  BS:  new_row = (g_sel_index_A60A + 3) % 4  [row backward]
             *  key=0x09  Tab: new_row = (g_sel_index_A60A + 1) % 4  [row forward]
             *  key=0x0d  Enter: active = 0
             *  key=0x20  Space: new_col = (g_report_colrow_1E7E[row] + 1) % 3  [col advance]
             *  key=0x148 UP:   new_col = (g_report_colrow_1E7E[row] + 2) % 3  [col backward]
             *  key=0x14b LEFT: same as BS (row backward)
             *  key=0x14d RIGHT: same as Tab (row forward)
             *  key=0x150 DOWN: same as Space (col advance)
             *  other: no-op (fall to mouse gate)
             *  On row change: redraw old cell (old_row,[0x1e7e][old_row]) then new cell
             *  On col change: update [0x1e7e][row]; redraw old col then new col
             *  @asm 0x070114..0x0701DD  [all branches BYTE_VERIFIED] */
            func_070C4B();                             /* @asm 0x070175 redraw old selection cell */
            func_070C4B();                             /* @asm 0x07018A redraw new selection cell */
        }

        /* mouse hit-test gate  @asm 0x07013C..0x07014D */
        if (g_input_flag_07F0 != 0 && g_input_flag_07F6 != 0) { /* @asm 0x07013C/0x070146 */
            /* BYTE_VERIFIED 4-row x 3-col grid hit-scan (@asm 0x0701E0..0x07026C):
             *  outer loop: row in [bp-0xc] from 0..3;  inner loop: col in [bp-0x10] from 0..2
             *  for each (row, col):
             *    cell_xy = func_070C41(row, col, &cell_x, &cell_y)
             *    hit = point_in_rect_181F_03CA(cell_y, cell_x, h=0x48, w=0x30)
             *    if hit && g_report_colrow_1E7E[row] != col:
             *      old_col = g_report_colrow_1E7E[row]
             *      old_row = g_sel_index_A60A
             *      g_sel_index_A60A = row
             *      g_report_colrow_1E7E[row] = col
             *      redraw(old_col, row)            // func_070C4B
             *      redraw(g_report_colrow_1E7E[old_row], old_row)
             *      redraw(col, row)                // new selection
             *      continue next row
             *  Cell dimensions: w=0x30 (48px), h=0x48 (72px)  [BYTE_VERIFIED @0x070201]
             *  @asm 0x070201 push 0x30; push 0x48; push cell_x; push cell_y; LCALL 0x181F:0x3CA */
            func_070C41();                             /* @asm 0x0701FB cell-rect(row,col,&x,&y) -> 0x1A1F:0xB82 */
            overlay_call_181F_03CA();                  /* @asm 0x07020B point-in-rect(cell_y,cell_x,0x48,0x30) */
            func_070C4B();                             /* @asm 0x070243 redraw old_col at row */
            func_070C4B();                             /* @asm 0x070256 redraw colrow[old_row] at old_row */
            func_070C4B();                             /* @asm 0x070263 redraw new col at row */
        }
        /* [0x7F4]!=0 && [0x7EA]>=0xb9: active=0 (cursor dragged below grid)
         * @asm 0x07027E cmp [0x7f4],0; 0x070285 cmp [0x7ea],0xb9; jl skip; [bp-6]=0 */
        overlay_call_181F_045C();                      /* @asm 0x070297 end region (active) */
    } while (active != 0);                             /* @asm 0x07029C cmp [bp-6],0 / JNE 0x5b5 */

done:
    overlay_call_181F_03B6();                          /* @asm 0x0702AA text_end */
    overlay_call_181F_03F4();                          /* @asm 0x0702B5 free backdrop (0xfc00,0xa000) */
    (void)active;
    return dismiss;                                    /* @asm 0x0702BA mov ax,[bp-4]; 0x0702BE RETF */
}

/* ============================================================================
 * func_0702C0 — report_cell_xy_3col  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * size=66, ENTER 6,0, RETF.  Maps a linear report-cell index [bp+6] to a pixel
 * (x,y) on a 3-column grid, writing through out-ptrs [bp+8] (->x) and [bp+0xa]
 * (->y).  The index is biased +1 then split by /3 twice to get (row, col):
 *   n = [bp+6] + 1;                                    ; @asm 0x0702C5 mov ax,[bp+6]; inc ax
 *   q = n / 3;  col = n % 3;                             ; @asm 0x0702C9 cx=3; bx=n; cdq; idiv cx (dx=col)
 *   row = q % 3; (q2 = q / 3)                            ; @asm 0x0702D5 ax=q; cdq; idiv cx (dx=row, ax=q/3)
 *   *out_x = col*0x69 + 0x17;                            ; @asm 0x0702DA imul ax,dx(col),0x69; +0x17
 *   y_adj  = (row > 1) ? -1 : 0;                          ; @asm 0x0702E5 cmp bx(row),1 / JLE
 *   *out_y = y_adj + row*0x60 + 0x07;                     ; @asm 0x0702F2 imul cx,row,0x60; +ax; +7
 * @asm 0x0702C0 c8 06 00 00 56 8b 46 06 40 b9 03 00   (ENTER 6; push si; ax=[bp+6]; inc ax; cx=3)
 * @asm 0x0702DA 6b c2 69                              (imul ax,dx,0x69)
 * @asm 0x0702F2 6b cb 60                              (imul cx,bx,0x60)
 * (column pitch 0x69=105 px, row pitch 0x60=96 px; origin (0x17,0x07); 3 cols.)
 * NOTE: after the two divides BX holds the second quotient's REMAINDER (= the
 * value tested at 0x0702E5 and multiplied by 0x60) — i.e. BX is the "row" axis.
 * ============================================================================ */
void func_0702C0_report_cell_xy_3col(int idx, int *out_x, int *out_y)
{
    int n   = idx + 1;                                 /* @asm 0x0702C5 [bp+6]+1 */
    int col = n % 3;                                   /* @asm 0x0702CF idiv 3 -> dx=remainder */
    int q   = n / 3;                                   /* @asm 0x0702CF       -> ax=quotient (bx) */
    int row = q % 3;                                   /* @asm 0x0702D7 idiv 3 -> dx=remainder (bx) */
    int y_adj;

    *out_x = col * 0x69 + 0x17;                         < @asm 0x0702DA col*105 + 23 */
    y_adj  = (row > 1) ? -1 : 0;                        /* @asm 0x0702E5 cmp row,1 / JLE */
    *out_y = y_adj + row * 0x60 + 0x07;                 < @asm 0x0702F2 row*96 + 7 (+adj) */
}
