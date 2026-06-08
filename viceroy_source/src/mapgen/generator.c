/* ============================================================================
 * generator.c -- VICEROY.EXE "New World" continental map generator (top level)
 * ============================================================================
 *
 * STATUS LEGEND
 *   BYTE_VERIFIED : control flow / in-EXE constant read straight from the
 *                   re-segmented overlay disassembly (file offset cited).
 *   not yet decoded : value/table is data-driven (NAMES.TXT) or lives behind an
 *                   RTLink overlay thunk whose target is not yet resolved.
 *
 * ENTRY POINT (BYTE_VERIFIED)
 *   func_064A10  @ VICEROY.EXE file 0x064A10 .. 0x065D25 (4886 bytes,
 *   ENTER 0x3C). Overlay page 0x14 (code_offset 0x063880). This is the single
 *   function that fills the terrain layer for a New Game. The old auto-decode
 *   labelled it `func_064A10_rng_sz_1792` with a TRUNCATED 1792-byte boundary
 *   (it stopped at the first early-return-ish branch); the overlay
 *   re-segmentation (2026-05-28) recovered the true 4886-byte body, which is
 *   unmistakably the map generator.
 *     @asm 0x064A1B  lcall 0x181F:0x04D4   ; random_int(1,0x7FFF) -> seed scratch [0x190]
 *     @asm 0x064A6E  sub al,6 ; [0x2d1e]   ; usable width  = map_width  - 6
 *     @asm 0x064A7B  [0x2d1f] = map_height ; usable height (clamped below)
 *
 * MAP MEMORY (BYTE_VERIFIED — see func_070FF8 @0x070FF8, page 0x19)
 *   The map is 4 parallel byte layers, each (map_width*map_height) bytes,
 *   malloc'd (lcall 0x181F:0x29A) and stored as far pointers in DGROUP:
 *     [0x15C/0x15E] layer 0 = TERRAIN (base id + flag bits)   <- generator fills
 *     [0x160/0x162] layer 1 = elevation / land-mask scratch   <- generator uses
 *     [0x164/0x166] layer 2 = (resource/prime overlay on disk)
 *     [0x168/0x16A] layer 3 = fog / visibility                <- generator zeroes
 *   At gen time these are cached into a render-context block:
 *     [0x85A8..0x85AE] = layer0 ptr,  [0x85B0..0x85B6] = layer1 ptr,
 *     [0x85B8..0x85BE] = layer2 ptr,  [0x85C0..0x85C6] = layer3 ptr.
 *   map_width  = DGROUP:[0x853A]  (58 in shipped maps)   (BYTE_VERIFIED)
 *   map_height = DGROUP:[0x853C]  (72 in shipped maps)   (BYTE_VERIFIED)
 *
 * TILE ACCESS HELPERS (BYTE_VERIFIED call shape; body in thunk page)
 *   read  : lcall 0x1A1F:0x0868  (layer_far_ptr, x in AX, y in DX) -> AL=byte
 *   write : lcall 0x1A1F:0x0872  (layer_far_ptr, x in AX, y in DX, BX=value)
 *   These are the explicit-pointer twins of the resident accessor
 *   func_005CFE (@0x5CFE), which computes layer[y*map_width + x].
 *
 * THE ARGUMENT  (BYTE_VERIFIED branch, semantics not yet decoded)
 *   func_064A10 takes one stack word [bp+6]. Almost every pass is gated on it:
 *     @asm 0x064A2C  cmp [bp+6],0 / jne 0x2561  (skip the whole procedural fill)
 *     @asm 0x065BF0  cmp [bp+6],0 ... or es:[bx],0xA0 at fixed tiles  (scripted
 *                     mountains for a *premade* scenario, e.g. AMER2)
 *   Interpretation: arg==0 => generate a random continental map; arg!=0 =>
 *   a premade/America scenario was loaded, so skip generation and only do the
 *   border / fixup passes. Named `premade` below. (NOT byte-proven to be the
 *   menu "America vs Random" flag — marked not yet decoded.)
 *
 * DGROUP file base = 0x1D9A0 (BYTE_VERIFIED: @UNFORESTED string at file 0x1FB54
 * lands at DS offset 0x21B4).  All DS-relative const tables (jump tables, the
 * 8-dir walk table, the 20-cell river kernel) are at file = 0x1D9A0 + offset.
 *
 * GENERATION PASSES, in execution order (all BYTE_VERIFIED control flow):
 *   P0  init        clear render-context + fill layer0/layer1 with 0x19 (Ocean)
 *                   via lcall 0x181F:0x484 (region fill).            @0x064A4B
 *   P1  landmass    blob-growth: seed N land-tiles ((p1+p2+1)*0x140 target,
 *                   @0x064AAD), then random-walk each seed with the 8-direction
 *                   compass table at DS 0xB4(dx)/0xBE(dy) (BYTE_VERIFIED:
 *                   N,NE,E,SE,S,SW,W,NW), carrying a 4-neighbour land mask
 *                   (bits 1/2/4/8 from lcall 0x1A1F:0x868 of the E/S/SE corner,
 *                   @0x064B5A..0x064BD1; mask 6 or 9 triggers fill).
 *   P2  climate     latitude sweeps: NORTH half (y<H/2) uses jump table
 *                   cs:[bx+0xBAC] (elev->base 5,4,1,3,2,2), SOUTH half uses
 *                   cs:[bx+0xEFE]; elev OR's hills(0x20)/forest(0x80).
 *                   See climate.c.                                  @0x064CEE,0x065048
 *   P3  smoothing   relaxation budgeted by (p_iter+1)*0x320 (@0x06538D); folds
 *                   unforested bases into forested ids (+8 / +0x10, @0x0653F8/
 *                   0x06540E) and refines warm bases via cs:[bx+0x11CE].
 *                   Also converts stray interior Ocean(0x19)/SeaLane cells.
 *                                                                   @0x064DD4,0x065318
 *   P4  rivers      feature spread over the 20-cell DGROUP kernel (DS 0xC8/0xDE);
 *                   land/flow gated by lcall 0x181F:0x768 / 0x718; stamps via
 *                   0x181F:0x68C. Sets terrain bit 6 (0x40).  See rivers.c. @0x065BC2
 *   P5  borders     right two columns -> base 0x1A SeaLane; top/bottom rows ->
 *                   base 0x18 Arctic, via lcall 0x181F:0xCE / 0x181F:0xBA.
 *                   See place_sea_lane_borders().                   @0x065941 (IP 0x2561)
 *   P6  starts      seed the 4 European powers' starting (x,y) into PowerRecord
 *                   +0x32/+0x33 (stride 0x13C): y = (H/5)*(p+1) band, x walked
 *                   inland from the east sea lane.
 *                   See pick_starting_positions().                  @0x065C9C
 *
 * NOTE ON SETTLEMENTS / RESOURCES / LCR
 *   func_064A10 does NOT place native settlements, prime resources, or lost-city
 *   rumours — it only builds the terrain layer + European starts. Those are
 *   separate New-Game passes (settlements.c / not yet decoded functions) and are largely
 *   data-driven (NAMES.TXT). They are kept here for structure but flagged.
 * ============================================================================ */
#include "viceroy_types.h"

/* ---- DGROUP map globals (BYTE_VERIFIED) -------------------------------- */
extern uint16_t g_map_width;    /* DGROUP:0x853A */
extern uint16_t g_map_height;   /* DGROUP:0x853C */

/* The four map layers as flat arrays (modelled; in the EXE they are far
 * pointers at DGROUP:0x15C/0x160/0x164/0x168). */
extern uint8_t *g_layer_terrain;    /* [0x15C] layer 0 */
extern uint8_t *g_layer_elev;       /* [0x160] layer 1 (scratch elevation) */
extern uint8_t *g_layer_resource;   /* [0x164] layer 2 */
extern uint8_t *g_layer_fog;        /* [0x168] layer 3 */

/* ---- runtime helpers (BYTE_VERIFIED roles) ----------------------------- */
extern int  random_int(int lo, int hi);   /* lcall 0x181F:0x04D4 -> 0xC322  */
extern void layer_fill(uint8_t *layer, uint8_t value);            /* 0x181F:0x484 */
extern uint8_t tile_read (uint8_t *layer, int x, int y);          /* 0x1A1F:0x868 */
extern void    tile_write(uint8_t *layer, int x, int y, uint8_t v);/* 0x1A1F:0x872 */

/* ---- pass entry points (defined in the sibling translation units) ------ */
extern void apply_landmass_and_climate(void);   /* climate.c — P1+P2+P3 */
extern void trace_all_rivers(void);             /* rivers.c   — P4       */
extern void place_sea_lane_borders(int premade);/* this file  — P5       */
extern void pick_starting_positions(void);      /* this file  — P6       */

/* Base terrain ids that appear as in-EXE immediates in func_064A10
 * (BYTE_VERIFIED — these are the literal bytes the generator writes). */
#define BASE_ARCTIC_FILL  0x18   /* 24 — polar band fill              @0x06582A bx=0x18 */
#define BASE_OCEAN        0x19   /* 25 — open ocean / interior fill   @0x064A4B,0x065470 */
#define BASE_SEA_LANE     0x1A   /* 26 — sea-lane border column       @0x0656EA or bl,0x19 ; 0x065976 push 0x1A */
#define FLAG_HILLS        0x20   /* terrain bit 5                     @0x064D19 or [bp-0x2e],0x20 */
#define FLAG_RIVER        0x40   /* terrain bit 6 (set in rivers pass; MAP_FORMAT.md) */
#define FLAG_FOREST       0x80   /* terrain bit 7                     @0x064D23 or [bp-0x2e],0x80 */

/* ---------------------------------------------------------------------------
 * map_generate_new_world  — reconstruction of func_064A10 @0x064A10
 *
 * `premade` is the [bp+6] argument (see header note). 0 = generate; nonzero =
 * a premade scenario is in memory, skip the procedural fill.
 * ------------------------------------------------------------------------- */
void map_generate_new_world(int premade)
{
    /* @asm 0x064A16  push 0x7FFF / push 1 / lcall 0x181F:0x4D4
     *               -> [0x190] = random_int(1, 0x7FFF)   (generator entropy) */
    (void)random_int(1, 0x7FFF);

    /* @asm 0x064A2C  cmp [bp+6],0 ; jne 0x2561 — when a premade scenario is in
     * memory, skip ONLY the procedural terrain build (P0..P3); the border,
     * river, scripted-mountain and start passes from 0x2561 onward still run
     * (they fall through linearly to the single retf at 0x065D06). */
    if (!premade) {
        /* --- P0: initialise both working layers to Ocean (BYTE_VERIFIED) ----
         * @asm 0x064A4B  push layer0 ptr / mov al,0x19 / lcall 0x181F:0x484
         * @asm 0x064A64  push layer1 ptr / sub al,al  / lcall 0x181F:0x484 */
        layer_fill(g_layer_terrain, BASE_OCEAN);   /* al = 0x19 */
        layer_fill(g_layer_elev, 0);               /* al = 0    */

        /* @asm 0x064A69  [0x2d20]=3 ; [0x2d1e]=map_width-6 ; [0x2d1f]=map_height
         * generator working bounds (a 3-tile inset frame). BYTE_VERIFIED. */

        /* --- P1+P2+P3: landmass blobs, latitude climate, smoothing ----- */
        apply_landmass_and_climate();
    }

    /* --- P5: water frame + sea-lane column (runs for both paths) -------- */
    place_sea_lane_borders(premade);

    /* --- P4: rivers (the river/feature sweep at 0x26C0, after the borders
     * in linear order; runs for both procedural and premade maps) -------- */
    trace_all_rivers();

    /* --- P6: European starting positions ------------------------------- */
    pick_starting_positions();
}

/* ---------------------------------------------------------------------------
 * place_sea_lane_borders — the map-frame fixup pass.  (BYTE_VERIFIED)
 *
 * This is the tail block at @asm 0x065941 (display IP 0x2561), reached either
 * by falling through the procedural passes or by the premade early-jump at
 * 0x064A32.  It uses two DGROUP-resident span-fill helpers:
 *   lcall 0x181F:0xCE  = vertical-span fill  (args: layer ptr (4 words), span
 *                        length, fill base, bx=column, ax=start row, cdq)
 *   lcall 0x181F:0xBA  = horizontal-span fill (args: layer ptr, span length,
 *                        fill base, ax=start col, bx=width, dx=row)
 * Their bodies are in thunk page (overlay thunks).
 *
 * EXACT SEQUENCE (BYTE_VERIFIED immediates):
 *   @asm 0x065951  col (W-1), rows 0..(H-1)   -> base 0x1A SeaLane   [push 0x1A; bx=W-1; ax=0]
 *   @asm 0x065975  col (W-2), rows 1..(H-1)   -> base 0x1A SeaLane   [push 0x1A; bx=W-2; ax=1]
 *   @asm 0x06599B  row 0,    cols 0..(W-1)    -> base 0x18 Arctic    [push 0x18; ax=0; dx=0]
 *   @asm 0x0659BB  row (H-1),cols 0..(W-1)    -> base 0x18 Arctic    [push 0x18; ax=0; dx=H-1]
 *
 * NOTE: the top/bottom frame rows are Arctic (0x18), NOT Ocean — corrected
 * 2026-05-30 from the 0x18 immediates at 0x06599D/0x0659BD.  The interior
 * polar-speckle pass (40 random Arctic cells on rows 0 and H-2) is a SEPARATE
 * earlier pass at @asm 0x06554E (count 0x28, bx=0x18); it runs during the
 * relaxation phase, not here, so it is not part of this fixup function.
 * ------------------------------------------------------------------------- */
void place_sea_lane_borders(int premade)
{
    int x, y;
    (void)premade;

    /* Right two columns -> Sea Lane (base 0x1A).  @asm 0x065951 / 0x065975
     * (col W-1 for all rows; col W-2 from row 1 down). */
    for (y = 0; y < (int)g_map_height; y++)
        tile_write(g_layer_terrain, (int)g_map_width - 1, y, BASE_SEA_LANE);
    for (y = 1; y < (int)g_map_height; y++)
        tile_write(g_layer_terrain, (int)g_map_width - 2, y, BASE_SEA_LANE);

    /* Top and bottom frame rows -> Arctic (base 0x18).  @asm 0x06599B / 0x0659BB */
    for (x = 0; x < (int)g_map_width; x++) {
        tile_write(g_layer_terrain, x, 0, BASE_ARCTIC_FILL);
        tile_write(g_layer_terrain, x, (int)g_map_height - 1, BASE_ARCTIC_FILL);
    }
}

/* ---------------------------------------------------------------------------
 * pick_starting_positions — seed the four European powers.  (BYTE_VERIFIED)
 *
 * Full trace @asm 0x065C9C .. 0x065D04 (the final loop of func_064A10):
 *   @asm 0x065C9C  [bp-0x22] = 0                       ; power loop index p
 *   @asm 0x065CDF  si = p ; al = [bp+si-0xc] ; [bp-0x28] = al
 *                  ; [bp-0xc..-9] is the 4-byte per-nation scratch built just
 *                  ; above (the rotated nation order; see 0x065C75 rotate).
 *   @asm 0x065CE9  ax = map_height ; cx = 5 ; idiv cx   ; ax = H/5
 *   @asm 0x065CF2  cx = si+1 ; imul cx                  ; [bp-0x24] = (H/5)*(p+1)
 *                  ; => start_y band: row (map_height/5)*(p+1).
 *   @asm 0x065CFA  ax = map_width ; dec ; dec           ; [bp-0x1e] = W-2
 *                  ; => start at the east edge minus 2 (just inside sea lane).
 *   @asm 0x065D02  jmp 0x28da  -> inland walk:
 *     @asm 0x065CA4  tile = read(x=[bp-0x1e], y=[bp-0x24])  (lcall 0x181F:0x78C)
 *     @asm 0x065CB2  cmp ax,0x1A (Sea Lane) ; jne done
 *     @asm 0x065CB7  dec [bp-0x1e]            ; walk WEST while on sea lane
 *     @asm 0x065CBA  cmp [bp-0x1e],2 ; jg loop ; (stop at column 2)
 *   @asm 0x065CC0  inc [bp-0x1e]              ; step back east by one onto land
 *   @asm 0x065CC6  bx = [bp-0x28] * 0x13C     ; nation * PowerRecord stride
 *   @asm 0x065CCB  mov [bx-0x77C6],al(x)      ; field at DS 0x883A = PR + 0x32
 *   @asm 0x065CD2  mov [bx-0x77C5],al(y)      ; field at DS 0x883B = PR + 0x33
 *
 * BYTE-VERIFIED FIELD MAP (NEW, this pass):
 *   The write base DS:0x883A = POWER_TABLE_BASE(0x8808) + 0x32, stride 0x13C.
 *   => PowerRecord + 0x32 = start_x (the inland-walked column)
 *      PowerRecord + 0x33 = start_y (the latitude band row)
 *   (-0x77C6 in 16-bit two's complement = 0x883A; -0x77C5 = 0x883B.)
 *
 * The 4-nation rotation @0x065C75 (ax = p + [0x5398]; idiv 4) selects which
 * physical nation slot gets band p; [0x5398] is the per-game start-nation
 * offset (its VALUE is RUNTIME_ONLY (runtime/setup-driven; set at new-game start)).
 * ------------------------------------------------------------------------- */
extern uint8_t *power_record(int idx);   /* &DGROUP:0x8808 + idx*0x13C */
/* DGROUP:0x5398 = g_active_power_5398 — active/chosen power index (0..3).
 * Cross-confirmed: war_turn.c, sons_of_liberty.c, intervention.c all use the
 * same address with the same semantics. Used here as the band-rotation seed
 * at @0x065C75 so that band 0 is always assigned to the player's nation. */
extern uint16_t g_active_power_5398;   /* DGROUP:0x5398 — active power / start-nation rotation seed */

#define PR_START_X 0x32   /* PowerRecord +0x32 = start column  @0x065CCB (DS 0x883A) */
#define PR_START_Y 0x33   /* PowerRecord +0x33 = start row     @0x065CD2 (DS 0x883B) */

void pick_starting_positions(void)
{
    int p;
    /* 4 European powers (literal 4, BYTE_VERIFIED — @asm 0x065CD9 cmp [bp-0x22],4). */
    for (p = 0; p < 4; p++) {
        int nation  = (p + (int)g_active_power_5398) % 4;        /* @0x065C75 idiv 4 */
        int band_y  = ((int)g_map_height / 5) * (p + 1);        /* @0x065CE9..0x065CF5 */
        int start_x = (int)g_map_width - 2;                     /* @0x065CFA W-2 */

        /* inland walk: step WEST off the sea-lane column until a non-SeaLane
         * tile, stop no further west than column 2, then step one east.
         * @asm 0x065CA4..0x065CC0. */
        while (start_x > 2 &&
               (tile_read(g_layer_terrain, start_x, band_y) & 0x1F) == BASE_SEA_LANE)
            start_x--;                                          /* @0x065CB7 dec */
        start_x++;                                              /* @0x065CC0 inc */

        {
            uint8_t *rec = power_record(nation);                /* stride 0x13C */
            rec[PR_START_X] = (uint8_t)start_x;                 /* +0x32 (BYTE_VERIFIED) */
            rec[PR_START_Y] = (uint8_t)band_y;                  /* +0x33 (BYTE_VERIFIED) */
        }
    }
}
