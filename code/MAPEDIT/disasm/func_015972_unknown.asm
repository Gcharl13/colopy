; ============================================================================
; func_015972_unknown
; Region   : load_image
; Bytes    : file 0x015972..0x015979  (7 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015972  55                    PUSH   bp ; STACK_PUSH
015973  8B EC                 MOV    bp, sp ; MOV
015975  B4 3F                 MOV    ah, 0x3f ; CONST_LOAD
015977  EB 05                 JMP    0x1597e ; JUMP
