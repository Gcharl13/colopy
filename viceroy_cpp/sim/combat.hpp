// sim/combat.hpp -- land + naval combat (spec/systems/combat.md).
#pragma once
#include "unit.hpp"
#include "immigration.hpp"   // RandFn
#include <vector>

namespace vc::sim {

struct World;   // sim/game.hpp (shore bombardment scans the map)

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

// The defense-bonus filler (func_007D3E, BYTE-VERIFIED accumulator [0x8D04]):
// colony present +2 (@0x7D8D); fortified building (build level >= 2) +4
// (@0x7DBC), DOUBLED under the 0x20 condition (@0x7DD1); river/road feature
// +(n+1)*2 (@0x7E12); open terrain + the @TERRAIN "Defensive" value (@0x7E63).
int defense_bonus(const RuleData& rd, bool colony_present, int fort_level,
                  bool fort_doubled, int river_road_n, int terrain_id);

// The decider applies the accumulated bonus to the defending strength as
// strength*(bonus+4)/4 then *3/2 (func_05CA7E @0x05CE05 + the *3/2 chain
// @0x05CE16). Applied only when a bonus exists: the trace's unconditional
// *3/2 is ambiguous about which strength local it scales (the spec text reads
// "attacker", the semantics say defender) -- gating on bonus > 0 keeps every
// unmodified engagement identical (RECONCILIATION, noted).
int apply_defense_bonus(int strength, int bonus);

// --- Naval combat (func_05B2C2 ship path, types 13..18) ---
// The roll uses the RAW per-type stat pair (the @UNIT Guns/Hull columns at
// 0x523B/0x523C) with NO land modifiers (@0x05B819): roll = random_int(1, A+D),
// attacker wins iff roll <= A. Only Privateers and Frigates can attack enemy
// ships (@SHIPCOMBAT verbatim; the Man-O-War fights on the King's side). The
// loser: carrying cargo -> SUNK (the +0x3148 & 0x40 cargo-bit test @0x05BD1E;
// the cargo scatters); empty -> DAMAGED (@SHIPDAMAGE "returns for repairs" --
// the repair voyage is not modeled; the ship survives with its move spent).
bool can_attack_ships(int type);
struct NavalResult {
    bool attacker_won = false;
    int  atk_str = 0, def_str = 0;
    bool loser_sunk = false;    // cargo aboard -> sunk; empty -> damaged
};
NavalResult resolve_naval(const RuleData& rd, const Unit& attacker,
                          const Unit& defender, const RandFn& rng);

// --- Shore bombardment (func_02D3C6, BYTE-VERIFIED) ---
// A colony with a fortification building fires DETERMINISTICALLY (no random
// thunk in the function) at one adjacent enemy ship each turn: strength =
// artillery_count * fort_level * 4, where artillery_count starts at 1 and is
// +1 per Artillery unit in the colony (@0x02D432) and fort_level = +1 stockade
// +1 fort (the 0x181F:0x9FC build-level queries @0x02D3D6/@0x02D3EE); no
// fortification -> no fire (@0x02D44D). Damage-vs-sink in the EXE is the
// opaque owner-bit test [bp-6] (@0x02D530) -- RECONSTRUCTED here as
// sunk iff strength >= the ship's Hull stat. Emits @FORTFIRE (+@SHIPSUNK/
// @SHIPDAMAGE) -- surfaced via the out list.
struct ShoreFire { int colony = -1; int ship = -1; int strength = 0; bool sunk = false; };
void shore_bombardment(World& w, const RuleData& rd, std::vector<ShoreFire>* out = nullptr);

// Demotion ladder (func_05B2C2): a defeated unit's type -> its demoted type,
// or -1 (destroyed). Missionary override: a Colonists(0) result whose
// profession is Missionary (0x18) becomes Missionaries(3).
int demote(int loser_type, int profession);

// Win-promotion (spec/systems/training.md 3 "Veteran promotion", BYTE-VERIFIED):
// with George Washington (Founding Father #11, @0x5C758) the roll is skipped and
// promotion is automatic; otherwise promote iff random_int(1, S) <= winner_strength
// (@0x5C764; S = the combat strength sum, so P = winner_strength / S). A non-veteran
// soldier-line winner is stamped Veteran (class 0x15, the @0x03D835 veteran stamp /
// func_05E714 next-rank write); a veteran at the class ceiling advances TYPE instead
// (@0x5C7C3/@0x5C7CE): Soldiers(1) -> Continental Army(9), Dragoons(4) ->
// Continental Cavalry(7). Returns true if io_type/io_profession changed.
bool promote_on_win(int& io_type, int& io_profession, int winner_strength,
                    int strength_sum, bool has_washington, const RandFn& rng);

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
// attacker_nation is the @NATIONALITY index (-1 = unknown): a Spanish (2)
// attacker vs a native defender gains +strength/2 (national_powers.md,
// func_05CA7E @0x05CF2F..0x05CF4D: attacker owner == 2, defender owner >= 4
// -> sar ax,1; add -- our engine maps "native defender" to the @UNIT brave
// band 19..22, the only native land units).
CombatResult resolve_land(const RuleData& rd,
                          const Unit& attacker, const Unit& defender,
                          int terrain_defense, int fort_bonus, int difficulty,
                          bool attacker_human, bool defender_human,
                          const RandFn& rng, bool defender_fortified = false,
                          int attacker_nation = -1);
CombatResult resolve_land(const Unit& attacker, const Unit& defender,
                          int terrain_defense, int fort_bonus, int difficulty,
                          bool attacker_human, bool defender_human,
                          const RandFn& rng);

} // namespace vc::sim
