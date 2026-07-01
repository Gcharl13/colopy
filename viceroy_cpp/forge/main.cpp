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
#include "savegame.hpp"
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
    if (sub.rfind("sprites/", 0) == 0 || sub.rfind("pik/", 0) == 0) fpath = "docs/atlas/" + sub;
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

// Start a new game, seeded from the chosen nation + difficulty and the authored
// scenario (data_extracted/engine/scenarios/new_world.json). The scenario supplies
// the map, calendar, starting gold, colonies and units; nation/difficulty come from
// the new-game screen. Falls back to the classic 2-colony opening if the file is absent.
static void game_new(int nation = 0, int difficulty = 1) {
    g_game = GameState{}; g_world = World{}; g_colony_xy.clear();
    g_engine_extra = forge::EngineExtra{}; g_rng = 0x2BAD1234;

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
    g_game.powers[0].gold = scn("start_gold") ? (long)scn("start_gold")->num : 500;
    // price_base = the internal supply accumulator (DGROUP 0x53EA), random-seeded per good in
    // [600,1000] (func_07561C, BYTE_VERIFIED market.md). It drives the drift; it is NOT the gold
    // price -- the player-facing buy/sell gold per unit comes from @CARGO (price_start1/2, ~1..20).
    for (int i = 0; i < NGOODS; ++i) g_game.price_base[i] = game_rng(600, 1000);
    g_game.ref = ref_start(g_game.difficulty);          // the King starts with an army

    std::vector<std::pair<int,int>> cxy;                // colony coords, indexed as authored
    auto add_colony = [&](int tx, int ty, int pop, int bells, int hammers, int food, int crosses) {
        auto xy = game_find_land(tx, ty);
        Colony c; c.owner_power = 0; c.human = true; c.population = pop;
        c.bells_per_turn = bells; c.hammers_per_turn = hammers;
        c.food_per_turn = food; c.crosses_output = crosses;
        c.rebel_A = 0; c.rebel_B = 1; c.build_target = -1;
        g_world.colonies.push_back(c); g_colony_xy.push_back(xy); cxy.push_back(xy);
        return xy;
    };
    if (const forge::JsonValue* cols = scn("colonies"))
        for (const forge::JsonValue& c : cols->arr) {
            auto gi = [&](const char* k, int d) { const forge::JsonValue* v = c.find(k); return v ? (int)v->num : d; };
            add_colony(gi("x", 20), gi("y", 22), gi("pop", 1), gi("bells", 0),
                       gi("hammers", 0), gi("food", 0), gi("crosses", 0));
        }
    if (g_world.colonies.empty()) { add_colony(20, 22, 3, 3, 4, 60, 2); add_colony(34, 42, 2, 1, 2, 45, 1); }

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
    g_game_active = true;
}

static void game_step() {
    if (g_game_active) step_turn(g_game, g_world, game_rng, 0, g_active_rules);
}

static forge::JsonValue game_state_json() {
    forge::JsonValue o = jobj();
    o.obj["active"] = jbool(g_game_active);
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
        cols.arr.push_back(cj);
    }
    o.obj["colonies"] = cols;
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
        if (path == "/api/functions") {
            try { return J(200, forge::json_parse_file("data_extracted/engine/functions.json")); }
            catch (...) { return err(404, "functions.json not found"); }
        }
        if (path == "/api/sprites") {
            try { return J(200, forge::json_parse_file("data_extracted/engine/sprites.json")); }
            catch (...) { return err(404, "sprites.json not found (run tools/build_sprites.py)"); }
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
        if (path == "/api/bind") {
            if (!g_game_active) game_new();
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            forge::JsonValue o = jobj();
            o.obj["value"] = forge::resolve_binding(qparam(query, "path"), cx);
            return J(200, o);
        }
        if (path == "/api/bind/set" && method == "POST") {
            if (!g_game_active) game_new();
            forge::JsonValue b = forge::json_parse(body);
            const forge::JsonValue* p = b.find("path"); const forge::JsonValue* v = b.find("value");
            if (!p || !v) return err(400, "need {path,value}");
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            forge::JsonValue o = jobj();
            o.obj["ok"] = jbool(forge::set_binding(p->str, v->as_double(), cx));
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

        if (path == "/api/game/new"  && method == "POST") { game_new();  return J(200, game_state_json()); }
        // New game from the setup screen: {nation 0..3, difficulty 0..4} seed the scenario.
        if (path == "/api/game/setup" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int nat  = b.find("nation")     ? b.find("nation")->as_int(0)     : 0;
            int diff = b.find("difficulty") ? b.find("difficulty")->as_int(1) : 1;
            game_new(nat, diff);
            return J(200, game_state_json());
        }
        if (path == "/api/game/step" && method == "POST") { game_step(); return J(200, game_state_json()); }
        if (path == "/api/game/turn" && method == "POST") {
            game_step();                                    // advance the turn
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            forge::JsonValue events = jarr();
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
            c.food_per_turn = 50; c.bells_per_turn = 1; c.hammers_per_turn = 2; c.crosses_output = 1;
            c.rebel_A = 0; c.rebel_B = 1; c.build_target = -1;
            g_world.colonies.push_back(c);
            g_colony_xy.push_back({u.x, u.y});
            u.alive = false;                            // the colonist becomes the colony
            return J(200, game_state_json());
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
            long gold_cost = remaining * 8;                       // RECONSTRUCTED rush curve
            int owner = col.owner_power;
            bool ok = (owner >= 0 && owner < 4) && rush_build(col, g_game.powers[owner], gold_cost);
            forge::JsonValue o = jobj(); o.obj["ok"] = jbool(ok); o.obj["cost"] = forge::json_num((double)gold_cost);
            o.obj["msg"] = forge::json_str(ok ? "Construction complete" : "Not enough gold");
            return J(200, o);
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
        vc::sim::Colony col; col.population = 3; col.rebel_A = 1; col.rebel_B = 1;  // sol=100 -> no tory penalty
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
        vc::sim::Colony col; col.population = 1; col.rebel_A = 1; col.rebel_B = 1;  // sol=100 -> no tory penalty
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
        vc::sim::Colony col; col.population = 1; col.rebel_A = 1; col.rebel_B = 1;  // built_mask = 0 (no buildings)
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
    // into the owner's gold -- but wasted, not sold, once independence is declared.
    {
        g.price_base[9] = 800; g.price_base[10] = 800; g.powers[0].tax = 0; ex.woi_declared = false;
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
        // excess Rum 52 + excess Cigars 80 = 132 units @800, tax 0 -> +105600 gold
        check(g.powers[0].gold - gold_before == 105600,
              "ExportOverflow: excess sold, taxed proceeds credited to gold (+105600)");

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

int main(int argc, char** argv) {
    std::string cmd = argc >= 2 ? argv[1] : "";
    if (cmd == "inspect") return do_inspect(argc >= 3 ? argv[2] : nullptr);
    if (cmd == "rules")   return do_rules(argc, argv);
    if (cmd == "map")     return do_map(argc, argv);
    if (cmd == "mod")     return do_mod(argc, argv);
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
                "  forge save selftest            game save/load round-trip self-test\n"
                "  forge data check [FILE]        structural-validate the data tables\n"
                "  forge data selftest            data-table validator self-test\n"
                "  forge formulas                 print the complete formula/function catalog\n"
                "  forge serve [port]             launch the browser GUI (default port 8099)\n");
    return 0;
}
