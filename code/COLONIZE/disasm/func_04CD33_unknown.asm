; ============================================================================
; func_04CD33_unknown
; Region   : load_image
; Bytes    : file 0x04CD33..0x04CFC4  (657 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04CD33  C8 66 00 00           ENTER  0x66, 0                      ; UNKNOWN
04CD37  56                    PUSH   si                           ; UNKNOWN
04CD38  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04CD3B  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
04CD40  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04CD43  C7 46 AA 02 00        MOV    word ptr [bp - 0x56], 2      ; UNKNOWN
04CD48  C7 46 A8 14 00        MOV    word ptr [bp - 0x58], 0x14   ; UNKNOWN
04CD4D  0E                    PUSH   cs                           ; UNKNOWN
04CD4E  E8 8B FF              CALL   0x4ccdc                      ; UNKNOWN
04CD51  2B C0                 SUB    ax, ax                       ; UNKNOWN
04CD53  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
04CD56  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
04CD59  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
04CD5C  E9 30 01              JMP    0x4ce8f                      ; UNKNOWN
04CD5F  6A 13                 PUSH   0x13                         ; UNKNOWN
04CD61  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
04CD66  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04CD69  0B C0                 OR     ax, ax                       ; UNKNOWN
04CD6B  74 10                 JE     0x4cd7d                      ; UNKNOWN
04CD6D  FF 36 8E 34           PUSH   word ptr [0x348e]            ; UNKNOWN
04CD71  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04CD74  50                    PUSH   ax                           ; UNKNOWN
04CD75  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04CD7A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04CD7D  68 92 00              PUSH   0x92                         ; UNKNOWN
04CD80  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
04CD83  83 C0 07              ADD    ax, 7                        ; UNKNOWN
04CD86  50                    PUSH   ax                           ; UNKNOWN
04CD87  8B 4E A0              MOV    cx, word ptr [bp - 0x60]     ; UNKNOWN
04CD8A  83 C1 03              ADD    cx, 3                        ; UNKNOWN
04CD8D  51                    PUSH   cx                           ; UNKNOWN
04CD8E  8D 4E B0              LEA    cx, [bp - 0x50]              ; UNKNOWN
04CD91  16                    PUSH   ss                           ; UNKNOWN
04CD92  51                    PUSH   cx                           ; UNKNOWN
04CD93  8B F0                 MOV    si, ax                       ; UNKNOWN
04CD95  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04CD9A  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04CD9D  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
04CDA1  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
04CDA5  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
04CDA8  40                    INC    ax                           ; UNKNOWN
04CDA9  40                    INC    ax                           ; UNKNOWN
04CDAA  50                    PUSH   ax                           ; UNKNOWN
04CDAB  B8 3F 00              MOV    ax, 0x3f                     ; UNKNOWN
04CDAE  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
04CDB2  BA D2 00              MOV    dx, 0xd2                     ; UNKNOWN
04CDB5  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
04CDBA  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
04CDBE  26 8B 87 32 03        MOV    ax, word ptr es:[bx + 0x332] ; UNKNOWN
04CDC3  05 D4 00              ADD    ax, 0xd4                     ; UNKNOWN
04CDC6  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
04CDC9  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
04CDCD  FF 36 AC 73           PUSH   word ptr [0x73ac]            ; UNKNOWN
04CDD1  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04CDD4  16                    PUSH   ss                           ; UNKNOWN
04CDD5  50                    PUSH   ax                           ; UNKNOWN
04CDD6  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
04CDDB  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04CDDE  68 92 00              PUSH   0x92                         ; UNKNOWN
04CDE1  56                    PUSH   si                           ; UNKNOWN
04CDE2  8B 46 A0              MOV    ax, word ptr [bp - 0x60]     ; UNKNOWN
04CDE5  83 C0 03              ADD    ax, 3                        ; UNKNOWN
04CDE8  50                    PUSH   ax                           ; UNKNOWN
04CDE9  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04CDEC  16                    PUSH   ss                           ; UNKNOWN
04CDED  50                    PUSH   ax                           ; UNKNOWN
04CDEE  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04CDF3  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04CDF6  C7 46 A0 FA 00        MOV    word ptr [bp - 0x60], 0xfa   ; UNKNOWN
04CDFB  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0      ; UNKNOWN
04CE00  EB 36                 JMP    0x4ce38                      ; UNKNOWN
04CE02  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
04CE05  9A F7 0D 5F 24        LCALL  0x245f, 0xdf7                ; UNKNOWN
04CE0A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04CE0D  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
04CE10  83 F8 11              CMP    ax, 0x11                     ; UNKNOWN
04CE13  75 20                 JNE    0x4ce35                      ; UNKNOWN
04CE15  6A 07                 PUSH   7                            ; UNKNOWN
04CE17  FF 76 AC              PUSH   word ptr [bp - 0x54]         ; UNKNOWN
04CE1A  9A F5 0E 5F 24        LCALL  0x245f, 0xef5                ; UNKNOWN
04CE1F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04CE22  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
04CE25  8B 5E A8              MOV    bx, word ptr [bp - 0x58]     ; UNKNOWN
04CE28  43                    INC    bx                           ; UNKNOWN
04CE29  8B 56 A0              MOV    dx, word ptr [bp - 0x60]     ; UNKNOWN
04CE2C  9A 60 01 76 1A        LCALL  0x1a76, 0x160                ; UNKNOWN
04CE31  83 46 A0 0C           ADD    word ptr [bp - 0x60], 0xc    ; UNKNOWN
04CE35  FF 46 AC              INC    word ptr [bp - 0x54]         ; UNKNOWN
04CE38  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
04CE3C  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
04CE3F  98                    CWDE                                ; UNKNOWN
04CE40  3B 46 AC              CMP    ax, word ptr [bp - 0x54]     ; UNKNOWN
04CE43  7F BD                 JG     0x4ce02                      ; UNKNOWN
04CE45  83 46 A8 11           ADD    word ptr [bp - 0x58], 0x11   ; UNKNOWN
04CE49  FF 46 9A              INC    word ptr [bp - 0x66]         ; UNKNOWN
04CE4C  83 7E 9A 09           CMP    word ptr [bp - 0x66], 9      ; UNKNOWN
04CE50  7C 3A                 JL     0x4ce8c                      ; UNKNOWN
04CE52  6A FF                 PUSH   -1                           ; UNKNOWN
04CE54  6A FE                 PUSH   -2                           ; UNKNOWN
04CE56  0E                    PUSH   cs                           ; UNKNOWN
04CE57  E8 91 E3              CALL   0x4b1eb                      ; UNKNOWN
04CE5A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04CE5D  6A 00                 PUSH   0                            ; UNKNOWN
04CE5F  68 40 01              PUSH   0x140                        ; UNKNOWN
04CE62  68 C8 00              PUSH   0xc8                         ; UNKNOWN
04CE65  2B C0                 SUB    ax, ax                       ; UNKNOWN
04CE67  99                    CDQ                                 ; UNKNOWN
04CE68  2B DB                 SUB    bx, bx                       ; UNKNOWN
04CE6A  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
04CE6F  9A 6B 00 EF 21        LCALL  0x21ef, 0x6b                 ; UNKNOWN
04CE74  0E                    PUSH   cs                           ; UNKNOWN
04CE75  E8 64 FE              CALL   0x4ccdc                      ; UNKNOWN
04CE78  C7 46 AA 02 00        MOV    word ptr [bp - 0x56], 2      ; UNKNOWN
04CE7D  C7 46 A8 14 00        MOV    word ptr [bp - 0x58], 0x14   ; UNKNOWN
04CE82  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0      ; UNKNOWN
04CE87  C7 46 AE 01 00        MOV    word ptr [bp - 0x52], 1      ; UNKNOWN
04CE8C  FF 46 A4              INC    word ptr [bp - 0x5c]         ; UNKNOWN
04CE8F  8B 46 A4              MOV    ax, word ptr [bp - 0x5c]     ; UNKNOWN
04CE92  39 06 16 3E           CMP    word ptr [0x3e16], ax        ; UNKNOWN
04CE96  7F 03                 JG     0x4ce9b                      ; UNKNOWN
04CE98  E9 F8 00              JMP    0x4cf93                      ; UNKNOWN
04CE9B  50                    PUSH   ax                           ; UNKNOWN
04CE9C  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
04CEA1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04CEA4  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
04CEA7  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
04CEAB  38 47 1A              CMP    byte ptr [bx + 0x1a], al     ; UNKNOWN
04CEAE  75 DC                 JNE    0x4ce8c                      ; UNKNOWN
04CEB0  9A 8F 26 5F 24        LCALL  0x245f, 0x268f               ; UNKNOWN
04CEB5  9A DB 38 5F 24        LCALL  0x245f, 0x38db               ; UNKNOWN
04CEBA  9A 24 1F 5F 24        LCALL  0x245f, 0x1f24               ; UNKNOWN
04CEBF  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04CEC3  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04CEC7  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04CECB  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04CECF  6A 64                 PUSH   0x64                         ; UNKNOWN
04CED1  6A 01                 PUSH   1                            ; UNKNOWN
04CED3  6A 00                 PUSH   0                            ; UNKNOWN
04CED5  8B 56 AA              MOV    dx, word ptr [bp - 0x56]     ; UNKNOWN
04CED8  42                    INC    dx                           ; UNKNOWN
04CED9  42                    INC    dx                           ; UNKNOWN
04CEDA  A1 86 73              MOV    ax, word ptr [0x7386]        ; UNKNOWN
04CEDD  8B 5E A8              MOV    bx, word ptr [bp - 0x58]     ; UNKNOWN
04CEE0  9A 5A 0C 76 1A        LCALL  0x1a76, 0xc5a                ; UNKNOWN
04CEE5  68 92 00              PUSH   0x92                         ; UNKNOWN
04CEE8  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
04CEEB  83 C0 07              ADD    ax, 7                        ; UNKNOWN
04CEEE  50                    PUSH   ax                           ; UNKNOWN
04CEEF  8B 4E AA              MOV    cx, word ptr [bp - 0x56]     ; UNKNOWN
04CEF2  83 C1 17              ADD    cx, 0x17                     ; UNKNOWN
04CEF5  51                    PUSH   cx                           ; UNKNOWN
04CEF6  8B 0E 38 73           MOV    cx, word ptr [0x7338]        ; UNKNOWN
04CEFA  41                    INC    cx                           ; UNKNOWN
04CEFB  41                    INC    cx                           ; UNKNOWN
04CEFC  1E                    PUSH   ds                           ; UNKNOWN
04CEFD  51                    PUSH   cx                           ; UNKNOWN
04CEFE  8B F0                 MOV    si, ax                       ; UNKNOWN
04CF00  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04CF05  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04CF08  89 76 9C              MOV    word ptr [bp - 0x64], si     ; UNKNOWN
04CF0B  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
04CF0F  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
04CF13  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
04CF16  40                    INC    ax                           ; UNKNOWN
04CF17  40                    INC    ax                           ; UNKNOWN
04CF18  50                    PUSH   ax                           ; UNKNOWN
04CF19  B8 7C 00              MOV    ax, 0x7c                     ; UNKNOWN
04CF1C  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
04CF20  BA 6E 00              MOV    dx, 0x6e                     ; UNKNOWN
04CF23  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
04CF28  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
04CF2C  26 8B 87 0E 06        MOV    ax, word ptr es:[bx + 0x60e] ; UNKNOWN
04CF31  83 C0 70              ADD    ax, 0x70                     ; UNKNOWN
04CF34  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
04CF37  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
04CF3B  9A 71 02 5F 24        LCALL  0x245f, 0x271                ; UNKNOWN
04CF40  50                    PUSH   ax                           ; UNKNOWN
04CF41  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04CF44  16                    PUSH   ss                           ; UNKNOWN
04CF45  50                    PUSH   ax                           ; UNKNOWN
04CF46  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
04CF4B  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04CF4E  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04CF51  50                    PUSH   ax                           ; UNKNOWN
04CF52  9A 6D 00 13 24        LCALL  0x2413, 0x6d                 ; UNKNOWN
04CF57  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04CF5A  68 92 00              PUSH   0x92                         ; UNKNOWN
04CF5D  56                    PUSH   si                           ; UNKNOWN
04CF5E  8B 46 A0              MOV    ax, word ptr [bp - 0x60]     ; UNKNOWN
04CF61  83 C0 03              ADD    ax, 3                        ; UNKNOWN
04CF64  50                    PUSH   ax                           ; UNKNOWN
04CF65  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04CF68  16                    PUSH   ss                           ; UNKNOWN
04CF69  50                    PUSH   ax                           ; UNKNOWN
04CF6A  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
04CF6F  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04CF72  C7 46 A0 96 00        MOV    word ptr [bp - 0x60], 0x96   ; UNKNOWN
04CF77  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
04CF7B  6A 14                 PUSH   0x14                         ; UNKNOWN
04CF7D  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
04CF82  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04CF85  0B C0                 OR     ax, ax                       ; UNKNOWN
04CF87  75 03                 JNE    0x4cf8c                      ; UNKNOWN
04CF89  E9 D3 FD              JMP    0x4cd5f                      ; UNKNOWN
04CF8C  FF 36 03 3A           PUSH   word ptr [0x3a03]            ; UNKNOWN
04CF90  E9 DE FD              JMP    0x4cd71                      ; UNKNOWN
04CF93  83 7E 9A 00           CMP    word ptr [bp - 0x66], 0      ; UNKNOWN
04CF97  75 06                 JNE    0x4cf9f                      ; UNKNOWN
04CF99  83 7E AE 00           CMP    word ptr [bp - 0x52], 0      ; UNKNOWN
04CF9D  75 22                 JNE    0x4cfc1                      ; UNKNOWN
04CF9F  6A FF                 PUSH   -1                           ; UNKNOWN
04CFA1  6A FE                 PUSH   -2                           ; UNKNOWN
04CFA3  0E                    PUSH   cs                           ; UNKNOWN
04CFA4  E8 44 E2              CALL   0x4b1eb                      ; UNKNOWN
04CFA7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04CFAA  6A 00                 PUSH   0                            ; UNKNOWN
04CFAC  68 40 01              PUSH   0x140                        ; UNKNOWN
04CFAF  68 C8 00              PUSH   0xc8                         ; UNKNOWN
04CFB2  2B C0                 SUB    ax, ax                       ; UNKNOWN
04CFB4  99                    CDQ                                 ; UNKNOWN
04CFB5  2B DB                 SUB    bx, bx                       ; UNKNOWN
04CFB7  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
04CFBC  9A 6B 00 EF 21        LCALL  0x21ef, 0x6b                 ; UNKNOWN
04CFC1  5E                    POP    si                           ; UNKNOWN
04CFC2  C9                    LEAVE                               ; UNKNOWN
04CFC3  CB                    RETF                                ; UNKNOWN
