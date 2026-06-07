; ============================================================================
; func_048039_unknown
; Region   : load_image
; Bytes    : file 0x048039..0x0481EC  (435 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048039  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
04803D  56                    PUSH   si                           ; UNKNOWN
04803E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
048042  80 BF 88 88 0C        CMP    byte ptr [bx - 0x7778], 0xc  ; UNKNOWN
048047  75 08                 JNE    0x48051                      ; UNKNOWN
048049  C7 06 C0 0B FF FF     MOV    word ptr [0xbc0], 0xffff     ; UNKNOWN
04804F  EB 0E                 JMP    0x4805f                      ; UNKNOWN
048051  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
048055  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
048059  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
04805C  A3 C0 0B              MOV    word ptr [0xbc0], ax         ; UNKNOWN
04805F  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
048062  9A 5D 0F A4 3B        LCALL  0x3ba4, 0xf5d                ; UNKNOWN
048067  0B C0                 OR     ax, ax                       ; UNKNOWN
048069  7D 03                 JGE    0x4806e                      ; UNKNOWN
04806B  E9 5C 01              JMP    0x481ca                      ; UNKNOWN
04806E  83 F8 08              CMP    ax, 8                        ; UNKNOWN
048071  7C 03                 JL     0x48076                      ; UNKNOWN
048073  E9 54 01              JMP    0x481ca                      ; UNKNOWN
048076  8B 0E 14 3E           MOV    cx, word ptr [0x3e14]        ; UNKNOWN
04807A  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
04807D  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
048081  8A 8F 83 88           MOV    cl, byte ptr [bx - 0x777d]   ; UNKNOWN
048085  80 E1 0F              AND    cl, 0xf                      ; UNKNOWN
048088  80 F9 04              CMP    cl, 4                        ; UNKNOWN
04808B  73 2E                 JAE    0x480bb                      ; UNKNOWN
04808D  2A ED                 SUB    ch, ch                       ; UNKNOWN
04808F  6B F1 34              IMUL   si, cx, 0x34                 ; UNKNOWN
048092  38 AC B7 C0           CMP    byte ptr [si - 0x3f49], ch   ; UNKNOWN
048096  75 23                 JNE    0x480bb                      ; UNKNOWN
048098  8B F0                 MOV    si, ax                       ; UNKNOWN
04809A  8A 84 2F 09           MOV    al, byte ptr [si + 0x92f]    ; UNKNOWN
04809E  98                    CWDE                                ; UNKNOWN
04809F  50                    PUSH   ax                           ; UNKNOWN
0480A0  8A 84 26 09           MOV    al, byte ptr [si + 0x926]    ; UNKNOWN
0480A4  98                    CWDE                                ; UNKNOWN
0480A5  50                    PUSH   ax                           ; UNKNOWN
0480A6  8B F3                 MOV    si, bx                       ; UNKNOWN
0480A8  9A 9D 04 C1 3D        LCALL  0x3dc1, 0x49d                ; UNKNOWN
0480AD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0480B0  0B C0                 OR     ax, ax                       ; UNKNOWN
0480B2  74 32                 JE     0x480e6                      ; UNKNOWN
0480B4  C6 84 88 88 00        MOV    byte ptr [si - 0x7778], 0    ; UNKNOWN
0480B9  EB 2B                 JMP    0x480e6                      ; UNKNOWN
0480BB  8B D8                 MOV    bx, ax                       ; UNKNOWN
0480BD  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
0480C1  98                    CWDE                                ; UNKNOWN
0480C2  6B 76 06 1C           IMUL   si, word ptr [bp + 6], 0x1c  ; UNKNOWN
0480C6  8A 8C 81 88           MOV    cl, byte ptr [si - 0x777f]   ; UNKNOWN
0480CA  2A ED                 SUB    ch, ch                       ; UNKNOWN
0480CC  03 C1                 ADD    ax, cx                       ; UNKNOWN
0480CE  50                    PUSH   ax                           ; UNKNOWN
0480CF  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
0480D3  98                    CWDE                                ; UNKNOWN
0480D4  8A 8C 80 88           MOV    cl, byte ptr [si - 0x7780]   ; UNKNOWN
0480D8  03 C8                 ADD    cx, ax                       ; UNKNOWN
0480DA  51                    PUSH   cx                           ; UNKNOWN
0480DB  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0480DE  9A 04 00 FD 3C        LCALL  0x3cfd, 4                    ; UNKNOWN
0480E3  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0480E6  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
0480E9  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
0480EC  74 03                 JE     0x480f1                      ; UNKNOWN
0480EE  E9 F2 00              JMP    0x481e3                      ; UNKNOWN
0480F1  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0480F5  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
0480F9  38 87 89 88           CMP    byte ptr [bx - 0x7777], al   ; UNKNOWN
0480FD  74 03                 JE     0x48102                      ; UNKNOWN
0480FF  E9 E1 00              JMP    0x481e3                      ; UNKNOWN
048102  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
048106  38 8F 8A 88           CMP    byte ptr [bx - 0x7776], cl   ; UNKNOWN
04810A  74 03                 JE     0x4810f                      ; UNKNOWN
04810C  E9 D4 00              JMP    0x481e3                      ; UNKNOWN
04810F  2A ED                 SUB    ch, ch                       ; UNKNOWN
048111  51                    PUSH   cx                           ; UNKNOWN
048112  2A E4                 SUB    ah, ah                       ; UNKNOWN
048114  50                    PUSH   ax                           ; UNKNOWN
048115  8B F3                 MOV    si, bx                       ; UNKNOWN
048117  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
04811C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04811F  83 F8 1A              CMP    ax, 0x1a                     ; UNKNOWN
048122  75 67                 JNE    0x4818b                      ; UNKNOWN
048124  80 BC 88 88 0C        CMP    byte ptr [si - 0x7778], 0xc  ; UNKNOWN
048129  74 60                 JE     0x4818b                      ; UNKNOWN
04812B  83 3E 0C 3E 04        CMP    word ptr [0x3e0c], 4         ; UNKNOWN
048130  7D 0C                 JGE    0x4813e                      ; UNKNOWN
048132  6B 1E 0C 3E 34        IMUL   bx, word ptr [0x3e0c], 0x34  ; UNKNOWN
048137  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
04813C  74 0B                 JE     0x48149                      ; UNKNOWN
04813E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
048142  80 BF 87 88 45        CMP    byte ptr [bx - 0x7779], 0x45 ; UNKNOWN
048147  75 42                 JNE    0x4818b                      ; UNKNOWN
048149  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
04814E  74 14                 JE     0x48164                      ; UNKNOWN
048150  A1 4A 3E              MOV    ax, word ptr [0x3e4a]        ; UNKNOWN
048153  39 06 0C 3E           CMP    word ptr [0x3e0c], ax        ; UNKNOWN
048157  75 32                 JNE    0x4818b                      ; UNKNOWN
048159  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04815D  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
048162  75 27                 JNE    0x4818b                      ; UNKNOWN
048164  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
048167  A3 0A 3E              MOV    word ptr [0x3e0a], ax        ; UNKNOWN
04816A  9A 82 00 0D 46        LCALL  0x460d, 0x82                 ; UNKNOWN
04816F  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
048173  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
048177  24 0F                 AND    al, 0xf                      ; UNKNOWN
048179  3A 06 0E 3E           CMP    al, byte ptr [0x3e0e]        ; UNKNOWN
04817D  75 0C                 JNE    0x4818b                      ; UNKNOWN
04817F  FF 36 0A 3E           PUSH   word ptr [0x3e0a]            ; UNKNOWN
048183  9A 33 05 0B 38        LCALL  0x380b, 0x533                ; UNKNOWN
048188  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04818B  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04818F  80 BF 82 88 02        CMP    byte ptr [bx - 0x777e], 2    ; UNKNOWN
048194  75 0A                 JNE    0x481a0                      ; UNKNOWN
048196  C6 87 91 88 00        MOV    byte ptr [bx - 0x776f], 0    ; UNKNOWN
04819B  C6 87 92 88 FF        MOV    byte ptr [bx - 0x776e], 0xff ; UNKNOWN
0481A0  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0481A4  80 BF 88 88 0B        CMP    byte ptr [bx - 0x7778], 0xb  ; UNKNOWN
0481A9  75 0B                 JNE    0x481b6                      ; UNKNOWN
0481AB  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0481AE  9A 35 15 B7 36        LCALL  0x36b7, 0x1535               ; UNKNOWN
0481B3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0481B6  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0481BA  80 BF 88 88 02        CMP    byte ptr [bx - 0x7778], 2    ; UNKNOWN
0481BF  74 22                 JE     0x481e3                      ; UNKNOWN
0481C1  80 BF 88 88 0C        CMP    byte ptr [bx - 0x7778], 0xc  ; UNKNOWN
0481C6  74 1B                 JE     0x481e3                      ; UNKNOWN
0481C8  EB 14                 JMP    0x481de                      ; UNKNOWN
0481CA  83 F8 08              CMP    ax, 8                        ; UNKNOWN
0481CD  75 0B                 JNE    0x481da                      ; UNKNOWN
0481CF  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0481D3  80 BF 88 88 02        CMP    byte ptr [bx - 0x7778], 2    ; UNKNOWN
0481D8  74 09                 JE     0x481e3                      ; UNKNOWN
0481DA  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0481DE  C6 87 88 88 00        MOV    byte ptr [bx - 0x7778], 0    ; UNKNOWN
0481E3  C7 06 C0 0B FF FF     MOV    word ptr [0xbc0], 0xffff     ; UNKNOWN
0481E9  5E                    POP    si                           ; UNKNOWN
0481EA  C9                    LEAVE                               ; UNKNOWN
0481EB  CB                    RETF                                ; UNKNOWN
