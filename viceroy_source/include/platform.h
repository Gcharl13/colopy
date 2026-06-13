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
const uint8_t *vid_get_palette(void);      /* live DAC, 256 x 8-bit RGB     */
void vid_set_palette(const uint8_t *rgb768);  /* 256 x 8-bit RGB            */
void vid_set_palette_range(const uint8_t *rgb768, int first, int count);
                                           /* DAC window (0x0C2E:0x0022)    */
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

/* raw MADSPACK container access (shared by .PIK/.FF loaders) */
int  madspack_load(const char *path, uint8_t **items, uint32_t *sizes, int max);

/* ---- .FF bitmap fonts (see font.c) --------------------------------------- */
typedef struct {
    uint8_t   maxh, maxw;
    uint8_t   widths[128];
    uint16_t  offs[128];
    uint8_t  *data;
    uint32_t  datasize;
    uint8_t   colors[4];    /* [0] unused (transparent); [1..3] palette idx */
} ff_font_t;

int  ff_load(const char *path, ff_font_t *f);
void ff_free(ff_font_t *f);
int  ff_text_width(const ff_font_t *f, const char *s, int spacew);
void ff_draw(const ff_font_t *f, const char *s, int x, int y, int spacew);

/* ---- .SS sprite sheets (MS_SPRITE RLE; see ss.c) -------------------------- */
#define SS_MAX_FRAMES   192
#define SS_TRANSPARENT  0xFD     /* the codec's own transparent marker */

typedef struct {
    int16_t  x, y;               /* placement hint from the sheet */
    uint16_t w, h;
    uint8_t *pixels;             /* w*h, SS_TRANSPARENT = skip */
} ss_frame_t;

typedef struct {
    int        nframes;
    ss_frame_t frames[SS_MAX_FRAMES];
    uint8_t    pal6[768];        /* sheet's own 6-bit VGA palette */
    int        has_pal;
} ss_sheet_t;

int  ss_load(const char *path, ss_sheet_t *s);
void ss_free(ss_sheet_t *s);
void ss_blit(const ss_sheet_t *s, int frame, int x, int y);
void ss_blit_remap(const ss_sheet_t *s, int frame, int x, int y);  /* remap to live palette */
void ss_blit_remap_clip(const ss_sheet_t *s, int frame, int x, int y,
                        int cx0, int cy0, int cx1, int cy1);
void ss_blit_clip(const ss_sheet_t *s, int frame, int x, int y,
                  int cx0, int cy0, int cx1, int cy1);

#endif /* VICEROY_PLATFORM_H */
