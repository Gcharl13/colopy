; ============================================================================
; func_006BEA_unknown
; Region   : load_image
; Bytes    : file 0x006BEA..0x006C0A  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006BEA  55                    PUSH   bp ; STACK_PUSH
006BEB  8B EC                 MOV    bp, sp ; MOV
006BED  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
006BF0  3B 1E AD 42           CMP    bx, word ptr [0x42ad] ; CMP
006BF4  72 06                 JB     0x6bfc ; CJUMP
006BF6  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
006BF9  F9                    STC ; FLAG
006BFA  EB 0B                 JMP    0x6c07 ; JUMP
006BFC  B4 3E                 MOV    ah, 0x3e ; CONST_LOAD
006BFE  CD 21                 INT    0x21 ; SYS
006C00  72 05                 JB     0x6c07 ; CJUMP
006C02  C6 87 AF 42 00        MOV    byte ptr [bx + 0x42af], 0 ; MOV
006C07  E9 4A F7              JMP    0x6354 ; JUMP
