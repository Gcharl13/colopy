/* ============================================================================
 * render_glue.c -- platform implementation of the byte-verified map renderer's
 *                  leaf layer (replaces src/render/blit.c's DOS thunk wrappers)
 * ----------------------------------------------------------------------------
 * The map frame is composed ENTIRELY by the decompiled chain
 *     map_view_render (func_O514) -> tile_dispatch (func_O513)
 *     -> tile_compose_subcells (func_O512) + the nmask/connectivity helpers
 * (src/render/tile_chain.c + terrain.c, BYTE_VERIFIED).  That code picks every
 * sprite -- terrain bases, coast pieces, rivers, roads, forest/mountain/hill
 * variants, centre specials -- with the original's logic.  This file supplies
 * only what the original took from the machine/runtime:
 *
 *  1. the LAYER PLUMBING: the original walks three far pointers into the map
 *     layer heap (bases at DGROUP [0x15C]/[0x160]/[0x168], working pointers
 *     committed per tile at [0xA594]/[0xA598]/[0xA59C]; fast-path math
 *     base + (relrow+1)*stride[0x8548] + (relcol+1), @verify O514
 *     0x68684..0x6886E).  Modern: the three layers are host buffers and
 *     wp_commit()/wp_*_rel() implement exactly that arithmetic.
 *  2. render_frame_setup (0x191F:0x18E -> func_06787C): viewport geometry --
 *     tile_px = 0x10>>zoom[0x184] -> [0x5AD4]/[0x8326]; spans 0xF/0xC<<zoom ->
 *     [0x8544]/[0x8546]; origin clamp to [1, dim-span-1] -> [0x8328]/[0x832E];
 *     max = origin+span-1 -> [0x8804]/[0x8806].  (Per the RENDER_CHAIN spec of
 *     func_06787C; reimplemented here pending its direct port.)
 *  3. the four LEAF EMITTERS (the only never-decoded pixel pokes):
 *     destination = ([0xA5A4]-8, [0xA5A6]-0xF) + nudge ([0x1EA4],[0x1EA5]),
 *     clip rect [0x839E..], sheet selection: ground/terrain emitters draw from
 *     the TERRAIN sheet [0x16C], marker/alt emitters from the PHYS sheet
 *     [0x174].  Sprite codes are 1-BASED sheet frame indices (validated:
 *     forest codes 0x41.. == PHYS0 frames 64.., mountains 0x21.. == 32..,
 *     rivers 0x52.. == 81.., shore edges 0x8D.. == 140..).
 *
 * Sheet "far pointers": the DGROUP slots hold small HANDLES into a host-side
 * sheet registry (the 16-bit slots cannot hold host pointers; the handle is
 * written/read only by this file, so the model is self-consistent).
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include <stdint.h>
#include <string.h>

#include "viceroy_types.h"
#include "dgroup.h"
#include "platform.h"

/* ---- DGROUP addresses (same names/offsets as tile_chain.c) ---------------- */
#define G_LAYER_TERRAIN  0x015C
#define G_LAYER_FEATURE  0x0160
#define G_LAYER_RESFOG   0x0168
#define G_LAYERS_RESIDENT 0x015A
#define G_SHEET_TERRAIN  0x016C   /* handle slot: TERRAIN.SS */
#define G_SHEET_PHYS     0x0174   /* handle slot: PHYS0.SS   */
#define G_SHEET_METRIC   0x0186
#define G_ZOOM_LEVEL     0x0184
#define G_TILE_PX_W      0x5AD4
#define G_TILE_PX_H      0x8326
#define G_SPAN_W         0x8544
#define G_SPAN_H         0x8546
#define G_VIEW_ORIGIN_COL 0x8328
#define G_VIEW_ORIGIN_ROW 0x832E
#define G_VIEW_MAX_COL   0x8804
#define G_VIEW_MAX_ROW   0x8806
#define G_PIX_BASE_COL   0x832A
#define G_PIX_BASE_ROW   0x832C
#define G_RENDER_STRIDE  0x8548
#define G_MAP_W          0x853A
#define G_MAP_H          0x853C
#define G_TILE_SX        0xA5A4
#define G_TILE_SY        0xA5A6
#define G_NUDGE_DX       0x1EA4
#define G_NUDGE_DY       0x1EA5
#define G_CLIP_RECT      0x839E   /* x0,y0,x1,y1 words */

#include <stdio.h>
static int g_emit_log;

/* ---- layer plumbing -------------------------------------------------------- */
static const uint8_t *g_layer[4];          /* terrain, feature, resfog, region */
static uint8_t g_region_layer[64*80];       /* layer [0x164]: computed at load */
static long           g_wp[3];             /* committed per-tile offsets */
static long           g_layer_len;

void viceroy_map_attach(const uint8_t *terrain, const uint8_t *feature,
                        const uint8_t *resfog, int w, int h)
{
    g_layer[0] = terrain; g_layer[1] = feature; g_layer[2] = resfog;
    g_layer_len = (long)w * h;
    /* layer [0x164] (region/lake ids; the original computes it at map load --
     * loader not yet decoded): RECONSTRUCTED as water-region nibbles via
     * edge-connected flood fill: open ocean = 1, enclosed lakes = 2.., land=0.
     * The byte-cited CONSUMER (func_005DBA lake test: nibble==1 = sailable)
     * matches this model. */
    {
        memset(g_region_layer, 0, sizeof g_region_layer);
        static long st[4176]; int sp = 0;
        #define ISW(o) ((terrain[o] & 0x1F) == 0x19 || (terrain[o] & 0x1F) == 0x1A)
        for (int x = 0; x < w; x++) {
            long o1 = x, o2 = (long)(h-1)*w + x;
            if (ISW(o1) && !g_region_layer[o1]) { g_region_layer[o1]=1; st[sp++]=o1; }
            if (ISW(o2) && !g_region_layer[o2]) { g_region_layer[o2]=1; st[sp++]=o2; }
        }
        for (int y = 0; y < h; y++) {
            long o1 = (long)y*w, o2 = (long)y*w + w-1;
            if (ISW(o1) && !g_region_layer[o1]) { g_region_layer[o1]=1; st[sp++]=o1; }
            if (ISW(o2) && !g_region_layer[o2]) { g_region_layer[o2]=1; st[sp++]=o2; }
        }
        while (sp) {
            long o = st[--sp];
            long nb[4] = { o-1, o+1, o-w, o+w };
            for (int k = 0; k < 4; k++) {
                long q = nb[k];
                if (q < 0 || q >= (long)w*h) continue;
                if ((k<2) && q/w != o/w) continue;
                if (ISW(q) && !g_region_layer[q]) { g_region_layer[q]=1; st[sp++]=q; }
            }
        }
        int next = 2;
        for (long o = 0; o < (long)w*h; o++)
            if (ISW(o) && !g_region_layer[o]) {
                g_region_layer[o] = (uint8_t)next; st[sp++] = o;
                while (sp) {
                    long p = st[--sp];
                    long nb[4] = { p-1, p+1, p-w, p+w };
                    for (int k = 0; k < 4; k++) {
                        long q = nb[k];
                        if (q < 0 || q >= (long)w*h) continue;
                        if ((k<2) && q/w != p/w) continue;
                        if (ISW(q) && !g_region_layer[q]) { g_region_layer[q]=(uint8_t)next; st[sp++]=q; }
                    }
                }
                if (next < 15) next++;
            }
        #undef ISW
        g_layer[3] = g_region_layer;
    }
    DG16(G_MAP_W) = (uint16_t)w;
    DG16(G_MAP_H) = (uint16_t)h;
    /* SLOW path ([0x15A]=0): the ported render_frame_setup then sets
     * stride = full map width (@0x679E8) -- exactly what the host-side
     * wp_* plumbing implements. */
    DG16(G_LAYERS_RESIDENT) = 0;
    { extern void tilehead_reset(int,int); tilehead_reset(w, h); }
    { extern void viceroy_save_bind_layers(void); viceroy_save_bind_layers(); }
}

/* commit the 3 working pointers for the CURRENT tile.
 * @verify O514 fast path: base + (relrow+1)*[0x8548] + relcol+1
 * (the +1s skip the map border ring) @0x68684..0x686BF / @0x68852-@0x6886E */
void wp_commit(int relcol, int relrow)
{
    int origin_col = (int16_t)DG16(G_VIEW_ORIGIN_COL);
    int origin_row = (int16_t)DG16(G_VIEW_ORIGIN_ROW);
    long off = (long)(origin_row + relrow) * (int16_t)DG16(G_RENDER_STRIDE)
             + (origin_col + relcol);
    g_wp[0] = g_wp[1] = g_wp[2] = off;
    if (g_emit_log)
        fprintf(stderr, "commit rel=%d,%d map=%d,%d byte=%02X SX=%d SY=%d\n",
                relcol, relrow, origin_col+relcol, origin_row+relrow,
                g_layer[0] ? g_layer[0][off] : 0xEE,
                (int16_t)DG16(0xA5A4), (int16_t)DG16(0xA5A6));
}

static uint8_t wp_rel(int layer, int16_t off)
{
    long o = g_wp[layer] + off;
    if (!g_layer[layer] || o < 0 || o >= g_layer_len) return 0;
    return g_layer[layer][o];
}
uint8_t wp_terrain_rel(int16_t off) { return wp_rel(0, off); }
/* absolute layer reads (the [0x15C]/[0x160]/[0x168] far-ptr model of the
 * load_image readers func_005CFE/005D32/005EE8; stride = map width per their
 * `imul [0x853A]` bodies) */
uint8_t viceroy_layer_byte(int layer, int x, int y)
{
    long o = (long)y * (int16_t)DG16(0x853A) + x;
    if (layer < 0 || layer > 3 || !g_layer[layer] || o < 0 || o >= g_layer_len)
        return 0;
    return g_layer[layer][o];
}

/* writable host address of a layer tile (the DOS far-address helpers, e.g.
 * func_005D84 for layer [0x164], return this in modern mode). Layer 3 is the
 * platform-owned region buffer; the .MP layers stay read-only. */
static uint8_t g_layer_scratch;
uint8_t *viceroy_layer_addr(int layer, int x, int y)
{
    long o = (long)y * (int16_t)DG16(0x853A) + x;
    if (layer == 3 && o >= 0 && o < (long)sizeof g_region_layer)
        return &g_region_layer[o];
    g_layer_scratch = 0;
    return &g_layer_scratch;
}
uint8_t wp_feature_rel(int16_t off) { return wp_rel(1, off); }
uint8_t wp_resfog_rel(int16_t off)  { return wp_rel(2, off); }

/* render_frame_setup: now PORTED byte-cited in src/render/tile_chain.c
 * (func_06787C, file 0x6787C..0x67A22); the spec-based reimplementation that
 * lived here is removed. */

/* ---- sheet registry -------------------------------------------------------- */
static const ss_sheet_t *g_sheets[8];
static int g_nsheets;

int viceroy_sheet_register(const ss_sheet_t *s)   /* returns handle (1-based) */
{
    if (g_nsheets >= 8) return 0;
    g_sheets[g_nsheets++] = s;
    return g_nsheets;
}
void viceroy_set_sheet_terrain(int handle) { DG16(G_SHEET_TERRAIN) = (uint16_t)handle; }
void viceroy_set_sheet_phys(int handle)    { DG16(G_SHEET_PHYS)    = (uint16_t)handle; }

static const ss_sheet_t *sheet_at(uint16_t slot)
{
    int h = (int16_t)DG16(slot);
    return (h >= 1 && h <= g_nsheets) ? g_sheets[h - 1] : 0;
}

/* ---- the four leaf emitters ------------------------------------------------
 * dest = ([0xA5A4]-8, [0xA5A6]-0xF) + signed nudge ([0x1EA4],[0x1EA5]);
 * clipped to [0x839E..]; sprite codes are 1-based frame indices. */
void viceroy_emit_log(int on) { g_emit_log = on; }

static void emit(const ss_sheet_t *s, int code)
{
    if (!s || code < 0 || code >= s->nframes) {
        if (g_emit_log)
            fprintf(stderr, "emit SKIP code=0x%X (%d) nframes=%d sheet=%s\n",
                    code, code, s ? s->nframes : -1,
                    s == sheet_at(G_SHEET_TERRAIN) ? "TERRAIN" : "PHYS");
        return;
    }
    if (g_emit_log)
        fprintf(stderr, "emit code=0x%X sheet=%s at %d,%d\n", code,
                s == sheet_at(G_SHEET_TERRAIN) ? "TERRAIN" : "PHYS",
                (int16_t)DG16(G_TILE_SX), (int16_t)DG16(G_TILE_SY));
    int x = (int16_t)DG16(G_TILE_SX) - 8 + (int8_t)DG8(G_NUDGE_DX);
    int y = (int16_t)DG16(G_TILE_SY) - 0xF + (int8_t)DG8(G_NUDGE_DY);
    /* honor the clip rect at [0x839E..] (x0,y0,x1,y1) like the resident blit */
    int cl[4] = { (int16_t)DG16(G_CLIP_RECT),     (int16_t)DG16(G_CLIP_RECT+2),
                  (int16_t)DG16(G_CLIP_RECT+4),   (int16_t)DG16(G_CLIP_RECT+6) };
    ss_blit_clip(s, code, x, y, cl[0], cl[1], cl[2], cl[3]);
}

/* PHYS-sheet markers -- BYTE-VERIFIED from the resident blit 0x181F:0x254
 * (file 0xE76A, resolved from the thunk record): directory entry =
 * code*12 + 0x36 (i.e. code IS the 0-based frame index, no transform,
 * @0xE796-@0xE7A8); sign bit = horizontal flip (@0xE783-@0xE78D dx=-1,
 * code &= 0x7FFF; flip path not yet exercised by the map codes). */
void draw_tile_marker(int sprite_idx)   { emit(sheet_at(G_SHEET_PHYS),    sprite_idx & 0x7FFF); }
void emit_sprite_alt(int sprite_idx)    { emit(sheet_at(G_SHEET_PHYS),    sprite_idx & 0x7FFF); }

/* TERRAIN-sheet code transform -- BYTE-VERIFIED from the resident blits'
 * shared helper func_03436 (file 0x3436..0x345E; called by both ground blits
 * 0x181F:0x25E -> file 0x3460 and 0x181F:0x268 -> file 0x34C4, resolved from
 * the thunk records):
 *   cmp 0x11 / cmp 0x09 -> return 8         @0x3439/@0x343F/@0x3445
 *   code >= 8           -> return code-0xF  @0x3450/@0x3456
 *   else                -> code unchanged
 * Cells are 0-BASED frames: the blit copies 16 rows of 16 bytes from
 * sheet_ptr + cell*0x100 (mov ah,cell; al=0 @0x3496; rep movsb @0x34B7) --
 * the loaded sheet is a flat 256-byte-per-cell array in frame order. */
static int terrain_cell_transform(int code)
{
    if (code == 0x11 || code == 0x09) return 8;
    if (code >= 8) return code - 0xF;
    return code;
}
void emit_ground_sprite(int sprite_idx) { emit(sheet_at(G_SHEET_TERRAIN), terrain_cell_transform(sprite_idx)); }
void emit_terrain_sprite(int sprite_idx){ emit(sheet_at(G_SHEET_TERRAIN), terrain_cell_transform(sprite_idx)); }

#endif /* _VICEROY_MODERN */

/* ---- colony-blit leaves (func_004314's resident calls; same cell model) ----
 * 0xC56:4 cell blit from the [0x83E] sheet slot (ICONS); 0xC28:0xA text color;
 * 0xC11:0xC text at x,y; 0xB9E:0xA small filled box. */
#define G_SHEET_ICONS  0x083E   /* handle slot: ICONS.SS (set by the shell) */
void viceroy_set_sheet_icons(int handle) { DG16(G_SHEET_ICONS) = (uint16_t)handle; }

void vid_cell_blit(int cell, int x, int y, int metric, int x_end)
{
    (void)metric; (void)x_end;
    const ss_sheet_t *s = sheet_at(G_SHEET_ICONS);
    if (!s || cell < 0 || cell >= s->nframes) return;
    /* dest semantics per func_004314: x arg = centre-ish column, y = row end;
     * the resident blit anchors cell at (x - w/2, y - h + 1) */
    const ss_frame_t *f = &s->frames[cell];
    ss_blit(s, cell, x - f->w / 2, y - f->h + 1);
}

static uint8_t g_text_color = 0x0F;
extern ff_font_t *viceroy_font(void);          /* main_modern provides */
void vid_text_color(int c) { g_text_color = (uint8_t)c; }
void vid_text_xy(const char *str, int x, int y)
{
    ff_font_t *f = viceroy_font();
    if (!f) return;
    f->colors[1] = f->colors[2] = f->colors[3] = g_text_color;
    ff_draw(f, str, x, y, 1);
}

void vid_small_box(int x, int y, int px, int color)
{
    uint8_t *fb = vid_framebuffer();
    for (int r = 0; r < px && y + r < VID_H; r++)
        for (int c = 0; c < px && x + c < VID_W; c++)
            if (x + c >= 0 && y + r >= 0)
                fb[(y + r) * VID_W + x + c] = (uint8_t)color;
}

/* ============================================================================
 * Sidebar / panel TEXT-BUILDER leaves (tile_info_panel.c's named externs).
 * The DOS bodies append into the caller's buffer through the text engine;
 * these are the modern semantic implementations over the platform font.
 * (Glyph-engine fidelity pending the 0x0C28 font-core decode.)
 * ============================================================================ */
#include <string.h>
extern const char *viceroy_str(uint16_t handle);

static void app(char *buf, const char *s) { strcat(buf, s); }

void ovly_text_newseg_11E(char *buf)              { buf[0] = 0; }
void ovly_text_appother_128(char *buf)            { (void)buf; }
void ovly_text_appsep_178(char *buf)              { app(buf, " "); }
void ovly_text_appcomma_1B4(char *buf)            { app(buf, ", "); }
void ovly_text_appother_10A(char *buf)            { (void)buf; }
void ovly_text_applabel_16E(uint16_t labelptr, char *buf)
{
    app(buf, viceroy_str(labelptr));
}
void ovly_text_appnum_182(uint16_t ss, char *buf, int16_t val)
{
    (void)ss;
    char t[16]; snprintf(t, sizeof t, "%d", val); app(buf, t);
}
void ovly_text_appd8_0D8(int16_t hi, int16_t lo, uint16_t ss, char *buf)
{
    (void)ss;
    long v = ((long)(uint16_t)hi << 16) | (uint16_t)lo;   /* gold dword */
    char t[24]; snprintf(t, sizeof t, "%ld", v); app(buf, t);
}
void ovly_text_drawcol_132(uint16_t ss, char *buf, int16_t y, int16_t x)
{
    (void)ss; vid_text_xy(buf, x, y);          /* current color */
}
void ovly_text_draw5_13C(uint16_t ss, char *buf, int16_t y, int16_t x,
                         int16_t col)
{
    (void)ss; vid_text_color(col); vid_text_xy(buf, x, y);
}
void ovly_panel_flush_E46(int16_t z)              { (void)z; }
int16_t ovly_tile_owner_visbits_74A(int16_t y, int16_t x)
{
    return (int16_t)viceroy_layer_byte(2, x, y);
}

/* ---- box primitives (minimap/panel frames; interiors = region manager) ---- */
void vid_box_outline(int x, int y, int w, int h, uint8_t color)
{
    uint8_t *fb = vid_framebuffer();
    for (int c = 0; c < w; c++) {
        if (y >= 0 && y < VID_H && x+c < VID_W)      fb[y*VID_W + x+c] = color;
        if (y+h-1 < VID_H && x+c < VID_W)            fb[(y+h-1)*VID_W + x+c] = color;
    }
    for (int r = 0; r < h; r++) {
        if (x >= 0 && x < VID_W && y+r < VID_H)      fb[(y+r)*VID_W + x] = color;
        if (x+w-1 < VID_W && y+r < VID_H)            fb[(y+r)*VID_W + x+w-1] = color;
    }
}
void vid_box_fill(int x, int y, int w, int h, uint8_t color)
{
    uint8_t *fb = vid_framebuffer();
    for (int r = 0; r < h && y+r < VID_H; r++)
        for (int c = 0; c < w && x+c < VID_W; c++)
            if (x+c >= 0 && y+r >= 0) fb[(y+r)*VID_W + x+c] = color;
}

/* ============================================================================
 * Minimap contents -- per-tile pixel plot at (0xFC,9) anchored window
 * [col0=0x9CCC, row0=0x9CCA], 0x37 x 0x26 tiles (hud.c byte-cited geometry).
 * Tile colors from the loaded NAMES @COLORS table [0x830..] -- role mapping
 * RECONSTRUCTED (the picker 0x1A1F:0x8CE interior is seg-21 AMBIG):
 * water -> [0x830], land -> [0x831], forest -> [0x832], mtn/hill -> [0x833].
 * ============================================================================ */
void minimap_draw_contents(void)
{
    int col0 = (int16_t)DG16(0x9CCC), row0 = (int16_t)DG16(0x9CCA);
    int w = (int16_t)DG16(G_MAP_W), h = (int16_t)DG16(G_MAP_H);
    uint8_t *fb = vid_framebuffer();
    for (int ty = 0; ty < 0x26; ty++) {
        for (int tx = 0; tx < 0x37; tx++) {
            int mx = col0 + tx, my = row0 + ty;
            if (mx < 0 || my < 0 || mx >= w || my >= h) continue;
            uint8_t t = viceroy_layer_byte(0, mx, my) & 0x1F;
            uint8_t f = viceroy_layer_byte(1, mx, my);
            uint8_t c;
            if (t == 0x19 || t == 0x1A)      c = DG8(0x830);
            else if (f & 0x20)               c = DG8(0x833);
            else if (viceroy_layer_byte(0, mx, my) & 0x80) c = DG8(0x832);
            else                              c = DG8(0x831);
            int px = 0xFC + tx, py = 9 + ty;
            if (px < VID_W && py < VID_H) fb[py*VID_W + px] = c;
        }
    }
}

/* ---- text-context slots ([0x89E] default / [0x268A] restore) --------------
 * DOS keeps far pointers to a font-context whose byte0 is the LINE HEIGHT
 * (tile_info_panel line_h = ctx[0]+1 @0x0430E8).  Modern: the slots hold a
 * HOST pointer (8 bytes; the 4-byte DOS slots 0x89E/0x268A are pointer-model
 * and excluded from byte-exact comparison like every pointer slot). */
static uint8_t g_text_ctx[8];
void viceroy_init_text_ctx(int line_height_minus1)
{
    g_text_ctx[0] = (uint8_t)line_height_minus1;
    void *p = g_text_ctx;
    memcpy(&DG8(0x089E), &p, sizeof p);
    memcpy(&DG8(0x268A), &p, sizeof p);
}

/* ---- per-tile occupancy head map ------------------------------------------
 * The DOS tile->chain-head state lives behind the 0x037F helpers (layer
 * [0x164] encoding not yet decoded).  MODERN: an explicit host map, updated
 * by unit_place_on_tile / unit_chain_unlink, read by unit_tile_head. */
static int16_t g_tile_head[64*80];
void tilehead_reset(int w, int h)
{
    for (long i = 0; i < (long)w*h && i < 64*80; i++) g_tile_head[i] = -1;
}
int  tilehead_get(int x, int y)
{
    int w = (int16_t)DG16(G_MAP_W);
    long o = (long)y*w + x;
    return (o >= 0 && o < 64*80) ? g_tile_head[o] : -1;
}
void tilehead_set(int x, int y, int head)
{
    int w = (int16_t)DG16(G_MAP_W);
    long o = (long)y*w + x;
    if (o >= 0 && o < 64*80) g_tile_head[o] = (int16_t)head;
}

/* ---- colony-screen painter leaves (src/ui/colony_screen.c externs) -------- */
void fill_rect(int x, int y, int w, int h)
{
    (void)x; (void)y; (void)w; (void)h;
    /* the original's fill leaf (0x7ED3 -> 0x191F:0x7EC) is undecoded, so the
     * flat fill is a no-op: the shell clears to black and draws the COLONY.PIK
     * band as the scene before the composer runs (see main_modern.c) */
}
void blit_band(int x, int y, int w, int h) { (void)x;(void)y;(void)w;(void)h; }
void blit_box_id(int x, int y, int w, int h, int id)
{
    (void)id;
    vid_box_outline(x, y, w, h, 0x0F);
}
void blit_sprite(int desc, int id, int x, int y)
{
    (void)desc;
    const ss_sheet_t *s = sheet_at(G_SHEET_ICONS);
    if (s && id >= 0 && id < s->nframes) ss_blit(s, id, x, y);
}
/* ICONS.SS header width read for the painters' centering math
 * (@asm 0x02825D es:[bx+si+0x152] -- per-frame width, stride 12) */
int sheet_frame_w_icons(int id)
{
    const ss_sheet_t *s = sheet_at(G_SHEET_ICONS);
    return (s && id >= 0 && id < s->nframes) ? (int)s->frames[id].w : 0;
}
void draw_text(int x, int y, const char *buf) { vid_text_xy(buf, x, y); }
void enter_screen_view(int bx_screen_id) { (void)bx_screen_id; }

/* ---- save/load map-layer bridge (integration 2026-06-10) -------------------
 * The serializers' externs (DOS layer ptrs at [0x15C..0x168], byte count at
 * [0x180]) become the attached host layers. Layer 3 = the computed region
 * nibbles (g_l164). */
void     *g_map_layer[4];
uint32_t  g_map_layer_bytes;
void viceroy_save_bind_layers(void)
{
    g_map_layer[0] = (void *)g_layer[0];
    g_map_layer[1] = (void *)g_layer[1];
    g_map_layer[2] = (void *)g_layer[2];
    g_map_layer[3] = (void *)g_layer[3];
    g_map_layer_bytes = (uint32_t)g_layer_len;
}
