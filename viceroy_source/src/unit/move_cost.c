/* ============================================================================
 * move_cost.c -- the movement-cost head of func_03ECF0  [PORTED 2026-06-10]
 * ----------------------------------------------------------------------------
 * func_03ECF0 is THE unit-move executor: the landfall MOVE COMMIT thunk
 * 0x1A1F:0x142 resolves to it (overlay-stub record at file 0x1C5F0+0x142 =
 * "9a ab 0d 0d 11 / ea 00 00 00 00 / 07 00" -> page 7 offset 0x0000; page 7
 * code base 0x3ECF0 per re_work/overlay_segmap.json, independently confirmed
 * here: the body reads the unit's src x/y and prices the step to the pushed
 * dest).  The full executor is 3101 bytes (combat, boarding, war-declaration
 * dispatch); THIS file ports its self-contained COST section,
 * file 0x3ECF0..0x3EDD7, transcribed from re_work/disasm/func_03ECF0.asm.
 *
 * The rule (all thirds -- 3 = one full terrain step):
 *   class = terrain-class(dest)                 0x181F:0x78C -> func_00627A
 *   cost3 = 3 * NAMES.TXT terrain Movement      [class*16 + 0x2F76] = row +0x02
 *   road:  feature(src)&0x0A && feature(dest)&0x0A          -> cost3 = 1
 *   river: raw(src)&0x40 && raw(dest)&0x40 && same row/col  -> cost3 = 1
 *   owned dest (owner_at >= 0): cost3 = min(cost3, 3)
 *
 * The terrain Movement column is populated at runtime from the user's
 * NAMES.TXT (@UNFORESTED/@FORESTED/@OTHER -> data_load.c load_terrain,
 * row +0x02); nothing is embedded.
 *
 * NOTE (model alignment, cite-marked): further down the executor accounts
 * movement as allowance(func_006CCA via 0x181F:0x90C) MINUS the per-unit
 * used-accumulator [unit*0x1C + 0x3149] (= UnitRecord +5)  @0x3EE84..0x3EE9D.
 * The shell currently tracks REMAINING thirds in UnitRecord +6; converging
 * the two models happens when the full executor is ported.
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include "viceroy_types.h"
#include "dgroup.h"

#define UB(i, off)  DG8(0x3144 + (i)*0x1C + (off))

extern int func_00627A_op_sz_57(uint16_t x, uint16_t y);                 /* 0x78C */
extern int func_005D32_map_tile_read_layer_160(uint16_t x, uint16_t y);  /* 0x754 */
extern int func_005CFE_map_tile_read_layer_15C(uint16_t x, uint16_t y);  /* 0x72C */
extern int func_005FD4_map_xy_bounds_or_neg1_alt(uint16_t x, uint16_t y);/* 0x6BE */

int unit_move_cost_thirds(int unit, int dest_x, int dest_y)
{
    int src_x = UB(unit, 0);                       /* @0x3ED0F [bx+0x3144] */
    int src_y = UB(unit, 1);                       /* @0x3ED18 [bx+0x3145] */
    int cost3;

    /* terrain class of dest -> Movement column * 3 (thirds).
     * @0x3ED25 lcall 0x181F:0x78C (dest_x, dest_y) -> class
     * @0x3ED32 shl bx,4 / @0x3ED35 mov al,[bx+0x2F76] (= terrain row +0x02)
     * @0x3ED3D shl ax,1 / @0x3ED3F add ax,cx  (cost*3) */
    {
        int cls  = func_00627A_op_sz_57((uint16_t)dest_x, (uint16_t)dest_y);
        int cost = DG8(0x2F76 + (cls << 4));
        cost3 = cost * 3;
    }

    /* ROAD: feature layer bit 0x02|0x08 on BOTH ends -> one third.
     * @0x3ED44 lcall 0x181F:0x754 (src) / @0x3ED52 test al,0x0A
     * @0x3ED5C lcall 0x181F:0x754 (dest) / @0x3ED64 test al,0x0A
     * @0x3ED68 mov [bp-0x3E],1 */
    if ((func_005D32_map_tile_read_layer_160((uint16_t)src_x,
                                             (uint16_t)src_y) & 0x0A) &&
        (func_005D32_map_tile_read_layer_160((uint16_t)dest_x,
                                             (uint16_t)dest_y) & 0x0A))
        cost3 = 1;

    /* RIVER: raw terrain bit 0x40 on BOTH ends, and the step stays on the
     * same column or row (orthogonal along the river).
     * @0x3ED6D/0x3ED85 lcall 0x181F:0x72C / test al,0x40
     * @0x3ED91 cmp src_x,dest_x / @0x3ED99 cmp src_y,dest_y
     * @0x3EDA1 mov [bp-0x3E],1 */
    if ((func_005CFE_map_tile_read_layer_15C((uint16_t)src_x,
                                             (uint16_t)src_y) & 0x40) &&
        (func_005CFE_map_tile_read_layer_15C((uint16_t)dest_x,
                                             (uint16_t)dest_y) & 0x40) &&
        (src_x == dest_x || src_y == dest_y))
        cost3 = 1;

    /* owned destination clamps the step to one full move (3 thirds).
     * @0x3EDBA lcall 0x181F:0x6BE (dest) / @0x3EDC5 or ax,ax; jl skip
     * @0x3EDC9 cmp [bp-0x3E],3 / @0x3EDD1 mov ax,3 / @0x3EDD4 store */
    if (func_005FD4_map_xy_bounds_or_neg1_alt((uint16_t)dest_x,
                                              (uint16_t)dest_y) >= 0 &&
        cost3 > 3)
        cost3 = 3;

    return cost3;
}

#endif /* _VICEROY_MODERN */
