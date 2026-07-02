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

} // namespace vc::sim
