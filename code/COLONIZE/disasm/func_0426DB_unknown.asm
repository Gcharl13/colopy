; ============================================================================
; func_0426DB_unknown
; Region   : load_image
; Bytes    : file 0x0426DB..0x04270B  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0426DB  C8 60 00 00           ENTER  0x60, 0                      ; UNKNOWN
0426DF  56                    PUSH   si                           ; UNKNOWN
0426E0  A1 86 73              MOV    ax, word ptr [0x7386]        ; UNKNOWN
0426E3  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
0426E6  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0426E9  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
0426EE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0426F1  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
0426F5  7C 3B                 JL     0x42732                      ; UNKNOWN
0426F7  6A 01                 PUSH   1                            ; UNKNOWN
0426F9  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0426FC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0426FF  0E                    PUSH   cs                           ; UNKNOWN
042700  E8 9D FC              CALL   0x423a0                      ; UNKNOWN
042703  83 C4 06              ADD    sp, 6                        ; UNKNOWN
042706  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
042709  8B C3                 MOV    ax, bx                       ; UNKNOWN
