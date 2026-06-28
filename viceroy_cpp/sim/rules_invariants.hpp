// sim/rules_invariants.hpp -- validate a RuleData (the modded-data guard).
//
// The golden-master vectors in sim_tests assert the DEFAULT outputs and so cannot
// double as a mod validator (any edit fails them by construction). This is the
// other half of the split harness: a suite of invariants that must hold for ANY
// ruleset -- ranges, referential integrity, and a few behavioral sanity checks
// (run via the real sim). The Forge runs check_rules() on every edited overlay so
// a bad mod is caught before it ships.
#pragma once

#include "rules.hpp"
#include <string>
#include <vector>

namespace vc::sim {

struct InvariantReport {
    std::vector<std::string> violations;
    bool ok() const { return violations.empty(); }
};

// Validate a ruleset. Empty report == valid. Checks structural ranges (no
// negative stats/costs, divisors > 0, shifts in [0,30], gate years ascending,
// move_class in {0,1,6,99}) and light behavioral invariants (SoL converges into
// [0,100]; price still falls when a good is being sold).
InvariantReport check_rules(const RuleData& rd);

} // namespace vc::sim
