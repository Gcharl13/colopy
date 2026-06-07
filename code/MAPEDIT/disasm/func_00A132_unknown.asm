; ============================================================================
; func_00A132_unknown
; Region   : load_image
; Bytes    : file 0x00A132..0x00A142  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A132  55                    PUSH   bp ; STACK_PUSH
00A133  8B EC                 MOV    bp, sp ; MOV
00A135  68 56 06              PUSH   0x656 ; PUSH_CONST
00A138  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A13B  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
00A140  C9                    LEAVE ; EPILOGUE
00A141  CB                    RETF ; RETURN
