/* Map/tile queries — ports of game.js:356-455 + tileYield (2415), each a
 * one-for-one transcription. The yield tables come from the generated
 * dat_yields_* (same @UNFORESTED/@FORESTED/@OTHER rows the JS reads). */
#include <string.h>
#include "colopy_sim.h"
#include "../data/colopy_data.h"

colopy_runtime CR;

static uint32_t rng_s;
void colopy_init(uint32_t seed) { rng_s = seed; CS.rng = seed; CR.upkeep_unpaid = 0; }
uint32_t rng_next(void) {
    rng_s = rng_s * 214013u + 2531011u;
    CS.rng = rng_s;
    return (rng_s >> 16) & 0x7FFF;
}
int32_t rng_range(int32_t lo, int32_t hi) {
    return lo + (int32_t)((rng_next() * (uint32_t)(hi - lo + 1)) >> 15);
}

/* game.js:469 `at`: OFF-MAP READS AS OCEAN (25) — an off-map sentinel ship
 * sails "water" back toward the map edge, and no land query ever sees
 * ground beyond the border. */
uint8_t map_at(int x, int y) {
    if (x < 0 || y < 0 || x >= COLOPY_MAP_W || y >= COLOPY_MAP_H)
        return TERR_OCEAN;
    return CS.terrain[y * COLOPY_MAP_W + x];
}
/* The JS importer masks the improvement plane to road|plow (0x48) on load;
 * the C keeps the plane verbatim for byte-exact saves and masks on READ, so
 * logic sees exactly what the JS logic sees (plus the port's runtime
 * depletion marker). */
uint8_t map_improve(int x, int y) {
    if (x < 0 || y < 0 || x >= COLOPY_MAP_W || y >= COLOPY_MAP_H) return 0;
    return CS.improve[y * COLOPY_MAP_W + x] & (ROAD_BIT | PLOW_BIT | DEPLETED_BIT);
}

int tile_terrain(uint8_t v)   { return v & 0x1F; }
int tile_water(uint8_t v) {
    int t = v & 0x1F;
    return t == TERR_OCEAN || t == TERR_SEALANE;
}
int tile_hills(uint8_t v)     { return !tile_water(v) && (v & 0xA0) == 0x20; }
int tile_mountains(uint8_t v) { return !tile_water(v) && (v & 0xA0) == 0xA0; }
int tile_river(uint8_t v)     { return (v & 0x40) ? ((v & 0x80) ? 2 : 1) : 0; }

/* tileYield (game.js:2415): fold forested 16..23 onto 8..15, then the three
 * band tables; col 8 is the water/fisherman column. */
int tile_yield(uint8_t v, int col) {
    int t = v & 0x1F;
    if (t >= 16 && t <= 23) t = (t & 7) | 8;
    const int32_t *row;
    if (t <= 7)       row = dat_yields_unforested[t];
    else if (t <= 15) row = dat_yields_forested[t - 8];
    else if (t >= 24 && t - 24 < DAT_YIELDS_OTHER_COUNT) row = dat_yields_other[t - 24];
    else return 0;
    return (col >= 0 && col < 9) ? row[col] : 0;
}

/* ---- fog of war (game.js:8571..8600) ----
 * The plane's own bit convention: 1<<(power+4) (importer note 10272).
 * sightRadius (8576): Scouts 2; @UNIT rows 15..17 (Galleon/Privateer/
 * Frigate) 2; any naval row 13..18 with Hernando de Soto 2; else 1. */
int unit_sight_radius(int ui) {
    int t = CS.units[ui].type;
    if (t < 0 || t >= DAT_UNITS_COUNT) return 1;
    if (strcmp(dat_units[t].name, "Scouts") == 0) return 2;
    if (t >= 15 && t <= 17) return 2;
    if (t >= 13 && t <= 18 &&
        father_owned(father_by_name("Hernando de Soto"))) return 2;
    return 1;
}

/* reveal (game.js:8584): the r-radius square OR of the player's bit */
void colopy_reveal(int x, int y, int r) {
    uint8_t bit = (uint8_t)(1u << (cs_nation() + 4));
    for (int dy = -r; dy <= r; dy++)
        for (int dx = -r; dx <= r; dx++) {
            int tx = x + dx, ty = y + dy;
            if (tx < 0 || ty < 0 || tx >= COLOPY_MAP_W ||
                ty >= COLOPY_MAP_H)
                continue;
            CS.fog[ty * COLOPY_MAP_W + tx] |= bit;
        }
}

/* revealAll (game.js:8594): every player map unit by its sight radius,
 * every player colony at r=2 — run each turn (endTurn 10741) and at
 * game start (beginGame 733). */
void colopy_reveal_all(void) {
    for (int i = 0; i < CS.n_units; i++)
        if (unit_on_map_player(i))
            colopy_reveal(CS.units[i].map_x, CS.units[i].map_y,
                          unit_sight_radius(i));
    for (int ci = 0; ci < CS.n_colonies; ci++)
        if ((CS.colonies[ci].owner_power & 3) == cs_nation())
            colopy_reveal(CS.colonies[ci].map_x, CS.colonies[ci].map_y, 2);
}
