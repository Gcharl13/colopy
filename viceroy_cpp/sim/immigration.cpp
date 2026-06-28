// sim/immigration.cpp -- see immigration.hpp.
#include "immigration.hpp"

namespace vc::sim {

constexpr int FREE_COLONIST = 0x1C;   // @JOB type id (full distribution = P2)

int crosses_threshold(int total_workers, int unit_count,
                      int difficulty, bool ai, int player_idx) {
    int a = total_workers + unit_count;
    if (a < 4000) a = a * 2 + 8;
    if (a > 4000) a = 4000;
    if (ai) a = a * (8 - difficulty) / 8;
    if (player_idx == 0) a = a * 2 / 3;           // England immigration bonus
    return a;
}

ImmigrationResult immigration_step(Power& p, int crosses_gained,
                                   int total_workers, int unit_count,
                                   int difficulty, bool ai, int player_idx,
                                   const RandFn& rng) {
    p.crosses_accum += crosses_gained;
    p.crosses_threshold = crosses_threshold(total_workers, unit_count,
                                            difficulty, ai, player_idx);
    ImmigrationResult r;
    if (p.crosses_accum > p.crosses_threshold) {
        r.slot = rng(0, 2);                       // random dock slot
        r.type = FREE_COLONIST;
        r.spawned = true;
        p.dock_pool[r.slot] = r.type;
        p.crosses_accum = 0;
    }
    return r;
}

} // namespace vc::sim
