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

bool ff_available(uint32_t owned_bits, int ff_id) {
    // Offerable set is byte-verified as simply "un-acquired": the next father is a
    // weighted random over ALL un-owned fathers (founding_fathers.md §71-79 / :220,
    // func_03BFD2 @0x03C035/@0x03C0C4). There is NO intra-category ordering gate --
    // a prior version invented a "lower-index same-category must be owned first"
    // rule with no byte basis (removed 2026-06-23 per spec-conformance audit).
    return !(owned_bits & (1u << ff_id));
}

} // namespace vc::sim
