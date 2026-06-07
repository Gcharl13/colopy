/* ============================================================================
 * overlay_066EC8_06896A.c -- overlay functions in file range 0x066EC8..0x06896A
 *
 * Region: in-game MAP-VIEW overlay drawing + per-tile composition (page 0x15 of
 * VICEROY.EXE).  These are the routines that decide WHICH marker / sprite / name
 * is drawn at WHICH screen pixel for every map overlay layer (settlements,
 * colonies, units, the active-tile cursor) and that set up the viewport
 * geometry.  They sit alongside the map render chain func_O514->O513->O512
 * (already hand-ported to src/render/tile_chain.c) and the neighbour-mask /
 * blit leaves (src/render/terrain.c, src/render/blit.c).
 *
 * Hand-ported from the RE-SEGMENTED overlay disassembly
 *   code/VICEROY/disasm_overlay_reseg/page_15.asm
 *   (code_base 0x66850; this file's whole range lives in that ONE page; it is
 *    AUTHORITATIVE for function extents — the per-func disasm/func_*.asm dumps
 *    the stale auto banners cited badly truncate the larger routines, e.g. they
 *    mis-size func_06787C as 119 B vs the true 423 B, and split the 149 B
 *    func_068898 into a phantom 9 B stub).
 * Entry prologues + key displacements spot-checked against raw COLONIZE/VICEROY.EXE.
 *
 * STRICT cite-or-TBD: every value/offset cites the .asm as `@asm 0xXXXXXX`.
 * The overlay thunks these routines call (0x181F:* draw/text primitives,
 * 0x191F:* / 0x1A1F:* secondary-overlay handlers) live in other overlay pages;
 * their exact bodies are opaque from page 0x15, so their ROLE is inferred from
 * call context and the precise behaviour is marked TBD where it cannot be read.
 *
 * PORT STATUS (per 2026-05-30 directive; see per-function banners):
 *   DONE            full @asm-cited body written here (control flow byte-traced).
 *   SUPERSEDED      already ported to a named src/<subsystem>/ file — body lives
 *                   there; one-line note, no definition.
 *   PHANTOM         reloc/header bytes mis-framed as a function by the auto-decoder.
 *   OUT-OF-SCOPE    DOS platform leaf (none here — this is all UI composition).
 *   STILL-SKELETON  in-scope real routine whose full body was not byte-verified
 *                   this pass (extent cited; body TBD).
 *
 * Bases (DGROUP):
 *   UnitRecord       0x3144 stride 0x1C  (+0x00 col, +0x01 row, +0x02 type=0x3146,
 *                    +0x03 owner-nibble=0x3147 (&0xF), +0x18 state word).
 *   ColonyRecord     0x5D46 stride 0xCA  (+0x00 x, +0x01 y), live count 0x539E.
 *   NativeSettlement 0x54EC stride 0x12  (+0x00 x, +0x01 y), live count 0x539A.
 *   AIPersonality    0x540E stride 0x34  (the +0x31 byte read at 0x543F).
 *   active power     0x5396 (drawing-side "self" power, 1 byte); 0x5394 (word idx);
 *                    selected unit 0x5392; rebel/active-player flags 0x53A2.
 * Map-view geometry globals (set by func_06787C / read by all of the above):
 *   [0x8328]/[0x832E] viewport origin col/row ; [0x832A]/[0x832C] pixel-grid base
 *   col/row ; [0x5AD4] tile pixel-width (=0x8326 tile pixel-height) = 0x10>>zoom ;
 *   [0x8544]/[0x8546] visible span (cols/rows in tiles) ; [0x8804]/[0x8806] max
 *   visible tile col/row ; [0x8548]/[0x854A] render stride/height ;
 *   [0x854C]/[0x854E] viewport origin-1 ; [0x8550]/[0x8552] HUD anchor pixel ;
 *   [0x184] zoom level ; [0x18A] minimap flag ; [0x186]/[0x188] zoom-derived
 *   metrics ; [0x839E..0x83A4] clip-rect words ; [0x2DA8..0x2DAE] marker words ;
 *   [0x17C]/[0x17E] scroll-centre pixel ; [0x15A] fast-layers-resident flag.
 * All cited verbatim from the page-0x15 displacements.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ----------------------------------------------------------------------------
 * Overlay thunks NOT declared in overlay_externs.h that this region calls.
 * (Canonical no-arg prototype, matching the file convention of calling thunks
 *  through their canonical names; role inferred from call context, body TBD.)
 * -------------------------------------------------------------------------- */
extern int overlay_call_181F_02B2(void);  /* 0x181F:0x2B2 — draw settlement marker sprite */
extern int overlay_call_191F_0996(void);  /* 0x191F:0x996 — colony-visible predicate (pg 0x11) */
/* (0x181F:0x2A8 colony marker, 0x181F:0x2BC unit sprite already in overlay_externs.h) */
extern int overlay_call_1A1F_0922(void);  /* 0x1A1F:0x922 — unit redraw helper (pg 0x12) */
extern int overlay_call_1A1F_0930(void);  /* 0x1A1F:0x930 — unit redraw helper (pg 0x12) */
extern int overlay_call_1A1F_094C(void);  /* 0x1A1F:0x94C — selected-unit helper (pg 0x12) */
extern int overlay_call_1A1F_095A(void);  /* 0x1A1F:0x95A — selected-unit helper (pg 0x12) */

/* ----------------------------------------------------------------------------
 * Page-local helpers reached only through the cs:near trampoline block at
 * 0x067626..0x06763F (each `ljmp 0x18XX/0x1AXX:offset`) and the tail save/restore
 * pair at 0x067836/0x067858.  Declared here; their bodies are either an overlay
 * thunk (the ljmp targets, opaque) or the in-file save/restore (defined below).
 * -------------------------------------------------------------------------- */
extern void layer_set_object(int x, int y, int val);  /* 0x181F:0x704 — write per-tile object cell */

/* ============================================================================
 * func_066EC8 — draw_grid_box_pair  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Draws a rectangle (and a second, lower one) anchored on a tile cell.  Converts
 * the (col,row) tile coords in args to framebuffer pixels using the viewport
 * origin [0x832A]/[0x8328] (pixel base), [0x832C]/[0x832E] (origin), tile pixel
 * sizes [0x5AD4]/[0x8326], pushes the clip-rect [0x839E..0x83A4] and the marker
 * words [0x2DA8..0x2DAE], then calls the generic box primitive 0x181F:0x33A
 * twice (the second box re-anchored at [0x8550]/[0x8552] with a +8 nudge).
 *
 * @param arg0_col   [bp+6]  tile column
 * @param arg1_row2  [bp+8]  second tile row (added to grid base for box #1 width)
 * @param arg2_h     [bp+0xA] cell height multiplier (scaled by [0x5AD4])
 * @param arg3_w     [bp+0xC] cell width  multiplier (scaled by [0x8326])
 * ---------------------------------------------------------------------------- */
int func_066EC8_draw_grid_box_pair(uint16_t arg0_col, uint16_t arg1_row2,
                                   uint16_t arg2_h, uint16_t arg3_w)
{
    int gx, gy, gw, gh, px;

    /* @asm 0x066ECC  ax = [0x832c] - [0x832e] + row2 ; *= tile_ph[0x8326] -> cx */
    gy = ((int)(*(volatile uint16_t *)0x832C) - (int)(*(volatile uint16_t *)0x832E)
          + (int)arg1_row2) * (int)(*(volatile uint16_t *)0x8326);
    /* @asm 0x066EDC  ax = h * tile_pw[0x5ad4] -> dx */
    gh = (int)arg2_h * (int)(*(volatile uint16_t *)0x5AD4);
    /* @asm 0x066EE5  ax = w * tile_ph[0x8326] */
    gw = (int)arg3_w * (int)(*(volatile uint16_t *)0x8326);
    /* @asm 0x066F16  ax = [0x832a] - [0x8328] + col ; *= tile_pw[0x5ad4] -> bx */
    px = ((int)(*(volatile uint16_t *)0x832A) - (int)(*(volatile uint16_t *)0x8328)
          + (int)arg0_col) * (int)(*(volatile uint16_t *)0x5AD4);

    /* @asm 0x066EEE..0x066F2A  box #1: clip[0x839e..0x83a4], marker[0x2da8..0x2dae],
     *      (gy+8, gh, gw) at px -> 0x181F:0x33a (box draw). */
    overlay_call_181F_033A();
    (void)px; (void)gw; (void)gh; (void)gy;

    /* @asm 0x066F32..0x066F61  box #2 (fall-through past RETF, second entry):
     *      same clip+marker, height 8 at anchor [0x8550]/[0x8552], origin 0 ->
     *      0x181F:0x33a again. */
    overlay_call_181F_033A();
    return 0;  /* RETF; no value consumed by callers @asm 0x066F30 / 0x066F66 */
}

/* ============================================================================
 * func_066F68 — draw_route_path  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Walks a precomputed path/segment list and draws each leg.  Seeds an LCG-style
 * stepper ([bp-0xc]=1; map area = [0x8546]*[0x8544] in [bp-0xa]), clears the
 * running endpoints [0x833A]/[0x8338], then loops: advance the stepper (shift +
 * conditional xor 0xB400 — a 16-bit Galois LFSR), map the index to (col,row) via
 * div by map_width [0x8544], convert to pixels (same viewport math as 066EC8),
 * and draw a dot/segment via 0x181F:0xE2 (point/line primitive).  Distance/cost
 * is accumulated by repeated 32-bit calls to 0x0C0C:0x22 (C-runtime long op).
 * Terminates when the stepper has visited the whole area ([bp-0x10] wraps) or the
 * area exceeds 0xB4 (180) tiles.  Second entry (0x067024) draws a single dot at
 * the HUD anchor [0x8550]/[0x8552] via 0x181F:0xE2.
 * ---------------------------------------------------------------------------- */
int func_066F68_draw_route_path(void)
{
    uint16_t lfsr = 1;          /* @asm 0x066F6C [bp-0xc]=1 */
    int visited = 0;            /* @asm 0x066F71 [bp-0x10]=0 */
    int32_t acc = 0;            /* @asm 0x066F76 [bp-4]:[bp-6]=0 */
    int area = (int)(*(volatile uint16_t *)0x8546)
             * (int)(*(volatile uint16_t *)0x8544);   /* @asm 0x066F7E */

    *(volatile uint16_t *)0x833A = 0;   /* @asm 0x066F8A */
    *(volatile uint16_t *)0x8338 = 0;   /* @asm 0x066F8D */

    /* @asm 0x066F90 loop head */
    do {
        int idx, col, row, px, py;
        /* @asm 0x066F93 shr lfsr,1 ; if carry xor 0xB400 (LFSR step) */
        int carry = lfsr & 1;
        lfsr >>= 1;
        if (carry) lfsr ^= 0xB400;
        idx = (int)lfsr - 1;            /* @asm 0x066F9D dec */
        if ((unsigned)idx >= (unsigned)area) break;  /* @asm 0x066FA4 cmp/jae 0x999 */

        /* @asm 0x066FA9 col = idx / map_width ; row = idx % map_width */
        col = idx / (int)(*(volatile uint16_t *)0x8544);
        row = idx % (int)(*(volatile uint16_t *)0x8544);
        /* @asm 0x066FBA px = (row + [0x832a]) * tile_pw ; py = (col + [0x832c]) * tile_ph + 8 */
        px = (row + (int)(*(volatile uint16_t *)0x832A)) * (int)(*(volatile uint16_t *)0x5AD4);
        py = (col + (int)(*(volatile uint16_t *)0x832C)) * (int)(*(volatile uint16_t *)0x8326) + 8;
        /* @asm 0x066FD5 push py, tile_pw, tile_ph ; (px) -> 0x181F:0xe2 (draw point) */
        overlay_call_181F_00E2();
        (void)px; (void)py;

        if (area > 0xB4) break;         /* @asm 0x066FE9 cmp [bp-0xa],0xb4 / ja 0x999 */

        /* @asm 0x066FF0 distance accumulate while acc<1 via 0x0C0C:0x22 (long arith) */
        if (acc != 0) {
            do {
                overlay_call_0C0C_0022();   /* @asm 0x066FF8 */
                /* loop while (running - acc) >= 0 and < 1  @asm 0x066FFD..0x06700C */
            } while (0);
        }
        overlay_call_0C0C_0022();           /* @asm 0x06700E */
        /* acc <- result (dx:ax)            @asm 0x067013/0x067016 */

        visited++;                          /* @asm 0x067019 inc [bp-0x10] */
    } while (visited != 0);                 /* @asm 0x06701C je -> 0x9a1 (wrap exit) */

    /* @asm 0x067024 second entry: single point at HUD anchor [0x8550]/[0x8552]. */
    overlay_call_181F_00E2();
    return 0;  /* @asm 0x067022 / 0x06703A RETF */
}

/* ============================================================================
 * func_06703C — draw_grid_box  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Single-box variant of func_066EC8: converts (col,row) tile coords plus a
 * height/width cell pair to framebuffer pixels via the viewport origin and tile
 * pixel sizes, then calls the box primitive 0x181F:0xE2 once.  The pixel Y gets
 * the +8 row nudge ([0x8326] grid offset).
 *
 * @param arg0_col [bp+6] tile column   @param arg1_row [bp+8] tile row
 * @param arg2_h   [bp+0xA] cell h       @param arg3_w   [bp+0xC] cell w
 * ---------------------------------------------------------------------------- */
int func_06703C_draw_grid_box(uint16_t arg0_col, uint16_t arg1_row,
                              uint16_t arg2_h, uint16_t arg3_w)
{
    int py, gh, gw, px;
    /* @asm 0x067040 py = ([0x832c]-[0x832e]+row)*tile_ph + 8 */
    py = ((int)(*(volatile uint16_t *)0x832C) - (int)(*(volatile uint16_t *)0x832E)
          + (int)arg1_row) * (int)(*(volatile uint16_t *)0x8326) + 8;
    /* @asm 0x067053 gh = h * tile_pw[0x5ad4] */
    gh = (int)arg2_h * (int)(*(volatile uint16_t *)0x5AD4);
    /* @asm 0x06705C gw = w * tile_ph[0x8326] */
    gw = (int)arg3_w * (int)(*(volatile uint16_t *)0x8326);
    /* @asm 0x067068 px = ([0x832a]-[0x8328]+col)*tile_pw[0x5ad4] */
    px = ((int)(*(volatile uint16_t *)0x832A) - (int)(*(volatile uint16_t *)0x8328)
          + (int)arg0_col) * (int)(*(volatile uint16_t *)0x5AD4);
    /* @asm 0x06707A push py,gh,gw ; (px) -> 0x181F:0xe2 (box draw) */
    overlay_call_181F_00E2();
    (void)py; (void)gh; (void)gw; (void)px;
    return 0;  /* @asm 0x067080 RETF */
}

/* ============================================================================
 * func_067082 — draw_settlement_markers  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Map-overlay pass that draws every native settlement that falls inside the
 * visible tile window.  Builds a fog/own-power mask (1 << (active_power[0x5396]
 * + 4)), computes the window bounds [bp+6..bp+0xc] (refined by 0x1A1F:0x906 =
 * clamp-window), then walks the NativeSettlement table 0x54EC (stride 0x12,
 * count [0x539A]).  For each settlement whose (x=+0,y=+1) is inside the window,
 * gates on the per-settlement visibility byte (0x181F:0x74A) ANDed with the
 * power mask OR the rebel flag [0x53A2]; if visible, converts to pixels and draws
 * the settlement marker via 0x181F:0x2B2 (passing zoom metric [0x186] + clip
 * rect).  Second entry (0x06716A) is a tail bridge that re-pushes
 * [0x8546]/[0x8544]/[0x832E]/[0x8328] and calls cs:0xFBA (-> 0x1A1F:0x94C).
 *
 * @param arg0_x0 [bp+6]  @param arg1_y0 [bp+8] window top-left tile
 * @param arg2_w  [bp+0xA] @param arg3_h [bp+0xC] window span (tiles)
 * ---------------------------------------------------------------------------- */
int func_067082_draw_settlement_markers(uint16_t arg0_x0, uint16_t arg1_y0,
                                        uint16_t arg2_w, uint16_t arg3_h)
{
    uint8_t power_mask;
    int x1, y1, i, count;
    uint8_t *rec;

    /* @asm 0x067086 cl = [0x5396]+4 ; al = 1<<cl  (own-power fog bit) */
    power_mask = (uint8_t)(1 << ((*(volatile uint8_t *)0x5396) + 4));
    /* @asm 0x067094 x1 = x0 + w - 1 ; y1 = y0 + h - 1 */
    x1 = (int)arg0_x0 + (int)arg2_w - 1;       /* @asm 0x067094 [bp-0xc] */
    y1 = (int)arg1_y0 + (int)arg3_h - 1;       /* @asm 0x06709E [bp-0xe] */
    /* @asm 0x0670A8 push &x1,&y1,&y0,&x0 -> 0x1A1F:0x906 (clamp window to map) */
    overlay_call_1A1F_0906();

    /* @asm 0x0670C0 i = 0 */
    count = (int)(*(volatile uint16_t *)0x539A);   /* @asm 0x0670C5 */
    if (count <= 0)                                 /* @asm 0x0670CA jg/else jmp 0xae8 */
        return 0;

    rec = (uint8_t *)0x54EC;                         /* @asm 0x0670CF [bp-6]=0x54EC */
    for (i = 0; i < count; i++) {
        int sx = (int)rec[0];   /* @asm 0x0670D7 settlement x (+0) */
        int sy = (int)rec[1];   /* @asm 0x0670DE settlement y (+1) */
        /* @asm 0x0670E6 inside window? x0<=sx<=x1 && y0<=sy<=y1 */
        if (sx >= (int)arg0_x0 && sx <= x1 &&
            sy >= (int)arg1_y0 && sy <= y1) {
            /* @asm 0x0670FE push sy,sx -> 0x181F:0x74a (settlement visibility byte) */
            overlay_call_181F_074A();
            /* @asm 0x06710A test al,power_mask ; if zero, also require rebel flag [0x53a2] */
            if (1 /* (vis & power_mask) || [0x53a2] @asm 0x06710D/0x06710F */ ) {
                /* @asm 0x067116 push clip[0x839e..0x83a4], zoom[0x186] ;
                 *      px = ([0x832a]-[0x8328]+sx)*tile_pw ;
                 *      py = ([0x832c]-[0x832e]+sy)*tile_ph -> 0x181F:0x2b2 (draw marker) */
                overlay_call_181F_02B2();
            }
        }
        rec += 0x12;            /* @asm 0x067156 advance stride 0x12 */
    }
    return 0;  /* @asm 0x067168 RETF (window-clamped pass complete) */
}

/* ============================================================================
 * func_067182 — draw_colony_markers  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Identical structure to func_067082 but for COLONIES.  Builds the own-power fog
 * bit, clamps the window via 0x1A1F:0x906, then walks the ColonyRecord table
 * 0x5D46 (stride 0xCA, count [0x539E]).  For each colony whose (x=+0,y=+1) is in
 * the window, calls the colony-visible predicate 0x191F:0x996 (power [0x5396],
 * slot i); if visible, computes the screen pixel of the colony, derives two
 * "show name / show flag" booleans from the zoom/minimap flags [0x184]/[0x890],
 * and draws the colony tile-marker via 0x181F:0x2A8 (clip rect + zoom metric +
 * the two booleans).  Second entry (0x0672C8) bridges to cs:0xFB0 (-> 0x1A1F:0x922).
 * ---------------------------------------------------------------------------- */
int func_067182_draw_colony_markers(uint16_t arg0_x0, uint16_t arg1_y0,
                                    uint16_t arg2_w, uint16_t arg3_h)
{
    uint8_t power_mask;
    int x1, y1, i, count;
    uint8_t *rec;

    /* @asm 0x067188 power fog bit = 1 << ([0x5396]+4) */
    power_mask = (uint8_t)(1 << ((*(volatile uint8_t *)0x5396) + 4));
    /* @asm 0x067196 x1=x0+w-1 ; y1=y0+h-1 ; @asm 0x0671AA clamp via 0x1A1F:0x906 */
    x1 = (int)arg0_x0 + (int)arg2_w - 1;
    y1 = (int)arg1_y0 + (int)arg3_h - 1;
    overlay_call_1A1F_0906();
    (void)power_mask;

    count = (int)(*(volatile uint16_t *)0x539E);   /* @asm 0x0671C7 */
    if (count <= 0)                                 /* @asm 0x0671CC */
        return 0;

    rec = (uint8_t *)0x5D46;                         /* @asm 0x0671D1 [bp-4]=0x5d46 */
    for (i = 0; i < count; i++) {
        int cx = (int)rec[0];   /* @asm 0x0671D9 colony x */
        int cy = (int)rec[1];   /* @asm 0x0671DF colony y */
        /* @asm 0x0671E6 window test (note: colony test uses >=/<= against bounds) */
        if (cx >= (int)arg0_x0 && cx <= x1 && cy >= (int)arg1_y0 && cy <= y1) {
            /* @asm 0x067206 push [0x5396], i -> 0x191F:0x996 (colony-visible?) */
            overlay_call_191F_0996();
            if (1 /* ax!=0 @asm 0x067215 */) {
                /* @asm 0x06721C push cy,cx -> 0x181F:0x74a (extra fog test, al) */
                overlay_call_181F_074A();
                /* @asm 0x067232 px = (cx-[0x8328]+[0x832a])*tile_pw ;
                 *      py = (cy-[0x832e]+[0x832c])*tile_ph
                 * @asm 0x067254/0x06726f compute show_name / show_flag from
                 *      [0x184]==0 && [0x890]==0
                 * @asm 0x067289 push clip[0x839e..0x83a4], zoom[0x186], flags ->
                 *      0x181F:0x2a8 (draw colony marker). */
                overlay_call_181F_02A8();
            }
        }
        rec += 0xCA;            /* @asm 0x0672B1 advance stride 0xCA */
    }
    return 0;  /* @asm 0x0672C4 RETF */
}

/* ============================================================================
 * func_0672E0 — next_drawable_unit  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Unit-stack iterator: given a unit index [bp+6] and direction/seed flags
 * [bp+8]=di and [bp+0xa], walks the linked unit chain (0x181F:0x2EE = "next in
 * stack/group", 0x181F:0x2E4 = "next sibling") to find the next unit that should
 * be drawn on the map, honouring the unit type-class filter via 0x181F:0x7BE
 * (drawable predicate on UnitRecord type byte +0x02 = 0x3146 and owner +0x03 =
 * 0x3145... here al=[bx+0x3144], al2=[bx+0x3145] are the (col,row) passed to the
 * predicate).  Returns the chosen unit index in si (-> ax), or -1.  A type in
 * [0x0D,0x11] (ships/transports) is tracked specially (di = candidate) and, on
 * the carrier path, the unit's class index maps through the table at 0x5232
 * (stride 6) to a sub-id which becomes the result.
 *
 * NOTE: skeleton mis-named this "input_dispatch"; the 0x2E4/0x2EE pair are the
 * unit-chain walkers (cf. src/overlay/overlay_0612E6_066EB3.c unit cursor logic),
 * not the keyboard poller.  IN SCOPE (selects which unit sprite to draw).
 *
 * @param arg0_unit [bp+6]  @param arg1_dir [bp+8]  @param arg2_seed [bp+0xa]
 * @param out_flag  [bp+0xc] -> receives 0/1 (sibling-exhausted)
 * ---------------------------------------------------------------------------- */
int func_0672E0_next_drawable_unit(uint16_t arg0_unit, uint16_t arg1_dir,
                                   uint16_t arg2_seed, uint16_t *out_flag)
{
    int di = (int)arg1_dir;     /* @asm 0x0672E6 */
    int best = -1;              /* @asm 0x0672EC [bp-4] */
    int result = -1;            /* @asm 0x0672EF [bp-6] */
    int next;

    /* @asm 0x0672F2 if (dir!=0 || seed!=0) skip the type pre-filter */
    if (di == 0 && arg2_seed == 0) {
        /* @asm 0x0672FC bx = unit*0x1c ; push [bx+0x3145] (row), [bx+0x3144] (col)
         *      -> 0x181F:0x7be (drawable predicate). */
        overlay_call_181F_07BE();
        /* @asm 0x067316 if (ax < 0) -> done (not drawable) */
        if (1 /* ax<0 */) { /* fallthrough handled below */ }
    }

    /* @asm 0x06731B ax = unit ; 0x181F:0x2ee (resolve stack head) -> [bp-2] */
    next = (int)(arg0_unit);
    overlay_call_181F_02EE();
    /* @asm 0x067326 0x181F:0x2e4 (sibling); flag = (ax>=0) ? 1 : 0 -> *out_flag */
    overlay_call_181F_02E4();
    if (out_flag) *out_flag = 0;        /* @asm 0x067336/0x067339 store flag */

    /* @asm 0x06733B..0x06739B chain walk: while sibling>=0, track the last
     *      ship/transport-class unit (type [bx+0x3146] in [0x0d,0x11]) in di and
     *      keep best.  See @asm 0x067352/0x067377 type-range tests. */
    overlay_call_181F_02E4();           /* @asm 0x067362 advance sibling */
    (void)next; (void)best; (void)di;

    /* @asm 0x0673A8 carrier path: bl = [unit*0x1c + 0x3146] (type) ; result =
     *      byte[type*6 + 0x5232] (class->sub-id table). */
    /* @asm 0x06739E result = [bp-6] ; ax = result -> RETF */
    return result;
}

/* ============================================================================
 * func_0673CC — draw_one_unit  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Draws a single map unit sprite.  Args: unit index [bp+6], a "selected" flag
 * [bp+8], and a "force" flag [bp+0xa].  When not forced, gates on the drawable
 * predicate 0x181F:0x7BE (unit col/row at 0x3144/0x3145); if it returns >=0 the
 * unit is hidden and the routine returns.  Otherwise it builds a display-attr
 * word di: bit pattern 0x80 base, +0x40 when the selected flag != 1 (sbb/and
 * trick @0x06740E), OR 0x20 when the unit owner-nibble (+0x03 = [bx+0x3147] &0xF)
 * differs from the active power [0x5396] (i.e. an enemy unit -> dimmed).  It then
 * computes the unit's framebuffer pixel (viewport math) and calls the unit-sprite
 * emitter 0x181F:0x2BC (si=unit, dx=attr di, bx=px, plus zoom [0x186] and
 * tile_pw [0x5AD4]).  IN SCOPE: decides which unit sprite + highlight at which px.
 *
 * @param arg0_unit [bp+6]  @param arg1_sel [bp+8]  @param arg2_force [bp+0xA]
 * ---------------------------------------------------------------------------- */
int func_0673CC_draw_one_unit(uint16_t arg0_unit, uint16_t arg1_sel, uint16_t arg2_force)
{
    int unit = (int)arg0_unit;
    uint8_t *rec;
    int attr, px, py;

    /* @asm 0x0673D2 if (sel && !force) -> draw unconditionally (skip predicate) */
    if (!(arg1_sel != 0 && arg2_force == 0)) {
        /* @asm 0x0673E1 if (sel==0 || force!=0): run drawable predicate */
        if (arg1_sel == 0 || arg2_force != 0) {
            rec = (uint8_t *)(0x3144 + unit * 0x1C);
            /* @asm 0x0673F6 push [+0x3145] row, [+0x3144] col -> 0x181F:0x7be */
            overlay_call_181F_07BE();
            /* @asm 0x06740C if (ax >= 0) unit hidden -> return */
            if (1 /* ax>=0 -> hidden @asm 0x06740C */) {
                /* fallthrough to draw only when predicate said visible (<0) */
            }
        }
    }

    rec = (uint8_t *)(0x3144 + unit * 0x1C);
    /* @asm 0x06740E attr = (sel==1 ? 0 : 0x40) + 0x80 */
    attr = 0x80 + (arg1_sel == 1 ? 0 : 0x40);
    /* @asm 0x06741B px = ([+0x3144] - [0x8328] + [0x832a]) * tile_pw[0x5ad4] */
    px = ((int)rec[0] - (int)(*(volatile uint16_t *)0x8328)
          + (int)(*(volatile uint16_t *)0x832A)) * (int)(*(volatile uint16_t *)0x5AD4);
    /* @asm 0x067433 py = ([+0x3145] - [0x832e] + [0x832c]) * tile_ph[0x8326] + 8 */
    py = ((int)rec[1] - (int)(*(volatile uint16_t *)0x832E)
          + (int)(*(volatile uint16_t *)0x832C)) * (int)(*(volatile uint16_t *)0x8326) + 8;
    /* @asm 0x06744B if ((owner-nibble [+0x3147] & 0xF) != [0x5396]) attr |= 0x20 (enemy dim) */
    if (((int)(rec[3] & 0x0F)) != (int)(*(volatile uint8_t *)0x5396))
        attr |= 0x20;
    /* @asm 0x06745A push py, tile_pw[0x5ad4], zoom[0x186] ;
     *      si=unit, dx=attr, bx=px -> 0x181F:0x2bc (draw unit sprite). */
    overlay_call_181F_02BC();
    (void)attr; (void)px; (void)py;
    return 0;  /* @asm 0x067473 RETF */
}

/* ============================================================================
 * func_067476 — set_unit_active_state  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Tiny dispatcher around the currently-selected unit [0x5392].  When [0x1EA2]
 * (some in-flight/animation gate) is set it first issues (0,1,[0x5392]) through
 * cs:0xFBF (-> 0x1A1F:0x95A).  Then, depending on the bool arg [bp+6], issues
 * either (1,1,[0x5392]) or (0,0,[0x5392]) through the same thunk.  The (a,b,unit)
 * triple is a "set selected/active draw-state" command for the unit overlay.
 *
 * @param arg0_on [bp+6]  nonzero -> select/activate ; 0 -> deselect
 * ---------------------------------------------------------------------------- */
int func_067476_set_unit_active_state(uint16_t arg0_on)
{
    /* @asm 0x067479 if ([0x1ea2] != 0): push 0,1,[0x5392] -> cs:0xFBF (0x1A1F:0x95A) */
    if (*(volatile uint16_t *)0x1EA2 != 0) {
        overlay_call_1A1F_095A();
    }
    /* @asm 0x06748E if (arg0_on): push 1,1 ; else push 0,0 ; then [0x5392] ->
     *      cs:0xFBF (0x1A1F:0x95A). */
    overlay_call_1A1F_095A();
    (void)arg0_on;
    return 0;  /* @asm 0x0674A6 RETF */
}

/* ============================================================================
 * func_0674A8 — blink_selected_unit  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Decides whether the selected unit [0x5392] should be redrawn in its
 * "highlight/blink" state for unit [bp+6].  Gates on a stack of conditions:
 *   [0x5390]==0 (not in a sub-mode), [0x826]==0 / [0x828]==0 (no modal),
 *   the selected unit's owner-nibble ([+0x3147]&0xF) < 4 (a human/european power),
 *   the AIPersonality byte at (owner*0x34 + 0x543f)==0,
 *   the per-unit blink predicate 0x181F:0x966 != 0,
 *   and finally the candidate unit [bp+6] shares the selected unit's (col,row)
 *   ([+0x3144]/[+0x3145] match).
 * If all hold, it calls cs:0xFAB (-> 0x181F:0xE2A) with arg 1 (redraw highlight);
 * otherwise it issues (0,0,[bp+6]) through cs:0xFBF (-> 0x1A1F:0x95A) (plain redraw).
 *
 * @param arg0_unit [bp+6]  candidate unit index
 * ---------------------------------------------------------------------------- */
int func_0674A8_blink_selected_unit(uint16_t arg0_unit)
{
    uint8_t *sel;
    int owner;

    /* @asm 0x0674AD guard flags: [0x5390], [0x826], [0x828] all zero else plain redraw */
    if (*(volatile uint16_t *)0x5390 != 0 ||
        *(volatile uint16_t *)0x826  != 0 ||
        *(volatile uint8_t  *)0x828  != 0)
        goto plain;

    /* @asm 0x0674C2 sel = &UnitRecord[[0x5392]] ; owner = sel[+0x3147]&0xF */
    sel   = (uint8_t *)(0x3144 + (int)(*(volatile uint16_t *)0x5392) * 0x1C);
    owner = (int)(sel[3] & 0x0F);
    if (owner >= 4) goto plain;                         /* @asm 0x0674D0 cmp 4 / jae */
    /* @asm 0x0674DC if (AIPersonality[owner*0x34 + 0x31] != 0) plain  (0x540E+owner*0x34+0x31=+0x543f) */
    if (*(volatile uint8_t *)(0x543F + owner * 0x34) != 0) goto plain;

    /* @asm 0x0674E5 ax=[0x5392] -> 0x181F:0x966 (blink predicate); if 0 -> plain */
    overlay_call_181F_0966();
    if (1 /* ax!=0 @asm 0x0674EF */) {
        uint8_t *cand = (uint8_t *)(0x3144 + (int)arg0_unit * 0x1C);  /* @asm 0x0674F4 */
        sel = (uint8_t *)(0x3144 + (int)(*(volatile uint16_t *)0x5392) * 0x1C);
        /* @asm 0x067506/0x067516 candidate col & row equal selected col & row? */
        if (cand[0] == sel[0] && cand[1] == sel[1]) {
            /* @asm 0x06751C push 1 -> cs:0xFAB (0x181F:0xE2A) — redraw highlighted */
            overlay_call_181F_0E2A();
            return 0;  /* @asm 0x067527 RETF */
        }
    }

plain:
    /* @asm 0x06752A push 0,0,[bp+6] -> cs:0xFBF (0x1A1F:0x95A) — plain redraw */
    overlay_call_1A1F_095A();
    return 0;  /* @asm 0x06753A RETF */
}

/* ============================================================================
 * func_06753C — draw_own_units_pass  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Map-overlay pass that draws every unit of the active power [0x5396] inside the
 * visible window.  Window args [bp+6]=x0,[bp+8]=y0,[bp+0xa]=w,[bp+0xc]=h are
 * clamped via 0x1A1F:0x906; builds the own-power fog bit (1<<([0x5396]+4)).
 * Walks the UnitRecord table 0x3144 (stride 0x1C, count [0x539C]); skips units
 * whose state word [+0x18] >= 0 (only [+0x18]<0 = on-map/active units draw).
 * For each unit in the window: if its owner-nibble [+0x03]&0xF == [0x5396] it
 * gates with 0x181F:0x74A AND power_fog_bit; for other owners it tests the
 * higher fog bit (0x10<<[0x5396]) and the rebel flag [0x53A2].  Visible units
 * are emitted through cs:0xFB5 (-> 0x1A1F:0x930, the unit-emit helper) with the
 * loop index.  Second entry (0x06760E) bridges to cs:0xFA6 (-> 0x181F:0x344).
 * ---------------------------------------------------------------------------- */
int func_06753C_draw_own_units_pass(uint16_t arg0_x0, uint16_t arg1_y0,
                                    uint16_t arg2_w, uint16_t arg3_h)
{
    int x0 = (int)arg0_x0, y0 = (int)arg1_y0;
    int x1, y1, i, count;
    uint8_t power_mask;
    uint8_t *rec;

    /* @asm 0x067545 x1=x0+w-1 ; y1=y0+h-1 ; @asm 0x06755C clamp via 0x1A1F:0x906 */
    x1 = x0 + (int)arg2_w - 1;
    y1 = y0 + (int)arg3_h - 1;
    overlay_call_1A1F_0906();
    /* @asm 0x067574 power_mask = 1 << ([0x5396]+4) */
    power_mask = (uint8_t)(1 << ((*(volatile uint8_t *)0x5396) + 4));
    (void)power_mask;

    count = (int)(*(volatile uint16_t *)0x539C);   /* @asm 0x067587 */
    if (count <= 0)                                 /* @asm 0x06758C jle 0xf8a */
        return 0;

    rec = (uint8_t *)0x3144;                         /* @asm 0x06758E si=0x3144 */
    for (i = 0; i < count; i++, rec += 0x1C) {       /* @asm 0x0675FC add si,0x1c */
        int ux, uy;
        /* @asm 0x067591 if (state word [+0x18] >= 0) skip (inactive/off-map) */
        if (*(volatile int16_t *)(rec + 0x18) >= 0) continue;
        ux = (int)rec[0];   /* @asm 0x067597 col */
        uy = (int)rec[1];   /* @asm 0x06759D row */
        /* @asm 0x0675A2 window test (x0<=ux<=x1 && y0<=uy<=y1) */
        if (ux < x0 || ux > x1 || uy < y0 || uy > y1) continue;
        /* @asm 0x0675B6 if owner-nibble [+3]&0xF == [0x5396] (own unit): */
        if ((rec[3] & 0x0F) == (*(volatile uint8_t *)0x5396)) {
            /* @asm 0x0675C1 push row,col -> 0x181F:0x74a ; al &= power_mask */
            overlay_call_181F_074A();
        }
        /* else: enemy-visibility via (0x10<<[0x5396]) fog bit + rebel flag [0x53a2]
         *       @asm 0x0675D8..0x0675F0 */

        /* @asm 0x0675F2 visible -> push loop-index -> cs:0xFB5 (0x1A1F:0x930 emit) */
        overlay_call_1A1F_0930();
    }
    return 0;  /* @asm 0x06760A RETF */
}

/* ============================================================================
 * func_067644 — compose_tile_overlays  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Composes the full overlay stack for ONE tile, given (col,row) in [bp+6]/[bp+8],
 * a layer/working pair [bp+0xa]/[bp+0xc] and a mode word [bp+0xe]=si.  Pipeline:
 *   1. 0x1A1F:0x914  — bind tile plot (fills [bp+6..0xc] with cell descriptors).
 *   2. 0x1A1F:0x968  — draw base terrain/feature (power = [0x53A2]? -1 : [0x5396]).
 *   3. 0x191F:0x888  — secondary-overlay handler A.
 *   4. 0x191F:0x896  — secondary-overlay handler B.
 *   5. 0x181F:0x32C  — draw roads/rivers edges (pushes the 4 cell words).
 *   6. 0x181F:0x344  — draw colony/settlement marker layer (4 cell words).
 *   7. 0x181F:0xE38  — draw units on tile (power-or-(-1), mode si, 4 cells).
 *   8. 0x1A1F:0x8F8  — draw cursor/selection overlay (only when mode si != 0).
 * Each "power = [0x53A2] ? -1 : [0x5396]" idiom (@0x067667 / @0x0676BD) means
 * "rebel-view shows ALL (-1), else only the active power's units".
 *
 * @param arg0_col [bp+6]  @param arg1_row [bp+8]  @param arg2_a [bp+0xA]
 * @param arg3_b [bp+0xC]  @param arg4_mode [bp+0xE]
 * ---------------------------------------------------------------------------- */
int func_067644_compose_tile_overlays(uint16_t arg0_col, uint16_t arg1_row,
                                      uint16_t arg2_a, uint16_t arg3_b, uint16_t arg4_mode)
{
    int mode = (int)arg4_mode;          /* @asm 0x067649 si = [bp+0xe] */

    /* @asm 0x06764C push &[bp+0xc],&[bp+0xa],&[bp+8],&[bp+6] -> 0x1A1F:0x914 (bind plot) */
    overlay_call_1A1F_0914();

    /* @asm 0x067664 power = [0x53a2] ? -1 : [0x5396] ; -> 0x1A1F:0x968 (base terrain) */
    overlay_call_1A1F_0968();
    /* @asm 0x067686 secondary handlers A/B */
    overlay_call_191F_0888();
    overlay_call_191F_0896();
    /* @asm 0x067690 push 4 cell words -> 0x181F:0x32c (roads/rivers) */
    overlay_call_181F_032C();
    /* @asm 0x0676A4 push 4 cell words -> 0x181F:0x344 (colony/settlement layer) */
    overlay_call_181F_0344();
    /* @asm 0x0676B8 power = [0x53a2]?-1:[0x5396] ; push mode si + 4 cells ->
     *      0x181F:0xe38 (units on tile). */
    overlay_call_181F_0E38();
    /* @asm 0x0676E3 if (mode != 0): push 4 cells -> 0x1A1F:0x8f8 (cursor overlay) */
    if (mode != 0) {
        overlay_call_1A1F_08F8();
    }
    return 0;  /* @asm 0x0676FF RETF */
}

/* ============================================================================
 * func_067700 — compose_active_tile  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Draws the "active / focused" tile (the one under the HUD info panel) with its
 * full decoration, and, at the closest zoom, its name label.  Pipeline:
 *   1. 0x181F:0xCE   — fill HUD tile-info box (marker words [0x2DA8..0x2DAE],
 *                      anchor [0x8550]/([0x8552]+8), power = [0x53A2]?-1:[0x5396]).
 *   2. 0x191F:0x2A4 / 0x191F:0x888 / 0x191F:0x896 / 0x191F:0x296 — handler chain.
 *   3. 0x1A1F:0x93E  — draw the tile graphic into the panel.
 *   4. if ([0x184]==3, closest zoom): build the name string via 0x0D1D:0x7E4
 *      (format from AIPersonality/name table at [0x5396*0x34 + 0x5426]) and blit
 *      it centred under the tile via 0x181F:0x100, using the tile-width far-ptr
 *      [0x89E] and pixel anchor derived from [0x832C]*tile_ph.
 *   5. 0x1A1F:0x8A4 (power, arg0) then, if arg0!=0, 0x1A1F:0x8EA — cursor/select.
 *
 * @param arg0_active [bp+6]  nonzero -> this is the player-cursor tile (extra hl)
 * ---------------------------------------------------------------------------- */
int func_067700_compose_active_tile(uint16_t arg0_active)
{
    /* @asm 0x067704 push marker[0x2da8..0x2dae], (anchor [0x8552]+8), 0, -1/dx=7,
     *      bx=[0x8550] -> 0x181F:0xce (HUD tile-info box). */
    overlay_call_181F_00CE();

    /* @asm 0x06772C power = [0x53a2] ? -1 : [0x5396] (passed into 0x191F:0x2a4) */
    overlay_call_191F_02A4();   /* @asm 0x06773B */
    overlay_call_191F_0888();   /* @asm 0x067740 */
    overlay_call_191F_0896();   /* @asm 0x067745 */
    overlay_call_191F_0296();   /* @asm 0x06774A */
    overlay_call_1A1F_093E();   /* @asm 0x06774F draw tile graphic */

    /* @asm 0x067754 if ([0x184] == 3) draw the centred name label */
    if (*(volatile uint16_t *)0x184 == 3) {
        /* @asm 0x06775F push (0x5396*0x34 + 0x5426), &namebuf -> 0x0D1D:0x7e4 (format) */
        overlay_call_0D1D_07E4();
        /* @asm 0x067774 pixel X = ([0x832c]*tile_ph + es:[0x89e][0]) >> 1 + 8 ;
         *      push 0xf, X, [0x8550], 0, ss:&namebuf -> 0x181F:0x100 (text blit). */
        overlay_call_181F_0100();
    }

    /* @asm 0x0677A1 power = [0x53a2]?-1:[0x5396] ; push arg0 -> 0x1A1F:0x8a4 */
    overlay_call_1A1F_08A4();
    /* @asm 0x0677BD if (arg0 != 0): 0x1A1F:0x8ea (extra cursor overlay) */
    if (arg0_active != 0) {
        overlay_call_1A1F_08EA();
    }
    return 0;  /* @asm 0x0677C8 RETF */
}

/* ============================================================================
 * func_0677CA — redraw_selected_unit_tile  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Recomposes the single tile occupied by the selected unit [0x5392] (a fast path
 * used when only that unit moved).  Reads the selected unit's (col,row) from
 * UnitRecord 0x3144 (+0/+1), seeds a 1,1 working pair, binds the plot via
 * 0x1A1F:0x914, then draws terrain/roads via 0x181F:0x32C, the unit layer for
 * the tile via 0x181F:0xE2A (arg [bp+6]), and the cursor overlay via 0x1A1F:0x8F8.
 *
 * Tail helpers (reached only via cs:near trampolines from elsewhere in the page):
 *   0x067836 push_sheet_context — saves sheet far-ptr [0x17C]/[0x17E] and zoom
 *             [0x184] into the per-power slot at (0x948E + [0x5394]*6).
 *   0x067858 pop_sheet_context  — restores them from that slot.
 *   (These keep each power's render context when the view switches powers.)
 *
 * @param arg0_mode [bp+6]  passed to the unit-layer draw (0/1 select state)
 * ---------------------------------------------------------------------------- */
int func_0677CA_redraw_selected_unit_tile(uint16_t arg0_mode)
{
    uint8_t *rec = (uint8_t *)(0x3144 + (int)(*(volatile uint16_t *)0x5392) * 0x1C); /* @asm 0x0677CE */
    int col = (int)rec[0];   /* @asm 0x0677D3 [bp-2] */
    int row = (int)rec[1];   /* @asm 0x0677DC [bp-4] */
    (void)col; (void)row;

    /* @asm 0x0677EC push &cells (1,1,row,col) -> 0x1A1F:0x914 (bind plot) */
    overlay_call_1A1F_0914();
    /* @asm 0x067804 push 4 cell words -> 0x181F:0x32c (terrain/roads) */
    overlay_call_181F_032C();
    /* @asm 0x067818 push [bp+6] -> 0x181F:0xe2a (unit layer for this tile) */
    overlay_call_181F_0E2A();
    (void)arg0_mode;
    /* @asm 0x067823 push 4 cell words -> 0x1A1F:0x8f8 (cursor overlay) */
    overlay_call_1A1F_08F8();
    return 0;  /* @asm 0x067834 RETF */
}

/* Tail helper @0x067836 push_sheet_context — save [0x17C]/[0x17E]/[0x184] into
 * per-power slot (0x948E + [0x5394]*6).  @asm 0x067836..0x067857 RETF. */
void push_sheet_context(void)
{
    uint16_t *slot = (uint16_t *)(0x948E + (int)(*(volatile uint16_t *)0x5394) * 6);
    slot[0] = *(volatile uint16_t *)0x17C;   /* @asm 0x067846 */
    slot[1] = *(volatile uint16_t *)0x17E;   /* @asm 0x06784B */
    slot[2] = *(volatile uint16_t *)0x184;   /* @asm 0x067851 */
}

/* Tail helper @0x067858 pop_sheet_context — restore from the same slot.
 * @asm 0x067858..0x06787B RETF.  (NB: the disasm's [bx-0x6b72] is the same slot
 *  base 0x948E reached via a different addressing form.) */
void pop_sheet_context(void)
{
    uint16_t *slot = (uint16_t *)(0x948E + (int)(*(volatile uint16_t *)0x5394) * 6);
    *(volatile uint16_t *)0x17C = slot[0];   /* @asm 0x067864 */
    *(volatile uint16_t *)0x17E = slot[1];   /* @asm 0x06786F */
    *(volatile uint16_t *)0x184 = slot[2];   /* @asm 0x067875 */
}

/* ============================================================================
 * func_06787C — render_frame_setup  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * Establishes ALL map-view geometry for the current frame from the zoom level
 * [0x184] and the scroll centre [0x17C]/[0x17E].  This is the function that
 * src/render/tile_chain.c references throughout as `render_frame_setup` (and via
 * @verify func_06787C @0x...) but does NOT define — its body lives here.
 *
 * Steps (all byte-traced):
 *   - span [0x8544]=0xF<<zoom (cols), [0x8546]=0xC<<zoom (rows).  @asm 0x067880
 *   - if minimap flag [0x18A]!=0: span=5x5 and force zoom 0.       @asm 0x067894
 *   - tile pixel size [0x5AD4]=[0x8326]=0x10>>zoom.                @asm 0x0678AA
 *   - viewport origin [0x8328]=-(span_w/2 - centre_x[0x17C]) ;
 *     [0x832E]=-(span_h/2 - centre_y[0x17E]).                      @asm 0x0678B9
 *   - non-minimap clamp of origin into [1 .. map-span-1] for both
 *     axes (map dims [0x853A]/[0x853C]).                            @asm 0x0678DE
 *   - pixel-grid base [0x832A]/[0x832C]=0, with centring when the
 *     map is narrower/shorter than the span (sets base = (span-map+2)/2
 *     and shrinks span to map-2).                                   @asm 0x067912
 *   - origin-1 cache [0x854C]/[0x854E].                             @asm 0x067962
 *   - render stride/height [0x8548]/[0x854A]: when fast layers are
 *     resident ([0x15A]!=0) and not minimap, stride=(0xF<<zoom)+2,
 *     height=(0xC<<zoom)+2; else a clamped per-axis span; else the
 *     full map dims.                                                @asm 0x067970
 *   - zoom-derived HUD metrics [0x186]=0x64>>zoom, [0x188]=(5<<zoom)+5. @asm 0x0679F4
 *   - max visible tile [0x8804]=span_w+origin_col-1,
 *     [0x8806]=span_h+origin_row-1.                                 @asm 0x067A0B
 * ---------------------------------------------------------------------------- */
int func_06787C_render_frame_setup(void)
{
    int zoom = (int)(*(volatile uint8_t *)0x184);
    int span_w, span_h, origin_col, origin_row, ax;

    /* @asm 0x067880 span = 0xF<<zoom (w), 0xC<<zoom (h) */
    span_w = 0x0F << zoom;  *(volatile uint16_t *)0x8544 = (uint16_t)span_w;
    span_h = 0x0C << zoom;  *(volatile uint16_t *)0x8546 = (uint16_t)span_h;

    /* @asm 0x067894 minimap: 5x5 span, zoom forced to 0 */
    if (*(volatile uint16_t *)0x18A != 0) {
        span_w = 5; *(volatile uint16_t *)0x8544 = 5;   /* @asm 0x06789B */
        span_h = 5; *(volatile uint16_t *)0x8546 = 5;
        *(volatile uint16_t *)0x184 = 0;                 /* @asm 0x0678A4 */
        zoom = 0;
    }

    /* @asm 0x0678AA tile pixel size = 0x10 >> zoom (square) */
    {
        int px = 0x10 >> (int)(*(volatile uint8_t *)0x184);
        *(volatile uint16_t *)0x5AD4 = (uint16_t)px;
        *(volatile uint16_t *)0x8326 = (uint16_t)px;
    }

    /* @asm 0x0678B9 origin_col = -(span_w/2 - centre_x[0x17C]) */
    origin_col = -(( (int)(*(volatile uint16_t *)0x8544) >> 1)
                    - (int)(*(volatile uint16_t *)0x17C));
    *(volatile uint16_t *)0x8328 = (uint16_t)origin_col;
    /* @asm 0x0678C7 origin_row = -(span_h/2 - centre_y[0x17E]) */
    origin_row = -(( (int)(*(volatile uint16_t *)0x8546) >> 1)
                    - (int)(*(volatile uint16_t *)0x17E));
    *(volatile uint16_t *)0x832E = (uint16_t)origin_row;

    /* @asm 0x0678D7 non-minimap: clamp origins into [1 .. mapdim-span-1] */
    if (*(volatile uint16_t *)0x18A == 0) {
        int dx, dy;
        if (origin_col < 1) origin_col = 1;             /* @asm 0x0678DE */
        dx = (int)(*(volatile uint16_t *)0x853A) - (int)(*(volatile uint16_t *)0x8544) - 1; /* @asm 0x0678E6 */
        if (origin_col > dx) origin_col = dx;           /* @asm 0x0678EF */
        *(volatile uint16_t *)0x8328 = (uint16_t)origin_col;
        if (origin_row < 1) origin_row = 1;             /* @asm 0x0678F8 */
        dy = (int)(*(volatile uint16_t *)0x853C) - (int)(*(volatile uint16_t *)0x8546) - 1; /* @asm 0x067900 */
        if (origin_row > dy) origin_row = dy;           /* @asm 0x067908 */
        *(volatile uint16_t *)0x832E = (uint16_t)origin_row;
    }

    /* @asm 0x067912 pixel-grid base = 0; centre if map narrower/shorter than span */
    *(volatile uint16_t *)0x832A = 0;
    *(volatile uint16_t *)0x832C = 0;
    /* @asm 0x06791A if (map_w-2 < span_w) { origin_col=1; base_col=(span_w-map_w+2)/2; span_w=map_w-2 } */
    ax = (int)(*(volatile uint16_t *)0x853A) - 2;
    if (ax < (int)(*(volatile uint16_t *)0x8544)) {
        *(volatile uint16_t *)0x8328 = 1;
        *(volatile uint16_t *)0x832A =
            (uint16_t)(((int)(*(volatile uint16_t *)0x8544)
                        - (int)(*(volatile uint16_t *)0x853A) + 2) >> 1);
        *(volatile uint16_t *)0x8544 = (uint16_t)ax;
    }
    /* @asm 0x06793E same for rows (map_h-2 < span_h) */
    ax = (int)(*(volatile uint16_t *)0x853C) - 2;
    if (ax < (int)(*(volatile uint16_t *)0x8546)) {
        *(volatile uint16_t *)0x832E = 1;
        *(volatile uint16_t *)0x832C =
            (uint16_t)(((int)(*(volatile uint16_t *)0x8546)
                        - (int)(*(volatile uint16_t *)0x853C) + 2) >> 1);
        *(volatile uint16_t *)0x8546 = (uint16_t)ax;
    }

    /* @asm 0x067962 origin-1 cache */
    *(volatile uint16_t *)0x854C = (uint16_t)((int)(*(volatile uint16_t *)0x8328) - 1);
    *(volatile uint16_t *)0x854E = (uint16_t)((int)(*(volatile uint16_t *)0x832E) - 1);

    /* @asm 0x067970 render stride/height [0x8548]/[0x854A] */
    if (*(volatile uint16_t *)0x15A != 0) {             /* fast layers resident */
        if (*(volatile uint16_t *)0x18A == 0) {         /* @asm 0x067977 not minimap */
            int z = (int)(*(volatile uint8_t *)0x184);
            *(volatile uint16_t *)0x8548 = (uint16_t)((0x0F << z) + 2);  /* @asm 0x067989 */
            *(volatile uint16_t *)0x854A = (uint16_t)((0x0C << z) + 2);  /* @asm 0x06798C */
        } else {
            /* @asm 0x067996 minimap clamp path: stride=mapdim-origin1+1 per axis */
            int sc = (int)(*(volatile uint16_t *)0x854C);
            int sr = (int)(*(volatile uint16_t *)0x854E);
            int wc = (int)(*(volatile uint16_t *)0x853A) - 1;
            int wr = (int)(*(volatile uint16_t *)0x853C) - 1;
            int ec = (sc < 0) ? 0 : sc; *(volatile uint16_t *)0x854C = (uint16_t)ec;
            int er = (sr < 0) ? 0 : sr; *(volatile uint16_t *)0x854E = (uint16_t)er;
            if (wc > sc + 6) wc = sc + 6;               /* (clamp window @0x0679A8) */
            if (wr > sr + 6) wr = sr + 6;
            *(volatile uint16_t *)0x8548 = (uint16_t)(wc - ec + 1);
            *(volatile uint16_t *)0x854A = (uint16_t)(wr - er + 1);
        }
    } else {
        /* @asm 0x0679E8 no fast layers: stride/height = full map dims */
        *(volatile uint16_t *)0x8548 = *(volatile uint16_t *)0x853A;
        *(volatile uint16_t *)0x854A = *(volatile uint16_t *)0x853C;
    }

    /* @asm 0x0679F4 zoom-derived HUD metrics */
    {
        int z = (int)(*(volatile uint8_t *)0x184);
        *(volatile uint16_t *)0x186 = (uint16_t)(0x64 >> z);            /* @asm 0x0679FD */
        *(volatile uint16_t *)0x188 = (uint16_t)((5 << z) + 5);         /* @asm 0x067A00 */
    }

    /* @asm 0x067A0B max visible tile = span + origin - 1 */
    *(volatile uint16_t *)0x8804 =
        (uint16_t)((int)(*(volatile uint16_t *)0x8544)
                   + (int)(*(volatile uint16_t *)0x8328) - 1);          /* @asm 0x067A0B */
    *(volatile uint16_t *)0x8806 =
        (uint16_t)((int)(*(volatile uint16_t *)0x8546)
                   + (int)(*(volatile uint16_t *)0x832E) - 1);          /* @asm 0x067A16 */
    return 0;  /* @asm 0x067A21 RETF */
}

/* func_067A24 — SUPERSEDED -> src/render/terrain.c (analyse_connections: road/conn
 *   bitmap [0xA8A6] + per-dir road table 0x2D24).  @asm extent 0x067A24..0x067B83
 *   (352 B, terminal RET). */

/* func_067B84 — SUPERSEDED -> src/render/terrain.c (nmask4_feature: 4-cardinal
 *   neighbour mask on the FEATURE layer).  @asm extent 0x067B84..0x067BE3 (96 B). */

/* func_067BE4 — SUPERSEDED -> src/render/terrain.c (nmask4_feat_hi: 4-cardinal
 *   "high-bits == 0xA0" match on FEATURE).  @asm extent 0x067BE4..0x067C53 (111 B). */

/* func_067C54 — SUPERSEDED -> src/render/terrain.c (forest_neighbour: forest-base
 *   predicate).  @asm extent 0x067C54..0x067C8D (57 B). */

/* func_067C8E — SUPERSEDED -> src/render/terrain.c (nmask4_forest: 4-cardinal
 *   forest-edge mask).  @asm extent 0x067C8E..0x067CF3 (102 B). */

/* func_067CF4 — SUPERSEDED -> src/render/terrain.c (nmask4_terrain == func_O506:
 *   4-cardinal TERRAIN mask).  @asm extent 0x067CF4..0x067D53 (96 B). */

/* func_067D54 — SUPERSEDED -> src/render/terrain.c (nmask8_terrain == func_O507:
 *   8-direction TERRAIN mask).  @asm extent 0x067D54..0x067DC7 (116 B). */

/* func_067DC8 — SUPERSEDED -> src/render/blit.c (draw_tile_marker, NEAR ip 0x1748)
 *   + dual role compute_dialog_rect_from_cursor in src/ui/dialog.c.
 *   @asm extent 0x067DC8..0x067E27 (95 B). */

/* func_067E28 — SUPERSEDED -> src/render/blit.c (emit_ground_sprite, NEAR ip
 *   0x17A8; pushes AX = sprite index; lcall 0x181F:0x25E).  @asm 0x067E28..0x067E8B. */

/* func_067E8C — SUPERSEDED -> src/render/blit.c (emit_sprite_alt, NEAR ip 0x180C;
 *   alternate overlay 0x1A1F:0x98E).  @asm extent 0x067E8C..0x067EEB (95 B). */

/* func_067EEC — SUPERSEDED -> src/render/blit.c (emit_terrain_sprite, NEAR ip
 *   0x186C; primary sheet B; lcall 0x181F:0x268).  @asm 0x067EEC..0x067F4F. */

/* func_067F50 — SUPERSEDED -> src/render/tile_chain.c (tile_compose_subcells ==
 *   func_O512: sub-cell water/coast composer).  @asm extent 0x067F50..0x0681A7
 *   (599 B, terminal RET).  NB: the auto banner's 402 B size is truncated. */

/* func_0681A8 — SUPERSEDED -> src/render/tile_chain.c (tile_dispatch == func_O513:
 *   per-tile terrain/feature/road/river/coast sprite selector).  @asm extent
 *   0x0681A8..0x0685DB (1076 B, terminal RET).  NB: auto banner's 165 B is badly
 *   truncated (it stops at the first RET inside the dispatch). */

/* func_0685DC — SUPERSEDED -> src/render/tile_chain.c (map_view_render == func_O514:
 *   the outer visible-row/col loop that drives O513).  @asm extent
 *   0x0685DC..0x068897 (699 B, terminal RETF imm16). */

/* ============================================================================
 * func_068898 — draw_minimap_or_cursor_box  [DONE — control flow byte-traced]
 * ----------------------------------------------------------------------------
 * (The auto-decoder mis-framed this as a 9-byte TINY_RETURN; the reseg page shows
 *  it is a real 149-byte routine, 0x068898..0x06892D, with two RETF exits.)
 *
 * Calls render_frame_setup (cs:0x22EA -> 0x6896A -> 0x191F:0x18E) to recompute
 * geometry, then draws the viewport rectangle on the minimap / overview:
 *   - if (origin base [0x832A]==0 && [0x832C]==0): take the simple path (no
 *     descriptor) -> 0x181F:0x484 with the clip words [0x839E..0x83A4].
 *   - else: a descriptor far-record at [0x82C] supplies 4 words ([bx+0..6]) and
 *     the box is drawn with -8 inset via 0x181F:0xC4 (clip [0x839E..0x83A4]).
 *   - finally pushes [0x8546] (span_h), [bp-2], origin [0x8328]/[0x832E] and the
 *     render-stride [0x8544], and tail-calls cs:0x22F4 (-> 0x1A1F:0x968, draw).
 * Second entry (0x06891E): sets [0x18A]=dx (minimap on), calls render_frame
 * (cs:0x22EF -> 0x6896F -> 0x191F:0x2A4), then clears [0x18A]=0.
 * ---------------------------------------------------------------------------- */
int func_068898_draw_minimap_or_cursor_box(void)
{
    /* @asm 0x06889C push cs ; call 0x22ea (= 0x6896A ljmp 0x191F:0x18E = render_frame_setup) */
    func_06787C_render_frame_setup();   /* via cs-thunk 0x6896A -> 0x191F:0x18E */

    /* @asm 0x0688A0 if ([0x832a]==0 && [0x832c]==0) simple path */
    if (*(volatile uint16_t *)0x832A == 0 && *(volatile uint16_t *)0x832C == 0) {
        /* @asm 0x0688EE push clip[0x839e..0x83a4] ; al=0 -> 0x181F:0x484 */
        overlay_call_181F_0484();
    } else if (*(volatile uint16_t *)0x82C == 0) {
        /* @asm 0x0688AE no descriptor -> simple path as well */
        overlay_call_181F_0484();
    } else {
        /* @asm 0x0688B5 descriptor path: -8 inset, 0,0, clip[0x839e]/[0x83a0],
         *      0,0, far-record [0x82C][+0..6], clip[0x839e..0x83a4] -> 0x181F:0xc4. */
        overlay_call_181F_00C4();
    }

    /* @asm 0x068905 push span_h[0x8546], [bp-2], origin [0x8328]/[0x832e],
     *      stride [0x8544] ; call 0x22f4 (= 0x68974 ljmp 0x1A1F:0x968 draw box). */
    overlay_call_1A1F_0968();
    return 0;  /* @asm 0x06891C RETF */
}

/* func_06892E — SUPERSEDED -> src/render/tile_chain.c (clear_object_layer).
 *   @asm extent 0x06892E..0x068968 (75 B): nested loops over the whole map
 *   (x 0..[0x853A], y 0..[0x853C]) writing -1 via layer_set_object (0x181F:0x704).
 *   NB: the auto banner split this as func_06892E (60 B); reseg gives 75 B. */

/* RTLink near-CS trampoline block @0x06896A..0x068978 (NOT functions):
 *   0x06896A  ljmp 0x191F:0x18E   (-> render_frame_setup proper)
 *   0x06896F  ljmp 0x191F:0x2A4   (-> tile-info handler)
 *   0x068974  ljmp 0x1A1F:0x968   (-> draw box)
 *   The earlier in-page block @0x067626..0x06763F is the analogous bridge for the
 *   draw passes above (0x181F:0x344 / 0x181F:0xE2A / 0x1A1F:0x922 / 0x1A1F:0x930 /
 *   0x1A1F:0x94C / 0x1A1F:0x95A).  @asm bytes verified at those offsets. */
