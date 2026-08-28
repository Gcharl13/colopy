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
/* the same map for the UI layer's popup notes ("job - made"): >= 0 is a
 * cargo id, the negatives are hammers/bells/crosses/teaching */
int colony_job_good(int job) { return job_good(job); }

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
/* the same table for the UI layer's scene-panel hit-test */
const int8_t colony_cell_dx[8] = { 0, 1, 0, -1, -1, 1, 1, -1 };
const int8_t colony_cell_dy[8] = { -1, 0, 1, 0, -1, -1, 1, 1 };

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

/* ---- the RUNTIME building list (JS c.buildings) ------------------------
 * Seeded in the importer's push order (game.js:10366-10373: FAMS families
 * ascending, then Warehouse Expansion), then owned by construction and the
 * raid removals — the record field cannot express a torn-out middle link,
 * so every sim-side query below reads THIS list, by NAME, exactly like the
 * JS includes()/find() calls it mirrors. */
void colony_bld_seed(int ci) {
    colony_rt *r = &CR.col[ci];
    const ColonyRecord *c = &CS.colonies[ci];
    uint64_t built = colony_buildings(c);
    r->n_bld = 0;
    for (int b = 0; b < DAT_BUILDINGS_COUNT && b < 48; b++)
        if ((built >> b) & 1) r->bld[r->n_bld++] = (uint8_t)b;
    if (c->warehouse_level >= 2) {
        int e = building_index("Warehouse Expansion");
        if (e >= 0 && !colony_has_name(ci, "Warehouse Expansion"))
            r->bld[r->n_bld++] = (uint8_t)e;
    }
}
int colony_has_name(int ci, const char *name) {
    const colony_rt *r = &CR.col[ci];
    for (int k = 0; k < r->n_bld; k++)
        if (strcmp(dat_buildings[r->bld[k]].name, name) == 0) return 1;
    return 0;
}
/* JS bldIndex / DATA.buildings.find(name): upgrade tiers reuse display
 * names (rows 9..11 are all "Town Hall"), and every JS name lookup lands
 * on the FIRST row. */
int bld_first_row(int idx) {
    for (int a = 0; a < idx; a++)
        if (strcmp(dat_buildings[a].name, dat_buildings[idx].name) == 0)
            return a;
    return idx;
}
void colony_bld_append(int ci, int idx) {
    colony_rt *r = &CR.col[ci];
    if (idx >= 0 && r->n_bld < sizeof(r->bld)) r->bld[r->n_bld++] = (uint8_t)idx;
}
/* splice(indexOf(name)) — remove the FIRST occurrence of the name
 * (game.js:5735). */
void colony_bld_remove_name(int ci, const char *name) {
    colony_rt *r = &CR.col[ci];
    for (int k = 0; k < r->n_bld; k++) {
        if (strcmp(dat_buildings[r->bld[k]].name, name) != 0) continue;
        memmove(&r->bld[k], &r->bld[k + 1], (size_t)(r->n_bld - k - 1));
        r->n_bld--;
        return;
    }
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

/* chainCount (game.js:2478): links of the job's chain the colony owns —
 * name membership over the RUNTIME list, like the JS includes(). */
int chain_count_i(int ci, int job) {
    wp_resolve();
    for (unsigned i = 0; i < N_WP; i++) {
        if (WP[i].job_id != job) continue;
        int n = 0;
        for (int j = 0; j < WP[i].len; j++)
            if (colony_has_name(ci, dat_buildings[WP[i].first_id + j].name))
                n++;
        /* the Expansion counts for the warehouse family only — not part of
         * any workplace chain, so nothing to add here */
        return n;
    }
    return 0;
}

/* workplaceFor/jobForBuilding (game.js:2464): the workplace whose chain
 * CONTAINS the building — tier rows share display names, so the match
 * is by NAME like the JS chain.includes().  Returns the job's dat_jobs
 * id, -1 when the building employs nobody. */
int workplace_job_for_name(const char *building_name) {
    wp_resolve();
    for (unsigned i = 0; i < N_WP; i++) {
        if (WP[i].first_id < 0) continue;
        for (int j = 0; j < WP[i].len; j++)
            if (strcmp(dat_buildings[WP[i].first_id + j].name,
                       building_name) == 0)
                return WP[i].job_id;
    }
    return -1;
}

/* SoL % from the record's EMA pair (importer: game.js:10395-10405).
 * FLOOR, not round: the DOS colony screen prints 36%% for Isabella
 * (107/292 = 36.64) and 5%% for Vlissingen (64/1082 = 5.92) on the
 * census fixture -- two independent live frames, and the engine's
 * integer division truncates.  The old +divisor/2 rounding read both
 * one high. */
int colony_sol(const ColonyRecord *c) {
    if (c->rebel_divisor <= 0) return 0;
    long v = (100l * c->rebel_dividend) / c->rebel_divisor;
    if (v < 0) v = 0;
    if (v > 100) v = 100;
    return (int)v;
}

/* toryPenalty (game.js:2516, byte-verified @0x9D14..0x9D98): every
 * (10 - difficulty) Tories costs 1; the 50%/100% latches give one back.
 * Reads the RUNTIME sol (JS c.sol), passed down from colony_produce. */
static int tory_penalty(const ColonyRecord *c, int sol) {
    int pop = c->population;
    int tories = (pop * (100 - sol) + 50) / 100;
    int d = -(tories / (10 - cs_difficulty()));
    if (sol >= 50) d += 1;
    if (sol >= 100) d += 1;
    return d;
}

/* isExpert (game.js:2526): the colonist's profession byte is a @JOB row;
 * expert when its expert TITLE matches the working job's expert title
 * (title comparison, exactly as the JS compares the strings). */
int colony_is_expert(uint8_t prof, int job);   /* UI layer's bestFieldJob */
static int is_expert(uint8_t prof, int job) {
    if (prof < 1 || prof >= DAT_JOBEXPERT_COUNT) return 0;
    if (job < 0 || job >= DAT_JOBEXPERT_COUNT) return 0;
    return strcmp(dat_jobexpert[prof], dat_jobexpert[job]) == 0;
}
int colony_is_expert(uint8_t prof, int job) { return is_expert(prof, job); }

/* improvementBonus (game.js:2535, byte-verified @0x9EC6..0x9F23): ROAD adds
 * for goods > 3, PLOW for goods <= 3; the bonus is 2 for lumber or a
 * river tile, else 1. */
int improvement_bonus(int x, int y, int g) {
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
int field_yield(const ColonyRecord *c, int sol, int job,
                       uint8_t prof, int dx, int dy) {
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
    yld += tory_penalty(c, sol);
    if (is_expert(prof, job)) {
        if (g == FOOD || g == HORSES) yld += 2; else yld *= 2;
    }
    return yld > 0 ? yld : 0;
}

/* indoorRate (game.js:2508): 3 base, 6 with the second link; the INDOOR_BASE
 * itself is the port's reading (no rate column exists in @BUILDING), the
 * factory-tier 2/3 raw cost IS byte-verified (@0x8EB1). */
int indoor_yield(int ci, int sol, int job, uint8_t prof) {
    const ColonyRecord *c = &CS.colonies[ci];
    int rate = chain_count_i(ci, job) >= 2 ? 6 : 3;
    int y = rate + tory_penalty(c, sol);
    if (is_expert(prof, job)) y *= 2;
    if (CR.upkeep_unpaid) y /= 2;
    return y > 0 ? y : 0;
}

/* The nine field jobs are @JOB rows 0..8 (game.js:2596 FIELD_JOBS). */
static int is_field_job(int job) { return job >= 0 && job <= 8; }

/* Warehouse capacity — BYTE_VERIFIED `func_008D00 @0x08D00`: 100 flat while
 * `warehouse_level` (+0x95) is 0, else `(level + 1) * 100`
 * (`cmp byte [bx+0x95],0` @0x08D0D; `inc ax; imul ax,ax,0x64` @0x08D1A). */
static int32_t colony_store_cap(const ColonyRecord *c) {
    return c->warehouse_level ? (c->warehouse_level + 1) * 100 : 100;
}

/* Horse breeding — BYTE_VERIFIED `func_00A3E1 @0x0A5B4..0x0A63F`.
 *
 * This block was previously read as a FOOD-growth accumulator on
 * `ColonyRecord +0xAA`, and both engines carried an invented rule from it
 * ("herd >= 25/50, then herd += max(1, herd/10)").  `+0xAA` is not a food
 * field at all: the colony stock array is at `+0x9A`, u16 per good, indexed
 * by good id — proved directly by `push word ptr [bx+si+0x9a]`
 * @0x08E6E with `si = good*2` — so `+0x9A + 2*8 = +0xAA` is **Horses**
 * (cargo row 8), and 0x11 is the **Stable** (buildings row 17).
 *
 *   herd < 2                      -> no breeding      @0x0A5B4 cmp [bx+0xaa],2
 *   T    = Stable ? 25 : 50       @0x0A5BB mov [bp-0x1e],0x19 /
 *                                 @0x0A5C0 push 0x11; call 0x863e /
 *                                 @0x0A5CD mov [bp-0x1e],0x32
 *   cap  = 2 * ceil(herd / T)     @0x0A5D6..@0x0A5E2 (add T; dec; idiv T; shl 1)
 *   surplus = max(0, produced_food - 2*pop)   @0x0A5F7..@0x0A603
 *   accrual = min(ceil(surplus/2), cap)       @0x0A606 inc;sar 1 / @0x0A609
 *   room    = max(0, capacity - herd)         @0x0A614 call 0x8d00 / @0x0A61F
 *   bred    = min(accrual, room)              @0x0A627
 *   food eaten += bred                        @0x0A63F add [bp-4],ax
 *
 * So the 25/50 Stable pair is the DIVISOR inside the per-turn cap, never the
 * gate, and breeding both COSTS food and cannot push the herd past the
 * warehouse — which also retires the old "the herd compounds past 65,535"
 * flag, since `room` bounds it every turn. */
static int32_t horses_bred(int ci, int32_t produced_food, int32_t eaten) {
    const ColonyRecord *c = &CS.colonies[ci];
    int32_t herd = c->stock[HORSES];
    if (herd < 2) return 0;
    int32_t t = colony_has_bld_name(ci, "Stable") ? 25 : 50;
    int32_t cap = 2 * ((herd + t - 1) / t);
    int32_t surplus = produced_food - eaten;
    if (surplus < 0) surplus = 0;
    int32_t accrual = (surplus + 1) >> 1;
    if (accrual > cap) accrual = cap;
    int32_t room = colony_store_cap(c) - herd;
    if (room < 0) room = 0;
    return accrual < room ? accrual : room;
}

void colony_produce(int ci, colony_output *r) {
    const ColonyRecord *c = &CS.colonies[ci];
    int sol = rt_sol(ci);
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
                r->out[g] += field_yield(c, sol, job, c->profession[k],
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
        int want = indoor_yield(ci, sol, job, c->profession[k]);
        int raw = raw_for(g);
        if (raw >= 0) {
            int factory = chain_count_i(ci, job) > 2;
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
    r->horses_bred = horses_bred(ci, r->gross[FOOD], r->eaten);
    r->eaten += r->horses_bred;                 /* BYTE_VERIFIED @0x0A63F */
    r->net_food = r->out[FOOD] - r->eaten;
}
