/* ============================================================================
 *      >>> BYTE_VERIFIED (calling convention) / pixel poke TBD (cited) <<<
 * ----------------------------------------------------------------------------
 * The four leaf SPRITE-EMIT primitives the tile-render chain (O513/O512) calls
 * to paint one sprite cell. Hand-decompiled from the FULL bodies in
 * code/VICEROY/disasm_overlay_reseg/page_15.asm 2026-05-30:
 *
 *   func_067DC8 @0x67DC8 (NEAR ip 0x1748)  draw_tile_marker
 *   func_067E28 @0x67E28 (NEAR ip 0x17A8)  emit_ground_sprite
 *   func_067E8C @0x67E8C (NEAR ip 0x180C)  emit_sprite_alt   (alt overlay 0x1A1F)
 *   func_067EEC @0x67EEC (NEAR ip 0x186C)  emit_terrain_sprite
 *
 * COMMON SHAPE (all four): read a loaded sprite-sheet far-pointer pair, branch on
 * a zoom global, compute a destination from the tile origin [0xA5A4]/[0xA5A6]
 * minus the sprite half-extent ([0x1EA4] dX-8 / [0x1EA5] dY-15), pass the clip
 * rect &[0x839E], and LCALL into a load-image overlay that does the actual
 * masked blit. They differ in (a) which sheet pointer, (b) which zoom global,
 * (c) which overlay thunk, and (d) whether the sprite index in AX is forwarded.
 *
 * RESOLVED reconciliation of the long-standing "func_067DC8 = dialog rect"
 * question: func_067DC8 reads sheet ptr [0x174]/[0x176] and the sheet metric
 * [0x186] (= 0x64>>zoom, set by func_06787C). When [0x186] >= 0x64 (closest
 * zoom) it takes the path that calls 0x181F:0x254 -> overlay 0x0C36:0x000A —
 * the SAME resident setter the dialog code uses (UI ledger 2026-05-29). It does
 * NOT forward the AX sprite index. So in BOTH the dialog and the render chain it
 * paints from the currently-selected sheet cell + the marker/overlay globals;
 * the AX argument is vestigial at this callee. The PRIMARY terrain sprites flow
 * through func_067EEC / func_067E28, which DO push AX (the sprite index) into
 * their resident blit. Both facts are byte-verified below.
 *
 * STILL TBD (cited): the pixel format of the resident blit. Every path ends in
 * an LCALL whose target is in a load-image overlay (0x181F:0x254/0x25E/0x268/
 * 0x272/0x286/0x2F8 -> overlay segs 0x0C36/0x0101/0x0C56; 0x1A1F:0x984/0x98E ->
 * 0x0CAA/0x0C89 per lcall_resolution_VICEROY.json). Those bytes are not in the
 * decodable VICEROY.EXE code image, so we model index + placement + clip (all
 * verified) and leave the framebuffer write abstract.
 * ============================================================================ */

/* ============================================================================
 * blit.c -- Tile-render leaf sprite-emit primitives
 * ----------------------------------------------------------------------------
 * @asm_function   func_067DC8 / func_067E28 / func_067E8C / func_067EEC
 * @asm_offset     file 0x67DC8 / 0x67E28 / 0x67E8C / 0x67EEC
 * @asm_page       code/VICEROY/disasm_overlay_reseg/page_15.asm
 * @region         overlay page 0x15
 * @verified_by    Hand-decompiled from FULL VICEROY.EXE bodies 2026-05-30
 * @ref            lcall_resolution_VICEROY.json (thunk -> overlay targets)
 * @ref            ../ui/dialog.c (func_067DC8 dual role)
 * ============================================================================ */
#include "viceroy_types.h"

/* Sheet far-pointer pairs (the loaded PHYS0.SS / TERRAIN.SS surfaces). */
#define G_SHEET_PTR_A   0x0174   /* [0x174]/[0x176]  used by 067DC8 / 067E8C */
#define G_SHEET_PTR_B   0x016C   /* [0x16C]/[0x16E]  used by 067E28 / 067EEC */

/* Sheet metric / zoom flag the emitters branch on. */
#define G_SHEET_METRIC  0x0186   /* = 0x64>>zoom; cmp vs 0x64 (067DC8/067E8C) */
#define G_ZOOM_LEVEL    0x0184   /* != 0 => zoomed out (067E28/067EEC branch) */
#define G_STRAT_VIEW2   0x018E   /* secondary mode flag (read elsewhere) */

/* Tile origin + sub-cell nudge written by O514/O513. */
#define G_TILE_SX       0xA5A4
#define G_TILE_SY       0xA5A6
#define G_SUBCELL_DX    0x1EA4   /* sprite dX nudge (byte) */
#define G_SUBCELL_DY    0x1EA5   /* sprite dY nudge (byte) */
#define G_CLIP_RECT     0x839E   /* 4-word screen-bounds clip rect */

/* The resident blit thunks (load-image overlay; not decodable to EXE offsets).
 * Declared with their calling convention as decoded from the push sequences. */
extern void rblt_marker_full (int sx_minus8, int sy_minus15, int sheet_off, int sheet_seg); /* 0x181F:0x254 */
extern void rblt_marker_scaled(int metric, int sy, int sheet_off, int sheet_seg);            /* 0x181F:0x2F8 */
extern void rblt_sprite_full (int sheet_off, int sheet_seg, int sprite, int clip,
                              int sx_minus8, int sy_minus15);                                 /* 0x181F:0x25E / 0x268 */
extern void rblt_sprite_scaled(int sheet_off, int sheet_seg, int sprite, int clip,
                               int metric, int sy);                                           /* 0x181F:0x272 / 0x286 */
extern void rblt_alt_full    (int sx_minus8, int sy_minus15, int sheet_off, int sheet_seg);  /* 0x1A1F:0x98E */
extern void rblt_alt_scaled  (int metric, int sy, int sheet_off, int sheet_seg);             /* 0x1A1F:0x984 */

/* Helper: read a DGROUP far-pointer pair (offset then segment word). */
static int gp_off(int addr) { return (int)(*(volatile uint16_t *)(uint16_t)addr); }
static int gp_seg(int addr) { return (int)(*(volatile uint16_t *)(uint16_t)(addr + 2)); }

/* ----------------------------------------------------------------------------
 * func_067DC8 -- draw a marker / currently-selected sheet cell  (file 0x67DC8)
 * ----------------------------------------------------------------------------
 * @verify cx=[0x174], dx=[0x176] @0x67DCC/@0x67DD0; cmp [0x186],0x64 @0x67DDA;
 *   full path (jge): push dx,cx; cy=[0x1EA5]+[0xA5A6]-0xF; cx2=[0x1EA4]+[0xA5A4]-8;
 *   lea bx,[0x839E]; lcall 0x181F:0x254 @0x67DFE/@0x67E02; ret @0x67E08.
 *   scaled path (jl 0x178a): push [0x1EA5_ctx], [0x176], [0xA5A6], [0x186];
 *   lea bx,[0x839E]; dx=[0xA5A4]; lcall 0x181F:0x2F8 @0x67E20.
 * The AX sprite index is NOT referenced (see banner). */
void draw_tile_marker(int sprite_idx)
{
    int sheet_off = gp_off(G_SHEET_PTR_A);
    int sheet_seg = gp_seg(G_SHEET_PTR_A);
    (void)sprite_idx;   /* vestigial at this callee — confirmed @0x67DC8 body */

    if (gp_off(G_SHEET_METRIC) >= 0x64) {          /* @0x67DDA closest zoom */
        int cy = (int)(*(volatile uint8_t *)G_SUBCELL_DY)
                 + (int)(*(volatile uint16_t *)G_TILE_SY) - 0xF;   /* @0x67DE9-@0x67DED */
        int cx = (int)(*(volatile uint8_t *)G_SUBCELL_DX)
                 + (int)(*(volatile uint16_t *)G_TILE_SX) - 8;     /* @0x67DF7-@0x67DFB */
        rblt_marker_full(cx, cy, sheet_off, sheet_seg);            /* @0x67E02 */
    } else {                                       /* @0x67E0A scaled */
        rblt_marker_scaled((int)(*(volatile uint16_t *)G_SHEET_METRIC),
                           (int)(*(volatile uint16_t *)G_TILE_SY),
                           sheet_off, sheet_seg);                  /* @0x67E20 */
    }
}

/* ----------------------------------------------------------------------------
 * func_067E28 -- emit a ground sprite (sheet B)  (file 0x67E28)
 * ----------------------------------------------------------------------------
 * @verify cx=[0x16C], dx=[0x16E] @0x67E2C/@0x67E30; cmp [0x184],0 @0x67E3A;
 *   closest (je): cy=[0x1EA5]+[0xA5A6]-0xF; cx2=[0x1EA4]+[0xA5A4]-8;
 *   push cy,cx2,0x839E, AX(sprite), dx, cx; lcall 0x181F:0x25E @0x67E63;
 *   else: push [0x184],[0xA5A6],[0xA5A4],0x839E, AX, dx, cx; lcall 0x181F:0x272
 *   @0x67E84. The AX sprite index IS forwarded. */
void emit_ground_sprite(int sprite_idx)
{
    int sheet_off = gp_off(G_SHEET_PTR_B);
    int sheet_seg = gp_seg(G_SHEET_PTR_B);

    if (*(volatile uint16_t *)G_ZOOM_LEVEL == 0) {     /* @0x67E3A */
        int cy = (int)(*(volatile uint8_t *)G_SUBCELL_DY)
                 + (int)(*(volatile uint16_t *)G_TILE_SY) - 0xF;
        int cx = (int)(*(volatile uint8_t *)G_SUBCELL_DX)
                 + (int)(*(volatile uint16_t *)G_TILE_SX) - 8;
        rblt_sprite_full(sheet_off, sheet_seg, sprite_idx, G_CLIP_RECT, cx, cy); /* @0x67E63 */
    } else {
        rblt_sprite_scaled(sheet_off, sheet_seg, sprite_idx, G_CLIP_RECT,
                           (int)(*(volatile uint16_t *)G_TILE_SX),
                           (int)(*(volatile uint16_t *)G_TILE_SY));              /* @0x67E84 */
    }
}

/* ----------------------------------------------------------------------------
 * func_067E8C -- emit via the alternate overlay (sheet A, 0x1A1F)  (file 0x67E8C)
 * ----------------------------------------------------------------------------
 * Mirror of func_067DC8 but the resident blit lives in the 0x1A1F overlay group
 * (lcall 0x1A1F:0x98E full @0x67EC6 / 0x1A1F:0x984 scaled @0x67EE4). Reads sheet
 * ptr [0x174]/[0x176] and the same [0x186] metric. @verify cmp [0x186],0x64
 * @0x67E9E; nudge math @0x67EAD-@0x67EBF. */
void emit_sprite_alt(int sprite_idx)
{
    int sheet_off = gp_off(G_SHEET_PTR_A);
    int sheet_seg = gp_seg(G_SHEET_PTR_A);
    (void)sprite_idx;   /* same vestigial-AX shape as func_067DC8 */

    if (gp_off(G_SHEET_METRIC) >= 0x64) {
        int cy = (int)(*(volatile uint8_t *)G_SUBCELL_DY)
                 + (int)(*(volatile uint16_t *)G_TILE_SY) - 0xF;
        int cx = (int)(*(volatile uint8_t *)G_SUBCELL_DX)
                 + (int)(*(volatile uint16_t *)G_TILE_SX) - 8;
        rblt_alt_full(cx, cy, sheet_off, sheet_seg);            /* @0x67EC6 */
    } else {
        rblt_alt_scaled((int)(*(volatile uint16_t *)G_SHEET_METRIC),
                        (int)(*(volatile uint16_t *)G_TILE_SY),
                        sheet_off, sheet_seg);                  /* @0x67EE4 */
    }
}

/* ----------------------------------------------------------------------------
 * func_067EEC -- emit the terrain sprite (sheet B, primary)  (file 0x67EEC)
 * ----------------------------------------------------------------------------
 * The primary terrain-sprite emitter. Identical shape to func_067E28 but the
 * resident blit thunks are 0x181F:0x268 (full @0x67F27) / 0x181F:0x286 (scaled
 * @0x67F48). @verify cx=[0x16C],dx=[0x16E] @0x67EF0/@0x67EF4; cmp [0x184],0
 * @0x67EFE; push ...AX... @0x67F24. The AX sprite index IS forwarded. */
void emit_terrain_sprite(int sprite_idx)
{
    int sheet_off = gp_off(G_SHEET_PTR_B);
    int sheet_seg = gp_seg(G_SHEET_PTR_B);

    if (*(volatile uint16_t *)G_ZOOM_LEVEL == 0) {     /* @0x67EFE */
        int cy = (int)(*(volatile uint8_t *)G_SUBCELL_DY)
                 + (int)(*(volatile uint16_t *)G_TILE_SY) - 0xF;
        int cx = (int)(*(volatile uint8_t *)G_SUBCELL_DX)
                 + (int)(*(volatile uint16_t *)G_TILE_SX) - 8;
        rblt_sprite_full(sheet_off, sheet_seg, sprite_idx, G_CLIP_RECT, cx, cy); /* @0x67F27 */
    } else {
        rblt_sprite_scaled(sheet_off, sheet_seg, sprite_idx, G_CLIP_RECT,
                           (int)(*(volatile uint16_t *)G_TILE_SX),
                           (int)(*(volatile uint16_t *)G_TILE_SY));              /* @0x67F48 */
    }
    (void)G_STRAT_VIEW2;
}
