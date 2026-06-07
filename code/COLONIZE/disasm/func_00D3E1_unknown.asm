; ============================================================================
; func_00D3E1_unknown
; Region   : load_image
; Bytes    : file 0x00D3E1..0x00D61E  (573 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D3E1  C8 20 03 00           ENTER  0x320, 0                     ; UNKNOWN
00D3E5  57                    PUSH   di                           ; UNKNOWN
00D3E6  56                    PUSH   si                           ; UNKNOWN
00D3E7  2B C0                 SUB    ax, ax                       ; UNKNOWN
00D3E9  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
00D3EC  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
00D3EF  A1 14 0C              MOV    ax, word ptr [0xc14]         ; UNKNOWN
00D3F2  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
00D3F5  2B C0                 SUB    ax, ax                       ; UNKNOWN
00D3F7  A3 14 0C              MOV    word ptr [0xc14], ax         ; UNKNOWN
00D3FA  A3 0C 0A              MOV    word ptr [0xa0c], ax         ; UNKNOWN
00D3FD  68 21 1C              PUSH   0x1c21                       ; UNKNOWN
00D400  8D 46 E0              LEA    ax, [bp - 0x20]              ; UNKNOWN
00D403  50                    PUSH   ax                           ; UNKNOWN
00D404  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00D409  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00D40C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00D40F  8D 46 E0              LEA    ax, [bp - 0x20]              ; UNKNOWN
00D412  16                    PUSH   ss                           ; UNKNOWN
00D413  50                    PUSH   ax                           ; UNKNOWN
00D414  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
00D419  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00D41C  8D 86 E0 FC           LEA    ax, [bp - 0x320]             ; UNKNOWN
00D420  16                    PUSH   ss                           ; UNKNOWN
00D421  50                    PUSH   ax                           ; UNKNOWN
00D422  6A 00                 PUSH   0                            ; UNKNOWN
00D424  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00D428  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00D42C  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00D430  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00D434  8D 46 E0              LEA    ax, [bp - 0x20]              ; UNKNOWN
00D437  50                    PUSH   ax                           ; UNKNOWN
00D438  9A 0A 00 69 1A        LCALL  0x1a69, 0xa                  ; UNKNOWN
00D43D  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
00D440  0B C0                 OR     ax, ax                       ; UNKNOWN
00D442  74 03                 JE     0xd447                       ; UNKNOWN
00D444  E9 A6 01              JMP    0xd5ed                       ; UNKNOWN
00D447  A1 10 3E              MOV    ax, word ptr [0x3e10]        ; UNKNOWN
00D44A  0B C0                 OR     ax, ax                       ; UNKNOWN
00D44C  74 0B                 JE     0xd459                       ; UNKNOWN
00D44E  48                    DEC    ax                           ; UNKNOWN
00D44F  74 0D                 JE     0xd45e                       ; UNKNOWN
00D451  48                    DEC    ax                           ; UNKNOWN
00D452  74 0F                 JE     0xd463                       ; UNKNOWN
00D454  48                    DEC    ax                           ; UNKNOWN
00D455  74 11                 JE     0xd468                       ; UNKNOWN
00D457  EB 1E                 JMP    0xd477                       ; UNKNOWN
00D459  68 29 1C              PUSH   0x1c29                       ; UNKNOWN
00D45C  EB 0D                 JMP    0xd46b                       ; UNKNOWN
00D45E  68 30 1C              PUSH   0x1c30                       ; UNKNOWN
00D461  EB 08                 JMP    0xd46b                       ; UNKNOWN
00D463  68 37 1C              PUSH   0x1c37                       ; UNKNOWN
00D466  EB 03                 JMP    0xd46b                       ; UNKNOWN
00D468  68 3D 1C              PUSH   0x1c3d                       ; UNKNOWN
00D46B  8D 46 E0              LEA    ax, [bp - 0x20]              ; UNKNOWN
00D46E  50                    PUSH   ax                           ; UNKNOWN
00D46F  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00D474  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00D477  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00D47A  8D 46 E0              LEA    ax, [bp - 0x20]              ; UNKNOWN
00D47D  16                    PUSH   ss                           ; UNKNOWN
00D47E  50                    PUSH   ax                           ; UNKNOWN
00D47F  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
00D484  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00D487  9A 08 00 D0 21        LCALL  0x21d0, 8                    ; UNKNOWN
00D48C  8D 5E E0              LEA    bx, [bp - 0x20]              ; UNKNOWN
00D48F  2B C0                 SUB    ax, ax                       ; UNKNOWN
00D491  9A 5A 00 D0 21        LCALL  0x21d0, 0x5a                 ; UNKNOWN
00D496  8B F0                 MOV    si, ax                       ; UNKNOWN
00D498  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
00D49B  0B D0                 OR     dx, ax                       ; UNKNOWN
00D49D  74 1D                 JE     0xd4bc                       ; UNKNOWN
00D49F  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
00D4A2  50                    PUSH   ax                           ; UNKNOWN
00D4A3  56                    PUSH   si                           ; UNKNOWN
00D4A4  8E C0                 MOV    es, ax                       ; UNKNOWN
00D4A6  26 FF 74 48           PUSH   word ptr es:[si + 0x48]      ; UNKNOWN
00D4AA  6A 64                 PUSH   0x64                         ; UNKNOWN
00D4AC  26 8B 54 46           MOV    dx, word ptr es:[si + 0x46]  ; UNKNOWN
00D4B0  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00D4B3  8D 1E 8A CE           LEA    bx, [0xce8a]                 ; UNKNOWN
00D4B7  9A 02 00 35 5D        LCALL  0x5d35, 2                    ; UNKNOWN
00D4BC  83 7E 06 01           CMP    word ptr [bp + 6], 1         ; UNKNOWN
00D4C0  75 26                 JNE    0xd4e8                       ; UNKNOWN
00D4C2  83 7E 08 01           CMP    word ptr [bp + 8], 1         ; UNKNOWN
00D4C6  75 1B                 JNE    0xd4e3                       ; UNKNOWN
00D4C8  68 43 1C              PUSH   0x1c43                       ; UNKNOWN
00D4CB  8D 46 E0              LEA    ax, [bp - 0x20]              ; UNKNOWN
00D4CE  50                    PUSH   ax                           ; UNKNOWN
00D4CF  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00D4D4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00D4D7  6A 3E                 PUSH   0x3e                         ; UNKNOWN
00D4D9  9A C8 02 28 1A        LCALL  0x1a28, 0x2c8                ; UNKNOWN
00D4DE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00D4E1  EB 14                 JMP    0xd4f7                       ; UNKNOWN
00D4E3  68 49 1C              PUSH   0x1c49                       ; UNKNOWN
00D4E6  EB 03                 JMP    0xd4eb                       ; UNKNOWN
00D4E8  68 52 1C              PUSH   0x1c52                       ; UNKNOWN
00D4EB  8D 46 E0              LEA    ax, [bp - 0x20]              ; UNKNOWN
00D4EE  50                    PUSH   ax                           ; UNKNOWN
00D4EF  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00D4F4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00D4F7  9A 08 00 D0 21        LCALL  0x21d0, 8                    ; UNKNOWN
00D4FC  8D 5E E0              LEA    bx, [bp - 0x20]              ; UNKNOWN
00D4FF  2B C0                 SUB    ax, ax                       ; UNKNOWN
00D501  9A 5A 00 D0 21        LCALL  0x21d0, 0x5a                 ; UNKNOWN
00D506  8B F0                 MOV    si, ax                       ; UNKNOWN
00D508  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
00D50B  0B D0                 OR     dx, ax                       ; UNKNOWN
00D50D  74 1D                 JE     0xd52c                       ; UNKNOWN
00D50F  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
00D512  50                    PUSH   ax                           ; UNKNOWN
00D513  56                    PUSH   si                           ; UNKNOWN
00D514  8E C0                 MOV    es, ax                       ; UNKNOWN
00D516  26 FF 74 48           PUSH   word ptr es:[si + 0x48]      ; UNKNOWN
00D51A  6A 64                 PUSH   0x64                         ; UNKNOWN
00D51C  26 8B 54 46           MOV    dx, word ptr es:[si + 0x46]  ; UNKNOWN
00D520  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00D523  8D 1E 8A CE           LEA    bx, [0xce8a]                 ; UNKNOWN
00D527  9A 02 00 35 5D        LCALL  0x5d35, 2                    ; UNKNOWN
00D52C  9A 1D 00 EF 21        LCALL  0x21ef, 0x1d                 ; UNKNOWN
00D531  8D 86 E0 FC           LEA    ax, [bp - 0x320]             ; UNKNOWN
00D535  16                    PUSH   ss                           ; UNKNOWN
00D536  50                    PUSH   ax                           ; UNKNOWN
00D537  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
00D53C  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00D540  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00D544  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00D548  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00D54C  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
00D550  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
00D554  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
00D558  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
00D55C  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00D55F  2B C0                 SUB    ax, ax                       ; UNKNOWN
00D561  99                    CDQ                                 ; UNKNOWN
00D562  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00D565  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
00D56A  6A 00                 PUSH   0                            ; UNKNOWN
00D56C  68 40 01              PUSH   0x140                        ; UNKNOWN
00D56F  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00D572  2B C0                 SUB    ax, ax                       ; UNKNOWN
00D574  99                    CDQ                                 ; UNKNOWN
00D575  2B DB                 SUB    bx, bx                       ; UNKNOWN
00D577  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
00D57C  8D 1E 5A 1C           LEA    bx, [0x1c5a]                 ; UNKNOWN
00D580  9A 0A 00 4D 5B        LCALL  0x5b4d, 0xa                  ; UNKNOWN
00D585  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
00D588  89 56 F6              MOV    word ptr [bp - 0xa], dx      ; UNKNOWN
00D58B  0B D0                 OR     dx, ax                       ; UNKNOWN
00D58D  74 05                 JE     0xd594                       ; UNKNOWN
00D58F  8B 56 F6              MOV    dx, word ptr [bp - 0xa]      ; UNKNOWN
00D592  EB 07                 JMP    0xd59b                       ; UNKNOWN
00D594  A1 B4 09              MOV    ax, word ptr [0x9b4]         ; UNKNOWN
00D597  8B 16 B6 09           MOV    dx, word ptr [0x9b6]         ; UNKNOWN
00D59B  A3 1C 0A              MOV    word ptr [0xa1c], ax         ; UNKNOWN
00D59E  89 16 1E 0A           MOV    word ptr [0xa1e], dx         ; UNKNOWN
00D5A2  8B 36 F2 09           MOV    si, word ptr [0x9f2]         ; UNKNOWN
00D5A6  8B 3E F8 09           MOV    di, word ptr [0x9f8]         ; UNKNOWN
00D5AA  A1 FA 09              MOV    ax, word ptr [0x9fa]         ; UNKNOWN
00D5AD  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
00D5B0  C7 06 F2 09 F2 00     MOV    word ptr [0x9f2], 0xf2       ; UNKNOWN
00D5B6  C7 06 F8 09 2F 00     MOV    word ptr [0x9f8], 0x2f       ; UNKNOWN
00D5BC  C7 06 FA 09 00 00     MOV    word ptr [0x9fa], 0          ; UNKNOWN
00D5C2  80 0E FE 09 18        OR     byte ptr [0x9fe], 0x18       ; UNKNOWN
00D5C7  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
00D5CA  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
00D5CF  89 36 F2 09           MOV    word ptr [0x9f2], si         ; UNKNOWN
00D5D3  89 3E F8 09           MOV    word ptr [0x9f8], di         ; UNKNOWN
00D5D7  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
00D5DA  A3 FA 09              MOV    word ptr [0x9fa], ax         ; UNKNOWN
00D5DD  9A 1D 00 EF 21        LCALL  0x21ef, 0x1d                 ; UNKNOWN
00D5E2  68 00 A0              PUSH   0xa000                       ; UNKNOWN
00D5E5  68 00 FC              PUSH   0xfc00                       ; UNKNOWN
00D5E8  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
00D5ED  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
00D5F0  0B 46 F4              OR     ax, word ptr [bp - 0xc]      ; UNKNOWN
00D5F3  74 0B                 JE     0xd600                       ; UNKNOWN
00D5F5  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
00D5F8  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
00D5FB  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
00D600  A1 20 0C              MOV    ax, word ptr [0xc20]         ; UNKNOWN
00D603  8B 16 22 0C           MOV    dx, word ptr [0xc22]         ; UNKNOWN
00D607  A3 1C 0A              MOV    word ptr [0xa1c], ax         ; UNKNOWN
00D60A  89 16 1E 0A           MOV    word ptr [0xa1e], dx         ; UNKNOWN
00D60E  C7 06 0C 0A 01 00     MOV    word ptr [0xa0c], 1          ; UNKNOWN
00D614  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
00D617  A3 14 0C              MOV    word ptr [0xc14], ax         ; UNKNOWN
00D61A  5E                    POP    si                           ; UNKNOWN
00D61B  5F                    POP    di                           ; UNKNOWN
00D61C  C9                    LEAVE                               ; UNKNOWN
00D61D  CB                    RETF                                ; UNKNOWN
