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

#endif /* _VICEROY_MODERN */
