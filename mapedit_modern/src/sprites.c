/*
 * sprites.c — terrain tile drawing (see sprites.h and docs/RENDER_SPEC.md).
 *
 * With the COLONIZE assets present this composes each tile the way VICEROY's
 * O513 does, using the real sprites:
 *   base ground   TERRAIN.SS[ unforested(id) ]
 *   forest canopy PHYS0 0x41 + forest-neighbour mask     (terrain id 8..23)
 *   hills/mtns    PHYS0 0x31 / 0x21 + nmask4_feat_hi      (terrain bit 0x20)
 *   river         PHYS0 0x51 / 0x52+i                     (terrain bit 0x40)
 *   coast beach   PHYS0 0x01..0x0F by water-neighbour mask
 *
 * Terrain-byte (L1) bits, per the byte-verified renderer:
 *   bits 0..4 base id (8..23 = forest variants, collapsed to 8..15 by classify)
 *   bit 0x20  hills/mountains          bit 0x80  mountain (vs hill)
 *   bit 0x40  river
 *
 * Mask bit order matches nmask4: N=8 S=4 W=2 E=1.
 */
#include "sprites.h"
#include "ss.h"
#include "mp.h"
#include "terrain.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static ss_sheet *g_terrain;             /* TERRAIN.SS textured ground */
static ss_sheet *g_phys0;               /* PHYS0.SS overlays */
static int       g_terr_frame[32];      /* base terrain id -> TERRAIN.SS frame */
static bool      g_have_sheet;

/* PHYS0 sprite-index bases (RENDER_SPEC.md, verified against decoded frames). */
#define PH_SHORE   0x00   /* + wmask (0x01..0x0F)  */
#define PH_MTN     0x21   /* + nmask4_feat_hi      */
#define PH_HILL    0x31
#define PH_FOREST  0x41   /* + forest-neighbour mask */
#define PH_RIVER0  0x51   /* lone river            */
#define PH_RIVER   0x52   /* + 8-dir bit           */

bool sprite_have_sheet(void) { return g_have_sheet; }

static uint32_t frame_avg(const ss_frame *fr)
{
    if (!fr || !fr->rgba) return 0;
    long r = 0, g = 0, b = 0, n = 0;
    for (int i = 0; i < fr->w * fr->h; i++) {
        uint32_t c = fr->rgba[i];
        if (!(c >> 24)) continue;
        r += (c >> 16) & 0xFF; g += (c >> 8) & 0xFF; b += c & 0xFF; n++;
    }
    return n ? RGB(r / n, g / n, b / n) : 0;
}

static long color_dist(uint32_t a, uint32_t b)
{
    long dr = (long)((a >> 16) & 0xFF) - ((b >> 16) & 0xFF);
    long dg = (long)((a >> 8) & 0xFF) - ((b >> 8) & 0xFF);
    long db = (long)(a & 0xFF) - (b & 0xFF);
    return dr * dr + dg * dg + db * db;
}

bool sprite_load_phys0(const char *colonize_dir)
{
    char path[1024];
    snprintf(path, sizeof path, "%s/TERRAIN.SS", colonize_dir);
    g_terrain = ss_load(path);
    snprintf(path, sizeof path, "%s/PHYS0.SS", colonize_dir);
    g_phys0 = ss_load(path);

    g_have_sheet = (g_terrain != NULL && g_phys0 != NULL);
    if (!g_have_sheet)
        return false;

    /* Match each base terrain id to the closest TERRAIN.SS frame by colour. */
    for (int id = 0; id < 32; id++) {
        g_terr_frame[id] = -1;
        const terrain_info *t = terrain_by_id((uint8_t)id);
        if (!t) continue;
        uint32_t want = terrain_color((uint8_t)id);
        long best = 0x7FFFFFFF; int bestk = -1;
        for (int k = 0; k < g_terrain->count; k++) {
            uint32_t avg = frame_avg(&g_terrain->frames[k]);
            if (!avg) continue;
            long d = color_dist(avg, want);
            if (d < best) { best = d; bestk = k; }
        }
        g_terr_frame[id] = bestk;
    }
    return true;
}

/* nearest-neighbour blit of a frame scaled to tp x tp; transparent pixels skip */
static void blit_frame(fb *f, int px, int py, int tp, const ss_frame *fr)
{
    if (!fr || !fr->rgba || fr->w <= 0 || fr->h <= 0)
        return;
    for (int yy = 0; yy < tp; yy++) {
        int sy = yy * fr->h / tp;
        for (int xx = 0; xx < tp; xx++) {
            int sx = xx * fr->w / tp;
            uint32_t c = fr->rgba[sy * fr->w + sx];
            if (c >> 24)
                fb_set(f, px + xx, py + yy, c & 0xFFFFFF);
        }
    }
}

static void blit_phys0(fb *f, int px, int py, int tp, int idx)
{
    if (g_phys0 && idx >= 0 && idx < g_phys0->count)
        blit_frame(f, px, py, tp, &g_phys0->frames[idx]);
}

/* ---- terrain predicates over the L1 byte ---- */
static int is_water_id(uint8_t id)  { return id == 25 || id == 26; }
static int is_forest_id(uint8_t id) { return id >= 8 && id < 24; }
static uint8_t base_ground_id(uint8_t id)
{
    if (is_forest_id(id)) return id & 7;     /* unforested ground under canopy */
    return id;
}

static uint8_t L1at(const mp_map *m, int x, int y)
{
    if (x < 0 || y < 0 || x >= m->width || y >= m->height) return 0;
    return m->terrain[mp_idx(m, x, y)];
}
static int water_at(const mp_map *m, int x, int y)
{
    if (x < 0 || y < 0 || x >= m->width || y >= m->height) return 1;  /* off-map = sea */
    return is_water_id(MP_TERRAIN_ID(m->terrain[mp_idx(m, x, y)]));
}

/* 4-cardinal masks (N=8 S=4 W=2 E=1). */
static int forest_nmask(const mp_map *m, int x, int y)
{
    int k = 0;
    if (is_forest_id(MP_TERRAIN_ID(L1at(m, x, y - 1)))) k |= 8;
    if (is_forest_id(MP_TERRAIN_ID(L1at(m, x, y + 1)))) k |= 4;
    if (is_forest_id(MP_TERRAIN_ID(L1at(m, x - 1, y)))) k |= 2;
    if (is_forest_id(MP_TERRAIN_ID(L1at(m, x + 1, y)))) k |= 1;
    return k;
}
static int feat_hi_nmask(const mp_map *m, int x, int y)
{
    int self_hi = L1at(m, x, y) & 0xA0;
    int k = 0;
    if ((L1at(m, x, y - 1) & 0xA0) == self_hi) k |= 8;
    if ((L1at(m, x, y + 1) & 0xA0) == self_hi) k |= 4;
    if ((L1at(m, x - 1, y) & 0xA0) == self_hi) k |= 2;
    if ((L1at(m, x + 1, y) & 0xA0) == self_hi) k |= 1;
    return k;
}
static int water_nmask(const mp_map *m, int x, int y)
{
    return (water_at(m, x, y - 1) ? 8 : 0) | (water_at(m, x, y + 1) ? 4 : 0)
         | (water_at(m, x - 1, y) ? 2 : 0) | (water_at(m, x + 1, y) ? 1 : 0);
}
/* 8-dir river connectivity (neighbours that also carry the river bit). */
static int river_nmask8(const mp_map *m, int x, int y)
{
    static const int dx[8] = { 0, 1, 1, 1, 0, -1, -1, -1 };
    static const int dy[8] = { -1, -1, 0, 1, 1, 1, 0, -1 };
    int k = 0;
    for (int i = 0; i < 8; i++)
        if (L1at(m, x + dx[i], y + dy[i]) & MP_FLAG_ROADRIVER) k |= (1 << i);
    return k;
}

/* Neighbour-aware map tile composition (the O513 stack). */
void sprite_draw_map_tile(fb *f, int px, int py, int tp, const mp_map *m, int tx, int ty)
{
    uint8_t b  = m->terrain[mp_idx(m, tx, ty)];
    uint8_t id = MP_TERRAIN_ID(b);

    /* 1. base ground */
    if (g_have_sheet) {
        int bf = g_terr_frame[base_ground_id(id)];
        fb_fill_rect(f, px, py, tp, tp, terrain_color(id));
        if (bf >= 0) blit_frame(f, px, py, tp, &g_terrain->frames[bf]);
    } else {
        sprite_draw_tile(f, px, py, tp, b);   /* colored fallback (+ markers) */
    }

    if (is_water_id(id)) {
        /* water tiles: coast composes from land neighbours in the land path */
        return;
    }

    if (!g_have_sheet) {
        /* colored fallback already drew forest/river markers; add a halo coast */
        if (tp >= 4) {
            uint32_t beach = RGB(0xDA, 0xC6, 0x8A);
            int bt = tp / 5; if (bt < 1) bt = 1;
            if (water_at(m, tx, ty - 1)) fb_fill_rect(f, px, py, tp, bt, beach);
            if (water_at(m, tx, ty + 1)) fb_fill_rect(f, px, py + tp - bt, tp, bt, beach);
            if (water_at(m, tx - 1, ty)) fb_fill_rect(f, px, py, bt, tp, beach);
            if (water_at(m, tx + 1, ty)) fb_fill_rect(f, px + tp - bt, py, bt, tp, beach);
        }
        return;
    }

    /* 2. forest canopy */
    if (is_forest_id(id))
        blit_phys0(f, px, py, tp, PH_FOREST + forest_nmask(m, tx, ty));

    /* 3. hills / mountains (terrain bit 0x20; bit 0x80 = mountain) */
    if (b & 0x20) {
        int hm = (b & 0x80) ? PH_MTN : PH_HILL;
        blit_phys0(f, px, py, tp, hm + feat_hi_nmask(m, tx, ty));
    }

    /* (No roads on a stock map: roads come from the in-game road-connectivity
     * pass, which is empty on AMER2; the brown 0x51/0x52 road sprites are not
     * drawn here.) */
    (void)river_nmask8;

    /* 5. coast beach on edges facing water */
    int wm = water_nmask(m, tx, ty);
    if (wm)
        blit_phys0(f, px, py, tp, PH_SHORE + wm);   /* 0x01..0x0F */
}

/* ---- context-free single-tile draw (palette/swatches/fallback) ---- */
static uint32_t darken(uint32_t c, int pct)
{
    int r = (int)((c >> 16) & 0xFF) * (100 - pct) / 100;
    int g = (int)((c >> 8) & 0xFF) * (100 - pct) / 100;
    int b = (int)(c & 0xFF) * (100 - pct) / 100;
    return RGB(r, g, b);
}

void sprite_draw_tile(fb *f, int px, int py, int tp, uint8_t tile_byte)
{
    uint8_t id = MP_TERRAIN_ID(tile_byte);
    uint32_t base = terrain_color(id);
    fb_fill_rect(f, px, py, tp, tp, base);

    if (g_have_sheet && g_terr_frame[base_ground_id(id)] >= 0)
        blit_frame(f, px, py, tp, &g_terrain->frames[g_terr_frame[base_ground_id(id)]]);

    if (tp >= 6 && !is_water_id(id) && !g_have_sheet) {
        uint32_t mottle = darken(base, 12);
        for (int yy = 1; yy < tp; yy += 3)
            fb_hline(f, px + 1, py + yy, tp - 2, mottle);
    }
}
