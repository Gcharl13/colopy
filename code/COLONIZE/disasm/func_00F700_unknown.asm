; ============================================================================
; func_00F700_unknown
; Region   : load_image
; Bytes    : file 0x00F700..0x00F8C9  (457 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F700  C8 A8 00 00           ENTER  0xa8, 0                      ; UNKNOWN
00F704  6A FF                 PUSH   -1                           ; UNKNOWN
00F706  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F709  50                    PUSH   ax                           ; UNKNOWN
00F70A  0E                    PUSH   cs                           ; UNKNOWN
00F70B  E8 F2 FE              CALL   0xf600                       ; UNKNOWN
00F70E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F711  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F714  16                    PUSH   ss                           ; UNKNOWN
00F715  50                    PUSH   ax                           ; UNKNOWN
00F716  8D 8E 60 FF           LEA    cx, [bp - 0xa0]              ; UNKNOWN
00F71A  16                    PUSH   ss                           ; UNKNOWN
00F71B  51                    PUSH   cx                           ; UNKNOWN
00F71C  E8 67 FE              CALL   0xf586                       ; UNKNOWN
00F71F  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00F722  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F726  50                    PUSH   ax                           ; UNKNOWN
00F727  9A 00 00 B2 00        LCALL  0xb2, 0                      ; UNKNOWN
00F72C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00F72F  89 86 5C FF           MOV    word ptr [bp - 0xa4], ax     ; UNKNOWN
00F733  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00F736  50                    PUSH   ax                           ; UNKNOWN
00F737  9A 9E 0D 65 5F        LCALL  0x5f65, 0xd9e                ; UNKNOWN
00F73C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00F73F  1E                    PUSH   ds                           ; UNKNOWN
00F740  50                    PUSH   ax                           ; UNKNOWN
00F741  1E                    PUSH   ds                           ; UNKNOWN
00F742  68 40 3F              PUSH   0x3f40                       ; UNKNOWN
00F745  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
00F74A  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00F74D  8B 86 5C FF           MOV    ax, word ptr [bp - 0xa4]     ; UNKNOWN
00F751  0B C0                 OR     ax, ax                       ; UNKNOWN
00F753  74 13                 JE     0xf768                       ; UNKNOWN
00F755  48                    DEC    ax                           ; UNKNOWN
00F756  48                    DEC    ax                           ; UNKNOWN
00F757  75 03                 JNE    0xf75c                       ; UNKNOWN
00F759  E9 5C 01              JMP    0xf8b8                       ; UNKNOWN
00F75C  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
00F760  8D 06 1A 07           LEA    ax, [0x71a]                  ; UNKNOWN
00F764  E9 59 01              JMP    0xf8c0                       ; UNKNOWN
00F767  90                    NOP                                 ; UNKNOWN
00F768  C7 86 5E FF FF FF     MOV    word ptr [bp - 0xa2], 0xffff ; UNKNOWN
00F76E  C7 86 5A FF 00 00     MOV    word ptr [bp - 0xa6], 0      ; UNKNOWN
00F774  C7 86 58 FF B7 C0     MOV    word ptr [bp - 0xa8], 0xc0b7 ; UNKNOWN
00F77A  81 BE 58 FF 87 C1     CMP    word ptr [bp - 0xa8], 0xc187 ; UNKNOWN
00F780  73 21                 JAE    0xf7a3                       ; UNKNOWN
00F782  8B 9E 58 FF           MOV    bx, word ptr [bp - 0xa8]     ; UNKNOWN
00F786  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
00F789  75 08                 JNE    0xf793                       ; UNKNOWN
00F78B  8B 86 5A FF           MOV    ax, word ptr [bp - 0xa6]     ; UNKNOWN
00F78F  89 86 5E FF           MOV    word ptr [bp - 0xa2], ax     ; UNKNOWN
00F793  83 86 58 FF 34        ADD    word ptr [bp - 0xa8], 0x34   ; UNKNOWN
00F798  FF 86 5A FF           INC    word ptr [bp - 0xa6]         ; UNKNOWN
00F79C  83 BE 5E FF 00        CMP    word ptr [bp - 0xa2], 0      ; UNKNOWN
00F7A1  7C D7                 JL     0xf77a                       ; UNKNOWN
00F7A3  83 BE 5E FF 00        CMP    word ptr [bp - 0xa2], 0      ; UNKNOWN
00F7A8  7D 06                 JGE    0xf7b0                       ; UNKNOWN
00F7AA  C7 86 5E FF 00 00     MOV    word ptr [bp - 0xa2], 0      ; UNKNOWN
00F7B0  C6 86 60 FF 00        MOV    byte ptr [bp - 0xa0], 0      ; UNKNOWN
00F7B5  8A 1E 1E 3E           MOV    bl, byte ptr [0x3e1e]        ; UNKNOWN
00F7B9  2A FF                 SUB    bh, bh                       ; UNKNOWN
00F7BB  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00F7BD  FF B7 E9 37           PUSH   word ptr [bx + 0x37e9]       ; UNKNOWN
00F7C1  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F7C5  50                    PUSH   ax                           ; UNKNOWN
00F7C6  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
00F7CB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F7CE  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F7D2  50                    PUSH   ax                           ; UNKNOWN
00F7D3  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
00F7D8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00F7DB  6B 86 5E FF 34        IMUL   ax, word ptr [bp - 0xa2], 0x34 ; UNKNOWN
00F7E0  05 86 C0              ADD    ax, 0xc086                   ; UNKNOWN
00F7E3  1E                    PUSH   ds                           ; UNKNOWN
00F7E4  50                    PUSH   ax                           ; UNKNOWN
00F7E5  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F7E9  16                    PUSH   ss                           ; UNKNOWN
00F7EA  50                    PUSH   ax                           ; UNKNOWN
00F7EB  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
00F7F0  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00F7F3  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F7F7  50                    PUSH   ax                           ; UNKNOWN
00F7F8  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
00F7FD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00F800  FF 36 20 33           PUSH   word ptr [0x3320]            ; UNKNOWN
00F804  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F808  50                    PUSH   ax                           ; UNKNOWN
00F809  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
00F80E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F811  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F815  50                    PUSH   ax                           ; UNKNOWN
00F816  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
00F81B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00F81E  8B 9E 5E FF           MOV    bx, word ptr [bp - 0xa2]     ; UNKNOWN
00F822  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00F824  FF B7 F3 37           PUSH   word ptr [bx + 0x37f3]       ; UNKNOWN
00F828  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F82C  50                    PUSH   ax                           ; UNKNOWN
00F82D  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
00F832  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00F835  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F839  50                    PUSH   ax                           ; UNKNOWN
00F83A  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
00F83F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00F842  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F846  50                    PUSH   ax                           ; UNKNOWN
00F847  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
00F84C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00F84F  8B 1E 04 3E           MOV    bx, word ptr [0x3e04]        ; UNKNOWN
00F853  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00F855  FF B7 D9 3D           PUSH   word ptr [bx + 0x3dd9]       ; UNKNOWN
00F859  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
00F85E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00F861  52                    PUSH   dx                           ; UNKNOWN
00F862  50                    PUSH   ax                           ; UNKNOWN
00F863  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F867  16                    PUSH   ss                           ; UNKNOWN
00F868  50                    PUSH   ax                           ; UNKNOWN
00F869  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
00F86E  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00F871  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F875  50                    PUSH   ax                           ; UNKNOWN
00F876  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
00F87B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00F87E  FF 36 02 3E           PUSH   word ptr [0x3e02]            ; UNKNOWN
00F882  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F886  16                    PUSH   ss                           ; UNKNOWN
00F887  50                    PUSH   ax                           ; UNKNOWN
00F888  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
00F88D  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00F890  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F894  50                    PUSH   ax                           ; UNKNOWN
00F895  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
00F89A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00F89D  8D 86 60 FF           LEA    ax, [bp - 0xa0]              ; UNKNOWN
00F8A1  16                    PUSH   ss                           ; UNKNOWN
00F8A2  50                    PUSH   ax                           ; UNKNOWN
00F8A3  6A 01                 PUSH   1                            ; UNKNOWN
00F8A5  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
00F8AA  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00F8AD  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
00F8B1  8D 06 09 07           LEA    ax, [0x709]                  ; UNKNOWN
00F8B5  EB 09                 JMP    0xf8c0                       ; UNKNOWN
00F8B7  90                    NOP                                 ; UNKNOWN
00F8B8  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
00F8BC  8D 06 12 07           LEA    ax, [0x712]                  ; UNKNOWN
00F8C0  2B D2                 SUB    dx, dx                       ; UNKNOWN
00F8C2  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
00F8C7  C9                    LEAVE                               ; UNKNOWN
00F8C8  CB                    RETF                                ; UNKNOWN
