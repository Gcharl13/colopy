/* ============================================================================
 * boot/entry.c — MZ entry-point + system_init + dos_version_check_stub
 * ----------------------------------------------------------------------------
 * The first three things DOS executes when the user types VICEROY:
 *   1. entry_point         (10 bytes at file 0x13BED)
 *   2. system_init         (1368 bytes at file 0x13BF7)
 *   3. dos_version_check_stub  (13 bytes at file 0x0F720)
 *   4. cstart                  (182 bytes at file 0x0F72D)  → see runtime/cstart.c
 *
 * The MZ header points to entry_point via cs:ip = 110D:071D.
 *
 * @ref decompiled.md "Region: boot / system_init pipeline"
 * @ref code/VICEROY/manual_funcs.json (entries: entry_point, system_init, …)
 * ============================================================================ */
#include "viceroy.h"
#include "runtime.h"
#include "rtlink.h"
#include "dos.h"

extern void  cstart(void);             /* runtime/cstart.c */
extern void  panic_exit(const char* msg);

/* External setup helpers used during system_init (still in this module).
 * @asm 0x18153  XMS detection helper (returns AX = XMS available flag)
 * @asm 0x18717..0x18835 cluster: heap-setup helpers (each ~0x80 bytes)
 * @asm 0x16C61  panic-no-memory display helper
 * @asm 0x1726B  clear-region helper (memset-like for far buffer) */
extern int   xms_detect_18153(void);
extern void  heap_setup_18717(void);
extern void  heap_setup_18776(void);
extern void  heap_setup_181B3(void);
extern void  heap_setup_182BC(void);
extern void  heap_setup_18835(void);
extern void  heap_setup_184B5(void);
extern void  panic_no_memory_16C61(void);
extern void  clear_region_1726B(void far *p, uint32_t n);

/* ============================================================================
 * entry_point — 10 bytes; very first instructions DOS executes
 *
 * @asm 0x013BED..0x013BF6  (10 bytes)
 * @manual manual_funcs.json index "entry_point"
 * @verified byte-equal: encoded as LCALL 110D:0727 + LJMP 0D1D:0150
 *
 * The MZ header's e_cs:e_ip points at this stub, located at file offset
 * 0x13BED (= header(0x2400) + 0x110D*16 + 0x071D).  Two instructions:
 *   1. far-call system_init at 110D:0727   (= file 0x13BF7)
 *   2. far-jump dos_version_check_stub at 0D1D:0150   (= file 0xF720)
 * ============================================================================ */
void __cdecl entry_point(void)
{
    /* DS, ES point at the PSP per the DOS loader convention.
     * AX, BX, CX, DX, SI, DI, BP, SP, SS are all in their DOS-default state. */
    system_init();                 /* LCALL 110D:0727 */
    dos_version_check_stub();      /* LJMP  0D1D:0150 (tail-jump; never returns) */
}

/* ============================================================================
 * dos_version_check_stub — pre-stack-relocation stub
 *
 * @asm 0x00F720..0x00F72C  (13 bytes)
 * @manual manual_funcs.json index "dos_version_check_stub"
 * @verified byte-equal: 13 bytes from 0xF720 to 0xF72C inclusive of RETF
 *
 * Reached as the LJMP-target of the entry-point stub.  Calls DOS Get-Version
 * (INT 21h, AH=30h); if the major version is below 2, falls through to a
 * 'PUSH ES; PUSH AX; RETF' that returns to PSP:0 (DOS terminates the
 * program).  On DOS 2.0+ jumps forward to cstart to set up the C runtime.
 * ============================================================================ */
void __cdecl dos_version_check_stub(void)
{
    uint16_t ver = int21h_AH_30();      /* AL = major, AH = minor */
    if ((ver & 0xFF) < 2) {
        /* Push ES (PSP), push AX, RETF → returns to PSP:0 which is the
         * "INT 20h" DOS-terminate instruction. */
        terminate_via_psp_int20();
    }
    cstart();                            /* tail-jump to C runtime startup */
}

/* ============================================================================
 * system_init — 1368 bytes; boot-time DOS/EMS/XMS/heap initialization
 *
 * @asm 0x013BF7..0x01414E  (1368 bytes)
 * @manual manual_funcs.json index "system_init"
 * @ref decompiled.md "system_init"
 * @verified Boundary verified: RETF at 0x1414E; size 0x1414F - 0x13BF7 = 1368 bytes
 *
 * Saves the initial DS/ES/SS, runs DOS Get-Version, probes for an EMS driver
 * and allocates a 1-page handle if present, probes for XMS and allocates an
 * XMS block if present, queries the conventional-memory ceiling from the
 * PSP, computes the runtime memory layout (program break, near-heap,
 * far-heap, EMS window, XMS handle), shrinks the program memory block via
 * INT 21h AH=4Ah, allocates the near-heap base via INT 21h AH=48h, hooks
 * INT 21h handlers for environment-variable lookup, and stores all of
 * this into the layout globals at DGROUP:0x3995..0x39FF.
 *
 * Returns far via PUSH ES; PUSH DS; ... ; POP DS; POP ES; RETF.
 *
 * NOTE: only Region 1 of 4 has been line-by-line annotated.  Regions 2-4
 * (~350 lines remaining) are still PARTIAL.
 * ============================================================================ */
void far __cdecl system_init(void)
{
    /* ---- Phase 1: Save loader state ----
     * @asm 0x13BF7..0x13C03  PUSH ES; PUSH DS; … */
    save_initial_segments();    /* DGROUP:0x39B7 etc. */

    /* ---- Phase 2: DOS Get-Version (INT 21h AH=30h) ----
     * @asm 0x13C04..0x13C0B */
    uint16_t dos_ver = int21h_AH_30();
    g_overlay_layout[/* DOS version slot */ 0] = dos_ver;
    if ((dos_ver & 0xFF) < 2) {
        panic_exit("DOS 2.0+ required");
    }

    /* ---- Phase 3: EMS detection (INT 67h AH=42h) ----
     * @asm 0x13C0C..0x13C42 */
    int ems_present = ems_probe_int67_42();    /* AH=42h "Get Number of Pages" */
    int ems_handle = -1;
    if (ems_present) {
        ems_handle = ems_alloc_pages_int67_43(1);  /* 1 page = 16 KB */
        if (ems_handle < 0) ems_present = 0;
    }

    /* ---- Phase 4: XMS detection ----
     * @asm 0x13C43..0x13CA8  CALL 0x18153 */
    int xms_present = xms_detect_18153();
    int xms_handle = -1;
    if (xms_present) {
        xms_handle = xms_alloc_64k();
    }

    /* ---- Phase 5..7: Conventional memory ceiling, layout compute, shrink block ----
     * @asm 0x13CA9..0x13E10  uses INT 21h AH=4Ah Resize Memory Block */
    uint16_t psp_ceiling     = read_word_at_psp_offset_2();
    uint16_t program_break   = compute_program_break();
    uint16_t near_heap_size  = compute_near_heap_size();
    uint16_t far_heap_size   = compute_far_heap_size();
    uint16_t ems_window_size = compute_ems_window_size();

    int21h_AH_4A_resize(program_break + near_heap_size + far_heap_size + ems_window_size);

    /* ---- Phase 8: Allocate near-heap base ----
     * @asm 0x13E11..0x13E60 */
    uint16_t near_heap_seg = int21h_AH_48_alloc(near_heap_size);
    if ((int16_t)near_heap_seg < 0) {
        panic_no_memory_16C61();    /* prints "out of memory", exits */
    }

    /* ---- Phase 9: Hook INT 21h handlers for env-var lookup ----
     * @asm 0x13E61..0x13F60  uses INT 21h AH=35h get-vector + AH=25h set-vector */
    install_env_var_int21h_hooks();

    /* ---- Phase 10: Initialize layout globals at DGROUP:0x3995..0x39FF ----
     * @asm 0x13F61..0x14140 */
    g_overlay_layout[0x00] = near_heap_seg;
    g_overlay_layout[0x01] = near_heap_size;
    g_overlay_layout[0x02] = far_heap_size;
    /* TODO: ~20 more layout globals — exact mapping pending Phase-2 line-by-line. */

    /* @asm 0x14141..0x1414E  POP DS; POP ES; RETF */
}

/* ----------------------------------------------------------------------------
 * Stubs for helpers that the period-correct toolchain provides but we
 * declare locally for documentation.
 * ---------------------------------------------------------------------------- */

/* @asm 0xF8DD..0xF8E3  (7 bytes)  exit() — XOR CX,CX + JMP exit_impl
 * @ref FUNCTIONS_INVENTORY.md "exit" */
void __cdecl exit(int status)
{
    exit_impl(status, 0 /*flags=0: run atexit + flush stdio*/);
}

/* @asm 0xF8E4..0xF8EB  (8 bytes)  _exit() — MOV CX,1 + JMP exit_impl
 * @ref FUNCTIONS_INVENTORY.md "exit_abort" */
void __cdecl _exit(int status)
{
    exit_impl(status, 1 /*flags=1: skip atexit + stdio flush*/);
}
