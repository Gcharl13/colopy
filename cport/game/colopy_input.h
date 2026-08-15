/* C-port Phase 8 — the input layer's UI state (the JS G view fields the
 * renderers draw and onKey/onClick mutate). */
#ifndef COLOPY_INPUT_H
#define COLOPY_INPUT_H

#include <stdint.h>

enum {
    SCR_TITLE = 0, SCR_DIFFICULTY, SCR_NATION, SCR_NAME, SCR_BRIEFING,
    SCR_HOF, SCR_MAP, SCR_REPORT, SCR_COLONY, SCR_EUROPE, SCR_WOODCUT
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
    int8_t  colony, colony_view;
    int8_t  market_sel, euro_row, euro_ship, euro_dock_sel;
    int8_t  show_hidden;             /* G.showHidden */
} colopy_ui;

extern colopy_ui UI;

void ui_init(void);
void in_key(const char *key, int alt, int shift);

#endif /* COLOPY_INPUT_H */
