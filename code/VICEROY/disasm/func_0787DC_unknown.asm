; ============================================================================
; func_0787DC_unknown
; Region   : overlay
; Bytes    : file 0x0787DC..0x0787ED  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0787DC  55                    PUSH   bp ; STACK_PUSH
0787DD  8B EC                 MOV    bp, sp ; MOV
0787DF  52                    PUSH   dx ; STACK_PUSH
0787E0  50                    PUSH   ax ; STACK_PUSH
0787E1  53                    PUSH   bx ; STACK_PUSH
0787E2  56                    PUSH   si ; STACK_PUSH
0787E3  1E                    PUSH   ds ; STACK_PUSH
0787E4  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0787E7  8B C8                 MOV    cx, ax ; MOV
0787E9  8B C2                 MOV    ax, dx ; MOV
0787EB  F7 E1                 MUL    cx ; ARITH
