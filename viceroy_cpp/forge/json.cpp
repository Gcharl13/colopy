// forge/json.cpp -- see json.hpp. A compact recursive-descent JSON parser.
#include "json.hpp"

#include <cstdint>
#include <cstdio>
#include <fstream>
#include <sstream>
#include <stdexcept>

namespace forge {
namespace {

struct Parser {
    const std::string& s;
    size_t i = 0;
    explicit Parser(const std::string& src) : s(src) {}

    [[noreturn]] void fail(const std::string& msg) {
        throw std::runtime_error("json: " + msg + " at offset " + std::to_string(i));
    }
    void skip_ws() {
        while (i < s.size()) {
            char c = s[i];
            if (c == ' ' || c == '\t' || c == '\n' || c == '\r') ++i;
            else break;
        }
    }
    char peek() { return i < s.size() ? s[i] : '\0'; }
    char get()  { if (i >= s.size()) fail("unexpected end"); return s[i++]; }

    void expect(char c) { if (get() != c) { --i; fail(std::string("expected '") + c + "'"); } }

    void encode_utf8(uint32_t cp, std::string& out) {
        if (cp <= 0x7F) out.push_back((char)cp);
        else if (cp <= 0x7FF) {
            out.push_back((char)(0xC0 | (cp >> 6)));
            out.push_back((char)(0x80 | (cp & 0x3F)));
        } else {
            out.push_back((char)(0xE0 | (cp >> 12)));
            out.push_back((char)(0x80 | ((cp >> 6) & 0x3F)));
            out.push_back((char)(0x80 | (cp & 0x3F)));
        }
    }
    unsigned hex4() {
        unsigned v = 0;
        for (int k = 0; k < 4; ++k) {
            char c = get(); v <<= 4;
            if (c >= '0' && c <= '9') v |= (unsigned)(c - '0');
            else if (c >= 'a' && c <= 'f') v |= (unsigned)(c - 'a' + 10);
            else if (c >= 'A' && c <= 'F') v |= (unsigned)(c - 'A' + 10);
            else { --i; fail("bad \\u escape"); }
        }
        return v;
    }

    std::string parse_string() {
        expect('"');
        std::string out;
        for (;;) {
            char c = get();
            if (c == '"') break;
            if (c == '\\') {
                char e = get();
                switch (e) {
                    case '"': out.push_back('"'); break;
                    case '\\': out.push_back('\\'); break;
                    case '/': out.push_back('/'); break;
                    case 'b': out.push_back('\b'); break;
                    case 'f': out.push_back('\f'); break;
                    case 'n': out.push_back('\n'); break;
                    case 'r': out.push_back('\r'); break;
                    case 't': out.push_back('\t'); break;
                    case 'u': encode_utf8(hex4(), out); break;
                    default: --i; fail("bad escape");
                }
            } else {
                out.push_back(c);
            }
        }
        return out;
    }

    JsonValue parse_number() {
        size_t start = i;
        if (peek() == '-') ++i;
        while (i < s.size()) {
            char c = s[i];
            if ((c >= '0' && c <= '9') || c == '.' || c == 'e' || c == 'E' ||
                c == '+' || c == '-') ++i;
            else break;
        }
        JsonValue v; v.type = JsonValue::Number;
        v.num = std::stod(s.substr(start, i - start));
        return v;
    }

    void parse_literal(const char* lit) {
        for (const char* p = lit; *p; ++p) if (get() != *p) { --i; fail("bad literal"); }
    }

    JsonValue parse_value() {
        skip_ws();
        char c = peek();
        JsonValue v;
        switch (c) {
            case '"': v.type = JsonValue::String; v.str = parse_string(); return v;
            case '{': return parse_object();
            case '[': return parse_array();
            case 't': parse_literal("true");  v.type = JsonValue::Bool; v.b = true;  return v;
            case 'f': parse_literal("false"); v.type = JsonValue::Bool; v.b = false; return v;
            case 'n': parse_literal("null");  v.type = JsonValue::Null; return v;
            default:
                if (c == '-' || (c >= '0' && c <= '9')) return parse_number();
                fail("unexpected character");
        }
    }

    JsonValue parse_object() {
        expect('{');
        JsonValue v; v.type = JsonValue::Object;
        skip_ws();
        if (peek() == '}') { ++i; return v; }
        for (;;) {
            skip_ws();
            std::string key = parse_string();
            skip_ws(); expect(':');
            v.obj[key] = parse_value();
            skip_ws();
            char c = get();
            if (c == ',') continue;
            if (c == '}') break;
            --i; fail("expected ',' or '}'");
        }
        return v;
    }

    JsonValue parse_array() {
        expect('[');
        JsonValue v; v.type = JsonValue::Array;
        skip_ws();
        if (peek() == ']') { ++i; return v; }
        for (;;) {
            v.arr.push_back(parse_value());
            skip_ws();
            char c = get();
            if (c == ',') continue;
            if (c == ']') break;
            --i; fail("expected ',' or ']'");
        }
        return v;
    }

    JsonValue parse_document() {
        JsonValue v = parse_value();
        skip_ws();
        if (i != s.size()) fail("trailing characters");
        return v;
    }
};

} // namespace

JsonValue json_parse(const std::string& text) {
    Parser p(text);
    return p.parse_document();
}

JsonValue json_parse_file(const std::string& path) {
    std::ifstream f(path, std::ios::binary);
    if (!f) throw std::runtime_error("json: cannot open " + path);
    std::ostringstream ss;
    ss << f.rdbuf();
    return json_parse(ss.str());
}

// ---- serialization ----
namespace {

void dump_string(const std::string& s, std::string& out) {
    out.push_back('"');
    for (char c : s) {
        switch (c) {
            case '"':  out += "\\\""; break;
            case '\\': out += "\\\\"; break;
            case '\n': out += "\\n"; break;
            case '\t': out += "\\t"; break;
            case '\r': out += "\\r"; break;
            case '\b': out += "\\b"; break;
            case '\f': out += "\\f"; break;
            default:
                if ((unsigned char)c < 0x20) {
                    char buf[8];
                    std::snprintf(buf, sizeof buf, "\\u%04x", (unsigned)(unsigned char)c);
                    out += buf;
                } else out.push_back(c);
        }
    }
    out.push_back('"');
}

void dump_number(double n, std::string& out) {
    char buf[32];
    if (n == (double)(long long)n && n < 1e15 && n > -1e15)
        std::snprintf(buf, sizeof buf, "%lld", (long long)n);
    else
        std::snprintf(buf, sizeof buf, "%g", n);
    out += buf;
}

void dump(const JsonValue& v, int indent, int depth, std::string& out) {
    std::string pad(depth * indent, ' ');
    std::string pad1((depth + 1) * indent, ' ');
    switch (v.type) {
        case JsonValue::Null:   out += "null"; break;
        case JsonValue::Bool:   out += v.b ? "true" : "false"; break;
        case JsonValue::Number: dump_number(v.num, out); break;
        case JsonValue::String: dump_string(v.str, out); break;
        case JsonValue::Array:
            if (v.arr.empty()) { out += "[]"; break; }
            out += "[\n";
            for (size_t i = 0; i < v.arr.size(); ++i) {
                out += pad1; dump(v.arr[i], indent, depth + 1, out);
                out += (i + 1 < v.arr.size()) ? ",\n" : "\n";
            }
            out += pad; out += "]";
            break;
        case JsonValue::Object: {
            if (v.obj.empty()) { out += "{}"; break; }
            out += "{\n";
            size_t i = 0;
            for (const auto& kv : v.obj) {
                out += pad1; dump_string(kv.first, out); out += ": ";
                dump(kv.second, indent, depth + 1, out);
                out += (++i < v.obj.size()) ? ",\n" : "\n";
            }
            out += pad; out += "}";
            break;
        }
    }
}

}  // namespace

std::string json_dump(const JsonValue& v, int indent) {
    std::string out;
    dump(v, indent, 0, out);
    out.push_back('\n');
    return out;
}

JsonValue json_num(double n) { JsonValue v; v.type = JsonValue::Number; v.num = n; return v; }
JsonValue json_str(const std::string& s) { JsonValue v; v.type = JsonValue::String; v.str = s; return v; }

} // namespace forge
