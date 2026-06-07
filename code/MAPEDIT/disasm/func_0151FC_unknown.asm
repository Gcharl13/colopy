; ============================================================================
; func_0151FC_unknown
; Region   : load_image
; Bytes    : file 0x0151FC..0x015227  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0151FC  55                    PUSH   bp ; STACK_PUSH
0151FD  8B EC                 MOV    bp, sp ; MOV
0151FF  56                    PUSH   si ; STACK_PUSH
015200  9A 7E 1B 88 13        LCALL  0x1388, 0x1b7e ; LCALL
015205  8B F0                 MOV    si, ax ; MOV
015207  0B F6                 OR     si, si ; LOGIC
015209  75 05                 JNE    0x15210 ; CJUMP
01520B  2B C0                 SUB    ax, ax ; ARITH
01520D  EB 13                 JMP    0x15222 ; JUMP
01520F  90                    NOP ; NOP
015210  56                    PUSH   si ; STACK_PUSH
015211  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
015214  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
015217  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
01521A  9A 34 14 88 13        LCALL  0x1388, 0x1434 ; LCALL
01521F  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
015222  5E                    POP    si ; STACK_POP
015223  8B E5                 MOV    sp, bp ; MOV
015225  5D                    POP    bp ; STACK_POP
015226  CB                    RETF ; RETURN
