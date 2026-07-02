// drydock/text -- the canonical record text format (engine-dev-environment-spec.md §4.2).
//
// One record per file (high-count leaf types may group), syntax:
//
//   record unit.expert_farmer {
//     name      = text.unit_expert_farmer
//     moves     = 2
//     flags     = [land, colonist]
//     notes     = "free text; the only prose allowed"
//   }
//
// Determinism contract (hard gate, §4.2 / §10.4):
//   - fields serialize in SCHEMA order, one per line, '=' aligned per record;
//   - canonical number formatting (ints bare; floats shortest round-trip, no
//     trailing-zero churn);
//   - lists sorted unless the schema marks the field `ordered`;
//   - no comments -- `notes` is the only prose, so text -> store -> text is
//     byte-identical.
//
// Value model: a small tagged union. Refs are bare dotted tokens
// (`prof.farming`); enum/flag tokens are bare identifiers; strings are quoted
// with \" and \\ escapes only.
#pragma once
#include <string>
#include <vector>
#include <cstdint>

namespace drydock {

enum class ValKind : uint8_t { Int, Float, Str, Token, List, Dict };

struct Value {
    ValKind kind = ValKind::Int;
    long long          i = 0;      // Int
    double             f = 0.0;    // Float
    std::string        s;          // Str (unquoted content) / Token (bare)
    std::vector<Value> list;       // List
    // Dict: parallel arrays (keys/list) keep Value self-referential without
    // an extra heap type; keys[i] names list[i].
    std::vector<std::string> keys;

    static Value make_int(long long v)          { Value x; x.kind = ValKind::Int;   x.i = v; return x; }
    static Value make_float(double v)           { Value x; x.kind = ValKind::Float; x.f = v; return x; }
    static Value make_str(std::string v)        { Value x; x.kind = ValKind::Str;   x.s = std::move(v); return x; }
    static Value make_token(std::string v)      { Value x; x.kind = ValKind::Token; x.s = std::move(v); return x; }
    static Value make_list(std::vector<Value> v){ Value x; x.kind = ValKind::List;  x.list = std::move(v); return x; }
    static Value make_dict()                    { Value x; x.kind = ValKind::Dict;  return x; }
    void dict_put(std::string k, Value v)       { keys.push_back(std::move(k)); list.push_back(std::move(v)); }
    const Value* dict_get(const std::string& k) const {
        for (size_t i = 0; i < keys.size(); ++i) if (keys[i] == k) return &list[i];
        return nullptr;
    }
    bool truthy() const { return kind == ValKind::Token && s == "true"; }
};

bool value_equal(const Value& a, const Value& b);

// One parsed record: full dotted id ("unit.expert_farmer"; the segment before
// the first dot is the type code) + fields in FILE order (the serializer is
// what enforces schema order).
struct RecField {
    std::string name;
    Value       value;
};
struct Record {
    std::string id;                       // full dotted id
    std::vector<RecField> fields;

    std::string type() const {            // "unit" of "unit.expert_farmer"
        auto p = id.find('.');
        return p == std::string::npos ? id : id.substr(0, p);
    }
    const Value* find(const std::string& field) const {
        for (const auto& f : fields) if (f.name == field) return &f.value;
        return nullptr;
    }
};

// ---- parsing ----------------------------------------------------------------
// Parses a whole .rec source (any number of `record` blocks). On error returns
// false and fills `err` with "line N: message"; on success appends to `out`.
bool parse_records(const std::string& src, std::vector<Record>& out, std::string& err);

// ---- canonical serialization -------------------------------------------------
// Field order + list sorting are the SCHEMA's business; the serializer takes
// the record with fields already in canonical order (see schema::canonicalize)
// and renders the deterministic byte layout: aligned '=', canonical numbers,
// one trailing newline.
std::string serialize_record(const Record& r);
std::string serialize_records(const std::vector<Record>& rs);   // blank line between

// Canonical scalar renderings (exposed for tests + codegen'd serializers).
std::string canon_int(long long v);
std::string canon_float(double v);
std::string canon_value(const Value& v);

} // namespace drydock
