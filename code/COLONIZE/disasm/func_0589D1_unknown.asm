; ============================================================================
; func_0589D1_unknown
; Region   : load_image
; Bytes    : file 0x0589D1..0x058BD6  (517 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0589D1  C8 5E 00 00           ENTER  0x5e, 0                      ; UNKNOWN
0589D5  57                    PUSH   di                           ; UNKNOWN
0589D6  56                    PUSH   si                           ; UNKNOWN
0589D7  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0589DB  B0 64                 MOV    al, 0x64                     ; UNKNOWN
0589DD  F6 A7 97 88           MUL    byte ptr [bx - 0x7769]       ; UNKNOWN
0589E1  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
0589E4  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
0589E9  74 27                 JE     0x58a12                      ; UNKNOWN
0589EB  6A 00                 PUSH   0                            ; UNKNOWN
0589ED  50                    PUSH   ax                           ; UNKNOWN
0589EE  6A 00                 PUSH   0                            ; UNKNOWN
0589F0  9A 24 04 97 1B        LCALL  0x1b97, 0x424                ; UNKNOWN
0589F5  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0589F8  6A 02                 PUSH   2                            ; UNKNOWN
0589FA  68 2A 2C              PUSH   0x2c2a                       ; UNKNOWN
0589FD  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
058A02  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058A05  6A 02                 PUSH   2                            ; UNKNOWN
058A07  9A 44 03 28 1A        LCALL  0x1a28, 0x344                ; UNKNOWN
058A0C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058A0F  E9 9B 01              JMP    0x58bad                      ; UNKNOWN
058A12  8A 1E 1E 3E           MOV    bl, byte ptr [0x3e1e]        ; UNKNOWN
058A16  2A FF                 SUB    bh, bh                       ; UNKNOWN
058A18  D1 E3                 SHL    bx, 1                        ; UNKNOWN
058A1A  FF B7 E9 37           PUSH   word ptr [bx + 0x37e9]       ; UNKNOWN
058A1E  6A 00                 PUSH   0                            ; UNKNOWN
058A20  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
058A25  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058A28  6B 46 08 34           IMUL   ax, word ptr [bp + 8], 0x34  ; UNKNOWN
058A2C  05 86 C0              ADD    ax, 0xc086                   ; UNKNOWN
058A2F  1E                    PUSH   ds                           ; UNKNOWN
058A30  50                    PUSH   ax                           ; UNKNOWN
058A31  6A 01                 PUSH   1                            ; UNKNOWN
058A33  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
058A38  83 C4 06              ADD    sp, 6                        ; UNKNOWN
058A3B  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
058A3E  6A 00                 PUSH   0                            ; UNKNOWN
058A40  6A 02                 PUSH   2                            ; UNKNOWN
058A42  9A FC 03 97 1B        LCALL  0x1b97, 0x3fc                ; UNKNOWN
058A47  83 C4 06              ADD    sp, 6                        ; UNKNOWN
058A4A  69 5E 08 3C 01        IMUL   bx, word ptr [bp + 8], 0x13c ; UNKNOWN
058A4F  8A 87 AB 74           MOV    al, byte ptr [bx + 0x74ab]   ; UNKNOWN
058A53  98                    CWDE                                ; UNKNOWN
058A54  99                    CDQ                                 ; UNKNOWN
058A55  52                    PUSH   dx                           ; UNKNOWN
058A56  50                    PUSH   ax                           ; UNKNOWN
058A57  6A 00                 PUSH   0                            ; UNKNOWN
058A59  9A 24 04 97 1B        LCALL  0x1b97, 0x424                ; UNKNOWN
058A5E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
058A61  68 37 2C              PUSH   0x2c37                       ; UNKNOWN
058A64  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
058A67  50                    PUSH   ax                           ; UNKNOWN
058A68  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
058A6D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058A70  6A 0A                 PUSH   0xa                          ; UNKNOWN
058A72  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
058A75  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
058A7A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058A7D  0B C0                 OR     ax, ax                       ; UNKNOWN
058A7F  74 05                 JE     0x58a86                      ; UNKNOWN
058A81  68 43 2C              PUSH   0x2c43                       ; UNKNOWN
058A84  EB 03                 JMP    0x58a89                      ; UNKNOWN
058A86  68 45 2C              PUSH   0x2c45                       ; UNKNOWN
058A89  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
058A8C  50                    PUSH   ax                           ; UNKNOWN
058A8D  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
058A92  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058A95  6A 3E                 PUSH   0x3e                         ; UNKNOWN
058A97  9A C8 02 28 1A        LCALL  0x1a28, 0x2c8                ; UNKNOWN
058A9C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058A9F  8D 5E B0              LEA    bx, [bp - 0x50]              ; UNKNOWN
058AA2  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
058AA7  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
058AAA  48                    DEC    ax                           ; UNKNOWN
058AAB  74 03                 JE     0x58ab0                      ; UNKNOWN
058AAD  E9 22 01              JMP    0x58bd2                      ; UNKNOWN
058AB0  69 5E 08 3C 01        IMUL   bx, word ptr [bp + 8], 0x13c ; UNKNOWN
058AB5  8A 87 AB 74           MOV    al, byte ptr [bx + 0x74ab]   ; UNKNOWN
058AB9  98                    CWDE                                ; UNKNOWN
058ABA  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
058ABD  6A 0A                 PUSH   0xa                          ; UNKNOWN
058ABF  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
058AC2  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
058AC7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058ACA  0B C0                 OR     ax, ax                       ; UNKNOWN
058ACC  75 1D                 JNE    0x58aeb                      ; UNKNOWN
058ACE  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
058AD1  2A E4                 SUB    ah, ah                       ; UNKNOWN
058AD3  83 C0 0A              ADD    ax, 0xa                      ; UNKNOWN
058AD6  8B C8                 MOV    cx, ax                       ; UNKNOWN
058AD8  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
058ADB  03 C1                 ADD    ax, cx                       ; UNKNOWN
058ADD  D1 66 A8              SHL    word ptr [bp - 0x58], 1      ; UNKNOWN
058AE0  3B 46 A8              CMP    ax, word ptr [bp - 0x58]     ; UNKNOWN
058AE3  7D 03                 JGE    0x58ae8                      ; UNKNOWN
058AE5  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
058AE8  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
058AEB  6A 00                 PUSH   0                            ; UNKNOWN
058AED  6A 64                 PUSH   0x64                         ; UNKNOWN
058AEF  8B 46 A6              MOV    ax, word ptr [bp - 0x5a]     ; UNKNOWN
058AF2  2B D2                 SUB    dx, dx                       ; UNKNOWN
058AF4  52                    PUSH   dx                           ; UNKNOWN
058AF5  50                    PUSH   ax                           ; UNKNOWN
058AF6  8B C8                 MOV    cx, ax                       ; UNKNOWN
058AF8  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
058AFB  83 F8 5A              CMP    ax, 0x5a                     ; UNKNOWN
058AFE  7E 03                 JLE    0x58b03                      ; UNKNOWN
058B00  B8 5A 00              MOV    ax, 0x5a                     ; UNKNOWN
058B03  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
058B06  8B DA                 MOV    bx, dx                       ; UNKNOWN
058B08  99                    CDQ                                 ; UNKNOWN
058B09  52                    PUSH   dx                           ; UNKNOWN
058B0A  50                    PUSH   ax                           ; UNKNOWN
058B0B  8B F0                 MOV    si, ax                       ; UNKNOWN
058B0D  8B F9                 MOV    di, cx                       ; UNKNOWN
058B0F  89 76 A2              MOV    word ptr [bp - 0x5e], si     ; UNKNOWN
058B12  89 56 A4              MOV    word ptr [bp - 0x5c], dx     ; UNKNOWN
058B15  8B F3                 MOV    si, bx                       ; UNKNOWN
058B17  9A 6C 12 65 5F        LCALL  0x5f65, 0x126c               ; UNKNOWN
058B1C  52                    PUSH   dx                           ; UNKNOWN
058B1D  50                    PUSH   ax                           ; UNKNOWN
058B1E  9A D2 11 65 5F        LCALL  0x5f65, 0x11d2               ; UNKNOWN
058B23  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
058B26  89 56 AC              MOV    word ptr [bp - 0x54], dx     ; UNKNOWN
058B29  56                    PUSH   si                           ; UNKNOWN
058B2A  57                    PUSH   di                           ; UNKNOWN
058B2B  56                    PUSH   si                           ; UNKNOWN
058B2C  8B F0                 MOV    si, ax                       ; UNKNOWN
058B2E  9A 24 04 97 1B        LCALL  0x1b97, 0x424                ; UNKNOWN
058B33  83 C4 06              ADD    sp, 6                        ; UNKNOWN
058B36  FF 76 A4              PUSH   word ptr [bp - 0x5c]         ; UNKNOWN
058B39  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
058B3C  6A 01                 PUSH   1                            ; UNKNOWN
058B3E  9A 24 04 97 1B        LCALL  0x1b97, 0x424                ; UNKNOWN
058B43  83 C4 06              ADD    sp, 6                        ; UNKNOWN
058B46  8B C6                 MOV    ax, si                       ; UNKNOWN
058B48  29 46 A6              SUB    word ptr [bp - 0x5a], ax     ; UNKNOWN
058B4B  6A 00                 PUSH   0                            ; UNKNOWN
058B4D  FF 76 A6              PUSH   word ptr [bp - 0x5a]         ; UNKNOWN
058B50  6A 02                 PUSH   2                            ; UNKNOWN
058B52  9A 24 04 97 1B        LCALL  0x1b97, 0x424                ; UNKNOWN
058B57  83 C4 06              ADD    sp, 6                        ; UNKNOWN
058B5A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
058B5D  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
058B62  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058B65  50                    PUSH   ax                           ; UNKNOWN
058B66  6A 00                 PUSH   0                            ; UNKNOWN
058B68  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
058B6D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058B70  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
058B73  D1 E3                 SHL    bx, 1                        ; UNKNOWN
058B75  FF B7 E1 37           PUSH   word ptr [bx + 0x37e1]       ; UNKNOWN
058B79  6A 01                 PUSH   1                            ; UNKNOWN
058B7B  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
058B80  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058B83  6A 02                 PUSH   2                            ; UNKNOWN
058B85  9A 44 03 28 1A        LCALL  0x1a28, 0x344                ; UNKNOWN
058B8A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058B8D  6A 02                 PUSH   2                            ; UNKNOWN
058B8F  68 47 2C              PUSH   0x2c47                       ; UNKNOWN
058B92  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
058B97  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058B9A  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
058B9D  8B 56 AC              MOV    dx, word ptr [bp - 0x54]     ; UNKNOWN
058BA0  69 5E 08 3C 01        IMUL   bx, word ptr [bp + 8], 0x13c ; UNKNOWN
058BA5  01 87 CC 74           ADD    word ptr [bx + 0x74cc], ax   ; UNKNOWN
058BA9  11 97 CE 74           ADC    word ptr [bx + 0x74ce], dx   ; UNKNOWN
058BAD  8B 46 A6              MOV    ax, word ptr [bp - 0x5a]     ; UNKNOWN
058BB0  2B D2                 SUB    dx, dx                       ; UNKNOWN
058BB2  69 5E 08 3C 01        IMUL   bx, word ptr [bp + 8], 0x13c ; UNKNOWN
058BB7  01 87 D4 74           ADD    word ptr [bx + 0x74d4], ax   ; UNKNOWN
058BBB  11 97 D6 74           ADC    word ptr [bx + 0x74d6], dx   ; UNKNOWN
058BBF  01 87 D0 74           ADD    word ptr [bx + 0x74d0], ax   ; UNKNOWN
058BC3  11 97 D2 74           ADC    word ptr [bx + 0x74d2], dx   ; UNKNOWN
058BC7  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
058BCA  9A 1C 08 B7 36        LCALL  0x36b7, 0x81c                ; UNKNOWN
058BCF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058BD2  5E                    POP    si                           ; UNKNOWN
058BD3  5F                    POP    di                           ; UNKNOWN
058BD4  C9                    LEAVE                               ; UNKNOWN
058BD5  CB                    RETF                                ; UNKNOWN
