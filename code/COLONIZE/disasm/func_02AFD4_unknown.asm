; ============================================================================
; func_02AFD4_unknown
; Region   : load_image
; Bytes    : file 0x02AFD4..0x02AFF0  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AFD4  55                    PUSH   bp                           ; UNKNOWN
02AFD5  8B EC                 MOV    bp, sp                       ; UNKNOWN
02AFD7  9A 02 00 9A 5B        LCALL  0x5b9a, 2                    ; UNKNOWN
02AFDC  0B C0                 OR     ax, ax                       ; UNKNOWN
02AFDE  74 0E                 JE     0x2afee                      ; UNKNOWN
02AFE0  9A 14 00 9A 5B        LCALL  0x5b9a, 0x14                 ; UNKNOWN
02AFE5  9A 02 00 9A 5B        LCALL  0x5b9a, 2                    ; UNKNOWN
02AFEA  0B C0                 OR     ax, ax                       ; UNKNOWN
02AFEC  75 F2                 JNE    0x2afe0                      ; UNKNOWN
02AFEE  C9                    LEAVE                               ; UNKNOWN
02AFEF  CB                    RETF                                ; UNKNOWN
