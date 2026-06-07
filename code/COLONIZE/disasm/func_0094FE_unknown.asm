; ============================================================================
; func_0094FE_unknown
; Region   : load_image
; Bytes    : file 0x0094FE..0x00951A  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0094FE  55                    PUSH   bp                           ; UNKNOWN
0094FF  8B EC                 MOV    bp, sp                       ; UNKNOWN
009501  B4 48                 MOV    ah, 0x48                     ; UNKNOWN
009503  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
009506  CD 21                 INT    0x21                         ; UNKNOWN
009508  72 07                 JB     0x9511                       ; UNKNOWN
00950A  8B 5E 04              MOV    bx, word ptr [bp + 4]        ; UNKNOWN
00950D  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
00950F  33 C0                 XOR    ax, ax                       ; UNKNOWN
009511  F7 D8                 NEG    ax                           ; UNKNOWN
009513  1B C0                 SBB    ax, ax                       ; UNKNOWN
009515  40                    INC    ax                           ; UNKNOWN
009516  C9                    LEAVE                               ; UNKNOWN
009517  C2 04 00              RET    4                            ; UNKNOWN
