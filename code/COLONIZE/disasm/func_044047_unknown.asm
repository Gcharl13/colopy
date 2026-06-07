; ============================================================================
; func_044047_unknown
; Region   : load_image
; Bytes    : file 0x044047..0x0441D6  (399 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044047  C8 2C 00 00           ENTER  0x2c, 0                      ; UNKNOWN
04404B  56                    PUSH   si                           ; UNKNOWN
04404C  A1 B2 C1              MOV    ax, word ptr [0xc1b2]        ; UNKNOWN
04404F  89 46 DA              MOV    word ptr [bp - 0x26], ax     ; UNKNOWN
044052  2B C0                 SUB    ax, ax                       ; UNKNOWN
044054  A3 B2 C1              MOV    word ptr [0xc1b2], ax        ; UNKNOWN
044057  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04405A  E9 BF 00              JMP    0x4411c                      ; UNKNOWN
04405D  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
044060  2B 06 2C 0B           SUB    ax, word ptr [0xb2c]         ; UNKNOWN
044064  F7 D0                 NOT    ax                           ; UNKNOWN
044066  40                    INC    ax                           ; UNKNOWN
044067  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
04406A  FF 36 3A 0B           PUSH   word ptr [0xb3a]             ; UNKNOWN
04406E  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
044071  2B 06 2E 0B           SUB    ax, word ptr [0xb2e]         ; UNKNOWN
044075  0B C0                 OR     ax, ax                       ; UNKNOWN
044077  7F 0A                 JG     0x44083                      ; UNKNOWN
044079  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
04407C  2B 06 2E 0B           SUB    ax, word ptr [0xb2e]         ; UNKNOWN
044080  F7 D0                 NOT    ax                           ; UNKNOWN
044082  40                    INC    ax                           ; UNKNOWN
044083  50                    PUSH   ax                           ; UNKNOWN
044084  FF 76 DC              PUSH   word ptr [bp - 0x24]         ; UNKNOWN
044087  9A 33 00 C9 33        LCALL  0x33c9, 0x33                 ; UNKNOWN
04408C  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04408F  83 F8 01              CMP    ax, 1                        ; UNKNOWN
044092  1B C0                 SBB    ax, ax                       ; UNKNOWN
044094  F7 D8                 NEG    ax                           ; UNKNOWN
044096  09 46 F8              OR     word ptr [bp - 8], ax        ; UNKNOWN
044099  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04409C  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
04409F  83 7E F6 00           CMP    word ptr [bp - 0xa], 0       ; UNKNOWN
0440A3  7D 07                 JGE    0x440ac                      ; UNKNOWN
0440A5  2B 06 94 82           SUB    ax, word ptr [0x8294]        ; UNKNOWN
0440A9  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
0440AC  83 7E F6 00           CMP    word ptr [bp - 0xa], 0       ; UNKNOWN
0440B0  7E 06                 JLE    0x440b8                      ; UNKNOWN
0440B2  A1 94 82              MOV    ax, word ptr [0x8294]        ; UNKNOWN
0440B5  01 46 EE              ADD    word ptr [bp - 0x12], ax     ; UNKNOWN
0440B8  C4 1E A2 C1           LES    bx, ptr [0xc1a2]             ; UNKNOWN
0440BC  8B 76 EE              MOV    si, word ptr [bp - 0x12]     ; UNKNOWN
0440BF  26 8A 00              MOV    al, byte ptr es:[bx + si]    ; UNKNOWN
0440C2  24 1F                 AND    al, 0x1f                     ; UNKNOWN
0440C4  88 46 F4              MOV    byte ptr [bp - 0xc], al      ; UNKNOWN
0440C7  3C 18                 CMP    al, 0x18                     ; UNKNOWN
0440C9  73 04                 JAE    0x440cf                      ; UNKNOWN
0440CB  80 66 F4 07           AND    byte ptr [bp - 0xc], 7       ; UNKNOWN
0440CF  8A 46 F4              MOV    al, byte ptr [bp - 0xc]      ; UNKNOWN
0440D2  2A E4                 SUB    ah, ah                       ; UNKNOWN
0440D4  50                    PUSH   ax                           ; UNKNOWN
0440D5  9A FE 05 C9 33        LCALL  0x33c9, 0x5fe                ; UNKNOWN
0440DA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0440DD  88 46 E4              MOV    byte ptr [bp - 0x1c], al     ; UNKNOWN
0440E0  C4 1E 9E C1           LES    bx, ptr [0xc19e]             ; UNKNOWN
0440E4  8B 76 EE              MOV    si, word ptr [bp - 0x12]     ; UNKNOWN
0440E7  C4 1E A6 C1           LES    bx, ptr [0xc1a6]             ; UNKNOWN
0440EB  26 8A 00              MOV    al, byte ptr es:[bx + si]    ; UNKNOWN
0440EE  80 3E B4 C1 00        CMP    byte ptr [0xc1b4], 0         ; UNKNOWN
0440F3  74 06                 JE     0x440fb                      ; UNKNOWN
0440F5  84 06 B4 C1           TEST   byte ptr [0xc1b4], al        ; UNKNOWN
0440F9  74 06                 JE     0x44101                      ; UNKNOWN
0440FB  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
0440FF  74 07                 JE     0x44108                      ; UNKNOWN
044101  C7 46 F2 01 00        MOV    word ptr [bp - 0xe], 1       ; UNKNOWN
044106  EB 05                 JMP    0x4410d                      ; UNKNOWN
044108  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0       ; UNKNOWN
04410D  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
044111  74 64                 JE     0x44177                      ; UNKNOWN
044113  83 7E F2 00           CMP    word ptr [bp - 0xe], 0       ; UNKNOWN
044117  74 5E                 JE     0x44177                      ; UNKNOWN
044119  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
04411C  83 7E FC 04           CMP    word ptr [bp - 4], 4         ; UNKNOWN
044120  7C 03                 JL     0x44125                      ; UNKNOWN
044122  E9 6B 01              JMP    0x44290                      ; UNKNOWN
044125  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
044128  8A 87 21 09           MOV    al, byte ptr [bx + 0x921]    ; UNKNOWN
04412C  98                    CWDE                                ; UNKNOWN
04412D  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
044130  8B C8                 MOV    cx, ax                       ; UNKNOWN
044132  8A 87 1C 09           MOV    al, byte ptr [bx + 0x91c]    ; UNKNOWN
044136  98                    CWDE                                ; UNKNOWN
044137  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04413A  03 06 AA C1           ADD    ax, word ptr [0xc1aa]        ; UNKNOWN
04413E  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
044141  03 0E AC C1           ADD    cx, word ptr [0xc1ac]        ; UNKNOWN
044145  89 4E E8              MOV    word ptr [bp - 0x18], cx     ; UNKNOWN
044148  51                    PUSH   cx                           ; UNKNOWN
044149  50                    PUSH   ax                           ; UNKNOWN
04414A  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
04414F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
044152  83 F8 01              CMP    ax, 1                        ; UNKNOWN
044155  1B C0                 SBB    ax, ax                       ; UNKNOWN
044157  F7 D8                 NEG    ax                           ; UNKNOWN
044159  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04415C  83 3E 3A 0B 00        CMP    word ptr [0xb3a], 0          ; UNKNOWN
044161  75 03                 JNE    0x44166                      ; UNKNOWN
044163  E9 33 FF              JMP    0x44099                      ; UNKNOWN
044166  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
044169  2B 06 2C 0B           SUB    ax, word ptr [0xb2c]         ; UNKNOWN
04416D  0B C0                 OR     ax, ax                       ; UNKNOWN
04416F  7F 03                 JG     0x44174                      ; UNKNOWN
044171  E9 E9 FE              JMP    0x4405d                      ; UNKNOWN
044174  E9 F0 FE              JMP    0x44067                      ; UNKNOWN
044177  80 7E E4 19           CMP    byte ptr [bp - 0x1c], 0x19   ; UNKNOWN
04417B  74 09                 JE     0x44186                      ; UNKNOWN
04417D  80 7E E4 1A           CMP    byte ptr [bp - 0x1c], 0x1a   ; UNKNOWN
044181  74 03                 JE     0x44186                      ; UNKNOWN
044183  E9 9F 00              JMP    0x44225                      ; UNKNOWN
044186  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
04418A  74 03                 JE     0x4418f                      ; UNKNOWN
04418C  E9 96 00              JMP    0x44225                      ; UNKNOWN
04418F  C7 46 F0 07 00        MOV    word ptr [bp - 0x10], 7      ; UNKNOWN
044194  EB 13                 JMP    0x441a9                      ; UNKNOWN
044196  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
044199  39 46 EA              CMP    word ptr [bp - 0x16], ax     ; UNKNOWN
04419C  7D 08                 JGE    0x441a6                      ; UNKNOWN
04419E  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
0441A1  39 46 E0              CMP    word ptr [bp - 0x20], ax     ; UNKNOWN
0441A4  7C 3F                 JL     0x441e5                      ; UNKNOWN
0441A6  FF 4E F0              DEC    word ptr [bp - 0x10]         ; UNKNOWN
0441A9  80 7E E4 19           CMP    byte ptr [bp - 0x1c], 0x19   ; UNKNOWN
0441AD  74 06                 JE     0x441b5                      ; UNKNOWN
0441AF  80 7E E4 1A           CMP    byte ptr [bp - 0x1c], 0x1a   ; UNKNOWN
0441B3  75 5E                 JNE    0x44213                      ; UNKNOWN
0441B5  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
0441B9  7C 58                 JL     0x44213                      ; UNKNOWN
0441BB  8B 5E F0              MOV    bx, word ptr [bp - 0x10]     ; UNKNOWN
0441BE  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
0441C2  98                    CWDE                                ; UNKNOWN
0441C3  03 46 EC              ADD    ax, word ptr [bp - 0x14]     ; UNKNOWN
0441C6  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
0441C9  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
0441CD  98                    CWDE                                ; UNKNOWN
0441CE  03 46 E8              ADD    ax, word ptr [bp - 0x18]     ; UNKNOWN
0441D1  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
0441D4  F6                    DB     0xF6                         ; UNKNOWN (raw)
0441D5  C3                    DB     0xC3                         ; UNKNOWN (raw)
