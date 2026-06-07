/* ============================================================================
 *   DATA: NAMES.TXT @UNFORESTED/@FORESTED/@OTHER  |  mirrors runtime table 0x2F7B
 * ----------------------------------------------------------------------------
 * Rebuilt 2026-05-30 from NAMES.TXT. The previous version was FULLY FABRICATED
 * (docs/RULINGS.md 2026-05-30): the terrain ids were shifted (it labeled Ocean
 * "Tundra"), 18/19 food yields were wrong (inflated +1), it invented F_Arc and
 * Lake rows and omitted Ocean/Sea Lane, and carried four fabricated auxiliary
 * tables (PRIME_BONUS/FOREST_BONUS/RIVER_BONUS/EXPERT_FOR) with a wrong
 * occupation enum, plus a fake offset 0x05000.
 *
 * This table mirrors the runtime per-terrain yield table at DGROUP:0x2F7B
 * ([terrain_id*16 + good_id], stride 16), which the game POPULATES FROM
 * NAMES.TXT at startup (write site @asm 0x07463D; reader compute_terrain_yield
 * @0x9B9C). The EXE image stores zeros there — see src/data/production.c, which
 * is the byte-verified loader posture. Values below are the NAMES.TXT contents
 * that loader writes.
 *
 * @source extracted/text/NAMES_sections.json @UNFORESTED/@FORESTED/@OTHER/@RESOURCE
 *   terrain line cols: move_cost, defense, (col2/col3 TBD), then 9 yields =
 *   Food, Sugar, Tobacco, Cotton, Furs, Lumber, Ore, Silver, Fish.
 * @order terrain_id per game_data.py TERR_* (NOT @ section order): Ocean=0 ..
 *   Hills=20; @UNFORESTED/@FORESTED/@OTHER are interleaved by id.
 * @xref colonize_sdl/engine/game_data.py TERRAIN_YIELD / *_MOVE_COST / *_DEFENSE.
 * ============================================================================ */
#include "viceroy_types.h"

/* good_id columns 0..15 (NAMES @CARGO order). Terrain produces only the 9 raw
 * goods (0..8); finished goods (9..15) are 0 here and made by production chains. */
const uint8_t TERRAIN_YIELD[21][16] = {
    /*                  Fd Su To Co Fr Lu Or Si Fi  -- finished 9..15 -- */
    /*  0 Ocean      */ { 0, 0, 0, 0, 0, 0, 0, 0, 3,  0,0,0,0,0,0,0 },
    /*  1 Sea Lane   */ { 0, 0, 0, 0, 0, 0, 0, 0, 3,  0,0,0,0,0,0,0 },
    /*  2 Tundra     */ { 2, 0, 0, 0, 0, 0, 2, 0, 0,  0,0,0,0,0,0,0 },
    /*  3 Desert     */ { 1, 0, 0, 1, 0, 0, 2, 0, 0,  0,0,0,0,0,0,0 },
    /*  4 Plains     */ { 4, 0, 0, 2, 0, 0, 1, 0, 0,  0,0,0,0,0,0,0 },
    /*  5 Prairie    */ { 2, 0, 0, 3, 0, 0, 0, 0, 0,  0,0,0,0,0,0,0 },
    /*  6 Grassland  */ { 2, 0, 3, 0, 0, 0, 0, 0, 0,  0,0,0,0,0,0,0 },
    /*  7 Savannah   */ { 3, 3, 0, 0, 0, 0, 0, 0, 0,  0,0,0,0,0,0,0 },
    /*  8 Marsh      */ { 2, 0, 2, 0, 0, 0, 2, 0, 0,  0,0,0,0,0,0,0 },
    /*  9 Swamp      */ { 2, 2, 0, 0, 0, 0, 2, 0, 0,  0,0,0,0,0,0,0 },
    /* 10 Boreal     */ { 1, 0, 0, 0, 3, 2, 1, 0, 0,  0,0,0,0,0,0,0 },
    /* 11 Scrub      */ { 1, 0, 0, 1, 2, 1, 1, 0, 0,  0,0,0,0,0,0,0 },
    /* 12 Mixed      */ { 2, 0, 0, 1, 3, 3, 0, 0, 0,  0,0,0,0,0,0,0 },
    /* 13 Broadleaf  */ { 1, 0, 0, 1, 2, 2, 0, 0, 0,  0,0,0,0,0,0,0 },
    /* 14 Conifer    */ { 1, 0, 1, 0, 2, 3, 0, 0, 0,  0,0,0,0,0,0,0 },
    /* 15 Tropical   */ { 2, 1, 0, 0, 2, 2, 0, 0, 0,  0,0,0,0,0,0,0 },
    /* 16 Wetland    */ { 1, 0, 1, 0, 2, 2, 1, 0, 0,  0,0,0,0,0,0,0 },
    /* 17 Rain       */ { 1, 1, 0, 0, 1, 2, 1, 0, 0,  0,0,0,0,0,0,0 },
    /* 18 Arctic     */ { 0, 0, 0, 0, 0, 0, 0, 0, 0,  0,0,0,0,0,0,0 },
    /* 19 Mountains  */ { 0, 0, 0, 0, 0, 0, 4, 1, 0,  0,0,0,0,0,0,0 },
    /* 20 Hills      */ { 1, 0, 0, 0, 0, 0, 4, 0, 0,  0,0,0,0,0,0,0 },
};

/* Per-terrain movement cost (col 0) and defense bonus (col 1) from NAMES.TXT,
 * same terrain_id order. (cols 2 and 3 of each line are not yet identified.) */
const uint8_t TERRAIN_MOVE_COST[21] = {
    1,1,1,1,1,1,1,1, 2,2, 2,1,2,2,2,2, 3,3, 2,3,2
};
const uint8_t TERRAIN_DEFENSE_BONUS[21] = {
    0,0,0,0,0,0,0,0, 1,1, 2,2,2,2,2,2, 2,3, 0,6,4
};

/* Resource-overlay bonus, indexed by resource_id (0 = none; 1..14 = @RESOURCE).
 * @source NAMES.TXT @RESOURCE ; @xref game_data.py RESOURCE_BONUS. */
const uint8_t RESOURCE_BONUS[15] = {
    0,   /* 0  none           */
    6,   /* 1  Depleted Mine  */
    3,   /* 2  Oasis          */
    4,   /* 3  Wheat          */
    6,   /* 4  Prime Cotton   */
    6,   /* 5  Prime Tobacco  */
    7,   /* 6  Prime Sugar    */
    4,   /* 7  Minerals       */
    5,   /* 8  Fishery        */
    6,   /* 9  Beaver         */
    6,   /* 10 Game           */
    6,   /* 11 Prime Timber   */
    6,   /* 12 Prime Timber   */
   12,   /* 13 Silver Deposit */
    6,   /* 14 Ore Deposit    */
};

/* REMOVED (fabricated, no NAMES/byte basis): PRIME_BONUS, FOREST_BONUS,
 * RIVER_BONUS, EXPERT_FOR, and the wrong occupation enum. Forest terrain is a
 * distinct terrain_id with its own row above (NOT a runtime "base + forest bit"
 * add). River/road/expert adjustments are applied in compute_terrain_yield
 * (steps 7..11, @0x9B9C) and are TBD pending decode of that function. */
