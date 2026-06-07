> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# Map Generation

## Two paths

VICEROY.EXE supports **two ways** of providing a map:

1. **Stock map**: load from `.MP` file (`AMER2.MP`, `AMER3.MP`,
   `BLANK4.MP`, `ONE.MP`).
2. **Random map**: procedurally generate a 56×72 New World layout.

The game prompts on new-game setup. Random map uses the algorithm below.

## Random map algorithm

Pseudocode reconstructed from the map-gen overlay:

```c
void map_generate_random(uint32_t seed) {
    srand(seed);

    /* Stage 1: Coastline */
    init_all_water();                       /* every cell = sea (id 25) */
    place_continent_seed(20, 36);            /* center of map */

    /* Voronoi-like growth */
    for (int iter = 0; iter < 200; iter++) {
        Coord c = random_land_neighbor();
        if (!c.valid) break;
        map_terrain[c.y * 58 + c.x] = TERRAIN_PLAINS;  /* land */
    }

    /* Stage 2: Climate zones */
    for each row y:
        Climate clim = climate_for_row(y);
        /* North → Tundra, mid → Plains/Forest, equator → Jungle/Desert */
        for each col x with land:
            map_terrain[y * 58 + x] = pick_terrain_for_climate(clim);

    /* Stage 3: Mountains and hills */
    for (int i = 0; i < 30; i++) {
        Coord c = random_land();
        place_mountain_chain(c, random_range(3, 8));
    }
    for (int i = 0; i < 60; i++) {
        Coord c = random_land();
        if (map_terrain[c.y * 58 + c.x] != MOUNTAIN)
            map_terrain[c.y * 58 + c.x] = HILLS;
    }

    /* Stage 4: Rivers */
    for (int i = 0; i < 15; i++) {
        Coord src = pick_mountain_or_high_terrain();
        trace_river_to_sea(src);            /* sets river bit */
    }

    /* Stage 5: Forests */
    for each cell with terrain in {plains,prairie,grassland,etc}:
        if (random_chance(40)) {
            map_terrain[c.y * 58 + c.x] |= 0x80;     /* forested bit */
        }

    /* Stage 6: Resources */
    for each cell:
        if (random_chance(15)) {
            map_terrain[c.y * 58 + c.x] |= 0x20;     /* prime resource bit */
            place_resource_overlay(c);
        }

    /* Stage 7: Sea-lane border (left and right columns = sea-lane id 26) */
    for (int y = 0; y < 72; y++) {
        map_terrain[y * 58 + 0]  = TERRAIN_SEA_LANE;
        map_terrain[y * 58 + 57] = TERRAIN_SEA_LANE;
    }

    /* Stage 8: Native settlements */
    place_native_settlements(random_range(20, 30));

    /* Stage 9: Lost City Rumors */
    place_lcr_markers(random_range(15, 25));

    /* Stage 10: Starting positions for the 4 powers */
    pick_starting_positions(4);
}
```

@ref `COLONIZATION_TECHNICAL_REFERENCE.md` §11 (Map Generation)

## Climate gradient

```c
Climate climate_for_row(int y) {
    /* y = 0 north pole, y = 71 equator */
    if (y < 8)  return CLIMATE_ARCTIC;
    if (y < 16) return CLIMATE_TUNDRA;
    if (y < 32) return CLIMATE_TEMPERATE;
    if (y < 56) return CLIMATE_SUBTROPICAL;
    return CLIMATE_TROPICAL;
}
```

Per-climate terrain weights:

| Climate     | Terrain weights                                                    |
|-------------|---------------------------------------------------------------------|
| Arctic      | Tundra 100%                                                         |
| Tundra      | Tundra 50%, Marsh 25%, Forest(tundra) 25%                           |
| Temperate   | Plains 30%, Prairie 25%, Grassland 20%, Forest 15%, Hills 10%      |
| Subtropical | Grassland 30%, Savannah 25%, Forest(grass) 20%, Swamp 15%, Hills 10% |
| Tropical    | Savannah 30%, Marsh 25%, Swamp 25%, Forest 15%, Desert 5%          |

## Mountain chain placement

```c
void place_mountain_chain(Coord start, int length) {
    Coord c = start;
    int dx = random_chance(50) ? -1 : 1;
    for (int i = 0; i < length; i++) {
        if (in_bounds(c) && is_land(c)) {
            map_terrain[c.y * 58 + c.x] = TERRAIN_MOUNTAIN;
        }
        c.x += dx + random_range(-1, 1);
        c.y += random_range(-1, 1);
    }
}
```

## River tracing

```c
void trace_river_to_sea(Coord src) {
    Coord c = src;
    int max_steps = 50;
    while (max_steps-- > 0) {
        if (terrain_id(c) == TERRAIN_SEA) break;
        map_terrain[c.y * 58 + c.x] |= 0x40;  /* river bit */
        c = next_lower_neighbor(c);            /* descend "altitude" */
        if (c.x < 0 || c.x >= 58) break;
    }
}
```

## Native settlement placement

```c
void place_native_settlements(int n) {
    for (int i = 0; i < n; i++) {
        Coord c = random_land();
        if (settlement_too_close(c, 4)) continue;     /* min spacing */

        int tribe = pick_tribe_for_climate(climate_at(c));
        int type = pick_settlement_type(tribe);
        spawn_settlement(tribe, type, c);
    }
}
```

Tribe-to-climate mapping:

| Climate     | Likely tribes                |
|-------------|------------------------------|
| Tundra      | (none — too cold)            |
| Temperate   | Iroquois, Cherokee           |
| Subtropical | Apache, Sioux, Cherokee      |
| Tropical    | Aztec, Inca, Arawak, Tupi    |

## Starting position selection

```c
void pick_starting_positions(int n_powers) {
    /* Each power needs a coastal land tile, far from other powers */
    for (int p = 0; p < n_powers; p++) {
        Coord c;
        for (int attempt = 0; attempt < 100; attempt++) {
            c = random_coastal_land_tile();
            if (no_other_power_within(c, 8)) break;
        }
        powers[p].start_x = c.x;
        powers[p].start_y = c.y;
    }
}
```

## Stock-map idiosyncrasies

Each stock map has artist-placed features:

- **`AMER2.MP`** (default): Earth's American continent, recognizable
  shape. Hand-placed native settlements at historical sites.
- **`AMER3.MP`**: Larger continent with extra land area.
- **`BLANK4.MP`**: Mostly water, used for testing the random-map seeding.
- **`ONE.MP`**: One small island; used for AI testing.

## Cross-references

- Map cell encoding: [MAP_SYSTEM.md](MAP_SYSTEM.md)
- File format: [../formats/MP.md](../formats/MP.md)
