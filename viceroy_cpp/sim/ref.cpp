// sim/ref.cpp -- see ref.hpp.
#include "ref.hpp"

namespace vc::sim {

Ref ref_start(int d, const RuleData& rd) {
    const Config& cfg = rd.cfg;
    Ref r;
    r.regulars  = cfg.ref_regulars_scale  * d + cfg.ref_regulars_offset;
    r.cavalry   = cfg.ref_cavalry_scale   * d + cfg.ref_cavalry_offset;
    r.manowar   = cfg.ref_manowar_scale   * d + cfg.ref_manowar_offset;
    r.artillery = cfg.ref_artillery_scale * d + cfg.ref_artillery_offset;
    return r;
}

int ref_accrue_rate(int d, int year, const RuleData& rd) {
    const Config& cfg = rd.cfg;
    int rate = cfg.ref_accrue_scale * d + cfg.ref_accrue_offset;
    for (int gate : cfg.ref_accrue_gate_years)
        if (year >= gate) rate *= 2;
    return rate;
}

void ref_purchase(Ref& ref, int64_t& royal_money, const RuleData& rd) {
    const Config& cfg = rd.cfg;
    while (royal_money >= cfg.ref_unit_cost) {
        if (ref.regulars + 2 > cfg.ref_cavalry_ratio * ref.cavalry)
            ref.cavalry += 1;                       // 1 cav per N reg
        else if (ref.regulars > cfg.ref_artillery_ratio * ref.artillery)
            ref.artillery += 1;                     // 1 art per N reg
        else if (ref.regulars + ref.cavalry + ref.artillery + 5 > cfg.ref_naval_ratio * ref.manowar)
            ref.manowar += 1;                       // 1 naval per N land
        else
            ref.regulars += 1;                      // default
        royal_money -= cfg.ref_unit_cost;
    }
}

} // namespace vc::sim
