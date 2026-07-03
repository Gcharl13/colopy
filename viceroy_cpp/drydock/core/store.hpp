// drydock/core/store -- the in-memory record store (spec §10.3): the single
// source of truth both the editor and the engine read. Per type: a contiguous
// record array + an ID->index hash; globally: u32 handles, the bidirectional
// reference index, the dirty set, and the UNDO JOURNAL.
//
// THE CHOKEPOINT RULE (spec preamble #5): every mutation goes through
// store_set / store_add / store_delete. Nothing else writes a record --
// that single funnel is what makes global undo/redo and (later) per-field
// provenance fall out for free.
//
// P1 storage note: records are held as generic parsed Records rather than the
// codegen'd structs -- at a few MB of game the difference is noise, every
// generic view works off the schema/reflection anyway, and the typed structs
// remain the bridge's access path. Revisit if a profiler ever cares.
#pragma once
#include "../schema/schema.hpp"
#include <unordered_map>
#include <map>
#include <set>

namespace drydock {

// u32 handle: type index << 24 | instance index (spec §3.1). Runtime-only,
// never serialized.
using Handle = uint32_t;
constexpr Handle DD_NULL_HANDLE = 0xFFFFFFFFu;

struct StoreOp {                          // one journal entry (inverse op data)
    enum Kind : uint8_t { Set, Add, Del } kind = Set;
    std::string id;                       // record id
    std::string field;                    // Set only
    bool  had_before = false;             // Set: field existed before
    bool  has_after  = false;             // Set: field exists after (false = cleared)
    Value before, after;                  // Set payloads
    Record rec;                           // Add/Del: the whole record
};

struct Store {
    Schema schema;
    std::vector<std::string>                             type_codes;  // idx -> code
    std::map<std::string, uint32_t>                      type_index;  // code -> idx
    std::vector<std::vector<Record>>                     records;     // per type, contiguous
    std::vector<std::unordered_map<std::string, uint32_t>> id_to_idx; // per type: id -> instance
    // bidirectional ref index (spec §3.3): src id -> (field, dst id) and back
    std::multimap<std::string, std::pair<std::string, std::string>> refs_out;
    std::multimap<std::string, std::pair<std::string, std::string>> refs_in;
    // undo journal: ops [0, pos) are done; redo replays [pos, size)
    std::vector<StoreOp> journal;
    size_t journal_pos = 0;
    std::set<std::string> dirty;          // ids touched since last save
};

// Build the store from a schema + parsed records (indexes + ref index).
bool store_init(Store& s, Schema schema, std::vector<Record> recs, std::string& err);

// Lookup. Handles are (type<<24)|instance; invalidated by delete (P1: dense
// re-index on delete keeps arrays contiguous -- handles are session-transient).
Record*       store_find(Store& s, const std::string& id);
const Record* store_find(const Store& s, const std::string& id);
Handle        store_handle(const Store& s, const std::string& id);

// ---- THE mutation chokepoint --------------------------------------------------
// Set (value != nullptr) or clear (value == nullptr) one field. Validates the
// field against the schema first; maintains the ref index; journals the
// inverse; marks dirty. Returns false with err on any rejection.
bool store_set(Store& s, const std::string& id, const std::string& field,
               const Value* value, std::string& err);

// Add a whole record (id must be new, type known). Journaled.
bool store_add(Store& s, Record r, std::string& err);

// Delete: REFUSED if any inbound refs exist (safe delete, spec §3.3) --
// err lists them. Journaled with the full record for undo.
bool store_delete(Store& s, const std::string& id, std::string& err);

bool store_undo(Store& s, std::string& err);
bool store_redo(Store& s, std::string& err);

// Used-by: (src id, field) pairs referencing `id`, sorted.
std::vector<std::pair<std::string, std::string>> store_used_by(const Store& s, const std::string& id);

} // namespace drydock
