/* ============================================================================
 *              >>> PLATFORM TICK SOURCE (BIOS 0040:006C model) <<<
 * ----------------------------------------------------------------------------
 * The original reads the 18.2 Hz BIOS tick-count dword through two far entries
 * in the runtime segment 0x0C0C:
 *
 *   0x0C0C:0x0006 -> func_00E4C6 @asm 0x00E4C6: les bx,[0x267A]; ax=es:[bx];
 *                    dx=es:[bx+2]  — read via the redirectable far pointer at
 *                    DGROUP:0x267A, whose init-image value IS 0040:006C (bytes
 *                    6C 00 40 00 at file 0x1D9A0+0x267A).
 *   0x0C0C:0x0012 -> @asm 0x00E4D2: mov bx,0x40; mov es,bx; mov bx,0x6C;
 *                    ax=es:[bx]; dx=es:[bx+2]  — the same dword, direct.
 *
 * Consumers on the AI path:
 *   - 0x181F:0x04CA -> @asm 0x0C31C/0x0C2F8: srand(ticks & 0x7FFF) — the
 *     per-epoch RNG re-seed in the func_052F7E dispatch epoch.
 *   - func_00D1CA pacing wait: spin until the tick differs from the snapshot
 *     latched at DGROUP:0x7FC/0x7FE by func_00D106.
 *
 * MODERN MODEL.  The tick must (a) advance so pacing waits terminate, and
 * (b) be deterministic so the soak/determinism rig (ROUTE_B_PLAN 0.1) keeps
 * byte-identical replays: a synthetic counter advancing one tick per read.
 * Under DOSBox fixed-cycle replays the real counter advances near-uniformly
 * per poll, so the synthetic model preserves the original's *sequence* shape
 * (every read sees a fresh value; each epoch re-seeds with a new word).
 * Wall-clock 18.2 Hz binding for interactive SDL play rides the Phase-3
 * screen work (vid layer owns real pacing there).
 * ============================================================================ */
#include "viceroy_types.h"

static uint32_t g_synth_ticks;     /* modern model of BIOS 0040:006C */

uint32_t viceroy_bios_ticks(void)
{
    return ++g_synth_ticks;
}

/* 0x181F:0x04CA — re-seed the MSC LCG from the BIOS tick.
 * @asm 0x0C31C: push cs; call 0xC2F8; retf
 * @asm 0x0C2F8: lcall 0x0C0C:0x12 (ticks -> AX:DX); and ah,0x7F;
 *               push ax; lcall 0x0D1D:0xDF2 (srand); add sp,2; retf
 * Strong definition overrides the generated weak stub. */
extern void msc_srand(unsigned v);   /* runtime/rng.c, @asm 0x0103C2 */

long overlay_call_181F_04CA(void)
{
    msc_srand((unsigned)(viceroy_bios_ticks() & 0x7FFF));
    return 0;
}
