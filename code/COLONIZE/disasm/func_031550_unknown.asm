; ============================================================================
; func_031550_unknown
; Region   : load_image
; Bytes    : file 0x031550..0x031798  (584 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031550  C8 2C 01 00           ENTER  0x12c, 0                     ; UNKNOWN
031554  57                    PUSH   di                           ; UNKNOWN
031555  56                    PUSH   si                           ; UNKNOWN
031556  C6 06 66 74 00        MOV    byte ptr [0x7466], 0         ; UNKNOWN
03155B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03155E  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
031563  83 C4 02              ADD    sp, 2                        ; UNKNOWN
031566  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
03156A  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
03156D  2A E4                 SUB    ah, ah                       ; UNKNOWN
03156F  89 86 D6 FE           MOV    word ptr [bp - 0x12a], ax    ; UNKNOWN
031573  50                    PUSH   ax                           ; UNKNOWN
031574  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
031579  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03157C  0E                    PUSH   cs                           ; UNKNOWN
03157D  E8 43 FD              CALL   0x312c3                      ; UNKNOWN
031580  9A 8F 26 5F 24        LCALL  0x245f, 0x268f               ; UNKNOWN
031585  9A DB 38 5F 24        LCALL  0x245f, 0x38db               ; UNKNOWN
03158A  6A 00                 PUSH   0                            ; UNKNOWN
03158C  6A 12                 PUSH   0x12                         ; UNKNOWN
03158E  9A F6 0A 5F 24        LCALL  0x245f, 0xaf6                ; UNKNOWN
031593  83 C4 04              ADD    sp, 4                        ; UNKNOWN
031596  89 86 48 FF           MOV    word ptr [bp - 0xb8], ax     ; UNKNOWN
03159A  50                    PUSH   ax                           ; UNKNOWN
03159B  FF B6 D6 FE           PUSH   word ptr [bp - 0x12a]        ; UNKNOWN
03159F  9A 12 0A 3A 39        LCALL  0x393a, 0xa12                ; UNKNOWN
0315A4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0315A7  9A 3B 0A 5F 24        LCALL  0x245f, 0xa3b                ; UNKNOWN
0315AC  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
0315AF  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0315B3  8B 87 9A 00           MOV    ax, word ptr [bx + 0x9a]     ; UNKNOWN
0315B7  89 46 96              MOV    word ptr [bp - 0x6a], ax     ; UNKNOWN
0315BA  C7 87 90 00 00 00     MOV    word ptr [bx + 0x90], 0      ; UNKNOWN
0315C0  2B C0                 SUB    ax, ax                       ; UNKNOWN
0315C2  89 86 3E FF           MOV    word ptr [bp - 0xc2], ax     ; UNKNOWN
0315C6  89 46 94              MOV    word ptr [bp - 0x6c], ax     ; UNKNOWN
0315C9  89 86 4C FF           MOV    word ptr [bp - 0xb4], ax     ; UNKNOWN
0315CD  E9 10 02              JMP    0x317e0                      ; UNKNOWN
0315D0  FF B6 4C FF           PUSH   word ptr [bp - 0xb4]         ; UNKNOWN
0315D4  0E                    PUSH   cs                           ; UNKNOWN
0315D5  E8 27 FF              CALL   0x314ff                      ; UNKNOWN
0315D8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0315DB  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
0315DE  0B C0                 OR     ax, ax                       ; UNKNOWN
0315E0  75 03                 JNE    0x315e5                      ; UNKNOWN
0315E2  E9 8A 01              JMP    0x3176f                      ; UNKNOWN
0315E5  8B B6 4C FF           MOV    si, word ptr [bp - 0xb4]     ; UNKNOWN
0315E9  D1 E6                 SHL    si, 1                        ; UNKNOWN
0315EB  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0315EF  83 B8 9A 00 64        CMP    word ptr [bx + si + 0x9a], 0x64 ; UNKNOWN
0315F4  7D 03                 JGE    0x315f9                      ; UNKNOWN
0315F6  E9 76 01              JMP    0x3176f                      ; UNKNOWN
0315F9  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; UNKNOWN
0315FD  83 E8 32              SUB    ax, 0x32                     ; UNKNOWN
031600  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
031603  29 80 9A 00           SUB    word ptr [bx + si + 0x9a], ax ; UNKNOWN
031607  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03160A  29 86 7C FF           SUB    word ptr [bp - 0x84], ax     ; UNKNOWN
03160E  FF B6 4C FF           PUSH   word ptr [bp - 0xb4]         ; UNKNOWN
031612  9A 43 00 E2 29        LCALL  0x29e2, 0x43                 ; UNKNOWN
031617  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03161A  F7 6E FE              IMUL   word ptr [bp - 2]            ; UNKNOWN
03161D  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
031620  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
031625  75 21                 JNE    0x31648                      ; UNKNOWN
031627  6A 00                 PUSH   0                            ; UNKNOWN
031629  6A 64                 PUSH   0x64                         ; UNKNOWN
03162B  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
03162F  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
031632  98                    CWDE                                ; UNKNOWN
031633  F7 6E 9C              IMUL   word ptr [bp - 0x64]         ; UNKNOWN
031636  52                    PUSH   dx                           ; UNKNOWN
031637  50                    PUSH   ax                           ; UNKNOWN
031638  9A D2 11 65 5F        LCALL  0x5f65, 0x11d2               ; UNKNOWN
03163D  89 86 D8 FE           MOV    word ptr [bp - 0x128], ax    ; UNKNOWN
031641  2B 46 9C              SUB    ax, word ptr [bp - 0x64]     ; UNKNOWN
031644  F7 D8                 NEG    ax                           ; UNKNOWN
031646  EB 06                 JMP    0x3164e                      ; UNKNOWN
031648  C7 86 D8 FE 00 00     MOV    word ptr [bp - 0x128], 0     ; UNKNOWN
03164E  89 86 DA FE           MOV    word ptr [bp - 0x126], ax    ; UNKNOWN
031652  99                    CDQ                                 ; UNKNOWN
031653  52                    PUSH   dx                           ; UNKNOWN
031654  50                    PUSH   ax                           ; UNKNOWN
031655  FF 36 9A 79           PUSH   word ptr [0x799a]            ; UNKNOWN
031659  8B F0                 MOV    si, ax                       ; UNKNOWN
03165B  8B FA                 MOV    di, dx                       ; UNKNOWN
03165D  9A 4B 05 5F 24        LCALL  0x245f, 0x54b                ; UNKNOWN
031662  83 C4 06              ADD    sp, 6                        ; UNKNOWN
031665  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
031668  FF B6 4C FF           PUSH   word ptr [bp - 0xb4]         ; UNKNOWN
03166C  9A C5 1D E2 29        LCALL  0x29e2, 0x1dc5               ; UNKNOWN
031671  83 C4 04              ADD    sp, 4                        ; UNKNOWN
031674  8B 86 D8 FE           MOV    ax, word ptr [bp - 0x128]    ; UNKNOWN
031678  99                    CDQ                                 ; UNKNOWN
031679  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
03167D  01 47 22              ADD    word ptr [bx + 0x22], ax     ; UNKNOWN
031680  11 57 24              ADC    word ptr [bx + 0x24], dx     ; UNKNOWN
031683  01 77 26              ADD    word ptr [bx + 0x26], si     ; UNKNOWN
031686  11 7F 28              ADC    word ptr [bx + 0x28], di     ; UNKNOWN
031689  83 BE D6 FE 04        CMP    word ptr [bp - 0x12a], 4     ; UNKNOWN
03168E  7C 03                 JL     0x31693                      ; UNKNOWN
031690  E9 DC 00              JMP    0x3176f                      ; UNKNOWN
031693  6B 9E D6 FE 34        IMUL   bx, word ptr [bp - 0x12a], 0x34 ; UNKNOWN
031698  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
03169D  74 03                 JE     0x316a2                      ; UNKNOWN
03169F  E9 CD 00              JMP    0x3176f                      ; UNKNOWN
0316A2  6A 01                 PUSH   1                            ; UNKNOWN
0316A4  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
0316A9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0316AC  A1 38 73              MOV    ax, word ptr [0x7338]        ; UNKNOWN
0316AF  40                    INC    ax                           ; UNKNOWN
0316B0  40                    INC    ax                           ; UNKNOWN
0316B1  1E                    PUSH   ds                           ; UNKNOWN
0316B2  50                    PUSH   ax                           ; UNKNOWN
0316B3  9A 86 01 2B 3E        LCALL  0x3e2b, 0x186                ; UNKNOWN
0316B8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0316BB  FF 36 58 33           PUSH   word ptr [0x3358]            ; UNKNOWN
0316BF  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
0316C4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0316C7  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0316CA  9A BE 01 2B 3E        LCALL  0x3e2b, 0x1be                ; UNKNOWN
0316CF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0316D2  8B 9E 4C FF           MOV    bx, word ptr [bp - 0xb4]     ; UNKNOWN
0316D6  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0316D8  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
0316DC  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
0316E1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0316E4  FF 36 5A 33           PUSH   word ptr [0x335a]            ; UNKNOWN
0316E8  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
0316ED  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0316F0  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
0316F3  9A BE 01 2B 3E        LCALL  0x3e2b, 0x1be                ; UNKNOWN
0316F8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0316FB  9A 27 02 2B 3E        LCALL  0x3e2b, 0x227                ; UNKNOWN
031700  1E                    PUSH   ds                           ; UNKNOWN
031701  68 7C 1E              PUSH   0x1e7c                       ; UNKNOWN
031704  9A 86 01 2B 3E        LCALL  0x3e2b, 0x186                ; UNKNOWN
031709  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03170C  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
031711  75 47                 JNE    0x3175a                      ; UNKNOWN
031713  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
031717  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
03171A  98                    CWDE                                ; UNKNOWN
03171B  50                    PUSH   ax                           ; UNKNOWN
03171C  9A BE 01 2B 3E        LCALL  0x3e2b, 0x1be                ; UNKNOWN
031721  83 C4 02              ADD    sp, 2                        ; UNKNOWN
031724  9A 27 02 2B 3E        LCALL  0x3e2b, 0x227                ; UNKNOWN
031729  6A 11                 PUSH   0x11                         ; UNKNOWN
03172B  9A 03 30 BF 0D        LCALL  0xdbf, 0x3003                ; UNKNOWN
031730  83 C4 02              ADD    sp, 2                        ; UNKNOWN
031733  FF B6 D8 FE           PUSH   word ptr [bp - 0x128]        ; UNKNOWN
031737  9A BE 01 2B 3E        LCALL  0x3e2b, 0x1be                ; UNKNOWN
03173C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03173F  9A 27 02 2B 3E        LCALL  0x3e2b, 0x227                ; UNKNOWN
031744  6A 12                 PUSH   0x12                         ; UNKNOWN
031746  9A 03 30 BF 0D        LCALL  0xdbf, 0x3003                ; UNKNOWN
03174B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03174E  FF B6 DA FE           PUSH   word ptr [bp - 0x126]        ; UNKNOWN
031752  9A BE 01 2B 3E        LCALL  0x3e2b, 0x1be                ; UNKNOWN
031757  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03175A  80 3E 65 74 00        CMP    byte ptr [0x7465], 0         ; UNKNOWN
03175F  74 0E                 JE     0x3176f                      ; UNKNOWN
031761  6A 00                 PUSH   0                            ; UNKNOWN
031763  6A 78                 PUSH   0x78                         ; UNKNOWN
031765  6A 01                 PUSH   1                            ; UNKNOWN
031767  9A E3 2F BF 0D        LCALL  0xdbf, 0x2fe3                ; UNKNOWN
03176C  83 C4 06              ADD    sp, 6                        ; UNKNOWN
03176F  83 BE 4C FF 00        CMP    word ptr [bp - 0xb4], 0      ; UNKNOWN
031774  74 2A                 JE     0x317a0                      ; UNKNOWN
031776  FF B6 7C FF           PUSH   word ptr [bp - 0x84]         ; UNKNOWN
03177A  6A 00                 PUSH   0                            ; UNKNOWN
03177C  8B B6 4C FF           MOV    si, word ptr [bp - 0xb4]     ; UNKNOWN
031780  D1 E6                 SHL    si, 1                        ; UNKNOWN
031782  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
031786  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; UNKNOWN
03178A  2B 46 98              SUB    ax, word ptr [bp - 0x68]     ; UNKNOWN
03178D  89 82 1E FF           MOV    word ptr [bp + si - 0xe2], ax ; UNKNOWN
031791  50                    PUSH   ax                           ; UNKNOWN
031792  9A 08 00 C2 44        LCALL  0x44c2, 8                    ; UNKNOWN
031797  83                    DB     0x83                         ; UNKNOWN (raw)
