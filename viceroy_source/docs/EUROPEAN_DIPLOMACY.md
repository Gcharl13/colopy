> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.
>
> **UPDATE 2026-05-30 — partial byte-verification + specific retractions.**
> The European-power meeting/diplomacy dispatcher (`func_057F4E`) is now
> ported and verified in `src/diplomacy/meeting.c`; treaty/war state in
> `src/diplomacy/treaty.c`. Trust those `.c` files over this doc. Two
> structures described below are **FABRICATED and contradicted by the bytes:**
>
> 1. **The `-100..+100 rel_score[8]` relationship-score model** (the "Relationship
>    score" section, its event-delta table, and the `if (score < -50 - aggression)…`
>    threshold formulas) does **not** exist. There is no signed pair-score array.
>    The real diplomatic state is the **war bit-matrix at DGROUP 0x883C** (one bit
>    per power-pair; set @0x58A7B `80 88 3c 88 02`) — boolean war/not-war, not a
>    scalar score.
> 2. **The `rel_state[8]` Peace/War/Alliance enum** and **`ai_evaluate_treaty()`
>    scoring** are reconstructions, not byte-verified field layouts. "Alliance" as a
>    distinct stored state is unconfirmed.
>
> Everything else here remains RECONSTRUCTED (plausible behavior, unverified
> numbers). The `Treaty` struct, boycott/privateer/alliance prose, and the
> per-power market block are illustrative only.

# European Diplomacy

## Powers

The 4 European powers (England, France, Spain, Dutch — power ids 0..3) plus
the king (slot 4) interact via three relationship modes:

| State        | Code | Effects                                        |
|--------------|------|------------------------------------------------|
| Peace        | 0    | Trade allowed, units cannot attack, free move  |
| War          | 1    | Combat allowed, units block tiles              |
| Alliance     | 2    | Trade + reduced tariffs + shared sight         |

Stored on PowerRecord at `rel_state[8]` (8 slots; only 0..3 used for the
European powers).

## Relationship score — ⚠️ FABRICATED (see banner)

> **Retracted 2026-05-30.** No `rel_score[8]` array exists in VICEROY.EXE.
> Diplomatic state is the boolean war bit-matrix at DGROUP 0x883C (see
> `src/diplomacy/treaty.c`), not a -100..+100 scalar. The table and the
> threshold formulas below are fabricated and kept only as a record.

Each pair has a `rel_score[8]` value -100..+100. Score changes from
events:

| Event                              | Score delta |
|------------------------------------|-------------|
| Trade with the other power         | +1          |
| Successful diplomacy treaty        | +5          |
| Other power loses a colony to you  | -25         |
| You lose a colony to other power   | +5 (?!)     |
| Other power's missionary in your colony | +2     |
| Your missionary in other power's colony | -2     |
| Founding Father (Pocahontas) signed | +20 (one shot to all) |
| Founding Father (de Witt) signed   | +5 (one shot to all)  |

When score crosses thresholds, AI may auto-propose state changes:

```c
if (score < -50 - aggression && state == PEACE)  propose_war();
if (score >  50 + diplomacy && state == PEACE)  propose_alliance();
if (score >   0 + diplomacy && state == WAR)    propose_peace();
```

## Treaty proposals

```c
struct Treaty {
    uint8_t  proposer_id;       /* power proposing */
    uint8_t  recipient_id;      /* power receiving */
    uint8_t  treaty_type;       /* PEACE, WAR_DECL, ALLIANCE, TRADE, GIFT */
    uint8_t  flags;
    int16_t  payment;           /* gold offered (negative if demanded) */
    int16_t  goods_id;          /* commodity id if gift, else -1 */
    int16_t  goods_qty;
};
```

The recipient AI evaluates:

```c
int ai_evaluate_treaty(Treaty *t, PowerRecord *p, AIPersonality *pers) {
    int score = 0;
    score += t->payment / 100;
    score += pers->diplomacy / 10;

    if (t->treaty_type == TREATY_PEACE && p->ai_strategy_state == WAR_DEFENSIVE)
        score += 50;
    if (t->treaty_type == TREATY_ALLIANCE && pers->aggression < 0)
        score += 30;
    if (t->treaty_type == TREATY_WAR_DECL)
        score -= 100;            /* nobody likes being declared on */

    return score >= ACCEPT_THRESHOLD;
}
```

Human player gets a dialog box to accept or reject AI proposals.

## European market (per-power)

Each power has its own European market state. Prices fluctuate based on:

- **Total volume traded** in market (player + AI + king sales)
- **Random ±1 per-turn drift** for high-volume goods
- **Player trade affects only that player's market** (per the game's
  isolated-market model)

```c
void market_tick_for_power(PowerRecord *p) {
    for (int g = 0; g < 16; g++) {
        int volume = p->market_volume[g];
        int trend = market_trend(g, volume);

        p->buy_price[g] += trend;
        p->buy_price[g] = clamp(p->buy_price[g],
                                MARKET_MIN_PRICE[g],
                                MARKET_MAX_PRICE[g]);
        p->sell_price[g] = max(1, p->buy_price[g] - MARKET_SPREAD[g]);

        /* Price decay back toward median when not traded */
        if (volume == 0 && p->buy_price[g] > MARKET_DEFAULT[g]) {
            p->buy_price[g]--;
        }
        p->market_volume[g] = 0;     /* reset trade counter */
    }
}
```

@ref `../include/market.h`

## Trading at European port

When a ship enters Europe (off the right edge of the map onto the
sea-lane border):

```c
void europe_dock_ship(Unit *ship, PowerRecord *p) {
    /* Sell cargo */
    for each cargo slot c:
        if (c.type < 16) {                           /* commodity */
            int sale = c.quantity * p->sell_price[c.type];
            p->treasury += sale;
            p->market_volume[c.type] += c.quantity;
        }
        if (c.type & 0x80) {                          /* unit passenger */
            unit_arrive_in_europe(p, c.type & 0x7F);
        }
        cargo_clear(ship, c);

    /* Player can now buy goods, recruit units, train */
    open_europe_screen(p, ship);
}
```

## Boycotts

If the player exceeds a per-game royal-tax-imposed sale-volume cap on a
commodity, that commodity is boycotted: `boycotted[g] = 1`. While
boycotted, no trade in that commodity can occur (selling forbidden,
buying impossible). The player must:

1. Pay a "fine" to the king (treasury cost) to lift the boycott, OR
2. Use a Custom House (via Stuyvesant) to bypass.

@ref `KING_TAX.md`

## Privateers / undeclared raids

Privateers attack ships **without affecting diplomatic relations** (the
flag isn't shown). The other power doesn't know who attacked unless
the Privateer enters one of their colonies (which reveals nationality).

This makes Privateers the only way to harass a power at peace.

## War mechanics

When at war:

- Cannot trade with that power.
- Cannot enter their colonies (auto-attack at boundary).
- Combat resolves per [COMBAT.md](COMBAT.md).
- Each killed colonist of theirs: -1 score for them, +1 for you.
- Captured colonies: ownership flips, trade markets remain split.

Peace can be declared by either side (with payment) or auto-triggered when
one side lacks any military units AND any active colonies.

## Alliance benefits

- Shared visible map (you see what they see).
- Trade volume bonus (-15% market drift on shared trades).
- Defensive pact: if one ally attacked, other can join (optional).
- Cannot ally during war; must make peace first.

## Royal Diplomacy

The king is **not a diplomatic partner** in the normal sense — relations
with the king are governed by the tax system ([KING_TAX.md](KING_TAX.md)).

## Cross-references

- Market: [../include/market.h](../include/market.h)
- AI diplomacy: [AI_SYSTEM.md](AI_SYSTEM.md)
- Combat: [COMBAT.md](COMBAT.md)
- Founding Fathers (Pocahontas, de Witt): [FOUNDING_FATHERS.md](FOUNDING_FATHERS.md)
