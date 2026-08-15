/* The combat-strength modifier chain — game.js:6806 combatAnalysis, which
 * itemises §14.1–14.3 exactly as the Combat Analysis dialog prints it.
 * Ported as a PURE function over explicit parameters so the same arithmetic
 * serves the resolver, the future dialog, and the JS↔C sweep oracle.
 * The floor() chain ORDER is the fidelity — do not reorder. */
#include "colopy_sim.h"
#include "colopy_data.h"

int terrain_defence(uint8_t v);

/* defenceBonus (game.js): terrain + colony(+2) + fortify orders(+4) +
 * river(+2). Orders 5/6 are Fortify/Fortified. */
static int defence_bonus(uint8_t terrain, int on_colony, uint8_t orders) {
    int b = terrain_defence(terrain);
    if (on_colony) b += 2;
    if (orders == 5 || orders == 6) b += 4;
    if (tile_river(terrain)) b += 2;
    return b;
}

int combat_total(const combat_params *p) {
    const dat_units_t *t = &dat_units[p->type];
    /* §14.1: combat column; a cargo-carrying warship adds attack; damage -2 */
    int s = t->combat + ((t->cargo && t->hull) ? t->attack : 0);
    if (p->damaged) s -= 2;
    if (s < 1) s = 1;
    /* veteran +50% */
    if (p->veteran) s = s * 3 / 2;
    /* fatigue: -33% spent-a-third, -66% truly spent */
    if (p->fatigue) s = s * (p->fatigue == 2 ? 1 : 2) / 3;
    /* cargo aboard: -12.5% per used hold */
    if (p->holds) {
        int h = p->holds > 8 ? 8 : p->holds;
        s = s * (8 - h) / 8;
    }
    /* §14.3 step 1: accumulated terrain/fort bonus, then the flat 3/2 */
    s = (s * (defence_bonus(p->terrain, p->on_colony, p->orders) + 4) / 4) * 3 / 2;
    /* step 2: difficulty handicap, both sides */
    s += 4 - p->difficulty;
    /* step 4: a colony on the defending tile */
    if (p->is_defender && p->on_colony) s = s * 3 / 2;
    /* fortified */
    if (p->orders == 5 || p->orders == 6) s = s * 3 / 2;
    /* artillery in the open defends at a quarter */
    if (p->is_defender && p->artillery && !p->on_colony) s = s / 4;
    /* Drake's privateers */
    if (p->privateer_drake) s = s * 3 / 2;
    /* Spain attacking (vs-native clause as the JS carries it) */
    if (p->spain_attacker) s = s * 3 / 2;
    /* wartime bombardment of the King's landed force */
    if (p->woi_ref_bombard) s = s * 3 / 2;
    /* (the Tory/Rebel row is display-only in the JS chain — no s change) */
    /* step 7 */
    s += s * p->difficulty / 20;
    return s < 1 ? 1 : s;
}
