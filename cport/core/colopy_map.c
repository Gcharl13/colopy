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
/* tile_terrain_variant_hash (@0x0060A0): the tile's DETAIL ID -- and that
 * id IS the prime-resource id (the field yield's getter 0x37F:0x4B0
 * resolves to file 0x60A0 by the type-B thunk rule stub = seg*16 + off +
 * 0x2400, proven on 0x37F:0x10E -> 0x5CFE map_tile_read_layer_15C).
 * Resources are procedural, not a plane.  DTAB stands in for the runtime
 * table at [0x192]. */
static const int8_t MAP_DTAB[29] = { 6, 1, 2, 3, 4, 5, 6, 6,
                                     9, 1, 8, 9, 10, 10, 6, 6,
                                     9, 1, 8, 9, 10, 10, 6, 6,
                                     -1, 7, -1, 12, 13 };
int map_detail_id(int mx, int my, uint8_t v) {
    if (!CR.map_seed) return -1;             /* gate @0x60A9 */
    if (mx < 0 || my < 0 || mx >= COLOPY_MAP_W || my >= COLOPY_MAP_H)
        return -1;
    int idx = my * COLOPY_MAP_W + mx;
    int imp = CS.improve[idx];
    /* the pre-gate func_005F82 (@0x0060B3-@0x0060C4): improvement bit 2
     * with the TERRITORY plane's high nibble >= 4 (a tribe owner;
     * func_005DF0 = [0x164] byte >> 4, 0xF none) suppresses the detail */
    int owner = CS.region[idx] >> 4;
    if ((imp & 2) && owner != 0x0F && owner >= 4) return -1;
    int t = v & 0x1F;
    int forest = (t >= 8 && t <= 0x17);
    int q = (mx & 3) * 4 + (my & 3);
    int h = ((my >> 2) * 3 + (mx >> 2) + (CR.map_seed & 0xF) - forest) & 0xF;
    if (h != q && (h ^ 0xA) != q) return -1;
    int cls = tile_mountains(v) ? 27 : tile_hills(v) ? 28 : t;
    int d = MAP_DTAB[cls];
    if (d < 0) return -1;
    /* improve bit 4 suppresses the detail EXCEPT table entry 0xC, which
     * becomes id 0 (@0x00616A-@0x00617E) */
    if (imp & 4) return d == 0xC ? 0 : -1;
    return d;
}

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

/* The engine's terrain classifier for yields — BYTE_VERIFIED
 * `func_00624E @0x624E` (the 0x3E4:0xE thunk target): bit5 set means the
 * tile IS hills (0x1C) or, with bit7 also set, mountains (0x1B), and the
 * yield row is the @OTHER Mountains/Hills row — NOT the base terrain in
 * bits 0..4.  This is what pays ore miners 4 on mountain tiles (the
 * COLONY_SHIP baseline's Vlissingen scene badges, 2026-08-28). */
int tile_yield_class(uint8_t v) {
    if (v & 0x20) return (v & 0x80) ? 27 : 28;   /* @0x6254..@0x6266 */
    return v & 0x1F;
}

/* tileYield: classify per func_00624E, fold forested 16..23 onto 8..15,
 * then the three band tables; col 8 is the water/fisherman column. */
int tile_yield(uint8_t v, int col) {
    int t = tile_yield_class(v);
    if (t >= 16 && t <= 23) t = (t & 7) | 8;
    const int32_t *row;
    if (t <= 7)       row = dat_yields_unforested[t];
    else if (t <= 15) row = dat_yields_forested[t - 8];
    else if (t >= 24 && t - 24 < DAT_YIELDS_OTHER_COUNT) row = dat_yields_other[t - 24];
    else return 0;
    return (col >= 0 && col < 9) ? row[col] : 0;
}

/* The raw improvement byte — the DOS yield code tests bits the masked
 * map_improve() drops: roads are `al & 0x0A` (@0x9C9B/@0x9F01), plow
 * `al & 0x40` (@0x9F1F), the silver-mine bit `al & 4` (@0x9E5D). */
uint8_t map_improve_raw(int x, int y) {
    if (x < 0 || y < 0 || x >= COLOPY_MAP_W || y >= COLOPY_MAP_H) return 0;
    return CS.improve[y * COLOPY_MAP_W + x];
}

/* count of the 8 neighbours whose base terrain id lies in [lo,hi] —
 * BYTE_VERIFIED `func_0099EE @0x99EE` (per-neighbour test @0x99AE:
 * in-bounds, then `(v & 0x1F)` between the two bounds).  The fisherman
 * ladder calls it with (0x19,0x1A) = ocean/sea-lane. */
int map_count8_terr(int x, int y, int lo, int hi) {
    static const int8_t NDX[8] = { 0, 1, 0, -1, -1, 1, 1, -1 };
    static const int8_t NDY[8] = { -1, 0, 1, 0, -1, -1, 1, 1 };
    int n = 0;
    for (int k = 0; k < 8; k++) {
        int tx = x + NDX[k], ty = y + NDY[k];
        if (tx < 0 || ty < 0 || tx >= COLOPY_MAP_W || ty >= COLOPY_MAP_H)
            continue;
        int t = CS.terrain[ty * COLOPY_MAP_W + tx] & 0x1F;
        if (t >= lo && t <= hi) n++;
    }
    return n;
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

/* func_003710 — the unit ICON RESOLVER (byte-read 2026-08-30).  The @UNIT
 * icon column is only the BASE: type 0 Colonists resolve per profession
 * (@0x3749 -> the sub-resolver @0x36B2: experts icon = prof + 0x52 -> png
 * 81+row; the class rows via the inline jump table @0x36C4 = the F4 figure
 * cluster), and the five equipment types fall back to the PLAIN gray
 * variants when the matching expert profession is absent: Pioneers png 73
 * unless Hardy (@0x3751), Soldiers 74 unless Veteran (@0x3761), Scouts 75
 * unless Seasoned (@0x377B), Dragoons 76 unless Veteran SOLDIERS
 * (@0x376E — a mounted veteran keeps his 0x15 byte), Missionaries 77
 * unless Jesuit (@0x378B); damaged Artillery draws the broken cart, png 65
 * (@0x37A5, record +0x04 bit 0x80).  Braves and ships fall through.
 * Returns png space (VICEROY index − 1).  Profession byte semantics are
 * UNIFORM here: 0 = Expert Farmers (the +0x52 arithmetic applies to 0,
 * corroborating the manifest capture), 28 = no specialty (the 0x36B2
 * table maps 0x1C to the plain-colonist icon 101) — C4.26's unit side. */
int unit_icon_parts(int type, int prof, int damaged) {
    int has = prof >= 0 && prof < DAT_JOBEXPERT_COUNT;
    if (type == 0) {                              /* Colonists */
        if (has && prof <= 18) return 81 + prof;  /* prof + 0x52 */
        switch (has ? prof : -1) {
        case 19: return 100; case 20: return 58; case 21: return 59;
        case 22: return 60;  case 23: return 104; case 24: return 61;
        case 25: return 106; case 26: return 107; case 27: return 66;
        default: return 100;
        }
    }
    if (type == 2 && !(has && prof == 20)) return 73;   /* Pioneers */
    if (type == 1 && !(has && prof == 21)) return 74;   /* Soldiers */
    if (type == 5 && !(has && prof == 22)) return 75;   /* Scouts */
    if (type == 4 && !(has && prof == 21)) return 76;   /* Dragoons */
    if (type == 3 && !(has && prof == 24)) return 77;   /* Missionaries */
    if (type == 11 && damaged) return 65;               /* Artillery */
    return (int)dat_units[type].icon - 1;
}
int unit_icon_of(int ui) {
    return unit_icon_parts(CS.units[ui].type, CS.units[ui].profession,
                           CR.unit_damaged[ui]);
}
