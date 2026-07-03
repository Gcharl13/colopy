// forge/drydock_api -- the store-backed HTTP surface for the Drydock editor
// views (spec §5, hosted in the web shell per the Phase-0 ruling). One global
// Store loaded from data/ at serve start; every mutation goes through the
// store chokepoint; saving re-serializes DIRTY records to canonical text,
// one record per file (spec §4.1 "saving = deterministically re-serializing
// changed records").
#pragma once
#include "httpd.hpp"
#include "rules.hpp"
#include <string>

namespace forge {

// Load schema + data/base into the global Drydock store. Safe to call once at
// serve start; returns false with msg on error (store left empty).
bool drydock_store_init(const std::string& data_dir, std::string& msg);

// True when a /api/dd/* path should be handled here.
bool drydock_handles(const std::string& path);

// True once the store is loaded -- migrated types then take authority over
// their legacy JSON-binding paths (strangler cutover, GAP-ANALYSIS 5).
bool drydock_active();

// Re-patch the in-memory legacy JSON tables from the store (write-through for
// the un-cut-over @SECTION[...] readers). No-op until the store is loaded.
// Call after invalidate_tables() so a legacy reload cannot shadow the store.
void drydock_repatch_tables();

// Route a /api/dd/* request. After any successful mutation the migrated rule
// values are re-applied onto *live_rules (the live game follows the store).
HttpResponse drydock_route(const std::string& method, const std::string& path,
                           const std::string& query, const std::string& body,
                           vc::sim::RuleData* live_rules);

} // namespace forge
