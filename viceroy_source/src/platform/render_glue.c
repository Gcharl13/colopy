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
static const uint8_t *g_layer[3];          /* terrain, feature, resfog */
static long           g_wp[3];             /* committed per-tile offsets */
static long           g_layer_len;

void viceroy_map_attach(const uint8_t *terrain, const uint8_t *feature,
                        const uint8_t *resfog, int w, int h)
{
    g_layer[0] = terrain; g_layer[1] = feature; g_layer[2] = resfog;
    g_layer_len = (long)w * h;
    DG16(G_MAP_W) = (uint16_t)w;
    DG16(G_MAP_H) = (uint16_t)h;
    DG16(G_RENDER_STRIDE) = (uint16_t)w;   /* row stride in the layer arrays */
    DG16(G_LAYERS_RESIDENT) = 1;           /* fast path */
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
uint8_t wp_feature_rel(int16_t off) { return wp_rel(1, off); }
uint8_t wp_resfog_rel(int16_t off)  { return wp_rel(2, off); }

/* ---- render_frame_setup (func_06787C semantics) ---------------------------- */
void render_frame_setup(void)
{
    int zoom = (int16_t)DG16(G_ZOOM_LEVEL);
    int px   = 0x10 >> zoom;
    DG16(G_TILE_PX_W) = (uint16_t)px;
    DG16(G_TILE_PX_H) = (uint16_t)px;
    DG8(G_SHEET_METRIC) = (uint8_t)(0x64 >> zoom);

    int span_w = 0x0F << zoom, span_h = 0x0C << zoom;
    DG16(G_SPAN_W) = (uint16_t)span_w;
    DG16(G_SPAN_H) = (uint16_t)span_h;

    int w = (int16_t)DG16(G_MAP_W), h = (int16_t)DG16(G_MAP_H);
    int oc = (int16_t)DG16(G_VIEW_ORIGIN_COL);
    int orow = (int16_t)DG16(G_VIEW_ORIGIN_ROW);
    if (oc < 1) oc = 1;
    if (orow < 1) orow = 1;
    if (oc > w - span_w - 1) oc = w - span_w - 1;
    if (orow > h - span_h - 1) orow = h - span_h - 1;
    DG16(G_VIEW_ORIGIN_COL) = (uint16_t)oc;
    DG16(G_VIEW_ORIGIN_ROW) = (uint16_t)orow;
    DG16(G_VIEW_MAX_COL) = (uint16_t)(oc + span_w - 1);
    DG16(G_VIEW_MAX_ROW) = (uint16_t)(orow + span_h - 1);
    DG16(G_PIX_BASE_COL) = 0;
    DG16(G_PIX_BASE_ROW) = 0;

    /* default clip = map viewport area */
    DG16(G_CLIP_RECT + 0) = 0;
    DG16(G_CLIP_RECT + 2) = 0;
    DG16(G_CLIP_RECT + 4) = (uint16_t)(span_w * px - 1);
    DG16(G_CLIP_RECT + 6) = (uint16_t)(span_h * px - 1);
}

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
