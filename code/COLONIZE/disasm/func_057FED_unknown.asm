; ============================================================================
; func_057FED_unknown
; Region   : load_image
; Bytes    : file 0x057FED..0x058385  (920 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

057FED  C8 24 00 00           ENTER  0x24, 0                      ; UNKNOWN
057FF1  56                    PUSH   si                           ; UNKNOWN
057FF2  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
057FF5  83 E8 04              SUB    ax, 4                        ; UNKNOWN
057FF8  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
057FFB  50                    PUSH   ax                           ; UNKNOWN
057FFC  9A 06 00 BA 33        LCALL  0x33ba, 6                    ; UNKNOWN
058001  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058004  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
058007  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
05800C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05800F  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
058013  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
058016  2A E4                 SUB    ah, ah                       ; UNKNOWN
058018  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
05801B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05801E  9A 94 01 49 22        LCALL  0x2249, 0x194                ; UNKNOWN
058023  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058026  50                    PUSH   ax                           ; UNKNOWN
058027  6A 00                 PUSH   0                            ; UNKNOWN
058029  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
05802E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058031  A1 38 73              MOV    ax, word ptr [0x7338]        ; UNKNOWN
058034  40                    INC    ax                           ; UNKNOWN
058035  40                    INC    ax                           ; UNKNOWN
058036  1E                    PUSH   ds                           ; UNKNOWN
058037  50                    PUSH   ax                           ; UNKNOWN
058038  6A 01                 PUSH   1                            ; UNKNOWN
05803A  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
05803F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
058042  6A 00                 PUSH   0                            ; UNKNOWN
058044  9A 98 03 5F 24        LCALL  0x245f, 0x398                ; UNKNOWN
058049  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05804C  8B C8                 MOV    cx, ax                       ; UNKNOWN
05804E  D1 E0                 SHL    ax, 1                        ; UNKNOWN
058050  03 C1                 ADD    ax, cx                       ; UNKNOWN
058052  40                    INC    ax                           ; UNKNOWN
058053  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
058056  FF 36 86 3E           PUSH   word ptr [0x3e86]            ; UNKNOWN
05805A  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
05805F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058062  6A 0C                 PUSH   0xc                          ; UNKNOWN
058064  6A 00                 PUSH   0                            ; UNKNOWN
058066  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
05806B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05806E  48                    DEC    ax                           ; UNKNOWN
05806F  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
058072  83 7E DE 04           CMP    word ptr [bp - 0x22], 4      ; UNKNOWN
058076  7D 15                 JGE    0x5808d                      ; UNKNOWN
058078  6B 5E DE 34           IMUL   bx, word ptr [bp - 0x22], 0x34 ; UNKNOWN
05807C  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
058081  75 0A                 JNE    0x5808d                      ; UNKNOWN
058083  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
058086  2A E4                 SUB    ah, ah                       ; UNKNOWN
058088  48                    DEC    ax                           ; UNKNOWN
058089  48                    DEC    ax                           ; UNKNOWN
05808A  01 46 E8              ADD    word ptr [bp - 0x18], ax     ; UNKNOWN
05808D  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
058090  39 46 E8              CMP    word ptr [bp - 0x18], ax     ; UNKNOWN
058093  7D 09                 JGE    0x5809e                      ; UNKNOWN
058095  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
058099  75 03                 JNE    0x5809e                      ; UNKNOWN
05809B  E9 74 02              JMP    0x58312                      ; UNKNOWN
05809E  6A 04                 PUSH   4                            ; UNKNOWN
0580A0  6A 01                 PUSH   1                            ; UNKNOWN
0580A2  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
0580A7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0580AA  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0580AD  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
0580B0  2A E4                 SUB    ah, ah                       ; UNKNOWN
0580B2  48                    DEC    ax                           ; UNKNOWN
0580B3  48                    DEC    ax                           ; UNKNOWN
0580B4  F7 D8                 NEG    ax                           ; UNKNOWN
0580B6  6B C0 28              IMUL   ax, ax, 0x28                 ; UNKNOWN
0580B9  3B 06 06 3E           CMP    ax, word ptr [0x3e06]        ; UNKNOWN
0580BD  7E 18                 JLE    0x580d7                      ; UNKNOWN
0580BF  80 3E 1E 3E 01        CMP    byte ptr [0x3e1e], 1         ; UNKNOWN
0580C4  77 11                 JA     0x580d7                      ; UNKNOWN
0580C6  83 7E FC 02           CMP    word ptr [bp - 4], 2         ; UNKNOWN
0580CA  74 06                 JE     0x580d2                      ; UNKNOWN
0580CC  83 7E FC 03           CMP    word ptr [bp - 4], 3         ; UNKNOWN
0580D0  75 05                 JNE    0x580d7                      ; UNKNOWN
0580D2  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
0580D7  83 7E FC 02           CMP    word ptr [bp - 4], 2         ; UNKNOWN
0580DB  75 4D                 JNE    0x5812a                      ; UNKNOWN
0580DD  83 7E DE 04           CMP    word ptr [bp - 0x22], 4      ; UNKNOWN
0580E1  7D 15                 JGE    0x580f8                      ; UNKNOWN
0580E3  6B 5E DE 34           IMUL   bx, word ptr [bp - 0x22], 0x34 ; UNKNOWN
0580E7  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
0580EC  75 0A                 JNE    0x580f8                      ; UNKNOWN
0580EE  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
0580F1  2A E4                 SUB    ah, ah                       ; UNKNOWN
0580F3  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
0580F6  EB 05                 JMP    0x580fd                      ; UNKNOWN
0580F8  C7 46 DC 01 00        MOV    word ptr [bp - 0x24], 1      ; UNKNOWN
0580FD  6A 08                 PUSH   8                            ; UNKNOWN
0580FF  6A 00                 PUSH   0                            ; UNKNOWN
058101  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
058106  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058109  8B 4E DC              MOV    cx, word ptr [bp - 0x24]     ; UNKNOWN
05810C  41                    INC    cx                           ; UNKNOWN
05810D  41                    INC    cx                           ; UNKNOWN
05810E  3B C1                 CMP    ax, cx                       ; UNKNOWN
058110  7E 05                 JLE    0x58117                      ; UNKNOWN
058112  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
058117  6A 01                 PUSH   1                            ; UNKNOWN
058119  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
05811E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058121  0B C0                 OR     ax, ax                       ; UNKNOWN
058123  74 05                 JE     0x5812a                      ; UNKNOWN
058125  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
05812A  83 7E FC 04           CMP    word ptr [bp - 4], 4         ; UNKNOWN
05812E  75 13                 JNE    0x58143                      ; UNKNOWN
058130  6A 00                 PUSH   0                            ; UNKNOWN
058132  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
058137  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05813A  0B C0                 OR     ax, ax                       ; UNKNOWN
05813C  74 05                 JE     0x58143                      ; UNKNOWN
05813E  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
058143  83 7E FC 03           CMP    word ptr [bp - 4], 3         ; UNKNOWN
058147  75 13                 JNE    0x5815c                      ; UNKNOWN
058149  6A 02                 PUSH   2                            ; UNKNOWN
05814B  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
058150  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058153  0B C0                 OR     ax, ax                       ; UNKNOWN
058155  74 05                 JE     0x5815c                      ; UNKNOWN
058157  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
05815C  83 7E FC 01           CMP    word ptr [bp - 4], 1         ; UNKNOWN
058160  75 29                 JNE    0x5818b                      ; UNKNOWN
058162  6A 00                 PUSH   0                            ; UNKNOWN
058164  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
058169  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05816C  0B C0                 OR     ax, ax                       ; UNKNOWN
05816E  74 1B                 JE     0x5818b                      ; UNKNOWN
058170  6A 08                 PUSH   8                            ; UNKNOWN
058172  6A 00                 PUSH   0                            ; UNKNOWN
058174  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
058179  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05817C  8A 0E 1E 3E           MOV    cl, byte ptr [0x3e1e]        ; UNKNOWN
058180  2A ED                 SUB    ch, ch                       ; UNKNOWN
058182  3B C1                 CMP    ax, cx                       ; UNKNOWN
058184  7E 05                 JLE    0x5818b                      ; UNKNOWN
058186  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
05818B  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
05818E  48                    DEC    ax                           ; UNKNOWN
05818F  74 15                 JE     0x581a6                      ; UNKNOWN
058191  48                    DEC    ax                           ; UNKNOWN
058192  75 03                 JNE    0x58197                      ; UNKNOWN
058194  E9 9B 00              JMP    0x58232                      ; UNKNOWN
058197  48                    DEC    ax                           ; UNKNOWN
058198  75 03                 JNE    0x5819d                      ; UNKNOWN
05819A  E9 1C 02              JMP    0x583b9                      ; UNKNOWN
05819D  48                    DEC    ax                           ; UNKNOWN
05819E  75 03                 JNE    0x581a3                      ; UNKNOWN
0581A0  E9 5D 02              JMP    0x58400                      ; UNKNOWN
0581A3  E9 71 01              JMP    0x58317                      ; UNKNOWN
0581A6  C7 46 EA 00 00        MOV    word ptr [bp - 0x16], 0      ; UNKNOWN
0581AB  FF 46 EA              INC    word ptr [bp - 0x16]         ; UNKNOWN
0581AE  6A 0F                 PUSH   0xf                          ; UNKNOWN
0581B0  6A 00                 PUSH   0                            ; UNKNOWN
0581B2  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
0581B7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0581BA  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
0581BD  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
0581C1  80 7F 08 00           CMP    byte ptr [bx + 8], 0         ; UNKNOWN
0581C5  75 2A                 JNE    0x581f1                      ; UNKNOWN
0581C7  83 7E EA 01           CMP    word ptr [bp - 0x16], 1      ; UNKNOWN
0581CB  75 24                 JNE    0x581f1                      ; UNKNOWN
0581CD  8B F0                 MOV    si, ax                       ; UNKNOWN
0581CF  D1 E6                 SHL    si, 1                        ; UNKNOWN
0581D1  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0581D5  83 B8 9A 00 34        CMP    word ptr [bx + si + 0x9a], 0x34 ; UNKNOWN
0581DA  7E 15                 JLE    0x581f1                      ; UNKNOWN
0581DC  6A 01                 PUSH   1                            ; UNKNOWN
0581DE  6A 00                 PUSH   0                            ; UNKNOWN
0581E0  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
0581E5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0581E8  0B C0                 OR     ax, ax                       ; UNKNOWN
0581EA  75 05                 JNE    0x581f1                      ; UNKNOWN
0581EC  C7 46 E2 08 00        MOV    word ptr [bp - 0x1e], 8      ; UNKNOWN
0581F1  83 7E E2 0F           CMP    word ptr [bp - 0x1e], 0xf    ; UNKNOWN
0581F5  75 19                 JNE    0x58210                      ; UNKNOWN
0581F7  68 C8 00              PUSH   0xc8                         ; UNKNOWN
0581FA  6A 00                 PUSH   0                            ; UNKNOWN
0581FC  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
058201  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058204  8B C8                 MOV    cx, ax                       ; UNKNOWN
058206  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
058209  2A E4                 SUB    ah, ah                       ; UNKNOWN
05820B  F7 6E EA              IMUL   word ptr [bp - 0x16]         ; UNKNOWN
05820E  2B C8                 SUB    cx, ax                       ; UNKNOWN
058210  83 7E EA 64           CMP    word ptr [bp - 0x16], 0x64   ; UNKNOWN
058214  7D 10                 JGE    0x58226                      ; UNKNOWN
058216  8B 76 E2              MOV    si, word ptr [bp - 0x1e]     ; UNKNOWN
058219  D1 E6                 SHL    si, 1                        ; UNKNOWN
05821B  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05821F  83 B8 9A 00 0A        CMP    word ptr [bx + si + 0x9a], 0xa ; UNKNOWN
058224  7C 85                 JL     0x581ab                      ; UNKNOWN
058226  83 7E EA 64           CMP    word ptr [bp - 0x16], 0x64   ; UNKNOWN
05822A  7D 03                 JGE    0x5822f                      ; UNKNOWN
05822C  E9 E8 00              JMP    0x58317                      ; UNKNOWN
05822F  E9 E0 00              JMP    0x58312                      ; UNKNOWN
058232  C7 46 EA 00 00        MOV    word ptr [bp - 0x16], 0      ; UNKNOWN
058237  6A 00                 PUSH   0                            ; UNKNOWN
058239  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05823D  8A 87 94 00           MOV    al, byte ptr [bx + 0x94]     ; UNKNOWN
058241  98                    CWDE                                ; UNKNOWN
058242  50                    PUSH   ax                           ; UNKNOWN
058243  9A 92 32 5F 24        LCALL  0x245f, 0x3292               ; UNKNOWN
058248  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05824B  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
05824E  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
058253  FF 46 EA              INC    word ptr [bp - 0x16]         ; UNKNOWN
058256  6A 29                 PUSH   0x29                         ; UNKNOWN
058258  6A 00                 PUSH   0                            ; UNKNOWN
05825A  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
05825F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058262  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
058265  83 F8 23              CMP    ax, 0x23                     ; UNKNOWN
058268  75 05                 JNE    0x5826f                      ; UNKNOWN
05826A  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
05826F  50                    PUSH   ax                           ; UNKNOWN
058270  9A 73 14 5F 24        LCALL  0x245f, 0x1473               ; UNKNOWN
058275  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058278  83 F8 09              CMP    ax, 9                        ; UNKNOWN
05827B  75 05                 JNE    0x58282                      ; UNKNOWN
05827D  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
058282  83 7E EE 01           CMP    word ptr [bp - 0x12], 1      ; UNKNOWN
058286  75 28                 JNE    0x582b0                      ; UNKNOWN
058288  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05828C  8A 87 94 00           MOV    al, byte ptr [bx + 0x94]     ; UNKNOWN
058290  98                    CWDE                                ; UNKNOWN
058291  50                    PUSH   ax                           ; UNKNOWN
058292  9A 73 14 5F 24        LCALL  0x245f, 0x1473               ; UNKNOWN
058297  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05829A  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
05829D  8B F0                 MOV    si, ax                       ; UNKNOWN
05829F  9A 73 14 5F 24        LCALL  0x245f, 0x1473               ; UNKNOWN
0582A4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0582A7  3B C6                 CMP    ax, si                       ; UNKNOWN
0582A9  75 05                 JNE    0x582b0                      ; UNKNOWN
0582AB  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0582B0  83 7E F8 27           CMP    word ptr [bp - 8], 0x27      ; UNKNOWN
0582B4  74 2A                 JE     0x582e0                      ; UNKNOWN
0582B6  83 7E F8 15           CMP    word ptr [bp - 8], 0x15      ; UNKNOWN
0582BA  74 24                 JE     0x582e0                      ; UNKNOWN
0582BC  83 7E F8 18           CMP    word ptr [bp - 8], 0x18      ; UNKNOWN
0582C0  74 1E                 JE     0x582e0                      ; UNKNOWN
0582C2  83 7E F8 1B           CMP    word ptr [bp - 8], 0x1b      ; UNKNOWN
0582C6  74 18                 JE     0x582e0                      ; UNKNOWN
0582C8  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
0582CC  74 12                 JE     0x582e0                      ; UNKNOWN
0582CE  83 7E F8 01           CMP    word ptr [bp - 8], 1         ; UNKNOWN
0582D2  74 0C                 JE     0x582e0                      ; UNKNOWN
0582D4  83 7E F8 02           CMP    word ptr [bp - 8], 2         ; UNKNOWN
0582D8  74 06                 JE     0x582e0                      ; UNKNOWN
0582DA  83 7E F8 20           CMP    word ptr [bp - 8], 0x20      ; UNKNOWN
0582DE  75 05                 JNE    0x582e5                      ; UNKNOWN
0582E0  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0582E5  83 7E EA 64           CMP    word ptr [bp - 0x16], 0x64   ; UNKNOWN
0582E9  7D 1B                 JGE    0x58306                      ; UNKNOWN
0582EB  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
0582EE  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
0582F3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0582F6  0B C0                 OR     ax, ax                       ; UNKNOWN
0582F8  75 03                 JNE    0x582fd                      ; UNKNOWN
0582FA  E9 51 FF              JMP    0x5824e                      ; UNKNOWN
0582FD  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
058301  75 03                 JNE    0x58306                      ; UNKNOWN
058303  E9 48 FF              JMP    0x5824e                      ; UNKNOWN
058306  83 7E EA 64           CMP    word ptr [bp - 0x16], 0x64   ; UNKNOWN
05830A  7D 06                 JGE    0x58312                      ; UNKNOWN
05830C  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
058310  75 69                 JNE    0x5837b                      ; UNKNOWN
058312  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
058317  FF 76 DE              PUSH   word ptr [bp - 0x22]         ; UNKNOWN
05831A  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
05831F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
058322  50                    PUSH   ax                           ; UNKNOWN
058323  6A 03                 PUSH   3                            ; UNKNOWN
058325  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
05832A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05832D  83 7E DE 04           CMP    word ptr [bp - 0x22], 4      ; UNKNOWN
058331  7D 0B                 JGE    0x5833e                      ; UNKNOWN
058333  6B 5E DE 34           IMUL   bx, word ptr [bp - 0x22], 0x34 ; UNKNOWN
058337  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
05833C  74 13                 JE     0x58351                      ; UNKNOWN
05833E  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
058342  74 0D                 JE     0x58351                      ; UNKNOWN
058344  6A 03                 PUSH   3                            ; UNKNOWN
058346  68 D4 2B              PUSH   0x2bd4                       ; UNKNOWN
058349  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
05834E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
058351  83 7E DE 04           CMP    word ptr [bp - 0x22], 4      ; UNKNOWN
058355  7C 03                 JL     0x5835a                      ; UNKNOWN
058357  E9 38 01              JMP    0x58492                      ; UNKNOWN
05835A  6B 5E DE 34           IMUL   bx, word ptr [bp - 0x22], 0x34 ; UNKNOWN
05835E  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
058363  74 03                 JE     0x58368                      ; UNKNOWN
058365  E9 2A 01              JMP    0x58492                      ; UNKNOWN
058368  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
05836C  74 03                 JE     0x58371                      ; UNKNOWN
05836E  E9 17 01              JMP    0x58488                      ; UNKNOWN
058371  6A 02                 PUSH   2                            ; UNKNOWN
058373  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
058378  E9 14 01              JMP    0x5848f                      ; UNKNOWN
05837B  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
058380  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
058383  8B C3                 MOV    ax, bx                       ; UNKNOWN
