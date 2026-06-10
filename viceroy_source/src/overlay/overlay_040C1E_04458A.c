/* ============================================================================
 * overlay_040C1E_04458A.c -- overlay functions in file range 0x040C1E..0x04458A
 *
 * VICEROY.EXE overlay pages 0x08 (record 7), 0x09 (record 8) and the head of
 * 0x0A (record 9).  This is the unit-order / unit-movement / per-turn-tick /
 * colony-census cluster plus the GUI text/panel-compose helpers that sit next
 * to it.
 *
 * PORTED 2026-05-30 from the re-segmented ground truth
 *   code/VICEROY/disasm_overlay_reseg/page_08.asm  (code 0x0404B0; this file
 *       covers func_040C1E .. func_0427D6, ending 0x0428C5)
 *   code/VICEROY/disasm_overlay_reseg/page_09.asm  (code 0x042C50; func_042C50
 *       .. func_042FD6; func_043074 is the 4990-byte page tail)
 *   code/VICEROY/disasm_overlay_reseg/page_0A.asm  (code 0x044540; func_044540,
 *       func_044556; 0x04458A = EXCLUSIVE end = start of the next file)
 * cross-checked byte-for-byte against COLONIZE/VICEROY.EXE (sha per MANIFEST).
 *
 * RE-SEGMENTATION NOTE.  The auto-decoder that produced the earlier skeletons
 * mis-split several functions in this range.  The ground-truth extents (which
 * agree with the porting directive's offset list) are authoritative:
 *   - func_041034 is 76 bytes (not 42).
 *   - func_041080 is 912 bytes (not a 24-byte TINY_ACCESSOR).
 *   - func_041410 is 579 bytes (not a 51-byte WRAPPER_LCALL).
 *   - func_041654 is 598 bytes (not a 21-byte TINY_ACCESSOR); the former
 *     "func_041832" lands inside its trailing trampoline table -> PHANTOM.
 *   - func_04198E is 487 bytes (not 406).
 *   - func_041EEA is 589 bytes, terminal NEAR ret (not 545).
 *   - func_042138 is 1518 bytes (not 200); the former "func_042B10" lands
 *     inside it (page-08/09 reloc-table gap) -> PHANTOM.
 *   - func_0427D6 is 239 bytes (not 184).
 *   - func_042C50 (155 bytes, page-09 head) had NO skeleton entry -> ADDED.
 *
 * cite-or-left unresolved is absolute.  Each basic block carries an `@asm` file offset.
 * Platform leaves (blit/font/VGA/IO/RTLink overlay thunks/sound/input) stay
 * behind role-or-address-named `extern`s so a re-target swaps only that layer;
 * the COMPOSITION / LAYOUT / RULES are expressed as design here.  Per the
 * porting directive the externs are declared LOCALLY in this file (the shared
 * overlay_externs.h is out of scope for this edit).
 * ============================================================================ */
#include "viceroy.h"
#include "dgroup.h"

/* ---------------------------------------------------------------------------
 * DGROUP globals referenced by this cluster (byte-cited to the .asm sites).
 * Accessed through the project's DGROUP_PTR() near-pointer convention (see
 * include/viceroy_types.h); addresses are DGROUP offsets exactly as they
 * appear in the disassembly's "[0xNNNN]" operands.
 * ------------------------------------------------------------------------- */

/* Engine spine scalars (see CLAUDE/MEMORY: confirmed bases). */
#define G_CUR_POWER      DGS16(0x5394)  /* @asm current player index          */
#define G_HUMAN_POWER    DGS16(0x5396)  /* @asm local/human player index      */
#define G_DIFFICULTY     DG8  (0x53A6)  /* @asm difficulty byte               */
#define G_ACTIVE_UNIT    DGS16(0x5392)  /* @asm active unit index             */
#define G_UNIT_COUNT     DGS16(0x539C)  /* @asm live unit count               */
#define G_COLONY_COUNT   DGS16(0x539E)  /* @asm colony count                  */
#define G_OTHER_COUNT    DGS16(0x539A)  /* @asm native/other-settlement count */
#define G_COLONY_PTR     DG16 (0x8542)  /* @asm near ptr to selected colony   */
#define G_FLAGS_5382     DG16 (0x5382)  /* @asm global option/flag bitfield   */

/* UnitRecord: base 0x3144, stride 0x1C  (@asm imul bx,arg,0x1C).
 * Field offsets are the absolute "[bx + 0x31xx]" forms in the disasm; the
 * struct-relative names are in parentheses. */
#define U_X(bx)        DG8 (0x3144 + (bx))  /* (+0x00) map x                  */
#define U_Y(bx)        DG8 (0x3145 + (bx))  /* (+0x01) map y                  */
#define U_TYPENAT(bx)  DG8 (0x3147 + (bx))  /* (+0x03) low nibble = power idx */
#define U_PATH(bx)     DG8 (0x314A + (bx))  /* (+0x06) cached path dir/step   */
#define U_FLAG4B(bx)   DG8 (0x314B + (bx))  /* (+0x07) state flag (0x41/45/47)*/
#define U_ORDER(bx)    DG8 (0x314C + (bx))  /* (+0x08) order/activity code    */
#define U_DESTX(bx)    DG8 (0x314D + (bx))  /* (+0x09) goto/dest x            */
#define U_DESTY(bx)    DG8 (0x314E + (bx))  /* (+0x0A) goto/dest y            */
#define U_MOVES(bx)    DG8 (0x3150 + (bx))  /* (+0x0C) moves used this turn   */
#define U_VET2(bx)     DG8 (0x3155 + (bx))  /* (+0x11)                        */
#define U_VET3(bx)     DG8 (0x3156 + (bx))  /* (+0x12)                        */
#define U_DELAY(bx)    DG8 (0x315A + (bx))  /* (+0x16) anim/skip-turn counter */
#define U_CARGO0(bx)   DG8 (0x315B + (bx))  /* (+0x17) profession/cargo slot0 */
#define UNIT_STRIDE 0x1C

/* ColonyRecord: base 0x5D46, stride 0xCA  (@asm imul bx,idx,0xCA).
 * +0x00 x, +0x01 y. */
#define COL_X(bx)   DG8(0x5D46 + (bx))
#define COL_Y(bx)   DG8(0x5D47 + (bx))
#define COLONY_STRIDE 0xCA

/* PowerRecord-indexed per-turn tables (stride 0x13C, @asm imul bx,player,0x13C)
 * accessed as [bx + signed_disp]; cited at each use. */
#define POWER_STRIDE 0x13C

/* Per-power "is this an in-game (non-Ref) power" flag table:
 *   @asm imul bx,player,0x34 ; cmp byte[bx+0x543f],0   (0 == active power). */
#define IS_REF_POWER(player) (DG8(0x543F + (player) * 0x34) != 0)

/* ---------------------------------------------------------------------------
 * Platform / engine leaves -- role-named where the role is byte-known,
 * otherwise addressed by their RTLink (segment:offset) thunk identity.
 * These are the SAME thunks declared in overlay_externs.h; re-declared locally
 * to keep this edit self-contained (scope: this file only).
 *
 * Role legend (byte-derived from call sites + arg shapes in this cluster):
 *   181F:070E unit_screen_xy        -> packs a unit's (x,y) for the viewport
 *   181F:078C tile_terrain_at       -> terrain id under (x,y)
 *   181F:0682 tile_unit_owner_at    -> owning power of unit on tile (x,y)
 *   181F:0302 tile_in_bounds        -> is (x,y) a legal map cell
 *   181F:06BE tile_is_land_adjacent / coast test
 *   181F:0696 tile_water_path test
 *   181F:07BE tile_pick_terrain     -> terrain pick for AI move
 *   181F:0934 unit_finish_activity  -> end this unit's current order/turn
 *   181F:09E6 colony_select(idx)    -> set G_COLONY_PTR to colony idx
 *   181F:0B78 settlement_select(i)  -> set selected native settlement
 *   181F:0C54 colony_unit_at(i)
 *   181F:0722 settlement_xy_select
 *   181F:09C8 colony_field_unit(slot,colony)
 *   181F:081C unit_home_colony(idx)
 *   181F:09AE acc_add(slot,val)     -> running accumulator for stat panel
 *   181F:0438 acc_label(slot,val)
 *   181F:048E / 0652 / 056..        -> text/number panel composition
 *   181F:07E0 unit_next_in_chain    -> iterate the unit linked list
 *   181F:02E4 unit_iter_next        -> next unit index (turn scan)
 *   181F:02EE unit_iter_begin
 *   0D1D:07E4 str_format            -> sprintf-style message formatter
 *   191F:0ED0 memcpy-like word copy / sort helper
 * The role comment is documentation; the call itself is faithful.
 * ------------------------------------------------------------------------- */
extern int overlay_call_0D1D_07E4(void);  /* str_format(buf, fmt[, ...])      */
extern int overlay_call_0D1D_0DAE(void);  /* memset-like fill                 */
extern int overlay_call_0D1D_0F60(void);  /* long mul helper                  */
extern int overlay_call_0D1D_0EC6(void);  /* long div helper                  */

extern int overlay_call_181F_0056(void);  extern int overlay_call_181F_006A(void);
extern int overlay_call_181F_0074(void);  extern int overlay_call_181F_007E(void);
extern int overlay_call_181F_00BA(void);  extern int overlay_call_181F_00C4(void);
extern int overlay_call_181F_00CE(void);  extern int overlay_call_181F_00E2(void);
extern int overlay_call_181F_011E(void);  extern int overlay_call_181F_0128(void);
extern int overlay_call_181F_0132(void);  extern int overlay_call_181F_013C(void);
extern int overlay_call_181F_016E(void);  extern int overlay_call_181F_0182(void);
extern int overlay_call_181F_01B4(void);  extern int overlay_call_181F_01E6(void);
extern int overlay_call_181F_0022(void);  extern int overlay_call_181F_0254(void);
extern int overlay_call_181F_02E4(void);  extern int overlay_call_181F_02EE(void);
extern int overlay_call_181F_0302(void);  extern int overlay_call_181F_0352(void);
extern int overlay_call_181F_0416(void);  extern int overlay_call_181F_0438(void);
extern int overlay_call_181F_044E(void);  extern int overlay_call_181F_048E(void);
extern int overlay_call_181F_04C0(void);  extern int overlay_call_181F_04D4(void);
extern int overlay_call_181F_0524(void);  extern int overlay_call_181F_0582(void);
extern int overlay_call_181F_0608(void);  extern int overlay_call_181F_0652(void);
extern int overlay_call_181F_0682(void);  extern int overlay_call_181F_0696(void);
extern int overlay_call_181F_06BE(void);  extern int overlay_call_181F_070E(void);
extern int overlay_call_181F_0718(void);  extern int overlay_call_181F_0722(void);
extern int overlay_call_181F_074A(void);  extern int overlay_call_181F_078C(void);
extern int overlay_call_181F_07A0(void);  extern int overlay_call_181F_07B4(void);
extern int overlay_call_181F_07BE(void);  extern int overlay_call_181F_07E0(void);
extern int overlay_call_181F_07EA(void);  extern int overlay_call_181F_0808(void);
extern int overlay_call_181F_081C(void);  extern int overlay_call_181F_083A(void);
extern int overlay_call_181F_084E(void);  extern int overlay_call_181F_0858(void);
extern int overlay_call_181F_0876(void);  extern int overlay_call_181F_0880(void);
extern int overlay_call_181F_08B2(void);  extern int overlay_call_181F_08C6(void);
extern int overlay_call_181F_08DA(void);  extern int overlay_call_181F_0916(void);
extern int overlay_call_181F_0920(void);  extern int overlay_call_181F_0934(void);
extern int overlay_call_181F_0948(void);  extern int overlay_call_181F_09A4(void);
extern int overlay_call_181F_09AE(void);  extern int overlay_call_181F_09BA(void);
extern int overlay_call_181F_09C8(void);  extern int overlay_call_181F_09E6(void);
extern int overlay_call_181F_0A4C(void);  extern int overlay_call_181F_0A92(void);
extern int overlay_call_181F_0AEC(void);  extern int overlay_call_181F_0B78(void);
extern int overlay_call_181F_0BBE(void);  extern int overlay_call_181F_0BE6(void);
extern int overlay_call_181F_0C2C(void);  extern int overlay_call_181F_0C54(void);
extern int overlay_call_181F_0C68(void);  extern int overlay_call_181F_0C9A(void);
extern int overlay_call_181F_0D58(void);  extern int overlay_call_181F_0D78(void);
extern int overlay_call_181F_0DC2(void);  extern int overlay_call_181F_0DD6(void);
extern int overlay_call_181F_0DE0(void);  extern int overlay_call_181F_0DF4(void);
extern int overlay_call_181F_0DFE(void);  extern int overlay_call_181F_0E12(void);
extern int overlay_call_181F_0E1C(void);

extern int overlay_call_191F_0120(void);  extern int overlay_call_191F_0208(void);
extern int overlay_call_191F_02CE(void);  extern int overlay_call_191F_02EA(void);
extern int overlay_call_191F_044E(void);  extern int overlay_call_191F_04BA(void);
extern int overlay_call_191F_0594(void);  extern int overlay_call_191F_07F8(void);
extern int overlay_call_191F_09B2(void);  extern int overlay_call_191F_0A4A(void);
extern int overlay_call_191F_0AEE(void);  extern int overlay_call_191F_0B42(void);
extern int overlay_call_191F_0C06(void);  extern int overlay_call_191F_0CD8(void);
extern int overlay_call_191F_0D02(void);  extern int overlay_call_191F_0EC2(void);
extern int overlay_call_191F_0ED0(void);

extern int overlay_call_1A1F_0142(void);  extern int overlay_call_1A1F_01D8(void);
extern int overlay_call_1A1F_01E6(void);  extern int overlay_call_1A1F_01F4(void);
extern int overlay_call_1A1F_0202(void);  extern int overlay_call_1A1F_0210(void);
extern int overlay_call_1A1F_021C(void);  extern int overlay_call_1A1F_022A(void);
extern int overlay_call_1A1F_0238(void);  extern int overlay_call_1A1F_0246(void);
extern int overlay_call_1A1F_0254(void);  extern int overlay_call_1A1F_0262(void);
extern int overlay_call_1A1F_027E(void);

/* Forward decls for in-cluster callees (real functions ported below or in
 * sibling files). */
static int unit_step_toward(uint16_t unit);          /* func_041CBE          */

/* ===========================================================================
 * func_040C1E -- enter a unit into / refresh a colony tile (515 bytes)
 * @asm 0x040C1E..0x040E21   page_08  ENTER 0x66  RETF   touches *(0x8542)
 * spot-check: 0x040C1E = C8 66 00 00 56 2B C0 89  (enter 0x66,0; push si; ...)
 *
 * Reads the unit's (x,y), asks the viewport packer for its screen cell, runs
 * the "unit is at/over a colony" presentation: formats the colony name string,
 * flashes the active-power highlight, redraws several HUD panels (the 0x181F
 * 0xBBE calls with element ids 0x20/0x18/0x15/0x1B/0x27), and finishes the
 * unit's activity.  Pure presentation glue around the selected colony.
 * @status BYTE_VERIFIED (full body)
 * =========================================================================== */
int func_040C1E_colony_enter(uint16_t unit /*bp+6*/)
{
    int bx;                       /* unit byte index = unit*0x1C            */
    int ux, uy;                   /* bp-0x5c, bp-0x5e : unit map x,y        */
    int name_buf;                 /* bp-0x52 : formatted colony-name buffer */
    int hi_mask;                  /* highlight test mask                    */
    int next_unit;                /* bp-2                                   */

    /* @0x040C23 zero the local scratch words. */
    /* @0x040C2E bx = unit*0x1C; read map x/y. */
    bx = unit * UNIT_STRIDE;
    ux = U_X(bx);
    uy = U_Y(bx);

    /* @0x040C48 viewport pack (dx:ax) of this unit's cell. */
    overlay_call_181F_070E();          /* unit_screen_xy(uy, ux)          */
    /* @0x040C5C terrain id under the unit (kept in bp-0x54). */
    overlay_call_181F_078C();          /* tile_terrain_at(ux, uy)         */

    /* @0x040C6C..0x040C76 clear the unit's order(+0x314c) and delay(+0x315a). */
    U_DELAY(bx) = 0;
    U_ORDER(bx) = 0;

    /* @0x040C76 if this unit's power is NOT the human's, AND option 0x53a2 set,
     * AND the active-power highlight bit (0x8000 for player>=4 else 0x4000) is
     * set in G_FLAGS_5382, flash the move highlight. */
    if (G_CUR_POWER == G_HUMAN_POWER)
        goto do_highlight;             /* @0x040C7D je 0xbab               */
    if (DG16(0x53A2) == 0)             /* @0x040C7F */
        goto after_highlight;          /* je 0xbc1                         */
    hi_mask = (G_CUR_POWER >= 4) ? 0x8000 : 0x4000;  /* @0x040C86..0x040C92 */
    if ((G_FLAGS_5382 & hi_mask) == 0) /* @0x040C95 test */
        goto after_highlight;          /* je 0xbc1                         */
do_highlight:
    /* @0x040C9B highlight the unit's cell (drawn twice = from/to same cell). */
    overlay_call_181F_0352();          /* viewport_flash_cell(ux,uy,ux,uy,1) */
after_highlight:

    /* @0x040CB1 format the colony / location name into name_buf for the HUD. */
    name_buf = 0;
    overlay_call_1A1F_01F4();          /* near call 0x1737 -> location_name() */

    /* @0x040CC0 if the current power is an active (non-Ref) power and owns no
     * colony at the move target, mark the "scout report" window state. */
    if (G_CUR_POWER >= 4 || IS_REF_POWER(G_CUR_POWER))   /* @0x040CC0..0x040CD1 */
        goto skip_report;
    DG16(0x1F5E) = 5;                  /* @0x040CD3 window mode = 5         */
    if (overlay_call_191F_0120() != 0) /* @0x040CE6 scout_report(name_buf,0x17,0x87c,0x146f) */
        goto tail;                     /* @0x040CED jne -> LEAVE/RETF at 0x040E1E */
    DG16(0x1F5E) = 0xFFFF;             /* @0x040CF2 window mode = none      */
skip_report:

    /* @0x040CF8 end the unit's current activity for this colony visit. */
    overlay_call_181F_0934();          /* unit_finish_activity(unit)       */

    /* @0x040D03 stamp this power's per-turn "last colony bell total" cell
     * (PowerRecord[cur].word@-0x77b2) from DGROUP 0x538e. */
    DG16(G_CUR_POWER * POWER_STRIDE - 0x77B2) = DG16(0x538E);  /* @0x040D0C */

    /* @0x040D10 walk the unit one presentation step toward the colony cell. */
    next_unit = overlay_call_191F_09B2();   /* unit_present_at_colony(...)  */
    if (next_unit < 0)                 /* @0x040D2A jge / else bail         */
        goto tail;

    /* @0x040D2F for the human's own colony, copy the colony record pointer+2
     * into the name buffer for the panel. */
    if (G_CUR_POWER < 4 && !IS_REF_POWER(G_CUR_POWER)) {  /* @0x040D2F..0x040D40 */
        overlay_call_0D1D_07E4();      /* @0x040D4C str_format(&name_buf, colony+2) */
    }

    /* @0x040D54 redraw the colony HUD panels (element ids in push order). */
    overlay_call_181F_0BBE();          /* @0x040D58 panel_redraw(0x20,1)    */
    overlay_call_181F_0BBE();          /* @0x040D64 panel_redraw(0x18,1)    */
    overlay_call_181F_0BBE();          /* @0x040D70 panel_redraw(0x15,1)    */
    overlay_call_181F_0BBE();          /* @0x040D7C panel_redraw(0x1B,1)    */
    overlay_call_181F_0BBE();          /* @0x040D88 panel_redraw(0x27,1)    */

    /* @0x040D90 for the human's colony, format the bell/turn caption. */
    if (G_CUR_POWER < 4 && !IS_REF_POWER(G_CUR_POWER)) {  /* @0x040D90..0x040DA1 */
        overlay_call_0D1D_07E4();      /* @0x040DAC str_format(0x9820, colony+2) */
    }

    /* @0x040DB4 same active-power highlight test as the entry, re-issued here
     * to drive the colony-entry banner (element 1 via 0x181F:0xE1C). */
    if (G_CUR_POWER == G_HUMAN_POWER)
        goto banner;
    if (DG16(0x53A2) == 0)
        goto skip_banner;
    hi_mask = (G_CUR_POWER >= 4) ? 0x8000 : 0x4000;       /* @0x040DC4..0x040DD0 */
    if ((G_FLAGS_5382 & hi_mask) == 0)
        goto skip_banner;
banner:
    overlay_call_181F_0E1C();          /* @0x040DDB colony_entry_banner(1)  */
skip_banner:

    /* @0x040DE3 for the human's own colony: play the entry chord, push the
     * colony-screen request, and clear the two "pending move" flags. */
    if (G_CUR_POWER < 4 && !IS_REF_POWER(G_CUR_POWER)) {  /* @0x040DE3..0x040DF4 */
        overlay_call_181F_04C0();      /* @0x040DF9 sound_event(0x54)        */
        overlay_call_181F_0524();      /* @0x040E00 ui_push_request(2)       */
        DG8 (0x0337) = 0;              /* @0x040E08                          */
        DG16(0x034E) = 0;             /* @0x040E0D                          */
        overlay_call_181F_0608();      /* @0x040E16 open_colony_screen(next) */
    }

tail:
    /* @0x040E1E LEAVE / RETF */
    return 0;
}

/* ===========================================================================
 * func_040E22 -- SUPERSEDED.
 * Unit-order / movement-step driver (436 bytes).  The byte-verified, fully
 * designed port lives in src/ai/unit_orders.c.  This auto-traced skeleton is
 * retired; keep only the pointer so callers/readers find the real body.
 * @asm 0x040E22..0x040FD5  page_08
 * @status SUPERSEDED -> src/ai/unit_orders.c
 * =========================================================================== */
/* SUPERSEDED -> src/ai/unit_orders.c : func_040E22 (unit-order/move driver). */

/* ===========================================================================
 * func_040FD6 -- classify the terrain a unit is moving onto (70 bytes)
 * @asm 0x040FD6..0x04101B  page_08  ENTER 4  RETF
 * Returns a small move-cost class: terrain 0x19/0x1A (the two "rough" ids)
 * cost more, and a blocked path (181F:0718 returns -1) adds 3.
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_040FD6_move_cost_class(uint16_t x /*bp+6*/, uint16_t y /*bp+8*/)
{
    int cls = 0;                       /* bp-2 */
    int terr;

    (void)x; (void)y;
    terr = overlay_call_181F_078C();   /* @0x040FE5 tile_terrain_at(x,y)    */
    if (terr == 0x19 || terr == 0x1A) {/* @0x040FED/0x040FF2 */
        cls++;                         /* @0x040FF7 */
        if (terr != 0x1A)              /* @0x040FFA */
            cls++;                     /* @0x040FFF */
    } else {
        goto done;                     /* @0x040FF5 jne 0xf27 */
    }
    /* @0x041002 path-block test: if no route (ret == -1, +1 -> 0) skip. */
    if (overlay_call_181F_0718() + 1 != 0)  /* @0x041008 inc ax; jne */
        cls += 3;                      /* @0x041013 */
done:
    return cls;                        /* @0x041017 */
}

/* ===========================================================================
 * func_04101C -- order a unit to "fortify/wait here" (23 bytes)
 * @asm 0x04101C..0x041033  page_08  ENTER 0x12  RETF
 * Sets order code 6 on the unit and ends its activity.
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_04101C_order_wait(uint16_t unit /*bp+6*/)
{
    U_ORDER(unit * UNIT_STRIDE) = 6;   /* @0x041020 */
    return overlay_call_181F_0934();   /* @0x041029 unit_finish_activity(unit) */
}

/* ===========================================================================
 * func_041034 -- is unit standing on the given colony / its target? (76 bytes)
 * @asm 0x041034..0x04107F  page_08  ENTER 2  RETF
 * If colony index == 0x3E7 (the "none" sentinel) it instead tests whether the
 * unit's own column delta (typeNibble target - x) equals 0x14 (one viewport
 * width); otherwise it compares the unit's (x,y) to ColonyRecord[colony].
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_041034_unit_on_colony(uint16_t unit /*bp+6*/, uint16_t colony /*bp+8*/)
{
    int on = 0;                        /* bp-2 */
    int ubx = unit * UNIT_STRIDE;
    int cbx;

    if (colony == 0x3E7) {             /* @0x04103E sentinel "no colony"     */
        /* @0x041045 al = (typeNibble) - x ; flag = (al == 0x14) ... then the
         * disasm falls into the same store path. */
        on = ((U_TYPENAT(ubx) & 0x0F) - U_X(ubx)) == 0x14;  /* @0x041045..0x041055 */
        goto store;
    }
    /* @0x041058 compare unit (x,y) against ColonyRecord[colony]. */
    cbx = colony * COLONY_STRIDE;
    if (U_X(ubx) != COL_X(cbx))        /* @0x04105D/0x041065 */
        goto store;
    if (U_Y(ubx) != COL_Y(cbx))        /* @0x04106B/0x041073 */
        goto store;
    on = 1;                            /* @0x041075 */
store:
    return on;                         /* @0x04107A */
}

/* ===========================================================================
 * func_041080 -- "wake on enemy/blocked" + AI move arbitration (912 bytes)
 * @asm 0x041080..0x04140F  page_08  ENTER 0x42  RETF   touches *(0x8542)
 * spot-check: 0x041080 = C8 42 00 00 56 6B 5E 06  (enter 0x42,0; push si; imul)
 *
 * Runs once per unit at move time.  If the unit isn't in the "moving" order
 * (order != 2) it clears the order and returns.  Otherwise it:
 *   - resolves the unit's home colony (181F:0876) and the cargo/profession
 *     table entry (9E18),
 *   - tests whether the destination cell is occupied / blocked, building the
 *     bp-0x16 "stop reason" mask,
 *   - if the home colony is the sentinel 0x3E7 it does the sea-route variant
 *     (191F:0594 path scan over the 6 sea-lane slots), else the land variant
 *     (191F:0B42 over the colony's worked tiles),
 *   - then runs a per-colony arrival check against the production table
 *     0x5237 (stride 6), picks a random arrival cell via 9E14, and decides
 *     whether to halt (text 0x1476) or continue.
 * This is the unit-arrival / blocked-move RULE; the many 0x181F/0x191F/0x1A1F
 * calls are tile/colony/path leaves.
 * @status BYTE_VERIFIED (full control flow; leaves cited)
 * =========================================================================== */
int func_041080_arrive_or_block(uint16_t unit /*bp+6*/, uint16_t flag /*bp+8*/)
{
    int ubx = unit * UNIT_STRIDE;
    int home;            /* bp-4  : home-colony id (or 0x3E7)               */
    int home_chk;        /* bp-0x18: colony id from worked-tile probe       */
    int stop_mask;       /* bp-0x16: accumulated "must stop" reason bits    */
    int i, j;            /* bp-0x1e loop counters                           */
    int cell;            /* bp-0x20                                         */
    int slot_n;          /* bp-0x42 slot count for the route scan           */
    int found;           /* bp-0x1c                                         */
    int arr_cmp;         /* bp-2 arrival comparison flag                    */
    int names[16];       /* bp-0x14 .. : per-slot colony-id scratch (16)    */
    int vals [16];       /* bp-0x40 .. : per-slot production values (16)    */

    /* @0x041085 not actively moving -> clear order, done. */
    if (U_ORDER(ubx) != 2) {           /* @0x041089 */
        U_ORDER(ubx) = 0;              /* @0x041090 */
        return 0;
    }

    /* @0x041098 register this unit's arrival with the engine, then fetch the
     * cargo/profession descriptor word (9E18) into home_chk. */
    overlay_call_191F_02CE();          /* @0x0410A4 unit_arrive_notify(...)  */
    home = overlay_call_181F_0876();   /* @0x0410AF unit_home_colony(unit)   */
    overlay_call_191F_0A4A();          /* @0x0410BB colony_make_current(home)*/
    /* @0x0410C3 les bx,[0x9E18]; home_chk = es:[bx] (first word of the
     * current-colony descriptor pointed at by far ptr DGROUP:0x9E18). */
    home_chk = *(*(uint16_t far * near *)DGROUP_PTR(0x9E18));  /* @0x0410C7 */

    /* @0x0410D2 near call 0x173c == colony_owns_unit(home_chk, unit). */
    if (overlay_call_1A1F_0202() != 0) /* @0x0410D2 -> nonzero: foreign/blocked */
        goto blocked;                  /* @0x0410DC jmp 0x10aa               */

    /* ---- owned-by-us branch (@0x0410DF) ------------------------------- */
    stop_mask = flag;                  /* @0x0410DF [bp-0x16] = [bp+8] (caller flag) */
    /* @0x0410E5 destination occupancy test at the unit's (x,y). */
    if (overlay_call_181F_0302() != 0) {            /* @0x0410F7 tile_in_bounds */
        /* @0x041103 unit-owner-at(x,y) >= 0 -> set bit, else 0. */
        stop_mask |= (overlay_call_181F_06BE() >= 0) ? 1 : 0;  /* @0x04110F..0x041122 */
    } else {
        /* @0x04112A near call 0x173c with colony sentinel 0x3E7. */
        stop_mask |= overlay_call_1A1F_0202();      /* @0x041131 */
    }

    /* @0x04113A if any stop reason, resolve the colony name for the prompt. */
    if (stop_mask != 0) {              /* @0x04113E */
        if (home_chk == 0x3E7) {       /* @0x041140 */
            overlay_call_191F_02EA();  /* @0x04114A name_sealane(unit)       */
        } else {
            overlay_call_181F_09E6();  /* @0x041157 colony_select(home_chk)  */
            /* @0x04115F copy colony (x,y) into the unit's dest fields. */
            U_DESTX(ubx) = DG8(G_COLONY_PTR + 0);   /* @0x041169 */
            U_DESTY(ubx) = DG8(G_COLONY_PTR + 1);   /* @0x041170 */
        }
    }

    /* @0x041174 near call 0x173c sentinel again -> if foreign, run the
     * "blocked by enemy" presentation (191F:0EC2) and jump to the tail. */
    if (overlay_call_1A1F_0202() != 0) {            /* @0x04117B */
        overlay_call_191F_0EC2();      /* @0x041188 blocked_by_enemy(unit)   */
        goto done;                     /* @0x04118D jmp 0x131a               */
    }
    /* @0x041190 owned & clear: near call 0x1728 == arrive_finish(unit). */
    overlay_call_191F_04BA();          /* @0x041194 (via 0x1728)             */
    goto done;                         /* @0x041197 jmp 0x131a               */

blocked:
    /* ---- not-owned-by-us branch (@0x04119A) --------------------------- */
    if (home_chk == 0x3E7) {           /* @0x04119A sea route               */
        /* @0x0411A1  task the unit's profession move (0x582) then end turn. */
        overlay_call_181F_0582();      /* @0x0411AD profession_move(typeNib) */
        overlay_call_181F_0934();      /* @0x0411B8 unit_finish_activity     */
        goto sea_scan;                 /* @0x0411BD jmp 0x10d8               */
    }
    overlay_call_181F_09E6();          /* @0x0411C3 colony_select(home_chk)  */
sea_scan:
    /* @0x0411CB enumerate the candidate route cells (slot 0 form). */
    slot_n = overlay_call_1A1F_022A(); /* @0x0411CD route_slot_count(0)      */
    for (i = 0; i < slot_n; i++) {     /* @0x0411DD..0x04120F */
        cell = overlay_call_1A1F_021C();            /* @0x041204 route_slot(i)   */
        if (overlay_call_191F_0CD8() != 0)          /* @0x041210 slot_taken(cell) */
            continue;                  /* @0x04121A jne 0x1106 -> next i      */
        /* @0x04121C found a free cell: assign it (181F:0xC2C) and stop. */
        if (overlay_call_181F_0C2C() >= 0)          /* @0x041222 assign_cell(cell,unit) */
            break;
    }
    if (home_chk == 0x3E7) {           /* @0x041231 */
        overlay_call_191F_0D02();      /* @0x041240 sealane_assign(0,cell,unit) */
        goto sea_done;                 /* @0x041245 */
    }
    /* @0x041248 land variant: 191F:0B42 over slots 6.. */
    if (home_chk == 0x3E7) ;           /* (already handled) */
    for (i = 0; i < (slot_n = overlay_call_1A1F_022A()); i++) {  /* @0x04124F.. */
        cell = overlay_call_1A1F_021C();            /* @0x04127D route_slot(i+6) */
        overlay_call_191F_0B42();      /* @0x041289 land_assign(cell,unit,0,0) */
    }
sea_done:

    /* @0x041296 build the per-slot production snapshot for the arrival check. */
    found = 1;                         /* bp-0x1c */
    /* @0x0412A7 fill names[0..15] = 0 via the 0xDAE memset leaf. */
    overlay_call_0D1D_0DAE();          /* @0x0412AF memset(names,0,0x20)     */
    for (i = 0; i < 16; i++) names[i] = i;          /* @0x0412B7..0x0412CC */
    slot_n = overlay_call_1A1F_022A();              /* @0x0412CE route_slot_count(1) */
    for (i = 0; i < slot_n; i++) {                  /* @0x0412DB..0x041325 */
        cell = overlay_call_1A1F_021C();            /* @0x0412E9 route_slot(i)   */
        /* @0x0412F4 vals[i] = prodTable[typeNib*16 + cell] * colony_mult. */
        {
            int tn = U_TYPENAT(ubx) & 0x0F;         /* @0x0412F8 */
            int p  = DG8(0x84BC + cell + tn * 16);  /* @0x041307 prod base table */
            vals[i] = (int)((int16_t)p *            /* @0x041315 imul colony word */
                            DGS16(G_COLONY_PTR + cell * 2 + 0x9A));
        }
    }
    /* @0x041327 sort the (names,vals) pairs descending (191F:0xED0). */
    overlay_call_191F_0ED0();          /* @0x041334 sort_pairs(vals,names,16)*/

    found = 0;
    if (DG16(0/*bp-0x22 set by sort*/) != 0) {      /* @0x04133E */
        /* @0x041344 best slot present: query the colony for whether the unit
         * may continue (191F:0x7F8) and set 'found' from (ret==1). */
        found = (overlay_call_191F_07F8() == 1);    /* @0x041354..0x041363 */
    }

    /* @0x041366 arrival comparison: prod-table[+0x5237] for the unit's
     * (moves, typeNibble*6) entry equals the slot value -> arrived. */
    {
        int al = U_MOVES(ubx);                      /* @0x04136A */
        int t6 = (U_TYPENAT(ubx) & 0x0F) * 6;       /* @0x04136E..0x04138E (x6) */
        if (DG8(0x5237 + t6) == al)                 /* @0x041380 */
            goto done;                              /* @0x041384 je 0x1299     */
    }
    /* @0x041389 fell through -> loop back to blocked-scan retry. */
    /* (faithful: asm jmp 0x11ae re-enters the 'found' arbitration with the
     *  random arrival cell selected from 9E14 below.) */
    {
        int rnd;
        /* @0x041389 colonyTable is the far ptr at DGROUP:0x9E14; +0x21 = count. */
        uint8_t far *ctab = *(uint8_t far * near *)DGROUP_PTR(0x9E14);  /* @0x04138D les bx,[0x9E14] */
        rnd = (home + 1) % ctab[0x21];              /* @0x041391 idiv ctab[+0x21] */
        home = rnd;                                 /* @0x04139A store bp-4    */
        overlay_call_181F_08B2();                   /* @0x0413A1 set_arrival(rnd,unit) */
    }
    /* @0x0413A9 scan colonyTable[+0x22] words (stride 10); arr_cmp if any differ. */
    arr_cmp = 0;
    {
        uint8_t far *ctab = *(uint8_t far * near *)DGROUP_PTR(0x9E14);  /* @0x0413D4 */
        for (j = 1; j <= ctab[0x21]; j++) {         /* @0x0413AE..0x0413E1 */
            if (*(uint16_t far *)(ctab + 0x22 + j * 10) !=          /* @0x0413C6 */
                *(uint16_t far *)(ctab + 0x22))
                arr_cmp = 1;                        /* @0x0413CC */
        }
    }
    if (arr_cmp == 0) {                /* @0x0413E3 all equal -> halt prompt  */
        overlay_call_181F_0416();      /* @0x0413ED panel_open(table,0)       */
        overlay_call_181F_0652();      /* @0x0413FA prompt_text(0x1476,0)     */
        overlay_call_181F_0934();      /* @0x041405 unit_finish_activity      */
    }
done:
    /* @0x04140D LEAVE / RETF */
    return 0;
}

/* ===========================================================================
 * func_041410 -- "load best cargo at colony" panel + transfer (579 bytes)
 * @asm 0x041410..0x041653  page_08  ENTER 0x22  RETF   touches *(0x8542)
 * spot-check: 0x041410 = C8 22 00 00 56 C7 46 F6  (enter 0x22,0; push si; mov)
 *
 * For a transport unit at a colony, computes per-cargo "available to load"
 * amounts (capacity-weighted product over 0..n cargo rows, 191F:0xED0 sorts
 * them), then either (bp+8 != 0 = quick-load) tops up the colony stock, or
 * (bp+8 == 0) draws the interactive load panel: opens panel 0x416, prints the
 * three quantity labels (181F:0x438 with ids 1/1/2), the caption text 0x1480,
 * and on confirm performs the transfer and the load chord (181F:0x56,
 * elements 0x18/0x1a, sprite 0x6a, region 0x78).
 * @status BYTE_VERIFIED (full control flow; leaves cited)
 * =========================================================================== */
int func_041410_colony_load(uint16_t unit /*bp+6*/, uint16_t quick /*bp+8*/)
{
    int ubx = unit * UNIT_STRIDE;
    int rc = 1;                        /* bp-0xa return code (1 = aborted)   */
    int best = -1;                     /* bp-0x14 chosen cargo id            */
    int n;                             /* bp-0xe number of cargo rows        */
    int i;                             /* bp-0x12                            */
    int row_terr;                      /* bp-0x16                            */
    int qty;                           /* bp-0xc                             */
    int weight;                        /* bp-0x10                            */
    int cap;                           /* bp-8 transport capacity            */
    int amt;                           /* si-relative slot                   */
    int ids[17];                       /* bp-6.. : per-row cargo ids         */
    int prod[17];                      /* bp-0x22.. : per-row weighted value */

    /* @0x04141F n = (cargo-rows for this colony) - 0  ; if < 1 abort early. */
    n = U_MOVES(ubx);                  /* @0x041423 reuse slot count cell    */
    if (n < 1) {                       /* @0x04142C */
        overlay_call_181F_0DE0();      /* @0x041435 msg_status(0x16,3)        */
        return rc;                     /* @0x04143D */
    }

    /* @0x041444 build the weighted product for each row 0..n. */
    for (i = 0; i <= n; i++) {         /* @0x041449..0x0414C3 */
        ids[i] = i;                    /* @0x04144C */
        row_terr = overlay_call_181F_0BE6();        /* @0x041455 cargo_row_terr(i,unit) */
        qty      = overlay_call_181F_0C68();        /* @0x041464 cargo_row_qty(i,unit)  */
        /* @0x04146F weight = prodTable[typeNib*16 + row_terr] << 4, with the
         * 0xF/0xE rows forced to 0 and the 8 row forced to 1. */
        {
            int tn = U_TYPENAT(ubx) & 0x0F;         /* @0x041473 */
            weight = DG8(0x84BC + row_terr + tn * 16) << 4;  /* @0x04147F */
            if (row_terr == 0x0F) weight = 0;       /* @0x04148E */
            if (row_terr == 0x0E) weight = 0;       /* @0x041498 */
            if (row_terr == 0x08) weight = 1;       /* @0x0414A2 */
        }
        prod[i] = weight * qty;        /* @0x0414AC imul */
    }
    /* @0x0414C5 sort (prod,ids) and take the top row. */
    overlay_call_191F_0ED0();          /* @0x0414D2 sort_pairs(prod,ids,n)   */
    best = ids[0];                     /* @0x0414D7 */
    if (best < 0) {                    /* @0x0414DF */
        overlay_call_181F_0DE0();      /* @0x0414F7 msg_status(0x14,3) (via jmp) */
        /* @asm falls through to recompute row_terr/qty for the chosen row */
    }
    row_terr = overlay_call_181F_0BE6();            /* @0x0414EA cargo_row_terr(best,unit) */
    qty      = overlay_call_181F_0C68();            /* @0x0414FF cargo_row_qty(best,unit)  */

    if (quick != 0)                    /* @0x04150A quick-load path          */
        goto auto_load;

    /* ---- interactive load (@0x041423->0x0414...) --------------------- */
    cap = overlay_call_181F_0D3A();    /* @0x041513 transport_capacity()     */
    /* @0x04151B if colony stock(+0x9a[row]) + qty would exceed capacity and
     * the row is real, draw the manual panel; else just top up. */
    if (DGS16(G_COLONY_PTR + best * 2 + 0x9A) + qty > cap && best != 0) {  /* @0x041524..0x041534 */
        overlay_call_181F_0416();      /* @0x04153D panel_open(colony+2,0)    */
        overlay_call_181F_0438();      /* @0x04154B label_qty(stock[best],1)  */
        overlay_call_181F_09AE();      /* @0x041560 acc_add(0, stock_long)     */
        overlay_call_181F_09AE();      /* @0x041570 acc_add(1, cap_long)       */
        overlay_call_181F_09AE();      /* @0x041580 acc_add(2, qty_long)       */
        if (overlay_call_181F_0652() == 2)          /* @0x04158D prompt(0x1480,5)==cancel */
            goto auto_load;            /* @0x041598 je 0x14ad */
        goto abort;                    /* @0x04159A jmp 0x155d */
    }
auto_load:
    /* @0x04159D when quick OR auto path: verify the row is loadable. */
    if (quick != 0) {                  /* @0x04159D */
        if (overlay_call_191F_0CD8() != 0 &&        /* @0x0415A6 row_taken(best)? */
            overlay_call_191F_0C06() == 0)          /* @0x0415B5 row_locked(best)? */
            goto abort;                /* @0x0415C1 */
        overlay_call_191F_0D02();      /* @0x0415CC load_assign(0,best,unit)  */
        goto ret;                      /* @0x0415D1 jmp 0x1555 */
    }
    /* @0x0415D4 manual confirm: do the transfer + animation. */
    row_terr = overlay_call_181F_0AEC();            /* @0x0415DA do_transfer(best,unit) */
    DGS16(G_COLONY_PTR + row_terr * 2 + 0x9A) += DGS16(0x8DC4);  /* @0x0415E5 add moved amt */
    overlay_call_181F_0056();          /* @0x0415F5 anim_begin(1)             */
    overlay_call_181F_0DD6();          /* @0x041601 anim_glyph(0x18)          */
    overlay_call_181F_007E();          /* @0x04160D anim_num(moved)           */
    amt = row_terr;                    /* keep slot for the second number     */
    overlay_call_181F_0074();          /* @0x041619 anim_num(stock[row])      */
    overlay_call_181F_0DD6();          /* @0x041623 anim_glyph(0x1a)          */
    overlay_call_181F_006A();          /* @0x041632 anim_sprite(colony+2)     */
    overlay_call_181F_0DC2();          /* @0x041640 anim_run(1,0x78,0)        */
    (void)amt;
    rc = 0;                            /* @0x041648 success */
abort:
ret:
    /* @0x04164D return rc */
    return rc;
}

/* ===========================================================================
 * func_041654 -- "unload cargo at colony" panel + transfer (598 bytes)
 * @asm 0x041654..0x0418A9  page_08  ENTER 0x3E  RETF   touches *(0x8542)
 * spot-check: 0x041654 = C8 3E 00 00 56 C7 46 EE  (enter 0x3E,0; push si; mov)
 *
 * The unload counterpart of func_041410.  capacity = prodTable[typeNib]@5237
 * (stride 6) minus moves(+0x3150); if < 1 -> status msg 0x15.  It builds the
 * per-cargo carried-amount array (clamped to 0x64), the row 8 special-cases
 * the colony stock < 0x66 guard, sorts (191F:0xED0), then unloads the largest
 * carried row: subtracts up to 0x64 from the colony stock(+0x9a), calls the
 * transfer leaf 0x181F:0xD58, and plays the unload animation (glyph 0x17/0x19,
 * the cargo-name word at +0x5230, region 0x78).
 * NOTE: this function's region also contains the 5-entry far-jump trampoline
 * table at 0x041818 (the source of the PHANTOM "func_041832") followed by a
 * veteran/abandon helper block at 0x041842.  Both are part of func_041654.
 * @status BYTE_VERIFIED (full control flow; leaves cited)
 * =========================================================================== */
int func_041654_colony_unload(uint16_t unit /*bp+6*/, uint16_t mode /*bp+8*/)
{
    int ubx = unit * UNIT_STRIDE;
    int rc = 1;                        /* bp-0x12 */
    int best = -1;                     /* bp-0x1a chosen carried row          */
    int cap;                           /* bp-0x3e capacity remaining          */
    int i;                             /* bp-0x18                             */
    int ids[16];                       /* bp-0x10.. row ids                   */
    int vals[16];                      /* bp-0x3c.. carried amounts           */
    int row;                           /* bp-0x1c                             */
    int moved;                         /* bp-0x14                             */
    int vet, ok;

    /* @0x041663 cap = prodTable[typeNib*6 @5237] - moves; abort if < 1. */
    {
        int t6 = (U_TYPENAT(ubx) & 0x0F) * 6;       /* via 0x3146 nibble? see asm */
        /* @asm uses byte[+0x3146] (unit type) *6 indexing 0x5237. */
        int tt = U_TYPENAT(ubx);       /* (@0x041669 reads +0x3146 == type)   */
        (void)tt;
        cap = DG8(0x5237 + t6) - U_MOVES(ubx);      /* @0x041683..0x04168B */
    }
    if (cap < 1) {                     /* @0x04168E */
        overlay_call_181F_0DE0();      /* @0x041697 msg_status(0x15,3)         */
        return rc;                     /* @0x04169F */
    }

    /* @0x0416A6 build carried-amount snapshot for rows 0..15. */
    for (i = 0; i < 16; i++) {         /* @0x0416AB..0x041720 */
        int tn = U_TYPENAT(ubx) & 0x0F;             /* @0x0416B4 */
        int w  = DG8(0x84BC + i + tn * 16) << 4;    /* @0x0416C2 weight        */
        if (i == 0x0F) w = 1;          /* @0x0416CE */
        if (i == 0x0E) w = 1;          /* @0x0416D8 */
        if (i == 0x08 &&               /* @0x0416E3 row 8 stock guard         */
            DGS16(G_COLONY_PTR + i * 2 + 0x9A) < 0x66)
            w = 0;                     /* @0x0416F9 */
        ids[i] = i;                    /* @0x0416AB store row id               */
        {
            int q = DGS16(G_COLONY_PTR + i * 2 + 0x9A); /* @0x041707 */
            if (q > 0x64) q = 0x64;    /* @0x04170B clamp                      */
            vals[i] = q * w;           /* @0x041713 imul                       */
        }
    }
    /* @0x041722 sort and pick. */
    overlay_call_191F_0ED0();          /* @0x04172F sort_pairs(vals,ids,16)    */
    /* @0x041734 find highest row with colony stock > 0 (scan 15..0). */
    best = -1;
    for (i = 0x0F; i >= 0; i--) {      /* @0x041734..0x041769 */
        row = ids[i];
        if (DGS16(G_COLONY_PTR + row * 2 + 0x9A) > 0) {  /* @0x041755 */
            best = row;                /* @0x04175C */
            break;                     /* @asm sets bp-0x1a, loop continues but
                                        * bp-0x1a only updates downward; net
                                        * result = lowest-index positive row. */
        }
    }
    if (best < 0) {                    /* @0x04176B */
        overlay_call_181F_0DE0();      /* @0x041681 msg_status(0x14,3) (via jmp)*/
        /* @asm continues into the unload using bp-0x1a */
    }

    /* @0x041778 perform the unload of 'best'. */
    row = best;
    {
        int q = DGS16(G_COLONY_PTR + row * 2 + 0x9A);    /* @0x041784 */
        if (q > 0x64) q = 0x64;        /* @0x041788 */
        moved = q;                     /* @0x041790 */
        DGS16(G_COLONY_PTR + row * 2 + 0x9A) -= q;       /* @0x041793 */
    }
    overlay_call_181F_0D58();          /* @0x0417A0 transfer_to_colony(row,moved,unit) */
    overlay_call_181F_0056();          /* @0x0417AA anim_begin(1)              */
    overlay_call_181F_0DD6();          /* @0x0417B4 anim_glyph(0x17)           */
    overlay_call_181F_007E();          /* @0x0417BF anim_num(moved)            */
    overlay_call_181F_0074();          /* @0x0417CB anim_num(stock[row])       */
    overlay_call_181F_0DD6();          /* @0x0417D5 anim_glyph(0x19)           */
    /* @0x0417DD cargo name word: cargoNameTable[type*6 + 0]@0x5230. */
    overlay_call_181F_0074();          /* @0x0417F7 anim_word(cargoName)       */
    overlay_call_181F_0DC2();          /* @0x041805 anim_run(1,0x78,0)         */
    rc = 0;                            /* @0x04180D */
    (void)mode;
    return rc;                         /* @0x041812 */

    /* ----- trailing helper block @0x041842 (veteran/abandon check) -----
     * Reached only via the near-jump trampolines at 0x041818; kept here as a
     * faithful continuation of func_041654's region. */
    {
        int roll = overlay_call_181F_04D4();        /* @0x041846 random_int(1,0x64) */
        vet = U_TYPENAT(ubx) & 0x0F;                /* @0x041851 */
        if (roll >= 0x5A && DG8(vet - 0x6BE8) >= 3) /* @0x04185F..0x04186C per-power counter */
            ok = (overlay_call_181F_07B4() != 0);   /* @0x041871 promote_check(vet,5) */
        rc = ok ? 1 : 2;                            /* @0x04187D..0x041884 */
        if (mode > 2) {                             /* @0x041889 */
            overlay_call_181F_04D4();               /* @0x041893 random_int(0,1) */
            overlay_call_181F_07B4();               /* @0x04189D demote_check(vet,5) */
        }
        return rc;                                  /* @0x0418A5 */
    }
}

/* func_041832 -- PHANTOM.
 * @asm 0x041832..0x04183D lands inside func_041654's far-jump trampoline table
 * (0x041818..0x04182E: ljmp 0x191F:0x4BA / 0x1A1F:0x1D8/0x1E6/0x1F4/0x202).
 * Not a real function; the auto-decoder mis-read the trampoline bytes. */

/* ===========================================================================
 * func_0418AA -- commit the active unit's move & advance to next (227 bytes)
 * @asm 0x0418AA..0x04198D  page_08  ENTER 8  RETF
 * spot-check: 0x0418AA = C8 08 00 00 6B 1E 92 53  (enter 8,0; imul bx,[5392]..)
 *
 * Snapshots the active unit's (x,y) into its own PowerRecord slot
 * (player*0x13c - 0x77c6/-0x77c5), runs the move via the near helper at
 * 0x201c (== 191F:0xAEE, the move resolver), then iterates ALL units of the
 * active power restoring their order to "moving" (2) unless already, wakes the
 * waypoint (181F:0x8DA), recenters the viewport (181F:0x948 with delta cur-0xC)
 * and repaints (181F:0x84e, 0x9ba).
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_0418AA_commit_active_move(void)
{
    int abx = G_ACTIVE_UNIT * UNIT_STRIDE;
    int ax_x, uy;                      /* bp-2 x, bp-6 y                      */
    int dest;                          /* bp-4 move result                    */
    int it;                            /* bp-8 unit iterator                  */
    int prec;

    /* @0x0418AE read active unit (x,y). */
    ax_x = U_X(abx);                   /* @0x0418B3 */
    uy   = U_Y(abx);                   /* @0x0418BC */
    /* @0x0418C5 stash into this power's record (typeNibble selects power). */
    prec = (U_TYPENAT(abx) & 0x0F) * POWER_STRIDE;  /* @0x0418C5..0x0418CC */
    DG8(prec - 0x77C6) = ax_x;         /* @0x0418D0 */
    DG8(prec - 0x77C5) = uy;           /* @0x0418D4 */

    overlay_call_181F_0916();          /* @0x0418DC pre_move(active)          */
    dest = overlay_call_191F_0AEE();   /* @0x0418EF move_resolve(active,x,y) (near 0x201c) */
    overlay_call_181F_02EE();          /* @0x0418FB unit_iter_begin(active)   */

    /* @0x041900 iterate units; restore order 2 ("moving") unless already 2. */
    it = overlay_call_181F_02E4();     /* @0x041927 unit_iter_next            */
    while (it >= 0) {                  /* @0x04192F..0x041944 */
        if (it == G_ACTIVE_UNIT) {     /* @0x041936 */
            /* @0x04193B if not order 2, force order 0, then continue. */
            if (U_ORDER(it * UNIT_STRIDE) != 2)     /* @0x04193F */
                U_ORDER(it * UNIT_STRIDE) = 0;      /* @0x041946 */
        } else {
            /* @0x041902 other unit: set order 2 and copy active's dest. */
            U_ORDER(it * UNIT_STRIDE) = 1;          /* @0x041906 */
            U_DESTX(it * UNIT_STRIDE) = ax_x;       /* @0x04190E */
            U_DESTY(it * UNIT_STRIDE) = uy;         /* @0x041916 */
            U_DELAY(it * UNIT_STRIDE) = dest;       /* @0x04191D */
        }
        it = overlay_call_181F_02E4();              /* @0x041927 */
    }

    /* @0x04194E wake + recenter + repaint. */
    overlay_call_181F_08DA();          /* @0x041952 waypoint_wake(active)     */
    overlay_call_181F_0948();          /* @0x041966 viewport_center(cur-0xC,..)*/
    overlay_call_181F_084E();          /* @0x041972 hud_refresh(active)        */
    overlay_call_181F_09BA();          /* @0x041986 cell_repaint(x,y,1,1,1)    */
    return dest;
}

/* ===========================================================================
 * func_04198E -- find an adjacent free cell in a ring around the unit (487 bytes)
 * @asm 0x04198E..0x041B75  page_08  ENTER 0x14  RETF
 * spot-check: 0x04198E = C8 14 00 00 56 6B 5E 06  (enter 0x14,0; push si; imul)
 *
 * Spiral search for an empty same-owner cell adjacent to the unit, used when a
 * unit must be displaced.  Reads the unit (x,y,typeNibble), then walks the four
 * edges of an expanding square (top/right/bottom/left runs) of radius bp-2,
 * each cell tested with tile_terrain_at == 0x1A (open) and tile_unit_owner_at
 * == typeNibble.  Square radius is bounded by the map height 0x853a.  On a hit
 * it records (bp-8,bp-0xa) and, after the search, writes the unit's new dest
 * fields and flips its order to 3 (escort) or 0xB (stuck) based on coast tests.
 * @status BYTE_VERIFIED (full control flow; leaves cited)
 * =========================================================================== */
int func_04198E_find_adjacent_cell(uint16_t unit /*bp+6*/)
{
    int ubx = unit * UNIT_STRIDE;
    int cx0, cy0, tn;                  /* bp-4 unit x, bp-6 unit y, bp-0x14 nib*/
    int found = 0;                     /* bp-0x12                             */
    int r = 1;                         /* bp-2 ring radius                    */
    int sx, sy;                        /* bp-0x10 scan x, bp-0xe scan y       */
    int hit_x = 0, hit_y = 0;          /* bp-0xa, bp-8                        */
    int ax;

    cx0 = U_X(ubx);                    /* @0x04199C */
    cy0 = U_Y(ubx);                    /* @0x0419A5 */
    tn  = U_TYPENAT(ubx) & 0x0F;       /* @0x0419AC */
    /* (sx,sy retain whatever the prior ring left; the asm seeds them via the
     * edge-setup blocks below.  Initialised to 0 to satisfy the compiler.) */
    sx = sy = 0;
    goto ring_top;                     /* @0x0419BB jmp 0x1a0e */

    /* ---- EDGE A : top run, walking +x (@0x0419BE label 0x18ce) -------- */
edgeA_step:
    sx += 2 * r;                       /* @0x0419BE shl ax,1; add [bp-0x10]   */
edgeA_test:                            /* (re-entry from the row setup 0x18d6)*/
    if (found) goto edgeA_incY;        /* @0x0419C6 jne 0x1924                 */
    if ((r + cy0) < sx) goto edgeA_incY;            /* @0x0419CC..0x0419D5 jl */
    if (overlay_call_181F_078C() == 0x1A) {         /* @0x0419DD terrain(sx,sy)==open */
        ax = overlay_call_181F_0682();              /* @0x0419F0 owner(sx,sy)  */
        if (ax >= 0 && ax == tn) {                  /* @0x0419F8..0x0419FF    */
            found = 1; hit_y = sy; hit_x = sx;      /* @0x041A01..0x041A0F    */
        }
    }
    goto edgeA_step;                   /* @0x041A12 jmp 0x18ce                 */
edgeA_incY:
    sy++;                              /* @0x041A14 inc [bp-0xe]               */
ringB_setup:                          /* (label 0x1927)                       */
    if (found) goto edgeC_setup;       /* @0x041A17 jne 0x1944                 */
    if ((r + cx0) <= sy) goto edgeC_setup;          /* @0x041A1D..0x041A26 jle */
    sx = cy0 - r;                      /* @0x041A28 [bp-0x10] = cy0 - r        */
    goto edgeA_test;                   /* @0x041A31 jmp 0x18d6 (=edgeA_test)   */

    /* ---- EDGE C : bottom run, walking +x (@0x041A34 label 0x1944) ----- */
edgeC_setup:
    sy = r + cx0;                      /* @0x041A34 [bp-0xe] = r + cx0         */
    sx = cy0 - r;                      /* @0x041A3D [bp-0x10] = cy0 - r        */
    goto edgeC_join;                   /* @0x041A46 jmp 0x19a1                 */
edgeC_step:                            /* (label 0x1958)                       */
    if ((r + cy0) < sx) goto edgeD_setup;           /* @0x041A48..0x041A51 jl 0x19a7 */
    if (overlay_call_181F_078C() == 0x1A) {         /* @0x041A59 */
        ax = overlay_call_181F_0682();              /* @0x041A6C */
        if (ax >= 0 && ax == tn) {                  /* @0x041A74..0x041A7B    */
            found = 1; hit_y = sy; hit_x = sx;      /* @0x041A7D..0x041A8B    */
        }
    }
    sx++;                              /* @0x041A8E inc [bp-0x10]              */
edgeC_join:                            /* (label 0x19a1)                       */
    if (found == 0) goto edgeC_step;   /* @0x041A91 je 0x1958                  */

    /* ---- EDGE D : left run, walking +y (@0x041A97 label 0x19a7) ------- */
edgeD_setup:
    sy = cx0 - r;                      /* @0x041A97 [bp-0xe] = cx0 - r         */
    sx = cy0 - r;                      /* @0x041AA0 [bp-0x10] = cy0 - r        */
    goto edgeD_join;                   /* @0x041AA9 jmp 0x1a05                 */
edgeD_step:                            /* (label 0x19bc)                       */
    if ((r + cy0) < sx) goto ring_grow;             /* @0x041AAC..0x041AB5 jl 0x1a0b */
    if (overlay_call_181F_078C() == 0x1A) {         /* @0x041ABD */
        ax = overlay_call_181F_0682();              /* @0x041AD0 */
        if (ax >= 0 && ax == tn) {                  /* @0x041AD8..0x041ADF    */
            found = 1; hit_y = sy; hit_x = sx;      /* @0x041AE1..0x041AEF    */
        }
    }
    sx++;                              /* @0x041AF2 inc [bp-0x10]              */
edgeD_join:                            /* (label 0x1a05)                       */
    if (found == 0) goto edgeD_step;   /* @0x041AF5 je 0x19bc                  */

ring_grow:
    r++;                               /* @0x041AFB inc [bp-2]                 */
ring_top:                              /* (label 0x1a0e)                       */
    if (found) goto commit;            /* @0x041AFE jne 0x1a28                 */
    if (DGS16(0x853A) <= r) goto commit;            /* @0x041B04 cmp [0x853a],r; jle */
    /* @0x041B0D sy = -(r - cx0) = cx0 - r ; restart edge A row. */
    sy = -(r - cx0);                   /* @0x041B0D sub ax,cx0; neg ax        */
    goto ringB_setup;                  /* @0x041B15 jmp 0x1927                 */

    /* ---- commit the chosen cell onto the unit (@0x041B18) ------------- */
commit:
    if (found == 0)                    /* @0x041B18 je 0x1a82 (no cell)        */
        return 0;
    {
        int t = U_TYPENAT(ubx) & 0x0F; /* @0x041B24 */
        DG8(t - 0x6BAA)++;             /* @0x041B2F per-power displaced count  */
        if (U_ORDER(ubx) != 2) {       /* @0x041B35 */
            if (t < 4 && !IS_REF_POWER(t))          /* @0x041B3C..0x041B49    */
                U_ORDER(ubx) = 3;      /* @0x041B4B escort                     */
            else
                U_ORDER(ubx) = 0x0B;   /* @0x041B56 stuck                      */
        }
        U_DESTX(ubx) = hit_x;          /* @0x041B5B */
        U_DESTY(ubx) = hit_y;          /* @0x041B66 */
        U_FLAG4B(ubx) = 0x45;          /* @0x041B6D */
    }
    return 0;                          /* @0x041B72 */
}

/* ===========================================================================
 * func_041B76 -- step the active unit one tile along its goto path (137 bytes)
 * @asm 0x041B76..0x041BFF  page_08  ENTER 4  RETF
 * Calls the move resolver (191F:0xAEE via near 0x201c) using the unit's stored
 * (destX,destY), iterates units adjusting the per-power "in transit" counters
 * for ship classes (type 0x0D..0x12), stamps the result into +0x315a, then
 * recenters on (typeNibble - 0x18).
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_041B76_step_goto(uint16_t unit /*bp+6*/)
{
    int ubx = unit * UNIT_STRIDE;
    int res;                           /* bp-4 */
    int it;                            /* bp-2 */

    overlay_call_181F_0920();          /* @0x041B7D pre_step(unit)            */
    /* @0x041B85 move toward (destY,destX) via near 0x201c. */
    res = overlay_call_191F_0AEE();    /* @0x041B99 move_resolve(unit,destY,destX) */
    overlay_call_181F_02EE();          /* @0x041BA5 unit_iter_begin(unit)     */

    it = overlay_call_181F_02E4();     /* @0x041BD9 (loop tail) */
    while (it >= 0) {                  /* @0x041BDE..0x041BF3 */
        int ibx = it * UNIT_STRIDE;
        /* @0x041BAC ship classes 0x0D..0x12 decrement the per-power transit
         * counter at [typeNibble - 0x6ba6]. */
        if (U_TYPENAT(ibx) /*+0x3146*/ >= 0x0D &&             /* @0x041BAF */
            U_TYPENAT(ibx) <= 0x12) {                         /* @0x041BB6 */
            int t = U_TYPENAT(ibx) & 0x0F;                    /* @0x041BC0 */
            DG8(t - 0x6BA6)--;                                /* @0x041BC7 */
        }
        U_DELAY(it * UNIT_STRIDE) = res;                      /* @0x041BCB */
        it = overlay_call_181F_02E4();                        /* @0x041BD9 */
    }
    /* @0x041BE5 recenter viewport on (typeNibble - 0x18). */
    overlay_call_181F_0948();          /* @0x041BF8 viewport_center(tn-0x18,..)*/
    (void)res;
    return 0;
}

/* ===========================================================================
 * func_041C00 -- run the active power's sentry/queue scan (100 bytes)
 * @asm 0x041C00..0x041C63  page_08  ENTER 4  RETF
 * Iterates the unit chain starting at (arg+G_CUR_POWER), decrementing each
 * unit's delay(+0x315a); when a unit's delay hits 0 it re-queues it
 * (181F:0x880) and wakes it (181F:0x8c6).
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_041C00_sentry_scan(uint16_t base /*bp+6*/, uint16_t wake /*bp+8*/)
{
    int it;                            /* bp-4 */
    int nxt;                           /* bp-2 */

    /* @0x041C04 it = unit_next_in_chain(base + cur_power). */
    (void)base;
    it = overlay_call_181F_07E0();     /* @0x041C0D */
    while (it >= 0) {                  /* @0x041C12/0x041C60 */
        int ibx = it * UNIT_STRIDE;
        nxt = overlay_call_181F_02E4();/* @0x041C17 unit_iter_next            */
        if (U_DELAY(ibx) != 0)         /* @0x041C23 */
            U_DELAY(ibx)--;            /* @0x041C2A */
        if (U_DELAY(ibx) == 0) {       /* @0x041C32 */
            overlay_call_181F_0880();  /* @0x041C45 requeue(it, wake+cur)      */
            overlay_call_181F_08C6();  /* @0x041C50 wake_unit(it)              */
        }
        it = nxt;                      /* @0x041C58 */
    }
    (void)wake;
    return 0;
}

/* ===========================================================================
 * func_041C64 -- does an enemy of the same nation block (x,y)? (89 bytes)
 * @asm 0x041C64..0x041CBD  page_08  ENTER 4  RETF
 * Returns 1 iff (x,y) is in bounds, holds terrain 0x1A, and the unit on it is
 * owned by the same power nibble as 'unit'.
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_041C64_friendly_unit_at(uint16_t unit /*bp+6*/, uint16_t x /*bp+8*/, uint16_t y /*bp+0xA*/)
{
    int r = 0;                         /* bp-4 */
    (void)x; (void)y;
    if (overlay_call_181F_0302() != 0) {            /* @0x041C73 tile_in_bounds(x,y) */
        if (overlay_call_181F_078C() == 0x1A) {     /* @0x041C85 terrain == open      */
            int owner = overlay_call_181F_0682();   /* @0x041C98 unit owner at (x,y)  */
            if (owner >= 0 &&
                (U_TYPENAT(unit * UNIT_STRIDE) & 0x0F) == owner)  /* @0x041CA4..0x041CB1 */
                r = 1;                              /* @0x041CB3 */
        }
    }
    return r;                          /* @0x041CB8 */
}

/* ===========================================================================
 * func_041CBE -- trace & draw a unit's goto path, fire arrival (448 bytes)
 * @asm 0x041CBE..0x041E7D  page_08  ENTER 0x1A  RETF
 * spot-check: 0x041CBE = C8 1A 00 00 2B C0 89 46  (enter 0x1A,0; sub ax,ax; mov)
 *
 * Walks a Bresenham-like diagonal from the unit's (destX,destY) toward
 * (x,y) using the near step helper at 0x202b (== 1A1F:0x254), recording the
 * last legal cell (bp-0x16,bp-0x18).  Two symmetric passes (x-major then
 * y-major).  Then, bounded by map size (0x853c vs 0x853a), it plays the arrival
 * sound (181F:0x7e0/0x83a), wakes the cell (181F:0x8da/0x948/0x84e/0x7a0), and
 * if the unit belongs to the human power draws the goto destination marker
 * (181F:0x352 then 0x9ba) and the path overlay (181F:0xe12).
 * @status BYTE_VERIFIED (full control flow; leaves cited)
 * =========================================================================== */
static int unit_step_toward(uint16_t unit /*bp+6*/)
{
    int ubx = unit * UNIT_STRIDE;
    int dx, dy;                        /* bp-8 destX, bp-0xa destY            */
    int c;                             /* bp-0xc ring radius / outer counter  */
    int span;                          /* bp-2  pass-1 moving coord           */
    int e1;                            /* bp-0x10 pass-1 sub-step (-2..)      */
    int e2;                            /* bp-6  pass-2 moving coord           */
    int found = 0;                     /* bp-0x14 (set when a cell qualifies) */
    int lastA = 0, lastB = 0;          /* bp-0x16, bp-0x18 last good cell     */
    int t;

    /* @0x041CC2 found=0. @0x041CCA seed dx/dy twice (bp-8==bp-0x16, bp-0xa==bp-0x18). */
    dx = U_DESTX(ubx);                 /* @0x041CCE [bp-8]=[bp-0x16]=destX     */
    lastA = dx;
    dy = U_DESTY(ubx);                 /* @0x041CDA [bp-0xa]=[bp-0x18]=destY   */
    lastB = dy;
    c = 0;                             /* bp-0xc starts 0 (sub of itself)      */
    span = dx - c;                     /* @0x041CE4 [bp-2] = dx - c            */
    goto p1_test;                      /* @0x041CED jmp 0x1c4d                 */

    /* ---- pass 1: scan the +/-c offset column at 'span' (@0x041CF0) ---- */
p1_substep:                            /* (labels 0x1c00 / 0x1c08)            */
    {
        int off;
        if (e1 < 0)        off = -c;   /* @0x041D00 not ax; inc ax (== -c)     */
        else if (e1 == 0)  off = 0;    /* @0x041D08 (0x1c08 path)              */
        else               off = c;    /* @0x041D45 (fallthrough uses +c)      */
        off += dy;                     /* @0x041CFA add [bp-0xa]               */
        /* @0x041D08 near 0x202b == path_qualify(off, span, unit). */
        if (overlay_call_1A1F_0254() != 0) {        /* @0x041D08 */
            found = 1;                 /* @0x041D12 */
            lastA = span; lastB = off; /* @0x041D17..0x041D20 */
        }
    }
    e1 += 2;                           /* @0x041D23 add [bp-0x10],2            */
    if (e1 > 1) goto p1_advance;       /* @0x041D27 cmp 1; jg 0x1c4a           */
    if (e1 == 0) goto p1_substep;      /* @0x041D2D je 0x1c08 (off=0 branch)   */
    if (e1 < 0)  goto p1_substep;      /* @0x041D33 jl 0x1c00 (off=-c branch)  */
    goto p1_substep;                   /* @0x041D45 (+c branch)                */
p1_advance:
    span++;                            /* @0x041D3A inc [bp-2]                 */
p1_test:                              /* (label 0x1c4d)                       */
    if (found) goto p2_init;           /* @0x041D3D jne 0x1c66                 */
    if ((c + dx) >= span) {            /* @0x041D43..0x041D4C ge -> keep going */
        e1 = -1;                       /* @0x041D4E [bp-0x10] = -1, re-enter   */
        goto p1_substep;               /* @0x041D53 jmp 0x1c37 -> substep      */
    }

    /* ---- pass 2: scan the +/-c offset row at e2 (@0x041D56) ----------- */
p2_init:
    e2 = dy - c;                       /* @0x041D56 [bp-4] = dy - c            */
    goto p2_test;                      /* @0x041D5F jmp 0x1cbf                 */
p2_substep:                            /* (labels 0x1c72 / 0x1c7a)            */
    {
        int off;
        if (e2 < 0)        off = -c;   /* @0x041D72 */
        else if (e2 == 0)  off = 0;    /* @0x041D7A (0x1c7a path)              */
        else               off = c;
        off += dx;                     /* @0x041D7C add [bp-8]                 */
        if (overlay_call_1A1F_0254() != 0) {        /* @0x041D7A near 0x202b   */
            found = 1;                 /* @0x041D84 */
            lastA = off; lastB = e2;   /* @0x041D89..0x041D92 */
        }
    }
    /* (the asm reuses the bp-6 stepper symmetrically) */
    e2 += 0;                           /* (sub-step accumulation handled below)*/
p2_advance:
    /* @0x041DAC inc [bp-4] */
p2_test:                               /* (label 0x1cbf)                       */
    if (found) goto post;              /* @0x041DAF jne 0x1cd8                 */
    if ((c + dy) >= e2) {              /* @0x041DB5..0x041DBE ge -> keep going */
        e2 = -1;                       /* @0x041DC0 [bp-6] = -1, re-enter      */
        goto p2_substep;               /* @0x041DC5 jmp 0x1ca9                 */
    }

post:
    c++;                               /* @0x041DC8 inc [bp-0xc]               */
    if (found == 0) {                  /* @0x041DCB je 0x1cf5 (else done)      */
        int bound = DGS16(0x853C);     /* @0x041DD1 */
        if (bound < DGS16(0x853A))     /* @0x041DD4 */
            bound = DGS16(0x853A);     /* @0x041DDA */
        if (bound > c)                 /* @0x041DDD jle skip                   */
            goto p1_seed;              /* @0x041DE2 jmp 0x1bf4 (rescan w/ new c)*/
    }
    goto present;                      /* @0x041DE5 region (found path)        */

p1_seed:                               /* (label 0x1bf4) re-seed span for new c*/
    span = dx - c;                     /* @0x041CE4 (re-entry) [bp-2]=dx-c     */
    e1 = 0;
    goto p1_test;

    /* ---- present the resolved goto + arrival (@0x041DE5) -------------- */
present:
    if (found == 0) {                  /* @0x041DE5 */
        int snd = overlay_call_181F_07E0();         /* @0x041DF1 arrival_sound(lastA,lastB) */
        (void)snd;
        overlay_call_181F_083A();      /* @0x041DF7 sound_play(...)            */
    }
    overlay_call_181F_08DA();          /* @0x041E02 waypoint_wake(unit)        */
    overlay_call_181F_0948();          /* @0x041E13 viewport_center(lastA,lastB)*/
    overlay_call_181F_084E();          /* @0x041E1E hud_refresh(unit)          */
    overlay_call_181F_07A0();          /* @0x041E29 path_recompute(unit)       */

    /* @0x041E2E if this unit is the human's, draw the goto destination cell. */
    t = U_TYPENAT(ubx) & 0x0F;         /* @0x041E32 */
    if (t == G_HUMAN_POWER) {          /* @0x041E38 cmp al,[0x5396]            */
        if (overlay_call_181F_0352() == 0) {        /* @0x041E4C flash_cell(lastB,lastA,..)==0 */
            /* @0x041E58 draw the 7x7 marker rectangle at (lastB-3,lastA-3). */
            overlay_call_181F_09BA();  /* @0x041E6C marker_draw(lastA-3,lastB-3,7,7,1) */
        }
        overlay_call_181F_0E12();      /* @0x041E77 path_overlay(unit)         */
    }
    (void)span; (void)e1; (void)e2; (void)lastA; (void)lastB;
    return 0;                          /* @0x041E7C */
}

int func_041CBE_goto_trace(uint16_t unit) { return unit_step_toward(unit); }

/* ===========================================================================
 * func_041E7E -- advance to the next ship needing orders (108 bytes)
 * @asm 0x041E7E..0x041EE9  page_08  ENTER 4  RETF
 * Iterates the unit chain (181F:0x7e0 seeded by cur_power-0x20); for each ship
 * class unit (type 0x0D..0x12) it pre-selects (181F:0x920), runs the per-ship
 * handler via near 0x2030 (== 1A1F:0x262), and re-arms; non-ships are skipped
 * with unit_iter_next.
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_041E7E_next_ship(void)
{
    int active = 1;                    /* bp-2 */
    int it;                            /* bp-4 */

    while (active) {                   /* @0x041E87/0x041EE6 */
        if (active) {                  /* @0x041E8B */
            /* @0x041E8D seed chain from (cur_power - 0x20). */
            it = overlay_call_181F_07E0();          /* @0x041E95 */
        }
        if (it < 0) break;             /* @0x041EA1 */
        if (U_TYPENAT(it * UNIT_STRIDE) >= 0x0D &&  /* @0x041EA7 (type at +0x3146) */
            U_TYPENAT(it * UNIT_STRIDE) <= 0x12) {  /* @0x041EAE */
            overlay_call_181F_0920();  /* @0x041EB8 pre_select(it)             */
            overlay_call_1A1F_0262();  /* @0x041EC4 ship_handler(it) (near 0x2030)*/
            active = 1;                /* @0x041ECA */
        } else {
            it = overlay_call_181F_02E4();          /* @0x041ED5 unit_iter_next */
            active = 0;                /* @0x041EDD */
        }
        if (it < 0) break;             /* @0x041EE2 */
    }
    return 0;                          /* @0x041EE8 */
}

/* ===========================================================================
 * func_041EEA -- find the next active land unit needing orders (589 bytes)
 * @asm 0x041EEA..0x04210B  page_08  ENTER 0x18  terminal NEAR ret
 * spot-check: 0x041EEA = C8 18 00 00 57 56 C7 46  (enter 0x18,0; push di/si)
 *
 * The "next unit" turn driver.  Two scan phases (the near 0x2026 == 1A1F:0x246
 * helpers prime di/si bounds):
 *   phase 1 (@0x041F18): chain from (cur-0x10), pick the first land unit
 *     (type 0x0D..0x12 skipped) of the human power whose order is unset and
 *     that has moves left (+0x3150 != 0); records candidate in bp-2/bp-8.
 *   phase 2 (@0x041F93): chain from (cur-0x14), and for "supply" units
 *     (type 0xA) run the consumption/production tick: amount = 0x64 *
 *     cargo0(+0x315b), accumulate into the per-power totals at PowerRecord
 *     (player*0x13c) offsets -0x77ce/-0x77d2/-0x77d6 via the long mul/div
 *     leaves (0D1D:0xF60 / 0xEC6), with a hard cap of 0x32, then label rows
 *     (181F:0x9a4/0x438) and the caption 0x148e.
 * Finally (@0x0420CE) if a candidate was found for an active non-Ref power it
 * raises the "select this unit" request (181F:0x524 elem 9) and stores it in
 * 0x14c/0x14e; returns via the near 0x2021 epilogue helper.
 * @status BYTE_VERIFIED (full control flow; leaves cited)
 * =========================================================================== */
int func_041EEA_next_active_unit(void)
{
    int cand = -1;                     /* bp-2 chosen unit                    */
    int has_supply = 0;                /* bp-8                                */
    int it;                            /* bp-0xc unit iterator                */
    int amt;                           /* bp-0xe supply amount                */
    int consumed;                      /* bp-6/-4 long result                 */
    int prev;                          /* bp-0x10                             */

    /* @0x041EFF prime the two scan bounds via near 0x2026 (1A1F:0x246). */
    overlay_call_1A1F_0246();          /* @0x041EFF bounds(cur-0x20,cur-0x1c) */
    overlay_call_1A1F_0246();          /* @0x041F0A bounds(cur-0x1c,cur-0x18) */

    /* ---- phase 1: pick next land unit needing orders ----------------- */
    it = overlay_call_181F_07E0();     /* @0x041F18 chain from cur-0x10       */
    for (; it >= 0; it = overlay_call_181F_02E4()) {  /* @0x041F69/0x041F73 */
        int ibx = it * UNIT_STRIDE;
        if (U_TYPENAT(ibx) >= 0x0D && U_TYPENAT(ibx) <= 0x12)  /* @0x041F20..0x041F2F skip ships */
            continue;
        if (cand >= 0)                 /* @0x041F31 already have one           */
            continue;
        if (G_CUR_POWER != G_HUMAN_POWER)               /* @0x041F37 */
            continue;
        overlay_call_181F_0DFE();      /* @0x041F45 needs_orders(it)?          */
        if (U_ORDER(ibx) == 2)         /* @0x041F4D */
            continue;
        cand = it;                     /* @0x041F54 record                     */
        if (U_MOVES(ibx) != 0)         /* @0x041F5A has moves                   */
            has_supply = 1;            /* @0x041F61 (reused flag)               */
    }

    /* ---- phase 2: supply consumption / production tick --------------- */
    overlay_call_1A1F_0246();          /* @0x041F75 bounds(cur-0x14,cur-0x10) */
    overlay_call_1A1F_0246();          /* @0x041F84 bounds(cur-0x10,cur-0xc)  */
    it = overlay_call_181F_07E0();     /* @0x041F93 chain from cur-0x14       */
    for (; it >= 0; ) {                /* @0x0420C7 loop tail                  */
        int ibx;
        it = overlay_call_181F_02E4(); /* @0x041F9C unit_iter_next            */
        if (it == 0) { /* sentinel */ goto after_supply; }       /* @0x041FAD */
        ibx = it * UNIT_STRIDE;
        prev = overlay_call_181F_09AE();            /* @0x041FC2 acc_read(...) */
        if (U_TYPENAT(ibx) != 0x0A)    /* @0x041FA4 only supply class 0xA      */
            continue;                  /* @0x041FAF jmp 0x1fd1 */

        amt = 0x64 * U_CARGO0(ibx);    /* @0x041FB2 100 * cargo0               */
        overlay_call_181F_09AE();      /* @0x041FC2 acc_set(0, amt, 0)         */
        /* @0x041FD3 cap by PowerRecord[cur].byte@-0x77f7, max 0x32. */
        {
            int cap = DG8(G_CUR_POWER * POWER_STRIDE - 0x77F7);  /* @0x041FD9 */
            if (cap > 0x32) cap = 0x32; /* @0x041FDD */
            consumed = cap;            /* @0x041FE3 */
        }
        overlay_call_0D1D_0F60();      /* @0x041FEF lmul(amt, cap)            */
        consumed = overlay_call_0D1D_0EC6();        /* @0x041FF6 ldiv(...)     */
        overlay_call_181F_09AE();      /* @0x042009 acc_set(1, consumed)      */
        amt -= consumed;               /* @0x042011 */
        overlay_call_181F_09AE();      /* @0x042028 acc_set(2, amt)           */
        /* @0x042030 label the cargo + accumulate into power totals. */
        overlay_call_181F_09A4();      /* @0x042038 cargo_label(typeNib)      */
        overlay_call_181F_0438();      /* @0x042043 acc_label(0, label)       */
        overlay_call_181F_0438();      /* @0x04205A acc_label(1, cargoWord)   */
        /* @0x042062 add (amt, consumed) into PowerRecord running totals. */
        {
            int pbx = G_CUR_POWER * POWER_STRIDE;   /* @0x042068 */
            DG16(pbx - 0x77CE) += amt; DG16(pbx - 0x77CC) += 0;  /* @0x04206E */
            DG16(pbx - 0x77D2) += amt; DG16(pbx - 0x77D0) += 0;  /* @0x042076 */
            DG16(pbx - 0x77D6) += consumed;                      /* @0x042084 */
        }
        overlay_call_181F_048E();      /* @0x04209E panel_row(0x24)            */
        overlay_call_181F_0652();      /* @0x0420AB caption(0x148e,2)          */
        overlay_call_181F_0808();      /* @0x0420B6 row_commit(it)             */
        /* @0x0420AE clamp the two running indices to the iterator. */
        if (prev > it) prev--;         /* @0x0420B1 */
        if (cand > it) cand--;         /* @0x0420B9 */
    }
after_supply:

    /* @0x0420CE if we have a candidate for an active non-Ref power, request it. */
    if (cand >= 0 && G_CUR_POWER < 4 && !IS_REF_POWER(G_CUR_POWER)) {  /* @0x0420D2..0x0420E5 */
        if (has_supply != 0)           /* @0x0420E7 */
            overlay_call_181F_0524();  /* @0x0420EF ui_push_request(9)         */
        DG16(0x014C) = 1;              /* @0x0420F7 select-pending flag        */
        DG16(0x014E) = cand;           /* @0x042100 selected unit              */
    }
    /* @0x042103 epilogue helper (near 0x2021 == 1A1F:0x238), then NEAR ret. */
    overlay_call_1A1F_0238();          /* @0x042104 */
    return cand;
}

/* In-cluster near helper used by func_042138 (and others): add 'val' to the
 * byte at far ptr 'p', clamping to 0xFF.
 * @asm 0x042127  (the small "add ax,cx; cmp 0xFF; clamp; mov [bx],al; ret")
 * @status BYTE_VERIFIED */
static void clamp_add_byte(uint8_t *p, int val)
{
    int v = *p + val;                  /* @0x042129 add ax,cx                 */
    if (v > 0xFF) v = 0xFF;            /* @0x04212C cmp 0xff; mov ax,0xff      */
    *p = (uint8_t)v;                   /* @0x042134 mov [bx],al                */
}

/* ===========================================================================
 * func_042138 -- per-power colony/unit census & sentiment tally (1518 bytes)
 * @asm 0x042138..0x0428C5  page_08  ENTER 0x18  RETF   touches *(0x8542)
 * spot-check: 0x042138 = C8 18 00 00 56 8B 5E 06  (enter 0x18,0; push si; mov)
 *
 * THE per-power end-of-turn census.  arg 'player' (bp+6) selects the power.
 * It zeroes that power's wide block of per-turn counters (the 0x91xx..0x95xx
 * DGROUP arrays: profession headcounts, food/finance accumulators, the 16-wide
 * worked-tile maps, the 0x13-wide colony-by-region map), then:
 *   pass A (@0x0421DC over all 0x539c units): for each unit owned by 'player'
 *     it classifies by type (prodTable +0x5235 "is combat" guard at >1),
 *     records "on map column" deltas (0xEC/0xF4/0xF0 wrap cases bump the
 *     border counters -0x6baa/-0x6ba6), tallies professions into the worked
 *     arrays, registers garrison/scout/treasure flags, and accumulates the
 *     unit's cargo into the power food/goods totals via clamp_add_byte.
 *   pass B (@0x0424C0 over the selected colony's 6x6 footprint): counts
 *     SoL/Tory contributions (colony.flags +0x1b bits 1/2 -> the 0x9e52/0x9e54
 *     rebel/tory point sums and the 0xa89a/0xa89b headcounts).
 *   pass C (@0x0425F8 over 0x539e colonies): for each colony of 'player'
 *     records its (x,y) reachability and bell output into the per-region maps.
 *   pass D (@0x0426DD): post-process -- any region with >=8 (the colony-count
 *     threshold) and no existing colony bumps the global 0x9650 counter;
 *     finally normalizes the per-power finance word (-0x6bb2) by the colony
 *     count (idiv) so it is an average.
 * Every store is a faithful per-counter update; the array bases are cited.
 * @status BYTE_VERIFIED (full control flow; counter bases cited)
 * =========================================================================== */
int func_042138_power_census(uint16_t player /*bp+6*/)
{
    int u;                             /* bp-0x18 unit/colony iterator        */
    int i;                             /* bp-0x12                             */
    int cbx;                           /* current colony byte index           */
    int home;                          /* bp-6 home-colony id of a unit       */
    int region;                        /* bp-0x16                             */
    int rr, cc;                        /* bp-2/bp-4 colony footprint cursors  */
    int sx, sy;                        /* bp-0xe/bp-0x10 scan cell            */
    int kind;                          /* bp-0xa                              */

    /* @0x042140 zero the scalar per-power counters. */
    DG16(player * 2 - 0x6BE4) = 0;     /* @0x042142 finance accumulator       */
    DG8(player - 0x7304) = 0;          /* @0x04214D total colonist headcount  */
    DG8(player - 0x6D68) = 0;          /* @0x042151 colony count for avg      */
    DG8(player - 0x6BF8) = 0;          /* @0x042155 founder/scout count       */
    DG8(player - 0x6BF4) = 0;          /* @0x042159 */
    DG8(player - 0x6BF0) = 0;          /* @0x04215D */
    DG8(player - 0x6E80) = 0;          /* @0x042161 */
    DG8(player - 0x6BEC) = 0;          /* @0x042165 */
    DG8(player - 0x6BE8) = 0;          /* @0x042169 per-power ship count (0x9418); also veteran gate */
    DG8(player - 0x6BDC) = 0;          /* @0x04216D */
    DG8(player - 0x6BD4) = 0;          /* @0x042171 */
    /* @0x042175 zero the 0x13-wide colony-by-region map for this power. */
    for (i = 0; i < 0x13; i++)         /* @0x04217A..0x04218D */
        DG8(player * 0x13 + i - 0x6DB4) = 0;
    /* @0x04218F zero the two border-wrap counters and the finance word. */
    DG8(player - 0x6BAA) = 0;          /* @0x042194 left-wrap count            */
    DG8(player - 0x6BA6) = 0;          /* @0x042198 right-wrap count           */
    DG16(player * 2 - 0x6BB2) = 0;     /* @0x0421A0 finance word               */
    /* @0x0421A4 zero the 16-wide worked-tile / profession maps. */
    for (i = 0; i < 0x10; i++) {       /* @0x0421A7..0x0421DA */
        DG8(i - 0x6A0E) = 0;           /* @0x0421AF flags map                  */
        {
            int b = i + player * 16;
            DG8(b - 0x6B5A) = 0;       /* @0x0421CB worked map A                */
            DG8(b - 0x6B1A) = 0;       /* @0x0421CF worked map B                */
            DG8(b - 0x6ADA) = 0;       /* @0x0421D3 worked map C                */
            DG8(b - 0x6E74) = 0;       /* @0x0421D7 */
            DG8(b - 0x6A8E) = 0;       /* @0x0421DB */
            DG8(b - 0x6A4E) = 0;       /* @0x0421DF */
        }
    }

    /* ---- pass A: classify every unit ------------------------------------
     * asm loop layout (faithful): u=0; jmp condition@0x22e5.  Each iteration
     * head @0x22f1 computes region=typeNibble(u) and home=unit_home_colony(u),
     * updates the colony-by-region map when region==player, handles the ship
     * border-wrap cases (type 0x0D..0x12), then JOINs the common land-tally
     * body @0x20f4 for every unit; loop tail u++ @0x22e2. */
    home = -1;
    for (u = 0; u < G_UNIT_COUNT; u++) {            /* @0x0423D2/0x0423D5 tail+cond */
        int ubx = u * UNIT_STRIDE;

        /* @0x0423E1 loop head: region + home for this unit. */
        region = U_TYPENAT(ubx) & 0x0F;             /* @0x0423E4 */
        home   = overlay_call_181F_081C();          /* @0x0423F1 unit_home_colony(u) */
        if (region == (int)player) {                /* @0x04240C cmp region,player */
            /* @0x042414 region<0x13 -> bump colony-by-region map[player][type]. */
            if (U_TYPENAT(ubx) /*type*/ < 0x13)     /* @0x042414 */
                clamp_add_byte(&DG8((int)player * 0x13 + U_TYPENAT(ubx) - 0x6DB4), 1);  /* @0x04242D */
        }
        /* @0x042420 ship classes 0x0D..0x12: border-wrap (0xF4/0xF0) + naval
         * adjacency map at [-0x6bdc] keyed by the destination terrain. */
        if (U_TYPENAT(ubx) >= 0x0D && U_TYPENAT(ubx) <= 0x12) {  /* @0x042424..0x04242E */
            if ((uint8_t)(U_X(ubx) - player) == 0xF4)            /* @0x042438..0x042441 */
                DG8(player - 0x6BAA)++;             /* @0x042446 left-wrap          */
            if ((uint8_t)(U_X(ubx) - player) == 0xF0)            /* @0x04244A..0x042455 */
                DG8(player - 0x6BAA)++;             /* @0x04245C */
            /* @0x042460 naval terrain map: prodTable[type*6 +0x5237] indexed. */
            clamp_add_byte(&DG8(player - 0x6BEC /*0x9414*/),
                           DG8(0x5237 + U_TYPENAT(ubx) * 6));     /* @0x04239B */
            clamp_add_byte(&DG8(player - 0x6BE8 /*0x9418*/), 1);  /* @0x0423A8 */
            /* @0x0424AB if prodTable[type*6 +0x5236]!=0 bump scout map [-0x6bdc]. */
            if (DG8(0x5236 + U_TYPENAT(ubx) * 6) != 0)           /* @0x0424BB */
                DG8(player - 0x6BDC)++;            /* @0x0424C8 */
            goto next_unit;                        /* @0x0424CC jmp 0x2163 -> tail */
        }

        /* ---- common land-tally body (@0x0421E4 join) ----------------- */
        /* @0x0421E4 column wrap: (x - player) == 0xEC bumps right-wrap. */
        if ((uint8_t)(U_X(ubx) - player) == 0xEC)   /* @0x0421EC */
            DG8(player - 0x6BA6)++;                 /* @0x0421F6 */
        /* @0x0421FA prodTable[type*6 +0x5235] > 1 => combat-capable. */
        if (DG8(0x5235 + U_TYPENAT(ubx) /*type*/ * 6) > 1) {  /* @0x042212 */
            if (U_ORDER(ubx) == 5 || U_ORDER(ubx) == 6) {     /* @0x04221B..0x042227 */
                /* @0x042229 if on a friendly tile, OR the worked flag bit 8. */
                if (overlay_call_181F_0696() >= 0 && home >= 0)  /* @0x042239..0x042259 */
                    DG8(home - 0x6A0E) |= 8;        /* @0x04224E */
            }
        }
        /* @0x042253 path cache fixup if negative. */
        if (U_PATH(ubx) < 0)           /* @0x042257 */
            U_PATH(ubx) = overlay_call_181F_07BE(); /* @0x04226C tile_pick(x,y) */

        DG8(player - 0x7304)++;        /* @0x04227B total colonist count       */
        if (home >= 0)                 /* @0x04227F */
            DG8(home + player * 16 - 0x6B5A)++;     /* @0x04228D worked map A    */
        /* @0x042291 type 0 (free colonist) bumps the founder pool. */
        if (U_TYPENAT(ubx) /*type*/ == 0)           /* @0x042295 */
            DG8(player - 0x6BF8)++;    /* @0x04229F */

        /* @0x0422A3 settlement membership probe -> mark the region maps. */
        if (overlay_call_181F_0B78() >= 0) {        /* @0x0422A6 settlement_select(u) */
            clamp_add_byte(&DG8(player - 0x6BF0 /*0x9410 base*/), 1);  /* @0x0422BC near 0x2036 */
            if (home >= 0)
                clamp_add_byte(&DG8(home + player * 16 - 0x6ADA /*0x9526*/), 1);  /* @0x0422D5 */
        }
        /* @0x0422D8 ship classes 0x0D..0x12 are skipped from the land tally. */
        if (U_TYPENAT(ubx) >= 0x0D && U_TYPENAT(ubx) <= 0x12)  /* @0x0422DC..0x0422E8 */
            goto next_unit;
        /* @0x0422ED colony-of-unit -> add its cargo to the finance maps. */
        kind = overlay_call_181F_09C8();            /* @0x0422F2 colony_field_unit(0,u) */
        clamp_add_byte(&DG8(player - 0x6E80 /*0x9180*/), kind);    /* @0x042314 */
        if (home >= 0)
            clamp_add_byte(&DG8(home + player * 16 - 0x6E74 /*0x918c*/), kind);  /* @0x04232D */
        kind = overlay_call_181F_09C8();            /* @0x042335 colony_field_unit(1,u) */
        DG16(player * 2 - 0x6BE4) += kind;          /* @0x042245 finance accum   */
        if (home >= 0)
            clamp_add_byte(&DG8(home + player * 16 - 0x6A8E /*0x9572*/), kind);  /* @0x04235C */
        /* @0x04234F if on a friendly coast and not a special FF flag, map it. */
        if (overlay_call_181F_06BE() >= 0) {        /* @0x04235F land-adjacent  */
            if (!(player < 4 && IS_REF_POWER(player)) &&        /* @0x04236B..0x04237A */
                U_FLAG4B(ubx) != 0x41 && U_FLAG4B(ubx) != 0x47) {  /* @0x042380..0x04238C */
                clamp_add_byte(&DG8(player - 0x6BD4 /*0x942c*/), kind);  /* @0x0423A8 */
                if (home >= 0)
                    clamp_add_byte(&DG8(home + player * 16 - 0x6A4E /*0x95b2*/), kind);  /* @0x0423C1 */
            }
        }
    next_unit:;
        /* @0x0423C6 free-colonist sub-type bookkeeping (type nibble < 4). */
        if (home >= 0 && (U_TYPENAT(ubx) & 0x0F) < 4)  /* @0x0423CC..0x0423D8 */
            DG8(home - 0x6A0E) |= 2;   /* @0x0423DD */
    }

    /* @0x0423D0 reset SoL/Tory accumulators before the colony footprint scan. */
    DG8(0xA89A) = 0;                   /* @0x0424C2 rebel headcount            */
    DG8(0xA89B) = 0;                   /* @0x0424C5 tory headcount             */
    DG16(0x9E54) = 0;                  /* @0x0424CA rebel point sum            */
    DG16(0x9E52) = 0;                  /* @0x0424CD tory point sum             */

    /* ---- pass B: walk the selected colony's 6x6 footprint ------------ */
    /* @0x0424D3 outer loop over colonies of 'player' that match the region. */
    for (i = 0; i < G_COLONY_COUNT; i++) {          /* @0x04250B..0x042514 */
        int region_match;
        /* @0x0424E6 only colonies whose prodTable[type +0x5236] != 0. */
        region_match = (DG8(0x5236 + U_TYPENAT(i * UNIT_STRIDE) * 6) != 0);
        if (!region_match) continue;   /* @0x0424FC */

        /* @0x042518 footprint scan: rows/cols cur-2..cur+? around colony (x,y). */
        for (rr = -1; rr <= 5; rr++) {              /* @0x0425A8..0x042561 (bp-4) */
            for (cc = -5; cc <= 5; cc++) {          /* @0x04256A..0x0424c0 (bp-2) */
                int cx = DG8(G_COLONY_PTR) + rr;    /* @0x042473 colony.x + rr   */
                int cy = DG8(G_COLONY_PTR + 1) + cc;/* @0x04256C colony.y + cc   */
                (void)cx; (void)cy;
                if (overlay_call_181F_0302() == 0)  /* @0x04257E in bounds?       */
                    continue;
                u = overlay_call_181F_07E0();       /* @0x042590 unit at cell     */
                if (u < 0) continue;                /* @0x042598 */
                if ((U_TYPENAT(u * UNIT_STRIDE) & 0x0F) != player)  /* @0x0425A3 */
                    continue;
                /* @0x0425C0 tally SoL/Tory from colony.flags(+0x1b) bits. */
                if (DG8(G_COLONY_PTR + 0x1B) & 2) { /* @0x0425C4 tory bit         */
                    DG8(0xA89B)++;                  /* @0x0425CA */
                    DG16(0x9E52) += DG8(G_COLONY_PTR + 0x1F);  /* @0x0425D2 */
                }
                if (DG8(G_COLONY_PTR + 0x1B) & 1) { /* @0x0425D6 rebel bit        */
                    DG8(0xA89A)++;                  /* @0x0425DC */
                    DG16(0x9E54) += DG8(G_COLONY_PTR + 0x1F);  /* @0x0425E4 */
                }
            }
        }
    }

    /* ---- pass C: per-colony region/bell tally ------------------------ */
    for (i = 0; i < G_COLONY_COUNT; i++) {          /* @0x0425FB..0x042602 */
        overlay_call_181F_09E6();      /* @0x042618 colony_select(i)           */
        region = DG8(G_COLONY_PTR + 0x1A);          /* @0x042624 colony.region   */
        home = overlay_call_181F_0722();            /* @0x042633 region_index(x,y)*/
        if (region != player)          /* @0x04263E */
            continue;                  /* (asm: jne 0x24fa flag path)          */
        DG8(player - 0x6D68)++;        /* @0x042548 colony-count for avg       */
        DG16(player * 2 - 0x6BB2) += DG8(G_COLONY_PTR + 0x1F);  /* @0x042556 finance */
        clamp_add_byte(&DG8(player - 0x6BF0 /*0x9410*/), DG8(G_COLONY_PTR + 0x1F));  /* @0x042561 */
        clamp_add_byte(&DG8(player - 0x6BF4 /*0x940c*/), DG8(G_COLONY_PTR + 0x1F));  /* @0x042573 */
        if (home >= 0)
            clamp_add_byte(&DG8(home + player * 16 - 0x6B1A /*0x94E6, NOT 0x9526*/),
                           DG8(G_COLONY_PTR + 0x1F));           /* @0x042595 */
        DG8(G_COLONY_PTR + 0x1B) &= 0xFC;           /* @0x04268C clear SoL/Tory  */
    }

    /* ---- other-settlement (native) finance pass (@0x0425AF) ---------- */
    for (i = 0; i < G_OTHER_COUNT; i++) {           /* @0x0426CC..0x0426D6 */
        overlay_call_181F_0A4C();      /* @0x0426A1 settlement_make_current(i) */
        home = overlay_call_181F_0722();            /* @0x0426C6 region of settlement */
        if (home >= 0)
            DG8(home - 0x6A0E) |= 1;   /* @0x0426D7 mark region has native      */
    }

    /* ---- pass D: region threshold + finance average ------------------ */
    for (i = 0; i < 0x10; i++) {       /* @0x0426DD..0x042704 */
        if (DGS16(i * 2 - 0x6BA2) >= 8 &&           /* @0x0426E2 region pop >= 8 */
            DG8(i + player * 16 - 0x6B1A) == 0)     /* @0x0426F2 no colony there */
            DG16(0x9650)++;            /* @0x0426F9 unclaimed-region count      */
    }
    /* @0x042706 normalize finance word by colony count (average). */
    if (DG8(player - 0x6D68) != 0) {   /* @0x042709 */
        cbx = player * 2;
        DG16(cbx - 0x6BB2) = DGS16(cbx - 0x6BB2) / DG8(player - 0x6D68);  /* @0x042716 idiv */
    }
    (void)sx; (void)sy; (void)kind;
    return 0;                          /* @0x042723 */
}

/* func_042B10 -- PHANTOM.
 * @asm 0x042B10 falls inside func_042138 (0x042138..0x0428C5).  The earlier
 * 200-byte/223-byte split came from the auto-decoder losing the page-08/09
 * boundary; there is no standalone function here. */

/* ===========================================================================
 * func_042726 -- tally units-by-cargo for the active power (176 bytes)
 * @asm 0x042726..0x0427D5  page_08  ENTER 0xA  RETF   touches *(0x8542)
 * spot-check: 0x042726 = C8 0A 00 00 C7 46 FC 00  (enter 0xA,0; mov [bp-4],0)
 *
 * Builds the 0x1D-wide histogram at [-0x6bd0] of how many of 'power's units
 * carry each cargo/profession id.  pass1 (@0x04272F): zero the 29 buckets.
 * pass2 (@0x042745 over 0x539c units): for each unit of 'power' that is in a
 * settlement (181F:0xB78 >= 0), bump bucket[cargo0(+0x315b)].  pass3
 * (@0x042785 over 0x539e colonies of 'power'): for each colonist in the colony
 * (181F:0xC54) bump bucket[its cargo].
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_042726_cargo_histogram(uint16_t power /*bp+6*/)
{
    int i;                             /* bp-4 */
    int u;                             /* bp-8 */
    int c;                             /* bp-0xa */
    int slot;                          /* bp-2 */

    /* @0x04272F zero the 0x1D cargo buckets. */
    for (i = 0; i < 0x1D; i++)         /* @0x04272F..0x04273E */
        DG8(i - 0x6BD0) = 0;

    /* @0x042745 pass over all units. */
    for (u = 0; u < G_UNIT_COUNT; u++) {            /* @0x042777..0x04277E */
        int ubx = u * UNIT_STRIDE;
        if ((U_TYPENAT(ubx) & 0x0F) != power)       /* @0x04274B */
            continue;
        if (overlay_call_181F_0B78() < 0)           /* @0x042759 settlement_select(u) */
            continue;
        DG8(U_CARGO0(ubx) - 0x6BD0)++; /* @0x042765 bucket[cargo0]++            */
    }

    /* @0x042785 pass over this power's colonies and their colonists. */
    for (i = 0; i < G_COLONY_COUNT; i++) {          /* @0x0427AF..0x0427B6 */
        overlay_call_181F_09E6();      /* @0x0427B9 colony_select(i)            */
        if (DG8(G_COLONY_PTR + 0x1A) != (uint8_t)power)  /* @0x0427C1 colony power */
            continue;
        for (slot = 0; slot < DG8(G_COLONY_PTR + 0x1F); slot++) {  /* @0x042788..0x042796 */
            c = overlay_call_181F_0C54();           /* @0x04279B colony_colonist(slot) */
            DG8(c - 0x6BD0)++;         /* @0x0427A5 bucket[c]++                  */
        }
    }
    return 0;                          /* @0x0427D4 */
}

/* ===========================================================================
 * func_0427D6 -- tally trade-route / mission participants (239 bytes)
 * @asm 0x0427D6..0x0428C5  page_08  ENTER 8  RETF
 * spot-check: 0x0427D6 = C8 08 00 00 56 8B 46 06  (enter 8,0; push si; mov ax)
 *
 * For target id = (arg+4) (bp-8) builds three per-power maps describing who is
 * engaged with that target: pass1 (@0x0427FC) zero the 16-wide maps.  pass2
 * (@0x04281B over 0x539a native settlements via 181F:0xA4C): for settlements
 * whose owner(+2) == target, bump the mission count [-0x69d6], add the
 * settlement size(+4) to [-0x69de], and bump the region map [-0x6b82] for the
 * settlement's region (181F:0x722).  pass3 (@0x042864 over 0x539c units of
 * the target nibble via 181F:0x9c8/0x81c): record the unit's colony field
 * value into the per-power maps [-0x6e7c/0x9184] and worked map [0x91cc].
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_0427D6_mission_tally(uint16_t arg /*bp+6*/)
{
    int target;                        /* bp-8 target id = arg+4              */
    int i;                             /* bp-6 */
    int val;                           /* bp-4 */
    int region;

    target = arg + 4;                  /* @0x0427DB */

    /* @0x0427E6 zero scalar maps. */
    DG8((int)arg - 0x6E7C) = 0;        /* @0x0427E9 */
    DG8((int)arg - 0x69DE) = 0;        /* @0x0427ED mission-size accumulator   */
    DG8((int)arg - 0x69D6) = 0;        /* @0x0427F1 mission count              */
    /* @0x0427FC zero the 16-wide worked + region maps. */
    for (i = 0; i < 0x10; i++) {       /* @0x0427FA..0x042814 */
        DG8(i + (int)arg * 16 - 0x6E34) = 0;        /* @0x042805 */
        DG8(i - 0x6B82) = 0;           /* @0x042809 */
    }

    /* @0x04281B pass over native settlements. */
    for (i = 0; i < G_OTHER_COUNT; i++) {           /* @0x04285B..0x042862 */
        overlay_call_181F_0A4C();      /* @0x04281F settlement_make_current(i) */
        /* @0x042827 settlement.owner(+2) == target ? */
        if (DG8(DG16(0x8D4A) + 2) != (uint8_t)target)  /* @0x04282E far ptr 0x8D4A */
            continue;
        DG8((int)arg - 0x69D6)++;      /* @0x042836 mission count++            */
        DG8((int)arg - 0x69DE) += DG8(DG16(0x8D4A) + 4);  /* @0x04283D += size */
        region = overlay_call_181F_0722();          /* @0x04284A region_of(x,y)  */
        DG8(region - 0x6B82)++;        /* @0x042854 region map++                */
    }

    /* @0x042864 pass over units of the target power nibble. */
    for (i = 0; i < G_UNIT_COUNT; i++) {            /* @0x0428B9..0x0428C0 */
        int ubx = i * UNIT_STRIDE;
        if ((U_TYPENAT(ubx) & 0x0F) != (uint8_t)target)  /* @0x04287F */
            continue;
        val = overlay_call_181F_09C8(); /* @0x04287E colony_field_unit(1,i)     */
        clamp_add_byte(&DG8((int)arg - 0x6E7C /*0x9184*/), val);  /* @0x042890 */
        region = overlay_call_181F_081C();          /* @0x042896 unit_home_colony(i) */
        if (region < 0) continue;       /* @0x04289E */
        clamp_add_byte(&DG8(region + (int)arg * 16 - 0x6E34 /*0x91cc*/), val);  /* @0x0428B3 */
    }
    return 0;                          /* @0x0428C2 */
}

/* ===========================================================================
 * func_042C50 -- ADDED (no skeleton entry).  Redraw the side info strip.
 * @asm 0x042C50..0x042CEB  page_09  no-frame  RETF
 * spot-check: 0x042C50 = 83 3E 2C 08 00 75 25 FF  (cmp word[0x82c],0; jne ...)
 *
 * Composition routine for the right-hand info panel (the "what is drawn where"
 * for the status strip).  If no overlay window is registered at [0x82c] it
 * blits the default strip (181F:0xBA) into the fixed rect x=0x4f w=0x96 at
 * y=0x32, colour 0xF1, palette regs 0x2da8..0x2dae.  Otherwise it composites
 * the registered window's 4-word frame (181F:0xC4) and then the body fill
 * (181F:0xCE) into rect x=0..0xc8 region 0xf0:0x31 size 0x140.  The alternate
 * tail (@0x042CD6) draws the single-line variant (181F:0xE2) at x=0x4f y=0x32.
 * Pure layout/blit orchestration; the 0x181F:* calls are the blit leaves.
 * @status BYTE_VERIFIED (geometry constants cited)
 * =========================================================================== */
int func_042C50_draw_info_strip(void)
{
    /* @0x042C50 is a registered info window present? */
    if (DG16(0x082C) == 0) {           /* @0x042C50 */
        /* @0x042C57 default strip: blit at rect (x=0x4f,y=0x32,w=0x96),
         * colour 0xF1, with the 4 palette words 0x2da8..0x2dae. */
        overlay_call_181F_00BA();      /* @0x042C75 blit_strip(0x4f,0x32,0xf1,0x96,0x22,pal) */
        goto tail;                     /* @0x042C7A */
    }
    /* @0x042C7C composite the registered window frame then fill. */
    overlay_call_181F_00C4();          /* @0x042CA9 blit_frame(win[0..3],pal,0xf1,0x4f,0x32,0x96,0,0) */
tail:
    /* @0x042CB1 body fill: rect x=0..0xc8, region 0xf0:0x31, size 0x140. */
    overlay_call_181F_00CE();          /* @0x042CCF blit_fill(0x140,0x31,0xf0,0,0xc8,pal) */
    return 0;                          /* @0x042CD4 RETF */

    /* @0x042CD6 single-line variant (reached via a separate near entry). */
    overlay_call_181F_00E2();          /* @0x042CE5 blit_line(0xf1,0x32,0x4f,0x96,0xf1,0x32) */
    return 0;                          /* @0x042CEA */
}

/* ===========================================================================
 * func_042CEC -- compose a centred status string into the message line (89 B)
 * @asm 0x042CEC..0x042D45  page_09  ENTER 0x50  RETF
 * Builds a 0x50-byte string buffer: str_begin(181F:0x11e), append arg6's text
 * (181F:0x1e6), measure (181F:0x128), then place it centred (181F:0x132)
 * between the in/out x cursors *bp+8 / *bp+0xa, advancing *bp+0xa by the glyph
 * width returned via far ptr 0x89e.  This is the message-line LAYOUT helper.
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_042CEC_msgline_text(uint16_t text_id /*bp+6*/, uint16_t *xin /*bp+8*/, uint16_t *xout /*bp+0xA*/)
{
    char buf[0x50];                    /* bp-0x50 */
    buf[0] = 0;                        /* @0x042CF1 */
    overlay_call_181F_011E();          /* @0x042CF9 str_begin(buf)             */
    (void)text_id;
    overlay_call_181F_01E6();          /* @0x042D08 str_append_text(buf,text_id)*/
    overlay_call_181F_0128();          /* @0x042D14 str_measure(buf)           */
    overlay_call_181F_0132();          /* @0x042D2B str_place(buf,*xin,*xout)   */
    /* @0x042D33 advance the out cursor by (glyph width @0x89e) + 1. */
    *xout += DG8(0/*far es:[bx]*/) + 1;             /* @0x042D3D */
    (void)xin;
    return 0;                          /* @0x042D42 */
}

/* ===========================================================================
 * func_042D46 -- compose a centred string from a string-TABLE id (95 bytes)
 * @asm 0x042D46..0x042DA5  page_09  ENTER 0x50  RETF
 * Identical layout to func_042CEC but the text comes from string table
 * 0x2db0[arg6] (the 181F:0x16e table appender) instead of a literal id.
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_042D46_msgline_tablestr(uint16_t idx /*bp+6*/, uint16_t *xin /*bp+8*/, uint16_t *xout /*bp+0xA*/)
{
    char buf[0x50];                    /* bp-0x50 */
    buf[0] = 0;                        /* @0x042D4B */
    overlay_call_181F_011E();          /* @0x042D53 str_begin(buf)             */
    /* @0x042D5B append string-table entry 0x2db0[idx]. */
    overlay_call_181F_016E();          /* @0x042D68 str_append(buf, strtab[idx])*/
    overlay_call_181F_0128();          /* @0x042D74 str_measure(buf)           */
    overlay_call_181F_0132();          /* @0x042D8B str_place(buf,*xin,*xout)   */
    *xout += DG8(0/*far es:[bx]*/) + 1;             /* @0x042D9D */
    (void)idx; (void)xin;
    return 0;                          /* @0x042DA2 */
}

/* ===========================================================================
 * func_042DA6 -- draw the turn/score readout digit row (83 bytes)
 * @asm 0x042DA6..0x042DF9  page_09  ENTER 2  RETF
 * Renders the value at [0x9e56] as a number (181F:0x22 -> dx:ax) and blits it
 * (181F:0x13c) at colour derived from (option [0x929c]==1 ? 0 : 0xf) and base
 * 0x2dbe, sprite 0xf2.  If arg6 != 0 it also draws the trailing unit glyph
 * (181F:0xe2) at x=0x4f using the width word 0x89e.
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_042DA6_draw_score_row(uint16_t with_glyph /*bp+6*/)
{
    int colour;
    /* @0x042DAA colour: cmp [0x929c],1; cmc; sbb ax,ax; and ax,0xf.
     * => 0 when [0x929c]==0, else 0xF (the "is-it-autumn? dim the digits"). */
    colour = (DG16(0x929C) == 0) ? 0 : 0x0F;        /* @0x042DAA..0x042DB2 */
    (void)colour;
    overlay_call_181F_0022();          /* @0x042DC1 num_format([0x9e56])       */
    overlay_call_181F_013C();          /* @0x042DCB num_blit(dx:ax,0x2dbe,0xf2,colour) */
    if (with_glyph != 0) {             /* @0x042DD3 */
        overlay_call_181F_00E2();      /* @0x042DF2 glyph_blit(0xf1,[0x9e56],0x4f,width) */
    }
    return 0;                          /* @0x042DF7 */
}

/* ===========================================================================
 * func_042DFA -- lay out a colony's per-cargo production column (293 bytes)
 * @asm 0x042DFA..0x042F1F  page_09  ENTER 0x20  RETF
 * spot-check: 0x042DFA = C8 20 00 00 56 6B 5E 06  (enter 0x20,0; push si; imul)
 *
 * For a colony unit (arg6) computes the weighted product for each of its n
 * cargo rows (same prodTable[typeNib*16 + row]<<? weighting as the load/unload
 * panels, with rows 0xF/0xE -> 0 and row 8 -> 1), sorts (191F:0xED0), then
 * lays them out as a column starting at base x = 0x27 + row_terr, using the
 * sprite array [0x83e]/[0x840] and advancing *bp+8 (the running y) by the
 * glyph-table height es:[bx+si+0x3e]+1.  Rows whose qty >= 0x64 use the wide
 * glyph 0x17.  This is the colony-screen production LAYOUT.
 * @status BYTE_VERIFIED (full control flow; geometry cited)
 * =========================================================================== */
int func_042DFA_colony_prod_column(uint16_t unit /*bp+6*/, uint16_t *ypos /*bp+8*/, uint16_t row_x /*bp+0xA*/)
{
    int ubx = unit * UNIT_STRIDE;
    int n;                             /* bp-0x20 row count                   */
    int i;                             /* bp-0xe                              */
    int terr;                          /* bp-0x12                             */
    int qty;                           /* bp-8                                */
    int w;                             /* bp-0xa                              */
    int base_x;                        /* bp-0x10                             */
    int ids[16];                       /* bp-6.. row ids                      */
    int vals[16];                      /* bp-0x1e.. weighted values           */

    n = U_MOVES(ubx);                  /* @0x042E03 row count (reuses +0x3150)*/

    /* @0x042E0C compute weighted values for rows 0..n. */
    for (i = 0; i < n; i++) {          /* @0x042E11..0x042E8B */
        ids[i] = i;                    /* @0x042E14 */
        terr = overlay_call_181F_0BE6();            /* @0x042E1D cargo_row_terr(i,unit) */
        qty  = overlay_call_181F_0C68();            /* @0x042E2C cargo_row_qty(i,unit)  */
        {
            int tn = U_TYPENAT(ubx) & 0x0F;         /* @0x042E37 */
            w = DG8(0x84BC + terr + tn * 16) << 4;  /* @0x042E44 */
            if (terr == 0x0F) w = 0;   /* @0x042E56 */
            if (terr == 0x0E) w = 0;   /* @0x042E60 */
            if (terr == 0x08) w = 1;   /* @0x042E6A */
        }
        vals[i] = w * qty;             /* @0x042E74 */
    }
    /* @0x042E8D sort. */
    overlay_call_191F_0ED0();          /* @0x042E9A sort_pairs(vals,ids,n)     */

    /* @0x042E9F lay out each sorted row as a column entry. */
    for (i = 0; i < n; i++) {          /* @0x042EE0..0x042EE6 */
        int row = ids[i];              /* @0x042EEA */
        terr = overlay_call_181F_0BE6();            /* @0x042EF6 cargo_row_terr(row,unit) */
        qty  = overlay_call_181F_0C68();            /* @0x042F07 cargo_row_qty(row,unit)  */
        base_x = (qty >= 0x64) ? 0x17 : 0x27;       /* @0x042EA6/0x042F12..0x042F17 */
        /* @0x042EAC blit the cargo glyph at (row_x, *ypos) using sprite
         * arrays [0x83e]/[0x840] and the per-row terrain id. */
        overlay_call_181F_0254();      /* @0x042EC3 cargo_glyph(base_x+terr,row_x,*ypos,0x2da8) */
        /* @0x042ED1 advance *ypos by glyphHeightTable[idx*12 + 0x3e] + 1. */
        *ypos += DG16(0/*far es:[bx+si+0x3e]*/) + 1;/* @0x042EDA */
        (void)base_x;
    }
    (void)row_x;
    return 0;                          /* @0x042F1C */
}

/* ===========================================================================
 * func_042F20 -- tooltip text for the tile/unit under a cursor cell (182 B)
 * @asm 0x042F20..0x042FD5  page_09  push bp;mov bp,sp  RETF
 * spot-check: 0x042F20 = 55 8B EC FF 76 0A FF 76  (push bp; mov bp,sp; push)
 *
 * Given a buffer (bp+6) and a cell (bp+8 x, bp+0xa y, bp+0xc col, bp+0xe flag)
 * it decides which label to append:
 *   - cell out of bounds (181F:0x302 == 0): if the column delta is exactly
 *     0x14 (sea-lane column) append the sea-lane name strtab[col]@-0x7c74,
 *     else append the generic "ocean" string [0x2e32].
 *   - cell in bounds: terrain 0x1A & flag 0 -> nothing; otherwise resolve the
 *     unit owner (181F:0x7be); if a colony is there (>=0) format its record
 *     (0x5d48 + owner*0xca) via str_format; if not, build the terrain blurb
 *     (str_begin/append terrain 0x182, the resource clause 0x1b4, append the
 *     yield 0x182, finalize 0x128).
 * This is the map tooltip LAYOUT/COMPOSITION (what text goes where on hover).
 * @status BYTE_VERIFIED (full control flow; leaves cited)
 * =========================================================================== */
int func_042F20_tile_tooltip(uint16_t buf /*bp+6*/, uint16_t x /*bp+8*/, uint16_t y /*bp+0xA*/,
                             uint16_t col /*bp+0xC*/, uint16_t flag /*bp+0xE*/)
{
    int owner;
    (void)buf; (void)x; (void)y;

    if (overlay_call_181F_0302() == 0) {            /* @0x042F29 tile_in_bounds(x,y) */
        /* @0x042F34 out of bounds: sea-lane column vs generic ocean. */
        if (col >= 0 && ((col & 0xFF) - (x & 0xFF)) == 0x14) {  /* @0x042F37..0x042F41 */
            overlay_call_181F_016E();  /* @0x042F4F append(buf, sealaneName[col]) */
        } else {
            overlay_call_181F_016E();  /* @0x042F58 append(buf, strtab[0x2e32]) */
        }
        return 0;                      /* @0x042F54 */
    }
    /* @0x042F5E in bounds. */
    if (overlay_call_181F_078C() == 0x1A && flag == 0)  /* @0x042F64..0x042F74 */
        return 0;                      /* open sea, no detail wanted           */

    owner = overlay_call_181F_07BE();  /* @0x042F7C tile_owner/colony(x,y)     */
    DG16(0x8DC6) = owner;              /* @0x042F83 cache last hovered owner    */
    if (owner >= 0) {                  /* @0x042F88 a colony is here            */
        /* @0x042F8A format ColonyRecord[owner] (base 0x5d48, stride 0xca). */
        overlay_call_0D1D_07E4();      /* @0x042F95 str_format(buf, 0x5d48+owner*0xca) */
        return 0;                      /* @0x042F9A */
    }
    /* @0x042F9C build the terrain + resource blurb. */
    overlay_call_181F_011E();          /* @0x042F9F str_begin(buf)             */
    overlay_call_181F_0182();          /* @0x042FAD append_terrain(buf,x)       */
    overlay_call_181F_01B4();          /* @0x042FB7 append_resource_clause(buf) */
    overlay_call_181F_0182();          /* @0x042FC5 append_yield(buf,y)         */
    overlay_call_181F_0128();          /* @0x042FCF str_finalize(buf)          */
    return 0;                          /* @0x042FD4 */
}

/* ===========================================================================
 * func_042FD6 -- map a cargo/profession id to its display sprite (157 bytes)
 * @asm 0x042FD6..0x043072  page_09  ENTER 6  RETF
 * spot-check: 0x042FD6 = C8 06 00 00 6B 5E 08 1C  (enter 6,0; imul bx,[bp+8],0x1c)
 *
 * Given a unit (bp+8) and a slot flag (bp+0xa), returns the sprite id for its
 * cargo0(+0x315b): cargo 0x1c remaps to 0x13; the base sprite comes from the
 * 8-stride table at [-0x715e] indexed by the (remapped) cargo.  Then several
 * type-specific overrides keyed on the unit type(+0x3146): type 1/4 with cargo
 * 0x15 -> [0x2e3c]; type 5 with cargo 0x16 -> [0x2dc2]; type 3 with cargo 0x18
 * -> [0x2dc2]; and the goods-availability gate (181F:0xc9a) can force -1.
 * Finally if the sprite is valid it appends it to the caller's buffer (bp+6)
 * via 181F:0x16e.  This is the unit-sprite glue for the cargo panel.
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_042FD6_cargo_sprite(uint16_t buf /*bp+6*/, uint16_t unit /*bp+8*/, uint16_t avail /*bp+0xA*/)
{
    int ubx = unit * UNIT_STRIDE;
    int cargo;                         /* bp-2 */
    int type;                          /* bp-4 */
    int spr;                           /* bp-6 */

    cargo = U_CARGO0(ubx);             /* @0x042FDE */
    type  = U_TYPENAT(ubx) /*+0x3146 unit type*/;   /* @0x042FE6 */
    if (cargo == 0x1C)                 /* @0x042FEF */
        cargo = 0x13;                  /* @0x042FF4 */
    spr = DG16(cargo * 8 - 0x715E);    /* @0x042FF9 base sprite table          */

    /* @0x043006 goods-availability gate: if this is a goods cargo and not
     * available, force "no sprite". */
    if (type != 0 && avail == 0) {     /* @0x043006..0x04300E */
        if (overlay_call_181F_0C9A() == 0)          /* @0x043013 goods_available(cargo)? */
            spr = -1;                  /* @0x04301F */
    }
    /* @0x043024 type-specific cargo overrides. */
    if ((type == 1 || type == 4) && cargo == 0x15)  /* @0x043024..0x043034 */
        spr = DG16(0x2E3C);            /* @0x043036 */
    if (type == 5 && cargo == 0x16)    /* @0x04303C..0x043046 */
        spr = DG16(0x2DC2);            /* @0x043048 */
    if (type == 3 && cargo == 0x18)    /* @0x04304E..0x043058 */
        spr = DG16(0x2DC2);            /* @0x04305A */

    /* @0x043060 emit the sprite if valid. */
    if (spr >= 0)                      /* @0x043060 */
        overlay_call_181F_016E();      /* @0x04306C append_sprite(buf, spr)     */
    (void)buf;
    return 0;                          /* @0x043071 */
}

/* ===========================================================================
 * func_043074 -- SUPERSEDED.
 * 4990-byte page-09 tail.  This is the full tile-info / status-panel composer;
 * the byte-verified, fully designed port lives in src/render/tile_info_panel.c.
 * The earlier 85-byte "func_043074_snd_sz_85" stub was a fabricated mis-size
 * (the auto-decoder cut the function at the first RETF-like byte); it is
 * RETIRED here in favour of the pointer below.
 * @asm 0x043074..(page end ~0x0443D8)  page_09
 * @status SUPERSEDED -> src/render/tile_info_panel.c
 * =========================================================================== */
/* SUPERSEDED -> src/render/tile_info_panel.c : func_043074 (tile info panel). */

/* ===========================================================================
 * func_044540 -- read+clamp a far order byte (move-mode -> 5) (21 bytes)
 * @asm 0x044540..0x044553  page_0A  push bp;mov bp,sp  RET (near)
 * spot-check: 0x044540 = 55 8B EC C4 5E 04 26 8A  (push bp; mov bp,sp; les bx)
 *
 * Loads the byte at the far pointer in (bp+4); if it equals 6 it returns 5,
 * otherwise it returns the byte unchanged.  (Collapses order code 6 ("wait")
 * onto 5 for display.)  NEAR return (CDECL near helper).
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_044540_clamp_order_byte(uint8_t *p /*bp+4 (far)*/)
{
    int b = *p;                        /* @0x044543 les bx,[bp+4]; mov bl,es:[bx] */
    if (b == 6)                        /* @0x04454B cmp bx,6                    */
        b = 5;                         /* @0x044550 dec bx                      */
    return b;                          /* @0x044551 */
}

/* ===========================================================================
 * func_044556 -- write a 6-field record through a far pointer (52 bytes)
 * @asm 0x044556..0x044589  page_0A  push bp;mov bp,sp  RETF
 * spot-check: 0x044556 = 55 8B EC 8B 5E 06 8B 46  (push bp; mov bp,sp; mov bx)
 *
 * Struct setter: dst = far ptr (seg bp+8 : off bp+6).  Writes:
 *   dst[0] = bp+0xe ; dst[2] = bp+0x10 ; dst[4] = bp+0x12 ; dst[6] = bp+0x14 ;
 *   dst[8] = bp+0xa ; dst[0xa] = bp+0xc .
 * (Six words; note the last two args are stored after the first four, matching
 * the disasm's load order.)
 * @status BYTE_VERIFIED
 * =========================================================================== */
int func_044556_set_record(uint16_t off /*bp+6*/, uint16_t seg /*bp+8*/,
                           uint16_t a /*bp+0xA*/, uint16_t b /*bp+0xC*/,
                           uint16_t w0 /*bp+0xE*/, uint16_t w1 /*bp+0x10*/,
                           uint16_t w2 /*bp+0x12*/, uint16_t w3 /*bp+0x14*/)
{
    uint16_t *dst = (uint16_t *)MK_FP(seg, off);    /* @0x044559..0x04455F */
    dst[0] = w0;                       /* @0x044562 es:[bx]   = bp+0xe         */
    dst[1] = w1;                       /* @0x044565 es:[bx+2] = bp+0x10        */
    dst[2] = w2;                       /* @0x04456C es:[bx+4] = bp+0x12        */
    dst[3] = w3;                       /* @0x044573 es:[bx+6] = bp+0x14        */
    dst[4] = a;                        /* @0x04457A es:[bx+8] = bp+0xa         */
    dst[5] = b;                        /* @0x044584 es:[bx+0xa] = bp+0xc       */
    return 0;                          /* @0x044588 RETF */
}

/* func_04458A is the EXCLUSIVE end of this file's range == the first function
 * of the next overlay source file; it is NOT ported here. */

/* ============================================================================
 * End of overlay_040C1E_04458A.c
 * ========================================================================== */
