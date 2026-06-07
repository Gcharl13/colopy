; ============================================================================
; func_0498BE_unknown
; Region   : load_image
; Bytes    : file 0x0498BE..0x049D3A  (1148 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0498BE  C8 A8 00 00           ENTER  0xa8, 0                      ; UNKNOWN
0498C2  57                    PUSH   di                           ; UNKNOWN
0498C3  56                    PUSH   si                           ; UNKNOWN
0498C4  0E                    PUSH   cs                           ; UNKNOWN
0498C5  E8 75 F5              CALL   0x48e3d                      ; UNKNOWN
0498C8  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
0498CB  2A E4                 SUB    ah, ah                       ; UNKNOWN
0498CD  50                    PUSH   ax                           ; UNKNOWN
0498CE  6A 05                 PUSH   5                            ; UNKNOWN
0498D0  68 40 01              PUSH   0x140                        ; UNKNOWN
0498D3  6A 00                 PUSH   0                            ; UNKNOWN
0498D5  FF 36 D2 33           PUSH   word ptr [0x33d2]            ; UNKNOWN
0498D9  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
0498DE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0498E1  52                    PUSH   dx                           ; UNKNOWN
0498E2  50                    PUSH   ax                           ; UNKNOWN
0498E3  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
0498E8  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
0498EB  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
0498EF  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
0498F2  2A E4                 SUB    ah, ah                       ; UNKNOWN
0498F4  83 C0 07              ADD    ax, 7                        ; UNKNOWN
0498F7  89 86 78 FF           MOV    word ptr [bp - 0x88], ax     ; UNKNOWN
0498FB  C6 46 84 00           MOV    byte ptr [bp - 0x7c], 0      ; UNKNOWN
0498FF  8D 46 84              LEA    ax, [bp - 0x7c]              ; UNKNOWN
049902  50                    PUSH   ax                           ; UNKNOWN
049903  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
049908  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04990B  C6 46 D4 00           MOV    byte ptr [bp - 0x2c], 0      ; UNKNOWN
04990F  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
049912  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
049915  FF B7 B4 34           PUSH   word ptr [bx + 0x34b4]       ; UNKNOWN
049919  8D 46 D4              LEA    ax, [bp - 0x2c]              ; UNKNOWN
04991C  50                    PUSH   ax                           ; UNKNOWN
04991D  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
049922  83 C4 04              ADD    sp, 4                        ; UNKNOWN
049925  83 7E 06 08           CMP    word ptr [bp + 6], 8         ; UNKNOWN
049929  7C 22                 JL     0x4994d                      ; UNKNOWN
04992B  83 7E 06 10           CMP    word ptr [bp + 6], 0x10      ; UNKNOWN
04992F  7D 1C                 JGE    0x4994d                      ; UNKNOWN
049931  8D 46 D4              LEA    ax, [bp - 0x2c]              ; UNKNOWN
049934  50                    PUSH   ax                           ; UNKNOWN
049935  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
04993A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04993D  FF 36 F0 32           PUSH   word ptr [0x32f0]            ; UNKNOWN
049941  8D 46 D4              LEA    ax, [bp - 0x2c]              ; UNKNOWN
049944  50                    PUSH   ax                           ; UNKNOWN
049945  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04994A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04994D  8D 46 D4              LEA    ax, [bp - 0x2c]              ; UNKNOWN
049950  50                    PUSH   ax                           ; UNKNOWN
049951  8D 46 84              LEA    ax, [bp - 0x7c]              ; UNKNOWN
049954  50                    PUSH   ax                           ; UNKNOWN
049955  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
04995A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04995D  8D 46 84              LEA    ax, [bp - 0x7c]              ; UNKNOWN
049960  50                    PUSH   ax                           ; UNKNOWN
049961  9A 4D 00 13 24        LCALL  0x2413, 0x4d                 ; UNKNOWN
049966  83 C4 02              ADD    sp, 2                        ; UNKNOWN
049969  6A 02                 PUSH   2                            ; UNKNOWN
04996B  8D 46 84              LEA    ax, [bp - 0x7c]              ; UNKNOWN
04996E  50                    PUSH   ax                           ; UNKNOWN
04996F  0E                    PUSH   cs                           ; UNKNOWN
049970  E8 43 F4              CALL   0x48db6                      ; UNKNOWN
049973  83 C4 04              ADD    sp, 4                        ; UNKNOWN
049976  8D 46 84              LEA    ax, [bp - 0x7c]              ; UNKNOWN
049979  50                    PUSH   ax                           ; UNKNOWN
04997A  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
04997F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
049982  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
049985  2A E4                 SUB    ah, ah                       ; UNKNOWN
049987  50                    PUSH   ax                           ; UNKNOWN
049988  FF B6 78 FF           PUSH   word ptr [bp - 0x88]         ; UNKNOWN
04998C  68 40 01              PUSH   0x140                        ; UNKNOWN
04998F  6A 00                 PUSH   0                            ; UNKNOWN
049991  8D 46 84              LEA    ax, [bp - 0x7c]              ; UNKNOWN
049994  16                    PUSH   ss                           ; UNKNOWN
049995  50                    PUSH   ax                           ; UNKNOWN
049996  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04999B  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04999E  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
0499A2  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
0499A5  2A E4                 SUB    ah, ah                       ; UNKNOWN
0499A7  40                    INC    ax                           ; UNKNOWN
0499A8  40                    INC    ax                           ; UNKNOWN
0499A9  01 86 78 FF           ADD    word ptr [bp - 0x88], ax     ; UNKNOWN
0499AD  C7 86 7C FF 07 00     MOV    word ptr [bp - 0x84], 7      ; UNKNOWN
0499B3  83 7E 06 1B           CMP    word ptr [bp + 6], 0x1b      ; UNKNOWN
0499B7  74 06                 JE     0x499bf                      ; UNKNOWN
0499B9  83 7E 06 1C           CMP    word ptr [bp + 6], 0x1c      ; UNKNOWN
0499BD  75 07                 JNE    0x499c6                      ; UNKNOWN
0499BF  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
0499C4  EB 05                 JMP    0x499cb                      ; UNKNOWN
0499C6  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0499CB  83 7E 06 19           CMP    word ptr [bp + 6], 0x19      ; UNKNOWN
0499CF  74 06                 JE     0x499d7                      ; UNKNOWN
0499D1  83 7E 06 1A           CMP    word ptr [bp + 6], 0x1a      ; UNKNOWN
0499D5  75 08                 JNE    0x499df                      ; UNKNOWN
0499D7  C7 86 6E FF 01 00     MOV    word ptr [bp - 0x92], 1      ; UNKNOWN
0499DD  EB 06                 JMP    0x499e5                      ; UNKNOWN
0499DF  C7 86 6E FF 00 00     MOV    word ptr [bp - 0x92], 0      ; UNKNOWN
0499E5  83 7E 06 18           CMP    word ptr [bp + 6], 0x18      ; UNKNOWN
0499E9  75 05                 JNE    0x499f0                      ; UNKNOWN
0499EB  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0499EE  EB 02                 JMP    0x499f2                      ; UNKNOWN
0499F0  2B C0                 SUB    ax, ax                       ; UNKNOWN
0499F2  89 86 7A FF           MOV    word ptr [bp - 0x86], ax     ; UNKNOWN
0499F6  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
0499FA  74 08                 JE     0x49a04                      ; UNKNOWN
0499FC  C7 86 62 FF 03 00     MOV    word ptr [bp - 0x9e], 3      ; UNKNOWN
049A02  EB 15                 JMP    0x49a19                      ; UNKNOWN
049A04  83 7E 06 18           CMP    word ptr [bp + 6], 0x18      ; UNKNOWN
049A08  7C 05                 JL     0x49a0f                      ; UNKNOWN
049A0A  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
049A0D  EB 06                 JMP    0x49a15                      ; UNKNOWN
049A0F  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
049A12  83 E0 07              AND    ax, 7                        ; UNKNOWN
049A15  89 86 62 FF           MOV    word ptr [bp - 0x9e], ax     ; UNKNOWN
049A19  C7 86 5A FF 00 00     MOV    word ptr [bp - 0xa6], 0      ; UNKNOWN
049A1F  83 7E 06 08           CMP    word ptr [bp + 6], 8         ; UNKNOWN
049A23  7C 06                 JL     0x49a2b                      ; UNKNOWN
049A25  83 7E 06 10           CMP    word ptr [bp + 6], 0x10      ; UNKNOWN
049A29  7C 0C                 JL     0x49a37                      ; UNKNOWN
049A2B  83 7E 06 10           CMP    word ptr [bp + 6], 0x10      ; UNKNOWN
049A2F  7C 0D                 JL     0x49a3e                      ; UNKNOWN
049A31  83 7E 06 18           CMP    word ptr [bp + 6], 0x18      ; UNKNOWN
049A35  7D 07                 JGE    0x49a3e                      ; UNKNOWN
049A37  C7 46 80 01 00        MOV    word ptr [bp - 0x80], 1      ; UNKNOWN
049A3C  EB 05                 JMP    0x49a43                      ; UNKNOWN
049A3E  C7 46 80 00 00        MOV    word ptr [bp - 0x80], 0      ; UNKNOWN
049A43  83 7E 80 00           CMP    word ptr [bp - 0x80], 0      ; UNKNOWN
049A47  74 13                 JE     0x49a5c                      ; UNKNOWN
049A49  83 BE 62 FF 01        CMP    word ptr [bp - 0x9e], 1      ; UNKNOWN
049A4E  75 0C                 JNE    0x49a5c                      ; UNKNOWN
049A50  C7 86 5A FF 01 00     MOV    word ptr [bp - 0xa6], 1      ; UNKNOWN
049A56  C7 86 62 FF 11 00     MOV    word ptr [bp - 0x9e], 0x11   ; UNKNOWN
049A5C  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
049A5F  D1 E3                 SHL    bx, 1                        ; UNKNOWN
049A61  8B 87 42 0B           MOV    ax, word ptr [bx + 0xb42]    ; UNKNOWN
049A65  89 86 72 FF           MOV    word ptr [bp - 0x8e], ax     ; UNKNOWN
049A69  8B 86 7C FF           MOV    ax, word ptr [bp - 0x84]     ; UNKNOWN
049A6D  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
049A70  83 C0 33              ADD    ax, 0x33                     ; UNKNOWN
049A73  89 86 66 FF           MOV    word ptr [bp - 0x9a], ax     ; UNKNOWN
049A77  8B 8E 78 FF           MOV    cx, word ptr [bp - 0x88]     ; UNKNOWN
049A7B  89 4E 82              MOV    word ptr [bp - 0x7e], cx     ; UNKNOWN
049A7E  83 C1 33              ADD    cx, 0x33                     ; UNKNOWN
049A81  89 8E 5E FF           MOV    word ptr [bp - 0xa2], cx     ; UNKNOWN
049A85  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
049A89  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
049A8D  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
049A91  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
049A95  51                    PUSH   cx                           ; UNKNOWN
049A96  8A 16 6B 09           MOV    dl, byte ptr [0x96b]         ; UNKNOWN
049A9A  52                    PUSH   dx                           ; UNKNOWN
049A9B  8B D8                 MOV    bx, ax                       ; UNKNOWN
049A9D  8B 96 78 FF           MOV    dx, word ptr [bp - 0x88]     ; UNKNOWN
049AA1  8B F0                 MOV    si, ax                       ; UNKNOWN
049AA3  8B 86 7C FF           MOV    ax, word ptr [bp - 0x84]     ; UNKNOWN
049AA7  8B F9                 MOV    di, cx                       ; UNKNOWN
049AA9  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
049AAE  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
049AB2  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
049AB6  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
049ABA  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
049ABE  8D 45 FF              LEA    ax, [di - 1]                 ; UNKNOWN
049AC1  50                    PUSH   ax                           ; UNKNOWN
049AC2  A0 69 09              MOV    al, byte ptr [0x969]         ; UNKNOWN
049AC5  50                    PUSH   ax                           ; UNKNOWN
049AC6  8B 86 7C FF           MOV    ax, word ptr [bp - 0x84]     ; UNKNOWN
049ACA  40                    INC    ax                           ; UNKNOWN
049ACB  8D 5C FF              LEA    bx, [si - 1]                 ; UNKNOWN
049ACE  8B 96 78 FF           MOV    dx, word ptr [bp - 0x88]     ; UNKNOWN
049AD2  42                    INC    dx                           ; UNKNOWN
049AD3  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
049AD8  C7 86 6C FF 00 00     MOV    word ptr [bp - 0x94], 0      ; UNKNOWN
049ADE  E9 83 02              JMP    0x49d64                      ; UNKNOWN
049AE1  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
049AE5  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
049AE9  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049AEC  B8 41 00              MOV    ax, 0x41                     ; UNKNOWN
049AEF  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
049AF3  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
049AF6  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
049AFB  83 BE 70 FF 01        CMP    word ptr [bp - 0x90], 1      ; UNKNOWN
049B00  75 21                 JNE    0x49b23                      ; UNKNOWN
049B02  83 BE 6C FF 02        CMP    word ptr [bp - 0x94], 2      ; UNKNOWN
049B07  75 1A                 JNE    0x49b23                      ; UNKNOWN
049B09  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
049B0D  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
049B11  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049B14  B8 96 00              MOV    ax, 0x96                     ; UNKNOWN
049B17  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
049B1B  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
049B1E  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
049B23  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
049B27  75 4D                 JNE    0x49b76                      ; UNKNOWN
049B29  83 BE 6E FF 00        CMP    word ptr [bp - 0x92], 0      ; UNKNOWN
049B2E  75 46                 JNE    0x49b76                      ; UNKNOWN
049B30  83 BE 7A FF 00        CMP    word ptr [bp - 0x86], 0      ; UNKNOWN
049B35  75 3F                 JNE    0x49b76                      ; UNKNOWN
049B37  83 BE 70 FF 00        CMP    word ptr [bp - 0x90], 0      ; UNKNOWN
049B3C  75 38                 JNE    0x49b76                      ; UNKNOWN
049B3E  83 BE 6C FF 01        CMP    word ptr [bp - 0x94], 1      ; UNKNOWN
049B43  75 10                 JNE    0x49b55                      ; UNKNOWN
049B45  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
049B49  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
049B4D  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049B50  B8 17 00              MOV    ax, 0x17                     ; UNKNOWN
049B53  EB 15                 JMP    0x49b6a                      ; UNKNOWN
049B55  83 BE 6C FF 02        CMP    word ptr [bp - 0x94], 2      ; UNKNOWN
049B5A  75 1A                 JNE    0x49b76                      ; UNKNOWN
049B5C  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
049B60  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
049B64  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049B67  B8 1B 00              MOV    ax, 0x1b                     ; UNKNOWN
049B6A  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
049B6E  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
049B71  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
049B76  83 BE 6E FF 00        CMP    word ptr [bp - 0x92], 0      ; UNKNOWN
049B7B  75 73                 JNE    0x49bf0                      ; UNKNOWN
049B7D  83 BE 70 FF 02        CMP    word ptr [bp - 0x90], 2      ; UNKNOWN
049B82  75 6C                 JNE    0x49bf0                      ; UNKNOWN
049B84  83 BE 6C FF 00        CMP    word ptr [bp - 0x94], 0      ; UNKNOWN
049B89  75 2A                 JNE    0x49bb5                      ; UNKNOWN
049B8B  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
049B8F  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
049B93  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049B96  B8 53 00              MOV    ax, 0x53                     ; UNKNOWN
049B99  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
049B9D  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
049BA0  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
049BA5  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
049BA9  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
049BAD  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049BB0  B8 56 00              MOV    ax, 0x56                     ; UNKNOWN
049BB3  EB 2F                 JMP    0x49be4                      ; UNKNOWN
049BB5  83 BE 6C FF 01        CMP    word ptr [bp - 0x94], 1      ; UNKNOWN
049BBA  75 34                 JNE    0x49bf0                      ; UNKNOWN
049BBC  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
049BC0  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
049BC4  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049BC7  B8 52 00              MOV    ax, 0x52                     ; UNKNOWN
049BCA  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
049BCE  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
049BD1  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
049BD6  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
049BDA  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
049BDE  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049BE1  B8 55 00              MOV    ax, 0x55                     ; UNKNOWN
049BE4  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
049BE8  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
049BEB  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
049BF0  83 BE 70 FF 01        CMP    word ptr [bp - 0x90], 1      ; UNKNOWN
049BF5  75 2C                 JNE    0x49c23                      ; UNKNOWN
049BF7  83 BE 6C FF 01        CMP    word ptr [bp - 0x94], 1      ; UNKNOWN
049BFC  75 25                 JNE    0x49c23                      ; UNKNOWN
049BFE  83 BE 72 FF FF        CMP    word ptr [bp - 0x8e], -1     ; UNKNOWN
049C03  74 1E                 JE     0x49c23                      ; UNKNOWN
049C05  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
049C09  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
049C0D  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049C10  8B 86 72 FF           MOV    ax, word ptr [bp - 0x8e]     ; UNKNOWN
049C14  83 C0 5A              ADD    ax, 0x5a                     ; UNKNOWN
049C17  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
049C1B  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
049C1E  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
049C23  FF 86 70 FF           INC    word ptr [bp - 0x90]         ; UNKNOWN
049C27  83 BE 70 FF 03        CMP    word ptr [bp - 0x90], 3      ; UNKNOWN
049C2C  7C 03                 JL     0x49c31                      ; UNKNOWN
049C2E  E9 2F 01              JMP    0x49d60                      ; UNKNOWN
049C31  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049C34  8B 86 70 FF           MOV    ax, word ptr [bp - 0x90]     ; UNKNOWN
049C38  C1 E0 04              SHL    ax, 4                        ; UNKNOWN
049C3B  03 86 7C FF           ADD    ax, word ptr [bp - 0x84]     ; UNKNOWN
049C3F  40                    INC    ax                           ; UNKNOWN
049C40  40                    INC    ax                           ; UNKNOWN
049C41  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
049C44  50                    PUSH   ax                           ; UNKNOWN
049C45  68 82 CE              PUSH   0xce82                       ; UNKNOWN
049C48  FF B6 62 FF           PUSH   word ptr [bp - 0x9e]         ; UNKNOWN
049C4C  FF 36 1E 0B           PUSH   word ptr [0xb1e]             ; UNKNOWN
049C50  FF 36 1C 0B           PUSH   word ptr [0xb1c]             ; UNKNOWN
049C54  9A 43 00 2D 45        LCALL  0x452d, 0x43                 ; UNKNOWN
049C59  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
049C5C  83 7E 80 00           CMP    word ptr [bp - 0x80], 0      ; UNKNOWN
049C60  74 35                 JE     0x49c97                      ; UNKNOWN
049C62  83 BE 5A FF 00        CMP    word ptr [bp - 0xa6], 0      ; UNKNOWN
049C67  75 2E                 JNE    0x49c97                      ; UNKNOWN
049C69  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
049C6D  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
049C71  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049C74  8B B6 6C FF           MOV    si, word ptr [bp - 0x94]     ; UNKNOWN
049C78  8B C6                 MOV    ax, si                       ; UNKNOWN
049C7A  D1 E6                 SHL    si, 1                        ; UNKNOWN
049C7C  03 F0                 ADD    si, ax                       ; UNKNOWN
049C7E  8B 9E 70 FF           MOV    bx, word ptr [bp - 0x90]     ; UNKNOWN
049C82  8A 80 D6 0B           MOV    al, byte ptr [bx + si + 0xbd6] ; UNKNOWN
049C86  2A E4                 SUB    ah, ah                       ; UNKNOWN
049C88  83 C0 41              ADD    ax, 0x41                     ; UNKNOWN
049C8B  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
049C8F  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
049C92  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
049C97  83 7E 06 1C           CMP    word ptr [bp + 6], 0x1c      ; UNKNOWN
049C9B  75 2E                 JNE    0x49ccb                      ; UNKNOWN
049C9D  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
049CA1  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
049CA5  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049CA8  8B B6 6C FF           MOV    si, word ptr [bp - 0x94]     ; UNKNOWN
049CAC  8B C6                 MOV    ax, si                       ; UNKNOWN
049CAE  D1 E6                 SHL    si, 1                        ; UNKNOWN
049CB0  03 F0                 ADD    si, ax                       ; UNKNOWN
049CB2  8B 9E 70 FF           MOV    bx, word ptr [bp - 0x90]     ; UNKNOWN
049CB6  8A 80 D6 0B           MOV    al, byte ptr [bx + si + 0xbd6] ; UNKNOWN
049CBA  2A E4                 SUB    ah, ah                       ; UNKNOWN
049CBC  83 C0 31              ADD    ax, 0x31                     ; UNKNOWN
049CBF  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
049CC3  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
049CC6  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
049CCB  83 7E 06 1B           CMP    word ptr [bp + 6], 0x1b      ; UNKNOWN
049CCF  75 2E                 JNE    0x49cff                      ; UNKNOWN
049CD1  FF 36 26 0B           PUSH   word ptr [0xb26]             ; UNKNOWN
049CD5  FF 36 24 0B           PUSH   word ptr [0xb24]             ; UNKNOWN
049CD9  FF 76 82              PUSH   word ptr [bp - 0x7e]         ; UNKNOWN
049CDC  8B B6 6C FF           MOV    si, word ptr [bp - 0x94]     ; UNKNOWN
049CE0  8B C6                 MOV    ax, si                       ; UNKNOWN
049CE2  D1 E6                 SHL    si, 1                        ; UNKNOWN
049CE4  03 F0                 ADD    si, ax                       ; UNKNOWN
049CE6  8B 9E 70 FF           MOV    bx, word ptr [bp - 0x90]     ; UNKNOWN
049CEA  8A 80 D6 0B           MOV    al, byte ptr [bx + si + 0xbd6] ; UNKNOWN
049CEE  2A E4                 SUB    ah, ah                       ; UNKNOWN
049CF0  83 C0 21              ADD    ax, 0x21                     ; UNKNOWN
049CF3  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
049CF7  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
049CFA  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
049CFF  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
049D03  74 03                 JE     0x49d08                      ; UNKNOWN
049D05  E9 1B FE              JMP    0x49b23                      ; UNKNOWN
049D08  83 BE 6E FF 00        CMP    word ptr [bp - 0x92], 0      ; UNKNOWN
049D0D  74 03                 JE     0x49d12                      ; UNKNOWN
049D0F  E9 11 FE              JMP    0x49b23                      ; UNKNOWN
049D12  83 7E 80 00           CMP    word ptr [bp - 0x80], 0      ; UNKNOWN
049D16  74 03                 JE     0x49d1b                      ; UNKNOWN
049D18  E9 08 FE              JMP    0x49b23                      ; UNKNOWN
049D1B  83 BE 7A FF 00        CMP    word ptr [bp - 0x86], 0      ; UNKNOWN
049D20  74 03                 JE     0x49d25                      ; UNKNOWN
049D22  E9 FE FD              JMP    0x49b23                      ; UNKNOWN
049D25  83 BE 70 FF 01        CMP    word ptr [bp - 0x90], 1      ; UNKNOWN
049D2A  75 03                 JNE    0x49d2f                      ; UNKNOWN
049D2C  E9 CC FD              JMP    0x49afb                      ; UNKNOWN
049D2F  83 BE 6C FF 01        CMP    word ptr [bp - 0x94], 1      ; UNKNOWN
049D34  75 03                 JNE    0x49d39                      ; UNKNOWN
049D36  E9 C2 FD              JMP    0x49afb                      ; UNKNOWN
049D39  83                    DB     0x83                         ; UNKNOWN (raw)
