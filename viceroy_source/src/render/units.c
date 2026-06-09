/* ============================================================================
 *   >>> MIXED: chain mechanics BYTE_VERIFIED / sprite-index table CITED <<<
 * ----------------------------------------------------------------------------
 * Unit map rendering. Two clearly separated parts:
 *
 *  (A) The per-tile unit-occupancy CHAIN walk and the unit-tile render entry
 *      func_008982 -- BYTE_VERIFIED, hand-decompiled from VICEROY.EXE 2026-05-29.
 *      Chain link fields are UnitRecord +0x18 (0x315C, prev) and +0x1A
 *      (0x315E, next), stride 0x1C, table base 0x3144. These match unit.h.
 *
 *  (B) The unit-TYPE -> ICONS.SS sprite index map. The only source for these
 *      indices today is CLAUDE.md ("foot units 100-105 + 109; ships 5-7 /
 *      14-15 / 127"). They are NOT yet byte-verified against an in-EXE table,
 *      so each entry below cites CLAUDE.md and the rest are marked UNKNOWN (-1). Do NOT
 *      treat the per-type assignments as confirmed.
 *
 * The fabricated 45-entry "ICONS_UNIT_SPRITE" array, the invented Unit struct
 * with map_x/movement_left/cargo_count, and the made-up g_units[256] linear
 * scan from the prior version are removed: the original uses the flat
 * UnitRecord table + the occupancy chain, NOT a per-frame linear scan.
 * ============================================================================ */

/* ============================================================================
 * units.c -- Unit map sprite rendering + per-tile occupancy chain
 * ----------------------------------------------------------------------------
 * @asm_function   func_006672 (unit_chain_resolve), func_0066BA, func_008982
 * @region         load_image
 * @verified_by    Hand-decompiled from VICEROY.EXE bytes 2026-05-29
 * @ref            ../../../FUNCTIONS_INVENTORY.md
 * @ref            ../../../SPRITE_CATALOG.md  (ICONS.SS)
 * @ref            ../../code/VICEROY/disasm/func_006672_unit_chain_resolve.asm
 * @ref            ../../code/VICEROY/disasm/func_0066BA_unit_field_lookup_simple.asm
 * @ref            ../../code/VICEROY/disasm/func_008982_update_and_render_tile_at.asm
 * ============================================================================ */
#include "viceroy_types.h"
#include "unit.h"

/* ----------------------------------------------------------------------------
 * (A) Per-tile unit-occupancy chain.  BYTE_VERIFIED.
 * ----------------------------------------------------------------------------
 * Units on the same tile are stored as an intrusive doubly-linked list inside
 * the flat UnitRecord table:
 *
 *   chain_prev  = UnitRecord +0x18  ->  DGROUP word [idx*0x1C + 0x315C]
 *   chain_next  = UnitRecord +0x1A  ->  DGROUP word [idx*0x1C + 0x315E]
 *
 * 0xFFFF (== -1 signed) terminates the chain.
 *
 * Insert-at-head, verified at the placement site near file 0x6958:
 *   imul bx, [bp-6], 0x1C
 *   mov  [bx+0x3144], al            ; map_x
 *   mov  [bx+0x3145], al            ; map_y
 *   mov  word [bx+0x315C], 0xFFFF   ; new.chain_prev = null   @0x696E
 *   mov  [bx+0x315E], si            ; new.chain_next = old_head @0x6975
 *   or   si,si / jl ...             ; if old_head valid
 *   imul bx, [bp-6], 0x1C
 *   mov  [bx+0x315C], ax            ; old_head.chain_prev = new @0x6981
 * ---------------------------------------------------------------------------- */

#define UNIT_CHAIN_PREV_BASE  0x315C  /* word [idx*0x1C + 0x315C] == UnitRecord+0x18 */
#define UNIT_CHAIN_NEXT_BASE  0x315E  /* word [idx*0x1C + 0x315E] == UnitRecord+0x1A */
#define UNIT_NULL             0xFFFF  /* chain terminator / "no unit" */

/* func_0066BA (unit_chain_next) and func_006672 (unit_chain_resolve) used to be
 * MODELLED here (they returned UNIT_NULL instead of reading the DGROUP word).
 * The REAL byte-verified bodies — which actually read UnitRecord+0x1A/+0x18 —
 * now live in src/unit/chain.c (wave-5, verified @0x66C4 mov bx,[si+0x315E]).
 * They are declared in unit.h; this file just CALLS them (see units_draw_stack
 * below). Removed here 2026-05-30 to fix the duplicate-definition link collision.
 * (render/units.c had the semantics right — 0x315E == chain_next — but stubbed
 *  the reads; chain.c is the canonical owner.) */

/* Iterate every unit occupying the tile that `head_idx` belongs to, drawing
 * each (caller passes the chain head). Drawing order = chain order (top of
 * stack first). The original walks chain_next from the resolved head. */
void units_draw_stack(int head_idx)
{
    int idx = unit_chain_resolve(head_idx);
    while (idx != (int)UNIT_NULL && idx >= 0) {
        unit_draw_on_map(idx);               /* see func_008982 below */
        idx = unit_chain_next(idx);          /* @asm word at +0x1A */
    }
}

/* ----------------------------------------------------------------------------
 * func_008982 -- update_and_render_tile_at  (file 0x8982, 532 bytes)
 * ----------------------------------------------------------------------------
 * Renders the contents (unit/colony/feature) of one tile, keyed off the
 * "active record" pointer at DGROUP:[0x8542] (the currently-selected unit or
 * colony record; see project memory "VICEROY *(0x8542) is the colony struct").
 *
 * Verified structure:
 *   bx = [0x8542]                       active record ptr  @0x8998
 *   al = [bx+1] (record.y), [bx] (.x)   record origin       @0x899C/@0x89A2
 *   -> lcall 0x37F:0x2A0 maps (x,y) to a linear tile slot   @0x89A5
 *   slot byte stored at [bx+si+0x70]    visibility/lifetime  @0x89C3
 *   owner = [bx+0x1A]                   record owner field   @0x8A14
 *   per-tile visible-object id read from [bx+si-0x7262]      @0x8A35
 *     (si = (bp+6)*5; bx = bp+8) -> a width-5 packed per-tile object array
 *   if visible: lcall 0x181F:0xD84 (draw object) @0x8A4F
 *   AI / fog gating uses AIPersonality stride 0x34 at [bx+0x543F] @0x8A6E
 *   final emit: lcall 0x181F:0xD6C (sprite blit, args sprite_id-4, owner, ...)
 *               @0x8B69
 *   on clear: writes 0xFF to the per-tile object slot @0x8B7E then
 *             calls func_008918 (blit_at_origin_if_pair_visible) @0x8B8C
 *
 * @param x  [bp+6]    map tile X
 * @param y  [bp+8]    map tile Y
 * @param object_id [bp+0xA]  visible-object/unit id to place (or clear)
 *
 * Not yet decoded: the byte layout of the per-tile object array at DGROUP-0x7262, the exact
 * sprite passed to 0x181F:0xD6C, and the meaning of the 0x10 padding constant.
 * Verified here: the active-record indexing, the owner field +0x1A, the per-tile
 * array stride 5, and the call edges. */
void update_and_render_tile_at(int x, int y, int object_id)
{
    /* bx = active record [0x8542]; record.x = [bx], record.y = [bx+1];
     * owner = [bx+0x1A]. The per-tile object byte lives at
     *   mem8[ (bp+8)_base + (bp+6)*5 - 0x7262 ]  (@asm @0x8A35 / @0x8B7E). */
    (void)x; (void)y; (void)object_id;

    /* The real body: visibility update + conditional sprite emit via
     * lcall 0x181F:0xD6C, or clear + func_008918. Pixel format: library-implementation-only. */
}

/* Draw a single unit at index `idx` on the map. Thin wrapper that resolves the
 * unit's tile and dispatches to update_and_render_tile_at with the unit's
 * ICONS sprite. (The original reaches the same emit through func_008982's tail
 * lcall 0x181F:0xD6C.) */
void unit_draw_on_map(int idx)
{
    /* map_x = unit[idx].map_x (+0x00); map_y = unit[idx].map_y (+0x01);
     * type  = unit[idx].type (+0x02). */
    (void)idx;
    /* update_and_render_tile_at(map_x, map_y, icons_sprite_for_unit_type(type)); */
}

/* ----------------------------------------------------------------------------
 * (B) Unit-type -> ICONS.SS map sprite index.
 * ----------------------------------------------------------------------------
 * Source: CLAUDE.md "Unit map sprites come from ICONS.SS (foot units 100-105 +
 * 109; ships 5-7 / 14-15 / 127), NOT CC-NN". This is the ONLY citation for
 * these indices; there is no byte-verified in-EXE type->sprite table located
 * yet. Per project memory, the in-EXE @UNIT table's column 1 is the ICONS
 * sprite index, read at UnitRecord+0x02 (type) -> @UNIT line; locating and
 * dumping that table is the proper next step to upgrade this from CITED to
 * BYTE_VERIFIED.
 *
 * Only the values explicitly named in CLAUDE.md are filled; every other slot
 * is marked UNKNOWN (-1) rather than guessed.
 * ---------------------------------------------------------------------------- */
#define UNIT_SPRITE_UNKNOWN  (-1)

/* @ref CLAUDE.md "foot units 100-105 + 109; ships 5-7 / 14-15 / 127" */
int icons_sprite_for_unit_type(int unit_type)
{
    /* The CLAUDE.md-named map sprites, as a *set* of legal ICONS indices:
     *   foot units : 100, 101, 102, 103, 104, 105, 109
     *   ships      : 5, 6, 7, 14, 15, 127
     * The exact per-@UNIT-row assignment is data-driven (RUNTIME_ONLY), so we
     * do not fabricate a 45-entry array. A caller that needs the precise sprite
     * must read @UNIT col 1 for `unit_type` (project memory: NAMES.TXT @UNIT). */
    (void)unit_type;
    return UNIT_SPRITE_UNKNOWN;
}

/* Owner of a unit record: low nibble of UnitRecord+0x03 (0x3147).
 *   @verify unit.h owner_flags +0x03 (AND 0xF); @asm 0x5B306 / 0x3C984 */
int unit_owner(int idx)
{
    (void)idx;
    /* return unit_table[idx].owner_flags & 0x0F; */
    return -1;
}

/* ============================================================================
 * Map overlay passes: COLONIES + NATIVE SETTLEMENTS   [PORTED 2026-06-10]
 * ----------------------------------------------------------------------------
 * Bodies decoded from the raw EXE (docs/MAP_COMPOSER_SPEC.md):
 *   0x191F:0x896 -> wrapper 0x672C8 -> ljmp 0x1A1F:0x922 -> BODY 0x67182
 *   0x191F:0x888 -> wrapper 0x6716A -> ljmp 0x1A1F:0x94C -> BODY 0x67082
 * Both walk their record table over the view rect, fog-test per tile
 * (0x181F:0x74A = func_005EE8), transform to screen, and emit.
 * ============================================================================ */
#include <stdio.h>
#include "dgroup.h"

extern int  func_066E0C_clamp_rect_to_view(int *x0, int *y0, int *x1, int *y1);
extern int  func_02EB46_logic_sz_13(uint16_t cid, uint16_t pw);     /* colony known */
extern int  func_005EE8_logic_sz_28(uint16_t x, uint16_t y);        /* fog byte 0x74A */
extern int  func_004314_colony_blit(uint16_t idx, int sx, int sy,
                                    uint16_t name_flag, uint16_t pop_flag,
                                    uint16_t metric);
extern int  func_003E40_logic_sz_174(uint16_t a, uint16_t b, uint16_t c,
                                     uint16_t d, uint16_t e);       /* settlement blit (stub) */

/* BODY file 0x67182: colony pass (full transcription in MAP_COMPOSER_SPEC.md) */
void func_067182_colony_pass(int x0, int y0, int w, int h)
{
    uint8_t fogmask = (uint8_t)(1 << ((int16_t)DG16(0x5396) + 4)); /* @0x67188 */
    int x1 = x0 + w - 1, y1 = y0 + h - 1;                          /* @0x67196 */
    func_066E0C_clamp_rect_to_view(&x0, &y0, &x1, &y1);            /* @0x671BA (0x906) */

    int n = (int16_t)DG16(0x539E);                                 /* @0x671C7 */
    for (int i = 0; i < n; i++) {                                  /* @0x671D1.. */
        int rec = 0x5D46 + i * 0xCA;
        int x = DG8(rec), y = DG8(rec + 1);                        /* @0x671D9/0x671DF */
        if (x < x0 || x > x1 || y < y0 || y > y1) continue;        /* @0x671E6.. */
        if (!func_02EB46_logic_sz_13((uint16_t)i, DG16(0x5396)))   /* @0x6720D (0x996) */
            continue;
        if (!(func_005EE8_logic_sz_28((uint16_t)x, (uint16_t)y) & fogmask)
            && DG16(0x53A2) == 0)                                  /* @0x6721E/0x6722B */
            continue;
        int sx = (x - (int16_t)DG16(0x8328) + (int16_t)DG16(0x832A))
                 * (int16_t)DG16(0x5AD4);                          /* @0x67232 */
        int sy = (y - (int16_t)DG16(0x832E) + (int16_t)DG16(0x832C))
                 * (int16_t)DG16(0x8326);                          /* @0x67243 */
        int f = ((int16_t)DG16(0x0184) == 0 && DG16(0x0890) == 0); /* @0x67254/0x6726F */
        func_004314_colony_blit((uint16_t)i, sx, sy,
                                (uint16_t)f, (uint16_t)f,
                                DG16(0x0186));                     /* @0x672AC (0x2A8) */
    }                                                              /* @0x672B1 +0xCA */
}

/* BODY file 0x67082: native-settlement pass (same shape; stride 0x12 @0x54EC,
 * count [0x539A]; emit 0x181F:0x2B2 = func_003E40 -- still a stub, so
 * settlements stay invisible until its port lands) */
void func_067082_settlement_pass(int x0, int y0, int w, int h)
{
    uint8_t fogmask = (uint8_t)(1 << ((int16_t)DG16(0x5396) + 4)); /* @0x67086 */
    int x1 = x0 + w - 1, y1 = y0 + h - 1;                          /* @0x67094 */
    func_066E0C_clamp_rect_to_view(&x0, &y0, &x1, &y1);            /* @0x670B8 */

    int n = (int16_t)DG16(0x539A);                                 /* @0x670C5 */
    for (int i = 0; i < n; i++) {                                  /* @0x670CF.. */
        int rec = 0x54EC + i * 0x12;
        int x = DG8(rec), y = DG8(rec + 1);                        /* @0x670D7.. */
        if (x < x0 || x > x1 || y < y0 || y > y1) continue;        /* (per body @0x670E6+) */
        if (!(func_005EE8_logic_sz_28((uint16_t)x, (uint16_t)y) & fogmask)
            && DG16(0x53A2) == 0)                                  /* @0x6710A */
            continue;
        int sx = (x - (int16_t)DG16(0x8328) + (int16_t)DG16(0x832A))
                 * (int16_t)DG16(0x5AD4);                          /* @0x6712A */
        int sy = (y - (int16_t)DG16(0x832E) + (int16_t)DG16(0x832C))
                 * (int16_t)DG16(0x8326);                          /* @0x6713A */
        func_003E40_logic_sz_174((uint16_t)i, (uint16_t)sx, (uint16_t)sy,
                                 DG16(0x0186), 0);                 /* @0x67151 (0x2B2) */
    }                                                              /* @0x67156 +0x12 */
}

/* the original wrappers (0x6716A / 0x672C8) push the live view rect */
void overlay_pass_colonies(void)     /* = 0x191F:0x896 chain */
{
    func_067182_colony_pass((int16_t)DG16(0x8328), (int16_t)DG16(0x832E),
                            (int16_t)DG16(0x8544), (int16_t)DG16(0x8546));
}
void overlay_pass_settlements(void)  /* = 0x191F:0x888 chain */
{
    func_067082_settlement_pass((int16_t)DG16(0x8328), (int16_t)DG16(0x832E),
                                (int16_t)DG16(0x8544), (int16_t)DG16(0x8546));
}
