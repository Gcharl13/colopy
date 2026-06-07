; ============================================================================
; func_020FB6_unknown
; Region   : load_image
; Bytes    : file 0x020FB6..0x0210F0  (314 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020FB6  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
020FBA  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
020FBF  1E                    PUSH   ds                           ; UNKNOWN
020FC0  68 A0 82              PUSH   0x82a0                       ; UNKNOWN
020FC3  1E                    PUSH   ds                           ; UNKNOWN
020FC4  68 A0 82              PUSH   0x82a0                       ; UNKNOWN
020FC7  1E                    PUSH   ds                           ; UNKNOWN
020FC8  68 04 0B              PUSH   0xb04                        ; UNKNOWN
020FCB  9A 57 00 3A 5B        LCALL  0x5b3a, 0x57                 ; UNKNOWN
020FD0  1E                    PUSH   ds                           ; UNKNOWN
020FD1  68 A0 82              PUSH   0x82a0                       ; UNKNOWN
020FD4  8D 1E 9A 18           LEA    bx, [0x189a]                 ; UNKNOWN
020FD8  9A FC 00 E9 5A        LCALL  0x5ae9, 0xfc                 ; UNKNOWN
020FDD  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
020FE0  0B C0                 OR     ax, ax                       ; UNKNOWN
020FE2  75 09                 JNE    0x20fed                      ; UNKNOWN
020FE4  C7 06 08 0B 01 00     MOV    word ptr [0xb08], 1          ; UNKNOWN
020FEA  E9 F0 00              JMP    0x210dd                      ; UNKNOWN
020FED  50                    PUSH   ax                           ; UNKNOWN
020FEE  6A 01                 PUSH   1                            ; UNKNOWN
020FF0  6A 04                 PUSH   4                            ; UNKNOWN
020FF2  68 88 82              PUSH   0x8288                       ; UNKNOWN
020FF5  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
020FFA  83 C4 08              ADD    sp, 8                        ; UNKNOWN
020FFD  0B C0                 OR     ax, ax                       ; UNKNOWN
020FFF  75 09                 JNE    0x2100a                      ; UNKNOWN
021001  C7 06 08 0B 02 00     MOV    word ptr [0xb08], 2          ; UNKNOWN
021007  E9 D3 00              JMP    0x210dd                      ; UNKNOWN
02100A  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02100D  6A 01                 PUSH   1                            ; UNKNOWN
02100F  6A 02                 PUSH   2                            ; UNKNOWN
021011  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
021014  50                    PUSH   ax                           ; UNKNOWN
021015  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
02101A  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02101D  0B C0                 OR     ax, ax                       ; UNKNOWN
02101F  74 E0                 JE     0x21001                      ; UNKNOWN
021021  83 7E FC 04           CMP    word ptr [bp - 4], 4         ; UNKNOWN
021025  7F 02                 JG     0x21029                      ; UNKNOWN
021027  7D 10                 JGE    0x21039                      ; UNKNOWN
021029  83 3E 02 0B 00        CMP    word ptr [0xb02], 0          ; UNKNOWN
02102E  7C 09                 JL     0x21039                      ; UNKNOWN
021030  C7 06 08 0B 03 00     MOV    word ptr [0xb08], 3          ; UNKNOWN
021036  E9 A4 00              JMP    0x210dd                      ; UNKNOWN
021039  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02103C  A3 02 0B              MOV    word ptr [0xb02], ax         ; UNKNOWN
02103F  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
021042  F7 2E 88 82           IMUL   word ptr [0x8288]            ; UNKNOWN
021046  A3 F0 82              MOV    word ptr [0x82f0], ax        ; UNKNOWN
021049  89 16 F2 82           MOV    word ptr [0x82f2], dx        ; UNKNOWN
02104D  0E                    PUSH   cs                           ; UNKNOWN
02104E  E8 21 FF              CALL   0x20f72                      ; UNKNOWN
021051  0B C0                 OR     ax, ax                       ; UNKNOWN
021053  74 03                 JE     0x21058                      ; UNKNOWN
021055  E9 85 00              JMP    0x210dd                      ; UNKNOWN
021058  39 06 0A 0B           CMP    word ptr [0xb0a], ax         ; UNKNOWN
02105C  75 74                 JNE    0x210d2                      ; UNKNOWN
02105E  FF 36 0E 0B           PUSH   word ptr [0xb0e]             ; UNKNOWN
021062  FF 36 0C 0B           PUSH   word ptr [0xb0c]             ; UNKNOWN
021066  50                    PUSH   ax                           ; UNKNOWN
021067  6A 01                 PUSH   1                            ; UNKNOWN
021069  A1 F0 82              MOV    ax, word ptr [0x82f0]        ; UNKNOWN
02106C  8B 16 F2 82           MOV    dx, word ptr [0x82f2]        ; UNKNOWN
021070  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
021073  9A 04 00 03 5B        LCALL  0x5b03, 4                    ; UNKNOWN
021078  0B D0                 OR     dx, ax                       ; UNKNOWN
02107A  75 08                 JNE    0x21084                      ; UNKNOWN
02107C  C7 06 08 0B 04 00     MOV    word ptr [0xb08], 4          ; UNKNOWN
021082  EB 59                 JMP    0x210dd                      ; UNKNOWN
021084  FF 36 12 0B           PUSH   word ptr [0xb12]             ; UNKNOWN
021088  FF 36 10 0B           PUSH   word ptr [0xb10]             ; UNKNOWN
02108C  6A 00                 PUSH   0                            ; UNKNOWN
02108E  6A 01                 PUSH   1                            ; UNKNOWN
021090  A1 F0 82              MOV    ax, word ptr [0x82f0]        ; UNKNOWN
021093  8B 16 F2 82           MOV    dx, word ptr [0x82f2]        ; UNKNOWN
021097  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
02109A  9A 04 00 03 5B        LCALL  0x5b03, 4                    ; UNKNOWN
02109F  0B D0                 OR     dx, ax                       ; UNKNOWN
0210A1  75 08                 JNE    0x210ab                      ; UNKNOWN
0210A3  C7 06 08 0B 05 00     MOV    word ptr [0xb08], 5          ; UNKNOWN
0210A9  EB 32                 JMP    0x210dd                      ; UNKNOWN
0210AB  FF 36 16 0B           PUSH   word ptr [0xb16]             ; UNKNOWN
0210AF  FF 36 14 0B           PUSH   word ptr [0xb14]             ; UNKNOWN
0210B3  6A 00                 PUSH   0                            ; UNKNOWN
0210B5  6A 01                 PUSH   1                            ; UNKNOWN
0210B7  A1 F0 82              MOV    ax, word ptr [0x82f0]        ; UNKNOWN
0210BA  8B 16 F2 82           MOV    dx, word ptr [0x82f2]        ; UNKNOWN
0210BE  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0210C1  9A 04 00 03 5B        LCALL  0x5b03, 4                    ; UNKNOWN
0210C6  0B D0                 OR     dx, ax                       ; UNKNOWN
0210C8  75 08                 JNE    0x210d2                      ; UNKNOWN
0210CA  C7 06 08 0B 06 00     MOV    word ptr [0xb08], 6          ; UNKNOWN
0210D0  EB 0B                 JMP    0x210dd                      ; UNKNOWN
0210D2  2B C0                 SUB    ax, ax                       ; UNKNOWN
0210D4  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0210D7  A3 08 0B              MOV    word ptr [0xb08], ax         ; UNKNOWN
0210DA  E8 75 FD              CALL   0x20e52                      ; UNKNOWN
0210DD  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
0210E1  74 08                 JE     0x210eb                      ; UNKNOWN
0210E3  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
0210E6  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
0210EB  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0210EE  C9                    LEAVE                               ; UNKNOWN
0210EF  CB                    RETF                                ; UNKNOWN
