// sim/unit.cpp -- see unit.hpp. @UNIT stat table from data_extracted @UNIT
// (NAMES_sections.json), columns attack/defense/cargo/move-class.
#include "unit.hpp"

namespace vc::sim {

// 24 rows (0..23). Row 23 is not present in the extracted @UNIT (left zeroed).
static const UnitStats kStats[NUNITTYPES] = {
    /* 0  Colonists    */ {"Colonists",     0,  1, 0,  1},
    /* 1  Soldiers     */ {"Soldiers",      2,  2, 0,  1},
    /* 2  Pioneers     */ {"Pioneers",      0,  1, 0,  1},
    /* 3  Missionaries */ {"Missionaries",  0,  1, 0,  1},
    /* 4  Dragoons     */ {"Dragoons",      3,  3, 0,  1},
    /* 5  Scouts       */ {"Scouts",        1,  1, 0,  1},
    /* 6  Regulars     */ {"Regulars",      5,  5, 0,  1},
    /* 7  Cont. Cav.   */ {"Continental Cavalry", 5, 5, 0, 1},
    /* 8  Cavalry      */ {"Cavalry",        6,  6, 0,  1},
    /* 9  Cont. Army   */ {"Continental Army",4,  4, 0,  1},
    /* 10 Treasure     */ {"Treasure",       0,  0, 0,  6},
    /* 11 Artillery    */ {"Artillery",      7,  5, 0,  1},
    /* 12 Wagon Train  */ {"Wagon Train",    0,  1, 2, 99},
    /* 13 Caravel      */ {"Caravel",        0,  2, 2, 99},
    /* 14 Merchantman  */ {"Merchantman",    0,  6, 4, 99},
    /* 15 Galleon      */ {"Galleon",        0, 10, 6, 99},
    /* 16 Privateer    */ {"Privateer",      8,  8, 2, 99},
    /* 17 Frigate      */ {"Frigate",       16, 16, 4, 99},
    /* 18 Man-O-War    */ {"Man-O-War",     24, 24, 6, 99},
    /* 19 Braves       */ {"Braves",         1,  1, 0,  0},
    /* 20 Armed Braves */ {"Armed Braves",   2,  2, 0,  0},
    /* 21 Mtd. Braves  */ {"Mounted Braves", 2,  2, 0,  0},
    /* 22 Mtd. Warriors*/ {"Mounted Warriors",3, 3, 0,  0},
    /* 23 (unused)     */ {"",               0,  0, 0,  0},
};

const UnitStats& unit_stats(int type) {
    static const UnitStats zero{"", 0, 0, 0, 0};
    if (type < 0 || type >= NUNITTYPES) return zero;
    return kStats[type];
}

} // namespace vc::sim
