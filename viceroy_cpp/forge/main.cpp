// forge/main.cpp -- Viceroy Forge: the headless balance inspector (F1 MVP).
//
//   forge inspect [overlay.json]
//
// Loads the default ruleset (optionally with a rules.json mod overlay applied),
// validates it with sim::check_rules(), and prints key balance curves with deltas
// vs the un-modded baseline -- so a designer can see exactly how an edit moves the
// game. It links the headless sim in-process; this is the "balance laboratory."
// The Dear ImGui GUI + editors are the next cycle (F2).
#include "ai.hpp"
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
#include "drydock_bridge.hpp"
#include "drydock_api.hpp"
#include "explore.hpp"
#include "natives.hpp"
#include "store.hpp"
#include "training.hpp"
#include "turnpipe.hpp"
#include "native_powers.hpp"
#include "mapgen.hpp"
#include "types.hpp"
#include "unit_turn.hpp"
#include "web_ui.hpp"
#include "session.hpp"   // the game session (shared with the viceroy app)
#include "desktop.hpp"   // Forge as a desktop application (project + window)

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
    else if (sub == "palette.json") {
        std::string ddp;                       // store-authoritative when loaded
        if (forge::drydock_palette_json(ddp))
            return forge::HttpResponse{200, "application/json", std::move(ddp)};
        fpath = "data_extracted/palette.json";
    }
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
    if (forge::drydock_handles(path))
        return forge::drydock_route(method, path, query, body, &g_active_rules);
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
                // P5: with the store loaded the overlay IMPORTS as record edits
                // (chokepoint-validated, journaled, undoable) and the live rules
                // sync from the store; the file stays as boot-import + export.
                std::string isum;
                if (forge::drydock_import_overlay(forge::json_parse(body), &g_active_rules, isum))
                    root.obj["imported"] = forge::json_str(isum);
                else
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
            // With the store loaded, re-init it from data/ so imported overlay
            // edits vanish too and the rules rebuild from the records.
            g_active_rules = make_default_rules();
            std::error_code ec; std::filesystem::remove(ACTIVE_RULES_PATH, ec);
            if (forge::drydock_active()) {
                std::string smsg;
                forge::drydock_store_init("data", smsg);
                forge::drydock_apply_base(g_active_rules, "data", smsg);
            }
            return J(200, jbool(true));
        }

        if (path == "/api/text") {
            // Real game strings from data_extracted/text/<FILE>_sections.json (default GAME);
            // sections migrated to Drydock TEXT records are overlaid from the store.
            std::string file = qparam(query, "file"); if (file.empty()) file = "GAME";
            for (char c : file) if (!std::isalnum((unsigned char)c) && c != '_') return err(400, "bad file");
            try {
                forge::JsonValue d = forge::json_parse_file("data_extracted/text/" + file + "_sections.json");
                forge::drydock_text_overlay(d, file);
                return J(200, d);
            }
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
        // Byte-cited UI geometry extracted from spec/ui/*.md by tools/extract_layouts.py --
        // screens render from THIS data, not hand-transcribed coordinates.
        if (path == "/api/layout") {
            std::string sc = qparam(query, "screen");
            for (char c : sc) if (!std::isalnum((unsigned char)c) && c != '_') return err(400, "bad screen");
            if (sc.empty()) {                       // list the extracted layouts
                forge::JsonValue a = jarr();
                std::error_code ec;
                for (const auto& e : std::filesystem::directory_iterator("data_extracted/engine/layouts", ec)) {
                    std::string fn = e.path().filename().string();
                    if (fn.size() > 5 && fn.compare(fn.size() - 5, 5, ".json") == 0)
                        a.arr.push_back(forge::json_str(fn.substr(0, fn.size() - 5)));
                }
                return J(200, a);
            }
            try { return J(200, forge::json_parse_file("data_extracted/engine/layouts/" + sc + ".json")); }
            catch (...) { return err(404, "no layout for " + sc + " (run tools/extract_layouts.py)"); }
        }
        if (path == "/api/labels") {
            // ?section=MISC|EUROLABEL|... -> the verbatim LABELS.TXT section lines (index = the
            // line number the specs cite, e.g. @MISC[37] = the Congress title). Screens draw
            // these exact strings -- text is data, never retyped.
            std::string sec = qparam(query, "section"); if (sec.empty()) sec = "MISC";
            forge::JsonValue a = jarr();
            for (const std::string& s : labels_section(sec.c_str())) a.arr.push_back(forge::json_str(s));
            forge::JsonValue o = jobj(); o.obj["section"] = forge::json_str("@" + sec); o.obj["lines"] = a;
            return J(200, o);
        }
        if (path == "/api/functions") {
            try { return J(200, forge::json_parse_file("data_extracted/engine/functions.json")); }
            catch (...) { return err(404, "functions.json not found"); }
        }
        if (path == "/api/sprites") {
            { std::string dds;                 // store-authoritative when loaded
              if (forge::drydock_sprites_json(dds))
                  return forge::HttpResponse{200, "application/json", std::move(dds)}; }
            try { return J(200, forge::json_parse_file("data_extracted/engine/sprites.json")); }
            catch (...) { return err(404, "sprites.json not found (run tools/build_sprites.py)"); }
        }
        // Individual sprites sliced out of the sheets (each identified by label) -> /assets/sliced/...
        if (path == "/api/sprites/sliced") {
            try { return J(200, forge::json_parse_file("data_extracted/sprites/manifest.json")); }
            catch (...) { return err(404, "run tools/slice_sprites.py to cut the sheets into sprites"); }
        }
        if (path == "/api/messages") {
            { std::string ddm;                 // store-authoritative when loaded
              if (forge::drydock_messages_json(ddm))
                  return forge::HttpResponse{200, "application/json", ddm}; }
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

        // T1 ([0x5386]&0x10, the move/land dispatcher func_020F50 @0x20FFB):
        // the opening "our ship is on the high seas" lesson, fired as the new
        // game begins; %STRING0 = the starting ship's @UNIT name.
        auto tutorial_start = [&]() {
            g_tutorial_queue.clear();                    // no popups from a prior game
            for (const Unit& tu : g_world.units)
                if (tu.owner == 0 && tu.alive && unit_stats(tu.type).move_class == 99) {
                    const char* nm = unit_stats(tu.type).name;
                    tutorial_fire(0x0010, "@TUTORIAL1", {nm ? nm : "ship"});
                    break;
                }
        };
        if (path == "/api/game/new"  && method == "POST") {
            game_new(); g_history.clear(); history_snapshot(); tutorial_start();
            return J(200, game_state_json());
        }
        // New game from the setup screen: {nation 0..3, difficulty 0..4} seed the
        // scenario; {random:1, land/landform/temperature/climate 0..2} rolls a
        // random continental map instead (func_064A10 + the Customize enums).
        if (path == "/api/game/setup" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int nat  = b.find("nation")     ? b.find("nation")->as_int(0)     : 0;
            int diff = b.find("difficulty") ? b.find("difficulty")->as_int(1) : 1;
            const bool rnd = b.find("random") && b.find("random")->as_int(0);
            auto p3 = [&](const char* k) { const forge::JsonValue* v = b.find(k);
                int n = v ? v->as_int(1) : 1; return n < 0 ? 0 : n > 2 ? 2 : n; };
            game_new(nat, diff, rnd, p3("land"), p3("landform"),
                     p3("temperature"), p3("climate"));
            g_history.clear(); history_snapshot(); tutorial_start();
            return J(200, game_state_json());
        }
        // @GAME menu options (menus.md): the three verbatim toggle lists +
        // Pick Music. GET reads; POST {list:"game"|"colony"|"sound", bit:N}
        // toggles one row, POST {music:N} records the @PICKMUSIC row.
        if (path == "/api/options" && method != "POST") {
            forge::JsonValue o = jobj();
            o.obj["game"] = forge::json_num(g_engine_extra.game_options);
            o.obj["colony"] = forge::json_num(g_engine_extra.colony_options);
            o.obj["sound"] = forge::json_num(g_engine_extra.sound_options);
            o.obj["music"] = forge::json_num(g_engine_extra.music_pick);
            return J(200, o);
        }
        if (path == "/api/options" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            if (const forge::JsonValue* m = b.find("music")) {
                g_engine_extra.music_pick = m->as_int(-1);
            } else {
                const forge::JsonValue* l = b.find("list"); const forge::JsonValue* bt = b.find("bit");
                if (!l || !bt) return err(400, "need {list,bit} or {music}");
                int bit = bt->as_int(-1);
                if (bit < 0 || bit > 15) return err(400, "bit 0..15");
                if (l->str == "game")        g_engine_extra.game_options   ^= (1u << bit);
                else if (l->str == "colony") g_engine_extra.colony_options ^= (1u << bit);
                else if (l->str == "sound")  g_engine_extra.sound_options  ^= (1u << bit);
                else return err(400, "list is game/colony/sound");
            }
            forge::JsonValue o = jobj();
            o.obj["game"] = forge::json_num(g_engine_extra.game_options);
            o.obj["colony"] = forge::json_num(g_engine_extra.colony_options);
            o.obj["sound"] = forge::json_num(g_engine_extra.sound_options);
            o.obj["music"] = forge::json_num(g_engine_extra.music_pick);
            return J(200, o);
        }
        // @GAME "Retire" (@RETIRE Yes): end the game as a voluntary retirement
        // -- the endgame turns over/won and the client plays the CLOSING pageant.
        if (path == "/api/game/retire" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            g_engine_extra.retired = true;
            return J(200, game_state_json());
        }
        // ---- CHEAT menu backends (MENU @CUP rows) -- forge/debug tools over
        // existing engine features. Rows without a subsystem here (Sound Test,
        // Memory Check, Debug Info Flags, Test Routine, Set Human Player) stay
        // menu-muted rather than faked.
        if (path == "/api/cheat/units") {                // the @UNIT type list for Create Unit
            forge::JsonValue a = jarr();
            for (int t = 0; t < 24; ++t) {
                const char* nm = unit_stats(t).name; if (!nm || !*nm) continue;
                forge::JsonValue e = jobj();
                e.obj["type"] = forge::json_num(t); e.obj["name"] = forge::json_str(nm);
                a.arr.push_back(e);
            }
            return J(200, a);
        }
        if (path == "/api/cheat/unit" && method == "POST") {   // F01 Create Unit
            forge::JsonValue b = forge::json_parse(body);
            int type = b.find("type") ? b.find("type")->as_int(0) : 0;
            int x = b.find("x") ? b.find("x")->as_int(-1) : -1;
            int y = b.find("y") ? b.find("y")->as_int(-1) : -1;
            if (type < 0 || type >= 24) return err(400, "bad @UNIT type");
            if (g_world.terrain_id(x, y) < 0) return err(400, "off the map");
            Unit u; u.type = type; u.owner = 0; u.x = x; u.y = y; u.alive = true;
            g_world.units.push_back(u);
            return J(200, game_state_json());
        }
        if (path == "/api/cheat/reveal" && method == "POST") { // F04 Reveal Map
            for (uint8_t& fb : g_world.fog) fb |= 0x10;        // player-0 seen bit (player+4)
            return J(200, game_state_json());
        }
        if (path == "/api/cheat/kill_indians" && method == "POST") {   // F06 Kill Indians
            g_engine_extra.settlements.clear();
            g_engine_extra.braves.clear();
            return J(200, game_state_json());
        }
        if (path == "/api/cheat/revolution" && method == "POST") {
            // F07 Advance Revolution Status: the per-invocation step is not
            // spec'd -- +10 national SoL clamped to 100 (RECONSTRUCTED).
            g_engine_extra.national_sol = std::min(100, g_engine_extra.national_sol + 10);
            return J(200, game_state_json());
        }
        if (path == "/api/cheat/strategy") {             // F08 Show Strategy: the plan-map
            forge::JsonValue a = jarr();                 // (ai.md 6.1, DS:0x98B0 4x64 slots)
            for (int p = 0; p < 4; ++p)
                for (const auto& s : g_game.plan[p]) {
                    if (s.goal_type == 0xFF) continue;
                    forge::JsonValue e = jobj();
                    e.obj["power"] = forge::json_num(p); e.obj["x"] = forge::json_num(s.x);
                    e.obj["y"] = forge::json_num(s.y); e.obj["goal"] = forge::json_num(s.goal_type);
                    e.obj["priority"] = forge::json_num(s.priority);
                    a.arr.push_back(e);
                }
            forge::JsonValue o = jobj(); o.obj["slots"] = a; return J(200, o);
        }
        if (path == "/api/cheat/sites") {                // F09 Show Colony Sites (ai.md scorer)
            struct Site { int v, x, y; };
            std::vector<Site> scored;
            for (int y = 0; y < g_world.map_h; ++y)
                for (int x = 0; x < g_world.map_w; ++x) {
                    int t = g_world.terrain_id(x, y);
                    if (t < 0 || game_is_water(t)) continue;
                    int v = vc::sim::colony_site_value(g_world, g_active_rules, x, y, g_game.rumor_seed);
                    if (v > 0) scored.push_back({v, x, y});
                }
            std::sort(scored.begin(), scored.end(), [](const Site& a2, const Site& b2){ return a2.v > b2.v; });
            forge::JsonValue a = jarr();
            for (size_t i = 0; i < scored.size() && i < 20; ++i) {
                forge::JsonValue e = jobj();
                e.obj["value"] = forge::json_num(scored[i].v);
                e.obj["x"] = forge::json_num(scored[i].x);
                e.obj["y"] = forge::json_num(scored[i].y);
                a.arr.push_back(e);
            }
            forge::JsonValue o = jobj(); o.obj["sites"] = a; return J(200, o);
        }
        if (path == "/api/tutorial") {                   // drain the pending lessons
            forge::JsonValue o = jobj(), a = jarr();
            for (auto& [k, t] : g_tutorial_queue) {
                forge::JsonValue e = jobj();
                e.obj["key"] = forge::json_str(k); e.obj["text"] = forge::json_str(t);
                a.arr.push_back(e);
            }
            g_tutorial_queue.clear();
            o.obj["steps"] = a;
            return J(200, o);
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
        // The Systems browser's per-turn trace (3.1): advance ONE real turn -- the same
        // stages as game_step(), in the same order -- but phase-by-phase, snapshotting each
        // stage's declared writes (turn.json) so every mechanic's effect on live state shows
        // as before->after cell deltas. Only CHANGED cells are returned.
        if (path == "/api/turn/trace" && method == "POST") {
            if (!g_game_active) game_new();
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            // expand a turn.json shorthand write (colony.X / power.X / market.price_base /
            // unit.X / literal) into concrete cell paths against the live world
            auto expand = [&](const std::string& w, std::vector<std::string>& out) {
                size_t ncol = g_world.colonies.size(); if (ncol > 6) ncol = 6;
                if (w.rfind("colony.", 0) == 0) {
                    std::string rest = w.substr(7);
                    if (rest.find('<') != std::string::npos) return;   // pattern cols (built.<id>)
                    for (size_t i = 0; i < ncol; ++i) out.push_back("colony" + std::to_string(i) + "." + rest);
                } else if (w.rfind("power.", 0) == 0) {
                    out.push_back("power0." + w.substr(6));            // the player power
                } else if (w.rfind("market.price", 0) == 0) {
                    for (int g = 0; g < NGOODS; ++g) out.push_back("price." + std::to_string(g));
                } else if (w.rfind("unit.", 0) == 0) {
                    size_t n = g_world.units.size(); if (n > 8) n = 8;
                    for (size_t i = 0; i < n; ++i) out.push_back("unit" + std::to_string(i) + "." + w.substr(5));
                } else if (w.find('<') == std::string::npos) out.push_back(w);
            };
            auto snap = [&](const std::vector<std::string>& paths) {
                std::vector<std::string> vals; vals.reserve(paths.size());
                for (const std::string& p : paths) vals.push_back(forge::json_dump(forge::cell_get(p, cx)));
                return vals;
            };
            forge::JsonValue stages = jarr();
            auto trace_stage = [&](const std::string& id, const std::string& fn, const std::string& note,
                                   const std::vector<std::string>& watch, const std::function<void()>& run) {
                std::vector<std::string> before = snap(watch);
                run();
                std::vector<std::string> after = snap(watch);
                forge::JsonValue st = jobj();
                st.obj["id"] = forge::json_str(id);
                st.obj["function"] = forge::json_str(fn);
                st.obj["note"] = forge::json_str(note);
                forge::JsonValue ch = jarr();
                for (size_t i = 0; i < watch.size(); ++i) if (before[i] != after[i]) {
                    forge::JsonValue c = jobj();
                    c.obj["path"] = forge::json_str(watch[i]);
                    c.obj["before"] = forge::json_parse(before[i]);
                    c.obj["after"] = forge::json_parse(after[i]);
                    ch.arr.push_back(c);
                }
                st.obj["changes"] = ch;
                stages.arr.push_back(st);
            };
            // pipeline phases with their turn.json declarations
            forge::JsonValue turn_doc; try { turn_doc = forge::json_parse_file("data_extracted/engine/turn.json"); } catch (...) {}
            const forge::JsonValue* phv = turn_doc.find("phases");
            Ref ref_before = g_game.ref; int64_t rm_before = g_game.powers[0].royal_money;
            for (const std::string& id : forge::enabled_turn_phases()) {
                std::string fn = id, note; std::vector<std::string> watch;
                if (phv) for (const forge::JsonValue& p : phv->arr) {
                    const forge::JsonValue* pid = p.find("id");
                    if (!pid || pid->str != id) continue;
                    if (const forge::JsonValue* f = p.find("function")) fn = f->str;
                    if (const forge::JsonValue* n = p.find("note")) note = n->str;
                    if (const forge::JsonValue* ws = p.find("writes"))
                        for (const forge::JsonValue& w : ws->arr) expand(w.str, watch);
                    break;
                }
                trace_stage(id, fn, note, watch, [&]{
                    forge::run_turn_phase(id, g_game, g_world, game_rng, 0, g_active_rules, g_engine_extra.ff_owned);
                });
            }
            // wartime REF freeze -- same rule as game_step: once independence is declared the
            // King's force is committed; the peacetime buildup is reverted.
            if (g_engine_extra.woi_declared) { g_game.ref = ref_before; g_game.powers[0].royal_money = rm_before; }
            // forge-side stages, in game_step order, each with a fixed watch set
            { std::vector<std::string> w = {"power0.gold"};
              for (int g = 0; g < NGOODS; ++g) w.push_back("price." + std::to_string(g));
              trace_stage("auto_export", "auto_export_step",
                          "Custom-House auto-sell of over-cap goods (peacetime).", w,
                          [&]{ auto_export_step(); }); }
            { std::vector<std::string> w = {"congress.bells", "congress.cost", "congress.count", "revolution.sol"};
              trace_stage("congress", "congress_step",
                          "Player liberty bells accrue toward the next founding father.", w, [&]{
                    int bells = 0;
                    for (const Colony& c : g_world.colonies)
                        if (c.owner_power == 0) bells += c.bells_per_turn;
                    congress_step(g_engine_extra, g_game.difficulty, g_game.year, bells, game_rng);
                    if (g_engine_extra.woi_declared)
                        for (const Colony& c : g_world.colonies)
                            if (c.owner_power == 0) g_engine_extra.bells_since_declaration += c.bells_per_turn;
              }); }
            trace_stage("succession", "spanish_succession_step",
                        "War of the Spanish Succession (scripted, self-gated).",
                        {"succession.seceded"}, [&]{ spanish_succession_step(); });
            { std::vector<std::string> w;
              expand("colony.sol", w); expand("colony.population", w);
              trace_stage("tory_uprising", "tory_uprising_step",
                          "During-war internal dissent (self-gated).", w, [&]{ tory_uprising_step(); }); }
            { std::vector<std::string> w = {"ref.regulars", "ref.cavalry", "ref.manowar", "ref.artillery",
                                            "revolution.sol", "revolution.declared"};
              trace_stage("war", "war_resolution_step",
                          "Resolve the War of Independence if declared.", w,
                          [&]{ war_resolution_step(); }); }
            history_snapshot();
            forge::JsonValue o = jobj();
            o.obj["ok"] = jbool(true);
            o.obj["turn"] = forge::json_num((double)g_game.turn);
            o.obj["year"] = forge::json_num(g_game.year);
            o.obj["season"] = forge::json_num(g_game.season);
            o.obj["stages"] = stages;
            return J(200, o);
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
            // Continental-promotion pass (func_03E2EA @0x3E2EA..0x3E440): per
            // colony with SoL >= 50 (@0x03E3F1), budget = max(1,
            // ((SoL-50)*(pop/2))/50) (@0x03E3F6..0x03E425); Veteran (0x15)
            // Soldiers -> Continental Army and Dragoons -> Continental Cavalry
            // stacked on the colony tile, until the budget runs out. No new
            // units are created.
            int promoted = 0;
            for (const Colony& c : g_world.colonies) {
                if (c.owner_power != 0 || !c.human || c.x < 0) continue;
                const int sol = sol_pct(c, g_engine_extra.ff_owned, true);
                if (sol < 50) continue;
                int budget = ((sol - 50) * (c.population / 2)) / 50;
                if (budget < 1) budget = 1;
                for (Unit& u : g_world.units) {
                    if (budget <= 0) break;
                    if (!u.alive || u.owner != 0 || u.x != c.x || u.y != c.y) continue;
                    if (u.profession != 0x15) continue;          // Veterans only
                    if (u.type == vc::sim::SOLDIERS)      { u.type = vc::sim::CONT_ARMY; --budget; ++promoted; }
                    else if (u.type == vc::sim::DRAGOONS) { u.type = vc::sim::CONT_CAV;  --budget; ++promoted; }
                }
            }
            forge::JsonValue o = game_state_json(); o.obj["declared"] = jbool(true);
            o.obj["continentals"] = forge::json_num(promoted);
            return J(200, o);
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
            forge::JsonValue o = jobj();
            o.obj["saved"] = jbool(save_game_to("data_extracted/engine/savegame.json"));
            return J(200, o);
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
        // Player commands shared with the native editor (session.cpp):
        // thin JSON shims over unit_order() / found_colony().
        if (path == "/api/game/order" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            const forge::JsonValue* pu = b.find("unit");
            if (!pu) return err(400, "need {unit}");
            std::string o = b.find("order") ? b.find("order")->str : "";
            int tx = b.find("tx") ? b.find("tx")->as_int(-1) : -1;
            int ty = b.find("ty") ? b.find("ty")->as_int(-1) : -1;
            if (o.empty() && (!b.find("tx") || !b.find("ty")))
                return err(400, "need {unit,tx,ty} or {unit,order}");
            OrderResult r = unit_order(pu->as_int(-1), o, tx, ty,
                                       b.find("route") ? b.find("route")->as_int(-1) : -1,
                                       b.find("hold") ? b.find("hold")->as_int(-1) : -1);
            if (!r.ok) return err(400, r.err);
            return J(200, game_state_json());
        }
        if (path == "/api/game/found" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            const forge::JsonValue* pu = b.find("unit");
            if (!pu) return err(400, "need {unit}");
            std::vector<std::string> acks;
            if (const forge::JsonValue* a = b.find("ack"))
                for (const forge::JsonValue& e : a->arr) acks.push_back(e.str);
            FoundResult fr = found_colony(pu->as_int(-1), acks,
                                          b.find("land") ? b.find("land")->str : "");
            if (!fr.confirm.empty()) {
                forge::JsonValue o = jobj();
                o.obj["confirm"] = forge::json_str(fr.confirm);
                o.obj["text"] = forge::json_str(fr.text);
                if (fr.choices == 3) {
                    o.obj["choices"] = forge::json_num(3);
                    o.obj["price"] = forge::json_num((double)fr.price);
                }
                return J(200, o);
            }
            if (!fr.ok) return err(400, fr.err);
            return J(200, game_state_json());
        }
        // Trade-route editor (trade_routes.md 4): create func_0610B0 (12-route cap
        // @0x610B5 -> @TRADEMANY; name uniqueness @0x611FF), delete func_0612E6.
        if (path == "/api/route/create" && method == "POST") {
            if ((int)g_game.routes.size() >= MAX_TRADE_ROUTES)
                return err(400, "Only 12 trade routes can be defined");   // @TRADEMANY
            forge::JsonValue b = forge::json_parse(body);
            TradeRoute r;
            if (const forge::JsonValue* nm = b.find("name"); nm && nm->is_string())
                r.name = nm->str.substr(0, 31);                           // 32 B name field
            if (r.name.empty()) return err(400, "need {name}");
            for (const TradeRoute& ex : g_game.routes)
                if (ex.name == r.name) return err(400, "route name already in use");
            r.type = b.find("type") ? b.find("type")->as_int(0) : 0;
            if (const forge::JsonValue* sts = b.find("stops"))
                for (const forge::JsonValue& so : sts->arr) {
                    if ((int)r.stops.size() >= MAX_ROUTE_STOPS) break;    // 4-stop cap
                    TradeStop st;
                    st.dest = so.find("dest") ? so.find("dest")->as_int(ROUTE_DEST_NONE)
                                              : ROUTE_DEST_NONE;
                    if (st.dest != ROUTE_DEST_EUROPE && st.dest != ROUTE_DEST_NONE &&
                        (st.dest < 0 || st.dest >= (int)g_world.colonies.size()))
                        return err(400, "bad stop destination");
                    auto lane = [&](const char* key, std::vector<int>& out) {
                        if (const forge::JsonValue* l = so.find(key))
                            for (const forge::JsonValue& v : l->arr) {
                                int gg = v.as_int(-1);
                                if (gg >= 0 && gg < NGOODS &&
                                    (int)out.size() < MAX_LANE_GOODS) out.push_back(gg);
                            }
                    };
                    lane("load", st.load); lane("unload", st.unload);
                    r.stops.push_back(st);
                }
            g_game.routes.push_back(r);
            return J(200, game_state_json());
        }
        if (path == "/api/route/delete" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int ri = b.find("route") ? b.find("route")->as_int(-1) : -1;
            if (ri < 0 || ri >= (int)g_game.routes.size()) return err(400, "bad route");
            g_game.routes.erase(g_game.routes.begin() + ri);
            // Rebind carriers (the EXE shifts records @0x605DB; higher indices slide down).
            for (Unit& u : g_world.units) {
                if (u.route == ri) { u.route = -1; u.route_stop = 0;
                                     if (u.order == ORDER_TRADE_ROUTE) u.order = ORDER_NONE; }
                else if (u.route > ri) --u.route;
            }
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
        // "Live among the Indians" (player command, spec/systems/training.md 3): a colonist
        // unit adjacent to a village asks to learn its skill. The outcome message is the
        // VERBATIM GAME.TXT @LEARN* record; the class/skill rules live in sim/training.cpp.
        // The native-village action menu (context_dialogs.md 6, func_04B308):
        // the 10 verbatim @ACTIONS rows with each row's BYTE-VERIFIED show/enable
        // predicate. Returns {rows:[{id,label,enabled,wired}]} for the unit at
        // the village; the UI runs the enabled rows against their routes.
        if (path == "/api/native/actions") {
            if (!g_game_active) return err(400, "no active game");
            int ui2 = qparam(query, "unit").empty() ? -1 : std::atoi(qparam(query, "unit").c_str());
            int si = qparam(query, "settlement").empty() ? -1 : std::atoi(qparam(query, "settlement").c_str());
            if (ui2 < 0 || ui2 >= (int)g_world.units.size() ||
                si < 0 || si >= (int)g_engine_extra.settlements.size())
                return err(400, "bad unit/settlement");
            const Unit& u = g_world.units[ui2];
            const forge::NativeSettlement& sv = g_engine_extra.settlements[si];
            const auto& acts = labels_section("ACTIONS");
            const int alarm = sv.alarm[u.owner & 3];
            const bool scout = u.type == vc::sim::SCOUTS;
            const bool missionary = u.type == vc::sim::MISSIONARIES;
            const bool ship = u.type >= 0x0D && u.type <= 0x12;
            const int tl = forge::tribe_level(sv.tribe);   // TribeData [+0x5236] proxy: the level
            forge::JsonValue rows = jarr();
            auto row = [&](int id, bool show, bool wired) {
                if (!show) return;
                forge::JsonValue r = jobj();
                r.obj["id"] = forge::json_num(id);
                std::string lbl = id < (int)acts.size() ? acts[id] : "?";
                r.obj["label"] = forge::json_str(lbl);
                r.obj["wired"] = jbool(wired);
                rows.arr.push_back(r);
            };
            row(0, alarm < 0x4B, true);                    // Trade (alarm < 75, @0x4B664)
            row(1, alarm >= 0x4B, true);                   // Enter Hostile (the exclusive twin)
            row(2, missionary && sv.mission < 0, true);    // Establish Mission
            row(3, sv.mission >= 0 && sv.mission != (u.owner & 3), true);    // Denounce Heresy
            row(4, alarm < 128 && tl < 2 && !scout, true); // Live Among (relation >= 0, tribe < 2, not Scout)
            row(5, scout, true);                           // Speak With Chief (type 5)
            row(6, tl != 0, true);                         // Incite (tribe-record != 0)
            row(7, tl != 0 && !ship, true);                // Demand Tribute (also excludes ships)
            row(8, tl > 1, true);                          // Attack Village (tribe-record > 1)
            row(9, true, true);                            // Cancel -- always
            forge::JsonValue o = jobj(); o.obj["rows"] = rows;
            o.obj["settlement"] = forge::json_num(si);
            return J(200, o);
        }

        // Establish a mission (the r2 action): a Missionary at a mission-less
        // village founds one -- the unit is absorbed into the mission; the
        // @MISSION<n> response keys carry the tribe's reception.
        if (path == "/api/native/mission" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            forge::JsonValue b = forge::json_parse(body);
            int ui2 = b.find("unit") ? b.find("unit")->as_int(-1) : -1;
            int si = b.find("settlement") ? b.find("settlement")->as_int(-1) : -1;
            if (ui2 < 0 || ui2 >= (int)g_world.units.size() ||
                si < 0 || si >= (int)g_engine_extra.settlements.size())
                return err(400, "bad unit/settlement");
            Unit& u = g_world.units[ui2];
            forge::NativeSettlement& sv = g_engine_extra.settlements[si];
            if (!u.alive || u.type != vc::sim::MISSIONARIES) return err(400, "needs a Missionary");
            if (sv.mission >= 0) return err(400, "a mission is already present");
            if (std::abs(u.x - sv.x) > 1 || std::abs(u.y - sv.y) > 1) return err(400, "not adjacent");
            sv.mission = u.owner & 3;
            // The expert-mission doubler (natives.md): a Jesuit-trained missionary
            // (class 0x18 expert) marks the mission expert (+5 |= 0x10).
            sv.mission_expert = (u.profession == 0x18);
            u.alive = false;                               // absorbed into the mission
            std::string key = "@MISSION" + std::to_string(game_rng(0, 3));
            forge::JsonValue o = jobj();
            o.obj["ok"] = jbool(true); o.obj["key"] = forge::json_str(key);
            o.obj["msg"] = forge::json_str(game_message_text(key));
            return J(200, o);
        }

        // Demand tribute (r7): attitude-gated -- an amenable village pays from
        // its wealth; a refusal raises tension (the trespass-scale delta).
        // The payment magnitude is RECONSTRUCTED (wealth-bounded roll).
        if (path == "/api/native/tribute" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            forge::JsonValue b = forge::json_parse(body);
            int ui2 = b.find("unit") ? b.find("unit")->as_int(-1) : -1;
            int si = b.find("settlement") ? b.find("settlement")->as_int(-1) : -1;
            if (ui2 < 0 || ui2 >= (int)g_world.units.size() ||
                si < 0 || si >= (int)g_engine_extra.settlements.size())
                return err(400, "bad unit/settlement");
            Unit& u = g_world.units[ui2];
            forge::NativeSettlement& sv = g_engine_extra.settlements[si];
            if (std::abs(u.x - sv.x) > 1 || std::abs(u.y - sv.y) > 1) return err(400, "not adjacent");
            forge::JsonValue o = jobj();
            const int alarm = sv.alarm[u.owner & 3];
            if (alarm < 75 && sv.wealth > 0 && game_rng(1, 4) != 1) {
                long pay = std::min<long>(sv.wealth, game_rng(10, 50));
                sv.wealth -= (int)pay;
                g_game.powers[u.owner & 3].gold += pay;
                o.obj["ok"] = jbool(true); o.obj["gold"] = forge::json_num((double)pay);
            } else {
                forge::tension_apply(sv, u.owner & 3, forge::TENSION_TRESPASS_SEVERE,
                                     power_nation(g_game, u.owner & 3) == 1,
                                     (g_engine_extra.ff_owned >> 16) & 1u);
                o.obj["ok"] = jbool(false); o.obj["gold"] = forge::json_num(0);
            }
            u.moves_left = 0;
            return J(200, o);
        }

        // The remaining village actions share the same (unit, settlement) lookup.
        auto village_pair = [&](const std::string& body_str, Unit** up, forge::NativeSettlement** sp,
                                int* sip) -> bool {
            forge::JsonValue b = forge::json_parse(body_str);
            int ui2 = b.find("unit") ? b.find("unit")->as_int(-1) : -1;
            int si = b.find("settlement") ? b.find("settlement")->as_int(-1) : -1;
            if (ui2 < 0 || ui2 >= (int)g_world.units.size() ||
                si < 0 || si >= (int)g_engine_extra.settlements.size()) return false;
            Unit& u = g_world.units[ui2];
            forge::NativeSettlement& sv = g_engine_extra.settlements[si];
            if (!u.alive || std::abs(u.x - sv.x) > 1 || std::abs(u.y - sv.y) > 1) return false;
            *up = &u; *sp = &sv; if (sip) *sip = si;
            return true;
        };
        auto vfill = [](std::string s, const char* tok, const std::string& v) {
            for (size_t p2; (p2 = s.find(tok)) != std::string::npos; )
                s.replace(p2, std::strlen(tok), v);
            return s;
        };
        auto tribe_name = [&](int tribe) {
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            return forge::resolve_binding("@TRIBES[" + std::to_string(tribe) + "].name", cx).str;
        };

        // Trade With Village (r0): sell the unit's laden cargo holds. The offer
        // percentage is BYTE-VERIFIED (func_05C878 @0x5C976: max(5*diff+50,
        // 2*tax) capped 90); what it multiplies is not decomposed in the trace --
        // RECONSTRUCTED as that percent of the European bid price per unit of
        // good. Success lowers tension by 4 (@0x5C41E) and bumps the village
        // wealth/goodwill bytes (@0x5C3E4; magnitudes not byte-cited -- +1 per
        // hold sold, RECONSTRUCTED).
        if (path == "/api/native/trade" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            Unit* u; forge::NativeSettlement* sv; int si = -1;
            if (!village_pair(body, &u, &sv, &si)) return err(400, "bad unit/settlement");
            const int p = u->owner & 3;
            if (sv->alarm[p] >= 0x4B) return err(400, "the village is hostile (alarm >= 75)");
            const int pct = forge::native_trade_price(g_game.difficulty, g_game.powers[p].tax);
            long total = 0; int holds_sold = 0;
            forge::JsonValue deals = jarr();
            for (int h = 0; h < 6; ++h) {
                if (u->hold_good[h] < 0 || u->hold_qty[h] <= 0) continue;
                const int good = u->hold_good[h], qty = u->hold_qty[h];
                long offer = (long)qty * vc::sim::market_bid(g_game, p, good) * pct / 100;
                forge::JsonValue d = jobj();
                d.obj["good"] = forge::json_num(good);
                d.obj["name"] = forge::json_str(good_display(good));
                d.obj["qty"] = forge::json_num(qty);
                d.obj["gold"] = forge::json_num((double)offer);
                deals.arr.push_back(d);
                total += offer; ++holds_sold;
                u->hold_good[h] = -1; u->hold_qty[h] = 0;
            }
            forge::JsonValue o = jobj();
            if (!holds_sold) { o.obj["ok"] = jbool(false); o.obj["error"] = forge::json_str("no cargo to trade"); return J(200, o); }
            g_game.powers[p].gold += total;
            forge::tension_apply(*sv, p, forge::TENSION_TRADE_GOODWILL,         // -4 (@0x5C41E)
                                 power_nation(g_game, p) == 1,
                                 (g_engine_extra.ff_owned >> 16) & 1u);
            sv->wealth += holds_sold;                                           // goodwill bump (@0x5C3E4)
            u->moves_left = 0;
            o.obj["ok"] = jbool(true);
            o.obj["gold"] = forge::json_num((double)total);
            o.obj["pct"] = forge::json_num(pct);
            o.obj["deals"] = deals;
            return J(200, o);
        }

        // Enter Hostile Village (r1, the alarm >= 75 twin of Trade): the natives
        // will not trade; forcing entry is a moderate trespass (+2, @0x4A319 --
        // the byte-cited middle tier of the village-entry trespass ladder). The
        // response reports the attitude band so the player sees where they stand.
        // No further outcome is specified for this row -- RECONSTRUCTED as the
        // trespass bump alone.
        if (path == "/api/native/hostile" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            Unit* u; forge::NativeSettlement* sv; int si = -1;
            if (!village_pair(body, &u, &sv, &si)) return err(400, "bad unit/settlement");
            const int p = u->owner & 3;
            forge::tension_apply(*sv, p, forge::TENSION_TRESPASS_MODERATE,
                                 power_nation(g_game, p) == 1,
                                 (g_engine_extra.ff_owned >> 16) & 1u);
            u->moves_left = 0;
            forge::JsonValue o = jobj();
            o.obj["ok"] = jbool(true);
            o.obj["alarm"] = forge::json_num(sv->alarm[p]);   // >= 128 = the War state
            o.obj["war"] = jbool(sv->alarm[p] >= 128);
            return J(200, o);
        }

        // Denounce Heresy (r3): a missionary preaches against a rival's mission.
        // Outcome keys @HERESY0 (the converts burn the rival mission and erect
        // ours) / @HERESY1 (the loyal worshipers burn OUR missionary at the
        // stake) -- both verbatim GAME.TXT. The council roll driver is not
        // byte-decomposed -- RECONSTRUCTED by reusing the establish-mission roll
        // (func_0572E6 @0x57316: rng(0,15) < tribe_level+2, doubled for a Jesuit
        // expert -- the Jesuit FF card pins "more effective denouncements").
        if (path == "/api/native/denounce" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            Unit* u; forge::NativeSettlement* sv; int si = -1;
            if (!village_pair(body, &u, &sv, &si)) return err(400, "bad unit/settlement");
            const int p = u->owner & 3;
            if (u->type != vc::sim::MISSIONARIES) return err(400, "needs a Missionary");
            if (sv->mission < 0 || sv->mission == p) return err(400, "no foreign mission here");
            const bool jesuit = u->profession == 0x18;
            const int old_owner = sv->mission;
            const bool won = forge::mission_convert_roll(forge::tribe_level(sv->tribe), jesuit, game_rng);
            forge::JsonValue o = jobj();
            std::string msg = game_message_text(won ? "@HERESY0" : "@HERESY1");
            msg = vfill(msg, "%STRING0", nation_name(p));
            msg = vfill(msg, "%STRING1", nation_name(old_owner));
            msg = vfill(msg, "%STRING2", tribe_name(sv->tribe));
            if (won) {                       // the converts flip the mission to us
                sv->mission = p;
                sv->mission_expert = jesuit;
                u->alive = false;            // absorbed into the new mission (as r2)
            } else {
                u->alive = false;            // burned at the stake (@HERESY1)
            }
            o.obj["ok"] = jbool(won);
            o.obj["key"] = forge::json_str(won ? "@HERESY0" : "@HERESY1");
            o.obj["msg"] = forge::json_str(msg);
            return J(200, o);
        }

        // Ask to Speak With Chief (r5, Scouts): the manual pins the outcomes --
        // the chief tells what the village trades for and teaches (@CHIEFHOWDY),
        // gifts beads (@CHIEFGIFT), tells tales of nearby lands (@CHIEFAREA,
        // a map reveal), or is merely polite (@CHIEFBORED); "there is a chance
        // he will not come out alive... influenced by the mood of the tribe"
        // (@CHIEFKILL). The selection driver is runtime (A-tier) -- RECONSTRUCTED:
        // kill iff rng(0,255) < alarm, else an even pick of the four responses;
        // the bead gift reuses the byte-verified tribute clamp (natives.md 6.3);
        // the tales reveal is an 11x11ish +/-8 square (radius RECONSTRUCTED).
        // European parley (diplomacy.md func_057F4E): the human court meets
        // power 1..3. Eligibility (@0x57B10/@0x57B1A): turn >= 0x28, one
        // side's attitude >= 8, and the 16-turn re-parley cooldown expired.
        // Actions write the byte-verified +0x34/+0x40 matrices; every
        // completed action re-arms the cooldown (@0x58075). The tribute
        // gold->demand-score conversion (1 per 100) and the -2 attitude cost
        // of a paid demand are RECONSTRUCTED.
        // Pending AI reparation demand (@WANTSTUFF): GET reads it (filled text),
        // POST {accept} resolves -- pay (gold transfers, grievance clears) or
        // refuse ("We laugh at your puny threats"): the aggrieved power may
        // declare war through the ai_acts willingness gate (@0x58C24).
        if (path == "/api/diplomacy/demand" && method == "GET") {
            forge::JsonValue o = jobj();
            const int p = g_engine_extra.demand_power;
            o.obj["pending"] = jbool(p >= 0);
            if (p >= 0) {
                o.obj["power"] = forge::json_num(p);
                o.obj["amount"] = forge::json_num((double)g_engine_extra.demand_amount);
                std::string m = game_message_text("@WANTSTUFF");
                forge::EngineCtx dcx{g_game, g_world, g_colony_xy, g_engine_extra,
                                     g_active_rules, game_rng};
                std::string who = forge::resolve_binding(
                    "@COUNTRY[" + std::to_string(p) + "].name", dcx).str;
                size_t p2;
                while ((p2 = m.find("%STRING0")) != std::string::npos) m.replace(p2, 8, who);
                while ((p2 = m.find("%NUMBER0")) != std::string::npos)
                    m.replace(p2, 8, std::to_string(g_engine_extra.demand_amount));
                while ((p2 = m.find("%STRING1")) != std::string::npos) m.replace(p2, 8, "Gold");
                o.obj["text"] = forge::json_str(m);
            }
            return J(200, o);
        }
        if (path == "/api/diplomacy/demand" && method == "POST") {
            const int p = g_engine_extra.demand_power;
            if (p < 0) return err(400, "no pending demand");
            forge::JsonValue b = forge::json_parse(body);
            const bool accept = b.find("accept") && b.find("accept")->b;
            forge::JsonValue o = jobj();
            auto& dp = g_engine_extra.diplo;
            if (accept) {
                long pay = std::min<long>(g_game.powers[0].gold, g_engine_extra.demand_amount);
                g_game.powers[0].gold -= pay;
                g_game.powers[p & 3].gold += pay;
                dp.grievance[p] = 0;                            // reparations settle the score
                o.obj["paid"] = forge::json_num((double)pay);
            } else {
                const int score = (int)(g_engine_extra.demand_amount / 100);
                if (vc::sim::ai_acts(dp.attitude[p], score, game_rng)) {
                    vc::sim::declare_war(dp, p, 0);             // they make good on the threat
                    o.obj["war"] = jbool(true);
                } else o.obj["war"] = jbool(false);
            }
            dp.cooldown[p] = vc::sim::treaty_cooldown(g_game.turn);
            g_engine_extra.demand_power = -1;
            g_engine_extra.demand_amount = 0;
            return J(200, o);
        }
        if (path == "/api/diplomacy/parley" && method == "POST") {
            if (!g_game_active) game_new();
            forge::JsonValue b = forge::json_parse(body);
            int p = b.find("power") ? b.find("power")->as_int(-1) : -1;
            if (p < 1 || p > 3) return err(400, "need {power: 1..3}");
            auto& dp = g_engine_extra.diplo;
            forge::JsonValue o = jobj();
            const bool eligible = g_game.turn >= 0x28 &&
                (dp.attitude[p] >= 8 || dp.attitude[0] >= 8) &&
                g_game.turn >= dp.cooldown[p];
            std::string act = b.find("action") ? b.find("action")->str : "topics";
            if (act != "topics" && !eligible)
                return err(400, "the court will not receive you");
            if (act == "treaty") {
                vc::sim::sign_treaty(dp, 0, p, g_game.turn);
                o.obj["text"] = forge::json_str(game_message_text("@SIGNTREATY"));
            } else if (act == "peace") {
                if (!vc::sim::at_war(dp, 0, p)) return err(400, "not at war");
                vc::sim::make_peace(dp, 0, p);
                dp.cooldown[p] = vc::sim::treaty_cooldown(g_game.turn);
                o.obj["text"] = forge::json_str(game_message_text("@PEACEMANLY"));
            } else if (act == "war") {
                vc::sim::declare_war(dp, 0, p);
                dp.cooldown[p] = vc::sim::treaty_cooldown(g_game.turn);
                o.obj["text"] = forge::json_str(game_message_text("@DECLAREWAR"));
            } else if (act == "tribute") {
                long amount = b.find("amount") ? (long)b.find("amount")->num : 0;
                if (amount <= 0) return err(400, "need {amount}");
                const int score = (int)(amount / 100);
                auto& pw = g_game.powers[p & 3];
                const bool accepted = vc::sim::ai_acts(dp.attitude[p], score, game_rng) &&
                                      pw.gold >= amount;   // affordability (@0x58E1F)
                if (accepted) {
                    pw.gold -= amount; g_game.powers[0].gold += amount;
                    if (dp.attitude[p] >= 2) dp.attitude[p] -= 2;
                }
                dp.cooldown[p] = vc::sim::treaty_cooldown(g_game.turn);
                o.obj["accepted"] = jbool(accepted);
            } else if (act != "topics") return err(400, "unknown action");
            o.obj["eligible"] = jbool(eligible);
            o.obj["at_war"] = jbool(vc::sim::at_war(dp, 0, p));
            o.obj["treaty"] = jbool(vc::sim::has_treaty(dp, 0, p));
            o.obj["attitude"] = forge::json_num(dp.attitude[p]);
            o.obj["grievance"] = forge::json_num(dp.grievance[p]);
            o.obj["cooldown_until"] = forge::json_num(dp.cooldown[p]);
            return J(200, o);
        }
        if (path == "/api/native/chief" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            Unit* u; forge::NativeSettlement* sv; int si = -1;
            if (!village_pair(body, &u, &sv, &si)) return err(400, "bad unit/settlement");
            const int p = u->owner & 3;
            if (u->type != vc::sim::SCOUTS) return err(400, "needs a Scout");
            forge::JsonValue o = jobj();
            std::string key, msg;
            if (game_rng(0, 255) < sv->alarm[p]) {
                key = "@CHIEFKILL";
                msg = vfill(game_message_text(key), "%STRING0", tribe_name(sv->tribe));
                u->alive = false;                           // the scout does not come out
            } else {
                switch (game_rng(0, 3)) {
                case 0: {                                   // what we trade for / teach
                    key = "@CHIEFHOWDY";
                    msg = game_message_text(key);
                    msg = vfill(msg, "%STRING0", forge::job_name(sv->skill, false));
                    msg = vfill(msg, "%STRING1", good_display(sv->wanted));
                    break; }
                case 1: {                                   // beads for the chieftain
                    key = "@CHIEFGIFT";
                    long gift = vc::sim::tribute_gold(game_rng(10, 100), sv->wealth);
                    g_game.powers[p].gold += gift;
                    msg = game_message_text(key);
                    msg = vfill(msg, "%NUMBER0", std::to_string(gift));
                    msg = vfill(msg, "%STRING0", tribe_name(sv->tribe));
                    msg = vfill(msg, "%STRING1", nation_name(p));
                    o.obj["gold"] = forge::json_num((double)gift);
                    break; }
                case 2: {                                   // tales of nearby lands
                    key = "@CHIEFAREA";
                    vc::sim::reveal_around(g_world, sv->x, sv->y, 8, p);
                    msg = game_message_text(key);
                    msg = vfill(msg, "%STRING0", tribe_name(sv->tribe));
                    break; }
                default: {
                    key = "@CHIEFBORED";
                    msg = game_message_text(key);
                    msg = vfill(msg, "%STRING0", tribe_name(sv->tribe));
                    msg = vfill(msg, "%STRING1", nation_name(p));
                    break; }
                }
            }
            u->moves_left = 0;
            o.obj["ok"] = jbool(key != "@CHIEFKILL");
            o.obj["key"] = forge::json_str(key);
            o.obj["msg"] = forge::json_str(msg);
            return J(200, o);
        }

        // Incite Indians (r6): pay the tribe to move against a rival. Deltas are
        // BYTE-VERIFIED: +100 tension toward the target (@0x486F8) with the
        // paired -100 favor shift toward the inciter (@0x04870C). The price
        // formula is forge::incite_price -- RECONSTRUCTED from the manual's
        // three factors (missions in the tribe / their attitude to you / their
        // attitude to the target).
        if (path == "/api/native/incite" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            Unit* u; forge::NativeSettlement* sv; int si = -1;
            if (!village_pair(body, &u, &sv, &si)) return err(400, "bad unit/settlement");
            const int p = u->owner & 3;
            forge::JsonValue b2 = forge::json_parse(body);
            int target = b2.find("target") ? b2.find("target")->as_int(-1) : -1;
            if (target < 0 || target > 3 || target == p) return err(400, "bad target power");
            int missions = 0;
            for (const forge::NativeSettlement& s2 : g_engine_extra.settlements)
                if (s2.tribe == sv->tribe && s2.mission == p) ++missions;
            const long price = forge::incite_price(sv->tension[p], sv->tension[target], missions);
            forge::JsonValue o = jobj();
            o.obj["price"] = forge::json_num((double)price);
            const bool confirm = b2.find("confirm") && b2.find("confirm")->type == forge::JsonValue::Bool
                                 && b2.find("confirm")->b;
            if (!confirm) { o.obj["ok"] = jbool(false); o.obj["quote"] = jbool(true); return J(200, o); }
            if (g_game.powers[p].gold < price) return err(400, "not enough gold");
            g_game.powers[p].gold -= price;
            const bool french = power_nation(g_game, p) == 1;
            const bool poca = (g_engine_extra.ff_owned >> 16) & 1u;
            forge::tension_apply(*sv, target, forge::TENSION_INCITE, false, false);   // +100 (@0x486F8)
            forge::tension_apply(*sv, p, forge::TENSION_PACIFY, french, poca);        // -100 pair (@0x04870C)
            u->moves_left = 0;
            o.obj["ok"] = jbool(true);
            o.obj["target"] = forge::json_str(nation_name(target));
            o.obj["tension_target"] = forge::json_num(sv->tension[target]);
            return J(200, o);
        }

        if (path == "/api/native/learn" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            forge::JsonValue b = forge::json_parse(body);
            int ui = b.find("unit") ? b.find("unit")->as_int(-1) : -1;
            if (ui < 0 || ui >= (int)g_world.units.size()) return err(400, "bad unit");
            Unit& u = g_world.units[ui];
            if (!u.alive || u.owner != 0) return err(400, "not a live player unit");
            if (u.type != vc::sim::COLONISTS) return err(400, "only a colonist can live among the Indians");
            forge::NativeSettlement* vil = nullptr;
            for (auto& s : g_engine_extra.settlements)
                if (std::abs(s.x - u.x) <= 1 && std::abs(s.y - u.y) <= 1) { vil = &s; break; }
            if (!vil) return err(400, "no native village adjacent");
            vc::sim::LearnResult r = vc::sim::native_learn(u.profession, vil->skill, vil->taught,
                                                           g_game.difficulty, game_rng);
            const char* key = r == vc::sim::LearnResult::LEARNED          ? "@LEARNDONE"
                            : r == vc::sim::LearnResult::STAYED           ? "@LEARNSLOW"
                            : r == vc::sim::LearnResult::REFUSED_CRIMINAL ? "@LEARNCRIMINAL"
                            : r == vc::sim::LearnResult::REFUSED_MASTER   ? "@LEARNMASTER"
                                                                          : "@LEARNALREADY";
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            std::string skill_name = forge::job_name(vil->skill, true);
            std::string tribe_name = forge::resolve_binding(
                "@TRIBES[" + std::to_string(vil->tribe) + "].name", cx).str;
            std::string msg = game_message_text(key);
            { size_t p; while ((p = msg.find("{%STRING1}")) != std::string::npos) msg.replace(p, 10, skill_name);
              while ((p = msg.find("{%STRING0}")) != std::string::npos) msg.replace(p, 10, tribe_name); }
            forge::JsonValue o = jobj();
            o.obj["ok"] = jbool(true);
            o.obj["key"] = forge::json_str(key);
            o.obj["msg"] = forge::json_str(msg);
            o.obj["learned"] = jbool(r == vc::sim::LearnResult::LEARNED);
            o.obj["profession"] = forge::json_num(u.profession);
            o.obj["skill_name"] = forge::json_str(skill_name);
            return J(200, o);
        }

        // Treasure cash-in / the King's galleon (events.md, func_05C878): gross =
        // 100 * value-class; post-independence full; else the Crown's cut% = tax
        // with Cortes (FF #10) or max(5*diff+50, 2*tax) <= 90. Returns the
        // @KINGGALLEON record fields so the UI can show cut / gross / net.
        if (path == "/api/treasure/cashin" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            forge::JsonValue b = forge::json_parse(body);
            int ui = b.find("unit") ? b.find("unit")->as_int(-1) : -1;
            const bool cortes = (g_engine_extra.ff_owned >> 10) & 1u;
            vc::sim::CashInResult cr = vc::sim::treasure_cash_in(
                g_game, g_world, ui, g_engine_extra.woi_declared, cortes);
            if (!cr.ok) return err(400, "not a live treasure unit");
            forge::JsonValue o = jobj();
            o.obj["gross"] = forge::json_num((double)cr.gross);
            o.obj["cut_pct"] = forge::json_num(cr.cut_pct);
            o.obj["cut"] = forge::json_num((double)cr.cut);
            o.obj["net"] = forge::json_num((double)cr.net);
            o.obj["key"] = forge::json_str(g_engine_extra.woi_declared ? "@CASHTREASURE"
                                                                       : "@KINGGALLEON");
            std::string m = game_message_text(g_engine_extra.woi_declared ? "@CASHTREASURE"
                                                                          : "@KINGGALLEON");
            for (auto& [tok, val] : std::initializer_list<std::pair<const char*, long>>{
                     {"%NUMBER0", cr.gross}, {"%NUMBER1", (long)cr.cut_pct}, {"%NUMBER2", cr.net}}) {
                size_t p2; std::string t = std::to_string(val);
                while ((p2 = m.find(tok)) != std::string::npos) m.replace(p2, std::strlen(tok), t);
            }
            o.obj["msg"] = forge::json_str(m);
            return J(200, o);
        }

        // Attack a native settlement (CHIEFKILL, natives.md func_04A7CA): the
        // village is razed (treasure gold straight to the treasury, settlement
        // removed, score razed-counter++) or the villagers escape with their
        // wealth; either way the tribe's other villages turn hostile (+100
        // tension toward the attacker -- the incite-scale delta).
        if (path == "/api/native/attack" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            forge::JsonValue b = forge::json_parse(body);
            int ui = b.find("unit") ? b.find("unit")->as_int(-1) : -1;
            int si = b.find("settlement") ? b.find("settlement")->as_int(-1) : -1;
            if (ui < 0 || ui >= (int)g_world.units.size() ||
                si < 0 || si >= (int)g_engine_extra.settlements.size())
                return err(400, "bad unit/settlement");
            Unit& u = g_world.units[ui];
            forge::NativeSettlement& sv = g_engine_extra.settlements[si];
            if (!u.alive || std::abs(u.x - sv.x) > 1 || std::abs(u.y - sv.y) > 1)
                return err(400, "unit not adjacent");
            forge::ChiefKillResult ck = forge::chiefkill(g_game, sv, u.profession, game_rng);
            forge::JsonValue o = jobj();
            o.obj["razed"] = jbool(ck.razed);
            o.obj["gold"] = forge::json_num((double)ck.gold);
            const int tribe = sv.tribe;
            if (ck.razed) {
                g_game.powers[u.owner & 3].gold += ck.gold;    // straight credit (@0x4AB66)
                if (g_game.powers[u.owner & 3].gold > 999999)
                    g_game.powers[u.owner & 3].gold = 999999;
                if (u.owner == 0) g_engine_extra.razed_settlements += 1;
                g_engine_extra.settlements.erase(g_engine_extra.settlements.begin() + si);
            }
            for (auto& other : g_engine_extra.settlements)     // the tribe turns hostile
                if (other.tribe == tribe)
                    forge::tension_apply(other, u.owner & 3, forge::TENSION_INCITE,
                                         power_nation(g_game, u.owner & 3) == 1,
                                         (g_engine_extra.ff_owned >> 16) & 1u);
            u.moves_left = 0;
            return J(200, o);
        }

        // Scout at a foreign colony (exploration.md 3, func_05A20E): the 4-option
        // @SCOUTCOLONY dialog. choice 0 Meet With Mayor (blocked during the WoI,
        // test [0x5382],1 -> @NOMAYORSDURINGREV) / 1 Infiltrate (the random_int(1,36)
        // roll, scout lost on failure) / 2 Attack (the Jan de Witt FF#4 info gate
        // @0x5A469) / 3 Nothing. No choice -> the dialog record itself.
        if (path == "/api/scout/colony" && method == "POST") {
            if (!g_game_active) return err(400, "no active game");
            forge::JsonValue b = forge::json_parse(body);
            int ui = b.find("unit") ? b.find("unit")->as_int(-1) : -1;
            if (ui < 0 || ui >= (int)g_world.units.size()) return err(400, "bad unit");
            Unit& u = g_world.units[ui];
            if (!u.alive || u.owner != 0) return err(400, "not a live player unit");
            if (u.type != vc::sim::SCOUTS) return err(400, "only scouts parley at colonies");
            int ci = -1;
            for (int i = 0; i < (int)g_world.colonies.size(); ++i) {
                const Colony& c = g_world.colonies[i];
                if (c.owner_power != u.owner &&
                    std::abs(c.x - u.x) <= 1 && std::abs(c.y - u.y) <= 1) { ci = i; break; }
            }
            if (ci < 0) return err(400, "no foreign colony adjacent");
            const std::string clabel = "#" + std::to_string(ci + 1);
            auto fill = [](std::string s, const char* tok, const std::string& v) {
                for (size_t p; (p = s.find(tok)) != std::string::npos; )
                    s.replace(p, std::string(tok).size(), v);
                return s;
            };
            // Colony intelligence: FULL (stockpile + works) vs LIMITED (population
            // only). The de Witt gate governs the Attack path's report @0x5A469.
            auto colony_info = [&](bool full) {
                const Colony& c = g_world.colonies[ci];
                forge::JsonValue o = jobj();
                o.obj["colony"] = forge::json_num(ci);
                o.obj["owner"] = forge::json_str(nation_name(c.owner_power));
                o.obj["population"] = forge::json_num(c.population);
                if (full) {
                    forge::JsonValue sp = jarr();
                    for (int gd = 0; gd < NGOODS; ++gd) sp.arr.push_back(forge::json_num(c.stockpile[gd]));
                    o.obj["stockpile"] = sp;
                    int nb = 0; for (int bi = 0; bi < 48; ++bi) nb += (int)((c.built_mask >> bi) & 1u);
                    o.obj["buildings"] = forge::json_num(nb);
                    o.obj["build_target"] = forge::json_num(c.build_target);
                }
                return o;
            };
            forge::JsonValue o = jobj();
            const forge::JsonValue* pc = b.find("choice");
            if (!pc) {                                    // the dialog record, filled
                o.obj["key"] = forge::json_str("@SCOUTCOLONY");
                o.obj["msg"] = forge::json_str(fill(game_message_text("@SCOUTCOLONY"),
                                                    "{%STRING0}", clabel));
                return J(200, o);
            }
            const int choice = pc->as_int(3);
            if (choice == 0) {                            // Meet With Mayor
                if (g_engine_extra.woi_declared) {
                    o.obj["key"] = forge::json_str("@NOMAYORSDURINGREV");
                    o.obj["msg"] = forge::json_str(game_message_text("@NOMAYORSDURINGREV"));
                    return J(200, o);
                }
                o.obj["ok"] = jbool(true);                // parley: a limited briefing
                o.obj["info"] = colony_info(false);       //   (detail RECONSTRUCTED)
                return J(200, o);
            }
            if (choice == 1) {                            // Infiltrate Colony
                const bool ok = vc::sim::scout_infiltrate(g_game, g_world, ui, ci, game_rng);
                o.obj["ok"] = jbool(ok);
                if (ok) { o.obj["info"] = colony_info(true); }
                else {
                    o.obj["key"] = forge::json_str("@LOSTOURSCOUTS");
                    std::string m = game_message_text("@LOSTOURSCOUTS");
                    m = fill(m, "{%STRING0}", nation_name(g_world.colonies[ci].owner_power));
                    m = fill(m, "{%STRING1}", clabel);
                    o.obj["msg"] = forge::json_str(m);
                }
                return J(200, o);
            }
            if (choice == 2) {                            // Attack Colony (func_05A40E)
                const bool de_witt = (g_engine_extra.ff_owned >> 4) & 1u;   // FF #4 gate
                o.obj["ok"] = jbool(true);
                o.obj["info"] = colony_info(de_witt);
                u.order = ORDER_GOTO;                     // close on the colony; combat vs
                u.target_x = g_world.colonies[ci].x;      //   its defenders resolves in the
                u.target_y = g_world.colonies[ci].y;      //   movement loop (assault itself
                return J(200, o);                         //   is not separately modeled)
            }
            o.obj["ok"] = jbool(true);                    // Nothing
            return J(200, o);
        }

        // ---- Europe market (player-command trade): buy/sell goods for gold, recruit/train colonists ----
        // Prices from @CARGO (price_start1 = bid/sell, price_start2 = ask/buy, ~1..20); tax on sales.
        if (path == "/api/europe") {
            if (!g_game_active) game_new();
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            RuleData mrd = live_market_rules(cx);
            // T12 ([0x5387]&0x80, Europe/docks func_02C5D4 @0x2C7BC): the "ship
            // has arrived in %STRING0, waiting for cargo" lesson on first visit.
            tutorial_fire(0x8000, "@TUTORIAL12", {tutorial_home_port()});
            // T17 ([0x5380]&0x20, test @0x35BE3): the European Status Screen
            // lesson -- "%STRING0, %STRING1" = home port, nation.
            if (!(g_engine_extra.tutorial_mask2 & 0x20)) {
                std::string nat = forge::resolve_binding(
                    "@COUNTRY[" + std::to_string(g_game.nation & 3) + "].name", cx).str;
                tutorial_fire2(0x20, "@TUTORIAL17", {tutorial_home_port(), nat});
            }
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
                pj.obj["boycott"] = jbool((g_game.powers[0].boycotts >> gd) & 1u);
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
            if ((g_game.powers[0].boycotts >> gd) & 1u) {
                // The interactive sell handler falls through to the back-tax
                // pay-or-abort dialog (@KISSUP, func_041410 @0x415A6): back_tax =
                // current price x 500 (func_03334E @0x333AF imul 0x1F4).
                const long back_tax = (long)g_game.powers[0].price_level[gd] * 500;
                forge::JsonValue o = jobj();
                o.obj["boycotted"] = jbool(true);
                o.obj["key"] = forge::json_str("@KISSUP");
                std::string m = game_message_text("@KISSUP");
                { size_t p2; while ((p2 = m.find("%STRING0")) != std::string::npos) m.replace(p2, 8, good_display(gd));
                  while ((p2 = m.find("%STRING1")) != std::string::npos) m.replace(p2, 8, "Europe");
                  std::string t = std::to_string(back_tax);
                  while ((p2 = m.find("%NUMBER0")) != std::string::npos) m.replace(p2, 8, t); }
                o.obj["msg"] = forge::json_str(m);
                o.obj["back_tax"] = forge::json_num((double)back_tax);
                return J(200, o);
            }
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
            if (g_game.powers[0].gold < cost) {
                // T18 (emit @0x32764; guard = the buy is UNAFFORDABLE, the `ja`
                // skip @0x32754): "%STRING0 costs %NUMBER0$ per unit and we only
                // have %NUMBER1$ gold". No once-mark in the EXE -- engine latch.
                tutorial_fire_x(2, "@TUTORIAL18",
                    {forge::resolve_binding("@CARGO[" + std::to_string(gd) + "].name", cx).str},
                    {(long)vc::sim::market_ask(g_game, 0, gd, mrd), (long)g_game.powers[0].gold});
                return err(400, "not enough gold");
            }
            vc::sim::market_buy(g_game, 0, gd, qty, mrd);                       // buying drains the volume
            g_world.colonies[ci].stockpile[gd] += qty;
            forge::JsonValue o = jobj(); o.obj["bought"] = forge::json_num(qty); o.obj["gold_spent"] = forge::json_num((double)cost);
            o.obj["ask_now"] = forge::json_num(vc::sim::market_ask(g_game, 0, gd, mrd));
            o.obj["gold"] = forge::json_num((double)g_game.powers[0].gold); return J(200, o);
        }
        // Lift a boycott by paying the back tax (boycotts.md, func_03334E): the
        // payment moves treasury -> the King's REF fund (@0x3340C) and clears the
        // good's bit (@0x33423); unaffordable -> not lifted (@0x333DD).
        if (path == "/api/europe/liftboycott" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int gd = b.find("good") ? b.find("good")->as_int(-1) : -1;
            if (gd < 0 || gd >= NGOODS) return err(400, "need {good 0..15}");
            Power& p = g_game.powers[0];
            if (!((p.boycotts >> gd) & 1u)) return err(400, "not boycotted");
            // Back tax = the good's live PER-UNIT price x 500 (imul 0x1F4
            // @0x333AF), computed on demand -- there is NO per-good accumulator
            // (full scan 2026-07-02; the pricing helper 0x36890 is the same one
            // TUTORIAL18 cites as "costs %NUMBER0$ per unit", i.e. the ask).
            forge::EngineCtx cx2{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            RuleData brd = live_market_rules(cx2);
            const long back_tax = (long)vc::sim::market_ask(g_game, 0, gd, brd) * 500;
            if (p.gold < back_tax) return err(400, "not enough gold for the back taxes");
            p.gold -= back_tax;
            p.royal_money += back_tax;                             // -> the Crown's REF budget
            p.boycotts &= (uint16_t)~(1u << gd);                   // clear the bit (@0x33423)
            forge::JsonValue o = jobj();
            o.obj["lifted"] = jbool(true); o.obj["paid"] = forge::json_num((double)back_tax);
            o.obj["gold"] = forge::json_num((double)p.gold);
            return J(200, o);
        }
        if (path == "/api/europe/recruit" && method == "POST") {
            // Recruit a waiting dock immigrant (immigration.md 3): the cost is
            // the recruit-pool slot cost word (+0x04, read @0x051E52/@0x35114),
            // whose value is the class's @CLASS transport_cost row -- Petty
            // Criminals 300 / Indentured Servants 400 / free colonists priced
            // as Peasant Farmers 600 (the class->row mapping for classless
            // colonists is RECONSTRUCTED). A Fountain-of-Youth grant makes the
            // next recruits free (the +0x49 free queue, @0x52682).
            forge::JsonValue b = forge::json_parse(body);
            int slot = b.find("slot") ? b.find("slot")->as_int(-1) : -1;
            int ci = b.find("colony") ? b.find("colony")->as_int(0) : 0;
            if (slot < 0 || slot >= 3) return err(400, "slot 0..2");
            int cls = g_game.powers[0].dock_pool[slot];
            if (cls < 0) return err(400, "no immigrant waiting in that slot");
            long cost = 0;
            if (g_engine_extra.free_recruits > 0) {
                --g_engine_extra.free_recruits;          // FoY free queue
            } else {
                forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
                const int row = cls == 0x19 ? 0 : cls == 0x1A ? 1 : 2;
                cost = forge::resolve_binding("@CLASS[" + std::to_string(row) + "].transport_cost", cx).as_int();
                if (cost < 0) cost = 0;
                if (g_game.powers[0].gold < cost) return err(400, "not enough gold");
                g_game.powers[0].gold -= cost;
            }
            Unit u; u.owner = 0; u.alive = true;
            if (cls < NUNITTYPES) { u.type = cls; }      // legacy unit-typed slot
            else { u.type = COLONISTS; u.profession = cls; }   // class byte carried (+0x315B)
            if (ci >= 0 && ci < (int)g_colony_xy.size()) { u.x = g_colony_xy[ci].first; u.y = g_colony_xy[ci].second; }
            g_world.units.push_back(u);
            g_game.powers[0].dock_pool[slot] = -1;
            forge::JsonValue o = game_state_json();
            o.obj["recruit_cost"] = forge::json_num((double)cost);
            return J(200, o);
        }
        // Purchase artillery in Europe (the PURCHASE menu): the one recruit type
        // with a count-based cost -- cost = base + artillery_bought*100 (the
        // PowerRecord +0x1E escalation counter, read x100 @0x035124/@0x03527B,
        // inc @0x035282, zeroed at new-game init @0x03662F). The base is the
        // recruit-pool slot cost word, not decomposed in the spec -- the
        // cfg.artillery_base_cost knob (RECONSTRUCTED default 500).
        if (path == "/api/europe/purchase" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int ci = b.find("colony") ? b.find("colony")->as_int(0) : 0;
            long cost = g_active_rules.cfg.artillery_base_cost
                      + (long)g_engine_extra.artillery_bought * 100;
            if (g_game.powers[0].gold < cost) return err(400, "not enough gold");
            g_game.powers[0].gold -= cost;
            ++g_engine_extra.artillery_bought;               // @0x035282
            Unit u; u.type = ARTILLERY; u.owner = 0; u.alive = true;
            if (ci >= 0 && ci < (int)g_colony_xy.size()) { u.x = g_colony_xy[ci].first; u.y = g_colony_xy[ci].second; }
            g_world.units.push_back(u);
            forge::JsonValue o = game_state_json();
            o.obj["purchase_cost"] = forge::json_num((double)cost);
            o.obj["next_cost"] = forge::json_num((double)(g_active_rules.cfg.artillery_base_cost
                                                          + (long)g_engine_extra.artillery_bought * 100));
            return J(200, o);
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
            // T4 ([0x5386]&0x80): the colony-screen jobs lesson, on first open.
            // %STRING0 = the good a colonist produces now, %STRING1 = an alternative.
            if (!(g_engine_extra.tutorial_mask & 0x0080) &&
                ci >= 0 && ci < (int)g_world.colonies.size()) {
                const Colony& c = g_world.colonies[ci];
                for (const auto& wk : c.workers)
                    if (wk.tile >= 0 && wk.good >= 0 && wk.good < NGOODS) {   // a ring-tile worker
                        forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
                        const int cur = wk.good, alt = cur == 5 ? 0 : 5;      // Lumber unless already
                        tutorial_fire(0x0080, "@TUTORIAL4",
                            {forge::resolve_binding("@CARGO[" + std::to_string(cur) + "].name", cx).str,
                             forge::resolve_binding("@CARGO[" + std::to_string(alt) + "].name", cx).str});
                        break;
                    }
            }
            // T16 ([0x5380]&0x10, test @0x286E1): the colony food lesson,
            // also fired from the colony-screen context (no fills).
            tutorial_fire2(0x10, "@TUTORIAL16");
            return J(200, colony_screen_json(ci));
        }
        // Toggle a good's Custom-House auto-sell selection (USER RULING 2026-07-02:
        // selected goods sell everything over 50 each turn). Needs the Custom House built.
        if (path == "/api/colony/export" && method == "POST") {
            forge::JsonValue b = forge::json_parse(body);
            int ci = b.find("colony") ? b.find("colony")->as_int(-1) : -1;
            int gd = b.find("good") ? b.find("good")->as_int(-1) : -1;
            if (ci < 0 || ci >= (int)g_world.colonies.size()) return err(400, "bad colony");
            if (gd < 1 || gd >= NGOODS) return err(400, "good 1..15 (Food feeds growth)");
            Colony& c = g_world.colonies[ci];
            if (!((c.built_mask >> 18) & 1ull)) return err(400, "needs a Custom House");
            c.export_mask ^= (1u << gd);
            forge::JsonValue o = jobj();
            o.obj["ok"] = jbool(true);
            o.obj["selected"] = jbool((c.export_mask >> gd) & 1u);
            o.obj["export_mask"] = forge::json_num(c.export_mask);
            return J(200, o);
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
            forge::colony_compute_production(col, g_game.difficulty, g_active_rules, g_engine_extra.ff_owned,
                                     0, &g_world, g_game.rumor_seed);
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
            forge::colony_compute_production(col, g_game.difficulty, g_active_rules, g_engine_extra.ff_owned,
                                     0, &g_world, g_game.rumor_seed);
            return J(200, colony_detail_json(ci));
        }

        // Start constructing a specific building in a colony (the interactive build menu).
        // {colony, building} -> start_building with cost/min_colony from @BUILDING.
        // The func_0B900 availability predicate (context_dialogs.md 12): within an
        // upgrade family (the @BUILDING `size` column = chain id, constant per
        // family, e.g. 3 = Stockade/Fort/Fortress), the PREVIOUS member must be
        // built (prereq @0xB97D) and a LATER member built supersedes the entry
        // (@0xB956); plus min-colony-size (@0xB940) and already-built. The
        // prereq/supersede chain itself is engine-coded from the family order
        // (func_07464C), not a CSV column.
        if (path == "/api/colony/buildmenu") {
            if (!g_game_active) game_new();
            int ci = qparam(query, "colony").empty() ? 0 : std::atoi(qparam(query, "colony").c_str());
            if (ci < 0 || ci >= (int)g_world.colonies.size()) return err(400, "bad colony");
            const Colony& c = g_world.colonies[ci];
            forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra, g_active_rules, game_rng};
            forge::JsonValue a = jarr();
            for (int i = 0; i < 48; ++i) {
                std::string name = forge::resolve_binding("@BUILDING[" + std::to_string(i) + "].name", cx).str;
                if (name.empty()) break;
                const int fam  = (int)forge::resolve_binding("@BUILDING[" + std::to_string(i) + "].size", cx).as_int();
                const int minc = (int)forge::resolve_binding("@BUILDING[" + std::to_string(i) + "].min_colony", cx).as_int();
                const int cost = (int)forge::resolve_binding("@BUILDING[" + std::to_string(i) + "].cost", cx).as_int();
                if ((c.built_mask >> i) & 1ull) continue;               // already built
                if (i == c.build_target) continue;                      // already in progress
                if (c.population < minc) continue;                      // size gate (@0xB940)
                (void)fam;
                if (building_chain_blocked(c, i, nullptr, nullptr)) continue;   // @0xB97D/@0xB956
                if (building_ff_requirement(i, g_engine_extra.ff_owned)) continue;   // Smith/Stuyvesant gates
                forge::JsonValue e = jobj();
                e.obj["id"] = forge::json_num(i); e.obj["name"] = forge::json_str(name);
                e.obj["cost"] = forge::json_num(cost); e.obj["min_colony"] = forge::json_num(minc);
                a.arr.push_back(e);
            }
            forge::JsonValue o = jobj(); o.obj["buildable"] = a; return J(200, o);
        }
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
            // The func_0B900 chain gate (prereq @0xB97D / supersede @0xB956).
            {
                int blocker = -1; bool super2 = false;
                if (building_chain_blocked(g_world.colonies[ci], bid, &blocker, &super2)) {
                    std::string bn = forge::resolve_binding(
                        "@BUILDING[" + std::to_string(blocker) + "].name", cx).str;
                    forge::JsonValue o = jobj(); o.obj["ok"] = jbool(false);
                    o.obj["msg"] = forge::json_str(name + (super2
                        ? " is superseded by the " + bn + " already built"
                        : " needs its predecessor (" + bn + ") built first"));
                    return J(200, o);
                }
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
            forge::colony_compute_production(col, g_sb_game.difficulty, g_active_rules, g_sb_extra.ff_owned,
                                     0, &g_sb_world, g_sb_game.rumor_seed);
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
            forge::colony_compute_production(col, g_sb_game.difficulty, g_active_rules, g_sb_extra.ff_owned,
                                     0, &g_sb_world, g_sb_game.rumor_seed);
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
            forge::colony_compute_production(g_sb_world.colonies[0], g_sb_game.difficulty, g_active_rules, g_sb_extra.ff_owned,
                                     0, &g_sb_world, g_sb_game.rumor_seed);
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
            if ((g_sb_game.powers[0].boycotts >> gd) & 1u) return err(400, good_display(gd) + " is boycotted in Europe");
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
                forge::colony_compute_production(g_sb_world.colonies[0], g_sb_game.difficulty, g_active_rules, g_sb_extra.ff_owned,
                                     0, &g_sb_world, g_sb_game.rumor_seed);
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
            forge::drydock_repatch_tables();   // the store stays authoritative for migrated sections
            return J(200, jbool(true));
        }

        if (path == "/api/tables/reset" && method == "POST") {
            std::string file = qparam(query, "file"), canon, user;
            if (!table_paths(file, canon, user)) return err(400, "unknown table file: " + file);
            std::error_code ec; std::filesystem::remove(user, ec);
            forge::invalidate_tables();
            forge::drydock_repatch_tables();
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
        // Founding-father effect: Thomas Jefferson (#15) -> bells x2 (@0x55818 --
        // the byte site doubles; the manual's "+50%" diverges). At SoL 0, base 3 -> 6.
        Colony jf; jf.population = 1; jf.rebel_A = 0; jf.rebel_B = 1; jf.workers.push_back(mkw(17, -1, 0, 18));
        forge::colony_compute_production(jf, 1, rd4, /*ff*/ (1u << 15));
        check(jf.bells_per_turn == 6, "Thomas Jefferson (#15) -> bells x2 (3 -> 6, @0x55818)");
        // Thomas Paine (#17): bells += bells * tax% / 100 (@0x290FB). Tax 50% on base 3 -> 4.
        Colony tp; tp.population = 1; tp.rebel_A = 0; tp.rebel_B = 1; tp.workers.push_back(mkw(17, -1, 0, 18));
        forge::colony_compute_production(tp, 1, rd4, /*ff*/ (1u << 17), /*tax*/ 50);
        check(tp.bells_per_turn == 4, "Thomas Paine (#17) -> bells +tax% (3 -> 4 at 50%%)");
        // CHIEFKILL (natives.md func_04A7CA): the escape roll vs alarm and the
        // once-shape of the payout (raze_treasure_gold is separately checked).
        { vc::sim::GameState cg; cg.difficulty = 1;
          forge::NativeSettlement sv; sv.tribe = 0; sv.population = 10; sv.alarm[0] = 50;
          vc::sim::RandFn hi = [](int, int hi2) { return hi2; };   // roll = bound = 100
          forge::ChiefKillResult ck = forge::chiefkill(cg, sv, 0, hi);
          check(ck.razed && ck.gold > 0, "high roll >= alarm: razed with treasure gold");
          vc::sim::RandFn lo = [](int lo2, int) { return lo2; };   // roll = 0
          ck = forge::chiefkill(cg, sv, 0, lo);
          check(!ck.razed && ck.gold == 0, "low roll < alarm: the villagers escape");
          sv.population = 80;                                      // big-treasure branch
          ck = forge::chiefkill(cg, sv, 0, lo);
          check(ck.razed, "size >= 75 takes the big-treasure branch (@0x4A802)");
          check(forge::settlement_attitude(-1, 0) == 0 &&          // 8*-1-5 = -13 -> Content
                forge::settlement_attitude(0, 0)  == 1 &&          // -5 -> Uneasy (band edge)
                forge::settlement_attitude(1, 0)  == 2 &&          // 3 -> Restless
                forge::settlement_attitude(2, 0)  == 3 &&          // 11 -> Angry
                forge::settlement_attitude(0, 128) == 4,           // War = alarm >= 128
                "attitude bands -5/0/10 + War (@0x048AFE/@0x048B62)");
          // Incite price (RECONSTRUCTED, manual-structured): base 100 +4/you -2/target,
          // -100 per own mission in the tribe, floored at 50.
          check(forge::incite_price(0, 0, 0) == 100, "incite: neutral base 100");
          check(forge::incite_price(50, 0, 0) == 300, "incite: they dislike you -> pricier");
          check(forge::incite_price(0, 100, 0) == 50, "incite: they hate the target -> floor 50");
          check(forge::incite_price(0, 0, 1) == 50, "incite: a mission in the tribe -> floor 50");
          // Native land price (func_0464C2, the @INDIANLAND offer): the byte-
          // verified shape, the resource/capital multipliers, the Minuit waiver.
          check(forge::native_land_price(6, 4, false, 1, 2, true, false, false) == 520,
                "land price: human path ((diff+3)*2+level+value-dist)*65/2 = 520");
          check(forge::native_land_price(6, 4, false, 1, 2, true, true, false) == 1040,
                "land price: a prime resource doubles the ask (@0x46576)");
          check(forge::native_land_price(6, 4, true, 1, 2, true, false, false) == 780,
                "land price: capital settlement +50% (@0x465C5)");
          check(forge::native_land_price(6, 4, false, 1, 2, true, false, true) == 0,
                "land price: Peter Minuit -> the land is free (@0x465D5)");
          // Fisherman column (@0x9C2E/@0x9F4F): an ocean tile feeds food only
          // through the Docks; the fisherman yield column supplies the base.
          { RuleData rdf = make_default_rules();
            int base_fish = forge::terrain_good_yield(25, 0);
            Colony fc; fc.population = 1; fc.rebel_A = 0; fc.rebel_B = 1;
            fc.center_terrain = 2; fc.center_food = 0;
            Colony::Worker fw; fw.profession = 11; fw.tile = 0; fw.terrain = 25; fw.good = 0;
            fc.workers.push_back(fw);
            forge::colony_compute_production(fc, 1, rdf);
            int without = fc.food_per_turn;
            fc.built_mask |= (1ull << 6);                      // build the Docks
            forge::colony_compute_production(fc, 1, rdf);
            check(base_fish > 0 && fc.food_per_turn == without + base_fish,
                  "ocean food needs the Docks (@0x9F4F); with them the fisherman column feeds");
          }
        }
        // Founding-father effect: Henry Hudson (#8) -> furs x2 for a fur trapper on tundra.
        Colony hh; hh.population = 1; hh.rebel_A = 0; hh.rebel_B = 1; hh.workers.push_back(mkw(4, 0, 8, 4));   // fur trapper on Boreal forest (terrain 8)
        forge::colony_compute_production(hh, 1, rd4, /*ff*/ 0);
        int base_furs = hh.stockpile[4];
        Colony hh2; hh2.population = 1; hh2.rebel_A = 0; hh2.rebel_B = 1; hh2.workers.push_back(mkw(4, 0, 8, 4));  // same fur trapper, with Hudson owned
        forge::colony_compute_production(hh2, 1, rd4, /*ff*/ (1u << 8));
        check(base_furs > 0 && hh2.stockpile[4] == base_furs * 2, "Henry Hudson (#8) -> fur production x2");

        // Prime-resource yield application (map_system.md "Resource yield application",
        // func_009AAA @0x9AAA applied at func_009B9C): a resource on the worked tile
        // doubles the Prime crops and adds the mapped bonus otherwise (expert doubles it).
        {
            const int SEED = 5;
            auto find_res = [&](World& ww, int want) {          // a tile whose lattice hits `want`
                for (int y2 = 1; y2 < ww.map_h - 1; ++y2)
                    for (int x2 = 1; x2 < ww.map_w - 1; ++x2)
                        if (vc::sim::resource_at(ww, x2, y2, SEED) == want)
                            return std::pair<int,int>{x2, y2};
                return std::pair<int,int>{-1, -1};
            };
            World wt; wt.map_w = 16; wt.map_h = 16;
            wt.terrain.assign(256, 4);                          // all Grassland -> Prime Tobacco (4)
            auto [tx, ty] = find_res(wt, 4);
            check(tx >= 0, "lattice yields a Prime Tobacco tile on a Grassland map");
            int base = forge::terrain_good_yield(4, 2);
            Colony pt; pt.population = 1; pt.rebel_A = 0; pt.rebel_B = 1;
            pt.x = tx + 1; pt.y = ty + 1;                        // ring slot 0 (NW) = the prime tile
            pt.workers.push_back(mkw(2, 0, 4, 2));               // tobacco planter on that tile
            forge::colony_compute_production(pt, 1, rd4, 0, 0, &wt, SEED);
            check(base > 0 && pt.stockpile[2] == base * 2, "Prime Tobacco on the worked tile -> tobacco x2");
            // Minerals + expert ore miner: additive +3, doubled to +6 for the expert (@0x9E04).
            World wm; wm.map_w = 16; wm.map_h = 16;
            wm.terrain.assign(256, 0);                           // all Tundra -> Minerals (6)
            auto [mx, my] = find_res(wm, 6);
            int ore = forge::terrain_good_yield(0, 6);
            Colony om; om.population = 1; om.rebel_A = 0; om.rebel_B = 1;
            om.x = mx + 1; om.y = my + 1;
            om.workers.push_back(mkw(6, 0, 0, 6)); om.workers.back().expert = true;
            forge::colony_compute_production(om, 1, rd4, 0, 0, &wm, SEED);
            check(om.stockpile[6] == ore * 2 + 6, "expert ore miner on Minerals -> base x2 (expert) + 3x2 (bonus doubled)");
            // Mining pressure + the depletion writer: silver on Minerals accrues +2/turn;
            // with the counter primed at 49 and a nonzero roll, the deposit depletes --
            // the bit is set, resource_at reads Depleted (-1 on Minerals), notice queued.
            int pressure = 0;
            Colony sm; sm.population = 1; sm.rebel_A = 0; sm.rebel_B = 1;
            sm.x = mx + 1; sm.y = my + 1;
            sm.workers.push_back(mkw(7, 0, 0, 7));               // silver miner on the Minerals tile
            forge::colony_compute_production(sm, 1, rd4, 0, 0, &wm, SEED, &pressure);
            check(pressure == 2, "silver mined on Minerals -> +2 mining pressure (@0x9E2A)");
            sm.depletion_counter = 49;
            World& gw = wm; GameState gs; gs.difficulty = 1; gs.rumor_seed = SEED;
            gw.colonies.push_back(sm);
            vc::sim::RandFn one = [](int, int) { return 1; };    // every roll lands (nonzero)
            forge::run_turn_phase("production", gs, gw, one, 0, rd4, 0);
            check((gw.improve_at(mx, my) & 0x04) != 0, "depletion roll at counter 50 sets the tile bit (mask 4)");
            check(vc::sim::resource_at(gw, mx, my, SEED) == -1, "depleted Minerals vanish (resource_at -1)");
            check(!forge::depletion_log().empty(), "the depletion event queues the @DEPLETION notice");
            forge::depletion_log().clear();
            // A depleted SILVER deposit renders as Depleted Mine (0), not -1 (@0x616A).
            World ws; ws.map_w = 16; ws.map_h = 16;
            ws.terrain.assign(256, 0xA0);                        // special+0x80 -> Mountains (27) -> Silver Deposit
            auto [sx, sy] = find_res(ws, 12);
            ws.improve_set(sx, sy, 0x04);
            check(vc::sim::resource_at(ws, sx, sy, SEED) == 0, "depleted Silver Deposit -> Depleted Mine (0)");
        }
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
    // Optional release-path pack: `forge serve <port> --pack game.pack` boots the
    // whole store (schema + records) from the drydockc artifact instead of
    // parsing the canonical text (spec 4.1). Explicit only -- a stale pack must
    // never silently shadow fresh .rec edits in a dev tree.
    std::string pack_path;
    for (int i = 3; i + 1 < argc; ++i)
        if (!std::strcmp(argv[i], "--pack")) pack_path = argv[i + 1];
    // Drydock strangler seam: the migrated types (GOOD/UNIT/PROF) load from the
    // canonical text under data/ when present (dev text loading, spec 4.1);
    // values are parity-proven identical to the compiled defaults.
    { std::string dmsg;
      if (forge::drydock_apply_base(g_active_rules, "data", dmsg)) std::printf("%s\n", dmsg.c_str());
      else if (!dmsg.empty()) std::printf("drydock: NOT applied -- %s\n", dmsg.c_str()); }
    { std::string smsg;
      if (forge::drydock_store_init("data", smsg, pack_path)) std::printf("%s\n", smsg.c_str());
      else std::printf("drydock store: NOT loaded -- %s\n", smsg.c_str()); }
    // Load the persisted active mod (if any). With the store loaded it IMPORTS
    // as record edits (P5: the store is the single live rules authority; the
    // overlay file is the boot-time exchange format); otherwise the legacy
    // direct-apply path keeps working.
    if (std::filesystem::exists(ACTIVE_RULES_PATH)) {
        try {
            forge::JsonValue ov = forge::json_parse_file(ACTIVE_RULES_PATH);
            std::string isum;
            if (forge::drydock_import_overlay(ov, &g_active_rules, isum)) {
                std::printf("%s\n", isum.c_str());
            } else {
                forge::OverlayResult o = forge::apply_overlay(ov, make_default_rules());
                if (check_rules(o.rules).ok()) { g_active_rules = o.rules;
                    std::printf("loaded active mod from %s\n", ACTIVE_RULES_PATH); }
                else std::printf("active mod %s is invalid -- ignoring\n", ACTIVE_RULES_PATH);
            }
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

    // Every scenario, keyed by stem (scen records when the store is loaded,
    // else data_extracted/engine/scenarios/*.json).
    forge::JsonValue scenarios = jobj();
    if (const auto ids = forge::drydock_scenario_ids(); !ids.empty()) {
        for (const std::string& id : ids) {
            forge::JsonValue v;
            if (forge::drydock_scenario_json(id, v)) scenarios.obj[id] = v;
        }
    } else try {
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
    if (cmd == "desktop")
        return forge::desktop_main(argc >= 3 ? argv[2] : nullptr, serve_route);
#ifdef _WIN32
    if (cmd.empty())      // double-clicked: run as the desktop application
        return forge::desktop_main(nullptr, serve_route);
#endif

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
                "  forge desktop [PROJECT]        open the desktop editor on a project folder\n"
                "  forge serve [port]             launch the browser GUI (default port 8099)\n");
    return 0;
}
