; ============================================================================
; func_0693D0_unknown
; Region   : load_image
; Bytes    : file 0x0693D0..0x0693EE  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0693D0  55                    PUSH   bp                           ; UNKNOWN
0693D1  8B EC                 MOV    bp, sp                       ; UNKNOWN
0693D3  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0693D6  8B D3                 MOV    dx, bx                       ; UNKNOWN
0693D8  EB 0B                 JMP    0x693e5                      ; UNKNOWN
0693DA  2C 41                 SUB    al, 0x41                     ; UNKNOWN
0693DC  3C 1A                 CMP    al, 0x1a                     ; UNKNOWN
0693DE  73 04                 JAE    0x693e4                      ; UNKNOWN
0693E0  04 61                 ADD    al, 0x61                     ; UNKNOWN
0693E2  88 07                 MOV    byte ptr [bx], al            ; UNKNOWN
0693E4  43                    INC    bx                           ; UNKNOWN
0693E5  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
0693E7  0A C0                 OR     al, al                       ; UNKNOWN
0693E9  75 EF                 JNE    0x693da                      ; UNKNOWN
0693EB  92                    XCHG   dx, ax                       ; UNKNOWN
0693EC  5D                    POP    bp                           ; UNKNOWN
0693ED  CB                    RETF                                ; UNKNOWN
