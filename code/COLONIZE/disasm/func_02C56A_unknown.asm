; ============================================================================
; func_02C56A_unknown
; Region   : load_image
; Bytes    : file 0x02C56A..0x02C762  (504 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02C56A  C8 12 03 00           ENTER  0x312, 0                     ; UNKNOWN
02C56E  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
02C573  8D 86 F0 FC           LEA    ax, [bp - 0x310]             ; UNKNOWN
02C577  16                    PUSH   ss                           ; UNKNOWN
02C578  50                    PUSH   ax                           ; UNKNOWN
02C579  2B C0                 SUB    ax, ax                       ; UNKNOWN
02C57B  A3 B6 40              MOV    word ptr [0x40b6], ax        ; UNKNOWN
02C57E  50                    PUSH   ax                           ; UNKNOWN
02C57F  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
02C583  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
02C587  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
02C58B  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
02C58F  68 E6 1D              PUSH   0x1de6                       ; UNKNOWN
02C592  9A 0A 00 69 1A        LCALL  0x1a69, 0xa                  ; UNKNOWN
02C597  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
02C59A  0B C0                 OR     ax, ax                       ; UNKNOWN
02C59C  74 03                 JE     0x2c5a1                      ; UNKNOWN
02C59E  E9 12 02              JMP    0x2c7b3                      ; UNKNOWN
02C5A1  9A 1D 00 EF 21        LCALL  0x21ef, 0x1d                 ; UNKNOWN
02C5A6  8D 86 F0 FC           LEA    ax, [bp - 0x310]             ; UNKNOWN
02C5AA  16                    PUSH   ss                           ; UNKNOWN
02C5AB  50                    PUSH   ax                           ; UNKNOWN
02C5AC  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
02C5B1  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
02C5B5  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
02C5B9  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
02C5BD  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
02C5C1  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02C5C5  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02C5C9  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02C5CD  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02C5D1  68 C8 00              PUSH   0xc8                         ; UNKNOWN
02C5D4  2B C0                 SUB    ax, ax                       ; UNKNOWN
02C5D6  99                    CDQ                                 ; UNKNOWN
02C5D7  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
02C5DA  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
02C5DF  6A 00                 PUSH   0                            ; UNKNOWN
02C5E1  68 40 01              PUSH   0x140                        ; UNKNOWN
02C5E4  68 C8 00              PUSH   0xc8                         ; UNKNOWN
02C5E7  2B C0                 SUB    ax, ax                       ; UNKNOWN
02C5E9  99                    CDQ                                 ; UNKNOWN
02C5EA  2B DB                 SUB    bx, bx                       ; UNKNOWN
02C5EC  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
02C5F1  0E                    PUSH   cs                           ; UNKNOWN
02C5F2  E8 A9 FE              CALL   0x2c49e                      ; UNKNOWN
02C5F5  9A 2F 00 8F 5C        LCALL  0x5c8f, 0x2f                 ; UNKNOWN
02C5FA  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
02C5FF  2B C0                 SUB    ax, ax                       ; UNKNOWN
02C601  9A 55 00 8F 5C        LCALL  0x5c8f, 0x55                 ; UNKNOWN
02C606  A1 B6 40              MOV    ax, word ptr [0x40b6]        ; UNKNOWN
02C609  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02C60C  9A 02 00 9A 5B        LCALL  0x5b9a, 2                    ; UNKNOWN
02C611  0B C0                 OR     ax, ax                       ; UNKNOWN
02C613  74 31                 JE     0x2c646                      ; UNKNOWN
02C615  9A 14 00 9A 5B        LCALL  0x5b9a, 0x14                 ; UNKNOWN
02C61A  89 86 EE FC           MOV    word ptr [bp - 0x312], ax    ; UNKNOWN
02C61E  83 F8 20              CMP    ax, 0x20                     ; UNKNOWN
02C621  75 03                 JNE    0x2c626                      ; UNKNOWN
02C623  E9 9E 00              JMP    0x2c6c4                      ; UNKNOWN
02C626  7E 03                 JLE    0x2c62b                      ; UNKNOWN
02C628  E9 A9 00              JMP    0x2c6d4                      ; UNKNOWN
02C62B  83 F8 1B              CMP    ax, 0x1b                     ; UNKNOWN
02C62E  75 03                 JNE    0x2c633                      ; UNKNOWN
02C630  E9 80 01              JMP    0x2c7b3                      ; UNKNOWN
02C633  77 11                 JA     0x2c646                      ; UNKNOWN
02C635  2C 08                 SUB    al, 8                        ; UNKNOWN
02C637  74 29                 JE     0x2c662                      ; UNKNOWN
02C639  FE C8                 DEC    al                           ; UNKNOWN
02C63B  74 5F                 JE     0x2c69c                      ; UNKNOWN
02C63D  2C 04                 SUB    al, 4                        ; UNKNOWN
02C63F  75 05                 JNE    0x2c646                      ; UNKNOWN
02C641  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
02C646  83 3E EA 0E 00        CMP    word ptr [0xeea], 0          ; UNKNOWN
02C64B  75 03                 JNE    0x2c650                      ; UNKNOWN
02C64D  E9 4B 01              JMP    0x2c79b                      ; UNKNOWN
02C650  83 3E F0 0E 00        CMP    word ptr [0xef0], 0          ; UNKNOWN
02C655  75 03                 JNE    0x2c65a                      ; UNKNOWN
02C657  E9 41 01              JMP    0x2c79b                      ; UNKNOWN
02C65A  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; UNKNOWN
02C65F  E9 17 01              JMP    0x2c779                      ; UNKNOWN
02C662  A1 B6 40              MOV    ax, word ptr [0x40b6]        ; UNKNOWN
02C665  83 C0 03              ADD    ax, 3                        ; UNKNOWN
02C668  B9 04 00              MOV    cx, 4                        ; UNKNOWN
02C66B  99                    CDQ                                 ; UNKNOWN
02C66C  F7 F9                 IDIV   cx                           ; UNKNOWN
02C66E  89 16 B6 40           MOV    word ptr [0x40b6], dx        ; UNKNOWN
02C672  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
02C675  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02C677  FF B7 7C 0B           PUSH   word ptr [bx + 0xb7c]        ; UNKNOWN
02C67B  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02C67E  0E                    PUSH   cs                           ; UNKNOWN
02C67F  E8 A4 FC              CALL   0x2c326                      ; UNKNOWN
02C682  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02C685  8B 1E B6 40           MOV    bx, word ptr [0x40b6]        ; UNKNOWN
02C689  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02C68B  FF B7 7C 0B           PUSH   word ptr [bx + 0xb7c]        ; UNKNOWN
02C68F  FF 36 B6 40           PUSH   word ptr [0x40b6]            ; UNKNOWN
02C693  0E                    PUSH   cs                           ; UNKNOWN
02C694  E8 8F FC              CALL   0x2c326                      ; UNKNOWN
02C697  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02C69A  EB AA                 JMP    0x2c646                      ; UNKNOWN
02C69C  A1 B6 40              MOV    ax, word ptr [0x40b6]        ; UNKNOWN
02C69F  40                    INC    ax                           ; UNKNOWN
02C6A0  EB C6                 JMP    0x2c668                      ; UNKNOWN
02C6A2  8B 1E B6 40           MOV    bx, word ptr [0x40b6]        ; UNKNOWN
02C6A6  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02C6A8  8B 87 7C 0B           MOV    ax, word ptr [bx + 0xb7c]    ; UNKNOWN
02C6AC  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02C6AF  40                    INC    ax                           ; UNKNOWN
02C6B0  40                    INC    ax                           ; UNKNOWN
02C6B1  B9 03 00              MOV    cx, 3                        ; UNKNOWN
02C6B4  99                    CDQ                                 ; UNKNOWN
02C6B5  F7 F9                 IDIV   cx                           ; UNKNOWN
02C6B7  89 97 7C 0B           MOV    word ptr [bx + 0xb7c], dx    ; UNKNOWN
02C6BB  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02C6BE  FF 36 B6 40           PUSH   word ptr [0x40b6]            ; UNKNOWN
02C6C2  EB BA                 JMP    0x2c67e                      ; UNKNOWN
02C6C4  8B 1E B6 40           MOV    bx, word ptr [0x40b6]        ; UNKNOWN
02C6C8  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02C6CA  8B 87 7C 0B           MOV    ax, word ptr [bx + 0xb7c]    ; UNKNOWN
02C6CE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02C6D1  40                    INC    ax                           ; UNKNOWN
02C6D2  EB DD                 JMP    0x2c6b1                      ; UNKNOWN
02C6D4  2D 48 01              SUB    ax, 0x148                    ; UNKNOWN
02C6D7  74 C9                 JE     0x2c6a2                      ; UNKNOWN
02C6D9  83 E8 03              SUB    ax, 3                        ; UNKNOWN
02C6DC  74 84                 JE     0x2c662                      ; UNKNOWN
02C6DE  48                    DEC    ax                           ; UNKNOWN
02C6DF  48                    DEC    ax                           ; UNKNOWN
02C6E0  74 BA                 JE     0x2c69c                      ; UNKNOWN
02C6E2  83 E8 03              SUB    ax, 3                        ; UNKNOWN
02C6E5  74 DD                 JE     0x2c6c4                      ; UNKNOWN
02C6E7  E9 5C FF              JMP    0x2c646                      ; UNKNOWN
02C6EA  FF 46 F0              INC    word ptr [bp - 0x10]         ; UNKNOWN
02C6ED  83 7E F0 03           CMP    word ptr [bp - 0x10], 3      ; UNKNOWN
02C6F1  7C 03                 JL     0x2c6f6                      ; UNKNOWN
02C6F3  E9 80 00              JMP    0x2c776                      ; UNKNOWN
02C6F6  8D 46 F2              LEA    ax, [bp - 0xe]               ; UNKNOWN
02C6F9  50                    PUSH   ax                           ; UNKNOWN
02C6FA  8D 4E F6              LEA    cx, [bp - 0xa]               ; UNKNOWN
02C6FD  51                    PUSH   cx                           ; UNKNOWN
02C6FE  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
02C701  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
02C704  0E                    PUSH   cs                           ; UNKNOWN
02C705  E8 F2 FB              CALL   0x2c2fa                      ; UNKNOWN
02C708  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02C70B  6A 30                 PUSH   0x30                         ; UNKNOWN
02C70D  6A 48                 PUSH   0x48                         ; UNKNOWN
02C70F  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
02C712  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
02C715  9A 00 01 EF 21        LCALL  0x21ef, 0x100                ; UNKNOWN
02C71A  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02C71D  0B C0                 OR     ax, ax                       ; UNKNOWN
02C71F  74 C9                 JE     0x2c6ea                      ; UNKNOWN
02C721  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
02C724  8B 5E F4              MOV    bx, word ptr [bp - 0xc]      ; UNKNOWN
02C727  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02C729  39 87 7C 0B           CMP    word ptr [bx + 0xb7c], ax    ; UNKNOWN
02C72D  74 BB                 JE     0x2c6ea                      ; UNKNOWN
02C72F  8B 8F 7C 0B           MOV    cx, word ptr [bx + 0xb7c]    ; UNKNOWN
02C733  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
02C736  8B 0E B6 40           MOV    cx, word ptr [0x40b6]        ; UNKNOWN
02C73A  89 4E F8              MOV    word ptr [bp - 8], cx        ; UNKNOWN
02C73D  8B 4E F4              MOV    cx, word ptr [bp - 0xc]      ; UNKNOWN
02C740  89 0E B6 40           MOV    word ptr [0x40b6], cx        ; UNKNOWN
02C744  89 87 7C 0B           MOV    word ptr [bx + 0xb7c], ax    ; UNKNOWN
02C748  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02C74B  51                    PUSH   cx                           ; UNKNOWN
02C74C  0E                    PUSH   cs                           ; UNKNOWN
02C74D  E8 D6 FB              CALL   0x2c326                      ; UNKNOWN
02C750  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02C753  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
02C756  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02C758  FF B7 7C 0B           PUSH   word ptr [bx + 0xb7c]        ; UNKNOWN
02C75C  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
02C75F  0E                    PUSH   cs                           ; UNKNOWN
02C760  E8                    DB     0xE8                         ; UNKNOWN (raw)
02C761  C3                    DB     0xC3                         ; UNKNOWN (raw)
