// sim/diplomacy.cpp -- see diplomacy.hpp.
#include "diplomacy.hpp"

namespace vc::sim {

void declare_war(Diplomacy& d, int a, int b) {
    d.war[a][b] |= WAR_AT_WAR; d.war[b][a] |= WAR_AT_WAR;
    d.rel[a][b] |= REL_WAR;    d.rel[b][a] |= REL_WAR;
    d.rel[a][b] &= ~REL_TREATY; d.rel[b][a] &= ~REL_TREATY;
}

void make_peace(Diplomacy& d, int a, int b) {
    d.war[a][b] &= ~WAR_AT_WAR; d.war[b][a] &= ~WAR_AT_WAR;
    d.rel[a][b] &= ~REL_WAR;    d.rel[b][a] &= ~REL_WAR;
}

bool at_war(const Diplomacy& d, int a, int b) {
    return (d.war[a][b] & WAR_AT_WAR) != 0;
}

void sign_treaty(Diplomacy& d, int a, int b, int turn) {
    d.rel[a][b] |= REL_TREATY; d.rel[b][a] |= REL_TREATY;
    make_peace(d, a, b);
    d.cooldown[a] = d.cooldown[b] = treaty_cooldown(turn);
}

bool has_treaty(const Diplomacy& d, int a, int b) {
    return (d.rel[a][b] & REL_TREATY) != 0;
}

bool ai_acts(int attitude, int demand_score, const RandFn& rng) {
    bool restrained = ((attitude >> 2) > demand_score) &&
                      (demand_score > 12) &&
                      (rng(0, 4) != 0);
    return !restrained;
}

} // namespace vc::sim
