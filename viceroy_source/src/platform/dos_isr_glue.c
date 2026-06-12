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
int overlay_call_181F_0E5E(void) { return 0; }

/* 181F:0E68 -- BIOS key read+translate; modern input is the script/SDL
 * queue (vid_poll_key); headless returns "no key". */
int overlay_call_181F_0E68(void)
{
    extern int vid_poll_key(void);
    return vid_poll_key();
}

/* 181F:0EB8 -- input-state reset.  Mirror the byte-visible DGROUP writes so
 * dependent reads stay byte-faithful; the ISR side is platform-owned. */
int overlay_call_181F_0EB8(void)
{
    DG16(0x92F6) = 0; DG16(0x92F4) = 0;          /* @0xC7EB/@0xC7F1 */
    DG8(0x376) = 1; DG8(0x377) = 1; DG8(0x378) = 1; /* @0xC7F7.. */
    DG16(0x92E8) = 0; DG16(0x92EA) = 0;          /* @0xC806/@0xC80C */
    DG16(0x8338) = 0;                            /* @0xC812 */
    return 0;
}

/* mouse cursor show/hide/shape family -- host cursor is platform-owned; the
 * visibility counter byte [0xA899] is kept so EXE-side reads stay coherent. */
int overlay_call_181F_04E8(void)   /* hide (and 0A58:000D alias) */
{
    if (DG16(0x92F8) != 0)
        DG8(0xA899) = (uint8_t)(DG8(0xA899) + 1);  /* @0xC9A5 inc visibility */
    return 0;
}
int overlay_call_0A58_000D(void) { return overlay_call_181F_04E8(); }
int overlay_call_181F_04F2(void)   /* show (and 0A58:0054 alias) */
{
    if (DG16(0x92F8) != 0)
        DG8(0xA899) = (uint8_t)(DG8(0xA899) - 1);  /* @0xC9E5 dec visibility */
    return 0;
}
int overlay_call_0A58_0054(void) { return overlay_call_181F_04F2(); }
int overlay_call_0A58_02CE(void)   /* shape reset @0xCC55/[0x58B],[0x58A] */
{
    if (DG16(0x92F8) != 0) { DG8(0x58B) = 0; DG8(0x58A) = 0xFF; }
    return 0;
}
int overlay_call_0A58_02E0(void) { return 0; }  /* cursor blank/save region */
int overlay_call_0A58_03CE(void)   /* conditional re-show */
{
    if (DG16(0x92F8) != 0 && DG8(0xA899) == 0)
        overlay_call_0A58_02CE();                  /* @0xCD5C lcall 0A58:02CE */
    return 0;
}
int overlay_call_0A58_03E2(void) { return 0; }  /* sprite save/restore (VGA) */
int overlay_call_0A58_06FD(void) { return 0; }  /* blit vector dispatch (VGA) */

/* 0A58:0207 -- the timer ISR body; platform/timer.c owns time. */
int overlay_call_0A58_0207(void) { return 0; }

/* 181F:0EE0 -- MSC stack probe; host stack never underruns: deficit 0. */
int overlay_call_181F_0EE0(void) { return 0; }

/* 191F:04A2 -- keyboard drain; the modern queue is drained by the shell. */
int overlay_call_191F_04A2(void) { return 0; }

#endif /* _VICEROY_MODERN */
