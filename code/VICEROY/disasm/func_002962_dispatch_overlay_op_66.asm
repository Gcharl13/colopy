; ============================================================================
; func_002962_unknown
; Region   : load_image
; Bytes    : file 0x002962..0x002972  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002962  55                    PUSH   bp ; STACK_PUSH
002963  8B EC                 MOV    bp, sp ; MOV
002965  68 66 00              PUSH   0x66 ; PUSH_CONST
002968  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00296B  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
002970  C9                    LEAVE ; EPILOGUE
002971  CB                    RETF ; RETURN
