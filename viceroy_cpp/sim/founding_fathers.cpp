// sim/founding_fathers.cpp -- see founding_fathers.hpp.
#include "founding_fathers.hpp"
#include <initializer_list>

namespace vc::sim {

int ff_cost(int difficulty, int year, int ff_count, bool human, bool post_independence) {
    if (post_independence) return difficulty * 1500 + 2000;
    int cost = human ? (difficulty + 3) * 16 : (14 - difficulty) * 8;
    for (int gate : {1600, 1650, 1700, 1750})
        if (year >= gate) cost += cost >> 1;       // x1.5 compounding
    cost = (ff_count + 1) * cost + 1;
    if (ff_count == 0) cost >>= 1;                  // first father half price
    return cost;
}

int ff_era_band(int year) {
    if (year < 1600) return 0;
    if (year < 1700) return 1;
    return 2;
}

bool ff_available(uint32_t owned_bits, int ff_id, const int* category, int nfathers) {
    if (owned_bits & (1u << ff_id)) return false;           // already owned
    int cat = category[ff_id];
    for (int i = 0; i < nfathers; ++i)                      // lower-index same cat owned?
        if (category[i] == cat && i < ff_id && !(owned_bits & (1u << i)))
            return false;
    return true;
}

} // namespace vc::sim
