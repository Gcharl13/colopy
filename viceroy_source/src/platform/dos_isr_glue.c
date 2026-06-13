/* ============================================================================
 * dos_isr_glue.c -- MODERN-REPLACED terminal states for the DOS ISR / mouse
 * cursor / keyboard platform internals (Phase 4.6 Batch A, 2026-06-12).
 * ----------------------------------------------------------------------------
 * Every entry below is a byte-classified DOS platform leaf whose modern
 * equivalent lives in the platform layer (timer.c synthetic tick,
 * script_input.c input, SDL/host cursor).  Strong definitions here beat the
 * weak hit-counting stubs so the rows reach their terminal state; each
 * carries its byte proof.  Ledger: docs/UNREACHABLE_LEDGER.md §MODERN-REPLACED.
 *
 * All identities read from VICEROY.EXE (capstone over the raw bytes):
 *   0xC2F4  181F:0E5E  `sub ax,ax; retf`                  -> return 0
 *   0xC2F8  181F:0E68  BIOS key read 0xC0C:0x12 + 0x7F mask + translate
 *   0xC7EB  181F:0EB8  input-state reset ([0x92F4/F6]=0, [0x376..378]=1,
 *                       [0x92E8/EA]=0, [0x8338]=0)
 *   0xC98D  181F:04E8 / 0A58:000D  mouse-guarded ([0x92F8]) cursor HIDE:
 *                       ++[0xA899]; on 0->1 edge call 0xCDD6 (restore under)
 *   0xC9D4  181F:04F2 / 0A58:0054  cursor SHOW: --[0xA899]; edge call 0xCDAD
 *   0xCB87  0A58:0207  the INT8/timer ISR body: DS:=0x1B5A, reentrancy latch
 *                       [0x6D2], SS:SP save [0x6CE/0x6D0]
 *   0xCC4E  0A58:02CE  cursor-shape reset ([0x58B]=0, [0x58A]=0xFF)
 *   0xCC60  0A58:02E0  cursor blank (xchg [0xA899],0x80 + region save)
 *   0xCD4E  0A58:03CE  conditional re-show (calls 0A58:02CE when visible)
 *   0xCD62  0A58:03E2  cursor sprite save/restore (ES video segment ops)
 *   0xD07D  0A58:06FD  cursor blit dispatch (jmp word [0x7E0] into VGA segs)
 *   0xD236  181F:0EE0  MSC stack probe: zero-fill [SP..[0x27E6]) and return
 *                       the deficit (host stack: 0)
 *   0xD29C  191F:04A2  keyboard drain loop (while (poll 0xD272) consume 0xD286)
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include "viceroy_types.h"
#include "dgroup.h"

/* 181F:0E5E -- literal `return 0` in the EXE. */
int overlay_call_181F_0E5E() { return 0; }

/* 181F:0E68 -- BIOS key read+translate; modern input is the script/SDL
 * queue (vid_poll_key); headless returns "no key". */
int overlay_call_181F_0E68()
{
    extern int vid_poll_key(void);
    return vid_poll_key();
}

/* 181F:0EB8 -- input-state reset.  Mirror the byte-visible DGROUP writes so
 * dependent reads stay byte-faithful; the ISR side is platform-owned. */
int overlay_call_181F_0EB8()
{
    DG16(0x92F6) = 0; DG16(0x92F4) = 0;          /* @0xC7EB/@0xC7F1 */
    DG8(0x376) = 1; DG8(0x377) = 1; DG8(0x378) = 1; /* @0xC7F7.. */
    DG16(0x92E8) = 0; DG16(0x92EA) = 0;          /* @0xC806/@0xC80C */
    DG16(0x8338) = 0;                            /* @0xC812 */
    return 0;
}

/* mouse cursor show/hide/shape family -- host cursor is platform-owned; the
 * visibility counter byte [0xA899] is kept so EXE-side reads stay coherent. */
int overlay_call_181F_04E8()   /* hide (and 0A58:000D alias) */
{
    if (DG16(0x92F8) != 0)
        DG8(0xA899) = (uint8_t)(DG8(0xA899) + 1);  /* @0xC9A5 inc visibility */
    return 0;
}
int overlay_call_0A58_000D() { return overlay_call_181F_04E8(); }
int overlay_call_181F_04F2()   /* show (and 0A58:0054 alias) */
{
    if (DG16(0x92F8) != 0)
        DG8(0xA899) = (uint8_t)(DG8(0xA899) - 1);  /* @0xC9E5 dec visibility */
    return 0;
}
int overlay_call_0A58_0054() { return overlay_call_181F_04F2(); }
int overlay_call_0A58_02CE()   /* shape reset @0xCC55/[0x58B],[0x58A] */
{
    if (DG16(0x92F8) != 0) { DG8(0x58B) = 0; DG8(0x58A) = 0xFF; }
    return 0;
}
int overlay_call_0A58_02E0() { return 0; }  /* cursor blank/save region */
int overlay_call_0A58_03CE()   /* conditional re-show */
{
    if (DG16(0x92F8) != 0 && DG8(0xA899) == 0)
        overlay_call_0A58_02CE();                  /* @0xCD5C lcall 0A58:02CE */
    return 0;
}
int overlay_call_0A58_03E2() { return 0; }  /* sprite save/restore (VGA) */
int overlay_call_0A58_06FD() { return 0; }  /* blit vector dispatch (VGA) */

/* 0A58:0207 -- the timer ISR body; platform/timer.c owns time. */
int overlay_call_0A58_0207() { return 0; }

/* 181F:0EE0 -- MSC stack probe; host stack never underruns: deficit 0. */
int overlay_call_181F_0EE0() { return 0; }

/* 191F:04A2 -- keyboard drain; the modern queue is drained by the shell. */
int overlay_call_191F_04A2() { return 0; }

/* Batch C additions (2026-06-12): more resident platform leaves.
 *   0xC861  181F:05CE / 0A29:01D1  INT-vector restore epilogue: when armed
 *           ([0x379]!=0) re-points INT8 via AH=0x25 INT 21h to the saved
 *           cs-stored vector, re-arms the tick divisor words
 *           ([0x267C]=0x40, [0x...]=0x6C) -- the timer teardown twin of the
 *           0xCB87 ISR body.  Modern: platform/timer.c owns time.
 *   0xC31C  09EF:002C  forwarder `push cs; call 0xC2F8; retf` = the BIOS
 *           key read+translate (181F:0E68's body).  -> vid_poll_key(). */
int overlay_call_181F_05CE() { return 0; }
int overlay_call_0A29_01D1() { return 0; }
int overlay_call_09EF_002C()
{
    extern int overlay_call_181F_0E68();
    return overlay_call_181F_0E68();
}

/* ----------------------------------------------------------------------------
 * func_00CCEB -- DOS int-0x33 mouse-coordinate transform (Phase 4 floor,
 * BYTE_VERIFIED 2026-06-13 @asm 0x00CCEB..0x00CD0A).
 *
 *   0xCCEB push ax; mov ax,cx; mov cx,[0x598]   ; cx = packed shift pair
 *   0xCCF2 shr ax,cl                              ; cell_x = mouse_x >> xshift
 *   0xCCF4 xchg cl,ch; shr dx,cl                  ; cell_y = mouse_y >> yshift
 *   0xCCF8 mov cx,ax
 *   0xCCFA cmp [0x92F8],0; jne 0xCD09             ; if NOT frozen:
 *   0xCD01   mov [0x92FC],cx; mov [0x92FE],dx     ;   cache cell (x,y)
 *   0xCD09 pop ax; ret
 *
 * The transform's inputs are the int-0x33 driver's CX/DX register outputs
 * (live mouse pixel position). The modern build has no int 0x33: SDL/host owns
 * the pointer, and the sole caller (the mouse-read leaf in
 * load_image_00C0D0_00D27F.c) already reports the cached coordinate pair via
 * DGROUP 0x92FC/0x92FE and the platform read otherwise. So the register-side
 * shift is a no-op here -- MODERN-REPLACED, like the cursor HIDE/SHOW leaves
 * above. Strong def beats the weak stub; ledger §MODERN-REPLACED. */
int func_00CCEB(void) { return 0; }

#endif /* _VICEROY_MODERN */

