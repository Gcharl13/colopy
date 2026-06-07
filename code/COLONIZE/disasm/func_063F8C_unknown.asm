; ============================================================================
; func_063F8C_unknown
; Region   : load_image
; Bytes    : file 0x063F8C..0x063FB8  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063F8C  C8 50 00 00           ENTER  0x50, 0                      ; UNKNOWN
063F90  53                    PUSH   bx                           ; UNKNOWN
063F91  56                    PUSH   si                           ; UNKNOWN
063F92  8B F3                 MOV    si, bx                       ; UNKNOWN
063F94  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
063F97  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
063F9A  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
063F9D  16                    PUSH   ss                           ; UNKNOWN
063F9E  50                    PUSH   ax                           ; UNKNOWN
063F9F  0E                    PUSH   cs                           ; UNKNOWN
063FA0  E8 A0 FF              CALL   0x63f43                      ; UNKNOWN
063FA3  83 C4 08              ADD    sp, 8                        ; UNKNOWN
063FA6  56                    PUSH   si                           ; UNKNOWN
063FA7  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
063FAA  50                    PUSH   ax                           ; UNKNOWN
063FAB  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
063FB0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
063FB3  5E                    POP    si                           ; UNKNOWN
063FB4  C9                    LEAVE                               ; UNKNOWN
063FB5  CA 04 00              RETF   4                            ; UNKNOWN
