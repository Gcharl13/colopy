/* Unit movement costs — game.js:10820 moveCost + the band-table column
 * readers (game.js:2317-2323). Budgets are in THIRDS (spec/systems/unit.md
 * §3); the terrain table's `movement` column is whole moves. A road at both
 * ends, or a cardinal step along a river through both tiles, costs a single
 * third. */
#include "colopy_sim.h"
#include "colopy_data.h"

#define MOVE_UNIT 3   /* thirds per whole move (game.js:631) */

/* terrainCol (game.js:2317): fold forested 16..23, then the three bands. */
static int terrain_col(uint8_t v, const int32_t *unf, const int32_t *fore,
                       const int32_t *other, int n_other) {
    int t = v & 0x1F;
    if (t >= 16 && t <= 23) t = (t & 7) | 8;
    if (t <= 7) return unf[t];
    if (t <= 15) return fore[t - 8];
    return (t >= 24 && t - 24 < n_other) ? other[t - 24] : 0;
}

int terrain_move(uint8_t v) {
    int m = terrain_col(v, dat_terrainmove_unforested, dat_terrainmove_forested,
                        dat_terrainmove_other, DAT_TERRAINMOVE_OTHER_COUNT);
    return m ? m : 1;
}

int terrain_defence(uint8_t v) {
    return terrain_col(v, dat_defensive_unforested, dat_defensive_forested,
                       dat_defensive_other, DAT_DEFENSIVE_OTHER_COUNT);
}

/* the pioneer work threshold column (+0x2F78 byte, game.js improveWork) */
int improve_work(uint8_t v) {
    return terrain_col(v, dat_improvework_unforested, dat_improvework_forested,
                       dat_improvework_other, DAT_IMPROVEWORK_OTHER_COUNT);
}

static int has_road(int x, int y) { return (map_improve(x, y) & ROAD_BIT) != 0; }

/* moveCost (game.js:10823), in thirds. */
int move_cost(int is_ship, int fx, int fy, int tx, int ty) {
    if (is_ship) return MOVE_UNIT;
    if (has_road(fx, fy) && has_road(tx, ty)) return 1;
    if (tile_river(map_at(fx, fy)) && tile_river(map_at(tx, ty)) &&
        (fx == tx || fy == ty)) return 1;
    return MOVE_UNIT * terrain_move(map_at(tx, ty));
}
