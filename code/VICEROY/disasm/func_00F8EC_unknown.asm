; ============================================================================
; func_00F8EC_unknown
; Region   : load_image
; Bytes    : file 0x00F8EC..0x00F8F6  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F8EC  55                    PUSH   bp ; STACK_PUSH
00F8ED  8B EC                 MOV    bp, sp ; MOV
00F8EF  56                    PUSH   si ; STACK_PUSH
00F8F0  57                    PUSH   di ; STACK_PUSH
00F8F1  B9 00 01              MOV    cx, 0x100 ; CONST_LOAD
00F8F4  EB 08                 JMP    0xf8fe ; JUMP
