; ============================================================================
; func_00427E_unknown
; Region   : load_image
; Bytes    : file 0x00427E..0x00428F  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00427E  55                    PUSH   bp ; STACK_PUSH
00427F  8B EC                 MOV    bp, sp ; MOV
004281  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
004284  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
004287  0E                    PUSH   cs ; STACK_PUSH
004288  E8 D5 FF              CALL   0x4260 ; CALL_NEAR
00428B  24 0F                 AND    al, 0xf ; LOGIC
00428D  C9                    LEAVE ; EPILOGUE
00428E  CB                    RETF ; RETURN
