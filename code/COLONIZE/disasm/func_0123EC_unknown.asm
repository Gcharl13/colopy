; ============================================================================
; func_0123EC_unknown
; Region   : load_image
; Bytes    : file 0x0123EC..0x012676  (650 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0123EC  C8 20 00 00           ENTER  0x20, 0                      ; UNKNOWN
0123F0  56                    PUSH   si                           ; UNKNOWN
0123F1  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
0123F4  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
0123F7  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
0123FB  8A 47 05              MOV    al, byte ptr [bx + 5]        ; UNKNOWN
0123FE  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
012401  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
012404  A1 36 82              MOV    ax, word ptr [0x8236]        ; UNKNOWN
012407  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01240A  2B C0                 SUB    ax, ax                       ; UNKNOWN
01240C  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
01240F  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
012412  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
012415  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
012418  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
01241B  EB 71                 JMP    0x1248e                      ; UNKNOWN
01241D  39 46 EE              CMP    word ptr [bp - 0x12], ax     ; UNKNOWN
012420  75 08                 JNE    0x1242a                      ; UNKNOWN
012422  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
012425  01 46 EC              ADD    word ptr [bp - 0x14], ax     ; UNKNOWN
012428  EB 06                 JMP    0x12430                      ; UNKNOWN
01242A  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
01242D  01 46 F6              ADD    word ptr [bp - 0xa], ax      ; UNKNOWN
012430  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
012434  80 7F 05 00           CMP    byte ptr [bx + 5], 0         ; UNKNOWN
012438  7C 51                 JL     0x1248b                      ; UNKNOWN
01243A  8A 47 05              MOV    al, byte ptr [bx + 5]        ; UNKNOWN
01243D  8B C8                 MOV    cx, ax                       ; UNKNOWN
01243F  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
012442  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
012445  8A C1                 MOV    al, cl                       ; UNKNOWN
012447  83 E0 10              AND    ax, 0x10                     ; UNKNOWN
01244A  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
01244D  8A 4F 04              MOV    cl, byte ptr [bx + 4]        ; UNKNOWN
012450  2A ED                 SUB    ch, ch                       ; UNKNOWN
012452  01 4E F6              ADD    word ptr [bp - 0xa], cx      ; UNKNOWN
012455  0B C0                 OR     ax, ax                       ; UNKNOWN
012457  74 03                 JE     0x1245c                      ; UNKNOWN
012459  D1 66 F6              SHL    word ptr [bp - 0xa], 1       ; UNKNOWN
01245C  F6 47 03 04           TEST   byte ptr [bx + 3], 4         ; UNKNOWN
012460  74 03                 JE     0x12465                      ; UNKNOWN
012462  D1 66 F6              SHL    word ptr [bp - 0xa], 1       ; UNKNOWN
012465  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
012468  39 46 F2              CMP    word ptr [bp - 0xe], ax      ; UNKNOWN
01246B  75 08                 JNE    0x12475                      ; UNKNOWN
01246D  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
012470  01 46 EC              ADD    word ptr [bp - 0x14], ax     ; UNKNOWN
012473  EB 16                 JMP    0x1248b                      ; UNKNOWN
012475  39 46 EE              CMP    word ptr [bp - 0x12], ax     ; UNKNOWN
012478  75 08                 JNE    0x12482                      ; UNKNOWN
01247A  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
01247D  01 46 E8              ADD    word ptr [bp - 0x18], ax     ; UNKNOWN
012480  EB 09                 JMP    0x1248b                      ; UNKNOWN
012482  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
012485  01 46 F0              ADD    word ptr [bp - 0x10], ax     ; UNKNOWN
012488  01 46 F4              ADD    word ptr [bp - 0xc], ax      ; UNKNOWN
01248B  FF 46 EA              INC    word ptr [bp - 0x16]         ; UNKNOWN
01248E  A1 12 3E              MOV    ax, word ptr [0x3e12]        ; UNKNOWN
012491  39 46 EA              CMP    word ptr [bp - 0x16], ax     ; UNKNOWN
012494  7D 3F                 JGE    0x124d5                      ; UNKNOWN
012496  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
012499  9A 32 00 BA 33        LCALL  0x33ba, 0x32                 ; UNKNOWN
01249E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0124A1  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
0124A4  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
0124A8  38 47 02              CMP    byte ptr [bx + 2], al        ; UNKNOWN
0124AB  75 DE                 JNE    0x1248b                      ; UNKNOWN
0124AD  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
0124B2  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
0124B5  50                    PUSH   ax                           ; UNKNOWN
0124B6  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
0124B9  9A F5 03 D2 14        LCALL  0x14d2, 0x3f5                ; UNKNOWN
0124BE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0124C1  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
0124C4  3B 46 F2              CMP    ax, word ptr [bp - 0xe]      ; UNKNOWN
0124C7  74 03                 JE     0x124cc                      ; UNKNOWN
0124C9  E9 51 FF              JMP    0x1241d                      ; UNKNOWN
0124CC  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
0124CF  01 46 E8              ADD    word ptr [bp - 0x18], ax     ; UNKNOWN
0124D2  E9 5B FF              JMP    0x12430                      ; UNKNOWN
0124D5  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
0124D8  9A 32 00 BA 33        LCALL  0x33ba, 0x32                 ; UNKNOWN
0124DD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0124E0  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0124E4  80 BF 97 88 03        CMP    byte ptr [bx - 0x7769], 3    ; UNKNOWN
0124E9  75 05                 JNE    0x124f0                      ; UNKNOWN
0124EB  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0124EE  EB 02                 JMP    0x124f2                      ; UNKNOWN
0124F0  2B C0                 SUB    ax, ax                       ; UNKNOWN
0124F2  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0124F5  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
0124F9  8A 47 05              MOV    al, byte ptr [bx + 5]        ; UNKNOWN
0124FC  83 E0 10              AND    ax, 0x10                     ; UNKNOWN
0124FF  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
012502  8A 47 03              MOV    al, byte ptr [bx + 3]        ; UNKNOWN
012505  83 E0 04              AND    ax, 4                        ; UNKNOWN
012508  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
01250B  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
01250E  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
012512  8B F0                 MOV    si, ax                       ; UNKNOWN
012514  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
012519  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01251C  8B CE                 MOV    cx, si                       ; UNKNOWN
01251E  D3 E0                 SHL    ax, cl                       ; UNKNOWN
012520  01 46 E8              ADD    word ptr [bp - 0x18], ax     ; UNKNOWN
012523  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
012526  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
01252A  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
01252F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
012532  B1 01                 MOV    cl, 1                        ; UNKNOWN
012534  2A 4E E4              SUB    cl, byte ptr [bp - 0x1c]     ; UNKNOWN
012537  D3 F8                 SAR    ax, cl                       ; UNKNOWN
012539  01 46 EC              ADD    word ptr [bp - 0x14], ax     ; UNKNOWN
01253C  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
01253F  50                    PUSH   ax                           ; UNKNOWN
012540  9A A1 00 BA 33        LCALL  0x33ba, 0xa1                 ; UNKNOWN
012545  83 C4 02              ADD    sp, 2                        ; UNKNOWN
012548  40                    INC    ax                           ; UNKNOWN
012549  01 46 F0              ADD    word ptr [bp - 0x10], ax     ; UNKNOWN
01254C  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
01254F  9A A1 00 BA 33        LCALL  0x33ba, 0xa1                 ; UNKNOWN
012554  83 C4 02              ADD    sp, 2                        ; UNKNOWN
012557  40                    INC    ax                           ; UNKNOWN
012558  01 46 F4              ADD    word ptr [bp - 0xc], ax      ; UNKNOWN
01255B  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0      ; UNKNOWN
01255F  74 27                 JE     0x12588                      ; UNKNOWN
012561  6A 14                 PUSH   0x14                         ; UNKNOWN
012563  6A 01                 PUSH   1                            ; UNKNOWN
012565  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
01256A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01256D  01 46 E8              ADD    word ptr [bp - 0x18], ax     ; UNKNOWN
012570  6A 14                 PUSH   0x14                         ; UNKNOWN
012572  6A 01                 PUSH   1                            ; UNKNOWN
012574  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
012579  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01257C  03 46 EC              ADD    ax, word ptr [bp - 0x14]     ; UNKNOWN
01257F  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
012582  D1 66 F4              SHL    word ptr [bp - 0xc], 1       ; UNKNOWN
012585  D1 66 F0              SHL    word ptr [bp - 0x10], 1      ; UNKNOWN
012588  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
01258C  74 06                 JE     0x12594                      ; UNKNOWN
01258E  D1 66 E8              SHL    word ptr [bp - 0x18], 1      ; UNKNOWN
012591  D1 66 F4              SHL    word ptr [bp - 0xc], 1       ; UNKNOWN
012594  83 7E E0 00           CMP    word ptr [bp - 0x20], 0      ; UNKNOWN
012598  74 06                 JE     0x125a0                      ; UNKNOWN
01259A  D1 66 EC              SHL    word ptr [bp - 0x14], 1      ; UNKNOWN
01259D  D1 66 F0              SHL    word ptr [bp - 0x10], 1      ; UNKNOWN
0125A0  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
0125A3  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
0125A8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0125AB  50                    PUSH   ax                           ; UNKNOWN
0125AC  6A 00                 PUSH   0                            ; UNKNOWN
0125AE  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
0125B3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0125B6  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
0125B9  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
0125BE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0125C1  50                    PUSH   ax                           ; UNKNOWN
0125C2  6A 01                 PUSH   1                            ; UNKNOWN
0125C4  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
0125C9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0125CC  FF 36 84 C0           PUSH   word ptr [0xc084]            ; UNKNOWN
0125D0  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
0125D5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0125D8  50                    PUSH   ax                           ; UNKNOWN
0125D9  6A 02                 PUSH   2                            ; UNKNOWN
0125DB  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
0125E0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0125E3  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
0125E6  03 46 E8              ADD    ax, word ptr [bp - 0x18]     ; UNKNOWN
0125E9  50                    PUSH   ax                           ; UNKNOWN
0125EA  6A 01                 PUSH   1                            ; UNKNOWN
0125EC  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
0125F1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0125F4  3B 46 E8              CMP    ax, word ptr [bp - 0x18]     ; UNKNOWN
0125F7  7F 2F                 JG     0x12628                      ; UNKNOWN
0125F9  B8 24 80              MOV    ax, 0x8024                   ; UNKNOWN
0125FC  9A 0A 00 11 5D        LCALL  0x5d11, 0xa                  ; UNKNOWN
012601  6A 04                 PUSH   4                            ; UNKNOWN
012603  68 24 25              PUSH   0x2524                       ; UNKNOWN
012606  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
01260B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01260E  8A 46 EE              MOV    al, byte ptr [bp - 0x12]     ; UNKNOWN
012611  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
012615  88 47 05              MOV    byte ptr [bx + 5], al        ; UNKNOWN
012618  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
01261C  74 05                 JE     0x12623                      ; UNKNOWN
01261E  0C 10                 OR     al, 0x10                     ; UNKNOWN
012620  88 47 05              MOV    byte ptr [bx + 5], al        ; UNKNOWN
012623  F7 5E F0              NEG    word ptr [bp - 0x10]         ; UNKNOWN
012626  EB 18                 JMP    0x12640                      ; UNKNOWN
012628  B8 53 00              MOV    ax, 0x53                     ; UNKNOWN
01262B  9A 0A 00 11 5D        LCALL  0x5d11, 0xa                  ; UNKNOWN
012630  6A 04                 PUSH   4                            ; UNKNOWN
012632  68 2C 25              PUSH   0x252c                       ; UNKNOWN
012635  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
01263A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01263D  F7 5E F4              NEG    word ptr [bp - 0xc]          ; UNKNOWN
012640  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
012643  9A 1C 08 B7 36        LCALL  0x36b7, 0x81c                ; UNKNOWN
012648  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01264B  6A 00                 PUSH   0                            ; UNKNOWN
01264D  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
012650  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
012653  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
012657  9A F6 00 D2 14        LCALL  0x14d2, 0xf6                 ; UNKNOWN
01265C  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01265F  6A 00                 PUSH   0                            ; UNKNOWN
012661  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
012664  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
012667  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
01266B  9A F6 00 D2 14        LCALL  0x14d2, 0xf6                 ; UNKNOWN
012670  83 C4 08              ADD    sp, 8                        ; UNKNOWN
012673  5E                    POP    si                           ; UNKNOWN
012674  C9                    LEAVE                               ; UNKNOWN
012675  CB                    RETF                                ; UNKNOWN
