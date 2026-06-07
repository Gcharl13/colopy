; ============================================================================
; func_039084_unknown
; Region   : load_image
; Bytes    : file 0x039084..0x03910A  (134 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

039084  C8 2A 00 00           ENTER  0x2a, 0                      ; UNKNOWN
039088  56                    PUSH   si                           ; UNKNOWN
039089  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
03908C  89 46 DA              MOV    word ptr [bp - 0x26], ax     ; UNKNOWN
03908F  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
039092  80 BF 88 88 00        CMP    byte ptr [bx - 0x7778], 0    ; UNKNOWN
039097  74 03                 JE     0x3909c                      ; UNKNOWN
039099  E9 82 06              JMP    0x3971e                      ; UNKNOWN
03909C  0B C0                 OR     ax, ax                       ; UNKNOWN
03909E  7D 03                 JGE    0x390a3                      ; UNKNOWN
0390A0  E9 7B 06              JMP    0x3971e                      ; UNKNOWN
0390A3  39 06 14 3E           CMP    word ptr [0x3e14], ax        ; UNKNOWN
0390A7  7F 03                 JG     0x390ac                      ; UNKNOWN
0390A9  E9 72 06              JMP    0x3971e                      ; UNKNOWN
0390AC  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
0390AF  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
0390B3  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
0390B6  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; UNKNOWN
0390B9  3B 06 10 3E           CMP    ax, word ptr [0x3e10]        ; UNKNOWN
0390BD  74 03                 JE     0x390c2                      ; UNKNOWN
0390BF  E9 5C 06              JMP    0x3971e                      ; UNKNOWN
0390C2  6B 5E DA 1C           IMUL   bx, word ptr [bp - 0x26], 0x1c ; UNKNOWN
0390C6  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
0390CA  2A E4                 SUB    ah, ah                       ; UNKNOWN
0390CC  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
0390CF  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
0390D3  2A ED                 SUB    ch, ch                       ; UNKNOWN
0390D5  89 4E E4              MOV    word ptr [bp - 0x1c], cx     ; UNKNOWN
0390D8  51                    PUSH   cx                           ; UNKNOWN
0390D9  50                    PUSH   ax                           ; UNKNOWN
0390DA  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
0390DF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0390E2  0B C0                 OR     ax, ax                       ; UNKNOWN
0390E4  75 03                 JNE    0x390e9                      ; UNKNOWN
0390E6  E9 35 06              JMP    0x3971e                      ; UNKNOWN
0390E9  83 3E 06 3E 00        CMP    word ptr [0x3e06], 0         ; UNKNOWN
0390EE  75 47                 JNE    0x39137                      ; UNKNOWN
0390F0  80 3E 1E 3E 00        CMP    byte ptr [0x3e1e], 0         ; UNKNOWN
0390F5  75 40                 JNE    0x39137                      ; UNKNOWN
0390F7  F6 06 FE 3D 10        TEST   byte ptr [0x3dfe], 0x10      ; UNKNOWN
0390FC  75 39                 JNE    0x39137                      ; UNKNOWN
0390FE  6B 5E DA 1C           IMUL   bx, word ptr [bp - 0x26], 0x1c ; UNKNOWN
039102  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
039106  2A FF                 SUB    bh, bh                       ; UNKNOWN
039108  8B C3                 MOV    ax, bx                       ; UNKNOWN
