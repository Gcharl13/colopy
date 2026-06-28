// sim/rules.cpp -- the default ruleset, value-identical to the original literals.
// (Previously these lived as file-static tables in unit.cpp / combat.cpp.)
#include "rules.hpp"

namespace vc::sim {

// @UNIT stats (24 rows, 0..23; row 23 unused/zeroed). attack <- @UNIT.attack,
// defense <- @UNIT.combat, cargo <- @UNIT.cargo, movement <- @UNIT.movement
// (value-identical across all rows, ships included). name + move_class are
// code-side structural fields (see header). Columns: {name, atk, def, cargo,
// move_class, movement}.
static const UnitStats kDefaultUnits[NUNITTYPES] = {
    /* 0  Colonists    */ {"Colonists",     0,  1, 0,  1, 1},
    /* 1  Soldiers     */ {"Soldiers",      2,  2, 0,  1, 1},
    /* 2  Pioneers     */ {"Pioneers",      0,  1, 0,  1, 1},
    /* 3  Missionaries */ {"Missionaries",  0,  1, 0,  1, 2},
    /* 4  Dragoons     */ {"Dragoons",      3,  3, 0,  1, 4},
    /* 5  Scouts       */ {"Scouts",        1,  1, 0,  1, 4},
    /* 6  Regulars     */ {"Regulars",      5,  5, 0,  1, 1},
    /* 7  Cont. Cav.   */ {"Continental Cavalry", 5, 5, 0, 1, 4},
    /* 8  Cavalry      */ {"Cavalry",        6,  6, 0,  1, 4},
    /* 9  Cont. Army   */ {"Continental Army",4,  4, 0,  1, 1},
    /* 10 Treasure     */ {"Treasure",       0,  0, 0,  6, 1},
    /* 11 Artillery    */ {"Artillery",      7,  5, 0,  1, 1},
    /* 12 Wagon Train  */ {"Wagon Train",    0,  1, 2, 99, 2},
    /* 13 Caravel      */ {"Caravel",        0,  2, 2, 99, 4},
    /* 14 Merchantman  */ {"Merchantman",    0,  6, 4, 99, 5},
    /* 15 Galleon      */ {"Galleon",        0, 10, 6, 99, 6},
    /* 16 Privateer    */ {"Privateer",      8,  8, 2, 99, 8},
    /* 17 Frigate      */ {"Frigate",       16, 16, 4, 99, 6},
    /* 18 Man-O-War    */ {"Man-O-War",     24, 24, 6, 99, 5},
    /* 19 Braves       */ {"Braves",         1,  1, 0,  0, 1},
    /* 20 Armed Braves */ {"Armed Braves",   2,  2, 0,  0, 1},
    /* 21 Mtd. Braves  */ {"Mounted Braves", 2,  2, 0,  0, 4},
    /* 22 Mtd. Warriors*/ {"Mounted Warriors",3, 3, 0,  0, 4},
    /* 23 (unused)     */ {"",               0,  0, 0,  0, 0},
};

// Per-terrain "Defensive" value (@TERRAIN): open 0, marsh/swamp 1, forest 2,
// rain 3, hills 4, mountains 6. Forest ids 8..23 normalize via (id&7)|8; the
// canonical Rain Forest id 15 (and its duplicate encoding 23) get 3.
static int default_terrain_defense(int terrain_id) {
    switch (terrain_id) {
        case 6: case 7: return 1;          // Marsh, Swamp
        case 27: return 6;                  // Mountains
        case 28: return 4;                  // Hills
    }
    if (terrain_id >= 8 && terrain_id <= 23) {
        int canon = (terrain_id & 7) | 8;
        return canon == 15 ? 3 : 2;
    }
    return 0;                               // open land / ocean / arctic / sea-lane
}

// Per-terrain move-points to ENTER (@UNFORESTED/@FORESTED/@OTHER "movement"):
// open land 1, marsh/swamp 2; forested 8..15 {Boreal2,Scrub1,Mixed2,Broadleaf2,
// Conifer2,Tropical2,Wetland3,Rain3}; 16..23 duplicate 8..15 via (id&7)|8;
// Arctic 2, Ocean 1, Sea Lane 1, Mountains 3, Hills 2.
static int default_terrain_move(int terrain_id) {
    static const int land[8]   = {1, 1, 1, 1, 1, 1, 2, 2};       // ids 0..7
    static const int forest[8] = {2, 1, 2, 2, 2, 2, 3, 3};       // ids 8..15
    if (terrain_id >= 0 && terrain_id <= 7)  return land[terrain_id];
    if (terrain_id >= 8 && terrain_id <= 23) return forest[((terrain_id & 7) | 8) - 8];
    switch (terrain_id) {
        case 24: return 2;   // Arctic
        case 25: return 1;   // Ocean
        case 26: return 1;   // Sea Lane
        case 27: return 3;   // Mountains
        case 28: return 2;   // Hills
    }
    return 1;
}

RuleData make_default_rules() {
    RuleData rd;
    for (int i = 0; i < NUNITTYPES; ++i) rd.units[i] = kDefaultUnits[i];
    for (int id = 0; id < NTERRAIN; ++id) {
        rd.terrain_defense[id] = default_terrain_defense(id);
        rd.terrain_move[id]    = default_terrain_move(id);
    }
    return rd;
}

const RuleData& default_rules() {
    static const RuleData rd = make_default_rules();
    return rd;
}

} // namespace vc::sim
