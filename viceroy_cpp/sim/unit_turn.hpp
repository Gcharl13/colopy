// sim/unit_turn.hpp -- the unit/turn spine: movement, orders, combat-on-contact.
//
// This is the net-new logic both player clients (Godot, ESP32) need before "End
// Turn" drives a playable game (the work flagged as buried in the P2 gap). It is
// pure and headless like the rest of the sim, driven by an injected RNG + RuleData
// and golden-tested. Scope: per-type move points (@UNIT.movement), GOTO greedy
// stepping with map-bound clamping, FORTIFY/SENTRY (no move), and combat when a
// move enters an enemy-occupied tile (via resolve_land). Deferred (noted): terrain
// movement cost, obstacle pathfinding, stacking, and AI order-setting.
#pragma once

#include "game.hpp"      // World
#include "rules.hpp"     // RuleData
#include "immigration.hpp"  // RandFn

namespace vc::sim {

// Owner index treated as the human player (affects the combat difficulty handicap).
constexpr int HUMAN_OWNER = 0;

// Start-of-turn: each living unit's moves_left = unit_stats(rd, type).movement.
void refresh_moves(World& w, const RuleData& rd = default_rules());

// Execute standing orders for every living unit (all owners). ORDER_GOTO steps
// one tile/move toward (target_x,target_y); entering an enemy tile triggers
// resolve_land and ends the unit's move. Mutates units (move/demote/capture/kill).
void apply_orders(GameState& g, World& w, const RandFn& rng,
                  const RuleData& rd = default_rules());

// Index of a living unit at (x,y) other than `except`, or -1.
int unit_at(const World& w, int x, int y, int except = -1);

} // namespace vc::sim
