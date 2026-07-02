// sim/training.cpp -- see training.hpp for the byte citations.
#include "training.hpp"

#include <algorithm>
#include <vector>

namespace vc::sim {

namespace {
constexpr int SCHOOLHOUSE = 12;   // building id 0x0C
constexpr int COLLEGE     = 13;   // building id 0x0D
constexpr int UNIVERSITY  = 14;   // building id 0x0E
} // namespace

int school_level(const Colony& c) {
    if ((c.built_mask >> UNIVERSITY) & 1ull)  return 3;
    if ((c.built_mask >> COLLEGE) & 1ull)     return 2;
    if ((c.built_mask >> SCHOOLHOUSE) & 1ull) return 1;
    return 0;
}

void school_teach_step(Colony& c, const RuleData& rd, const RandFn& rng) {
    const int level = school_level(c);
    if (level <= 0) return;
    // Faculty: expert colonists working a building slot (tile < 0) whose profession the
    // school's level can teach. Students: every non-expert colonist.
    std::vector<int> teachers, students;
    for (int i = 0; i < (int)c.workers.size(); ++i) {
        const Colony::Worker& w = c.workers[i];
        const int tier = (w.profession >= 0 && w.profession < NJOBS)
                             ? rd.jobs[w.profession].school_tier : 4;
        if (w.expert && w.tile < 0 && tier >= 1 && tier <= level) teachers.push_back(i);
        else if (!w.expert) students.push_back(i);
    }
    int cap = level;                                       // Schoolhouse 1 / College 2 / University 3
    if (cap > rd.cfg.school_faculty_cap) cap = rd.cfg.school_faculty_cap;
    if ((int)teachers.size() > cap) teachers.resize(cap);
    for (int ti : teachers) {
        if (students.empty()) return;                      // @TRAINFAIL: no eligible student
        const int pick = (int)rng(0, (int)students.size() - 1);   // random student @0x02DEC5
        const int si = students[pick];
        Colony::Worker& s = c.workers[si];
        const int tier = rd.jobs[c.workers[ti].profession].school_tier;
        const int need = tier == 1 ? rd.cfg.school_turns_t1
                       : tier == 2 ? rd.cfg.school_turns_t2
                                   : rd.cfg.school_turns_t3;
        if (++s.teach >= need) {                           // graduation (@TRAINPROFESSION)
            s.profession = c.workers[ti].profession;
            s.expert = true;
            s.teach = 0;
            students.erase(students.begin() + pick);       // not a student twice in one turn
        }
    }
}

bool native_learnable(int job) {
    switch (job) {
        case 0: case 1: case 2: case 3:   // Farmer, Sugar/Tobacco/Cotton Planter
        case 4:                           // Fur Trapper
        case 7:                           // Silver Miner
        case 8:                           // Fisherman
        case 22:                          // Scout (Seasoned)
            return true;
        default: return false;            // manufacturing skills are not Indian-learnable
    }
}

LearnResult native_learn(int& unit_class, int village_skill, bool& village_taught,
                         int difficulty, const RandFn& rng) {
    constexpr int PETTY_CRIMINAL     = 0x19;   // the class immigration.cpp names Criminal
    constexpr int INDENTURED_SERVANT = 0x1A;
    constexpr int FREE_COLONIST      = 0x1C;
    if (village_taught) return LearnResult::REFUSED_TAUGHT;          // @LEARNALREADY
    if (unit_class == PETTY_CRIMINAL) return LearnResult::REFUSED_CRIMINAL;
    if (unit_class != FREE_COLONIST && unit_class != INDENTURED_SERVANT)
        return LearnResult::REFUSED_MASTER;                          // already skilled/master
    // Slow-learner roll (@0x4A72C): random_int(1,1000) >= 200*difficulty + 100.
    if (rng(1, 1000) < 200 * difficulty + 100) return LearnResult::STAYED;   // @LEARNSLOW
    unit_class = village_skill;                                      // expertise grant @0x04A782
    village_taught = true;                                           // once-only latch @0x04A78A
    return LearnResult::LEARNED;                                     // @LEARNDONE
}

} // namespace vc::sim
