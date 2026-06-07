; ============================================================================
; func_02B04A_unknown
; Region   : load_image
; Bytes    : file 0x02B04A..0x02B1F5  (427 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B04A  C8 50 03 00           ENTER  0x350, 0                     ; UNKNOWN
02B04E  57                    PUSH   di                           ; UNKNOWN
02B04F  56                    PUSH   si                           ; UNKNOWN
02B050  68 FC 1C              PUSH   0x1cfc                       ; UNKNOWN
02B053  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02B056  50                    PUSH   ax                           ; UNKNOWN
02B057  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
02B05C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B05F  83 7E 06 0A           CMP    word ptr [bp + 6], 0xa       ; UNKNOWN
02B063  7D 0F                 JGE    0x2b074                      ; UNKNOWN
02B065  68 03 1D              PUSH   0x1d03                       ; UNKNOWN
02B068  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02B06B  50                    PUSH   ax                           ; UNKNOWN
02B06C  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
02B071  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B074  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B077  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02B07A  16                    PUSH   ss                           ; UNKNOWN
02B07B  50                    PUSH   ax                           ; UNKNOWN
02B07C  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
02B081  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02B084  83 7E 06 01           CMP    word ptr [bp + 6], 1         ; UNKNOWN
02B088  75 04                 JNE    0x2b08e                      ; UNKNOWN
02B08A  0E                    PUSH   cs                           ; UNKNOWN
02B08B  E8 7F FE              CALL   0x2af0d                      ; UNKNOWN
02B08E  8D 86 B0 FC           LEA    ax, [bp - 0x350]             ; UNKNOWN
02B092  16                    PUSH   ss                           ; UNKNOWN
02B093  50                    PUSH   ax                           ; UNKNOWN
02B094  6A 00                 PUSH   0                            ; UNKNOWN
02B096  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02B09A  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02B09E  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02B0A2  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02B0A6  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02B0A9  50                    PUSH   ax                           ; UNKNOWN
02B0AA  9A 0A 00 69 1A        LCALL  0x1a69, 0xa                  ; UNKNOWN
02B0AF  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
02B0B2  0B C0                 OR     ax, ax                       ; UNKNOWN
02B0B4  74 03                 JE     0x2b0b9                      ; UNKNOWN
02B0B6  E9 2C 01              JMP    0x2b1e5                      ; UNKNOWN
02B0B9  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02B0BD  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02B0C1  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02B0C5  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02B0C9  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
02B0CD  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
02B0D1  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
02B0D5  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
02B0D9  68 C8 00              PUSH   0xc8                         ; UNKNOWN
02B0DC  99                    CDQ                                 ; UNKNOWN
02B0DD  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
02B0E0  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
02B0E5  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02B0E8  48                    DEC    ax                           ; UNKNOWN
02B0E9  48                    DEC    ax                           ; UNKNOWN
02B0EA  74 08                 JE     0x2b0f4                      ; UNKNOWN
02B0EC  48                    DEC    ax                           ; UNKNOWN
02B0ED  74 27                 JE     0x2b116                      ; UNKNOWN
02B0EF  48                    DEC    ax                           ; UNKNOWN
02B0F0  74 3A                 JE     0x2b12c                      ; UNKNOWN
02B0F2  EB 7D                 JMP    0x2b171                      ; UNKNOWN
02B0F4  8A 1E 1E 3E           MOV    bl, byte ptr [0x3e1e]        ; UNKNOWN
02B0F8  2A FF                 SUB    bh, bh                       ; UNKNOWN
02B0FA  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02B0FC  FF B7 E9 37           PUSH   word ptr [bx + 0x37e9]       ; UNKNOWN
02B100  6A 00                 PUSH   0                            ; UNKNOWN
02B102  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
02B107  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B10A  6B 06 10 3E 34        IMUL   ax, word ptr [0x3e10], 0x34  ; UNKNOWN
02B10F  05 86 C0              ADD    ax, 0xc086                   ; UNKNOWN
02B112  1E                    PUSH   ds                           ; UNKNOWN
02B113  50                    PUSH   ax                           ; UNKNOWN
02B114  EB 51                 JMP    0x2b167                      ; UNKNOWN
02B116  8B 1E 10 3E           MOV    bx, word ptr [0x3e10]        ; UNKNOWN
02B11A  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02B11C  FF B7 E1 37           PUSH   word ptr [bx + 0x37e1]       ; UNKNOWN
02B120  6A 00                 PUSH   0                            ; UNKNOWN
02B122  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
02B127  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B12A  EB 45                 JMP    0x2b171                      ; UNKNOWN
02B12C  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
02B130  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02B133  50                    PUSH   ax                           ; UNKNOWN
02B134  6A 00                 PUSH   0                            ; UNKNOWN
02B136  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
02B13A  9A 41 01 49 22        LCALL  0x2249, 0x141                ; UNKNOWN
02B13F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02B142  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02B145  16                    PUSH   ss                           ; UNKNOWN
02B146  50                    PUSH   ax                           ; UNKNOWN
02B147  6A 00                 PUSH   0                            ; UNKNOWN
02B149  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
02B14E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02B151  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
02B155  68 05 1D              PUSH   0x1d05                       ; UNKNOWN
02B158  68 86 09              PUSH   0x986                        ; UNKNOWN
02B15B  9A 0E 02 09 45        LCALL  0x4509, 0x20e                ; UNKNOWN
02B160  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02B163  1E                    PUSH   ds                           ; UNKNOWN
02B164  68 42 C6              PUSH   0xc642                       ; UNKNOWN
02B167  6A 01                 PUSH   1                            ; UNKNOWN
02B169  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
02B16E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02B171  9A 93 37 97 1B        LCALL  0x1b97, 0x3793               ; UNKNOWN
02B176  80 0E FE 09 20        OR     byte ptr [0x9fe], 0x20       ; UNKNOWN
02B17B  C7 06 12 0A 01 00     MOV    word ptr [0xa12], 1          ; UNKNOWN
02B181  C7 06 0C 0A 00 00     MOV    word ptr [0xa0c], 0          ; UNKNOWN
02B187  68 0E 1D              PUSH   0x1d0e                       ; UNKNOWN
02B18A  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02B18D  50                    PUSH   ax                           ; UNKNOWN
02B18E  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
02B193  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B196  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B199  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02B19C  16                    PUSH   ss                           ; UNKNOWN
02B19D  50                    PUSH   ax                           ; UNKNOWN
02B19E  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
02B1A3  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02B1A6  8B 36 F2 09           MOV    si, word ptr [0x9f2]         ; UNKNOWN
02B1AA  8B 3E F8 09           MOV    di, word ptr [0x9f8]         ; UNKNOWN
02B1AE  C7 06 F2 09 0E 00     MOV    word ptr [0x9f2], 0xe        ; UNKNOWN
02B1B4  C7 06 F8 09 36 00     MOV    word ptr [0x9f8], 0x36       ; UNKNOWN
02B1BA  8D 5E B0              LEA    bx, [bp - 0x50]              ; UNKNOWN
02B1BD  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
02B1C2  89 36 F2 09           MOV    word ptr [0x9f2], si         ; UNKNOWN
02B1C6  89 3E F8 09           MOV    word ptr [0x9f8], di         ; UNKNOWN
02B1CA  83 7E 06 01           CMP    word ptr [bp + 6], 1         ; UNKNOWN
02B1CE  75 0B                 JNE    0x2b1db                      ; UNKNOWN
02B1D0  8D 86 B0 FC           LEA    ax, [bp - 0x350]             ; UNKNOWN
02B1D4  16                    PUSH   ss                           ; UNKNOWN
02B1D5  50                    PUSH   ax                           ; UNKNOWN
02B1D6  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
02B1DB  6A 08                 PUSH   8                            ; UNKNOWN
02B1DD  9A 02 00 F1 44        LCALL  0x44f1, 2                    ; UNKNOWN
02B1E2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02B1E5  C7 06 12 0A 00 00     MOV    word ptr [0xa12], 0          ; UNKNOWN
02B1EB  C7 06 0C 0A 01 00     MOV    word ptr [0xa0c], 1          ; UNKNOWN
02B1F1  5E                    POP    si                           ; UNKNOWN
02B1F2  5F                    POP    di                           ; UNKNOWN
02B1F3  C9                    LEAVE                               ; UNKNOWN
02B1F4  CB                    RETF                                ; UNKNOWN
