; ============================================================================
; func_0472BE_unknown
; Region   : load_image
; Bytes    : file 0x0472BE..0x0472EF  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0472BE  55                    PUSH   bp                           ; UNKNOWN
0472BF  8B EC                 MOV    bp, sp                       ; UNKNOWN
0472C1  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0472C4  48                    DEC    ax                           ; UNKNOWN
0472C5  74 0F                 JE     0x472d6                      ; UNKNOWN
0472C7  48                    DEC    ax                           ; UNKNOWN
0472C8  74 0C                 JE     0x472d6                      ; UNKNOWN
0472CA  48                    DEC    ax                           ; UNKNOWN
0472CB  74 12                 JE     0x472df                      ; UNKNOWN
0472CD  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0472D0  C7 07 44 00           MOV    word ptr [bx], 0x44          ; UNKNOWN
0472D4  EB 10                 JMP    0x472e6                      ; UNKNOWN
0472D6  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0472D9  C7 07 95 00           MOV    word ptr [bx], 0x95          ; UNKNOWN
0472DD  EB 07                 JMP    0x472e6                      ; UNKNOWN
0472DF  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0472E2  C7 07 0C 00           MOV    word ptr [bx], 0xc           ; UNKNOWN
0472E6  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
0472E9  C7 07 22 00           MOV    word ptr [bx], 0x22          ; UNKNOWN
0472ED  C9                    LEAVE                               ; UNKNOWN
0472EE  CB                    RETF                                ; UNKNOWN
