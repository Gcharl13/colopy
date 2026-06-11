/* ============================================================================
 * video_sdl.c -- VGA Mode 13h emulation over SDL2 (with headless fallback)
 * ----------------------------------------------------------------------------
 * The original renders into A000:0000 -- 320x200, one byte per pixel, through
 * a 256-entry DAC palette.  This layer reproduces exactly that surface and
 * presents it scaled 3x.  When SDL can't open a display (CI/container), it
 * falls back to headless mode: the framebuffer/palette still work and frames
 * can be dumped as PPM screenshots for verification.
 * ============================================================================ */
#include <stdio.h>
#include <string.h>

#include "platform.h"

#ifdef VICEROY_HAVE_SDL2
#  include <SDL.h>
#endif

#define SCALE 3

static uint8_t fb[VID_W * VID_H];
static uint8_t pal[768];
static int     headless = 1;

#ifdef VICEROY_HAVE_SDL2
static SDL_Window   *win;
static SDL_Renderer *ren;
static SDL_Texture  *tex;
static uint32_t      argb[VID_W * VID_H];
#endif

int vid_init(const char *title)
{
#ifdef VICEROY_HAVE_SDL2
    if (SDL_Init(SDL_INIT_VIDEO) == 0) {
        /* dummy/offscreen drivers "succeed" with no real display -- treat as
         * headless or the input loop would spin forever */
        const char *drv = SDL_GetCurrentVideoDriver();
        if (drv && (strcmp(drv, "dummy") == 0 || strcmp(drv, "offscreen") == 0)) {
            SDL_Quit();
            goto no_display;
        }
        win = SDL_CreateWindow(title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
                               VID_W * SCALE, VID_H * SCALE, 0);
        if (win) {
            ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_PRESENTVSYNC);
            if (!ren) ren = SDL_CreateRenderer(win, -1, 0);
            if (ren) {
                tex = SDL_CreateTexture(ren, SDL_PIXELFORMAT_ARGB8888,
                                        SDL_TEXTUREACCESS_STREAMING, VID_W, VID_H);
                if (tex) headless = 0;
            }
        }
        if (headless) SDL_Quit();
    }
no_display:
#else
    (void)title;
#endif
    memset(fb, 0, sizeof fb);
    memset(pal, 0, sizeof pal);
    if (headless)
        fprintf(stderr, "video: headless mode (no display) -- PPM dumps only\n");
    return headless;
}

void vid_shutdown(void)
{
#ifdef VICEROY_HAVE_SDL2
    if (!headless) {
        SDL_DestroyTexture(tex);
        SDL_DestroyRenderer(ren);
        SDL_DestroyWindow(win);
        SDL_Quit();
    }
#endif
}

uint8_t *vid_framebuffer(void)               { return fb; }

void vid_set_palette(const uint8_t *rgb768)  { memcpy(pal, rgb768, 768); }

void vid_present(void)
{
#ifdef VICEROY_HAVE_SDL2
    if (headless) return;
    for (int i = 0; i < VID_W * VID_H; i++) {
        const uint8_t *c = pal + fb[i] * 3;
        argb[i] = 0xFF000000u | ((uint32_t)c[0] << 16) | ((uint32_t)c[1] << 8) | c[2];
    }
    SDL_UpdateTexture(tex, NULL, argb, VID_W * 4);
    SDL_RenderClear(ren);
    SDL_RenderCopy(ren, tex, NULL, NULL);
    SDL_RenderPresent(ren);
#endif
}

int vid_screenshot_ppm(const char *path)
{
    FILE *f = fopen(path, "wb");
    if (!f) return -1;
    fprintf(f, "P6\n%d %d\n255\n", VID_W, VID_H);
    for (int i = 0; i < VID_W * VID_H; i++)
        fwrite(pal + fb[i] * 3, 1, 3, f);
    fclose(f);
    return 0;
}

int vid_poll_key(void)
{
    /* determinism rig (ROUTE_B_PLAN 0.1): a loaded script feeds input
     * ahead of (and headless, instead of) SDL -- byte-replayable runs */
    {
        extern int script_input_active(void);
        extern int script_input_poll(int headless);
        if (script_input_active())
            return script_input_poll(headless);
    }
#ifdef VICEROY_HAVE_SDL2
    if (!headless) {
        SDL_Event ev;
        while (SDL_PollEvent(&ev)) {
            if (ev.type == SDL_QUIT) return VID_QUIT_REQUESTED;
            if (ev.type == SDL_KEYDOWN) return ev.key.keysym.sym;
        }
    }
#endif
    return 0;
}

void vid_delay_ms(int ms)
{
#ifdef VICEROY_HAVE_SDL2
    if (!headless) { SDL_Delay((Uint32)ms); return; }
#endif
    (void)ms;
}
