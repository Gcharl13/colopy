// sim/scoring.hpp -- end-game scoring (spec/systems/scoring.md).
#pragma once
#include "revolution.hpp"   // revolution_bonus

namespace vc::sim {

// Difficulty multiplier (func_03A9C0): diff+4+(diff>=3)+(diff>=4) = {4,5,6,8,10}.
inline int score_difficulty_mult(int difficulty) {
    return difficulty + 4 + (difficulty >= 3 ? 1 : 0) + (difficulty >= 4 ? 1 : 0);
}

// Population score per colonist by profession byte (UnitRecord +0x15):
//   {0x19,0x1A,0x1B} -> +1; 0x1C (Free Colonist) -> +2; else (skilled) -> +4.
inline int score_population_component(int profession) {
    if (profession == 0x19 || profession == 0x1A || profession == 0x1B) return 1;
    if (profession == 0x1C) return 2;
    return 4;
}

// Hall-of-Fame rank: largest n with n*n/3 < score, capped at 23.
inline int score_rank(int score) {
    int n = 0;
    while (n < 23 && (n + 1) * (n + 1) / 3 < score) ++n;
    return n;
}

// The full base score (scoring.md components 1-7), then the final scaling
// (func_03A9C0): score = (mult * base) / 100; score >>= 1.
//   population_score  = Σ score_population_component(profession) over every colonist
//   ff_count          x5 per founding father
//   rebel_sentiment   national Sons-of-Liberty % (x1)
//   razed             -(difficulty+1) per razed native settlement
//   gold              +gold/1000
//   post_bells        +bells/100 after the intervention, capped at 100 (gate on the
//                     declaration is RECONSTRUCTED; spec gates on [0x5382]&2)
//   declaration_year  revolution bonus (1780-year)*2 if declared+won before 1780
inline long score_game(int difficulty, long population_score, int ff_count,
                       int rebel_sentiment_pct, int razed_settlements, long gold,
                       long post_intervention_bells, int declaration_year, bool won_war) {
    long base = population_score;
    base += (long)ff_count * 5;
    base += rebel_sentiment_pct;
    base -= (long)razed_settlements * (difficulty + 1);
    base += gold / 1000;
    long pb = post_intervention_bells / 100;
    if (pb > 100) pb = 100;
    base += pb;
    if (won_war && declaration_year > 0) base += revolution_bonus(declaration_year);
    long score = (long)score_difficulty_mult(difficulty) * base / 100;
    score >>= 1;
    return score < 0 ? 0 : score;
}

} // namespace vc::sim
