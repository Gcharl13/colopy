/*
 * ui.h — editor screen layout + renderer, matching the original MAPEDIT.
 *
 * Real MAPEDIT layout (from the DOS original):
 *   +--------------------------------------------------------------+
 *   | Editor   View   Map                                  Help    |  wood menu bar,
 *   +-----------------------------------------------+--------------+  gold text, Help
 *   |                                               |  [mini-map]  |  right-aligned
 *   |                                               |              |
 *   |              map viewport                      | Size:(w,h)  |  wood right panel,
 *   |        (PHYS0 sprites or colored)              | Curs:(x,y)  |  green status text
 *   |            [white cursor box]                  |             |
 *   |                                               | Terrain at  |
 *   |                                               | cursor:     |
 *   |                                               | (Hills)     |
 *   |                                               | Selected:   |
 *   |                                               | [swatch]    |
 *   |                                               | (Ocean)     |
 *   |                                               | Shift-Left: |
 *   |                                               |  Paint      |
 *   |                                               | Shift-Right:|
 *   |                                               |  Pick up    |
 *   |                                               | Fill radius:|
 *   |                                               | Coast Prot: |
 *   +-----------------------------------------------+--------------+
 *
 * There is NO bottom status bar; all status lives in the wood right panel
 * under the mini-map. The terrain palette is a separate "Map Tile Select"
 * popup (Map menu), not an always-visible list.
 */
#ifndef MPEDIT_UI_H
#define MPEDIT_UI_H

#include "framebuffer.h"
#include "editor.h"

/* Native VGA editor resolution (the original is 320x200). The renderer draws
 * into this size; shot/gui scale it up by an integer factor for display, so the
 * proportions match the original exactly. */
#define UI_WIN_W      320
#define UI_WIN_H      200
#define UI_MENU_H     8
#define UI_PANEL_W    80
#define UI_SCALE      3       /* default display upscale (320x200 -> 960x600) */

/* Map viewport rectangle. */
#define UI_MAP_X      0
#define UI_MAP_Y      UI_MENU_H
#define UI_MAP_W      (UI_WIN_W - UI_PANEL_W)
#define UI_MAP_H      (UI_WIN_H - UI_MENU_H)

/* Right panel rectangle. */
#define UI_PANEL_X    (UI_WIN_W - UI_PANEL_W)
#define UI_PANEL_Y    UI_MENU_H

/* Zoom levels = tiles visible across the viewport (View menu F1..F4). */
extern const int UI_ZOOM_TILES[4];   /* {120, 60, 30, 15} */

typedef struct {
    int zoom;             /* index 0..3 into UI_ZOOM_TILES         */
    int scroll_x;         /* leftmost map tile shown               */
    int scroll_y;         /* topmost  map tile shown               */
    int menu_open;        /* open dropdown: -1 none, else 0..3     */
    int tile_select_open; /* "Map Tile Select" popup visible       */
    int hover_x, hover_y; /* last hovered tile (-1 if outside map) */
} ui_view;

/* Load the authentic game fonts (FONTINTR/FONTTINY) from a COLONIZE dir.
 * Optional — without it the built-in 8x8 font is used. */
void ui_load_fonts(const char *colonize_dir);

void ui_view_init(ui_view *v);
int  ui_tile_px(const ui_view *v);          /* pixels per tile at current zoom */
void ui_center_on(ui_view *v, const editor *e, int tx, int ty);
void ui_clamp_scroll(ui_view *v, const editor *e);

/* Render the whole editor screen into f. */
void ui_render(fb *f, const editor *e, const ui_view *v);

/* Hit-testing for the input layer. */
int ui_hit_menu(int mx, int my);                 /* top menu index 0..3 or -1 */
int ui_hit_menu_item(const ui_view *v, int mx, int my);
int ui_hit_minimap(const ui_view *v, const editor *e, int mx, int my, int *tx, int *ty);
int ui_hit_map(const ui_view *v, const editor *e, int mx, int my, int *tx, int *ty);
/* Tile-select popup: returns terrain id, -1 (no hit / inside but empty),
 * or -2 (clicked outside the popup -> close). Only meaningful when open. */
int ui_hit_tile_select(const ui_view *v, int mx, int my);

/* Menu model (also used by the SDL command dispatch). */
#define UI_MENU_COUNT 4
const char *ui_menu_title(int menu);
int         ui_menu_item_count(int menu);
const char *ui_menu_item(int menu, int item);

#endif /* MPEDIT_UI_H */
