; ============================================================================
; func_0418B0_unknown
; Region   : load_image
; Bytes    : file 0x0418B0..0x041AA4  (500 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0418B0  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
0418B4  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0418B8  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
0418BC  2A E4                 SUB    ah, ah                       ; UNKNOWN
0418BE  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
0418C1  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
0418C5  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
0418C8  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
0418CC  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
0418D0  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
0418D3  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0418D6  6A 00                 PUSH   0                            ; UNKNOWN
0418D8  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0418DB  0E                    PUSH   cs                           ; UNKNOWN
0418DC  E8 BD FE              CALL   0x4179c                      ; UNKNOWN
0418DF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0418E2  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0418E5  2B C0                 SUB    ax, ax                       ; UNKNOWN
0418E7  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
0418EA  A3 5C C1              MOV    word ptr [0xc15c], ax        ; UNKNOWN
0418ED  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
0418F0  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
0418F3  9A 81 03 C9 33        LCALL  0x33c9, 0x381                ; UNKNOWN
0418F8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0418FB  0B C0                 OR     ax, ax                       ; UNKNOWN
0418FD  7C 54                 JL     0x41953                      ; UNKNOWN
0418FF  C7 46 E8 02 00        MOV    word ptr [bp - 0x18], 2      ; UNKNOWN
041904  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
041907  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
04190A  9A 03 03 D2 14        LCALL  0x14d2, 0x303                ; UNKNOWN
04190F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
041912  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
041915  A3 90 0B              MOV    word ptr [0xb90], ax         ; UNKNOWN
041918  6B D8 12              IMUL   bx, ax, 0x12                 ; UNKNOWN
04191B  8A 87 DE 79           MOV    al, byte ptr [bx + 0x79de]   ; UNKNOWN
04191F  2A E4                 SUB    ah, ah                       ; UNKNOWN
041921  83 E8 04              SUB    ax, 4                        ; UNKNOWN
041924  6B D8 4E              IMUL   bx, ax, 0x4e                 ; UNKNOWN
041927  80 BF C6 7F 02        CMP    byte ptr [bx + 0x7fc6], 2    ; UNKNOWN
04192C  72 0A                 JB     0x41938                      ; UNKNOWN
04192E  C7 46 E8 04 00        MOV    word ptr [bp - 0x18], 4      ; UNKNOWN
041933  80 0E 5A C1 10        OR     byte ptr [0xc15a], 0x10      ; UNKNOWN
041938  6B 5E F0 12           IMUL   bx, word ptr [bp - 0x10], 0x12 ; UNKNOWN
04193C  F6 87 DF 79 04        TEST   byte ptr [bx + 0x79df], 4    ; UNKNOWN
041941  74 08                 JE     0x4194b                      ; UNKNOWN
041943  D1 66 E8              SHL    word ptr [bp - 0x18], 1      ; UNKNOWN
041946  80 0E 5A C1 20        OR     byte ptr [0xc15a], 0x20      ; UNKNOWN
04194B  80 0E 5A C1 08        OR     byte ptr [0xc15a], 8         ; UNKNOWN
041950  E9 1B 01              JMP    0x41a6e                      ; UNKNOWN
041953  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
041956  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
041959  9A 47 03 C9 33        LCALL  0x33c9, 0x347                ; UNKNOWN
04195E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
041961  0B C0                 OR     ax, ax                       ; UNKNOWN
041963  7C 2C                 JL     0x41991                      ; UNKNOWN
041965  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
041968  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
04196B  9A 61 0A 5F 24        LCALL  0x245f, 0xa61                ; UNKNOWN
041970  83 C4 04              ADD    sp, 4                        ; UNKNOWN
041973  A3 92 0B              MOV    word ptr [0xb92], ax         ; UNKNOWN
041976  50                    PUSH   ax                           ; UNKNOWN
041977  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
04197C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04197F  0E                    PUSH   cs                           ; UNKNOWN
041980  E8 D7 FD              CALL   0x4175a                      ; UNKNOWN
041983  40                    INC    ax                           ; UNKNOWN
041984  D1 E0                 SHL    ax, 1                        ; UNKNOWN
041986  01 46 E8              ADD    word ptr [bp - 0x18], ax     ; UNKNOWN
041989  80 0E 5A C1 40        OR     byte ptr [0xc15a], 0x40      ; UNKNOWN
04198E  E9 DD 00              JMP    0x41a6e                      ; UNKNOWN
041991  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
041994  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
041997  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
04199C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04199F  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
0419A2  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0419A6  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
0419AA  24 0F                 AND    al, 0xf                      ; UNKNOWN
0419AC  3C 04                 CMP    al, 4                        ; UNKNOWN
0419AE  73 1E                 JAE    0x419ce                      ; UNKNOWN
0419B0  83 7E FE 04           CMP    word ptr [bp - 2], 4         ; UNKNOWN
0419B4  7D 2F                 JGE    0x419e5                      ; UNKNOWN
0419B6  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
0419BB  74 11                 JE     0x419ce                      ; UNKNOWN
0419BD  83 7E FE 04           CMP    word ptr [bp - 2], 4         ; UNKNOWN
0419C1  7D 0B                 JGE    0x419ce                      ; UNKNOWN
0419C3  6B 5E FE 34           IMUL   bx, word ptr [bp - 2], 0x34  ; UNKNOWN
0419C7  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
0419CC  74 17                 JE     0x419e5                      ; UNKNOWN
0419CE  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
0419D1  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
0419D4  8A 87 B7 34           MOV    al, byte ptr [bx + 0x34b7]   ; UNKNOWN
0419D8  2A E4                 SUB    ah, ah                       ; UNKNOWN
0419DA  01 46 E8              ADD    word ptr [bp - 0x18], ax     ; UNKNOWN
0419DD  80 0E 5A C1 80        OR     byte ptr [0xc15a], 0x80      ; UNKNOWN
0419E2  E9 89 00              JMP    0x41a6e                      ; UNKNOWN
0419E5  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
0419EA  83 7E FE 04           CMP    word ptr [bp - 2], 4         ; UNKNOWN
0419EE  7D 54                 JGE    0x41a44                      ; UNKNOWN
0419F0  6B 5E FE 34           IMUL   bx, word ptr [bp - 2], 0x34  ; UNKNOWN
0419F4  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
0419F9  75 49                 JNE    0x41a44                      ; UNKNOWN
0419FB  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
0419FE  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
041A01  9A 47 03 C9 33        LCALL  0x33c9, 0x347                ; UNKNOWN
041A06  83 C4 04              ADD    sp, 4                        ; UNKNOWN
041A09  0B C0                 OR     ax, ax                       ; UNKNOWN
041A0B  7D 1C                 JGE    0x41a29                      ; UNKNOWN
041A0D  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
041A11  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
041A15  2A E4                 SUB    ah, ah                       ; UNKNOWN
041A17  50                    PUSH   ax                           ; UNKNOWN
041A18  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
041A1C  50                    PUSH   ax                           ; UNKNOWN
041A1D  9A 47 03 C9 33        LCALL  0x33c9, 0x347                ; UNKNOWN
041A22  83 C4 04              ADD    sp, 4                        ; UNKNOWN
041A25  0B C0                 OR     ax, ax                       ; UNKNOWN
041A27  7C 2B                 JL     0x41a54                      ; UNKNOWN
041A29  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
041A2E  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
041A31  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
041A34  8A 87 B7 34           MOV    al, byte ptr [bx + 0x34b7]   ; UNKNOWN
041A38  2A E4                 SUB    ah, ah                       ; UNKNOWN
041A3A  01 46 E8              ADD    word ptr [bp - 0x18], ax     ; UNKNOWN
041A3D  80 0E 5A C1 80        OR     byte ptr [0xc15a], 0x80      ; UNKNOWN
041A42  EB 10                 JMP    0x41a54                      ; UNKNOWN
041A44  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
041A48  80 BF 88 88 06        CMP    byte ptr [bx - 0x7778], 6    ; UNKNOWN
041A4D  75 05                 JNE    0x41a54                      ; UNKNOWN
041A4F  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
041A54  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
041A58  74 14                 JE     0x41a6e                      ; UNKNOWN
041A5A  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
041A5D  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
041A60  8A 87 B7 34           MOV    al, byte ptr [bx + 0x34b7]   ; UNKNOWN
041A64  2A E4                 SUB    ah, ah                       ; UNKNOWN
041A66  A3 5C C1              MOV    word ptr [0xc15c], ax        ; UNKNOWN
041A69  80 0E 58 C1 80        OR     byte ptr [0xc158], 0x80      ; UNKNOWN
041A6E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
041A72  80 BF 88 88 06        CMP    byte ptr [bx - 0x7778], 6    ; UNKNOWN
041A77  75 1D                 JNE    0x41a96                      ; UNKNOWN
041A79  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
041A7E  72 07                 JB     0x41a87                      ; UNKNOWN
041A80  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
041A85  76 0F                 JBE    0x41a96                      ; UNKNOWN
041A87  83 7E E8 05           CMP    word ptr [bp - 0x18], 5      ; UNKNOWN
041A8B  7D 09                 JGE    0x41a96                      ; UNKNOWN
041A8D  83 46 E8 02           ADD    word ptr [bp - 0x18], 2      ; UNKNOWN
041A91  80 0E 5B C1 20        OR     byte ptr [0xc15b], 0x20      ; UNKNOWN
041A96  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
041A99  83 C0 04              ADD    ax, 4                        ; UNKNOWN
041A9C  F7 6E F6              IMUL   word ptr [bp - 0xa]          ; UNKNOWN
041A9F  C1 F8 02              SAR    ax, 2                        ; UNKNOWN
041AA2  C9                    LEAVE                               ; UNKNOWN
041AA3  CB                    RETF                                ; UNKNOWN
