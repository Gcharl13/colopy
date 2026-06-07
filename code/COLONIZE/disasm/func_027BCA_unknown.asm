; ============================================================================
; func_027BCA_unknown
; Region   : load_image
; Bytes    : file 0x027BCA..0x027FDF  (1045 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

027BCA  C8 68 01 00           ENTER  0x168, 0                     ; UNKNOWN
027BCE  52                    PUSH   dx                           ; UNKNOWN
027BCF  50                    PUSH   ax                           ; UNKNOWN
027BD0  53                    PUSH   bx                           ; UNKNOWN
027BD1  57                    PUSH   di                           ; UNKNOWN
027BD2  56                    PUSH   si                           ; UNKNOWN
027BD3  B9 01 00              MOV    cx, 1                        ; UNKNOWN
027BD6  89 4E FC              MOV    word ptr [bp - 4], cx        ; UNKNOWN
027BD9  89 8E 9E FE           MOV    word ptr [bp - 0x162], cx    ; UNKNOWN
027BDD  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
027BE2  2B C9                 SUB    cx, cx                       ; UNKNOWN
027BE4  89 4E F6              MOV    word ptr [bp - 0xa], cx      ; UNKNOWN
027BE7  89 4E F4              MOV    word ptr [bp - 0xc], cx      ; UNKNOWN
027BEA  50                    PUSH   ax                           ; UNKNOWN
027BEB  68 A8 D3              PUSH   0xd3a8                       ; UNKNOWN
027BEE  8B F0                 MOV    si, ax                       ; UNKNOWN
027BF0  8B FB                 MOV    di, bx                       ; UNKNOWN
027BF2  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
027BF7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027BFA  56                    PUSH   si                           ; UNKNOWN
027BFB  57                    PUSH   di                           ; UNKNOWN
027BFC  9A 24 00 09 45        LCALL  0x4509, 0x24                 ; UNKNOWN
027C01  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027C04  0B C0                 OR     ax, ax                       ; UNKNOWN
027C06  74 03                 JE     0x27c0b                      ; UNKNOWN
027C08  E9 B0 03              JMP    0x27fbb                      ; UNKNOWN
027C0B  FF 36 1E 0A           PUSH   word ptr [0xa1e]             ; UNKNOWN
027C0F  FF 36 1C 0A           PUSH   word ptr [0xa1c]             ; UNKNOWN
027C13  FF 36 20 0A           PUSH   word ptr [0xa20]             ; UNKNOWN
027C17  0E                    PUSH   cs                           ; UNKNOWN
027C18  E8 13 D4              CALL   0x2502e                      ; UNKNOWN
027C1B  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027C1E  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
027C21  89 56 F6              MOV    word ptr [bp - 0xa], dx      ; UNKNOWN
027C24  0B D0                 OR     dx, ax                       ; UNKNOWN
027C26  75 03                 JNE    0x27c2b                      ; UNKNOWN
027C28  E9 90 03              JMP    0x27fbb                      ; UNKNOWN
027C2B  83 3E 22 0A 00        CMP    word ptr [0xa22], 0          ; UNKNOWN
027C30  74 18                 JE     0x27c4a                      ; UNKNOWN
027C32  83 3E 86 40 00        CMP    word ptr [0x4086], 0         ; UNKNOWN
027C37  74 11                 JE     0x27c4a                      ; UNKNOWN
027C39  FF 36 86 40           PUSH   word ptr [0x4086]            ; UNKNOWN
027C3D  8D 86 A0 FE           LEA    ax, [bp - 0x160]             ; UNKNOWN
027C41  50                    PUSH   ax                           ; UNKNOWN
027C42  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
027C47  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027C4A  9A 0F 01 09 45        LCALL  0x4509, 0x10f                ; UNKNOWN
027C4F  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
027C52  50                    PUSH   ax                           ; UNKNOWN
027C53  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
027C58  83 C4 02              ADD    sp, 2                        ; UNKNOWN
027C5B  0B C0                 OR     ax, ax                       ; UNKNOWN
027C5D  75 06                 JNE    0x27c65                      ; UNKNOWN
027C5F  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
027C62  E9 4D 03              JMP    0x27fb2                      ; UNKNOWN
027C65  8B 5E F2              MOV    bx, word ptr [bp - 0xe]      ; UNKNOWN
027C68  80 3F 40              CMP    byte ptr [bx], 0x40          ; UNKNOWN
027C6B  74 03                 JE     0x27c70                      ; UNKNOWN
027C6D  E9 62 02              JMP    0x27ed2                      ; UNKNOWN
027C70  53                    PUSH   bx                           ; UNKNOWN
027C71  9A 9E 0D 65 5F        LCALL  0x5f65, 0xd9e                ; UNKNOWN
027C76  83 C4 02              ADD    sp, 2                        ; UNKNOWN
027C79  68 0C 19              PUSH   0x190c                       ; UNKNOWN
027C7C  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
027C7F  40                    INC    ax                           ; UNKNOWN
027C80  89 86 98 FE           MOV    word ptr [bp - 0x168], ax    ; UNKNOWN
027C84  50                    PUSH   ax                           ; UNKNOWN
027C85  9A A6 07 65 5F        LCALL  0x5f65, 0x7a6                ; UNKNOWN
027C8A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027C8D  0B C0                 OR     ax, ax                       ; UNKNOWN
027C8F  74 13                 JE     0x27ca4                      ; UNKNOWN
027C91  68 14 19              PUSH   0x1914                       ; UNKNOWN
027C94  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027C98  9A A6 07 65 5F        LCALL  0x5f65, 0x7a6                ; UNKNOWN
027C9D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027CA0  0B C0                 OR     ax, ax                       ; UNKNOWN
027CA2  75 08                 JNE    0x27cac                      ; UNKNOWN
027CA4  C7 46 FC 02 00        MOV    word ptr [bp - 4], 2         ; UNKNOWN
027CA9  E9 06 03              JMP    0x27fb2                      ; UNKNOWN
027CAC  68 1B 19              PUSH   0x191b                       ; UNKNOWN
027CAF  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027CB3  9A A6 07 65 5F        LCALL  0x5f65, 0x7a6                ; UNKNOWN
027CB8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027CBB  0B C0                 OR     ax, ax                       ; UNKNOWN
027CBD  75 08                 JNE    0x27cc7                      ; UNKNOWN
027CBF  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
027CC4  E9 EB 02              JMP    0x27fb2                      ; UNKNOWN
027CC7  68 20 19              PUSH   0x1920                       ; UNKNOWN
027CCA  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027CCE  9A A6 07 65 5F        LCALL  0x5f65, 0x7a6                ; UNKNOWN
027CD3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027CD6  0B C0                 OR     ax, ax                       ; UNKNOWN
027CD8  75 17                 JNE    0x27cf1                      ; UNKNOWN
027CDA  A1 B4 09              MOV    ax, word ptr [0x9b4]         ; UNKNOWN
027CDD  8B 16 B6 09           MOV    dx, word ptr [0x9b6]         ; UNKNOWN
027CE1  C4 5E F4              LES    bx, ptr [bp - 0xc]           ; UNKNOWN
027CE4  26 89 87 80 00        MOV    word ptr es:[bx + 0x80], ax  ; UNKNOWN
027CE9  26 89 97 82 00        MOV    word ptr es:[bx + 0x82], dx  ; UNKNOWN
027CEE  E9 C1 02              JMP    0x27fb2                      ; UNKNOWN
027CF1  6A 01                 PUSH   1                            ; UNKNOWN
027CF3  68 2A 19              PUSH   0x192a                       ; UNKNOWN
027CF6  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027CFA  9A 4C 08 65 5F        LCALL  0x5f65, 0x84c                ; UNKNOWN
027CFF  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027D02  0B C0                 OR     ax, ax                       ; UNKNOWN
027D04  75 31                 JNE    0x27d37                      ; UNKNOWN
027D06  EB 10                 JMP    0x27d18                      ; UNKNOWN
027D08  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
027D0A  98                    CWDE                                ; UNKNOWN
027D0B  8B D8                 MOV    bx, ax                       ; UNKNOWN
027D0D  F6 87 BB 13 04        TEST   byte ptr [bx + 0x13bb], 4    ; UNKNOWN
027D12  75 0D                 JNE    0x27d21                      ; UNKNOWN
027D14  FF 86 98 FE           INC    word ptr [bp - 0x168]        ; UNKNOWN
027D18  8B 9E 98 FE           MOV    bx, word ptr [bp - 0x168]    ; UNKNOWN
027D1C  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
027D1F  75 E7                 JNE    0x27d08                      ; UNKNOWN
027D21  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027D25  9A 86 08 65 5F        LCALL  0x5f65, 0x886                ; UNKNOWN
027D2A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
027D2D  C4 5E F4              LES    bx, ptr [bp - 0xc]           ; UNKNOWN
027D30  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax   ; UNKNOWN
027D34  E9 7B 02              JMP    0x27fb2                      ; UNKNOWN
027D37  6A 01                 PUSH   1                            ; UNKNOWN
027D39  68 2C 19              PUSH   0x192c                       ; UNKNOWN
027D3C  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027D40  9A 4C 08 65 5F        LCALL  0x5f65, 0x84c                ; UNKNOWN
027D45  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027D48  0B C0                 OR     ax, ax                       ; UNKNOWN
027D4A  75 31                 JNE    0x27d7d                      ; UNKNOWN
027D4C  EB 10                 JMP    0x27d5e                      ; UNKNOWN
027D4E  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
027D50  98                    CWDE                                ; UNKNOWN
027D51  8B D8                 MOV    bx, ax                       ; UNKNOWN
027D53  F6 87 BB 13 04        TEST   byte ptr [bx + 0x13bb], 4    ; UNKNOWN
027D58  75 0D                 JNE    0x27d67                      ; UNKNOWN
027D5A  FF 86 98 FE           INC    word ptr [bp - 0x168]        ; UNKNOWN
027D5E  8B 9E 98 FE           MOV    bx, word ptr [bp - 0x168]    ; UNKNOWN
027D62  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
027D65  75 E7                 JNE    0x27d4e                      ; UNKNOWN
027D67  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027D6B  9A 86 08 65 5F        LCALL  0x5f65, 0x886                ; UNKNOWN
027D70  83 C4 02              ADD    sp, 2                        ; UNKNOWN
027D73  C4 5E F4              LES    bx, ptr [bp - 0xc]           ; UNKNOWN
027D76  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax   ; UNKNOWN
027D7A  E9 35 02              JMP    0x27fb2                      ; UNKNOWN
027D7D  6A 05                 PUSH   5                            ; UNKNOWN
027D7F  68 2E 19              PUSH   0x192e                       ; UNKNOWN
027D82  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027D86  9A 4C 08 65 5F        LCALL  0x5f65, 0x84c                ; UNKNOWN
027D8B  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027D8E  0B C0                 OR     ax, ax                       ; UNKNOWN
027D90  75 3B                 JNE    0x27dcd                      ; UNKNOWN
027D92  EB 10                 JMP    0x27da4                      ; UNKNOWN
027D94  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
027D96  98                    CWDE                                ; UNKNOWN
027D97  8B D8                 MOV    bx, ax                       ; UNKNOWN
027D99  F6 87 BB 13 04        TEST   byte ptr [bx + 0x13bb], 4    ; UNKNOWN
027D9E  75 0D                 JNE    0x27dad                      ; UNKNOWN
027DA0  FF 86 98 FE           INC    word ptr [bp - 0x168]        ; UNKNOWN
027DA4  8B 9E 98 FE           MOV    bx, word ptr [bp - 0x168]    ; UNKNOWN
027DA8  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
027DAB  75 E7                 JNE    0x27d94                      ; UNKNOWN
027DAD  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027DB1  9A 86 08 65 5F        LCALL  0x5f65, 0x886                ; UNKNOWN
027DB6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
027DB9  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
027DBC  50                    PUSH   ax                           ; UNKNOWN
027DBD  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
027DC0  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
027DC3  0E                    PUSH   cs                           ; UNKNOWN
027DC4  E8 B1 D7              CALL   0x25578                      ; UNKNOWN
027DC7  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027DCA  E9 E5 01              JMP    0x27fb2                      ; UNKNOWN
027DCD  6A 06                 PUSH   6                            ; UNKNOWN
027DCF  68 34 19              PUSH   0x1934                       ; UNKNOWN
027DD2  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027DD6  9A FC 0C 65 5F        LCALL  0x5f65, 0xcfc                ; UNKNOWN
027DDB  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027DDE  0B C0                 OR     ax, ax                       ; UNKNOWN
027DE0  75 37                 JNE    0x27e19                      ; UNKNOWN
027DE2  EB 10                 JMP    0x27df4                      ; UNKNOWN
027DE4  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
027DE6  98                    CWDE                                ; UNKNOWN
027DE7  8B D8                 MOV    bx, ax                       ; UNKNOWN
027DE9  F6 87 BB 13 04        TEST   byte ptr [bx + 0x13bb], 4    ; UNKNOWN
027DEE  75 0D                 JNE    0x27dfd                      ; UNKNOWN
027DF0  FF 86 98 FE           INC    word ptr [bp - 0x168]        ; UNKNOWN
027DF4  8B 9E 98 FE           MOV    bx, word ptr [bp - 0x168]    ; UNKNOWN
027DF8  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
027DFB  75 E7                 JNE    0x27de4                      ; UNKNOWN
027DFD  83 3E 88 40 00        CMP    word ptr [0x4088], 0         ; UNKNOWN
027E02  74 03                 JE     0x27e07                      ; UNKNOWN
027E04  E9 AB 01              JMP    0x27fb2                      ; UNKNOWN
027E07  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027E0B  9A 86 08 65 5F        LCALL  0x5f65, 0x886                ; UNKNOWN
027E10  83 C4 02              ADD    sp, 2                        ; UNKNOWN
027E13  A3 88 40              MOV    word ptr [0x4088], ax        ; UNKNOWN
027E16  E9 99 01              JMP    0x27fb2                      ; UNKNOWN
027E19  6A 07                 PUSH   7                            ; UNKNOWN
027E1B  68 3B 19              PUSH   0x193b                       ; UNKNOWN
027E1E  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027E22  9A 4C 08 65 5F        LCALL  0x5f65, 0x84c                ; UNKNOWN
027E27  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027E2A  0B C0                 OR     ax, ax                       ; UNKNOWN
027E2C  75 10                 JNE    0x27e3e                      ; UNKNOWN
027E2E  C7 46 F0 01 00        MOV    word ptr [bp - 0x10], 1      ; UNKNOWN
027E33  C4 5E F4              LES    bx, ptr [bp - 0xc]           ; UNKNOWN
027E36  26 80 4F 0A 05        OR     byte ptr es:[bx + 0xa], 5    ; UNKNOWN
027E3B  E9 74 01              JMP    0x27fb2                      ; UNKNOWN
027E3E  6A 07                 PUSH   7                            ; UNKNOWN
027E40  68 44 19              PUSH   0x1944                       ; UNKNOWN
027E43  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027E47  9A 4C 08 65 5F        LCALL  0x5f65, 0x84c                ; UNKNOWN
027E4C  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027E4F  0B C0                 OR     ax, ax                       ; UNKNOWN
027E51  75 77                 JNE    0x27eca                      ; UNKNOWN
027E53  39 06 22 0A           CMP    word ptr [0xa22], ax         ; UNKNOWN
027E57  74 4B                 JE     0x27ea4                      ; UNKNOWN
027E59  EB 09                 JMP    0x27e64                      ; UNKNOWN
027E5B  80 3F 3D              CMP    byte ptr [bx], 0x3d          ; UNKNOWN
027E5E  74 0D                 JE     0x27e6d                      ; UNKNOWN
027E60  FF 86 98 FE           INC    word ptr [bp - 0x168]        ; UNKNOWN
027E64  8B 9E 98 FE           MOV    bx, word ptr [bp - 0x168]    ; UNKNOWN
027E68  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
027E6B  75 EE                 JNE    0x27e5b                      ; UNKNOWN
027E6D  83 3E 86 40 00        CMP    word ptr [0x4086], 0         ; UNKNOWN
027E72  74 03                 JE     0x27e77                      ; UNKNOWN
027E74  E9 3B 01              JMP    0x27fb2                      ; UNKNOWN
027E77  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
027E7A  74 04                 JE     0x27e80                      ; UNKNOWN
027E7C  FF 86 98 FE           INC    word ptr [bp - 0x168]        ; UNKNOWN
027E80  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027E84  8D 86 A0 FE           LEA    ax, [bp - 0x160]             ; UNKNOWN
027E88  50                    PUSH   ax                           ; UNKNOWN
027E89  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
027E8E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027E91  E9 1E 01              JMP    0x27fb2                      ; UNKNOWN
027E94  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
027E96  98                    CWDE                                ; UNKNOWN
027E97  8B D8                 MOV    bx, ax                       ; UNKNOWN
027E99  F6 87 BB 13 04        TEST   byte ptr [bx + 0x13bb], 4    ; UNKNOWN
027E9E  75 0D                 JNE    0x27ead                      ; UNKNOWN
027EA0  FF 86 98 FE           INC    word ptr [bp - 0x168]        ; UNKNOWN
027EA4  8B 9E 98 FE           MOV    bx, word ptr [bp - 0x168]    ; UNKNOWN
027EA8  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
027EAB  75 E7                 JNE    0x27e94                      ; UNKNOWN
027EAD  83 BE 96 FE 00        CMP    word ptr [bp - 0x16a], 0     ; UNKNOWN
027EB2  74 03                 JE     0x27eb7                      ; UNKNOWN
027EB4  E9 FB 00              JMP    0x27fb2                      ; UNKNOWN
027EB7  FF B6 98 FE           PUSH   word ptr [bp - 0x168]        ; UNKNOWN
027EBB  9A 86 08 65 5F        LCALL  0x5f65, 0x886                ; UNKNOWN
027EC0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
027EC3  89 86 96 FE           MOV    word ptr [bp - 0x16a], ax    ; UNKNOWN
027EC7  E9 E8 00              JMP    0x27fb2                      ; UNKNOWN
027ECA  C7 46 FC 03 00        MOV    word ptr [bp - 4], 3         ; UNKNOWN
027ECF  E9 E0 00              JMP    0x27fb2                      ; UNKNOWN
027ED2  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
027ED5  E9 CE 00              JMP    0x27fa6                      ; UNKNOWN
027ED8  8D 86 F0 FE           LEA    ax, [bp - 0x110]             ; UNKNOWN
027EDC  50                    PUSH   ax                           ; UNKNOWN
027EDD  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
027EE0  0E                    PUSH   cs                           ; UNKNOWN
027EE1  E8 E2 FA              CALL   0x279c6                      ; UNKNOWN
027EE4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027EE7  8D 86 F0 FE           LEA    ax, [bp - 0x110]             ; UNKNOWN
027EEB  16                    PUSH   ss                           ; UNKNOWN
027EEC  50                    PUSH   ax                           ; UNKNOWN
027EED  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
027EF0  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
027EF3  0E                    PUSH   cs                           ; UNKNOWN
027EF4  E8 90 D6              CALL   0x25587                      ; UNKNOWN
027EF7  83 C4 08              ADD    sp, 8                        ; UNKNOWN
027EFA  E9 B5 00              JMP    0x27fb2                      ; UNKNOWN
027EFD  83 3E 22 0A 00        CMP    word ptr [0xa22], 0          ; UNKNOWN
027F02  74 41                 JE     0x27f45                      ; UNKNOWN
027F04  83 3E 88 40 00        CMP    word ptr [0x4088], 0         ; UNKNOWN
027F09  75 06                 JNE    0x27f11                      ; UNKNOWN
027F0B  C7 06 88 40 05 00     MOV    word ptr [0x4088], 5         ; UNKNOWN
027F11  8D 86 F0 FE           LEA    ax, [bp - 0x110]             ; UNKNOWN
027F15  50                    PUSH   ax                           ; UNKNOWN
027F16  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
027F19  0E                    PUSH   cs                           ; UNKNOWN
027F1A  E8 A9 FA              CALL   0x279c6                      ; UNKNOWN
027F1D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027F20  FF 36 88 40           PUSH   word ptr [0x4088]            ; UNKNOWN
027F24  8D 86 A0 FE           LEA    ax, [bp - 0x160]             ; UNKNOWN
027F28  16                    PUSH   ss                           ; UNKNOWN
027F29  50                    PUSH   ax                           ; UNKNOWN
027F2A  8D 86 F0 FE           LEA    ax, [bp - 0x110]             ; UNKNOWN
027F2E  16                    PUSH   ss                           ; UNKNOWN
027F2F  50                    PUSH   ax                           ; UNKNOWN
027F30  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
027F33  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
027F36  0E                    PUSH   cs                           ; UNKNOWN
027F37  E8 5E D7              CALL   0x25698                      ; UNKNOWN
027F3A  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
027F3D  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
027F40  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
027F43  EB 6D                 JMP    0x27fb2                      ; UNKNOWN
027F45  8D 86 F0 FE           LEA    ax, [bp - 0x110]             ; UNKNOWN
027F49  50                    PUSH   ax                           ; UNKNOWN
027F4A  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
027F4D  0E                    PUSH   cs                           ; UNKNOWN
027F4E  E8 75 FA              CALL   0x279c6                      ; UNKNOWN
027F51  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027F54  FF B6 9E FE           PUSH   word ptr [bp - 0x162]        ; UNKNOWN
027F58  8D 86 F0 FE           LEA    ax, [bp - 0x110]             ; UNKNOWN
027F5C  16                    PUSH   ss                           ; UNKNOWN
027F5D  50                    PUSH   ax                           ; UNKNOWN
027F5E  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
027F61  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
027F64  0E                    PUSH   cs                           ; UNKNOWN
027F65  E8 EE D3              CALL   0x25356                      ; UNKNOWN
027F68  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
027F6B  89 86 9A FE           MOV    word ptr [bp - 0x166], ax    ; UNKNOWN
027F6F  89 96 9C FE           MOV    word ptr [bp - 0x164], dx    ; UNKNOWN
027F73  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
027F77  74 0A                 JE     0x27f83                      ; UNKNOWN
027F79  C4 9E 9A FE           LES    bx, ptr [bp - 0x166]         ; UNKNOWN
027F7D  26 C7 47 06 00 00     MOV    word ptr es:[bx + 6], 0      ; UNKNOWN
027F83  8B 86 96 FE           MOV    ax, word ptr [bp - 0x16a]    ; UNKNOWN
027F87  39 86 9E FE           CMP    word ptr [bp - 0x162], ax    ; UNKNOWN
027F8B  75 13                 JNE    0x27fa0                      ; UNKNOWN
027F8D  8B 86 9A FE           MOV    ax, word ptr [bp - 0x166]    ; UNKNOWN
027F91  8B 96 9C FE           MOV    dx, word ptr [bp - 0x164]    ; UNKNOWN
027F95  C4 5E F4              LES    bx, ptr [bp - 0xc]           ; UNKNOWN
027F98  26 89 47 4C           MOV    word ptr es:[bx + 0x4c], ax  ; UNKNOWN
027F9C  26 89 57 4E           MOV    word ptr es:[bx + 0x4e], dx  ; UNKNOWN
027FA0  FF 86 9E FE           INC    word ptr [bp - 0x162]        ; UNKNOWN
027FA4  EB 0C                 JMP    0x27fb2                      ; UNKNOWN
027FA6  48                    DEC    ax                           ; UNKNOWN
027FA7  75 03                 JNE    0x27fac                      ; UNKNOWN
027FA9  E9 2C FF              JMP    0x27ed8                      ; UNKNOWN
027FAC  48                    DEC    ax                           ; UNKNOWN
027FAD  75 03                 JNE    0x27fb2                      ; UNKNOWN
027FAF  E9 4B FF              JMP    0x27efd                      ; UNKNOWN
027FB2  83 7E FC 03           CMP    word ptr [bp - 4], 3         ; UNKNOWN
027FB6  7D 03                 JGE    0x27fbb                      ; UNKNOWN
027FB8  E9 8F FC              JMP    0x27c4a                      ; UNKNOWN
027FBB  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
027FBE  0B 46 F4              OR     ax, word ptr [bp - 0xc]      ; UNKNOWN
027FC1  75 12                 JNE    0x27fd5                      ; UNKNOWN
027FC3  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
027FC6  A3 06 0A              MOV    word ptr [0xa06], ax         ; UNKNOWN
027FC9  A3 04 0A              MOV    word ptr [0xa04], ax         ; UNKNOWN
027FCC  A3 08 0A              MOV    word ptr [0xa08], ax         ; UNKNOWN
027FCF  C7 06 0E 0A 00 00     MOV    word ptr [0xa0e], 0          ; UNKNOWN
027FD5  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
027FD8  8B 56 F6              MOV    dx, word ptr [bp - 0xa]      ; UNKNOWN
027FDB  5E                    POP    si                           ; UNKNOWN
027FDC  5F                    POP    di                           ; UNKNOWN
027FDD  C9                    LEAVE                               ; UNKNOWN
027FDE  CB                    RETF                                ; UNKNOWN
