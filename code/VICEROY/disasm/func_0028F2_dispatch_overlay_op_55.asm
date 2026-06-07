; ============================================================================
; func_0028F2_unknown
; Region   : load_image
; Bytes    : file 0x0028F2..0x002902  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0028F2  55                    PUSH   bp ; STACK_PUSH
0028F3  8B EC                 MOV    bp, sp ; MOV
0028F5  68 55 00              PUSH   0x55 ; PUSH_CONST
0028F8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0028FB  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
002900  C9                    LEAVE ; EPILOGUE
002901  CB                    RETF ; RETURN
