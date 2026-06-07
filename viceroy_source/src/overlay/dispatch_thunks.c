/* ============================================================================
 * overlay/dispatch_thunks.c — the 12 dispatch wrappers
 * ----------------------------------------------------------------------------
 * Twelve identical-shape wrappers at file offsets 0x28B0..0x2982, each
 * forwarding a fixed opcode plus the caller's argument to the major
 * dispatch function at overlay address 0xD1D:0x07A4.
 *
 * The opcodes are not contiguous (gaps at 0x51, 0x53, 0x54, 0x56, 0x57,
 * 0x59-0x5B, 0x5D, 0x5F, 0x61, 0x63, 0x65, 0x67, 0x69 are NOT exposed
 * as wrappers) — the dispatcher accepts those values but only via direct
 * inline LCALL from elsewhere.
 *
 * @ref decompiled.md "Region: load_image — overlay-op dispatch thunks"
 * ============================================================================ */
#include "viceroy.h"

extern int overlay_call_0D1D_07A4(uint16_t opcode, uint16_t arg);

/* @asm 0x0028B0..0x0028BF  (16 bytes)
 * @manual manual_funcs.json "call_overlay_with_80" */
int dispatch_overlay_op_50(uint16_t arg) { return overlay_call_0D1D_07A4(0x50, arg); }

/* @asm 0x0028E2..0x0028F1  (16 bytes) */
int dispatch_overlay_op_52(uint16_t arg) { return overlay_call_0D1D_07A4(0x52, arg); }

/* @asm 0x0028F2..0x002901  (16 bytes) */
int dispatch_overlay_op_55(uint16_t arg) { return overlay_call_0D1D_07A4(0x55, arg); }

/* @asm 0x002902..0x002911  (16 bytes) */
int dispatch_overlay_op_58(uint16_t arg) { return overlay_call_0D1D_07A4(0x58, arg); }

/* @asm 0x002912..0x002921  (16 bytes) */
int dispatch_overlay_op_5C(uint16_t arg) { return overlay_call_0D1D_07A4(0x5C, arg); }

/* @asm 0x002922..0x002931  (16 bytes) */
int dispatch_overlay_op_5E(uint16_t arg) { return overlay_call_0D1D_07A4(0x5E, arg); }

/* @asm 0x002932..0x002941  (16 bytes) */
int dispatch_overlay_op_60(uint16_t arg) { return overlay_call_0D1D_07A4(0x60, arg); }

/* @asm 0x002942..0x002951  (16 bytes) */
int dispatch_overlay_op_62(uint16_t arg) { return overlay_call_0D1D_07A4(0x62, arg); }

/* @asm 0x002952..0x002961  (16 bytes) */
int dispatch_overlay_op_64(uint16_t arg) { return overlay_call_0D1D_07A4(0x64, arg); }

/* @asm 0x002962..0x002971  (16 bytes) */
int dispatch_overlay_op_66(uint16_t arg) { return overlay_call_0D1D_07A4(0x66, arg); }

/* @asm 0x002972..0x002981  (16 bytes) */
int dispatch_overlay_op_68(uint16_t arg) { return overlay_call_0D1D_07A4(0x68, arg); }

/* @asm 0x002982..0x002991  (16 bytes) */
int dispatch_overlay_op_6A(uint16_t arg) { return overlay_call_0D1D_07A4(0x6A, arg); }

/* ============================================================================
 * repeat_dispatch_op_50 — calls dispatch_overlay_op_50 in a loop
 * @asm 0x0028C0..0x0028E1  (34 bytes)
 * ============================================================================ */
void repeat_dispatch_op_50(uint16_t arg, int count)
{
    /* @asm 0x28C6: CMP DX, 0; JLE 0x28DD  (bound check) */
    if (count <= 0) return;
    /* @asm 0x28CD..0x28DB  loop count times */
    for (int i = 0; i < count; i++) {
        dispatch_overlay_op_50(arg);
    }
}
