; ============================================================================
; func_005576_unknown
; Region   : load_image
; Bytes    : file 0x005576..0x005586  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005576  55                    PUSH   bp ; STACK_PUSH
005577  8B EC                 MOV    bp, sp ; MOV
005579  50                    PUSH   ax ; STACK_PUSH
00557A  B8 02 00              MOV    ax, 2 ; MOV
00557D  FF 1E 0E 46           LCALL  [0x460e] ; LCALL
005581  58                    POP    ax ; STACK_POP
005582  8B E5                 MOV    sp, bp ; MOV
005584  5D                    POP    bp ; STACK_POP
005585  C3                    RET ; RETURN
