; ============================================================================
; func_024D39_unknown
; Region   : load_image
; Bytes    : file 0x024D39..0x024D54  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024D39  55                    PUSH   bp                           ; UNKNOWN
024D3A  8B EC                 MOV    bp, sp                       ; UNKNOWN
024D3C  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
024D3F  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
024D42  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
024D45  C1 E0 06              SHL    ax, 6                        ; UNKNOWN
024D48  05 40 3F              ADD    ax, 0x3f40                   ; UNKNOWN
024D4B  1E                    PUSH   ds                           ; UNKNOWN
024D4C  50                    PUSH   ax                           ; UNKNOWN
024D4D  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
024D52  C9                    LEAVE                               ; UNKNOWN
024D53  CB                    RETF                                ; UNKNOWN
