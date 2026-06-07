; ============================================================================
; func_00C1F8_unknown
; Region   : load_image
; Bytes    : file 0x00C1F8..0x00C20C  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C1F8  55                    PUSH   bp ; STACK_PUSH
00C1F9  8B EC                 MOV    bp, sp ; MOV
00C1FB  56                    PUSH   si ; STACK_PUSH
00C1FC  6A 01                 PUSH   1 ; STACK_PUSH
00C1FE  9A B4 00 09 00        LCALL  9, 0xb4 ; LCALL
00C203  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00C206  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
00C20A  8B C3                 MOV    ax, bx ; MOV
