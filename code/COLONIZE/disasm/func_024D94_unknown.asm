; ============================================================================
; func_024D94_unknown
; Region   : load_image
; Bytes    : file 0x024D94..0x024DAD  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024D94  55                    PUSH   bp                           ; UNKNOWN
024D95  8B EC                 MOV    bp, sp                       ; UNKNOWN
024D97  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
024D9A  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
024D9D  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
024DA0  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
024DA3  89 87 2A 3F           MOV    word ptr [bx + 0x3f2a], ax   ; UNKNOWN
024DA7  89 97 2C 3F           MOV    word ptr [bx + 0x3f2c], dx   ; UNKNOWN
024DAB  C9                    LEAVE                               ; UNKNOWN
024DAC  CB                    RETF                                ; UNKNOWN
