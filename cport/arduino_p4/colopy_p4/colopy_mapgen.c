/* The procedural New World builder — a FLAGGED RECONSTRUCTION (2026-09-09,
 * RULINGS 2026-09-09c; user-approved as such).
 *
 * WHAT IS EVIDENCE AND WHAT IS NOT.  The original builder is func_064A10
 * @0x064A10 (the [0x190] salt draw @0x064A16..0x064A23 is byte-verified
 * here; the four Customize selectors it reads at DGROUP 0x1E7E..0x1E84
 * are byte-verified, RULINGS 2026-09-08a).  The pass SKELETON below —
 * ocean init; blob growth to a land target (land_mass+land_form+1)*0x140;
 * a smoothing budget (p_iter+1)*0x320; two six-entry latitude tables;
 * a 20-cell river kernel; the four-column sea-lane / two-row Arctic
 * outline (that part IS byte-verified: @0x65941..0x659CA, the same
 * premade-map pass colopy_newgame.c cites); four east-coast starts at
 * H/5 bands — is the sibling port's reading of that function and is
 * UNVERIFIED in this tree (lead: read func_064A10 whole).  Every rule
 * INSIDE a pass — the walkers and their restart, the relaxation
 * predicate, the latitude jitter, the forest / hill / mountain / river
 * rolls, the start rotation — is INVENTED.  Worlds from here are "a
 * random New World", not the game's; nothing in this file may be cited
 * as the engine's behaviour.
 *
 * WHY IT IS HERE ANYWAY.  The board has no other way to start a game off
 * the shipped America map, and the title's NEW WORLD / CUSTOMIZE rows
 * lead here in the original.  The generator is deterministic on the
 * [0x190] salt with a map-local MS-C rand (state*214013+2531011, high
 * 15 bits; random_int(lo,hi) = lo + ((r*(hi-lo+1))>>15)) so the
 * simulation's shared stream is NOT perturbed, and it is shared
 * draw-for-draw with game.js generateNewWorld — the newgame oracle
 * compares the resulting terrain (maphash) and every unit square across
 * NEW and CUSTOM worlds, so the two engines cannot drift apart on it. */
#include <string.h>

#include "colopy_core.h"
#include "colopy_state.h"

#define MG_OCEAN  0x19               /* @OTHER: 24 Arctic / 25 Ocean / */
#define MG_LANE   0x1A               /* 26 Sea Lane (CLAUDE.md rule 2)  */
#define MG_ARCTIC 0x18

typedef struct { uint32_t s; } map_rng;

static uint32_t mr_next(map_rng *r) {
    r->s = r->s * 214013u + 2531011u;
    return (r->s >> 16) & 0x7FFFu;
}
static int mr_range(map_rng *r, int lo, int hi) {
    return lo + (int)((mr_next(r) * (uint32_t)(hi - lo + 1)) >> 15);
}
static int clampi(int v, int lo, int hi) {
    return v < lo ? lo : v > hi ? hi : v;
}
static int is_land_marker(const uint8_t *m, int x, int y) {
    return x >= 0 && y >= 0 && x < COLOPY_MAP_W && y < COLOPY_MAP_H &&
           m[y * COLOPY_MAP_W + x] == 0;
}
static int count_land8(const uint8_t *m, int x, int y) {
    int n = 0;
    for (int dy = -1; dy <= 1; dy++)
        for (int dx = -1; dx <= 1; dx++)
            if ((dx || dy) && is_land_marker(m, x + dx, y + dy)) n++;
    return n;
}

/* P6 (RECONSTRUCTED): an east-to-west coast search on the nation's H/5
 * band, widening to the neighbouring rows when the band crosses no
 * land; the start is the water square just east of the first coast. */
static void pick_start(const uint8_t *m, int band_y, uint8_t out[2]) {
    for (int radius = 0; radius < COLOPY_MAP_H; radius++) {
        int ys[2] = { band_y - radius, band_y + radius };
        int ny = radius ? 2 : 1;
        for (int q = 0; q < ny; q++) {
            int y = ys[q];
            if (y < 2 || y >= COLOPY_MAP_H - 2) continue;
            for (int x = COLOPY_MAP_W - 4; x >= 2; x--) {
                int here = m[y * COLOPY_MAP_W + x] & 0x1F;
                int east = m[y * COLOPY_MAP_W + x + 1] & 0x1F;
                if (here != MG_OCEAN && here != MG_LANE &&
                    (east == MG_OCEAN || east == MG_LANE)) {
                    out[0] = (uint8_t)(x + 1);
                    out[1] = (uint8_t)y;
                    return;
                }
            }
        }
    }
    out[0] = COLOPY_MAP_W - 2;
    out[1] = (uint8_t)clampi(band_y, 2, COLOPY_MAP_H - 3);
}

colopy_status colopy_generate_world(uint16_t seed,
                                    const colopy_world_options *world,
                                    uint8_t terrain[COLOPY_PLANE],
                                    uint8_t starts[4][2]) {
    static const int8_t DX[8] = { 0, 1, 1, 1, 0, -1, -1, -1 };
    static const int8_t DY[8] = { -1, -1, 0, 1, 1, 1, 0, -1 };
    /* the two six-entry latitude tables (base terrain ids 0..7 in the
     * NAMES $TERRAIN order): the sibling's reading of func_064A10,
     * UNVERIFIED here */
    static const uint8_t NORTH[6] = { 5, 4, 1, 3, 2, 2 };
    static const uint8_t SOUTH[6] = { 2, 3, 3, 4, 6, 7 };
    int p[5];
    map_rng r;

    if (!terrain || !starts || !world ||
        (world->mode != COLOPY_WORLD_NEW &&
         world->mode != COLOPY_WORLD_CUSTOM))
        return COLOPY_ERR_BAD_COMMAND;
    if (world->mode == COLOPY_WORLD_CUSTOM &&
        (world->land_mass > 2 || world->land_form > 2 ||
         world->temperature > 2 || world->climate > 2))
        return COLOPY_ERR_BAD_COMMAND;

    r.s = seed ? seed : 1;
    if (world->mode == COLOPY_WORLD_CUSTOM) {
        p[0] = world->land_mass;
        p[1] = world->land_form;
        p[2] = world->temperature;
        p[3] = world->climate;
        p[4] = 1;                 /* the fifth setup word, not exposed */
    } else {
        /* NEW WORLD: the boot dispatcher seeds all five setup words with
         * random_int(0,3) (sibling's cite @0x75C86..0x75CC2, UNVERIFIED
         * here) — drawn on the map-local stream */
        for (int i = 0; i < 5; i++) p[i] = mr_range(&r, 0, 3);
    }

    memset(terrain, MG_OCEAN, COLOPY_PLANE);

    /* P1 (RECONSTRUCTED walkers; the target formula is the sibling's
     * cite): one independently seeded 8-direction walker per land
     * mass, many for Archipelago, few for continents */
    {
        int target = (p[0] + p[1] + 1) * 0x140;
        int blobs = clampi(12 - 3 * p[1], 3, 12);
        int made = 0;
        for (int b = 0; b < blobs && made < target; b++) {
            int quota = (target - made + blobs - b - 1) / (blobs - b);
            int x = mr_range(&r, 3, COLOPY_MAP_W - 4);
            int y = mr_range(&r, 2, COLOPY_MAP_H - 3);
            int got = 0;
            for (int tries = 0; tries < quota * 80 && got < quota; tries++) {
                int i = y * COLOPY_MAP_W + x;
                if (terrain[i] == MG_OCEAN) {
                    terrain[i] = 0;
                    got++;
                    made++;
                }
                int d = mr_range(&r, 0, 7);
                int nx = x + DX[d], ny = y + DY[d];
                if (nx < 2 || nx >= COLOPY_MAP_W - 2 ||
                    ny < 2 || ny >= COLOPY_MAP_H - 2 ||
                    (tries && tries % 97 == 0)) {
                    x = mr_range(&r, 3, COLOPY_MAP_W - 4);
                    y = mr_range(&r, 2, COLOPY_MAP_H - 3);
                } else {
                    x = nx;
                    y = ny;
                }
            }
        }
    }

    /* P3 relaxation (RECONSTRUCTED predicate; the budget is the
     * sibling's cite): fill ocean pockets with enough land neighbours,
     * thin lone land squares; the climate word tilts it wetter */
    for (int k = 0; k < (p[4] + 1) * 0x320; k++) {
        int x = mr_range(&r, 2, COLOPY_MAP_W - 3);
        int y = mr_range(&r, 2, COLOPY_MAP_H - 3);
        int i = y * COLOPY_MAP_W + x;
        int n = count_land8(terrain, x, y);
        if (terrain[i] == MG_OCEAN) {
            if (n >= 5 - clampi(p[3], 0, 2)) terrain[i] = 0;
        } else if (n <= 1 && mr_range(&r, 0, 3) != 0) {
            terrain[i] = MG_OCEAN;
        }
    }

    /* P2 latitude bands (RECONSTRUCTED jitter and rolls): base terrain
     * by distance from the equator shifted by temperature, forest = +8
     * (CLAUDE.md rule 3, ids 8..23) by the climate word, hills 0x20 and
     * mountains 0xA0 by an elevation roll (formats/MP_FORMAT.md bits) */
    {
        int eq = COLOPY_MAP_H / 2;
        for (int y = 1; y < COLOPY_MAP_H - 1; y++)
            for (int x = 2; x < COLOPY_MAP_W - 2; x++) {
                int i = y * COLOPY_MAP_W + x;
                if (terrain[i] != 0) continue;
                int dist = y < eq ? eq - y : y - eq;
                int band = (dist * 6) / eq + (1 - p[2]) + mr_range(&r, -1, 1);
                band = clampi(band, 0, 5);
                int base = (y < eq ? NORTH : SOUTH)[band];
                if (mr_range(&r, 0, 3) < clampi(p[3] + 1, 1, 3)) base += 8;
                uint8_t t = (uint8_t)base;
                int elev = mr_range(&r, 0, 5);
                if (elev >= 4) t |= 0x20;        /* hills */
                if (elev == 5 && mr_range(&r, 0, 2) == 0) t |= 0x80; /* mountains */
                terrain[i] = t;
            }
    }

    /* P4 rivers (RECONSTRUCTED source roll; the 20-cell interior kernel
     * is the sibling's cite): a sparse minor river (0x40) on land squares
     * whose 20-cell neighbourhood holds no water, western half only */
    {
        static const int8_t KX[20] = {
             0, 1, 0,-1,-1, 1, 1,-1, 0, 2, 0,-2,-1, 1,-1, 1,-2,-2, 2, 2 };
        static const int8_t KY[20] = {
            -1, 0, 1, 0,-1,-1, 1, 1,-2, 0, 2, 0,-2,-2, 2, 2,-1, 1,-1, 1 };
        for (int y = 2; y < COLOPY_MAP_H - 2; y++)
            for (int x = 2; x < COLOPY_MAP_W / 2; x++) {
                int i = y * COLOPY_MAP_W + x;
                int base = terrain[i] & 0x1F;
                if (base == MG_OCEAN || base == MG_LANE || mr_range(&r, 0, 31)) continue;
                int enclosed = 1;
                for (int k = 0; k < 20; k++) {
                    int b = terrain[(y + KY[k]) * COLOPY_MAP_W + x + KX[k]] & 0x1F;
                    if (b == MG_OCEAN || b == MG_LANE) { enclosed = 0; break; }
                }
                if (enclosed) terrain[i] |= 0x40;
            }
    }

    /* P5 outline — BYTE-VERIFIED (the loader's own pass, @0x65941..
     * 0x659CA): rows 0 and h-1 Arctic, columns 0/1 and w-2/w-1 Sea Lane */
    for (int y = 0; y < COLOPY_MAP_H; y++)
        for (int x = 0; x < COLOPY_MAP_W; x++) {
            int i = y * COLOPY_MAP_W + x;
            if (y == 0 || y == COLOPY_MAP_H - 1) terrain[i] = MG_ARCTIC;
            else if (x <= 1 || x >= COLOPY_MAP_W - 2) terrain[i] = MG_LANE;
        }

    /* P6 starts at H/5 bands, nation order = identity (the original's
     * rotation is unread) */
    for (int n = 0; n < 4; n++)
        pick_start(terrain, (COLOPY_MAP_H / 5) * (n + 1), starts[n]);
    return COLOPY_OK;
}
