// drydock test harness -- the spec's hard gates live here (§10.4):
// text -> store -> text byte-identical, canonical number formatting, parser
// error quality. Grows with each Drydock phase.
#include "../text/rec_text.hpp"
#include "../schema/schema.hpp"
#include "../../forge/drydock_bridge.hpp"
#include "rules.hpp"
#include "dd_gen.hpp"
#include <fstream>
#include <sstream>
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

static std::string slurp(const char* path) {
    std::ifstream f(path);
    std::stringstream ss; ss << f.rdbuf();
    return ss.str();
}

static void test_dicts() {
    const char* src =
        "record schm.demo {\n"
        "  fields = [{ name = \"x\", type = \"int\", min = 0, max = 5 }]\n"
        "}\n";
    std::vector<Record> rs; std::string err;
    check(parse_records(src, rs, err), "dict: schema-style source parses");
    std::string t2 = rs.empty() ? "" : serialize_records(rs);
    std::vector<Record> rs2;
    check(parse_records(t2, rs2, err) && !rs2.empty() &&
          value_equal(*rs[0].find("fields"), *rs2[0].find("fields")),
          "dict: value round-trips");
    err.clear(); rs.clear();
    check(!parse_records("record a.b { d = { k = 1, k = 2 } }", rs, err),
          "dict: duplicate key rejected");
}

static void test_schema() {
    // the real authored schemas load
    std::vector<Record> schm; std::string err;
    for (const char* p : {"data/schema/good.rec", "data/schema/unit.rec", "data/schema/prof.rec"}) {
        std::string s = slurp(p);
        check(!s.empty(), "schema file readable");
        check(parse_records(s, schm, err), "schema file parses");
        if (!err.empty()) { std::printf("       %s: %s\n", p, err.c_str()); err.clear(); }
    }
    Schema sc;
    check(schema_load(schm, sc, err), "schema_load on authored schemas");
    if (!err.empty()) std::printf("       err: %s\n", err.c_str());
    check(sc.find("good") && sc.find("unit") && sc.find("prof"), "three types loaded");
    check(sc.find("good") && sc.find("good")->find("burden") &&
          sc.find("good")->find("burden")->type == FType::Int, "field types parsed");

    // canonicalize: schema order + unknown-field rejection
    Record r;
    r.id = "good.food";
    r.fields.push_back({"name",  Value::make_str("Food")});
    r.fields.push_back({"index", Value::make_int(0)});
    check(schema_canonicalize(sc, r, err), "canonicalize ok");
    check(r.fields.size() == 2 && r.fields[0].name == "index", "fields re-ordered to schema order");
    Record bad = r;
    bad.fields.push_back({"bogus", Value::make_int(1)});
    check(!schema_canonicalize(sc, bad, err) && err.find("bogus") != std::string::npos,
          "canonicalize rejects unknown field");

    // validation: range + required + ref shape
    std::vector<std::string> ve;
    Record v; v.id = "prof.farmer";
    v.fields.push_back({"index", Value::make_int(99)});          // out of range
    schema_validate(sc, v, ve);
    bool range_hit = false, req_hit = false;
    for (const auto& e : ve) {
        if (e.find("out of range") != std::string::npos) range_hit = true;
        if (e.find("required field 'name'") != std::string::npos) req_hit = true;
    }
    check(range_hit, "validate flags out-of-range int");
    check(req_hit, "validate flags missing required field");
}

static void test_ruledata_parity() {
    // The migration hard gate: the values loaded from data/base/*.rec must be
    // IDENTICAL to the compiled defaults (which verify_rules.py proves equal
    // to the original extraction tables). Zero out the migrated fields first
    // so equality proves the values actually came from the records.
    using vc::sim::RuleData;
    RuleData def = vc::sim::make_default_rules();
    RuleData rd  = def;
    // @UNIT has 23 rows; units[23] is the zeroed padding slot with no record
    const size_t NU = rd.units.size() - 1;
    for (size_t i = 0; i < NU; ++i) { auto& u = rd.units[i];
        u.attack = -999; u.defense = -999; u.cargo = -999; u.movement = -999; }
    for (auto& c : rd.cargo) { c.start1 = c.start2 = c.lo = c.hi = c.burden = -999; }
    for (auto& j : rd.jobs)  { j.school_tier = -999; j.value = -999; }
    std::string msg;
    check(forge::drydock_apply_base(rd, "data", msg), "parity: drydock_apply_base loads data/");
    if (!msg.empty()) std::printf("       %s\n", msg.c_str());
    int bad = 0;
    for (size_t i = 0; i < NU; ++i)
        if (rd.units[i].attack != def.units[i].attack || rd.units[i].defense != def.units[i].defense ||
            rd.units[i].cargo != def.units[i].cargo || rd.units[i].movement != def.units[i].movement) ++bad;
    check(bad == 0, "parity: every UNIT field == compiled defaults");
    bad = 0;
    for (size_t i = 0; i < rd.cargo.size(); ++i)
        if (rd.cargo[i].start1 != def.cargo[i].start1 || rd.cargo[i].start2 != def.cargo[i].start2 ||
            rd.cargo[i].lo != def.cargo[i].lo || rd.cargo[i].hi != def.cargo[i].hi ||
            rd.cargo[i].burden != def.cargo[i].burden) ++bad;
    check(bad == 0, "parity: every GOOD market field == compiled defaults");
    bad = 0;
    for (size_t i = 0; i < rd.jobs.size(); ++i)
        if (rd.jobs[i].school_tier != def.jobs[i].school_tier || rd.jobs[i].value != def.jobs[i].value) ++bad;
    check(bad == 0, "parity: every PROF field == compiled defaults");
}

static void test_reflection() {
    // codegen'd struct + reflection tables: load a real record through the
    // generic runtime and get typed fields back; serialize returns the same
    // record (schema order, absent fields stay absent).
    std::string src = slurp("data/base/good/food.rec"), err;
    std::vector<Record> rs;
    check(parse_records(src, rs, err) && rs.size() == 1, "reflect: food.rec parses");
    DDGood g;
    check(load_good(rs[0], g), "reflect: generic load into DDGood");
    check(g.index == 0 && g.has_index, "reflect: index field");
    check(g.name == "Food" && g.has_name, "reflect: string field");
    check(g.burden == 7, "reflect: burden == 7 (the Food spread)");
    Record back = reflect_serialize(good_type, "good.food", &g);
    check(serialize_record(back) == src, "reflect: struct -> record -> text BYTE-IDENTICAL");
    check(dd_all_types_count == 3 && std::string(good_type.code) == "good",
          "reflect: type registry populated");
}

int main() {
    test_roundtrip();
    test_canonical_numbers();
    test_parse_errors();
    test_multi_and_lists();
    test_dicts();
    test_schema();
    test_ruledata_parity();
    test_reflection();
    std::printf(g_fail ? "drydock tests: %d FAILED\n" : "drydock tests: ALL PASSED\n", g_fail);
    return g_fail ? 1 : 0;
}
