// sim/economy.cpp -- see economy.hpp.
#include "economy.hpp"

namespace vc::sim {

int warehouse_cap(const Colony& c) {
    return (c.warehouse_lvl + 1) * 100;
}

int sol_pct(const Colony& c) {
    if (c.rebel_B <= 0) return 0;
    int p = (int)((int64_t)c.rebel_A * 100 / c.rebel_B);
    return p > 100 ? 100 : p;
}

void sol_update(Colony& c, int bells_this_turn, int population) {
    // divisor B: decay 1/64, floor 1, inflow 2*pop
    c.rebel_B -= c.rebel_B >> 6;
    if (c.rebel_B < 1) c.rebel_B = 1;
    c.rebel_B += 2 * population;
    // dividend A: decay 1/64, add bells, clamp [0, B]
    c.rebel_A += bells_this_turn - (c.rebel_A >> 6);
    if (c.rebel_A < 0) c.rebel_A = 0;
    if (c.rebel_A > c.rebel_B) c.rebel_A = c.rebel_B;
}

int tory_expert_adjust(int base_yield, int population, int sol_percent,
                       int difficulty, bool human, bool expert, int good) {
    int y = base_yield;
    if (y <= 0) return 0;
    int tory = (population * (100 - sol_percent) + 50) / 100;   // round
    int div  = human ? (10 - difficulty) : 10;
    if (div < 1) div = 1;
    y -= tory / div;                                            // truncated
    if (expert) {
        if (good_is_era(good)) y += 2;
        else                   y *= 2;
    }
    return y < 0 ? 0 : y;
}

void colony_economic_step(Colony& c, int difficulty) {
    (void)difficulty;                          // tile-yield difficulty applies upstream
    sol_update(c, c.bells_per_turn, c.population);
    build_step(c, c.hammers_per_turn, c.build_cost);
    if (c.food_per_turn > 0) c.food_accum += (uint32_t)c.food_per_turn;
    if (c.food_accum >= 200 && c.population < 32) {
        c.population += 1;
        c.food_accum -= 200;                   // surplus carried
        c.rebel_B += 100;                      // SoL divisor bump on birth (colony.md:211, @0x009453, B)
    }
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

} // namespace vc::sim
