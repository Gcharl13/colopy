; ============================================================================
; func_02D1ED_unknown
; Region   : load_image
; Bytes    : file 0x02D1ED..0x02D1FD  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D1ED  55                    PUSH   bp                           ; UNKNOWN
02D1EE  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D1F0  68 30 1E              PUSH   0x1e30                       ; UNKNOWN
02D1F3  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D1F6  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
02D1FB  C9                    LEAVE                               ; UNKNOWN
02D1FC  CB                    RETF                                ; UNKNOWN
