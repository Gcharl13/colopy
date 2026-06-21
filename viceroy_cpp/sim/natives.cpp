// sim/natives.cpp -- see natives.hpp.
#include "natives.hpp"

namespace vc::sim {

int mission_threshold(int tribe_level, bool jesuit) {
    int t = tribe_level + 2;
    if (jesuit) t *= 2;
    return t;
}
bool mission_converts(int roll0to15, int tribe_level, bool jesuit) {
    return roll0to15 < mission_threshold(tribe_level, jesuit);
}
double mission_prob(int tribe_level, bool jesuit) {
    return mission_threshold(tribe_level, jesuit) / 15.0;
}

int apply_tension(int tension, int delta, bool french_power, bool pocahontas) {
    if (delta > 0) {
        if (french_power) delta /= 2;
        if (pocahontas)   delta /= 2;
    }
    int t = tension + delta;
    if (t < 0)   t = 0;
    if (t > 100) t = 100;
    return t;
}

int native_trade_price(int difficulty, int tax_pct) {
    int p = 5 * difficulty + 50;
    int o = 2 * tax_pct;
    if (o > p) p = o;
    if (p > 90) p = 90;
    return p;
}

int tribute_gold(int demand, int settlement_wealth) {
    int hi = 3 * settlement_wealth + 10;
    if (hi > 100) hi = 100;
    if (demand < 10) demand = 10;
    if (demand > hi) demand = hi;
    return demand;
}

} // namespace vc::sim
