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

// --- Strategic plan-map accessors (ai.md 6.1, all BYTE-VERIFIED sites) ---
// The 4x64 per-power table of provisional goal tiles (GameState::plan).
//   plan_clear -- func_04C1F0: reset one slot to {goal_type=0xFF, priority=0}.
//   plan_set   -- func_04C3A2: priority-ordered insert (scans for the first
//                 slot that is free or outranked, shifts, writes the 4 fields).
//                 Returns false when the table is full of higher-priority goals.
//   plan_query -- func_04C306: max priority among slots matching (x,y,goal_type);
//                 -1 when none match.
void plan_clear(GameState& g, int power, int slot);
bool plan_set(GameState& g, int power, int x, int y, int goal_type, int priority);
int  plan_query(const GameState& g, int power, int x, int y, int goal_type);

// The per-power strategic pass (func_04CC50, ai.md 6.1/6.3): refills the
// power's plan slots from what it can see, then matches idle units to the
// highest-priority slot whose goal_type capbit the unit's @UNIT capability
// bitfield carries ((1<<G) & capbits, @0x04DFF4) -- writing state '1' (target
// selected) + the goto coords, refined to 't' (goal_type==1, unit-flag 0x4
// gate @0x04E05C) or 'i' (goal_type==7, flag 0x8 gate @0x04E07E). The slot
// FILL policy (which targets get which goal class) is RECONSTRUCTED: settle
// sites -> goal 6 (the 0x40 Colonist/Pioneer bit), explore frontier -> goal 5
// (the 0x20 Scout/Missionary bit), garrison -> goal 3 (a Soldier-band bit);
// the layout, match test, and state chars are the byte-cited part.
void ai_strategic_plan(GameState& g, World& w, int power, const RuleData& rd);

// The match half of the strategic pass alone (fill and match are the two
// halves of func_04CC50): binds idle units of the power to the best plan slot
// their capbits qualify for. Exposed so a caller (or test) can stage slots
// with plan_set and observe the binding/refinement chars directly.
void ai_plan_match(GameState& g, World& w, int power, const RuleData& rd);

// A native-settlement view for the visit-natives missions ('4'/'J', ai.md 6.2).
// The settlement entities live engine-side (forge EngineExtra.settlements); the
// sim AI receives this read-only projection of the table the EXE scans (count
// [0x539A], stride 0x12; the Capital bit is NativeSettlement +0x03 & 0x04).
struct AiVillage { int x = 0, y = 0; bool capital = false; bool mission_open = true; };

// One power's AI pass (ai.md 6.3: controller gate -> strategic plan ->
// per-unit dispatch -> execute). Assigns missions (writing Unit.ai_state with
// the decoded state chars) and steps each unit via the func_046FFA heading
// scorer within its budget. Settler-class units seek the best colony site
// (the +500 term) and found a colony on arrival (state '=' absorbed); scouts
// explore toward their power's fog frontier ('2', 'D' when >= 8 tiles out);
// military garrisons a colony ('3' assigned, 'L' routing in, 'V' arrived,
// 'G' garrisoned); ships wander ('8'); AI Pioneers improve tiles around their
// colonies ('B' clear/plow, 'e' road, 'C' complete). Budget exhaustion mid-
// route writes '9'; a lost goal writes '?' (re-planned next pass).
// With a village view, Scouts/Missionaries also take the visit-natives
// missions: '4' go-to-native-village (@0x0508AB, nearest-scored) and 'J' the
// capital-preferring variant (@0x050BD8, distance + capital bonus).
// AI units do not initiate combat in this pass (the enemy-on-tile candidate
// reject @0x047A1D; attack missions are not in the decoded dispatch table).
void ai_power_turn(GameState& g, World& w, int power, const RuleData& rd,
                   const RandFn& rng,
                   const std::vector<AiVillage>* villages = nullptr);

} // namespace vc::sim
