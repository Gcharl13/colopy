// sim/scoring.hpp -- end-game scoring (spec/systems/scoring.md).
#pragma once

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

} // namespace vc::sim
