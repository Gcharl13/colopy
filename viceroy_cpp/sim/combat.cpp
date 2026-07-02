// sim/combat.cpp -- see combat.hpp.
#include "combat.hpp"
#include "rules.hpp"
#include "game.hpp"   // World (shore bombardment)

#include <cstdlib>

namespace vc::sim {

int defense_bonus(const RuleData& rd, bool colony_present, int fort_level,
                  bool fort_doubled, int river_road_n, int terrain_id) {
    int b = 0;
    if (colony_present) b += 2;                        // @0x7D8D
    if (fort_level >= 2) {                             // fortified building @0x7DBC
        int f = 4;
        if (fort_doubled) f *= 2;                      // the 0x20 condition @0x7DD1
        b += f;
    }
    if (river_road_n > 0) b += (river_road_n + 1) * 2; // river/road feature @0x7E12
    b += terrain_defense_value(rd, terrain_id);        // @TERRAIN Defensive @0x7E63
    return b;
}

int apply_defense_bonus(int strength, int bonus) {
    if (bonus <= 0) return strength;                   // see the header reconciliation note
    int v = strength * (bonus + 4) / 4;                // @0x05CE05
    return v * 3 / 2;                                  // the *3/2 chain @0x05CE16
}

bool can_attack_ships(int type) {
    return type == PRIVATEER || type == FRIGATE || type == MAN_O_WAR;
}

NavalResult resolve_naval(const RuleData& rd, const Unit& attacker,
                          const Unit& defender, const RandFn& rng) {
    NavalResult res;
    // RAW stat pair (for ships attack/defense = the @UNIT Guns/Hull columns);
    // no terrain/fort/veteran modifiers on the ship roll (@0x05B819).
    res.atk_str = unit_stats(rd, attacker.type).attack;
    res.def_str = unit_stats(rd, defender.type).defense;
    const int total = res.atk_str + res.def_str;
    const int roll = total > 0 ? rng(1, total) : 1;    // random_int(1, A+D) @0x05B844
    res.attacker_won = roll <= res.atk_str;
    const Unit& loser = res.attacker_won ? defender : attacker;
    bool cargo = false;                                // the +0x3148 & 0x40 cargo bit
    for (int h = 0; h < 6; ++h) if (loser.hold_good[h] >= 0) cargo = true;
    res.loser_sunk = cargo;                            // laden -> sunk; empty -> damaged
    return res;
}

void shore_bombardment(World& w, const RuleData& rd, std::vector<ShoreFire>* out) {
    for (int ci = 0; ci < (int)w.colonies.size(); ++ci) {
        const Colony& c = w.colonies[ci];
        if (c.x < 0) continue;
        // fort_level: +1 for a stockade-line building, +1 for fort/fortress
        // (@BUILDING ids 0 Stockade / 1 Fort / 2 Fortress; the 0x181F:0x9FC
        // build-level >= 1 / >= 2 queries @0x02D3D6/@0x02D3EE).
        const bool stockade = (c.built_mask >> 0) & 1ull;
        const bool fort     = (c.built_mask >> 1) & 1ull;
        const bool fortress = (c.built_mask >> 2) & 1ull;
        const int level = ((stockade || fort || fortress) ? 1 : 0) + ((fort || fortress) ? 1 : 0);
        if (level == 0) continue;                      // no fortification: no fire @0x02D44D
        int art = 1;                                   // [bp-0x10] starts 1 (@0x02D432)
        for (const Unit& u : w.units)
            if (u.alive && u.type == ARTILLERY && u.owner == c.owner_power &&
                u.x == c.x && u.y == c.y) ++art;
        const int strength = art * level * 4;          // [bp-0xe] = count*level*4
        // scan the 8 neighbours for an enemy ship (types 13..18, @0x02D4D2)
        for (int i = 0; i < (int)w.units.size(); ++i) {
            Unit& sh = w.units[i];
            if (!sh.alive || sh.owner == c.owner_power) continue;
            if (sh.type < CARAVEL || sh.type > MAN_O_WAR) continue;
            if (std::abs(sh.x - c.x) > 1 || std::abs(sh.y - c.y) > 1) continue;
            const bool sunk = strength >= unit_stats(rd, sh.type).defense;
            if (sunk) sh.alive = false;
            else sh.moves_left = 0;                    // damaged: limps off (repairs
                                                       //   not modeled, noted)
            if (out) out->push_back(ShoreFire{ci, i, strength, sunk});
            break;                                     // one target per colony per turn
        }
    }
}

double combat_odds(int atk_str, int def_str) {
    int total = atk_str + def_str;
    return total > 0 ? (double)atk_str / total : 0.0;
}

int terrain_defense_value(const RuleData& rd, int terrain_id) {
    // The per-id "Defensive" values (incl. the forest 8..23 normalization where
    // canonical Rain Forest id 15 / its duplicate 23 -> 3) are baked into
    // rd.terrain_defense by make_default_rules(). Out-of-range -> 0.
    if (terrain_id < 0 || terrain_id >= NTERRAIN) return 0;
    return rd.terrain_defense[terrain_id];
}

int terrain_defense_value(int terrain_id) {
    return terrain_defense_value(default_rules(), terrain_id);
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

bool promote_on_win(int& io_type, int& io_profession, int winner_strength,
                    int strength_sum, bool has_washington, const RandFn& rng) {
    constexpr int VETERAN = 0x15;   // Veteran Soldier class (+0x315B)
    // Only the soldier line promotes; Continental units are already at the type ceiling.
    const bool soldier = (io_type == 1 || io_type == 4);
    const bool continental = (io_type == 9 || io_type == 7);
    if (!soldier && !continental) return false;
    if (!has_washington) {
        const int s = strength_sum > 0 ? strength_sum : 1;
        if (rng(1, s) > winner_strength) return false;   // P(promote) = winner_strength / S
    }
    if (soldier && io_profession != VETERAN) { io_profession = VETERAN; return true; }
    if (io_type == 1) { io_type = 9; return true; }      // Soldiers -> Continental Army
    if (io_type == 4) { io_type = 7; return true; }      // Dragoons -> Continental Cavalry
    return false;                                        // Continental veteran: ceiling reached
}

CombatResult resolve_land(const RuleData& rd,
                          const Unit& attacker, const Unit& defender,
                          int terrain_defense, int fort_bonus, int difficulty,
                          bool attacker_human, bool defender_human,
                          const RandFn& rng, bool defender_fortified,
                          int attacker_nation) {
    CombatResult res;
    res.atk_str = unit_stats(rd, attacker.type).attack;
    if (attacker_nation == 2 && defender.type >= BRAVES && defender.type < NUNITTYPES)
        res.atk_str += res.atk_str / 2;   // Spanish +50% vs natives (@0x05CF2F: sar;add)
    // The func_007D3E accumulator (terrain + colony/fort/road folds) applies to
    // the defending strength via the byte-verified *(bonus+4)/4 *3/2 chain
    // (func_05CA7E @0x05CE05/@0x05CE16), not additively.
    res.def_str = apply_defense_bonus(unit_stats(rd, defender.type).defense,
                                      terrain_defense + fort_bonus);
    if (attacker_human) res.atk_str += difficulty_bonus(difficulty);
    if (defender_human) res.def_str += difficulty_bonus(difficulty);
    if (res.atk_str < 0) res.atk_str = 0;
    if (res.def_str < 0) res.def_str = 0;
    if (defender_fortified)                            // fortified: +50% DEF (spec combat.md)
        res.def_str = res.def_str * rd.cfg.fortify_def_num / rd.cfg.fortify_def_den;

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

CombatResult resolve_land(const Unit& attacker, const Unit& defender,
                          int terrain_defense, int fort_bonus, int difficulty,
                          bool attacker_human, bool defender_human,
                          const RandFn& rng) {
    return resolve_land(default_rules(), attacker, defender, terrain_defense,
                        fort_bonus, difficulty, attacker_human, defender_human, rng);
}

} // namespace vc::sim
