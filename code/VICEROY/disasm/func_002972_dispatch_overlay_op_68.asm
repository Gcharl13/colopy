; ============================================================================
; func_002972_unknown
; Region   : load_image
; Bytes    : file 0x002972..0x002982  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002972  55                    PUSH   bp ; STACK_PUSH
002973  8B EC                 MOV    bp, sp ; MOV
002975  68 68 00              PUSH   0x68 ; PUSH_CONST
002978  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00297B  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
002980  C9                    LEAVE ; EPILOGUE
002981  CB                    RETF ; RETURN
