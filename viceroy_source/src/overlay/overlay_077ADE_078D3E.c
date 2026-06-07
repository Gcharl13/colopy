/* ============================================================================
 * overlay_077ADE_078D3E.c -- overlay functions in file range 0x077ADE..0x078D3E
 *
 * Region: the LAST overlay page region of VICEROY.EXE.  It contains THREE
 * distinct subsystems, hand-ported from the RE-SEGMENTED overlay disassembly
 * (AUTHORITATIVE for extents / control flow; the per-func disasm/func_*.asm
 * dumps the stale auto-banners cite truncate the large routines):
 *   code/VICEROY/disasm_overlay_reseg/page_1D.asm (code_base 0x77990) — tail
 *   code/VICEROY/disasm_overlay_reseg/page_1E.asm (code_base 0x77ED0)
 *   code/VICEROY/disasm_overlay_reseg/page_1F.asm (code_base 0x78640)
 * Raw-byte prologues spot-checked against raw/COLONIZE/VICEROY.EXE.
 *
 * The three subsystems:
 *   (A) DIAGNOSTICS / FATAL-ERROR REPORT + DEBUG LOG  (page-1D tail + early 1E):
 *       composes the "Error \"...\" in module \"...\"" panic dump (string IDs
 *       0x24CF.., DGROUP-base 0x1D9A0) and the VICEROY.LOG line logger.  These
 *       decide WHAT TEXT is emitted, so they are IN SCOPE and ported here.
 *   (B) VGA PALETTE / COLOUR-CYCLE engine  (most of page 1E):
 *       PIT-timed (out 0x43/in 0x40) DAC writes (out 0x3C8/0x3C9), vsync polls
 *       (in 0x3DA), 768-byte (=0x300) palette fades, and the CYCLE.DAT loader.
 *       Pure colour/pixel/timer hardware -> OUT-OF-SCOPE.
 *   (C) DOS NEAR-HEAP / memory-block manager  (page 1F):
 *       int 21h AH=48/49/4A allocate/free/resize over block descriptors
 *       (es:bx fields +0..+0x10), driven by page-0x12 (=seg 0x1A1F) heap
 *       primitives 0x1A1F:0x0Fxx.  Pure DOS memory mover -> OUT-OF-SCOPE.
 *
 * PORT STATUS (per 2026-05-30 directive; see per-function banners):
 *   DONE            full @asm-cited body written here (control flow byte-traced).
 *   SUPERSEDED      already ported to a named src/<subsystem>/ file.
 *   TRAMPOLINE      RTLink ljmp-far forwarder; one-line stub citing seg:off.
 *   PHANTOM         reloc/page-boundary bytes mis-framed as a function.
 *   OUT-OF-SCOPE    DOS-platform leaf (VGA DAC / PIT / int-21h heap / file I/O).
 *
 * Bases (DGROUP, file base 0x1D9A0): the diagnostics strings live at DGROUP
 * 0x24CF.. ("Error \"", "\" in module \"", "Tried to allocate ", ...), the
 * VICEROY.LOG format at 0x25DF, "CYCLE.DAT" at 0x25F9.  random_int etc. are
 * not used in this region.
 *
 * STRICT cite-or-TBD: every value/offset cites the .asm; opaque overlay
 * targets (0x181F / 0x1A1F / 0x0D1D / 0x0C0C / 0x191F) are called through their
 * canonical overlay_call_* externs and never given a fabricated body.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ----------------------------------------------------------------------------
 * Local overlay-thunk / near-target declarations.
 * The 0x181F:* / 0x0D1D:* / 0x191F:* helpers used by the IN-SCOPE routines below
 * (strcpy/strcat/ltoa/wtoa/fopen/fprintf/fclose/exit and the value formatters)
 * are already declared in overlay_externs.h.  Only the two page-0x12 (=seg
 * 0x1A1F) report-line sinks are NOT in that header, so they are declared here
 * with the file's canonical no-arg prototype; both resolve via
 * tools/rtlink/rtlink_decode.py (page 0x12, file 0x60D7A / 0x60D86) and their
 * role is inferred from call context (the panic-report text sink).
 * -------------------------------------------------------------------------- */
extern int overlay_call_1A1F_0F1A(void);   /* 0x1A1F:0x0F1A — page-0x12 report dump-to-file (open) */
extern int overlay_call_1A1F_0F26(void);   /* 0x1A1F:0x0F26 — page-0x12 report-line sink (emit) */

/* DGROUP diagnostics globals (absolute offsets from the disassembly; file base
 * 0x1D9A0).  These are the error-reporter's scratch + last-state cells; their
 * exact field semantics beyond "diagnostic scratch" are TBD and not guessed. */
extern uint16_t g_dbg_modptr_2470;   /* DGROUP:0x2470/0x246E — module-cleanup callback ptr */
extern uint16_t g_dbg_errptr_2474;   /* DGROUP:0x2474/0x2472 — error-cleanup callback ptr */
extern uint16_t g_dbg_memchk_27AC;   /* DGROUP:0x27AC — "most recent memory check" value */
extern uint8_t  g_dbg_logopen_25F0;  /* DGROUP:0x25F0 — VICEROY.LOG-opened flag */
extern int16_t  g_dbg_threshold_2476;/* DGROUP:0x2476 — report verbosity threshold (word) */

/* Near-CS targets in the page-1D tail (resolved off this region's CS).  The two
 * report sinks are RTLink ljmp trampolines at file 0x077DF6 / 0x077DFB; the
 * formatter helpers func_077990 / func_077A34 live in the adjacent file
 * overlay_0745F0_077A6A.c (file 0x77990 / 0x77A34, just below this range). */
extern int func_077990(void);              /* @asm 0x077990 — 3-arg field formatter (adjacent file) */

/* ============================================================================
 * (A) DIAGNOSTICS / FATAL-ERROR REPORT + DEBUG LOG  — IN SCOPE (text content)
 * ============================================================================ */

/* ----------------------------------------------------------------------------
 * func_077ADE — error_screen_teardown  [DONE — control flow BYTE_VERIFIED]
 * @asm 0x077ADE..0x077B0F  (49 bytes)  page_1D.asm
 *
 * The abort/error-exit dispatcher: queries a "should we do the cleanup dialog?"
 * predicate, optionally tears down the active subsystem, then forces the screen
 * back to 80x25 colour text mode (BIOS int 0x10, AX=0x0003) so the panic text
 * is legible.  Inline mode-set is a platform op but the routine as a whole is
 * the error-exit SEQUENCER (decides what shuts down), so it is ported here.
 *
 * @asm 0x077AE1  lcall 0x181F:0x05E2          ; predicate (nonzero => run cleanup)
 * @asm 0x077AE8  je    0x077AF8               ; skip cleanup if zero
 * @asm 0x077AEC  push 0; lcall 0x181F:0x04DE  ; cleanup(0)
 * @asm 0x077AF3  lcall 0x181F:0x05D8          ; cleanup tail
 * @asm 0x077AF8  lcall 0x181F:0x05CE          ; always-run teardown
 * @asm 0x077AFF  push 3; push 0; lcall 0x181F:0x05C4
 * @asm 0x077B08  mov ax,3; int 0x10           ; BIOS set video mode 3 (80x25 text)
 * @asm 0x077B0D  leave; retf                  ; bytes: 55 8b ec .. b8 03 00 cd 10 c9 cb
 * -------------------------------------------------------------------------- */
void func_077ADE_error_screen_teardown(void)
{
    if (overlay_call_181F_05E2() != 0) {     /* @asm 0x077AE1 / 0x077AE8 */
        overlay_call_181F_04DE();            /* @asm 0x077AEC  cleanup(0) */
        overlay_call_181F_05D8();            /* @asm 0x077AF3 */
    }
    overlay_call_181F_05CE();                /* @asm 0x077AF8  always */
    overlay_call_181F_05C4();                /* @asm 0x077AFF  push 3, push 0 */

    /* @asm 0x077B08  mov ax,3 ; int 0x10  — BIOS set 80x25 16-colour text mode.
     * Pure platform op (kept inline; no portable side effect to model here). */
    /* set_video_mode(3); */
}

/* ----------------------------------------------------------------------------
 * func_077B10 — fatal_error_report  [DONE — control flow BYTE_VERIFIED]
 * @asm 0x077B10..0x077D5D  (590 bytes)  page_1D.asm
 *   (the stale auto-banner's "31 bytes" is wrong — the per-func dump truncated
 *    at the first RET; the reseg page gives the true 590-byte extent.)
 *
 * Composes the game's fatal-error panic report into a stack text buffer
 * [bp-0x50] and emits it line-by-line through the page-0x12 report sink
 * (0x1A1F:0x0F26).  Layout, byte-traced:
 *
 *   args:  arg0(si)=ax  arg1(di)=dx  [bp-0x52]=bx (saved third value)
 *          [bp+6],[bp+8]=a coordinate/code pair   [bp+0xA]=a count/value
 *   @asm 0x077B20  push cs; call 0x077DF6 (ljmp 0x181F:0x03D4) — begin report
 *   @asm 0x077B24  cmp word [bp+4], -0x14   ; bytes 83 7e 04 ec
 *   @asm 0x077B28  jne  0x077B2D            ; if return-addr-tag == -20 -> short path
 *   @asm 0x077B2A  jmp  0x077D2C            ; (short path: just pick "*warn6.dat")
 *
 *   long path builds, via strcpy/strcat helpers 0x0D1D:0x07E4 / 0x07A4 and the
 *   value formatters 0x0D1D:0x0916 (word->dec) / 0x0D1D:0x08FA (long->dec):
 *     "Error \""          (str 0x24CF)
 *     <module>            (strcat [bp-0x52])
 *     "\" in module \""   (str 0x24D7)
 *     <si>  <"\" data: "(0x24E5)>  <di>  <" "(0x24EE)>  <[bp+0xA]>
 *   each accumulated line flushed with `lea ax,[bp-0x50]; push ss; mov ax,1;
 *   lcall 0x1A1F:0x0F26` (@asm 0x077BA9 ...).
 *
 *   Then, gated on byte [0x264F] (memory-error flag, @asm 0x077BC9):
 *     "Tried to allocate "(0x24F0) <[bp-0x54]> " bytes when only "(0x2503)
 *     <[bp+0xA]> " bytes were free."(0x2515)   — emitted via 0x0D1D:0x0916.
 *   "Most recent memory check: "(0x2529) <[0x27AC]>            (@asm 0x077CAE)
 *   "Most recent DOS error:    "(0x2544) <last-DOS-error>      (@asm 0x077C9F)
 *   "Stack use indicator:      "(0x255F) <0x181F:0x08BC()>     (@asm 0x077CEA)
 *
 *   @asm 0x077D25  lea bx,[0x257C] ("*warn0.dat")  / 0x077D2C lea bx,[0x2587] ("*warn6.dat")
 *   @asm 0x077D30  push cs; call 0x077DFB (ljmp 0x1A1F:0x0F1A) — dump to that file
 *   @asm 0x077D34  if errptr [0x2474:0x2472] != 0  -> lcall [0x2472]  (run error hook)
 *   @asm 0x077D41  if modptr [0x2470:0x246E] != 0  -> lcall [0x246E]  (run module hook)
 *   @asm 0x077D4E  push 3; lcall 0x0D1D:0x030D       — exit(3)/abort
 *   @asm 0x077D5B  ret 8
 *
 * String IDs cited verbatim from DGROUP (file base 0x1D9A0); all are diagnostic
 * literals.  The exact value packed into each %-slot beyond "the arg / the
 * formatter output" is TBD only where the helper's return is opaque.
 * -------------------------------------------------------------------------- */
void func_077B10_fatal_error_report(uint16_t arg_si, uint16_t arg_di,
                                     uint16_t code_bp04, uint16_t mod_bp06,
                                     uint16_t mod_bp08, uint16_t count_bp0A)
{
    char buf[0x50];   /* [bp-0x50] line-accumulation buffer */

    func_077990();    /* @asm 0x077B20  push cs; call 0x077DF6 -> 0x181F:0x03D4 (report begin) */

    if (code_bp04 == (uint16_t)-0x14) {       /* @asm 0x077B24/28  short path */
        /* short path: emit the "*warn6.dat" tail only (see below) */
    } else {
        /* "Error \"" + <module> + "\" in module \"" + <si> + "\" data: " + <di>
         * + " " + <count> — all via strcpy/strcat + word/long formatters. */
        overlay_call_0D1D_07E4();             /* @asm 0x077B34  strcpy(buf, "Error \"")  (str 0x24CF) */
        overlay_call_0D1D_07A4();             /* @asm 0x077B43  strcat(buf, <module> [bp-0x52]) */
        overlay_call_0D1D_07A4();             /* @asm 0x077B52  strcat(buf, "\" in module \"") (0x24D7) */
        overlay_call_0D1D_07A4();             /* @asm 0x077B5F  strcat(buf, <si>) */
        overlay_call_0D1D_07A4();             /* @asm 0x077B6E  strcat(buf, "\" data: ") (0x24E5) */
        overlay_call_0D1D_07A4();             /* @asm 0x077B7B  strcat(buf, <di>) */
        overlay_call_0D1D_07A4();             /* @asm 0x077B8A  strcat(buf, " ") (0x24EE) */
        overlay_call_0D1D_07A4();             /* @asm 0x077B99  strcat(buf, <count> [bp+0xA]) */
        overlay_call_1A1F_0F26();             /* @asm 0x077BA9  emit line (push ss; mov ax,1) */

        if (overlay_call_0D1D_0842() != 0) {  /* @asm 0x077BB1  if str-test(0x2478) -> echo to stderr */
            overlay_call_1A1F_0F26();         /* @asm 0x077BC4  emit "0x2478" line */
        }

        if (*(volatile uint8_t *)0x264F != 0) {   /* @asm 0x077BC9  memory-error flag */
            /* "Tried to allocate " <[bp-0x54]> " bytes when only " <count> " bytes were free." */
            overlay_call_0D1D_0916();         /* @asm 0x077BE0  fmt [0x2654:0x2652] */
            overlay_call_0D1D_0916();         /* @asm 0x077BF5  fmt [0x2658:0x2656] */
            overlay_call_0D1D_07E4();         /* @asm 0x077C04  strcpy "Tried to allocate " (0x24F0) */
            overlay_call_0D1D_07A4();         /* @asm 0x077C13  strcat <bytes-wanted> [bp-0x54] */
            overlay_call_0D1D_07A4();         /* @asm 0x077C22  strcat " bytes when only " (0x2503) */
            overlay_call_0D1D_07A4();         /* @asm 0x077C31  strcat <count> [bp+0xA] */
            overlay_call_0D1D_07A4();         /* @asm 0x077C40  strcat " bytes were free." (0x2515) */
            overlay_call_1A1F_0F26();         /* @asm 0x077C50  emit line */
        }

        overlay_call_1A1F_0F26();             /* @asm 0x077C5C  emit " " (0x2527) line */

        /* "Most recent memory check: " <[0x27AC]> */
        overlay_call_0D1D_07E4();             /* @asm 0x077C68  strcpy "Most recent memory check: " (0x2529) */
        overlay_call_0D1D_0916();             /* @asm 0x077C7B  fmt [bp+8]:[bp+6] */
        overlay_call_0D1D_07A4();             /* @asm 0x077C8A  strcat value */
        overlay_call_1A1F_0F26();             /* @asm 0x077C9A  emit line */

        /* "Most recent DOS error:    " <[0x27AC]> */
        overlay_call_0D1D_07E4();             /* @asm 0x077CA6  strcpy "Most recent DOS error:    " (0x2544) */
        (void)g_dbg_memchk_27AC;
        overlay_call_0D1D_08FA();             /* @asm 0x077CB7  fmt long [bp-0x54]:[0x27AC] */
        overlay_call_0D1D_07A4();             /* @asm 0x077CC6  strcat value */
        overlay_call_1A1F_0F26();             /* @asm 0x077CD6  emit line */

        /* "Stack use indicator:      " <stack-use> */
        overlay_call_0D1D_07E4();             /* @asm 0x077CE2  strcpy "Stack use indicator:      " (0x255F) */
        overlay_call_181F_08BC();             /* @asm 0x077CEF  stack-use indicator value */
        overlay_call_0D1D_08FA();             /* @asm 0x077CF5  fmt long */
        overlay_call_0D1D_07A4();             /* @asm 0x077D04  strcat value */
        overlay_call_1A1F_0F26();             /* @asm 0x077D14  emit line */
        overlay_call_1A1F_0F26();             /* @asm 0x077D20  emit " " (0x257A) line */
    }

    /* @asm 0x077D25 / 0x077D2C  choose dump file: "*warn0.dat" (long) / "*warn6.dat" (short) */
    func_077990();        /* @asm 0x077D30  push cs; call 0x077DFB -> 0x1A1F:0x0F1A (write dump file) */

    if (g_dbg_errptr_2474 != 0) { /* @asm 0x077D34  or [0x2474],[0x2472] */
        /* lcall [0x2472] — run registered error-cleanup hook (@asm 0x077D3D) */
    }
    if (g_dbg_modptr_2470 != 0) { /* @asm 0x077D41  or [0x2470],[0x246E] */
        /* lcall [0x246E] — run registered module-cleanup hook (@asm 0x077D4A) */
    }

    overlay_call_0D1D_030D();     /* @asm 0x077D4E  push 3; lcall 0x0D1D:0x030D — exit(3) */
    (void)buf; (void)arg_si; (void)arg_di; (void)mod_bp06; (void)mod_bp08; (void)count_bp0A;
}

/* ----------------------------------------------------------------------------
 * func_077D5E — fatal_error_report_xy  [DONE — control flow BYTE_VERIFIED]
 * @asm 0x077D5E..0x077DF5  (162 bytes)  page_1D.asm  (terminal retf 8)
 *
 * Thin front-end to func_077B10: formats two long values (si, di) into decimal
 * scratch strings, formats the two coordinate words from [bp+0xC]/[bp+0xA] and
 * [bp+8]/[bp+6], then calls func_077B10 to build+emit the panic report.  Gated
 * by a verbosity threshold so low-priority diagnostics are dropped.
 *
 * @asm 0x077D6B  [bp-2] = 0
 * @asm 0x077D70  mov ax,[0x2476]; cmp dx,ax; jl 0x077DF0   ; below threshold -> skip
 * @asm 0x077D77  ltoa(si, &[bp-0x42], 10)        (0x0D1D:0x08FA)
 * @asm 0x077D86  ltoa(di, &[bp-0x6A], 10)        (0x0D1D:0x08FA)
 * @asm 0x077D95  wtoa([bp+0xC]:[bp+0xA] -> &[bp-0xE], 10)   (0x0D1D:0x0916)
 * @asm 0x077DA9  wtoa([bp+8]:[bp+6]     -> &[bp-0x1A], 10)  (0x0D1D:0x0916)
 * @asm 0x077DC2  call 0x077990 (cs:0x110) with (-si, &[bp-0x42], "...0x2592")  ; format field
 * @asm 0x077DCC  call 0x077990 with (di, &[bp-0x6A], "...0x259D")              ; format field
 * @asm 0x077DD8  lcall 0x191F:0x027A(&[bp-0x1A])                                ; value xform
 * @asm 0x077DED  call func_077B10 (cs:0x290) with composed args
 * @asm 0x077DF3  retf 8
 * -------------------------------------------------------------------------- */
void func_077D5E_fatal_error_report_xy(uint16_t a_si, int16_t prio_dx,
                                        uint16_t y_bp06, uint16_t x_bp08,
                                        uint16_t v_bp0A, uint16_t w_bp0C)
{
    char dec_si[0x40];   /* [bp-0x42] */
    char dec_di[0x50];   /* [bp-0x6A] */
    char coord_a[0x0C];  /* [bp-0x0E] */
    char coord_b[0x10];  /* [bp-0x1A] */

    if (prio_dx < g_dbg_threshold_2476)        /* @asm 0x077D70/75  below verbosity threshold */
        return;

    overlay_call_0D1D_08FA();   /* @asm 0x077D77  ltoa(si -> dec_si, 10) */
    overlay_call_0D1D_08FA();   /* @asm 0x077D86  ltoa(di -> dec_di, 10) */
    overlay_call_0D1D_0916();   /* @asm 0x077D95  wtoa(w:v -> coord_a, 10) */
    overlay_call_0D1D_0916();   /* @asm 0x077DA9  wtoa(x:y -> coord_b, 10) */

    func_077990();              /* @asm 0x077DC2  format field <-si, dec_si, str 0x2592> */
    func_077990();              /* @asm 0x077DCC  format field < di, dec_di, str 0x259D> */
    overlay_call_191F_027A();   /* @asm 0x077DD8  value transform on coord_b */

    /* @asm 0x077DED  tail-build the report (args = si, formatter outputs). */
    func_077B10_fatal_error_report(a_si, prio_dx, /*code*/0, y_bp06, x_bp08, v_bp0A);

    (void)dec_si; (void)dec_di; (void)coord_a; (void)coord_b; (void)w_bp0C;
}

/* ----------------------------------------------------------------------------
 * func_078142 — assert_report  [DONE — control flow BYTE_VERIFIED]
 * @asm 0x078142..0x078183  (66 bytes)  page_1E.asm  (terminal retf)
 *
 * The assertion reporter (the "DANGER" path).  Registers/echoes a module name,
 * widens three int args to longs into the diagnostic scratch block at DGROUP
 * 0x9CB0/0x9CB4/0x9CB8, then emits the report keyed by the "DANGER" (0x25B4)
 * literal.
 *
 * @asm 0x078146  push ds; push [bp+6]; push 0; lcall 0x181F:0x0416   ; register module ptr
 * @asm 0x078152  ax=[bp+8]; cdq; [0x9CB0]=ax, [0x9CB2]=dx            ; bytes a3 b0 9c
 * @asm 0x07815D  ax=[bp+0xA]; cdq; [0x9CB4]=ax, [0x9CB6]=dx
 * @asm 0x078168  ax=[bp+0xC]; cdq; [0x9CB8]=ax, [0x9CBA]=dx
 * @asm 0x078173  lea bx,[0x25BB] ("DEBUG"); lea ax,[0x25B4] ("DANGER"); sub dx,dx
 * @asm 0x07817D  lcall 0x181F:0x0998                                ; emit assert(level,name)
 * -------------------------------------------------------------------------- */
void func_078142_assert_report(uint16_t modptr_bp06, int16_t a_bp08,
                                int16_t b_bp0A, int16_t c_bp0C)
{
    overlay_call_181F_0416();                       /* @asm 0x078146  register module(ds,[bp+6],0) */

    *(volatile int32_t *)0x9CB0 = (int32_t)a_bp08;  /* @asm 0x078152  store widened arg0 */
    *(volatile int32_t *)0x9CB4 = (int32_t)b_bp0A;  /* @asm 0x07815D  store widened arg1 */
    *(volatile int32_t *)0x9CB8 = (int32_t)c_bp0C;  /* @asm 0x078168  store widened arg2 */

    /* @asm 0x078173  bx="DEBUG"(0x25BB), ax="DANGER"(0x25B4) — both diagnostic literals. */
    overlay_call_181F_0998();                       /* @asm 0x07817D  emit assertion report */
    (void)modptr_bp06;
}

/* ----------------------------------------------------------------------------
 * func_078184 — viceroy_log_write  [DONE — control flow BYTE_VERIFIED]
 * @asm 0x078184..0x0781DD  (90 bytes)  page_1E.asm  (terminal retf)
 *
 * The VICEROY.LOG line logger.  Opens VICEROY.LOG with "wt" (truncate) the
 * first time and "at" (append) thereafter (one-shot flag byte [0x25F0]), writes
 * one formatted line "(%d, %d, %d) %s\n" (fmt 0x25DF) with the four args, then
 * closes the handle.
 *
 * @asm 0x07818D  cmp byte [0x25F0], 0 ; bytes 80 3e f0 25 00
 * @asm 0x078192  jne 0x07819C
 * @asm 0x078194  push "VICEROY.LOG"(0x25C4); push "wt"(0x25C1)        ; first open: truncate
 * @asm 0x07819A  jmp 0x0781A2
 * @asm 0x07819C  push "VICEROY.LOG"(0x25D3); push "at"(0x25D0)        ; later: append
 * @asm 0x0781A2  lcall 0x0D1D:0x04DA (fopen) ; [bp-2]=ax = FILE*
 * @asm 0x0781AF  or ax,ax; je 0x0781CE                               ; open failed -> skip
 * @asm 0x0781B1  mov byte [0x25F0], 1                                ; mark opened-once
 * @asm 0x0781B6  push [bp+0xC],[bp+0xA],[bp+8],[bp+6]; push "(%d, %d, %d) %s\n"(0x25DF); push FILE*
 * @asm 0x0781C6  lcall 0x0D1D:0x04F0 (fprintf)
 * @asm 0x0781CE  if [bp-2]!=0 -> push FILE*; lcall 0x0D1D:0x03F4 (fclose)
 * @asm 0x0781DC  retf 4
 * -------------------------------------------------------------------------- */
void func_078184_viceroy_log_write(uint16_t a_bp06, uint16_t b_bp08,
                                    uint16_t c_bp0A, uint16_t str_bp0C)
{
    int fh;   /* [bp-2] — FILE* from fopen */

    /* @asm 0x07818D  pick "wt" on first call, "at" afterwards (filename "VICEROY.LOG"). */
    if (g_dbg_logopen_25F0 == 0) {
        /* fopen("VICEROY.LOG","wt")  @asm 0x078194 */
    } else {
        /* fopen("VICEROY.LOG","at")  @asm 0x07819C */
    }
    fh = overlay_call_0D1D_04DA();          /* @asm 0x0781A2  fopen -> handle */

    if (fh != 0) {                          /* @asm 0x0781AD/AF */
        g_dbg_logopen_25F0 = 1;             /* @asm 0x0781B1  mark opened-once */
        overlay_call_0D1D_04F0();           /* @asm 0x0781C6  fprintf(fh,"(%d, %d, %d) %s\n",a,b,c,str) */
    }
    if (fh != 0) {                          /* @asm 0x0781CE  if handle valid */
        overlay_call_0D1D_03F4();           /* @asm 0x0781D7  fclose(fh) */
    }
    (void)a_bp06; (void)b_bp08; (void)c_bp0A; (void)str_bp0C;
}

/* ============================================================================
 * (B) VGA PALETTE / COLOUR-CYCLE ENGINE  — OUT-OF-SCOPE (DOS VGA DAC + PIT)
 *     + the binary palette/cycle FILE LOADER that feeds it.
 * ============================================================================ */

/* func_0781DE — load+decode a binary data file into caller buffer.
 * @asm 0x0781DE..0x078241 (100 B)  page_1E.asm  (terminal retf 4)
 *   @asm 0x0781EB  lea bx,[0x25F2] ("rb"); lcall 0x181F:0x0E86  ; fopen(name,"rb") -> si
 *   @asm 0x0781F8  or si,si; je 0x07822D                        ; open failed -> ret 1
 *   @asm 0x078205  fread(&[bp-0x302], 0x300, 1, si)  (0x0D1D:0x0528)
 *   @asm 0x078220  decode/copy into es:[bp+6]:[bp+8]  (0x0D1D:0x0FB2)  [bp-2]=0
 *   @asm 0x078232  if si: fclose(si)  (0x0D1D:0x03F4); return [bp-2]
 * Reads up to 0x300 (=768) bytes — a VGA palette / cycle definition — and
 * decodes it into the caller's buffer.  Pure file I/O over palette data.
 * OUT-OF-SCOPE: DOS platform (palette/cycle file loader). */
int func_0781DE_load_palette_file(void) { return 0; }

/* ----------------------------------------------------------------------------
 * (B continued) palette/timer hardware leaves.
 * ----------------------------------------------------------------------------
 * These are pure colour/timer hardware: PIT latch (out 0x43 / in 0x40), VGA DAC
 * (out 0x3C8/0x3C9, in 0x3C7), and CRT vsync polling (in 0x3DA bit 3).  They
 * move palette bytes and measure frame timing; none decides layout/sprite/text
 * placement, so per the scope rule they stay platform stubs (return 0).  The
 * CYCLE.DAT loader and cycle teardown are file-I/O over palette data and are
 * likewise OUT.
 * ========================================================================== */

/* func_077ED0 — palette DAC burst w/ PIT timing.  @asm 0x077ED0..0x077F39 (106 B)
 * page_1E.asm: out 0x43/in 0x40 (PIT), out 0x3C8 + rep outsb 0x3C9 (DAC write),
 * returns elapsed PIT ticks.  OUT-OF-SCOPE: DOS platform (VGA DAC / PIT). */
int func_077ED0_palette_dac_burst(void) { return 0; }

/* func_077F3A — vsync-calibrated palette-fade setup.  @asm 0x077F3A..0x078061 (519 B)
 * page_1E.asm: 0x20-sample vsync timing loop (in 0x3DA, in 0x40), stores tick
 * baseline at [0x802], computes per-step DAC counts via 0x1A1F:0x0F30, writes
 * fade state [0x800..0x80A].  OUT-OF-SCOPE: DOS platform (VGA timing). */
int func_077F3A_palette_fade_setup(void) { return 0; }

/* func_078062 — TRAMPOLINE.  @asm 0x078062  ljmp 0x1A1F:0x0F30 (page 0x12 DAC
 * step helper).  RTLink ljmp-far forwarder — no body. */

/* func_078142 / func_078184 are the IN-SCOPE diagnostics above. */

/* func_078242 — palette dim/scale.  @asm 0x078242..0x078268 (39 B)  page_1E.asm:
 * for cx=0x300 bytes:  al = (src >> [bp+0xE]) with rounding (adc al,0), clamped
 * to >=1, stored to es:di.  A 768-byte palette-darken pass.
 * OUT-OF-SCOPE: DOS platform (VGA palette). */
int func_078242_palette_dim(void) { return 0; }

/* func_07826A — palette fade-down step.  @asm 0x07826A..0x078317 (176 B)
 * page_1E.asm: zeroes [0x8338]/[0x833A], calls cs:0x5DE (ljmp 0x1A1F:0x0F3E),
 * then a 0x300-byte saturating-subtract of a delta vector from the live palette
 * (lcall 0x0C0C:0x0022 = 32-bit accumulate), looping until the target is hit.
 * OUT-OF-SCOPE: DOS platform (VGA palette fade). */
int func_07826A_palette_fade_down(void) { return 0; }

/* func_07831A — palette fade-up step.  @asm 0x07831A..0x0783DA (320 B)
 * page_1E.asm: mirror of func_07826A but a saturating-ADD toward a ceiling
 * (xchg ah,al; add al,dl; cmp/clamp), over the 0x300-byte palette.
 * OUT-OF-SCOPE: DOS platform (VGA palette fade). */
int func_07831A_palette_fade_up(void) { return 0; }

/* func_0783DE — TRAMPOLINE.  @asm 0x0783DE  ljmp 0x1A1F:0x0F3E (page 0x12 fade
 * helper; the cs:0x5DE target of func_07826A / func_07831A).  No body.
 * NOTE: the auto-skeleton's "func_0783E4" mis-frames this trampoline (it began
 * 4 bytes into the reloc padding); the reseg page lists no function there. */

/* func_0783E4 — CYCLE.DAT loader + colour-cycle teardown.  (auto-skeleton name)
 * @asm 0x0783EE  fopen("CYCLE.DAT"(0x25F9),"rb"(0x25F6)) via 0x181F:0x0E86,
 *               fread into [0x929E] (0x0D1D:0x0528), fclose (0x0D1D:0x03F4).
 * @asm 0x078422  if handle [0x2604]!=0: stop cycling (0x181F:0x04DE/0x0EC2/0x05D8),
 *               free cycle def (0x1A1F:0x0F74 / 0x1A1F:0x0F4C), clear [0x2604].
 * OUT-OF-SCOPE: DOS platform (palette-cycle data file I/O). */
int func_0783E4_cycle_dat_load(void) { return 0; }

/* func_07845A — colour-cycle register + DAC blaster.  @asm 0x07845A..0x078594 (315 B)
 * page_1E.asm: copies a cycle name (substituting '#' with a digit, @asm 0x078480),
 * registers the cycle definition via 0x1A1F:0x0F6A (handle -> [0x2604]), drives
 * the per-frame colour rotation (0x1A1F:0x0F60 / 0x0F56), and its cs:0x742 tail
 * (ljmp 0x1A1F:0x0E4E) plus the 0x078547 sub-block blast palette bytes straight
 * to the DAC (out 0x3C7, insb from 0x3C9, vsync wait on 0x3DA).
 * OUT-OF-SCOPE: DOS platform (VGA palette cycling / DAC). */
int func_07845A_palette_cycle_run(void) { return 0; }

/* func_078595 — PHANTOM.  @asm 0x078595 = bytes `ca 04 00` = `retf 4`, the
 * terminal RETF of func_07845A (which ends ...5e 5f c9 at 0x078594).  The
 * re-segmenter split it off at the page boundary (size=315 stops one byte
 * short of the RETF).  Not a function — no body. */

/* func_078542 — TRAMPOLINE.  @asm 0x078542  ljmp 0x1A1F:0x0E4E (page 0x12; the
 * cs:0x742 target of func_07845A).  No body. */

/* ============================================================================
 * (C) DOS NEAR-HEAP / MEMORY-BLOCK MANAGER  — OUT-OF-SCOPE (int-21h heap)
 * ----------------------------------------------------------------------------
 * These manage a near-heap of DOS memory blocks.  They issue int 21h AH=0x48
 * (allocate), 0x49 (free), 0x4A (resize) and manipulate a block-descriptor
 * struct at es:bx (byte +0 type, +1 in-use flag, +2/+4 seg:handle, +6/+8 base,
 * +0xA/+0xC current, +0xE/+0x10 remaining), driven by the page-0x12 (seg
 * 0x1A1F) heap primitives 0x1A1F:0x0F96/0x0FA0/0x0FBC/0x0FC6/0x0FD4/0x0FDE.
 * Pure byte/segment movers -> platform stubs (return 0).
 * ========================================================================== */

/* func_078640 — heap alloc/lookup dispatch.  @asm 0x078640..0x0786FD (189 B)
 * page_1F.asm: parses a request via 0x181F:0x0ECC, branches on si (-8 = record
 * lookup via 0x1A1F:0x0FA0 then publish via 0x181F:0x033A; -2 = direct via
 * 0x1A1F:0x0F96), returns a block index.  OUT-OF-SCOPE: DOS heap. */
int func_078640_heap_alloc_dispatch(void) { return 0; }

/* func_0786FE — heap resize/grow dispatch.  @asm 0x0786FE..0x0787A1 (163 B)
 * page_1F.asm: same 0x181F:0x0ECC parse; classifies si into grow (0x1A1F:0x0F8C)
 * vs commit (0x1A1F:0x0F7E) using the descriptor at [0x2D28..].  OUT-OF-SCOPE. */
int func_0786FE_heap_resize_dispatch(void) { return 0; }

/* func_0787A2 — alloc(count*size).  @asm 0x0787A2..0x0787DB (58 B)  page_1F.asm:
 * mul cx (count) * dx (size), call near-alloc 0x181F:0x029A, stash result handle
 * at si+4/+6 (or seg:off at si/+2 on success).  OUT-OF-SCOPE: DOS heap. */
int func_0787A2_calloc_near(void) { return 0; }

/* func_0787DC — alloc(count*size) far.  @asm 0x0787DC..0x07881D (66 B)
 * page_1F.asm: as func_0787A2 but the allocator is far via 0x1A1F:0x0E90.
 * OUT-OF-SCOPE: DOS heap. */
int func_0787DC_calloc_far(void) { return 0; }

/* func_07881E — free block handle.  @asm 0x07881E..0x078855 (55 B)  page_1F.asm:
 * if descriptor [bx+4]:[bx+6] nonzero -> lcall 0x191F:0x01A8 (free), then zero
 * the descriptor's four words.  OUT-OF-SCOPE: DOS heap. */
int func_07881E_free_block(void) { return 0; }

/* func_078856 — guarded indirect call.  @asm 0x078856..0x078871 (28 B)
 * page_1F.asm: if [bp+8]:[bp+6] (a far fn ptr) nonzero, set re-entry guard
 * [0x2672]=1, lcall [bp+6], clear guard.  A platform call-thunk.
 * OUT-OF-SCOPE: DOS platform (runtime trampoline). */
int func_078856_guarded_call(void) { return 0; }

/* func_078872 — heap arena scan/init.  @asm 0x078872..0x0789F8 (391 B)
 * page_1F.asm: walks the DOS free-block chain (lcall 0x1A1F:0x0FC6/0x0FBC heap
 * primitives + int 21h AH=0x48 probe @asm 0x0789A9 `b4 48 cd 21`), records the
 * arena bounds at DGROUP 0x2652..0x266C and the success flag [0x264F].
 * OUT-OF-SCOPE: DOS heap arena management. */
int func_078872_heap_arena_scan(void) { return 0; }

/* func_0789FA — release block (int21 AH=0x49).  @asm 0x0789FA..0x078A49 (80 B)
 * page_1F.asm: if seg [bp+8] >= 0xA000 it is a far helper (0x1A1F:0x0FD4), else
 * `les ax,[bp+6]; mov ah,0x49; int 0x21` (free DOS block).  OUT-OF-SCOPE. */
int func_0789FA_free_dos_block(void) { return 0; }

/* func_078A4A — resize block (int21 AH=0x4A).  @asm 0x078A4A..0x078AF1 (168 B)
 * page_1F.asm: paragraph-rounds a byte size (sar/rcr x4, inc) into bx and
 * `mov ah,0x4A; int 0x21` (set DOS block size); the cs:0x548/0x54D tails are
 * ljmp 0x1A1F:0x0E90 / 0x1A1F:0x0FAE far helpers.  OUT-OF-SCOPE. */
int func_078A4A_resize_dos_block(void) { return 0; }

/* func_078AF2 — SUPERSEDED -> src/iolib/file.c (coreleft_max:
 *   mov ah,0x48; mov bx,0xFFFF; int 0x21 — largest-free-block query).
 * Already ported there with full @asm citation; no body here. */

/* func_078AE8 — TRAMPOLINE.  @asm 0x078AE8 ljmp 0x1A1F:0x0E90.  No body. */
/* func_078AED — TRAMPOLINE.  @asm 0x078AED ljmp 0x1A1F:0x0FAE.  No body. */

/* func_078B0E — block grow + descriptor publish.  @asm 0x078B0E..0x078BCD (191 B)
 * page_1F.asm: queries current top (cs:0x598 = ljmp 0x1A1F:0x0FC6), grows via
 * 0x1A1F:0x0E90 / falls back to 0x191F:0x027A + 0x181F:0x0772, then fills the
 * caller's descriptor at es:[bp+0xE] (+1 flag, +2..+0x10 the seg/base/cur).
 * OUT-OF-SCOPE: DOS heap. */
int func_078B0E_block_grow(void) { return 0; }

/* func_078B38 — TRAMPOLINE.  @asm 0x078B38 ljmp 0x1A1F:0x0FC6 (heap-top query;
 * the cs:0x598 target of func_078B0E).  No body. */

/* func_078BCE — descriptor init (static block).  @asm 0x078BCE..0x078C0B (62 B)
 * page_1F.asm: zero-fills the in-use flag and seeds a block descriptor at
 * es:[bp+0xE] from (al type, [bp+0xA]:[bp+0xC] base, [bp+6]:[bp+8] size).
 * OUT-OF-SCOPE: DOS heap. */
int func_078BCE_descriptor_init(void) { return 0; }

/* func_078C0C — free descriptor + clear.  @asm 0x078C0C..0x078C47 (59 B)
 * page_1F.asm: if descriptor es:[bx+1] set, lcall 0x191F:0x01A8 (free), then
 * zero the six descriptor words.  OUT-OF-SCOPE: DOS heap. */
int func_078C0C_free_descriptor(void) { return 0; }

/* func_078C48 — sub-allocate from block.  @asm 0x078C48..0x078CB1 (105 B)
 * page_1F.asm: if the descriptor's remaining (+0xE/+0x10) covers dx:ax, carve
 * it (advance +6, decrement +0xE/+0x10) and return the old cursor; else error
 * via 0x181F:0x0772 with code 0xFFC3.  OUT-OF-SCOPE: DOS heap. */
int func_078C48_block_suballoc(void) { return 0; }

/* func_078CB2 — shrink block to used (int21 AH=0x4A).  @asm 0x078CB2..0x078D3A (137 B)
 * page_1F.asm: computes used = cur - remaining, paragraph-rounds, `mov ah,0x4A;
 * int 0x21` to shrink the DOS allocation, then resets the descriptor cursor.
 * OUT-OF-SCOPE: DOS heap. */
int func_078CB2_shrink_block(void) { return 0; }

/* func_078D3B — PHANTOM.  @asm 0x078D3B = bytes `ca 04 00` = `retf 4`, the
 * terminal RETF of func_078CB2 (which ends ...5e 5f c9 at 0x078D3A).  The
 * re-segmenter split it off at the page end (size=137 stops one byte short of
 * the RETF).  Not a function — no body. */
