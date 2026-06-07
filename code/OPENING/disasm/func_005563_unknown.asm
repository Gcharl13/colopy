; ============================================================================
; func_005563_unknown
; Region   : load_image
; Bytes    : file 0x005563..0x005576  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005563  55                    PUSH   bp ; STACK_PUSH
005564  8B EC                 MOV    bp, sp ; MOV
005566  50                    PUSH   ax ; STACK_PUSH
005567  53                    PUSH   bx ; STACK_PUSH
005568  BB 01 00              MOV    bx, 1 ; MOV
00556B  93                    XCHG   bx, ax ; MOV
00556C  FF 1E 0E 46           LCALL  [0x460e] ; LCALL
005570  5B                    POP    bx ; STACK_POP
005571  58                    POP    ax ; STACK_POP
005572  8B E5                 MOV    sp, bp ; MOV
005574  5D                    POP    bp ; STACK_POP
005575  C3                    RET ; RETURN
