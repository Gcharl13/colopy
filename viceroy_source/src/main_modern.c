/* ============================================================================
 * main_modern.c -- modern-host entry point + title-screen shell (milestone 3)
 * ----------------------------------------------------------------------------
 * Replaces the DOS pair boot/entry.c + runtime/cstart.c.  Boots the DGROUP
 * memory layer, loads the game's own data files (NAMES.TXT tables at their
 * byte-verified addresses; .PIK backdrops + palettes), and runs a TITLE
 * SCREEN SHELL over the Mode-13h video layer (platform.h).
 *
 * Honesty note (reconstruction layer vs byte-verified rules): the artwork,
 * palette, screen flow and key handling here are the RECONSTRUCTION SHELL --
 * the real data-driven @BEGINMENU runner (0x181F:0x3FE) is not yet ported, so
 * this shell presents the real backdrops and routes selections through the
 * real title_screen_update() dispatch.  Every byte of pixel/palette content
 * comes from the user's own game files at runtime (copyright constraint).
 *
 * Screens (artwork per docs/SESSION_UI_CATALOG.md):
 *   title    OPENING backdrop composite = OPENMENU.PIK over OPENING.PIK
 *   new game NATIONS.PIK (power select) -> DIFFICUL.PIK (difficulty select)
 *
 * Keys: 1..4 menu/select | ESC back/quit | F12 screenshot (viceroy_shot.ppm)
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
extern void title_screen_render(void);
extern int  title_screen_update(void);

static const char *g_data = "game_data";

/* blit a (possibly larger) PIK image into the 320x200 framebuffer */
static void blit_pik(const pik_image_t *img)
{
    uint8_t *fb = vid_framebuffer();
    int w = img->w < VID_W ? img->w : VID_W;
    int h = img->h < VID_H ? img->h : VID_H;
    for (int y = 0; y < h; y++)
        memcpy(fb + y * VID_W, img->pixels + y * img->w, w);
    if (img->has_pal) vid_set_palette(img->pal);
}

static int show_pik(const char *name)
{
    char path[512];
    snprintf(path, sizeof path, "%s/%s", g_data, name);
    pik_image_t img;
    if (pik_load(path, &img) != 0) {
        fprintf(stderr, "shell: cannot load %s\n", path);
        return -1;
    }
    blit_pik(&img);
    pik_free(&img);
    vid_present();
    return 0;
}

/* ---- the shell screens ---------------------------------------------------- */
enum { SH_TITLE, SH_NATIONS, SH_DIFFICULTY, SH_QUIT };

static int shell_loop(void)
{
    int screen = SH_TITLE, shots = 0;
    show_pik("OPENMENU.PIK");

    for (;;) {
        int k = vid_poll_key();
        if (k == VID_QUIT_REQUESTED) return 0;
        if (k == 0) { vid_delay_ms(16); vid_present(); continue; }

        if (k == 0x11D /* F12 (SDLK_F12 & 0x1FF) */ || k == 1073741893) {
            char p[64]; snprintf(p, sizeof p, "viceroy_shot%d.ppm", shots++);
            vid_screenshot_ppm(p);
            printf("shell: screenshot -> %s\n", p);
            continue;
        }

        switch (screen) {
        case SH_TITLE:
            if (k == 27) return 0;                      /* ESC = quit */
            if (k == '4' || k == 'n') {                 /* NEW GAME path */
                /* the real dispatch: title_screen_update()'s case 4 calls
                 * ttl_begin_game (0x191F:0x320) -- exercised here, then the
                 * shell advances to the power-select backdrop */
                (void)title_screen_update();
                if (show_pik("NATIONS.PIK") == 0) screen = SH_NATIONS;
            }
            break;
        case SH_NATIONS:
            if (k == 27) { show_pik("OPENMENU.PIK"); screen = SH_TITLE; break; }
            if (k >= '1' && k <= '4') {
                DG16(0x5398) = (uint16_t)(k - '1');     /* player nation 0..3 */
                printf("shell: nation = %d\n", k - '1');
                if (show_pik("DIFFICUL.PIK") == 0) screen = SH_DIFFICULTY;
            }
            break;
        case SH_DIFFICULTY:
            if (k == 27) { show_pik("NATIONS.PIK"); screen = SH_NATIONS; break; }
            if (k >= '1' && k <= '5') {
                DG8(0x53A6) = (uint8_t)(k - '1');       /* difficulty 0..4 */
                printf("shell: difficulty = %d -- in-game map loop is the "
                       "next milestone; returning to title\n", k - '1');
                show_pik("OPENMENU.PIK"); screen = SH_TITLE;
            }
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

    /* exercise the real byte-traced title logic once regardless of video */
    title_screen_render();

    int headless = vid_init("Viceroy (Colonization reconstruction)");
    if (headless) {
        /* no display: render the title composite + dump verification shots */
        if (show_pik("OPENMENU.PIK") == 0) {
            vid_screenshot_ppm("viceroy_title.ppm");
            printf("  headless  : title frame -> viceroy_title.ppm\n");
        }
        if (show_pik("NATIONS.PIK") == 0) {
            vid_screenshot_ppm("viceroy_nations.ppm");
            printf("  headless  : nations frame -> viceroy_nations.ppm\n");
        }
    } else {
        shell_loop();
    }

    vid_shutdown();
    printf("viceroy_modern: clean exit\n");
    return 0;
}
