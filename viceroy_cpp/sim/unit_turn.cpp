// sim/unit_turn.cpp -- see unit_turn.hpp.
#include "unit_turn.hpp"
#include "combat.hpp"

#include <climits>
#include <cstdlib>
#include <queue>
#include <vector>

namespace vc::sim {

namespace {
int sgn(int v) { return (v > 0) - (v < 0); }
bool is_water_id(int tid) { return tid == 25 || tid == 26; }   // Ocean / Sea Lane
}

std::pair<int, int> find_step(const World& w, const RuleData& rd,
                              int fx, int fy, int tx, int ty, bool naval) {
    if (w.terrain.empty() || w.map_w <= 0 || w.map_h <= 0) return {-1, -1};
    auto passable = [&](int x, int y) {
        if (x < 0 || x >= w.map_w || y < 0 || y >= w.map_h) return false;
        return naval == is_water_id(w.terrain_id(x, y));
    };
    if (!passable(tx, ty)) return {-1, -1};

    const int N = w.map_w * w.map_h;
    auto idx = [&](int x, int y) { return y * w.map_w + x; };
    std::vector<long> dist(N, LONG_MAX);
    std::vector<int> prev(N, -1);
    const int s = idx(fx, fy), t = idx(tx, ty);
    using QN = std::pair<long, int>;   // (dist, node)
    std::priority_queue<QN, std::vector<QN>, std::greater<QN>> pq;
    dist[s] = 0; pq.push({0, s});
    const int dx[8] = {1, -1, 0, 0, 1, 1, -1, -1};
    const int dy[8] = {0, 0, 1, -1, 1, -1, 1, -1};
    while (!pq.empty()) {
        QN top = pq.top(); pq.pop();
        if (top.first > dist[top.second]) continue;
        if (top.second == t) break;
        int ux = top.second % w.map_w, uy = top.second / w.map_w;
        for (int k = 0; k < 8; ++k) {
            int nx = ux + dx[k], ny = uy + dy[k];
            if (!passable(nx, ny)) continue;
            int nt = w.terrain_id(nx, ny);
            long cost = (nt >= 0 && nt < NTERRAIN) ? rd.terrain_move[nt] : 1;
            if (cost < 1) cost = 1;
            int v = idx(nx, ny);
            if (dist[top.second] + cost < dist[v]) {
                dist[v] = dist[top.second] + cost;
                prev[v] = top.second;
                pq.push({dist[v], v});
            }
        }
    }
    if (dist[t] == LONG_MAX) return {-1, -1};
    int cur = t;                                   // walk back to the first step after start
    while (prev[cur] != s && prev[cur] != -1) cur = prev[cur];
    if (prev[cur] != s) return {-1, -1};
    return {cur % w.map_w, cur / w.map_w};
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
                      const RandFn& rng, const RuleData& rd, uint32_t ff_owned) {
    Unit& atk = w.units[ai];
    Unit& def = w.units[di];
    CombatResult res = resolve_land(rd, atk, def, /*terrain*/0, /*fort*/0, g.difficulty,
                                    atk.owner == HUMAN_OWNER, def.owner == HUMAN_OWNER, rng,
                                    /*defender_fortified*/ def.order == ORDER_FORTIFY);
    Unit& loser = res.attacker_won ? def : atk;
    if (res.captured) {
        loser.owner = res.attacker_won ? atk.owner : def.owner;  // changes hands intact
    } else if (res.loser_outcome < 0) {
        loser.alive = false;                                     // destroyed
    } else {
        loser.type = res.loser_outcome;                         // demoted in place
    }
    // The winner may promote (training.md 3): Washington (FF 11, human only) skips the
    // random_int(1,S) <= winner_strength roll.
    Unit& winner = res.attacker_won ? atk : def;
    const int winner_str = res.attacker_won ? res.atk_str : res.def_str;
    const bool washington = winner.owner == HUMAN_OWNER && ((ff_owned >> 11) & 1u);
    promote_on_win(winner.type, winner.profession, winner_str,
                   res.atk_str + res.def_str, washington, rng);
    atk.moves_left = 0;                                          // attacking ends the turn
    return res.attacker_won && !res.captured && !def.alive;     // defender tile cleared
}

// Terrain improvement (spec/systems/terrain_improvement.md 3, all sites byte-cited):
// Clear/Plow "P" (func_040656) and Build Road "R" (func_0409D6). Work counter +0x16
// increments each held turn (@0x04071D/@0x040A46); threshold = the per-terrain table
// value (+2 for clear/plow, @0x040727; none for road, @0x040A50), HALVED for a Hardy
// Pioneer (class 0x14, sar ax,1 @0x04074A/@0x040A59). On completion (@0x040756/
// @0x040A6C) the counter resets and the order clears; clear drops a forested id by 8
// (@0x040896), plow sets 0x40 (@0x04089F), road sets 0x08 (@0x040AEC); clearing next
// to an own colony deposits lumber into its stockpile (@0x04084D, the Lumber slot);
// then func_040608 debits 20 tools (@0x4060F) and reverts the Pioneer to a plain
// Colonist when fewer than 20 remain (@0x040614.., @USEDUPTOOLS).
static void do_improve(World& w, Unit& u, const RuleData& rd) {
    const int t = w.terrain_id(u.x, u.y);
    if (t < 0 || t == 25 || t == 26) { u.order = ORDER_NONE; return; }   // no plane / water
    const bool forested = t >= 8 && t <= 23;
    if (u.order == ORDER_CLEAR_PLOW && !forested && (w.improve_at(u.x, u.y) & 0x40)) {
        u.order = ORDER_NONE; return;                                    // already plowed
    }
    if (u.order == ORDER_ROAD && (w.improve_at(u.x, u.y) & 0x08)) {
        u.order = ORDER_NONE; return;                                    // already a road
    }
    ++u.work;
    int threshold = rd.terrain_move[t] + (u.order == ORDER_CLEAR_PLOW ? 2 : 0);
    if (u.profession == CLASS_HARDY_PIONEER) threshold >>= 1;
    if (threshold < 1) threshold = 1;
    if (u.work < threshold) return;
    u.work = 0;
    if (u.order == ORDER_CLEAR_PLOW) {
        if (forested) {
            // Forested id -> its unforested base. The EXE subtracts 8 (@0x040896), which
            // assumes ids 8..15; the map data also carries the duplicate encodings 16..23
            // ((id&7)|8 canon), where the base is id&7 -- one rule covers both.
            uint8_t& b = w.terrain[(size_t)u.y * w.map_w + u.x];
            b = (uint8_t)((b & ~0x1F) | (b & 0x07));
            for (Colony& c : w.colonies)                   // lumber to the adjacent own colony
                if (c.owner_power == u.owner &&
                    c.x >= 0 && std::abs(c.x - u.x) <= 1 && std::abs(c.y - u.y) <= 1) {
                    c.stockpile[5] += rd.cfg.clear_lumber_base;   // good 5 = Lumber (@CLEARCUT)
                    break;
                }
        } else {
            w.improve_set(u.x, u.y, 0x40);                 // plow
        }
    } else {
        w.improve_set(u.x, u.y, 0x08);                     // road
    }
    u.order = ORDER_NONE;
    u.tools -= rd.cfg.improve_tool_cost;
    if (u.tools < rd.cfg.improve_tool_cost) {              // out of tools: back to a Colonist
        u.tools = 0;
        if (u.type == PIONEERS) u.type = COLONISTS;
    }
}

void apply_orders(GameState& g, World& w, const RandFn& rng, const RuleData& rd, uint32_t ff_owned) {
    for (int i = 0; i < (int)w.units.size(); ++i) {
        Unit& u = w.units[i];
        if (!u.alive) continue;
        if (u.order == ORDER_CLEAR_PLOW || u.order == ORDER_ROAD) { do_improve(w, u, rd); continue; }
        if (u.order != ORDER_GOTO) continue;
        const bool naval = unit_stats(rd, u.type).move_class == 99;

        while (u.alive && u.moves_left > 0 && (u.x != u.target_x || u.y != u.target_y)) {
            int nx = u.x + sgn(u.target_x - u.x);
            int ny = u.y + sgn(u.target_y - u.y);

            // Is the straight (greedy) step valid -- in bounds and passable terrain?
            bool greedy_ok = !(w.map_w > 0 && (nx < 0 || nx >= w.map_w)) &&
                             !(w.map_h > 0 && (ny < 0 || ny >= w.map_h));
            if (greedy_ok) {
                int tid = w.terrain_id(nx, ny);
                if (tid >= 0 && naval != (tid == 25 || tid == 26)) greedy_ok = false;
            }
            if (!greedy_ok) {
                // Straight path blocked by impassable terrain -> route around it.
                std::pair<int, int> step = find_step(w, rd, u.x, u.y, u.target_x, u.target_y, naval);
                if (step.first < 0) break;            // unreachable
                nx = step.first; ny = step.second;
            }

            int occ = unit_at(w, nx, ny, i);
            if (occ >= 0) {
                if (w.units[occ].owner != u.owner) {
                    bool cleared = do_combat(g, w, i, occ, rng, rd, ff_owned);
                    if (cleared && u.alive) { u.x = nx; u.y = ny; }  // advance into vacated tile
                } // friendly occupant: blocked this turn (no stacking)
                break;                                              // combat or block ends the move
            }

            // (nx,ny) is now a passable, empty neighbor. Charge its terrain entry cost.
            int tid = w.terrain_id(nx, ny);
            int cost = 1;
            if (tid >= 0 && tid < NTERRAIN) { cost = rd.terrain_move[tid]; if (cost < 1) cost = 1; }
            u.x = nx; u.y = ny;
            // "always move at least one tile": entering costs `cost`, floored at 0.
            u.moves_left = (u.moves_left > cost) ? (u.moves_left - cost) : 0;
        }
        if (u.alive && u.x == u.target_x && u.y == u.target_y)
            u.order = ORDER_NONE;                                   // arrived
    }
}

} // namespace vc::sim
