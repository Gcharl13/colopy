; ============================================================================
; func_011A6C_unknown
; Region   : load_image
; Bytes    : file 0x011A6C..0x011D4F  (739 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011A6C  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
011A70  56                    PUSH   si                           ; UNKNOWN
011A71  C7 46 EC 00 00        MOV    word ptr [bp - 0x14], 0      ; UNKNOWN
011A76  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
011A79  9A 32 00 BA 33        LCALL  0x33ba, 0x32                 ; UNKNOWN
011A7E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
011A81  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
011A84  0E                    PUSH   cs                           ; UNKNOWN
011A85  E8 D4 EA              CALL   0x1055c                      ; UNKNOWN
011A88  83 C4 02              ADD    sp, 2                        ; UNKNOWN
011A8B  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
011A8F  3A 47 04              CMP    al, byte ptr [bx + 4]        ; UNKNOWN
011A92  76 05                 JBE    0x11a99                      ; UNKNOWN
011A94  C7 46 EC 02 00        MOV    word ptr [bp - 0x14], 2      ; UNKNOWN
011A99  F6 47 03 01           TEST   byte ptr [bx + 3], 1         ; UNKNOWN
011A9D  74 05                 JE     0x11aa4                      ; UNKNOWN
011A9F  C7 46 EC 01 00        MOV    word ptr [bp - 0x14], 1      ; UNKNOWN
011AA4  83 7E EC 00           CMP    word ptr [bp - 0x14], 0      ; UNKNOWN
011AA8  75 03                 JNE    0x11aad                      ; UNKNOWN
011AAA  E9 92 00              JMP    0x11b3f                      ; UNKNOWN
011AAD  8A 47 04              MOV    al, byte ptr [bx + 4]        ; UNKNOWN
011AB0  00 47 06              ADD    byte ptr [bx + 6], al        ; UNKNOWN
011AB3  80 7F 06 14           CMP    byte ptr [bx + 6], 0x14      ; UNKNOWN
011AB7  7D 03                 JGE    0x11abc                      ; UNKNOWN
011AB9  E9 83 00              JMP    0x11b3f                      ; UNKNOWN
011ABC  C6 47 06 00           MOV    byte ptr [bx + 6], 0         ; UNKNOWN
011AC0  83 7E EC 02           CMP    word ptr [bp - 0x14], 2      ; UNKNOWN
011AC4  75 05                 JNE    0x11acb                      ; UNKNOWN
011AC6  FE 47 04              INC    byte ptr [bx + 4]            ; UNKNOWN
011AC9  EB 74                 JMP    0x11b3f                      ; UNKNOWN
011ACB  C7 46 FE 13 00        MOV    word ptr [bp - 2], 0x13      ; UNKNOWN
011AD0  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
011AD4  80 7F 07 00           CMP    byte ptr [bx + 7], 0         ; UNKNOWN
011AD8  7E 1E                 JLE    0x11af8                      ; UNKNOWN
011ADA  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
011ADD  2A E4                 SUB    ah, ah                       ; UNKNOWN
011ADF  50                    PUSH   ax                           ; UNKNOWN
011AE0  6A 00                 PUSH   0                            ; UNKNOWN
011AE2  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
011AE7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
011AEA  0B C0                 OR     ax, ax                       ; UNKNOWN
011AEC  75 07                 JNE    0x11af5                      ; UNKNOWN
011AEE  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
011AF2  FE 4F 07              DEC    byte ptr [bx + 7]            ; UNKNOWN
011AF5  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
011AF8  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
011AFC  83 7F 0A 32           CMP    word ptr [bx + 0xa], 0x32    ; UNKNOWN
011B00  7C 08                 JL     0x11b0a                      ; UNKNOWN
011B02  83 6F 0A 32           SUB    word ptr [bx + 0xa], 0x32    ; UNKNOWN
011B06  83 46 FE 02           ADD    word ptr [bp - 2], 2         ; UNKNOWN
011B0A  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
011B0E  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
011B11  2A E4                 SUB    ah, ah                       ; UNKNOWN
011B13  50                    PUSH   ax                           ; UNKNOWN
011B14  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
011B16  50                    PUSH   ax                           ; UNKNOWN
011B17  8A 47 02              MOV    al, byte ptr [bx + 2]        ; UNKNOWN
011B1A  50                    PUSH   ax                           ; UNKNOWN
011B1B  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
011B1E  9A AE 06 B7 36        LCALL  0x36b7, 0x6ae                ; UNKNOWN
011B23  83 C4 08              ADD    sp, 8                        ; UNKNOWN
011B26  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
011B29  0B C0                 OR     ax, ax                       ; UNKNOWN
011B2B  7C 12                 JL     0x11b3f                      ; UNKNOWN
011B2D  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
011B30  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
011B33  88 87 86 88           MOV    byte ptr [bx - 0x777a], al   ; UNKNOWN
011B37  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
011B3B  80 67 03 FE           AND    byte ptr [bx + 3], 0xfe      ; UNKNOWN
011B3F  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
011B44  74 03                 JE     0x11b49                      ; UNKNOWN
011B46  E9 81 00              JMP    0x11bca                      ; UNKNOWN
011B49  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
011B4E  EB 34                 JMP    0x11b84                      ; UNKNOWN
011B50  B8 0C 00              MOV    ax, 0xc                      ; UNKNOWN
011B53  2B 46 E8              SUB    ax, word ptr [bp - 0x18]     ; UNKNOWN
011B56  50                    PUSH   ax                           ; UNKNOWN
011B57  6A 00                 PUSH   0                            ; UNKNOWN
011B59  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
011B5E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
011B61  0B C0                 OR     ax, ax                       ; UNKNOWN
011B63  75 03                 JNE    0x11b68                      ; UNKNOWN
011B65  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
011B68  FF 46 F4              INC    word ptr [bp - 0xc]          ; UNKNOWN
011B6B  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
011B6E  40                    INC    ax                           ; UNKNOWN
011B6F  3B 46 F4              CMP    ax, word ptr [bp - 0xc]      ; UNKNOWN
011B72  7F DC                 JG     0x11b50                      ; UNKNOWN
011B74  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
011B77  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
011B7B  8B 76 EE              MOV    si, word ptr [bp - 0x12]     ; UNKNOWN
011B7E  00 40 36              ADD    byte ptr [bx + si + 0x36], al ; UNKNOWN
011B81  FF 46 EE              INC    word ptr [bp - 0x12]         ; UNKNOWN
011B84  83 7E EE 04           CMP    word ptr [bp - 0x12], 4      ; UNKNOWN
011B88  7D 40                 JGE    0x11bca                      ; UNKNOWN
011B8A  FF 36 84 C0           PUSH   word ptr [0xc084]            ; UNKNOWN
011B8E  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
011B91  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
011B96  83 C4 04              ADD    sp, 4                        ; UNKNOWN
011B99  A8 20                 TEST   al, 0x20                     ; UNKNOWN
011B9B  74 E4                 JE     0x11b81                      ; UNKNOWN
011B9D  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
011BA0  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
011BA4  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
011BA9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
011BAC  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
011BAF  50                    PUSH   ax                           ; UNKNOWN
011BB0  9A A1 00 BA 33        LCALL  0x33ba, 0xa1                 ; UNKNOWN
011BB5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
011BB8  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
011BBB  F7 E8                 IMUL   ax                           ; UNKNOWN
011BBD  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
011BC0  2B C0                 SUB    ax, ax                       ; UNKNOWN
011BC2  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
011BC5  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
011BC8  EB A1                 JMP    0x11b6b                      ; UNKNOWN
011BCA  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
011BCD  50                    PUSH   ax                           ; UNKNOWN
011BCE  FF 36 36 82           PUSH   word ptr [0x8236]            ; UNKNOWN
011BD2  9A F5 03 D2 14        LCALL  0x14d2, 0x3f5                ; UNKNOWN
011BD7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
011BDA  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
011BDD  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
011BE1  8A 47 05              MOV    al, byte ptr [bx + 5]        ; UNKNOWN
011BE4  98                    CWDE                                ; UNKNOWN
011BE5  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
011BE8  0B C0                 OR     ax, ax                       ; UNKNOWN
011BEA  7C 06                 JL     0x11bf2                      ; UNKNOWN
011BEC  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
011BEF  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
011BF2  0B C0                 OR     ax, ax                       ; UNKNOWN
011BF4  7D 09                 JGE    0x11bff                      ; UNKNOWN
011BF6  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
011BFA  7D 03                 JGE    0x11bff                      ; UNKNOWN
011BFC  E9 19 01              JMP    0x11d18                      ; UNKNOWN
011BFF  8A 47 03              MOV    al, byte ptr [bx + 3]        ; UNKNOWN
011C02  24 04                 AND    al, 4                        ; UNKNOWN
011C04  3C 01                 CMP    al, 1                        ; UNKNOWN
011C06  1B C0                 SBB    ax, ax                       ; UNKNOWN
011C08  40                    INC    ax                           ; UNKNOWN
011C09  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
011C0C  83 7E F2 00           CMP    word ptr [bp - 0xe], 0       ; UNKNOWN
011C10  7C 68                 JL     0x11c7a                      ; UNKNOWN
011C12  8B C8                 MOV    cx, ax                       ; UNKNOWN
011C14  8A 47 05              MOV    al, byte ptr [bx + 5]        ; UNKNOWN
011C17  24 10                 AND    al, 0x10                     ; UNKNOWN
011C19  3C 01                 CMP    al, 1                        ; UNKNOWN
011C1B  1B C0                 SBB    ax, ax                       ; UNKNOWN
011C1D  24 FD                 AND    al, 0xfd                     ; UNKNOWN
011C1F  83 C0 04              ADD    ax, 4                        ; UNKNOWN
011C22  D3 E0                 SHL    ax, cl                       ; UNKNOWN
011C24  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
011C27  6A 18                 PUSH   0x18                         ; UNKNOWN
011C29  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
011C2C  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
011C31  83 C4 04              ADD    sp, 4                        ; UNKNOWN
011C34  0B C0                 OR     ax, ax                       ; UNKNOWN
011C36  74 03                 JE     0x11c3b                      ; UNKNOWN
011C38  D1 66 FA              SHL    word ptr [bp - 6], 1         ; UNKNOWN
011C3B  6A 17                 PUSH   0x17                         ; UNKNOWN
011C3D  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
011C40  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
011C45  83 C4 04              ADD    sp, 4                        ; UNKNOWN
011C48  0B C0                 OR     ax, ax                       ; UNKNOWN
011C4A  74 03                 JE     0x11c4f                      ; UNKNOWN
011C4C  D1 7E FA              SAR    word ptr [bp - 6], 1         ; UNKNOWN
011C4F  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
011C52  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
011C56  8B 76 F2              MOV    si, word ptr [bp - 0xe]      ; UNKNOWN
011C59  00 40 36              ADD    byte ptr [bx + si + 0x36], al ; UNKNOWN
011C5C  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
011C5F  8B C8                 MOV    cx, ax                       ; UNKNOWN
011C61  D1 E0                 SHL    ax, 1                        ; UNKNOWN
011C63  03 C1                 ADD    ax, cx                       ; UNKNOWN
011C65  D1 E6                 SHL    si, 1                        ; UNKNOWN
011C67  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
011C6B  29 40 0A              SUB    word ptr [bx + si + 0xa], ax ; UNKNOWN
011C6E  8B 40 0A              MOV    ax, word ptr [bx + si + 0xa] ; UNKNOWN
011C71  0B C0                 OR     ax, ax                       ; UNKNOWN
011C73  7D 02                 JGE    0x11c77                      ; UNKNOWN
011C75  2B C0                 SUB    ax, ax                       ; UNKNOWN
011C77  89 40 0A              MOV    word ptr [bx + si + 0xa], ax ; UNKNOWN
011C7A  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
011C7E  7C 44                 JL     0x11cc4                      ; UNKNOWN
011C80  8A 4E F8              MOV    cl, byte ptr [bp - 8]        ; UNKNOWN
011C83  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
011C86  D3 E0                 SHL    ax, cl                       ; UNKNOWN
011C88  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
011C8B  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
011C8F  8B 76 EE              MOV    si, word ptr [bp - 0x12]     ; UNKNOWN
011C92  28 40 36              SUB    byte ptr [bx + si + 0x36], al ; UNKNOWN
011C95  3B 76 F2              CMP    si, word ptr [bp - 0xe]      ; UNKNOWN
011C98  75 03                 JNE    0x11c9d                      ; UNKNOWN
011C9A  D1 7E F6              SAR    word ptr [bp - 0xa], 1       ; UNKNOWN
011C9D  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
011CA0  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
011CA4  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
011CA9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
011CAC  B9 05 00              MOV    cx, 5                        ; UNKNOWN
011CAF  99                    CDQ                                 ; UNKNOWN
011CB0  F7 F9                 IDIV   cx                           ; UNKNOWN
011CB2  01 46 F6              ADD    word ptr [bp - 0xa], ax      ; UNKNOWN
011CB5  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
011CB8  8B 76 EE              MOV    si, word ptr [bp - 0x12]     ; UNKNOWN
011CBB  D1 E6                 SHL    si, 1                        ; UNKNOWN
011CBD  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
011CC1  01 40 0A              ADD    word ptr [bx + si + 0xa], ax ; UNKNOWN
011CC4  83 7E F2 00           CMP    word ptr [bp - 0xe], 0       ; UNKNOWN
011CC8  7C 24                 JL     0x11cee                      ; UNKNOWN
011CCA  EB 15                 JMP    0x11ce1                      ; UNKNOWN
011CCC  80 68 36 08           SUB    byte ptr [bx + si + 0x36], 8 ; UNKNOWN
011CD0  6A 03                 PUSH   3                            ; UNKNOWN
011CD2  6A FF                 PUSH   -1                           ; UNKNOWN
011CD4  56                    PUSH   si                           ; UNKNOWN
011CD5  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
011CD9  9A F6 00 D2 14        LCALL  0x14d2, 0xf6                 ; UNKNOWN
011CDE  83 C4 08              ADD    sp, 8                        ; UNKNOWN
011CE1  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
011CE5  8B 76 F2              MOV    si, word ptr [bp - 0xe]      ; UNKNOWN
011CE8  80 78 36 08           CMP    byte ptr [bx + si + 0x36], 8 ; UNKNOWN
011CEC  7D DE                 JGE    0x11ccc                      ; UNKNOWN
011CEE  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
011CF2  7C 24                 JL     0x11d18                      ; UNKNOWN
011CF4  EB 15                 JMP    0x11d0b                      ; UNKNOWN
011CF6  80 40 36 08           ADD    byte ptr [bx + si + 0x36], 8 ; UNKNOWN
011CFA  6A 05                 PUSH   5                            ; UNKNOWN
011CFC  6A 01                 PUSH   1                            ; UNKNOWN
011CFE  56                    PUSH   si                           ; UNKNOWN
011CFF  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
011D03  9A F6 00 D2 14        LCALL  0x14d2, 0xf6                 ; UNKNOWN
011D08  83 C4 08              ADD    sp, 8                        ; UNKNOWN
011D0B  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
011D0F  8B 76 EE              MOV    si, word ptr [bp - 0x12]     ; UNKNOWN
011D12  80 78 36 F8           CMP    byte ptr [bx + si + 0x36], 0xf8 ; UNKNOWN
011D16  7E DE                 JLE    0x11cf6                      ; UNKNOWN
011D18  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
011D1D  EB 03                 JMP    0x11d22                      ; UNKNOWN
011D1F  FF 46 EE              INC    word ptr [bp - 0x12]         ; UNKNOWN
011D22  83 7E EE 04           CMP    word ptr [bp - 0x12], 4      ; UNKNOWN
011D26  7D 24                 JGE    0x11d4c                      ; UNKNOWN
011D28  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
011D2C  8B 76 EE              MOV    si, word ptr [bp - 0x12]     ; UNKNOWN
011D2F  80 78 36 08           CMP    byte ptr [bx + si + 0x36], 8 ; UNKNOWN
011D33  7C EA                 JL     0x11d1f                      ; UNKNOWN
011D35  80 68 36 08           SUB    byte ptr [bx + si + 0x36], 8 ; UNKNOWN
011D39  6A 00                 PUSH   0                            ; UNKNOWN
011D3B  6A FF                 PUSH   -1                           ; UNKNOWN
011D3D  56                    PUSH   si                           ; UNKNOWN
011D3E  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
011D42  9A F6 00 D2 14        LCALL  0x14d2, 0xf6                 ; UNKNOWN
011D47  83 C4 08              ADD    sp, 8                        ; UNKNOWN
011D4A  EB DC                 JMP    0x11d28                      ; UNKNOWN
011D4C  5E                    POP    si                           ; UNKNOWN
011D4D  C9                    LEAVE                               ; UNKNOWN
011D4E  CB                    RETF                                ; UNKNOWN
