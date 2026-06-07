; ============================================================================
; func_0044EC_unknown
; Region   : load_image
; Bytes    : file 0x0044EC..0x0044F6  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0044EC  55                    PUSH   bp ; STACK_PUSH
0044ED  8B EC                 MOV    bp, sp ; MOV
0044EF  56                    PUSH   si ; STACK_PUSH
0044F0  57                    PUSH   di ; STACK_PUSH
0044F1  B9 00 01              MOV    cx, 0x100 ; CONST_LOAD
0044F4  EB 08                 JMP    0x44fe ; JUMP
