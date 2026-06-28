// sim/market.cpp -- see market.hpp.
#include "market.hpp"

namespace vc::sim {

void price_drift(GameState& g) {
    for (int good = 0; good < NGOODS; ++good) {
        int64_t acc = g.price_base[good];
        for (int p = 0; p < 4; ++p) {
            int32_t v = g.powers[p].trade[good];
            if (v > 0) acc += v;                    // clamp negatives to 0
        }
        g.price_base[good] -= (int32_t)(acc >> 8);  // proportional decay /256
    }
}

} // namespace vc::sim
