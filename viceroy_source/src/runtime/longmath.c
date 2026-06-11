/* longmath.c -- the MSC 6.0 32-bit arithmetic intrinsics (C runtime leaves).
 *
 * VICEROY.EXE links the Microsoft C runtime's long-math helpers; game code
 * reaches them as far calls into segment 0x0D1D:
 *
 *   0x0D1D:0x0F60  __aFlmul  (file 0x10530)  DX:AX = a * b   (4 stack words)
 *   0x0D1D:0x0EC6  __aFldiv  (file 0x10496)  DX:AX = a / b   (signed)
 *
 * The ports declare these under three names (call-site typed):
 *   ov_long_mul_F60(long a, int b_hi, int b_lo)   colony/production_support.c
 *   ov_long_div_EC6(long product, long divisor)   colony/production_support.c
 *   ldiv32(long n, long d)                        native/haggle.c
 *
 * Until 2026-06-11 all three resolved to generated weak no-op stubs
 * returning 0 (12-16K hits per 500-turn soak) — every colony-percentage
 * and haggle-total computed through them was silently zero.  These are
 * exact intrinsics, not game logic: the C `*` and `/` operators ARE the
 * byte-faithful implementation on int32 (MSC __aFldiv truncates toward
 * zero, same as C99).  Division by zero raised INT 0 on DOS; the modern
 * build returns 0 with the quirk noted (no game path divides by zero on
 * sane data; the guard only prevents a host SIGFPE on corrupt input).
 */
#include "viceroy_types.h"

long msc_aFlmul(long a, int b_hi, int b_lo)
{
    long b = ((long)b_hi << 16) | (uint16_t)b_lo;
    return (long)((int32_t)a * (int32_t)b);
}

long msc_aFldiv(long product, long divisor)
{
    if (divisor == 0)
        return 0;                 /* DOS: INT 0; see header note */
    return (long)((int32_t)product / (int32_t)divisor);
}

/* The three public call-site names (ov_long_mul_F60 / ov_long_div_EC6 /
 * ldiv32) are PROVIDE-aliased to these impls in tools/linkfloor_extra.ld:
 * a same-name strong definition cannot displace the generated weak stub
 * (the linker never pulls the archive member), but the alias mechanism
 * both forces extraction and suppresses the stub via linkgap's wired map. */
