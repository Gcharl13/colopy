// forge/drydock_bridge -- the strangler seam between the Drydock record store
// and the sim's RuleData (GAP-ANALYSIS §5). Dev builds load the canonical text
// directly (spec §4.1); values are proven identical to the compiled defaults
// by the drydock_parity ctest, so applying them changes no behavior -- it
// changes the SOURCE OF TRUTH for the migrated types (GOOD/UNIT/PROF).
#pragma once
#include "rules.hpp"
#include "../drydock/text/rec_text.hpp"
#include <string>
#include <vector>

namespace forge {

// Load data/schema + data/base/{good,unit,prof} from `data_dir` and apply the
// record values onto `rd` (units/cargo/jobs by each record's EXE-parity
// `index`). Returns true and sets `msg` to a one-line summary on success;
// returns false with the error in `msg` (rd left untouched -- never crash on
// bad data, spec §6.2). A missing data/ dir is "false" with an empty msg.
bool drydock_apply_base(vc::sim::RuleData& rd, const std::string& data_dir,
                        std::string& msg);

// Apply already-parsed records onto rd (the store-backed API uses this to keep
// the live game in lockstep after edits). Unknown types/indices are skipped.
// include_conf: CONF scalars apply only at startup (before the Rules overlay
// loads on top); live /api/dd edits skip them so overlay cfg edits survive
// until overlays are subsumed at P5.
void drydock_apply_records(vc::sim::RuleData& rd,
                           const std::vector<drydock::Record>& recs,
                           bool include_conf = false);

} // namespace forge
