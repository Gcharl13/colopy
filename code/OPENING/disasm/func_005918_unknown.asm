; ============================================================================
; func_005918_unknown
; Region   : load_image
; Bytes    : file 0x005918..0x005922  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005918  55                    PUSH   bp ; STACK_PUSH
005919  8B EC                 MOV    bp, sp ; MOV
00591B  56                    PUSH   si ; STACK_PUSH
00591C  57                    PUSH   di ; STACK_PUSH
00591D  B3 01                 MOV    bl, 1 ; MOV
00591F  E9 2E 17              JMP    0x7050 ; JUMP
