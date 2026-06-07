; ============================================================================
; func_00467E_unknown
; Region   : load_image
; Bytes    : file 0x00467E..0x0046A9  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00467E  55                    PUSH   bp ; STACK_PUSH
00467F  8B EC                 MOV    bp, sp ; MOV
004681  56                    PUSH   si ; STACK_PUSH
004682  9A E6 19 7D 03        LCALL  0x37d, 0x19e6 ; LCALL
004687  8B F0                 MOV    si, ax ; MOV
004689  0B F6                 OR     si, si ; LOGIC
00468B  75 05                 JNE    0x4692 ; CJUMP
00468D  2B C0                 SUB    ax, ax ; ARITH
00468F  EB 13                 JMP    0x46a4 ; JUMP
004691  90                    NOP ; NOP
004692  56                    PUSH   si ; STACK_PUSH
004693  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
004696  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
004699  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00469C  9A 9C 12 7D 03        LCALL  0x37d, 0x129c ; LCALL
0046A1  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0046A4  5E                    POP    si ; STACK_POP
0046A5  8B E5                 MOV    sp, bp ; MOV
0046A7  5D                    POP    bp ; STACK_POP
0046A8  CB                    RETF ; RETURN
