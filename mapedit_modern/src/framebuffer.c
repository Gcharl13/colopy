/*
 * framebuffer.c — software RGBA framebuffer (see framebuffer.h).
 */
#include "framebuffer.h"
#include "font8x8.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

fb *fb_create(int w, int h)
{
    if (w <= 0 || h <= 0)
        return NULL;
    fb *f = malloc(sizeof *f);
    if (!f)
        return NULL;
    f->w = w;
    f->h = h;
    f->px = malloc((size_t)w * h * sizeof(uint32_t));
    if (!f->px) { free(f); return NULL; }
    return f;
}

void fb_free(fb *f)
{
    if (!f)
        return;
    free(f->px);
    free(f);
}

void fb_clear(fb *f, uint32_t c)
{
    size_t n = (size_t)f->w * f->h;
    for (size_t i = 0; i < n; i++)
        f->px[i] = c;
}

void fb_set(fb *f, int x, int y, uint32_t c)
{
    if (x < 0 || y < 0 || x >= f->w || y >= f->h)
        return;
    f->px[(size_t)y * f->w + x] = c;
}

void fb_fill_rect(fb *f, int x, int y, int w, int h, uint32_t c)
{
    if (w <= 0 || h <= 0)
        return;
    int x0 = x < 0 ? 0 : x, y0 = y < 0 ? 0 : y;
    int x1 = x + w, y1 = y + h;
    if (x1 > f->w) x1 = f->w;
    if (y1 > f->h) y1 = f->h;
    for (int yy = y0; yy < y1; yy++) {
        uint32_t *row = &f->px[(size_t)yy * f->w];
        for (int xx = x0; xx < x1; xx++)
            row[xx] = c;
    }
}

void fb_hline(fb *f, int x, int y, int w, uint32_t c) { fb_fill_rect(f, x, y, w, 1, c); }
void fb_vline(fb *f, int x, int y, int h, uint32_t c) { fb_fill_rect(f, x, y, 1, h, c); }

void fb_rect(fb *f, int x, int y, int w, int h, uint32_t c)
{
    fb_hline(f, x, y, w, c);
    fb_hline(f, x, y + h - 1, w, c);
    fb_vline(f, x, y, h, c);
    fb_vline(f, x + w - 1, y, h, c);
}

static void draw_glyph(fb *f, int x, int y, unsigned char ch, uint32_t fg, int scale)
{
    if (ch < FONT_FIRST || ch > FONT_LAST)
        ch = '?';
    const uint8_t *g = FONT8X8[ch - FONT_FIRST];
    for (int row = 0; row < 8; row++) {
        uint8_t bits = g[row];
        for (int col = 0; col < 8; col++) {
            if (bits & (1 << col))
                fb_fill_rect(f, x + col * scale, y + row * scale, scale, scale, fg);
        }
    }
}

int fb_text(fb *f, int x, int y, const char *s, uint32_t fg, int scale)
{
    if (scale < 1) scale = 1;
    int cx = x;
    for (const unsigned char *p = (const unsigned char *)s; *p; p++) {
        if (*p == '\n') { cx = x; y += 8 * scale; continue; }
        draw_glyph(f, cx, y, *p, fg, scale);
        cx += 8 * scale;
    }
    return cx;
}

int fb_text_w(const char *s, int scale)
{
    if (scale < 1) scale = 1;
    int n = 0, max = 0;
    for (const char *p = s; *p; p++) {
        if (*p == '\n') { if (n > max) max = n; n = 0; }
        else n++;
    }
    if (n > max) max = n;
    return max * 8 * scale;
}

int fb_save_bmp(const fb *f, const char *path)
{
    FILE *fp = fopen(path, "wb");
    if (!fp)
        return -1;

    int row_bytes = f->w * 3;
    int pad = (4 - (row_bytes % 4)) % 4;
    int img_size = (row_bytes + pad) * f->h;
    int file_size = 54 + img_size;

    uint8_t hdr[54] = {0};
    hdr[0] = 'B'; hdr[1] = 'M';
    hdr[2] = (uint8_t)file_size; hdr[3] = (uint8_t)(file_size >> 8);
    hdr[4] = (uint8_t)(file_size >> 16); hdr[5] = (uint8_t)(file_size >> 24);
    hdr[10] = 54;                         /* pixel data offset */
    hdr[14] = 40;                         /* DIB header size */
    hdr[18] = (uint8_t)f->w; hdr[19] = (uint8_t)(f->w >> 8);
    hdr[20] = (uint8_t)(f->w >> 16); hdr[21] = (uint8_t)(f->w >> 24);
    hdr[22] = (uint8_t)f->h; hdr[23] = (uint8_t)(f->h >> 8);
    hdr[24] = (uint8_t)(f->h >> 16); hdr[25] = (uint8_t)(f->h >> 24);
    hdr[26] = 1;                          /* planes */
    hdr[28] = 24;                         /* bpp */
    fwrite(hdr, 1, 54, fp);

    uint8_t *rowbuf = calloc((size_t)row_bytes + pad, 1);
    for (int y = f->h - 1; y >= 0; y--) {     /* BMP is bottom-up */
        const uint32_t *src = &f->px[(size_t)y * f->w];
        for (int x = 0; x < f->w; x++) {
            uint32_t c = src[x];
            rowbuf[x * 3 + 0] = (uint8_t)(c);          /* B */
            rowbuf[x * 3 + 1] = (uint8_t)(c >> 8);     /* G */
            rowbuf[x * 3 + 2] = (uint8_t)(c >> 16);    /* R */
        }
        fwrite(rowbuf, 1, (size_t)row_bytes + pad, fp);
    }
    free(rowbuf);
    fclose(fp);
    return 0;
}

/* ---- minimal PNG writer (RGB8, stored DEFLATE) ---- */

static uint32_t crc32_buf(const uint8_t *p, size_t n, uint32_t crc)
{
    crc = ~crc;
    for (size_t i = 0; i < n; i++) {
        crc ^= p[i];
        for (int k = 0; k < 8; k++)
            crc = (crc >> 1) ^ (0xEDB88320u & (uint32_t)(-(int)(crc & 1)));
    }
    return ~crc;
}

static uint32_t adler32_buf(const uint8_t *p, size_t n)
{
    uint32_t a = 1, b = 0;
    for (size_t i = 0; i < n; i++) {
        a = (a + p[i]) % 65521;
        b = (b + a) % 65521;
    }
    return (b << 16) | a;
}

static void put_be32(FILE *fp, uint32_t v)
{
    uint8_t b[4] = { (uint8_t)(v >> 24), (uint8_t)(v >> 16), (uint8_t)(v >> 8), (uint8_t)v };
    fwrite(b, 1, 4, fp);
}

static void png_chunk(FILE *fp, const char *type, const uint8_t *data, size_t len)
{
    put_be32(fp, (uint32_t)len);
    fwrite(type, 1, 4, fp);
    fwrite(data, 1, len, fp);
    uint8_t *tmp = malloc(4 + len);
    memcpy(tmp, type, 4);
    if (len) memcpy(tmp + 4, data, len);
    put_be32(fp, crc32_buf(tmp, 4 + len, 0));   /* CRC over type + data */
    free(tmp);
}

int fb_save_png(const fb *f, const char *path)
{
    FILE *fp = fopen(path, "wb");
    if (!fp)
        return -1;

    static const uint8_t sig[8] = { 0x89, 'P', 'N', 'G', 0x0D, 0x0A, 0x1A, 0x0A };
    fwrite(sig, 1, 8, fp);

    uint8_t ihdr[13];
    ihdr[0] = (uint8_t)(f->w >> 24); ihdr[1] = (uint8_t)(f->w >> 16);
    ihdr[2] = (uint8_t)(f->w >> 8);  ihdr[3] = (uint8_t)f->w;
    ihdr[4] = (uint8_t)(f->h >> 24); ihdr[5] = (uint8_t)(f->h >> 16);
    ihdr[6] = (uint8_t)(f->h >> 8);  ihdr[7] = (uint8_t)f->h;
    ihdr[8] = 8;    /* bit depth */
    ihdr[9] = 2;    /* colour type RGB */
    ihdr[10] = 0; ihdr[11] = 0; ihdr[12] = 0;
    png_chunk(fp, "IHDR", ihdr, sizeof ihdr);

    /* raw image: per-row filter byte (0) + RGB triples */
    size_t raw_len = (size_t)f->h * (1 + (size_t)f->w * 3);
    uint8_t *raw = malloc(raw_len);
    size_t o = 0;
    for (int y = 0; y < f->h; y++) {
        raw[o++] = 0;
        const uint32_t *row = &f->px[(size_t)y * f->w];
        for (int x = 0; x < f->w; x++) {
            uint32_t c = row[x];
            raw[o++] = (uint8_t)(c >> 16);
            raw[o++] = (uint8_t)(c >> 8);
            raw[o++] = (uint8_t)c;
        }
    }

    /* zlib stream: 2-byte header + stored DEFLATE blocks + adler32 */
    size_t maxblk = 65535;
    size_t nblocks = (raw_len + maxblk - 1) / maxblk;
    if (nblocks == 0) nblocks = 1;
    size_t zlen = 2 + nblocks * 5 + raw_len + 4;
    uint8_t *z = malloc(zlen);
    size_t zo = 0;
    z[zo++] = 0x78; z[zo++] = 0x01;             /* CMF/FLG */
    size_t left = raw_len, ro = 0;
    do {
        size_t blk = left < maxblk ? left : maxblk;
        z[zo++] = (left - blk == 0) ? 1 : 0;    /* BFINAL on last block */
        z[zo++] = (uint8_t)blk; z[zo++] = (uint8_t)(blk >> 8);
        uint16_t nlen = (uint16_t)~(uint16_t)blk;
        z[zo++] = (uint8_t)nlen; z[zo++] = (uint8_t)(nlen >> 8);
        memcpy(z + zo, raw + ro, blk);
        zo += blk; ro += blk; left -= blk;
    } while (left > 0);
    uint32_t ad = adler32_buf(raw, raw_len);
    z[zo++] = (uint8_t)(ad >> 24); z[zo++] = (uint8_t)(ad >> 16);
    z[zo++] = (uint8_t)(ad >> 8);  z[zo++] = (uint8_t)ad;

    png_chunk(fp, "IDAT", z, zo);
    png_chunk(fp, "IEND", NULL, 0);

    free(raw);
    free(z);
    fclose(fp);
    return 0;
}
