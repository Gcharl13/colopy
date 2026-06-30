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
#include "formulas.hpp"
#include "httpd.hpp"
#include "inspect.hpp"
#include "json.hpp"
#include "mapedit.hpp"
#include "mod.hpp"
#include "rules.hpp"
#include "rules_invariants.hpp"
#include "rules_json.hpp"
#include "savegame.hpp"
#include "types.hpp"
#include "unit_turn.hpp"
#include "web_ui.hpp"

#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iterator>
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
    GameState g; g.difficulty = 2;
    g.price_base[SUGAR] = 800; g.powers[0].trade[SUGAR] = 100;
    g.powers[0].gold = 1234;
    World w; w.map_w = 20; w.map_h = 12;
    w.terrain.assign((size_t)w.map_w * w.map_h, (uint8_t)2);   // Plains
    Colony c; c.owner_power = 0; c.population = 3; c.hammers_per_turn = 10;
    c.build_target = 0; c.build_cost = 64; c.food_per_turn = 60; c.crosses_output = 3;
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
    check(lg.g.powers[0].gold == 1234, "power gold preserved");
    check(lg.w.colonies.size() == 1 && lg.w.colonies[0].population == w.colonies[0].population,
          "colony population preserved");
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

        if (path == "/api/formulas")
            return J(200, forge::formulas_catalog());

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

static int do_serve(int argc, char** argv) {
    int port = (argc >= 3) ? std::atoi(argv[2]) : 8099;
    if (port <= 0 || port > 65535) port = 8099;
    return forge::serve_http(port, serve_route);
}

int main(int argc, char** argv) {
    std::string cmd = argc >= 2 ? argv[1] : "";
    if (cmd == "inspect") return do_inspect(argc >= 3 ? argv[2] : nullptr);
    if (cmd == "rules")   return do_rules(argc, argv);
    if (cmd == "map")     return do_map(argc, argv);
    if (cmd == "mod")     return do_mod(argc, argv);
    if (cmd == "save")    return do_save(argc, argv);
    if (cmd == "data")    return do_data(argc, argv);
    if (cmd == "formulas") { std::printf("%s\n", forge::formulas_text().c_str()); return 0; }
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
                "  forge save selftest            game save/load round-trip self-test\n"
                "  forge data check [FILE]        structural-validate the data tables\n"
                "  forge data selftest            data-table validator self-test\n"
                "  forge formulas                 print the complete formula/function catalog\n"
                "  forge serve [port]             launch the browser GUI (default port 8099)\n");
    return 0;
}
