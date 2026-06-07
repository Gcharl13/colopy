; ============================================================================
; func_01709C_unknown
; Region   : load_image
; Bytes    : file 0x01709C..0x017168  (204 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01709C  C8 A4 00 00           ENTER  0xa4, 0                      ; UNKNOWN
0170A0  57                    PUSH   di                           ; UNKNOWN
0170A1  56                    PUSH   si                           ; UNKNOWN
0170A2  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0170A6  80 7F 1F 02           CMP    byte ptr [bx + 0x1f], 2      ; UNKNOWN
0170AA  7D 03                 JGE    0x170af                      ; UNKNOWN
0170AC  E9 EB 00              JMP    0x1719a                      ; UNKNOWN
0170AF  C7 46 BC 00 00        MOV    word ptr [bp - 0x44], 0      ; UNKNOWN
0170B4  EB 2A                 JMP    0x170e0                      ; UNKNOWN
0170B6  8A 46 BC              MOV    al, byte ptr [bp - 0x44]     ; UNKNOWN
0170B9  8B 76 BC              MOV    si, word ptr [bp - 0x44]     ; UNKNOWN
0170BC  88 82 5C FF           MOV    byte ptr [bp + si - 0xa4], al ; UNKNOWN
0170C0  8A 40 40              MOV    al, byte ptr [bx + si + 0x40] ; UNKNOWN
0170C3  88 82 7C FF           MOV    byte ptr [bp + si - 0x84], al ; UNKNOWN
0170C7  56                    PUSH   si                           ; UNKNOWN
0170C8  9A 60 0C 5F 24        LCALL  0x245f, 0xc60                ; UNKNOWN
0170CD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0170D0  88 42 DE              MOV    byte ptr [bp + si - 0x22], al ; UNKNOWN
0170D3  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0170D7  8A 40 20              MOV    al, byte ptr [bx + si + 0x20] ; UNKNOWN
0170DA  88 42 9C              MOV    byte ptr [bp + si - 0x64], al ; UNKNOWN
0170DD  FF 46 BC              INC    word ptr [bp - 0x44]         ; UNKNOWN
0170E0  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
0170E3  98                    CWDE                                ; UNKNOWN
0170E4  3B 46 BC              CMP    ax, word ptr [bp - 0x44]     ; UNKNOWN
0170E7  7F CD                 JG     0x170b6                      ; UNKNOWN
0170E9  8D 86 5C FF           LEA    ax, [bp - 0xa4]              ; UNKNOWN
0170ED  16                    PUSH   ss                           ; UNKNOWN
0170EE  50                    PUSH   ax                           ; UNKNOWN
0170EF  8D 46 9C              LEA    ax, [bp - 0x64]              ; UNKNOWN
0170F2  16                    PUSH   ss                           ; UNKNOWN
0170F3  50                    PUSH   ax                           ; UNKNOWN
0170F4  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0170F8  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
0170FB  98                    CWDE                                ; UNKNOWN
0170FC  9A 04 00 E7 5C        LCALL  0x5ce7, 4                    ; UNKNOWN
017101  C7 46 BC 00 00        MOV    word ptr [bp - 0x44], 0      ; UNKNOWN
017106  EB 14                 JMP    0x1711c                      ; UNKNOWN
017108  8A 46 BC              MOV    al, byte ptr [bp - 0x44]     ; UNKNOWN
01710B  8B 76 BC              MOV    si, word ptr [bp - 0x44]     ; UNKNOWN
01710E  8A 8A 5C FF           MOV    cl, byte ptr [bp + si - 0xa4] ; UNKNOWN
017112  2A ED                 SUB    ch, ch                       ; UNKNOWN
017114  8B F9                 MOV    di, cx                       ; UNKNOWN
017116  88 43 BE              MOV    byte ptr [bp + di - 0x42], al ; UNKNOWN
017119  FF 46 BC              INC    word ptr [bp - 0x44]         ; UNKNOWN
01711C  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
017120  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
017123  98                    CWDE                                ; UNKNOWN
017124  3B 46 BC              CMP    ax, word ptr [bp - 0x44]     ; UNKNOWN
017127  7F DF                 JG     0x17108                      ; UNKNOWN
017129  C7 46 BC 00 00        MOV    word ptr [bp - 0x44], 0      ; UNKNOWN
01712E  EB 29                 JMP    0x17159                      ; UNKNOWN
017130  8B 76 BC              MOV    si, word ptr [bp - 0x44]     ; UNKNOWN
017133  8A 82 7C FF           MOV    al, byte ptr [bp + si - 0x84] ; UNKNOWN
017137  8A 4A BE              MOV    cl, byte ptr [bp + si - 0x42] ; UNKNOWN
01713A  2A ED                 SUB    ch, ch                       ; UNKNOWN
01713C  8B F9                 MOV    di, cx                       ; UNKNOWN
01713E  88 41 40              MOV    byte ptr [bx + di + 0x40], al ; UNKNOWN
017141  8A 42 9C              MOV    al, byte ptr [bp + si - 0x64] ; UNKNOWN
017144  88 40 20              MOV    byte ptr [bx + si + 0x20], al ; UNKNOWN
017147  8A 42 DE              MOV    al, byte ptr [bp + si - 0x22] ; UNKNOWN
01714A  2A E4                 SUB    ah, ah                       ; UNKNOWN
01714C  50                    PUSH   ax                           ; UNKNOWN
01714D  57                    PUSH   di                           ; UNKNOWN
01714E  9A A0 0C 5F 24        LCALL  0x245f, 0xca0                ; UNKNOWN
017153  83 C4 04              ADD    sp, 4                        ; UNKNOWN
017156  FF 46 BC              INC    word ptr [bp - 0x44]         ; UNKNOWN
017159  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01715D  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
017160  98                    CWDE                                ; UNKNOWN
017161  3B 46 BC              CMP    ax, word ptr [bp - 0x44]     ; UNKNOWN
017164  7F CA                 JG     0x17130                      ; UNKNOWN
017166  8B                    DB     0x8B                         ; UNKNOWN (raw)
017167  36                    DB     0x36                         ; UNKNOWN (raw)
