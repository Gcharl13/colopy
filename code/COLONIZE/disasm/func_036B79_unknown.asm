; ============================================================================
; func_036B79_unknown
; Region   : load_image
; Bytes    : file 0x036B79..0x036C98  (287 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

036B79  C8 CE 00 00           ENTER  0xce, 0                      ; UNKNOWN
036B7D  57                    PUSH   di                           ; UNKNOWN
036B7E  56                    PUSH   si                           ; UNKNOWN
036B7F  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
036B83  7D 20                 JGE    0x36ba5                      ; UNKNOWN
036B85  7E 05                 JLE    0x36b8c                      ; UNKNOWN
036B87  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
036B8A  EB 07                 JMP    0x36b93                      ; UNKNOWN
036B8C  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
036B8F  F6 D0                 NOT    al                           ; UNKNOWN
036B91  FE C0                 INC    al                           ; UNKNOWN
036B93  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
036B97  3A 47 01              CMP    al, byte ptr [bx + 1]        ; UNKNOWN
036B9A  7E 09                 JLE    0x36ba5                      ; UNKNOWN
036B9C  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
036B9F  98                    CWDE                                ; UNKNOWN
036BA0  F7 D8                 NEG    ax                           ; UNKNOWN
036BA2  89 46 08              MOV    word ptr [bp + 8], ax        ; UNKNOWN
036BA5  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
036BA8  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
036BAC  00 47 01              ADD    byte ptr [bx + 1], al        ; UNKNOWN
036BAF  80 7F 01 4B           CMP    byte ptr [bx + 1], 0x4b      ; UNKNOWN
036BB3  7E 19                 JLE    0x36bce                      ; UNKNOWN
036BB5  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
036BB8  8B C8                 MOV    cx, ax                       ; UNKNOWN
036BBA  98                    CWDE                                ; UNKNOWN
036BBB  83 E8 4B              SUB    ax, 0x4b                     ; UNKNOWN
036BBE  89 86 58 FF           MOV    word ptr [bp - 0xa8], ax     ; UNKNOWN
036BC2  2A C8                 SUB    cl, al                       ; UNKNOWN
036BC4  88 4F 01              MOV    byte ptr [bx + 1], cl        ; UNKNOWN
036BC7  8B 86 58 FF           MOV    ax, word ptr [bp - 0xa8]     ; UNKNOWN
036BCB  29 46 08              SUB    word ptr [bp + 8], ax        ; UNKNOWN
036BCE  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
036BD2  75 03                 JNE    0x36bd7                      ; UNKNOWN
036BD4  E9 A0 03              JMP    0x36f77                      ; UNKNOWN
036BD7  83 3E 9A 79 04        CMP    word ptr [0x799a], 4         ; UNKNOWN
036BDC  7C 03                 JL     0x36be1                      ; UNKNOWN
036BDE  E9 96 03              JMP    0x36f77                      ; UNKNOWN
036BE1  6B 1E 9A 79 34        IMUL   bx, word ptr [0x799a], 0x34  ; UNKNOWN
036BE6  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
036BEB  74 03                 JE     0x36bf0                      ; UNKNOWN
036BED  E9 87 03              JMP    0x36f77                      ; UNKNOWN
036BF0  2B C0                 SUB    ax, ax                       ; UNKNOWN
036BF2  89 46 84              MOV    word ptr [bp - 0x7c], ax     ; UNKNOWN
036BF5  89 46 82              MOV    word ptr [bp - 0x7e], ax     ; UNKNOWN
036BF8  89 86 56 FF           MOV    word ptr [bp - 0xaa], ax     ; UNKNOWN
036BFC  8B B6 56 FF           MOV    si, word ptr [bp - 0xaa]     ; UNKNOWN
036C00  D1 E6                 SHL    si, 1                        ; UNKNOWN
036C02  C7 82 5E FF FF FF     MOV    word ptr [bp + si - 0xa2], 0xffff ; UNKNOWN
036C08  C7 82 36 FF 00 00     MOV    word ptr [bp + si - 0xca], 0 ; UNKNOWN
036C0E  6A 00                 PUSH   0                            ; UNKNOWN
036C10  6A 64                 PUSH   0x64                         ; UNKNOWN
036C12  8B BE 56 FF           MOV    di, word ptr [bp - 0xaa]     ; UNKNOWN
036C16  C1 E7 02              SHL    di, 2                        ; UNKNOWN
036C19  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
036C1D  FF B1 BE 00           PUSH   word ptr [bx + di + 0xbe]    ; UNKNOWN
036C21  FF B1 BC 00           PUSH   word ptr [bx + di + 0xbc]    ; UNKNOWN
036C25  9A 16 0E 65 5F        LCALL  0x5f65, 0xe16                ; UNKNOWN
036C2A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
036C2D  52                    PUSH   dx                           ; UNKNOWN
036C2E  50                    PUSH   ax                           ; UNKNOWN
036C2F  9A D2 11 65 5F        LCALL  0x5f65, 0x11d2               ; UNKNOWN
036C34  89 42 88              MOV    word ptr [bp + si - 0x78], ax ; UNKNOWN
036C37  FF 86 56 FF           INC    word ptr [bp - 0xaa]         ; UNKNOWN
036C3B  83 BE 56 FF 10        CMP    word ptr [bp - 0xaa], 0x10   ; UNKNOWN
036C40  7C BA                 JL     0x36bfc                      ; UNKNOWN
036C42  C1 7E A6 02           SAR    word ptr [bp - 0x5a], 2      ; UNKNOWN
036C46  C1 7E 98 02           SAR    word ptr [bp - 0x68], 2      ; UNKNOWN
036C4A  D1 7E A4              SAR    word ptr [bp - 0x5c], 1      ; UNKNOWN
036C4D  D1 7E 88              SAR    word ptr [bp - 0x78], 1      ; UNKNOWN
036C50  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
036C54  8B 47 20              MOV    ax, word ptr [bx + 0x20]     ; UNKNOWN
036C57  89 86 5C FF           MOV    word ptr [bp - 0xa4], ax     ; UNKNOWN
036C5B  C7 86 34 FF 00 00     MOV    word ptr [bp - 0xcc], 0      ; UNKNOWN
036C61  EB 4B                 JMP    0x36cae                      ; UNKNOWN
036C63  FF 86 56 FF           INC    word ptr [bp - 0xaa]         ; UNKNOWN
036C67  83 BE 56 FF 10        CMP    word ptr [bp - 0xaa], 0x10   ; UNKNOWN
036C6C  7D 3C                 JGE    0x36caa                      ; UNKNOWN
036C6E  8A 8E 56 FF           MOV    cl, byte ptr [bp - 0xaa]     ; UNKNOWN
036C72  B8 01 00              MOV    ax, 1                        ; UNKNOWN
036C75  D3 E0                 SHL    ax, cl                       ; UNKNOWN
036C77  85 86 5C FF           TEST   word ptr [bp - 0xa4], ax     ; UNKNOWN
036C7B  75 E6                 JNE    0x36c63                      ; UNKNOWN
036C7D  8B B6 56 FF           MOV    si, word ptr [bp - 0xaa]     ; UNKNOWN
036C81  D1 E6                 SHL    si, 1                        ; UNKNOWN
036C83  8B 82 36 FF           MOV    ax, word ptr [bp + si - 0xca] ; UNKNOWN
036C87  6B 9E 34 FF 65        IMUL   bx, word ptr [bp - 0xcc], 0x65 ; UNKNOWN
036C8C  03 9E 56 FF           ADD    bx, word ptr [bp - 0xaa]     ; UNKNOWN
036C90  D1 E3                 SHL    bx, 1                        ; UNKNOWN
036C92  39 87 52 41           CMP    word ptr [bx + 0x4152], ax   ; UNKNOWN
036C96  7E CB                 JLE    0x36c63                      ; UNKNOWN
