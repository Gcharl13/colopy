; ============================================================================
; func_005A3E_unknown
; Region   : load_image
; Bytes    : file 0x005A3E..0x005A58  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005A3E  55                    PUSH   bp ; STACK_PUSH
005A3F  8B EC                 MOV    bp, sp ; MOV
005A41  2B C0                 SUB    ax, ax ; ARITH
005A43  50                    PUSH   ax ; STACK_PUSH
005A44  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
005A47  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
005A4A  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
005A4C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005A4F  9A 9E 08 52 04        LCALL  0x452, 0x89e ; LCALL
005A54  8B E5                 MOV    sp, bp ; MOV
005A56  5D                    POP    bp ; STACK_POP
005A57  CB                    RETF ; RETURN
