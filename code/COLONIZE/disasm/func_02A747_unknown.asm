; ============================================================================
; func_02A747_unknown
; Region   : load_image
; Bytes    : file 0x02A747..0x02AC97  (1360 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02A747  C8 60 01 00           ENTER  0x160, 0                     ; UNKNOWN
02A74B  57                    PUSH   di                           ; UNKNOWN
02A74C  56                    PUSH   si                           ; UNKNOWN
02A74D  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02A752  68 3D 1A              PUSH   0x1a3d                       ; UNKNOWN
02A755  68 40 1A              PUSH   0x1a40                       ; UNKNOWN
02A758  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
02A75D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02A760  89 86 A4 FE           MOV    word ptr [bp - 0x15c], ax    ; UNKNOWN
02A764  0B C0                 OR     ax, ax                       ; UNKNOWN
02A766  74 31                 JE     0x2a799                      ; UNKNOWN
02A768  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
02A76D  50                    PUSH   ax                           ; UNKNOWN
02A76E  6A 01                 PUSH   1                            ; UNKNOWN
02A770  68 D2 00              PUSH   0xd2                         ; UNKNOWN
02A773  8D 86 00 FF           LEA    ax, [bp - 0x100]             ; UNKNOWN
02A777  50                    PUSH   ax                           ; UNKNOWN
02A778  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
02A77D  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02A780  0B C0                 OR     ax, ax                       ; UNKNOWN
02A782  75 03                 JNE    0x2a787                      ; UNKNOWN
02A784  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02A787  FF B6 A4 FE           PUSH   word ptr [bp - 0x15c]        ; UNKNOWN
02A78B  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
02A790  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02A793  C7 86 A4 FE 00 00     MOV    word ptr [bp - 0x15c], 0     ; UNKNOWN
02A799  C7 86 A6 FE 00 00     MOV    word ptr [bp - 0x15a], 0     ; UNKNOWN
02A79F  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
02A7A3  74 07                 JE     0x2a7ac                      ; UNKNOWN
02A7A5  83 BE A6 FE 05        CMP    word ptr [bp - 0x15a], 5     ; UNKNOWN
02A7AA  75 2F                 JNE    0x2a7db                      ; UNKNOWN
02A7AC  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; UNKNOWN
02A7B1  C6 82 00 FF 00        MOV    byte ptr [bp + si - 0x100], 0 ; UNKNOWN
02A7B6  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
02A7B9  89 82 18 FF           MOV    word ptr [bp + si - 0xe8], ax ; UNKNOWN
02A7BD  89 82 24 FF           MOV    word ptr [bp + si - 0xdc], ax ; UNKNOWN
02A7C1  89 82 26 FF           MOV    word ptr [bp + si - 0xda], ax ; UNKNOWN
02A7C5  2B C0                 SUB    ax, ax                       ; UNKNOWN
02A7C7  89 82 22 FF           MOV    word ptr [bp + si - 0xde], ax ; UNKNOWN
02A7CB  89 82 1E FF           MOV    word ptr [bp + si - 0xe2], ax ; UNKNOWN
02A7CF  89 82 20 FF           MOV    word ptr [bp + si - 0xe0], ax ; UNKNOWN
02A7D3  89 82 1A FF           MOV    word ptr [bp + si - 0xe6], ax ; UNKNOWN
02A7D7  89 82 1C FF           MOV    word ptr [bp + si - 0xe4], ax ; UNKNOWN
02A7DB  FF 86 A6 FE           INC    word ptr [bp - 0x15a]        ; UNKNOWN
02A7DF  83 BE A6 FE 06        CMP    word ptr [bp - 0x15a], 6     ; UNKNOWN
02A7E4  7C B9                 JL     0x2a79f                      ; UNKNOWN
02A7E6  C7 86 AC FE FF FF     MOV    word ptr [bp - 0x154], 0xffff ; UNKNOWN
02A7EC  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
02A7F0  74 4C                 JE     0x2a83e                      ; UNKNOWN
02A7F2  C7 86 A6 FE 00 00     MOV    word ptr [bp - 0x15a], 0     ; UNKNOWN
02A7F8  EB 6C                 JMP    0x2a866                      ; UNKNOWN
02A7FA  6B B6 AA FE 2A        IMUL   si, word ptr [bp - 0x156], 0x2a ; UNKNOWN
02A7FF  8D BA 00 FF           LEA    di, [bp + si - 0x100]        ; UNKNOWN
02A803  8D B2 D6 FE           LEA    si, [bp + si - 0x12a]        ; UNKNOWN
02A807  8C D0                 MOV    ax, ss                       ; UNKNOWN
02A809  8E C0                 MOV    es, ax                       ; UNKNOWN
02A80B  B9 15 00              MOV    cx, 0x15                     ; UNKNOWN
02A80E  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; UNKNOWN
02A810  FF 8E AA FE           DEC    word ptr [bp - 0x156]        ; UNKNOWN
02A814  8B 86 A6 FE           MOV    ax, word ptr [bp - 0x15a]    ; UNKNOWN
02A818  39 86 AA FE           CMP    word ptr [bp - 0x156], ax    ; UNKNOWN
02A81C  7F DC                 JG     0x2a7fa                      ; UNKNOWN
02A81E  6B F0 2A              IMUL   si, ax, 0x2a                 ; UNKNOWN
02A821  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02A824  8D BA 00 FF           LEA    di, [bp + si - 0x100]        ; UNKNOWN
02A828  8B F0                 MOV    si, ax                       ; UNKNOWN
02A82A  16                    PUSH   ss                           ; UNKNOWN
02A82B  07                    POP    es                           ; UNKNOWN
02A82C  B9 15 00              MOV    cx, 0x15                     ; UNKNOWN
02A82F  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; UNKNOWN
02A831  8B 86 A6 FE           MOV    ax, word ptr [bp - 0x15a]    ; UNKNOWN
02A835  89 86 AC FE           MOV    word ptr [bp - 0x154], ax    ; UNKNOWN
02A839  C7 46 06 00 00        MOV    word ptr [bp + 6], 0         ; UNKNOWN
02A83E  6A 00                 PUSH   0                            ; UNKNOWN
02A840  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02A844  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02A848  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02A84C  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02A850  68 4D 1A              PUSH   0x1a4d                       ; UNKNOWN
02A853  9A 08 00 5E 1A        LCALL  0x1a5e, 8                    ; UNKNOWN
02A858  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
02A85B  0B C0                 OR     ax, ax                       ; UNKNOWN
02A85D  74 2E                 JE     0x2a88d                      ; UNKNOWN
02A85F  E9 1E 04              JMP    0x2ac80                      ; UNKNOWN
02A862  FF 86 A6 FE           INC    word ptr [bp - 0x15a]        ; UNKNOWN
02A866  83 BE A6 FE 06        CMP    word ptr [bp - 0x15a], 6     ; UNKNOWN
02A86B  7D D1                 JGE    0x2a83e                      ; UNKNOWN
02A86D  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02A870  8B 47 26              MOV    ax, word ptr [bx + 0x26]     ; UNKNOWN
02A873  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; UNKNOWN
02A878  39 82 26 FF           CMP    word ptr [bp + si - 0xda], ax ; UNKNOWN
02A87C  7C 07                 JL     0x2a885                      ; UNKNOWN
02A87E  83 BE A6 FE 05        CMP    word ptr [bp - 0x15a], 5     ; UNKNOWN
02A883  75 DD                 JNE    0x2a862                      ; UNKNOWN
02A885  C7 86 AA FE 05 00     MOV    word ptr [bp - 0x156], 5     ; UNKNOWN
02A88B  EB 87                 JMP    0x2a814                      ; UNKNOWN
02A88D  A0 65 09              MOV    al, byte ptr [0x965]         ; UNKNOWN
02A890  2A E4                 SUB    ah, ah                       ; UNKNOWN
02A892  50                    PUSH   ax                           ; UNKNOWN
02A893  A0 62 09              MOV    al, byte ptr [0x962]         ; UNKNOWN
02A896  50                    PUSH   ax                           ; UNKNOWN
02A897  6A 03                 PUSH   3                            ; UNKNOWN
02A899  68 40 01              PUSH   0x140                        ; UNKNOWN
02A89C  6A 00                 PUSH   0                            ; UNKNOWN
02A89E  FF 36 7A 34           PUSH   word ptr [0x347a]            ; UNKNOWN
02A8A2  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
02A8A7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02A8AA  52                    PUSH   dx                           ; UNKNOWN
02A8AB  50                    PUSH   ax                           ; UNKNOWN
02A8AC  9A 36 04 13 24        LCALL  0x2413, 0x436                ; UNKNOWN
02A8B1  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
02A8B4  C7 86 A8 FE 10 00     MOV    word ptr [bp - 0x158], 0x10  ; UNKNOWN
02A8BA  C7 86 AE FE 0A 00     MOV    word ptr [bp - 0x152], 0xa   ; UNKNOWN
02A8C0  C7 86 A6 FE 00 00     MOV    word ptr [bp - 0x15a], 0     ; UNKNOWN
02A8C6  E9 CE 01              JMP    0x2aa97                      ; UNKNOWN
02A8C9  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; UNKNOWN
02A8CE  83 BA 1A FF 00        CMP    word ptr [bp + si - 0xe6], 0 ; UNKNOWN
02A8D3  74 06                 JE     0x2a8db                      ; UNKNOWN
02A8D5  FF 36 82 34           PUSH   word ptr [0x3482]            ; UNKNOWN
02A8D9  EB 4E                 JMP    0x2a929                      ; UNKNOWN
02A8DB  FF 36 84 34           PUSH   word ptr [0x3484]            ; UNKNOWN
02A8DF  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A8E3  50                    PUSH   ax                           ; UNKNOWN
02A8E4  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02A8E9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02A8EC  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A8F0  50                    PUSH   ax                           ; UNKNOWN
02A8F1  9A 3D 00 13 24        LCALL  0x2413, 0x3d                 ; UNKNOWN
02A8F6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02A8F9  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; UNKNOWN
02A8FE  FF B2 18 FF           PUSH   word ptr [bp + si - 0xe8]    ; UNKNOWN
02A902  9A 44 02 49 22        LCALL  0x2249, 0x244                ; UNKNOWN
02A907  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02A90A  50                    PUSH   ax                           ; UNKNOWN
02A90B  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A90F  50                    PUSH   ax                           ; UNKNOWN
02A910  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02A915  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02A918  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A91C  50                    PUSH   ax                           ; UNKNOWN
02A91D  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
02A922  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02A925  FF 36 B8 33           PUSH   word ptr [0x33b8]            ; UNKNOWN
02A929  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A92D  50                    PUSH   ax                           ; UNKNOWN
02A92E  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02A933  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02A936  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A93A  50                    PUSH   ax                           ; UNKNOWN
02A93B  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
02A940  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02A943  FF 36 7C 34           PUSH   word ptr [0x347c]            ; UNKNOWN
02A947  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A94B  50                    PUSH   ax                           ; UNKNOWN
02A94C  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02A951  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02A954  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A958  50                    PUSH   ax                           ; UNKNOWN
02A959  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
02A95E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02A961  FF 36 7E 34           PUSH   word ptr [0x347e]            ; UNKNOWN
02A965  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A969  50                    PUSH   ax                           ; UNKNOWN
02A96A  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02A96F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02A972  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A976  50                    PUSH   ax                           ; UNKNOWN
02A977  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
02A97C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02A97F  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; UNKNOWN
02A984  FF B2 1E FF           PUSH   word ptr [bp + si - 0xe2]    ; UNKNOWN
02A988  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A98C  16                    PUSH   ss                           ; UNKNOWN
02A98D  50                    PUSH   ax                           ; UNKNOWN
02A98E  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
02A993  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02A996  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A99A  50                    PUSH   ax                           ; UNKNOWN
02A99B  9A 5D 00 13 24        LCALL  0x2413, 0x5d                 ; UNKNOWN
02A9A0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02A9A3  FF 36 86 34           PUSH   word ptr [0x3486]            ; UNKNOWN
02A9A7  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A9AB  50                    PUSH   ax                           ; UNKNOWN
02A9AC  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02A9B1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02A9B4  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A9B8  50                    PUSH   ax                           ; UNKNOWN
02A9B9  9A 4D 00 13 24        LCALL  0x2413, 0x4d                 ; UNKNOWN
02A9BE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02A9C1  FF B2 24 FF           PUSH   word ptr [bp + si - 0xdc]    ; UNKNOWN
02A9C5  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A9C9  16                    PUSH   ss                           ; UNKNOWN
02A9CA  50                    PUSH   ax                           ; UNKNOWN
02A9CB  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
02A9D0  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02A9D3  A0 65 09              MOV    al, byte ptr [0x965]         ; UNKNOWN
02A9D6  2A E4                 SUB    ah, ah                       ; UNKNOWN
02A9D8  50                    PUSH   ax                           ; UNKNOWN
02A9D9  FF B6 A0 FE           PUSH   word ptr [bp - 0x160]        ; UNKNOWN
02A9DD  FF B6 A8 FE           PUSH   word ptr [bp - 0x158]        ; UNKNOWN
02A9E1  FF B6 A2 FE           PUSH   word ptr [bp - 0x15e]        ; UNKNOWN
02A9E5  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02A9E9  16                    PUSH   ss                           ; UNKNOWN
02A9EA  50                    PUSH   ax                           ; UNKNOWN
02A9EB  9A A0 03 13 24        LCALL  0x2413, 0x3a0                ; UNKNOWN
02A9F0  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
02A9F3  C4 1E 20 0C           LES    bx, ptr [0xc20]              ; UNKNOWN
02A9F7  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
02A9FA  2A E4                 SUB    ah, ah                       ; UNKNOWN
02A9FC  40                    INC    ax                           ; UNKNOWN
02A9FD  40                    INC    ax                           ; UNKNOWN
02A9FE  01 86 A8 FE           ADD    word ptr [bp - 0x158], ax    ; UNKNOWN
02AA02  C6 86 B0 FE 00        MOV    byte ptr [bp - 0x150], 0     ; UNKNOWN
02AA07  68 68 1A              PUSH   0x1a68                       ; UNKNOWN
02AA0A  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AA0E  50                    PUSH   ax                           ; UNKNOWN
02AA0F  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
02AA14  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02AA17  FF 36 88 34           PUSH   word ptr [0x3488]            ; UNKNOWN
02AA1B  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AA1F  50                    PUSH   ax                           ; UNKNOWN
02AA20  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02AA25  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02AA28  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AA2C  50                    PUSH   ax                           ; UNKNOWN
02AA2D  9A 4D 00 13 24        LCALL  0x2413, 0x4d                 ; UNKNOWN
02AA32  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02AA35  FF B2 26 FF           PUSH   word ptr [bp + si - 0xda]    ; UNKNOWN
02AA39  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AA3D  16                    PUSH   ss                           ; UNKNOWN
02AA3E  50                    PUSH   ax                           ; UNKNOWN
02AA3F  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
02AA44  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02AA47  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AA4B  50                    PUSH   ax                           ; UNKNOWN
02AA4C  9A 6D 00 13 24        LCALL  0x2413, 0x6d                 ; UNKNOWN
02AA51  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02AA54  68 6D 1A              PUSH   0x1a6d                       ; UNKNOWN
02AA57  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AA5B  50                    PUSH   ax                           ; UNKNOWN
02AA5C  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
02AA61  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02AA64  A0 65 09              MOV    al, byte ptr [0x965]         ; UNKNOWN
02AA67  2A E4                 SUB    ah, ah                       ; UNKNOWN
02AA69  50                    PUSH   ax                           ; UNKNOWN
02AA6A  FF B6 A0 FE           PUSH   word ptr [bp - 0x160]        ; UNKNOWN
02AA6E  FF B6 A8 FE           PUSH   word ptr [bp - 0x158]        ; UNKNOWN
02AA72  68 40 01              PUSH   0x140                        ; UNKNOWN
02AA75  6A 00                 PUSH   0                            ; UNKNOWN
02AA77  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AA7B  16                    PUSH   ss                           ; UNKNOWN
02AA7C  50                    PUSH   ax                           ; UNKNOWN
02AA7D  9A 36 04 13 24        LCALL  0x2413, 0x436                ; UNKNOWN
02AA82  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
02AA85  C4 1E 20 0C           LES    bx, ptr [0xc20]              ; UNKNOWN
02AA89  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
02AA8C  2A E4                 SUB    ah, ah                       ; UNKNOWN
02AA8E  40                    INC    ax                           ; UNKNOWN
02AA8F  01 86 A8 FE           ADD    word ptr [bp - 0x158], ax    ; UNKNOWN
02AA93  FF 86 A6 FE           INC    word ptr [bp - 0x15a]        ; UNKNOWN
02AA97  83 BE A6 FE 05        CMP    word ptr [bp - 0x15a], 5     ; UNKNOWN
02AA9C  7C 03                 JL     0x2aaa1                      ; UNKNOWN
02AA9E  E9 9A 01              JMP    0x2ac3b                      ; UNKNOWN
02AAA1  8B 86 A6 FE           MOV    ax, word ptr [bp - 0x15a]    ; UNKNOWN
02AAA5  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02AAA8  83 F8 04              CMP    ax, 4                        ; UNKNOWN
02AAAB  75 0C                 JNE    0x2aab9                      ; UNKNOWN
02AAAD  83 BE AC FE 05        CMP    word ptr [bp - 0x154], 5     ; UNKNOWN
02AAB2  75 05                 JNE    0x2aab9                      ; UNKNOWN
02AAB4  C7 46 FC 05 00        MOV    word ptr [bp - 4], 5         ; UNKNOWN
02AAB9  6B F0 2A              IMUL   si, ax, 0x2a                 ; UNKNOWN
02AABC  83 BA 18 FF 00        CMP    word ptr [bp + si - 0xe8], 0 ; UNKNOWN
02AAC1  7C D0                 JL     0x2aa93                      ; UNKNOWN
02AAC3  A0 62 09              MOV    al, byte ptr [0x962]         ; UNKNOWN
02AAC6  2A E4                 SUB    ah, ah                       ; UNKNOWN
02AAC8  89 86 A0 FE           MOV    word ptr [bp - 0x160], ax    ; UNKNOWN
02AACC  8B 86 AC FE           MOV    ax, word ptr [bp - 0x154]    ; UNKNOWN
02AAD0  39 46 FC              CMP    word ptr [bp - 4], ax        ; UNKNOWN
02AAD3  75 09                 JNE    0x2aade                      ; UNKNOWN
02AAD5  A0 63 09              MOV    al, byte ptr [0x963]         ; UNKNOWN
02AAD8  2A E4                 SUB    ah, ah                       ; UNKNOWN
02AADA  89 86 A0 FE           MOV    word ptr [bp - 0x160], ax    ; UNKNOWN
02AADE  83 86 A8 FE 04        ADD    word ptr [bp - 0x158], 4     ; UNKNOWN
02AAE3  C6 86 B0 FE 00        MOV    byte ptr [bp - 0x150], 0     ; UNKNOWN
02AAE8  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02AAEB  40                    INC    ax                           ; UNKNOWN
02AAEC  50                    PUSH   ax                           ; UNKNOWN
02AAED  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AAF1  16                    PUSH   ss                           ; UNKNOWN
02AAF2  50                    PUSH   ax                           ; UNKNOWN
02AAF3  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
02AAF8  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02AAFB  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AAFF  50                    PUSH   ax                           ; UNKNOWN
02AB00  9A 5D 00 13 24        LCALL  0x2413, 0x5d                 ; UNKNOWN
02AB05  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02AB08  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; UNKNOWN
02AB0D  8B 9A 22 FF           MOV    bx, word ptr [bp + si - 0xde] ; UNKNOWN
02AB11  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02AB13  FF B7 E9 37           PUSH   word ptr [bx + 0x37e9]       ; UNKNOWN
02AB17  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AB1B  50                    PUSH   ax                           ; UNKNOWN
02AB1C  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02AB21  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02AB24  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AB28  50                    PUSH   ax                           ; UNKNOWN
02AB29  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
02AB2E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02AB31  8D 82 00 FF           LEA    ax, [bp + si - 0x100]        ; UNKNOWN
02AB35  50                    PUSH   ax                           ; UNKNOWN
02AB36  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AB3A  50                    PUSH   ax                           ; UNKNOWN
02AB3B  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
02AB40  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02AB43  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AB47  50                    PUSH   ax                           ; UNKNOWN
02AB48  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
02AB4D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02AB50  FF 36 20 33           PUSH   word ptr [0x3320]            ; UNKNOWN
02AB54  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AB58  50                    PUSH   ax                           ; UNKNOWN
02AB59  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02AB5E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02AB61  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AB65  50                    PUSH   ax                           ; UNKNOWN
02AB66  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
02AB6B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02AB6E  83 BA 1A FF 00        CMP    word ptr [bp + si - 0xe6], 0 ; UNKNOWN
02AB73  74 1E                 JE     0x2ab93                      ; UNKNOWN
02AB75  FF 36 78 34           PUSH   word ptr [0x3478]            ; UNKNOWN
02AB79  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AB7D  50                    PUSH   ax                           ; UNKNOWN
02AB7E  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02AB83  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02AB86  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AB8A  50                    PUSH   ax                           ; UNKNOWN
02AB8B  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
02AB90  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02AB93  6B B6 A6 FE 2A        IMUL   si, word ptr [bp - 0x15a], 0x2a ; UNKNOWN
02AB98  FF B2 18 FF           PUSH   word ptr [bp + si - 0xe8]    ; UNKNOWN
02AB9C  9A 44 02 49 22        LCALL  0x2249, 0x244                ; UNKNOWN
02ABA1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02ABA4  50                    PUSH   ax                           ; UNKNOWN
02ABA5  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02ABA9  50                    PUSH   ax                           ; UNKNOWN
02ABAA  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02ABAF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02ABB2  A0 65 09              MOV    al, byte ptr [0x965]         ; UNKNOWN
02ABB5  2A E4                 SUB    ah, ah                       ; UNKNOWN
02ABB7  50                    PUSH   ax                           ; UNKNOWN
02ABB8  FF B6 A0 FE           PUSH   word ptr [bp - 0x160]        ; UNKNOWN
02ABBC  FF B6 A8 FE           PUSH   word ptr [bp - 0x158]        ; UNKNOWN
02ABC0  FF B6 AE FE           PUSH   word ptr [bp - 0x152]        ; UNKNOWN
02ABC4  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02ABC8  16                    PUSH   ss                           ; UNKNOWN
02ABC9  50                    PUSH   ax                           ; UNKNOWN
02ABCA  9A A0 03 13 24        LCALL  0x2413, 0x3a0                ; UNKNOWN
02ABCF  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
02ABD2  C4 1E 20 0C           LES    bx, ptr [0xc20]              ; UNKNOWN
02ABD6  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
02ABD9  2A E4                 SUB    ah, ah                       ; UNKNOWN
02ABDB  40                    INC    ax                           ; UNKNOWN
02ABDC  40                    INC    ax                           ; UNKNOWN
02ABDD  01 86 A8 FE           ADD    word ptr [bp - 0x158], ax    ; UNKNOWN
02ABE1  8B 86 AE FE           MOV    ax, word ptr [bp - 0x152]    ; UNKNOWN
02ABE5  83 C0 0F              ADD    ax, 0xf                      ; UNKNOWN
02ABE8  89 86 A2 FE           MOV    word ptr [bp - 0x15e], ax    ; UNKNOWN
02ABEC  C6 86 B0 FE 00        MOV    byte ptr [bp - 0x150], 0     ; UNKNOWN
02ABF1  83 BA 1C FF 00        CMP    word ptr [bp + si - 0xe4], 0 ; UNKNOWN
02ABF6  75 03                 JNE    0x2abfb                      ; UNKNOWN
02ABF8  E9 CE FC              JMP    0x2a8c9                      ; UNKNOWN
02ABFB  FF 36 80 34           PUSH   word ptr [0x3480]            ; UNKNOWN
02ABFF  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AC03  50                    PUSH   ax                           ; UNKNOWN
02AC04  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02AC09  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02AC0C  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AC10  50                    PUSH   ax                           ; UNKNOWN
02AC11  9A 3D 00 13 24        LCALL  0x2413, 0x3d                 ; UNKNOWN
02AC16  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02AC19  FF B2 18 FF           PUSH   word ptr [bp + si - 0xe8]    ; UNKNOWN
02AC1D  68 56 1A              PUSH   0x1a56                       ; UNKNOWN
02AC20  68 62 1A              PUSH   0x1a62                       ; UNKNOWN
02AC23  9A 0E 02 09 45        LCALL  0x4509, 0x20e                ; UNKNOWN
02AC28  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02AC2B  68 42 C6              PUSH   0xc642                       ; UNKNOWN
02AC2E  8D 86 B0 FE           LEA    ax, [bp - 0x150]             ; UNKNOWN
02AC32  50                    PUSH   ax                           ; UNKNOWN
02AC33  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
02AC38  E9 F8 FC              JMP    0x2a933                      ; UNKNOWN
02AC3B  6A 00                 PUSH   0                            ; UNKNOWN
02AC3D  68 40 01              PUSH   0x140                        ; UNKNOWN
02AC40  68 C8 00              PUSH   0xc8                         ; UNKNOWN
02AC43  2B C0                 SUB    ax, ax                       ; UNKNOWN
02AC45  99                    CDQ                                 ; UNKNOWN
02AC46  2B DB                 SUB    bx, bx                       ; UNKNOWN
02AC48  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
02AC4D  9A E4 00 EF 21        LCALL  0x21ef, 0xe4                 ; UNKNOWN
02AC52  9A 6B 00 EF 21        LCALL  0x21ef, 0x6b                 ; UNKNOWN
02AC57  68 72 1A              PUSH   0x1a72                       ; UNKNOWN
02AC5A  68 75 1A              PUSH   0x1a75                       ; UNKNOWN
02AC5D  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
02AC62  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02AC65  89 86 A4 FE           MOV    word ptr [bp - 0x15c], ax    ; UNKNOWN
02AC69  0B C0                 OR     ax, ax                       ; UNKNOWN
02AC6B  74 13                 JE     0x2ac80                      ; UNKNOWN
02AC6D  50                    PUSH   ax                           ; UNKNOWN
02AC6E  6A 01                 PUSH   1                            ; UNKNOWN
02AC70  68 D2 00              PUSH   0xd2                         ; UNKNOWN
02AC73  8D 86 00 FF           LEA    ax, [bp - 0x100]             ; UNKNOWN
02AC77  50                    PUSH   ax                           ; UNKNOWN
02AC78  9A D4 04 65 5F        LCALL  0x5f65, 0x4d4                ; UNKNOWN
02AC7D  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02AC80  83 BE A4 FE 00        CMP    word ptr [bp - 0x15c], 0     ; UNKNOWN
02AC85  74 0C                 JE     0x2ac93                      ; UNKNOWN
02AC87  FF B6 A4 FE           PUSH   word ptr [bp - 0x15c]        ; UNKNOWN
02AC8B  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
02AC90  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02AC93  5E                    POP    si                           ; UNKNOWN
02AC94  5F                    POP    di                           ; UNKNOWN
02AC95  C9                    LEAVE                               ; UNKNOWN
02AC96  CB                    RETF                                ; UNKNOWN
