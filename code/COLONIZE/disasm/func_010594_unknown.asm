; ============================================================================
; func_010594_unknown
; Region   : load_image
; Bytes    : file 0x010594..0x01060D  (121 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010594  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
010598  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
01059D  83 3E 12 3E 54        CMP    word ptr [0x3e12], 0x54      ; UNKNOWN
0105A2  7C 03                 JL     0x105a7                      ; UNKNOWN
0105A4  E9 8F 00              JMP    0x10636                      ; UNKNOWN
0105A7  A1 12 3E              MOV    ax, word ptr [0x3e12]        ; UNKNOWN
0105AA  FF 06 12 3E           INC    word ptr [0x3e12]            ; UNKNOWN
0105AE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0105B1  50                    PUSH   ax                           ; UNKNOWN
0105B2  9A 32 00 BA 33        LCALL  0x33ba, 0x32                 ; UNKNOWN
0105B7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0105BA  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0105BD  83 E8 04              SUB    ax, 4                        ; UNKNOWN
0105C0  50                    PUSH   ax                           ; UNKNOWN
0105C1  9A 06 00 BA 33        LCALL  0x33ba, 6                    ; UNKNOWN
0105C6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0105C9  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
0105CC  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
0105D0  88 47 02              MOV    byte ptr [bx + 2], al        ; UNKNOWN
0105D3  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
0105D6  88 07                 MOV    byte ptr [bx], al            ; UNKNOWN
0105D8  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
0105DB  88 47 01              MOV    byte ptr [bx + 1], al        ; UNKNOWN
0105DE  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0105E1  0E                    PUSH   cs                           ; UNKNOWN
0105E2  E8 77 FF              CALL   0x1055c                      ; UNKNOWN
0105E5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0105E8  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
0105EC  88 47 04              MOV    byte ptr [bx + 4], al        ; UNKNOWN
0105EF  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
0105F3  C6 47 05 FF           MOV    byte ptr [bx + 5], 0xff      ; UNKNOWN
0105F7  C6 47 06 00           MOV    byte ptr [bx + 6], 0         ; UNKNOWN
0105FB  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0105FE  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
010601  9A 20 01 C9 33        LCALL  0x33c9, 0x120                ; UNKNOWN
010606  83 C4 04              ADD    sp, 4                        ; UNKNOWN
010609  8E C2                 MOV    es, dx                       ; UNKNOWN
01060B  8B D8                 MOV    bx, ax                       ; UNKNOWN
