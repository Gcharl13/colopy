// forge/mod.cpp -- see mod.hpp.
#include "mod.hpp"

#include "json.hpp"
#include "rules_invariants.hpp"
#include "rules_json.hpp"

#include <filesystem>
#include <fstream>
#include <stdexcept>

namespace fs = std::filesystem;

namespace forge {

ModWriteResult write_mod(const std::string& dir, const ModInfo& info,
                         const vc::sim::RuleData& base, const vc::sim::RuleData& cur,
                         const MpFile* map) {
    ModWriteResult res;
    fs::create_directories(dir);

    // modinfo.json
    JsonValue mi; mi.type = JsonValue::Object;
    mi.obj["id"]           = json_str(info.id);
    mi.obj["name"]         = json_str(info.name);
    mi.obj["version"]      = json_str(info.version);
    mi.obj["author"]       = json_str(info.author);
    mi.obj["spec_version"] = json_num(info.spec_version);
    {
        std::string p = (fs::path(dir) / "modinfo.json").string();
        std::ofstream f(p, std::ios::binary);
        if (!f) throw std::runtime_error("mod: cannot write " + p);
        f << json_dump(mi);
        res.written.push_back(p);
    }

    // rules.json (only if there are rule changes)
    JsonValue diff = overlay_diff(base, cur);
    if (!diff.obj.empty()) {
        std::string p = (fs::path(dir) / "rules.json").string();
        save_overlay(p, base, cur);
        res.written.push_back(p);
    }

    // map.mp (optional)
    if (map) {
        std::string p = (fs::path(dir) / "map.mp").string();
        save_mp(p, *map);
        res.written.push_back(p);
    }
    return res;
}

ModReport load_mod(const std::string& dir, vc::sim::RuleData base) {
    ModReport r;
    r.rules = base;

    std::string mi_path = (fs::path(dir) / "modinfo.json").string();
    if (!fs::exists(mi_path)) { r.issues.push_back("missing modinfo.json"); return r; }
    try {
        JsonValue mi = json_parse_file(mi_path);
        auto getstr = [&](const char* k) {
            const JsonValue* v = mi.find(k); return v && v->is_string() ? v->str : std::string();
        };
        r.info.id      = getstr("id");
        r.info.name    = getstr("name");
        r.info.version = getstr("version");
        r.info.author  = getstr("author");
        const JsonValue* sv = mi.find("spec_version");
        r.info.spec_version = sv ? sv->as_int(FORGE_SPEC_VERSION) : FORGE_SPEC_VERSION;
        r.found = true;
    } catch (const std::exception& e) {
        r.issues.push_back(std::string("modinfo.json: ") + e.what());
        return r;
    }
    if (r.info.spec_version != FORGE_SPEC_VERSION)
        r.warnings.push_back("spec_version " + std::to_string(r.info.spec_version) +
                             " != engine " + std::to_string(FORGE_SPEC_VERSION));

    // rules.json -> apply + validate
    std::string rules_path = (fs::path(dir) / "rules.json").string();
    if (fs::exists(rules_path)) {
        r.has_rules = true;
        try {
            OverlayResult o = load_overlay(rules_path, std::move(base));
            r.rules = o.rules;
            for (auto& w : o.warnings) r.warnings.push_back("rules.json: " + w);
            vc::sim::InvariantReport inv = vc::sim::check_rules(r.rules);
            for (auto& v : inv.violations) r.issues.push_back("rules: " + v);
        } catch (const std::exception& e) {
            r.issues.push_back(std::string("rules.json: ") + e.what());
        }
    }

    // map.mp -> load + validate
    std::string map_path = (fs::path(dir) / "map.mp").string();
    if (fs::exists(map_path)) {
        r.has_map = true;
        try {
            MpFile m = load_mp(map_path);
            MapReport mr = validate(m);
            for (auto& i : mr.issues)   r.issues.push_back("map: " + i);
            for (auto& w : mr.warnings) r.warnings.push_back("map: " + w);
        } catch (const std::exception& e) {
            r.issues.push_back(std::string("map.mp: ") + e.what());
        }
    }
    return r;
}

} // namespace forge
