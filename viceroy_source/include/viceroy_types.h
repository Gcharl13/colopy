/* ============================================================================
 * viceroy_types.h — fundamental types for 16-bit DOS C
 * ----------------------------------------------------------------------------
 * The original toolchain (Microsoft C 6.0 / Borland C++ 3.x) didn't have
 * <stdint.h> — so we provide the same typedefs here.
 * ============================================================================ */
#ifndef VICEROY_TYPES_H
#define VICEROY_TYPES_H

#ifdef _VICEROY_MODERN
/* modern host: take the fixed-width types from the system -- the manual
 * typedefs below collide with glibc (int32_t there is int, not long) */
#  include <stdint.h>
#else
typedef unsigned char  uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long  uint32_t;
typedef signed char    int8_t;
typedef signed short   int16_t;
typedef signed long    int32_t;
typedef unsigned long  uintptr_t;
#endif

/* MS C "far" pointer keyword reproduced here for documentation.
 * In a build with the period-correct compiler this is the actual keyword. */
#ifndef far
#  define far  /*far*/
#endif
#ifndef near
#  define near /*near*/
#endif

/* MK_FP — make a far pointer from segment + offset (16:16 real-mode).
 * The Microsoft C runtime provides this as a macro in <dos.h>.
 * Modern build: ported bodies use MK_FP(0, dgroup_off) for DS-relative
 * far derefs; segment 0 therefore maps into g_dgroup[] (a raw absolute
 * address would fault on the host).  A non-zero segment keeps the 16:16
 * linear value: those sites are heap far pointers in not-yet-modernized
 * code and must not silently alias DGROUP. */
#ifndef MK_FP
#  ifdef _VICEROY_MODERN
extern unsigned char g_dgroup[];
#    define MK_FP(seg, off)  ((seg) == 0                                       \
        ? (void far*)(g_dgroup + (uint16_t)(off))                              \
        : (void far*)(uintptr_t)(((uint32_t)(seg) << 16) | (uint16_t)(off)))
#  else
#    define MK_FP(seg, off)  ((void far*)(((uint32_t)(seg) << 16) | (uint16_t)(off)))
#  endif
#endif

/* DGROUP-relative load. In real mode this is just a near pointer with the
 * implicit DS = DGROUP. We make it explicit for documentation.
 * Modern build: DS is the g_dgroup[] array, so the pointer maps into it
 * (raw absolute derefs would read host memory). */
#ifdef _VICEROY_MODERN
extern unsigned char g_dgroup[];
#  define DGROUP_PTR(addr)  ((void near*)(g_dgroup + (uint16_t)(addr)))
#else
#  define DGROUP_PTR(addr)  ((void near*)(uint16_t)(addr))
#endif

#endif /* VICEROY_TYPES_H */
