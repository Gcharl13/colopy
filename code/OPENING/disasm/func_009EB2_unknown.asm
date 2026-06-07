; ============================================================================
; func_009EB2_unknown
; Region   : load_image
; Bytes    : file 0x009EB2..0x009ED2  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009EB2  55                    PUSH   bp ; STACK_PUSH
009EB3  8B EC                 MOV    bp, sp ; MOV
009EB5  57                    PUSH   di ; STACK_PUSH
009EB6  56                    PUSH   si ; STACK_PUSH
009EB7  1E                    PUSH   ds ; STACK_PUSH
009EB8  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
009EBB  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
009EBE  B9 03 00              MOV    cx, 3 ; MOV
009EC1  33 D2                 XOR    dx, dx ; LOGIC
009EC3  AC                    LODSB  al, byte ptr [si] ; STR
009EC4  26 2A 05              SUB    al, byte ptr es:[di] ; ARITH
009EC7  47                    INC    di ; ARITH
009EC8  F6 E8                 IMUL   al ; ARITH
009ECA  03 D0                 ADD    dx, ax ; ARITH
009ECC  E2 F5                 LOOP   0x9ec3 ; CJUMP
009ECE  8B C2                 MOV    ax, dx ; MOV
009ED0  1F                    POP    ds ; STACK_POP
009ED1  5E                    POP    si ; STACK_POP
