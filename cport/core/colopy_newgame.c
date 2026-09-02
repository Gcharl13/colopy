/* colopy_new_game — beginGame (game.js:668-750) over the record
 * layouts: a fresh game constructed directly in the .SAV-shaped state
 * (colopy_state.h), then run through the SAME runtime build the .SAV
 * loader uses (cr_reset_from_load), with the importer-vs-beginGame
 * differences overridden after (the importer marks tribes/rivals met;
 * a fresh game has met no one).
 *
 * RNG parity: draws happen in beginGame's exact order — plotSeedBase
 * (677), the eight tribe tensions (seedNatives 5149), mapSeed (742),
 * the sixteen market starts (seedMarket 4309), the three dock rolls
 * (748) — so a seeded run projects identically to the JS
 * (tools/newgame_compare.py).
 *
 * Blocks the JS never reads on import (prelude u16 @0x0A, the mid
 * blocks, blocks 11-43, the tail) are zeroed — FLAGGED: their engine
 * new-game contents are unmodeled; the C loader/saver preserve
 * whatever is here, and nothing in the ported sim reads them. */
#include <string.h>

#include "colopy_core.h"
#include "colopy_sim.h"
#include "../data/colopy_data.h"

/* START_GOLD (game.js:629) */
static const int32_t START_GOLD[5] = { 1000, 300, 0, 0, 0 };
/* TRIBE_SITE_DX/DY (game.js:5145) */
#define TRIBE_SITE_DX 2
#define TRIBE_SITE_DY 0
#define PIONEER_TOOLS 100            /* mkUnit (game.js:664) */

/* the per-tribe site tables, in dat_tribes order (Incas..Tupi) */
static const int32_t (*const SITES[8])[2] = {
    dat_tribesites_inca, dat_tribesites_aztec, dat_tribesites_arawak,
    dat_tribesites_iroquois, dat_tribesites_cherokee, dat_tribesites_apache,
    dat_tribesites_sioux, dat_tribesites_tupi,
};
static const int SITES_N[8] = { 5, 4, 5, 11, 4, 7, 7, 16 };

static void put16(uint8_t *p, uint16_t v) {
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}

static int unit_row(const char *name) {
    for (int i = 0; i < DAT_UNITS_COUNT; i++)
        if (strcmp(dat_units[i].name, name) == 0) return i;
    return -1;
}

/* buildRegions (game.js:483): 4-connected land flood fill; ids cap at
 * the nibble (next stops growing at 15). */
static void build_regions(void) {
    memset(CS.region, 0, sizeof(CS.region));
    static int16_t stack[COLOPY_PLANE];
    int next = 1;
    for (int seed = 0; seed < COLOPY_PLANE; seed++) {
        if (CS.region[seed] || tile_water(CS.terrain[seed])) continue;
        /* hi nibble = the territory OWNER plane, 0xF = unclaimed (the
         * fresh-map state; func_005DF0) */
        CS.region[seed] = (uint8_t)(0xF0 | (next & 0x0F));
        int sp = 0;
        stack[sp++] = (int16_t)seed;
        while (sp) {
            int t = stack[--sp];
            int x = t % COLOPY_MAP_W, y = t / COLOPY_MAP_W;
            static const int D[4][2] = { {1,0}, {-1,0}, {0,1}, {0,-1} };
            for (int d = 0; d < 4; d++) {
                int nx = x + D[d][0], ny = y + D[d][1];
                if (nx < 0 || ny < 0 || nx >= COLOPY_MAP_W ||
                    ny >= COLOPY_MAP_H)
                    continue;
                int n = ny * COLOPY_MAP_W + nx;
                if (CS.region[n] || tile_water(CS.terrain[n])) continue;
                CS.region[n] = (uint8_t)(0xF0 | (next & 0x0F));
                stack[sp++] = (int16_t)n;
            }
        }
        if (next < 15) next++;
    }
}

/* reveal (game.js:8586): the fog plane uses the engine's own
 * 1<<(power+4) bit convention (importer note game.js:10272) */
static void reveal(int x, int y, int r, uint8_t bit) {
    for (int dy = -r; dy <= r; dy++)
        for (int dx = -r; dx <= r; dx++) {
            int tx = x + dx, ty = y + dy;
            if (tx < 0 || ty < 0 || tx >= COLOPY_MAP_W ||
                ty >= COLOPY_MAP_H)
                continue;
            CS.fog[ty * COLOPY_MAP_W + tx] |= bit;
        }
}

static int add_unit(int type, int x, int y, int owner) {
    if (type < 0 || CS.n_units >= COLOPY_MAX_UNITS) return -1;
    UnitRecord *u = &CS.units[CS.n_units];
    memset(u, 0, sizeof(*u));
    u->map_x = (uint8_t)x;
    u->map_y = (uint8_t)y;
    u->type = (uint8_t)type;
    u->owner_flags = (uint8_t)owner;
    u->profession = DAT_JOBEXPERT_COUNT;   /* none (28); 0 = Expert Farmers */
    return CS.n_units++;
}

colopy_status colopy_new_game(uint8_t nation, uint8_t difficulty,
                              const char *leader_name) {
    (void)leader_name;               /* the leader lives UI-side; no
                                      * record block carries the name */
    if (nation > 3 || difficulty > 4) return COLOPY_ERR_BAD_COMMAND;

    memset(&CS, 0, sizeof(CS));

    /* prelude: "COLONIZE" 00 1A + u16 (unread; FLAGGED 0) + w,h */
    memcpy(CS.prelude, "COLONIZE", 8);
    CS.prelude[8] = 0x00;
    CS.prelude[9] = 0x1A;
    put16(CS.prelude + 0x0C, COLOPY_MAP_W);
    put16(CS.prelude + 0x0E, COLOPY_MAP_H);

    /* planes: the shipped map, no improvements, regions rebuilt */
    memcpy(CS.terrain, dat_map_tiles, COLOPY_PLANE);
    build_regions();

    /* globals: year 1492 s0 turn 0 (beginGame 670), tutorial mask 0x0E
     * (725), REF seeds (seedREF 8869) */
    uint8_t *g = CS.globals;
    put16(g + 0x0A, 1492);
    put16(g + 0x0C, 0);
    put16(g + 0x0E, 0);
    put16(g + 0x14, nation);
    g[0x26] = difficulty;
    put16(g + 0x06, 0x0E);
    /* the game-options word [0x5382]: 0xC600 (@0x0755E5), then
     * func_07431E turns Tutorial Hints (0x80) ON iff Discoverer
     * (@0x074341..0x074348); cr_reset_from_load mirrors it into
     * CR.game_options (beginGame, game.js) */
    put16(g + 0x02, (uint16_t)(0xC600 | (difficulty == 0 ? 0x80 : 0)));
    int d = difficulty;
    put16(g + 0x5A, (uint16_t)(8 * d + 15));   /* Regulars */
    put16(g + 0x5C, (uint16_t)(5 * d + 5));    /* Cavalry */
    put16(g + 0x5E, (uint16_t)(3 * d + 2));    /* Man-O-War */
    put16(g + 0x60, (uint16_t)(6 * d + 2));    /* Artillery */

    CS.powers[nation].gold = START_GOLD[difficulty];

    /* --- the seeded draws, in beginGame order --- */
    /* G.plotSeedBase = (random * 2^32) >>> 0 (677): with the shared
     * 15-bit stream that is exactly r * 131072 */
    uint32_t plot = rng_next() * 131072u;

    /* seedNatives (5146): tensions first (one draw per tribe, in
     * dat_tribes order), then the villages, then one brave each */
    uint8_t tension[8];
    for (int ti = 0; ti < 8; ti++) {
        tension[ti] = (uint8_t)(rng_range(0, 14) + 2 * difficulty);
        int off = ti * 0x4E + 0x46 + nation * 2;
        put16(CS.tribes + off, tension[ti]);
    }
    /* placement = func_065D26's TRIBE.TXT mode (@0x660C4..@0x66246,
     * 2026-08-29): per site a triangular +-2 jitter (random_int(-1,1) +
     * random_int(-1,1) per axis), up to 100 tries against passable,
     * improve & 3 clear, terrain < 0x18 with (id & 7) not Desert/Swamp,
     * nearest-settlement distance > 3/2/1 by tries; the FIRST placed
     * site is the capital (byte-confirmed).  Mirrors game.js
     * draw-for-draw. */
    for (int ti = 0; ti < 8; ti++) {
        int lv = dat_tribes[ti].level;
        int placed_first = 0;
        for (int k = 0; k < SITES_N[ti]; k++) {
            int bx = (int)SITES[ti][k][0] + TRIBE_SITE_DX;
            int by = (int)SITES[ti][k][1] + TRIBE_SITE_DY;
            int px = -1, py = -1;
            for (int tries = 1; tries <= 100; tries++) {
                int dx = ((int)((rng_next() * 3u) >> 15) - 1) +
                         ((int)((rng_next() * 3u) >> 15) - 1);
                int dy = ((int)((rng_next() * 3u) >> 15) - 1) +
                         ((int)((rng_next() * 3u) >> 15) - 1);
                int x = bx + dx, y = by + dy;
                if (x < 0 || y < 0 || x >= COLOPY_MAP_W ||
                    y >= COLOPY_MAP_H)
                    continue;
                uint8_t tv = map_at(x, y);
                int tt = tile_terrain(tv);
                if (tile_water(tv) || tt >= 0x18) continue;
                if ((tt & 7) == 1 || (tt & 7) == 7) continue;
                if (map_improve(x, y) & 3) continue;
                int need = tries < 0x21 ? 3 : tries < 0x42 ? 2 : 1;
                int near_d = 99;
                for (int w = 0; w < CS.n_villages; w++) {
                    int ddx = CS.villages[w].map_x - x;
                    int ddy = CS.villages[w].map_y - y;
                    if (ddx < 0) ddx = -ddx;
                    if (ddy < 0) ddy = -ddy;
                    int d = ddx > ddy ? ddx : ddy;
                    if (d < near_d) near_d = d;
                }
                if (near_d <= need) continue;
                px = x;
                py = y;
                break;
            }
            if (px < 0) continue;
            if (CS.n_villages >= COLOPY_MAX_SETTLEMENTS) continue;
            NativeSettlement *v = &CS.villages[CS.n_villages++];
            memset(v, 0, sizeof(*v));
            v->map_x = (uint8_t)px;
            v->map_y = (uint8_t)py;
            v->owner_tribe = (uint8_t)(ti + 4);
            v->flags = (uint8_t)(placed_first ? 0 : 0x04);
            v->population = (uint8_t)(placed_first ? 2 * lv + 3
                                                   : 3 * lv + 4);
            placed_first = 1;
            v->mission = 0xFF;                          /* none */
            v->alarm[nation] = tension[ti];             /* v.alarm (5167) */
            v->walked_good = 0xFF;
            v->last_bought = 0xFF;
            v->last_sold = 0xFF;
            /* HOMELAND CLAIM: settlement creation writes the tribe into
             * the plane-3 owner nibble via the claim writer func_005E18
             * ((byte & 0xF) | owner<<4, @0x5E7E..@0x5E8B; the create
             * path calls it on the village tile @0x46E9E).  The RADIUS
             * is the engine's own getter func_00822A: 1/1/2/3 by
             * TRIBE TECH (byte-read 2026-08-30; the manual's "1/2" was
             * short).  First claim wins here, FLAGGED.  This keeps
             * rumour medallions (and details) off native country: the
             * marker predicate requires an UNCLAIMED nibble
             * (func_006188 @0x61BC). */
            {
                static const int HRAD[4] = { 1, 1, 2, 3 };
                int rad = HRAD[lv & 3];          /* func_00822A */
                for (int cy = py - rad; cy <= py + rad; cy++)
                    for (int cx = px - rad; cx <= px + rad; cx++) {
                        if (cx < 0 || cy < 0 || cx >= COLOPY_MAP_W ||
                            cy >= COLOPY_MAP_H) continue;
                        int mi = cy * COLOPY_MAP_W + cx;
                        if ((CS.region[mi] >> 4) != 0x0F) continue;
                        CS.region[mi] = (uint8_t)
                            ((CS.region[mi] & 0x0F) | ((ti + 4) << 4));
                    }
            }
        }
    }

    /* the player's starting force (682): ONE ship (Dutch = Merchantman)
     * carrying Soldiers then Pioneers, at the nation's start tile —
     * the riders are land units on the ship's water tile, exactly the
     * encoding the importer reads back as ship cargo (game.js:10451) */
    int sx = (int)dat_starts[nation][0], sy = (int)dat_starts[nation][1];
    int ship_type = unit_row(nation == 3 ? "Merchantman" : "Caravel");
    add_unit(ship_type, sx, sy, nation);
    add_unit(unit_row("Soldiers"), sx, sy, nation);
    int pio = add_unit(unit_row("Pioneers"), sx, sy, nation);
    if (pio >= 0) CS.units[pio].tools = PIONEER_TOOLS;

    /* seedRivals (7301): one ship each at their own start tile */
    for (int n = 0; n < 4; n++) {
        if (n == nation) continue;
        add_unit(unit_row(n == 3 ? "Merchantman" : "Caravel"),
                 (int)dat_starts[n][0], (int)dat_starts[n][1], n);
    }

    /* spawnBrave (5951), a second pass in village order: the first of
     * E,W,S,N that is land with no village and no earlier brave */
    int braves = unit_row("Braves");
    for (int vi = 0; vi < CS.n_villages; vi++) {
        static const int SPOT[4][2] = { {1,0}, {-1,0}, {0,1}, {0,-1} };
        for (int s = 0; s < 4; s++) {
            int bx = CS.villages[vi].map_x + SPOT[s][0];
            int by = CS.villages[vi].map_y + SPOT[s][1];
            if (tile_water(map_at(bx, by))) continue;
            int taken = 0;
            for (int w = 0; w < CS.n_villages && !taken; w++)
                if (CS.villages[w].map_x == bx && CS.villages[w].map_y == by)
                    taken = 1;
            for (int u = 0; u < CS.n_units && !taken; u++)
                if ((CS.units[u].owner_flags & 0x0F) >= 4 &&
                    CS.units[u].map_x == bx && CS.units[u].map_y == by)
                    taken = 1;
            if (taken) continue;
            add_unit(braves, bx, by,
                     4 + (CS.villages[vi].owner_tribe - 4));
            break;
        }
    }

    /* counts + their globals mirrors */
    put16(g + 0x1A, CS.n_villages);
    put16(g + 0x1C, CS.n_units);
    put16(g + 0x1E, CS.n_colonies);

    /* revealAll (733): the player's units light their surroundings —
     * one ship, sight radius 1 (sightRadius 8576) */
    reveal(sx, sy, 1, (uint8_t)(1u << (nation + 4)));

    /* tutOnce(1) (730): the fleet-on-the-high-seas opener — the focus
     * dispatcher's turn-0 arm (func_020F50 @0x020FB5..0x020FFB: turn 0,
     * difficulty 0, [0x5386]&0x10 clear; %STRING0 = @UNIT name) */
    tut_once(1, 0, 0, dat_units[ship_type].name, 0);

    /* G.mapSeed = 1 + random(0x7FFF) (742) */
    uint16_t mseed = (uint16_t)rng_range(1, 0x7FFF);

    /* seedMarket (4308): per-good start price start1..start2 */
    for (int i = 0; i < 16; i++)
        CS.powers[nation].price_level[i] =
            (uint8_t)(dat_cargo[i].start1 +
                      rng_range(0, (int32_t)(dat_cargo[i].start2 -
                                             dat_cargo[i].start1)));
    /* every other power starts level-for-level with the player: the
     * engine computes all four from ONE shared random price base with
     * empty pools (func_036574's tail @0x367E8..@0x36809) — copies, no
     * extra draws (JS seedMarket rivalMarket) */
    for (int p = 0; p < 4; p++)
        if (p != (int)nation)
            memcpy(CS.powers[p].price_level, CS.powers[nation].price_level,
                   sizeof(CS.powers[p].price_level));

    /* --- runtime: the loader's own build, then the fresh-game
     * overrides (the importer marks everyone met; beginGame does not:
     * t.met=false 5148 / seedRivals met:false 7307) --- */
    cr_reset_from_load();
    memset(CR.tribe_met, 0, sizeof(CR.tribe_met));
    for (int n = 0; n < 4; n++) CR.rivals[n].met = 0;
    CR.land_ho = 0;                  /* beginGame 695: landfall + first
                                      * colony still ahead */
    CR.built_colony = 0;
    CR.map_seed = mseed;
    CR.plot_seed = plot;
    units_session_seed();
    for (int k = 0; k < 3; k++) roll_immigrant(&CR.dock[k]);

    return COLOPY_OK;
}
