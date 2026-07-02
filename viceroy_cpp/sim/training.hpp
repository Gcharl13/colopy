// sim/training.hpp -- colonist training: the school teaching mechanic.
//
// spec/systems/training.md 3 "Schoolhouse teaching" (BYTE-VERIFIED, func_02D658
// @0x02DDB4..0x02E012, the per-colony turn processor):
//   - building ids: Schoolhouse 0x0C, College 0x0D, University 0x0E (bits 12/13/14
//     of the colony building bitmap);
//   - a school of level L teaches only professions whose @JOB school tier <= L
//     (1 = Schoolhouse, 2 = College, 3 = University; tier >= 4 = not teachable);
//   - faculty cap = the school level (Schoolhouse 1 / College 2 / University 3,
//     hard cap 3 -- cmp [bp-0x6C],3 @0x02DE5B);
//   - each teacher advances ONE randomly-picked student's per-student counter each
//     turn (random_int @0x02DEC5; counter via 0x181F:0xD1C, reset on graduation);
//   - turns-to-graduate = 4 / 6 / 8 by the taught profession's tier
//     (@0x02DDB4 / @0x02DE98 / @0x02DE8E);
//   - on graduation a free colonist learns the teacher's profession outright
//     (@0x02DF70). The EXE's promote-one-tier branch (criminal->servant->colonist)
//     applies to the dock CLASS ladder, which this colony model does not carry --
//     every in-colony Worker is already a working colonist, so the learn-outright
//     branch is the one that applies (adaptation noted, not invented).
#pragma once

#include "types.hpp"
#include "rules.hpp"
#include "immigration.hpp"   // RandFn

namespace vc::sim {

// The colony's school level: 3 University / 2 College / 1 Schoolhouse / 0 none.
int school_level(const Colony& c);

// One colony-turn of school teaching (part of the per-colony turn processor).
void school_teach_step(Colony& c, const RuleData& rd, const RandFn& rng);

// --- Native learning ("live among the Indians", spec/systems/training.md 3) ---
// Learnable skills are the outdoors/gathering experts ONLY (the player-aid chart's
// `*` rows): Farmer(0), Sugar/Tobacco/Cotton Planter(1..3), Fur Trapper(4),
// Silver Miner(7), Fisherman(8), Scout(22). Manufacturing skills are not learnable.
bool native_learnable(int job);

enum class LearnResult {
    LEARNED,            // @LEARNDONE  -- "become a master ..."; expertise granted
    STAYED,             // @LEARNSLOW  -- the unskilled learn slowly; roll failed, stays
    REFUSED_CRIMINAL,   // @LEARNCRIMINAL -- Petty Criminals cannot learn
    REFUSED_MASTER,     // @LEARNMASTER   -- already a master, refused
    REFUSED_TAUGHT,     // @LEARNALREADY  -- each village teaches only once
};

// Ask the village to teach the colonist. unit_class = the +0x315B class byte
// (free colonist / indentured learn with the roll; the Criminal class is refused --
// NOTE: training.md and immigration.md read the 0x19/0x1A criminal-vs-servant codes
// oppositely; the sim keeps immigration.cpp's constants, the SEMANTIC -- criminals
// refused -- is what both agree on). village_skill = the settlement's @JOB skill;
// village_taught = the +0x03 bit-0x02 once-only latch (stamped on success,
// @0x04A78A). Success for the unskilled iff random_int(1,1000) >= 200*difficulty
// + 100 (@0x4A72C) => P ~ 90/70/50/30/10% by difficulty. On success unit_class
// becomes the village skill (the +0x17 expertise write, grant site @0x04A782).
LearnResult native_learn(int& unit_class, int village_skill, bool& village_taught,
                         int difficulty, const RandFn& rng);

} // namespace vc::sim
