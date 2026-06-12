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

/* string-measure leaf 0xC2A:6 (= thunk 0x181F:0x204 -> resident func_00E6A6):
 * sums the glyph widths with inter-char spacing AX, and every byte-cited
 * caller passes ax=0.  MODERN: measured with spacew=1 to hug what vid_text_xy
 * actually renders (ff_draw advances cw+1) -- same convention as
 * bar_count_badge below. */
int vid_text_width(const char *s)
{
    ff_font_t *f = viceroy_font();
    return f ? ff_text_width(f, s, 1) : 0;
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
/* byte0 of the [0x89E] text ctx (the DOS `les bx,[0x89E]; mov al,es:[bx]`
 * idiom, e.g. func_00386A label_h = ctx[0]+3 @0x3AB3..0x3ABF) */
int vid_text_ctx_byte0(void) { return g_text_ctx[0]; }

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
/* height sibling (@asm 0x0271D2 es:[bx+0x40], bx = id*0xC + [0x83E]) */
int sheet_frame_h_icons(int id)
{
    const ss_sheet_t *s = sheet_at(G_SHEET_ICONS);
    return (s && id >= 0 && id < s->nframes) ? (int)s->frames[id].h : 0;
}

/* 0x181F:0xCE -> resident func_00E0A2 (file 0xE0A2..0xE145): 1-px rectangle
 * OUTLINE.  Register corners ax=x1 dx=y1 bx=x2 plus pushed y2; each pair is
 * normalized (X swap @0xE0A8..0xE0B3, Y swap @0xE0B6..0xE0C6), then the four
 * edges are stroked through the clipped run leaves, endpoints INCLUSIVE
 * (run = hi-lo+1): rows via func_00DFCC (top @0xE0C9, bottom @0xE0E7) and
 * columns via func_00E036 (left @0xE105, right @0xE123).  The 4 pushed
 * descriptor words [0x2DAE],[0x2DAC],[0x2DAA],[0x2DA8] = seg, base,
 * width/stride, height = the 320x200 screen; per-edge clip: an edge whose
 * fixed row/col lies outside [0,dim) is dropped whole (@0xDFD4/@0xE03E),
 * the run ends clamp into [0,dim-1] (@0xDFDF../@0xE04A..).  Colour = low
 * byte of the last pushed word ([bp+6], mov al @0xE0D5). */
void draw_box(int x1, int y1, int x2, int y2, int color)
{
    uint8_t *fb = vid_framebuffer();
    int xl = (x1 < x2) ? x1 : x2, xh = (x1 < x2) ? x2 : x1;  /* @asm 0xE0A8 */
    int yl = (y1 < y2) ? y1 : y2, yh = (y1 < y2) ? y2 : y1;  /* @asm 0xE0B6 */
    int lo, hi, p;
    lo = (xl < 0) ? 0 : xl;                       /* h-run clamps (func_00DFCC) */
    hi = (xh > VID_W - 1) ? VID_W - 1 : xh;
    for (p = lo; p <= hi; p++) {
        if (yl >= 0 && yl < VID_H) fb[yl * VID_W + p] = (uint8_t)color; /* top */
        if (yh >= 0 && yh < VID_H) fb[yh * VID_W + p] = (uint8_t)color; /* bottom */
    }
    lo = (yl < 0) ? 0 : yl;                       /* v-run clamps (func_00E036) */
    hi = (yh > VID_H - 1) ? VID_H - 1 : yh;
    for (p = lo; p <= hi; p++) {
        if (xl >= 0 && xl < VID_W) fb[p * VID_W + xl] = (uint8_t)color; /* left */
        if (xh >= 0 && xh < VID_W) fb[p * VID_W + xh] = (uint8_t)color; /* right */
    }
}
void draw_text(int x, int y, const char *buf) { vid_text_xy(buf, x, y); }
void enter_screen_view(int bx_screen_id) { (void)bx_screen_id; }

/* ============================================================================
 * Colony-screen icon-run / warehouse-bar leaves (wired 2026-06-12).
 * Thunk resolutions (tools/whois.py):
 *   0x181F:0x218 -> 0097:067A  file 0x33EA    bar-queue reset
 *   0x181F:0x222 -> 0097:0682  func_0033F2    bar-queue push
 *   0x181F:0x22C -> 0097:0394  func_003104    bar-row flush (draws the queue)
 *   0x181F:0x236 -> 0097:0174  func_002EE4    icon run (N sprites + badges)
 *   0x181F:0x24A -> 012B:015C  func_00380C    shadowed sprite (silhouette+blit)
 *   0x181F:0x506 -> 02DD:0064  func_005234    texture/flat rect fill
 * All draw from the ICONS sheet handle [0x83E] into the 320x200 screen
 * descriptor [0x2DA8..0x2DAE], like blit_sprite above.
 * ============================================================================ */

/* 0xCD8:4 -> resident func_00F184 (file 0xF184..0xF388): the SILHOUETTE blit.
 * Same frame directory (id*12+0x36) and RLE walk as the normal blit 0xC36:0xA,
 * but every opaque pixel writes the constant colour byte [bp+6]
 * (@0xF2FF/@0xF336/@0xF356 mov al,[bp+6]; mov es:[bx],al); 0xFD pixels stay
 * transparent (@0xF2FB cmp al,0xFD); sign bit of the id = horizontal flip
 * (@0xF19A..0xF1AD; not exercised by the colony ids -> masked, like
 * draw_tile_marker). */
void blit_sprite_solid(int id, int x, int y, int color)
{
    const ss_sheet_t *s = sheet_at(G_SHEET_ICONS);
    int idm = id & 0x7FFF;
    const ss_frame_t *f;
    uint8_t *fb;
    int r, c;
    if (!s || idm >= s->nframes) return;
    f  = &s->frames[idm];
    fb = vid_framebuffer();
    for (r = 0; r < (int)f->h; r++) {
        int py = y + r;
        if (py < 0 || py >= VID_H) continue;
        for (c = 0; c < (int)f->w; c++) {
            int px = x + c;
            if (px < 0 || px >= VID_W) continue;
            if (f->pixels[r * f->w + c] != SS_TRANSPARENT)
                fb[py * VID_W + px] = (uint8_t)color;
        }
    }
}

/* 0x181F:0x24A -> func_00380C (file 0x380C..0x3869), the worker-pip /
 * shadowed-sprite drawer.  DOS: one stack word (flags, retf 2) + regs
 * ax=sprite dx=x bx=y.  bit0 -> silhouette of the sprite at (x,y) in flat
 * colour (flags&4 ? 0x5F : 0) via 0xCD8:4 (@0x3818..0x383E: cmc/sbb/and 0x5F
 * folds bit2 into the colour); bit1 -> the normal sprite at (x+2,y) via
 * 0xC36:0xA (@0x3845..0x385E).  flags=3 = black drop-silhouette + sprite. */
void blit_sprite_shadowed(int flags, int id, int x, int y)
{
    if (flags & 1)
        blit_sprite_solid(id, x, y, (flags & 4) ? 0x5F : 0); /* @0x381E..0x383E */
    if (flags & 2)
        blit_sprite(0, id, x + 2, y);                        /* @0x3849..0x385E */
}

/* 0x181F:0x218 / 0x181F:0x222: the warehouse bar-chart QUEUE.  0x218 (file
 * 0x33EA) is `mov word [0x2CE0],0; retf`.  0x222 (func_0033F2, file
 * 0x33F2..0x341D) appends the register triple ax/dx/bx to three parallel
 * DGROUP word arrays -- ids [0x2CF4+i*2], values [0x2CCE+i*2], tails
 * [0x2CE2+i*2], count [0x2CE0] -- skipping NUL entries (dx==0 && bx==0,
 * @0x33F7..0x33FD).  Nothing draws until bar_row_flush walks the queue.
 * Id flag bits (consumed by the flush): 0x4000 = lead units drawn hollow
 * (sprite 0x3A), 0x8000 = every unit crossed out (sprite 0x38 overlay). */
void bar_queue_reset(void) { DG16(0x2CE0) = 0; }     /* @asm 0x33EA */

void bar_queue_push(int id, int value, int tail)
{
    uint16_t i = DG16(0x2CE0);                       /* @asm 0x33FF */
    if (value == 0 && tail == 0) return;             /* @asm 0x33F7/0x33FB */
    if (i >= 9) return;  /* MODERN GUARD: the arrays are 9 entries
                          * (0x2CCE..0x2CDF); DOS never queues more than 4 */
    DG16(0x2CF4 + i*2) = (uint16_t)id;               /* @asm 0x3405 */
    DG16(0x2CCE + i*2) = (uint16_t)value;            /* @asm 0x340C */
    DG16(0x2CE2 + i*2) = (uint16_t)tail;             /* @asm 0x3413 */
    DG16(0x2CE0) = (uint16_t)(i + 1);                /* @asm 0x3417 */
}

/* numeric count badge, near func_002E4E (file 0x2E4E..0x2EE3; shared by the
 * bar flush and the icon run): skip when value<=0 (@0x2E52); y+=2 (@0x2E5B);
 * itoa via 0xD1D:0x8FA (@0x2E68); measure via 0xC2A:6 (@0x2E7F, dec'd --
 * the resident func_00E6A6 sums the glyph widths with inter-char spacing AX,
 * called with ax=0, so the DOS box = glyph sum + 1); boxed -> black backing
 * box (x, y, h=7) via the fill leaf 0xB9E:0xA (@0x2E8E..0x2EAC, bx=w+2 /
 * pushes desc4,7,0); set the text colour (0xC28:0xA @0x2EBC) and draw the
 * digits at (x+1, y+1) (0xC11:0xC @0x2EDC).  MODERN: measured with spacew=1
 * to hug what vid_text_xy actually renders (ff_draw advances cw+1). */
static void bar_count_badge(int value, int x, int y, int color, int boxed)
{
    char buf[0x16];                                  /* [bp-0x16] */
    ff_font_t *f = viceroy_font();
    int w;
    if (value <= 0 || !f) return;                    /* @0x2E52 */
    y += 2;                                          /* @0x2E5B */
    snprintf(buf, sizeof buf, "%d", value);          /* 0xD1D:0x8FA */
    w = ff_text_width(f, buf, 1);                    /* 0xC2A:6 measure */
    if (boxed)
        vid_box_fill(x, y, w + 2, 7, 0);             /* @0x2E8E..0x2EAC */
    vid_text_color(color);                           /* @0x2EB1 0xC28:0xA */
    vid_text_xy(buf, x + 1, y + 1);                  /* @0x2EC1 0xC11:0xC */
}

/* sizer, near func_002D74 (file 0x2D74..0x2E4E): pick the per-icon x advance
 * for a run of `total` copies of sprite `id` in a cell `avail` px wide and
 * centre the run.
 *   base_w = ICONS hdr width [id*12+0x3E] (@0x2D95..0x2DA9), +2 if flags&2;
 *   rem_w  = avail - base_w (@0x2DB7);
 *   step   = total>1 ? clamp(rem_w/(total-1), 1, base_w+1) : 1 (@0x2DC0..);
 *   span   = (total-1)*step (@0x2DE9); while ((span>>shift) > rem_w) shift++
 *            (@0x2DF3..0x2E12); seg = (span>>shift) + base_w = run width;
 *   top    = ((slot_w-1 > seg) ? slot_w : avail) - seg (@0x2E14..0x2E28);
 *   *out_rem = top (@0x2E2B); slot_w!=0 -> *x += top>>1 (centre, @0x2E36..).
 * Returns step; 0 when either count register is 0 (@0x2D80/@0x2D87). */
static int icon_run_sizer(int flags, int16_t *out_shift, int16_t *out_rem,
                          int slot_w, int avail, int *x,
                          int spread, int total, int id)
{
    int base_w, rem_w, step, span, seg, top;
    if (spread == 0 || total == 0) return 0;         /* @0x2D80/@0x2D87 */
    *out_shift = 0;                                  /* @0x2D8E */
    base_w = sheet_frame_w_icons(id);                /* @0x2D95..0x2DA9 */
    if (flags & 2) base_w += 2;                      /* @0x2DAC */
    rem_w = avail - base_w;                          /* @0x2DB7 */
    if (total > 1) {                                 /* @0x2DC0 */
        step = rem_w / (total - 1);                  /* @0x2DCB idiv */
        if (step > base_w + 1) step = base_w + 1;    /* @0x2DD1 */
        if (step < 1) step = 1;                      /* @0x2DD7 */
    } else
        step = 1;                                    /* @0x2DE4 */
    span = (total - 1) * step;                       /* @0x2DE9..0x2DF0 */
    while ((span >> *out_shift) > rem_w && *out_shift < 15)
        (*out_shift)++;   /* @0x2DF3..0x2E12 (<15 = MODERN GUARD: the DOS
                           * loop never terminates when rem_w < 0) */
    seg = (span >> *out_shift) + base_w;             /* @0x2DFF/@0x2E02 */
    top = ((slot_w - 1 > seg) ? slot_w : avail) - seg;  /* @0x2E14..0x2E28 */
    if (out_rem) *out_rem = (int16_t)top;            /* @0x2E2B */
    if (slot_w != 0) *x += top >> 1;                 /* @0x2E36..0x2E44 */
    return step;                                     /* @0x2E46 */
}

/* 0x181F:0x236 -> func_002EE4 (file 0x2EE4..0x304A): the ICON RUN -- draw
 * `total` copies of sprite `id` along row y+1 starting at x (centred in
 * slot_w/avail by the sizer); the work-grid bonus markers and yield-amount
 * stacks.  DOS: 6 stack words (flags, filled, slot_w, avail, y, x =
 * bp+6..bp+0x10, retf 0xC) + regs ax=id dx=spread bx=total.  Per icon j
 * (j < total>>shift):
 *   flags&2 -> shadowed pip via 0x12B:0x15C(3; id, x, y+1)   (@0x2FEA..0x2FF6)
 *   else    -> sprite blit 0xC36:0xA(id, x, y+1)             (@0x2F66..0x2F7D)
 *   j == (total-filled)>>shift -> remember x for badge 2     (@0x2F82..0x2F8D)
 *   j >= (total-filled)>>shift -> cross-out overlay 0x38     (@0x2F90..0x2FAF)
 *   x += step (@0x2FB4); flags&1 -> Bresenham-spread the sizer leftover
 *   (acc += rem; while (acc >= spread>>shift) {acc-=..; x++}) (@0x2FBA..0x2FD4)
 * Badges when [0x70] != 0 or (step==1 && total>1) (@0x2FFE..0x3015):
 * (total-filled [+parity rounding @0x2F45..0x2F55]) at start x+2 colour 0xF
 * and `filled` at the remembered boundary +2 colour 0xC (@0x301B/@0x3032). */
void draw_icon_run(int flags, int filled, int slot_w, int avail,
                   int y, int x, int id, int spread, int total)
{
    int16_t shift = 0, rem = 0;            /* [bp-0x14], [bp-4] */
    int last_full = 0;                     /* [bp-0x12] @0x2EEB */
    int step, acc, fill, fill_badge, fill_sh, inner, nrows, start_x, j, show;

    step = icon_run_sizer(flags, &shift, &rem, slot_w, avail, &x,
                          spread, total, id);        /* @0x2EF0..0x2F09 */
    if (step == 0) return;                           /* @0x2F0F */
    acc        = 0;                                  /* [bp-8]    @0x2F16 */
    fill       = total - filled;                     /* [bp-0x18] @0x2F21 neg */
    fill_badge = fill;                               /* [bp-6]    @0x2F29 */
    fill_sh    = fill >> shift;                      /* @0x2F32 */
    inner      = spread >> shift;                    /* [bp-0xC]  @0x2F35 */
    nrows      = total >> shift;                     /* [bp-0x1A] @0x2F3D */
    if (shift != 0 && (filled & fill_badge & 1))     /* @0x2F45..0x2F53 */
        fill_badge++;                                /* @0x2F55 */
    start_x    = x;                                  /* [bp-0xE]  @0x2F58 */
    for (j = 0; j < nrows; j++) {                    /* [bp-0x10] @0x2FD9 */
        if (flags & 2)                               /* @0x2FE1 */
            blit_sprite_shadowed(3, id, x, y + 1);   /* @0x2FEA 0x12B:0x15C */
        else
            blit_sprite(0, id, x, y + 1);            /* @0x2F66 0xC36:0xA */
        if (fill_sh == j) last_full = x;             /* @0x2F82..0x2F8D */
        if (fill_sh <= j)                            /* @0x2F90 */
            blit_sprite(0, 0x38, x, y + 1);          /* @0x2F98..0x2FAF */
        x += step;                                   /* @0x2FB4 */
        if (flags & 1) {                             /* @0x2FBA */
            acc += rem;                              /* @0x2FC0 */
            while (acc >= inner && inner > 0) {      /* inner>0 MODERN GUARD */
                acc -= inner; x++;                   /* @0x2FC8..0x2FCB */
            }
        }
    }
    show = (int16_t)DG16(0x0070);                    /* [bp-2] @0x2FFE */
    if (step == 1 && total > 1) show = 1;            /* @0x3004..0x3010 */
    if (show) {                                      /* @0x3015 */
        bar_count_badge(fill_badge, start_x + 2, y, 0xF, 1);   /* @0x301B */
        bar_count_badge(filled, last_full + 2, y, 0xC, 1);     /* @0x3032 */
    }
}

/* 0x181F:0x22C -> func_003104 (file 0x3104..0x33E9): FLUSH the bar queue --
 * lay the queued bars left to right from `x` on row `y`, each bar = `value`
 * unit sprites (id & 0xFFF) stepped min(width+1, scale) px (scale = leftover
 * width / total extra units @0x31D4, falling back to a binary shift of the
 * unit counts when scale==0 @0x31DF..0x31ED), `spacing` px between bars
 * (squeezed first, then the per-sprite width, @0x3181..0x31CC).  Unit j of
 * bar i: id bit 0x4000 -> the lead units (j < (value-tail)>>shift) draw the
 * hollow sprite 0x3A (@0x32D7) and the tail ones the real id; bit 0x8000 ->
 * every unit overlaid with sprite 0x38 (@0x3253); plain ids overlay 0x38 on
 * the tail units only (@0x3258..0x3263).  Count badges when [0x70] != 0 (or
 * step==1 with value>1, @0x32E8..0x3305): lead count at bar start +2, colour
 * 0x8000?0xC:0xF; tail count at the tail boundary +2, colour 0x4000?0xF:0xC;
 * bit 0x4000 folds the tail into the lead count and zeroes the tail badge
 * (@0x3317..0x3321).  DOS: regs ax=x dx=y bx=x_limit + one stack word
 * (spacing, retf 2). */
void bar_row_flush(int x, int y, int x_limit, int spacing)
{
    int n = (int16_t)DG16(0x2CE0);
    int n_multi = 0, extra = 0;              /* [bp-0x20], [bp-0xA] */
    int wsum = 0, squeeze = 0;               /* [bp-0xC],  [bp-0xE] */
    int avail = 0, scale = 0, shift = 0;     /* [bp-4], [bp-0x22], [bp-0x1C] */
    int i, j;

    for (i = 0; i < n; i++) {                /* @0x3122..0x3143 */
        int v = (int16_t)DG16(0x2CCE + i*2); /* (the total [bp-0x24] is dead) */
        if (v > 1) { n_multi++; extra += v - 1; }   /* @0x312D..0x3136 */
    }
    for (i = 0; i < n; i++)                  /* @0x3150..0x317A */
        wsum += sheet_frame_w_icons((int16_t)DG16(0x2CF4 + i*2) & 0xFFF);
    for (;;) {                               /* @0x3181..0x31CC squeeze */
        int cx = wsum - n * squeeze;         /* @0x3184..0x318A imul; neg */
        if (cx < 0) cx = 0;                  /* @0x318E..0x3190 */
        avail = (1 - n) * spacing - cx + x_limit;   /* @0x3194..0x31A3 */
        if (avail < n_multi) {               /* @0x31A6 */
            if (spacing > 0)      spacing--; /* @0x31AB/@0x31B1 */
            else if (cx > 0)      squeeze++; /* @0x31B6/@0x31BA */
            else                  avail = n_multi;  /* @0x31C0 */
        }
        if (n_multi <= avail) break;         /* @0x31C6..0x31CC */
    }
    if (extra != 0) {                        /* @0x31CE */
        scale = avail / extra;               /* @0x31D4 idiv */
        if (scale == 0)                      /* @0x31DB */
            do { shift++; } while ((extra >> shift) > avail && shift < 15);
                  /* @0x31DF..0x31ED (<15 = MODERN GUARD, see icon_run_sizer) */
    }
    for (i = 0; i < n; i++) {                /* [bp-0x16] @0x31EF/@0x33A6 */
        int id_full = (int16_t)DG16(0x2CF4 + i*2);
        int id      = id_full & 0xFFF;       /* and ah,0xF @0x323C */
        int value   = (int16_t)DG16(0x2CCE + i*2);
        int tail    = (int16_t)DG16(0x2CE2 + i*2);
        int lead    = value - tail;          /* [bp-0x1A] @0x3205..0x320D */
        int lead_sh = lead >> shift;         /* [bp-8]    @0x3210 */
        int label_x = x;                     /* [bp-0x12] @0x3215 */
        int mark_x  = -1;                    /* [bp-0x18] @0x321B */
        int step, show;                      /* [bp-0x1E], [bp-2] */
        if (scale == 0)
            step = 1;                        /* @0x31F8 */
        else {                               /* @0x33B8..0x33DE */
            step = sheet_frame_w_icons(id) + 1;
            if (step > scale) step = scale;
        }
        for (j = 0; j < (value >> shift); j++) {     /* [bp-0x14] @0x329C */
            int hollow = (id_full & 0x4000) && j < lead_sh; /* @0x32C2/@0x32CC */
            if (j == lead_sh) mark_x = x;            /* @0x32AF..0x32BA */
            blit_sprite(0, hollow ? 0x3A : id, x, y);
                       /* @0x3228 (id) / @0x32D7 (0x3A), both via 0xC36:0xA */
            if (!hollow &&
                ((id_full & 0x8000) ||               /* @0x3253 */
                 (j >= lead_sh && !(id_full & 0x4000)))) /* @0x3258/@0x3260 */
                blit_sprite(0, 0x38, x, y);          /* @0x3265..0x327A */
            if ((value >> shift) - 1 > j)            /* @0x327F..0x3291 */
                x += step;                           /* @0x3293..0x3296 */
        }
        show = (int16_t)DG16(0x0070);                /* @0x32E8 */
        if (step == 1 && value > 1) show = 1;        /* @0x32EE..0x3300 */
        if (show) {                                  /* @0x3305 */
            int lead2 = lead, tval = tail;           /* [bp-0x1A], [bp-6] */
            if (id_full & 0x4000) { lead2 += tail; tval = 0; } /* @0x3317.. */
            bar_count_badge(lead2, label_x + 2, y,
                            (id_full & 0x8000) ? 0xC : 0xF, 1); /* @0x3326.. */
            bar_count_badge(tval, mark_x + 2, y,
                            (id_full & 0x4000) ? 0xF : 0xC, 1); /* @0x3355.. */
        }
        x += sheet_frame_w_icons(id) - squeeze + spacing;  /* @0x337C..0x33A0 */
    }
}

/* 0x181F:0x506 -> func_005234 (file 0x5234..0x5294): rect background fill.
 * DOS: when the texture-block slot [0x82C] is set (the map-screen init
 * overlay_0745F0 @0x0762C0 points it at the 0x20x0x18 block decoded into
 * DGROUP:0x93F0), TILE that texture across (x,y,w,h) via the strip copier
 * 0xBF5:0 (@0x523E..0x526E; func_00E350: phase = (x,y) mod (32,24) anchored
 * at the pushed (0,0), strips via 0xBAA:6) -- the terrain-weave backdrop
 * behind the colony work grid.  The decoded block lives in DOS far memory
 * with no host-side image (its 0x181F:0x254 layer-decode is unported), so
 * the texture path is NOT YET PORTABLE; MODERN: the byte-cited fallback path
 * (@0x5272..0x5293, taken when [0x82C]==0): flat fill with the caller's
 * colour via the fill leaf 0xB9E:0xA (regs ax=x dx=y bx=w; pushes desc4
 * [bp+0xC..6], h [bp+0x14], colour byte [bp+0x16]). */
void texture_fill_rect(int x, int y, int w, int h, int color)
{
    vid_box_fill(x, y, w, h, (uint8_t)color);
}

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

/* ---- resident-segment display leaves (headless no-ops) ---------------------
 * These are calls into the EXE's resident code with register-arg conventions
 * (not RTLink thunks).  In headless/modern mode they are pure display ops
 * that touch no game state; strong no-ops here override the weak stubs. */

/* 0x0B9E:0x000A — draw glyph / column cell fill (register args: ax=x, dx=y,
 * bx=w; used by colony_screen composers in load_image_00AB2E_00C0D0 / 0024C6) */
int overlay_call_0B9E_000A(void) { return 0; }

/* 0x0B70:0x003A — cell refresh / invalidate (register arg: dx=tile_index;
 * used alongside 0B9E:000A to redraw a colony-screen cell after painting) */
int overlay_call_0B70_003A(void) { return 0; }

/* 0x181F:0xC22 → file 0x0BC06 — colony screen compositor.
 * Triggers the full colony-screen repaint (calls two internal render chains).
 * Headless: no-op (screen is not visible). */
void colony_screen_compose(void) { }
