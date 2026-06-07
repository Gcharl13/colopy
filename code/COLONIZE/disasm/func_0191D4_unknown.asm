; ============================================================================
; func_0191D4_unknown
; Region   : load_image
; Bytes    : file 0x0191D4..0x019202  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0191D4  55                    PUSH   bp                           ; UNKNOWN
0191D5  8B EC                 MOV    bp, sp                       ; UNKNOWN
0191D7  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0191DA  8B C8                 MOV    cx, ax                       ; UNKNOWN
0191DC  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0191DE  03 C1                 ADD    ax, cx                       ; UNKNOWN
0191E0  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
0191E3  83 C0 7F              ADD    ax, 0x7f                     ; UNKNOWN
0191E6  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0191E9  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
0191EB  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
0191EE  C7 07 A5 00           MOV    word ptr [bx], 0xa5          ; UNKNOWN
0191F2  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
0191F5  C7 07 0A 00           MOV    word ptr [bx], 0xa           ; UNKNOWN
0191F9  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
0191FC  C7 07 16 00           MOV    word ptr [bx], 0x16          ; UNKNOWN
019200  C9                    LEAVE                               ; UNKNOWN
019201  CB                    RETF                                ; UNKNOWN
