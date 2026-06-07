; ============================================================================
; func_06B324_unknown
; Region   : load_image
; Bytes    : file 0x06B324..0x06B4B7  (403 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06B324  55                    PUSH   bp                           ; UNKNOWN
06B325  8B EC                 MOV    bp, sp                       ; UNKNOWN
06B327  B8 AE 00              MOV    ax, 0xae                     ; UNKNOWN
06B32A  9A 98 02 65 5F        LCALL  0x5f65, 0x298                ; UNKNOWN
06B32F  56                    PUSH   si                           ; UNKNOWN
06B330  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
06B333  C7 46 D8 01 00        MOV    word ptr [bp - 0x28], 1      ; UNKNOWN
06B338  C7 46 D2 00 00        MOV    word ptr [bp - 0x2e], 0      ; UNKNOWN
06B33D  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
06B341  75 46                 JNE    0x6b389                      ; UNKNOWN
06B343  89 76 DC              MOV    word ptr [bp - 0x24], si     ; UNKNOWN
06B346  B8 6C 15              MOV    ax, 0x156c                   ; UNKNOWN
06B349  50                    PUSH   ax                           ; UNKNOWN
06B34A  9A 74 2C 65 5F        LCALL  0x5f65, 0x2c74               ; UNKNOWN
06B34F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B352  8B F0                 MOV    si, ax                       ; UNKNOWN
06B354  0B F6                 OR     si, si                       ; UNKNOWN
06B356  75 0C                 JNE    0x6b364                      ; UNKNOWN
06B358  C7 06 38 12 08 00     MOV    word ptr [0x1238], 8         ; UNKNOWN
06B35E  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
06B361  E9 4E 01              JMP    0x6b4b2                      ; UNKNOWN
06B364  FF 76 DC              PUSH   word ptr [bp - 0x24]         ; UNKNOWN
06B367  56                    PUSH   si                           ; UNKNOWN
06B368  8D 86 52 FF           LEA    ax, [bp - 0xae]              ; UNKNOWN
06B36C  50                    PUSH   ax                           ; UNKNOWN
06B36D  8D 46 E0              LEA    ax, [bp - 0x20]              ; UNKNOWN
06B370  50                    PUSH   ax                           ; UNKNOWN
06B371  8D 46 D2              LEA    ax, [bp - 0x2e]              ; UNKNOWN
06B374  50                    PUSH   ax                           ; UNKNOWN
06B375  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
06B378  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
06B37B  9A 7A 2F 65 5F        LCALL  0x5f65, 0x2f7a               ; UNKNOWN
06B380  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
06B383  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
06B386  40                    INC    ax                           ; UNKNOWN
06B387  74 D5                 JE     0x6b35e                      ; UNKNOWN
06B389  B8 20 00              MOV    ax, 0x20                     ; UNKNOWN
06B38C  50                    PUSH   ax                           ; UNKNOWN
06B38D  B8 00 80              MOV    ax, 0x8000                   ; UNKNOWN
06B390  50                    PUSH   ax                           ; UNKNOWN
06B391  56                    PUSH   si                           ; UNKNOWN
06B392  9A D8 29 65 5F        LCALL  0x5f65, 0x29d8               ; UNKNOWN
06B397  83 C4 06              ADD    sp, 6                        ; UNKNOWN
06B39A  89 46 DA              MOV    word ptr [bp - 0x26], ax     ; UNKNOWN
06B39D  40                    INC    ax                           ; UNKNOWN
06B39E  75 14                 JNE    0x6b3b4                      ; UNKNOWN
06B3A0  83 7E D2 00           CMP    word ptr [bp - 0x2e], 0      ; UNKNOWN
06B3A4  74 B8                 JE     0x6b35e                      ; UNKNOWN
06B3A6  FF 76 D2              PUSH   word ptr [bp - 0x2e]         ; UNKNOWN
06B3A9  9A A8 2B 65 5F        LCALL  0x5f65, 0x2ba8               ; UNKNOWN
06B3AE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B3B1  EB AB                 JMP    0x6b35e                      ; UNKNOWN
06B3B3  90                    NOP                                 ; UNKNOWN
06B3B4  B8 18 00              MOV    ax, 0x18                     ; UNKNOWN
06B3B7  50                    PUSH   ax                           ; UNKNOWN
06B3B8  8D 46 E2              LEA    ax, [bp - 0x1e]              ; UNKNOWN
06B3BB  50                    PUSH   ax                           ; UNKNOWN
06B3BC  FF 76 DA              PUSH   word ptr [bp - 0x26]         ; UNKNOWN
06B3BF  9A 58 21 65 5F        LCALL  0x5f65, 0x2158               ; UNKNOWN
06B3C4  83 C4 06              ADD    sp, 6                        ; UNKNOWN
06B3C7  40                    INC    ax                           ; UNKNOWN
06B3C8  75 2C                 JNE    0x6b3f6                      ; UNKNOWN
06B3CA  FF 76 DA              PUSH   word ptr [bp - 0x26]         ; UNKNOWN
06B3CD  9A BE 20 65 5F        LCALL  0x5f65, 0x20be               ; UNKNOWN
06B3D2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B3D5  83 7E D2 00           CMP    word ptr [bp - 0x2e], 0      ; UNKNOWN
06B3D9  74 0B                 JE     0x6b3e6                      ; UNKNOWN
06B3DB  FF 76 D2              PUSH   word ptr [bp - 0x2e]         ; UNKNOWN
06B3DE  9A A8 2B 65 5F        LCALL  0x5f65, 0x2ba8               ; UNKNOWN
06B3E3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B3E6  C7 06 38 12 08 00     MOV    word ptr [0x1238], 8         ; UNKNOWN
06B3EC  C7 06 43 12 0B 00     MOV    word ptr [0x1243], 0xb       ; UNKNOWN
06B3F2  E9 69 FF              JMP    0x6b35e                      ; UNKNOWN
06B3F5  90                    NOP                                 ; UNKNOWN
06B3F6  B8 02 00              MOV    ax, 2                        ; UNKNOWN
06B3F9  50                    PUSH   ax                           ; UNKNOWN
06B3FA  2B C0                 SUB    ax, ax                       ; UNKNOWN
06B3FC  50                    PUSH   ax                           ; UNKNOWN
06B3FD  50                    PUSH   ax                           ; UNKNOWN
06B3FE  FF 76 DA              PUSH   word ptr [bp - 0x26]         ; UNKNOWN
06B401  9A DE 20 65 5F        LCALL  0x5f65, 0x20de               ; UNKNOWN
06B406  83 C4 08              ADD    sp, 8                        ; UNKNOWN
06B409  05 0F 00              ADD    ax, 0xf                      ; UNKNOWN
06B40C  83 D2 00              ADC    dx, 0                        ; UNKNOWN
06B40F  D1 FA                 SAR    dx, 1                        ; UNKNOWN
06B411  D1 D8                 RCR    ax, 1                        ; UNKNOWN
06B413  D1 FA                 SAR    dx, 1                        ; UNKNOWN
06B415  D1 D8                 RCR    ax, 1                        ; UNKNOWN
06B417  D1 FA                 SAR    dx, 1                        ; UNKNOWN
06B419  D1 D8                 RCR    ax, 1                        ; UNKNOWN
06B41B  D1 FA                 SAR    dx, 1                        ; UNKNOWN
06B41D  D1 D8                 RCR    ax, 1                        ; UNKNOWN
06B41F  89 46 D4              MOV    word ptr [bp - 0x2c], ax     ; UNKNOWN
06B422  89 56 D6              MOV    word ptr [bp - 0x2a], dx     ; UNKNOWN
06B425  FF 76 DA              PUSH   word ptr [bp - 0x26]         ; UNKNOWN
06B428  9A BE 20 65 5F        LCALL  0x5f65, 0x20be               ; UNKNOWN
06B42D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B430  81 7E E2 5A 4D        CMP    word ptr [bp - 0x1e], 0x4d5a ; UNKNOWN
06B435  74 07                 JE     0x6b43e                      ; UNKNOWN
06B437  81 7E E2 4D 5A        CMP    word ptr [bp - 0x1e], 0x5a4d ; UNKNOWN
06B43C  75 03                 JNE    0x6b441                      ; UNKNOWN
06B43E  FF 4E D8              DEC    word ptr [bp - 0x28]         ; UNKNOWN
06B441  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
06B445  74 28                 JE     0x6b46f                      ; UNKNOWN
06B447  2B C0                 SUB    ax, ax                       ; UNKNOWN
06B449  50                    PUSH   ax                           ; UNKNOWN
06B44A  56                    PUSH   si                           ; UNKNOWN
06B44B  8D 86 52 FF           LEA    ax, [bp - 0xae]              ; UNKNOWN
06B44F  50                    PUSH   ax                           ; UNKNOWN
06B450  8D 46 E0              LEA    ax, [bp - 0x20]              ; UNKNOWN
06B453  50                    PUSH   ax                           ; UNKNOWN
06B454  8D 46 D2              LEA    ax, [bp - 0x2e]              ; UNKNOWN
06B457  50                    PUSH   ax                           ; UNKNOWN
06B458  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
06B45B  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
06B45E  9A 7A 2F 65 5F        LCALL  0x5f65, 0x2f7a               ; UNKNOWN
06B463  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
06B466  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
06B469  40                    INC    ax                           ; UNKNOWN
06B46A  75 03                 JNE    0x6b46f                      ; UNKNOWN
06B46C  E9 EF FE              JMP    0x6b35e                      ; UNKNOWN
06B46F  FF 76 D4              PUSH   word ptr [bp - 0x2c]         ; UNKNOWN
06B472  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
06B475  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
06B478  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
06B47B  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
06B47E  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
06B481  B1 05                 MOV    cl, 5                        ; UNKNOWN
06B483  D3 E0                 SHL    ax, cl                       ; UNKNOWN
06B485  2B 46 EA              SUB    ax, word ptr [bp - 0x16]     ; UNKNOWN
06B488  03 46 EC              ADD    ax, word ptr [bp - 0x14]     ; UNKNOWN
06B48B  50                    PUSH   ax                           ; UNKNOWN
06B48C  FF 76 DE              PUSH   word ptr [bp - 0x22]         ; UNKNOWN
06B48F  FF 76 E0              PUSH   word ptr [bp - 0x20]         ; UNKNOWN
06B492  8D 86 52 FF           LEA    ax, [bp - 0xae]              ; UNKNOWN
06B496  50                    PUSH   ax                           ; UNKNOWN
06B497  56                    PUSH   si                           ; UNKNOWN
06B498  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
06B49D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06B4A0  40                    INC    ax                           ; UNKNOWN
06B4A1  50                    PUSH   ax                           ; UNKNOWN
06B4A2  56                    PUSH   si                           ; UNKNOWN
06B4A3  FF 76 D8              PUSH   word ptr [bp - 0x28]         ; UNKNOWN
06B4A6  9A F2 31 65 5F        LCALL  0x5f65, 0x31f2               ; UNKNOWN
06B4AB  83 C4 18              ADD    sp, 0x18                     ; UNKNOWN
06B4AE  E9 F5 FE              JMP    0x6b3a6                      ; UNKNOWN
06B4B1  90                    NOP                                 ; UNKNOWN
06B4B2  5E                    POP    si                           ; UNKNOWN
06B4B3  8B E5                 MOV    sp, bp                       ; UNKNOWN
06B4B5  5D                    POP    bp                           ; UNKNOWN
06B4B6  CB                    RETF                                ; UNKNOWN
