/* ============================================================================
 * intro_render_glue.c -- platform renderer for the Phase-6.4 intro player.
 * ----------------------------------------------------------------------------
 * Strong overrides of intro_player.c's weak render hooks. Decodes the user's
 * OPENING.PIK backdrop (MADSPACK 2.0; pik.c) + palette and the OPEN*.SS sprite
 * series (MADSPACK MS_SPRITE; ss.c), and composites each intro frame into the
 * 320x200 framebuffer (headless: dump-able via vid_screenshot_ppm).
 *
 * Animation model (the SCHEDULE is exact from OPENING.TXT; the per-tick sprite
 * selection/position is RECONSTRUCTED pending the OPENING.EXE frame-loop decode
 * -- see docs/INTRO_PLAYER.md): the backdrop is the opening scene; each
 * @OPENING animation cycles its sheet's frames at the intro tick rate at its
 * baseX; each @CREDITS card shows sprite `sprite` of OPENCRD<series> during its
 * [start,end] window, centered.
 * ============================================================================ */
#ifdef _VICEROY_MODERN
#include <stdio.h>
#include <string.h>
#include "platform.h"

typedef struct { int start, end, series, sprite; } intro_credit_t;
typedef struct { int series, frame, repeats, basex; } intro_anim_t;

extern const char *intro_anim_sheet(int series);
extern const char *intro_credit_sheet(int series);

static pik_image_t g_bg;
static int         g_have_bg;
static ss_sheet_t  g_anim[10];   static int g_anim_ok[10];
static ss_sheet_t  g_cred[3];    static int g_cred_ok[3];
static const char *g_dir;

int intro_render_open(const char *dir)
{
    char path[512];
    g_dir = dir;
    snprintf(path, sizeof path, "%s/OPENING.PIK", dir);
    g_have_bg = (pik_load(path, &g_bg) == 0);
    if (g_have_bg && g_bg.has_pal) vid_set_palette(g_bg.pal);
    for (int s = 0; s < 10; s++) {
        const char *n = intro_anim_sheet(s);
        if (!n) continue;
        snprintf(path, sizeof path, "%s/%s", dir, n);
        g_anim_ok[s] = (ss_load(path, &g_anim[s]) == 0);
    }
    for (int s = 0; s < 3; s++) {
        snprintf(path, sizeof path, "%s/%s", dir, intro_credit_sheet(s));
        g_cred_ok[s] = (ss_load(path, &g_cred[s]) == 0);
    }
    /* renderable iff at least the backdrop decoded (sheets are best-effort). */
    return g_have_bg ? 0 : -1;
}

static void draw_backdrop(void)
{
    uint8_t *fb = vid_framebuffer();
    if (!g_have_bg) { memset(fb, 0, VID_W * VID_H); return; }
    int w = g_bg.w < VID_W ? g_bg.w : VID_W;
    int h = g_bg.h < VID_H ? g_bg.h : VID_H;
    memset(fb, 0, VID_W * VID_H);
    for (int y = 0; y < h; y++)
        memcpy(fb + y * VID_W, g_bg.pixels + y * g_bg.w, w);
}

void intro_render_frame(int frame, const intro_credit_t *creds, int nc,
                        const intro_anim_t *anims, int na)
{
    draw_backdrop();
    /* opening animations: cycle each sheet's frames at the intro tick rate at
     * its baseX (clamped onto the 320-wide screen; baseX 640/320 are the
     * original's 2x-overscan coords, halved here). */
    for (int i = 0; i < na; i++) {
        int s = anims[i].series;
        if (s < 0 || s >= 10 || !g_anim_ok[s] || g_anim[s].nframes <= 0) continue;
        int x = anims[i].basex >> 1;                 /* overscan -> screen */
        if (x >= VID_W) x -= VID_W;
        int fr = frame % g_anim[s].nframes;          /* cycle the sheet frames */
        ss_blit(&g_anim[s], fr, x, VID_H / 4);
    }
    /* credit cards active in their [start,end] window. */
    for (int i = 0; i < nc; i++) {
        if (frame < creds[i].start || frame > creds[i].end) continue;
        int s = creds[i].series;
        if (s < 0 || s >= 3 || !g_cred_ok[s]) continue;
        int spr = creds[i].sprite;
        if (spr < 0 || spr >= g_cred[s].nframes) spr = 0;
        const ss_frame_t *f = &g_cred[s].frames[spr];
        ss_blit(&g_cred[s], spr, (VID_W - f->w) / 2, (VID_H - f->h) / 2);
    }
}

void intro_render_message(const char *msg)
{
    /* the @MESSAGES "Loading Game..." card; drawn via the shell font if present. */
    extern ff_font_t *viceroy_font(void);
    ff_font_t *fnt = viceroy_font();
    draw_backdrop();
    if (fnt && msg && msg[0]) {
        int w = ff_text_width(fnt, msg, 1);
        fnt->colors[1] = fnt->colors[2] = fnt->colors[3] = 15;
        ff_draw(fnt, msg, (VID_W - w) / 2, VID_H - 24, 1);
    }
}

void intro_render_close(void)
{
    if (g_have_bg) { pik_free(&g_bg); g_have_bg = 0; }
    for (int s = 0; s < 10; s++) if (g_anim_ok[s]) { ss_free(&g_anim[s]); g_anim_ok[s] = 0; }
    for (int s = 0; s < 3; s++)  if (g_cred_ok[s]) { ss_free(&g_cred[s]); g_cred_ok[s] = 0; }
}

/* present a frame: SDL when live, else dump a numbered PPM for verification. */
void intro_render_present(int frame)
{
    extern int viceroy_interactive(void);
    if (viceroy_interactive()) { vid_present(); return; }
    char path[256];
    snprintf(path, sizeof path, "/tmp/intro_%04d.ppm", frame);
    vid_screenshot_ppm(path);
}

int intro_aborted(void) { return vid_poll_key() == 0x1B; }   /* ESC skips */
#endif /* _VICEROY_MODERN */
