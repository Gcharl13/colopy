/*
 * ui.c — editor layout + renderer matching the original MAPEDIT (see ui.h).
 */
#include "ui.h"
#include "terrain.h"
#include "sprites.h"
#include "ff.h"

#include <stdio.h>
#include <string.h>

const int UI_ZOOM_TILES[4] = { 120, 60, 30, 15 };

/* Authentic game fonts (loaded from COLONIZE if available; else the built-in
 * 8x8 font is used). FONTINTR = menus/titles, FONTTINY = panel/status. */
static ff_font *g_menu_font;     /* FONTINTR.FF */
static ff_font *g_panel_font;    /* FONTTINY.FF */
#define MENU_FSCALE   1
#define PANEL_FSCALE  1

void ui_load_fonts(const char *colonize_dir)
{
    char path[1024];
    snprintf(path, sizeof path, "%s/FONTINTR.FF", colonize_dir);
    g_menu_font = ff_load(path);
    snprintf(path, sizeof path, "%s/FONTTINY.FF", colonize_dir);
    g_panel_font = ff_load(path);
}

/* Text helpers: use the game font when loaded, else the built-in 8x8 font. */
static int panel_text(fb *f, int x, int y, const char *s, uint32_t c)
{
    if (g_panel_font) return ff_draw(f, g_panel_font, x, y, s, c, PANEL_FSCALE);
    return fb_text(f, x, y, s, c, 1);
}
static int menu_text(fb *f, int x, int y, const char *s, uint32_t c)
{
    if (g_menu_font) return ff_draw(f, g_menu_font, x, y, s, c, MENU_FSCALE);
    return fb_text(f, x, y, s, c, 1);
}
static int menu_text_w(const char *s)
{
    if (g_menu_font) return ff_text_width(g_menu_font, s) * MENU_FSCALE;
    return fb_text_w(s, 1);
}

/* ---- menu model (matches MAPMENU.TXT @GAME/@VIEW/@CUP/@HELP) ---- */
static const char *MENU_TITLES[UI_MENU_COUNT] = { "Editor", "View", "Map", "Help" };

static const char *MENU_EDITOR[] = {
    "Save Map", "Save Map As", "Load Map", "Create Map", "Exit to DOS"
};
static const char *MENU_VIEW[] = {
    "Zoom In   Z", "Zoom Out   X", "Zoom Level 120 x 96", "Zoom Level 60 x 48",
    "Zoom Level 30 x 24", "Zoom Level 15 x 12", "Center View"
};
static const char *MENU_MAP[] = {
    "Map Tile Select", "Fill Mode Change", "Toggle Coastline Protect",
    "Find Continents", "Undo Last Change", "Memory check"
};
static const char *MENU_HELP[] = {
    "General Information", "Mouse Commands", "Keyboard Commands",
    "Special Functions", "How To Use Maps", "About Map Editor"
};
static const char **MENU_ITEMS[UI_MENU_COUNT] = { MENU_EDITOR, MENU_VIEW, MENU_MAP, MENU_HELP };
static const int    MENU_LEN[UI_MENU_COUNT]   = { 5, 7, 6, 6 };

const char *ui_menu_title(int m)      { return (m >= 0 && m < 4) ? MENU_TITLES[m] : ""; }
int         ui_menu_item_count(int m) { return (m >= 0 && m < 4) ? MENU_LEN[m] : 0; }
const char *ui_menu_item(int m, int i)
{
    if (m < 0 || m >= 4 || i < 0 || i >= MENU_LEN[m]) return "";
    return MENU_ITEMS[m][i];
}

/* ---- colours sampled from the original ---- */
#define C_GOLD        RGB(0xF0,0xC8,0x40)
#define C_GOLD_HOT    RGB(0xFF,0xF0,0x90)
#define C_GREEN       RGB(0x4C,0xCC,0x4C)
#define C_GREEN_DIM   RGB(0x38,0x9C,0x38)
#define C_WHITE       RGB(0xF4,0xF4,0xF4)
#define C_CURSOR      RGB(0xFF,0xFF,0xFF)
#define C_MAP_VOID    RGB(0x10,0x28,0x50)
#define C_GRID        RGB(0x00,0x00,0x00)
#define C_MM_BORDER   RGB(0xC8,0x84,0x30)
#define C_MM_FOREST   RGB(0x1C,0x6D,0x10)   /* minimap forest (dark green) */
#define C_MM_HILL     RGB(0x9C,0x84,0x5C)   /* minimap hills  (tan-brown)  */
#define C_MM_MTN      RGB(0xB4,0xA8,0x9C)   /* minimap mtns   (grey)       */
#define C_DROP_FG     RGB(0xF0,0xE0,0xB0)

static int clampb(int v) { return v < 0 ? 0 : v > 255 ? 255 : v; }

/* Procedural wood-grain fill (stand-in for WOODTILE.SS when assets absent). */
static void draw_wood(fb *f, int x0, int y0, int w, int h)
{
    for (int y = 0; y < h; y++) {
        unsigned hsh = (unsigned)((y0 + y) * 2246822519u) ^ 0x9E3779B9u;
        int v = (int)((hsh >> 16) & 0x0F) - 8;
        uint32_t base = RGB(clampb(0x6E + v), clampb(0x40 + v / 2), clampb(0x1E + v / 3));
        fb_hline(f, x0, y0 + y, w, base);
        if (((hsh >> 20) & 7) == 0) fb_hline(f, x0, y0 + y, w, RGB(0x4A,0x2A,0x14));
        if (((hsh >> 23) & 7) == 0) fb_hline(f, x0, y0 + y, w, RGB(0x86,0x56,0x2C));
    }
}

/* ---- menu-bar geometry: Editor/View/Map left, Help right-aligned ---- */
static void menu_rect(int m, int *x, int *w)
{
    int tw = menu_text_w(MENU_TITLES[m]);
    if (m == 3) {                       /* Help, right-aligned */
        *x = UI_WIN_W - tw - 4;
        *w = tw + 4;
        return;
    }
    int cx = 6;
    for (int i = 0; i < m; i++)
        cx += menu_text_w(MENU_TITLES[i]) + 12;
    *x = cx;
    *w = tw + 6;
}

void ui_view_init(ui_view *v)
{
    v->zoom = 3;          /* F4 closest (native 16px, 15x12) — like the original */
    v->scroll_x = v->scroll_y = 0;
    v->menu_open = -1;
    v->tile_select_open = 0;
    v->hover_x = v->hover_y = -1;
}

int ui_tile_px(const ui_view *v)
{
    /* Native tile pixels per zoom = 240px viewport / {120,60,30,15} tiles =
     * {2,4,8,16}. zoom 3 = native 16px (F4, closest); zoom 0 = 2px (F1). All
     * integer ratios of the 16px sprite, so blits stay crisp. */
    static const int TPX[4] = { 2, 4, 8, 16 };
    return TPX[v->zoom & 3];
}

void ui_clamp_scroll(ui_view *v, const editor *e)
{
    int tp = ui_tile_px(v);
    int vis_x = UI_MAP_W / tp, vis_y = UI_MAP_H / tp;
    int maxx = e->map->width  - vis_x;
    int maxy = e->map->height - vis_y;
    if (maxx < 0) maxx = 0;
    if (maxy < 0) maxy = 0;
    if (v->scroll_x > maxx) v->scroll_x = maxx;
    if (v->scroll_y > maxy) v->scroll_y = maxy;
    if (v->scroll_x < 0) v->scroll_x = 0;
    if (v->scroll_y < 0) v->scroll_y = 0;
}

void ui_center_on(ui_view *v, const editor *e, int tx, int ty)
{
    int tp = ui_tile_px(v);
    v->scroll_x = tx - (UI_MAP_W / tp) / 2;
    v->scroll_y = ty - (UI_MAP_H / tp) / 2;
    ui_clamp_scroll(v, (editor *)e);
}

/* ---- mini-map geometry ----
 * The original minimap shows only the playable area, cropping the sea-lane
 * border columns (x==0 and x==width-1). cx0/cy0 = crop origin, cw/ch = cropped
 * tile span. */
#define MM_CROP_COLS 1   /* sea-lane border columns trimmed from each side */

static void minimap_crop(const editor *e, int *cx0, int *cy0, int *cw, int *ch)
{
    int W = e->map->width, H = e->map->height;
    *cx0 = (W > 2 * MM_CROP_COLS) ? MM_CROP_COLS : 0;
    *cy0 = 0;
    *cw  = W - 2 * (*cx0);
    *ch  = H - 2 * (*cy0);
}

static void minimap_geom(const editor *e, int *mmx, int *mmy, int *cell, int *mmw, int *mmh)
{
    int cx0, cy0, cw, ch;
    minimap_crop(e, &cx0, &cy0, &cw, &ch);
    int sw = (UI_PANEL_W - 6) / cw;     /* fit the panel width */
    int sh = 80 / ch;                    /* cap height so status fits below */
    int c = sw < sh ? sw : sh;
    if (c < 1) c = 1;
    *cell = c;
    *mmw = cw * c;
    *mmh = ch * c;
    *mmx = UI_PANEL_X + (UI_PANEL_W - *mmw) / 2;
    *mmy = UI_MENU_H + 3;
}

/* ---- map viewport: neighbour-aware tiles with real coast sprites ---- */
static void render_map(fb *f, const editor *e, const ui_view *v)
{
    fb_fill_rect(f, UI_MAP_X, UI_MAP_Y, UI_MAP_W, UI_MAP_H, C_MAP_VOID);
    int tp = ui_tile_px(v);
    const mp_map *m = e->map;

    for (int sy = 0; sy * tp < UI_MAP_H; sy++) {
        int ty = v->scroll_y + sy;
        if (ty >= m->height) break;
        for (int sx = 0; sx * tp < UI_MAP_W; sx++) {
            int tx = v->scroll_x + sx;
            if (tx >= m->width) break;
            int px = UI_MAP_X + sx * tp, py = UI_MAP_Y + sy * tp;
            /* neighbour-aware: base ground + real coast beach + overlays */
            sprite_draw_map_tile(f, px, py, tp, m, tx, ty);
        }
    }

    if (e->cursor_x >= v->scroll_x && e->cursor_y >= v->scroll_y) {
        int cx = UI_MAP_X + (e->cursor_x - v->scroll_x) * tp;
        int cy = UI_MAP_Y + (e->cursor_y - v->scroll_y) * tp;
        if (cx < UI_MAP_X + UI_MAP_W && cy < UI_MAP_Y + UI_MAP_H) {
            fb_rect(f, cx, cy, tp, tp, C_CURSOR);
            fb_rect(f, cx - 1, cy - 1, tp + 2, tp + 2, C_CURSOR);
        }
    }
}

/* ---- right panel: mini-map + green status text ---- */
static void render_panel(fb *f, const editor *e, const ui_view *v)
{
    draw_wood(f, UI_PANEL_X, UI_PANEL_Y, UI_PANEL_W, UI_MAP_H);
    fb_vline(f, UI_PANEL_X, UI_PANEL_Y, UI_MAP_H, RGB(0x2A,0x18,0x0C));

    /* mini-map (cropped to the playable area) */
    int mmx, mmy, cell, mmw, mmh, cx0, cy0, cw, ch;
    minimap_geom(e, &mmx, &mmy, &cell, &mmw, &mmh);
    minimap_crop(e, &cx0, &cy0, &cw, &ch);
    const mp_map *m = e->map;
    for (int y = 0; y < ch; y++)
        for (int x = 0; x < cw; x++) {
            /* per the original minimap (func_066BB0 / NAMES @COLORS roles): colour
             * by CATEGORY — water, then mtn/hill (bit 0x20), then forest (ids
             * 8..23), then base land — so elevation and forest read on the map. */
            uint8_t b  = m->terrain[mp_idx(m, cx0 + x, cy0 + y)];
            uint8_t id = MP_TERRAIN_ID(b);
            uint32_t c;
            if (id == 25 || id == 26)        c = terrain_color(id);           /* water */
            else if (b & 0x20)               c = (b & 0x80) ? C_MM_MTN
                                                            : C_MM_HILL;       /* mtn/hill */
            else if (id >= 8 && id < 24)     c = C_MM_FOREST;                  /* forest */
            else                             c = terrain_color(id);           /* land */
            fb_fill_rect(f, mmx + x * cell, mmy + y * cell, cell, cell, c);
        }
    fb_rect(f, mmx - 2, mmy - 2, mmw + 4, mmh + 4, C_MM_BORDER);
    fb_rect(f, mmx - 1, mmy - 1, mmw + 2, mmh + 2, C_MM_BORDER);

    /* viewport rectangle on the mini-map (in cropped coordinates) */
    int tp = ui_tile_px(v);
    int visx = UI_MAP_W / tp, visy = UI_MAP_H / tp;
    int bx = mmx + (v->scroll_x - cx0) * cell;
    int by = mmy + (v->scroll_y - cy0) * cell;
    fb_rect(f, bx, by, visx * cell, visy * cell, C_WHITE);

    /* status text — native FONTTINY scale (6px), tight line spacing */
    int tx = UI_PANEL_X + 3;
    int y = mmy + mmh + 6;
    char line[80];
    const terrain_info *sel = terrain_by_id(e->selected_id);
    char desc[48];
    uint8_t cur = e->map->terrain[mp_idx(e->map, e->cursor_x, e->cursor_y)];
    terrain_describe(cur, desc, sizeof desc);

    snprintf(line, sizeof line, "Size: (%d, %d)", e->map->width, e->map->height);
    panel_text(f, tx, y, line, C_GREEN); y += 8;
    snprintf(line, sizeof line, "Curs: (%d, %d)", e->cursor_x, e->cursor_y);
    panel_text(f, tx, y, line, C_GREEN); y += 12;

    panel_text(f, tx, y, "Terrain at cursor:", C_GREEN); y += 8;
    snprintf(line, sizeof line, "(%s)", desc);
    panel_text(f, tx, y, line, C_GREEN); y += 12;

    panel_text(f, tx, y, "Selected:", C_GREEN); y += 8;
    sprite_draw_tile(f, tx, y, 16, e->selected_id);   /* real terrain sprite */
    fb_rect(f, tx, y, 16, 16, RGB(0x20,0x10,0x08));
    y += 18;
    snprintf(line, sizeof line, "(%s)", sel ? sel->name : "?");
    panel_text(f, tx, y, line, C_GREEN); y += 12;

    panel_text(f, tx, y, "Shift-Left:  Paint", C_GREEN); y += 8;
    panel_text(f, tx, y, "Shift-Right: Pick up", C_GREEN); y += 12;

    snprintf(line, sizeof line, "Fill radius: %d", e->fill_radius);
    panel_text(f, tx, y, line, C_GREEN); y += 8;
    snprintf(line, sizeof line, "Coast Protect: %s", e->coast_protect ? "ON" : "OFF");
    panel_text(f, tx, y, line, C_GREEN);
}

/* ---- menu bar + dropdowns ---- */
static void render_menubar(fb *f, const ui_view *v)
{
    draw_wood(f, 0, 0, UI_WIN_W, UI_MENU_H);
    fb_hline(f, 0, UI_MENU_H - 1, UI_WIN_W, RGB(0x2A,0x18,0x0C));

    for (int m = 0; m < UI_MENU_COUNT; m++) {
        int x, w;
        menu_rect(m, &x, &w);
        menu_text(f, x, 0, MENU_TITLES[m], C_GOLD);
        char acc[2] = { MENU_TITLES[m][0], 0 };
        menu_text(f, x, 0, acc, C_GOLD_HOT);   /* brighter accelerator letter */
    }

    if (v->menu_open >= 0) {
        int m = v->menu_open, n = MENU_LEN[m];
        int mx, mw;
        menu_rect(m, &mx, &mw);
        int x = mx - 2, y = UI_MENU_H;
        int w = 8;
        for (int i = 0; i < n; i++) {
            int iw = menu_text_w(MENU_ITEMS[m][i]) + 6;
            if (iw > w) w = iw;
        }
        if (x + w > UI_WIN_W) x = UI_WIN_W - w;
        if (x < 0) x = 0;
        draw_wood(f, x, y, w, n * 10 + 3);
        fb_rect(f, x, y, w, n * 10 + 3, RGB(0xC8,0x84,0x30));
        for (int i = 0; i < n; i++)
            menu_text(f, x + 3, y + 2 + i * 10, MENU_ITEMS[m][i], C_DROP_FG);
    }
}

/* ---- "Map Tile Select" popup ---- */
static void tile_select_geom(int *x, int *y, int *w, int *h)
{
    *w = 300; *h = 150;
    *x = (UI_WIN_W - *w) / 2;
    *y = UI_MENU_H + (UI_MAP_H - *h) / 2;
}

static const char *GROUP_NAME[] = { "UNFORESTED", "FORESTED", "OTHER" };

/* row rectangle of palette entry i within the popup (native scale) */
static void ts_entry_rect(int px, int py, int i, int *x, int *y)
{
    int col = i / 8;                  /* 0:unf 1:for 2:other -> three columns */
    int row = i % 8;
    *x = px + 8 + col * 96;
    *y = py + 30 + row * 14;          /* leaves room for group headers above */
}

static void render_tile_select(fb *f, const editor *e)
{
    int px, py, pw, ph;
    tile_select_geom(&px, &py, &pw, &ph);
    draw_wood(f, px, py, pw, ph);
    fb_rect(f, px, py, pw, ph, RGB(0xC8,0x84,0x30));
    fb_rect(f, px + 1, py + 1, pw - 2, ph - 2, RGB(0xC8,0x84,0x30));
    menu_text(f, px + 6, py + 3, "Map Tile Select", C_GOLD_HOT);

    int count = 0;
    const terrain_info *pal = terrain_palette(&count);
    for (int g = 0; g < 3; g++)
        panel_text(f, px + 8 + g * 96, py + 18, GROUP_NAME[g], C_GOLD);

    for (int i = 0; i < count; i++) {
        int x, y;
        ts_entry_rect(px, py, i, &x, &y);
        sprite_draw_tile(f, x, y, 12, pal[i].id);   /* real terrain sprite */
        fb_rect(f, x, y, 12, 12, RGB(0x20,0x10,0x08));
        uint32_t fg = (pal[i].id == e->selected_id) ? C_GOLD_HOT : C_DROP_FG;
        if (pal[i].id == e->selected_id)
            fb_rect(f, x - 1, y - 1, 14, 14, C_GOLD_HOT);
        panel_text(f, x + 15, y + 3, pal[i].name, fg);
    }
    panel_text(f, px + 6, py + ph - 9, "click a tile  (Esc to close)", C_GREEN_DIM);
}

void ui_render(fb *f, const editor *e, const ui_view *v)
{
    fb_clear(f, C_MAP_VOID);
    render_map(f, e, v);
    render_panel(f, e, v);
    render_menubar(f, v);
    if (v->tile_select_open)
        render_tile_select(f, e);
}

/* ---------------- hit testing ---------------- */
int ui_hit_menu(int mx, int my)
{
    if (my < 0 || my >= UI_MENU_H)
        return -1;
    for (int m = 0; m < UI_MENU_COUNT; m++) {
        int x, w;
        menu_rect(m, &x, &w);
        if (mx >= x - 4 && mx < x + w)
            return m;
    }
    return -1;
}

int ui_hit_menu_item(const ui_view *v, int mx, int my)
{
    if (v->menu_open < 0)
        return -1;
    int m = v->menu_open, n = MENU_LEN[m];
    int mx0, mw;
    menu_rect(m, &mx0, &mw);
    int x = mx0 - 2, y = UI_MENU_H, w = 8;
    for (int i = 0; i < n; i++) {
        int iw = menu_text_w(MENU_ITEMS[m][i]) + 6;
        if (iw > w) w = iw;
    }
    if (x + w > UI_WIN_W) x = UI_WIN_W - w;
    if (x < 0) x = 0;
    if (mx < x || mx >= x + w || my < y + 2 || my >= y + 2 + n * 10)
        return -1;
    int item = (my - y - 2) / 10;
    return (item >= 0 && item < n) ? item : -1;
}

int ui_hit_minimap(const ui_view *v, const editor *e, int mx, int my, int *tx, int *ty)
{
    (void)v;
    int mmx, mmy, cell, mmw, mmh, cx0, cy0, cw, ch;
    minimap_geom(e, &mmx, &mmy, &cell, &mmw, &mmh);
    minimap_crop(e, &cx0, &cy0, &cw, &ch);
    if (mx < mmx || mx >= mmx + mmw || my < mmy || my >= mmy + mmh)
        return 0;
    *tx = cx0 + (mx - mmx) / cell;   /* cropped -> map coords */
    *ty = cy0 + (my - mmy) / cell;
    return 1;
}

int ui_hit_map(const ui_view *v, const editor *e, int mx, int my, int *tx, int *ty)
{
    if (mx < UI_MAP_X || mx >= UI_MAP_X + UI_MAP_W ||
        my < UI_MAP_Y || my >= UI_MAP_Y + UI_MAP_H)
        return 0;
    int tp = ui_tile_px(v);
    int x = v->scroll_x + (mx - UI_MAP_X) / tp;
    int y = v->scroll_y + (my - UI_MAP_Y) / tp;
    if (!mp_in_bounds(e->map, x, y))
        return 0;
    *tx = x; *ty = y;
    return 1;
}

int ui_hit_tile_select(const ui_view *v, int mx, int my)
{
    if (!v->tile_select_open)
        return -1;
    int px, py, pw, ph;
    tile_select_geom(&px, &py, &pw, &ph);
    if (mx < px || mx >= px + pw || my < py || my >= py + ph)
        return -2;          /* outside -> close */
    int count = 0;
    const terrain_info *pal = terrain_palette(&count);
    for (int i = 0; i < count; i++) {
        int x, y;
        ts_entry_rect(px, py, i, &x, &y);
        if (mx >= x - 1 && mx < x + 92 && my >= y - 1 && my < y + 13)
            return pal[i].id;
    }
    return -1;
}
