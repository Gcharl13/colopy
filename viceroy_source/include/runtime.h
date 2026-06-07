/* ============================================================================
 * runtime.h — C runtime startup / atexit / exit declarations
 * ============================================================================ */
#ifndef VICEROY_RUNTIME_H
#define VICEROY_RUNTIME_H

#include "viceroy_types.h"

void  cstart(void);                                          /* @asm 0xF72D */
void  exit(int status);                                      /* @asm 0xF8DD */
void  _exit_abort(int status);                               /* @asm 0xF8E4 */
void  exit_impl(int status, int flags);                      /* @asm 0xF8FE */

void  system_init(void);                                     /* @asm 0x13BF7 */
void  dos_version_check_stub(void);                          /* @asm 0xF720 */
void  entry_point(void);                                     /* @asm 0x13BED */

/* atexit chain plumbing */
void  run_atexit_chain(void);
void  flush_stdio_buffers(void);
void  close_all_open_files(void);

/* misc helpers in this module */
int   relocate_stack_to_dedicated_segment(void);
void  zero_bss_segment(void);
uint16_t read_ds_segment(void);
void  install_env_var_int21h_hooks(void);
uint16_t read_word_at_psp_offset_2(void);
uint16_t compute_program_break(void);
uint16_t compute_near_heap_size(void);
uint16_t compute_far_heap_size(void);
uint16_t compute_ems_window_size(void);
void  save_initial_segments(void);

/* exit chain glue */
void  exit_chain_F8DD(int status);

#endif /* VICEROY_RUNTIME_H */
