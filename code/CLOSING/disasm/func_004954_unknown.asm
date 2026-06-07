; ============================================================================
; func_004954_unknown
; Region   : load_image
; Bytes    : file 0x004954..0x00495E  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004954  55                    PUSH   bp ; STACK_PUSH
004955  8B EC                 MOV    bp, sp ; MOV
004957  56                    PUSH   si ; STACK_PUSH
004958  57                    PUSH   di ; STACK_PUSH
004959  B3 01                 MOV    bl, 1 ; MOV
00495B  E9 F2 16              JMP    0x6050 ; JUMP
