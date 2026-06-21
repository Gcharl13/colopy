// sim/founding_fathers.hpp -- Continental Congress (spec/systems/founding_fathers.md).
#pragma once
#include <cstdint>

namespace vc::sim {

// Bell-cost curve for the next Founding Father (func_03C282):
//   base = human ? (diff+3)*16 : (14-diff)*8
//   for each year gate {1600,1650,1700,1750} reached: base += base>>1
//   cost = (ff_count+1)*base + 1; first father (ff_count==0) is half price.
//   Post-independence override: diff*1500 + 2000.
int ff_cost(int difficulty, int year, int ff_count, bool human, bool post_independence);

// Era band by year: 0 (<1600), 1 (1600..1699), 2 (>=1700).
int ff_era_band(int year);

// Offerable iff not owned AND every lower-index father of the same category is
// owned. owned_bits: bit i set = father i acquired. category[i] in 0..4.
bool ff_available(uint32_t owned_bits, int ff_id, const int* category, int nfathers);

} // namespace vc::sim
