/* ============================================================================
 * font.c -- MADS .FF bitmap-font loader + Mode-13h text renderer
 * ----------------------------------------------------------------------------
 * COLONIZE's fonts (FONTSMAL/FONTINTR/FONTKING/...) are MADSPACK files with a
 * single item:
 *
 *   maxHeight:u8 | maxWidth:u8 | charWidths[127] (chars 1..127) | pad:u8 |
 *   charOffs[127]:u16le (absolute; bias = 2+128+256) | pad:u16 | glyph data
 *
 *   glyph = maxHeight rows x bpp bytes, bpp by width (>12:4, >8:3, >4:2, :1);
 *   each byte holds 4 pixels, 2 bits each, MSB first; value 0 = transparent,
 *   1..3 index the caller's 4-entry color table.
 *
 * Format recovered via the ScummVM MADS engine's reader; fresh C
 * implementation drawing straight into the platform framebuffer.
 * ============================================================================ */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "platform.h"

static int ff_bpp(int w) { return w > 12 ? 4 : w > 8 ? 3 : w > 4 ? 2 : 1; }

int ff_load(const char *path, ff_font_t *f)
{
    memset(f, 0, sizeof *f);
    uint8_t *items[2] = { 0 };
    uint32_t sizes[2] = { 0 };
    if (madspack_load(path, items, sizes, 2) < 1) return -1;

    const uint8_t *d = items[0];
    uint32_t       n = sizes[0];
    const uint32_t bias = 2 + 128 + 256;
    if (n < bias) { free(items[0]); return -1; }

    f->maxh = d[0];
    f->maxw = d[1];
    f->widths[0] = 0;
    memcpy(f->widths + 1, d + 2, 127);            /* char data shifted by 1 */
    f->offs[0] = 0;
    for (int i = 1; i < 128; i++) {
        uint16_t o = (uint16_t)(d[2 + 128 + (i-1)*2] | (d[2 + 128 + (i-1)*2 + 1] << 8));
        f->offs[i] = (uint16_t)(o - bias);
    }
    f->datasize = n - bias;
    f->data = malloc(f->datasize);
    memcpy(f->data, d + bias, f->datasize);
    free(items[0]);

    f->colors[0] = 0; f->colors[1] = 0;           /* caller sets real colors */
    f->colors[2] = 0; f->colors[3] = 0;
    return 0;
}

void ff_free(ff_font_t *f) { free(f->data); f->data = 0; }

int ff_text_width(const ff_font_t *f, const char *s, int spacew)
{
    int w = 0;
    for (; *s; s++) w += f->widths[*s & 0x7F] + spacew;
    return w > 0 ? w - spacew : 0;
}

void ff_draw(const ff_font_t *f, const char *s, int x, int y, int spacew)
{
    uint8_t *fb = vid_framebuffer();
    for (; *s; s++) {
        int c = *s & 0x7F;
        int cw = f->widths[c];
        if (cw > 0) {
            int bpp = ff_bpp(cw);
            const uint8_t *g = f->data + f->offs[c];
            for (int row = 0; row < f->maxh; row++) {
                int py = y + row;
                if (py < 0 || py >= VID_H) { g += bpp; continue; }
                int px = x;
                for (int b = 0; b < bpp; b++, g++) {
                    uint8_t v = *g;
                    for (int k = 6; k >= 0; k -= 2, px++) {
                        int ci = (v >> k) & 3;
                        if (ci && px >= 0 && px < VID_W && px - x < cw)
                            fb[py * VID_W + px] = f->colors[ci];
                    }
                }
            }
        }
        x += cw + spacew;
    }
}
