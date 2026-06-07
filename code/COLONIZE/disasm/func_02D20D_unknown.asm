; ============================================================================
; func_02D20D_unknown
; Region   : load_image
; Bytes    : file 0x02D20D..0x02D21D  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D20D  55                    PUSH   bp                           ; UNKNOWN
02D20E  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D210  68 34 1E              PUSH   0x1e34                       ; UNKNOWN
02D213  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D216  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
02D21B  C9                    LEAVE                               ; UNKNOWN
02D21C  CB                    RETF                                ; UNKNOWN
