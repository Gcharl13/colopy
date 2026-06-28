// forge/datacheck.cpp -- see datacheck.hpp.
#include "datacheck.hpp"

#include "rules.hpp"   // vc::sim::NUNITTYPES

#include <cstdlib>
#include <string>

namespace forge {
namespace {

// Parse an integer cell that may be stored as a JSON string ("2") or number.
bool cell_int(const JsonValue& v, long& out) {
    if (v.type == JsonValue::Number) { out = (long)v.num; return true; }
    if (v.type == JsonValue::String) {
        char* end = nullptr;
        out = std::strtol(v.str.c_str(), &end, 10);
        return end && *end == '\0' && !v.str.empty();
    }
    return false;
}

int row_count_of(const JsonValue& section) {
    const JsonValue* rows = section.find("rows");
    return (rows && rows->is_array()) ? (int)rows->arr.size() : -1;
}

}  // namespace

DataReport check_data(const JsonValue& root) {
    DataReport r;
    if (!root.is_object()) { r.issues.push_back("root is not an object"); return r; }

    // @FOUNDING size for the @FATHERS.type referential check.
    int founding_n = -1;
    if (const JsonValue* f = root.find("@FOUNDING")) founding_n = row_count_of(*f);

    // generic structural pass over every CSV-style section.
    for (const auto& kv : root.obj) {
        const std::string& name = kv.first;
        const JsonValue& sec = kv.second;
        const JsonValue* cols = sec.find("columns");
        const JsonValue* rows = sec.find("rows");
        if (!cols || !rows || !cols->is_array() || !rows->is_array()) continue;  // not a table
        r.sections++;

        const JsonValue* rc = sec.find("row_count");
        if (rc && rc->is_number() && rc->as_int() != (int)rows->arr.size())
            r.warnings.push_back(name + ": row_count " + std::to_string(rc->as_int()) +
                                 " != rows " + std::to_string(rows->arr.size()));

        for (size_t i = 0; i < rows->arr.size(); ++i) {
            const JsonValue& row = rows->arr[i];
            r.rows++;
            if (!row.is_object()) { r.issues.push_back(name + " row " + std::to_string(i) +
                                                       ": not an object"); continue; }
            for (const auto& col : cols->arr)
                if (col.is_string() && !row.find(col.str))
                    r.issues.push_back(name + " row " + std::to_string(i) +
                                       ": missing column '" + col.str + "'");
        }
    }

    // @UNIT: enum wall + non-negative numeric stats.
    if (const JsonValue* u = root.find("@UNIT")) {
        if (const JsonValue* rows = u->find("rows")) {
            if ((int)rows->arr.size() > vc::sim::NUNITTYPES)
                r.issues.push_back("@UNIT has " + std::to_string(rows->arr.size()) +
                                   " rows > NUNITTYPES(" + std::to_string(vc::sim::NUNITTYPES) +
                                   ") -- exceeds the sim's fixed unit enum");
            for (size_t i = 0; i < rows->arr.size(); ++i) {
                for (const char* k : {"attack", "combat", "cargo", "movement"}) {
                    const JsonValue* c = rows->arr[i].find(k);
                    long n = 0;
                    if (c && cell_int(*c, n) && n < 0)
                        r.issues.push_back("@UNIT row " + std::to_string(i) + ": " + k + " < 0");
                }
            }
        }
    }

    // @FATHERS.type must index a real @FOUNDING category.
    if (founding_n >= 0) {
        if (const JsonValue* f = root.find("@FATHERS")) {
            if (const JsonValue* rows = f->find("rows")) {
                for (size_t i = 0; i < rows->arr.size(); ++i) {
                    const JsonValue* t = rows->arr[i].find("type");
                    long n = 0;
                    if (t && cell_int(*t, n) && (n < 0 || n >= founding_n))
                        r.issues.push_back("@FATHERS row " + std::to_string(i) + ": type " +
                                           std::to_string(n) + " out of @FOUNDING range [0," +
                                           std::to_string(founding_n - 1) + "]");
                }
            }
        }
    }

    return r;
}

DataReport check_data_tables(const std::string& path) {
    return check_data(json_parse_file(path));
}

} // namespace forge
