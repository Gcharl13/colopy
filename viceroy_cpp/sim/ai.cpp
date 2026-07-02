// sim/ai.cpp -- see ai.hpp for the byte citations.
#include "ai.hpp"
#include "unit.hpp"
#include "unit_turn.hpp"   // unit_at
#include "explore.hpp"     // reveal_around

#include <cstdlib>

namespace vc::sim {

namespace {

bool water_id(int t) { return t == 25 || t == 26; }
bool land_ok(int t)  { return t >= 0 && !water_id(t); }

// Site value a settler considers worth the +500 term / founding on. The EXE's
// validity helper (0x181F:0x7BE/0x9E6) is a spot check, not a value bar -- this
// numeric gate is RECONSTRUCTED (live captures show coastal land scoring 9..13).
constexpr int SITE_BAR = 8;

// Octile distance (func_004900, ai.md 8.3): max+min/2 -- the AI's step metric.
int octile(int dx, int dy) {
    dx = std::abs(dx); dy = std::abs(dy);
    const int mx = dx > dy ? dx : dy, mn = dx > dy ? dy : dx;
    return mx + (mn >> 1);
}

// The colony catchment: 21 tiles = the 5x5 block minus its corners, nearest
// rings first (the EXE's [bx+0xc8]/[bx+0xde] delta tables are runtime-built --
// this ordering is the RECONSTRUCTED part; the weights/thresholds are cited).
struct D { int dx, dy; };
const D CATCH[21] = {
    {0,0},                                                        // center
    {1,0},{-1,0},{0,1},{0,-1},{1,1},{1,-1},{-1,1},{-1,-1},        // ring 1
    {2,0},{-2,0},{0,2},{0,-2},{2,1},{2,-1},{-2,1},{-2,-1},        // ring 2
    {1,2},{1,-2},{-1,2},{-1,-2}                                   //   (no corners)
};

int colony_near(const World& w, int x, int y, int r) {
    for (int i = 0; i < (int)w.colonies.size(); ++i)
        if (w.colonies[i].x >= 0 &&
            std::abs(w.colonies[i].x - x) <= r && std::abs(w.colonies[i].y - y) <= r)
            return i;
    return -1;
}

} // namespace

int ai_move_allowance(const RuleData& rd, int unit_type) {
    return unit_stats(rd, unit_type).movement * 3;    // UnitTypeStats +0x00 = moves*3
}

int colony_site_value(const World& w, const RuleData& rd, int x, int y) {
    const int center = w.terrain_id(x, y);
    if (center < 0 || water_id(center)) return 0;     // water / out-of-bounds -> 0
    long score = 0;
    for (int i = 0; i < 21; ++i) {
        const int tx = x + CATCH[i].dx, ty = y + CATCH[i].dy;
        const int t = w.terrain_id(tx, ty);
        if (t < 0) continue;
        long v;
        if (t == 25) {                                // ocean: coastal-adjacency bonus
            int adj_land = 0;
            for (int k = 1; k <= 8; ++k)              // the 8 neighbours (ring-1 deltas)
                if (land_ok(w.terrain_id(tx + CATCH[k].dx, ty + CATCH[k].dy)))
                    ++adj_land;
            v = (2 + 2 * adj_land) >> 2;
        } else {
            v = rd.terrain_improve[t < NTERRAIN ? t : 0];   // the +0x2F79 Improvement stat
        }
        if (!w.terrain.empty() && tx >= 0 && tx < w.map_w && ty >= 0 && ty < w.map_h &&
            (w.terrain[(size_t)ty * w.map_w + tx] & 0x40))
            v += 1;                                   // layer-1 feature bit 0x40 (@181F:0x72c)
        const int wgt = i < 4 ? 5 : i < 8 ? 4 : i < 12 ? 3 : 2;   // ring weights (cmp 4/8/0xc/0x14)
        score += (v * wgt) >> 1;                      // di = (di*w)>>1
    }
    if (colony_near(w, x, y, 3) >= 0) score >>= 1;    // near an existing colony: halved
    if (center == 27) return 0;                       // Mountains centre -> 0
    if (center == 28) score >>= 1;                    // Hills centre -> halved
    long v = score / 10;                              // idiv 10 @0x6410E
    if (v < 0) v = 0; if (v > 15) v = 15;             // clamp(v,0,0xF) (func_0048CC)
    return (int)v;
}

namespace {

// func_046FFA -- score the 9 candidates (8 compass dirs + stay) for one unit and
// return the winning dir (8 = stay). Terms per the ai.md 3 table; helpers that
// need engine state World does not carry (native settlements, the era counter,
// the yield helper) are skipped, not approximated. The target-distance term is
// applied as closer-is-better (the byte trace reads "3*dist" without the sign
// context; toward-the-target is the only reading consistent with the decoded
// goal-seeking missions -- RECONSTRUCTED note).
int ai_pick_heading(const World& w, const RuleData& rd, const Unit& u, int self_idx,
                    bool settler, const RandFn& rng) {
    static const int DX[9] = {1, 1, 0, -1, -1, -1, 0, 1, 0};
    static const int DY[9] = {0, 1, 1, 1, 0, -1, -1, -1, 0};
    const bool naval = unit_stats(rd, u.type).move_class == 99;
    int best = -1, best_dir = 8;
    for (int dir = 0; dir < 9; ++dir) {               // candidate loop 0..8 (@0x047371)
        const int tx = u.x + DX[dir], ty = u.y + DY[dir];
        const int t = w.terrain_id(tx, ty);
        if (dir != 8) {
            if (t < 0) continue;                      // off-map
            if (!naval && (t == 25 || t == 26 || t == 24)) continue;  // Ocean/SeaLane/Arctic reject
            if (naval && !water_id(t)) continue;      // ships stay on water
            if (unit_at(w, tx, ty, self_idx) >= 0) continue;   // occupied tile reject (@0x047A1D)
        }
        long score = 200;                             // base +200 (@0x0473A4)
        // (+4 heading continuity and the reverse turn-cost helper need the stored
        // compass heading +0x314F, which this model does not carry -- skipped.)
        if (dir == 8 && colony_near(w, u.x, u.y, 0) >= 0)
            score += 40;                              // colony-proximity stay bonus (0x28;
                                                      //   applied ON a colony tile so marchers
                                                      //   are not pinned short -- adaptation)
        if (u.target_x >= 0)                          // target-distance term (@0x047AEC)
            score -= 3 * octile(u.target_x - tx, u.target_y - ty);
        if (settler && dir != 8 && colony_near(w, tx, ty, 1) < 0) {
            const int sv = colony_site_value(w, rd, tx, ty);
            if (sv >= SITE_BAR) score += 500;         // colony-site term (0x1F4, @0x047D84)
        }
        score += rng(1, 5);                           // RNG jitter (@0x047F44)
        if (score < 0) score = 0;                     // clamp (@0x047F4A)
        if (score > best) { best = (int)score; best_dir = dir; }   // strict max (@0x047F6E)
    }
    return best_dir;
}

// Nearest tile this power has NOT explored (the scout frontier). Returns false
// when the whole map is revealed.
bool nearest_frontier(const World& w, int power, int x, int y, int& ox, int& oy) {
    long best = 1 << 20; bool found = false;
    for (int ty = 0; ty < w.map_h; ++ty)
        for (int tx = 0; tx < w.map_w; ++tx) {
            if (w.explored(tx, ty, power)) continue;
            if (!land_ok(w.terrain_id(tx, ty))) continue;
            const long d = octile(tx - x, ty - y);
            if (d < best) { best = d; ox = tx; oy = ty; found = true; }
        }
    return found;
}

// Best colony site this power can see (max site value, octile-near breaks ties).
bool best_colony_site(const World& w, const RuleData& rd, int power, int x, int y,
                      int& ox, int& oy) {
    int best_v = SITE_BAR;                            // must reach the qualifying bar
    long best_d = 1 << 20; bool found = false;
    for (int ty = 0; ty < w.map_h; ++ty)
        for (int tx = 0; tx < w.map_w; ++tx) {
            if (!w.explored(tx, ty, power)) continue;
            if (!land_ok(w.terrain_id(tx, ty))) continue;
            if (colony_near(w, tx, ty, 1) >= 0) continue;
            const int v = colony_site_value(w, rd, tx, ty);
            if (v < best_v) continue;
            const long d = octile(tx - x, ty - y);
            if (v > best_v || d < best_d) { best_v = v; best_d = d; ox = tx; oy = ty; found = true; }
        }
    return found;
}

int nearest_own_colony(const World& w, int power, int x, int y) {
    int best = -1; long bd = 1 << 20;
    for (int i = 0; i < (int)w.colonies.size(); ++i) {
        const Colony& c = w.colonies[i];
        if (c.owner_power != power || c.x < 0) continue;
        const long d = octile(c.x - x, c.y - y);
        if (d < bd) { bd = d; best = i; }
    }
    return best;
}

} // namespace

void ai_power_turn(GameState& g, World& w, int power, const RuleData& rd, const RandFn& rng) {
    if (power == HUMAN_OWNER) return;                 // controller gate (@0x58A6)
    for (int i = 0; i < (int)w.units.size(); ++i) {
        Unit& u = w.units[i];
        if (!u.alive || u.owner != power) continue;
        u.ai_spent = 0;                               // budget reset (@0x005872)
        const bool naval   = unit_stats(rd, u.type).move_class == 99;
        const bool settler = u.type == COLONISTS || u.type == PIONEERS;
        const bool scout   = u.type == SCOUTS;

        // --- strategic plan: pick/refresh the mission (func_04CC50 -> state char) ---
        if (settler) {
            int sx, sy;
            if (best_colony_site(w, rd, power, u.x, u.y, sx, sy)) {
                u.target_x = sx; u.target_y = sy; u.ai_state = '1';   // target selected
            } else { u.ai_state = '0'; continue; }                    // idle/sentry
        } else if (scout) {
            int fx, fy;
            if (nearest_frontier(w, power, u.x, u.y, fx, fy)) {
                u.target_x = fx; u.target_y = fy; u.ai_state = '2';   // scout explore
            } else { u.ai_state = '0'; continue; }
        } else if (!naval) {
            const int ci = nearest_own_colony(w, power, u.x, u.y);
            if (ci < 0) { u.ai_state = '0'; continue; }
            const Colony& c = w.colonies[ci];
            if (u.x == c.x && u.y == c.y) {                           // arrived: garrison
                u.ai_state = 'G'; u.order = ORDER_FORTIFY; continue;
            }
            u.target_x = c.x; u.target_y = c.y; u.ai_state = '3';     // move-to-colony
        } else {
            u.target_x = -1; u.target_y = -1; u.ai_state = '8';       // explore-wander
        }

        // --- execute: step within the budget (allowance - spent >= 3, @0x03EE95) ---
        const int allowance = ai_move_allowance(rd, u.type);
        while (u.alive && allowance - u.ai_spent >= 3) {
            const int dir = ai_pick_heading(w, rd, u, i, settler && u.ai_state == '1', rng);
            if (dir == 8) break;                      // stay (heading 8, @0x051A95)
            static const int DX[8] = {1, 1, 0, -1, -1, -1, 0, 1};
            static const int DY[8] = {0, 1, 1, 1, 0, -1, -1, -1};
            u.x += DX[dir]; u.y += DY[dir];
            u.ai_spent += 3;                          // step charge +3 (@0x05CAE2)
            reveal_around(w, u.x, u.y, 1, power);     // AI powers track their own fog
            if (u.x == u.target_x && u.y == u.target_y) break;
        }

        // --- arrival handling ---
        if (settler && u.ai_state == '1' && u.x == u.target_x && u.y == u.target_y &&
            colony_near(w, u.x, u.y, 1) < 0 && colony_site_value(w, rd, u.x, u.y) >= SITE_BAR) {
            Colony c;                                  // found: the unit is absorbed ('=',
            c.x = u.x; c.y = u.y;                      //   type mutated @0x04F20E)
            c.owner_power = power; c.human = false;
            c.population = 1;
            c.center_terrain = w.terrain_id(u.x, u.y) & 0x1F;
            c.center_food = 3;
            Colony::Worker wk; wk.profession = 19; wk.tile = 0; wk.good = 0;
            wk.terrain = c.center_terrain;
            c.workers.push_back(wk);
            w.colonies.push_back(c);
            u.ai_state = '=';
            u.alive = false;
        }
    }
}

} // namespace vc::sim
