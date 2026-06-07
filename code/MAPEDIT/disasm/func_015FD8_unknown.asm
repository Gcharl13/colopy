; ============================================================================
; func_015FD8_unknown
; Region   : load_image
; Bytes    : file 0x015FD8..0x015FE7  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015FD8  55                    PUSH   bp ; STACK_PUSH
015FD9  8B EC                 MOV    bp, sp ; MOV
015FDB  1E                    PUSH   ds ; STACK_PUSH
015FDC  8E 06 6E 45           MOV    es, word ptr [0x456e] ; GLOBAL_LOAD
015FE0  26 8B 1E 2C 00        MOV    bx, word ptr es:[0x2c] ; GLOBAL_LOAD
015FE5  8E C3                 MOV    es, bx ; MOV
