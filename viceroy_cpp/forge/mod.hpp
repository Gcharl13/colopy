// forge/mod.hpp -- mod packaging: write/load/validate a Forge mod directory.
//
// A mod is a directory with a manifest plus sparse overrides the runtime layers
// onto the base content:
//   mymod/
//     modinfo.json   id, name, version, author, spec_version
//     rules.json     sparse RuleData overlay (omitted if no rule changes)
//     map.mp         a replacement map (optional)
// load_mod applies rules.json onto the base ruleset and validates it with the sim
// invariants, and validates map.mp with the map checker -- so "publish" and "is
// this mod sound?" reuse the exact same engine the clients run.
#pragma once

#include "mapedit.hpp"
#include "rules.hpp"

#include <string>
#include <vector>

namespace forge {

constexpr int FORGE_SPEC_VERSION = 1;   // bumped when the data schema changes

struct ModInfo {
    std::string id, name, version, author;
    int spec_version = FORGE_SPEC_VERSION;
};

// Write a mod directory. Emits modinfo.json always; rules.json only if cur differs
// from base; map.mp only if `map` is given. Returns the files written. Throws on
// I/O error.
struct ModWriteResult { std::vector<std::string> written; };
ModWriteResult write_mod(const std::string& dir, const ModInfo& info,
                         const vc::sim::RuleData& base, const vc::sim::RuleData& cur,
                         const MpFile* map = nullptr);

// Load + validate a mod directory.
struct ModReport {
    ModInfo info;
    bool found = false;             // modinfo.json parsed
    bool has_rules = false, has_map = false;
    vc::sim::RuleData rules;        // base + applied overlay
    std::vector<std::string> issues;    // hard failures (invalid rules / map)
    std::vector<std::string> warnings;  // overlay warnings, spec-version mismatch
    bool ok() const { return issues.empty(); }
};
ModReport load_mod(const std::string& dir,
                   vc::sim::RuleData base = vc::sim::make_default_rules());

} // namespace forge
