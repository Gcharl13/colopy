; ============================================================================
; func_005A9C_unknown
; Region   : load_image
; Bytes    : file 0x005A9C..0x005AC8  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005A9C  55                    PUSH   bp ; STACK_PUSH
005A9D  8B EC                 MOV    bp, sp ; MOV
005A9F  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
005AA3  75 0D                 JNE    0x5ab2 ; CJUMP
005AA5  2B C0                 SUB    ax, ax ; ARITH
005AA7  50                    PUSH   ax ; STACK_PUSH
005AA8  B8 04 00              MOV    ax, 4 ; MOV
005AAB  50                    PUSH   ax ; STACK_PUSH
005AAC  2B C0                 SUB    ax, ax ; ARITH
005AAE  50                    PUSH   ax ; STACK_PUSH
005AAF  EB 0B                 JMP    0x5abc ; JUMP
005AB1  90                    NOP ; NOP
005AB2  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
005AB5  50                    PUSH   ax ; STACK_PUSH
005AB6  2B C0                 SUB    ax, ax ; ARITH
005AB8  50                    PUSH   ax ; STACK_PUSH
005AB9  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005ABC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005ABF  9A 44 1E 52 04        LCALL  0x452, 0x1e44 ; LCALL
005AC4  8B E5                 MOV    sp, bp ; MOV
005AC6  5D                    POP    bp ; STACK_POP
005AC7  CB                    RETF ; RETURN
