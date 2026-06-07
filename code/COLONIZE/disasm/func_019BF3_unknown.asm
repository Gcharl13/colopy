; ============================================================================
; func_019BF3_unknown
; Region   : load_image
; Bytes    : file 0x019BF3..0x019C06  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

019BF3  55                    PUSH   bp                           ; UNKNOWN
019BF4  8B EC                 MOV    bp, sp                       ; UNKNOWN
019BF6  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
019BF9  D1 E3                 SHL    bx, 1                        ; UNKNOWN
019BFB  FF B7 AD 3B           PUSH   word ptr [bx + 0x3bad]       ; UNKNOWN
019BFF  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
019C04  C9                    LEAVE                               ; UNKNOWN
019C05  CB                    RETF                                ; UNKNOWN
