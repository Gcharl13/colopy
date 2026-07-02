// sim/explore.cpp -- see explore.hpp for the byte citations.
#include "explore.hpp"
#include "unit.hpp"

namespace vc::sim {

int sight_radius(int unit_type, bool owner_has_de_soto) {
    if (unit_type == SCOUTS) return 2;                                   // @0x665E
    if (unit_type == GALLEON || unit_type == PRIVATEER || unit_type == FRIGATE)
        return 2;                                                        // @0x6619..0x662E
    if (owner_has_de_soto && unit_type >= CARAVEL && unit_type <= MAN_O_WAR)
        return 2;                                                        // naval-only de Soto boost (0x0D..0x12)
    return 1;                                                            // @0x6610 default
}

void reveal_around(World& w, int x, int y, int r, int player) {
    if (w.map_w <= 0 || w.map_h <= 0 || player < 0 || player > 3) return;
    if (w.fog.empty()) w.fog.assign((size_t)w.map_w * w.map_h, 0);
    const uint8_t bit = (uint8_t)(1u << (player + 4));
    for (int dy = -r; dy <= r; ++dy)
        for (int dx = -r; dx <= r; ++dx) {
            int tx = x + dx, ty = y + dy;
            if (tx < 0 || tx >= w.map_w || ty < 0 || ty >= w.map_h) continue;
            w.fog[(size_t)ty * w.map_w + tx] |= bit;                     // func_00631A OR
        }
}

void reveal_step(World& w, uint32_t human_ff_owned) {
    if (w.map_w <= 0 || w.map_h <= 0) return;
    const bool de_soto = (human_ff_owned >> 7) & 1u;                     // FF #7 = Hernando de Soto
    for (const Unit& u : w.units)
        if (u.alive)
            reveal_around(w, u.x, u.y,
                          sight_radius(u.type, u.owner == 0 && de_soto), u.owner);
    for (const Colony& c : w.colonies)
        if (c.x >= 0)
            reveal_around(w, c.x, c.y, 5, c.owner_power);                // func_0063B6 +/-5
}

bool scout_infiltrate(GameState& g, World& w, int unit_idx, int colony_idx,
                      const RandFn& rng) {
    if (unit_idx < 0 || unit_idx >= (int)w.units.size()) return false;
    if (colony_idx < 0 || colony_idx >= (int)w.colonies.size()) return false;
    Unit& u = w.units[unit_idx];
    Colony& c = w.colonies[colony_idx];
    int roll = rng(1, 36);                            // random_int(1,36) @0x5A2DC
    if (u.profession == 0x16) roll >>= 1;             // Seasoned Scout: sar @0x5A2F2
    int threshold = (g.difficulty + 6) * 2;           // (X+6)*2; X RECONSTRUCTED = difficulty
    if (c.human) threshold += g.difficulty - 2;       // +(diff-2) vs a human target
    if (roll <= threshold) {
        reveal_around(w, c.x, c.y, 1, u.owner);       // colony info revealed
        c.food_accum += 100;                          // the target's +0xAA bump by 100
        return true;
    }
    u.alive = false;                                  // caught (@0x5A3EA)
    c.stockpile[HORSES] += 50;                        // @LOSTTHEIRSCOUTS: mounts to the
    return false;                                     //   stables (count RECONSTRUCTED)
}

} // namespace vc::sim
