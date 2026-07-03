// drydock/schema -- SCHM loader, canonicalizer, per-record validator (spec §7).
#include "schema.hpp"
#include <algorithm>

namespace drydock {

// "ref<TYPE>" / "list<int>" style type strings -> FType
static bool parse_ftype(const std::string& t, FieldDef& fd, std::string& err) {
    if (t == "int")   { fd.type = FType::Int;   return true; }
    if (t == "float") { fd.type = FType::Float; return true; }
    if (t == "str")   { fd.type = FType::Str;   return true; }
    if (t == "flags") { fd.type = FType::Flags; return true; }
    if (t.rfind("ref<", 0) == 0 && t.back() == '>') {
        fd.type = FType::Ref;
        fd.ref_type = t.substr(4, t.size() - 5);
        if (fd.ref_type.empty()) { err = "empty ref<> target"; return false; }
        return true;
    }
    if (t == "list<int>")  { fd.type = FType::ListInt;  return true; }
    if (t == "list<str>")  { fd.type = FType::ListStr;  return true; }
    if (t == "list<dict>") { fd.type = FType::ListDict; return true; }
    err = "unknown field type '" + t + "'";
    return false;
}

bool schema_load(const std::vector<Record>& schm_records, Schema& out, std::string& err) {
    for (const auto& r : schm_records) {
        if (r.type() != "schm") { err = r.id + ": not a schm record"; return false; }
        TypeDef td;
        td.code = r.id.substr(5);                       // "schm.unit" -> "unit"
        if (td.code.empty()) { err = r.id + ": empty type code"; return false; }
        if (const Value* v = r.find("version"))
            td.version = (int)v->i;
        const Value* fl = r.find("fields");
        if (!fl || fl->kind != ValKind::List) { err = r.id + ": missing fields list"; return false; }
        for (const Value& fv : fl->list) {
            if (fv.kind != ValKind::Dict) { err = r.id + ": field entry must be a dict"; return false; }
            FieldDef fd;
            const Value* n = fv.dict_get("name");
            const Value* t = fv.dict_get("type");
            if (!n || n->kind != ValKind::Str || !t || t->kind != ValKind::Str) {
                err = r.id + ": field needs name and type strings";
                return false;
            }
            fd.name = n->s;
            std::string terr;
            if (!parse_ftype(t->s, fd, terr)) { err = r.id + "." + fd.name + ": " + terr; return false; }
            if (const Value* v = fv.dict_get("required")) fd.required = v->truthy();
            if (const Value* v = fv.dict_get("ordered"))  fd.ordered  = v->truthy();
            if (const Value* v = fv.dict_get("min")) fd.min = v->i;
            if (const Value* v = fv.dict_get("max")) fd.max = v->i;
            if (const Value* v = fv.dict_get("default")) fd.def = *v;
            if (const Value* v = fv.dict_get("doc")) fd.doc = (v->kind == ValKind::Str) ? v->s : "";
            if (const Value* v = fv.dict_get("values"); v && v->kind == ValKind::List)
                for (const Value& x : v->list)
                    if (x.kind == ValKind::Token) fd.flag_values.push_back(x.s);
            if (td.find(fd.name)) { err = r.id + ": duplicate field def '" + fd.name + "'"; return false; }
            td.fields.push_back(std::move(fd));
        }
        if (out.types.count(td.code)) { err = r.id + ": duplicate type"; return false; }
        out.types[td.code] = std::move(td);
    }
    return true;
}

bool schema_canonicalize(const Schema& s, Record& r, std::string& err) {
    const TypeDef* td = s.find(r.type());
    if (!td) { err = r.id + ": no schema for type '" + r.type() + "'"; return false; }
    // reject unknown fields BEFORE any reordering (moved-from names lie)
    for (const auto& f : r.fields)
        if (!td->find(f.name)) { err = r.id + ": unknown field '" + f.name + "'"; return false; }
    std::vector<RecField> out;
    out.reserve(r.fields.size());
    for (const FieldDef& fd : td->fields) {
        for (auto& f : r.fields)
            if (f.name == fd.name) {
                // sort unordered lists by canonical rendering (spec 4.2)
                if (f.value.kind == ValKind::List && !fd.ordered &&
                    fd.type != FType::ListDict)
                    std::sort(f.value.list.begin(), f.value.list.end(),
                              [](const Value& a, const Value& b) {
                                  return canon_value(a) < canon_value(b);
                              });
                out.push_back(std::move(f));
                break;
            }
    }
    if (out.size() != r.fields.size()) {                // same name twice
        err = r.id + ": duplicate field";
        return false;
    }
    r.fields = std::move(out);
    return true;
}

static const char* kind_name(ValKind k) {
    switch (k) {
        case ValKind::Int: return "int";       case ValKind::Float: return "float";
        case ValKind::Str: return "str";       case ValKind::Token: return "token";
        case ValKind::List: return "list";     case ValKind::Dict:  return "dict";
    }
    return "?";
}

void schema_validate(const Schema& s, const Record& r, std::vector<std::string>& errors) {
    const TypeDef* td = s.find(r.type());
    if (!td) { errors.push_back(r.id + ": no schema for type '" + r.type() + "'"); return; }
    for (const FieldDef& fd : td->fields)
        if (fd.required && !r.find(fd.name))
            errors.push_back(r.id + ": required field '" + fd.name + "' missing");
    for (const auto& f : r.fields) {
        const FieldDef* fd = td->find(f.name);
        if (!fd) { errors.push_back(r.id + ": unknown field '" + f.name + "'"); continue; }
        schema_validate_field(r.id, *fd, f.value, errors);
    }
}

void schema_validate_field(const std::string& rec_id, const FieldDef& fdef,
                           const Value& v, std::vector<std::string>& errors) {
    {
        const FieldDef* fd = &fdef;
        const std::string& rid = rec_id;
        const std::string& fname = fdef.name;
        auto type_err = [&](const char* want) {
            errors.push_back(rid + "." + fname + ": expected " + want +
                             ", got " + kind_name(v.kind));
        };
        switch (fd->type) {
            case FType::Int:
                if (v.kind != ValKind::Int) { type_err("int"); break; }
                if ((fd->min && v.i < *fd->min) || (fd->max && v.i > *fd->max))
                    errors.push_back(rid + "." + fname + ": " + canon_int(v.i) +
                                     " out of range " +
                                     (fd->min ? canon_int(*fd->min) : "") + ".." +
                                     (fd->max ? canon_int(*fd->max) : ""));
                break;
            case FType::Float:
                if (v.kind != ValKind::Float && v.kind != ValKind::Int) type_err("float");
                break;
            case FType::Str:
                if (v.kind != ValKind::Str) type_err("str");
                break;
            case FType::Ref:
                if (v.kind != ValKind::Token) { type_err("ref token"); break; }
                if (v.s.rfind(fd->ref_type + ".", 0) != 0)
                    errors.push_back(rid + "." + fname + ": ref '" + v.s +
                                     "' must target type '" + fd->ref_type + "'");
                break;
            case FType::Flags:
                if (v.kind != ValKind::List) { type_err("flags list"); break; }
                for (const Value& x : v.list) {
                    if (x.kind != ValKind::Token) { type_err("flag token"); break; }
                    if (!fd->flag_values.empty() &&
                        std::find(fd->flag_values.begin(), fd->flag_values.end(), x.s) ==
                            fd->flag_values.end())
                        errors.push_back(rid + "." + fname + ": unknown flag '" + x.s + "'");
                }
                break;
            case FType::ListInt:
                if (v.kind != ValKind::List) { type_err("list<int>"); break; }
                for (const Value& x : v.list)
                    if (x.kind != ValKind::Int) { type_err("int element"); break; }
                break;
            case FType::ListStr:
                if (v.kind != ValKind::List) { type_err("list<str>"); break; }
                for (const Value& x : v.list)
                    if (x.kind != ValKind::Str) { type_err("str element"); break; }
                break;
            case FType::ListDict:
                if (v.kind != ValKind::List) { type_err("list<dict>"); break; }
                for (const Value& x : v.list)
                    if (x.kind != ValKind::Dict) { type_err("dict element"); break; }
                break;
        }
    }
}

} // namespace drydock
