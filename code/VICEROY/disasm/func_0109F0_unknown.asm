; ============================================================================
; func_0109F0_unknown
; Region   : load_image
; Bytes    : file 0x0109F0..0x0109FF  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0109F0  55                    PUSH   bp ; STACK_PUSH
0109F1  8B EC                 MOV    bp, sp ; MOV
0109F3  1E                    PUSH   ds ; STACK_PUSH
0109F4  8E 06 B2 27           MOV    es, word ptr [0x27b2] ; GLOBAL_LOAD
0109F8  26 8B 1E 2C 00        MOV    bx, word ptr es:[0x2c] ; GLOBAL_LOAD
0109FD  8E C3                 MOV    es, bx ; MOV
