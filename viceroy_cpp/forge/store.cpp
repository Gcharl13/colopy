// forge/store.cpp -- see store.hpp. The unified cell accessor (A2).
#include "store.hpp"

using vc::sim::Config;

namespace forge {
namespace {

// The scalar Config fields, addressable as cfg.<name>. Kept in step with rules.hpp Config
// (the array fields ff_gate_years / ref_accrue_gate_years are edited via the Rules overlay).
#define CFG_FIELDS(X) \
    X(warehouse_cap_base) X(sol_decay_shift) X(sol_inflow_mult) X(sol_birth_bonus) \
    X(food_growth_threshold) X(food_growth_threshold_stable) X(max_population) X(rush_gold_per_hammer) X(tory_divisor_base) \
    X(expert_era_bonus) X(expert_mfg_mult) \
    X(price_drift_shift) X(fortify_def_num) X(fortify_def_den) \
    X(ff_human_scale) X(ff_human_offset) X(ff_ai_scale) X(ff_ai_offset) \
    X(ff_post_indep_scale) X(ff_post_indep_offset) \
    X(ff_compounding_shift) X(ff_first_father_shift) \
    X(ref_regulars_scale) X(ref_regulars_offset) X(ref_cavalry_scale) X(ref_cavalry_offset) \
    X(ref_manowar_scale) X(ref_manowar_offset) X(ref_artillery_scale) X(ref_artillery_offset) \
    X(ref_accrue_scale) X(ref_accrue_offset) X(ref_unit_cost) \
    X(ref_cavalry_ratio) X(ref_artillery_ratio) X(ref_naval_ratio) \
    X(imm_threshold_cap) X(imm_sub4k_mult) X(imm_sub4k_offset) \
    X(imm_ai_scale) X(imm_ai_divisor) X(imm_england_num) X(imm_england_den) \
    X(imm_dock_slots) X(imm_base_crosses)

} // namespace

bool cfg_get(const Config& c, const std::string& name, double& out) {
#define X(f) if (name == #f) { out = (double)c.f; return true; }
    CFG_FIELDS(X)
#undef X
    return false;
}

const std::vector<std::string>& cfg_field_names() {
    static const std::vector<std::string> N = {
#define X(f) #f,
        CFG_FIELDS(X)
#undef X
    };
    return N;
}

JsonValue cell_get(const std::string& path, const EngineCtx& cx) {
    if (path.rfind("cfg.", 0) == 0) {
        double v; if (cfg_get(cx.rd.cfg, path.substr(4), v)) return json_num(v);
        return JsonValue{};
    }
    return resolve_binding(path, cx);   // reference (@...) + state, byte-verified resolver
}

bool cell_set(const std::string& path, double value, EngineCtx& cx) {
    if (path.rfind("cfg.", 0) == 0) return false;   // config is edited via the Rules overlay
    return set_binding(path, value, cx);
}

} // namespace forge
