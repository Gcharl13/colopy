; ============================================================================
; func_00951A_unknown
; Region   : load_image
; Bytes    : file 0x00951A..0x009531  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00951A  55                    PUSH   bp                           ; UNKNOWN
00951B  8B EC                 MOV    bp, sp                       ; UNKNOWN
00951D  8E 46 04              MOV    es, word ptr [bp + 4]        ; UNKNOWN
009520  B4 49                 MOV    ah, 0x49                     ; UNKNOWN
009522  CD 21                 INT    0x21                         ; UNKNOWN
009524  72 02                 JB     0x9528                       ; UNKNOWN
009526  33 C0                 XOR    ax, ax                       ; UNKNOWN
009528  F7 D8                 NEG    ax                           ; UNKNOWN
00952A  1B C0                 SBB    ax, ax                       ; UNKNOWN
00952C  40                    INC    ax                           ; UNKNOWN
00952D  C9                    LEAVE                               ; UNKNOWN
00952E  C2 02 00              RET    2                            ; UNKNOWN
