; ============================================================================
; func_036F7B_unknown
; Region   : load_image
; Bytes    : file 0x036F7B..0x037216  (667 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

036F7B  C8 D6 00 00           ENTER  0xd6, 0                      ; UNKNOWN
036F7F  56                    PUSH   si                           ; UNKNOWN
036F80  C7 46 92 01 00        MOV    word ptr [bp - 0x6e], 1      ; UNKNOWN
036F85  C7 46 8C 14 00        MOV    word ptr [bp - 0x74], 0x14   ; UNKNOWN
036F8A  2B C0                 SUB    ax, ax                       ; UNKNOWN
036F8C  89 46 90              MOV    word ptr [bp - 0x70], ax     ; UNKNOWN
036F8F  89 46 8E              MOV    word ptr [bp - 0x72], ax     ; UNKNOWN
036F92  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
036F95  89 86 2E FF           MOV    word ptr [bp - 0xd2], ax     ; UNKNOWN
036F99  89 86 30 FF           MOV    word ptr [bp - 0xd0], ax     ; UNKNOWN
036F9D  EB 30                 JMP    0x36fcf                      ; UNKNOWN
036F9F  8B 9E 30 FF           MOV    bx, word ptr [bp - 0xd0]     ; UNKNOWN
036FA3  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
036FA6  83 BF 39 38 00        CMP    word ptr [bx + 0x3839], 0    ; UNKNOWN
036FAB  7E 1E                 JLE    0x36fcb                      ; UNKNOWN
036FAD  8B 87 39 38           MOV    ax, word ptr [bx + 0x3839]   ; UNKNOWN
036FB1  8B B6 2E FF           MOV    si, word ptr [bp - 0xd2]     ; UNKNOWN
036FB5  D1 E6                 SHL    si, 1                        ; UNKNOWN
036FB7  89 82 54 FF           MOV    word ptr [bp + si - 0xac], ax ; UNKNOWN
036FBB  8A 86 30 FF           MOV    al, byte ptr [bp - 0xd0]     ; UNKNOWN
036FBF  8B B6 2E FF           MOV    si, word ptr [bp - 0xd2]     ; UNKNOWN
036FC3  88 82 36 FF           MOV    byte ptr [bp + si - 0xca], al ; UNKNOWN
036FC7  FF 86 2E FF           INC    word ptr [bp - 0xd2]         ; UNKNOWN
036FCB  FF 86 30 FF           INC    word ptr [bp - 0xd0]         ; UNKNOWN
036FCF  83 BE 30 FF 1C        CMP    word ptr [bp - 0xd0], 0x1c   ; UNKNOWN
036FD4  7C C9                 JL     0x36f9f                      ; UNKNOWN
036FD6  8D 86 36 FF           LEA    ax, [bp - 0xca]              ; UNKNOWN
036FDA  16                    PUSH   ss                           ; UNKNOWN
036FDB  50                    PUSH   ax                           ; UNKNOWN
036FDC  8D 86 54 FF           LEA    ax, [bp - 0xac]              ; UNKNOWN
036FE0  16                    PUSH   ss                           ; UNKNOWN
036FE1  50                    PUSH   ax                           ; UNKNOWN
036FE2  8B 86 2E FF           MOV    ax, word ptr [bp - 0xd2]     ; UNKNOWN
036FE6  9A 00 00 DB 5C        LCALL  0x5cdb, 0                    ; UNKNOWN
036FEB  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
036FEF  8D 06 9C 20           LEA    ax, [0x209c]                 ; UNKNOWN
036FF3  2B D2                 SUB    dx, dx                       ; UNKNOWN
036FF5  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
036FFA  89 46 8E              MOV    word ptr [bp - 0x72], ax     ; UNKNOWN
036FFD  89 56 90              MOV    word ptr [bp - 0x70], dx     ; UNKNOWN
037000  0B D0                 OR     dx, ax                       ; UNKNOWN
037002  75 03                 JNE    0x37007                      ; UNKNOWN
037004  E9 31 02              JMP    0x37238                      ; UNKNOWN
037007  C4 5E 8E              LES    bx, ptr [bp - 0x72]          ; UNKNOWN
03700A  26 80 4F 0A 01        OR     byte ptr es:[bx + 0xa], 1    ; UNKNOWN
03700F  26 C7 47 22 08 00     MOV    word ptr es:[bx + 0x22], 8   ; UNKNOWN
037015  C7 86 34 FF 00 00     MOV    word ptr [bp - 0xcc], 0      ; UNKNOWN
03701B  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
03701F  75 08                 JNE    0x37029                      ; UNKNOWN
037021  6A 01                 PUSH   1                            ; UNKNOWN
037023  FF 36 00 33           PUSH   word ptr [0x3300]            ; UNKNOWN
037027  EB 06                 JMP    0x3702f                      ; UNKNOWN
037029  6A 62                 PUSH   0x62                         ; UNKNOWN
03702B  FF 36 A5 3B           PUSH   word ptr [0x3ba5]            ; UNKNOWN
03702F  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
037034  83 C4 02              ADD    sp, 2                        ; UNKNOWN
037037  52                    PUSH   dx                           ; UNKNOWN
037038  50                    PUSH   ax                           ; UNKNOWN
037039  FF 76 90              PUSH   word ptr [bp - 0x70]         ; UNKNOWN
03703C  FF 76 8E              PUSH   word ptr [bp - 0x72]         ; UNKNOWN
03703F  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
037044  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
037047  C7 86 30 FF 00 00     MOV    word ptr [bp - 0xd0], 0      ; UNKNOWN
03704D  E9 02 01              JMP    0x37152                      ; UNKNOWN
037050  8B B6 30 FF           MOV    si, word ptr [bp - 0xd0]     ; UNKNOWN
037054  8A 82 36 FF           MOV    al, byte ptr [bp + si - 0xca] ; UNKNOWN
037058  2A E4                 SUB    ah, ah                       ; UNKNOWN
03705A  89 86 52 FF           MOV    word ptr [bp - 0xae], ax     ; UNKNOWN
03705E  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
037061  F7 6E 8C              IMUL   word ptr [bp - 0x74]         ; UNKNOWN
037064  3B 86 34 FF           CMP    ax, word ptr [bp - 0xcc]     ; UNKNOWN
037068  7E 03                 JLE    0x3706d                      ; UNKNOWN
03706A  E9 DD 00              JMP    0x3714a                      ; UNKNOWN
03706D  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
037070  40                    INC    ax                           ; UNKNOWN
037071  F7 6E 8C              IMUL   word ptr [bp - 0x74]         ; UNKNOWN
037074  3B 86 34 FF           CMP    ax, word ptr [bp - 0xcc]     ; UNKNOWN
037078  7F 03                 JG     0x3707d                      ; UNKNOWN
03707A  E9 CD 00              JMP    0x3714a                      ; UNKNOWN
03707D  C6 46 AA 00           MOV    byte ptr [bp - 0x56], 0      ; UNKNOWN
037081  8B 9E 52 FF           MOV    bx, word ptr [bp - 0xae]     ; UNKNOWN
037085  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
037088  FF B7 35 38           PUSH   word ptr [bx + 0x3835]       ; UNKNOWN
03708C  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
03708F  50                    PUSH   ax                           ; UNKNOWN
037090  8B F3                 MOV    si, bx                       ; UNKNOWN
037092  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
037097  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03709A  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
03709D  50                    PUSH   ax                           ; UNKNOWN
03709E  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
0370A3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0370A6  68 A8 20              PUSH   0x20a8                       ; UNKNOWN
0370A9  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
0370AC  50                    PUSH   ax                           ; UNKNOWN
0370AD  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
0370B2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0370B5  FF 36 14 33           PUSH   word ptr [0x3314]            ; UNKNOWN
0370B9  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
0370BC  50                    PUSH   ax                           ; UNKNOWN
0370BD  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
0370C2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0370C5  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
0370C8  50                    PUSH   ax                           ; UNKNOWN
0370C9  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
0370CE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0370D1  6A 0A                 PUSH   0xa                          ; UNKNOWN
0370D3  8D 46 94              LEA    ax, [bp - 0x6c]              ; UNKNOWN
0370D6  50                    PUSH   ax                           ; UNKNOWN
0370D7  8B 8C 39 38           MOV    cx, word ptr [si + 0x3839]   ; UNKNOWN
0370DB  89 8E 32 FF           MOV    word ptr [bp - 0xce], cx     ; UNKNOWN
0370DF  51                    PUSH   cx                           ; UNKNOWN
0370E0  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
0370E5  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0370E8  8D 46 94              LEA    ax, [bp - 0x6c]              ; UNKNOWN
0370EB  50                    PUSH   ax                           ; UNKNOWN
0370EC  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
0370EF  50                    PUSH   ax                           ; UNKNOWN
0370F0  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
0370F5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0370F8  FF 36 16 33           PUSH   word ptr [0x3316]            ; UNKNOWN
0370FC  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
0370FF  50                    PUSH   ax                           ; UNKNOWN
037100  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
037105  83 C4 04              ADD    sp, 4                        ; UNKNOWN
037108  8B 86 52 FF           MOV    ax, word ptr [bp - 0xae]     ; UNKNOWN
03710C  40                    INC    ax                           ; UNKNOWN
03710D  40                    INC    ax                           ; UNKNOWN
03710E  50                    PUSH   ax                           ; UNKNOWN
03710F  8D 4E AA              LEA    cx, [bp - 0x56]              ; UNKNOWN
037112  16                    PUSH   ss                           ; UNKNOWN
037113  51                    PUSH   cx                           ; UNKNOWN
037114  FF 76 90              PUSH   word ptr [bp - 0x70]         ; UNKNOWN
037117  FF 76 8E              PUSH   word ptr [bp - 0x72]         ; UNKNOWN
03711A  8B F0                 MOV    si, ax                       ; UNKNOWN
03711C  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
037121  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
037124  8B 86 32 FF           MOV    ax, word ptr [bp - 0xce]     ; UNKNOWN
037128  99                    CDQ                                 ; UNKNOWN
037129  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
03712D  39 57 2C              CMP    word ptr [bx + 0x2c], dx     ; UNKNOWN
037130  7F 18                 JG     0x3714a                      ; UNKNOWN
037132  7C 05                 JL     0x37139                      ; UNKNOWN
037134  39 47 2A              CMP    word ptr [bx + 0x2a], ax     ; UNKNOWN
037137  73 11                 JAE    0x3714a                      ; UNKNOWN
037139  6A 01                 PUSH   1                            ; UNKNOWN
03713B  56                    PUSH   si                           ; UNKNOWN
03713C  FF 76 90              PUSH   word ptr [bp - 0x70]         ; UNKNOWN
03713F  FF 76 8E              PUSH   word ptr [bp - 0x72]         ; UNKNOWN
037142  9A E6 08 97 1B        LCALL  0x1b97, 0x8e6                ; UNKNOWN
037147  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03714A  FF 86 34 FF           INC    word ptr [bp - 0xcc]         ; UNKNOWN
03714E  FF 86 30 FF           INC    word ptr [bp - 0xd0]         ; UNKNOWN
037152  8B 86 2E FF           MOV    ax, word ptr [bp - 0xd2]     ; UNKNOWN
037156  39 86 30 FF           CMP    word ptr [bp - 0xd0], ax     ; UNKNOWN
03715A  7D 03                 JGE    0x3715f                      ; UNKNOWN
03715C  E9 F1 FE              JMP    0x37050                      ; UNKNOWN
03715F  8B 46 92              MOV    ax, word ptr [bp - 0x6e]     ; UNKNOWN
037162  48                    DEC    ax                           ; UNKNOWN
037163  3B 46 FE              CMP    ax, word ptr [bp - 2]        ; UNKNOWN
037166  7E 1E                 JLE    0x37186                      ; UNKNOWN
037168  6A 63                 PUSH   0x63                         ; UNKNOWN
03716A  FF 36 A5 3B           PUSH   word ptr [0x3ba5]            ; UNKNOWN
03716E  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
037173  83 C4 02              ADD    sp, 2                        ; UNKNOWN
037176  52                    PUSH   dx                           ; UNKNOWN
037177  50                    PUSH   ax                           ; UNKNOWN
037178  FF 76 90              PUSH   word ptr [bp - 0x70]         ; UNKNOWN
03717B  FF 76 8E              PUSH   word ptr [bp - 0x72]         ; UNKNOWN
03717E  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
037183  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
037186  C7 06 0E 0A 01 00     MOV    word ptr [0xa0e], 1          ; UNKNOWN
03718C  FF 76 90              PUSH   word ptr [bp - 0x70]         ; UNKNOWN
03718F  FF 76 8E              PUSH   word ptr [bp - 0x72]         ; UNKNOWN
037192  9A 4A 25 97 1B        LCALL  0x1b97, 0x254a               ; UNKNOWN
037197  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
03719A  FF 76 90              PUSH   word ptr [bp - 0x70]         ; UNKNOWN
03719D  FF 76 8E              PUSH   word ptr [bp - 0x72]         ; UNKNOWN
0371A0  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
0371A5  2B C0                 SUB    ax, ax                       ; UNKNOWN
0371A7  89 46 90              MOV    word ptr [bp - 0x70], ax     ; UNKNOWN
0371AA  89 46 8E              MOV    word ptr [bp - 0x72], ax     ; UNKNOWN
0371AD  83 7E A8 02           CMP    word ptr [bp - 0x58], 2      ; UNKNOWN
0371B1  7D 03                 JGE    0x371b6                      ; UNKNOWN
0371B3  E9 82 00              JMP    0x37238                      ; UNKNOWN
0371B6  83 7E A8 62           CMP    word ptr [bp - 0x58], 0x62   ; UNKNOWN
0371BA  75 03                 JNE    0x371bf                      ; UNKNOWN
0371BC  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
0371BF  83 7E A8 63           CMP    word ptr [bp - 0x58], 0x63   ; UNKNOWN
0371C3  75 03                 JNE    0x371c8                      ; UNKNOWN
0371C5  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
0371C8  39 06 10 0A           CMP    word ptr [0xa10], ax         ; UNKNOWN
0371CC  74 21                 JE     0x371ef                      ; UNKNOWN
0371CE  83 7E A8 62           CMP    word ptr [bp - 0x58], 0x62   ; UNKNOWN
0371D2  74 1B                 JE     0x371ef                      ; UNKNOWN
0371D4  83 7E A8 63           CMP    word ptr [bp - 0x58], 0x63   ; UNKNOWN
0371D8  74 15                 JE     0x371ef                      ; UNKNOWN
0371DA  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
0371DD  48                    DEC    ax                           ; UNKNOWN
0371DE  48                    DEC    ax                           ; UNKNOWN
0371DF  50                    PUSH   ax                           ; UNKNOWN
0371E0  9A 06 18 A2 3F        LCALL  0x3fa2, 0x1806               ; UNKNOWN
0371E5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0371E8  0E                    PUSH   cs                           ; UNKNOWN
0371E9  E8 6A D5              CALL   0x34756                      ; UNKNOWN
0371EC  E9 FC FD              JMP    0x36feb                      ; UNKNOWN
0371EF  83 7E A8 62           CMP    word ptr [bp - 0x58], 0x62   ; UNKNOWN
0371F3  7C 03                 JL     0x371f8                      ; UNKNOWN
0371F5  E9 F3 FD              JMP    0x36feb                      ; UNKNOWN
0371F8  8B 5E A8              MOV    bx, word ptr [bp - 0x58]     ; UNKNOWN
0371FB  4B                    DEC    bx                           ; UNKNOWN
0371FC  4B                    DEC    bx                           ; UNKNOWN
0371FD  89 5E FC              MOV    word ptr [bp - 4], bx        ; UNKNOWN
037200  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
037203  8B 87 39 38           MOV    ax, word ptr [bx + 0x3839]   ; UNKNOWN
037207  89 86 32 FF           MOV    word ptr [bp - 0xce], ax     ; UNKNOWN
03720B  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
03720E  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
037211  50                    PUSH   ax                           ; UNKNOWN
037212  0E                    PUSH   cs                           ; UNKNOWN
037213  E8 1E C3              CALL   0x33534                      ; UNKNOWN
