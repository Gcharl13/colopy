; ============================================================================
; func_005642_unknown
; Region   : load_image
; Bytes    : file 0x005642..0x00566D  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005642  55                    PUSH   bp ; STACK_PUSH
005643  8B EC                 MOV    bp, sp ; MOV
005645  56                    PUSH   si ; STACK_PUSH
005646  9A 96 1A 52 04        LCALL  0x452, 0x1a96 ; LCALL
00564B  8B F0                 MOV    si, ax ; MOV
00564D  0B F6                 OR     si, si ; LOGIC
00564F  75 05                 JNE    0x5656 ; CJUMP
005651  2B C0                 SUB    ax, ax ; ARITH
005653  EB 13                 JMP    0x5668 ; JUMP
005655  90                    NOP ; NOP
005656  56                    PUSH   si ; STACK_PUSH
005657  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00565A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00565D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005660  9A 4C 13 52 04        LCALL  0x452, 0x134c ; LCALL
005665  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
005668  5E                    POP    si ; STACK_POP
005669  8B E5                 MOV    sp, bp ; MOV
00566B  5D                    POP    bp ; STACK_POP
00566C  CB                    RETF ; RETURN
