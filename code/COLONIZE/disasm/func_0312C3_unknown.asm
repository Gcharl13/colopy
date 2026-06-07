; ============================================================================
; func_0312C3_unknown
; Region   : load_image
; Bytes    : file 0x0312C3..0x0313F2  (303 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0312C3  C8 1A 00 00           ENTER  0x1a, 0                      ; UNKNOWN
0312C7  56                    PUSH   si                           ; UNKNOWN
0312C8  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
0312CD  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0312D0  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
0312D3  50                    PUSH   ax                           ; UNKNOWN
0312D4  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
0312D9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0312DC  0B C0                 OR     ax, ax                       ; UNKNOWN
0312DE  74 0B                 JE     0x312eb                      ; UNKNOWN
0312E0  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; UNKNOWN
0312E5  A1 1F 39              MOV    ax, word ptr [0x391f]        ; UNKNOWN
0312E8  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
0312EB  6A 02                 PUSH   2                            ; UNKNOWN
0312ED  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
0312F2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0312F5  0B C0                 OR     ax, ax                       ; UNKNOWN
0312F7  74 09                 JE     0x31302                      ; UNKNOWN
0312F9  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
0312FC  A1 2B 39              MOV    ax, word ptr [0x392b]        ; UNKNOWN
0312FF  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
031302  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
031306  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
031309  2A E4                 SUB    ah, ah                       ; UNKNOWN
03130B  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
03130E  8A 4F 1A              MOV    cl, byte ptr [bx + 0x1a]     ; UNKNOWN
031311  2A ED                 SUB    ch, ch                       ; UNKNOWN
031313  89 4E E6              MOV    word ptr [bp - 0x1a], cx     ; UNKNOWN
031316  8B D0                 MOV    dx, ax                       ; UNKNOWN
031318  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
03131A  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
03131D  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
031322  EB 12                 JMP    0x31336                      ; UNKNOWN
031324  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
031327  80 BF 82 88 0B        CMP    byte ptr [bx - 0x777e], 0xb  ; UNKNOWN
03132C  75 03                 JNE    0x31331                      ; UNKNOWN
03132E  FF 46 F0              INC    word ptr [bp - 0x10]         ; UNKNOWN
031331  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
031336  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
031339  0B C0                 OR     ax, ax                       ; UNKNOWN
03133B  7D E7                 JGE    0x31324                      ; UNKNOWN
03133D  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
031340  F7 6E F6              IMUL   word ptr [bp - 0xa]          ; UNKNOWN
031343  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
031346  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
031349  0B C0                 OR     ax, ax                       ; UNKNOWN
03134B  75 03                 JNE    0x31350                      ; UNKNOWN
03134D  E9 AC 01              JMP    0x314fc                      ; UNKNOWN
031350  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; UNKNOWN
031355  EB 2A                 JMP    0x31381                      ; UNKNOWN
031357  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; UNKNOWN
03135B  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
031360  72 07                 JB     0x31369                      ; UNKNOWN
031362  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
031367  76 0F                 JBE    0x31378                      ; UNKNOWN
031369  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
03136C  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
031371  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
031374  0B C0                 OR     ax, ax                       ; UNKNOWN
031376  7D DF                 JGE    0x31357                      ; UNKNOWN
031378  83 7E E8 00           CMP    word ptr [bp - 0x18], 0      ; UNKNOWN
03137C  7D 40                 JGE    0x313be                      ; UNKNOWN
03137E  FF 46 F4              INC    word ptr [bp - 0xc]          ; UNKNOWN
031381  83 7E F4 08           CMP    word ptr [bp - 0xc], 8       ; UNKNOWN
031385  7C 03                 JL     0x3138a                      ; UNKNOWN
031387  E9 72 01              JMP    0x314fc                      ; UNKNOWN
03138A  8B 5E F4              MOV    bx, word ptr [bp - 0xc]      ; UNKNOWN
03138D  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
031391  98                    CWDE                                ; UNKNOWN
031392  03 46 EC              ADD    ax, word ptr [bp - 0x14]     ; UNKNOWN
031395  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
031398  50                    PUSH   ax                           ; UNKNOWN
031399  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
03139D  98                    CWDE                                ; UNKNOWN
03139E  03 46 EE              ADD    ax, word ptr [bp - 0x12]     ; UNKNOWN
0313A1  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0313A4  50                    PUSH   ax                           ; UNKNOWN
0313A5  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
0313AA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0313AD  0B C0                 OR     ax, ax                       ; UNKNOWN
0313AF  74 CD                 JE     0x3137e                      ; UNKNOWN
0313B1  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0313B4  8B 56 F8              MOV    dx, word ptr [bp - 8]        ; UNKNOWN
0313B7  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
0313BC  EB B3                 JMP    0x31371                      ; UNKNOWN
0313BE  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; UNKNOWN
0313C2  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
0313C6  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
0313C9  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0313CC  3B 46 E6              CMP    ax, word ptr [bp - 0x1a]     ; UNKNOWN
0313CF  74 AD                 JE     0x3137e                      ; UNKNOWN
0313D1  50                    PUSH   ax                           ; UNKNOWN
0313D2  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
0313D5  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
0313DA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0313DD  A8 40                 TEST   al, 0x40                     ; UNKNOWN
0313DF  74 0B                 JE     0x313ec                      ; UNKNOWN
0313E1  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; UNKNOWN
0313E5  80 BF 82 88 10        CMP    byte ptr [bx - 0x777e], 0x10 ; UNKNOWN
0313EA  75 92                 JNE    0x3137e                      ; UNKNOWN
0313EC  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; UNKNOWN
0313F0  8B C3                 MOV    ax, bx                       ; UNKNOWN
