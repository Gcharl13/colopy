// sim/unit.cpp -- see unit.hpp. The @UNIT stat table is now data-driven: stats
// come from a RuleData (sim/rules.hpp); default_rules() reproduces the original
// @UNIT literals exactly. Source: data_extracted @UNIT (attack/combat/cargo cols).
#include "unit.hpp"
#include "rules.hpp"

namespace vc::sim {

const UnitStats& unit_stats(const RuleData& rd, int type) {
    static const UnitStats zero{"", 0, 0, 0, 0, 0, 0};
    if (type < 0 || type >= NUNITTYPES) return zero;
    return rd.units[type];
}

const UnitStats& unit_stats(int type) {
    return unit_stats(default_rules(), type);
}

} // namespace vc::sim
