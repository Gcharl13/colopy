// drydock/text -- hand-written parser + deterministic serializer (spec §4.2,
// §10.2 "parser: hand-written -- owning it guarantees determinism and error
// quality"). Deliberately small; no regex, no locale, no float printf churn.
#include "rec_text.hpp"
#include <cctype>
#include <cstdio>
#include <cstring>
#include <algorithm>

namespace drydock {

bool value_equal(const Value& a, const Value& b) {
    if (a.kind != b.kind) return false;
    switch (a.kind) {
        case ValKind::Int:   return a.i == b.i;
        case ValKind::Float: return a.f == b.f;
        case ValKind::Str:
        case ValKind::Token: return a.s == b.s;
        case ValKind::List:
            if (a.list.size() != b.list.size()) return false;
            for (size_t i = 0; i < a.list.size(); ++i)
                if (!value_equal(a.list[i], b.list[i])) return false;
            return true;
    }
    return false;
}

// ---- lexer -------------------------------------------------------------------

namespace {

struct Lex {
    const char* p;
    const char* end;
    int line = 1;
    std::string err;

    explicit Lex(const std::string& s) : p(s.c_str()), end(s.c_str() + s.size()) {}

    void skip_ws() {
        while (p < end) {
            if (*p == '\n') { ++line; ++p; }
            else if (*p == ' ' || *p == '\t' || *p == '\r') ++p;
            else break;
        }
    }
    bool fail(const std::string& m) {
        if (err.empty()) err = "line " + std::to_string(line) + ": " + m;
        return false;
    }
    static bool ident_start(char c) { return std::isalpha((unsigned char)c) || c == '_'; }
    static bool ident_char(char c)  { return std::isalnum((unsigned char)c) || c == '_' || c == '.'; }

    // bare token: identifier chars + dots (ids, refs, enum/flag names)
    bool token(std::string& out) {
        skip_ws();
        if (p >= end || !ident_start(*p)) return fail("expected identifier");
        const char* s = p;
        while (p < end && ident_char(*p)) ++p;
        out.assign(s, p);
        return true;
    }
    bool expect(char c) {
        skip_ws();
        if (p >= end || *p != c) return fail(std::string("expected '") + c + "'");
        ++p;
        return true;
    }
    bool peek(char c) {
        skip_ws();
        return p < end && *p == c;
    }
    bool at_end() { skip_ws(); return p >= end; }

    bool string_lit(std::string& out) {
        // opening quote already consumed by caller? no -- consume here
        if (!expect('"')) return false;
        out.clear();
        while (p < end && *p != '"') {
            char c = *p++;
            if (c == '\n') return fail("newline in string (use \\n)");
            if (c == '\\') {
                if (p >= end) return fail("dangling escape");
                char e = *p++;
                if (e == '"') out.push_back('"');
                else if (e == '\\') out.push_back('\\');
                else if (e == 'n') out.push_back('\n');
                else return fail("unknown escape (only \\\" \\\\ \\n)");
            } else out.push_back(c);
        }
        if (p >= end) return fail("unterminated string");
        ++p;                                            // closing quote
        return true;
    }

    bool number(Value& out) {
        skip_ws();
        const char* s = p;
        if (p < end && (*p == '-' || *p == '+')) ++p;
        bool digits = false, dot = false;
        while (p < end && (std::isdigit((unsigned char)*p) || *p == '.')) {
            if (*p == '.') { if (dot) return fail("two dots in number"); dot = true; }
            else digits = true;
            ++p;
        }
        if (!digits) return fail("expected number");
        std::string t(s, p);
        if (dot) out = Value::make_float(std::strtod(t.c_str(), nullptr));
        else     out = Value::make_int(std::strtoll(t.c_str(), nullptr, 10));
        return true;
    }

    bool value(Value& out, int depth) {
        skip_ws();
        if (p >= end) return fail("expected value");
        if (depth > 4) return fail("list nesting too deep");
        char c = *p;
        if (c == '"') { std::string s; if (!string_lit(s)) return false; out = Value::make_str(std::move(s)); return true; }
        if (c == '[') {
            ++p;
            std::vector<Value> xs;
            skip_ws();
            if (peek(']')) { ++p; out = Value::make_list(std::move(xs)); return true; }
            for (;;) {
                Value v;
                if (!value(v, depth + 1)) return false;
                xs.push_back(std::move(v));
                skip_ws();
                if (peek(',')) { ++p; continue; }
                if (peek(']')) { ++p; break; }
                return fail("expected ',' or ']' in list");
            }
            out = Value::make_list(std::move(xs));
            return true;
        }
        if (c == '-' || c == '+' || std::isdigit((unsigned char)c)) return number(out);
        if (ident_start(c)) { std::string t; if (!token(t)) return false; out = Value::make_token(std::move(t)); return true; }
        return fail("unexpected character in value");
    }
};

} // namespace

bool parse_records(const std::string& src, std::vector<Record>& out, std::string& err) {
    Lex lx(src);
    for (;;) {
        if (lx.at_end()) return true;
        std::string kw;
        if (!lx.token(kw)) { err = lx.err; return false; }
        if (kw != "record") { err = "line " + std::to_string(lx.line) + ": expected 'record'"; return false; }
        Record r;
        if (!lx.token(r.id)) { err = lx.err; return false; }
        if (r.id.find('.') == std::string::npos) {
            err = "line " + std::to_string(lx.line) + ": record id must be type.name";
            return false;
        }
        if (!lx.expect('{')) { err = lx.err; return false; }
        while (!lx.peek('}')) {
            RecField f;
            if (!lx.token(f.name)) { err = lx.err; return false; }
            if (!lx.expect('=')) { err = lx.err; return false; }
            if (!lx.value(f.value, 0)) { err = lx.err; return false; }
            for (const auto& prev : r.fields)
                if (prev.name == f.name) {
                    err = "line " + std::to_string(lx.line) + ": duplicate field '" + f.name + "'";
                    return false;
                }
            r.fields.push_back(std::move(f));
        }
        lx.expect('}');
        out.push_back(std::move(r));
    }
}

// ---- canonical rendering -----------------------------------------------------

std::string canon_int(long long v) { return std::to_string(v); }

// Shortest decimal that round-trips: try increasing precision until strtod
// gives the value back, then strip the trailing zeros printf may leave.
std::string canon_float(double v) {
    char buf[64];
    for (int prec = 1; prec <= 17; ++prec) {
        std::snprintf(buf, sizeof buf, "%.*g", prec, v);
        if (std::strtod(buf, nullptr) == v) break;
    }
    std::string s(buf);
    if (s.find('.') == std::string::npos &&
        s.find('e') == std::string::npos && s.find('n') == std::string::npos)
        s += ".0";                                       // floats always carry a dot
    return s;
}

static std::string quote(const std::string& s) {
    std::string o = "\"";
    for (char c : s) {
        if (c == '"') o += "\\\"";
        else if (c == '\\') o += "\\\\";
        else if (c == '\n') o += "\\n";
        else o.push_back(c);
    }
    o += '"';
    return o;
}

std::string canon_value(const Value& v) {
    switch (v.kind) {
        case ValKind::Int:   return canon_int(v.i);
        case ValKind::Float: return canon_float(v.f);
        case ValKind::Str:   return quote(v.s);
        case ValKind::Token: return v.s;
        case ValKind::List: {
            std::string o = "[";
            for (size_t i = 0; i < v.list.size(); ++i) {
                if (i) o += ", ";
                o += canon_value(v.list[i]);
            }
            o += "]";
            return o;
        }
    }
    return "";
}

std::string serialize_record(const Record& r) {
    size_t w = 0;
    for (const auto& f : r.fields) w = std::max(w, f.name.size());
    std::string o = "record " + r.id + " {\n";
    for (const auto& f : r.fields) {
        o += "  " + f.name + std::string(w - f.name.size(), ' ') + " = " + canon_value(f.value) + "\n";
    }
    o += "}\n";
    return o;
}

std::string serialize_records(const std::vector<Record>& rs) {
    std::string o;
    for (size_t i = 0; i < rs.size(); ++i) {
        if (i) o += "\n";
        o += serialize_record(rs[i]);
    }
    return o;
}

} // namespace drydock
