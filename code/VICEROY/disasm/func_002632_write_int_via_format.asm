; ============================================================================
; func_002632_unknown
; Region   : load_image
; Bytes    : file 0x002632..0x002647  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002632  55                    PUSH   bp ; STACK_PUSH
002633  8B EC                 MOV    bp, sp ; MOV
002635  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002638  9A 62 00 00 00        LCALL  0, 0x62 ; LCALL
00263D  8B E5                 MOV    sp, bp ; MOV
00263F  52                    PUSH   dx ; STACK_PUSH
002640  50                    PUSH   ax ; STACK_PUSH
002641  0E                    PUSH   cs ; STACK_PUSH
002642  E8 C9 FF              CALL   0x260e ; CALL_NEAR
002645  C9                    LEAVE ; EPILOGUE
002646  CB                    RETF ; RETURN
