// drydock/core/reflect -- the field-offset reflection runtime (spec §7 consumer
// #1). The codegen emits one DDTypeInfo (+ field table) per record type; this
// header is the SINGLE generic implementation of load/serialize/inspect that
// every consumer (form view, grid view, SQLite mirror, store) drives through
// those tables -- written once, never per-type.
#pragma once
#include "../text/rec_text.hpp"
#include <cstddef>
#include <cstdint>
#include <string>

namespace drydock {

enum class RType : uint8_t { I32, Str, RefId };   // grows with the migrated field kinds

struct DDFieldInfo {
    const char* name;        // schema field name
    RType       type;        // storage type in the generated struct
    size_t      offset;      // offsetof the value member
    size_t      has_offset;  // offsetof the presence bool (absent fields stay default)
};

struct DDTypeInfo {
    const char*        code;      // "good"
    const DDFieldInfo* fields;
    size_t             nfields;
    size_t             struct_size;
};

// ---- generic load: parsed Record -> generated struct --------------------------
inline bool reflect_load(const DDTypeInfo& ti, const Record& r, void* obj) {
    for (size_t i = 0; i < ti.nfields; ++i) {
        const DDFieldInfo& fi = ti.fields[i];
        const Value* v = r.find(fi.name);
        bool* has = reinterpret_cast<bool*>((char*)obj + fi.has_offset);
        *has = (v != nullptr);
        if (!v) continue;
        switch (fi.type) {
            case RType::I32:
                if (v->kind != ValKind::Int) return false;
                *reinterpret_cast<int32_t*>((char*)obj + fi.offset) = (int32_t)v->i;
                break;
            case RType::Str:
                if (v->kind != ValKind::Str) return false;
                *reinterpret_cast<std::string*>((char*)obj + fi.offset) = v->s;
                break;
            case RType::RefId:
                if (v->kind != ValKind::Token) return false;
                *reinterpret_cast<std::string*>((char*)obj + fi.offset) = v->s;
                break;
        }
    }
    return true;
}

// ---- generic serialize: generated struct -> Record (schema field order) -------
inline Record reflect_serialize(const DDTypeInfo& ti, const std::string& id, const void* obj) {
    Record r;
    r.id = id;
    for (size_t i = 0; i < ti.nfields; ++i) {
        const DDFieldInfo& fi = ti.fields[i];
        const bool* has = reinterpret_cast<const bool*>((const char*)obj + fi.has_offset);
        if (!*has) continue;                       // absent stays absent (lossless)
        switch (fi.type) {
            case RType::I32:
                r.fields.push_back({fi.name, Value::make_int(
                    *reinterpret_cast<const int32_t*>((const char*)obj + fi.offset))});
                break;
            case RType::Str:
                r.fields.push_back({fi.name, Value::make_str(
                    *reinterpret_cast<const std::string*>((const char*)obj + fi.offset))});
                break;
            case RType::RefId:
                r.fields.push_back({fi.name, Value::make_token(
                    *reinterpret_cast<const std::string*>((const char*)obj + fi.offset))});
                break;
        }
    }
    return r;
}

} // namespace drydock
