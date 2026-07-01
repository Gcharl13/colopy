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

// The dock-slot refill distribution (func_034C24): difficulty-scaled high/low tier split;
// Brewster (FF 0x14) upgrades the high tier to Free Colonist. See immigration.cpp.
int immigrant_refill(int difficulty, bool has_brewster, const RandFn& rng,
                     const RuleData& rd = default_rules());

// One immigration step for a power: accrue `crosses_gained` (= base + Σ colony cross
// output -- USER RULING: crosses drive the pool), recompute the threshold, and when
// accum > threshold the chosen dock slot's stored colonist arrives (the slot refills via
// the func_034C24 distribution) and accum resets.
ImmigrationResult immigration_step(Power& p, int crosses_gained,
                                   int total_workers, int unit_count,
                                   int difficulty, bool ai, bool is_england,
                                   const RandFn& rng,
                                   const RuleData& rd = default_rules(),
                                   bool has_brewster = false);

} // namespace vc::sim
