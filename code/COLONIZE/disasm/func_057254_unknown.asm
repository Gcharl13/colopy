; ============================================================================
; func_057254_unknown
; Region   : load_image
; Bytes    : file 0x057254..0x057435  (481 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

057254  C8 72 00 00           ENTER  0x72, 0                      ; UNKNOWN
057258  57                    PUSH   di                           ; UNKNOWN
057259  56                    PUSH   si                           ; UNKNOWN
05725A  C7 46 9C FF FF        MOV    word ptr [bp - 0x64], 0xffff ; UNKNOWN
05725F  2B C0                 SUB    ax, ax                       ; UNKNOWN
057261  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
057264  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
057267  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
05726B  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
05726F  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
057272  89 46 96              MOV    word ptr [bp - 0x6a], ax     ; UNKNOWN
057275  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
057279  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
05727D  2A E4                 SUB    ah, ah                       ; UNKNOWN
05727F  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
057282  C7 06 DE CD 00 00     MOV    word ptr [0xcdde], 0         ; UNKNOWN
057288  0B C0                 OR     ax, ax                       ; UNKNOWN
05728A  75 03                 JNE    0x5728f                      ; UNKNOWN
05728C  E9 9F 01              JMP    0x5742e                      ; UNKNOWN
05728F  C7 46 9C 00 00        MOV    word ptr [bp - 0x64], 0      ; UNKNOWN
057294  B8 01 00              MOV    ax, 1                        ; UNKNOWN
057297  A3 DE CD              MOV    word ptr [0xcdde], ax        ; UNKNOWN
05729A  50                    PUSH   ax                           ; UNKNOWN
05729B  50                    PUSH   ax                           ; UNKNOWN
05729C  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
05729F  9A 0C 00 C1 3D        LCALL  0x3dc1, 0xc                  ; UNKNOWN
0572A4  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0572A7  3B 46 98              CMP    ax, word ptr [bp - 0x68]     ; UNKNOWN
0572AA  7C 03                 JL     0x572af                      ; UNKNOWN
0572AC  E9 7F 01              JMP    0x5742e                      ; UNKNOWN
0572AF  83 7E 96 04           CMP    word ptr [bp - 0x6a], 4      ; UNKNOWN
0572B3  7C 03                 JL     0x572b8                      ; UNKNOWN
0572B5  E9 06 01              JMP    0x573be                      ; UNKNOWN
0572B8  6B 5E 96 34           IMUL   bx, word ptr [bp - 0x6a], 0x34 ; UNKNOWN
0572BC  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
0572C1  74 03                 JE     0x572c6                      ; UNKNOWN
0572C3  E9 F8 00              JMP    0x573be                      ; UNKNOWN
0572C6  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0572CA  8D 06 52 2B           LEA    ax, [0x2b52]                 ; UNKNOWN
0572CE  2B D2                 SUB    dx, dx                       ; UNKNOWN
0572D0  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
0572D5  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
0572D8  89 56 A2              MOV    word ptr [bp - 0x5e], dx     ; UNKNOWN
0572DB  0B D0                 OR     dx, ax                       ; UNKNOWN
0572DD  75 03                 JNE    0x572e2                      ; UNKNOWN
0572DF  E9 4C 01              JMP    0x5742e                      ; UNKNOWN
0572E2  6A 63                 PUSH   0x63                         ; UNKNOWN
0572E4  FF 36 3A 33           PUSH   word ptr [0x333a]            ; UNKNOWN
0572E8  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
0572ED  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0572F0  52                    PUSH   dx                           ; UNKNOWN
0572F1  50                    PUSH   ax                           ; UNKNOWN
0572F2  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
0572F5  FF 76 A0              PUSH   word ptr [bp - 0x60]         ; UNKNOWN
0572F8  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
0572FD  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
057300  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0      ; UNKNOWN
057305  EB 70                 JMP    0x57377                      ; UNKNOWN
057307  FF 76 9A              PUSH   word ptr [bp - 0x66]         ; UNKNOWN
05730A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05730D  9A 92 2F 5F 24        LCALL  0x245f, 0x2f92               ; UNKNOWN
057312  83 C4 04              ADD    sp, 4                        ; UNKNOWN
057315  89 46 94              MOV    word ptr [bp - 0x6c], ax     ; UNKNOWN
057318  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
05731C  FF 76 9A              PUSH   word ptr [bp - 0x66]         ; UNKNOWN
05731F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
057322  9A DF 2F 5F 24        LCALL  0x245f, 0x2fdf               ; UNKNOWN
057327  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05732A  89 46 9E              MOV    word ptr [bp - 0x62], ax     ; UNKNOWN
05732D  50                    PUSH   ax                           ; UNKNOWN
05732E  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
057331  16                    PUSH   ss                           ; UNKNOWN
057332  50                    PUSH   ax                           ; UNKNOWN
057333  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
057338  83 C4 06              ADD    sp, 6                        ; UNKNOWN
05733B  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
05733E  50                    PUSH   ax                           ; UNKNOWN
05733F  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
057344  83 C4 02              ADD    sp, 2                        ; UNKNOWN
057347  8B 5E 94              MOV    bx, word ptr [bp - 0x6c]     ; UNKNOWN
05734A  D1 E3                 SHL    bx, 1                        ; UNKNOWN
05734C  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
057350  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
057353  50                    PUSH   ax                           ; UNKNOWN
057354  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
057359  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05735C  8B 46 9A              MOV    ax, word ptr [bp - 0x66]     ; UNKNOWN
05735F  40                    INC    ax                           ; UNKNOWN
057360  50                    PUSH   ax                           ; UNKNOWN
057361  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
057364  16                    PUSH   ss                           ; UNKNOWN
057365  50                    PUSH   ax                           ; UNKNOWN
057366  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
057369  FF 76 A0              PUSH   word ptr [bp - 0x60]         ; UNKNOWN
05736C  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
057371  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
057374  FF 46 9A              INC    word ptr [bp - 0x66]         ; UNKNOWN
057377  8B 46 98              MOV    ax, word ptr [bp - 0x68]     ; UNKNOWN
05737A  39 46 9A              CMP    word ptr [bp - 0x66], ax     ; UNKNOWN
05737D  7C 88                 JL     0x57307                      ; UNKNOWN
05737F  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
057382  FF 76 A0              PUSH   word ptr [bp - 0x60]         ; UNKNOWN
057385  9A 4A 25 97 1B        LCALL  0x1b97, 0x254a               ; UNKNOWN
05738A  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
05738D  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
057390  FF 76 A0              PUSH   word ptr [bp - 0x60]         ; UNKNOWN
057393  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
057398  83 7E 9C 63           CMP    word ptr [bp - 0x64], 0x63   ; UNKNOWN
05739C  75 08                 JNE    0x573a6                      ; UNKNOWN
05739E  C7 46 9C FF FF        MOV    word ptr [bp - 0x64], 0xffff ; UNKNOWN
0573A3  E9 88 00              JMP    0x5742e                      ; UNKNOWN
0573A6  83 7E 9C 00           CMP    word ptr [bp - 0x64], 0      ; UNKNOWN
0573AA  7E 0B                 JLE    0x573b7                      ; UNKNOWN
0573AC  C7 06 DE CD 00 00     MOV    word ptr [0xcdde], 0         ; UNKNOWN
0573B2  FF 4E 9C              DEC    word ptr [bp - 0x64]         ; UNKNOWN
0573B5  EB 77                 JMP    0x5742e                      ; UNKNOWN
0573B7  C7 46 9C 00 00        MOV    word ptr [bp - 0x64], 0      ; UNKNOWN
0573BC  EB 70                 JMP    0x5742e                      ; UNKNOWN
0573BE  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0      ; UNKNOWN
0573C3  EB 45                 JMP    0x5740a                      ; UNKNOWN
0573C5  FF 76 9A              PUSH   word ptr [bp - 0x66]         ; UNKNOWN
0573C8  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0573CB  9A 92 2F 5F 24        LCALL  0x245f, 0x2f92               ; UNKNOWN
0573D0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0573D3  89 46 94              MOV    word ptr [bp - 0x6c], ax     ; UNKNOWN
0573D6  FF 76 9A              PUSH   word ptr [bp - 0x66]         ; UNKNOWN
0573D9  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0573DC  9A DF 2F 5F 24        LCALL  0x245f, 0x2fdf               ; UNKNOWN
0573E1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0573E4  89 46 9E              MOV    word ptr [bp - 0x62], ax     ; UNKNOWN
0573E7  8A 46 9A              MOV    al, byte ptr [bp - 0x66]     ; UNKNOWN
0573EA  8B 76 9A              MOV    si, word ptr [bp - 0x66]     ; UNKNOWN
0573ED  88 42 8E              MOV    byte ptr [bp + si - 0x72], al ; UNKNOWN
0573F0  8B 7E 96              MOV    di, word ptr [bp - 0x6a]     ; UNKNOWN
0573F3  C1 E7 04              SHL    di, 4                        ; UNKNOWN
0573F6  8B 5E 94              MOV    bx, word ptr [bp - 0x6c]     ; UNKNOWN
0573F9  8A 81 68 74           MOV    al, byte ptr [bx + di + 0x7468] ; UNKNOWN
0573FD  2A E4                 SUB    ah, ah                       ; UNKNOWN
0573FF  F7 6E 9E              IMUL   word ptr [bp - 0x62]         ; UNKNOWN
057402  D1 E6                 SHL    si, 1                        ; UNKNOWN
057404  89 42 A4              MOV    word ptr [bp + si - 0x5c], ax ; UNKNOWN
057407  FF 46 9A              INC    word ptr [bp - 0x66]         ; UNKNOWN
05740A  8B 46 98              MOV    ax, word ptr [bp - 0x68]     ; UNKNOWN
05740D  39 46 9A              CMP    word ptr [bp - 0x66], ax     ; UNKNOWN
057410  7C B3                 JL     0x573c5                      ; UNKNOWN
057412  8D 46 8E              LEA    ax, [bp - 0x72]              ; UNKNOWN
057415  16                    PUSH   ss                           ; UNKNOWN
057416  50                    PUSH   ax                           ; UNKNOWN
057417  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
05741A  16                    PUSH   ss                           ; UNKNOWN
05741B  50                    PUSH   ax                           ; UNKNOWN
05741C  8B 46 98              MOV    ax, word ptr [bp - 0x68]     ; UNKNOWN
05741F  9A 00 00 DB 5C        LCALL  0x5cdb, 0                    ; UNKNOWN
057424  8B 76 98              MOV    si, word ptr [bp - 0x68]     ; UNKNOWN
057427  8A 42 8D              MOV    al, byte ptr [bp + si - 0x73] ; UNKNOWN
05742A  98                    CWDE                                ; UNKNOWN
05742B  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
05742E  8B 46 9C              MOV    ax, word ptr [bp - 0x64]     ; UNKNOWN
057431  5E                    POP    si                           ; UNKNOWN
057432  5F                    POP    di                           ; UNKNOWN
057433  C9                    LEAVE                               ; UNKNOWN
057434  CB                    RETF                                ; UNKNOWN
