// forge/store.hpp -- the unified cell accessor over the one path grammar (A2).
//
// The database-first model addresses every value -- reference data, dynamic state,
// and config scalars -- through ONE path grammar. cell_get/cell_set are that single
// entry point:
//   reference  @SECTION[row].col          (via resolve_binding -> table_cell)
//   state      game.* / power<N>.* / colony<N>.* / unit<N>.* / native<N>.* / ...
//   config     cfg.<name>                 (the Config scalars, newly addressable)
//
// State + reference delegate to the existing byte-verified resolver (behavior-preserving);
// config is resolved here against the active RuleData. This makes the third table kind
// (config) reachable by the same grammar the graphs/screens already use.
#pragma once

#include "engine.hpp"   // EngineCtx, resolve_binding, set_binding
#include "rules.hpp"    // vc::sim::Config
#include <string>
#include <vector>

namespace forge {

// Read any cell by path. cfg.<name> reads the active Config; everything else delegates
// to resolve_binding (reference + state). Returns Null for an unknown path.
JsonValue cell_get(const std::string& path, const EngineCtx& cx);

// Write any cell by path. State delegates to set_binding. cfg.* is read-only through the
// store (edit config via the Rules overlay); returns false for cfg.* and unknown paths.
bool cell_set(const std::string& path, double value, EngineCtx& cx);

// Config scalar access (the cfg.* table), used by cell_get + schema coverage.
bool cfg_get(const vc::sim::Config& c, const std::string& name, double& out);
const std::vector<std::string>& cfg_field_names();

} // namespace forge
