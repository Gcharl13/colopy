; ============================================================================
; func_00C276_unknown
; Region   : load_image
; Bytes    : file 0x00C276..0x00C28A  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C276  55                    PUSH   bp ; STACK_PUSH
00C277  8B EC                 MOV    bp, sp ; MOV
00C279  56                    PUSH   si ; STACK_PUSH
00C27A  6A 01                 PUSH   1 ; STACK_PUSH
00C27C  9A B4 00 09 00        LCALL  9, 0xb4 ; LCALL
00C281  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00C284  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
00C288  8B C3                 MOV    ax, bx ; MOV
