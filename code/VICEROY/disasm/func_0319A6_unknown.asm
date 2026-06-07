; ============================================================================
; func_0319A6_unknown
; Region   : overlay
; Bytes    : file 0x0319A6..0x0319BB  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0319A6  55                    PUSH   bp ; STACK_PUSH
0319A7  8B EC                 MOV    bp, sp ; MOV
0319A9  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0319AC  0E                    PUSH   cs ; STACK_PUSH
0319AD  E8 5D 4F              CALL   0x3690d ; CALL_NEAR
0319B0  8B E5                 MOV    sp, bp ; MOV
0319B2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0319B5  0E                    PUSH   cs ; STACK_PUSH
0319B6  E8 A4 4F              CALL   0x3695d ; CALL_NEAR
0319B9  C9                    LEAVE ; EPILOGUE
0319BA  CB                    RETF ; RETURN
