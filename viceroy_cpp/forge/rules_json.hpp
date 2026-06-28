// forge/rules_json.hpp -- load a rules.json mod overlay onto a base RuleData.
//
// Overlay format (all sections optional; sparse -- only changed values):
//   {
//     "cfg": { "warehouse_cap_base": 150, "ref_unit_cost": 1500,
//              "ff_gate_years": [1600,1640,1680,1720] },
//     "units": { "Soldiers": {"attack":4,"defense":3}, "11": {"attack":9} },
//     "terrain_defense": { "28": 6 }
//   }
// Unit keys may be a display name or a numeric index; terrain keys are numeric ids.
#pragma once

#include "json.hpp"
#include "rules.hpp"   // vc::sim::RuleData / make_default_rules()
#include <string>
#include <vector>

namespace forge {

struct OverlayResult {
    vc::sim::RuleData rules;
    std::vector<std::string> warnings;   // unknown keys / out-of-range ids
};

// Apply a parsed overlay document onto `base`.
OverlayResult apply_overlay(const JsonValue& root, vc::sim::RuleData base);

// Parse and apply a rules.json file onto `base` (default = the historical rules).
OverlayResult load_overlay(const std::string& path,
                           vc::sim::RuleData base = vc::sim::make_default_rules());

} // namespace forge
