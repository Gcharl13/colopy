; ============================================================================
; func_0040B2_unknown
; Region   : load_image
; Bytes    : file 0x0040B2..0x0040BD  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0040B2  55                    PUSH   bp ; STACK_PUSH
0040B3  8B EC                 MOV    bp, sp ; MOV
0040B5  53                    PUSH   bx ; STACK_PUSH
0040B6  9A 1C 00 FB 0B        LCALL  0xbfb, 0x1c ; LCALL
0040BB  C9                    LEAVE ; EPILOGUE
0040BC  CB                    RETF ; RETURN
