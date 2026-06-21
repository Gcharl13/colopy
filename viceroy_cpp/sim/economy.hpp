// sim/economy.hpp -- colony economic formulas (spec/systems/colony.md, byte-verified).
#pragma once
#include "types.hpp"

namespace vc::sim {

// Per-good warehouse capacity (func_008D00): (level+1)*100.
int warehouse_cap(const Colony& c);

// Sons-of-Liberty % from the EMA state (sol_membership_pct @0x8524): A*100/B.
int sol_pct(const Colony& c);

// Per-turn SoL EMA update (func_02D658 @0x2DA1C): decay 1/64, inflow 2*pop.
//   B -= B>>6; B = max(B,1); B += 2*pop
//   A += bells - (A>>6); A = clamp(0, B)
// Steady state => sol% ~= 50*bells/pop.
void sol_update(Colony& c, int bells_this_turn, int population);

// Tory production penalty + expert match on a base tile yield
// (compute_terrain_yield @0x9D14/@0x9DAD):
//   tory = round(pop*(100-sol%)/100); div = human ? 10-difficulty : 10
//   y -= tory/div  (truncated)
//   if expert: era good +2, else manufactured *2
int tory_expert_adjust(int base_yield, int population, int sol_percent,
                       int difficulty, bool human, bool expert, int good);

// Accrue hammers and (if a target is set) try to complete it.
// +0x92 and +0xB6 both accrue; complete when cost <= both; bank -= cost
// (surplus carried); set the built bit. Returns true on completion.
bool build_step(Colony& c, int hammers_produced, int build_cost);

} // namespace vc::sim
