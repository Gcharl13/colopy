// sim/immigration.hpp -- religious immigration (spec/systems/immigration.md).
#pragma once
#include "types.hpp"
#include <functional>

namespace vc::sim {

// Inclusive random int in [lo, hi] (injected for determinism/testing).
using RandFn = std::function<int(int /*lo*/, int /*hi*/)>;

// Crosses spawn threshold (func_035D9A): from empire size (Σ colony pop +
// unit count). accum = workers+units; if <4000 -> accum*2+8; clamp 4000;
// AI scales *(8-diff)/8; England (player 0) gets *2/3.
int crosses_threshold(int total_workers, int unit_count,
                      int difficulty, bool ai, int player_idx);

struct ImmigrationResult { bool spawned = false; int type = -1; int slot = -1; };

// One immigration step for a power: accrue `crosses_gained` (= 2 base + Σ
// colony cross output), recompute the threshold, and when accum > threshold
// spawn an immigrant into a random dock slot and reset accum.
// (P1 spawns a Free Colonist; the full turn&3 type-distribution RNG is P2.)
ImmigrationResult immigration_step(Power& p, int crosses_gained,
                                   int total_workers, int unit_count,
                                   int difficulty, bool ai, int player_idx,
                                   const RandFn& rng);

} // namespace vc::sim
