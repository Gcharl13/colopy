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
    int attack;       // @UNIT col2 (land) / Guns (ship)
    int defense;      // @UNIT col3 (land) / Hull (ship)
    int cargo;        // hold capacity
    int move_class;   // 99 = naval/free
};

struct RuleData;   // sim/rules.hpp -- the injected, data-driven parameter set.

// Stats for a unit type (0..23); out-of-range -> a zeroed entry.
//   unit_stats(rd, type)  reads from the injected ruleset (preferred).
//   unit_stats(type)      falls back to default_rules() (value-identical).
const UnitStats& unit_stats(const RuleData& rd, int type);
const UnitStats& unit_stats(int type);

struct Unit {
    int type    = COLONISTS;   // +0x3146
    int owner   = 0;           // +0x3147 low nibble (power 0..3)
    int x = 0, y = 0;          // +0x3144 / +0x3145
    int profession = 0;        // +0x315B class/profession
};

} // namespace vc::sim
