// sim/economy.hpp -- colony economic formulas (spec/systems/colony.md, byte-verified).
#pragma once
#include "types.hpp"
#include "rules.hpp"   // RuleData / default_rules() -- scalar constants are injected

namespace vc::sim {

// Per-good warehouse capacity (func_008D00): (level+1)*cfg.warehouse_cap_base.
int warehouse_cap(const Colony& c, const RuleData& rd = default_rules());

// Sons-of-Liberty % from the EMA state (sol_membership_pct @0x8524): A*100/B.
int sol_pct(const Colony& c);

// Per-turn SoL EMA update (func_02D658 @0x2DA1C): decay 1/64, inflow 2*pop.
//   B -= B>>cfg.sol_decay_shift; B = max(B,1); B += cfg.sol_inflow_mult*pop
//   A += bells - (A>>shift); A = clamp(0, B)
// Steady state => sol% ~= 50*bells/pop.
void sol_update(Colony& c, int bells_this_turn, int population,
                const RuleData& rd = default_rules());

// Tory production penalty + expert match on a base tile yield
// (compute_terrain_yield @0x9D14/@0x9DAD):
//   tory = round(pop*(100-sol%)/100); div = human ? base-difficulty : base
//   y -= tory/div  (truncated)
//   if expert: era good +cfg.expert_era_bonus, else manufactured *cfg.expert_mfg_mult
int tory_expert_adjust(int base_yield, int population, int sol_percent,
                       int difficulty, bool human, bool expert, int good,
                       const RuleData& rd = default_rules());

// Accrue hammers and (if a target is set) try to complete it.
// +0x92 and +0xB6 both accrue; complete when cost <= both; bank -= cost
// (surplus carried); set the built bit. Returns true on completion.
bool build_step(Colony& c, int hammers_produced, int build_cost);

// One colony's per-turn economic update (the Production phase, per colony):
// SoL EMA from bells, build progress from hammers, and food->population growth
// (accumulate food_per_turn; +1 pop at threshold, surplus carried, max @0x009432).
void colony_economic_step(Colony& c, int difficulty,
                          const RuleData& rd = default_rules());

} // namespace vc::sim
