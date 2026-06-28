// sim/rules_invariants.cpp -- see rules_invariants.hpp.
#include "rules_invariants.hpp"
#include "types.hpp"
#include "unit.hpp"
#include "economy.hpp"
#include "market.hpp"

namespace vc::sim {

namespace {
void need(InvariantReport& r, bool cond, const std::string& msg) {
    if (!cond) r.violations.push_back(msg);
}
bool shift_ok(int s) { return s >= 0 && s <= 30; }   // avoid UB / no-op shifts
}

InvariantReport check_rules(const RuleData& rd) {
    InvariantReport r;
    const Config& cfg = rd.cfg;

    // --- unit table: non-negative stats; structural move_class ---
    for (int i = 0; i < NUNITTYPES; ++i) {
        const UnitStats& u = rd.units[i];
        need(r, u.attack >= 0 && u.defense >= 0 && u.cargo >= 0 && u.movement >= 0,
             "unit " + std::to_string(i) + ": negative stat");
        int mc = u.move_class;
        need(r, mc == 0 || mc == 1 || mc == 6 || mc == 99,
             "unit " + std::to_string(i) + ": move_class not in {0,1,6,99}");
    }

    // --- terrain defense: sized, non-negative ---
    need(r, (int)rd.terrain_defense.size() == NTERRAIN, "terrain_defense wrong size");
    for (int id = 0; id < NTERRAIN; ++id) {
        need(r, rd.terrain_defense[id] >= 0,
             "terrain " + std::to_string(id) + ": negative defense");
        need(r, rd.terrain_move[id] >= 1,   // 0 would stall movement
             "terrain " + std::to_string(id) + ": move cost < 1");
    }

    // --- economy ---
    need(r, cfg.warehouse_cap_base > 0, "warehouse_cap_base must be > 0");
    need(r, shift_ok(cfg.sol_decay_shift), "sol_decay_shift out of [0,30]");
    need(r, cfg.food_growth_threshold > 0, "food_growth_threshold must be > 0");
    need(r, cfg.max_population > 0, "max_population must be > 0");
    need(r, cfg.tory_divisor_base > 0, "tory_divisor_base must be > 0");

    // --- market ---
    need(r, shift_ok(cfg.price_drift_shift), "price_drift_shift out of [0,30]");

    // --- founding fathers ---
    need(r, shift_ok(cfg.ff_compounding_shift), "ff_compounding_shift out of [0,30]");
    need(r, shift_ok(cfg.ff_first_father_shift), "ff_first_father_shift out of [0,30]");
    for (size_t i = 1; i < cfg.ff_gate_years.size(); ++i)
        need(r, cfg.ff_gate_years[i] >= cfg.ff_gate_years[i - 1],
             "ff_gate_years not ascending");

    // --- REF ---
    need(r, cfg.ref_unit_cost > 0, "ref_unit_cost must be > 0");
    need(r, cfg.ref_cavalry_ratio > 0 && cfg.ref_artillery_ratio > 0 && cfg.ref_naval_ratio > 0,
         "REF ratios must be > 0");
    for (size_t i = 1; i < cfg.ref_accrue_gate_years.size(); ++i)
        need(r, cfg.ref_accrue_gate_years[i] >= cfg.ref_accrue_gate_years[i - 1],
             "ref_accrue_gate_years not ascending");

    // --- immigration ---
    need(r, cfg.imm_threshold_cap > 0, "imm_threshold_cap must be > 0");
    need(r, cfg.imm_ai_divisor > 0, "imm_ai_divisor must be > 0");
    need(r, cfg.imm_england_den > 0, "imm_england_den must be > 0");
    need(r, cfg.imm_dock_slots >= 1, "imm_dock_slots must be >= 1");

    // --- behavioral sanity (run the real sim under this ruleset) ---
    if (shift_ok(cfg.sol_decay_shift)) {
        Colony c;
        for (int i = 0; i < 2000; ++i) sol_update(c, 2, 10, rd);
        int p = sol_pct(c);
        need(r, p >= 0 && p <= 100, "SoL% does not converge into [0,100]");
    }
    if (shift_ok(cfg.price_drift_shift)) {
        GameState g;
        g.price_base[0] = 800;
        g.powers[0].trade[0] = 100;
        price_drift(g, rd);
        need(r, g.price_base[0] < 800, "price does not fall when a good is being sold");
    }

    return r;
}

} // namespace vc::sim
