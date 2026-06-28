// sim/immigration.cpp -- see immigration.hpp.
#include "immigration.hpp"

namespace vc::sim {

constexpr int FREE_COLONIST = 0x1C;   // @JOB type id (full distribution = P2)

int crosses_threshold(int total_workers, int unit_count,
                      int difficulty, bool ai, int player_idx, const RuleData& rd) {
    const Config& cfg = rd.cfg;
    int a = total_workers + unit_count;
    if (a < cfg.imm_threshold_cap) a = a * cfg.imm_sub4k_mult + cfg.imm_sub4k_offset;
    if (a > cfg.imm_threshold_cap) a = cfg.imm_threshold_cap;
    if (ai) a = a * (cfg.imm_ai_scale - difficulty) / cfg.imm_ai_divisor;
    if (player_idx == 0) a = a * cfg.imm_england_num / cfg.imm_england_den;  // England bonus
    return a;
}

ImmigrationResult immigration_step(Power& p, int crosses_gained,
                                   int total_workers, int unit_count,
                                   int difficulty, bool ai, int player_idx,
                                   const RandFn& rng, const RuleData& rd) {
    p.crosses_accum += crosses_gained;
    p.crosses_threshold = crosses_threshold(total_workers, unit_count,
                                            difficulty, ai, player_idx, rd);
    ImmigrationResult r;
    if (p.crosses_accum > p.crosses_threshold) {
        r.slot = rng(0, rd.cfg.imm_dock_slots - 1);   // random dock slot
        r.type = FREE_COLONIST;
        r.spawned = true;
        p.dock_pool[r.slot] = r.type;
        p.crosses_accum = 0;
    }
    return r;
}

} // namespace vc::sim
