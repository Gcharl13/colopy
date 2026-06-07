; ============================================================================
; func_002982_unknown
; Region   : load_image
; Bytes    : file 0x002982..0x002992  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002982  55                    PUSH   bp ; STACK_PUSH
002983  8B EC                 MOV    bp, sp ; MOV
002985  68 6A 00              PUSH   0x6a ; PUSH_CONST
002988  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00298B  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
002990  C9                    LEAVE ; EPILOGUE
002991  CB                    RETF ; RETURN
