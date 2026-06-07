; ============================================================================
; func_048FE7_unknown
; Region   : load_image
; Bytes    : file 0x048FE7..0x0491FC  (533 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048FE7  C8 66 00 00           ENTER  0x66, 0                      ; UNKNOWN
048FEB  56                    PUSH   si                           ; UNKNOWN
048FEC  0E                    PUSH   cs                           ; UNKNOWN
048FED  E8 4D FE              CALL   0x48e3d                      ; UNKNOWN
048FF0  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
048FF3  2A E4                 SUB    ah, ah                       ; UNKNOWN
048FF5  50                    PUSH   ax                           ; UNKNOWN
048FF6  6A 05                 PUSH   5                            ; UNKNOWN
048FF8  68 40 01              PUSH   0x140                        ; UNKNOWN
048FFB  6A 00                 PUSH   0                            ; UNKNOWN
048FFD  FF 36 D2 33           PUSH   word ptr [0x33d2]            ; UNKNOWN
049001  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
049006  83 C4 02              ADD    sp, 2                        ; UNKNOWN
049009  52                    PUSH   dx                           ; UNKNOWN
04900A  50                    PUSH   ax                           ; UNKNOWN
04900B  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
049010  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
049013  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
049017  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04901A  2A E4                 SUB    ah, ah                       ; UNKNOWN
04901C  83 C0 07              ADD    ax, 7                        ; UNKNOWN
04901F  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
049022  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
049026  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
049029  50                    PUSH   ax                           ; UNKNOWN
04902A  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
04902F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
049032  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
049035  D1 E3                 SHL    bx, 1                        ; UNKNOWN
049037  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
04903B  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
04903E  50                    PUSH   ax                           ; UNKNOWN
04903F  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
049044  83 C4 04              ADD    sp, 4                        ; UNKNOWN
049047  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
04904A  50                    PUSH   ax                           ; UNKNOWN
04904B  9A 4D 00 13 24        LCALL  0x2413, 0x4d                 ; UNKNOWN
049050  83 C4 02              ADD    sp, 2                        ; UNKNOWN
049053  6A 00                 PUSH   0                            ; UNKNOWN
049055  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
049058  50                    PUSH   ax                           ; UNKNOWN
049059  0E                    PUSH   cs                           ; UNKNOWN
04905A  E8 59 FD              CALL   0x48db6                      ; UNKNOWN
04905D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
049060  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
049063  50                    PUSH   ax                           ; UNKNOWN
049064  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
049069  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04906C  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
04906F  2A E4                 SUB    ah, ah                       ; UNKNOWN
049071  50                    PUSH   ax                           ; UNKNOWN
049072  FF 76 A8              PUSH   word ptr [bp - 0x58]         ; UNKNOWN
049075  68 40 01              PUSH   0x140                        ; UNKNOWN
049078  6A 00                 PUSH   0                            ; UNKNOWN
04907A  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
04907D  16                    PUSH   ss                           ; UNKNOWN
04907E  50                    PUSH   ax                           ; UNKNOWN
04907F  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
049084  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
049087  C7 46 AA 0A 00        MOV    word ptr [bp - 0x56], 0xa    ; UNKNOWN
04908C  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
049090  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
049093  2A E4                 SUB    ah, ah                       ; UNKNOWN
049095  83 C0 0E              ADD    ax, 0xe                      ; UNKNOWN
049098  01 46 A8              ADD    word ptr [bp - 0x58], ax     ; UNKNOWN
04909B  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0490A0  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0490A4  75 15                 JNE    0x490bb                      ; UNKNOWN
0490A6  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0490A9  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
0490AC  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
0490AF  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
0490B2  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
0490B5  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
0490B8  E9 B0 00              JMP    0x4916b                      ; UNKNOWN
0490BB  83 7E 06 08           CMP    word ptr [bp + 6], 8         ; UNKNOWN
0490BF  74 06                 JE     0x490c7                      ; UNKNOWN
0490C1  83 7E 06 0D           CMP    word ptr [bp + 6], 0xd       ; UNKNOWN
0490C5  75 16                 JNE    0x490dd                      ; UNKNOWN
0490C7  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0490CA  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
0490CD  D1 E6                 SHL    si, 1                        ; UNKNOWN
0490CF  89 42 9A              MOV    word ptr [bp + si - 0x66], ax ; UNKNOWN
0490D2  C7 42 A0 FF FF        MOV    word ptr [bp + si - 0x60], 0xffff ; UNKNOWN
0490D7  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
0490DA  E9 93 00              JMP    0x49170                      ; UNKNOWN
0490DD  83 7E 06 07           CMP    word ptr [bp + 6], 7         ; UNKNOWN
0490E1  75 10                 JNE    0x490f3                      ; UNKNOWN
0490E3  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0490E6  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
0490E9  D1 E6                 SHL    si, 1                        ; UNKNOWN
0490EB  89 42 9A              MOV    word ptr [bp + si - 0x66], ax ; UNKNOWN
0490EE  89 42 A0              MOV    word ptr [bp + si - 0x60], ax ; UNKNOWN
0490F1  EB E4                 JMP    0x490d7                      ; UNKNOWN
0490F3  83 7E 06 06           CMP    word ptr [bp + 6], 6         ; UNKNOWN
0490F7  74 0C                 JE     0x49105                      ; UNKNOWN
0490F9  83 7E 06 0E           CMP    word ptr [bp + 6], 0xe       ; UNKNOWN
0490FD  74 06                 JE     0x49105                      ; UNKNOWN
0490FF  83 7E 06 0F           CMP    word ptr [bp + 6], 0xf       ; UNKNOWN
049103  75 22                 JNE    0x49127                      ; UNKNOWN
049105  B8 06 00              MOV    ax, 6                        ; UNKNOWN
049108  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
04910B  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
04910E  B8 0E 00              MOV    ax, 0xe                      ; UNKNOWN
049111  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
049114  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
049117  B8 0F 00              MOV    ax, 0xf                      ; UNKNOWN
04911A  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
04911D  89 46 9E              MOV    word ptr [bp - 0x62], ax     ; UNKNOWN
049120  C7 46 FE 03 00        MOV    word ptr [bp - 2], 3         ; UNKNOWN
049125  EB 49                 JMP    0x49170                      ; UNKNOWN
049127  83 7E 06 05           CMP    word ptr [bp + 6], 5         ; UNKNOWN
04912B  75 15                 JNE    0x49142                      ; UNKNOWN
04912D  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
049130  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
049133  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
049136  C7 46 9C 10 00        MOV    word ptr [bp - 0x64], 0x10   ; UNKNOWN
04913B  C7 46 A2 0D 00        MOV    word ptr [bp - 0x5e], 0xd    ; UNKNOWN
049140  EB 29                 JMP    0x4916b                      ; UNKNOWN
049142  83 7E 06 08           CMP    word ptr [bp + 6], 8         ; UNKNOWN
049146  7D 0E                 JGE    0x49156                      ; UNKNOWN
049148  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04914B  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
04914E  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
049151  83 C0 08              ADD    ax, 8                        ; UNKNOWN
049154  EB 0F                 JMP    0x49165                      ; UNKNOWN
049156  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
049159  83 E8 08              SUB    ax, 8                        ; UNKNOWN
04915C  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
04915F  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
049162  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
049165  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
049168  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
04916B  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2         ; UNKNOWN
049170  C7 46 A6 00 00        MOV    word ptr [bp - 0x5a], 0      ; UNKNOWN
049175  EB 1C                 JMP    0x49193                      ; UNKNOWN
049177  FF 76 A8              PUSH   word ptr [bp - 0x58]         ; UNKNOWN
04917A  8B 76 A6              MOV    si, word ptr [bp - 0x5a]     ; UNKNOWN
04917D  D1 E6                 SHL    si, 1                        ; UNKNOWN
04917F  FF 72 A0              PUSH   word ptr [bp + si - 0x60]    ; UNKNOWN
049182  FF 72 9A              PUSH   word ptr [bp + si - 0x66]    ; UNKNOWN
049185  0E                    PUSH   cs                           ; UNKNOWN
049186  E8 1C FD              CALL   0x48ea5                      ; UNKNOWN
049189  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04918C  83 46 A8 14           ADD    word ptr [bp - 0x58], 0x14   ; UNKNOWN
049190  FF 46 A6              INC    word ptr [bp - 0x5a]         ; UNKNOWN
049193  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
049196  39 46 A6              CMP    word ptr [bp - 0x5a], ax     ; UNKNOWN
049199  7C DC                 JL     0x49177                      ; UNKNOWN
04919B  68 5F 29              PUSH   0x295f                       ; UNKNOWN
04919E  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0491A1  50                    PUSH   ax                           ; UNKNOWN
0491A2  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
0491A7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0491AA  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0491AD  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0491B0  16                    PUSH   ss                           ; UNKNOWN
0491B1  50                    PUSH   ax                           ; UNKNOWN
0491B2  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
0491B7  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0491BA  83 46 A8 0A           ADD    word ptr [bp - 0x58], 0xa    ; UNKNOWN
0491BE  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
0491C1  A3 02 0A              MOV    word ptr [0xa02], ax         ; UNKNOWN
0491C4  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0491C7  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0491C9  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
0491CD  6A 00                 PUSH   0                            ; UNKNOWN
0491CF  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
0491D4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0491D7  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0491DA  50                    PUSH   ax                           ; UNKNOWN
0491DB  0E                    PUSH   cs                           ; UNKNOWN
0491DC  E8 F7 FB              CALL   0x48dd6                      ; UNKNOWN
0491DF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0491E2  6A 00                 PUSH   0                            ; UNKNOWN
0491E4  68 40 01              PUSH   0x140                        ; UNKNOWN
0491E7  68 C8 00              PUSH   0xc8                         ; UNKNOWN
0491EA  2B C0                 SUB    ax, ax                       ; UNKNOWN
0491EC  99                    CDQ                                 ; UNKNOWN
0491ED  2B DB                 SUB    bx, bx                       ; UNKNOWN
0491EF  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
0491F4  9A 6B 00 EF 21        LCALL  0x21ef, 0x6b                 ; UNKNOWN
0491F9  5E                    POP    si                           ; UNKNOWN
0491FA  C9                    LEAVE                               ; UNKNOWN
0491FB  CB                    RETF                                ; UNKNOWN
