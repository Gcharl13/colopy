/* Colony production — colonyProduce (game.js:2630) and its helpers, ported
 * over the RECORD form: occupation/profession are @JOB row bytes, worker
 * cells come from the +0x70 slot table, buildings from the +0x84 tier-packed
 * field. Where the JS works on names, this works on the same table indexes
 * the names came from; every JS-side citation (EXE offsets) carries over.
 */
#include <string.h>

#include "colopy_sim.h"
#include "colopy_data.h"

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
        /* PREFIX COUNT, not binary value: the field is a unary mask, one
         * bit per built tier.  Proven by San Salvador's fortification
         * bits 1,1,0 -- the binary read said 3 (Fortress) while the
         * colony's own map frame byte (+0xBE, read by func_004314
         * @0x004385) says 2 (Fort).  The two readings only ever differ
         * at two-of-three bits set, which the Jamestown pin never hit. */
        int t = 0;
        while (t < w &&
               ((c->buildings[(lo + t) >> 3] >> ((lo + t) & 7)) & 1))
            t++;
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

/* toryPenalty — BYTE_VERIFIED @0x9D13..@0x9D98 (and the identical block
 * @0xA029..@0xA0AF in the indoor function):
 *   tories  = (pop*(100-sol)+50)/100          @0x9D1A..@0x9D32
 *   HUMAN colony (owner<4, AIPersonality.controller==0 @0x9D43):
 *     divisor = 10 - difficulty               @0x9D49..@0x9D51
 *   AI colony: tories = 0                     @0x9D73
 *   pen = -(tories/divisor)                   @0x9D78..@0x9D81
 *   +1 per RECORD flag +0x1C bit2 / bit1      @0x9D88/@0x9D92
 * The latches come from the record's flag byte, NOT the runtime sol; a
 * POSITIVE pen is added early (@0x9D9B, only when yield != 0), a NEGATIVE
 * pen at the very END of the yield chain (@0x9FD8). */
static int tory_penalty(const ColonyRecord *c, int sol) {
    int d = 0;
    if ((c->owner_power & 3) == cs_nation()) {
        int tories = (c->population * (100 - sol) + 50) / 100;
        d = -(tories / (10 - cs_difficulty()));
    }
    if (c->colony_flags & 4) d += 1;
    if (c->colony_flags & 2) d += 1;
    return d;
}

/* isExpert — BYTE_VERIFIED @0x9CDC (field: profession byte == the yield
 * COLUMN, i.e. the job id 0..8) and @0xA01A (indoor: profession byte ==
 * occupation byte).  Plain byte equality; profession 0 IS the Expert
 * Farmer (the old `prof < 1` guard under-paid every prof-0 farmer — the
 * Vlissingen scene badges 6/5 vs the port's 5/4 were the tell). */
int colony_is_expert(uint8_t prof, int job);   /* UI layer's bestFieldJob */
static int is_expert(uint8_t prof, int job) { return prof == job; }
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

/* PRIME RESOURCES -- byte-read at func_009B9C @0x9DD5-@0x9E10 with the
 * bonus table func_009AAA (@0x9AAA-@0x9B9A).  The "resource id" argument
 * is the tile's DETAIL ID: the getter 0x37F:0x4B0 resolves to
 * tile_terrain_variant_hash @0x60A0 itself -- the seeded detail sprites
 * ARE the prime resources (runtime-confirmed 2026-08-28: the view-mode
 * sidebar prints "(Minerals)" on Vlissingen's centre tile, exactly where
 * the hash says detail id 6).  bonus = table[id][col]; id 7 (fish) with
 * no base yield gives 0; a NEGATIVE entry DOUBLES the yield; otherwise
 * an EXPERT doubles the bonus. */
static const int8_t RES_BONUS[16][16] = {
    [9] = { [0] = 2, [4] = 2 },
    [1] = { [0] = 2 },
    [2] = { [0] = 2 },
    [8] = { [4] = 3 },
    [3] = { [3] = -1 },
    [4] = { [2] = -1 },
    [5] = { [1] = -1 },
    [10] = { [5] = 2 },
    [6] = { [6] = 3, [7] = 1 },
    [13] = { [6] = 2 },
    [12] = { [7] = 2 },
    [7] = { [8] = 3 },
};
static int res_bonus(int res, int col) {
    if (res < 0) return 0;
    return RES_BONUS[res & 0x0F][col & 0x0F];
}

/* the [0xA896] depletion-pressure accumulator — zeroed by colony_produce,
 * fed by field_yield, read back into colony_output */
static int dep_accrue;

/* fieldYield — the FULL func_009B9C chain, byte-read end to end
 * @0x9B9C..@0x9FFB and cross-checked against every per-tile badge in the
 * COLONY_SHIP baseline's worked-tile grid (Vlissingen: farmers 6/5,
 * lumberjacks 4/4, miners 4/4, fisherman 4, 2026-08-28).  Order matters:
 *   1  yield = table[classify(v)][col]           (col == job id 0..8)
 *   2  fisher ladder on the 8-neighbour ocean count   @0x9C33..@0x9C87
 *   3  furs: +1 road (imp&0xA), +1 river, +1 major river   @0x9C87
 *   4  clamp >= 0                                 @0x9CB4
 *   5  pen > 0 added now (yield != 0)             @0x9D9B
 *   6  expert (prof byte == col): food/fish +2 (+pen again if pen>0),
 *      else x2                                    @0x9DAD..@0x9DD2
 *   7  prime-resource bonus (negative doubles; expert doubles the bonus)
 *   8  silver with no detail and no mine bit (imp&4): 1 if road/expert
 *      else 0, and the improvement block is skipped     @0x9E41..@0x9EA6
 *   9  LUMBER column doubles                      @0x9EAB
 *  10  improvement block (b = 2 for lumber or non-food expert, else 1):
 *      col 0 inherent +b; road +b (col>3); plow +b (col<=3); river +b
 *      (major river a second +b only when the river was the sole bonus)
 *                                                 @0x9EBD..@0x9F4C
 *  11  fisherman needs the Docks (@BUILDING row 6) or yields 0   @0x9F4F
 *  12  furs x2 with Henry Hudson (father 8)       @0x9F65
 *  13  Indian Convert profession (27): +1 on raw cols 0..4 and fish
 *                                                 @0x9F86..@0x9FB6
 *  14  clamp; pen < 0 applied LAST, clamp again   @0x9FB9..@0x9FF3  */
int field_yield(const ColonyRecord *c, int sol, int job,
                       uint8_t prof, int dx, int dy) {
    int ci = (int)(c - CS.colonies);
    int col = job;                     /* @JOB rows 0..8 are the columns */
    if (col < 0 || col > 8) return 0;
    int x = c->map_x + dx, y = c->map_y + dy;
    uint8_t v = map_at(x, y);
    uint8_t imp = map_improve_raw(x, y);
    int yld = tile_yield(v, col);
    int expert = is_expert(prof, col);
    int foodish = (col == 0 || col == 8);
    if (yld != 0) {
        if (col >= 8) {
            int n = map_count8_terr(x, y, 0x19, 0x1A);
            if (n >= 8) yld -= 2;
            else if (n >= 6) yld -= 1;
            else yld += 1;
        }
        if (col == 4) {
            if (imp & 0x0A) yld += 1;
            if (v & 0x40) { yld += 1; if (v & 0x80) yld += 1; }
        }
    }
    if (yld < 0) yld = 0;
    int pen = tory_penalty(c, sol);
    if (yld != 0 && pen > 0) yld += pen;
    if (expert && yld != 0) {
        if (foodish) { yld += 2; if (pen > 0) yld += pen; }
        else yld <<= 1;
    }
    int res = map_detail_id(x, y, v);
    {
        int bonus = res_bonus(res, col);
        if (res == 7 && yld <= 0) bonus = 0;
        if (bonus < 0) yld <<= 1;
        else { if (expert) bonus <<= 1; yld += bonus; }
    }
    /* depletion pressure accrues per worked mineral (@0x9E13..@0x9E41 on
     * [0xA896], zeroed at each produce @0xA22C): ore on Minerals +1,
     * silver on Minerals +2, silver on a Depleted Mine +1 */
    if (res == 6) {
        if (col == 6) dep_accrue += 1;
        else if (col == 7) dep_accrue += 2;
    }
    if (res == 0xC && col == 7) dep_accrue += 1;
    int no_mine = 0;
    if (col == 7 && res == -1 && !(imp & 4)) {
        no_mine = 1;
        if (yld != 0) yld = ((imp & 0x0A) || expert) ? 1 : 0;
    }
    if (col == 5) yld <<= 1;
    if (yld > 0 && !no_mine) {
        int b = ((expert && !foodish) || col == 5) ? 2 : 1;
        int add = 0;
        if (col == 0) add = b;
        if ((imp & 0x0A) && col > 3) add += b;
        if ((imp & 0x40) && col <= 3) add += b;
        if (v & 0x40) { add += b; if ((v & 0x80) && add == b) add += b; }
        yld += add;
    }
    if (col >= 8 && !colony_has_name(ci, "Docks")) yld = 0;
    if (col == 4 && (c->owner_power & 3) == cs_nation() &&
        father_owned(father_by_name("Henry Hudson"))) yld <<= 1;
    if (prof == 27 && yld > 0 && (col <= 4 || col >= 8)) yld += 1;
    if (yld < 0) yld = 0;
    if (yld != 0 && pen < 0) { yld += pen; if (yld < 0) yld = 0; }
    return yld;
}

/* indoorRate — the FULL func_009FFC, byte-read @0x9FFC..@0xA221.
 * expert = profession byte == occupation byte (@0xA01A); the class rate
 * keys off the PROFESSION: Indentured Servant (25) -> 2, Criminal (26) /
 * Convert (27) -> 1, everyone else 3 (@0xA0D7..@0xA0FD; the Isabella
 * baseline's rum row 4 = criminal 1 + free 3).  Per job (@0xA1E4 jump
 * table, cs base 0x82B0):
 *   Carpenter 13 @0xA100: (expert?6:class)+pen, x2 with the Lumber Mill
 *                          (@BUILDING row 0x24)
 *   Preacher 16 @0xA132:  (expert?6:class)+pen, x2 with the Cathedral
 *                          (row 0x26), +50% with William Penn (father 21)
 *   Statesman 17 @0xA1C8: class+pen, x2 if expert (the press/newspaper
 *                          multipliers act on the bell TOTAL, @0xA587)
 *   Teacher 18 (default @0xA0AF): expert?3:1
 *   converters 9-12,14,15 @0xA188: class+pen, +class with the 2nd link,
 *                          +50% with the 3rd (factory), x2 if expert  */
int indoor_yield(int ci, int sol, int job, uint8_t prof) {
    const ColonyRecord *c = &CS.colonies[ci];
    int expert = is_expert(prof, job);
    int pen = tory_penalty(c, sol);
    int cls = (prof == 25) ? 2 : (prof == 26 || prof == 27) ? 1 : 3;
    int y;
    switch (job) {
    case 13:
        y = (expert ? 6 : cls) + pen;
        if (colony_has_name(ci, "Lumber Mill")) y <<= 1;
        break;
    case 16:
        y = (expert ? 6 : cls) + pen;
        if (colony_has_name(ci, "Cathedral")) y <<= 1;
        if (father_owned(father_by_name("William Penn"))) y += y / 2;
        break;
    case 17:
        y = cls + pen;
        if (expert) y <<= 1;
        break;
    default:
        if (job >= 9 && job <= 15) {
            y = cls + pen;
            int n = chain_count_i(ci, job);
            if (n > 1) y += cls;
            if (n > 2) y += y / 2;
            if (expert) y <<= 1;
        } else {
            y = expert ? 3 : 1;          /* teacher & the rest @0xA0AF */
        }
        break;
    }
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

/* The centre tile — compute_colony_center_yields func_00A222, byte-read
 * END TO END @0xA222..@0xA3D1 (2026-08-28; the old plow/river/runtime-SoL
 * model was capture-fitted and wrong):
 *   FOOD: band by the CLASSIFIER id (hills/mountains and forested ids
 *   keep their own rows — NO auto-clear fold): arctic 0; desert family
 *   {1,9,0x11} 1; forested 8..23 and hills/mountains 2; else 3
 *   (@0xA247..@0xA290); +2/+1 at difficulty 0/1 (@0xA295); +2 when the
 *   centre's prime resource is 1, 2 or 9 (@0xA314); +1 per record flag
 *   +0x1C bit2/bit1 (@0xA32B).
 *   SECONDARY (@0xA343..@0xA3D1): best of columns 1..7 skipping 5 on the
 *   SAME classified row, resource bonus per column (negative doubles),
 *   strict > so the FIRST max wins; the winner gets +1 at difficulty 0,
 *   the river bonus (minor 1 / major 2), +1 per flag bit — and the
 *   amount is ADDED TO PRODUCTION (@0xA3F7..@0xA409).  Vlissingen:
 *   rain-forest ore 1 + minerals 3 = 4 wins, +1 -> 5, closing the ore
 *   row at 4+4+5 = 13. */
void colony_centre_yield(int ci, int *food, int *good, int *amount) {
    const ColonyRecord *c = &CS.colonies[ci];
    uint8_t cv = map_at(c->map_x, c->map_y);
    int ct = tile_yield_class(cv);
    int cres = map_detail_id(c->map_x, c->map_y, cv);
    int band;
    if (ct == 0x18) band = 0;
    else if (ct == 1 || ct == 9 || ct == 0x11) band = 1;
    else if (ct == 27 || ct == 28 || (ct >= 8 && ct <= 23)) band = 2;
    else band = 3;
    int f = band;
    if (cs_difficulty() == 0) f += 2;
    else if (cs_difficulty() == 1) f += 1;
    if (cres == 1 || cres == 2 || cres == 9) f += 2;
    if (c->colony_flags & 4) f += 1;
    if (c->colony_flags & 2) f += 1;
    int sg = -1, sa = 0;
    for (int cc = 1; cc <= 7; cc++) {
        if (cc == 5) continue;
        int yv = tile_yield(cv, cc);
        int bb = res_bonus(cres, cc);
        if (bb < 0) yv <<= 1; else yv += bb;
        if (yv > sa) { sa = yv; sg = cc; }
    }
    if (sg >= 0) {
        if (cs_difficulty() == 0) sa += 1;
        sa += tile_river(cv);
        if (c->colony_flags & 4) sa += 1;
        if (c->colony_flags & 2) sa += 1;
    }
    *food = f; *good = sg; *amount = sg >= 0 ? sa : 0;
}

/* One (raw, product) band resolution — set_commodity_band func_008E02:
 * shortfall = max(0, consumed - stock - produced_raw) (@0x8E27..@0x8E40);
 * func_008E84's tail turns a factory's raw shortfall into product units
 * (everything when nothing was affordable, else 3/2 per pair,
 * @0x8EC9..@0x8EFC).  produced_raw is read from r->out so the gunsmith
 * sees the toolsmith's post-outage output (@0x8E5A). */
static int32_t converter_resolve(colony_output *r, const ColonyRecord *c,
                                 int raw, int32_t product, int factory) {
    int32_t cost = r->consumed[raw];
    if (cost <= 0) { r->outage_amt[raw] = 0; return product; }
    int32_t over = cost - r->gross[raw];
    r->over_amt[raw] = over > 0 ? over : 0;
    int32_t sh = cost - (c->stock[raw] + r->out[raw]);
    if (sh <= 0) { r->outage_amt[raw] = 0; return product; }
    r->outages |= (uint16_t)(1u << raw);
    r->consumed[raw] = cost - sh;      /* only what stock+intake covered */
    int32_t loss = factory ? ((sh == cost) ? product : (3 * sh) / 2) : sh;
    r->outage_amt[raw] = loss;
    product -= loss;
    return product > 0 ? product : 0;
}

void colony_produce(int ci, colony_output *r) {
    const ColonyRecord *c = &CS.colonies[ci];
    int sol = rt_sol(ci);
    memset(r, 0, sizeof(*r));
    r->crosses = 1;   /* the churchless base cross, census3 [0x8DEA]=1 */
    r->sec_good = -1;
    dep_accrue = 0;   /* [0xA896] zeroed at produce start (@0xA22C) */

    /* centre tile — compute_colony_center_yields func_00A222, byte-read
     * END TO END @0xA222..@0xA3D1 (2026-08-28; the old plow/river/runtime-
     * SoL model was capture-fitted and wrong):
     *   band by the CLASSIFIER id (hills/mountains and forested ids keep
     *   their own rows — NO auto-clear fold): arctic 0; desert family
     *   {1,9,0x11} 1; forested 8..23 and hills/mountains 2; else 3
     *                                          @0xA247..@0xA290
     *   +2 / +1 at difficulty 0 / 1            @0xA295..@0xA2A8
     *   +2 when the centre's prime resource is 1, 2 or 9   @0xA314
     *   +1 per record flag +0x1C bit2 / bit1   @0xA32B..@0xA33F
     * SECONDARY (@0xA343..@0xA3D1): best of columns 1..7 skipping 5 on
     * the SAME classified row, resource bonus added per column (negative
     * doubles), strict > so the FIRST max wins; the winner then gets +1
     * at difficulty 0, the river bonus (minor 1 / major 2), +1 per flag
     * bit — and the amount is ADDED TO PRODUCTION (@0xA3F7..@0xA409).
     * Vlissingen: rain-forest ore 1 + minerals 3 = 4 wins, +1 -> 5,
     * closing the panel's ore row at 4+4+5 = 13. */
    {
        int cf, cg, ca;
        colony_centre_yield(ci, &cf, &cg, &ca);
        r->centre = cf;
        r->out[FOOD] += cf;
        if (cg >= 0) {
            r->sec_good = cg; r->sec_amount = ca;
            r->out[cg] += ca;
        }
    }

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
            if (g >= 0) {
                int y = field_yield(c, sol, job, c->profession[k],
                                    CELL_DX[cell_of[k]], CELL_DY[cell_of[k]]);
                r->out[g] += y;
                /* [0xA895] += the fisherman's yield (@0xA44D..@0xA456) */
                if (job == 8) r->fish_food += y;
            }
        } else if (is_field_job(job)) {
            /* a field job with no field rests in the plaza (importer rule,
             * game.js:10393) */
            continue;
        } else {
            indoor[n_indoor++] = k;
        }
    }

    /* indoor workers — the wants accumulate UNCAPPED (@0xA480..@0xA4A0);
     * raw costs are recorded in full (factory tier pays 2/3, @0x8EB1) and
     * the shortages resolve AFTERWARDS through the outage plane. */
    for (int i = 0; i < n_indoor; i++) {
        int k = indoor[i];
        int job = c->occupation[k];
        int g = job_good(job);
        if (g == J_NONE) continue;
        int want = indoor_yield(ci, sol, job, c->profession[k]);
        int raw = raw_for(g);
        if (raw >= 0) {
            int factory = chain_count_i(ci, job) > 2;
            r->consumed[raw] += factory ? (want * 2) / 3 : want;
        }
        if (g >= 0) r->out[g] += want;
        else if (g == J_HAMMERS) r->hammers += want;
        else if (g == J_BELLS) r->bells += want;
        else if (g == J_CROSSES) r->crosses += want;
        else if (g == J_TEACHING) r->teaching += want;
    }

    /* crosses: +1 per Church / Cathedral on top of the base 1
     * (@0xA4B0..@0xA4D2, families 0x25/0x26) */
    if (colony_has_name(ci, "Church")) r->crosses += 1;
    if (colony_has_name(ci, "Cathedral")) r->crosses += 1;
    /* bells: base 1 (@0xA4DB), Jefferson +50% (@0xA4DF father 15),
     * Paine +tax% (@0xA500 father 17), Bolivar (size+3)/5 for AI-run
     * colonies (@0xA539 father 18), then Newspaper x2 else Printing
     * Press +50% (@0xA587..@0xA5AC, rows 0x14/0x13).
     *
     * Every check keys on the colony OWNER (the 0x981:0 calls take
     * [bx+0x1A] @0xA4E5/@0xA50B/@0xA544) and Paine reads the OWNER's
     * tax byte (@0xA525, PowerRecord[owner].tax_pct) — live now that
     * the pass runs rival colonies (B3.6).  father_owned() reads
     * cur_power(), which IS the owner inside the pass. */
    r->bells += 1;
    {
        int owner = c->owner_power & 3;
        if (father_owned(father_by_name("Thomas Jefferson")))
            r->bells += r->bells / 2;
        if (father_owned(father_by_name("Thomas Paine")))
            r->bells += (CS.powers[owner].tax_rate * r->bells) / 100;
        /* Bolivar's gate @0xA555..@0xA567: owner >= 4 (never for a
         * colony) OR an AIPersonality controller != 0 — an AI power */
        if (owner != (int)cs_nation() &&
            father_owned(father_by_name("Simon Bolivar")))
            r->bells += (c->population + 3) / 5;
    }
    if (colony_has_name(ci, "Newspaper")) r->bells <<= 1;
    else if (colony_has_name(ci, "Printing Press")) r->bells += r->bells / 2;

    memcpy(r->gross, r->out, sizeof(r->gross));

    /* outage resolution — set_commodity_band func_008E02 (@0x8E02..@0x8E44)
     * per (raw, product) pair in the engine's order (@0xA64E..@0xA69C):
     * outage[raw] = max(0, consumed - stock - produced); the product loses
     * that many units (a factory loses ceil-ish 3/2 per missing raw pair,
     * or everything when nothing was affordable, @0x8EC9..@0x8EFC).  The
     * tools available to the gunsmith are net of the ore outage
     * (@0x8E5A reads outage[ORE] off the tools production). */
    static const int8_t PAIR_RAW[6] = { ORE, TOBACCO, COTTON, FURS, SUGAR,
                                        TOOLS };
    static const int8_t PAIR_PROD[6] = { TOOLS, CIGARS, CLOTH, COATS, RUM,
                                         MUSKETS };
    r->hammers = converter_resolve(r, c, LUMBER, r->hammers, 0);
    for (int pi = 0; pi < 6; pi++) {
        int raw = PAIR_RAW[pi], g = PAIR_PROD[pi];
        int factory = 0;
        for (int i = 0; i < n_indoor; i++)
            if (job_good(c->occupation[indoor[i]]) == g)
                factory = chain_count_i(ci, c->occupation[indoor[i]]) > 2;
        r->out[g] = converter_resolve(r, c, raw, r->out[g], factory);
    }
    for (int i = 0; i < N_GOODS; i++) r->out[i] -= r->consumed[i];
    r->depletion_pts = dep_accrue;              /* [0xA896] after the fields */
    r->eaten = 2 * c->population;               /* BYTE_VERIFIED @0xA5F2 */
    r->horses_bred = horses_bred(ci, r->gross[FOOD], r->eaten);
    /* the panel's horses cell: bred WANT into production, the unfed rest
     * crossed out (@0xA632..@0xA63B goods_out[8] += want, [0x8E6A] =
     * want - stored) */
    {
        int32_t herd = c->stock[HORSES];
        int32_t want = 0;
        if (herd >= 2) {
            int32_t t = colony_has_bld_name(ci, "Stable") ? 25 : 50;
            want = 2 * ((herd + t - 1) / t);
        }
        r->gross[HORSES] += want;   /* panel only — the turn step banks
                                     * horses_bred itself */
        r->outage_amt[HORSES] = want - r->horses_bred;
    }
    r->eaten += r->horses_bred;                 /* BYTE_VERIFIED @0x0A63F */
    /* the food row's own outage (starvation display, @0xA642) */
    {
        int32_t sh = r->eaten - c->stock[FOOD] - r->gross[FOOD];
        if (sh > 0) { r->outage_amt[FOOD] = sh; r->outages |= 1u << FOOD; }
    }
    r->net_food = r->out[FOOD] - r->eaten;
}
