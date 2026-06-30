// forge/expr.cpp -- recursive-descent evaluator for the Formula node. See expr.hpp.
#include "expr.hpp"

#include <cctype>
#include <cmath>
#include <cstdlib>
#include <stdexcept>
#include <vector>

namespace forge {
namespace {

struct Parser {
    const std::string& s;
    size_t i = 0;
    const std::function<double(const std::string&)>& var;
    const std::function<int(int, int)>& rng;

    Parser(const std::string& str,
           const std::function<double(const std::string&)>& v,
           const std::function<int(int, int)>& r) : s(str), var(v), rng(r) {}

    [[noreturn]] void fail(const char* m) { throw std::runtime_error(m); }
    void ws() { while (i < s.size() && std::isspace((unsigned char)s[i])) ++i; }
    bool eof() { ws(); return i >= s.size(); }
    char peek() { ws(); return i < s.size() ? s[i] : '\0'; }
    bool take(char c) { ws(); if (i < s.size() && s[i] == c) { ++i; return true; } return false; }
    // match a two-char operator like ">=", "==", "&&"
    bool take2(char a, char b) {
        ws(); if (i + 1 < s.size() && s[i] == a && s[i + 1] == b) { i += 2; return true; } return false;
    }

    // ---- precedence climbing (lowest -> highest) ----
    double parse() { double v = ternary(); if (!eof()) fail("trailing characters"); return v; }

    double ternary() {
        double c = logic_or();
        if (take('?')) { double a = ternary(); if (!take(':')) fail("expected ':'"); double b = ternary();
            return c != 0 ? a : b; }
        return c;
    }
    double logic_or() {
        double v = logic_and();
        for (;;) { if (take2('|', '|')) { double r = logic_and(); v = (v != 0 || r != 0) ? 1 : 0; } else break; }
        return v;
    }
    double logic_and() {
        double v = equality();
        for (;;) { if (take2('&', '&')) { double r = equality(); v = (v != 0 && r != 0) ? 1 : 0; } else break; }
        return v;
    }
    double equality() {
        double v = comparison();
        for (;;) {
            if (take2('=', '=')) { double r = comparison(); v = (v == r) ? 1 : 0; }
            else if (take2('!', '=')) { double r = comparison(); v = (v != r) ? 1 : 0; }
            else break;
        }
        return v;
    }
    double comparison() {
        double v = additive();
        for (;;) {
            if (take2('<', '=')) { double r = additive(); v = (v <= r) ? 1 : 0; }
            else if (take2('>', '=')) { double r = additive(); v = (v >= r) ? 1 : 0; }
            else if (peek() == '<') { ++i; double r = additive(); v = (v < r) ? 1 : 0; }
            else if (peek() == '>') { ++i; double r = additive(); v = (v > r) ? 1 : 0; }
            else break;
        }
        return v;
    }
    double additive() {
        double v = multiplicative();
        for (;;) {
            char c = peek();
            if (c == '+') { ++i; v += multiplicative(); }
            else if (c == '-') { ++i; v -= multiplicative(); }
            else break;
        }
        return v;
    }
    double multiplicative() {
        double v = unary();
        for (;;) {
            char c = peek();
            if (c == '*') { ++i; v *= unary(); }
            else if (c == '/') { ++i; double r = unary(); v = (r != 0) ? v / r : 0; }
            else if (c == '%') { ++i; double r = unary(); v = (r != 0) ? std::fmod(v, r) : 0; }
            else break;
        }
        return v;
    }
    double unary() {
        char c = peek();
        if (c == '-') { ++i; return -unary(); }
        if (c == '+') { ++i; return unary(); }
        if (c == '!') { ++i; return unary() == 0 ? 1 : 0; }
        return primary();
    }
    double primary() {
        char c = peek();
        if (c == '(') { ++i; double v = ternary(); if (!take(')')) fail("expected ')'"); return v; }
        if (std::isdigit((unsigned char)c) || c == '.') return number();
        return word();   // identifier: function call or variable
    }
    double number() {
        ws(); size_t start = i;
        while (i < s.size() && (std::isdigit((unsigned char)s[i]) || s[i] == '.')) ++i;
        return std::strtod(s.substr(start, i - start).c_str(), nullptr);
    }
    // an identifier (variable or function name). Variable names may include '.', '_', '@',
    // and a bracketed selector "[...]" (so "@BUILDING[name:Fort].cost" is one token).
    std::string ident() {
        ws(); std::string out;
        while (i < s.size()) {
            char c = s[i];
            if (std::isalnum((unsigned char)c) || c == '_' || c == '.' || c == '@') { out += c; ++i; }
            else if (c == '[') { int depth = 0;                 // consume a whole [...] selector
                do { if (s[i] == '[') ++depth; else if (s[i] == ']') --depth; out += s[i]; ++i; }
                while (i < s.size() && depth > 0); }
            else break;
        }
        return out;
    }
    double word() {
        std::string name = ident();
        if (name.empty()) fail("unexpected character");
        if (peek() == '(') {            // function call
            ++i; std::vector<double> args;
            if (peek() != ')') { args.push_back(ternary());
                while (take(',')) args.push_back(ternary()); }
            if (!take(')')) fail("expected ')'");
            return call(name, args);
        }
        return var(name);               // variable lookup via the host
    }
    double call(const std::string& fn, const std::vector<double>& a) {
        auto n = a.size();
        if (fn == "roll" && n == 2) return (double)rng((int)a[0], (int)a[1]);
        if (fn == "min" && n >= 1) { double m = a[0]; for (size_t k = 1; k < n; ++k) m = a[k] < m ? a[k] : m; return m; }
        if (fn == "max" && n >= 1) { double m = a[0]; for (size_t k = 1; k < n; ++k) m = a[k] > m ? a[k] : m; return m; }
        if (fn == "abs" && n == 1) return std::fabs(a[0]);
        if (fn == "floor" && n == 1) return std::floor(a[0]);
        if (fn == "ceil" && n == 1) return std::ceil(a[0]);
        if (fn == "clamp" && n == 3) return a[0] < a[1] ? a[1] : (a[0] > a[2] ? a[2] : a[0]);
        fail("unknown function");
    }
};

} // namespace

double eval_expr(const std::string& expr,
                 const std::function<double(const std::string&)>& var,
                 const std::function<int(int, int)>& rng,
                 std::string* err) {
    try { Parser p(expr, var, rng); return p.parse(); }
    catch (const std::exception& e) { if (err) *err = e.what(); return 0; }
}

} // namespace forge
