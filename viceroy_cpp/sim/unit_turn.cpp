// sim/unit_turn.cpp -- see unit_turn.hpp.
#include "unit_turn.hpp"
#include "combat.hpp"

#include <climits>
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
                      const RandFn& rng, const RuleData& rd) {
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
                    bool cleared = do_combat(g, w, i, occ, rng, rd);
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
