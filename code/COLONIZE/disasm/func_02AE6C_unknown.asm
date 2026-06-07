; ============================================================================
; func_02AE6C_unknown
; Region   : load_image
; Bytes    : file 0x02AE6C..0x02AE8D  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AE6C  55                    PUSH   bp                           ; UNKNOWN
02AE6D  8B EC                 MOV    bp, sp                       ; UNKNOWN
02AE6F  1E                    PUSH   ds                           ; UNKNOWN
02AE70  68 A2 40              PUSH   0x40a2                       ; UNKNOWN
02AE73  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02AE76  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02AE79  1E                    PUSH   ds                           ; UNKNOWN
02AE7A  68 F4 1C              PUSH   0x1cf4                       ; UNKNOWN
02AE7D  B8 09 00              MOV    ax, 9                        ; UNKNOWN
02AE80  9A 06 00 7A 5B        LCALL  0x5b7a, 6                    ; UNKNOWN
02AE85  C7 06 B4 40 00 00     MOV    word ptr [0x40b4], 0         ; UNKNOWN
02AE8B  C9                    LEAVE                               ; UNKNOWN
02AE8C  CB                    RETF                                ; UNKNOWN
