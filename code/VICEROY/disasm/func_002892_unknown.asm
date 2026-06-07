; ============================================================================
; func_002892_unknown
; Region   : load_image
; Bytes    : file 0x002892..0x0028B0  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002892  55                    PUSH   bp ; STACK_PUSH
002893  8B EC                 MOV    bp, sp ; MOV
002895  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
002898  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00289B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00289E  0E                    PUSH   cs ; STACK_PUSH
00289F  E8 32 FE              CALL   0x26d4 ; CALL_NEAR
0028A2  8B E5                 MOV    sp, bp ; MOV
0028A4  6A 00                 PUSH   0 ; STACK_PUSH
0028A6  6A 00                 PUSH   0 ; STACK_PUSH
0028A8  6A 01                 PUSH   1 ; STACK_PUSH
0028AA  0E                    PUSH   cs ; STACK_PUSH
0028AB  E8 AE FE              CALL   0x275c ; CALL_NEAR
0028AE  C9                    LEAVE ; EPILOGUE
0028AF  CB                    RETF ; RETURN
