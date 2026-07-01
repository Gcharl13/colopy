// sim/immigration.hpp -- religious immigration (spec/systems/immigration.md).
#pragma once
#include "types.hpp"
#include "rules.hpp"   // RuleData / default_rules()
#include <functional>

namespace vc::sim {

// Inclusive random int in [lo, hi] (injected for determinism/testing).
using RandFn = std::function<int(int /*lo*/, int /*hi*/)>;

// Crosses spawn threshold (func_035D9A): from empire size (Σ colony pop +
// unit count). accum = workers+units; if <cap -> accum*mult+off; clamp cap;
// AI scales *(8-diff)/8; England gets *2/3. `is_england` keys on the power's
// nation (@COUNTRY 0), not its slot index -- so the bonus follows the chosen
// nation, not always power 0. (scalars from cfg.)
int crosses_threshold(int total_workers, int unit_count,
                      int difficulty, bool ai, bool is_england,
                      const RuleData& rd = default_rules());

struct ImmigrationResult { bool spawned = false; int type = -1; int slot = -1; };

// One immigration step for a power: accrue `crosses_gained` (= base + Σ
// colony cross output), recompute the threshold, and when accum > threshold
// spawn an immigrant into a random dock slot and reset accum.
// (P1 spawns a Free Colonist; the full turn&3 type-distribution RNG is P2.)
ImmigrationResult immigration_step(Power& p, int crosses_gained,
                                   int total_workers, int unit_count,
                                   int difficulty, bool ai, bool is_england,
                                   const RandFn& rng,
                                   const RuleData& rd = default_rules());

} // namespace vc::sim
