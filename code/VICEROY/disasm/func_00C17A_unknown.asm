; ============================================================================
; func_00C17A_unknown
; Region   : load_image
; Bytes    : file 0x00C17A..0x00C18E  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C17A  55                    PUSH   bp ; STACK_PUSH
00C17B  8B EC                 MOV    bp, sp ; MOV
00C17D  56                    PUSH   si ; STACK_PUSH
00C17E  6A 01                 PUSH   1 ; STACK_PUSH
00C180  9A B4 00 09 00        LCALL  9, 0xb4 ; LCALL
00C185  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00C188  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
00C18C  8B C3                 MOV    ax, bx ; MOV
