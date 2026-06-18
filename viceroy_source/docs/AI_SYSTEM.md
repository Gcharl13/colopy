> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# AI System

## Overview

The AI in VICEROY.EXE drives the **other 3 European powers** (those not
played by the human). It also drives all native settlements and the king.

There is **one AI driver function** invoked once per AI power per turn.
Each AI's behavior is parameterized by an **AIPersonality** record that
biases its decisions across nine axes (aggression, expansion, militarism,
religion, trade, pioneering, rebellion, diplomacy, exploration).

## AI driver entry point

```c
void ai_dispatch_per_power(int power_id) {
    PowerRecord *p = &powers[power_id];
    if (p->controller != CONTROLLER_AI) return;
    if (p->flags & POWER_FLAG_DEFEATED) return;

    AIPersonality *pers = &ai_personality[p->ai_personality_id];

    /* 1. Update strategic state */
    ai_update_strategy(p, pers);

    /* 2. Move every unit */
    for (int u = 0; u < 256; u++) {
        if (units[u].owner == power_id) {
            ai_move_unit(&units[u], p, pers);
        }
    }

    /* 3. Manage every colony */
    for (int c = 0; c < 64; c++) {
        if (colonies[c].owner == power_id) {
            ai_manage_colony(&colonies[c], p, pers);
        }
    }

    /* 4. Diplomatic decisions */
    ai_consider_diplomacy(p, pers);

    /* 5. Trade decisions */
    ai_consider_trade(p, pers);

    /* 6. Mark turn done */
    p->flags |= POWER_FLAG_AI_DONE_TURN;
}
```


## AI personality templates

Eight pre-canned templates (`AIPersonality` records 0..7), one per power
plus 4 alternates the random seeder may pick. Templates (RECONSTRUCTED — not byte-verified; AI weights are overlay-resident, undecoded):

| ID  | Name             | Aggression | Expansion | Militarism | Trade | Diplomacy |
|-----|------------------|------------|-----------|------------|-------|-----------|
| 0   | Builder          | -50        | +75       | -25        | +50   | +25       |
| 1   | Conqueror        | +75        | +25       | +75        | -25   | -50       |
| 2   | Trader           | -25        | +25       | -50        | +75   | +50       |
| 3   | Pioneer          | 0          | +50       | 0          | +25   | 0         |
| 4   | Religionist      | +25        | +50       | +25        | 0     | +25       |
| 5   | Aggressor        | +50        | +25       | +50        | 0     | -25       |
| 6   | Pacifist         | -75        | +25       | -75        | +50   | +75       |
| 7   | Rebel            | +25        | +50       | +50        | +25   | +25       |

## Strategic state

Each AI cycles between strategic priorities based on its template + game
state. The state machine in `ai_strategy_state`:

| State              | When to enter                                |
|--------------------|----------------------------------------------|
| EXPLORE            | Early game, < 3 colonies                     |
| EXPAND             | < 6 colonies, peaceful                       |
| CONSOLIDATE        | 6+ colonies, building infrastructure         |
| WAR_PREP           | At war declaration                           |
| WAR_OFFENSIVE      | At war, militarism > 0                       |
| WAR_DEFENSIVE      | At war, militarism < 0 OR losing             |
| TRADE_FOCUS        | Treasury < 1000 + trader/pacifist            |
| INDEPENDENCE_PREP  | SoL > 50% across colonies + rebellion > 0    |

Transitions are evaluated each turn before movement.

## Unit movement priorities

```c
void ai_move_unit(Unit *u, PowerRecord *p, AIPersonality *pers) {
    int unit_role = ai_classify_unit(u);

    switch (unit_role) {
    case ROLE_SETTLER:           /* Free Colonists with no orders */
        ai_move_to_best_colony_site(u, p, pers);
        break;

    case ROLE_PIONEER:
        ai_assign_pioneer_work(u, p);
        break;

    case ROLE_SOLDIER:
        if (p->ai_strategy_state == WAR_OFFENSIVE)
            ai_attack_target(u, p, pers);
        else
            ai_garrison_or_fortify(u, p);
        break;

    case ROLE_TRANSPORT_SHIP:
        ai_run_trade_route(u, p);
        break;

    case ROLE_WARSHIP:
        if (p->ai_war_target >= 0)
            ai_naval_blockade(u, p, p->ai_war_target);
        else
            ai_patrol_coast(u, p);
        break;

    case ROLE_MISSIONARY:
        ai_pick_mission_target(u, p);
        break;

    case ROLE_SCOUT:
        ai_explore_unknown(u, p);
        break;
    }
}
```

## Colony management

```c
void ai_manage_colony(Colony *c, PowerRecord *p, AIPersonality *pers) {
    /* 1. Re-assign workers based on shortage */
    for each commodity:
        if production[c] < demand[c]:
            reassign_worker_to(c, commodity);

    /* 2. Build queue */
    int next_build = ai_pick_next_building(c, p, pers);
    c->in_construction = next_build;

    /* 3. Recruit/train colonists */
    if (c->population < 8 and treasury > recruit_cost):
        recruit_colonist(p);

    /* 4. Garrison check */
    if (ai_threat_level_at(c->map_x, c->map_y) > c->defense_strength) {
        order_nearest_soldier_to(c);
    }
}
```

## Building priority

```c
int ai_pick_next_building(Colony *c, PowerRecord *p, AIPersonality *pers) {
    int score[40] = {0};

    for each building b:
        if has_prereq(c, b):
            score[b] = base_value(b);
            score[b] += pers->militarism * mil_weight(b) / 100;
            score[b] += pers->trade      * trade_weight(b) / 100;
            score[b] += pers->expansion  * expansion_weight(b) / 100;
            /* etc */
            score[b] -= cost(b) * 2;     /* prefer cheaper */

    return argmax(score);
}
```

## Founding Father selection

Each AI prefers FFs by `pers->ff_weight[25]`. When the bell pool fills and
the AI must pick a father, it picks the highest-weight available father in
the **current Continental Congress age**.

@ref `FOUNDING_FATHERS.md`

## Diplomacy

```c
void ai_consider_diplomacy(PowerRecord *p, AIPersonality *pers) {
    for each other power op:
        int rel = p->rel_state[op->power_id];
        int score = p->rel_score[op->power_id];

        if (rel == REL_PEACE && score < -50 - pers->aggression) {
            propose_war(p, op);
        }
        if (rel == REL_WAR && score > -10 + pers->diplomacy) {
            propose_peace(p, op);
        }
        if (rel == REL_PEACE && score > 50 + pers->diplomacy &&
            pers->aggression < 0) {
            propose_alliance(p, op);
        }
}
```

## Trade

```c
void ai_consider_trade(PowerRecord *p, AIPersonality *pers) {
    if (treasury too low) return;

    for each commodity g:
        int net = sum of production[g] across colonies;
        if (net > 100 and trade_priority(p, g, pers) > threshold) {
            ai_send_trade_ship(p, g);
        }
}
```

## Random events from AI perspective

AIs don't know about rumored events the player triggers (Lost City Rumor
treasures, etc.) but can experience their own (e.g., when the AI's
treasury suddenly increases the player gets a notification iff at peace).

## Native AI

Native settlements are NOT driven by the European AI cycle; they're
independent state machines. See [NATIVE_RELATIONS.md](NATIVE_RELATIONS.md).

## King AI

The King is a "phantom" power (slot 4) that:

- Issues tax demands (see [KING_TAX.md](KING_TAX.md))
- Accumulates the REF
- Deploys the REF on independence

The King AI never moves units before independence is declared.

## AI debug / testing

A debug build of VICEROY.EXE (not shipped) had an `AI_TRACE` flag that
logged every decision to `AI.LOG`. Not present in the retail build.

