; ============================================================================
; func_00A17A_unknown
; Region   : load_image
; Bytes    : file 0x00A17A..0x00A2E8  (366 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A17A  C8 6A 00 00           ENTER  0x6a, 0                      ; UNKNOWN
00A17E  C7 46 AA 01 00        MOV    word ptr [bp - 0x56], 1      ; UNKNOWN
00A183  C7 46 A4 00 00        MOV    word ptr [bp - 0x5c], 0      ; UNKNOWN
00A188  83 3E 0A 0B 00        CMP    word ptr [0xb0a], 0          ; UNKNOWN
00A18D  74 05                 JE     0xa194                       ; UNKNOWN
00A18F  C7 46 AA 05 00        MOV    word ptr [bp - 0x56], 5      ; UNKNOWN
00A194  68 52 03              PUSH   0x352                        ; UNKNOWN
00A197  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00A19A  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
00A19F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A1A2  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
00A1A5  0B C0                 OR     ax, ax                       ; UNKNOWN
00A1A7  75 03                 JNE    0xa1ac                       ; UNKNOWN
00A1A9  E9 6E 07              JMP    0xa91a                       ; UNKNOWN
00A1AC  8D 5E B0              LEA    bx, [bp - 0x50]              ; UNKNOWN
00A1AF  8B 46 9C              MOV    ax, word ptr [bp - 0x64]     ; UNKNOWN
00A1B2  9A 00 00 34 5B        LCALL  0x5b34, 0                    ; UNKNOWN
00A1B7  0B C0                 OR     ax, ax                       ; UNKNOWN
00A1B9  75 03                 JNE    0xa1be                       ; UNKNOWN
00A1BB  E9 5C 07              JMP    0xa91a                       ; UNKNOWN
00A1BE  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00A1C1  50                    PUSH   ax                           ; UNKNOWN
00A1C2  68 55 03              PUSH   0x355                        ; UNKNOWN
00A1C5  9A A6 07 65 5F        LCALL  0x5f65, 0x7a6                ; UNKNOWN
00A1CA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00A1CD  0B C0                 OR     ax, ax                       ; UNKNOWN
00A1CF  74 09                 JE     0xa1da                       ; UNKNOWN
00A1D1  C7 46 AA 02 00        MOV    word ptr [bp - 0x56], 2      ; UNKNOWN
00A1D6  E9 41 07              JMP    0xa91a                       ; UNKNOWN
00A1D9  90                    NOP                                 ; UNKNOWN
00A1DA  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
00A1DD  6A 01                 PUSH   1                            ; UNKNOWN
00A1DF  6A 02                 PUSH   2                            ; UNKNOWN
00A1E1  8D 46 A2              LEA    ax, [bp - 0x5e]              ; UNKNOWN
00A1E4  50                    PUSH   ax                           ; UNKNOWN
00A1E5  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00A1EA  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00A1ED  0B C0                 OR     ax, ax                       ; UNKNOWN
00A1EF  75 03                 JNE    0xa1f4                       ; UNKNOWN
00A1F1  E9 26 07              JMP    0xa91a                       ; UNKNOWN
00A1F4  8B 46 A2              MOV    ax, word ptr [bp - 0x5e]     ; UNKNOWN
00A1F7  39 06 30 0A           CMP    word ptr [0xa30], ax         ; UNKNOWN
00A1FB  7C D4                 JL     0xa1d1                       ; UNKNOWN
00A1FD  7E 09                 JLE    0xa208                       ; UNKNOWN
00A1FF  C7 46 AA 03 00        MOV    word ptr [bp - 0x56], 3      ; UNKNOWN
00A204  E9 13 07              JMP    0xa91a                       ; UNKNOWN
00A207  90                    NOP                                 ; UNKNOWN
00A208  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
00A20B  6A 01                 PUSH   1                            ; UNKNOWN
00A20D  6A 04                 PUSH   4                            ; UNKNOWN
00A20F  8D 46 A6              LEA    ax, [bp - 0x5a]              ; UNKNOWN
00A212  50                    PUSH   ax                           ; UNKNOWN
00A213  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00A218  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00A21B  0B C0                 OR     ax, ax                       ; UNKNOWN
00A21D  75 03                 JNE    0xa222                       ; UNKNOWN
00A21F  E9 F8 06              JMP    0xa91a                       ; UNKNOWN
00A222  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
00A225  F7 6E A6              IMUL   word ptr [bp - 0x5a]         ; UNKNOWN
00A228  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
00A22B  89 56 AE              MOV    word ptr [bp - 0x52], dx     ; UNKNOWN
00A22E  A1 32 0B              MOV    ax, word ptr [0xb32]         ; UNKNOWN
00A231  0B 06 30 0B           OR     ax, word ptr [0xb30]         ; UNKNOWN
00A235  74 17                 JE     0xa24e                       ; UNKNOWN
00A237  8B 46 AC              MOV    ax, word ptr [bp - 0x54]     ; UNKNOWN
00A23A  39 06 30 0B           CMP    word ptr [0xb30], ax         ; UNKNOWN
00A23E  75 06                 JNE    0xa246                       ; UNKNOWN
00A240  39 16 32 0B           CMP    word ptr [0xb32], dx         ; UNKNOWN
00A244  74 31                 JE     0xa277                       ; UNKNOWN
00A246  C7 46 AA 04 00        MOV    word ptr [bp - 0x56], 4      ; UNKNOWN
00A24B  E9 CC 06              JMP    0xa91a                       ; UNKNOWN
00A24E  6A 04                 PUSH   4                            ; UNKNOWN
00A250  8D 46 A6              LEA    ax, [bp - 0x5a]              ; UNKNOWN
00A253  50                    PUSH   ax                           ; UNKNOWN
00A254  68 88 82              PUSH   0x8288                       ; UNKNOWN
00A257  9A BC 0D 65 5F        LCALL  0x5f65, 0xdbc                ; UNKNOWN
00A25C  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00A25F  2B C0                 SUB    ax, ax                       ; UNKNOWN
00A261  9A 59 00 E5 17        LCALL  0x17e5, 0x59                 ; UNKNOWN
00A266  0B C0                 OR     ax, ax                       ; UNKNOWN
00A268  74 08                 JE     0xa272                       ; UNKNOWN
00A26A  C7 46 AA 01 00        MOV    word ptr [bp - 0x56], 1      ; UNKNOWN
00A26F  E9 A8 06              JMP    0xa91a                       ; UNKNOWN
00A272  C7 46 A4 01 00        MOV    word ptr [bp - 0x5c], 1      ; UNKNOWN
00A277  6A 04                 PUSH   4                            ; UNKNOWN
00A279  8D 46 A6              LEA    ax, [bp - 0x5a]              ; UNKNOWN
00A27C  50                    PUSH   ax                           ; UNKNOWN
00A27D  68 88 82              PUSH   0x8288                       ; UNKNOWN
00A280  9A BC 0D 65 5F        LCALL  0x5f65, 0xdbc                ; UNKNOWN
00A285  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00A288  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
00A28B  6A 01                 PUSH   1                            ; UNKNOWN
00A28D  68 8E 00              PUSH   0x8e                         ; UNKNOWN
00A290  68 F8 3D              PUSH   0x3df8                       ; UNKNOWN
00A293  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00A298  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00A29B  0B C0                 OR     ax, ax                       ; UNKNOWN
00A29D  75 03                 JNE    0xa2a2                       ; UNKNOWN
00A29F  E9 78 06              JMP    0xa91a                       ; UNKNOWN
00A2A2  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
00A2A5  6A 01                 PUSH   1                            ; UNKNOWN
00A2A7  68 D0 00              PUSH   0xd0                         ; UNKNOWN
00A2AA  68 86 C0              PUSH   0xc086                       ; UNKNOWN
00A2AD  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00A2B2  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00A2B5  0B C0                 OR     ax, ax                       ; UNKNOWN
00A2B7  75 03                 JNE    0xa2bc                       ; UNKNOWN
00A2B9  E9 5E 06              JMP    0xa91a                       ; UNKNOWN
00A2BC  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
00A2BF  6A 01                 PUSH   1                            ; UNKNOWN
00A2C1  6A 18                 PUSH   0x18                         ; UNKNOWN
00A2C3  68 5A 85              PUSH   0x855a                       ; UNKNOWN
00A2C6  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
00A2CB  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00A2CE  0B C0                 OR     ax, ax                       ; UNKNOWN
00A2D0  75 03                 JNE    0xa2d5                       ; UNKNOWN
00A2D2  E9 45 06              JMP    0xa91a                       ; UNKNOWN
00A2D5  83 3E 16 3E 00        CMP    word ptr [0x3e16], 0         ; UNKNOWN
00A2DA  74 1E                 JE     0xa2fa                       ; UNKNOWN
00A2DC  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
00A2DF  6A 01                 PUSH   1                            ; UNKNOWN
00A2E1  69 06 16 3E CA 00     IMUL   ax, word ptr [0x3e16], 0xca  ; UNKNOWN
00A2E7  50                    PUSH   ax                           ; UNKNOWN
