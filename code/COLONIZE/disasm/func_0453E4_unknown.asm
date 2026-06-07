; ============================================================================
; func_0453E4_unknown
; Region   : load_image
; Bytes    : file 0x0453E4..0x0454DA  (246 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0453E4  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
0453E8  53                    PUSH   bx                           ; UNKNOWN
0453E9  52                    PUSH   dx                           ; UNKNOWN
0453EA  50                    PUSH   ax                           ; UNKNOWN
0453EB  56                    PUSH   si                           ; UNKNOWN
0453EC  C7 46 F2 FF FF        MOV    word ptr [bp - 0xe], 0xffff  ; UNKNOWN
0453F1  C1 F8 02              SAR    ax, 2                        ; UNKNOWN
0453F4  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
0453F7  C1 FA 02              SAR    dx, 2                        ; UNKNOWN
0453FA  89 56 EE              MOV    word ptr [bp - 0x12], dx     ; UNKNOWN
0453FD  0B DB                 OR     bx, bx                       ; UNKNOWN
0453FF  74 0C                 JE     0x4540d                      ; UNKNOWN
045401  6B F0 12              IMUL   si, ax, 0x12                 ; UNKNOWN
045404  8B DA                 MOV    bx, dx                       ; UNKNOWN
045406  80 B8 42 84 00        CMP    byte ptr [bx + si - 0x7bbe], 0 ; UNKNOWN
04540B  EB 0A                 JMP    0x45417                      ; UNKNOWN
04540D  6B F0 12              IMUL   si, ax, 0x12                 ; UNKNOWN
045410  8B DA                 MOV    bx, dx                       ; UNKNOWN
045412  80 B8 34 83 00        CMP    byte ptr [bx + si - 0x7ccc], 0 ; UNKNOWN
045417  74 05                 JE     0x4541e                      ; UNKNOWN
045419  C7 46 F2 08 00        MOV    word ptr [bp - 0xe], 8       ; UNKNOWN
04541E  83 7E F2 08           CMP    word ptr [bp - 0xe], 8       ; UNKNOWN
045422  75 3D                 JNE    0x45461                      ; UNKNOWN
045424  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
045427  50                    PUSH   ax                           ; UNKNOWN
045428  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
04542B  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
04542E  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
045431  40                    INC    ax                           ; UNKNOWN
045432  8B 56 EE              MOV    dx, word ptr [bp - 0x12]     ; UNKNOWN
045435  C1 E2 02              SHL    dx, 2                        ; UNKNOWN
045438  42                    INC    dx                           ; UNKNOWN
045439  8D 5E FE              LEA    bx, [bp - 2]                 ; UNKNOWN
04543C  E8 0D F6              CALL   0x44a4c                      ; UNKNOWN
04543F  0B C0                 OR     ax, ax                       ; UNKNOWN
045441  74 19                 JE     0x4545c                      ; UNKNOWN
045443  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
045446  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
045449  6A 12                 PUSH   0x12                         ; UNKNOWN
04544B  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04544E  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
045451  8B 5E E6              MOV    bx, word ptr [bp - 0x1a]     ; UNKNOWN
045454  0E                    PUSH   cs                           ; UNKNOWN
045455  E8 E4 FE              CALL   0x4533c                      ; UNKNOWN
045458  0B C0                 OR     ax, ax                       ; UNKNOWN
04545A  7D 05                 JGE    0x45461                      ; UNKNOWN
04545C  C7 46 F2 FF FF        MOV    word ptr [bp - 0xe], 0xffff  ; UNKNOWN
045461  83 7E F2 00           CMP    word ptr [bp - 0xe], 0       ; UNKNOWN
045465  7C 03                 JL     0x4546a                      ; UNKNOWN
045467  E9 E5 00              JMP    0x4554f                      ; UNKNOWN
04546A  C7 46 EC 63 00        MOV    word ptr [bp - 0x14], 0x63   ; UNKNOWN
04546F  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; UNKNOWN
045474  EB 0F                 JMP    0x45485                      ; UNKNOWN
045476  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
04547A  7C 06                 JL     0x45482                      ; UNKNOWN
04547C  83 7E F8 12           CMP    word ptr [bp - 8], 0x12      ; UNKNOWN
045480  7C 30                 JL     0x454b2                      ; UNKNOWN
045482  FF 46 F4              INC    word ptr [bp - 0xc]          ; UNKNOWN
045485  83 7E F4 08           CMP    word ptr [bp - 0xc], 8       ; UNKNOWN
045489  7C 03                 JL     0x4548e                      ; UNKNOWN
04548B  E9 C1 00              JMP    0x4554f                      ; UNKNOWN
04548E  8B 5E F4              MOV    bx, word ptr [bp - 0xc]      ; UNKNOWN
045491  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
045495  98                    CWDE                                ; UNKNOWN
045496  03 46 EE              ADD    ax, word ptr [bp - 0x12]     ; UNKNOWN
045499  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04549C  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
0454A0  98                    CWDE                                ; UNKNOWN
0454A1  03 46 F0              ADD    ax, word ptr [bp - 0x10]     ; UNKNOWN
0454A4  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0454A7  0B C0                 OR     ax, ax                       ; UNKNOWN
0454A9  7C D7                 JL     0x45482                      ; UNKNOWN
0454AB  83 F8 0F              CMP    ax, 0xf                      ; UNKNOWN
0454AE  7C C6                 JL     0x45476                      ; UNKNOWN
0454B0  EB D0                 JMP    0x45482                      ; UNKNOWN
0454B2  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; UNKNOWN
0454B6  74 0D                 JE     0x454c5                      ; UNKNOWN
0454B8  6B F0 12              IMUL   si, ax, 0x12                 ; UNKNOWN
0454BB  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
0454BE  80 B8 42 84 00        CMP    byte ptr [bx + si - 0x7bbe], 0 ; UNKNOWN
0454C3  75 13                 JNE    0x454d8                      ; UNKNOWN
0454C5  83 7E EA 00           CMP    word ptr [bp - 0x16], 0      ; UNKNOWN
0454C9  75 B7                 JNE    0x45482                      ; UNKNOWN
0454CB  6B F0 12              IMUL   si, ax, 0x12                 ; UNKNOWN
0454CE  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
0454D1  80 B8 34 83 00        CMP    byte ptr [bx + si - 0x7ccc], 0 ; UNKNOWN
0454D6  74 AA                 JE     0x45482                      ; UNKNOWN
0454D8  8B C3                 MOV    ax, bx                       ; UNKNOWN
