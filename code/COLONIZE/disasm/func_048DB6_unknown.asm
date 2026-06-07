; ============================================================================
; func_048DB6_unknown
; Region   : load_image
; Bytes    : file 0x048DB6..0x048DD6  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048DB6  55                    PUSH   bp                           ; UNKNOWN
048DB7  8B EC                 MOV    bp, sp                       ; UNKNOWN
048DB9  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
048DBC  68 44 29              PUSH   0x2944                       ; UNKNOWN
048DBF  68 4A 29              PUSH   0x294a                       ; UNKNOWN
048DC2  9A 0E 02 09 45        LCALL  0x4509, 0x20e                ; UNKNOWN
048DC7  8B E5                 MOV    sp, bp                       ; UNKNOWN
048DC9  68 42 C6              PUSH   0xc642                       ; UNKNOWN
048DCC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
048DCF  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
048DD4  C9                    LEAVE                               ; UNKNOWN
048DD5  CB                    RETF                                ; UNKNOWN
