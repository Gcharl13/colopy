; ============================================================================
; func_0028C0_unknown
; Region   : load_image
; Bytes    : file 0x0028C0..0x0028E1  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0028C0  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0028C4  57                    PUSH   di                           ; UNKNOWN
0028C5  56                    PUSH   si                           ; UNKNOWN
0028C6  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
0028C9  0B D2                 OR     dx, dx                       ; UNKNOWN
0028CB  7E 10                 JLE    0x28dd                       ; UNKNOWN
0028CD  8B F2                 MOV    si, dx                       ; UNKNOWN
0028CF  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
0028D2  57                    PUSH   di                           ; UNKNOWN
0028D3  0E                    PUSH   cs                           ; UNKNOWN
0028D4  E8 D9 FF              CALL   0x28b0                       ; UNKNOWN
0028D7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0028DA  4E                    DEC    si                           ; UNKNOWN
0028DB  75 F5                 JNE    0x28d2                       ; UNKNOWN
0028DD  5E                    POP    si                           ; UNKNOWN
0028DE  5F                    POP    di                           ; UNKNOWN
0028DF  C9                    LEAVE                               ; UNKNOWN
0028E0  CB                    RETF                                ; UNKNOWN
