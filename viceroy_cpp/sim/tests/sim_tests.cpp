// sim_tests.cpp -- golden-master tests for the economic-spine sim core.
// Each vector is a documented output from spec/systems/* (cited in the plan).
// Dependency-free; exits non-zero if any check fails.
#include "../types.hpp"
#include "../economy.hpp"
#include "../market.hpp"
#include "../turn.hpp"
#include "../ref.hpp"
#include "../immigration.hpp"
#include "../game.hpp"
#include "../rules.hpp"
#include "../unit.hpp"
#include "../combat.hpp"
#include "../natives.hpp"
#include "../diplomacy.hpp"
#include "../founding_fathers.hpp"
#include "../revolution.hpp"
#include "../scoring.hpp"
#include "../mapgen.hpp"
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

static void test_food_growth() {
    std::printf("food -> population growth (food 50/turn, threshold 200):\n");
    Colony c; c.population = 1; c.food_per_turn = 50;
    colony_economic_step(c, 1); colony_economic_step(c, 1); colony_economic_step(c, 1);
    CHECK(c.population == 1 && c.food_accum == 150, "after 3 -> pop %d acc %u",
          c.population, c.food_accum);
    colony_economic_step(c, 1);
    CHECK(c.population == 2 && c.food_accum == 0, "after 4 -> pop %d acc %u",
          c.population, c.food_accum);
}

static void test_immigration() {
    std::printf("immigration (England, 3 workers, 0 units, diff 0):\n");
    CHECK(crosses_threshold(3, 0, 0, false, 0) == 9, "threshold -> %d",
          crosses_threshold(3, 0, 0, false, 0));
    Power p;
    auto rng = [](int, int) { return 1; };       // dock slot 1
    bool spawned = false;
    int turns = 0;
    for (; turns < 10 && !spawned; ++turns)       // 2 crosses/turn, threshold 9
        spawned = immigration_step(p, 2, 3, 0, 0, false, 0, rng).spawned;
    CHECK(turns == 5, "spawned on turn %d", turns);
    CHECK(p.dock_pool[1] == 0x1C && p.crosses_accum == 0, "dock %d acc %d",
          p.dock_pool[1], p.crosses_accum);
}

static void test_turn_loop() {
    std::printf("turn-loop integration (diff 1; 1 colony building Stockade):\n");
    GameState g; g.difficulty = 1;
    g.price_base[SUGAR] = 800; g.powers[0].trade[SUGAR] = 100;
    World w; Colony c;
    c.owner_power = 0; c.population = 3; c.hammers_per_turn = 10;
    c.build_target = 0; c.build_cost = 64;        // Stockade
    w.colonies.push_back(c);
    auto rng = [](int, int) { return 0; };
    for (int i = 0; i < 8; ++i) step_turn(g, w, rng);
    CHECK((w.colonies[0].built_mask & 1ull) != 0, "Stockade built");
    CHECK(g.powers[0].royal_money == 144, "REF accrued -> %lld",
          (long long)g.powers[0].royal_money);          // 18/turn * 8
    CHECK(g.price_base[SUGAR] < 800, "Sugar price drifted -> %d", g.price_base[SUGAR]);
    CHECK(g.year == 1500 && g.turn == 8, "advanced to %d t%ld", g.year, (long)g.turn);
}

static void test_units() {
    std::printf("@UNIT stats:\n");
    CHECK(unit_stats(SOLDIERS).attack == 2 && unit_stats(SOLDIERS).defense == 2, "Soldiers");
    CHECK(unit_stats(ARTILLERY).attack == 7 && unit_stats(ARTILLERY).defense == 5, "Artillery");
    CHECK(unit_stats(MAN_O_WAR).attack == 24 && unit_stats(MAN_O_WAR).defense == 24, "Man-O-War");
    CHECK(unit_stats(COLONISTS).attack == 0 && unit_stats(COLONISTS).defense == 1, "Colonists");
}

static void test_combat() {
    std::printf("land combat:\n");
    CHECK(combat_odds(2, 2) == 0.5, "Soldiers v Soldiers = 50%%");
    CHECK(combat_odds(2, 6) == 0.25, "vs def 6 = 25%%");
    CHECK(terrain_defense_value(28) == 4 && terrain_defense_value(27) == 6, "hills/mountains");
    CHECK(terrain_defense_value(15) == 3 && terrain_defense_value(23) == 3 &&
          terrain_defense_value(10) == 2, "rain (canon 15 & raw 23) / forest");
    CHECK(difficulty_bonus(0) == 4 && difficulty_bonus(4) == 0, "handicap");
    // demotion ladder
    CHECK(demote(SOLDIERS, 0) == COLONISTS, "Soldiers->Colonists");
    CHECK(demote(DRAGOONS, 0) == SOLDIERS, "Dragoons->Soldiers");
    CHECK(demote(CAVALRY, 0) == REGULARS, "Cavalry->Regulars");
    CHECK(demote(REGULARS, 0) == -1, "Regulars destroyed");
    CHECK(demote(SOLDIERS, CLASS_MISSIONARY) == MISSIONARIES, "missionary override");
    CHECK(is_capturable(TREASURE) && is_capturable(WAGON_TRAIN) && !is_capturable(SOLDIERS), "capture set");

    Unit atk; atk.type = SOLDIERS;
    Unit def; def.type = SOLDIERS;
    auto win  = [](int, int) { return 1; };       // roll 1 <= atk 2 -> attacker wins
    auto lose = [](int, int hi) { return hi; };   // roll = max -> defender wins
    CombatResult r = resolve_land(atk, def, /*td*/0, /*fort*/0, /*diff*/4, false, false, win);
    CHECK(r.attacker_won && r.loser_outcome == COLONISTS && !r.captured, "win -> defender demoted");
    r = resolve_land(atk, def, 0, 0, 4, false, false, lose);
    CHECK(!r.attacker_won && r.loser_outcome == COLONISTS, "loss -> attacker demoted");
    // terrain + human handicap fold into strengths
    r = resolve_land(atk, def, /*td hills*/4, 0, /*diff*/0, /*atkH*/true, /*defH*/false, win);
    CHECK(r.atk_str == 6 && r.def_str == 6, "str atk %d def %d", r.atk_str, r.def_str);
    // capture a Treasure
    Unit treasure; treasure.type = TREASURE;
    r = resolve_land(atk, treasure, 0, 0, 4, false, false, win);
    CHECK(r.attacker_won && r.captured && r.loser_outcome == TREASURE, "treasure captured");
}

// --- RuleData seam: the modded-data invariant suite (seed). Proves the sim reads
// its balance numbers from an injected RuleData and that the default is the
// value-identical historical table. ---
static void test_rules() {
    std::printf("RuleData seam (data-driven stats):\n");
    const RuleData& def = default_rules();

    // (a) default ruleset is value-identical to the historical literals.
    CHECK(def.units[SOLDIERS].attack == 2 && def.units[SOLDIERS].defense == 2, "default Soldiers");
    CHECK(def.units[MAN_O_WAR].attack == 24 && def.units[MAN_O_WAR].defense == 24, "default Man-O-War");
    CHECK(def.units[ARTILLERY].cargo == 0 && def.units[GALLEON].cargo == 6, "default cargo");
    CHECK(def.terrain_defense[27] == 6 && def.terrain_defense[28] == 4 &&
          def.terrain_defense[15] == 3 && def.terrain_defense[10] == 2, "default terrain defense");
    // free-function fallbacks read the default ruleset.
    CHECK(unit_stats(SOLDIERS).attack == 2 && terrain_defense_value(27) == 6, "fallbacks == default");

    // (b) a modded ruleset changes sim output; the shared default is untouched.
    RuleData mod = make_default_rules();
    mod.units[SOLDIERS].attack = 4;          // buff Soldiers
    mod.terrain_defense[28]   = 9;           // buff Hills
    CHECK(unit_stats(mod, SOLDIERS).attack == 4, "modded unit_stats");
    CHECK(terrain_defense_value(mod, 28) == 9, "modded terrain_defense");
    CHECK(unit_stats(SOLDIERS).attack == 2 && terrain_defense_value(28) == 4,
          "default isolated from mod");

    // (c) the mod flows through combat strength resolution.
    Unit atk; atk.type = SOLDIERS;
    Unit def_u; def_u.type = SOLDIERS;
    auto win = [](int, int) { return 1; };
    CombatResult r = resolve_land(mod, atk, def_u, /*td*/0, 0, /*diff*/4, false, false, win);
    CHECK(r.atk_str == 4, "modded attack folds into combat -> %d", r.atk_str);
    r = resolve_land(atk, def_u, 0, 0, 4, false, false, win);
    CHECK(r.atk_str == 2, "default combat unchanged -> %d", r.atk_str);
}

static void test_natives() {
    std::printf("natives:\n");
    CHECK(mission_threshold(1, false) == 3, "level1 threshold 3");
    CHECK(mission_converts(2, 1, false) && !mission_converts(3, 1, false), "roll gate");
    CHECK(mission_threshold(1, true) == 6, "jesuit doubles");
    CHECK(apply_tension(50, 100, false, false) == 100, "incite -> war");
    CHECK(apply_tension(10, 4, true, false) == 12, "french halves +4 -> +2");
    CHECK(native_trade_price(1, 10) == 55, "price floor 5d+50");
    CHECK(native_trade_price(0, 60) == 90, "price capped 90");
    CHECK(tribute_gold(100, 20) == 70, "tribute ceil 3w+10");
    CHECK(tribute_gold(5, 20) == 10, "tribute floor 10");
}

static void test_diplomacy() {
    std::printf("diplomacy:\n");
    Diplomacy d;
    declare_war(d, 0, 1);
    CHECK(at_war(d, 0, 1) && at_war(d, 1, 0), "war symmetric");
    sign_treaty(d, 0, 1, 100);
    CHECK(!at_war(d, 0, 1) && has_treaty(d, 0, 1), "treaty ends war");
    CHECK(d.cooldown[0] == 116, "cooldown turn+16 -> %d", d.cooldown[0]);
    CHECK(ai_grace(3) == 70, "grace 10*(10-diff)");
    auto rng1 = [](int, int) { return 1; };
    CHECK(!ai_acts(80, 15, rng1), "restrained: (80>>2=20)>15, >12, rng!=0");
    CHECK(ai_acts(40, 15, rng1), "acts: 10 not > 15");
}

static void test_founding_fathers() {
    std::printf("founding fathers:\n");
    CHECK(ff_cost(1, 1599, 1, true, false) == 129, "human Explorer ff1 -> %d",
          ff_cost(1, 1599, 1, true, false));
    CHECK(ff_cost(2, 1500, 0, true, true) == 5000, "post-indep override d2");
    CHECK(ff_era_band(1599) == 0 && ff_era_band(1650) == 1 && ff_era_band(1700) == 2, "era bands");
    // Offerable = un-acquired only (no intra-category ordering, per spec audit 2026-06-23).
    CHECK(ff_available(0u, 0), "father0 available (un-acquired)");
    CHECK(ff_available(0u, 1), "father1 available (un-acquired; no intra-category gate)");
    CHECK(!ff_available(1u, 0), "father0 not offerable once owned");
}

static void test_revolution() {
    std::printf("revolution:\n");
    CHECK(can_declare_independence(50) && !can_declare_independence(49), "SoL>=50 gate");
    CHECK(ref_war_won(0, 0, false) && !ref_war_won(1, 0, false), "REF < 1 -> win");
    CHECK(ref_war_won(7, 0, true) && !ref_war_won(8, 0, true), "hard flag threshold 8");
    CHECK(!ref_war_won(0, 5, false), "intervention blocks win");
    CHECK(revolution_bonus(1700) == 160 && revolution_bonus(1776) == 8, "bonus (1780-y)*2");
    CHECK(revolution_bonus(1780) == 0, "no bonus from 1780");
}

static void test_scoring() {
    std::printf("scoring:\n");
    CHECK(score_difficulty_mult(0) == 4 && score_difficulty_mult(2) == 6 &&
          score_difficulty_mult(3) == 8 && score_difficulty_mult(4) == 10, "mult {4,5,6,8,10}");
    CHECK(score_population_component(0x1C) == 2, "free colonist +2");
    CHECK(score_population_component(0x19) == 1, "criminal +1");
    CHECK(score_population_component(0x10) == 4, "skilled +4");
    CHECK(score_rank(100) == 17, "rank(100) -> %d", score_rank(100));
}

static void test_mapgen() {
    std::printf("map generation:\n");
    CHECK(MAP_W == 58 && MAP_H == 72, "dims 58x72");
    CHECK(climate_base_terrain(0, false) == 5, "north band0 -> Savannah(5)");
    CHECK(climate_base_terrain(3, true) == 4, "south band3 -> Grassland(4)");
    CHECK(climate_base_terrain(2, false) == 1, "north band2 -> Desert(1)");
}

int main() {
    test_cadence();
    test_sol();
    test_production();
    test_warehouse();
    test_build();
    test_price_drift();
    test_ref();
    test_food_growth();
    test_immigration();
    test_turn_loop();
    test_units();
    test_combat();
    test_rules();
    test_natives();
    test_diplomacy();
    test_founding_fathers();
    test_revolution();
    test_scoring();
    test_mapgen();
    if (failures == 0) { std::printf("\nALL SIM TESTS PASSED\n"); return 0; }
    std::printf("\n%d FAILURE(S)\n", failures);
    return 1;
}
