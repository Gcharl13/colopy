// forge/inspect.hpp -- the balance-inspector's data layer (header-only, inline).
//
// Shared by the headless CLI (forge inspect) and the GUI scaffold so both compute
// identical curves from one place. Pure: just runs the sim under a RuleData. The
// CLI exercises this, so the GUI's data layer is verified even though its ImGui
// rendering glue is not buildable in CI.
#pragma once

#include "economy.hpp"
#include "founding_fathers.hpp"
#include "market.hpp"
#include "ref.hpp"
#include "rules.hpp"
#include "types.hpp"

#include <string>
#include <vector>

namespace forge {

// Sons-of-Liberty steady-state % for given bells/pop under `rd`.
inline int sol_steady(int bells, int pop, const vc::sim::RuleData& rd) {
    vc::sim::Colony c;
    for (int i = 0; i < 3000; ++i) vc::sim::sol_update(c, bells, pop, rd);
    return vc::sim::sol_pct(c);
}

// Sugar price after N turns of player 0 selling 100/turn (start 800) under `rd`.
inline int price_after(int turns, const vc::sim::RuleData& rd) {
    vc::sim::GameState g;
    g.price_base[vc::sim::SUGAR] = 800;
    g.powers[0].trade[vc::sim::SUGAR] = 100;
    for (int i = 0; i < turns; ++i) vc::sim::price_drift(g, rd);
    return g.price_base[vc::sim::SUGAR];
}

struct CurveRow {
    std::string section;
    std::string label;
    long base;   // value under the baseline ruleset
    long cur;    // value under the inspected ruleset
    long delta() const { return cur - base; }
};

// Build the full set of balance curves comparing `cur` against `base`.
inline std::vector<CurveRow> balance_curves(const vc::sim::RuleData& base,
                                            const vc::sim::RuleData& cur) {
    using namespace vc::sim;
    std::vector<CurveRow> rows;
    auto add = [&](const char* sec, const std::string& lbl, long b, long c) {
        rows.push_back({sec, lbl, b, c});
    };

    for (int t = 1; t <= 5; ++t)
        add("Market: Sugar price (sell 100/turn)", "after turn " + std::to_string(t),
            price_after(t, base), price_after(t, cur));

    for (int bells : {1, 2, 4})
        add("Sons of Liberty: steady % (pop 10)", "bells " + std::to_string(bells),
            sol_steady(bells, 10, base), sol_steady(bells, 10, cur));

    Ref rb = ref_start(1, base), rc = ref_start(1, cur);
    add("REF: starting force (difficulty 1)", "regulars",  rb.regulars,  rc.regulars);
    add("REF: starting force (difficulty 1)", "cavalry",   rb.cavalry,   rc.cavalry);
    add("REF: starting force (difficulty 1)", "man-o-war", rb.manowar,   rc.manowar);
    add("REF: starting force (difficulty 1)", "artillery", rb.artillery, rc.artillery);

    for (int year : {1492, 1600, 1700, 1750})
        add("REF: accrual rate (difficulty 1)", "year " + std::to_string(year),
            ref_accrue_rate(1, year, base), ref_accrue_rate(1, year, cur));

    for (int n = 0; n < 4; ++n)
        add("Founding Fathers: bell cost (human d1 y1599)", "father #" + std::to_string(n + 1),
            ff_cost(1, 1599, n, true, false, base), ff_cost(1, 1599, n, true, false, cur));

    return rows;
}

} // namespace forge
