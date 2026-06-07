/* ============================================================================
 * overlay/rtlink.c — RTLink/Plus overlay system
 * ----------------------------------------------------------------------------
 * VICEROY.EXE uses RTLink/Plus (Pocket Soft) to manage 362 KB of overlay
 * code in 82 distinct overlay segments.  Without RTLink, the game would
 * exceed the 640 KB conventional-memory limit.
 *
 * @ref formats/RTLINK.md (full byte-level format)
 * @ref code/VICEROY/overlay_thunks.md (1,020 thunk catalog)
 *
 * Architecture:
 *   1. THE THUNK TABLE at file 0x01A5F0 (12,278 bytes, 1020 entries)
 *      — every cross-segment call goes through one of these.
 *   2. TWO RUNTIME ENTRY POINTS:
 *        0x110D:0x0DAB at file 0x1427B (24 bytes; type-A)
 *        0x110D:0x0D91 at file 0x14261 (26 bytes; type-B)
 *   3. SHARED BODY at file 0x14293 (1018 bytes) called by both entries
 *   4. SEGMENT-LOOKUP DISPATCHER at file 0x164A2 (59 bytes)
 *   5. SIX STORAGE-CLASS HELPERS at file 0x164FE / 0x164E8 / 0x16564 /
 *                                       0x16516 / 0x16837 / 0x167F2
 *   6. EXE FILE-OPEN HELPER at file 0x01A488 (~13 bytes; near-call helper
 *                                              that opens VICEROY.EXE
 *                                              for read)
 *
 * The thunks come in two formats:
 *   Type-A: 14-byte stub with variable trailer (2/4/6 bytes)
 *   Type-B: 10-byte stub
 *
 * Each thunk carries:
 *   - The target segment id (1 byte)
 *   - The target offset within the segment (2 bytes)
 *   - A patch-on-load LJMP placeholder
 *
 * When a thunk is called:
 *   1. The first call falls into the runtime entry stub (0DAB or 0D91)
 *   2. The runtime loads the target overlay segment from VICEROY.EXE
 *      into the EMS/conventional buffer reserved by system_init
 *   3. The LJMP placeholder is patched with the loaded segment's address
 *   4. Control jumps to the target offset
 *   5. Subsequent calls bypass the load (jump straight via the patched LJMP)
 * ============================================================================ */
#include "viceroy.h"
#include "rtlink.h"
#include "dos.h"

extern int  rtlink_load_segment_into_buffer(int seg_id);
extern void rtlink_patch_thunk_ljmp(struct rtlink_thunk *thunk, uint16_t loaded_seg);

/* ============================================================================
 * RTLink runtime entry — type-A thunks (14-byte format)
 * @asm 0x01427B  (24 bytes)
 *
 * Pop the LJMP target address off the stack, look up the requested segment,
 * load it if not resident, patch the LJMP, and far-return into it.
 * ============================================================================ */
void __cdecl rtlink_runtime_entry_typeA(void)
{
    /* @asm 0x01427B..0x014293  type-A entry */
    struct rtlink_thunk *thunk = pop_thunk_address_from_stack();
    int seg_id = thunk->target_seg_id;

    if (!rtlink_segment_is_resident(seg_id)) {
        rtlink_load_segment_into_buffer(seg_id);
    }
    uint16_t loaded_seg = rtlink_segment_lookup_164A2(seg_id);
    rtlink_patch_thunk_ljmp(thunk, loaded_seg);

    /* Tail-jump into the just-patched LJMP — execution resumes in the loaded segment */
    far_jump(loaded_seg, thunk->target_offset);
}

/* ============================================================================
 * RTLink runtime entry — type-B thunks (10-byte format)
 * @asm 0x014261  (26 bytes)
 * ============================================================================ */
void __cdecl rtlink_runtime_entry_typeB(void)
{
    /* @asm 0x014261..0x014293  type-B entry; shares body with type-A */
    rtlink_runtime_entry_typeA();
}

/* ============================================================================
 * Shared runtime body
 * @asm 0x014293  (1018 bytes)
 * @ref formats/RTLINK.md
 *
 * The body that both entries call.  Implements:
 *   - Pop LJMP target from stack
 *   - Call segment_lookup_164A2 (segment-id → resident-seg or 0)
 *   - If not resident, page in from VICEROY.EXE on disk
 *   - Patch the LJMP placeholder
 *   - Far-return to the (now-patched) LJMP
 * ============================================================================ */

/* ============================================================================
 * rtlink_segment_lookup — 59 bytes
 * @asm 0x0164A2..0x0164DD
 * @ref FUNCTIONS_INVENTORY.md "rtlink_segment_lookup"
 *
 * Dispatcher across 6 storage-class helpers (each handles a specific
 * memory region: conventional, EMS, XMS, etc.).
 * ============================================================================ */
extern uint16_t rtlink_storage_class_164FE(int seg_id);   /* conventional? */
extern uint16_t rtlink_storage_class_164E8(int seg_id);
extern uint16_t rtlink_storage_class_16564(int seg_id);
extern uint16_t rtlink_storage_class_16516(int seg_id);
extern uint16_t rtlink_storage_class_16837(int seg_id);
extern uint16_t rtlink_storage_class_167F2(int seg_id);

uint16_t rtlink_segment_lookup_164A2(int seg_id)
{
    /* @asm 0x164A2..0x164DD  Six-way switch on the storage class */
    int storage_class = (seg_id >> 5) & 7;   /* approximate; @ref RTLINK.md */
    switch (storage_class) {
    case 0: return rtlink_storage_class_164FE(seg_id);
    case 1: return rtlink_storage_class_164E8(seg_id);
    case 2: return rtlink_storage_class_16564(seg_id);
    case 3: return rtlink_storage_class_16516(seg_id);
    case 4: return rtlink_storage_class_16837(seg_id);
    case 5: return rtlink_storage_class_167F2(seg_id);
    default: return 0;
    }
}

/* ============================================================================
 * rtlink_open_exe_for_overlay_read — ~13 bytes
 * @asm 0x01A488..0x01A494
 *
 * The 7-instruction near-callable helper used by the RTLink overlay loader
 * to open VICEROY.EXE itself for reading overlay segments.
 *
 *   PUSH DS
 *   MOV  DS, [BP+0xC]      ; load filename segment
 *   XOR  DX, DX            ; offset 0
 *   MOV  AL, [BP+0xE]      ; access mode
 *   MOV  AH, 0x3D
 *   INT  21h               ; → AX = handle, CF = error flag
 *   POP  DS
 *   POP  DX
 *   RET
 *
 * Returns the DOS handle on success, or -1 with CF set on failure.
 * ============================================================================ */
int rtlink_open_exe_for_overlay_read(const char* exe_path, int access_mode)
{
    return int21h_AH_3D(exe_path, access_mode);
}

/* ============================================================================
 * RTLink thunk table — 12,278 bytes at file 0x01A5F0
 *
 * @asm 0x01A5F0..0x01D5E6  (12,278 bytes; 1,020 thunks across 82 segments)
 *
 * NOT a function — this is a DATA STRUCTURE.  Each entry is a 10- or
 * 14-byte stub.  We declare it here as an extern array; its layout is
 * documented in formats/RTLINK.md and the per-thunk catalog is in
 * code/VICEROY/overlay_thunks.md.
 * ============================================================================ */
extern struct rtlink_thunk g_thunk_table[1020];   /* @asm 0x1A5F0 */
