/* ============================================================================
 * headless_io_stubs.c -- strong MODERN-REPLACED no-ops for DOS display/input
 *                        thunks that are gameplay-reachable but have no modern
 *                        meaning in the headless build.
 * ----------------------------------------------------------------------------
 * The real-data smoke (VICEROY_DATA=<COLONIZE> --smoke --stub-report) exercises
 * the per-turn event/market/king logic and shows which weak stubs are actually
 * hit during play. The dominant hits are DOS display/input leaves whose correct
 * headless behavior is exactly "do nothing / no input":
 *
 *   overlay_call_1059_000A  modal keyboard/input poll (in func_004EE6's
 *                           watchdog loop `while(poll()!=0)`); 0 == no input.
 *   overlay_call_181F_00E2  clear_region / draw_frame  (no framebuffer headless)
 *   overlay_call_181F_0100  draw header text           (no framebuffer headless)
 *
 * These already no-op via the weak link-floor stubs (return 0); defining them
 * here as STRONG defs is behavior-identical but gives them a terminal
 * MODERN-REPLACED disposition and removes their benign hits from the
 * weak-stub-hit counter (so the counter tracks genuine logic gaps, not the
 * display/input surface). Same policy/role as src/platform/render_glue.c.
 *
 * Signatures match the link-floor weak stubs (`long (void)`); K&R call sites
 * that pass args push them harmlessly (cdecl: caller cleans, callee ignores).
 * ============================================================================ */
#ifdef _VICEROY_MODERN

long overlay_call_1059_000A(void) { return 0; }  /* input poll -> no input */
long overlay_call_181F_00E2(void) { return 0; }  /* clear region / draw frame */
long overlay_call_181F_0100(void) { return 0; }  /* draw header text */

/* Text-composition blit leaves (load_image glyph/string region): each resolves
 * to a screen-blit routine -- func_002992 (string-by-id blit), func_0029DE
 * (number fmt + blit), and func_002922/0028F2/002932 (label-prefix / separator
 * / finalize, all tail-calling the glyph drawer func_00D974). On-screen text
 * composition has no headless meaning; the menu/placeholder path is separate
 * (msg_set_arg). No-op in headless. */
long overlay_call_181F_016E(void) { return 0; }  /* strcat_str blit (func_002992) */
long overlay_call_181F_0182(void) { return 0; }  /* fmt_int blit (func_0029DE) */
long overlay_call_181F_011E(void) { return 0; }  /* label-prefix glyph (func_002922) */
long overlay_call_181F_01BE(void) { return 0; }  /* separator glyph (func_0028F2) */
long overlay_call_181F_0128(void) { return 0; }  /* finalize glyph (func_002932) */

/* UI / screen-management leaves with no headless meaning:
 *   overlay_call_02D8_000E  screen refresh after state change (@asm 0x0050AF)
 *   func_06B692             dialog open / save-background (cs:0x2D12, screen
 *                           bitmap capture for restore -- not a game save)
 *   overlay_call_181F_040A  open panel (@asm 0x0692CD)
 *   overlay_call_0D1D_07A4  show a GAME.TXT message string (the headless menu
 *                           path renders text separately)
 *   overlay_call_181F_0422  free_block (DOS heap free; the modern DGROUP model
 *                           persists -- no per-block free)
 * All already no-op via the weak floor; strong defs make the disposition terminal. */
long overlay_call_02D8_000E(void) { return 0; }  /* screen refresh */
long func_06B692(void)            { return 0; }  /* dialog open / save-bg */
long overlay_call_181F_040A(void) { return 0; }  /* open panel */
long overlay_call_0D1D_07A4(void) { return 0; }  /* show GAME.TXT message */
long overlay_call_181F_0422(void) { return 0; }  /* free_block (no-op heap free) */

/* ff_pre_a (0x181F:0x056A -> func_0C136): draws the fullscreen "Founding Father
 * joins" announcement (text blit + 320x200 rect via func_0B73A); the FF effect
 * itself is applied separately. Pure display -> no-op in headless. */
long ff_pre_a(void) { return 0; }

#endif /* _VICEROY_MODERN */
