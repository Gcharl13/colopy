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
#include "events.hpp"       // RumorResult (rumor squares resolve during movement)
#include <utility>       // std::pair

namespace vc::sim {

// Owner index treated as the human player (affects the combat difficulty handicap).
constexpr int HUMAN_OWNER = 0;

// A battlefield promotion (training.md 3, promote_on_win), surfaced for the
// end-of-turn notices: the veteran stamp -> @VETERAN "Our {%STRING0} have
// hardened to {Veteran} status"; the type ceiling (Soldiers->Continental Army,
// Dragoons->Continental Cavalry) -> @CONTINENTAL.
struct PromoteResult { int unit = -1; int owner = 0; int old_type = 0; int new_type = 0; };

// Start-of-turn: each living unit's moves_left = unit_stats(rd, type).movement.
void refresh_moves(World& w, const RuleData& rd = default_rules());

// Execute standing orders for every living unit (all owners). ORDER_GOTO steps
// one tile/move toward (target_x,target_y); entering an enemy tile triggers
// resolve_land and ends the unit's move. Mutates units (move/demote/capture/kill;
// the winner may promote per training.md -- ff_owned is the HUMAN power's
// founding-father bitmask, bit 11 = George Washington's auto-promote).
// woi = the War of Independence is declared ([0x5382] bit 0): rebel attacks
// on other European powers are cancelled (@NOWARSDURINGREV, func_05A862
// @0x5A912).
// only_owner >= 0 runs the order loop for that power's units alone -- the
// per-power interleave slice (turn_dispatch.md 3: the func_005760 power loop
// runs Orders per power, not globally).
void apply_orders(GameState& g, World& w, const RandFn& rng,
                  const RuleData& rd = default_rules(), uint32_t ff_owned = 0,
                  std::vector<RumorResult>* rumor_out = nullptr,
                  std::vector<PromoteResult>* promote_out = nullptr,
                  bool woi = false, int only_owner = -1);

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
