/* ============================================================================
 *        >>> SUBSYSTEM DOES NOT EXIST IN VICEROY.EXE (BYTE_VERIFIED) <<<
 * ----------------------------------------------------------------------------
 * weather.c — Weather random events.
 *
 * FINDING (2026-05-28): *Sid Meier's Colonization* (VICEROY.EXE) has NO
 * weather-event subsystem.  The previous contents of this file (a WX_CLEAR /
 * WX_BAD state machine with a 5%-per-month roll, -1 land movement, and -25%
 * production) were FABRICATED — they describe a Civilization-style mechanic
 * that Colonization does not have.
 *
 * EVIDENCE (string-first, per MEMORY.md methodology):
 *   - GAME.TXT (COLONIZE/GAME.TXT, 510 message templates) contains NO weather
 *     event key.  A case-insensitive scan for weather / storm / blizzard /
 *     hurricane / drought / frost / gale / gale finds exactly one hit:
 *       line 567  "In this harsh winter weather, many colonists are {starving}"
 *     which is part of @STARVE1 — i.e. FLAVOR text inside the food/starvation
 *     system (@FOOD1/@FOOD2/@STARVE1/@STARVE2/@VANISH, GAME.TXT 0x2976..),
 *     NOT a weather event.  "Winter" here only modulates STARVATION messaging.
 *   - code/VICEROY/strings.json (every NUL-terminated string in VICEROY.EXE)
 *     contains NO weather / storm / blizzard / hurricane / drought token.
 *   - No function in the re-segmented overlay (disasm_overlay_reseg/page_*.asm)
 *     references any such string or a per-turn "weather state" global.
 *
 * WHAT ACTUALLY EXISTS (the real seasonal/climate touchpoints):
 *   - The two-season turn cycle (Spring/Autumn) at DGROUP:0x5390, processed by
 *     func_021A14 (Spring) / func_021D32 (Autumn).  Season affects the YEAR
 *     advance and movement-point refresh, but applies NO weather penalty.
 *     See src/ui/main_loop.c.
 *   - Per-tile climate at MAP-GENERATION time (latitude bands -> terrain),
 *     handled in src/mapgen/climate.c — a static map property, not a runtime
 *     event.
 *   - Starvation (food deficit) — a deterministic colony mechanic, not random
 *     weather.  See @FOOD / @STARVE / @VANISH in GAME.TXT.
 *
 * This file is intentionally left as a documented stub.  Do NOT re-introduce a
 * weather mechanic without a VICEROY.EXE citation; there is none to cite.
 *
 * @verified_by   String-table + GAME.TXT scan, 2026-05-28.
 * @status        BYTE_VERIFIED (absence): no weather subsystem in VICEROY.EXE.
 * ============================================================================ */
#include "viceroy_types.h"

/* No weather state, no weather tick, no movement/production modifier.
 * VICEROY.EXE has none of these.  See header block for the byte evidence. */
