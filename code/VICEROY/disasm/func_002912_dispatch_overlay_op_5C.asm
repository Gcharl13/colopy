; ============================================================================
; func_002912_unknown
; Region   : load_image
; Bytes    : file 0x002912..0x002922  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002912  55                    PUSH   bp ; STACK_PUSH
002913  8B EC                 MOV    bp, sp ; MOV
002915  68 5C 00              PUSH   0x5c ; PUSH_CONST
002918  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00291B  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
002920  C9                    LEAVE ; EPILOGUE
002921  CB                    RETF ; RETURN
