; ============================================================================
; func_019C7C_unknown
; Region   : load_image
; Bytes    : file 0x019C7C..0x019E7F  (515 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

019C7C  C8 6A 00 00           ENTER  0x6a, 0                      ; UNKNOWN
019C80  57                    PUSH   di                           ; UNKNOWN
019C81  56                    PUSH   si                           ; UNKNOWN
019C82  C7 46 AC 01 00        MOV    word ptr [bp - 0x54], 1      ; UNKNOWN
019C87  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
019C8A  9A F7 0D 5F 24        LCALL  0x245f, 0xdf7                ; UNKNOWN
019C8F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
019C92  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
019C95  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
019C98  9A 30 0E 5F 24        LCALL  0x245f, 0xe30                ; UNKNOWN
019C9D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
019CA0  89 46 96              MOV    word ptr [bp - 0x6a], ax     ; UNKNOWN
019CA3  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
019CA6  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
019CA9  83 F8 17              CMP    ax, 0x17                     ; UNKNOWN
019CAC  75 05                 JNE    0x19cb3                      ; UNKNOWN
019CAE  C7 46 9A 15 00        MOV    word ptr [bp - 0x66], 0x15   ; UNKNOWN
019CB3  50                    PUSH   ax                           ; UNKNOWN
019CB4  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
019CB7  0E                    PUSH   cs                           ; UNKNOWN
019CB8  E8 D4 D1              CALL   0x16e8f                      ; UNKNOWN
019CBB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
019CBE  89 46 9E              MOV    word ptr [bp - 0x62], ax     ; UNKNOWN
019CC1  E9 56 02              JMP    0x19f1a                      ; UNKNOWN
019CC4  6A 05                 PUSH   5                            ; UNKNOWN
019CC6  68 DC 15              PUSH   0x15dc                       ; UNKNOWN
019CC9  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
019CCE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
019CD1  E9 80 02              JMP    0x19f54                      ; UNKNOWN
019CD4  6A 05                 PUSH   5                            ; UNKNOWN
019CD6  68 E9 15              PUSH   0x15e9                       ; UNKNOWN
019CD9  EB EE                 JMP    0x19cc9                      ; UNKNOWN
019CDB  8D 1E F7 15           LEA    bx, [0x15f7]                 ; UNKNOWN
019CDF  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
019CE4  E9 6D 02              JMP    0x19f54                      ; UNKNOWN
019CE7  8D 1E 01 16           LEA    bx, [0x1601]                 ; UNKNOWN
019CEB  EB F2                 JMP    0x19cdf                      ; UNKNOWN
019CED  A1 38 73              MOV    ax, word ptr [0x7338]        ; UNKNOWN
019CF0  40                    INC    ax                           ; UNKNOWN
019CF1  40                    INC    ax                           ; UNKNOWN
019CF2  1E                    PUSH   ds                           ; UNKNOWN
019CF3  50                    PUSH   ax                           ; UNKNOWN
019CF4  6A 00                 PUSH   0                            ; UNKNOWN
019CF6  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
019CFB  83 C4 06              ADD    sp, 6                        ; UNKNOWN
019CFE  6A 05                 PUSH   5                            ; UNKNOWN
019D00  68 0B 16              PUSH   0x160b                       ; UNKNOWN
019D03  EB C4                 JMP    0x19cc9                      ; UNKNOWN
019D05  A1 38 73              MOV    ax, word ptr [0x7338]        ; UNKNOWN
019D08  40                    INC    ax                           ; UNKNOWN
019D09  40                    INC    ax                           ; UNKNOWN
019D0A  1E                    PUSH   ds                           ; UNKNOWN
019D0B  50                    PUSH   ax                           ; UNKNOWN
019D0C  1E                    PUSH   ds                           ; UNKNOWN
019D0D  68 40 3F              PUSH   0x3f40                       ; UNKNOWN
019D10  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
019D15  83 C4 08              ADD    sp, 8                        ; UNKNOWN
019D18  68 10 16              PUSH   0x1610                       ; UNKNOWN
019D1B  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019D1E  50                    PUSH   ax                           ; UNKNOWN
019D1F  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
019D24  83 C4 04              ADD    sp, 4                        ; UNKNOWN
019D27  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
019D2B  8A 5F 1A              MOV    bl, byte ptr [bx + 0x1a]     ; UNKNOWN
019D2E  2A FF                 SUB    bh, bh                       ; UNKNOWN
019D30  80 BF AE 86 02        CMP    byte ptr [bx - 0x7952], 2    ; UNKNOWN
019D35  73 17                 JAE    0x19d4e                      ; UNKNOWN
019D37  81 3E 02 3E 27 06     CMP    word ptr [0x3e02], 0x627     ; UNKNOWN
019D3D  7E 0F                 JLE    0x19d4e                      ; UNKNOWN
019D3F  68 18 16              PUSH   0x1618                       ; UNKNOWN
019D42  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019D45  50                    PUSH   ax                           ; UNKNOWN
019D46  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
019D4B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
019D4E  6A 05                 PUSH   5                            ; UNKNOWN
019D50  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019D53  50                    PUSH   ax                           ; UNKNOWN
019D54  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
019D59  83 C4 04              ADD    sp, 4                        ; UNKNOWN
019D5C  48                    DEC    ax                           ; UNKNOWN
019D5D  74 03                 JE     0x19d62                      ; UNKNOWN
019D5F  E9 F2 01              JMP    0x19f54                      ; UNKNOWN
019D62  C7 46 9E 00 00        MOV    word ptr [bp - 0x62], 0      ; UNKNOWN
019D67  E9 EA 01              JMP    0x19f54                      ; UNKNOWN
019D6A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
019D6D  9A 30 0E 5F 24        LCALL  0x245f, 0xe30                ; UNKNOWN
019D72  83 C4 02              ADD    sp, 2                        ; UNKNOWN
019D75  89 46 96              MOV    word ptr [bp - 0x6a], ax     ; UNKNOWN
019D78  83 F8 1C              CMP    ax, 0x1c                     ; UNKNOWN
019D7B  75 06                 JNE    0x19d83                      ; UNKNOWN
019D7D  FF 36 00 33           PUSH   word ptr [0x3300]            ; UNKNOWN
019D81  EB 09                 JMP    0x19d8c                      ; UNKNOWN
019D83  8B D8                 MOV    bx, ax                       ; UNKNOWN
019D85  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
019D88  FF B7 33 38           PUSH   word ptr [bx + 0x3833]       ; UNKNOWN
019D8C  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
019D91  83 C4 02              ADD    sp, 2                        ; UNKNOWN
019D94  52                    PUSH   dx                           ; UNKNOWN
019D95  50                    PUSH   ax                           ; UNKNOWN
019D96  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019D99  16                    PUSH   ss                           ; UNKNOWN
019D9A  50                    PUSH   ax                           ; UNKNOWN
019D9B  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
019DA0  83 C4 08              ADD    sp, 8                        ; UNKNOWN
019DA3  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019DA6  50                    PUSH   ax                           ; UNKNOWN
019DA7  9A 9E 0D 65 5F        LCALL  0x5f65, 0xd9e                ; UNKNOWN
019DAC  83 C4 02              ADD    sp, 2                        ; UNKNOWN
019DAF  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019DB2  16                    PUSH   ss                           ; UNKNOWN
019DB3  50                    PUSH   ax                           ; UNKNOWN
019DB4  1E                    PUSH   ds                           ; UNKNOWN
019DB5  68 40 3F              PUSH   0x3f40                       ; UNKNOWN
019DB8  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
019DBD  83 C4 08              ADD    sp, 8                        ; UNKNOWN
019DC0  8B 5E 9A              MOV    bx, word ptr [bp - 0x66]     ; UNKNOWN
019DC3  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
019DC6  FF B7 33 38           PUSH   word ptr [bx + 0x3833]       ; UNKNOWN
019DCA  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
019DCF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
019DD2  52                    PUSH   dx                           ; UNKNOWN
019DD3  50                    PUSH   ax                           ; UNKNOWN
019DD4  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019DD7  16                    PUSH   ss                           ; UNKNOWN
019DD8  50                    PUSH   ax                           ; UNKNOWN
019DD9  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
019DDE  83 C4 08              ADD    sp, 8                        ; UNKNOWN
019DE1  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019DE4  50                    PUSH   ax                           ; UNKNOWN
019DE5  9A 9E 0D 65 5F        LCALL  0x5f65, 0xd9e                ; UNKNOWN
019DEA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
019DED  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019DF0  16                    PUSH   ss                           ; UNKNOWN
019DF1  50                    PUSH   ax                           ; UNKNOWN
019DF2  1E                    PUSH   ds                           ; UNKNOWN
019DF3  68 80 3F              PUSH   0x3f80                       ; UNKNOWN
019DF6  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
019DFB  83 C4 08              ADD    sp, 8                        ; UNKNOWN
019DFE  6A 05                 PUSH   5                            ; UNKNOWN
019E00  68 1A 16              PUSH   0x161a                       ; UNKNOWN
019E03  E9 4E FF              JMP    0x19d54                      ; UNKNOWN
019E06  8B 5E 9A              MOV    bx, word ptr [bp - 0x66]     ; UNKNOWN
019E09  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
019E0C  FF B7 33 38           PUSH   word ptr [bx + 0x3833]       ; UNKNOWN
019E10  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
019E15  83 C4 02              ADD    sp, 2                        ; UNKNOWN
019E18  52                    PUSH   dx                           ; UNKNOWN
019E19  50                    PUSH   ax                           ; UNKNOWN
019E1A  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019E1D  16                    PUSH   ss                           ; UNKNOWN
019E1E  50                    PUSH   ax                           ; UNKNOWN
019E1F  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
019E24  83 C4 08              ADD    sp, 8                        ; UNKNOWN
019E27  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019E2A  50                    PUSH   ax                           ; UNKNOWN
019E2B  9A 9E 0D 65 5F        LCALL  0x5f65, 0xd9e                ; UNKNOWN
019E30  83 C4 02              ADD    sp, 2                        ; UNKNOWN
019E33  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019E36  16                    PUSH   ss                           ; UNKNOWN
019E37  50                    PUSH   ax                           ; UNKNOWN
019E38  1E                    PUSH   ds                           ; UNKNOWN
019E39  68 40 3F              PUSH   0x3f40                       ; UNKNOWN
019E3C  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
019E41  83 C4 08              ADD    sp, 8                        ; UNKNOWN
019E44  68 23 16              PUSH   0x1623                       ; UNKNOWN
019E47  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019E4A  50                    PUSH   ax                           ; UNKNOWN
019E4B  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
019E50  83 C4 04              ADD    sp, 4                        ; UNKNOWN
019E53  83 7E 9E 0E           CMP    word ptr [bp - 0x62], 0xe    ; UNKNOWN
019E57  75 0F                 JNE    0x19e68                      ; UNKNOWN
019E59  68 2B 16              PUSH   0x162b                       ; UNKNOWN
019E5C  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019E5F  50                    PUSH   ax                           ; UNKNOWN
019E60  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
019E65  83 C4 04              ADD    sp, 4                        ; UNKNOWN
019E68  83 7E 9E 0F           CMP    word ptr [bp - 0x62], 0xf    ; UNKNOWN
019E6C  74 03                 JE     0x19e71                      ; UNKNOWN
019E6E  E9 DD FE              JMP    0x19d4e                      ; UNKNOWN
019E71  68 33 16              PUSH   0x1633                       ; UNKNOWN
019E74  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
019E77  50                    PUSH   ax                           ; UNKNOWN
019E78  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
019E7D  E9                    DB     0xE9                         ; UNKNOWN (raw)
019E7E  CB                    DB     0xCB                         ; UNKNOWN (raw)
