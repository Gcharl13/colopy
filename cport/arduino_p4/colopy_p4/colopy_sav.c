/* .SAV load/save — the byte-preserving codec over colopy_state.
 *
 * Layout source: the JS importer (port/src/game.js importSav, re-validated
 * against the ten shipped COLONY0#.SAV files) and the serializer's 43-block
 * order (func_0734F8 @0x073562). File order:
 *
 *   prelude(0x10) globals(0x8E) mid(0xE8)
 *   colonies(ncol*0xCA) units(nunit*0x1C) powers(0x4F0) villages(nvill*0x12)
 *   tribes(0x270) blocks11-43(727) planes(4 * w*h) tail(1502)
 *
 * Counts nvill/nunit/ncol live in the globals block at +0x1A/+0x1C/+0x1E.
 * Everything is copied verbatim; a save we loaded writes back byte-exactly
 * (proved by the host roundtrip test on both fixtures).
 *
 * The 1502-byte TAIL after the planes (serializer @0x0739BC..@0x073A88,
 * loader mirror @0x0741DA..@0x07423D, read 2026-09-02) is:
 *   0x86F6 0x10E + 0x85E8 0x10E   (blocks 48-49, pathfinding scratch)
 *   0x945E 0x20  + 0x85C8 0x20    (blocks 50-51, AI word arrays)
 *   [bp-6] 4 B                    (a stack local left by the serializer's
 *                                  RNG reseed 0x181f:0x4ca = func_00C31C ->
 *                                  func_00C2F8: timer 0xc0c:0x12 & 0x7fff ->
 *                                  srand 0xd1d:0xdf2; opaque, verbatim)
 *   DGROUP 0x8D80 4 B             (the plot/skill seed base)
 *   DGROUP 0x190  2 B             (the map-detail salt)
 *   0x1B22:0000 0x378 B           (12 x 0x4A TRADE-ROUTE records)
 * The route table is decoded into CR.routes on load and re-encoded on save
 * (C3.7, 2026-09-02); the rest rides verbatim.
 */
#include <string.h>

#include "colopy_data.h"

#include "colopy_core.h"
#include "colopy_sim.h"
#include "colopy_state.h"

colopy_state CS;

static colopy_status g_last = COLOPY_OK;
colopy_status colopy_last_error(void) { return g_last; }

static uint16_t rd16(const uint8_t *p) { return (uint16_t)(p[0] | (p[1] << 8)); }
static void wr16(uint8_t *p, uint16_t v) { p[0] = (uint8_t)v; p[1] = (uint8_t)(v >> 8); }

/* the trailing route block: 12 x 0x4A records at tail offset 614
 * (2*0x10E + 2*0x20 + 4 + 4 + 2), written from segment 0x1B22:0000 with
 * size 0x378 @0x073A73..@0x073A83 and read back @0x07422C..@0x07423D.
 * Record layout (spec/systems/trade_routes.md par.2): name[32] +0x00,
 * type byte +0x20 (0 = sea, 1 = land @0x061282), stop COUNT +0x21
 * (dec on stop delete @0x06051A, loop bound @0x02EEED), then 4 stops of
 * 10 bytes at +0x22: dest word (colony record index, 0x3E7 Europe,
 * 0x3E8 none), count byte +2 (low nibble = UNLOAD count, high = LOAD,
 * func_060382 @0x060394/@0x0603A2), LOAD goods nibble-packed at
 * +0x03..+0x05 and UNLOAD goods at +0x06..+0x08 (addr_of_good_byte
 * @0x060350: n < 6 -> +6 + n/2, n >= 6 -> +3 + (n-6)/2; get_nth_good
 * @0x0603F2: odd n = high nibble).  The active count is the globals word
 * [0x53A0] = g+0x20. */
#define SAV_TAIL_LEN     1502
#define SAV_TAIL_ROUTES  614
#define SAV_ROUTE_STRIDE 0x4A
#define SAV_ROUTE_BLOCK  (COLOPY_MAX_ROUTES * SAV_ROUTE_STRIDE)
#define SAV_STOP_EUROPE  0x3E7
#define SAV_STOP_NONE    0x3E8

/* a route-carrying unit: the engine tests the @UNIT cargo column
 * (byte [0x5237 + type*14] != 0 @0x06136E, i.e. dat_units[].cargo) */
static int unit_is_carrier(int type) {
    return type >= 0 && type < DAT_UNITS_COUNT && dat_units[type].cargo > 0;
}
/* CR.routes stops are PLAYER-colony ordinals (game.js G.colonies index);
 * the record holds the global colony record index. */
static int player_ord_of_rec(int rec) {
    uint8_t nation = cs_nation();
    int ord = -1;
    for (int i = 0; i < CS.n_colonies; i++) {
        if ((CS.colonies[i].owner_power & 3) != nation) continue;
        ord++;
        if (i == rec) return ord;
    }
    return -1;
}
static int rec_of_player_ord(int ord) {
    uint8_t nation = cs_nation();
    int k = -1;
    for (int i = 0; i < CS.n_colonies; i++) {
        if ((CS.colonies[i].owner_power & 3) != nation) continue;
        if (++k == ord) return i;
    }
    return -1;
}
static uint8_t lane_nibble(const uint8_t *lane, int k) {
    return (uint8_t)((k & 1) ? (lane[k >> 1] >> 4) : (lane[k >> 1] & 0x0F));
}
static void lane_set(uint8_t *lane, int k, uint8_t good) {
    if (k & 1) lane[k >> 1] = (uint8_t)((lane[k >> 1] & 0x0F) | (good << 4));
    else       lane[k >> 1] = (uint8_t)((lane[k >> 1] & 0xF0) | (good & 0x0F));
}

/* decode the route block + the units' +0x17 route/stop nibbles
 * (func_0075D4 low nibble = route, func_0075FE high nibble = stop) into
 * the runtime.  A carrier is BOUND when its orders byte is 2 (Trade
 * Route) — the engine has no separate unbound sentinel; orders != 2 is
 * "not on a route" (func_0612E6 clears orders 2 -> 0 when unbinding). */
static void routes_from_sav(void) {
    CR.n_routes = 0;
    memset(CR.unit_route, 0xFF, sizeof(CR.unit_route));
    memset(CR.unit_stop_index, 0, sizeof(CR.unit_stop_index));
    if (CS.tail_len < SAV_TAIL_LEN) return;
    int n = rd16(CS.globals + 0x20);
    if (n > COLOPY_MAX_ROUTES) n = COLOPY_MAX_ROUTES;
    for (int r = 0; r < n; r++) {
        const uint8_t *rec = CS.tail + SAV_TAIL_ROUTES + r * SAV_ROUTE_STRIDE;
        struct colopy_route *rt = &CR.routes[r];
        memset(rt, 0, sizeof(*rt));
        memcpy(rt->name, rec, 32);
        rt->name[31] = 0;
        rt->sea = (int8_t)(rec[0x20] == 0);
        int ns = rec[0x21];
        if (ns > COLOPY_MAX_STOPS) ns = COLOPY_MAX_STOPS;
        int out = 0;
        for (int k = 0; k < ns; k++) {
            const uint8_t *st = rec + 0x22 + k * 10;
            int dest = rd16(st);
            int16_t stop;
            if (dest == SAV_STOP_EUROPE) stop = COLOPY_STOP_EUROPE;
            else {
                int ord = player_ord_of_rec(dest);
                if (ord < 0) continue;       /* not a player colony: dropped */
                stop = (int16_t)ord;
            }
            rt->stops[out] = stop;
            int nl = st[2] >> 4, nu = st[2] & 0x0F;
            if (nl > 6) nl = 6;
            if (nu > 6) nu = 6;
            rt->n_load[out] = (uint8_t)nl;
            rt->n_unload[out] = (uint8_t)nu;
            for (int j = 0; j < nl; j++) rt->load[out][j] = lane_nibble(st + 3, j);
            for (int j = 0; j < nu; j++) rt->unload[out][j] = lane_nibble(st + 6, j);
            out++;
        }
        rt->n_stops = (int8_t)out;
    }
    CR.n_routes = (int8_t)n;
    for (int i = 0; i < CS.n_units; i++) {
        UnitRecord *u = &CS.units[i];
        if (u->orders != 2) continue;
        if (!unit_is_carrier(u->type)) { u->orders = 0; continue; }
        int route = u->profession & 0x0F;
        if (route >= CR.n_routes) { u->orders = 0; continue; }
        CR.unit_route[i] = (int16_t)route;
        CR.unit_stop_index[i] = (uint8_t)(u->profession >> 4);
    }
}

/* the inverse: CR.routes -> the tail block, [0x53A0], and each bound
 * carrier's +0x17 nibbles (setters func_0075E4 / func_007610) */
static void routes_to_sav(void) {
    wr16(CS.globals + 0x20, (uint16_t)(CR.n_routes < 0 ? 0 : CR.n_routes));
    if (CS.tail_len < SAV_TAIL_LEN) return;
    uint8_t *blk = CS.tail + SAV_TAIL_ROUTES;
    memset(blk, 0, SAV_ROUTE_BLOCK);
    for (int r = 0; r < CR.n_routes && r < COLOPY_MAX_ROUTES; r++) {
        const struct colopy_route *rt = &CR.routes[r];
        uint8_t *rec = blk + r * SAV_ROUTE_STRIDE;
        memcpy(rec, rt->name, 32);
        rec[0x20] = (uint8_t)(rt->sea ? 0 : 1);
        int ns = rt->n_stops < 0 ? 0 : rt->n_stops;
        if (ns > COLOPY_MAX_STOPS) ns = COLOPY_MAX_STOPS;
        rec[0x21] = (uint8_t)ns;
        for (int k = 0; k < ns; k++) {
            uint8_t *st = rec + 0x22 + k * 10;
            int dest;
            if (rt->stops[k] == COLOPY_STOP_EUROPE) dest = SAV_STOP_EUROPE;
            else {
                dest = rec_of_player_ord(rt->stops[k]);
                if (dest < 0) dest = SAV_STOP_NONE;
            }
            wr16(st, (uint16_t)dest);
            int nl = rt->n_load[k] > 6 ? 6 : rt->n_load[k];
            int nu = rt->n_unload[k] > 6 ? 6 : rt->n_unload[k];
            st[2] = (uint8_t)((nl << 4) | nu);
            for (int j = 0; j < nl; j++) lane_set(st + 3, j, rt->load[k][j]);
            for (int j = 0; j < nu; j++) lane_set(st + 6, j, rt->unload[k][j]);
        }
    }
    for (int i = 0; i < CS.n_units; i++) {
        if (CR.unit_route[i] < 0 || !unit_is_carrier(CS.units[i].type)) continue;
        CS.units[i].profession =
            (uint8_t)((CR.unit_stop_index[i] << 4) | (CR.unit_route[i] & 0x0F));
    }
}

uint16_t cs_year(void)       { return rd16(CS.globals + 0x0A); }
uint16_t cs_season(void)     { return rd16(CS.globals + 0x0C); }
uint16_t cs_turn(void)       { return rd16(CS.globals + 0x0E); }
uint8_t  cs_nation(void)     { return (uint8_t)(rd16(CS.globals + 0x14) & 3); }
uint8_t  cs_difficulty(void) { return CS.globals[0x26]; }
uint16_t cs_tut_mask(void)   { return rd16(CS.globals + 0x06); }
uint16_t cs_wc_seen(void)    { return rd16(CS.globals + 0x8A); }
uint16_t cs_ref(int i)       { return rd16(CS.globals + 0x5A + 2 * i); }
/* Block 34 = the single byte [0x336], 564 bytes past the tribe table
 * (game.js:10257) => blocks11_43[564]. */
uint8_t  cs_colony_numbers(void) { return CS.blocks11_43[564]; }

colopy_status colopy_load_sav(const uint8_t *buf, size_t len) {
    if (len < SAV_PRELUDE + SAV_GLOBALS ||
        memcmp(buf, "COLONIZE", 8) != 0 || buf[9] != 0x1A)
        return g_last = COLOPY_ERR_BAD_SAV;
    if (rd16(buf + 0x0C) != COLOPY_MAP_W || rd16(buf + 0x0E) != COLOPY_MAP_H)
        return g_last = COLOPY_ERR_BAD_SAV;

    const uint8_t *g = buf + SAV_PRELUDE;
    uint16_t nvill = rd16(g + 0x1A);
    uint16_t nunit = rd16(g + 0x1C);
    uint16_t ncol  = rd16(g + 0x1E);
    if (ncol > COLOPY_MAX_COLONIES || nunit > COLOPY_MAX_UNITS ||
        nvill > COLOPY_MAX_SETTLEMENTS)
        return g_last = COLOPY_ERR_CAPACITY;   /* reject, never truncate */

    size_t need = (size_t)SAV_PRELUDE + SAV_GLOBALS + SAV_MID +
                  (size_t)ncol * sizeof(ColonyRecord) +
                  (size_t)nunit * sizeof(UnitRecord) +
                  SAV_POWERS +
                  (size_t)nvill * sizeof(NativeSettlement) +
                  SAV_TRIBES + SAV_BLOCKS_11_43 + 4u * COLOPY_PLANE;
    if (len < need)
        return g_last = COLOPY_ERR_BAD_SAV;
    if (len - need > SAV_TAIL_MAX)
        return g_last = COLOPY_ERR_CAPACITY;

    memset(&CS, 0, sizeof(CS));
    const uint8_t *p = buf;
    memcpy(CS.prelude, p, SAV_PRELUDE);            p += SAV_PRELUDE;
    memcpy(CS.globals, p, SAV_GLOBALS);            p += SAV_GLOBALS;
    memcpy(CS.mid, p, SAV_MID);                    p += SAV_MID;
    memcpy(CS.colonies, p, (size_t)ncol * sizeof(ColonyRecord));
    p += (size_t)ncol * sizeof(ColonyRecord);
    memcpy(CS.units, p, (size_t)nunit * sizeof(UnitRecord));
    p += (size_t)nunit * sizeof(UnitRecord);
    memcpy(CS.powers, p, SAV_POWERS);              p += SAV_POWERS;
    memcpy(CS.villages, p, (size_t)nvill * sizeof(NativeSettlement));
    p += (size_t)nvill * sizeof(NativeSettlement);
    memcpy(CS.tribes, p, SAV_TRIBES);              p += SAV_TRIBES;
    memcpy(CS.blocks11_43, p, SAV_BLOCKS_11_43);   p += SAV_BLOCKS_11_43;
    memcpy(CS.terrain, p, COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(CS.improve, p, COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(CS.region,  p, COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(CS.fog,     p, COLOPY_PLANE);           p += COLOPY_PLANE;
    CS.tail_len = (uint16_t)(len - need);
    memcpy(CS.tail, p, CS.tail_len);
    CS.n_colonies = ncol;
    CS.n_units = nunit;
    CS.n_villages = nvill;
    market_reset_accum();
    cr_reset_from_load();
    routes_from_sav();
    return g_last = COLOPY_OK;
}

size_t colopy_save_sav(uint8_t *buf, size_t cap) {
    size_t need = (size_t)SAV_PRELUDE + SAV_GLOBALS + SAV_MID +
                  (size_t)CS.n_colonies * sizeof(ColonyRecord) +
                  (size_t)CS.n_units * sizeof(UnitRecord) +
                  SAV_POWERS +
                  (size_t)CS.n_villages * sizeof(NativeSettlement) +
                  SAV_TRIBES + SAV_BLOCKS_11_43 + 4u * COLOPY_PLANE +
                  CS.tail_len;
    if (cap < need) { g_last = COLOPY_ERR_BUFFER; return 0; }

    /* keep the header's counts honest before writing */
    CS.globals[0x1A] = (uint8_t)CS.n_villages;
    CS.globals[0x1B] = (uint8_t)(CS.n_villages >> 8);
    CS.globals[0x1C] = (uint8_t)CS.n_units;
    CS.globals[0x1D] = (uint8_t)(CS.n_units >> 8);
    CS.globals[0x1E] = (uint8_t)CS.n_colonies;
    CS.globals[0x1F] = (uint8_t)(CS.n_colonies >> 8);
    routes_to_sav();
    /* the map-detail salt [0x190] rides in the tail (C3.8, offset 612):
     * a new game's draw and a loaded word both go back where the engine
     * keeps it; the [0x8D80] plot base (tail 608, 4 B) is written only when the slot
     * is empty (a new game's zero tail) -- a loaded file keeps the
     * saving session's tick, the port pins its own (cr_reset_from_load) */
    if (CS.tail_len >= 614) {
        CS.tail[612] = (uint8_t)(CR.map_seed & 0xFF);
        CS.tail[613] = (uint8_t)(CR.map_seed >> 8);
        if (!(CS.tail[608] | CS.tail[609] | CS.tail[610] | CS.tail[611])) {
            CS.tail[608] = (uint8_t)(CR.plot_seed & 0xFF);
            CS.tail[609] = (uint8_t)((CR.plot_seed >> 8) & 0xFF);
            CS.tail[610] = (uint8_t)((CR.plot_seed >> 16) & 0xFF);
            CS.tail[611] = (uint8_t)((CR.plot_seed >> 24) & 0xFF);
        }
    }

    uint8_t *p = buf;
    memcpy(p, CS.prelude, SAV_PRELUDE);            p += SAV_PRELUDE;
    memcpy(p, CS.globals, SAV_GLOBALS);            p += SAV_GLOBALS;
    memcpy(p, CS.mid, SAV_MID);                    p += SAV_MID;
    /* +0x94 carries a unit target as 0x2A + (type - 0x0B) — the engine's
     * own encoding (classifier func_00B5A8 @0x00B5CE..@0x00B5E1), so the
     * record goes out verbatim (C3.7, 2026-09-02). */
    memcpy(p, CS.colonies, (size_t)CS.n_colonies * sizeof(ColonyRecord));
    p += (size_t)CS.n_colonies * sizeof(ColonyRecord);
    memcpy(p, CS.units, (size_t)CS.n_units * sizeof(UnitRecord));
    p += (size_t)CS.n_units * sizeof(UnitRecord);
    /* fold the runtime relation matrices back into the +0x34 rows
     * (B4.6): the JS keeps its MET/TREATY 0x40 in two maps, the record
     * has one bit — OR them. Tribe columns and the timers ride verbatim. */
    for (int a = 0; a < 4; a++)
        for (int b = 0; b < 4; b++)
            CS.powers[a].war_rel[b] = (uint8_t)
                (CR.war_matrix[a][b] |
                 ((CR.treaty_matrix[a][b] & REL_TREATY) ? 0x40 : 0));
    memcpy(p, CS.powers, SAV_POWERS);              p += SAV_POWERS;
    memcpy(p, CS.villages, (size_t)CS.n_villages * sizeof(NativeSettlement));
    p += (size_t)CS.n_villages * sizeof(NativeSettlement);
    memcpy(p, CS.tribes, SAV_TRIBES);              p += SAV_TRIBES;
    memcpy(p, CS.blocks11_43, SAV_BLOCKS_11_43);   p += SAV_BLOCKS_11_43;
    memcpy(p, CS.terrain, COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(p, CS.improve, COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(p, CS.region,  COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(p, CS.fog,     COLOPY_PLANE);           p += COLOPY_PLANE;
    memcpy(p, CS.tail, CS.tail_len);               p += CS.tail_len;
    g_last = COLOPY_OK;
    return (size_t)(p - buf);
}

/* ---- read-only views --------------------------------------------------- */
const ColonyRecord *colopy_colony(int i) {
    return (i >= 0 && i < CS.n_colonies) ? &CS.colonies[i] : 0;
}
const UnitRecord *colopy_unit(int i) {
    return (i >= 0 && i < CS.n_units) ? &CS.units[i] : 0;
}
const PowerRecord *colopy_power(int i) {
    return (i >= 0 && i < COLOPY_POWERS) ? &CS.powers[i] : 0;
}
const NativeSettlement *colopy_settlement(int i) {
    return (i >= 0 && i < CS.n_villages) ? &CS.villages[i] : 0;
}
const uint8_t *colopy_map_tiles(void) { return CS.terrain; }

void colopy_get_overview(colopy_overview *out) {
    out->turn = cs_turn();
    out->year = (int16_t)cs_year();
    out->season = (uint8_t)cs_season();
    out->human_power = cs_nation();
    out->difficulty = cs_difficulty();
    out->n_units = CS.n_units;
    out->n_colonies = CS.n_colonies;
    out->n_settlements = CS.n_villages;
    out->tax_rate = CS.powers[cs_nation()].tax_rate;
    out->declared = 0;   /* TBD: not yet mapped from the globals block */
}

/* FNV-1a over the state blocks — the parity/hardware digest. */
static uint32_t fnv(uint32_t h, const void *v, size_t n) {
    const uint8_t *b = (const uint8_t *)v;
    while (n--) { h ^= *b++; h *= 16777619u; }
    return h;
}
uint32_t colopy_digest(void) {
    uint32_t h = 2166136261u;
    h = fnv(h, CS.globals, SAV_GLOBALS);
    h = fnv(h, CS.colonies, (size_t)CS.n_colonies * sizeof(ColonyRecord));
    h = fnv(h, CS.units, (size_t)CS.n_units * sizeof(UnitRecord));
    h = fnv(h, CS.powers, sizeof(CS.powers));
    h = fnv(h, CS.villages, (size_t)CS.n_villages * sizeof(NativeSettlement));
    h = fnv(h, CS.terrain, sizeof(CS.terrain));
    h = fnv(h, CS.improve, sizeof(CS.improve));
    h = fnv(h, CS.fog, sizeof(CS.fog));
    h = fnv(h, &CS.rng, sizeof(CS.rng));
    return h;
}

/* a fresh game's tail: the engine writes its 1502 trailing bytes from live
 * DGROUP (save.md blocks 48-55); the port starts them zero so the two seed
 * words and the route block have a home (C3.7/C3.8, 2026-09-03) */
void sav_tail_init(void) {
    CS.tail_len = SAV_TAIL_LEN;
    memset(CS.tail, 0, SAV_TAIL_LEN);
}
