; ============================================================================
; func_006274_unknown
; Region   : load_image
; Bytes    : file 0x006274..0x006283  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006274  55                    PUSH   bp ; STACK_PUSH
006275  8B EC                 MOV    bp, sp ; MOV
006277  1E                    PUSH   ds ; STACK_PUSH
006278  8E 06 A6 42           MOV    es, word ptr [0x42a6] ; GLOBAL_LOAD
00627C  26 8B 1E 2C 00        MOV    bx, word ptr es:[0x2c] ; GLOBAL_LOAD
006281  8E C3                 MOV    es, bx ; MOV
