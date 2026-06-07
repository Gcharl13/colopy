; ============================================================================
; func_04F786_unknown
; Region   : load_image
; Bytes    : file 0x04F786..0x04F9A5  (543 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04F786  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
04F78A  57                    PUSH   di                           ; UNKNOWN
04F78B  56                    PUSH   si                           ; UNKNOWN
04F78C  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
04F791  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
04F796  6A E0                 PUSH   -0x20                        ; UNKNOWN
04F798  6A E4                 PUSH   -0x1c                        ; UNKNOWN
04F79A  0E                    PUSH   cs                           ; UNKNOWN
04F79B  E8 04 FD              CALL   0x4f4a2                      ; UNKNOWN
04F79E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F7A1  6A E4                 PUSH   -0x1c                        ; UNKNOWN
04F7A3  6A E8                 PUSH   -0x18                        ; UNKNOWN
04F7A5  0E                    PUSH   cs                           ; UNKNOWN
04F7A6  E8 F9 FC              CALL   0x4f4a2                      ; UNKNOWN
04F7A9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F7AC  A1 0C 3E              MOV    ax, word ptr [0x3e0c]        ; UNKNOWN
04F7AF  83 E8 10              SUB    ax, 0x10                     ; UNKNOWN
04F7B2  8B D0                 MOV    dx, ax                       ; UNKNOWN
04F7B4  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
04F7B9  EB 4E                 JMP    0x4f809                      ; UNKNOWN
04F7BB  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
04F7BE  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
04F7C3  72 3C                 JB     0x4f801                      ; UNKNOWN
04F7C5  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
04F7CA  77 35                 JA     0x4f801                      ; UNKNOWN
04F7CC  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
04F7D0  7D 2F                 JGE    0x4f801                      ; UNKNOWN
04F7D2  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
04F7D5  39 06 0C 3E           CMP    word ptr [0x3e0c], ax        ; UNKNOWN
04F7D9  75 26                 JNE    0x4f801                      ; UNKNOWN
04F7DB  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
04F7DE  8B F3                 MOV    si, bx                       ; UNKNOWN
04F7E0  9A B0 05 0B 38        LCALL  0x380b, 0x5b0                ; UNKNOWN
04F7E5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F7E8  80 BC 88 88 02        CMP    byte ptr [si - 0x7778], 2    ; UNKNOWN
04F7ED  74 12                 JE     0x4f801                      ; UNKNOWN
04F7EF  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
04F7F2  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04F7F5  80 BC 8C 88 00        CMP    byte ptr [si - 0x7774], 0    ; UNKNOWN
04F7FA  74 05                 JE     0x4f801                      ; UNKNOWN
04F7FC  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1         ; UNKNOWN
04F801  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
04F804  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
04F809  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
04F80C  0B C0                 OR     ax, ax                       ; UNKNOWN
04F80E  7D AB                 JGE    0x4f7bb                      ; UNKNOWN
04F810  6A EC                 PUSH   -0x14                        ; UNKNOWN
04F812  6A F0                 PUSH   -0x10                        ; UNKNOWN
04F814  0E                    PUSH   cs                           ; UNKNOWN
04F815  E8 8A FC              CALL   0x4f4a2                      ; UNKNOWN
04F818  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F81B  6A F0                 PUSH   -0x10                        ; UNKNOWN
04F81D  6A F4                 PUSH   -0xc                         ; UNKNOWN
04F81F  0E                    PUSH   cs                           ; UNKNOWN
04F820  E8 7F FC              CALL   0x4f4a2                      ; UNKNOWN
04F823  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F826  A1 0C 3E              MOV    ax, word ptr [0x3e0c]        ; UNKNOWN
04F829  83 E8 14              SUB    ax, 0x14                     ; UNKNOWN
04F82C  8B D0                 MOV    dx, ax                       ; UNKNOWN
04F82E  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
04F833  E9 28 01              JMP    0x4f95e                      ; UNKNOWN
04F836  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
04F83B  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
04F83E  6B 5E F4 1C           IMUL   bx, word ptr [bp - 0xc], 0x1c ; UNKNOWN
04F842  80 BF 82 88 0A        CMP    byte ptr [bx - 0x777e], 0xa  ; UNKNOWN
04F847  74 03                 JE     0x4f84c                      ; UNKNOWN
04F849  E9 0F 01              JMP    0x4f95b                      ; UNKNOWN
04F84C  B0 64                 MOV    al, 0x64                     ; UNKNOWN
04F84E  F6 A7 97 88           MUL    byte ptr [bx - 0x7769]       ; UNKNOWN
04F852  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
04F855  6A 00                 PUSH   0                            ; UNKNOWN
04F857  50                    PUSH   ax                           ; UNKNOWN
04F858  6A 00                 PUSH   0                            ; UNKNOWN
04F85A  8B F3                 MOV    si, bx                       ; UNKNOWN
04F85C  9A 24 04 97 1B        LCALL  0x1b97, 0x424                ; UNKNOWN
04F861  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04F864  6A 00                 PUSH   0                            ; UNKNOWN
04F866  6A 64                 PUSH   0x64                         ; UNKNOWN
04F868  6A 00                 PUSH   0                            ; UNKNOWN
04F86A  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
04F86D  69 1E 0C 3E 3C 01     IMUL   bx, word ptr [0x3e0c], 0x13c ; UNKNOWN
04F873  8A 87 AB 74           MOV    al, byte ptr [bx + 0x74ab]   ; UNKNOWN
04F877  3C 32                 CMP    al, 0x32                     ; UNKNOWN
04F879  7E 02                 JLE    0x4f87d                      ; UNKNOWN
04F87B  B0 32                 MOV    al, 0x32                     ; UNKNOWN
04F87D  98                    CWDE                                ; UNKNOWN
04F87E  99                    CDQ                                 ; UNKNOWN
04F87F  52                    PUSH   dx                           ; UNKNOWN
04F880  50                    PUSH   ax                           ; UNKNOWN
04F881  8B F8                 MOV    di, ax                       ; UNKNOWN
04F883  89 7E EC              MOV    word ptr [bp - 0x14], di     ; UNKNOWN
04F886  89 56 EE              MOV    word ptr [bp - 0x12], dx     ; UNKNOWN
04F889  9A 6C 12 65 5F        LCALL  0x5f65, 0x126c               ; UNKNOWN
04F88E  52                    PUSH   dx                           ; UNKNOWN
04F88F  50                    PUSH   ax                           ; UNKNOWN
04F890  9A D2 11 65 5F        LCALL  0x5f65, 0x11d2               ; UNKNOWN
04F895  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
04F898  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
04F89B  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
04F89E  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
04F8A1  6A 01                 PUSH   1                            ; UNKNOWN
04F8A3  9A 24 04 97 1B        LCALL  0x1b97, 0x424                ; UNKNOWN
04F8A8  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04F8AB  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
04F8AE  29 46 F2              SUB    word ptr [bp - 0xe], ax      ; UNKNOWN
04F8B1  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
04F8B4  2B D2                 SUB    dx, dx                       ; UNKNOWN
04F8B6  52                    PUSH   dx                           ; UNKNOWN
04F8B7  50                    PUSH   ax                           ; UNKNOWN
04F8B8  6A 02                 PUSH   2                            ; UNKNOWN
04F8BA  8B F8                 MOV    di, ax                       ; UNKNOWN
04F8BC  89 7E E8              MOV    word ptr [bp - 0x18], di     ; UNKNOWN
04F8BF  89 56 EA              MOV    word ptr [bp - 0x16], dx     ; UNKNOWN
04F8C2  9A 24 04 97 1B        LCALL  0x1b97, 0x424                ; UNKNOWN
04F8C7  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04F8CA  8A 84 83 88           MOV    al, byte ptr [si - 0x777d]   ; UNKNOWN
04F8CE  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
04F8D1  50                    PUSH   ax                           ; UNKNOWN
04F8D2  9A D9 01 49 22        LCALL  0x2249, 0x1d9                ; UNKNOWN
04F8D7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F8DA  50                    PUSH   ax                           ; UNKNOWN
04F8DB  6A 00                 PUSH   0                            ; UNKNOWN
04F8DD  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
04F8E2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F8E5  8A 9C 83 88           MOV    bl, byte ptr [si - 0x777d]   ; UNKNOWN
04F8E9  83 E3 0F              AND    bx, 0xf                      ; UNKNOWN
04F8EC  D1 E3                 SHL    bx, 1                        ; UNKNOWN
04F8EE  FF B7 E1 37           PUSH   word ptr [bx + 0x37e1]       ; UNKNOWN
04F8F2  6A 01                 PUSH   1                            ; UNKNOWN
04F8F4  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
04F8F9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F8FC  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
04F8FF  8B 56 EA              MOV    dx, word ptr [bp - 0x16]     ; UNKNOWN
04F902  69 1E 0C 3E 3C 01     IMUL   bx, word ptr [0x3e0c], 0x13c ; UNKNOWN
04F908  01 87 D4 74           ADD    word ptr [bx + 0x74d4], ax   ; UNKNOWN
04F90C  11 97 D6 74           ADC    word ptr [bx + 0x74d6], dx   ; UNKNOWN
04F910  01 87 D0 74           ADD    word ptr [bx + 0x74d0], ax   ; UNKNOWN
04F914  11 97 D2 74           ADC    word ptr [bx + 0x74d2], dx   ; UNKNOWN
04F918  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
04F91B  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
04F91E  01 87 CC 74           ADD    word ptr [bx + 0x74cc], ax   ; UNKNOWN
04F922  11 97 CE 74           ADC    word ptr [bx + 0x74ce], dx   ; UNKNOWN
04F926  6A 24                 PUSH   0x24                         ; UNKNOWN
04F928  9A C8 02 28 1A        LCALL  0x1a28, 0x2c8                ; UNKNOWN
04F92D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F930  6A 02                 PUSH   2                            ; UNKNOWN
04F932  68 74 2A              PUSH   0x2a74                       ; UNKNOWN
04F935  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
04F93A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F93D  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
04F940  9A 1C 08 B7 36        LCALL  0x36b7, 0x81c                ; UNKNOWN
04F945  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F948  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
04F94B  39 46 F0              CMP    word ptr [bp - 0x10], ax     ; UNKNOWN
04F94E  7E 03                 JLE    0x4f953                      ; UNKNOWN
04F950  FF 4E F0              DEC    word ptr [bp - 0x10]         ; UNKNOWN
04F953  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
04F956  7E 03                 JLE    0x4f95b                      ; UNKNOWN
04F958  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
04F95B  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
04F95E  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
04F961  0B C0                 OR     ax, ax                       ; UNKNOWN
04F963  7C 03                 JL     0x4f968                      ; UNKNOWN
04F965  E9 CE FE              JMP    0x4f836                      ; UNKNOWN
04F968  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
04F96C  7C 2F                 JL     0x4f99d                      ; UNKNOWN
04F96E  83 3E 0C 3E 04        CMP    word ptr [0x3e0c], 4         ; UNKNOWN
04F973  7D 28                 JGE    0x4f99d                      ; UNKNOWN
04F975  6B 1E 0C 3E 34        IMUL   bx, word ptr [0x3e0c], 0x34  ; UNKNOWN
04F97A  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
04F97F  75 1C                 JNE    0x4f99d                      ; UNKNOWN
04F981  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
04F985  74 0A                 JE     0x4f991                      ; UNKNOWN
04F987  6A 09                 PUSH   9                            ; UNKNOWN
04F989  9A 64 00 9A 46        LCALL  0x469a, 0x64                 ; UNKNOWN
04F98E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F991  C7 06 E2 0B 01 00     MOV    word ptr [0xbe2], 1          ; UNKNOWN
04F997  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04F99A  A3 E4 0B              MOV    word ptr [0xbe4], ax         ; UNKNOWN
04F99D  0E                    PUSH   cs                           ; UNKNOWN
04F99E  E8 7A FD              CALL   0x4f71b                      ; UNKNOWN
04F9A1  5E                    POP    si                           ; UNKNOWN
04F9A2  5F                    POP    di                           ; UNKNOWN
04F9A3  C9                    LEAVE                               ; UNKNOWN
04F9A4  CB                    RETF                                ; UNKNOWN
