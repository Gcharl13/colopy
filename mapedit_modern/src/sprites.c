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
 *   [land] forest PHYS0 0x41 + nmask4_forest (forest_neighbour)      (6c)
 *   [land] river  PHYS0 0x96                 (bit 0x40)              (6d)
 *   [land] hills  PHYS0 0x31 + nmask4_feat_hi (bit 0x20, !0x80)      (6e)
 *   [land] mtn    PHYS0 0x21 + nmask4_feat_hi (bit 0x20, 0x80)       (6e)
 *   [water] coast 0xC665: diagonal beach 0x97+pattern OR 4 quadrant
 *           sub-cells 0x6D+config*4+q, driven by 8-neighbour connectivity (6i)
 *
 * The coast sub-cell/diagonal block (6i) runs ONLY for water tiles (base_drawn
 * set by the Ocean/Sea-Lane test at 0xC450/0xC457); its connectivity bitmap +
 * per-quadrant config come from the 0xBC1E builder over the 8 neighbours' L1
 * land/water — see compose_coast() below. The road / feature-edge blocks
 * (6f,6h,6k) of O513 need the FEATURE layer's road bits, which the stock .MP
 * does not carry (no roads in saved maps — confirmed), so they are not emitted.
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
static uint32_t  g_ui_pal[256];         /* VICEROY.PAL as 0x00RRGGBB (UI chrome) */
static bool      g_ui_pal_ok;

/* PHYS0 sprite-index bases. Each terrain overlay occupies a 16-sprite row; the
 * 4-cardinal neighbour mask (0..15) indexes WITHIN the row, so the base must be
 * the row START or a fully-forested tile (mask 15) overflows into the next row.
 * The previous 0x21/0x31/0x41 bases pushed forest interiors to 0x50 — the ROAD
 * row — which is exactly the "road sprites on terrain" bug. Rows are pixel-
 * verified in notes/SPRITE_CATALOG.md: 0x20 mtn, 0x30 hills, 0x40 forest,
 * 0x50 roads (never drawn here). */
#define PH_MTN     0x20   /* row 0x20 + nmask4_feat_hi (0..15) */
#define PH_HILL    0x30   /* row 0x30 + nmask4_feat_hi (0..15) */
#define PH_FOREST  0x40   /* row 0x40 + nmask4_forest  (0..15) */
#define PH_RIVER   0x00   /* row 0x00 river overlays (green banks) + river mask */
#define PH_COAST   0x96   /* row 0x90: ocean-with-sand corner beaches 0x96..0x99 */

uint32_t sprite_ui_color(int idx)
{
    /* The editor's chrome colour indices (0,7,8,15 = text/bar/disabled/hilite)
     * are the canonical DOS 16-colour UI set, resolved through the STANDARD VGA
     * palette — not VICEROY.PAL (a terrain-art palette where idx 7 is green).
     * Indices >= 16 (rare) fall back to the loaded VICEROY.PAL. */
    static const uint32_t vga16[16] = {
        0x000000, 0x0000AA, 0x00AA00, 0x00AAAA, 0xAA0000, 0xAA00AA, 0xAA5500,
        0xAAAAAA, 0x555555, 0x5555FF, 0x55FF55, 0x55FFFF, 0xFF5555, 0xFF55FF,
        0xFFFF55, 0xFFFFFF };
    if (idx >= 0 && idx < 16) return vga16[idx];
    if (g_ui_pal_ok && idx >= 0 && idx < 256) return g_ui_pal[idx];
    return 0;
}

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

/* Load VICEROY.PAL (256 * 4 bytes, 6-bit RGB) into g_ui_pal for UI chrome
 * colours (the editor's menu/border colours are palette indices into this).
 * Sprites keep their own embedded palettes, so we do NOT set it as master. */
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
    for (int k = 0; k < 256; k++) {
        int r = raw[k*4]*255/63, g = raw[k*4+1]*255/63, b = raw[k*4+2]*255/63;
        g_ui_pal[k] = ((uint32_t)r << 16) | ((uint32_t)g << 8) | (uint32_t)b;
    }
    g_ui_pal_ok = true;
}

bool sprite_load_phys0(const char *colonize_dir)
{
    char path[1024];
    /* Each .SS uses its own embedded palette — verified: VICEROY.PAL as the
     * sprite palette produces garbage, so the sheets are self-palettized. But
     * the editor's UI chrome colours ARE palette indices into VICEROY.PAL, so
     * load it for sprite_ui_color(). */
    ss_set_master_palette(NULL);
    load_master_palette(colonize_dir);
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

/* blit a PHYS0 frame with optional horizontal/vertical mirroring (used to
 * orient the corner-beach sprites toward whichever side faces land). */
static void blit_phys0_flip(fb *f, int px, int py, int tp, int idx,
                            int hflip, int vflip)
{
    if (!g_phys0 || idx < 0 || idx >= g_phys0->count) return;
    const ss_frame *fr = &g_phys0->frames[idx];
    if (!fr->rgba || fr->w <= 0 || fr->h <= 0) return;
    for (int yy = 0; yy < tp; yy++) {
        int sy = yy * fr->h / tp;
        if (vflip) sy = fr->h - 1 - sy;
        for (int xx = 0; xx < tp; xx++) {
            int sx = xx * fr->w / tp;
            if (hflip) sx = fr->w - 1 - sx;
            uint32_t c = fr->rgba[sy * fr->w + sx];
            if (c >> 24)
                fb_set(f, px + xx, py + yy, c & 0xFFFFFF);
        }
    }
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
/* river continuity mask: cardinal neighbours that also carry the river bit
 * (0x40). Indexes the river row (PHYS0 0x00..0x0F); index 0 is a placeholder so
 * an isolated river cell is bumped to a visible 4-way piece. N=8,S=4,W=2,E=1. */
static int river_nmask(const mp_map *m, int x, int y)
{
    int k = 0;
    if (L1at(m, x, y - 1) & 0x40) k |= 8;
    if (L1at(m, x, y + 1) & 0x40) k |= 4;
    if (L1at(m, x - 1, y) & 0x40) k |= 2;
    if (L1at(m, x + 1, y) & 0x40) k |= 1;
    return k ? k : 0x0F;
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

/* ---- Coast: sand-edge beaches from the pixel-verified PHYS0 corner sprites ----
 * The original's coast sub-cells live at PHYS0 row 0x70 (8x8) / 0x90 (16x16);
 * the four sprites 0x96..0x99 are "ocean with sand toward a corner/edge"
 * (SPRITE_CATALOG.md row 0x90). 0x96 has sand at the NW corner — top + left
 * edges — and we mirror it to face any corner. For a WATER tile we look at its
 * 4 cardinal LAND neighbours and pick a sprite + flip so the sand runs along the
 * land-facing edges. Open ocean (no land neighbour) draws nothing — plain base.
 *
 * NOTE: the exact mask->sprite+flip table is approximated here (the byte-exact
 * one lives inside MAPEDIT's _buffer_tile compositor); it is verified visually.
 * What matters vs. the old code: these are REAL beach sprites, never the black
 * "null padding" frames 0x6C..0x6F the previous composer indexed. */
static void compose_coast(fb *f, int px, int py, int tp, const mp_map *m, int tx, int ty)
{
    /* cardinal land mask: N=8, E=4, S=2, W=1 */
    int N = !water_at(m, tx, ty - 1);
    int E = !water_at(m, tx + 1, ty);
    int S = !water_at(m, tx, ty + 1);
    int W = !water_at(m, tx - 1, ty);
    int mask = (N << 3) | (E << 2) | (S << 1) | W;
    if (mask == 0) return;                  /* open ocean: plain base */

    /* base sprite 0x96 = sand at NW (top+left). Mirror to orient the sand:
     *   no flip   -> sand top+left   (covers N and/or W)
     *   hflip     -> sand top+right  (N and/or E)
     *   vflip     -> sand bottom+left(S and/or W)
     *   h+vflip   -> sand bottom+right(S and/or E)
     * For straight cardinal edges this still bleeds sand along that edge, which
     * reads as a beach. Three-/four-sided cases use the wider 0x99 sprite. */
    int idx = PH_COAST;     /* 0x96 */
    int hflip = 0, vflip = 0;

    int sides = N + E + S + W;
    if (sides >= 3) {
        idx = 0x99;                 /* sand on three sides */
        /* leave open side toward the lone water neighbour via flips */
        if (!N) vflip = 1;          /* open at N -> push sand down  */
        if (!W) hflip = 1;          /* open at W -> push sand right */
    } else {
        /* choose the corner that the present land sides share */
        vflip = (S && !N);          /* sand toward bottom if S land (and not N) */
        hflip = (E && !W);          /* sand toward right  if E land (and not W) */
    }
    blit_phys0_flip(f, px, py, tp, idx, hflip, vflip);
}

/* Representative minimap colour for a tile, mirroring MAPEDIT's _get_tile_colors
 * (which samples a colour per classified terrain id). We average the tile's
 * actual sprite: base ground for land/water, the PHYS0 hill/mtn/forest overlay
 * for elevated/forested tiles. Falls back to terrain_color() with no sheet. */
uint32_t sprite_minimap_color(uint8_t b)
{
    uint8_t id = MP_TERRAIN_ID(b);
    if (!g_have_sheet)
        return terrain_color(id);

    /* hills / mountains (bit 0x20): sample the PHYS0 elevation sprite */
    if ((b & 0x20) && !is_water_id(id)) {
        int idx = (b & 0x80) ? (PH_MTN + 5) : (PH_HILL + 5);
        uint32_t c = (g_phys0 && idx < g_phys0->count)
                         ? frame_avg(&g_phys0->frames[idx]) : 0;
        if (c) return c;
    }
    /* forest (visible band 8..23): sample the forest canopy sprite */
    if (id >= 8 && id < 24 && !is_water_id(id)) {
        int idx = PH_FOREST + 0x0F;     /* full canopy */
        uint32_t c = (g_phys0 && idx < g_phys0->count)
                         ? frame_avg(&g_phys0->frames[idx]) : 0;
        if (c) return c;
    }
    /* base ground (incl. water): average the TERRAIN.SS tile */
    int bf = g_terr_frame[id];
    if (g_terrain && bf >= 0 && bf < g_terrain->count) {
        uint32_t c = frame_avg(&g_terrain->frames[bf]);
        if (c) return c;
    }
    return terrain_color(id);
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

    /* 6d. river-on-terrain: terrain bit 0x40 -> PHYS0 river row 0x00 + continuity
     * mask (green/tan banks). Was wrongly 0x96, which is a coast beach sprite. */
    if (b & 0x40)
        blit_phys0(f, px, py, tp, PH_RIVER + river_nmask(m, tx, ty));

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
