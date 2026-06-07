; ============================================================================
; func_00A96C_unknown
; Region   : load_image
; Bytes    : file 0x00A96C..0x00AE10  (1188 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A96C  C8 68 03 00           ENTER  0x368, 0                     ; UNKNOWN
00A970  C7 46 A6 01 00        MOV    word ptr [bp - 0x5a], 1      ; UNKNOWN
00A975  C7 46 F8 C8 00        MOV    word ptr [bp - 8], 0xc8      ; UNKNOWN
00A97A  C7 46 FA 40 01        MOV    word ptr [bp - 6], 0x140     ; UNKNOWN
00A97F  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
00A984  C7 46 FE 00 A0        MOV    word ptr [bp - 2], 0xa000    ; UNKNOWN
00A989  8D 86 9A FC           LEA    ax, [bp - 0x366]             ; UNKNOWN
00A98D  16                    PUSH   ss                           ; UNKNOWN
00A98E  50                    PUSH   ax                           ; UNKNOWN
00A98F  6A 00                 PUSH   0                            ; UNKNOWN
00A991  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00A995  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00A999  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00A99D  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00A9A1  68 5E 03              PUSH   0x35e                        ; UNKNOWN
00A9A4  9A 0A 00 69 1A        LCALL  0x1a69, 0xa                  ; UNKNOWN
00A9A9  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
00A9AC  0B C0                 OR     ax, ax                       ; UNKNOWN
00A9AE  74 3C                 JE     0xa9ec                       ; UNKNOWN
00A9B0  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00A9B4  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00A9B8  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00A9BC  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00A9C0  2A C0                 SUB    al, al                       ; UNKNOWN
00A9C2  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
00A9C7  9A 2D 3F B2 00        LCALL  0xb2, 0x3f2d                 ; UNKNOWN
00A9CC  68 00 03              PUSH   0x300                        ; UNKNOWN
00A9CF  68 00 A0              PUSH   0xa000                       ; UNKNOWN
00A9D2  68 00 FC              PUSH   0xfc00                       ; UNKNOWN
00A9D5  8D 86 9A FC           LEA    ax, [bp - 0x366]             ; UNKNOWN
00A9D9  16                    PUSH   ss                           ; UNKNOWN
00A9DA  50                    PUSH   ax                           ; UNKNOWN
00A9DB  9A BE 12 65 5F        LCALL  0x5f65, 0x12be               ; UNKNOWN
00A9E0  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
00A9E3  C7 46 A0 01 00        MOV    word ptr [bp - 0x60], 1      ; UNKNOWN
00A9E8  E9 F6 00              JMP    0xaae1                       ; UNKNOWN
00A9EB  90                    NOP                                 ; UNKNOWN
00A9EC  80 3E A2 09 00        CMP    byte ptr [0x9a2], 0          ; UNKNOWN
00A9F1  74 2D                 JE     0xaa20                       ; UNKNOWN
00A9F3  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
00A9F6  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
00A9F9  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
00A9FC  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
00A9FF  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00AA03  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00AA07  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00AA0B  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00AA0F  68 B0 00              PUSH   0xb0                         ; UNKNOWN
00AA12  2B C0                 SUB    ax, ax                       ; UNKNOWN
00AA14  99                    CDQ                                 ; UNKNOWN
00AA15  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00AA18  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
00AA1D  EB 0C                 JMP    0xaa2b                       ; UNKNOWN
00AA1F  90                    NOP                                 ; UNKNOWN
00AA20  8D 86 9A FC           LEA    ax, [bp - 0x366]             ; UNKNOWN
00AA24  16                    PUSH   ss                           ; UNKNOWN
00AA25  50                    PUSH   ax                           ; UNKNOWN
00AA26  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
00AA2B  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00AA2F  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00AA33  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00AA37  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00AA3B  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00AA3E  6A 07                 PUSH   7                            ; UNKNOWN
00AA40  6A 06                 PUSH   6                            ; UNKNOWN
00AA42  2B C0                 SUB    ax, ax                       ; UNKNOWN
00AA44  99                    CDQ                                 ; UNKNOWN
00AA45  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00AA48  9A 04 00 8E 5A        LCALL  0x5a8e, 4                    ; UNKNOWN
00AA4D  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00AA51  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00AA55  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00AA59  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00AA5D  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00AA60  6A 08                 PUSH   8                            ; UNKNOWN
00AA62  6A 09                 PUSH   9                            ; UNKNOWN
00AA64  2B C0                 SUB    ax, ax                       ; UNKNOWN
00AA66  99                    CDQ                                 ; UNKNOWN
00AA67  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00AA6A  9A 04 00 8E 5A        LCALL  0x5a8e, 4                    ; UNKNOWN
00AA6F  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00AA73  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00AA77  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00AA7B  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00AA7F  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00AA82  6A 0F                 PUSH   0xf                          ; UNKNOWN
00AA84  6A 0E                 PUSH   0xe                          ; UNKNOWN
00AA86  2B C0                 SUB    ax, ax                       ; UNKNOWN
00AA88  99                    CDQ                                 ; UNKNOWN
00AA89  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00AA8C  9A 04 00 8E 5A        LCALL  0x5a8e, 4                    ; UNKNOWN
00AA91  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00AA95  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00AA99  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00AA9D  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00AAA1  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
00AAA5  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
00AAA9  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
00AAAD  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
00AAB1  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00AAB4  2B C0                 SUB    ax, ax                       ; UNKNOWN
00AAB6  99                    CDQ                                 ; UNKNOWN
00AAB7  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00AABA  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
00AABF  6A 00                 PUSH   0                            ; UNKNOWN
00AAC1  68 40 01              PUSH   0x140                        ; UNKNOWN
00AAC4  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00AAC7  2B C0                 SUB    ax, ax                       ; UNKNOWN
00AAC9  99                    CDQ                                 ; UNKNOWN
00AACA  2B DB                 SUB    bx, bx                       ; UNKNOWN
00AACC  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
00AAD1  8D 86 9A FC           LEA    ax, [bp - 0x366]             ; UNKNOWN
00AAD5  16                    PUSH   ss                           ; UNKNOWN
00AAD6  50                    PUSH   ax                           ; UNKNOWN
00AAD7  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
00AADC  C7 46 A0 00 00        MOV    word ptr [bp - 0x60], 0      ; UNKNOWN
00AAE1  6A 33                 PUSH   0x33                         ; UNKNOWN
00AAE3  9A 0E 00 04 5D        LCALL  0x5d04, 0xe                  ; UNKNOWN
00AAE8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00AAEB  9A 06 00 01 30        LCALL  0x3001, 6                    ; UNKNOWN
00AAF0  83 3E 92 CE 00        CMP    word ptr [0xce92], 0         ; UNKNOWN
00AAF5  74 05                 JE     0xaafc                       ; UNKNOWN
00AAF7  9A 07 00 1E 5C        LCALL  0x5c1e, 7                    ; UNKNOWN
00AAFC  83 7E A0 00           CMP    word ptr [bp - 0x60], 0      ; UNKNOWN
00AB00  75 05                 JNE    0xab07                       ; UNKNOWN
00AB02  9A 33 1A B2 00        LCALL  0xb2, 0x1a33                 ; UNKNOWN
00AB07  9A 06 00 01 30        LCALL  0x3001, 6                    ; UNKNOWN
00AB0C  C7 46 A2 00 00        MOV    word ptr [bp - 0x5e], 0      ; UNKNOWN
00AB11  8D 1E 67 03           LEA    bx, [0x367]                  ; UNKNOWN
00AB15  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
00AB1A  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
00AB1D  48                    DEC    ax                           ; UNKNOWN
00AB1E  7D 03                 JGE    0xab23                       ; UNKNOWN
00AB20  E9 E3 02              JMP    0xae06                       ; UNKNOWN
00AB23  48                    DEC    ax                           ; UNKNOWN
00AB24  48                    DEC    ax                           ; UNKNOWN
00AB25  7E 0F                 JLE    0xab36                       ; UNKNOWN
00AB27  48                    DEC    ax                           ; UNKNOWN
00AB28  75 03                 JNE    0xab2d                       ; UNKNOWN
00AB2A  E9 F1 00              JMP    0xac1e                       ; UNKNOWN
00AB2D  48                    DEC    ax                           ; UNKNOWN
00AB2E  75 03                 JNE    0xab33                       ; UNKNOWN
00AB30  E9 95 01              JMP    0xacc8                       ; UNKNOWN
00AB33  E9 D0 02              JMP    0xae06                       ; UNKNOWN
00AB36  C7 86 98 FC 7C 0B     MOV    word ptr [bp - 0x368], 0xb7c ; UNKNOWN
00AB3C  83 7E A4 03           CMP    word ptr [bp - 0x5c], 3      ; UNKNOWN
00AB40  75 0A                 JNE    0xab4c                       ; UNKNOWN
00AB42  8B 9E 98 FC           MOV    bx, word ptr [bp - 0x368]    ; UNKNOWN
00AB46  C7 07 01 00           MOV    word ptr [bx], 1             ; UNKNOWN
00AB4A  EB 12                 JMP    0xab5e                       ; UNKNOWN
00AB4C  6A 03                 PUSH   3                            ; UNKNOWN
00AB4E  6A 00                 PUSH   0                            ; UNKNOWN
00AB50  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
00AB55  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00AB58  8B 9E 98 FC           MOV    bx, word ptr [bp - 0x368]    ; UNKNOWN
00AB5C  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
00AB5E  83 86 98 FC 02        ADD    word ptr [bp - 0x368], 2     ; UNKNOWN
00AB63  81 BE 98 FC 86 0B     CMP    word ptr [bp - 0x368], 0xb86 ; UNKNOWN
00AB69  72 D1                 JB     0xab3c                       ; UNKNOWN
00AB6B  83 7E A4 03           CMP    word ptr [bp - 0x5c], 3      ; UNKNOWN
00AB6F  75 0E                 JNE    0xab7f                       ; UNKNOWN
00AB71  9A 7A 02 2F 23        LCALL  0x232f, 0x27a                ; UNKNOWN
00AB76  0B C0                 OR     ax, ax                       ; UNKNOWN
00AB78  74 05                 JE     0xab7f                       ; UNKNOWN
00AB7A  C7 46 A2 01 00        MOV    word ptr [bp - 0x5e], 1      ; UNKNOWN
00AB7F  9A 2D 3F B2 00        LCALL  0xb2, 0x3f2d                 ; UNKNOWN
00AB84  83 7E A4 02           CMP    word ptr [bp - 0x5c], 2      ; UNKNOWN
00AB88  75 5E                 JNE    0xabe8                       ; UNKNOWN
00AB8A  8D 1E 71 03           LEA    bx, [0x371]                  ; UNKNOWN
00AB8E  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
00AB93  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
00AB96  3D 01 00              CMP    ax, 1                        ; UNKNOWN
00AB99  7D 07                 JGE    0xaba2                       ; UNKNOWN
00AB9B  C7 46 A2 01 00        MOV    word ptr [bp - 0x5e], 1      ; UNKNOWN
00ABA0  EB 46                 JMP    0xabe8                       ; UNKNOWN
00ABA2  3D 01 00              CMP    ax, 1                        ; UNKNOWN
00ABA5  7E 41                 JLE    0xabe8                       ; UNKNOWN
00ABA7  8D 46 A8              LEA    ax, [bp - 0x58]              ; UNKNOWN
00ABAA  50                    PUSH   ax                           ; UNKNOWN
00ABAB  68 79 03              PUSH   0x379                        ; UNKNOWN
00ABAE  68 7E 03              PUSH   0x37e                        ; UNKNOWN
00ABB1  68 86 09              PUSH   0x986                        ; UNKNOWN
00ABB4  9A EA 17 B2 00        LCALL  0xb2, 0x17ea                 ; UNKNOWN
00ABB9  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00ABBC  0B C0                 OR     ax, ax                       ; UNKNOWN
00ABBE  7C DB                 JL     0xab9b                       ; UNKNOWN
00ABC0  68 32 0A              PUSH   0xa32                        ; UNKNOWN
00ABC3  8D 46 A8              LEA    ax, [bp - 0x58]              ; UNKNOWN
00ABC6  50                    PUSH   ax                           ; UNKNOWN
00ABC7  9A A6 07 65 5F        LCALL  0x5f65, 0x7a6                ; UNKNOWN
00ABCC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00ABCF  0B C0                 OR     ax, ax                       ; UNKNOWN
00ABD1  74 15                 JE     0xabe8                       ; UNKNOWN
00ABD3  C7 06 3F 0A 01 00     MOV    word ptr [0xa3f], 1          ; UNKNOWN
00ABD9  8D 46 A8              LEA    ax, [bp - 0x58]              ; UNKNOWN
00ABDC  50                    PUSH   ax                           ; UNKNOWN
00ABDD  68 32 0A              PUSH   0xa32                        ; UNKNOWN
00ABE0  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00ABE5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00ABE8  83 7E A2 00           CMP    word ptr [bp - 0x5e], 0      ; UNKNOWN
00ABEC  74 03                 JE     0xabf1                       ; UNKNOWN
00ABEE  E9 EB 00              JMP    0xacdc                       ; UNKNOWN
00ABF1  83 7E A4 02           CMP    word ptr [bp - 0x5c], 2      ; UNKNOWN
00ABF5  75 05                 JNE    0xabfc                       ; UNKNOWN
00ABF7  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00ABFA  EB 02                 JMP    0xabfe                       ; UNKNOWN
00ABFC  2B C0                 SUB    ax, ax                       ; UNKNOWN
00ABFE  50                    PUSH   ax                           ; UNKNOWN
00ABFF  9A 35 3B B2 00        LCALL  0xb2, 0x3b35                 ; UNKNOWN
00AC04  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00AC07  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
00AC0A  48                    DEC    ax                           ; UNKNOWN
00AC0B  75 05                 JNE    0xac12                       ; UNKNOWN
00AC0D  C7 46 A2 01 00        MOV    word ptr [bp - 0x5e], 1      ; UNKNOWN
00AC12  83 7E 9C 01           CMP    word ptr [bp - 0x64], 1      ; UNKNOWN
00AC16  7F 03                 JG     0xac1b                       ; UNKNOWN
00AC18  E9 C1 00              JMP    0xacdc                       ; UNKNOWN
00AC1B  E9 E8 01              JMP    0xae06                       ; UNKNOWN
00AC1E  9A 2D 3F B2 00        LCALL  0xb2, 0x3f2d                 ; UNKNOWN
00AC23  6A 00                 PUSH   0                            ; UNKNOWN
00AC25  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00AC29  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00AC2D  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00AC31  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00AC35  68 88 03              PUSH   0x388                        ; UNKNOWN
00AC38  9A 08 00 5E 1A        LCALL  0x1a5e, 8                    ; UNKNOWN
00AC3D  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
00AC40  3D 01 00              CMP    ax, 1                        ; UNKNOWN
00AC43  1B C0                 SBB    ax, ax                       ; UNKNOWN
00AC45  F7 D8                 NEG    ax                           ; UNKNOWN
00AC47  0B C0                 OR     ax, ax                       ; UNKNOWN
00AC49  74 40                 JE     0xac8b                       ; UNKNOWN
00AC4B  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00AC4F  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00AC53  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00AC57  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00AC5B  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
00AC5F  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
00AC63  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
00AC67  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
00AC6B  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00AC6E  2B C0                 SUB    ax, ax                       ; UNKNOWN
00AC70  99                    CDQ                                 ; UNKNOWN
00AC71  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00AC74  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
00AC79  6A 00                 PUSH   0                            ; UNKNOWN
00AC7B  68 40 01              PUSH   0x140                        ; UNKNOWN
00AC7E  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00AC81  2B C0                 SUB    ax, ax                       ; UNKNOWN
00AC83  99                    CDQ                                 ; UNKNOWN
00AC84  2B DB                 SUB    bx, bx                       ; UNKNOWN
00AC86  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
00AC8B  9A 4A 03 58 06        LCALL  0x658, 0x34a                 ; UNKNOWN
00AC90  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
00AC93  0B C0                 OR     ax, ax                       ; UNKNOWN
00AC95  75 29                 JNE    0xacc0                       ; UNKNOWN
00AC97  C6 06 A1 09 01        MOV    byte ptr [0x9a1], 1          ; UNKNOWN
00AC9C  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
00ACA1  74 09                 JE     0xacac                       ; UNKNOWN
00ACA3  6A 03                 PUSH   3                            ; UNKNOWN
00ACA5  9A 11 03 28 1A        LCALL  0x1a28, 0x311                ; UNKNOWN
00ACAA  EB 11                 JMP    0xacbd                       ; UNKNOWN
00ACAC  6A 01                 PUSH   1                            ; UNKNOWN
00ACAE  9A 11 03 28 1A        LCALL  0x1a28, 0x311                ; UNKNOWN
00ACB3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00ACB6  6A 02                 PUSH   2                            ; UNKNOWN
00ACB8  9A 06 03 28 1A        LCALL  0x1a28, 0x306                ; UNKNOWN
00ACBD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00ACC0  83 7E 9C 01           CMP    word ptr [bp - 0x64], 1      ; UNKNOWN
00ACC4  E9 44 FF              JMP    0xac0b                       ; UNKNOWN
00ACC7  90                    NOP                                 ; UNKNOWN
00ACC8  C7 46 A2 01 00        MOV    word ptr [bp - 0x5e], 1      ; UNKNOWN
00ACCD  9A 2D 3F B2 00        LCALL  0xb2, 0x3f2d                 ; UNKNOWN
00ACD2  6A 00                 PUSH   0                            ; UNKNOWN
00ACD4  9A 37 0F 81 20        LCALL  0x2081, 0xf37                ; UNKNOWN
00ACD9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00ACDC  83 7E A2 00           CMP    word ptr [bp - 0x5e], 0      ; UNKNOWN
00ACE0  75 03                 JNE    0xace5                       ; UNKNOWN
00ACE2  E9 13 01              JMP    0xadf8                       ; UNKNOWN
00ACE5  8D 86 9A FC           LEA    ax, [bp - 0x366]             ; UNKNOWN
00ACE9  16                    PUSH   ss                           ; UNKNOWN
00ACEA  50                    PUSH   ax                           ; UNKNOWN
00ACEB  6A 00                 PUSH   0                            ; UNKNOWN
00ACED  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00ACF1  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00ACF5  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00ACF9  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00ACFD  68 91 03              PUSH   0x391                        ; UNKNOWN
00AD00  9A 0A 00 69 1A        LCALL  0x1a69, 0xa                  ; UNKNOWN
00AD05  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
00AD08  0B C0                 OR     ax, ax                       ; UNKNOWN
00AD0A  74 36                 JE     0xad42                       ; UNKNOWN
00AD0C  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00AD10  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00AD14  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00AD18  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00AD1C  2A C0                 SUB    al, al                       ; UNKNOWN
00AD1E  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
00AD23  9A 2D 3F B2 00        LCALL  0xb2, 0x3f2d                 ; UNKNOWN
00AD28  68 00 03              PUSH   0x300                        ; UNKNOWN
00AD2B  68 00 A0              PUSH   0xa000                       ; UNKNOWN
00AD2E  68 00 FC              PUSH   0xfc00                       ; UNKNOWN
00AD31  8D 86 9A FC           LEA    ax, [bp - 0x366]             ; UNKNOWN
00AD35  16                    PUSH   ss                           ; UNKNOWN
00AD36  50                    PUSH   ax                           ; UNKNOWN
00AD37  9A BE 12 65 5F        LCALL  0x5f65, 0x12be               ; UNKNOWN
00AD3C  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
00AD3F  E9 B6 00              JMP    0xadf8                       ; UNKNOWN
00AD42  9A 42 3F B2 00        LCALL  0xb2, 0x3f42                 ; UNKNOWN
00AD47  8D 86 9A FC           LEA    ax, [bp - 0x366]             ; UNKNOWN
00AD4B  16                    PUSH   ss                           ; UNKNOWN
00AD4C  50                    PUSH   ax                           ; UNKNOWN
00AD4D  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
00AD52  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00AD56  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00AD5A  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00AD5E  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00AD62  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00AD65  6A 07                 PUSH   7                            ; UNKNOWN
00AD67  6A 06                 PUSH   6                            ; UNKNOWN
00AD69  2B C0                 SUB    ax, ax                       ; UNKNOWN
00AD6B  99                    CDQ                                 ; UNKNOWN
00AD6C  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00AD6F  9A 04 00 8E 5A        LCALL  0x5a8e, 4                    ; UNKNOWN
00AD74  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00AD78  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00AD7C  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00AD80  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00AD84  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00AD87  6A 08                 PUSH   8                            ; UNKNOWN
00AD89  6A 09                 PUSH   9                            ; UNKNOWN
00AD8B  2B C0                 SUB    ax, ax                       ; UNKNOWN
00AD8D  99                    CDQ                                 ; UNKNOWN
00AD8E  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00AD91  9A 04 00 8E 5A        LCALL  0x5a8e, 4                    ; UNKNOWN
00AD96  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00AD9A  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00AD9E  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00ADA2  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00ADA6  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00ADA9  6A 0F                 PUSH   0xf                          ; UNKNOWN
00ADAB  6A 0E                 PUSH   0xe                          ; UNKNOWN
00ADAD  2B C0                 SUB    ax, ax                       ; UNKNOWN
00ADAF  99                    CDQ                                 ; UNKNOWN
00ADB0  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00ADB3  9A 04 00 8E 5A        LCALL  0x5a8e, 4                    ; UNKNOWN
00ADB8  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00ADBC  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00ADC0  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00ADC4  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00ADC8  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
00ADCC  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
00ADD0  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
00ADD4  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
00ADD8  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00ADDB  2B C0                 SUB    ax, ax                       ; UNKNOWN
00ADDD  99                    CDQ                                 ; UNKNOWN
00ADDE  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00ADE1  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
00ADE6  6A 00                 PUSH   0                            ; UNKNOWN
00ADE8  68 40 01              PUSH   0x140                        ; UNKNOWN
00ADEB  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00ADEE  2B C0                 SUB    ax, ax                       ; UNKNOWN
00ADF0  99                    CDQ                                 ; UNKNOWN
00ADF1  2B DB                 SUB    bx, bx                       ; UNKNOWN
00ADF3  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
00ADF8  83 7E A2 00           CMP    word ptr [bp - 0x5e], 0      ; UNKNOWN
00ADFC  74 03                 JE     0xae01                       ; UNKNOWN
00ADFE  E9 FB FC              JMP    0xaafc                       ; UNKNOWN
00AE01  C7 46 A6 00 00        MOV    word ptr [bp - 0x5a], 0      ; UNKNOWN
00AE06  9A 2D 3F B2 00        LCALL  0xb2, 0x3f2d                 ; UNKNOWN
00AE0B  8B 46 A6              MOV    ax, word ptr [bp - 0x5a]     ; UNKNOWN
00AE0E  C9                    LEAVE                               ; UNKNOWN
00AE0F  CB                    RETF                                ; UNKNOWN
