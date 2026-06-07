; ============================================================================
; func_00BFF2_unknown
; Region   : load_image
; Bytes    : file 0x00BFF2..0x00C009  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BFF2  55                    PUSH   bp ; STACK_PUSH
00BFF3  8B EC                 MOV    bp, sp ; MOV
00BFF5  6A 00                 PUSH   0 ; STACK_PUSH
00BFF7  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00BFFA  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00BFFD  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00C000  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00C003  0E                    PUSH   cs ; STACK_PUSH
00C004  E8 35 FF              CALL   0xbf3c ; CALL_NEAR
00C007  C9                    LEAVE ; EPILOGUE
00C008  CB                    RETF ; RETURN
