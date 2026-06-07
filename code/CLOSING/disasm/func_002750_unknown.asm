; ============================================================================
; func_002750_unknown
; Region   : load_image
; Bytes    : file 0x002750..0x00275D  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002750  55                    PUSH   bp ; STACK_PUSH
002751  8B EC                 MOV    bp, sp ; MOV
002753  52                    PUSH   dx ; STACK_PUSH
002754  50                    PUSH   ax ; STACK_PUSH
002755  53                    PUSH   bx ; STACK_PUSH
002756  56                    PUSH   si ; STACK_PUSH
002757  8B C8                 MOV    cx, ax ; MOV
002759  8B C2                 MOV    ax, dx ; MOV
00275B  F7 E1                 MUL    cx ; ARITH
