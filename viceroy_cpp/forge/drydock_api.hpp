// forge/drydock_api -- the store-backed HTTP surface for the Drydock editor
// views (spec §5, hosted in the web shell per the Phase-0 ruling). One global
// Store loaded from data/ at serve start; every mutation goes through the
// store chokepoint; saving re-serializes DIRTY records to canonical text,
// one record per file (spec §4.1 "saving = deterministically re-serializing
// changed records").
#pragma once
#include "httpd.hpp"
#include "json.hpp"
#include "rules.hpp"
#include <string>
#include <vector>

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

// The /api/messages payload built from the store's msge records (same shape as
// the legacy messages.json: {"messages":[{key,text,box_w,x,y,sprite,speaker,
// default}...]}). False when the store is not loaded (caller serves the file).
bool drydock_messages_json(std::string& out);

// Store-authoritative @SECTION text lines (the labels_section cutover).
// Accepts "MISC" or "@MISC". False when the store is off or the section is
// not migrated -- the caller falls back to the frozen _sections.json.
bool drydock_text_lines(const std::string& section, std::vector<std::string>& out);

// Overlay the migrated sections of <file>_sections.json (file = "LABELS" |
// "NAMES" | "COLONY" | "MENU") with the store's text records, in place.
void drydock_text_overlay(JsonValue& doc, const std::string& file);

// Route a /api/dd/* request. After any successful mutation the migrated rule
// values are re-applied onto *live_rules (the live game follows the store).
HttpResponse drydock_route(const std::string& method, const std::string& path,
                           const std::string& query, const std::string& body,
                           vc::sim::RuleData* live_rules);

} // namespace forge
