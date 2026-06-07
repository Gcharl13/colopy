; ============================================================================
; func_002922_unknown
; Region   : load_image
; Bytes    : file 0x002922..0x002932  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002922  55                    PUSH   bp ; STACK_PUSH
002923  8B EC                 MOV    bp, sp ; MOV
002925  68 5E 00              PUSH   0x5e ; PUSH_CONST
002928  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00292B  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
002930  C9                    LEAVE ; EPILOGUE
002931  CB                    RETF ; RETURN
