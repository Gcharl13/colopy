; ============================================================================
; func_02F2F8_unknown
; Region   : load_image
; Bytes    : file 0x02F2F8..0x02F4F7  (511 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02F2F8  C8 1C 00 00           ENTER  0x1c, 0                      ; UNKNOWN
02F2FC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02F2FF  0E                    PUSH   cs                           ; UNKNOWN
02F300  E8 E4 F0              CALL   0x2e3e7                      ; UNKNOWN
02F303  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02F306  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
02F309  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02F30C  0E                    PUSH   cs                           ; UNKNOWN
02F30D  E8 10 F1              CALL   0x2e420                      ; UNKNOWN
02F310  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02F313  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
02F316  3B 46 EA              CMP    ax, word ptr [bp - 0x16]     ; UNKNOWN
02F319  75 05                 JNE    0x2f320                      ; UNKNOWN
02F31B  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02F31E  EB 02                 JMP    0x2f322                      ; UNKNOWN
02F320  2B C0                 SUB    ax, ax                       ; UNKNOWN
02F322  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
02F325  0E                    PUSH   cs                           ; UNKNOWN
02F326  E8 38 E5              CALL   0x2d861                      ; UNKNOWN
02F329  B9 64 00              MOV    cx, 0x64                     ; UNKNOWN
02F32C  2B C8                 SUB    cx, ax                       ; UNKNOWN
02F32E  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F332  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02F335  98                    CWDE                                ; UNKNOWN
02F336  F7 E9                 IMUL   cx                           ; UNKNOWN
02F338  83 C0 32              ADD    ax, 0x32                     ; UNKNOWN
02F33B  B9 64 00              MOV    cx, 0x64                     ; UNKNOWN
02F33E  99                    CDQ                                 ; UNKNOWN
02F33F  F7 F9                 IDIV   cx                           ; UNKNOWN
02F341  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
02F344  80 7F 1A 04           CMP    byte ptr [bx + 0x1a], 4      ; UNKNOWN
02F348  73 1B                 JAE    0x2f365                      ; UNKNOWN
02F34A  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
02F34D  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F34F  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
02F352  38 A7 B7 C0           CMP    byte ptr [bx - 0x3f49], ah   ; UNKNOWN
02F356  75 0D                 JNE    0x2f365                      ; UNKNOWN
02F358  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
02F35B  83 E8 0A              SUB    ax, 0xa                      ; UNKNOWN
02F35E  F7 D8                 NEG    ax                           ; UNKNOWN
02F360  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
02F363  EB 05                 JMP    0x2f36a                      ; UNKNOWN
02F365  C7 46 F6 0A 00        MOV    word ptr [bp - 0xa], 0xa     ; UNKNOWN
02F36A  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F36E  80 7F 1A 04           CMP    byte ptr [bx + 0x1a], 4      ; UNKNOWN
02F372  73 0E                 JAE    0x2f382                      ; UNKNOWN
02F374  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
02F377  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F379  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
02F37C  38 A7 B7 C0           CMP    byte ptr [bx - 0x3f49], ah   ; UNKNOWN
02F380  74 05                 JE     0x2f387                      ; UNKNOWN
02F382  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
02F387  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
02F38A  99                    CDQ                                 ; UNKNOWN
02F38B  F7 7E F6              IDIV   word ptr [bp - 0xa]          ; UNKNOWN
02F38E  F7 D8                 NEG    ax                           ; UNKNOWN
02F390  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
02F393  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F397  F6 47 1C 04           TEST   byte ptr [bx + 0x1c], 4      ; UNKNOWN
02F39B  74 04                 JE     0x2f3a1                      ; UNKNOWN
02F39D  40                    INC    ax                           ; UNKNOWN
02F39E  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
02F3A1  F6 47 1C 02           TEST   byte ptr [bx + 0x1c], 2      ; UNKNOWN
02F3A5  74 03                 JE     0x2f3aa                      ; UNKNOWN
02F3A7  FF 46 F2              INC    word ptr [bp - 0xe]          ; UNKNOWN
02F3AA  83 7E E4 01           CMP    word ptr [bp - 0x1c], 1      ; UNKNOWN
02F3AE  1B C0                 SBB    ax, ax                       ; UNKNOWN
02F3B0  24 FE                 AND    al, 0xfe                     ; UNKNOWN
02F3B2  83 C0 03              ADD    ax, 3                        ; UNKNOWN
02F3B5  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02F3B8  C7 46 E8 FF FF        MOV    word ptr [bp - 0x18], 0xffff ; UNKNOWN
02F3BD  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
02F3C0  0E                    PUSH   cs                           ; UNKNOWN
02F3C1  E8 03 ED              CALL   0x2e0c7                      ; UNKNOWN
02F3C4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02F3C7  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02F3CA  50                    PUSH   ax                           ; UNKNOWN
02F3CB  0E                    PUSH   cs                           ; UNKNOWN
02F3CC  E8 4C E6              CALL   0x2da1b                      ; UNKNOWN
02F3CF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02F3D2  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
02F3D5  83 E8 19              SUB    ax, 0x19                     ; UNKNOWN
02F3D8  74 18                 JE     0x2f3f2                      ; UNKNOWN
02F3DA  48                    DEC    ax                           ; UNKNOWN
02F3DB  7C 03                 JL     0x2f3e0                      ; UNKNOWN
02F3DD  48                    DEC    ax                           ; UNKNOWN
02F3DE  7E 07                 JLE    0x2f3e7                      ; UNKNOWN
02F3E0  C7 46 EE 03 00        MOV    word ptr [bp - 0x12], 3      ; UNKNOWN
02F3E5  EB 05                 JMP    0x2f3ec                      ; UNKNOWN
02F3E7  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; UNKNOWN
02F3EC  8B 46 EA              MOV    ax, word ptr [bp - 0x16]     ; UNKNOWN
02F3EF  E9 E4 00              JMP    0x2f4d6                      ; UNKNOWN
02F3F2  C7 46 EE 02 00        MOV    word ptr [bp - 0x12], 2      ; UNKNOWN
02F3F7  EB F3                 JMP    0x2f3ec                      ; UNKNOWN
02F3F9  C7 46 E8 10 00        MOV    word ptr [bp - 0x18], 0x10   ; UNKNOWN
02F3FE  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0      ; UNKNOWN
02F402  74 05                 JE     0x2f409                      ; UNKNOWN
02F404  B8 06 00              MOV    ax, 6                        ; UNKNOWN
02F407  EB 03                 JMP    0x2f40c                      ; UNKNOWN
02F409  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
02F40C  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02F40F  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
02F412  01 46 FA              ADD    word ptr [bp - 6], ax        ; UNKNOWN
02F415  6A 24                 PUSH   0x24                         ; UNKNOWN
02F417  0E                    PUSH   cs                           ; UNKNOWN
02F418  E8 5D E5              CALL   0x2d978                      ; UNKNOWN
02F41B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02F41E  0B C0                 OR     ax, ax                       ; UNKNOWN
02F420  75 03                 JNE    0x2f425                      ; UNKNOWN
02F422  E9 D3 00              JMP    0x2f4f8                      ; UNKNOWN
02F425  D1 66 FA              SHL    word ptr [bp - 6], 1         ; UNKNOWN
02F428  E9 CD 00              JMP    0x2f4f8                      ; UNKNOWN
02F42B  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0      ; UNKNOWN
02F42F  74 05                 JE     0x2f436                      ; UNKNOWN
02F431  B8 06 00              MOV    ax, 6                        ; UNKNOWN
02F434  EB 03                 JMP    0x2f439                      ; UNKNOWN
02F436  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
02F439  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02F43C  C7 46 E8 11 00        MOV    word ptr [bp - 0x18], 0x11   ; UNKNOWN
02F441  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
02F444  01 46 FA              ADD    word ptr [bp - 6], ax        ; UNKNOWN
02F447  6A 26                 PUSH   0x26                         ; UNKNOWN
02F449  0E                    PUSH   cs                           ; UNKNOWN
02F44A  E8 2B E5              CALL   0x2d978                      ; UNKNOWN
02F44D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02F450  0B C0                 OR     ax, ax                       ; UNKNOWN
02F452  74 03                 JE     0x2f457                      ; UNKNOWN
02F454  D1 66 FA              SHL    word ptr [bp - 6], 1         ; UNKNOWN
02F457  6A 15                 PUSH   0x15                         ; UNKNOWN
02F459  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F45D  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
02F460  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F462  50                    PUSH   ax                           ; UNKNOWN
02F463  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
02F468  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F46B  0B C0                 OR     ax, ax                       ; UNKNOWN
02F46D  75 03                 JNE    0x2f472                      ; UNKNOWN
02F46F  E9 86 00              JMP    0x2f4f8                      ; UNKNOWN
02F472  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02F475  D1 F8                 SAR    ax, 1                        ; UNKNOWN
02F477  01 46 FA              ADD    word ptr [bp - 6], ax        ; UNKNOWN
02F47A  EB 7C                 JMP    0x2f4f8                      ; UNKNOWN
02F47C  8B 46 EA              MOV    ax, word ptr [bp - 0x16]     ; UNKNOWN
02F47F  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
02F482  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
02F485  03 46 F2              ADD    ax, word ptr [bp - 0xe]      ; UNKNOWN
02F488  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02F48B  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02F48E  0E                    PUSH   cs                           ; UNKNOWN
02F48F  E8 F6 E4              CALL   0x2d988                      ; UNKNOWN
02F492  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02F495  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
02F498  83 F8 01              CMP    ax, 1                        ; UNKNOWN
02F49B  7E 09                 JLE    0x2f4a6                      ; UNKNOWN
02F49D  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02F4A0  03 46 EE              ADD    ax, word ptr [bp - 0x12]     ; UNKNOWN
02F4A3  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02F4A6  83 7E F4 02           CMP    word ptr [bp - 0xc], 2       ; UNKNOWN
02F4AA  7E 08                 JLE    0x2f4b4                      ; UNKNOWN
02F4AC  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02F4AF  D1 F8                 SAR    ax, 1                        ; UNKNOWN
02F4B1  01 46 FA              ADD    word ptr [bp - 6], ax        ; UNKNOWN
02F4B4  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0      ; UNKNOWN
02F4B8  E9 65 FF              JMP    0x2f420                      ; UNKNOWN
02F4BB  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
02F4BE  03 46 F2              ADD    ax, word ptr [bp - 0xe]      ; UNKNOWN
02F4C1  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02F4C4  C7 46 E8 12 00        MOV    word ptr [bp - 0x18], 0x12   ; UNKNOWN
02F4C9  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0      ; UNKNOWN
02F4CD  74 29                 JE     0x2f4f8                      ; UNKNOWN
02F4CF  D1 E0                 SHL    ax, 1                        ; UNKNOWN
02F4D1  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02F4D4  EB 22                 JMP    0x2f4f8                      ; UNKNOWN
02F4D6  83 E8 09              SUB    ax, 9                        ; UNKNOWN
02F4D9  83 F8 08              CMP    ax, 8                        ; UNKNOWN
02F4DC  77 1A                 JA     0x2f4f8                      ; UNKNOWN
02F4DE  D1 E0                 SHL    ax, 1                        ; UNKNOWN
02F4E0  93                    XCHG   bx, ax                       ; UNKNOWN
02F4E1  2E FF A7 F6 1E        JMP    word ptr cs:[bx + 0x1ef6]    ; UNKNOWN
02F4E6  8C 1E 8C 1E           MOV    word ptr [0x1e8c], ds        ; UNKNOWN
02F4EA  8C 1E 8C 1E           MOV    word ptr [0x1e8c], ds        ; UNKNOWN
02F4EE  09 1E 8C 1E           OR     word ptr [0x1e8c], bx        ; UNKNOWN
02F4F2  8C 1E 3B 1E           MOV    word ptr [0x1e3b], ds        ; UNKNOWN
02F4F6  CB                    RETF                                ; UNKNOWN
