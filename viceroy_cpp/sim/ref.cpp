// sim/ref.cpp -- see ref.hpp.
#include "ref.hpp"

namespace vc::sim {

Ref ref_start(int d) {
    Ref r;
    r.regulars  = 8 * d + 15;
    r.cavalry   = 5 * (d + 1);
    r.manowar   = 3 * d + 2;
    r.artillery = 6 * d + 2;
    return r;
}

int ref_accrue_rate(int d, int year) {
    int rate = 8 * d + 10;
    if (year >= 1600) rate *= 2;
    if (year >= 1700) rate *= 2;
    if (year >= 1750) rate *= 2;
    return rate;
}

void ref_purchase(Ref& ref, int64_t& royal_money) {
    while (royal_money >= 1800) {
        if (ref.regulars + 2 > 3 * ref.cavalry)
            ref.cavalry += 1;                       // 1 cav per 3 reg
        else if (ref.regulars > 4 * ref.artillery)
            ref.artillery += 1;                     // 1 art per 4 reg
        else if (ref.regulars + ref.cavalry + ref.artillery + 5 > 10 * ref.manowar)
            ref.manowar += 1;                       // 1 naval per 10 land
        else
            ref.regulars += 1;                      // default
        royal_money -= 1800;
    }
}

} // namespace vc::sim
