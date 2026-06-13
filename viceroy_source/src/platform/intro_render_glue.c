/* ============================================================================
 * intro_render_glue.c -- platform renderer for the Phase-6.4 intro player.
 * ----------------------------------------------------------------------------
 * Strong overrides of intro_player.c's weak render hooks. Faithful port of
 * OPENING.EXE's player loop (decoded in docs/INTRO_FRAMELOOP_DECODE.md):
 *
 *   - backdrop = OPENING.PIK, a **960x132 voyage panorama** shown through a
 *     320-wide window that PANS across it (the scene scrolls; sprites are
 *     screen-fixed -- proven by OPENSHIP's 8 frames sharing one (x,y)).
 *     OPENBORD.PIK frames the play window.
 *   - sprites are **event-triggered** (FUN_1000_0724): each @OPENING series
 *     activates at its trigger frame, advances its own sheet frame, holds the
 *     last frame when repeats==0 (the guy holds nframes-5), loops `repeats`
 *     times otherwise. Series 1 (Sun) uses the hand-keyed frame ladder from
 *     FUN_1000_042c; series 8 (logo) shows at frame 767; series -1 ends @891.
 *   - each sprite blits at its **.SS per-frame (x,y)** screen anchor
 *     (bottom-center registration), clipped to the 320x132 play window.
 *   - credit cards (OPENCRD1/2/3) show in their [start,end] windows.
 *
 * Reconstructed (documented residual; needs a DOSBox runtime trace): the exact
 * scroll-position table (0x4f0e) -> the pan here is linear in the frame number;
 * the late Z-order swap at frame 507; the logo palette cross-fade.
 * ============================================================================ */
#ifdef _VICEROY_MODERN
#include <stdio.h>
#include <string.h>
#include "platform.h"

#define INTRO_PLAY_H 132          /* FUN_1000_02e4: play area is 320 x 132 */
#define INTRO_SERIES_SUN   1      /* hand-keyed frame ladder (FUN_1000_042c) */
#define INTRO_SERIES_GUY   7      /* holds at nframes-5                      */
#define INTRO_SERIES_LOGO  8      /* OPENLOGO single frame                   */

typedef struct { int start, end, series, sprite; } intro_credit_t;
typedef struct { int series, frame, repeats, basex; } intro_anim_t;

extern const char *intro_anim_sheet(int series);
extern const char *intro_credit_sheet(int series);
extern int         intro_end_frame(void);

static pik_image_t g_bg;          static int g_have_bg;       /* OPENING.PIK 960x132 */
static pik_image_t g_border;      static int g_have_border;   /* OPENBORD.PIK 320x200 */
static ss_sheet_t  g_anim[10];    static int g_anim_ok[10];
static ss_sheet_t  g_cred[3];     static int g_cred_ok[3];
static const char *g_dir;

int intro_render_open(const char *dir)
{
    char path[512];
    g_dir = dir;
    snprintf(path, sizeof path, "%s/OPENING.PIK", dir);
    g_have_bg = (pik_load(path, &g_bg) == 0);
    if (g_have_bg && g_bg.has_pal) vid_set_palette(g_bg.pal);
    snprintf(path, sizeof path, "%s/OPENBORD.PIK", dir);
    g_have_border = (pik_load(path, &g_border) == 0);
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

/* window_left(frame): the 320-window's left edge in the 960-wide scene. The
 * scene pans its full width over the run (linear reconstruction; the exact
 * per-step table lives at OPENING.EXE DGROUP 0x4f0e). */
static int window_left(int frame)
{
    int span = g_bg.w - VID_W;
    if (span <= 0) return 0;
    int end = intro_end_frame();
    if (end <= 0) return 0;
    long wl = (long)frame * span / end;
    if (wl < 0) wl = 0;
    if (wl > span) wl = span;
    return (int)wl;
}

/* draw the panning scene window into the play area, framed by OPENBORD. */
static void draw_backdrop(int frame)
{
    uint8_t *fb = vid_framebuffer();
    memset(fb, 0, VID_W * VID_H);
    if (g_have_border) {                       /* base: the border frame */
        int w = g_border.w < VID_W ? g_border.w : VID_W;
        int h = g_border.h < VID_H ? g_border.h : VID_H;
        for (int y = 0; y < h; y++)
            memcpy(fb + y * VID_W, g_border.pixels + y * g_border.w, w);
    }
    if (!g_have_bg) return;
    int wl = window_left(frame);
    int h = g_bg.h < INTRO_PLAY_H ? g_bg.h : INTRO_PLAY_H;   /* top 132 rows */
    int w = g_bg.w - wl < VID_W ? g_bg.w - wl : VID_W;
    for (int y = 0; y < h; y++)
        memcpy(fb + y * VID_W, g_bg.pixels + y * g_bg.w + wl, w);
}

/* Sun frame index (0-based) keyed to the global frame -- FUN_1000_042c. */
static int sun_idx(int frame)
{
    int v = 1;
    if (frame > 0x86) v = 2;  if (frame > 0x98) v = 3;  if (frame > 0xac) v = 4;
    if (frame > 0xc2) v = 5;  if (frame > 0xdb) v = 6;  if (frame > 0xeb) v = 7;
    if (frame > 0xfb) v = 6;
    return v - 1;
}

/* Resolve an @OPENING entry to a sheet-frame index at `frame`, or -1 if the
 * animation is not currently on screen. Closed form of the FUN_1000_0724
 * activate/advance/hold/repeat state machine (works for random-access frames
 * so the keyframe dumps are correct). */
static int anim_frame_index(const intro_anim_t *a, int frame)
{
    int s = a->series;
    if (s < 0 || s >= 10 || !g_anim_ok[s]) return -1;
    int N = g_anim[s].nframes;
    if (N <= 0 || frame < a->frame) return -1;

    if (s == INTRO_SERIES_SUN) {                 /* hand-keyed ladder, holds */
        int idx = sun_idx(frame);
        return idx < N ? idx : N - 1;
    }
    int e = frame - a->frame;                    /* ticks since activation */
    if (a->repeats == 0) {                        /* play once, then hold */
        if (e < N) return e;
        int hold = (s == INTRO_SERIES_GUY && N > 5) ? N - 5 : N - 1;
        return hold;
    }
    /* repeats>0: play `repeats` cycles, then leave the screen */
    long total = (long)N * a->repeats;
    if (e >= total) return -1;
    return e % N;
}

/* blit a sheet frame at its stored (x,y) screen anchor (bottom-center
 * registration), clipped to the play window. */
static void blit_anchored(const ss_sheet_t *sh, int idx, int cy1)
{
    if (idx < 0 || idx >= sh->nframes) return;
    const ss_frame_t *f = &sh->frames[idx];
    int tlx = f->x - (int)f->w / 2;
    int tly = f->y - (int)f->h;
    ss_blit_clip(sh, idx, tlx, tly, 0, 0, VID_W - 1, cy1);
}

void intro_render_frame(int frame, const intro_credit_t *creds, int nc,
                        const intro_anim_t *anims, int na)
{
    draw_backdrop(frame);
    /* event-triggered animation sprites (scene-fixed screen anchors). */
    for (int i = 0; i < na; i++) {
        int s = anims[i].series;
        if (s < 0 || s >= 10 || !g_anim_ok[s]) continue;
        int idx = anim_frame_index(&anims[i], frame);
        if (idx >= 0)
            blit_anchored(&g_anim[s], idx, INTRO_PLAY_H - 1);
    }
    /* credit cards active in their [start,end] window. */
    for (int i = 0; i < nc; i++) {
        if (frame < creds[i].start || frame > creds[i].end) continue;
        int s = creds[i].series;
        if (s < 0 || s >= 3 || !g_cred_ok[s]) continue;
        int spr = creds[i].sprite;
        if (spr < 0 || spr >= g_cred[s].nframes) spr = 0;
        blit_anchored(&g_cred[s], spr, INTRO_PLAY_H - 1);
    }
}

void intro_render_message(const char *msg)
{
    /* the @MESSAGES "Loading Game..." card; drawn via the shell font if present. */
    extern ff_font_t *viceroy_font(void);
    ff_font_t *fnt = viceroy_font();
    draw_backdrop(intro_end_frame());
    if (fnt && msg && msg[0]) {
        int w = ff_text_width(fnt, msg, 1);
        fnt->colors[1] = fnt->colors[2] = fnt->colors[3] = 15;
        ff_draw(fnt, msg, (VID_W - w) / 2, VID_H - 24, 1);
    }
}

void intro_render_close(void)
{
    if (g_have_bg)     { pik_free(&g_bg);     g_have_bg = 0; }
    if (g_have_border) { pik_free(&g_border); g_have_border = 0; }
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
