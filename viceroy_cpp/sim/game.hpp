// sim/game.hpp -- the per-turn orchestration (spec/systems/turn_dispatch.md).
#pragma once
#include "types.hpp"
#include "immigration.hpp"   // RandFn
#include <vector>

namespace vc::sim {

struct World {
    std::vector<Colony> colonies;
    // units[] arrive with P2 (combat/movement)
};

// One full turn, in the byte-verified phase order (func_005760):
//   Production (per colony) -> Market price drift -> Immigration ->
//   REF (King) accrual+purchase -> cadence advance.
// (Per-power Orders/Diplomacy AI phases are P2+.) `rng` drives immigration's
// dock-slot pick; `player_idx` is the human power whose immigration/REF advance.
void step_turn(GameState& g, World& w, const RandFn& rng, int player_idx = 0);

} // namespace vc::sim
