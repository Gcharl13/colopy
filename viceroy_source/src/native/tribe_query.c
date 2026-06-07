/* ============================================================================
 *        >>> NATIVE SETTLEMENT QUERY — BYTE_VERIFIED (control flow) <<<
 * ----------------------------------------------------------------------------
 * func_046FC2 is a small iterator over the 18-byte NativeSettlement table: it
 * walks every live settlement and invokes an overlay helper on each one whose
 * owner field (+0x02) matches a given tribe.  The loop bounds, the stride, the
 * field compared, and the +4 tribe->power conversion are all byte-traced.  The
 * SEMANTICS of the per-match helper are TBD (it is a far call into overlay
 * 0x191F whose target is not yet resolved).
 *
 * @asm_function  func_046FC2  (file 0x046FC2..0x046FF9, 56 bytes)
 * @asm_disasm    disasm_overlay_reseg/page_0C.asm (page 0x0C, code_base 0x46600)
 * @verified_by   Hand-decompiled 2026-05-30 from the re-segmented overlay dump.
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
 * i.e. a far call into overlay 0x191F.  The target routine is not yet resolved
 * (overlay 0x191F is one of the still-opaque overlays — see project memory
 * "core logic blocked behind overlays 0x191F/0x181F"), so the per-settlement
 * action it performs is TBD.  ANCHOR_VERIFIED via the call site only. */
extern void ovly_191F_0248(int settlement_index);   /* near 0x5402 -> ljmp 0x191F:0x0248 */

/* ============================================================================
 * native_foreach_settlement_of_tribe — BYTE_VERIFIED (loop), helper TBD
 *
 * Walk the NativeSettlement table from the last live slot down to slot 0 and
 * call ovly_191F_0248(i) for every settlement owned by `tribe_id`.
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
 * Note the descending iteration: like native_settlement_remove, the table is
 * walked high-to-low so that any compaction the helper triggers does not skip
 * records.  (The helper IS allowed to remove settlements — 0x191F:0x0248 is the
 * same overlay family that owns settlement teardown — which is the documented
 * reason for the reverse walk.  TBD until the target is resolved.)
 * ============================================================================ */
void native_foreach_settlement_of_tribe(int tribe_id)
{
    /* @asm 0x046FC6..0x046FCC — power index = tribe id + 4 (see banner). */
    uint8_t key = (uint8_t)(tribe_id + 4);

    /* @asm 0x046FCF..0x046FF6 — descending walk over the live table. */
    for (int i = g_native_count_539A - 1; i >= 0; i--) {
        uint8_t *rec = &g_native_table_54EC[i * NATIVE_SETTLEMENT_STRIDE];
        if (rec[0x02] == key) {              /* @asm 0x046FDF cmp [bx+0x54EE],al */
            ovly_191F_0248(i);               /* @asm 0x046FE9 call 0x5402 (TBD target) */
        }
    }
}
