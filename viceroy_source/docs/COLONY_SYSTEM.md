> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# Colony System

Colonies are the core economic unit of the game. Each colony occupies one
map tile, draws workers from a 3×3 ring of surrounding tiles (the **colony
ring**), and produces commodities from terrain × occupation × building
combinations.

## Founding a colony

A unit of type `UNIT_PIONEER`, `UNIT_HARDY_PIONEER`, or any unit type
flagged as "can found colony" (free colonists, indentured servants,
veterans) executes the **Build Colony** order.

Preconditions checked by `colony_can_found(x, y)`:

1. Tile is land (terrain id < 25).
2. Tile is not occupied by another colony.
3. Tile is not directly adjacent to another colony of the same power
   (minimum 3-tile separation).
4. Founder unit's power has fewer than 32 colonies (table cap).

Effect:

- Allocate next free `ColonyRecord` slot in the ColonyTable.
- Set `owner = founder.owner`, `map_x/y = tile`, `population = 1`.
- Move founder unit *into* the colony as the first worker.
- Set initial building loadout: a single Town Hall slot (id 38).
- Mark the feature layer at the tile with the colony marker byte.

## Colony ring (8 surrounding tiles + center)

The colony tile itself is the **center** (always works at +1 Tools
production from its base building). The 8 surrounding tiles are workable
**only if not occupied by another colony or a sea-lane**. Coast-adjacent
colonies can fish in adjacent sea tiles.

```
+---+---+---+
| 0 | 1 | 2 |
+---+---+---+
| 7 |CTR| 3 |
+---+---+---+
| 6 | 5 | 4 |
+---+---+---+
```

Slot order in `worker_slots[24]` (per ColonyRecord):

- Slots 0..7: ring tiles in the order above
- Slots 8..15: in-colony specialists (workers in buildings)
- Slots 16..23: defenders/garrison

Each slot is a 16-bit value packing `unit_id` (bits 0..7) and either
`tile_id` for ring slots or `occupation_id` for in-colony slots
(bits 8..15).

@ref `../src/colony/assignment.c`

## Production calculation

Per turn, for each occupied worker slot:

```c
int compute_production(WorkerSlot *slot, ColonyRecord *colony) {
    Unit *u = &units[slot->unit_id];
    int base_yield;

    if (slot->is_ring_tile) {
        int tx = colony->map_x + RING_DX[slot->slot_idx];
        int ty = colony->map_y + RING_DY[slot->slot_idx];
        uint8_t terrain = map_terrain[ty * 58 + tx];
        int occupation = slot->occupation;          /* food/lumber/etc. */

        base_yield = TERRAIN_YIELD[terrain & 0x1F][occupation];

        if (terrain & 0x80) base_yield += FOREST_BONUS[occupation];
        if (terrain & 0x20) base_yield += PRIME_RESOURCE_BONUS[occupation];
        if (river_at(tx, ty)) base_yield += RIVER_BONUS[occupation];

    } else {
        /* in-colony worker: building-based production */
        int bld = colony->building[slot->building_slot];
        base_yield = BUILDING_BASE_OUTPUT[bld];
    }

    /* Expert multiplier */
    if (u->unit_type == EXPERT_FOR_OCCUPATION[occupation]) {
        base_yield *= 2;
    }

    /* SoL bonus */
    if (colony->sol_pct >= 50 && occupation != OCC_FOOD) {
        base_yield = (base_yield * 3) / 2;     /* +50% */
    }
    if (colony->sol_pct == 100 && occupation != OCC_FOOD) {
        base_yield *= 2;                        /* +100% */
    }

    return base_yield;
}
```

### Occupations

- `OCC_FOOD` (farmer / fisherman)
- `OCC_SUGAR`, `OCC_TOBACCO`, `OCC_COTTON`, `OCC_FURS`, `OCC_LUMBER`,
  `OCC_ORE`, `OCC_SILVER` (raw material gatherers)
- In-colony: `OCC_RUM`, `OCC_CIGARS`, `OCC_CLOTH`, `OCC_COATS`,
  `OCC_TOOLS`, `OCC_MUSKETS`, `OCC_HAMMERS`, `OCC_BELLS`,
  `OCC_CROSSES`

## Buildings

See [../include/building.h](../include/building.h) for the 39-entry
`BuildingId` enum.

**Building tiers** (most have 3 levels):

| Base               | Tier 2          | Tier 3          |
|--------------------|-----------------|-----------------|
| Stockade           | Fort            | Fortress        |
| Armory             | Magazine        | Arsenal         |
| Dock               | Drydock         | Shipyard        |
| School             | College         | University      |
| Warehouse          | Warehouse Exp.  | —               |
| Printing Press     | Newspaper       | —               |
| Weaver's House     | Weaver's Shop   | Textile Mill    |
| Tobacconist's Hse  | Tobacconist Shp | Cigar Factory   |
| Rum Distiller's H. | Rum Distiller S.| Rum Factory     |
| Fur Trader's House | Fur Trading Pst | Fur Factory     |
| Carpenter's Shop   | Lumber Mill     | —               |
| Church             | Cathedral       | —               |
| Blacksmith's House | Blacksmith Shop | Iron Works      |

Standalone (no upgrade):
- Town Hall (always present, produces bells)
- Stables, Custom House

## Hammers / Tools / Construction

```c
void colony_construct_tick(ColonyRecord *c) {
    if (c->in_construction == BLD_NONE) return;

    int building_id = c->in_construction;
    int hammers_needed = BUILDING_COST_TABLE[building_id].hammers;
    int tools_needed   = BUILDING_COST_TABLE[building_id].tools;

    /* Carpenter / Lumber Mill produces hammers from lumber */
    int produced = compute_hammers_this_turn(c);
    c->hammers += produced;

    if (c->hammers >= hammers_needed && c->stock[GOOD_TOOLS] >= tools_needed) {
        /* Complete it */
        c->stock[GOOD_TOOLS] -= tools_needed;
        c->hammers = 0;
        c->in_construction = BLD_NONE;
        place_building(c, building_id);
    }
}
```

## Sons of Liberty (SoL) and Tory %

SoL is computed per-colony each turn from:

```c
int sol_for_colony(ColonyRecord *c) {
    int bells_ratio = (c->bells_per_turn * 100) /
                      ((c->population * BELLS_PER_COLONIST_GOAL));
    return min(100, bells_ratio);
}
```

The aggregate per-power SoL drives the **Continental Congress** timer for
recruiting Founding Fathers (see [FOUNDING_FATHERS.md](FOUNDING_FATHERS.md)).

When `sol_pct >= 50`: +50% production on non-food goods.
When `sol_pct == 100`: +100% production AND military units in this colony
get the **rebellion bonus** (+50% combat).

## Crosses and immigration

Each colony with a Church/Cathedral produces "crosses" → drives the
immigration queue. When the queue fills:

```c
void church_tick(ColonyRecord *c, PowerRecord *p) {
    int crosses = compute_crosses(c);
    p->ff_progress += crosses; /* shared bell/cross pool? — see code */
    if (p->ff_progress >= IMMIGRATION_THRESHOLD[crosses_total]) {
        unit_arrive_in_europe(p, p->next_immigrant);
        p->next_immigrant = pick_next_recruit(p);
    }
}
```

@ref@ref `../src/colony/turn_update.c`

## Custom House

Once unlocked (and the founder Peter Stuyvesant is recruited, which is the
only way to build it), the Custom House sells excess stockpile commodities
directly to Europe at standard prices, bypassing the dock and avoiding
boycotts.

## Warehouse capacity

- No warehouse: max stock = 100 per commodity.
- Warehouse: max stock = 200.
- Warehouse Expansion: max stock = 300.

Excess at end-of-turn is destroyed and `warehouse_overflow` flag is set
(triggers a UI alert next time the colony is opened).

## Capture / siege / starvation

A colony with `population == 0` (because all colonists starved or died) is
**razed** — the ColonyRecord is freed and the feature-layer marker cleared.

A colony attacked by an enemy unit, with no defending units in the
garrison slots, is **captured**: ownership flips, all stockpile and
buildings transfer.

@ref `COMBAT.md`

## Cross-referenced sources

- ColonyRecord layout: [DATA_MODEL.md](../../docs/DATA_MODEL.md) §2
- Building enum: [../include/building.h](../include/building.h)
- Production formulas: `data_extracted/text/NAMES_sections.json` (@BUILDING/@JOB/@TERRAIN) + TBD
- Colony screen UI: [RENDER_CHAIN.md](RENDER_CHAIN.md)
