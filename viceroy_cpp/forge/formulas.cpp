// forge/formulas.cpp -- see formulas.hpp. Faithful transcription of sim/*.cpp.
#include "formulas.hpp"

#include <string>
#include <vector>

namespace forge {
namespace {

using J = JsonValue;

J F(const char* fn, const char* title, const char* expr,
    std::vector<const char*> knobs, const char* note) {
    J f; f.type = J::Object;
    f.obj["fn"]    = json_str(fn);
    f.obj["title"] = json_str(title);
    f.obj["expr"]  = json_str(expr);
    J k; k.type = J::Array;
    for (const char* kn : knobs) k.arr.push_back(json_str(kn));
    f.obj["knobs"] = k;
    f.obj["note"]  = json_str(note);
    return f;
}

J SYS(const char* name, const char* source, std::vector<J> fs) {
    J s; s.type = J::Object;
    s.obj["name"]   = json_str(name);
    s.obj["source"] = json_str(source);
    J a; a.type = J::Array;
    for (J& f : fs) a.arr.push_back(f);
    s.obj["formulas"] = a;
    return s;
}

} // namespace

JsonValue formulas_catalog() {
    J root; root.type = J::Object;
    root.obj["note"] = json_str(
        "Every formula the sim computes. The named knobs are cfg values you can "
        "edit on the Rules tab (Load full ruleset). Entries with no knobs are fixed "
        "code logic -- the formula shape, enums, and the demotion/capture ladder are "
        "structural and not data-tunable. Expressions are transcribed from sim/*.cpp.");
    J systems; systems.type = J::Array;

    systems.arr.push_back(SYS(
        "Economy - Sons of Liberty, tax, growth, building", "sim/economy.cpp", {
        F("warehouse_cap", "Warehouse capacity per good",
          "cap = (warehouse_lvl + 1) * warehouse_cap_base",
          {"warehouse_cap_base"},
          "Per-good storage cap; production over the cap spoils."),
        F("sol_pct", "Sons-of-Liberty percentage",
          "sol% = clamp( rebel_A * 100 / rebel_B , 0 .. 100 )   ; 0 when rebel_B <= 0",
          {},
          "Rebel sentiment as a percent of accumulated bell support (A=dividend, B=divisor)."),
        F("sol_update (divisor B)", "SoL membership divisor",
          "B -= B >> sol_decay_shift   (floor 1) ; then  B += sol_inflow_mult * population",
          {"sol_decay_shift", "sol_inflow_mult"},
          "1/64 exponential decay (shift 6) plus a per-colonist inflow each turn."),
        F("sol_update (dividend A)", "SoL bell accumulator",
          "A += bells_this_turn - (A >> sol_decay_shift) ; clamp A to [0, B]",
          {"sol_decay_shift"},
          "Bells raise rebel sentiment; the same 1/64 decay pulls it back down."),
        F("tory_expert_adjust", "Tory penalty + expert bonus on a tile yield",
          "tory = (population*(100-sol%) + 50)/100 ; div = human ? (tory_divisor_base - difficulty) "
          ": tory_divisor_base  (floor 1) ; y -= tory/div ; if expert: era-good y += expert_era_bonus "
          "else y *= expert_mfg_mult ; y = max(y,0)",
          {"tory_divisor_base", "expert_era_bonus", "expert_mfg_mult"},
          "Loyalists (Tories) cut output; experts add a flat era bonus or multiply manufactured goods."),
        F("colony_economic_step (growth)", "Population growth on stored food",
          "warehouse Food += food surplus ; if Food >= food_growth_threshold (200) and "
          "population < max_population: population += 1 ; Food -= threshold ; "
          "rebel_B += sol_birth_bonus",
          {"food_growth_threshold", "max_population", "sol_birth_bonus"},
          "USER RULING + warehousing.md: at 200 stored food a new colonist is born and eats the "
          "200; surplus carries over."),
        F("build_step", "Construction from hammers",
          "accumulate hammers into hammers_accum and build_bank ; when build_cost <= both, "
          "build_bank -= build_cost and the building/unit completes (surplus carried)",
          {},
          "build_cost is per-building/unit data (@BUILDING/@UNIT), not a global knob."),
    }));

    systems.arr.push_back(SYS(
        "Market - European price drift", "sim/market.cpp", {
        F("price_drift", "Per-good price decay from net sales",
          "for each good: acc = price_base + SUM over 4 powers of max(trade,0) ; "
          "price_base -= acc >> price_drift_shift",
          {"price_drift_shift"},
          "Selling pushes a good's price down proportionally (>>8 = /256 each turn); buys (negative) ignored."),
    }));

    systems.arr.push_back(SYS(
        "Combat - land resolution, demotion, capture", "sim/combat.cpp", {
        F("combat_odds", "Probability the attacker wins",
          "P(attacker wins) = atk_str / (atk_str + def_str)   ; 0 when total is 0",
          {},
          "Pure ATK/(ATK+DEF) odds -- the classic Colonization combat model."),
        F("resolve_land (strengths)", "Attack/defense strength build-up",
          "atk = unit.attack (+difficulty_bonus if human attacker) ; "
          "def = unit.defense + terrain_defense + fort_bonus (+difficulty_bonus if human defender) ; "
          "clamp both >= 0 ; if fortified: def = def * fortify_def_num / fortify_def_den",
          {"fortify_def_num", "fortify_def_den", "terrain_defense"},
          "Terrain defense comes from the editable terrain_defense table; fortify adds +50% (3/2)."),
        F("resolve_land (roll)", "The combat die",
          "roll = rng(1, atk_str + def_str) ; attacker_won = (roll <= atk_str)",
          {},
          "A single uniform roll over the combined strength decides the fight."),
        F("demote", "Loser demotion ladder",
          "Soldiers->Colonists ; Dragoons->Soldiers ; Cont.Cavalry->Cont.Army ; Cavalry->Regulars ; "
          "Cont.Army->Colonists ; (Missionary loser of a ->Colonists step becomes Missionaries) ; "
          "anything else -> destroyed",
          {},
          "Fixed structural ladder (unit type ids) -- a code wall, not data."),
        F("is_capturable", "Units that change hands instead of dying",
          "capturable = loser is Colonists, Treasure, or Wagon Train  (taken intact by the winner)",
          {},
          "Fixed structural set -- a code wall, not data."),
    }));

    systems.arr.push_back(SYS(
        "REF / the King - the Royal Expeditionary Force", "sim/ref.cpp", {
        F("ref_start", "Starting REF size by difficulty d",
          "regulars  = ref_regulars_scale*d  + ref_regulars_offset ; "
          "cavalry   = ref_cavalry_scale*d   + ref_cavalry_offset ; "
          "manowar   = ref_manowar_scale*d   + ref_manowar_offset ; "
          "artillery = ref_artillery_scale*d + ref_artillery_offset",
          {"ref_regulars_scale", "ref_regulars_offset", "ref_cavalry_scale", "ref_cavalry_offset",
           "ref_manowar_scale", "ref_manowar_offset", "ref_artillery_scale", "ref_artillery_offset"},
          "The King's army at game start scales with the difficulty level."),
        F("ref_accrue_rate", "Royal treasury growth per turn",
          "rate = ref_accrue_scale*d + ref_accrue_offset ; "
          "then for each gate year in ref_accrue_gate_years with year >= gate: rate *= 2",
          {"ref_accrue_scale", "ref_accrue_offset", "ref_accrue_gate_years"},
          "The King saves faster as the game advances (doubles at each gate year)."),
        F("ref_purchase", "Spending the treasury on new REF units",
          "while royal_money >= ref_unit_cost: "
          "if regulars+2 > ref_cavalry_ratio*cavalry -> +1 cavalry ; "
          "else if regulars > ref_artillery_ratio*artillery -> +1 artillery ; "
          "else if (regulars+cavalry+artillery+5) > ref_naval_ratio*manowar -> +1 man-o-war ; "
          "else +1 regular ; royal_money -= ref_unit_cost",
          {"ref_unit_cost", "ref_cavalry_ratio", "ref_artillery_ratio", "ref_naval_ratio"},
          "Buys to keep target ratios of cavalry/artillery/ships to regulars."),
    }));

    systems.arr.push_back(SYS(
        "Founding Fathers - recruitment cost & availability", "sim/founding_fathers.cpp", {
        F("ff_cost", "Bells (or gold) to recruit the next father",
          "post-independence: cost = difficulty*ff_post_indep_scale + ff_post_indep_offset ; "
          "otherwise base = human ? (difficulty+ff_human_offset)*ff_human_scale "
          ": (ff_ai_offset-difficulty)*ff_ai_scale ; "
          "for each gate in ff_gate_years with year>=gate: cost += cost >> ff_compounding_shift  (x1.5) ; "
          "cost = (ff_count+1)*cost + 1 ; if ff_count==0: cost >>= ff_first_father_shift  (half price)",
          {"ff_post_indep_scale", "ff_post_indep_offset", "ff_human_offset", "ff_human_scale",
           "ff_ai_offset", "ff_ai_scale", "ff_gate_years", "ff_compounding_shift", "ff_first_father_shift"},
          "Each father costs more than the last; later eras compound it; the first is half price."),
        F("ff_era_band", "Era band for father weighting",
          "band = (year < 1600) ? 0 : (year < 1700) ? 1 : 2",
          {},
          "Fixed era cutoffs (code) used to weight which fathers appear."),
        F("ff_available", "Which fathers may be offered",
          "offerable = any father not yet owned  (next pick is a weighted random over all un-owned)",
          {},
          "Byte-verified: no intra-category ordering gate -- simply un-acquired."),
    }));

    systems.arr.push_back(SYS(
        "Immigration - religious unrest & the docks", "sim/immigration.cpp", {
        F("crosses_threshold", "Crosses needed for the next immigrant",
          "a = total_workers + unit_count ; if a < imm_threshold_cap: a = a*imm_sub4k_mult + imm_sub4k_offset ; "
          "cap a at imm_threshold_cap ; if AI: a = a*(imm_ai_scale - difficulty)/imm_ai_divisor ; "
          "if player 0 (England): a = a*imm_england_num/imm_england_den",
          {"imm_threshold_cap", "imm_sub4k_mult", "imm_sub4k_offset", "imm_ai_scale",
           "imm_ai_divisor", "imm_england_num", "imm_england_den"},
          "More colonists raise the bar; England immigrates faster (x2/3)."),
        F("immigration_step", "Spawning an immigrant on the dock",
          "crosses_accum += crosses_gained ; if crosses_accum > threshold: "
          "spawn a Free Colonist at dock slot rng(0, imm_dock_slots-1) ; crosses_accum = 0",
          {"imm_dock_slots"},
          "When accumulated crosses pass the threshold, a recruit appears in a random dock slot."),
    }));

    systems.arr.push_back(SYS(
        "Turn loop - phase order & calendar", "sim/game.cpp, sim/turn.cpp", {
        F("step_turn", "Order of operations each turn",
          "1) production: every colony runs colony_economic_step ; 2) market: price_drift once ; "
          "3) immigration: each of 4 powers, crosses = imm_base_crosses + SUM of its colonies' crosses_output ; "
          "4) REF: human player's royal_money += accrue rate, then ref_purchase ; "
          "5) units: refresh_moves then apply_orders (all owners) ; 6) advance_cadence",
          {"imm_base_crosses"},
          "Fixed phase sequence; only the base-crosses scalar is a knob."),
        F("advance_cadence", "Calendar advance",
          "turn += 1 ; if year < 1600: year += 1  (1 turn = 1 year) ; "
          "else season = (season+1) mod 2, and year += 1 when season wraps to 0  (2 seasons/year)",
          {},
          "Fixed calendar: yearly turns before 1600, two seasons per year after."),
    }));

    systems.arr.push_back(SYS(
        "Units & movement - orders, routing, terrain cost", "sim/unit_turn.cpp", {
        F("refresh_moves", "Move points restored each turn",
          "moves_left = unit.movement   (per unit type)",
          {},
          "Movement allowance is per-unit data (@UNIT movement column)."),
        F("apply_orders (GOTO)", "Executing a move order",
          "greedy step = sign(target - pos) on each axis ; if that tile is off-map or wrong "
          "land/water -> find_step routes around it ; enemy occupant -> combat ; friendly -> blocked ; "
          "entering a tile costs terrain_move[id] (floor 1), but a unit always moves at least one tile",
          {"terrain_move"},
          "Greedy stepping with Dijkstra fallback; entry cost comes from the editable terrain_move table."),
        F("find_step", "Obstacle-routing pathfinder",
          "Dijkstra over passable tiles (passable = naval flag matches Ocean/Sea-Lane), 8-connected, "
          "edge cost = terrain_move[id] ; returns the first step of the least-cost route, or none",
          {"terrain_move"},
          "Routes a unit around coastlines/obstacles toward its target."),
        F("do_combat", "Combat triggered by a move",
          "attacker vs the occupant (defender fortified if its order is FORTIFY) ; loser is captured, "
          "destroyed, or demoted in place ; attacking sets attacker moves_left = 0",
          {},
          "Wraps resolve_land for unit-vs-unit encounters during movement."),
    }));

    systems.arr.push_back(SYS(
        "Natives - missions, tension, trade, tribute", "sim/natives.cpp", {
        F("mission_threshold / converts / prob", "Mission conversion chance",
          "threshold = tribe_level + 2 ; if Jesuit: threshold *= 2 ; "
          "converts when rng(0..15) < threshold ; probability = threshold / 15",
          {},
          "Code-side native formulas (literals; not in the cfg block)."),
        F("apply_tension", "Native tension update",
          "if delta>0: halve if a French power, halve again if Pocahontas ; "
          "tension = clamp(tension + delta, 0 .. 100)",
          {},
          "French diplomacy and the Pocahontas father each soften provocations."),
        F("native_trade_price", "Native trade price percent",
          "p = max(5*difficulty + 50, 2*tax_pct) ; cap p at 90",
          {},
          "Code-side; rises with difficulty and your tax rate, capped at 90%."),
        F("incite_price", "Gold the tribe asks to move against a rival",
          "price = max(50, 100 + 4*tension_toward_you - 2*tension_toward_target - 100*own_missions_in_tribe)",
          {},
          "RECONSTRUCTED from the manual's three factors: your missions in the tribe, "
          "their attitude to you, and their attitude to the target."),
        F("tribute_gold", "Gold a native demand resolves to",
          "hi = min(3*settlement_wealth + 10, 100) ; gold = clamp(demand, 10 .. hi)",
          {},
          "Code-side bounds on a tribute demand."),
    }));

    systems.arr.push_back(SYS(
        "Diplomacy - war/peace/treaty & AI nerve", "sim/diplomacy.cpp", {
        F("declare_war / make_peace / sign_treaty", "Relationship state transitions",
          "war/peace toggle the AT_WAR and WAR relation bits both ways ; sign_treaty sets the "
          "TREATY bit, makes peace, and sets a cooldown = treaty_cooldown(turn)",
          {},
          "Bit-flag relationship bookkeeping between the 4 powers."),
        F("ai_acts", "Whether an AI follows through on a demand",
          "restrained = (attitude >> 2 > demand_score) and (demand_score > 12) and (rng(0,4) != 0) ; "
          "the AI acts = not restrained",
          {},
          "Code-side nerve check: a calm, cautious AI sometimes backs down."),
    }));

    root.obj["systems"] = systems;
    return root;
}

std::string formulas_text() {
    J cat = formulas_catalog();
    std::string out;
    out += cat.obj["note"].str;
    out += "\n";
    for (const J& s : cat.obj["systems"].arr) {
        out += "\n=== " + s.obj.at("name").str + "   [" + s.obj.at("source").str + "] ===\n";
        for (const J& f : s.obj.at("formulas").arr) {
            out += "  " + f.obj.at("title").str + "  (" + f.obj.at("fn").str + ")\n";
            out += "    " + f.obj.at("expr").str + "\n";
            const auto& knobs = f.obj.at("knobs").arr;
            if (knobs.empty()) {
                out += "    knobs: (none - fixed code logic)\n";
            } else {
                out += "    knobs:";
                for (const J& k : knobs) out += " " + k.str;
                out += "\n";
            }
            out += "    " + f.obj.at("note").str + "\n";
        }
    }
    return out;
}

} // namespace forge
