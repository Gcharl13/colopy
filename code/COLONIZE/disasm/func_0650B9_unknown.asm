; ============================================================================
; func_0650B9_unknown
; Region   : load_image
; Bytes    : file 0x0650B9..0x0651DF  (294 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0650B9  C8 0A 03 00           ENTER  0x30a, 0                     ; UNKNOWN
0650BD  57                    PUSH   di                           ; UNKNOWN
0650BE  C7 06 7E 0C 00 00     MOV    word ptr [0xc7e], 0          ; UNKNOWN
0650C4  33 FF                 XOR    di, di                       ; UNKNOWN
0650C6  B9 20 00              MOV    cx, 0x20                     ; UNKNOWN
0650C9  FA                    CLI                                 ; UNKNOWN
0650CA  BA DA 03              MOV    dx, 0x3da                    ; UNKNOWN
0650CD  B4 08                 MOV    ah, 8                        ; UNKNOWN
0650CF  EC                    IN     al, dx                       ; UNKNOWN
0650D0  22 C4                 AND    al, ah                       ; UNKNOWN
0650D2  75 FB                 JNE    0x650cf                      ; UNKNOWN
0650D4  EC                    IN     al, dx                       ; UNKNOWN
0650D5  22 C4                 AND    al, ah                       ; UNKNOWN
0650D7  74 FB                 JE     0x650d4                      ; UNKNOWN
0650D9  32 C0                 XOR    al, al                       ; UNKNOWN
0650DB  E6 43                 OUT    0x43, al                     ; UNKNOWN
0650DD  EB 00                 JMP    0x650df                      ; UNKNOWN
0650DF  E4 40                 IN     al, 0x40                     ; UNKNOWN
0650E1  8A D8                 MOV    bl, al                       ; UNKNOWN
0650E3  EB 00                 JMP    0x650e5                      ; UNKNOWN
0650E5  E4 40                 IN     al, 0x40                     ; UNKNOWN
0650E7  8A F8                 MOV    bh, al                       ; UNKNOWN
0650E9  BA DA 03              MOV    dx, 0x3da                    ; UNKNOWN
0650EC  B4 08                 MOV    ah, 8                        ; UNKNOWN
0650EE  EC                    IN     al, dx                       ; UNKNOWN
0650EF  22 C4                 AND    al, ah                       ; UNKNOWN
0650F1  75 FB                 JNE    0x650ee                      ; UNKNOWN
0650F3  32 C0                 XOR    al, al                       ; UNKNOWN
0650F5  E6 43                 OUT    0x43, al                     ; UNKNOWN
0650F7  EB 00                 JMP    0x650f9                      ; UNKNOWN
0650F9  E4 40                 IN     al, 0x40                     ; UNKNOWN
0650FB  8A D0                 MOV    dl, al                       ; UNKNOWN
0650FD  EB 00                 JMP    0x650ff                      ; UNKNOWN
0650FF  E4 40                 IN     al, 0x40                     ; UNKNOWN
065101  8A F0                 MOV    dh, al                       ; UNKNOWN
065103  FB                    STI                                 ; UNKNOWN
065104  2B DA                 SUB    bx, dx                       ; UNKNOWN
065106  03 FB                 ADD    di, bx                       ; UNKNOWN
065108  E2 BF                 LOOP   0x650c9                      ; UNKNOWN
06510A  C1 EF 05              SHR    di, 5                        ; UNKNOWN
06510D  89 3E 76 0C           MOV    word ptr [0xc76], di         ; UNKNOWN
065111  8D 86 00 FD           LEA    ax, [bp - 0x300]             ; UNKNOWN
065115  16                    PUSH   ss                           ; UNKNOWN
065116  50                    PUSH   ax                           ; UNKNOWN
065117  9A 04 00 F8 5B        LCALL  0x5bf8, 4                    ; UNKNOWN
06511C  C7 86 F6 FC 40 00     MOV    word ptr [bp - 0x30a], 0x40  ; UNKNOWN
065122  C7 86 FE FC 80 00     MOV    word ptr [bp - 0x302], 0x80  ; UNKNOWN
065128  2B C0                 SUB    ax, ax                       ; UNKNOWN
06512A  89 86 FA FC           MOV    word ptr [bp - 0x306], ax    ; UNKNOWN
06512E  89 86 FC FC           MOV    word ptr [bp - 0x304], ax    ; UNKNOWN
065132  83 BE F6 FC 02        CMP    word ptr [bp - 0x30a], 2     ; UNKNOWN
065137  7F 07                 JG     0x65140                      ; UNKNOWN
065139  83 BE FA FC 00        CMP    word ptr [bp - 0x306], 0     ; UNKNOWN
06513E  75 68                 JNE    0x651a8                      ; UNKNOWN
065140  83 BE FC FC 40        CMP    word ptr [bp - 0x304], 0x40  ; UNKNOWN
065145  7D 61                 JGE    0x651a8                      ; UNKNOWN
065147  8D 86 00 FD           LEA    ax, [bp - 0x300]             ; UNKNOWN
06514B  16                    PUSH   ss                           ; UNKNOWN
06514C  50                    PUSH   ax                           ; UNKNOWN
06514D  2B C0                 SUB    ax, ax                       ; UNKNOWN
06514F  8B 96 FE FC           MOV    dx, word ptr [bp - 0x302]    ; UNKNOWN
065153  0E                    PUSH   cs                           ; UNKNOWN
065154  E8 F9 FE              CALL   0x65050                      ; UNKNOWN
065157  89 86 F8 FC           MOV    word ptr [bp - 0x308], ax    ; UNKNOWN
06515B  39 06 76 0C           CMP    word ptr [0xc76], ax         ; UNKNOWN
06515F  72 1C                 JB     0x6517d                      ; UNKNOWN
065161  8B 86 FE FC           MOV    ax, word ptr [bp - 0x302]    ; UNKNOWN
065165  03 86 F6 FC           ADD    ax, word ptr [bp - 0x30a]    ; UNKNOWN
065169  3D 00 01              CMP    ax, 0x100                    ; UNKNOWN
06516C  7E 03                 JLE    0x65171                      ; UNKNOWN
06516E  B8 00 01              MOV    ax, 0x100                    ; UNKNOWN
065171  89 86 FE FC           MOV    word ptr [bp - 0x302], ax    ; UNKNOWN
065175  C7 86 FA FC 01 00     MOV    word ptr [bp - 0x306], 1     ; UNKNOWN
06517B  EB 1A                 JMP    0x65197                      ; UNKNOWN
06517D  8B 86 FE FC           MOV    ax, word ptr [bp - 0x302]    ; UNKNOWN
065181  2B 86 F6 FC           SUB    ax, word ptr [bp - 0x30a]    ; UNKNOWN
065185  83 F8 01              CMP    ax, 1                        ; UNKNOWN
065188  7D 03                 JGE    0x6518d                      ; UNKNOWN
06518A  B8 01 00              MOV    ax, 1                        ; UNKNOWN
06518D  89 86 FE FC           MOV    word ptr [bp - 0x302], ax    ; UNKNOWN
065191  C7 86 FA FC 00 00     MOV    word ptr [bp - 0x306], 0     ; UNKNOWN
065197  83 BE F6 FC 02        CMP    word ptr [bp - 0x30a], 2     ; UNKNOWN
06519C  7E 04                 JLE    0x651a2                      ; UNKNOWN
06519E  D1 BE F6 FC           SAR    word ptr [bp - 0x30a], 1     ; UNKNOWN
0651A2  FF 86 FC FC           INC    word ptr [bp - 0x304]        ; UNKNOWN
0651A6  EB 8A                 JMP    0x65132                      ; UNKNOWN
0651A8  83 BE FA FC 00        CMP    word ptr [bp - 0x306], 0     ; UNKNOWN
0651AD  75 08                 JNE    0x651b7                      ; UNKNOWN
0651AF  C7 06 78 0C 20 00     MOV    word ptr [0xc78], 0x20       ; UNKNOWN
0651B5  EB 13                 JMP    0x651ca                      ; UNKNOWN
0651B7  8B 86 FE FC           MOV    ax, word ptr [bp - 0x302]    ; UNKNOWN
0651BB  8B C8                 MOV    cx, ax                       ; UNKNOWN
0651BD  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0651BF  03 C1                 ADD    ax, cx                       ; UNKNOWN
0651C1  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0651C3  03 C1                 ADD    ax, cx                       ; UNKNOWN
0651C5  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0651C7  A3 78 0C              MOV    word ptr [0xc78], ax         ; UNKNOWN
0651CA  A1 78 0C              MOV    ax, word ptr [0xc78]         ; UNKNOWN
0651CD  8B C8                 MOV    cx, ax                       ; UNKNOWN
0651CF  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0651D1  03 C1                 ADD    ax, cx                       ; UNKNOWN
0651D3  A3 7A 0C              MOV    word ptr [0xc7a], ax         ; UNKNOWN
0651D6  C7 06 74 0C 01 00     MOV    word ptr [0xc74], 1          ; UNKNOWN
0651DC  5F                    POP    di                           ; UNKNOWN
0651DD  C9                    LEAVE                               ; UNKNOWN
0651DE  CB                    RETF                                ; UNKNOWN
