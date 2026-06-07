; ============================================================================
; func_03A108_unknown
; Region   : load_image
; Bytes    : file 0x03A108..0x03A232  (298 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03A108  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
03A10C  56                    PUSH   si                           ; UNKNOWN
03A10D  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
03A110  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
03A113  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03A116  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
03A11A  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
03A11D  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
03A120  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
03A124  2A E4                 SUB    ah, ah                       ; UNKNOWN
03A126  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
03A129  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
03A12D  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
03A130  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03A133  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
03A136  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
03A139  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
03A13E  72 0A                 JB     0x3a14a                      ; UNKNOWN
03A140  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
03A145  77 03                 JA     0x3a14a                      ; UNKNOWN
03A147  E9 C4 00              JMP    0x3a20e                      ; UNKNOWN
03A14A  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
03A14F  EB 13                 JMP    0x3a164                      ; UNKNOWN
03A151  50                    PUSH   ax                           ; UNKNOWN
03A152  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
03A155  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
03A15A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A15D  A8 40                 TEST   al, 0x40                     ; UNKNOWN
03A15F  75 5E                 JNE    0x3a1bf                      ; UNKNOWN
03A161  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
03A164  83 7E FA 08           CMP    word ptr [bp - 6], 8         ; UNKNOWN
03A168  7D 5B                 JGE    0x3a1c5                      ; UNKNOWN
03A16A  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
03A16D  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
03A171  98                    CWDE                                ; UNKNOWN
03A172  03 46 F2              ADD    ax, word ptr [bp - 0xe]      ; UNKNOWN
03A175  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03A178  50                    PUSH   ax                           ; UNKNOWN
03A179  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
03A17D  98                    CWDE                                ; UNKNOWN
03A17E  03 46 F6              ADD    ax, word ptr [bp - 0xa]      ; UNKNOWN
03A181  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03A184  50                    PUSH   ax                           ; UNKNOWN
03A185  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
03A18A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A18D  0B C0                 OR     ax, ax                       ; UNKNOWN
03A18F  74 D0                 JE     0x3a161                      ; UNKNOWN
03A191  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03A194  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
03A197  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
03A19C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A19F  0B C0                 OR     ax, ax                       ; UNKNOWN
03A1A1  75 BE                 JNE    0x3a161                      ; UNKNOWN
03A1A3  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03A1A6  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
03A1A9  9A 47 03 C9 33        LCALL  0x33c9, 0x347                ; UNKNOWN
03A1AE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A1B1  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
03A1B4  0B C0                 OR     ax, ax                       ; UNKNOWN
03A1B6  7C A9                 JL     0x3a161                      ; UNKNOWN
03A1B8  3B 46 EC              CMP    ax, word ptr [bp - 0x14]     ; UNKNOWN
03A1BB  75 94                 JNE    0x3a151                      ; UNKNOWN
03A1BD  EB A2                 JMP    0x3a161                      ; UNKNOWN
03A1BF  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
03A1C2  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
03A1C5  83 7E F4 00           CMP    word ptr [bp - 0xc], 0       ; UNKNOWN
03A1C9  7C 43                 JL     0x3a20e                      ; UNKNOWN
03A1CB  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
03A1CE  9A 94 01 49 22        LCALL  0x2249, 0x194                ; UNKNOWN
03A1D3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03A1D6  50                    PUSH   ax                           ; UNKNOWN
03A1D7  6A 00                 PUSH   0                            ; UNKNOWN
03A1D9  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
03A1DE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A1E1  6A 01                 PUSH   1                            ; UNKNOWN
03A1E3  68 67 22              PUSH   0x2267                       ; UNKNOWN
03A1E6  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
03A1EB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A1EE  83 F8 02              CMP    ax, 2                        ; UNKNOWN
03A1F1  75 3C                 JNE    0x3a22f                      ; UNKNOWN
03A1F3  69 76 F4 3C 01        IMUL   si, word ptr [bp - 0xc], 0x13c ; UNKNOWN
03A1F8  8B 5E EC              MOV    bx, word ptr [bp - 0x14]     ; UNKNOWN
03A1FB  80 88 DE 74 02        OR     byte ptr [bx + si + 0x74de], 2 ; UNKNOWN
03A200  6A 40                 PUSH   0x40                         ; UNKNOWN
03A202  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
03A205  53                    PUSH   bx                           ; UNKNOWN
03A206  9A CE 00 49 22        LCALL  0x2249, 0xce                 ; UNKNOWN
03A20B  83 C4 06              ADD    sp, 6                        ; UNKNOWN
03A20E  B8 58 00              MOV    ax, 0x58                     ; UNKNOWN
03A211  9A 0A 00 11 5D        LCALL  0x5d11, 0xa                  ; UNKNOWN
03A216  6B 5E EE 1C           IMUL   bx, word ptr [bp - 0x12], 0x1c ; UNKNOWN
03A21A  C6 87 88 88 05        MOV    byte ptr [bx - 0x7778], 5    ; UNKNOWN
03A21F  C6 87 96 88 00        MOV    byte ptr [bx - 0x776a], 0    ; UNKNOWN
03A224  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
03A227  9A 35 15 B7 36        LCALL  0x36b7, 0x1535               ; UNKNOWN
03A22C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03A22F  5E                    POP    si                           ; UNKNOWN
03A230  C9                    LEAVE                               ; UNKNOWN
03A231  CB                    RETF                                ; UNKNOWN
