/* ============================================================================
 * format.h — printf-family pipeline declarations
 * ============================================================================ */
#ifndef VICEROY_FORMAT_H
#define VICEROY_FORMAT_H

#include "viceroy_types.h"

void   format_to_buffer_2D54(void far *buf);                    /* @asm 0x260E (35) */
void   open_output_stream(uint16_t mode_flag, uint16_t buf_arg, /* @asm 0x2400 (33) */
                          uint16_t source);
int    format_int_to_stream(int value);                         /* @asm 0x242C (53) */
void far *find_char_in_buffer(uint16_t count);                  /* @asm 0x2462 (45) */
void   map_int_to_screen_code(int code,                         /* @asm 0x2494 (50) */
                              uint16_t *out_a, uint16_t *out_b);
void   write_int_via_format(int arg);                           /* @asm 0x2632 (21) */
void   format_long_via_8FA(int value);                          /* @asm 0x2648 (32) */
void   format_long_via_916(int low, int high);                  /* @asm 0x2668 (35) */
void   format_via_lib_4B_1E8(uint16_t arg1, uint16_t arg2);     /* @asm 0x268C (38) */

#endif /* VICEROY_FORMAT_H */
