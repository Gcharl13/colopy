// forge/main.cpp -- Viceroy Forge: the headless balance inspector (F1 MVP).
//
//   forge inspect [overlay.json]
//
// Loads the default ruleset (optionally with a rules.json mod overlay applied),
// validates it with sim::check_rules(), and prints key balance curves with deltas
// vs the un-modded baseline -- so a designer can see exactly how an edit moves the
// game. It links the headless sim in-process; this is the "balance laboratory."
// The Dear ImGui GUI + editors are the next cycle (F2).
#include "founding_fathers.hpp"
#include "economy.hpp"
#include "market.hpp"
#include "ref.hpp"
#include "rules.hpp"
#include "rules_invariants.hpp"
#include "rules_json.hpp"
#include "types.hpp"

#include <cstdio>
#include <string>

using namespace vc::sim;

static int sol_steady(int bells, int pop, const RuleData& rd) {
    Colony c;
    for (int i = 0; i < 3000; ++i) sol_update(c, bells, pop, rd);
    return sol_pct(c);
}

static int price_after(int turns, const RuleData& rd) {
    GameState g;
    g.price_base[SUGAR] = 800;
    g.powers[0].trade[SUGAR] = 100;             // player 0 selling Sugar
    for (int i = 0; i < turns; ++i) price_drift(g, rd);
    return g.price_base[SUGAR];
}

// Print a value with its delta vs the baseline (blank delta if unchanged).
static void row(const char* label, long base, long cur) {
    long delta = cur - base;
    if (delta) std::printf("    %-26s %8ld   (%+ld vs base)\n", label, cur, delta);
    else       std::printf("    %-26s %8ld\n", label, cur);
}

static void print_curves(const RuleData& base, const RuleData& cur) {
    std::printf("\n  Market: Sugar price (start 800, player 0 selling 100/turn)\n");
    for (int t = 1; t <= 5; ++t) {
        char lbl[32]; std::snprintf(lbl, sizeof lbl, "after turn %d", t);
        row(lbl, price_after(t, base), price_after(t, cur));
    }

    std::printf("\n  Sons of Liberty: steady-state %% (pop 10)\n");
    for (int bells : {1, 2, 4}) {
        char lbl[32]; std::snprintf(lbl, sizeof lbl, "bells %d", bells);
        row(lbl, sol_steady(bells, 10, base), sol_steady(bells, 10, cur));
    }

    std::printf("\n  REF: starting force (difficulty 1)\n");
    Ref rb = ref_start(1, base), rc = ref_start(1, cur);
    row("regulars",  rb.regulars,  rc.regulars);
    row("cavalry",   rb.cavalry,   rc.cavalry);
    row("man-o-war", rb.manowar,   rc.manowar);
    row("artillery", rb.artillery, rc.artillery);

    std::printf("\n  REF: accrual rate (difficulty 1) by year\n");
    for (int year : {1492, 1600, 1700, 1750}) {
        char lbl[32]; std::snprintf(lbl, sizeof lbl, "year %d", year);
        row(lbl, ref_accrue_rate(1, year, base), ref_accrue_rate(1, year, cur));
    }

    std::printf("\n  Founding Fathers: bell cost (human, difficulty 1, year 1599)\n");
    for (int n = 0; n < 4; ++n) {
        char lbl[32]; std::snprintf(lbl, sizeof lbl, "father #%d", n + 1);
        row(lbl, ff_cost(1, 1599, n, true, false, base), ff_cost(1, 1599, n, true, false, cur));
    }
}

static int do_inspect(const char* overlay_path) {
    RuleData base = make_default_rules();
    RuleData cur  = base;

    if (overlay_path) {
        try {
            forge::OverlayResult o = forge::load_overlay(overlay_path, make_default_rules());
            cur = o.rules;
            std::printf("Loaded overlay: %s\n", overlay_path);
            if (!o.warnings.empty()) {
                std::printf("  warnings:\n");
                for (const auto& w : o.warnings) std::printf("    - %s\n", w.c_str());
            }
        } catch (const std::exception& e) {
            std::printf("ERROR loading overlay: %s\n", e.what());
            return 2;
        }
    } else {
        std::printf("Inspecting the default (un-modded) ruleset.\n");
    }

    InvariantReport rep = check_rules(cur);
    std::printf("\nInvariants: %s\n", rep.ok() ? "PASS" : "FAIL");
    for (const auto& v : rep.violations) std::printf("    ! %s\n", v.c_str());

    print_curves(base, cur);

    std::printf("\n%s\n", rep.ok() ? "OK" : "INVALID RULESET");
    return rep.ok() ? 0 : 1;
}

int main(int argc, char** argv) {
    if (argc >= 2 && std::string(argv[1]) == "inspect")
        return do_inspect(argc >= 3 ? argv[2] : nullptr);

    std::printf("Viceroy Forge -- headless balance inspector\n"
                "usage: forge inspect [overlay.json]\n"
                "  inspect          validate + chart the default ruleset\n"
                "  inspect FILE     apply a rules.json mod overlay, then validate + chart vs base\n");
    return 0;
}
