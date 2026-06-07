; ============================================================================
; func_00A182_unknown
; Region   : load_image
; Bytes    : file 0x00A182..0x00A192  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A182  55                    PUSH   bp ; STACK_PUSH
00A183  8B EC                 MOV    bp, sp ; MOV
00A185  68 60 06              PUSH   0x660 ; PUSH_CONST
00A188  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A18B  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
00A190  C9                    LEAVE ; EPILOGUE
00A191  CB                    RETF ; RETURN
