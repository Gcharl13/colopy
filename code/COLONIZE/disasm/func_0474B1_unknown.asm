; ============================================================================
; func_0474B1_unknown
; Region   : load_image
; Bytes    : file 0x0474B1..0x0474D7  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0474B1  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
0474B5  C6 46 EC 00           MOV    byte ptr [bp - 0x14], 0      ; UNKNOWN
0474B9  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0474BC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0474BF  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
0474C2  16                    PUSH   ss                           ; UNKNOWN
0474C3  50                    PUSH   ax                           ; UNKNOWN
0474C4  9A F1 01 13 24        LCALL  0x2413, 0x1f1                ; UNKNOWN
0474C9  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0474CC  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
0474CF  16                    PUSH   ss                           ; UNKNOWN
0474D0  50                    PUSH   ax                           ; UNKNOWN
0474D1  0E                    PUSH   cs                           ; UNKNOWN
0474D2  E8 61 FF              CALL   0x47436                      ; UNKNOWN
0474D5  C9                    LEAVE                               ; UNKNOWN
0474D6  CB                    RETF                                ; UNKNOWN
