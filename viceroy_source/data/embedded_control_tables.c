/* embedded_control_tables.c — DGROUP-resident control tables that are REAL
 * static bytes inside VICEROY.EXE (unlike the balance tables, which load from
 * COLONIZE/*.TXT into BSS at runtime — see README.md / docs/DATA_TABLES.md).
 *
 * Every table here is BYTE_VERIFIED: the bytes are read directly from the EXE
 * and the accessor that indexes them is cited. Verified 2026-06-07 against
 * VICEROY.EXE (sha256 a17ed64c...). Address model: DS:off == file 0x1D9A0+off.
 */
#include <stdint.h>

/* ------------------------------------------------------------------ adjacency
 * The 8-neighbour tile-offset table. The map/movement code loops i=0..7 and
 * forms (x + dx[i], y + dy[i]):
 *
 *   @asm 0x007088  cmp word [bp-4], 8        ; for i in 0..7
 *   @asm 0x00708e  mov bx, [bp-4]
 *   @asm 0x007091  mov al, [bx+0xb4]   8a 87 b4 00   ; dx = NEIGHBOR_DX[i]
 *   @asm 0x007098  add si, [bp+6]                    ; si = x + dx
 *   @asm 0x00709b  mov al, [bx+0xbe]   8a 87 be 00   ; dy = NEIGHBOR_DY[i]
 *   @asm 0x0070a2  add di, [bp+8]                    ; di = y + dy
 *
 * Direction order is N, NE, E, SE, S, SW, W, NW.
 *   @bytes dx @file 0x1DA54: 00 01 01 01 00 ff ff ff
 *   @bytes dy @file 0x1DA5E: ff ff 00 01 01 01 00 ff
 * @status BYTE_VERIFIED (values + accessor + loop bound)
 */
const int8_t NEIGHBOR_DX[8] = {  0,  1,  1,  1,  0, -1, -1, -1 };
const int8_t NEIGHBOR_DY[8] = { -1, -1,  0,  1,  1,  1,  0, -1 };

/* A second 10-entry signed table at DS:0x00C8 (file 0x1DA68), indexed in the
 * same family of map helpers. Values 0,1,0,-1,-1,1,1,-1,(0,2). Exact role
 * (alternate direction ordering / second axis) is [not yet decoded — accessor not fully
 * traced]; bytes are recorded so the value is not lost.
 *   @bytes @file 0x1DA68: 00 01 00 ff ff 01 01 ff 00 02
 * @status BYTE_VERIFIED (bytes); semantics ANCHOR/not yet decoded
 */
const int8_t MAP_DELTA_C8[10] = { 0, 1, 0, -1, -1, 1, 1, -1, 0, 2 };

/* 4-cardinal neighbour deltas (N,E,S,W), used by the map-generator landmass
 * blob-growth pass (func_0645F6 @0x646EC/0x646F8) and orthogonal walks.
 *   @bytes dx @file 0x1DA48: 00 01 00 ff   dy @file 0x1DA4E: ff 00 01 00
 * @status BYTE_VERIFIED
 */
const int8_t CARDINAL_DX[4] = {  0,  1,  0, -1 };
const int8_t CARDINAL_DY[4] = { -1,  0,  1,  0 };

/* ------------------------------------------------------- commodity → building
 * good_to_chain_bit[good] : for each of the 19 commodity slots, the building
 * "chain" bit-id whose presence gates/boosts that good's production, or -1 if
 * the good has no building chain (the first 9 raw goods). Read by func_008D9C
 * = lookup_signed_2F4(index):
 *
 *   @asm 0x008da5  cmp word [bp+6], 0x13        ; 19 entries (0..18)
 *   @asm 0x008dae  mov al, [bx+0x2f4]  8a 87 f4 02
 *   @asm 0x008db2  cwde                         ; sign-extend (-1 = none)
 *   @bytes @file 0x1DC94: ff ff ff ff ff ff ff ff ff 1b 18 15 20 23 27 03 25 09 0c
 * @status BYTE_VERIFIED (values + accessor + bound)
 */
const int8_t GOOD_TO_CHAIN_BIT[19] = {
    -1, -1, -1, -1, -1, -1, -1, -1, -1,
    0x1b, 0x18, 0x15, 0x20, 0x23, 0x27, 0x03, 0x25, 0x09, 0x0c
};

/* good_to_raw_input[good] : the raw-material commodity id consumed to make each
 * finished good (-1 = none / is itself raw). 19 entries at DS:0x02A2, used by
 * the colony production net-flow helpers (commodity_net_minus_chain family).
 *   @bytes @file 0x1DC42: ff ff ff ff ff ff ff ff 08 01 02 03 04 ff 06 0e 05 ff ff
 * @status BYTE_VERIFIED (bytes); per-index meaning ANCHOR (raw->finished pairing)
 */
const int8_t GOOD_TO_RAW_INPUT[19] = {
    -1, -1, -1, -1, -1, -1, -1, -1,
    0x08, 0x01, 0x02, 0x03, 0x04, -1, 0x06, 0x0e, 0x05, -1, -1
};
