; ============================================================================
; func_012D38_unknown
; Region   : load_image
; Bytes    : file 0x012D38..0x0131B1  (1145 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012D38  C8 D8 00 00           ENTER  0xd8, 0                      ; UNKNOWN
012D3C  57                    PUSH   di                           ; UNKNOWN
012D3D  56                    PUSH   si                           ; UNKNOWN
012D3E  C7 86 3A FF FF FF     MOV    word ptr [bp - 0xc6], 0xffff ; UNKNOWN
012D44  C7 86 3C FF 01 00     MOV    word ptr [bp - 0xc4], 1      ; UNKNOWN
012D4A  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
012D4E  7C 18                 JL     0x12d68                      ; UNKNOWN
012D50  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4       ; UNKNOWN
012D54  7D 12                 JGE    0x12d68                      ; UNKNOWN
012D56  6B 5E 0A 34           IMUL   bx, word ptr [bp + 0xa], 0x34 ; UNKNOWN
012D5A  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
012D5F  75 07                 JNE    0x12d68                      ; UNKNOWN
012D61  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
012D66  EB 05                 JMP    0x12d6d                      ; UNKNOWN
012D68  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
012D6D  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
012D71  74 3C                 JE     0x12daf                      ; UNKNOWN
012D73  6A 03                 PUSH   3                            ; UNKNOWN
012D75  6A 00                 PUSH   0                            ; UNKNOWN
012D77  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
012D7C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
012D7F  0B C0                 OR     ax, ax                       ; UNKNOWN
012D81  75 2C                 JNE    0x12daf                      ; UNKNOWN
012D83  6A 05                 PUSH   5                            ; UNKNOWN
012D85  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
012D8A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
012D8D  83 3E 3A 82 00        CMP    word ptr [0x823a], 0         ; UNKNOWN
012D92  75 0A                 JNE    0x12d9e                      ; UNKNOWN
012D94  6A 07                 PUSH   7                            ; UNKNOWN
012D96  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
012D9B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
012D9E  83 3E 3A 82 01        CMP    word ptr [0x823a], 1         ; UNKNOWN
012DA3  75 0A                 JNE    0x12daf                      ; UNKNOWN
012DA5  6A 06                 PUSH   6                            ; UNKNOWN
012DA7  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
012DAC  83 C4 02              ADD    sp, 2                        ; UNKNOWN
012DAF  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
012DB3  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
012DB8  72 07                 JB     0x12dc1                      ; UNKNOWN
012DBA  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
012DBF  76 09                 JBE    0x12dca                      ; UNKNOWN
012DC1  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
012DC5  C6 87 94 88 00        MOV    byte ptr [bx - 0x776c], 0    ; UNKNOWN
012DCA  C7 86 40 FF 00 00     MOV    word ptr [bp - 0xc0], 0      ; UNKNOWN
012DD0  8A 86 40 FF           MOV    al, byte ptr [bp - 0xc0]     ; UNKNOWN
012DD4  8B B6 40 FF           MOV    si, word ptr [bp - 0xc0]     ; UNKNOWN
012DD8  88 42 86              MOV    byte ptr [bp + si - 0x7a], al ; UNKNOWN
012DDB  88 82 6A FF           MOV    byte ptr [bp + si - 0x96], al ; UNKNOWN
012DDF  FF 86 40 FF           INC    word ptr [bp - 0xc0]         ; UNKNOWN
012DE3  83 BE 40 FF 10        CMP    word ptr [bp - 0xc0], 0x10   ; UNKNOWN
012DE8  7C E6                 JL     0x12dd0                      ; UNKNOWN
012DEA  FF 36 86 3E           PUSH   word ptr [0x3e86]            ; UNKNOWN
012DEE  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
012DF3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
012DF6  0E                    PUSH   cs                           ; UNKNOWN
012DF7  E8 7C F8              CALL   0x12676                      ; UNKNOWN
012DFA  A1 5C 82              MOV    ax, word ptr [0x825c]        ; UNKNOWN
012DFD  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
012E00  C7 06 5C 82 00 00     MOV    word ptr [0x825c], 0         ; UNKNOWN
012E06  A1 76 82              MOV    ax, word ptr [0x8276]        ; UNKNOWN
012E09  39 46 9A              CMP    word ptr [bp - 0x66], ax     ; UNKNOWN
012E0C  7E 06                 JLE    0x12e14                      ; UNKNOWN
012E0E  C7 06 3C 82 00 00     MOV    word ptr [0x823c], 0         ; UNKNOWN
012E14  8D 86 6A FF           LEA    ax, [bp - 0x96]              ; UNKNOWN
012E18  16                    PUSH   ss                           ; UNKNOWN
012E19  50                    PUSH   ax                           ; UNKNOWN
012E1A  1E                    PUSH   ds                           ; UNKNOWN
012E1B  68 5C 82              PUSH   0x825c                       ; UNKNOWN
012E1E  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
012E21  9A 00 00 DB 5C        LCALL  0x5cdb, 0                    ; UNKNOWN
012E26  C7 86 40 FF 01 00     MOV    word ptr [bp - 0xc0], 1      ; UNKNOWN
012E2C  8D 9E 7A FF           LEA    bx, [bp - 0x86]              ; UNKNOWN
012E30  2B 9E 40 FF           SUB    bx, word ptr [bp - 0xc0]     ; UNKNOWN
012E34  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
012E36  8B C8                 MOV    cx, ax                       ; UNKNOWN
012E38  98                    CWDE                                ; UNKNOWN
012E39  8B F0                 MOV    si, ax                       ; UNKNOWN
012E3B  D1 E6                 SHL    si, 1                        ; UNKNOWN
012E3D  C7 84 3C 82 00 00     MOV    word ptr [si - 0x7dc4], 0    ; UNKNOWN
012E43  0A C9                 OR     cl, cl                       ; UNKNOWN
012E45  75 03                 JNE    0x12e4a                      ; UNKNOWN
012E47  C6 07 0C              MOV    byte ptr [bx], 0xc           ; UNKNOWN
012E4A  FF 86 40 FF           INC    word ptr [bp - 0xc0]         ; UNKNOWN
012E4E  83 BE 40 FF 03        CMP    word ptr [bp - 0xc0], 3      ; UNKNOWN
012E53  7E D7                 JLE    0x12e2c                      ; UNKNOWN
012E55  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
012E59  7D 03                 JGE    0x12e5e                      ; UNKNOWN
012E5B  E9 45 0C              JMP    0x13aa3                      ; UNKNOWN
012E5E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
012E62  80 BF 8C 88 00        CMP    byte ptr [bx - 0x7774], 0    ; UNKNOWN
012E67  75 03                 JNE    0x12e6c                      ; UNKNOWN
012E69  E9 47 01              JMP    0x12fb3                      ; UNKNOWN
012E6C  C7 46 84 00 00        MOV    word ptr [bp - 0x7c], 0      ; UNKNOWN
012E71  80 BF 8C 88 01        CMP    byte ptr [bx - 0x7774], 1    ; UNKNOWN
012E76  77 03                 JA     0x12e7b                      ; UNKNOWN
012E78  E9 15 01              JMP    0x12f90                      ; UNKNOWN
012E7B  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
012E7F  75 15                 JNE    0x12e96                      ; UNKNOWN
012E81  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
012E85  2A E4                 SUB    ah, ah                       ; UNKNOWN
012E87  48                    DEC    ax                           ; UNKNOWN
012E88  50                    PUSH   ax                           ; UNKNOWN
012E89  6A 00                 PUSH   0                            ; UNKNOWN
012E8B  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
012E90  83 C4 04              ADD    sp, 4                        ; UNKNOWN
012E93  E9 F7 00              JMP    0x12f8d                      ; UNKNOWN
012E96  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
012E9A  8D 06 3F 25           LEA    ax, [0x253f]                 ; UNKNOWN
012E9E  2B D2                 SUB    dx, dx                       ; UNKNOWN
012EA0  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
012EA5  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
012EA8  89 56 9E              MOV    word ptr [bp - 0x62], dx     ; UNKNOWN
012EAB  0B D0                 OR     dx, ax                       ; UNKNOWN
012EAD  75 03                 JNE    0x12eb2                      ; UNKNOWN
012EAF  E9 DC 0B              JMP    0x13a8e                      ; UNKNOWN
012EB2  C7 86 40 FF 00 00     MOV    word ptr [bp - 0xc0], 0      ; UNKNOWN
012EB8  EB 73                 JMP    0x12f2d                      ; UNKNOWN
012EBA  FF B6 40 FF           PUSH   word ptr [bp - 0xc0]         ; UNKNOWN
012EBE  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
012EC1  9A 92 2F 5F 24        LCALL  0x245f, 0x2f92               ; UNKNOWN
012EC6  83 C4 04              ADD    sp, 4                        ; UNKNOWN
012EC9  89 86 3A FF           MOV    word ptr [bp - 0xc6], ax     ; UNKNOWN
012ECD  6A 0A                 PUSH   0xa                          ; UNKNOWN
012ECF  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
012ED2  50                    PUSH   ax                           ; UNKNOWN
012ED3  FF B6 40 FF           PUSH   word ptr [bp - 0xc0]         ; UNKNOWN
012ED7  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
012EDA  9A DF 2F 5F 24        LCALL  0x245f, 0x2fdf               ; UNKNOWN
012EDF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
012EE2  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
012EE5  50                    PUSH   ax                           ; UNKNOWN
012EE6  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
012EEB  83 C4 06              ADD    sp, 6                        ; UNKNOWN
012EEE  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
012EF1  50                    PUSH   ax                           ; UNKNOWN
012EF2  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
012EF7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
012EFA  8B 9E 3A FF           MOV    bx, word ptr [bp - 0xc6]     ; UNKNOWN
012EFE  D1 E3                 SHL    bx, 1                        ; UNKNOWN
012F00  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
012F04  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
012F07  50                    PUSH   ax                           ; UNKNOWN
012F08  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
012F0D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
012F10  8B 86 40 FF           MOV    ax, word ptr [bp - 0xc0]     ; UNKNOWN
012F14  40                    INC    ax                           ; UNKNOWN
012F15  50                    PUSH   ax                           ; UNKNOWN
012F16  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
012F19  16                    PUSH   ss                           ; UNKNOWN
012F1A  50                    PUSH   ax                           ; UNKNOWN
012F1B  FF 76 9E              PUSH   word ptr [bp - 0x62]         ; UNKNOWN
012F1E  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
012F21  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
012F26  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
012F29  FF 86 40 FF           INC    word ptr [bp - 0xc0]         ; UNKNOWN
012F2D  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
012F31  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
012F35  2A E4                 SUB    ah, ah                       ; UNKNOWN
012F37  3B 86 40 FF           CMP    ax, word ptr [bp - 0xc0]     ; UNKNOWN
012F3B  7E 03                 JLE    0x12f40                      ; UNKNOWN
012F3D  E9 7A FF              JMP    0x12eba                      ; UNKNOWN
012F40  6A 63                 PUSH   0x63                         ; UNKNOWN
012F42  FF 36 3A 33           PUSH   word ptr [0x333a]            ; UNKNOWN
012F46  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
012F4B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
012F4E  52                    PUSH   dx                           ; UNKNOWN
012F4F  50                    PUSH   ax                           ; UNKNOWN
012F50  FF 76 9E              PUSH   word ptr [bp - 0x62]         ; UNKNOWN
012F53  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
012F56  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
012F5B  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
012F5E  FF 76 9E              PUSH   word ptr [bp - 0x62]         ; UNKNOWN
012F61  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
012F64  9A 4A 25 97 1B        LCALL  0x1b97, 0x254a               ; UNKNOWN
012F69  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
012F6C  FF 76 9E              PUSH   word ptr [bp - 0x62]         ; UNKNOWN
012F6F  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
012F72  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
012F77  83 7E A4 00           CMP    word ptr [bp - 0x5c], 0      ; UNKNOWN
012F7B  75 03                 JNE    0x12f80                      ; UNKNOWN
012F7D  E9 0E 0B              JMP    0x13a8e                      ; UNKNOWN
012F80  83 7E A4 63           CMP    word ptr [bp - 0x5c], 0x63   ; UNKNOWN
012F84  75 03                 JNE    0x12f89                      ; UNKNOWN
012F86  E9 05 0B              JMP    0x13a8e                      ; UNKNOWN
012F89  8B 46 A4              MOV    ax, word ptr [bp - 0x5c]     ; UNKNOWN
012F8C  48                    DEC    ax                           ; UNKNOWN
012F8D  89 46 84              MOV    word ptr [bp - 0x7c], ax     ; UNKNOWN
012F90  FF 76 84              PUSH   word ptr [bp - 0x7c]         ; UNKNOWN
012F93  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
012F96  9A 92 2F 5F 24        LCALL  0x245f, 0x2f92               ; UNKNOWN
012F9B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
012F9E  89 86 3A FF           MOV    word ptr [bp - 0xc6], ax     ; UNKNOWN
012FA2  FF 76 84              PUSH   word ptr [bp - 0x7c]         ; UNKNOWN
012FA5  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
012FA8  9A DF 2F 5F 24        LCALL  0x245f, 0x2fdf               ; UNKNOWN
012FAD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
012FB0  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
012FB3  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
012FB6  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
012FBA  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
012FBF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
012FC2  89 86 2C FF           MOV    word ptr [bp - 0xd4], ax     ; UNKNOWN
012FC6  83 BE 3A FF 00        CMP    word ptr [bp - 0xc6], 0      ; UNKNOWN
012FCB  7D 03                 JGE    0x12fd0                      ; UNKNOWN
012FCD  E9 D9 03              JMP    0x133a9                      ; UNKNOWN
012FD0  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
012FD4  75 03                 JNE    0x12fd9                      ; UNKNOWN
012FD6  E9 FA 00              JMP    0x130d3                      ; UNKNOWN
012FD9  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
012FDD  8A 47 08              MOV    al, byte ptr [bx + 8]        ; UNKNOWN
012FE0  98                    CWDE                                ; UNKNOWN
012FE1  3B 86 3A FF           CMP    ax, word ptr [bp - 0xc6]     ; UNKNOWN
012FE5  74 1A                 JE     0x13001                      ; UNKNOWN
012FE7  8A 47 09              MOV    al, byte ptr [bx + 9]        ; UNKNOWN
012FEA  98                    CWDE                                ; UNKNOWN
012FEB  3B 86 3A FF           CMP    ax, word ptr [bp - 0xc6]     ; UNKNOWN
012FEF  74 10                 JE     0x13001                      ; UNKNOWN
012FF1  8B 9E 3A FF           MOV    bx, word ptr [bp - 0xc6]     ; UNKNOWN
012FF5  D1 E3                 SHL    bx, 1                        ; UNKNOWN
012FF7  83 BF 3C 82 00        CMP    word ptr [bx - 0x7dc4], 0    ; UNKNOWN
012FFC  74 03                 JE     0x13001                      ; UNKNOWN
012FFE  E9 A9 00              JMP    0x130aa                      ; UNKNOWN
013001  8B 9E 3A FF           MOV    bx, word ptr [bp - 0xc6]     ; UNKNOWN
013005  D1 E3                 SHL    bx, 1                        ; UNKNOWN
013007  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
01300B  6A 00                 PUSH   0                            ; UNKNOWN
01300D  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
013012  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013015  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
013019  80 7F 08 00           CMP    byte ptr [bx + 8], 0         ; UNKNOWN
01301D  7C 0E                 JL     0x1302d                      ; UNKNOWN
01301F  8A 47 08              MOV    al, byte ptr [bx + 8]        ; UNKNOWN
013022  98                    CWDE                                ; UNKNOWN
013023  8B D8                 MOV    bx, ax                       ; UNKNOWN
013025  D1 E3                 SHL    bx, 1                        ; UNKNOWN
013027  C7 87 3C 82 00 00     MOV    word ptr [bx - 0x7dc4], 0    ; UNKNOWN
01302D  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
013031  80 7F 09 00           CMP    byte ptr [bx + 9], 0         ; UNKNOWN
013035  7C 0E                 JL     0x13045                      ; UNKNOWN
013037  8A 47 09              MOV    al, byte ptr [bx + 9]        ; UNKNOWN
01303A  98                    CWDE                                ; UNKNOWN
01303B  8B D8                 MOV    bx, ax                       ; UNKNOWN
01303D  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01303F  C7 87 3C 82 00 00     MOV    word ptr [bx - 0x7dc4], 0    ; UNKNOWN
013045  8D 46 86              LEA    ax, [bp - 0x7a]              ; UNKNOWN
013048  16                    PUSH   ss                           ; UNKNOWN
013049  50                    PUSH   ax                           ; UNKNOWN
01304A  1E                    PUSH   ds                           ; UNKNOWN
01304B  68 3C 82              PUSH   0x823c                       ; UNKNOWN
01304E  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
013051  9A 00 00 DB 5C        LCALL  0x5cdb, 0                    ; UNKNOWN
013056  8A 46 95              MOV    al, byte ptr [bp - 0x6b]     ; UNKNOWN
013059  98                    CWDE                                ; UNKNOWN
01305A  8B D8                 MOV    bx, ax                       ; UNKNOWN
01305C  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01305E  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
013062  6A 01                 PUSH   1                            ; UNKNOWN
013064  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
013069  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01306C  8A 46 94              MOV    al, byte ptr [bp - 0x6c]     ; UNKNOWN
01306F  98                    CWDE                                ; UNKNOWN
013070  8B D8                 MOV    bx, ax                       ; UNKNOWN
013072  D1 E3                 SHL    bx, 1                        ; UNKNOWN
013074  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
013078  6A 02                 PUSH   2                            ; UNKNOWN
01307A  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
01307F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013082  8A 46 93              MOV    al, byte ptr [bp - 0x6d]     ; UNKNOWN
013085  98                    CWDE                                ; UNKNOWN
013086  8B D8                 MOV    bx, ax                       ; UNKNOWN
013088  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01308A  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
01308E  6A 03                 PUSH   3                            ; UNKNOWN
013090  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
013095  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013098  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
01309C  68 4A 25              PUSH   0x254a                       ; UNKNOWN
01309F  9A 00 37 97 1B        LCALL  0x1b97, 0x3700               ; UNKNOWN
0130A4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0130A7  E9 E4 09              JMP    0x13a8e                      ; UNKNOWN
0130AA  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
0130AE  8A 47 07              MOV    al, byte ptr [bx + 7]        ; UNKNOWN
0130B1  98                    CWDE                                ; UNKNOWN
0130B2  3B 86 3A FF           CMP    ax, word ptr [bp - 0xc6]     ; UNKNOWN
0130B6  75 1B                 JNE    0x130d3                      ; UNKNOWN
0130B8  8B D8                 MOV    bx, ax                       ; UNKNOWN
0130BA  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0130BC  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
0130C0  6A 00                 PUSH   0                            ; UNKNOWN
0130C2  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
0130C7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0130CA  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
0130CE  68 53 25              PUSH   0x2553                       ; UNKNOWN
0130D1  EB CC                 JMP    0x1309f                      ; UNKNOWN
0130D3  6A 05                 PUSH   5                            ; UNKNOWN
0130D5  6A 01                 PUSH   1                            ; UNKNOWN
0130D7  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
0130DC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0130DF  89 46 80              MOV    word ptr [bp - 0x80], ax     ; UNKNOWN
0130E2  C7 46 A6 06 00        MOV    word ptr [bp - 0x5a], 6      ; UNKNOWN
0130E7  83 BE 3A FF 08        CMP    word ptr [bp - 0xc6], 8      ; UNKNOWN
0130EC  7E 05                 JLE    0x130f3                      ; UNKNOWN
0130EE  C7 46 A6 07 00        MOV    word ptr [bp - 0x5a], 7      ; UNKNOWN
0130F3  83 BE 3A FF 0D        CMP    word ptr [bp - 0xc6], 0xd    ; UNKNOWN
0130F8  75 0F                 JNE    0x13109                      ; UNKNOWN
0130FA  6A 07                 PUSH   7                            ; UNKNOWN
0130FC  6A 00                 PUSH   0                            ; UNKNOWN
0130FE  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
013103  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013106  29 46 A6              SUB    word ptr [bp - 0x5a], ax     ; UNKNOWN
013109  83 BE 3A FF 0F        CMP    word ptr [bp - 0xc6], 0xf    ; UNKNOWN
01310E  75 10                 JNE    0x13120                      ; UNKNOWN
013110  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
013114  8A 47 07              MOV    al, byte ptr [bx + 7]        ; UNKNOWN
013117  98                    CWDE                                ; UNKNOWN
013118  83 E8 0C              SUB    ax, 0xc                      ; UNKNOWN
01311B  F7 D8                 NEG    ax                           ; UNKNOWN
01311D  01 46 A6              ADD    word ptr [bp - 0x5a], ax     ; UNKNOWN
013120  83 BE 3A FF 08        CMP    word ptr [bp - 0xc6], 8      ; UNKNOWN
013125  75 10                 JNE    0x13137                      ; UNKNOWN
013127  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
01312B  8A 47 08              MOV    al, byte ptr [bx + 8]        ; UNKNOWN
01312E  98                    CWDE                                ; UNKNOWN
01312F  83 E8 0A              SUB    ax, 0xa                      ; UNKNOWN
013132  F7 D8                 NEG    ax                           ; UNKNOWN
013134  01 46 A6              ADD    word ptr [bp - 0x5a], ax     ; UNKNOWN
013137  83 BE 3A FF 0E        CMP    word ptr [bp - 0xc6], 0xe    ; UNKNOWN
01313C  75 03                 JNE    0x13141                      ; UNKNOWN
01313E  FF 46 A6              INC    word ptr [bp - 0x5a]         ; UNKNOWN
013141  FF B6 2C FF           PUSH   word ptr [bp - 0xd4]         ; UNKNOWN
013145  9A A1 00 BA 33        LCALL  0x33ba, 0xa1                 ; UNKNOWN
01314A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01314D  D1 E0                 SHL    ax, 1                        ; UNKNOWN
01314F  89 46 82              MOV    word ptr [bp - 0x7e], ax     ; UNKNOWN
013152  83 BE 3A FF 0F        CMP    word ptr [bp - 0xc6], 0xf    ; UNKNOWN
013157  74 07                 JE     0x13160                      ; UNKNOWN
013159  83 BE 3A FF 08        CMP    word ptr [bp - 0xc6], 8      ; UNKNOWN
01315E  75 05                 JNE    0x13165                      ; UNKNOWN
013160  C7 46 82 00 00        MOV    word ptr [bp - 0x7e], 0      ; UNKNOWN
013165  8B 9E 3A FF           MOV    bx, word ptr [bp - 0xc6]     ; UNKNOWN
013169  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01316B  83 BF 3C 82 14        CMP    word ptr [bx - 0x7dc4], 0x14 ; UNKNOWN
013170  7C 03                 JL     0x13175                      ; UNKNOWN
013172  D1 7E 82              SAR    word ptr [bp - 0x7e], 1      ; UNKNOWN
013175  6A 00                 PUSH   0                            ; UNKNOWN
013177  6A 64                 PUSH   0x64                         ; UNKNOWN
013179  8B 46 A6              MOV    ax, word ptr [bp - 0x5a]     ; UNKNOWN
01317C  8A 0E 1E 3E           MOV    cl, byte ptr [0x3e1e]        ; UNKNOWN
013180  2A ED                 SUB    ch, ch                       ; UNKNOWN
013182  2B C1                 SUB    ax, cx                       ; UNKNOWN
013184  2B 46 82              SUB    ax, word ptr [bp - 0x7e]     ; UNKNOWN
013187  03 46 80              ADD    ax, word ptr [bp - 0x80]     ; UNKNOWN
01318A  83 C0 04              ADD    ax, 4                        ; UNKNOWN
01318D  D1 E0                 SHL    ax, 1                        ; UNKNOWN
01318F  89 86 2A FF           MOV    word ptr [bp - 0xd6], ax     ; UNKNOWN
013193  8B 9E 3A FF           MOV    bx, word ptr [bp - 0xc6]     ; UNKNOWN
013197  D1 E3                 SHL    bx, 1                        ; UNKNOWN
013199  F7 AF 3C 82           IMUL   word ptr [bx - 0x7dc4]       ; UNKNOWN
01319D  0B C0                 OR     ax, ax                       ; UNKNOWN
01319F  7D 02                 JGE    0x131a3                      ; UNKNOWN
0131A1  2B C0                 SUB    ax, ax                       ; UNKNOWN
0131A3  8B C8                 MOV    cx, ax                       ; UNKNOWN
0131A5  8B 46 80              MOV    ax, word ptr [bp - 0x80]     ; UNKNOWN
0131A8  8B D0                 MOV    dx, ax                       ; UNKNOWN
0131AA  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
0131AD  03 C2                 ADD    ax, dx                       ; UNKNOWN
0131AF  03 C1                 ADD    ax, cx                       ; UNKNOWN
