/*
 * sprites.c — terrain tile drawing: a faithful port of VICEROY's byte-verified
 * map-render chain (func_O513 tile_dispatch + func_O512 tile_compose_subcells,
 * code/VICEROY/disasm_overlay_reseg/page_15.asm). MAPEDIT shares VICEROY's
 * PHYS0.SS / TERRAIN.SS and indexes them identically (code/MAPEDIT analysis),
 * so the same selection logic applies.
 *
 * LAYER SOURCING.  The stock .MP packs everything into one byte (L1); the
 * separate feature layer (L2) is empty in saved scenarios (verified: AMER2.MP
 * L2 is all-zero).  VICEROY's in-game chain reads its elevation/feature bits
 * from a *split* in-memory feature layer; here those same bits live in L1, so
 * every "raw_feature" read is sourced from the L1 byte.  Per-tile byte (L1):
 *   bits 0..4  base id   (8..23 = forest variants; classify folds to 8..15)
 *   bit 0x20   hills/mountains          bit 0x80  mountain (vs hill)
 *   bit 0x40   river
 *
 * Z-order, exactly as O513 emits (closest zoom, map view):
 *   base ground   TERRAIN.SS[terrain_cell_transform(land_base)]      (6b)
 *   [water] coast O512: PHYS0 0x68+dir per cardinal LAND neighbour
 *   [land] forest PHYS0 0x41 + nmask4_forest (forest_neighbour)      (6c)
 *   [land] river  PHYS0 0x96                 (bit 0x40)              (6d)
 *   [land] hills  PHYS0 0x31 + nmask4_feat_hi (bit 0x20, !0x80)      (6e)
 *   [land] mtn    PHYS0 0x21 + nmask4_feat_hi (bit 0x20, 0x80)       (6e)
 *
 * The road / feature-edge / clean-coast blocks (6f,6h,6i,6k) of O513 are driven
 * by the FEATURE layer's road/connectivity bits, which the stock .MP does not
 * carry (no roads in saved maps — confirmed); they would mis-fire on land
 * connectivity, so they are intentionally not emitted.
 *
 * Coast sprite directions are pixel-verified from PHYS0: frame 0x68 = north
 * edge, 0x69 = east, 0x6A = south, 0x6B = west, i.e. 0x68 + DIR4 index
 * (N,E,S,W).  Mask bit order matches nmask4: N=8 S=4 W=2 E=1.
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

/* PHYS0 sprite-index bases (byte-verified O513 + pixel-verified frames). */
#define PH_COAST   0x68   /* + DIR4 idx: 0x68 N, 0x69 E, 0x6A S, 0x6B W */
#define PH_MTN     0x21   /* + nmask4_feat_hi      */
#define PH_HILL    0x31   /* + nmask4_feat_hi      */
#define PH_FOREST  0x41   /* + nmask4_forest       */
#define PH_RIVER   0x96   /* river-on-terrain marker (O513 6d) */

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

/* TERRAIN.SS base-ground cell, byte-verified from the resident blits' shared
 * helper func_03436 (render_glue.c terrain_cell_transform):
 *   code 0x11 or 0x09 -> 8 ; code >= 8 -> code-0xF ; else code. */
static int terrain_cell_transform(int code)
{
    if (code == 0x11 || code == 0x09) return 8;
    if (code >= 8) return code - 0xF;
    return code;
}

/* O513 base-ground id (6b): land_base = vis<0x18 ? vis&7 : vis, with the
 * unforested Desert group (vis&7==1, not forested) remapped to 0x11. */
static int land_base_of(uint8_t id)
{
    int vis = id & 0x1F;
    int forested = (vis >= 8 && vis < 0x18);
    int lb = (vis < 0x18) ? (vis & 7) : vis;
    if (lb == 1 && !forested) lb = 0x11;
    return lb;
}

/* Load VICEROY.PAL (256 * 4 bytes, 6-bit RGB) as the master DAC palette. */
static void load_master_palette(const char *colonize_dir)
{
    char path[1024];
    snprintf(path, sizeof path, "%s/VICEROY.PAL", colonize_dir);
    FILE *fp = fopen(path, "rb");
    if (!fp) return;
    uint8_t raw[1024];
    size_t n = fread(raw, 1, sizeof raw, fp);
    fclose(fp);
    if (n < 1024) return;
    uint32_t pal[256];
    for (int k = 0; k < 256; k++) {
        int r = raw[k*4]*255/63, g = raw[k*4+1]*255/63, b = raw[k*4+2]*255/63;
        pal[k] = ((uint32_t)r << 16) | ((uint32_t)g << 8) | (uint32_t)b;
    }
    ss_set_master_palette(pal);
}

bool sprite_load_phys0(const char *colonize_dir)
{
    char path[1024];
    /* Each .SS uses its own embedded palette — verified: VICEROY.PAL as the
     * sprite palette produces garbage, so the sheets are self-palettized. */
    ss_set_master_palette(NULL);
    (void)load_master_palette;
    snprintf(path, sizeof path, "%s/TERRAIN.SS", colonize_dir);
    g_terrain = ss_load(path);
    snprintf(path, sizeof path, "%s/PHYS0.SS", colonize_dir);
    g_phys0 = ss_load(path);

    g_have_sheet = (g_terrain != NULL && g_phys0 != NULL);
    if (!g_have_sheet)
        return false;

    /* Base terrain id -> TERRAIN.SS frame via the verified transform (the cells
     * are 0-based frames in sheet order). */
    for (int id = 0; id < 32; id++) {
        int frame = terrain_cell_transform(land_base_of((uint8_t)id));
        g_terr_frame[id] = (frame >= 0 && frame < g_terrain->count) ? frame : -1;
    }
    (void)frame_avg; (void)color_dist;
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

/* ---- terrain predicates over the L1 byte ----
 * The render chain works on the *classified visible id*: classify masks the
 * byte to 0x1F and folds the forest band 8..23 down to 8..15. */
static int is_water_id(uint8_t id)  { return id == 25 || id == 26; }

/* classify_terrain (func_006204, map view): id &= 0x1F; if 8<=id<0x18 ->
 * (id&7)|8. Water ids 25/26 -> 0x19/0x1A in the renderer's id space. */
static int classify_vis(uint8_t b)
{
    int id = b & 0x1F;
    if (id >= 8 && id < 0x18) return (id & 7) | 8;
    if (id == 25) return 0x19;
    if (id == 26) return 0x1A;
    return id;
}

/* DIR4 neighbour offsets, N,E,S,W (matches VICEROY DIR4_DX/DY). */
static const int DIR4_DX[4] = {  0,  1,  0, -1 };
static const int DIR4_DY[4] = { -1,  0,  1,  0 };

static uint8_t L1at(const mp_map *m, int x, int y)
{
    if (x < 0 || y < 0 || x >= m->width || y >= m->height) return 0;
    return m->terrain[mp_idx(m, x, y)];
}
/* off-map counts as sea so edge water tiles get no spurious coast */
static int water_at(const mp_map *m, int x, int y)
{
    if (x < 0 || y < 0 || x >= m->width || y >= m->height) return 1;
    return is_water_id(MP_TERRAIN_ID(m->terrain[mp_idx(m, x, y)]));
}

/* forest_neighbour (func_067C54): b = neighbour base & 0x1F; forested iff
 *   b >= 0x18, or (8..0x17 with (b&7) != 1). ids 9/17 (the Scrub group) and
 *   bases <= 7 are NOT forest. */
static int forest_neighbour(const mp_map *m, int x, int y)
{
    int b = MP_TERRAIN_ID(L1at(m, x, y));
    if (b >= 0x18) return 1;
    if ((b & 7) == 1) return 0;
    if (b <= 7)       return 0;
    return 1;
}
/* nmask4_forest (func_067C8E): forest_neighbour at N(+8)/S(+4)/W(+2)/E(+1). */
static int forest_nmask(const mp_map *m, int x, int y)
{
    int k = 0;
    if (forest_neighbour(m, x, y - 1)) k |= 8;
    if (forest_neighbour(m, x, y + 1)) k |= 4;
    if (forest_neighbour(m, x - 1, y)) k |= 2;
    if (forest_neighbour(m, x + 1, y)) k |= 1;
    return k;
}
/* nmask4_feat_hi (func_067BE4): (neighbour & 0xA0) == self_hi, N/S/W/E. */
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

/* Coast / beach on a WATER tile (func_O512, the sub-cell composer).
 *
 * O512 composes the shoreline from 8x8 water sub-cells (PHYS0 0x70..0x8B) per
 * quadrant; that selection table is not byte-decoded, so the beach is composed
 * here from the game's OWN coast colours (sampled from PHYS0 0x97: deep ocean
 * #283891, shallow/foam #5069B2, sand #BAA17D) — sand at the land border, a
 * shallow band, then deep ocean — for every land-facing edge and corner.  This
 * reproduces the original's coastline look without inventing colours. */
#define COAST_SAND    RGB(0xBA, 0xA1, 0x7D)
#define COAST_SHALLOW RGB(0x50, 0x69, 0xB2)

static void coast_edge(fb *f, int px, int py, int tp, int dir, int sand, int shallow)
{
    /* outer `sand` px at the land border, then `shallow` px of foam water */
    switch (dir) {
        case 0: /* N: land above -> beach on the top edge */
            fb_fill_rect(f, px, py, tp, sand, COAST_SAND);
            fb_fill_rect(f, px, py + sand, tp, shallow, COAST_SHALLOW);
            break;
        case 1: /* E */
            fb_fill_rect(f, px + tp - sand, py, sand, tp, COAST_SAND);
            fb_fill_rect(f, px + tp - sand - shallow, py, shallow, tp, COAST_SHALLOW);
            break;
        case 2: /* S */
            fb_fill_rect(f, px, py + tp - sand, tp, sand, COAST_SAND);
            fb_fill_rect(f, px, py + tp - sand - shallow, tp, shallow, COAST_SHALLOW);
            break;
        case 3: /* W */
            fb_fill_rect(f, px, py, sand, tp, COAST_SAND);
            fb_fill_rect(f, px + sand, py, shallow, tp, COAST_SHALLOW);
            break;
    }
}

static void compose_coast(fb *f, int px, int py, int tp, const mp_map *m, int tx, int ty)
{
    if (tp < 4) return;                 /* too small to show a beach */
    int sand = tp / 8; if (sand < 1) sand = 1;
    int shallow = tp / 6; if (shallow < 1) shallow = 1;

    /* shallow band first (under the sand), then sand on top, per land edge */
    for (int d = 0; d < 4; d++)
        if (!water_at(m, tx + DIR4_DX[d], ty + DIR4_DY[d]))
            coast_edge(f, px, py, tp, d, sand, shallow);

    /* diagonal land neighbours: a sand fleck in the matching corner */
    static const int cdx[4] = { -1, 1, 1, -1 }, cdy[4] = { -1, -1, 1, 1 };
    for (int c = 0; c < 4; c++)
        if (!water_at(m, tx + cdx[c], ty + cdy[c])) {
            int cx = (cdx[c] < 0) ? px : px + tp - sand;
            int cy = (cdy[c] < 0) ? py : py + tp - sand;
            fb_fill_rect(f, cx, cy, sand, sand, COAST_SAND);
        }
}

/* Neighbour-aware map tile composition (the O513/O512 stack). */
void sprite_draw_map_tile(fb *f, int px, int py, int tp, const mp_map *m, int tx, int ty)
{
    uint8_t b   = m->terrain[mp_idx(m, tx, ty)];
    uint8_t id  = MP_TERRAIN_ID(b);
    int     vis = classify_vis(b);

    /* 6b. base ground (verified terrain_cell_transform mapping, per id) */
    if (g_have_sheet) {
        int bf = g_terr_frame[id];
        fb_fill_rect(f, px, py, tp, tp, terrain_color(id));
        if (bf >= 0) blit_frame(f, px, py, tp, &g_terrain->frames[bf]);
    } else {
        sprite_draw_tile(f, px, py, tp, b);   /* colored fallback (+ markers) */
    }

    /* water tile: ocean base drawn above; coast composed on the water side. */
    if (is_water_id(id)) {
        if (g_have_sheet)
            compose_coast(f, px, py, tp, m, tx, ty);
        else if (tp >= 4) {
            uint32_t beach = RGB(0xDA, 0xC6, 0x8A);
            int bt = tp / 5; if (bt < 1) bt = 1;
            if (!water_at(m, tx, ty - 1)) fb_fill_rect(f, px, py, tp, bt, beach);
            if (!water_at(m, tx, ty + 1)) fb_fill_rect(f, px, py + tp - bt, tp, bt, beach);
            if (!water_at(m, tx - 1, ty)) fb_fill_rect(f, px, py, bt, tp, beach);
            if (!water_at(m, tx + 1, ty)) fb_fill_rect(f, px + tp - bt, py, bt, tp, beach);
        }
        return;
    }

    if (!g_have_sheet)
        return;   /* colored fallback already drew forest/river markers */

    /* 6c. forest canopy: forested visible band 8..0x17, EXCEPT the land_base==1
     * (Scrub/Desert) group. forest_nmask uses the forest_neighbour predicate. */
    if (vis >= 8 && vis < 0x18 && land_base_of(b) != 1)
        blit_phys0(f, px, py, tp, PH_FOREST + forest_nmask(m, tx, ty));

    /* 6d. river-on-terrain: terrain bit 0x40 -> PHYS0 0x96 (blue river, banks). */
    if (b & 0x40)
        blit_phys0(f, px, py, tp, PH_RIVER);

    /* 6e. hills / mountains (bit 0x20; bit 0x80 = mountain) + same-class mask. */
    if (b & 0x20) {
        int hm = (b & 0x80) ? PH_MTN : PH_HILL;
        blit_phys0(f, px, py, tp, hm + feat_hi_nmask(m, tx, ty));
    }
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

    if (g_have_sheet && g_terr_frame[id] >= 0)
        blit_frame(f, px, py, tp, &g_terrain->frames[g_terr_frame[id]]);

    if (tp >= 6 && !is_water_id(id) && !g_have_sheet) {
        uint32_t mottle = darken(base, 12);
        for (int yy = 1; yy < tp; yy += 3)
            fb_hline(f, px + 1, py + yy, tp - 2, mottle);
    }
}
