; ============================================================================
; func_02ED6D_unknown
; Region   : load_image
; Bytes    : file 0x02ED6D..0x02EDAC  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02ED6D  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02ED71  2B C0                 SUB    ax, ax                       ; UNKNOWN
02ED73  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02ED76  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02ED79  EB 26                 JMP    0x2eda1                      ; UNKNOWN
02ED7B  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
02ED7E  50                    PUSH   ax                           ; UNKNOWN
02ED7F  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
02ED82  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
02ED86  98                    CWDE                                ; UNKNOWN
02ED87  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
02ED8A  50                    PUSH   ax                           ; UNKNOWN
02ED8B  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
02ED8F  98                    CWDE                                ; UNKNOWN
02ED90  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
02ED93  50                    PUSH   ax                           ; UNKNOWN
02ED94  0E                    PUSH   cs                           ; UNKNOWN
02ED95  E8 9D FF              CALL   0x2ed35                      ; UNKNOWN
02ED98  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02ED9B  01 46 FE              ADD    word ptr [bp - 2], ax        ; UNKNOWN
02ED9E  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02EDA1  83 7E FC 08           CMP    word ptr [bp - 4], 8         ; UNKNOWN
02EDA5  7C D4                 JL     0x2ed7b                      ; UNKNOWN
02EDA7  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02EDAA  C9                    LEAVE                               ; UNKNOWN
02EDAB  CB                    RETF                                ; UNKNOWN
