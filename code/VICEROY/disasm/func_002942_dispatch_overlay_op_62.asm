; ============================================================================
; func_002942_unknown
; Region   : load_image
; Bytes    : file 0x002942..0x002952  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002942  55                    PUSH   bp ; STACK_PUSH
002943  8B EC                 MOV    bp, sp ; MOV
002945  68 62 00              PUSH   0x62 ; PUSH_CONST
002948  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00294B  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
002950  C9                    LEAVE ; EPILOGUE
002951  CB                    RETF ; RETURN
