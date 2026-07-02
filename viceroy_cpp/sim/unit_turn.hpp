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
#include <utility>       // std::pair

namespace vc::sim {

// Owner index treated as the human player (affects the combat difficulty handicap).
constexpr int HUMAN_OWNER = 0;

// Start-of-turn: each living unit's moves_left = unit_stats(rd, type).movement.
void refresh_moves(World& w, const RuleData& rd = default_rules());

// Execute standing orders for every living unit (all owners). ORDER_GOTO steps
// one tile/move toward (target_x,target_y); entering an enemy tile triggers
// resolve_land and ends the unit's move. Mutates units (move/demote/capture/kill;
// the winner may promote per training.md -- ff_owned is the HUMAN power's
// founding-father bitmask, bit 11 = George Washington's auto-promote).
void apply_orders(GameState& g, World& w, const RandFn& rng,
                  const RuleData& rd = default_rules(), uint32_t ff_owned = 0);

// Index of a living unit at (x,y) other than `except`, or -1.
int unit_at(const World& w, int x, int y, int except = -1);

// First step of a least-cost route over PASSABLE terrain from (fx,fy) to (tx,ty)
// for a land/naval unit (8-connected Dijkstra; edge cost = terrain_move; units are
// ignored — combat/blocking is handled at execution). Returns {-1,-1} if the
// target is unreachable or there is no terrain plane. Used to route GOTO around
// impassable terrain (coastlines) when the straight step is blocked.
std::pair<int, int> find_step(const World& w, const RuleData& rd,
                              int fx, int fy, int tx, int ty, bool naval);

} // namespace vc::sim
