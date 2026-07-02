// drydock test harness -- the spec's hard gates live here (§10.4):
// text -> store -> text byte-identical, canonical number formatting, parser
// error quality. Grows with each Drydock phase.
#include "../text/rec_text.hpp"
#include <cstdio>
#include <string>
#include <vector>

static int g_fail = 0;
static void check(bool ok, const char* what) {
    std::printf("%s %s\n", ok ? "  ok " : "FAIL ", what);
    if (!ok) ++g_fail;
}

using namespace drydock;

static void test_roundtrip() {
    Record r;
    r.id = "unit.expert_farmer";
    r.fields.push_back({"name",      Value::make_token("text.unit_expert_farmer")});
    r.fields.push_back({"template",  Value::make_token("unit._base_colonist")});
    r.fields.push_back({"moves",     Value::make_int(2)});
    r.fields.push_back({"ration",    Value::make_float(1.5)});
    r.fields.push_back({"flags",     Value::make_list({Value::make_token("colonist"),
                                                       Value::make_token("land")})});
    r.fields.push_back({"notes",     Value::make_str("quote \" and \\ backslash\nline2")});

    std::string t1 = serialize_record(r);
    std::vector<Record> back;
    std::string err;
    check(parse_records(t1, back, err), "roundtrip: parse serialized record");
    if (!err.empty()) std::printf("       err: %s\n", err.c_str());
    check(back.size() == 1, "roundtrip: one record back");
    std::string t2 = back.empty() ? "" : serialize_record(back[0]);
    check(t1 == t2, "roundtrip: text -> store -> text BYTE-IDENTICAL");
    check(back.size() == 1 && back[0].find("moves") && back[0].find("moves")->i == 2,
          "roundtrip: int value survives");
    check(back.size() == 1 && back[0].find("ration") && back[0].find("ration")->f == 1.5,
          "roundtrip: float value survives");
    check(back.size() == 1 && back[0].find("notes") &&
          back[0].find("notes")->s == "quote \" and \\ backslash\nline2",
          "roundtrip: escaped string survives");
}

static void test_canonical_numbers() {
    check(canon_int(0) == "0" && canon_int(-7) == "-7", "canon int");
    check(canon_float(1.5) == "1.5", "canon float 1.5 (not 1.50)");
    check(canon_float(2.0) == "2.0", "canon float 2.0 keeps its dot");
    check(canon_float(0.1) == "0.1", "canon float 0.1 shortest round-trip");
    // shortest-round-trip: re-parsing the canonical text gives the bit-exact double
    double v = 0.30000000000000004;
    check(std::strtod(canon_float(v).c_str(), nullptr) == v, "canon float round-trips exactly");
}

static void test_parse_errors() {
    std::vector<Record> rs; std::string err;
    check(!parse_records("record no_dot { }", rs, err), "reject id without type prefix");
    err.clear(); rs.clear();
    check(!parse_records("record a.b { x = 1 x = 2 }", rs, err), "reject duplicate field");
    err.clear(); rs.clear();
    check(!parse_records("record a.b { x = \"unterminated }", rs, err), "reject unterminated string");
    err.clear(); rs.clear();
    check(!parse_records("recor a.b { }", rs, err), "reject bad keyword");
    err.clear(); rs.clear();
    check(parse_records("", rs, err) && rs.empty(), "empty source is zero records");
    // error messages carry a line number
    err.clear(); rs.clear();
    parse_records("record a.b {\n  x = @bad\n}", rs, err);
    check(err.find("line 2") != std::string::npos, "errors carry line numbers");
}

static void test_multi_and_lists() {
    const char* src =
        "record good.food {\n"
        "  index  = 0\n"
        "  spread = [1, 2, 3]\n"
        "}\n"
        "\n"
        "record good.sugar {\n"
        "  index = 1\n"
        "  tags  = []\n"
        "}\n";
    std::vector<Record> rs; std::string err;
    check(parse_records(src, rs, err), "multi-record source parses");
    check(rs.size() == 2, "two records");
    check(rs.size() == 2 && serialize_records(rs) == src, "grouped-file serialization matches");
    check(rs.size() == 2 && rs[1].find("tags") && rs[1].find("tags")->list.empty(), "empty list");
}

int main() {
    test_roundtrip();
    test_canonical_numbers();
    test_parse_errors();
    test_multi_and_lists();
    std::printf(g_fail ? "drydock tests: %d FAILED\n" : "drydock tests: ALL PASSED\n", g_fail);
    return g_fail ? 1 : 0;
}
