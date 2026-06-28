// sim/game.hpp -- the per-turn orchestration (spec/systems/turn_dispatch.md).
#pragma once
#include "types.hpp"
#include "unit.hpp"          // Unit
#include "immigration.hpp"   // RandFn
#include "rules.hpp"         // RuleData / default_rules()
#include <vector>

namespace vc::sim {

struct World {
    std::vector<Colony> colonies;
    std::vector<Unit>   units;        // on-map units (the unit/turn spine)
    int map_w = 0, map_h = 0;         // map bounds for movement clamping (0 = unbounded)
    std::vector<uint8_t> terrain;     // optional L1 terrain plane (map_w*map_h); empty = flat

    // Terrain id at (x,y) (low 5 bits); -1 if no terrain plane / out of range.
    int terrain_id(int x, int y) const {
        if (terrain.empty() || map_w <= 0) return -1;
        if (x < 0 || x >= map_w || y < 0 || y >= map_h) return -1;
        return terrain[(size_t)y * map_w + x] & 0x1F;
    }
};

// One full turn, in the byte-verified phase order (func_005760):
//   Production (per colony) -> Market price drift -> Immigration ->
//   REF (King) accrual+purchase -> cadence advance.
// (Per-power Orders/Diplomacy AI phases are P2+.) `rng` drives immigration's
// dock-slot pick; `player_idx` is the human power whose immigration/REF advance;
// `rd` is the active ruleset (the Forge drives a whole turn with a modded one).
void step_turn(GameState& g, World& w, const RandFn& rng, int player_idx = 0,
               const RuleData& rd = default_rules());

} // namespace vc::sim
