// sim/economy.hpp -- colony economic formulas (spec/systems/colony.md, byte-verified).
#pragma once
#include "types.hpp"
#include "rules.hpp"   // RuleData / default_rules() -- scalar constants are injected

namespace vc::sim {

// Per-good warehouse capacity (func_008D00): (level+1)*cfg.warehouse_cap_base.
int warehouse_cap(const Colony& c, const RuleData& rd = default_rules());

// Sons-of-Liberty % from the EMA state (sol_membership_pct @0x8524): A*100/B.
// Sons-of-Liberty membership percent (sol_membership_pct @0x8557/@0x855E):
// A*100/B clamped to 100; the FF with op 0x12 (row 18) adds +20 for the
// human player's colonies, clamp 100 (@0x859C -- colony.md 2).
int sol_pct(const Colony& c, uint32_t ff_owned = 0, bool human_owner = false);

// Per-turn SoL EMA update (func_02D658 @0x2DA1C): decay 1/64, inflow 2*pop.
//   B -= B>>cfg.sol_decay_shift; B = max(B,1); B += cfg.sol_inflow_mult*pop
//   A += bells - (A>>shift); A = clamp(0, B)
// Steady state => sol% ~= 50*bells/pop.
// woi_tory_colony: the colony belongs to the tory-leader power ([0x53D2])
// during the War of Independence -- its bells are halved and negated
// (@0x2D9F2) before the EMA.
void sol_update(Colony& c, int bells_this_turn, int population,
                const RuleData& rd = default_rules(),
                bool woi_tory_colony = false);

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

// Begin constructing building `id` (cost + min_colony come from @BUILDING, supplied by the
// caller so the sim stays table-I/O-free). Rejects if the colony is below min_colony or already
// has the building; otherwise sets build_target/build_cost. Returns false if rejected.
bool start_building(Colony& c, int building_id, int build_cost, int min_colony);

// Pay gold to finish the current build immediately (the @BUYME1 "Complete it" path). Debits
// `gold_cost` from the owner if affordable, sets the built bit, clears the target. Returns false
// if there's no target or not enough gold. The gold_cost itself is computed by the caller
// (a Formula node) -- the rush-cost curve is RECONSTRUCTED, see notes/rulings.
bool rush_build(Colony& c, Power& owner, long gold_cost);

// One colony's per-turn economic update (the Production phase, per colony):
// SoL EMA from bells, build progress from hammers, and food->population growth
// (accumulate food_per_turn; +1 pop at threshold, surplus carried, max @0x009432).
// food_event (optional out): 0 none, 1 = food running out (@FOODLOW/@FOOD1
// family), 2 = a colonist starved (@STARVE1), 3 = the colony vanished
// (@VANISH) -- the resident driver's per-colony message push (func_02D658
// @0x2E219/@0x2E234/@0x2E265, once-per-turn gate [0xa898]).
// sol_event (optional out): the per-colony SoL announcement with the
// byte-verified hysteresis latches (func_02D658 @0x2DB29..@0x2DBFA, latch
// bits ColonyRecord +0x1C 0x04/0x02): 1 = @REBELMAJORITY (rose to >= 50),
// 2 = @REBELUNANIMOUS (reached 100), 3 = @TORYMINORITY (fell below 95 from
// unanimous), 4 = @TORYMAJORITY (fell below 50).
void colony_economic_step(Colony& c, int difficulty,
                          const RuleData& rd = default_rules(),
                          int* food_event = nullptr,
                          int* sol_event = nullptr);

// End-of-turn surplus disposal (warehousing.md §6.4, func_02D658 @0x2D6F7): after production is
// banked, each tradeable good (1..15; Food(0) drives growth, excluded) whose stockpile >= 100 is
// reduced to 50 and the excess auto-exported to Europe. The excess is SOLD -- taxed proceeds credited
// to the owner's gold -- unless independence is declared, in which case it is WASTED (no Crown market).
// Returns the total gold gained. NOTE: the taxed-sale amount is net = excess*price*(100-tax)/100;
// warehousing.md's shorthand omits the *price factor while colony.md keeps it -- price-weighted here
// (the economically-correct reading), so the exact proceeds are RECONSTRUCTED.
long export_overflow(Colony& c, Power& owner, const std::array<int32_t, NGOODS>& price,
                     int tax_pct, bool independence);

} // namespace vc::sim
