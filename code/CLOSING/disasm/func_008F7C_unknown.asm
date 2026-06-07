; ============================================================================
; func_008F7C_unknown
; Region   : load_image
; Bytes    : file 0x008F7C..0x008F9C  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008F7C  55                    PUSH   bp ; STACK_PUSH
008F7D  8B EC                 MOV    bp, sp ; MOV
008F7F  57                    PUSH   di ; STACK_PUSH
008F80  56                    PUSH   si ; STACK_PUSH
008F81  1E                    PUSH   ds ; STACK_PUSH
008F82  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
008F85  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
008F88  B9 03 00              MOV    cx, 3 ; MOV
008F8B  33 D2                 XOR    dx, dx ; LOGIC
008F8D  AC                    LODSB  al, byte ptr [si] ; STR
008F8E  26 2A 05              SUB    al, byte ptr es:[di] ; ARITH
008F91  47                    INC    di ; ARITH
008F92  F6 E8                 IMUL   al ; ARITH
008F94  03 D0                 ADD    dx, ax ; ARITH
008F96  E2 F5                 LOOP   0x8f8d ; CJUMP
008F98  8B C2                 MOV    ax, dx ; MOV
008F9A  1F                    POP    ds ; STACK_POP
008F9B  5E                    POP    si ; STACK_POP
