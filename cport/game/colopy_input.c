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
#include <string.h>

#include "../core/colopy_sim.h"
#include "../data/colopy_data.h"
#include "../data/colopy_ui.h"
#include "../render/colopy_render.h"
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
    int n = rm_menu_rows(mi, sel_unit(), rows);
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
    int n = rm_menu_rows(UI.open_menu, sel_unit(), rows);
    const rm_mrow *r = (UI.menu_sel >= 0 && UI.menu_sel < n)
                           ? &rows[UI.menu_sel] : 0;
    UI.open_menu = -1;
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
    (void)shift;
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
            int n = rm_menu_rows(UI.open_menu, sel_unit(), rows);
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
                cmd_move(ui, DIR[i].dx, DIR[i].dy);
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
        }
        break;
    }
    case SCR_COLONY:
        /* §26.8 slice-2 keys: 1/2/3 select the right-panel view,
         * ESC/x exits (the popup/menu keys follow with the pointer
         * slice) */
        if (k[0] >= '1' && k[0] <= '3' && !k[1])
            UI.colony_view = (int8_t)(k[0] - '1');
        if (key_is(k, "Escape") || key_is(k, "x")) UI.screen = SCR_MAP;
        break;
    case SCR_EUROPE: {
        /* §26.9 slice-2 keys: arrows walk the market cursor, L/=/+ buy
         * to the active ship, ESC/x/E exit.  The sell key runs the
         * @HOWMUCH5 amount dialog (inert under the shared harness
         * conventions) and the r/p/t sub-menus follow later. */
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
        if (key_is(k, "Escape") || key_is(k, "x") || key_is(k, "e") ||
            key_is(k, "E"))
            UI.screen = SCR_MAP;
        break;
    }
    default:
        break;
    }
}
