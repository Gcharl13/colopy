; ============================================================================
; func_002992_unknown
; Region   : load_image
; Bytes    : file 0x002992..0x0029AC  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002992  55                    PUSH   bp ; STACK_PUSH
002993  8B EC                 MOV    bp, sp ; MOV
002995  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002998  9A 62 00 00 00        LCALL  0, 0x62 ; LCALL
00299D  8B E5                 MOV    sp, bp ; MOV
00299F  52                    PUSH   dx ; STACK_PUSH
0029A0  50                    PUSH   ax ; STACK_PUSH
0029A1  1E                    PUSH   ds ; STACK_PUSH
0029A2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0029A5  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
0029AA  C9                    LEAVE ; EPILOGUE
0029AB  CB                    RETF ; RETURN
