; ============================================================================
; func_069466_unknown
; Region   : load_image
; Bytes    : file 0x069466..0x06947C  (22 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069466  55                    PUSH   bp                           ; UNKNOWN
069467  8B EC                 MOV    bp, sp                       ; UNKNOWN
069469  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
06946C  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
06946F  0B D2                 OR     dx, dx                       ; UNKNOWN
069471  7D 07                 JGE    0x6947a                      ; UNKNOWN
069473  F7 D8                 NEG    ax                           ; UNKNOWN
069475  83 D2 00              ADC    dx, 0                        ; UNKNOWN
069478  F7 DA                 NEG    dx                           ; UNKNOWN
06947A  5D                    POP    bp                           ; UNKNOWN
06947B  CB                    RETF                                ; UNKNOWN
