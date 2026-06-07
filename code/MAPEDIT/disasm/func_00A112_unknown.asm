; ============================================================================
; func_00A112_unknown
; Region   : load_image
; Bytes    : file 0x00A112..0x00A122  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A112  55                    PUSH   bp ; STACK_PUSH
00A113  8B EC                 MOV    bp, sp ; MOV
00A115  68 4F 06              PUSH   0x64f ; PUSH_CONST
00A118  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A11B  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
00A120  C9                    LEAVE ; EPILOGUE
00A121  CB                    RETF ; RETURN
