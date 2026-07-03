// drydock/core/store -- see store.hpp. All index maintenance lives in the
// private apply_* helpers so do/undo/redo share one code path.
#include "store.hpp"
#include <algorithm>

namespace drydock {

// ---- ref-index maintenance -----------------------------------------------------

static void refs_erase(std::multimap<std::string, std::pair<std::string, std::string>>& mm,
                       const std::string& key, const std::string& a, const std::string& b) {
    auto range = mm.equal_range(key);
    for (auto it = range.first; it != range.second; ++it)
        if (it->second.first == a && it->second.second == b) { mm.erase(it); return; }
}

// add/remove the ref edges contributed by one field value of record `id`
static void field_refs(Store& s, const Record& r, const std::string& field,
                       const Value& v, bool add) {
    const TypeDef* td = s.schema.find(r.type());
    const FieldDef* fd = td ? td->find(field) : nullptr;
    if (!fd || fd->type != FType::Ref || v.kind != ValKind::Token) return;
    if (add) {
        s.refs_out.insert({r.id, {field, v.s}});
        s.refs_in.insert({v.s, {r.id, field}});
    } else {
        refs_erase(s.refs_out, r.id, field, v.s);
        refs_erase(s.refs_in, v.s, r.id, field);
    }
}

static void record_refs(Store& s, const Record& r, bool add) {
    for (const auto& f : r.fields) field_refs(s, r, f.name, f.value, add);
}

// ---- core structure ------------------------------------------------------------

bool store_init(Store& s, Schema schema, std::vector<Record> recs, std::string& err) {
    s.schema = std::move(schema);
    for (const auto& [code, td] : s.schema.types) {
        (void)td;
        s.type_index[code] = (uint32_t)s.type_codes.size();
        s.type_codes.push_back(code);
        s.records.emplace_back();
        s.id_to_idx.emplace_back();
    }
    for (auto& r : recs) {
        auto ti = s.type_index.find(r.type());
        if (ti == s.type_index.end()) { err = r.id + ": no schema type"; return false; }
        auto& bucket = s.records[ti->second];
        if (!s.id_to_idx[ti->second].emplace(r.id, (uint32_t)bucket.size()).second) {
            err = r.id + ": duplicate id";
            return false;
        }
        bucket.push_back(std::move(r));
    }
    for (const auto& bucket : s.records)
        for (const auto& r : bucket) record_refs(s, r, true);
    return true;
}

Record* store_find(Store& s, const std::string& id) {
    auto dot = id.find('.');
    if (dot == std::string::npos) return nullptr;
    auto ti = s.type_index.find(id.substr(0, dot));
    if (ti == s.type_index.end()) return nullptr;
    auto& map = s.id_to_idx[ti->second];
    auto it = map.find(id);
    return it == map.end() ? nullptr : &s.records[ti->second][it->second];
}
const Record* store_find(const Store& s, const std::string& id) {
    return store_find(const_cast<Store&>(s), id);
}

Handle store_handle(const Store& s, const std::string& id) {
    auto dot = id.find('.');
    if (dot == std::string::npos) return DD_NULL_HANDLE;
    auto ti = s.type_index.find(id.substr(0, dot));
    if (ti == s.type_index.end()) return DD_NULL_HANDLE;
    auto it = s.id_to_idx[ti->second].find(id);
    if (it == s.id_to_idx[ti->second].end()) return DD_NULL_HANDLE;
    return (ti->second << 24) | it->second;
}

// ---- apply helpers (shared by do / undo / redo) ---------------------------------

static void apply_set(Store& s, const std::string& id, const std::string& field,
                      const bool has, const Value& v) {
    Record* r = store_find(s, id);
    if (!r) return;
    for (size_t i = 0; i < r->fields.size(); ++i)
        if (r->fields[i].name == field) {
            field_refs(s, *r, field, r->fields[i].value, false);
            if (has) {
                r->fields[i].value = v;
                field_refs(s, *r, field, v, true);
            } else {
                r->fields.erase(r->fields.begin() + i);
            }
            s.dirty.insert(id);
            return;
        }
    if (has) {                                       // field newly present
        r->fields.push_back({field, v});
        field_refs(s, *r, field, v, true);
        // keep canonical schema order in memory so serialization stays trivial
        std::string err;
        schema_canonicalize(s.schema, *r, err);
        s.dirty.insert(id);
    }
}

static void apply_add(Store& s, const Record& rec) {
    uint32_t t = s.type_index.at(rec.type());
    s.id_to_idx[t][rec.id] = (uint32_t)s.records[t].size();
    s.records[t].push_back(rec);
    record_refs(s, s.records[t].back(), true);
    s.dirty.insert(rec.id);
}

static void apply_del(Store& s, const std::string& id) {
    Record* r = store_find(s, id);
    if (!r) return;
    uint32_t t = s.type_index.at(r->type());
    uint32_t idx = s.id_to_idx[t].at(id);
    record_refs(s, *r, false);
    auto& bucket = s.records[t];
    bucket.erase(bucket.begin() + idx);
    s.id_to_idx[t].erase(id);
    for (auto& [rid, ridx] : s.id_to_idx[t])         // dense re-index (contiguous array)
        if (ridx > idx) --ridx;
    s.dirty.insert(id);
}

// truncate the redo tail, push, mark done
static void journal_push(Store& s, StoreOp op) {
    s.journal.resize(s.journal_pos);
    s.journal.push_back(std::move(op));
    s.journal_pos = s.journal.size();
}

// ---- public mutations ------------------------------------------------------------

bool store_set(Store& s, const std::string& id, const std::string& field,
               const Value* value, std::string& err) {
    Record* r = store_find(s, id);
    if (!r) { err = id + ": no such record"; return false; }
    const TypeDef* td = s.schema.find(r->type());
    const FieldDef* fd = td ? td->find(field) : nullptr;
    if (!fd) { err = id + ": unknown field '" + field + "'"; return false; }
    if (value) {                                     // validate the candidate value
        std::vector<std::string> ve;
        schema_validate_field(id, *fd, *value, ve);
        if (!ve.empty()) { err = ve.front(); return false; }
    } else if (fd->required) {
        err = id + ": cannot clear required field '" + field + "'";
        return false;
    }
    StoreOp op;
    op.kind = StoreOp::Set;
    op.id = id;
    op.field = field;
    if (const Value* cur = r->find(field)) { op.had_before = true; op.before = *cur; }
    if (value) { op.has_after = true; op.after = *value; }
    if (!op.had_before && !op.has_after) { err = ""; return true; }   // clearing absent: no-op
    apply_set(s, id, field, op.has_after, op.after);
    journal_push(s, std::move(op));
    return true;
}

bool store_add(Store& s, Record r, std::string& err) {
    if (!s.type_index.count(r.type())) { err = r.id + ": no schema type"; return false; }
    if (store_find(s, r.id)) { err = r.id + ": id already exists"; return false; }
    if (!schema_canonicalize(s.schema, r, err)) return false;
    std::vector<std::string> ve;
    schema_validate(s.schema, r, ve);
    if (!ve.empty()) { err = ve.front(); return false; }
    StoreOp op;
    op.kind = StoreOp::Add;
    op.id = r.id;
    op.rec = r;
    apply_add(s, r);
    journal_push(s, std::move(op));
    return true;
}

bool store_delete(Store& s, const std::string& id, std::string& err) {
    Record* r = store_find(s, id);
    if (!r) { err = id + ": no such record"; return false; }
    auto uses = store_used_by(s, id);
    if (!uses.empty()) {                             // safe delete (spec 3.3)
        err = id + ": refused, referenced by";
        for (const auto& [src, field] : uses) err += " " + src + "." + field;
        return false;
    }
    StoreOp op;
    op.kind = StoreOp::Del;
    op.id = id;
    op.rec = *r;
    apply_del(s, id);
    journal_push(s, std::move(op));
    return true;
}

bool store_undo(Store& s, std::string& err) {
    if (s.journal_pos == 0) { err = "nothing to undo"; return false; }
    const StoreOp& op = s.journal[--s.journal_pos];
    switch (op.kind) {
        case StoreOp::Set: apply_set(s, op.id, op.field, op.had_before, op.before); break;
        case StoreOp::Add: apply_del(s, op.id); break;
        case StoreOp::Del: apply_add(s, op.rec); break;
    }
    return true;
}

bool store_redo(Store& s, std::string& err) {
    if (s.journal_pos >= s.journal.size()) { err = "nothing to redo"; return false; }
    const StoreOp& op = s.journal[s.journal_pos++];
    switch (op.kind) {
        case StoreOp::Set: apply_set(s, op.id, op.field, op.has_after, op.after); break;
        case StoreOp::Add: apply_add(s, op.rec); break;
        case StoreOp::Del: apply_del(s, op.id); break;
    }
    return true;
}

std::vector<std::pair<std::string, std::string>> store_used_by(const Store& s, const std::string& id) {
    std::vector<std::pair<std::string, std::string>> out;
    auto range = s.refs_in.equal_range(id);
    for (auto it = range.first; it != range.second; ++it) out.push_back(it->second);
    std::sort(out.begin(), out.end());
    return out;
}

} // namespace drydock
