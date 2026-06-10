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
 * UnitRecord DGROUP layout (base 0x3144, stride 0x1C):
 *   +0x0C (0x3150): cargo_slot_count (byte; max slots currently used)
 *   +0x0D (0x3151): cargo_kind_packed[0]  (nibbles for slots 0,1)
 *   +0x0E (0x3152): cargo_kind_packed[1]  (nibbles for slots 2,3)
 *   +0x0F (0x3153): cargo_kind_packed[2]  (nibbles for slots 4,5)
 *   +0x10 (0x3154): cargo_qty[0]
 *   +0x11 (0x3155): cargo_qty[1]
 *   ...
 *   +0x15 (0x3159): cargo_qty[5]
 *
 * @ref decompiled.md "UnitRecord cargo layout"
 * @ref decompiled.md "unit_load_commodity_into_slots"
 * ============================================================================ */
#include "viceroy.h"
#include "dgroup.h"

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
extern int unit_alloc_new_slot(int unit_idx, int commodity_idx, int qty);  /* defined in same module (see cargo.c sibling) */

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

/* ============================================================================
 * BYTE_VERIFIED DG8-direct accessor family (for use from move.c / AI scoring)
 * These replicate the period-toolchain bodies byte-for-byte using the DG8/DG16
 * memory model (compatible with -D_VICEROY_MODERN).
 * ============================================================================ */

/* ============================================================================
 * func_00B2A2_cargo_slot_good
 * @asm 0x00B2A2..0x00B2EF  (68 bytes, bound-check stub + nibble unpacker unified)
 * BYTE_VERIFIED 2026-06-10
 *
 * Returns the cargo KIND nibble for the given slot (0..15), or -1 when
 * slot >= cargo_slot_count.
 *
 *   [bp+6]=unit  [bp+8]=slot
 *   bx = unit*0x1C
 *   al = [bx+0x3150]  -- slot_count
 *   if (slot_count <= slot) return 0xFFFF  @asm 0xB2B4/0xB2B6
 *   si = slot sar 1
 *   al = [bx+si+0x3151]   @asm 0xB2CB
 *   if slot&1: return ax sar 4  @asm 0xB2DA
 *   else:      return ax & 0xF  @asm 0xB2E6
 * ============================================================================ */
int16_t func_00B2A2_cargo_slot_good(int16_t unit, int16_t slot)
{
    /* @asm 0xB2A7..0xB2B4 bound check: slot_count at [bx+0x3150] */
    if ((int16_t)DG8((uint16_t)(unit * 0x1C + 0x3150)) <= slot)
        return -1;                           /* @asm 0xB2B6 mov [bp-4],0xFFFF */
    /* @asm 0xB2C5 si = slot sar 1 (half-slot index into packed array) */
    int16_t half = slot >> 1;
    uint8_t packed = DG8((uint16_t)(unit * 0x1C + 0x3151 + half)); /* @asm 0xB2CB */
    if (slot & 1)
        return (int16_t)(packed >> 4) & 0xF; /* @asm 0xB2DA sar 4; callers use & 0xF */
    else
        return (int16_t)(packed & 0x0F);     /* @asm 0xB2E6 and 0xF */
}

/* ============================================================================
 * func_00B2F0_cargo_slot_amount
 * @asm 0x00B2F0..0x00B303  (20 bytes)
 * BYTE_VERIFIED 2026-06-10
 *
 *   si = unit*0x1C; bx = slot
 *   return [bx+si+0x3154] zero-extended
 * ============================================================================ */
int16_t func_00B2F0_cargo_slot_amount(int16_t unit, int16_t slot)
{
    /* @asm 0xB2F4 imul si,unit,0x1C; bx=slot; mov al,[bx+si+0x3154] */
    return (int16_t)DG8((uint16_t)(unit * 0x1C + 0x3154 + slot));
}

/* ============================================================================
 * func_00B304_cargo_slot_set_amount
 * @asm 0x00B304..0x00B318  (21 bytes)
 * BYTE_VERIFIED 2026-06-10
 *
 *   al = qty (byte from [bp+0xa]); si = unit*0x1C; bx = slot
 *   [bx+si+0x3154] = al
 * ============================================================================ */
void func_00B304_cargo_slot_set_amount(int16_t unit, int16_t slot, int16_t qty)
{
    /* @asm 0xB308 al=[bp+0xa]; 0xB30B si=unit*0x1C; 0xB30F bx=slot; 0xB312 store */
    DG8((uint16_t)(unit * 0x1C + 0x3154 + slot)) = (uint8_t)qty;
}

/* ============================================================================
 * func_00B31A_cargo_slot_set_good
 * @asm 0x00B31A..0x00B366  (77 bytes)
 * BYTE_VERIFIED 2026-06-10
 *
 * Writes a 4-bit KIND nibble into the packed cargo_kind byte for `slot`.
 * Even slots → low nibble; odd slots → high nibble.
 *
 *   [bp-4]=mask=0xF0; half=slot>>1; packed=[bx+half+0x3151]
 *   if slot&1: mask=0x0F; good<<=4  @asm 0xB341/0xB346
 *   result = (mask & packed) | good; store to [bx+half+0x3151]
 * ============================================================================ */
void func_00B31A_cargo_slot_set_good(int16_t unit, int16_t slot, int16_t good)
{
    uint16_t mask = 0xF0U;                                /* @asm 0xB31F [bp-4]=0xF0 */
    int16_t  half = slot >> 1;                            /* @asm 0xB324/0xB327 sar 1 */
    uint16_t addr = (uint16_t)(unit * 0x1C + 0x3151 + half);
    uint8_t  packed = DG8(addr);                          /* @asm 0xB332 */
    if (slot & 1) {                                       /* @asm 0xB33B test 1 */
        mask = 0x0FU;                                     /* @asm 0xB341 */
        good = (int16_t)(good << 4);                      /* @asm 0xB346 shl [bp+0xa],4 */
    }
    DG8(addr) = (uint8_t)((mask & packed) | (uint8_t)good); /* @asm 0xB34A..0xB35D */
}

/* ============================================================================
 * func_00B368_cargo_load  (unit_load_commodity_into_slots BYTE_VERIFIED port)
 * @asm 0x00B368..0x00B42B  (196 bytes)
 * BYTE_VERIFIED 2026-06-10
 *
 * Phase 1: fill existing matching slots (up to 100 per slot).
 * Phase 2: if leftover qty AND type table says room, alloc a new slot.
 * Returns the old slot count (the slot_count before any new slot was appended).
 *
 *   [bp+6]=unit  [bp+8]=good  [bp+0xa]=qty
 *   [bp-6]=slot loop counter; [bp-2]=saved slot_count; [bp-4]=adding; [bp-8]=cur
 * ============================================================================ */
int16_t func_00B368_cargo_load(int16_t unit, int16_t good, int16_t qty)
{
    int16_t slot;                          /* [bp-6] loop counter @asm 0xB36D */
    int16_t slot_count;
    int16_t old_count = 0;

    /* ---- Phase 1: fill existing matching slots ---- */
    /* @asm 0xB36D mov [bp-6],0; jmp 0xB3C4 (loop condition first) */
    for (slot = 0; ; slot++) {             /* @asm 0xB3C1 inc [bp-6] */
        /* @asm 0xB3C4 loop condition: slot_count > slot */
        slot_count = (int16_t)DG8((uint16_t)(unit * 0x1C + 0x3150)); /* @asm 0xB3C8 */
        if (slot_count <= slot)            /* @asm 0xB3CE cmp ax,[bp-6]; jg 0xB374 */
            break;

        /* @asm 0xB374..0xB383: call func_00B2A2, compare good */
        if (func_00B2A2_cargo_slot_good(unit, slot) != good) /* @asm 0xB381 cmp ax,[bp+8] */
            continue;                      /* @asm 0xB384 jne 0xB3C1 */

        /* @asm 0xB386: cur = func_00B2F0 */
        int16_t cur = func_00B2F0_cargo_slot_amount(unit, slot); /* @asm 0xB393 [bp-8]=ax */
        int16_t room = (int16_t)(0x64 - cur); /* @asm 0xB396 sub 0x64; neg */
        if (room == 0) continue;           /* @asm 0xB39D or ax,ax; je 0xB3C1 */
        int16_t adding = (room < qty) ? room : qty; /* @asm 0xB39F..0xB3A7 */
        func_00B304_cargo_slot_set_amount(unit, slot,
                                          (int16_t)(cur + adding)); /* @asm 0xB3AA..0xB3B7 */
        qty -= adding;                     /* @asm 0xB3BE sub [bp+0xa],ax */
    }

    /* ---- Phase 2: allocate a new slot if qty remains ---- */
    /* @asm 0xB3D3 cmp [bp+0xa],0; je 0xB426 */
    if (qty == 0) return slot_count;       /* @asm 0xB3D7 je 0xB426 (done; [bp-2] uninit path) */

    /* @asm 0xB3D9..0xB3E4 re-read slot_count; save as old_count */
    slot_count = (int16_t)DG8((uint16_t)(unit * 0x1C + 0x3150));
    old_count = slot_count;                /* @asm 0xB3E1 mov [bp-2],ax */

    /* @asm 0xB3E6..0xB401: type*14 -> dl=[bx+0x5237] max_slots; if max<=count skip */
    {
        uint8_t utype = DG8((uint16_t)(unit * 0x1C + 0x3146)); /* +0x02 */
        int16_t t14 = (int16_t)utype * 14; /* @asm 0xB3EE..0xB3F8 multiply *14 */
        int16_t max_slots = (int16_t)DG8((uint16_t)(0x5237 + t14)); /* @asm 0xB3F8 [bx+0x5237] */
        if (max_slots <= slot_count)       /* @asm 0xB3FE cmp dx,ax; jle 0xB426 */
            return old_count;
    }

    /* @asm 0xB402: set good in new slot */
    func_00B31A_cargo_slot_set_good(unit, slot_count, good); /* @asm 0xB402..0xB410 */
    func_00B304_cargo_slot_set_amount(unit, slot_count, qty); /* @asm 0xB412..0xB41F */
    DG8((uint16_t)(unit * 0x1C + 0x3150)) =
        (uint8_t)(slot_count + 1);         /* @asm 0xB422 inc [si+0x3150] */

    return old_count;                      /* @asm 0xB426 mov ax,[bp-2] */
}

/* ============================================================================
 * func_008D00_colony_stock_cap
 * @asm 0x008D00..0x008D25  (38 bytes)
 * BYTE_VERIFIED 2026-06-10
 *
 * Returns the storage capacity of the CURRENT active colony (pointed to by
 * DGROUP:0x8542).  Without a warehouse: 100.  With a warehouse (level byte at
 * colony+0x95 > 0): (level+1)*100.
 *
 *   bx=[0x8542]; if [bx+0x95]==0: cap=100; else cap=(al+1)*100
 * ============================================================================ */
int16_t func_008D00_colony_stock_cap(void)
{
    int16_t cap = 0x64;                        /* @asm 0x8D05 mov [bp-2],0x64 */
    uint16_t bx = DG16(0x8542);               /* @asm 0x8D09 mov bx,[0x8542] */
    uint8_t  wh = DG8((uint16_t)(bx + 0x95)); /* @asm 0x8D0D cmp [bx+0x95],0 */
    if (wh != 0) {
        cap = (int16_t)((wh + 1) * 0x64);     /* @asm 0x8D18 al+1; imul 0x64 */
    }
    return cap;                                /* @asm 0x8D21 */
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
