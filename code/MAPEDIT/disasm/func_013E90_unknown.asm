; ============================================================================
; func_013E90_unknown
; Region   : load_image
; Bytes    : file 0x013E90..0x013EA8  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013E90  55                    PUSH   bp ; STACK_PUSH
013E91  8B EC                 MOV    bp, sp ; MOV
013E93  BB AC 5A              MOV    bx, 0x5aac ; CONST_LOAD
013E96  8B 0E F6 44           MOV    cx, word ptr [0x44f6] ; GLOBAL_LOAD
013E9A  E3 0F                 JCXZ   0x13eab ; CJUMP
013E9C  53                    PUSH   bx ; STACK_PUSH
013E9D  8B 17                 MOV    dx, word ptr [bx] ; MOV
013E9F  B4 11                 MOV    ah, 0x11 ; CONST_LOAD
013EA1  FF 1E 6C 3C           LCALL  [0x3c6c] ; LCALL
013EA5  5B                    POP    bx ; STACK_POP
013EA6  83                    DB     0x83 ; DATA_BYTE
013EA7  C3                    DB     0xC3 ; DATA_BYTE
