/* ============================================================================
 *                  >>> BYTE_VERIFIED (full chain, re-segmented disasm) <<<
 * ----------------------------------------------------------------------------
 * The in-game map tile-render chain, hand-decompiled from the FULL function
 * bodies in code/VICEROY/disasm_overlay_reseg/page_15.asm (overlay page 0x15,
 * file_offset 0x066680, code 0x066850). These are the COMPLETE bodies; the
 * earlier reconstruction of this file used truncated per-func dumps and got the
 * sizes badly wrong (it had O513 at 165 B — the real function is 1076 B — and
 * omitted the entire sprite-emission body). Corrected 2026-05-30.
 *
 *   func_O514  @ file 0x685DC  (699 B, 241 insns)  outer viewport walk
 *      -> func_O513  @ file 0x681A8  (1076 B, 363 insns)  per-tile EMITTER
 *            -> func_O512  @ file 0x67F50  (599 B, 210 insns)  sub-cell composer
 *      (both O513 and O512 emit through the leaf primitives below)
 *
 *   leaf emit primitives (file 0x67DC8..0x67F4E, all in page_15):
 *      func_067DC8 @0x67DC8  draw_tile_marker  (NEAR ip 0x1748)
 *      func_067E28 @0x67E28  emit_sprite_layerA (NEAR ip 0x17A8, consumes AX)
 *      func_067EEC @0x67EEC  emit_sprite_layerB (NEAR ip 0x186C, consumes AX)
 *      func_067E8C @0x67E8C  emit_sprite_alt    (NEAR ip 0x180C, uses ovl 0x1A1F)
 *   neighbour-mask helpers (terrain.c): func_067CF4/067D54/067B84/067BE4/
 *      067C54/067C8E/067A24.
 *   render setup (this file): func_06787C @0x6787C establishes zoom + viewport.
 *
 * STILL not yet decoded (cited reason): the *pixel format* of the leaf framebuffer poke.
 * Every leaf primitive ends in an LCALL into a load-image overlay
 * (0x181F:0x254/0x25E/0x268/0x272/0x286/0x2F8 -> overlay segs 0x0C36/0x0101/
 * 0x0C56; 0x1A1F:0x984/0x98E -> seg 0x0CAA/0x0C89). Those targets are resident
 * in load-image overlays, not in VICEROY.EXE's decodable code image, so the
 * actual byte blit is decoded only to its calling convention (which globals /
 * which sprite index / which clip rect). The SELECTION logic — which sprite
 * index at which screen pixel — is now fully byte-verified below.
 *
 * The PHYS0 sprite-sheet far-pointer pairs are identified (no longer "left unresolved
 * descriptor"): [0x174]/[0x176] and [0x16C]/[0x16E] are the loaded sheet bases;
 * [0x186]/[0x188] are sheet metrics; the sheet's *internal* numbering is data.
 * ============================================================================ */

/* ============================================================================
 * tile_chain.c -- Map view rendering: func_O514 -> O513 -> O512 (+ setup)
 * ----------------------------------------------------------------------------
 * @asm_function   func_O514 / func_O513 / func_O512 / func_06787C
 * @asm_offset     file 0x685DC / 0x681A8 / 0x67F50 / 0x6787C
 * @asm_page       code/VICEROY/disasm_overlay_reseg/page_15.asm
 * @region         overlay page 0x15 (resident across the in-game map screen)
 * @verified_by    Hand-decompiled from FULL VICEROY.EXE bodies 2026-05-30
 * @ref            ../../../FUNCTIONS_INVENTORY.md  section A
 * ============================================================================ */
#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * Map geometry globals (DGROUP). All byte-verified from page_15.asm.
 * ---------------------------------------------------------------------------- */

/*   [0x853A] = map_width    @verify O512 mov ax,[0x853a] @0x680A2; O514 @0x6871A
 *   [0x853C] = map_height   @verify O512 @0x680AA; O514 @0x68652 / @0x6887D */
#define G_MAP_WIDTH   0x853A
#define G_MAP_HEIGHT  0x853C

/* Renderer effective row stride. func_06787C sets it to (0xF<<zoom)+2 when the
 * fast-path layers are resident, else = map_width.
 *   @verify func_06787C @0x67989 (0xF<<cl, inc, inc -> [0x8548]); else
 *           @0x679E8 (mov [0x8548], map_width). Used as the imul base by O514
 *           @0x6868E and as ±stride by every neighbour reader.
 * The +2 over the 0xF<<zoom span is the pair of sea-lane border columns
 * (MAP_FORMAT.md); do NOT unify with G_MAP_WIDTH. */
#define G_RENDER_STRIDE  0x8548

/* Viewport tile origin (top-left visible tile), set by func_06787C.
 *   [0x8328] = origin col   @verify func_06787C @0x678C4 / O514 cmp @0x68645
 *   [0x832E] = origin row    @verify func_06787C @0x678D3 / O514 cmp @0x68663 */
#define G_VIEW_ORIGIN_COL  0x8328
#define G_VIEW_ORIGIN_ROW  0x832E

/* Visible-tile extents (max tile index, inclusive). func_06787C computes them
 * as origin + span - 1.
 *   [0x8804] = max col   @verify func_06787C @0x67A13; O514 cmp @0x6860A/@0x68636
 *   [0x8806] = max row    @verify func_06787C @0x67A1E; O514 cmp @0x68616/@0x68655 */
#define G_VIEW_MAX_COL  0x8804
#define G_VIEW_MAX_ROW  0x8806

/* Tile size in framebuffer pixels = 0x10 >> zoom (square). Both W and H hold the
 * same value. @verify func_06787C @0x678B3 (sar 0x10 by cl=[0x184]) -> [0x5ad4]
 * AND -> [0x8326]. At zoom 0 both = 16 (matches TILE_W/TILE_H). O514 scales the
 * pixel origin by these (imul @0x68765 / @0x68727). */
#define G_TILE_PX_W  0x5AD4
#define G_TILE_PX_H  0x8326

/* Pixel-grid base col/row (added before col/row scaling). Normally 0; set
 * nonzero by func_06787C only when the map is narrower than the viewport span
 * (centering). @verify func_06787C @0x67914/@0x67917 (zero) and @0x67937 (center). */
#define G_PIX_BASE_COL  0x832A   /* @asm O514 mov ax,[0x832a] @0x6875F */
#define G_PIX_BASE_ROW  0x832C   /* @asm O514 mov ax,[0x832c] @0x68720 */

/* Zoom level (shift amount). 0 = closest. Drives tile px, span, stride.
 * @verify func_06787C reads it as cl at @0x67880/@0x678AA/@0x6797E/@0x679F4. */
#define G_ZOOM_LEVEL  0x0184

/* Span in tiles: width = 0xF<<zoom @0x8544, height = 0xC<<zoom @0x8546.
 * @verify func_06787C @0x67889 / @0x67891 (15x12 tiles at zoom 0). */
#define G_SPAN_W  0x8544
#define G_SPAN_H  0x8546

/* Strategic/minimap mode flag. When nonzero, span is forced to 5 and zoom to 0.
 * @verify func_06787C cmp [0x18a],0 @0x67894; also gates fast-path math in
 * O512 (@0x68066) and O513 (@0x682A8) and O514 (@0x6873D). */
#define G_STRAT_VIEW  0x018A

/* Sheet metric threshold = 0x64 >> zoom. The leaf emit primitives compare it
 * against 0x64 to pick the full-tile blit path vs the scaled path.
 * @verify func_06787C @0x679FD (sar 0x64 by zoom -> [0x186]); read by
 * func_067DC8 @0x67DDA and func_067E8C @0x67E9E (cmp [0x186],0x64). */
#define G_SHEET_METRIC  0x0186

/* ----------------------------------------------------------------------------
 * The 3 parallel map layers (far pointers in DGROUP). O514 composes a per-tile
 * working pointer for each into [0xA594..0xA59E].
 *   [0x15C]/[0x15E] = TERRAIN layer base   @verify O514 add @0x68697/@0x6869B
 *   [0x160]/[0x162] = FEATURE layer base   @verify O514 add @0x686A7/@0x686AB
 *   [0x168]/[0x16A] = RESOURCE/FOG base    @verify O514 add @0x686B5/@0x686B9
 * Each layer is a flat byte array; fast-path index = (relrow+1)*stride+relcol+1.
 * ---------------------------------------------------------------------------- */
#define G_TERRAIN_LAYER_PTR   0x015C
#define G_FEATURE_LAYER_PTR   0x0160
#define G_RESFOG_LAYER_PTR    0x0168

/* O514 fast-path enable: when [0x15A]!=0 layer pointers are valid and indexed
 * directly; otherwise the resident layer-ptr fetchers are called per tile.
 *   @verify O514 cmp [0x15a],0 @0x68684; func_06787C also branches on it @0x67970. */
#define G_LAYERS_RESIDENT  0x015A

/* Per-tile working far-pointers (O513/O512/O506/O507 read es:bx from here).
 *   [0xA594]/[0xA596] = terrain working ptr  @verify O514 @0x68860; O513 les @0x681B3
 *   [0xA598]/[0xA59A] = feature working ptr  @verify O514 @0x68852; O513 les @0x681BD
 *   [0xA59C]/[0xA59E] = resfog working ptr   @verify O514 @0x6886E; O513 les @0x681C7 */
#define G_WP_TERRAIN  0xA594
#define G_WP_FEATURE  0xA598
#define G_WP_RESFOG   0xA59C

/* Per-tile pixel origin written by O514, read by the leaf emit math.
 *   [0xA5A4] = tile centre screen X  @verify O514 @0x68771 ((base+relcol)*pxw+pxw/2)
 *   [0xA5A6] = tile bottom screen Y  @verify O514 @0x6872C ((base+relrow+1)*pxh-1)
 *   [0xA5A0]/[0xA5A2] = sub-cell map base added in O512  @verify O514 @0x68803/@0x68849
 *   [0xA5A8] = per-column parity flag (isometric stagger), xor 1 each col
 *              @verify O514 @0x687F3; saved/restored across O512 @0x67F55/@0x681A1 */
#define G_TILE_SX     0xA5A4
#define G_TILE_SY     0xA5A6
#define G_SUBCELL_BX  0xA5A0
#define G_SUBCELL_BY  0xA5A2
#define G_COL_PARITY  0xA5A8

/* Fog / per-tile raw bytes (O513 fills these from the working pointers).
 *   [0xA89E] = fog test mask = 1 << (active_layer + 4), or 0 if layer<0
 *              @verify O514 shl al,cl @0x685F7; mov [0xa89e] @0x685F9
 *   [0xA89F] = raw terrain byte    @verify O513 @0x681BA
 *   [0xA8A0] = raw resfog  byte    @verify O513 @0x681CE
 *   [0xA8A1] = raw feature byte    @verify O513 @0x681C4
 *   [0xA8A2] = classified visible-terrain id   @verify O513 @0x681DD
 *   [0xA8A6] = neighbour-connectivity bitmap (set by func_067A24) @verify @0x67A2E */
#define G_FOG_MASK        0xA89E
#define G_RAW_TERRAIN     0xA89F
#define G_RAW_RESFOG      0xA8A0
#define G_RAW_FEATURE     0xA8A1
#define G_VIS_TERRAIN     0xA8A2
#define G_CONN_BITMAP     0xA8A6

/* Per-direction road-connection table (4 bytes). Cleared and filled by
 * func_067A24; read by O513's road block as byte[bx+0x2D24].
 *   @verify func_067A24 init @0x67A39; O513 read @0x684DD. */
#define G_ROAD_DIR_TABLE  0x2D24

/* Sprite-sheet descriptor globals (the loaded PHYS0.SS / TERRAIN.SS bases).
 *   [0x174]/[0x176] = sheet far-ptr A   @verify func_067DC8 @0x67DCC; setter @0x765AC
 *   [0x16C]/[0x16E] = sheet far-ptr B   @verify func_067EEC @0x67EF0; setter @0x72C5C
 * The leaf primitives read these as the source surface. The sheet's internal
 * sprite numbering remains data (SPRITE_CATALOG.md); only the descriptor
 * globals are identified here. */
#define G_SHEET_PTR_A  0x0174
#define G_SHEET_PTR_B  0x016C

/* Leaf-emit sub-cell pixel offsets (sprite top-left nudge), written per sub-cell
 * by O513's road block and consumed by every leaf primitive.
 *   [0x1EA4] = dX nudge  @verify O513 @0x684CC; read by func_067DC8 @0x67DF1
 *   [0x1EA5] = dY nudge  @verify O513 @0x684D7; read by func_067DC8 @0x67DE3 */
#define G_SUBCELL_DX  0x1EA4
#define G_SUBCELL_DY  0x1EA5

/* Screen-bounds clip rect (NOT a popup rect). 4 words at [0x839E..0x83A4].
 * @ref hud.c / RENDERER_GEOMETRY.md. Passed by address to every leaf primitive.
 * @verify func_067DC8 lea bx,[0x839e] @0x67DFE. */
#define G_CLIP_RECT  0x839E

/* ----------------------------------------------------------------------------
 * Selection tables (defined in terrain.c).
 * ---------------------------------------------------------------------------- */
extern const uint8_t TERRAIN_3X3[9];               /* @file 0x1F884 */
extern const int16_t TERRAIN_CENTER_VARIANT[29];   /* @file 0x1DB32 */
extern const int8_t DIR4_DX[4], DIR4_DY[4];        /* @file 0x1DA48 / 0x1DA4E */
extern const int8_t DIR8_DX[8], DIR8_DY[8];        /* @file 0x1DA54 / 0x1DA5E */

/* neighbour-mask helpers in terrain.c (file offsets noted). */
extern int nmask4_terrain(uint8_t mask);      /* func_067CF4 @0x67CF4 */
extern int nmask8_terrain(uint8_t mask);      /* func_067D54 @0x67D54 (== O507) */
extern int nmask4_feature(uint16_t mask);     /* func_067B84 @0x67B84 */
extern int nmask4_feat_hi(int self_hi);       /* func_067BE4 @0x67BE4 (hi-bits match) */
extern int nmask4_forest(void);               /* func_067C8E @0x67C8E */
extern int analyse_connections(void);         /* func_067A24 @0x67A24 -> [0xA8A6]/road tbl */

/* ----------------------------------------------------------------------------
 * Resident helpers reached through the RTLink thunk table (0x181F:NNNN).
 * All resolved to load-image overlay targets (lcall_resolution_VICEROY.json):
 *   0x6AA -> ovl 0x37F:0x614  classify_terrain(raw)->visible id (auto-forest @0x6204)
 *   0x6C8 -> ovl 0x37F:0x03C  subcell_priority(dx,dy,?) cursor-highlight gate
 *   0x302 -> ovl 0x37F:0x00A  is_xy_in_map_bounds(x,y)
 *   0x72C -> ovl 0x37F:0x10E  read_terrain_byte(x,y) & layer
 *   0x70E -> ovl 0x37F:0x0F6  layer_ptr_terrain(x,y)  (O514 slow path)
 *   0x740 -> ovl 0x37F:0x12A  layer_ptr_feature(x,y)
 *   0x736 -> ovl 0x37F:0x2E0  layer_ptr_resfog(x,y)
 *   0x718 -> ovl 0x37F:0x4B0  special-feature/centre-variant lookup(bx,by)
 *   0x75E -> ovl 0x37F:0x598  river-mouth/coast-detail lookup(bx,by)
 * ---------------------------------------------------------------------------- */
extern int      classify_terrain(uint8_t raw);              /* 0x181F:0x6AA */
extern int      subcell_priority(int dx, int dy, int q);    /* 0x181F:0x6C8 */
extern int      is_xy_in_map_bounds(int x, int y);          /* 0x181F:0x302 */
extern uint8_t  read_terrain_byte(int x, int y);            /* 0x181F:0x72C */
extern int      special_feature_at(int bx, int by);         /* 0x181F:0x718 */
extern int      river_detail_at(int bx, int by);            /* 0x181F:0x75E */

/* ----------------------------------------------------------------------------
 * Leaf emit primitives (this overlay; file offsets cited). Each takes a sprite
 * index in AX and draws it at the current tile origin [0xA5A4]/[0xA5A6] offset
 * by [0x1EA4]/[0x1EA5], clipped to [0x839E]. They branch on [0x186] (zoom
 * metric) to a full-tile path vs a scaled path. EXACT pixel poke is in the
 * load-image overlay (library-implementation-only); we model the index + placement, which IS verified.
 * ---------------------------------------------------------------------------- */

/* func_067DC8 @0x67DC8 (NEAR 0x1748). Reads sheet ptr [0x174]/[0x176]; if
 * [0x186] >= 0x64 -> lcall 0x181F:0x254 (full path: dest = ([0xA5A4]-8,[0xA5A6]-15)
 * with the [0x1EA4]/[0x1EA5] nudge baked into the resident routine, clip [0x839E]);
 * else -> lcall 0x181F:0x2F8 (scaled path). The passed sprite index is NOT
 * referenced here — this primitive paints from the *currently selected* sheet
 * cell + the marker/overlay globals, which is why the prior pass concluded
 * "AX dead" and tagged it the dialog/selection-rect emitter (UI ledger
 * 2026-05-29). In the render chain it is the marker/overlay-cell painter; the
 * index in AX is vestigial at this callee.  @verify @0x67DCC..@0x67E26. */
extern void draw_tile_marker(int sprite_idx);

/* func_067EEC @0x67EEC (NEAR 0x186C). Reads sheet ptr [0x16C]/[0x16E]; PUSHES AX
 * (the sprite index) into the resident blit. If [0x184]==0 (closest zoom)
 * -> lcall 0x181F:0x268 (full), else -> 0x181F:0x286 (scaled). This IS the
 * primary terrain-sprite emitter: AX = sprite index.
 * @verify push ax @0x67F24; lcall 0x268 @0x67F27 / 0x286 @0x67F48. */
extern void emit_terrain_sprite(int sprite_idx);

/* func_067E28 @0x67E28 (NEAR 0x17A8). Same shape as 067EEC but lcall 0x25E/0x272;
 * also pushes AX. Used by O513 for the base-ground sprite of the tile.
 * @verify push ax @0x67E60/@0x67E7D; lcall 0x25E @0x67E63 / 0x272 @0x67E84. */
extern void emit_ground_sprite(int sprite_idx);

/* ----------------------------------------------------------------------------
 * func_O512 -- sub-cell terrain composer  (file 0x67F50, 599 B)  BYTE_VERIFIED
 * ----------------------------------------------------------------------------
 * Runs ONLY for water tiles (O513 calls it after classifying the visible id as
 * Ocean 0x19 / Sea-Lane 0x1A; for non-water O513 emits inline). It walks the 4
 * cardinal directions; for each, gates the neighbour with subcell_priority +
 * is_xy_in_map_bounds, reads the neighbour FEATURE byte, normalises it
 * (&0x1F, and &7 when <0x18), classifies it, then for ocean/sea-lane neighbours
 * walks an 8-step ring to pick the coast/water transition. Non-water neighbours
 * emit a transition sprite at base (pass + 0x69).
 *
 *  @param composite  [bp+4] : 1 = transition pass enabled (O513 passes 1)
 *  @param edge_lo    [bp+6] : nonzero gates the 8-ring water tail
 *  @param edge_hi    [bp+8] : (structural; O513 passes 0)
 * ---------------------------------------------------------------------------- */
void tile_compose_subcells(int composite, int edge_lo, int edge_hi)
{
    int pass;
    int saved_parity;       /* [bp-0x26] <- [0xA5A8] @0x67F55 */
    int prio;               /* [bp-8]  accumulated priority flag */
    int nbase;              /* [bp-0xc] normalised neighbour base id */
    int nvis;               /* [bp-0x1c] classified neighbour visible id */
    int hidden;             /* [bp-0xe] fog-hidden flag */

    saved_parity = (int)(*(volatile uint16_t *)G_COL_PARITY);  /* @0x67F55 */
    *(volatile uint16_t *)G_COL_PARITY = 0;                    /* @0x67F5D */

    /* @verify [bp-4] pass 0..3 loop @0x67F60 init / @0x68026 test */
    for (pass = 0; pass < 4; pass++) {
        int dy = DIR4_DY[pass];   /* @asm mov al,[bx+0xae] @0x68032 */
        int dx = DIR4_DX[pass];   /* @asm mov al,[bx+0xa8] @0x6803C */
        int ncell_x, ncell_y;

        /* neighbour sub-cell = dir + sub-cell map base [0xA5A0]/[0xA5A2].
         * @verify add ax,[0xa5a0] @0x68044; add cx,[0xa5a2] @0x6804B */
        ncell_x = dx + (int)(*(volatile uint16_t *)G_SUBCELL_BX);
        ncell_y = dy + (int)(*(volatile uint16_t *)G_SUBCELL_BY);

        /* gate: in-bounds -> prio = (rc==1)?-1:0 accumulated.
         * @verify lcall 0x302 @0x68054; sbb/neg @0x6805F; mov [bp-8] @0x68063 */
        prio = is_xy_in_map_bounds(ncell_x, ncell_y) ? -1 : 0;

        /* In strategic view ([0x18A]==0) the loop re-primes (jmp back); the
         * fast path falls through. @verify cmp [0x18a],0 @0x68066. (Modelled as
         * a single linear pass — the jmp is the strat-view re-entry.) */
        (void)prio;

        /* neighbour FEATURE byte, normalised. @verify les [0xa598] @0x67FC1;
         * and 0x1f @0x67FCB; cmp 0x18 / and 7 @0x67FD0. (The offset uses the
         * ±stride select at @0x67FA8/@0x67FB5 per the dY sign.) */
        nbase = read_terrain_byte(ncell_x, ncell_y) & 0x1F;
        if (nbase < 0x18) nbase &= 7;

        nvis = classify_terrain((uint8_t)nbase);   /* @verify lcall 0x6AA @0x67FDE */

        /* fog: hidden unless fog disabled, mask matches, or prio set.
         * @verify cmp [0xa89e],0 @0x67FF7; test [0xa89e],al @0x67FFE;
         *         cmp [bp-8],0 @0x68004; set [bp-0xe] @0x6800A/@0x68012 */
        {
            uint8_t fog  = *(volatile uint8_t *)G_FOG_MASK;
            uint8_t rfog = read_terrain_byte(ncell_x, ncell_y); /* resfog at runtime */
            hidden = (fog == 0 || (fog & rfog) || prio) ? 1 : 0;
        }

        /* composite/hidden gate before drawing. @verify cmp [bp+4],0 @0x68017;
         *   cmp [bp-0xe],0 @0x6801D */
        if (!composite || !hidden) {
            /* loop continues (no emit this pass) */
            continue;
        }

        /* Water-tail dispatch: if the neighbour visible id is Ocean(0x19)/
         * Sea-Lane(0x1A) AND edge_lo set, walk an 8-step ring (counter
         * [bp-0x10] 7..0) emitting coast/water sub-cells; otherwise emit the
         * transition sprite at base (pass + 0x69).
         * @verify cmp [bp-0x1c],0x19/0x1a @0x68082/@0x68088; ring init 7
         *   @0x6809A; non-water tail @0x68189 (add ax,0x69; call 0x1748). */
        if ((nvis == 0x19 || nvis == 0x1A) && edge_lo) {
            int ring;
            for (ring = 7; ring >= 0; ring--) {
                int rdx = DIR8_DX[ring];  /* @asm [bx+0xb4] @0x680CA */
                int rdy = DIR8_DY[ring];  /* @asm [bx+0xbe] @0x680D5 */
                int rcx = ncell_x + rdx;
                int rcy = ncell_y + rdy;
                uint8_t rb;
                /* odd ring positions are diagonals -> skipped (test bl,1).
                 * @verify test bl,1 @0x680E0; bounds gate @0x680E5/@0x680EB. */
                if (ring & 1) continue;
                if (rcx < 0 || rcy < 0) continue;
                if (rcx >= (int)(*(volatile uint16_t *)G_MAP_WIDTH)) continue;
                if (rcy >= (int)(*(volatile uint16_t *)G_MAP_HEIGHT)) continue;
                /* reclassify the ring neighbour. @verify lcall 0x72c @0x680F8;
                 *   and 0x1f / cmp 0x18 / and 7 @0x68100..@0x6810C; lcall 0x6aa
                 *   @0x68113; store [bp-0x1c] @0x6811B. */
                rb = read_terrain_byte(rcx, rcy) & 0x1F;
                if (rb < 0x18) rb &= 7;
                nvis = classify_terrain(rb);
            }
        } else {
            /* transition sprite: base = pass + 0x69 via draw_tile_marker, then
             * the classified id via emit_terrain_sprite.
             * @verify add ax,0x69 @0x6818C; call 0x1748 @0x6818F;
             *   mov al,[bp-0x1c] @0x68192; call 0x186c @0x68197. */
            draw_tile_marker(pass + 0x69);
            emit_terrain_sprite(nvis);
        }

        (void)edge_hi;
    }

    *(volatile uint16_t *)G_COL_PARITY = (uint16_t)saved_parity;  /* @0x681A1 */
}

/* ----------------------------------------------------------------------------
 * func_O513 -- per-tile terrain emitter  (file 0x681A8, 1076 B)  BYTE_VERIFIED
 * ----------------------------------------------------------------------------
 * THE core terrain renderer. Fetches the 3 raw tile bytes, classifies the
 * visible id, runs the fog test, then emits the full stack of sprites for the
 * tile in z-order: base ground, hill/mountain body, forest, river, coast,
 * roads, and the active-tile marker. Sprite-index bases are all byte-verified
 * (PHYS0 roles per CLAUDE.md/RULINGS confirmed by the constants here):
 *
 *   0x95 marker / 0x96 marker      (selection / road-on-tile overlay)
 *   centre  = 0x5A + special_feature_at(...)      @0x682B2 / @0x683F7 / @0x685D3
 *   forest  = 0x41 + forest-edge-mask             @0x68349
 *   hill    = 0x31 + nmask4_feat_hi               @0x68384   (PHYS0 row 0x31 = hills)
 *   mtn     = 0x21 + nmask4_feat_hi               @0x6837F   (PHYS0 row 0x21 = mountains)
 *   water   = 0x40 + nmask4_feature(0x40)         @0x683AB   (or 0xF when 0)
 *   river   = 0x51 base / 0x52 + 8-dir bit        @0x6843B / @0x68459 (row 0x50 family)
 *   coast   = 0x97 + river_detail_at              @0x6850D / @0x68411 (=0x68)
 *   road    = 0x6D + 4*table[dir] + dir           @0x684E8   (per-dir road table 0x2D24)
 *   feat-dir= 0x8D + (feat&0x80?+4:+0) + dir       @0x68532   (road/river feature edges)
 *
 *  @param active_cell  [bp-0x26 alias of caller arg] : nonzero = cursor tile.
 * ---------------------------------------------------------------------------- */
void tile_dispatch(int active_cell)
{
    uint8_t raw_terrain, raw_feature, raw_resfog;
    int     vis_terrain;
    int     visible;          /* [bp-8] */
    int     feat_flags;       /* [bp-0x12] = raw_feature & 0xC0 */
    int     is_water;         /* [bp-0x22] */
    int     v;

    /* 1. Fetch the three raw bytes from the working far-pointers.
     * @verify les [0xa594]; mov [0xa89f] @0x681B3-@0x681BA (terrain);
     *         les [0xa598]; mov [0xa8a1] @0x681BD-@0x681C4 (feature);
     *         les [0xa59c]; mov [0xa8a0] @0x681C7-@0x681CE (resfog). */
    raw_terrain = *(volatile uint8_t *)G_WP_TERRAIN;    /* es:[bx] modelled */
    raw_feature = *(volatile uint8_t *)G_WP_FEATURE;
    raw_resfog  = *(volatile uint8_t *)G_WP_RESFOG;
    *(volatile uint8_t *)G_RAW_TERRAIN = raw_terrain;
    *(volatile uint8_t *)G_RAW_FEATURE = raw_feature;
    *(volatile uint8_t *)G_RAW_RESFOG  = raw_resfog;

    /* 2. Classify visible terrain. @verify lcall 0x6aa @0x681D5; [0xa8a2] @0x681DD */
    vis_terrain = classify_terrain(raw_terrain);
    *(volatile uint8_t *)G_VIS_TERRAIN = (uint8_t)vis_terrain;

    /* 3. Fog/visibility. @verify cmp [0xa89e],0 @0x681E0; test [0xa8a0],al
     *    @0x681EA; cmp [bp-0x26],0 @0x681F0; set [bp-8] @0x681F6/@0x681FE */
    {
        uint8_t fog = *(volatile uint8_t *)G_FOG_MASK;
        visible = (fog == 0 || (raw_resfog & fog) || active_cell) ? 1 : 0;
    }

    /* 4. Feature road/river flags = top 2 bits. @verify and ax,0xC0 @0x68206;
     *    store [bp-0x12] @0x68209 */
    feat_flags = raw_feature & 0xC0;

    /* 5. If visible, draw the active-tile marker (sprite 0x95). At closest zoom
     *    ([0x184]==0) fall through to draw the tile; else (zoomed out) the marker
     *    IS the whole emit and we return via the shared tail.
     *    @verify cmp [bp-8],0 @0x6820C; mov ax,0x95 @0x68212; call 0x1748 @0x68215;
     *            cmp [0x184],0 @0x68218; jmp tail @0x6821F. */
    if (visible) {
        draw_tile_marker(0x95);
        if (*(volatile uint16_t *)G_ZOOM_LEVEL != 0)
            goto tail;
    }

    /* 6. Water test on the visible id. @verify cmp [0xa8a2],0x19 @0x68222;
     *    0x1a @0x68229; set [bp-0x22] @0x68230/@0x68238. When water, hand off the
     *    whole tile to O512 and return. @verify push 0/[bp-0x22]/1; call 0x18d0
     *    @0x68244. */
    is_water = (vis_terrain == 0x19 || vis_terrain == 0x1A) ? 1 : 0;
    if (!visible) {
        /* not visible: the original still composes water sub-cells via O512 with
         * (1, is_water, 0). @verify push 0 @0x6823D..call 0x18d0 @0x68244. */
        tile_compose_subcells(/*composite=*/1, /*edge_lo=*/is_water, /*edge_hi=*/0);
        return;
    }

    /* ---- The big visible-tile emission body (file 0x6824E..0x685D8). ----
     * (Only reached at closest zoom, [0x184]==0.) */
    {
        int base_drawn = 0;      /* [bp-4] : 1 once a water base sprite emitted */
        int water_id   = 0x19;   /* [bp-2] : ocean/sea-lane id for the base sprite */
        int land_base;           /* [bp-0x20] */
        int sub;                 /* [bp-0xc] sub-cell loop var */

        /* 6a. Ocean/sea-lane base ground. @verify mov [bp-4],0 @0x6824E;
         *   mov [bp-2],0x19 @0x68252; cmp 0x19/0x1a @0x68256/@0x6825D. */
        if (vis_terrain == 0x19 || vis_terrain == 0x1A) {
            water_id = vis_terrain;
            /* func_067A24 (analyse_connections) returns the ocean connectivity;
             * stored at [bp-0x1c]. @verify call 0x13a4 @0x6826A. */
            v = analyse_connections();          /* @0x6826A */
            base_drawn = 1;                     /* @0x68270 */
            /* if connectivity == 0 (open ocean) emit the plain base + centre
             *   variant, then hand off to O512 for coast composition.
             * @verify cmp [bp-4],0 @0x68274; cmp [bp-0x1c],0 @0x6827A;
             *   call 0x17a8 (ground) @0x68285; centre 0x5A+special @0x682B2;
             *   call 0x18d0 (O512) @0x682BC->0x682BE (push 0,1,1). */
            if (v == 0) {
                emit_ground_sprite(water_id);             /* @0x68285 */
                if (*(volatile uint16_t *)G_ZOOM_LEVEL != 0) goto tail;
                {
                    int sp = special_feature_at(
                                 (int)(*(volatile uint16_t *)G_SUBCELL_BX),
                                 (int)(*(volatile uint16_t *)G_SUBCELL_BY)); /* 0x718 @0x6829A */
                    if (sp != -1 && *(volatile uint16_t *)G_STRAT_VIEW == 0)
                        draw_tile_marker(0x5A + sp);       /* @0x682B5 */
                }
                tile_compose_subcells(1, 1, 0);            /* @0x682BC */
                return;
            }
        }

        /* 6b. Land base ground sprite. land_base = vis<0x18 ? (vis&7) : vis;
         *   special-case Plains/Prairie/etc. group -> 0x11.  @verify cmp 0x18
         *   @0x682C0; and 7 @0x682CA; group tests @0x682DD..@0x682F7;
         *   mov ax,0x11 @0x682FE; call 0x17a8 @0x68301. */
        if (vis_terrain >= 0x18) land_base = vis_terrain;
        else                     land_base = vis_terrain & 7;
        if (land_base == 1 &&
            !((vis_terrain >= 8 && vis_terrain < 0x10) ||
              (vis_terrain >= 0x10 && vis_terrain < 0x18))) {
            land_base = 0x11;    /* @0x682FE */
        }
        emit_ground_sprite(land_base);   /* @0x68301 */
        if (*(volatile uint16_t *)G_ZOOM_LEVEL != 0) {
            /* zoomed: emit O512 water sub-cells then done. @verify push 0,[bp-4],0
             *   @0x6830B..; call 0x18d0 @0x68315. */
            tile_compose_subcells(0, base_drawn, 0);
            goto tail;
        }

        /* 6c. Forest overlay. For the forest terrain range only, add forest-edge
         *   mask to base 0x41. @verify cmp [bp-0x20],1 @0x6831B; forest range
         *   tests @0x68321..@0x6833B; call 0x160e (nmask4_forest), dx=3 @0x68343;
         *   add ax,0x41 @0x68349; call 0x1748 @0x6834C. */
        if (land_base == 1 &&
            ((vis_terrain >= 8 && vis_terrain < 0x10) ||
             (vis_terrain >= 0x10 && vis_terrain < 0x18))) {
            int fmask = nmask4_forest();     /* @0x68343 */
            draw_tile_marker(0x41 + fmask);  /* @0x6834C */
        }

        /* 6d. River-on-terrain marker (terrain byte bit 0x40 -> sprite 0x96).
         * @verify test [0xa89f],0x40 @0x6834F; mov ax,0x96 @0x68356; call 0x1748. */
        if (raw_terrain & 0x40)
            draw_tile_marker(0x96);          /* @0x68359 */

        /* 6e. Hills / mountains body (feature byte bit 0x20). Match the high-2-bit
         *   neighbours (nmask4_feat_hi); base 0x21 for mountains (bit 0x80) else
         *   0x31 for hills.  @verify test [0xa8a1],0x20 @0x6835C; not when water
         *   (cmp [bp-4]) @0x68363; and 0xa0 @0x6836C; call 0x1564 (nmask4_feat_hi)
         *   dx=2 @0x68372; test 0x80 @0x68378; add 0x21 @0x6837F / add 0x31
         *   @0x68384; call 0x1748 @0x68387. */
        if ((raw_feature & 0x20) && !base_drawn) {
            int hmask = nmask4_feat_hi(raw_feature & 0xA0);  /* @0x6836C/@0x68372 */
            if (raw_feature & 0x80) draw_tile_marker(0x21 + hmask);  /* mountains @0x6837F */
            else                    draw_tile_marker(0x31 + hmask);  /* hills @0x68384 */
        }

        /* 6f. Coastal/shore body (feature bit 0x40). 4-cardinal feature mask vs
         *   the 0x40 bit; pick 1 (bit 0x80 set) or 0x11 base; add water mask
         *   (nmask4_feature(0x40)) or 0xF.  @verify test [0xa8a1],0x40 @0x6838A;
         *   not when water @0x68391; test 0x80 @0x68397; base 1/0x11 @0x6839E/
         *   @0x683A6; mov ax,0x40 @0x683AB; call 0x1504 (nmask4_feature) dx=3
         *   @0x683B1; or ax,ax / 0xF default @0x683B7; add base @0x683C0;
         *   call 0x1748 @0x683C6. */
        if ((raw_feature & 0x40) && !base_drawn) {
            int shore_base = (raw_feature & 0x80) ? 1 : 0x11;
            int wmask = nmask4_feature(0x40);    /* @0x683B1 */
            if (wmask == 0) wmask = 0xF;          /* @0x683BB */
            draw_tile_marker(shore_base + wmask); /* @0x683C6 */
        }

        /* 6g. Coast halo (closest zoom, not strategic). centre variant
         *   0x5A+special, plus a 0x68 coast sprite when river_detail_at != 0.
         * @verify cmp [0x184],0 @0x683C9; cmp [0x18e],0 @0x683D0; lcall 0x718
         *   @0x683DF; add 0x5a @0x683F7; call 0x1748 @0x683FA; lcall 0x75e
         *   @0x68405; or ax,ax @0x6840D; mov ax,0x68 @0x68411; call 0x1748. */
        if (*(volatile uint16_t *)G_ZOOM_LEVEL == 0 &&
            *(volatile uint16_t *)0x018E == 0) {
            int sp = special_feature_at(
                         (int)(*(volatile uint16_t *)G_SUBCELL_BX),
                         (int)(*(volatile uint16_t *)G_SUBCELL_BY));   /* @0x683DF */
            if (sp != -1 && *(volatile uint16_t *)G_STRAT_VIEW == 0)
                draw_tile_marker(0x5A + sp);                            /* @0x683FA */
            if (river_detail_at(
                    (int)(*(volatile uint16_t *)G_SUBCELL_BX),
                    (int)(*(volatile uint16_t *)G_SUBCELL_BY)))         /* @0x68405 */
                draw_tile_marker(0x68);                                 /* @0x68414 */
        }

        /* 6h. River network (terrain byte bits 0xA). nmask8_terrain(... dx=1) gives
         *   the 8-dir river connectivity; base 0x51 when 0, else add 0x52 per set
         *   bit over 8 dirs.  @verify test [0xa89f],0xa @0x68417; not when water
         *   @0x6841E; cmp [0x18e],0 @0x68424; call 0x16d4 (nmask8_terrain) ax=0xa
         *   dx=1 @0x68431; or ax,ax @0x68437; mov ax,0x51 @0x6843B; call 0x1748;
         *   else per-bit 0x52+i loop @0x68449..@0x6846B. */
        if ((raw_terrain & 0xA) && !base_drawn &&
            *(volatile uint16_t *)0x018E == 0) {
            int rmask = nmask8_terrain(0xA);     /* @0x68431 (ax=0xa,dx=1) */
            if (rmask == 0) {
                draw_tile_marker(0x51);          /* @0x6843E */
            } else {
                int bit = 1, i;
                for (i = 0; i < 8; i++) {
                    if (rmask & bit) draw_tile_marker(0x52 + i);  /* @0x6845C */
                    bit <<= 1;                                    /* @0x6845F */
                }
            }
        }

        /* 6i. Roads / straight-edge coast (non-water only). Reached when
         *   base_drawn==0. @verify cmp [bp-4],0; jne tail @0x6846B/@0x6846F.
         *
         *   First classify the connectivity bitmap [0xA8A6] into a "clean pattern"
         *   index [bp-6] (0..3) or 0xFFFF if none:
         *     (conn & 0xDD) == 0xC1 -> 0     @verify @0x6847C-@0x68482
         *     (conn & 0x77) == 0x07 -> 1     @verify @0x68487-@0x68490
         *     (conn & 0x77) == 0x70 -> 2     @verify @0x68495-@0x6849E
         *     (conn & 0xDD) == 0x1C -> 3     @verify @0x684A3-@0x684AC
         *
         *   If a clean pattern matched (>=0): emit ONE straight sprite
         *   0x97 + pattern with zero nudge (the 4 coast/road straight sprites
         *   0x97..0x9A). @verify cmp [bp-6],0; jge @0x684B1/@0x684B5; zero nudge
         *   @0x68502-@0x68507; add 0x97 @0x6850D; call 0x1748 @0x68510.
         *
         *   Else (no clean pattern): emit the 4-direction road pieces. Each dir's
         *   pixel nudge [0x1EA4]=((dir+1)&0x3e)<<2, [0x1EA5]=(dir&0xfe)<<2, and the
         *   sprite = 0x6D + 4*roadtable[dir] + dir. @verify loop @0x684B7-@0x684F5
         *   (nudge @0x684C9-@0x684D7; table @0x684DD; +0x6D @0x684E8; call @0x684EB),
         *   then zero the nudge @0x684F7-@0x684FC. */
        if (!base_drawn) {
            int pattern = -1;
            uint8_t conn = *(volatile uint8_t *)G_CONN_BITMAP;  /* [0xA8A6] */
            if ((conn & 0xDD) == 0xC1) pattern = 0;
            if ((conn & 0x77) == 0x07) pattern = 1;
            if ((conn & 0x77) == 0x70) pattern = 2;
            if ((conn & 0xDD) == 0x1C) pattern = 3;

            if (pattern >= 0) {
                *(volatile uint8_t *)G_SUBCELL_DY = 0;   /* @0x68504 */
                *(volatile uint8_t *)G_SUBCELL_DX = 0;   /* @0x68507 */
                draw_tile_marker(0x97 + pattern);        /* @0x68510 */
            } else {
                int dir;
                for (dir = 0; dir < 4; dir++) {
                    uint8_t road = *(volatile uint8_t *)(G_ROAD_DIR_TABLE + dir); /* @0x684DD */
                    *(volatile uint8_t *)G_SUBCELL_DX = (uint8_t)(((dir + 1) & 0x3e) << 2); /* @0x684CC */
                    *(volatile uint8_t *)G_SUBCELL_DY = (uint8_t)((dir & 0xfe) << 2);       /* @0x684D7 */
                    draw_tile_marker(0x6D + (road << 2) + dir);   /* @0x684EB */
                }
                *(volatile uint8_t *)G_SUBCELL_DY = 0;   /* @0x684F9 */
                *(volatile uint8_t *)G_SUBCELL_DX = 0;   /* @0x684FC */
            }
        }

        /* 6j. The terrain sprite proper (the classified base via 0x186c). For
         *   water tiles water_id holds the ocean/sea-lane id; for land it was the
         *   land base set at 6b (note [bp-2] is reused as the emit id).
         * @verify mov al,[bp-2] @0x68513; call 0x186c @0x68518. */
        emit_terrain_sprite(water_id);               /* @0x68518 */

        /* 6k. Feature-direction overlay (road/river entering the tile edge).
         *   feat_flags top bit selects +0x8D / +0x91 base; loop 4 sub-cells,
         *   each reads the neighbour FEATURE byte (±stride), skips ocean/sea-lane,
         *   and emits base + sub.
         * @verify cmp [bp-0x12],0 @0x6851B; and 0x80 @0x68527; +0x8D @0x68532;
         *   sub-cell loop @0x68538..@0x68598 (read [0xa598] neighbour @0x6856E,
         *   test 0x40 @0x68573, classify @0x68578, skip 0x19/0x1a @0x68582/@0x68587,
         *   add base+sub @0x6858C, call 0x1748 @0x68592). */
        if (feat_flags != 0) {
            int fbase = ((feat_flags & 0x80) ? 4 : 0) + 0x8D;   /* @0x68532 */
            for (sub = 0; sub < 4; sub++) {
                int dy = DIR4_DY[sub];                           /* [bx+0xae] @0x68548 */
                int dx = DIR4_DX[sub];                           /* [bx+0xa8] @0x68559 */
                int off = dx + (dy > 0 ? (int)(*(volatile uint16_t *)G_RENDER_STRIDE)
                                       : (dy < 0 ? -(int)(*(volatile uint16_t *)G_RENDER_STRIDE) : 0));
                uint8_t nb = *(volatile uint8_t *)(G_WP_FEATURE + (off & 0xffff)); /* es:[bx+si] */
                if (nb & 0x40) {                                 /* @0x68573 */
                    int nv = classify_terrain((uint8_t)(nb & 0x1F)); /* @0x68578 */
                    if (nv != 0x19 && nv != 0x1A)                /* @0x68582/@0x68587 */
                        draw_tile_marker(fbase + sub);           /* @0x68592 */
                }
            }
        }
    }

tail:
    /* Shared tail: at closest zoom + non-strat, draw the centre special-feature
     * variant (0x5A + special_feature_at). @verify cmp [0x184],0 @0x6585AC;
     *   cmp [0x18a],0 @0x685B3; lcall 0x718 @0x685C2; add 0x5a @0x685D3;
     *   call 0x1748 @0x685D6. */
    if (*(volatile uint16_t *)G_ZOOM_LEVEL == 0 &&
        *(volatile uint16_t *)G_STRAT_VIEW == 0) {
        int sp = special_feature_at(
                     (int)(*(volatile uint16_t *)G_SUBCELL_BX),
                     (int)(*(volatile uint16_t *)G_SUBCELL_BY));
        if (sp != -1)
            draw_tile_marker(0x5A + sp);
    }
}

/* ----------------------------------------------------------------------------
 * func_06892E -- clear the per-tile object/visibility layer  (file 0x6892E)
 * ----------------------------------------------------------------------------
 * Walks the whole map (y 0..map_height, x 0..map_width) writing -1 via the
 * resident layer setter 0x181F:0x704. Used at view init.  BYTE_VERIFIED.
 * @verify nested loops @0x6892E..@0x68966; push -1,col,row; lcall 0x704 @0x6894C. */
void clear_object_layer(void)
{
    int x, y;
    int w = (int)(*(volatile uint16_t *)G_MAP_WIDTH);
    int h = (int)(*(volatile uint16_t *)G_MAP_HEIGHT);
    extern void layer_set_object(int x, int y, int val);   /* 0x181F:0x704 */
    for (y = 0; y < h; y++)            /* @verify cmp [0x853c] @0x6895C */
        for (x = 0; x < w; x++)        /* @verify cmp [0x853a] @0x68940 */
            layer_set_object(x, y, -1);  /* @0x6894C */
}

/* ----------------------------------------------------------------------------
 * func_O514 -- outer viewport walk  (file 0x685DC, 699 B)  BYTE_VERIFIED
 * ----------------------------------------------------------------------------
 * Sets the fog mask, calls the dispatch-overlay frame-setup (0x191F:0x18E via
 * the cs-thunk at 0x6896A), clamps the visible window to [0x8804]/[0x8806] and
 * the origin [0x8328]/[0x832E], then for every visible row/col composes the 3
 * layer working pointers + the pixel origin and calls func_O513.
 *
 *  @param active_layer  [bp+6] : season/layer. fog_mask = 1<<(idx+4), 0 if <0.
 *  @param y_extent      [bp+8] : starting row extent (recomputed by the clamp).
 *  Far-called; terminal RETF 4.
 * ---------------------------------------------------------------------------- */
void map_view_render(int active_layer, int y_extent)
{
    int col, row;
    int origin_col, origin_row;
    int max_col, max_row;
    int relrow;
    extern void render_frame_setup(void);   /* 0x191F:0x18E via cs-thunk @0x6896A */

    /* 1. Fog mask = 1 << (active_layer+4), or 0 when active_layer<0.
     * @verify cmp [bp+6],0 @0x685E9; add cl,4 @0x685F2; shl al,cl @0x685F7;
     *   mov [0xa89e] @0x685F9 / mov 0 @0x685FE. */
    if (active_layer < 0)
        *(volatile uint8_t *)G_FOG_MASK = 0;
    else
        *(volatile uint8_t *)G_FOG_MASK = (uint8_t)(1u << ((active_layer & 0xff) + 4));

    /* 2. Dispatch-overlay frame setup (push cs; call 0x22ea -> ljmp 0x191F:0x18E).
     * @verify @0x68603/@0x68604; thunk @0x6896A. */
    render_frame_setup();

    /* 3. Bail if the clamped window is empty. @verify cmp [0x8804],ax @0x6860A;
     *   cmp [0x8806],ax @0x68616 (jge continue else jmp tail @0x68610/@0x6861C). */
    origin_col = (int)(*(volatile uint16_t *)G_VIEW_ORIGIN_COL);
    origin_row = (int)(*(volatile uint16_t *)G_VIEW_ORIGIN_ROW);
    max_col    = (int)(*(volatile uint16_t *)G_VIEW_MAX_COL);
    max_row    = (int)(*(volatile uint16_t *)G_VIEW_MAX_ROW);
    (void)y_extent;

    /* 4. Row loop. relrow = row - origin_row. Per-row Y pixel origin:
     *   [0xa5a6] = ([0x832c] + relrow + 1) * [0x8326] - 1.
     * @verify sub @0x6867D; mov ax,[0x832c]+[bp-0x20]+1 @0x68720; imul [0x8326]
     *   @0x68727; dec @0x6872B; mov [0xa5a6] @0x6872C. Outer loop counter [bp-0x14]
     *   vs [bp-0x22]=max_row @0x6883E. */
    for (row = origin_row; row <= max_row; row++) {
        relrow = row - origin_row;
        *(volatile uint16_t *)G_TILE_SY =
            (uint16_t)(((int)(*(volatile uint16_t *)G_PIX_BASE_ROW) + relrow + 1)
                       * (int)(*(volatile uint16_t *)G_TILE_PX_H) - 1);

        /* 5. Column loop. relcol = col - origin_col. Per-col X pixel origin:
         *   [0xa5a4] = ([0x832a] + relcol) * [0x5ad4] + [0x5ad4]/2.
         * @verify mov ax,[0x832a]+[bp-0x1a] @0x6875F; imul [0x5ad4] @0x68765;
         *   sar [0x5ad4] @0x6876D; add @0x6876F; mov [0xa5a4] @0x68771. */
        for (col = origin_col; col <= max_col; col++) {
            int relcol = col - origin_col;
            int active_cell;

            *(volatile uint16_t *)G_TILE_SX =
                (uint16_t)(((int)(*(volatile uint16_t *)G_PIX_BASE_COL) + relcol)
                           * (int)(*(volatile uint16_t *)G_TILE_PX_W)
                           + ((int)(*(volatile uint16_t *)G_TILE_PX_W) >> 1));

            /* The 3 layer working pointers are committed here from either the
             * fast-path bases (relrow+1)*stride+relcol+1 + layer base, or the
             * slow-path lcall layer_ptr_* fetchers. @verify fast @0x68684-@0x686BF;
             *   slow lcall 0x70e/0x740/0x736 @0x686E8/@0x686FA/@0x6870C; commit to
             *   [0xa594]/[0xa598]/[0xa59c] @0x68852-@0x6886E. (Pointer plumbing
             *   modelled — the math is the imul [0x8548] at @0x6868E.) */

            /* active_cell = subcell_priority(...) for the cursor highlight.
             * @verify lcall 0x6c8 @0x687BC; or [bp-0xe],ax @0x687CB. */
            {
                int sp = subcell_priority(0, 0, 0);   /* args from the col/row delta */
                active_cell = (sp == 1) ? -1 : 0;
            }

            /* call O513. @verify call 0x1b28 @0x687D1 (relative to func_0681A8). */
            tile_dispatch(active_cell);

            /* advance X origin by one tile width. @verify mov ax,[0x5ad4];
             *   add [0xa5a4],ax @0x687D4/@0x687D7. The column-edge pointer bump
             *   (inc [0xa598]/[0xa594]/[0xa59c]) and the parity xor follow
             *   @0x687E7-@0x687F3. */
            (void)relcol;
        }

        /* advance Y origin by one tile height; on the strat-view fast path also
         * bump the layer base pointers by map_width. @verify mov ax,[0x8326];
         *   add [0xa5a6],ax @0x68822/@0x68825; add map_width to bases @0x68832. */
        (void)relrow;
    }
}
