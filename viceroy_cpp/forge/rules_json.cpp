// forge/rules_json.cpp -- see rules_json.hpp.
#include "rules_json.hpp"

#include <array>
#include <cstdlib>
#include <fstream>
#include <map>
#include <stdexcept>
#include <string>
#include <utility>

using vc::sim::Config;
using vc::sim::RuleData;
using vc::sim::NUNITTYPES;
using vc::sim::NTERRAIN;

namespace forge {
namespace {

// Set one scalar Config field by name. Returns false for an unknown key.
bool set_cfg_scalar(Config& c, const std::string& k, const JsonValue& v) {
#define F(name) if (k == #name) { c.name = v.as_int(c.name); return true; }
    F(warehouse_cap_base) F(sol_decay_shift) F(sol_inflow_mult) F(sol_birth_bonus)
    F(food_growth_threshold) F(max_population) F(rush_gold_per_hammer) F(tory_divisor_base)
    F(expert_era_bonus) F(expert_mfg_mult)
    F(price_drift_shift) F(fortify_def_num) F(fortify_def_den)
    F(ff_human_scale) F(ff_human_offset) F(ff_ai_scale) F(ff_ai_offset)
    F(ff_post_indep_scale) F(ff_post_indep_offset)
    F(ff_compounding_shift) F(ff_first_father_shift)
    F(ref_regulars_scale) F(ref_regulars_offset) F(ref_cavalry_scale) F(ref_cavalry_offset)
    F(ref_manowar_scale) F(ref_manowar_offset) F(ref_artillery_scale) F(ref_artillery_offset)
    F(ref_accrue_scale) F(ref_accrue_offset) F(ref_unit_cost)
    F(ref_cavalry_ratio) F(ref_artillery_ratio) F(ref_naval_ratio)
    F(imm_threshold_cap) F(imm_sub4k_mult) F(imm_sub4k_offset)
    F(imm_ai_scale) F(imm_ai_divisor) F(imm_england_num) F(imm_england_den)
    F(imm_dock_slots) F(imm_base_crosses) F(imm_refill_addend)
    F(school_turns_t1) F(school_turns_t2) F(school_turns_t3) F(school_faculty_cap)
    F(improve_tool_cost) F(clear_lumber_base) F(rumor_count)
#undef F
    return false;
}

template <size_t N>
void fill_int_array(std::array<int, N>& dst, const JsonValue& v) {
    for (size_t i = 0; i < N && i < v.arr.size(); ++i)
        dst[i] = v.arr[i].as_int(dst[i]);
}

// Resolve a unit key (display name or numeric index) -> index, or -1.
int unit_index(const RuleData& rd, const std::string& key) {
    for (int i = 0; i < NUNITTYPES; ++i)
        if (rd.units[i].name && key == rd.units[i].name) return i;
    // numeric fallback
    char* end = nullptr;
    long idx = std::strtol(key.c_str(), &end, 10);
    if (end && *end == '\0' && idx >= 0 && idx < NUNITTYPES) return (int)idx;
    return -1;
}

} // namespace

OverlayResult apply_overlay(const JsonValue& root, RuleData base) {
    OverlayResult out;
    out.rules = std::move(base);
    if (!root.is_object()) {
        out.warnings.push_back("overlay root is not an object; ignored");
        return out;
    }

    // --- cfg ---
    if (const JsonValue* cfg = root.find("cfg")) {
        if (cfg->is_object()) {
            for (const auto& kv : cfg->obj) {
                const std::string& k = kv.first;
                if (k == "ff_gate_years")        { fill_int_array(out.rules.cfg.ff_gate_years, kv.second); continue; }
                if (k == "ref_accrue_gate_years"){ fill_int_array(out.rules.cfg.ref_accrue_gate_years, kv.second); continue; }
                if (!set_cfg_scalar(out.rules.cfg, k, kv.second))
                    out.warnings.push_back("unknown cfg key: " + k);
            }
        } else out.warnings.push_back("cfg is not an object");
    }

    // --- units ---
    if (const JsonValue* units = root.find("units")) {
        if (units->is_object()) {
            for (const auto& kv : units->obj) {
                int idx = unit_index(out.rules, kv.first);
                if (idx < 0) { out.warnings.push_back("unknown unit: " + kv.first); continue; }
                const JsonValue& u = kv.second;
                if (const JsonValue* a = u.find("attack"))     out.rules.units[idx].attack = a->as_int(out.rules.units[idx].attack);
                if (const JsonValue* d = u.find("defense"))    out.rules.units[idx].defense = d->as_int(out.rules.units[idx].defense);
                if (const JsonValue* c = u.find("cargo"))      out.rules.units[idx].cargo = c->as_int(out.rules.units[idx].cargo);
                if (const JsonValue* m = u.find("move_class")) out.rules.units[idx].move_class = m->as_int(out.rules.units[idx].move_class);
                if (const JsonValue* v = u.find("movement"))   out.rules.units[idx].movement = v->as_int(out.rules.units[idx].movement);
            }
        } else out.warnings.push_back("units is not an object");
    }

    // --- terrain_defense / terrain_move (keyed by terrain id) ---
    auto apply_terrain = [&](const char* key, std::array<int, NTERRAIN>& dst) {
        const JsonValue* t = root.find(key);
        if (!t) return;
        if (!t->is_object()) { out.warnings.push_back(std::string(key) + " is not an object"); return; }
        for (const auto& kv : t->obj) {
            char* end = nullptr;
            long id = std::strtol(kv.first.c_str(), &end, 10);
            if (end && *end == '\0' && id >= 0 && id < NTERRAIN)
                dst[(int)id] = kv.second.as_int(dst[(int)id]);
            else
                out.warnings.push_back(std::string(key) + ": bad terrain id: " + kv.first);
        }
    };
    apply_terrain("terrain_defense", out.rules.terrain_defense);
    apply_terrain("terrain_move", out.rules.terrain_move);

    // --- unknown top-level keys ---
    for (const auto& kv : root.obj) {
        const std::string& k = kv.first;
        if (k != "cfg" && k != "units" && k != "terrain_defense" && k != "terrain_move")
            out.warnings.push_back("unknown overlay section: " + k);
    }

    return out;
}

OverlayResult load_overlay(const std::string& path, RuleData base) {
    JsonValue root = json_parse_file(path);
    return apply_overlay(root, std::move(base));
}

// ---- sparse overlay writer (inverse of apply_overlay) ----

JsonValue overlay_diff(const RuleData& base, const RuleData& cur) {
    JsonValue root; root.type = JsonValue::Object;

    // cfg scalars: emit only the ones that changed.
    JsonValue cfg; cfg.type = JsonValue::Object;
    const Config& b = base.cfg; const Config& c = cur.cfg;
#define D(name) if (b.name != c.name) cfg.obj[#name] = json_num(c.name);
    D(warehouse_cap_base) D(sol_decay_shift) D(sol_inflow_mult) D(sol_birth_bonus)
    D(food_growth_threshold) D(max_population) D(rush_gold_per_hammer) D(tory_divisor_base)
    D(expert_era_bonus) D(expert_mfg_mult)
    D(price_drift_shift) D(fortify_def_num) D(fortify_def_den)
    D(ff_human_scale) D(ff_human_offset) D(ff_ai_scale) D(ff_ai_offset)
    D(ff_post_indep_scale) D(ff_post_indep_offset)
    D(ff_compounding_shift) D(ff_first_father_shift)
    D(ref_regulars_scale) D(ref_regulars_offset) D(ref_cavalry_scale) D(ref_cavalry_offset)
    D(ref_manowar_scale) D(ref_manowar_offset) D(ref_artillery_scale) D(ref_artillery_offset)
    D(ref_accrue_scale) D(ref_accrue_offset) D(ref_unit_cost)
    D(ref_cavalry_ratio) D(ref_artillery_ratio) D(ref_naval_ratio)
    D(imm_threshold_cap) D(imm_sub4k_mult) D(imm_sub4k_offset)
    D(imm_ai_scale) D(imm_ai_divisor) D(imm_england_num) D(imm_england_den)
    D(imm_dock_slots) D(imm_base_crosses) D(imm_refill_addend)
    D(school_turns_t1) D(school_turns_t2) D(school_turns_t3) D(school_faculty_cap)
    D(improve_tool_cost) D(clear_lumber_base) D(rumor_count)
#undef D
    auto emit_array = [&](const char* key, const int* bv, const int* cv, size_t n) {
        bool diff = false;
        for (size_t i = 0; i < n; ++i) if (bv[i] != cv[i]) diff = true;
        if (!diff) return;
        JsonValue a; a.type = JsonValue::Array;
        for (size_t i = 0; i < n; ++i) a.arr.push_back(json_num(cv[i]));
        cfg.obj[key] = a;
    };
    emit_array("ff_gate_years", b.ff_gate_years.data(), c.ff_gate_years.data(), b.ff_gate_years.size());
    emit_array("ref_accrue_gate_years", b.ref_accrue_gate_years.data(),
               c.ref_accrue_gate_years.data(), b.ref_accrue_gate_years.size());
    if (!cfg.obj.empty()) root.obj["cfg"] = cfg;

    // units: keyed by name, only changed fields.
    JsonValue units; units.type = JsonValue::Object;
    for (int i = 0; i < NUNITTYPES; ++i) {
        const auto& ub = base.units[i]; const auto& uc = cur.units[i];
        JsonValue u; u.type = JsonValue::Object;
        if (ub.attack     != uc.attack)     u.obj["attack"]     = json_num(uc.attack);
        if (ub.defense    != uc.defense)    u.obj["defense"]    = json_num(uc.defense);
        if (ub.cargo      != uc.cargo)      u.obj["cargo"]      = json_num(uc.cargo);
        if (ub.move_class != uc.move_class) u.obj["move_class"] = json_num(uc.move_class);
        if (ub.movement   != uc.movement)   u.obj["movement"]   = json_num(uc.movement);
        if (!u.obj.empty()) {
            std::string key = (uc.name && uc.name[0]) ? uc.name : std::to_string(i);
            units.obj[key] = u;
        }
    }
    if (!units.obj.empty()) root.obj["units"] = units;

    // terrain_defense / terrain_move: keyed by id, only changed.
    auto emit_terrain = [&](const char* key, const std::array<int, NTERRAIN>& bt,
                            const std::array<int, NTERRAIN>& ct) {
        JsonValue t; t.type = JsonValue::Object;
        for (int id = 0; id < NTERRAIN; ++id)
            if (bt[id] != ct[id]) t.obj[std::to_string(id)] = json_num(ct[id]);
        if (!t.obj.empty()) root.obj[key] = t;
    };
    emit_terrain("terrain_defense", base.terrain_defense, cur.terrain_defense);
    emit_terrain("terrain_move", base.terrain_move, cur.terrain_move);

    return root;
}

// ---- complete overlay writer (every value, unconditional) ----

JsonValue full_overlay(const RuleData& rd) {
    JsonValue root; root.type = JsonValue::Object;

    // cfg: emit EVERY scalar + the two arrays (same field list as overlay_diff,
    // unconditional). apply_overlay(full_overlay(rd), anything) reproduces rd.cfg.
    JsonValue cfg; cfg.type = JsonValue::Object;
    const Config& c = rd.cfg;
#define E(name) cfg.obj[#name] = json_num(c.name);
    E(warehouse_cap_base) E(sol_decay_shift) E(sol_inflow_mult) E(sol_birth_bonus)
    E(food_growth_threshold) E(max_population) E(rush_gold_per_hammer) E(tory_divisor_base)
    E(expert_era_bonus) E(expert_mfg_mult)
    E(price_drift_shift) E(fortify_def_num) E(fortify_def_den)
    E(ff_human_scale) E(ff_human_offset) E(ff_ai_scale) E(ff_ai_offset)
    E(ff_post_indep_scale) E(ff_post_indep_offset)
    E(ff_compounding_shift) E(ff_first_father_shift)
    E(ref_regulars_scale) E(ref_regulars_offset) E(ref_cavalry_scale) E(ref_cavalry_offset)
    E(ref_manowar_scale) E(ref_manowar_offset) E(ref_artillery_scale) E(ref_artillery_offset)
    E(ref_accrue_scale) E(ref_accrue_offset) E(ref_unit_cost)
    E(ref_cavalry_ratio) E(ref_artillery_ratio) E(ref_naval_ratio)
    E(imm_threshold_cap) E(imm_sub4k_mult) E(imm_sub4k_offset)
    E(imm_ai_scale) E(imm_ai_divisor) E(imm_england_num) E(imm_england_den)
    E(imm_dock_slots) E(imm_base_crosses) E(imm_refill_addend)
    E(school_turns_t1) E(school_turns_t2) E(school_turns_t3) E(school_faculty_cap)
    E(improve_tool_cost) E(clear_lumber_base) E(rumor_count)
#undef E
    auto emit_array = [&](const char* key, const int* cv, size_t n) {
        JsonValue a; a.type = JsonValue::Array;
        for (size_t i = 0; i < n; ++i) a.arr.push_back(json_num(cv[i]));
        cfg.obj[key] = a;
    };
    emit_array("ff_gate_years", c.ff_gate_years.data(), c.ff_gate_years.size());
    emit_array("ref_accrue_gate_years", c.ref_accrue_gate_years.data(),
               c.ref_accrue_gate_years.size());
    root.obj["cfg"] = cfg;

    // units: every unit keyed by display name (numeric fallback for the unused
    // slot), all five fields.
    JsonValue units; units.type = JsonValue::Object;
    for (int i = 0; i < NUNITTYPES; ++i) {
        const auto& u = rd.units[i];
        JsonValue uj; uj.type = JsonValue::Object;
        uj.obj["attack"]     = json_num(u.attack);
        uj.obj["defense"]    = json_num(u.defense);
        uj.obj["cargo"]      = json_num(u.cargo);
        uj.obj["move_class"] = json_num(u.move_class);
        uj.obj["movement"]   = json_num(u.movement);
        std::string key = (u.name && u.name[0]) ? u.name : std::to_string(i);
        units.obj[key] = uj;
    }
    root.obj["units"] = units;

    // terrain_defense / terrain_move: every id.
    auto emit_terrain = [&](const char* key, const std::array<int, NTERRAIN>& t) {
        JsonValue tj; tj.type = JsonValue::Object;
        for (int id = 0; id < NTERRAIN; ++id)
            tj.obj[std::to_string(id)] = json_num(t[id]);
        root.obj[key] = tj;
    };
    emit_terrain("terrain_defense", rd.terrain_defense);
    emit_terrain("terrain_move", rd.terrain_move);

    return root;
}

void save_overlay(const std::string& path, const RuleData& base, const RuleData& cur) {
    std::ofstream f(path, std::ios::binary);
    if (!f) throw std::runtime_error("rules_json: cannot write " + path);
    f << json_dump(overlay_diff(base, cur));
    if (!f) throw std::runtime_error("rules_json: write failed for " + path);
}

} // namespace forge
