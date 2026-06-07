; ============================================================================
; func_0462A1_unknown
; Region   : load_image
; Bytes    : file 0x0462A1..0x0463D2  (305 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0462A1  C8 9A 06 00           ENTER  0x69a, 0                     ; UNKNOWN
0462A5  49                    DEC    cx                           ; UNKNOWN
0462A6  22 83 C4 04           AND    al, byte ptr [bp + di + 0x4c4] ; UNKNOWN
0462AA  A8 04                 TEST   al, 4                        ; UNKNOWN
0462AC  75 39                 JNE    0x462e7                      ; UNKNOWN
0462AE  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0462B1  9A 94 01 49 22        LCALL  0x2249, 0x194                ; UNKNOWN
0462B6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0462B9  50                    PUSH   ax                           ; UNKNOWN
0462BA  6A 00                 PUSH   0                            ; UNKNOWN
0462BC  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
0462C1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0462C4  6A 01                 PUSH   1                            ; UNKNOWN
0462C6  68 61 28              PUSH   0x2861                       ; UNKNOWN
0462C9  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
0462CE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0462D1  48                    DEC    ax                           ; UNKNOWN
0462D2  74 03                 JE     0x462d7                      ; UNKNOWN
0462D4  E9 C7 08              JMP    0x46b9e                      ; UNKNOWN
0462D7  6A 04                 PUSH   4                            ; UNKNOWN
0462D9  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0462DC  FF 76 C8              PUSH   word ptr [bp - 0x38]         ; UNKNOWN
0462DF  9A 65 00 49 22        LCALL  0x2249, 0x65                 ; UNKNOWN
0462E4  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0462E7  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
0462EA  2A E4                 SUB    ah, ah                       ; UNKNOWN
0462EC  83 C0 05              ADD    ax, 5                        ; UNKNOWN
0462EF  89 46 CC              MOV    word ptr [bp - 0x34], ax     ; UNKNOWN
0462F2  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0462F5  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0462F8  9A 03 03 D2 14        LCALL  0x14d2, 0x303                ; UNKNOWN
0462FD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
046300  0B C0                 OR     ax, ax                       ; UNKNOWN
046302  7C 32                 JL     0x46336                      ; UNKNOWN
046304  50                    PUSH   ax                           ; UNKNOWN
046305  9A 32 00 BA 33        LCALL  0x33ba, 0x32                 ; UNKNOWN
04630A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04630D  D1 66 CC              SHL    word ptr [bp - 0x34], 1      ; UNKNOWN
046310  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
046314  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
046318  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
04631B  8B F0                 MOV    si, ax                       ; UNKNOWN
04631D  D1 E6                 SHL    si, 1                        ; UNKNOWN
04631F  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
046323  80 40 0B 01           ADD    byte ptr [bx + si + 0xb], 1  ; UNKNOWN
046327  F6 47 03 04           TEST   byte ptr [bx + 3], 4         ; UNKNOWN
04632B  74 09                 JE     0x46336                      ; UNKNOWN
04632D  B8 03 00              MOV    ax, 3                        ; UNKNOWN
046330  F7 6E CC              IMUL   word ptr [bp - 0x34]         ; UNKNOWN
046333  89 46 CC              MOV    word ptr [bp - 0x34], ax     ; UNKNOWN
046336  6A 00                 PUSH   0                            ; UNKNOWN
046338  FF 76 CC              PUSH   word ptr [bp - 0x34]         ; UNKNOWN
04633B  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04633F  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
046343  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
046346  50                    PUSH   ax                           ; UNKNOWN
046347  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
04634B  9A F6 00 D2 14        LCALL  0x14d2, 0xf6                 ; UNKNOWN
046350  83 C4 08              ADD    sp, 8                        ; UNKNOWN
046353  E9 45 02              JMP    0x4659b                      ; UNKNOWN
046356  83 7E C8 04           CMP    word ptr [bp - 0x38], 4      ; UNKNOWN
04635A  7D 0E                 JGE    0x4636a                      ; UNKNOWN
04635C  6B 5E FA 1C           IMUL   bx, word ptr [bp - 6], 0x1c  ; UNKNOWN
046360  80 BF 82 88 10        CMP    byte ptr [bx - 0x777e], 0x10 ; UNKNOWN
046365  75 03                 JNE    0x4636a                      ; UNKNOWN
046367  E9 31 02              JMP    0x4659b                      ; UNKNOWN
04636A  83 7E C8 04           CMP    word ptr [bp - 0x38], 4      ; UNKNOWN
04636E  7D 61                 JGE    0x463d1                      ; UNKNOWN
046370  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
046374  80 BF 82 88 10        CMP    byte ptr [bx - 0x777e], 0x10 ; UNKNOWN
046379  75 56                 JNE    0x463d1                      ; UNKNOWN
04637B  69 76 FE 3C 01        IMUL   si, word ptr [bp - 2], 0x13c ; UNKNOWN
046380  8B 5E C8              MOV    bx, word ptr [bp - 0x38]     ; UNKNOWN
046383  80 88 DE 74 80        OR     byte ptr [bx + si + 0x74de], 0x80 ; UNKNOWN
046388  6A 64                 PUSH   0x64                         ; UNKNOWN
04638A  6A 00                 PUSH   0                            ; UNKNOWN
04638C  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
046391  83 C4 04              ADD    sp, 4                        ; UNKNOWN
046394  8A 0E 1E 3E           MOV    cl, byte ptr [0x3e1e]        ; UNKNOWN
046398  2A ED                 SUB    ch, ch                       ; UNKNOWN
04639A  41                    INC    cx                           ; UNKNOWN
04639B  3B C1                 CMP    ax, cx                       ; UNKNOWN
04639D  7C 03                 JL     0x463a2                      ; UNKNOWN
04639F  E9 F9 01              JMP    0x4659b                      ; UNKNOWN
0463A2  8B 5E C8              MOV    bx, word ptr [bp - 0x38]     ; UNKNOWN
0463A5  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0463A7  8B 87 C6 86           MOV    ax, word ptr [bx - 0x793a]   ; UNKNOWN
0463AB  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
0463AE  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0463B0  39 87 C6 86           CMP    word ptr [bx - 0x793a], ax   ; UNKNOWN
0463B4  72 0B                 JB     0x463c1                      ; UNKNOWN
0463B6  8B 5E C8              MOV    bx, word ptr [bp - 0x38]     ; UNKNOWN
0463B9  80 88 DE 74 08        OR     byte ptr [bx + si + 0x74de], 8 ; UNKNOWN
0463BE  E9 DA 01              JMP    0x4659b                      ; UNKNOWN
0463C1  69 76 FE 3C 01        IMUL   si, word ptr [bp - 2], 0x13c ; UNKNOWN
0463C6  8B 5E C8              MOV    bx, word ptr [bp - 0x38]     ; UNKNOWN
0463C9  80 88 DE 74 02        OR     byte ptr [bx + si + 0x74de], 2 ; UNKNOWN
0463CE  E9 CA 01              JMP    0x4659b                      ; UNKNOWN
0463D1  83                    DB     0x83                         ; UNKNOWN (raw)
