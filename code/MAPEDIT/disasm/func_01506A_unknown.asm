; ============================================================================
; func_01506A_unknown
; Region   : load_image
; Bytes    : file 0x01506A..0x015074  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01506A  55                    PUSH   bp ; STACK_PUSH
01506B  8B EC                 MOV    bp, sp ; MOV
01506D  56                    PUSH   si ; STACK_PUSH
01506E  57                    PUSH   di ; STACK_PUSH
01506F  B9 00 01              MOV    cx, 0x100 ; CONST_LOAD
015072  EB 08                 JMP    0x1507c ; JUMP
