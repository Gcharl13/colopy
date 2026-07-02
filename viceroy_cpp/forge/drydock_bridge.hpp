// forge/drydock_bridge -- the strangler seam between the Drydock record store
// and the sim's RuleData (GAP-ANALYSIS §5). Dev builds load the canonical text
// directly (spec §4.1); values are proven identical to the compiled defaults
// by the drydock_parity ctest, so applying them changes no behavior -- it
// changes the SOURCE OF TRUTH for the migrated types (GOOD/UNIT/PROF).
#pragma once
#include "rules.hpp"
#include <string>

namespace forge {

// Load data/schema + data/base/{good,unit,prof} from `data_dir` and apply the
// record values onto `rd` (units/cargo/jobs by each record's EXE-parity
// `index`). Returns true and sets `msg` to a one-line summary on success;
// returns false with the error in `msg` (rd left untouched -- never crash on
// bad data, spec §6.2). A missing data/ dir is "false" with an empty msg.
bool drydock_apply_base(vc::sim::RuleData& rd, const std::string& data_dir,
                        std::string& msg);

} // namespace forge
