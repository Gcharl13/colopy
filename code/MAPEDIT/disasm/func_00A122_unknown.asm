; ============================================================================
; func_00A122_unknown
; Region   : load_image
; Bytes    : file 0x00A122..0x00A132  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A122  55                    PUSH   bp ; STACK_PUSH
00A123  8B EC                 MOV    bp, sp ; MOV
00A125  68 52 06              PUSH   0x652 ; PUSH_CONST
00A128  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A12B  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
00A130  C9                    LEAVE ; EPILOGUE
00A131  CB                    RETF ; RETURN
