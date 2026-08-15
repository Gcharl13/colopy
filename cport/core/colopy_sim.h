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

/* colonyProduce (game.js:2630) over the RECORD form. */
void colony_produce(const ColonyRecord *c, colony_output *r);

/* Record-side helpers shared with later subsystems. */
int  colony_sol(const ColonyRecord *c);         /* % from +0xC2/+0xC6 */
uint64_t colony_buildings(const ColonyRecord *c); /* bit per @BUILDING id */
int  colony_has(const ColonyRecord *c, const char *building_name);

/* ---- the Europe market (colopy_market.c) ------------------------------ */
int     market_bid(int good);
int     market_ask(int good);
int     market_boycotted(int good);
void    market_drift(void);
int32_t market_sell(int good, int32_t qty);
int32_t market_buy(int good, int32_t qty);
int32_t market_accum(int good);
void    market_reset_accum(void);   /* call at load: JS-importer semantics */

/* Runtime flags that live beside the save image (not in it). */
typedef struct {
    uint8_t upkeep_unpaid;      /* @UPKEEP half-rate latch */
} colopy_runtime;
extern colopy_runtime CR;

#endif /* COLOPY_SIM_H */
