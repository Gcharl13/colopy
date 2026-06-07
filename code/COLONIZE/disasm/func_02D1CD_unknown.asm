; ============================================================================
; func_02D1CD_unknown
; Region   : load_image
; Bytes    : file 0x02D1CD..0x02D1DD  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D1CD  55                    PUSH   bp                           ; UNKNOWN
02D1CE  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D1D0  68 2C 1E              PUSH   0x1e2c                       ; UNKNOWN
02D1D3  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D1D6  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
02D1DB  C9                    LEAVE                               ; UNKNOWN
02D1DC  CB                    RETF                                ; UNKNOWN
