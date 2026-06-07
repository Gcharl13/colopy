; ============================================================================
; func_00278A_unknown
; Region   : load_image
; Bytes    : file 0x00278A..0x00279B  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00278A  55                    PUSH   bp ; STACK_PUSH
00278B  8B EC                 MOV    bp, sp ; MOV
00278D  52                    PUSH   dx ; STACK_PUSH
00278E  50                    PUSH   ax ; STACK_PUSH
00278F  53                    PUSH   bx ; STACK_PUSH
002790  56                    PUSH   si ; STACK_PUSH
002791  1E                    PUSH   ds ; STACK_PUSH
002792  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002795  8B C8                 MOV    cx, ax ; MOV
002797  8B C2                 MOV    ax, dx ; MOV
002799  F7 E1                 MUL    cx ; ARITH
