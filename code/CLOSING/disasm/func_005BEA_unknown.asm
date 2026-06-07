; ============================================================================
; func_005BEA_unknown
; Region   : load_image
; Bytes    : file 0x005BEA..0x005C0A  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005BEA  55                    PUSH   bp ; STACK_PUSH
005BEB  8B EC                 MOV    bp, sp ; MOV
005BED  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
005BF0  3B 1E 57 40           CMP    bx, word ptr [0x4057] ; CMP
005BF4  72 06                 JB     0x5bfc ; CJUMP
005BF6  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
005BF9  F9                    STC ; FLAG
005BFA  EB 0B                 JMP    0x5c07 ; JUMP
005BFC  B4 3E                 MOV    ah, 0x3e ; CONST_LOAD
005BFE  CD 21                 INT    0x21 ; SYS
005C00  72 05                 JB     0x5c07 ; CJUMP
005C02  C6 87 59 40 00        MOV    byte ptr [bx + 0x4059], 0 ; MOV
005C07  E9 4A F7              JMP    0x5354 ; JUMP
