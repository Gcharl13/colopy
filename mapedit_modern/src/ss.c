/*
 * ss.c — MADS ".SS" sprite-sheet decoder (see ss.h).
 *
 * Pipeline (ported verbatim from the Python that was validated against the
 * original assets):
 *   MADSPACK 2.0 directory -> FAB-decompress 4 sections -> parse the 16-byte
 *   frame records -> MS_SPRITE RLE-decode each frame -> apply the embedded
 *   256-colour VGA palette.
 */
#include "ss.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TRANS_INDEX 0xFD

static uint8_t *read_file(const char *path, size_t *len)
{
    FILE *f = fopen(path, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    rewind(f);
    if (sz < 0) { fclose(f); return NULL; }
    uint8_t *b = malloc((size_t)sz ? (size_t)sz : 1);
    if (b && fread(b, 1, (size_t)sz, f) != (size_t)sz) { free(b); b = NULL; }
    fclose(f);
    if (b) *len = (size_t)sz;
    return b;
}

static uint16_t u16(const uint8_t *p) { return (uint16_t)(p[0] | (p[1] << 8)); }
static uint32_t u32(const uint8_t *p) { return (uint32_t)(p[0] | (p[1] << 8) | (p[2] << 16) | ((uint32_t)p[3] << 24)); }

/* FAB decompress one section (src points at "FAB"). Caller gives dest buffer
 * of exactly destsize. Returns 0 on success. */
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
            uint32_t copyLen;
            int32_t copyOfs;
            uint32_t b2;
            GETBIT(b2);
            if (b2 == 0) {
                uint32_t a, b, c, d;
                GETBIT(a); GETBIT(b);
                (void)c; (void)d;
                copyLen = ((a << 1) | b) + 2;
                if (p >= srclen) return -2;
                copyOfs = (int32_t)(src[p] | 0xFFFFFF00u);
                p++;
            } else {
                if (p + 1 >= srclen) return -2;
                uint8_t b0 = src[p], b1 = src[p + 1];
                uint32_t ofs = (uint32_t)(((((b1 >> copyOfsShift) | copyOfsMask) << 8) | b0));
                copyLen = (uint32_t)(b1 & copyLenMask);
                p += 2;
                if (copyLen == 0) {
                    if (p >= srclen) return -2;
                    copyLen = src[p++];
                    if (copyLen == 0) break;
                    else if (copyLen == 1) continue;
                    else copyLen++;
                } else {
                    copyLen += 2;
                }
                copyOfs = (int32_t)(ofs | 0xFFFF0000u);
            }
            while (copyLen-- > 0) {
                if (dp >= destsize) return -3;
                size_t srcpos = dp + (size_t)(int64_t)copyOfs;  /* copyOfs negative */
                if (srcpos >= dp) return -4;
                dest[dp] = dest[srcpos];
                dp++;
            }
        } else {
            if (p >= srclen || dp >= destsize) return -2;
            dest[dp++] = src[p++];
        }
    }
    #undef GETBIT
    return (dp == destsize) ? 0 : -5;
}

/* MS_SPRITE RLE decode one frame into an index buffer (TRANS_INDEX for clear). */
static void decode_frame_indices(const uint8_t *data, size_t off, size_t size,
                                 int w, int h, uint8_t *out /* w*h */)
{
    memset(out, TRANS_INDEX, (size_t)w * h);
    const uint8_t *s = data + off;
    size_t i = 0, n = size;
    int x = 0, y = 0;

    #define PUT(v) do { if (y < h && x < w) out[y * w + x] = (v); x++; } while (0)

    while (i < n) {
        uint8_t cmd1 = s[i++];
        if (cmd1 == 0xFC) break;
        if (cmd1 == 0xFF) { y++; x = 0; continue; }
        if (cmd1 == 0xFD) {
            while (i < n) {
                uint8_t count = s[i++];
                if (count == 0xFF) break;
                if (i >= n) break;
                uint8_t pixel = s[i++];
                while (count--) PUT(pixel);
            }
            y++; x = 0;
        } else {
            while (i < n) {
                uint8_t cmd2 = s[i++];
                if (cmd2 == 0xFF) break;
                if (cmd2 == 0xFE) {
                    if (i + 1 >= n) break;
                    uint8_t count = s[i++];
                    uint8_t pixel = s[i++];
                    while (count--) PUT(pixel);
                } else {
                    PUT(cmd2);
                }
            }
            y++; x = 0;
        }
    }
    #undef PUT
}

ss_sheet *ss_load(const char *path)
{
    size_t len = 0;
    uint8_t *buf = read_file(path, &len);
    if (!buf) return NULL;
    if (len < 16 || memcmp(buf, "MADSPACK 2.0", 12) != 0) { free(buf); return NULL; }

    int count = u16(buf + 14);
    if (count != 4) { free(buf); return NULL; }   /* expect 4 sections */

    size_t o = 16;
    uint32_t usize[4], csize[4];
    for (int i = 0; i < 4; i++) {
        usize[i] = u32(buf + o + 2);
        csize[i] = u32(buf + o + 6);
        o += 10;
    }

    /* sections begin at the first "FAB" marker after the directory (skipping
     * the embedded expander stub), then chain by compressed size. */
    size_t fab = o;
    while (fab + 3 <= len && memcmp(buf + fab, "FAB", 3) != 0) fab++;

    uint8_t *sec[4] = {0};
    int ok = 1;
    size_t p = fab;
    for (int i = 0; i < 4 && ok; i++) {
        sec[i] = malloc(usize[i] ? usize[i] : 1);
        if (!sec[i] || p + csize[i] > len ||
            fab_decompress(buf + p, csize[i] + 8 <= len - p ? csize[i] + 8 : len - p,
                           sec[i], usize[i]) != 0) {
            ok = 0;
        }
        p += csize[i];
    }
    free(buf);
    if (!ok) { for (int i = 0; i < 4; i++) free(sec[i]); return NULL; }

    /* palette: 256 * RGB6 -> RGB8 */
    uint32_t pal[256];
    const uint8_t *pr = sec[2];
    for (int k = 0; k < 256; k++) {
        int r = pr[k * 3] * 255 / 63, g = pr[k * 3 + 1] * 255 / 63, b = pr[k * 3 + 2] * 255 / 63;
        pal[k] = ((uint32_t)0xFF << 24) | ((uint32_t)r << 16) | ((uint32_t)g << 8) | (uint32_t)b;
    }

    const uint8_t *ft = sec[1];
    /* usize[1] / 16 frames */
    int nframes = (int)(usize[1] / 16);
    ss_sheet *sh = calloc(1, sizeof *sh);
    sh->count = nframes;
    sh->frames = calloc((size_t)nframes, sizeof(ss_frame));

    uint8_t *idx = malloc(64 * 64);
    for (int k = 0; k < nframes; k++) {
        uint32_t dOff = u32(ft + k * 16 + 0);
        uint32_t dSize = u32(ft + k * 16 + 4);
        int w = u16(ft + k * 16 + 12);
        int h = u16(ft + k * 16 + 14);
        ss_frame *fr = &sh->frames[k];
        fr->w = w; fr->h = h;
        if (w <= 0 || h <= 0 || w > 64 || h > 64 || dOff + dSize > usize[3]) {
            fr->w = fr->h = 0; fr->rgba = NULL; continue;
        }
        decode_frame_indices(sec[3], dOff, dSize, w, h, idx);
        fr->rgba = malloc((size_t)w * h * sizeof(uint32_t));
        for (int q = 0; q < w * h; q++)
            fr->rgba[q] = (idx[q] == TRANS_INDEX) ? 0u : pal[idx[q]];
    }
    free(idx);
    for (int i = 0; i < 4; i++) free(sec[i]);
    return sh;
}

void ss_free(ss_sheet *s)
{
    if (!s) return;
    for (int i = 0; i < s->count; i++)
        free(s->frames[i].rgba);
    free(s->frames);
    free(s);
}
