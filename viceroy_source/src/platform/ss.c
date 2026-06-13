/* ============================================================================
 * ss.c -- MS_SPRITE (.SS) sprite-sheet loader (MADSPACK container)
 * ----------------------------------------------------------------------------
 * COLONIZE's sprite sheets (TERRAIN.SS, ICONS.SS, PHYS0.SS, ...) are MADSPACK
 * files with 4 items:
 *   item 0: header -- mode:u8, pad:u8, type1:u16, type2:u16, pad[32],
 *           frameCount:u16
 *   item 1: frame directory -- per frame { offset:u32, size:u32, x:i16,
 *           y:i16, w:u16, h:u16 } (16 bytes)
 *   item 2: 768-byte palette (Colonization variant: a full 256x6-bit VGA
 *           palette, byte-identical to VICEROY.PAL modulo cycled entries;
 *           sprite pixels are DIRECT palette indices)
 *   item 3: RLE pixel streams, one per frame at its directory offset
 *
 * RLE (per the MADS MSprite codec):
 *   line cmd: 0xFC end-of-sprite | 0xFF next line | 0xFD run-mode line |
 *             other = mixed-mode line (cmd byte itself not emitted)
 *   run-mode   : { count:u8 (0xFF=end line), pixel:u8 } repeated
 *   mixed-mode : pixel bytes; 0xFF=end line, 0xFE={count,pixel} run,
 *                0xFD = transparent pixel
 *
 * Format recovered via the ScummVM MADS engine's reader; fresh C
 * implementation.  Transparent pixels are stored as SS_TRANSPARENT.
 *
 * CROSS-VALIDATED 2026-06-10 against VICEROY.EXE's OWN blitter
 * (func_00E76A, file 0xE76A, full disasm): identical control-byte
 * semantics -- 0xFF end-of-line, 0xFD run-mode line ({count,pixel},
 * count 0xFF ends), mixed-mode 0xFE={count,pixel} run and 0xFD =
 * transparent (pixel skipped, never written).  The EXE blitter adds
 * clipping, sign-bit HORIZONTAL MIRRORING (negative sprite index =
 * mirrored; step -1), and VRAM banking -- responsibilities of the
 * modern blit layer (unit_blit.c/video_sdl.c), which must honour the
 * mirror convention for west-facing units.
 * ============================================================================ */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "platform.h"

#define RD16(p)  ((uint16_t)((p)[0] | ((p)[1] << 8)))
#define RD32(p)  ((uint32_t)((p)[0] | ((p)[1] << 8) | ((p)[2] << 16) | ((uint32_t)(p)[3] << 24)))

static int rle_decode(const uint8_t *src, long n, uint8_t *out, int w, int h)
{
    long i = 0, px = 0, line = 0;
    memset(out, SS_TRANSPARENT, (size_t)w * h);
    while (i < n) {
        uint8_t cmd = src[i++];
        if (cmd == 0xFC) return 0;                     /* end of sprite */
        if (cmd == 0xFF) { line++; px = 0; continue; } /* empty line */
        if (line >= h) return 0;
        uint8_t *row = out + line * w;
        if (cmd == 0xFD) {                             /* run-mode line */
            for (;;) {
                if (i >= n) return -1;
                uint8_t count = src[i++];
                if (count == 0xFF) break;
                if (i >= n) return -1;
                uint8_t pixel = src[i++];
                while (count-- && px < w)
                    row[px++] = (pixel == 0xFD) ? SS_TRANSPARENT : pixel;
            }
        } else {                                       /* mixed-mode line */
            for (;;) {
                if (i >= n) return -1;
                uint8_t c = src[i++];
                if (c == 0xFF) break;
                if (c == 0xFE) {
                    if (i + 1 >= n) return -1;
                    uint8_t count = src[i++], pixel = src[i++];
                    while (count-- && px < w)
                        row[px++] = (pixel == 0xFD) ? SS_TRANSPARENT : pixel;
                } else if (px < w) {
                    row[px++] = (c == 0xFD) ? SS_TRANSPARENT : c;
                }
            }
        }
        line++; px = 0;
    }
    return 0;
}

int ss_load(const char *path, ss_sheet_t *s)
{
    memset(s, 0, sizeof *s);
    uint8_t *items[4] = { 0 };
    uint32_t sizes[4] = { 0 };
    int count = madspack_load(path, items, sizes, 4);
    if (count < 4) return -1;

    int mode = items[0][0];
    s->nframes = RD16(items[0] + 38);
    if (mode != 0 || s->nframes > SS_MAX_FRAMES) {     /* FAB-frame mode: TODO */
        for (int i = 0; i < 4; i++) free(items[i]);
        return -1;
    }
    if (sizes[2] >= 768) {
        memcpy(s->pal6, items[2], 768);
        s->has_pal = 1;
    }
    for (int i = 0; i < s->nframes; i++) {
        const uint8_t *e = items[1] + i * 16;
        uint32_t off  = RD32(e);
        uint32_t size = RD32(e + 4);
        s->frames[i].x = (int16_t)RD16(e + 8);
        s->frames[i].y = (int16_t)RD16(e + 10);
        int w = s->frames[i].w = RD16(e + 12);
        int h = s->frames[i].h = RD16(e + 14);
        s->frames[i].pixels = malloc((size_t)w * h);
        if (!s->frames[i].pixels ||
            off + size > sizes[3] ||
            rle_decode(items[3] + off, size, s->frames[i].pixels, w, h) != 0) {
            ss_free(s);
            for (int j = 0; j < 4; j++) free(items[j]);
            return -1;
        }
    }
    for (int i = 0; i < 4; i++) free(items[i]);
    return 0;
}

void ss_free(ss_sheet_t *s)
{
    for (int i = 0; i < s->nframes; i++) {
        free(s->frames[i].pixels);
        s->frames[i].pixels = 0;
    }
    s->nframes = 0;
}

/* blit one frame clipped to an inclusive rect */
void ss_blit_clip(const ss_sheet_t *s, int frame, int x, int y,
                  int cx0, int cy0, int cx1, int cy1)
{
    if (frame < 0 || frame >= s->nframes) return;
    const ss_frame_t *f = &s->frames[frame];
    uint8_t *fb = vid_framebuffer();
    if (cx1 >= VID_W) cx1 = VID_W - 1;
    if (cy1 >= VID_H) cy1 = VID_H - 1;
    for (int r = 0; r < f->h; r++) {
        int py = y + r;
        if (py < cy0 || py > cy1) continue;
        for (int c = 0; c < f->w; c++) {
            int px = x + c;
            uint8_t v = f->pixels[r * f->w + c];
            if (v != SS_TRANSPARENT && px >= cx0 && px <= cx1)
                fb[py * VID_W + px] = v;
        }
    }
}

/* blit one frame into the framebuffer, honoring transparency + clipping */
void ss_blit(const ss_sheet_t *s, int frame, int x, int y)
{
    if (frame < 0 || frame >= s->nframes) return;
    const ss_frame_t *f = &s->frames[frame];
    uint8_t *fb = vid_framebuffer();
    for (int r = 0; r < f->h; r++) {
        int py = y + r;
        if (py < 0 || py >= VID_H) continue;
        for (int c = 0; c < f->w; c++) {
            int px = x + c;
            uint8_t v = f->pixels[r * f->w + c];
            if (v != SS_TRANSPARENT && px >= 0 && px < VID_W)
                fb[py * VID_W + px] = v;
        }
    }
}

/* Build a sheet-index -> active-index remap LUT (nearest colour in the live DAC).
 * The modern stand-in for the original's palette-reconciliation: a sheet's pal6
 * indices mean nothing under another image's palette, so map sheet-colour -> RGB
 * -> nearest active index. */
static void ss_remap_lut(const ss_sheet_t *s, uint8_t lut[256])
{
    const uint8_t *dst = vid_get_palette();
    for (int i = 0; i < 256; i++) {
        int sr = (s->pal6[i*3]   << 2) | (s->pal6[i*3]   >> 4);
        int sg = (s->pal6[i*3+1] << 2) | (s->pal6[i*3+1] >> 4);
        int sb = (s->pal6[i*3+2] << 2) | (s->pal6[i*3+2] >> 4);
        int best = 0, bd = 1 << 30;
        for (int j = 0; j < 256; j++) {
            int dr = sr - dst[j*3], dg = sg - dst[j*3+1], db = sb - dst[j*3+2];
            int d = dr*dr + dg*dg + db*db;
            if (d < bd) { bd = d; best = j; }
        }
        lut[i] = (uint8_t)best;
    }
}

/* Blit a sheet authored for its OWN palette onto a framebuffer showing a
 * DIFFERENT (active) palette, remapping each colour. A sheet with no own palette
 * already speaks the active palette -> plain ss_blit. */
void ss_blit_remap(const ss_sheet_t *s, int frame, int x, int y)
{
    if (frame < 0 || frame >= s->nframes) return;
    if (!s->has_pal) { ss_blit(s, frame, x, y); return; }
    const ss_frame_t *f = &s->frames[frame];
    uint8_t lut[256]; ss_remap_lut(s, lut);
    uint8_t *fb = vid_framebuffer();
    for (int r = 0; r < f->h; r++) {
        int py = y + r;
        if (py < 0 || py >= VID_H) continue;
        for (int c = 0; c < f->w; c++) {
            int px = x + c;
            uint8_t v = f->pixels[r * f->w + c];
            if (v != SS_TRANSPARENT && px >= 0 && px < VID_W)
                fb[py * VID_W + px] = lut[v];
        }
    }
}

/* Remap-blit clipped to an inclusive rect (for tiling a panel fill). */
void ss_blit_remap_clip(const ss_sheet_t *s, int frame, int x, int y,
                        int cx0, int cy0, int cx1, int cy1)
{
    if (frame < 0 || frame >= s->nframes) return;
    if (!s->has_pal) { ss_blit_clip(s, frame, x, y, cx0, cy0, cx1, cy1); return; }
    const ss_frame_t *f = &s->frames[frame];
    uint8_t lut[256]; ss_remap_lut(s, lut);
    uint8_t *fb = vid_framebuffer();
    if (cx1 >= VID_W) cx1 = VID_W - 1;
    if (cy1 >= VID_H) cy1 = VID_H - 1;
    for (int r = 0; r < f->h; r++) {
        int py = y + r;
        if (py < cy0 || py > cy1) continue;
        for (int c = 0; c < f->w; c++) {
            int px = x + c;
            uint8_t v = f->pixels[r * f->w + c];
            if (v != SS_TRANSPARENT && px >= cx0 && px <= cx1)
                fb[py * VID_W + px] = lut[v];
        }
    }
}
