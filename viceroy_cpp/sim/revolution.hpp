// sim/revolution.hpp -- War of Independence (spec/systems/revolution.md).
#pragma once

namespace vc::sim {

// Declare Independence gate (func_03E984): national SoL >= 50%.
inline bool can_declare_independence(int national_sol_pct) {
    return national_sol_pct >= 50;
}

// End-game victory (per-turn resolver @0x2F464): the rebels WIN when the
// surviving REF combatants (unit types {6,8,0xB}) fall below the threshold
// (normally 1; 8 if the harder-end flag [0x5382]&0x40 is set) AND no foreign
// intervention force remains.
inline bool ref_war_won(int surviving_ref, int intervention_force, bool hard_flag) {
    int threshold = hard_flag ? 8 : 1;
    return surviving_ref < threshold && intervention_force == 0;
}

// Revolution score bonus (additive): (1780 - declaration_year)*2 if won before
// 1780, else 0.
inline int revolution_bonus(int declaration_year) {
    return declaration_year < 1780 ? (1780 - declaration_year) * 2 : 0;
}

// Per-turn Tory-uprising trigger (func_03CAC6): fires when random_int(0,diff+1)
// != 0, i.e. probability (diff+1)/(diff+2).
inline bool tory_uprising(int roll, int /*difficulty*/) { return roll != 0; }

} // namespace vc::sim
