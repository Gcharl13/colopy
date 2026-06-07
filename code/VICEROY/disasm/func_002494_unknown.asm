; ============================================================================
; func_002494_unknown
; Region   : load_image
; Bytes    : file 0x002494..0x0024C6  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002494  55                    PUSH   bp                           ; UNKNOWN
002495  8B EC                 MOV    bp, sp                       ; UNKNOWN
002497  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
00249A  48                    DEC    ax                           ; UNKNOWN
00249B  74 0F                 JE     0x24ac                       ; UNKNOWN
00249D  48                    DEC    ax                           ; UNKNOWN
00249E  74 0C                 JE     0x24ac                       ; UNKNOWN
0024A0  48                    DEC    ax                           ; UNKNOWN
0024A1  74 13                 JE     0x24b6                       ; UNKNOWN
0024A3  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0024A6  C7 07 44 00           MOV    word ptr [bx], 0x44          ; UNKNOWN
0024AA  EB 11                 JMP    0x24bd                       ; UNKNOWN
0024AC  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0024AF  C7 07 95 00           MOV    word ptr [bx], 0x95          ; UNKNOWN
0024B3  EB 08                 JMP    0x24bd                       ; UNKNOWN
0024B5  90                    NOP                                 ; UNKNOWN
0024B6  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0024B9  C7 07 0C 00           MOV    word ptr [bx], 0xc           ; UNKNOWN
0024BD  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; LOCAL_LOAD
0024C0  C7 07 22 00           MOV    word ptr [bx], 0x22          ; UNKNOWN
0024C4  C9                    LEAVE                               ; UNKNOWN
0024C5  CB                    RETF                                ; UNKNOWN
