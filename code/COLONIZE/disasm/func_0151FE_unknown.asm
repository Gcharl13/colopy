; ============================================================================
; func_0151FE_unknown
; Region   : load_image
; Bytes    : file 0x0151FE..0x01525D  (95 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0151FE  C8 50 00 00           ENTER  0x50, 0                      ; UNKNOWN
015202  56                    PUSH   si                           ; UNKNOWN
015203  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
015207  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
01520A  50                    PUSH   ax                           ; UNKNOWN
01520B  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
015210  83 C4 02              ADD    sp, 2                        ; UNKNOWN
015213  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
015216  D1 E3                 SHL    bx, 1                        ; UNKNOWN
015218  FF B7 F0 32           PUSH   word ptr [bx + 0x32f0]       ; UNKNOWN
01521C  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
01521F  50                    PUSH   ax                           ; UNKNOWN
015220  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
015225  83 C4 04              ADD    sp, 4                        ; UNKNOWN
015228  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
01522B  50                    PUSH   ax                           ; UNKNOWN
01522C  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
015231  83 C4 02              ADD    sp, 2                        ; UNKNOWN
015234  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
015237  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
015239  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
01523C  FF 34                 PUSH   word ptr [si]                ; UNKNOWN
01523E  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
015241  16                    PUSH   ss                           ; UNKNOWN
015242  50                    PUSH   ax                           ; UNKNOWN
015243  9A 55 02 13 24        LCALL  0x2413, 0x255                ; UNKNOWN
015248  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01524B  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
01524F  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
015252  2A E4                 SUB    ah, ah                       ; UNKNOWN
015254  40                    INC    ax                           ; UNKNOWN
015255  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
015258  01 07                 ADD    word ptr [bx], ax            ; UNKNOWN
01525A  5E                    POP    si                           ; UNKNOWN
01525B  C9                    LEAVE                               ; UNKNOWN
01525C  CB                    RETF                                ; UNKNOWN
