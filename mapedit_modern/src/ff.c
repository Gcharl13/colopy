/*
 * ff.c — MADS ".FF" bitmap font decoder (see ff.h). Verified against
 * FONTTINY.FF: 'A' renders correctly with offset = LE16(130+(ch-1)*2).
 */
#include "ff.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint16_t u16(const uint8_t *p) { return (uint16_t)(p[0] | (p[1] << 8)); }
static uint32_t u32(const uint8_t *p) { return (uint32_t)(p[0] | (p[1] << 8) | (p[2] << 16) | ((uint32_t)p[3] << 24)); }

/* FAB decompress (same codec as ss.c). src points at "FAB". */
static int fab_decompress(const uint8_t *src, size_t srclen, uint8_t *dest, size_t destsize)
{
    if (srclen < 6 || memcmp(src, "FAB", 3) != 0)
        return -1;
    int shiftVal = src[3];
    int copyOfsShift = 16 - shiftVal;
    uint8_t copyOfsMask = (uint8_t)(0xFF << (shiftVal - 8));
    uint8_t copyLenMask = (uint8_t)((1 << copyOfsShift) - 1);
    size_t p = 6, dp = 0;
    int bitsLeft = 16;
    uint32_t bitBuffer = (uint32_t)src[4] | ((uint32_t)src[5] << 8);
    #define GETBIT(bit) do {                                              \
        bitsLeft--;                                                        \
        if (bitsLeft == 0) {                                              \
            if (p + 1 >= srclen) return -2;                              \
            uint32_t w = (uint32_t)src[p] | ((uint32_t)src[p + 1] << 8);  \
            bitBuffer = ((w << 1) | (bitBuffer & 1)) & 0x1FFFF;          \
            p += 2; bitsLeft = 16;                                       \
        }                                                                 \
        (bit) = bitBuffer & 1; bitBuffer >>= 1;                          \
    } while (0)
    for (;;) {
        uint32_t bit;
        GETBIT(bit);
        if (bit == 0) {
            uint32_t copyLen; int32_t copyOfs; uint32_t b2;
            GETBIT(b2);
            if (b2 == 0) {
                uint32_t a, b; GETBIT(a); GETBIT(b);
                copyLen = ((a << 1) | b) + 2;
                if (p >= srclen) return -2;
                copyOfs = (int32_t)(src[p] | 0xFFFFFF00u); p++;
            } else {
                if (p + 1 >= srclen) return -2;
                uint8_t b0 = src[p], b1 = src[p + 1];
                uint32_t ofs = (uint32_t)(((((b1 >> copyOfsShift) | copyOfsMask) << 8) | b0));
                copyLen = (uint32_t)(b1 & copyLenMask); p += 2;
                if (copyLen == 0) {
                    if (p >= srclen) return -2;
                    copyLen = src[p++];
                    if (copyLen == 0) break;
                    else if (copyLen == 1) continue;
                    else copyLen++;
                } else copyLen += 2;
                copyOfs = (int32_t)(ofs | 0xFFFF0000u);
            }
            while (copyLen-- > 0) {
                if (dp >= destsize) return -3;
                size_t srcpos = dp + (size_t)(int64_t)copyOfs;
                if (srcpos >= dp) return -4;
                dest[dp] = dest[srcpos]; dp++;
            }
        } else {
            if (p >= srclen || dp >= destsize) return -2;
            dest[dp++] = src[p++];
        }
    }
    #undef GETBIT
    return (dp == destsize) ? 0 : -5;
}

ff_font *ff_load(const char *path)
{
    FILE *fp = fopen(path, "rb");
    if (!fp) return NULL;
    fseek(fp, 0, SEEK_END); long sz = ftell(fp); rewind(fp);
    if (sz < 16) { fclose(fp); return NULL; }
    uint8_t *buf = malloc((size_t)sz);
    if (!buf || fread(buf, 1, (size_t)sz, fp) != (size_t)sz) { free(buf); fclose(fp); return NULL; }
    fclose(fp);
    if (memcmp(buf, "MADSPACK 2.0", 12) != 0) { free(buf); return NULL; }

    uint32_t usize = u32(buf + 18);
    /* first FAB after the directory */
    size_t fab = 16;
    while (fab + 3 <= (size_t)sz && memcmp(buf + fab, "FAB", 3) != 0) fab++;
    uint8_t *sec = malloc(usize ? usize : 1);
    if (!sec || fab + 3 > (size_t)sz ||
        fab_decompress(buf + fab, (size_t)sz - fab, sec, usize) != 0) {
        free(buf); free(sec); return NULL;
    }
    free(buf);

    ff_font *f = calloc(1, sizeof *f);
    f->max_h = sec[0];
    f->max_w = sec[1];
    f->data = sec;
    f->len = usize;
    return f;
}

void ff_free(ff_font *f)
{
    if (!f) return;
    free(f->data);
    free(f);
}

int ff_char_width(const ff_font *f, int ch)
{
    if (ch < 1 || ch > 127) return (ch == ' ') ? 2 : 0;
    return f->data[1 + ch];     /* width table: char ch at byte 1+ch */
}

int ff_text_width(const ff_font *f, const char *s)
{
    int w = 0;
    for (const unsigned char *p = (const unsigned char *)s; *p; p++) {
        int cw = ff_char_width(f, *p);
        w += cw ? cw : 2;     /* glyph width already includes trailing spacing */
    }
    return w;
}

static int ff_bpp(int w)
{
    return w > 12 ? 4 : w > 8 ? 3 : w > 4 ? 2 : 1;
}

int ff_draw(fb *dst, const ff_font *f, int x, int y, const char *s,
            uint32_t color, int scale)
{
    if (scale < 1) scale = 1;
    int cx = x;
    for (const unsigned char *p = (const unsigned char *)s; *p; p++) {
        int ch = *p;
        int w = ff_char_width(f, ch);
        if (w == 0) { cx += 2 * scale; continue; }          /* space-ish */
        uint32_t off = u16(f->data + 130 + (ch - 1) * 2);  /* absolute */
        int bpp = ff_bpp(w);
        for (int r = 0; r < f->max_h; r++) {
            const uint8_t *row = f->data + off + (size_t)r * bpp;
            for (int px = 0; px < w; px++) {
                int byi = px / 4;
                int shift = (3 - (px % 4)) * 2;
                int v = ((size_t)(off + r * bpp + byi) < f->len)
                          ? (row[byi] >> shift) & 3 : 0;
                if (v)
                    fb_fill_rect(dst, cx + px * scale, y + r * scale, scale, scale, color);
            }
        }
        cx += w * scale;   /* glyph width includes trailing spacing */
    }
    return cx;
}
