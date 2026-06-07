; ============================================================================
; func_0084F2_unknown
; Region   : load_image
; Bytes    : file 0x0084F2..0x008507  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0084F2  55                    PUSH   bp ; STACK_PUSH
0084F3  8B EC                 MOV    bp, sp ; MOV
0084F5  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0084F8  0E                    PUSH   cs ; STACK_PUSH
0084F9  E8 CC FF              CALL   0x84c8 ; CALL_NEAR
0084FC  8B D8                 MOV    bx, ax ; MOV
0084FE  C1 E3 03              SHL    bx, 3 ; LOGIC
008501  8B 87 A4 8E           MOV    ax, word ptr [bx - 0x715c] ; MOV
008505  C9                    LEAVE ; EPILOGUE
008506  CB                    RETF ; RETURN
