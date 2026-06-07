; ============================================================================
; func_0151A4_unknown
; Region   : load_image
; Bytes    : file 0x0151A4..0x0151FD  (89 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0151A4  C8 50 00 00           ENTER  0x50, 0                      ; UNKNOWN
0151A8  56                    PUSH   si                           ; UNKNOWN
0151A9  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
0151AD  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0151B0  50                    PUSH   ax                           ; UNKNOWN
0151B1  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
0151B6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0151B9  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0151BC  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0151BF  50                    PUSH   ax                           ; UNKNOWN
0151C0  9A 7D 04 13 24        LCALL  0x2413, 0x47d                ; UNKNOWN
0151C5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0151C8  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0151CB  50                    PUSH   ax                           ; UNKNOWN
0151CC  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
0151D1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0151D4  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
0151D7  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
0151D9  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
0151DC  FF 34                 PUSH   word ptr [si]                ; UNKNOWN
0151DE  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0151E1  16                    PUSH   ss                           ; UNKNOWN
0151E2  50                    PUSH   ax                           ; UNKNOWN
0151E3  9A 55 02 13 24        LCALL  0x2413, 0x255                ; UNKNOWN
0151E8  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0151EB  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
0151EF  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
0151F2  2A E4                 SUB    ah, ah                       ; UNKNOWN
0151F4  40                    INC    ax                           ; UNKNOWN
0151F5  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
0151F8  01 07                 ADD    word ptr [bx], ax            ; UNKNOWN
0151FA  5E                    POP    si                           ; UNKNOWN
0151FB  C9                    LEAVE                               ; UNKNOWN
0151FC  CB                    RETF                                ; UNKNOWN
