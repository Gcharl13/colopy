// sim/diplomacy.hpp -- inter-power diplomacy (spec/systems/diplomacy.md).
#pragma once
#include <cstdint>
#include "immigration.hpp"   // RandFn

namespace vc::sim {

// War bit-matrix (PowerRecord +0x34) bit meanings.
constexpr uint8_t WAR_RESOLVED  = 0x01;   // resolved/normalized relationship (set @0x5318F)
constexpr uint8_t WAR_AT_WAR    = 0x02;
constexpr uint8_t WAR_GRIEVANCE = 0x08;
constexpr uint8_t WAR_PRIVATEER = 0x80;
// Treaty/relation matrix (PowerRecord +0x40) bit meanings.
constexpr uint8_t REL_WAR      = 0x02;
constexpr uint8_t REL_PEACE_PENDING = 0x20;
constexpr uint8_t REL_TREATY   = 0x40;

struct Diplomacy {
    uint8_t war[4][4] = {};       // +0x34 matrix
    uint8_t rel[4][4] = {};       // +0x40 matrix
    int     cooldown[4] = {};     // [power*2 + 0x53C8] re-parley lockout turn
    // Per-power grievance score (the DGROUP 0x941C 4-word array, extraction
    // 2026-07-02): reset @0x42142, accrued @0x42335 by the per-unit value call
    // (0x181F:0x9C8 -> file 0x7C2A, decoded -- grievance_unit_value below)
    // when a power's unit is destroyed; the confrontation evaluator compares
    // two powers' scores relatively (@0x3F0C5/@0x3F0CE) to raise the
    // pending-grievance bit (@0x3F0D7).
    uint16_t grievance[4] = {};
    // Per-power attitude byte (DGROUP 0x940C, diplomacy.md 3): the willingness
    // input to ai_acts and the parley target-eligibility floor (>= 8 on at
    // least one side, @0x57B1A). Adjusted on unit-ownership transfer
    // (@0x5DC76); the INITIAL value is unextracted -- seeded 8 (the
    // eligibility floor) at game setup, RECONSTRUCTED.
    uint8_t attitude[4] = {8, 8, 8, 8};
};

// Symmetric writes (SIGNTREATY writes matrix[A][B] = matrix[B][A]).
void declare_war(Diplomacy& d, int a, int b);
void make_peace(Diplomacy& d, int a, int b);

// Privateer hidden attribution (diplomacy.md @0x3F092 -> @0x3F0A1): a
// Privateer (type 0x10) attack sets the victim's WAR_PRIVATEER bit toward
// the owner INSTEAD of open war (the victim knows pirates struck, not whose);
// cleared on make-peace (@0x58BE1).
void privateer_attack(Diplomacy& d, int victim, int owner);
bool at_war(const Diplomacy& d, int a, int b);
void sign_treaty(Diplomacy& d, int a, int b, int turn);  // sets REL_TREATY + cooldown
bool has_treaty(const Diplomacy& d, int a, int b);

// 16-turn re-parley lockout: turn + 0x10.
inline int treaty_cooldown(int turn) { return turn + 0x10; }
// AI demand grace period: 10*(10-difficulty) turns.
inline int ai_grace(int difficulty) { return 10 * (10 - difficulty); }
// AI tribute/demand value scaling (difficulty.md @0x583A0): x0.8 .. x1.2.
inline long ai_demand_value(long value, int difficulty) {
    return value * 10 * (difficulty + 8) / 100;
}
// AI demand surcharge (@0x5842B): += 500*(diff+1).
inline long ai_demand_surcharge(int difficulty) { return 500L * (difficulty + 1); }

// Per-unit combat-strength value -- func_007C2A (thunk 0x181F:0x9C8, type-B
// -> file 0x7C2A; decoded 2026-07-03 via tools/rtlink_decode.py). This is the
// shared "x8 accessor" of combat.md 2 (it also publishes the base to
// [0x8D06+2*mode] and modifier flags to [0x8D00+2*mode]: bit 2 veteran,
// 0x40 Drake, 4 cargo-laden -- the combat-analysis readout); the grievance
// accrual @0x42335 reuses it as the destroyed unit's value. BYTE_VERIFIED:
//   base  = @UNIT stat [type*14 + 0x5235] = defense (mode 0, the destroyed-
//           unit accrual path; mode 1 reads attack @+0x5236)
//   damaged Artillery (type 0xB, unit flag [0x3148]&0x80) -> base -= 2
//     (approximated: the sim demotes damaged artillery by type, so the
//     lower @UNIT stat already reflects it)
//   score = base * 8
//   veteran class ([0x315B]==0x15) Soldiers (1) / Dragoons (4) -> +50%
//   Privateer (0x10) whose owner has Francis Drake (FF 13)     -> +50%
//   ships (0xD..0x12) -> score -= cargo count [unit+0x3150] (unit.md: the
//     # goods in hold -- laden ships fight/are valued weaker per item)
inline long grievance_unit_value(int defense, int type, bool veteran, bool drake,
                                 int cargo = 0) {
    long score = (long)defense * 8;
    if (veteran && (type == 1 || type == 4)) score += score / 2;
    if (type == 0x10 && drake) score += score / 2;
    if (type >= 0xD && type <= 0x12) score -= cargo;
    return score;
}

// AI willingness (@0x58C24): the AI takes NO action when
//   (attitude>>2) > demand_score AND demand_score > 12 AND random(0,4) != 0.
// Returns true if the AI *acts*.
bool ai_acts(int attitude, int demand_score, const RandFn& rng);

} // namespace vc::sim
