; ============================================================================
; func_005C0E_unknown
; Region   : load_image
; Bytes    : file 0x005C0E..0x005C15  (7 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005C0E  55                    PUSH   bp ; STACK_PUSH
005C0F  8B EC                 MOV    bp, sp ; MOV
005C11  B4 3F                 MOV    ah, 0x3f ; CONST_LOAD
005C13  EB 05                 JMP    0x5c1a ; JUMP
