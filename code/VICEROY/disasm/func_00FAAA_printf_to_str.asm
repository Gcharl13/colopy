; ============================================================================
; func_00FAAA_printf_to_str
; Region   : load_image
; Bytes    : file 0x00FAAA..0x00FABF  (21 bytes)
; Purpose  : C `printf` / `vsprintf`-style entry: pushes 0 (NULL fill arg), the format string ([bp+8]), and a destination buffer pointer ([bp+6]), then far-calls 0x0D1D:0x04AE — the overlay-resident format-string engine. Returns whatever the engine returns.
; Args     : [bp+6] = output pointer, [bp+8] = format-string pointer
; Returns  : AX = length written (per typical C convention)
; Callers  : TBD (9 distinct call sites)
; Callees  : 0x0D1D:0x04AE — overlay-resident format engine
; Verified : Boundary verified: ENTER-less wrapper, LCALL + RETF, 21 bytes.
; Source   : Pattern matches standard C runtime printf shim; LCALL target is in the overlay's format module.
; ============================================================================

00FAAA  55                    PUSH   bp                           ; standard frame prologue
00FAAB  8B EC                 MOV    bp, sp                       ; BP = SP
00FAAD  2B C0                 SUB    ax, ax                       ; AX = 0 — passed as the "fill / NULL" argument to the format engine
00FAAF  50                    PUSH   ax                           ; push 0 (3rd arg to engine)
00FAB0  FF 76 08              PUSH   word ptr [bp + 8]            ; push format string ptr (2nd arg)
00FAB3  FF 76 06              PUSH   word ptr [bp + 6]            ; push output buffer ptr (1st arg)
00FAB6  9A AE 04 1D 0D        LCALL  0xd1d, 0x4ae                 ; far-call the overlay-resident format engine; on return AX = bytes written
00FABB  8B E5                 MOV    sp, bp                       ; restore SP — clean up the 6 bytes we pushed
00FABD  5D                    POP    bp                           ; restore BP
00FABE  CB                    RETF                                ; far-return: AX = bytes written by the format engine
