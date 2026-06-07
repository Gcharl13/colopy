; ============================================================================
; func_062716_unknown
; Region   : overlay
; Bytes    : file 0x062716..0x062722  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

062716  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
06271A  50                    PUSH   ax ; STACK_PUSH
06271B  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
062720  2B C3                 SUB    ax, bx ; ARITH
