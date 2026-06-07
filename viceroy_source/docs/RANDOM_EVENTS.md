> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# Random Events

VICEROY.EXE generates several classes of random events:

1. **Lost City Rumors** (LCR) — terrain features that players can investigate
2. **Weather** — affects movement and production
3. **Disease** — population loss
4. **Native incidents** — separate from raids; spontaneous gifts/threats
5. **Pirates** — non-king naval threats

## Lost City Rumors (LCR)

Markers placed at random forest/mountain tiles at map generation. When a
unit enters the tile, the LCR is consumed and resolves to one of:

```c
enum LcrOutcome {
    LCR_NOTHING                 = 0,    /* fizzle */
    LCR_GOLD_SMALL              = 1,    /* +50 gold */
    LCR_GOLD_LARGE              = 2,    /* +500 gold */
    LCR_TREASURE                = 3,    /* spawn UNIT_TREASURE */
    LCR_FOUNTAIN_OF_YOUTH       = 4,    /* +8 free immigrants */
    LCR_LOST_CITY               = 5,    /* +5000 gold + treasure */
    LCR_BURIAL_GROUND_DESECRATED = 6,   /* -25 native attitude all tribes */
    LCR_SEASONED_SCOUT_PROMOTION = 7,   /* unit promoted to Seasoned Scout */
    LCR_MISSIONARY_SHRINE       = 8,    /* +1 free Missionary */
    LCR_NATIVE_BURIAL_TREASURE  = 9,    /* small gold but -10 attitude */
    LCR_GHOSTLY_GALLEON         = 10,   /* small treasure */
};
```

### Outcome weights

```c
/* LCR outcome weight table (totals to 100) */
const uint8_t lcr_weights[] = {
    [LCR_NOTHING]                 = 25,
    [LCR_GOLD_SMALL]              = 18,
    [LCR_GOLD_LARGE]              = 5,
    [LCR_TREASURE]                = 12,
    [LCR_FOUNTAIN_OF_YOUTH]       = 2,
    [LCR_LOST_CITY]               = 1,
    [LCR_BURIAL_GROUND_DESECRATED] = 8,
    [LCR_SEASONED_SCOUT_PROMOTION] = 4,
    [LCR_MISSIONARY_SHRINE]       = 3,
    [LCR_NATIVE_BURIAL_TREASURE]  = 12,
    [LCR_GHOSTLY_GALLEON]         = 10,
};
```

Outcome modifiers:

- **Hardy Pioneer or Seasoned Scout** investigating: re-roll on negative
  outcomes once.
- **De Soto Founding Father owned**: doubles positive monetary outcomes,
  removes burial-ground penalty.

### Treasure unit

`UNIT_TREASURE` is special: it has no combat/movement and **must be
loaded onto a ship**, then delivered to Europe. On arrival, the player
receives the **treasure value** in gold, **minus the king's tax cut** (a
percentage based on `tax_rate`):

```c
int treasure_arrive(Unit *t, PowerRecord *p) {
    int gross = t->treasure_value;
    int king_cut = (gross * p->tax_rate) / 100;
    p->treasury += (gross - king_cut);

    /* Cortés FF: 0% king cut */
    if (power_has_ff(p, FF_HERNAN_CORTES)) {
        p->treasury += king_cut;
    }
    unit_destroy(t);
    return gross - king_cut;
}
```

## Weather

```c
enum WeatherEvent {
    WX_CLEAR,         /* normal */
    WX_BAD            /* movement -1 for all land units, -25% production */
};
```

Weather is rolled once per game-month with low probability. When BAD:

- All land units get -1 movement that turn.
- Outdoor production -25% across all colonies.
- Naval movement unaffected.

Native settlements don't experience weather (game-design simplification).

## Disease

When a colony's population is too high relative to its food production
(or randomly each turn for swamp/marsh-adjacent colonies):

```c
void colony_disease_check(Colony *c) {
    int risk = base_disease_risk(c->terrain_type);
    if (c->population > 8) risk += 5;
    if (no_doctor_in_colony(c)) risk += 5;
    if (random_chance(risk)) {
        c->population--;
        /* Show event: "Disease in COLNAME!" */
        notify_player(c, EVENT_DISEASE);
    }
}
```

## Native gifts (non-raid)

A friendly tribe's settlement may **spontaneously gift** the player food,
horses, or guns:

```c
void native_gift_tick(NativeSettlement *s, int player) {
    if (s->attitude[player] < 50) return;
    if (!random_chance(2)) return;       /* 2% chance per turn */

    int gift = pick_gift(s);
    int colony_id = nearest_colony_to(s->map_x, s->map_y, player);
    if (colony_id < 0) return;
    deliver_gift(colonies[colony_id], gift);
}
```

## Pirate ships

Independent pirate Caravels spawn at sea-lane edges and attack any
ship they encounter. Pirates do not affect diplomatic relations.

```c
void pirate_spawn_check(void) {
    if (random_chance(PIRATE_SPAWN_PCT)) {
        int x = (random_chance(50)) ? 0 : 57;
        int y = random_range(20, 50);
        spawn_unit(POWER_PIRATE, UNIT_CARAVEL, x, y);
    }
}
```

The `POWER_PIRATE` slot is a phantom power (not in the diplomacy table).

## Random event UI

Most events trigger a popup notification (using the standard event
dialog renderer). Some events (small monetary LCRs) only update the HUD
silently.

@ref `COLONIZATION_TECHNICAL_REFERENCE.md` §10 (Random Events)

## Event log

Events are appended to a per-game event log (small in-memory ring buffer)
visible in the "Recent Events" panel. The log is NOT saved to disk.

## Cross-references

- LCR placement: [MAP_GENERATION.md](MAP_GENERATION.md)
- Treasure unit: [UNIT_SYSTEM.md](UNIT_SYSTEM.md)
- Tax interaction: [KING_TAX.md](KING_TAX.md)
