; ============================================================================
; func_02D1DD_unknown
; Region   : load_image
; Bytes    : file 0x02D1DD..0x02D1ED  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D1DD  55                    PUSH   bp                           ; UNKNOWN
02D1DE  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D1E0  68 2E 1E              PUSH   0x1e2e                       ; UNKNOWN
02D1E3  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D1E6  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
02D1EB  C9                    LEAVE                               ; UNKNOWN
02D1EC  CB                    RETF                                ; UNKNOWN
