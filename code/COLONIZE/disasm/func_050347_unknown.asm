; ============================================================================
; func_050347_unknown
; Region   : load_image
; Bytes    : file 0x050347..0x0503DE  (151 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

050347  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
05034B  56                    PUSH   si                           ; UNKNOWN
05034C  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
050351  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
050355  7D 02                 JGE    0x50359                      ; UNKNOWN
050357  EB 7F                 JMP    0x503d8                      ; UNKNOWN
050359  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
05035C  D1 E3                 SHL    bx, 1                        ; UNKNOWN
05035E  8B 87 14 83           MOV    ax, word ptr [bx - 0x7cec]   ; UNKNOWN
050362  B9 0C 00              MOV    cx, 0xc                      ; UNKNOWN
050365  99                    CDQ                                 ; UNKNOWN
050366  F7 F9                 IDIV   cx                           ; UNKNOWN
050368  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
05036B  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
05036E  8A 87 07 87           MOV    al, byte ptr [bx - 0x78f9]   ; UNKNOWN
050372  2A E4                 SUB    ah, ah                       ; UNKNOWN
050374  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
050377  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
05037C  8B 76 FC              MOV    si, word ptr [bp - 4]        ; UNKNOWN
05037F  C1 E6 04              SHL    si, 4                        ; UNKNOWN
050382  8A 80 57 87           MOV    al, byte ptr [bx + si - 0x78a9] ; UNKNOWN
050386  2A E4                 SUB    ah, ah                       ; UNKNOWN
050388  01 46 FA              ADD    word ptr [bp - 6], ax        ; UNKNOWN
05038B  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
05038E  83 7E FC 04           CMP    word ptr [bp - 4], 4         ; UNKNOWN
050392  7C E8                 JL     0x5037c                      ; UNKNOWN
050394  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
050397  2B 46 FA              SUB    ax, word ptr [bp - 6]        ; UNKNOWN
05039A  0B C0                 OR     ax, ax                       ; UNKNOWN
05039C  7E 05                 JLE    0x503a3                      ; UNKNOWN
05039E  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0503A1  EB 0F                 JMP    0x503b2                      ; UNKNOWN
0503A3  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
0503A6  2B 46 FA              SUB    ax, word ptr [bp - 6]        ; UNKNOWN
0503A9  78 04                 JS     0x503af                      ; UNKNOWN
0503AB  2B C0                 SUB    ax, ax                       ; UNKNOWN
0503AD  EB 03                 JMP    0x503b2                      ; UNKNOWN
0503AF  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
0503B2  01 46 F6              ADD    word ptr [bp - 0xa], ax      ; UNKNOWN
0503B5  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0503B8  8A 87 07 87           MOV    al, byte ptr [bx - 0x78f9]   ; UNKNOWN
0503BC  2A E4                 SUB    ah, ah                       ; UNKNOWN
0503BE  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
0503C1  75 04                 JNE    0x503c7                      ; UNKNOWN
0503C3  83 46 F6 02           ADD    word ptr [bp - 0xa], 2       ; UNKNOWN
0503C7  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0503CA  C1 E6 04              SHL    si, 4                        ; UNKNOWN
0503CD  80 B8 57 87 01        CMP    byte ptr [bx + si - 0x78a9], 1 ; UNKNOWN
0503D2  73 04                 JAE    0x503d8                      ; UNKNOWN
0503D4  83 46 F6 04           ADD    word ptr [bp - 0xa], 4       ; UNKNOWN
0503D8  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
0503DB  5E                    POP    si                           ; UNKNOWN
0503DC  C9                    LEAVE                               ; UNKNOWN
0503DD  CB                    RETF                                ; UNKNOWN
