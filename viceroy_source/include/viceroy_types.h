/* ============================================================================
 * viceroy_types.h — fundamental types for 16-bit DOS C
 * ----------------------------------------------------------------------------
 * The original toolchain (Microsoft C 6.0 / Borland C++ 3.x) didn't have
 * <stdint.h> — so we provide the same typedefs here.
 * ============================================================================ */
#ifndef VICEROY_TYPES_H
#define VICEROY_TYPES_H

typedef unsigned char  uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long  uint32_t;
typedef signed char    int8_t;
typedef signed short   int16_t;
typedef signed long    int32_t;
typedef unsigned long  uintptr_t;

/* MS C "far" pointer keyword reproduced here for documentation.
 * In a build with the period-correct compiler this is the actual keyword. */
#ifndef far
#  define far  /*far*/
#endif
#ifndef near
#  define near /*near*/
#endif

/* MK_FP — make a far pointer from segment + offset (16:16 real-mode).
 * The Microsoft C runtime provides this as a macro in <dos.h>. */
#ifndef MK_FP
#  define MK_FP(seg, off)  ((void far*)(((uint32_t)(seg) << 16) | (uint16_t)(off)))
#endif

/* DGROUP-relative load. In real mode this is just a near pointer with the
 * implicit DS = DGROUP. We make it explicit for documentation. */
#define DGROUP_PTR(addr)  ((void near*)(uint16_t)(addr))

#endif /* VICEROY_TYPES_H */
