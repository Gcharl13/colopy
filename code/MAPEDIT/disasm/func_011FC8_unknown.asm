; ============================================================================
; func_011FC8_unknown
; Region   : load_image
; Bytes    : file 0x011FC8..0x011FE8  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011FC8  55                    PUSH   bp ; STACK_PUSH
011FC9  8B EC                 MOV    bp, sp ; MOV
011FCB  57                    PUSH   di ; STACK_PUSH
011FCC  56                    PUSH   si ; STACK_PUSH
011FCD  1E                    PUSH   ds ; STACK_PUSH
011FCE  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
011FD1  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
011FD4  B9 03 00              MOV    cx, 3 ; MOV
011FD7  33 D2                 XOR    dx, dx ; LOGIC
011FD9  AC                    LODSB  al, byte ptr [si] ; STR
011FDA  26 2A 05              SUB    al, byte ptr es:[di] ; ARITH
011FDD  47                    INC    di ; ARITH
011FDE  F6 E8                 IMUL   al ; ARITH
011FE0  03 D0                 ADD    dx, ax ; ARITH
011FE2  E2 F5                 LOOP   0x11fd9 ; CJUMP
011FE4  8B C2                 MOV    ax, dx ; MOV
011FE6  1F                    POP    ds ; STACK_POP
011FE7  5E                    POP    si ; STACK_POP
