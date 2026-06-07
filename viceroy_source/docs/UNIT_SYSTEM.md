> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# Unit System

Units are individuals or vessels owned by a power, occupying a single map
tile (or being carried inside another unit's cargo hold).

The UnitRecord layout is in [DATA_MODEL.md §3](DATA_MODEL.md#3-unit-record--28-bytes-0x1c).

## Unit types (45 active)

The full list comes from `NAMES.TXT @UNIT`. Selected types:

### Foot units (no cargo, walk on land)

| ID  | Name                | Move | Atk | Def | Cargo | Notes                  |
|-----|---------------------|------|-----|-----|-------|------------------------|
| 0   | Free Colonist       | 1    | 1   | 1   | 0     | Becomes any specialist |
| 1   | Indentured Servant  | 1    | 1   | 1   | 0     | Promotes to colonist   |
| 2   | Petty Criminal      | 1    | 1   | 1   | 0     | Promotes to servant    |
| 3   | Expert Farmer       | 1    | 1   | 1   | 0     | 2× food production     |
| 4   | Expert Fisherman    | 1    | 1   | 1   | 0     | 2× fish production     |
| 5   | Expert Sugar Planter| 1    | 1   | 1   | 0     |                        |
| 6   | Expert Tobacco Planter | 1 | 1  | 1   | 0     |                        |
| 7   | Expert Cotton Planter  | 1 | 1  | 1   | 0     |                        |
| 8   | Expert Fur Trapper  | 1    | 1   | 1   | 0     |                        |
| 9   | Expert Lumberjack   | 1    | 1   | 1   | 0     |                        |
| 10  | Expert Ore Miner    | 1    | 1   | 1   | 0     |                        |
| 11  | Expert Silver Miner | 1    | 1   | 1   | 0     |                        |
| 12  | Master Distiller    | 1    | 1   | 1   | 0     | In-colony specialist   |
| 13  | Master Tobacconist  | 1    | 1   | 1   | 0     |                        |
| 14  | Master Weaver       | 1    | 1   | 1   | 0     |                        |
| 15  | Master Fur Trader   | 1    | 1   | 1   | 0     |                        |
| 16  | Master Carpenter    | 1    | 1   | 1   | 0     |                        |
| 17  | Master Blacksmith   | 1    | 1   | 1   | 0     |                        |
| 18  | Master Gunsmith     | 1    | 1   | 1   | 0     |                        |
| 19  | Elder Statesman     | 1    | 1   | 1   | 0     | 2× bells production    |
| 20  | Firebrand Preacher  | 1    | 1   | 1   | 0     | 2× crosses production  |
| 21  | Hardy Pioneer       | 1    | 1   | 1   | 0     | 2× pioneer work        |
| 22  | Veteran Soldier     | 1    | 2   | 2   | 0     | Promotes to dragoon w/ horses |
| 23  | Jesuit Missionary   | 1    | 1   | 1   | 0     | Can found mission      |
| 24  | Indian Convert      | 1    | 1   | 1   | 0     | From mission graduates |

### Combat units

| ID  | Name             | Move | Atk | Def | Notes                       |
|-----|------------------|------|-----|-----|------------------------------|
| 25  | Soldier          | 1    | 2   | 1   | Free colonist + 50 muskets   |
| 26  | Veteran Soldier  | 1    | 2   | 2   | Earned via combat XP         |
| 27  | Continental Army | 1    | 3   | 2   | Veteran after declaring indep|
| 28  | Dragoon          | 2    | 3   | 1   | Soldier + 50 horses          |
| 29  | Veteran Dragoon  | 2    | 3   | 2   |                             |
| 30  | Continental Cav. | 2    | 4   | 2   | After indep                  |
| 31  | Artillery        | 1    | 4   | 2   | Built in colony, costs hammers/tools |
| 32  | Damaged Artillery| 1    | 2   | 1   | After taking damage          |
| 33  | Scout            | 4    | 1   | 1   | Free colonist + 50 horses    |
| 34  | Pioneer          | 1    | 1   | 1   | + 100 tools, terraforms      |

### Naval units

| ID  | Name           | Move | Atk | Def | Cargo | Notes              |
|-----|----------------|------|-----|-----|-------|---------------------|
| 35  | Caravel        | 4    | 0   | 2   | 2     | Cheapest ship       |
| 36  | Merchantman    | 5    | 0   | 4   | 4     |                     |
| 37  | Galleon        | 6    | 0   | 6   | 6     |                     |
| 38  | Privateer      | 8    | 8   | 4   | 2     | Hidden nationality  |
| 39  | Frigate        | 6    | 16  | 8   | 4     |                     |
| 40  | Man-O-War      | 5    | 24  | 12  | 6     | Strongest warship   |

### Special

| ID  | Name              | Notes                                |
|-----|-------------------|--------------------------------------|
| 41  | Wagon Train       | 4 cargo, land-only goods transport   |
| 42  | Treasure          | Lost-City treasure (delivered to Eur)|
| 43  | Brave             | Native warrior (foot)                |
| 44  | Mounted Brave     | Native warrior (mounted, has horses) |

@ref `../include/unit.h`, `NAMES.TXT @UNIT`

## Promotions / training

Free Colonists can be **promoted** to specialists by:

1. **Working in a school** (3 turns): trained in whatever the colony's
   education infrastructure level supports (School: Colonist→Master,
   College: → Expert, University: → Statesman/Preacher).
2. **Living in a native settlement** (Speak with Chief + train): learn the
   skill the tribe teaches (`skills_known[8]` on NativeSettlement).
3. **Combat veterancy**: Soldier wins 2 battles → Veteran Soldier.

## Cargo system

Each cargo slot holds **either** 100 units of one commodity **or** one
unit (transported as a passenger). A galleon's 6 cargo slots can therefore
carry 600 commodity units, or 6 colonists, or any mix.

```c
struct CargoEntry {           /* 2 bytes */
    uint8_t  type;            /* 0xFF = empty, 0x80+id = unit, 0..63 = commodity */
    uint8_t  quantity;        /* 0..100 if commodity; 1 if unit */
};
```

Cargo loading:

```c
int unit_load_cargo(Unit *carrier, int commodity, int qty) {
    for (int i = 0; i < carrier->cargo_max; i++) {
        if (carrier->cargo[i].type == commodity) {
            int space = 100 - carrier->cargo[i].quantity;
            int load = min(space, qty);
            carrier->cargo[i].quantity += load;
            return load;
        }
    }
    /* New slot */
    for (int i = 0; i < carrier->cargo_max; i++) {
        if (carrier->cargo[i].type == 0xFF) {
            carrier->cargo[i].type = commodity;
            carrier->cargo[i].quantity = min(100, qty);
            return carrier->cargo[i].quantity;
        }
    }
    return 0;
}
```

@ref `../src/unit/cargo.c`

## Movement

```c
int unit_can_move_to(Unit *u, int tx, int ty) {
    if (!in_bounds(tx, ty)) return 0;

    int terrain = map_terrain[ty * 58 + tx] & 0x1F;
    int is_water = (terrain >= 25);
    int is_naval = (UNIT_TYPE_TABLE[u->unit_type].flags & UF_NAVAL);

    if (is_naval && !is_water) return 0;       /* ships can't go on land */
    if (!is_naval && is_water && !on_ship(u)) return 0;  /* foot can't swim */

    int cost = tile_movement_cost(u->map_x, u->map_y, tx, ty);
    if (u->movement_left < cost && cost != INF) {
        /* Allow partial-move with chance to fail */
        return rand() % cost == 0;
    }
    return 1;
}
```

Foot units **board ships** by moving into the same tile as a ship with
free cargo capacity; they auto-load.

## Pioneer commands

Pioneer (and Hardy Pioneer) units consume tools to perform terraforming:

| Action       | Tool cost | Turns | Effect                          |
|--------------|-----------|-------|----------------------------------|
| Plow field   | 20        | 5     | Bonus food on plains/prairie     |
| Build road   | 20        | 4     | Sets road bit, halves move cost  |
| Clear forest | 20        | 6     | Removes forest bit               |
| Plant forest | 20        | 6     | Adds forest bit                  |
| Build bridge | 40        | 6     | Crosses river (if road)          |

Hardy Pioneer halves the turn count.

## Sentry / Fortify

```c
enum {
    UNIT_FLAG_SENTRY    = 0x08,   /* Wakes when enemy/native enters sight */
    UNIT_FLAG_FORTIFIED = 0x10,   /* +50% defense, can't move */
};
```

A fortified unit gets `defense * 1.5`. A sentried unit auto-skips its turn
but wakes if any enemy enters its visible range.

## REF (Royal Expeditionary Force)

When the player declares independence (see [REVOLUTION.md](REVOLUTION.md)),
the king deploys his REF — accumulated over the game on PowerRecord
(`ref_regulars`, `ref_dragoons`, `ref_artillery`, `ref_manowar`).

REF units are **owned by power slot 4** (the king), have +50% combat over
normal soldiers, and land via Man-O-Wars on the eastern coast.

## Cross-references

- Combat resolution: [COMBAT.md](COMBAT.md)
- Cargo & ports: [EUROPEAN_DIPLOMACY.md](EUROPEAN_DIPLOMACY.md)
- Native warriors: [NATIVE_RELATIONS.md](NATIVE_RELATIONS.md)
