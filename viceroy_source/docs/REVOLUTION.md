> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# Revolution / War of Independence

## Preconditions

The player can declare independence when:

1. Total SoL across all colonies ≥ 50% (weighted by population), AND
2. At least 1 colony has 100% SoL, AND
3. Year ≥ 1700 (declaration valid window).

The "Declare Independence" button on the main HUD is gated by these.

## Declaration

```c
void declare_independence(PowerRecord *p) {
    if (!can_declare_independence(p)) return;

    p->flags |= POWER_FLAG_IN_REVOLUTION;
    PowerRecord *king = &powers[KING_POWER_ID];
    king->king_anger = 100;

    /* All Veteran units → Continental */
    for each unit u in p:
        if (u.unit_type == UNIT_VETERAN_SOLDIER)
            u.unit_type = UNIT_CONTINENTAL_ARMY;
        if (u.unit_type == UNIT_VETERAN_DRAGOON)
            u.unit_type = UNIT_CONTINENTAL_CAVALRY;

    /* Lock European trade — no more selling/buying via standard market */
    for each commodity g:
        p->boycotted[g] = 1;

    /* Schedule the REF deployment for next 1-3 turns */
    schedule_ref_deployment(king, p);

    /* All other European powers' relations: -50 score (king's allies) */
    for each other power op:
        p->rel_score[op->power_id] -= 50;

    /* SoL ratchet: all colonies at >= 50 SoL boost to 100 */
    for each colony c owned by p:
        if (c.sol_pct >= 50) c.sol_pct = 100;
}
```

## REF Deployment

The king's REF lands as a fleet of Man-O-Wars carrying Regulars,
Dragoons, and Artillery. The deployment target is the **eastern coast**
of the player's territory.

```c
void deploy_ref(PowerRecord *king, PowerRecord *target) {
    Coord landing = pick_landing_site(target);   /* coastal player tile */

    /* Spawn Man-O-Wars + REF units */
    for (int i = 0; i < king->ref_manowar; i++)
        spawn_unit(king, UNIT_MAN_O_WAR, landing.x + 1, landing.y);

    for (int i = 0; i < king->ref_regulars; i++)
        spawn_unit(king, UNIT_REGULAR, landing.x, landing.y);

    for (int i = 0; i < king->ref_dragoons; i++)
        spawn_unit(king, UNIT_REF_DRAGOON, landing.x, landing.y);

    for (int i = 0; i < king->ref_artillery; i++)
        spawn_unit(king, UNIT_ARTILLERY, landing.x, landing.y);
}
```

## REF strength formula

The "REF effective strength" is what you see in the HUD. It's computed:

```c
int ref_effective_strength(PowerRecord *king, PowerRecord *target) {
    int base = (king->ref_regulars * 2) +
               (king->ref_dragoons * 3) +
               (king->ref_artillery * 4) +
               (king->ref_manowar * 6);

    int penalty = 0;
    for each colony c owned by target:
        if (c.sol_pct == 100) penalty += 2;
    for each unit u owned by target:
        if (u.unit_type == UNIT_CONTINENTAL_ARMY)    penalty += 1;
        if (u.unit_type == UNIT_CONTINENTAL_CAVALRY) penalty += 2;
    if (power_has_ff(target, FF_GEORGE_WASHINGTON)) penalty += 10;
    if (power_has_ff(target, FF_LAFAYETTE))         penalty += 10;
    if (power_has_ff(target, FF_JOHN_PAUL_JONES))   penalty += 10;
    if (power_has_ff(target, FF_FRANCIS_DRAKE))     penalty += 5;

    return max(0, base - penalty);
}
```

When `ref_effective_strength == 0`, the player has effectively neutralized
the REF.

## Winning the Revolution

The player wins independence when:

- All Royal forces in the New World are destroyed (no surviving REF), OR
- The player captures the king's last European base — irrelevant in
  practice; the game ends on REF defeat.

```c
int check_revolution_win(PowerRecord *p) {
    if (!(p->flags & POWER_FLAG_IN_REVOLUTION)) return 0;
    PowerRecord *king = &powers[KING_POWER_ID];
    int king_units = count_active_units(KING_POWER_ID);
    if (king_units == 0) {
        p->flags |= POWER_FLAG_REVOLUTION_WON;
        return 1;
    }
    return 0;
}
```

## Losing the Revolution

The player loses if:

- All player colonies captured / razed by REF, OR
- Player's last unit destroyed.

In both cases, the king "wins" — game ends with `show_endgame_screen(KING_WON)`.

## Continental Congress (post-declaration)

The Continental Congress unlocks specific Founding Fathers ONLY available
after declaration:

- George Washington (military bonus)
- Thomas Jefferson (bell production bonus)
- Benjamin Franklin (free European trade reopens)
- John Paul Jones (naval bonus)
- Lafayette (foreign volunteers)

@ref `FOUNDING_FATHERS.md`

## Foreign volunteers

If the player recruits Lafayette during the Revolution, French regular
units begin to **defect to the player** at a low rate (each turn, small
chance per French regular in the New World becomes a Continental Army).

## Naval blockades

The REF Man-O-Wars enforce a **trade blockade** — the player's ships
can't reach the European border-edge sea lanes while the REF is active.
Custom House remains the only outlet.

## Game-over screen

On revolution-won OR king-won, the game runs `show_endgame_screen()`
which:

1. Computes final score (see [SCORING.md](SCORING.md))
2. Plays an ending animation
3. Records into HALLFAME.DAT
4. Chains to CLOSING.EXE for the credits + final stats

@ref `SCORING.md`, `../../docs/RTLINK_OVERLAYS.md`

## Cross-references

- King's REF accumulation: [KING_TAX.md](KING_TAX.md)
- Combat (with REF bonuses): [COMBAT.md](COMBAT.md)
- Founding Fathers: [FOUNDING_FATHERS.md](FOUNDING_FATHERS.md)
