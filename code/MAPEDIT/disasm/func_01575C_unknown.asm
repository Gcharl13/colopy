; ============================================================================
; func_01575C_unknown
; Region   : load_image
; Bytes    : file 0x01575C..0x015788  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01575C  55                    PUSH   bp ; STACK_PUSH
01575D  8B EC                 MOV    bp, sp ; MOV
01575F  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
015763  75 0D                 JNE    0x15772 ; CJUMP
015765  2B C0                 SUB    ax, ax ; ARITH
015767  50                    PUSH   ax ; STACK_PUSH
015768  B8 04 00              MOV    ax, 4 ; MOV
01576B  50                    PUSH   ax ; STACK_PUSH
01576C  2B C0                 SUB    ax, ax ; ARITH
01576E  50                    PUSH   ax ; STACK_PUSH
01576F  EB 0B                 JMP    0x1577c ; JUMP
015771  90                    NOP ; NOP
015772  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
015775  50                    PUSH   ax ; STACK_PUSH
015776  2B C0                 SUB    ax, ax ; ARITH
015778  50                    PUSH   ax ; STACK_PUSH
015779  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
01577C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
01577F  9A 6C 20 88 13        LCALL  0x1388, 0x206c ; LCALL
015784  8B E5                 MOV    sp, bp ; MOV
015786  5D                    POP    bp ; STACK_POP
015787  CB                    RETF ; RETURN
