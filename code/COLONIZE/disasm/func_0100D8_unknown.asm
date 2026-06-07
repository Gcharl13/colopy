; ============================================================================
; func_0100D8_unknown
; Region   : load_image
; Bytes    : file 0x0100D8..0x01026E  (406 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0100D8  C8 26 00 00           ENTER  0x26, 0                      ; UNKNOWN
0100DC  57                    PUSH   di                           ; UNKNOWN
0100DD  56                    PUSH   si                           ; UNKNOWN
0100DE  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0      ; UNKNOWN
0100E3  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0100E7  89 5E DA              MOV    word ptr [bp - 0x26], bx     ; UNKNOWN
0100EA  80 BF 97 88 16        CMP    byte ptr [bx - 0x7769], 0x16 ; UNKNOWN
0100EF  75 05                 JNE    0x100f6                      ; UNKNOWN
0100F1  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0100F4  EB 02                 JMP    0x100f8                      ; UNKNOWN
0100F6  2B C0                 SUB    ax, ax                       ; UNKNOWN
0100F8  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
0100FB  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0100FE  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
010102  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
010107  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01010A  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
01010D  3D 4B 00              CMP    ax, 0x4b                     ; UNKNOWN
010110  7C 03                 JL     0x10115                      ; UNKNOWN
010112  E9 A9 03              JMP    0x104be                      ; UNKNOWN
010115  6B 46 E8 28           IMUL   ax, word ptr [bp - 0x18], 0x28 ; UNKNOWN
010119  05 64 00              ADD    ax, 0x64                     ; UNKNOWN
01011C  50                    PUSH   ax                           ; UNKNOWN
01011D  6A 00                 PUSH   0                            ; UNKNOWN
01011F  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
010124  83 C4 04              ADD    sp, 4                        ; UNKNOWN
010127  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
01012A  83 7E E6 19           CMP    word ptr [bp - 0x1a], 0x19   ; UNKNOWN
01012E  7C 0E                 JL     0x1013e                      ; UNKNOWN
010130  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
010133  C1 F8 02              SAR    ax, 2                        ; UNKNOWN
010136  3B 46 E4              CMP    ax, word ptr [bp - 0x1c]     ; UNKNOWN
010139  7C 03                 JL     0x1013e                      ; UNKNOWN
01013B  E9 80 03              JMP    0x104be                      ; UNKNOWN
01013E  83 3E 3A 82 02        CMP    word ptr [0x823a], 2         ; UNKNOWN
010143  75 21                 JNE    0x10166                      ; UNKNOWN
010145  8A 4E E8              MOV    cl, byte ptr [bp - 0x18]     ; UNKNOWN
010148  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
01014B  2A E4                 SUB    ah, ah                       ; UNKNOWN
01014D  2D 08 00              SUB    ax, 8                        ; UNKNOWN
010150  F7 D8                 NEG    ax                           ; UNKNOWN
010152  D3 E0                 SHL    ax, cl                       ; UNKNOWN
010154  50                    PUSH   ax                           ; UNKNOWN
010155  6A 00                 PUSH   0                            ; UNKNOWN
010157  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
01015C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01015F  0B C0                 OR     ax, ax                       ; UNKNOWN
010161  75 03                 JNE    0x10166                      ; UNKNOWN
010163  E9 58 03              JMP    0x104be                      ; UNKNOWN
010166  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
01016A  7C 03                 JL     0x1016f                      ; UNKNOWN
01016C  E9 25 01              JMP    0x10294                      ; UNKNOWN
01016F  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34  ; UNKNOWN
010173  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
010178  74 03                 JE     0x1017d                      ; UNKNOWN
01017A  E9 17 01              JMP    0x10294                      ; UNKNOWN
01017D  6A 01                 PUSH   1                            ; UNKNOWN
01017F  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
010182  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
010185  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
010188  0E                    PUSH   cs                           ; UNKNOWN
010189  E8 8A FB              CALL   0xfd16                       ; UNKNOWN
01018C  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01018F  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
010192  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
010195  6A FF                 PUSH   -1                           ; UNKNOWN
010197  FF 36 36 82           PUSH   word ptr [0x8236]            ; UNKNOWN
01019B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01019E  9A 78 32 AC 06        LCALL  0x6ac, 0x3278                ; UNKNOWN
0101A3  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0101A6  C7 46 EA 00 00        MOV    word ptr [bp - 0x16], 0      ; UNKNOWN
0101AB  8A 46 EA              MOV    al, byte ptr [bp - 0x16]     ; UNKNOWN
0101AE  8B 76 EA              MOV    si, word ptr [bp - 0x16]     ; UNKNOWN
0101B1  88 42 EC              MOV    byte ptr [bp + si - 0x14], al ; UNKNOWN
0101B4  FF 46 EA              INC    word ptr [bp - 0x16]         ; UNKNOWN
0101B7  83 7E EA 10           CMP    word ptr [bp - 0x16], 0x10   ; UNKNOWN
0101BB  7C EE                 JL     0x101ab                      ; UNKNOWN
0101BD  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
0101C1  80 7F 08 00           CMP    byte ptr [bx + 8], 0         ; UNKNOWN
0101C5  7C 0E                 JL     0x101d5                      ; UNKNOWN
0101C7  8A 47 08              MOV    al, byte ptr [bx + 8]        ; UNKNOWN
0101CA  98                    CWDE                                ; UNKNOWN
0101CB  8B D8                 MOV    bx, ax                       ; UNKNOWN
0101CD  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0101CF  C7 87 3C 82 00 00     MOV    word ptr [bx - 0x7dc4], 0    ; UNKNOWN
0101D5  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
0101D9  80 7F 09 00           CMP    byte ptr [bx + 9], 0         ; UNKNOWN
0101DD  7C 0E                 JL     0x101ed                      ; UNKNOWN
0101DF  8A 47 09              MOV    al, byte ptr [bx + 9]        ; UNKNOWN
0101E2  98                    CWDE                                ; UNKNOWN
0101E3  8B D8                 MOV    bx, ax                       ; UNKNOWN
0101E5  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0101E7  C7 87 3C 82 00 00     MOV    word ptr [bx - 0x7dc4], 0    ; UNKNOWN
0101ED  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
0101F0  16                    PUSH   ss                           ; UNKNOWN
0101F1  50                    PUSH   ax                           ; UNKNOWN
0101F2  1E                    PUSH   ds                           ; UNKNOWN
0101F3  68 3C 82              PUSH   0x823c                       ; UNKNOWN
0101F6  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
0101F9  9A 00 00 DB 5C        LCALL  0x5cdb, 0                    ; UNKNOWN
0101FE  8B 5E E2              MOV    bx, word ptr [bp - 0x1e]     ; UNKNOWN
010201  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
010204  FF B7 35 38           PUSH   word ptr [bx + 0x3835]       ; UNKNOWN
010208  6A 00                 PUSH   0                            ; UNKNOWN
01020A  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
01020F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
010212  8A 5E FB              MOV    bl, byte ptr [bp - 5]        ; UNKNOWN
010215  2A FF                 SUB    bh, bh                       ; UNKNOWN
010217  D1 E3                 SHL    bx, 1                        ; UNKNOWN
010219  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
01021D  6A 01                 PUSH   1                            ; UNKNOWN
01021F  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
010224  83 C4 04              ADD    sp, 4                        ; UNKNOWN
010227  8A 5E FA              MOV    bl, byte ptr [bp - 6]        ; UNKNOWN
01022A  2A FF                 SUB    bh, bh                       ; UNKNOWN
01022C  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01022E  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
010232  6A 02                 PUSH   2                            ; UNKNOWN
010234  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
010239  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01023C  8A 5E F9              MOV    bl, byte ptr [bp - 7]        ; UNKNOWN
01023F  2A FF                 SUB    bh, bh                       ; UNKNOWN
010241  D1 E3                 SHL    bx, 1                        ; UNKNOWN
010243  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
010247  6A 03                 PUSH   3                            ; UNKNOWN
010249  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
01024E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
010251  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
010255  68 C5 07              PUSH   0x7c5                        ; UNKNOWN
010258  9A 00 37 97 1B        LCALL  0x1b97, 0x3700               ; UNKNOWN
01025D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
010260  8A 4E 08              MOV    cl, byte ptr [bp + 8]        ; UNKNOWN
010263  B8 01 00              MOV    ax, 1                        ; UNKNOWN
010266  D3 E0                 SHL    ax, cl                       ; UNKNOWN
010268  8B 1E 36 82           MOV    bx, word ptr [0x8236]        ; UNKNOWN
01026C  8B CB                 MOV    cx, bx                       ; UNKNOWN
