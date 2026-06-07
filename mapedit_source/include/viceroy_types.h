/* ============================================================================
 * viceroy_types.h (MAPEDIT) -- mirrors viceroy_source/include/viceroy_types.h
 * Same fundamental types for 16-bit DOS C.
 * ============================================================================ */
#ifndef MAPEDIT_VICEROY_TYPES_H
#define MAPEDIT_VICEROY_TYPES_H

typedef unsigned char  uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long  uint32_t;
typedef signed char    int8_t;
typedef signed short   int16_t;
typedef signed long    int32_t;

#ifndef far
#  define far  /*far*/
#endif
#ifndef near
#  define near /*near*/
#endif

#ifndef MK_FP
#  define MK_FP(seg, off)  ((void far*)(((uint32_t)(seg) << 16) | (uint16_t)(off)))
#endif

#define DGROUP_PTR(addr)  ((void near*)(uint16_t)(addr))

#endif /* MAPEDIT_VICEROY_TYPES_H */
