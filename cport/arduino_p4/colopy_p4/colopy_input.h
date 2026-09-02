/* C-port Phase 8 — the input layer's UI state (the JS G view fields the
 * renderers draw and onKey/onClick mutate). */
#ifndef COLOPY_INPUT_H
#define COLOPY_INPUT_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

enum {
    SCR_TITLE = 0, SCR_DIFFICULTY, SCR_NATION, SCR_NAME, SCR_BRIEFING,
    SCR_HOF, SCR_MAP, SCR_REPORT, SCR_COLONY, SCR_EUROPE, SCR_WOODCUT,
    SCR_VILLAGE, SCR_KING, SCR_CARDS, SCR_PEDIA, SCR_OPTIONS, SCR_TRADE
};

typedef struct {
    uint8_t screen;
    int8_t  menu_row;                /* boot menu (G.menuRow) */
    int8_t  difficulty, nation;
    char    leader[24];
    int8_t  brief_page;
    char    report[4];               /* "F2".."F10" */
    int     view_x, view_y;          /* G.view */
    int     sel;                     /* units_order ordinal (G.sel) */
    int8_t  open_menu, menu_sel;     /* pulldown state */
    int8_t  view_mode;               /* G.viewMode */
    int8_t  zoom;                    /* G.zoom (§26.7, 0..3) */
    int8_t  colony, colony_view, colony_ship_sel;
    int8_t  market_sel, euro_row, euro_ship, euro_dock_sel;
    int8_t  euro_menu;               /* G.euroMenu: 0 none, 1 recruit,
                                      * 2 purchase, 3 train (4 ship /
                                      * 5 dockunit reserved for the
                                      * context-menu slice) */
    int8_t  euro_menu_row;           /* G.euroMenuRow */
    int8_t  show_hidden;             /* G.showHidden */
    int8_t  goto_arm;                /* Go to Place armed: next map click
                                      * is the destination (G.goTo) */
    int8_t  request;                 /* board-shell service request from a
                                      * menu row: 'S' save / 'L' load / 0.
                                      * The core never does I/O — the shell
                                      * reads, acts, and clears this. */
    int8_t  colony_numbers;          /* G.colonyNumbers ([0x336]) */
    int8_t  village_row;             /* G.villageRow */
    int8_t  woodcut;                 /* G.woodcut — the open plate */
    int8_t  card;                    /* G.card — the open LEVN card */
    uint32_t clock_ms;               /* the front's clock as of the last
                                      * in_tick (a harness scripts it) */
    uint32_t card_t0;                /* G.cardT0: the slideshow's
                                      * [0x90:0x92] stamp, in clock_ms */
    int8_t  pedia_cat;               /* G.pediaCat (7 = Complete) */
    int16_t pedia_sel;               /* G.pediaSel */
    int8_t  pedia_mode;              /* G.pediaMode: 0 index, 1 entry */
    int8_t  options_which;           /* 0 game / 1 colony / 2 sound */
    int8_t  options_row;
    int8_t  trade_mode;              /* G.trade.mode: 1 create / 2 assign
                                      * / 3 delete / 4 edit (0 = closed) */
    int8_t  trade_row;               /* G.trade.row */
    int8_t  trade_n_stops;           /* picked stops so far (create) */
    int16_t trade_stops[4];          /* player-colony ordinals / 999 */
    int8_t  trade_phase;             /* edit: 0 route / 1 stop / 2 load
                                      * lane / 3 unload lane (B3.4) */
    int8_t  trade_route;             /* edit: the picked route */
    int8_t  trade_stop;              /* edit: the picked stop index */
    int8_t  colony_popup;            /* G.colonyPopup: 0 none, 1 jobs,
                                      *                2 build */
    int8_t  colonist_sel;            /* G.colonistSel (game.js:566) */
    int8_t  dlg;                     /* G.dialog: 0 none, 1 = @HOWMUCH5
                                      * (Europe sell), 2 = @HOWMUCH1
                                      * (colony load), 3 = @HOWMUCH2
                                      * (colony unload) */
    char    dlg_entry[24];           /* d.entry (digits, cap 23) */
    int32_t dlg_max;                 /* the 0..N bound (max = have) */
    int8_t  dlg_good;                /* the good the amount applies to */
    int16_t dlg_port;                /* kind 1: CR.europe port index;
                                      * kinds 2/3: the colony record */
    int16_t dlg_unit;                /* kinds 2/3: the ship record */
    int8_t  colony_popup_row;
    int8_t  colony_popup_unit;   /* @UNITOPTIONS: units_order index */
} colopy_ui;

extern colopy_ui UI;

/* 0 under the parity harness; a LIVE front end (the Teensy loop) sets 1
 * to complete the flows the harness leaves at an inert dialog — today:
 * colony FOUNDING with the suggested name, and the ship menu's sail. */
extern int colopy_front_live;
extern uint32_t colopy_front_seed;   /* New Game seed (default 1653; a live
                                      * front end sets it from its clock —
                                      * the DOS engine reads the BIOS
                                      * clock at start) */

void ui_init(void);
/* the trade screen's row model (tradeRows, game.js:7835) — shared with
 * the board shells' painter/hit-test; returns the row count.  sofar =
 * the create mode's running stop summary (may be empty). */
int  ui_trade_rows(char out[][64], int cap);
void ui_trade_sofar(char *out, int cap);
/* the Europe sub-menu row model (euroMenuRows, game.js:4662) + the
 * GAME.TXT caption its box quotes — for the shells' painter */
int  ui_euro_menu_rows(char out[][64], char notes[][64], int cap);
const char *ui_euro_menu_caption(void);
/* the colony popups' display model (colonyPopupRows, game.js:3895):
 * labels + right-aligned notes + the @CTITLE title; small = build */
int  ui_colony_popup_model(char labels[][40], char notes[][40],
                           char *title, int tcap, int cap);
int  ui_colony_popup_small(void);
void in_key(const char *key, int alt, int shift);
void in_click(int mx, int my, int right);
/* the front's clock: the timed LEVN slideshow (sequencer func_004D1E,
 * one card per 0x23A ticks = 1873 ms) advances here.  Returns 1 when the
 * screen changed (a card advanced, or the game began) so the shell can
 * redraw. */
int  in_tick(uint32_t now_ms);

#ifdef __cplusplus
}
#endif
#endif /* COLOPY_INPUT_H */

int ui_build_rows_probe(int cci, const char **names);
const char *ui_build_target_probe(void);
