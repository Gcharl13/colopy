// forge/formulas.hpp -- a complete, read-only catalog of every formula/function
// the sim computes. The Rules tab exposes the *data* (unit stats, terrain, the ~45
// scalar `cfg` constants), which is tunable. This catalog exposes the *logic* that
// consumes that data -- the formula shapes themselves -- so the whole ruleset is
// visible end to end. Each entry names the exact knobs (cfg keys) that feed it, or
// is marked as fixed code logic (a "code wall") when no knob tunes it.
//
// The expressions are transcribed faithfully from sim/*.cpp; this catalog is built
// by hand (not parsed) and must be kept in step with the source it documents.
#pragma once

#include "json.hpp"

namespace forge {

// The catalog as a JSON document:
//   { "note": "...",
//     "systems": [ { "name","source",
//                    "formulas":[ {"fn","title","expr","knobs":[...],"note"} ] } ] }
JsonValue formulas_catalog();

// A human-readable text dump (for `forge formulas`).
std::string formulas_text();

} // namespace forge
