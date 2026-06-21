// sim/combat.cpp -- see combat.hpp.
#include "combat.hpp"

namespace vc::sim {

double combat_odds(int atk_str, int def_str) {
    int total = atk_str + def_str;
    return total > 0 ? (double)atk_str / total : 0.0;
}

int terrain_defense_value(int terrain_id) {
    // terrain ids: 0..7 open/wetland base, 8..23 forest variants, 24..28 special.
    switch (terrain_id) {
        case 6: case 7: return 1;          // Marsh, Swamp
        case 27: return 6;                  // Mountains
        case 28: return 4;                  // Hills
    }
    if (terrain_id >= 8 && terrain_id <= 23) {
        // forests = 2; Rain Forest = 3 (the wettest variant, id 23)
        return terrain_id == 23 ? 3 : 2;
    }
    return 0;                               // open land / ocean / arctic / sea-lane
}

int demote(int loser_type, int profession) {
    int r;
    switch (loser_type) {
        case 1: r = 0; break;   // Soldiers   -> Colonists
        case 4: r = 1; break;   // Dragoons   -> Soldiers
        case 7: r = 9; break;   // Cont. Cav. -> Cont. Army
        case 8: r = 6; break;   // Cavalry    -> Regulars
        case 9: r = 0; break;   // Cont. Army -> Colonists
        default: return -1;     // no entry -> destroyed
    }
    if (r == 0 && profession == CLASS_MISSIONARY) r = 3;   // Missionary override
    return r;
}

bool is_capturable(int loser_type) {
    return loser_type == COLONISTS || loser_type == TREASURE || loser_type == WAGON_TRAIN;
}

CombatResult resolve_land(const Unit& attacker, const Unit& defender,
                          int terrain_defense, int fort_bonus, int difficulty,
                          bool attacker_human, bool defender_human,
                          const RandFn& rng) {
    CombatResult res;
    res.atk_str = unit_stats(attacker.type).attack;
    res.def_str = unit_stats(defender.type).defense + terrain_defense + fort_bonus;
    if (attacker_human) res.atk_str += difficulty_bonus(difficulty);
    if (defender_human) res.def_str += difficulty_bonus(difficulty);
    if (res.atk_str < 0) res.atk_str = 0;
    if (res.def_str < 0) res.def_str = 0;

    int total = res.atk_str + res.def_str;
    int roll  = total > 0 ? rng(1, total) : 1;
    res.attacker_won = roll <= res.atk_str;

    const Unit& loser = res.attacker_won ? defender : attacker;
    res.loser_type = loser.type;
    if (is_capturable(loser.type)) {
        res.captured = true;
        res.loser_outcome = loser.type;     // changes hands intact
    } else {
        res.loser_outcome = demote(loser.type, loser.profession);
    }
    return res;
}

} // namespace vc::sim
