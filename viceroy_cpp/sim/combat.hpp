// sim/combat.hpp -- land combat (spec/systems/combat.md).
#pragma once
#include "unit.hpp"
#include "immigration.hpp"   // RandFn

namespace vc::sim {

// Win probability for the attacker: ATK / (ATK + DEF) (func_05CA7E).
double combat_odds(int atk_str, int def_str);

struct RuleData;   // sim/rules.hpp

// Per-terrain "Defensive" value from @TERRAIN: open 0, marsh/swamp 1, forest 2,
// rain 3, hills 4, mountains 6 (terrain ids per CLAUDE.md / map_system.md).
//   terrain_defense_value(rd, id)  reads from the injected ruleset (preferred).
//   terrain_defense_value(id)      falls back to default_rules() (value-identical).
int terrain_defense_value(const RuleData& rd, int terrain_id);
int terrain_defense_value(int terrain_id);

// Human-controlled combatant strength handicap: +(4 - difficulty), 0..4.
inline int difficulty_bonus(int difficulty) { return 4 - difficulty; }

// Demotion ladder (func_05B2C2): a defeated unit's type -> its demoted type,
// or -1 (destroyed). Missionary override: a Colonists(0) result whose
// profession is Missionary (0x18) becomes Missionaries(3).
int demote(int loser_type, int profession);

// Capture-eligible loser types: Colonists(0), Treasure(0xA), Wagon Train(0xC).
bool is_capturable(int loser_type);

struct CombatResult {
    bool attacker_won = false;
    int  atk_str = 0, def_str = 0;
    int  loser_type = -1;       // the defeated unit's original type
    int  loser_outcome = -1;    // new type after demote/capture, or -1 destroyed
    bool captured = false;      // owner reassigned (vs demoted/destroyed)
};

// Resolve one land attack. terrain_defense from terrain_defense_value();
// fort_bonus folds colony/fortification/road bonuses (+2/+4/...). rng(1,N)
// draws the roll; attacker wins if roll <= atk_str.
//   resolve_land(rd, ...)  uses the injected ruleset for unit strengths.
//   resolve_land(...)      falls back to default_rules() (value-identical).
CombatResult resolve_land(const RuleData& rd,
                          const Unit& attacker, const Unit& defender,
                          int terrain_defense, int fort_bonus, int difficulty,
                          bool attacker_human, bool defender_human,
                          const RandFn& rng);
CombatResult resolve_land(const Unit& attacker, const Unit& defender,
                          int terrain_defense, int fort_bonus, int difficulty,
                          bool attacker_human, bool defender_human,
                          const RandFn& rng);

} // namespace vc::sim
