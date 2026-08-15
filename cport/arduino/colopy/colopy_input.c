/* C-port Phase 8 slice 1 — the keyboard input layer.
 *
 * A transcription of the JS onKey dispatcher (port/src/game.js:12394)
 * over the C records: the boot flow (§26.1-26.4 keys), the map screen's
 * key vocabulary (movement/orders/reports/pulldowns, §27.1), and the
 * report exit — each key handler mutating the same UI state the Phase-7
 * renderers draw and calling the Phase-5 command layer for the sim
 * side.  Slice 1 covers the keys the shared input script exercises
 * (boot navigation, viewMode panning, the unit cycle with its endTurn
 * rollover, orders, F-key reports, pulldown navigation); the pointer
 * layer and the remaining screen vocabularies follow in later slices. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "colopy_sim.h"
#include "colopy_data.h"
#include "colopy_ui.h"
#include "colopy_render.h"
#include "colopy_input.h"

colopy_ui UI;

#define VIEW_COLS 15
#define VIEW_ROWS 12

void ui_init(void) {
    memset(&UI, 0, sizeof(UI));
    UI.screen = SCR_TITLE;
    UI.open_menu = -1;
    UI.market_sel = -1;
    UI.sel = 0;
}

/* centerOn (game.js:758) */
static void center_on(int tx, int ty) {
    int x = tx - (VIEW_COLS >> 1), y = ty - (VIEW_ROWS >> 1);
    if (x > COLOPY_MAP_W - VIEW_COLS) x = COLOPY_MAP_W - VIEW_COLS;
    if (y > COLOPY_MAP_H - VIEW_ROWS) y = COLOPY_MAP_H - VIEW_ROWS;
    if (x < 0) x = 0;
    if (y < 0) y = 0;
    UI.view_x = x;
    UI.view_y = y;
}

static int sel_unit(void) {
    if (UI.sel < 0 || UI.sel >= CR.n_units_order) return -1;
    return CR.units_order[UI.sel];
}

/* nextUnit (game.js:11168): the next unit with moves, view centred */
static int next_unit(void) {
    int n = CR.n_units_order;
    for (int i = 1; i <= n; i++) {
        int k = (UI.sel + i) % n;
        int ui = CR.units_order[k];
        if (!CR.unit_moves_undef[ui] && CS.units[ui].moves_remaining > 0) {
            UI.sel = k;
            center_on(CS.units[ui].map_x, CS.units[ui].map_y);
            return 1;
        }
    }
    return 0;
}

/* endTurn = the full parity-verified step chain (host --turns order) */
static void end_turn(void) {
    turn_step_prefix();
    turn_step2();
    turn_step3();
    turn_step5();
}

/* advance (game.js:10866) */
static void advance(void) {
    if (!next_unit()) {
        end_turn();
        next_unit();
        /* an askZoom answered 1 during the turn opened a colony
         * (game.js:6378) — the input layer applies it */
        if (CR.zoom_colony >= 0) {
            UI.colony = (int8_t)CR.zoom_colony;
            UI.screen = SCR_COLONY;
            CR.zoom_colony = -1;
        }
    }
}

/* openMenu (game.js:1874): first non-separator row selected */
static void open_menu(int mi) {
    rm_mrow rows[64];
    int n = rm_menu_rows(mi, UI.sel, rows);
    UI.open_menu = (int8_t)mi;
    UI.menu_sel = 0;
    for (int i = 0; i < n; i++)
        if (!rows[i].sep) { UI.menu_sel = (int8_t)i; break; }
}

/* runMenuRow (game.js:1880): the menu closes FIRST, then the row's
 * command runs; dim rows and separators are inert.  Slice 2 binds the
 * rows whose commands exist in the C — the rest are explicit no-ops
 * (the shared script only exercises bound rows). */
static void run_menu_row(void) {
    if (UI.open_menu < 0) return;
    rm_mrow rows[64];
    int n = rm_menu_rows(UI.open_menu, UI.sel, rows);
    const rm_mrow *r = (UI.menu_sel >= 0 && UI.menu_sel < n)
                           ? &rows[UI.menu_sel] : 0;
    UI.open_menu = -1;
    if (getenv("COLOPY_INPUT_DBG"))
        fprintf(stderr, "runrow sel=%d n=%d ms=%d label=%s dim=%d sep=%d\n",
                UI.sel, n, UI.menu_sel, r && r->label ? r->label : "(null)",
                r ? r->dim : -1, r ? r->sep : -1);
    if (!r || r->sep || r->dim || !r->label) return;
    const char *l = r->label;
    int ui = sel_unit();
    if (strcmp(l, "Activate unit") == 0) {
        if (ui >= 0) cmd_activate(ui);
    } else if (strcmp(l, "Wait for next unit") == 0) {
        next_unit();
    } else if (strcmp(l, "Fortify") == 0) {
        if (ui >= 0) { cmd_set_order(ui, 5); advance(); }
    } else if (strcmp(l, "Sentry") == 0) {
        if (ui >= 0) { cmd_set_order(ui, 1); advance(); }
    } else if (strcmp(l, "No Orders (space bar)") == 0) {
        if (ui >= 0) { cmd_skip(ui); advance(); }
    } else if (strcmp(l, "Move Pieces") == 0) {
        UI.view_mode = 0;
    } else if (strcmp(l, "View Pieces") == 0) {
        UI.view_mode = 1;
    } else if (strcmp(l, "European Status") == 0) {
        if ((CR.woi_flags & WOI_DECLARED) && !(CR.woi_flags & WOI_WON))
            ev_emit("EUROPENOTAVAIL", 0, 0, 0, 0);
        else
            UI.screen = SCR_EUROPE;
    } else if (strcmp(l, "Center View") == 0) {
        if (ui >= 0) center_on(CS.units[ui].map_x, CS.units[ui].map_y);
    } else if (strcmp(l, "Show Hidden Terrain") == 0) {
        UI.show_hidden = (int8_t)!UI.show_hidden;
    } else if (l[0] == 'F' && l[1] >= '1' && l[1] <= '9') {
        /* the REPORTS ladder rows: "F<N> <Adviser>" */
        int fn = l[1] - '0';
        int off = 2;
        if (l[2] >= '0' && l[2] <= '9') { fn = fn * 10 + l[2] - '0'; off = 3; }
        if (l[off] == ' ') {
            if (fn == 1) return;             /* pedia: a later slice */
            if (fn == 8 && (CR.woi_flags & WOI_DECLARED) &&
                !(CR.woi_flags & WOI_WON)) {
                ev_emit("FOREIGNNOTAVAIL", 0, 0, 0, 0);
                return;
            }
            if (fn >= 2 && fn <= 10) {
                snprintf(UI.report, sizeof(UI.report), "F%d", fn);
                UI.screen = SCR_REPORT;
            }
        }
    }
    /* every other MENU.TXT row: unbound in this slice (dialog flows,
     * zoom, trade routes, pedia) — the script does not send them */
}

static int key_is(const char *k, const char *want) {
    return strcmp(k, want) == 0;
}

/* ---- the numeric-entry dialog (askAmount, game.js:969) ----------------
 * The shared conventions stub openDialog but NOT askAmount, so the
 * @HOWMUCH amount dialogs are LIVE modals on both sides: dialogKey
 * (game.js:12403) captures every key while one is open — digits append
 * (cap 23), Backspace trims, Enter commits the entry (an EMPTY entry
 * takes the FULL amount, the port's flagged convenience reading),
 * Escape cancels a numeric dialog to 0.  A click commits like Enter
 * (dialogClick's non-opts arm, game.js:12410). */
static void dialog_done(int cancel) {
    int32_t qty;
    if (cancel) {
        qty = 0;                             /* closeDialog(-1) -> 0 */
    } else if (!UI.dlg_entry[0]) {
        qty = UI.dlg_max;
    } else {
        long v = strtol(UI.dlg_entry, 0, 10);
        qty = v < 0 ? 0 : v > UI.dlg_max ? UI.dlg_max : (int32_t)v;
    }
    int kind = UI.dlg;
    UI.dlg = 0;
    UI.dlg_entry[0] = 0;
    if (!qty) return;                /* every finish() gates on qty */
    if (kind == 1) {                 /* HOWMUCH5 finish (game.js:4795) */
        euro_sell_from_ship(UI.dlg_port, UI.dlg_good, qty);
    } else if (kind == 2) {          /* HOWMUCH1: load (game.js:11247) */
        ColonyRecord *c = &CS.colonies[UI.dlg_port];
        c->stock[UI.dlg_good] = (uint16_t)(c->stock[UI.dlg_good] - qty);
        hold_add(CR.unit_hold[UI.dlg_unit], &CR.unit_n_hold[UI.dlg_unit],
                 UI.dlg_good, qty);
    } else if (kind == 3) {          /* HOWMUCH2: unload (game.js:11268) */
        ColonyRecord *c = &CS.colonies[UI.dlg_port];
        hold_add(CR.unit_hold[UI.dlg_unit], &CR.unit_n_hold[UI.dlg_unit],
                 UI.dlg_good, -qty);
        c->stock[UI.dlg_good] = (uint16_t)(c->stock[UI.dlg_good] + qty);
    }
}
static void dialog_key(const char *k) {
    if (key_is(k, "Enter")) { dialog_done(0); return; }
    if (key_is(k, "Escape")) { dialog_done(1); return; }
    if (key_is(k, "Backspace")) {
        size_t n = strlen(UI.dlg_entry);
        if (n) UI.dlg_entry[n - 1] = 0;
        return;
    }
    if (k[0] && !k[1] && k[0] >= '0' && k[0] <= '9') {
        size_t n = strlen(UI.dlg_entry);
        if (n < 23) { UI.dlg_entry[n] = k[0]; UI.dlg_entry[n + 1] = 0; }
    }
}
/* the player colony record standing on a tile (colonyAt, game.js) */
static int colony_rec_at_xy(int x, int y) {
    for (int i = 0; i < CS.n_colonies; i++)
        if ((CS.colonies[i].owner_power & 3) == (int)cs_nation() &&
            CS.colonies[i].map_x == x && CS.colonies[i].map_y == y)
            return i;
    return -1;
}

/* sellFromShip(G.marketSel) with no qty (game.js:4783): no port ship or
 * nothing aboard = euroMsg only; a boycotted good runs the @KISSUP
 * back-tax ask at once; else the @HOWMUCH5 modal opens with max = the
 * hold quantity */
static void euro_sell_interactive(void) {
    if (UI.market_sel < 0) return;
    int port = -1, ord = -1;
    for (int q = 0; q < CR.n_europe; q++) {
        if (CR.europe[q].state != 0) continue;
        if (++ord == UI.euro_ship) { port = q; break; }
    }
    if (port < 0) return;
    if (market_boycotted(UI.market_sel)) {
        euro_sell_from_ship(port, UI.market_sel, 0);   /* KISSUP arm */
        return;
    }
    int32_t have = euro_hold_qty(port, UI.market_sel);
    if (!have) return;
    UI.dlg = 1;
    UI.dlg_entry[0] = 0;
    UI.dlg_max = have;
    UI.dlg_good = (int8_t)UI.market_sel;
    UI.dlg_port = (int16_t)port;
}

/* the CS record of the ordinal-TH player colony (JS G.colonies[ord]) */
static int player_colony_rec(int ord) {
    int o = -1;
    for (int k = 0; k < CS.n_colonies; k++) {
        if ((CS.colonies[k].owner_power & 3) != cs_nation()) continue;
        if (++o == ord) return k;
    }
    return -1;
}

/* ---- the construction picker (openBuildPicker, game.js:3989) ----------
 * Row NAMES in colonyPopupRows 'build' order (game.js:3914): the
 * "(No Production)" stop row, then buildOptions (game.js:2938) — every
 * @BUILDING row not already built (by NAME over the runtime list) whose
 * min_colony gate the population meets, whose chain predecessor stands
 * with no higher tier up (buildingChain, game.js:2907: the
 * BUILDING_GROUP plot table's consecutive-name-deduped sequences, the
 * Stable independent), the Custom House behind Peter Stuyvesant and the
 * factory tier behind Adam Smith — then the colony-built units
 * (unitBuildRows, game.js:2973: a Wagon Train always, Artillery once an
 * Armory-chain building stands, ships behind the Shipyard).
 * names[0] = NULL marks the stop row; returns the row count. */
#define BUILD_MAX_ROWS 64
static const char *BUILD_UNITS[7] = { "Wagon Train", "Artillery", "Caravel",
    "Merchantman", "Galleon", "Privateer", "Frigate" };
static int build_rows(int cci, const char **names) {
    static const char *FACTORY[6] = { "Textile Mill", "Cigar Factory",
        "Rum Factory", "Fur Factory", "Iron Works", "Arsenal" };
    const ColonyRecord *c = &CS.colonies[cci];
    int n = 0;
    names[n++] = NULL;
    for (int i = 0; i < DAT_BUILDINGS_COUNT && n < BUILD_MAX_ROWS - 8; i++) {
        const char *nm = dat_buildings[i].name;
        if (colony_has_name(cci, nm)) continue;
        if (dat_buildings[i].min_colony > c->population) continue;
        if (strcmp(nm, "Stable") != 0) {
            const char *seq[16];
            int ns = 0, at = -1, sup = 0, g = rm_building_group(i);
            for (int j = 0; j < DAT_BUILDINGS_COUNT; j++) {
                if (rm_building_group(j) != g ||
                    strcmp(dat_buildings[j].name, "Stable") == 0) continue;
                if (ns && strcmp(seq[ns - 1], dat_buildings[j].name) == 0)
                    continue;
                if (ns < 16) seq[ns++] = dat_buildings[j].name;
            }
            for (int q = 0; q < ns; q++)
                if (strcmp(seq[q], nm) == 0) { at = q; break; }
            if (at > 0 && !colony_has_name(cci, seq[at - 1])) continue;
            for (int q = at + 1; q < ns; q++)
                if (colony_has_name(cci, seq[q])) sup = 1;
            if (sup) continue;
        }
        if (strcmp(nm, "Custom House") == 0 &&
            !father_owned(father_by_name("Peter Stuyvesant"))) continue;
        int fac = 0;
        for (int f = 0; f < 6; f++)
            if (strcmp(nm, FACTORY[f]) == 0) fac = 1;
        if (fac && !father_owned(father_by_name("Adam Smith"))) continue;
        names[n++] = nm;
    }
    for (int u = 0; u < 7 && n < BUILD_MAX_ROWS; u++) {
        if (u == 1 && !(colony_has_name(cci, "Armory") ||
                        colony_has_name(cci, "Magazine") ||
                        colony_has_name(cci, "Arsenal"))) continue;
        if (u >= 2 && !colony_has_name(cci, "Shipyard")) continue;
        names[n++] = BUILD_UNITS[u];
    }
    return n;
}
/* the JS c.building NAME for the record's target byte. Units cannot be
 * expressed in the record's @BUILDING index, so a unit target committed
 * from the picker is held as 0xC0+u (input-layer encoding, outside the
 * sav's 0..41/0xFF vocabulary — a save-out with a unit under way would
 * need a real mirror; FLAGGED with the turn step's unit-build TBD). */
static const char *build_target_name(const ColonyRecord *c) {
    int bip = c->building_in_production;
    if (bip >= 0xC0 && bip < 0xC7) return BUILD_UNITS[bip - 0xC0];
    return bip < DAT_BUILDINGS_COUNT ? dat_buildings[bip].name : NULL;
}
/* openBuildPicker (game.js:3989): the picker opens ON the current
 * target's row, "(No Production)" when none */
static void open_build_picker(void) {
    int cci = player_colony_rec(UI.colony);
    if (cci < 0) return;
    const char *names[BUILD_MAX_ROWS];
    int n = build_rows(cci, names);
    const char *cur = build_target_name(&CS.colonies[cci]);
    int at = -1;
    for (int i = 0; i < n && at < 0; i++)
        if (names[i] ? (cur && strcmp(names[i], cur) == 0) : !cur) at = i;
    UI.colony_popup = 2;
    UI.colony_popup_row = (int8_t)(at < 0 ? 0 : at);
}
/* colonyPopupRows jobs arm (game.js:3925): the "No job (plaza)" row,
 * then the runtime buildings that employ anyone, list order.
 * names[0] = NULL marks the plaza row. */
static int jobs_rows(int cci, const char **names) {
    int n = 0;
    names[n++] = NULL;
    const colony_rt *r = &CR.col[cci];
    for (int k = 0; k < r->n_bld && n < BUILD_MAX_ROWS; k++) {
        const char *nm = dat_buildings[r->bld[k]].name;
        if (workplace_job_for_name(nm) >= 0) names[n++] = nm;
    }
    return n;
}
/* teacherGuard (game.js:3050): @NOTEACHER for the professionless, the
 * NEEDCOLLEGE/NEEDUNIVERSITY tier gates, the faculty cap (level = seats) */
static int teacher_guard(int cci, int k) {
    int lvl = colony_school_level(cci);
    if (!lvl) return 0;
    const ColonyRecord *c = &CS.colonies[cci];
    uint8_t prof = c->profession[k];
    int has_prof = prof >= 1 && prof < DAT_JOBEXPERT_COUNT;
    int cls = colony_profession_class(prof);
    if (!has_prof || cls >= 4) { ev_emit("NOTEACHER", 0, 0, 0, 0); return 1; }
    if (cls > lvl) {
        ev_emit(cls == 2 ? "NEEDCOLLEGE" : "NEEDUNIVERSITY", 0, 0,
                dat_jobexpert[prof], 0);
        return 1;
    }
    int teacher = workplace_job_for_name("Schoolhouse"), faculty = 0;
    for (int q = 0; q < c->population && q < 32; q++)
        if (q != k && c->occupation[q] == teacher) faculty++;
    if (faculty >= lvl) {
        ev_emit(lvl == 1 ? "SCHOOL1" : lvl == 2 ? "COLLEGE2" : "UNIV3",
                0, 0, 0, 0);
        return 1;
    }
    return 0;
}
/* the +0x70 worker slot pointing at colonist k, cleared = p.cell = null */
static void cell_clear(ColonyRecord *c, int k) {
    for (int j = 0; j < 8; j++)
        if ((uint8_t)c->tiles[j] == (uint8_t)k) c->tiles[j] = -1;
}
/* colonyPopupCommit (game.js:3996), the jobs arm: the row's building
 * names the job; @MORETHANTHREE caps a building at three cell-less
 * workers, the teacher guard vets the faculty; the plaza row clears
 * both job and cell.  A field-job byte never equals a workplace job
 * id, so the raw occupation compare matches the JS p.job semantics
 * (the importer's cell-less field-job nulling included). */
static void jobs_popup_commit(void) {
    int cci = player_colony_rec(UI.colony);
    if (cci >= 0) {
        ColonyRecord *c = &CS.colonies[cci];
        const char *names[BUILD_MAX_ROWS];
        int n = jobs_rows(cci, names);
        int row = UI.colony_popup_row, k = UI.colonist_sel;
        if (row >= 0 && row < n && k >= 0 && k < c->population && k < 32) {
            if (row == 0) {
                cell_clear(c, k);
                c->occupation[k] = 0xFF;             /* job null (JS) */
            } else {
                int job = workplace_job_for_name(names[row]);
                int crew = 0;
                for (int q = 0; q < c->population && q < 32; q++) {
                    int qc = -1;
                    for (int j = 0; j < 8; j++)
                        if ((uint8_t)c->tiles[j] == (uint8_t)q) qc = j;
                    if (qc < 0 && c->occupation[q] == job) crew++;
                }
                if (crew >= 3 && c->occupation[k] != job) {
                    ev_emit("MORETHANTHREE", 0, 0, 0, 0);
                    UI.colony_popup = 0;
                    return;
                }
                if (job == workplace_job_for_name("Schoolhouse") &&
                    c->occupation[k] != job && teacher_guard(cci, k)) {
                    UI.colony_popup = 0;
                    return;
                }
                c->occupation[k] = (uint8_t)job;
                cell_clear(c, k);                    /* p.cell = null */
            }
        }
    }
    UI.colony_popup = 0;
}
/* colonyPopupCommit (game.js:3996), the 'build' arm: the row becomes
 * the construction target and the popup closes */
static void build_picker_commit(void) {
    int cci = player_colony_rec(UI.colony);
    if (cci >= 0) {
        const char *names[BUILD_MAX_ROWS];
        int n = build_rows(cci, names);
        if (UI.colony_popup_row >= 0 && UI.colony_popup_row < n) {
            ColonyRecord *c = &CS.colonies[cci];
            const char *nm = names[UI.colony_popup_row];
            if (!nm) c->building_in_production = 0xFF;
            else {
                int id = -1;
                for (int i = 0; i < DAT_BUILDINGS_COUNT && id < 0; i++)
                    if (strcmp(dat_buildings[i].name, nm) == 0) id = i;
                if (id < 0)
                    for (int u = 0; u < 7; u++)
                        if (strcmp(BUILD_UNITS[u], nm) == 0) id = 0xC0 + u;
                if (id >= 0) c->building_in_production = (uint8_t)id;
            }
        }
    }
    UI.colony_popup = 0;
}
static int is_fkey(const char *k, int *out) {
    if (k[0] != 'F' || k[1] < '0' || k[1] > '9') return 0;
    int v = k[1] - '0';
    if (k[2] >= '0' && k[2] <= '9') { v = v * 10 + (k[2] - '0'); if (k[3]) return 0; }
    else if (k[2]) return 0;
    *out = v;
    return 1;
}

/* the boot menu commit (commitMenu, game.js:12038): rows 0-2 enter the
 * new-game path, 3 = LOAD, 4 = Hall of Fame — the load/new-game flows
 * are dialogs the harness scripts around, so only the screen moves. */
static void commit_menu(void) {
    if (UI.menu_row <= 2) UI.screen = SCR_DIFFICULTY;
    else if (UI.menu_row == 4) UI.screen = SCR_HOF;
    /* row 3 (LOAD) opens a picker dialog — slice 2 */
}

void in_key(const char *k, int alt, int shift) {
    /* an open @HOWMUCH dialog owns the keyboard (onKey, game.js:12403:
     * the G.dialog check runs before every screen case) */
    if (UI.dlg) { dialog_key(k); return; }
    /* the name-entry screen owns every key (game.js:12404) */
    if (UI.screen == SCR_NAME) {
        size_t len = strlen(UI.leader);
        if (key_is(k, "Enter")) {
            if (!len)
                snprintf(UI.leader, sizeof(UI.leader), "%s",
                         dat_nations[UI.nation].leader);
            UI.brief_page = 0;
            UI.screen = SCR_BRIEFING;
        } else if (key_is(k, "Backspace")) {
            if (len) UI.leader[len - 1] = 0;
        } else if (strlen(k) == 1 && len < 23) {
            UI.leader[len] = k[0];
            UI.leader[len + 1] = 0;
        }
        return;
    }
    switch (UI.screen) {
    case SCR_HOF:
        if (key_is(k, "Escape") || key_is(k, "Enter") || key_is(k, " ")) {
            UI.screen = SCR_TITLE;
            UI.menu_row = 0;
        }
        break;
    case SCR_TITLE:
        if (key_is(k, "ArrowUp")) UI.menu_row = (int8_t)((UI.menu_row + 4) % 5);
        if (key_is(k, "ArrowDown")) UI.menu_row = (int8_t)((UI.menu_row + 1) % 5);
        if (key_is(k, "Enter") || key_is(k, " ")) commit_menu();
        break;
    case SCR_DIFFICULTY:
        if (key_is(k, "ArrowUp")) UI.difficulty = (int8_t)((UI.difficulty + 4) % 5);
        if (key_is(k, "ArrowDown")) UI.difficulty = (int8_t)((UI.difficulty + 1) % 5);
        if (key_is(k, "Enter")) UI.screen = SCR_NATION;
        if (key_is(k, "Escape")) UI.screen = SCR_TITLE;
        break;
    case SCR_NATION:
        if (key_is(k, "ArrowLeft") || key_is(k, "ArrowUp"))
            UI.nation = (int8_t)((UI.nation + 3) % 4);
        if (key_is(k, "ArrowRight") || key_is(k, "ArrowDown"))
            UI.nation = (int8_t)((UI.nation + 1) % 4);
        if (key_is(k, "Enter")) {
            snprintf(UI.leader, sizeof(UI.leader), "%s",
                     dat_nations[UI.nation].leader);
            UI.screen = SCR_NAME;
        }
        if (key_is(k, "Escape")) UI.screen = SCR_DIFFICULTY;
        break;
    case SCR_BRIEFING:
        /* Enter/space advances the page pair, then the game would
         * start (newGame — out of the slice; the script stops here) */
        if (key_is(k, "Enter") || key_is(k, " ")) {
            if (UI.brief_page == 0) UI.brief_page = 1;
            /* page 1 -> newGame: unported, the script never sends it */
        }
        break;
    case SCR_REPORT:
        {
            int fn;
            if (key_is(k, "Escape") || key_is(k, "x") || is_fkey(k, &fn))
                UI.screen = SCR_MAP;
        }
        break;
    case SCR_MAP: {
        /* an open pulldown owns the keyboard (game.js:12545) */
        if (UI.open_menu >= 0) {
            rm_mrow rows[64];
            int n = rm_menu_rows(UI.open_menu, UI.sel, rows);
            if (key_is(k, "ArrowUp") || key_is(k, "ArrowDown")) {
                int dir = key_is(k, "ArrowUp") ? -1 : 1;
                int i = UI.menu_sel;
                for (int t = 0; t < n; t++) {
                    i = (i + dir + n) % n;
                    if (!rows[i].sep) { UI.menu_sel = (int8_t)i; break; }
                }
            } else if (key_is(k, "ArrowLeft"))
                open_menu((UI.open_menu + DAT_MENUS_COUNT - 1) %
                          DAT_MENUS_COUNT);
            else if (key_is(k, "ArrowRight"))
                open_menu((UI.open_menu + 1) % DAT_MENUS_COUNT);
            else if (key_is(k, "Escape"))
                UI.open_menu = -1;
            else if (key_is(k, "Enter") || key_is(k, " "))
                run_menu_row();
            else if (strlen(k) == 1) {
                /* accelerator: the first MASTER row with that letter,
                 * then the visible row of the same label (game.js:12560) */
                char K = (char)(k[0] >= 'a' && k[0] <= 'z' ? k[0] - 32
                                                           : k[0]);
                const dat_menus_t *m = &dat_menus[UI.open_menu];
                const char *lbl = 0;
                for (int q = 0; q < m->row_count && !lbl; q++) {
                    const dat_menu_rows_t *mr =
                        &dat_menu_rows[m->row_start + q];
                    if (mr->accel[0] == K && !mr->accel[1]) lbl = mr->label;
                }
                if (lbl) {
                    for (int i = 0; i < n; i++)
                        if (!rows[i].sep && rows[i].label &&
                            strcmp(rows[i].label, lbl) == 0) {
                            UI.menu_sel = (int8_t)i;
                            run_menu_row();
                            break;
                        }
                }
            }
            break;
        }
        if (alt && strlen(k) == 1) {
            char K = (char)(k[0] >= 'a' && k[0] <= 'z' ? k[0] - 32 : k[0]);
            for (int i = 0; i < DAT_MENUS_COUNT; i++)
                if (dat_menus[i].accel[0] == K && !dat_menus[i].accel[1]) {
                    open_menu(i);
                    return;
                }
            return;
        }
        int fn;
        if (is_fkey(k, &fn)) {
            /* F1 = the pedia TERRAIN page (hard rule 7) — slice 2;
             * F8 gated by woiLocked; F2-F10 = the report ladder */
            if (fn == 1) return;
            if (fn == 8 && (CR.woi_flags & WOI_DECLARED) &&
                !(CR.woi_flags & WOI_WON)) {
                ev_emit("FOREIGNNOTAVAIL", 0, 0, 0, 0);
                return;
            }
            if (fn >= 2 && fn <= 10) {
                snprintf(UI.report, sizeof(UI.report), "F%d", fn);
                UI.screen = SCR_REPORT;
            }
            return;
        }
        /* 8-way movement (game.js:12603) */
        static const struct { const char *k; int8_t dx, dy; } DIR[] = {
            { "ArrowLeft", -1, 0 }, { "ArrowRight", 1, 0 },
            { "ArrowUp", 0, -1 }, { "ArrowDown", 0, 1 },
            { "7", -1, -1 }, { "9", 1, -1 }, { "1", -1, 1 }, { "3", 1, 1 },
        };
        for (unsigned i = 0; i < sizeof(DIR) / sizeof(DIR[0]); i++) {
            if (!key_is(k, DIR[i].k)) continue;
            if (UI.view_mode) {
                center_on(UI.view_x + 7 + DIR[i].dx * 3,
                          UI.view_y + 6 + DIR[i].dy * 3);
            } else {
                int ui = sel_unit();
                if (ui < 0) return;
                int ox = CS.units[ui].map_x, oy = CS.units[ui].map_y;
                int had = !CR.unit_moves_undef[ui] &&
                          CS.units[ui].moves_remaining > 0;
                CR.ui_advance = 0;
                int vil_before = CR.cur_village;
                cmd_move(ui, DIR[i].dx, DIR[i].dy);
                if (CR.ui_advance) {   /* a combat arm ended in advance() */
                    CR.ui_advance = 0;
                    advance();
                    return;
                }
                /* a village entry that fired no fresh woodcut leaves
                 * the village screen open (enterVillage, game.js:6459).
                 * Under the SHARED trace conventions the woodcutOnce
                 * stub dismisses to the map unconditionally, so
                 * CR.village_screen never latches there — this branch
                 * (and the SCR_VILLAGE vocabulary) is the real game's
                 * path, live once the Teensy loop runs real woodcut
                 * modals. */
                if (CR.cur_village >= 0 && CR.cur_village != vil_before &&
                    CR.village_screen) {
                    UI.village_row = 0;
                    UI.screen = SCR_VILLAGE;
                    return;
                }
                /* step's own tail (game.js:10850): recentre when the
                 * unit strays near the view edge, then advance when the
                 * budget is spent */
                if (had && (CS.units[ui].map_x != ox ||
                            CS.units[ui].map_y != oy)) {
                    int nx = CS.units[ui].map_x, ny = CS.units[ui].map_y;
                    if (nx - UI.view_x < 3 || nx - UI.view_x > VIEW_COLS - 4 ||
                        ny - UI.view_y < 3 || ny - UI.view_y > VIEW_ROWS - 4)
                        center_on(nx, ny);
                    if (CS.units[ui].moves_remaining <= 0) advance();
                }
            }
            return;
        }
        int ui = sel_unit();
        if (key_is(k, " ")) {
            if (ui >= 0) { cmd_skip(ui); advance(); }
        } else if (key_is(k, "Tab") || key_is(k, "w") || key_is(k, "W")) {
            next_unit();
        } else if (key_is(k, "a") || key_is(k, "A")) {
            if (ui >= 0) cmd_activate(ui);
        } else if (key_is(k, "f") || key_is(k, "F")) {
            if (ui >= 0) { cmd_set_order(ui, 5); advance(); }
        } else if (key_is(k, "s") || key_is(k, "S")) {
            if (ui >= 0) { cmd_set_order(ui, 1); advance(); }
        } else if (key_is(k, "p") || key_is(k, "P")) {
            if (ui >= 0) { cmd_set_order(ui, 8); advance(); }
        } else if (key_is(k, "r") || key_is(k, "R")) {
            if (ui >= 0) { cmd_set_order(ui, 9); advance(); }
        } else if (key_is(k, "c") || key_is(k, "C")) {
            if (ui >= 0) center_on(CS.units[ui].map_x, CS.units[ui].map_y);
        } else if (key_is(k, "v") || key_is(k, "V")) {
            UI.view_mode = 1;
        } else if (key_is(k, "m") || key_is(k, "M")) {
            UI.view_mode = 0;
        } else if (key_is(k, "b") || key_is(k, "B")) {
            /* buildColony (game.js:11258): join completes, a founding
             * runs its guards + ask chains and stops at the inert name
             * dialog */
            if (ui >= 0) {
                int ord = cmd_build_colony(ui);
                if (UI.sel >= CR.n_units_order)
                    UI.sel = CR.n_units_order ? CR.n_units_order - 1 : 0;
                if (ord >= 0) {
                    UI.colony = (int8_t)ord;
                    UI.screen = SCR_COLONY;
                }
            }
        } else if (key_is(k, "e") || key_is(k, "E")) {
            /* returnToEurope (game.js:12365) */
            if ((CR.woi_flags & WOI_DECLARED) && !(CR.woi_flags & WOI_WON)) {
                ev_emit("EUROPENOTAVAIL", 0, 0, 0, 0);
            } else {
                if (ui >= 0 && dat_units[CS.units[ui].type].hull > 0) {
                    cmd_sail_for_europe(ui);
                    if (UI.sel >= CR.n_units_order)
                        UI.sel = CR.n_units_order ? CR.n_units_order - 1 : 0;
                }
                UI.screen = SCR_EUROPE;
            }
        } else if (key_is(k, "l") || key_is(k, "L")) {
            /* loadCargo (game.js:11236): @CARGOLOAD picks the good (the
             * seq-policy ask), @HOWMUCH1 the amount (a live modal) */
            if (ui >= 0 && dat_units[CS.units[ui].type].hull > 0) {
                int ci = colony_rec_at_xy(CS.units[ui].map_x,
                                          CS.units[ui].map_y);
                if (ci >= 0) {
                    int goods[16], n = 0;
                    for (int g = 0; g < 16; g++)
                        if (CS.colonies[ci].stock[g] > 0) goods[n++] = g;
                    if (n) {
                        ev_emit("CARGOLOAD", 0, 0, CS.colonies[ci].name, 0);
                        int kk = ask_choice();
                        if (kk >= 0 && kk < n) {
                            int q = CS.colonies[ci].stock[goods[kk]];
                            UI.dlg = 2;
                            UI.dlg_entry[0] = 0;
                            UI.dlg_max = q < 100 ? q : 100;
                            UI.dlg_good = (int8_t)goods[kk];
                            UI.dlg_port = (int16_t)ci;
                            UI.dlg_unit = (int16_t)ui;
                        }
                    }
                }
            }
        } else if (key_is(k, "u") || key_is(k, "U")) {
            /* unloadCargo (game.js:11258 area): @CARGOUNLOAD picks the
             * slot, @HOWMUCH2 the amount */
            if (ui >= 0 && dat_units[CS.units[ui].type].hull > 0) {
                int ci = colony_rec_at_xy(CS.units[ui].map_x,
                                          CS.units[ui].map_y);
                if (ci >= 0) {
                    int slots[EURO_HOLD_MAX], n = 0;
                    for (int s2 = 0; s2 < CR.unit_n_hold[ui]; s2++)
                        if (CR.unit_hold[ui][s2].qty > 0) slots[n++] = s2;
                    if (n) {
                        ev_emit("CARGOUNLOAD", 0, 0, CS.colonies[ci].name, 0);
                        int kk = ask_choice();
                        if (kk >= 0 && kk < n) {
                            const hold_slot *h = &CR.unit_hold[ui][slots[kk]];
                            UI.dlg = 3;
                            UI.dlg_entry[0] = 0;
                            UI.dlg_max = h->qty;
                            UI.dlg_good = (int8_t)h->good;
                            UI.dlg_port = (int16_t)ci;
                            UI.dlg_unit = (int16_t)ui;
                        }
                    }
                }
            }
        } else if (key_is(k, "o") || key_is(k, "O")) {
            /* dumpCargo (game.js:11280): @OVERBOARD picks the slot to
             * splice away whole */
            if (ui >= 0 && CR.unit_n_hold[ui] > 0) {
                int slots[EURO_HOLD_MAX], n = 0;
                for (int s2 = 0; s2 < CR.unit_n_hold[ui]; s2++)
                    if (CR.unit_hold[ui][s2].qty > 0) slots[n++] = s2;
                if (n) {
                    ev_emit("OVERBOARD", 0, 0, 0, 0);
                    int kk = ask_choice();
                    if (kk >= 0 && kk < n) {
                        int at = slots[kk];
                        memmove(&CR.unit_hold[ui][at],
                                &CR.unit_hold[ui][at + 1],
                                (size_t)(CR.unit_n_hold[ui] - at - 1) *
                                    sizeof(hold_slot));
                        CR.unit_n_hold[ui]--;
                    }
                }
            }
        } else if (shift && key_is(k, "D")) {
            /* disbandUnit (game.js:11293): @DISBANDSHIP blocks a loaded
             * ship at sea; @SUREDISBAND row 0 removes the unit */
            if (ui >= 0) {
                int ship2 = dat_units[CS.units[ui].type].hull > 0;
                if (ship2 && CR.unit_n_pass[ui] > 0 &&
                    colony_rec_at_xy(CS.units[ui].map_x,
                                     CS.units[ui].map_y) < 0) {
                    ev_emit("DISBANDSHIP", 0, 0, 0, 0);
                } else {
                    ev_emit("SUREDISBAND", 0, 0,
                            dat_units[CS.units[ui].type].name, 0);
                    if (ask_choice() == 0) {
                        unit_remove(ui);
                        if (UI.sel >= CR.n_units_order)
                            UI.sel = CR.n_units_order ? CR.n_units_order - 1
                                                      : 0;
                    }
                }
            }
        }
        break;
    }
    case SCR_COLONY:
        /* an open popup owns the keyboard (onKey colony case,
         * game.js:12485): arrows walk the rows, Enter/space commits,
         * ESC closes, everything else is swallowed. Build and jobs are
         * fully modelled; the occupation popup (a colonist-click flow,
         * mouse-only) is a later slice (#92). */
        if (UI.colony_popup) {
            int cci = player_colony_rec(UI.colony);
            const char *names[BUILD_MAX_ROWS];
            int n = 1;
            if (cci >= 0)
                n = UI.colony_popup == 2 ? build_rows(cci, names)
                                         : jobs_rows(cci, names);
            if (key_is(k, "ArrowUp"))
                UI.colony_popup_row = (int8_t)((UI.colony_popup_row + n - 1) % n);
            if (key_is(k, "ArrowDown"))
                UI.colony_popup_row = (int8_t)((UI.colony_popup_row + 1) % n);
            if (key_is(k, "Enter") || key_is(k, " ")) {
                if (UI.colony_popup == 2) build_picker_commit();
                else jobs_popup_commit();
            }
            if (key_is(k, "Escape")) UI.colony_popup = 0;
            break;
        }
        /* §26.8 keys: 1/2/3 select the right-panel view, C opens the
         * construction picker, Enter the jobs popup for the selected
         * colonist, ESC/x exits */
        if (k[0] >= '1' && k[0] <= '3' && !k[1])
            UI.colony_view = (int8_t)(k[0] - '1');
        if (key_is(k, "c") || key_is(k, "C")) open_build_picker();
        if (key_is(k, "Enter")) {
            UI.colony_popup = 1;             /* 'jobs' */
            UI.colony_popup_row = 0;
        }
        if (key_is(k, "Escape") || key_is(k, "x")) UI.screen = SCR_MAP;
        break;
    case SCR_VILLAGE: {
        /* the @ACTIONS menu keys (onKey village case, game.js:12460):
         * arrows walk the rows, Enter/space commits, ESC/x leaves and
         * advances */
        uint8_t ids[12];
        int n = village_action_rows(ids);
        if (n > 0 && (key_is(k, "ArrowUp") || key_is(k, "ArrowDown"))) {
            int dir = key_is(k, "ArrowUp") ? -1 : 1;
            UI.village_row = (int8_t)((UI.village_row + dir + n) % n);
        }
        if ((key_is(k, "Enter") || key_is(k, " ")) && UI.village_row < n) {
            int id = ids[UI.village_row];
            int vi = CR.cur_village, vu = CR.cur_visitor;
            run_village_action(id);
            if (id == 0 || id == 1) {
                /* the trade rows keep the screen (runVillageAction,
                 * game.js:6497) — restore the open-village state the
                 * sim call clears */
                CR.cur_village = (int8_t)vi;
                CR.cur_visitor = (int16_t)vu;
            } else if (id == 8) {
                UI.screen = SCR_MAP;         /* attack: no advance */
            } else {
                UI.screen = SCR_MAP;
                advance();
            }
        }
        if (key_is(k, "Escape") || key_is(k, "x")) {
            UI.screen = SCR_MAP;
            CR.cur_village = -1;             /* G.village = null */
            advance();
        }
        break;
    }
    case SCR_EUROPE: {
        /* an open sub-menu owns the keyboard (onKey europe case,
         * game.js:12519): arrows walk the rows, Enter/space commits
         * (euroMenuCommit — the generic gold gate keeps the menu open
         * on failure), ESC closes */
        if (UI.euro_menu) {
            int n = UI.euro_menu == 1 ? 4        /* (None) + 3 candidates */
                  : UI.euro_menu == 2 ? 6        /* PURCHASE_CATALOG */
                  : 1 + DAT_JOBTRAIN_COUNT;      /* None + sorted experts */
            if (key_is(k, "ArrowUp"))
                UI.euro_menu_row = (int8_t)((UI.euro_menu_row + n - 1) % n);
            if (key_is(k, "ArrowDown"))
                UI.euro_menu_row = (int8_t)((UI.euro_menu_row + 1) % n);
            if (key_is(k, "Enter") || key_is(k, " ")) {
                int row = UI.euro_menu_row;
                if ((UI.euro_menu == 1 || UI.euro_menu == 3) && row == 0) {
                    UI.euro_menu = 0;            /* the "(None)" head */
                } else {
                    int32_t gold = CS.powers[cs_nation()].gold;
                    int32_t cost =
                        UI.euro_menu == 1 ? euro_recruit_cost(row - 1)
                      : UI.euro_menu == 2 ? euro_purchase_price(row)
                                          : euro_train_cost(row - 1);
                    if (cost <= gold) {          /* fail = euroMsg only */
                        if (UI.euro_menu == 1) euro_recruit(row - 1);
                        else if (UI.euro_menu == 2) euro_purchase(row);
                        else euro_train(row - 1);
                        UI.euro_menu = 0;
                    }
                }
            }
            if (key_is(k, "Escape")) UI.euro_menu = 0;
            break;
        }
        /* §26.9 keys: arrows walk the market cursor, L/=/+ buy to the
         * active ship, R/1 P/2 T/3 open the recruit/purchase/train
         * menus (openEuroMenu, game.js:4778), K petitions the King,
         * S asks @SAILAWAY (openDialog — inert under the shared
         * conventions, so unbound), ESC/x/E exit.  The sell key runs
         * the @HOWMUCH5 amount dialog — its numeric-entry modal is a
         * later slice. */
        if (key_is(k, "ArrowLeft"))
            UI.market_sel = (int8_t)((UI.market_sel + 15) % 16);
        if (key_is(k, "ArrowRight"))
            UI.market_sel = (int8_t)((UI.market_sel + 1) % 16);
        if (key_is(k, "l") || key_is(k, "L") || key_is(k, "=") ||
            key_is(k, "+")) {
            int qty = key_is(k, "+") ? 10 : 100;
            if (UI.market_sel >= 0) {
                int port = -1, ord = -1;
                for (int q = 0; q < CR.n_europe; q++) {
                    if (CR.europe[q].state != 0) continue;
                    if (++ord == UI.euro_ship) { port = q; break; }
                }
                if (port >= 0)
                    euro_buy_to_ship(port, UI.market_sel, qty);
            }
        }
        if (key_is(k, "r") || key_is(k, "R") || key_is(k, "1")) {
            UI.euro_menu = 1; UI.euro_row = 0; UI.euro_menu_row = 0;
        }
        if (key_is(k, "p") || key_is(k, "P") || key_is(k, "2")) {
            UI.euro_menu = 2; UI.euro_row = 1; UI.euro_menu_row = 0;
        }
        if (key_is(k, "t") || key_is(k, "T") || key_is(k, "3")) {
            UI.euro_menu = 3; UI.euro_row = 2; UI.euro_menu_row = 0;
        }
        if (key_is(k, "u") || key_is(k, "U") || key_is(k, "-") ||
            key_is(k, "_"))
            euro_sell_interactive();
        if (key_is(k, "k") || key_is(k, "K")) king_petition();
        if (key_is(k, "Escape") || key_is(k, "x") || key_is(k, "e") ||
            key_is(k, "E"))
            UI.screen = SCR_MAP;
        break;
    }
    default:
        break;
    }
}

/* ---- the pointer layer (onClick, game.js:12048) — slice 3 ----------
 * The boot screens, the report exit, the map screen (menubar, pulldown
 * rows, viewport: colony-open / stack-cycle / centre), the colony
 * screen's buttons/dock/exit, and the Europe screen's ship boxes,
 * market bar and exit.  The drag layer, the popup/scene/plaza colonist
 * moves and the context menus stay with later slices — the shared
 * script does not click those regions. */
static int hit(int mx, int my, int x, int y, int w, int h) {
    return mx >= x && mx < x + w && my >= y && my < y + h;
}

void in_click(int mx, int my, int right) {
    (void)right;
    /* a click on an open numeric dialog commits its entry
     * (dialogClick's non-opts arm, game.js:12410) */
    if (UI.dlg) { dialog_done(0); return; }
    switch (UI.screen) {
    case SCR_TITLE:
        for (int k = 0; k < 5; k++)
            if (hit(mx, my, 77 + 4, 106 + 8 * k, 158, 7)) {
                UI.menu_row = (int8_t)k;
                commit_menu();
                return;
            }
        break;
    case SCR_DIFFICULTY:
        for (int n = 0; n < 5; n++) {
            int i = n + 1;
            if (hit(mx, my, (i % 3) * 105 + 23, (i / 3) * 96 + 7, 68, 90)) {
                UI.difficulty = (int8_t)n;
                return;
            }
        }
        if (my < 103 && mx < 128) UI.screen = SCR_NATION;
        break;
    case SCR_NATION:
        for (int i = 0; i < 4; i++)
            if (hit(mx, my, (i % 2) * 99 + 112, (i / 2) * 91 + 13, 88, 82)) {
                UI.nation = (int8_t)i;
                return;
            }
        if (mx < 112) {
            snprintf(UI.leader, sizeof(UI.leader), "%s",
                     dat_nations[UI.nation].leader);
            UI.screen = SCR_NAME;
        }
        break;
    case SCR_NAME:
        UI.brief_page = 0;
        UI.screen = SCR_BRIEFING;
        break;
    case SCR_BRIEFING:
        if (UI.brief_page == 0) UI.brief_page = 1;
        /* page 1 -> the king audience (newGame chain): a later slice */
        break;
    case SCR_REPORT:
        UI.screen = SCR_MAP;
        break;
    case SCR_COLONY: {
        /* order per the JS: dock ships, view buttons, build buttons
         * (unbound), the production numbers toggle, the exit box */
        const ColonyRecord *c = 0;
        int cci = -1, ord = -1;
        for (int k = 0; k < CS.n_colonies; k++) {
            if ((CS.colonies[k].owner_power & 3) != cs_nation()) continue;
            if (++ord == UI.colony) { cci = k; break; }
        }
        if (cci >= 0) c = &CS.colonies[cci];
        if (c) {
            int nships = 0;
            for (int q = 0; q < CR.n_units_order; q++) {
                int u2 = CR.units_order[q];
                if (dat_units[CS.units[u2].type].hull > 0 &&
                    CS.units[u2].map_x == c->map_x &&
                    CS.units[u2].map_y == c->map_y) nships++;
            }
            for (int k = 0; k < (nships < 4 ? nships : 4); k++)
                if (hit(mx, my, 130 + 18 * k, 147, 16, 16)) {
                    UI.colony_ship_sel = (int8_t)k;
                    return;
                }
        }
        for (int k = 0; k < 3; k++)
            if (hit(mx, my, 303, 132 + 15 * k, 15, 13)) {
                UI.colony_view = (int8_t)k;
                return;
            }
        if (UI.colony_view == 0 && hit(mx, my, 207, 130, 95, 48)) {
            UI.colony_numbers = (int8_t)!UI.colony_numbers;
            return;
        }
        if (hit(mx, my, 305, 179, 15, 21)) UI.screen = SCR_MAP;
        break;
    }
    case SCR_EUROPE: {
        if (hit(mx, my, 305, 179, 15, 21)) {
            UI.screen = SCR_MAP;
            return;
        }
        /* the recruit/purchase/train buttons open the euro sub-menus —
         * a later slice; the script does not click (281, 89+11k) */
        int nport = 0;
        for (int q = 0; q < CR.n_europe; q++)
            if (CR.europe[q].state == 0) nport++;
        for (int k = 0; k < (nport < 6 ? nport : 6); k++)
            if (hit(mx, my, 145 + 18 * k, 145, 18, 18)) {
                /* a re-click on the selected ship opens its context
                 * menu (later slice); a different ship just selects */
                if (UI.euro_ship != k) UI.euro_ship = (int8_t)k;
                return;
            }
        if (my >= 179) {
            int i = mx / 19;
            if (i >= 0 && i < 16) {
                UI.market_sel = (int8_t)i;
                /* sellFromShip with no qty (game.js:12291): the
                 * @KISSUP ask for a boycott, else the @HOWMUCH5
                 * amount modal — now LIVE on both sides */
                euro_sell_interactive();
            }
        }
        break;
    }
    case SCR_MAP: {
        if (UI.open_menu >= 0) {
            int bx, by, bw, bh;
            rm_pulldown_box(UI.open_menu, UI.sel, &bx, &by, &bw, &bh);
            if (hit(mx, my, bx, by, bw, bh)) {
                /* the click row math clamps against the MASTER row
                 * count, not the visible one (game.js:12296 quirk) */
                int i = (my - by - 2) / 8;
                int max = dat_menus[UI.open_menu].row_count - 1;
                if (i < 0) i = 0;
                if (i > max) i = max;
                UI.menu_sel = (int8_t)i;
                run_menu_row();
            } else
                UI.open_menu = -1;
            return;
        }
        if (my < 8) {
            int mi = rm_menubar_hit(mx);
            if (mi >= 0) open_menu(mi);
            return;
        }
        if (hit(mx, my, 0, 8, 240, 192)) {
            int tx = UI.view_x + (mx - 0) / 16;
            int ty = UI.view_y + (my - 8) / 16;
            /* a pending Go To takes this click — a later slice */
            int ci = -1, ord = -1;
            for (int k = 0; k < CS.n_colonies; k++) {
                if ((CS.colonies[k].owner_power & 3) != cs_nation())
                    continue;
                ord++;
                if (CS.colonies[k].map_x == tx &&
                    CS.colonies[k].map_y == ty) { ci = ord; break; }
            }
            int on[64], non = 0;
            for (int q = 0; q < CR.n_units_order && non < 64; q++) {
                int u2 = CR.units_order[q];
                if (CS.units[u2].map_x == tx && CS.units[u2].map_y == ty)
                    on[non++] = q;
            }
            if (ci >= 0 && !non) {
                UI.colony = (int8_t)ci;
                UI.screen = SCR_COLONY;
            } else if (non) {
                int at = -1;
                for (int k = 0; k < non; k++)
                    if (on[k] == UI.sel) at = k;
                UI.sel = on[(at + 1) % non];
            } else
                center_on(tx, ty);
        }
        break;
    }
    default:
        break;
    }
}
