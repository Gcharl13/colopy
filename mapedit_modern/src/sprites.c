/*
 * sprites.c — terrain tile drawing (see sprites.h).
 *
 * If the original COLONIZE assets are reachable, sprite_load_phys0() decodes
 * TERRAIN.SS (textured ground) and PHYS0.SS (overlays) via ss.c and tiles are
 * drawn with the real game art. Each base terrain id is matched to a TERRAIN.SS
 * frame by nearest colour to the byte-verified terrain palette, so the mapping
 * is self-deriving. Water keeps the solid game colour (TERRAIN.SS is land only).
 *
 * With no assets, every tile falls back to a colored cell plus overlay markers.
 */
#include "sprites.h"
#include "ss.h"
#include "mp.h"
#include "terrain.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static ss_sheet *g_terrain;             /* TERRAIN.SS base ground */
static ss_sheet *g_phys0;               /* PHYS0.SS overlays */
static int       g_terr_frame[32];      /* terrain id -> TERRAIN.SS frame, or -1 */
static int       g_forest_frame = -1;   /* a PHYS0 forest overlay frame, or -1 */
static bool      g_have_sheet;

bool sprite_have_sheet(void) { return g_have_sheet; }

static uint32_t frame_avg(const ss_frame *fr)
{
    if (!fr || !fr->rgba) return 0;
    long r = 0, g = 0, b = 0, n = 0;
    for (int i = 0; i < fr->w * fr->h; i++) {
        uint32_t c = fr->rgba[i];
        if (!(c >> 24)) continue;           /* skip transparent */
        r += (c >> 16) & 0xFF; g += (c >> 8) & 0xFF; b += c & 0xFF; n++;
    }
    if (!n) return 0;
    return RGB(r / n, g / n, b / n);
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

    g_have_sheet = (g_terrain != NULL);
    if (!g_have_sheet)
        return false;

    /* Match each base terrain id to the closest TERRAIN.SS frame by colour. */
    for (int id = 0; id < 32; id++) {
        g_terr_frame[id] = -1;
        const terrain_info *t = terrain_by_id((uint8_t)id);
        if (!t)
            continue;
        /* TERRAIN.SS includes water textures too, so match every terrain. */
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

    /* Auto-detect a PHYS0 tree-overlay frame: a 16x16, green-dominant frame
     * that is partly transparent (trees with gaps), picking the greenest. */
    g_forest_frame = -1;
    long best_green = 0;
    if (g_phys0) {
        for (int k = 0; k < g_phys0->count; k++) {
            ss_frame *fr = &g_phys0->frames[k];
            if (fr->w != 16 || fr->h != 16 || !fr->rgba)
                continue;
            long gpx = 0, opaque = 0;
            for (int i = 0; i < 256; i++) {
                uint32_t c = fr->rgba[i];
                if (!(c >> 24)) continue;
                opaque++;
                int r = (c >> 16) & 0xFF, g = (c >> 8) & 0xFF, b = c & 0xFF;
                if (g > r + 16 && g > b + 16) gpx++;
            }
            if (opaque < 80 || opaque > 230)         /* overlay-like coverage */
                continue;
            if (gpx > best_green && gpx * 2 > opaque) { best_green = gpx; g_forest_frame = k; }
        }
    }
    return true;
}

static int is_forested_id(uint8_t id) { return id >= 8 && id <= 15; }

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

static uint32_t darken(uint32_t c, int pct)
{
    int r = (int)((c >> 16) & 0xFF) * (100 - pct) / 100;
    int g = (int)((c >> 8) & 0xFF) * (100 - pct) / 100;
    int b = (int)(c & 0xFF) * (100 - pct) / 100;
    return RGB(r, g, b);
}

/* Blit PHYS0 frame `idx` (overlay sprite) scaled to tp. */
static void blit_phys0(fb *f, int px, int py, int tp, int idx)
{
    if (!g_phys0 || idx < 0 || idx >= g_phys0->count)
        return;
    blit_frame(f, px, py, tp, &g_phys0->frames[idx]);
}

static int tile_is_water(const mp_map *m, int x, int y)
{
    if (x < 0 || y < 0 || x >= m->width || y >= m->height)
        return 1;   /* off-map = water, so map-edge land gets a beach edge */
    uint8_t id = MP_TERRAIN_ID(m->terrain[mp_idx(m, x, y)]);
    return id == 25 || id == 26;
}

/* Neighbour-aware map tile: base ground + real coast beach (PHYS0 shore family
 * 0x01..0x0F by water-neighbour mask, per RENDER_SPEC.md) + forest + markers.
 * The shore mask bit order matches the verified nmask4_feature: N=8 S=4 W=2 E=1. */
void sprite_draw_map_tile(fb *f, int px, int py, int tp, const mp_map *m, int tx, int ty)
{
    uint8_t b = m->terrain[mp_idx(m, tx, ty)];
    uint8_t id = MP_TERRAIN_ID(b);

    /* base ground (+ overlays without context: forest/river/prime) */
    sprite_draw_tile(f, px, py, tp, b);

    /* coast: land tiles get a beach overlay on edges facing water. */
    if (!(id == 25 || id == 26)) {
        if (g_have_sheet && g_phys0) {
            int wmask = (tile_is_water(m, tx, ty - 1) ? 8 : 0)   /* N */
                      | (tile_is_water(m, tx, ty + 1) ? 4 : 0)   /* S */
                      | (tile_is_water(m, tx - 1, ty) ? 2 : 0)   /* W */
                      | (tile_is_water(m, tx + 1, ty) ? 1 : 0);  /* E */
            if (wmask)
                blit_phys0(f, px, py, tp, wmask);   /* PHYS0 0x01..0x0F */
        } else if (tp >= 4) {
            /* fallback beach halo on the land side */
            uint32_t beach = RGB(0xDA, 0xC6, 0x8A);
            int bt = tp / 5; if (bt < 1) bt = 1;
            if (tile_is_water(m, tx, ty - 1)) fb_fill_rect(f, px, py, tp, bt, beach);
            if (tile_is_water(m, tx, ty + 1)) fb_fill_rect(f, px, py + tp - bt, tp, bt, beach);
            if (tile_is_water(m, tx - 1, ty)) fb_fill_rect(f, px, py, bt, tp, beach);
            if (tile_is_water(m, tx + 1, ty)) fb_fill_rect(f, px + tp - bt, py, bt, tp, beach);
        }
    }
}

void sprite_draw_tile(fb *f, int px, int py, int tp, uint8_t tile_byte)
{
    uint8_t id = MP_TERRAIN_ID(tile_byte);
    uint32_t base = terrain_color(id);

    /* base fill (also the water colour, and the backstop under any sprite) */
    fb_fill_rect(f, px, py, tp, tp, base);

    if (g_have_sheet && id < 32 && g_terr_frame[id] >= 0)
        blit_frame(f, px, py, tp, &g_terrain->frames[g_terr_frame[id]]);

    if (tp < 5)
        return;

    /* Forest: forested terrain ids (8..15) and the forest overlay bit. With
     * assets, overlay the real PHYS0 tree sprite; otherwise draw triangles. */
    int forested = is_forested_id(id) || (tile_byte & MP_FLAG_FOREST);
    if (forested) {
        if (g_have_sheet && g_forest_frame >= 0) {
            blit_frame(f, px, py, tp, &g_phys0->frames[g_forest_frame]);
        } else if (tile_byte & MP_FLAG_FOREST) {
            uint32_t fg = RGB(0x16, 0x40, 0x1C);
            int t = tp;
            for (int dy = 0; dy < t / 2; dy++) {
                int wq = dy;
                fb_hline(f, px + t / 4 - wq / 2, py + t / 4 + dy, wq + 1, fg);
                fb_hline(f, px + 3 * t / 4 - wq / 2, py + t / 4 + dy, wq + 1, fg);
            }
        }
    }

    /* Road / river (bit 6): blue line. */
    if (tile_byte & MP_FLAG_ROADRIVER) {
        uint32_t rv = RGB(0x30, 0x70, 0xD8);
        int cy = py + tp / 2;
        fb_fill_rect(f, px, cy - (tp >= 14 ? 1 : 0), tp, tp >= 14 ? 3 : 1, rv);
    }

    /* Prime resource (bit 5): small marker, top-right. */
    if (tile_byte & MP_FLAG_PRIME) {
        int s = tp / 4 < 2 ? 2 : tp / 4;
        fb_fill_rect(f, px + tp - s - 1, py + 1, s, s, RGB(0xFF, 0xE0, 0x40));
    }
    (void)darken;
}
