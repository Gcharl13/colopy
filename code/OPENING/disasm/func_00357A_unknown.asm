; ============================================================================
; func_00357A_unknown
; Region   : load_image
; Bytes    : file 0x00357A..0x003587  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00357A  55                    PUSH   bp ; STACK_PUSH
00357B  8B EC                 MOV    bp, sp ; MOV
00357D  52                    PUSH   dx ; STACK_PUSH
00357E  50                    PUSH   ax ; STACK_PUSH
00357F  53                    PUSH   bx ; STACK_PUSH
003580  56                    PUSH   si ; STACK_PUSH
003581  8B C8                 MOV    cx, ax ; MOV
003583  8B C2                 MOV    ax, dx ; MOV
003585  F7 E1                 MUL    cx ; ARITH
