/* Internal sim declarations — NOT part of the public API (colopy_core.h).
 * Each function mirrors a named game.js function; citations live at the
 * definitions. */
#ifndef COLOPY_SIM_H
#define COLOPY_SIM_H

#include <stdint.h>

#include "colopy_state.h"

/* ---- RNG: the Microsoft C runtime LCG the engine ships ----------------- */
/* state = state*214013 + 2531011; result = (state>>16) & 0x7FFF — byte-read
 * at file 0x0103D4/0x0103C2 (game.js:3344, verified against live DOSBox RAM,
 * RULINGS 2026-08-06b). */
uint32_t rng_next(void);                    /* 0..0x7FFF */
int32_t  rng_range(int32_t lo, int32_t hi); /* func_00C322: lo+((r*(hi-lo+1))>>15) */

/* ---- map/tile queries (game.js:356-455, 2415) -------------------------- */
#define TERR_OCEAN   25
#define TERR_SEALANE 26
#define ROAD_BIT 0x08
#define PLOW_BIT 0x40
#define DEPLETED_BIT 0x80   /* port-runtime marker (engine resource plane unread) */

uint8_t map_at(int x, int y);               /* terrain byte, 0 off-map */
uint8_t map_improve(int x, int y);          /* masked to 0x48 like the JS import */
int  tile_terrain(uint8_t v);               /* v & 0x1F */
int  tile_water(uint8_t v);
int  tile_hills(uint8_t v);
int  tile_mountains(uint8_t v);
int  tile_river(uint8_t v);                 /* 0 none / 1 minor / 2 major */
int  tile_yield(uint8_t v, int col);        /* the nine-column terrain tables */

/* ---- goods & job tallies ---------------------------------------------- */
enum { FOOD = 0, SUGAR, TOBACCO, COTTON, FURS, LUMBER, ORE, SILVER, HORSES,
       RUM, CIGARS, CLOTH, COATS, TRADE, TOOLS, MUSKETS, N_GOODS };

typedef struct {
    int32_t out[N_GOODS];       /* net per good */
    int32_t gross[N_GOODS];     /* before converter consumption */
    int32_t consumed[N_GOODS];
    int32_t hammers, bells, crosses, teaching;
    int32_t centre;             /* the centre tile's food */
    int32_t eaten;              /* 2 * population, BYTE_VERIFIED @0xA5F2 */
    int32_t net_food;
    uint16_t outages;           /* bit per raw good that starved a converter */
} colony_output;

/* colonyProduce (game.js:2630) over the RECORD form; ci indexes CS.colonies
 * (production reads the RUNTIME SoL, which the importer seeds from the
 * record and update_sol then owns — the JS c.sol life cycle). */
void colony_produce(int ci, colony_output *r);
int  rt_sol(int ci);

/* Record-side helpers shared with later subsystems. */
int  colony_sol(const ColonyRecord *c);         /* % from +0xC2/+0xC6 */
uint64_t colony_buildings(const ColonyRecord *c); /* bit per @BUILDING id */
int  colony_has(const ColonyRecord *c, const char *building_name);

/* ---- movement (colopy_move.c) ------------------------------------------ */
int move_cost(int is_ship, int fx, int fy, int tx, int ty);   /* in thirds */
int terrain_move(uint8_t v);
int terrain_defence(uint8_t v);
int improve_work(uint8_t v);        /* pioneer work threshold column */

/* ---- combat (colopy_combat.c): the §14.1-14.3 modifier chain ----------- */
typedef struct {
    uint8_t type;            /* @UNIT row */
    uint8_t terrain;         /* the tile byte the unit stands on */
    uint8_t on_colony;
    uint8_t orders;          /* 5/6 = Fortify/Fortified */
    uint8_t is_defender;
    uint8_t damaged, veteran, fatigue, holds, artillery;
    uint8_t privateer_drake, spain_attacker, woi_ref_bombard;
    int8_t  difficulty;
} combat_params;
int combat_total(const combat_params *p);

/* ---- the Europe market (colopy_market.c) ------------------------------ */
int     market_bid(int good);
int     market_ask(int good);
int     market_boycotted(int good);
void    market_drift(void);
int32_t market_sell(int good, int32_t qty);
int32_t market_buy(int good, int32_t qty);
int32_t market_accum(int good);
void    market_reset_accum(void);   /* call at load: JS-importer semantics */

/* ---- the turn pipeline (colopy_turn.c) --------------------------------- */
void cr_reset_from_load(void);   /* seed runtime from the loaded records */
void colony_turn(int ci);
void turn_step_prefix(void);     /* the ported endTurn prefix */
void turn_step2(void);           /* improvements/immigration/congress/treasure */
int  unit_on_map_player(int ui);  /* JS G.units membership predicate */

/* Runtime state that lives beside the save image (JS object-model fields
 * with no record home). One entry per colony, parallel to CS.colonies. */
typedef struct {
    uint8_t  sol;                /* runtime SoL % (JS c.sol) */
    uint8_t  sol_band;           /* 0xFF = unset */
    uint8_t  latch;              /* 0x04 majority / 0x02 unanimous */
    int32_t  rebelA, rebelB;     /* EMA pair; 0 = unseeded */
    uint8_t  food_depleted, food_warned, ineff, sieged;
    uint8_t  tool_warned, cap_warned, vanished;
    uint16_t cargo_ready, outage_latch;
    int32_t  crosses_turn, bells_turn;
    uint8_t  taught[32];         /* schoolhouse per-student counters */
} colony_rt;

/* An immigrant on the Europe dock: kind 0 = @CLASS row, kind 1 = a
 * jobtrain expert (game.js rollImmigrant), kind 2 = the "Free Colonists"
 * literal. */
typedef struct { uint8_t kind, idx; } immigrant;

typedef struct {
    uint8_t upkeep_unpaid;       /* @UPKEEP half-rate latch */
    uint8_t time_changed;        /* @TIMECHANGE one-shot */
    int32_t crosses;             /* immigration accumulator (JS G.crosses) */
    int32_t bells_total;         /* whole-game bells (JS G.bellsTotal) */
    int16_t father_in_progress;  /* dat_fathers index, -1 = none */
    immigrant dock[3];           /* the three Europe dock candidates */
    immigrant dock_units[64];    /* recruits waiting on the dock */
    uint8_t n_dock_units;
    uint8_t tension[8];          /* per-tribe anger toward the player, 0..100 */
    uint8_t alarm[COLOPY_MAX_SETTLEMENTS];  /* per-village (JS v.alarm) */
    uint8_t unit_work[COLOPY_MAX_UNITS];    /* pioneer work counters */
    uint8_t unit_offered[COLOPY_MAX_UNITS]; /* treasure offer latch */
    colony_rt col[COLOPY_MAX_COLONIES];
} colopy_runtime;
extern colopy_runtime CR;

void roll_immigrant(immigrant *out);
const char *immigrant_name(const immigrant *m);

#endif /* COLOPY_SIM_H */
