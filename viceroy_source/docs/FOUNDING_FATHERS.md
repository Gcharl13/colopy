> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# Founding Fathers

25 historical figures organized into 5 ages. Each Continental Congress
recruits 1 father, who provides a permanent or one-shot bonus. Recruitment
is gated by **bells production** (a per-power pool; bells come from Town
Halls, Statesmen, etc.).

## Ages and unlock order

A father from age N can be recruited only after the player has at least
ONE father from each prior age. So the ordering is roughly:

```
Exploration (0)  →  Trade (1)  →  Statesmanship (2)  →  Religious (3)  →  Military (4)
```

Within an age, the player picks **one** of 5 candidates each Congress.

## Cost calculation

```c
int ff_cost(int year, int age, int already_owned_in_age) {
    /* Base cost grows with age and total fathers owned */
    int base = FF_BASE_COST_BY_AGE[age];      /* 50, 100, 200, 400, 800 */
    int year_mult = max(1, (year - 1500) / 50);
    return base * year_mult * (already_owned_in_age + 1);
}
```

## The 25 fathers

### Age 0 — Exploration (5)

| ID | Name              | Effect                                      |
|----|-------------------|----------------------------------------------|
| 0  | Henry Hudson      | Furs production +50%                        |
| 1  | Hernán Cortés     | All native gold/silver: gives 2× treasury   |
| 2  | Hernando de Soto  | All units see 1 extra tile of map           |
| 3  | Sieur de La Salle | Stockades free in any colony pop ≥ 3        |
| 4  | Ferdinand Magellan| Ships +1 movement                           |

### Age 1 — Trade (5)

| ID | Name              | Effect                                      |
|----|-------------------|----------------------------------------------|
| 5  | Adam Smith        | Factories enabled (Cigar/Rum/Textile/Iron) |
| 6  | Jakob Fugger      | Boycotts removed, no more boycott penalty  |
| 7  | Peter Minuit      | Native land never taken (no -attitude on plow) |
| 8  | Peter Stuyvesant  | Custom House enabled                       |
| 9  | Jan de Witt       | All other powers' prices visible           |

### Age 2 — Statesmanship (5)

| ID | Name              | Effect                                      |
|----|-------------------|----------------------------------------------|
| 10 | Benjamin Franklin | All powers offer peace at any time         |
| 11 | Thomas Jefferson  | Bells production +50%                      |
| 12 | Pocahontas        | Native attitude +25 across all tribes      |
| 13 | Thomas Paine      | SoL bonus: bells per Tory/Liberty colonist scaled |
| 14 | Simón Bolívar     | All colonies +20 SoL                       |

### Age 3 — Religious (5)

| ID | Name              | Effect                                      |
|----|-------------------|----------------------------------------------|
| 15 | William Brewster  | Recruit from Europe at half cost           |
| 16 | William Penn      | Crosses production +50%                    |
| 17 | Father Jean de Brébeuf | Mission converts at 2× rate          |
| 18 | Juan de Sepúlveda | Native settlement attacks: 2× treasure     |
| 19 | Bartolomé de Las Casas | All Indian Converts → Free Colonists |

### Age 4 — Military (5)

| ID | Name              | Effect                                      |
|----|-------------------|----------------------------------------------|
| 20 | Francisco de Coronado | All map revealed                       |
| 21 | Hernán Cortés (split) | (alt slot — see name table)            |
| 22 | George Washington | All Veteran units +1 attack/defense        |
| 23 | Paul Revere       | All colonists in colony defend with muskets|
| 24 | Francis Drake     | Privateers attack 2×                       |

NB: The exact ordering and slot ID for the late "military"/"naval"
fathers (Lafayette, John Paul Jones) varies by source — these specific
names are **referenced by NAMES.TXT @FATHER**, not hard-coded by ID.

## Effect implementation

Each father's effect is dispatched on recruitment:

```c
void ff_apply(PowerRecord *p, int ff_id) {
    p->ff_owned_lo |= (1u << ff_id);

    switch (ff_id) {
    case FF_HENRY_HUDSON:
        /* Cached at colony tick: production[FUR] *= 1.5 */
        break;

    case FF_ADAM_SMITH:
        /* Allows construction of factory tier-3 buildings */
        p->factories_enabled = 1;
        break;

    case FF_PETER_STUYVESANT:
        p->custom_house_enabled = 1;
        break;

    case FF_THOMAS_JEFFERSON:
        /* Cached at colony tick: bells *= 1.5 */
        break;

    case FF_GEORGE_WASHINGTON:
        /* Each Veteran unit gets +1 atk/def at combat resolution */
        break;

    /* ... etc */
    }
}
```

Most effects are **flag-based** (set a bit, the relevant subsystem
queries the bit each turn). One-shot effects like Coronado's "reveal map"
execute immediately.

@ref `../include/ff.h`, NAMES.TXT @FATHER

## Father selection in Continental Congress

When the bell pool fills:

1. The game pauses, plays the Congress sound.
2. The player gets a dialog with the **5 candidates** for the current age.
3. Each candidate shows: portrait (ICONS.SS sprite_index), name, age,
   effect description (from MENU.TXT @FATHER_DESC).
4. Player picks one; `ff_apply()` runs; bell pool resets.
5. AI powers are simultaneously progressing through their FF queues
   (using their `ai_personality.ff_weight` array).

## Cross-references

- FF struct: [DATA_MODEL.md §7](DATA_MODEL.md#7-founding-father-record-constant--12-bytes-per-ff)
- AI weights: [AI_SYSTEM.md](AI_SYSTEM.md)
- Bells production: [COLONY_SYSTEM.md](COLONY_SYSTEM.md)
- Header: [../include/ff.h](../include/ff.h)
