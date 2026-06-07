; ============================================================================
; func_063472_unknown
; Region   : load_image
; Bytes    : file 0x063472..0x063494  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063472  55                    PUSH   bp                           ; UNKNOWN
063473  8B EC                 MOV    bp, sp                       ; UNKNOWN
063475  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
063478  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
06347B  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
06347E  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
063481  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
063484  50                    PUSH   ax                           ; UNKNOWN
063485  2B C0                 SUB    ax, ax                       ; UNKNOWN
063487  99                    CDQ                                 ; UNKNOWN
063488  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
06348B  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
063490  C9                    LEAVE                               ; UNKNOWN
063491  CA 08 00              RETF   8                            ; UNKNOWN
