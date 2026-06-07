/* >>> VALUES ARE [TBD — EXTERNAL DATA FILE], NOT BYTE-VERIFIED <<<
 * This balance table is NOT embedded in VICEROY.EXE. It is parsed at runtime
 * from a COLONIZE/*.TXT data file (NAMES.TXT/COLONY.TXT/TRIBE.TXT) into a BSS
 * buffer (DS offset > 0x2CC5). The numeric values below are RECONSTRUCTED and
 * must not be trusted until the .TXT data files are supplied and parsed.
 * Only the struct LAYOUT (stride/field order) is byte-anchored. See README.md
 * and docs/DATA_TABLES.md.  (banner added 2026-06-07) */

/* ============================================================================
 *   DATA: NAMES.TXT @SCENARIO (verified)  |  per-difficulty curves: REMOVED
 * ----------------------------------------------------------------------------
 * Rebuilt 2026-05-30 from NAMES.TXT @SCENARIO. The previous version was
 * FABRICATED (docs/RULINGS.md 2026-05-30): the AMER2 starts were all wrong
 * (it had every power at x=56; the real coords are below), and three of the
 * four "stock map" tables (AMER3, BLANK4, ONE) described scenarios that do
 * not exist — @SCENARIO defines only AMER2 and AMERICA. The
 * STARTING_TREASURY / STARTING_BELLS / STARTING_RECRUITS per-difficulty curves
 * were uncited guesses (the only concrete datapoint is a flat 1000 starting
 * gold, colonize_sdl/engine/game.py) and have been removed. The fabricated
 * DGROUP offset 0x08400 (below the 0x10000 DGROUP base) was removed too.
 *
 * @source extracted/text/NAMES_sections.json @SCENARIO ; raw COLONIZE/NAMES.TXT
 *   line spec: "; map file, x0,y0, x1,y1, x2,y2, x3,y3"  (4 powers x,y)
 *     AMER2,   34,20, 39,10, 47,61, 50,33
 *     AMERICA, 56,27, 67,12, 66,42, 84,65
 * Power order 0..3 = England, France, Spain, Netherlands (@COUNTRY/@HOMEPORT).
 * Verified in-bounds: AMER2 x{34,39,47,50}<56 (MAP_WIDTH), y{20,10,61,33}<72.
 * ============================================================================ */
#include "viceroy_types.h"

/* Stock scenarios actually present in @SCENARIO (only these two). */
#define SCENARIO_AMER2    0
#define SCENARIO_AMERICA  1
#define SCENARIO_COUNT    2

/* Per-power starting tile. NOTE: @SCENARIO carries ONLY the x,y coordinates;
 * the starting unit/ship loadout is not in this section (TBD — sourced from
 * the new-game setup code, not yet traced). */
struct ScenarioStart {
    uint8_t map_x;   /* @SCENARIO column 2k   */
    uint8_t map_y;   /* @SCENARIO column 2k+1 */
};

/* [scenario][power 0..3 = England, France, Spain, Netherlands] */
const struct ScenarioStart SCENARIO_STARTS[SCENARIO_COUNT][4] = {
    /* AMER2   */ { { 34, 20 }, { 39, 10 }, { 47, 61 }, { 50, 33 } },
    /* AMERICA */ { { 56, 27 }, { 67, 12 }, { 66, 42 }, { 84, 65 } },
};

/* Map-file name per scenario id (the @SCENARIO row label, ".MP" implied). */
const char *const SCENARIO_MAP[SCENARIO_COUNT] = { "AMER2", "AMERICA" };

/* ----------------------------------------------------------------------------
 * TBD (removed fabricated curves):
 *   - Starting treasury/bells/recruits per difficulty: not in NAMES.TXT and not
 *     byte-traced. Only datapoint is a flat 1000 gold (game.py). The real
 *     difficulty effects live in @DIFFICULTY (NAMES.TXT) + overlay setup code.
 *   - Starting unit/ship loadout per power: not in @SCENARIO.
 * Recover these from the new-game init code before re-adding any values.
 * ---------------------------------------------------------------------------- */
