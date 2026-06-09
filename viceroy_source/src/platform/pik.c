/* ============================================================================
 * pik.c -- MADSPACK 2.0 container + FAB decompressor (.PIK backdrop loader)
 * ----------------------------------------------------------------------------
 * Modern platform layer (milestone 3).  COLONIZE's .PIK backdrops are MADS
 * engine pack files (MicroProse shared toolkit -- see docs/ENGINE.md):
 *
 *   container: "MADSPACK 2.0\x1A" pad to 14 | count:u16le | 0xA0-byte item
 *     directory of 10-byte entries { type:u8 (0=stored, 1=FAB), priority:u8,
 *     size:u32le, csize:u32le } | item payloads back-to-back.
 *
 *   FAB stream: "FAB" | shift:u8 (10..13) | bitbuf0:u16le | LZ77 bitstream.
 *     bit 1            -> literal byte
 *     bit 0, bit 0     -> 2-bit extra length (2..5), 1-byte offset (-1..-256)
 *     bit 0, bit 1     -> 2-byte {offset | length}; len==0 -> extension byte
 *                         (0 = end of stream, 1 = continue, n -> length n+1)
 *
 *   .PIK item layout (verified against the COLONIZE files):
 *     item 0: 8-byte header { height:u16le, width:u16le, ... }
 *     item 1: width*height 8bpp pixels
 *     item 2: 768-byte VGA palette (256 x 6-bit RGB)
 *
 * Format facts recovered via the ScummVM MADS engine's reader; this is a
 * fresh C implementation against the COLONIZE data files.
 * ============================================================================ */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "platform.h"

#define RD16(p)  ((uint16_t)((p)[0] | ((p)[1] << 8)))
#define RD32(p)  ((uint32_t)((p)[0] | ((p)[1] << 8) | ((p)[2] << 16) | ((uint32_t)(p)[3] << 24)))

/* ---- FAB LZ77 ------------------------------------------------------------ */
typedef struct {
    const uint8_t *src, *p;
    long           size;
    uint32_t       bitbuf;   /* 17 bits live: (new word << 1) | carry */
    int            bits;
} fab_t;

static int fab_bit(fab_t *f)
{
    if (--f->bits == 0) {
        if (f->p - f->src >= f->size) return -1;
        f->bitbuf = ((uint32_t)RD16(f->p) << 1) | (f->bitbuf & 1);
        f->p += 2;
        f->bits = 16;
    }
    int b = f->bitbuf & 1;
    f->bitbuf >>= 1;
    return b;
}

static int fab_decompress(const uint8_t *src, long srcsize,
                          uint8_t *dst, long dstsize)
{
    if (srcsize < 6 || memcmp(src, "FAB", 3) != 0) return -1;
    int shift = src[3];
    if (shift < 10 || shift > 13) return -1;
    int  ofs_shift = 16 - shift;
    int  ofs_mask  = (0xFF << (shift - 8)) & 0xFF;
    int  len_mask  = (1 << ofs_shift) - 1;

    fab_t f = { src, src + 6, srcsize, RD16(src + 4), 16 };
    long out = 0;

    for (;;) {
        int b = fab_bit(&f);
        if (b < 0) return -1;
        if (b) {                                   /* literal */
            if (out >= dstsize || f.p - src >= srcsize) return -1;
            dst[out++] = *f.p++;
            continue;
        }
        long clen, cofs;
        if ((b = fab_bit(&f)) < 0) return -1;
        if (b == 0) {                              /* short match */
            int b1 = fab_bit(&f), b0 = fab_bit(&f);
            if (b1 < 0 || b0 < 0) return -1;
            clen = ((b1 << 1) | b0) + 2;
            cofs = (long)*f.p++ - 256;
        } else {                                   /* long match */
            cofs = ((((f.p[1] >> ofs_shift) | ofs_mask) << 8) | f.p[0]) - 0x10000;
            clen = f.p[1] & len_mask;
            f.p += 2;
            if (clen == 0) {
                clen = *f.p++;
                if (clen == 0) break;              /* end of stream */
                if (clen == 1) continue;           /* no-op */
                clen++;
            } else {
                clen += 2;
            }
        }
        if (out + cofs < 0) return -1;
        while (clen-- > 0) {
            if (out >= dstsize) return -1;
            dst[out] = dst[out + cofs];
            out++;
        }
    }
    return out == dstsize ? 0 : -1;
}

/* ---- MADSPACK container (shared by .PIK and .FF loaders) ----------------- */
int madspack_load(const char *path, uint8_t **items, uint32_t *sizes, int max)
{
    FILE *fp = fopen(path, "rb");
    if (!fp) return -1;
    fseek(fp, 0, SEEK_END);
    long fsize = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    uint8_t *data = malloc(fsize);
    if (!data || fread(data, 1, fsize, fp) != (size_t)fsize) {
        free(data); fclose(fp); return -1;
    }
    fclose(fp);

    if (fsize < 16 + 0xA0 || memcmp(data, "MADSPACK", 8) != 0) {
        free(data); return -1;
    }
    int count = RD16(data + 14);
    const uint8_t *dir = data + 16;
    long off = 16 + 0xA0;
    if (count > max) count = max;

    for (int i = 0; i < count; i++) {
        int      type  = dir[i*10];
        uint32_t size  = RD32(dir + i*10 + 2);
        uint32_t csize = RD32(dir + i*10 + 6);
        items[i] = malloc(size);
        sizes[i] = size;
        int ok = (off + csize <= fsize) && items[i];
        if (ok) {
            if (type == 0)
                memcpy(items[i], data + off, size < csize ? size : csize);
            else
                ok = fab_decompress(data + off, csize, items[i], size) == 0;
        }
        off += csize;
        if (!ok) {
            for (int j = 0; j <= i; j++) free(items[j]);
            free(data); return -1;
        }
    }
    free(data);
    return count;
}

/* ---- .PIK backdrops ------------------------------------------------------ */
int pik_load(const char *path, pik_image_t *img)
{
    memset(img, 0, sizeof *img);

    uint8_t *items[8] = { 0 };
    uint32_t sizes[8] = { 0 };
    int count = madspack_load(path, items, sizes, 8);
    if (count < 2) return -1;

    /* item 0 = dims header, 1 = pixels, 2 = 6-bit VGA palette */
    if (count >= 2 && sizes[0] >= 4) {
        img->h = RD16(items[0]);
        img->w = RD16(items[0] + 2);
    }
    img->pixels = items[1];
    if ((uint32_t)img->w * img->h != sizes[1]) {   /* trust the payload size */
        if (img->w && sizes[1] % img->w == 0) img->h = sizes[1] / img->w;
    }
    if (count >= 3 && sizes[2] >= 768) {
        for (int i = 0; i < 256; i++) {            /* 6-bit -> 8-bit */
            img->pal[i*3+0] = (uint8_t)((items[2][i*3+0] << 2) | (items[2][i*3+0] >> 4));
            img->pal[i*3+1] = (uint8_t)((items[2][i*3+1] << 2) | (items[2][i*3+1] >> 4));
            img->pal[i*3+2] = (uint8_t)((items[2][i*3+2] << 2) | (items[2][i*3+2] >> 4));
        }
        img->has_pal = 1;
    }
    free(items[0]);
    if (count >= 3) free(items[2]);
    return 0;
}

void pik_free(pik_image_t *img)
{
    free(img->pixels);
    img->pixels = 0;
}
