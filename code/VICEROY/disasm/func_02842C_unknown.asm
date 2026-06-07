; ============================================================================
; func_02842C_unknown
; Region   : overlay
; Bytes    : file 0x02842C..0x028435  (9 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02842C  55                    PUSH   bp ; STACK_PUSH
02842D  8B EC                 MOV    bp, sp ; MOV
02842F  56                    PUSH   si ; STACK_PUSH
028430  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
028433  8B C3                 MOV    ax, bx ; MOV
