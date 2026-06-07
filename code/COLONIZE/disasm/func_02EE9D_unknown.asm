; ============================================================================
; func_02EE9D_unknown
; Region   : load_image
; Bytes    : file 0x02EE9D..0x02F2F8  (1115 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EE9D  C8 2A 00 00           ENTER  0x2a, 0                      ; UNKNOWN
02EEA1  56                    PUSH   si                           ; UNKNOWN
02EEA2  2B C0                 SUB    ax, ax                       ; UNKNOWN
02EEA4  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
02EEA7  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
02EEAA  89 46 D8              MOV    word ptr [bp - 0x28], ax     ; UNKNOWN
02EEAD  8D 46 D6              LEA    ax, [bp - 0x2a]              ; UNKNOWN
02EEB0  50                    PUSH   ax                           ; UNKNOWN
02EEB1  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02EEB4  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02EEB7  0E                    PUSH   cs                           ; UNKNOWN
02EEB8  E8 BE FD              CALL   0x2ec79                      ; UNKNOWN
02EEBB  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02EEBE  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
02EEC1  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
02EEC4  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
02EEC6  0B C0                 OR     ax, ax                       ; UNKNOWN
02EEC8  7D 03                 JGE    0x2eecd                      ; UNKNOWN
02EECA  E9 25 04              JMP    0x2f2f2                      ; UNKNOWN
02EECD  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02EED1  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
02EED4  2A E4                 SUB    ah, ah                       ; UNKNOWN
02EED6  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
02EED9  48                    DEC    ax                           ; UNKNOWN
02EEDA  48                    DEC    ax                           ; UNKNOWN
02EEDB  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02EEDE  50                    PUSH   ax                           ; UNKNOWN
02EEDF  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02EEE1  2A E4                 SUB    ah, ah                       ; UNKNOWN
02EEE3  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
02EEE6  48                    DEC    ax                           ; UNKNOWN
02EEE7  48                    DEC    ax                           ; UNKNOWN
02EEE8  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02EEEB  50                    PUSH   ax                           ; UNKNOWN
02EEEC  9A 04 01 C9 33        LCALL  0x33c9, 0x104                ; UNKNOWN
02EEF1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02EEF4  88 46 DA              MOV    byte ptr [bp - 0x26], al     ; UNKNOWN
02EEF7  2A E4                 SUB    ah, ah                       ; UNKNOWN
02EEF9  50                    PUSH   ax                           ; UNKNOWN
02EEFA  9A 0E 00 3C 22        LCALL  0x223c, 0xe                  ; UNKNOWN
02EEFF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02EF02  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
02EF05  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02EF08  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02EF0B  9A 9A 04 C9 33        LCALL  0x33c9, 0x49a                ; UNKNOWN
02EF10  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02EF13  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
02EF16  8B 76 E2              MOV    si, word ptr [bp - 0x1e]     ; UNKNOWN
02EF19  C1 E6 04              SHL    si, 4                        ; UNKNOWN
02EF1C  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
02EF1F  8A 80 BB 34           MOV    al, byte ptr [bx + si + 0x34bb] ; UNKNOWN
02EF23  2A E4                 SUB    ah, ah                       ; UNKNOWN
02EF25  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
02EF28  0B C0                 OR     ax, ax                       ; UNKNOWN
02EF2A  75 03                 JNE    0x2ef2f                      ; UNKNOWN
02EF2C  E9 84 00              JMP    0x2efb3                      ; UNKNOWN
02EF2F  83 FB 08              CMP    bx, 8                        ; UNKNOWN
02EF32  7C 52                 JL     0x2ef86                      ; UNKNOWN
02EF34  6A 1A                 PUSH   0x1a                         ; UNKNOWN
02EF36  6A 19                 PUSH   0x19                         ; UNKNOWN
02EF38  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02EF3B  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02EF3E  0E                    PUSH   cs                           ; UNKNOWN
02EF3F  E8 B0 FD              CALL   0x2ecf2                      ; UNKNOWN
02EF42  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02EF45  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02EF48  83 F8 08              CMP    ax, 8                        ; UNKNOWN
02EF4B  7C 06                 JL     0x2ef53                      ; UNKNOWN
02EF4D  83 6E DC 02           SUB    word ptr [bp - 0x24], 2      ; UNKNOWN
02EF51  EB 33                 JMP    0x2ef86                      ; UNKNOWN
02EF53  83 F8 06              CMP    ax, 6                        ; UNKNOWN
02EF56  7C 05                 JL     0x2ef5d                      ; UNKNOWN
02EF58  FF 4E DC              DEC    word ptr [bp - 0x24]         ; UNKNOWN
02EF5B  EB 29                 JMP    0x2ef86                      ; UNKNOWN
02EF5D  83 F8 06              CMP    ax, 6                        ; UNKNOWN
02EF60  7D 05                 JGE    0x2ef67                      ; UNKNOWN
02EF62  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
02EF65  EB 1F                 JMP    0x2ef86                      ; UNKNOWN
02EF67  83 F8 04              CMP    ax, 4                        ; UNKNOWN
02EF6A  7D 06                 JGE    0x2ef72                      ; UNKNOWN
02EF6C  83 46 DC 02           ADD    word ptr [bp - 0x24], 2      ; UNKNOWN
02EF70  EB 14                 JMP    0x2ef86                      ; UNKNOWN
02EF72  83 F8 03              CMP    ax, 3                        ; UNKNOWN
02EF75  7D 06                 JGE    0x2ef7d                      ; UNKNOWN
02EF77  83 46 DC 03           ADD    word ptr [bp - 0x24], 3      ; UNKNOWN
02EF7B  EB 09                 JMP    0x2ef86                      ; UNKNOWN
02EF7D  83 F8 01              CMP    ax, 1                        ; UNKNOWN
02EF80  7D 04                 JGE    0x2ef86                      ; UNKNOWN
02EF82  83 46 DC 04           ADD    word ptr [bp - 0x24], 4      ; UNKNOWN
02EF86  83 7E EE 04           CMP    word ptr [bp - 0x12], 4      ; UNKNOWN
02EF8A  75 27                 JNE    0x2efb3                      ; UNKNOWN
02EF8C  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02EF8F  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02EF92  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
02EF97  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02EF9A  A8 0A                 TEST   al, 0xa                      ; UNKNOWN
02EF9C  74 03                 JE     0x2efa1                      ; UNKNOWN
02EF9E  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
02EFA1  F6 46 DA 40           TEST   byte ptr [bp - 0x26], 0x40   ; UNKNOWN
02EFA5  74 0C                 JE     0x2efb3                      ; UNKNOWN
02EFA7  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
02EFAA  F6 46 DA 80           TEST   byte ptr [bp - 0x26], 0x80   ; UNKNOWN
02EFAE  74 03                 JE     0x2efb3                      ; UNKNOWN
02EFB0  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
02EFB3  8B 46 DC              MOV    ax, word ptr [bp - 0x24]     ; UNKNOWN
02EFB6  0B C0                 OR     ax, ax                       ; UNKNOWN
02EFB8  7D 02                 JGE    0x2efbc                      ; UNKNOWN
02EFBA  2B C0                 SUB    ax, ax                       ; UNKNOWN
02EFBC  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
02EFBF  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02EFC2  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02EFC5  0E                    PUSH   cs                           ; UNKNOWN
02EFC6  E8 BD EC              CALL   0x2dc86                      ; UNKNOWN
02EFC9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02EFCC  98                    CWDE                                ; UNKNOWN
02EFCD  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
02EFD0  50                    PUSH   ax                           ; UNKNOWN
02EFD1  0E                    PUSH   cs                           ; UNKNOWN
02EFD2  E8 4B F4              CALL   0x2e420                      ; UNKNOWN
02EFD5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02EFD8  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
02EFDB  3B 46 EE              CMP    ax, word ptr [bp - 0x12]     ; UNKNOWN
02EFDE  75 05                 JNE    0x2efe5                      ; UNKNOWN
02EFE0  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02EFE3  EB 02                 JMP    0x2efe7                      ; UNKNOWN
02EFE5  2B C0                 SUB    ax, ax                       ; UNKNOWN
02EFE7  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
02EFEA  83 7E E0 1B           CMP    word ptr [bp - 0x20], 0x1b   ; UNKNOWN
02EFEE  75 05                 JNE    0x2eff5                      ; UNKNOWN
02EFF0  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02EFF3  EB 02                 JMP    0x2eff7                      ; UNKNOWN
02EFF5  2B C0                 SUB    ax, ax                       ; UNKNOWN
02EFF7  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
02EFFA  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
02EFFE  74 06                 JE     0x2f006                      ; UNKNOWN
02F000  83 7E EE 08           CMP    word ptr [bp - 0x12], 8      ; UNKNOWN
02F004  75 07                 JNE    0x2f00d                      ; UNKNOWN
02F006  C7 46 EC 01 00        MOV    word ptr [bp - 0x14], 1      ; UNKNOWN
02F00B  EB 05                 JMP    0x2f012                      ; UNKNOWN
02F00D  C7 46 EC 00 00        MOV    word ptr [bp - 0x14], 0      ; UNKNOWN
02F012  0E                    PUSH   cs                           ; UNKNOWN
02F013  E8 4B E8              CALL   0x2d861                      ; UNKNOWN
02F016  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
02F019  B9 64 00              MOV    cx, 0x64                     ; UNKNOWN
02F01C  2B C8                 SUB    cx, ax                       ; UNKNOWN
02F01E  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F022  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02F025  98                    CWDE                                ; UNKNOWN
02F026  F7 E9                 IMUL   cx                           ; UNKNOWN
02F028  83 C0 32              ADD    ax, 0x32                     ; UNKNOWN
02F02B  B9 64 00              MOV    cx, 0x64                     ; UNKNOWN
02F02E  99                    CDQ                                 ; UNKNOWN
02F02F  F7 F9                 IDIV   cx                           ; UNKNOWN
02F031  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
02F034  80 7F 1A 04           CMP    byte ptr [bx + 0x1a], 4      ; UNKNOWN
02F038  73 1B                 JAE    0x2f055                      ; UNKNOWN
02F03A  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
02F03D  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F03F  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
02F042  38 A7 B7 C0           CMP    byte ptr [bx - 0x3f49], ah   ; UNKNOWN
02F046  75 0D                 JNE    0x2f055                      ; UNKNOWN
02F048  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
02F04B  83 E8 0A              SUB    ax, 0xa                      ; UNKNOWN
02F04E  F7 D8                 NEG    ax                           ; UNKNOWN
02F050  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
02F053  EB 05                 JMP    0x2f05a                      ; UNKNOWN
02F055  C7 46 F2 0A 00        MOV    word ptr [bp - 0xe], 0xa     ; UNKNOWN
02F05A  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F05E  80 7F 1A 04           CMP    byte ptr [bx + 0x1a], 4      ; UNKNOWN
02F062  73 0E                 JAE    0x2f072                      ; UNKNOWN
02F064  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
02F067  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F069  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
02F06C  38 A7 B7 C0           CMP    byte ptr [bx - 0x3f49], ah   ; UNKNOWN
02F070  74 05                 JE     0x2f077                      ; UNKNOWN
02F072  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; UNKNOWN
02F077  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
02F07A  99                    CDQ                                 ; UNKNOWN
02F07B  F7 7E F2              IDIV   word ptr [bp - 0xe]          ; UNKNOWN
02F07E  F7 D8                 NEG    ax                           ; UNKNOWN
02F080  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
02F083  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F087  F6 47 1C 04           TEST   byte ptr [bx + 0x1c], 4      ; UNKNOWN
02F08B  74 04                 JE     0x2f091                      ; UNKNOWN
02F08D  40                    INC    ax                           ; UNKNOWN
02F08E  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
02F091  F6 47 1C 02           TEST   byte ptr [bx + 0x1c], 2      ; UNKNOWN
02F095  74 03                 JE     0x2f09a                      ; UNKNOWN
02F097  FF 46 E6              INC    word ptr [bp - 0x1a]         ; UNKNOWN
02F09A  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; UNKNOWN
02F09E  74 0C                 JE     0x2f0ac                      ; UNKNOWN
02F0A0  83 7E E6 00           CMP    word ptr [bp - 0x1a], 0      ; UNKNOWN
02F0A4  7E 06                 JLE    0x2f0ac                      ; UNKNOWN
02F0A6  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
02F0A9  01 46 DC              ADD    word ptr [bp - 0x24], ax     ; UNKNOWN
02F0AC  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; UNKNOWN
02F0B0  74 21                 JE     0x2f0d3                      ; UNKNOWN
02F0B2  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; UNKNOWN
02F0B6  74 1B                 JE     0x2f0d3                      ; UNKNOWN
02F0B8  83 7E EC 00           CMP    word ptr [bp - 0x14], 0      ; UNKNOWN
02F0BC  74 12                 JE     0x2f0d0                      ; UNKNOWN
02F0BE  83 46 DC 02           ADD    word ptr [bp - 0x24], 2      ; UNKNOWN
02F0C2  83 7E E6 00           CMP    word ptr [bp - 0x1a], 0      ; UNKNOWN
02F0C6  7E 0B                 JLE    0x2f0d3                      ; UNKNOWN
02F0C8  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
02F0CB  01 46 DC              ADD    word ptr [bp - 0x24], ax     ; UNKNOWN
02F0CE  EB 03                 JMP    0x2f0d3                      ; UNKNOWN
02F0D0  D1 66 DC              SHL    word ptr [bp - 0x24], 1      ; UNKNOWN
02F0D3  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
02F0D6  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
02F0D8  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
02F0DB  0E                    PUSH   cs                           ; UNKNOWN
02F0DC  E8 CD FC              CALL   0x2edac                      ; UNKNOWN
02F0DF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F0E2  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
02F0E5  83 7E E8 07           CMP    word ptr [bp - 0x18], 7      ; UNKNOWN
02F0E9  75 0B                 JNE    0x2f0f6                      ; UNKNOWN
02F0EB  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; UNKNOWN
02F0EF  7F 05                 JG     0x2f0f6                      ; UNKNOWN
02F0F1  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
02F0F6  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
02F0FA  7D 05                 JGE    0x2f101                      ; UNKNOWN
02F0FC  D1 66 DC              SHL    word ptr [bp - 0x24], 1      ; UNKNOWN
02F0FF  EB 0F                 JMP    0x2f110                      ; UNKNOWN
02F101  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; UNKNOWN
02F105  74 03                 JE     0x2f10a                      ; UNKNOWN
02F107  D1 66 F0              SHL    word ptr [bp - 0x10], 1      ; UNKNOWN
02F10A  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
02F10D  01 46 DC              ADD    word ptr [bp - 0x24], ax     ; UNKNOWN
02F110  83 7E E8 06           CMP    word ptr [bp - 0x18], 6      ; UNKNOWN
02F114  75 16                 JNE    0x2f12c                      ; UNKNOWN
02F116  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
02F119  83 3F 06              CMP    word ptr [bx], 6             ; UNKNOWN
02F11C  75 04                 JNE    0x2f122                      ; UNKNOWN
02F11E  FE 06 64 74           INC    byte ptr [0x7464]            ; UNKNOWN
02F122  83 3F 07              CMP    word ptr [bx], 7             ; UNKNOWN
02F125  75 05                 JNE    0x2f12c                      ; UNKNOWN
02F127  80 06 64 74 02        ADD    byte ptr [0x7464], 2         ; UNKNOWN
02F12C  83 7E E8 0C           CMP    word ptr [bp - 0x18], 0xc    ; UNKNOWN
02F130  75 0C                 JNE    0x2f13e                      ; UNKNOWN
02F132  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
02F135  83 3F 07              CMP    word ptr [bx], 7             ; UNKNOWN
02F138  75 04                 JNE    0x2f13e                      ; UNKNOWN
02F13A  FE 06 64 74           INC    byte ptr [0x7464]            ; UNKNOWN
02F13E  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
02F141  83 3F 07              CMP    word ptr [bx], 7             ; UNKNOWN
02F144  75 61                 JNE    0x2f1a7                      ; UNKNOWN
02F146  83 7E E8 FF           CMP    word ptr [bp - 0x18], -1     ; UNKNOWN
02F14A  75 5B                 JNE    0x2f1a7                      ; UNKNOWN
02F14C  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02F14F  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02F152  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
02F157  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F15A  A8 04                 TEST   al, 4                        ; UNKNOWN
02F15C  75 05                 JNE    0x2f163                      ; UNKNOWN
02F15E  C7 46 D8 01 00        MOV    word ptr [bp - 0x28], 1      ; UNKNOWN
02F163  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
02F166  83 3F 07              CMP    word ptr [bx], 7             ; UNKNOWN
02F169  75 3C                 JNE    0x2f1a7                      ; UNKNOWN
02F16B  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02F16E  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02F171  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
02F176  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F179  A8 04                 TEST   al, 4                        ; UNKNOWN
02F17B  75 2A                 JNE    0x2f1a7                      ; UNKNOWN
02F17D  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; UNKNOWN
02F181  74 24                 JE     0x2f1a7                      ; UNKNOWN
02F183  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02F186  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02F189  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
02F18E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F191  A8 0A                 TEST   al, 0xa                      ; UNKNOWN
02F193  75 06                 JNE    0x2f19b                      ; UNKNOWN
02F195  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; UNKNOWN
02F199  74 07                 JE     0x2f1a2                      ; UNKNOWN
02F19B  C7 46 DC 01 00        MOV    word ptr [bp - 0x24], 1      ; UNKNOWN
02F1A0  EB 05                 JMP    0x2f1a7                      ; UNKNOWN
02F1A2  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0      ; UNKNOWN
02F1A7  83 7E EE 05           CMP    word ptr [bp - 0x12], 5      ; UNKNOWN
02F1AB  75 03                 JNE    0x2f1b0                      ; UNKNOWN
02F1AD  D1 66 DC              SHL    word ptr [bp - 0x24], 1      ; UNKNOWN
02F1B0  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; UNKNOWN
02F1B4  7F 03                 JG     0x2f1b9                      ; UNKNOWN
02F1B6  E9 92 00              JMP    0x2f24b                      ; UNKNOWN
02F1B9  83 7E D8 00           CMP    word ptr [bp - 0x28], 0      ; UNKNOWN
02F1BD  74 03                 JE     0x2f1c2                      ; UNKNOWN
02F1BF  E9 89 00              JMP    0x2f24b                      ; UNKNOWN
02F1C2  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; UNKNOWN
02F1C7  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; UNKNOWN
02F1CB  74 06                 JE     0x2f1d3                      ; UNKNOWN
02F1CD  83 7E EC 00           CMP    word ptr [bp - 0x14], 0      ; UNKNOWN
02F1D1  74 06                 JE     0x2f1d9                      ; UNKNOWN
02F1D3  83 7E EE 05           CMP    word ptr [bp - 0x12], 5      ; UNKNOWN
02F1D7  75 05                 JNE    0x2f1de                      ; UNKNOWN
02F1D9  C7 46 F6 02 00        MOV    word ptr [bp - 0xa], 2       ; UNKNOWN
02F1DE  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
02F1E3  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
02F1E7  75 06                 JNE    0x2f1ef                      ; UNKNOWN
02F1E9  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
02F1EC  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
02F1EF  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02F1F2  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02F1F5  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
02F1FA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F1FD  A8 0A                 TEST   al, 0xa                      ; UNKNOWN
02F1FF  74 0C                 JE     0x2f20d                      ; UNKNOWN
02F201  83 7E EE 03           CMP    word ptr [bp - 0x12], 3      ; UNKNOWN
02F205  7E 06                 JLE    0x2f20d                      ; UNKNOWN
02F207  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
02F20A  01 46 F0              ADD    word ptr [bp - 0x10], ax     ; UNKNOWN
02F20D  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02F210  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02F213  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
02F218  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F21B  A8 40                 TEST   al, 0x40                     ; UNKNOWN
02F21D  74 0C                 JE     0x2f22b                      ; UNKNOWN
02F21F  83 7E EE 03           CMP    word ptr [bp - 0x12], 3      ; UNKNOWN
02F223  7F 06                 JG     0x2f22b                      ; UNKNOWN
02F225  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
02F228  01 46 F0              ADD    word ptr [bp - 0x10], ax     ; UNKNOWN
02F22B  F6 46 DA 40           TEST   byte ptr [bp - 0x26], 0x40   ; UNKNOWN
02F22F  74 14                 JE     0x2f245                      ; UNKNOWN
02F231  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
02F234  01 46 F0              ADD    word ptr [bp - 0x10], ax     ; UNKNOWN
02F237  F6 46 DA 80           TEST   byte ptr [bp - 0x26], 0x80   ; UNKNOWN
02F23B  74 08                 JE     0x2f245                      ; UNKNOWN
02F23D  39 46 F0              CMP    word ptr [bp - 0x10], ax     ; UNKNOWN
02F240  75 03                 JNE    0x2f245                      ; UNKNOWN
02F242  01 46 F0              ADD    word ptr [bp - 0x10], ax     ; UNKNOWN
02F245  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
02F248  01 46 DC              ADD    word ptr [bp - 0x24], ax     ; UNKNOWN
02F24B  83 7E EE 08           CMP    word ptr [bp - 0x12], 8      ; UNKNOWN
02F24F  7C 10                 JL     0x2f261                      ; UNKNOWN
02F251  6A 06                 PUSH   6                            ; UNKNOWN
02F253  0E                    PUSH   cs                           ; UNKNOWN
02F254  E8 21 E7              CALL   0x2d978                      ; UNKNOWN
02F257  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02F25A  0B C0                 OR     ax, ax                       ; UNKNOWN
02F25C  75 03                 JNE    0x2f261                      ; UNKNOWN
02F25E  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
02F261  83 7E EE 04           CMP    word ptr [bp - 0x12], 4      ; UNKNOWN
02F265  75 1B                 JNE    0x2f282                      ; UNKNOWN
02F267  6A 08                 PUSH   8                            ; UNKNOWN
02F269  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F26D  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
02F270  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F272  50                    PUSH   ax                           ; UNKNOWN
02F273  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
02F278  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F27B  0B C0                 OR     ax, ax                       ; UNKNOWN
02F27D  74 03                 JE     0x2f282                      ; UNKNOWN
02F27F  D1 66 DC              SHL    word ptr [bp - 0x24], 1      ; UNKNOWN
02F282  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
02F286  74 2D                 JE     0x2f2b5                      ; UNKNOWN
02F288  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; UNKNOWN
02F28C  7E 27                 JLE    0x2f2b5                      ; UNKNOWN
02F28E  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
02F292  74 1E                 JE     0x2f2b2                      ; UNKNOWN
02F294  83 7E EE 02           CMP    word ptr [bp - 0x12], 2      ; UNKNOWN
02F298  74 18                 JE     0x2f2b2                      ; UNKNOWN
02F29A  83 7E EE 03           CMP    word ptr [bp - 0x12], 3      ; UNKNOWN
02F29E  74 12                 JE     0x2f2b2                      ; UNKNOWN
02F2A0  83 7E EE 01           CMP    word ptr [bp - 0x12], 1      ; UNKNOWN
02F2A4  74 0C                 JE     0x2f2b2                      ; UNKNOWN
02F2A6  83 7E EE 04           CMP    word ptr [bp - 0x12], 4      ; UNKNOWN
02F2AA  74 06                 JE     0x2f2b2                      ; UNKNOWN
02F2AC  83 7E EE 08           CMP    word ptr [bp - 0x12], 8      ; UNKNOWN
02F2B0  7C 03                 JL     0x2f2b5                      ; UNKNOWN
02F2B2  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
02F2B5  8B 46 DC              MOV    ax, word ptr [bp - 0x24]     ; UNKNOWN
02F2B8  0B C0                 OR     ax, ax                       ; UNKNOWN
02F2BA  7D 02                 JGE    0x2f2be                      ; UNKNOWN
02F2BC  2B C0                 SUB    ax, ax                       ; UNKNOWN
02F2BE  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
02F2C1  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
02F2C5  74 0D                 JE     0x2f2d4                      ; UNKNOWN
02F2C7  83 7E EE 08           CMP    word ptr [bp - 0x12], 8      ; UNKNOWN
02F2CB  7C 07                 JL     0x2f2d4                      ; UNKNOWN
02F2CD  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
02F2D0  C7 07 00 00           MOV    word ptr [bx], 0             ; UNKNOWN
02F2D4  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; UNKNOWN
02F2D8  74 18                 JE     0x2f2f2                      ; UNKNOWN
02F2DA  83 7E E6 00           CMP    word ptr [bp - 0x1a], 0      ; UNKNOWN
02F2DE  7D 12                 JGE    0x2f2f2                      ; UNKNOWN
02F2E0  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
02F2E3  01 46 DC              ADD    word ptr [bp - 0x24], ax     ; UNKNOWN
02F2E6  8B 46 DC              MOV    ax, word ptr [bp - 0x24]     ; UNKNOWN
02F2E9  0B C0                 OR     ax, ax                       ; UNKNOWN
02F2EB  7D 02                 JGE    0x2f2ef                      ; UNKNOWN
02F2ED  2B C0                 SUB    ax, ax                       ; UNKNOWN
02F2EF  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
02F2F2  8B 46 DC              MOV    ax, word ptr [bp - 0x24]     ; UNKNOWN
02F2F5  5E                    POP    si                           ; UNKNOWN
02F2F6  C9                    LEAVE                               ; UNKNOWN
02F2F7  CB                    RETF                                ; UNKNOWN
