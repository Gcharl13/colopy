/*
 * ff.h — MADS ".FF" bitmap font decoder (FONTTINY.FF, FONTINTR.FF).
 *
 * MADSPACK 2.0 container (FAB-compressed), then:
 *   byte 0      max height
 *   byte 1      max width
 *   bytes 2..   per-char width table (char ch width at byte 1+ch, ch 1..127)
 *   off 130..   per-char data offset u16[] (char ch at 130+(ch-1)*2, absolute)
 *   glyph data  2 bits/pixel, getBpp(width) bytes per row, rows top-to-bottom
 * Pixel value 0 = transparent; 1..3 = foreground shades.
 */
#ifndef MPEDIT_FF_H
#define MPEDIT_FF_H

#include "framebuffer.h"
#include <stdint.h>
#include <stddef.h>

typedef struct {
    int      max_h, max_w;
    uint8_t *data;     /* whole decoded section (offsets index into this) */
    size_t   len;
} ff_font;

ff_font *ff_load(const char *path);
void     ff_free(ff_font *f);

int  ff_char_width(const ff_font *f, int ch);
int  ff_text_width(const ff_font *f, const char *s);   /* with 1px inter-char */

/* Draw text at (x, top-y) in colour (0x00RRGGBB), scaled by `scale` (nearest).
 * Returns the x advance end. */
int  ff_draw(fb *fb, const ff_font *f, int x, int y, const char *s,
             uint32_t color, int scale);

#endif /* MPEDIT_FF_H */
