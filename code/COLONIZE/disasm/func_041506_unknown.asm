; ============================================================================
; func_041506_unknown
; Region   : load_image
; Bytes    : file 0x041506..0x041519  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041506  55                    PUSH   bp                           ; UNKNOWN
041507  8B EC                 MOV    bp, sp                       ; UNKNOWN
041509  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04150C  D1 E3                 SHL    bx, 1                        ; UNKNOWN
04150E  FF B7 FA 32           PUSH   word ptr [bx + 0x32fa]       ; UNKNOWN
041512  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
041517  C9                    LEAVE                               ; UNKNOWN
041518  CB                    RETF                                ; UNKNOWN
