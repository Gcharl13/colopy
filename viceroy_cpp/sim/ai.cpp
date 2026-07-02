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
            // The +0x2F79 byte = the terrain VALUE column (4th of the M/D/I/V
            // prefix: Movement @0x2F76 [@0x051125], Defensive @0x2F77 [@0x7E63],
            // Improvement @0x2F78 [@0x040727], Value @0x2F79 [func_063F3C]).
            // ai.md's "Improvement" label for this byte is a one-byte cross-file
            // inconsistency -- the Value read reproduces the F9 captures exactly
            // (all-Plains catchment = 13, the observed maximum).
            v = rd.terrain_value[t < NTERRAIN ? t : 0];
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

// --- Plan-map accessors (ai.md 6.1; table GameState::plan) -------------------

void plan_clear(GameState& g, int power, int slot) {   // func_04C1F0
    if (power < 0 || power > 3 || slot < 0 || slot > 63) return;
    g.plan[power][slot] = GameState::PlanSlot{};       // {goal_type=0xFF, v3=0}
}

bool plan_set(GameState& g, int power, int x, int y, int goal_type, int priority) {
    if (power < 0 || power > 3) return false;
    auto& tab = g.plan[power];
    // func_04C3A2: scan the 64 slots for the first that is free (0xFF) or
    // outranked by the new entry; the priority-insert thunk shifts the rest.
    int at = -1;
    for (int s = 0; s < 64; ++s)
        if (tab[s].goal_type == 0xFF || tab[s].priority < priority) { at = s; break; }
    if (at < 0) return false;                          // full of higher-priority goals
    for (int s = 63; s > at; --s) tab[s] = tab[s - 1];
    tab[at].x = x; tab[at].y = y; tab[at].goal_type = goal_type; tab[at].priority = priority;
    return true;
}

int plan_query(const GameState& g, int power, int x, int y, int goal_type) {
    if (power < 0 || power > 3) return -1;
    int best = -1;                                     // func_04C306: max v3 among matches
    for (const auto& s : g.plan[power])
        if (s.goal_type == goal_type && s.x == x && s.y == y && s.priority > best)
            best = s.priority;
    return best;
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
        if (dir == u.heading && dir != 8)
            score += 4;                               // heading continuity +4 (@0x047A79)
        else if (u.heading < 8 && dir < 8 && ((dir - u.heading + 8) & 7) == 4)
            score -= 6;                               // turn-cost helper: reverse ~ -6 (@0x047A8D)
        if (dir != 8 && t >= 0 && t < NTERRAIN)
            score -= rd.terrain_move[t] * 3;          // terrain step cost (@0x051125..31:
                                                      //   the same x3 table the mover charges)
        if (naval && u.heading < 8 && dir < 8) {
            int ad = (dir - u.heading + 8) & 7;       // ship turn penalty: angular distance
            if (ad > 4) ad = 8 - ad;                  //   d*d*2 (the +0x314F ship term)
            score -= ad * ad * 2;
        }
        if (dir != 8) {                               // adjacent enemy attacker: -10 (@0x05170A,
            for (int k = 0; k < 8; ++k) {             //   0x0A when the neighbour attack != 0)
                const int ox = tx + DX[k], oy = ty + DY[k];
                const int oi = unit_at(w, ox, oy, self_idx);
                if (oi >= 0 && w.units[oi].owner != u.owner &&
                    unit_stats(rd, w.units[oi].type).attack > 0) { score -= 10; break; }
            }
        }
        if (dir == 8 && u.target_x < 0 && colony_near(w, u.x, u.y, 0) >= 0)
            score += 40;                              // colony-proximity stay bonus (0x28;
                                                      //   gated to goal-less units ON a colony
                                                      //   tile so goal-seekers are not pinned
                                                      //   -- adaptation)
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

// Own colony chosen by mission '3' (@0x04F1FD: "scores own colonies by
// distance + size [+0x1f]"). The exact combination of the two terms is not in
// the trace -- nearest first, population breaking ties is the RECONSTRUCTED
// reading (a big colony wins between two equally far ones).
int pick_garrison_colony(const World& w, int power, int x, int y) {
    int best = -1; long bd = 1 << 20; int bp = -1;
    for (int i = 0; i < (int)w.colonies.size(); ++i) {
        const Colony& c = w.colonies[i];
        if (c.owner_power != power || c.x < 0) continue;
        const long d = octile(c.x - x, c.y - y);
        if (d < bd || (d == bd && c.population > bp)) { bd = d; best = i; bp = c.population; }
    }
    return best;
}

// Worksite for an AI Pioneer: an improvable tile in the catchment of one of the
// power's colonies. Forested -> clear, open unplowed -> plow (both 'B'), sound
// land without a road -> road ('e'). Which build each cap-bit test maps to is
// not pinned in the trace (the &0x40/&0x20/&1/&4 probes, ai.md 4) -- the
// clear/plow-vs-road split here is the RECONSTRUCTED part; the state chars,
// work counter, and completion rule are the cited part.
bool pioneer_worksite(const World& w, int power, int self_idx, int& ox, int& oy, int& kind) {
    for (const Colony& c : w.colonies) {
        if (c.owner_power != power || c.x < 0) continue;
        for (int i = 1; i < 21; ++i) {                // ring tiles (skip the colony centre)
            const int tx = c.x + CATCH[i].dx, ty = c.y + CATCH[i].dy;
            const int t = w.terrain_id(tx, ty);
            if (!land_ok(t) || t == 24 || t == 27) continue;
            if (unit_at(w, tx, ty, self_idx) >= 0) continue;
            const int imp = w.improve_at(tx, ty);
            if (t >= 8 && t <= 23) { ox = tx; oy = ty; kind = 'B'; return true; }  // clear
            if (!(imp & 0x40))     { ox = tx; oy = ty; kind = 'B'; return true; }  // plow
            if (!(imp & 0x08))     { ox = tx; oy = ty; kind = 'e'; return true; }  // road
        }
    }
    return false;
}

bool idle_state(int s) {
    return s == 'X' || s == '0' || s == '?' || s == 'C' || s == 'U';
}

// Adjacent enemy unit (the sentry wake scan, tail @0x051C68: 0x181F:0xA38
// neighbour flags, test al,0x40 = threat).
bool adjacent_enemy(const World& w, int power, int x, int y) {
    for (int i = 0; i < (int)w.units.size(); ++i) {
        const Unit& o = w.units[i];
        if (!o.alive || o.owner == power) continue;
        if (std::abs(o.x - x) <= 1 && std::abs(o.y - y) <= 1) return true;
    }
    return false;
}

} // namespace

void ai_strategic_plan(GameState& g, World& w, int power, const RuleData& rd) {
    if (power < 0 || power > 3) return;
    for (int s = 0; s < 64; ++s) plan_clear(g, power, s);   // refill each pass

    // --- fill (policy RECONSTRUCTED; layout/match byte-cited, ai.md 6.1) ---
    // Settle sites -> goal 6 (the 0x40 Colonist/Pioneer capbit), priority =
    // site value: the best visible site from each settle-class unit's seat.
    for (const Unit& u : w.units) {
        if (!u.alive || u.owner != power) continue;
        const int caps = unit_stats(rd, u.type).capbits;
        if (caps & 0x40) {
            int sx, sy;
            if (best_colony_site(w, rd, power, u.x, u.y, sx, sy) &&
                plan_query(g, power, sx, sy, 6) < 0)
                plan_set(g, power, sx, sy, 6, colony_site_value(w, rd, sx, sy));
        }
        if (caps & 0x20) {                            // explore frontier -> goal 5
            int fx, fy;
            if (nearest_frontier(w, power, u.x, u.y, fx, fy) &&
                plan_query(g, power, fx, fy, 5) < 0)
                plan_set(g, power, fx, fy, 5, 4);
        }
    }
    for (const Colony& c : w.colonies)                // garrison -> goal 3
        if (c.owner_power == power && c.x >= 0 &&
            plan_query(g, power, c.x, c.y, 3) < 0)
            plan_set(g, power, c.x, c.y, 3, 1 + c.population);

    ai_plan_match(g, w, power, rd);
}

// The match half of the strategic pass: idle units bind to the highest-priority
// slot whose goal_type capbit they carry ((1<<G) & capbits, @0x04DFF4);
// consumed slots clear (func_04C1F0).
void ai_plan_match(GameState& g, World& w, int power, const RuleData& rd) {
    bool has_colony = false;
    for (const Colony& c : w.colonies)
        if (c.owner_power == power && c.x >= 0) { has_colony = true; break; }
    for (Unit& u : w.units) {
        if (!u.alive || u.owner != power || !idle_state(u.ai_state)) continue;
        const int caps  = unit_stats(rd, u.type).capbits;
        const bool naval = unit_stats(rd, u.type).move_class == 99;
        auto& tab = g.plan[power];
        for (int s = 0; s < 64; ++s) {
            if (tab[s].goal_type == 0xFF || tab[s].goal_type > 7) continue;
            if (!((1 << tab[s].goal_type) & caps)) continue;
            // Land-tile goal classes (settle/explore/garrison) never bind ships;
            // Pioneers with an owned colony leave settle slots to Colonists and
            // take the improvement mission instead (allocation RECONSTRUCTED --
            // the EXE's per-class tally @0x04E1BF is the untraced part).
            if (naval && (tab[s].goal_type == 3 || tab[s].goal_type == 5 ||
                          tab[s].goal_type == 6)) continue;
            if (u.type == PIONEERS && tab[s].goal_type == 6 && has_colony) continue;
            if (u.type == SCOUTS && tab[s].goal_type == 6) continue;   // scouts explore;
                                                       //   only settle classes found (the
                                                       //   dispatch, not the capbit, picks
                                                       //   the mission -- ai.md 6.2)
            u.target_x = tab[s].x; u.target_y = tab[s].y;
            u.ai_state = '1';                          // target selected (@0x04E15D)
            if (tab[s].goal_type == 1 && (u.ai_flags & 0x4))
                u.ai_state = 't';                      // goal class 1 (@0x04E175, gate @0x04E05C)
            else if (tab[s].goal_type == 7 && (u.ai_flags & 0x8))
                u.ai_state = 'i';                      // goal class 7 (@0x04E194, gate @0x04E07E)
            else if (tab[s].goal_type == 5)
                u.ai_state = '2';                      // scout-explore dispatch (@0x04F030)
            else if (tab[s].goal_type == 3)
                u.ai_state = '3';                      // move-to-colony dispatch (@0x04F1FD)
            plan_clear(g, power, s);                   // consumed (func_04C1F0)
            break;
        }
    }
}

void ai_power_turn(GameState& g, World& w, int power, const RuleData& rd, const RandFn& rng) {
    if (power == HUMAN_OWNER) return;                 // controller gate (@0x58A6)
    ai_strategic_plan(g, w, power, rd);               // func_04CC50 pass
    for (int i = 0; i < (int)w.units.size(); ++i) {
        Unit& u = w.units[i];
        if (!u.alive || u.owner != power) continue;
        u.ai_spent = 0;                               // budget reset (@0x005872)
        const bool naval   = unit_stats(rd, u.type).move_class == 99;
        const bool settler = (u.type == COLONISTS ||
                              (u.type == PIONEERS && u.ai_state == '1'));

        // --- resume the persistent state machine (ai.md 4) ---
        if (u.ai_state == 'G') {                       // garrisoned: hold fortification
            if (u.order != ORDER_FORTIFY && u.order != ORDER_FORTIFIED)
                u.order = ORDER_FORTIFY;               // (5 -> 6 next turn, @0x41024)
            continue;
        }
        if (u.ai_state == 'V') {                       // arrived -> garrison (promotion)
            u.ai_state = 'G'; u.order = ORDER_FORTIFY; continue;
        }
        if (u.ai_state == 'B' || u.ai_state == 'e') {
            if (u.order == ORDER_CLEAR_PLOW || u.order == ORDER_ROAD)
                continue;                              // still working (counter in apply_orders)
            u.ai_state = 'C';                          // build complete (@0x04F3B8)
            continue;                                  // re-planned next pass
        }

        // --- mission upkeep / fallback dispatch (func_04E2D6 + ai.md 6.2) ---
        if (u.ai_state == '2' || u.ai_state == 'D') {  // explore: retarget the frontier
            int fx, fy;
            if (nearest_frontier(w, power, u.x, u.y, fx, fy)) {
                u.target_x = fx; u.target_y = fy;
                if (octile(fx - u.x, fy - u.y) >= 8) { // long-range explore (@0x05107C)
                    u.ai_state = 'D'; u.ai_flags |= 0x10;
                } else u.ai_state = '2';
            } else { u.ai_state = '0'; u.target_x = u.target_y = -1; }
        } else if (u.ai_state == '1' && settler) {     // settle: re-validate the site
            if (u.target_x < 0 ||
                colony_near(w, u.target_x, u.target_y, 1) >= 0 ||
                colony_site_value(w, rd, u.target_x, u.target_y) < SITE_BAR) {
                u.ai_state = '?';                      // goal lost (@0x04E202) -> re-plan
                u.target_x = u.target_y = -1;
                continue;
            }
        } else if (idle_state(u.ai_state) || (u.ai_state == '8' && u.ai_steps <= 0)) {
            if (u.type == PIONEERS && u.tools >= rd.cfg.improve_tool_cost) {
                int wx, wy, kind;                      // AI Pioneer: improve near a colony
                if (pioneer_worksite(w, power, i, wx, wy, kind)) {
                    if (u.x == wx && u.y == wy) {      // on the worksite: start the build
                        u.order = (kind == 'B') ? ORDER_CLEAR_PLOW : ORDER_ROAD;
                        u.ai_state = kind;             // 'B' @0x051B26 / 'e' @0x051B7A
                        u.target_x = u.target_y = -1;
                        continue;
                    }
                    u.target_x = wx; u.target_y = wy;
                    u.ai_state = 'N';                  // Scout/Pioneer -> colony (@0x050C3B)
                } else u.ai_state = '0';
            } else if (naval) {
                u.ai_state = '8';                      // explore-wander (@0x050D58)
                u.ai_steps = rng(1, 0x14);             //   step counter +0x3156
                u.target_x = u.target_y = -1;
            } else if (u.type == SCOUTS || u.type == MISSIONARIES) {
                int fx, fy;
                if (nearest_frontier(w, power, u.x, u.y, fx, fy)) {
                    u.target_x = fx; u.target_y = fy;
                    u.ai_state = octile(fx - u.x, fy - u.y) >= 8 ? 'D' : '2';
                    if (u.ai_state == 'D') u.ai_flags |= 0x10;
                } else u.ai_state = '0';
            } else if (unit_stats(rd, u.type).capbits & 0x40) {
                int sx, sy;                            // settle-class fallback
                if (best_colony_site(w, rd, power, u.x, u.y, sx, sy)) {
                    u.target_x = sx; u.target_y = sy; u.ai_state = '1';
                } else { u.ai_state = '0'; }
            } else {                                   // military: garrison ('3' @0x04F1FD)
                const int ci = pick_garrison_colony(w, power, u.x, u.y);
                if (ci < 0) { u.ai_state = '0'; }
                else if (u.x == w.colonies[ci].x && u.y == w.colonies[ci].y) {
                    u.ai_state = 'V';                  // already there (@0x04E9F0)
                    continue;
                } else {
                    u.target_x = w.colonies[ci].x; u.target_y = w.colonies[ci].y;
                    u.ai_state = '3';
                }
            }
        }

        // --- execute: step within the budget (allowance - spent >= 3, @0x03EE95) ---
        const int allowance = ai_move_allowance(rd, u.type);
        const bool wander = (u.ai_state == '8');
        bool moved = false;
        while (u.alive && allowance - u.ai_spent >= 3) {
            if (!wander && u.target_x < 0) break;
            int dir;
            if (wander) {
                if (u.ai_steps <= 0) break;
                dir = rng(0, 7);                      // random-walk step (@0x050D58)
                static const int DXW[8] = {1, 1, 0, -1, -1, -1, 0, 1};
                static const int DYW[8] = {0, 1, 1, 1, 0, -1, -1, -1};
                const int t = w.terrain_id(u.x + DXW[dir], u.y + DYW[dir]);
                const bool ok = naval ? water_id(t) : land_ok(t);
                if (!ok) { --u.ai_steps; continue; }
            } else {
                dir = ai_pick_heading(w, rd, u, i, settler && u.ai_state == '1', rng);
            }
            if (dir == 8) break;                      // stay (heading 8, @0x051A95)
            static const int DX[8] = {1, 1, 0, -1, -1, -1, 0, 1};
            static const int DY[8] = {0, 1, 1, 1, 0, -1, -1, -1};
            u.x += DX[dir]; u.y += DY[dir];
            u.heading = dir;                          // write heading +0x314F (@0x051A95)
            u.ai_spent += 3;                          // step charge +3 (@0x05CAE2)
            moved = true;
            if (wander) --u.ai_steps;
            reveal_around(w, u.x, u.y, 1, power);     // AI powers track their own fog
            if (u.x == u.target_x && u.y == u.target_y) break;
        }

        // --- arrival / tail handling (func_04E2D6 tail + ai.md 4) ---
        if (u.target_x >= 0 && u.x == u.target_x && u.y == u.target_y) {
            if (settler && u.ai_state == '1' &&
                colony_near(w, u.x, u.y, 1) < 0 &&
                colony_site_value(w, rd, u.x, u.y) >= SITE_BAR) {
                Colony c;                              // found: the unit is absorbed ('=',
                c.x = u.x; c.y = u.y;                  //   type mutated @0x04F20E)
                c.owner_power = power; c.human = false;
                c.population = 1;
                c.center_terrain = w.terrain_id(u.x, u.y) & 0x1F;
                c.center_food = 3;
                Colony::Worker wk; wk.profession = 19; wk.tile = 0; wk.good = 0;
                wk.terrain = c.center_terrain;
                c.workers.push_back(wk);
                w.colonies.push_back(c);
                Unit& uu = w.units[i];                 // push_back may reallocate elsewhere;
                uu.ai_state = '=';                     //   re-take the reference
                uu.alive = false;
                continue;
            }
            const int ci = colony_near(w, u.x, u.y, 0);
            if (ci >= 0 && w.colonies[ci].owner_power == power && !settler) {
                u.ai_state = 'V';                      // arrived at the colony (@0x04E9F0)
                u.target_x = u.target_y = -1;
                continue;
            }
            if (u.ai_state == '2' || u.ai_state == 'D') {
                u.target_x = u.target_y = -1;          // frontier reached; retarget next pass
                continue;
            }
            if (u.ai_state == 'N') {                   // pioneer reached the worksite: the
                u.ai_state = '0';                      //   next pass dispatch starts the build
                u.target_x = u.target_y = -1;
                continue;
            }
            if (naval && u.ai_state == '1') {
                u.ai_state = 'B';                      // ship reached goto: '1' -> 'B' (@0x051D37)
                u.target_x = u.target_y = -1;
                continue;
            }
            u.ai_state = 'U';                          // sitting on the stored target (@0x0508D7)
            u.target_x = u.target_y = -1;
            continue;
        }
        if (u.target_x >= 0 && allowance - u.ai_spent < 3) {
            // Budget exhausted mid-route: the mission char persists across turns
            // (the re-entry tests, e.g. '2' @0x04E66B, '8' @0x050C9D). Routing
            // into a colony gets its own char when the entering step is next
            // ('L', @0x04EA53); a unit that could not step AT ALL is marked out-
            // of-budget ('9' @0x051A5E, the forced-stay branch).
            if ((u.ai_state == '3' || u.ai_state == 'L' || u.ai_state == '9') &&
                octile(u.target_x - u.x, u.target_y - u.y) <= 1)
                u.ai_state = 'L';
            else if (!moved)
                u.ai_state = '9';
            continue;
        }
        if (!moved && u.target_x < 0 && u.ai_state != 'G') {
            // stayed put with no goal: the sentry toggle (@0x051AB0) -- order 5,
            // promoted to fortify when transient bit 0x3148&2 is set (@0x051AB9).
            u.ai_state = '0';
            if (u.order != ORDER_FORTIFY && u.order != ORDER_FORTIFIED &&
                u.order != ORDER_SENTRY)
                u.order = (u.ai_flags & 0x2) ? ORDER_FORTIFY : ORDER_SENTRY;
        }
        // tail wake (@0x051C68): a sentried AI unit with an adjacent enemy wakes.
        if (u.order == ORDER_SENTRY && adjacent_enemy(w, power, u.x, u.y))
            u.order = ORDER_NONE;
    }
}

} // namespace vc::sim
