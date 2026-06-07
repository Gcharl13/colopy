; ============================================================================
; func_019BD3_unknown
; Region   : load_image
; Bytes    : file 0x019BD3..0x019BF3  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

019BD3  55                    PUSH   bp                           ; UNKNOWN
019BD4  8B EC                 MOV    bp, sp                       ; UNKNOWN
019BD6  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
019BD9  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
019BDC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
019BDF  9A 49 02 2B 3E        LCALL  0x3e2b, 0x249                ; UNKNOWN
019BE4  8B E5                 MOV    sp, bp                       ; UNKNOWN
019BE6  6A 00                 PUSH   0                            ; UNKNOWN
019BE8  6A 00                 PUSH   0                            ; UNKNOWN
019BEA  6A 01                 PUSH   1                            ; UNKNOWN
019BEC  9A D0 02 2B 3E        LCALL  0x3e2b, 0x2d0                ; UNKNOWN
019BF1  C9                    LEAVE                               ; UNKNOWN
019BF2  CB                    RETF                                ; UNKNOWN
