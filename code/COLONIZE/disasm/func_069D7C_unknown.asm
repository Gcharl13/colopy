; ============================================================================
; func_069D7C_unknown
; Region   : load_image
; Bytes    : file 0x069D7C..0x069D8B  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069D7C  55                    PUSH   bp                           ; UNKNOWN
069D7D  8B EC                 MOV    bp, sp                       ; UNKNOWN
069D7F  1E                    PUSH   ds                           ; UNKNOWN
069D80  8E 06 3E 12           MOV    es, word ptr [0x123e]        ; UNKNOWN
069D84  26 8B 1E 2C 00        MOV    bx, word ptr es:[0x2c]       ; UNKNOWN
069D89  8E C3                 MOV    es, bx                       ; UNKNOWN
