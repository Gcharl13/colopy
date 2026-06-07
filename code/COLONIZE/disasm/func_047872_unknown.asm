; ============================================================================
; func_047872_unknown
; Region   : load_image
; Bytes    : file 0x047872..0x047A17  (421 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

047872  C8 2A 00 00           ENTER  0x2a, 0                      ; UNKNOWN
047876  56                    PUSH   si                           ; UNKNOWN
047877  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04787B  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
04787F  2A E4                 SUB    ah, ah                       ; UNKNOWN
047881  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
047884  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
047888  2A ED                 SUB    ch, ch                       ; UNKNOWN
04788A  89 4E E6              MOV    word ptr [bp - 0x1a], cx     ; UNKNOWN
04788D  51                    PUSH   cx                           ; UNKNOWN
04788E  50                    PUSH   ax                           ; UNKNOWN
04788F  8B F3                 MOV    si, bx                       ; UNKNOWN
047891  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
047896  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047899  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
04789C  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
04789F  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
0478A2  9A EC 00 C9 33        LCALL  0x33c9, 0xec                 ; UNKNOWN
0478A7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0478AA  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
0478AD  89 56 DE              MOV    word ptr [bp - 0x22], dx     ; UNKNOWN
0478B0  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
0478B3  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
0478B6  9A 20 01 C9 33        LCALL  0x33c9, 0x120                ; UNKNOWN
0478BB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0478BE  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0478C1  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
0478C4  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
0478C7  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
0478CA  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
0478CF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0478D2  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
0478D5  8A 84 83 88           MOV    al, byte ptr [si - 0x777d]   ; UNKNOWN
0478D9  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
0478DC  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
0478DF  83 7E F2 08           CMP    word ptr [bp - 0xe], 8       ; UNKNOWN
0478E3  7C 06                 JL     0x478eb                      ; UNKNOWN
0478E5  83 7E F2 10           CMP    word ptr [bp - 0xe], 0x10    ; UNKNOWN
0478E9  7C 0C                 JL     0x478f7                      ; UNKNOWN
0478EB  83 7E F2 10           CMP    word ptr [bp - 0xe], 0x10    ; UNKNOWN
0478EF  7C 0D                 JL     0x478fe                      ; UNKNOWN
0478F1  83 7E F2 18           CMP    word ptr [bp - 0xe], 0x18    ; UNKNOWN
0478F5  7D 07                 JGE    0x478fe                      ; UNKNOWN
0478F7  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; UNKNOWN
0478FC  EB 2C                 JMP    0x4792a                      ; UNKNOWN
0478FE  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
047901  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
047904  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
047909  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04790C  A8 40                 TEST   al, 0x40                     ; UNKNOWN
04790E  74 03                 JE     0x47913                      ; UNKNOWN
047910  E9 D0 02              JMP    0x47be3                      ; UNKNOWN
047913  83 7E F2 19           CMP    word ptr [bp - 0xe], 0x19    ; UNKNOWN
047917  75 03                 JNE    0x4791c                      ; UNKNOWN
047919  E9 C7 02              JMP    0x47be3                      ; UNKNOWN
04791C  83 7E F2 1A           CMP    word ptr [bp - 0xe], 0x1a    ; UNKNOWN
047920  75 03                 JNE    0x47925                      ; UNKNOWN
047922  E9 BE 02              JMP    0x47be3                      ; UNKNOWN
047925  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1       ; UNKNOWN
04792A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04792D  9A 35 15 B7 36        LCALL  0x36b7, 0x1535               ; UNKNOWN
047932  83 C4 02              ADD    sp, 2                        ; UNKNOWN
047935  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
047939  FE 87 96 88           INC    byte ptr [bx - 0x776a]       ; UNKNOWN
04793D  8B 76 F2              MOV    si, word ptr [bp - 0xe]      ; UNKNOWN
047940  C1 E6 04              SHL    si, 4                        ; UNKNOWN
047943  8A 84 B8 34           MOV    al, byte ptr [si + 0x34b8]   ; UNKNOWN
047947  2A E4                 SUB    ah, ah                       ; UNKNOWN
047949  40                    INC    ax                           ; UNKNOWN
04794A  40                    INC    ax                           ; UNKNOWN
04794B  89 46 D8              MOV    word ptr [bp - 0x28], ax     ; UNKNOWN
04794E  80 BF 97 88 14        CMP    byte ptr [bx - 0x7769], 0x14 ; UNKNOWN
047953  75 05                 JNE    0x4795a                      ; UNKNOWN
047955  B8 01 00              MOV    ax, 1                        ; UNKNOWN
047958  EB 02                 JMP    0x4795c                      ; UNKNOWN
04795A  2B C0                 SUB    ax, ax                       ; UNKNOWN
04795C  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
04795F  0B C0                 OR     ax, ax                       ; UNKNOWN
047961  74 08                 JE     0x4796b                      ; UNKNOWN
047963  8B 46 D8              MOV    ax, word ptr [bp - 0x28]     ; UNKNOWN
047966  D1 F8                 SAR    ax, 1                        ; UNKNOWN
047968  89 46 D8              MOV    word ptr [bp - 0x28], ax     ; UNKNOWN
04796B  8A 46 D8              MOV    al, byte ptr [bp - 0x28]     ; UNKNOWN
04796E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
047972  38 87 96 88           CMP    byte ptr [bx - 0x776a], al   ; UNKNOWN
047976  73 03                 JAE    0x4797b                      ; UNKNOWN
047978  E9 71 02              JMP    0x47bec                      ; UNKNOWN
04797B  2A C0                 SUB    al, al                       ; UNKNOWN
04797D  88 87 96 88           MOV    byte ptr [bx - 0x776a], al   ; UNKNOWN
047981  88 87 88 88           MOV    byte ptr [bx - 0x7778], al   ; UNKNOWN
047985  83 3E 16 3E 00        CMP    word ptr [0x3e16], 0         ; UNKNOWN
04798A  75 03                 JNE    0x4798f                      ; UNKNOWN
04798C  E9 DE 00              JMP    0x47a6d                      ; UNKNOWN
04798F  83 7E F4 00           CMP    word ptr [bp - 0xc], 0       ; UNKNOWN
047993  74 03                 JE     0x47998                      ; UNKNOWN
047995  E9 D5 00              JMP    0x47a6d                      ; UNKNOWN
047998  6A FF                 PUSH   -1                           ; UNKNOWN
04799A  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
04799E  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
0479A1  50                    PUSH   ax                           ; UNKNOWN
0479A2  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
0479A5  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
0479A8  9A 45 01 5F 24        LCALL  0x245f, 0x145                ; UNKNOWN
0479AD  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0479B0  0B C0                 OR     ax, ax                       ; UNKNOWN
0479B2  7D 03                 JGE    0x479b7                      ; UNKNOWN
0479B4  E9 B6 00              JMP    0x47a6d                      ; UNKNOWN
0479B7  83 3E 78 73 03        CMP    word ptr [0x7378], 3         ; UNKNOWN
0479BC  7E 03                 JLE    0x479c1                      ; UNKNOWN
0479BE  E9 AC 00              JMP    0x47a6d                      ; UNKNOWN
0479C1  8B 5E F2              MOV    bx, word ptr [bp - 0xe]      ; UNKNOWN
0479C4  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
0479C7  8A 87 C0 34           MOV    al, byte ptr [bx + 0x34c0]   ; UNKNOWN
0479CB  2A E4                 SUB    ah, ah                       ; UNKNOWN
0479CD  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
0479D0  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0479D4  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
0479D7  50                    PUSH   ax                           ; UNKNOWN
0479D8  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
0479DA  50                    PUSH   ax                           ; UNKNOWN
0479DB  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
0479E0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0479E3  A8 0A                 TEST   al, 0xa                      ; UNKNOWN
0479E5  74 03                 JE     0x479ea                      ; UNKNOWN
0479E7  FF 46 EE              INC    word ptr [bp - 0x12]         ; UNKNOWN
0479EA  6A 24                 PUSH   0x24                         ; UNKNOWN
0479EC  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
0479F1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0479F4  0B C0                 OR     ax, ax                       ; UNKNOWN
0479F6  75 05                 JNE    0x479fd                      ; UNKNOWN
0479F8  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; UNKNOWN
0479FD  9A 3B 0A 5F 24        LCALL  0x245f, 0xa3b                ; UNKNOWN
047A02  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
047A06  2B 87 A4 00           SUB    ax, word ptr [bx + 0xa4]     ; UNKNOWN
047A0A  8A 4E EC              MOV    cl, byte ptr [bp - 0x14]     ; UNKNOWN
047A0D  6B 56 EE 14           IMUL   dx, word ptr [bp - 0x12], 0x14 ; UNKNOWN
047A11  D3 E2                 SHL    dx, cl                       ; UNKNOWN
047A13  3B C2                 CMP    ax, dx                       ; UNKNOWN
047A15  7E 02                 JLE    0x47a19                      ; UNKNOWN
