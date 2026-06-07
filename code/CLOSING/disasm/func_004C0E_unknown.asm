; ============================================================================
; func_004C0E_unknown
; Region   : load_image
; Bytes    : file 0x004C0E..0x004C15  (7 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004C0E  55                    PUSH   bp ; STACK_PUSH
004C0F  8B EC                 MOV    bp, sp ; MOV
004C11  B4 3F                 MOV    ah, 0x3f ; CONST_LOAD
004C13  EB 05                 JMP    0x4c1a ; JUMP
