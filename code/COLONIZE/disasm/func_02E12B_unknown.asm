; ============================================================================
; func_02E12B_unknown
; Region   : load_image
; Bytes    : file 0x02E12B..0x02E16F  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E12B  55                    PUSH   bp                           ; UNKNOWN
02E12C  8B EC                 MOV    bp, sp                       ; UNKNOWN
02E12E  2B C0                 SUB    ax, ax                       ; UNKNOWN
02E130  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02E133  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02E135  89 87 F1 73           MOV    word ptr [bx + 0x73f1], ax   ; UNKNOWN
02E139  89 87 19 74           MOV    word ptr [bx + 0x7419], ax   ; UNKNOWN
02E13D  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
02E140  89 87 C9 73           MOV    word ptr [bx + 0x73c9], ax   ; UNKNOWN
02E144  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
02E147  7E 07                 JLE    0x2e150                      ; UNKNOWN
02E149  2B 46 08              SUB    ax, word ptr [bp + 8]        ; UNKNOWN
02E14C  89 87 F1 73           MOV    word ptr [bx + 0x73f1], ax   ; UNKNOWN
02E150  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
02E153  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
02E156  3B 46 0A              CMP    ax, word ptr [bp + 0xa]      ; UNKNOWN
02E159  7D 12                 JGE    0x2e16d                      ; UNKNOWN
02E15B  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
02E15E  2B 46 0C              SUB    ax, word ptr [bp + 0xc]      ; UNKNOWN
02E161  2B 46 08              SUB    ax, word ptr [bp + 8]        ; UNKNOWN
02E164  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02E167  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02E169  89 87 19 74           MOV    word ptr [bx + 0x7419], ax   ; UNKNOWN
02E16D  C9                    LEAVE                               ; UNKNOWN
02E16E  CB                    RETF                                ; UNKNOWN
