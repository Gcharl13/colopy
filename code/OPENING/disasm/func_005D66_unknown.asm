; ============================================================================
; func_005D66_unknown
; Region   : load_image
; Bytes    : file 0x005D66..0x005D82  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005D66  55                    PUSH   bp ; STACK_PUSH
005D67  8B EC                 MOV    bp, sp ; MOV
005D69  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
005D6C  1E                    PUSH   ds ; STACK_PUSH
005D6D  57                    PUSH   di ; STACK_PUSH
005D6E  56                    PUSH   si ; STACK_PUSH
005D6F  E3 48                 JCXZ   0x5db9 ; CJUMP
005D71  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
005D74  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
005D77  8B C1                 MOV    ax, cx ; MOV
005D79  48                    DEC    ax ; ARITH
005D7A  8B D7                 MOV    dx, di ; MOV
005D7C  F7 D2                 NOT    dx ; LOGIC
005D7E  2B C2                 SUB    ax, dx ; ARITH
005D80  1B DB                 SBB    bx, bx ; ARITH
