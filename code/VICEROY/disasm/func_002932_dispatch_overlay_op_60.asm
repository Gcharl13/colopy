; ============================================================================
; func_002932_unknown
; Region   : load_image
; Bytes    : file 0x002932..0x002942  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002932  55                    PUSH   bp ; STACK_PUSH
002933  8B EC                 MOV    bp, sp ; MOV
002935  68 60 00              PUSH   0x60 ; PUSH_CONST
002938  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00293B  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
002940  C9                    LEAVE ; EPILOGUE
002941  CB                    RETF ; RETURN
