// sim/ai.hpp -- the computer-player per-unit order/move engine (spec/systems/ai.md).
//
// The EXE drives every non-player unit through a per-POWER pass (func_005760's
// power loop, controller byte [idx*0x34+0x543f] skips the human): the strategic
// planner func_04CC50 assigns each unit a mission (the state-char alphabet at
// UnitRecord +0x314B, ai.md 4), then the per-unit driver func_051D56 ->
// func_04E2D6 validates, scores the 8 compass headings (+stay) with the
// func_046FFA term table, and steps the unit within its move budget
// (UnitRecord +0x3149; allowance = @UNIT movement x3, one step = 3 credits,
// ai.md 5). Missions decoded (ai.md 6.2): explore ('2'/'8'/'D'),
// return-to-colony ('3'/'5'/'N'/'P'/'V'/'W'), visit-natives ('4'/'J').
//
// This implementation reproduces the byte-cited scoring terms and budget model
// on our World; terms whose helpers need engine state we do not carry (native
// settlements live forge-side, the era counter, the yield helper) are skipped
// with a note -- not approximated.
#pragma once

#include "types.hpp"
#include "game.hpp"          // World
#include "rules.hpp"
#include "immigration.hpp"   // RandFn

namespace vc::sim {

// AI move budget (ai.md 5, BYTE-VERIFIED): allowance = the @UNIT movement
// column x3 (UnitTypeStats +0x00 stores moves*3; one step charges +3 @0x05CAE2).
// (The EXE's +3 naval bonus is gated on a per-power trait not modeled here.)
int ai_move_allowance(const RuleData& rd, int unit_type);

// Colony-site land value 0..15 (ai.md 3b, func_063F3C BYTE-VERIFIED):
// water / out-of-bounds = 0; land accumulates over the 21-tile colony catchment
// (5x5 minus corners -- the EXE's delta tables are runtime-built, order
// RECONSTRUCTED) with ring weights 5/4/3/2 applied as (v*w)>>1; each catchment
// tile contributes the per-terrain Improvement stat (@0x2F79 column), an ocean
// tile the coastal bonus (2 + 2*adjacent-land)>>2, +1 for the layer-1 0x40
// feature bit; halved near an existing colony; center Mountains -> 0, Hills
// halved; final = clamp(score/10, 0, 15) (idiv @0x6410E, clamp 0x181F:0x35c).
// (The special-resource bonus table [id-0x684e] is skipped: World carries no
// resource plane.) This is what the F9 "Show Colony Sites" cheat displays.
int colony_site_value(const World& w, const RuleData& rd, int x, int y);

// One power's AI pass (ai.md 6.3: controller gate -> strategic plan ->
// per-unit dispatch -> execute). Assigns missions (writing Unit.ai_state with
// the decoded state chars) and steps each unit via the func_046FFA heading
// scorer within its budget. Settler-class units seek the best colony site
// (the +500 term) and found a colony on arrival (state '=' absorbed); scouts
// explore toward their power's fog frontier ('2'); military garrisons the
// nearest own colony ('3' en route, 'G' garrisoned); ships wander ('8').
// AI units do not initiate combat in this pass (the enemy-on-tile candidate
// reject @0x047A1D; attack missions are not in the decoded dispatch table).
void ai_power_turn(GameState& g, World& w, int power, const RuleData& rd,
                   const RandFn& rng);

} // namespace vc::sim
