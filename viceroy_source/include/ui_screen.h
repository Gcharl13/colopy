/* ============================================================================
 * ui_screen.h — screen-state ids returned by the per-screen handlers
 * ----------------------------------------------------------------------------
 * Each ui/<screen>.c handler returns one of these to the main_loop dispatcher
 * to select the next screen. CONSOLIDATED 2026-06-09 from per-file #defines
 * (title/europe/colony/hall_of_fame each carried its own copy).
 *
 * EUROPE/COLONY are anchored to the BYTE-VERIFIED enter_screen_view "view ids"
 * (Europe 0x2B @asm 0x030DEB — see europe_screen.c SCREEN_ID_EUR; Colony 0x2C
 * @asm 0x025EE8). TITLE/HALL_OF_FAME (0x29/0x2A) are convention-only — no
 * DOS-traced id exists for them; assigned contiguously below the verified pair.
 * ============================================================================ */
#ifndef VICEROY_UI_SCREEN_H
#define VICEROY_UI_SCREEN_H

#define SCREEN_TITLE         0x29   /* convention-only (no traced id) */
#define SCREEN_HALL_OF_FAME  0x2A   /* convention-only (no traced id) */
#define SCREEN_EUROPE        0x2B   /* = enter_screen_view id 0x2B (@asm 0x030DEB) */
#define SCREEN_COLONY        0x2C   /* = enter_screen_view id 0x2C (@asm 0x025EE8) */

#endif /* VICEROY_UI_SCREEN_H */
