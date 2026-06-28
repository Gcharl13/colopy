// forge/json.cpp -- see json.hpp. A compact recursive-descent JSON parser.
#include "json.hpp"

#include <cstdint>
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

} // namespace forge
