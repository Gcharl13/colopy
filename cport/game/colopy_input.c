/* C-port Phase 8 slice 1 — the keyboard input layer.
 *
 * A transcription of the JS onKey dispatcher (port/src/game.js:12394)
 * over the C records: the boot flow (§26.1-26.4 keys), the map screen's
 * key vocabulary (movement/orders/reports/pulldowns, §27.1), and the
 * report exit — each key handler mutating the same UI state the Phase-7
 * renderers draw and calling the Phase-5 command layer for the sim
 * side.  Slice 1 covers the keys the shared input script exercises
 * (boot navigation, viewMode panning, the unit cycle with its endTurn
 * rollover, orders, F-key reports, pulldown navigation).  The pointer
 * layer and every screen vocabulary are in as of 2026-08-17 — map,
 * colony (popups, scene panel, plaza, build buttons), Europe (menus,
 * market, dock), village, trade, pedia, options and the entry
 * dialogs.  Pick Music is the one MENU.TXT row still unbound: this
 * build has no audio backend. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../core/colopy_core.h"
#include "../core/colopy_sim.h"
#include "../data/colopy_data.h"
#include "../data/colopy_text.h"
#include "../data/colopy_ui.h"
#include "../render/colopy_render.h"
#include "colopy_input.h"

colopy_ui UI;
int colopy_front_live = 0;
uint32_t colopy_front_seed = 1653;   /* the front end's game seed (the DOS
                                      * engine reads the BIOS clock; the
                                      * harness stays deterministic) */

#define VIEW_COLS 15
#define VIEW_ROWS 12

void ui_init(void) {
    memset(&UI, 0, sizeof(UI));
    UI.screen = SCR_TITLE;
    UI.open_menu = -1;
    UI.market_sel = -1;
    UI.sel = 0;
    CR.wc_show = -1;                 /* the live-front channels idle
                                      * (a zeroed CR would read plate 0) */
    CR.ui_select = -1;
}

/* centerOn (game.js:758) */
static void center_on(int tx, int ty) {
    /* the JS VIEW_COLS()/VIEW_ROWS() are zoom-scaled (game.js:755) */
    int cols = VIEW_COLS << UI.zoom, rows = VIEW_ROWS << UI.zoom;
    int x = tx - (cols >> 1), y = ty - (rows >> 1);
    if (x > COLOPY_MAP_W - cols) x = COLOPY_MAP_W - cols;
    if (y > COLOPY_MAP_H - rows) y = COLOPY_MAP_H - rows;
    if (x < 0) x = 0;
    if (y < 0) y = 0;
    UI.view_x = x;
    UI.view_y = y;
}

/* setZoom (game.js:11342): clamp 0..3, recentre on the active unit or
 * the old window's centre */
static int sel_unit(void);
static void set_zoom(int z) {
    UI.zoom = (int8_t)(z < 0 ? 0 : z > 3 ? 3 : z);
    int ui = sel_unit();
    if (ui >= 0) center_on(CS.units[ui].map_x, CS.units[ui].map_y);
    else center_on(UI.view_x + 7, UI.view_y + 6);
}

static int sel_unit(void) {
    if (UI.sel < 0 || UI.sel >= CR.n_units_order) return -1;
    return CR.units_order[UI.sel];
}

/* nextUnit (game.js:11168): the next unit with moves AND NO STANDING
 * ORDER, view centred.  @ORDERS (NAMES.TXT, BYTE_VERIFIED) is 0=No
 * Orders, 1=Sentry, 2=Trade Route, 3=Go To, 4=Live In Village, 5=Fortify,
 * 6=Fortified, 7=Build Colony, 8=Clear/Plow, 9=Build Road — anything
 * non-zero is busy and must not be offered.  Without the orders test a
 * pioneer on Clear/Plow or Build Road came back as the active unit every
 * turn once its moves refreshed, and moving it threw the part-done work
 * away (user report 2026-08-17).
 *
 * Adding the test changed WHICH unit is active, which walked the fixed
 * oracle scripts into three latent JS/C divergences they had never
 * reached before (all fixed the same day): end_turn's missing recentre
 * tail, the missing @WAREHOUSEFULL gate on unload, and the input
 * oracle's dialog-shape-vs-dialog-kind projection mismatch. */
static int next_unit(void) {
    int n = CR.n_units_order;
    for (int i = 1; i <= n; i++) {
        int k = (UI.sel + i) % n;
        int ui = CR.units_order[k];
        if (!CR.unit_moves_undef[ui] && CS.units[ui].moves_remaining > 0 &&
            CS.units[ui].orders == 0) {
            UI.sel = k;
            center_on(CS.units[ui].map_x, CS.units[ui].map_y);
            return 1;
        }
    }
    return 0;
}

/* endTurn = the full parity-verified step chain (host --turns order),
 * plus the JS endTurn's own TAIL (game.js:10820) — `G.msg = ''` and a
 * recentre on the still-selected unit.  That tail was absent here and
 * invisible for as long as the nextUnit() right after end_turn always
 * succeeded and re-centred on its own.  Once next_unit learned to skip
 * a unit under a standing order it can return 0, and then this is the
 * only centring the new turn gets: savraleigh event 58 caught the C
 * holding vy=42 where the JS had scrolled to 41. */
static void end_turn(void) {
    turn_step_prefix();
    turn_step2();
    turn_step3();
    turn_step5();
    int ui = sel_unit();
    if (ui >= 0) center_on(CS.units[ui].map_x, CS.units[ui].map_y);
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
/* Menu-row buffers: STATIC, and one PER FUNCTION.
 *
 * These sit on the deepest path the board has — in_key -> in_key_inner
 * -> run_menu_row -> the command -> advance -> end_turn — and at 64 rows
 * each is 1.5 KB on the host, charged against every frame beneath.  That
 * is the shape of every stack crash this port has had: legal frames
 * summing past the task's stack, which -Wframe-larger-than cannot see.
 * `python3 tools/stack_budget.py` walks the real call graph and prints
 * the number; run it after touching anything on this path.
 *
 * Separate buffers rather than one shared: run_menu_row holds a pointer
 * into its rows and then dispatches a command that can call open_menu.
 * Today it copies the label out first so sharing would happen to work —
 * that is exactly the kind of accident not worth relying on. */
static rm_mrow mrows_open[64], mrows_run[64], mrows_key[64];

static void open_menu(int mi) {
    rm_mrow *rows = mrows_open;
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
/* pillage (game.js:2206): a foot unit standing on an improvement tears
 * it up and spends its turn.  The JS guards report through G.msg, a
 * legacy status-line channel that no longer renders (task #65 moved
 * messages to popups) — so the guarded cases are silent no-ops here
 * exactly as they present in the JS. */
static void pillage_row(void) {
    int ui = sel_unit();
    if (ui < 0 || dat_units[CS.units[ui].type].hull > 0) return;
    int x = CS.units[ui].map_x, y = CS.units[ui].map_y;
    for (int k = 0; k < CS.n_colonies; k++)
        if ((CS.colonies[k].owner_power & 3) == cs_nation() &&
            CS.colonies[k].map_x == x && CS.colonies[k].map_y == y)
            return;                      /* "our own colony" */
    int i = y * COLOPY_MAP_W + x;
    if (!CS.improve[i]) return;          /* "nothing here to destroy" */
    CS.improve[i] = 0;
    CS.units[ui].moves_remaining = 0;
    advance();
}

/* beginGoToPage (game.js:2237): the @SAILPORT/@TRAVELPLACE destination
 * picker — a ship's list opens with the EUROPE ROW FIRST then the
 * coastal colonies (water on the 4-halo); a land unit lists only the
 * colonies on ITS OWN LAND MASS (the region plane partitions by
 * landmass on both sides, so the filter agrees).  Pages of ten with a
 * "(More)" tail row; Escape / an out-of-range answer leaves
 * click-to-target (UI.goto_arm).  Picking Europe sets sail. */
static void begin_goto_page(int ui, int page) {
    static const int HALO[4][2] = { { 0, -1 }, { 1, 0 }, { 0, 1 }, { -1, 0 } };
    int ship = dat_units[CS.units[ui].type].hull > 0;
    int ecs[COLOPY_MAX_COLONIES + 1];    /* entry -> colony rec, -1 Europe */
    int n = 0;
    if (ship) {
        ecs[n++] = -1;
        for (int k = 0; k < CS.n_colonies; k++) {
            if ((CS.colonies[k].owner_power & 3) != cs_nation()) continue;
            for (int d = 0; d < 4; d++)
                if (tile_water(map_at(CS.colonies[k].map_x + HALO[d][0],
                                      CS.colonies[k].map_y + HALO[d][1]))) {
                    ecs[n++] = k;
                    break;
                }
        }
    } else {
        int home = CS.region[CS.units[ui].map_y * COLOPY_MAP_W +
                             CS.units[ui].map_x] & 0x0F;
        for (int k = 0; k < CS.n_colonies; k++) {
            if ((CS.colonies[k].owner_power & 3) != cs_nation()) continue;
            if ((CS.region[CS.colonies[k].map_y * COLOPY_MAP_W +
                           CS.colonies[k].map_x] & 0x0F) == home)
                ecs[n++] = k;
        }
    }
    if (!n) { UI.goto_arm = 1; return; } /* "Click the tile to travel to." */
    int from = page * 10;
    int cnt = n - from > 10 ? 10 : n - from;
    int more = n > from + 10;
    int rows = cnt + (more ? 1 : 0);
    /* the row labels (census: Europe = "<homeport> (<country>)", pager
     * "(More)") ride the live-front channel for the board's picker */
    CR.n_ask_rows = 0;
    for (int q = 0; q < cnt; q++) {
        if (ecs[from + q] < 0)
            snprintf(CR.ask_rows[CR.n_ask_rows++],
                     sizeof(CR.ask_rows[0]), "%s (%s)",
                     dat_nations[cs_nation()].homeport,
                     dat_nations[cs_nation()].country);
        else
            snprintf(CR.ask_rows[CR.n_ask_rows++],
                     sizeof(CR.ask_rows[0]), "%.24s",
                     CS.colonies[ecs[from + q]].name);
    }
    if (more)
        snprintf(CR.ask_rows[CR.n_ask_rows++],
                 sizeof(CR.ask_rows[0]), "(More)");
    ev_emit(ship ? "SAILPORT" : "TRAVELPLACE", 0, 0, 0, 0);
    int k = ask_choice();
    CR.n_ask_rows = 0;
    if (k < 0 || k >= rows) { UI.goto_arm = 1; return; }
    if (more && k == rows - 1) { begin_goto_page(ui, page + 1); return; }
    int e = ecs[from + k];
    if (e < 0) {                         /* the Europe row (func_022CDC) */
        if ((CR.woi_flags & WOI_DECLARED) && !(CR.woi_flags & WOI_WON)) {
            ev_emit("EUROPENOTAVAIL", 0, 0, 0, 0);
            return;
        }
        /* off the lane this only ORDERS the ship there (game.js's
         * orderSailHome); the harbour opens when it actually departs */
        if (cmd_order_sail_home(ui)) {
            if (UI.sel >= CR.n_units_order)
                UI.sel = CR.n_units_order ? CR.n_units_order - 1 : 0;
            UI.screen = SCR_EUROPE;
        } else {
            UI.goto_arm = 0;                 /* setGoTo (game.js:2268) */
            advance();
        }
        return;
    }
    cmd_goto(ui, CS.colonies[e].map_x, CS.colonies[e].map_y);
    advance();                           /* setGoTo (game.js:2268) */
}

/* the briefing's page-1 dismissal: the JS continues briefing -> king
 * audience -> the ten LEVN tutorial cards -> beginGame (onClick
 * game.js:12076-12084).  The king/cards cinematics need pak assets not
 * yet carried (KINGLSS1/LEVN*.PIK + the @VICEROY scroll) — FLAGGED
 * follow-up; until then the C boot starts the game here.  beginGame
 * ends on centerOn(start) with sel 0 (game.js:749). */
static void brief_begin(void) {
    colopy_init(colopy_front_seed);
    colopy_new_game((uint8_t)UI.nation, (uint8_t)UI.difficulty, UI.leader);
    snprintf(CR.leader, sizeof(CR.leader), "%s", UI.leader);
    UI.sel = 0;
    center_on((int)dat_starts[UI.nation][0], (int)dat_starts[UI.nation][1]);
    UI.screen = SCR_MAP;
}

/* openPedia (game.js:11429) */
static void open_pedia(int cat) {
    UI.pedia_cat = (int8_t)cat;
    UI.pedia_sel = 0;
    UI.pedia_mode = 0;
    UI.screen = SCR_PEDIA;
}

static void open_trade_menu(int mode);
static void run_menu_row(void) {
    if (UI.open_menu < 0) return;
    rm_mrow *rows = mrows_run;
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
        /* nobody left to wait for = end the turn.  The only ORDERS route
         * out of an all-ordered board (see the row builder's note). */
        if (!next_unit() && colopy_front_live) advance();
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
    } else if (strcmp(l, "Find Colony") == 0) {
        /* findColony (game.js:11326): the @FINDCITY entry dialog —
         * live-front only (openDialog is inert under the harness) */
        if (colopy_front_live) {
            UI.dlg = 8;
            UI.dlg_entry[0] = 0;
        }
    } else if (strcmp(l, "Show Hidden Terrain") == 0) {
        UI.show_hidden = (int8_t)!UI.show_hidden;
    /* the zoom rows (game.js:11375-11383; MENU.TXT spells the accels
     * into the labels, both spellings resolve) */
    } else if (strcmp(l, "Zoom In") == 0 ||
               strcmp(l, "Zoom In   Z") == 0) {
        set_zoom(UI.zoom - 1);
    } else if (strcmp(l, "Zoom Out") == 0 ||
               strcmp(l, "Zoom Out   X") == 0) {
        set_zoom(UI.zoom + 1);
    } else if (strcmp(l, "Zoom Level 15 x 12") == 0) {
        set_zoom(0);
    } else if (strcmp(l, "Zoom Level 30 x 24") == 0) {
        set_zoom(1);
    } else if (strcmp(l, "Zoom Level 60 x 48") == 0) {
        set_zoom(2);
    } else if (strcmp(l, "Zoom Level 120 x 96") == 0) {
        set_zoom(3);
    /* TRADE (game.js:11386-11389) */
    } else if (strcmp(l, "Create Trade Route") == 0) {
        open_trade_menu(1);
    } else if (strcmp(l, "Edit Trade Route") == 0) {
        /* the DOS route editor's stop/cargo pass (func_060C34 dest picker
         * + func_060D8C @CARGOLOAD/@CARGOUNLOAD lanes) — B3.4 */
        open_trade_menu(4);
    } else if (strcmp(l, "Begin Trade Route") == 0) {
        open_trade_menu(2);
    } else if (strcmp(l, "Delete Trade Route") == 0) {
        open_trade_menu(3);
    /* ORDERS rows — the JS dispatch table (game.js:11350) binds these
     * to the SAME functions the map keys run, so each row re-enters
     * in_key with its key (the menu is already closed at this point) */
    } else if (strcmp(l, "Build Colony") == 0 ||
               strcmp(l, "Join Colony (B)") == 0) {
        in_key("b", 0, 0);
    } else if (strcmp(l, "Clear Forest (P)") == 0 ||
               strcmp(l, "Plow Fields  (P)") == 0) {
        in_key("p", 0, 0);
    } else if (strcmp(l, "Build Road") == 0) {
        in_key("r", 0, 0);
    } else if (strcmp(l, "Load Cargo") == 0) {
        in_key("l", 0, 0);
    } else if (strcmp(l, "Unload Cargo") == 0) {
        in_key("u", 0, 0);
    } else if (strcmp(l, "Go to Port") == 0 ||
               strcmp(l, "Return to Europe") == 0) {
        in_key("e", 0, 0);               /* both = returnToEurope (11360) */
    } else if (strcmp(l, "Dump Cargo Overboard") == 0) {
        in_key("o", 0, 0);
    } else if (strcmp(l, "Disband Unit (shift-D)") == 0) {
        in_key("D", 0, 1);
    } else if (strcmp(l, "Pillage") == 0) {
        pillage_row();
    } else if (strcmp(l, "Go to Place") == 0) {
        if (ui >= 0) begin_goto_page(ui, 0);   /* beginGoTo (game.js:2244) */
    /* GAME rows */
    } else if (strcmp(l, "DECLARE INDEPENDENCE") == 0) {
        declare_independence();
    } else if (strcmp(l, "Retire") == 0) {
        /* retire (game.js:8153): @RETIRE row 0 confirms */
        ev_emit("RETIRE", 0, 0, 0, 0);
        if (ask_choice() == 0) end_game_sequence();
    } else if (strcmp(l, "Exit to DOS") == 0) {
        /* exitToDos (game.js:8059): @DOS row 0 confirms -> title */
        ev_emit("DOS", 0, 0, 0, 0);
        if (ask_choice() == 0) {
            UI.screen = SCR_TITLE;
            UI.menu_row = 0;
        }
    } else if (strcmp(l, "Game Options") == 0) {
        UI.options_which = 0;            /* openOptions (game.js:7957) */
        UI.options_row = 0;
        UI.screen = SCR_OPTIONS;
    } else if (strcmp(l, "Colony Report Options") == 0) {
        UI.options_which = 1;
        UI.options_row = 0;
        UI.screen = SCR_OPTIONS;
    } else if (strcmp(l, "Sound Options") == 0) {
        UI.options_which = 2;
        UI.options_row = 0;
        UI.screen = SCR_OPTIONS;
    } else if (strcmp(l, "Pick Music") == 0) {
        /* the picker is byte-verified and the tune id is real state;
         * PLAYBACK is the undecoded driver overlay (see pick_music) */
        pick_music();
    /* the COLONIZOPEDIA rows + F1 (the JS dispatch, 11393-11416) */
    } else if (strcmp(l, "Cargo Types") == 0) {
        open_pedia(0);
    } else if (strcmp(l, "Unit Types") == 0) {
        open_pedia(1);
    } else if (strcmp(l, "Terrain Types") == 0 ||
               strcmp(l, "F1 Terrain Information") == 0) {
        open_pedia(2);
    } else if (strcmp(l, "Colonist Skills") == 0) {
        open_pedia(3);
    } else if (strcmp(l, "Colony Buildings") == 0) {
        open_pedia(4);
    } else if (strcmp(l, "Founding Fathers") == 0) {
        open_pedia(5);
    } else if (strcmp(l, "Miscellaneous") == 0) {
        open_pedia(6);
    } else if (strcmp(l, "Complete") == 0) {
        open_pedia(7);
    } else if (strcmp(l, "Save Game") == 0) {
        UI.request = 'S';                /* the board shell owns the disk */
    } else if (strcmp(l, "Load Game") == 0) {
        UI.request = 'L';
    } else if (l[0] == 'F' && l[1] >= '1' && l[1] <= '9') {
        /* the REPORTS ladder rows: "F<N> <Adviser>" */
        int fn = l[1] - '0';
        int off = 2;
        if (l[2] >= '0' && l[2] <= '9') { fn = fn * 10 + l[2] - '0'; off = 3; }
        if (l[off] == ' ') {
            if (fn == 1) { open_pedia(2); return; }   /* hard rule 7 */
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
/* the create flow's pending stops survive the TRADETYPE ask + the
 * @TRADENAME entry dialog (kind 5) */
static int16_t pending_stops[4];
static int pending_n, pending_sea;

static void dialog_done(int cancel) {
    if (UI.dlg == 8) {               /* FINDCITY (findColony 11326): the
                                      * name-PREFIX search; a miss says
                                      * @NOCITY with what was typed */
        char q[24];
        snprintf(q, sizeof(q), "%s", UI.dlg_entry);
        UI.dlg = 0;
        UI.dlg_entry[0] = 0;
        if (cancel) return;
        char *b = q;
        while (*b == ' ') b++;
        char *e5 = b + strlen(b);
        while (e5 > b && e5[-1] == ' ') *--e5 = 0;
        if (!*b) return;
        size_t qn = strlen(b);
        for (int i = 0; i < CS.n_colonies; i++) {
            if ((CS.colonies[i].owner_power & 3) != cs_nation()) continue;
            char nm[25];
            memcpy(nm, CS.colonies[i].name, 24);
            nm[24] = 0;
            size_t j = 0;
            for (; j < qn && nm[j]; j++) {
                char a = nm[j], bb = b[j];
                if (a >= 'A' && a <= 'Z') a = (char)(a + 32);
                if (bb >= 'A' && bb <= 'Z') bb = (char)(bb + 32);
                if (a != bb) break;
            }
            if (j == qn) {
                center_on(CS.colonies[i].map_x, CS.colonies[i].map_y);
                return;
            }
        }
        ev_emit("NOCITY", 0, 0, b, 0);
        return;
    }
    if (UI.dlg == 7) {               /* COLONY (nameAndFound 2123): the
                                      * founding name; empty = suggested */
        char nm[24];
        snprintf(nm, sizeof(nm), "%s", UI.dlg_entry);
        int fu = UI.dlg_unit;
        UI.dlg = 0;
        UI.dlg_entry[0] = 0;
        char *b = nm;
        while (*b == ' ') b++;
        char *e4 = b + strlen(b);
        while (e4 > b && e4[-1] == ' ') *--e4 = 0;
        if (fu < 0 || fu >= CS.n_units) return;
        int ord = cmd_found_colony(fu, *b ? b : 0);
        if (UI.sel >= CR.n_units_order)
            UI.sel = CR.n_units_order ? (int8_t)(CR.n_units_order - 1) : 0;
        if (ord >= 0) {
            UI.colony = (int8_t)ord;
            UI.screen = SCR_COLONY;
        }
        return;
    }
    if (UI.dlg == 6) {               /* LANDHO (askLandName 10882): the
                                      * discovery plate's naming prompt;
                                      * an empty entry takes @default */
        char nm[24];
        snprintf(nm, sizeof(nm), "%s", UI.dlg_entry);
        UI.dlg = 0;
        UI.dlg_entry[0] = 0;
        char *b = nm;
        while (*b == ' ') b++;
        char *e3 = b + strlen(b);
        while (e3 > b && e3[-1] == ' ') *--e3 = 0;
        snprintf(CR.new_land, sizeof(CR.new_land), "%s",
                 (!cancel && *b) ? b : rm_event_default("LANDHO"));
        return;
    }
    if (UI.dlg == 5) {               /* TRADENAME (game.js:7849): the
                                      * trimmed entry names the route;
                                      * empty falls back to routeName */
        char nm[26];
        snprintf(nm, sizeof(nm), "%s", UI.dlg_entry);
        UI.dlg = 0;
        UI.dlg_entry[0] = 0;
        if (cancel) return;
        char *b = nm;
        while (*b == ' ') b++;
        char *e2 = b + strlen(b);
        while (e2 > b && e2[-1] == ' ') *--e2 = 0;
        route_create(pending_stops, pending_n, pending_sea,
                     *b ? b : 0);
        return;
    }
    if (UI.dlg == 4) {               /* RENAMECOLONY (game.js:2198):
                                      * a TRIMMED nonempty entry renames,
                                      * anything else leaves the name */
        int cci = UI.dlg_port;
        char nm[24];
        snprintf(nm, sizeof(nm), "%s", UI.dlg_entry);
        UI.dlg = 0;
        UI.dlg_entry[0] = 0;
        if (cancel) return;
        char *b = nm;
        while (*b == ' ') b++;
        char *e = b + strlen(b);
        while (e > b && e[-1] == ' ') *--e = 0;
        if (*b && cci >= 0 && cci < CS.n_colonies)
            snprintf(CS.colonies[cci].name,
                     sizeof(CS.colonies[cci].name), "%s", b);
        return;
    }
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
    /* only a NUMERIC dialog closes on Escape (dialogKey, game.js:995):
     * a text entry has no cancel — it commits, empty = the fallback */
    if (key_is(k, "Escape")) {
        if (UI.dlg < 4) dialog_done(1);
        return;
    }
    if (key_is(k, "Backspace")) {
        size_t n = strlen(UI.dlg_entry);
        if (n) UI.dlg_entry[n - 1] = 0;
        return;
    }
    int printable = UI.dlg >= 4 ? (k[0] >= ' ' && k[0] <= '~')
                                : (k[0] >= '0' && k[0] <= '9');
    if (k[0] && !k[1] && printable) {
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

/* ---- the Europe harbour context menus (em 4 ship / 5 dockunit) ------
 * euroShipRows (game.js:4682): front / sail / unload-all / close.
 * dockUnitRows (game.js:4590): the board-or-hold pair head, move to
 * front, the eligible @ARMOPTIONS verbs (euro_arm_rows), bless/unbless
 * by entry type, close.  acts: 0 board/noboard, 1 front, 2 arm (verb),
 * 3 bless, 4 unbless, 5 close. */
static int euro_port_of(int ordinal) {
    int ord = -1;
    for (int q = 0; q < CR.n_europe; q++) {
        if (CR.europe[q].state != 0) continue;
        if (++ord == ordinal) return q;
    }
    return -1;
}
static int dock_menu_rows(int kd, int acts[16], int verbs[16]) {
    if (kd < 0 || kd >= CR.n_dock_units) return 0;
    int n = 0;
    acts[n] = 0; verbs[n++] = 0;
    acts[n] = 1; verbs[n++] = 0;
    uint8_t vids[8];
    int na = euro_arm_rows(kd, vids);
    for (int i = 0; i < na && n < 14; i++) { acts[n] = 2; verbs[n] = vids[i]; n++; }
    int tt = entry_unit_type(&CR.dock_units[kd]);
    if (tt >= 0 && strcmp(dat_units[tt].name, "Colonists") == 0) {
        acts[n] = 3; verbs[n++] = 0;
    } else if (tt >= 0 && strcmp(dat_units[tt].name, "Missionaries") == 0) {
        acts[n] = 4; verbs[n++] = 0;
    }
    acts[n] = 5; verbs[n++] = 0;
    return n;
}
static int unit_row_by_name(const char *name) {
    for (int i = 0; i < DAT_UNITS_COUNT; i++)
        if (strcmp(dat_units[i].name, name) == 0) return i;
    return -1;
}
/* euroContextCommit (game.js:4838) */
static void euro_context_commit(void) {
    int menu = UI.euro_menu, row = UI.euro_menu_row;
    UI.euro_menu = 0;                    /* the menu closes FIRST */
    int port = euro_port_of(UI.euro_ship);
    if (menu == 4) {                     /* the ship menu */
        if (port < 0) return;
        if (row == 0) {                  /* Move to front. */
            euro_crossing e = CR.europe[port];
            memmove(&CR.europe[1], &CR.europe[0],
                    (size_t)port * sizeof(euro_crossing));
            CR.europe[0] = e;
            UI.euro_ship = 0;
        } else if (row == 1) {           /* Set sail: confirmSailAway is
                                          * an openDialog — inert under
                                          * the harness; a live front end
                                          * sails on the spot */
            if (colopy_front_live) euro_sail_new_world(port);
        } else if (row == 2) {           /* Unload all cargo = sell */
            hold_slot snap[EURO_HOLD_MAX];
            int n = CR.europe[port].n_hold;
            memcpy(snap, CR.europe[port].hold, sizeof(snap));
            for (int i = 0; i < n; i++)
                if (snap[i].qty > 0)
                    euro_sell_from_ship(port, snap[i].good, snap[i].qty);
        }
        return;
    }
    /* the dock-unit menu */
    int acts[16], verbs[16];
    int kd = UI.euro_dock_sel;
    int n = dock_menu_rows(kd, acts, verbs);
    if (row < 0 || row >= n) return;
    immigrant *e = &CR.dock_units[kd];
    switch (acts[row]) {
    case 0:
        if (e->no_board) {               /* 'board': onto the active ship */
            if (port < 0 || CR.europe[port].n_pass >= 6) return;
            immigrant b = *e;
            b.no_board = 0;
            memmove(e, e + 1,
                    (size_t)(CR.n_dock_units - kd - 1) * sizeof(immigrant));
            CR.n_dock_units--;
            CR.europe[port].pass[CR.europe[port].n_pass++] = b;
        } else {                         /* 'noboard': hold on the dock */
            e->no_board = 1;
        }
        break;
    case 1: {                            /* move to the dock front */
        immigrant b = *e;
        memmove(&CR.dock_units[1], &CR.dock_units[0],
                (size_t)kd * sizeof(immigrant));
        CR.dock_units[0] = b;
        break;
    }
    case 2:
        euro_arm_dock(kd, verbs[row]);
        break;
    case 3: {                            /* bless as Missionaries */
        int r2 = unit_row_by_name("Missionaries");
        if (r2 >= 0) e->type_ov = (uint8_t)(r2 + 1);
        break;
    }
    case 4: {                            /* unbless */
        int r2 = unit_row_by_name("Colonists");
        if (r2 >= 0) e->type_ov = (uint8_t)(r2 + 1);
        break;
    }
    default:
        break;                           /* close */
    }
}

/* ---- @ARMOPTIONS row labels ----------------------------------------
 * These live HERE, not in cport/core/colopy_europe.c, because the sim
 * core must never reference display text: tools/gen_c_data.py refuses
 * to emit if any sim source under cport/core names a dat_events_
 * symbol, and that
 * refusal is what keeps colopy_text.c droppable from flash in favour
 * of the SD pack's TEXT section (cport/MEMORY_BUDGET.md). The guard
 * caught this on 2026-08-17, the block having been written into
 * colopy_europe.c first. */
/* The @ARMOPTIONS price slots: NUMBER0 = Muskets, NUMBER1 = Tools,
 * NUMBER2 = Horses, each the BUY price of one full equip lot at this turn's
 * ask.  Mirrors armOptionSubs (game.js) exactly, including the flagged part:
 * the section carries ONE number per good, shown by both the buy row
 * ("costs") and the sell row ("save"), while the two transactions are worth
 * different amounts.  Which the engine puts there is unread; the buy price
 * goes in.  Do not make them agree — that would be inventing a rule. */
static int32_t armopt_number(int slot) {
    switch (slot) {
    case 0: return market_ask(MUSKETS) * 50;
    case 1: return market_ask(TOOLS) * 100;
    case 2: return market_ask(HORSES) * 50;
    default: return 0;
    }
}

/* The numeric half of fill_template (colopy_dialog.c) — @ARMOPTIONS rows carry
 * %NUMBERn and nothing else, and the core must not reach up into the render
 * layer for a four-line substitution. */
static void armopt_fill(const char *line, char *out, int cap) {
    int o = 0;
    for (const char *q = line; *q && o + 1 < cap;) {
        if (strncmp(q, "%NUMBER", 7) == 0 && q[7] >= '0' && q[7] <= '9') {
            char nb[16];
            snprintf(nb, sizeof(nb), "%ld", (long)armopt_number(q[7] - '0'));
            for (const char *c = nb; *c && o + 1 < cap;) out[o++] = *c++;
            q += 8;
            continue;
        }
        out[o++] = *q++;
    }
    out[o] = 0;
}

/* an @ARMOPTIONS equip row, read from the section itself (rows 3..8 line up
 * 1:1 with ARM[0..5] — spec/ui/context_dialogs.md §4).  This used to be a
 * hand-built "Soldiers (buy 50 Muskets)" stand-in, which was neither the
 * engine's wording nor the JS port's. */
static void euro_arm_verb_label(int verb, const immigrant *e,
                                char *out, int cap) {
    (void)e;
    if (verb < 0 || verb >= 6) { if (cap) out[0] = 0; return; }
    armopt_fill(dat_events_armoptions_body[3 + verb], out, cap);
}

/* euroMenuRows (game.js:4662) as board-facing labels — shared with the
 * shells' euro-menu painter and the pointer layer's row hit-test.  The
 * exact engine row text is unread; prices ride the labels where the JS
 * shows them (TRAIN "(Cost: N)"; RECRUIT hides its per-row price). */
int ui_euro_menu_rows(char out[][64], char notes[][64], int cap) {
    for (int i = 0; i < cap; i++) notes[i][0] = 0;
    int n = 0;
    switch (UI.euro_menu) {
    case 1:                              /* recruit: (None) + 3 dock */
        snprintf(out[n++], 64, "(None)");
        for (int i = 0; i < 3 && n < cap; i++)
            snprintf(out[n++], 64, "%s", immigrant_name(&CR.dock[i]));
        break;
    /* The price is a RIGHT-ALIGNED second column, not part of the label —
     * census_euro_train shows "(Cost: N)" hard against the box's right
     * edge.  It was concatenated into the row string until 2026-08-17,
     * which laid the board's shop menus out unlike the reference port's
     * (D12).  @MISC 13/14 are the "(Cost:" and ")" fragments. */
    case 2:                              /* the purchase catalog */
        for (int r = 0; r < 6 && n < cap; r++) {
            snprintf(out[n], 64, "%s", euro_purchase_unit(r));
            snprintf(notes[n], 64, "%s %ld%s", dat_text_misc[13],
                     (long)euro_purchase_price(r), dat_text_misc[14]);
            n++;
        }
        break;
    case 3:                              /* train, sorted by cost */
        snprintf(out[n], 64, "%s", dat_text_misc[3]);        /* None */
        notes[n][0] = 0;
        n++;
        for (int r = 0; r < DAT_JOBTRAIN_COUNT && n < cap; r++) {
            snprintf(out[n], 64, "%s", euro_train_expert(r));
            snprintf(notes[n], 64, "%s %ld%s", dat_text_misc[13],
                     (long)euro_train_cost(r), dat_text_misc[14]);
            n++;
        }
        break;
    case 4:                              /* euroShipRows — @EUROPESHIPOPTIONS */
        for (int r = 0; r < 4 && n < cap; r++)
            snprintf(out[n++], 64, "%s", dat_events_europeshipoptions_body[r]);
        break;
    case 5: {                            /* dockUnitRows (4622) */
        int acts[16], verbs[16];
        int m = dock_menu_rows(UI.euro_dock_sel, acts, verbs);
        const immigrant *e = UI.euro_dock_sel >= 0 &&
                             UI.euro_dock_sel < CR.n_dock_units
                                 ? &CR.dock_units[UI.euro_dock_sel] : 0;
        for (int r = 0; r < m && n < cap; r++) {
            switch (acts[r]) {
            /* the twelve @ARMOPTIONS rows, read from the section
             * (spec/ui/context_dialogs.md §4): 0 don't-board / 1 board /
             * 2 move to front / 3..8 the equip verbs / 9 bless /
             * 10 cancel Missionary / 11 no changes. */
            case 0:
                snprintf(out[n++], 64, "%s",
                         dat_events_armoptions_body[e && e->no_board ? 1 : 0]);
                break;
            case 1:
                snprintf(out[n++], 64, "%s", dat_events_armoptions_body[2]);
                break;
            case 2:
                if (e) euro_arm_verb_label(verbs[r], e, out[n++], 64);
                break;
            case 3:
                snprintf(out[n++], 64, "%s", dat_events_armoptions_body[9]);
                break;
            case 4:
                snprintf(out[n++], 64, "%s", dat_events_armoptions_body[10]);
                break;
            default:
                snprintf(out[n++], 64, "%s", dat_events_armoptions_body[11]);
                break;
            }
        }
        break;
    }
    }
    return n;
}

/* the caption section each menu quotes (EURO_MENU_KEY, game.js:4684 +
 * the euroMenuBox caption picks) */
const char *ui_euro_menu_caption(void) {
    switch (UI.euro_menu) {
    case 1: return "RECRUIT";
    case 2: return "PURCHASE";
    case 3: return "KINGRECRUIT";
    case 4: return "EUROPESHIPCLICK";
    case 5: return "EUROPEARM";
    }
    return 0;
}

/* euroMenuCommit (game.js:4919) — shared by the Enter key and a row
 * click (the JS runs the same function from both) */
static void euro_menu_commit_row(void) {
    int row = UI.euro_menu_row;
    if (UI.euro_menu >= 4) {
        euro_context_commit();
        return;
    }
    if ((UI.euro_menu == 1 || UI.euro_menu == 3) && row == 0) {
        UI.euro_menu = 0;                /* the "(None)" head */
        return;
    }
    int32_t gold = CS.powers[cs_nation()].gold;
    int32_t cost = UI.euro_menu == 1 ? euro_recruit_cost(row - 1)
                 : UI.euro_menu == 2 ? euro_purchase_price(row)
                                     : euro_train_cost(row - 1);
    if (cost <= gold) {                  /* fail = euroMsg only */
        if (UI.euro_menu == 1) euro_recruit(row - 1);
        else if (UI.euro_menu == 2) euro_purchase(row);
        else euro_train(row - 1);
        UI.euro_menu = 0;
    }
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
/* test-only probe: the build picker's row model, so tools can diff it
 * against the JS colonyPopupRows() (see the build-picker TODO above). */
int ui_build_rows_probe(int cci, const char **names) {
    return build_rows(cci, names);
}

/* the JS c.building NAME for the record's target byte: a @BUILDING index,
 * or a unit target 0x2A + (type - 0x0B) — the engine's own encoding
 * (func_00B5A8 @0x00B5CE; picker commit @0x02B710 stores row - 2). */
static const char *build_target_name(const ColonyRecord *c) {
    int bip = c->building_in_production;
    int ut = build_target_unit_type((uint8_t)bip);
    if (ut >= 0) return dat_units[ut].name;
    return bip < DAT_BUILDINGS_COUNT ? dat_buildings[bip].name : NULL;
}
/* test-only probe: the CURRENT colony's build-target name, exported so
 * the input oracle can watch it.  The projection carried no build target
 * at all, which is why a target divergence stayed invisible until the
 * build picker made it visible as a row number (2026-08-17). */
const char *ui_build_target_probe(void) {
    int cci = player_colony_rec(UI.colony);
    if (cci < 0) return "";
    const char *n = build_target_name(&CS.colonies[cci]);
    return n ? n : "";
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
/* rushBuy — BYTE_VERIFIED 2026-08-29 (@0x2B779..@0x2B8C2): price =
 * 13 x remaining hammers + (tools price level + 4) x missing tools,
 * DOUBLED when no hammers are banked (+0x92 == 0, @0x2B7E9); @BUYME0
 * refuses past the purse, @BUYME1 row 2 ("Complete it.") tops the
 * hammer bank, adds the MISSING tools to stock (@0x2B8BA) and runs the
 * construction step.  A unit target prices via unitBuildRow
 * (func_00B65A: cost x32, clamp <40 -> 40, 40..51 -> 52). */
static void rush_buy(void) {
    int cci = player_colony_rec(UI.colony);
    if (cci < 0) return;
    ColonyRecord *c = &CS.colonies[cci];
    int bip = c->building_in_production;
    int32_t cost_h, tools10;
    const char *nm;
    if (bip < DAT_BUILDINGS_COUNT) {
        int first = bld_first_row(bip);      /* JS find() = first row */
        cost_h = dat_buildings[first].cost;
        tools10 = dat_buildings[first].tools_x10;
        nm = dat_buildings[first].name;
    } else if (build_target_unit_type((uint8_t)bip) >= 0) {
        int ur = build_target_unit_type((uint8_t)bip);
        nm = dat_units[ur].name;
        /* BYTE_VERIFIED func_00B65A: @UNIT hammers byte x32 (@0x0B6B7)
         * with the clamp ladder <40 -> 40, 40..51 -> 52 (@0x0B6BD) */
        cost_h = dat_units[ur].cost * 32;
        if (cost_h < 40) cost_h = 40;
        else if (cost_h < 52) cost_h = 52;
        tools10 = dat_units[ur].tools;
    } else {
        return;                              /* no target */
    }
    int32_t rem_h = cost_h - c->hammers;
    if (rem_h < 0) rem_h = 0;
    int32_t rem_t = tools10 * 10 - c->stock[TOOLS];
    if (rem_t < 0) rem_t = 0;
    /* market level = bid + 1 (the JS G.market byte) */
    int32_t cost = 13 * rem_h + (market_bid(TOOLS) + 1 + 4) * rem_t;
    if (c->hammers == 0) cost *= 2;          /* unstarted: x2 @0x2B7E9 */
    PowerRecord *p = &CS.powers[cs_nation()];
    if (cost > p->gold) {
        ev_emit("BUYME0", cost, p->gold, nm, 0);
        return;
    }
    ev_emit("BUYME1", cost, p->gold, nm, 0);
    if (ask_choice() != 1) return;
    p->gold -= cost;
    if (c->hammers < cost_h) c->hammers = (uint16_t)cost_h;
    c->stock[TOOLS] = (uint16_t)(c->stock[TOOLS] + rem_t);
    colony_advance_construction(cci, 0);
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
    int has_prof = prof < DAT_JOBEXPERT_COUNT /* 0 = Expert Farmers; 28 = none */;
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
/* ---- the colony popups' display model (colonyPopupRows 3895) --------
 * build: @CTITLE 4 titles it, row 0 is @CTITLE 5 "(No Production)",
 * labels in CAPITALS with "(N Hammers) (M Tools)" notes; jobs: @CTITLE
 * 8 + the colonist, row 0 "No job (plaza)", each workplace noting
 * "job - made".  Shared with the shells' painter and the hit-test. */
int ui_colony_popup_model(char labels[][40], char notes[][40],
                          char *title, int tcap, int cap) {
    int cci = player_colony_rec(UI.colony);
    if (cci < 0 || !UI.colony_popup) return 0;
    const ColonyRecord *c = &CS.colonies[cci];
    const char *names[BUILD_MAX_ROWS];
    if (UI.colony_popup == 3) {
        /* occupationRows (game.js:3883): every OUTDOOR job with THIS
         * cell's yield, then "Return to the fence" */
        int k = UI.colonist_sel, slot = -1;
        for (int q = 0; q < 8; q++)
            if ((uint8_t)c->tiles[q] == (uint8_t)k) slot = q;
        if (k < 0 || k >= c->population || slot < 0) return 0;
        snprintf(title, (size_t)tcap, "%s %s", dat_text_ctitle[8],
                 c->profession[k] < DAT_JOBEXPERT_COUNT
                     ? dat_jobexpert[c->profession[k]] : "");
        int sol = rt_sol(cci), n2 = 0;
        for (int job = 0; job <= 8 && n2 < cap - 1; job++) {
            int y = field_yield(c, sol, job, c->profession[k],
                                colony_cell_dx[slot], colony_cell_dy[slot]);
            int g = colony_job_good(job);
            snprintf(labels[n2], 40, "%s",
                     job < DAT_JOBS_COUNT ? dat_jobs[job] : "");
            snprintf(notes[n2], 40, "%d %s", y,
                     g >= 0 && g < N_GOODS ? dat_cargo[g].name : "");
            n2++;
        }
        /* then the colony's INDOOR workplaces — see the long note on
         * occupationRows in game.js: a field worker had no route to a
         * building but "Return to the fence" and a second menu, which
         * reads as "colonists cannot go in buildings".  Same rows the
         * plaza jobs menu offers, committed through the same gates. */
        const colony_rt *r = &CR.col[cci];
        for (int b = 0; b < r->n_bld && n2 < cap - 1; b++) {
            const char *nm = dat_buildings[r->bld[b]].name;
            int job = workplace_job_for_name(nm);
            if (job < 0) continue;
            int g = colony_job_good(job);
            const char *made = g >= 0 && g < N_GOODS ? dat_cargo[g].name
                             : g == -1 ? "Hammers" : g == -2 ? "Bells"
                             : g == -3 ? "Crosses" : "Teaching";
            snprintf(labels[n2], 40, "%s", nm);
            snprintf(notes[n2], 40, "%s - %s",
                     job < DAT_JOBS_COUNT ? dat_jobs[job] : "", made);
            n2++;
        }
        if (n2 < cap) {
            snprintf(labels[n2], 40, "Return to the fence");
            notes[n2][0] = 0;
            n2++;
        }
        return n2;
    }
    if (UI.colony_popup == 5) {              /* @SHIPOPTIONS, 6 bare rows */
        const UnitRecord *gu = UI.colony_popup_unit >= 0 &&
                               UI.colony_popup_unit < CR.n_units_order
            ? &CS.units[CR.units_order[UI.colony_popup_unit]] : 0;
        snprintf(title, (size_t)tcap, "%s",
                 gu ? dat_units[gu->type].name : "");
        int n5 = 0;
        for (int i = 0; i < 6 && n5 < cap; i++) {
            snprintf(labels[n5], 40, "%s", dat_events_shipoptions_body[i]);
            notes[n5][0] = 0;
            n5++;
        }
        return n5;
    }
    if (UI.colony_popup == 4) {              /* @UNITOPTIONS, 5 bare rows */
        const UnitRecord *gu = UI.colony_popup_unit >= 0 &&
                               UI.colony_popup_unit < CR.n_units_order
            ? &CS.units[CR.units_order[UI.colony_popup_unit]] : 0;
        snprintf(title, (size_t)tcap, "%s",
                 gu ? dat_units[gu->type].name : "");
        int n4 = 0;
        for (int i = 0; i < 5 && n4 < cap; i++) {
            snprintf(labels[n4], 40, "%s", dat_events_unitoptions_body[i]);
            notes[n4][0] = 0;
            n4++;
        }
        return n4;
    }
    if (UI.colony_popup == 6) {
        /* the OUTSIDE-jobs menu func_028D8C(1): @JOB rows 0x13..0x18
         * (@0x028DF1..@0x028DF7), titled like the jobs menu (the same
         * function builds both); what the engine prints beside a row is
         * unread — bare labels, FLAGGED */
        int k = UI.colonist_sel;
        const char *who = k >= 0 && k < c->population &&
                          c->profession[k] < DAT_JOBEXPERT_COUNT
                              ? dat_jobexpert[c->profession[k]] : "";
        snprintf(title, (size_t)tcap, "%s %s", dat_text_ctitle[8], who);
        int n6 = 0;
        for (int j = 0x13; j <= 0x18 && n6 < cap; j++) {
            snprintf(labels[n6], 40, "%s", j < DAT_JOBS_COUNT ? dat_jobs[j] : "");
            notes[n6][0] = 0;
            n6++;
        }
        return n6;
    }
    int n = UI.colony_popup == 2 ? build_rows(cci, names)
                                 : jobs_rows(cci, names);
    if (n > cap) n = cap;
    if (UI.colony_popup == 2) {
        snprintf(title, (size_t)tcap, "%s", dat_text_ctitle[4]);
        for (int i = 0; i < n; i++) {
            notes[i][0] = 0;
            if (!names[i]) {
                snprintf(labels[i], 40, "%s", dat_text_ctitle[5]);
                continue;
            }
            char up[40];
            snprintf(up, sizeof(up), "%s", names[i]);
            for (char *q = up; *q; q++)
                if (*q >= 'a' && *q <= 'z') *q = (char)(*q - 32);
            snprintf(labels[i], 40, "%s", up);
            for (int b = 0; b < DAT_BUILDINGS_COUNT; b++)
                if (strcmp(dat_buildings[b].name, names[i]) == 0) {
                    if (dat_buildings[b].tools_x10)
                        snprintf(notes[i], 40, "(%d Hammers) (%d Tools)",
                                 (int)dat_buildings[b].cost,
                                 (int)dat_buildings[b].tools_x10 * 10);
                    else
                        snprintf(notes[i], 40, "(%d Hammers)",
                                 (int)dat_buildings[b].cost);
                    break;
                }
        }
        return n;
    }
    {
        int k = UI.colonist_sel;
        const char *who = k >= 0 && k < c->population &&
                          c->profession[k] < DAT_JOBEXPERT_COUNT
                              ? dat_jobexpert[c->profession[k]] : "";
        snprintf(title, (size_t)tcap, "%s %s", dat_text_ctitle[8], who);
    }
    for (int i = 0; i < n; i++) {
        notes[i][0] = 0;
        if (!names[i]) {
            snprintf(labels[i], 40, "No job (plaza)");
            continue;
        }
        snprintf(labels[i], 40, "%s", names[i]);
        int job = workplace_job_for_name(names[i]);
        if (job < 0) continue;
        int g = colony_job_good(job);
        const char *made = g >= 0 && g < N_GOODS ? dat_cargo[g].name
                         : g == -1 ? "Hammers" : g == -2 ? "Bells"
                         : g == -3 ? "Crosses" : "Teaching";
        snprintf(notes[i], 40, "%s - %s",
                 job < DAT_JOBS_COUNT ? dat_jobs[job] : "", made);
    }
    return n;
}
int ui_colony_popup_small(void) { return UI.colony_popup == 2; }

/* bestFieldJob (game.js:2601): the field job with the best yield on
 * this cell; an EXPERT keeps his own trade when it yields anything */
static int best_field_job(int cci, int k, int dx, int dy) {
    const ColonyRecord *c = &CS.colonies[cci];
    int sol = rt_sol(cci), best = 0, besty = -1;
    for (int job = 0; job <= 8; job++) {
        int y = field_yield(c, sol, job, c->profession[k], dx, dy);
        if (y > besty) { besty = y; best = job; }
    }
    uint8_t prof = c->profession[k];
    if (prof) {
        for (int job = 0; job <= 8; job++)
            if (colony_is_expert(prof, job) &&
                field_yield(c, sol, job, prof, dx, dy) > 0)
                return job;
    }
    return best;
}

/* The occupation menu's shape: rows 0..8 are the outdoor jobs, then one
 * row per EMPLOYING building, then "Return to the fence" last.  The fence
 * used to be a written-down index 9 because the list ended there; it moves
 * with the building count now, so both the commit and the key handler's
 * wrap-around derive it from here rather than each keeping their own copy
 * (the two disagreeing is exactly how an off-by-one hides). */
static int occupation_bld_rows(int cci) {
    const colony_rt *r = &CR.col[cci];
    int n = 0;
    for (int b = 0; b < r->n_bld; b++)
        if (workplace_job_for_name(dat_buildings[r->bld[b]].name) >= 0) n++;
    return n;
}
static int occupation_row_count(int cci) { return 10 + occupation_bld_rows(cci); }

/* the OUTSIDE-jobs menu's row: func_02883E(slot, 0x13 + row) — the
 * validator, the refusals / the @ABANDON ask, then the eject op
 * (colonist_out).  An emptied colony is gone when this returns: the
 * engine closes the screen ([0x346]=0 @0x028D69) and removes the record
 * at the exit (func_02EE34 @0x02C94C). */
static void outside_commit(void) {
    int cci = player_colony_rec(UI.colony);
    int row = UI.colony_popup_row, k = UI.colonist_sel;
    UI.colony_popup = 0;                     /* close BEFORE the ask */
    if (cci < 0 || row < 0 || row > 5) return;
    if (k < 0 || k >= CS.colonies[cci].population) return;
    colonist_out(cci, k, 0x13 + row);
    if (player_colony_rec(UI.colony) != cci ||
        CS.colonies[cci].population == 0) {
        UI.screen = SCR_MAP;
        return;
    }
    if (UI.colonist_sel >= CS.colonies[cci].population)
        UI.colonist_sel = (int8_t)(CS.colonies[cci].population
                                       ? CS.colonies[cci].population - 1 : 0);
}

/* colonyPopupCommit 'occupation' (game.js:4003): a job row re-tasks the
 * worker on his cell (Teacher through the same guard); a BUILDING row
 * moves him indoors; the last row calls him back to the plaza */
static void occupation_commit(void) {
    int cci = player_colony_rec(UI.colony);
    if (cci < 0) { UI.colony_popup = 0; return; }
    ColonyRecord *c = &CS.colonies[cci];
    int k = UI.colonist_sel, row = UI.colony_popup_row;
    const colony_rt *r = &CR.col[cci];
    int fence_row = 9 + occupation_bld_rows(cci);
    if (k >= 0 && k < c->population) {
        if (row == fence_row) {
            /* "Return to the fence" is not a job, it is OUT of the colony:
             * the man stops being a member and stands on the square, where
             * the plaza row draws him in the garrison group and the food
             * count no longer feeds him (colonist_to_fence). */
            colonist_to_fence(cci, k);
            /* the last colonist out empties the colony: the engine closes
             * the screen ([0x346]=0 @0x028D69) and removes the record at
             * the exit (func_02EE34 @0x02C94C) — colonist_eject did the
             * removal, so leave the screen */
            if (player_colony_rec(UI.colony) != cci ||
                CS.colonies[cci].population == 0) {
                UI.colony_popup = 0;
                UI.screen = SCR_MAP;
                return;
            }
            if (UI.colonist_sel >= c->population)
                UI.colonist_sel = (int8_t)(c->population ? c->population - 1 : 0);
        } else if (row >= 9 && row < fence_row) {
            /* a BUILDING row: the same gates the plaza jobs menu applies,
             * then he leaves the field for the workplace */
            int seen = 0, job = -1;
            for (int b = 0; b < r->n_bld && job < 0; b++) {
                int j = workplace_job_for_name(dat_buildings[r->bld[b]].name);
                if (j < 0) continue;
                if (9 + seen == row) job = j;
                seen++;
            }
            if (job < 0) { UI.colony_popup = 0; return; }
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
        } else if (row >= 0 && row <= 8) {
            int job = row;
            if (job < DAT_JOBS_COUNT &&
                strcmp(dat_jobs[job], "Teacher") == 0 &&
                teacher_guard(cci, k)) {
                UI.colony_popup = 0;
                return;
            }
            c->occupation[k] = (uint8_t)job;
        }
    }
    UI.colony_popup = 0;
}

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
                    for (int t = 0x0B; t <= 0x11; t++)
                        if (strcmp(dat_units[t].name, nm) == 0)
                            id = build_target_for_unit_type(t);
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
    else if (UI.menu_row == 3) UI.request = 'L';   /* the board shell's
                                                    * SD .SAV picker */
}

/* the LIVE-front pickup after any dispatch: a woodcut the core wants
 * shown, or a unit the core wants selected (both -1/none under the
 * harness, so the oracles never see this path) */
static void front_pickup(void) {
    if (!colopy_front_live) return;  /* harness: channels never fill,
                                      * and a zeroed CR reads plate 0 */
    if (CR.ui_select >= 0) {
        UI.sel = (int)CR.ui_select;
        CR.ui_select = -1;
    }
    if (CR.wc_show >= 0 && UI.screen != SCR_WOODCUT) {
        UI.woodcut = CR.wc_show;
        UI.screen = SCR_WOODCUT;
    }
}

/* the plate dismissal (onClick woodcut case, game.js:12086): plates 1
 * and 2 route by NUMBER (map / the new colony), the rest by wc_after */
static void wc_dismiss(void) {
    int plate = UI.woodcut;
    int after = CR.wc_after;
    CR.wc_show = -1;
    CR.wc_after = 0;
    if (plate == 2) {
        UI.screen = SCR_COLONY;      /* BUILDING A COLONY -> the colony */
    } else if (plate != 1 && after == 1) {
        UI.village_row = 0;
        UI.screen = SCR_VILLAGE;
        village_first_welcome();     /* the @INDIANWELCOME chain */
    } else if (plate != 1 && after == 2) {
        UI.village_row = 0;
        UI.screen = SCR_VILLAGE;
    } else {
        UI.screen = SCR_MAP;
        /* plate 1 hands over to the naming prompt (game.js:12092):
         * "Land Ho!  What shall we call this new land?" — an entry
         * dialog, so live-front only (openDialog is inert here) */
        if (plate == 1 && colopy_front_live) {
            UI.dlg = 6;
            snprintf(UI.dlg_entry, sizeof(UI.dlg_entry), "%s",
                     rm_event_default("LANDHO"));
        }
    }
}


/* ---- the trade-route screen (openTradeMenu, game.js:7822) -----------
 * G.trade -> UI.trade_*: mode 1 create / 2 assign / 3 delete. */
static int player_colony_count2(void) {
    int n = 0;
    for (int i = 0; i < CS.n_colonies; i++)
        if ((CS.colonies[i].owner_power & 3) == cs_nation()) n++;
    return n;
}

int ui_trade_rows(char out[][64], int cap) {
    int n = 0;
    if (UI.trade_mode == 4 && UI.trade_phase == 1) {   /* edit: stop pick */
        struct colopy_route *r = &CR.routes[UI.trade_route];
        for (int k = 0; k < r->n_stops && n < cap; k++) {
            char sn[26];
            route_stop_name(r->stops[k], sn, (int)sizeof(sn));
            snprintf(out[n++], 64, "%s", sn);
        }
        return n;
    }
    if (UI.trade_mode == 4 && UI.trade_phase >= 2) {   /* edit: cargo lane */
        struct colopy_route *r = &CR.routes[UI.trade_route];
        int load = UI.trade_phase == 2;
        uint8_t *lane = load ? r->load[UI.trade_stop]
                             : r->unload[UI.trade_stop];
        int cnt = load ? r->n_load[UI.trade_stop]
                       : r->n_unload[UI.trade_stop];
        for (int g = 0; g < 16 && n < cap; g++) {
            int in = 0;
            for (int k = 0; k < cnt; k++) if (lane[k] == g) in = 1;
            snprintf(out[n++], 64, "%s%s", in ? "* " : "  ",
                     dat_cargo[g].name);
        }
        if (n < cap)
            snprintf(out[n++], 64, "%s",
                     load ? "Done -- choose what to unload" : "Done");
        return n;
    }
    if (UI.trade_mode == 1) {                /* create: stop choices */
        int pc = player_colony_count2(), o = -1;
        for (int i = 0; i < CS.n_colonies && n < cap; i++) {
            if ((CS.colonies[i].owner_power & 3) != cs_nation()) continue;
            o++;
            snprintf(out[n++], 64, "%.24s", CS.colonies[i].name);
        }
        (void)pc;
        if (n < cap)
            snprintf(out[n++], 64, "%s",
                     dat_nations[cs_nation()].homeport);
        if (UI.trade_n_stops >= 2 && n < cap)
            snprintf(out[n++], 64, "Done -- create the route");
        return n;
    }
    for (int i = 0; i < CR.n_routes && n < cap; i++) {
        char stops[40];
        int sp = 0;
        stops[0] = 0;
        for (int k = 0; k < CR.routes[i].n_stops; k++) {
            char sn[26];
            route_stop_name(CR.routes[i].stops[k], sn, (int)sizeof(sn));
            sp += snprintf(stops + sp, sizeof(stops) - (size_t)sp,
                           "%s%s", k ? " - " : "", sn);
            if (sp >= (int)sizeof(stops)) break;
        }
        snprintf(out[n++], 64, "%s (%s)", CR.routes[i].name, stops);
    }
    return n;
}

void ui_trade_sofar(char *out, int cap) {
    out[0] = 0;
    /* edit lane phases: carry the STOP NAME (the @CARGOLOAD %STRING0) */
    if (UI.trade_mode == 4) {
        if (UI.trade_phase >= 2)
            route_stop_name(
                CR.routes[UI.trade_route].stops[UI.trade_stop], out, cap);
        return;
    }
    if (UI.trade_mode != 1 || !UI.trade_n_stops) return;
    int sp = snprintf(out, (size_t)cap, "So far: ");
    for (int k = 0; k < UI.trade_n_stops && sp < cap; k++) {
        char sn[26];
        route_stop_name(UI.trade_stops[k], sn, (int)sizeof(sn));
        sp += snprintf(out + sp, (size_t)(cap - sp), "%s%s",
                       k ? " - " : "", sn);
    }
}

static void open_trade_menu(int mode) {
    if (mode != 1 && !CR.n_routes) {         /* @TRADENONE */
        ev_emit("TRADENONE", 0, 0, 0, 0);
        return;
    }
    if (mode == 1 && !player_colony_count2()) return;  /* msg only */
    UI.trade_mode = (int8_t)mode;
    UI.trade_row = 0;
    UI.trade_n_stops = 0;
    UI.trade_phase = 0;
    UI.trade_route = 0;
    UI.trade_stop = 0;
    UI.screen = SCR_TRADE;
}

/* tradeCommit (game.js:7841) */
static void trade_commit(void) {
    char rows[20][64];
    int n = ui_trade_rows(rows, 20);
    int row = UI.trade_row;
    if (row < 0 || row >= n) {
        UI.screen = SCR_MAP;
        UI.trade_mode = 0;
        return;
    }
    if (UI.trade_mode == 1) {
        int pc = player_colony_count2();
        int done_row = pc + 1;               /* after colonies + Europe */
        if (UI.trade_n_stops >= 2 && row == done_row) {
            for (int k = 0; k < UI.trade_n_stops; k++)
                pending_stops[k] = UI.trade_stops[k];
            pending_n = UI.trade_n_stops;
            UI.screen = SCR_MAP;
            UI.trade_mode = 0;
            /* @TRADETYPE: Sea route / Land route, then the @TRADENAME
             * entry dialog — openDialog is inert under the harness, so
             * the name modal (and the route) is front-live only */
            ev_emit("TRADETYPE", 0, 0, 0, 0);
            int choice = ask_choice();
            if (choice < 0) return;
            pending_sea = choice == 0;
            if (colopy_front_live) {
                UI.dlg = 5;
                route_auto_name(pending_stops, pending_n, UI.dlg_entry,
                                (int)sizeof(UI.dlg_entry));
            }
            return;
        }
        int16_t id = row < pc ? (int16_t)row : COLOPY_STOP_EUROPE;
        if (row >= done_row) return;         /* Done while < 2 stops */
        int dup = 0;
        for (int k = 0; k < UI.trade_n_stops; k++)
            if (UI.trade_stops[k] == id) dup = 1;
        if (UI.trade_n_stops < COLOPY_MAX_STOPS && !dup)
            UI.trade_stops[UI.trade_n_stops++] = id;
        return;
    }
    if (UI.trade_mode == 4) {                /* edit: the cargo editor */
        if (UI.trade_phase == 0) {           /* route pick */
            if (row >= CR.n_routes) {
                UI.screen = SCR_MAP;
                UI.trade_mode = 0;
                return;
            }
            UI.trade_route = (int8_t)row;
            UI.trade_phase = 1;
            UI.trade_row = 0;
            return;
        }
        struct colopy_route *r = &CR.routes[UI.trade_route];
        if (UI.trade_phase == 1) {           /* stop pick */
            UI.trade_stop = (int8_t)row;
            UI.trade_phase = 2;
            UI.trade_row = 0;
            return;
        }
        int load = UI.trade_phase == 2;
        uint8_t *lane = load ? r->load[UI.trade_stop]
                             : r->unload[UI.trade_stop];
        uint8_t *cnt = load ? &r->n_load[UI.trade_stop]
                            : &r->n_unload[UI.trade_stop];
        if (row >= 16) {                     /* Done */
            if (load) { UI.trade_phase = 3; UI.trade_row = 0; return; }
            UI.screen = SCR_MAP;
            UI.trade_mode = 0;
            return;
        }
        int at = -1;
        for (int k = 0; k < *cnt; k++) if (lane[k] == row) at = k;
        if (at >= 0) {                       /* toggle off */
            for (int k = at; k + 1 < *cnt; k++) lane[k] = lane[k + 1];
            (*cnt)--;
        } else if (*cnt < 6) {               /* six nibble slots a lane */
            lane[(*cnt)++] = (uint8_t)row;
        }
        return;
    }
    if (UI.trade_mode == 3) {                /* delete: @SUREDELETE */
        UI.screen = SCR_MAP;
        UI.trade_mode = 0;
        ev_emit("SUREDELETE", 0, 0, CR.routes[row].name, 0);
        if (ask_choice() != 0) return;
        /* func_0612E6: unbind the carriers on it, renumber the ones
         * above, splice (C3.5, 2026-09-02) */
        route_delete(row);
        return;
    }
    /* assign (7878) */
    int ui = sel_unit();
    UI.screen = SCR_MAP;
    UI.trade_mode = 0;
    int ship = ui >= 0 && dat_units[CS.units[ui].type].hull > 0;
    int wagon = ui >= 0 &&
                strcmp(dat_units[CS.units[ui].type].name,
                       "Wagon Train") == 0;
    if (ui >= 0 && (ship || wagon)) {
        int have = 0;
        for (int i = 0; i < CR.n_routes; i++)
            if (!!CR.routes[i].sea == ship) have = 1;
        if (!have) {                         /* @TRADENONE2 */
            ev_emit("TRADENONE2", 0, 0, ship ? "sea" : "land", 0);
            return;
        }
    }
    if (ui < 0 || (!ship && !wagon)) return; /* msg only */
    CR.unit_route[ui] = (int16_t)row;
    CR.unit_stop_index[ui] = 0;
    CS.units[ui].orders = 2;                 /* ORDER_TRADE */
    CS.units[ui].moves_remaining = 0;
    CR.unit_moves_undef[ui] = 0;
    advance();
}


/* ---- GAME "Pick Music" (func_023344 @0x023344, game.js:8016) --------
 * spec/ui/options_dialogs.md §3.  Both jump tables are byte-read: the
 * row->id table at file 0x02353A gives rows 1-12, whose late four are
 * NOT contiguous (Hornpipe/Bonny Morn/Hole In The Wall/Nightingale =
 * 0x39/0x38/0x3A/0x3B); rows 13-15 open a class sub-picker and bias
 * its 1-based answer, the Indian one skipping event-only id 0x34
 * (cmp ax,2; jle +4; inc ax @0x02351A).  The reverse table at file
 * 0x0233E4 preselects the row the current tune sits on — a tune from a
 * sub-picker highlights its SUBMENU row, and ids 0x34/0x37 none.
 *
 * Selecting is all the port can do: the sound itself is the external
 * "$sound$" driver overlay (§5), whose tune data lives inside
 * ASOUND/GSOUND/PSOUND/RSOUND.COL and has never been decoded.  The id
 * is real state ([0x96]), so the round trip is honest. */
static const uint8_t MUSIC_ROW_ID[12] = {
    0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
    0x39, 0x38, 0x3A, 0x3B,
};
static const struct { const char *key; uint8_t bias; int8_t skip_after; }
MUSIC_SUBMENU[3] = {
    { "PICKINDEPENDENCE", 0x28, 0 },
    { "PICKMILITARY",     0x2D, 0 },
    { "PICKINDIAN",       0x31, 2 },
};
static int music_row(int id) {
    for (int i = 0; i < 12; i++) if (MUSIC_ROW_ID[i] == id) return i;
    if (id >= 0x28 && id <= 0x2D) return 12;
    if (id >= 0x2E && id <= 0x31) return 13;
    if (id == 0x32 || id == 0x33 || id == 0x35 || id == 0x36) return 14;
    return 0;                    /* 0x34 / 0x37 / unset: no row */
}
void pick_music(void) {
    CR.ask_sel = (int8_t)music_row(CR.tune);   /* G.dialog.sel */
    ev_emit("PICKMUSIC", 0, 0, 0, 0);
    int choice = ask_choice();
    CR.ask_sel = 0;
    if (choice < 0) return;
    if (choice < 12) { CR.tune = MUSIC_ROW_ID[choice]; return; }
    if (choice >= 15) return;
    int sub = choice - 12;
    ev_emit(MUSIC_SUBMENU[sub].key, 0, 0, 0, 0);
    int pick = ask_choice();
    if (pick < 0) return;
    int row = pick + 1;                        /* the picker is 1-based */
    if (MUSIC_SUBMENU[sub].skip_after && row > MUSIC_SUBMENU[sub].skip_after)
        row++;
    CR.tune = (uint8_t)(row + MUSIC_SUBMENU[sub].bias);
}

/* "Unload all cargo" (@SHIPOPTIONS row 4, unloadAllCargo in game.js): the
 * WHOLE hold into the warehouse in one step, unlike the 'u' key's per-slot
 * @CARGOUNLOAD/@HOWMUCH2 pair.  Same @WAREHOUSEFULL gate, asked once for the
 * first good that would cross the byte-read 100-ton threshold (the engine's
 * per-good behaviour is unread — flagged at the 'u' site too). */
static void unload_all_cargo(int ui, int ci) {
    ColonyRecord *c = &CS.colonies[ci];
    int full = -1;
    for (int s = 0; s < CR.unit_n_hold[ui]; s++) {
        const hold_slot *h = &CR.unit_hold[ui][s];
        if (c->stock[h->good] + h->qty > 100) { full = s; break; }
    }
    if (full >= 0) {
        const hold_slot *h = &CR.unit_hold[ui][full];
        ev_emit("WAREHOUSEFULL", c->stock[h->good], 100, c->name,
                dat_cargo[h->good].name);
        if (ask_choice() != 1) return;
    }
    for (int s = CR.unit_n_hold[ui] - 1; s >= 0; s--) {
        hold_slot *h = &CR.unit_hold[ui][s];
        if (h->qty <= 0) continue;
        int32_t v = (int32_t)c->stock[h->good] + h->qty;
        c->stock[h->good] = (uint16_t)(v > 0xFFFF ? 0xFFFF : v);
        hold_add(CR.unit_hold[ui], &CR.unit_n_hold[ui], h->good, -h->qty);
    }
}

/* @SHIPOPTIONS rows (shipOptionsCommit, game.js): 0 move to front,
 * 1 clear orders, 2 sentry, 3 anchor in harbor (= Fortify), 4 unload all
 * cargo, 5 no changes.  Rows 0..3 are @UNITOPTIONS' shape over a ship. */
static void ship_options_commit(void) {
    int q = UI.colony_popup_unit;
    if (q < 0 || q >= CR.n_units_order) { UI.colony_popup = 0; return; }
    int ui = CR.units_order[q];
    int row = UI.colony_popup_row;
    UI.colony_popup = 0;                     /* close BEFORE the unload ask */
    switch (row) {
    case 0:
        for (int i = q; i > 0; i--) CR.units_order[i] = CR.units_order[i - 1];
        CR.units_order[0] = (int16_t)ui;
        UI.sel = 0;
        break;
    case 1: CS.units[ui].orders = 0; break;
    case 2: CS.units[ui].orders = 1; break;
    case 3: CS.units[ui].orders = 5; break;
    case 4: {
        int ci = colony_rec_at_xy(CS.units[ui].map_x, CS.units[ui].map_y);
        if (ci >= 0) unload_all_cargo(ui, ci);
        break;
    }
    default: break;                          /* "No changes." */
    }
}

/* @UNITOPTIONS rows (unitOptionsCommit, game.js): 0 move to front,
 * 1 clear orders, 2 sentry/board, 3 fortify, 4 no changes.  The three
 * order rows write BYTE_VERIFIED @ORDERS values; "move to front"
 * reorders CR.units_order the way the JS reorders G.units. */
static void unit_options_commit(void) {
    int q = UI.colony_popup_unit;
    if (q < 0 || q >= CR.n_units_order) { UI.colony_popup = 0; return; }
    int ui = CR.units_order[q];
    switch (UI.colony_popup_row) {
    case 0:
        for (int i = q; i > 0; i--) CR.units_order[i] = CR.units_order[i - 1];
        CR.units_order[0] = (int16_t)ui;
        UI.sel = 0;
        break;
    case 1: CS.units[ui].orders = 0; break;
    case 2: CS.units[ui].orders = 1; break;
    case 3: CS.units[ui].orders = 5; break;
    default: break;                              /* "No changes." */
    }
    UI.colony_popup = 0;
}

/* customHouseMenu (game.js:3196): the per-good export toggle loop.
 * '*' marks an exported good ('customOff' is the JS map; the record's
 * custom_house_flags stores the inverse — bit SET = export on, the
 * importer's reading at game.js:10411); each pick toggles and the menu
 * re-opens until Done/none.  Rows ride the live-front channel. */
static void custom_house_menu(void) {
    int cci = player_colony_rec(UI.colony);
    if (cci < 0 || !colony_has_bld_name(cci, "Custom House")) return;
    ColonyRecord *c = &CS.colonies[cci];
    for (;;) {
        CR.n_ask_rows = 0;
        for (int i = 0; i < 16; i++)
            snprintf(CR.ask_rows[CR.n_ask_rows++],
                     sizeof(CR.ask_rows[0]), "%s%s",
                     (c->custom_house_flags >> i) & 1 ? "* " : "  ",
                     dat_cargo[i].name);
        snprintf(CR.ask_rows[CR.n_ask_rows++],
                 sizeof(CR.ask_rows[0]), "Done");
        ev_emit("CUSTOM", 0, 0, 0, 0);
        int ch = ask_choice();
        CR.n_ask_rows = 0;
        if (ch < 0 || ch >= 16) return;
        c->custom_house_flags ^= (uint16_t)(1u << ch);
    }
}

static void in_key_inner(const char *k, int alt, int shift);
void in_key(const char *k, int alt, int shift) {
    in_key_inner(k, alt, shift);
    front_pickup();
}

static void in_key_inner(const char *k, int alt, int shift) {
    /* the Combat Analysis panel is modal: it swallows the next key and
     * pops itself (onKey game.js: the G.combat check runs first) */
    if (CR.combat.active) { CR.combat.active = 0; return; }
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
        /* Enter/space = the click (game.js:12434); the shared script
         * never presses past page 0 */
        if (key_is(k, "Enter") || key_is(k, " ")) {
            if (UI.brief_page == 0) UI.brief_page = 1;
            else UI.screen = SCR_KING;       /* onClick 12078 */
        }
        break;
    case SCR_KING:
        if (key_is(k, "Enter") || key_is(k, " ")) {
            UI.card = 0;
            UI.screen = SCR_CARDS;           /* onClick 12080 */
        }
        break;
    case SCR_CARDS:
        if (key_is(k, "Enter") || key_is(k, " ")) {
            if (UI.card < 9) UI.card++;      /* onClick 12082 */
            else brief_begin();              /* beginGame -> map (12083) */
        }
        if (key_is(k, "Escape")) UI.screen = SCR_BRIEFING;   /* 12439 */
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
            rm_mrow *rows = mrows_key;
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
            /* F1 = the pedia TERRAIN page (hard rule 7);
             * F8 gated by woiLocked; F2-F10 = the report ladder */
            if (fn == 1) { open_pedia(2); return; }
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
        /* the trade menu key (game.js:12604): assign */
        if (key_is(k, "t") || key_is(k, "T")) { open_trade_menu(2); return; }
        /* §26.7 zoom keys (game.js:12608): z in, x out */
        if (key_is(k, "z") || key_is(k, "Z")) { set_zoom(UI.zoom - 1); return; }
        if (key_is(k, "x") || key_is(k, "X")) { set_zoom(UI.zoom + 1); return; }
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
            else if (colopy_front_live) {
                /* NOTHING is active — every unit is spent, or the
                 * player has no map unit at all (all colonists inside
                 * colonies, the ship at sea).  skipUnit returns early
                 * on a missing G.units[G.sel] (game.js:10874), so the
                 * JS never reaches advance() here and the turn cannot
                 * end: a live front would sit forever.  Space runs the
                 * turn itself.  FLAGGED live-front affordance — the
                 * DOS engine's own turn loop is not unit-driven, so it
                 * rolls over on its own; the harness keeps the JS
                 * behaviour (front_live 0) and stays in parity. */
                advance();
            }
        } else if (key_is(k, "Tab") || key_is(k, "w") || key_is(k, "W")) {
            next_unit();
        } else if (key_is(k, "a") || key_is(k, "A")) {
            if (ui >= 0) cmd_activate(ui);
        } else if (key_is(k, "f") || key_is(k, "F")) {
            if (ui >= 0) { cmd_set_order(ui, 5); advance(); }
        } else if (key_is(k, "s") || key_is(k, "S")) {
            if (ui >= 0) { cmd_set_order(ui, 1); advance(); }
        } else if (key_is(k, "p") || key_is(k, "P")) {
            /* the gated improveOrder path (@ONLYPIO/@NOROAD/@NOPLOW), like
             * the ORDERS menu rows; a refusal does not advance (JS) */
            if (ui >= 0) {
                cmd_improve(ui, 8);
                if (CS.units[ui].orders == 8) advance();
            }
        } else if (key_is(k, "r") || key_is(k, "R")) {
            if (ui >= 0) {
                cmd_improve(ui, 9);
                if (CS.units[ui].orders == 9) advance();
            }
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
                if (ord == -2) {
                    /* the @COLONY name dialog (live front only): the
                     * founding waits on the entry, prefilled with the
                     * name cmd_found_colony would pick */
                    if (colopy_front_live) {
                        UI.dlg = 7;
                        UI.dlg_unit = (int16_t)ui;
                        snprintf(UI.dlg_entry, sizeof(UI.dlg_entry), "%s",
                                 colony_suggested_name());
                    }
                    return;
                }
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
                    /* a ship off the lane is sent TO the lane and the
                     * harbour stays shut until it gets there */
                    if (!cmd_order_sail_home(ui)) {
                        UI.goto_arm = 0;     /* setGoTo (game.js:2268) */
                        advance();
                        break;
                    }
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
                    /* @WAREHOUSEFULL (game.js:11298): the pre-unload
                     * spoilage warning.  The FIRST hold good that would
                     * push the colony over the 100-ton threshold asks a
                     * 2-row confirm, and only row 1 ("...anyway") lets
                     * the unload run.  Absent here until 2026-08-17 —
                     * the C walked straight into @CARGOUNLOAD.  It went
                     * unseen because the fixed oracle script never had a
                     * loaded ship sitting in a colony until the standing-
                     * order fix changed which unit was active. */
                    int full = -1;
                    for (int s2 = 0; s2 < CR.unit_n_hold[ui]; s2++) {
                        const hold_slot *h = &CR.unit_hold[ui][s2];
                        if (CS.colonies[ci].stock[h->good] + h->qty > 100) {
                            full = s2;
                            break;
                        }
                    }
                    if (full >= 0) {
                        const hold_slot *h = &CR.unit_hold[ui][full];
                        ev_emit("WAREHOUSEFULL",
                                CS.colonies[ci].stock[h->good], 100,
                                CS.colonies[ci].name,
                                dat_cargo[h->good].name);
                        if (ask_choice() != 1) return;
                    }
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
         * ESC closes, everything else is swallowed.  All three popups
         * are modelled — build, jobs, and the scene panel's occupation
         * menu (kind 3, reached by tapping a working colonist twice). */
        if (UI.colony_popup) {
            int cci = player_colony_rec(UI.colony);
            const char *names[BUILD_MAX_ROWS];
            int n = 1;
            if (cci >= 0)
                n = UI.colony_popup == 2 ? build_rows(cci, names)
                  : UI.colony_popup == 3 ? occupation_row_count(cci)
                  : UI.colony_popup == 4 ? 5       /* @UNITOPTIONS */
                  : UI.colony_popup == 5 ? 6       /* @SHIPOPTIONS */
                  : UI.colony_popup == 6 ? 6       /* outside jobs 0x13..0x18 */
                                         : jobs_rows(cci, names);
            if (key_is(k, "ArrowUp"))
                UI.colony_popup_row = (int8_t)((UI.colony_popup_row + n - 1) % n);
            if (key_is(k, "ArrowDown"))
                UI.colony_popup_row = (int8_t)((UI.colony_popup_row + 1) % n);
            if (key_is(k, "Enter") || key_is(k, " ")) {
                if (UI.colony_popup == 2) build_picker_commit();
                else if (UI.colony_popup == 3) occupation_commit();
                else if (UI.colony_popup == 4) unit_options_commit();
                else if (UI.colony_popup == 5) ship_options_commit();
                else if (UI.colony_popup == 6) outside_commit();
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
        if (key_is(k, "b") || key_is(k, "B")) rush_buy();
        if (key_is(k, "e") || key_is(k, "E")) custom_house_menu();
        if (key_is(k, "r") || key_is(k, "R")) {
            /* renameColony (game.js:2195 via 12513): @RENAMECOLONY as
             * a text-entry modal, prefilled with the current name.
             * openDialog is inert under the shared harness (the trace
             * conventions), so the modal is front-live only. */
            int cci = player_colony_rec(UI.colony);
            if (colopy_front_live && cci >= 0) {
                UI.dlg = 4;
                UI.dlg_port = (int16_t)cci;
                snprintf(UI.dlg_entry, sizeof(UI.dlg_entry), "%s",
                         CS.colonies[cci].name);
            }
        }
        if (key_is(k, "l") || key_is(k, "L")) {
            /* @LOBOTOMIZE (game.js:12503): clear the selected
             * colonist's specialty on row 0 */
            int cci = player_colony_rec(UI.colony);
            if (cci >= 0) {
                ColonyRecord *c = &CS.colonies[cci];
                int k2 = UI.colonist_sel;
                /* prof 0 IS a specialty (Expert Farmers, C4.26) and can
                 * be cleared; "no specialty" is byte 28, not 0 */
                if (k2 >= 0 && k2 < c->population &&
                    c->profession[k2] < DAT_JOBEXPERT_COUNT) {
                    ev_emit("LOBOTOMIZE", 0, 0,
                            dat_jobexpert[c->profession[k2]], 0);
                    if (ask_choice() == 0) c->profession[k2] = 28;
                }
            }
        }
        if (key_is(k, "Enter")) {
            UI.colony_popup = 1;             /* 'jobs' */
            UI.colony_popup_row = 0;
        }
        if (key_is(k, "Escape") || key_is(k, "x")) UI.screen = SCR_MAP;
        break;
    case SCR_WOODCUT:
        if (key_is(k, "Enter") || key_is(k, " ") || key_is(k, "Escape"))
            wc_dismiss();
        break;
    case SCR_TRADE: {
        static char trows[20][64];      /* static: see the note in
                                         * in_click_inner (G1) */
        int tn = ui_trade_rows(trows, 20);
        if (tn < 1) tn = 1;
        if (key_is(k, "ArrowUp"))
            UI.trade_row = (int8_t)((UI.trade_row + tn - 1) % tn);
        if (key_is(k, "ArrowDown"))
            UI.trade_row = (int8_t)((UI.trade_row + 1) % tn);
        if (key_is(k, "Enter") || key_is(k, " ")) trade_commit();
        if (key_is(k, "Escape") || key_is(k, "x")) {
            UI.screen = SCR_MAP;
            UI.trade_mode = 0;
        }
        break;
    }
    case SCR_OPTIONS: {
        /* onKey options (game.js:12446): arrows walk, Enter toggles,
         * Escape/x leaves */
        int n = rm_options_rows(UI.options_which);
        if (n < 1) n = 1;
        if (key_is(k, "ArrowUp"))
            UI.options_row = (int8_t)((UI.options_row + n - 1) % n);
        if (key_is(k, "ArrowDown"))
            UI.options_row = (int8_t)((UI.options_row + 1) % n);
        if (key_is(k, "Enter") || key_is(k, " "))
            rm_options_toggle(UI.options_which, UI.options_row);
        if (key_is(k, "Escape") || key_is(k, "x")) UI.screen = SCR_MAP;
        break;
    }
    case SCR_PEDIA: {
        /* onKey pedia (game.js:12109) */
        int n = rm_pedia_count(UI.pedia_cat);
        if (n < 1) n = 1;
        if (UI.pedia_mode == 0) {
            if (key_is(k, "ArrowUp"))
                UI.pedia_sel = (int16_t)((UI.pedia_sel + n - 1) % n);
            if (key_is(k, "ArrowDown"))
                UI.pedia_sel = (int16_t)((UI.pedia_sel + 1) % n);
            if (key_is(k, "ArrowLeft"))
                UI.pedia_sel = (int16_t)(UI.pedia_sel >= 22
                                             ? UI.pedia_sel - 22 : 0);
            if (key_is(k, "ArrowRight")) {
                int v = UI.pedia_sel + 22;
                UI.pedia_sel = (int16_t)(v < n ? v : n - 1);
            }
            if (key_is(k, "Enter") || key_is(k, " ")) UI.pedia_mode = 1;
            if (key_is(k, "Escape") || key_is(k, "x")) UI.screen = SCR_MAP;
        } else {
            if (key_is(k, "ArrowLeft") || key_is(k, "ArrowUp"))
                UI.pedia_sel = (int16_t)((UI.pedia_sel + n - 1) % n);
            if (key_is(k, "ArrowRight") || key_is(k, "ArrowDown"))
                UI.pedia_sel = (int16_t)((UI.pedia_sel + 1) % n);
            if (key_is(k, "Escape") || key_is(k, "x")) UI.pedia_mode = 0;
        }
        break;
    }
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
            int cacts[16], cverbs[16];
            int n = UI.euro_menu == 1 ? 4        /* (None) + 3 candidates */
                  : UI.euro_menu == 2 ? 6        /* PURCHASE_CATALOG */
                  : UI.euro_menu == 3 ? 1 + DAT_JOBTRAIN_COUNT
                  : UI.euro_menu == 4 ? 4        /* the ship menu */
                  : dock_menu_rows(UI.euro_dock_sel, cacts, cverbs);
            if (n < 1) n = 1;
            if (key_is(k, "ArrowUp"))
                UI.euro_menu_row = (int8_t)((UI.euro_menu_row + n - 1) % n);
            if (key_is(k, "ArrowDown"))
                UI.euro_menu_row = (int8_t)((UI.euro_menu_row + 1) % n);
            if (key_is(k, "Enter") || key_is(k, " ")) euro_menu_commit_row();
            if (key_is(k, "Escape")) UI.euro_menu = 0;
            break;
        }
        /* §26.9 keys: arrows walk the market cursor, L/=/+ buy to the
         * active ship, R/1 P/2 T/3 open the recruit/purchase/train
         * menus (openEuroMenu, game.js:4778), K petitions the King,
         * S asks @SAILAWAY (confirmSailAway — live-front only, the
         * harness stubs openDialog), ESC/x/E exit.  The sell key runs
         * the @HOWMUCH5 amount modal, which is live on both sides. */
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
        if (key_is(k, "s") || key_is(k, "S")) {
            /* confirmSailAway (game.js:4904): @SAILAWAY openDialog —
             * inert under the harness; live: choice 0 sets sail */
            int sport = euro_port_of(UI.euro_ship);
            if (sport >= 0 && colopy_front_live) {
                ev_emit("SAILAWAY", 0, 0, 0, 0);
                if (ask_choice() == 0) euro_sail_new_world(sport);
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
 * market bar and exit — plus, since 2026-08-17, the colony popups /
 * scene panel / plaza colonist moves and the Europe context menus.
 * Only the DRAG layer is absent: every function it carries is
 * reachable through a menu or a tap, which is what the touch-only
 * board needs. */
static int hit(int mx, int my, int x, int y, int w, int h) {
    return mx >= x && mx < x + w && my >= y && my < y + h;
}

static void in_click_inner(int mx, int my, int right);
void in_click(int mx, int my, int right) {
    in_click_inner(mx, my, right);
    front_pickup();
}

static void in_click_inner(int mx, int my, int right) {
    (void)right;
    /* the Combat Analysis panel: any click dismisses it (onClick) */
    if (CR.combat.active) { CR.combat.active = 0; return; }
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
    case SCR_HOF:
        UI.screen = SCR_TITLE;
        break;
    case SCR_NAME:
        UI.brief_page = 0;
        UI.screen = SCR_BRIEFING;
        break;
    case SCR_BRIEFING:
        if (UI.brief_page == 0) UI.brief_page = 1;
        else UI.screen = SCR_KING;           /* onClick 12078 */
        break;
    case SCR_KING:
        UI.card = 0;
        UI.screen = SCR_CARDS;
        break;
    case SCR_CARDS:
        if (UI.card < 9) UI.card++;
        else brief_begin();                  /* beginGame -> map */
        break;
    case SCR_REPORT:
        UI.screen = SCR_MAP;
        break;
    case SCR_WOODCUT:
        wc_dismiss();
        break;
    case SCR_OPTIONS: {
        int r = rm_options_row_hit(UI.options_which, mx, my);
        if (r >= 0) {
            UI.options_row = (int8_t)r;
            rm_options_toggle(UI.options_which, r);
        } else if (r == -1)
            UI.screen = SCR_MAP;         /* off the box = leave */
        break;
    }
    case SCR_PEDIA: {
        if (UI.pedia_mode != 0) { UI.pedia_mode = 0; break; }
        int n = rm_pedia_count(UI.pedia_cat);
        int r = (my - 24) / 7;
        int i = (mx >= 160 ? 22 : 0) + r;
        if (r >= 0 && r < 22 && i < n) {
            UI.pedia_sel = (int16_t)i;
            UI.pedia_mode = 1;
        }
        break;
    }
    case SCR_VILLAGE: {
        /* tap an action row (the box geometry re-derived by the
         * painter's own helper) */
        int r = rm_village_row_hit(UI.village_row, mx, my);
        if (r >= 0) {
            UI.village_row = (int8_t)r;
            in_key_inner("Enter", 0, 0);
        } else if (r == -1) {
            in_key_inner("Escape", 0, 0);    /* off the box = leave */
        }
        break;
    }
    case SCR_COLONY: {
        /* order per the JS (onClick 'colony', game.js:12130): an open
         * popup, the scene panel's nine cells, the plaza row, dock
         * ships, view buttons, the build buttons, the numbers toggle,
         * the exit box */
        const ColonyRecord *c = 0;
        int cci = -1, ord = -1;
        for (int k = 0; k < CS.n_colonies; k++) {
            if ((CS.colonies[k].owner_power & 3) != cs_nation()) continue;
            if (++ord == UI.colony) { cci = k; break; }
        }
        if (cci >= 0) c = &CS.colonies[cci];
        if (UI.colony_popup) {
            /* a row commits; anything else DISMISSES and falls through
             * so the click is not wasted (game.js:12140) */
            static char plabels[64][40], pnotes[64][40], ptitle[64];
            const char *lp[64], *np[64];
            int pn = ui_colony_popup_model(plabels, pnotes, ptitle,
                                           (int)sizeof(ptitle), 64);
            for (int i = 0; i < pn; i++) { lp[i] = plabels[i];
                                           np[i] = pnotes[i]; }
            int r = rm_colony_popup_hit(ptitle, lp, np, pn,
                                        ui_colony_popup_small(), mx, my);
            if (r >= 0) {
                UI.colony_popup_row = (int8_t)r;
                if (UI.colony_popup == 2) build_picker_commit();
                else if (UI.colony_popup == 3) occupation_commit();
                else if (UI.colony_popup == 4) unit_options_commit();
                else if (UI.colony_popup == 5) ship_options_commit();
                else if (UI.colony_popup == 6) outside_commit();
                else jobs_popup_commit();
                return;
            }
            UI.colony_popup = 0;
        }
        /* the scene panel's nine cells (224,32,72,72 at 24px): a click
         * on a WORKING colonist selects him, a second opens his jobs
         * menu; an empty cell sends the SELECTED colonist out to it on
         * the field's best job (game.js:12146-12190) */
        if (c && hit(mx, my, 224, 32, 72, 72)) {
            int cx = (mx - 224) / 24 - 1, cy = (my - 32) / 24 - 1;
            if (!cx && !cy) return;               /* the centre works itself */
            int slot = -1;
            for (int q = 0; q < 8; q++)
                if (colony_cell_dx[q] == cx && colony_cell_dy[q] == cy)
                    slot = q;
            if (slot < 0) return;
            ColonyRecord *cw = &CS.colonies[cci];
            int tw = (uint8_t)cw->tiles[slot];      /* 0xFF = empty */
            int on = (tw != 0xFF && tw < cw->population) ? tw : -1;
            if (on >= 0) {
                if (UI.colonist_sel == on) {
                    UI.colony_popup = 3;      /* his OCCUPATION menu */
                    UI.colony_popup_row = 0;
                } else
                    UI.colonist_sel = (int8_t)on;
                return;
            }
            int k = UI.colonist_sel;
            if (k >= 0 && k < cw->population) {
                if (tile_water(map_at(cw->map_x + cx, cw->map_y + cy)) &&
                    !colony_has_name(cci, "Docks")) {
                    ev_emit("NODOCKS", 0, 0, cw->name, 0);   /* @NODOCKS */
                    return;
                }
                for (int q = 0; q < 8; q++)      /* leave his old cell */
                    if ((uint8_t)cw->tiles[q] == (uint8_t)k)
                        cw->tiles[q] = (int8_t)0xFF;
                cw->tiles[slot] = (int8_t)k;
                cw->occupation[k] = (uint8_t)best_field_job(cci, k, cx, cy);
            }
            return;
        }
        /* the plaza row (0,130,120,48): select, re-click = the jobs
         * menu.  Garrison units carry no menu (game.js:12193) */
        if (c && hit(mx, my, 0, 130, 120, 48)) {
            /* a GARRISON figure -- past the 4-px break -- is a unit, and
             * opens @UNITOPTIONS (game.js plazaUnitAt) */
            int gq = rm_plaza_unit_hit(cci, mx, my);
            if (gq >= 0) {
                UI.colony_popup = 4;
                UI.colony_popup_unit = (int8_t)gq;
                UI.colony_popup_row = 0;
                return;
            }
            int k = rm_plaza_hit(cci, mx, my);
            if (k >= 0) {
                if (UI.colonist_sel == k) {
                    UI.colony_popup = 1;
                    UI.colony_popup_row = 0;
                } else
                    UI.colonist_sel = (int8_t)k;
            }
            return;
        }
        /* building field: the crew figures under each shop are clickable
         * like the plaza row — a tap selects the man, a second tap opens
         * his JOBS menu (game.js buildingWorkerAt) */
        if (c && hit(mx, my, 0, 8, 199, 120)) {
            int bw = rm_building_worker_hit(cci, mx, my);
            if (bw >= 0) {
                if (UI.colonist_sel == bw) {
                    UI.colony_popup = 1;
                    UI.colony_popup_row = 0;
                } else
                    UI.colonist_sel = (int8_t)bw;
                return;
            }
            /* THE FENCE IS A HIT-RECT (C3.2, 2026-09-02): the Stockade
             * plot 13 of the buildings picture, (123, 98) in DS:0x266
             * drawn at y+8, category 3 -> w 73 h 18 (DS:0x230/0x236), so
             * (123,106,73,18); def 0 is written there even without a
             * Stockade (@0x025E64..@0x025E9F) and defs 0..2 map to job
             * 0x15 (DS:0x2CA).  A click there with a colonist selected
             * opens his OUTSIDE-jobs menu (func_029DD4 @0x02A07E..
             * @0x02A08A -> func_028D8C(1)); the board's tap is the
             * drop's equivalent (@0x029F7B..@0x029F98). */
            if (hit(mx, my, 123, 106, 73, 18) && UI.colonist_sel >= 0 &&
                UI.colonist_sel < c->population) {
                UI.colony_popup = 6;
                UI.colony_popup_row = 0;
                return;
            }
        }
        if (c) {
            int nships = 0, ship_q[8];
            for (int q = 0; q < CR.n_units_order; q++) {
                int u2 = CR.units_order[q];
                if (dat_units[CS.units[u2].type].hull > 0 &&
                    CS.units[u2].map_x == c->map_x &&
                    CS.units[u2].map_y == c->map_y) {
                    if (nships < 8) ship_q[nships] = q;
                    nships++;
                }
            }
            for (int k = 0; k < (nships < 4 ? nships : 4); k++)
                if (hit(mx, my, 130 + 18 * k, 147, 16, 16)) {
                    /* select, then the SAME box again for @SHIPOPTIONS —
                     * the select-then-menu rhythm the plaza row and the
                     * Europe harbour ship box both use */
                    if (UI.colony_ship_sel == k) {
                        UI.colony_popup = 5;
                        UI.colony_popup_unit = (int8_t)ship_q[k];
                        UI.colony_popup_row = 0;
                    } else
                        UI.colony_ship_sel = (int8_t)k;
                    return;
                }
        }
        for (int k = 0; k < 3; k++)
            if (hit(mx, my, 303, 132 + 15 * k, 15, 13)) {
                UI.colony_view = (int8_t)k;
                return;
            }
        /* BUILD_BTN (game.js:4130): buy (216,137,18,11) rush-buys,
         * change (270,137,29,11) opens the picker — build view only */
        if (UI.colony_view == 2) {
            if (hit(mx, my, 216, 137, 18, 11)) { rush_buy(); return; }
            if (hit(mx, my, 270, 137, 29, 11)) {
                open_build_picker();
                return;
            }
        }
        if (UI.colony_view == 0 && hit(mx, my, 207, 130, 95, 48)) {
            UI.colony_numbers = (int8_t)!UI.colony_numbers;
            return;
        }
        if (hit(mx, my, 305, 179, 15, 21)) UI.screen = SCR_MAP;
        break;
    }
    case SCR_EUROPE: {
        /* an open euro menu owns the pointer (onClick europe,
         * game.js:12519): a row click commits, anything else closes.
         * The row geometry here is the C dialog framework's, not the
         * JS euroMenuBox — FLAGGED divergence, scripts click only
         * far-outside points. */
        if (UI.euro_menu) {
            /* STATIC, not stack: in_click_inner sits at the top of the
             * whole command chain (menu row -> cmd_* -> advance ->
             * end_turn), so anything big here is charged against every
             * frame beneath it.  3 KB of row buffers put the build-colony
             * path over on the board — the second crash from stack DEPTH,
             * which -Wframe-larger-than cannot see (G1).  Single-threaded
             * UI scratch, so static costs nothing but BSS. */
            static char erows[24][64], enotes[24][64];
            static const char *erp[24];
            int en = ui_euro_menu_rows(erows, enotes, 24);
            for (int i = 0; i < en; i++) erp[i] = erows[i];
            rm_subs subs;
            memset(&subs, 0, sizeof(subs));
            int r = rm_dialog_rows_hit(ui_euro_menu_caption(), &subs, 0,
                                       mx, my, erp, en);
            if (r >= 0) {
                UI.euro_menu_row = (int8_t)r;
                euro_menu_commit_row();
            } else
                UI.euro_menu = 0;
            return;
        }
        if (hit(mx, my, 305, 179, 15, 21)) {
            UI.screen = SCR_MAP;
            return;
        }
        /* the recruit/purchase/train buttons (game.js:12538): the
         * @EUROLABEL boxes at (281, 89+11k, 37, 9) open the menus */
        for (int k = 0; k < 3; k++)
            if (hit(mx, my, 281, 89 + 11 * k, 37, 9)) {
                UI.euro_row = (int8_t)k;
                UI.euro_menu = (int8_t)(k + 1);
                UI.euro_menu_row = 0;
                return;
            }
        int nport = 0;
        for (int q = 0; q < CR.n_europe; q++)
            if (CR.europe[q].state == 0) nport++;
        for (int k = 0; k < (nport < 6 ? nport : 6); k++)
            if (hit(mx, my, 145 + 18 * k, 145, 18, 18)) {
                /* a re-click on the selected ship opens its
                 * @EUROPESHIPOPTIONS menu; a different ship selects */
                if (UI.euro_ship == k) {
                    UI.euro_menu = 4;
                    UI.euro_menu_row = 0;
                } else {
                    UI.euro_ship = (int8_t)k;
                }
                return;
            }
        for (int k = 0; k < (CR.n_dock_units < 6 ? CR.n_dock_units : 6); k++)
            if (hit(mx, my, 232 + 17 * k, 137, 18, 18)) {
                /* a dock unit's @ARMOPTIONS menu (game.js:12280) */
                UI.euro_dock_sel = (int8_t)k;
                UI.euro_menu = 5;
                UI.euro_menu_row = 0;
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
            int tp = 16 >> UI.zoom;          /* TILE_PX (game.js:757) */
            int tx = UI.view_x + (mx - 0) / tp;
            int ty = UI.view_y + (my - 8) / tp;
            /* a pending Go To takes this click (goToClick: the armed
             * unit walks toward the tile over as many turns as needed —
             * cmd_goto sets orders 3 + the goal the turn step walks) */
            if (UI.goto_arm) {
                UI.goto_arm = 0;
                int gu = sel_unit();
                if (gu >= 0) cmd_goto(gu, tx, ty);
                return;
            }
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
            /* The COLONY WINS over the unit stack (user report
             * 2026-08-17).  GAME_MANUAL.md p40 puts no "unoccupied"
             * condition on clicking a colony, and a colony square nearly
             * always holds units, so the old `&& !non` guard made the
             * colony screen almost unreachable by clicking.  A stack with
             * no colony still cycles.
             *
             * Landing this took three tries.  The first two diagnoses —
             * a "colony index mismatch" and a "build-picker row-model
             * ordering" problem — were both WRONG (the first was a stale
             * JS bundle, now guarded in tools/sim_trace.py; the row models
             * and dat_buildings == DATA.buildings were dumped and agree).
             * The third, a real `.bld` divergence at event 186, turned out
             * to be downstream of the three JS/C divergences the standing-
             * orders fix unmasked, and vanished when those were fixed. */
            if (ci >= 0) {
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
