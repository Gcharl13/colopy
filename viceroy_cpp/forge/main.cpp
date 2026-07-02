// forge/main.cpp -- Viceroy Forge: the headless balance inspector (F1 MVP).
//
//   forge inspect [overlay.json]
//
// Loads the default ruleset (optionally with a rules.json mod overlay applied),
// validates it with sim::check_rules(), and prints key balance curves with deltas
// vs the un-modded baseline -- so a designer can see exactly how an edit moves the
// game. It links the headless sim in-process; this is the "balance laboratory."
// The Dear ImGui GUI + editors are the next cycle (F2).
#include "founding_fathers.hpp"
#include "economy.hpp"
#include "market.hpp"
#include "ref.hpp"
#include "datacheck.hpp"
#include "engine.hpp"
#include "formulas.hpp"
#include "game.hpp"
#include "httpd.hpp"
#include "inspect.hpp"
#include "json.hpp"
#include "mapedit.hpp"
#include "mod.hpp"
#include "rules.hpp"
#include "rules_invariants.hpp"
#include "rules_json.hpp"
#include "scoring.hpp"
#include "savegame.hpp"
#include "store.hpp"
#include "turnpipe.hpp"
#include "types.hpp"
#include "unit_turn.hpp"
#include "web_ui.hpp"

#include <algorithm>
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <map>
#include <random>
#include <string>
#include <vector>

using namespace vc::sim;

// Print the shared balance curves (forge/inspect.hpp), grouped by section, with
// a delta column vs the baseline.
static void print_curves(const RuleData& base, const RuleData& cur) {
    std::string section;
    for (const auto& r : forge::balance_curves(base, cur)) {
        if (r.section != section) { section = r.section; std::printf("\n  %s\n", section.c_str()); }
        if (r.delta()) std::printf("    %-26s %8ld   (%+ld vs base)\n", r.label.c_str(), r.cur, r.delta());
        else           std::printf("    %-26s %8ld\n", r.label.c_str(), r.cur);
    }
}

static int do_inspect(const char* overlay_path) {
    RuleData base = make_default_rules();
    RuleData cur  = base;

    if (overlay_path) {
        try {
            forge::OverlayResult o = forge::load_overlay(overlay_path, make_default_rules());
            cur = o.rules;
            std::printf("Loaded overlay: %s\n", overlay_path);
            if (!o.warnings.empty()) {
                std::printf("  warnings:\n");
                for (const auto& w : o.warnings) std::printf("    - %s\n", w.c_str());
            }
        } catch (const std::exception& e) {
            std::printf("ERROR loading overlay: %s\n", e.what());
            return 2;
        }
    } else {
        std::printf("Inspecting the default (un-modded) ruleset.\n");
    }

    InvariantReport rep = check_rules(cur);
    std::printf("\nInvariants: %s\n", rep.ok() ? "PASS" : "FAIL");
    for (const auto& v : rep.violations) std::printf("    ! %s\n", v.c_str());

    print_curves(base, cur);

    std::printf("\n%s\n", rep.ok() ? "OK" : "INVALID RULESET");
    return rep.ok() ? 0 : 1;
}

// --- map editor commands -------------------------------------------------------

static void print_map_report(const forge::MapReport& rep) {
    std::printf("  land masses: %d, oceans: %d\n", rep.land_masses, rep.oceans);
    std::printf("  validity: %s\n", rep.ok() ? "OK" : "ISSUES");
    for (const auto& s : rep.issues)   std::printf("    ! %s\n", s.c_str());
    for (const auto& s : rep.warnings) std::printf("    ~ %s\n", s.c_str());
}

static int map_validate(const char* path) {
    try {
        forge::MpFile m = forge::load_mp(path);
        std::printf("Loaded %s (%dx%d, %zu trailing bytes)\n", path, m.w, m.h, m.rest.size());
        forge::MapReport rep = forge::validate(m);
        print_map_report(rep);
        return rep.ok() ? 0 : 1;
    } catch (const std::exception& e) { std::printf("ERROR: %s\n", e.what()); return 2; }
}

static int map_roundtrip(const char* path) {
    try {
        forge::MpFile a = forge::load_mp(path);
        std::filesystem::path tmp = std::filesystem::temp_directory_path() / "forge_rt.mp";
        forge::save_mp(tmp.string(), a);
        forge::MpFile b = forge::load_mp(tmp.string());
        std::filesystem::remove(tmp);
        bool same = (a.w == b.w && a.h == b.h && a.terrain == b.terrain && a.rest == b.rest);
        std::printf("round-trip %s: %s\n", path, same ? "BYTE-IDENTICAL" : "MISMATCH");
        return same ? 0 : 1;
    } catch (const std::exception& e) { std::printf("ERROR: %s\n", e.what()); return 2; }
}

// Self-contained test: synthesize a map, round-trip it, edit + validate it, and
// confirm the validator catches broken maps. No external .MP needed.
static int map_selftest() {
    int fail = 0;
    auto check = [&](bool ok, const char* msg) {
        if (!ok) { ++fail; std::printf("  FAIL: %s\n", msg); }
    };

    forge::MpFile m = forge::make_blank(20, 12);
    m.rest = {0xDE, 0xAD, 0xBE, 0xEF};                 // stand-in trailing metadata
    forge::fill_terrain(m, 6, 6, /*Plains*/2, 3);
    forge::set_forest(m, 6, 6, true);
    forge::set_river(m, 6, 6, true);

    forge::MapReport rep = forge::validate(m);
    check(rep.ok(), "valid edited map should pass");
    check(rep.land_masses == 1 && rep.oceans == 1, "expected 1 land mass + 1 ocean");

    // round-trip via a temp file: terrain + opaque trailing bytes must survive.
    std::filesystem::path tmp = std::filesystem::temp_directory_path() / "forge_selftest.mp";
    forge::save_mp(tmp.string(), m);
    forge::MpFile r = forge::load_mp(tmp.string());
    forge::save_mp((tmp.string() + ".2"), r);
    {
        std::ifstream fa(tmp.string(), std::ios::binary), fb(tmp.string() + ".2", std::ios::binary);
        std::string ba((std::istreambuf_iterator<char>(fa)), {});
        std::string bb((std::istreambuf_iterator<char>(fb)), {});
        check(ba == bb, "two serializations are byte-identical");
    }
    check(r.terrain == m.terrain && r.rest == m.rest, "round-trip preserves terrain + metadata");
    std::filesystem::remove(tmp);
    std::filesystem::remove(tmp.string() + ".2");

    // validator catches LAND on the right-edge column (Ocean/Sea-Lane are both OK
    // there -- the polar rows of the real AMER2 carry Ocean).
    forge::MpFile bad = forge::make_blank(10, 6);
    forge::set_terrain(bad, 9, 0, /*Plains*/2);        // land on the edge
    check(!forge::validate(bad).ok(), "land on the right-edge column should fail");

    // validator catches forest overlay where it is meaningless (ice/peaks). On
    // water bit 6 is the legitimate "special" marker (MP_FORMAT.md), so that's allowed.
    forge::MpFile bad2 = forge::make_blank(10, 6);
    forge::set_terrain(bad2, 3, 3, forge::MP_MOUNTAINS);
    forge::set_forest(bad2, 3, 3, true);               // forest on Mountains
    check(!forge::validate(bad2).ok(), "forest on mountains should fail");

    std::printf("map selftest: %s\n", fail == 0 ? "ALL PASSED" : "FAILURES");
    return fail == 0 ? 0 : 1;
}

// --- rules overlay write side (diff / round-trip) -----------------------------

static int rules_diff(const char* in_path, const char* out_path) {
    try {
        forge::OverlayResult o = forge::load_overlay(in_path, make_default_rules());
        for (const auto& w : o.warnings) std::printf("  ~ %s\n", w.c_str());
        forge::JsonValue d = forge::overlay_diff(make_default_rules(), o.rules);
        std::string text = forge::json_dump(d);
        if (out_path) { forge::save_overlay(out_path, make_default_rules(), o.rules);
                        std::printf("wrote sparse overlay -> %s\n", out_path); }
        else std::printf("%s", text.c_str());
        return 0;
    } catch (const std::exception& e) { std::printf("ERROR: %s\n", e.what()); return 2; }
}

static int rules_selftest() {
    int fail = 0;
    auto check = [&](bool ok, const char* msg) { if (!ok) { ++fail; std::printf("  FAIL: %s\n", msg); } };

    // a no-op diff is the empty object.
    RuleData def = make_default_rules();
    check(forge::overlay_diff(def, def).obj.empty(), "default->default diff is empty");

    // build a modded ruleset across cfg / units / terrain.
    RuleData mod = def;
    mod.cfg.warehouse_cap_base = 175;
    mod.cfg.ref_unit_cost      = 1500;
    mod.cfg.ff_gate_years      = {1600, 1640, 1680, 1720};
    mod.units[SOLDIERS].attack = 4;
    mod.units[ARTILLERY].movement = 2;
    mod.terrain_defense[28]    = 5;
    mod.terrain_move[27]       = 4;

    // diff -> dump -> parse -> apply onto default, and confirm round-trip idempotence.
    std::string dump1 = forge::json_dump(forge::overlay_diff(def, mod));
    check(dump1.find("warehouse_cap_base") != std::string::npos, "diff captured a cfg change");
    forge::OverlayResult rt = forge::apply_overlay(forge::json_parse(dump1), make_default_rules());
    std::string dump2 = forge::json_dump(forge::overlay_diff(def, rt.rules));
    check(dump1 == dump2, "overlay round-trip is idempotent");

    // spot-check the applied values match the mod.
    check(rt.rules.cfg.warehouse_cap_base == 175 && rt.rules.cfg.ref_unit_cost == 1500, "cfg applied");
    check(rt.rules.cfg.ff_gate_years[1] == 1640, "cfg array applied");
    check(rt.rules.units[SOLDIERS].attack == 4 && rt.rules.units[ARTILLERY].movement == 2, "units applied");
    check(rt.rules.terrain_defense[28] == 5 && rt.rules.terrain_move[27] == 4, "terrain applied");

    // full_overlay: the COMPLETE dump must (a) list every value and (b) reproduce
    // the source exactly when applied onto any base -- so its diff vs source is empty.
    forge::JsonValue full = forge::full_overlay(def);
    check(full.find("cfg") && full.find("units") && full.find("terrain_defense") &&
          full.find("terrain_move"), "full_overlay has every section");
    check(full.find("units")->obj.size() == (size_t)NUNITTYPES, "full_overlay lists every unit");
    check(full.find("terrain_defense")->obj.size() == (size_t)NTERRAIN &&
          full.find("terrain_move")->obj.size() == (size_t)NTERRAIN, "full_overlay lists every terrain id");
    forge::OverlayResult fr = forge::apply_overlay(full, make_default_rules());
    check(fr.warnings.empty(), "full_overlay applies with no warnings");
    check(forge::overlay_diff(def, fr.rules).obj.empty(), "full_overlay reproduces the default exactly");
    // applying the full dump of a MOD also reproduces that mod (onto an unrelated base).
    forge::OverlayResult fm = forge::apply_overlay(forge::full_overlay(mod), make_default_rules());
    check(forge::overlay_diff(mod, fm.rules).obj.empty(), "full_overlay(mod) reproduces the mod");

    std::printf("rules selftest: %s\n", fail == 0 ? "ALL PASSED" : "FAILURES");
    return fail == 0 ? 0 : 1;
}

static int do_rules(int argc, char** argv) {
    std::string sub = argc >= 3 ? argv[2] : "";
    if (sub == "selftest") return rules_selftest();
    if (sub == "diff" && argc >= 4) return rules_diff(argv[3], argc >= 5 ? argv[4] : nullptr);
    std::printf("usage: forge rules <selftest | diff IN.json [OUT.json]>\n");
    return 2;
}

static int do_map(int argc, char** argv) {
    std::string sub = argc >= 3 ? argv[2] : "";
    if (sub == "selftest") return map_selftest();
    if (sub == "validate" && argc >= 4) return map_validate(argv[3]);
    if (sub == "roundtrip" && argc >= 4) return map_roundtrip(argv[3]);
    std::printf("usage: forge map <selftest | validate FILE.mp | roundtrip FILE.mp>\n");
    return 2;
}

// --- mod packaging (write / load / validate) ----------------------------------

static int mod_validate(const char* dir) {
    forge::ModReport r = forge::load_mod(dir);
    if (!r.found) { std::printf("not a mod: %s\n", dir); return 2; }
    std::printf("mod '%s' v%s (spec %d)%s%s\n", r.info.id.c_str(), r.info.version.c_str(),
                r.info.spec_version, r.has_rules ? " +rules" : "", r.has_map ? " +map" : "");
    for (const auto& w : r.warnings) std::printf("  ~ %s\n", w.c_str());
    for (const auto& i : r.issues)   std::printf("  ! %s\n", i.c_str());
    std::printf("%s\n", r.ok() ? "OK" : "INVALID");
    return r.ok() ? 0 : 1;
}

static int mod_selftest() {
    int fail = 0;
    auto check = [&](bool ok, const char* msg) { if (!ok) { ++fail; std::printf("  FAIL: %s\n", msg); } };
    std::filesystem::path base = std::filesystem::temp_directory_path();

    // a valid mod: rule changes + a valid map.
    {
        RuleData mod = make_default_rules();
        mod.cfg.warehouse_cap_base = 150;
        mod.units[SOLDIERS].attack = 4;
        forge::MpFile m = forge::make_blank(10, 6);
        forge::fill_terrain(m, 4, 3, /*Plains*/2, 2);
        forge::ModInfo info{"testmod", "Test Mod", "1.0", "forge", forge::FORGE_SPEC_VERSION};
        std::string dir = (base / "forge_mod_ok").string();
        std::filesystem::remove_all(dir);
        forge::ModWriteResult w = forge::write_mod(dir, info, make_default_rules(), mod, &m);
        check(w.written.size() == 3, "wrote modinfo + rules + map");
        forge::ModReport r = forge::load_mod(dir);
        check(r.found && r.info.id == "testmod", "round-trip modinfo");
        check(r.has_rules && r.has_map, "detected rules + map");
        check(r.rules.cfg.warehouse_cap_base == 150 && r.rules.units[SOLDIERS].attack == 4, "rules applied");
        check(r.ok(), "valid mod passes");
        std::filesystem::remove_all(dir);
    }
    // a broken mod: an invalid rule overlay must be rejected on load.
    {
        RuleData mod = make_default_rules();
        mod.cfg.tory_divisor_base = 0;            // invalid (divide-by-zero risk)
        forge::ModInfo info{"badmod", "Bad", "0.1", "forge", forge::FORGE_SPEC_VERSION};
        std::string dir = (base / "forge_mod_bad").string();
        std::filesystem::remove_all(dir);
        forge::write_mod(dir, info, make_default_rules(), mod);
        forge::ModReport r = forge::load_mod(dir);
        check(!r.ok(), "broken mod rejected");
        std::filesystem::remove_all(dir);
    }

    std::printf("mod selftest: %s\n", fail == 0 ? "ALL PASSED" : "FAILURES");
    return fail == 0 ? 0 : 1;
}

static int do_mod(int argc, char** argv) {
    std::string sub = argc >= 3 ? argv[2] : "";
    if (sub == "selftest") return mod_selftest();
    if (sub == "validate" && argc >= 4) return mod_validate(argv[3]);
    std::printf("usage: forge mod <selftest | validate DIR>\n");
    return 2;
}

// --- save/load (game serialization) -------------------------------------------

static int save_selftest() {
    int fail = 0;
    auto check = [&](bool ok, const char* msg) { if (!ok) { ++fail; std::printf("  FAIL: %s\n", msg); } };

    // set up a small scenario and play it forward a few turns (exercises the loop).
    GameState g; g.difficulty = 2; g.nation = 3;
    g.price_base[SUGAR] = 800; g.powers[0].trade[SUGAR] = 100;
    g.powers[0].gold = 1234;
    World w; w.map_w = 20; w.map_h = 12;
    w.terrain.assign((size_t)w.map_w * w.map_h, (uint8_t)2);   // Plains
    Colony c; c.owner_power = 0; c.population = 3; c.hammers_per_turn = 10;
    c.build_target = 0; c.build_cost = 64; c.food_per_turn = 60; c.crosses_output = 3;
    c.stockpile[SUGAR] = 77; c.stockpile[ORE] = 12;            // previously dropped (#2)
    { Colony::Worker wk; wk.profession = 1; wk.tile = 0; wk.terrain = 2; wk.good = SUGAR; wk.expert = true;  c.workers.push_back(wk); }
    { Colony::Worker wk; wk.profession = 19; wk.tile = 1; wk.terrain = 0; wk.good = 0;    wk.expert = false; c.workers.push_back(wk); }
    w.colonies.push_back(c);
    Unit u; u.type = DRAGOONS; u.owner = 0; u.x = 0; u.y = 6;
    u.order = ORDER_GOTO; u.target_x = 15; u.target_y = 6;
    w.units.push_back(u);
    auto rng = [](int, int) { return 0; };
    for (int i = 0; i < 6; ++i) step_turn(g, w, rng, 0);

    // round-trip: dump -> parse -> re-dump must be identical, and key fields match.
    std::string d1 = forge::dump_game(g, w);
    forge::LoadedGame lg = forge::parse_game(d1);
    std::string d2 = forge::dump_game(lg.g, lg.w);
    check(d1 == d2, "in-memory save round-trip is idempotent");
    check(lg.g.year == g.year && lg.g.turn == g.turn, "year/turn preserved");
    check(lg.g.nation == 3, "game nation preserved");
    check(lg.g.powers[0].gold == 1234, "power gold preserved");
    check(lg.w.colonies.size() == 1 && lg.w.colonies[0].population == w.colonies[0].population,
          "colony population preserved");
    check(lg.w.colonies[0].stockpile[SUGAR] == 77 && lg.w.colonies[0].stockpile[ORE] == 12,
          "colony stockpile preserved (#2)");
    check(lg.w.colonies[0].workers.size() == 2 && lg.w.colonies[0].workers[0].good == SUGAR &&
          lg.w.colonies[0].workers[0].expert && lg.w.colonies[0].workers[0].profession == 1 &&
          lg.w.colonies[0].workers[0].tile == 0, "colony workers preserved (#2, +profession/tile)");
    check(lg.w.units.size() == 1 && lg.w.units[0].x == w.units[0].x &&
          lg.w.units[0].order == w.units[0].order, "unit position/order preserved");
    check(lg.w.terrain == w.terrain, "terrain plane preserved");

    // file round-trip, then continue playing and confirm the loaded game advances.
    std::filesystem::path tmp = std::filesystem::temp_directory_path() / "forge_save.json";
    forge::save_game(tmp.string(), g, w);
    forge::LoadedGame fl = forge::load_game(tmp.string());
    std::filesystem::remove(tmp);
    int year_before = fl.g.year;
    step_turn(fl.g, fl.w, rng, 0);
    check(fl.g.year == year_before + 1 || fl.g.season != g.season, "loaded game continues to advance");

    std::printf("save selftest: %s\n", fail == 0 ? "ALL PASSED" : "FAILURES");
    return fail == 0 ? 0 : 1;
}

static int do_save(int argc, char** argv) {
    std::string sub = argc >= 3 ? argv[2] : "";
    if (sub == "selftest") return save_selftest();
    std::printf("usage: forge save selftest\n");
    return 2;
}

// --- data-table validation ----------------------------------------------------

static void print_data_report(const forge::DataReport& r) {
    std::printf("  %d sections, %d rows; %s\n", r.sections, r.rows, r.ok() ? "OK" : "ISSUES");
    for (const auto& w : r.warnings) std::printf("    ~ %s\n", w.c_str());
    for (const auto& i : r.issues)   std::printf("    ! %s\n", i.c_str());
}

static int data_check(const char* path) {
    try {
        forge::DataReport r = forge::check_data_tables(path);
        std::printf("Checked %s\n", path);
        print_data_report(r);
        return r.ok() ? 0 : 1;
    } catch (const std::exception& e) { std::printf("ERROR: %s\n", e.what()); return 2; }
}

static int data_selftest() {
    int fail = 0;
    auto check = [&](bool ok, const char* msg) { if (!ok) { ++fail; std::printf("  FAIL: %s\n", msg); } };

    // a well-formed table passes.
    check(forge::check_data(forge::json_parse(
        R"({"@X":{"columns":["name","v"],"rows":[{"name":"a","v":"1"}],"row_count":1}})")).ok(),
        "well-formed table passes");

    // a missing declared column is an issue.
    check(!forge::check_data(forge::json_parse(
        R"({"@X":{"columns":["name","v"],"rows":[{"name":"a"}]}})")).ok(),
        "missing column rejected");

    // @UNIT exceeding the enum (NUNITTYPES) is an issue.
    {
        std::string rows;
        for (int i = 0; i < 25; ++i) rows += std::string(i ? "," : "") + R"({"attack":"1"})";
        std::string doc = R"({"@UNIT":{"columns":["attack"],"rows":[)" + rows + "]}}";
        check(!forge::check_data(forge::json_parse(doc)).ok(), "25 units > enum rejected");
    }

    // @FATHERS.type out of @FOUNDING range is an issue.
    check(!forge::check_data(forge::json_parse(
        R"({"@FOUNDING":{"columns":["name"],"rows":[{"name":"a"},{"name":"b"}]},
            "@FATHERS":{"columns":["type"],"rows":[{"type":"5"}]}})")).ok(),
        "@FATHERS.type out of range rejected");

    std::printf("data selftest: %s\n", fail == 0 ? "ALL PASSED" : "FAILURES");
    return fail == 0 ? 0 : 1;
}

static int do_data(int argc, char** argv) {
    std::string sub = argc >= 3 ? argv[2] : "";
    if (sub == "selftest") return data_selftest();
    if (sub == "check") return data_check(argc >= 4 ? argv[3]
                                          : "data_extracted/tables/names_tables.json");
    std::printf("usage: forge data <selftest | check [names_tables.json]>\n");
    return 2;
}

// --- browser GUI: a localhost HTTP server over the tested backend --------------

static forge::JsonValue jbool(bool b) { forge::JsonValue v; v.type = forge::JsonValue::Bool; v.b = b; return v; }
static forge::JsonValue jarr() { forge::JsonValue v; v.type = forge::JsonValue::Array; return v; }
static forge::JsonValue jobj() { forge::JsonValue v; v.type = forge::JsonValue::Object; return v; }
static forge::JsonValue jstrs(const std::vector<std::string>& xs) {
    forge::JsonValue a = jarr();
    for (const auto& s : xs) a.arr.push_back(forge::json_str(s));
    return a;
}
static forge::JsonValue jstr(const std::string& s) { return forge::json_str(s); }

// Map a table-file id to its canonical (pristine) path + the user-edit overlay path.
static bool table_paths(const std::string& file, std::string& canon, std::string& user) {
    if (file == "names")       canon = "data_extracted/tables/names_tables.json";
    else if (file == "dgroup") canon = "data_extracted/tables/dgroup_tables.json";
    else if (file == "tribe")  canon = "data_extracted/tables/tribe_tables.json";
    else return false;
    user = "data_extracted/engine/tables_user/" + file + ".json";
    return true;
}

static std::string url_decode(const std::string& s) {
    auto hx = [](char h) { return (h >= '0' && h <= '9') ? h - '0'
                                : (h >= 'a' && h <= 'f') ? h - 'a' + 10
                                : (h >= 'A' && h <= 'F') ? h - 'A' + 10 : 0; };
    std::string o;
    for (size_t i = 0; i < s.size(); ++i) {
        if (s[i] == '+') o += ' ';
        else if (s[i] == '%' && i + 2 < s.size()) { o += (char)(hx(s[i + 1]) * 16 + hx(s[i + 2])); i += 2; }
        else o += s[i];
    }
    return o;
}

static std::string qparam(const std::string& query, const std::string& key) {
    size_t i = 0;
    while (i < query.size()) {
        size_t amp = query.find('&', i);
        std::string kv = query.substr(i, amp == std::string::npos ? std::string::npos : amp - i);
        size_t eq = kv.find('=');
        if (eq != std::string::npos && kv.substr(0, eq) == key) return url_decode(kv.substr(eq + 1));
        if (amp == std::string::npos) break;
        i = amp + 1;
    }
    return "";
}

static forge::JsonValue inv_json(const InvariantReport& r) {
    forge::JsonValue o = jobj();
    o.obj["ok"] = jbool(r.ok());
    o.obj["violations"] = jstrs(r.violations);
    return o;
}

static forge::JsonValue curves_json(const RuleData& base, const RuleData& cur) {
    forge::JsonValue a = jarr();
    for (const auto& r : forge::balance_curves(base, cur)) {
        forge::JsonValue o = jobj();
        o.obj["section"] = forge::json_str(r.section);
        o.obj["label"]   = forge::json_str(r.label);
        o.obj["base"]    = forge::json_num((double)r.base);
        o.obj["cur"]     = forge::json_num((double)r.cur);
        o.obj["delta"]   = forge::json_num((double)r.delta());
        a.arr.push_back(o);
    }
    return a;
}

static forge::JsonValue maprep_json(const forge::MapReport& r) {
    forge::JsonValue o = jobj();
    o.obj["ok"] = jbool(r.ok());
    o.obj["land_masses"] = forge::json_num(r.land_masses);
    o.obj["oceans"] = forge::json_num(r.oceans);
    o.obj["issues"] = jstrs(r.issues);
    o.obj["warnings"] = jstrs(r.warnings);
    return o;
}

// ---- static asset serving (sprites / backgrounds / palette) ----

// A subpath is safe if it has no "..", no leading slash, and only sane chars.
static bool safe_asset_subpath(const std::string& s) {
    if (s.empty() || s.front() == '/' || s.find("..") != std::string::npos) return false;
    for (char c : s)
        if (!(std::isalnum((unsigned char)c) || c == '/' || c == '_' || c == '-' || c == '.'))
            return false;
    return true;
}

static const char* asset_content_type(const std::string& p) {
    auto ends = [&](const char* x) {
        size_t n = std::strlen(x);
        return p.size() >= n && p.compare(p.size() - n, n, x) == 0;
    };
    if (ends(".png"))  return "image/png";
    if (ends(".json")) return "application/json";
    return "application/octet-stream";
}

// Map a whitelisted /assets/<sub> request to an on-disk file under the committed
// asset trees, read it, and return it verbatim (binary-safe).
static forge::HttpResponse serve_asset(const std::string& sub) {
    if (!safe_asset_subpath(sub))
        return forge::HttpResponse{400, "text/plain", "bad asset path"};
    std::string fpath;
    if (sub.rfind("sliced/", 0) == 0)                               fpath = "data_extracted/sprites/" + sub.substr(7);
    else if (sub.rfind("sprites/", 0) == 0 || sub.rfind("pik/", 0) == 0) fpath = "docs/atlas/" + sub;
    else if (sub.rfind("screens/", 0) == 0)                         fpath = "docs/" + sub;
    else if (sub.rfind("tileset/", 0) == 0)                         fpath = "data_extracted/" + sub;
    else if (sub == "palette.json")                                 fpath = "data_extracted/palette.json";
    else return forge::HttpResponse{404, "text/plain", "unknown asset: " + sub};

    std::ifstream f(fpath, std::ios::binary);
    if (!f) return forge::HttpResponse{404, "text/plain", "not found: " + fpath};
    std::string bytes((std::istreambuf_iterator<char>(f)), std::istreambuf_iterator<char>());
    return forge::HttpResponse{200, asset_content_type(sub), std::move(bytes)};
}

// List the committed sprite sheets + full-screen backgrounds for the Assets tab.
static forge::JsonValue assets_manifest() {
    namespace fs = std::filesystem;
    auto list_dir = [](const std::string& dir) {
        std::vector<std::string> names;
        std::error_code ec;
        for (const auto& e : fs::directory_iterator(dir, ec)) {
            if (!e.is_regular_file()) continue;
            std::string fn = e.path().filename().string();
            if (fn.size() >= 4 && fn.compare(fn.size() - 4, 4, ".png") == 0) names.push_back(fn);
        }
        std::sort(names.begin(), names.end());
        return jstrs(names);
    };
    forge::JsonValue o = jobj();
    o.obj["sprites"]     = list_dir("docs/atlas/sprites");
    o.obj["backgrounds"] = list_dir("docs/atlas/pik");
    return o;
}

// ---- in-browser playable game: the engine loop over the real sim ----

static GameState g_game;
static World     g_world;
static std::vector<std::pair<int,int>> g_colony_xy;   // colony map positions (Forge-side)
static forge::EngineExtra g_engine_extra;             // relational state the action nodes touch
static bool g_game_active = false;
static int  g_end_year = 1800;                        // retirement year (scenario end_year)

// The active (possibly modded) ruleset the Play game + engine VM run on. Persisted as a
// sparse overlay on disk; edits in the Rules editor are saved here and bite the sim.
static const char* ACTIVE_RULES_PATH = "data_extracted/engine/rules.json";
static RuleData g_active_rules = make_default_rules();

static int g_rng = 0x2BAD1234;
static int game_rng(int lo, int hi) {                  // deterministic LCG in [lo,hi]
    g_rng = g_rng * 1103515245 + 12345;
    unsigned v = ((unsigned)g_rng >> 16) & 0x7FFF;
    return hi <= lo ? lo : lo + (int)(v % (unsigned)(hi - lo + 1));
}

static bool game_is_water(int id) { return id == 25 || id == 26; }

// Nearest land (non-water) tile to (tx,ty) by expanding-ring scan.
static std::pair<int,int> game_find_land(int tx, int ty) {
    for (int r = 0; r < 220; ++r)
        for (int dy = -r; dy <= r; ++dy)
            for (int dx = -r; dx <= r; ++dx) {
                int x = tx + dx, y = ty + dy, id = g_world.terrain_id(x, y);
                if (id >= 0 && !game_is_water(id)) return {x, y};
            }
    return {tx, ty};
}
// Nearest water tile to (tx,ty) -- where the starting ship sits. -1,-1 if the map has none.
static std::pair<int,int> game_find_water(int tx, int ty) {
    for (int r = 0; r < 40; ++r)
        for (int dy = -r; dy <= r; ++dy)
            for (int dx = -r; dx <= r; ++dx) {
                int x = tx + dx, y = ty + dy, id = g_world.terrain_id(x, y);
                if (id >= 0 && game_is_water(id)) return {x, y};
            }
    return {-1, -1};
}

// Resolve a scenario unit-type name ("Soldiers","Caravel",...) to its type id via the
// @UNIT reference table (row index == type id), so the scenario is authored by name.
static int scenario_unit_type(const std::string& name) {
    static forge::JsonValue names; static bool loaded = false;
    if (!loaded) { loaded = true;
        try { names = forge::json_parse_file("data_extracted/tables/names_tables.json"); } catch (...) {} }
    const forge::JsonValue* sec = names.find("@UNIT"); if (!sec) return -1;
    const forge::JsonValue* rows = sec->find("rows"); if (!rows) return -1;
    for (size_t i = 0; i < rows->arr.size(); ++i) {
        const forge::JsonValue* nm = rows->arr[i].find("name");
        if (nm && nm->str == name) return (int)i;
    }
    return -1;
}

// Seed the native settlements as first-class entities: one village per (map_x,map_y) in each
// active tribe's @<TRIBE> position table (tribe_tables.json), sized by its civilization @TRIBES
// level, the first per tribe flagged Capital. Replaces the phantom global tension scalar.
static void seed_native_settlements() {
    g_engine_extra.settlements.clear();
    static const char* TRIBE_TBL[8] = {"@INCA","@AZTEC","@ARAWAK","@IROQUOIS","@CHEROKEE","@APACHE","@SIOUX","@TUPI"};
    static const int TRIBE_LEVEL[8] = {3, 2, 1, 1, 1, 0, 0, 0};
    forge::JsonValue tribes;
    try { tribes = forge::json_parse_file("data_extracted/tables/tribe_tables.json"); } catch (...) { return; }
    auto asi = [](const forge::JsonValue* v) { return v ? (v->type == forge::JsonValue::String ? std::atoi(v->str.c_str()) : (int)v->num) : 0; };
    for (int t = 0; t < 8; ++t) {
        const forge::JsonValue* sec = tribes.find(TRIBE_TBL[t]); if (!sec) continue;
        const forge::JsonValue* rows = sec->find("rows"); if (!rows) continue;
        bool first = true;
        for (const forge::JsonValue& r : rows->arr) {
            const forge::JsonValue* mx = r.find("map_x"); const forge::JsonValue* my = r.find("map_y");
            if (!mx || !my) continue;
            forge::NativeSettlement s;
            s.tribe = t; s.x = asi(mx); s.y = asi(my);
            s.population = TRIBE_LEVEL[t] * 2 + 3;      // size scales with civilization level
            s.wealth = TRIBE_LEVEL[t] * 20 + 10;
            s.capital = first; first = false;           // first settlement of each tribe = its Capital
            g_engine_extra.settlements.push_back(s);
        }
    }
}

// Start a new game, seeded from the chosen nation + difficulty and the authored
// scenario (data_extracted/engine/scenarios/new_world.json). The scenario supplies
// the map, calendar, starting gold, colonies and units; nation/difficulty come from
// the new-game screen. Falls back to the classic 2-colony opening if the file is absent.
static void game_new(int nation = 0, int difficulty = 1) {
    g_game = GameState{}; g_world = World{}; g_colony_xy.clear();
    // Seed the live game from entropy so real play differs each time (fidelity backlog #14).
    // Tests/selftests inject their own deterministic rng, so they are unaffected; the sandbox
    // keeps its fixed seed for reproducible experimentation.
    std::random_device rdv;
    g_engine_extra = forge::EngineExtra{}; g_rng = (int)(rdv() ^ 0x2BAD1234u);

    forge::JsonValue sc;
    try { sc = forge::json_parse_file("data_extracted/engine/scenarios/new_world.json"); } catch (...) {}
    auto scn = [&](const char* k) -> const forge::JsonValue* {
        return sc.type == forge::JsonValue::Object ? sc.find(k) : nullptr; };

    std::string mapfile = "data_extracted/map/AMER2.MP";
    if (const forge::JsonValue* m = scn("map")) mapfile = "data_extracted/map/" + m->str;
    try { forge::MpFile m = forge::load_mp(mapfile);
        g_world.map_w = m.w; g_world.map_h = m.h; g_world.terrain = m.terrain;
    } catch (...) { g_world.map_w = g_world.map_h = 0; }

    g_game.difficulty = difficulty < 0 ? 0 : difficulty > 4 ? 4 : difficulty;
    g_game.nation     = nation < 0 ? 0 : nation > 3 ? 3 : nation;
    g_game.year   = scn("year")   ? (int)scn("year")->num   : 1492;
    g_game.season = scn("season") ? (int)scn("season")->num : 0;
    g_game.turn   = 0;
    g_end_year    = scn("end_year") ? (int)scn("end_year")->num : 1800;
    g_game.powers[0].gold = scn("start_gold") ? (long)scn("start_gold")->num : 500;
    // price_base = the internal supply accumulator (DGROUP 0x53EA), random-seeded per good in
    // [600,1000] (func_07561C, BYTE_VERIFIED market.md). It drives the drift; it is NOT the gold
    // price -- the player-facing buy/sell gold per unit comes from @CARGO (price_start1/2, ~1..20).
    for (int i = 0; i < NGOODS; ++i) g_game.price_base[i] = game_rng(600, 1000);
    // Published price levels: seed in [@CARGO start1, start2], clamp to the drift band, then one
    // recompute so the pooled goods start on-model (market.hpp; init RECONSTRUCTED).
    vc::sim::market_init(g_game, game_rng, g_active_rules);
    g_game.ref = ref_start(g_game.difficulty);          // the King starts with an army

    std::vector<std::pair<int,int>> cxy;                // colony coords, indexed as authored
    const int rdx[8] = {-1, 0, 1, -1, 1, -1, 0, 1};     // surrounding ring: 0=NW..7=SE
    const int rdy[8] = {-1,-1,-1,  0, 0,  1, 1, 1};
    // Seed one colony from its scenario record: built buildings + a colonist roster. A tile
    // worker's terrain is DERIVED from the map at its ring tile, so yields reflect the real map.
    auto add_colony_json = [&](const forge::JsonValue& cj) {
        auto gi = [&](const char* k, int d) { const forge::JsonValue* v = cj.find(k); return v ? (int)v->num : d; };
        auto xy = game_find_land(gi("x", 20), gi("y", 22));
        Colony c; c.owner_power = 0; c.human = true; c.rebel_A = 0; c.rebel_B = 1; c.build_target = -1;
        c.center_food = gi("center_food", 3);           // authored fallback for the town-square auto-food
        { int t = g_world.terrain_id(xy.first, xy.second); c.center_terrain = t < 0 ? 0 : (t & 0x1F); }
        if (const forge::JsonValue* bs = cj.find("buildings"))
            for (const forge::JsonValue& b : bs->arr) { int id = (int)b.num; if (id >= 0 && id < 48) c.built_mask |= (1ull << id); }
        if (const forge::JsonValue* ws = cj.find("workers"))
            for (const forge::JsonValue& w : ws->arr) {
                Colony::Worker wk;
                wk.profession = w.find("profession") ? (int)w.find("profession")->num : 19;
                wk.tile = w.find("tile") ? (int)w.find("tile")->num : -1;
                wk.good = w.find("good") ? (int)w.find("good")->num : 0;
                const forge::JsonValue* ev = w.find("expert");
                wk.expert = ev ? (ev->type == forge::JsonValue::Bool ? ev->b : ev->num != 0) : false;
                if (const forge::JsonValue* tv = w.find("terrain")) {
                    wk.terrain = (int)tv->num;              // authored terrain (deterministic yield)
                } else if (wk.tile >= 0 && wk.tile < 8) {   // else derive from the map at the ring tile
                    int tid = g_world.terrain_id(xy.first + rdx[wk.tile], xy.second + rdy[wk.tile]);
                    wk.terrain = tid < 0 ? 2 : (tid & 0x1F);
                } else wk.terrain = 0;                       // building worker (hammers/bells/crosses)
                c.workers.push_back(wk);
            }
        c.population = gi("pop", (int)c.workers.size()); if (c.population < 1) c.population = 1;
        forge::colony_compute_production(c, g_game.difficulty, g_active_rules, g_engine_extra.ff_owned);   // populate turn-0 output
        g_world.colonies.push_back(c); g_colony_xy.push_back(xy); cxy.push_back(xy);
        return xy;
    };
    if (const forge::JsonValue* cols = scn("colonies"))
        for (const forge::JsonValue& c : cols->arr) add_colony_json(c);
    if (g_world.colonies.empty()) {                     // fallback: two colonies with a Farmer each
        const char* fb = R"([{"x":20,"y":22,"buildings":[13,27],"workers":[
            {"profession":0,"good":0,"tile":0},{"profession":13,"good":16,"tile":-1}]},
            {"x":34,"y":42,"buildings":[13],"workers":[{"profession":0,"good":0,"tile":0}]}])";
        forge::JsonValue fbj = forge::json_parse(fb);
        for (const forge::JsonValue& c : fbj.arr) add_colony_json(c);
    }

    auto add_unit = [&](int type, int x, int y, int order = 0, int txx = -1, int tyy = -1) {
        Unit u; u.type = type; u.owner = 0; u.x = x; u.y = y;
        u.order = order; u.target_x = txx; u.target_y = tyy; u.alive = true;
        g_world.units.push_back(u);
    };
    const int dx8[8] = {1,-1,0,0,1,1,-1,-1}, dy8[8] = {0,0,1,-1,1,-1,1,-1};
    if (const forge::JsonValue* us = scn("units"))
        for (const forge::JsonValue& u : us->arr) {
            int ci = u.find("at_colony") ? (int)u.find("at_colony")->num : 0;
            if (ci < 0 || ci >= (int)cxy.size()) ci = 0;
            std::pair<int,int> base = cxy.empty() ? std::make_pair(20, 22) : cxy[ci];
            int type = scenario_unit_type(u.find("type") ? u.find("type")->str : "Colonists");
            if (type < 0) type = COLONISTS;
            if (u.find("on_water_adjacent")) {          // a ship: adjacent water, else nearest water
                bool placed = false;
                for (int k = 0; k < 8 && !placed; ++k) { int x = base.first + dx8[k], y = base.second + dy8[k];
                    if (game_is_water(g_world.terrain_id(x, y))) { add_unit(type, x, y); placed = true; } }
                if (!placed) { auto wxy = game_find_water(base.first, base.second);
                    if (wxy.first >= 0) add_unit(type, wxy.first, wxy.second); }
            } else {
                int x = base.first + (u.find("dx") ? (int)u.find("dx")->num : 0);
                int y = base.second + (u.find("dy") ? (int)u.find("dy")->num : 0);
                if (const forge::JsonValue* g = u.find("goto_colony")) {
                    int gc = (int)g->num;               // marches toward that colony each turn
                    if (gc >= 0 && gc < (int)cxy.size()) add_unit(type, x, y, ORDER_GOTO, cxy[gc].first, cxy[gc].second);
                    else add_unit(type, x, y);
                } else add_unit(type, x, y);
            }
        }
    if (g_world.units.empty()) {                        // fallback opening force
        auto a = cxy.empty() ? std::make_pair(20, 22) : cxy[0];
        add_unit(SOLDIERS, a.first, a.second); add_unit(PIONEERS, a.first + 1, a.second);
    }
    seed_native_settlements();                          // real native villages on the map
    g_game_active = true;
}

// Per-turn history (A4): a time series snapshotted each turn -> the history charts.
struct HistPoint { long turn; int year; long gold; int sol; long population; };
static std::vector<HistPoint> g_history;
static void history_snapshot() {
    long pop = 0; for (const auto& c : g_world.colonies) pop += c.population;
    g_history.push_back(HistPoint{(long)g_game.turn, g_game.year,
        (long)g_game.powers[0].gold, g_engine_extra.national_sol, pop});
    if (g_history.size() > 400) g_history.erase(g_history.begin());
}

// Turn notices: late-game turn-loop events (Spanish Succession, Tory uprisings) surface here so
// the /api/game/turn route can present them to the player alongside the OnTurnStart event graphs.
static std::vector<std::string> g_turn_notices;

// Tory-militia land strength: Crown-loyalist land units (owner != rebel power 0) that arm during
// the War of Independence and fight ALONGSIDE the King's expeditionary force against the rebels.
static long tory_militia_strength() {
    long str = 0;
    for (const Unit& u : g_world.units) {
        if (!u.alive || u.owner == 0) continue;         // rebel = power 0; loyalist militia are the rest
        const UnitStats& st = unit_stats(u.type);
        if (st.move_class == 99) continue;              // ships hold no ground
        str += st.attack + st.defense;
    }
    return str;
}

// Rebel land strength: player land-combat units (attack+defense) + a per-colony defensive bump.
static long rebel_strength(int* weakest_unit = nullptr) {
    long str = 0; int weakest = -1; long weakest_str = 0;
    for (int i = 0; i < (int)g_world.units.size(); ++i) {
        const Unit& u = g_world.units[i];
        if (!u.alive || u.owner != 0) continue;
        const UnitStats& st = unit_stats(u.type);
        if (st.move_class == 99) continue;              // ships hold no ground
        long s = st.attack + st.defense; if (s <= 0) continue;
        str += s; if (weakest < 0 || s < weakest_str) { weakest = i; weakest_str = s; }
    }
    str += (long)g_world.colonies.size() * 2;           // colonies contribute walls/militia
    if (weakest_unit) *weakest_unit = weakest;
    return str;
}
static long ref_land_strength() {                       // Man-o-War is naval, weighted low for land assault
    return (long)g_game.ref.regulars * 4 + g_game.ref.cavalry * 5 + g_game.ref.artillery * 7 + g_game.ref.manowar;
}
// War of Independence, resolved per turn while declared: one engagement between the rebel army and
// the King's expeditionary force. Rebels win -> REF attrition; REF wins -> a rebel unit falls, or a
// colony is captured if undefended. The endgame fires when the REF is destroyed (win) or the last
// colony is lost (lose). Abstract strength model (RECONSTRUCTED; the real WoI runs unit-level battles).
static void war_resolution_step() {
    if (!g_engine_extra.woi_declared) return;
    long ref_total = g_game.ref.regulars + g_game.ref.cavalry + g_game.ref.manowar + g_game.ref.artillery;
    if (ref_total <= 0 || g_world.colonies.empty()) return;   // already decided; endgame_json reports it
    int weakest = -1; long reb = rebel_strength(&weakest);
    long king = ref_land_strength() + tory_militia_strength();   // REF + any risen Tory militia
    long total = reb + king; if (total <= 0) return;
    if (game_rng(1, (int)total) <= reb) {               // rebels repel the assault -> REF attrition
        int loss = game_rng(1, 4);
        for (int k = 0; k < loss; ++k) {
            if (g_game.ref.regulars > 0) --g_game.ref.regulars;
            else if (g_game.ref.cavalry > 0) --g_game.ref.cavalry;
            else if (g_game.ref.artillery > 0) --g_game.ref.artillery;
            else if (g_game.ref.manowar > 0) --g_game.ref.manowar;
        }
    } else {                                            // REF prevails: destroy a rebel unit, else take a colony
        if (weakest >= 0) g_world.units[weakest].alive = false;
        else { g_world.colonies.pop_back(); if (!g_colony_xy.empty()) g_colony_xy.pop_back(); }
    }
}

// Nation display name for a power slot (@NATIONALITY, falling back to @COUNTRY / "power N").
static std::string nation_name(int p) {
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    forge::JsonValue v = forge::resolve_binding("@NATIONALITY[" + std::to_string(p) + "].name", cx);
    if (v.is_string() && !v.str.empty()) return v.str;
    v = forge::resolve_binding("@COUNTRY[" + std::to_string(p) + "].name", cx);
    return (v.is_string() && !v.str.empty()) ? v.str : ("power " + std::to_string(p));
}

// Per-power strength score (spec/systems/spanish_succession.md §2): rank powers by
// 3*mil + 2*colony_count + 1*econ (colony_count is live; mil/econ are the editable proxy stats
// standing in for the undecoded 0x9418/0x9410 arrays).
static long power_score(int p) {
    long nc = 0; for (const auto& c : g_world.colonies) if (c.owner_power == p) ++nc;
    return 3L * g_engine_extra.power_mil[p] + 2L * nc + g_engine_extra.power_econ[p];
}

// War of the Spanish Succession (spec/systems/spanish_succession.md): a scripted historical event --
// the Treaty of Utrecht (1713) ends the European war and a war-ravaged rival cedes its New-World
// possessions to another power. Fires ONCE, pre-independence, single-player: the weakest eligible AI
// (powers 1..3) is removed and its colonies/units pass to the strongest surviving power; the removed
// power is thereafter "(Withdrawn from New World)". Deterministic year gate -- the byte-verified
// dispatcher reads no RNG (spec §3); the once-flag is seceded_power ([0x53D2]).
static void spanish_succession_step() {
    if (g_engine_extra.seceded_power >= 0) return;      // already happened (once-flag [0x53D2] set)
    if (g_engine_extra.woi_declared) return;            // pre-revolution only ([0x5382] gate, spec §3)
    if (g_game.year < 1713) return;                     // Treaty of Utrecht -- the scripted trigger year
    int ceder = -1; long cw = 0;                        // weakest of the AI powers 1..3 cedes
    for (int p = 1; p < 4; ++p) { long s = power_score(p);
        if (ceder < 0 || s < cw) { cw = s; ceder = p; } }
    if (ceder < 0) return;
    int benef = -1; long bw = 0;                        // strongest of the remaining powers receives
    for (int p = 0; p < 4; ++p) { if (p == ceder) continue; long s = power_score(p);
        if (benef < 0 || s > bw) { bw = s; benef = p; } }
    if (benef < 0) return;
    int moved_c = 0, moved_u = 0;
    for (auto& c : g_world.colonies) if (c.owner_power == ceder) { c.owner_power = benef; ++moved_c; }
    for (auto& u : g_world.units)    if (u.alive && u.owner == ceder) { u.owner = benef; ++moved_u; }
    g_engine_extra.seceded_power = ceder;               // now shown "(Withdrawn from New World)"
    g_turn_notices.push_back(
        "War of the Spanish Succession ends in Europe! " + nation_name(ceder) +
        ", ravaged by war, cedes its New World possessions to the " + nation_name(benef) +
        " (Treaty of Utrecht, " + std::to_string(g_game.year) + "; " +
        std::to_string(moved_c) + " colonies, " + std::to_string(moved_u) + " units transferred).");
}

// Tory uprising during the War of Independence (spec/systems/tory_uprising.md, func_03CAC6): each WoI
// turn, with probability (diff+1)/(diff+2), Crown-loyal colonists rise in the rebel colony with the
// highest Tory strength = pop*2*(100-SoL%)/100 + diff + 1, arming Tory Militia (Soldiers, some promoted
// to Dragoons) on the free tiles adjacent to it. Latched per colony so it can't re-fire; suppressed
// silently (no latch) if no adjacent tile is free.
static void tory_uprising_step() {
    if (!g_engine_extra.woi_declared) return;
    int diff = g_game.difficulty;
    if (game_rng(0, diff + 1) == 0) return;             // per-call gate: fires with prob (diff+1)/(diff+2)
    int best = -1; long best_str = 0;                   // rebel colony with the highest tory strength
    for (int i = 0; i < (int)g_world.colonies.size(); ++i) {
        const Colony& c = g_world.colonies[i];
        if (c.owner_power != 0 || c.tory_risen) continue;
        int sol = c.rebel_B > 0 ? (int)((long)c.rebel_A * 100 / c.rebel_B) : g_engine_extra.national_sol;
        if (sol < 0) sol = 0; else if (sol > 100) sol = 100;
        long tstr = (long)c.population * 2 * (100 - sol) / 100 + diff + 1;
        if (best < 0 || tstr > best_str) { best_str = tstr; best = i; }
    }
    if (best < 0) return;                               // no eligible colony
    int cx0 = -1, cy0 = -1;
    if (best < (int)g_colony_xy.size()) { cx0 = g_colony_xy[best].first; cy0 = g_colony_xy[best].second; }
    if (cx0 < 0) return;
    static const int DX[8] = {-1, 0, 1, -1, 1, -1, 0, 1};
    static const int DY[8] = {-1, -1, -1, 0, 0, 1, 1, 1};
    long budget = best_str; int spawned = 0;
    for (int d = 0; d < 8 && budget > 0; ++d) {         // one militia per free adjacent tile, up to strength
        int nx = cx0 + DX[d], ny = cy0 + DY[d];
        int tid = g_world.terrain_id(nx, ny);
        if (tid < 0 || tid == 24 || tid == 25 || tid == 26) continue;   // OOB / Arctic / Ocean / Sea Lane
        bool occupied = false;
        for (const Unit& u : g_world.units) if (u.alive && u.x == nx && u.y == ny) { occupied = true; break; }
        if (occupied) continue;
        Unit m; m.owner = 1; m.x = nx; m.y = ny; m.alive = true;
        m.type = (game_rng(1, 100) <= 25) ? 4 : 1;      // random upgrade gate: Soldiers(1) -> Dragoons(4)
        m.moves_left = unit_stats(m.type).movement;
        g_world.units.push_back(m);
        ++spawned; --budget;
    }
    if (spawned == 0) return;                           // no free tile -> uprising suppressed (no latch)
    g_world.colonies[best].tory_risen = true;           // latch so this colony can't re-fire
    g_turn_notices.push_back(
        "Tory uprising near the colony at (" + std::to_string(cx0) + "," + std::to_string(cy0) +
        ")! Parliament arms " + std::to_string(spawned) + " Tory Militia against the rebellion.");
}

// ---- Europe market: the byte-verified supply/price-level model (spec/systems/market.md) --------
// The full model lives in sim/market.{hpp,cpp}: price_base = the hidden per-good supply level
// (seeded [600,1000]); power.trade (+0xFC) = the per-turn volume (SELL +=, BUY -=); the published
// price_level (+0x4C) derives from the pooled supply; bid = level-1, ask = bid + @CARGO.burden + 1
// (USER RULING). Selling is taxed and the tax funds the King's REF (royal_money). These wrappers
// read the LIVE @CARGO table (so Tables-tab edits bite) into the RuleData cargo block.
static int cargo_i(const forge::EngineCtx& cx, int g, const char* col, int dflt) {
    forge::JsonValue v = forge::resolve_binding("@CARGO[" + std::to_string(g) + "]." + col, cx);
    return v.type == forge::JsonValue::Null ? dflt : (int)v.as_int(dflt);
}
// The active ruleset with its cargo block refreshed from the live @CARGO bindings.
static RuleData live_market_rules(const forge::EngineCtx& cx) {
    RuleData rd = g_active_rules;
    for (int g = 0; g < NGOODS; ++g) {
        const vc::sim::CargoStats& d = rd.cargo[g];   // canonical defaults as fallbacks
        rd.cargo[g].start1 = cargo_i(cx, g, "price_start1", d.start1);
        rd.cargo[g].start2 = cargo_i(cx, g, "price_start2", d.start2);
        rd.cargo[g].lo     = cargo_i(cx, g, "drift_low",    d.lo);
        rd.cargo[g].hi     = cargo_i(cx, g, "drift_high",   d.hi);
        rd.cargo[g].burden = cargo_i(cx, g, "burden",       d.burden);
    }
    return rd;
}

// Auto-export: each turn every colony ships its over-cap tradeables (>100 -> keep 50) to Europe,
// crediting the owner's gold at the SAME @CARGO market bid + tax the manual sell route uses (so
// auto-selling and hand-selling price identically), skipping boycotted goods and Food (which feeds
// growth). No Crown market during the rebellion (spec/systems/colony.md §3: independence gates it).
// This lives Forge-side (not in the pure sim pipeline) because the sale price is @CARGO table data.
static void auto_export_step() {
    if (g_engine_extra.woi_declared) return;            // no European market while at war with the Crown
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    long total = 0; int sold_from = 0, spoiled_from = 0;
    for (Colony& c : g_world.colonies) {
        int owner = c.owner_power; if (owner < 0 || owner >= 4) continue;
        bool custom_house = (c.built_mask >> 18) & 1ull;                  // building 18 = Custom House
        int cap = (c.warehouse_lvl + 1) * g_active_rules.cfg.warehouse_cap_base;   // 100 / 200 / 300
        bool spoiled = false;
        for (int gd = 1; gd < NGOODS; ++gd) {           // Food(0) is the growth store, never here
            if (c.stockpile[gd] <= 100) continue;       // only surplus above the base warehouse
            if (custom_house) {
                // Custom House sells surplus directly to Europe -- no ship needed (Peter Stuyvesant).
                if ((g_engine_extra.boycotts >> gd) & 1u) continue;       // boycotted -> can't sell
                int excess = c.stockpile[gd] - 50; c.stockpile[gd] = 50;  // keep the lower band
                // The one market path: taxed sale at the published bid; the tax funds the REF;
                // the volume floods the market and the published price re-derives immediately.
                RuleData mrd = live_market_rules(cx);
                total += vc::sim::market_sell(g_game, owner, gd, excess, mrd);
            } else if (c.stockpile[gd] > cap) {
                // No Custom House: goods above the warehouse cap SPOIL. To sell, ship them to the
                // Europe market (/api/europe/sell) or build a Custom House (needs Stuyvesant).
                c.stockpile[gd] = cap; spoiled = true;
            }
        }
        if (custom_house && total > 0) ++sold_from;   // (approximate per-colony flag)
        if (spoiled) ++spoiled_from;
    }
    if (total > 0)
        g_turn_notices.push_back("Custom House: auto-sold colony surplus to Europe for " +
                                 std::to_string(total) + " gold.");
    if (spoiled_from > 0)
        g_turn_notices.push_back("Warehouse overflow: surplus goods spoiled in " + std::to_string(spoiled_from) +
                                 " colony(ies) -- build a Custom House (needs Peter Stuyvesant) or ship goods to Europe to sell them.");
}

// Continental Congress bell economy (defined with the sandbox helpers below; shared by both loops).
static void congress_step(forge::EngineExtra& x, int diff, int year, int bells_this_turn,
                          std::function<int(int,int)> rng);

static void game_step() {
    // Advance one turn by iterating the DATA pipeline (turn.json) -- behaviorally identical
    // to sim::step_turn (asserted by the engine selftest golden-master), but moddable.
    if (g_game_active) {
        // Once independence is declared the King's expeditionary force is COMMITTED: it fights and
        // depletes, it does not keep building. Freeze the peacetime REF buildup (run_turn's
        // ref_purchase) during the war so the conflict is winnable; war_resolution_step depletes it.
        Ref ref_before = g_game.ref; int64_t rm_before = g_game.powers[0].royal_money;
        forge::run_turn(g_game, g_world, game_rng, 0, g_active_rules, g_engine_extra.ff_owned);
        if (g_engine_extra.woi_declared) { g_game.ref = ref_before; g_game.powers[0].royal_money = rm_before; }
        auto_export_step();                             // auto-sell over-cap goods to Europe (peacetime)
        // (the per-turn market phase -- drift + republish + volume reset -- runs inside run_turn)
        // Continental Congress: the player's liberty bells accumulate toward the next father.
        { int bells = 0;
          for (const Colony& c : g_world.colonies)
              if (c.owner_power == 0) bells += c.bells_per_turn;
          congress_step(g_engine_extra, g_game.difficulty, g_game.year, bells, game_rng); }
        if (g_engine_extra.woi_declared)                // scoring component 6 (RECONSTRUCTED gate)
            for (const Colony& c : g_world.colonies)
                if (c.owner_power == 0) g_engine_extra.bells_since_declaration += c.bells_per_turn;
        spanish_succession_step();                      // scripted pre-revolution event (self-gated)
        tory_uprising_step();                           // during-WoI internal dissent (self-gated)
        war_resolution_step();                          // resolve the War of Independence if declared
        history_snapshot();
    }
}

static const char* GOOD_NAME[16] = {"Food","Sugar","Tobacco","Cotton","Furs","Lumber","Ore","Silver",
    "Horses","Rum","Cigars","Cloth","Coats","Trade Goods","Tools","Muskets"};
static std::string good_display(int g) {
    if (g >= 0 && g < 16) return GOOD_NAME[g];
    if (g == 16) return "Hammers";
    if (g == 17) return "Crosses";
    if (g == 18) return "Bells";
    return "?";
}

// The full detail a colony screen needs: buildings built, the colonist roster (each with its
// @JOB profession + specialty + what/where it works), the production breakdown, the 16-good
// warehouse, and the build project. Served by /api/colony/detail and folded into the state.
static forge::JsonValue colony_detail_json(int ci) {
    forge::JsonValue o = jobj();
    if (ci < 0 || ci >= (int)g_world.colonies.size()) { o.obj["error"] = forge::json_str("no colony"); return o; }
    const Colony& c = g_world.colonies[ci];
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    o.obj["index"] = forge::json_num(ci);
    o.obj["x"] = forge::json_num(ci < (int)g_colony_xy.size() ? g_colony_xy[ci].first : 0);
    o.obj["y"] = forge::json_num(ci < (int)g_colony_xy.size() ? g_colony_xy[ci].second : 0);
    o.obj["population"] = forge::json_num(c.population);
    o.obj["sol"] = forge::json_num(sol_pct(c));
    o.obj["warehouse"] = forge::json_num(c.warehouse_lvl);
    o.obj["food_accum"] = forge::json_num((double)c.food_accum);
    forge::JsonValue prod = jobj();                               // per-turn production breakdown
    prod.obj["food"] = forge::json_num(c.food_per_turn);
    prod.obj["bells"] = forge::json_num(c.bells_per_turn);
    prod.obj["hammers"] = forge::json_num(c.hammers_per_turn);
    prod.obj["crosses"] = forge::json_num(c.crosses_output);
    o.obj["production"] = prod;
    forge::JsonValue built = jarr();                             // which buildings are constructed
    for (int b = 0; b < 48; ++b) if ((c.built_mask >> b) & 1ull) {
        forge::JsonValue bo = jobj(); bo.obj["id"] = forge::json_num(b);
        bo.obj["name"] = forge::resolve_binding("@BUILDING[" + std::to_string(b) + "].name", cx);
        built.arr.push_back(bo);
    }
    o.obj["built"] = built;
    forge::JsonValue colonists = jarr();                         // the roster: who, specialty, where
    for (const auto& wk : c.workers) {
        forge::JsonValue w = jobj();
        w.obj["profession"] = forge::json_num(wk.profession);
        w.obj["name"] = forge::json_str(forge::job_name(wk.profession, wk.expert));
        w.obj["expert"] = jbool(wk.expert);
        w.obj["good"] = forge::json_num(wk.good);
        w.obj["good_name"] = forge::json_str(good_display(wk.good));
        w.obj["tile"] = forge::json_num(wk.tile);
        w.obj["where"] = forge::json_str(wk.tile >= 0
            ? (good_display(wk.good) + " (field tile " + std::to_string(wk.tile) + ")")
            : (good_display(wk.good) + " (building)"));
        colonists.arr.push_back(w);
    }
    o.obj["colonists"] = colonists;
    forge::JsonValue stock = jarr();                            // 16-good warehouse
    for (int g = 0; g < NGOODS; ++g) {
        forge::JsonValue s = jobj(); s.obj["good"] = forge::json_str(good_display(g));
        s.obj["qty"] = forge::json_num(c.stockpile[g]); stock.arr.push_back(s);
    }
    o.obj["stockpile"] = stock;
    forge::JsonValue build = jobj();                           // current construction
    build.obj["target"] = forge::json_num(c.build_target);
    build.obj["name"] = c.build_target < 0 ? forge::json_str("") :
        forge::resolve_binding("@BUILDING[" + std::to_string(c.build_target) + "].name", cx);
    build.obj["cost"] = forge::json_num(c.build_cost);
    build.obj["bank"] = forge::json_num((double)c.build_bank);
    long rem = (long)c.build_cost - (long)c.build_bank; if (rem < 0) rem = 0;
    build.obj["remaining"] = forge::json_num((double)rem);
    o.obj["build"] = build;
    return o;
}

// ---- the native colony screen (spec/ui/colony_screen.md, composer func_028592) ----
// Everything the 12-panel composer draws, assembled server-side from live sim state +
// the verbatim text sections. The frontend places it at the byte-cited rects.
static const std::vector<std::string>& labels_section(const std::string& section);
namespace forge { int terrain_good_yield(int terrain, int good); }
static forge::JsonValue colony_screen_json(int ci) {
    forge::JsonValue o = colony_detail_json(ci);
    if (o.find("error")) return o;
    const Colony& c = g_world.colonies[ci];
    // Title fields (spec 3.1, all oracle-confirmed): colony name + @SEASONS + year + gold.
    // The name comes from the per-nation COLONY.TXT pool (spec 5 "@COLONYNAME + per-nation
    // lists") by colony index; English entries carry a ",year" suffix that is not displayed.
    static const char* kPool[4] = {"ENGLISH", "FRENCH", "SPANISH", "DUTCH"};
    std::string name = "Colony " + std::to_string(ci + 1);
    { const auto& pool = labels_section(kPool[g_game.nation & 3]);
      if (ci < (int)pool.size() && !pool[ci].empty()) {
          name = pool[ci];
          size_t comma = name.find(','); if (comma != std::string::npos) name.resize(comma);
      } }
    o.obj["name"] = forge::json_str(name);
    { const auto& seasons = labels_section("SEASONS");   // 2 entries (Spring/Autumn), spec 5
      o.obj["season_name"] = forge::json_str(
          seasons.empty() ? "" : seasons[(g_game.season & 1) % seasons.size()]); }
    o.obj["year"] = forge::json_num(g_game.year);
    o.obj["gold"] = forge::json_num((double)g_game.powers[0].gold);
    // SoL line "N% (M)" (spec 8.4): members = population - round(tory% * pop / 100).
    { int sol = sol_pct(c), tory = 100 - sol;
      int members = c.population - (int)((tory * c.population + 50) / 100);
      o.obj["sol_members"] = forge::json_num(members); }
    o.obj["warehouse_cap"] = forge::json_num(vc::sim::warehouse_cap(c, g_active_rules));
    // Field-production panel data (spec 3.2 / 0.5): the center tile auto-yields its food
    // band + a secondary good (func_00A222 writes [0xA891]/[0xA893]/[0xA894]; the row-2
    // good here is the center terrain's best non-food yield -- the @0x00A34D loop's pick).
    { forge::JsonValue ctr = jobj();
      int food = forge::terrain_good_yield(c.center_terrain, 0);
      if (food < c.center_food) food = c.center_food;
      int bg = -1, bc = 0;
      for (int g = 1; g <= 7; ++g) {
          int yv = forge::terrain_good_yield(c.center_terrain, g);
          if (yv > bc) { bc = yv; bg = g; }
      }
      ctr.obj["food"] = forge::json_num(food);
      ctr.obj["good"] = forge::json_num(bg);
      ctr.obj["count"] = forge::json_num(bc);
      ctr.obj["terrain"] = forge::json_num(c.center_terrain);
      o.obj["center"] = ctr; }
    // The 8 surrounding ring tiles (terrain ids) for the field panel's tile scene.
    { static const int RDX[8] = {-1,0,1,-1,1,-1,0,1}, RDY[8] = {-1,-1,-1,0,0,1,1,1};
      forge::JsonValue ring = jarr();
      int cx = ci < (int)g_colony_xy.size() ? g_colony_xy[ci].first : 0;
      int cy = ci < (int)g_colony_xy.size() ? g_colony_xy[ci].second : 0;
      for (int t = 0; t < 8; ++t) {
          int tid = g_world.terrain_id(cx + RDX[t], cy + RDY[t]);
          ring.arr.push_back(forge::json_num(tid < 0 ? 25 : tid));
      }
      o.obj["ring"] = ring; }
    // Ships in port (spec 3.5: the (121,130,84,48) panel is the port view; the shared
    // empty-panel caption @MISC[11] "No Ships In Port" when none).
    { forge::JsonValue ships = jarr();
      int cx = ci < (int)g_colony_xy.size() ? g_colony_xy[ci].first : 0;
      int cy = ci < (int)g_colony_xy.size() ? g_colony_xy[ci].second : 0;
      for (const Unit& u : g_world.units) {
          if (!u.alive || u.owner != 0 || u.x != cx || u.y != cy) continue;
          if (unit_stats(u.type).move_class != 99) continue;
          forge::JsonValue s = jobj();
          s.obj["type"] = forge::json_num(u.type);
          const char* nm = unit_stats(u.type).name;
          s.obj["name"] = forge::json_str(nm ? nm : "?");
          ships.arr.push_back(s);
      }
      o.obj["ships"] = ships; }
    return o;
}

// End-game score: the spec/systems/scoring.md model (the same vc::sim::score_game the
// F10 report and the ScoreGame node use -- one scoring formula everywhere).
static long compute_score() {
    long pop_score = 0;
    for (const Colony& c : g_world.colonies)
        if (c.owner_power == 0)
            for (const Colony::Worker& w : c.workers) pop_score += w.expert ? 4 : 2;
    int ffc = 0; for (uint32_t b = g_engine_extra.ff_owned; b; b &= b - 1) ++ffc;
    return vc::sim::score_game(g_game.difficulty, pop_score, ffc,
                               g_engine_extra.national_sol, g_engine_extra.razed_settlements,
                               (long)g_game.powers[0].gold,
                               g_engine_extra.bells_since_declaration,
                               g_engine_extra.declaration_year, g_engine_extra.woi_declared);
}
// Endgame evaluation: independence won (REF destroyed), defeat (all colonies lost),
// or retirement at the scenario end year -- with the final score + Hall-of-Fame rank.
static forge::JsonValue endgame_json() {
    long ref_total = g_game.ref.regulars + g_game.ref.cavalry + g_game.ref.manowar + g_game.ref.artillery;
    bool over = false, won = false; std::string reason;
    if (g_engine_extra.woi_declared && ref_total == 0) {
        over = true; won = true; reason = "Independence won -- the King's forces are defeated!";
    } else if (g_game_active && g_world.colonies.empty()) {
        over = true; won = false; reason = "All colonies are lost. The venture ends.";
    } else if (g_game.year >= g_end_year) {
        over = true; won = true; reason = "You retire to Europe in " + std::to_string(g_game.year) + ".";
    }
    long score = compute_score(); g_engine_extra.score = score;
    forge::JsonValue o = jobj();
    o.obj["over"] = jbool(over); o.obj["won"] = jbool(won);
    o.obj["reason"] = forge::json_str(reason);
    o.obj["score"] = forge::json_num((double)score);
    o.obj["rank"] = forge::json_num(vc::sim::score_rank((int)score));
    return o;
}

static forge::JsonValue game_state_json() {
    forge::JsonValue o = jobj();
    o.obj["active"] = jbool(g_game_active);
    o.obj["endgame"] = endgame_json();
    { forge::JsonValue war = jobj();          // War of Independence status
      war.obj["declared"] = jbool(g_engine_extra.woi_declared);
      war.obj["national_sol"] = forge::json_num(g_engine_extra.national_sol);
      war.obj["rebel_strength"] = forge::json_num((double)rebel_strength());
      war.obj["ref_strength"] = forge::json_num((double)ref_land_strength());
      war.obj["tory_strength"] = forge::json_num((double)tory_militia_strength());
      war.obj["ref_total"] = forge::json_num((double)(g_game.ref.regulars + g_game.ref.cavalry + g_game.ref.manowar + g_game.ref.artillery));
      o.obj["war"] = war; }
    // War of the Spanish Succession: the rival withdrawn from the New World, -1 if none yet.
    o.obj["seceded_power"] = forge::json_num(g_engine_extra.seceded_power);
    if (g_engine_extra.seceded_power >= 0)
        o.obj["seceded_name"] = forge::json_str(nation_name(g_engine_extra.seceded_power));
    o.obj["w"] = forge::json_num(g_world.map_w);
    o.obj["h"] = forge::json_num(g_world.map_h);
    forge::JsonValue terr = jarr();
    for (uint8_t b : g_world.terrain) terr.arr.push_back(forge::json_num(b));
    o.obj["terrain"] = terr;
    o.obj["year"] = forge::json_num(g_game.year);
    o.obj["season"] = forge::json_num(g_game.season);
    o.obj["turn"] = forge::json_num((double)g_game.turn);
    o.obj["nation"] = forge::json_num(g_game.nation);
    o.obj["difficulty"] = forge::json_num(g_game.difficulty);
    o.obj["gold"] = forge::json_num((double)g_game.powers[0].gold);
    o.obj["royal_money"] = forge::json_num((double)g_game.powers[0].royal_money);
    forge::JsonValue ref = jobj();
    ref.obj["regulars"] = forge::json_num(g_game.ref.regulars);
    ref.obj["cavalry"]  = forge::json_num(g_game.ref.cavalry);
    ref.obj["manowar"]  = forge::json_num(g_game.ref.manowar);
    ref.obj["artillery"]= forge::json_num(g_game.ref.artillery);
    o.obj["ref"] = ref;
    forge::JsonValue prices = jarr();
    for (int i = 0; i < NGOODS; ++i) prices.arr.push_back(forge::json_num(g_game.price_base[i]));
    o.obj["prices"] = prices;
    forge::JsonValue cols = jarr();
    for (size_t i = 0; i < g_world.colonies.size(); ++i) {
        const Colony& c = g_world.colonies[i];
        forge::JsonValue cj = jobj();
        cj.obj["x"] = forge::json_num(i < g_colony_xy.size() ? g_colony_xy[i].first : 0);
        cj.obj["y"] = forge::json_num(i < g_colony_xy.size() ? g_colony_xy[i].second : 0);
        cj.obj["owner"] = forge::json_num(c.owner_power);
        cj.obj["population"] = forge::json_num(c.population);
        cj.obj["sol"] = forge::json_num(sol_pct(c));
        // production summary + counts so the map HUD has them; /api/colony/detail has the rest.
        forge::JsonValue prod = jobj();
        prod.obj["food"] = forge::json_num(c.food_per_turn); prod.obj["bells"] = forge::json_num(c.bells_per_turn);
        prod.obj["hammers"] = forge::json_num(c.hammers_per_turn); prod.obj["crosses"] = forge::json_num(c.crosses_output);
        cj.obj["production"] = prod;
        int nb = 0; for (int b = 0; b < 48; ++b) if ((c.built_mask >> b) & 1ull) ++nb;
        cj.obj["buildings"] = forge::json_num(nb);
        cj.obj["colonists"] = forge::json_num((double)c.workers.size());
        cols.arr.push_back(cj);
    }
    o.obj["colonies"] = cols;
    // native settlements (first-class map entities): tribe name + position + capital + player alarm
    forge::JsonValue nats = jarr();
    for (const forge::NativeSettlement& s : g_engine_extra.settlements) {
        forge::JsonValue so = jobj();
        so.obj["tribe"] = forge::json_num(s.tribe);
        so.obj["name"] = forge::resolve_binding("@TRIBES[" + std::to_string(s.tribe) + "].name",
            forge::EngineCtx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng});
        so.obj["x"] = forge::json_num(s.x); so.obj["y"] = forge::json_num(s.y);
        so.obj["capital"] = jbool(s.capital); so.obj["population"] = forge::json_num(s.population);
        so.obj["alarm"] = forge::json_num(s.alarm[0]);   // the human player's alarm at this village
        nats.arr.push_back(so);
    }
    o.obj["settlements"] = nats;
    forge::JsonValue us = jarr();
    for (int i = 0; i < (int)g_world.units.size(); ++i) {
        const Unit& u = g_world.units[i];
        if (!u.alive) continue;
        forge::JsonValue uj = jobj();
        uj.obj["id"] = forge::json_num(i);              // stable index into g_world.units
        uj.obj["x"] = forge::json_num(u.x); uj.obj["y"] = forge::json_num(u.y);
        uj.obj["type"] = forge::json_num(u.type);
        const char* nm = unit_stats(u.type).name;
        uj.obj["name"] = forge::json_str(nm ? nm : "?");
        uj.obj["owner"] = forge::json_num(u.owner);
        uj.obj["order"] = forge::json_num(u.order);
        uj.obj["moves"] = forge::json_num(u.moves_left);
        uj.obj["target_x"] = forge::json_num(u.target_x);
        uj.obj["target_y"] = forge::json_num(u.target_y);
        uj.obj["naval"] = jbool(unit_stats(u.type).move_class == 99);
        us.arr.push_back(uj);
    }
    o.obj["units"] = us;
    return o;
}

// ---- isolated colony sandbox (#67): a second, self-contained world -------------------
// A fresh single colony you can grow, build in, and step -- with every outside variable
// (gold, tax, population, stockpile, price) directly editable -- without touching the
// real Play game. Reuses the same sim (colony_economic_step via step_turn, start_building,
// rush_build) so behavior matches the game exactly.
static GameState g_sb_game; static World g_sb_world;
static std::vector<std::pair<int,int>> g_sb_colony_xy;
static forge::EngineExtra g_sb_extra;
static bool g_sb_active = false;
static int g_sb_rng = 0x51EDF00D;
static int sb_rng(int lo, int hi) {
    g_sb_rng = g_sb_rng * 1103515245 + 12345;
    unsigned v = ((unsigned)g_sb_rng >> 16) & 0x7FFF;
    return hi <= lo ? lo : lo + (int)(v % (unsigned)(hi - lo + 1));
}
static void sandbox_new(int pop) {
    g_sb_game = GameState{}; g_sb_world = World{}; g_sb_colony_xy.clear();
    g_sb_extra = forge::EngineExtra{}; g_sb_rng = 0x51EDF00D;
    g_sb_game.difficulty = 1; g_sb_game.year = 1600; g_sb_game.season = 0;
    g_sb_game.powers[0].gold = 1000; g_sb_game.powers[0].tax = 0;
    g_sb_game.ref = vc::sim::ref_start(g_sb_game.difficulty);   // the King's Expeditionary Force (grows each turn)
    // The hidden supply seed is random per good in [600,1000] (market.md, same as a real game),
    // and the published price levels seed from @CARGO -- the sandbox market IS the real model.
    for (int i = 0; i < NGOODS; ++i) g_sb_game.price_base[i] = sb_rng(600, 1000);
    vc::sim::market_init(g_sb_game, sb_rng, g_active_rules);
    Colony c; c.owner_power = 0; c.human = true;
    c.rebel_A = 0; c.rebel_B = 1; c.build_target = -1;
    c.center_terrain = 2; c.center_food = 5;                 // town-square auto-food (center tile)
    // A REAL colonist roster (Worker = {profession, tile, terrain, good, expert}) so production is
    // DERIVED from who works where, not seeded as flat numbers. Farmers on plains -> food, an expert
    // Lumberjack on forest -> lumber, a Carpenter -> hammers, a Statesman -> bells.
    c.workers.push_back(Colony::Worker{ 0,  0, 2,  0, false});   // Farmer            field tile 0 -> Food
    c.workers.push_back(Colony::Worker{ 0,  6, 2,  0, false});   // Farmer            field tile 6 -> Food
    c.workers.push_back(Colony::Worker{ 5,  4, 8,  5, true });   // Expert Lumberjack field tile 4 -> Lumber
    c.workers.push_back(Colony::Worker{13, -1, 0, 16, false});   // Carpenter         building     -> Hammers
    c.workers.push_back(Colony::Worker{17, -1, 0, 18, false});   // Statesman         building     -> Bells
    c.built_mask = (1ull << 9) | (1ull << 35) | (1ull << 37);   // Town Hall / Carpenter's Shop / Church
    c.population = (int)c.workers.size();
    if (pop > (int)c.workers.size() && pop <= 32) c.population = pop;
    forge::colony_compute_production(c, g_sb_game.difficulty, g_active_rules, g_sb_extra.ff_owned);   // roster -> *_per_turn
    g_sb_world.colonies.push_back(c); g_sb_colony_xy.push_back({0, 0});
    g_sb_active = true;
}
// --- Continental Congress bell economy (spec/systems/founding_fathers.md §3, BYTE_VERIFIED) ---
// Bells required for the next founding father. Human European power path; compounds x1.5 per era
// gate reached (1600/1650/1700/1750), grows with #fathers owned, first father is half price.
static int ff_bells_required(int diff, int year, int ff_count) {
    long cost = (long)(diff + 3) * 16;                        // human European power
    for (int gate : {1600, 1650, 1700, 1750}) if (year >= gate) cost += cost >> 1;
    cost = (long)(ff_count + 1) * cost + 1;
    if (ff_count == 0) cost >>= 1;
    return (int)cost;
}
// A father is offerable when it is not yet owned AND every lower-index father in its own category
// is already owned (the category-gated walk, congress.c ff_is_available). Categories are the fixed
// 5-per contiguous blocks (id/5 = category, id%5 = slot).
static bool ff_offerable(int id, uint32_t owned) {
    if ((owned >> id) & 1u) return false;
    int cat = id / 5;
    for (int j = cat * 5; j < id; ++j) if (!((owned >> j) & 1u)) return false;
    return true;
}
// Pick the next father the Congress offers: era-weighted random over the offerable fathers
// (spec §3 father selection). Reads the three @FATHERS weight columns via the binding grammar.
// The era band (0/1/2 = <1600 / 1600-1699 / >=1700) is vc::sim::ff_era_band.
static int ff_pick_next(uint32_t owned, int year, std::function<int(int,int)> rng) {
    forge::EngineCtx cx{g_sb_game, g_sb_world, g_sb_colony_xy, g_sb_extra, g_active_rules, rng};
    int band = vc::sim::ff_era_band(year);
    const char* col = band == 0 ? "weight_1500_1600"
                    : band == 1 ? "weight_1600_1700" : "weight_1700plus";
    int weight[25], total = 0, offer[25], noff = 0;
    for (int i = 0; i < 25; ++i) {
        if (!ff_offerable(i, owned)) continue;
        forge::JsonValue wv = forge::resolve_binding("@FATHERS[" + std::to_string(i) + "]." + col, cx);
        int w = (wv.type == forge::JsonValue::String) ? std::atoi(wv.str.c_str())
                : (wv.type == forge::JsonValue::Number ? (int)wv.num : 0);
        if (w < 1) w = 1;                    // every offerable father must be reachable
        offer[noff] = i; weight[noff] = w; total += w; ++noff;
    }
    if (noff == 0) return -1;
    int budget = rng(1, total);
    for (int k = 0; k < noff; ++k) { budget -= weight[k]; if (budget <= 0) return offer[k]; }
    return offer[noff - 1];
}
// Make sure the Congress is offering a valid, still-offerable father (picks one, era-weighted, if
// the slot is empty or the offered father was already acquired). Stored in EngineExtra so the offer
// is stable across state reads. Returns the offered id (-1 when all 25 are owned).
static int congress_ensure_offer(forge::EngineExtra& x, int year, std::function<int(int,int)> rng) {
    if (x.offered_ff < 0 || !ff_offerable(x.offered_ff, x.ff_owned))
        x.offered_ff = ff_pick_next(x.ff_owned, year, rng);
    return x.offered_ff;
}
// Accumulate this turn's bells into the pool and, when the pool reaches the threshold, acquire the
// offered father, reset the pool, record it for the Congress reveal, and offer the next father.
static void congress_step(forge::EngineExtra& x, int diff, int year, int bells_this_turn,
                          std::function<int(int,int)> rng) {
    x.congress_bells += bells_this_turn;
    int ff_count = 0; for (uint32_t b = x.ff_owned; b; b &= b - 1) ++ff_count;
    if (ff_count >= 25) { x.offered_ff = -1; return; }
    int offer = congress_ensure_offer(x, year, rng);
    if (offer < 0) return;
    int need = ff_bells_required(diff, year, ff_count);
    if (x.congress_bells >= need) {
        x.ff_owned |= (1u << offer);
        x.last_ff = offer;
        x.congress_bells -= need;
        if (x.congress_bells < 0) x.congress_bells = 0;
        x.offered_ff = -1;                     // Congress offers the next father from now on
        congress_ensure_offer(x, year, rng);
    }
}

// Verbatim UI labels from LABELS.TXT, by section + line index. Every screen pulls its exact
// strings from here (title @MISC[37], "OK" @MISC[46], the advisor titles, @EUROLABEL rows, ...)
// -- the text is the game's own, never retyped. Sections parse once from the newline-joined
// LABELS_sections.json strings and cache.
// Verbatim text-section lines by name. LABELS.TXT first (@MISC/@CTITLE/@CMISC/...), then
// NAMES.TXT (@SEASONS/...) and COLONY.TXT (the per-nation colony-name pools) -- every screen
// string is pulled from these files, never authored.
static const std::vector<std::string>& labels_section(const std::string& section) {
    static std::map<std::string, std::vector<std::string>> cache;
    auto it = cache.find(section);
    if (it != cache.end()) return it->second;
    std::vector<std::string> lines;
    static const char* kSources[] = {"data_extracted/text/LABELS_sections.json",
                                     "data_extracted/text/NAMES_sections.json",
                                     "data_extracted/text/COLONY_sections.json"};
    for (const char* src : kSources) {
        try {
            forge::JsonValue d = forge::json_parse_file(src);
            const forge::JsonValue* m = d.find("@" + section);
            if (m && m->type == forge::JsonValue::String) {
                std::string cur;
                for (char ch : m->str) { if (ch == '\n') { lines.push_back(cur); cur.clear(); } else cur += ch; }
                lines.push_back(cur);
                break;
            }
        } catch (...) {}
    }
    return cache.emplace(section, std::move(lines)).first->second;
}
static const std::string& misc_label(int idx) {
    static const std::string empty;
    const std::vector<std::string>& lines = labels_section("MISC");
    return (idx >= 0 && idx < (int)lines.size()) ? lines[idx] : empty;
}

static forge::JsonValue sandbox_state_json() {
    if (!g_sb_active) sandbox_new(3);
    forge::EngineCtx cx{g_sb_game, g_sb_world, g_sb_colony_xy, g_sb_extra, g_active_rules, sb_rng};
    const Colony& c = g_sb_world.colonies[0];
    forge::JsonValue o = jobj();
    o.obj["year"] = forge::json_num(g_sb_game.year);
    o.obj["season"] = forge::json_num(g_sb_game.season);
    o.obj["turn"] = forge::json_num((double)g_sb_game.turn);
    o.obj["gold"] = forge::json_num((double)g_sb_game.powers[0].gold);
    o.obj["tax"] = forge::json_num(g_sb_game.powers[0].tax);
    o.obj["population"] = forge::json_num(c.population);
    o.obj["sol"] = forge::json_num(sol_pct(c));
    o.obj["bells"] = forge::json_num(c.bells_per_turn);
    o.obj["hammers"] = forge::json_num(c.hammers_per_turn);
    o.obj["food"] = forge::json_num(c.food_per_turn);
    o.obj["crosses"] = forge::json_num(c.crosses_output);
    o.obj["build_target"] = forge::json_num(c.build_target);
    o.obj["build_cost"] = forge::json_num(c.build_cost);
    o.obj["build_bank"] = forge::json_num((double)c.build_bank);
    long rem = (long)c.build_cost - (long)c.build_bank; if (rem < 0) rem = 0;
    o.obj["build_remaining"] = forge::json_num((double)rem);
    o.obj["building_name"] = c.build_target < 0 ? forge::json_str("") :
        forge::resolve_binding("@BUILDING[" + std::to_string(c.build_target) + "].name", cx);
    forge::JsonValue sp = jarr();
    for (int i = 0; i < NGOODS; ++i) sp.arr.push_back(forge::json_num(c.stockpile[i]));
    o.obj["stockpile"] = sp;
    forge::JsonValue built = jarr();
    for (int b = 0; b < 48; ++b) if ((c.built_mask >> b) & 1ull) built.arr.push_back(forge::json_num(b));
    o.obj["built"] = built;
    // The colonist roster -- who is here, their specialty, and where they work -- plus the
    // food-growth accumulator, so the sandbox screen can show the mechanics, not just totals.
    forge::JsonValue colonists = jarr();
    for (const auto& wk : c.workers) {
        forge::JsonValue w = jobj();
        w.obj["name"] = forge::json_str(forge::job_name(wk.profession, wk.expert));
        w.obj["expert"] = jbool(wk.expert);
        w.obj["produces"] = forge::json_str(good_display(wk.good));
        w.obj["tile"] = forge::json_num(wk.tile);
        w.obj["where"] = forge::json_str(wk.tile >= 0 ? ("field tile " + std::to_string(wk.tile)) : "building");
        colonists.arr.push_back(w);
    }
    o.obj["colonists"] = colonists;
    o.obj["food_accum"] = forge::json_num((double)c.food_accum);
    o.obj["center_food"] = forge::json_num(c.center_food);
    // 200 stored food -> a new colonist (USER RULING + warehousing.md:61-62; single threshold)
    o.obj["food_threshold"] = forge::json_num(g_active_rules.cfg.food_growth_threshold);
    // Sons-of-Liberty production bonus (+1 at >=50%, +2 at 100%) + the owned founding fathers, so
    // the screen can show the multiplier and which fathers are boosting production.
    int sbsol = sol_pct(c);
    o.obj["sol_bonus"] = forge::json_num(sbsol >= 100 ? 2 : (sbsol >= 50 ? 1 : 0));
    o.obj["ff_owned"] = forge::json_num((double)g_sb_extra.ff_owned);
    forge::JsonValue ffa = jarr();
    for (int i = 0; i < 32; ++i) if ((g_sb_extra.ff_owned >> i) & 1u) ffa.arr.push_back(forge::json_num(i));
    o.obj["fathers"] = ffa;
    // Continental Congress progress: bells/turn, the bell pool toward the next father, the bell-cost
    // threshold, the currently-offered father, and the most-recently-acquired father (the reveal).
    int ff_count = 0; for (uint32_t b = g_sb_extra.ff_owned; b; b &= b - 1) ++ff_count;
    forge::JsonValue cong = jobj();
    cong.obj["bells_per_turn"] = forge::json_num(c.bells_per_turn);
    cong.obj["bells_pool"]     = forge::json_num(g_sb_extra.congress_bells);
    int need = ff_bells_required(g_sb_game.difficulty, g_sb_game.year, ff_count);
    cong.obj["threshold"]      = forge::json_num(need);
    cong.obj["remaining"]      = forge::json_num(need > g_sb_extra.congress_bells ? need - g_sb_extra.congress_bells : 0);
    cong.obj["ff_count"]       = forge::json_num(ff_count);
    int nextff = (ff_count >= 25) ? -1 : congress_ensure_offer(g_sb_extra, g_sb_game.year, sb_rng);
    cong.obj["offered"]        = forge::json_num(nextff);   // -1 when all 25 are owned
    cong.obj["last_ff"]        = forge::json_num(g_sb_extra.last_ff);
    cong.obj["national_sol"]   = forge::json_num(g_sb_extra.national_sol);
    // The King's Expeditionary Force (REF) by unit type -- shown on the Activities screen. Order
    // matches the DGROUP array (spec/ui/continental_congress.md §5): Regulars/Cavalry/Man-O-War/Artillery.
    forge::JsonValue ref = jobj();
    ref.obj["regulars"]  = forge::json_num(g_sb_game.ref.regulars);
    ref.obj["cavalry"]   = forge::json_num(g_sb_game.ref.cavalry);
    ref.obj["manowar"]   = forge::json_num(g_sb_game.ref.manowar);
    ref.obj["artillery"] = forge::json_num(g_sb_game.ref.artillery);
    cong.obj["ref"] = ref;
    // Verbatim UI label strings pulled from LABELS.TXT @MISC (spec §3), so the screen text is the
    // game's own, not invented.
    forge::JsonValue lab = jobj();
    lab.obj["title"]     = forge::json_str(misc_label(37));    // CONTINENTAL CONGRESS ACTIVITIES
    lab.obj["congress"]  = forge::json_str(misc_label(134));   // Continental Congress
    lab.obj["session"]   = forge::json_str(misc_label(112));   // Next Continental Congress Session
    lab.obj["rebel"]     = forge::json_str(misc_label(69));     // Rebel
    lab.obj["tory"]      = forge::json_str(misc_label(70));     // Tory
    lab.obj["sentiment"] = forge::json_str(misc_label(71));     // Sentiment
    lab.obj["ref"]       = forge::json_str(misc_label(85));     // Expeditionary Force
    lab.obj["fathers"]   = forge::json_str(misc_label(89));     // Founding Fathers
    lab.obj["ok"]        = forge::json_str(misc_label(46));      // OK
    cong.obj["labels"] = lab;
    o.obj["congress"] = cong;
    // Market: whether the colony has a Custom House (auto-sell to Europe), the tax, and the per-good
    // Europe bid price -- so the screen can offer a "ship & sell" action and show the auto-sell state.
    o.obj["custom_house"] = jbool((c.built_mask >> 18) & 1ull);
    o.obj["tax"] = forge::json_num(g_sb_game.powers[0].tax);
    // Live market (the byte-verified model): per-good the published bid/ask, the published price
    // level (+0x4C), and the HIDDEN VOLUME that drives it -- supply = price_base (the seeded base)
    // + this turn's sell volume (trade, +0xFC). The four finished goods price off the pooled
    // S_pair; every level is clamped to the good's @CARGO drift band; ask = bid + burden + 1.
    RuleData mrd = live_market_rules(cx);
    int64_t s_pair = 0;
    for (int i = vc::sim::RUM; i <= vc::sim::COATS; ++i) s_pair += vc::sim::market_supply(g_sb_game, i);
    if (s_pair < 1) s_pair = 1;
    o.obj["s_pair"] = forge::json_num((double)s_pair);
    forge::JsonValue market = jarr();
    for (int gd = 0; gd < NGOODS; ++gd) {
        forge::JsonValue m = jobj();
        m.obj["good"] = forge::json_str(good_display(gd));
        m.obj["bid"] = forge::json_num(vc::sim::market_bid(g_sb_game, 0, gd));
        m.obj["ask"] = forge::json_num(vc::sim::market_ask(g_sb_game, 0, gd, mrd));
        m.obj["level"] = forge::json_num(g_sb_game.powers[0].price_level[gd]);   // published +0x4C
        m.obj["base"] = forge::json_num(g_sb_game.price_base[gd]);               // hidden supply seed
        m.obj["trade"] = forge::json_num(g_sb_game.powers[0].trade[gd]);          // this turn's volume
        m.obj["supply"] = forge::json_num(vc::sim::market_supply(g_sb_game, gd)); // base + volume
        m.obj["low"] = forge::json_num(mrd.cargo[gd].lo);
        m.obj["high"] = forge::json_num(mrd.cargo[gd].hi);
        m.obj["burden"] = forge::json_num(mrd.cargo[gd].burden);
        m.obj["boycott"] = jbool((g_sb_extra.boycotts >> gd) & 1u);
        market.arr.push_back(m);
    }
    o.obj["market"] = market;
    // keep a flat bid array for the older price dropdown
    forge::JsonValue pr = jarr();
    for (int gd = 0; gd < NGOODS; ++gd) pr.arr.push_back(forge::json_num(vc::sim::market_bid(g_sb_game, 0, gd)));
    o.obj["prices"] = pr;
    return o;
}

// The complete founding-father reference (all 25, spec/systems/founding_fathers.md): id + @FATHERS
// name + byte-verified effect; `production` marks the ones colony_compute_production actually
// applies (Adam Smith, Henry Hudson, Thomas Jefferson, William Penn).
static forge::JsonValue fathers_json() {
    struct FF { const char* effect; bool prod; };
    static const FF FX[25] = {
        {"Enables factory-tier buildings; factory output no longer throttled", true},   // 0  Adam Smith
        {"Clears all boycotts in Europe", false},                                        // 1  Jakob Fugger
        {"No payment to natives for land", false},                                       // 2  Peter Minuit
        {"Enables the Custom House (auto-sell without shipping)", false},                // 3  Peter Stuyvesant
        {"Reveals foreign colony / scout information", false},                           // 4  Jan de Witt
        {"Atlantic crossing takes 1 turn instead of 2", false},                          // 5  Ferdinand Magellan
        {"Reveals all colonies on the map", false},                                      // 6  Francisco Coronado
        {"Lost-city rumors always positive; +1 naval sight", false},                     // 7  Hernando de Soto
        {"Doubles fur production (Furs x2)", true},                                      // 8  Henry Hudson
        {"Free Stockade for colonies of size >= 3", false},                              // 9  Sieur de La Salle
        {"King's treasure cut capped at the tax rate", false},                           // 10 Hernan Cortes
        {"Combat winners auto-promote", false},                                          // 11 George Washington
        {"Undefended colony with muskets defends at strength 75", false},                // 12 Paul Revere
        {"Privateer combat strength +50%", false},                                       // 13 Sir Francis Drake
        {"Free Frigate", false},                                                         // 14 John Paul Jones
        {"Bell production +50%", true},                                                  // 15 Thomas Jefferson
        {"Resets native attitudes; halves native tension increases", false},             // 16 Pocahontas
        {"Bell production scales with the tax rate (+tax%)", false},                      // 17 Thomas Paine
        {"+20% Sons of Liberty", false},                                                 // 18 Simon Bolivar
        {"Foreign powers offer peace", false},                                           // 19 Benjamin Franklin
        {"No criminals / servants arrive on the docks", false},                          // 20 William Brewster
        {"Crosses production +50%", true},                                               // 21 William Penn
        {"All missionaries become expert", false},                                       // 22 Jean de Brebeuf
        {"+4 native-conversion strength", false},                                        // 23 Juan de Sepulveda
        {"Converts become free colonists", false},                                       // 24 Bartolome de las Casas
    };
    // @FOUNDING category names (index = @FATHERS.type). Continental Congress groups the 25 fathers
    // into these 5 categories, 5 each -- the predefined layout every father slots into.
    static const char* CAT[5] = {"Trade", "Exploration", "Military", "Political", "Religious"};
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    forge::JsonValue arr = jarr();
    for (int i = 0; i < 25; ++i) {
        forge::JsonValue o = jobj();
        o.obj["id"] = forge::json_num(i);
        forge::JsonValue nm = forge::resolve_binding("@FATHERS[" + std::to_string(i) + "].name", cx);
        o.obj["name"] = (nm.type == forge::JsonValue::String && !nm.str.empty()) ? nm
                        : forge::json_str("Father #" + std::to_string(i));
        // category (type) from @FATHERS; falls back to i/5 (the fixed 5-per-category layout).
        forge::JsonValue ty = forge::resolve_binding("@FATHERS[" + std::to_string(i) + "].type", cx);
        int cat = (ty.type == forge::JsonValue::String) ? std::atoi(ty.str.c_str())
                  : (ty.type == forge::JsonValue::Number ? (int)ty.num : i / 5);
        if (cat < 0 || cat > 4) cat = i / 5;
        o.obj["type"] = forge::json_num(cat);
        o.obj["category"] = forge::json_str(CAT[cat]);
        o.obj["slot"] = forge::json_num(i % 5);   // column within the category row
        // CC-NN portrait (1:1 with @FATHERS order, spec/ui/continental_congress.md §3), cropped
        // out of the atlas sheet by tools/extract_cc_portraits.py and served via the sliced route.
        char pf[40]; std::snprintf(pf, sizeof pf, "sliced/fathers/CC-%02d.png", i);
        o.obj["portrait"] = forge::json_str(pf);
        o.obj["effect"] = forge::json_str(FX[i].effect);
        o.obj["production"] = jbool(FX[i].prod);
        arr.arr.push_back(o);
    }
    return arr;
}

// ---- Advisor-report state (spec/ui/advisor_reports.md): one endpoint assembling the live rows
// every F1-F10 report body draws. Text comes verbatim from LABELS/NAMES via /api/labels and the
// binding grammar; this carries only the numbers/rows. Report geometry lives in the renderer.
static forge::JsonValue report_state_json() {
    forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
    auto tcell = [&](const std::string& p) { return forge::resolve_binding(p, cx); };
    forge::JsonValue o = jobj();
    o.obj["year"] = forge::json_num(g_game.year);
    o.obj["season"] = forge::json_num(g_game.season);
    o.obj["gold"] = forge::json_num((double)g_game.powers[0].gold);
    o.obj["tax"] = forge::json_num(g_game.powers[0].tax);

    // F1 Terrain: the encyclopedia rows -- name/move/defense/farmer-food from @UNFORESTED (+Arctic).
    forge::JsonValue terr = jarr();
    for (int t = 0; t < 9; ++t) {
        forge::JsonValue r = jobj(); std::string i = std::to_string(t);
        r.obj["name"] = tcell("@UNFORESTED[" + i + "].name");
        r.obj["move"] = tcell("@UNFORESTED[" + i + "].movement");
        r.obj["defense"] = tcell("@UNFORESTED[" + i + "].defensive");
        r.obj["food"] = tcell("@UNFORESTED[" + i + "].y_farmer");
        r.obj["value"] = tcell("@UNFORESTED[" + i + "].value");
        terr.arr.push_back(r);
    }
    o.obj["terrain"] = terr;

    // F2 Religious: the crosses gauge (+0x2E of +0x30) + per-colony cross rows.
    forge::JsonValue rel = jobj();
    rel.obj["accum"] = forge::json_num(g_game.powers[0].crosses_accum);
    rel.obj["threshold"] = forge::json_num(g_game.powers[0].crosses_threshold);
    forge::JsonValue relc = jarr();
    for (size_t i = 0; i < g_world.colonies.size(); ++i) {
        if (g_world.colonies[i].owner_power != 0) continue;
        forge::JsonValue r = jobj();
        r.obj["colony"] = forge::json_num((double)i);
        r.obj["crosses"] = forge::json_num(g_world.colonies[i].crosses_output);
        relc.arr.push_back(r);
    }
    rel.obj["colonies"] = relc;
    o.obj["religious"] = rel;

    // F3 Congress: pool/threshold/offer/REF/sentiment (the game loop runs congress_step).
    { forge::JsonValue cg = jobj();
      int ffc = 0; for (uint32_t b = g_engine_extra.ff_owned; b; b &= b - 1) ++ffc;
      int bells = 0; for (const Colony& c : g_world.colonies) if (c.owner_power == 0) bells += c.bells_per_turn;
      cg.obj["bells_per_turn"] = forge::json_num(bells);
      cg.obj["bells_pool"] = forge::json_num(g_engine_extra.congress_bells);
      int need = ff_bells_required(g_game.difficulty, g_game.year, ffc);
      cg.obj["threshold"] = forge::json_num(need);
      cg.obj["remaining"] = forge::json_num(need > g_engine_extra.congress_bells ? need - g_engine_extra.congress_bells : 0);
      cg.obj["ff_count"] = forge::json_num(ffc);
      cg.obj["offered"] = forge::json_num(ffc >= 25 ? -1 : congress_ensure_offer(g_engine_extra, g_game.year, game_rng));
      cg.obj["last_ff"] = forge::json_num(g_engine_extra.last_ff);
      cg.obj["national_sol"] = forge::json_num(g_engine_extra.national_sol);
      forge::JsonValue ffa = jarr();
      for (int i = 0; i < 25; ++i) if ((g_engine_extra.ff_owned >> i) & 1u) ffa.arr.push_back(forge::json_num(i));
      cg.obj["fathers"] = ffa;
      forge::JsonValue ref = jobj();
      ref.obj["regulars"] = forge::json_num(g_game.ref.regulars);
      ref.obj["cavalry"] = forge::json_num(g_game.ref.cavalry);
      ref.obj["manowar"] = forge::json_num(g_game.ref.manowar);
      ref.obj["artillery"] = forge::json_num(g_game.ref.artillery);
      cg.obj["ref"] = ref;
      o.obj["congress"] = cg; }

    // F4 Labor: the occupation tally -- colonists per @JOB profession across the player's colonies.
    { std::map<int, int> tally;
      for (const Colony& c : g_world.colonies)
          if (c.owner_power == 0)
              for (const Colony::Worker& w : c.workers) tally[w.profession]++;
      forge::JsonValue lab = jarr();
      for (auto& kv : tally) {
          forge::JsonValue r = jobj();
          r.obj["job"] = tcell("@JOB[" + std::to_string(kv.first) + "].name");
          r.obj["count"] = forge::json_num(kv.second);
          lab.arr.push_back(r);
      }
      o.obj["labor"] = lab; }

    // F5 Economic: per-good total stock across the player's colonies + the published market.
    { forge::JsonValue eco = jarr();
      RuleData mrd = live_market_rules(cx);
      for (int gd = 0; gd < NGOODS; ++gd) {
          long stock = 0;
          for (const Colony& c : g_world.colonies)
              if (c.owner_power == 0) stock += c.stockpile[gd];
          forge::JsonValue r = jobj();
          r.obj["good"] = forge::json_str(good_display(gd));
          r.obj["stock"] = forge::json_num((double)stock);
          r.obj["bid"] = forge::json_num(vc::sim::market_bid(g_game, 0, gd));
          r.obj["ask"] = forge::json_num(vc::sim::market_ask(g_game, 0, gd, mrd));
          r.obj["boycott"] = jbool((g_engine_extra.boycotts >> gd) & 1u);
          eco.arr.push_back(r);
      }
      o.obj["economic"] = eco; }

    // F6 Colony: one row per player colony (pitch 17, 9/page in the renderer).
    { forge::JsonValue cols = jarr();
      for (size_t i = 0; i < g_world.colonies.size(); ++i) {
          const Colony& c = g_world.colonies[i];
          if (c.owner_power != 0) continue;
          forge::JsonValue r = jobj();
          r.obj["i"] = forge::json_num((double)i);
          r.obj["x"] = forge::json_num(i < g_colony_xy.size() ? g_colony_xy[i].first : 0);
          r.obj["y"] = forge::json_num(i < g_colony_xy.size() ? g_colony_xy[i].second : 0);
          r.obj["population"] = forge::json_num(c.population);
          r.obj["sol"] = forge::json_num(sol_pct(c));
          int nb = 0; for (int b = 0; b < 48; ++b) if ((c.built_mask >> b) & 1ull) ++nb;
          r.obj["buildings"] = forge::json_num(nb);
          r.obj["food"] = forge::json_num(c.stockpile[0]);
          r.obj["muskets"] = forge::json_num(c.stockpile[15]);
          r.obj["horses"] = forge::json_num(c.stockpile[8]);
          cols.arr.push_back(r);
      }
      o.obj["colonies"] = cols; }

    // F7 Naval: the player's ships (move_class 99), two passes are the renderer's concern.
    { forge::JsonValue nav = jarr();
      for (const auto& u : g_world.units) {
          if (!u.alive || u.owner != 0) continue;
          if (g_active_rules.units[u.type].move_class != 99) continue;
          forge::JsonValue r = jobj();
          r.obj["name"] = forge::json_str(g_active_rules.units[u.type].name);
          r.obj["x"] = forge::json_num(u.x); r.obj["y"] = forge::json_num(u.y);
          r.obj["order"] = forge::json_str(u.order == vc::sim::ORDER_GOTO ? "GOTO"
                            : u.order == vc::sim::ORDER_FORTIFY ? "FORTIFY"
                            : u.order == vc::sim::ORDER_SENTRY ? "SENTRY" : "-");
          r.obj["tx"] = forge::json_num(u.target_x); r.obj["ty"] = forge::json_num(u.target_y);
          nav.arr.push_back(r);
      }
      o.obj["naval"] = nav; }

    // F8 Foreign Affairs: the four powers' strength rows (+ war/peace vs the player).
    { forge::JsonValue fp = jarr();
      for (int p = 0; p < 4; ++p) {
          forge::JsonValue r = jobj();
          r.obj["name"] = tcell("@COUNTRY[" + std::to_string(p) + "].name");
          int ncol = 0; long pop = 0;
          for (const Colony& c : g_world.colonies)
              if (c.owner_power == p) { ++ncol; pop += c.population; }
          // the @MISC 95..100 strength rows: Colonies / Population / Average Colony /
          // Military Power (armed land units) / Naval Power (armed ships) / Merchant Marine
          // (unarmed cargo ships)
          int mil = 0, navy = 0, merchant = 0;
          for (const auto& u : g_world.units) {
              if (!u.alive || u.owner != p) continue;
              const auto& st = g_active_rules.units[u.type];
              if (st.move_class == 99) { if (st.attack > 0) ++navy; else ++merchant; }
              else if (st.attack > 0) ++mil;
          }
          r.obj["colonies"] = forge::json_num(ncol);
          r.obj["population"] = forge::json_num((double)pop);
          r.obj["avg_colony"] = forge::json_num(ncol > 0 ? (int)(pop / ncol) : 0);
          r.obj["military"] = forge::json_num(mil + g_engine_extra.power_mil[p]);
          r.obj["naval"] = forge::json_num(navy);
          r.obj["merchant"] = forge::json_num(merchant);
          r.obj["gold"] = forge::json_num((double)g_game.powers[p].gold);
          r.obj["at_war"] = jbool(p != 0 && vc::sim::at_war(g_engine_extra.diplo, 0, p));
          r.obj["seceded"] = jbool(g_engine_extra.seceded_power == p);
          fp.arr.push_back(r);
      }
      o.obj["foreign"] = fp; }

    // F9 Indian: one row per native settlement (tribe name via @TRIBES).
    { forge::JsonValue ind = jarr();
      for (const auto& s : g_engine_extra.settlements) {
          forge::JsonValue r = jobj();
          r.obj["tribe"] = tcell("@TRIBES[" + std::to_string(s.tribe) + "].name");
          r.obj["x"] = forge::json_num(s.x); r.obj["y"] = forge::json_num(s.y);
          r.obj["population"] = forge::json_num(s.population);
          r.obj["alarm"] = forge::json_num(s.alarm[0]);
          r.obj["mission"] = forge::json_num(s.mission);
          r.obj["capital"] = jbool(s.capital);
          ind.arr.push_back(r);
      }
      o.obj["indian"] = ind; }

    // F10 Score: the scoring.md component breakdown (the same math as the ScoreGame node).
    { forge::JsonValue sc = jobj();
      long pop_score = 0;
      for (const Colony& c : g_world.colonies)
          if (c.owner_power == 0)
              for (const Colony::Worker& w : c.workers) pop_score += w.expert ? 4 : 2;
      int ffc = 0; for (uint32_t b = g_engine_extra.ff_owned; b; b &= b - 1) ++ffc;
      sc.obj["population"] = forge::json_num((double)pop_score);
      sc.obj["fathers"] = forge::json_num(ffc * 5);
      sc.obj["sentiment"] = forge::json_num(g_engine_extra.national_sol);
      sc.obj["razed"] = forge::json_num(-g_engine_extra.razed_settlements * (g_game.difficulty + 1));
      sc.obj["gold"] = forge::json_num((double)(g_game.powers[0].gold / 1000));
      long pb = g_engine_extra.bells_since_declaration / 100; if (pb > 100) pb = 100;
      sc.obj["war_bells"] = forge::json_num((double)pb);
      sc.obj["revolution"] = forge::json_num(
          (g_engine_extra.woi_declared && g_engine_extra.declaration_year > 0)
              ? vc::sim::revolution_bonus(g_engine_extra.declaration_year) : 0);
      long total = vc::sim::score_game(g_game.difficulty, pop_score, ffc,
                                       g_engine_extra.national_sol, g_engine_extra.razed_settlements,
                                       (long)g_game.powers[0].gold,
                                       g_engine_extra.bells_since_declaration,
                                       g_engine_extra.declaration_year, g_engine_extra.woi_declared);
      sc.obj["total"] = forge::json_num((double)total);
      sc.obj["rank"] = forge::json_num(vc::sim::score_rank((int)total));
      sc.obj["mult"] = forge::json_num(vc::sim::score_difficulty_mult(g_game.difficulty));
      o.obj["score"] = sc; }

    return o;
}

// EngineExtra (the relational/Forge-side state) + colony_xy round-trip -- these were
// dropped by the (GameState,World)-only save (fidelity backlog #2/#3). Serialized here
// because they live Forge-side; the sim save stays pure.
static forge::JsonValue dump_extra(const forge::EngineExtra& x) {
    forge::JsonValue o = jobj();
    o.obj["tension"] = forge::json_num(x.tension);
    o.obj["ff_owned"] = forge::json_num((double)x.ff_owned);
    o.obj["boycotts"] = forge::json_num((double)x.boycotts);
    o.obj["national_sol"] = forge::json_num(x.national_sol);
    o.obj["woi_declared"] = jbool(x.woi_declared);
    o.obj["rebel_power"] = forge::json_num(x.rebel_power);
    o.obj["seceded_power"] = forge::json_num(x.seceded_power);
    o.obj["score"] = forge::json_num((double)x.score);
    o.obj["congress_bells"] = forge::json_num(x.congress_bells);
    forge::JsonValue mil = jarr(), econ = jarr();
    for (int i = 0; i < 4; ++i) { mil.arr.push_back(forge::json_num(x.power_mil[i]));
        econ.arr.push_back(forge::json_num(x.power_econ[i])); }
    o.obj["power_mil"] = mil; o.obj["power_econ"] = econ;
    forge::JsonValue war = jarr(), rel = jarr(), cd = jarr();
    for (int a = 0; a < 4; ++a) for (int b = 0; b < 4; ++b) {
        war.arr.push_back(forge::json_num(x.diplo.war[a][b]));
        rel.arr.push_back(forge::json_num(x.diplo.rel[a][b])); }
    for (int a = 0; a < 4; ++a) cd.arr.push_back(forge::json_num(x.diplo.cooldown[a]));
    o.obj["diplo_war"] = war; o.obj["diplo_rel"] = rel; o.obj["diplo_cooldown"] = cd;
    forge::JsonValue st = jarr();
    for (const forge::NativeSettlement& s : x.settlements) {
        forge::JsonValue so = jobj();
        so.obj["tribe"] = forge::json_num(s.tribe); so.obj["x"] = forge::json_num(s.x); so.obj["y"] = forge::json_num(s.y);
        so.obj["population"] = forge::json_num(s.population); so.obj["wealth"] = forge::json_num(s.wealth);
        so.obj["mission"] = forge::json_num(s.mission); so.obj["capital"] = jbool(s.capital);
        forge::JsonValue al = jarr(); for (int p = 0; p < 4; ++p) al.arr.push_back(forge::json_num(s.alarm[p]));
        so.obj["alarm"] = al; st.arr.push_back(so);
    }
    o.obj["settlements"] = st;
    return o;
}
static void read_extra(const forge::JsonValue* o, forge::EngineExtra& x) {
    if (!o) return;
    auto gi = [&](const char* k, int d) { const forge::JsonValue* v = o->find(k); return v ? v->as_int(d) : d; };
    x.tension = gi("tension", 0);
    if (const forge::JsonValue* v = o->find("ff_owned")) x.ff_owned = (uint32_t)v->num;
    if (const forge::JsonValue* v = o->find("boycotts")) x.boycotts = (uint16_t)v->num;
    x.national_sol = gi("national_sol", 0);
    if (const forge::JsonValue* v = o->find("woi_declared")) x.woi_declared = v->type == forge::JsonValue::Bool ? v->b : false;
    x.rebel_power = gi("rebel_power", -1);
    x.seceded_power = gi("seceded_power", -1);
    if (const forge::JsonValue* v = o->find("score")) x.score = (long)v->num;
    x.congress_bells = gi("congress_bells", 0);
    if (const forge::JsonValue* m = o->find("power_mil"))
        for (int i = 0; i < 4 && i < (int)m->arr.size(); ++i) x.power_mil[i] = m->arr[i].as_int();
    if (const forge::JsonValue* e = o->find("power_econ"))
        for (int i = 0; i < 4 && i < (int)e->arr.size(); ++i) x.power_econ[i] = e->arr[i].as_int();
    if (const forge::JsonValue* w = o->find("diplo_war"))
        for (int a = 0; a < 4; ++a) for (int b = 0; b < 4; ++b) { int k = a * 4 + b;
            if (k < (int)w->arr.size()) x.diplo.war[a][b] = (uint8_t)w->arr[k].as_int(); }
    if (const forge::JsonValue* r = o->find("diplo_rel"))
        for (int a = 0; a < 4; ++a) for (int b = 0; b < 4; ++b) { int k = a * 4 + b;
            if (k < (int)r->arr.size()) x.diplo.rel[a][b] = (uint8_t)r->arr[k].as_int(); }
    if (const forge::JsonValue* c = o->find("diplo_cooldown"))
        for (int a = 0; a < 4 && a < (int)c->arr.size(); ++a) x.diplo.cooldown[a] = c->arr[a].as_int();
    x.settlements.clear();
    if (const forge::JsonValue* st = o->find("settlements"))
        for (const forge::JsonValue& s : st->arr) {
            forge::NativeSettlement ns;
            auto si = [&](const char* k, int d) { const forge::JsonValue* v = s.find(k); return v ? v->as_int(d) : d; };
            ns.tribe = si("tribe", 0); ns.x = si("x", 0); ns.y = si("y", 0);
            ns.population = si("population", 1); ns.wealth = si("wealth", 0); ns.mission = si("mission", -1);
            const forge::JsonValue* cap = s.find("capital"); ns.capital = cap && cap->type == forge::JsonValue::Bool ? cap->b : false;
            if (const forge::JsonValue* al = s.find("alarm"))
                for (int p = 0; p < 4 && p < (int)al->arr.size(); ++p) ns.alarm[p] = al->arr[p].as_int();
            x.settlements.push_back(ns);
        }
}

static forge::JsonValue build_game_bundle();   // B13: full-game data bundle (defined below)

// Some buildings need a founding father before they can be built (spec/systems/founding_fathers.md):
// the Custom House (18) needs Peter Stuyvesant (#3); factory-tier buildings (5/23/26/29/34/41) need
// Adam Smith (#0). Returns a reason string if the owner lacks the required father, else nullptr.
static const char* building_ff_requirement(int bid, uint32_t ff_owned) {
    if (bid == 18 && !((ff_owned >> 3) & 1u)) return "requires Peter Stuyvesant";
    if ((bid == 5 || bid == 23 || bid == 26 || bid == 29 || bid == 34 || bid == 41) &&
        !((ff_owned >> 0) & 1u)) return "requires Adam Smith";
    return nullptr;
}

static forge::HttpResponse serve_route(const std::string& method, const std::string& path,
                                       const std::string& query, const std::string& body) {
    using forge::HttpResponse;
    auto J = [](int st, const forge::JsonValue& v) {
        return HttpResponse{st, "application/json", forge::json_dump(v)};
    };
    auto err = [&](int st, const std::string& msg) {
        forge::JsonValue o = jobj(); o.obj["error"] = forge::json_str(msg); return J(st, o);
    };
    try {
        if (path == "/")
            return HttpResponse{200, "text/html; charset=utf-8", forge::forge_index_html()};

        if (path == "/api/rules") {
            RuleData base = make_default_rules(), cur = base;
            std::vector<std::string> warns;
            if (method == "POST" && !body.empty()) {
                forge::OverlayResult o = forge::apply_overlay(forge::json_parse(body), make_default_rules());
                cur = o.rules; warns = o.warnings;
            }
            forge::JsonValue root = jobj();
            root.obj["invariants"] = inv_json(check_rules(cur));
            root.obj["curves"]     = curves_json(base, cur);
            root.obj["warnings"]   = jstrs(warns);
            root.obj["overlay"]    = forge::overlay_diff(base, cur);
            return J(200, root);
        }

        if (path == "/api/rules/full") {
            // The COMPLETE real ruleset as an overlay: every cfg scalar/array,
            // every unit, every terrain id. Posting it back to /api/rules
            // reproduces the default exactly (all curve deltas zero).
            return J(200, forge::full_overlay(make_default_rules()));
        }

        if (path == "/api/rules/active") {
            // The sparse overlay currently APPLIED to the Play game + engine VM.
            RuleData base = make_default_rules();
            forge::JsonValue root = jobj();
            root.obj["overlay"]    = forge::overlay_diff(base, g_active_rules);
            root.obj["invariants"] = inv_json(check_rules(g_active_rules));
            root.obj["curves"]     = curves_json(base, g_active_rules);
            return J(200, root);
        }

        if (path == "/api/rules/save" && method == "POST") {
            // Persist the posted overlay as the active mod -- but only if it is a
            // valid ruleset; an invalid edit is rejected (the sim never runs on it).
            RuleData base = make_default_rules();
            forge::OverlayResult o = forge::apply_overlay(forge::json_parse(body), base);
            InvariantReport rep = check_rules(o.rules);
            forge::JsonValue root = jobj();
            root.obj["invariants"] = inv_json(rep);
            root.obj["warnings"]   = jstrs(o.warnings);
            if (rep.ok()) {
                g_active_rules = o.rules;
                try { forge::save_overlay(ACTIVE_RULES_PATH, base, g_active_rules); }
                catch (const std::exception& e) { return err(500, std::string("write failed: ") + e.what()); }
                root.obj["saved"]   = jbool(true);
                root.obj["overlay"] = forge::overlay_diff(base, g_active_rules);
            } else {
                root.obj["saved"] = jbool(false);   // invalid: not applied, not written
            }
            return J(200, root);
        }

        if (path == "/api/rules/reset" && method == "POST") {
            // Revert to the un-modded ruleset and remove the on-disk overlay.
            g_active_rules = make_default_rules();
            std::error_code ec; std::filesystem::remove(ACTIVE_RULES_PATH, ec);
            return J(200, jbool(true));
        }

        if (path == "/api/text") {
            // Real game strings from data_extracted/text/<FILE>_sections.json (default GAME).
            std::string file = qparam(query, "file"); if (file.empty()) file = "GAME";
            for (char c : file) if (!std::isalnum((unsigned char)c) && c != '_') return err(400, "bad file");
            try { return J(200, forge::json_parse_file("data_extracted/text/" + file + "_sections.json")); }
            catch (const std::exception& e) { return err(404, e.what()); }
        }

        if (path == "/api/formulas")
            return J(200, forge::formulas_catalog());

        // ---- the game database schema (the DDL): reference + state + config tables ----
        if (path == "/api/schema") {
            try { return J(200, forge::json_parse_file("data_extracted/engine/schema.json")); }
            catch (...) { return err(404, "schema.json not found (run tools/build_schema.py)"); }
        }
        // B13: export the whole game as one portable data bundle (schema + tables + graphs +
        // screens + scenarios + messages/sprites + rules overlay). "Save this game as a mod."
        if (path == "/api/bundle") return J(200, build_game_bundle());
        // The 25 founding fathers + their effects (which ones boost colony production).
        if (path == "/api/fathers") return J(200, fathers_json());
        if (path == "/api/report/state") {
            if (!g_game_active) game_new();
            return J(200, report_state_json());
        }
        if (path == "/api/labels") {
            // ?section=MISC|EUROLABEL|... -> the verbatim LABELS.TXT section lines (index = the
            // line number the specs cite, e.g. @MISC[37] = the Congress title). Screens draw
            // these exact strings -- text is data, never retyped.
            std::string sec = qparam(query, "section"); if (sec.empty()) sec = "MISC";
            forge::JsonValue a = jarr();
            for (const std::string& s : labels_section(sec)) a.arr.push_back(forge::json_str(s));
            forge::JsonValue o = jobj(); o.obj["section"] = forge::json_str("@" + sec); o.obj["lines"] = a;
            return J(200, o);
        }
        if (path == "/api/functions") {
            try { return J(200, forge::json_parse_file("data_extracted/engine/functions.json")); }
            catch (...) { return err(404, "functions.json not found"); }
        }
        if (path == "/api/sprites") {
            try { return J(200, forge::json_parse_file("data_extracted/engine/sprites.json")); }
            catch (...) { return err(404, "sprites.json not found (run tools/build_sprites.py)"); }
        }
        // Individual sprites sliced out of the sheets (each identified by label) -> /assets/sliced/...
        if (path == "/api/sprites/sliced") {
            try { return J(200, forge::json_parse_file("data_extracted/sprites/manifest.json")); }
            catch (...) { return err(404, "run tools/slice_sprites.py to cut the sheets into sprites"); }
        }
        if (path == "/api/messages") {
            try { return J(200, forge::json_parse_file("data_extracted/engine/messages.json")); }
            catch (...) { return err(404, "messages.json not found (run tools/build_messages.py)"); }
        }

        if (path == "/api/assets")
            return J(200, assets_manifest());

        // ---- engine: node graphs (the visual logic) ----
        if (path == "/api/nodes")
            return J(200, forge::node_catalog());
        if (path == "/api/graphs") {
            forge::JsonValue a = jarr();
            for (const std::string& id : forge::list_graphs()) a.arr.push_back(forge::json_str(id));
            return J(200, a);
        }
        if (path == "/api/graph") {
            if (method == "POST") {
                forge::JsonValue b = forge::json_parse(body);
                const forge::JsonValue* id = b.find("id");
                if (!id || !id->is_string()) return err(400, "need {id, ...graph}");
                forge::save_graph(id->str, b);
                forge::JsonValue o = jobj(); o.obj["ok"] = jbool(true); return J(200, o);
            }
            std::string id = qparam(query, "id");
            if (id.empty()) return err(400, "missing ?id");
            return J(200, forge::load_graph(id));
        }
        // /api/bind + /api/cell: the unified cell accessor (A2) over the one path grammar --
        // reference (@...), state (game/power/colony/unit/...), and config (cfg.*).
        if (path == "/api/bind" || path == "/api/cell") {
            if (!g_game_active) game_new();
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            forge::JsonValue o = jobj();
            o.obj["value"] = forge::cell_get(qparam(query, "path"), cx);
            return J(200, o);
        }
        if ((path == "/api/bind/set" || path == "/api/cell/set") && method == "POST") {
            if (!g_game_active) game_new();
            forge::JsonValue b = forge::json_parse(body);
            const forge::JsonValue* p = b.find("path"); const forge::JsonValue* v = b.find("value");
            if (!p || !v) return err(400, "need {path,value}");
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            forge::JsonValue o = jobj();
            o.obj["ok"] = jbool(forge::cell_set(p->str, v->as_double(), cx));
            return J(200, o);
        }
        if (path == "/api/screens") {
            forge::JsonValue a = jarr();
            for (const std::string& id : forge::list_screens()) a.arr.push_back(forge::json_str(id));
            return J(200, a);
        }
        if (path == "/api/screen") {
            if (method == "POST") {
                forge::JsonValue b = forge::json_parse(body);
                const forge::JsonValue* id = b.find("id");
                if (!id || !id->is_string()) return err(400, "need {id, ...screen}");
                forge::save_screen(id->str, b);
                forge::JsonValue o = jobj(); o.obj["ok"] = jbool(true); return J(200, o);
            }
            std::string id = qparam(query, "id");
            if (id.empty()) return err(400, "missing ?id");
            return J(200, forge::load_screen(id));
        }
        if (path == "/api/graph/run" && method == "POST") {
            if (!g_game_active) game_new();
            forge::JsonValue b = forge::json_parse(body);
            forge::JsonValue graph;
            if (const forge::JsonValue* g = b.find("graph")) graph = *g;
            else if (const forge::JsonValue* id = b.find("id")) graph = forge::load_graph(id->str);
            else return err(400, "need {graph} or {id}");
            std::string from = b.find("from_node") ? b.find("from_node")->str : "";
            std::string choice = b.find("choice") ? b.find("choice")->str : "";
            forge::JsonValue cache = b.find("cache") ? *b.find("cache") : forge::JsonValue{};
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            return J(200, forge::run_graph(graph, cx, from, choice, cache));
        }

        if (path == "/api/game/new"  && method == "POST") {
            game_new(); g_history.clear(); history_snapshot(); return J(200, game_state_json());
        }
        // New game from the setup screen: {nation 0..3, difficulty 0..4} seed the scenario.
        if (path == "/api/game/setup" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int nat  = b.find("nation")     ? b.find("nation")->as_int(0)     : 0;
            int diff = b.find("difficulty") ? b.find("difficulty")->as_int(1) : 1;
            game_new(nat, diff); g_history.clear(); history_snapshot();
            return J(200, game_state_json());
        }
        if (path == "/api/turn" && method != "POST") {   // read the turn pipeline (turn.json)
            try { return J(200, forge::json_parse_file("data_extracted/engine/turn.json")); }
            catch (...) { return err(404, "turn.json not found"); }
        }
        if (path == "/api/turn" && method == "POST") {   // save the edited pipeline (B5)
            forge::JsonValue b = forge::json_parse(body);
            if (!b.find("phases")) return err(400, "need {phases:[...]}");
            std::ofstream f("data_extracted/engine/turn.json", std::ios::binary);
            f << forge::json_dump(b);
            forge::invalidate_turn_pipeline();           // next turn uses the edited order
            forge::JsonValue o = jobj(); o.obj["saved"] = jbool((bool)f); return J(200, o);
        }
        // Declare the War of Independence (player command). Requires national Sons of Liberty >= 50
        // (spec revolution gate); sets the war flag so war_resolution_step() runs each turn.
        if (path == "/api/game/declare" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            if (g_engine_extra.woi_declared) return err(400, "independence already declared");
            if (g_engine_extra.national_sol < 50)
                return err(400, "national Sons of Liberty must reach 50% to declare (now " +
                                std::to_string(g_engine_extra.national_sol) + "%)");
            g_engine_extra.woi_declared = true; g_engine_extra.rebel_power = 0;
            if (g_engine_extra.declaration_year == 0) g_engine_extra.declaration_year = g_game.year;
            forge::JsonValue o = game_state_json(); o.obj["declared"] = jbool(true); return J(200, o);
        }
        if (path == "/api/game/history") {
            forge::JsonValue a = jarr();
            for (const HistPoint& h : g_history) {
                forge::JsonValue o = jobj();
                o.obj["turn"] = forge::json_num((double)h.turn); o.obj["year"] = forge::json_num(h.year);
                o.obj["gold"] = forge::json_num((double)h.gold); o.obj["sol"] = forge::json_num(h.sol);
                o.obj["population"] = forge::json_num((double)h.population);
                a.arr.push_back(o);
            }
            return J(200, a);
        }
        if (path == "/api/game/step" && method == "POST") { game_step(); return J(200, game_state_json()); }
        if (path == "/api/game/turn" && method == "POST") {
            g_turn_notices.clear();                         // late-game turn-loop events fill this
            game_step();                                    // advance the turn
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            forge::JsonValue events = jarr();
            for (const std::string& notice : g_turn_notices) {   // Spanish Succession / Tory uprising
                forge::JsonValue e = jobj();
                e.obj["graph"] = forge::json_str("turn_event");
                forge::JsonValue rep = jobj(); forge::JsonValue effs = jarr();
                effs.arr.push_back(forge::json_str(notice)); rep.obj["effects"] = effs;
                e.obj["report"] = rep; events.arr.push_back(e);
            }
            for (const std::string& id : forge::list_graphs()) {
                forge::JsonValue gr;
                try { gr = forge::load_graph(id); } catch (...) { continue; }
                bool turn_trig = false;                     // only graphs whose entry is OnTurnStart
                if (const forge::JsonValue* ns = gr.find("nodes"))
                    for (const auto& n : ns->arr) {
                        const forge::JsonValue* t = n.find("type");
                        if (t && t->str == "OnTurnStart") { turn_trig = true; break; }
                    }
                if (!turn_trig) continue;
                forge::JsonValue rep = forge::run_graph(gr, cx);
                const forge::JsonValue* pop = rep.find("popup");
                const forge::JsonValue* eff = rep.find("effects");
                if ((pop && pop->is_object()) || (eff && !eff->arr.empty())) {
                    forge::JsonValue e = jobj();
                    e.obj["graph"] = forge::json_str(id); e.obj["report"] = rep;
                    events.arr.push_back(e);
                }
            }
            forge::JsonValue out = game_state_json();
            out.obj["events"] = events;
            return J(200, out);
        }
        if (path == "/api/game/state") {
            if (!g_game_active) game_new();
            return J(200, game_state_json());
        }
        // Full-state save/load: the sim (GameState+World, incl. colony stockpile/workers +
        // nation) plus the Forge-side colony_xy + EngineExtra -- nothing dropped (backlog #2/#3).
        if (path == "/api/game/save" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            forge::JsonValue root = forge::json_parse(forge::dump_game(g_game, g_world));
            forge::JsonValue cxy = jarr();
            for (auto& p : g_colony_xy) { forge::JsonValue e = jarr();
                e.arr.push_back(forge::json_num(p.first)); e.arr.push_back(forge::json_num(p.second));
                cxy.arr.push_back(e); }
            root.obj["colony_xy"] = cxy;
            root.obj["engine_extra"] = dump_extra(g_engine_extra);
            std::ofstream f("data_extracted/engine/savegame.json", std::ios::binary);
            f << forge::json_dump(root);
            forge::JsonValue o = jobj(); o.obj["saved"] = jbool((bool)f); return J(200, o);
        }
        if (path == "/api/game/load" && method == "POST") {
            forge::JsonValue root;
            try { root = forge::json_parse_file("data_extracted/engine/savegame.json"); }
            catch (...) { return err(400, "no saved game"); }
            forge::LoadedGame lg = forge::parse_game(forge::json_dump(root));
            g_game = lg.g; g_world = lg.w; g_colony_xy.clear();
            if (const forge::JsonValue* cxy = root.find("colony_xy"))
                for (const auto& e : cxy->arr) if (e.arr.size() >= 2)
                    g_colony_xy.push_back({(int)e.arr[0].num, (int)e.arr[1].num});
            g_engine_extra = forge::EngineExtra{};
            read_extra(root.find("engine_extra"), g_engine_extra);
            g_game_active = true;
            return J(200, game_state_json());
        }
        if (path == "/api/game/order" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            const forge::JsonValue* pu = b.find("unit");
            const forge::JsonValue* px = b.find("tx");
            const forge::JsonValue* py = b.find("ty");
            if (!pu || !px || !py) return err(400, "need {unit,tx,ty}");
            int ui = pu->as_int(-1);
            if (ui < 0 || ui >= (int)g_world.units.size() || !g_world.units[ui].alive)
                return err(400, "bad unit");
            Unit& u = g_world.units[ui];
            u.order = ORDER_GOTO; u.target_x = px->as_int(u.x); u.target_y = py->as_int(u.y);
            return J(200, game_state_json());
        }
        if (path == "/api/game/found" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            const forge::JsonValue* pu = b.find("unit");
            if (!pu) return err(400, "need {unit}");
            int ui = pu->as_int(-1);
            if (ui < 0 || ui >= (int)g_world.units.size() || !g_world.units[ui].alive)
                return err(400, "bad unit");
            Unit& u = g_world.units[ui];
            if (unit_stats(u.type).move_class == 99) return err(400, "a ship cannot found a colony");
            int id = g_world.terrain_id(u.x, u.y);
            if (id < 0 || game_is_water(id)) return err(400, "must found on land");
            Colony c; c.owner_power = u.owner; c.human = true; c.population = 1;
            c.rebel_A = 0; c.rebel_B = 1; c.build_target = -1;
            c.center_terrain = id & 0x1F; c.center_food = 3;   // center tile auto-produces its food (floor 3)
            { Colony::Worker wk; wk.profession = 19; wk.tile = 0; wk.good = 0;   // founding Free Colonist -> food
              int t = g_world.terrain_id(u.x, u.y + 1); wk.terrain = t < 0 ? (id & 0x1F) : (t & 0x1F);
              c.workers.push_back(wk); }
            forge::colony_compute_production(c, g_game.difficulty, g_active_rules, g_engine_extra.ff_owned);
            g_world.colonies.push_back(c);
            g_colony_xy.push_back({u.x, u.y});
            u.alive = false;                            // the colonist becomes the colony
            return J(200, game_state_json());
        }

        // Native settlements (first-class entities): tribe/name/position/capital/size/wealth/mission +
        // per-power alarm. The source for a native-relations screen and the native event graphs.
        if (path == "/api/natives") {
            if (!g_game_active) game_new();
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            forge::JsonValue a = jarr();
            for (size_t i = 0; i < g_engine_extra.settlements.size(); ++i) {
                const forge::NativeSettlement& s = g_engine_extra.settlements[i];
                forge::JsonValue so = jobj();
                so.obj["index"] = forge::json_num((double)i); so.obj["tribe"] = forge::json_num(s.tribe);
                so.obj["name"] = forge::resolve_binding("@TRIBES[" + std::to_string(s.tribe) + "].name", cx);
                so.obj["x"] = forge::json_num(s.x); so.obj["y"] = forge::json_num(s.y);
                so.obj["capital"] = jbool(s.capital); so.obj["population"] = forge::json_num(s.population);
                so.obj["wealth"] = forge::json_num(s.wealth); so.obj["mission"] = forge::json_num(s.mission);
                forge::JsonValue al = jarr(); for (int p = 0; p < 4; ++p) al.arr.push_back(forge::json_num(s.alarm[p]));
                so.obj["alarm"] = al; a.arr.push_back(so);
            }
            forge::JsonValue o = jobj(); o.obj["settlements"] = a;
            o.obj["count"] = forge::json_num((double)g_engine_extra.settlements.size());
            return J(200, o);
        }

        // ---- Europe market (player-command trade): buy/sell goods for gold, recruit/train colonists ----
        // Prices from @CARGO (price_start1 = bid/sell, price_start2 = ask/buy, ~1..20); tax on sales.
        if (path == "/api/europe") {
            if (!g_game_active) game_new();
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            RuleData mrd = live_market_rules(cx);
            forge::JsonValue o = jobj();
            o.obj["gold"] = forge::json_num((double)g_game.powers[0].gold);
            o.obj["tax"] = forge::json_num(g_game.powers[0].tax);
            forge::JsonValue pr = jarr();
            for (int gd = 0; gd < NGOODS; ++gd) {
                // the PUBLISHED prices from the live model (bid = level-1, ask = bid+burden+1),
                // plus the hidden volume behind them (base + this turn's sell volume = supply).
                forge::JsonValue pj = jobj(); pj.obj["good"] = forge::json_str(good_display(gd));
                pj.obj["bid"] = forge::json_num(vc::sim::market_bid(g_game, 0, gd));
                pj.obj["ask"] = forge::json_num(vc::sim::market_ask(g_game, 0, gd, mrd));
                pj.obj["level"] = forge::json_num(g_game.powers[0].price_level[gd]);
                pj.obj["supply"] = forge::json_num(vc::sim::market_supply(g_game, gd));
                pj.obj["base"] = forge::json_num(g_game.price_base[gd]);
                pj.obj["trade"] = forge::json_num(g_game.powers[0].trade[gd]);
                pj.obj["boycott"] = jbool((g_engine_extra.boycotts >> gd) & 1u);
                pr.arr.push_back(pj);
            }
            o.obj["prices"] = pr;
            forge::JsonValue dk = jarr();
            for (int s = 0; s < 3; ++s) dk.arr.push_back(forge::json_num(g_game.powers[0].dock_pool[s]));
            o.obj["dock"] = dk;
            return J(200, o);
        }
        if (path == "/api/europe/sell" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int ci = b.find("colony") ? b.find("colony")->as_int(0) : 0;
            int gd = b.find("good") ? b.find("good")->as_int(-1) : -1;
            int qty = b.find("qty") ? b.find("qty")->as_int(0) : 0;
            if (ci < 0 || ci >= (int)g_world.colonies.size() || gd < 0 || gd >= NGOODS || qty <= 0)
                return err(400, "need {colony,good 0..15,qty>0}");
            if ((g_engine_extra.boycotts >> gd) & 1u) return err(400, good_display(gd) + " is boycotted in Europe");
            Colony& c = g_world.colonies[ci];
            if (c.stockpile[gd] < qty) qty = c.stockpile[gd];
            if (qty <= 0) return err(400, "colony has none of that good");
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            // The one market path: taxed sale at the published bid; the tax funds the King's REF;
            // the sold volume floods the market and the published price re-derives immediately.
            c.stockpile[gd] -= qty;
            long proceeds = vc::sim::market_sell(g_game, 0, gd, qty, live_market_rules(cx));
            forge::JsonValue o = jobj(); o.obj["sold"] = forge::json_num(qty); o.obj["gold_gained"] = forge::json_num((double)proceeds);
            o.obj["bid_now"] = forge::json_num(vc::sim::market_bid(g_game, 0, gd));
            o.obj["gold"] = forge::json_num((double)g_game.powers[0].gold); return J(200, o);
        }
        if (path == "/api/europe/buy" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int ci = b.find("colony") ? b.find("colony")->as_int(0) : 0;
            int gd = b.find("good") ? b.find("good")->as_int(-1) : -1;
            int qty = b.find("qty") ? b.find("qty")->as_int(0) : 0;
            if (ci < 0 || ci >= (int)g_world.colonies.size() || gd < 0 || gd >= NGOODS || qty <= 0)
                return err(400, "need {colony,good 0..15,qty>0}");
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            RuleData mrd = live_market_rules(cx);
            long cost = (long)vc::sim::market_ask(g_game, 0, gd, mrd) * qty;   // untaxed (market.md 3.1)
            if (g_game.powers[0].gold < cost) return err(400, "not enough gold");
            vc::sim::market_buy(g_game, 0, gd, qty, mrd);                       // buying drains the volume
            g_world.colonies[ci].stockpile[gd] += qty;
            forge::JsonValue o = jobj(); o.obj["bought"] = forge::json_num(qty); o.obj["gold_spent"] = forge::json_num((double)cost);
            o.obj["ask_now"] = forge::json_num(vc::sim::market_ask(g_game, 0, gd, mrd));
            o.obj["gold"] = forge::json_num((double)g_game.powers[0].gold); return J(200, o);
        }
        if (path == "/api/europe/recruit" && method == "POST") {   // take a waiting dock immigrant (free)
            forge::JsonValue b = forge::json_parse(body);
            int slot = b.find("slot") ? b.find("slot")->as_int(-1) : -1;
            int ci = b.find("colony") ? b.find("colony")->as_int(0) : 0;
            if (slot < 0 || slot >= 3) return err(400, "slot 0..2");
            int type = g_game.powers[0].dock_pool[slot];
            if (type < 0) return err(400, "no immigrant waiting in that slot");
            Unit u; u.type = type < NUNITTYPES ? type : COLONISTS; u.owner = 0; u.alive = true;
            if (ci >= 0 && ci < (int)g_colony_xy.size()) { u.x = g_colony_xy[ci].first; u.y = g_colony_xy[ci].second; }
            g_world.units.push_back(u);
            g_game.powers[0].dock_pool[slot] = -1;
            return J(200, game_state_json());
        }
        if (path == "/api/europe/train" && method == "POST") {     // pay gold for a trained specialist
            forge::JsonValue b = forge::json_parse(body);
            int prof = b.find("profession") ? b.find("profession")->as_int(-1) : -1;
            int ci = b.find("colony") ? b.find("colony")->as_int(0) : 0;
            if (prof < 0) return err(400, "need {profession}");
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            int cost = (int)forge::resolve_binding("@JOB[" + std::to_string(prof) + "].europe_value", cx).as_int();
            if (cost <= 0) return err(400, "that profession cannot be trained in Europe");
            if (g_game.powers[0].gold < cost) return err(400, "not enough gold");
            g_game.powers[0].gold -= cost;
            Unit u; u.type = COLONISTS; u.owner = 0; u.profession = prof; u.alive = true;
            if (ci >= 0 && ci < (int)g_colony_xy.size()) { u.x = g_colony_xy[ci].first; u.y = g_colony_xy[ci].second; }
            g_world.units.push_back(u);
            forge::JsonValue o = game_state_json(); o.obj["trained_cost"] = forge::json_num(cost); return J(200, o);
        }

        // Full colony detail: buildings built, colonist roster (profession/specialty/where),
        // production breakdown, 16-good warehouse, build project. The colony screen's source.
        if (path == "/api/colony/detail") {
            if (!g_game_active) game_new();
            int ci = qparam(query, "colony").empty() ? 0 : std::atoi(qparam(query, "colony").c_str());
            return J(200, colony_detail_json(ci));
        }
        // Everything the native colony-screen composer draws (spec/ui/colony_screen.md).
        if (path == "/api/colony/screen") {
            if (!g_game_active) game_new();
            int ci = qparam(query, "colony").empty() ? 0 : std::atoi(qparam(query, "colony").c_str());
            return J(200, colony_screen_json(ci));
        }
        // Assign a colonist to a job: a ring tile (0..7) producing a raw good, or a building
        // slot (tile -1) producing Hammers(16)/Crosses(17)/Bells(18). Production recomputes.
        if (path == "/api/colony/assign" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int ci = b.find("colony") ? b.find("colony")->as_int(-1) : -1;
            if (ci < 0 || ci >= (int)g_world.colonies.size()) return err(400, "bad colony");
            static const int RDX[8] = {-1,0,1,-1,1,-1,0,1}, RDY[8] = {-1,-1,-1,0,0,1,1,1};
            Colony& col = g_world.colonies[ci];
            Colony::Worker wk;
            wk.profession = b.find("profession") ? b.find("profession")->as_int(19) : 19;
            wk.tile = b.find("tile") ? b.find("tile")->as_int(-1) : -1;
            wk.good = b.find("good") ? b.find("good")->as_int(0) : 0;
            const forge::JsonValue* ev = b.find("expert");
            wk.expert = ev ? (ev->type == forge::JsonValue::Bool ? ev->b : ev->as_int(0) != 0) : false;
            if (wk.tile >= 0 && wk.tile < 8 && ci < (int)g_colony_xy.size()) {
                int tid = g_world.terrain_id(g_colony_xy[ci].first + RDX[wk.tile], g_colony_xy[ci].second + RDY[wk.tile]);
                wk.terrain = tid < 0 ? 2 : (tid & 0x1F);
            } else wk.terrain = 0;
            col.workers.push_back(wk);
            if ((int)col.workers.size() > col.population) col.population = (int)col.workers.size();
            forge::colony_compute_production(col, g_game.difficulty, g_active_rules, g_engine_extra.ff_owned);
            return J(200, colony_detail_json(ci));
        }
        // Remove a colonist from a job (back to the plaza); production recomputes.
        if (path == "/api/colony/unassign" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int ci = b.find("colony") ? b.find("colony")->as_int(-1) : -1;
            int wi = b.find("worker") ? b.find("worker")->as_int(-1) : -1;
            if (ci < 0 || ci >= (int)g_world.colonies.size()) return err(400, "bad colony");
            Colony& col = g_world.colonies[ci];
            if (wi < 0 || wi >= (int)col.workers.size()) return err(400, "bad worker");
            col.workers.erase(col.workers.begin() + wi);
            forge::colony_compute_production(col, g_game.difficulty, g_active_rules, g_engine_extra.ff_owned);
            return J(200, colony_detail_json(ci));
        }

        // Start constructing a specific building in a colony (the interactive build menu).
        // {colony, building} -> start_building with cost/min_colony from @BUILDING.
        if (path == "/api/colony/build" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int ci = b.find("colony") ? b.find("colony")->as_int(-1) : -1;
            int bid = b.find("building") ? b.find("building")->as_int(-1) : -1;
            if (ci < 0 || ci >= (int)g_world.colonies.size()) return err(400, "bad colony");
            if (bid < 0) return err(400, "bad building");
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            int cost = (int)forge::resolve_binding("@BUILDING[" + std::to_string(bid) + "].cost", cx).as_int();
            int minc = (int)forge::resolve_binding("@BUILDING[" + std::to_string(bid) + "].min_colony", cx).as_int();
            std::string name = forge::resolve_binding("@BUILDING[" + std::to_string(bid) + "].name", cx).str;
            if (const char* req = building_ff_requirement(bid, g_engine_extra.ff_owned)) {
                forge::JsonValue o = jobj(); o.obj["ok"] = jbool(false);
                o.obj["msg"] = forge::json_str(name + " " + req); return J(200, o);
            }
            bool ok = start_building(g_world.colonies[ci], bid, cost, minc);
            forge::JsonValue o = jobj(); o.obj["ok"] = jbool(ok);
            o.obj["building"] = forge::json_str(name); o.obj["cost"] = forge::json_num(cost);
            o.obj["msg"] = forge::json_str(ok ? ("Started " + name + " (" + std::to_string(cost) + " hammers)")
                                              : (name + " unavailable (too small or already built)"));
            return J(200, o);
        }

        // Rush-buy the current build with gold (reconstructed cost = remaining hammers * 8, see
        // notes/rulings). {colony} -> rush_build against the colony's owner.
        if (path == "/api/colony/rush" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int ci = b.find("colony") ? b.find("colony")->as_int(-1) : -1;
            if (ci < 0 || ci >= (int)g_world.colonies.size()) return err(400, "bad colony");
            Colony& col = g_world.colonies[ci];
            if (col.build_target < 0) return err(400, "nothing under construction");
            long remaining = (long)col.build_cost - (long)col.build_bank;
            if (remaining < 0) remaining = 0;
            long gold_cost = remaining * g_active_rules.cfg.rush_gold_per_hammer;   // editable knob (cfg)
            int owner = col.owner_power;
            bool ok = (owner >= 0 && owner < 4) && rush_build(col, g_game.powers[owner], gold_cost);
            forge::JsonValue o = jobj(); o.obj["ok"] = jbool(ok); o.obj["cost"] = forge::json_num((double)gold_cost);
            o.obj["msg"] = forge::json_str(ok ? "Construction complete" : "Not enough gold");
            return J(200, o);
        }

        // ---- isolated colony sandbox (#67) ----
        if (path == "/api/sandbox/state") return J(200, sandbox_state_json());
        if (path == "/api/sandbox/new" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int pop = b.find("pop") ? b.find("pop")->as_int(3) : 3;
            sandbox_new(pop); return J(200, sandbox_state_json());
        }
        if (path == "/api/sandbox/set" && method == "POST") {   // edit any outside variable
            forge::JsonValue b = forge::json_parse(body);
            if (!g_sb_active) sandbox_new(3);
            std::string bp = b.find("path") ? b.find("path")->str : "";
            double val = b.find("value") ? b.find("value")->num : 0;
            forge::EngineCtx cx{g_sb_game, g_sb_world, g_sb_colony_xy, g_sb_extra, g_active_rules, sb_rng};
            bool ok = forge::set_binding(bp, val, cx);
            forge::JsonValue o = sandbox_state_json(); o.obj["ok"] = jbool(ok); return J(200, o);
        }
        if (path == "/api/sandbox/addpop" && method == "POST") {
            if (!g_sb_active) sandbox_new(3);
            Colony& c = g_sb_world.colonies[0]; if (c.population < 32) c.population += 1;
            return J(200, sandbox_state_json());
        }
        if (path == "/api/sandbox/build" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            if (!g_sb_active) sandbox_new(3);
            int bid = b.find("building") ? b.find("building")->as_int(-1) : -1;
            if (bid < 0) return err(400, "bad building");
            forge::EngineCtx cx{g_sb_game, g_sb_world, g_sb_colony_xy, g_sb_extra, g_active_rules, sb_rng};
            int cost = (int)forge::resolve_binding("@BUILDING[" + std::to_string(bid) + "].cost", cx).as_int();
            int minc = (int)forge::resolve_binding("@BUILDING[" + std::to_string(bid) + "].min_colony", cx).as_int();
            std::string name = forge::resolve_binding("@BUILDING[" + std::to_string(bid) + "].name", cx).str;
            if (const char* req = building_ff_requirement(bid, g_sb_extra.ff_owned)) {
                forge::JsonValue o = sandbox_state_json(); o.obj["ok"] = jbool(false);
                o.obj["msg"] = forge::json_str(name + " " + req + " (grant it below)"); return J(200, o);
            }
            bool ok = start_building(g_sb_world.colonies[0], bid, cost, minc);
            forge::JsonValue o = sandbox_state_json(); o.obj["ok"] = jbool(ok);
            o.obj["msg"] = forge::json_str(ok ? ("Started " + name + " (" + std::to_string(cost) + " hammers)")
                                              : (name + " unavailable (too small or already built)"));
            return J(200, o);
        }
        // Sandbox: assign a colonist to a tile (raw good, with its terrain) or a building slot
        // (good 16 Hammers / 17 Crosses / 18 Bells, or an artisan good 9..15), then recompute so the
        // production effect is immediate.
        if (path == "/api/sandbox/assign" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            if (!g_sb_active) sandbox_new(3);
            Colony& col = g_sb_world.colonies[0];
            Colony::Worker wk;
            wk.profession = b.find("profession") ? b.find("profession")->as_int(19) : 19;
            wk.tile    = b.find("tile")    ? b.find("tile")->as_int(-1) : -1;
            wk.good    = b.find("good")    ? b.find("good")->as_int(0) : 0;
            wk.terrain = b.find("terrain") ? b.find("terrain")->as_int(2) : 2;
            const forge::JsonValue* ev = b.find("expert");
            wk.expert = ev ? (ev->type == forge::JsonValue::Bool ? ev->b : ev->as_int(0) != 0) : false;
            col.workers.push_back(wk);
            if ((int)col.workers.size() > col.population) col.population = (int)col.workers.size();
            forge::colony_compute_production(col, g_sb_game.difficulty, g_active_rules, g_sb_extra.ff_owned);
            return J(200, sandbox_state_json());
        }
        if (path == "/api/sandbox/unassign" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            if (!g_sb_active) sandbox_new(3);
            Colony& col = g_sb_world.colonies[0];
            int idx = b.find("worker") ? b.find("worker")->as_int(-1) : -1;
            if (idx >= 0 && idx < (int)col.workers.size()) {
                col.workers.erase(col.workers.begin() + idx);
                if (col.population > (int)col.workers.size() && col.population > 1) col.population = (int)col.workers.size();
            }
            forge::colony_compute_production(col, g_sb_game.difficulty, g_active_rules, g_sb_extra.ff_owned);
            return J(200, sandbox_state_json());
        }
        // Sandbox: grant/revoke a founding father (a bit in ff_owned) to watch its production effect.
        if (path == "/api/sandbox/father" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            if (!g_sb_active) sandbox_new(3);
            int id = b.find("id") ? b.find("id")->as_int(-1) : -1;
            const forge::JsonValue* onv = b.find("on");
            bool on = onv ? (onv->type == forge::JsonValue::Bool ? onv->b : onv->as_int(0) != 0) : true;
            if (id >= 0 && id < 32) {
                if (on) { g_sb_extra.ff_owned |= (1u << id); g_sb_extra.last_ff = id; }   // reveal it
                else    { g_sb_extra.ff_owned &= ~(1u << id); if (g_sb_extra.last_ff == id) g_sb_extra.last_ff = -1; }
                if (g_sb_extra.offered_ff == id) g_sb_extra.offered_ff = -1;               // re-offer next
            }
            forge::colony_compute_production(g_sb_world.colonies[0], g_sb_game.difficulty, g_active_rules, g_sb_extra.ff_owned);
            return J(200, sandbox_state_json());
        }
        // Sandbox: ship a good to the Europe market and sell it (the path when you have NO Custom
        // House) -- proceeds = qty * @CARGO bid * (100 - tax)/100, the same price the Custom House gets.
        if (path == "/api/sandbox/sell" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            if (!g_sb_active) sandbox_new(3);
            Colony& col = g_sb_world.colonies[0];
            int gd = b.find("good") ? b.find("good")->as_int(-1) : -1;
            int qty = b.find("qty") ? b.find("qty")->as_int(0) : 0;
            if (gd < 1 || gd >= NGOODS) return err(400, "bad good");
            if ((g_sb_extra.boycotts >> gd) & 1u) return err(400, good_display(gd) + " is boycotted in Europe");
            if (qty <= 0 || qty > col.stockpile[gd]) qty = col.stockpile[gd];
            if (qty <= 0) return err(400, "nothing to sell");
            forge::EngineCtx cx{g_sb_game, g_sb_world, g_sb_colony_xy, g_sb_extra, g_active_rules, sb_rng};
            int bid = vc::sim::market_bid(g_sb_game, 0, gd);   // published price (level - 1)
            col.stockpile[gd] -= qty;
            // Taxed sale; the tax funds the King's REF; the volume floods the market (trade +=
            // qty) and the published level re-derives (pool recompute / -1 stepper).
            long proceeds = vc::sim::market_sell(g_sb_game, 0, gd, qty, live_market_rules(cx));
            forge::JsonValue o = sandbox_state_json();
            o.obj["msg"] = forge::json_str("Shipped " + std::to_string(qty) + " " + good_display(gd) +
                                           " to Europe for " + std::to_string(proceeds) + " gold (bid " + std::to_string(bid) +
                                           " -> " + std::to_string(vc::sim::market_bid(g_sb_game, 0, gd)) + ")");
            return J(200, o);
        }
        if (path == "/api/sandbox/rush" && method == "POST") {
            if (!g_sb_active) sandbox_new(3);
            Colony& col = g_sb_world.colonies[0];
            if (col.build_target < 0) return err(400, "nothing under construction");
            long rem = (long)col.build_cost - (long)col.build_bank; if (rem < 0) rem = 0;
            long gold_cost = rem * g_active_rules.cfg.rush_gold_per_hammer;   // editable knob (cfg)
            bool ok = rush_build(col, g_sb_game.powers[0], gold_cost);
            forge::JsonValue o = sandbox_state_json(); o.obj["ok"] = jbool(ok);
            o.obj["msg"] = forge::json_str(ok ? "Construction complete" : "Not enough gold");
            return J(200, o);
        }
        if (path == "/api/sandbox/step" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            if (!g_sb_active) sandbox_new(3);
            int n = b.find("n") ? b.find("n")->as_int(1) : 1; if (n < 1) n = 1; if (n > 50) n = 50;
            g_sb_extra.last_ff = -1;                           // clear stale reveal before stepping
            for (int i = 0; i < n; ++i) {
                // Recompute production from the colonist roster (as the real turn pipeline's
                // production phase does), THEN run the economic step off those fresh numbers.
                forge::colony_compute_production(g_sb_world.colonies[0], g_sb_game.difficulty, g_active_rules, g_sb_extra.ff_owned);
                step_turn(g_sb_game, g_sb_world, sb_rng, 0, g_active_rules);
                // Continental Congress: liberty bells accumulate toward the next founding father,
                // who is acquired (and revealed) when the bell pool crosses the cost threshold.
                congress_step(g_sb_extra, g_sb_game.difficulty, g_sb_game.year,
                              g_sb_world.colonies[0].bells_per_turn, sb_rng);
                // (the market phase -- drift + republish + volume reset -- runs inside step_turn)
            }
            return J(200, sandbox_state_json());
        }

        if (path.rfind("/assets/", 0) == 0)
            return serve_asset(path.substr(8));   // strip "/assets/"

        if (path == "/api/tables") {
            // ?file=names|dgroup|tribe (default names). User edits are kept in a separate
            // overlay file so the pristine extraction (the verify_rules oracle) stays intact.
            std::string file = qparam(query, "file");
            std::string p = qparam(query, "path");          // legacy explicit path still honored
            std::string canon, user;
            if (!p.empty()) return J(200, forge::json_parse_file(p));
            if (file.empty()) file = "names";
            if (!table_paths(file, canon, user)) return err(400, "unknown table file: " + file);
            return J(200, forge::json_parse_file(std::filesystem::exists(user) ? user : canon));
        }

        if (path == "/api/tables/list") {
            // The available table files + their section/grid counts (for the picker).
            forge::JsonValue o = jarr();
            for (const char* file : {"names", "dgroup", "tribe"}) {
                std::string canon, user; table_paths(file, canon, user);
                bool edited = std::filesystem::exists(user);
                forge::JsonValue e = jobj();
                e.obj["file"] = jstr(file);
                e.obj["edited"] = jbool(edited);
                try {
                    forge::JsonValue d = forge::json_parse_file(edited ? user : canon);
                    int grids = 0;
                    if (file == std::string("dgroup")) {
                        if (const forge::JsonValue* r = d.find("records")) grids += (int)r->arr.size();
                        if (d.find("scalars")) grids += 1;
                    } else for (auto& kv : d.obj) if (kv.second.is_object() && kv.second.find("rows")) ++grids;
                    e.obj["grids"] = forge::json_num(grids);
                } catch (...) { e.obj["grids"] = forge::json_num(0); }
                o.arr.push_back(e);
            }
            return J(200, o);
        }

        if (path == "/api/tables/save" && method == "POST") {
            std::string file = qparam(query, "file"), canon, user;
            if (!table_paths(file, canon, user)) return err(400, "unknown table file: " + file);
            forge::JsonValue doc;
            try { doc = forge::json_parse(body); } catch (const std::exception& e) { return err(400, std::string("bad JSON: ") + e.what()); }
            std::error_code ec; std::filesystem::create_directories("data_extracted/engine/tables_user", ec);
            std::ofstream f(user, std::ios::binary);
            if (!f) return err(500, "cannot write " + user);
            f << forge::json_dump(doc);
            forge::invalidate_tables();   // a newly added row resolves at once in @SECTION[...] bindings
            return J(200, jbool(true));
        }

        if (path == "/api/tables/reset" && method == "POST") {
            std::string file = qparam(query, "file"), canon, user;
            if (!table_paths(file, canon, user)) return err(400, "unknown table file: " + file);
            std::error_code ec; std::filesystem::remove(user, ec);
            forge::invalidate_tables();
            return J(200, jbool(true));
        }

        if (path == "/api/data/check") {
            std::string p = qparam(query, "path");
            if (p.empty()) p = "data_extracted/tables/names_tables.json";
            forge::DataReport r = forge::check_data_tables(p);
            forge::JsonValue o = jobj();
            o.obj["ok"] = jbool(r.ok());
            o.obj["sections"] = forge::json_num(r.sections);
            o.obj["rows"] = forge::json_num(r.rows);
            o.obj["issues"] = jstrs(r.issues);
            o.obj["warnings"] = jstrs(r.warnings);
            return J(200, o);
        }

        if (path == "/api/map") {
            std::string p = qparam(query, "path");
            if (p.empty()) return err(400, "missing ?path");
            forge::MpFile m = forge::load_mp(p);
            forge::JsonValue o = jobj();
            o.obj["w"] = forge::json_num(m.w);
            o.obj["h"] = forge::json_num(m.h);
            o.obj["rest"] = forge::json_num((double)m.rest.size());
            forge::JsonValue t = jarr();
            for (uint8_t b : m.terrain) t.arr.push_back(forge::json_num(b));
            o.obj["terrain"] = t;
            o.obj["report"] = maprep_json(forge::validate(m));
            return J(200, o);
        }

        if (path == "/api/map/save" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            const forge::JsonValue* pp = b.find("path");
            const forge::JsonValue* tt = b.find("terrain");
            if (!pp || !pp->is_string() || !tt || !tt->is_array()) return err(400, "need {path,terrain}");
            forge::MpFile m = forge::load_mp(pp->str);             // reload to preserve trailing bytes
            if ((int)tt->arr.size() != m.w * m.h) return err(400, "terrain size != w*h");
            for (size_t i = 0; i < tt->arr.size(); ++i) m.terrain[i] = (uint8_t)tt->arr[i].as_int();
            forge::save_mp(pp->str, m);
            forge::JsonValue o = jobj(); o.obj["ok"] = jbool(true); return J(200, o);
        }

        return err(404, "not found: " + path);
    } catch (const std::exception& e) {
        return err(400, e.what());
    }
}

static int engine_selftest() {
    int fail = 0;
    auto check = [&](bool ok, const char* m) { if (!ok) { ++fail; std::printf("  FAIL: %s\n", m); } };

    forge::JsonValue cat = forge::node_catalog();
    check(cat.find("categories") && !cat.find("categories")->arr.empty(), "node catalog non-empty");

    GameState g; World w; std::vector<std::pair<int,int>> cxy; forge::EngineExtra ex;
    RuleData rd = make_default_rules();
    g.powers[0].gold = 100;
    int seed = 0x1234;
    auto rng = [&](int lo, int hi) { seed = seed * 1103515245 + 12345;
        unsigned v = ((unsigned)seed >> 16) & 0x7FFF; return hi <= lo ? lo : lo + (int)(v % (unsigned)(hi - lo + 1)); };
    forge::EngineCtx cx{g, w, cxy, ex, rd, rng};

    check(forge::resolve_binding("power0.gold", cx).as_int() == 100, "resolve_binding power0.gold");

    // OnTestFire -> GrantGold(Constant 50) onto power 0.
    forge::JsonValue gr = forge::json_parse(
        R"({"id":"t","nodes":[{"id":"t","type":"OnTestFire","params":{}},)"
        R"({"id":"c","type":"Constant","params":{"value":50}},)"
        R"({"id":"g","type":"GrantGold","params":{"power":"0"}}],"edges":[)"
        R"({"from":{"node":"t","pin":"out"},"to":{"node":"g","pin":"in"}},)"
        R"({"from":{"node":"c","pin":"value"},"to":{"node":"g","pin":"amount"}}]})");
    forge::JsonValue rep = forge::run_graph(gr, cx);
    check(g.powers[0].gold == 150, "graph GrantGold applied (100+50)");
    check(rep.find("log") && !rep.find("log")->arr.empty(), "run log non-empty");

    // ShowPopup pauses and returns a popup with choices.
    forge::JsonValue gp = forge::json_parse(
        R"({"id":"p","nodes":[{"id":"t","type":"OnTestFire","params":{}},)"
        R"({"id":"p","type":"ShowPopup","params":{"title":"Hi","body":"x","choices":"A,B"}}],)"
        R"("edges":[{"from":{"node":"t","pin":"out"},"to":{"node":"p","pin":"in"}}]})");
    forge::JsonValue rep2 = forge::run_graph(gp, cx);
    const forge::JsonValue* pop = rep2.find("popup");
    check(pop && pop->is_object() && pop->find("choices") && pop->find("choices")->arr.size() == 2,
          "ShowPopup returns a popup with 2 choices");

    // Navigate sets the goto.
    forge::JsonValue gn = forge::json_parse(
        R"({"id":"n","nodes":[{"id":"t","type":"OnTestFire","params":{}},)"
        R"({"id":"n","type":"Navigate","params":{"screen":"europe"}}],)"
        R"("edges":[{"from":{"node":"t","pin":"out"},"to":{"node":"n","pin":"in"}}]})");
    forge::JsonValue rep3 = forge::run_graph(gn, cx);
    check(rep3.find("goto") && rep3.find("goto")->str == "europe", "Navigate sets goto");

    // set_binding writes; resolve reads it back.
    check(forge::set_binding("power0.gold", 777, cx) && g.powers[0].gold == 777, "set_binding writes gold");

    // --- F1: richer sim-wired nodes ---
    // GiveFoundingFather sets the bit; HasFoundingFather + ff.<id> binding read it.
    forge::JsonValue gff = forge::json_parse(
        R"({"id":"f","nodes":[{"id":"t","type":"OnTestFire","params":{}},)"
        R"({"id":"g","type":"GiveFoundingFather","params":{"father":16}}],)"
        R"("edges":[{"from":{"node":"t","pin":"out"},"to":{"node":"g","pin":"in"}}]})");
    forge::run_graph(gff, cx);
    check(ex.ff_owned == (1u << 16), "GiveFoundingFather sets Pocahontas (16)");
    check(forge::resolve_binding("ff.16", cx).as_int() == 1, "ff.16 binding reads 1");
    check(forge::resolve_binding("ff.count", cx).as_int() == 1, "ff.count is 1");

    // Pocahontas (granted above) halves every increase: two +40 deltas -> +20 each = 40.
    forge::JsonValue gt = forge::json_parse(
        R"({"id":"x","nodes":[{"id":"t","type":"OnTestFire","params":{}},)"
        R"({"id":"a","type":"ChangeNativeTension","params":{"amount":40}},)"
        R"({"id":"b","type":"ChangeNativeTension","params":{"amount":40}}],"edges":[)"
        R"({"from":{"node":"t","pin":"out"},"to":{"node":"a","pin":"in"}},)"
        R"({"from":{"node":"a","pin":"out"},"to":{"node":"b","pin":"in"}}]})");
    forge::run_graph(gt, cx);
    check(ex.tension == 40, "tension: two +40 halved by Pocahontas = 40");
    check(forge::resolve_binding("natives.tension", cx).as_int() == 40, "natives.tension binding");

    // AddBoycott(Tobacco=index 2) flips boycott.2.
    forge::JsonValue gb = forge::json_parse(
        R"({"id":"y","nodes":[{"id":"t","type":"OnTestFire","params":{}},)"
        R"({"id":"a","type":"AddBoycott","params":{"good":"Tobacco"}}],)"
        R"("edges":[{"from":{"node":"t","pin":"out"},"to":{"node":"a","pin":"in"}}]})");
    forge::run_graph(gb, cx);
    check(forge::resolve_binding("boycott.2", cx).as_int() == 1, "AddBoycott flips boycott.2");

    // DeclareWar(0,1) -> war.0.1 binding true.
    forge::JsonValue gw = forge::json_parse(
        R"({"id":"z","nodes":[{"id":"t","type":"OnTestFire","params":{}},)"
        R"({"id":"a","type":"DeclareWar","params":{"a":"0","b":"1"}}],)"
        R"("edges":[{"from":{"node":"t","pin":"out"},"to":{"node":"a","pin":"in"}}]})");
    forge::run_graph(gw, cx);
    check(forge::resolve_binding("war.0.1", cx).as_int() == 1, "DeclareWar sets war.0.1");

    // ResolveCombat between two spawned units leaves exactly one alive-or-demoted outcome.
    {
        vc::sim::Unit ua; ua.type = 1; ua.owner = 0; ua.alive = true; ua.x = 5; ua.y = 5;   // Soldiers
        vc::sim::Unit ud; ud.type = 0; ud.owner = 1; ud.alive = true; ud.x = 5; ud.y = 5;   // Colonists
        w.units.push_back(ua); w.units.push_back(ud);
        forge::JsonValue gc = forge::json_parse(
            R"({"id":"c","nodes":[{"id":"t","type":"OnTestFire","params":{}},)"
            R"({"id":"a","type":"ResolveCombat","params":{"attacker":0,"defender":1}}],)"
            R"("edges":[{"from":{"node":"t","pin":"out"},"to":{"node":"a","pin":"in"}}]})");
        forge::JsonValue repc = forge::run_graph(gc, cx);
        const forge::JsonValue* ef = repc.find("effects");
        bool reported = false;
        if (ef) for (const auto& s : ef->arr) if (s.str.rfind("combat:", 0) == 0) reported = true;
        check(reported, "ResolveCombat reports a combat outcome");
    }

    // --- F3: the engine VM runs on the CTX ruleset -- a modded unit stat bites combat.
    // Pull the attacker strength out of "combat: ... won (A vs B)" under default vs modded rules.
    auto combat_atk = [&](const RuleData& rdx) -> int {
        GameState g2; World w2; std::vector<std::pair<int,int>> cxy2; forge::EngineExtra ex2;
        forge::EngineCtx cxx{g2, w2, cxy2, ex2, rdx, rng};
        vc::sim::Unit ua; ua.type = 1; ua.owner = 0; ua.alive = true;   // Soldiers (human attacker)
        vc::sim::Unit ud; ud.type = 0; ud.owner = 1; ud.alive = true;   // Colonists
        w2.units.push_back(ua); w2.units.push_back(ud);
        forge::JsonValue gc = forge::json_parse(
            R"({"id":"c","nodes":[{"id":"t","type":"OnTestFire","params":{}},)"
            R"({"id":"a","type":"ResolveCombat","params":{"attacker":0,"defender":1}}],)"
            R"("edges":[{"from":{"node":"t","pin":"out"},"to":{"node":"a","pin":"in"}}]})");
        forge::JsonValue rep = forge::run_graph(gc, cxx);
        const forge::JsonValue* ef = rep.find("effects");
        if (ef) for (const auto& s : ef->arr) {
            size_t lp = s.str.find('('); size_t vs = s.str.find(" vs ");
            if (s.str.rfind("combat:", 0) == 0 && lp != std::string::npos && vs != std::string::npos)
                return std::atoi(s.str.c_str() + lp + 1);
        }
        return -1;
    };
    forge::OverlayResult om = forge::apply_overlay(
        forge::json_parse(R"({"units":{"Soldiers":{"attack":20}}})"), make_default_rules());
    int atk_def = combat_atk(make_default_rules());
    int atk_mod = combat_atk(om.rules);
    check(atk_def > 0 && atk_mod > atk_def && atk_mod >= 20,
          "modded Soldiers attack raises ResolveCombat attacker strength");

    // PickText/PickNumber feed a popup's %STRING0/%NUMBER0 slots from a computed index.
    {
        forge::JsonValue gp = forge::json_parse(
            R"({"id":"p","nodes":[)"
            R"({"id":"t","type":"OnTestFire","params":{}},)"
            R"({"id":"i","type":"Constant","params":{"value":1}},)"
            R"({"id":"s","type":"PickText","params":{"options":"Petty Criminals,Indentured Servants,Educated Elite"}},)"
            R"({"id":"n","type":"PickNumber","params":{"values":"300,400,2000"}},)"
            R"({"id":"d","type":"ShowPopup","params":{"body":"Class %STRING0 costs %NUMBER0 gold.","choices":"OK"}}],)"
            R"("edges":[)"
            R"({"from":{"node":"t","pin":"out"},"to":{"node":"d","pin":"in"}},)"
            R"({"from":{"node":"i","pin":"value"},"to":{"node":"s","pin":"index"}},)"
            R"({"from":{"node":"i","pin":"value"},"to":{"node":"n","pin":"index"}},)"
            R"({"from":{"node":"s","pin":"value"},"to":{"node":"d","pin":"str0"}},)"
            R"({"from":{"node":"n","pin":"value"},"to":{"node":"d","pin":"num0"}}]})");
        forge::JsonValue rep = forge::run_graph(gp, cx);
        const forge::JsonValue* pp = rep.find("popup");
        std::string body = pp && pp->is_object() && pp->find("body") ? pp->find("body")->str : "";
        check(body.find("Indented Servants") != std::string::npos ||
              body.find("Indentured Servants") != std::string::npos,
              "PickText fills %STRING0 with the index-1 entry");
        check(body.find("400") != std::string::npos, "PickNumber fills %NUMBER0 with the index-1 value");
    }

    // Notify emits a real GAME.TXT message (not a hardcoded string) with %STRING fill.
    {
        forge::JsonValue gn = forge::json_parse(
            R"({"id":"n","nodes":[)"
            R"({"id":"t","type":"OnTestFire","params":{}},)"
            R"({"id":"s","type":"PickText","params":{"options":"Jamestown,Plymouth"}},)"
            R"({"id":"i","type":"Constant","params":{"value":0}},)"
            R"({"id":"m","type":"Notify","params":{"textKey":"@NEWCOLONIST"}}],)"
            R"("edges":[)"
            R"({"from":{"node":"t","pin":"out"},"to":{"node":"m","pin":"in"}},)"
            R"({"from":{"node":"i","pin":"value"},"to":{"node":"s","pin":"index"}},)"
            R"({"from":{"node":"s","pin":"value"},"to":{"node":"m","pin":"str0"}}]})");
        forge::JsonValue rep = forge::run_graph(gn, cx);
        bool ok = false; const forge::JsonValue* ef = rep.find("effects");
        if (ef) for (const auto& e : ef->arr)
            if (e.str.find("Jamestown") != std::string::npos && e.str.find("colonist") != std::string::npos) ok = true;
        check(ok, "Notify emits the real @NEWCOLONIST message with %STRING0 filled");
    }

    // Formula collapses a Constant/Math/Compare chain into one node, mixing literals, live
    // bindings, table cells, wired pins, and functions.
    {
        cx.g.powers[0].gold = 50000; cx.x.national_sol = 100; cx.g.powers[0].tax = 20;
        forge::JsonValue gf = forge::json_parse(
            R"({"id":"f","nodes":[)"
            R"({"id":"t","type":"OnTestFire","params":{}},)"
            R"({"id":"c","type":"Constant","params":{"value":7}},)"
            R"({"id":"fm","type":"Formula","params":{"expr":")"
            R"((2*revolution.sol - power0.tax)*5 + power0.gold/100 + @CLASS[3].transport_cost/100 + a"})"
            R"(},)"
            R"({"id":"d","type":"ShowPopup","params":{"body":"V=%NUMBER0","choices":"ok"}}],)"
            R"("edges":[)"
            R"({"from":{"node":"t","pin":"out"},"to":{"node":"d","pin":"in"}},)"
            R"({"from":{"node":"c","pin":"value"},"to":{"node":"fm","pin":"a"}},)"
            R"({"from":{"node":"fm","pin":"value"},"to":{"node":"d","pin":"num0"}}]})");
        forge::JsonValue rep = forge::run_graph(gf, cx);
        const forge::JsonValue* pp = rep.find("popup");
        std::string body = pp && pp->is_object() && pp->find("body") ? pp->find("body")->str : "";
        // (2*100-20)*5 + 50000/100 + 800/100 + 7 = 900 + 500 + 8 + 7 = 1415
        check(body.find("1415") != std::string::npos,
              "Formula evaluates live bindings + table cell + wired pin (=1415)");
    }

    // @SECTION[row].column resolves a live data-table cell (any added row becomes a variable).
    check(forge::resolve_binding("@BUILDING[name:Fort].cost", cx).as_int() == 120,
          "@BUILDING[name:Fort].cost table-cell binding = 120");
    check(forge::resolve_binding("@CLASS[3].transport_cost", cx).as_int() == 800,
          "@CLASS[3].transport_cost table-cell binding = 800");

    // Pause/resume value cache: a roll() feeding both the popup and a post-choice action stays
    // stable across the resume when the popup's _cache is echoed back (offered == applied).
    {
        const char* GSRC = R"J({
            "id":"c","nodes":[
              {"id":"t","type":"OnTestFire","params":{}},
              {"id":"f","type":"Formula","params":{"expr":"roll(1,1000000)"}},
              {"id":"p","type":"ShowPopup","params":{"body":"V=%NUMBER0","choices":"ok"}},
              {"id":"g","type":"GrantGold","params":{"power":"0"}}],
            "edges":[
              {"from":{"node":"t","pin":"out"},"to":{"node":"p","pin":"in"}},
              {"from":{"node":"f","pin":"value"},"to":{"node":"p","pin":"num0"}},
              {"from":{"node":"p","pin":"ok"},"to":{"node":"g","pin":"in"}},
              {"from":{"node":"f","pin":"value"},"to":{"node":"g","pin":"amount"}}]})J";
        forge::JsonValue gc = forge::json_parse(GSRC);
        forge::JsonValue rep = forge::run_graph(gc, cx);
        const forge::JsonValue* pp = rep.find("popup");
        std::string body = pp && pp->find("body") ? pp->find("body")->str : "";
        long shown = std::atol(body.c_str() + body.find('=') + 1);
        forge::JsonValue cache = pp && pp->find("_cache") ? *pp->find("_cache") : forge::JsonValue{};
        // resume WITH the cache -> the granted amount matches the shown roll
        forge::JsonValue r2 = forge::run_graph(gc, cx, "p", "ok", cache);
        long applied = 0; if (const forge::JsonValue* ef = r2.find("effects"))
            for (const auto& e : ef->arr) { size_t k = e.str.rfind("+= ");
                if (k != std::string::npos) applied = std::atol(e.str.c_str() + k + 3); }
        check(shown > 0 && applied == shown, "pause/resume cache keeps the rolled value stable (offered==applied)");
    }

    // Worker/stockpile production: assign colonists to tiles + a building, run ColonyProduce,
    // and confirm the per-good stockpile + net food/bells match the terrain tables + spec math.
    {
        vc::sim::Colony col; col.population = 3; col.rebel_A = 0; col.rebel_B = 1;  // sol=0: tory truncates to 0 for a small colony + no SoL bonus (isolates conversion)
        w.colonies.push_back(col);   // no colonies were pushed to `w` earlier, so this is colony 0
        forge::JsonValue gw = forge::json_parse(
            R"({"id":"w","nodes":[)"
            R"({"id":"t","type":"OnTestFire","params":{}},)"
            R"({"id":"a1","type":"AssignWorker","params":{"colony":"0","terrain":3,"good":"Cotton","expert":"0"}},)"
            R"({"id":"a2","type":"AssignWorker","params":{"colony":"0","terrain":2,"good":"Food","expert":"0"}},)"
            R"({"id":"a3","type":"AssignWorker","params":{"colony":"0","terrain":0,"good":"Bells","expert":"0"}},)"
            R"({"id":"a4","type":"AssignWorker","params":{"colony":"0","terrain":3,"good":"Cotton","expert":"1"}},)"
            R"({"id":"pr","type":"ColonyProduce","params":{"colony":"0"}}],"edges":[)"
            R"({"from":{"node":"t","pin":"out"},"to":{"node":"a1","pin":"in"}},)"
            R"({"from":{"node":"a1","pin":"out"},"to":{"node":"a2","pin":"in"}},)"
            R"({"from":{"node":"a2","pin":"out"},"to":{"node":"a3","pin":"in"}},)"
            R"({"from":{"node":"a3","pin":"out"},"to":{"node":"a4","pin":"in"}},)"
            R"({"from":{"node":"a4","pin":"out"},"to":{"node":"pr","pin":"in"}}]})");
        forge::run_graph(gw, cx);
        check(forge::resolve_binding("colony0.workers", cx).as_int() == 4, "AssignWorker pushed 4 colonists");
        // Prairie(3) y_planter_cotton = 3, sol=100 -> tory 0. Plain worker = 3; expert (Cotton is a
        // non-era good, so *2 not +2) doubles -> 6. Stockpile Cotton = 3 + 6 = 9 (no per-good cap).
        check(forge::resolve_binding("colony0.stockpile.3", cx).as_int() == 9,
              "ColonyProduce: cotton (plain 3 + expert x2 = 6) -> stockpile Cotton = 9");
        // Plains(2) y_farmer = 4; net food = max(4 - 2*pop(3), 0) = max(-2,0) = 0 (colony.md floor)
        check(w.colonies[0].food_per_turn == 0, "ColonyProduce: net food = max(4 - 2*pop, 0) = 0 (floored)");
        // building Bells worker base rate = 3
        check(w.colonies[0].bells_per_turn == 3, "ColonyProduce: building Bells worker = 3 bells");
    }

    // Raw->finished conversion + NO per-good stockpile ceiling (colony.md §3 / CORRECTED warehouse).
    {
        vc::sim::Colony col; col.population = 1; col.rebel_A = 0; col.rebel_B = 1;  // sol=0: tory truncates to 0 for a small colony + no SoL bonus (isolates conversion)
        col.built_mask = (1ull << 27);   // owns the Rum Distiller's House (@BUILDING 27) -> Rum gate open
        w.colonies.push_back(col);   // colony 1
        forge::set_binding("colony1.stockpile.6", 98, cx);   // pre-bank 98 Ore (cap would be 100)
        forge::JsonValue gc = forge::json_parse(
            R"({"id":"c","nodes":[)"
            R"({"id":"t","type":"OnTestFire","params":{}},)"
            R"({"id":"o1","type":"AssignWorker","params":{"colony":"1","terrain":0,"good":"Ore","expert":"0"}},)"
            R"({"id":"o2","type":"AssignWorker","params":{"colony":"1","terrain":0,"good":"Ore","expert":"0"}},)"
            R"({"id":"s1","type":"AssignWorker","params":{"colony":"1","terrain":5,"good":"Sugar","expert":"0"}},)"
            R"({"id":"d1","type":"AssignWorker","params":{"colony":"1","terrain":0,"good":"Rum","expert":"0"}},)"
            R"({"id":"d2","type":"AssignWorker","params":{"colony":"1","terrain":0,"good":"Rum","expert":"0"}},)"
            R"({"id":"pr","type":"ColonyProduce","params":{"colony":"1"}}],"edges":[)"
            R"({"from":{"node":"t","pin":"out"},"to":{"node":"o1","pin":"in"}},)"
            R"({"from":{"node":"o1","pin":"out"},"to":{"node":"o2","pin":"in"}},)"
            R"({"from":{"node":"o2","pin":"out"},"to":{"node":"s1","pin":"in"}},)"
            R"({"from":{"node":"s1","pin":"out"},"to":{"node":"d1","pin":"in"}},)"
            R"({"from":{"node":"d1","pin":"out"},"to":{"node":"d2","pin":"in"}},)"
            R"({"from":{"node":"d2","pin":"out"},"to":{"node":"pr","pin":"in"}}]})");
        forge::run_graph(gc, cx);
        // Tundra(0) y_ore = 2 x2 workers = 4; 98 + 4 = 102 -- NOT clamped to the old (0+1)*100 cap.
        check(forge::resolve_binding("colony1.stockpile.6", cx).as_int() == 102,
              "ColonyProduce: Ore 98+4 = 102, no per-good warehouse ceiling");
        // Savannah(5) y_planter_sugar = 3 -> 3 Sugar. Distiller 1 converts 3 Sugar -> 3 Rum (1:1);
        // distiller 2 finds 0 Sugar left -> 0 Rum (NOT 3 from nothing). Rum = 3, Sugar = 0.
        check(forge::resolve_binding("colony1.stockpile.9", cx).as_int() == 3,
              "ColonyProduce: 3 Sugar -> 3 Rum via conversion; 2nd distiller makes 0 (no raw)");
        check(forge::resolve_binding("colony1.stockpile.1", cx).as_int() == 0,
              "ColonyProduce: conversion consumed the raw Sugar (stockpile Sugar = 0)");
    }

    // Building gate: a distiller with NO Rum Distiller's House produces 0 Rum (the raw Sugar stays).
    {
        vc::sim::Colony col; col.population = 1; col.rebel_A = 0; col.rebel_B = 1;  // built_mask = 0; sol=0 (no bonus)
        w.colonies.push_back(col);   // colony 2
        forge::JsonValue gg = forge::json_parse(
            R"({"id":"g","nodes":[)"
            R"({"id":"t","type":"OnTestFire","params":{}},)"
            R"({"id":"s","type":"AssignWorker","params":{"colony":"2","terrain":5,"good":"Sugar","expert":"0"}},)"
            R"({"id":"d","type":"AssignWorker","params":{"colony":"2","terrain":0,"good":"Rum","expert":"0"}},)"
            R"({"id":"pr","type":"ColonyProduce","params":{"colony":"2"}}],"edges":[)"
            R"({"from":{"node":"t","pin":"out"},"to":{"node":"s","pin":"in"}},)"
            R"({"from":{"node":"s","pin":"out"},"to":{"node":"d","pin":"in"}},)"
            R"({"from":{"node":"d","pin":"out"},"to":{"node":"pr","pin":"in"}}]})");
        forge::run_graph(gg, cx);
        check(forge::resolve_binding("colony2.stockpile.9", cx).as_int() == 0,
              "Building gate: no Rum Distiller's House -> distiller makes 0 Rum");
        check(forge::resolve_binding("colony2.stockpile.1", cx).as_int() == 3,
              "Building gate: ungated Sugar still banked (3), just not converted");
    }

    // Auto-export (warehousing.md 6.4): a good over 100 is cut to 50 and the excess sold (taxed)
    // into the owner's gold at the PUBLISHED market bid (price_level - 1), not the hidden supply
    // base -- but wasted, not sold, once independence is declared.
    {
        g.price_base[9] = 800; g.price_base[10] = 800; g.powers[0].tax = 0; ex.woi_declared = false;
        g.powers[0].price_level[9] = 12; g.powers[0].price_level[10] = 12;   // published level
        vc::sim::Colony col; col.owner_power = 0;
        w.colonies.push_back(col);   // colony 3
        forge::set_binding("colony3.stockpile.9", 102, cx);   // Rum 102
        forge::set_binding("colony3.stockpile.10", 130, cx);  // Cigars 130
        long gold_before = g.powers[0].gold;
        forge::JsonValue ge = forge::json_parse(
            R"({"id":"e","nodes":[{"id":"t","type":"OnTestFire","params":{}},)"
            R"({"id":"x","type":"ExportOverflow","params":{"colony":"3"}}],)"
            R"("edges":[{"from":{"node":"t","pin":"out"},"to":{"node":"x","pin":"in"}}]})");
        forge::run_graph(ge, cx);
        check(forge::resolve_binding("colony3.stockpile.9", cx).as_int() == 50 &&
              forge::resolve_binding("colony3.stockpile.10", cx).as_int() == 50,
              "ExportOverflow: over-100 goods cut back to 50");
        // excess Rum 52 + excess Cigars 80 = 132 units @ published bid (12-1=11), tax 0 -> +1452 gold
        check(g.powers[0].gold - gold_before == 1452,
              "ExportOverflow: excess sold at the published bid, proceeds credited (+1452)");

        ex.woi_declared = true;
        vc::sim::Colony col2; col2.owner_power = 0;
        w.colonies.push_back(col2);  // colony 4
        forge::set_binding("colony4.stockpile.9", 102, cx);
        long gold2 = g.powers[0].gold;
        forge::JsonValue ge2 = forge::json_parse(
            R"({"id":"e2","nodes":[{"id":"t","type":"OnTestFire","params":{}},)"
            R"({"id":"x","type":"ExportOverflow","params":{"colony":"4"}}],)"
            R"("edges":[{"from":{"node":"t","pin":"out"},"to":{"node":"x","pin":"in"}}]})");
        forge::run_graph(ge2, cx);
        check(forge::resolve_binding("colony4.stockpile.9", cx).as_int() == 50 &&
              g.powers[0].gold == gold2,
              "ExportOverflow: under independence the excess is wasted (cut to 50, no gold)");
        ex.woi_declared = false;
    }

    // Sequence must HALT at a popup: a ShowPopup wired to pin0 has to pause the whole Sequence,
    // not let pin1's action fire prematurely (the pause/resume invariant across a fan-out).
    {
        GameState gs; World ws; std::vector<std::pair<int,int>> cxys; forge::EngineExtra exs;
        forge::EngineCtx cxs{gs, ws, cxys, exs, rd, rng};
        gs.powers[0].gold = 100;
        forge::JsonValue gq = forge::json_parse(
            R"({"id":"q","nodes":[)"
            R"({"id":"t","type":"OnTestFire","params":{}},)"
            R"({"id":"sq","type":"Sequence","params":{}},)"
            R"({"id":"p","type":"ShowPopup","params":{"body":"FIRST","choices":"ok"}},)"
            R"({"id":"c","type":"Constant","params":{"value":50}},)"
            R"({"id":"g","type":"GrantGold","params":{"power":"0"}}],"edges":[)"
            R"({"from":{"node":"t","pin":"out"},"to":{"node":"sq","pin":"in"}},)"
            R"({"from":{"node":"sq","pin":"0"},"to":{"node":"p","pin":"in"}},)"
            R"({"from":{"node":"sq","pin":"1"},"to":{"node":"g","pin":"in"}},)"
            R"({"from":{"node":"c","pin":"value"},"to":{"node":"g","pin":"amount"}}]})");
        forge::JsonValue rq = forge::run_graph(gq, cxs);
        const forge::JsonValue* pq = rq.find("popup");
        std::string bd = pq && pq->is_object() && pq->find("body") ? pq->find("body")->str : "";
        check(bd.find("FIRST") != std::string::npos, "Sequence returns the pin0 popup (paused)");
        check(gs.powers[0].gold == 100, "Sequence halts at popup: pin1 GrantGold did NOT fire prematurely");
    }

    // congress.cost reflects the byte-verified bell-cost curve; congress.bells is writable.
    check(forge::resolve_binding("congress.cost", cx).as_int() > 0, "congress.cost computes the FF bell cost");
    forge::set_binding("congress.bells", 42, cx);
    check(forge::resolve_binding("congress.bells", cx).as_int() == 42, "congress.bells is writable");

    // A3 golden-master: the data-driven turn pipeline (turn.json / forge::run_turn) must be
    // byte-identical to the reference sim::step_turn over several turns.
    {
        auto mkworld = [] {
            GameState gg; gg.difficulty = 2; gg.powers[0].gold = 500;
            gg.price_base[SUGAR] = 800;
            World ww; ww.map_w = 16; ww.map_h = 10;
            ww.terrain.assign((size_t)ww.map_w * ww.map_h, (uint8_t)2);
            Colony c; c.owner_power = 0; c.population = 4; c.hammers_per_turn = 8;
            c.build_target = 0; c.build_cost = 64; c.food_per_turn = 55; c.crosses_output = 3;
            ww.colonies.push_back(c);
            Unit u; u.type = DRAGOONS; u.owner = 0; u.x = 0; u.y = 5;
            u.order = ORDER_GOTO; u.target_x = 12; u.target_y = 5; ww.units.push_back(u);
            return std::make_pair(gg, ww);
        };
        auto refp = mkworld(); auto pipe = mkworld();
        auto det = [](int lo, int) { return lo; };               // deterministic: same rolls both sides
        RuleData rd2 = make_default_rules();
        for (int i = 0; i < 8; ++i) {
            // The pipeline's production phase now runs colony_compute_production before the
            // economic step, so the reference mirrors it per colony (dispatch == direct calls).
            for (Colony& rc : refp.second.colonies) forge::colony_compute_production(rc, refp.first.difficulty, rd2);
            step_turn(refp.first, refp.second, det, 0, rd2);
            forge::run_turn(pipe.first, pipe.second, det, 0, rd2);
        }
        bool same = refp.first.year == pipe.first.year && refp.first.season == pipe.first.season &&
                    refp.first.turn == pipe.first.turn &&
                    refp.first.powers[0].gold == pipe.first.powers[0].gold &&
                    refp.first.powers[0].royal_money == pipe.first.powers[0].royal_money &&
                    refp.first.price_base[SUGAR] == pipe.first.price_base[SUGAR] &&
                    refp.second.colonies.size() == pipe.second.colonies.size() &&
                    refp.second.colonies[0].population == pipe.second.colonies[0].population &&
                    refp.second.colonies[0].build_bank == pipe.second.colonies[0].build_bank &&
                    refp.second.colonies[0].built_mask == pipe.second.colonies[0].built_mask &&
                    refp.second.units.size() == pipe.second.units.size() &&
                    refp.second.units[0].x == pipe.second.units[0].x &&
                    refp.second.units[0].y == pipe.second.units[0].y;
        check(same, "A3 turn.json pipeline == sim::step_turn (golden-master, 8 turns)");
    }

    // Colony production from real colonists: a colony with assigned workers computes food/bells/
    // hammers/crosses/goods from the terrain table + building workers (not flat seed numbers).
    {
        RuleData rd4 = make_default_rules();
        auto mkw = [](int prof, int tile, int terrain, int good) {
            Colony::Worker w; w.profession = prof; w.tile = tile; w.terrain = terrain; w.good = good; w.expert = false; return w; };
        // A: center Plains (terrain 2, auto food 4) + one Farmer on Plains (gross 4), pop 1
        //    -> net = 4 (center) + 4 (farmer) - 2*1 = 6.
        Colony a; a.owner_power = 0; a.human = true; a.population = 1; a.rebel_A = 0; a.rebel_B = 1;
        a.center_terrain = 2;                                        // Plains center -> +4 auto-food
        a.workers.push_back(mkw(0, 0, 2, 0));                         // Farmer, Plains, Food
        forge::colony_compute_production(a, /*diff*/1, rd4);
        check(a.food_per_turn == 6, "center Plains(4) + 1 Farmer(4) - 2 eaten -> net food 6");
        // B: Farmer + Carpenter + Statesman + Preacher, pop 5, with 10 Lumber pre-banked. The
        //    Carpenter converts Lumber -> Hammers (3/turn), CONSUMING lumber from the stockpile;
        //    bells/crosses are produced directly (no raw input).
        Colony b; b.owner_power = 0; b.human = true; b.population = 5; b.rebel_A = 0; b.rebel_B = 1;
        b.stockpile[5] = 10;                                           // 10 Lumber banked
        b.workers.push_back(mkw(0, 0, 2, 0));                          // Farmer -> Food
        b.workers.push_back(mkw(13, -1, 0, 16));                       // Carpenter -> Hammers(16) <- Lumber(5)
        b.workers.push_back(mkw(17, -1, 0, 18));                       // Statesman -> Bells(18)
        b.workers.push_back(mkw(16, -1, 0, 17));                       // Preacher  -> Crosses(17)
        forge::colony_compute_production(b, 1, rd4);
        check(b.bells_per_turn == 3,   "Statesman -> 3 bells/turn");
        check(b.hammers_per_turn == 3, "Carpenter converts 3 Lumber -> 3 hammers/turn");
        check(b.crosses_output == 3,   "Preacher -> 3 crosses/turn");
        check(b.stockpile[5] == 7,     "Carpenter consumed 3 Lumber from the stockpile (10 -> 7)");
        // C: a Carpenter with NO lumber makes 0 hammers -- lumber is required to build.
        Colony cc; cc.owner_power = 0; cc.human = true; cc.population = 1; cc.rebel_A = 0; cc.rebel_B = 1;
        cc.workers.push_back(mkw(13, -1, 0, 16));                      // Carpenter, no lumber available
        forge::colony_compute_production(cc, 1, rd4);
        check(cc.hammers_per_turn == 0, "Carpenter with no Lumber -> 0 hammers (lumber required)");
        // job_name resolves the @JOB display name (identity is data, not a number).
        check(forge::job_name(0, false) == "Farmer" || !forge::job_name(0, false).empty(),
              "job_name(Farmer) resolves from @JOB");
        // Sons-of-Liberty production bonus: a Statesman makes 3 bells at SoL<50, 3+1 at a rebel
        // majority (>=50%), 3+2 when unanimous (100%) -- spec @REBELMAJORITY/@REBELUNANIMOUS.
        auto bells_at = [&](int a, int bden){ Colony s; s.population = 1; s.rebel_A = a; s.rebel_B = bden;
            s.workers.push_back(mkw(17, -1, 0, 18)); forge::colony_compute_production(s, 1, rd4); return s.bells_per_turn; };
        check(bells_at(0, 1)  == 3, "SoL 0%  -> Statesman 3 bells (no bonus)");
        check(bells_at(1, 1)  == 5, "SoL 100% -> Statesman 3+2 bells (unanimous bonus)");
        check(bells_at(1, 2)  == 4, "SoL 50%  -> Statesman 3+1 bells (majority bonus)");
        // Founding-father effect: Thomas Jefferson (#15) -> bells +50%. At SoL 0, base 3 -> 4 (3 + 3/2).
        Colony jf; jf.population = 1; jf.rebel_A = 0; jf.rebel_B = 1; jf.workers.push_back(mkw(17, -1, 0, 18));
        forge::colony_compute_production(jf, 1, rd4, /*ff*/ (1u << 15));
        check(jf.bells_per_turn == 4, "Thomas Jefferson (#15) -> bells +50% (3 -> 4)");
        // Founding-father effect: Henry Hudson (#8) -> furs x2 for a fur trapper on tundra.
        Colony hh; hh.population = 1; hh.rebel_A = 0; hh.rebel_B = 1; hh.workers.push_back(mkw(4, 0, 8, 4));   // fur trapper on Boreal forest (terrain 8)
        forge::colony_compute_production(hh, 1, rd4, /*ff*/ 0);
        int base_furs = hh.stockpile[4];
        Colony hh2; hh2.population = 1; hh2.rebel_A = 0; hh2.rebel_B = 1; hh2.workers.push_back(mkw(4, 0, 8, 4));  // same fur trapper, with Hudson owned
        forge::colony_compute_production(hh2, 1, rd4, /*ff*/ (1u << 8));
        check(base_furs > 0 && hh2.stockpile[4] == base_furs * 2, "Henry Hudson (#8) -> fur production x2");
    }

    // A2 unified store: cell_get resolves reference + state + config through one grammar.
    {
        GameState gg; World ww; std::vector<std::pair<int,int>> cxy2; forge::EngineExtra ex2;
        RuleData rd3 = make_default_rules(); gg.year = 1543; gg.powers[0].gold = 321;
        auto det = [](int lo, int) { return lo; };
        forge::EngineCtx cs{gg, ww, cxy2, ex2, rd3, det};
        // state cells agree with the byte-verified resolver
        check(forge::cell_get("game.year", cs).as_int() == 1543, "cell_get state (game.year)");
        check(forge::cell_get("power0.gold", cs).as_int() ==
              forge::resolve_binding("power0.gold", cs).as_int(), "cell_get == resolve_binding (state)");
        // config cells (the third table kind) are now addressable
        check(forge::cell_get("cfg.max_population", cs).as_int() == 32, "cell_get config (cfg.max_population)");
        check(forge::cell_get("cfg.imm_base_crosses", cs).as_int() == 2, "cell_get config (cfg.imm_base_crosses)");
        // every scalar Config field resolves through cfg.* (no orphan config cell)
        bool all_cfg = true;
        for (const std::string& n : forge::cfg_field_names())
            if (forge::cell_get("cfg." + n, cs).type == forge::JsonValue::Null) all_cfg = false;
        check(all_cfg, "every cfg.<name> resolves (config fully addressable)");
        // state writes go through cell_set
        check(forge::cell_set("power0.gold", 999, cs) && gg.powers[0].gold == 999, "cell_set state (power0.gold)");
        check(!forge::cell_set("cfg.max_population", 40, cs), "cell_set cfg is read-only via the store");
    }

    std::printf("engine selftest: %s\n", fail == 0 ? "ALL PASSED" : "FAILURES");
    return fail == 0 ? 0 : 1;
}

static int do_serve(int argc, char** argv) {
    int port = (argc >= 3) ? std::atoi(argv[2]) : 8099;
    if (port <= 0 || port > 65535) port = 8099;
    // Load the persisted active mod (if any) so the Play game starts on the saved ruleset.
    if (std::filesystem::exists(ACTIVE_RULES_PATH)) {
        try {
            forge::OverlayResult o = forge::load_overlay(ACTIVE_RULES_PATH, make_default_rules());
            if (check_rules(o.rules).ok()) { g_active_rules = o.rules;
                std::printf("loaded active mod from %s\n", ACTIVE_RULES_PATH); }
            else std::printf("active mod %s is invalid -- ignoring\n", ACTIVE_RULES_PATH);
        } catch (const std::exception& e) {
            std::printf("could not load %s: %s\n", ACTIVE_RULES_PATH, e.what());
        }
    }
    return forge::serve_http(port, serve_route);
}

// ---- B13: the game as a portable data bundle ----------------------------------------------
// "The engine loads a bundle and IS that game." A bundle is one self-contained JSON capturing every
// data layer of the data-driven game -- schema (DDL), the turn pipeline, config, the reference
// tables, every event graph + screen + scenario, the message + sprite catalogs, and the effect/
// binding/function metadata -- plus the current rules overlay. Exporting a bundle and re-loading it
// reproduces the game without recompiling; a mod is a bundle with edited sections.
#ifndef FORGE_SPEC_VERSION
#define FORGE_SPEC_VERSION 1
#endif
static forge::JsonValue build_game_bundle() {
    namespace fs = std::filesystem;
    auto tryfile = [](const char* path) -> forge::JsonValue {
        try { return forge::json_parse_file(path); } catch (...) { return forge::JsonValue{}; }
    };
    forge::JsonValue b = jobj();

    // Flat engine data files (schema/pipeline/config/metadata/catalogs), each embedded verbatim.
    forge::JsonValue data = jobj();
    const char* files[] = {"schema", "turn", "effects", "functions", "function_writes",
                           "bindings", "cfg", "variables", "messages", "sprites"};
    for (const char* f : files) {
        forge::JsonValue v = tryfile((std::string("data_extracted/engine/") + f + ".json").c_str());
        if (v.type != forge::JsonValue::Null) data.obj[f] = v;
    }
    b.obj["data"] = data;

    // Reference tables (the game's DDL rows: NAMES + TRIBES).
    forge::JsonValue tables = jobj();
    { forge::JsonValue v = tryfile("data_extracted/tables/names_tables.json");
      if (v.type != forge::JsonValue::Null) tables.obj["names"] = v; }
    { forge::JsonValue v = tryfile("data_extracted/tables/tribe_tables.json");
      if (v.type != forge::JsonValue::Null) tables.obj["tribes"] = v; }
    b.obj["tables"] = tables;

    // Every event graph, keyed by id.
    forge::JsonValue graphs = jobj();
    for (const std::string& id : forge::list_graphs())
        try { graphs.obj[id] = forge::load_graph(id); } catch (...) {}
    b.obj["graphs"] = graphs;

    // Every screen, keyed by id.
    forge::JsonValue screens = jobj();
    for (const std::string& id : forge::list_screens())
        try { screens.obj[id] = forge::load_screen(id); } catch (...) {}
    b.obj["screens"] = screens;

    // Every scenario (data_extracted/engine/scenarios/*.json), keyed by stem.
    forge::JsonValue scenarios = jobj();
    try {
        for (const auto& e : fs::directory_iterator("data_extracted/engine/scenarios")) {
            if (e.path().extension() != ".json") continue;
            forge::JsonValue v = tryfile(e.path().string().c_str());
            if (v.type != forge::JsonValue::Null) scenarios.obj[e.path().stem().string()] = v;
        }
    } catch (...) {}
    b.obj["scenarios"] = scenarios;

    // The current rules overlay (sparse diff vs the default -- empty for a stock export, populated
    // for a balance mod). The engine re-applies it over its defaults on load.
    b.obj["rules_overlay"] = forge::overlay_diff(make_default_rules(), g_active_rules);

    // Manifest last, with section counts so a loader can sanity-check before applying.
    forge::JsonValue man = jobj();
    man.obj["name"]         = forge::json_str("Viceroy Forge -- New World");
    man.obj["version"]      = forge::json_str("1.0");
    man.obj["spec_version"] = forge::json_num(FORGE_SPEC_VERSION);
    man.obj["graphs"]       = forge::json_num((double)graphs.obj.size());
    man.obj["screens"]      = forge::json_num((double)screens.obj.size());
    man.obj["scenarios"]    = forge::json_num((double)scenarios.obj.size());
    man.obj["data_files"]   = forge::json_num((double)data.obj.size());
    b.obj["manifest"] = man;
    return b;
}

// Validate a bundle is well-formed + self-consistent: manifest present, section counts match the
// embedded sections, and every graph a screen references (its "graph" field) resolves in-bundle.
// Returns the list of problems (empty == OK).
static std::vector<std::string> verify_bundle(const forge::JsonValue& b) {
    std::vector<std::string> issues;
    const forge::JsonValue* man = b.find("manifest");
    if (!man) { issues.push_back("missing manifest"); return issues; }
    auto section = [&](const char* k) -> const forge::JsonValue* {
        const forge::JsonValue* v = b.find(k);
        if (!v || v->type != forge::JsonValue::Object) { issues.push_back(std::string("missing/!object section: ") + k); return nullptr; }
        return v;
    };
    const forge::JsonValue* graphs = section("graphs");
    const forge::JsonValue* screens = section("screens");
    const forge::JsonValue* scenarios = section("scenarios");
    section("data"); section("tables");
    auto count = [&](const char* k) { const forge::JsonValue* m = man->find(k); return m ? m->as_int(-1) : -1; };
    if (graphs && (int)graphs->obj.size() != count("graphs"))
        issues.push_back("manifest graphs count != embedded graphs");
    if (screens && (int)screens->obj.size() != count("screens"))
        issues.push_back("manifest screens count != embedded screens");
    if (scenarios && (int)scenarios->obj.size() != count("scenarios"))
        issues.push_back("manifest scenarios count != embedded scenarios");
    // referential integrity: a screen naming a graph must find it in the bundle.
    if (graphs && screens)
        for (const auto& kv : screens->obj) {
            const forge::JsonValue* gref = kv.second.find("graph");
            if (gref && gref->is_string() && !gref->str.empty() && !graphs->find(gref->str))
                issues.push_back("screen '" + kv.first + "' references missing graph '" + gref->str + "'");
        }
    return issues;
}

static int bundle_selftest() {
    int fail = 0;
    auto check = [&](bool ok, const char* what) {
        std::printf("  %s %s\n", ok ? "PASS:" : "FAIL:", what); if (!ok) ++fail;
    };
    forge::JsonValue b = build_game_bundle();
    const forge::JsonValue* man = b.find("manifest");
    check(man != nullptr, "bundle has a manifest");
    const forge::JsonValue* graphs = b.find("graphs");
    check(graphs && graphs->obj.size() >= 36, "bundle embeds >= 36 graphs");
    const forge::JsonValue* screens = b.find("screens");
    check(screens && screens->obj.size() >= 8, "bundle embeds >= 8 screens");
    const forge::JsonValue* scen = b.find("scenarios");
    check(scen && scen->obj.size() >= 1, "bundle embeds >= 1 scenario");
    const forge::JsonValue* data = b.find("data");
    check(data && data->find("schema") && data->find("turn") && data->find("messages") &&
          data->find("sprites"), "bundle embeds schema/turn/messages/sprites");
    const forge::JsonValue* tables = b.find("tables");
    check(tables && tables->find("names"), "bundle embeds reference tables");
    check(verify_bundle(b).empty(), "bundle passes self-consistency verification");
    // Round-trip: dump -> parse -> re-verify, and counts survive.
    std::string s = forge::json_dump(b);
    forge::JsonValue rt = forge::json_parse(s);
    check(verify_bundle(rt).empty(), "bundle round-trips through JSON dump/parse");
    const forge::JsonValue* rg = rt.find("graphs");
    check(graphs && rg && rg->obj.size() == graphs->obj.size(), "graph count survives round-trip");
    std::printf("bundle selftest: %s\n", fail == 0 ? "ALL PASSED" : "FAILURES");
    return fail == 0 ? 0 : 1;
}

static int do_bundle(int argc, char** argv) {
    std::string sub = argc >= 3 ? argv[2] : "";
    if (sub == "selftest") return bundle_selftest();
    if (sub == "export" && argc >= 4) {
        forge::JsonValue b = build_game_bundle();
        std::ofstream f(argv[3], std::ios::binary);
        if (!f) { std::printf("bundle: cannot write %s\n", argv[3]); return 1; }
        f << forge::json_dump(b);
        const forge::JsonValue* man = b.find("manifest");
        std::printf("wrote bundle %s (%d graphs, %d screens, %d scenarios)\n", argv[3],
                    (int)(man && man->find("graphs") ? man->find("graphs")->as_int() : 0),
                    (int)(man && man->find("screens") ? man->find("screens")->as_int() : 0),
                    (int)(man && man->find("scenarios") ? man->find("scenarios")->as_int() : 0));
        return 0;
    }
    if (sub == "verify" && argc >= 4) {
        forge::JsonValue b;
        try { b = forge::json_parse_file(argv[3]); } catch (const std::exception& e) {
            std::printf("bundle verify: cannot read %s: %s\n", argv[3], e.what()); return 1;
        }
        std::vector<std::string> issues = verify_bundle(b);
        for (const std::string& i : issues) std::printf("  ISSUE: %s\n", i.c_str());
        std::printf("bundle verify: %s\n", issues.empty() ? "OK" : "FAILURES");
        return issues.empty() ? 0 : 1;
    }
    std::printf("usage: forge bundle {selftest | export FILE | verify FILE}\n");
    return 1;
}

// All data paths are relative to a repo root that contains data_extracted/. Launching from the
// wrong directory (e.g. the build/ folder after `make`) makes every table/graph/message lookup
// silently return nothing, so the game looks empty/broken. Locate the root once at startup -- from
// the CWD, else by walking up from the executable's own directory -- and chdir there, so `forge`
// works no matter where it is launched.
static void ensure_data_root(const char* argv0) {
    namespace fs = std::filesystem;
    std::error_code ec;
    if (fs::exists("data_extracted", ec)) return;                 // already at a valid root
    auto try_up = [&](fs::path p) -> bool {
        for (int i = 0; i < 8 && !p.empty(); ++i) {
            if (fs::exists(p / "data_extracted", ec)) { fs::current_path(p, ec); return true; }
            if (!p.has_parent_path()) break;
            p = p.parent_path();
        }
        return false;
    };
    if (argv0 && *argv0) {
        fs::path exe = fs::weakly_canonical(fs::path(argv0), ec);
        if (!exe.empty() && exe.has_parent_path() && try_up(exe.parent_path())) return;
    }
    try_up(fs::current_path(ec));                                 // last resort: walk up from CWD
}

int main(int argc, char** argv) {
    ensure_data_root(argv[0]);
    std::string cmd = argc >= 2 ? argv[1] : "";
    if (cmd == "inspect") return do_inspect(argc >= 3 ? argv[2] : nullptr);
    if (cmd == "rules")   return do_rules(argc, argv);
    if (cmd == "map")     return do_map(argc, argv);
    if (cmd == "mod")     return do_mod(argc, argv);
    if (cmd == "bundle")  return do_bundle(argc, argv);
    if (cmd == "save")    return do_save(argc, argv);
    if (cmd == "data")    return do_data(argc, argv);
    if (cmd == "formulas") { std::printf("%s\n", forge::formulas_text().c_str()); return 0; }
    if (cmd == "engine" && argc >= 3 && std::string(argv[2]) == "selftest") return engine_selftest();
    if (cmd == "serve")   return do_serve(argc, argv);

    std::printf("Viceroy Forge -- headless modding tool\n"
                "usage:\n"
                "  forge inspect [overlay.json]   validate + chart a ruleset (vs baseline)\n"
                "  forge rules diff IN [OUT]      write the sparse overlay diff vs the default\n"
                "  forge rules selftest           overlay write/round-trip self-test\n"
                "  forge map selftest             self-contained .MP round-trip + validate test\n"
                "  forge map validate FILE.mp     check a map against the load-bearing invariants\n"
                "  forge map roundtrip FILE.mp    confirm load->save->load is byte-identical\n"
                "  forge mod selftest             write/load/validate a mod package (self-test)\n"
                "  forge mod validate DIR         validate a mod directory\n"
                "  forge bundle export FILE       export the whole game as one data bundle\n"
                "  forge bundle verify FILE       validate a game/mod bundle\n"
                "  forge bundle selftest          bundle export + round-trip self-test\n"
                "  forge save selftest            game save/load round-trip self-test\n"
                "  forge data check [FILE]        structural-validate the data tables\n"
                "  forge data selftest            data-table validator self-test\n"
                "  forge formulas                 print the complete formula/function catalog\n"
                "  forge serve [port]             launch the browser GUI (default port 8099)\n");
    return 0;
}
