; ============================================================================
; func_02D21D_unknown
; Region   : load_image
; Bytes    : file 0x02D21D..0x02D237  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D21D  55                    PUSH   bp                           ; UNKNOWN
02D21E  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D220  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D223  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
02D228  8B E5                 MOV    sp, bp                       ; UNKNOWN
02D22A  52                    PUSH   dx                           ; UNKNOWN
02D22B  50                    PUSH   ax                           ; UNKNOWN
02D22C  1E                    PUSH   ds                           ; UNKNOWN
02D22D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D230  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
02D235  C9                    LEAVE                               ; UNKNOWN
02D236  CB                    RETF                                ; UNKNOWN
