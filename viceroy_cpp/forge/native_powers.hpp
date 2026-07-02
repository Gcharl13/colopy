// forge/native_powers.hpp -- native-power behavior (spec/systems/natives.md, byte-cited).
//
// Settlements are forge-side entities (EngineExtra.settlements); this module
// implements the byte-verified native formulas on them:
//  - the 0x5B1C TENSION meter (func_045DF2): [0,100] per (settlement, power),
//    thresholds 75 hostile / 100 war -- distinct from the alarm[] words
//    (threshold 128, the +0x54F6 array);
//  - raid outcome selection (func_05BE84, the 6 @RAID* keys);
//  - mission conversion (func_0572E6, P = (tribe_level+2)/15, Jean de Brebeuf
//    doubling);
//  - native trade pricing (@0x5C976) and the CHIEFKILL raze treasure
//    (func_04A7CA raze branch).
#pragma once
#include "engine.hpp"        // NativeSettlement, EngineExtra
#include "immigration.hpp"   // vc::sim::RandFn

namespace forge {

constexpr int TENSION_HOSTILE = 75;    // raid-scan threshold (@0x47328 / @0x45E9E)
constexpr int TENSION_WAR     = 100;   // maxed -> war path (@0x45EB2)

// func_045DF2: tension[power] += delta, clamped [0,100]. A POSITIVE delta is
// HALVED for the French national power (@0x45E21) and again for a Pocahontas
// (FF 16) owner (@0x45E30). Returns the new value. (The 4th "category" arg the
// EXE callers push is dead -- never read by the applier; 2026-06-27 reseg.)
int tension_apply(NativeSettlement& s, int power, int delta,
                  bool is_france, bool pocahontas);

// func_0572E6: the mission-conversion roll -- threshold = tribe_level + 2,
// DOUBLED with Jean de Brebeuf (FF 0x16 = 22, @0x48C81); roll = random_int(0,15);
// converts iff roll < threshold (fails on roll >= threshold @0x57316).
bool mission_convert_roll(int tribe_level, bool brebeuf, const vc::sim::RandFn& rng);

// Native buy price (@0x5C976): floor = 5*difficulty + 50; offer =
// max(floor, 2*tax_pct), capped at 90 (@0x5C9A3).
int native_trade_price(int difficulty, int tax_pct);

// Incite-Indians price. The EXE formula is not byte-decomposed; the manual
// (GAME_MANUAL.md "Inciting Indians") pins the three factors: "the number of
// missions you have operating within settlements of their tribe, their current
// attitude toward you, and their current attitude toward the Europeans you
// want them to whack. The more missions you have, the better; the more they
// like you and dislike the target of your attack, the better."
// RECONSTRUCTED with that structure: price = 100 + 4*tension_toward_you
// - 2*tension_toward_target - 100*own_missions_in_tribe, floored at 50.
int incite_price(int tension_you, int tension_target, int missions_in_tribe);

// CHIEFKILL raze treasure (func_04A7CA raze branch @0x4AAD0..0x4AB35):
// gold = (sum of 3 x random_int(0, 10-difficulty)) * random_int(0,6) * 4
//        * (tribe_level + 1), credited DIRECTLY to the attacker's gold
// (no x100, no treasure unit on this path, @0x4AB66).
long raze_treasure_gold(int difficulty, int tribe_level, const vc::sim::RandFn& rng);

// One raid attempt (func_05BE84) by a hostile settlement against a colony.
// Gate roll: random_int(1,12)-1, biased +(difficulty-2) for a human-European
// target (@0x5BF1A), vs threshold 3*K+1 (@0x5BEE5; K RECONSTRUCTED as the
// colony's fortification level -- the byte trace leaves K unnamed). If the gate
// fails the raid fizzles (outcome 0 @RAIDNOTHING). Base outcome random_int(1,4)
// (@0x5BF35), DOWNGRADED by 1 while turn < 40*(2-difficulty) (@0x5BF44).
// Outcome map (byte-verified @0x5C026 ladder): 0 @RAIDNOTHING / 1 @RAIDSTORES
// (steal a stocked good; settlement wealth += 25 @0x5C3E4) / 2 @RAIDWREAK /
// 3 @RAIDGOLD / 4 @RAIDBURN (or @RAIDSHIP when a ship is docked).
struct RaidResult {
    int outcome = 0;          // 0..4 per the dispatch ladder
    const char* key = "@RAIDNOTHING";
    int good = -1;            // @RAIDSTORES: the good stolen
    int building = -1;        // @RAIDBURN: the @BUILDING id destroyed
    int ship = -1;            // @RAIDSHIP: the docked unit index hit
    long gold = 0;            // @RAIDGOLD: the sum plundered
};
RaidResult native_raid(vc::sim::GameState& g, vc::sim::World& w,
                       NativeSettlement& s, int colony_idx, long turn,
                       bool human_target, const vc::sim::RandFn& rng);

// The per-turn native pass: tension decays toward 0 (the @0x485E7 normalization
// loop); each mission rolls a conversion (a convert joins the owning power's
// colony -- surfaced in `converts`); each settlement hostile toward a power
// (tension >= 75 or alarm >= 128) raids that power's nearest colony (one raid
// per settlement per turn; results in `raids` with the settlement index).
struct NativeTurn {
    std::vector<std::pair<int, int>> converts;              // (settlement, colony)
    std::vector<std::pair<int, RaidResult>> raids;           // (settlement, result)
};
// The byte-verified tension-event delta table (natives.md, func_045DF2
// callers): trespass minor/moderate/severe +1/+2/+3 (@0x4A2E8/@0x4A319/
// @0x4A674), successful trade -4 (@0x5C41E), incite +100 / pacify -100
// (@0x486F8/@0x4870C), burial-ground desecration +100 (@0x61B84).
constexpr int TENSION_TRESPASS_MINOR    = 1;
constexpr int TENSION_TRESPASS_MODERATE = 2;
constexpr int TENSION_TRESPASS_SEVERE   = 3;
constexpr int TENSION_TRADE_GOODWILL    = -4;
constexpr int TENSION_INCITE            = 100;
constexpr int TENSION_PACIFY            = -100;
constexpr int TENSION_DESECRATE         = 100;

// The tribe's civilization level (@TRIBES[t].level -- the TribeData +2 column
// that scales missions, raze payouts and the action-menu gates).
int tribe_level(int tribe);

// CHIEFKILL -- razing a settlement (natives.md, func_04A7CA): the attacker's
// class 0x16 (Seasoned Scout) sets scout=1 (@0x4A7D9); the escape roll bound
// is 40*scout + 100 (@0x4A81A), or (8 - difficulty) << scout for tribe 2
// (@0x4A84A); settlements of size >= 25 re-roll while size/4 >= roll
// (@0x4A832..41, biasing large villages toward high rolls); size >= 75 takes
// the distinct big-treasure branch (@0x4A802, internals undecoded -- treated
// as razed). The roll is the village-survives/ESCAPE check vs alarm
// (@0x4A97A); the comparison DIRECTION is not in the trace -- razed on
// roll >= alarm is the RECONSTRUCTED reading (the size re-roll biases toward
// success, matching "larger settlements bias toward larger treasure"). On a
// raze the payout is raze_treasure_gold (credited by the caller) and the
// settlement is removed.
struct ChiefKillResult {
    bool razed = false;      // false = the villagers escaped with their wealth
    long gold  = 0;          // razed payout, credited straight to gold (@0x4AB66)
};
ChiefKillResult chiefkill(const vc::sim::GameState& g, const NativeSettlement& s,
                          int attacker_class, const vc::sim::RandFn& rng);

// Attitude banding (natives.md @0x048AFE): 0 Content / 1 Uneasy / 2 Restless /
// 3 Angry from score = 8*X-5 (bands -5/0/10); 4 War when alarm >= 128.
int settlement_attitude(int presence_x, int alarm);

NativeTurn native_turn_step(vc::sim::GameState& g, vc::sim::World& w,
                            EngineExtra& x, const vc::sim::RandFn& rng);

// The per-tribe attitude/demand evaluator (natives.md / difficulty.md, BYTE-
// VERIFIED @0x46500/@0x46538): the human and AI take DIFFERENT formulas --
// native friendliness is a difficulty handicap.
//   human: 2*(diff+3) + level + value - prior   (threshold 0x41 = 65)
//   AI:    level + value - diff + 12 - prior    (threshold 0x32 = 50)
// Returns the attitude value; `hostile` (out) = value >= the branch threshold.
int tribe_attitude(bool human, int difficulty, int tribe_level, int tribe_value,
                   int prior, bool& hostile);

} // namespace forge
