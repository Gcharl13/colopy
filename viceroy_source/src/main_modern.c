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
 * data-driven menu runner (0x181F:0x3FE) is not yet ported.  This shell IS
 * data-driven the same way -- @BEGINMENU's @width/@y/@smallfont directives and
 * option strings come from GAME.TXT at runtime, the row layout/colors are the
 * RECONSTRUCTED part -- and selections route through the real
 * title_screen_update() dispatch + real DGROUP state.  Every byte of
 * pixel/palette/font/string content comes from the user's own game files
 * (copyright constraint).
 *
 * Keys: Up/Down+Enter or 1..5 | ESC back/quit | F12 screenshot
 * Env : VICEROY_DATA = game data dir (default ./game_data)
 * ============================================================================ */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
    DG16(0x539C) = 1;                  /* unit count */
}

static int unit_x(void) { return UREC(0, 0); }
static int unit_y(void) { return UREC(0, 1); }

/* the REAL move gate: func_03FA9C classifier; legal moves commit via the
 * byte-verified chain primitives (the 0x1A1F:0x142 commit thunk sits in an
 * AMBIG segment -- composite cite: unlink @units.c, set xy @0x6958 insert,
 * reveal 0x181F:0xDB8 = func_00BD28) */
extern int naval_classify_dest(int unit, int dest_x, int dest_y);
extern int func_00BD28_op_sz_34(uint16_t x, uint16_t y);

static void try_move_ship(int dx, int dy)
{
    int u = 0;
    int nx = unit_x() + dx, ny = unit_y() + dy;
    DG16(0x5392) = 0;                            /* active unit */
    int r = naval_classify_dest(u, nx, ny);
    int status = (int16_t)DG16(0x9E4E);
    if (r == 1) {                                /* plain legal move */
        UREC(u, 0) = (uint8_t)nx;
        UREC(u, 1) = (uint8_t)ny;
        func_00BD28_op_sz_34((uint16_t)nx, (uint16_t)ny);  /* reveal */
    } else if (status) {
        static const char *names[10] = {0,"NODOCKS","LANDFALL","LANDFALL2",
            "SAILHOME","EUROPENOTLEAVE/SAILHOME","SHIPCOMBAT","SHIPCOMBAT",
            "SHIPLAKE","LANDFIRST"};
        printf("move: status %d (%s) -- dialog dispatch pending part-2 UI\n",
               status, names[status] ? names[status] : "?");
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

/* ---- the shell ------------------------------------------------------------ */
enum { SH_TITLE, SH_NATIONS, SH_DIFFICULTY, SH_MAP };

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
    if (load_bg("OPENMENU.PIK") == 0) draw_title_menu(sel);

    for (;;) {
        int k = vid_poll_key();
        if (k == VID_QUIT_REQUESTED) return 0;
        if (k == 0) { vid_delay_ms(16); continue; }

        if (k == KEY_F12) {
            char p[64]; snprintf(p, sizeof p, "viceroy_shot%d.ppm", shots++);
            vid_screenshot_ppm(p);
            printf("shell: screenshot -> %s\n", p);
            continue;
        }

        switch (screen) {
        case SH_TITLE:
            if (k == 27) return 0;
            if (k == KEY_UP)   { sel = (sel + g_menu_count - 1) % g_menu_count; draw_title_menu(sel); }
            if (k == KEY_DOWN) { sel = (sel + 1) % g_menu_count;                draw_title_menu(sel); }
            if (k == KEY_RETURN) menu_select(sel, &screen);
            if (k >= '1' && k < '1' + g_menu_count) menu_select(k - '1', &screen);
            break;
        case SH_NATIONS:
            if (k == 27) { if (load_bg("OPENMENU.PIK") == 0) draw_title_menu(sel); screen = SH_TITLE; break; }
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
        case SH_MAP:
            if (k == 27) {
                if (load_bg("OPENMENU.PIK") == 0) draw_title_menu(sel);
                screen = SH_TITLE; break;
            }
            if (k == KEY_UP)     { try_move_ship( 0,-1); follow_unit(); draw_map(); }
            if (k == KEY_DOWN)   { try_move_ship( 0, 1); follow_unit(); draw_map(); }
            if (k == 1073741904) { try_move_ship(-1, 0); follow_unit(); draw_map(); } /* left  */
            if (k == 1073741903) { try_move_ship( 1, 0); follow_unit(); draw_map(); } /* right */
            break;
        }
    }
}

int main(int argc, char **argv)
{
    (void)argc; (void)argv;
    printf("viceroy_modern\n");

    dgroup_init();
    const char *env = getenv("VICEROY_DATA");
    if (env) g_data = env;

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

    /* exercise the real byte-traced title logic once regardless of video */
    title_screen_render();

    int headless = vid_init("Viceroy (Colonization reconstruction)");
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
        }
        
        
        if (enter_map() == 0) {
            UREC(0,0) = 26; UREC(0,1) = 36;   /* park the test ship in view */
            g_cam_x = 24; g_cam_y = 34;   /* land-rich verification viewport */
            draw_map();
            vid_screenshot_ppm("viceroy_map.ppm");
            printf("  headless  : map frame -> viceroy_map.ppm "
                   "(%dx%d tiles)\n", g_map_w, g_map_h);
        }
    } else {
        shell_loop();
    }

    if (g_have_font) ff_free(&g_font);
    if (g_have_bg) pik_free(&g_bg);
    vid_shutdown();
    printf("viceroy_modern: clean exit\n");
    return 0;
}
