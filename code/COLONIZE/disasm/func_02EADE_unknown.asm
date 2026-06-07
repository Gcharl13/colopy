; ============================================================================
; func_02EADE_unknown
; Region   : load_image
; Bytes    : file 0x02EADE..0x02EAFA  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EADE  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02EAE2  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
02EAE7  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02EAEA  0E                    PUSH   cs                           ; UNKNOWN
02EAEB  E8 8A EE              CALL   0x2d978                      ; UNKNOWN
02EAEE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02EAF1  0B C0                 OR     ax, ax                       ; UNKNOWN
02EAF3  74 26                 JE     0x2eb1b                      ; UNKNOWN
02EAF5  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02EAF8  8B C3                 MOV    ax, bx                       ; UNKNOWN
