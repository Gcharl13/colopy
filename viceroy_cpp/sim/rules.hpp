// sim/rules.hpp -- RuleData: the data-driven, moddable parameter set.
//
// This is the "RuleData seam": the sim reads its balance numbers from a RuleData
// instance rather than from file-static literals, so the same headless core can be
// driven by edited data (the modding tool / "Forge"), shared by every front-end
// (Godot, ESP32) without forking logic. It is injected like the RNG (RandFn):
// pass a `const RuleData&` to the functions that need it, or use the free-function
// overloads that fall back to default_rules().
//
// default_rules() is value-identical to the original literals -- the existing
// golden-master vectors hold unchanged. A JSON loader (kept OUT of this pure,
// dependency-free core; it lives in the importer/Forge) can override the
// balance fields from data_extracted/tables/*.json.
//
// What is data (moddable) vs code (structural):
//   - units[i].attack/defense/cargo  <- @UNIT attack/combat/cargo (value-identical)
//   - terrain_defense[id]            <- @TERRAIN "Defensive" column
//   - units[i].name / units[i].move_class  stay CODE-side: the names are display
//     strings and move_class (1=land / 99=naval / 6=treasure / 0=native) is a
//     structural classification not present in @UNIT. See notes/rulings.
#pragma once

#include "unit.hpp"
#include <array>

namespace vc::sim {

// Number of distinct terrain ids (0..28): 0..7 base, 8..23 forest variants,
// 24 Arctic, 25 Ocean, 26 Sea Lane, 27 Mountains, 28 Hills.
constexpr int NTERRAIN = 29;

// Scalar balance constants. Unlike units/terrain (value-identically backed by the
// shipped @UNIT/@TERRAIN data), these are the sim's pure-formula constants -- there
// is no shipped-data source, so they live here as tunable code-side config whose
// defaults reproduce the historical literals exactly. A mod overlay (rules.json,
// loaded by the Forge) may override them; see forge/rules_json.*.
struct Config {
    // --- economy (sim/economy.cpp) ---
    int warehouse_cap_base    = 100;  // per-good cap = (level+1)*base
    int sol_decay_shift       = 6;    // SoL EMA decay 1/(2^shift) = 1/64
    int sol_inflow_mult       = 2;    // divisor inflow = mult*population
    int sol_birth_bonus       = 100;  // SoL divisor bump on a birth
    int food_growth_threshold = 200;  // food to add +1 population
    int max_population        = 32;   // colony population cap
    int tory_divisor_base     = 10;   // tory penalty divisor (human: base-diff; ai: base)
    int expert_era_bonus      = 2;    // expert on an era good: +bonus
    int expert_mfg_mult       = 2;    // expert on a manufactured good: *mult
    // --- market (sim/market.cpp) ---
    int price_drift_shift     = 8;    // price drift = acc >> shift  (/256)
    // --- founding fathers (sim/founding_fathers.cpp) ---
    int ff_human_scale = 16, ff_human_offset = 3;     // human base = (diff+off)*scale
    int ff_ai_scale    = 8,  ff_ai_offset    = 14;    // ai base    = (off-diff)*scale
    int ff_post_indep_scale = 1500, ff_post_indep_offset = 2000;  // diff*scale+off
    int ff_compounding_shift   = 1;   // per reached gate: cost += cost>>shift (x1.5)
    int ff_first_father_shift  = 1;   // first father: cost >>= shift (half price)
    std::array<int, 4> ff_gate_years = {1600, 1650, 1700, 1750};
    // --- REF / King (sim/ref.cpp) ---
    int ref_regulars_scale = 8, ref_regulars_offset = 15;  // start = scale*diff+off
    int ref_cavalry_scale  = 5, ref_cavalry_offset  = 5;
    int ref_manowar_scale  = 3, ref_manowar_offset  = 2;
    int ref_artillery_scale = 6, ref_artillery_offset = 2;
    int ref_accrue_scale   = 8, ref_accrue_offset   = 10;  // rate = scale*diff+off
    std::array<int, 3> ref_accrue_gate_years = {1600, 1700, 1750};  // rate doubles at each
    int ref_unit_cost      = 1800;    // gold per REF unit purchased
    int ref_cavalry_ratio  = 3;       // 1 cavalry per N regulars
    int ref_artillery_ratio = 4;      // 1 artillery per N regulars
    int ref_naval_ratio    = 10;      // 1 man-o-war per N land units
    // --- immigration (sim/immigration.cpp, sim/game.cpp) ---
    int imm_threshold_cap  = 4000;    // crosses threshold cap
    int imm_sub4k_mult = 2, imm_sub4k_offset = 8;  // below cap: a*mult+off
    int imm_ai_scale = 8, imm_ai_divisor = 8;      // ai: a*(scale-diff)/divisor
    int imm_england_num = 2, imm_england_den = 3;  // England (player 0): a*num/den
    int imm_dock_slots = 3;           // immigrant dock slot count
    int imm_base_crosses = 2;         // per-turn base crosses before colony output
};

struct RuleData {
    std::array<UnitStats, NUNITTYPES> units{};
    std::array<int, NTERRAIN> terrain_defense{};   // "Defensive" value by terrain id
    std::array<int, NTERRAIN> terrain_move{};      // move-points to ENTER, by terrain id
    Config cfg{};                                  // scalar balance constants
};

// Build a fresh default ruleset (value-identical to the historical literals).
RuleData make_default_rules();

// The shared canonical default ruleset (built once).
const RuleData& default_rules();

} // namespace vc::sim
