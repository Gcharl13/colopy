/* ============================================================================
 * iolib/format.c — printf-family pipeline (8 functions)
 * ----------------------------------------------------------------------------
 * Eight wrapper functions all converge on `format_to_buffer_2D54` (0x260E):
 *
 *   open_output_stream        @ 0x2400
 *   format_int_to_stream      @ 0x242C
 *   find_char_in_buffer       @ 0x2462
 *   map_int_to_screen_code    @ 0x2494
 *   write_int_via_format      @ 0x2632
 *   format_long_via_8FA       @ 0x2648
 *   format_long_via_916       @ 0x2668
 *   format_via_lib_4B_1E8     @ 0x268C
 *   format_to_buffer_2D54     @ 0x260E  (the hub)
 *
 * Each formats a different argument type into a 20-byte stack buffer and
 * sends it through the hub.  The output stream metadata lives at
 * g_output_stream_2D40 with byte counter g_output_count_2D52.
 *
 * @ref decompiled.md "Region: load_image — formatted-output buffer pipeline"
 * ============================================================================ */
#include "viceroy.h"
#include "format.h"

/* External overlay calls used by the pipeline */
extern void  overlay_call_181F_0048(int mode_flag, void *buf_arg, void *source,
                                     int unused, void *stream_descriptor);
extern void  overlay_call_181F_002C(void);                          /* sprintf-like format */
extern void  overlay_call_0D1D_113C(int value);                     /* long-format helper */
extern void  overlay_call_0D1D_117E(int high, int low);             /* second long helper */
extern void  overlay_call_0D1D_08FA(int value, char *buf, int radix);
extern void  overlay_call_0D1D_0916(int low, int high, char *buf, int radix);
extern void  overlay_call_004B_01E8(int arg1, int arg2, char *buf);

/* ============================================================================
 * format_to_buffer_2D54 — the central hub
 * @asm 0x00260E..0x002630  (35 bytes)
 * @manual manual_funcs.json "format_to_buffer_2D54"
 *
 * Takes a far pointer to a buffer and writes its contents through the
 * dual format-engine into the output stream.
 * ============================================================================ */
extern int  format_engine_a(void far *buf);  /* one of two engines */
extern int  format_engine_b(void far *buf);

void format_to_buffer_2D54(void far *buf)
{
    /* @asm 0x260E..0x2630
     * The function calls TWO format engines in sequence; the dual call
     * pattern is what gives this hub its name. */
    format_engine_a(buf);
    format_engine_b(buf);
}

/* ============================================================================
 * open_output_stream
 * @asm 0x002400..0x002420  (33 bytes)
 * ============================================================================ */
void open_output_stream(uint16_t mode_flag, uint16_t buf_arg, uint16_t source)
{
    /* @asm 0x2403..0x2418  Setup overlay stream open at 0x181F:0x48 */
    overlay_call_181F_0048(9 /* open mode flag */,
                           (void*)0x0042 /* arg slot */,
                           (void*)source,
                           buf_arg,
                           &g_output_stream_2D40);
    g_output_count_2D52 = 0;
}

/* ============================================================================
 * format_int_to_stream
 * @asm 0x00242C..0x002460  (53 bytes)
 * ============================================================================ */
int format_int_to_stream(int value)
{
    /* @asm 0x242C..0x244F  long-format dispatcher; transforms via three LCALLs */
    overlay_call_0D1D_113C(value);
    overlay_call_181F_002C();
    overlay_call_0D1D_117E(0, value);

    /* @asm 0x2457..0x245A  post-increment the output count */
    int prev = g_output_count_2D52;
    g_output_count_2D52++;
    return prev;
}

/* ============================================================================
 * find_char_in_buffer
 * @asm 0x002462..0x002493  (45 bytes)
 *
 * REPNE SCASB scan — searches the buffer at [g_buf_ptr_2D42..2D44] for a
 * NUL byte (or until count reaches 0).  Returns the matching far pointer.
 * ============================================================================ */
void far *find_char_in_buffer(uint16_t count)
{
    /* @asm 0x2462..0x2493  reads g_buf_ptr_2D42_2D44 then REPNE SCASB */
    char far *p = (char far *)g_buf_ptr_2D42_2D44;
    while (count-- > 0) {
        if (*p == 0) return (void far *)p;
        p++;
    }
    return (void far *)p;
}

/* ============================================================================
 * map_int_to_screen_code
 * @asm 0x002494..0x0024C5  (50 bytes)
 *
 * Maps a small integer code (0..3+) to one of four screen-character codes.
 * The constants 0x44/0x95/0x0C/0x22 don't have a clear ASCII interpretation
 * — they're MicroProse internal symbol-codes for screen-grid characters.
 * ============================================================================ */
void map_int_to_screen_code(int code, uint16_t *out_a, uint16_t *out_b)
{
    switch (code) {
    case 0:  *out_a = 0x44; break;
    case 1:  *out_a = 0x95; break;
    case 2:  *out_a = 0x0C; break;
    default: *out_a = 0x22; break;
    }
    *out_b = 0x22;
}

/* ============================================================================
 * write_int_via_format
 * @asm 0x002632..0x002646  (21 bytes)
 *
 * Tiny: PUSH arg / LCALL 0:0x62 (the very-low-segment error helper) /
 * forward result to format_to_buffer_2D54.
 * ============================================================================ */
extern void overlay_call_0000_0062(int arg, int *result_high, int *result_low);

void write_int_via_format(int arg)
{
    int hi, lo;
    overlay_call_0000_0062(arg, &hi, &lo);
    /* @asm 0x263F..0x2645  PUSH DX; PUSH AX; PUSH CS; CALL format_to_buffer_2D54 */
    int packed[2] = { lo, hi };
    format_to_buffer_2D54(packed);
}

/* ============================================================================
 * format_long_via_8FA
 * @asm 0x002648..0x002667  (32 bytes)
 *
 * Formats a long via 0xD1D:0x8FA(value, &buf, radix=10) into a 20-byte
 * stack buffer, then ships through format_to_buffer_2D54.
 * ============================================================================ */
void format_long_via_8FA(int value)
{
    char buf[20];
    overlay_call_0D1D_08FA(value, buf, 10);
    format_to_buffer_2D54(buf);
}

/* ============================================================================
 * format_long_via_916
 * @asm 0x002668..0x00268A  (35 bytes)
 *
 * Long-form variant via 0xD1D:0x916(low, high, &buf, radix=10).
 * ============================================================================ */
void format_long_via_916(int low, int high)
{
    char buf[20];
    overlay_call_0D1D_0916(low, high, buf, 10);
    format_to_buffer_2D54(buf);
}

/* ============================================================================
 * format_via_lib_4B_1E8
 * @asm 0x00268C..0x0026B1  (38 bytes)
 *
 * Goes through the lib helper at 0x4B:0x1E8 which formats two args into
 * a 20-byte buffer.
 * ============================================================================ */
void format_via_lib_4B_1E8(uint16_t arg1, uint16_t arg2)
{
    char buf[20];
    buf[0] = 0;
    overlay_call_004B_01E8(arg1, arg2, buf);
    format_to_buffer_2D54(buf);
}
