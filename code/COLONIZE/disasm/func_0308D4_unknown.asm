; ============================================================================
; func_0308D4_unknown
; Region   : load_image
; Bytes    : file 0x0308D4..0x030902  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0308D4  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
0308D8  2B C0                 SUB    ax, ax                       ; UNKNOWN
0308DA  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0308DD  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
0308E0  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
0308E3  50                    PUSH   ax                           ; UNKNOWN
0308E4  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0308E7  0E                    PUSH   cs                           ; UNKNOWN
0308E8  E8 97 FF              CALL   0x30882                      ; UNKNOWN
0308EB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0308EE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0308F1  48                    DEC    ax                           ; UNKNOWN
0308F2  74 09                 JE     0x308fd                      ; UNKNOWN
0308F4  48                    DEC    ax                           ; UNKNOWN
0308F5  74 26                 JE     0x3091d                      ; UNKNOWN
0308F7  FF 36 3A 33           PUSH   word ptr [0x333a]            ; UNKNOWN
0308FB  EB 10                 JMP    0x3090d                      ; UNKNOWN
0308FD  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
030900  8B C3                 MOV    ax, bx                       ; UNKNOWN
