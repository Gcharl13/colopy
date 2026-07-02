// drydock/schema -- SCHM records (spec §7): the record types themselves, as
// records. One schema definition drives codegen, validation, form generation,
// the SQLite mirror, and docs; this module is the loader + the canonicalizer +
// the validator the others consume.
//
// A schema is authored as canonical text (data/schema/<type>.rec):
//
//   record schm.unit {
//     version = 1
//     fields  = [
//       { name = "index", type = "int", required = true, min = 0, max = 23,
//         doc = "@UNIT row ordinal (EXE-parity; load-bearing)" },
//       { name = "name",  type = "str", required = true },
//       ...
//     ]
//   }
//
// Field `type` strings: int | float | str | ref<TYPE> | flags | list<int> ...
#pragma once
#include "../text/rec_text.hpp"
#include <map>
#include <optional>

namespace drydock {

enum class FType : uint8_t { Int, Float, Str, Ref, Flags, ListInt, ListStr, ListDict };

struct FieldDef {
    std::string name;
    FType       type = FType::Int;
    std::string ref_type;                 // Ref: target type code ("prof")
    bool        required = false;
    bool        ordered  = false;         // lists: order is semantic (skip sort)
    std::optional<long long> min, max;    // Int/Float range
    std::optional<Value>     def;         // default
    std::vector<std::string> flag_values; // Flags: the legal tokens
    std::string doc;
};

struct TypeDef {
    std::string code;                     // "unit"
    int         version = 1;
    std::vector<FieldDef> fields;

    const FieldDef* find(const std::string& n) const {
        for (const auto& f : fields) if (f.name == n) return &f;
        return nullptr;
    }
};

struct Schema {
    std::map<std::string, TypeDef> types;    // code -> def

    const TypeDef* find(const std::string& code) const {
        auto it = types.find(code);
        return it == types.end() ? nullptr : &it->second;
    }
};

// Build a Schema from parsed schm.* records. Errors name the offending record.
bool schema_load(const std::vector<Record>& schm_records, Schema& out, std::string& err);

// Canonicalize IN PLACE per the type's schema: fields re-ordered to schema
// order (unknown fields are an error), unordered lists sorted by canonical
// rendering. This is what makes serialize_record deterministic.
bool schema_canonicalize(const Schema& s, Record& r, std::string& err);

// Per-record validation: unknown fields, type mismatches, range, required,
// ref shape (target type prefix). Whole-set checks (ref existence, duplicate
// ids) live in the validator CLI which owns the full record set.
// Appends human-readable errors ("unit.frigate: moves out of range 0..20").
void schema_validate(const Schema& s, const Record& r, std::vector<std::string>& errors);

} // namespace drydock
