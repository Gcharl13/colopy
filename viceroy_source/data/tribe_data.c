/* >>> VALUES ARE [TBD — EXTERNAL DATA FILE], NOT BYTE-VERIFIED <<<
 * This balance table is NOT embedded in VICEROY.EXE. It is parsed at runtime
 * from a COLONIZE/*.TXT data file (NAMES.TXT/COLONY.TXT/TRIBE.TXT) into a BSS
 * buffer (DS offset > 0x2CC5). The numeric values below are RECONSTRUCTED and
 * must not be trusted until the .TXT data files are supplied and parsed.
 * Only the struct LAYOUT (stride/field order) is byte-anchored. See README.md
 * and docs/DATA_TABLES.md.  (banner added 2026-06-07) */

/* ============================================================================
 *   VERIFIED DATA: NAMES.TXT @TRIBES  |  BEHAVIOURAL PARAMS: TBD (not traced)
 * ----------------------------------------------------------------------------
 * Corrected 2026-05-30. The previous version of this file was almost entirely
 * FABRICATED ("RECONSTRUCTED — NOT BYTE-VERIFIED") and got the basics wrong:
 *   - tribe ORDER was Aztec=0/Inca=1/Tupi=3/Apache=4 — matched neither the
 *     canonical @TRIBES order nor the engine; corrected below.
 *   - `type` was a BINARY 0=Nomadic/1=Advanced flag — the game has FOUR
 *     advancement levels (@LEVELS); corrected to the 0..3 level.
 *   - `base_wealth` values (Apache 45 > Arawak 40 > Tupi 35, etc.) did not
 *     track the advancement level and had no citation — REMOVED.
 *   - DGROUP offset 0x09800 / "24-byte stride" had no @asm citation — REMOVED.
 *
 * The ONLY byte-/file-grounded native tribe data we currently have is
 * NAMES.TXT @TRIBES (8 playable tribes) and @LEVELS (the advancement tiers).
 * Per-tribe BEHAVIOURAL parameters (aggression, settlement population, warrior
 * fraction, skills taught, goods wanted, raze-treasure magnitude) are real in
 * the game but are NOT in @TRIBES — they live in overlay-resident tables that
 * have not been traced. They are marked TBD here, not guessed.
 *
 * @source extracted/text/NAMES_sections.json  @TRIBES, @LEVELS
 * @xref   colonize_sdl/engine/game_data.py  TRIBE_DEFS (same @TRIBES parse)
 * @xref   ../src/native/settlement.c  (runtime per-tribe record @0x8D52:
 *         settlement-count byte @-0x69D6, eliminated flag at +3 bit 0x80)
 * @ref    ../include/native.h   (NativeSettlement layout; tribe ids; @LEVELS)
 * ============================================================================ */
#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * VERIFIED — NAMES.TXT @TRIBES, in file order (= the tribe id 0..7).
 * Columns: plural, singular, treasure/gift type, advancement level (0..3 into
 * @LEVELS), VGA palette color index for the map marker.
 *   level 3 = Civilized, 2 = Advanced, 1 = Agrarian, 0 = Semi-Nomadic.
 * Wealth (raze treasure, gift value) scales with `level`: Civilized richest,
 * Semi-Nomadic poorest. So Inca/Aztec (3/2) >> Apache/Sioux/Tupi (0).
 * ---------------------------------------------------------------------------- */
struct TribeInfo {
    const char *name_plural;    /* @TRIBES col 0 */
    const char *name_singular;  /* @TRIBES col 1 */
    const char *treasure_type;  /* @TRIBES col 2 — gift / raze-treasure name  */
    uint8_t     level;          /* @TRIBES col 3 — 0..3, index into @LEVELS    */
    uint8_t     map_color;      /* @TRIBES col 4 — VICEROY.PAL index (NOT wealth) */
};

const struct TribeInfo TRIBE_INFO[8] = {
    /* id                       plural       singular     treasure          lvl  color */
    /* 0 */ { "Incas",    "Inca",     "Jewelled Relics", 3,  97 },  /* Civilized    */
    /* 1 */ { "Aztecs",   "Aztec",    "Gold Bars",       2, 149 },  /* Advanced     */
    /* 2 */ { "Arawaks",  "Arawak",   "Bone Jewelry",    1,  54 },  /* Agrarian     */
    /* 3 */ { "Iroquois", "Iroquois", "Wood Carvings",   1,  87 },  /* Agrarian     */
    /* 4 */ { "Cherokee", "Cherokee", "Turquoise",       1,  67 },  /* Agrarian     */
    /* 5 */ { "Apache",   "Apache",   "Beads",           0, 111 },  /* Semi-Nomadic */
    /* 6 */ { "Sioux",    "Sioux",    "Beads",           0, 118 },  /* Semi-Nomadic */
    /* 7 */ { "Tupi",     "Tupi",     "Gems",            0,  71 },  /* Semi-Nomadic */
};

/* ----------------------------------------------------------------------------
 * @LEVELS — advancement tier → settlement name (NAMES.TXT @LEVELS).
 * Index 0..3 is the tribe `level` above; index 4 ("<Any>") is the Capital,
 * applied to any tier's capital settlement (not a 5th advancement level).
 * ---------------------------------------------------------------------------- */
struct LevelInfo {
    const char *advancement;        /* "Semi-Nomadic" .. "Civilized" / "<Any>" */
    const char *settlement_name;    /* "Camp" / "Village" / "City" / "Capital" */
    const char *settlement_plural;
};

const struct LevelInfo LEVEL_INFO[5] = {
    { "Semi-Nomadic", "Camp",    "Camps"    },  /* 0 */
    { "Agrarian",     "Village", "Villages" },  /* 1 */
    { "Advanced",     "City",    "Cities"   },  /* 2 */
    { "Civilized",    "City",    "Cities"   },  /* 3 */
    { "<Any>",        "Capital", "Capitals" },  /* 4 — capital, any level */
};

/* ----------------------------------------------------------------------------
 * TBD — per-tribe BEHAVIOURAL parameters (NOT in NAMES.TXT @TRIBES).
 * ----------------------------------------------------------------------------
 * The game varies raid aggression, settlement population, warrior counts, the
 * skills a settlement teaches, and the goods a tribe pays well for — per tribe
 * and per settlement tier. These are real but UNVERIFIED: the old hard-coded
 * values for them were playthrough guesses and have been removed rather than
 * left masquerading as data. Recovering them requires tracing the native AI /
 * settlement-init tables (overlay-resident; see settlement.c @0x8D52 record).
 *
 * Likewise the raze-treasure magnitude per tier: the destruction handler
 * (src/native/native_village_raze.c, func_04A7CA) multiplies by a settlement
 * byte whose meaning is itself UNVERIFIED (it currently reads +0x02 = OWNER,
 * not a size) — so no trustworthy per-tier treasure multiplier exists yet.
 * TODO: native-behaviour-trace, native-raze-retrace.
 * ---------------------------------------------------------------------------- */
