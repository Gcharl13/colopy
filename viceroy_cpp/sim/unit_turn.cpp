// sim/unit_turn.cpp -- see unit_turn.hpp.
#include "unit_turn.hpp"
#include "combat.hpp"

namespace vc::sim {

namespace {
int sgn(int v) { return (v > 0) - (v < 0); }
}

int unit_at(const World& w, int x, int y, int except) {
    for (int i = 0; i < (int)w.units.size(); ++i) {
        if (i == except) continue;
        const Unit& u = w.units[i];
        if (u.alive && u.x == x && u.y == y) return i;
    }
    return -1;
}

void refresh_moves(World& w, const RuleData& rd) {
    for (Unit& u : w.units)
        if (u.alive) u.moves_left = unit_stats(rd, u.type).movement;
}

// Resolve combat when unit `ai` attacks the unit at index `di`; apply the outcome
// to both units. Returns true if the attacker's tile is now free to advance into
// (defender destroyed). The attacker's move ends regardless.
static bool do_combat(GameState& g, World& w, int ai, int di,
                      const RandFn& rng, const RuleData& rd) {
    Unit& atk = w.units[ai];
    Unit& def = w.units[di];
    CombatResult res = resolve_land(rd, atk, def, /*terrain*/0, /*fort*/0, g.difficulty,
                                    atk.owner == HUMAN_OWNER, def.owner == HUMAN_OWNER, rng);
    Unit& loser = res.attacker_won ? def : atk;
    if (res.captured) {
        loser.owner = res.attacker_won ? atk.owner : def.owner;  // changes hands intact
    } else if (res.loser_outcome < 0) {
        loser.alive = false;                                     // destroyed
    } else {
        loser.type = res.loser_outcome;                         // demoted in place
    }
    atk.moves_left = 0;                                          // attacking ends the turn
    return res.attacker_won && !res.captured && !def.alive;     // defender tile cleared
}

void apply_orders(GameState& g, World& w, const RandFn& rng, const RuleData& rd) {
    for (int i = 0; i < (int)w.units.size(); ++i) {
        Unit& u = w.units[i];
        if (!u.alive || u.order != ORDER_GOTO) continue;
        const bool naval = unit_stats(rd, u.type).move_class == 99;

        while (u.alive && u.moves_left > 0 && (u.x != u.target_x || u.y != u.target_y)) {
            int nx = u.x + sgn(u.target_x - u.x);
            int ny = u.y + sgn(u.target_y - u.y);
            if (w.map_w > 0 && (nx < 0 || nx >= w.map_w)) break;   // off-map: stop
            if (w.map_h > 0 && (ny < 0 || ny >= w.map_h)) break;

            int occ = unit_at(w, nx, ny, i);
            if (occ >= 0) {
                if (w.units[occ].owner != u.owner) {
                    bool cleared = do_combat(g, w, i, occ, rng, rd);
                    if (cleared && u.alive) { u.x = nx; u.y = ny; }  // advance into vacated tile
                } // friendly occupant: blocked this turn (no stacking)
                break;                                              // combat or block ends the move
            }

            // Terrain-aware step (only when the world carries a terrain plane).
            int tid = w.terrain_id(nx, ny);
            int cost = 1;
            if (tid >= 0) {
                bool water = (tid == 25 || tid == 26);   // Ocean / Sea Lane
                if (naval != water) break;               // land can't enter water; ships can't beach
                if (tid < NTERRAIN) cost = rd.terrain_move[tid];
                if (cost < 1) cost = 1;
            }
            u.x = nx; u.y = ny;                                     // step into empty tile
            // "always move at least one tile": entering costs `cost`, floored at 0.
            u.moves_left = (u.moves_left > cost) ? (u.moves_left - cost) : 0;
        }
        if (u.alive && u.x == u.target_x && u.y == u.target_y)
            u.order = ORDER_NONE;                                   // arrived
    }
}

} // namespace vc::sim
