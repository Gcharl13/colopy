/* ============================================================================
 * platform.h -- modern platform layer (video / input / asset decode)
 * ----------------------------------------------------------------------------
 * Milestone-3 SDL swap layer.  Emulates the machine the game was written for:
 * VGA Mode 13h -- a 320x200 byte-per-pixel framebuffer + 256-entry palette --
 * presented through SDL2 (scaled), or headless (PPM screenshot dump) when no
 * display is available.  The RULES layer never touches this directly; only
 * the reconstruction-layer shell (main_modern.c) does.
 * ============================================================================ */
#ifndef VICEROY_PLATFORM_H
#define VICEROY_PLATFORM_H

#include <stdint.h>

/* ---- Mode 13h screen ----------------------------------------------------- */
#define VID_W  320
#define VID_H  200

int  vid_init(const char *title);          /* 0 = SDL window, 1 = headless  */
void vid_shutdown(void);
uint8_t *vid_framebuffer(void);            /* 64000-byte 8bpp buffer        */
void vid_set_palette(const uint8_t *rgb768);  /* 256 x 8-bit RGB            */
void vid_present(void);                    /* framebuffer -> screen         */
int  vid_screenshot_ppm(const char *path); /* current frame -> P6 PPM       */

/* input poll: returns 0 if none, else a key code (SDLK_* subset / ASCII);
 * VID_QUIT_REQUESTED when the window is closed */
#define VID_QUIT_REQUESTED  (-2)
int  vid_poll_key(void);
void vid_delay_ms(int ms);

/* ---- .PIK backdrops (MADSPACK 2.0 + FAB; see pik.c) ---------------------- */
typedef struct {
    int      w, h;
    uint8_t *pixels;        /* w*h 8bpp, palette indices */
    uint8_t  pal[768];      /* 8-bit RGB (converted from 6-bit VGA) */
    int      has_pal;
} pik_image_t;

int  pik_load(const char *path, pik_image_t *img);
void pik_free(pik_image_t *img);

#endif /* VICEROY_PLATFORM_H */
