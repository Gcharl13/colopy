; ============================================================================
; func_0699E0_unknown
; Region   : load_image
; Bytes    : file 0x0699E0..0x0699FA  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0699E0  55                    PUSH   bp                           ; UNKNOWN
0699E1  8B EC                 MOV    bp, sp                       ; UNKNOWN
0699E3  57                    PUSH   di                           ; UNKNOWN
0699E4  56                    PUSH   si                           ; UNKNOWN
0699E5  1E                    PUSH   ds                           ; UNKNOWN
0699E6  8B 4E 0E              MOV    cx, word ptr [bp + 0xe]      ; UNKNOWN
0699E9  E3 27                 JCXZ   0x69a12                      ; UNKNOWN
0699EB  8B D9                 MOV    bx, cx                       ; UNKNOWN
0699ED  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
0699F0  8B F7                 MOV    si, di                       ; UNKNOWN
0699F2  33 C0                 XOR    ax, ax                       ; UNKNOWN
0699F4  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
0699F6  F7 D9                 NEG    cx                           ; UNKNOWN
0699F8  03 CB                 ADD    cx, bx                       ; UNKNOWN
