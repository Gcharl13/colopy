/* C-port Phase 7 — the platform-free render core (see colopy_render.h).
 *
 * Everything here is a transcription of a byte-verified reading:
 *   * pak layout            cport/data/colopy_pak.h (Phase 6 contract)
 *   * .SS transparency      formats/SS.md (rle_decode sentinel 0xFD)
 *   * font rasteriser       func_00E51C — dec dl @0x00E5DA (the ch-1
 *                           slot), width @0x00E5E9, offset @0x00E606,
 *                           2bpp MSB unpack (shl ax,2 @0x00E629), the
 *                           4-entry ink LUT with 0xFF = skip @0x00E637
 *   * font spacing          the JS Font class (game.js:75): advance =
 *                           glyph width; missing glyph advances
 *                           width(' ') or 3
 *   * palette override      usePalette (game.js) — the master
 *                           VICEROY.PAL with a sheet/PIK palette laid
 *                           over it (the DOS DAC is global; a screen
 *                           streams its own palette on entry) */
#include <string.h>

#include "colopy_render.h"
#include "../data/colopy_pak.h"

rd_state RD;

static uint32_t rd32(const uint8_t *p) {
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}
static uint16_t rd16(const uint8_t *p) { return (uint16_t)(p[0] | (p[1] << 8)); }

int rd_pak_open(rd_pak *pk, const uint8_t *buf, uint32_t len) {
    if (len < COLOPY_PAK_HDRLEN || memcmp(buf, COLOPY_PAK_MAGIC, 4) != 0)
        return 0;
    pk->buf = buf;
    pk->len = len;
    pk->count = rd16(buf + 4);
    if (COLOPY_PAK_HDRLEN + (uint32_t)pk->count * COLOPY_PAK_TOCENT > len)
        return 0;
    return 1;
}

int rd_pak_find(const rd_pak *pk, const char *name, rd_entry *out) {
    size_t nl = strlen(name);
    if (nl > COLOPY_PAK_NAMELEN) return 0;
    for (uint16_t i = 0; i < pk->count; i++) {
        const uint8_t *e = pk->buf + COLOPY_PAK_HDRLEN + i * COLOPY_PAK_TOCENT;
        if (memcmp(e, name, nl) != 0) continue;
        if (nl < COLOPY_PAK_NAMELEN && e[nl] != 0) continue;
        memcpy(out->name, e, COLOPY_PAK_NAMELEN);
        out->name[COLOPY_PAK_NAMELEN] = 0;
        uint32_t off = rd32(e + 12);
        out->len = rd32(e + 16);
        if (off + out->len > pk->len) return 0;
        out->payload = pk->buf + off;
        out->w = rd16(e + 20);
        out->h = rd16(e + 22);
        out->frames = rd16(e + 24);
        return 1;
    }
    return 0;
}

int rd_sheet_frame(const rd_entry *sheet, int idx, rd_frame *out) {
    if (sheet->payload == 0 || sheet->len < 4) return 0;
    uint16_t nfr = rd16(sheet->payload);
    if (idx < 0 || idx >= nfr) return 0;
    const uint8_t *fe = sheet->payload + 4 + 12 * idx;
    out->x = (int16_t)rd16(fe);
    out->y = (int16_t)rd16(fe + 2);
    out->w = rd16(fe + 4);
    out->h = rd16(fe + 6);
    uint32_t off = rd32(fe + 8);
    if (off + (uint32_t)out->w * out->h > sheet->len) return 0;
    out->pix = sheet->payload + off;
    return 1;
}

const uint8_t *rd_sheet_pal(const rd_entry *sheet) {
    if (sheet->len < 4 || !(rd16(sheet->payload + 2) & 1)) return 0;
    return sheet->payload + sheet->len - 768;
}

int rd_init(const uint8_t *pak_buf, uint32_t pak_len) {
    memset(&RD, 0, sizeof(RD));
    if (!rd_pak_open(&RD.pak, pak_buf, pak_len)) return 0;
    if (!rd_pak_find(&RD.pak, "TERRAIN.SS", &RD.terrain)) return 0;
    if (!rd_pak_find(&RD.pak, "PHYS0.SS", &RD.phys0)) return 0;
    if (!rd_pak_find(&RD.pak, "ICONS.SS", &RD.icons)) return 0;
    if (!rd_pak_find(&RD.pak, "WOODTILE.SS", &RD.woodtile)) return 0;
    rd_use_palette(0);
    return 1;
}

void rd_use_palette(const char *entry_name) {
    rd_entry pal;
    uint8_t master[768];
    if (rd_pak_find(&RD.pak, "VICEROY.PAL", &pal) && pal.len == 768)
        memcpy(RD.pal, pal.payload, 768);
    memcpy(master, RD.pal, 768);
    if (!entry_name) return;
    rd_entry e;
    if (!rd_pak_find(&RD.pak, entry_name, &e)) return;
    size_t nl = strlen(entry_name);
    const uint8_t *src = 0;
    if (nl > 3 && strcmp(entry_name + nl - 3, ".SS") == 0) {
        src = rd_sheet_pal(&e);
    } else if (nl > 4 && strcmp(entry_name + nl - 4, ".PIK") == 0) {
        uint32_t npx = (uint32_t)e.w * e.h;
        if (e.len == npx + 768) src = e.payload + npx;
    }
    if (!src) return;
    memcpy(RD.pal, src, 768);
    /* the JS usePalette merge (game.js:36): a magenta-placeholder entry
     * is patched from OPENMENU.PIK's palette, and an unauthored EGA-stub
     * low-16 row falls back to the master's own entries */
    rd_entry om;
    const uint8_t *op = 0;
    if (rd_pak_find(&RD.pak, "OPENMENU.PIK", &om) &&
        om.len == (uint32_t)om.w * om.h + 768)
        op = om.payload + (uint32_t)om.w * om.h;
    if (op)
        for (int i = 0; i < 256; i++) {
            const uint8_t *c = RD.pal + i * 3;
            if (c[0] > 240 && c[1] < 110 && c[2] > 240)
                memcpy(RD.pal + i * 3, op + i * 3, 3);
        }
    static const uint8_t EGA[48] = {
        0,0,0, 0,0,170, 0,170,0, 0,170,170, 170,0,0, 170,0,170,
        170,85,0, 170,170,170, 85,85,85, 85,85,255, 85,255,85,
        85,255,255, 255,85,85, 255,85,255, 255,255,85, 255,255,255 };
    if (memcmp(src, EGA, 48) == 0) memcpy(RD.pal, master, 48);
}

void rd_fill(int x, int y, int w, int h, uint8_t colour) {
    if (x < 0) { w += x; x = 0; }
    if (y < 0) { h += y; y = 0; }
    if (x + w > RD_W) w = RD_W - x;
    if (y + h > RD_H) h = RD_H - y;
    for (int r = 0; r < h; r++)
        memset(RD.fb + (y + r) * RD_W + x, colour, (size_t)(w > 0 ? w : 0));
}

void rd_blit(const rd_entry *sheet, int idx, int x, int y) {
    rd_frame f;
    if (!rd_sheet_frame(sheet, idx, &f)) return;
    for (int r = 0; r < f.h; r++) {
        int dy = y + r;
        if (dy < 0 || dy >= RD_H) continue;
        const uint8_t *src = f.pix + r * f.w;
        uint8_t *dst = RD.fb + dy * RD_W;
        for (int c = 0; c < f.w; c++) {
            int dx = x + c;
            if (dx < 0 || dx >= RD_W) continue;
            uint8_t v = src[c];
            if (v != RD_TRANSPARENT) dst[dx] = v;
        }
    }
}

void rd_blit_name(const char *sheet_name, int idx, int x, int y) {
    rd_entry e;
    if (rd_pak_find(&RD.pak, sheet_name, &e)) rd_blit(&e, idx, x, y);
}

void rd_pik(const char *name) {
    rd_entry e;
    if (!rd_pak_find(&RD.pak, name, &e)) return;
    uint32_t npx = (uint32_t)e.w * e.h;
    if (e.len != npx && e.len != npx + 768) return;
    for (int r = 0; r < e.h && r < RD_H; r++)
        memcpy(RD.fb + r * RD_W, e.payload + (uint32_t)r * e.w,
               (size_t)(e.w < RD_W ? e.w : RD_W));
}

/* ---- text ---- */

int rd_font_open(const rd_pak *pk, const char *name, rd_font *out) {
    rd_entry e;
    if (!rd_pak_find(pk, name, &e) || e.len < 386) return 0;
    out->payload = e.payload;
    out->len = e.len;
    out->cell_h = e.payload[0];
    out->max_w = e.payload[1];
    return 1;
}

/* width(ch) = width_table[ch-1] (formats/FF.md; dec dl @0x00E5DA) */
static int glyph_width(const rd_font *f, unsigned ch) {
    if (ch < 1 || ch > 128) return 0;
    return f->payload[2 + ch - 1];
}
static int space_width(const rd_font *f) {
    int w = glyph_width(f, ' ');
    return w ? w : 3;
}

int rd_text_width(const rd_font *f, const char *s) {
    int w = 0;
    for (; *s; s++) {
        int gw = glyph_width(f, (unsigned char)*s);
        w += gw ? gw : space_width(f);
    }
    return w;
}

static void draw_glyph(const rd_font *f, unsigned ch, int x, int y,
                       const uint8_t ink[4]) {
    int w = glyph_width(f, ch);
    if (!w) return;
    uint32_t off = rd16(f->payload + 130 + 2 * (ch - 1));
    int stride = (w * 2 + 7) / 8;              /* bytes per 2bpp row */
    if (off + (uint32_t)stride * f->cell_h > f->len) return;
    const uint8_t *bm = f->payload + off;
    for (int r = 0; r < f->cell_h; r++) {
        int dy = y + r;
        if (dy < 0 || dy >= RD_H) continue;
        const uint8_t *row = bm + r * stride;
        for (int c = 0; c < w; c++) {
            int dx = x + c;
            if (dx < 0 || dx >= RD_W) continue;
            /* MSB-first: leftmost pixel = bits 7..6 (formats/FF.md) */
            int lvl = (row[c >> 2] >> (6 - 2 * (c & 3))) & 3;
            if (ink[lvl] != 0xFF) RD.fb[dy * RD_W + dx] = ink[lvl];
        }
    }
}

int rd_text(const rd_font *f, const char *s, int x, int y,
            const uint8_t ink[4]) {
    for (; *s; s++) {
        int gw = glyph_width(f, (unsigned char)*s);
        if (gw) {
            draw_glyph(f, (unsigned char)*s, x, y, ink);
            x += gw;
        } else {
            x += space_width(f);
        }
    }
    return x;
}
