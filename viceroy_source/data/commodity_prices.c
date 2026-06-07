/* >>> VALUES ARE [TBD — EXTERNAL DATA FILE], NOT BYTE-VERIFIED <<<
 * This balance table is NOT embedded in VICEROY.EXE. It is parsed at runtime
 * from a COLONIZE/*.TXT data file (NAMES.TXT/COLONY.TXT/TRIBE.TXT) into a BSS
 * buffer (DS offset > 0x2CC5). The numeric values below are RECONSTRUCTED and
 * must not be trusted until the .TXT data files are supplied and parsed.
 * Only the struct LAYOUT (stride/field order) is byte-anchored. See README.md
 * and docs/DATA_TABLES.md.  (banner added 2026-06-07) */

/* ============================================================================
 *   DATA: NAMES.TXT @CARGO (verified)  |  loaded at runtime, not a static EXE table
 * ----------------------------------------------------------------------------
 * Rebuilt 2026-05-30 from NAMES.TXT @CARGO. The previous version was FULLY
 * FABRICATED (docs/RULINGS.md 2026-05-30): it used an invented 8-field schema
 * (default_buy/sell/min/max/spread/volume_threshold/drift/decay) with ~13 of 16
 * rows numerically wrong, an invented COMMODITY_TAX_BONUS table, and a fabricated
 * static offset 0x07A00. The byte-verified loader (src/market/pricing.c) shows
 * the real schema is the 9 @CARGO economic columns, loaded into DGROUP:0x96FC at
 * game start — the numeric values are NOT in the EXE.
 *
 * @source extracted/text/NAMES_sections.json @CARGO ; raw COLONIZE/NAMES.TXT.
 *   @CARGO legend: "start1, start2, low, high, burden, rise, fall, attrition, volatility"
 *     Start1/2 = starting price (lowest/highest)   Low/High = price drift bounds
 *     Burden   = extra ask-bid spread (0 => ask is bid+1)
 *     Rise/Fall= traffic-volume thresholds at which price rises/falls
 *     Attrition= added to traffic volume each turn (price recovery; signed)
 *     Volatility = shift value for traffic volume
 * @xref src/market/pricing.c — g_cargo_param[good*9+field] @ DGROUP:0x96FC,
 *       loaded by @asm file 0x074DEC ("THE NUMERIC VALUES ARE NOT IN THE EXE").
 * @xref colonize_sdl/engine/game_data.py CARGO_DATA (same @CARGO parse).
 * ============================================================================ */
#include "viceroy_types.h"

/* One record per tradable good, mirroring the NAMES.TXT @CARGO columns. */
struct CargoParams {
    int16_t start1;      /* starting price, lowest  */
    int16_t start2;      /* starting price, highest */
    int16_t low;         /* price floor (lowest drift)  */
    int16_t high;        /* price ceiling (highest drift) */
    int16_t burden;      /* extra ask-bid spread (0 => ask = bid + 1) */
    int16_t rise;        /* traffic indicator at which price rises */
    int16_t fall;        /* traffic indicator at which price falls */
    int16_t attrition;   /* added to traffic volume each turn (signed) */
    int16_t volatility;  /* shift value for traffic volume */
};

/* The 16 tradable goods (good_id 0..15), @CARGO file order. Values verbatim
 * from NAMES.TXT @CARGO — do NOT "normalize" the negative attritions; they are
 * authentic (raw/finished goods recover downward, Trade Goods/Tools/Muskets up). */
const struct CargoParams CARGO_TABLE[16] = {
    /*  0 Food        */ {  1,  3,  1,  6,  7,  3,  2,  -1,  0 },
    /*  1 Sugar       */ {  4,  7,  3,  7,  1,  4,  6,  -8,  1 },
    /*  2 Tobacco     */ {  3,  5,  2,  5,  1,  4,  8, -10,  1 },
    /*  3 Cotton      */ {  2,  5,  2,  5,  1,  4,  6, -11,  1 },
    /*  4 Furs        */ {  4,  6,  2,  6,  1,  4, 20, -13,  1 },
    /*  5 Lumber      */ {  2,  2,  2,  2,  4,  3,  2,   0,  0 },
    /*  6 Ore         */ {  3,  6,  2,  6,  2,  2,  4,  -7,  0 },
    /*  7 Silver      */ { 20, 20,  2, 20,  0,  8,  1,  -8,  2 },
    /*  8 Horses      */ {  2,  3,  2, 11,  0,  3,  2,  -3,  0 },
    /*  9 Rum         */ { 11, 13,  1, 20,  0,  4,  4, -12,  1 },
    /* 10 Cigars      */ { 11, 13,  1, 20,  0,  4,  4, -11,  1 },
    /* 11 Cloth       */ { 11, 13,  1, 20,  0,  4,  4, -13,  1 },
    /* 12 Coats       */ { 11, 13,  1, 20,  0,  4,  4, -11,  1 },
    /* 13 Trade Goods */ {  2,  3,  2, 12,  0,  2,  3,   4,  0 },
    /* 14 Tools       */ {  2,  2,  2,  9,  0,  2,  2,   5,  0 },
    /* 15 Muskets     */ {  3,  3,  2, 20,  0,  2,  2,   6,  0 },
};
/* The 4 non-traded internal goods that follow in @CARGO (Hammers, Crosses,
 * Liberty Bells, Flags) carry no economic columns — they are never sold to
 * Europe, so they are intentionally omitted from CARGO_TABLE.
 *
 * REMOVED (fabricated): COMMODITY_TAX_BONUS[] — there is no per-commodity tax;
 * tax is the single PowerRecord+0x01 byte (src/market/boycott.c). The
 * price->coin bid/ask curve is overlay-resident (TBD); see pricing.c. */
