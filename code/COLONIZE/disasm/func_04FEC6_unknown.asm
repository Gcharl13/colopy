; ============================================================================
; func_04FEC6_unknown
; Region   : load_image
; Bytes    : file 0x04FEC6..0x04FEE1  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04FEC6  55                    PUSH   bp                           ; UNKNOWN
04FEC7  8B EC                 MOV    bp, sp                       ; UNKNOWN
04FEC9  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04FECC  C1 E3 06              SHL    bx, 6                        ; UNKNOWN
04FECF  03 5E 08              ADD    bx, word ptr [bp + 8]        ; UNKNOWN
04FED2  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
04FED5  C6 87 2A C7 FF        MOV    byte ptr [bx - 0x38d6], 0xff ; UNKNOWN
04FEDA  C6 87 2B C7 00        MOV    byte ptr [bx - 0x38d5], 0    ; UNKNOWN
04FEDF  C9                    LEAVE                               ; UNKNOWN
04FEE0  CB                    RETF                                ; UNKNOWN
