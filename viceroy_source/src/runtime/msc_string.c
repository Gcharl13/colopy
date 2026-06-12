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
