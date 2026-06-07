; ============================================================================
; func_04021E_unknown
; Region   : load_image
; Bytes    : file 0x04021E..0x0402E3  (197 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04021E  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
040222  57                    PUSH   di                           ; UNKNOWN
040223  56                    PUSH   si                           ; UNKNOWN
040224  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
040227  BE FF FF              MOV    si, 0xffff                   ; UNKNOWN
04022A  83 FF 04              CMP    di, 4                        ; UNKNOWN
04022D  7D 0A                 JGE    0x40239                      ; UNKNOWN
04022F  6B DF 34              IMUL   bx, di, 0x34                 ; UNKNOWN
040232  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
040237  74 0B                 JE     0x40244                      ; UNKNOWN
040239  81 3E 14 3E F7 01     CMP    word ptr [0x3e14], 0x1f7     ; UNKNOWN
04023F  7C 03                 JL     0x40244                      ; UNKNOWN
040241  E9 42 01              JMP    0x40386                      ; UNKNOWN
040244  81 3E 14 3E FF 01     CMP    word ptr [0x3e14], 0x1ff     ; UNKNOWN
04024A  7C 03                 JL     0x4024f                      ; UNKNOWN
04024C  E9 1F 01              JMP    0x4036e                      ; UNKNOWN
04024F  83 FF 04              CMP    di, 4                        ; UNKNOWN
040252  7D 0A                 JGE    0x4025e                      ; UNKNOWN
040254  80 BD 92 85 FF        CMP    byte ptr [di - 0x7a6e], 0xff ; UNKNOWN
040259  76 03                 JBE    0x4025e                      ; UNKNOWN
04025B  E9 10 01              JMP    0x4036e                      ; UNKNOWN
04025E  8B 36 14 3E           MOV    si, word ptr [0x3e14]        ; UNKNOWN
040262  FF 06 14 3E           INC    word ptr [0x3e14]            ; UNKNOWN
040266  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
040269  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
04026C  89 5E FC              MOV    word ptr [bp - 4], bx        ; UNKNOWN
04026F  88 87 82 88           MOV    byte ptr [bx - 0x777e], al   ; UNKNOWN
040273  8B C7                 MOV    ax, di                       ; UNKNOWN
040275  88 87 83 88           MOV    byte ptr [bx - 0x777d], al   ; UNKNOWN
040279  C6 87 85 88 00        MOV    byte ptr [bx - 0x777b], 0    ; UNKNOWN
04027E  C6 87 87 88 58        MOV    byte ptr [bx - 0x7779], 0x58 ; UNKNOWN
040283  2A C0                 SUB    al, al                       ; UNKNOWN
040285  88 87 84 88           MOV    byte ptr [bx - 0x777c], al   ; UNKNOWN
040289  88 87 88 88           MOV    byte ptr [bx - 0x7778], al   ; UNKNOWN
04028D  88 87 8C 88           MOV    byte ptr [bx - 0x7774], al   ; UNKNOWN
040291  88 87 96 88           MOV    byte ptr [bx - 0x776a], al   ; UNKNOWN
040295  88 87 90 88           MOV    byte ptr [bx - 0x7770], al   ; UNKNOWN
040299  88 87 91 88           MOV    byte ptr [bx - 0x776f], al   ; UNKNOWN
04029D  C6 87 92 88 FF        MOV    byte ptr [bx - 0x776e], 0xff ; UNKNOWN
0402A2  83 FF 04              CMP    di, 4                        ; UNKNOWN
0402A5  7C 0A                 JL     0x402b1                      ; UNKNOWN
0402A7  A1 06 3E              MOV    ax, word ptr [0x3e06]        ; UNKNOWN
0402AA  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
0402AD  89 87 92 88           MOV    word ptr [bx - 0x776e], ax   ; UNKNOWN
0402B1  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
0402B4  C6 87 86 88 FF        MOV    byte ptr [bx - 0x777a], 0xff ; UNKNOWN
0402B9  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
0402BC  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0402BF  9A 61 0A 5F 24        LCALL  0x245f, 0xa61                ; UNKNOWN
0402C4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0402C7  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0402CA  0B C0                 OR     ax, ax                       ; UNKNOWN
0402CC  7C 0A                 JL     0x402d8                      ; UNKNOWN
0402CE  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
0402D1  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
0402D4  88 87 86 88           MOV    byte ptr [bx - 0x777a], al   ; UNKNOWN
0402D8  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
0402DB  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
0402DF  2A FF                 SUB    bh, bh                       ; UNKNOWN
0402E1  8B C3                 MOV    ax, bx                       ; UNKNOWN
