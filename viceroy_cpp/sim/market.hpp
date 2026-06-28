// sim/market.hpp -- per-turn European price drift (spec/systems/market.md).
#pragma once
#include "types.hpp"

namespace vc::sim {

// func_0305A8 (re-verified @0x305A8): for each good, subtract
//   (price_base[g] + Σ_players max(trade[p][g], 0)) >> 8
// from price_base[g]. Heavy selling raises the accumulator -> price falls faster.
void price_drift(GameState& g);

} // namespace vc::sim
