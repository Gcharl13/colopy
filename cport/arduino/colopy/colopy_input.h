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
    SCR_VILLAGE
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
    int8_t  colony, colony_view, colony_ship_sel;
    int8_t  market_sel, euro_row, euro_ship, euro_dock_sel;
    int8_t  euro_menu;               /* G.euroMenu: 0 none, 1 recruit,
                                      * 2 purchase, 3 train (4 ship /
                                      * 5 dockunit reserved for the
                                      * context-menu slice) */
    int8_t  euro_menu_row;           /* G.euroMenuRow */
    int8_t  show_hidden;             /* G.showHidden */
    int8_t  colony_numbers;          /* G.colonyNumbers ([0x336]) */
    int8_t  village_row;             /* G.villageRow */
    int8_t  colony_popup;            /* G.colonyPopup: 0 none, 1 jobs,
                                      *                2 build */
    int8_t  colonist_sel;            /* G.colonistSel (game.js:566) */
    int8_t  dlg;                     /* G.dialog: 0 none, 1 = @HOWMUCH5
                                      * (the numeric sell-amount modal) */
    char    dlg_entry[24];           /* d.entry (digits, cap 23) */
    int32_t dlg_max;                 /* the 0..N bound (max = have) */
    int8_t  dlg_good;                /* HOWMUCH5: the good being sold */
    int16_t dlg_port;                /* HOWMUCH5: CR.europe port index */
    int8_t  colony_popup_row;
} colopy_ui;

extern colopy_ui UI;

void ui_init(void);
void in_key(const char *key, int alt, int shift);
void in_click(int mx, int my, int right);

#ifdef __cplusplus
}
#endif
#endif /* COLOPY_INPUT_H */
