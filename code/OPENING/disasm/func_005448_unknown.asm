; ============================================================================
; func_005448_unknown
; Region   : load_image
; Bytes    : file 0x005448..0x005452  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005448  55                    PUSH   bp ; STACK_PUSH
005449  8B EC                 MOV    bp, sp ; MOV
00544B  56                    PUSH   si ; STACK_PUSH
00544C  57                    PUSH   di ; STACK_PUSH
00544D  B9 00 01              MOV    cx, 0x100 ; CONST_LOAD
005450  EB 08                 JMP    0x545a ; JUMP
