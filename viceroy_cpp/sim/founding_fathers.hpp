// sim/founding_fathers.hpp -- Continental Congress (spec/systems/founding_fathers.md).
#pragma once
#include <cstdint>
#include "rules.hpp"   // RuleData / default_rules()

namespace vc::sim {

// Bell-cost curve for the next Founding Father (func_03C282):
//   base = human ? (diff+3)*16 : (14-diff)*8
//   for each year gate {1600,1650,1700,1750} reached: base += base>>1
//   cost = (ff_count+1)*base + 1; first father (ff_count==0) is half price.
//   Post-independence override: diff*1500 + 2000. (all scalars from cfg.)
int ff_cost(int difficulty, int year, int ff_count, bool human, bool post_independence,
            const RuleData& rd = default_rules());

// Era band by year: 0 (<1600), 1 (1600..1699), 2 (>=1700).
int ff_era_band(int year);

// Offerable iff not yet acquired (the byte-verified rule: the next father is a
// weighted random over all un-owned fathers; there is no intra-category ordering).
// owned_bits: bit i set = father i acquired.
bool ff_available(uint32_t owned_bits, int ff_id);

} // namespace vc::sim
