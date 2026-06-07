; ============================================================================
; func_04FAFC_unknown
; Region   : load_image
; Bytes    : file 0x04FAFC..0x04FEC5  (969 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04FAFC  C8 C8 03 00           ENTER  0x3c8, 0                     ; UNKNOWN
04FB00  56                    PUSH   si                           ; UNKNOWN
04FB01  C7 86 5C FF 01 00     MOV    word ptr [bp - 0xa4], 1      ; UNKNOWN
04FB07  C7 86 38 FC 00 00     MOV    word ptr [bp - 0x3c8], 0     ; UNKNOWN
04FB0D  2B C0                 SUB    ax, ax                       ; UNKNOWN
04FB0F  89 86 56 FC           MOV    word ptr [bp - 0x3aa], ax    ; UNKNOWN
04FB13  89 86 54 FC           MOV    word ptr [bp - 0x3ac], ax    ; UNKNOWN
04FB17  89 86 44 FC           MOV    word ptr [bp - 0x3bc], ax    ; UNKNOWN
04FB1B  89 86 42 FC           MOV    word ptr [bp - 0x3be], ax    ; UNKNOWN
04FB1F  89 86 3C FC           MOV    word ptr [bp - 0x3c4], ax    ; UNKNOWN
04FB23  89 86 3A FC           MOV    word ptr [bp - 0x3c6], ax    ; UNKNOWN
04FB27  89 86 5A FC           MOV    word ptr [bp - 0x3a6], ax    ; UNKNOWN
04FB2B  89 86 58 FC           MOV    word ptr [bp - 0x3a8], ax    ; UNKNOWN
04FB2F  39 46 06              CMP    word ptr [bp + 6], ax        ; UNKNOWN
04FB32  7D 11                 JGE    0x4fb45                      ; UNKNOWN
04FB34  7F 09                 JG     0x4fb3f                      ; UNKNOWN
04FB36  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04FB39  F7 D0                 NOT    ax                           ; UNKNOWN
04FB3B  40                    INC    ax                           ; UNKNOWN
04FB3C  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
04FB3F  C7 86 38 FC 01 00     MOV    word ptr [bp - 0x3c8], 1     ; UNKNOWN
04FB45  68 7E 2A              PUSH   0x2a7e                       ; UNKNOWN
04FB48  8D 86 5E FF           LEA    ax, [bp - 0xa2]              ; UNKNOWN
04FB4C  50                    PUSH   ax                           ; UNKNOWN
04FB4D  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
04FB52  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04FB55  8D 86 5E FF           LEA    ax, [bp - 0xa2]              ; UNKNOWN
04FB59  16                    PUSH   ss                           ; UNKNOWN
04FB5A  50                    PUSH   ax                           ; UNKNOWN
04FB5B  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04FB5E  BA 02 00              MOV    dx, 2                        ; UNKNOWN
04FB61  9A 06 00 E9 5A        LCALL  0x5ae9, 6                    ; UNKNOWN
04FB66  8D 86 5E FF           LEA    ax, [bp - 0xa2]              ; UNKNOWN
04FB6A  16                    PUSH   ss                           ; UNKNOWN
04FB6B  50                    PUSH   ax                           ; UNKNOWN
04FB6C  1E                    PUSH   ds                           ; UNKNOWN
04FB6D  68 84 2A              PUSH   0x2a84                       ; UNKNOWN
04FB70  9A 0A 00 3A 5B        LCALL  0x5b3a, 0xa                  ; UNKNOWN
04FB75  8D 9E 5E FF           LEA    bx, [bp - 0xa2]              ; UNKNOWN
04FB79  9A 3A 01 E9 5A        LCALL  0x5ae9, 0x13a                ; UNKNOWN
04FB7E  0B C0                 OR     ax, ax                       ; UNKNOWN
04FB80  75 03                 JNE    0x4fb85                      ; UNKNOWN
04FB82  E9 39 03              JMP    0x4febe                      ; UNKNOWN
04FB85  8D 1E 87 2A           LEA    bx, [0x2a87]                 ; UNKNOWN
04FB89  9A 0A 00 4D 5B        LCALL  0x5b4d, 0xa                  ; UNKNOWN
04FB8E  89 86 54 FC           MOV    word ptr [bp - 0x3ac], ax    ; UNKNOWN
04FB92  89 96 56 FC           MOV    word ptr [bp - 0x3aa], dx    ; UNKNOWN
04FB96  0B D0                 OR     dx, ax                       ; UNKNOWN
04FB98  75 03                 JNE    0x4fb9d                      ; UNKNOWN
04FB9A  E9 21 03              JMP    0x4febe                      ; UNKNOWN
04FB9D  9A 08 00 D0 21        LCALL  0x21d0, 8                    ; UNKNOWN
04FBA2  8D 1E 8F 2A           LEA    bx, [0x2a8f]                 ; UNKNOWN
04FBA6  2B C0                 SUB    ax, ax                       ; UNKNOWN
04FBA8  9A 5A 00 D0 21        LCALL  0x21d0, 0x5a                 ; UNKNOWN
04FBAD  89 86 42 FC           MOV    word ptr [bp - 0x3be], ax    ; UNKNOWN
04FBB1  89 96 44 FC           MOV    word ptr [bp - 0x3bc], dx    ; UNKNOWN
04FBB5  0B D0                 OR     dx, ax                       ; UNKNOWN
04FBB7  75 03                 JNE    0x4fbbc                      ; UNKNOWN
04FBB9  E9 AF 02              JMP    0x4fe6b                      ; UNKNOWN
04FBBC  8D 1E 98 2A           LEA    bx, [0x2a98]                 ; UNKNOWN
04FBC0  2B C0                 SUB    ax, ax                       ; UNKNOWN
04FBC2  9A 5A 00 D0 21        LCALL  0x21d0, 0x5a                 ; UNKNOWN
04FBC7  89 86 58 FC           MOV    word ptr [bp - 0x3a8], ax    ; UNKNOWN
04FBCB  89 96 5A FC           MOV    word ptr [bp - 0x3a6], dx    ; UNKNOWN
04FBCF  0B D0                 OR     dx, ax                       ; UNKNOWN
04FBD1  75 03                 JNE    0x4fbd6                      ; UNKNOWN
04FBD3  E9 95 02              JMP    0x4fe6b                      ; UNKNOWN
04FBD6  83 BE 38 FC 00        CMP    word ptr [bp - 0x3c8], 0     ; UNKNOWN
04FBDB  74 19                 JE     0x4fbf6                      ; UNKNOWN
04FBDD  8D 86 5C FC           LEA    ax, [bp - 0x3a4]             ; UNKNOWN
04FBE1  16                    PUSH   ss                           ; UNKNOWN
04FBE2  50                    PUSH   ax                           ; UNKNOWN
04FBE3  9A 04 00 F8 5B        LCALL  0x5bf8, 4                    ; UNKNOWN
04FBE8  8D 86 5C FC           LEA    ax, [bp - 0x3a4]             ; UNKNOWN
04FBEC  16                    PUSH   ss                           ; UNKNOWN
04FBED  50                    PUSH   ax                           ; UNKNOWN
04FBEE  B8 01 00              MOV    ax, 1                        ; UNKNOWN
04FBF1  9A 2F 00 D7 44        LCALL  0x44d7, 0x2f                 ; UNKNOWN
04FBF6  8D 86 5C FC           LEA    ax, [bp - 0x3a4]             ; UNKNOWN
04FBFA  A3 24 0F              MOV    word ptr [0xf24], ax         ; UNKNOWN
04FBFD  8C 16 26 0F           MOV    word ptr [0xf26], ss         ; UNKNOWN
04FC01  8D 9E 5E FF           LEA    bx, [bp - 0xa2]              ; UNKNOWN
04FC05  2B C0                 SUB    ax, ax                       ; UNKNOWN
04FC07  9A 5A 00 D0 21        LCALL  0x21d0, 0x5a                 ; UNKNOWN
04FC0C  89 86 3A FC           MOV    word ptr [bp - 0x3c6], ax    ; UNKNOWN
04FC10  89 96 3C FC           MOV    word ptr [bp - 0x3c4], dx    ; UNKNOWN
04FC14  0B D0                 OR     dx, ax                       ; UNKNOWN
04FC16  75 03                 JNE    0x4fc1b                      ; UNKNOWN
04FC18  E9 50 02              JMP    0x4fe6b                      ; UNKNOWN
04FC1B  0E                    PUSH   cs                           ; UNKNOWN
04FC1C  E8 7F FE              CALL   0x4fa9e                      ; UNKNOWN
04FC1F  83 BE 38 FC 00        CMP    word ptr [bp - 0x3c8], 0     ; UNKNOWN
04FC24  75 06                 JNE    0x4fc2c                      ; UNKNOWN
04FC26  C7 06 14 0C 00 00     MOV    word ptr [0xc14], 0          ; UNKNOWN
04FC2C  8D 86 5C FC           LEA    ax, [bp - 0x3a4]             ; UNKNOWN
04FC30  16                    PUSH   ss                           ; UNKNOWN
04FC31  50                    PUSH   ax                           ; UNKNOWN
04FC32  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
04FC37  FF B6 44 FC           PUSH   word ptr [bp - 0x3bc]        ; UNKNOWN
04FC3B  FF B6 42 FC           PUSH   word ptr [bp - 0x3be]        ; UNKNOWN
04FC3F  E8 86 FE              CALL   0x4fac8                      ; UNKNOWN
04FC42  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04FC45  C4 9E 58 FC           LES    bx, ptr [bp - 0x3a8]         ; UNKNOWN
04FC49  26 8B 47 4A           MOV    ax, word ptr es:[bx + 0x4a]  ; UNKNOWN
04FC4D  89 86 52 FC           MOV    word ptr [bp - 0x3ae], ax    ; UNKNOWN
04FC51  26 8B 47 56           MOV    ax, word ptr es:[bx + 0x56]  ; UNKNOWN
04FC55  89 86 4C FC           MOV    word ptr [bp - 0x3b4], ax    ; UNKNOWN
04FC59  26 8B 47 62           MOV    ax, word ptr es:[bx + 0x62]  ; UNKNOWN
04FC5D  89 86 46 FC           MOV    word ptr [bp - 0x3ba], ax    ; UNKNOWN
04FC61  83 BE 38 FC 00        CMP    word ptr [bp - 0x3c8], 0     ; UNKNOWN
04FC66  74 0B                 JE     0x4fc73                      ; UNKNOWN
04FC68  83 7E 06 01           CMP    word ptr [bp + 6], 1         ; UNKNOWN
04FC6C  75 05                 JNE    0x4fc73                      ; UNKNOWN
04FC6E  C7 46 06 00 00        MOV    word ptr [bp + 6], 0         ; UNKNOWN
04FC73  68 A1 2A              PUSH   0x2aa1                       ; UNKNOWN
04FC76  68 A9 2A              PUSH   0x2aa9                       ; UNKNOWN
04FC79  9A 24 00 09 45        LCALL  0x4509, 0x24                 ; UNKNOWN
04FC7E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04FC81  C7 86 48 FC 00 00     MOV    word ptr [bp - 0x3b8], 0     ; UNKNOWN
04FC87  EB 0D                 JMP    0x4fc96                      ; UNKNOWN
04FC89  9A 0F 01 09 45        LCALL  0x4509, 0x10f                ; UNKNOWN
04FC8E  89 86 40 FC           MOV    word ptr [bp - 0x3c0], ax    ; UNKNOWN
04FC92  FF 86 48 FC           INC    word ptr [bp - 0x3b8]        ; UNKNOWN
04FC96  8B 86 48 FC           MOV    ax, word ptr [bp - 0x3b8]    ; UNKNOWN
04FC9A  39 46 06              CMP    word ptr [bp + 6], ax        ; UNKNOWN
04FC9D  7D EA                 JGE    0x4fc89                      ; UNKNOWN
04FC9F  9A 0A 00 09 45        LCALL  0x4509, 0xa                  ; UNKNOWN
04FCA4  FF B6 40 FC           PUSH   word ptr [bp - 0x3c0]        ; UNKNOWN
04FCA8  8D 86 5E FF           LEA    ax, [bp - 0xa2]              ; UNKNOWN
04FCAC  50                    PUSH   ax                           ; UNKNOWN
04FCAD  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
04FCB2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04FCB5  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
04FCB9  6A 0A                 PUSH   0xa                          ; UNKNOWN
04FCBB  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04FCBE  50                    PUSH   ax                           ; UNKNOWN
04FCBF  FF 36 02 3E           PUSH   word ptr [0x3e02]            ; UNKNOWN
04FCC3  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
04FCC8  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04FCCB  68 B1 2A              PUSH   0x2ab1                       ; UNKNOWN
04FCCE  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04FCD1  50                    PUSH   ax                           ; UNKNOWN
04FCD2  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
04FCD7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04FCDA  8D 86 5E FF           LEA    ax, [bp - 0xa2]              ; UNKNOWN
04FCDE  50                    PUSH   ax                           ; UNKNOWN
04FCDF  8D 4E B0              LEA    cx, [bp - 0x50]              ; UNKNOWN
04FCE2  51                    PUSH   cx                           ; UNKNOWN
04FCE3  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
04FCE8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04FCEB  8D 86 5E FF           LEA    ax, [bp - 0xa2]              ; UNKNOWN
04FCEF  50                    PUSH   ax                           ; UNKNOWN
04FCF0  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04FCF3  50                    PUSH   ax                           ; UNKNOWN
04FCF4  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
04FCF9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04FCFC  FF B6 56 FC           PUSH   word ptr [bp - 0x3aa]        ; UNKNOWN
04FD00  FF B6 54 FC           PUSH   word ptr [bp - 0x3ac]        ; UNKNOWN
04FD04  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04FD07  16                    PUSH   ss                           ; UNKNOWN
04FD08  50                    PUSH   ax                           ; UNKNOWN
04FD09  2B C0                 SUB    ax, ax                       ; UNKNOWN
04FD0B  9A 0E 00 75 5B        LCALL  0x5b75, 0xe                  ; UNKNOWN
04FD10  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
04FD13  2B C0                 SUB    ax, ax                       ; UNKNOWN
04FD15  89 86 3E FC           MOV    word ptr [bp - 0x3c2], ax    ; UNKNOWN
04FD19  89 86 4E FC           MOV    word ptr [bp - 0x3b2], ax    ; UNKNOWN
04FD1D  EB 0C                 JMP    0x4fd2b                      ; UNKNOWN
04FD1F  8B 86 4C FC           MOV    ax, word ptr [bp - 0x3b4]    ; UNKNOWN
04FD23  01 86 3E FC           ADD    word ptr [bp - 0x3c2], ax    ; UNKNOWN
04FD27  FF 86 4E FC           INC    word ptr [bp - 0x3b2]        ; UNKNOWN
04FD2B  8B 46 AE              MOV    ax, word ptr [bp - 0x52]     ; UNKNOWN
04FD2E  39 86 3E FC           CMP    word ptr [bp - 0x3c2], ax    ; UNKNOWN
04FD32  7C EB                 JL     0x4fd1f                      ; UNKNOWN
04FD34  FF B6 5A FC           PUSH   word ptr [bp - 0x3a6]        ; UNKNOWN
04FD38  FF B6 58 FC           PUSH   word ptr [bp - 0x3a8]        ; UNKNOWN
04FD3C  B8 A2 00              MOV    ax, 0xa2                     ; UNKNOWN
04FD3F  89 86 4A FC           MOV    word ptr [bp - 0x3b6], ax    ; UNKNOWN
04FD43  50                    PUSH   ax                           ; UNKNOWN
04FD44  BA A0 00              MOV    dx, 0xa0                     ; UNKNOWN
04FD47  8B 86 3E FC           MOV    ax, word ptr [bp - 0x3c2]    ; UNKNOWN
04FD4B  03 86 46 FC           ADD    ax, word ptr [bp - 0x3ba]    ; UNKNOWN
04FD4F  03 86 52 FC           ADD    ax, word ptr [bp - 0x3ae]    ; UNKNOWN
04FD53  D1 F8                 SAR    ax, 1                        ; UNKNOWN
04FD55  2B D0                 SUB    dx, ax                       ; UNKNOWN
04FD57  B8 01 00              MOV    ax, 1                        ; UNKNOWN
04FD5A  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
04FD5E  8B F2                 MOV    si, dx                       ; UNKNOWN
04FD60  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
04FD65  03 B6 52 FC           ADD    si, word ptr [bp - 0x3ae]    ; UNKNOWN
04FD69  89 B6 50 FC           MOV    word ptr [bp - 0x3b0], si    ; UNKNOWN
04FD6D  C7 86 48 FC 00 00     MOV    word ptr [bp - 0x3b8], 0     ; UNKNOWN
04FD73  EB 28                 JMP    0x4fd9d                      ; UNKNOWN
04FD75  FF B6 5A FC           PUSH   word ptr [bp - 0x3a6]        ; UNKNOWN
04FD79  FF B6 58 FC           PUSH   word ptr [bp - 0x3a8]        ; UNKNOWN
04FD7D  FF B6 4A FC           PUSH   word ptr [bp - 0x3b6]        ; UNKNOWN
04FD81  B8 02 00              MOV    ax, 2                        ; UNKNOWN
04FD84  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
04FD88  8B 96 50 FC           MOV    dx, word ptr [bp - 0x3b0]    ; UNKNOWN
04FD8C  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
04FD91  8B 86 4C FC           MOV    ax, word ptr [bp - 0x3b4]    ; UNKNOWN
04FD95  01 86 50 FC           ADD    word ptr [bp - 0x3b0], ax    ; UNKNOWN
04FD99  FF 86 48 FC           INC    word ptr [bp - 0x3b8]        ; UNKNOWN
04FD9D  8B 86 48 FC           MOV    ax, word ptr [bp - 0x3b8]    ; UNKNOWN
04FDA1  39 86 4E FC           CMP    word ptr [bp - 0x3b2], ax    ; UNKNOWN
04FDA5  7F CE                 JG     0x4fd75                      ; UNKNOWN
04FDA7  FF B6 5A FC           PUSH   word ptr [bp - 0x3a6]        ; UNKNOWN
04FDAB  FF B6 58 FC           PUSH   word ptr [bp - 0x3a8]        ; UNKNOWN
04FDAF  FF B6 4A FC           PUSH   word ptr [bp - 0x3b6]        ; UNKNOWN
04FDB3  B8 03 00              MOV    ax, 3                        ; UNKNOWN
04FDB6  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
04FDBA  8B 96 50 FC           MOV    dx, word ptr [bp - 0x3b0]    ; UNKNOWN
04FDBE  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
04FDC3  8B 46 AE              MOV    ax, word ptr [bp - 0x52]     ; UNKNOWN
04FDC6  D1 F8                 SAR    ax, 1                        ; UNKNOWN
04FDC8  2D A0 00              SUB    ax, 0xa0                     ; UNKNOWN
04FDCB  F7 D8                 NEG    ax                           ; UNKNOWN
04FDCD  89 86 50 FC           MOV    word ptr [bp - 0x3b0], ax    ; UNKNOWN
04FDD1  6A 5D                 PUSH   0x5d                         ; UNKNOWN
04FDD3  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
04FDD6  BA 5C 00              MOV    dx, 0x5c                     ; UNKNOWN
04FDD9  BB 5E 00              MOV    bx, 0x5e                     ; UNKNOWN
04FDDC  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
04FDE1  FF B6 56 FC           PUSH   word ptr [bp - 0x3aa]        ; UNKNOWN
04FDE5  FF B6 54 FC           PUSH   word ptr [bp - 0x3ac]        ; UNKNOWN
04FDE9  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04FDEC  16                    PUSH   ss                           ; UNKNOWN
04FDED  50                    PUSH   ax                           ; UNKNOWN
04FDEE  6A 00                 PUSH   0                            ; UNKNOWN
04FDF0  BA A5 00              MOV    dx, 0xa5                     ; UNKNOWN
04FDF3  89 96 4A FC           MOV    word ptr [bp - 0x3b6], dx    ; UNKNOWN
04FDF7  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
04FDFB  8B 86 50 FC           MOV    ax, word ptr [bp - 0x3b0]    ; UNKNOWN
04FDFF  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
04FE04  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04FE08  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04FE0C  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04FE10  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04FE14  6A 70                 PUSH   0x70                         ; UNKNOWN
04FE16  6A 0A                 PUSH   0xa                          ; UNKNOWN
04FE18  B8 3F 00              MOV    ax, 0x3f                     ; UNKNOWN
04FE1B  BA 28 00              MOV    dx, 0x28                     ; UNKNOWN
04FE1E  BB C0 00              MOV    bx, 0xc0                     ; UNKNOWN
04FE21  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
04FE26  6A 00                 PUSH   0                            ; UNKNOWN
04FE28  68 40 01              PUSH   0x140                        ; UNKNOWN
04FE2B  68 C8 00              PUSH   0xc8                         ; UNKNOWN
04FE2E  2B C0                 SUB    ax, ax                       ; UNKNOWN
04FE30  99                    CDQ                                 ; UNKNOWN
04FE31  2B DB                 SUB    bx, bx                       ; UNKNOWN
04FE33  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
04FE38  FF B6 3C FC           PUSH   word ptr [bp - 0x3c4]        ; UNKNOWN
04FE3C  FF B6 3A FC           PUSH   word ptr [bp - 0x3c6]        ; UNKNOWN
04FE40  E8 85 FC              CALL   0x4fac8                      ; UNKNOWN
04FE43  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04FE46  6A 08                 PUSH   8                            ; UNKNOWN
04FE48  9A 02 00 F1 44        LCALL  0x44f1, 2                    ; UNKNOWN
04FE4D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04FE50  83 BE 38 FC 00        CMP    word ptr [bp - 0x3c8], 0     ; UNKNOWN
04FE55  75 0E                 JNE    0x4fe65                      ; UNKNOWN
04FE57  9A 29 00 9A 5B        LCALL  0x5b9a, 0x29                 ; UNKNOWN
04FE5C  9A 6B 00 EF 21        LCALL  0x21ef, 0x6b                 ; UNKNOWN
04FE61  0E                    PUSH   cs                           ; UNKNOWN
04FE62  E8 39 FC              CALL   0x4fa9e                      ; UNKNOWN
04FE65  C7 86 5C FF 00 00     MOV    word ptr [bp - 0xa4], 0      ; UNKNOWN
04FE6B  83 BE 38 FC 00        CMP    word ptr [bp - 0x3c8], 0     ; UNKNOWN
04FE70  75 1C                 JNE    0x4fe8e                      ; UNKNOWN
04FE72  68 00 A0              PUSH   0xa000                       ; UNKNOWN
04FE75  68 00 FC              PUSH   0xfc00                       ; UNKNOWN
04FE78  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
04FE7D  8A 26 FB 3D           MOV    ah, byte ptr [0x3dfb]        ; UNKNOWN
04FE81  25 00 01              AND    ax, 0x100                    ; UNKNOWN
04FE84  83 F8 01              CMP    ax, 1                        ; UNKNOWN
04FE87  1B C0                 SBB    ax, ax                       ; UNKNOWN
04FE89  F7 D8                 NEG    ax                           ; UNKNOWN
04FE8B  A3 14 0C              MOV    word ptr [0xc14], ax         ; UNKNOWN
04FE8E  2B C0                 SUB    ax, ax                       ; UNKNOWN
04FE90  A3 26 0F              MOV    word ptr [0xf26], ax         ; UNKNOWN
04FE93  A3 24 0F              MOV    word ptr [0xf24], ax         ; UNKNOWN
04FE96  8B 86 56 FC           MOV    ax, word ptr [bp - 0x3aa]    ; UNKNOWN
04FE9A  0B 86 54 FC           OR     ax, word ptr [bp - 0x3ac]    ; UNKNOWN
04FE9E  74 0D                 JE     0x4fead                      ; UNKNOWN
04FEA0  FF B6 56 FC           PUSH   word ptr [bp - 0x3aa]        ; UNKNOWN
04FEA4  FF B6 54 FC           PUSH   word ptr [bp - 0x3ac]        ; UNKNOWN
04FEA8  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
04FEAD  9A C9 00 D0 21        LCALL  0x21d0, 0xc9                 ; UNKNOWN
04FEB2  83 BE 38 FC 00        CMP    word ptr [bp - 0x3c8], 0     ; UNKNOWN
04FEB7  75 05                 JNE    0x4febe                      ; UNKNOWN
04FEB9  9A F0 04 0B 38        LCALL  0x380b, 0x4f0                ; UNKNOWN
04FEBE  8B 86 5C FF           MOV    ax, word ptr [bp - 0xa4]     ; UNKNOWN
04FEC2  5E                    POP    si                           ; UNKNOWN
04FEC3  C9                    LEAVE                               ; UNKNOWN
04FEC4  CB                    RETF                                ; UNKNOWN
