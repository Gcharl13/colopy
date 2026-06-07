; ============================================================================
; func_013B4E_unknown
; Region   : load_image
; Bytes    : file 0x013B4E..0x013B5F  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013B4E  55                    PUSH   bp ; STACK_PUSH
013B4F  8B EC                 MOV    bp, sp ; MOV
013B51  9C                    PUSHF ; STACK_PUSH
013B52  50                    PUSH   ax ; STACK_PUSH
013B53  2E A1 A5 5D           MOV    ax, word ptr cs:[0x5da5] ; GLOBAL_LOAD
013B57  2E 2B 06 A7 5D        SUB    ax, word ptr cs:[0x5da7] ; ARITH
013B5C  48                    DEC    ax ; ARITH
013B5D  3B C3                 CMP    ax, bx ; CMP
