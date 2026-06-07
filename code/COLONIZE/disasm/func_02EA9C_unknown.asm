; ============================================================================
; func_02EA9C_unknown
; Region   : load_image
; Bytes    : file 0x02EA9C..0x02EAC3  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EA9C  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02EAA0  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
02EAA5  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02EAA8  0E                    PUSH   cs                           ; UNKNOWN
02EAA9  E8 B7 FF              CALL   0x2ea63                      ; UNKNOWN
02EAAC  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02EAAF  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
02EAB2  50                    PUSH   ax                           ; UNKNOWN
02EAB3  0E                    PUSH   cs                           ; UNKNOWN
02EAB4  E8 C1 EE              CALL   0x2d978                      ; UNKNOWN
02EAB7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02EABA  0B C0                 OR     ax, ax                       ; UNKNOWN
02EABC  74 1B                 JE     0x2ead9                      ; UNKNOWN
02EABE  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02EAC1  8B C3                 MOV    ax, bx                       ; UNKNOWN
