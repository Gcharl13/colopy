/* ============================================================================
 * rtlink.h — RTLink/Plus overlay system
 * @ref formats/RTLINK.md
 * ============================================================================ */
#ifndef VICEROY_RTLINK_H
#define VICEROY_RTLINK_H

#include "viceroy_types.h"

/* Type-A thunk format (14 bytes + variable trailer 2/4/6) */
struct rtlink_thunk {
    uint8_t  opcode_pushcs;     /* 0x0E */
    uint8_t  opcode_call_far;   /* 0x9A — LCALL stub */
    uint16_t lcall_offset;      /* offset of runtime entry */
    uint16_t lcall_segment;     /* segment of runtime entry */
    uint8_t  target_seg_id;
    uint16_t target_offset;
    uint8_t  trailer[6];        /* variable, 2/4/6 bytes */
};

/* RTLink runtime entry points */
void __cdecl rtlink_runtime_entry_typeA(void);   /* @asm 0x1427B (24 bytes) */
void __cdecl rtlink_runtime_entry_typeB(void);   /* @asm 0x14261 (26 bytes) */

/* Segment lookup dispatcher */
uint16_t rtlink_segment_lookup_164A2(int seg_id);            /* @asm 0x164A2 */

/* Loads the requested overlay segment into the buffer reserved by system_init */
int      rtlink_load_segment_into_buffer(int seg_id);
int      rtlink_segment_is_resident(int seg_id);
void     rtlink_patch_thunk_ljmp(struct rtlink_thunk *thunk, uint16_t loaded_seg);

/* The EXE-open helper used by the overlay loader */
int      rtlink_open_exe_for_overlay_read(const char *exe_path, int access_mode);

/* The thunk table itself */
extern struct rtlink_thunk g_thunk_table[1020];   /* @asm 0x1A5F0 */

/* Helpers */
struct rtlink_thunk *pop_thunk_address_from_stack(void);
void  far_jump(uint16_t seg, uint16_t off);

#endif /* VICEROY_RTLINK_H */
