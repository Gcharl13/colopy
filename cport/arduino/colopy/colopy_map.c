/* Map/tile queries — ports of game.js:356-455 + tileYield (2415), each a
 * one-for-one transcription. The yield tables come from the generated
 * dat_yields_* (same @UNFORESTED/@FORESTED/@OTHER rows the JS reads). */
#include "colopy_sim.h"
#include "colopy_data.h"

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
