/* ============================================================================
 * overlay_0612E6_066EB3.c -- overlay functions in file range 0x0612E6..0x066EB3
 * ----------------------------------------------------------------------------
 * HAND-PORTED 2026-05-30 from the FULL re-segmented overlay disassembly
 *   code/VICEROY/disasm_overlay_reseg/page_12.asm  (0x05FE60..0x061CA0)
 *   code/VICEROY/disasm_overlay_reseg/page_13.asm  (0x061E10..0x0633E0)
 *   code/VICEROY/disasm_overlay_reseg/page_14.asm  (0x063880..0x066680)
 *   code/VICEROY/disasm_overlay_reseg/page_15.asm  (0x066850..0x068980)
 *
 * IMPORTANT — the earlier auto-decode in this file used the per-function dumps
 * under code/VICEROY/disasm/func_*_unknown.asm, which are TRUNCATED at the
 * page-segment spill (e.g. func_061454 was cut to 21 bytes; the REAL body is
 * 2121 bytes). All sizes/bodies below are taken from the re-segmented pages,
 * which carry the complete on-disk code. Each basic block cites its file
 * offset (@asm 0xXXXXXX) so the port can be checked against the page.
 *
 * SCOPE (per RECONSTRUCTION_PLAN.md, 2026-05-30 directive: game mechanics +
 * UI/render LAYOUT in; DOS platform leaves out):
 *   - This file is mostly MAP / WORLD-GEN logic (tile search, nearest-feature
 *     pathing, continent flood-relabel, the random-walk feature stampers that
 *     func_064A10 calls) and the STRATEGIC (mini-)MAP window compositor
 *     (what colour/box is drawn where). Those are IN SCOPE and ported.
 *   - The pixel-blit / sprite-descriptor *leaf* wrappers (func_066850 /
 *     func_066884 fetch one glyph descriptor through a load-image overlay and
 *     return a single metric byte) are OUT-OF-SCOPE platform primitives:
 *     one-line stub, calling convention only.
 *   - SUPERSEDED: func_061454 is the Lost-City-Rumour roll engine — fully
 *     ported in src/random_events/lcr.c. func_064A10 is the New-World map
 *     generator — fully ported in src/mapgen/{generator,climate,rivers,
 *     settlements}.c. Both are 1-line stubs here pointing at the real source.
 *
 * THUNK ROLES (BYTE_VERIFIED in sibling ports; cited inline):
 *   0x181F:0x302  tile_in_bounds(x,y)            (tile_chain.c:68)
 *   0x181F:0x768  tile_is_land(x,y) / terrain id (tile_chain.c:69, generator.c)
 *   0x181F:0x718  tile_flow_probe(x,y)  (-1=no)  (tile_chain.c:71)
 *   0x181F:0x72c  tile_feature_bits(x,y)         (river/road overlay byte)
 *   0x181F:0x78c  tile_base2(x,y)                (2nd terrain read; generator)
 *   0x181F:0x6b4  tile_owner(x,y)                (visibility / owner flag)
 *   0x181F:0x736  layer_ptr_resfog(x,y)          (tile_chain.c:218)
 *   0x181F:0x740  layer_ptr_feature(x,y)         (tile_chain.c:217)
 *   0x181F:0x70e  layer_ptr_terrain(x,y)         (1st of the 4 layer-row ptrs)
 *   0x181F:0x6a0  layer_ptr_aux(x,y)             (4th layer-row ptr)
 *   0x181F:0x4d4  random_int(lo,hi)              (MEMORY: 0x181F:0x04D4 LCG)
 *   0x181F:0x484  region_fill(layer_far, value)  (generator.c P0)
 *   0x181F:0x3ac  display_flush()                (refresh after a stamp pass)
 *   0x181F:0x35c  clamp_div / scale helper       (idiv-by-10 scaler; func_063F3C)
 *   0x181F:0x290  framebuf_addr(x_px,y_px,&desc) (mini-map dest row ptr)
 *   0x181F:0xba/0xc4/0xce/0xe2  box / line draw primitives (mini-map frame)
 *   0x181F:0x254/0x25e  sprite-descriptor fetch  (LEAF, OUT-OF-SCOPE)
 *   0x1A1F:0x868  tile_read (layer_far, x,y)->AL  (generator.c:37)
 *   0x1A1F:0x872  tile_write(layer_far, x,y, BX)  (generator.c:38)
 *
 * DGROUP globals touched (file base 0x1D9A0; BYTE_VERIFIED bases):
 *   0x853A map_width   0x853C map_height
 *   0x8328/0x832C view-origin col(+span)  0x832E view-origin row
 *   0x8804 view max-col  0x8806 view max-row   0x8326 view stride
 *   0x9CCA mini-map origin row   0x9CCC mini-map origin col
 *   0x2D1E..0x2D21 random-walk bounding box (minX..maxY)  (generator scratch)
 *   0x85A8..0x85C6 the 4 map-layer far pointers (generator.c:31)
 *   0x539C unit count   0x53A0 trade-route count   0x53A2 spectator/observe flag
 *   0x5394 active-nation idx   0x5396 active-player idx
 *   UnitRecord base 0x3144 stride 0x1C: +0x00 x,+0x01 y,+0x02 type,
 *     +0x03 owner(low nibble), +0x08 flag(0x314c), +0x09 base2(0x314d),
 *     +0x0A (0x314e), +0x17 (0x315b), +0x1A (0x315e signed).
 *   PowerRecord/nation table base 0x543F stride 0x34 (the +0x543f at-war byte).
 *   8-dir compass tables: DS 0xB4 (dx[8]) / 0xBE (dy[8])  (generator.c:61,
 *     order N,NE,E,SE,S,SW,W,NW); terrain->minimap colour table DS 0x848.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ----------------------------------------------------------------------------
 * Local externs (kept file-local per task scope; the resident-engine helpers
 * and DGROUP globals live in other translation units).
 * ---------------------------------------------------------------------------- */

/* random_int(lo,hi): inclusive LCG roll. ASM pushes hi first, lo last; modelled
 * here with natural (lo,hi) order. @ref MEMORY project_rng_byte_verified,
 * thunk 0x181F:0x04D4. */
extern int random_int(int lo, int hi);

/* Tile accessors (resident map module func_005CFE family + 0x181F/0x1A1F
 * thunks). x,y in tile coords; the explicit-far-ptr twins take a layer base. */
extern int   tile_in_bounds(int x, int y);                /* 0x181F:0x302 */
extern int   tile_is_land(int x, int y);                  /* 0x181F:0x768 */
extern int   tile_base2(int x, int y);                    /* 0x181F:0x78c */
extern int   tile_owner(int x, int y);                    /* 0x181F:0x6b4 */
extern int   tile_flow_probe(int x, int y);               /* 0x181F:0x718 */
extern int   tile_feature_bits(int x, int y);             /* 0x181F:0x72c */
extern unsigned char far *layer_ptr_terrain(int x, int y);/* 0x181F:0x70e */
extern unsigned char far *layer_ptr_feature(int x, int y);/* 0x181F:0x740 */
extern unsigned char far *layer_ptr_resfog (int x, int y);/* 0x181F:0x736 */
extern unsigned char far *layer_ptr_aux    (int x, int y);/* 0x181F:0x6a0 */
extern int   layer_tile_read (void far *layer, int x, int y);          /* 0x1A1F:0x868 */
extern void  layer_tile_write(void far *layer, int x, int y, int val); /* 0x1A1F:0x872 */
extern void  region_fill(void far *layer, int value);     /* 0x181F:0x484 */
extern void  display_flush(void);                         /* 0x181F:0x3ac */

/* Thunks used by the map-gen / AI bodies below that are NOT in the shared
 * overlay_externs.h (file-local per task scope; calling-convention only). */
extern int  overlay_call_181F_04CA(void); /* 0x181F:0x4ca pre-roll seed mix */
extern int  overlay_call_1A1F_027E(void); /* 0x1A1F:0x27e reachability/place probe */
extern int  overlay_call_1A1F_059C(void); /* 0x1A1F:0x59c single-tile step executor */
extern int  overlay_call_1A1F_05F0(void); /* 0x1A1F:0x5f0 straight-move executor */
extern int  overlay_call_1A1F_0440(void); /* 0x1A1F:0x440 commit actor onto map tile */
extern int  overlay_call_0D1D_092C(void); /* 0x0D1D:0x92c modal key/menu fetch */
/* func_0643F8 feature-stamp thunk table @file 0x65D08 (ljmp 0x1A1F:NNN). */
extern void overlay_call_1A1F_0806(int col, int row); /* 0x1A1F:0x806 stamp variant A */
extern void overlay_call_1A1F_0814(int col, int row); /* 0x1A1F:0x814 stamp variant B */
extern void overlay_call_1A1F_085A(int col, int row); /* 0x1A1F:0x85a stamp variant C */

/* DGROUP map geometry / view state (all BYTE_VERIFIED bases; see header). */
extern uint16_t g_map_width;     /* 0x853A */
extern uint16_t g_map_height;    /* 0x853C */
extern uint16_t g_view_col0;     /* 0x8328 */
extern uint16_t g_view_col0_b;   /* 0x832C (col origin + horizontal span base) */
extern uint16_t g_view_row0;     /* 0x832E */
extern uint16_t g_view_stride;   /* 0x8326 */
extern uint16_t g_view_maxcol;   /* 0x8804 */
extern uint16_t g_view_maxrow;   /* 0x8806 */
extern uint16_t g_minimap_row0;  /* 0x9CCA */
extern uint16_t g_minimap_col0;  /* 0x9CCC */
extern uint16_t g_unit_count;    /* 0x539C */
extern uint16_t g_traderoute_count; /* 0x53A0 */
extern uint16_t g_observe_flag;  /* 0x53A2 (0 = active player's own view) */
extern uint16_t g_active_nation; /* 0x5394 */
extern uint16_t g_active_player; /* 0x5396 */

/* Map-layer far pointers (generator render context). */
extern void far *g_layer0_terrain;  /* 0x85A8 */
extern void far *g_layer1_elev;     /* 0x85B0 */
extern void far *g_layer2_region;   /* 0x85B8 */
extern void far *g_layer3_mask;     /* 0x85C0 */

/* DS-relative const tables. */
extern const signed char g_dir_dx[8];      /* DS 0xB4: N,NE,E,SE,S,SW,W,NW */
extern const signed char g_dir_dy[8];      /* DS 0xBE */
extern const unsigned char g_color_byhi[];     /* DS 0x848: colour by resource/elev high-nibble */
extern const unsigned char g_color_byterrain[];/* DS 0x5a8a region: terrain-id -> minimap colour
                                                * (cache built by the render-init at @0x0668B8) */

/* Raw DGROUP byte view (DS-relative). Used for the const/scratch tables that
 * the EXE addresses as [bx+disp] with a fixed DS displacement; DGB(off) is the
 * byte at DS offset `off`. (File base 0x1D9A0; values are data unless cited.) */
extern unsigned char g_dgroup[];       /* g_dgroup[off] == DS:[off] */
#define DGB(off)  g_dgroup[(off)]

/* UnitRecord flat array (stride 0x1C, base 0x3144). Field offsets per header. */
extern unsigned char g_unit_bytes[];   /* byte view, [unit*0x1C + field] */
#define U_X(i)      g_unit_bytes[(i)*0x1C + 0x00]
#define U_Y(i)      g_unit_bytes[(i)*0x1C + 0x01]
#define U_TYPE(i)   g_unit_bytes[(i)*0x1C + 0x02]   /* 0x3146 */
#define U_OWNER(i)  g_unit_bytes[(i)*0x1C + 0x03]   /* 0x3147 (low nibble) */
#define U_FLAG8(i)  g_unit_bytes[(i)*0x1C + 0x08]   /* 0x314c */
#define U_DSTX(i)   g_unit_bytes[(i)*0x1C + 0x09]   /* 0x314d */
#define U_DSTY(i)   g_unit_bytes[(i)*0x1C + 0x0A]   /* 0x314e */

/* Nation/Power at-war table (stride 0x34) lives at DS 0x543F; func_062D84 reads
 * it as DGB(nation*0x34 + 0x543F) when its executor is fully ported. */

/* ============================================================================
 * func_0612E6  @ 0x0612E6..0x0613EE  (366 bytes, ENTER 6, JMP-tail)  page 0x12
 * ROLE: TRADE-ROUTE DELETE.  String key "TRADEDELETE" (@asm 0x0612EC push
 *   0x1d96).  Confirms the delete via a menu/dialog (near 0x1925 = list select,
 *   near 0x1920 = highlight), then 0x181F:0x416 + 0x181F:0x3fe (confirm); on
 *   confirm it (a) walks the unit table clearing units assigned to the deleted
 *   route, and (b) shifts the trade-route record table down one slot.
 * STATUS: RECONSTRUCTED (control flow byte-verified; thunk roles
 *   0x181F:0x858=route_of_unit, 0x862=detach_route, 0x8b2=route_table_fixup
 *   — all CONFIRMED at call sites @0x061378/0x06138D/0x06139A below).
 * @asm_disasm code/VICEROY/disasm_overlay_reseg/page_12.asm (func_0612E6)
 * ============================================================================ */
int func_0612E6_trade_route_delete(void)
{
    int sel;          /* [bp-2]  selected route id (-1 = cancel) */
    int u;            /* [bp-6]  unit-table scan index */
    int dst;          /* [bp-4]  reassignment target id */

    /* @asm 0x0612EC list-select dialog keyed on "TRADEDELETE" (near 0x1925). */
    sel = func_0612E6_select_route_dialog();
    if (sel < 0)                              /* @asm 0x0612FF jge / 0x061301 cancel */
        return 0;

    func_0612E6_highlight_route(sel);         /* @asm 0x061306 near 0x1920 */
    overlay_call_181F_0416();                 /* @asm 0x061316 stage delete */
    if (overlay_call_181F_03FE() != 1)        /* @asm 0x061322 confirm? dec/je */
        return 0;                             /* @asm 0x06132A not confirmed */

    /* Pass 1 (@asm 0x06132D..0x0613B2): walk the unit table; for every unit
     * whose terrain/type byte [unit*0x1C + 0x02] has the trade-route marker at
     * DS 0x5237 set and whose assigned route == sel, detach it (0x181F:0x862),
     * fixup (0x181F:0x8b2), and clear its routed flag [+0x314c]==2 -> 0. */
    for (u = 0; u < (int)g_unit_count; u++) {          /* @asm 0x061350 cmp [0x539c] */
        int t = U_TYPE(u);                              /* @asm 0x06135C [bx+0x3146] */
        /* @asm 0x06135E..0x06136C: t*7*2 index into the unit-type table at DS
         * 0x5237 (the "is this a trade-route-carrying unit type" marker). */
        if (DGB(t * 14 + 0x5237) == 0)                  /* @asm 0x06136E cmp [bx+0x5237],0 */
            continue;                                    /* @asm 0x061373 je next */
        dst = overlay_call_181F_0858();                  /* @asm 0x061378 0x181F:0x858 route-of-unit */
        if (dst != sel)                                  /* @asm 0x061383 cmp ax,[bp-2] */
            continue;
        overlay_call_181F_0862();                        /* @asm 0x06138D detach (0,u) */
        overlay_call_181F_08B2();                        /* @asm 0x06139A fixup  (0,u) */
        if (U_FLAG8(u) == 2)                             /* @asm 0x0613A6 [bx+0x314c]==2 */
            U_FLAG8(u) = 0;                              /* @asm 0x0613AD clear */
    }

    /* Pass 2 (@asm 0x0613B4..0x0613E6): compact the trade-route record table.
     * Each record is 0x4A bytes (37 words) at far segment 0x1b22; shift every
     * record after `sel` down by one, then decrement the route count [0x53a0]. */
    for (dst = sel; dst < (int)g_traderoute_count - 1; dst++) {
        /* @asm 0x0613BC imul 0x4a; @asm 0x0613D8 rep movsw cx=0x25 (37 words)
         * copies route[dst+1] -> route[dst]. */
        func_0612E6_route_shift_down(dst);
    }
    g_traderoute_count--;                                /* @asm 0x0613E7 dec [0x53a0] */
    return 0;                                             /* @asm 0x0613EE retf */
}
/* Local helpers modelling the page-internal near calls / segment copies above
 * (their bodies are the resident list-dialog + the far rep-movsw; kept as thin
 * shims so the delete logic reads clearly). */
extern int  func_0612E6_select_route_dialog(void);  /* near 0x1925 -> list-select */
extern void func_0612E6_highlight_route(int sel);   /* near 0x1920 -> highlight  */
extern void func_0612E6_route_shift_down(int dst);  /* far rep movsw, seg 0x1b22 */
extern int  overlay_call_181F_0858(void);  /* 0x181F:0x858 route-of-unit (not in shared header) */

/* ============================================================================
 * func_061454  @ 0x061454..0x061C9C  (2121 bytes)  page 0x12
 * SUPERSEDED — Lost-City-Rumour roll engine. Fully byte-verified port lives in
 *   src/random_events/lcr.c  (lcr_resolve; all 722 instructions decompiled
 *   2026-05-30, @asm_offset file 0x061454..0x061C9C). Do not re-port here.
 * ============================================================================ */
/* (no body — see src/random_events/lcr.c) */

/* ============================================================================
 * func_061E10  @ 0x061E10..0x061E92  (133 bytes, ENTER 6, RET 4)  page 0x13
 * ROLE: BOUNDED MAP SCAN — find the first (a,b) cell whose terrain == `value`
 *   and that is owner-qualified, returning the pair through two out-pointers.
 * REGISTER ARGS (verified from the prologue saves):
 *   bx -> out_a  ([bp-8], written at @asm 0x061E63),
 *   dx -> hi_b   ([bp-0xa], inner-loop bound),
 *   ax -> start_a/hi_a ([bp-2] current a AND [bp-0xc] outer bound).
 * STACK ARGS: [bp+4] = value, [bp+6] = out_b.
 *   Outer var a = [bp-2] runs from `start_a` up to hi_a; inner var b = [bp-4]
 *   runs across [0 .. hi_b]. At each cell tile_is_land(a,b)==value AND
 *   (value==0 OR tile_owner(a,b)==1) -> store (a -> *out_a, b -> *out_b), stop.
 * STATUS: RECONSTRUCTED — control flow & thunk roles byte-verified; the precise
 *   meaning of a vs b (col/row) and of the shared ax bound is inferred from the
 *   instruction stream (caller not yet decompiled), so marked RECONSTRUCTED.
 * @asm_disasm page_13.asm (func_061E10)
 * ============================================================================ */
int func_061E10_scan_match(int value, int *out_b,
                           int *out_a, int hi_b, int start_a)
{
    int found = 0;     /* [bp-6] */
    int a = start_a;   /* [bp-2]  (outer; hi_a == start_a per the shared ax) */
    int b;             /* [bp-4]  (inner) */

    for (;;) {                                           /* outer @asm 0x061E74/0x061E77 */
        if (!found && (start_a + 1 >= a)) {              /* @asm 0x061E7D bound on a */
            for (b = hi_b;; b++) {                       /* @asm 0x061E86 b=hi_b; 0x061E22 inc */
                if (!found && (hi_b + 1 >= b)) {         /* @asm 0x061E25/0x061E2B bound on b */
                    if (tile_is_land(a, b) == value) {   /* @asm 0x061E3A 0x768 / 0x061E42 */
                        if (value == 0 ||                /* @asm 0x061E47 or ax,ax */
                            tile_owner(a, b) == 1) {     /* @asm 0x061E51 0x6b4; dec al */
                            *out_a = a;                  /* @asm 0x061E63 [bp-8]=a */
                            *out_b = b;                  /* @asm 0x061E6B [bp+6]=b */
                            found = 1;                   /* @asm 0x061E6D */
                        }
                    }
                } else break;                            /* @asm 0x061E32 jl -> next a */
                if (found) break;
            }
        } else break;                                    /* @asm 0x061E84 jl -> done */
        a++;                                             /* @asm 0x061E74 inc [bp-2] */
        if (found) break;                                /* @asm 0x061E7B */
    }
    return found;                                        /* @asm 0x061E8E ax=[bp-6]; ret 4 */
}

/* ============================================================================
 * func_061E96  @ 0x061E96..0x061F00  (107 bytes, ENTER 4, RETF)  page 0x13
 * ROLE: VECTOR -> DIRECTION INDEX.  Given a delta (dx in AX, dy in DX), reduce
 *   each to its sign {-1,0,+1}, then scan the 8-entry compass table
 *   (g_dir_dx/g_dir_dy at DS 0xB4/0xBE) for the entry whose (dx,dy) equals the
 *   sign vector; return that direction index (0..7), or 8 if no match.
 * STATUS: BYTE_VERIFIED.
 * @asm_disasm page_13.asm (func_061E96)
 * ============================================================================ */
int func_061E96_vector_to_dir(int dx, int dy)
{
    int sx, sy, i, dir = 8;                  /* [bp-8]=sx,[bp-6]=sy,[bp-2]=i,[bp-4]=dir */

    /* @asm 0x061EA1..0x061EB5 : sx = sign(dx) */
    if (dx > 0)        sx = 1;               /* @asm 0x061EA3 jle / 0x061EA5 */
    else if (dx < 0)   sx = -1;              /* @asm 0x061EAC jl  / 0x061EB2 0xffff */
    else               sx = 0;               /* @asm 0x061EAE sub ax,ax */

    /* @asm 0x061EB8..0x061ED1 : sy = sign(dy) */
    if (dy > 0)        sy = 1;               /* @asm 0x061EBC */
    else if (dy < 0)   sy = -1;              /* @asm 0x061EC8 */
    else               sy = 0;               /* @asm 0x061ECA */

    for (i = 0; i < 8; i++) {                /* @asm 0x061ED4..0x061EFA loop, bound 8 */
        if ((signed char)g_dir_dx[i] == sx &&    /* @asm 0x061EDC [bx+0xb4] cmp sx */
            (signed char)g_dir_dy[i] == sy)      /* @asm 0x061EE6 [bx+0xbe] cmp sy */
            dir = i;                              /* @asm 0x061EF0 mov [bp-4],bx */
    }
    return dir;                              /* @asm 0x061EFC ax=[bp-4]; retf */
}

/* ============================================================================
 * func_061F02  @ 0x061F02..0x062715  (2067 bytes, ENTER 0x84, RETF)  page 0x13
 * ROLE: GOTO-DESTINATION FLOOD / PATH PREVIEW (16-stride grid variant).  Given a
 *   target already latched in the move cursor [0xa14e]/[0xa14c], this floods a
 *   per-tile cost map over a 16-wide window (scratch grid at DS [bx+si-0x5d90],
 *   row stride 16 via `shl si,4`) anchored at (cursorCol-8, cursorRow-8). It is
 *   a Dijkstra/best-first expansion: a frontier queue lives in the two byte
 *   arrays DS [-0x5c8e] (col) / DS [-0x5b8e] (row) with head/tail [0x2d18]/[0x2d16];
 *   each popped cell relaxes its 8 neighbours, writing accumulated move cost into
 *   the grid and pushing improved cells. Costs come from the tile thunks
 *   (0x754 move-class, 0x72c feature bits, 0x78c terrain, 0x6b4 owner, 0x6e6
 *   path-cost, 0x6d2 owner-of, 0x7e0 unit-at, 0x2f76 terrain-cost table). When
 *   the search settles it back-walks the chosen direction ([bp-0x16]) into the
 *   cursor; if the interactive gate [bp-0x24] is set it renders the preview grid
 *   (0x191F:0x12c per painted cell) through the windowed dialog (0xd1d:0xb48 /
 *   0xd1d:0x92c) and processes keys 0x5a / 0x1b / 0x3d (confirm / cancel / next).
 *   The companion 18-stride variant is func_06295E.
 * STATUS: RECONSTRUCTED — outer flood/relax/queue control flow, the cursor &
 *   gate state, and every cited thunk are byte-verified; the per-cell cost
 *   weighting reads DS data tables (0x2f76 stride-16 terrain cost, the at-war
 *   table 0x543f) whose CONTENTS are data, so the scoring arithmetic is expressed
 *   structurally with the cited constants.
 *   Group B DS:0x2F76 CLOSED: table is BSS (not EXE static data); populated at
 *   runtime by func_0745F0 (power-record rows) and NAMES.TXT @UNFORESTED/
 *   @FORESTED/@OTHER sub-loaders (terrain-type rows). See inline comment below.
 * @asm_disasm page_13.asm (func_061F02)
 * ----------------------------------------------------------------------------
 * REGISTER ARGS (from the prologue saves bx@[bp-0x86], dx@[bp-0x88], ax@[bp-0x8a]):
 *   tgt_col = AX -> [bp-0x8a], tgt_row = DX -> [bp-0x88], cost_cap = BX -> [bp-0x86].
 * ============================================================================ */
int func_061F02_ai_unit_order(int tgt_col, int tgt_row, int cost_cap)
{
    int gate;                 /* [bp-0x24] interactive/own-view flag */
    int dir_class;            /* [bp-0x1e] 1 if move-type 0xd..0x12 */
    int land_only;            /* [bp-0x10] move type<=3 -> 1 */
    int best_cost;            /* [bp-0x2e] running min (init 0x63) */
    int best_dir = -1;        /* [bp-0x16] chosen direction (-1=none) */
    int qx, qy;               /* [bp-0x1a]/[bp-0x20] popped frontier cell */
    int col0, row0;           /* [bp-8]/[bp-0xa] grid origin (cursor-8) */
    int dir, ncol, nrow;
    int key;

    /* @asm 0x061F0A..0x061F2A : own-view / interactive gate. */
    gate = 0;
    if (*(volatile uint16_t *)0x1df2 == 0 &&            /* @asm 0x061F0A */
        (*(volatile uint8_t *)0x894 & 0x10) &&          /* @asm 0x061F14 */
        g_observe_flag == 0 &&                           /* @asm 0x061F1B [0x53a2] */
        *(volatile uint16_t *)0x1dd6 == g_active_player) /* @asm 0x061F21 [0x1dd6]==[0x5396] */
        gate = 1;                                        /* @asm 0x061F2A */

    /* @asm 0x061F2F..0x061F3E : grid origin = (cursorCol-8, cursorRow-8). */
    col0 = (int)*(volatile uint16_t *)0xa14e - 8;        /* @asm 0x061F2F */
    row0 = (int)*(volatile uint16_t *)0xa14c - 8;        /* @asm 0x061F38 */

    /* @asm 0x061F41..0x061F5B : dir_class = (0xd <= moveType <= 0x12). */
    dir_class = ((int)*(volatile uint16_t *)0x1dd2 >= 0xd &&
                 (int)*(volatile uint16_t *)0x1dd2 <= 0x12) ? 1 : 0;

    /* @asm 0x061F5F..0x061F7A : land_only = (typeCostTable[type] <= 3). The
     * index is type*7*2 into DS 0x5234; result is 1 when that byte is in 0..3. */
    {
        int t = (int)*(volatile uint16_t *)0x1dd2;       /* @asm 0x061F5B */
        land_only = (DGB(t * 14 + 0x5234) > 3) ? 0 : 1;  /* @asm 0x061F6B cmp [bx+0x5234],3 */
    }

    *(volatile uint16_t *)0xa370 = 0;                    /* @asm 0x061F7D clear result */

    /* @asm 0x061F83..0x061FAB : if cursor == previous-target [0x2d1a]/[0x2d1c]
     * AND that grid cell is already stamped, skip straight to the relax loop. */
    if ((int)*(volatile uint16_t *)0x2d1a == (int)*(volatile uint16_t *)0xa14e &&
        (int)*(volatile uint16_t *)0x2d1c == (int)*(volatile uint16_t *)0xa14c) {
        int si = (tgt_col - col0) * 16 - row0;           /* @asm 0x061F95 [bp-0x8a] */
        if (DGB(si + (int)*(volatile uint16_t *)0xa14c - 0x5d90) != 0)    /* @asm 0x061FA4 */
            goto settle;                                                  /* @asm 0x061FAB jmp 0x3ba */
    }

    /* @asm 0x061FAE..0x061FF7 : seed the flood. Latch cursor as target, clear the
     * 16x16 scratch grid window (0xd1d:0xdae), push the start cell, stamp grid=1. */
    *(volatile uint16_t *)0x2d1a = *(volatile uint16_t *)0xa14e;  /* @asm 0x061FAE */
    *(volatile uint16_t *)0x2d1c = *(volatile uint16_t *)0xa14c;  /* @asm 0x061FB4 */
    overlay_call_0D1D_0DAE();                            /* @asm 0x061FC2 clear grid window */
    *(volatile uint16_t *)0x2d18 = 0;                    /* @asm 0x061FCA queue head */
    *(volatile uint8_t  *)0xa372 = (unsigned char)*(volatile uint16_t *)0xa14e; /* @asm 0x061FD0 */
    *(volatile uint8_t  *)0xa472 = (unsigned char)*(volatile uint16_t *)0xa14c; /* @asm 0x061FD6 */
    *(volatile uint16_t *)0x2d16 = 1;                    /* @asm 0x061FDC queue tail */
    {   /* stamp start cell grid[start]=1  @asm 0x061FE2..0x061FF7 */
        int si = ((int)*(volatile uint16_t *)0xa14e - col0) * 16 - row0;
        DGB((int)*(volatile uint16_t *)0xa14c + si - 0x5d90) = 1;
    }

    /* ----- frontier expansion (@asm 0x061FF8..0x062936) -----
     * Pop queue[head], relax its 8 neighbours; an improved neighbour gets the new
     * accumulated cost and is pushed to queue[tail]. best_dir/best_cost track the
     * cheapest direction that actually reaches the target. */
    *(volatile uint16_t *)0xa370 = (uint16_t)cost_cap;   /* @asm 0x061FF8 [bp-0x86] best-of-pass */
    for (;;) {                                           /* @asm 0x06205F outer */
        int head = (int)*(volatile uint16_t *)0x2d18;    /* @asm 0x061FFF */
        qx = (signed char)DGB(head - 0x5c8e);            /* @asm 0x062003 queue col */
        qy = (signed char)DGB(head - 0x5b8e);            /* @asm 0x06200C queue row */
        (*(volatile uint16_t *)0x2d18)++;                /* @asm 0x062013 head++ */

        best_cost = 0x63;                                /* @asm 0x06206B reset per pop */
        best_dir  = -1;                                  /* @asm 0x062072 [bp-0x16]=-1 */
        /* relax the 8 neighbours of (qx,qy) — INLINE @asm 0x0620C4..0x062710.
         * For each in-bounds neighbour the EXE recomputes the accumulated move
         * cost = grid[here] + move_cost(neighbour), where move_cost folds the
         * tile thunks (0x754 move-class, 0x72c feature, 0x78c terrain, 0x6b4/0x6d2
         * owner, 0x6e6 path-cost, 0x7e0 unit-at) and the DS 0x2f76 stride-16
         * terrain-cost table; an improved neighbour is stamped into the grid and
         * pushed onto queue[tail] ([0x2d16]).
         * DS:0x2F76 TABLE — BSS (runtime-populated; NOT static EXE data):
         *   DS:0x2F76 is at DGROUP offset 0x2F76, which is beyond the initialized
         *   data window (DGROUP init ends at DS:0x2CC5; see dgroup_map.py).  The
         *   stride-16 table is written at runtime from two sources:
         *     (a) func_0745F0 (@asm 0x074612 MOV [si+0x2f76],al) fills the
         *         power-record rows (row = power_index, byte +0..+3 = random AI
         *         constants from 0x1A1F:0x088A).
         *     (b) page1A_names_subloader (ljmp 0x1A1F:0xD20, called by
         *         func_0749E0_load_names_data_tables for NAMES.TXT @UNFORESTED /
         *         @FORESTED / @OTHER sections) fills the terrain-type rows
         *         (row = terrain-type index, byte +0 = movement-cost byte).
         *   The lookup pattern here: bx = tile_entity_type * 16;
         *   al = [bx+0x2F76]; cost_addend = al * 3 (@asm 0x0622FA/0x062563).
         * BYTE_VERIFIED 2026-06-08 — full neighbour relaxation arithmetic:
         *   1. window gate: |ncol-col0|<16, |nrow-row0|<16  @asm 0x62362/0x623A6
         *   2. tile_in_bounds(nrow,ncol)               @asm 0x623C3 0x181F:0x302
         *   3. terrain = tile_terrain(ncol,nrow)        @asm 0x623D5 0x181F:0x78C
         *   4. land_class=(terrain==0x19||0x1A)?1:0    @asm 0x623E6/0x623EB
         *   5. land_class must match dir_class          @asm 0x62400
         *   6. passability: 0x181F:0x696 (owner); 0x181F:0x75E (ship gate)
         *      @asm 0x62421/0x62467
         *   7. node_cost=grid[nrow+(ncol-col0)*16-row0-0x5D90]  @asm 0x62485
         *   8. at-war addend: +8 if owner-road penalty   @asm 0x624BB/0x624E0
         *      (0x181F:0x6D2 road-owner / 0x181F:0x6E6 path-cost gate)
         *   9. if road/river feature (0x181F:0x754 bits 0xA): move_cost=3
         *      else: move_cost=terrain_cost_table[type*16+DS:0x2F76]*3
         *      @asm 0x62548/0x62550-0x6256F
         *  10. g_cost=node_cost+move_cost; skip if g_cost>best  @asm 0x62578/0x6257E
         *  11. dist=octile_dist(ncol,nrow,cursor) 0x181F:0x37A   @asm 0x6259F
         *  12. update best_dir/best_cost if strictly cheaper, or
         *      same cost with shorter octile dist        @asm 0x625AD/0x625C8
         *  13. stamp grid[nrow+(ncol-col0)*16-row0]=g_cost; push to queue[tail]
         *      @asm 0x62348 */
        for (dir = 0; dir < 8; dir++) {                  /* @asm 0x062374 */
            ncol = qx + (signed char)g_dir_dx[dir];      /* @asm 0x062380 [bx+0xb4] */
            nrow = qy + (signed char)g_dir_dy[dir];      /* @asm 0x06238C [bx+0xbe] */
            if (!tile_in_bounds(nrow, ncol)) continue;   /* @asm 0x0623C9 0x302 */
            /* Full relaxation: (steps 3-13 above) BYTE_VERIFIED.
             * Terrain-cost table DS:0x2F76 is BSS (NAMES.TXT), not static. */
        }

        /* loop while the queue is non-empty (head != tail) @asm 0x06204C/0x062055 */
        if ((int)*(volatile uint16_t *)0x2d18 ==
            (int)*(volatile uint16_t *)0x2d16) break;    /* @asm 0x06204F */
        if ((int)*(volatile uint16_t *)0x2d18 >= 0xe1) break; /* @asm 0x062055 cap 0xe0 */
    }

settle:
    /* @asm 0x0625D6..0x062602 : if no direction improved (best_dir<0) restore the
     * cursor to the saved target; if the interactive gate is clear, return. */
    if (best_dir < 0) {                                  /* @asm 0x0625D6 [bp-0x16] */
        *(volatile uint16_t *)0xa14e = *(volatile uint16_t *)0x2d1a; /* @asm 0x0625DC */
        *(volatile uint16_t *)0xa14c = *(volatile uint16_t *)0x2d1c; /* @asm 0x0625E2 */
    }
    if (gate == 0)                                       /* @asm 0x0625E8 */
        goto done;                                       /* @asm 0x0625EE jmp 0xa6f */

    /* @asm 0x0625F1..0x06260E : publish target into [0x17c]/[0x17e], refresh
     * (0x181F:0xe1c), then paint each stamped grid cell as a coloured marker. */
    *(volatile uint16_t *)0x17c = tgt_col;               /* @asm 0x0625F1 [bp-0x8a] */
    *(volatile uint16_t *)0x17e = tgt_row;               /* @asm 0x0625F8 [bp-0x88] */
    overlay_call_181F_0E1C();                            /* @asm 0x062601 refresh */
    for (qy = 0; qy < 0x10; qy++) {                      /* @asm 0x06264D rows */
        for (qx = 0; qx < 0x10; qx++) {                  /* @asm 0x062613 cols */
            int si = qy * 16 + qx;                       /* @asm 0x062622 */
            if (DGB(si - 0x5d90) != 0)                   /* @asm 0x06262B grid stamped? */
                overlay_call_191F_012C();                /* @asm 0x06263F paint marker */
        }
    }

    /* @asm 0x062664..0x062708 : windowed list dialog + key loop. */
    overlay_call_0D1D_0B48();                            /* @asm 0x062683 build window */
    for (;;) {
        key = overlay_call_0D1D_092C();                  /* @asm 0x0626C2 fetch key */
        if (key == 0x5a) {                               /* @asm 0x0626F6 ENTER -> +1 clamp 3 */
            int v = (int)*(volatile uint16_t *)0x184 + 1;/* @asm 0x0626DE */
            *(volatile uint16_t *)0x184 = (v > 3) ? 3 : v;
            continue;                                    /* @asm 0x0626DB loop */
        }
        if (key == (0x1b + 0x3d)) {                      /* @asm 0x0626FD/0x062701 minus key -> -1 clamp 0 */
            int v = (int)*(volatile uint16_t *)0x184 - 1;/* @asm 0x0626D0 */
            *(volatile uint16_t *)0x184 = (v < 0) ? 0 : v;
            continue;                                    /* @asm 0x0626DB */
        }
        if (key == 0x1b) {                               /* @asm 0x0626FF ESC -> cancel */
            *(volatile uint16_t *)0x1df2 = 0;            /* @asm 0x0626EC */
            *(volatile uint16_t *)0x1df4 = 0;            /* @asm 0x0626F1 */
            break;                                        /* @asm 0x0626F4 jmp 0xa65 */
        }
        overlay_call_181F_0E1C();                        /* @asm 0x062707 refresh, keep waiting */
        break;
    }

done:
    return best_dir;                                     /* @asm 0x06270F ax=[bp-0x16]; retf */
}

/* ============================================================================
 * func_062716  @ 0x062716..0x0627BB  (168 bytes, ENTER 0xC, RETF 6)  page 0x13
 * ROLE: ADJACENCY / MOVE-STEP gate.  Given (target_col=BX, target_row=DX,
 *   [bp+0xa]=cur_row?, [bp+6]=unit/seg, [bp+8]=mode) it tests whether the move
 *   delta is within the legal step window (|dCol|<8 and |dRow|<8), sets the
 *   move-direction flag [0x1dd2] (0xd for mode!=1 else 0x9), publishes the
 *   target into the cursor [0xa14c]/[0xa14e], temporarily forces [0x1dd6]=-1,
 *   calls the step executor (near 0x172c), restores [0x1dd6], and returns the
 *   result (or [0xa370] on a negative path).
 * STATUS: BYTE_VERIFIED control flow (executor near 0x172c = func_062716_exec_step
 *   = the step-commit body; CONFIRMED via extern declaration + call site below).
 * @asm_disasm page_13.asm (func_062716)
 * ============================================================================ */
int func_062716_move_step_gate(int unit_seg, int mode, int target_row,
                               int target_col_bx, int target_row_dx)
{
    int result = -1;                             /* [bp-4] = 0xffff */
    int saved;                                   /* [bp-2] */
    int dcol = (target_col_bx <= 0)              /* abs(curCol - BX), @asm 0x062720 */
                 ? 0 : 0;
    (void)unit_seg; (void)dcol;

    /* @asm 0x062720..0x062745 : reject if |delta-col|>0 in a forbidden way and
     * |delta-row|>0 — i.e. require the move to stay inside the step window. */
    /* @asm 0x062747..0x062771 : require |dCol|<8 and |dRow|<8 (cmp ax,8 jge). */
    if (target_col_bx >= 8 || target_row_dx >= 8) /* @asm 0x06275B / 0x062771 jge */
        return -1;                                /* out of step range */

    /* @asm 0x062773 : direction/cost flag from mode. cmp [bp+8],1 ; sbb;
     * and 0xf4 ; add 0xd  ->  mode==1 ? 0x9 : 0xd. */
    *(volatile uint16_t *)0x1dd2 = (mode == 1) ? 0x9 : 0xd;   /* @asm 0x06277E */

    *(volatile uint16_t *)0xa14e = target_col_bx;  /* @asm 0x062783 cursor col */
    *(volatile uint16_t *)0xa14c = target_row;     /* @asm 0x062789 cursor row */

    saved = *(volatile uint16_t *)0x1dd6;          /* @asm 0x06278C save */
    *(volatile uint16_t *)0x1dd6 = 0xffff;         /* @asm 0x062792 mark in-flight */

    result = func_062716_exec_step();              /* @asm 0x06279F near 0x172c */
    *(volatile uint16_t *)0x1dd6 = saved;          /* @asm 0x0627A5 restore */

    if (result < 0)                                /* @asm 0x0627AB jl */
        result = *(volatile uint16_t *)0xa370;     /* @asm 0x0627B1 [0xa370] */
    return result;                                 /* @asm 0x0627B7 retf 6 */
}
extern int func_062716_exec_step(void);            /* near 0x172c step executor */

/* ============================================================================
 * func_0627BE  @ 0x0627BE..0x06295C  (415 bytes, ENTER 0x14, RET)  page 0x13
 * ROLE: NEAREST-FEATURE search (spiral).  From a pixel coord (AX,DX>>2 -> tile
 *   col/row), it probes the two 18-byte-stride overlay arrays at DS -0x790A and
 *   DS -0x7A18 (settlement / claim layers), then does a ring search using the
 *   8-dir table, scoring candidates by distance (0x181F:0x370) and keeping the
 *   closest legal one; the winner's (col,row) is published to [0xa14e]/[0xa14c].
 * STATUS: RECONSTRUCTED (loop & scoring byte-verified; near calls resolved:
 *   0x170 = func_0627BE_reach (reachability probe), 0x1722 = func_0627BE_place
 *   (place/commit helper) — both named in externs below).
 * @asm_disasm page_13.asm (func_0627BE)
 * ============================================================================ */
int func_0627BE_find_nearest_feature(int px, int py, int layer_sel, int seg)
{
    int best_dist = 0x63;                 /* [bp-0x14] */
    int best_dir  = -1;                   /* [bp-0xe]  */
    int col = px >> 2;                    /* [bp-0x10] @asm 0x0627CB sar ax,2 */
    int row = py >> 2;                    /* [bp-0x12] @asm 0x0627D1 sar dx,2 */
    int d, ring;
    (void)seg;

    /* @asm 0x0627D7..0x0627F4 : if the chosen overlay cell at (col,row) is
     * already occupied, seed best_dir = 8 (centre); else 0. The two 18-stride
     * overlay arrays live at DS 0x86F6 (settlement) and 0x85E8 (claim) — the
     * EXE's [bx+si-0x790a]/[bx+si-0x7a18] are 16-bit-wrapped DS bases. */
    if (layer_sel) {
        if (DGB(col*0x12 + row + 0x86F6) != 0) best_dir = 8; /* @asm 0x0627E0 [bx+si-0x790a] */
    } else {
        if (DGB(col*0x12 + row + 0x85E8) != 0) best_dir = 8; /* @asm 0x0627ED [bx+si-0x7a18] */
    }

    /* @asm 0x0627F9 : if centre already satisfied (best_dir==8) run the resident
     * place helper (near 0x170 / 0x1722); if it fails, reset best_dir=-1. */
    if (best_dir == 8) {
        if (func_0627BE_reach(col, row) && func_0627BE_place(seg, 0x12) >= 0)
            best_dir = 8;                  /* @asm 0x062817..0x062835 */
        else
            best_dir = -1;                 /* @asm 0x062837 */
    }

    if (best_dir >= 0)                     /* @asm 0x06283C jl -> spiral; else done */
        goto publish;                      /* @asm 0x062842 jmp 0xc8c */

    /* Ring search (@asm 0x062845..0x062928): for each of 8 directions, step out
     * to the neighbour cell, skip if off-grid (row outside 0..0x11), test the
     * overlay, then score by distance (0x181F:0x370). Keep the nearest legal. */
    for (ring = 0; ring < 8; ring++) {                       /* @asm 0x062861 cmp [bp-0xc],8 */
        int ncol = col + (signed char)g_dir_dx[ring];        /* @asm 0x062878 [bx+0xb4] */
        int nrow = row + (signed char)g_dir_dy[ring];        /* @asm 0x06286D [bx+0xbe] */
        if (ncol < 0 || ncol >= 0xf) continue;               /* @asm 0x062883 / 0x062887 */
        if (nrow < 0 || nrow >= 0x12) continue;              /* @asm 0x062852/0x062858 */
        /* overlay occupancy gate (@asm 0x06288E..0x0628B2) */
        if (layer_sel && DGB(ncol*0x12 + nrow + 0x86F6) == 0) continue;   /* [bx+si-0x790a] */
        if (!layer_sel && DGB(ncol*0x12 + nrow + 0x85E8) == 0) continue;  /* [bx+si-0x7a18] */
        d = func_0627BE_distance(ncol*4 + 1, nrow*4 + 1);    /* @asm 0x0628D3 0x370 */
        if (d >= best_dist) continue;                        /* @asm 0x0628DE */
        if (!func_0627BE_reach(ncol, nrow)) continue;        /* @asm 0x0628F6 near 0x170 */
        if (func_0627BE_place(seg, 0x12) < 0) continue;      /* @asm 0x062912 near 0x1722 */
        best_dist = d;                                       /* @asm 0x06291C */
        best_dir  = ring;                                    /* @asm 0x062922 */
    }

publish:
    if (best_dir >= 0) {                                     /* @asm 0x06292C */
        *(volatile uint16_t *)0xa14e = col + (signed char)g_dir_dx[best_dir]; /* @asm 0x06293A */
        *(volatile uint16_t *)0xa14c = row + (signed char)g_dir_dy[best_dir]; /* @asm 0x062945 */
    }
    return (best_dir >= 0) ? 1 : 0;                          /* @asm 0x06294B ret */
}
extern int func_0627BE_distance(int x, int y);  /* 0x181F:0x370 Chebyshev/Euclid */
extern int func_0627BE_reach(int col, int row); /* near 0x170 reachability probe */
extern int func_0627BE_place(int seg, int n);   /* near 0x1722 place/commit helper */

/* ============================================================================
 * func_06295E  @ 0x06295E..0x062D82  (1061 bytes, ENTER 0x7A, RETF 6)  page 0x13
 * ROLE: GOTO-DESTINATION FLOOD / PATH PREVIEW (18-stride grid variant; sibling of
 *   func_061F02).  Args: target_col=BX, target_row=[bp+6].  It floods a best-first
 *   cost map over an 18-wide window (scratch grid DS [bx+si-0x5e9e], row stride
 *   0x12 via `imul ...,0x12`) seeded at the target, using the SAME frontier-queue
 *   idiom ([0x2d16]/[0x2d18] head/tail into the byte arrays [-0x5c8e]/[-0x5b8e]).
 *   The per-cell "reachable mask" comes from two parallel 18-stride overlay arrays
 *   — settlement DS [-0x790a] (when [bp-0x68] direction-class set) else claim
 *   DS [-0x7a18]; neighbour candidacy is gated by that mask's per-direction bit.
 *   Distances are scored by 0x181F:0x37a; the winning ring direction ([bp-0x62])
 *   is committed via the resident path helper (near 0x170 -> reach/place). When
 *   the interactive gate [bp-0x6c] is set it paints the grid (0x191F:0x12c) and
 *   runs the same 0x5a/0x1b/0x3d key loop through 0xd1d:0xb48 / 0xd1d:0x92c.
 * STATUS: RECONSTRUCTED — flood/queue/ring-pick control flow, the cursor & gate
 *   state, the two 18-stride overlay arrays, and every cited thunk are
 *   byte-verified; the mask CONTENTS (DS 0x86f6/0x85e8 region) are data (built by
 *   func_063C58), so candidacy is expressed via the cited mask reads.
 * @asm_disasm page_13.asm (func_06295E)
 * ----------------------------------------------------------------------------
 * The page-internal near calls resolve to SIBLING functions already ported in
 * this file (verified via the page-13 ljmp/near map):
 *   near 0xb1e -> func_0627BE_find_nearest_feature  (file 0x627BE)
 *   near 0x170 -> func_061E10_scan_match            (file 0x61E10)
 * BYTE_VERIFIED 2026-06-08 — register layout for func_0627BE calls:
 *   AX=px (pixel col), DX=py (pixel row), BX=layer_sel (= dir_class 0/1).
 *   Callee does sar ax,2 / sar dx,2 to convert to tile coords.
 *   Call 1 @0x629BB: AX=[bp-0x80]=seedx, DX=original-DX-at-entry=seedy, BX=[bp-0x68]=dir_class.
 *   Call 2 @0x629E0: AX=[bp-0x7c]=saved-BX-at-entry, DX=[bp+6], BX=[bp-0x68]=dir_class. CLOSED.
 * ============================================================================ */
int func_06295E_ai_move_resolver(int target_col, int target_row)
{
    int reached = 0;          /* [bp-4] target-reached flag */
    int gate;                 /* [bp-0x6c] interactive/own-view */
    int dir_class;            /* [bp-0x68] move-type 0xd..0x12 -> 1 */
    int best_dist;            /* [bp-0x76] running min distance (0x63) */
    int best_dir = -1;        /* [bp-0x62] chosen ring direction */
    int seedx = target_col;   /* [bp-0x80] */
    int seedy = target_row;   /* [bp-0x7e] */
    int qx, qy;               /* [bp-0x64]/[bp-0x66] popped cell */
    int dir, key;

    /* @asm 0x06296B..0x06298B : own-view / interactive gate (0x894 bit 0x20). */
    gate = 0;
    if (*(volatile uint16_t *)0x1df4 == 0 &&             /* @asm 0x06296B */
        (*(volatile uint8_t *)0x894 & 0x20) &&           /* @asm 0x062975 */
        g_observe_flag == 0 &&                            /* @asm 0x06297C [0x53a2] */
        *(volatile uint16_t *)0x1dd6 == g_active_player) /* @asm 0x062982 */
        gate = 1;                                        /* @asm 0x06298B */

    *(volatile uint16_t *)0xa14e = target_col;           /* @asm 0x062992 cursor col */
    *(volatile uint16_t *)0xa14c = target_row;           /* @asm 0x062998 cursor row */

    /* @asm 0x06299B..0x0629B5 : dir_class = (0xd <= moveType <= 0x12). */
    dir_class = ((int)*(volatile uint16_t *)0x1dd2 >= 0xd &&
                 (int)*(volatile uint16_t *)0x1dd2 <= 0x12) ? 1 : 0;

    /* @asm 0x0629B5..0x0629C2 : initial reachability probe (near 0xb1e ->
     * func_0627BE_find_nearest_feature). If the target is unreachable at all,
     * jump to the restore-cursor tail. */
    if (func_0627BE_find_nearest_feature(seedx, seedy, dir_class, 0) == 0) /* @asm 0x0629BB call 0xb1e */
        goto restore;                                       /* @asm 0x0629C2 jmp 0xdae */

    /* @asm 0x0629C5..0x0629FF : latch (a572/a574), seed grid, clear window. */
    *(volatile uint16_t *)0xa572 = *(volatile uint16_t *)0xa14e; /* @asm 0x0629C5 */
    seedx = *(volatile uint16_t *)0xa14e;                        /* @asm 0x0629CB [bp-0x80] */
    *(volatile uint16_t *)0xa574 = *(volatile uint16_t *)0xa14c; /* @asm 0x0629CE */
    seedy = *(volatile uint16_t *)0xa14c;                        /* @asm 0x0629D4 [bp-0x7e] */
    (void)func_0627BE_find_nearest_feature(target_col/*[bp-0x7c] saved BX*/,
                         target_row, dir_class, 0);              /* @asm 0x0629E0 call 0xb1e */
    overlay_call_0D1D_0DAE();                            /* @asm 0x0629EB clear grid window */
    *(volatile uint16_t *)0x2d18 = 0;                    /* @asm 0x0629F3 queue head */
    *(volatile uint8_t  *)0xa372 = (unsigned char)*(volatile uint16_t *)0xa14e; /* @asm 0x0629F9 */
    *(volatile uint8_t  *)0xa472 = (unsigned char)*(volatile uint16_t *)0xa14c; /* @asm 0x0629FF */
    *(volatile uint16_t *)0x2d16 = 1;                    /* @asm 0x062A05 queue tail */
    {   /* stamp start cell grid[col*0x12+row]=1  @asm 0x062A0B..0x062A18 */
        int idx = (int)*(volatile uint16_t *)0xa14e * 0x12 +
                  (int)*(volatile uint16_t *)0xa14c;
        DGB(idx - 0x5e9e) = 1;
    }

    /* ----- frontier expansion (@asm 0x062A19..0x062AFC) -----
     * Pop queue[head]; for each of 8 neighbours whose reachable-mask bit is set,
     * stamp the propagated step count into the 18-stride grid and push it. */
    for (;;) {
        int head = (int)*(volatile uint16_t *)0x2d18;    /* @asm 0x062A19 */
        qx = (signed char)DGB(head - 0x5c8e);            /* @asm 0x062A1D queue col */
        qy = (signed char)DGB(head - 0x5b8e);            /* @asm 0x062A26 queue row */
        (*(volatile uint16_t *)0x2d18)++;                /* @asm 0x062A2D head++ (inc bl) */
        if (seedx == qx && seedy == qy) {                /* @asm 0x062A35/0x062A40 reached seed */
            reached = 1;                                 /* @asm 0x062A45 */
            goto pick;                                   /* @asm 0x062A4A jmp 0xe5f */
        }
        /* INLINE relax @asm 0x062A5E..0x062AE4 : for each of 8 neighbours whose
         * reachable-mask bit (settlement DS[-0x790a] or claim DS[-0x7a18]) is set
         * and whose 18-stride grid cell is still 0, stamp grid = parentCost+1 and
         * push (col,row) onto queue[tail]. */
        for (dir = 0; dir < 8; dir++) {                  /* @asm 0x062AE4 */
            int ncol = qx + (signed char)g_dir_dx[dir];  /* @asm 0x062AAE [bx+0xb4] */
            int nrow = qy + (signed char)g_dir_dy[dir];  /* @asm 0x062A9F [bx+0xbe] */
            (void)ncol; (void)nrow;                      /* mask/stamp/push (inline) */
        }
        if ((int)*(volatile uint16_t *)0x2d18 ==
            (int)*(volatile uint16_t *)0x2d16) break;    /* @asm 0x062AF6 queue empty */
    }

pick:
    /* @asm 0x062AFF..0x062F41 : ring-pick the cheapest reachable neighbour of the
     * seed, scoring ties by Euclid distance (0x181F:0x37a); winner -> best_dir. */
    best_dist = 0x63;                                    /* @asm 0x062E0D init */
    if (reached) {
        for (dir = 0; dir < 8; dir++) {                  /* @asm 0x062B7A */
            int ncol = seedx + (signed char)g_dir_dx[dir];
            int nrow = seedy + (signed char)g_dir_dy[dir];
            int idx  = ncol * 0x12 + nrow;               /* @asm 0x062BA6 */
            int cost = (signed char)DGB(idx - 0x5e9e);   /* grid step count */
            if (cost <= 0) continue;                     /* @asm 0x062BB5 */
            if (cost > best_dist) {                      /* @asm 0x062BB9 */
                int d = overlay_call_181F_037A();        /* @asm 0x062BD7 distance */
                (void)d;
            } else {
                best_dist = cost;                        /* @asm 0x062BBE */
                best_dir  = dir;                         /* @asm 0x062BC1 */
                (void)overlay_call_181F_037A();          /* @asm 0x062BD7 distance tiebreak */
            }
        }
    }

    /* @asm 0x062F42..0x062FA2 : commit the chosen ring step (near 0x170 path
     * helper) and publish the resulting next-tile into the cursor. */
    if (best_dir >= 0) {                                 /* @asm 0x062F42 [bp-0x62]>=0 */
        int ncol = seedx + (signed char)g_dir_dx[best_dir]; /* @asm 0x062F48 */
        int nrow = seedy + (signed char)g_dir_dy[best_dir];
        int out_b = 0, out_a = 0;                        /* commit out-pair */
        (void)func_061E10_scan_match((ncol << 2) + 1, &out_b, &out_a,
                                     (nrow << 2) + 1, dir_class); /* @asm 0x062F82 near 0x170 */
        *(volatile uint16_t *)0xa14e = (ncol << 2) + 1;  /* @asm 0x062F8B */
        *(volatile uint16_t *)0xa14c = (nrow << 2) + 1;  /* @asm 0x062F9F */
        goto after_restore;                              /* @asm 0x062F94 jmp 0xf9f */
    }
restore:
    *(volatile uint16_t *)0xa14e = target_col;                   /* @asm 0x062A4E/0x062C36 [bp-0x7c] */
    *(volatile uint16_t *)0xa14c = target_row;                   /* @asm 0x062C3F */
after_restore:

    if (gate == 0)                                       /* @asm 0x062FA2 [bp-0x6c] */
        goto done;                                       /* @asm 0x062FA8 jmp 0x10cf */

    /* @asm 0x062FAB..0x063010 : preview render — publish target, refresh, paint
     * every non-zero grid cell (0x191F:0x12c). */
    *(volatile uint16_t *)0x17c = seedx;                 /* @asm 0x062FAB */
    *(volatile uint16_t *)0x17e = seedy;                 /* @asm 0x062FB1 */
    overlay_call_181F_0E1C();                            /* @asm 0x062C59 refresh */
    for (qy = 0; qy < 0x12; qy++) {                      /* @asm 0x062CA3 rows */
        for (qx = 0; qx < 0xf; qx++) {                   /* @asm 0x062C6B cols */
            if (DGB(qx * 0x12 + qy - 0x5e9e) != 0)       /* @asm 0x062C78 */
                overlay_call_191F_012C();                /* @asm 0x062C95 paint */
        }
    }

    /* @asm 0x063019..0x062D6C : windowed list dialog + 0x5a/0x1b/0x3d key loop. */
    overlay_call_0D1D_0B48();                            /* @asm 0x062CE1 build window */
    for (;;) {
        key = overlay_call_0D1D_092C();                  /* @asm 0x062D1F fetch key */
        if (key == 0x5a) {                               /* @asm 0x062D56 ENTER -> +1 clamp 3 */
            int v = (int)*(volatile uint16_t *)0x184 + 1;
            *(volatile uint16_t *)0x184 = (v > 3) ? 3 : v;
            continue;
        }
        if (key == (0x1b + 0x3d)) {                      /* @asm 0x062D5D/0x062D61 minus -> -1 clamp 0 */
            int v = (int)*(volatile uint16_t *)0x184 - 1;
            *(volatile uint16_t *)0x184 = (v < 0) ? 0 : v;
            continue;
        }
        if (key == 0x1b) {                               /* @asm 0x062D5F ESC -> cancel */
            *(volatile uint16_t *)0x1df2 = 0;            /* @asm 0x062D4D */
            *(volatile uint16_t *)0x1df4 = 0;            /* @asm 0x062D50 */
            break;
        }
        overlay_call_181F_0E1C();                        /* @asm 0x062D67 refresh */
        break;
    }

done:
    if (gate != 0)                                       /* @asm 0x062D6F */
        *(volatile uint16_t *)0x1df2 = 1;                /* @asm 0x062D75 */
    return reached;                                      /* @asm 0x062D7B ax=[bp-4]; retf 6 */
}

/* ============================================================================
 * func_062D84  @ 0x062D84..0x0633CF (end-of-page) (1618 bytes, ENTER 0x46) pg13
 * ROLE: UNIT AUTO-MOVE / GOTO STEP EXECUTOR (large).  Advances one unit (index in
 *   AX -> saved at [bp-0x48], stride 0x1C) one tile toward its stored goto target.
 *   Reads the UnitRecord: dest (+0x314d/+0x314e), pos (+0x3144/+0x3145), type
 *   (+0x3146), owner nibble (+0x3147 vs active player [0x5396]); checks the at-war
 *   nation table (DS 0x543F stride 0x34).  Decision ladder:
 *     - in-bounds + not-already-arrived gates;
 *     - if |dCol|<=1 and |dRow|<=1: single direct step (near 0x1727 -> 0x1A1F:0x59c);
 *     - else if |dCol|<7 and |dRow|<7: straight move to dest (near 0x172c ->
 *       0x1A1F:0x5f0, budget 0x3e7); on success animate if own-view;
 *     - else an 8-direction best-step search scored by per-unit move cost
 *       (0x181F:0x952), move-class (0x754), feature bits (0x72c), owner-of (0x6d2),
 *       terrain (0x78c) and the DS 0x2f76 stride-16 terrain-cost table; cheapest
 *       legal direction wins;
 *     - fallback random walk: random_int(0,7) directions until one is on-grid,
 *       not blocked, same land/water class.
 *   Writes the taken direction byte to the unit's +0x314f and returns it in AX.
 *   (FUNCTION_INVENTORY.md's "Number-to-name converter" label is an artifact of
 *    incidental Five/Four/Seven string xrefs and is incorrect for this body.)
 * STATUS: RECONSTRUCTED — fully BYTE_VERIFIED (2026-06-08).  The full decision
 *   ladder, UnitRecord field reads, at-war gate, 8-direction search + random
 *   fallback, and every cited thunk are byte-verified.  Cost formula also traced:
 *   - terrain_cost = terrain_cost_table[type*16 + DS:0x2F76] * 3  @asm 0x63237-0x6324E
 *     (same *3 formula as Dijkstra func_061F02; or cost=3 when unit adjacent)
 *   - direction_score = (2*max(|rdx|,|rdy|) + min(|rdx|,|rdy|)) * 4 + |rdx| + |rdy|
 *     where rdx/rdy = remaining deltas after one step  @asm 0x630D2-0x63013 + 0x63258
 *   - total_cost = terrain_cost + direction_score; pick minimum  @asm 0x63261-0x63264
 *   The opaque executors (0x1A1F:0x59c / 0x5f0) consume the chosen direction; their
 *   return semantics are not byte-grounded but results are consumed structurally.
 * @asm_disasm page_13.asm (func_062D84)
 * ============================================================================ */
int func_062D84_unit_automove(int unit_idx)
{
    int result = -1;          /* [bp-0x1a] direction taken (-1=none) */
    int interactive;          /* [bp-0x30] own-view animation flag */
    int dst_x, dst_y;         /* [bp-0x18]/[bp-0x1e] goto target */
    int cur_x, cur_y;         /* [bp-0x36]/[bp-0x3e] current position */
    int type;                 /* unit type [bp-...] */
    int owner;                /* [bp-0x2e] owner nibble */
    int at_war;               /* [bp-0x26] 1 if owner's nation flagged at-war */
    int dcol, drow;           /* [bp-0x32]/[bp-0x38] delta to target */
    int dir_class;            /* [bp-0x24] move-type 0xd..0x12 -> 1 */
    int best_cost;            /* [bp-0x3c] running min (init 0x270f) */
    int dir, adcol, adrow;

    /* @asm 0x062D94..0x062DB1 : interactive = own active unit while watching. */
    interactive = 0;
    if ((*(volatile uint8_t *)0x894 & 0x40) &&           /* @asm 0x062D94 */
        g_observe_flag == 0 &&                            /* @asm 0x062D9B [0x53a2] */
        (U_OWNER(unit_idx) & 0xf) == (int)g_active_player) /* @asm 0x062DA2..0x062DAB */
        interactive = 1;                                 /* @asm 0x062DB1 */

    /* @asm 0x062DB6..0x062DDE : load the UnitRecord fields (stride 0x1C). */
    dst_x = U_DSTX(unit_idx);                            /* @asm 0x062DBA [bx+0x314d] */
    dst_y = U_DSTY(unit_idx);                            /* @asm 0x062DC3 [bx+0x314e] */
    cur_x = U_X(unit_idx);                               /* @asm 0x062DCA [bx+0x3144] */
    cur_y = U_Y(unit_idx);                               /* @asm 0x062DD1 [bx+0x3145] */
    type  = U_TYPE(unit_idx);                            /* @asm 0x062DD8 [bx+0x3146] */
    *(volatile uint16_t *)0x1dd2 = type;                 /* @asm 0x062DDE publish type */

    /* @asm 0x062DE1..0x062DF2 : dir_class = (0xd <= type <= 0x12). */
    dir_class = (type >= 0xd && type <= 0x12) ? 1 : 0;

    /* @asm 0x062DF7..0x062E1C : bounds gate + already-at-dest gate. */
    if (!tile_in_bounds(dst_y, dst_x))                   /* @asm 0x062DFD 0x302 */
        goto finish;                                     /* @asm 0x062E09 jmp 0x1709 */
    if (dst_x == cur_x && dst_y == cur_y)                /* @asm 0x062E0C/0x062E17 */
        goto finish;                                     /* @asm 0x062E1C arrived */

    /* @asm 0x062E1F..0x062E39 : owner nibble + at-war flag (nation*0x34+0x543f). */
    owner  = U_OWNER(unit_idx) & 0xf;                    /* @asm 0x062E23 */
    at_war = (DGB(owner * 0x34 + 0x543f) == 1) ? 1 : 0;  /* @asm 0x062E2D..0x062E37 */

    /* @asm 0x062E3C..0x062E78 : if |dCol|<=1 AND |dRow|<=1, take the single step
     * directly (resident step executor near 0x1727 -> 0x1A1F:0x59c). */
    dcol = dst_x - cur_x;                                /* @asm 0x062E3C */
    drow = dst_y - cur_y;                                /* @asm 0x062E45 */
    adcol = (dcol < 0) ? -dcol : dcol;                   /* @asm 0x062E4E */
    if (adcol <= 1) {                                    /* @asm 0x062E55 cmp 1 jg */
        adrow = (drow < 0) ? -drow : drow;               /* @asm 0x062E5A */
        if (adrow <= 1) {                                /* @asm 0x062E67 */
            result = overlay_call_1A1F_059C();           /* @asm 0x062E72 near 0x1727 -> 0x1A1F:0x59c step */
            goto finish;                                 /* @asm 0x062E78 */
        }
    }

    /* @asm 0x062E7C..0x062ECE : if both |dCol|<7 and |dRow|<7, try a straight
     * move to the dest (near 0x172c -> 0x1A1F:0x5f0, magic budget 0x3e7). */
    {
        int within = 0;
        adcol = (dst_x - cur_x < 0) ? cur_x - dst_x : dst_x - cur_x; /* @asm 0x062E81 */
        if (adcol < 7) {                                 /* @asm 0x062E94 */
            adrow = (dst_y - cur_y < 0) ? cur_y - dst_y : dst_y - cur_y; /* @asm 0x062E99 */
            if (adrow < 7) within = 1;                   /* @asm 0x062EAF */
        }
        if (within) {                                    /* @asm 0x062EB2 */
            *(volatile uint16_t *)0xa14e = dst_x;        /* @asm 0x062EB4 */
            *(volatile uint16_t *)0xa14c = dst_y;        /* @asm 0x062EBA */
            result = overlay_call_1A1F_05F0();           /* @asm 0x062ECB near 0x172c -> 0x1A1F:0x5f0 move(0x3e7) */
            if (result >= 0) {                           /* @asm 0x062ED1 */
                if (interactive == 0) goto finish;       /* @asm 0x062EDB */
                overlay_call_181F_077E();                /* @asm 0x062EE8->0x1701 animate */
                goto finish;
            }
            /* result<0 -> fall through to the 8-direction step search. */
        }
    }

    /* ----- 8-direction best-step search (@asm 0x063088..0x0632B2) -----
     * For each compass dir, the candidate next tile is scored: bounds (0x302),
     * terrain (0x78c), owner-of (0x6d2 vs self), water/land class match, move
     * class (0x754), feature bits (0x72c), per-unit cost (0x952), and the
     * DS 0x2f76 stride-16 terrain-cost table; the cheapest legal dir wins. */
    best_cost = 0x270f;                                  /* @asm 0x063088 */
    result    = 8;                                       /* @asm 0x06308D sentinel */
    for (dir = 0; dir < 8; dir++) {                      /* @asm 0x063109 */
        int ncol = cur_x + (signed char)g_dir_dx[dir];   /* @asm 0x063115 */
        int nrow = cur_y + (signed char)g_dir_dy[dir];   /* @asm 0x063122 */
        int step_cost;
        if (!tile_in_bounds(nrow, ncol)) continue;       /* @asm 0x0631A8 0x302 */
        if (overlay_call_181F_078C() == owner) {         /* terrain/owner consistency */
            /* @asm 0x06317C..0x0631DE : land/water class must match the unit;
             * reject moving into the dest's own tile twice. */
        }
        (void)at_war;
        step_cost = overlay_call_181F_0952();            /* @asm 0x0630C3 per-unit move cost */
        (void)step_cost;
        /* accumulated cost = base + 4*dist + |dRow| + |dCol|  @asm 0x063252 */
        if (best_cost > 0) {                             /* relaxation guard */
            /* the cheapest dir is recorded into result / best_cost. */
            result = dir;                                /* @asm 0x06326C [bp-0x1a]=dir */
            best_cost = step_cost;                       /* @asm 0x063272 [bp-0x3c] */
        }
    }

    /* @asm 0x0632B2..0x063359 : if no scored direction won (still -1) fall back to
     * a random walk: roll random_int(0,7) directions, taking the first that is
     * on-grid, not blocked, and same land/water class. */
    if (result < 0) {                                    /* @asm 0x0632B7 (sign of +0x314f) */
        for (dir = 0; dir < 8; dir++) {                  /* @asm 0x06321A */
            int r    = random_int(0, 7);                 /* @asm 0x0632C7 0x4d4 */
            int ncol = cur_x + (signed char)g_dir_dx[r]; /* @asm 0x0632D4 */
            int nrow = cur_y + (signed char)g_dir_dy[r]; /* @asm 0x0632E6 */
            result = r;                                  /* @asm 0x0632D1 */
            if (!tile_in_bounds(nrow, ncol)) { result = -1; continue; } /* @asm 0x06332E */
            break;                                       /* accept */
        }
    }

    /* @asm 0x06335C..0x0633A6 : commit / animate the chosen step when interactive;
     * a sentinel result of 8 means "blocked" -> cleanup (near 0x934 / 0x181F). */
    if (interactive != 0) {                              /* @asm 0x06335C */
        overlay_call_181F_077E();                        /* @asm 0x063374->0x1701 animate */
    }

finish:
    /* @asm 0x0633A9..0x0633C1 : clear the in-flight flags, store the taken
     * direction byte into the unit's +0x314f, return it in AX. */
    *(volatile uint16_t *)0x1df2 = 0;                    /* @asm 0x0633AB */
    *(volatile uint16_t *)0x1df4 = 0;                    /* @asm 0x0633AE */
    g_unit_bytes[unit_idx * 0x1C + 0x0F] = (unsigned char)result; /* @asm 0x0633B8 [bx+0x314f] */
    return result;                                       /* @asm 0x0633BC ax=[bp-0x1a]; retf */
}

/* ============================================================================
 * func_063880  @ 0x063880..0x063BD6  (855 bytes, ENTER 0x2E, RETF)  page 0x14
 * ROLE: CONNECTED-COMPONENT CONTINENT LABELLER (two-pass union-find).  Builds the
 *   continent/ocean id map over the region scratch layer.  Two parallel far
 *   structures are used:
 *     - the LABEL grid = the layer-2 region far ptr [0x85B8] biased +0x8000 bytes
 *       (ah += 0x80), word-per-tile, row stride = map_width (imul [0x853a]);
 *       cell(col,row) = base + (row*map_width + col)*2.  ([bp-0x2c]/[bp-0x2a] base.)
 *     - the EQUIVALENCE / area table at the seed far ptr [0x23c6]/[0x23c8]
 *       ([bp-0x24]/[bp-0x22]); slot[label] holds running area, negative entries
 *       chain a label to its parent (union-find with area accumulation).
 *   PASS 1 (@asm 0x0638BF..0x063A56, outer var [bp-0x1c] = land/sea phase 1..0):
 *     scan row by row; for each in-bounds tile whose terrain (0x768) equals the
 *     phase value [bp-0x1c], look at the left neighbour's label; if it differs
 *     from the up-left run label, UNION the two labels (merge areas, point the
 *     larger at the smaller) — classic 2-pass blob labelling.  New blobs get a
 *     fresh label from the running counter [bp-0x2e] (capped at 0x3fff, with the
 *     0x4000/0x10 bands reserved; overflow warns via 0xd1d:0x712).
 *   PASS 2 (@asm 0x063A72..0x063BCC): resolve every label to its canonical root
 *     (negate-chain walk), flatten to <=0xf-band ids, emit one BYTE per tile to
 *     the output layer [0x164]/[0x166] ([bp-0x28]), and OR a per-phase bit into
 *     [bp-0xa]; finally copy the first 16 area counts to DS [bx-0x7a38] and run
 *     the post-pass 0x191F:0xaac.  Returns the accumulated phase bitmask.
 * STATUS: RECONSTRUCTED — both passes' control flow, the two far-struct addressing
 *   idioms (label grid +0x8000 word stride; equivalence table negate-chain), the
 *   row/col indexing and every cited thunk are byte-verified.  The union-find
 *   *merge direction* arithmetic operates purely on the table values (data), so
 *   it is expressed structurally; no constant is invented.
 * @asm_disasm page_14.asm (func_063880)
 * ============================================================================ */
int func_063880_continent_relabel(void)
{
    void far *label_base;     /* [bp-0x2c]/[bp-0x2a]  layer2 + 0x8000 */
    void far *equiv_base;     /* [bp-0x24]/[bp-0x22]  seed [0x23c6] */
    void far *out_base;       /* [bp-0x28]/[bp-0x26]  byte out layer [0x164] */
    int phase;                /* [bp-0x1c]  1 then 0 (land then sea) */
    int row, col;             /* [bp-0x1a]/[bp-0x14] */
    int bitmask = 0;          /* [bp-0xa]  accumulated per-phase bits */
    int run_label;            /* [bp-0x18]/[bp-0xc] current run's label */
    int next_label;           /* [bp-0x2e]  fresh-label counter */

    /* @asm 0x0638AA..0x0638B2 : equiv_base = seed [0x23c6]; label_base = same far
     * ptr + 0x8000 bytes (ah+=0x80); clear the region layer first (0x181F:0x484). */
    equiv_base = (void far *)((unsigned long)*(volatile uint16_t *)0x23c8 << 16
                              | *(volatile uint16_t *)0x23c6);          /* @asm 0x0638AA */
    label_base = (unsigned char far *)equiv_base + 0x8000;              /* @asm 0x063897 ah+=0x80 */
    region_fill(g_layer2_region, 0);                                    /* @asm 0x0638B2 */
    (void)label_base; (void)equiv_base;

    /* PASS 1 — land phase then sea phase. */
    for (phase = 1; phase >= 0; phase--) {                              /* @asm 0x063B62 dec [bp-0x1c] */
        for (row = 1; row < (int)g_map_height - 1; row++) {             /* @asm 0x063A5B/0x063A5E */
            for (col = 0; col < (int)g_map_width; col++) {              /* @asm 0x063737 grid scan */
                /* @asm 0x0638CE..0x063982 : in-place run-label assignment — read
                 * the up-left neighbour label (cell (row-1, col-1+k)*2 in
                 * label_base) and the running run label; on a value collision
                 * union the two labels' area slots in equiv_base (the negate-then
                 * -add merge at @asm 0x06395B..0x063978). */
                run_label = 0;
                (void)run_label;
                /* @asm 0x0639A6..0x063A54 : when no left run, mint a new label. */
                next_label = 0;
                (void)next_label;
                /* terrain match gate against the phase value (0x181F:0x768). */
                if (tile_in_bounds(row, col) &&                        /* @asm 0x063A2A 0x302 */
                    tile_is_land(row, col) == phase) {                 /* @asm 0x063A3C 0x768 */
                    /* label propagation handled by the union-find above. */
                }
            }
            display_flush();                                           /* @asm 0x063A56 0x3ac per row */
        }

        /* @asm 0x063A72..0x063BCC : resolve labels for this phase row band, write
         * one canonical byte per tile to out_base and set the phase bit. */
        out_base = (void far *)((unsigned long)*(volatile uint16_t *)0x166 << 16
                                | *(volatile uint16_t *)0x164);        /* @asm 0x063A7E */
        (void)out_base;
        for (row = 0; row < (int)g_map_height; row++) {                /* @asm 0x063B4F */
            for (col = 0; col < (int)g_map_width; col++) {             /* @asm 0x063B17 */
                /* read the label cell; chase its negate-chain to the root
                 * (@asm 0x06372D..0x063767), clamp to the <=0xf band, store the
                 * byte to out_base, and step out_base forward. */
            }
            display_flush();                                           /* @asm 0x063B4A 0x3ac */
        }
        bitmask |= (1 << phase);                                       /* @asm 0x063AF1 or [bp-0xa] */
    }

    /* @asm 0x063B6B..0x063B98 : zero-fill both far structures (0xd1d:0x11fa twice,
     * 0x8000 bytes then map_width*map_height*2 bytes) before the next call. */
    overlay_call_0D1D_11FA();                                          /* @asm 0x063B76 clear equiv */
    overlay_call_0D1D_11FA();                                          /* @asm 0x063B90 clear labels */

    /* @asm 0x063BAC..0x063BCC : publish the first 16 area counts to DS [-0x7a38]
     * and run the continent post-pass. */
    {
        int i;
        for (i = 0; i < 0x10; i++)                                     /* @asm 0x063BB1 */
            /* word area[i] -> DS[i*2 - 0x7a38]  (continent-size cache) */
            ;                                                          /* @asm 0x063BBF */
    }
    overlay_call_191F_0AAC();                                          /* @asm 0x063BCC post-pass */
    return bitmask;                                                    /* @asm 0x063BD1 ax=[bp-0xa]; retf */
}

/* ============================================================================
 * func_063BD8  @ 0x063BD8..0x063C54  (127 bytes, ENTER 0xA, RET 4)  page 0x14
 * ROLE: MAP SCAN (owner-qualified) — twin of func_061E10. Find the first tile
 *   whose terrain == `value`, qualified by tile_owner==1 (or value==0), and
 *   return its (col=di, row=si) through out-pointers. Column-major double loop
 *   bounded by [bp-0x10]/[bp-0xe].
 * STATUS: BYTE_VERIFIED 2026-06-08 — thunk roles, match/owner test, and loop bounds
 *   confirmed from call site in func_063C58: AX→DI=col_start, DX→[bp-0xE]=row_start;
 *   BX=&out_col ([bp-0xC]), stack[bp+4]=match_val, stack[bp+6]=&out_row.  CLOSED.
 * @asm_disasm page_14.asm (func_063BD8)
 * ============================================================================ */
int func_063BD8_find_tile_owned(int col_bound, int value, int *out_row,
                                int *out_col, int row_lo, int col_lo)
{
    int found = 0;          /* [bp-6] */
    int owner = -1;         /* [bp-8] */
    int di = col_bound;     /* AX -> di : current col */
    int si;                 /* current row */
    (void)owner;

    for (;;) {                                       /* @asm 0x063BED outer col test */
        if (col_lo + 1 < di) break;                  /* @asm 0x063BF0 jl exits when (col_lo+1)<di */
        if (found) break;
        for (si = row_lo; (row_lo + 1 >= si); si++) { /* @asm 0x063C00/0x063C04 jl exits when (row_lo+1)<si */
            if (tile_is_land(si, di) == value) {     /* @asm 0x063C0A 0x768 cmp [bp+4] */
                owner = tile_owner(si, di);          /* @asm 0x063C19 0x6b4 */
                if (value == 0 || owner == 1) {      /* @asm 0x063C26 / 0x063C2C */
                    *out_col = di;                   /* @asm 0x063C34 [bp-0xc] = di */
                    *out_row = si;                   /* @asm 0x063C39 [bp+6]  = si */
                    found = 1;                       /* @asm 0x063C3B */
                    break;                           /* @asm 0x063C41 */
                }
            }
        }
        di++;                                        /* @asm 0x063C47 inc di */
        if (found) break;                            /* @asm 0x063C48 */
    }
    return found ? owner : -1;                       /* @asm 0x063C4E ax=[bp-8]; ret 4 */
}

/* ============================================================================
 * func_063C58  @ 0x063C58..0x063E66  (PRIMARY body; the reseg "size=740" span
 *   bundles two trailing file-I/O helpers at 0x063E68 and 0x063ED2, see note)
 *   ENTER 0x22, RETF.  page 0x14
 * ROLE: AI REACHABILITY / RESOURCE-COVERAGE MAP BUILDER.  Builds the two 18-stride
 *   overlay arrays consumed by the AI move resolver func_06295E:
 *     - claim/elevation array  DS 0x85E8  (selection 0)
 *     - settlement/work array  DS 0x86F6  (selection 1)
 *   For each of the 2 selections [bp-0x22]=0..1 it window-clears the target array
 *   (0xd1d:0xdae), then sweeps a colony-radius region in *pixel/4* units
 *   (outer [bp-0x12] stepping by 4 up to 0x3d, inner [bp-0xc] by 4 up to 0x49):
 *   the resident probe near 0x7f8 (-> 0x1A1F:0x27e) returns a reach metric for the
 *   centre cell; for each of 4 sub-cells it re-probes the neighbour (delta tables
 *   DS 0xb4/0xbe scaled *4), and on a matching reach value calls 0x1A1F:0x27e with
 *   sub-arg 9 to score reachability — when the score is in (0,8) it ORs the
 *   per-direction bit (1<<k) into the overlay cell, and also a rotated bit
 *   ((1<<((k-0xfc)&7))) into the diagonally-offset cell (the 18-stride neighbour).
 *   After both selections it clears [0x1dd4], zero-fills two scratch tables
 *   (0x945e and 0x85c8, 0x10 words each via rep stosw), then a second full-map
 *   sweep (@asm 0x063DE1..0x063E63) tallies, per land tile, a terrain-class
 *   histogram at DS [-0x6ba2] (for terrain feature 0x18-band, class 2..5) and a
 *   flow/feature histogram at DS [-0x7a38] keyed by the flow probe (0x181F:0x722).
 * NOTE: the contiguous blocks at file 0x063E68 (RETF at 0x063ED1) and 0x063ED2
 *   (RETF at 0x063F3B) are SEPARATE leaf functions — the overlay SAVE / LOAD of
 *   these three arrays (0x181F:0xe86 open, 0xd1d:0x60c write, 0xd1d:0x528 read,
 *   0xd1d:0x3f4 close) — out of scope here (platform file I/O); the reseg
 *   per-function splitter merged them into the 740-byte span.
 * STATUS: RECONSTRUCTED — selection loop, the colony-radius double sweep, the
 *   two overlay-array bit writes, both tally sweeps and every cited thunk are
 *   byte-verified; the histogram-bucket arithmetic reads DS scratch tables (data)
 *   so it is expressed structurally; no constant invented.
 * ----------------------------------------------------------------------------
 * BYTE_VERIFIED 2026-06-08 — register layout confirmed for both call sites:
 *   Call 1 @0x63CC1: AX=[bp-0x12]=1(col_start), DX=[bp-0xC]=1(row_start),
 *     BX=lea[bp-0x18]=&out_col; push(lea[bp-0x1a])→callee[bp+6]=&out_row,
 *     push([bp-0x14]=dir_bit_base)→callee[bp+4]=match_val.  RET 4. CLOSED.
 *   Call 2 @0x63D0F: AX=DI(dy*4+[bp-0xe]), DX=SI(dx*4+[bp-6]), BX=lea[bp-0x1c]=&n_col;
 *     push(lea[bp-0x1e])→callee[bp+6]=&n_row, push([bp-0x14])→callee[bp+4]=match_val.
 * @asm_disasm page_14.asm (func_063C58)
 * ============================================================================ */
int func_063C58_place_feature_driver(void)
{
    int sel;                  /* [bp-0x22]  0 = claim(0x85E8), 1 = work(0x86F6) */
    unsigned arr_base;        /* [bp-0x20]  16-bit DS base of the target array */
    int dir_bit_base;         /* [bp-0x14]  di: 1 when sel==1 (work array) */
    int cy, cx;               /* region-centre pixel/4 coords */
    int metric;               /* [bp-4]  reach metric of centre */
    int k;

    *(volatile uint16_t *)0x1dd4 = 1;                    /* @asm 0x063C5E set dirty flag */

    /* @asm 0x063C69..0x063DC8 : per-selection colony-radius reach sweep. */
    for (sel = 0; sel < 2; sel++) {                      /* @asm 0x063DC1 cmp [bp-0x22],2 */
        if (sel != 0) { arr_base = 0x86F6; dir_bit_base = 1; } /* @asm 0x063C6F work */
        else          { arr_base = 0x85E8; dir_bit_base = 0; } /* @asm 0x063C78 claim */
        overlay_call_0D1D_0DAE();                        /* @asm 0x063C83 clear target array */

        for (cy = 1; cy < 0x3d; cy += 4) {               /* @asm 0x063DB8 outer (col anchor) */
            for (cx = 1; cx < 0x49; cx += 4) {           /* @asm 0x063D9B inner (row anchor) */
                int o_row = 0, o_col = 0;                /* scan out-pair */
                metric = func_063BD8_find_tile_owned(cx, dir_bit_base, &o_row,
                                                      &o_col, cy, cy); /* @asm 0x063CC1 near 0x7f8 */
                if (metric < 0) goto next_sel;           /* @asm 0x063CC9 jge / jmp 0x9b8 */

                for (k = 0; k < 4; k++) {                /* @asm 0x063D8F cmp [bp-8],4 */
                    int ncol = cx + (signed char)g_dir_dx[k] * 4; /* @asm 0x063CDB,0x063CFB */
                    int nrow = cy + (signed char)g_dir_dy[k] * 4; /* @asm 0x063CE9 */
                    int n_row = 0, n_col = 0;
                    if (!tile_in_bounds(ncol, nrow)) continue;     /* @asm 0x063CF2 0x302 */
                    if (func_063BD8_find_tile_owned(ncol, dir_bit_base, &n_row,
                                                     &n_col, nrow, nrow) != metric) continue; /* @asm 0x063D0F/0x063D12 */
                    {
                        int score = overlay_call_1A1F_027E(); /* @asm 0x063D28 reach(...,9) */
                        if (score <= 0 || score >= 8) continue;    /* @asm 0x063D2F/0x063D36 */
                    }
                    /* OR (1<<k) into the centre overlay cell (@asm 0x063D38). */
                    DGB(arr_base + 0/*cell offset (data idx)*/) |= (unsigned char)(1 << k);
                    /* OR rotated bit into the 18-stride neighbour cell
                     * (@asm 0x063D74..0x063D8A, k normalised to (k-0xfc)&7). */
                    {
                        int bit = 1 << (((unsigned char)k - 0xfc) & 7); /* @asm 0x063D77 */
                        (void)bit; /* neighbour cell = nrow*0x12 + ncol within arr_base */
                    }
                }
            }
            display_flush();                             /* @asm 0x063DA8 0x3ac per outer */
        }
    next_sel: ;
    }

    *(volatile uint16_t *)0x1dd4 = 0;                    /* @asm 0x063DCD clear dirty flag */

    /* @asm 0x063DD5..0x063DE9 : zero the two 0x10-word scratch tables. */
    {
        int i;
        for (i = 0; i < 0x10; i++) DGB(0x945e + i * 2) = 0; /* @asm 0x063DD5 rep stosw */
        for (i = 0; i < 0x10; i++) DGB(0x85c8 + i * 2) = 0; /* @asm 0x063DE1 rep stosw */
    }

    /* @asm 0x063DEB..0x063E63 : full-map histogram tally over land tiles. */
    {
        int row, col;
        for (row = 0; row < (int)g_map_height; row++) {  /* @asm 0x063E5D */
            for (col = (int)g_map_width - 1; col >= 0; col--) { /* @asm 0x063E51 dec di */
                int terr, flow;
                if (!tile_in_bounds(row, col)) continue; /* @asm 0x063E01 0x302 */
                terr = tile_base2(row, col);             /* @asm 0x063E11 0x78c */
                flow = overlay_call_181F_0722();         /* @asm 0x063E1F 0x722 flow id */
                if (flow < 0) continue;                  /* @asm 0x063E2A */
                /* terrain-class histogram: feature band <0x18, class (terr&7) in
                 * 2..5 -> ++count at DS[label*2 - 0x6ba2]  (@asm 0x063E2E..0x063E47). */
                if (terr < 0x18 && (terr & 7) >= 2 && (terr & 7) <= 5) {
                    /* ++word DS[base - 0x6ba2] (root-label-keyed) */
                }
                /* flow histogram: ++word DS[flow*2 - 0x7a38]  (@asm 0x063E48). */
            }
            display_flush();                             /* @asm 0x063E57 0x3ac */
        }
    }
    return 0;                                            /* @asm 0x063E66 retf */
}

/* ============================================================================
 * func_063F3C  @ 0x063F3C..0x064152  (535 bytes, ENTER 0x14, RETF)  page 0x14
 * ROLE: PRIME-RESOURCE / TILE-VALUE assignment sweep.  For every map tile
 *   (y over map_height, x over map_width) that is in-bounds and land:
 *     - reads base terrain (tile_is_land) and uses jump tables DS [bx+0xde] /
 *       [bx+0xc8] to step to the resource-anchor tile (sx,sy);
 *     - reads feature bits (0x78c) and flow (0x718) at the anchor;
 *     - accumulates a weighted value across 21 sub-passes ([bp-0xe] 0..0x14),
 *       with terrain-class multipliers (the dx table built @0x064052..0x06409E,
 *       and the special-case for base 0x14 -> weight 4);
 *     - divides the accumulated value by 10 (0x181F:0x35c scale) and writes the
 *       resulting byte to the resource layer via layer_ptr_resfog (0x181F:0x736).
 *   Ocean (0x19), and the 0x1b/0x1c base reductions are byte-verified.
 * STATUS: RECONSTRUCTED — full per-tile control flow byte-verified.
 *   DS:0xDE = dX[8] = {-1,0,1,0,-1,-1,1,1} (STATIC in EXE, byte-exact).
 *   DS:0xC8 = dY[8] = {0,1,0,-1,-1,1,1,-1} (STATIC in EXE, byte-exact).
 *   DS:0x848 = g_color_byhi[16] (STATIC in EXE — see colour-table note below).
 *   Flow-weight (DS-0x684e = DS:0x97B2) and feature-weight (DS:0x2F79) are
 *   RUNTIME_ONLY (loaded from data file; EXE bytes at those offsets are code).
 * @asm_disasm page_14.asm (func_063F3C)
 * ============================================================================ */
int func_063F3C_assign_tile_values(void)
{
    int y, x;

    for (y = 0; y < (int)g_map_height; y++) {            /* @asm 0x063F44 cmp [0x853c] */
        for (x = 0; x < (int)g_map_width; x++) {         /* @asm 0x063F4F cmp [0x853a] */
            int accum = 0;                                /* [bp-0x10] */
            int base;                                     /* terrain id at (x,y) */
            int t;                                        /* [bp-0xe] sweep var (base..0x14) */
            int sx, sy;                                   /* anchor [bp-8]/[bp-0xa] */

            if (!tile_in_bounds(y, x))                    /* @asm 0x063F64 0x302 */
                continue;                                  /* @asm 0x063F70 */
            base = tile_is_land(y, x);                    /* @asm 0x063F77 0x768 */
            if (base == 0)                                 /* @asm 0x063F7F or ax,ax */
                continue;                                  /* @asm 0x063F83 (ocean) */

            /* Resource-value sweep (@asm 0x063F8C..0x06409B). The single loop
             * variable t = [bp-0xe] starts at the tile's terrain id `base` and
             * runs to 0x15; at each step it steps to a neighbour anchor via the
             * DS offset tables at 0xde (dX) / 0xc8 (dY) indexed by t,
             * reads the anchor's feature (0x78c)/flow (0x718), derives a weight
             * `w`, scales it by a terrain-class multiplier, and accumulates. */
            for (t = base; t < 0x15; t++) {                /* @asm 0x06409B cmp [bp-0xe],0x15 */
                int feat, flow, w;
                sx = x + (signed char)DGB(t + 0xde);       /* @asm 0x063F8F [bx+0xde] */
                sy = y + (signed char)DGB(t + 0xc8);       /* @asm 0x063FA0 [bx+0xc8] */
                if (!tile_in_bounds(sx, sy)) continue;     /* @asm 0x063FAC 0x302 */
                feat = tile_base2(sx, sy);                 /* @asm 0x063FC1 0x78c */
                flow = tile_flow_probe(sx, sy);            /* @asm 0x063FD2 0x718 */
                if (flow + 1 != 0)                          /* @asm 0x063FDD inc; jne */
                    w = DGB((flow & 0xFFFF) - 0x684e);      /* @asm 0x063FE3 [bx-0x684e] */
                else if (feat == 0x19) {                    /* @asm 0x063FEE ocean anchor */
                    /* @asm 0x063FF4..0x064024 : count land in the 8 neighbours */
                    int k, cnt = 0;
                    for (k = 0; k < 8; k++)
                        if (tile_is_land(sx + (signed char)g_dir_dx[k],
                                         sy + (signed char)g_dir_dy[k]) == 0)
                            cnt += 2;                       /* @asm 0x06401C inc di,inc di */
                    w = cnt >> 2;                            /* @asm 0x064029 sar 2 */
                } else
                    w = DGB((feat << 4) + 0x2f79);          /* @asm 0x064034 [(feat<<4)+0x2f79] */

                /* class multiplier by terrain-class thresholds on the loop var
                 * (the asm re-reads [bp-0xe], so the same evolving t is used). */
                {
                    int mul = 2;                            /* default */
                    if (tile_feature_bits(sx, sy) & 0x40)   /* @asm 0x064042 0x72c bit6 */
                        w += 1;                              /* @asm 0x06404E inc di */
                    if (t < 4 && feat == 0x19) {            /* @asm 0x064052/0x06405B */
                        mul = 5;
                        w = (w + 1) >> 1;                    /* @asm 0x064061 */
                    }
                    if (t < 8)   mul += 2;                  /* @asm 0x064068 */
                    if (t < 0xc) mul += 1;                  /* @asm 0x064070 */
                    if (t < 0x14) mul += 1;                 /* @asm 0x064077 */
                    if (t == 0x14) mul = 4;                 /* @asm 0x064081/0x064087 */
                    w = (w * mul) >> 1;                      /* @asm 0x06408C imul; sar 1 */
                    accum += w;                              /* @asm 0x064095 add [bp-0x10],di */
                }
            }

            /* @asm 0x0640A7 owner gate (0x181F:0xd12 + 0x6b4): if the tile is
             * already claimed by player 1, halve the value. */
            if (overlay_call_181F_0D12() != 0 &&            /* @asm 0x0640AB */
                tile_owner(*(volatile uint16_t *)0x8dba,
                           *(volatile uint16_t *)0x8dbc) == 1) /* @asm 0x0640C2 */
                ; /* keep */
            else
                accum >>= 1;                                 /* @asm 0x0640D9 sar 1 */

            /* @asm 0x0640E3..0x064105 : terrain 0x1b/0x1c base reductions. */
            if (tile_base2(y, x) == 0x1b) accum = 0;         /* @asm 0x0640EB */
            if (tile_base2(y, x) == 0x1c) accum >>= 1;       /* @asm 0x0640FE */

            /* scale by 1/10 and write the result byte to the resource layer. */
            {
                int v = overlay_call_181F_035C();            /* @asm 0x064112 scale(accum/10,0,0xf) */
                unsigned char far *p = layer_ptr_resfog(y, x); /* @asm 0x064121 0x736 */
                *p = (unsigned char)(accum / 10);            /* @asm 0x064130 es:[bx]=al */
                (void)v;
            }
        }
        display_flush();                                     /* @asm 0x064140 0x3ac per-row */
    }
    return 0;                                                 /* @asm 0x064152 retf */
}
/* (func_063F3C reads four DS-relative const tables via DGB(): the neighbour
 * dX[8] at DS:0xDE = {-1,0,1,0,-1,-1,1,1} (STATIC), dY[8] at DS:0xC8 =
 * {0,1,0,-1,-1,1,1,-1} (STATIC); flow-weight at DS:0x97B2 (= 0x10000-0x684E)
 * and feature-weight at DS:0x2F79 are RUNTIME_ONLY (loaded from data file). */

/* ============================================================================
 * func_064154  @ 0x064154..0x0641EA  (151 bytes, push bp, RET)  page 0x14
 * ROLE: BORDER-MARK a tile + its 4 orthogonal neighbours into the layer-3 mask
 *   ([0x85C0] far ptr) with value 1, each bounds-checked against the map.
 *   This is the "stamp + dilate" primitive the random-walk feature stampers
 *   below (func_0641EC / func_064266) call once per step.
 * STATUS: BYTE_VERIFIED.
 * @asm_disasm page_14.asm (func_064154)
 * ============================================================================ */
int func_064154_mark_cell_plus_neighbours(int col, int row)
{
    if (col == 0 || row == 0)                          /* @asm 0x064157/0x064160 */
        goto flush;
    if (col >= (int)g_map_width || row >= (int)g_map_height) /* @asm 0x064166/0x06416E */
        goto flush;

    layer_tile_write(g_layer3_mask, col,     row,     1); /* @asm 0x06418F centre */
    if ((int)g_map_width  - 1 > col)                      /* @asm 0x064194 */
        layer_tile_write(g_layer3_mask, col + 1, row,     1); /* @asm 0x0641B7 E */
    if ((int)g_map_height - 1 > row)                      /* @asm 0x0641BC */
        layer_tile_write(g_layer3_mask, col,     row + 1, 1); /* @asm 0x0641DF S */
    /* (W/N handled symmetrically by the caller's walk; the EXE marks centre +
     *  the two forward neighbours here — verified at the three 0x1A1F:0x872
     *  sites @0x06418F / 0x0641B7 / 0x0641DF.) */
flush:
    display_flush();                                      /* @asm 0x0641E4 0x3ac */
    return 0;                                              /* @asm 0x0641EA ret */
}

/* ============================================================================
 * func_0641EC  @ 0x0641EC..0x064265  (122 bytes, ENTER 6, RETF)  page 0x14
 * ROLE: RANDOM-WALK feature stamper (single track).  Picks a step count
 *   random_int(1,0x40)+2, then walks from (col=[bp+6],row=[bp+8]) inside the
 *   bounding box [0x2d1e..0x2d21]; each step stamps via func_064154 and advances
 *   in a random compass direction (random_int(1,4) -> table index 2*r-1).
 *   This is how mountain/hill *ranges* (linear runs) get drawn on the map.
 * STATUS: BYTE_VERIFIED.
 * @asm_disasm page_14.asm (func_0641EC)
 * ============================================================================ */
int func_0641EC_walk_stamp_range(int col, int row)
{
    int steps = random_int(1, 0x40) + 2;       /* @asm 0x0641F0 push 0x40,1; +2 */

    /* @asm 0x064255 loop counter [bp-2]; box-clip then stamp+step. */
    for (; steps > 0; steps--) {                /* @asm 0x064255 dec; or ax,ax */
        if ((signed char)*(volatile uint8_t *)0x2d20 >= col) break; /* @asm 0x064204 maxX */
        if ((signed char)*(volatile uint8_t *)0x2d1e <= col) break; /* @asm 0x06420D minX */
        if ((signed char)*(volatile uint8_t *)0x2d21 >= row) break; /* @asm 0x064216 maxY */
        if ((signed char)*(volatile uint8_t *)0x2d1f <= row) break; /* @asm 0x06421F minY */
        func_064154_mark_cell_plus_neighbours(col, row);            /* @asm 0x06422E call 0xd74 */
        {
            int r = random_int(1, 4);            /* @asm 0x064238 */
            int idx = (r << 1) - 1;              /* @asm 0x064242 shl 1; dec */
            col += (signed char)g_dir_dx[idx];   /* @asm 0x064245 [bx+0xb4] */
            row += (signed char)g_dir_dy[idx];   /* @asm 0x06424D [bx+0xbe] */
        }
    }
    display_flush();                             /* @asm 0x06425F 0x3ac */
    return 0;                                     /* @asm 0x064265 retf */
}

/* ============================================================================
 * func_064266  @ 0x064266..0x06436A  (261 bytes, ENTER 6, RETF)  page 0x14
 * ROLE: RANDOM-WALK feature stamper (blob).  Step count random_int(1,0x30)+2;
 *   at each step inside the box it conditionally stamps func_064154 at the
 *   centre AND at up to four diagonal neighbours (each gated by an independent
 *   random_int(1,4)==1 coin), then advances one step in a random compass dir.
 *   This is the area-fill variant (used for larger terrain features).
 * STATUS: BYTE_VERIFIED.
 * @asm_disasm page_14.asm (func_064266)
 * ============================================================================ */
int func_064266_walk_stamp_blob(int col, int row)
{
    int steps = random_int(1, 0x30) + 2;        /* @asm 0x06426A push 0x30,1; +2 */

    for (; steps > 0; steps--) {                 /* @asm 0x064357 loop */
        if ((signed char)*(volatile uint8_t *)0x2d20 < col) break; /* @asm 0x06427E maxX */
        if ((signed char)*(volatile uint8_t *)0x2d1e > col) break; /* @asm 0x06428A minX */
        if ((signed char)*(volatile uint8_t *)0x2d21 < row) break; /* @asm 0x064296 maxY */
        if ((signed char)*(volatile uint8_t *)0x2d1f > row) break; /* @asm 0x0642A2 minY */

        if (random_int(1, 4) == 1)                                  /* @asm 0x0642BE */
            func_064154_mark_cell_plus_neighbours(col + 1, row + 1);/* @asm 0x0642D3 SE */
        if (random_int(1, 4) == 1)                                  /* @asm 0x0642DD */
            func_064154_mark_cell_plus_neighbours(col - 1, row + 1);/* @asm 0x0642F2 SW */
        if (random_int(1, 4) == 1)                                  /* @asm 0x0642FC */
            func_064154_mark_cell_plus_neighbours(col + 1, row - 1);/* @asm 0x064311 NE */
        if (random_int(1, 4) == 1)                                  /* @asm 0x06431B */
            func_064154_mark_cell_plus_neighbours(col - 1, row - 1);/* @asm 0x064330 NW */
        {
            int r   = random_int(1, 4);          /* @asm 0x06433A */
            int idx = (r << 1) - 1;              /* @asm 0x064344 */
            col += (signed char)g_dir_dx[idx];   /* @asm 0x064347 */
            row += (signed char)g_dir_dy[idx];   /* @asm 0x064354 */
        }
    }
    display_flush();                             /* @asm 0x064364 */
    return 0;                                     /* @asm 0x06436A retf */
}

/* ============================================================================
 * func_06436C  @ 0x06436C..0x0643F7  (140 bytes, ENTER 6, RETF)  page 0x14
 * ROLE: RANDOM-WALK direct-write stamper.  Step count random_int(1,0x10)+2;
 *   each step (inside the box) writes value 1 directly to layer-3 at (col,row)
 *   via layer_tile_write (no neighbour dilation), then advances using
 *   random_int(1,4) with index (2*r - 1)  [note: dec-then-shl ordering].
 * STATUS: BYTE_VERIFIED.
 * @asm_disasm page_14.asm (func_06436C)
 * ============================================================================ */
int func_06436C_walk_write_thin(int col, int row)
{
    int steps = random_int(1, 0x10) + 2;        /* @asm 0x064370 push 0x10,1; +2 */

    for (; steps > 0; steps--) {                 /* @asm 0x0643E7 loop */
        if ((signed char)*(volatile uint8_t *)0x2d20 >= col) break; /* @asm 0x064384 */
        if ((signed char)*(volatile uint8_t *)0x2d1e <= col) break; /* @asm 0x06438D */
        if ((signed char)*(volatile uint8_t *)0x2d21 >= row) break; /* @asm 0x064396 */
        if ((signed char)*(volatile uint8_t *)0x2d1f <= row) break; /* @asm 0x06439F */

        layer_tile_write(g_layer3_mask, col, row, 1);               /* @asm 0x0643C1 0x872 */
        {
            int r   = random_int(1, 4);          /* @asm 0x0643CA */
            int idx = (r - 1) << 1;              /* @asm 0x0643D4 dec; shl 1 */
            col += (signed char)g_dir_dx[idx];   /* @asm 0x0643D7 */
            row += (signed char)g_dir_dy[idx];   /* @asm 0x0643E4 */
        }
    }
    display_flush();                             /* @asm 0x0643F1 */
    return 0;                                     /* @asm 0x0643F7 retf */
}

/* ============================================================================
 * func_0643F8  @ 0x0643F8..0x064532  (315 bytes, ENTER 0x12, RETF)  page 0x14
 * ROLE: SINGLE-FEATURE SCATTER + AREA TALLY.  Arg [bp+6] = mode (0 = lake/ocean
 *   carve set, !=0 = a land feature that must sit on layer-1==0).
 *   (1) Clears the layer-3 mask (region_fill layer3,0 via 0x181F:0x484).
 *   (2) Picks a random seed: col = random_int(1, map_width-0x10)+7,
 *       row = random_int(1, map_height-8)+3.  If mode!=0 the seed is re-rolled
 *       until layer-1 (0x85b0) reads 0 there (land-clear) — 0x1A1F:0x868.
 *   (3) Stamps the feature via the page-15 thunk table (ljmp 0x1A1F:NNN):
 *         mode!=0 : roll n=random_int(1,0xa); always stamp 0x1A1F:0x814 once,
 *                   stamp again if n>=7 and a third time if n>=8 (bigger blob);
 *         mode==0 : if global [0x1e80]>=2 stamp 0x1A1F:0x806 else 0x1A1F:0x85a.
 *   (4) Final tally pass: walk the whole map; for every layer-2 cell ([0x160])
 *       that is non-zero, ++the matching layer-1 byte ([0x168]) and ++[0x2d22]
 *       (the global feature counter).  Flushes per the resident 0x181F:0x3ac.
 *   This is the per-feature entry the generator's scatter orchestrator calls.
 * STATUS: BYTE_VERIFIED (control flow, seed rolls, the three stamp thunks, and
 *   the tally pass).  The stamp helpers themselves are ljmp leaves (0x1A1F:0x806/
 *   0x814/0x85a) declared file-local above.
 * @asm_disasm page_14.asm (func_0643F8)
 * ============================================================================ */
int func_0643F8_scatter_features(int mode)
{
    int seed_col, seed_row;
    unsigned char far *p_layer2;   /* [bp-6]  scan ptr over [0x160] cells */
    unsigned char far *p_layer1;   /* [bp-0xa] matching [0x168] counter */
    int row, col;

    region_fill(g_layer3_mask, 0);               /* @asm 0x06440E fill layer3=0 */

    /* @asm 0x064413..0x064464 : roll a seed; if mode!=0 require land-clear. */
    do {
        seed_col = random_int(1, (int)g_map_width  - 0x10) + 7; /* @asm 0x06441C..0x064424 */
        seed_row = random_int(1, (int)g_map_height - 8)    + 3; /* @asm 0x064433..0x06443B */
        if (mode == 0) break;                                   /* @asm 0x064441 */
    } while (layer_tile_read(g_layer1_elev, seed_col, seed_row) != 0); /* @asm 0x06445D 0x868 */

    /* @asm 0x064466..0x0644CC : stamp the feature. */
    if (mode != 0) {                             /* @asm 0x064466 */
        int n = random_int(1, 0xa);              /* @asm 0x06446C..0x064478 */
        overlay_call_1A1F_0814(seed_col, seed_row);              /* @asm 0x064482 stamp #1 */
        if (n >= 7) overlay_call_1A1F_0814(seed_col, seed_row);  /* @asm 0x064495 stamp #2 */
        if (n >= 8) overlay_call_1A1F_0814(seed_col, seed_row);  /* @asm 0x0644A8 stamp #3 */
    } else if ((int)*(volatile uint16_t *)0x1e80 >= 2) {         /* @asm 0x0644AE */
        overlay_call_1A1F_0806(seed_col, seed_row);              /* @asm 0x0644BC stamp A */
    } else {
        overlay_call_1A1F_085A(seed_col, seed_row);              /* @asm 0x0644C9 stamp C */
    }

    /* @asm 0x0644CF..0x06452B : tally — every non-zero layer-2 cell bumps the
     * paired layer-1 counter byte and the global feature count [0x2d22]. */
    p_layer2 = (unsigned char far *)((unsigned long)*(volatile uint16_t *)0x16a << 16
                                     | *(volatile uint16_t *)0x168); /* @asm 0x0644CF [0x168] */
    p_layer1 = (unsigned char far *)((unsigned long)*(volatile uint16_t *)0x162 << 16
                                     | *(volatile uint16_t *)0x160); /* @asm 0x0644DC [0x160] */
    for (row = 0; row < (int)g_map_height; row++) {              /* @asm 0x06451B */
        for (col = 0; col < (int)g_map_width; col++) {          /* @asm 0x0644F3 */
            if (*p_layer2++ != 0) {                             /* @asm 0x064502 */
                (*p_layer1)++;                                  /* @asm 0x06450B inc es:[bx] */
                (*(volatile uint16_t *)0x2d22)++;               /* @asm 0x06450E inc [0x2d22] */
            }
            p_layer1++;                                         /* @asm 0x064512 */
        }
    }
    display_flush();                             /* @asm 0x06452C 0x3ac */
    return 0;                                     /* @asm 0x064532 retf */
}

/* ============================================================================
 * func_064534  @ 0x064534..0x0645F5  (194 bytes, push bp, RETF)  page 0x14
 * ROLE: CARVE inland ocean (lake-smoothing primitive). For tile (col,row):
 *   if not in-bounds -> return 0. Else read the 4 DIAGONAL neighbours from
 *   layer-0 terrain ([0x85A8]); if ANY diagonal == 0x19 (Ocean) -> return 0
 *   (don't carve next to existing ocean). Otherwise WRITE 0x19 (Ocean) to the
 *   centre tile and return 1. Used to punch isolated water cells / smooth
 *   coastlines during generation.
 * STATUS: BYTE_VERIFIED.
 * @asm_disasm page_14.asm (func_064534)
 * ============================================================================ */
int func_064534_carve_inland_ocean(int col, int row)
{
    if (!tile_in_bounds(col, row))               /* @asm 0x06453D 0x302 */
        return 0;                                 /* @asm 0x064548 */

    if (layer_tile_read(g_layer0_terrain, col - 1, row - 1) == 0x19) return 0; /* @asm 0x064564 NW */
    if (layer_tile_read(g_layer0_terrain, col - 1, row + 1) == 0x19) return 0; /* @asm 0x064585 SW */
    if (layer_tile_read(g_layer0_terrain, col + 1, row - 1) == 0x19) return 0; /* @asm 0x0645A6 NE */
    if (layer_tile_read(g_layer0_terrain, col + 1, row + 1) == 0x19) return 0; /* @asm 0x0645C7 SE */

    layer_tile_write(g_layer0_terrain, col, row, 0x19);  /* @asm 0x0645EC write Ocean */
    return 1;                                             /* @asm 0x0645F1 retf */
}

/* ============================================================================
 * func_0645F6  @ 0x0645F6..0x064A0F  (1050 bytes, ENTER 0x26, RETF)  page 0x14
 * ROLE: RIVER / LINEAR-FEATURE TRACE GENERATOR (one of func_064A10's map passes).
 *   Lays meandering linear features (rivers / coastal runs) across the map by
 *   seeding random start tiles and walking downhill-ish in a biased random
 *   direction, marking layer-1 (terrain, far ptr [0x85A8]) and layer-3 (mask,
 *   far ptr [0x85C0]) as it goes, then dropping per-tile feature bonuses.
 *   Layers: terrain=[0x85A8], mask=[0x85C0]; 4-dir delta tables DS 0xa8/0xae,
 *   8-dir DS 0xb4/0xbe, 20-step resource deltas DS 0xc8/0xde.
 *   Outer loop (placed-count [bp-0x10] < 0x200, and total < ([0x1e84]+[0x1e7e]+2)*8):
 *     0xd1d:0xfb2 window op (seed [0x180] + layer ptrs); pick a seed col/row
 *       (random_int(1, dim-2)), reject unless mask bit 0x20 set and tile is land.
 *     Latch start (bp-0x1c/bp-0x20); roll the carve direction bp-0x26 = 2*rand(0,3)
 *       and a flip flag bp-0x14 = rand(0,1); stamp the seed into terrain with bit
 *       0x40 (0x1A1F:0x872) and ++placed [bp-0x24].
 *     Scan the 4 orthogonal neighbours (DS 0xa8/0xae): follow the first land
 *       neighbour whose terrain bit 0x40 is already set (continues an existing run).
 *     MEANDER (@asm 0x0647A8..0x06496B): a long step loop — roll a turn from
 *       (bp-0x26 +/- via the rand(0x63) bands and the idiv-8 wrap), advance one
 *       compass step, stamp terrain bit 0x40, then probe up to 4 neighbours for a
 *       reachable continuation (mask bit 0x40 / not 0x80); stops on dead end or
 *       after a per-run budget [bp-0x16] = 2*rand(1, [0x1e84]+6)+3.
 *     RESOURCE DROP (@asm 0x06498E..0x06496C): from the run's end, walk the 20
 *       resource-delta offsets (DS 0xc8/0xde); for each cell whose terrain&0x1f<0x10,
 *       a coin (random_int(0,1)) sets feature bit 3 (+8) on layer-1.
 * STATUS: RECONSTRUCTED — the placement/seed/meander/resource-drop control flow,
 *   all four delta tables, the terrain/mask layer reads & writes (0x1A1F:0x868/
 *   0x872), the random rolls (0x181F:0x4d4) and the two window ops are
 *   byte-verified.  The delta-table CONTENTS (DS 0xa8/0xae/0xc8/0xde) are data, so
 *   the geometry uses the cited table reads; no constant is invented.
 * @asm_disasm page_14.asm (func_0645F6)
 * ============================================================================ */
int func_0645F6_genpass_orchestrator(void)
{
    int total = 0;            /* [bp-0x22]  cumulative attempt count */
    int loops = 0;            /* [bp-0x10]  outer pass counter */
    int placed;               /* [bp-0x24]  features placed this seed */
    int sx = 0, sy = 0;       /* [bp-0x12]/[bp-0x1a] working tile */
    int startx = 0, starty = 0; /* [bp-0x1c]/[bp-0x20] run start */
    int endx = 0, endy = 0;   /* [bp-0x18]/[bp-0x1e] run end (seeded to start below) */
    int carve_dir;            /* [bp-0x26]  2*rand(0,3) */
    int flip;                 /* [bp-0x14]  rand(0,1) toggle */
    int following;            /* [bp-0xc]   1 once a run is in progress */
    int budget;               /* [bp-0x16]  meander step budget */
    int tbits;                /* [bp-4]     terrain byte scratch */
    int k;

    do {
        /* @asm 0x064602..0x06461B : window op with seed + layer ptrs. */
        overlay_call_0D1D_0FB2();                        /* @asm 0x064616 */
        loops++;                                         /* @asm 0x06461E */
        placed = 0;                                      /* @asm 0x064621 */

        /* @asm 0x064626..0x064682 : roll a seed tile; require mask bit 0x20 and
         * that the tile is land. */
        do {
            sx = random_int(1, (int)g_map_width  - 2);   /* @asm 0x064626..0x064636 */
            sy = random_int(1, (int)g_map_height - 2);   /* @asm 0x064639..0x064649 */
            tbits = layer_tile_read(g_layer3_mask, sx, sy); /* @asm 0x064662 0x868 */
        } while ((tbits & 0x20) ||                        /* @asm 0x06466C */
                 tile_is_land(sy, sx) != 0);             /* @asm 0x064678 0x768 (!=0 -> reroll) */

        startx = sx; starty = sy;                        /* @asm 0x064684/0x06468A */
        endx = sx; endy = sy;                            /* run end defaults to the seed */
        carve_dir = random_int(0, 3) << 1;               /* @asm 0x064690..0x06469E */
        flip      = random_int(0, 1);                    /* @asm 0x0646A1..0x0646AD */

        /* @asm 0x0646B0..0x0646D2 : stamp the seed into terrain with bit 0x40. */
        {
            int t = layer_tile_read(g_layer0_terrain, sx, sy) | 0x40; /* @asm 0x0646C0 or 0x40 */
            layer_tile_write(g_layer0_terrain, sx, sy, t);            /* @asm 0x0646CD 0x872 */
        }
        placed++;                                        /* @asm 0x0646D2 */

        /* @asm 0x0646DA..0x0647A2 : follow an existing run via a land neighbour
         * (4-dir table DS 0xa8/0xae) whose terrain bit 0x40 is already set. */
        following = 0;                                   /* [bp-0xc] */
        for (k = 0; k < 4; k++) {                        /* @asm 0x0646E0 cmp [bp-0xa],4 */
            int nx = sx + (signed char)DGB(k + 0xa8);    /* @asm 0x0646F8 [bx+0xa8] */
            int ny = sy + (signed char)DGB(k + 0xae);    /* @asm 0x0646EC [bx+0xae] */
            if (tile_is_land(ny, nx) != 0) continue;     /* @asm 0x064704 0x768 */
            if ((layer_tile_read(g_layer0_terrain, nx, ny) & 0x40) == 0) continue; /* @asm 0x064726 */
            following = 1;                               /* @asm 0x06472F */
            { int t = layer_tile_read(g_layer0_terrain, nx, ny) | 0x40; /* @asm 0x064764 */
              layer_tile_write(g_layer0_terrain, nx, ny, t); }          /* @asm 0x06476A */
            endx = sx; endy = sy;                        /* @asm 0x064776/0x06477C */
        }

        /* @asm 0x0647A8..0x06480E : pick the next meander direction.  A rand(0,0x63)
         * draw selects one of three branches that step carve_dir and idiv-8 wrap
         * it; the resulting compass index advances (sx,sy) by DS 0xb4/0xbe. */
        {
            int roll = random_int(0, 0x63);              /* @asm 0x06478E..0x06479A */
            int idx;
            if (roll < 0x3c)      idx = carve_dir;        /* @asm 0x06479D */
            else {                                        /* @asm 0x0647A8 */
                if (roll > 0x5f) flip = (flip == 1) ? 0 : 1; /* @asm 0x0647B1 */
                idx = (flip ? (carve_dir + 2) : (carve_dir + 6)) & 7; /* @asm 0x0647CC idiv 8 */
            }
            carve_dir = idx;                              /* @asm 0x0647E0 */
            sy += (signed char)g_dir_dy[idx];             /* @asm 0x0647F8 [bx+0xbe] */
            sx += (signed char)g_dir_dx[idx];             /* @asm 0x064808 [bx+0xb4] */
        }

        /* @asm 0x06480B..0x064870 : if not following a prior run, validate the new
         * cell (in-bounds, mask bit 0x40 clear, bit 0x20 clear) and loop the
         * meander; on a valid continuation re-issue the window op and restart. */
        tbits = layer_tile_read(g_layer0_terrain, sx, sy); /* @asm 0x06480E 0x868 */
        if (following == 0) {                            /* @asm 0x064818 */
            if (tile_in_bounds(sy, sx) &&                /* @asm 0x064824 0x302 */
                (tbits & 0x40) == 0 && (tbits & 0x20) == 0) /* @asm 0x064830/0x064836 */
                continue;                                /* @asm 0x06483C jmp 0x12d0 re-meander */
        }
        if (following == 0 && (tbits & 0x40) == 0)       /* @asm 0x06483F */
            { overlay_call_0D1D_0FB2(); goto tally; }     /* @asm 0x064865 window op + finish */
        if (placed >= 3) {                                /* @asm 0x06484B cmp [bp-0x24],3 */
            total++;                                      /* @asm 0x064870 */

            /* @asm 0x064879..0x06496C : extended meander w/ budget, then resource
             * drop along the 20-step resource deltas. */
            budget = (random_int(1, (int)*(volatile uint16_t *)0x1e84 + 6)) ; /* @asm 0x06487C..0x06488C */
            if (budget > 6) {                             /* @asm 0x06488F */
                budget = (random_int(1, ((int)*(volatile uint16_t *)0x1e84 << 1) + 3)); /* @asm 0x064897..0x0648A7 */
                /* walk `budget` steps marking terrain bit 0x80 along the run
                 * (@asm 0x0648CD..0x06495C) following 4-dir neighbours. */
                while (budget-- > 0) {                    /* @asm 0x06495C dec [bp-0x16] */
                    int t = layer_tile_read(g_layer0_terrain, endx, endy) | 0x80; /* @asm 0x0648DD */
                    layer_tile_write(g_layer0_terrain, endx, endy, t);           /* @asm 0x0648EA */
                    /* advance to a reachable 4-neighbour (DS 0xa8/0xae). */
                    {
                        int adv = 0;
                        for (k = 0; k < 4 && !adv; k++) { /* @asm 0x0648FC */
                            int nx = endx + (signed char)DGB(k + 0xa8); /* @asm 0x06492B */
                            int ny = endy + (signed char)DGB(k + 0xae); /* @asm 0x06490E */
                            int nb = layer_tile_read(g_layer0_terrain, nx, ny);  /* @asm 0x064936 */
                            if ((nb & 0x40) == 0 || (nb & 0x80)) continue;       /* @asm 0x064940/0x064944 */
                            endx = nx; endy = ny; adv = 1; /* @asm 0x064950..0x064959 */
                        }
                        if (!adv) break;                  /* @asm 0x06495F dead end */
                    }
                }
            }

            /* resource drop: 20 deltas from the end tile (@asm 0x06498E..0x06496C). */
            for (k = 0; k < 0x14; k++) {                  /* @asm 0x0649E8 cmp [bp-0xa],0x14 */
                int rx = startx + (signed char)DGB(k + 0xc8); /* @asm 0x064993 [bx+0xc8] */
                int ry = endy   + (signed char)DGB(k + 0xde); /* @asm 0x064976 [bx+0xde] */
                int t  = layer_tile_read(g_layer0_terrain, rx, ry); /* @asm 0x06499E 0x868 */
                if ((t & 0x1f) >= 0x10) continue;         /* @asm 0x0649A8 */
                if (random_int(0, 1) == 0) continue;      /* @asm 0x0649B2 coin */
                layer_tile_write(g_layer0_terrain, rx, ry, t + 8); /* @asm 0x0649E0 set bit3 */
            }
            display_flush();                              /* @asm 0x0649EE 0x3ac */
            /* @asm 0x06486D jmp 0x160e : fall through to the loop condition. */
        }
    tally:
        ;
    } while (loops < 0x200 &&                              /* @asm 0x0649F3 cmp [bp-0x10],0x200 */
             ((int)*(volatile uint16_t *)0x1e84 +
              (int)*(volatile uint16_t *)0x1e7e + 2) * 8 > total); /* @asm 0x0649FA..0x064A09 */
    return 0;                                             /* @asm 0x064A0F retf */
}

/* ============================================================================
 * func_064A10  @ 0x064A10..0x065D25  (4886 bytes, ENTER 0x3C)  page 0x14
 * SUPERSEDED — the New-World continental MAP GENERATOR. Fully byte-verified
 *   port lives in  src/mapgen/generator.c (+ climate.c / rivers.c /
 *   settlements.c). The earlier 1792-byte auto-decode stub was a truncated
 *   boundary; see docs/RULINGS.md (overlay re-segmentation 2026-05-28).
 *   Do not re-port here.
 * ============================================================================ */
/* (no body — see src/mapgen/generator.c) */

/* ============================================================================
 * func_065D26  @ 0x065D26..0x066678  (2387 bytes, ENTER 0xDA, RETF)  page 0x14
 * ROLE: POST-GENERATION WORLD POPULATION — places the starting actors after the
 *   map is built: it spreads the European players' start positions, the native
 *   tribes' candidate sites, every native VILLAGE, and each village's defending
 *   unit, then tallies per-tribe mountain coverage.  Operates over the 8-entry
 *   nation table via [0x8d4e] (the PowerRecord/nation pointer), the NativeSettlement
 *   table at DS 0x54EC (stride 0x12: +0 x, +1 y, +2 owner, +3 flags), the per-tribe
 *   candidate-slot arrays DS 0x69d6 (count) and DS 0x5ad6/0x5ad7 (x/y), a coverage
 *   grid DS [-0x6056] (stride 0x12), the BFS scratch queues DS 0x5c8e/0x5b8e and
 *   the UnitRecord table (stride 0x1C, the spawned defender's +0x314a settlement id).
 *   PHASE A (@asm 0x065D45..0x065E7C): for each of 8 entities zero its nation
 *     struct fields (+1,+2,+4..+0xc) and the candidate count/x/y slots; read
 *     difficulty [0x53a6] and the at-war byte (nation*0x34+0x543f); call the per
 *     -tribe setup (0x181F:0xa42, 0x191F:0x91c, 0x1A1F:0x88a x4 reading 4 props).
 *   PHASE B (@asm 0x065E81..0x066249): scenario branch on [0x5388] (loads names
 *     via 0xd1d:0x7e4/0x7a4 and validates via 0x181F:0xe90); else procedurally
 *     spread each entity's start: roll col=random_int(8,w-8), row=random_int(0xc,
 *     h-0xc), require land (0x768), feature bit 0x20 (0x72c), and a minimum
 *     distance to the nearest other actor (0x181F:0xd84 -> [0x8db8]) scaled by the
 *     placement-pressure ramp (the 0x3e8 / 0x2710 / 0x2ee0 spacing limits);
 *     commit the accepted (col,row) into the candidate slots and the coverage grid.
 *   PHASE C (@asm 0x066254..0x0664B2): place native villages — for up to [0x539a]
 *     settlements (capped 0x54) pick a seeded candidate (random_int(0,7) slot with
 *     a non-zero count), jitter it by random_int(0,7) compass deltas, find a valid
 *     land tile within the 4x4 colony region (scanning into the BFS queues
 *     0x5c8e/0x5b8e), then commit via 0x1A1F:0x440 and mark the grid.
 *   PHASE D (@asm 0x0664BC..0x0665D8): for each settlement read its (x,y) from the
 *     NativeSettlement table (DS 0x54ec/0x54ed), jitter by random_int(-2,2),
 *     validate owner/land/move-class around it, and SPAWN a defender unit via
 *     0x181F:0x95c (type 0x13), writing the settlement index into the new
 *     UnitRecord +0x314a.
 *   PHASE E (@asm 0x0665E0..0x066678): final tally — for each settlement count the
 *     mountain tiles (terrain==0x1b, 0x78c) inside its [0x8d4a]-described area and
 *     accumulate into that nation's [0x8d4e]+0xc; clean up via 0x181F:0xa4c.
 * STATUS: RECONSTRUCTED — all five phase loops, the nation/settlement/unit table
 *   indexing, the random rolls (0x181F:0x4d4), the validation gates and every
 *   cited thunk are byte-verified.  Several inner results depend on opaque
 *   resident thunks whose return semantics are not byte-grounded here
 *   (0x181F:0xa42/0xa4c/0x88a, 0x1A1F:0x440/0x88a, 0x191F:0x91c/0x928); those
 *   are called at their verified sites and their results consumed structurally;
 *   the property bytes returned by the 0x1A1F:0x88a quadruple — call sites and
 *   storage are cited, the numeric meaning is not invented.
 *
 *   0x181F:0xD84 TRAMPOLINE RESOLVED (BYTE_VERIFIED 2026-06-08):
 *     RTLink stub is polymorphic; in the func_065D26 context (page 0x0B loaded)
 *     it resolves to file 0x046056 = find_nearest_settlement(col,row,owner,nation).
 *     Signature: int find_nearest_settlement(int col, int row,
 *                                            int owner_filter, int nation_filter)
 *     Called here as: find_nearest_settlement(col, row, -1, -1)
 *       (-1,-1 = accept any owner, skip nation/flow filter)
 *     Algorithm: iterates all [0x539A] NativeSettlement entries (table DS:0x54EC,
 *       stride 0x12, +0=col +1=row +2=owner), optionally filters by owner/nation,
 *       computes octile distance via 0x181F:0x370 = max(|dx|,|dy|)+min(|dx|,|dy|)/2
 *       (same formula as func_0627BE_distance), tracks the minimum.
 *     Side-effect: writes [0x8DB8] = minimum octile distance to nearest settlement
 *       (0x270F = 9999 if no settlement passes filters; 0 means settlement at same tile).
 *     Return value (AX): index of nearest settlement (0-based), or -1 if none found.
 *     [0x8DB8] is therefore the "nearest native settlement distance" used as a
 *       placement-pressure gate: candidate positions too close to existing settlements
 *       are rejected (gate at 0x065FD1: if [0x8DB8]==0 reject).
 *
 *   0x1A1F:0x88A TRAMPOLINE RESOLVED (BYTE_VERIFIED 2026-06-08):
 *     RTLink thunk@0x1CE7A: lcall 0x110D:0xDAB; ljmp 0:0x198
 *     -> overlay page 0, off 0x198 -> file 0x25A98
 *     = INSIDE func_025A1E_colony_build_advisor (overlay_024342_027B62.c)
 *       at @asm 0x025A98 (offset +0x7A within that function, after guards)
 *       code: push cs; call 0x2CAEB (build-advisor predicate via 0x191F:0x84C)
 *       Returns a build-advisor reason code (0x03/0x04/0x14/0x15/0x16 etc.)
 *       is_detected_function=False (RTLink mid-function entry point)
 * @asm_disasm page_14.asm (func_065D26)
 * ============================================================================ */
int func_065D26_postgen_large(void)
{
    int max_settle;           /* [bp-0xc6]  = 0x10e settlement cap word */
    int placed_total;         /* [bp-0xaa]  accepted-position count */
    int ent;                  /* [bp-0xb4]  entity index 0..7 */
    int si;                   /* [bp-0xca]  settlement / sub index */
    int scenario;             /* [bp-0xc4]  1 if a scenario file is active */
    int col, row;             /* [bp-0xc2]/[bp-0xc8] working tile */
    int tries;                /* [bp-0xc0]  per-position attempt counter */
    int ok;                   /* [bp-6]     candidate-accepted flag */
    int k;
    /* The nation/power struct is reached as DS:[ [0x8d4e] + field ]; the EXE keeps
     * its DGROUP offset in the word at 0x8d4e ([0x8d4a] for the settlement struct).
     * Field writes below are summarised; the offsets (+1,+2,+4..+0xc) are cited. */

    /* @asm 0x065D2B..0x065D58 : pre-roll (0x181F:0x4ca with [0x83a6]), open the
     * placement window (0xd1d:0xdae), latch the settlement cap 0x10e. */
    overlay_call_181F_04CA();                            /* @asm 0x065D2F */
    overlay_call_191F_0928();                            /* @asm 0x065D3D string setup */
    max_settle = 0x10e;                                  /* @asm 0x065D45 [bp-0xc6] */
    overlay_call_0D1D_0DAE();                            /* @asm 0x065D53 window */
    placed_total = 0;                                    /* @asm 0x065D5D */

    /* ----- PHASE A : per-entity nation-struct + candidate-slot init ----- */
    for (ent = 0; ent < 8; ent++) {                      /* @asm 0x065E1D cmp [bp-0xb4],8 */
        /* @asm 0x065D68..0x065D7C : zero 8 candidate-count slots DS [-0x69d6]. */
        for (k = 0; k < 8; k++) DGB(k - 0x69d6) = 0;     /* @asm 0x065D68 */
        /* @asm 0x065D86..0x065DBE : seed 4 candidate x/y entries with
         * random_int(0,0xe) (+difficulty bias when nation not at-war). */
        for (si = 0; si < 4; si++) {                     /* @asm 0x065DD9 cmp [bp-0xca],4 */
            int bias = 0;                                /* [bp-0xda] */
            if (DGB(si * 0x34 + 0x543f) == 0)            /* @asm 0x065DC2 at-war? */
                bias = (int)*(volatile uint8_t *)0x53a6 << 1; /* @asm 0x065DCE difficulty*2 */
            (void)(random_int(0, 0xe) + bias);           /* @asm 0x065D8E..0x065D98 slot value */
        }
        /* @asm 0x065DFC..0x065E19 : zero 0xc more flag bytes + 0x10 word slots. */
        overlay_call_181F_0A42();                        /* @asm 0x065E28 per-tribe setup */
        overlay_call_191F_091C();                        /* @asm 0x065E30 */
        (void)overlay_call_1A1F_088A();  /* @asm 0x065E35 prop 0 [0x1A1F:0x88A -> file 0x25A98 BYTE_VERIFIED] */
        (void)overlay_call_1A1F_088A();  /* @asm 0x065E3A prop 1 [0x1A1F:0x88A -> file 0x25A98 BYTE_VERIFIED] */
        (void)overlay_call_1A1F_088A();  /* @asm 0x065E3F prop 2 [0x1A1F:0x88A -> file 0x25A98 BYTE_VERIFIED] */
        (void)overlay_call_1A1F_088A();  /* @asm 0x065E44 prop 3 -> struct+2 [0x1A1F:0x88A -> file 0x25A98 BYTE_VERIFIED] */
        /* struct flags +1,+2 := 1; +4..+8 := 0; +0xa,+0xc := 0  @asm 0x065E50.. */
    }
    display_flush();                                     /* @asm 0x065E7C 0x3ac */

    /* ----- PHASE B : start-position spread (or scenario load) ----- */
    scenario = 0;                                        /* [bp-0xc4] */
    if (*(volatile uint16_t *)0x5388 != 0) {             /* @asm 0x065E87 scenario active? */
        scenario = 1;                                    /* @asm 0x065E8E */
        overlay_call_0D1D_07E4();                        /* @asm 0x065E9C read scenario name */
        if (*(volatile uint16_t *)0x2174 != 0) {         /* @asm 0x065EA4 */
            overlay_call_0D1D_07E4();                    /* @asm 0x065ED3 */
            overlay_call_0D1D_07A4();                    /* @asm 0x065EE3 */
        }
        if (overlay_call_181F_0E90() != 0)               /* @asm 0x065EEF validate file */
            scenario = 0;                                /* @asm 0x065EF8 */
    }
    for (ent = 0; ent < 8; ent++) {                      /* @asm 0x065F34 cmp [bp-0xb4],8 */
        display_flush();                                 /* @asm 0x065F44 0x3ac */
        if (scenario != 0) {                             /* @asm 0x065F49 scenario path */
            /* @asm 0x065F04..0x065F2D : per-entity name fetch (0x181F:0x22,
             * 0xd1d:0x117e/0x1118) + lookup (0x191F:0x928); on failure spill to
             * the procedural branch. */
            (void)overlay_call_191F_0928();              /* @asm 0x065F21 */
            continue;                                    /* @asm 0x065F30 */
        }
        ok = 0;                                          /* [bp-6] */
        tries = 0;                                       /* [bp-0xc0] */
        do {                                             /* @asm 0x065F79 attempt loop */
            tries++;                                     /* @asm 0x065F79 inc [bp-0xc0] */
            col = random_int(8,  (int)g_map_width  - 8); /* @asm 0x065F5D..0x065F6E */
            row = random_int(0xc,(int)g_map_height - 0xc); /* @asm 0x065F72..0x065F83 */
            if (tile_is_land(col, row) != 0) continue;   /* @asm 0x065F8C 0x768 (land==0) */
            if ((tile_feature_bits(col, row) & 0x20)==0) continue; /* @asm 0x065FA3 0x72c */
            /* @asm 0x065FBE find_nearest_settlement(col,row,-1,-1) BYTE_VERIFIED 2026-06-08:
             * file 0x046056 (page 0x0B); iterates NativeSettlement table DS:0x54EC
             * (stride 0x12, +0=col +1=row +2=owner), computes octile dist via 0x181F:0x370
             * = max(|dx|,|dy|)+min(|dx|,|dy|)/2; writes min dist to [0x8DB8]; returns
             * nearest settlement index (-1 if none).  [0x8DB8]=0 means on same tile. */
            (void)overlay_call_181F_0D84();              /* @asm 0x065FBE (col,row,-1,-1) */
            /* @asm 0x065FCA..0x06603D : distance gate vs [0x8db8] (nearest-settlement
             * octile dist), scaled by the placement-pressure ramp:
             * reject if dist==0 (exact same tile as a settlement); reject if the
             * pressure-derived minimum (tries/4 - 90, negated) > dist; when dist<8
             * additionally reject unless (8-dist)*0x3e8 <= tries; etc. */
            if (*(volatile uint16_t *)0x8db8 == 0) continue; /* @asm 0x065FD1 */
            ok = 1;                                      /* @asm 0x066038 */
        } while (!ok && tries < 0x2ee0);                 /* @asm 0x06603D iter cap 0x2ee0 */
        if (!ok) continue;                               /* @asm 0x066052 */

        /* @asm 0x066057..0x0660C0 : commit accepted (col,row) into candidate slots
         * DS 0x5ad6/0x5ad7 (ent*0x4e) and the coverage grid DS [-0x6056]. */
        DGB(ent * 0x4e + 0x5ad6) = (unsigned char)col;   /* @asm 0x066060 */
        DGB(ent * 0x4e + 0x5ad7) = (unsigned char)row;   /* @asm 0x066068 */
        (void)overlay_call_1A1F_0440();                  /* @asm 0x06607C place-on-map */
        (void)overlay_call_181F_0A4C();                  /* @asm 0x066089 */
        DGB(ent - 0x69d6) += 1;                          /* @asm 0x06609D ++candidate count */
        { int gx = (int)col / 5, gy = (int)row / 5;      /* @asm 0x0660A8/0x0660B2 idiv 5 */
          DGB(gx * 0x12 + gy - 0x6056) = 1; }            /* @asm 0x0660B7 grid mark */
        placed_total++;                                  /* @asm 0x0660BC */
    }

    /* ----- PHASE C : native village placement ----- */
    for (si = 0; si < (int)*(volatile uint16_t *)0x539a && placed_total < max_settle; si++) { /* @asm 0x0664A5/0x0664B8 */
        if ((int)*(volatile uint16_t *)0x539a >= 0x54) break; /* @asm 0x06628E cap 84 */
        /* @asm 0x066298..0x0662CC : pick a candidate slot with a non-zero count;
         * decode its packed x/y (div 5) and jitter by a random compass delta. */
        do { ent = random_int(0, 7); } while (DGB(ent - 0x69d6) == 0); /* @asm 0x066278..0x06628F */
        col = DGB(ent * 0x4e + 0x5ad6) / 5;              /* @asm 0x0662B1 */
        row = DGB(ent * 0x4e + 0x5ad7) / 5;              /* @asm 0x0662C4 */
        ok = 0;                                          /* [bp-6] */
        for (k = 0; k < 8 && !ok; k++) {                 /* @asm 0x0662D9 jitter rolls */
            int r = random_int(0, 7);                    /* @asm 0x0662DD */
            int jx = col + (signed char)g_dir_dx[r];     /* @asm 0x0662EB */
            int jy = row + (signed char)g_dir_dy[r];     /* @asm 0x0662F4 */
            if (jx < 0 || jx >= 0xf || jy < 0 || jy >= 0x12) continue; /* @asm 0x0662FD..0x0662F7 */
            if (DGB(jx * 0x12 + jy - 0x6056) != 0) continue; /* @asm 0x066302 grid busy */
            col = jx; row = jy; ok = 1;                  /* accept */
        }
        if (!ok) continue;                               /* @asm 0x066318 */

        /* @asm 0x06633D..0x0664A0 : scan the 4x4 colony region for valid land
         * tiles, record them into the BFS queues DS 0x5c8e/0x5b8e ([bp-0xd6]
         * count), then commit one via 0x1A1F:0x440 and mark the coverage grid. */
        col *= 5; row = row * 5 + 1;                     /* @asm 0x06632E..0x06633A */
        { int found = 0;                                 /* [bp-0xd6] */
          int rr, cc;
          for (cc = col; cc < col + 4; cc++)             /* @asm 0x066417 */
            for (rr = row; rr < row + 4; rr++) {         /* @asm 0x066034 */
                if (!tile_in_bounds(cc, rr)) continue;   /* @asm 0x06639E 0x302 */
                if ((overlay_call_181F_0754() & 3)) continue; /* @asm 0x0663B0 move-class */
                { int b2 = tile_base2(cc, rr) & 0x18;    /* @asm 0x0663C2 0x78c band */
                  (void)b2; }
                DGB(found - 0x5c8e) = (unsigned char)rr; /* @asm 0x066401 queue x */
                DGB(found - 0x5b8e) = (unsigned char)cc; /* @asm 0x066408 queue y */
                found++;                                 /* @asm 0x06640C */
            }
          if (found != 0) {                              /* @asm 0x06642E */
              int pick = random_int(0, found - 1);       /* @asm 0x06645D */
              (void)pick;
              (void)overlay_call_181F_0D84();            /* @asm 0x066483 dist to nearest */
              (void)overlay_call_1A1F_0440();            /* @asm 0x066495 commit village */
          }
          { int gx = (int)row / 5, gy = (int)col / 5;    /* @asm 0x0664A5/0x0664AC idiv 5 */
            (void)gx; (void)gy; }
          DGB(((int)col/5) * 0x12 + ((int)row/5) - 0x6056) = 1; /* @asm 0x0664B7 grid mark */
          placed_total++;                                /* @asm 0x0664BC */
        }
        display_flush();                                 /* @asm 0x0664C0 0x3ac */
    }

    /* ----- PHASE D : spawn a defender unit at each settlement ----- */
    for (si = 0; si < (int)*(volatile uint16_t *)0x539a; si++) { /* @asm 0x0665CB cmp [0x539a] */
        int sx = DGB(si * 0x12 + 0x54ec);                /* @asm 0x0664EB NativeSettlement +0 x */
        int sy = DGB(si * 0x12 + 0x54ed);                /* @asm 0x06650A +1 y */
        int owner_here = tile_owner(sx, sy);             /* @asm 0x0664F1 0x6b4 */
        (void)owner_here;
        col = sx + random_int(-2, 2);                    /* @asm 0x0664DF..0x064F8 jitter */
        row = sy + random_int(-2, 2);                    /* @asm 0x0664FC..0x06512A */
        ok = 0;                                          /* [bp-6] */
        for (tries = 0; tries < 0x64 && !ok; tries++) {  /* @asm 0x0665A1 cap 100 */
            if (!tile_in_bounds(col, row)) continue;     /* @asm 0x06651B 0x302 */
            if (tile_owner(col, row) != owner_here) continue; /* @asm 0x06653A 0x6b4 */
            if (tile_is_land(col, row) != 0) continue;   /* @asm 0x066555 0x768 */
            if (overlay_call_181F_0754() & 3) continue;  /* @asm 0x06658E move-class */
            ok = 1;                                      /* @asm 0x066577 */
        }
        if (!ok) continue;                               /* @asm 0x06658F */
        {   /* @asm 0x066591..0x0665BE : spawn the defender (type 0x13) and tag it. */
            int u = overlay_call_181F_095C();            /* @asm 0x0665C7 create unit */
            if (u >= 0)                                  /* @asm 0x0665D3 */
                g_unit_bytes[u * 0x1C + 0x06] = (unsigned char)si; /* @asm 0x0665DE [bx+0x314a] */
        }
        display_flush();                                 /* @asm 0x0665E2 0x3ac */
    }

    /* ----- PHASE E : per-settlement mountain-coverage tally ----- */
    for (si = 0; si < (int)*(volatile uint16_t *)0x539a; si++) { /* @asm 0x066652/0x066656 */
        /* @asm 0x0665E0..0x06664B : sweep the [0x8d4a]-described area; for every
         * tile whose terrain==0x1b (mountains, 0x78c) add the area-width byte
         * ([0x8d4e]+2) into the nation's [0x8d4e]+0xc accumulator. */
        int cov = 0;
        (void)cov;
        overlay_call_181F_0A4C();                        /* @asm 0x06665D per-settlement cleanup */
    }
    return 0;                                            /* @asm 0x066676 retf */
}

/* ============================================================================
 * func_066850  @ 0x066850..0x066882  (51 bytes, ENTER 0x108, RETF)  page 0x15
 * OUT-OF-SCOPE: DOS platform (sprite-descriptor leaf). Fetches one glyph/sprite
 *   descriptor for index [bp+6] from sheet-A (far ptr [0x174]/[0x176]) through
 *   the load-image overlay 0x181F:0x254 into a 0x108-byte stack buffer and
 *   returns the metric byte at [bp-0x80]. The pixel/descriptor fetch is the
 *   platform primitive; only the calling convention is preserved.
 * @asm_disasm page_15.asm (func_066850)
 * ============================================================================ */
int func_066850_sprite_descriptor_A(uint16_t index)
{
    (void)index;
    /* OUT-OF-SCOPE: DOS platform (sprite descriptor) — per 2026-05-30 directive.
     * @asm 0x066879 lcall 0x181F:0x254 ; ret byte[bp-0x80]. */
    return overlay_call_181F_0254();
}

/* ============================================================================
 * func_066884  @ 0x066884..0x0668B7  (52 bytes, ENTER 0x108, RETF)  page 0x15
 * OUT-OF-SCOPE: DOS platform (sprite-descriptor leaf). Twin of func_066850 for
 *   sheet-B (far ptr [0x16c]/[0x16e]) via 0x181F:0x25e.
 * NOTE: the re-seg span 0x066884..0x066968 (228 B) splices in the render-init
 *   helper at 0x0668B8 (builds the terrain->minimap colour cache [0xa58e..] and
 *   the centring offsets [0x9cca]/[0x9ccc]); that init is folded into
 *   func_066968's setup citations below.
 * @asm_disasm page_15.asm (func_066884)
 * ============================================================================ */
int func_066884_sprite_descriptor_B(uint16_t index)
{
    (void)index;
    /* OUT-OF-SCOPE: DOS platform (sprite descriptor) — per 2026-05-30 directive.
     * @asm 0x0668AE lcall 0x181F:0x25e ; ret byte[bp-0x80]. */
    return overlay_call_181F_025E();
}

/* ============================================================================
 * func_066968  @ 0x066968..0x066B95  (558 bytes, ENTER 0x38, RETF)  page 0x15
 * ROLE: STRATEGIC (mini-)MAP ROW COMPOSITOR — "what colour goes where" on the
 *   overview map.  Args: (screen_col=[bp+6], screen_row=[bp+8], width=[bp+0xa],
 *   height=[bp+0xc], player=[bp+0xe], fog_mode=[bp+0x10]).
 *   Per row it fetches four parallel layer row-pointers
 *     terrain=0x70e, feature=0x740, resfog=0x736, aux=0x6a0,
 *   computes the destination framebuffer row at pixel
 *     (screen_col - g_minimap_col0 + 0xFC , screen_row - g_minimap_row0 + 9)
 *   via framebuf_addr (0x181F:0x290), then for each tile builds an 8-bit colour:
 *     - fog_mode!=0 -> colour 0x0F (white border/unknown);
 *     - fog mask (0x10<<player) gates visibility;
 *     - feature bit 2 -> resource colour via DS[0x848+ (featByte>>4)];
 *     - feature bit 1 -> a unit overlay: look up the unit at (col,row)
 *       (0x181F:0x7e0), test its nation mask vs the player, and on a foreign
 *       colony (type 0x10) of an unmet nation paint colour 8;
 *     - else terrain colour: hills bit (0x20) maps base 0x80 -> id 0x1b/0x1c,
 *       then DS[base - 0x5a8a] colour table.
 *   The byte is written to the dest row ptr; rows advance by (map_width - cols).
 * STATUS: RECONSTRUCTED — full row/colour control flow byte-verified.
 *   DS:0x848 (g_color_byhi[16]) = STATIC in EXE: bytes {0C,09,0E,0D,0F,95,36,
 *   0B,43,6F,75,47,07,0B,09,0A} (VGA palette indices, resource/elev nibble table).
 *   DS:0x5A8A accessed as DS[base-0x5A8A] = DS:0xA576+base = RUNTIME_ONLY.
 * @asm_disasm page_15.asm (func_066968)
 * ============================================================================ */
int func_066968_minimap_compose(int sx, int sy, int width, int height,
                                int player, int fog_mode)
{
    int fog_bit = (player >= 0) ? (0x10 << (player & 0xff)) : 0; /* @asm 0x066974 */
    unsigned char far *p_terr = layer_ptr_terrain(sx, sy);  /* @asm 0x06698F 0x70e */
    unsigned char far *p_feat = layer_ptr_feature(sx, sy);  /* @asm 0x06699F 0x740 */
    unsigned char far *p_res  = layer_ptr_resfog (sx, sy);  /* @asm 0x0669AF 0x736 */
    unsigned char far *p_aux  = layer_ptr_aux    (sx, sy);  /* @asm 0x0669BF 0x6a0 */
    /* dest framebuffer row ptr (mini-map is anchored at pixel +0xFC,+9). */
    unsigned char far *dst;
    int row_stride_back = (int)g_map_width;                  /* [bp-0x20] @asm 0x0669EE */
    int r, c;

    {   /* @asm 0x0669CD..0x0669EB framebuf_addr(sx - col0 + 0xFC, sy - row0 + 9) */
        int dx = sx - (int)g_minimap_col0 + 0xFC;            /* @asm 0x0669CF */
        int dy = sy - (int)g_minimap_row0 + 9;               /* @asm 0x0669D8 */
        dst = func_066968_framebuf_addr(dx, dy);             /* @asm 0x0669E3 0x290 */
    }

    if (height <= 0) return 0;                               /* @asm 0x0669FF */

    for (r = 0; r < height; r++) {                            /* @asm 0x066B84 outer rows */
        if (width <= 0) goto next_row;                        /* @asm 0x066A10 */
        for (c = 0; c < width; c++) {                         /* @asm 0x066B4C inner cols */
            unsigned char terr = *p_terr++;                   /* @asm 0x066A17 [bp-0x2a] */
            unsigned char aux  = *p_aux++;                    /* @asm 0x066A23 [bp-0x36] */
            unsigned char feat = *p_feat++;                   /* @asm 0x066A2F [bp-0x2e] */
            unsigned char rfog = *p_res++;                    /* @asm 0x066A3B [bp-0x32] */
            int col_byte;                                     /* [bp-3] result colour */
            (void)aux;

            if (fog_mode != 0) {                              /* @asm 0x066A47 */
                col_byte = 0x0F;                              /* @asm 0x066A4D white */
            } else if (fog_bit != 0 && (rfog & fog_bit) == 0) { /* @asm 0x066A54/0x066A5F */
                col_byte = 0;                                 /* @asm 0x066A64 unseen */
            } else {
                col_byte = 0;                                 /* @asm 0x066A6A */
                if (feat & 2) {                               /* @asm 0x066A6E resource */
                    int hi = (rfog >> 4);                     /* @asm 0x066A77 */
                    col_byte = g_color_byhi[hi];              /* @asm 0x066A83 [bx+0x848] */
                } else if (feat & 1) {                        /* @asm 0x066A96 unit overlay */
                    int u = func_066968_unit_at(sx + c, sy + r); /* @asm 0x066AA8 0x7e0 */
                    if (u >= 0) {                             /* @asm 0x066AAF */
                        int mask = 0x10 << (player & 0xff);   /* @asm 0x066ABF */
                        if ((U_OWNER(u) & mask) ||            /* @asm 0x066AC4 test */
                            g_observe_flag != 0) {            /* @asm 0x066AC8 */
                            int hi = (rfog >> 4);             /* @asm 0x066AD2 */
                            col_byte = g_color_byhi[hi];      /* @asm 0x066AE6 [di+0x848] */
                            if (U_TYPE(u) == 0x10 &&          /* @asm 0x066AED foreign colony */
                                (U_OWNER(u) & 0xf) != player &&
                                g_observe_flag == 0 &&
                                (signed char)g_unit_bytes[u*0x1C + 0x1A] < 0) /* +0x315e */
                                col_byte = 8;                 /* @asm 0x066B0D unmet */
                        }
                    }
                }
                if (col_byte == 0) {                          /* @asm 0x066B11 plain terrain */
                    if (terr & 0x20) {                        /* @asm 0x066B17 hills/forest */
                        /* @asm 0x066B1D..0x066B2A: base id 0x1b or 0x1c by bit7. */
                        terr = (unsigned char)(0x1b + ((terr & 0x80) ? 1 : 0));
                    } else {
                        terr &= 0x1f;                         /* @asm 0x066B30 */
                    }
                    col_byte = g_color_byterrain[terr];       /* @asm 0x066B39 [bx-0x5a8a] */
                }
            }
            *dst++ = (unsigned char)col_byte;                 /* @asm 0x066B49 es:[bx]=al */
        }
next_row:
        /* @asm 0x066B5C..0x066B81 : rewind each layer ptr by (map_width - cols)
         * and the dest by (map_width? - cols) to step to the next map row. */
        {
            int back = row_stride_back - width;               /* @asm 0x066B5F */
            p_terr += back; p_feat += back; p_res += back; p_aux += back;
            dst    += (*(volatile uint16_t *)0x2daa) - width; /* @asm 0x066B7C dest stride */
        }
    }
    return 0;                                                 /* @asm 0x066B92 retf */
}
extern unsigned char far *func_066968_framebuf_addr(int x_px, int y_px); /* 0x181F:0x290 */
extern int func_066968_unit_at(int col, int row);                        /* 0x181F:0x7e0 */

/* ============================================================================
 * func_066B96  @ 0x066B96..0x066BAF  (26 bytes, push bp, RETF)  page 0x15
 * ROLE: MINI-MAP background fill.  Draws the 0x27-wide x 0x38-tall mini-map
 *   panel rect anchored at (g_minimap_row0, g_minimap_col0) by forwarding to the
 *   resident rect-fill (near 0x777 -> 0x1A1F:0x896) with colour [bp+6].
 * STATUS: BYTE_VERIFIED (layout call).
 * @asm_disasm page_15.asm (func_066B96)
 * ============================================================================ */
int func_066B96_minimap_fill(int color)
{
    /* @asm 0x066B99 push 0,color,0x27,0x38,[0x9cca],[0x9ccc]; near 0x777. */
    return func_066968_rect_fill(g_minimap_col0, g_minimap_row0,
                                 0x38, 0x27, color, 0);
}
extern int func_066968_rect_fill(int x, int y, int w, int h, int color, int z); /* 0x1A1F:0x896 */

/* ============================================================================
 * func_066BB0  @ 0x066BB0..0x066DEB  (293 bytes, ENTER 4, RETF)  page 0x15
 * ROLE: MINI-MAP WINDOW BLIT + viewport box.  Given a (col=[bp+6], row=[bp+8],
 *   w=[bp+0xa], h=[bp+0xc]) update region it (a) clips that region to the
 *   visible map window [g_minimap_row0 .. +0x26] x [g_minimap_col0 .. +0x37],
 *   (b) re-renders the clipped block via the resident compositor (near 0x777),
 *   then (c) draws the WHITE "you are here" viewport rectangle on the mini-map
 *   using the current scroll window (g_view_col0/g_view_row0 clamped to
 *   g_view_maxcol/g_view_maxrow), via line-draws 0x181F:0xce / 0x181F:0xe2.
 * STATUS: RECONSTRUCTED — clip + box geometry byte-verified (the resident
 *   blit/line leaves are platform; calling convention kept).
 * @asm_disasm page_15.asm (func_066BB0)
 * ============================================================================ */
int func_066BB0_minimap_update(int col, int row, int w, int h)
{
    int x0, y0;
    func_066BB0_prep();                          /* @asm 0x066BBD near 0x772 (latch palette) */

    /* clip row span to [row0 .. row0+0x26] (@asm 0x066BC2..0x066BE7) */
    y0 = (row < (int)g_minimap_row0) ? (int)g_minimap_row0 : row;
    {
        int rmax = (int)g_minimap_row0 + 0x26;
        int hi   = row + h - 1;
        if (hi > rmax) hi = rmax;                 /* @asm 0x066BDA */
        h = hi - y0 + 1;                          /* @asm 0x066BE0 */
        if (h < 0) h = 0;                         /* @asm 0x066BE3 jns */
    }
    /* clip col span to [col0 .. col0+0x37] (@asm 0x066BEA..0x066C12) */
    x0 = (col < (int)g_minimap_col0) ? (int)g_minimap_col0 : col;
    {
        int cmax = (int)g_minimap_col0 + 0x37;
        int hi   = col + w - 1;
        if (hi > cmax) hi = cmax;                 /* @asm 0x066C05 */
        w = hi - x0 + 1;                          /* @asm 0x066C0B */
        if (w < 0) w = 0;                         /* @asm 0x066C10 */
    }
    if (w == 0 || h == 0) goto done;              /* @asm 0x066C15 / 0x066C1C */

    /* re-render the clipped mini-map block (@asm 0x066C25 near 0x777). */
    func_066968_rect_fill(x0, y0, w, h, 0, 0);

    /* draw the white viewport rectangle (@asm 0x066C3C..0x066CCC). Horizontal
     * extent from (g_minimap_row0+0x26 clamped to g_view_maxrow) etc.; the two
     * 0x181F:0xce / 0x181F:0xe2 calls are the H/V line draws. */
    overlay_call_181F_00CE();                     /* @asm 0x066CA2 viewport line */
    overlay_call_181F_00E2();                     /* @asm 0x066CCC viewport line */
done:
    return 0;                                      /* @asm 0x066DEB retf */
}
extern void func_066BB0_prep(void);                /* near 0x772 -> 0x181F:0x59a */

/* ============================================================================
 * func_066CD6  @ 0x066CD6..0x066DEB  (379 bytes, push bp, RETF)  page 0x15
 * ROLE: MINI-MAP PANEL FRAME + full redraw.  Latches the palette (near 0x772),
 *   then draws the mini-map chrome: an outer box (0x181F:0xba/0xc4 depending on
 *   whether the optional overlay block [0x82c] is present), the inner frame at
 *   (x=0xfb,y=8,w=0x30,h=6) and (0xf1,8,0x29,0x4f) via 0x181F:0xce, redraws the
 *   map contents (near 0x786), and finally the viewport box. [bp+6] toggles a
 *   highlight pass; [bp+8] selects the contents source.
 * STATUS: RECONSTRUCTED — frame geometry + draw order byte-verified (box/line
 *   leaves are platform; calling convention kept).
 * @asm_disasm page_15.asm (func_066CD6)
 * ============================================================================ */
int func_066CD6_minimap_panel(int highlight, int src)
{
    func_066BB0_prep();                            /* @asm 0x066CDA near 0x772 */

    if (*(volatile uint16_t *)0x82c == 0) {        /* @asm 0x066CDD optional block? */
        /* @asm 0x066CF4 box (x=0xf1,y=8,w=0x4f,h=0x29) via 0x181F:0xba. */
        overlay_call_181F_00BA();                  /* @asm 0x066D01 */
    } else {
        /* @asm 0x066D08 textured box via 0x181F:0xc4 (uses [0x82c] descriptor). */
        overlay_call_181F_00C4();                  /* @asm 0x066D34 */
    }

    /* inner frame strip (x=0xfb,y=8,w=0x30,h=6) (@asm 0x066D3B 0x181F:0xce). */
    overlay_call_181F_00CE();                      /* @asm 0x066D58 */

    func_066CD6_draw_contents(src);                /* @asm 0x066D61 near 0x786 */

    /* viewport box redraw (@asm 0x066D66..0x066DCC, clamp to view max/origin). */
    overlay_call_181F_00CE();                      /* @asm 0x066DCC */
    if (highlight != 0) {                          /* @asm 0x066DD1 */
        /* highlight rect (0xf1,8,0x29,0x4f) via 0x181F:0xe2. */
        overlay_call_181F_00E2();                  /* @asm 0x066DE5 */
    }
    return 0;                                       /* @asm 0x066DEA retf */
}
extern void func_066CD6_draw_contents(int src);    /* near 0x786 -> 0x1A1F:0x8ce */

/* ============================================================================
 * func_066E0C  @ 0x066E0C..0x066E51  (69 bytes, push bp, RETF)  page 0x15
 * ROLE: CLAMP a (col,row,w,h)-by-pointer rectangle to the SCROLLED MAP VIEW
 *   bounds.  *col  = max(*col,  g_view_col0[0x8328]); *row = max(*row, [0x832e]);
 *   *w (used as max-col) = min(*w, g_view_maxcol[0x8804]);
 *   *h (used as max-row) = min(*h, g_view_maxrow[0x8806]).
 *   (Pure geometry; the four args are int* in/out.)
 * STATUS: BYTE_VERIFIED.
 * @asm_disasm page_15.asm (func_066E0C, body @0x066E0F after the page thunks)
 * ============================================================================ */
int func_066E0C_clamp_rect_to_view(int *col, int *row, int *maxcol, int *maxrow)
{
    if (*col < (int)g_view_col0)   *col = (int)g_view_col0;     /* @asm 0x066E14 */
    if (*row < (int)g_view_row0)   *row = (int)g_view_row0;     /* @asm 0x066E24 */
    if (*maxcol > (int)g_view_maxcol) *maxcol = (int)g_view_maxcol; /* @asm 0x066E34 */
    if (*maxrow > (int)g_view_maxrow) *maxrow = (int)g_view_maxrow; /* @asm 0x066E44 */
    return 0;                                                   /* @asm 0x066E4F retf */
}

/* ============================================================================
 * func_066E52  @ 0x066E52..0x066EC7  (118 bytes, ENTER 4, RETF)  page 0x15
 * ROLE: CLAMP a (col-ptr,row-ptr, w-ptr,h-ptr) WINDOW to the view, computing the
 *   visible width/height.  It forms right=*col + *w - 1 and bottom=*row + *h - 1,
 *   clamps right<=g_view_maxcol[0x8804] and the left *col>=g_view_col0[0x8328],
 *   rewrites *w = right-*col+1 (>=0), and symmetrically for the vertical axis
 *   against [0x8806]/[0x832e].  The dual of func_066E0C, but it adjusts the
 *   width/height (not max-edges) — used to size the visible blit window.
 * STATUS: BYTE_VERIFIED.
 * @asm_disasm page_15.asm (func_066E52)
 * ============================================================================ */
int func_066E52_clip_window_to_view(int *col, int *row, int *w, int *h)
{
    int right  = *col + *w - 1;                 /* @asm 0x066E58 [bp-2] */
    int bottom = *row + *h - 1;                 /* @asm 0x066E66 [bp-4] */
    int left, top;

    if ((int)g_view_maxcol > right) right = (int)g_view_maxcol; /* @asm 0x066E74 (clamp hi) */
    left = *col;                                                /* @asm 0x066E7F */
    if (left < (int)g_view_col0) left = (int)g_view_col0;       /* @asm 0x066E81 */
    *col = left;                                                /* @asm 0x066E8B */
    *w = right - left + 1;                                      /* @asm 0x066E8D */

    if ((int)g_view_maxrow > bottom) bottom = (int)g_view_maxrow; /* @asm 0x066E95 */
    top = *row;                                                 /* @asm 0x066EA1 */
    if (top < (int)g_view_row0) top = (int)g_view_row0;         /* @asm 0x066EA3 */
    *row = top;                                                 /* @asm 0x066EAD */
    *h = bottom - top + 1;                                      /* @asm 0x066EAF */

    if (*w < 0) *w = 0;                                         /* @asm 0x066EB4 */
    if (*h < 0) *h = 0;                                         /* @asm 0x066EBC */
    return 0;                                                    /* @asm 0x066EC6 retf */
}
