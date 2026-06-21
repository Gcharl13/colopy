// sim/turn.hpp -- turn/year/season cadence (spec/systems/turn_dispatch.md).
#pragma once
#include "types.hpp"

namespace vc::sim {

// End-of-turn advance (func_005760 tail @0x5A9D): turn++; before 1600 one turn
// is one year; from 1600 on, two seasons per year (year advances on season wrap).
void advance_cadence(GameState& g);

// Forced end-game year gate (@0x5BB5): year >= 1725.
inline bool game_over(const GameState& g) { return g.year >= 1725; }

} // namespace vc::sim
