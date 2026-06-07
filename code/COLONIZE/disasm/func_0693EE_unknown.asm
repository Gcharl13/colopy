; ============================================================================
; func_0693EE_unknown
; Region   : load_image
; Bytes    : file 0x0693EE..0x06940C  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0693EE  55                    PUSH   bp                           ; UNKNOWN
0693EF  8B EC                 MOV    bp, sp                       ; UNKNOWN
0693F1  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0693F4  8B D3                 MOV    dx, bx                       ; UNKNOWN
0693F6  EB 0B                 JMP    0x69403                      ; UNKNOWN
0693F8  2C 61                 SUB    al, 0x61                     ; UNKNOWN
0693FA  3C 1A                 CMP    al, 0x1a                     ; UNKNOWN
0693FC  73 04                 JAE    0x69402                      ; UNKNOWN
0693FE  04 41                 ADD    al, 0x41                     ; UNKNOWN
069400  88 07                 MOV    byte ptr [bx], al            ; UNKNOWN
069402  43                    INC    bx                           ; UNKNOWN
069403  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
069405  0A C0                 OR     al, al                       ; UNKNOWN
069407  75 EF                 JNE    0x693f8                      ; UNKNOWN
069409  92                    XCHG   dx, ax                       ; UNKNOWN
06940A  5D                    POP    bp                           ; UNKNOWN
06940B  CB                    RETF                                ; UNKNOWN
