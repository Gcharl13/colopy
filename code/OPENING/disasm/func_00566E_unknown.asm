; ============================================================================
; func_00566E_unknown
; Region   : load_image
; Bytes    : file 0x00566E..0x005683  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00566E  55                    PUSH   bp ; STACK_PUSH
00566F  8B EC                 MOV    bp, sp ; MOV
005671  2B C0                 SUB    ax, ax ; ARITH
005673  50                    PUSH   ax ; STACK_PUSH
005674  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005677  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00567A  9A 22 05 52 04        LCALL  0x452, 0x522 ; LCALL
00567F  8B E5                 MOV    sp, bp ; MOV
005681  5D                    POP    bp ; STACK_POP
005682  CB                    RETF ; RETURN
