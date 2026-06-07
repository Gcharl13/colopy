; ============================================================================
; func_00A142_unknown
; Region   : load_image
; Bytes    : file 0x00A142..0x00A152  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A142  55                    PUSH   bp ; STACK_PUSH
00A143  8B EC                 MOV    bp, sp ; MOV
00A145  68 58 06              PUSH   0x658 ; PUSH_CONST
00A148  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A14B  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
00A150  C9                    LEAVE ; EPILOGUE
00A151  CB                    RETF ; RETURN
