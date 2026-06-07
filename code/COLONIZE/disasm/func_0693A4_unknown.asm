; ============================================================================
; func_0693A4_unknown
; Region   : load_image
; Bytes    : file 0x0693A4..0x0693CF  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0693A4  55                    PUSH   bp                           ; UNKNOWN
0693A5  8B EC                 MOV    bp, sp                       ; UNKNOWN
0693A7  57                    PUSH   di                           ; UNKNOWN
0693A8  1E                    PUSH   ds                           ; UNKNOWN
0693A9  07                    POP    es                           ; UNKNOWN
0693AA  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
0693AD  33 C0                 XOR    ax, ax                       ; UNKNOWN
0693AF  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
0693B2  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
0693B4  41                    INC    cx                           ; UNKNOWN
0693B5  F7 D9                 NEG    cx                           ; UNKNOWN
0693B7  4F                    DEC    di                           ; UNKNOWN
0693B8  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
0693BB  FD                    STD                                 ; UNKNOWN
0693BC  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
0693BE  47                    INC    di                           ; UNKNOWN
0693BF  38 05                 CMP    byte ptr [di], al            ; UNKNOWN
0693C1  74 04                 JE     0x693c7                      ; UNKNOWN
0693C3  33 C0                 XOR    ax, ax                       ; UNKNOWN
0693C5  EB 02                 JMP    0x693c9                      ; UNKNOWN
0693C7  8B C7                 MOV    ax, di                       ; UNKNOWN
0693C9  FC                    CLD                                 ; UNKNOWN
0693CA  5F                    POP    di                           ; UNKNOWN
0693CB  8B E5                 MOV    sp, bp                       ; UNKNOWN
0693CD  5D                    POP    bp                           ; UNKNOWN
0693CE  CB                    RETF                                ; UNKNOWN
