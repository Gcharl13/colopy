/* ============================================================================
 * unit/cargo.c — UnitRecord cargo accessors
 * ----------------------------------------------------------------------------
 * Each unit has up to 6 cargo slots.  Each slot holds:
 *   - a TYPE  (4-bit nibble in cargo_kind_packed[3])
 *   - a QUANTITY (1 byte in cargo_qty[6])
 *
 * The packed-nibble layout:
 *   cargo_kind_packed[0] = (slot[1] << 4) | slot[0]
 *   cargo_kind_packed[1] = (slot[3] << 4) | slot[2]
 *   cargo_kind_packed[2] = (slot[5] << 4) | slot[4]
 *
 * @ref decompiled.md "UnitRecord cargo layout"
 * @ref decompiled.md "unit_load_commodity_into_slots"
 * ============================================================================ */
#include "viceroy.h"

/* ============================================================================
 * unit_cargo_slot_kind — 31-byte bound check + fall-through to 0xB2C2 unpacker
 * @asm 0x00B2A2..0x00B2C1  (31 bytes)
 * @asm 0x00B2C2..0x00B2EF  (continuation: nibble unpacker)
 *
 * The original splits this into a bound-check stub (0xB2A2) that falls
 * through to the nibble unpacker (0xB2C2).  We unify them.
 * ============================================================================ */
int unit_cargo_slot_kind(int slot, int unit_idx)
{
    if (slot >= unit(unit_idx).cargo_slot_count) {
        return -1;       /* @asm 0xB2B6: MOV [bp-4], 0xFFFF */
    }
    /* @asm 0xB2C2..0xB2EF  packed-nibble fetch */
    uint8_t packed = unit(unit_idx).cargo_kind_packed[slot >> 1];
    return (slot & 1) ? ((packed >> 4) & 0xF) : (packed & 0xF);
}

/* ============================================================================
 * unit_cargo_slot_quantity
 * @asm 0x00B2F0..0x?     @ref FUNCTIONS_INVENTORY.md "unit_table_3154_byte"
 *
 * Returns unit[idx].cargo_qty[slot] (byte at +0x3154 + slot).
 * ============================================================================ */
int unit_cargo_slot_quantity(int slot, int unit_idx)
{
    return unit(unit_idx).cargo_qty[slot];
}

/* ============================================================================
 * unit_cargo_slot_set_quantity
 * @asm 0x00B304..0x00B318  (21 bytes)
 *
 * Writes a byte to unit[unit_idx].cargo_qty[slot].
 * Note arg order in original: (unit_idx, slot, qty) per stack-frame.
 * ============================================================================ */
void unit_cargo_slot_set_quantity(int unit_idx, int slot, int qty)
{
    unit(unit_idx).cargo_qty[slot] = (uint8_t)qty;
}

/* ============================================================================
 * unit_load_commodity_into_slots — 126 bytes
 * @asm 0x00B368..0x00B3E5
 *
 * Add `qty` of `commodity_idx` to existing slots (filling first), then
 * allocate new slots if room remains.  Returns leftover qty (0 if all
 * loaded successfully).
 * ============================================================================ */
extern int unit_cargo_slot_kind_or_neg1(int slot, int unit_idx);
extern int unit_alloc_new_slot(int unit_idx, int commodity_idx, int qty);  /* TBD: in same module */

int unit_load_commodity_into_slots(int unit_idx, int commodity_idx, int qty)
{
    /* ---- Phase 1: fill existing matching slots ---- */
    /* @asm 0xB372..0xB3D1  loop slot 0..cargo_slot_count-1 */
    for (int slot = 0; slot < unit(unit_idx).cargo_slot_count; slot++) {
        if (qty == 0) break;
        int slot_kind = unit_cargo_slot_kind(slot, unit_idx);
        if (slot_kind != commodity_idx) continue;

        int existing = unit_cargo_slot_quantity(slot, unit_idx);
        int room_left = 100 - existing;
        if (room_left == 0) continue;
        int adding = (room_left < qty) ? room_left : qty;
        unit_cargo_slot_set_quantity(unit_idx, slot, existing + adding);
        qty -= adding;
    }

    /* ---- Phase 2: try to allocate a new slot for the leftover ---- */
    /* @asm 0xB3D3..0xB3E5  (continues past listing boundary) */
    if (qty > 0 /* and unit has free slot capacity */) {
        unit_alloc_new_slot(unit_idx, commodity_idx, qty);
        qty = 0;
    }

    return qty;
}

/* ----------------------------------------------------------------------------
 * NOTE: the chain primitives that used to live here -- unit_field_lookup_simple
 * (func_0066BA) and unit_chain_resolve (func_006672) -- have moved to
 * src/unit/chain.c, where they are BYTE_VERIFIED against the raw EXE and the
 * earlier mis-labels are corrected:
 *   - func_0066BA returns chain_next (+0x1A word), NOT the type field. It is
 *     now `unit_chain_next(idx)`.
 *   - func_006672 walks chain_prev (+0x18) to the head; the old body here read
 *     a signed BYTE at -2 (wrong: it is a signed WORD at [idx*0x1C + 0x315C]).
 * Keeping a single correct definition avoids a duplicate-symbol clash. (A third
 * stubbed copy exists in src/render/units.c -- flagged for the central de-dup
 * pass; that file is outside this scope.)
 * ---------------------------------------------------------------------------- */

/* ============================================================================
 * unit_field_test_at_3146 — 24 bytes
 * @asm 0x008B96..0x008BAD
 *
 * Tests byte at unit_table[idx].type — returns 1 if non-zero, 0 if zero.
 * Used as a "is-this-unit-active" predicate by init_and_scan_units_in_area.
 * ============================================================================ */
int unit_field_test_at_3146(int idx)
{
    return unit(idx).type != 0;
}
