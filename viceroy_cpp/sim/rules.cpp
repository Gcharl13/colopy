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
    /* 0  Colonists    */ {"Colonists",     0,  1, 0,  1, 1, 0x40},
    /* 1  Soldiers     */ {"Soldiers",      2,  2, 0,  1, 1, 0x1C},
    /* 2  Pioneers     */ {"Pioneers",      0,  1, 0,  1, 1, 0x40},
    /* 3  Missionaries */ {"Missionaries",  0,  1, 0,  1, 2, 0x20},
    /* 4  Dragoons     */ {"Dragoons",      3,  3, 0,  1, 4, 0x3C},
    /* 5  Scouts       */ {"Scouts",        1,  1, 0,  1, 4, 0x64},
    /* 6  Regulars     */ {"Regulars",      5,  5, 0,  1, 1, 0x1C},
    /* 7  Cont. Cav.   */ {"Continental Cavalry", 5, 5, 0, 1, 4, 0x1C},
    /* 8  Cavalry      */ {"Cavalry",        6,  6, 0,  1, 4, 0x1C},
    /* 9  Cont. Army   */ {"Continental Army",4,  4, 0,  1, 1, 0x1C},
    /* 10 Treasure     */ {"Treasure",       0,  0, 0,  6, 1, 0x00},
    /* 11 Artillery    */ {"Artillery",      7,  5, 0,  1, 1, 0x18},
    /* 12 Wagon Train  */ {"Wagon Train",    0,  1, 2,  1, 2, 0x00},   // land hauler (naval band
                                                                 // is 13..18, unit.md)
    /* 13 Caravel      */ {"Caravel",        0,  2, 2, 99, 4, 0xA2},
    /* 14 Merchantman  */ {"Merchantman",    0,  6, 4, 99, 5, 0x82},
    /* 15 Galleon      */ {"Galleon",        0, 10, 6, 99, 6, 0x82},
    /* 16 Privateer    */ {"Privateer",      8,  8, 2, 99, 8, 0x01},
    /* 17 Frigate      */ {"Frigate",       16, 16, 4, 99, 6, 0x81},
    /* 18 Man-O-War    */ {"Man-O-War",     24, 24, 6, 99, 5, 0x81},
    /* 19 Braves       */ {"Braves",         1,  1, 0,  0, 1, 0x38},
    /* 20 Armed Braves */ {"Armed Braves",   2,  2, 0,  0, 1, 0x38},
    /* 21 Mtd. Braves  */ {"Mounted Braves", 2,  2, 0,  0, 4, 0x38},
    /* 22 Mtd. Warriors*/ {"Mounted Warriors",3, 3, 0,  0, 4, 0x38},
    /* 23 (unused)     */ {"",               0,  0, 0,  0, 0, 0x00},
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

// Per-terrain "Improvement" column (@UNFORESTED/@FORESTED/@OTHER improvement --
// the 16-byte terrain record's +2 prefix byte at 0x2F79, map_system.md). This is
// the AI colony-site land-value base contribution (ai.md 3b, func_063F3C):
// unforested {Tundra4,Desert3,Plains3,Prairie3,Grassland3,Savannah3,Marsh5,Swamp7};
// forested 8..15 {Boreal4,Scrub4,Mixed4,Broadleaf4,Conifer4,Tropical6,Wetland6,Rain7}
// (16..23 duplicate via (id&7)|8); Arctic 4, Ocean 2, Sea Lane 2, Mountains 7, Hills 4.
static int default_terrain_improve(int terrain_id) {
    static const int land[8]   = {4, 3, 3, 3, 3, 3, 5, 7};       // ids 0..7
    static const int forest[8] = {4, 4, 4, 4, 4, 6, 6, 7};       // ids 8..15
    if (terrain_id >= 0 && terrain_id <= 7)  return land[terrain_id];
    if (terrain_id >= 8 && terrain_id <= 23) return forest[((terrain_id & 7) | 8) - 8];
    switch (terrain_id) {
        case 24: return 4;   // Arctic
        case 25: return 2;   // Ocean
        case 26: return 2;   // Sea Lane
        case 27: return 7;   // Mountains
        case 28: return 4;   // Hills
    }
    return 0;
}

// Per-terrain "Value" column (the 4th prefix byte @0x2F79 of the 16-byte
// terrain record: Movement @0x2F76 / Defensive @0x2F77 / Improvement @0x2F78 /
// Value @0x2F79 -- the four consecutive byte reads @0x051125, @0x7E63,
// @0x040727 and func_063F3C pin the order). This is the colony-site
// desirability stat the AI's F9 land-value formula sums (ai.md 3b).
static int default_terrain_value(int terrain_id) {
    static const int land[8]   = {2, 2, 4, 4, 4, 4, 2, 2};       // ids 0..7
    static const int forest[8] = {3, 1, 3, 3, 3, 3, 1, 1};       // ids 8..15
    if (terrain_id >= 0 && terrain_id <= 7)  return land[terrain_id];
    if (terrain_id >= 8 && terrain_id <= 23) return forest[((terrain_id & 7) | 8) - 8];
    switch (terrain_id) {
        case 24: return 0;   // Arctic
        case 25: return 3;   // Ocean
        case 26: return 0;   // Sea Lane
        case 27: return 2;   // Mountains
        case 28: return 2;   // Hills
    }
    return 0;
}

// NAMES @CARGO market columns per good: {price_start1, price_start2, drift_low, drift_high,
// burden}. Value-identical to data_extracted/tables/names_tables.json @CARGO (asserted by the
// tools/verify_rules.py oracle, same as @UNIT). Order = the Good enum (Food..Muskets).
static const CargoStats kDefaultCargo[NGOODS] = {
    {1, 3, 1, 6, 7},      // Food
    {4, 7, 3, 7, 1},      // Sugar
    {3, 5, 2, 5, 1},      // Tobacco
    {2, 5, 2, 5, 1},      // Cotton
    {4, 6, 2, 6, 1},      // Furs
    {2, 2, 2, 2, 4},      // Lumber
    {3, 6, 2, 6, 2},      // Ore
    {20, 20, 2, 20, 0},   // Silver
    {2, 3, 2, 11, 0},     // Horses
    {11, 13, 1, 20, 0},   // Rum
    {11, 13, 1, 20, 0},   // Cigars
    {11, 13, 1, 20, 0},   // Cloth
    {11, 13, 1, 20, 0},   // Coats
    {2, 3, 2, 12, 0},     // Trade Goods
    {2, 2, 2, 9, 0},      // Tools
    {3, 3, 2, 20, 0},     // Muskets
};

// NAMES @JOB training columns per profession: {school_tier, value}. Column 3 = the minimum
// school level to teach the skill (1 Schoolhouse / 2 College / 3 University / 4 not taught);
// column 4 = the expert's gold value. Value-identical to names_tables.json @JOB (asserted by
// the tools/verify_rules.py oracle). Order = the @JOB row order (Farmer..Convert).
static const JobStats kDefaultJobs[NJOBS] = {
    {1, 1100},  // Farmer
    {2, -1},    // Sugar Planter
    {2, -1},    // Tobacco Planter
    {2, -1},    // Cotton Planter
    {1, -1},    // Fur Trapper
    {1, 700},   // Lumberjack
    {1, 600},   // Ore Miner
    {1, 900},   // Silver Miner
    {1, 1000},  // Fisherman
    {2, 1100},  // Distiller
    {2, 1200},  // Tobacconist
    {2, 1300},  // Weaver
    {2, 950},   // Fur Trader
    {1, 1000},  // Carpenter
    {2, 1050},  // Blacksmith
    {2, 850},   // Gunsmith
    {3, 1500},  // Preacher
    {3, 1900},  // Statesman
    {4, -1},    // Teacher
    {4, -1},    // Colonist
    {1, 1200},  // Pioneer
    {2, 2000},  // Soldier
    {1, -1},    // Scout
    {2, -1},    // Dragoon
    {3, 1400},  // Missionary
    {4, -1},    // Ind. Servant
    {4, -1},    // Criminal
    {4, -1},    // Convert
};

RuleData make_default_rules() {
    RuleData rd;
    for (int i = 0; i < NUNITTYPES; ++i) rd.units[i] = kDefaultUnits[i];
    for (int id = 0; id < NTERRAIN; ++id) {
        rd.terrain_defense[id] = default_terrain_defense(id);
        rd.terrain_move[id]    = default_terrain_move(id);
        rd.terrain_improve[id] = default_terrain_improve(id);
        rd.terrain_value[id]   = default_terrain_value(id);
    }
    for (int g = 0; g < NGOODS; ++g) rd.cargo[g] = kDefaultCargo[g];
    for (int j = 0; j < NJOBS; ++j) rd.jobs[j] = kDefaultJobs[j];
    return rd;
}

const RuleData& default_rules() {
    static const RuleData rd = make_default_rules();
    return rd;
}

} // namespace vc::sim
