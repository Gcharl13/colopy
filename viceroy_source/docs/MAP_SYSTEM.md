> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# Map System

## Overview

VICEROY.EXE represents the New World as a **58 × 72 byte grid in three
parallel layers** (terrain / feature / resource). Of those 58 columns, the
leftmost and rightmost are **sea-lane border columns** (terrain id 26),
giving the player a **56 × 72 playable area**.

Maps live on disk as `.MP` files (4 stock maps + procedurally generated)
and are loaded into the in-memory map buffer at DGROUP `0x0E000`.

## File format

See [../formats/MP.md](../formats/MP.md) for the full byte layout. Summary:

```
+0x0000  4 bytes  width  (LE uint16) + height (LE uint16)
+0x0004  4 bytes  reserved (zeros in stock maps)
+0x0008  4176 b   Terrain layer    (58 × 72 × 1)
+0x1058  4176 b   Feature layer    (cities, units, special markers)
+0x20A8  4176 b   Resource overlay (gold, silver, prime resources)
```

## Terrain encoding (1 byte per tile)

```
bit 7 : Forested       (overlays a tree sprite atop base terrain)
bit 6 : Road or River  (interpretation depends on bit 5 + base)
bit 5 : Prime resource (this tile has its prime good available)
bits 4..0 : Base terrain id (0..31)
```

Decoding pseudocode:

```c
uint8_t cell = map_terrain[y * 58 + x];
int base_terrain   = cell & 0x1F;
int has_prime      = (cell >> 5) & 1;
int has_road_river = (cell >> 6) & 1;
int is_forested    = (cell >> 7) & 1;
```

## Base terrain types (21 active + 11 reserved)

The full list comes from `NAMES.TXT @TERRAIN`. **Do NOT use mapedit.c** — it
has been wrong about ordering before, see CLAUDE.md.

| ID  | Name              | Movement | Defense | Notes                 |
|-----|-------------------|----------|---------|-----------------------|
| 0   | Tundra            | 1        | 0       | Cold north            |
| 1   | Desert            | 1        | 0       | Hot south             |
| 2   | Plains            | 1        | 0       | Standard farmland     |
| 3   | Prairie           | 1        | 0       | Grasslands            |
| 4   | Grassland         | 1        | 0       | Lush                  |
| 5   | Savannah          | 1        | 0       | Equatorial            |
| 6   | Marsh             | 2        | 0       | Slow movement         |
| 7   | Swamp             | 2        | 0       | Slow + disease risk   |
| 8   | Boreal (forested Tundra)   | 2 | 25% | Auto-forest range start (CLAUDE.md ruling) |
| 9   | Scrub (forested Desert)    | 2 | 25% |                       |
| 10  | Mixed (forested Plains)    | 2 | 25% |                       |
| 11  | Broadleaf (forested Prairie)| 2 | 25% |                      |
| 12  | Conifer (forested Grassland)| 2 | 25% |                      |
| 13  | Tropical (forested Savannah)| 2 | 25% |                      |
| 14  | Wetland (forested Marsh)   | 2 | 25% |                       |
| 15  | Rain (forested Swamp)      | 2 | 25% |                       |
| 16-23 | (second encoding of the 8 forest variants: 16->8 .. 23->15) | | | folds to 8..15 via `(id&7)\|8` @0x6225 |
| 24  | Arctic            | 2        | 0       | polar ice             |
| 25  | Ocean             | 1 (ship) | 0       | open water            |
| 26  | Sea Lane          | 1 (ship) | 0       | right-edge sea-lane column (hard rule 2) |
| 27  | Mountains         | 3        | 100%    | heavy defense         |
| 28  | Hills             | 2        | 50%     | defense bonus         |

Terrain id ordering = `NAMES.TXT $TERRAIN` (CLAUDE.md hard rule 1; resolved in
`notes/rulings/RULINGS.md` + `formats/MP_FORMAT.md`): **24=Arctic, 25=Ocean,
26=Sea Lane, 27=Mountains, 28=Hills**. The earlier "16=Arctic / 18=Hills /
19=Mountains / 20=Lake / 25=Sea / 27=River" table was the stale mapedit-derived
ordering and is wrong. The auto-forest range **8..23** is byte-verified at
VICEROY.EXE 0x6204 (`get_terrain_id_from_raw`, masks `&0x1F` then folds 8..23 to
the 8 canonical forest ids 8..15) and 0x6831B.

## Feature layer

The feature layer encodes **non-terrain entities at each tile**:

- 0x00 — empty
- 0x01..0x40 — colony marker (low bits = colony slot id)
- 0x41..0xA0 — native settlement marker
- 0xA1..0xC0 — special features (Lost City Rumor, ancient burial ground)
- 0xC1..0xFF — reserved

@ref `../src/load_image/load_image_*.c`, `MAP_GENERATION.md`

## Resource overlay (14 types)

The resource layer adds a "prime resource" or "small bonus" sprite atop
the base terrain. Only active when terrain bit 5 (prime) is set.

| Overlay ID | Resource    | On terrain                  |
|-----------|-------------|-----------------------------|
| 0x00      | (none)      | (clear)                     |
| 0x01      | Sugar       | Savannah, Grassland         |
| 0x02      | Tobacco     | Plains, Grassland           |
| 0x03      | Cotton      | Prairie, Plains             |
| 0x04      | Furs        | Forest variants             |
| 0x05      | Lumber      | Forest variants             |
| 0x06      | Ore         | Hills, Mountains            |
| 0x07      | Silver      | Mountains, Hills            |
| 0x08      | Fish        | Sea adjacent                |
| 0x09      | Wheat (food)| Plains, Prairie             |
| 0x0A      | Beaver      | Forest                      |
| 0x0B      | Minerals    | Hills                       |
| 0x0C      | Oasis       | Desert                      |
| 0x0D      | Wheat field | Plains (high)               |
| 0x0E      | Tobacco big | Grassland                   |


## Movement cost calculation

```c
int tile_movement_cost(int from_x, int from_y, int to_x, int to_y) {
    uint8_t cell = map_terrain[to_y * 58 + to_x];
    int base = cell & 0x1F;
    int forested = (cell >> 7) & 1;
    int road = ((cell >> 6) & 1) && !is_river_cell(cell);

    if (road) return 1;                /* roads always 1 mp */
    if (forested) return 2;            /* forested terrain 2 mp */
    return TERRAIN_BASE_COST[base];    /* terrain table */
}
```

Diagonal moves cost the same as orthogonal (per the game's discrete movement
model).

## Defense bonus

```c
int tile_defense_bonus(int x, int y) {
    uint8_t cell = map_terrain[y * 58 + x];
    int base = cell & 0x1F;
    int forested = (cell >> 7) & 1;
    int bonus = TERRAIN_DEFENSE_PCT[base];
    if (forested) bonus = max(bonus, 25);
    return bonus;
}
```

## Discovered/visible mask

A separate per-power **522-byte bitmap** (58 × 72 / 8 = 522) tracks which
tiles each power has discovered. Stored in the save file at +0xB9B0.

@ref `../include/save.h`

## Map generation

The 4 stock maps (`AMER2.MP`, `AMER3.MP`, `BLANK4.MP`, `ONE.MP`) ship
pre-generated. The "random" option invokes the procedural generator
documented in [MAP_GENERATION.md](MAP_GENERATION.md).

## Display coordinates

In the renderer, the map viewport shows `15 × 12 tiles` (320×200 ÷ 16-pixel
tiles, with sidebar reservation). The chain
`func_O514 → func_O513 → func_O512` per CLAUDE.md is what draws each tile.

@ref `RENDER_CHAIN.md`
