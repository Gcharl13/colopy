; ============================================================================
; func_06A202_unknown
; Region   : load_image
; Bytes    : file 0x06A202..0x06A3C2  (448 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06A202  55                    PUSH   bp                           ; UNKNOWN
06A203  8B EC                 MOV    bp, sp                       ; UNKNOWN
06A205  B8 71 01              MOV    ax, 0x171                    ; UNKNOWN
06A208  0E                    PUSH   cs                           ; UNKNOWN
06A209  E8 DC E6              CALL   0x688e8                      ; UNKNOWN
06A20C  56                    PUSH   si                           ; UNKNOWN
06A20D  57                    PUSH   di                           ; UNKNOWN
06A20E  33 C0                 XOR    ax, ax                       ; UNKNOWN
06A210  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
06A213  88 46 FB              MOV    byte ptr [bp - 5], al        ; UNKNOWN
06A216  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
06A219  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
06A21A  89 76 08              MOV    word ptr [bp + 8], si        ; UNKNOWN
06A21D  88 46 FE              MOV    byte ptr [bp - 2], al        ; UNKNOWN
06A220  0A C0                 OR     al, al                       ; UNKNOWN
06A222  74 06                 JE     0x6a22a                      ; UNKNOWN
06A224  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
06A228  7D 06                 JGE    0x6a230                      ; UNKNOWN
06A22A  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
06A22D  E9 A3 04              JMP    0x6a6d3                      ; UNKNOWN
06A230  BB E0 14              MOV    bx, 0x14e0                   ; UNKNOWN
06A233  2C 20                 SUB    al, 0x20                     ; UNKNOWN
06A235  3C 58                 CMP    al, 0x58                     ; UNKNOWN
06A237  77 05                 JA     0x6a23e                      ; UNKNOWN
06A239  D7                    XLATB                               ; UNKNOWN
06A23A  24 0F                 AND    al, 0xf                      ; UNKNOWN
06A23C  EB 02                 JMP    0x6a240                      ; UNKNOWN
06A23E  B0 00                 MOV    al, 0                        ; UNKNOWN
06A240  B1 03                 MOV    cl, 3                        ; UNKNOWN
06A242  D2 E0                 SHL    al, cl                       ; UNKNOWN
06A244  02 46 FB              ADD    al, byte ptr [bp - 5]        ; UNKNOWN
06A247  D7                    XLATB                               ; UNKNOWN
06A248  FE C1                 INC    cl                           ; UNKNOWN
06A24A  D2 E8                 SHR    al, cl                       ; UNKNOWN
06A24C  88 46 FB              MOV    byte ptr [bp - 5], al        ; UNKNOWN
06A24F  98                    CWDE                                ; UNKNOWN
06A250  8B D8                 MOV    bx, ax                       ; UNKNOWN
06A252  D1 E3                 SHL    bx, 1                        ; UNKNOWN
06A254  2E FF A7 A2 1B        JMP    word ptr cs:[bx + 0x1ba2]    ; UNKNOWN
06A259  8A 56 FE              MOV    dl, byte ptr [bp - 2]        ; UNKNOWN
06A25C  B9 01 00              MOV    cx, 1                        ; UNKNOWN
06A25F  E8 24 04              CALL   0x6a686                      ; UNKNOWN
06A262  EB B2                 JMP    0x6a216                      ; UNKNOWN
06A264  33 C0                 XOR    ax, ax                       ; UNKNOWN
06A266  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
06A269  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
06A26C  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
06A26F  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
06A272  48                    DEC    ax                           ; UNKNOWN
06A273  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
06A276  EB 9E                 JMP    0x6a216                      ; UNKNOWN
06A278  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
06A27B  3C 2D                 CMP    al, 0x2d                     ; UNKNOWN
06A27D  75 06                 JNE    0x6a285                      ; UNKNOWN
06A27F  80 4E FC 04           OR     byte ptr [bp - 4], 4         ; UNKNOWN
06A283  EB 91                 JMP    0x6a216                      ; UNKNOWN
06A285  3C 2B                 CMP    al, 0x2b                     ; UNKNOWN
06A287  75 06                 JNE    0x6a28f                      ; UNKNOWN
06A289  80 4E FC 01           OR     byte ptr [bp - 4], 1         ; UNKNOWN
06A28D  EB 87                 JMP    0x6a216                      ; UNKNOWN
06A28F  3C 20                 CMP    al, 0x20                     ; UNKNOWN
06A291  75 07                 JNE    0x6a29a                      ; UNKNOWN
06A293  80 4E FC 02           OR     byte ptr [bp - 4], 2         ; UNKNOWN
06A297  E9 7C FF              JMP    0x6a216                      ; UNKNOWN
06A29A  3C 23                 CMP    al, 0x23                     ; UNKNOWN
06A29C  75 07                 JNE    0x6a2a5                      ; UNKNOWN
06A29E  80 4E FC 80           OR     byte ptr [bp - 4], 0x80      ; UNKNOWN
06A2A2  E9 71 FF              JMP    0x6a216                      ; UNKNOWN
06A2A5  80 4E FC 08           OR     byte ptr [bp - 4], 8         ; UNKNOWN
06A2A9  E9 6A FF              JMP    0x6a216                      ; UNKNOWN
06A2AC  8A 4E FE              MOV    cl, byte ptr [bp - 2]        ; UNKNOWN
06A2AF  80 F9 2A              CMP    cl, 0x2a                     ; UNKNOWN
06A2B2  75 0F                 JNE    0x6a2c3                      ; UNKNOWN
06A2B4  E8 56 03              CALL   0x6a60d                      ; UNKNOWN
06A2B7  0B C0                 OR     ax, ax                       ; UNKNOWN
06A2B9  79 17                 JNS    0x6a2d2                      ; UNKNOWN
06A2BB  F7 D8                 NEG    ax                           ; UNKNOWN
06A2BD  80 4E FC 04           OR     byte ptr [bp - 4], 4         ; UNKNOWN
06A2C1  EB 0F                 JMP    0x6a2d2                      ; UNKNOWN
06A2C3  80 E9 30              SUB    cl, 0x30                     ; UNKNOWN
06A2C6  32 ED                 XOR    ch, ch                       ; UNKNOWN
06A2C8  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
06A2CB  BB 0A 00              MOV    bx, 0xa                      ; UNKNOWN
06A2CE  F7 E3                 MUL    bx                           ; UNKNOWN
06A2D0  03 C1                 ADD    ax, cx                       ; UNKNOWN
06A2D2  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
06A2D5  E9 3E FF              JMP    0x6a216                      ; UNKNOWN
06A2D8  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; UNKNOWN
06A2DD  E9 36 FF              JMP    0x6a216                      ; UNKNOWN
06A2E0  8A 4E FE              MOV    cl, byte ptr [bp - 2]        ; UNKNOWN
06A2E3  80 F9 2A              CMP    cl, 0x2a                     ; UNKNOWN
06A2E6  75 0C                 JNE    0x6a2f4                      ; UNKNOWN
06A2E8  E8 22 03              CALL   0x6a60d                      ; UNKNOWN
06A2EB  0B C0                 OR     ax, ax                       ; UNKNOWN
06A2ED  79 14                 JNS    0x6a303                      ; UNKNOWN
06A2EF  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
06A2F2  EB 0F                 JMP    0x6a303                      ; UNKNOWN
06A2F4  80 E9 30              SUB    cl, 0x30                     ; UNKNOWN
06A2F7  32 ED                 XOR    ch, ch                       ; UNKNOWN
06A2F9  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
06A2FC  BB 0A 00              MOV    bx, 0xa                      ; UNKNOWN
06A2FF  F7 E3                 MUL    bx                           ; UNKNOWN
06A301  03 C1                 ADD    ax, cx                       ; UNKNOWN
06A303  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
06A306  E9 0D FF              JMP    0x6a216                      ; UNKNOWN
06A309  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
06A30C  3C 6C                 CMP    al, 0x6c                     ; UNKNOWN
06A30E  75 06                 JNE    0x6a316                      ; UNKNOWN
06A310  80 4E FC 10           OR     byte ptr [bp - 4], 0x10      ; UNKNOWN
06A314  EB 22                 JMP    0x6a338                      ; UNKNOWN
06A316  3C 46                 CMP    al, 0x46                     ; UNKNOWN
06A318  75 06                 JNE    0x6a320                      ; UNKNOWN
06A31A  80 4E FC 20           OR     byte ptr [bp - 4], 0x20      ; UNKNOWN
06A31E  EB 18                 JMP    0x6a338                      ; UNKNOWN
06A320  3C 4E                 CMP    al, 0x4e                     ; UNKNOWN
06A322  75 06                 JNE    0x6a32a                      ; UNKNOWN
06A324  80 4E FD 10           OR     byte ptr [bp - 3], 0x10      ; UNKNOWN
06A328  EB 0E                 JMP    0x6a338                      ; UNKNOWN
06A32A  3C 4C                 CMP    al, 0x4c                     ; UNKNOWN
06A32C  75 06                 JNE    0x6a334                      ; UNKNOWN
06A32E  80 4E FD 04           OR     byte ptr [bp - 3], 4         ; UNKNOWN
06A332  EB 04                 JMP    0x6a338                      ; UNKNOWN
06A334  80 4E FD 08           OR     byte ptr [bp - 3], 8         ; UNKNOWN
06A338  E9 DB FE              JMP    0x6a216                      ; UNKNOWN
06A33B  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
06A33E  3C 64                 CMP    al, 0x64                     ; UNKNOWN
06A340  75 03                 JNE    0x6a345                      ; UNKNOWN
06A342  E9 8E 01              JMP    0x6a4d3                      ; UNKNOWN
06A345  3C 69                 CMP    al, 0x69                     ; UNKNOWN
06A347  75 03                 JNE    0x6a34c                      ; UNKNOWN
06A349  E9 87 01              JMP    0x6a4d3                      ; UNKNOWN
06A34C  3C 75                 CMP    al, 0x75                     ; UNKNOWN
06A34E  75 03                 JNE    0x6a353                      ; UNKNOWN
06A350  E9 84 01              JMP    0x6a4d7                      ; UNKNOWN
06A353  3C 58                 CMP    al, 0x58                     ; UNKNOWN
06A355  75 03                 JNE    0x6a35a                      ; UNKNOWN
06A357  E9 83 01              JMP    0x6a4dd                      ; UNKNOWN
06A35A  3C 78                 CMP    al, 0x78                     ; UNKNOWN
06A35C  75 03                 JNE    0x6a361                      ; UNKNOWN
06A35E  E9 82 01              JMP    0x6a4e3                      ; UNKNOWN
06A361  3C 6F                 CMP    al, 0x6f                     ; UNKNOWN
06A363  75 03                 JNE    0x6a368                      ; UNKNOWN
06A365  E9 9C 01              JMP    0x6a504                      ; UNKNOWN
06A368  3C 63                 CMP    al, 0x63                     ; UNKNOWN
06A36A  74 1A                 JE     0x6a386                      ; UNKNOWN
06A36C  3C 73                 CMP    al, 0x73                     ; UNKNOWN
06A36E  74 27                 JE     0x6a397                      ; UNKNOWN
06A370  3C 6E                 CMP    al, 0x6e                     ; UNKNOWN
06A372  74 51                 JE     0x6a3c5                      ; UNKNOWN
06A374  3C 70                 CMP    al, 0x70                     ; UNKNOWN
06A376  74 60                 JE     0x6a3d8                      ; UNKNOWN
06A378  3C 45                 CMP    al, 0x45                     ; UNKNOWN
06A37A  74 07                 JE     0x6a383                      ; UNKNOWN
06A37C  3C 47                 CMP    al, 0x47                     ; UNKNOWN
06A37E  74 03                 JE     0x6a383                      ; UNKNOWN
06A380  E9 BB 00              JMP    0x6a43e                      ; UNKNOWN
06A383  E9 B5 00              JMP    0x6a43b                      ; UNKNOWN
06A386  E8 84 02              CALL   0x6a60d                      ; UNKNOWN
06A389  8D BE 8F FE           LEA    di, [bp - 0x171]             ; UNKNOWN
06A38D  16                    PUSH   ss                           ; UNKNOWN
06A38E  07                    POP    es                           ; UNKNOWN
06A38F  AA                    STOSB  byte ptr es:[di], al         ; UNKNOWN
06A390  4F                    DEC    di                           ; UNKNOWN
06A391  B9 01 00              MOV    cx, 1                        ; UNKNOWN
06A394  E9 EB 01              JMP    0x6a582                      ; UNKNOWN
06A397  E8 87 02              CALL   0x6a621                      ; UNKNOWN
06A39A  0B FF                 OR     di, di                       ; UNKNOWN
06A39C  75 12                 JNE    0x6a3b0                      ; UNKNOWN
06A39E  8C C0                 MOV    ax, es                       ; UNKNOWN
06A3A0  0B C0                 OR     ax, ax                       ; UNKNOWN
06A3A2  75 0C                 JNE    0x6a3b0                      ; UNKNOWN
06A3A4  1E                    PUSH   ds                           ; UNKNOWN
06A3A5  07                    POP    es                           ; UNKNOWN
06A3A6  BF 39 15              MOV    di, 0x1539                   ; UNKNOWN
06A3A9  8B 0E 3F 15           MOV    cx, word ptr [0x153f]        ; UNKNOWN
06A3AD  E9 D2 01              JMP    0x6a582                      ; UNKNOWN
06A3B0  57                    PUSH   di                           ; UNKNOWN
06A3B1  8B 4E F4              MOV    cx, word ptr [bp - 0xc]      ; UNKNOWN
06A3B4  E3 07                 JCXZ   0x6a3bd                      ; UNKNOWN
06A3B6  32 C0                 XOR    al, al                       ; UNKNOWN
06A3B8  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
06A3BA  75 01                 JNE    0x6a3bd                      ; UNKNOWN
06A3BC  4F                    DEC    di                           ; UNKNOWN
06A3BD  59                    POP    cx                           ; UNKNOWN
06A3BE  2B F9                 SUB    di, cx                       ; UNKNOWN
06A3C0  87 CF                 XCHG   di, cx                       ; UNKNOWN
