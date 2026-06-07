; ============================================================================
; func_005274_unknown
; Region   : load_image
; Bytes    : file 0x005274..0x005283  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005274  55                    PUSH   bp ; STACK_PUSH
005275  8B EC                 MOV    bp, sp ; MOV
005277  1E                    PUSH   ds ; STACK_PUSH
005278  8E 06 50 40           MOV    es, word ptr [0x4050] ; GLOBAL_LOAD
00527C  26 8B 1E 2C 00        MOV    bx, word ptr es:[0x2c] ; GLOBAL_LOAD
005281  8E C3                 MOV    es, bx ; MOV
