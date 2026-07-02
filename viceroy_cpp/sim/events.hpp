// sim/events.hpp -- Lost City Rumors (spec/systems/events.md, func_061454 BYTE-VERIFIED).
//
// A unit entering a rumor square rolls the outcome n = random_int(1,9), used
// DIRECTLY as the @LOSTCITY<n> message suffix (itoa-append @0x618D1, no weight
// table). Scout level s = (type == Scout) + (class 0x16 Seasoned Scout)
// [+ Hernando de Soto, who also forces positive outcomes -- exploration.md];
// the bad outcomes (5 vanish / 8 shrines) escape-reroll via random_int(1, s+1).
// Byte-verified reward dice (s does NOT include difficulty):
//   n=1 Fountain of Youth  -> 8 immigrants queued on the Europe docks
//   n=2 Cibola             -> Treasure unit worth (10*(s+2) + 1d20) * 100  (%NUMBER1)
//   n=3 ruins              -> gold 10*(3d8), scaled *(s+2)/2               (%NUMBER0)
//   n=4 burial mounds      -> @BURIAL1 empty / @BURIAL2 gold 10*(3d8)
//                             / @BURIAL3 treasure 2*(1d8 + 2*(s+5)) * 100
//   n=5 vanished           -> the triggering unit is destroyed
//   n=6 nothing but rumors -> fizzle
//   n=7 friendly tribe     -> gift of gold 2*(4d10)
//   n=8 holy shrines       -> the local tribe is displeased (alarm)
//   n=9 survivors          -> colonist(s) join (count elided -> 1, RECONSTRUCTED)
// The rumor square is consumed on entry. Rumor PLACEMENT is not in the spec's
// byte record (the original map carries them) -- seeded via cfg.rumor_count
// (RECONSTRUCTED), stored as improvement-plane bit 0x10.
#pragma once

#include "game.hpp"
#include "rules.hpp"
#include "immigration.hpp"   // RandFn

namespace vc::sim {

constexpr uint8_t RUMOR_BIT = 0x10;   // improvement-plane marker for a rumor square

struct RumorResult {
    int  unit = -1;         // triggering unit index
    int  x = 0, y = 0;      // where
    int  n = 0;             // @LOSTCITY<n> outcome index (1..9)
    int  burial = 0;        // @BURIAL<b> sub-outcome when n == 4 (1..3)
    long gold = 0;          // %NUMBER0 -- immediate gold credited to the owner
    long treasure = 0;      // %NUMBER1 -- treasure-unit gross value (stored /100)
    int  immigrants = 0;    // n=1 Fountain of Youth burst
    int  colonists = 0;     // n=9 survivors joining
    bool vanished = false;  // n=5 unit destroyed
};

// Resolve one rumor entry (func_061454). Mutates the unit/game/world (gold credit,
// treasure/colonist unit spawns, vanish) and clears the rumor bit. de_soto = the
// owner holds Founding Father #7.
RumorResult lost_city_rumor(GameState& g, World& w, int unit_idx,
                            bool de_soto, const RandFn& rng);

} // namespace vc::sim
