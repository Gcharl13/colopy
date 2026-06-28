/* ============================================================================
 *                  >>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<
 * ----------------------------------------------------------------------------
 * The values, formulas, and offsets in this file are reconstructed from
 * accumulated playthrough knowledge and the project's prior reverse-engineering
 * work. They have NOT been confirmed by reading bytes from VICEROY.EXE or by
 * hand-decompiling the relevant overlay function.
 *
 * DO NOT TRUST any specific number, table value, or formula in this file
 * for gameplay decisions. To upgrade an entry to BYTE_VERIFIED, follow the
 * methodology in viceroy_source/VERIFICATION_LEDGER.md.
 *
 * Status of every claim in this file: RECONSTRUCTED (until proven otherwise).
 * ============================================================================ */

/* ============================================================================
 * building.h -- Colony building system
 * ----------------------------------------------------------------------------
 * Colonies have ~20 building slots. Each slot can hold a building
 * (Stockade, Fort, Town Hall, Carpenter's Shop, ..., Cathedral).
 * Buildings are identified by NAMES.TXT @BUILDING.
 *
 * ============================================================================ */
#ifndef VICEROY_BUILDING_H
#define VICEROY_BUILDING_H

#include "viceroy_types.h"

/* Building IDs = line index in NAMES.TXT @BUILDING (file order, 0..41).
 * Verified against extracted/text/NAMES_sections.json @BUILDING (42 rows) and
 * data/building_costs.c. (The earlier 1-based, BLD_NONE-prefixed, 39-entry order
 * was fabricated — it lacked the Capitol pair and the 3 Town Hall tiers.) */
enum BuildingId {
    BLD_STOCKADE              =  0,
    BLD_FORT                  =  1,
    BLD_FORTRESS              =  2,
    BLD_ARMORY                =  3,
    BLD_MAGAZINE              =  4,
    BLD_ARSENAL               =  5,
    BLD_DOCKS                 =  6,
    BLD_DRYDOCK               =  7,
    BLD_SHIPYARD              =  8,
    BLD_TOWN_HALL             =  9,   /* tiers: II=10, III=11 */
    BLD_TOWN_HALL_II          = 10,
    BLD_TOWN_HALL_III         = 11,
    BLD_SCHOOLHOUSE           = 12,
    BLD_COLLEGE               = 13,
    BLD_UNIVERSITY            = 14,
    BLD_WAREHOUSE             = 15,
    BLD_WAREHOUSE_EXPANSION   = 16,
    BLD_STABLE                = 17,
    BLD_CUSTOM_HOUSE          = 18,
    BLD_PRINTING_PRESS        = 19,
    BLD_NEWSPAPER             = 20,
    BLD_WEAVERS_HOUSE         = 21,
    BLD_WEAVERS_SHOP          = 22,
    BLD_TEXTILE_MILL          = 23,
    BLD_TOBACCONISTS_HOUSE    = 24,
    BLD_TOBACCONISTS_SHOP     = 25,
    BLD_CIGAR_FACTORY         = 26,
    BLD_RUM_DISTILLERS_HOUSE  = 27,
    BLD_RUM_DISTILLERY        = 28,
    BLD_RUM_FACTORY           = 29,
    BLD_CAPITOL               = 30,
    BLD_CAPITOL_EXPANSION     = 31,
    BLD_FUR_TRADERS_HOUSE     = 32,
    BLD_FUR_TRADING_POST      = 33,
    BLD_FUR_FACTORY           = 34,
    BLD_CARPENTERS_SHOP       = 35,
    BLD_LUMBER_MILL           = 36,
    BLD_CHURCH                = 37,
    BLD_CATHEDRAL             = 38,
    BLD_BLACKSMITHS_HOUSE     = 39,
    BLD_BLACKSMITHS_SHOP      = 40,
    BLD_IRON_WORKS            = 41,
    BLD_COUNT                 = 42,
    BLD_NONE                  = 0xFF, /* sentinel — NOT a table index (Stockade is 0) */
};

/* ----------------------------------------------------------------------------
 * Building cost / hammer table
 * ----------------------------------------------------------------------------
 * Each @BUILDING row carries: cost(hammers 39..400), tools(*10 => 0..200),
 * size class, min_colony size, and upkeep (gold/turn). See data/building_costs.c
 * for the full 42-row table. The data is LOADED FROM NAMES.TXT @BUILDING at game
 * start (func_0749E0) — it is NOT a static table in the EXE image. (The earlier
 * "stored at file offset 0x01DB32" claim was fabricated and removed.)
 */

/* ----------------------------------------------------------------------------
 * Sons of Liberty / Tory tracking
 * ---------------------------------------------------------------------------- */

/* Sons of Liberty membership %% per colony (drives revolution support) */
/* Tory sentiment is the inverse: 100 - sol_pct */

/* When colony hits 50% SoL, certain bonuses kick in (production +50% for
 * non-food, etc.). At 100% SoL, military units get the rebellion bonus. */

#endif /* VICEROY_BUILDING_H */
