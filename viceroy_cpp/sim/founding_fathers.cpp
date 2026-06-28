// sim/founding_fathers.cpp -- see founding_fathers.hpp.
#include "founding_fathers.hpp"

namespace vc::sim {

int ff_cost(int difficulty, int year, int ff_count, bool human, bool post_independence,
            const RuleData& rd) {
    const Config& cfg = rd.cfg;
    if (post_independence) return difficulty * cfg.ff_post_indep_scale + cfg.ff_post_indep_offset;
    int cost = human ? (difficulty + cfg.ff_human_offset) * cfg.ff_human_scale
                     : (cfg.ff_ai_offset - difficulty) * cfg.ff_ai_scale;
    for (int gate : cfg.ff_gate_years)
        if (year >= gate) cost += cost >> cfg.ff_compounding_shift;   // x1.5 compounding
    cost = (ff_count + 1) * cost + 1;
    if (ff_count == 0) cost >>= cfg.ff_first_father_shift;            // first father half price
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
