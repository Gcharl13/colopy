; ============================================================================
; func_00A102_unknown
; Region   : load_image
; Bytes    : file 0x00A102..0x00A112  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A102  55                    PUSH   bp ; STACK_PUSH
00A103  8B EC                 MOV    bp, sp ; MOV
00A105  68 4C 06              PUSH   0x64c ; PUSH_CONST
00A108  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A10B  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
00A110  C9                    LEAVE ; EPILOGUE
00A111  CB                    RETF ; RETURN
