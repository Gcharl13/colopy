; ============================================================================
; func_0035B4_unknown
; Region   : load_image
; Bytes    : file 0x0035B4..0x0035C5  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0035B4  55                    PUSH   bp ; STACK_PUSH
0035B5  8B EC                 MOV    bp, sp ; MOV
0035B7  52                    PUSH   dx ; STACK_PUSH
0035B8  50                    PUSH   ax ; STACK_PUSH
0035B9  53                    PUSH   bx ; STACK_PUSH
0035BA  56                    PUSH   si ; STACK_PUSH
0035BB  1E                    PUSH   ds ; STACK_PUSH
0035BC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0035BF  8B C8                 MOV    cx, ax ; MOV
0035C1  8B C2                 MOV    ax, dx ; MOV
0035C3  F7 E1                 MUL    cx ; ARITH
