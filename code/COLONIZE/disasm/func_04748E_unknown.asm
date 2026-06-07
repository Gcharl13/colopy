; ============================================================================
; func_04748E_unknown
; Region   : load_image
; Bytes    : file 0x04748E..0x0474B1  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04748E  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
047492  6A 0A                 PUSH   0xa                          ; UNKNOWN
047494  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
047497  50                    PUSH   ax                           ; UNKNOWN
047498  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04749B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04749E  9A A6 08 65 5F        LCALL  0x5f65, 0x8a6                ; UNKNOWN
0474A3  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0474A6  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
0474A9  16                    PUSH   ss                           ; UNKNOWN
0474AA  50                    PUSH   ax                           ; UNKNOWN
0474AB  0E                    PUSH   cs                           ; UNKNOWN
0474AC  E8 87 FF              CALL   0x47436                      ; UNKNOWN
0474AF  C9                    LEAVE                               ; UNKNOWN
0474B0  CB                    RETF                                ; UNKNOWN
