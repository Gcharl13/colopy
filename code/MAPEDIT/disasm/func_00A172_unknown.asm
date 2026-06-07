; ============================================================================
; func_00A172_unknown
; Region   : load_image
; Bytes    : file 0x00A172..0x00A182  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A172  55                    PUSH   bp ; STACK_PUSH
00A173  8B EC                 MOV    bp, sp ; MOV
00A175  68 5E 06              PUSH   0x65e ; PUSH_CONST
00A178  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A17B  9A E6 05 88 13        LCALL  0x1388, 0x5e6 ; LCALL
00A180  C9                    LEAVE ; EPILOGUE
00A181  CB                    RETF ; RETURN
