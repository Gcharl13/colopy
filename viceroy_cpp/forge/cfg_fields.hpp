// forge/cfg_fields.hpp -- the ONE list of scalar Config fields, shared by the
// cell() store (cfg_get) and the Drydock CONF bridge (cfg_set_field). Kept in
// step with sim/rules.hpp Config; array fields (gate years) are not listed --
// they are edited via the Rules overlay until Drydock P5 subsumes overlays.
#pragma once

#define CFG_FIELDS(X) \
    X(warehouse_cap_base) X(sol_decay_shift) X(sol_inflow_mult) X(sol_birth_bonus) \
    X(food_growth_threshold) X(max_population) X(rush_gold_per_hammer) X(tory_divisor_base) \
    X(artillery_base_cost) \
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
    X(imm_dock_slots) X(imm_base_crosses) X(imm_refill_addend) \
    X(school_turns_t1) X(school_turns_t2) X(school_turns_t3) X(school_faculty_cap) \
    X(improve_tool_cost) X(clear_lumber_base)
