// sim/ref.hpp -- Royal Expeditionary Force growth (spec/systems/ref_growth.md).
#pragma once
#include "types.hpp"

namespace vc::sim {

// Starting REF by difficulty (new_game_state_init @0x7569B):
//   regulars 8d+15, cavalry 5(d+1), man-o-war 3d+2, artillery 6d+2.
Ref ref_start(int difficulty);

// Per-turn budget accrual rate (func_03E162 @0x3E17C, re-verified):
//   (8d+10), doubled at year>=1600, >=1700, >=1750.
int ref_accrue_rate(int difficulty, int year);

// Spend royal_money on REF units while >= 1800, maintaining the ratios
// (3:1 reg:cav, 4:1 reg:art, 10:1 land:naval). Mutates ref + royal_money.
void ref_purchase(Ref& ref, int64_t& royal_money);

} // namespace vc::sim
