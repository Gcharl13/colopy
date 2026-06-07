; ============================================================================
; func_009532_unknown
; Region   : load_image
; Bytes    : file 0x009532..0x00954C  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009532  55                    PUSH   bp                           ; UNKNOWN
009533  8B EC                 MOV    bp, sp                       ; UNKNOWN
009535  8E 46 06              MOV    es, word ptr [bp + 6]        ; UNKNOWN
009538  8B 5E 04              MOV    bx, word ptr [bp + 4]        ; UNKNOWN
00953B  B4 4A                 MOV    ah, 0x4a                     ; UNKNOWN
00953D  CD 21                 INT    0x21                         ; UNKNOWN
00953F  72 02                 JB     0x9543                       ; UNKNOWN
009541  33 C0                 XOR    ax, ax                       ; UNKNOWN
009543  F7 D8                 NEG    ax                           ; UNKNOWN
009545  1B C0                 SBB    ax, ax                       ; UNKNOWN
009547  40                    INC    ax                           ; UNKNOWN
009548  C9                    LEAVE                               ; UNKNOWN
009549  C2 04 00              RET    4                            ; UNKNOWN
