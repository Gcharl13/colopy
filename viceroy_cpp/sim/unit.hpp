// sim/unit.hpp -- unit model + @UNIT stat table (spec/systems/unit.md).
//
// UnitRecord base DGROUP:0x3144, stride 0x1C; @UNIT stat table DGROUP:0x5230
// stride 14, indexed type*14 (attack col @0x5236, defense @0x5235). For ships
// the attack/defense shown here are the Guns/Hull columns.
#pragma once

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

// Standing order for a unit (spec/systems/unit_orders.md, subset for the spine).
enum Order : int {
    ORDER_NONE = 0,    // idle (manual control each turn)
    ORDER_FORTIFY,     // hold position; +defense (applied by the colony/site, P2+)
    ORDER_SENTRY,      // skip until something happens
    ORDER_GOTO,        // move toward (target_x, target_y) each turn
    ORDER_CLEAR_PLOW,  // "P" -- clear (forested tile) / plow (open tile), order 8
    ORDER_ROAD,        // "R" -- build road, order 9 (terrain_improvement.md)
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
};

} // namespace vc::sim
