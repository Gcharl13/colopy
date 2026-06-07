; ============================================================================
; func_013EEC_unknown
; Region   : load_image
; Bytes    : file 0x013EEC..0x0140E5  (505 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013EEC  C8 24 00 00           ENTER  0x24, 0                      ; UNKNOWN
013EF0  57                    PUSH   di                           ; UNKNOWN
013EF1  56                    PUSH   si                           ; UNKNOWN
013EF2  C7 46 E6 00 00        MOV    word ptr [bp - 0x1a], 0      ; UNKNOWN
013EF7  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
013EFB  80 BF 97 88 16        CMP    byte ptr [bx - 0x7769], 0x16 ; UNKNOWN
013F00  75 05                 JNE    0x13f07                      ; UNKNOWN
013F02  B8 01 00              MOV    ax, 1                        ; UNKNOWN
013F05  EB 02                 JMP    0x13f09                      ; UNKNOWN
013F07  2B C0                 SUB    ax, ax                       ; UNKNOWN
013F09  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
013F0C  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
013F0F  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
013F13  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
013F18  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013F1B  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
013F1E  83 F8 4B              CMP    ax, 0x4b                     ; UNKNOWN
013F21  7C 17                 JL     0x13f3a                      ; UNKNOWN
013F23  6A 06                 PUSH   6                            ; UNKNOWN
013F25  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
013F28  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
013F2D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013F30  0B C0                 OR     ax, ax                       ; UNKNOWN
013F32  75 03                 JNE    0x13f37                      ; UNKNOWN
013F34  E9 58 03              JMP    0x1428f                      ; UNKNOWN
013F37  E9 A5 03              JMP    0x142df                      ; UNKNOWN
013F3A  6B 46 DC 28           IMUL   ax, word ptr [bp - 0x24], 0x28 ; UNKNOWN
013F3E  83 C0 64              ADD    ax, 0x64                     ; UNKNOWN
013F41  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
013F44  50                    PUSH   ax                           ; UNKNOWN
013F45  6A 00                 PUSH   0                            ; UNKNOWN
013F47  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
013F4C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013F4F  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
013F52  83 7E DE 19           CMP    word ptr [bp - 0x22], 0x19   ; UNKNOWN
013F56  7C 0B                 JL     0x13f63                      ; UNKNOWN
013F58  8B 46 DE              MOV    ax, word ptr [bp - 0x22]     ; UNKNOWN
013F5B  C1 F8 02              SAR    ax, 2                        ; UNKNOWN
013F5E  3B 46 E8              CMP    ax, word ptr [bp - 0x18]     ; UNKNOWN
013F61  7D C0                 JGE    0x13f23                      ; UNKNOWN
013F63  83 3E 3A 82 02        CMP    word ptr [0x823a], 2         ; UNKNOWN
013F68  75 21                 JNE    0x13f8b                      ; UNKNOWN
013F6A  8A 4E DC              MOV    cl, byte ptr [bp - 0x24]     ; UNKNOWN
013F6D  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
013F70  2A E4                 SUB    ah, ah                       ; UNKNOWN
013F72  83 E8 08              SUB    ax, 8                        ; UNKNOWN
013F75  F7 D8                 NEG    ax                           ; UNKNOWN
013F77  D3 E0                 SHL    ax, cl                       ; UNKNOWN
013F79  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
013F7C  50                    PUSH   ax                           ; UNKNOWN
013F7D  6A 00                 PUSH   0                            ; UNKNOWN
013F7F  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
013F84  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013F87  0B C0                 OR     ax, ax                       ; UNKNOWN
013F89  74 98                 JE     0x13f23                      ; UNKNOWN
013F8B  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
013F8F  7C 03                 JL     0x13f94                      ; UNKNOWN
013F91  E9 F0 00              JMP    0x14084                      ; UNKNOWN
013F94  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34  ; UNKNOWN
013F98  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
013F9D  74 03                 JE     0x13fa2                      ; UNKNOWN
013F9F  E9 E2 00              JMP    0x14084                      ; UNKNOWN
013FA2  6A 01                 PUSH   1                            ; UNKNOWN
013FA4  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
013FA7  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
013FAA  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
013FAD  0E                    PUSH   cs                           ; UNKNOWN
013FAE  E8 65 BD              CALL   0xfd16                       ; UNKNOWN
013FB1  83 C4 08              ADD    sp, 8                        ; UNKNOWN
013FB4  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
013FB7  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
013FBA  6A FF                 PUSH   -1                           ; UNKNOWN
013FBC  FF 36 36 82           PUSH   word ptr [0x8236]            ; UNKNOWN
013FC0  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
013FC3  0E                    PUSH   cs                           ; UNKNOWN
013FC4  E8 71 ED              CALL   0x12d38                      ; UNKNOWN
013FC7  83 C4 08              ADD    sp, 8                        ; UNKNOWN
013FCA  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0      ; UNKNOWN
013FCF  8A 46 E4              MOV    al, byte ptr [bp - 0x1c]     ; UNKNOWN
013FD2  8B 76 E4              MOV    si, word ptr [bp - 0x1c]     ; UNKNOWN
013FD5  88 42 EE              MOV    byte ptr [bp + si - 0x12], al ; UNKNOWN
013FD8  FF 46 E4              INC    word ptr [bp - 0x1c]         ; UNKNOWN
013FDB  83 7E E4 10           CMP    word ptr [bp - 0x1c], 0x10   ; UNKNOWN
013FDF  7C EE                 JL     0x13fcf                      ; UNKNOWN
013FE1  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
013FE5  80 7F 08 00           CMP    byte ptr [bx + 8], 0         ; UNKNOWN
013FE9  7C 0E                 JL     0x13ff9                      ; UNKNOWN
013FEB  8A 47 08              MOV    al, byte ptr [bx + 8]        ; UNKNOWN
013FEE  98                    CWDE                                ; UNKNOWN
013FEF  8B D8                 MOV    bx, ax                       ; UNKNOWN
013FF1  D1 E3                 SHL    bx, 1                        ; UNKNOWN
013FF3  C7 87 3C 82 00 00     MOV    word ptr [bx - 0x7dc4], 0    ; UNKNOWN
013FF9  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
013FFD  80 7F 09 00           CMP    byte ptr [bx + 9], 0         ; UNKNOWN
014001  7C 0E                 JL     0x14011                      ; UNKNOWN
014003  8A 47 09              MOV    al, byte ptr [bx + 9]        ; UNKNOWN
014006  98                    CWDE                                ; UNKNOWN
014007  8B D8                 MOV    bx, ax                       ; UNKNOWN
014009  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01400B  C7 87 3C 82 00 00     MOV    word ptr [bx - 0x7dc4], 0    ; UNKNOWN
014011  8D 46 EE              LEA    ax, [bp - 0x12]              ; UNKNOWN
014014  16                    PUSH   ss                           ; UNKNOWN
014015  50                    PUSH   ax                           ; UNKNOWN
014016  1E                    PUSH   ds                           ; UNKNOWN
014017  68 3C 82              PUSH   0x823c                       ; UNKNOWN
01401A  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
01401D  9A 00 00 DB 5C        LCALL  0x5cdb, 0                    ; UNKNOWN
014022  8B 5E EA              MOV    bx, word ptr [bp - 0x16]     ; UNKNOWN
014025  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
014028  FF B7 35 38           PUSH   word ptr [bx + 0x3835]       ; UNKNOWN
01402C  6A 00                 PUSH   0                            ; UNKNOWN
01402E  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
014033  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014036  8A 5E FD              MOV    bl, byte ptr [bp - 3]        ; UNKNOWN
014039  2A FF                 SUB    bh, bh                       ; UNKNOWN
01403B  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01403D  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
014041  6A 01                 PUSH   1                            ; UNKNOWN
014043  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
014048  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01404B  8A 5E FC              MOV    bl, byte ptr [bp - 4]        ; UNKNOWN
01404E  2A FF                 SUB    bh, bh                       ; UNKNOWN
014050  D1 E3                 SHL    bx, 1                        ; UNKNOWN
014052  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
014056  6A 02                 PUSH   2                            ; UNKNOWN
014058  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
01405D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014060  8A 5E FB              MOV    bl, byte ptr [bp - 5]        ; UNKNOWN
014063  2A FF                 SUB    bh, bh                       ; UNKNOWN
014065  D1 E3                 SHL    bx, 1                        ; UNKNOWN
014067  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
01406B  6A 03                 PUSH   3                            ; UNKNOWN
01406D  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
014072  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014075  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
014079  68 19 26              PUSH   0x2619                       ; UNKNOWN
01407C  9A 00 37 97 1B        LCALL  0x1b97, 0x3700               ; UNKNOWN
014081  83 C4 04              ADD    sp, 4                        ; UNKNOWN
014084  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
014087  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
01408C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01408F  50                    PUSH   ax                           ; UNKNOWN
014090  6A 00                 PUSH   0                            ; UNKNOWN
014092  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
014097  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01409A  8B 46 DE              MOV    ax, word ptr [bp - 0x22]     ; UNKNOWN
01409D  39 46 E8              CMP    word ptr [bp - 0x18], ax     ; UNKNOWN
0140A0  7F 03                 JG     0x140a5                      ; UNKNOWN
0140A2  E9 3A 02              JMP    0x142df                      ; UNKNOWN
0140A5  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
0140A9  F6 47 03 08           TEST   byte ptr [bx + 3], 8         ; UNKNOWN
0140AD  74 03                 JE     0x140b2                      ; UNKNOWN
0140AF  E9 2D 02              JMP    0x142df                      ; UNKNOWN
0140B2  80 4F 03 08           OR     byte ptr [bx + 3], 8         ; UNKNOWN
0140B6  6A 03                 PUSH   3                            ; UNKNOWN
0140B8  6A 01                 PUSH   1                            ; UNKNOWN
0140BA  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
0140BF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0140C2  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0140C5  48                    DEC    ax                           ; UNKNOWN
0140C6  74 0C                 JE     0x140d4                      ; UNKNOWN
0140C8  48                    DEC    ax                           ; UNKNOWN
0140C9  74 74                 JE     0x1413f                      ; UNKNOWN
0140CB  48                    DEC    ax                           ; UNKNOWN
0140CC  75 03                 JNE    0x140d1                      ; UNKNOWN
0140CE  E9 07 01              JMP    0x141d8                      ; UNKNOWN
0140D1  E9 0B 02              JMP    0x142df                      ; UNKNOWN
0140D4  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; UNKNOWN
0140D8  75 65                 JNE    0x1413f                      ; UNKNOWN
0140DA  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
0140DE  8A 5F 02              MOV    bl, byte ptr [bx + 2]        ; UNKNOWN
0140E1  2A FF                 SUB    bh, bh                       ; UNKNOWN
0140E3  8B C3                 MOV    ax, bx                       ; UNKNOWN
