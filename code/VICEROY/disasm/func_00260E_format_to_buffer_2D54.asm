; ============================================================================
; func_00260E_format_to_buffer_2D54
; Region   : load_image
; Bytes    : file 0x00260E..0x002631  (35 bytes)
; Purpose  : Twice calls the format engine at 0x0D1D:0x11B4 with the buffer at DGROUP:0x2D54: first to format the caller's two arguments ([bp+6], [bp+8]) into the buffer, then again with constant 0x4D (77) — likely terminator append or finalisation pass.
; Args     : [bp+6], [bp+8] = format arguments
; Returns  : (no useful return value)
; Callers  : TBD (4 distinct call sites)
; Callees  : 0x0D1D:0x11B4 (overlay format engine — different from the 0x4AE engine used by printf_to_str)
; Verified : Boundary verified: PUSH BP / LEAVE / RETF, 35 bytes.
; Source   : Two LCALL 0xD1D:0x11B4 to a fixed buffer at 0x2D54.
; ============================================================================

00260E  55                    PUSH   bp                           ; standard frame prologue
00260F  8B EC                 MOV    bp, sp                       ; BP = SP
002611  FF 76 08              PUSH   word ptr [bp + 8]            ; push 2nd arg
002614  FF 76 06              PUSH   word ptr [bp + 6]            ; push 1st arg
002617  1E                    PUSH   ds                           ; push DS (high half of buffer far-pointer)
002618  68 54 2D              PUSH   0x2d54                       ; push offset 0x2D54 (low half of far-pointer to a fixed buffer)
00261B  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4                ; far-call format engine #2 at 0x0D1D:0x11B4
002620  8B E5                 MOV    sp, bp                       ; restore SP (clean all 8 bytes pushed)
002622  1E                    PUSH   ds                           ; push DS
002623  68 4D 00              PUSH   0x4d                         ; push 0x4D = 77 — likely a format-spec or terminator code
002626  1E                    PUSH   ds                           ; push DS
002627  68 54 2D              PUSH   0x2d54                       ; push offset of buffer again
00262A  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4                ; second call to the same format engine
00262F  C9                    LEAVE                               ; teardown
002630  CB                    RETF                                ; far-return
