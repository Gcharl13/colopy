// forge/json.hpp -- a tiny dependency-free JSON reader for the Forge tooling.
//
// Deliberately NOT in viceroy_sim: the pure sim core stays dependency-light (the
// project's only external dep is libpng, and it hand-rolls its JSON I/O). This
// reader is used by the Forge to load mod overlays (rules.json) and the extracted
// data tables. Read-only (no serializer yet); throws std::runtime_error on
// malformed input.
#pragma once

#include <map>
#include <string>
#include <vector>

namespace forge {

struct JsonValue {
    enum Type { Null, Bool, Number, String, Array, Object } type = Null;
    bool        b = false;
    double      num = 0.0;
    std::string str;
    std::vector<JsonValue>         arr;
    std::map<std::string, JsonValue> obj;

    bool is_object() const { return type == Object; }
    bool is_array()  const { return type == Array; }
    bool is_number() const { return type == Number; }
    bool is_string() const { return type == String; }

    int    as_int(int def = 0) const   { return type == Number ? (int)num : def; }
    double as_double(double d = 0) const { return type == Number ? num : d; }

    // Object member lookup; nullptr if absent or not an object.
    const JsonValue* find(const std::string& key) const {
        if (type != Object) return nullptr;
        auto it = obj.find(key);
        return it == obj.end() ? nullptr : &it->second;
    }
};

// Parse a JSON document. Throws std::runtime_error with a position on error.
JsonValue json_parse(const std::string& text);

// Parse a JSON file. Throws std::runtime_error if it can't be opened/parsed.
JsonValue json_parse_file(const std::string& path);

// Serialize to a pretty-printed JSON string (indent spaces per level). Integral
// numbers print without a decimal point.
std::string json_dump(const JsonValue& v, int indent = 2);

// Convenience constructors for building documents to serialize.
JsonValue json_num(double n);
JsonValue json_str(const std::string& s);

} // namespace forge
