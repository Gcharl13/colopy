; ============================================================================
; func_01D051_unknown
; Region   : load_image
; Bytes    : file 0x01D051..0x01D136  (229 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01D051  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
01D055  56                    PUSH   si                           ; UNKNOWN
01D056  C7 46 F2 01 00        MOV    word ptr [bp - 0xe], 1       ; UNKNOWN
01D05B  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
01D05E  83 F8 4E              CMP    ax, 0x4e                     ; UNKNOWN
01D061  75 03                 JNE    0x1d066                      ; UNKNOWN
01D063  E9 EB 02              JMP    0x1d351                      ; UNKNOWN
01D066  7E 03                 JLE    0x1d06b                      ; UNKNOWN
01D068  E9 21 04              JMP    0x1d48c                      ; UNKNOWN
01D06B  83 F8 4D              CMP    ax, 0x4d                     ; UNKNOWN
01D06E  75 03                 JNE    0x1d073                      ; UNKNOWN
01D070  E9 B7 02              JMP    0x1d32a                      ; UNKNOWN
01D073  76 03                 JBE    0x1d078                      ; UNKNOWN
01D075  E9 38 04              JMP    0x1d4b0                      ; UNKNOWN
01D078  3C 2D                 CMP    al, 0x2d                     ; UNKNOWN
01D07A  75 03                 JNE    0x1d07f                      ; UNKNOWN
01D07C  E9 03 03              JMP    0x1d382                      ; UNKNOWN
01D07F  7E 03                 JLE    0x1d084                      ; UNKNOWN
01D081  E9 C1 03              JMP    0x1d445                      ; UNKNOWN
01D084  2C 09                 SUB    al, 9                        ; UNKNOWN
01D086  75 03                 JNE    0x1d08b                      ; UNKNOWN
01D088  E9 35 02              JMP    0x1d2c0                      ; UNKNOWN
01D08B  2C 12                 SUB    al, 0x12                     ; UNKNOWN
01D08D  74 0A                 JE     0x1d099                      ; UNKNOWN
01D08F  2C 10                 SUB    al, 0x10                     ; UNKNOWN
01D091  75 03                 JNE    0x1d096                      ; UNKNOWN
01D093  E9 1E 03              JMP    0x1d3b4                      ; UNKNOWN
01D096  E9 17 04              JMP    0x1d4b0                      ; UNKNOWN
01D099  2B C0                 SUB    ax, ax                       ; UNKNOWN
01D09B  A3 0C 09              MOV    word ptr [0x90c], ax         ; UNKNOWN
01D09E  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
01D0A1  F6 06 FB 3D 20        TEST   byte ptr [0x3dfb], 0x20      ; UNKNOWN
01D0A6  75 03                 JNE    0x1d0ab                      ; UNKNOWN
01D0A8  E9 74 04              JMP    0x1d51f                      ; UNKNOWN
01D0AB  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
01D0AE  83 F8 74              CMP    ax, 0x74                     ; UNKNOWN
01D0B1  75 03                 JNE    0x1d0b6                      ; UNKNOWN
01D0B3  E9 38 04              JMP    0x1d4ee                      ; UNKNOWN
01D0B6  76 03                 JBE    0x1d0bb                      ; UNKNOWN
01D0B8  E9 64 04              JMP    0x1d51f                      ; UNKNOWN
01D0BB  3C 53                 CMP    al, 0x53                     ; UNKNOWN
01D0BD  75 03                 JNE    0x1d0c2                      ; UNKNOWN
01D0BF  E9 8E 04              JMP    0x1d550                      ; UNKNOWN
01D0C2  7E 03                 JLE    0x1d0c7                      ; UNKNOWN
01D0C4  E9 64 05              JMP    0x1d62b                      ; UNKNOWN
01D0C7  2C 20                 SUB    al, 0x20                     ; UNKNOWN
01D0C9  75 03                 JNE    0x1d0ce                      ; UNKNOWN
01D0CB  E9 4E 05              JMP    0x1d61c                      ; UNKNOWN
01D0CE  FE C8                 DEC    al                           ; UNKNOWN
01D0D0  75 03                 JNE    0x1d0d5                      ; UNKNOWN
01D0D2  E9 DE 04              JMP    0x1d5b3                      ; UNKNOWN
01D0D5  2C 03                 SUB    al, 3                        ; UNKNOWN
01D0D7  75 03                 JNE    0x1d0dc                      ; UNKNOWN
01D0D9  E9 87 04              JMP    0x1d563                      ; UNKNOWN
01D0DC  FE C8                 DEC    al                           ; UNKNOWN
01D0DE  75 03                 JNE    0x1d0e3                      ; UNKNOWN
01D0E0  E9 9E 04              JMP    0x1d581                      ; UNKNOWN
01D0E3  E9 39 04              JMP    0x1d51f                      ; UNKNOWN
01D0E6  A1 FB 08              MOV    ax, word ptr [0x8fb]         ; UNKNOWN
01D0E9  0B C0                 OR     ax, ax                       ; UNKNOWN
01D0EB  74 16                 JE     0x1d103                      ; UNKNOWN
01D0ED  48                    DEC    ax                           ; UNKNOWN
01D0EE  74 60                 JE     0x1d150                      ; UNKNOWN
01D0F0  48                    DEC    ax                           ; UNKNOWN
01D0F1  75 02                 JNE    0x1d0f5                      ; UNKNOWN
01D0F3  EB 7E                 JMP    0x1d173                      ; UNKNOWN
01D0F5  48                    DEC    ax                           ; UNKNOWN
01D0F6  75 03                 JNE    0x1d0fb                      ; UNKNOWN
01D0F8  E9 8D 00              JMP    0x1d188                      ; UNKNOWN
01D0FB  48                    DEC    ax                           ; UNKNOWN
01D0FC  75 03                 JNE    0x1d101                      ; UNKNOWN
01D0FE  E9 AE 00              JMP    0x1d1af                      ; UNKNOWN
01D101  EB 46                 JMP    0x1d149                      ; UNKNOWN
01D103  A1 FF 08              MOV    ax, word ptr [0x8ff]         ; UNKNOWN
01D106  8B D8                 MOV    bx, ax                       ; UNKNOWN
01D108  8B 36 FD 08           MOV    si, word ptr [0x8fd]         ; UNKNOWN
01D10C  89 76 F8              MOV    word ptr [bp - 8], si        ; UNKNOWN
01D10F  8B CE                 MOV    cx, si                       ; UNKNOWN
01D111  C1 E6 02              SHL    si, 2                        ; UNKNOWN
01D114  03 F1                 ADD    si, cx                       ; UNKNOWN
01D116  80 B8 B0 73 10        CMP    byte ptr [bx + si + 0x73b0], 0x10 ; UNKNOWN
01D11B  74 2C                 JE     0x1d149                      ; UNKNOWN
01D11D  8B 36 38 73           MOV    si, word ptr [0x7338]        ; UNKNOWN
01D121  8A 0C                 MOV    cl, byte ptr [si]            ; UNKNOWN
01D123  2A ED                 SUB    ch, ch                       ; UNKNOWN
01D125  03 4E F8              ADD    cx, word ptr [bp - 8]        ; UNKNOWN
01D128  49                    DEC    cx                           ; UNKNOWN
01D129  49                    DEC    cx                           ; UNKNOWN
01D12A  89 4E F8              MOV    word ptr [bp - 8], cx        ; UNKNOWN
01D12D  8A 54 01              MOV    dl, byte ptr [si + 1]        ; UNKNOWN
01D130  2A F6                 SUB    dh, dh                       ; UNKNOWN
01D132  03 C2                 ADD    ax, dx                       ; UNKNOWN
01D134  48                    DEC    ax                           ; UNKNOWN
01D135  48                    DEC    ax                           ; UNKNOWN
