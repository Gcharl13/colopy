> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# Scoring & Endgame

## Final score components

The end-of-game score is computed from:

```c
int compute_final_score(PowerRecord *p) {
    int score = 0;

    /* 1. Population — main driver */
    int pop = total_colonists_owned(p);
    score += pop * SCORE_PER_COLONIST;          /* 5 */

    /* 2. Treasury at end */
    score += p->treasury / 100;                 /* 1 per 100 gold */

    /* 3. Founding Fathers */
    int n_ff = popcount(p->ff_owned_lo);
    score += n_ff * SCORE_PER_FF;               /* 50 */

    /* 4. Bells produced lifetime */
    score += p->bells_total / 50;

    /* 5. Score multiplier from difficulty */
    int diff_mult = DIFFICULTY_SCORE_MULT[p->difficulty];
    /* Discoverer 0.5×, Explorer 1.0×, Conquistador 1.5×,
       Governor 2.0×, Viceroy 2.5× */
    score = (score * diff_mult) / 100;

    /* 6. Bonus for revolution win */
    if (p->flags & POWER_FLAG_REVOLUTION_WON) {
        score += REVOLUTION_BONUS;              /* 1000 */
        /* Bonus scales by speed: faster = more */
        int turn_bonus = max(0, (1820 - current_year()) * 10);
        score += turn_bonus;
    }

    return score;
}
```


## Difficulty multipliers

| Difficulty   | Multiplier | Notes                                       |
|--------------|------------|----------------------------------------------|
| Discoverer   | 0.5×       | Easiest                                     |
| Explorer     | 1.0×       |                                             |
| Conquistador | 1.5×       |                                             |
| Governor     | 2.0×       |                                             |
| Viceroy      | 2.5×       | Hardest — REF doubles, AI more aggressive  |

## Score table breakdown

The endgame screen shows a per-component breakdown:

```
                        FINAL SCORE
=======================================
Population (1230 col × 5)        6150
Treasury  (8475 / 100)             84
Founding Fathers (12 × 50)        600
Bells (32891 / 50)                657
                            --------
Subtotal                        7491
Difficulty (Conquistador 1.5×) ×1.5
                            --------
                              11237
Revolution Bonus               +1000
Year Bonus (1742, 78×10)        +780
                            --------
FINAL SCORE                    13017
```

## Hall of Fame

The top 10 scores are persisted to `HALLFAME.DAT`:

```c
struct HallFameEntry {
    char     player_name[20];   /* From last new-game prompt */
    char     nation[16];        /* "England", "Spain", etc. */
    int32_t  score;
    int16_t  year_won;
    uint8_t  difficulty;
    uint8_t  reserved;
    uint32_t timestamp;
};                              /* 50 bytes per entry */
```

@ref `../formats/DAT.md`

## End-of-game flow

```c
void show_endgame_screen(int win_state) {
    /* 1. Score animation: counters tick up */
    animate_score_counters(p);

    /* 2. Show win/lose ending */
    if (win_state == REVOLUTION_WON) {
        play_animation("INDEPDAY.PIK");
        show_text(MENU_TEXT_INDEPENDENCE_WON);
    } else {
        play_animation("KING_WIN.PIK");
        show_text(MENU_TEXT_KING_WON);
    }

    /* 3. Update HOF */
    int score = compute_final_score(p);
    if (score > HALLFAME_MIN_SCORE) {
        hallfame_insert(p->name, score, win_state);
    }

    /* 4. Show HOF */
    show_hall_of_fame_screen();

    /* 5. Chain to closing */
    chain_to_exe("CLOSING.EXE");
}
```

`chain_to_exe` uses `INT 21h AH=4Bh` (load and execute) — DOS process
chain. CLOSING.EXE inherits the screen state, plays the credits, then
exits to DOS.

## Game-over conditions

| Condition                     | Outcome             |
|-------------------------------|---------------------|
| All colonies razed/captured   | Defeat              |
| All units destroyed           | Defeat              |
| REF defeated post-declaration | Revolution Win      |
| Year reaches 1850             | Time-out, score now |
| Player resigns (menu)         | Defeat              |

## Time-out scoring

If the game reaches **1850** without revolution being declared, the game
ends in a **time-out** (defeat). Score is computed normally. This is the
"you took too long" outcome.

## Revolution timing bonus

The earlier you win the Revolution, the more bonus points:

```c
int year_bonus = max(0, (1820 - year_won) * 10);
```

A 1700 declaration that wins in 1710 = +1100 bonus. A 1820 declaration
gets 0 bonus.

## Cross-references

- HOF format: [../formats/DAT.md](../formats/DAT.md)
- CLOSING.EXE chain: [ARCHITECTURE.md](ARCHITECTURE.md)
- Revolution timing: [REVOLUTION.md](REVOLUTION.md)
