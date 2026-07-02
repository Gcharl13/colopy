// sim/events.cpp -- see events.hpp for the byte citations (func_061454).
#include "events.hpp"
#include "unit.hpp"
#include <algorithm>

namespace vc::sim {

bool rumor_present(const World& w, int x, int y, int seed) {
    if (w.map_w <= 0 || x < 0 || y < 0 || x >= w.map_w || y >= w.map_h) return false;
    const int t = w.terrain_id(x, y);
    if (t < 0 || t == 24 || t == 25 || t == 26) return false;   // Arctic/Ocean/Sea Lane gate
    if (w.improve_at(x, y) & RUMOR_BIT) return false;           // consumed / suppressed
    const int h = (((x >> 2) * 0x13 + (y >> 2) * 0x11 + seed + 8) & 0x1F) - (y & 3) * 4;
    return h == (x & 3);
}

RumorResult lost_city_rumor(GameState& g, World& w, int unit_idx,
                            bool de_soto, const RandFn& rng) {
    RumorResult r;
    if (unit_idx < 0 || unit_idx >= (int)w.units.size()) return r;
    Unit& u = w.units[unit_idx];
    r.unit = unit_idx; r.x = u.x; r.y = u.y;
    w.improve_set(u.x, u.y, RUMOR_BIT);             // consume: the stored state suppresses
    // scout level s: unit type Scout (@0x614A6) + Seasoned class 0x16 (@0x614BB)
    // + de Soto (exploration.md func_061454 note; he also forces positive rerolls)
    int s = (u.type == SCOUTS ? 1 : 0) + (u.profession == 0x16 ? 1 : 0) + (de_soto ? 1 : 0);
    auto d = [&](int n_, int faces) { int t = 0; for (int i = 0; i < n_; ++i) t += rng(1, faces); return t; };
    // Anti-streak floor (events.md 2, [bp-0x2C]): min(prev+1, 3), rising by 1
    // each rumor per power -- once it reaches 3, every outcome is forced >= 3
    // (the good low outcomes FoY/Cibola are only reachable on the first rumors).
    const int pw_i = u.owner & 3;
    const int floor_n = std::min(g.rumor_floor[pw_i] + 1, 3);
    g.rumor_floor[pw_i] = floor_n;
    int n = rng(1, 9);                              // the base outcome roll (@0x614F6)
    if (n < floor_n) n = floor_n;
    // Quality-roll demotions (@0x6159A/@0x61646): q = random_int(1,100)+scout*10
    // vs thresholds 10/25; the per-game caps [0x1DC6] (1 Fountain) / [0x1DC7]
    // (7 Cibolas) demote further finds.
    const int q = rng(1, 100) + s * 10;
    if (n == 1 && (q < 10 || g.fountains_found >= 1))
        n = q < 10 ? 5 : 6;                         // FoY -> vanish / nothing
    if (n == 2 && (q < 25 || g.cibolas_found >= 7))
        n = 4;                                      // Cibola -> burial-treasure
    // bad-outcome escape (5 vanish / 8 shrines): reroll via random_int(1, s+1)
    // (exploration.md); de Soto forces positive -- reroll until benign (bounded).
    for (int tries = 0; (n == 5 || n == 8) && tries < 8; ++tries) {
        if (de_soto || rng(1, s + 1) > 1) { n = rng(1, 9); if (n < floor_n) n = floor_n; }
        else break;
    }
    if (n == 1) ++g.fountains_found;                // inc @0x614E6
    if (n == 2) ++g.cibolas_found;                  // inc @0x616C9
    r.n = n;
    Power& owner = g.powers[u.owner & 3];
    switch (n) {
        case 1: r.immigrants = 8; break;            // Fountain of Youth: 8 queued immigrants
        case 2: {                                   // Cibola: a Treasure unit (%NUMBER1 = value*100)
            int value = 10 * (s + 2) + rng(1, 20);
            Unit t; t.type = TREASURE; t.owner = u.owner; t.x = u.x; t.y = u.y;
            t.profession = value;                   // the treasure convention: stores gross/100
            t.alive = true; w.units.push_back(t);
            r.treasure = (long)value * 100;
            break;
        }
        case 3:                                     // ruins: gold 10*(3d8), scaled *(s+2)/2
            r.gold = (long)(10 * d(3, 8)) * (s + 2) / 2;
            break;
        case 4: {                                   // burial mounds sub-dispatch (@BURIAL1..3)
            r.burial = rng(1, 3);                   // sub-selection roll elided -> RECONSTRUCTED
            if (r.burial == 3 && g.burial_special_used[pw_i])
                r.burial = 2;                       // the treasure special fires ONCE per power
            if (r.burial == 3) g.burial_special_used[pw_i] = true;   // (@0x6186B bit 0x40)
            if (r.burial == 2) r.gold = 10 * d(3, 8);
            else if (r.burial == 3) {
                int value = 2 * (rng(1, 8) + 2 * (s + 5));
                Unit t; t.type = TREASURE; t.owner = u.owner; t.x = u.x; t.y = u.y;
                t.profession = value; t.alive = true; w.units.push_back(t);
                r.treasure = (long)value * 100;
            }
            break;
        }
        case 5: r.vanished = true; u.alive = false; break;   // expedition vanished
        case 6: break;                                        // nothing but rumors
        case 7: r.gold = 2 * d(4, 10); break;                 // friendly tribe's gift
        case 8: break;                                        // shrines: alarm applied by the caller
        case 9: {                                             // survivors join (count elided -> 1)
            r.colonists = 1;
            Unit c; c.type = COLONISTS; c.owner = u.owner; c.x = u.x; c.y = u.y;
            c.profession = 0x1C; c.alive = true; w.units.push_back(c);
            break;
        }
    }
    if (r.gold > 0) {                               // treasury credit @0x61C4C
        owner.gold += r.gold;
        if (owner.gold > 999999) owner.gold = 999999;
    }
    return r;
}

} // namespace vc::sim
