// sim/turn.cpp -- see turn.hpp.
#include "turn.hpp"

namespace vc::sim {

void advance_cadence(GameState& g) {
    g.turn += 1;
    if (g.year < 1600) {
        g.year += 1;                       // 1 turn = 1 year (fast early game)
    } else {
        g.season = (g.season + 1) % 2;     // 2 seasons/year
        if (g.season == 0) g.year += 1;
    }
}

} // namespace vc::sim
