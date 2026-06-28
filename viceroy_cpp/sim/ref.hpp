// sim/ref.hpp -- Royal Expeditionary Force growth (spec/systems/ref_growth.md).
#pragma once
#include "types.hpp"
#include "rules.hpp"   // RuleData / default_rules()

namespace vc::sim {

// Starting REF by difficulty (new_game_state_init @0x7569B):
//   regulars 8d+15, cavalry 5(d+1), man-o-war 3d+2, artillery 6d+2 (cfg scalars).
Ref ref_start(int difficulty, const RuleData& rd = default_rules());

// Per-turn budget accrual rate (func_03E162 @0x3E17C, re-verified):
//   (8d+10), doubled at each cfg.ref_accrue_gate_years (1600/1700/1750).
int ref_accrue_rate(int difficulty, int year, const RuleData& rd = default_rules());

// Spend royal_money on REF units while >= cfg.ref_unit_cost, maintaining the ratios
// (3:1 reg:cav, 4:1 reg:art, 10:1 land:naval). Mutates ref + royal_money.
void ref_purchase(Ref& ref, int64_t& royal_money, const RuleData& rd = default_rules());

} // namespace vc::sim
