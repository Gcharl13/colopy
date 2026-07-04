// sim/unit.hpp -- unit model + @UNIT stat table (spec/systems/unit.md).
//
// UnitRecord base DGROUP:0x3144, stride 0x1C; @UNIT stat table DGROUP:0x5230
// stride 14, indexed type*14 (attack col @0x5236, defense @0x5235). For ships
// the attack/defense shown here are the Guns/Hull columns.
#pragma once
#include <array>

namespace vc::sim {

enum UnitType : int {
    COLONISTS = 0, SOLDIERS, PIONEERS, MISSIONARIES, DRAGOONS, SCOUTS,
    REGULARS, CONT_CAV, CAVALRY, CONT_ARMY, TREASURE, ARTILLERY, WAGON_TRAIN,
    CARAVEL, MERCHANTMAN, GALLEON, PRIVATEER, FRIGATE, MAN_O_WAR,
    BRAVES, ARMED_BRAVES, MTD_BRAVES, MTD_WARRIORS, NUNITTYPES = 24
};

// Profession/class byte (UnitRecord +0x315B). Missionary = 0x18 (@JOB 24).
constexpr int CLASS_MISSIONARY = 0x18;

struct UnitStats {
    const char* name;
    int attack;       // @UNIT attack  (land) / Guns (ship)
    int defense;      // @UNIT combat   (land) / Hull (ship)
    int cargo;        // @UNIT cargo  -- hold capacity
    int move_class;   // structural class: 1 land / 99 naval / 6 treasure / 0 native
    int movement;     // @UNIT movement -- move points per turn
    int capbits;      // @UNIT last column verbatim (binary; UnitTypeStats +0x09
                      //   @0x523d): the capability bitfield the plan-map goal
                      //   match tests ((1<<goal_type) & capbits, ai.md 6.1
                      //   @0x04DFF4) and the B/e build states probe (ai.md 4).
};

struct RuleData;   // sim/rules.hpp -- the injected, data-driven parameter set.

// Stats for a unit type (0..23); out-of-range -> a zeroed entry.
//   unit_stats(rd, type)  reads from the injected ruleset (preferred).
//   unit_stats(type)      falls back to default_rules() (value-identical).
const UnitStats& unit_stats(const RuleData& rd, int type);
const UnitStats& unit_stats(int type);

// Hardy Pioneer class (+0x315B == 0x14): improvement work thresholds halve
// (spec/systems/terrain_improvement.md, sar ax,1 @0x04074A/@0x040A59).
constexpr int CLASS_HARDY_PIONEER = 0x14;

// Veteran Soldier class (+0x315B == 0x15): the combat-promotion stamp
// (training.md 3 @0x03D835); Soldiers/Dragoons carry +50% strength inside
// the per-unit evaluator func_007C2A (diplomacy.md 2 / combat.md 2).
constexpr int CLASS_VETERAN = 0x15;

// Standing order for a unit (spec/systems/unit_orders.md, subset for the spine).
enum Order : int {
    ORDER_NONE = 0,    // idle (manual control each turn)
    ORDER_FORTIFY,     // hold position; +defense (applied by the colony/site, P2+)
    ORDER_SENTRY,      // skip until something happens
    ORDER_GOTO,        // move toward (target_x, target_y) each turn
    ORDER_CLEAR_PLOW,  // "P" -- clear (forested tile) / plow (open tile), order 8
    ORDER_ROAD,        // "R" -- build road, order 9 (terrain_improvement.md)
    ORDER_TRADE_ROUTE, // "T" -- @ORDERS row 2; EXE order byte 2 (+0x314C, dispatch
                       //   @0x249CB) -> automation func_041080 (trade_routes.md)
    ORDER_FORTIFIED,   // EXE order 6: the ACTIVE fortification. Fortify (EXE 5,
                       //   our ORDER_FORTIFY) is only "in progress"; func_04101C
                       //   promotes 5 -> 6 on the following turn (@0x41024) and
                       //   the 3/2 defense bonus applies only in this state
                       //   (unit_orders.md rows 5/6 -- "not gain the effects
                       //   until the following turn").
};

struct Unit {
    int type    = COLONISTS;   // +0x3146
    int owner   = 0;           // +0x3147 low nibble (power 0..3)
    int x = 0, y = 0;          // +0x3144 / +0x3145
    int profession = 0;        // +0x315B class/profession
    int tools   = 100;         // +0x15 (0x3159) tool count, init 100; each completed
                               //   improvement debits 20 (func_040608 @0x4060F)
    int work    = 0;           // +0x16 (0x315A) improvement work counter, ++ per turn
    // --- per-turn movement/order state (the unit/turn spine) ---
    int  moves_left = 0;       // refreshed to unit_stats().movement each turn
    int  order      = ORDER_NONE;
    int  target_x = -1, target_y = -1;  // ORDER_GOTO destination
    bool alive      = true;    // cleared when destroyed in combat
    // --- computer-player state (spec/systems/ai.md) ---
    int  ai_state = 'X';       // +0x314B persistent AI mode char ('X' = fresh @0x06D84;
                               //   the decoded alphabet is ai.md 4)
    int  ai_spent = 0;         // +0x3149 move-credits SPENT this turn (allowance =
                               //   @UNIT movement x3; one step = 3, ai.md 5)
    int  heading  = 8;         // +0x314F compass heading written by the scorer
                               //   (0..7; 8 = no-move) -- feeds the +4 continuity
                               //   term (@0x047A79) and the turn-cost helper
    int  ai_flags = 0;         // +0x3148 unit flag word (ai.md): bit1 (0x2)
                               //   sentry->fortify toggle (@0x051AB9), bit2 (0x4)
                               //   goal-class-1 gate (@0x04E05C), bit3 (0x8)
                               //   goal-class-7 gate (@0x04E07E), bit4 (0x10)
                               //   long-range explore 'D' (@0x05107C)
    int  ai_steps = 0;         // +0x3156 explore-wander step counter, seeded
                               //   rand(1,0x14) by mission '8' (@0x050D58)
    // --- trade route (trade_routes.md 2): on a ship/wagon the +0x315B byte is
    // route index (low nibble, func_0075D4) + current-stop index (high nibble,
    // func_0075FE) -- the profession byte is unused on those types, so the two
    // uses never collide. Modeled as separate ints; route -1 = none.
    int  route = -1;
    int  route_stop = 0;
    // Cargo holds: @UNIT cargo = hold count (up to 6); each hold carries up to
    // 100 of one good (LOAD primitive func_00B880 caps at 100). good -1 = empty.
    std::array<int, 6> hold_good{{-1, -1, -1, -1, -1, -1}};
    std::array<int, 6> hold_qty{};
    // --- Atlantic crossing (europe_screen.md sail-states; crossing time = 2
    // turns, 1 with Magellan, byte-cited @0x41871). sail > 0 = turns until
    // arrival; sail_dir +1 = sailing to Europe, -1 = to the New World;
    // in_europe = docked in the home port. A crossing/docked unit is off the
    // map (skipped by unit_at + renderers); x,y keep the departure tile.
    int  sail = 0, sail_dir = 0;
    bool in_europe = false;
};

} // namespace vc::sim
