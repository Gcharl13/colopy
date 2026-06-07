; ============================================================================
; func_0787A2_unknown
; Region   : overlay
; Bytes    : file 0x0787A2..0x0787AF  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0787A2  55                    PUSH   bp ; STACK_PUSH
0787A3  8B EC                 MOV    bp, sp ; MOV
0787A5  52                    PUSH   dx ; STACK_PUSH
0787A6  50                    PUSH   ax ; STACK_PUSH
0787A7  53                    PUSH   bx ; STACK_PUSH
0787A8  56                    PUSH   si ; STACK_PUSH
0787A9  8B C8                 MOV    cx, ax ; MOV
0787AB  8B C2                 MOV    ax, dx ; MOV
0787AD  F7 E1                 MUL    cx ; ARITH
