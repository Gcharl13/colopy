; ============================================================================
; func_00A152_unknown
; Region   : load_image
; Bytes    : file 0x00A152..0x00A162  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A152  55                    PUSH   bp ; STACK_PUSH
00A153  8B EC                 MOV    bp, sp ; MOV
00A155  68 5A 06              PUSH   0x65a ; PUSH_CONST
00A158  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A15B  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
00A160  C9                    LEAVE ; EPILOGUE
00A161  CB                    RETF ; RETURN
