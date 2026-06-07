; ============================================================================
; func_00A162_unknown
; Region   : load_image
; Bytes    : file 0x00A162..0x00A172  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A162  55                    PUSH   bp ; STACK_PUSH
00A163  8B EC                 MOV    bp, sp ; MOV
00A165  68 5C 06              PUSH   0x65c ; PUSH_CONST
00A168  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A16B  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
00A170  C9                    LEAVE ; EPILOGUE
00A171  CB                    RETF ; RETURN
