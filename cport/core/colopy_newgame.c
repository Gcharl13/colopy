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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "colopy_core.h"
#include "colopy_sim.h"
#include "../data/colopy_data.h"

/* START_GOLD (game.js:629) */
static const int32_t START_GOLD[5] = { 1000, 300, 0, 0, 0 };
/* TRIBE_SITE_DX/DY (game.js TRIBE_SITE_DX): 0 since G11 (2026-09-03) --
 * the 2 compensated a terrain table shifted by two tiles (the old
 * extract_mp.py read the .MP version word as tiles) */
#define TRIBE_SITE_DX 0
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
static void build_regions(void);
void colopy_build_regions(void) { build_regions(); }
static void build_regions(void) {
    /* func_063880 @0x063880 (0x1A1F:0x7DC), read whole 2026-09-09 and
     * matched 4176/4176 against every fixture's region plane (RULINGS
     * 2026-09-09e).  A raster labeller run TWICE ([bp-0x1C] 1 = water
     * bodies, then 0 = land) over rows 1..h-2, columns w-2 down to 1
     * (the border keeps id 0): per square the three squares of the row
     * above (@0x063922) adopt or MERGE the run id -- the larger working
     * id is relabelled to the smaller over every row so far (@0x0638C8),
     * its size folded in and freed (@0x063973/@0x063978); a fresh
     * component takes the LOWEST free working id (`[bp-0x2E]=0; inc;
     * while size != 0` @0x063992..0x0639C9), from 0x11 for land on rows
     * 1 / h-2 (@0x063997..0x0639AE); the run id [bp-0xC] is NOT reset at
     * a row end, so a run ending at x=1 continues at (w-2, y+1) when that
     * square is the same class -- the original's seam quirk, reproduced.
     * Then the compaction @0x063A8B: working ids <= 15 stay, larger ones
     * take the lowest free slot 1..15 at first appearance (row-major, all
     * rows), any further component shares 0xF.  Each class restarts at 1
     * (the fixtures: ocean 1, main continent 1).  The 16-word size table
     * [0x85C8] holds the LAST class -- land -- which the builder's P1
     * counts.  High nibble = territory owner, 0xF none (func_005DF0).
     * Scratch: the working-id plane lives in a static int16 plane, the
     * size table in CS.fog (free here: the builder wipes plane 4 at P6a
     * and re-clears it before every walker; no loader calls this). */
    static int16_t ids[COLOPY_PLANE];
    int16_t *size = (int16_t *)CS.fog;             /* 2088 entries */
    const int NSIZE = (int)(sizeof(CS.fog) / sizeof(int16_t));
    memset(CS.region, 0, sizeof(CS.region));
    for (int cls = 1; cls >= 0; cls--) {
        memset(ids, 0, sizeof(ids));
        memset(size, 0, sizeof(CS.fog));
        int cur = 0;
        for (int y = 1; y < COLOPY_MAP_H - 1; y++)
            for (int x = COLOPY_MAP_W - 2; x >= 1; x--) {
                int i = y * COLOPY_MAP_W + x;
                if ((tile_water(CS.terrain[i]) != 0) != cls) { cur = 0; continue; }
                for (int k = -1; k <= 1; k++) {
                    int a = ids[(y - 1) * COLOPY_MAP_W + x + k];
                    if (a == 0) continue;
                    if (cur == 0) { cur = a; continue; }
                    if (a == cur) continue;
                    int big = a > cur ? a : cur, small = a > cur ? cur : a;
                    size[small] = (int16_t)(size[small] + size[big]);
                    size[big] = 0;
                    for (int j = COLOPY_MAP_W; j < (y + 1) * COLOPY_MAP_W; j++)
                        if (ids[j] == big) ids[j] = (int16_t)small;
                    cur = small;
                }
                if (cur == 0) {
                    int id = (cls == 0 && (y == 1 || y == COLOPY_MAP_H - 2)) ? 0x11 : 1;
                    while (id < NSIZE - 1 && size[id] != 0) id++;
                    cur = id;                      /* < 2088 for any 8-connected map */
                }
                ids[i] = (int16_t)cur;
                size[cur]++;
            }
        for (int i = 0; i < COLOPY_PLANE; i++) {
            int w = ids[i], f;
            if (w == 0) continue;
            if (w <= 15) f = w;
            else if (size[w] > 0) {
                int s = 1;
                while (s <= 15 && size[s] != 0) s++;
                if (s > 15) f = 15;
                else { size[s] = size[w]; size[w] = (int16_t)-s; f = s; }
            } else f = -size[w];
            CS.region[i] = (uint8_t)f;
        }
    }
    memset(CS.fog, 0, sizeof(CS.fog));
    for (int i = 0; i < COLOPY_PLANE; i++) CS.region[i] |= 0xF0;
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
    u->home_settlement = 0xFF;             /* +0x06: no settlement (C3.9) */
    return CS.n_units++;
}

/* the @JOB row of an expert name (28 = none when absent) */
static int expert_row(const char *name) {
    for (int i = 0; i < DAT_JOBEXPERT_COUNT; i++)
        if (strcmp(dat_jobexpert[i], name) == 0) return i;
    return DAT_JOBEXPERT_COUNT;
}

/* the 8-direction tables at DS:0xB4 / DS:0xBE (file 0x1DA54 / 0x1DA5E):
 * N, NE, E, SE, S, SW, W, NW, then two (0,0) entries -- the natives
 * placer walks entries 0..7 and scans 0..8 */
static const int8_t NDX[10] = { 0, 1, 1, 1, 0, -1, -1, -1, 0, 0 };
static const int8_t NDY[10] = { -1, -1, 0, 1, 1, 1, 0, -1, 0, 0 };

/* func_00624E (behind 0x181F:0x78C = func_00627A, which answers 0x19
 * Ocean off the 1..W-2 / 1..H-2 interior): 0x1B Mountains / 0x1C Hills
 * for a relief tile, else the id */
static int terrain_class(uint8_t v) {
    if (v & 0x20) return (v & 0x80) ? 0x1B : 0x1C;
    return v & 0x1F;
}
/* func_004900 (0x181F:0x370): max(|dx|,|dy|) + (min >> 1) */
static int engine_dist(int dx, int dy) {
    int a = dx < 0 ? -dx : dx, b = dy < 0 ? -dy : dy;
    return b < a ? (b >> 1) + a : (a >> 1) + b;
}
/* func_046056 (0x181F:0xD84) called as (x, y, -1, -1): the nearest
 * settlement by engine_dist -- a later equal distance wins (`jg` skips
 * only strictly farther, @0x460C5), 0x270F / -1 with none.  The engine
 * also selects the winner (0x181F:0xA4C) so [0x8D50] holds its tribe. */
static int nearest_settlement(int x, int y, int *dist) {
    int best = -1, bd = 0x270F;
    for (int i = 0; i < CS.n_villages; i++) {
        int d = engine_dist(CS.villages[i].map_x - x,
                            CS.villages[i].map_y - y);
        if (d > bd) continue;
        best = i;
        bd = d;
    }
    *dist = bd;
    return best;
}
/* 0x181F:0x302 (func_005BFA): the 1..W-2 / 1..H-2 interior */
static int in_bounds(int x, int y) {
    return x >= 1 && y >= 1 && x <= COLOPY_MAP_W - 2 && y <= COLOPY_MAP_H - 2;
}

/* settlement creation func_046E18 (0x1A1F:0x440) plus the port's record
 * model: owner tribe ti (0..7), population 2*tech+3 (see below), the
 * mission/trade bytes 0xFF, the human's alarm from the tribe tension,
 * and the HOMELAND CLAIM.  Returns the index, -1 at the 84 cap
 * (@0x46E21). */
static int create_village(int ti, int px, int py, int capital,
                          int nation, uint8_t tension) {
    int lv = dat_tribes[ti].level;
    if (CS.n_villages >= COLOPY_MAX_SETTLEMENTS) return -1;
    NativeSettlement *v = &CS.villages[CS.n_villages];
    memset(v, 0, sizeof(*v));
    v->map_x = (uint8_t)px;
    v->map_y = (uint8_t)py;
    v->owner_tribe = (uint8_t)(ti + 4);
    v->flags = (uint8_t)(capital ? 0x04 : 0);
    /* the opening population is 2*tech+3 for EVERY settlement, the capital
     * included: func_046E18 sizes +0x04 through 0x1A1F:0x410 BEFORE the
     * caller sets the capital bit (+0x03 is cleared @0x46EA7, the bit lands
     * @0x66095 / @0x66225), so the capital size 3*tech+4 is only the cap
     * growth aims for.  Read off a pristine DOS capture (dos_world_oracle,
     * 2026-09-10: capitals 9/7/5/3 for tech 3/2/1/0). */
    v->population = (uint8_t)(2 * lv + 3);
    v->mission = 0xFF;                          /* none */
    v->alarm[nation] = tension;                 /* v.alarm (5167) */
    v->walked_good = 0xFF;
    v->last_bought = 0xFF;
    v->last_sold = 0xFF;
    /* the tile: plane-2 bit 2 (`or byte es:[bx],2` @0x46E91 -- the
     * SETTLEMENT bit the placer's own `improve & 3` tests and the
     * detail gate read) and the HOMELAND CLAIM, the tribe into the
     * plane-3 owner nibble via the claim writer func_005E18
     * ((byte & 0xF) | owner<<4, @0x5E7E..@0x5E8B) on the village tile
     * ONLY (@0x46E9E).  The pristine DOS capture (2026-09-10) shows every
     * village tile claimed and the further claims -- scattered squares
     * within two of a village, never a filled radius -- written by the
     * tribes' first turn (the per-tribe turn calls the writer @0x0489E5),
     * so the port's earlier tech-radius fill (func_00822A's 1/1/2/3 is a
     * roaming radius, not a claim) is gone.  The marker predicate still
     * needs an UNCLAIMED nibble (func_006188 @0x61BC). */
    {
        int mi = py * COLOPY_MAP_W + px;
        CS.improve[mi] |= 0x02;
        CS.region[mi] = (uint8_t)((CS.region[mi] & 0x0F) | ((ti + 4) << 4));
    }
    return CS.n_villages++;
}

/* the natives: the whole of func_065D26 (tensions, the two placement
 * modes, the braves, the hoard) on the stream as it stands -- the C
 * host exposes it to the DOS capture oracle (tools/dos_world_oracle.py)
 * through colopy_oracle_place_natives */
static void place_natives(uint8_t nation, uint8_t difficulty,
                          const colopy_world_options *world) {
    /* every `improve & 3` below reads the RAW plane-2 byte (0x181F:0x754):
     * bit 1 = a colony, bit 2 = a settlement -- map_improve() masks those
     * off (roads/plow/depleted only), which hid the settlement bit the
     * creator sets @0x46E91 from the placer (JS/C lockstep, 2026-09-10) */
    /* func_065D26 (0x1A1F:0x87C, called @0x07596A after the starting
     * units): the natives.  Per-tribe init @0x65E1D..@0x65E78 -- the
     * tribe selected (0x181F:0xA42), the @TRIBES NAMES.TXT row read
     * (four tokens, the fourth = +0x02 TECH @0x65E4D), +0x00/+0x01 = 1,
     * +0x04..+0x08 = 0, +0x0A/+0x0C = 0, then per POWER 0..3 the
     * tension word +0x46+2p = random_int(0, 14) + (controller == 0 ?
     * 2 * difficulty : 0) (@0x65D86..@0x65DD9: FOUR draws per tribe,
     * 32 in all) and +0x36+p = 0; then +0x3A..+0x45 and the sixteen
     * words at +0x0E zeroed.  The controller test [0x543F]: the human
     * power is 0 (@0x0745B6); the AI powers hold whatever the last game
     * left (@0x075AB9 sets them 1 AFTER this call; the EXE data image
     * seeds them 206/25/0/150) -- the port grants the bonus to the human
     * only, FLAGGED. */
    uint8_t tension[8];
    for (int ti = 0; ti < 8; ti++) {
        uint8_t *tr = CS.tribes + ti * 0x4E;
        tr[0] = 1;
        tr[1] = 1;
        tr[2] = (uint8_t)dat_tribes[ti].level;    /* +0x02 TECH */
        for (int p = 0; p < 4; p++) {
            int t = rng_range(0, 14) + (p == (int)nation ? 2 * difficulty : 0);
            put16(tr + 0x46 + 2 * p, (uint16_t)t);
            tr[0x36 + p] = 0;
        }
        tension[ti] = (uint8_t)(tr[0x46 + 2 * nation] | (tr[0x47 + 2 * nation] << 8));
    }

    if (world->mode == COLOPY_WORLD_AMERICA) {
        /* the TRIBE.TXT mode (@0x65E87: [0x5388] != 0 -> the file;
         * @0x660C4..@0x66246): per site a triangular +-2 jitter
         * (random_int(-1,1) + random_int(-1,1) per axis), up to 100
         * tries against passable, improve & 3 clear, terrain < 0x18
         * with (id & 7) not Desert/Swamp, nearest-settlement distance
         * (engine_dist, func_046056 @0x661A5) > 3/2/1 by tries; the
         * FIRST placed site is the capital (flags |= 4 @0x66225).
         * Mirrors game.js draw-for-draw. */
        for (int ti = 0; ti < 8; ti++) {
            int placed_first = 0;
            for (int k = 0; k < SITES_N[ti]; k++) {
                int bx = (int)SITES[ti][k][0] + TRIBE_SITE_DX;
                int by = (int)SITES[ti][k][1] + TRIBE_SITE_DY;
                int px = -1, py = -1;
                for (int tries = 1; tries <= 100; tries++) {
                    int dx = rng_range(-1, 1) + rng_range(-1, 1);
                    int dy = rng_range(-1, 1) + rng_range(-1, 1);
                    int x = bx + dx, y = by + dy;
                    if (!in_bounds(x, y)) continue;
                    uint8_t tv = map_at(x, y);
                    if (map_improve_raw(x, y) & 3) continue;
                    int tt = terrain_class(tv);
                    if (tt >= 0x18) continue;
                    tt &= 7;
                    if (!((tt >= 2 && tt <= 6) || tt == 0)) continue;
                    int near_d;
                    nearest_settlement(x, y, &near_d);
                    int need = tries < 0x21 ? 3 : tries < 0x42 ? 2 : 1;
                    if (near_d <= need) continue;
                    px = x;
                    py = y;
                    break;
                }
                if (px < 0) continue;
                if (create_village(ti, px, py, !placed_first, nation,
                                   tension[ti]) < 0)
                    continue;
                placed_first = 1;
            }
        }
    } else {
        /* the RANDOM mode (no file: @0x65F50..@0x660C0 the capitals,
         * @0x6624A..@0x664AF the satellites).  A 15x18 cell grid of
         * 5x5 squares at DS:0x9FAA (memset @0x65D53, x-stride 0x12),
         * per-tribe counts at DS:0x962A (@0x65D6C). */
        uint8_t grid[15][18];
        uint8_t tcount[8];
        int placed = 0;                            /* [bp-0xAA] */
        memset(grid, 0, sizeof(grid));
        memset(tcount, 0, sizeof(tcount));
        for (int ti = 0; ti < 8; ti++) {
            /* one CAPITAL per tribe: x = random_int(8, W-8), y =
             * random_int(12, H-12) (@0x65F5D..@0x65F83), rejected while
             * water (0x181F:0x768), relief (raw & 0x20, 0x181F:0x72C),
             * a settlement ON the square (nearest distance 0), nearest
             * distance < 90 - tries/4 (@0x65FD5..@0x65FE5), distance
             * < 8 until tries >= (8 - d) * 1000 (@0x65FE7..@0x65FFD),
             * for tribes 0/1 (Inca, Aztec) x * 8 > tries (@0x65FFF..
             * @0x66011: the west), and a taken cell until tries >=
             * 10000 (@0x66013..@0x66036); up to 12000 tries
             * (@0x66043), else the tribe gets no capital. */
            int tries = 0, ok = 0, x = 0, y = 0;
            do {
                tries++;
                x = rng_range(8, COLOPY_MAP_W - 8);
                y = rng_range(12, COLOPY_MAP_H - 12);
                ok = 0;
                do {
                    uint8_t tv = map_at(x, y);
                    int d;
                    if (tile_water(tv)) break;
                    if (tv & 0x20) break;
                    nearest_settlement(x, y, &d);
                    if (d == 0) break;
                    if (0x5A - (tries >> 2) > d) break;
                    if (d < 8 && (8 - d) * 1000 > tries) break;
                    if (ti < 2 && x * 8 > tries) break;
                    if (grid[x / 5][y / 5] != 0 && tries < 10000) break;
                    ok = 1;
                } while (0);
            } while (!ok && tries < 12000);
            if (!ok) continue;
            CS.tribes[ti * 0x4E + 0] = (uint8_t)x;   /* +0x00/+0x01: the
                                                      * capital square */
            CS.tribes[ti * 0x4E + 1] = (uint8_t)y;
            if (create_village(ti, x, y, 1, nation, tension[ti]) < 0)
                continue;
            tcount[ti]++;
            grid[x / 5][y / 5] = 1;
            placed++;
        }
        /* the SATELLITES: while placed < 0x10E (the grid size) and
         * tries < 0x10E * 8 and the count < 84: pick a tribe with a
         * capital (random_int(0,7) rerolled), walk its capital's cell
         * by random_int(0,7) steps (NDX/NDY) until a free cell (a step
         * off the 15x18 grid abandons the pass); scan the cell's 3x3
         * interior (yy = Y+1..Y+3 outer, xx = X+1..X+3 inner) for
         * in-bounds squares with improve & 3 clear, class < 0x18 and
         * (id & 7) in {0, 2..6}, and no improve & 3 on the 9-square
         * neighbourhood; place ONE at random_int(0, n-1) for the
         * NEAREST settlement's tribe ([0x8D50] after func_046056),
         * then mark the cell and count it placed even with no
         * candidate (@0x66497..@0x6649C). */
        {
            int tries = 0;
            int any = 0;
            for (int ti = 0; ti < 8; ti++) any |= tcount[ti];
            while (any && placed < 0x10E) {
                if (0x10E * 8 <= tries) break;
                if (CS.n_villages >= COLOPY_MAX_SETTLEMENTS) break;
                int ti;
                do { ti = rng_range(0, 7); } while (tcount[ti] == 0);
                int cx = CS.tribes[ti * 0x4E + 0] / 5;
                int cy = CS.tribes[ti * 0x4E + 1] / 5;
                int ok = 0;
                tries++;              /* ONE try per walk: `inc [bp-0xC0]` @0x662B5
                                       * sits before the step loop, which re-enters
                                       * at the draw @0x662B9 (DOS oracle, 2026-09-10:
                                       * counting steps ended the pass a walk early) */
                for (;;) {
                    int d = rng_range(0, 7);
                    cx += NDX[d];
                    cy += NDY[d];
                    if (cx < 0 || cx >= 15 || cy < 0 || cy >= 18) break;
                    if (grid[cx][cy] == 0) { ok = 1; break; }
                }
                if (!ok) continue;
                uint8_t cand[9][2];
                int n = 0;
                int X = cx * 5, Y = cy * 5;
                for (int yy = Y + 1; yy < Y + 4; yy++)
                    for (int xx = X + 1; xx < X + 4; xx++) {
                        if (!in_bounds(xx, yy)) continue;
                        if (map_improve_raw(xx, yy) & 3) continue;
                        int tt = terrain_class(map_at(xx, yy));
                        if (tt >= 0x18) continue;
                        tt &= 7;
                        if (!((tt >= 2 && tt <= 6) || tt == 0)) continue;
                        int hit = 0;
                        for (int k = 0; k < 9 && !hit; k++)
                            if (map_improve_raw(xx + NDX[k], yy + NDY[k]) & 3)
                                hit = 1;
                        if (hit) continue;
                        cand[n][0] = (uint8_t)xx;
                        cand[n][1] = (uint8_t)yy;
                        n++;
                    }
                if (n > 0) {
                    int i = rng_range(0, n - 1);
                    int d;
                    int near = nearest_settlement(cand[i][0], cand[i][1], &d);
                    int owner = CS.villages[near].owner_tribe - 4;
                    create_village(owner, cand[i][0], cand[i][1], 0, nation,
                                   tension[owner]);
                }
#if COLOPY_ORACLE
                if (getenv("COLOPY_NATIVES_TRACE"))
                    fprintf(stderr, "sat tries %d placed %d tribe %d cell %d,%d cand %d -> %d villages\n",
                            tries, placed, ti, cx, cy, n, CS.n_villages);
#endif
                grid[cx][cy] = 1;
                placed++;
            }
#if COLOPY_ORACLE
            if (getenv("COLOPY_NATIVES_TRACE"))
                fprintf(stderr, "sat end: tries %d placed %d villages %d\n", tries, placed, CS.n_villages);
#endif
        }
    }

    /* the BRAVES (@0x664B2..@0x665D3, both modes, before the hoard):
     * per settlement in order, up to 100 tries of x = sx +
     * random_int(-2, 2), y = sy + random_int(-2, 2) (@0x664DF..
     * @0x66512) accepted when in bounds, the SAME landmass nibble
     * (0x181F:0x6B4), not water and improve & 3 clear; spawn_unit(0x13
     * Braves, the settlement's tribe, x, y) with +0x06 = the home
     * settlement (@0x665A5..@0x665BE).  No unit check: braves may
     * stack. */
    {
        int braves = unit_row("Braves");     /* @UNIT row 0x13 */
        for (int vi = 0; vi < CS.n_villages; vi++) {
            int sx = CS.villages[vi].map_x, sy = CS.villages[vi].map_y;
            int reg = CS.region[sy * COLOPY_MAP_W + sx] & 0x0F;
            int tries = 0, ok = 0, x = 0, y = 0;
            do {
                x = sx + rng_range(-2, 2);
                y = sy + rng_range(-2, 2);
                ok = in_bounds(x, y);
                if (ok) {
                    if ((CS.region[y * COLOPY_MAP_W + x] & 0x0F) != reg) ok = 0;
                    if (tile_water(map_at(x, y))) ok = 0;
                    if (map_improve_raw(x, y) & 3) ok = 0;
                }
                tries++;
            } while (!ok && tries < 100);
            if (!ok) continue;
            int bi = add_unit(braves, x, y, CS.villages[vi].owner_tribe);
            if (bi >= 0) CS.units[bi].home_settlement = (uint8_t)vi;
        }
    }

    /* the tribe +0x0C HOARD word (RULINGS 2026-09-03e, JS seedNatives):
     * zeroed at tribe init (@0x65E71), then += the tribe's tech for every
     * in-bounds tile (1..W-2, 1..H-2) of the 5x5 box around each
     * settlement whose terrain class is 0x1B Mountains (@0x665E0..
     * @0x6664B, into the owning tribe @0x6662A) */
    for (int ti = 0; ti < 8; ti++) put16(CS.tribes + ti * 0x4E + 0x0C, 0);
    for (int vi = 0; vi < CS.n_villages; vi++) {
        int ti = CS.villages[vi].owner_tribe - 4;
        if (ti < 0 || ti >= 8) continue;
        uint8_t *hp = CS.tribes + ti * 0x4E + 0x0C;
        int hoard = hp[0] | (hp[1] << 8);
        for (int y = CS.villages[vi].map_y - 2; y <= CS.villages[vi].map_y + 2; y++)
            for (int x = CS.villages[vi].map_x - 2; x <= CS.villages[vi].map_x + 2; x++) {
                if (x < 1 || y < 1 || x > COLOPY_MAP_W - 2 || y > COLOPY_MAP_H - 2)
                    continue;
                uint8_t tv = map_at(x, y);
                if ((tv & 0xA0) == 0xA0) hoard += dat_tribes[ti].level;
            }
        put16(hp, (uint16_t)hoard);
    }
}

#if COLOPY_ORACLE
void colopy_oracle_place_natives(uint8_t nation, uint8_t difficulty, int mode) {
    colopy_world_options w;
    memset(&w, 0, sizeof(w));
    w.mode = (uint8_t)mode;
    place_natives(nation, difficulty, &w);
}
#endif

colopy_status colopy_new_game_ex(uint8_t nation, uint8_t difficulty,
                                 const char *leader_name,
                                 const colopy_world_options *world) {
    static const colopy_world_options AMERICA = {
        COLOPY_WORLD_AMERICA, 1, 1, 1, 1, 1
    };
    uint8_t starts[4][2];
    (void)leader_name;               /* the leader lives UI-side; no
                                      * record block carries the name */
    if (nation > 3 || difficulty > 4) return COLOPY_ERR_BAD_COMMAND;
    if (!world) world = &AMERICA;
    if (world->mode > COLOPY_WORLD_CUSTOM) return COLOPY_ERR_BAD_COMMAND;
    for (int n = 0; n < 4; n++) {
        starts[n][0] = (uint8_t)dat_starts[n][0];
        starts[n][1] = (uint8_t)dat_starts[n][1];
    }

    memset(&CS, 0, sizeof(CS));

    /* prelude: "COLONIZE" 00 1A + u16 (unread; FLAGGED 0) + w,h */
    memcpy(CS.prelude, "COLONIZE", 8);
    CS.prelude[8] = 0x00;
    CS.prelude[9] = 0x1A;
    put16(CS.prelude + 0x0C, COLOPY_MAP_W);
    put16(CS.prelude + 0x0E, COLOPY_MAP_H);

    /* planes: the shipped map, no improvements, regions rebuilt */
    memcpy(CS.terrain, dat_map_tiles, COLOPY_PLANE);
    /* VICEROY's load-time normalisation of a file map (G12, 2026-09-03;
     * formats/MP_FORMAT.md "VICEROY loader behavior"): new_game_state_init
     * fills rows 0 and h-1 with Arctic 0x18 (@0x75746..0x75785), then
     * func_064A10(1) outlines (0,0)-(w-1,h-1) and (1,0)-(w-2,h-1) with
     * Sea Lane 0x1A (@0x65941..0x65986 -- columns 0, 1, w-2, w-1),
     * re-fills rows 0/h-1 Arctic (@0x6598B..0x659CA), then folds every
     * tile (@0x659D8..0x65A85): base = b & 0x1F; base >= 0x18 untouched;
     * bit 0x20 set -> (b & 0xE0) | (base & 7); else 16 <= base < 24 ->
     * b - 8.  Layer 2 and the fog plane are zeroed (@0x65AA5..0x65ACE) --
     * CS.improve is already zero here, fog is CR runtime. */
    /* the outline / fold / landmass labels of the loader's own pass are
     * func_064A10's premade path, run below right after the salt draw
     * (2026-09-09; it also writes the plane-2 bits and the start squares) */

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
    /* the five Customize words [0x1E7E..0x1E86] (the title dispatcher
     * @0x075C86..@0x075CC2, read 2026-09-10 off the DOS capture oracle):
     * NEW WORLD and AMERICA draw EACH as random_int(0, 3) -- five draws,
     * the fifth the relaxation count the builder reads @0x06538D, so a
     * generated world's words run 0..3, not the dialog's 0..2 -- while
     * CUSTOMIZE sets all five to 1 (@0x075CBC) and its dialog then edits
     * the first four.  The JS beginGame draws at the same point. */
    colopy_world_options drawn = *world;
    if (world->mode != COLOPY_WORLD_CUSTOM) {
        drawn.land_mass = (uint8_t)rng_range(0, 3);
        drawn.land_form = (uint8_t)rng_range(0, 3);
        drawn.temperature = (uint8_t)rng_range(0, 3);
        drawn.climate = (uint8_t)rng_range(0, 3);
        drawn.iterations = (uint8_t)rng_range(0, 3);
    } else {
        drawn.iterations = 1;
    }
    world = &drawn;
    /* G.plotSeedBase = (random * 2^32) >>> 0 (677): with the shared
     * 15-bit stream that is exactly r * 131072 */
    uint32_t plot = rng_next() * 131072u;
    /* [0x190] = random_int(1, 0x7FFF) @0x64A16..0x64A23 -- the map
     * generator's first act, called from new_game_state_init @0x7579B
     * right after the .MP load, before any placement (G12; the JS draws
     * G.mapSeed at the same point) */
    uint16_t mseed = (uint16_t)rng_range(1, 0x7FFF);
    CR.map_seed = mseed;             /* the builder's detail pass hashes on it */
    /* func_064A10 continues here on the SHARED stream (2026-09-09, RULINGS
     * 2026-09-09d): the whole builder for NEW WORLD / CUSTOMIZE, the
     * premade tail (outline, fold, labels, plane-2 bits, the H/5-band
     * start squares dealt at random) for AMERICA -- the JS beginGame
     * runs generateNewWorld at the same point */
    {
        colopy_status ms = colopy_generate_world(
            world, world->mode == COLOPY_WORLD_AMERICA, starts);
        if (ms != COLOPY_OK) return ms;
    }

    /* [0x53A7] = 0 and [0x53A8] = random_int(1, 8) (@0x0757D3..
     * @0x0757E4, new_game_state_init): the wedding counter and the
     * REMEMBERED @KINGWAR country the tax cycle rerolls against
     * (king_war_cycle) -- one draw on the shared stream between the
     * builder and the natives (the JS beginGame draws at the same
     * point).  Of the four calls between the builder and this draw
     * (@0x0757AB..@0x0757BA): func_06892E clears the plane-3 owner
     * nibble to 0xF on every square (0 draws; the ports' labeller ends
     * the same way), func_063C58 builds the coarse connectivity grids
     * and the per-landmass counts the SAV tail carries (0 draws; not
     * computed here, the tail stays zero), func_063F3C the land-value
     * plane (0 draws) -- read 2026-09-10 -- and func_036574 is the
     * market/power init, which reseeds from the clock and draws its own
     * (see seedMarket below: its ORDER here is the port's, not the
     * original's, and stays FLAGGED). */
    g[0x27] = 0;
    g[0x28] = (uint8_t)rng_range(1, 8);   /* cr_reset_from_load reads it */

    /* the starting forces (@0x075820..@0x075961, read 2026-09-10): for
     * every power whose controller byte is not 2 -- all four play here --
     * in power order 0..3: the ship (13, the Merchantman 14 for power 3
     * @0x07587B), Pioneers (2) carrying 100 tools (+0x15 = 0x64 in the
     * pristine capture) and Soldiers (1), the two riders sentried (+0x08 =
     * 1 @0x07589B/@0x0758DB); the French Pioneers are Hardy (profession
     * 0x14 @0x0758BB), the Spanish Soldiers and a human's at Discoverer /
     * Explorer Veteran (0x15 @0x07590C, [bp-8] = controller 0 and
     * [0x53A6] <= 1).  Each spawns at (p-28, p-28) with the start square
     * at +0x09/+0x0A and crosses to it on the first turn: the port puts
     * them on the start square directly (C1.26 open).  The record order
     * is Pioneers THEN Soldiers, the tile stack chained newest-first
     * (+0x18/+0x1A in the capture); the port keeps its Soldiers-then-
     * Pioneers order -- the display order the live sidebar shows
     * (LIVE_UI_CHECK 2026-08-05) -- until the sidebar's stack walk is
     * read (C1.26).  The riders are land units on the ship's water tile,
     * exactly the encoding the importer reads back as ship cargo
     * (game.js:10451). */
    int sx = starts[nation][0], sy = starts[nation][1];
    int ship_type = unit_row(nation == 3 ? "Merchantman" : "Caravel");
    for (int n = 0; n < 4; n++) {
        int x = starts[n][0], y = starts[n][1];
        /* +0x32/+0x33: the square the spawn reads @0x075865.. */
        CS.powers[n].start_x = (uint8_t)x;
        CS.powers[n].start_y = (uint8_t)y;
        add_unit(unit_row(n == 3 ? "Merchantman" : "Caravel"), x, y, n);
        int sol = add_unit(unit_row("Soldiers"), x, y, n);
        if (sol >= 0) {
            CS.units[sol].orders = 1;
            if (n == 2 || (n == (int)nation && difficulty <= 1))
                CS.units[sol].profession = (uint8_t)expert_row("Veteran Soldiers");
        }
        int pio = add_unit(unit_row("Pioneers"), x, y, n);
        if (pio >= 0) {
            CS.units[pio].orders = 1;
            CS.units[pio].tools = PIONEER_TOOLS;
            if (n == 1)
                CS.units[pio].profession = (uint8_t)expert_row("Hardy Pioneers");
        }
    }

    /* the natives AFTER the four powers' starting units: the original's
     * unit records run ship/Soldiers/Pioneers for each power first and
     * the braves after (the DOS captures of 2026-09-10, all four worlds:
     * records 0..2 are the human's trio, 3.. the rivals', 12.. the
     * braves), so record 0 is the ship the front end centres on
     * (brief_begin) and the JS beginGame's order (mkUnit, seedNatives)
     * holds here too; the placer runs on its own reseeded stream in the
     * original, so the move costs no shared draw */
    place_natives(nation, difficulty, world);

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
    sav_tail_init();                 /* the trailing block the seeds and
                                      * routes are saved in (C3.7/C3.8) */
    cr_reset_from_load();
    memset(CR.tribe_met, 0, sizeof(CR.tribe_met));
    for (int n = 0; n < 4; n++) {
        CR.rivals[n].met = 0;
        CR.rivals[n].gold_undef = 1;   /* seedRivals carries no gold */
    }
    CR.met_anyone = 0;               /* beginGame 910 */
    CR.land_ho = 0;                  /* beginGame 695: landfall + first
                                      * colony still ahead */
    CR.built_colony = 0;
    CR.map_seed = mseed;
    CR.plot_seed = plot;
    units_session_seed();
    for (int k = 0; k < 3; k++) roll_immigrant(&CR.dock[k]);

    return COLOPY_OK;
}

/* The pre-2026-09-09 entry point: the shipped America map. */
colopy_status colopy_new_game(uint8_t nation, uint8_t difficulty,
                              const char *leader_name) {
    return colopy_new_game_ex(nation, difficulty, leader_name, 0);
}
