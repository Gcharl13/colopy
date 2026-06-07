> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# Combat Resolution

## Overview

Combat is a deterministic single-round resolution: when an attacker
attempts to move into a tile occupied by an enemy unit, the combat
resolver compares **modified attack** vs. **modified defense** and rolls
once.

VICEROY.EXE does NOT use multi-round HP combat (unlike Civilization). It's
binary: attacker wins or defender wins; loser is destroyed (or for
artillery / ships, downgraded).

## Top-level resolver

```c
int combat_resolve(Unit *attacker, Unit *defender) {
    int atk = compute_attack_strength(attacker);
    int def = compute_defense_strength(defender);

    /* Roll: 0..(atk + def - 1).
     * roll < atk → attacker wins; else defender wins. */
    int total = atk + def;
    int roll = random_range(0, total - 1);

    if (roll < atk) {
        return COMBAT_ATTACKER_WINS;
    } else {
        return COMBAT_DEFENDER_WINS;
    }
}
```

@ref `COLONIZATION_TECHNICAL_REFERENCE.md` §7 (Combat)

## Attack strength

```c
int compute_attack_strength(Unit *u) {
    int base = UNIT_TYPE_TABLE[u->unit_type].attack;

    /* Veteran/Continental bonus baked into base */

    /* SoL bonus for units in colony at 100% SoL */
    if (in_colony_at_100_sol(u)) {
        base = base + (base / 2);          /* +50% rebellion bonus */
    }

    /* Founding Father bonuses */
    if (power_has_ff(u->owner, FF_GEORGE_WASHINGTON)) {
        base += 1;                         /* Washington bonus */
    }

    return base;
}
```

## Defense strength

```c
int compute_defense_strength(Unit *u) {
    int base = UNIT_TYPE_TABLE[u->unit_type].defense;

    /* Fortified bonus */
    if (u->flags & UNIT_FLAG_FORTIFIED) {
        base = base + (base / 2);          /* +50% */
    }

    /* Terrain bonus (only for land units defending in non-colony) */
    if (!is_naval(u) && !on_colony_tile(u)) {
        int terrain_bonus = tile_defense_bonus(u->map_x, u->map_y);
        base += (base * terrain_bonus) / 100;
    }

    /* Colony fortification bonus (Stockade/Fort/Fortress) */
    Colony *c = colony_at(u->map_x, u->map_y);
    if (c) {
        int fort_bonus = COLONY_DEFENSE_BONUS[colony_fort_level(c)];
        base += fort_bonus;
    }

    /* SoL +50% in colony at 100% */
    if (in_colony_at_100_sol(u)) {
        base = base + (base / 2);
    }

    return base;
}
```

### COLONY_DEFENSE_BONUS table

| Building          | Defense added |
|-------------------|---------------|
| (none)            | 0             |
| Stockade          | 50%           |
| Fort              | 100%          |
| Fortress          | 150%          |

## Attacker / defender selection

Within a stack on a single tile, the **strongest defender** is chosen to
fight. Ties broken by:

1. Higher base defense.
2. Fortified status.
3. Order in the table.

After resolution, **only the loser of that one fight is destroyed**, not
the entire stack. Subsequent attackers must re-attack against the next
strongest.

## Promotion (winning)

```c
void combat_apply_winner(Unit *winner, Unit *loser) {
    /* Soldier → Veteran Soldier on win */
    if (winner->unit_type == UNIT_SOLDIER) {
        winner->unit_type = UNIT_VETERAN_SOLDIER;
    }
    /* Dragoon → Veteran Dragoon */
    if (winner->unit_type == UNIT_DRAGOON) {
        winner->unit_type = UNIT_VETERAN_DRAGOON;
    }

    /* Continental promotion only after declaring independence */
    if (rebellion_started(winner->owner)) {
        if (winner->unit_type == UNIT_VETERAN_SOLDIER) {
            winner->unit_type = UNIT_CONTINENTAL_ARMY;
        }
        if (winner->unit_type == UNIT_VETERAN_DRAGOON) {
            winner->unit_type = UNIT_CONTINENTAL_CAVALRY;
        }
    }

    /* Capture cargo? — naval combat may capture cargo + commodities */
    if (is_naval(winner) && is_naval(loser)) {
        capture_cargo_proportional(winner, loser);
    }
}
```

## Demotion (losing)

```c
void combat_apply_loser(Unit *winner, Unit *loser) {
    /* Soldier loses muskets → Free Colonist */
    if (loser->unit_type == UNIT_SOLDIER) {
        loser->unit_type = UNIT_FREE_COLONIST;
        return;                              /* survives, weaponless */
    }

    /* Veteran/Continental on losing side: become regular soldier */
    if (loser->unit_type == UNIT_VETERAN_SOLDIER ||
        loser->unit_type == UNIT_CONTINENTAL_ARMY) {
        loser->unit_type = UNIT_SOLDIER;
        return;
    }

    /* Dragoons lose horses → Soldier (with muskets still) */
    if (loser->unit_type == UNIT_DRAGOON) {
        loser->unit_type = UNIT_SOLDIER;
        return;
    }

    /* Artillery damaged → Damaged Artillery */
    if (loser->unit_type == UNIT_ARTILLERY) {
        loser->unit_type = UNIT_DAMAGED_ARTILLERY;
        return;
    }

    /* Damaged Artillery destroyed */
    if (loser->unit_type == UNIT_DAMAGED_ARTILLERY) {
        unit_destroy(loser);
        return;
    }

    /* Default: unit destroyed */
    unit_destroy(loser);
}
```

## Naval combat

Ship-vs-ship combat uses the same atk/def formula, but on **defender win**
the attacker is **damaged → repair-needed** rather than destroyed:

- Caravel/Merchantman/Galleon damaged → must return to Europe for repair
- Frigate/Man-O-War damaged → can be repaired in any colony with Drydock+

A damaged ship's cargo is forfeited (sunk).

## Privateer rules

Privateers can attack **any** ship without declaring war. The flagship's
identity isn't revealed unless the Privateer enters a colony. This makes
them the only "harassment without diplomatic cost" tool.

## Bombardment from colonies

A colony with **Fort or Fortress** can **bombard** any naval unit in an
adjacent water tile **once per turn**. Damage is the colony's fort tier
(2 / 4 strength).

## Native combat

Native warriors (Brave / Mounted Brave) follow the same formula but lack
veterancy paths. A killed brave **never returns**; the settlement
recomputes warrior count from `population - civilians`.

When a player kills a brave that came from a settlement, that settlement's
attitude toward that power drops by 25.

## REF combat (during Revolution)

The Royal Expeditionary Force (see [REVOLUTION.md](REVOLUTION.md)) gets a
**+50% effective combat strength** against rebel forces, but this is
canceled out 1-for-1 by:

- Each colony at 100% SoL: -2% REF effective strength
- Each Continental Army/Cavalry unit: -1% REF effective strength
- Possession of certain Founding Fathers (Washington, Lafayette, Jones)

The "REF strength meter" is computed and cached on PowerRecord.

@ref `REVOLUTION.md`, `KING_TAX.md`
