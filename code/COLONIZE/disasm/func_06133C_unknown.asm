; ============================================================================
; func_06133C_unknown
; Region   : load_image
; Bytes    : file 0x06133C..0x06147C  (320 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06133C  C8 CC 00 00           ENTER  0xcc, 0                      ; UNKNOWN
061340  56                    PUSH   si                           ; UNKNOWN
061341  83 7E 16 00           CMP    word ptr [bp + 0x16], 0      ; UNKNOWN
061345  7C 0B                 JL     0x61352                      ; UNKNOWN
061347  FF 76 16              PUSH   word ptr [bp + 0x16]         ; UNKNOWN
06134A  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
06134F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
061352  83 7E 18 00           CMP    word ptr [bp + 0x18], 0      ; UNKNOWN
061356  7C 0B                 JL     0x61363                      ; UNKNOWN
061358  FF 76 18              PUSH   word ptr [bp + 0x18]         ; UNKNOWN
06135B  9A 32 00 BA 33        LCALL  0x33ba, 0x32                 ; UNKNOWN
061360  83 C4 02              ADD    sp, 2                        ; UNKNOWN
061363  2B C0                 SUB    ax, ax                       ; UNKNOWN
061365  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
061368  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
06136B  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
06136E  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
061371  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
061374  E9 81 10              JMP    0x623f8                      ; UNKNOWN
061377  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
06137A  3B 46 EA              CMP    ax, word ptr [bp - 0x16]     ; UNKNOWN
06137D  7D 03                 JGE    0x61382                      ; UNKNOWN
06137F  8B 46 EA              MOV    ax, word ptr [bp - 0x16]     ; UNKNOWN
061382  6B C0 14              IMUL   ax, ax, 0x14                 ; UNKNOWN
061385  83 C0 06              ADD    ax, 6                        ; UNKNOWN
061388  89 46 8E              MOV    word ptr [bp - 0x72], ax     ; UNKNOWN
06138B  8B C8                 MOV    cx, ax                       ; UNKNOWN
06138D  D1 F8                 SAR    ax, 1                        ; UNKNOWN
06138F  83 E8 64              SUB    ax, 0x64                     ; UNKNOWN
061392  F7 D8                 NEG    ax                           ; UNKNOWN
061394  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
061397  51                    PUSH   cx                           ; UNKNOWN
061398  B9 D6 00              MOV    cx, 0xd6                     ; UNKNOWN
06139B  89 4E 92              MOV    word ptr [bp - 0x6e], cx     ; UNKNOWN
06139E  51                    PUSH   cx                           ; UNKNOWN
06139F  50                    PUSH   ax                           ; UNKNOWN
0613A0  B9 35 00              MOV    cx, 0x35                     ; UNKNOWN
0613A3  89 4E F0              MOV    word ptr [bp - 0x10], cx     ; UNKNOWN
0613A6  51                    PUSH   cx                           ; UNKNOWN
0613A7  6A 00                 PUSH   0                            ; UNKNOWN
0613A9  6A 00                 PUSH   0                            ; UNKNOWN
0613AB  8B F0                 MOV    si, ax                       ; UNKNOWN
0613AD  9A 47 22 97 1B        LCALL  0x1b97, 0x2247               ; UNKNOWN
0613B2  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
0613B5  8D 44 03              LEA    ax, [si + 3]                 ; UNKNOWN
0613B8  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0613BB  8A 0E 62 09           MOV    cl, byte ptr [0x962]         ; UNKNOWN
0613BF  2A ED                 SUB    ch, ch                       ; UNKNOWN
0613C1  51                    PUSH   cx                           ; UNKNOWN
0613C2  8B C8                 MOV    cx, ax                       ; UNKNOWN
0613C4  83 C0 06              ADD    ax, 6                        ; UNKNOWN
0613C7  50                    PUSH   ax                           ; UNKNOWN
0613C8  68 D0 00              PUSH   0xd0                         ; UNKNOWN
0613CB  B8 38 00              MOV    ax, 0x38                     ; UNKNOWN
0613CE  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0613D1  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
0613D4  50                    PUSH   ax                           ; UNKNOWN
0613D5  FF 36 90 33           PUSH   word ptr [0x3390]            ; UNKNOWN
0613D9  8B F1                 MOV    si, cx                       ; UNKNOWN
0613DB  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
0613E0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0613E3  52                    PUSH   dx                           ; UNKNOWN
0613E4  50                    PUSH   ax                           ; UNKNOWN
0613E5  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
0613EA  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
0613ED  8D 44 14              LEA    ax, [si + 0x14]              ; UNKNOWN
0613F0  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
0613F3  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
0613F6  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0613F9  C7 46 E8 00 00        MOV    word ptr [bp - 0x18], 0      ; UNKNOWN
0613FE  E9 B4 0F              JMP    0x623b5                      ; UNKNOWN
061401  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
061404  89 46 88              MOV    word ptr [bp - 0x78], ax     ; UNKNOWN
061407  83 7E E8 00           CMP    word ptr [bp - 0x18], 0      ; UNKNOWN
06140B  75 05                 JNE    0x61412                      ; UNKNOWN
06140D  8B 46 12              MOV    ax, word ptr [bp + 0x12]     ; UNKNOWN
061410  EB 03                 JMP    0x61415                      ; UNKNOWN
061412  8B 46 14              MOV    ax, word ptr [bp + 0x14]     ; UNKNOWN
061415  89 86 36 FF           MOV    word ptr [bp - 0xca], ax     ; UNKNOWN
061419  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
06141C  89 46 8C              MOV    word ptr [bp - 0x74], ax     ; UNKNOWN
06141F  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0      ; UNKNOWN
061423  74 13                 JE     0x61438                      ; UNKNOWN
061425  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
061428  6A 00                 PUSH   0                            ; UNKNOWN
06142A  6A 64                 PUSH   0x64                         ; UNKNOWN
06142C  8B D8                 MOV    bx, ax                       ; UNKNOWN
06142E  8B 46 88              MOV    ax, word ptr [bp - 0x78]     ; UNKNOWN
061431  2B D2                 SUB    dx, dx                       ; UNKNOWN
061433  9A BD 01 76 1A        LCALL  0x1a76, 0x1bd                ; UNKNOWN
061438  83 46 8C 11           ADD    word ptr [bp - 0x74], 0x11   ; UNKNOWN
06143C  F6 46 8B 02           TEST   byte ptr [bp - 0x75], 2      ; UNKNOWN
061440  74 2A                 JE     0x6146c                      ; UNKNOWN
061442  C6 46 94 00           MOV    byte ptr [bp - 0x6c], 0      ; UNKNOWN
061446  6B 5E 88 1C           IMUL   bx, word ptr [bp - 0x78], 0x1c ; UNKNOWN
06144A  8A 87 97 88           MOV    al, byte ptr [bx - 0x7769]   ; UNKNOWN
06144E  98                    CWDE                                ; UNKNOWN
06144F  50                    PUSH   ax                           ; UNKNOWN
061450  9A 2C 02 5F 24        LCALL  0x245f, 0x22c                ; UNKNOWN
061455  83 C4 02              ADD    sp, 2                        ; UNKNOWN
061458  50                    PUSH   ax                           ; UNKNOWN
061459  8D 46 94              LEA    ax, [bp - 0x6c]              ; UNKNOWN
06145C  50                    PUSH   ax                           ; UNKNOWN
06145D  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
061462  83 C4 04              ADD    sp, 4                        ; UNKNOWN
061465  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
06146A  EB 36                 JMP    0x614a2                      ; UNKNOWN
06146C  C6 46 94 00           MOV    byte ptr [bp - 0x6c], 0      ; UNKNOWN
061470  6B 5E 88 1C           IMUL   bx, word ptr [bp - 0x78], 0x1c ; UNKNOWN
061474  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
061478  2A FF                 SUB    bh, bh                       ; UNKNOWN
06147A  8B C3                 MOV    ax, bx                       ; UNKNOWN
