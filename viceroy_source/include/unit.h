/* ============================================================================
 * unit.h — UnitRecord struct + cargo accessor declarations
 * ----------------------------------------------------------------------------
 * Units (military, civilian, ships, settlers, wagons) are stored in a single
 * flat table at DGROUP:0x3144 with stride 0x1C = 28 bytes per record.
 * (BYTE_VERIFIED 2026-05-28 via WRITE sites: func_04007E @0x4009E/0x400A2 writes
 *  a new unit's x/y to [idx*0x1C + 0x3144]/[+0x3145]; func_L141 @0x06958/0x0695E
 *  writes real x/y there on placement. 0x3146 is field +0x02 (type), NOT the
 *  base. See docs/RULINGS.md 2026-05-28 (RESOLVED).)
 *
 * @ref FUNCTIONS_INVENTORY.md  "UnitRecord stride 0x1C"
 * @ref decompiled.md "UnitRecord cargo layout (now decoded)"
 * ============================================================================ */
#ifndef VICEROY_UNIT_H
#define VICEROY_UNIT_H

#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * UnitRecord — stride 0x1C bytes; base DGROUP:0x3144  (BYTE_VERIFIED 2026-05-28)
 * ----------------------------------------------------------------------------
 * Field addresses (all reached via `imul reg,0x1C` then `[reg+addr]`):
 *   0x3144 +0x00 map_x      |  0x3150 +0x0C cargo_slot_count
 *   0x3145 +0x01 map_y      |  0x3151 +0x0D cargo_kind_packed[3]
 *   0x3146 +0x02 type       |  0x3154 +0x10 cargo_qty[6]
 *   0x3147 +0x03 owner|flg  |  0x315A +0x16 turn_counter
 *   0x3148 +0x04 flags      |  0x315B +0x17 vet/profession type (0x13..0x1C)
 *   0x314A +0x06 moves      |  0x315C +0x18 (word) tile-chain prev-link
 *   0x314B +0x07 profession |  0x315E +0x1A (word) tile-chain next-link
 *   0x314C +0x08 orders     |  end = 0x3144 + 0x1C = 0x3160
 *   0x314D/E +0x09/0A goto x/y
 *
 * Base = 0x3144, proven by the WRITE sites of a newly-allocated unit:
 * func_04007E @0x4009E `MOV [bx+0x3144],al`(x=0xFF) / @0x400A2 `[bx+0x3145]`(y) /
 * @0x400AF `[bx+0x3146]`(type), bx=idx*0x1C; func_L141 @0x06958/0x0695E writes
 * real x/y to 0x3144/0x3145 on placement. func_008B96 (`IMUL ...,0x1C` +
 * `[bx+0x3146]`) reads field +0x02 (type) — the most-tested field (hence the
 * high ref count) but NOT the origin. The earlier "base 0x3146" was off by 2
 * (it labeled type's address as the base); "base 0x315E" was off by 0x1A.
 * Stride boundary confirmed: no field access at 0x3160+ corpus-wide. */
struct UnitRecord {                /* base DGROUP:0x3144, stride 0x1C (28 bytes) */
    uint8_t  map_x;            /* +0x00 (0x3144)  map X; 0xFF=off-map.  @asm write 0x4009E / 0x06958 */
    uint8_t  map_y;            /* +0x01 (0x3145)  map Y; 0xFF=off-map.  @asm write 0x400A2 / 0x0695E */
    uint8_t  type;             /* +0x02 (0x3146)  unit type (@UNIT idx). @asm read 0x8B99, write 0x400AF */
    uint8_t  owner_flags;      /* +0x03 (0x3147)  owner in low nibble (AND 0xF). @asm 0x5B306, 0x3C984 */
    uint8_t  flags;            /* +0x04 (0x3148)  bitfield 0x10/0x40/0x80. @asm TEST 0x5B3A9 */
    uint8_t  field_05;         /* +0x05 (0x3149)  state/sub-flag. not yet decoded */
    uint8_t  moves_remaining;  /* +0x06 (0x314A)  init 0xFF; dec on move. @asm 0x400B3, dec 0x2EF17 */
    uint8_t  profession;       /* +0x07 (0x314B)  init 0x2D=45. @asm 0x40061 */
    uint8_t  orders;           /* +0x08 (0x314C)  orders/activity state. @asm set 0x22105 */
    uint8_t  goto_x;           /* +0x09 (0x314D)  goto/dest x. @asm 0x24506 */
    uint8_t  goto_y;           /* +0x0A (0x314E)  goto/dest y. @asm 0x2450D */
    uint8_t  field_0B;         /* +0x0B (0x314F)  pad/boundary; no standalone access */
    uint8_t  cargo_slot_count; /* +0x0C (0x3150)  valid cargo slots; init 0. @asm 0x400B8; bound 0xB2A2 */
    uint8_t  cargo_kind_packed[3]; /* +0x0D..0x0F (0x3151-53)  6-slot packed nibbles. @asm 0xB2A2/0xB2C2 */
    union {
        uint8_t  cargo_qty[6]; /* +0x10..0x15 (0x3154-59)  per-slot qty 0..100 */
        struct {
            uint8_t  cargo_qty_lo[4]; /* +0x10..0x13 */
            uint8_t  field_at_14;     /* +0x14 (0x3158) */
            uint8_t  pad_15;          /* +0x15 (0x3159)  cargo-pickup flag (0=free, 2=frozen) */
        };
    };
    union {
        uint8_t  turn_counter; /* +0x16 (0x315A)  inc to cap 8; also repurposed by job-assign */
        uint8_t  field_at_16;  /* +0x16  alias for turn_counter */
    };
    uint8_t  vet_type;         /* +0x17 (0x315B)  veteran/profession type 0x13..0x1C; used in MUL. @asm 0x57374, 0x41FB4 */
    uint16_t chain_prev;       /* +0x18 (0x315C)  tile-occupancy chain PREV (unit idx; 0xFFFF=null). @asm 0x06962 */
    uint16_t chain_next;       /* +0x1A (0x315E)  tile-occupancy chain NEXT (unit idx). @asm 0x06968; read 0x66BA */
};                             /* total 0x1C = 28 bytes; next record at 0x3160 */

#define UNIT_RECORD_STRIDE  0x1C   /* @ref derived from IMUL bx, ax, 0x1C in many functions */
#define UNIT_TABLE_BASE     0x3144 /* DGROUP-relative; base of UnitRecord[] (x@+0).
                                    * NOT 0x3146 — that is the type field (+0x02). The
                                    * struct above documents base 0x3144; this macro had
                                    * the same off-by-2 error. @ref RULINGS 2026-05-28 (unit) */

extern struct UnitRecord far *unit_table;   /* the flat unit array */
extern uint16_t                g_unit_chain_field;  /* DGROUP:0x315C (chain pointer) */

#define unit(idx)  (unit_table[(idx)])

/* ----------------------------------------------------------------------------
 * Cargo accessors
 * ---------------------------------------------------------------------------- */

/* @asm 0xB2A2..0xB2C1  (31 bytes)  bound check; falls through to 0xB2C2 unpacker
 * @ref decompiled.md "unit_cargo_slot_kind_or_neg1"
 * Returns -1 if slot >= cargo_slot_count; otherwise the unpacked nibble. */
int  unit_cargo_slot_kind(int slot, int unit_idx);

/* @asm 0xB2F0..0x?    @ref FUNCTIONS_INVENTORY.md "unit_table_3154_byte"
 * Returns unit[idx].cargo_qty[slot]. */
int  unit_cargo_slot_quantity(int slot, int unit_idx);

/* @asm 0xB304..0xB318  (21 bytes)
 * @ref decompiled.md "unit_cargo_slot_set_quantity" */
void unit_cargo_slot_set_quantity(int unit_idx, int slot, int qty);

/* @asm 0xB42C..0x?     looks up the matching commodity for a unit's load
 * @ref decompiled.md  "colony_receive_commodity_from_unit" — calls 0xB42C */
int  unit_cargo_kind(int unit_idx, int qty);

/* @asm 0xB368..0xB3E5  (126 bytes)
 * @ref decompiled.md "unit_load_commodity_into_slots" */
int  unit_load_commodity_into_slots(int unit_idx, int commodity_idx, int qty);

/* @asm 0x66BA..0x66CB  (18 bytes)  func_0066BA   BYTE_VERIFIED 2026-05-30
 * @ref src/unit/chain.c  unit_chain_next
 * Returns unit[idx].chain_next (the WORD at +0x1A == DGROUP word [idx*0x1C +
 * 0x315E]); returns the input unchanged when idx < 0. NB the old name
 * "unit_field_lookup_simple"/"returns type" was WRONG: 0x315E is +0x1A
 * (chain_next), not +0x00. Corrected & verified against the raw EXE. */
int  unit_chain_next(int idx);

/* @asm 0x6672..0x6694  (35 bytes)  func_006672   BYTE_VERIFIED 2026-05-30
 * @ref src/unit/chain.c  unit_chain_resolve
 * Walks chain_prev (+0x18) upward; returns the head (root) of the tile chain. */
int  unit_chain_resolve(int i);

/* @asm 0x66CC..0x6704  (57 bytes)  func_0066CC   BYTE_VERIFIED 2026-05-30
 * @ref src/unit/chain.c  unit_tile_head
 * Head unit index occupying tile (x,y) via the 0x037F:* map helpers; -1 if none. */
int  unit_tile_head(int x, int y);

/* ----------------------------------------------------------------------------
 * Unit lifecycle  (src/unit/lifecycle.c)   BYTE_VERIFIED 2026-05-30
 * ---------------------------------------------------------------------------- */

/* @asm 0x4007E..0x400CF  (82 bytes)  func_04007E
 * Allocate a new UnitRecord at the table tail (off-map, full moves, no cargo).
 * type = (kind_flag!=0) ? 0x0D : 0x00. Returns the new unit index. */
int16_t unit_create(int16_t kind_flag, int16_t arg_b, int16_t arg_a, int16_t arg_c);

/* @asm 0x693A..0x69D0  (157 bytes)  func_00693A
 * Place unit at (x,y) and insert it at the HEAD of that tile's chain. */
void unit_place_on_tile(int16_t unit_idx, int16_t x, int16_t y);

/* @asm 0x68AA..0x6938  (143 bytes)  func_0068AA
 * Splice a unit out of its tile chain and park it off-map (0xFF,0xFF). */
void unit_chain_unlink(int16_t unit_idx);

/* @asm 0x6E94..0x6F59  (198 bytes)  func_006E94
 * Destroy a unit: unlink, compact the array, renumber all chain links + the
 * selected-unit index, decrement counts. */
void unit_destroy(int16_t unit_idx);

/* ----------------------------------------------------------------------------
 * Unit move-step evaluator  (src/unit/move.c)
 * ---------------------------------------------------------------------------- */

/* @asm 0x4E2D6.. (14975 bytes)  func_04E2D6
 * Per-unit move/action evaluator. HEAD + order-byte dispatch (orders 0/5/6/>=0xA
 * proceed; 1-4,7-9 skip) BYTE_VERIFIED; per-candidate scoring tail not yet decoded. */
int16_t unit_move_step(int16_t unit_index);

/* @asm 0x8B96..0x8BAD  (24 bytes)
 * @ref FUNCTIONS_INVENTORY.md "unit_field_test_at_3146"
 * Tests byte at unit_table_3146[idx]. */
int  unit_field_test_at_3146(int idx);

/* @asm 0x87F4..0x8805  (18 bytes)
 * @ref FUNCTIONS_INVENTORY.md "power_record_read_dword"
 * Wait — this reads a PowerRecord, not a UnitRecord. PowerRecord stride 0x13C.
 * Declared in power.h. */

#endif /* VICEROY_UNIT_H */
