// sim/natives.hpp -- native relations (spec/systems/natives.md).
#pragma once

namespace vc::sim {

// Mission conversion (func_0572E6): success iff random_int(0,15) < threshold,
// where threshold = TribeData[+2]+2, doubled for an expert/Jesuit missionary.
// P(convert) = threshold/15.
int    mission_threshold(int tribe_level, bool jesuit);
bool   mission_converts(int roll0to15, int tribe_level, bool jesuit);
double mission_prob(int tribe_level, bool jesuit);

// Raid outcomes (func_05BE84 dispatch).
enum RaidOutcome { RAID_NOTHING = 0, RAID_STORES = 1, RAID_WREAK = 2,
                   RAID_GOLD = 3, RAID_BURN = 4 };

constexpr int TENSION_HOSTILE = 75;    // tension >= 75 -> hostile
constexpr int TENSION_WAR     = 100;   // tension == 100 -> war
constexpr int ALARM_WAR       = 128;   // per-power alarm >= 0x80 -> hostile

// Apply a tension delta (func_045DF2): positive deltas halved by French power
// and again by Pocahontas (FF 16); result clamped to [0,100].
int apply_tension(int tension, int delta, bool french_power, bool pocahontas);

// Native trade buy price: max(5*difficulty+50, 2*tax), capped at 90.
int native_trade_price(int difficulty, int tax_pct);

// Tribute gold extorted: clamp(demand, [10, min(3*wealth+10, 100)]).
int tribute_gold(int demand, int settlement_wealth);

} // namespace vc::sim
