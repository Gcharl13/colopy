/* >>> VALUES ARE [RUNTIME_ONLY (data-resident) — EXTERNAL DATA FILE], NOT BYTE-VERIFIED <<<
 * This balance table is NOT embedded in VICEROY.EXE. It is parsed at runtime
 * from a COLONIZE/*.TXT data file (NAMES.TXT/COLONY.TXT/TRIBE.TXT) into a BSS
 * buffer (DS offset > 0x2CC5). The numeric values below are RECONSTRUCTED and
 * must not be trusted until the .TXT data files are supplied and parsed.
 * Only the struct LAYOUT (stride/field order) is byte-anchored. See README.md
 * and docs/DATA_TABLES.md.  (banner added 2026-06-07) */

/* ============================================================================
 *   DATA: NAMES.TXT @BUILDING (verified)  |  loaded at runtime, not a static EXE table
 * ----------------------------------------------------------------------------
 * Rebuilt 2026-05-30 from NAMES.TXT @BUILDING. The previous version was
 * fabricated (docs/RULINGS.md 2026-05-30): only 39 rows in a custom order with a
 * leading BLD_NONE, the Capitol + Capitol Expansion missing, Town Hall collapsed
 * into one fake 0-cost entry, several hammer values wrong (Carpenter's Shop,
 * Lumber Mill, Printing Press), upkeep zeroed everywhere, and three invented
 * columns (base_output, prereq_id, sprite_idx) plus a fake offset 0x01DB32.
 *
 * @source extracted/text/NAMES_sections.json @BUILDING ; raw COLONIZE/NAMES.TXT.
 *   @BUILDING legend: "name, cost(hammers), tools(*10), size, min_colony, upkeep"
 *   42 rows, file order (= the building id). Loaded at game start (func_0749E0);
 *   the numeric values are NOT a static table in the EXE image.
 * @xref colonize_sdl/engine/game_data.py (same @BUILDING parse).
 * @ref ../include/building.h  (BuildingId enum, same @BUILDING order)
 * ============================================================================ */
#include "viceroy_types.h"
#include "building.h"

/* One record per @BUILDING row. NOTE: `tools_x10` is the raw NAMES.TXT column;
 * the actual tools requirement is tools_x10 * 10 (per the "tools(*10)" legend).
 * `size` is the building's size class; `min_colony` is the minimum colony size
 * required to build it. No prereq/output/sprite columns exist in @BUILDING. */
struct BuildingCost {
    int16_t hammers;     /* @BUILDING col "cost"       */
    int16_t tools_x10;   /* @BUILDING col "tools(*10)" — actual tools = *10 */
    int16_t size;        /* @BUILDING col "size"       */
    int16_t min_colony;  /* @BUILDING col "min_colony" */
    int16_t upkeep;      /* @BUILDING col "upkeep" (gold/turn) */
};

const struct BuildingCost BUILDING_COST_TABLE[42] = {
    /*  0 Stockade              */ {  64,  0, 3,  3,  0 },
    /*  1 Fort                  */ { 120, 10, 3,  3, 10 },
    /*  2 Fortress              */ { 320, 20, 3,  8, 15 },
    /*  3 Armory                */ {  52,  0, 1,  1,  5 },
    /*  4 Magazine              */ { 120,  5, 1,  8, 10 },
    /*  5 Arsenal               */ { 240, 10, 1,  8, 15 },
    /*  6 Docks                 */ {  52,  0, 4,  1,  5 },
    /*  7 Drydock               */ {  80,  5, 4,  4, 10 },
    /*  8 Shipyard              */ { 240, 10, 4,  8, 15 },
    /*  9 Town Hall             */ {  64,  0, 2,  1,  0 },
    /* 10 Town Hall (II)        */ {  64,  5, 2,  4, 10 },
    /* 11 Town Hall (III)       */ { 120, 10, 2,  8, 15 },
    /* 12 Schoolhouse           */ {  64,  0, 1,  4,  5 },
    /* 13 College               */ { 160,  5, 1,  8, 10 },
    /* 14 University            */ { 200, 10, 1, 10, 15 },
    /* 15 Warehouse             */ {  80,  0, 1,  1,  5 },
    /* 16 Warehouse Expansion   */ {  80,  2, 1,  1,  5 },
    /* 17 Stable                */ {  64,  0, 0,  1,  5 },
    /* 18 Custom House          */ { 160,  5, 0,  1, 15 },
    /* 19 Printing Press        */ {  52,  2, 0,  1,  5 },
    /* 20 Newspaper             */ { 120,  5, 0,  4, 10 },
    /* 21 Weaver's House        */ {  64,  0, 0,  1,  0 },
    /* 22 Weaver's Shop         */ {  64,  2, 0,  1,  5 },
    /* 23 Textile Mill          */ { 160, 10, 0,  8, 15 },
    /* 24 Tobacconist's House   */ {  64,  0, 0,  1,  0 },
    /* 25 Tobacconist's Shop    */ {  64,  2, 0,  1,  5 },
    /* 26 Cigar Factory         */ { 160, 10, 0,  8, 15 },
    /* 27 Rum Distiller's House */ {  64,  0, 0,  1,  0 },
    /* 28 Rum Distillery        */ {  64,  2, 0,  1,  5 },
    /* 29 Rum Factory           */ { 160, 10, 0,  8, 15 },
    /* 30 Capitol               */ { 400, 10, 2, 16, 20 },
    /* 31 Capitol Expansion     */ { 400, 10, 2, 16, 10 },
    /* 32 Fur Trader's House    */ {  56,  0, 0,  1,  0 },
    /* 33 Fur Trading Post      */ {  56,  2, 0,  1,  5 },
    /* 34 Fur Factory           */ { 160, 10, 0,  6, 15 },
    /* 35 Carpenter's Shop      */ {  39,  0, 1,  1,  0 },
    /* 36 Lumber Mill           */ {  52,  0, 1,  3, 10 },
    /* 37 Church                */ {  64,  0, 2,  3,  5 },
    /* 38 Cathedral             */ { 176, 10, 2,  8, 15 },
    /* 39 Blacksmith's House    */ {  64,  0, 0,  1,  0 },
    /* 40 Blacksmith's Shop     */ {  64,  2, 0,  1,  5 },
    /* 41 Iron Works            */ { 240, 10, 0,  8, 15 },
};
