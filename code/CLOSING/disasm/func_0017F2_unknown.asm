; ============================================================================
; func_0017F2_unknown
; Region   : load_image
; Bytes    : file 0x0017F2..0x0017FD  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0017F2  55                    PUSH   bp ; STACK_PUSH
0017F3  8B EC                 MOV    bp, sp ; MOV
0017F5  53                    PUSH   bx ; STACK_PUSH
0017F6  9A 1E 00 96 01        LCALL  0x196, 0x1e ; LCALL
0017FB  C9                    LEAVE ; EPILOGUE
0017FC  CB                    RETF ; RETURN
