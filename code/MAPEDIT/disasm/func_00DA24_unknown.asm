; ============================================================================
; func_00DA24_unknown
; Region   : load_image
; Bytes    : file 0x00DA24..0x00DA35  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DA24  55                    PUSH   bp ; STACK_PUSH
00DA25  8B EC                 MOV    bp, sp ; MOV
00DA27  52                    PUSH   dx ; STACK_PUSH
00DA28  50                    PUSH   ax ; STACK_PUSH
00DA29  53                    PUSH   bx ; STACK_PUSH
00DA2A  56                    PUSH   si ; STACK_PUSH
00DA2B  1E                    PUSH   ds ; STACK_PUSH
00DA2C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00DA2F  8B C8                 MOV    cx, ax ; MOV
00DA31  8B C2                 MOV    ax, dx ; MOV
00DA33  F7 E1                 MUL    cx ; ARITH
