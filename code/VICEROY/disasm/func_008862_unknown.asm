; ============================================================================
; func_008862_unknown
; Region   : load_image
; Bytes    : file 0x008862..0x00887B  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008862  55                    PUSH   bp ; STACK_PUSH
008863  8B EC                 MOV    bp, sp ; MOV
008865  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
008868  0E                    PUSH   cs ; STACK_PUSH
008869  E8 88 FF              CALL   0x87f4 ; CALL_NEAR
00886C  8B E5                 MOV    sp, bp ; MOV
00886E  52                    PUSH   dx ; STACK_PUSH
00886F  50                    PUSH   ax ; STACK_PUSH
008870  1E                    PUSH   ds ; STACK_PUSH
008871  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
008874  9A E8 01 4B 00        LCALL  0x4b, 0x1e8 ; LCALL
008879  C9                    LEAVE ; EPILOGUE
00887A  CB                    RETF ; RETURN
