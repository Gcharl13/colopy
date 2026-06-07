; ============================================================================
; func_0279C6_unknown
; Region   : load_image
; Bytes    : file 0x0279C6..0x027BCA  (516 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0279C6  C8 2E 00 00           ENTER  0x2e, 0                      ; UNKNOWN
0279CA  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0279CD  C6 07 00              MOV    byte ptr [bx], 0             ; UNKNOWN
0279D0  6A 25                 PUSH   0x25                         ; UNKNOWN
0279D2  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0279D5  9A 90 0C 65 5F        LCALL  0x5f65, 0xc90                ; UNKNOWN
0279DA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0279DD  89 46 D4              MOV    word ptr [bp - 0x2c], ax     ; UNKNOWN
0279E0  0B C0                 OR     ax, ax                       ; UNKNOWN
0279E2  74 05                 JE     0x279e9                      ; UNKNOWN
0279E4  8B D8                 MOV    bx, ax                       ; UNKNOWN
0279E6  C6 07 00              MOV    byte ptr [bx], 0             ; UNKNOWN
0279E9  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0279EC  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
0279EF  74 0C                 JE     0x279fd                      ; UNKNOWN
0279F1  53                    PUSH   bx                           ; UNKNOWN
0279F2  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0279F5  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
0279FA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0279FD  83 7E D4 00           CMP    word ptr [bp - 0x2c], 0      ; UNKNOWN
027A01  75 03                 JNE    0x27a06                      ; UNKNOWN
027A03  E9 B9 01              JMP    0x27bbf                      ; UNKNOWN
027A06  FF 46 D4              INC    word ptr [bp - 0x2c]         ; UNKNOWN
027A09  8B 46 D4              MOV    ax, word ptr [bp - 0x2c]     ; UNKNOWN
027A0C  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
027A0F  6A 06                 PUSH   6                            ; UNKNOWN
027A11  68 E9 18              PUSH   0x18e9                       ; UNKNOWN
027A14  50                    PUSH   ax                           ; UNKNOWN
027A15  9A FC 0C 65 5F        LCALL  0x5f65, 0xcfc                ; UNKNOWN
027A1A  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027A1D  0B C0                 OR     ax, ax                       ; UNKNOWN
027A1F  75 30                 JNE    0x27a51                      ; UNKNOWN
027A21  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
027A24  83 C0 06              ADD    ax, 6                        ; UNKNOWN
027A27  50                    PUSH   ax                           ; UNKNOWN
027A28  9A 86 08 65 5F        LCALL  0x5f65, 0x886                ; UNKNOWN
027A2D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
027A30  89 46 D2              MOV    word ptr [bp - 0x2e], ax     ; UNKNOWN
027A33  C1 E0 06              SHL    ax, 6                        ; UNKNOWN
027A36  05 40 3F              ADD    ax, 0x3f40                   ; UNKNOWN
027A39  50                    PUSH   ax                           ; UNKNOWN
027A3A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
027A3D  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
027A42  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027A45  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
027A48  83 C0 07              ADD    ax, 7                        ; UNKNOWN
027A4B  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
027A4E  E9 6E 01              JMP    0x27bbf                      ; UNKNOWN
027A51  6A 06                 PUSH   6                            ; UNKNOWN
027A53  68 F0 18              PUSH   0x18f0                       ; UNKNOWN
027A56  FF 76 D4              PUSH   word ptr [bp - 0x2c]         ; UNKNOWN
027A59  9A 4C 08 65 5F        LCALL  0x5f65, 0x84c                ; UNKNOWN
027A5E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027A61  0B C0                 OR     ax, ax                       ; UNKNOWN
027A63  75 43                 JNE    0x27aa8                      ; UNKNOWN
027A65  6A 0A                 PUSH   0xa                          ; UNKNOWN
027A67  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
027A6A  50                    PUSH   ax                           ; UNKNOWN
027A6B  8B 4E D4              MOV    cx, word ptr [bp - 0x2c]     ; UNKNOWN
027A6E  83 C1 06              ADD    cx, 6                        ; UNKNOWN
027A71  51                    PUSH   cx                           ; UNKNOWN
027A72  9A 86 08 65 5F        LCALL  0x5f65, 0x886                ; UNKNOWN
027A77  83 C4 02              ADD    sp, 2                        ; UNKNOWN
027A7A  89 46 D2              MOV    word ptr [bp - 0x2e], ax     ; UNKNOWN
027A7D  8B D8                 MOV    bx, ax                       ; UNKNOWN
027A7F  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
027A82  FF B7 2C 3F           PUSH   word ptr [bx + 0x3f2c]       ; UNKNOWN
027A86  FF B7 2A 3F           PUSH   word ptr [bx + 0x3f2a]       ; UNKNOWN
027A8A  9A A6 08 65 5F        LCALL  0x5f65, 0x8a6                ; UNKNOWN
027A8F  83 C4 08              ADD    sp, 8                        ; UNKNOWN
027A92  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
027A95  50                    PUSH   ax                           ; UNKNOWN
027A96  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
027A99  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
027A9E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027AA1  83 46 06 07           ADD    word ptr [bp + 6], 7         ; UNKNOWN
027AA5  E9 17 01              JMP    0x27bbf                      ; UNKNOWN
027AA8  6A 03                 PUSH   3                            ; UNKNOWN
027AAA  68 F7 18              PUSH   0x18f7                       ; UNKNOWN
027AAD  FF 76 D4              PUSH   word ptr [bp - 0x2c]         ; UNKNOWN
027AB0  9A 4C 08 65 5F        LCALL  0x5f65, 0x84c                ; UNKNOWN
027AB5  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027AB8  0B C0                 OR     ax, ax                       ; UNKNOWN
027ABA  75 71                 JNE    0x27b2d                      ; UNKNOWN
027ABC  6A 10                 PUSH   0x10                         ; UNKNOWN
027ABE  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
027AC1  50                    PUSH   ax                           ; UNKNOWN
027AC2  8B 46 D4              MOV    ax, word ptr [bp - 0x2c]     ; UNKNOWN
027AC5  83 C0 03              ADD    ax, 3                        ; UNKNOWN
027AC8  50                    PUSH   ax                           ; UNKNOWN
027AC9  9A 86 08 65 5F        LCALL  0x5f65, 0x886                ; UNKNOWN
027ACE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
027AD1  8B D8                 MOV    bx, ax                       ; UNKNOWN
027AD3  89 5E D2              MOV    word ptr [bp - 0x2e], bx     ; UNKNOWN
027AD6  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
027AD9  FF B7 2C 3F           PUSH   word ptr [bx + 0x3f2c]       ; UNKNOWN
027ADD  FF B7 2A 3F           PUSH   word ptr [bx + 0x3f2a]       ; UNKNOWN
027AE1  9A A6 08 65 5F        LCALL  0x5f65, 0x8a6                ; UNKNOWN
027AE6  83 C4 08              ADD    sp, 8                        ; UNKNOWN
027AE9  C7 46 D6 00 00        MOV    word ptr [bp - 0x2a], 0      ; UNKNOWN
027AEE  EB 11                 JMP    0x27b01                      ; UNKNOWN
027AF0  68 FB 18              PUSH   0x18fb                       ; UNKNOWN
027AF3  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
027AF6  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
027AFB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027AFE  FF 46 D6              INC    word ptr [bp - 0x2a]         ; UNKNOWN
027B01  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
027B04  50                    PUSH   ax                           ; UNKNOWN
027B05  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
027B0A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
027B0D  83 E8 04              SUB    ax, 4                        ; UNKNOWN
027B10  F7 D8                 NEG    ax                           ; UNKNOWN
027B12  3B 46 D6              CMP    ax, word ptr [bp - 0x2a]     ; UNKNOWN
027B15  77 D9                 JA     0x27af0                      ; UNKNOWN
027B17  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
027B1A  50                    PUSH   ax                           ; UNKNOWN
027B1B  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
027B1E  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
027B23  83 C4 04              ADD    sp, 4                        ; UNKNOWN
027B26  83 46 06 04           ADD    word ptr [bp + 6], 4         ; UNKNOWN
027B2A  E9 92 00              JMP    0x27bbf                      ; UNKNOWN
027B2D  6A 07                 PUSH   7                            ; UNKNOWN
027B2F  68 FD 18              PUSH   0x18fd                       ; UNKNOWN
027B32  FF 76 D4              PUSH   word ptr [bp - 0x2c]         ; UNKNOWN
027B35  9A 4C 08 65 5F        LCALL  0x5f65, 0x84c                ; UNKNOWN
027B3A  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027B3D  0B C0                 OR     ax, ax                       ; UNKNOWN
027B3F  75 2A                 JNE    0x27b6b                      ; UNKNOWN
027B41  C6 46 D8 00           MOV    byte ptr [bp - 0x28], 0      ; UNKNOWN
027B45  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
027B48  50                    PUSH   ax                           ; UNKNOWN
027B49  6A 00                 PUSH   0                            ; UNKNOWN
027B4B  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
027B4F  9A 41 01 49 22        LCALL  0x2249, 0x141                ; UNKNOWN
027B54  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027B57  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
027B5A  16                    PUSH   ss                           ; UNKNOWN
027B5B  50                    PUSH   ax                           ; UNKNOWN
027B5C  1E                    PUSH   ds                           ; UNKNOWN
027B5D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
027B60  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
027B65  83 C4 08              ADD    sp, 8                        ; UNKNOWN
027B68  E9 36 FF              JMP    0x27aa1                      ; UNKNOWN
027B6B  6A 04                 PUSH   4                            ; UNKNOWN
027B6D  68 05 19              PUSH   0x1905                       ; UNKNOWN
027B70  FF 76 D4              PUSH   word ptr [bp - 0x2c]         ; UNKNOWN
027B73  9A 4C 08 65 5F        LCALL  0x5f65, 0x84c                ; UNKNOWN
027B78  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027B7B  0B C0                 OR     ax, ax                       ; UNKNOWN
027B7D  75 25                 JNE    0x27ba4                      ; UNKNOWN
027B7F  6A 0A                 PUSH   0xa                          ; UNKNOWN
027B81  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
027B84  50                    PUSH   ax                           ; UNKNOWN
027B85  FF 36 02 3E           PUSH   word ptr [0x3e02]            ; UNKNOWN
027B89  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
027B8E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
027B91  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
027B94  16                    PUSH   ss                           ; UNKNOWN
027B95  50                    PUSH   ax                           ; UNKNOWN
027B96  1E                    PUSH   ds                           ; UNKNOWN
027B97  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
027B9A  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
027B9F  83 C4 08              ADD    sp, 8                        ; UNKNOWN
027BA2  EB 82                 JMP    0x27b26                      ; UNKNOWN
027BA4  8B 5E D4              MOV    bx, word ptr [bp - 0x2c]     ; UNKNOWN
027BA7  80 3F 25              CMP    byte ptr [bx], 0x25          ; UNKNOWN
027BAA  75 13                 JNE    0x27bbf                      ; UNKNOWN
027BAC  1E                    PUSH   ds                           ; UNKNOWN
027BAD  68 0A 19              PUSH   0x190a                       ; UNKNOWN
027BB0  1E                    PUSH   ds                           ; UNKNOWN
027BB1  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
027BB4  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
027BB9  83 C4 08              ADD    sp, 8                        ; UNKNOWN
027BBC  FF 46 06              INC    word ptr [bp + 6]            ; UNKNOWN
027BBF  83 7E D4 00           CMP    word ptr [bp - 0x2c], 0      ; UNKNOWN
027BC3  74 03                 JE     0x27bc8                      ; UNKNOWN
027BC5  E9 08 FE              JMP    0x279d0                      ; UNKNOWN
027BC8  C9                    LEAVE                               ; UNKNOWN
027BC9  CB                    RETF                                ; UNKNOWN
