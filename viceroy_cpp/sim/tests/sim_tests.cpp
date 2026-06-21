// sim_tests.cpp -- golden-master tests for the economic-spine sim core.
// Each vector is a documented output from spec/systems/* (cited in the plan).
// Dependency-free; exits non-zero if any check fails.
#include "../types.hpp"
#include "../economy.hpp"
#include "../market.hpp"
#include "../turn.hpp"
#include "../ref.hpp"
#include <cstdio>

using namespace vc::sim;

static int failures = 0;
#define CHECK(expr, ...) do { \
    if (!(expr)) { ++failures; std::printf("  FAIL: %s  [", #expr); \
        std::printf(__VA_ARGS__); std::printf("]\n"); } \
} while (0)

static void test_cadence() {
    std::printf("cadence:\n");
    GameState g;                          // 1492, season 0, turn 0
    CHECK(g.year == 1492 && g.season == 0 && g.turn == 0, "start");
    for (int i = 0; i < 108; ++i) advance_cadence(g);
    CHECK(g.year == 1600 && g.season == 0 && g.turn == 108,
          "turn108 -> %d s%d t%ld", g.year, g.season, (long)g.turn);
    advance_cadence(g);
    CHECK(g.year == 1600 && g.season == 1 && g.turn == 109,
          "turn109 -> %d s%d", g.year, g.season);
    advance_cadence(g);
    CHECK(g.year == 1601 && g.season == 0 && g.turn == 110,
          "turn110 -> %d s%d", g.year, g.season);
}

static int sol_steady(int bells, int pop) {
    Colony c;                             // A=0, B=1
    for (int i = 0; i < 3000; ++i) sol_update(c, bells, pop);
    return sol_pct(c);
}

static void test_sol() {
    std::printf("Sons of Liberty EMA (pop 10):\n");
    CHECK(sol_steady(1, 10) == 5,  "bells1 -> %d%%", sol_steady(1, 10));
    CHECK(sol_steady(2, 10) == 10, "bells2 -> %d%%", sol_steady(2, 10));
    CHECK(sol_steady(4, 10) == 20, "bells4 -> %d%%", sol_steady(4, 10));
}

static void test_production() {
    std::printf("tory penalty + expert (Food base 3, pop 10, diff 1):\n");
    CHECK(tory_expert_adjust(3, 10,  0, 1, true, false, FOOD) == 2, "sol0");
    CHECK(tory_expert_adjust(3, 10, 50, 1, true, false, FOOD) == 3, "sol50");
    // expert: Food (+2) vs a manufactured good (x2)
    CHECK(tory_expert_adjust(3, 10, 50, 1, true, true, FOOD)  == 5, "expert food +2");
    CHECK(tory_expert_adjust(3, 10, 50, 1, true, true, CIGARS) == 6, "expert mfg x2");
}

static void test_warehouse() {
    std::printf("warehouse capacity:\n");
    Colony c;
    c.warehouse_lvl = 0; CHECK(warehouse_cap(c) == 100, "lvl0");
    c.warehouse_lvl = 1; CHECK(warehouse_cap(c) == 200, "lvl1");
    c.warehouse_lvl = 2; CHECK(warehouse_cap(c) == 300, "lvl2");
}

static void test_build() {
    std::printf("hammers / build (cost 64):\n");
    Colony c; c.build_target = 0;
    CHECK(!build_step(c, 30, 64), "30 not done");
    CHECK(!build_step(c, 30, 64), "60 not done");
    CHECK(build_step(c, 10, 64), "70 completes");
    CHECK(c.build_bank == 6, "surplus carried -> %u", c.build_bank);
    CHECK((c.built_mask & 1ull) != 0, "built bit set");
}

static void test_price_drift() {
    std::printf("price drift (base 800, player0 sells 100 Sugar):\n");
    GameState g;
    g.price_base[SUGAR] = 800;
    g.powers[0].trade[SUGAR] = 100;       // cumulative trade accumulator
    price_drift(g);
    CHECK(g.price_base[SUGAR] == 797, "turn1 -> %d", g.price_base[SUGAR]);
    price_drift(g);
    CHECK(g.price_base[SUGAR] == 794, "turn2 -> %d", g.price_base[SUGAR]);
}

static void test_ref() {
    std::printf("REF growth (difficulty 1):\n");
    Ref r = ref_start(1);
    CHECK(r.regulars == 23 && r.cavalry == 10 && r.manowar == 5 && r.artillery == 8,
          "start %d/%d/%d/%d", r.regulars, r.cavalry, r.manowar, r.artillery);
    CHECK(ref_accrue_rate(1, 1492) == 18, "rate 1492");
    CHECK(ref_accrue_rate(1, 1600) == 36, "rate 1600");
    CHECK(ref_accrue_rate(1, 1700) == 72, "rate 1700");
    CHECK(ref_accrue_rate(1, 1750) == 144, "rate 1750");
    int64_t money = 1800;
    ref_purchase(r, money);
    CHECK(money == 0 && r.regulars == 24,
          "purchase -> money %lld reg %d", (long long)money, r.regulars);
}

int main() {
    test_cadence();
    test_sol();
    test_production();
    test_warehouse();
    test_build();
    test_price_drift();
    test_ref();
    if (failures == 0) { std::printf("\nALL SIM TESTS PASSED\n"); return 0; }
    std::printf("\n%d FAILURE(S)\n", failures);
    return 1;
}
