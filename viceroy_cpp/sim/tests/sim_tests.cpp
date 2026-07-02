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
#include "../rules_invariants.hpp"
#include "../unit.hpp"
#include "../unit_turn.hpp"
#include "../combat.hpp"
#include "../natives.hpp"
#include "../diplomacy.hpp"
#include "../founding_fathers.hpp"
#include "../revolution.hpp"
#include "../scoring.hpp"
#include "../mapgen.hpp"
#include "../training.hpp"
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

static void test_export() {
    std::printf("auto-export over-cap goods (100->50):\n");
    std::array<int32_t, NGOODS> price{}; price[RUM] = 800; price[CIGARS] = 800;
    Colony c; c.owner_power = 0; c.stockpile[RUM] = 102; c.stockpile[CIGARS] = 130;
    c.stockpile[FOOD] = 300;                       // Food never auto-sold
    Power owner; owner.gold = 0;
    long g = export_overflow(c, owner, price, /*tax*/0, /*independence*/false);
    CHECK(c.stockpile[RUM] == 50 && c.stockpile[CIGARS] == 50, "over-100 cut to 50");
    CHECK(c.stockpile[FOOD] == 300, "Food exempt from export");
    CHECK(g == (52 + 80) * 800 && owner.gold == g, "excess sold @800 no tax -> %ld", g);
    // taxed: 60 excess @800 with 25% tax -> 60*800*75/100 = 36000
    Colony c2; c2.owner_power = 0; c2.stockpile[RUM] = 110; Power o2; o2.gold = 0;
    CHECK(export_overflow(c2, o2, price, 25, false) == 36000, "25%% tax reduces proceeds");
    // independence: goods still dumped to 50 but nothing credited
    Colony c3; c3.owner_power = 0; c3.stockpile[RUM] = 150; Power o3; o3.gold = 7;
    CHECK(export_overflow(c3, o3, price, 0, true) == 0 && c3.stockpile[RUM] == 50 && o3.gold == 7,
          "independence wastes the excess (no gold)");
}

static void test_build() {
    std::printf("hammers / build (cost 64):\n");
    Colony c; c.build_target = 0;
    CHECK(!build_step(c, 30, 64), "30 not done");
    CHECK(!build_step(c, 30, 64), "60 not done");
    CHECK(build_step(c, 10, 64), "70 completes");
    CHECK(c.build_bank == 6, "surplus carried -> %u", c.build_bank);
    CHECK((c.built_mask & 1ull) != 0, "built bit set");

    // start_building gates on colony size + already-built; rush_build pays gold to finish.
    Colony c2; c2.population = 2;
    CHECK(!start_building(c2, 1, 120, 3), "Fort refused at pop 2 (min 3)");
    c2.population = 4;
    CHECK(start_building(c2, 1, 120, 3), "Fort starts at pop 4");
    CHECK(c2.build_target == 1 && c2.build_cost == 120, "target/cost set");
    Power owner; owner.gold = 500;
    CHECK(!rush_build(c2, owner, 600), "rush refused when gold < cost");
    CHECK(rush_build(c2, owner, 300), "rush completes when affordable");
    CHECK(owner.gold == 200, "gold debited -> %lld", (long long)owner.gold);
    CHECK((c2.built_mask & (1ull << 1)) != 0 && c2.build_target == -1, "Fort built, target cleared");
    CHECK(!start_building(c2, 1, 120, 3), "Fort refused (already built)");
}

static void test_price_drift() {
    std::printf("price drift (base 800, player0 sells 100 Sugar):\n");
    GameState g;
    g.price_base[SUGAR] = 800;
    g.powers[0].trade[SUGAR] = 100;       // this turn's sell volume
    price_drift(g);
    CHECK(g.price_base[SUGAR] == 797, "turn1 -> %d", g.price_base[SUGAR]);
    price_drift(g);
    CHECK(g.price_base[SUGAR] == 794, "turn2 -> %d", g.price_base[SUGAR]);
}

static void test_score_game() {
    std::printf("score_game (scoring.md components + func_03A9C0 scaling):\n");
    // diff 1 (mult 5): pop 40 + FF 25 + sentiment 60 - razed 2*(1+1)=4 + gold 5 + bells 3
    //   + revolution (1780-1776)*2 = 8 -> base 137; (5*137)/100 = 6; >>1 = 3
    long s = score_game(1, 40, 5, 60, 2, 5000, 300, 1776, true);
    CHECK(s == 3, "score -> %ld", s);
    // post-intervention bells cap at 100 (20000/100 -> capped 100, same as 10000/100)
    long capped = score_game(1, 0, 0, 0, 0, 0, 20000, 0, false);
    long at_cap = score_game(1, 0, 0, 0, 0, 0, 10000, 0, false);
    CHECK(capped == at_cap, "bells/100 capped at 100");
}

static void test_market_model() {
    std::printf("market: published prices from the pooled supply (market.md):\n");
    const RuleData& rd = default_rules();
    GameState g; g.year = 1750;                 // no Furs year bumps
    for (int i = 0; i < NGOODS; ++i) g.price_base[i] = 800;   // equal supply everywhere
    market_recompute(g, rd);
    // S_pair = 4*800; Rum target = 3200*3/800 = 12 (inside its 1..20 band)
    CHECK(g.powers[0].price_level[RUM] == 12, "Rum level -> %d", g.powers[0].price_level[RUM]);
    CHECK(market_bid(g, 0, RUM) == 11, "Rum bid = level-1 -> %d", market_bid(g, 0, RUM));
    // ask = bid + burden + 1 (Rum burden 0 -> spread 1; Food burden 7 -> spread 8)
    CHECK(market_ask(g, 0, RUM, rd) == 12, "Rum ask -> %d", market_ask(g, 0, RUM, rd));
    g.powers[0].price_level[FOOD] = 3;
    CHECK(market_ask(g, 0, FOOD, rd) == 2 + 7 + 1, "Food ask = bid+burden+1 -> %d",
          market_ask(g, 0, FOOD, rd));
    // raw inputs clamp to their @CARGO band (Sugar target 12 clamps to hi=7)
    CHECK(g.powers[0].price_level[SUGAR] == 7, "Sugar level clamped -> %d",
          g.powers[0].price_level[SUGAR]);

    std::printf("market: selling floods the pool (Rum falls, other luxuries rise):\n");
    int rum_before = g.powers[0].price_level[RUM];
    int cig_before = g.powers[0].price_level[CIGARS];
    g.powers[0].tax = 10; g.powers[0].gold = 0; g.powers[0].royal_money = 0;
    long net = market_sell(g, 0, RUM, 300, rd);
    // gross = 11*300 = 3300; tax 10% = 330 -> net 2970, tax to the REF fund
    CHECK(net == 2970, "sell net (taxed) -> %ld", net);
    CHECK(g.powers[0].gold == 2970, "gold += net -> %lld", (long long)g.powers[0].gold);
    CHECK(g.powers[0].royal_money == 330, "tax -> royal_money (REF fund) -> %lld",
          (long long)g.powers[0].royal_money);
    CHECK(g.powers[0].trade[RUM] == 300, "SELL adds volume -> %d", g.powers[0].trade[RUM]);
    CHECK(g.powers[0].price_level[RUM] < rum_before, "Rum level fell -> %d",
          g.powers[0].price_level[RUM]);
    CHECK(g.powers[0].price_level[CIGARS] > cig_before, "Cigars level rose (pool) -> %d",
          g.powers[0].price_level[CIGARS]);

    std::printf("market: buying is untaxed; non-pool goods use the +/-1 steppers:\n");
    g.powers[0].gold = 1000; g.powers[0].royal_money = 0;
    g.powers[0].price_level[MUSKETS] = 10;
    long cost = market_buy(g, 0, MUSKETS, 5, rd);   // ask = 9+0+1 = 10 -> cost 50
    CHECK(cost == 50, "buy cost -> %ld", cost);
    CHECK(g.powers[0].gold == 950, "gold -= cost, untaxed -> %lld", (long long)g.powers[0].gold);
    CHECK(g.powers[0].royal_money == 0, "no tax on buys");
    CHECK(g.powers[0].price_level[MUSKETS] == 11, "buy steps a non-pool level +1 -> %d",
          g.powers[0].price_level[MUSKETS]);
    market_sell(g, 0, MUSKETS, 5, rd);
    CHECK(g.powers[0].price_level[MUSKETS] == 10, "sell steps it back -1 -> %d",
          g.powers[0].price_level[MUSKETS]);

    std::printf("market: the turn phase resets the per-turn volumes:\n");
    market_turn(g, rd);
    CHECK(g.powers[0].trade[RUM] == 0 && g.powers[0].trade[MUSKETS] == 0,
          "trade volumes zeroed at the turn boundary");
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
    std::printf("food -> population growth (USER RULING: 200 stored food -> +1 colonist, -200):\n");
    Colony c; c.population = 1; c.food_per_turn = 75;    // the full surplus banks in the warehouse
    colony_economic_step(c, 1); colony_economic_step(c, 1);
    CHECK(c.population == 1 && c.stockpile[FOOD] == 150, "after 2 -> pop %d food %d",
          c.population, c.stockpile[FOOD]);
    colony_economic_step(c, 1);                          // t3: 225 >= 200 -> grow, keep 25
    CHECK(c.population == 2 && c.stockpile[FOOD] == 25, "after 3 -> pop %d food %d",
          c.population, c.stockpile[FOOD]);
    // the SoL divisor gets the +100 birth bump (colony.md:211 @0x009453): 3 turns of
    // sol_update on pop 1 leave B=7, then the birth adds 100.
    CHECK(c.rebel_B == 107, "birth bumps rebel_B -> %d", c.rebel_B);
}

static void test_immigration() {
    std::printf("immigration (England, 3 workers, 0 units, diff 0):\n");
    CHECK(crosses_threshold(3, 0, 0, false, /*is_england*/true) == 9, "threshold -> %d",
          crosses_threshold(3, 0, 0, false, /*is_england*/true));
    Power p;
    auto rng = [](int, int) { return 1; };       // dock slot 1; refill roll 1 -> low tier -> criminal
    bool spawned = false;
    int turns = 0;
    for (; turns < 10 && !spawned; ++turns)       // 2 crosses/turn, England threshold 9
        spawned = immigration_step(p, 2, 3, 0, /*diff*/0, /*ai*/false, /*is_england*/true, rng).spawned;
    CHECK(turns == 5, "spawned on turn %d", turns);
    // rng==1 everywhere: refill roll 1 < threshold (0+8)/2=4 -> low tier; rng(1,10)=1 -> Petty Criminal
    CHECK(p.dock_pool[1] == 0x19 && p.crosses_accum == 0, "dock %d acc %d",
          p.dock_pool[1], p.crosses_accum);
    // the func_034C24 distribution: high tier is Servant, Free Colonist with Brewster
    auto hi = [](int lo, int) { return lo == 1 ? 15 : 5; };   // roll 15 -> high tier
    CHECK(immigrant_refill(0, false, hi) == 0x1A, "high tier -> Indentured Servant");
    CHECK(immigrant_refill(0, true,  hi) == 0x1C, "Brewster high tier -> Free Colonist");
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

    // fortified defender: +50% DEF (Soldiers def 2 -> 3).
    r = resolve_land(default_rules(), atk, def, 0, 0, 4, false, false, win, /*fortified*/true);
    CHECK(r.def_str == 3, "fortified Soldiers def 2 -> %d (expect 3)", r.def_str);
    r = resolve_land(default_rules(), atk, def, 0, 0, 4, false, false, win, /*fortified*/false);
    CHECK(r.def_str == 2, "unfortified Soldiers def -> %d (expect 2)", r.def_str);
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

// --- the unit/turn spine: movement, orders, combat-on-contact ---
static void test_unit_turn() {
    std::printf("unit/turn spine (movement + orders + combat):\n");
    auto win = [](int, int) { return 1; };          // roll 1 -> attacker wins
    auto mk = [](int type, int owner, int x, int y) {
        Unit u; u.type = type; u.owner = owner; u.x = x; u.y = y; return u;
    };

    // movement: Dragoons (4 moves) step 4 tiles toward a far target, not arrived.
    {
        World w; w.map_w = 20; w.map_h = 20;
        Unit d = mk(DRAGOONS, 0, 0, 0);
        d.order = ORDER_GOTO; d.target_x = 10; d.target_y = 0;
        w.units.push_back(d);
        GameState g; g.difficulty = 4;
        refresh_moves(w); apply_orders(g, w, win);
        CHECK(w.units[0].x == 4 && w.units[0].y == 0, "dragoons at %d,%d", w.units[0].x, w.units[0].y);
        CHECK(w.units[0].moves_left == 0 && w.units[0].order == ORDER_GOTO, "moves spent, still en route");
    }
    // arrival clears the order; leftover moves remain.
    {
        World w; w.map_w = 20; w.map_h = 20;
        Unit s = mk(SCOUTS, 0, 0, 0);
        s.order = ORDER_GOTO; s.target_x = 3; s.target_y = 0;
        w.units.push_back(s);
        GameState g; g.difficulty = 4;
        refresh_moves(w); apply_orders(g, w, win);
        CHECK(w.units[0].x == 3 && w.units[0].order == ORDER_NONE, "scout arrived, order cleared");
        CHECK(w.units[0].moves_left == 1, "leftover moves -> %d", w.units[0].moves_left);
    }
    // combat: win vs Soldiers -> demoted in place; attacker does NOT advance.
    {
        World w; w.map_w = 20; w.map_h = 20;
        Unit a = mk(SOLDIERS, 0, 0, 0); a.order = ORDER_GOTO; a.target_x = 1; a.target_y = 0;
        w.units.push_back(a);
        w.units.push_back(mk(SOLDIERS, 1, 1, 0));
        GameState g; g.difficulty = 4;
        refresh_moves(w); apply_orders(g, w, win);
        CHECK(w.units[1].type == COLONISTS && w.units[1].alive, "defender demoted to colonist");
        CHECK(w.units[0].x == 0 && w.units[0].moves_left == 0, "attacker held, move spent");
    }
    // combat: win vs Regulars -> destroyed; attacker advances into the tile.
    {
        World w; w.map_w = 20; w.map_h = 20;
        Unit a = mk(SOLDIERS, 0, 0, 0); a.order = ORDER_GOTO; a.target_x = 1; a.target_y = 0;
        w.units.push_back(a);
        w.units.push_back(mk(REGULARS, 1, 1, 0));
        GameState g; g.difficulty = 4;
        refresh_moves(w); apply_orders(g, w, win);
        CHECK(!w.units[1].alive, "regular destroyed");
        CHECK(w.units[0].x == 1 && w.units[0].y == 0, "attacker advanced to vacated tile");
    }
    // combat: win vs Treasure -> captured (changes hands); attacker holds.
    {
        World w; w.map_w = 20; w.map_h = 20;
        Unit a = mk(SOLDIERS, 0, 0, 0); a.order = ORDER_GOTO; a.target_x = 1; a.target_y = 0;
        w.units.push_back(a);
        w.units.push_back(mk(TREASURE, 1, 1, 0));
        GameState g; g.difficulty = 4;
        refresh_moves(w); apply_orders(g, w, win);
        CHECK(w.units[1].owner == 0 && w.units[1].alive && w.units[1].type == TREASURE, "treasure captured");
        CHECK(w.units[0].x == 0, "attacker held after capture");
    }
    // friendly occupant blocks (no stacking, no combat).
    {
        World w; w.map_w = 20; w.map_h = 20;
        Unit a = mk(SOLDIERS, 0, 0, 0); a.order = ORDER_GOTO; a.target_x = 1; a.target_y = 0;
        w.units.push_back(a);
        w.units.push_back(mk(SOLDIERS, 0, 1, 0));   // same owner
        GameState g; g.difficulty = 4;
        refresh_moves(w); apply_orders(g, w, win);
        CHECK(w.units[0].x == 0 && w.units[1].type == SOLDIERS, "blocked by friendly, no combat");
    }
    // integration: step_turn refreshes + moves the unit.
    {
        World w; w.map_w = 20; w.map_h = 20;
        Unit d = mk(DRAGOONS, 0, 0, 0); d.order = ORDER_GOTO; d.target_x = 9; d.target_y = 0;
        w.units.push_back(d);
        GameState g; g.difficulty = 4;
        auto rng = [](int, int) { return 0; };
        step_turn(g, w, rng);
        CHECK(w.units[0].x == 4, "step_turn moved dragoons to x=%d", w.units[0].x);
    }

    // --- terrain-aware movement (entry cost + land/naval passability) ---
    GameState g; g.difficulty = 4;
    auto make_terrain = [](World& w, int fill) {
        w.terrain.assign((size_t)w.map_w * w.map_h, (uint8_t)fill);
    };
    // Hills (id 28, cost 2): Dragoons (4 moves) cross only 2 tiles.
    {
        World w; w.map_w = 12; w.map_h = 3; make_terrain(w, 28);
        Unit d = mk(DRAGOONS, 0, 0, 1); d.order = ORDER_GOTO; d.target_x = 10; d.target_y = 1;
        w.units.push_back(d);
        refresh_moves(w); apply_orders(g, w, win);
        CHECK(w.units[0].x == 2, "dragoons over hills -> x=%d (expect 2)", w.units[0].x);
    }
    // Plains (cost 1): same Dragoons cross 4 tiles.
    {
        World w; w.map_w = 12; w.map_h = 3; make_terrain(w, /*Plains*/2);
        Unit d = mk(DRAGOONS, 0, 0, 1); d.order = ORDER_GOTO; d.target_x = 10; d.target_y = 1;
        w.units.push_back(d);
        refresh_moves(w); apply_orders(g, w, win);
        CHECK(w.units[0].x == 4, "dragoons over plains -> x=%d (expect 4)", w.units[0].x);
    }
    // "always move one tile": a 1-move Colonist still enters cost-3 Mountains (id 27).
    {
        World w; w.map_w = 6; w.map_h = 3; make_terrain(w, /*Mountains*/27);
        Unit c = mk(COLONISTS, 0, 0, 1); c.order = ORDER_GOTO; c.target_x = 5; c.target_y = 1;
        w.units.push_back(c);
        refresh_moves(w); apply_orders(g, w, win);
        CHECK(w.units[0].x == 1 && w.units[0].moves_left == 0, "colonist 1 step into mountains");
    }
    // passability: a land unit cannot enter Ocean (id 25).
    {
        World w; w.map_w = 6; w.map_h = 3; make_terrain(w, /*Plains*/2);
        for (int y = 0; y < 3; ++y) w.terrain[(size_t)y * w.map_w + 1] = 25;   // column x=1 Ocean
        Unit s = mk(SOLDIERS, 0, 0, 1); s.order = ORDER_GOTO; s.target_x = 5; s.target_y = 1;
        w.units.push_back(s);
        refresh_moves(w); apply_orders(g, w, win);
        CHECK(w.units[0].x == 0, "land unit blocked by ocean at x=1 -> x=%d", w.units[0].x);
    }
    // obstacle routing: an ocean wall at x=2 with a one-tile gap at the bottom row;
    // the unit must route around through the gap to reach the far side.
    {
        World w; w.map_w = 6; w.map_h = 4; make_terrain(w, /*Plains*/2);
        for (int y = 0; y < 3; ++y) w.terrain[(size_t)y * w.map_w + 2] = 25;    // wall x=2, rows 0..2
        // (2,3) stays Plains -> the gap.
        Unit d = mk(DRAGOONS, 0, 0, 1); d.order = ORDER_GOTO; d.target_x = 5; d.target_y = 1;
        w.units.push_back(d);
        bool reached = false;
        for (int turn = 0; turn < 12 && !reached; ++turn) {
            refresh_moves(w); apply_orders(g, w, win);
            reached = (w.units[0].x == 5 && w.units[0].y == 1);
        }
        CHECK(reached && w.units[0].order == ORDER_NONE, "routed around wall to target (%d,%d)",
              w.units[0].x, w.units[0].y);
    }
}

// --- multi-power turn: every power's economy + Europe immigration advances ---
static void test_multipower() {
    std::printf("multi-power turn (economy + immigration for all powers):\n");
    GameState g; g.difficulty = 1;
    World w;
    Colony c0; c0.owner_power = 0; c0.population = 3; c0.crosses_output = 3; c0.food_per_turn = 60;
    Colony c1; c1.owner_power = 1; c1.population = 3; c1.crosses_output = 3; c1.food_per_turn = 60;
    w.colonies.push_back(c0); w.colonies.push_back(c1);
    auto rng = [](int, int) { return 1; };           // dock slot 1
    for (int i = 0; i < 5; ++i) step_turn(g, w, rng, /*player*/0);

    // economy runs for both powers' colonies (food -> growth).
    CHECK(w.colonies[0].population > 3 && w.colonies[1].population > 3,
          "both colonies grew -> %d / %d", w.colonies[0].population, w.colonies[1].population);
    // immigration advanced for both powers' Europe docks.
    auto spawned = [](const Power& p) {
        for (int s = 0; s < 3; ++s) if (p.dock_pool[s] != -1) return true;
        return false;
    };
    CHECK(spawned(g.powers[0]) && spawned(g.powers[1]), "both powers received immigrants");
    // human (England, power 0) and AI (power 1) get different thresholds.
    CHECK(g.powers[0].crosses_threshold != g.powers[1].crosses_threshold,
          "human %d vs AI %d threshold", g.powers[0].crosses_threshold, g.powers[1].crosses_threshold);
}

// --- modded-data invariant suite: cfg scalars are injected, and check_rules()
// guards arbitrary rulesets. ---
static void test_rules_invariants() {
    std::printf("RuleData config + invariants:\n");

    // default ruleset is valid.
    CHECK(check_rules(default_rules()).ok(), "default ruleset valid -> %zu violations",
          check_rules(default_rules()).violations.size());

    // cfg scalars flow into the sim: bump REF accrual and warehouse cap.
    RuleData mod = make_default_rules();
    mod.cfg.warehouse_cap_base = 150;
    mod.cfg.ref_accrue_offset  = 20;          // base rate 8d+20 instead of 8d+10
    Colony wc; wc.warehouse_lvl = 1;
    CHECK(warehouse_cap(wc, mod) == 300 && warehouse_cap(wc) == 200,
          "modded warehouse cap %d (default %d)", warehouse_cap(wc, mod), warehouse_cap(wc));
    CHECK(ref_accrue_rate(1, 1492, mod) == 28 && ref_accrue_rate(1, 1492) == 18,
          "modded accrue %d (default %d)", ref_accrue_rate(1, 1492, mod), ref_accrue_rate(1, 1492));
    CHECK(check_rules(mod).ok(), "valid mod passes invariants");

    // a full turn under the modded ruleset uses the modded REF rate.
    GameState g; g.difficulty = 1;
    World w; Colony c; c.owner_power = 0; c.population = 3; w.colonies.push_back(c);
    auto rng = [](int, int) { return 0; };
    for (int i = 0; i < 8; ++i) step_turn(g, w, rng, 0, mod);
    CHECK(g.powers[0].royal_money == 224, "modded REF accrued 28*8 -> %lld",
          (long long)g.powers[0].royal_money);

    // broken rulesets fail the right invariants.
    RuleData bad = make_default_rules();
    bad.cfg.tory_divisor_base = 0;            // divide-by-zero risk
    bad.cfg.sol_decay_shift   = 40;           // UB-range shift
    bad.cfg.ff_gate_years     = {1700, 1600, 1650, 1750};   // not ascending
    bad.units[1].move_class   = 7;            // not a valid class
    InvariantReport rep = check_rules(bad);
    CHECK(!rep.ok() && rep.violations.size() >= 4, "broken ruleset -> %zu violations",
          rep.violations.size());
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

// spec/systems/training.md 3: school teaching (func_02D658). Tier gate by school level,
// turns-to-graduate 4/6/8 by @JOB tier, faculty cap = level, graduate learns the profession.
static void test_training() {
    std::printf("school teaching:\n");
    const RuleData& rd = default_rules();
    CHECK(rd.jobs[0].school_tier == 1 && rd.jobs[17].school_tier == 3 && rd.jobs[18].school_tier == 4,
          "@JOB tiers: Farmer 1, Statesman 3, Teacher 4 (not taught)");
    RandFn first = [](int lo, int) { return lo; };   // deterministic: always pick student 0
    Colony c;
    c.built_mask = 1ull << 12;                       // Schoolhouse (0x0C)
    CHECK(school_level(c) == 1, "schoolhouse = level 1");
    Colony::Worker teacher; teacher.profession = 0; teacher.expert = true; teacher.tile = -1;  // Expert Farmer
    Colony::Worker student; student.profession = 19; student.expert = false; student.tile = 0;
    c.workers = {teacher, student};
    for (int t = 0; t < 3; ++t) school_teach_step(c, rd, first);
    CHECK(!c.workers[1].expert && c.workers[1].teach == 3, "3 turns in: still a student (needs 4)");
    school_teach_step(c, rd, first);
    CHECK(c.workers[1].expert && c.workers[1].profession == 0 && c.workers[1].teach == 0,
          "4th turn: graduates as Expert Farmer, counter reset");
    // tier gate: a Schoolhouse (level 1) cannot teach a tier-3 Elder Statesman
    Colony c2; c2.built_mask = 1ull << 12;
    Colony::Worker states; states.profession = 17; states.expert = true; states.tile = -1;
    Colony::Worker stud2; stud2.profession = 19; stud2.expert = false; stud2.tile = 0;
    c2.workers = {states, stud2};
    for (int t = 0; t < 12; ++t) school_teach_step(c2, rd, first);
    CHECK(!c2.workers[1].expert && c2.workers[1].teach == 0, "schoolhouse cannot teach a tier-3 skill");
    // University teaches it in 8 turns
    c2.built_mask |= 1ull << 14;                     // University (0x0E)
    CHECK(school_level(c2) == 3, "university = level 3");
    for (int t = 0; t < 8; ++t) school_teach_step(c2, rd, first);
    CHECK(c2.workers[1].expert && c2.workers[1].profession == 17, "university graduates an Elder Statesman in 8");
}

// training.md 3: native learning ("live among the Indians") + combat veterancy.
static void test_native_learn_and_veterancy() {
    std::printf("native learning + veterancy:\n");
    RandFn hi = [](int, int h) { return h; };     // max roll: learn succeeds, promo roll fails gate
    RandFn lo = [](int l, int) { return l; };     // min roll: learn fails, promo roll passes
    int cls = 0x1C; bool taught = false;          // a Free Colonist at a Fur Trapper village
    CHECK(native_learn(cls, 4, taught, 0, hi) == LearnResult::LEARNED && cls == 4 && taught,
          "free colonist learns Fur Trapper; village latched");
    int c1 = 0x1C;
    CHECK(native_learn(c1, 4, taught, 0, hi) == LearnResult::REFUSED_TAUGHT, "each village teaches once");
    int crim = 0x19; bool t2 = false;
    CHECK(native_learn(crim, 4, t2, 0, hi) == LearnResult::REFUSED_CRIMINAL, "criminals refused");
    int master = 4; bool t3 = false;
    CHECK(native_learn(master, 0, t3, 0, hi) == LearnResult::REFUSED_MASTER, "masters refused");
    int c2 = 0x1C; bool t4 = false;               // roll 1 < 200*0+100: the unskilled stay
    CHECK(native_learn(c2, 4, t4, 0, lo) == LearnResult::STAYED && c2 == 0x1C, "failed roll: stays");
    CHECK(native_learnable(4) && !native_learnable(13), "Fur Trapper learnable, Carpenter not");
    // Veterancy: Washington skips the roll; the stamp precedes the type-ceiling advance.
    int type = 1, prof = 0x1C;
    CHECK(promote_on_win(type, prof, 5, 10, true, hi) && prof == 0x15 && type == 1,
          "Washington: winning soldier stamped Veteran");
    CHECK(promote_on_win(type, prof, 5, 10, true, hi) && type == 9,
          "veteran soldier advances to Continental Army");
    int t5 = 1, p5 = 0x1C;
    RandFn ten = [](int, int) { return 10; };     // roll 10 > winner strength 5
    CHECK(!promote_on_win(t5, p5, 5, 10, false, ten) && p5 == 0x1C, "lost roll: no promotion");
    int t6 = 4, p6 = 0x15;                        // veteran Dragoons at the ceiling
    CHECK(promote_on_win(t6, p6, 5, 10, false, lo) && t6 == 7, "veteran dragoons -> Continental Cavalry");
}

int main() {
    test_cadence();
    test_sol();
    test_production();
    test_warehouse();
    test_export();
    test_build();
    test_price_drift();
    test_market_model();
    test_score_game();
    test_ref();
    test_food_growth();
    test_immigration();
    test_turn_loop();
    test_units();
    test_combat();
    test_unit_turn();
    test_multipower();
    test_rules();
    test_rules_invariants();
    test_natives();
    test_diplomacy();
    test_founding_fathers();
    test_revolution();
    test_scoring();
    test_mapgen();
    test_training();
    test_native_learn_and_veterancy();
    if (failures == 0) { std::printf("\nALL SIM TESTS PASSED\n"); return 0; }
    std::printf("\n%d FAILURE(S)\n", failures);
    return 1;
}
