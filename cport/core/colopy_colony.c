/* Colony production — colonyProduce (game.js:2630) and its helpers, ported
 * over the RECORD form: occupation/profession are @JOB row bytes, worker
 * cells come from the +0x70 slot table, buildings from the +0x84 tier-packed
 * field. Where the JS works on names, this works on the same table indexes
 * the names came from; every JS-side citation (EXE offsets) carries over.
 */
#include <string.h>

#include "colopy_sim.h"
#include "../data/colopy_data.h"

/* @JOB row -> produced good (game.js:2435 JOB_GOOD). Negative ids are the
 * accumulators: -1 hammers, -2 bells, -3 crosses, -4 teaching. */
#define J_HAMMERS  (-1)
#define J_BELLS    (-2)
#define J_CROSSES  (-3)
#define J_TEACHING (-4)
#define J_NONE     (-99)
static const int8_t JOB_GOOD[19] = {
    FOOD, SUGAR, TOBACCO, COTTON, FURS, LUMBER, ORE, SILVER, FOOD,
    RUM, CIGARS, CLOTH, COATS, J_HAMMERS, TOOLS, MUSKETS,
    J_CROSSES, J_BELLS, J_TEACHING,
};
static int job_good(int job) {
    return (job >= 0 && job < 19) ? JOB_GOOD[job] : J_NONE;
}

/* Raw input per finished good (game.js:2466 RAW_FOR; five chains byte-cited
 * @0xA660..0xA68C, hammers<-lumber PEDIA @BUILDING35, muskets<-tools the
 * port's own reading, flagged there). -1 = no raw needed. */
static int raw_for(int g) {
    switch (g) {
    case RUM:       return SUGAR;
    case CIGARS:    return TOBACCO;
    case CLOTH:     return COTTON;
    case COATS:     return FURS;
    case TOOLS:     return ORE;
    case MUSKETS:   return TOOLS;
    case J_HAMMERS: return LUMBER;
    default:        return -1;
    }
}

/* Worker-slot -> cell offsets, N,E,S,W,NW,NE,SE,SW (game.js:10338
 * CELL_OF_WORKER; order pinned by census3 Jamestown). */
static const int8_t CELL_DX[8] = { 0, 1, 0, -1, -1, 1, 1, -1 };
static const int8_t CELL_DY[8] = { -1, 0, 1, 0, -1, -1, 1, 1 };

/* The tier-packed buildings field (+0x84): [bit base, width, chain length]
 * per family, family base bit == its chain's first @BUILDING index
 * (game.js:10358 FAMS, pinned bit-exactly by census3_build_picker,
 * RULINGS 2026-08-08h). */
static const uint8_t FAMS[][3] = {
    {0,3,3},{3,3,3},{6,3,3},{9,3,3},{12,3,3},{15,1,1},{17,1,1},{18,1,1},
    {19,2,2},{21,3,3},{24,3,3},{27,3,3},{30,2,2},{32,3,3},{35,2,2},
    {37,2,2},{39,3,3},
};

uint64_t colony_buildings(const ColonyRecord *c) {
    uint64_t built = 0;
    for (unsigned f = 0; f < sizeof(FAMS) / sizeof(FAMS[0]); f++) {
        int lo = FAMS[f][0], w = FAMS[f][1], len = FAMS[f][2];
        int t = 0;
        for (int j = 0; j < w; j++)
            t |= ((c->buildings[(lo + j) >> 3] >> ((lo + j) & 7)) & 1) << j;
        if (t > len) t = len;
        for (int j = 0; j < t; j++) built |= 1ull << (lo + j);
    }
    return built;
}

static int building_index(const char *name) {
    for (int i = 0; i < DAT_BUILDINGS_COUNT; i++)
        if (strcmp(dat_buildings[i].name, name) == 0) return i;
    return -1;
}
int colony_has(const ColonyRecord *c, const char *building_name) {
    int i = building_index(building_name);
    if (i < 0) return 0;
    if (colony_buildings(c) & (1ull << i)) return 1;
    /* warehouse_level >= 2 stands the Expansion (game.js:10368) */
    if (c->warehouse_level >= 2 &&
        strcmp(building_name, "Warehouse Expansion") == 0) return 1;
    return 0;
}

/* The workplaces (game.js:2451): a job id and its building chain, first
 * link's @BUILDING index + chain length (chain rows are consecutive in
 * @BUILDING — that is what makes the tier-packing work). Job ids resolved
 * from dat_jobs once at first use. */
typedef struct { const char *job; const char *first; int len; int job_id; int first_id; } workplace;
static workplace WP[] = {
    { "Weaver",      "Weaver's House",       3, -2, -2 },
    { "Tobacconist", "Tobacconist's House",  3, -2, -2 },
    { "Distiller",   "Rum Distiller's House",3, -2, -2 },
    { "Fur Trader",  "Fur Trader's House",   3, -2, -2 },
    { "Blacksmith",  "Blacksmith's House",   3, -2, -2 },
    { "Gunsmith",    "Armory",               3, -2, -2 },
    { "Carpenter",   "Carpenter's Shop",     2, -2, -2 },
    { "Statesman",   "Town Hall",            1, -2, -2 },
    { "Preacher",    "Church",               2, -2, -2 },
    { "Teacher",     "Schoolhouse",          3, -2, -2 },
};
#define N_WP (sizeof(WP) / sizeof(WP[0]))

static void wp_resolve(void) {
    if (WP[0].job_id != -2) return;
    for (unsigned i = 0; i < N_WP; i++) {
        WP[i].job_id = -1;
        for (int j = 0; j < DAT_JOBS_COUNT; j++)
            if (strcmp(dat_jobs[j], WP[i].job) == 0) { WP[i].job_id = j; break; }
        WP[i].first_id = building_index(WP[i].first);
    }
}

/* chainCount (game.js:2478): links of the job's chain the colony owns. */
static int chain_count(const ColonyRecord *c, int job) {
    wp_resolve();
    uint64_t built = colony_buildings(c);
    for (unsigned i = 0; i < N_WP; i++) {
        if (WP[i].job_id != job) continue;
        int n = 0;
        for (int j = 0; j < WP[i].len; j++)
            if (built & (1ull << (WP[i].first_id + j))) n++;
        /* the Expansion counts for the warehouse family only — not part of
         * any workplace chain, so nothing to add here */
        return n;
    }
    return 0;
}

/* SoL % from the record's EMA pair (importer: game.js:10395-10405). */
int colony_sol(const ColonyRecord *c) {
    if (c->rebel_divisor <= 0) return 0;
    long v = (100l * c->rebel_dividend + c->rebel_divisor / 2) / c->rebel_divisor;
    if (v < 0) v = 0;
    if (v > 100) v = 100;
    return (int)v;
}

/* toryPenalty (game.js:2516, byte-verified @0x9D14..0x9D98): every
 * (10 - difficulty) Tories costs 1; the 50%/100% latches give one back. */
static int tory_penalty(const ColonyRecord *c) {
    int pop = c->population;
    int sol = colony_sol(c);
    int tories = (pop * (100 - sol) + 50) / 100;
    int d = -(tories / (10 - cs_difficulty()));
    if (sol >= 50) d += 1;
    if (sol >= 100) d += 1;
    return d;
}

/* isExpert (game.js:2526): the colonist's profession byte is a @JOB row;
 * expert when its expert TITLE matches the working job's expert title
 * (title comparison, exactly as the JS compares the strings). */
static int is_expert(uint8_t prof, int job) {
    if (prof < 1 || prof >= DAT_JOBEXPERT_COUNT) return 0;
    if (job < 0 || job >= DAT_JOBEXPERT_COUNT) return 0;
    return strcmp(dat_jobexpert[prof], dat_jobexpert[job]) == 0;
}

/* improvementBonus (game.js:2535, byte-verified @0x9EC6..0x9F23): ROAD adds
 * for goods > 3, PLOW for goods <= 3; the bonus is 2 for lumber or a
 * river tile, else 1. */
static int improvement_bonus(int x, int y, int g) {
    uint8_t imp = map_improve(x, y);
    if (!imp) return 0;
    int bonus = (g == LUMBER || tile_river(map_at(x, y))) ? 2 : 1;
    if ((imp & ROAD_BIT) && g > 3) return bonus;
    if ((imp & PLOW_BIT) && g <= 3) return bonus;
    return 0;
}

/* Jan de Witt is consulted by updateSoL, not production; production reads
 * the record's stored ratio. (Kept here as the one fathers query production
 * will need when the SoL update lands in the turn step.) */

/* fieldYield (game.js:2544) for colonist k standing on worker slot cell. */
static int field_yield(const ColonyRecord *c, int job, uint8_t prof,
                       int dx, int dy) {
    int g = job_good(job);
    if (g == J_NONE || g < 0) return 0;
    int x = c->map_x + dx, y = c->map_y + dy;
    uint8_t v = map_at(x, y);
    int col = tile_water(v) ? 8 : g;
    int yld = tile_yield(v, col);
    if (yld <= 0) return 0;
    if (g == SILVER && (map_improve(x, y) & DEPLETED_BIT)) yld = 1;
    yld += improvement_bonus(x, y, g);
    /* easy-difficulty bonus on the plow group (capture-fitted, FLAGGED in
     * game.js:2558) */
    if (g <= 3) {
        if (cs_difficulty() == 0) yld += 2;
        else if (cs_difficulty() == 1) yld += 1;
    }
    yld += tory_penalty(c);
    if (is_expert(prof, job)) {
        if (g == FOOD || g == HORSES) yld += 2; else yld *= 2;
    }
    return yld > 0 ? yld : 0;
}

/* indoorRate (game.js:2508): 3 base, 6 with the second link; the INDOOR_BASE
 * itself is the port's reading (no rate column exists in @BUILDING), the
 * factory-tier 2/3 raw cost IS byte-verified (@0x8EB1). */
static int indoor_yield(const ColonyRecord *c, int job, uint8_t prof) {
    int rate = chain_count(c, job) >= 2 ? 6 : 3;
    int y = rate + tory_penalty(c);
    if (is_expert(prof, job)) y *= 2;
    if (CR.upkeep_unpaid) y /= 2;
    return y > 0 ? y : 0;
}

/* The nine field jobs are @JOB rows 0..8 (game.js:2596 FIELD_JOBS). */
static int is_field_job(int job) { return job >= 0 && job <= 8; }

void colony_produce(const ColonyRecord *c, colony_output *r) {
    memset(r, 0, sizeof(*r));
    r->crosses = 1;   /* the churchless base cross, census3 [0x8DEA]=1 */

    /* centre tile (compute_colony_center_yields func_00A222, read end to end
     * @0x00A247..0x00A33F; band ladder + difficulty + plow + SoL latches;
     * the forest fold models the auto-clear at founding — FLAGGED in
     * game.js:2646). Prime-resource +2 is TBD (no resource model). */
    uint8_t cv = map_at(c->map_x, c->map_y);
    int ct = tile_terrain(cv);
    if (ct >= 8 && ct <= 23) ct = ct >= 16 ? ct - 16 : ct - 8;
    int band = ct == 24 ? 0 : ct == 1 ? 1 : (ct == 27 || ct == 28) ? 2 : 3;
    int centre = band;
    if (cs_difficulty() == 0) centre += 2;
    else if (cs_difficulty() == 1) centre += 1;
    centre += improvement_bonus(c->map_x, c->map_y, FOOD);
    int sol = colony_sol(c);
    if (sol >= 50) centre += 1;
    if (sol >= 100) centre += 1;
    r->centre = centre;
    r->out[FOOD] += centre;

    /* which colonist stands on which worker cell (+0x70 slot table) */
    int8_t cell_of[32];
    memset(cell_of, -1, sizeof(cell_of));
    for (int k = 0; k < 8; k++) {
        int w = (uint8_t)c->tiles[k];
        if (w != 0xFF && w < c->population && w < 32) cell_of[w] = (int8_t)k;
    }

    /* fields first, indoor collected (game.js:2663) */
    int indoor[32], n_indoor = 0;
    for (int k = 0; k < c->population && k < 32; k++) {
        int job = c->occupation[k];
        if (job >= DAT_JOBS_COUNT) continue;            /* no job */
        if (cell_of[k] >= 0) {
            int g = job_good(job);
            if (g >= 0)
                r->out[g] += field_yield(c, job, c->profession[k],
                                         CELL_DX[cell_of[k]], CELL_DY[cell_of[k]]);
        } else if (is_field_job(job)) {
            /* a field job with no field rests in the plaza (importer rule,
             * game.js:10393) */
            continue;
        } else {
            indoor[n_indoor++] = k;
        }
    }

    /* converter chains (game.js:2674): output capped by raw on hand + this
     * turn's field intake; factory tier (3rd link, @0x8EA9) pays 2/3 raw
     * (@0x8EB1). */
    for (int i = 0; i < n_indoor; i++) {
        int k = indoor[i];
        int job = c->occupation[k];
        int g = job_good(job);
        if (g == J_NONE) continue;
        int want = indoor_yield(c, job, c->profession[k]);
        int raw = raw_for(g);
        if (raw >= 0) {
            int factory = chain_count(c, job) > 2;
            int avail = c->stock[raw] + r->out[raw] - r->consumed[raw];
            int potential = want;
            while (want > 0) {
                int cost = factory ? (want * 2) / 3 : want;
                if (cost <= avail) break;
                want--;
            }
            if (potential > 0 && want == 0) r->outages |= (uint16_t)(1u << raw);
            r->consumed[raw] += factory ? (want * 2) / 3 : want;
        }
        if (g >= 0) r->out[g] += want;
        else if (g == J_HAMMERS) r->hammers += want;
        else if (g == J_BELLS) r->bells += want;
        else if (g == J_CROSSES) r->crosses += want;
        else if (g == J_TEACHING) r->teaching += want;
    }

    memcpy(r->gross, r->out, sizeof(r->gross));
    for (int i = 0; i < N_GOODS; i++) r->out[i] -= r->consumed[i];
    r->eaten = 2 * c->population;               /* BYTE_VERIFIED @0xA5F2 */
    r->net_food = r->out[FOOD] - r->eaten;
}
