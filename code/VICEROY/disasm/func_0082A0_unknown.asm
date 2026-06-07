; ============================================================================
; func_0082A0_unknown
; Region   : load_image
; Bytes    : file 0x0082A0..0x0082B2  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0082A0  55                    PUSH   bp ; STACK_PUSH
0082A1  8B EC                 MOV    bp, sp ; MOV
0082A3  6B 5E 06 27           IMUL   bx, word ptr [bp + 6], 0x27 ; ARITH
0082A7  03 5E 08              ADD    bx, word ptr [bp + 8] ; ARITH
0082AA  D1 E3                 SHL    bx, 1 ; LOGIC
0082AC  8B 87 1C 5B           MOV    ax, word ptr [bx + 0x5b1c] ; MOV
0082B0  C9                    LEAVE ; EPILOGUE
0082B1  CB                    RETF ; RETURN
