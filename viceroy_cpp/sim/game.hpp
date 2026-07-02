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
    // Per-tile improvement bits (terrain_improvement.md: plow 0x40 @0x04089F,
    // road 0x08 @0x040AEC -- a feature plane distinct from the .MP terrain byte).
    // Lazily sized on the first write; empty = no improvements anywhere.
    std::vector<uint8_t> improve;
    // Per-tile fog-of-war (exploration.md 2, BYTE-VERIFIED encoding): a separate
    // visibility layer (the EXE's 4th map layer at far-ptr [0x168]) holding one
    // STICKY bit per power -- bit player+4 (player 0 = 0x10 .. player 3 = 0x80),
    // OR'd by func_00631A; no shared exploration. Empty = fog disabled (all seen).
    std::vector<uint8_t> fog;

    // Terrain id at (x,y); -1 if no terrain plane / out of range. The stored
    // byte is the .MP FILE packing (func_0624E, map_system.md 8): bits 0-4 =
    // base id, bit 0x20 = special terrain (with bit 0x80: Mountains 27, else
    // Hills 28), bit 0x40 = river. Ids 27/28 never occur in the low bits of
    // shipped maps -- they are synthesized here from the flag.
    int terrain_id(int x, int y) const {
        if (terrain.empty() || map_w <= 0) return -1;
        if (x < 0 || x >= map_w || y < 0 || y >= map_h) return -1;
        uint8_t b = terrain[(size_t)y * map_w + x];
        if (b & 0x20) return (b & 0x80) ? 27 : 28;
        return b & 0x1F;
    }
    // Improvement bits at (x,y): 0x40 plowed, 0x08 road; 0 if none/out of range.
    int improve_at(int x, int y) const {
        if (improve.empty() || map_w <= 0) return 0;
        if (x < 0 || x >= map_w || y < 0 || y >= map_h) return 0;
        return improve[(size_t)y * map_w + x];
    }
    void improve_set(int x, int y, uint8_t bit) {
        if (map_w <= 0 || map_h <= 0 || x < 0 || x >= map_w || y < 0 || y >= map_h) return;
        if (improve.empty()) improve.assign((size_t)map_w * map_h, 0);
        improve[(size_t)y * map_w + x] |= bit;
    }
    // Has `player` explored (x,y)? Fog disabled (empty plane) => everything visible.
    bool explored(int x, int y, int player) const {
        if (fog.empty() || map_w <= 0) return true;
        if (x < 0 || x >= map_w || y < 0 || y >= map_h) return false;
        return (fog[(size_t)y * map_w + x] & (uint8_t)(1u << (player + 4))) != 0;
    }
};

// One full turn, in the byte-verified phase order (func_005760):
//   Production (per colony) -> Market price drift -> Immigration ->
//   REF (King) accrual+purchase -> cadence advance.
// (Per-power Orders/Diplomacy AI phases are P2+.) `rng` drives immigration's
// dock-slot pick; `player_idx` is the human power whose immigration/REF advance;
// `rd` is the active ruleset (the Forge drives a whole turn with a modded one);
// `ff_owned` is the human power's founding-father bitmask (school/combat effects).
void step_turn(GameState& g, World& w, const RandFn& rng, int player_idx = 0,
               const RuleData& rd = default_rules(), uint32_t ff_owned = 0);

} // namespace vc::sim
