; ============================================================================
; func_004AD8_unknown
; Region   : load_image
; Bytes    : file 0x004AD8..0x004B04  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004AD8  55                    PUSH   bp ; STACK_PUSH
004AD9  8B EC                 MOV    bp, sp ; MOV
004ADB  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
004ADF  75 0D                 JNE    0x4aee ; CJUMP
004AE1  2B C0                 SUB    ax, ax ; ARITH
004AE3  50                    PUSH   ax ; STACK_PUSH
004AE4  B8 04 00              MOV    ax, 4 ; MOV
004AE7  50                    PUSH   ax ; STACK_PUSH
004AE8  2B C0                 SUB    ax, ax ; ARITH
004AEA  50                    PUSH   ax ; STACK_PUSH
004AEB  EB 0B                 JMP    0x4af8 ; JUMP
004AED  90                    NOP ; NOP
004AEE  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
004AF1  50                    PUSH   ax ; STACK_PUSH
004AF2  2B C0                 SUB    ax, ax ; ARITH
004AF4  50                    PUSH   ax ; STACK_PUSH
004AF5  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
004AF8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
004AFB  9A 94 1D 7D 03        LCALL  0x37d, 0x1d94 ; LCALL
004B00  8B E5                 MOV    sp, bp ; MOV
004B02  5D                    POP    bp ; STACK_POP
004B03  CB                    RETF ; RETURN
