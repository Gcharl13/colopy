; ============================================================================
; func_0692E0_unknown
; Region   : load_image
; Bytes    : file 0x0692E0..0x06930A  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0692E0  55                    PUSH   bp                           ; UNKNOWN
0692E1  8B EC                 MOV    bp, sp                       ; UNKNOWN
0692E3  57                    PUSH   di                           ; UNKNOWN
0692E4  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
0692E7  1E                    PUSH   ds                           ; UNKNOWN
0692E8  07                    POP    es                           ; UNKNOWN
0692E9  8B DF                 MOV    bx, di                       ; UNKNOWN
0692EB  33 C0                 XOR    ax, ax                       ; UNKNOWN
0692ED  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
0692F0  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
0692F2  41                    INC    cx                           ; UNKNOWN
0692F3  F7 D9                 NEG    cx                           ; UNKNOWN
0692F5  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
0692F8  8B FB                 MOV    di, bx                       ; UNKNOWN
0692FA  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
0692FC  4F                    DEC    di                           ; UNKNOWN
0692FD  38 05                 CMP    byte ptr [di], al            ; UNKNOWN
0692FF  74 02                 JE     0x69303                      ; UNKNOWN
069301  33 FF                 XOR    di, di                       ; UNKNOWN
069303  8B C7                 MOV    ax, di                       ; UNKNOWN
069305  5F                    POP    di                           ; UNKNOWN
069306  8B E5                 MOV    sp, bp                       ; UNKNOWN
069308  5D                    POP    bp                           ; UNKNOWN
069309  CB                    RETF                                ; UNKNOWN
