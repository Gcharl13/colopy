/* ============================================================================
 * main_modern.c -- modern-host entry point + title-screen shell (milestone 3)
 * ----------------------------------------------------------------------------
 * Replaces the DOS pair boot/entry.c + runtime/cstart.c.  Boots the DGROUP
 * memory layer, loads the game's own data files (NAMES.TXT tables at their
 * byte-verified addresses; .PIK backdrops; .FF fonts; the @BEGINMENU menu
 * section from GAME.TXT), and runs the title flow over the Mode-13h video
 * layer (platform.h).
 *
 * Honesty note (reconstruction layer vs byte-verified rules): the original's
 * data-driven menu runner (0x181F:0x3FE) IS ported (src/ui/menu_runner.c,
 * ROUTE_B_PLAN 3.1) and the title flow runs through it -- @BEGINMENU's
 * directives/option rows, the option highlight, the key loop and the
 * 1-based/-1 return contract are the original's (byte cites in menu_runner.c).
 * The local draw_title_menu/load_beginmenu below remain only for the headless
 * screenshot path.  Every byte of pixel/palette/font/string content comes
 * from the user's own game files (copyright constraint).
 *
 * Keys: Up/Down+Enter or 1..5 | ESC back/quit | F12 screenshot
 * Env : VICEROY_DATA = game data dir (default ./game_data)
 * ============================================================================ */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "viceroy_types.h"
#include "dgroup.h"
#include "ui_screen.h"
#include "platform.h"

extern void dgroup_init(void);
extern int  viceroy_load_names(const char *dir);
extern int  viceroy_load_labels(const char *dir);
extern const char *viceroy_str(uint16_t handle);
extern void title_screen_render(void);
extern int  title_screen_update(void);

static const char *g_data = "game_data";
const char *viceroy_data_dir(void) { return g_data; }
static int g_interactive;
int viceroy_interactive(void) { return g_interactive; }
static ff_font_t   g_font;
static int         g_have_font;
ff_font_t *viceroy_font(void) { return g_have_font ? &g_font : 0; }

/* ---- @BEGINMENU (GAME.TXT) ------------------------------------------------ */
#define MENU_MAX 8
static char g_menu_prompt[96];
static char g_menu_opt[MENU_MAX][64];
static int  g_menu_count, g_menu_width = 160, g_menu_y = 91;

static int load_beginmenu(void)
{
    char path[512], line[256];
    snprintf(path, sizeof path, "%s/GAME.TXT", g_data);
    FILE *f = fopen(path, "r");
    if (!f) return -1;

    int in = 0, opts = 0;
    g_menu_count = 0;
    while (fgets(line, sizeof line, f)) {
        char *p = line + strspn(line, " \t");
        size_t len = strcspn(p, "\r\n"); p[len] = 0;
        if (!in) {
            if (!strcmp(p, "@BEGINMENU")) in = 1;
            continue;
        }
        if (p[0] == '@') {
            if      (!strncmp(p, "@width=", 7)) g_menu_width = atoi(p + 7);
            else if (!strncmp(p, "@y=", 3))     g_menu_y = atoi(p + 3);
            else if (!strcmp(p, "@options"))    opts = 1;
            else if (!strcmp(p, "@smallfont")) {/* font selector */}
            else if (!strncmp(p, "@default=", 9)) {/* runner consumes (menu_runner.c) */}
            else break;                          /* next section */
            continue;
        }
        if (!p[0]) { if (opts && g_menu_count) break; continue; }
        if (!opts) {
            strncpy(g_menu_prompt, p, sizeof g_menu_prompt - 1);
        } else if (g_menu_count < MENU_MAX) {
            strncpy(g_menu_opt[g_menu_count], p, sizeof g_menu_opt[0] - 1);
            g_menu_count++;
        }
    }
    fclose(f);
    return g_menu_count ? 0 : -1;
}

/* ---- drawing helpers ------------------------------------------------------ */
static pik_image_t g_bg;            /* current backdrop, kept for redraws */
static int         g_have_bg;

static void pal_pick_text_colors(uint8_t *dark, uint8_t *light)
{
    /* RECONSTRUCTED: choose darkest/lightest palette entries for text --
     * the original's color indices for the menu rows are not yet traced */
    int dmin = 1 << 20, dmax = -1;
    for (int i = 0; i < 256; i++) {
        int v = g_bg.pal[i*3] + g_bg.pal[i*3+1] + g_bg.pal[i*3+2];
        if (v < dmin) { dmin = v; *dark = (uint8_t)i; }
        if (v > dmax) { dmax = v; *light = (uint8_t)i; }
    }
}

static int load_bg(const char *name)
{
    char path[512];
    snprintf(path, sizeof path, "%s/%s", g_data, name);
    if (g_have_bg) { pik_free(&g_bg); g_have_bg = 0; }
    if (pik_load(path, &g_bg) != 0) {
        fprintf(stderr, "shell: cannot load %s\n", path);
        return -1;
    }
    g_have_bg = 1;
    if (g_bg.has_pal) vid_set_palette(g_bg.pal);
    return 0;
}

static void draw_bg(void)
{
    if (!g_have_bg) return;
    uint8_t *fb = vid_framebuffer();
    int w = g_bg.w < VID_W ? g_bg.w : VID_W;
    int h = g_bg.h < VID_H ? g_bg.h : VID_H;
    for (int y = 0; y < h; y++)
        memcpy(fb + y * VID_W, g_bg.pixels + y * g_bg.w, w);
}

static void draw_text_center(const char *s, int y, uint8_t color)
{
    if (!g_have_font) return;
    g_font.colors[1] = g_font.colors[2] = g_font.colors[3] = color;
    int w = ff_text_width(&g_font, s, 1);
    ff_draw(&g_font, s, (VID_W - w) / 2, y, 1);
}

static void draw_title_menu(int sel)
{
    draw_bg();
    if (!g_have_font) { vid_present(); return; }

    uint8_t dark = 0, light = 15;
    pal_pick_text_colors(&dark, &light);

    int row_h = g_font.maxh + 2;
    for (int i = 0; i < g_menu_count; i++) {
        const char *s = g_menu_opt[i];
        g_font.colors[1] = g_font.colors[2] = g_font.colors[3] =
            (i == sel) ? light : dark;
        int w = ff_text_width(&g_font, s, 1);
        int x = (VID_W - w) / 2;                 /* centered in the plate */
        ff_draw(&g_font, s, x, g_menu_y + i * row_h, 1);
    }
    vid_present();
}

static void draw_nations(void)
{
    draw_bg();
    if (g_have_font) {
        uint8_t dark = 0, light = 15;
        pal_pick_text_colors(&dark, &light);
        /* the four COUNTRY names exactly as NAMES.TXT loaded them into
         * DGROUP:0x8D42 (word-ptr table; see data_load.c) */
        for (int i = 0; i < 4; i++) {
            char buf[80];
            snprintf(buf, sizeof buf, "%d  %s", i + 1, &DG8(DG16(0x8D42 + i*2)));
            g_font.colors[1] = g_font.colors[2] = g_font.colors[3] = light;
            ff_draw(&g_font, buf, 18, 24 + i * 44, 1);
        }
        draw_text_center("Select a European Power (1-4)", 184, light);
    }
    vid_present();
}

static void draw_difficulty(void)
{
    draw_bg();
    if (g_have_font) {
        uint8_t dark = 0, light = 15;
        pal_pick_text_colors(&dark, &light);
        draw_text_center("Choose Difficulty Level (1-5)", 184, light);
    }
    vid_present();
}

/* ---- in-game map (first map light) ----------------------------------------
 * Loads the premade America map (AMER2.MP: { w:u16, h:u16, ?:u16,
 * terrain[w*h], layer1[w*h], layer2[w*h] } -- terrain bytes are the SAME
 * 0..28 row indices as the decoded DS:0x2F74 terrain table) and renders the
 * 15x12-tile viewport (16px tiles = 240x192 + sidebar) from TERRAIN.SS.
 *
 * RECONSTRUCTED: the terrain-type -> tile-frame mapping below (frames 0..7 =
 * the eight UNFORESTED types in NAMES.TXT order -- visually confirmed against
 * the sheet; 9/10/11 = Arctic/Ocean/SeaLane).  Forest/mountain/hill OVERLAYS
 * (PHYS0.SS) and the byte-traced tile-pick of func_O513 come next; until
 * then forested tiles show their unforested base. */
static ss_sheet_t g_terrain, g_phys;
static int        g_have_terrain, g_have_phys;
static uint8_t   *g_map;
static int        g_map_w, g_map_h, g_cam_x, g_cam_y;

/* PHYS0.SS overlay rows (16 connectivity variants each; atlas-confirmed,
 * matching RENDER_CHAIN.md's row 0x01/0x11/0x21/0x31 notes):
 *   0..15 minor river | 16..31 major river | 32..47 MOUNTAINS |
 *   48..63 HILLS | 64..79 FOREST | 80.. roads/resources/shore */
#define PH_MOUNT  32
#define PH_HILLS  48
#define PH_FOREST 64

static int t_at(int x, int y)
{
    if (x < 0 || y < 0 || x >= g_map_w || y >= g_map_h) return 25; /* ocean */
    return g_map[y * g_map_w + x];
}

static int is_forest(int t)  { return t >= 8 && t < 24; }

/* 4-bit N/E/S/W same-feature connectivity -> variant frame.
 * RECONSTRUCTED bit order pending the func_O513 neighbour-mask port. */
static int conn_mask(int x, int y, int (*pred)(int))
{
    return (pred(t_at(x, y-1)) ? 1 : 0) | (pred(t_at(x+1, y)) ? 2 : 0) |
           (pred(t_at(x, y+1)) ? 4 : 0) | (pred(t_at(x-1, y)) ? 8 : 0);
}
static int is_mount(int t) { return t == 27; }
static int is_hill(int t)  { return t == 28; }

/* ---- the starting unit, in the REAL UnitRecord table ----------------------
 * UnitRecord: DGROUP:0x3144 stride 0x1C -- +0 map_x, +1 map_y, +2 type
 * (unit.h, BYTE_VERIFIED); unit count @0x539C.  Sprite: ICONS.SS ships are
 * frames 5..7 (project catalog; per-type table not yet byte-verified). */
static ss_sheet_t g_icons;
static int        g_have_icons;
#define UREC(i, off)  DG8(0x3144 + (i)*0x1C + (off))
#define ICON_SHIP 5

static int is_water(int t) { return t == 25 || t == 26; }

static void spawn_start_ship(void)
{
    /* first water tile scanning from mid-map east coast, biased to where the
     * original drops the starting caravel (open Atlantic) */
    int x = g_map_w - 3, y = g_map_h / 3;
    while (x > 1 && !is_water(t_at(x, y))) x--;
    UREC(0, 0) = (uint8_t)x;
    UREC(0, 1) = (uint8_t)y;
    UREC(0, 2) = 0x0D;                 /* Caravel (@UNIT index 13) */
    DG16(0x3144 + 0*0x1C + 0x18) = 0xFFFF;  /* chain head: on-map gate [+0x18]<0 */
    DG16(0x3144 + 0*0x1C + 0x1A) = 0xFFFF;  /* chain_next terminator (0 is a valid idx!) */
    { extern void tilehead_set(int,int,int);
      tilehead_set(UREC(0,0), UREC(0,1), 0); } /* register in the tile-head map */
    DG16(0x539C) = 1;                  /* unit count */
}

static int unit_x(void) { return UREC(0, 0); }
static int unit_y(void) { return UREC(0, 1); }

/* the REAL move gate: func_03FA9C classifier; legal moves commit via the
 * byte-verified chain primitives (the 0x1A1F:0x142 commit thunk sits in an
 * AMBIG segment -- composite cite: unlink @units.c, set xy @0x6958 insert,
 * reveal 0x181F:0xDB8 = func_00BD28) */
extern int naval_classify_dest(int unit, int dest_x, int dest_y);
extern int naval_move_arrive(int dx, int dy);
extern void viceroy_set_move_dest(int x, int y);

static void try_move_ship(int dx, int dy)
{
    /* the REAL pipeline: naval_move_arrive computes dest, classifies
     * (func_03FA9C) and dispatches every status case -- including the
     * COMMIT for legal moves (its 'abort_move' label = the move path). */
    if ((int8_t)UREC(0, 6) <= 0) {               /* moves exhausted (thirds) */
        printf("move: out of moves (SPACE = end turn)\n");
        return;
    }
    DG16(0x5392) = 0;                            /* active unit */
    viceroy_set_move_dest(unit_x() + dx, unit_y() + dy);
    naval_move_arrive(dx, dy);
}

extern int unit_turn_advance(int notify);      /* func_021D32, PORTED */

static void end_turn(void)
{
    /* the REAL advance step (func_021D32): deselect, order ladder, season
     * latch, reveal/cursor, season processors.  Unit ROTATION belongs to the
     * resident dispatcher tail of func_0246E2 -- the SHELL substitutes it
     * here (mainloop_* helpers) until that tail is ported. */
    extern void mainloop_pick_next_unit(void);
    extern void mainloop_finish_rotation(void);
    unit_turn_advance(1);
    mainloop_pick_next_unit();
    if ((int16_t)DG16(0x5392) < 0) {             /* rotation exhausted */
        unit_turn_advance(1);                    /* autumn step (season=1) */
        {   /* the WORLD STEP: census + colonies + market drift + REF
             * (runtime/game_turn.c -- each engine byte-verified) */
            extern void viceroy_world_autumn(void);
            viceroy_world_autumn();
        }
        mainloop_finish_rotation();              /* refresh unit moves */
    }
}

#define TILE 16
#define VIEW_TX 15
#define VIEW_TY 12

static int terrain_frame(int t)
{
    if (t < 8)  return t;             /* unforested base */
    if (t < 16) return t - 8;         /* forested: base for now (overlay TODO) */
    if (t < 24) return t - 16;        /* forested working copies */
    switch (t) {
    case 24: return 9;                /* Arctic   */
    case 25: return 10;               /* Ocean    */
    case 26: return 11;               /* Sea Lane */
    case 27: return 2;                /* Mountains: base under PHYS0 overlay */
    case 28: return 2;                /* Hills:     base under PHYS0 overlay */
    }
    return 10;
}

extern void viceroy_map_attach(const uint8_t *terrain, const uint8_t *feature,
                               const uint8_t *resfog, int w, int h);
extern int  viceroy_sheet_register(const ss_sheet_t *s);
extern void viceroy_set_sheet_terrain(int handle);
extern void viceroy_set_sheet_phys(int handle);

static uint8_t *g_feat, *g_resfog;     /* the .MP's other two layers */

static int load_map(const char *name)
{
    char path[512];
    snprintf(path, sizeof path, "%s/%s", g_data, name);
    FILE *f = fopen(path, "rb");
    if (!f) return -1;
    uint8_t hdr[6];
    if (fread(hdr, 1, 6, f) != 6) { fclose(f); return -1; }
    g_map_w = hdr[0] | (hdr[1] << 8);
    g_map_h = hdr[2] | (hdr[3] << 8);
    size_t n = (size_t)g_map_w * g_map_h;
    free(g_map); free(g_feat); free(g_resfog);
    g_map = malloc(n); g_feat = malloc(n); g_resfog = malloc(n);
    if (!g_map || !g_feat || !g_resfog ||
        fread(g_map, 1, n, f) != n ||
        fread(g_feat, 1, n, f) != n ||
        fread(g_resfog, 1, n, f) != n) {
        fclose(f); return -1;
    }
    fclose(f);
    /* hand all three layers to the real renderer's plumbing (also writes the
     * byte-verified DGROUP homes 0x853A/0x853C/0x8548) */
    viceroy_map_attach(g_map, g_feat, g_resfog, g_map_w, g_map_h);
    return 0;
}

/* the BYTE-VERIFIED composer (tile_chain.c func_O514) draws the frame; this
 * shell only sets the viewport origin and overlays the unit sprite */
extern void map_view_render(int active_layer, int y_extent);

static void draw_map(void)
{
    uint8_t *fb = vid_framebuffer();
    memset(fb, 0, VID_W * VID_H);

    /* the ported func_06787C derives the origin from the view CENTER
     * [0x17C]/[0x17E] (clamped); the shell tracks the center */
    DG16(0x017C) = (uint16_t)(g_cam_x + 7);
    DG16(0x017E) = (uint16_t)(g_cam_y + 6);
    /* map-viewport clip rect (shell-level; the original's screen init sets
     * [0x839E] -- chrome wiring next) */
    DG16(0x839E) = 0; DG16(0x83A0) = 0;
    DG16(0x83A2) = 239; DG16(0x83A4) = 191;
    DG16(0x53A2) = 1;                        /* reveal-all (no fog yet) */
    map_view_render(-1, 0);                  /* tiles (O514 walk) */
    {   /* the composer's overlay passes (func_067644 order) */
        extern void overlay_pass_settlements(void);
        extern void overlay_pass_colonies(void);
        overlay_pass_settlements();          /* 0x191F:0x888 */
        overlay_pass_colonies();             /* 0x191F:0x896 */
        {   extern void overlay_pass_units(void);
            overlay_pass_units();            /* 0x181F:0x344 chain */
        }
    }
    g_cam_x = (int16_t)DG16(0x8328);         /* read back the clamped origin */
    g_cam_y = (int16_t)DG16(0x832E);

    /* (manual ship blit removed: units draw via the ported chain) */
    /* the REAL right-hand UI: minimap panel + tile/unit info panel */
    {
        extern int func_066CD6_minimap_panel(int highlight, int src);
        extern int16_t tile_info_panel(int16_t redraw, int16_t use_cur);
        /* minimap window origin: centre the view (clamped) -- the original's
         * init helper 0x0668B8 is not yet ported */
        int c0 = (int16_t)DG16(0x8328) + 7 - 0x37/2;
        int r0 = (int16_t)DG16(0x832E) + 6 - 0x26/2;
        if (c0 < 0) c0 = 0;
        if (r0 < 0) r0 = 0;
        if (c0 > g_map_w - 0x37) c0 = g_map_w - 0x37;
        if (r0 > g_map_h - 0x26) r0 = g_map_h - 0x26;
        DG16(0x9CCC) = (uint16_t)c0;
        DG16(0x9CCA) = (uint16_t)r0;
        func_066CD6_minimap_panel(0, 0);
        DG16(0x8540) = (uint16_t)unit_x();   /* cursor at the unit */
        DG16(0x853E) = (uint16_t)unit_y();
        tile_info_panel(1, 1);
    }
    vid_present();
}

static int enter_map(void)
{
    if (!g_have_terrain) {
        char path[512];
        snprintf(path, sizeof path, "%s/TERRAIN.SS", g_data);
        if (ss_load(path, &g_terrain) != 0) {
            fprintf(stderr, "shell: cannot load TERRAIN.SS\n");
            return -1;
        }
        g_have_terrain = 1;
        snprintf(path, sizeof path, "%s/PHYS0.SS", g_data);
        g_have_phys = ss_load(path, &g_phys) == 0;
        snprintf(path, sizeof path, "%s/ICONS.SS", g_data);
        g_have_icons = ss_load(path, &g_icons) == 0;
        /* register the sheets with the renderer's leaf layer */
        viceroy_set_sheet_terrain(viceroy_sheet_register(&g_terrain));
        if (g_have_phys)
            viceroy_set_sheet_phys(viceroy_sheet_register(&g_phys));
        if (g_have_icons) {
            extern void viceroy_set_sheet_icons(int);
            viceroy_set_sheet_icons(viceroy_sheet_register(&g_icons));
        }
    }
    if (load_map("AMER2.MP") != 0) {
        fprintf(stderr, "shell: cannot load AMER2.MP\n");
        return -1;
    }
    /* the sheet's palette is VICEROY.PAL (737/768 identical); use it */
    if (g_terrain.has_pal) {
        uint8_t pal[768];
        for (int i = 0; i < 768; i++)
            pal[i] = (uint8_t)((g_terrain.pal6[i] << 2) | (g_terrain.pal6[i] >> 4));
        vid_set_palette(pal);
        memcpy(g_bg.pal, pal, 768);               /* for text-color picking */
    }
    DG16(0x018E) = 2;                 /* classify mode: map view (collapses 8..0x17) */
    spawn_start_ship();
    g_cam_x = unit_x() - VIEW_TX / 2;
    g_cam_y = unit_y() - VIEW_TY / 2;
    if (g_cam_x < 0) g_cam_x = 0;
    if (g_cam_y < 0) g_cam_y = 0;
    if (g_cam_x > g_map_w - VIEW_TX) g_cam_x = g_map_w - VIEW_TX;
    if (g_cam_y > g_map_h - VIEW_TY) g_cam_y = g_map_h - VIEW_TY;
    draw_map();
    return 0;
}

static void follow_unit(void)
{
    int ux = unit_x(), uy = unit_y();
    if (ux - g_cam_x < 2  && g_cam_x > 0)                  g_cam_x--;
    if (ux - g_cam_x > 12 && g_cam_x < g_map_w - VIEW_TX)  g_cam_x++;
    if (uy - g_cam_y < 2  && g_cam_y > 0)                  g_cam_y--;
    if (uy - g_cam_y > 9  && g_cam_y < g_map_h - VIEW_TY)  g_cam_y++;
}

/* ---- Europe dock (playable economy over the decoded engines) --------------
 * Draws the 16-good market strip from the LIVE price levels through the
 * byte-verified leaves (bid = level-1, ask = level+burden), and routes
 * B/S+digit keys into market_buy/market_sell (tax + crown writes inside).
 * Layout is SHELL-RECONSTRUCTED (the original's europe composer is partially
 * ported); every NUMBER shown comes from the real engines. */
static int g_eur_sel;

static void draw_europe(void)
{
    extern int market_bid_price(int good);
    extern int market_ask_price(int good);
    extern uint8_t g_dgroup[];
    uint8_t *fb = vid_framebuffer();
    memset(fb, 0, VID_W * VID_H);
    if (load_bg("EUROPE.PIK") == 0) draw_bg();
    if (g_have_font) {
        uint8_t dark = 0, light = 15;
        pal_pick_text_colors(&dark, &light);
        int32_t gold = *(int32_t *)(g_dgroup + 0x8808 +
                                    (int16_t)DG16(0x9E12) * 0x13C + 0x2A);
        char hdr[96];
        snprintf(hdr, sizeof hdr, "EUROPE  -  Gold %d  Tax %u%%",
                 gold, DG8(0x8808 + (int16_t)DG16(0x9E12) * 0x13C + 1));
        draw_text_center(hdr, 4, light);
        for (int g = 0; g < 16; g++) {
            char row[96];
            const char *nm = viceroy_str(DG16(0x97C0 + g * 2)); /* @CARGO col0 */
            snprintf(row, sizeof row, "%c%2d %-12.12s %3d/%3d",
                     g == g_eur_sel ? '>' : ' ', g + 1,
                     (nm && nm[0]) ? nm : "good", 
                     market_bid_price(g), market_ask_price(g));
            g_font.colors[1] = g_font.colors[2] = g_font.colors[3] =
                (g == g_eur_sel) ? light : dark;
            ff_draw(&g_font, row, 12, 18 + g * (g_font.maxh + 1), 1);
        }
        draw_text_center("S sell 100   B buy 100   Up/Down   ESC", 188, light);
    }
    vid_present();
}

/* ---- the shell ------------------------------------------------------------ */
enum { SH_TITLE, SH_NATIONS, SH_DIFFICULTY, SH_MAP, SH_COLONY, SH_EUROPE };

#define KEY_UP     1073741906
#define KEY_DOWN   1073741905
#define KEY_RETURN 13
#define KEY_F12    1073741893

static void menu_select(int sel, int *screen)
{
    /* options per GAME.TXT @BEGINMENU:
     *   0 Start a Game in NEW WORLD   1 Start a Game in AMERICA
     *   2 CUSTOMIZE New World         3 LOAD Game     4 View Hall of Fame */
    if (sel == 0 || sel == 1) {
        (void)title_screen_update();             /* real dispatch (case 4 path) */
        if (load_bg("NATIONS.PIK") == 0) { draw_nations(); *screen = SH_NATIONS; }
    } else {
        printf("shell: '%s' -- not yet wired (next milestones)\n", g_menu_opt[sel]);
    }
}

static int shell_loop(void)
{
    int screen = SH_TITLE, sel = 0, shots = 0;

    for (;;) {
        int k;

        if (screen == SH_TITLE) {
            /* THE ORIGINAL's title menu: func_0759E8 draws the OPENMENU plate
             * then runs the @BEGINMENU panel through the 0x181F:0x3FE engine
             * (@asm 0x075C60 lea bx,[0x2345]; 0x075C64 lcall 0x181F:0x3FE) and
             * dispatches the 1-based result with `dec ax; jge` (@asm 0x075C6D
             * -- <1 aborts).  The runner is PORTED (src/ui/menu_runner.c); the
             * shell now routes the title flow through it instead of its own
             * Up/Down/Enter reconstruction.  @BEGINMENU's @y/@width/option
             * rows come from GAME.TXT exactly as the original read them. */
            extern int menu_run_key(const char *key, int preselect);
            int r;
            if (load_bg("OPENMENU.PIK") == 0) { draw_bg(); vid_present(); }
            r = menu_run_key("BEGINMENU", 0);  /* key text = DS:0x2345 */
            if (r < 1) return 0;               /* ESC/-1, quit, or no GAME.TXT */
            menu_select(r - 1, &screen);
            continue;
        }

        k = vid_poll_key();
        if (k == VID_QUIT_REQUESTED) return 0;
        if (k == 0) { vid_delay_ms(16); continue; }

        if (k == KEY_F12) {
            char p[64]; snprintf(p, sizeof p, "viceroy_shot%d.ppm", shots++);
            vid_screenshot_ppm(p);
            printf("shell: screenshot -> %s\n", p);
            continue;
        }

        switch (screen) {
        case SH_NATIONS:
            if (k == 27) { screen = SH_TITLE; break; }   /* loop top re-runs the engine */
            if (k >= '1' && k <= '4') {
                DG16(0x5398) = (uint16_t)(k - '1');      /* player nation */
                printf("shell: nation = %s\n", &DG8(DG16(0x8D42 + (k-'1')*2)));
                if (load_bg("DIFFICUL.PIK") == 0) { draw_difficulty(); screen = SH_DIFFICULTY; }
            }
            break;
        case SH_DIFFICULTY:
            if (k == 27) { if (load_bg("NATIONS.PIK") == 0) draw_nations(); screen = SH_NATIONS; break; }
            if (k >= '1' && k <= '5') {
                DG8(0x53A6) = (uint8_t)(k - '1');        /* difficulty 0..4 */
                printf("shell: difficulty = %d -- entering the map\n", k - '1');
                if (enter_map() == 0) screen = SH_MAP;
            }
            break;
        case SH_COLONY:
            if (k >= '1' && k <= '9') {          /* colony services (func_02883E) */
                extern int colony_service_menu(int colony_sel, int item_id);
                int r = colony_service_menu((int16_t)DG16(0x8DC6), k - '0');
                printf("colony: service %d -> %d\n", k - '0', r);
                {   extern void colony_screen_render(int);
                    memset(vid_framebuffer(), 0, VID_W * VID_H);
                    if (load_bg("COLONY.PIK") == 0) draw_bg();
                    colony_screen_render(1);
                    vid_present();
                }
            }
            if (k == 27) {                        /* ESC: back to the map */
                if (g_terrain.has_pal) {
                    uint8_t pal[768];
                    for (int i2 = 0; i2 < 768; i2++)
                        pal[i2] = (uint8_t)((g_terrain.pal6[i2] << 2) | (g_terrain.pal6[i2] >> 4));
                    vid_set_palette(pal);
                }
                draw_map(); screen = SH_MAP;
            }
            break;
        case SH_EUROPE: {
            extern long market_sell(int good, int qty);
            extern long market_buy(int good, int qty);
            extern void market_set_active(int power);
            if (k == 27) { draw_map(); screen = SH_MAP; break; }
            if (k == KEY_UP)   { g_eur_sel = (g_eur_sel + 15) & 15; draw_europe(); }
            if (k == KEY_DOWN) { g_eur_sel = (g_eur_sel + 1) & 15;  draw_europe(); }
            if (k == 's' || k == 'S') {
                market_set_active((int16_t)DG16(0x5398));
                long n = market_sell(g_eur_sel, 100);
                printf("europe: sold 100 of good %d for %ld (net of tax)\n",
                       g_eur_sel, n);
                draw_europe();
            }
            if (k == 'b' || k == 'B') {
                market_set_active((int16_t)DG16(0x5398));
                long n = market_buy(g_eur_sel, 100);
                printf("europe: bought 100 of good %d for %ld\n", g_eur_sel, n);
                draw_europe();
            }
            break;
        }
        case SH_MAP:
            if (k == 1073741886) {               /* F5: save (original format) */
                extern int save_game_state(const char *);
                char sp[512];
                snprintf(sp, sizeof sp, "%s/COLONY00.SAV", g_data);
                printf(save_game_state(sp) == 0 ? "saved: %s\n"
                                                : "save FAILED: %s\n", sp);
            }
            if (k == 1073741888) {               /* F7: load */
                extern int load_savegame(const char *);
                char sp[512];
                snprintf(sp, sizeof sp, "%s/COLONY00.SAV", g_data);
                if (load_savegame(sp) == 0) {
                    printf("loaded: %s\n", sp);
                    draw_map();
                } else printf("load FAILED: %s\n", sp);
            }
            if (k == 'e' || k == 'E') {
                extern void market_set_active(int power);
                market_set_active((int16_t)DG16(0x5398));
                draw_europe(); screen = SH_EUROPE; break;
            }
            if (k == 27) { screen = SH_TITLE; break; }   /* loop top re-runs the engine */
            if (k == KEY_UP)     { try_move_ship( 0,-1); follow_unit(); draw_map(); }
            if (k == KEY_DOWN)   { try_move_ship( 0, 1); follow_unit(); draw_map(); }
            if (k == 1073741904) { try_move_ship(-1, 0); follow_unit(); draw_map(); } /* left  */
            if (k == 1073741903) { try_move_ship( 1, 0); follow_unit(); draw_map(); } /* right */
            if (k == ' ')        { end_turn(); draw_map(); }
            if (k == 13) {                        /* ENTER: open colony here */
                extern int func_0082DC_logic_sz_118(uint16_t);
                extern void colony_screen_render(int);
                int u = (int16_t)DG16(0x5392);
                int cx = u >= 0 ? UREC(u,0) : unit_x();
                int cy = u >= 0 ? UREC(u,1) : unit_y();
                int n = (int16_t)DG16(0x539E);
                for (int ci = 0; ci < n; ci++) {
                    if (DG8(0x5D46+ci*0xCA) == cx && DG8(0x5D46+ci*0xCA+1) == cy) {
                        func_0082DC_logic_sz_118((uint16_t)ci); /* select: ctx */
                        /* composer fill @0x0285A2 covers 0,0,320,200; its fill
                         * leaf (0x191F:0x7EC) is undecoded, so clear to black
                         * (no stale frame) and let the PIK band be the scene */
                        memset(vid_framebuffer(), 0, VID_W * VID_H);
                        if (load_bg("COLONY.PIK") == 0) draw_bg();
                        colony_screen_render(1);   /* title painter draws name */
                        vid_present();
                        screen = SH_COLONY;
                        break;
                    }
                }
            }
            if (k == 'b') {                      /* B: FOUND COLONY (real creator) */
                extern int func_02EB78_text_sz_55(uint16_t,uint16_t,uint16_t,uint16_t);
                int u = (int16_t)DG16(0x5392);
                if (u >= 0 && UREC(u,2) < 0xD) {     /* a land unit */
                    int s = func_02EB78_text_sz_55(DG16(0x5396),
                                                   UREC(u,0), UREC(u,1), 0xFFFF);
                    if (s >= 0) {
                        for (int kk = 0; kk < 16; kk++)   /* default name */
                            DG8(0x5D46 + s*0xCA + 2 + kk) =
                                DG8(0x5426 + DG16(0x5396)*0x34 + kk);
                        printf("colony founded: slot %d at %d,%d\n",
                               s, UREC(u,0), UREC(u,1));
                    }
                    draw_map();
                }
            }
            if (k == 1073741882) {               /* F1: the REAL terrain report */
                extern int func_069D8C_terrain_report_dialog(uint16_t);
                func_069D8C_terrain_report_dialog(0);
                draw_map();
            }
            break;
        }
    }
}

int main(int argc, char **argv)
{
    printf("viceroy_modern\n");
    int smoke_turns = 0;
    const char *script_path = getenv("VICEROY_SCRIPT");
    const char *seed_str = getenv("VICEROY_SEED");
    const char *roundtrip_path = NULL;
    for (int ai = 1; ai < argc; ai++) {
        if (!strncmp(argv[ai], "--smoke", 7))
            smoke_turns = argv[ai][7] == '=' ? atoi(argv[ai] + 8) : 4;
        if (!strncmp(argv[ai], "--script=", 9))
            script_path = argv[ai] + 9;
        if (!strncmp(argv[ai], "--seed=", 7))
            seed_str = argv[ai] + 7;
        if (!strncmp(argv[ai], "--roundtrip=", 12))
            roundtrip_path = argv[ai] + 12;
    }
    /* determinism rig (ROUTE_B_PLAN 0.1): explicit LCG seed + input script */
    if (seed_str) {
        extern unsigned int g_rand_seed_28EE;
        g_rand_seed_28EE = (unsigned int)strtoul(seed_str, NULL, 0);
        printf("  SEED      : 0x%08X\n", g_rand_seed_28EE);
    }
    if (script_path) {
        extern int script_input_load(const char *);
        if (script_input_load(script_path) != 0)
            return 2;
    }

    dgroup_init();
    const char *env = getenv("VICEROY_DATA");
    if (env) g_data = env;

    /* the DGROUP initialized window, from the USER'S OWN VICEROY.EXE at
     * runtime (file 0x1D9A0 .. +0x2CC5; nothing embedded in this binary) */
    {
        extern int dgroup_load_image(const char *);
        if (dgroup_load_image(g_data) == 0)
            printf("  DGROUP    : init window loaded from VICEROY.EXE "
                   "(anchor @0xB4 ok)\n");
        else
            printf("  DGROUP    : VICEROY.EXE not found -- embedded tables "
                   "stay zero\n");
    }

    int n = viceroy_load_names(g_data);
    if (n >= 0)
        printf("  NAMES.TXT : %d entries (%s | %s | %s | %s)\n", n,
               &DG8(0x540E), &DG8(0x540E + 0x34),
               &DG8(0x540E + 2*0x34), &DG8(0x540E + 3*0x34));
    else
        printf("  NAMES.TXT : not found under '%s' (set $VICEROY_DATA)\n", g_data);
    int nl = viceroy_load_labels(g_data);
    if (nl >= 0)
        printf("  LABELS    : %d entries (MISC[0]='%s' INFO[0]='%s' CTITLE[0]='%s')\n",
               nl, viceroy_str(DG16(0x2DBA)), viceroy_str(DG16(0x96F4)),
               viceroy_str(DG16(0x939E)));

    if (load_beginmenu() == 0)
        printf("  @BEGINMENU: %d options, width=%d y=%d\n",
               g_menu_count, g_menu_width, g_menu_y);

    char fpath[512];
    snprintf(fpath, sizeof fpath, "%s/FONTSMAL.FF", g_data);
    g_have_font = ff_load(fpath, &g_font) == 0;
    if (g_have_font) {
        printf("  FONTSMAL  : %dx%d glyphs\n", g_font.maxw, g_font.maxh);
        extern void viceroy_init_text_ctx(int);
        viceroy_init_text_ctx(g_font.maxh);   /* ctx byte0+1 = line height */
    }

    /* DOSBox-parity: load a real COLONIZE save and re-save it, for savediff
     * against the original (load-fidelity = modern state model matches the
     * original's save format byte-for-byte). */
    if (roundtrip_path) {
        extern int load_savegame(const char *);
        extern int save_game_state(const char *);
        char out[700];
        snprintf(out, sizeof out, "%s.rt", roundtrip_path);
        { int rc = load_savegame(roundtrip_path);
          if (rc != 0) { printf("roundtrip: load FAILED rc=%d\n", rc); return 3; } }
        if (save_game_state(out) != 0) { printf("roundtrip: save FAILED %s\n", out); return 3; }
        printf("roundtrip: %s -> %s (year %u, %u colonies, %u units)\n",
               roundtrip_path, out, DG16(0x538A), DG16(0x539E), DG16(0x539C));
        return 0;
    }

    /* HOF persistence self-test (6.2): verify hof_fopen resolves the DGROUP
     * string handles and the 0xD2-byte HALLFAME.DAT round-trips. */
    {
        for (int ai = 1; ai < argc; ai++) if (!strcmp(argv[ai], "--hoftest")) {
            extern void *hof_fopen(int, int);
            extern int hof_fwrite(const void *, int, int, void *);
            extern int hof_fread(void *, int, int, void *);
            extern int hof_fclose(void *);
            unsigned char w[0xD2], r[0xD2]; int k;
            for (k = 0; k < 0xD2; k++) w[k] = (unsigned char)(k * 7 + 1);
            if (chdir("/tmp") != 0) {}
            void *fp = hof_fopen(0x1224 /*wb*/, 0x1227 /*HALLFAME.DAT*/);
            int wn = fp ? hof_fwrite(w, 1, 0xD2, fp) : -1; if (fp) hof_fclose(fp);
            fp = hof_fopen(0x11EF /*rb*/, 0x11F2 /*HALLFAME.DAT*/);
            int rn = fp ? hof_fread(r, 1, 0xD2, fp) : -1; if (fp) hof_fclose(fp);
            printf("hoftest: wb_fopen=%s wrote=%d read=%d match=%s\n",
                   wn >= 0 ? "ok" : "NULL", wn, rn,
                   (wn == 0xD2 && rn == 0xD2 && memcmp(w, r, 0xD2) == 0) ? "YES" : "NO");
            return 0;
        }
    }

    /* Intro-player self-test (6.4): parse OPENING.TXT + report the schedule. */
    {
        for (int ai = 1; ai < argc; ai++) if (!strcmp(argv[ai], "--introtest")) {
            extern int intro_load_script(const char *);
            extern int intro_credit_count(void), intro_anim_count(void), intro_end_frame(void);
            extern const char *intro_loading_msg(void), *intro_anim_sheet(int);
            if (intro_load_script(g_data) != 0) { printf("introtest: OPENING.TXT load FAILED\n"); return 3; }
            printf("introtest: %d credit cards, %d animations, end_frame=%d, msg=\"%s\"\n",
                   intro_credit_count(), intro_anim_count(), intro_end_frame(), intro_loading_msg());
            for (int s = 0; s < 10; s++) printf("  series %d -> %s\n", s, intro_anim_sheet(s));
            return 0;
        }
    }

    if (smoke_turns > 0) {
        extern int viceroy_world_smoke(int);
        return viceroy_world_smoke(smoke_turns);
    }

    /* exercise the real byte-traced title logic once regardless of video */
    title_screen_render();

    int headless = vid_init("Viceroy (Colonization reconstruction)");

    /* 6.4: the boxed-experience opening sequence (the original boots OPENING.EXE
     * before VICEROY.EXE). Data-driven from OPENING.TXT + OPENING.PIK + OPEN*.SS;
     * with a display it plays, headless it validates the script and returns. */
    {   extern int script_input_active(void);
        if (!headless && !script_input_active()) {
            extern int intro_play(const char *dir);
            intro_play(g_data);
        }
    }

    {   /* determinism rig (ROUTE_B_PLAN 0.1): a loaded script drives the
         * real shell loop even headless; script exhaustion delivers QUIT */
        extern int script_input_active(void);
        if (headless && script_input_active()) {
            g_interactive = 1;
            shell_loop();
            if (g_have_font) ff_free(&g_font);
            if (g_have_bg) pik_free(&g_bg);
            vid_shutdown();
            return 0;
        }
    }
    if (headless) {
        if (load_bg("OPENMENU.PIK") == 0) {
            draw_title_menu(0);
            vid_screenshot_ppm("viceroy_title.ppm");
            printf("  headless  : title+menu frame -> viceroy_title.ppm\n");
        }
        if (load_bg("NATIONS.PIK") == 0) {
            draw_nations();
            vid_screenshot_ppm("viceroy_nations.ppm");
            printf("  headless  : nations frame -> viceroy_nations.ppm\n");
        }
        /* (colony-screen frame added after the map frame below) */
        DG16(0x5398) = 0;                          /* England, for the sidebar */
        /* TEST SEED (headless verification only): one colony of power 0 at a
         * land tile, named with the REAL default from NAMES.TXT @COLONYNAME
         * (PowerRecord name field 0x5426), so the ported colony pass + blit
         * (func_067182 -> func_004314) have something to draw. */
        {
            int rec = 0x5D46;                     /* ColonyRecord[0] */
            DG8(rec)     = 30;                    /* x */
            DG8(rec + 1) = 38;                    /* y (land region) */
            DG8(rec + 0x1A) = 0;                  /* owner = power 0 */
            DG8(rec + 0x1F) = 4;                  /* population */
            for (int k = 0; k < 16; k++)          /* name from 0x5426 */
                DG8(rec + 2 + k) = DG8(0x5426 + k);
            DG16(0x539E) = 1;                     /* colony count */
            DG16(0x5396) = 0;                     /* active power */
            DG8(0x543F)  = 1;                     /* power 0 ACTIVE (the title
                                                   * gate [owner*0x34+0x543F]) */
            DG16(0x2F5E) = 1000;                  /* treasury (gold display) */
            {   /* a little stock so the bar's value path is visible:
                 * Food=25, Lumber=60, Ore=12 (ctx words +0x9A+i*2) */
                DG16(rec + 0x9A + 0*2) = 25;
                DG16(rec + 0x9A + 5*2) = 60;
                DG16(rec + 0x9A + 6*2) = 12;
            }
        }
        
        
        if (enter_map() == 0) {
            UREC(0,0) = 26; UREC(0,1) = 36;   /* park the test ship in view */
            { extern void tilehead_reset(int,int); extern void tilehead_set(int,int,int);
              tilehead_reset(g_map_w, g_map_h); tilehead_set(26, 36, 0); }
            /* classifier self-test (headless): W=water, E=land+empty hold,
             * far-E edge = SAILHOME */
            {
                UREC(0,6) = DG8(0x5234 + 0x0D*9);   /* caravel moves (thirds) */
                printf("  move-test : start (%d,%d) moves=%d\n",
                       UREC(0,0), UREC(0,1), (int8_t)UREC(0,6));
                try_move_ship(-1, 0);                /* W into open water */
                printf("  move-test : after W -> (%d,%d) moves=%d\n",
                       UREC(0,0), UREC(0,1), (int8_t)UREC(0,6));
                try_move_ship(0, -1);                /* N onto land (empty hold) */
                printf("  move-test : after N(land) -> (%d,%d) status=%d\n",
                       UREC(0,0), UREC(0,1), DG16(0x9E4E));
                end_turn();
                {   /* LANDFALL + FOUND COLONY: colonist aboard, sail E onto
                     * the shore, accept the landfall prompt, build */
                    extern void viceroy_dialog_force(int);
                    extern void tilehead_set(int,int,int);
                    extern int func_02EB78_text_sz_55(uint16_t,uint16_t,uint16_t,uint16_t);
                    /* seed colonist (type 0, unit 1) chained behind the ship */
                    UREC(1,0)=UREC(0,0); UREC(1,1)=UREC(0,1);
                    UREC(1,2)=0; UREC(1,3)=0; UREC(1,6)=DG8(0x5234);
                    DG16(0x3144+0x1C+0x18)=0; DG16(0x3144+0x1C+0x1A)=0xFFFF;
                    DG16(0x3144+0x1A)=1;        /* ship.next = colonist */
                    DG16(0x539C)=2;
                    viceroy_dialog_force(2);    /* answer 'Make Landfall' */
                    try_move_ship(1, 0);        /* E onto the shore */
                    printf("  landfall  : colonist at (%d,%d) orders=%d\n",
                           UREC(1,0), UREC(1,1), UREC(1,8));
                    DG16(0x5392)=1;             /* select the colonist */
                    {   int s = func_02EB78_text_sz_55(DG16(0x5396),
                                UREC(1,0), UREC(1,1), 0xFFFF);
                        if (s >= 0)
                            for (int kk = 0; kk < 16; kk++)
                                DG8(0x5D46 + s*0xCA + 2 + kk) =
                                    DG8(0x5426 + DG16(0x5396)*0x34 + kk);
                        printf("  founded   : slot %d colonies=%d\n",
                               s, DG16(0x539E));
                    }
                    DG16(0x5392)=0;
                }
                {   /* movement-cost engine: NAMES.TXT Movement column must
                     * differentiate terrain (Ocean 1x3 / land per-class) */
                    extern int unit_move_cost_thirds(int, int, int);
                    int cw = unit_move_cost_thirds(1, UREC(1,0)-1, UREC(1,1));
                    int ce = unit_move_cost_thirds(1, UREC(1,0)+1, UREC(1,1));
                    int cn = unit_move_cost_thirds(1, UREC(1,0), UREC(1,1)-1);
                    printf("  move-cost : W=%d E=%d N=%d thirds (from @TERRAIN)\n",
                           cw, ce, cn);
                    /* the Movement column itself (rows: Tundra=0, Marsh=6,
                     * Ocean=25, Mountains=27): expect 1,2,1,3 per NAMES.TXT */
                    printf("  @TERRAIN  : move Tundra=%d Marsh=%d Ocean=%d "
                           "Mountains=%d\n",
                           DG8(0x2F76 + 0*16), DG8(0x2F76 + 6*16),
                           DG8(0x2F76 + 25*16), DG8(0x2F76 + 27*16));
                }
                {   /* F1 smoke: the real terrain report must run clean */
                    extern int func_069D8C_terrain_report_dialog(uint16_t);
                    int rr = func_069D8C_terrain_report_dialog(0);
                    printf("  F1 report : ran (ret=%d)\n", rr);
                }
                UREC(0,0) = 26; UREC(0,1) = 36;      /* re-park for the frame */
                { extern void tilehead_reset(int,int); extern void tilehead_set(int,int,int);
                  tilehead_reset(g_map_w, g_map_h); tilehead_set(26,36,0); }
            }
            g_cam_x = 24; g_cam_y = 34;   /* land-rich verification viewport */
            draw_map();
            vid_screenshot_ppm("viceroy_map.ppm");
            {   /* colony screen frame */
                extern int func_0082DC_logic_sz_118(uint16_t);
                extern void colony_screen_render(int);
                func_0082DC_logic_sz_118(0);
                memset(vid_framebuffer(), 0, VID_W * VID_H);  /* see ENTER path */
                if (load_bg("COLONY.PIK") == 0) draw_bg();
                colony_screen_render(1);   /* title painter draws the name */
                vid_present();
                vid_screenshot_ppm("viceroy_colony.ppm");
                printf("  headless  : colony frame -> viceroy_colony.ppm\n");
            }
            printf("  headless  : map frame -> viceroy_map.ppm "
                   "(%dx%d tiles)\n", g_map_w, g_map_h);
        }
    } else {
        g_interactive = 1;
        shell_loop();
    }

    if (g_have_font) ff_free(&g_font);
    if (g_have_bg) pik_free(&g_bg);
    vid_shutdown();
    printf("viceroy_modern: clean exit\n");
    return 0;
}
