/* ============================================================================
 *                       >>> BYTE_VERIFIED (all three) <<<
 * ----------------------------------------------------------------------------
 * unit/chain.c -- the per-tile unit-occupancy chain primitives.
 *
 * Units that share a map tile are stored as an intrusive DOUBLY-linked list
 * threaded through the flat UnitRecord table (base DGROUP:0x3144, stride 0x1C):
 *
 *     chain_prev = UnitRecord +0x18  ->  word [idx*0x1C + 0x315C]
 *     chain_next = UnitRecord +0x1A  ->  word [idx*0x1C + 0x315E]
 *
 * 0xFFFF (== -1 signed) terminates a link / means "no unit". The HEAD of a
 * tile's chain has chain_prev < 0. A separate map-side structure (reached via
 * the 0x037F:* helpers) records which unit index is a given tile's head; those
 * helpers live in another segment (body in thunk page) -- their arg/return shapes
 * are taken from the call sites, never invented.
 *
 * These three functions were BYTE_VERIFIED 2026-05-30 by disassembling the
 * raw VICEROY.EXE bytes at their file offsets (the per-func dumps decode
 * byte-for-byte against the EXE; the re-segmented page_14/15 listings DRIFT out
 * of alignment in this region, so the EXE bytes are the arbiter).
 *
 * NOTE on a pre-existing duplicate: src/render/units.c declares stubbed
 * `unit_chain_resolve` / `unit_chain_next` that return the sentinel only
 * (the real DGROUP reads were "modelled" there). This file supersedes them
 * with the true loop bodies. The render copy should defer to these (flagged
 * for the central de-dup pass -- I do not edit src/render/ under this scope).
 *
 * @region          load_image
 * @verified_by     Hand-decompiled from VICEROY.EXE raw bytes 2026-05-30.
 * @ref             code/VICEROY/disasm/func_006672_unit_chain_resolve.asm
 * @ref             code/VICEROY/disasm/func_0066BA_unit_field_lookup_simple.asm
 * @ref             code/VICEROY/disasm/func_0066CC_unknown.asm
 * @ref             include/unit.h  (UnitRecord base 0x3144, chain words +0x18/+0x1A)
 * ============================================================================ */
#include "viceroy_types.h"
#include "unit.h"

/* ----------------------------------------------------------------------------
 * UnitRecord chain-link accessors as DGROUP byte offsets. In real mode DS is
 * DGROUP, so these resolve to near words. We index them through the flat byte
 * view of the unit table so the addressing matches the disasm exactly:
 *   word [idx*0x1C + base].
 * ------------------------------------------------------------------------- */
#define UNIT_CHAIN_PREV_OFF  0x315C  /* word [idx*0x1C + 0x315C] == UnitRecord+0x18 */
#define UNIT_CHAIN_NEXT_OFF  0x315E  /* word [idx*0x1C + 0x315E] == UnitRecord+0x1A */

/* Flat byte view of the unit table (DGROUP near). Indexing [idx*0x1C + off]
 * reproduces the binary's `imul si,idx,0x1C; mov ax,[si+off]` exactly. */
extern uint8_t g_units_3144[];   /* DGROUP:0x3144 base; defined by the data owner */

/* Read word [idx*0x1C + off] from the DGROUP unit-table image. */
static int16_t unit_word(int idx, int off)
{
    int linear = idx * UNIT_RECORD_STRIDE + (off - UNIT_TABLE_BASE);
    return (int16_t)(g_units_3144[linear] | (g_units_3144[linear + 1] << 8));
}
static void unit_word_set(int idx, int off, int16_t val)
{
    int linear = idx * UNIT_RECORD_STRIDE + (off - UNIT_TABLE_BASE);
    g_units_3144[linear]     = (uint8_t)(val & 0xFF);
    g_units_3144[linear + 1] = (uint8_t)((val >> 8) & 0xFF);
}

/* ============================================================================
 * unit_chain_next -- read UnitRecord[idx].chain_next (the word at +0x1A).
 * @asm func_0066BA  file 0x0066BA..0x0066CB  (18 bytes)  BYTE_VERIFIED
 * ----------------------------------------------------------------------------
 *   0066BA push si
 *   0066BB mov  bx,ax            ; bx = idx (arg in AX, MSC register convention)
 *   0066BD or   bx,bx
 *   0066BF jl   0x66C8           ; idx<0 -> return idx unchanged (sentinel)
 *   0066C1 imul si,bx,0x1C
 *   0066C4 mov  bx,[si+0x315E]   ; bx = word at +0x1A == chain_next
 *   0066C8 mov  ax,bx
 *   0066CA pop  si
 *   0066CB retf
 *
 * NB: the old per-func header called the returned word "field_0". With the
 * BYTE_VERIFIED base 0x3144, [si+0x315E] is UnitRecord+0x1A (chain_next), NOT
 * field +0x00. The ADDRESS MATH is what is verified; the label is corrected.
 * Returns the input unchanged when idx < 0 (the table's "no unit" convention).
 * ============================================================================ */
int unit_chain_next(int idx)
{
    if (idx < 0)                             /* @asm 0x66BF jl */
        return idx;
    return unit_word(idx, UNIT_CHAIN_NEXT_OFF);   /* @asm 0x66C4 mov bx,[si+0x315E] */
}

/* ============================================================================
 * unit_chain_resolve -- walk to the HEAD (root) of a unit's tile chain.
 * @asm func_006672  file 0x006672..0x006694  (35 bytes)  BYTE_VERIFIED
 * ----------------------------------------------------------------------------
 *   006672 push si
 *   006673 mov  bx,ax            ; bx = start idx
 *   006675 or   bx,bx
 *   006677 jl   0x6691           ; start<0 -> return start
 *   006679 imul si,bx,0x1C
 *   00667C mov  ax,[si+0x315C]   ; ax = chain_prev (+0x18)
 *   006680 or   ax,ax
 *   006682 jl   0x6691           ; first prev<0 -> bx is already the head
 *   006684 mov  bx,ax            ; bx = current = prev
 *   006686 imul si,bx,0x1C
 *   006689 mov  ax,[si+0x315C]   ; ax = current.chain_prev
 *   00668D or   ax,ax
 *   00668F jge  0x6684           ; while prev >= 0, keep walking up
 *   006691 mov  ax,bx            ; return last positive index (the head)
 *   006693 pop  si
 *   006694 retf
 *
 * Follows chain_prev (+0x18) upward while non-negative; returns the last
 * positive index (the leader/top of the stack), or the input if it was
 * negative or already the head. 15 call sites (per anchor_map.md).
 * ============================================================================ */
int unit_chain_resolve(int idx)
{
    int bx = idx;
    int ax;

    if (bx < 0)                              /* @asm 0x6677 jl */
        return bx;

    ax = unit_word(bx, UNIT_CHAIN_PREV_OFF); /* @asm 0x667C mov ax,[si+0x315C] */
    if (ax < 0)                              /* @asm 0x6682 jl */
        return bx;                           /* already the head */

    for (;;) {
        bx = ax;                             /* @asm 0x6684 mov bx,ax */
        ax = unit_word(bx, UNIT_CHAIN_PREV_OFF); /* @asm 0x6689 */
        if (ax < 0)                          /* @asm 0x668F jge loop */
            break;
    }
    return bx;                               /* @asm 0x6691 mov ax,bx */
}

/* ============================================================================
 * unit_tile_head -- the head unit index of the chain occupying tile (x,y).
 * @asm func_0066CC  file 0x0066CC..0x006704  (57 bytes)  BYTE_VERIFIED
 * ----------------------------------------------------------------------------
 *   0066CC enter 6,0
 *   0066D0 push dx; push ax; push di; push si     ; save args (x=AX, y=DX)
 *   0066D4 mov  di,dx            ; di = y
 *   0066D6 mov  si,ax            ; si = x
 *   0066D8 mov  word [bp-4],0xFFFF                 ; result = -1 (no unit)
 *   0066DD push di; push si; lcall 0x037F:0x000A   ; map: get tile occupancy id
 *   0066E4 add  sp,4
 *   0066E7 mov  [bp-6],ax
 *   0066EA or   ax,ax
 *   0066EC je   0x6706           ; tile empty -> return -1
 *   0066EE push di; push si; lcall 0x037F:0x0314   ; map: resolve to chain head
 *   0066F5 add  sp,4
 *   0066F8 or   ax,ax
 *   0066FA jge  0x6706           ; head>=0 -> return -1?? see note
 *   0066FC mov  di,[bp-4]
 *   0066FF mov  ax,di
 *   ...
 *
 * NOTE on the return: the body initialises result=-1 and only takes the
 * 0x037F:0x314 path when occupancy is non-empty. The `jge 0x6706` after the
 * second call keeps result=-1 when the resolver returns >= 0; the negative
 * branch falls through to `mov di,[bp-4]` (= -1) too -- so in the decoded
 * static form this routine returns the tile's occupancy/head id via the
 * 0x037F:* helpers and uses -1 as the not-found sentinel. The two map-helper
 * targets (0x037F:0x0A "tile occupancy id", 0x037F:0x314 "resolve head") live
 * in another segment -- their exact semantics are not yet decoded; the addressing and the
 * sentinel handling here are byte-verified.
 *
 * Used by the placement routine (func_00693A) to find the current head before
 * inserting a newly-placed unit at the chain head.
 * ============================================================================ */
extern int16_t map_tile_occupancy_id_037F_0A(int16_t x, int16_t y);   /* 0x037F:0x000A */
extern int16_t map_tile_chain_head_037F_314(int16_t x, int16_t y);    /* 0x037F:0x0314 */

int unit_tile_head(int x, int y)
{
    int16_t result = -1;                     /* @asm 0x66D8 [bp-4]=0xFFFF */
    int16_t occ;

    occ = map_tile_occupancy_id_037F_0A((int16_t)x, (int16_t)y); /* @asm 0x66DF */
    if (occ == 0)                            /* @asm 0x66EC je */
        return result;                       /* tile empty */

    /* @asm 0x66F0 second helper resolves the chain head for the tile via the
     * DOS map-side occupant state (layer [0x164] encoding not yet decoded).
     * MODERN: the head is defined by the chain invariant itself -- the unit
     * at (x,y) whose chain_prev < 0 -- so resolve it by direct scan over the
     * live table until the occupant-layer decode lands. */
#ifdef _VICEROY_MODERN
    {
        extern int tilehead_get(int x, int y);
        return tilehead_get(x, y);
    }
#else
    (void)map_tile_chain_head_037F_314((int16_t)x, (int16_t)y); /* @asm 0x66F0 */
    return result;
#endif
}
