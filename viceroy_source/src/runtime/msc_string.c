/* ============================================================================
 * runtime/msc_string.c -- MSC RTL string primitives (0x0D1D thunk family)
 * ----------------------------------------------------------------------------
 * BYTE_VERIFIED ports of the small Microsoft C runtime string routines the
 * overlay code reaches through the 0x0D1D RTLink window.  The DOS bodies
 * operate on DS-relative near offsets or seg:off far pointers; the modern
 * build models both as host pointers (call sites pass &DG8(off) for DGROUP
 * strings, or local buffers directly).
 *
 *   0x0D1D:0x07E4  file 0x0FDB4 (50 B)  near strcpy(dest_off, src_off)
 *       @asm 0x00FDBB si=[bp+8](src); repne scasb -> len incl. NUL;
 *       di=[bp+6](dest); aligned movsb/movsw/movsb copy.  Both args are
 *       DS-relative offsets; ES=DS throughout.
 *   0x0D1D:0x113C  file 0x1070C (23 B)  far strlen(ptr)
 *       @asm 0x010711 les di,[bp+6]; repne scasb; ax = ~cx - 1.
 *   0x0D1D:0x117E  file 0x1074E (54 B)  far strcpy(dest, src)
 *       @asm 0x010756 lds si,[bp+0xA](src); scasb -> len incl. NUL;
 *       les di,[bp+6](dest); aligned copy.
 *
 * Call sites keep their hit-counting weak thunk stubs until each one is
 * byte-reviewed and converted to call these hosts with its REAL arguments
 * (the 0x0D1D thunk externs are void-arg; blind PROVIDE aliasing would feed
 * the bodies garbage).
 * ============================================================================ */
#include "viceroy_types.h"
#include "dgroup.h"

/* 0x0D1D:0x07E4 -- near strcpy over the data segment.  The DOS body copies
 * length-counted (strlen+1) bytes with the aligned movsw idiom; the result
 * is exactly strcpy semantics. */
void msc_strcpy_near(uint16_t dest_off, uint16_t src_off)
{
    char *d = (char *)(DG_BASE + dest_off);
    const char *s = (const char *)(DG_BASE + src_off);
    while ((*d++ = *s++) != 0) { }
}

/* host-pointer spelling for call sites whose buffers are C locals
 * (the original passed ss:&buf far pointers there) */
void msc_strcpy(char *dest, const char *src)
{
    while ((*dest++ = *src++) != 0) { }
}

/* 0x0D1D:0x113C -- far strlen. */
unsigned msc_strlen(const char *p)
{
    unsigned n = 0;
    if (!p) return 0;                 /* headless: NULL string-table pointers */
    while (p[n]) n++;
    return n;
}

/* 0x0D1D:0x117E -- far strcpy (dest [bp+6], src [bp+0xA]). */
void msc_far_strcpy(char *dest, const char *src)
{
    if (!dest) return;
    if (!src) { *dest = 0; return; }  /* headless: copy of an absent string */
    while ((*dest++ = *src++) != 0) { }
}

/* 0x0D1D:0x0842  file 0x0FE12 (27 B)  near strlen(off)
 *   @asm 0x00FE1B di=[bp+6]; es=ds; repne scasb; ax = ~cx - 1. */
unsigned msc_strlen_near(uint16_t off)
{
    const char *p = (const char *)(DG_BASE + off);
    unsigned n = 0;
    while (p[n]) n++;
    return n;
}

/* 0x0D1D:0x0C56  file 0x10226 (42 B)  near strchr(str_off, ch)
 *   @asm 0x01022A scan to NUL for the bound, then repne scasb for ch;
 *   dec di; cmp [di],al -> returns the matching offset, or 0 when the
 *   character is absent (the NUL terminator itself matches a ch of 0). */
uint16_t msc_strchr_near(uint16_t str_off, uint16_t ch)
{
    const char *base = (const char *)DG_BASE;
    uint16_t i = str_off;
    for (;;) {
        if ((uint8_t)base[i] == (uint8_t)ch)
            return i;
        if (base[i] == 0)
            return 0;
        i++;
    }
}

/* 0x0D1D:0x0C80  file 0x10250 (66 B)  stricmp(a_off, b_off)
 *   @asm 0x010261 lodsb walks arg1 ([bp+8]); mov ah,[bx] walks arg0
 *   ([bp+6]); raw-equal fast path loops; otherwise both fold through the
 *   sub-0x41/sbb/and-0x20 tolower idiom and the tail @0x010285
 *   cmp al,ah / sbb al,al / sbb al,0xFF / cwde returns EXACTLY
 *   -1 / 0 / +1 with sign = fold(arg1 char) - fold(arg0 char). */
static int msc_tolower_(int c)
{
    return (c >= 'A' && c <= 'Z') ? c + 0x20 : c;
}
int msc_stricmp_near(uint16_t a_off, uint16_t b_off)
{
    const char *p0 = (const char *)(DG_BASE + a_off);   /* @asm bx  */
    const char *p1 = (const char *)(DG_BASE + b_off);   /* @asm si  */
    for (;;) {
        int c0 = (uint8_t)*p0++;
        int c1 = (uint8_t)*p1++;
        if (c0 == c1) {                  /* raw match (incl. both NUL) */
            if (c0 == 0) return 0;
            continue;
        }
        c0 = msc_tolower_(c0);
        c1 = msc_tolower_(c1);
        if (c0 == c1) continue;          /* @asm je 0x1025D after folding */
        return (c1 < c0) ? -1 : 1;       /* sign(fold(arg1)-fold(arg0)) */
    }
}
