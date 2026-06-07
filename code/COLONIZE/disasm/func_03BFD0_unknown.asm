; ============================================================================
; func_03BFD0_unknown
; Region   : load_image
; Bytes    : file 0x03BFD0..0x03C275  (677 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03BFD0  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
03BFD4  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
03BFD9  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
03BFDE  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
03BFE3  A1 DA 79              MOV    ax, word ptr [0x79da]        ; UNKNOWN
03BFE6  3D 11 01              CMP    ax, 0x111                    ; UNKNOWN
03BFE9  74 3A                 JE     0x3c025                      ; UNKNOWN
03BFEB  7E 03                 JLE    0x3bff0                      ; UNKNOWN
03BFED  E9 EA 01              JMP    0x3c1da                      ; UNKNOWN
03BFF0  83 F8 33              CMP    ax, 0x33                     ; UNKNOWN
03BFF3  75 03                 JNE    0x3bff8                      ; UNKNOWN
03BFF5  E9 28 01              JMP    0x3c120                      ; UNKNOWN
03BFF8  7E 03                 JLE    0x3bffd                      ; UNKNOWN
03BFFA  E9 A8 01              JMP    0x3c1a5                      ; UNKNOWN
03BFFD  83 F8 32              CMP    ax, 0x32                     ; UNKNOWN
03C000  75 03                 JNE    0x3c005                      ; UNKNOWN
03C002  E9 C9 00              JMP    0x3c0ce                      ; UNKNOWN
03C005  76 03                 JBE    0x3c00a                      ; UNKNOWN
03C007  E9 B1 01              JMP    0x3c1bb                      ; UNKNOWN
03C00A  2C 11                 SUB    al, 0x11                     ; UNKNOWN
03C00C  75 03                 JNE    0x3c011                      ; UNKNOWN
03C00E  E9 83 00              JMP    0x3c094                      ; UNKNOWN
03C011  2C 07                 SUB    al, 7                        ; UNKNOWN
03C013  75 02                 JNE    0x3c017                      ; UNKNOWN
03C015  EB 7D                 JMP    0x3c094                      ; UNKNOWN
03C017  2C 03                 SUB    al, 3                        ; UNKNOWN
03C019  74 79                 JE     0x3c094                      ; UNKNOWN
03C01B  2C 16                 SUB    al, 0x16                     ; UNKNOWN
03C01D  75 03                 JNE    0x3c022                      ; UNKNOWN
03C01F  E9 26 01              JMP    0x3c148                      ; UNKNOWN
03C022  E9 96 01              JMP    0x3c1bb                      ; UNKNOWN
03C025  8A 26 FB 3D           MOV    ah, byte ptr [0x3dfb]        ; UNKNOWN
03C029  25 00 20              AND    ax, 0x2000                   ; UNKNOWN
03C02C  74 25                 JE     0x3c053                      ; UNKNOWN
03C02E  50                    PUSH   ax                           ; UNKNOWN
03C02F  6A 06                 PUSH   6                            ; UNKNOWN
03C031  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
03C035  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
03C039  9A 0F 05 67 18        LCALL  0x1867, 0x50f                ; UNKNOWN
03C03E  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03C041  6A 01                 PUSH   1                            ; UNKNOWN
03C043  9A 8B 04 0B 38        LCALL  0x380b, 0x48b                ; UNKNOWN
03C048  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03C04B  80 36 FB 3D 20        XOR    byte ptr [0x3dfb], 0x20      ; UNKNOWN
03C050  E9 D7 01              JMP    0x3c22a                      ; UNKNOWN
03C053  83 3E FA 0A 00        CMP    word ptr [0xafa], 0          ; UNKNOWN
03C058  75 08                 JNE    0x3c062                      ; UNKNOWN
03C05A  81 3E DA 79 11 01     CMP    word ptr [0x79da], 0x111     ; UNKNOWN
03C060  EB 0D                 JMP    0x3c06f                      ; UNKNOWN
03C062  83 3E FA 0A 01        CMP    word ptr [0xafa], 1          ; UNKNOWN
03C067  75 17                 JNE    0x3c080                      ; UNKNOWN
03C069  81 3E DA 79 17 01     CMP    word ptr [0x79da], 0x117     ; UNKNOWN
03C06F  74 03                 JE     0x3c074                      ; UNKNOWN
03C071  E9 B6 01              JMP    0x3c22a                      ; UNKNOWN
03C074  FF 06 FA 0A           INC    word ptr [0xafa]             ; UNKNOWN
03C078  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
03C07D  E9 AA 01              JMP    0x3c22a                      ; UNKNOWN
03C080  81 3E DA 79 31 01     CMP    word ptr [0x79da], 0x131     ; UNKNOWN
03C086  74 03                 JE     0x3c08b                      ; UNKNOWN
03C088  E9 9F 01              JMP    0x3c22a                      ; UNKNOWN
03C08B  8A 26 FB 3D           MOV    ah, byte ptr [0x3dfb]        ; UNKNOWN
03C08F  25 00 20              AND    ax, 0x2000                   ; UNKNOWN
03C092  EB 9A                 JMP    0x3c02e                      ; UNKNOWN
03C094  8D 1E C0 24           LEA    bx, [0x24c0]                 ; UNKNOWN
03C098  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
03C09D  48                    DEC    ax                           ; UNKNOWN
03C09E  74 03                 JE     0x3c0a3                      ; UNKNOWN
03C0A0  E9 87 01              JMP    0x3c22a                      ; UNKNOWN
03C0A3  C7 06 3A 3E 00 00     MOV    word ptr [0x3e3a], 0         ; UNKNOWN
03C0A9  E9 7E 01              JMP    0x3c22a                      ; UNKNOWN
03C0AC  6A 01                 PUSH   1                            ; UNKNOWN
03C0AE  FF 0E 2E 0B           DEC    word ptr [0xb2e]             ; UNKNOWN
03C0B2  A1 2E 0B              MOV    ax, word ptr [0xb2e]         ; UNKNOWN
03C0B5  0B C0                 OR     ax, ax                       ; UNKNOWN
03C0B7  7D 02                 JGE    0x3c0bb                      ; UNKNOWN
03C0B9  2B C0                 SUB    ax, ax                       ; UNKNOWN
03C0BB  A3 2E 0B              MOV    word ptr [0xb2e], ax         ; UNKNOWN
03C0BE  50                    PUSH   ax                           ; UNKNOWN
03C0BF  FF 36 2C 0B           PUSH   word ptr [0xb2c]             ; UNKNOWN
03C0C3  9A 9C 02 0B 38        LCALL  0x380b, 0x29c                ; UNKNOWN
03C0C8  83 C4 06              ADD    sp, 6                        ; UNKNOWN
03C0CB  E9 5C 01              JMP    0x3c22a                      ; UNKNOWN
03C0CE  6A 01                 PUSH   1                            ; UNKNOWN
03C0D0  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03C0D3  48                    DEC    ax                           ; UNKNOWN
03C0D4  FF 06 2E 0B           INC    word ptr [0xb2e]             ; UNKNOWN
03C0D8  3B 06 2E 0B           CMP    ax, word ptr [0xb2e]         ; UNKNOWN
03C0DC  7E DD                 JLE    0x3c0bb                      ; UNKNOWN
03C0DE  A1 2E 0B              MOV    ax, word ptr [0xb2e]         ; UNKNOWN
03C0E1  EB D8                 JMP    0x3c0bb                      ; UNKNOWN
03C0E3  6A 01                 PUSH   1                            ; UNKNOWN
03C0E5  FF 36 2E 0B           PUSH   word ptr [0xb2e]             ; UNKNOWN
03C0E9  FF 0E 2C 0B           DEC    word ptr [0xb2c]             ; UNKNOWN
03C0ED  A1 2C 0B              MOV    ax, word ptr [0xb2c]         ; UNKNOWN
03C0F0  0B C0                 OR     ax, ax                       ; UNKNOWN
03C0F2  7D 02                 JGE    0x3c0f6                      ; UNKNOWN
03C0F4  2B C0                 SUB    ax, ax                       ; UNKNOWN
03C0F6  A3 2C 0B              MOV    word ptr [0xb2c], ax         ; UNKNOWN
03C0F9  50                    PUSH   ax                           ; UNKNOWN
03C0FA  EB C7                 JMP    0x3c0c3                      ; UNKNOWN
03C0FC  6A 01                 PUSH   1                            ; UNKNOWN
03C0FE  FF 36 2E 0B           PUSH   word ptr [0xb2e]             ; UNKNOWN
03C102  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03C105  48                    DEC    ax                           ; UNKNOWN
03C106  FF 06 2C 0B           INC    word ptr [0xb2c]             ; UNKNOWN
03C10A  3B 06 2C 0B           CMP    ax, word ptr [0xb2c]         ; UNKNOWN
03C10E  7E E6                 JLE    0x3c0f6                      ; UNKNOWN
03C110  A1 2C 0B              MOV    ax, word ptr [0xb2c]         ; UNKNOWN
03C113  EB E1                 JMP    0x3c0f6                      ; UNKNOWN
03C115  6A 01                 PUSH   1                            ; UNKNOWN
03C117  A1 38 0B              MOV    ax, word ptr [0xb38]         ; UNKNOWN
03C11A  29 06 2E 0B           SUB    word ptr [0xb2e], ax         ; UNKNOWN
03C11E  EB 92                 JMP    0x3c0b2                      ; UNKNOWN
03C120  6A 01                 PUSH   1                            ; UNKNOWN
03C122  A1 38 0B              MOV    ax, word ptr [0xb38]         ; UNKNOWN
03C125  01 06 2E 0B           ADD    word ptr [0xb2e], ax         ; UNKNOWN
03C129  A1 2E 0B              MOV    ax, word ptr [0xb2e]         ; UNKNOWN
03C12C  8B 0E 8A 82           MOV    cx, word ptr [0x828a]        ; UNKNOWN
03C130  49                    DEC    cx                           ; UNKNOWN
03C131  3B C1                 CMP    ax, cx                       ; UNKNOWN
03C133  7E 86                 JLE    0x3c0bb                      ; UNKNOWN
03C135  8B C1                 MOV    ax, cx                       ; UNKNOWN
03C137  EB 82                 JMP    0x3c0bb                      ; UNKNOWN
03C139  6A 01                 PUSH   1                            ; UNKNOWN
03C13B  FF 36 2E 0B           PUSH   word ptr [0xb2e]             ; UNKNOWN
03C13F  A1 38 0B              MOV    ax, word ptr [0xb38]         ; UNKNOWN
03C142  29 06 2C 0B           SUB    word ptr [0xb2c], ax         ; UNKNOWN
03C146  EB A5                 JMP    0x3c0ed                      ; UNKNOWN
03C148  6A 01                 PUSH   1                            ; UNKNOWN
03C14A  FF 36 2E 0B           PUSH   word ptr [0xb2e]             ; UNKNOWN
03C14E  A1 38 0B              MOV    ax, word ptr [0xb38]         ; UNKNOWN
03C151  01 06 2C 0B           ADD    word ptr [0xb2c], ax         ; UNKNOWN
03C155  A1 2C 0B              MOV    ax, word ptr [0xb2c]         ; UNKNOWN
03C158  8B 0E 88 82           MOV    cx, word ptr [0x8288]        ; UNKNOWN
03C15C  49                    DEC    cx                           ; UNKNOWN
03C15D  3B C1                 CMP    ax, cx                       ; UNKNOWN
03C15F  7E 95                 JLE    0x3c0f6                      ; UNKNOWN
03C161  8B C1                 MOV    ax, cx                       ; UNKNOWN
03C163  EB 91                 JMP    0x3c0f6                      ; UNKNOWN
03C165  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03C16A  E9 BD 00              JMP    0x3c22a                      ; UNKNOWN
03C16D  C7 46 FE 04 00        MOV    word ptr [bp - 2], 4         ; UNKNOWN
03C172  E9 B5 00              JMP    0x3c22a                      ; UNKNOWN
03C175  C7 46 FE 06 00        MOV    word ptr [bp - 2], 6         ; UNKNOWN
03C17A  E9 AD 00              JMP    0x3c22a                      ; UNKNOWN
03C17D  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2         ; UNKNOWN
03C182  E9 A5 00              JMP    0x3c22a                      ; UNKNOWN
03C185  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
03C18A  E9 9D 00              JMP    0x3c22a                      ; UNKNOWN
03C18D  C7 46 FE 03 00        MOV    word ptr [bp - 2], 3         ; UNKNOWN
03C192  E9 95 00              JMP    0x3c22a                      ; UNKNOWN
03C195  C7 46 FE 07 00        MOV    word ptr [bp - 2], 7         ; UNKNOWN
03C19A  E9 8D 00              JMP    0x3c22a                      ; UNKNOWN
03C19D  C7 46 FE 05 00        MOV    word ptr [bp - 2], 5         ; UNKNOWN
03C1A2  E9 85 00              JMP    0x3c22a                      ; UNKNOWN
03C1A5  83 F8 37              CMP    ax, 0x37                     ; UNKNOWN
03C1A8  74 8F                 JE     0x3c139                      ; UNKNOWN
03C1AA  7F 16                 JG     0x3c1c2                      ; UNKNOWN
03C1AC  83 E8 34              SUB    ax, 0x34                     ; UNKNOWN
03C1AF  75 03                 JNE    0x3c1b4                      ; UNKNOWN
03C1B1  E9 2F FF              JMP    0x3c0e3                      ; UNKNOWN
03C1B4  48                    DEC    ax                           ; UNKNOWN
03C1B5  48                    DEC    ax                           ; UNKNOWN
03C1B6  75 03                 JNE    0x3c1bb                      ; UNKNOWN
03C1B8  E9 41 FF              JMP    0x3c0fc                      ; UNKNOWN
03C1BB  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
03C1C0  EB 68                 JMP    0x3c22a                      ; UNKNOWN
03C1C2  83 E8 38              SUB    ax, 0x38                     ; UNKNOWN
03C1C5  75 03                 JNE    0x3c1ca                      ; UNKNOWN
03C1C7  E9 E2 FE              JMP    0x3c0ac                      ; UNKNOWN
03C1CA  48                    DEC    ax                           ; UNKNOWN
03C1CB  75 03                 JNE    0x3c1d0                      ; UNKNOWN
03C1CD  E9 45 FF              JMP    0x3c115                      ; UNKNOWN
03C1D0  2D D7 00              SUB    ax, 0xd7                     ; UNKNOWN
03C1D3  75 03                 JNE    0x3c1d8                      ; UNKNOWN
03C1D5  E9 BC FE              JMP    0x3c094                      ; UNKNOWN
03C1D8  EB E1                 JMP    0x3c1bb                      ; UNKNOWN
03C1DA  3D 48 01              CMP    ax, 0x148                    ; UNKNOWN
03C1DD  74 86                 JE     0x3c165                      ; UNKNOWN
03C1DF  7F 27                 JG     0x3c208                      ; UNKNOWN
03C1E1  2D 17 01              SUB    ax, 0x117                    ; UNKNOWN
03C1E4  75 03                 JNE    0x3c1e9                      ; UNKNOWN
03C1E6  E9 3C FE              JMP    0x3c025                      ; UNKNOWN
03C1E9  83 E8 0E              SUB    ax, 0xe                      ; UNKNOWN
03C1EC  75 03                 JNE    0x3c1f1                      ; UNKNOWN
03C1EE  E9 34 FE              JMP    0x3c025                      ; UNKNOWN
03C1F1  83 E8 08              SUB    ax, 8                        ; UNKNOWN
03C1F4  75 03                 JNE    0x3c1f9                      ; UNKNOWN
03C1F6  E9 9B FE              JMP    0x3c094                      ; UNKNOWN
03C1F9  83 E8 04              SUB    ax, 4                        ; UNKNOWN
03C1FC  75 03                 JNE    0x3c201                      ; UNKNOWN
03C1FE  E9 24 FE              JMP    0x3c025                      ; UNKNOWN
03C201  83 E8 16              SUB    ax, 0x16                     ; UNKNOWN
03C204  74 8F                 JE     0x3c195                      ; UNKNOWN
03C206  EB B3                 JMP    0x3c1bb                      ; UNKNOWN
03C208  2D 49 01              SUB    ax, 0x149                    ; UNKNOWN
03C20B  83 F8 08              CMP    ax, 8                        ; UNKNOWN
03C20E  77 AB                 JA     0x3c1bb                      ; UNKNOWN
03C210  D1 E0                 SHL    ax, 1                        ; UNKNOWN
03C212  93                    XCHG   bx, ax                       ; UNKNOWN
03C213  2E FF A7 08 32        JMP    word ptr cs:[bx + 0x3208]    ; UNKNOWN
03C218  75 31                 JNE    0x3c24b                      ; UNKNOWN
03C21A  AB                    STOSW  word ptr es:[di], ax         ; UNKNOWN
03C21B  31 65 31              XOR    word ptr [di + 0x31], sp     ; UNKNOWN
03C21E  AB                    STOSW  word ptr es:[di], ax         ; UNKNOWN
03C21F  31 6D 31              XOR    word ptr [di + 0x31], bp     ; UNKNOWN
03C222  AB                    STOSW  word ptr es:[di], ax         ; UNKNOWN
03C223  31 8D 31 5D           XOR    word ptr [di + 0x5d31], cx   ; UNKNOWN
03C227  31 7D 31              XOR    word ptr [di + 0x31], di     ; UNKNOWN
03C22A  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
03C22E  75 06                 JNE    0x3c236                      ; UNKNOWN
03C230  C7 06 FA 0A 00 00     MOV    word ptr [0xafa], 0          ; UNKNOWN
03C236  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
03C23A  7C 30                 JL     0x3c26c                      ; UNKNOWN
03C23C  83 3E 08 3E 00        CMP    word ptr [0x3e08], 0         ; UNKNOWN
03C241  75 19                 JNE    0x3c25c                      ; UNKNOWN
03C243  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
03C246  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
03C24A  98                    CWDE                                ; UNKNOWN
03C24B  50                    PUSH   ax                           ; UNKNOWN
03C24C  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
03C250  98                    CWDE                                ; UNKNOWN
03C251  50                    PUSH   ax                           ; UNKNOWN
03C252  9A 9D 04 C1 3D        LCALL  0x3dc1, 0x49d                ; UNKNOWN
03C257  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03C25A  EB 0B                 JMP    0x3c267                      ; UNKNOWN
03C25C  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
03C25F  9A C6 03 0B 38        LCALL  0x380b, 0x3c6                ; UNKNOWN
03C264  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03C267  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
03C26C  0E                    PUSH   cs                           ; UNKNOWN
03C26D  E8 C1 D8              CALL   0x39b31                      ; UNKNOWN
03C270  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
03C273  C9                    LEAVE                               ; UNKNOWN
03C274  CB                    RETF                                ; UNKNOWN
