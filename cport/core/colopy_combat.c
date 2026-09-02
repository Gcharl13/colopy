/* The combat-strength modifier chain — game.js:6806 combatAnalysis, which
 * itemises §14.1–14.3 exactly as the Combat Analysis dialog prints it.
 * Ported as a PURE function over explicit parameters so the same arithmetic
 * serves the resolver, the future dialog, and the JS↔C sweep oracle.
 * The floor() chain ORDER is the fidelity — do not reorder. */
#include <stdio.h>
#include "colopy_sim.h"
#include "../data/colopy_data.h"

int terrain_defence(uint8_t v);

/* defenceBonus (game.js): terrain + colony(+2) + fortify orders(+4) +
 * river(+2). Orders 5/6 are Fortify/Fortified. */
static int defence_bonus(const combat_params *p) {
    /* func_007D3E settlement branch (exclusive, @0x7D8D..@0x7DD9) */
    if (p->village_def) return p->village_def;
    int b = terrain_defence(p->terrain);
    if (p->on_colony) b += 2;
    if (p->orders == 5 || p->orders == 6) b += 4;
    if (tile_river(p->terrain)) b += 2;
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
    s = (s * (defence_bonus(p) + 4) / 4) * 3 / 2;
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

/* The Combat Analysis rows — the same chain, itemised exactly as the JS
 * combatAnalysis prints them (spec/ui/combat_analysis.md, func_05E9B0):
 * @MISC label + value per modifier that fired, plus the base strength.
 * The arithmetic is combat_total's; this only names what fired. */
static void row(combat_row *out, int *n, int misc, const char *v) {
    if (*n >= COMBAT_ROWS_MAX) return;
    out[*n].misc = (uint8_t)misc;
    size_t i = 0;
    for (; i + 1 < sizeof(out[*n].value) && v[i]; i++) out[*n].value[i] = v[i];
    out[*n].value[i] = 0;
    (*n)++;
}
int combat_rows(const combat_params *p, combat_row *out, int *base) {
    const dat_units_t *t = &dat_units[p->type];
    int s = t->combat + ((t->cargo && t->hull) ? t->attack : 0);
    if (p->damaged) s -= 2;
    if (s < 1) s = 1;
    *base = s;
    int n = 0;
    char buf[8];                       /* "+150%" at most */
    if (p->veteran) row(out, &n, 65, "+50%");
    if (p->fatigue) row(out, &n, 76, p->fatigue == 2 ? "-66%" : "-33%");
    if (p->holds) {
        snprintf(buf, sizeof(buf), "-%d%%", (int)p->holds * 12);
        row(out, &n, 62, buf);
    }
    {
        int terr = p->village_def ? 0 : terrain_defence(p->terrain);
        if (terr) {
            snprintf(buf, sizeof(buf), "+%d%%", terr * 25);
            row(out, &n, p->is_defender ? 79 : 78, buf);
        }
    }
    if (p->is_defender && p->on_colony) {
        snprintf(buf, sizeof(buf), "+%d%%", ((int)p->colony_level + 1) * 50);
        row(out, &n, 80, buf);
    }
    if (p->orders == 5 || p->orders == 6) row(out, &n, 81, "+50%");
    if (p->is_defender && p->artillery && !p->on_colony) row(out, &n, 84, "-75%");
    if (p->privateer_drake) row(out, &n, 90, "+50%");
    if (p->spain_attacker) row(out, &n, 82, "+50%");
    if (p->woi_ref_bombard) row(out, &n, 104, "+50%");
    if (p->has_home) {
        if (p->home_sol >= 50) {
            snprintf(buf, sizeof(buf), "+%d%%", (int)p->home_sol);
            row(out, &n, 133, buf);
        } else {
            snprintf(buf, sizeof(buf), "-%d%%", 100 - (int)p->home_sol);
            row(out, &n, 132, buf);
        }
    }
    return n;
}
