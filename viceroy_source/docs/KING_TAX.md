> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# King's Tax & Demands

The king (power slot 4) extracts wealth from the player throughout the
colonial period and accumulates the **Royal Expeditionary Force** (REF)
that will deploy when the player declares independence.

## Tax rate

Each power has a `tax_rate` field on PowerRecord (0..75 — capped). The
king's tax applies to all sales in the European market:

```c
int market_sell_with_tax(PowerRecord *p, int commodity, int qty) {
    int gross = qty * p->sell_price[commodity];
    int tax = (gross * p->tax_rate) / 100;
    p->treasury += (gross - tax);
    /* tax accumulates implicitly to king side */
    return gross - tax;
}
```

## Tax demand events

Periodically (every 6-15 turns, weighted by population, randomized), the
king will demand a tax increase:

```c
struct KingDemand {
    uint8_t  demand_type;       /* 0=tax_raise, 1=commodity_tax,
                                   2=tribute_gold, 3=force_disband */
    uint8_t  parameter;         /* tax delta or commodity id */
    int16_t  value;             /* gold amount or qty */
    int16_t  consequence_id;    /* boycott commodity id, or -1 */
};
```

The player gets a dialog with two choices:

- **Accept**: tax_rate += demand.parameter (or pay the tribute).
- **Refuse**: triggers the **consequence**:
  - Boycott on a randomly chosen commodity.
  - +5 to king's anger meter.

### Tax escalation table

```c
const KingDemand demand_table[] = {
    /* turn_min, turn_max, type, param, consequence */
    {  10,  30, KD_TAX,  3,  BOYCOTT_RUM        },
    {  20,  50, KD_TAX,  5,  BOYCOTT_TOBACCO    },
    {  40,  80, KD_TAX,  7,  BOYCOTT_CIGARS     },
    {  60, 100, KD_TAX, 10,  BOYCOTT_SUGAR      },
    {  80, 130, KD_TAX, 12,  BOYCOTT_COTTON     },
    { 100, 160, KD_TAX, 15,  BOYCOTT_COATS      },
    { 130, 200, KD_TAX, 20,  BOYCOTT_CLOTH      },
};
```

When `tax_rate` hits 75, **Tea Party** is the only relief — see below.

## Tea Party

If the player **refuses** a tax demand AND has the necessary cargo in a
coastal colony, the player can stage a **Tea Party**:

```c
void colony_tea_party(Colony *c) {
    /* Must have the boycotted commodity in stock */
    int g = current_boycott_commodity();
    if (c->stock[g] <= 0) return;

    /* Dump the entire stockpile into the harbor */
    c->stock[g] = 0;

    /* Effects: */
    add_sol_pct(c, +25);                /* SoL spike across colony */
    set_boycott(g, true);                /* permanent boycott on this good */
    king_anger += 10;                   /* king fumes */
    bell_pool += 25;                    /* bonus toward next FF */
}
```

Tea Party is a **one-time per commodity** event but you can trigger it
multiple times (different commodities). It's the primary "early-game
revolutionary speedup" tool.

## REF buildup

Each turn the king is in your game, his REF grows:

```c
void king_tick(PowerRecord *king, PowerRecord *colony_power) {
    int turn = current_turn();

    /* Linear growth scaled by colony_power's economy */
    if (turn % 10 == 0) {
        int growth = 1 + (colony_power->treasury / 5000);
        king->ref_regulars += growth;
    }
    if (turn % 15 == 0) king->ref_dragoons += 1;
    if (turn % 20 == 0) king->ref_artillery += 1;
    if (turn % 25 == 0) king->ref_manowar += 1;

    /* King's anger drives rate */
    int anger_bonus = (king->king_anger / 25);
    king->ref_regulars += anger_bonus;
}
```

## King's anger meter

`king_anger` 0..100, increases when:

- Player refuses a tax demand: +5
- Player stages Tea Party: +10
- Player kills any king's unit (REF or pre-deployed): +1 each
- Player declares independence: +50 (one-time)
- Player passes Continental Congress events: +1 per FF recruited

When `king_anger >= 50`, the king issues tax demands more frequently.
When `king_anger >= 75`, the king's REF growth is doubled.

## Pre-revolution king actions

Before independence, the king can:

- Demand taxes (above)
- Refuse a peace treaty between you and another European power
- Order specific units disbanded ("disband 5 dragoons or pay 500 gold")

After independence, the king deploys the REF (see [REVOLUTION.md](REVOLUTION.md)).

## How tax bypasses work

| Method                       | Effect                                    |
|------------------------------|--------------------------------------------|
| Custom House (Stuyvesant FF) | Auto-sells excess at 0% tax via colony   |
| Sell to other Europeans      | No king tax (per-power markets)          |
| Trade with natives           | Native trade isn't taxed                  |
| Hoard                        | Don't sell, no tax — but warehouse caps   |

## Cross-references

- REF deployment: [REVOLUTION.md](REVOLUTION.md)
- Custom House (Stuyvesant): [FOUNDING_FATHERS.md](FOUNDING_FATHERS.md)
- Power record: [DATA_MODEL.md §1](DATA_MODEL.md#1-power-record-per-nation-state--316-bytes-0x13c)
