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

// Build a SPARSE overlay document capturing only what differs in `cur` vs `base`
// (changed cfg scalars/arrays, changed unit fields keyed by name, changed
// terrain_defense/terrain_move ids). Empty object when identical. This is the
// inverse of apply_overlay: apply_overlay(overlay_diff(base,cur), base) == cur.
JsonValue overlay_diff(const vc::sim::RuleData& base, const vc::sim::RuleData& cur);

// Build a COMPLETE overlay document listing EVERY value in `rd` (all cfg scalars
// + arrays, every unit's full stats by name, every terrain_defense/terrain_move
// id). Applying it onto any base reproduces `rd` exactly. Used to load the whole
// real ruleset into the editor.
JsonValue full_overlay(const vc::sim::RuleData& rd);

// Write overlay_diff(base, cur) to a rules.json file.
void save_overlay(const std::string& path,
                  const vc::sim::RuleData& base, const vc::sim::RuleData& cur);

} // namespace forge
