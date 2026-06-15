/*
 * framebuffer.h — a tiny software RGBA framebuffer + drawing primitives.
 *
 * The whole editor UI is drawn into one of these buffers. That keeps the
 * rendering free of any windowing dependency: it can be screenshotted to a BMP
 * for headless testing, or handed to SDL2 as a texture for the live editor.
 *
 * Colours are 0x00RRGGBB packed in a uint32_t.
 */
#ifndef MPEDIT_FRAMEBUFFER_H
#define MPEDIT_FRAMEBUFFER_H

#include <stdint.h>

typedef struct {
    int       w, h;
    uint32_t *px;        /* w*h, row-major */
} fb;

#define RGB(r, g, b) (((uint32_t)(r) << 16) | ((uint32_t)(g) << 8) | (uint32_t)(b))

fb  *fb_create(int w, int h);
void fb_free(fb *f);

void fb_clear(fb *f, uint32_t c);
void fb_set(fb *f, int x, int y, uint32_t c);
void fb_fill_rect(fb *f, int x, int y, int w, int h, uint32_t c);
void fb_rect(fb *f, int x, int y, int w, int h, uint32_t c);   /* 1px outline */
void fb_hline(fb *f, int x, int y, int w, uint32_t c);
void fb_vline(fb *f, int x, int y, int h, uint32_t c);

/* Draw an 8x8-font string at scale (>=1). Returns x advance end position. */
int  fb_text(fb *f, int x, int y, const char *s, uint32_t fg, int scale);
int  fb_text_w(const char *s, int scale);   /* pixel width of a string */

/* Headless screenshot export. Both return 0 on success. PNG uses a built-in
 * stored-DEFLATE encoder (no zlib dependency). */
int  fb_save_bmp(const fb *f, const char *path);
int  fb_save_png(const fb *f, const char *path);

#endif /* MPEDIT_FRAMEBUFFER_H */
