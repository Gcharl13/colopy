; ============================================================================
; func_00D9EA_unknown
; Region   : load_image
; Bytes    : file 0x00D9EA..0x00D9F7  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D9EA  55                    PUSH   bp ; STACK_PUSH
00D9EB  8B EC                 MOV    bp, sp ; MOV
00D9ED  52                    PUSH   dx ; STACK_PUSH
00D9EE  50                    PUSH   ax ; STACK_PUSH
00D9EF  53                    PUSH   bx ; STACK_PUSH
00D9F0  56                    PUSH   si ; STACK_PUSH
00D9F1  8B C8                 MOV    cx, ax ; MOV
00D9F3  8B C2                 MOV    ax, dx ; MOV
00D9F5  F7 E1                 MUL    cx ; ARITH
