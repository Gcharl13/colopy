; ============================================================================
; func_0100EC_unknown
; Region   : load_image
; Bytes    : file 0x0100EC..0x010118  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0100EC  55                    PUSH   bp ; STACK_PUSH
0100ED  8B EC                 MOV    bp, sp ; MOV
0100EF  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
0100F3  75 0D                 JNE    0x10102 ; CJUMP
0100F5  2B C0                 SUB    ax, ax ; ARITH
0100F7  50                    PUSH   ax ; STACK_PUSH
0100F8  B8 04 00              MOV    ax, 4 ; MOV
0100FB  50                    PUSH   ax ; STACK_PUSH
0100FC  2B C0                 SUB    ax, ax ; ARITH
0100FE  50                    PUSH   ax ; STACK_PUSH
0100FF  EB 0B                 JMP    0x1010c ; JUMP
010101  90                    NOP ; NOP
010102  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
010105  50                    PUSH   ax ; STACK_PUSH
010106  2B C0                 SUB    ax, ax ; ARITH
010108  50                    PUSH   ax ; STACK_PUSH
010109  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
01010C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
01010F  9A 06 24 1D 0D        LCALL  0xd1d, 0x2406 ; LCALL
010114  8B E5                 MOV    sp, bp ; MOV
010116  5D                    POP    bp ; STACK_POP
010117  CB                    RETF ; RETURN
