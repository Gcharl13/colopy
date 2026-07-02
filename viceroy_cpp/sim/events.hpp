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
// The rumor square is consumed on entry. Rumor PRESENCE is PROCEDURAL
// (events.md 6.1, EXE-verified func_006188): a coordinate hash against the map
// seed [0x190] -- ((x>>2)*0x13 + (y>>2)*0x11 + seed + 8) & 0x1F - (y&3)*4 ==
// (x&3) -- gated on terrain (not Arctic/Ocean/Sea Lane) and on the tile's
// feature state being clean (a stored feature SUPPRESSES the rumor). Here the
// improvement-plane bit 0x10 is that suppress/consumed state.
#pragma once

#include "game.hpp"
#include "rules.hpp"
#include "immigration.hpp"   // RandFn

namespace vc::sim {

constexpr uint8_t RUMOR_BIT = 0x10;   // improvement-plane CONSUMED/suppressed marker

// The byte-verified rumor-presence predicate (func_006188 @0x61C7..0x61F8):
// true iff the coordinate hash selects this tile, the terrain admits a rumor,
// and the tile has not been consumed/suppressed.
bool rumor_present(const World& w, int x, int y, int seed);

// The byte-verified PRIME-RESOURCE predicate (func_0060A0, resolved from the
// map-view draw site @0x6829A `lcall 0x181F:0x718` -> RTLink stub -> body
// @0x60A0). Returns the @RESOURCE row index at (x,y) or -1. Presence is
// PROCEDURAL -- computed from the same map seed [0x190] the rumor hash uses
// (rolled at new game; seed==0 -> no resources anywhere, @0x60A9):
//   a = (x&3)*4 + (y&3)                       (position in the 4x4 cell)
//   c = ((y>>2)*3 + (x>>2) - forested + seed) & 0xF
//   present iff c == a  or  (c ^ 0xA) == a    (two lattice points per cell;
//                                              @0x6101..0x6139)
// forested = terrain byte & 0x3F in [8, 0x18) (@0x60D4..0x6101) -- so clearing
// a forest MOVES the lattice under that tile. The resource kind is the word
// table DGROUP 0x192[terrain_id] (id 0..28; dumped from the EXE image
// @file 0x1DB32): Ocean->Fishery, Mountains->Silver Deposit, Hills->Ore
// Deposit, Arctic/Sea Lane->none, and per-band land kinds; table value 0 ->
// Minerals (@0x6154). The EXE also gates on the runtime flags plane [0x160]:
// bit1 = stored feature (suppresses, via func_005F82), bit2 = DEPLETED --
// a depleted Silver Deposit renders as Depleted Mine (idx 0), any other
// depleted resource vanishes (@0x616A..0x617E; not yet modeled -- our engine
// has no depletion writer). Sprite = PHYS0 game frame 0x5A+idx (png 0x59+idx),
// drawn at zoom 0 only ([0x184]==0 gate @0x68288).
int resource_at(const World& w, int x, int y, int seed);

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

// Treasure cash-in / the King's galleon (events.md, func_05C878 FULLY
// BYTE_VERIFIED): gross = 100 * the Treasure unit's class byte (value/100
// convention, @0x5C882). Post-independence the treasure cashes IN FULL
// (@0x5C88B). Pre-independence the King ships it (@KINGGALLEON) for a cut:
// with Hernan Cortes (FF #10) cut% = the tax rate (@0x5C965); without,
// cut% = max(5*difficulty + 50, 2*tax) clamped <= 90 (@0x5C976/@0x5C9A3).
// Cut = gross*cut%/100 (@0x5C9BF/@0x5C9C6); the player receives gross-cut
// (@0x5C9F0). (Transporting with your OWN Galleon -- no cut -- would need
// treasure units as ship cargo, which is not modeled; noted.)
struct CashInResult {
    bool ok = false;
    long gross = 0, cut = 0, net = 0;
    int  cut_pct = 0;
};
CashInResult treasure_cash_in(GameState& g, World& w, int unit_idx,
                              bool independence, bool cortes);

// Resolve one rumor entry (func_061454). Mutates the unit/game/world (gold credit,
// treasure/colonist unit spawns, vanish) and clears the rumor bit. de_soto = the
// owner holds Founding Father #7.
RumorResult lost_city_rumor(GameState& g, World& w, int unit_idx,
                            bool de_soto, const RandFn& rng);

} // namespace vc::sim
