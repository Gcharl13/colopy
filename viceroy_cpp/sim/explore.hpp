// sim/explore.hpp -- exploration / fog of war (spec/systems/exploration.md, BYTE-VERIFIED).
//
// The map starts hidden; each power owns an independent STICKY per-tile bit
// (1 << (player+4)) in the visibility layer -- no shared exploration. Units reveal
// a (2R+1)x(2R+1) square centred on themselves (func_006468 double loop); the
// radius comes from the func_006608 selector; colonies/settlements reveal +/-5
// (func_0063B6, an 11x11 square). Once revealed, a tile never re-fogs.
#pragma once

#include "game.hpp"
#include "immigration.hpp"   // RandFn

namespace vc::sim {

// Sight radius R (func_006608): land units 1 (3x3); Scout(5) 2 (@0x665E);
// Galleon/Privateer/Frigate 2 (@0x6619..0x662E); any naval (13..18) 2 when the
// owner has Hernando de Soto (FF #7 -- the has-father check @0x6631, naval-ONLY
// per @0x6647; the manual's "all units" reach is a documented divergence).
int sight_radius(int unit_type, bool owner_has_de_soto);

// OR the (2R+1)^2 square around (x,y) into the fog plane for `player`
// (func_006468 -> func_00631A). Lazily allocates the plane on first use.
void reveal_around(World& w, int x, int y, int r, int player);

// The per-turn sweep: every living unit reveals its sight square and every
// colony its +/-5 block (idempotent -- the bits are sticky). human_ff_owned
// carries de Soto for player 0; AI founding fathers are not modeled.
void reveal_step(World& w, uint32_t human_ff_owned);

// Scout "Infiltrate Colony" (exploration.md 3, func_05A20E option 2 @0x5A2DC):
// success iff random_int(1,36) <= (X+6)*2, the roll HALVED for a Seasoned Scout
// (class 0x16, sar @0x5A2F2), the threshold +(difficulty-2) against a human
// target. The spec leaves X unnamed -- RECONSTRUCTED as the game difficulty.
// Success reveals the colony's square and bumps the target's +0xAA store by 100;
// failure = the scout is caught and lost (@0x5A3EA, @LOSTOURSCOUTS), and its
// mounts go to the colony stables (@LOSTTHEIRSCOUTS "%NUMBER0 horses"; the count
// is not byte-cited -- RECONSTRUCTED as 50, the scout's mount complement).
// Returns true on success. Never adds/removes units (only marks the scout dead).
bool scout_infiltrate(GameState& g, World& w, int unit_idx, int colony_idx,
                      const RandFn& rng);

} // namespace vc::sim
