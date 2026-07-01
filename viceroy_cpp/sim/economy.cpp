// sim/economy.cpp -- see economy.hpp.
#include "economy.hpp"

namespace vc::sim {

int warehouse_cap(const Colony& c, const RuleData& rd) {
    return (c.warehouse_lvl + 1) * rd.cfg.warehouse_cap_base;
}

int sol_pct(const Colony& c) {
    if (c.rebel_B <= 0) return 0;
    int p = (int)((int64_t)c.rebel_A * 100 / c.rebel_B);
    return p > 100 ? 100 : p;
}

void sol_update(Colony& c, int bells_this_turn, int population, const RuleData& rd) {
    const Config& cfg = rd.cfg;
    // divisor B: decay 1/64, floor 1, inflow mult*pop
    c.rebel_B -= c.rebel_B >> cfg.sol_decay_shift;
    if (c.rebel_B < 1) c.rebel_B = 1;
    c.rebel_B += cfg.sol_inflow_mult * population;
    // dividend A: decay 1/64, add bells, clamp [0, B]
    c.rebel_A += bells_this_turn - (c.rebel_A >> cfg.sol_decay_shift);
    if (c.rebel_A < 0) c.rebel_A = 0;
    if (c.rebel_A > c.rebel_B) c.rebel_A = c.rebel_B;
}

int tory_expert_adjust(int base_yield, int population, int sol_percent,
                       int difficulty, bool human, bool expert, int good,
                       const RuleData& rd) {
    const Config& cfg = rd.cfg;
    int y = base_yield;
    if (y <= 0) return 0;
    int tory = (population * (100 - sol_percent) + 50) / 100;   // round
    int div  = human ? (cfg.tory_divisor_base - difficulty) : cfg.tory_divisor_base;
    if (div < 1) div = 1;
    y -= tory / div;                                            // truncated
    if (expert) {
        if (good_is_era(good)) y += cfg.expert_era_bonus;
        else                   y *= cfg.expert_mfg_mult;
    }
    return y < 0 ? 0 : y;
}

void colony_economic_step(Colony& c, int difficulty, const RuleData& rd) {
    (void)difficulty;                          // tile-yield difficulty applies upstream
    const Config& cfg = rd.cfg;
    sol_update(c, c.bells_per_turn, c.population, rd);
    build_step(c, c.hammers_per_turn, c.build_cost);
    // HALF the food surplus accrues toward growth (ceil(surplus/2), spec @0xA606); food_per_turn is
    // the already-netted surplus (produced - 2*pop, >=0).
    if (c.food_per_turn > 0) c.food_accum += (uint32_t)((c.food_per_turn + 1) / 2);
    // Growth threshold is 25 with a Stable (building 0x11 = 17) present, else 50 (spec colony.md
    // func_00A3E1 @0xA5BB/@0xA5CD -- corrected from the mis-attributed 200).
    uint32_t threshold = (c.built_mask & (1ull << 17)) ? (uint32_t)cfg.food_growth_threshold_stable
                                                       : (uint32_t)cfg.food_growth_threshold;
    if (c.food_accum >= threshold && c.population < cfg.max_population) {
        c.population += 1;
        c.food_accum -= threshold;             // surplus carried
        c.rebel_B += cfg.sol_birth_bonus;      // SoL divisor bump on birth (colony.md:211, @0x009453, B)
    }
    // Surface the food-growth store (+0xAA) as the colony's warehouse Food (+0x9A[0]) so stored food
    // is visible and drawn down on a birth -- the same accumulator, just shown in the warehouse row.
    c.stockpile[FOOD] = (int32_t)c.food_accum;
}

long export_overflow(Colony& c, Power& owner, const std::array<int32_t, NGOODS>& price,
                     int tax_pct, bool independence) {
    long gained = 0;
    for (int g = 1; g < NGOODS; ++g) {              // Food(0) drives colony growth, never auto-sold
        if (c.stockpile[g] < 100) continue;         // flat 0x64 threshold (func_02D658 @0x2D6F7)
        int excess = c.stockpile[g] - 50;           // keep the lower band 0x32=50 (@0x2D70B)
        c.stockpile[g] = 50;
        if (independence) continue;                 // [0x5382]&1: no Crown market in rebellion -> wasted
        long net = (long)excess * price[g] * (100 - tax_pct) / 100;   // taxed sale (price-weighted, RECONSTRUCTED)
        if (net < 0) net = 0;
        owner.gold += net; gained += net;           // score_add_money @0x2D785
    }
    return gained;
}

bool build_step(Colony& c, int hammers_produced, int build_cost) {
    if (hammers_produced > 0) {
        c.hammers_accum += (uint32_t)hammers_produced;
        c.build_bank    += (uint32_t)hammers_produced;
    }
    if (c.build_target < 0) return false;
    if ((uint32_t)build_cost <= c.hammers_accum &&
        (uint32_t)build_cost <= c.build_bank) {
        c.build_bank -= (uint32_t)build_cost;          // surplus carried
        c.built_mask |= (1ull << c.build_target);
        return true;
    }
    return false;
}

bool start_building(Colony& c, int building_id, int build_cost, int min_colony) {
    if (building_id < 0 || building_id >= 48) return false;
    if (c.population < min_colony) return false;                 // colony too small
    if (c.built_mask & (1ull << building_id)) return false;      // already built
    c.build_target = building_id;
    c.build_cost   = build_cost;
    return true;
}

bool rush_build(Colony& c, Power& owner, long gold_cost) {
    if (c.build_target < 0) return false;
    if (gold_cost < 0 || owner.gold < gold_cost) return false;   // can't afford
    owner.gold -= gold_cost;
    c.built_mask |= (1ull << c.build_target);
    c.build_bank = 0;
    c.build_target = -1;                                         // project done
    return true;
}

} // namespace vc::sim
