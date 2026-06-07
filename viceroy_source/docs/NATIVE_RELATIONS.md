> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# Native Relations

## Tribes (8)

The 8 tribes are partitioned into **2 advanced** + **6 semi-nomadic**:

| ID | Tribe       | Type     | Capital can teach    | Wealth |
|----|-------------|----------|----------------------|--------|
| 0  | Aztec       | Advanced | Cigars/Cotton        | High   |
| 1  | Inca        | Advanced | Cotton/Silver        | High   |
| 2  | Arawak      | Nomadic  | Sugar/Tobacco        | Med    |
| 3  | Tupi        | Nomadic  | Sugar/Furs           | Low    |
| 4  | Apache      | Nomadic  | Furs/Horses          | Med    |
| 5  | Sioux       | Nomadic  | Furs/Horses          | Med    |
| 6  | Iroquois    | Nomadic  | Lumber/Furs          | Med    |
| 7  | Cherokee    | Nomadic  | Tobacco/Lumber       | Med    |

Aztec/Inca have **City** and **Capital** settlement types only; the others
have **Camp** and **Village** with rare **Capital** for the home tribe.

## Settlement types (4)

| Type | Name    | Capacity | Defenders | Notes                     |
|------|---------|----------|-----------|---------------------------|
| 0    | Camp    | 1-3      | 1-2       | Smallest, often abandoned |
| 1    | Village | 4-6      | 2-4       |                           |
| 2    | City    | 7-10     | 4-6       | Aztec/Inca only           |
| 3    | Capital | 8-12     | 6-8       | Tribe HQ, gives skill     |

@ref `../include/native.h`, NAMES.TXT @TRIBE / @SETTLEMENT

## Player interactions

### Speak with chief

When a unit enters a native settlement that hasn't been visited:

- **First visit**: chief reveals tribe + settlement type, gives directions
  to a learned skill, may give small gift (food/horses).
- **Tribute / gift demand**: settlement may demand a small commodity
  payment in exchange for friendship.
- **Skill learning**: a Free Colonist can be promoted by **living among**
  the tribe for several turns. The skill learned is one of the
  `skills_known[8]` array on the settlement.

### Trade

Settlements buy player commodities (especially the goods they can't make
themselves: e.g., Aztec/Inca don't make muskets/horses):

```c
int settlement_buy_price(NativeSettlement *s, int commodity, int qty) {
    int demand = s->goods_offered[commodity];
    if (demand <= 0) return 0;             /* don't want it */

    int base = NATIVE_BASE_PRICE[commodity];
    int bonus = (s->attitude[player] / 25);    /* +1 per 25 attitude */
    return (base + bonus) * qty;
}
```

### Mission

A `UNIT_JESUIT_MISSIONARY` can establish a mission at a settlement
(if attitude > 0). Each turn the mission is active:

- Small chance of producing an `UNIT_INDIAN_CONVERT` (gradient based on
  settlement size, mission type Jesuit/regular, and bishop FF).
- +1 attitude per turn from settlement to mission's owner.
- Player gets reduced raid frequency from this settlement.

### Demand tribute

A military unit can demand tribute, which costs **-25 attitude** but
yields gold/horses if successful (depends on the settlement's wealth and
the unit's strength).

## Native AI / behavior

Settlements aren't driven by the European AI loop. They have their own
per-turn tick:

```c
void native_tick(NativeSettlement *s) {
    /* 1. Population growth */
    if (random_chance(NATIVE_GROWTH_PCT)) s->population++;

    /* 2. Random raid trigger */
    for each adjacent power:
        int aggression = compute_native_aggression(s, power);
        if (random_chance(aggression)) {
            spawn_raiding_brave(s, power);
        }

    /* 3. Mission production */
    if (s->flags & NATIVE_FLAG_MISSION_ACTIVE) {
        if (random_chance(MISSION_CONVERT_PCT)) {
            spawn_indian_convert(s);
        }
    }

    /* 4. Capital teach skill */
    if (s->type == NATIVE_TYPE_CAPITAL && random_chance(15)) {
        teach_random_skill(s);
    }
}
```

### Raiding

Native braves spawn from settlements with declining attitude. They:

- Move toward the nearest enemy colony.
- Attack any military unit in the way (combat per [COMBAT.md](COMBAT.md)).
- If they reach the colony with no defenders, **burn it** (pillage:
  treasury -= small amount, stockpile destroyed, population -= 1).

### Settlement destruction

A player can attack a settlement directly:

- Combat resolves vs. the strongest defender (a brave).
- On settlement defeated AND population <= 0, the settlement is **razed**.
- Treasure proceeds: payable to the player (modulated by tribe wealth).
- All other settlements of the same tribe shift **-50 attitude** toward
  the destroyer.

## Attitude scale

Per-power attitude on each settlement is `-100..100`:

| Range     | Status        | Effects                                 |
|-----------|---------------|------------------------------------------|
| -100..-50 | Hostile       | Raids common, no trade, no entry         |
| -49..-25  | Angry         | Raids occasional                         |
| -24..0    | Wary          | Trade penalty                            |
| 1..25     | Neutral       | Standard trade                           |
| 26..50    | Friendly      | Trade bonus                              |
| 51..100   | Allied        | Bonus gifts, no raids                    |

Attitude changes from:

- Speak with chief (+5)
- Establish mission (+15 over time)
- Trade (+1 per profitable trade)
- Demand tribute (-25)
- Attack braves (-25 per kill)
- Destroy settlement (-50 across tribe)
- Found colony on tribal land (-15)
- Plow/road on tribal claims (-5)

## Cross-references

- Combat: [COMBAT.md](COMBAT.md)
- Settlement struct: [DATA_MODEL.md §4](DATA_MODEL.md#4-native-settlement-record--200-bytes-0xc8)
- Headers: [../include/native.h](../include/native.h)
