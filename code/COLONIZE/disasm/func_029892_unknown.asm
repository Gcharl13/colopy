; ============================================================================
; func_029892_unknown
; Region   : load_image
; Bytes    : file 0x029892..0x029C78  (998 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

029892  C8 7E 00 00           ENTER  0x7e, 0                      ; UNKNOWN
029896  A0 20 3E              MOV    al, byte ptr [0x3e20]        ; UNKNOWN
029899  98                    CWDE                                ; UNKNOWN
02989A  8B C8                 MOV    cx, ax                       ; UNKNOWN
02989C  B0 64                 MOV    al, 0x64                     ; UNKNOWN
02989E  F6 2E 1F 3E           IMUL   byte ptr [0x3e1f]            ; UNKNOWN
0298A2  03 C8                 ADD    cx, ax                       ; UNKNOWN
0298A4  89 4E 96              MOV    word ptr [bp - 0x6a], cx     ; UNKNOWN
0298A7  2B C0                 SUB    ax, ax                       ; UNKNOWN
0298A9  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
0298AC  89 46 92              MOV    word ptr [bp - 0x6e], ax     ; UNKNOWN
0298AF  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0298B2  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
0298B5  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
0298B8  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
0298BB  89 46 94              MOV    word ptr [bp - 0x6c], ax     ; UNKNOWN
0298BE  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
0298C1  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
0298C4  89 46 8C              MOV    word ptr [bp - 0x74], ax     ; UNKNOWN
0298C7  89 46 82              MOV    word ptr [bp - 0x7e], ax     ; UNKNOWN
0298CA  EB 1A                 JMP    0x298e6                      ; UNKNOWN
0298CC  A1 10 3E              MOV    ax, word ptr [0x3e10]        ; UNKNOWN
0298CF  39 46 82              CMP    word ptr [bp - 0x7e], ax     ; UNKNOWN
0298D2  74 0F                 JE     0x298e3                      ; UNKNOWN
0298D4  69 5E 82 3C 01        IMUL   bx, word ptr [bp - 0x7e], 0x13c ; UNKNOWN
0298D9  F6 87 AA 74 04        TEST   byte ptr [bx + 0x74aa], 4    ; UNKNOWN
0298DE  74 03                 JE     0x298e3                      ; UNKNOWN
0298E0  FF 46 AA              INC    word ptr [bp - 0x56]         ; UNKNOWN
0298E3  FF 46 82              INC    word ptr [bp - 0x7e]         ; UNKNOWN
0298E6  83 7E 82 04           CMP    word ptr [bp - 0x7e], 4      ; UNKNOWN
0298EA  7C E0                 JL     0x298cc                      ; UNKNOWN
0298EC  A1 10 3E              MOV    ax, word ptr [0x3e10]        ; UNKNOWN
0298EF  89 46 82              MOV    word ptr [bp - 0x7e], ax     ; UNKNOWN
0298F2  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0298F6  75 03                 JNE    0x298fb                      ; UNKNOWN
0298F8  E9 4E 01              JMP    0x29a49                      ; UNKNOWN
0298FB  0E                    PUSH   cs                           ; UNKNOWN
0298FC  E8 11 FF              CALL   0x29810                      ; UNKNOWN
0298FF  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
029902  2A E4                 SUB    ah, ah                       ; UNKNOWN
029904  50                    PUSH   ax                           ; UNKNOWN
029905  B8 05 00              MOV    ax, 5                        ; UNKNOWN
029908  89 46 9E              MOV    word ptr [bp - 0x62], ax     ; UNKNOWN
02990B  50                    PUSH   ax                           ; UNKNOWN
02990C  68 40 01              PUSH   0x140                        ; UNKNOWN
02990F  6A 00                 PUSH   0                            ; UNKNOWN
029911  FF 36 DE 33           PUSH   word ptr [0x33de]            ; UNKNOWN
029915  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
02991A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02991D  52                    PUSH   dx                           ; UNKNOWN
02991E  50                    PUSH   ax                           ; UNKNOWN
02991F  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
029924  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
029927  F6 06 FA 3D 10        TEST   byte ptr [0x3dfa], 0x10      ; UNKNOWN
02992C  74 2B                 JE     0x29959                      ; UNKNOWN
02992E  A0 62 09              MOV    al, byte ptr [0x962]         ; UNKNOWN
029931  2A E4                 SUB    ah, ah                       ; UNKNOWN
029933  50                    PUSH   ax                           ; UNKNOWN
029934  B8 61 00              MOV    ax, 0x61                     ; UNKNOWN
029937  89 46 9E              MOV    word ptr [bp - 0x62], ax     ; UNKNOWN
02993A  50                    PUSH   ax                           ; UNKNOWN
02993B  68 40 01              PUSH   0x140                        ; UNKNOWN
02993E  6A 00                 PUSH   0                            ; UNKNOWN
029940  FF 36 F6 33           PUSH   word ptr [0x33f6]            ; UNKNOWN
029944  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
029949  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02994C  52                    PUSH   dx                           ; UNKNOWN
02994D  50                    PUSH   ax                           ; UNKNOWN
02994E  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
029953  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
029956  E9 E5 09              JMP    0x2a33e                      ; UNKNOWN
029959  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
02995D  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
029960  2A E4                 SUB    ah, ah                       ; UNKNOWN
029962  40                    INC    ax                           ; UNKNOWN
029963  01 46 9E              ADD    word ptr [bp - 0x62], ax     ; UNKNOWN
029966  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
02996A  8A 1E 1E 3E           MOV    bl, byte ptr [0x3e1e]        ; UNKNOWN
02996E  2A FF                 SUB    bh, bh                       ; UNKNOWN
029970  D1 E3                 SHL    bx, 1                        ; UNKNOWN
029972  FF B7 E9 37           PUSH   word ptr [bx + 0x37e9]       ; UNKNOWN
029976  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029979  50                    PUSH   ax                           ; UNKNOWN
02997A  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02997F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
029982  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029985  50                    PUSH   ax                           ; UNKNOWN
029986  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
02998B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02998E  6B 46 82 34           IMUL   ax, word ptr [bp - 0x7e], 0x34 ; UNKNOWN
029992  05 86 C0              ADD    ax, 0xc086                   ; UNKNOWN
029995  50                    PUSH   ax                           ; UNKNOWN
029996  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029999  50                    PUSH   ax                           ; UNKNOWN
02999A  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
02999F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0299A2  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0299A5  50                    PUSH   ax                           ; UNKNOWN
0299A6  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
0299AB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0299AE  FF 36 20 33           PUSH   word ptr [0x3320]            ; UNKNOWN
0299B2  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0299B5  50                    PUSH   ax                           ; UNKNOWN
0299B6  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
0299BB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0299BE  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0299C1  50                    PUSH   ax                           ; UNKNOWN
0299C2  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
0299C7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0299CA  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
0299CD  9A 44 02 49 22        LCALL  0x2249, 0x244                ; UNKNOWN
0299D2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0299D5  50                    PUSH   ax                           ; UNKNOWN
0299D6  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0299D9  50                    PUSH   ax                           ; UNKNOWN
0299DA  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
0299DF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0299E2  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0299E5  50                    PUSH   ax                           ; UNKNOWN
0299E6  9A 4D 00 13 24        LCALL  0x2413, 0x4d                 ; UNKNOWN
0299EB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0299EE  8B 1E 04 3E           MOV    bx, word ptr [0x3e04]        ; UNKNOWN
0299F2  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0299F4  FF B7 D9 3D           PUSH   word ptr [bx + 0x3dd9]       ; UNKNOWN
0299F8  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
0299FB  50                    PUSH   ax                           ; UNKNOWN
0299FC  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
029A01  83 C4 04              ADD    sp, 4                        ; UNKNOWN
029A04  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029A07  50                    PUSH   ax                           ; UNKNOWN
029A08  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
029A0D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029A10  FF 36 02 3E           PUSH   word ptr [0x3e02]            ; UNKNOWN
029A14  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029A17  16                    PUSH   ss                           ; UNKNOWN
029A18  50                    PUSH   ax                           ; UNKNOWN
029A19  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
029A1E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
029A21  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
029A24  2A E4                 SUB    ah, ah                       ; UNKNOWN
029A26  50                    PUSH   ax                           ; UNKNOWN
029A27  FF 76 9E              PUSH   word ptr [bp - 0x62]         ; UNKNOWN
029A2A  68 40 01              PUSH   0x140                        ; UNKNOWN
029A2D  6A 00                 PUSH   0                            ; UNKNOWN
029A2F  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029A32  16                    PUSH   ss                           ; UNKNOWN
029A33  50                    PUSH   ax                           ; UNKNOWN
029A34  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
029A39  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
029A3C  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
029A40  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
029A43  2A E4                 SUB    ah, ah                       ; UNKNOWN
029A45  40                    INC    ax                           ; UNKNOWN
029A46  01 46 9E              ADD    word ptr [bp - 0x62], ax     ; UNKNOWN
029A49  C7 46 9E 18 00        MOV    word ptr [bp - 0x62], 0x18   ; UNKNOWN
029A4E  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
029A51  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
029A54  A3 9A 40              MOV    word ptr [0x409a], ax        ; UNKNOWN
029A57  C7 06 9C 40 20 00     MOV    word ptr [0x409c], 0x20      ; UNKNOWN
029A5D  C7 46 84 00 00        MOV    word ptr [bp - 0x7c], 0      ; UNKNOWN
029A62  EB 64                 JMP    0x29ac8                      ; UNKNOWN
029A64  C7 46 A2 00 00        MOV    word ptr [bp - 0x5e], 0      ; UNKNOWN
029A69  EB 1E                 JMP    0x29a89                      ; UNKNOWN
029A6B  83 7E 90 19           CMP    word ptr [bp - 0x70], 0x19   ; UNKNOWN
029A6F  74 0C                 JE     0x29a7d                      ; UNKNOWN
029A71  83 7E 90 1A           CMP    word ptr [bp - 0x70], 0x1a   ; UNKNOWN
029A75  74 06                 JE     0x29a7d                      ; UNKNOWN
029A77  83 7E 90 1B           CMP    word ptr [bp - 0x70], 0x1b   ; UNKNOWN
029A7B  75 05                 JNE    0x29a82                      ; UNKNOWN
029A7D  FF 46 92              INC    word ptr [bp - 0x6e]         ; UNKNOWN
029A80  EB 04                 JMP    0x29a86                      ; UNKNOWN
029A82  83 46 92 04           ADD    word ptr [bp - 0x6e], 4      ; UNKNOWN
029A86  FF 46 A2              INC    word ptr [bp - 0x5e]         ; UNKNOWN
029A89  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
029A8D  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
029A90  98                    CWDE                                ; UNKNOWN
029A91  3B 46 A2              CMP    ax, word ptr [bp - 0x5e]     ; UNKNOWN
029A94  7E 2F                 JLE    0x29ac5                      ; UNKNOWN
029A96  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
029A99  9A 30 0E 5F 24        LCALL  0x245f, 0xe30                ; UNKNOWN
029A9E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029AA1  89 46 90              MOV    word ptr [bp - 0x70], ax     ; UNKNOWN
029AA4  9A 0C 00 76 1A        LCALL  0x1a76, 0xc                  ; UNKNOWN
029AA9  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
029AAC  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
029AB0  74 07                 JE     0x29ab9                      ; UNKNOWN
029AB2  50                    PUSH   ax                           ; UNKNOWN
029AB3  E8 93 FD              CALL   0x29849                      ; UNKNOWN
029AB6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029AB9  83 7E 90 1C           CMP    word ptr [bp - 0x70], 0x1c   ; UNKNOWN
029ABD  75 AC                 JNE    0x29a6b                      ; UNKNOWN
029ABF  83 46 92 02           ADD    word ptr [bp - 0x6e], 2      ; UNKNOWN
029AC3  EB C1                 JMP    0x29a86                      ; UNKNOWN
029AC5  FF 46 84              INC    word ptr [bp - 0x7c]         ; UNKNOWN
029AC8  A1 16 3E              MOV    ax, word ptr [0x3e16]        ; UNKNOWN
029ACB  39 46 84              CMP    word ptr [bp - 0x7c], ax     ; UNKNOWN
029ACE  7D 2E                 JGE    0x29afe                      ; UNKNOWN
029AD0  FF 76 84              PUSH   word ptr [bp - 0x7c]         ; UNKNOWN
029AD3  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
029AD8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029ADB  8A 46 82              MOV    al, byte ptr [bp - 0x7e]     ; UNKNOWN
029ADE  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
029AE2  38 47 1A              CMP    byte ptr [bx + 0x1a], al     ; UNKNOWN
029AE5  75 03                 JNE    0x29aea                      ; UNKNOWN
029AE7  E9 7A FF              JMP    0x29a64                      ; UNKNOWN
029AEA  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
029AEF  74 D4                 JE     0x29ac5                      ; UNKNOWN
029AF1  A0 4A 3E              MOV    al, byte ptr [0x3e4a]        ; UNKNOWN
029AF4  38 47 1A              CMP    byte ptr [bx + 0x1a], al     ; UNKNOWN
029AF7  75 03                 JNE    0x29afc                      ; UNKNOWN
029AF9  E9 68 FF              JMP    0x29a64                      ; UNKNOWN
029AFC  EB C7                 JMP    0x29ac5                      ; UNKNOWN
029AFE  C7 46 86 00 00        MOV    word ptr [bp - 0x7a], 0      ; UNKNOWN
029B03  EB 12                 JMP    0x29b17                      ; UNKNOWN
029B05  FF 76 86              PUSH   word ptr [bp - 0x7a]         ; UNKNOWN
029B08  9A F0 08 5F 24        LCALL  0x245f, 0x8f0                ; UNKNOWN
029B0D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029B10  0B C0                 OR     ax, ax                       ; UNKNOWN
029B12  7D 2E                 JGE    0x29b42                      ; UNKNOWN
029B14  FF 46 86              INC    word ptr [bp - 0x7a]         ; UNKNOWN
029B17  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
029B1A  39 46 86              CMP    word ptr [bp - 0x7a], ax     ; UNKNOWN
029B1D  7C 03                 JL     0x29b22                      ; UNKNOWN
029B1F  E9 81 00              JMP    0x29ba3                      ; UNKNOWN
029B22  6B 5E 86 1C           IMUL   bx, word ptr [bp - 0x7a], 0x1c ; UNKNOWN
029B26  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
029B2A  24 0F                 AND    al, 0xf                      ; UNKNOWN
029B2C  3A 46 82              CMP    al, byte ptr [bp - 0x7e]     ; UNKNOWN
029B2F  74 D4                 JE     0x29b05                      ; UNKNOWN
029B31  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
029B36  74 DC                 JE     0x29b14                      ; UNKNOWN
029B38  A1 4A 3E              MOV    ax, word ptr [0x3e4a]        ; UNKNOWN
029B3B  39 46 82              CMP    word ptr [bp - 0x7e], ax     ; UNKNOWN
029B3E  74 C5                 JE     0x29b05                      ; UNKNOWN
029B40  EB D2                 JMP    0x29b14                      ; UNKNOWN
029B42  8B 46 86              MOV    ax, word ptr [bp - 0x7a]     ; UNKNOWN
029B45  9A 67 00 76 1A        LCALL  0x1a76, 0x67                 ; UNKNOWN
029B4A  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
029B4D  83 F8 4A              CMP    ax, 0x4a                     ; UNKNOWN
029B50  7C 19                 JL     0x29b6b                      ; UNKNOWN
029B52  83 F8 4E              CMP    ax, 0x4e                     ; UNKNOWN
029B55  7F 14                 JG     0x29b6b                      ; UNKNOWN
029B57  6B 5E 86 1C           IMUL   bx, word ptr [bp - 0x7a], 0x1c ; UNKNOWN
029B5B  8A 87 97 88           MOV    al, byte ptr [bx - 0x7769]   ; UNKNOWN
029B5F  98                    CWDE                                ; UNKNOWN
029B60  89 46 90              MOV    word ptr [bp - 0x70], ax     ; UNKNOWN
029B63  9A 0C 00 76 1A        LCALL  0x1a76, 0xc                  ; UNKNOWN
029B68  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
029B6B  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
029B6F  74 07                 JE     0x29b78                      ; UNKNOWN
029B71  50                    PUSH   ax                           ; UNKNOWN
029B72  E8 D4 FC              CALL   0x29849                      ; UNKNOWN
029B75  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029B78  83 7E 90 1C           CMP    word ptr [bp - 0x70], 0x1c   ; UNKNOWN
029B7C  75 06                 JNE    0x29b84                      ; UNKNOWN
029B7E  83 46 92 02           ADD    word ptr [bp - 0x6e], 2      ; UNKNOWN
029B82  EB 90                 JMP    0x29b14                      ; UNKNOWN
029B84  83 7E 90 19           CMP    word ptr [bp - 0x70], 0x19   ; UNKNOWN
029B88  74 0C                 JE     0x29b96                      ; UNKNOWN
029B8A  83 7E 90 1A           CMP    word ptr [bp - 0x70], 0x1a   ; UNKNOWN
029B8E  74 06                 JE     0x29b96                      ; UNKNOWN
029B90  83 7E 90 1B           CMP    word ptr [bp - 0x70], 0x1b   ; UNKNOWN
029B94  75 06                 JNE    0x29b9c                      ; UNKNOWN
029B96  FF 46 92              INC    word ptr [bp - 0x6e]         ; UNKNOWN
029B99  E9 78 FF              JMP    0x29b14                      ; UNKNOWN
029B9C  83 46 92 04           ADD    word ptr [bp - 0x6e], 4      ; UNKNOWN
029BA0  E9 71 FF              JMP    0x29b14                      ; UNKNOWN
029BA3  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
029BA7  75 03                 JNE    0x29bac                      ; UNKNOWN
029BA9  E9 85 00              JMP    0x29c31                      ; UNKNOWN
029BAC  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
029BB0  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
029BB3  9A 44 02 49 22        LCALL  0x2249, 0x244                ; UNKNOWN
029BB8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029BBB  50                    PUSH   ax                           ; UNKNOWN
029BBC  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029BBF  50                    PUSH   ax                           ; UNKNOWN
029BC0  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
029BC5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
029BC8  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029BCB  50                    PUSH   ax                           ; UNKNOWN
029BCC  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
029BD1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029BD4  FF 36 E0 33           PUSH   word ptr [0x33e0]            ; UNKNOWN
029BD8  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029BDB  50                    PUSH   ax                           ; UNKNOWN
029BDC  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
029BE1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
029BE4  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029BE7  50                    PUSH   ax                           ; UNKNOWN
029BE8  9A 4D 00 13 24        LCALL  0x2413, 0x4d                 ; UNKNOWN
029BED  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029BF0  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029BF3  50                    PUSH   ax                           ; UNKNOWN
029BF4  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
029BF9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029BFC  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029BFF  50                    PUSH   ax                           ; UNKNOWN
029C00  9A BD 00 13 24        LCALL  0x2413, 0xbd                 ; UNKNOWN
029C05  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029C08  FF 76 92              PUSH   word ptr [bp - 0x6e]         ; UNKNOWN
029C0B  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029C0E  16                    PUSH   ss                           ; UNKNOWN
029C0F  50                    PUSH   ax                           ; UNKNOWN
029C10  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
029C15  83 C4 06              ADD    sp, 6                        ; UNKNOWN
029C18  A0 62 09              MOV    al, byte ptr [0x962]         ; UNKNOWN
029C1B  2A E4                 SUB    ah, ah                       ; UNKNOWN
029C1D  50                    PUSH   ax                           ; UNKNOWN
029C1E  FF 76 9E              PUSH   word ptr [bp - 0x62]         ; UNKNOWN
029C21  FF 76 A4              PUSH   word ptr [bp - 0x5c]         ; UNKNOWN
029C24  8D 46 AE              LEA    ax, [bp - 0x52]              ; UNKNOWN
029C27  16                    PUSH   ss                           ; UNKNOWN
029C28  50                    PUSH   ax                           ; UNKNOWN
029C29  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
029C2E  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
029C31  C7 46 8A 10 00        MOV    word ptr [bp - 0x76], 0x10   ; UNKNOWN
029C36  A1 9C 40              MOV    ax, word ptr [0x409c]        ; UNKNOWN
029C39  83 C0 14              ADD    ax, 0x14                     ; UNKNOWN
029C3C  89 46 9E              MOV    word ptr [bp - 0x62], ax     ; UNKNOWN
029C3F  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
029C43  26 8A 0F              MOV    cl, byte ptr es:[bx]         ; UNKNOWN
029C46  2A ED                 SUB    ch, ch                       ; UNKNOWN
029C48  03 C1                 ADD    ax, cx                       ; UNKNOWN
029C4A  40                    INC    ax                           ; UNKNOWN
029C4B  89 46 88              MOV    word ptr [bp - 0x78], ax     ; UNKNOWN
029C4E  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0      ; UNKNOWN
029C53  FF 76 9A              PUSH   word ptr [bp - 0x66]         ; UNKNOWN
029C56  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
029C59  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
029C5E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
029C61  0B C0                 OR     ax, ax                       ; UNKNOWN
029C63  74 66                 JE     0x29ccb                      ; UNKNOWN
029C65  83 46 A8 05           ADD    word ptr [bp - 0x58], 5      ; UNKNOWN
029C69  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
029C6D  74 5C                 JE     0x29ccb                      ; UNKNOWN
029C6F  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0      ; UNKNOWN
029C73  8B 5E 9A              MOV    bx, word ptr [bp - 0x66]     ; UNKNOWN
029C76  8B C3                 MOV    ax, bx                       ; UNKNOWN
