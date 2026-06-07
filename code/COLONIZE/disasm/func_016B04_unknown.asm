; ============================================================================
; func_016B04_unknown
; Region   : load_image
; Bytes    : file 0x016B04..0x016B38  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016B04  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
016B08  A1 36 08              MOV    ax, word ptr [0x836]         ; UNKNOWN
016B0B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
016B0E  0B C0                 OR     ax, ax                       ; UNKNOWN
016B10  7C 24                 JL     0x16b36                      ; UNKNOWN
016B12  6A FF                 PUSH   -1                           ; UNKNOWN
016B14  0E                    PUSH   cs                           ; UNKNOWN
016B15  E8 20 00              CALL   0x16b38                      ; UNKNOWN
016B18  83 C4 02              ADD    sp, 2                        ; UNKNOWN
016B1B  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
016B1E  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
016B21  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
016B24  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
016B27  89 87 98 D3           MOV    word ptr [bx - 0x2c68], ax   ; UNKNOWN
016B2B  89 97 9A D3           MOV    word ptr [bx - 0x2c66], dx   ; UNKNOWN
016B2F  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
016B32  0E                    PUSH   cs                           ; UNKNOWN
016B33  E8 02 00              CALL   0x16b38                      ; UNKNOWN
016B36  C9                    LEAVE                               ; UNKNOWN
016B37  CB                    RETF                                ; UNKNOWN
