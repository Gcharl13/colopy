// drydock test harness -- the spec's hard gates live here (§10.4):
// text -> store -> text byte-identical, canonical number formatting, parser
// error quality. Grows with each Drydock phase.
#include "../text/rec_text.hpp"
#include "../schema/schema.hpp"
#include "../core/store.hpp"
#include "../../forge/drydock_bridge.hpp"
#include "rules.hpp"
#include "dd_gen.hpp"
#include <fstream>
#include <sstream>
#include <cstdio>
#include <string>
#include <vector>
#include <algorithm>
#include <dirent.h>
#include <sys/stat.h>

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

    // TERR: poison the four terrain arrays, reload, compare
    RuleData rt = def;
    for (size_t i = 0; i < rt.terrain_defense.size(); ++i) {
        rt.terrain_defense[i] = -999; rt.terrain_move[i] = -999;
        rt.terrain_improve[i] = -999; rt.terrain_value[i] = -999;
    }
    rt.cfg.food_growth_threshold = -999;                 // CONF spot-check
    rt.cfg.fortify_def_num = -999;
    check(forge::drydock_apply_base(rt, "data", msg), "parity: reload with terr/conf");
    bad = 0;
    for (size_t i = 0; i < rt.terrain_defense.size(); ++i)
        if (rt.terrain_defense[i] != def.terrain_defense[i] ||
            rt.terrain_move[i] != def.terrain_move[i] ||
            rt.terrain_improve[i] != def.terrain_improve[i] ||
            rt.terrain_value[i] != def.terrain_value[i]) ++bad;
    check(bad == 0, "parity: every TERR array == compiled defaults");
    check(rt.cfg.food_growth_threshold == def.cfg.food_growth_threshold &&
          rt.cfg.fortify_def_num == def.cfg.fortify_def_num,
          "parity: CONF scalars == compiled defaults");
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
    check(dd_all_types_count == 14 && std::string(good_type.code) == "good",
          "reflect: type registry populated (schm meta-type + natn/ffat/msge/text/sprt/pltt)");
}

static Store make_test_store() {
    // tiny synthetic schema with a ref field so the ref index is exercised
    const char* schm_src =
        "record schm.good { fields = [ { name = \"index\", type = \"int\" }, "
        "{ name = \"name\", type = \"str\" } ] }\n"
        "record schm.unit { fields = [ { name = \"index\", type = \"int\" }, "
        "{ name = \"eats\", type = \"ref<good>\" } ] }\n";
    const char* rec_src =
        "record good.food { index = 0 name = \"Food\" }\n"
        "record good.rum { index = 9 name = \"Rum\" }\n"
        "record unit.colonist { index = 0 eats = good.food }\n";
    std::vector<Record> schm, recs;
    std::string err;
    parse_records(schm_src, schm, err);
    parse_records(rec_src, recs, err);
    Schema sc;
    schema_load(schm, sc, err);
    Store s;
    if (!store_init(s, sc, recs, err)) std::printf("       store_init: %s\n", err.c_str());
    return s;
}

static void test_store() {
    Store s = make_test_store();
    std::string err;

    // lookup + handles
    check(store_find(s, "good.food") != nullptr, "store: find by id");
    check(store_handle(s, "good.rum") != DD_NULL_HANDLE, "store: handle assigned");
    check(store_handle(s, "good.nope") == DD_NULL_HANDLE, "store: missing id -> null handle");

    // ref index built at init
    auto uses = store_used_by(s, "good.food");
    check(uses.size() == 1 && uses[0].first == "unit.colonist" && uses[0].second == "eats",
          "store: ref index built (used-by)");

    // the chokepoint: set validates, journals, retargets the ref index
    Value nine = Value::make_int(9);
    check(store_set(s, "good.food", "index", &nine, err), "store: set int");
    check(store_find(s, "good.food")->find("index")->i == 9, "store: value applied");
    Value bad = Value::make_str("nope");
    check(!store_set(s, "good.food", "index", &bad, err), "store: type-mismatched set refused");
    Value rum = Value::make_token("good.rum");
    check(store_set(s, "unit.colonist", "eats", &rum, err), "store: ref retarget");
    check(store_used_by(s, "good.food").empty() && store_used_by(s, "good.rum").size() == 1,
          "store: ref index follows the edit");

    // safe delete: refused while referenced, allowed after clearing
    check(!store_delete(s, "good.rum", err) && err.find("unit.colonist") != std::string::npos,
          "store: delete refused with inbound-ref list");
    check(store_set(s, "unit.colonist", "eats", nullptr, err), "store: clear ref field");
    check(store_delete(s, "good.rum", err), "store: delete after refs cleared");
    check(store_find(s, "good.rum") == nullptr, "store: deleted record gone");

    // undo/redo round-trip across set/clear/delete
    check(store_undo(s, err), "store: undo delete");
    check(store_find(s, "good.rum") != nullptr, "store: record restored");
    check(store_undo(s, err), "store: undo clear");
    check(store_used_by(s, "good.rum").size() == 1, "store: ref index restored by undo");
    check(store_undo(s, err), "store: undo retarget");
    check(store_used_by(s, "good.food").size() == 1, "store: ref back on food");
    check(store_undo(s, err) && store_find(s, "good.food")->find("index")->i == 0,
          "store: undo set restores original value");
    check(!store_undo(s, err), "store: journal floor");
    // redo all the way forward
    while (store_redo(s, err)) {}
    check(store_find(s, "good.rum") == nullptr &&
          store_find(s, "good.food")->find("index")->i == 9,
          "store: redo replays to the final state");

    // add + undo add
    Record nr;
    nr.id = "good.cloth";
    nr.fields.push_back({"index", Value::make_int(11)});
    check(store_add(s, nr, err), "store: add record");
    check(store_handle(s, "good.cloth") != DD_NULL_HANDLE, "store: added record indexed");
    check(store_undo(s, err) && store_find(s, "good.cloth") == nullptr, "store: undo add");
    check(!s.dirty.empty(), "store: dirty set tracks edits");
}

static void walk_dir(const std::string& dir, std::vector<std::string>& out) {
    DIR* d = opendir(dir.c_str());
    if (!d) return;
    while (dirent* e = readdir(d)) {
        std::string n = e->d_name;
        if (n == "." || n == "..") continue;
        std::string p = dir + "/" + n;
        struct stat st{};
        if (stat(p.c_str(), &st) != 0) continue;
        if (S_ISDIR(st.st_mode)) walk_dir(p, out);
        else if (n.size() > 4 && n.substr(n.size() - 4) == ".rec") out.push_back(p);
    }
    closedir(d);
    std::sort(out.begin(), out.end());
}

static void test_real_refs() {
    // P2 real refs: prof.produces = ref<good>, data-sourced from the engine's
    // profession->good mapping (terrain yield columns for tile profs, the
    // colony_compute_production outputs for artisans). The store's ref index,
    // used-by, and safe delete run over the GENUINE data/base topology here.
    std::vector<std::string> files;
    std::vector<Record> schm, recs;
    std::string err;
    bool ok = true;
    walk_dir("data/schema", files);
    for (const auto& p : files) ok = ok && parse_records(slurp(p.c_str()), schm, err);
    files.clear();
    walk_dir("data/base", files);
    for (const auto& p : files) ok = ok && parse_records(slurp(p.c_str()), recs, err);
    Schema sc;
    ok = ok && schema_load(schm, sc, err);
    check(ok, "real refs: data/ parses");
    Store s;
    check(store_init(s, sc, recs, err), "real refs: store_init over data/base");
    if (!err.empty()) std::printf("       %s\n", err.c_str());

    // 18 producing professions carry the ref (0-17); the 10 classes don't
    int nrefs = 0;
    for (const Record& r : recs)
        if (r.type() == "prof" && r.find("produces")) ++nrefs;
    check(nrefs == 18, "real refs: 18 prof records carry produces");

    // Farmer AND Fisherman both produce Food (y_farmer / y_fisherman columns)
    auto food = store_used_by(s, "good.food");
    bool farmer = false, fisher = false;
    for (const auto& [src, fld] : food)
        if (fld == "produces") { farmer |= src == "prof.farmer"; fisher |= src == "prof.fisherman"; }
    check(food.size() == 2 && farmer && fisher, "real refs: good.food used by farmer + fisherman");

    // Statesman -> the Liberty Bells pseudo-good (index 18)
    auto bells = store_used_by(s, "good.liberty_bells");
    check(bells.size() == 1 && bells[0].first == "prof.statesman",
          "real refs: liberty_bells used by statesman only");

    // safe delete on the real topology: Rum is Distiller's output
    check(!store_delete(s, "good.rum", err) && err.find("prof.distiller") != std::string::npos,
          "real refs: delete good.rum refused, names prof.distiller");

    // a dangling ref is a validation error at the store chokepoint... shape only;
    // wrong TARGET TYPE is rejected here (existence is drydockc's whole-set gate)
    Value wrong = Value::make_token("unit.frigate");
    check(!store_set(s, "prof.farmer", "produces", &wrong, err),
          "real refs: ref to the wrong type refused");
    Value horses = Value::make_token("good.horses");
    check(store_set(s, "prof.farmer", "produces", &horses, err) &&
          store_used_by(s, "good.horses").size() == 1,
          "real refs: retarget updates the real index");
    check(store_undo(s, err) && store_used_by(s, "good.food").size() == 2,
          "real refs: undo restores the extraction truth");
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
    test_store();
    test_real_refs();
    std::printf(g_fail ? "drydock tests: %d FAILED\n" : "drydock tests: ALL PASSED\n", g_fail);
    return g_fail ? 1 : 0;
}
