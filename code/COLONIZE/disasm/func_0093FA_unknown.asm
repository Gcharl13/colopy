; ============================================================================
; func_0093FA_unknown
; Region   : load_image
; Bytes    : file 0x0093FA..0x009412  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0093FA  55                    PUSH   bp                           ; UNKNOWN
0093FB  8B EC                 MOV    bp, sp                       ; UNKNOWN
0093FD  B8 01 58              MOV    ax, 0x5801                   ; UNKNOWN
009400  8B 5E 04              MOV    bx, word ptr [bp + 4]        ; UNKNOWN
009403  CD 21                 INT    0x21                         ; UNKNOWN
009405  72 02                 JB     0x9409                       ; UNKNOWN
009407  33 C0                 XOR    ax, ax                       ; UNKNOWN
009409  F7 D8                 NEG    ax                           ; UNKNOWN
00940B  1B C0                 SBB    ax, ax                       ; UNKNOWN
00940D  40                    INC    ax                           ; UNKNOWN
00940E  C9                    LEAVE                               ; UNKNOWN
00940F  C2 02 00              RET    2                            ; UNKNOWN
