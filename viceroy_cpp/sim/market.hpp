// sim/market.hpp -- per-turn European price drift (spec/systems/market.md).
#pragma once
#include "types.hpp"
#include "rules.hpp"   // RuleData / default_rules()

namespace vc::sim {

// func_0305A8 (re-verified @0x305A8): for each good, subtract
//   (price_base[g] + Σ_players max(trade[p][g], 0)) >> cfg.price_drift_shift
// from price_base[g]. Heavy selling raises the accumulator -> price falls faster.
void price_drift(GameState& g, const RuleData& rd = default_rules());

} // namespace vc::sim
