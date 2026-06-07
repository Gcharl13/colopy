/* ============================================================================
 * runtime/cstart.c — C runtime startup + atexit + exit
 * ----------------------------------------------------------------------------
 * The "cstart" function is what runs after system_init returns and before
 * main() is called.  It relocates the stack, zeros BSS, runs precompiled-
 * init chains, sets up argc/argv/envp, calls _main, and on return invokes
 * the exit chain.
 *
 * @ref decompiled.md "cstart"
 * @ref manual_funcs.json "cstart" / "exit" / "exit_abort"
 * ============================================================================ */
#include "viceroy.h"
#include "runtime.h"
#include "rtlink.h"
#include "dos.h"

extern void  stack_overflow_print_10812(void);
extern void  panic_exit_10A99(void);
extern void  precompiled_init_atexit_D1D_1420(void);
extern void  precompiled_init_fpu_D1D_128E(void);
extern void  precompiled_init_setargv_D1D_0248(void);
extern int   _main(int argc, char **argv, char **envp);
extern void  exit_chain_F8DD(int status);
extern void  exit_impl(int status, int flags);

/* ============================================================================
 * cstart — 182 bytes
 *
 * @asm 0x00F72D..0x00F7E2  (182 bytes; ends with RETF)
 * @manual manual_funcs.json index "cstart"
 * @verified Boundary verified: ENTER 4 / RETF; size 0xF7E3 - 0xF72D = 182 bytes
 *
 * Phases:
 *   1. Relocate the program stack to its dedicated SS segment
 *   2. On stack-relocate failure: print "stack overflow" and terminate
 *   3. Zero the BSS
 *   4. Call the precompiled-init chain (atexit, FPU init, setargv equivalent)
 *   5. Call _main(argc, argv, envp) via overlay thunk 0x1A5F0
 *   6. On main's return: invoke exit_chain with main's return value
 * ============================================================================ */
void cstart(void)
{
    /* @asm 0xF72D..0xF74A  Relocate stack */
    if (!relocate_stack_to_dedicated_segment()) {
        stack_overflow_print_10812();
        panic_exit_10A99();
    }

    /* @asm 0xF74B..0xF767  Zero BSS */
    zero_bss_segment();

    /* @asm 0xF768..0xF782  Save program DS / setup argv globals */
    g_program_ds = read_ds_segment();

    /* @asm 0xF783..0xF7A0  Precompiled init chain */
    precompiled_init_atexit_D1D_1420();   /* atexit init */
    precompiled_init_fpu_D1D_128E();      /* FPU init */
    precompiled_init_setargv_D1D_0248();  /* _setargv equivalent */

    /* @asm 0xF7A1..0xF7DC  Call _main via overlay thunk 0x1A5F0 */
    /* The PUSH sequence is envp / argv / argc per the C calling convention. */
    int rc = _main(g_argc, (char**)g_argv, (char**)g_envp);

    /* @asm 0xF7DD..0xF7E2  Pass _main's return code to the exit chain */
    exit_chain_F8DD(rc);
}

/* ============================================================================
 * exit + _exit — 7 + 8 bytes (twin entry points to shared impl)
 * @asm 0x00F8DD..0x00F8E3  exit (7 bytes)
 * @asm 0x00F8E4..0x00F8EB  _exit (8 bytes)
 *
 * Two cooperating thunks that share an implementation at 0xF8FE:
 *   exit  → CX = 0 (run atexit + flush stdio + close files + INT 21h AH=4Ch)
 *   _exit → CX = 1 (skip atexit, just terminate)
 *
 * Both tail-jump to the merged implementation.
 * ============================================================================ */
void __cdecl exit(int status)
{
    /* @asm 0xF8DD: XOR CX, CX
     * @asm 0xF8DF: JMP 0xF8FE */
    exit_impl(status, 0);
}

void __cdecl _exit_abort(int status)
{
    /* @asm 0xF8E4: MOV CX, 1
     * @asm 0xF8E7: JMP 0xF8FE */
    exit_impl(status, 1);
}

/* ============================================================================
 * exit_impl — the merged implementation at 0xF8FE
 * @asm 0x00F8FE..(unmapped end)
 *
 * If flags == 0:
 *   1. Run atexit chain in reverse order
 *   2. Flush all stdio FILE buffers
 *   3. Close all open file descriptors
 *   4. INT 21h AH=4Ch with status
 *
 * If flags != 0:
 *   1. INT 21h AH=4Ch with status (immediate terminate)
 * ============================================================================ */
void exit_impl(int status, int flags)
{
    if (flags == 0) {
        run_atexit_chain();
        flush_stdio_buffers();
        close_all_open_files();
    }
    int21h_AH_4C(status);
    /* INT 21h AH=4Ch terminates the program; this point is never reached. */
}

/* ============================================================================
 * putchar / getchar — 8 bytes each
 * @asm 0x00FD20..0x00FD27  putchar
 * @asm 0x00FD4E..0x00FD55  getchar
 *
 * Both are tiny wrappers that load the appropriate FILE struct address
 * into BX and tail-jump to the shared putc/getc fast path.
 * ============================================================================ */
extern int  putc_fast_FD2E(int c, void far *file);
extern int  getc_fast_FD5C(void far *file);

int __cdecl putchar(int c)
{
    return putc_fast_FD2E(c, g_stdout);
}

int __cdecl getchar(void)
{
    return getc_fast_FD5C(g_stdin);
}
