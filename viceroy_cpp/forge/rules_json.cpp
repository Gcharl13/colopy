// forge/rules_json.cpp -- see rules_json.hpp.
#include "rules_json.hpp"

#include <array>
#include <cstdlib>
#include <map>
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
    F(food_growth_threshold) F(max_population) F(tory_divisor_base)
    F(expert_era_bonus) F(expert_mfg_mult)
    F(price_drift_shift)
    F(ff_human_scale) F(ff_human_offset) F(ff_ai_scale) F(ff_ai_offset)
    F(ff_post_indep_scale) F(ff_post_indep_offset)
    F(ff_compounding_shift) F(ff_first_father_shift)
    F(ref_regulars_scale) F(ref_regulars_offset) F(ref_cavalry_scale) F(ref_cavalry_offset)
    F(ref_manowar_scale) F(ref_manowar_offset) F(ref_artillery_scale) F(ref_artillery_offset)
    F(ref_accrue_scale) F(ref_accrue_offset) F(ref_unit_cost)
    F(ref_cavalry_ratio) F(ref_artillery_ratio) F(ref_naval_ratio)
    F(imm_threshold_cap) F(imm_sub4k_mult) F(imm_sub4k_offset)
    F(imm_ai_scale) F(imm_ai_divisor) F(imm_england_num) F(imm_england_den)
    F(imm_dock_slots) F(imm_base_crosses)
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
            }
        } else out.warnings.push_back("units is not an object");
    }

    // --- terrain_defense ---
    if (const JsonValue* td = root.find("terrain_defense")) {
        if (td->is_object()) {
            for (const auto& kv : td->obj) {
                char* end = nullptr;
                long id = std::strtol(kv.first.c_str(), &end, 10);
                if (end && *end == '\0' && id >= 0 && id < NTERRAIN)
                    out.rules.terrain_defense[(int)id] = kv.second.as_int(out.rules.terrain_defense[(int)id]);
                else
                    out.warnings.push_back("bad terrain id: " + kv.first);
            }
        } else out.warnings.push_back("terrain_defense is not an object");
    }

    // --- unknown top-level keys ---
    for (const auto& kv : root.obj) {
        const std::string& k = kv.first;
        if (k != "cfg" && k != "units" && k != "terrain_defense")
            out.warnings.push_back("unknown overlay section: " + k);
    }

    return out;
}

OverlayResult load_overlay(const std::string& path, RuleData base) {
    JsonValue root = json_parse_file(path);
    return apply_overlay(root, std::move(base));
}

} // namespace forge
