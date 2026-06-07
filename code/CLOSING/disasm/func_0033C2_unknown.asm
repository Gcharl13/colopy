; ============================================================================
; func_0033C2_unknown
; Region   : load_image
; Bytes    : file 0x0033C2..0x0033D1  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0033C2  55                    PUSH   bp ; STACK_PUSH
0033C3  8B EC                 MOV    bp, sp ; MOV
0033C5  8B C8                 MOV    cx, ax ; MOV
0033C7  88 0E 74 36           MOV    byte ptr [0x3674], cl ; GLOBAL_LOAD
0033CB  88 16 75 36           MOV    byte ptr [0x3675], dl ; GLOBAL_LOAD
0033CF  8B C3                 MOV    ax, bx ; MOV
