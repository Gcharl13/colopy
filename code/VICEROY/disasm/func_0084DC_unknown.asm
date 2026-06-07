; ============================================================================
; func_0084DC_unknown
; Region   : load_image
; Bytes    : file 0x0084DC..0x0084F1  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0084DC  55                    PUSH   bp ; STACK_PUSH
0084DD  8B EC                 MOV    bp, sp ; MOV
0084DF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0084E2  0E                    PUSH   cs ; STACK_PUSH
0084E3  E8 E2 FF              CALL   0x84c8 ; CALL_NEAR
0084E6  8B D8                 MOV    bx, ax ; MOV
0084E8  C1 E3 03              SHL    bx, 3 ; LOGIC
0084EB  8B 87 A2 8E           MOV    ax, word ptr [bx - 0x715e] ; MOV
0084EF  C9                    LEAVE ; EPILOGUE
0084F0  CB                    RETF ; RETURN
