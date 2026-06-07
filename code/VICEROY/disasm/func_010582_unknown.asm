; ============================================================================
; func_010582_unknown
; Region   : load_image
; Bytes    : file 0x010582..0x01059E  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010582  55                    PUSH   bp ; STACK_PUSH
010583  8B EC                 MOV    bp, sp ; MOV
010585  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
010588  1E                    PUSH   ds ; STACK_PUSH
010589  57                    PUSH   di ; STACK_PUSH
01058A  56                    PUSH   si ; STACK_PUSH
01058B  E3 48                 JCXZ   0x105d5 ; CJUMP
01058D  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
010590  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
010593  8B C1                 MOV    ax, cx ; MOV
010595  48                    DEC    ax ; ARITH
010596  8B D7                 MOV    dx, di ; MOV
010598  F7 D2                 NOT    dx ; LOGIC
01059A  2B C2                 SUB    ax, dx ; ARITH
01059C  1B DB                 SBB    bx, bx ; ARITH
