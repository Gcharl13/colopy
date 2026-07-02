// sim/immigration.cpp -- see immigration.hpp.
#include "immigration.hpp"

namespace vc::sim {

constexpr int PETTY_CRIMINAL     = 0x19;
constexpr int INDENTURED_SERVANT = 0x1A;
constexpr int FREE_COLONIST      = 0x1C;

// Dock-slot refill distribution (func_034C24, immigration.md 3.3, BYTE_VERIFIED structure):
// roll random_int(1,15) against a difficulty-scaled threshold (diff + addend)/2 -- the addend
// is elided in the spec disassembly note, so it is a named knob (RECONSTRUCTED default 8).
// High tier: Indentured Servant 0x1A, or Free Colonist 0x1C with William Brewster (FF 0x14).
// Low tier: random_int(1,10) over the criminal/servant/free classes (the exact bucket mapping
// is elided in the spec -- RECONSTRUCTED near-even split). Harder difficulty => higher
// threshold => more low-tier colonists; Brewster shifts the pool toward the top class.
int immigrant_refill(int difficulty, bool has_brewster, const RandFn& rng, const RuleData& rd) {
    int threshold = (difficulty + rd.cfg.imm_refill_addend) / 2;
    if (rng(1, 15) >= threshold)
        return has_brewster ? FREE_COLONIST : INDENTURED_SERVANT;
    int low = rng(1, 10);
    if (low <= 3) return PETTY_CRIMINAL;
    if (low <= 6) return INDENTURED_SERVANT;
    return FREE_COLONIST;
}

int crosses_threshold(int total_workers, int unit_count,
                      int difficulty, bool ai, bool is_england, const RuleData& rd) {
    const Config& cfg = rd.cfg;
    int a = total_workers + unit_count;
    if (a < cfg.imm_threshold_cap) a = a * cfg.imm_sub4k_mult + cfg.imm_sub4k_offset;
    if (a > cfg.imm_threshold_cap) a = cfg.imm_threshold_cap;
    // The (8 - difficulty)/8 scale applies UNCONDITIONALLY (func_035D9A @0x35E60,
    // difficulty.md) -- the earlier AI-only gate was the audit-corrected misread.
    (void)ai;
    a = a * (cfg.imm_ai_scale - difficulty) / cfg.imm_ai_divisor;
    if (is_england) a = a * cfg.imm_england_num / cfg.imm_england_den;  // England nation bonus
    return a;
}

ImmigrationResult immigration_step(Power& p, int crosses_gained,
                                   int total_workers, int unit_count,
                                   int difficulty, bool ai, bool is_england,
                                   const RandFn& rng, const RuleData& rd,
                                   bool has_brewster) {
    p.crosses_accum += crosses_gained;
    p.crosses_threshold = crosses_threshold(total_workers, unit_count,
                                            difficulty, ai, is_england, rd);
    ImmigrationResult r;
    if (p.crosses_accum > p.crosses_threshold) {
        // func_0363A2: a random dock slot's STORED colonist arrives, then the emptied slot
        // is refilled by the func_034C24 distribution. An unseeded (-1) slot generates on
        // the fly (the original seeds the dock at game start).
        r.slot = rng(0, rd.cfg.imm_dock_slots - 1);
        int stored = p.dock_pool[r.slot];
        r.type = stored >= 0 ? stored : immigrant_refill(difficulty, has_brewster, rng, rd);
        r.spawned = true;
        p.dock_pool[r.slot] = immigrant_refill(difficulty, has_brewster, rng, rd);
        p.crosses_accum = 0;
    }
    return r;
}

} // namespace vc::sim
