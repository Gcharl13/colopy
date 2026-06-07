; ============================================================================
; func_015ACA_unknown
; Region   : load_image
; Bytes    : file 0x015ACA..0x015AE6  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015ACA  55                    PUSH   bp ; STACK_PUSH
015ACB  8B EC                 MOV    bp, sp ; MOV
015ACD  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
015AD0  1E                    PUSH   ds ; STACK_PUSH
015AD1  57                    PUSH   di ; STACK_PUSH
015AD2  56                    PUSH   si ; STACK_PUSH
015AD3  E3 48                 JCXZ   0x15b1d ; CJUMP
015AD5  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
015AD8  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
015ADB  8B C1                 MOV    ax, cx ; MOV
015ADD  48                    DEC    ax ; ARITH
015ADE  8B D7                 MOV    dx, di ; MOV
015AE0  F7 D2                 NOT    dx ; LOGIC
015AE2  2B C2                 SUB    ax, dx ; ARITH
015AE4  1B DB                 SBB    bx, bx ; ARITH
