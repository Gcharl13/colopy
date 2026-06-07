; ============================================================================
; func_00B4B8_unknown
; Region   : load_image
; Bytes    : file 0x00B4B8..0x00B4C3  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B4B8  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00B4BC  56                    PUSH   si ; STACK_PUSH
00B4BD  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
00B4C1  8B C3                 MOV    ax, bx ; MOV
