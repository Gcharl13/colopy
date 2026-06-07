; ============================================================================
; func_047436_unknown
; Region   : load_image
; Bytes    : file 0x047436..0x047459  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

047436  55                    PUSH   bp                           ; UNKNOWN
047437  8B EC                 MOV    bp, sp                       ; UNKNOWN
047439  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04743C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04743F  1E                    PUSH   ds                           ; UNKNOWN
047440  68 EA C5              PUSH   0xc5ea                       ; UNKNOWN
047443  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
047448  8B E5                 MOV    sp, bp                       ; UNKNOWN
04744A  1E                    PUSH   ds                           ; UNKNOWN
04744B  68 E8 28              PUSH   0x28e8                       ; UNKNOWN
04744E  1E                    PUSH   ds                           ; UNKNOWN
04744F  68 EA C5              PUSH   0xc5ea                       ; UNKNOWN
047452  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
047457  C9                    LEAVE                               ; UNKNOWN
047458  CB                    RETF                                ; UNKNOWN
