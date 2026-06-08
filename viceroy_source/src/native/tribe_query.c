/* ============================================================================
 *     >>> NATIVE SETTLEMENT QUERY — BYTE_VERIFIED (control flow + helper) <<<
 * ----------------------------------------------------------------------------
 * func_046FC2 is a small iterator over the 18-byte NativeSettlement table: it
 * walks every live settlement and invokes an overlay helper on each one whose
 * owner field (+0x02) matches a given tribe.  The loop bounds, the stride, the
 * field compared, the +4 tribe->power conversion, and the semantics of the
 * per-match helper are all now byte-traced.
 *
 * @asm_function  func_046FC2  (file 0x046FC2..0x046FF9, 56 bytes)
 * @asm_disasm    disasm_overlay_reseg/page_0C.asm (page 0x0C, code_base 0x46600)
 * @verified_by   Hand-decompiled 2026-05-30 from the re-segmented overlay dump.
 *                Helper resolved 2026-06-08 via RTLink flatten.py thunk trace.
 *
 * ----------------------------------------------------------------------------
 * KEY FINDING (BYTE_VERIFIED): NativeSettlement +0x02 stores a POWER INDEX,
 * not a raw 0..7 tribe id.
 *
 * This function takes a tribe id in [BP+6], adds 4, and compares the result
 * against the settlement record's +0x02 byte (addressed as [bx+0x54EE]):
 *
 *   @asm 0x046FC6  mov ax,[bp+6]      ; tribe id argument
 *   @asm 0x046FC9  add ax,4           ; -> power index  (natives occupy 4..11)
 *   @asm 0x046FCC  mov [bp-4],ax      ; match key
 *   ...
 *   @asm 0x046FDF  cmp byte [bx+0x54EE],al   ; record[+0x02] == (tribe+4)?
 *
 * The companion display function func_046DE0 reads the same +0x02 byte as a
 * "class" and indexes a per-class table with (class-4)*0x4E (see settlement.c
 * native_settlement_value_for_display) — i.e. it ALSO subtracts 4.  Both sites
 * therefore agree that +0x02 = tribe_id + 4 = the power index, where:
 *     power 0..3   = the four European powers (England/France/Spain/Holland)
 *     power 4..11  = the eight native tribes (Inca..Tupi, @TRIBES order)
 * This matches the native-unit owner test in raid.c ([bx+0x3147]&0xF >= 4 =
 * native) and func_046FFA's prologue (unit owner-nibble - 4 -> tribe).  The
 * settlement.c "owner (tribe id)" label on native_settlement_add's +0x02 write
 * is therefore the POWER INDEX that the caller has already biased by +4; the
 * raw tribe id is (power - 4).  [BYTE_VERIFIED]
 * ============================================================================ */
#include "viceroy_types.h"
#include "native.h"

extern uint8_t  g_native_table_54EC[];   /* DGROUP:0x54EC — NativeSettlement[] base, stride 0x12 */
extern int16_t  g_native_count_539A;     /* DGROUP:0x539A — live settlement count (word) */

/* Near call 0x5402 in page_0C is an RTLink trampoline:
 *   @asm 0x04BA02  ljmp 0x191F:0x0248
 * i.e. a far call through the RTLink thunk table.
 *
 * THUNK RESOLUTION (BYTE_VERIFIED 2026-06-08):
 *   0x191F:0x0248 encodes the SEG-field address of thunk #48 in the 0x191F table.
 *   Thunk #48 (file 0x1BE30, 12-byte Type-A):  segid=2  off=0x0FCE  extra=0
 *   Resolution: seg2_base(0x025900) + 0x0FCE = file 0x0268CE
 *   Confirmed by:  python3 flatten.py 2 0x0FCE  ->  'overlay 2:0x0fce -> file 0x0268ce (STRONG)'
 *
 * TARGET: func_0268CE  (file 0x0268CE..0x026AB0, 483 bytes, 174 instructions)
 * SEMANTIC (BYTE_VERIFIED):  native_colony_interaction_dialog(settlement_index)
 *
 *   Displays a multi-field event notification dialog about a native tribe's
 *   interaction with the colony pointed to by the global DGROUP:0x8542
 *   (ColonyRecord ptr, set by the caller before the loop).
 *
 *   Guard conditions — silently skips if any hold:
 *     (a) colony[+0x1a] (owner class) < 4  AND  player_table[owner][0] == 0
 *         i.e. the colony belongs to an inactive / eliminated European player
 *     (b) DGROUP:0x0B98 != 0  (some global suppression flag)
 *     (c) DGROUP:0x0828 != 0  (a second suppression flag; possibly AI/auto-mode)
 *
 *   Main path (colony is active / native-owned):
 *     Builds a formatted text buffer containing:
 *       - Colony identifier: colony[+0x1b] right-padded to 8 chars  [0x181F:0x1A0]
 *       - 4 numeric values from colony[+0x8C..+0x8F]  (tribute goods quantities)
 *         at index i=1, a string label is also fetched from [colony[+0x8D]*2 - 0x6840]
 *       - A string from DGROUP:0x2E38  (event-type label)
 *       - Colony map location from (colony[+0x00], colony[+0x01])  [0x181F:0x722]
 *       - A table value indexed by (colony[+0x1a] * 16 + location_code - 0x6790)
 *       - Game year from DGROUP:0x93A0  [0x181F:0x22]
 *       - Colony owner-class name  [0x181F:0xB1E]
 *     Then renders the complete dialog via 0x181F:0x00B0(settlement_index, ss:buf).
 *     When settlement_index != 0 the dialog renderer additionally highlights the
 *     settlement's map location (via lcall 0x0B70:0x003A with screen coordinates).
 *
 *   Alt path (guard triggered):
 *     Builds a shortened message using the colony's name/pointer string and
 *     the current player data (DGROUP:0x538A value, DGROUP:0x538C player-name
 *     index), then joins the common year/owner-class/dialog tail.
 *
 *   SETTLEMENT TABLE: NOT MODIFIED.  This function is display-only; it does not
 *   write to the NativeSettlement table, does not decrement 0x539A, and does not
 *   compact records.  The descending iteration in native_foreach_settlement_of_tribe
 *   is a conservative safety pattern (the comment about settlement teardown was
 *   speculative; the resolved target is a notification helper, not a removal helper).
 *
 * @BYTE_VERIFIED  thunk bytes 0x1BE30..0x1BE3B; flatten.py STRONG resolution;
 *                 full 174-instruction disasm traced at re_work/disasm/func_0268CE.asm */
extern void ovly_191F_0248(int settlement_index);   /* -> func_0268CE  native_colony_interaction_dialog */

/* ============================================================================
 * native_foreach_settlement_of_tribe — BYTE_VERIFIED (loop + helper)
 *
 * Walk the NativeSettlement table from the last live slot down to slot 0 and
 * call native_colony_interaction_dialog(i) for every settlement owned by
 * `tribe_id`.
 *
 *   @asm 0x046FC6..0x046FCC  key = tribe_id + 4              ; power index
 *   @asm 0x046FCF..0x046FD3  i   = count(0x539A) - 1
 *   @asm 0x046FD6           jmp test                         ; check-then-body
 *   @asm 0x046FDB           imul bx,i,0x12                   ; stride 0x12
 *   @asm 0x046FDF           cmp byte [bx+0x54EE],al          ; record[+0x02] == key?
 *   @asm 0x046FE3           jne skip
 *   @asm 0x046FE5..0x046FE9 push i ; call 0x5402             ; helper(i)
 *   @asm 0x046FEF           dec i
 *   @asm 0x046FF2..0x046FF6 cmp i,0 ; jge body               ; i >= 0 continues
 *
 * Note the descending iteration: the table is walked high-to-low.  This was
 * previously annotated as a safety precaution against compaction-on-removal,
 * but the resolved helper (func_0268CE) is display-only and does NOT modify the
 * settlement table.  The reverse walk is therefore a conservative coding pattern
 * that does no harm; it does not reflect any live compaction by this helper.
 * ============================================================================ */
void native_foreach_settlement_of_tribe(int tribe_id)
{
    /* @asm 0x046FC6..0x046FCC — power index = tribe id + 4 (see banner). */
    uint8_t key = (uint8_t)(tribe_id + 4);

    /* @asm 0x046FCF..0x046FF6 — descending walk over the live table. */
    for (int i = g_native_count_539A - 1; i >= 0; i--) {
        uint8_t *rec = &g_native_table_54EC[i * NATIVE_SETTLEMENT_STRIDE];
        if (rec[0x02] == key) {              /* @asm 0x046FDF cmp [bx+0x54EE],al */
            ovly_191F_0248(i);               /* @asm 0x046FE9 call 0x5402 -> func_0268CE */
        }
    }
}
