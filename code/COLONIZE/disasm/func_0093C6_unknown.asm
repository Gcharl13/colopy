; ============================================================================
; func_0093C6_unknown
; Region   : load_image
; Bytes    : file 0x0093C6..0x0093E0  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0093C6  55                    PUSH   bp                           ; UNKNOWN
0093C7  8B EC                 MOV    bp, sp                       ; UNKNOWN
0093C9  B8 00 58              MOV    ax, 0x5800                   ; UNKNOWN
0093CC  CD 21                 INT    0x21                         ; UNKNOWN
0093CE  72 07                 JB     0x93d7                       ; UNKNOWN
0093D0  8B 5E 04              MOV    bx, word ptr [bp + 4]        ; UNKNOWN
0093D3  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
0093D5  33 C0                 XOR    ax, ax                       ; UNKNOWN
0093D7  F7 D8                 NEG    ax                           ; UNKNOWN
0093D9  1B C0                 SBB    ax, ax                       ; UNKNOWN
0093DB  40                    INC    ax                           ; UNKNOWN
0093DC  C9                    LEAVE                               ; UNKNOWN
0093DD  C2 02 00              RET    2                            ; UNKNOWN
